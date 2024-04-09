;; Plan Layer Setting....???
(defun c:la-p(/ a)
	(if (= (tblsearch "layer" "plan") nil)
		(progn
			(prompt "\n\t Layer \"PLAN\" was Not Found.. Run first C:MLA2 ")
			(exit)
		)
	)
	(initget "Hid Elp Con 1 2 3")
	(setq a (getkword "\n\t Hid(1)/Elp(2)/Con(3) : ?"))
	(cond
		((= a "Hid")(plan-hid))
		((= a "Elp")(plan-elp))
		((= a "Con")(plan-Con))
		((= a "1")(plan-hid))
		((= a "2")(plan-elp))
		((= a "3")(plan-Con))
		(T nil)
	)
	(c:pp)
)

(defun layer-tri(/ c la-con la-name)
	(setq c (tblnext "layer" "0"))
	(setq la-con "0")
	(while (setq la-name (tblnext "layer"))
		(if (and (= "CONTINUOUS" (cdr (assoc 6 la-name))) (/= (getvar "clayer") (cdr (assoc 2 la-name))))
			(setq la-con (strcat la-con "," (cdr (assoc 2 la-name))))
		)
	)
)

(defun plan-con(/ b)
	(la-set "plan" "9")
	(setvar "clayer" "plan")
	(setq b (ssget "W" (getvar "vsmin") (getvar "vsmax")))
	(command "change" b "" "p" "layer" "plan" "color" "bylayer" "")
)

(defun plan-hid(/ b)
	(setq b (ssget "W" (getvar "vsmin") (getvar "vsmax")))
	(command "change" b "" "p" "layer" "plan" "color" "7" "ltype" "hid" "")
	(setvar "CLAYER" "plan")
)

(defun plan-elp(/ b)
	(setq b (ssget "W" (getvar "vsmin") (getvar "vsmax")))
	(command "change" b "" "p" "layer" "plan" "color" "7" "ltype" "elp" "")
	(setvar "CLAYER" "plan")
)
;; End

;;CHANG ALL....ELEVATION IS "0"
(defun c:ev0()
	(c:fu)(c:ft)
	(setq a (ssget "x"))
	(command "change" a "" "p" "e" 0 "")
	(c:pp)
)
;; End

;;QSAVE & CLOSE & Purge
(defun C:QC()(c:pp)(command "save" "close"))
;;End

;;도면상의 특정문자를 찾는리습 0,0에서부터 라인을 그림
(defun c:FTT() 
	(setq aaa(getstring "\n\t Find of Text String ? : "))
;	(setq bbb (ssget "X" (list (cons 0 "TEXT") (cons 1 aaa) (cons 8 "주방기구"))) ;==> 블록을 찾는다
	(setq bbb (ssget "X" (list (cons 0 "TEXT") (cons 1 aaa) )) ;==> 블록을 찾는다
			bbbl (if bbb (sslength bbb) 0) ;==> 블록의 갯수
			cou 0) ;==>초기값설정
	(repeat bbbl ;==> 블록의 숫자만큼반복
		(setq ssn (ssname bbb cou) ;==> 첫번째블록
				ent (entget ssn) ;==> 첫번째블록의 속성
				xy (cdr (assoc 10 ent)) ;==> 블록의속성중 좌표값추출
				cou (1+ cou)
		)
		(command "pline" "0,0" xy "") ;==> 0,0에서 블록의 좌표까지 라인그림
	) ;re 
) 
;;End

;;아키프리용 리습에서 가져옴...... 레이어 체인지 리습
;========================================================================
;                     Layer (대화상자) 변경                              
;========================================================================
; Change Layer used Dialog. Start command with CIMCHLD.

(defun c:chla(/ name ent ent1)
	(command "_.undo" "_group")
	(prompt "\n레이어를 변경할 객체를 선택하시오: ")
	(setq ent (ssget))  
	(if (setq ent1 (entsel "\n변경할 대상레이어를 가진 객체를 선택하시오: "))
		(progn
			(setq name (cdr (assoc 8 (entget (car ent1)))))
			(command "change" ent "" "p" "la" name "c" "bylayer" "")
		)
		(cimcad_chla ent)
	)
	(command "_.undo" "_en")
)

(defun cimcad_chla(ent / curlay num templist name sortlist laylist ent ent_list)
;  (ai_err_on) 
;  (ai_undo_on)
;	(command "_.undo" "_group")
  
;  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
;  (princ "\n대화상자를 통해 layer를 변경하는 명령입니다.")
;	(prompt "\n변경할 객체를 선택하시오: ")
;	(setq ent (ssget))  

;	(while (setq ent (entsel "\n변경할 객체를 선택하시오: "))

		; make layer_list
;		(setq ent_list (entget (car ent)))
;		(setq curlay (cdr (assoc 8 ent_list)))

		(setq curlay (getvar "CLAYER"))

		(setq sortlist nil)
		(setq templist (tblnext "LAYER" T))
		(while templist
			(setq name (cdr (assoc 2 templist)))
			(setq sortlist (cons name sortlist))
			(setq templist (tblnext "LAYER"))
		)
		(if (>= (getvar "maxsort") (length sortlist))
			(setq sortlist (acad_strlsort sortlist))
			(setq sortlist (reverse sortlist))
		)
		(setq laylist sortlist)

		; 대화상자 호출
		(setq num (load_dialog "layerlist"))
		(new_dialog "select_layer" num)
		(start_list "layer_list")
		(mapcar 'add_list laylist)
		(end_list)
		(set_tile "layer_edit" curlay)
		(action_tile "layer_list" "(set_layer)")
		(action_tile "accept" "(get_layer)(done_dialog)")
		(action_tile "cancel" "(setq curlay nil)")
		(start_dialog)
		(done_dialog)

		; 도면층  변경
		(if curlay
			(progn
				(setlay curlay)
				(command "CHANGE" ent "" "P" "LA" curlay "c" "bylayer" "")
			)
		)
;	)
;	(command "_.undo" "_en")
;	(ai_err_off)
;	(ai_undo_off)
	(princ)
)

(defun get_layer(/ index)
    (setq curlay (get_tile "layer_edit"))
)

(defun set_layer(/ index)
  (setq index (get_tile "layer_list"))
  (setq curlay (nth (atoi index) laylist))
  (set_tile "layer_edit" curlay)
)
(princ)

;;; (주)진전기 엔지니어링
;;;////////////////////   Auto-loading Lisp //////////////////////

(defun c:eattedit(/ a)
	(setq a (ssget))
	(initdia 1)
	(command "attedit" a)
)

(autoload "JTIT"		'("tit"))
(autoload "DRB"		'("drf" "drb" "drr"))
(autoload "JT-EXP"	'("t-exp"))


;;;//////////////////// Load Other Lisp Program File's ///////////

;(load "apg")
(load "jenn")
(load "jt")
(load "JRMM")
(load "jroom")
(LOAD "JTT3")

(defun c:tt () (c:jtt))
(defun c:jtnn () (load "jtnn") (c:jtnn))
(defun c:tnn () (c:jtnn))
;(DEFUN C:CX()(LOAD "CX")(C:CX))
(autoload "cx" '("cx" "cx2" "cxx"))

(load "jst")
(load "chtgr1")

;;(load "thchtxt5")	;	문자의 속성변경

(load "tgscreen")			; 스크린-색상변경 tg1, tg2, tg7.....

(defun c:+ ()(if (not c:t_num)(load "k_tnum"))(c:t_num))					;	가감승제..
(defun c:- ()(if (not c:t_num)(load "k_tnum"))(c:t_num))					;	가감승제..
(defun c:* ()(if (not c:t_num)(load "k_tnum"))(c:t_num))					;	가감승제..
(defun c:/ ()(if (not c:t_num)(load "k_tnum"))(c:t_num))					;	가감승제..

;;;////////////////////  Auto-loading Lisp //////////////////////

(defun c:cv(/ a p1 p2)
;	(setq olderr *error* *error* cverror chm 0)
;	(defun cverror	(s)
;		(if (/= s "Function cancelled")
;			(alert (strcat "\nError: " s))
;			)
;		(redraw a 1)
;		(setq *error* olderr)
;	)
	(setq a(entsel))
	(redraw (car a) 3)
	(while a
		(setq p1 (getpoint))
		(setq p2 (getpoint p1)) 
		(if p2 
			(progn 
				(command "copy" a "" p1 p2)
				(setq a (entlast))
				(redraw a 3)
			)
			(redraw a 1)
		)
		(setq p2 nil)
	)
)

;(defun c:ppp()(load "p-jplot")(c:ppp))
(autoload "P-JPLOT" '("ppp"))

(defun c:cm()(prompt "\n\t => Chamfer : ")(command "chamfer"))

;(defun c:test2(/ a b c d)
;	(setq a(entsel))
;	(setq b(entget (car a)))
;	(setq c "\\A1;4609\\S+2^-1;")
;	(setq b (subst (cons 1 c) (assoc 1 b) b))
;	(entmod b)
;)

(defun c:gr()(initdia 1)(command "group"))
(defun c:grr(/ a)
	(setq a (getvar "pickstyle"))
	(if (= a 1)
		(progn
			(setvar "pickstyle" 0)
			(prompt "Group-Mode Off")
		)
		(progn
			(setvar "pickstyle" 1)
			(prompt "Group-Mode On")
		)
	)
	(prin1)
)

(defun c:ucst(/ a)
	(setq a (getvar "ucsfollow"))
	(if (= a 1)
		(progn
			(setvar "ucsfollow" 0)
			(prompt "Ucsfollow is None")
		)
		(progn
			(setvar "ucsfollow" 1)
			(prompt "Ucsfollow is Yep!!")
		)
	)
	(prin1)
)

;(setvar "modemacro" 
;  (strcat
;    "L:$(substr,$(getvar,clayer),1,30)"
;    "$(substr,        ,1,$(-,30,$(strlen,$(getvar,clayer)))) "
;    ;;            ^^^^^ 이곳에 8개의 공백이 있음에 주목하십시오.
;    "<.."
;      "$(if,$(eq,$(getvar,dwgname),UNNAMED),UNNAMED,"
;        "$(substr,$(getvar,dwgname),"
;        "$(if,$(>,$(strlen,$(getvar,dwgprefix)),29),"
;          "$(-,$(strlen,$(getvar,dwgprefix)),29),1"
;        "),"
;        "$(strlen,$(getvar,dwgname))"
;        ")"
;      ")"
;    ">"
;    "$(if,$(getvar,orthomode), O, )"
;    "$(if,$(getvar,snapmode), S, )"
;    "$(if,$(getvar,tabmode), T, )"
;    "$(if,$(and,"
;    "$(=,$(getvar,tilemode),0),$(=,$(getvar,cvport),1)),P)"
;  )
;)

(defun c:a2t()(load "attDef2txt")(c:attDef2txt))
; 속성을 가진 문자를 일반문자로 교체함

(defun c:dfx(/ p1 p2 dfx_dist dfx_distn dfx_distx dfx_ang pts pte p3 p4 p5 p6)
; 전등설비용 플렉시블 배관그리기..직선구간만 해당
	(setq p1 (getpoint "\n\t Strart-Point of Flexible_tube ? : "))
	(setq p2 (getpoint p1 "Ending Point ? : "))
	(setq dfx_distx (distance p1 p2))
	(setq dfx_distn (fix (/ dfx_distx (* 2 (/ (getvar "ltscale") 1)))))
	(setq dfx_dist (/ dfx_distx dfx_distn))
	(setq dfx_ang (angle p1 p2))
	(setq pts p1 pte p2)
	(command "pline" pts "w" 0 0 )
	(repeat dfx_distn
		(setq p2 (polar p1 (+ dfx_ang (dtr 270)) (/ dfx_dist 2)))
		(command p2)
		(setq p3 (polar p2 dfx_ang (/ dfx_dist 2)))
		(command p3)
		(setq p4 (polar p3 (+ dfx_ang (dtr 90)) dfx_dist))
		(command p4)
		(setq p5 (polar p4 dfx_ang (/ dfx_dist 2)))
		(command p5)
		(setq p6 (polar p5 (+ dfx_ang (dtr 270)) (/ dfx_dist 2)))
		(command p6)
		(setq p1 p6)
	)
	(command "")
	(command "pedit" (entlast) "S" "")
)

;------------------------------------------------------------------------------------
(defun c:of3 (/ a b p1 p2 a_p10 a_p11 b_p10 b_p11 of3_ang10 of3_dist10 of3_dist10 of3_dist11)
;평행한 두선의 중심선 그리기
	(setvar "osmode" 0)
	(setq a (entsel))
	(setq b (entsel))
	(setq a_p10 (of3_get_dxf a 10))
	(setq a_p11 (of3_get_dxf a 11))
	(setq b_p10 (of3_get_dxf b 10))
	(setq b_p11 (of3_get_dxf b 11))

	(of3_po_chk a_p10 a_p11 b_p10 b_p11)

	(command "dist" a_p10 b_p10)
	(setq of3_ang10 (angle a_p10 b_p10))
	(setq of3_dist10 (getvar "distance"))
	(command "dist" a_p11 b_p11)
	(setq of3_ang11 (angle a_p11 b_p11))
	(setq of3_dist11 (getvar "distance"))
	(setq p1 (polar a_p10 of3_ang10 (/ of3_dist10 2)))
	(setq p2 (polar a_p11 of3_ang11 (/ of3_dist11 2)))
	(command "line" p1 p2 "")
	(setvar "osmode" 0)
)

(defun of3_po_chk (p1 p2 p3 p4)
	(setq of3_po_cr (inters p1 p3 p2 p4 ))
	(if of3_po_cr
		(progn
			(setq b_p10 b_p11)
			(setq b_p11 (of3_get_dxf b 10))
		)
	)
	(prin1)
)

(defun of3_get_dxf(ga gb)
	(cdr (assoc gb (entget (car ga))))
)
;------------------------------------------------------------------------------------

(defun c:ssbb (/ a ssb-na)			
; SHEET를 바꿀때 사용함. 030212
  (setq a (car (entsel "Select of Chnaging Sheet ? :")))
  (if a
    (progn
      (setq ssb-na (cdr (assoc 2 (entget a))))
      (if ssb-na
	(progn
	  (setq ssb-na (strcat ssb-na "="))
	  (setvar "regenmode" 1)
	  (command "insert" ssb-na "0,0" "" "" "")
	  (command "zoom" "e")
	  (command "erase" "last" "")
	  (command "zoom" "e")
	)
	(prompt "Not Select !!!")
      )
    )
    (prompt "Not Select !!!")
  )
)

;;;-------------------------------------------------------------------------
;;; Text Style Setting - HS, HGT, ....

(defun C:HST ()
  (prompt " = Style's Make ")
  (setvar "REGENMODE" 0)
  (command "style" "hs" "simplex,hs" "" "" "" "" "" "")
					;(command "style" "hd" "simplex,hd" "" "" "" "" "" "")
					;(command "style" "hgd" "simplex,hgdtxt" "" "" "" "" "" "")
  (command "style" "standard" "simplex" "" "" "" "" "" "")
  (command "style" "hgt" "simplex,hgtxt" "" "" "" "" "" "")
					;(command "style" "ghd" "outline,ghd" "" "" "" "" "" "")
  (command "style" "ghd" "helved,ghd" "" "" "" "" "")
  (command "style" "ghs" "simplex,ghs" "" "" "" "" "")
  (command "Style" "UTM" "으뜸체" "" "" "" "" "" "")
  (command "Style" "UTM2" "가는으뜸체" "" "" "" "" "" "")
  (command "Style" "dot2" "돋움체" "" "" "" "" "")
  (command "Style" "dot" "돋움" "" "" "" "" "")
  (prompt
    "\n Make Style [HGT],[GHS],[Standard] and Current is [돋움=DOT] !!!"
  )
  (prin1)
)

;;;-------------------------------------------------------------------------
;;=========================================================================
;;=========================================================================

(DEFUN C:OS3 () (SETVAR "SNAPANG" (DTR 30)))
(DEFUN C:OS4 () (SETVAR "SNAPANG" (DTR 45)))
(DEFUN C:OS6 () (SETVAR "SNAPANG" (DTR 60)))
(DEFUN C:OS0 () (SETVAR "SNAPANG" 0))

					;(DEFUN C:SH4()(COMMAND "LAYER" "C" 4 "SHEET,SHT" ""))
					;(DEFUN C:SH11()(COMMAND "LAYER" "C" 11 "SHEET,SHT" ""))

					;(defun c:bbx()
					;  (setvar "OSMODE" 1)
					;  (command "layer" "unlock" "*" "")
					;  (command "rotate" "all" "" "0,0" "90")
					;  (c:oon)
					;  (command "insert" "bbx")
					;)

					;(defun c:gg3()(command "line" "mid" pause "mid" pause ""))
(defun c:ggf (/ dis) (setq dis 170) (gg-line dis))
(defun c:gg (/ dis) (setq dis 150) (gg-line dis))
					;(defun c:gg2(/ dis)(setq dis (* 150 gg-sc))(gg-line dis))
(defun c:ggf2 (/ dis)
  (setq dis (* 170 gg-sc))
  (gg-line dis)
)

(defun gg-line (dis / p1 p2 p3 p4 gg-ang1 gg-ang2 xx)
  (old-cen)
  (setq XX 1)
  (setq p1 (getpoint "\t Pick First Point ? :"))
  (while XX
    (setq p2 (getpoint p1 "\n Pick Second Point ? :"))
    (if	p2
      (progn
	(setvar "OSMODE" 0)
	(setq gg-ang1 (angle p1 p2))
	(setq gg-ang2 (angle p2 p1))
	(setq p3 (polar p1 gg-ang1 dis))
	(setq p4 (polar p2 gg-ang2 dis))
	(command "line" p3 p4 "")
	(setvar "OSMODE" 4)
	(setq p1 p2)
      )
      (setq xx nil)
    )
  )
  (new-sn)
  (prin1)
)

(defun c:ggsc (/ a)
  (if (= wire-scale nil)
    (setq wire-scale (/ (getvar "LTSCALE") 100))
  )
  (if (= gg-sc nil)
    (setq gg-sc wire-scale)
  )
  (prompt "\n Current [GG2] scale is [")
  (prin1 gg-sc)
  (setq a (getreal "] Enter [GG2] Scale is ? : "))
  (if a
    (setq gg-sc a)
  )
  (prompt "\n [GG2] Scale Setting is <")
  (prin1 gg-sc)
  (prompt "> ")
  (prin1)
)

(defun c:gg2 (/ p1 p2 p3 p4 gg-ang1 gg-ang2 gg-dist xx)
  (if (or (= gg-sc nil) (= gg-sc 0.0))
    (setq gg-sc wire-scale)
  )
  (prompt "\t [GG2] Scale is <")
  (prin1 gg-sc)
  (prompt "> if change as \"GGSC\" Typing ")
  (if gg-sc
    (progn
      (old-cen)
      (setq gg-dist (* gg-sc 150))
      (setq p1 (getpoint "\n Pick First Point ? :"))
      (setq xx 1)
      (while xx
	(setq p2 (getpoint p1 "\n Pick Second Point ? :"))
	(if p2
	  (progn
	    (setvar "OSMODE" 0)
	    (setq gg-ang1 (angle p1 p2))
	    (setq gg-ang2 (angle p2 p1))
	    (setq p3 (polar p1 gg-ang1 gg-dist))
	    (setq p4 (polar p2 gg-ang2 gg-dist))
	    (command "line" p3 p4 "")
	    (setvar "OSMODE" 4)
	    (setq p1 p2)
	  )
	  (setq xx nil)
	)
      )
      (new-sn)
    )
    (prompt
      "\n [GG2] Scale was Nothing --> Enter is \"GGSC\" !! "
    )
  )
  (prin1)
)


(defun c:gg3 (/ p1 p2 p3 p4 gg-ang1 gg-ang2 gg-dist xx)
  (if (or (= gg-sc nil) (= gg-sc 0.0))
    (setq gg-sc wire-scale)
  )
  (prompt "\t [GG2] Scale is <")
  (prin1 gg-sc)
  (prompt "> if change as \"GGSC\" Typing ")
  (if gg-sc
    (progn
      (old-cen)
      (setq gg-dist 50)
      (setq p1 (getpoint "\n Pick First Point ? :"))
      (setq xx 1)
      (while xx
	(setq p2 (getpoint p1 "\n Pick Second Point ? :"))
	(if p2
	  (progn
	    (setvar "OSMODE" 0)
	    (setq gg-ang1 (angle p1 p2))
	    (setq gg-ang2 (angle p2 p1))
	    (setq p3 (polar p1 gg-ang1 gg-dist))
	    (setq p4 (polar p2 gg-ang2 gg-dist))
	    (command "line" p3 p4 "")
	    (setvar "OSMODE" 4)
	    (setq p1 p2)
	  )
	  (setq xx nil)
	)
      )
      (new-sn)
    )
    (prompt
      "\n [GG2] Scale was Nothing --> Enter is \"GGSC\" !! "
    )
  )
  (prin1)
)

;;;#########################################################################
;;;#########################################################################

(defun blk-list (a) (acad_helpdlg "blk-list.hlp" a))
(defun test1 () (blk-list "WIRE"))

(defun pds_key ()
  (prompt
    "\n----------------------------------------------------"
  )
  (prompt
    "\n* This Program Maked by [P.D.S] HP:016-465-7324 *"
  )
  (prompt
    "\n----------------------------------------------------"
  )
  (prin1)
)

;;;*****************************************
;;; - This program is ACAD.LSP             /
;;;------------------------------        /
;;; Make by P D S                 /
;;; Date is 1997-08-05                   /
;;; Where is "JIN" Electric co.          /
;;; (HP) 017-292-7324                    /
;;;------------------------------        /
;;; - Last Up-Date is 03-02-01 (P.D.S)     /
;;;*****************************************

;;;------------------ Basic Function's -------------------

(defun c:ee(/ sell)
	(setvar "CMDECHO" 0)
	(sel_group)
	(if sell
		(progn
			(command "undo" "group")
			(command "erase" "P" "")
			(command "undo" "end")
		)
		(prompt "\n Select is Nothing ! ")
	)
	(prin1)
)

(defun sel_group (/ sel_key)
  (initget 1 "Text Block Poly Line Dim Arc Circle Hatch")
  (setq	sel_key
	 (getkword "\n Enter Select => Arc/Block/Circle/Dim/Line/Poly/Text/Hatch : "))
  (cond
    ((= sel_key "Text") (setq sell (sel_text)))
    ((= sel_key "Block") (setq sell (sel_block)))
    ((= sel_key "Poly") (setq sell (sel_poly)))
    ((= sel_key "Line") (setq sell (sel_line)))
    ((= sel_key "Dim") (setq sell (sel_dim)))
    ((= sel_key "Arc") (setq sell (sel_arc)))
    ((= sel_key "Circle") (setq sell (sel_cir)))
    ((= sel_key "Hatch") (setq sell (sel_hatch)))
    (T nil)
  )
;  (if sell
;    (prompt "\n Select Group is Complete ")
;    (prompt "\n Select is Nothing ! ")
;  )
;  (prin1)
)

;;------------------------------------------------
(defun li_find (a b) (setq data1 (cdr (assoc a b))))
(defun eeee (a b) (setq ent-des (cdr (assoc b a))))

(defun C:ENTSEL	(/ entty i ent-des _ent)
  (setq entty (entsel "\nSelect object/<None>: "))
  (setq	i -5
	ent-des	nil
  )
  (setq _ent (entget (car entty)))
  (prompt "Select Point : ")
  (prin1 (cadr entty))
  (while i
    (eeee _ent i)
    (if	ent-des
      (progn
	(prompt "\n [")
	(prin1 i)
	(prompt "] => ")
	(prin1 ent-des)
      )
    )
    (setq ent-des nil)
    (setq i (1+ i))
    (if	(> i 255)
      (setq i nil)
    )
  )
  (setq pds-select entty)
)

;;*---------------select option----------------------------
(defun sel_text ()	(ssget ":L" (list (cons 0 "TEXT"))))
(defun sel_mtext ()	(ssget ":L" (list (cons 0 "MTEXT"))))
(defun sel_block ()	(ssget		(list (cons 0 "INSERT"))))
(defun sel_poly ()	(ssget		(list (cons 0 "LWPOLYLINE"))))
(defun sel_line ()	(ssget		(list (cons 0 "LINE"))))
(defun sel_arc ()		(ssget		(list (cons 0 "ARC"))))
(defun sel_cir ()		(ssget		(list (cons 0 "CIRCLE"))))
(defun sel_dim ()		(ssget		(list (cons 0 "DIMENSION"))))
(defun sel_hatch ()		(ssget		(list (cons 0 "hatch"))))
(defun sel_oth (a b)	(ssget		(list (cons a b))))

;;*---------------drag & radian----------------------------
(defun dtr (a) (* pi (/ a 180.0)))
(defun rtd (a) (/ (* a 180.0) pi))

;;*---------------osnap mode-------------------------------
(defun old-sn () (OLD-ERR) (set-os 0))
(defun old-cen () (OLD-ERR) (set-os 4))
(defun old-ins () (OLD-ERR) (set-os 64))
(defun old-mid () (OLD-ERR) (set-os 2))
(defun old-qua () (OLD-ERR) (set-os 16))
(defun old-non () (OLD-ERR) (set-os 0))
(defun old-int () (OLD-ERR) (set-os 32))
(defun old-NEA () (OLD-ERR) (set-os 512))
(defun old-end () (OLD-ERR) (set-os 1))
(defun old-endint () (OLD-ERR) (set-os 33))
(defun old-endintnod () (OLD-ERR) (set-os 41))

(defun set-os (a)
  (setq olds (getvar "osmode"))
  (setvar "osmode" a)
  (prompt " \"OSMODE\" is Change at [")
  (prin1 a)
  (prompt "] ")
)

(defun new-sn ()
  (setvar "OSMODE" olds)
  (prompt "\n \"OSMODE\" is Return at [")
  (prin1 olds)
  (prompt "] ")
  (setq olds nil)
  (prin1)
)

(DEFUN SNAP-RO () (SETVAR "ORTHOMODE" 1))

;;*---------------layer setting----------------------------
(defun la-set (a b)
  (setq old-la (getvar "CLAYER"))
  (if (tblsearch "LAYER" a)
    (command "layer" "s" a "")
    (command "layer" "m" a "c" b a "")
  )
)

(defun la-back ()
  (if old-la
    (command "Layer" "S" old-la "")
    (prompt "**ERROR**")
  )
  (setq old-la nil)
)

;;*---------------error message-----------------------------
(defun OLD-ERR ()
  (setq	olderr	*error*
	*error*	myerror
	chm	0
  )
)

(defun TEXERROR	(s)			;T, TT, TTT, TTW, TTS.....
  (if (/= s "Function cancelled")
    (alert (strcat "\nError: " s))
  )
  (setq p nil)
  (setq *error* olderr)
  (princ)
)

(defun MYERROR (s)
  (if (/= s "Function cancelled")
    (alert (strcat "\nError: " s))
  )
  (if olds
    (new-sn)
  )
  (setq *error* olderr)
  (princ)
)

(defun REERROR (s)			;RE, RE2, RR, RR2
  (if (/= s "Function cancelled")
    (progn (new-la)
	   (new-sn)
	   (setq *error* olderr)
	   (setq olds nil
		 c_layer nil
	   )
	   (princ)
    )
  )
)

;;;*--------------------------------------------------------
;;;*--------------------------------------------------------
;;;------------------ End of Basic -----------------------

;;;------------------ Help Command -----------------------
(defun c:jinkey () (acad_helpdlg "lisp-hlp.hlp" "command"))

;;;------------------ Key Macro's ------------------------
(defun C:WBB (/ wb-name wb-enty)
  (setq wb-name (getstring "\n Enter Wblock Name ? : "))
  (setq wb-enty (ssget))
  (command "wblock" wb-name "" "0,0" wb-enty "" "oops")
)

(defun C:LLMT (/ a b c lim-l lim-h lim-b)
  (setq	a (getvar "LIMMIN")
	b (getvar "LIMMAX")
	c (getvar "INSBASE")
  )
  (old-endintnod)
  (prompt " = Limits & Base ")
  (prompt "\n\t Enter Limits Point (Lower Left) ? <")
  (prin1 a)
  (setq lim-l (getpoint "> :"))
  (if (or (= lim-l nil) (= lim-l ""))
    (setq lim-l a)
  )
  (prompt "\n\t Enter Limits Point (Higher Right) ? :")
  (prin1 b)
  (setq lim-h (getcorner lim-l "> :"))
  (if (or (= lim-h nil) (= lim-h ""))
    (setq lim-h b)
  )
  (prompt "\n\t Enter Base Point (Lower Left) ? :")
  (prin1 c)
  (setq lim-b (getpoint "> :"))
  (if (or (= lim-b nil) (= lim-b ""))
    (setq lim-b c)
  )
  (command "Limits" lim-l lim-h "Base" lim-b)
  (prin1)
  (command "._ZOOM" "ALL")
  (new-sn)
)

(defun C:DEL () (prompt " = Erase ") (command "ERASE"))
(defun C:EF ()
  (prompt " = Erase & Fence ")
  (command "ERASE" "F")
)

(defun C:E11 (/ la name)
  (prompt " = Erase at Lock-Entty (Single) ")
  (setq la (car (entsel "\n\t Pick an object on the Lock-Entty :")))
  (if la
    (progn
      (setq name (cdr (assoc 8 (entget la))))
      (command "layer" "U" name "")
      (command "Erase" "Si" la)
      (command "layer" "Lock" name "")
    )
    (prompt "\n\t Select is Noting")
  )
)

(defun C:EMM (/ la name nl n i e2 t2 ed laname ername)
  (prompt " = Erase at Lock-Entty (Multiple) ")
  (prompt "\n\t Select of object on the Lock-Entty :")
  (command "undo" "group")
  (setq	la (ssget)
	laname ""
	ername nil
	i 0
  )
  (if la
    (progn
      (setq nl (sslength la))
      (setq n (- nl 1))
      (while (<= i n)
			(setq ed (entget (setq e2 (ssname la i))))
			(setq t2 (cdr (assoc 8 ed)))
			(setq laname (strcat laname "," t2))
			(if ername
				  (setq ername (ssadd e2 ername))
				  (setq ername (ssadd e2))
			)
			(setq i (1+ i))
      )
      (command "Layer" "U" laname "")
      (command "Erase" ername "")
      (command "Layer" "Lock" laname "")
    )
  )
  (command "undo" "end")
)

(defun c:ew () (command "erase" "w"))
(defun c:ec () (command "erase" "c"))

(defun C:EWW ()
  (prompt " = Erase & View-All ")
  (command "ERASE" "W" (getvar "VSMIN") (getvar "VSMAX") "")
  (prin1)
)

(defun C:CWW ()
  (prompt " = Chprop & View-All ")
  (command "CHPROP" "W" (getvar "VSMIN") (getvar "VSMAX") "")
  (prin1)
)

(defun C:CCW ()
  (prompt " = Copy & View-All ")
  (command "COPY" "W" (getvar "VSMIN") (getvar "VSMAX") "")
  (prin1)
)

(DEFUN C:ST ()
  (prompt " = STRETCH ")
  (snap-ro)
  (command ".STRETCH")
)
(defun C:ZW ()
  (prompt " = Zoom [Window] ")
  (command "'ZOOM" "W")
  (prin1)
)
(defun C:ZD ()
  (prompt " = Zoom [Dinamic] ")
  (command ".ZOOM" "D")
  (prin1)
)
(defun C:ZP ()
  (prompt " = Zoom [Previews] ")
  (command ".ZOOM" "P")
  (prin1)
)
(defun C:ZZ ()
  (prompt " = Zoom [Previews] ")
  (command ".ZOOM" "P")
  (prin1)
)
(defun C:ZV ()
  (prompt " = Zoom [Vmax-View]")
  (command ".ZOOM" "V")
  (prin1)
)
(defun C:ZE ()
  (prompt " = Zoom & Extend ")
  (command ".ZOOM" "e")
  (prin1)
)

(defun C:ZA ()
  (prompt " = Zoom & Max-view ")
  (command ".zoom" "w" (getvar "EXTMIN") (getvar "EXTMAX"))
)

(defun C:VS (/ vs-name)
  (prompt " = View & Save ")
  (setq vs-name (getstring "\n Enter View Name ? : "))
  (if vs-name
    (command "view" "s" vs-name)
  )
)

(defun C:VR ()
  (prompt " = View & Restore ")
  (command "view" "r")
)

;;;-------------------------------------------------------------
;;;-------------- Start-up & Rename Command ------------------
;;;---------------------- Start-up ---------------------------

;(command "UNDEFINE" "load")
;(command "zoom" "e")
;(command "-layer" "color" 9 "plan,arch" "")
;(command "UNDEFINE" "load")
(defun S::STARTUP ()

;  (setq m_data (strcat "(주) 진전기 엔지니어링" " : 박 대식 "))
;  (command "MODEMACRO" m_data)
;	(prin1)
	(setvar "BLIPMODE" 1)
	(setvar "CMDECHO" 0)
	(setvar "mirrtext" 0)
	(setvar "CHAMFERA" 0)
	(setvar "CHAMFERB" 0)
	(setq name (getvar "dwgname"))

	(command "UNDEFINE" "END")
	(command "UNDEFINE" "load")
	(command "undefine" "qsave")
	(command "FILL" "ON")
	(command "REGENAUTO" "OFF")
;  (y3name)
	(setq	dwg-scale	(GETVAR "USERR1")
			bk1			(GETVAR "USERR2")
			wire-scale	(GETVAR "USERR3")
	)

	(if (tblsearch "layer" "plan")
		(command "Layer" "Color" 9 "plan,arch" "")
	)

	(PRIN1)
);

(defun c:aaaa()(s::startup))
;;------------------ Rename of Command's ---------------------
;(defun C:QUIT()   (command ".QUIT" ))
;(defun C:SAVE()   (command ".save" "~"))
;(defun C:SAVEAS() (command ".saveas" "~")(c:name))

(defun C:QSAVE ()
  (if c:date-time
    (C:DATE-TIME)
  )
  (command ".qsave")
)
(defun C:QQ ()
  (if c:date-time
    (C:DATE-TIME)
  )
;  (c:pp)
  (command ".qsave")
)

(defun C:END (/ a olds)
  (setq a (getvar "cmdecho"))
  (setvar "cmdecho" 0)
  (initget "Yes No")
  (if (= (getkword
	   "\nEND the drawing session?  Yes(save)/No(cancel): "
	 )
	 "Yes"
      )
    (progn (command ".qsave" "" ".quit"))
    (princ "\nYou must enter Yes to END a drawing session.")
  )
  (if a
    (setvar "cmdecho" a)
  )
  (princ)
)


;;-------------- Drawing File Indoor Information ---------------

(defun c:path (/ a b c d)
  (setq a (getvar "dwgname"))
  (setq b (getvar "dwgprefix"))
  (prompt "\n Drawing-File Name is => ")
  (prin1 a)
  (prompt "\n Drawing Path is => ")
  (prin1 b)
  (prin1)
)

(defun Y3NAME (/ x1 x2 y1 y2)
  (setq x1 (strlen (setq x2 (getvar "dwgprefix"))))
  (setq y1 (strlen (setq y2 (getvar "dwgname"))))
  (cond
    ((< y1 9) (setq y3 y2))
    ((= x1 y1) (setq y3 y2))
    ((> y1 x1) (setq y3 (substr y2 (+ x1 1) y1)))
    ((< y1 x1) (setq y3 y2))
  )
  (setq _dwgname y3)
)

(defun C:NAME2 (/ tth p1)
  (setq tth (getreal "\n Enter DWG-NAME's text hight ? : "))
  (setq p1 (getpoint "\n Enter Text point ? : "))
  (command "text" p1 tth "" _dwgname)
)

;;----------------------------------------------------------
;;                    Acad.pgp File
;;----------------------------------------------------------
;;I,      *DDINSERT        ;DT,     *DTEXT         ;D,      *DIST
;;BL,     *BLOCK           ;A,      *ARRAY         ;C,      *COPY
;;DD,     *DDEDIT          ;EP,     *EXPLODE       ;E,      *ERASE
;;WB,     *WBLOCK          ;PE,     *PEDIT         ;M,      *MOVE
;;REN,    *RENAME          ;O,      *OFFSET        ;S,      *SCALE
;;LA,     *LAYER           ;B,      *BREAK         ;ST,     *STRETCH
;;MS,     *MSPACE          ;F,      *FILLET        ;MI,     *MIRROR
;;P,      *PAN             ;CH,     *CHANGE        ;RO,     *ROTATE
;;PS,     *PSPACE          ;CP,     *CHPROP        ;TR,     *TRIM
;;DV,     *DVIEW           ;CM,     *CHAMFER       ;EX,     *EXTEND
;;LT,     *LINETYPE        ;PL,     *PLINE         ;3DLINE, *LINE
;;R,      *REDRAW          ;H,      *HATCH         ;PT,     *POINT
;;Z,      *ZOOM            ;EP,     *EXPLODE       ;CI,     *CIRCLE
;;VW,     *VIEWRES         ;DI,     *DIVIDE        ;L,      *LINE
;;SK,     *SKETCH          ;PO,     *POLYGON       ;DO,     *DONUT

;;---------------------------------------------------------
;;--------------------- Lisp Program's --------------------
;;---------------------------------------------------------


;;;;=============
(defun C:MX (/	    ts	   a	  b	 c	t11    t-ipx1 t-ipx2
	     t-ipx  t-ipy1 t-ipy2 t-ipy	 l	l1     pt-new tt-ip
	     ip-x   ip-y   ip-z	  count	 i	t1     t2     et1
	     x_y    t0
	    )
					; X-position Change
  (setq	olderr	*error*
	*error*	TEXERROR
	chm	0
  )
  (prompt " = Block's Insert-Point Change -> (X) Point ")
  (ch_blkp T)
)

(defun C:MY (/	    ts	   a	  b	 c	t11    t-ipx1 t-ipx2
	     t-ipx  t-ipy1 t-ipy2 t-ipy	 l	l1     pt-new tt-ip
	     ip-x   ip-y   ip-z	  count	 i	t1     t2     et1
	     x_y    t0
	    )
					; Y-position Change
  (setq	olderr	*error*
	*error*	TEXERROR
	chm	0
  )
  (prompt " = Block's Insert-Point Change -> (Y) Point ")
  (ch_blkp nil)
)

(defun ch_blkp (set_t / mes_mxmy)
	(if (= set_t T)
		(setq x_y "X")
		(setq x_y "Y")
	)
	(setq ts (sel_block))
	(prompt "\n\t !!! select BLOCK : TARGET BLOCK [")
	(prompt x_y)
	(prompt "-POINT ] : ONLY ONE SELECT !!!")
	(setq et1 (CAR (ENTSEL)))

	(setq T-IPX (CAR (CDR (ASSOC 10 (ENTGET et1)))))
	(setq T-IPy (CaDR (cdr (ASSOC 10 (ENTGET et1)))))

	(setq L (SSLENGTH ts))
	(setq	i 0
			COUNT 0
	)
	(setq l1 (- l 1))
	(while (<= i l1)
		(setq t1 (ssname ts i))
		(setq t2 (entget t1))
		(setq t0 (cdr (assoc 0 t2)))
		(setq t11 (cadr (cdr (assoc 11 t2))))
		(setq bl_code_66 (cdr (assoc 66 t2)))
		(if (= bl_code_66 nil)(setq bl_code_66 0))
		(if (= bl_code_66 0)
			(_ipp t2 x_y 10)
		)
		(setq i (+ i 1))
	)
;	(prompt "\n\t CHANGE POINT-")
;	(prompt x_y)
;	(prompt " is --> ")
;	(PRIN1 COUNT)
;	(prompt "/")
;	(PRIN1 i)
	(setq mes_mxmy (strcat "CHANGE POINT-" x_y " is --> " (rtos COUNT) "/" (rtos i)))
	(prin1 mes_mxmy)
	(prin1)
)

;;;;=============
;;;-------------------------------------------------------------------------
;;;  Layer's Change or Setting

					;(defun c:mla()
					;  (prompt "\n MLA1 [ E-LINE(2),E-LINE2(2),E-WIRE(1),E-SYM(3),E-RECEP(3),ELP(2),;PLAN(253) ]")
					;  (prompt "\n MLA2 [ LINE(2),LINE2(2),WIRE(1),ELEC(3),RECEP(3),ELP(2),PLAN(253); ]")
					;  (prompt "\n MLAS [ LAYER-MAKE as SAMOO ( FOR ELECTRIC DESIGN )]")
					;)

(defun c:mla ()
  (command "layer"    "n"	 "line,recep,plan,title"
	   "c"	      "1"	 "line"	    "c"	       "6"
	   "recep"    "c"	 "253"	    "plan"     "c"
	   "101"      "title"	 "lt"	    "rece100"  "recep"
	   "s"	      "plan"	 ""
	  )
  (prompt "\n MLA1 [ LINE(1),RECEP(6),PLAN(253) ]")
)

(defun C:MLA1 ()
  (command "color" "bylayer")
  (command "layer"	       "n"
	   "e-line,e-title,e-wire,e-sym,e-recep,e-elp,e-plan,e-text"
	   "c"		       "2"
	   "e-line,e-line2,e-elp,e-recep"	   "c"
	   "3"		       "e-sym,e-text"	   "c"
	   "253"	       "e-plan"		   "c"
	   "1"		       "e-wire"		   "lt"
	   "pds3"	       "e-line2"	   "lt"
	   "rece4"	       "e-recep"	   "lt"
	   "elp"	       "e-elp"		   "C"
	   "4"		       "SHEET"		   "S"
	   "E-PLAN"	       ""
	  )
  (prompt
    "\n ** Layer [ E-LINE(2),E-LINE2(2),E-WIRE(1),E-SYM(3),E-RECEP(3),ELP(2),PLAN(15) ] in Make ! **"
  )
)

(defun C:MLA2 ()
  (command "color" "bylayer")
  (command "layer"	  "n"
	   "line,line2,wire,elec,recep,elp,plan,mach,50"
	   "c"		  "1"		 "line,line2,elp"
	   "c"		  "3"		 "50,elec"
	   "c"		  "6"		 "recep"
	   "c"		  "9"		 "plan"		"c"
	   "1"		  "wire"	 "lt"		"pds3"
	   "line2"	  "c"		 "5"		"mach"
	   "C"		  "4"		 "SHEET"	"lt"
	   "rece4"	  "recep"	 "lt"		"elp"
	   "elp"	  "S"		 "PLAN"		""
	  )
  (prompt
    "\n ** Layer [ LINE(2),LINE2(2),WIRE(1),ELEC(3),RECEP(6),ELP(2),PLAN(9),MACH(5) ] in Make ! **"
  )
)

(defun C:MLAs ()
  (command "COLOR" "BYLAYER")
  (command "LAYER"	     "N"
	   "SHEET,ARCH,SP,SL,SRE,STE,STV,SSE,SF,SW,L1,L2,L3,L4,T3,TE"
	   "C"		     "2"	       "STE,STV,SSE,SF,SW,TE"
	   "C"		     "253"	       "ARCH"
	   "C"		     "4"	       "L1,L2,L3,L4"
	   "C"		     "6"	       "T3"
	   "C"		     "10"	       "SP,SL,SRE"
	   "C"		     "4"	       "SHEET"
	   "LT"		     "RECE4"	       "L2"
	   "LT"		     "ELP"	       "L3"
	   "LT"		     "PDS"	       "L4"
	   "S"		     "L1"	       ""
	  )
  (prompt
    "\n ** LAYER-MAKE WAS COMPLETE ( FOR ELECTRIC DESIGN ) **"
  )
)

;;;-------------------------------------------------------------------------
(defun c:fc()(c:chla))	;	layer-change
(defun c:ff()(c:fla))	;	layer-off
(defun c:fff()(c:ffla))	;	layer-freeze-off
(defun c:fs()(c:sla))	;	layer-set
(defun c:fss()(c:sla)(c:off))	;	layer-set
(defun c:fu()(c:ula))	;	layer-unlock
(defun c:fuu()(c:uula))	;	layer-unlock
(defun c:ft()(c:tla))	;	layer-unfreeze
(defun c:fd()(c:lla))	;	layer-unfreeze
(defun c:fdd()(c:lock))	;	layer-freeze-off

(defun C:CL (/ a1 a2 b2 la-name)
  (prompt " = Change Layer (Target)")
  (setq	olderr	*error*
	*error*	myerror
	chm	0
  )
  (prompt "\n ** Select Object to be changed : ")
  (setq a1 (ssget))
  (if a1
    (progn
      (prompt "\n ** Select-Pick to entity on target layer : ")
      (setq a2 (entsel))
      (if a2
	(progn
	  (setq b2 (entget (car a2)))
	  (setq la-name (cdr (assoc 8 b2)))
	)
	(setq la-name (getstring "\n Enter target Layer Name : "))
      )
      (command "CHPROP" a1 "" "layer" la-name "c" "bylayer" "")
    )
  )
  (prompt "\n Change Layer is [")
  (prin1 la-name)
  (prompt "] ")
  (prin1)
)

;;;-------------------------------------------------------------------------

(defun C:CC (/ a la-name)
  (prompt " = Change Layer (Current)")
  (setq	olderr	*error*
	*error*	myerror
	chm	0
  )
  (prompt
    "\n ** Select Object to be changed : ( By-Current LAYER )"
  )
  (setq a (ssget))
  (if a
    (progn
      (setq la-name (getvar "CLAYER"))
      (command "CHPROP" a "" "layer" la-name "c" "bylayer" "")
    )
  )
  (prompt "\n Change Layer is [")
  (prin1 la-name)
  (prompt "] ")
  (prin1)
)

(defun C:CC2 (/ a la-name)
  (prompt " = Change Layer (Current)")
  (setq	olderr	*error*
	*error*	myerror
	chm	0
  )
  (prompt
    "\n ** Select Object to be changed : ( By-Current LAYER )"
  )
  (setq a (ssget))
  (if a
    (progn
      (setq la-name (getvar "CLAYER"))
      (command "CHPROP"	 a	   ""	     "layer"   la-name
	       "c"	 "bylayer" "ltype"   "bylayer" ""
	      )
    )
  )
  (prompt "\n Change Layer is [")
  (prin1 la-name)
  (prompt "] ")
  (prin1)
)


(defun C:SLA (/ la name)
  (prompt " = Set Layer (Pick)")
  (setq	olderr	*error*
	*error*	myerror
	chm	0
  )
  (setq la (car (entsel "\n\t Pick an object on the SETTING LAYER :")))
  (if la
    (progn
      (setq name (cdr (assoc 8 (entget la))))
      (command "layer" "set" name "")
      (command "layer" "Unlock" name "")
    )
    (progn
;      (setq name (getstring "\n\t Enter the SET-LAYER to NAME ? : "))
;      (command "layer" "set" name "")
;      (command "layer" "Unlock" name "")
			(initdia 1)
			(command "layer")
			(setq name (getvar "clayer"))
			(command "layer" "Unlock" name "")
    )
  )
  (prin1 name)
  (prin1)
)

;;;-------------------------------------------------------------------------
(defun c:ff2(/ a b c n nl i name l_na)
	(prompt  "\n\t Select of Non-Off mode entty ? :")
	(setq a (ssget))
	(setq n (sslength a) i 0 nl (- n 1) )
	(setq name (getvar "CLAYER"))
	(while (>= nl 0)
		(setq c (entget (ssname a i)))
		(setq l_na (cdr (assoc 8 c)))
		(setq name (strcat name "," l_na))
		(setq i (1+ i))
		(setq nl (- nl 1))
	)
	(command "layer" "off" "*" "n" "")
	(command "layer" "on" name "")
)

(defun C:FLA (/ la name)
  (prompt " = Off Layer (Pick)")
  (setq	olderr	*error*
	*error*	myerror
	chm	0
  )
  (setq la (car (entsel "\n\t Pick an object to be --OFF-- layer :")))
  (if la
    (progn
      (setq name (cdr (assoc 8 (entget la))))
      (command "layer" "off" name "")
    )
    (progn
;      (setq name (getstring "\n\t Enter the OFF-LAYER's to NAME ? : "))
;      (command "layer" "off" name "")
			(initdia 1)
			(command "layer")
    )
  )
  (prin1 name)
  (prin1)
)

(defun C:FFLA (/ la name)
  (prompt " = Off & Freeze Layer (Pick)")
  (setq	olderr	*error*
	*error*	myerror
	chm	0
  )
  (setq la (car (entsel "\n\t Pick an object to be -- Off, Freeze -- layer :")))
  (if la
    (progn
      (setq name (cdr (assoc 8 (entget la))))
      (command "layer" "off" name "f" name "")
    )
    (progn
;      (setq name (getstring "\n\t Enter the Off and Freeze LAYER's to NAME ? : "))
;      (command "layer" "off" name "f" name "")
			(initdia 1)
			(command "layer")
    )
  )
  (prin1 name)
  (prin1)
)

(defun C:UULA (/ la name)
  (prompt " = Un-Lock Layer (Pick)")
  (setq	olderr	*error*
	*error*	myerror
	chm	0
  )
  (setq
    la (car (entsel "\n\t Pick an object to be --UNLOCK-- layer :")
       )
  )
  (if la
    (progn
      (setq name (cdr (assoc 8 (entget la))))
      (command "layer" "unlock" name "")
    )
    (progn
;      (setq	name (getstring "\n\t Enter the Un-LOCK-LAYER's to NAME ? : "))
;      (command "layer" "unlock" name "")
			(initdia 1)
			(command "layer")
    )
  )
  (prin1 name)
  (prin1)
)

(defun C:LLA (/ la name)
  (prompt " = Lock Layer (Pick)")
  (setq	olderr	*error*
	*error*	myerror
	chm	0
  )
  (setq la (car (entsel "\n\t Pick an object to be --LOCK-- layer :")))
  (if la
    (progn
      (setq name (cdr (assoc 8 (entget la))))
      (command "layer" "lock" name "")
    )
    (progn
;      (setq name (getstring "\n\t Enter the LOCK-LAYER's to NAME ? : "))
;      (command "layer" "lock" name "")
			(initdia 1)
			(command "layer")
    )
  )
  (prin1 name)
  (prin1)
)

(defun C:LOCK (/ la)
  (prompt " = Lock-Layer (*)")
  (prompt "\n\t Typing the With Un Lock layer Name :")
  (setq la (getstring " Enter is Only Current Layer : "))
  (if (or (= la nil) (= la ""))
    (setq la nil)
  )
  (command "layer" "lock" "*" "u" (getvar "CLAYER") "")
  (if la
    (command "layer" "u" la "")
  )
)

(defun C:ULA ()
  (prompt " = Un-Lock Layer (*)")
  (command "Layer" "U" "*" "")
  (prin1)
)

(defun C:TLA ()
  (prompt " = Un-Freeze Layer (*)")
  (command "Layer" "T" "*" "")
  (prin1)
)

;;;-------------------------------------------------------------------------

(defun C:ELA (/ la la_name del_la del_no)
  (prompt " = Erase-Layer (Pick)")
  (setvar "cmdecho" 0)
  (setq	la (car
	     (entsel "\n\t *** Pick an object to be DELETED LAYER :")
	   )
  )
  (if (= la nil)
    (setq
      la_name (strcase
		(getstring "\n\t *** Type Layer name to be ERASED :")
	      )
    )
    (setq la_name (cdr (assoc 8 (entget la))))
  )
  (setq del_la (ssget "X" (list (cons 8 la_name))))
  (setq index 0)
  (if (/= del_la nil)
    (progn
      (command "erase" del_la "")
      (setq del_no (sslength del_la))
    )
  )
  (setq del_la nil)
  (prompt (strcat "\n\t** Thank you! selected ["
		  la_name
		  "] layer erasd = "
	  )
  )
  (prin1 del_no)
  (prin1)
)

(defun C:OLA (/ lam)
  (prompt " = On-Layer (Name)")
  (setq lam (getstring "\n\t Typing the -On- Layer Name ? : "))
  (setq lam (strcat lam "*"))
  (if lam
    (command "layer" "on" lam "")
  )
  (prin1 lam)
  (prin1)
)

;;;-------------------------------------------------------------------------

(defun C:ON ()
  (prompt " = On-Layer (*)")
  (command "layer" "on" "*" "")
)
(defun C:OFF ()
  (prompt " = Off-Layer (*)")
  (command "LAYER" "OFF" "*" "N" "")
)

(DEFUN C:off2 (/ i a aa aa-l aaa)
  (SETQ I T)
  (setq aaa "0")
  (tblnext "layer" t)
  (while i
    (setq a (tblnext "layer"))
    (if	a
      (progn
	(setq aa (cdr (assoc 6 a)))
	(setq aa-l (cdr (assoc 2 a)))
	(if (= aa "CONTINUOUS")
	  (setq aaa (strcat aaa "," aa-l))
	)
      )
      (setq i nil)
    )
  )
  (if aaa
    (command "layer" "off" aaa "" "")
  )
  (prompt "\n Off Layer ==> Ltype is \"Continuous\"")
  (prompt " : [ ")
  (prin1 aaa)
  (prompt " ] ")
  (prin1)
)

(DEFUN C:off3 (/ i a aa aa-l aaa)
  (SETQ I T)
  (setq aaa "")
  (tblnext "layer" t)
  (while i
    (setq a (tblnext "layer"))
    (if	a
      (progn
	(setq aa (cdr (assoc 6 a)))
	(setq aa-l (cdr (assoc 2 a)))
	(if (/= aa "CONTINUOUS")
	  (if (= aaa "")
	    (setq aaa aa-l)
	    (setq aaa (strcat aaa "," aa-l))
	  )
	)
      )
      (setq i nil)
    )
  )
  (if (/= aaa "")
    (command "layer" "off" aaa "" "")
  )
  (prompt "\n Off Layer ==> Ltype is Not-\"Continuous\"")
  (prompt " : [ ")
  (prin1 aaa)
  (prompt " ] ")
  (prin1)
)

;;;-------------------------------------------------------------------------

(DEFUN C:CHH ()
  (PROMPT
    "\n CH1 : [Layer=LINE], [Color=bylayer], [Ltype=bylayer] "
  )
  (PROMPT
    "\n CH2 : [Layer=100],  [Color=4],       [Ltype=ELP] "
  )
  (PROMPT
    "\n CH3 : [Layer=RECEP],[Color=bylayer], [Ltype=bylayer] "
  )
  (PROMPT
    "\n CH4 : [Layer=ELP],  [Color=bylayer], [Ltype=bylayer] "
  )
  (PROMPT
    "\n CH5 : [Layer=PLAN], [Color=7],       [Ltype=ELP] "
  )
  (PROMPT
    "\n CH6 : [Layer=PLAN], [Color=7],       [Ltype=PDS3] "
  )
  (PROMPT
    "\n CH7 : [Layer=PLAN], [Color=bylayer], [Ltype=Default] "
  )
  (PROMPT "\n 33  : [Layer=Default], [Color=3], [Ltype=PDS] ")
)

(defun chg-lalt	(a / b)
  (setq b (ssget))
  (command "CHPROP" b "" "layer" a "c" "bylayer" "LT" "BYLAYER"	"")
)

(defun C:CH1 (/ a)
  (prompt
    "\n Change of layer=[LINE], color=[byl], ltype=[byl]"
  )
  (chg-lalt "LINE")
)

(defun c:ch2 ()
  (setq a (car (entsel)))
  (prompt "\n Change of layer=[100], color=[4], ltype=[ELP]")
  (command "chprop" a "" "layer" "100" "c" 4 "ltype" "elp" "")
)

					;(defun C:CH2(/ a)(chg-lalt "100"))

(defun C:CH3 (/ a)
  (prompt
    "\n Change of layer=[RECEP], color=[byl], ltype=[byl]"
  )
  (chg-lalt "RECEP")
)

(defun C:CH4 (/ a)
  (prompt "\n Change of layer=[ELP], color=[byl], ltype=[byl]"
  )
  (chg-lalt "ELP")
)

(defun c:33 ()
  (prompt "\n Change of layer=[None], color=[3], ltype=[PDS]")
  (setq a (ssget))
  (command "chprop" a "" "c" 3 "ltype" "pds" "")
)

(defun c:ch5 ()
  (prompt "\n Change of layer=[PLAN], color=[7], ltype=[ELP]")
  (setq a (ssget))
  (command "chprop" a "" "layer" "plan"	"c" 7 "ltype" "elp" "")
)

(defun c:ch6 ()
  (prompt "\n Change of layer=[PLAN], color=[7], ltype=[PDS3]"
  )
  (setq a (ssget))
  (command "chprop" a "" "layer" "plan"	"c" 7 "ltype" "pds3" "")
)

(defun c:ch7 ()
  (prompt
    "\n Change of layer=[PLAN], color=[byl], ltype=[None]"
  )
  (setq a (ssget))
  (command "chprop" a "" "layer" "plan" "c" "bylayer" "")
)

					;(defun C:CHH()(COMMAND "CHPROP" "SI" "COLOR" "BYLAYER" "LAYER" "100" "LTYPE" "ELP"))
					;(defun C:CH1(/ a)(chg-lalt "L1"))
					;(defun C:CH2(/ a)(chg-lalt "L2"))
					;(defun C:CH3(/ a)(chg-lalt "L3"))
					;(defun C:CH4(/ a)(chg-lalt "L4"))
					;(defun C:CH5(/ a)(chg-lalt "TE"))
					;(defun C:CH6(/ a)(chg-lalt "T3"))

					;-----------------------
(defun chg-ltype (a / b)
  (prompt "\n LINETYPE to CHANGE at [ ")
  (prin1 a)
  (prompt " ] :")
  (setq b (ssget))
  (command "CHPROP" b "" "LT" a "")
)

(defun C:LT1 (/ a) (chg-ltype "PDS3"))
(defun C:LT1A (/ a) (chg-ltype "PDS2"))
(defun C:LT1B (/ a) (chg-ltype "PDS3"))
(defun C:LT2 (/ a) (chg-ltype "RECE3"))
(defun C:LT2A (/ a) (chg-ltype "RECE5"))
(defun C:LT2B (/ a) (chg-ltype "RECE3"))
(defun C:LT3 (/ a) (chg-ltype "HIDDENN"))
(defun C:LT4 (/ a) (chg-ltype "ELP2"))
(defun C:LT5 (/ a) (chg-ltype "ELP2A"))
(defun C:LT6 (/ a) (chg-ltype "ELP2B"))

					;-----------------------
(defun C:LTY (/ a)
  (if (= ltname nil)
    (setq ltname "BYLAYER")
  )
  (prompt "\n CHANGE-LINETYPE <")
  (prin1 ltname)
  (prompt "> : ")
  (prompt "  if LineType Setting --> command : LTT ")
  (prompt "\n Select Object for change : ")
  (setq a (ssget))
  (if a
    (command "CHPROP" a "" "lt" ltname "")
  )
  (prin1)
)

					;-----------------------
(defun C:LTT ()
  (setq LTNAME (getstring "\n Enter LineType name ? : "))
  (prompt "\t Now Changing LineType is [")
  (prin1 ltname)
  (prompt "] --")
  (c:lty)
)

;;;-------------------------------------------------------------------------
;;;-------------------------------------------------------------------------
;;;  Select-object at the Change ( angle,scale,....)

					;Rotate Comment.

(defun C:R1 (/ a b p1) (bl-r1 180))
(defun C:R2 (/ a b p1) (bl-r1 90))
(defun C:RO1 (/ a b p1) (bl-r1 60))
(defun C:RO2 (/ a b p1) (bl-r1 -60))

					;-----------------------
(defun bl-r1 (b)
  (prompt " = Block Rotate at [")
  (prin1 b)
  (prompt "] ")
  (setq	olderr	*error*
	*error*	myerror
	chm	0
  )
  (old-non)
  (setq a (entsel))
  (setq p1 (cdr (assoc 10 (entget (car a)))))
  (command "rotate" a "" p1 b)
  (new-sn)
)

;;;-------------------------------------------------------------------------
;;;-------------------------------------------------------------------------
(defun C:R3 (/ ro-x ebl nl n ctts e2 ed p1 i)
  (prompt "\n Select Block's Groop-Rotate at +90")
  (bl-ro 90)
  (prin1)
)

(defun C:R4 (/ ro-x ebl nl n ctts e2 ed p1 i)
  (prompt "\n\t Select Block's Groop-Rotate ")
  (bl-ro 0)
  (prin1)
)

(defun C:R5 (/ ro-x ebl nl n ctts e2 ed p1 i)
  (prompt
    "\n\t Select Block's Groop-Rotate <All is Rotate = 0> "
  )
  (bl-ro "0")
  (prin1)
)

(defun bl-ro (ro-x)
	(if (= ro-x 0)
		(setq b "??")
		(setq b ro-x)
	)
	(prompt " = Block Rotate at [")
	(prin1 b)
	(prompt "] ")
	(setq	olderr	*error*
			*error*	myerror
			chm	0
	)
	(setq ebl (ssget ":L"	(list (cons 0 "INSERT"))))
	(setq nl (sslength ebl))
	(setq n (- nl 1))
	(setq ctts 0)
	(setq i 0)
	(old-non)
	(if (= ro-x 0)
		(setq r_ang (getreal "\n  Enter the Rotation's ANGLE ? : "))
		(if	(= ro-x "0")
			(setq r_ang 0)
			(setq r_ang 90)
		)
	)
	(while (<= i n)
		(setq ed (entget (setq e2 (ssname ebl i))))
		(setq bna0 (cdr (assoc 0 ed)))
		(if	(= "INSERT" bna0)
			(progn
				(setq p1 (cdr (assoc 10 ed)))
				(command "rotate" e2 "" p1 r_ang)
				(setq ctts (+ ctts 1))
			)
		)
		(setq i (1+ i))
	)
	(new-sn)
	(prompt "\n Rotate at -- [")
	(prin1 ctts)
	(prompt "] ea ")
)

(defun C:R0 (/ e1 nl n i chm e2 t0 tt1 tts1 ed)
  (setq	olderr	*error*
	*error*	TEXERROR
	chm	0
  )
  (prompt " = Block's Angle -> [0] ")
  (setq i 0)
  (setq e1 (sel_block))
  (if e1
    (progn
      (setq nl (sslength e1))
      (setq n (- nl 1))
      (while (<= i n)
	(setq ed (entget (setq e2 (ssname e1 i))))
	(setq ed (subst (cons 50 0) (assoc 50 ed) ed))
	(entmod ed)
	(setq i (1+ i))
      )
    )
  )
)

;;----------------------------------------------------------------------------
;;----------------------------------------------------------------------------
(defun err () (alert " [ Missing the non-input !!! ] "))

(setq bl-sc (getvar "USERR4"))

(defun set-blsc	()
  (prompt "\n\t Enter Block Sclae <")
  (prin1 bl-sc)
  (prompt "> : ")
  (setq sold bl-sc)
  (initget (+ 2 4))
  (setq bl-sc (getreal))
  (if (= bl-sc nil)
    (setq bl-sc sold)
  )
  (setvar "userr4" bl-sc)
)

;;----------------------------------------------------------------------------
(defun C:SS (/ sold tag p3)
  (setq	olderr	*error*
	*error*	myerror
	chm	0
  )
  (if (or (= bl-sc 0.0) (= bl-sc nil))
    (setq bl-sc wire-scale)
  )
  (prompt "\n\t SCALE at [")
  (prin1 bl-sc)
  (prompt "] ")
  (prompt " and Select<Pick> / Scale(Enter) : ")
  (old-non)
  (setq tag (entsel))
  (if tag
    (progn
      (setq p3 (cdr (assoc 10 (entget (car tag)))))
      (command "scale" tag "" p3 bl-sc)
    )
    (set-blsc)
  )
  (new-sn)
)

;;----------------------------------------------------------------------------
(defun C:SM (/ sold tag bl bl1 i n nl p3)
  (setq	olderr	*error*
	*error*	myerror
	chm	0
  )
  (if (or (= bl-sc 0.0) (= bl-sc nil))
    (setq bl-sc wire-scale)
  )
  (prompt "\n\t SCALE at [")
  (prin1 bl-sc)
  (prompt "] ")
  (prompt " and Select<Multiple> / Scale(Enter) : ")
  (old-non)
  (setq tag (ssget (list (cons 0 "INSERT"))))
  (if tag
    (progn
      (setq i 0)
      (setq nl (sslength tag))
      (setq n (- nl 1))
      (while (<= i n)
	(setq bl (entget (setq bl1 (ssname tag i))))
	(if (= "INSERT" (cdr (assoc 0 bl)))
	  (progn
	    (setq p3 (cdr (assoc 10 bl)))
	    (command "scale" bl1 "" p3 bl-sc)
	  )
	)
	(setq i (1+ i))
      )
    )
    (set-blsc)
  )
  (new-sn)
)

;;----------------------------------------------------------------------------
;;----------------------------------------------------------------------------
;;----------------------------------------------------------------------------
					;Block Mirror Comment. (!! old Object is deleted or life !!)
					;-----------------------

(defun C:MI1 (/ kk A P3)
  (prompt " = Block Mirring Vertical (Old is Del)")
  (old-non)
  (setq kk 1)
  (while kk
    (setq A (ENTSEL))
    (if	a
      (progn
	(setq P3 (CDR (ASSOC 10 (ENTGET (CAR A)))))
	(command "MIRROR" A "" P3 "@100<90" "Y")
      )
      (setq kk nil)
    )
  )
  (new-sn)
)
					;-----------------------
(defun C:MI2 (/ kk A P3)
  (prompt " = Block Mirring Horigental (Old is Del)")
  (old-non)
  (setq kk 1)
  (while kk
    (setq A (ENTSEL))
    (if	a
      (progn (setq P3 (CDR (ASSOC 10 (ENTGET (CAR A)))))
	     (command "MIRROR" A "" P3 "@100<0" "Y")
      )
      (setq kk nil)
    )
  )
  (new-sn)
)
					;-----------------------

(defun mirr-yn (key1 key2)
  (old-non)
  (setvar "OSMODE" 0)
  (if (= key1 "H")
    (setq pnt2 "@1<90")
    (setq pnt2 "@1<0")
  )
  (prompt "\n Select the Mirror's entty : ")
  (setq MI (ssget))
  (if MI
    (progn
      (setvar "OSMODE" 2)
      (setq P1 (getpoint "\n Pick the Mirroring Base Point (mid) : "))
      (setvar "OSMODE" 0)
      (command "MIRROR" MI "" P1 pnt2 key2)
    )
    (prompt "\n Select was Empty .....")
  )
  (new-sn)
)

(defun C:MI3 () (mirr-yn "H" "Y"))
(defun C:MI4 () (mirr-yn "V" "Y"))
(defun C:MI5 () (mirr-yn "H" "N"))
(defun C:MI6 () (mirr-yn "V" "N"))


;;-----------------------------------------------------------------------

;;-----------------------------------------------------------------------
;;;  Other

(defun C:UCSE ()
  (SNAP-RO)
  (command "Ucsicon" "on")
  (command "Ucsicon" "N")
  (command "Ucs" "E")
)
(defun C:UCSW ()
  (SNAP-RO)
  (command "Ucsicon" "on")
  (command "Ucsicon" "N")
  (command "Ucs" "W")
)
(defun C:UCSV ()
  (SNAP-RO)
  (command "Ucsicon" "on")
  (command "Ucsicon" "N")
  (command "Ucs" "V")
)

(defun per_li (b / pt1 pt2)
  (setq pt1 (cdr (assoc 10 b)))
  (setq pt2 (cdr (assoc 11 b)))
  (setq ang1 (angle pt1 pt2))
  (SNAP-RO)
  (setvar "SNAPANG" ang1)
)

(defun per_bl (b)
  (setq ang1 (cdr (assoc 50 b)))
  (SNAP-RO)
  (setvar "SNAPANG" ang1)
)

(defun per_ar (b / ang2)
  (setq ang1 (cdr (assoc 50 b)))
  (setq ang2 (cdr (assoc 51 b)))
  (setq ang1 (/ (+ ang1 ang2) 2))
  (SNAP-RO)
  (setvar "SNAPANG" ang1)
)

(defun C:PER (/ b pt1 pt2 ang1 ang2 xx last-po ent_name)
  (setq	olderr	*error*
	*error*	myerror
	chm	0
  )
  (setq	xx nil
	ang1 nil
	ent_name nil
	last-po	nil
  )
  (graphscr)
  (setq last-po (getvar "lsatpoint"))
  (setq
    b (entget
	(car
	  (entsel
	    "\n Select the \"Snap Angle Change\" at Line,Arc,Block :"
	  )
	)
      )
  )
  (if b
    (setq ent_name (cdr (assoc 0 b)))
  )
  (cond
    ((= ent_name "LINE") (per_li b))
    ((= ent_name "INSERT") (per_bl b))
    ((= ent_name "TEXT") (per_bl b))
    ((= ent_name "ARC") (per_ar b))
    (T nil)
  )
  (if last-po
    (setvar "lastpoint" last-po)
  )
  (if ang1
    (progn
      (setq xx (rem (rtd ang1) 360))
      (prompt "\n** Select Angle is [")
      (prin1 xx)
      (prompt "] **")
    )
    (prompt "\n !!! Select is Fail !!!")
  )
  (prin1)
)

;;---------------

					;(defun C:DWGS(/ a1 a)
					;   (setq olderr  *error* *error* myerror chm 0)
					;   (setq a1 (getvar "LTSCALE"))
					;   (prompt "\n Enter DRAWING scale's = \"LTSCALE\" ? <")(prin1 a1)
					;   (prompt "> :")
					;   (setq a(getreal))
					;   (if (or (= a "")(= a nil))(setq a a1))
					;   (setq dwg-scale (/ a 100))
					;   (setvar "LTSCALE" a)
					;   (setvar "USERR1" dwg-scale)
					;   (setq ard nil)
					;   (setvar "regenmode" 0)
					;   ;;(setvar "fillmode" 1)
					;   (setvar "ucsicon" 0)
					;   (if br-harf
					;      (progn
					;         (br-harf)
					;         (prompt "\n !!! Return of Wire's Break-Width !!! ")
					;      )
					;   )
					;   (C:W-SC)
					;   (prin1)
					;)

;;--------------

(defun DIMENSION (/ p1 dsc dsc1 dsc2)
  (setq	olderr	*error*
	*error*	myerror
	chm	0
  )
  (command "layer" "unlock" "*" "")
  (setq p1 (getvar "VIEWCTR"))
  (command ".insert"
	   "dimdot"
	   p1
	   ""
	   ""
	   ""
	   "ERASE"
	   (entlast)
	   ""
  )
  (command "dim"      "dimblk"	 "dimdot"   "dimasz"   "1.3"
	   "dimcen"   "-1"	 "dimdle"   "2"	       "dimdli"
	   "8"	      "dimexe"	 "2"	    "dimexo"   "2"
	   "dimlfac"  "1"	 "dimtad"   "on"       "dimtih"
	   "off"      "dimtix"	 "on"	    "dimtm"    "0"
	   "dimtofl"  "off"	 "dimtoh"   "on"       "dimtol"
	   "off"      "dimtxt"	 "2.5"	    "dimse1"   "off"
	   "dimse2"   "off"	 "dimaso"   "on"       "dimclre"
	   "bylayer"  "dimclrd"	 "bylayer"  "dimclrt"  "bylayer"
	   "dimtofl"  "on"	 "exit"
	  )
  (setq dsc (getvar "DIMSCALE"))
  (prompt "\n\t Dimension scale's ? <")
  (prin1 dsc)
  (setq dsc1 (getreal "> : "))
  (if (or (= dsc1 nil) (= dsc1 ""))
    (setq dsc2 dsc)
    (setq dsc2 dsc1)
  )
  (setvar "dimscale" dsc2)
)

(defun C:DIMension () (DIMENSION))
(defun C:DIMS () (DIMENSION) (C:UPD))
(defun C:HOR () (command "DIM1" "HOR") (prin1))
(defun C:VER () (command "DIM1" "VER") (prin1))
(defun C:UPD () (command "DIM1" "UPD") (prin1))
(defun C:BAS () (command "DIM1" "BAS") (prin1))
					;(defun C:CON()(command "DIM" "CON" )(prin1))
(defun C:DTT () (command "DIM1" "NEW") (prin1))
(DEFUN C:CON (/ p1)
  (setq xx 1)
  (while xx
    (setq p1 (getpoint "\n Pick Continuous Next-Point ? :"))
    (if	p1
      (command "dim" "con" p1 "")
      (PROGN (COMMAND "E") (setq xx nil))
    )
					;    (command "")
  )
)
					;-----------------------
;(defun C:IWB (/ na)
;  (command ".qsave")
;					;   (command ".qsave")
;  (setq NA (GETVAR "DWGNAME"))
;  (prompt "\n* End & Purge to [")
;  (PRIN1 NA)
;  (prompt "] !")
;  (command "WBLOCK" NA "Y" "*" "OPEN" "Y" "~")
;)

;(defun C:IWB2 (/ na a)
;  (textscr)
;  (prompt
;    "\n !!! Warning !!! Warning !!! Warning !!! Warning !!! Warning !!! 2002에선 쓰지마!!"
;  )
;  (prompt
;    "\n !!! Warning !!! Warning !!! Warning !!! Warning !!! Warning !!! 2002에선 쓰지마!!"
;  )
;  (prompt
;    "\n !!! Warning !!! Warning !!! Warning !!! Warning !!! Warning !!! 2002에선 쓰지마!!"
;  )
;  (prompt
;    "\n !!! 경고 !!! 경고 !!! 경고 !!! 안보이는건 모두가 삭제된다 !!! 2002에선 쓰지마!!"
;  )
;  (prompt
;    "\n !!! 경고 !!! 경고 !!! 경고 !!! 안보이는건 모두가 삭제된다 !!! 2002에선 쓰지마!!"
;  )
;  (prompt
;    "\n !!! 경고 !!! 경고 !!! 경고 !!! 안보이는건 모두가 삭제된다 !!! 2002에선 쓰지마!!"
;  )
;  (prompt
;    "\n This Command is Only viewing-object Saving=>Clocking object as erase 2002에선 쓰지마!!"
;  )
;  (prompt
;    "\n This Command is Only viewing-object Saving=>Clocking object as erase 2002에선 쓰지마!!"
;  )
;  (prompt
;    "\n This Command is Only viewing-object Saving=>Clocking object as erase 2002에선 쓰지마!!"
;  )
;  (setq a (getvar "cmdecho"))
;  (setvar "cmdecho" 0)
;  (initget "Yes No")
;  (if (= (getkword "\n Purge the drawing session ?  Yes/No: ")
;	 "Yes"
;      )
;    (progn
;      (command ".qsave")
;					;(command ".qsave")
;      (command "LAYER" "U" "*" "")
;      (command "zoom" "e")
;      (setq p1 (getvar "EXTMIN"))
;      (setq p2 (getvar "EXTMAX"))
;      (setq NA (GETVAR "DWGNAME"))
;      (prompt "\n* End & Purge to [")
;      (PRIN1 NA)
;      (prompt "] !")
;      (command "WBLOCK"	NA "Y" "" "0,0"	"c" p1 p2 "" "OPEN" "Y"	"~")
;    )
;    (princ "\n [Yes] is Purge to drawing session.")
;  )
;  (if a
;    (setvar "cmdecho" a)
;  )
;  (princ)
;)


;;-----------------------------------------------------------------------
;; READ-LINE

(defun C:RC ()
  (prompt " = Lead-Line (Tick+Cir) - 1")
  (lead-l 0 1 "A")
)
(defun C:RC2 ()
  (prompt " = Lead-Line (Tick+Cir) - 2")
  (lead-l 0 2 "A")
)
(defun C:RR ()
  (prompt " = Lead-Line (Room) - 1")
  (lead-l 0 1 "C")
)
(defun C:RR2 ()
  (prompt " = Lead-Line (Room) - 2")
  (lead-l 0 2 "C")
)
(defun C:RE ()
  (prompt " = Lead-Line (Tick) - 1")
  (lead-l 0 1 "T")
)
(defun C:RE2 ()
  (prompt " = Lead-Line (Tick) - 2")
  (lead-l 0 2 "T")
)
(defun C:RE3 ()
  (prompt " = Lead-Line (Tick) - @60")
  (lead-l 60 2 "T")
)
(defun C:RE4 ()
  (prompt " = Lead-Line (Tick) - @30")
  (lead-l 30 2 "T")
)
(defun C:RE5 ()
  (prompt " = Lead-Line (Tick) - @45")
  (lead-l 45 2 "T")
)

;;----------------------------------------------------------------------
(defun lead-l (a_k p_k e_k / stp po1 po2 po3 ang olds c_layer)
  (setq	olderr	*error*
	*error*	reerror
	chm	0
  )
  (old-non)
  (snap-ro)
  (IF (= ARD NIL)
    (setq ARD (GETVAR "LTSCALE"))
  )
  (setq STP (GETPOINT "\nPick Point of START (none) : "))
  (setq PO1 (GETPOINT STP "\nPick Point of SECOND (none) : "))
  (grdraw stp po1 133)
  (setq trr nil)
  (cond
    ((= p_k 1) (setq trr 1))
    ((= p_k 2) (setvar "SNAPANG" (dtr a_k)))
  )
  (if (= trr nil)
    (setq PO2 (GETPOINT PO1 "\nPick Point of END (none) : "))
  )
  (SETVAR "SNAPANG" (DTR 0))
  (if po2
    (progn (cond ((= e_k "T") (re_draw_t 2))
		 ((= e_k "A") (re_draw_a 2))
		 ((= e_k "C") (re_draw_c 2))
	   )
    )
    (progn (cond ((= e_k "T") (re_draw_t 1))
		 ((= e_k "A") (re_draw_a 1))
		 ((= e_k "C") (re_draw_c 1))
	   )
    )
  )
  (new-sn)
)

(defun re_draw_a (a)
  (la-set "E-100" 4)
  (setq RAD (GETVAR "LTSCALE"))
  (setq RAD (/ RAD 2))
  (if (= a 2)
    (progn
      (setq ANG (ANGLE PO1 PO2))
      (setq PO3 (POLAR PO2 (- ANG (dtr 180)) (* 2 ARD)))
      (command "PLINE" STP PO1 PO3 "W" (* ARD 0.8) "0" PO2 "")
      (command "CIRCLE" STP RAD)
    )
    (progn
      (setq ANG (ANGLE STP PO1))
      (setq PO2 (POLAR PO1 (- ANG (dtr 180)) (* 2 ARD)))
      (command "PLINE" STP PO2 "W" (* ARD 0.8) "0" PO1 "")
      (command "CIRCLE" STP RAD)
    )
  )
  (la-back)
)

(defun re_draw_t (a)
  (la-set "E-100" 4)
  (if (= a 2)
    (progn
      (setq ANG (ANGLE PO1 PO2))
      (setq PO3 (POLAR PO2 (- ANG (dtr 180)) (* 2 ARD)))
      (command "PLINE" STP PO1 PO3 "W" (* ARD 0.8) "0" PO2 "")
    )
    (progn
      (setq ANG (ANGLE STP PO1))
      (setq PO2 (POLAR PO1 (- ANG (dtr 180)) (* 2 ARD)))
      (command "PLINE" STP PO2 "W" (* ARD 0.8) "0" PO1 "")
    )
  )
  (la-back)
)

(defun re_draw_c (a)
  (la-set "E-100" 4)
  (setq RAD (GETVAR "LTSCALE"))
  (setq RAD (/ RAD 2))
  (if (= a 2)
    (progn
      (setq ANG (ANGLE PO1 PO2))
      (command "PLINE" STP PO1 PO2 "" "CIRCLE" PO2 RAD)
    )
    (progn
      (setq ANG (ANGLE STP PO1))
      (command "LINE" STP PO1 "" "CIRCLE" PO1 RAD)
    )
  )
  (la-back)
)

;;----------------------------------------------------------------------

(defun C:PB (/ p1 p2 p3 p4 XXXX YYYY)
  (setq	olderr	*error*
	*error*	myerror
	chm	0
  )
  (graphscr)
  (old-non)
  (if (= len-x nil)
    (setq len-x 300.0)
  )
  (prompt "\n\t Enter PULL-BOX size? (Horigental) <")
  (PRIN1 LEN-X)
  (setq XXXX (getdist "> : "))
  (IF XXXX
    (setq LEN-X XXXX)
  )
  (prompt "\n\t Enter PULL-BOX size? (Vertical) : <")
  (prin1 LEN-X)
  (setq YYYY (getdist "> : "))
  (if YYYY
    (setq len-y YYYY)
    (setq LEN-Y LEN-X)
  )
  (setq p1 (getpoint "\n\t Enter POINT? (none) : "))
  (setq p2 (list (car p1) (+ (cadr p1) len-y)))
  (setq p4 (list (+ (car p1) len-x) (cadr p1)))
  (setq p3 (list (car p4) (cadr p2)))
  (SETVAR "CMDECHO" 0)
  (command "pline" p1 p2 p3 p4 "c" "color" "bylayer")
  (NEW-SN)
)

(defun C:PX (/ p1 p2 p3 p4 XXXX YYYY)
  (setq	olderr	*error*
	*error*	myerror
	chm	0
  )
  (graphscr)
  (old-non)
  (if (= len-x nil)
    (setq len-x 300.0)
  )
  (prompt "\n\t Enter PULL-BOX size? (Horigental) <")
  (PRIN1 LEN-X)
  (setq XXXX (getdist "> : "))
  (IF XXXX
    (setq LEN-X XXXX)
  )
  (prompt "\n\t Enter PULL-BOX size? (Vertical) : <")
  (prin1 LEN-X)
  (setq YYYY (getdist "> : "))
  (if YYYY
    (setq len-y YYYY)
    (setq LEN-Y LEN-X)
  )
  (setq p1 (getpoint "\n\t Enter POINT? (none) : "))
  (setq p2 (list (car p1) (+ (cadr p1) len-y)))
  (setq p4 (list (+ (car p1) len-x) (cadr p1)))
  (setq p3 (list (car p4) (cadr p2)))
  (SETVAR "CMDECHO" 0)
  (command "pline" p1 p2 p3 p4 p1 p3 p4	p2 "" "color" "bylayer")
  (NEW-SN)
)
;;;-------------------------------------------------------------------------

(defun C:D (/ po1 po2 dis ang)
					;(old-non)
  (setq	po1 (getpoint "\n Enter First Point : ")
	po2 (getpoint po1 ", Enter Second Point : ")
  )
  (setq	dis (distance po1 po2)
	ang (rtd (angle po1 po2))
  )
  (prompt "\n Distance = [")
  (prin1 dis)
  (prompt "], ")
  (prompt "Angle = [")
  (prin1 ang)
  (prompt "] ")
  (prin1)
)

;;;-------------------------------------------------------------------------

(defun C:ME (/ a aname olds)
  (setq	olderr	*error*
	*error*	myerror
	chm	0
  )
  (setq a (entsel))
  (IF (OR (= BLNAME "") (= BLNAME NIL))
    (setq blname "IL60")
  )
  (prompt "\n Divide Block Name ([.] is Points) ? <")
  (prin1 blname)
  (setq aname (getstring "> : "))
  (if (/= aname ".")
    (progn
      (if (/= aname "")
	(setq blname (strcase aname))
      )
      (prompt "\n ** Enter Block-distance ? : ")
      (command "MEASURE" a "Block" blname "Y" pause)
    )
    (progn
      (prompt "\n ** Enter Distance ? : ")
      (command "MEASURE" a pause)
    )
  )
)

;;---------------------------------------------------------------------------

(defun C:DV (/ a aname olds wd_1 wd-no)
  (setq	olderr	*error*
	*error*	myerror
	chm	0
  )
  (setq a (entsel))
  (if (= blname nil)
    (setq blname "IL60")
  )
  (prompt "\n Divide Block Name ([.] is Points) ? <")
  (prin1 blname)
  (setq aname (getstring "> : "))
  (if (/= aname ".")
    (progn
      (if (/= aname "")
	(setq blname (strcase aname))
      )
      (setq wd-no (getint "\n ** Enter number of segupment ? : "))
      (command "DIVIDE" a "Block" blname "Y" wd-no)
      (setq po1 (cdr (assoc 10 (setq list2 (entget (car a))))))
      (setq po2 (cdr (assoc 11 list2)))
      (setq wd_1 (/ (distance po1 po2) wd-no))
      (prompt "\t Witdh is = ")
      (prin1 wd_1)
      (prompt " *")
      (prin1)
    )
    (progn
      (setvar "pdmode" 3)
      (setvar "pdsize" -3)
      (prompt "\n ** Enter number of segupment ? : ")
      (command "DIVIDE" a pause)
      (prin1)
      (setvar "pdmode" 0)
      (setvar "pdsize" 0)
    )
  )
)

					;---------------
(defun C:UNIT () (command "UNITS" "2" "0" "1" "4" "0" "N"))

;;;;------------------------------------------------------------------------


(defun C:BF (/ a)
  (prompt "\n Break command : First point option is \"INT\"")
  (setq a (entsel))
  (if a
    (command "BREAK" a "F" "INT" pause pause)
  )
)

(defun C:BI (/ a)
  (prompt
    "\n Break command : Second point is Same at First point : option is \"INT\""
  )
  (setq A (entsel))
  (if A
    (command "BREAK" A "F" "INT" pause (GETVAR "LASTPOINT"))
  )
)

(defun C:BBB (/ p1 p2 p3 a)
  (if (or (= bb-w nil) (= bb-w 0))
    (setq bb-w 150)
  )
  (prompt " Break command : Block-side (ex:E-L,G-L....)")
  (prompt "\n Width is [")
  (prin1 bb-w)
  (prompt "].. change is \"(BBW)\" ")
  (setq A (entsel))
  (old-ins)
  (setq p1 (getpoint "Enter BREAK Point ? (Insert-point) : "))
  (SETVAR "OSMODE" 0)
  (setq p2 (list (+ (car p1) bb-w) (cadr p1)))
  (setq p3 (list (- (car p1) bb-w) (cadr p1)))
  (if A
    (command "BREAK" A "F" p2 p3)
  )
  (new-sn)
)

(defun bbw ()
  (setq bb-w (getreal "\n Enter [C:BBB] width is ?"))
)

;;---------------------------------------------------------------------------
(defun chg-col (key)
  (prompt "\n Change Color command : ")
  (cond
    ((= key 1) (setq key "Red"))
    ((= key 2) (setq key "Yellow"))
    ((= key 3) (setq key "Green"))
    ((= key 4) (setq key "Cyan"))
    ((= key 5) (setq key "Blue"))
    ((= key 6) (setq key "Magenta"))
    ((= key 7) (setq key "White"))
  )
  (prompt " Select Objetct for Change-Color as [")
  (prin1 key)
  (prompt "]")
  (setq A (SSGET))
  (command "CHPROP" A "" "C" key "")
)

(defun C:C21 (/ a) (chg-col 21))
(defun C:C31 (/ a) (chg-col 31))
(defun C:C41 (/ a) (chg-col 41))
(defun C:C51 (/ a) (chg-col 51))
(defun C:C61 (/ a) (chg-col 61))
(defun C:C121 (/ a) (chg-col 121))
(defun C:C131 (/ a) (chg-col 131))
(defun C:C141 (/ a) (chg-col 141))
(defun C:C151 (/ a) (chg-col 151))
(defun C:C161 (/ a) (chg-col 161))
(defun C:C171 (/ a) (chg-col 171))
(defun C:C181 (/ a) (chg-col 181))
(defun C:C191 (/ a) (chg-col 191))
(defun C:C221 (/ a) (chg-col 221))
(defun C:C254 (/ a) (chg-col 254))
(defun C:C1 (/ a) (chg-col 1))
(defun C:C1 (/ a) (chg-col 1))
(defun C:C1 (/ a) (chg-col 1))
(defun C:C1 (/ a) (chg-col 1))
(defun C:C1 (/ a) (chg-col 1))
(defun C:C2 (/ a) (chg-col 2))
(defun C:C3 (/ a) (chg-col 3))
(defun C:C4 (/ a) (chg-col 4))
(defun C:C5 (/ a) (chg-col 5))
(defun C:C6 (/ a) (chg-col 6))
(defun C:C7 (/ a) (chg-col 7))
(defun C:C8 (/ a) (chg-col 8))
(defun C:C9 (/ a) (chg-col 9))
(defun C:C10 (/ a) (chg-col 10))
(defun C:C11 (/ a) (chg-col 11))
(defun C:C12 (/ a) (chg-col 12))
(defun C:C13 (/ a) (chg-col 13))
(defun C:C14 (/ a) (chg-col 14))
(defun C:C15 (/ a) (chg-col 15))
(defun C:C101 (/ a) (chg-col 101))
(defun C:C41 (/ a) (chg-col 41))

(defun C:COO (/ a)
  (prompt "\n Change Color command : ")
  (setq a (ssget))
  (if a
    (progn
      (initget (+ 1 2 4))
      (setq co-no (getint "\n Enter you want color number ? :"))
      (command "CHPROP" A "" "C" co-no "")
    )
  )
)

					;---------------

					; Pline Editing (width)
(defun C:PW (/ a l-pl p-w)
  (prompt "\n LWPOLYLINE's Width Setting command :")
  (IF (= PL-WD NIL)
    (prompt "\n Current Width is \"0\" ! ")
    (PROGN
      (prompt "\n Current Width is [")
      (PRIN1 PL-WD)
      (prompt "] ... If You Change Width to \"command:PWL\" ")
    )
  )
  (setq A (ENTSEL))
  (setq L-PL (CDR (ASSOC 0 (ENTGET (CAR A)))))
  (if (= pl-wd nil)
    (if	a
      (setq p-w (getreal "\n Enter Poly-line's Width ? "))
    )
    (setq p-w pl-wd)
  )
  (setq pl-wd p-w)
  (if p-w
    (IF	(= L-PL "LWPOLYLINE")
      (command "PEDIT" A "W" p-w "X")
      (command "PEDIT" A "" "W" p-w "X")
    )
  )
)

(defun C:PWL () (setq pl-wd nil) (C:PW))
(defun C:PWWL () (setq pl-wd nil) (C:PWW))

(defun C:PWW (/ E1 E2 ED NL N I l-pl p-w)
  (prompt "\n LWPOLYLINE's Width Setting command :")
  (IF (= PL-WD NIL)
    (prompt "\n Current Width is \"0\" ! ")
    (PROGN
      (prompt "\n Current Width is [")
      (PRIN1 PL-WD)
      (prompt "] ... If You Change Width to \"command:PWWL\" ")
    )
  )
  (setq i 0)
  (setq e1 (ssget))
  (if e1
    (progn
      (setq nl (sslength e1))
      (setq n (- nl 1))
      (while (<= i n)
	(setq ed (entget (setq e2 (ssname e1 i))))
	(setq L-PL (cdr (assoc 0 ed)))
	(if (= pl-wd nil)
	  (if a
	    (setq p-w (getreal "\n Enter Poly-line's Width ? "))
	  )
	  (setq p-w pl-wd)
	)
	(setq pl-wd p-w)
	(if p-w
	  (IF (= L-PL "LWPOLYLINE")
	    (command "PEDIT" E2 "W" p-w "X")
	    (command "PEDIT" E2 "" "W" p-w "X")
	  )
	)
	(setq I (+ 1 I))
      )
    )
  )
)

					; Pline Editing (Close)
(defun C:PJ (/ a l-pl kk)
  (prompt "\n Line's or Pline's Joint command :")
  (prompt "\n Select the Base [Line] or [Pline] : ")
  (setq A (ENTSEL))
  (setq L-PL (CDR (ASSOC 0 (ENTGET (CAR A)))))
  (prompt "\n Select the Other [Line's] or [Pline's] : ")
  (setq KK (SSGET))
  (IF (= L-PL "LWPOLYLINE")
    (command "PEDIT" A "J" KK "" "X")
    (command "PEDIT" A "" "J" KK "" "X")
  )
)

(defun C:PJ2 (/ a l-pl kk)
  (prompt "\n Line's or Pline's Joint command :")
  (prompt "\n Select the Base [Line] or [Pline] : ")
  (setq A (ENTSEL))
  (setq L-PL (CDR (ASSOC 0 (ENTGET (CAR A)))))
  (prompt "\n Select the Other [Line's] or [Pline's] : ")
  (setq KK (SSGET))
  (IF (= L-PL "LWPOLYLINE")
    (command "PEDIT" A "J" KK "" "X")
    (command "PEDIT" A "" "J" KK "" "X")
  )
  (command "chprop" "L" "" "layer" "100" "c" "byl" "")
)

					; Pline Editing (Spline)
(defun C:PeS (/ a)
  (prompt "\n Pline Corve command :")
  (setq a (entsel "\n Select Pline to Spline Corve : "))
  (command "pedit" a "s" "x")
)

;;; MOVE & COPY

(defun C:MM (/ a p1 p2 p3 MMK olds)
  (prompt "\n Extended Move command :")
  (setq	olderr	*error*
	*error*	myerror
	chm	0
  )

  (old-sn)
  (snap-ro)

  (if (= m_dis nil)
    (setq m_dis 25)
  )
  (prompt "\n Select the MOVING target <")
  (prin1 m_dis)
  (prompt "> ? : ")
  (setq a (ssget))
  (if (= a nil)
    (progn
      (prompt "\n Enter moving DISTANCE ? : <")
      (PRIN1 M_DIS)
      (setq MMK (GETDIST "> ? : "))
      (IF MMK
	(setq M_DIS MMK)
	(setq M_DIS M_DIS)
      )
    )
    (progn
      (setq p1 (getpoint "\n Start Ponit ? (none) : "))
      (setq p2 (getpoint p1 "\n To point ? (none) : "))
      (setq p3 (polar p1 (angle p1 p2) m_dis))
      (command "move" a "" p1 p3)
    )
  )
  (new-sn)
)

					;-------------------------------------------------------------------------
(defun C:MM1 () (mes-mm) (MOVEXX 1))
(defun C:MM2 () (mes-mm) (MOVEXX 2))
(defun C:MM3 () (mes-mm) (MOVEXX 3))
(defun C:MM4 () (mes-mm) (MOVEXX 4))
(defun C:MM5 () (mes-mm) (MOVEXX 5))
(defun C:MM6 () (mes-mm) (MOVEXX 6))
(defun C:MM7 () (mes-mm) (MOVEXX 7))
(defun C:MM8 () (mes-mm) (MOVEXX 8))
(defun C:MM9 () (mes-mm) (MOVEXX 9))
(defun C:MM10 () (mes-mm) (MOVEXX 10))
(defun C:MM15 () (mes-mm) (MOVEXX 15))
(defun C:MM20 () (mes-mm) (MOVEXX 20))
(defun C:MM25 () (mes-mm) (MOVEXX 25))
(defun C:MM30 () (mes-mm) (MOVEXX 30))
(defun C:MM40 () (mes-mm) (MOVEXX 40))
(defun C:MM50 () (mes-mm) (MOVEXX 50))
(defun C:MM60 () (mes-mm) (MOVEXX 60))
(defun C:MM70 () (mes-mm) (MOVEXX 70))
(defun C:MM80 () (mes-mm) (MOVEXX 80))
(defun C:MM30 () (mes-mm) (MOVEXX 30))
(defun C:MM30 () (mes-mm) (MOVEXX 30))
(defun C:MM30 () (mes-mm) (MOVEXX 30))

(defun mes-mm () (prompt "\n Extended Move command :"))

(defun movexx (xx / a p1 p2 p3 MMK olds)
  (setq	olderr	*error*
	*error*	myerror
	chm	0
  )
  (old-sn)
  (snap-ro)
  (setq m_dis (* 100 xx))
  (prompt "\n Select the MOVING target <")
  (prin1 m_dis)
  (prompt "> ? : ")
  (setq a (ssget))
  (if a
    (progn
      (setq p1 (getpoint "\n Start Ponit ? (none) : "))
      (setq p2 (getpoint p1 "\n To point ? (none) : "))
      (setq p3 (polar p1 (angle p1 p2) m_dis))
      (command "move" a "" p1 p3)
    )
    (prompt "\n !!! Select was Not Found !!! ")
  )
  (new-sn)
)

(defun C:M2 (/ m_dis2 a p1 p2 p3 olds)
  (prompt "\n Extended Move command : Distance is (Offset/2) "
  )
  (setq m_dis2 (/ (getvar "offsetdist") 2))
  (setq xx (/ m_dis2 100))
  (movexx xx)
)

(defun C:M3 (/ m_dis3 a p1 p2 p3 olds)
  (prompt
    "\n Extended Move command : Distance is (Multiple-Copy/2) "
  )
  (if (= c_dis nil)
    (setq c_dis 2000)
  )
  (setq m_dis3 (/ c_dis 2))
  (setq xx (/ m_dis3 100))
  (movexx xx)
)

					;-------------------------------------------------------------------------
(defun C:MC1 () (mes-mc) (COPYXX 1))
(defun C:MC2 () (mes-mc) (COPYXX 2))
(defun C:MC3 () (mes-mc) (COPYXX 3))
(defun C:MC4 () (mes-mc) (COPYXX 4))
(defun C:MC5 () (mes-mc) (COPYXX 5))
(defun C:MC6 () (mes-mc) (COPYXX 6))
(defun C:MC7 () (mes-mc) (COPYXX 7))
(defun C:MC8 () (mes-mc) (COPYXX 8))
(defun C:MC9 () (mes-mc) (COPYXX 9))
(defun C:MC10 () (mes-mc) (COPYXX 10))
(defun C:MC15 () (mes-mc) (COPYXX 15))
(defun C:MC20 () (mes-mc) (COPYXX 20))
(defun C:MC25 () (mes-mc) (COPYXX 25))
(defun C:MC30 () (mes-mc) (COPYXX 30))
(defun C:MC40 () (mes-mc) (COPYXX 40))
(defun C:MC50 () (mes-mc) (COPYXX 50))
(defun C:MC60 () (mes-mc) (COPYXX 60))
(defun C:MC70 () (mes-mc) (COPYXX 70))
(defun C:MC80 () (mes-mc) (COPYXX 80))

(defun mes-mc () (prompt "\n Multiple Copy command :"))

(defun copyxx (xx / a p1 p2 p3 MMK olds)
  (setq	olderr	*error*
	*error*	myerror
	chm	0
  )
  (old-sn)
  (snap-ro)
  (setq m_dis (* 100 xx))
  (prompt "\n Select the COPY target <")
  (prin1 m_dis)
  (prompt "> ? : ")
  (setq a (ssget))
  (if a
    (progn
      (setq aa 1)
      (setq p1 (getpoint "\n Start Ponit ? (none) : "))
      (setq p2 (getpoint p1 "\n To point ? (none) : "))
      (setq mc-ang (angle p1 p2))
      (setq pc-pnt (polar p1 mc-ang (* m_dis aa)))
      (command "copy" a "" p1 pc-pnt)	;(polar p1 mc-ang (* m_dis a)))
      (while a
	(setq p3 (getpoint p1 "\n Next ? : "))
	(if p3
	  (progn
	    (setq aa (1+ aa))
	    (setq pc-pnt (polar p1 mc-ang (* m_dis aa)))
	    (command "copy" a "" p1 pc-pnt)
	  )
	  (setq a nil)
	)
      )
    )
    (prompt "\n !!! Select was Not Found !!! ")
  )
  (new-sn)
)
					;---------------
(defun C:MC (/ a i ddd olds)
  (prompt "\n Multiple Copy command :")
  (setq	olderr	*error*
	*error*	myerror
	chm	0
  )

  (snap-ro)
  (old-sn)

  (IF (= C_DIS NIL)
    (setq C_DIS 2000)
  )
  (prompt "\n Select the Multiple-Copy target <D=")
  (prin1 c_dis)
  (prompt "> ? : ")
  (setq a (ssget))
  (command "undo" "group")
  (if (= a nil)
    (progn
      (prompt "\n Enter coping DISTANCE <")
      (prin1 c_dis)
      (setq ddd (getdist "> ? : "))
      (if ddd
	(setq c_dis ddd)
      )
      (prompt "\n Select the COPYNG target ? : ")
      (setq a (ssget))
      (if a
	(copy_m a c_dis)
      )
    )
    (copy_m a c_dis)
  )
  (command "undo" "end")
  (new-sn)
)

					;---------------
(defun copy_m (sel dist1 / p1 p2 p3 count dist2)
  (setq p1 (getpoint "\n Start Ponit ? (none) : "))
  (setq	count 1
	dist2 dist1
  )
  (while p1
    (if	(setq p2 (getpoint p1 "\n To point ? (none) : "))
      (progn
	(setq p3 (polar p1 (angle p1 p2) dist2))
	(command "copy" sel "" p1 p3)
	(setq count (1+ count))
	(setq dist2 (* count dist1))
      )
      (setq p1 nil)
    )
  )
)

;;;;-------------------------------------------------------------------------
(defun C:BNAME (/ ENTTY LIST1 LIST2 B-NAME P1)
  (setq ENTTY (ENTSEL))
  (if entty
    (setq list1 (cdr (assoc 0 (setq list2 (entget (car entty))))))
  )
  (IF (= LIST1 "INSERT")
    (PROGN
      (prompt "[name=")
      (setq B-NAME (prin1 (li_find 2 LIST2)))
      (prompt "]")
      (setq P1 (GETPOINT))
      (command "TEXT" P1 "" "" B-NAME)
    )
  )
)
;;;-------------------------------------------------------------------------


;;;-------------------------------------------------------------------------
					;(defun C:II(/ po1 b-n )
					;   (setq b-n(getstring "\n Enter INSERT BOLCK NAME ? : "))
					;   (while b-n
					;      (prompt "\n Block Name is [")(prin1 b-n)(prompt "] ")
					;      (setq po1 (getpoint "-- Insert Point ? : "))
					;      (command "insert" b-n po1 "" "" "")
					;   )
					;)

;;;;---------------- Tow Point Pointing.

					;--------- Line to Line's Intersect Point
(defun n2i (/ tag1 tag2 p1 p2 p3 p4 p5)
  (prompt "\n\t Point at Line by Line Int-point : ")
  (setq	olderr	*error*
	*error*	myerror
	chm	0
  )
  (setq tag1 (entsel "\t Select First line : "))
  (setq tag2 (entsel "\n Select other Line : \n"))
  (if tag1
    (progn
      (old-non)
      (setq p1 (cdr (assoc 10 (entget (car tag1)))))
      (setq p2 (cdr (assoc 11 (entget (car tag1)))))
      (setq p3 (cdr (assoc 10 (entget (car tag2)))))
      (setq p4 (cdr (assoc 11 (entget (car tag2)))))
      (setq p5 (inters p1 p2 p3 p4 nil))
      (new-sn)
      (setvar "LASTPOINT" p5)
    )
  )
)

(defun c:3 () (n2i))
(defun c:mil ()
  (n2i)
  (prin1)
  (command "line" (getvar "lastpoint"))
)

					;--------- Line to Line's Middle Point
(defun n2 (/ p1 p2 ang dts)
  (old-endint)
;  (ai_sysvar '(("osmode" . 33)("cmdecho" . 0)))
  (setq p1 (getpoint "\First point (end+int) : "))
  (setq p2 (getpoint p1 "\Second point (end+int) : "))
;  (grdraw p1 p2 133)
  (setq ang (angle p1 p2))
  (setq dts (/ (distance p1 p2) 2))
  (SETVAR "OSMODE" 0)
  (setvar "LASTPOINT" (setq p3 (polar p1 ang dts)))
  (prin1 p3)
  (new-sn)(prin1)
;  (ai_sysvar nil)
)

(defun C:2 ()
  (n2)
  (getvar "lastpoint")
)

(defun C:ML ()
  (n2)
;  (command "line" n2_po)
  (command "line" (getvar "LASTPOINT"))
)

;;--------- Circle to Circle's Middle Point
					;(defun nc2 (/ p1 p2 ang dts)
					;  (old-cen)
					;  (setq p1 (getpoint " First point (center) : "))
					;  (setq p2 (getpoint " Second point (center) : "))
					;  (setq ang (angle p1 p2))
					;  (setq dts (/ (distance p1 p2) 2))
					;  (new-sn)
					;  (setvar "lastPOINT" (polar p1 ang dts))
					;)

					;(defun C:NC2()(nc2))
					;(defun C:CP2()(nc2))
					;(defun C:MCL()(nc2)(prin1)(command "line" (getvar "lastpoint")))

(defun C:CI2 ()
  (OLD-ENDINT)
  (command "circle" "2P" PAUSE PAUSE)
  (NEW-SN)
)

;;;;----------------------------------------------------------------------
;;;;------------------ Block or Symbol Insert comment.--------------------
;;;;----------------------------------------------------------------------

;;;-----------------Wiring Work------------------------------------------

					;(if (or (= wire-scale "0.0") (= wire-scale nil))
					;   (setq wire-scale(/ (getvar "LTSCALE") 100))
					;)

					;(defun C:W-SC(/ w1 w2 w3 w4)
					;   (setq w1 wire-scale w2 dwg-scale)
					;   (if (or (= w1 0)(= w1 nil))(setq w3 w2)(setq w3 w1))
					;   (prompt "\n Wire Scale is [")(prin1 w3)
					;   (setq w4(GETREAL "] Enter New Wire-scale ? :"))
					;   (IF (or (= w4 "")(= w4 nil))(setq wire-scale w3)(setq wire-scale w4))
					;   (setvar "USERR3" wire-scale)(prin1))
					;   (setq wire-scale (getvar "userr3"))
					;   (if (or (= wire-scale 0) (= wire-scale nil))
					;   (setq wire-scale dwg-scale))

(setq dwg-scale (/ (getvar "LTSCALE") 100))

					;----------------
(defun in-wi (a)
  (if (or (= wire-scale 0.0) (= wire-sacle 0))
    (prompt
      "\n [wire-scale] is Nothing => First Running command [DWGS]"
    )
    (progn
      (prompt "\n Now Wire-Scale is [")
      (prin1 wire-scale)
      (prompt "] If You Change Scale to Run --> [DWGS]")
      (prompt "\n Pick the Insert Point for [")
      (prin1 a)
      (prompt "] : ")
      (command ".insert" a pause wire-scale "")
      (command "'setvar" "osmode" 0)
      (command pause)
    )
  )
)

(defun ossxx () (setvar "OSMODE" 0) (prin1))
					;----------------
(defun C:CT (/ OLDS) (old-endint) (in-wi "CCT-F") (new-sn))

(defun C:11 ()
  (command ".insert" "LEAD11" "nea" pause wire-scale "")
)
(defun C:12 ()
  (command ".insert" "LEAD12" "nea" pause wire-scale "")
)
(defun C:13 ()
  (command ".insert" "LEAD13" "nea" pause wire-scale "")
)
(defun C:14 ()
  (command ".insert" "LEAD14" "nea" pause wire-scale "")
)

(defun C:21 ()
  (command ".insert" "LEAD21" "nea" pause wire-scale "")
)
(defun C:22 ()
  (command ".insert" "LEAD22" "nea" pause wire-scale "")
)
(defun C:23 ()
  (command ".insert" "LEAD23" "nea" pause wire-scale "")
)
(defun C:24 ()
  (command ".insert" "LEAD24" "nea" pause wire-scale "")
)

					;(defun C:I1(/ bl-name)
					;  (setq bl-name (getstring "\n What's the Block Name ? : "))
					;  (command ".insert" bl-name pause "" "" pause))

;;=========================================================================
					;----------------
(defun in-wi2 (a)
  (if (or (= line-work "Other") (= line-work nil))
    (progn
      (prompt "\n Wiring-Work at [Tel,Tv,Fir,Spk..] => C:LWW")
      (in-wi a)
    )
    (progn
      (prompt "\n Wiring-Work at [Light,Recep] => C:LWW")
      (setvar "OSMODE" 2)
      (in-wi a)
    )
  )
)

(setq line-work nil)

(defun c:lww () (line-ww jlww))

(defun line-ww (jlww / a)
  (if jlww
    (if	(= jlww 1)
      (setq line-work "Light")
      (setq line-work "Other")
    )
    (progn
      (prompt
	"\n Enter Line's Wiring-Work Style? : Light(MIDp)/Other(NEAp) <"
      )
      (prin1 line-work)
      (initget "Light Other")
      (setq a (getkword "> ? :"))
      (cond
	((= a "Light") (setq line-work "Light"))
	((= a "Other") (setq line-work "Other"))
	(T (prompt "\n Not Changed"))
      )
    )
  )
  (setq jlww nil)
)

					;(defun C:W11(/ OLDS)(old-nea)(in-wi2 "WIRE-3")(new-sn))

					;----------------
(defun C:W1 (/ OLDS) (old-nea) (in-wi2 "WIRE-1") (new-sn))
(defun C:W2 (/ OLDS) (old-nea) (in-wi2 "WIRE-2") (new-sn))
(defun C:W3 (/ OLDS) (old-nea) (in-wi2 "WIRE-3") (new-sn))
(defun C:W4 (/ OLDS) (old-nea) (in-wi2 "WIRE-4") (new-sn))
(defun C:W5 (/ OLDS) (old-nea) (in-wi2 "WIRE-5") (new-sn))
(defun C:W6 (/ OLDS) (old-nea) (in-wi2 "WIRE-6") (new-sn))
(defun C:W7 (/ OLDS) (old-nea) (in-wi2 "WIRE-7") (new-sn))
(defun C:W8 (/ OLDS) (old-nea) (in-wi2 "WIRE-8") (new-sn))
(defun C:W9 (/ OLDS) (old-nea) (in-wi2 "WIRE-9") (new-sn))
(defun C:W10 (/ OLDS) (old-nea) (in-wi2 "WIRE-10") (new-sn))
(defun C:W11 (/ OLDS) (old-nea) (in-wi2 "WIRE-11") (new-sn))
(defun C:W12 (/ OLDS) (old-nea) (in-wi2 "WIRE-12") (new-sn))
(defun C:W13 (/ OLDS) (old-nea) (in-wi2 "WIRE-13") (new-sn))
(defun C:W14 (/ OLDS) (old-nea) (in-wi2 "WIRE-14") (new-sn))
(defun C:W15 (/ OLDS) (old-nea) (in-wi2 "WIRE-15") (new-sn))
(defun C:W16 (/ OLDS) (old-nea) (in-wi2 "WIRE-16") (new-sn))
(defun C:W17 (/ OLDS) (old-nea) (in-wi2 "WIRE-17") (new-sn))
(defun C:W18 (/ OLDS) (old-nea) (in-wi2 "WIRE-18") (new-sn))
(defun C:W19 (/ OLDS) (old-nea) (in-wi2 "WIRE-19") (new-sn))
(defun C:W20 (/ OLDS) (old-nea) (in-wi2 "WIRE-20") (new-sn))

					;----------------
(defun C:WH1 (/ OLDS) (old-nea) (in-wi2 "wire-h1") (new-sn))
(defun C:WH2 (/ OLDS) (old-nea) (in-wi2 "wire-h2") (new-sn))
(defun C:WH3 (/ OLDS) (old-nea) (in-wi2 "wire-h3") (new-sn))
(defun C:WH4 (/ OLDS) (old-nea) (in-wi2 "wire-h4") (new-sn))
(defun C:WH5 (/ OLDS) (old-nea) (in-wi2 "wire-h5") (new-sn))
(defun C:WH6 (/ OLDS) (old-nea) (in-wi2 "wire-h6") (new-sn))
(defun C:WH7 (/ OLDS) (old-nea) (in-wi2 "wire-h7") (new-sn))
(defun C:WH8 (/ OLDS) (old-nea) (in-wi2 "wire-h8") (new-sn))
					;(defun C:WH9(/ OLDS)(old-nea)(in-wi2 "wire-h9")(new-sn))
					;(defun C:WH10(/ OLDS)(old-nea)(in-wi2 "wire-h10")(new-sn))

					;----------------
(defun C:WR2 (/ OLDS) (old-nea) (in-wi2 "WIRE-r2") (new-sn))
(defun C:WR3 (/ OLDS) (old-nea) (in-wi2 "WIRE-r3") (new-sn))
(defun C:WR4 (/ OLDS) (old-nea) (in-wi2 "WIRE-r4") (new-sn))
(defun C:WR5 (/ OLDS) (old-nea) (in-wi2 "WIRE-r5") (new-sn))
(defun C:WR6 (/ OLDS) (old-nea) (in-wi2 "WIRE-r6") (new-sn))
(defun C:WR7 (/ OLDS) (old-nea) (in-wi2 "WIRE-r7") (new-sn))
(defun C:WR8 (/ OLDS) (old-nea) (in-wi2 "WIRE-r8") (new-sn))

;;==========================================================================

					;----------------
(defun C:ENDS (/ OLDS) (old-end) (in-wi "END") (new-sn))
(defun C:ENDD (/ OLDS) (old-int) (in-wi "ENDD") (new-sn))
(defun C:CL1 (/ OLDS) (old-NON) (in-wi "CL1") (new-sn))
(defun C:CR1 (/ OLDS) (old-NON) (in-wi "CR1") (new-sn))
(defun C:CR3 (/ OLDS) (old-NON) (in-wi "CR3") (new-sn))
(defun C:CE1 (/ OLDS) (old-NON) (in-wi "CE1") (new-sn))

					;---------------------------------------------------------------------------
					;----------------
(defun in-dw (a)
  (if (or (= dwg-scale 0) (= dwg-scale 0.0))
    (prompt
      "\n [dwg-scale] is Nothing ...
               \n First Running command [DWGS] "
    )
    (progn
      (prompt "\n Now Drawing-Scale is [")
      (prin1 dwg-scale)
      (prompt "] If You Change Scale to Run --> [DWGS]")
      (prompt "\n Pick the Insert Point for [")
      (prin1 a)
      (prompt "] (int) : ")
      (command ".insert" a pause dwg-scale "" "")
    )
  )
)

(defun in-dw2 (a)
  (if (or (= wire-scale 0.0) (= wire-sacle 0))
    (prompt
      "\n [wire-scale] is Nothing ...
               \n First Running command [DWGS]"
    )
    (progn
      (prompt "\n Now Wire-Scale is [")
      (prin1 wire-scale)
      (prompt "] If You Change Scale to Run --> [DWGS]")
      (prompt "\n Pick the Insert Point for [")
      (prin1 a)
      (prompt "] (int) : ")
      (command ".insert" a pause wire-scale "" "")
    )
  )
)

(defun C:LQ () (old-end) (in-dw "LQT") (new-sn))
(defun C:AB () (old-mid) (in-dw "ABC") (new-sn))

(defun C:LQQ () (old-end) (in-dw2 "LQT") (new-sn))
(defun C:ABB () (old-mid) (in-dw2 "ABC") (new-sn))


					;(defun C:CE1()(old-non)(in-dw "CE1")(new-sn))
					;(defun C:CL1()(old-non)(in-dw "CL1")(new-sn))
					;(defun C:CR1()(old-non)(in-dw "CR1")(new-sn))

;;------------------------------------------------------------------------
;;------------------------------------------------------------------------

;;;;---------------------------------------------------------------------

(defun C:LOAD (/ lla olds)
  (setq	olderr	*error*
	*error*	myerror
	chm	0
  )
  (if (= ln nil)
    (setq ln "ACAD")
  )
  (prompt (strcat "\n\n\t Enter the LISP name ? <" ln "> : =")
  )
  (setq lla (strcase (getstring)))
  (if (= lla "")
    (load ln)
    (progn (load lla) (setq ln lla))
  )
  (PRIN1)
)


;;;-------------------------- Hanger ------------------------------------

(defun C:HA1 (/ entty list1 list2)
  (command "undo" "group")
  (old-non)
  (setq hh2 nil)
  (setq entty (entsel "\nSelect object <Line=TRAY> / (Enter is ?) : "))
  (if entty
    (setq ha-entty entty)
  )
  (if entty
    (setq list1 (cdr (assoc 0 (setq list2 (entget (car entty))))))
    (setq list2 "WIRE")
  )
  (cond	((= list1 "LINE") (arr-hanger list2))
	((= list2 "WIRE") (blk-list "WIRE"))
	(T
	 (progn	(prompt "\n Select is Not \"LINE\" --> ")
		(prin1 list1)
	 )
	)
  )
  (prin1)
  (new-sn)
  (command "undo" "end")
)

(defun C:HA3 (/ entty list1 list2)
	(command "undo" "group")
	(old-non)
	(setq hh2 nil)
	(setq entty (entsel "\nSelect object <Line=TRAY> / (Enter is ?) : "))
	(if entty
		(progn
			(setq ha-entty entty)
			(setq list1 (cdr (assoc 0 (setq list2 (entget (car entty))))))
			(if (= list1 "LINE") 
				(arr-hanger list2)
				(progn
					(prompt "\n Select is Not \"LINE\" --> ")
					(prin1 list1)
				)
			)
		)
		(ha-pbox)
	)
  (prin1)
  (new-sn)
  (command "undo" "end")
)

(defun ha-pbox()
	(setvar "osmode" 33)
	(setq p1 (getpoint "\n\t Pick First Point [Start] "))
	(setq p2 (getpoint p1 "\n\t Pick Second Point [End] : "))
	(command "line" p1 p2 "")
	(setvar "osmode" 0)
	(setq entty (entlast))
;	(setq list1 (cdr (assoc 0 (setq list2 (entget (car entty))))))
	(setq list1 (cdr (assoc 0 (setq list2 (entget entty)))))
	(arr-hanger list2)
	(entdel entty)
)

(defun C:HA2 (/ entty list1 list2 hh2 kkk)
					;  (setq kkk(getvar "UNDOMARKS"))
					;  (if (/= kkk 1)
  (if ha-entty
    (progn
      (command "u")
      (command "undo" "group")
      (old-non)
      (setq hh2 1)
      (setq entty ha-entty)
      (setq ha-entty nil)
      (setq list1 (cdr (assoc 0 (setq list2 (entget (car entty))))))
      (arr-hanger2 list2)
      (prin1)
      (new-sn)
      (command "undo" "end")
    )
    (progn
      (C:HA1)
      (setq ha-entty nil)
    )
  )
)

					;---------------

(defun arr-hanger (_d / xx ang dist1 k2 k3 k2a k3a p1 p2 p3 _arr -arr)
  (setq xx (li_find 10 _d))
  (setq yy (li_find 11 _d))
  (setq ang (angle xx yy))
  (setq dist1 (distance xx yy))
  (if (= hpost-d nil)
    (setq hpost-d 1500)
  )
  (prompt "\n Enter Hanger-Post Distance ? <")
  (prin1 hpost-d)
  (setq k2a (getreal "> : "))
  (if (or (= k2a nil) (= k2a ""))
    (setq k2 hpost-d)
    (setq k2 k2a)
  )
  (if (= hpost-n nil)
    (setq hpost-n "H60")
  )
  (prompt "\n Enter Hanger-Post Name ? <")
  (prin1 hpost-n)
  (setq k3a (getstring "> : "))
  (if (or (= k3a nil) (= k3a ""))
    (setq k3 hpost-n)
    (setq k3 k3a)
  )
  (setq _arr (setq -arr (fix (/ dist1 k2))))
  (if (= 2 (gcd 2 _arr))		;JJACK-SU
    (setq p1 (polar xx ang (/ (- dist1 (* k2 _arr)) 2)))
    (setq p1 (polar xx ang (/ (- dist1 (* k2 _arr)) 2)))
  )
  (if hh2
    (command ".insert" k3 p1 "" "" (+ (rtd ang) 180))
    (command ".insert" k3 p1 "" "" (rtd ang))
  )
  (setq p3 (polar p1 ang k2))
  (repeat -arr
    (command "copy" "L" "" p1 p3)
    (setq p1 p3)
    (setq p3 (polar p1 ang k2))
  )
  (if (= hh2 nil)
    (progn (prompt "\n Do You Rotation -->  command:HA2 ")
    )
  )
  (setq	hpost-d	k2
	hpost-n	k3
  )
)

(defun arr-hanger2 (_d / xx ang dist1 k2 k3 k2a k3a p1 p2 p3 _arr -arr)
  (setq xx (li_find 10 _d))
  (setq yy (li_find 11 _d))
  (setq ang (angle xx yy))
  (setq dist1 (distance xx yy))
  (setq k2 hpost-d)
  (setq k3 hpost-n)
  (setq _arr (setq -arr (fix (/ dist1 k2))))
  (if (= 2 (gcd 2 _arr))		;JJACK-SU
    (setq p1 (polar xx ang (/ (- dist1 (* k2 _arr)) 2)))
    (setq p1 (polar xx ang (/ (- dist1 (* k2 _arr)) 2)))
  )
  (command ".insert" k3 p1 "" "" (+ (rtd ang) 180))
  (setq p3 (polar p1 ang k2))
  (repeat -arr
    (command "copy" "L" "" p1 p3)
    (setq p1 p3)
    (setq p3 (polar p1 ang k2))
  )
  (setq	hpost-d	k2
	hpost-n	k3
  )
)

					;-----------------------Other Command by "Kil...... "-------------
					;(load"hhf")
					;(load"dtins")
					;(c:date-time)
					;-----------------------------------------------------------------
					;(load "drb")

					;BREAK.LSP
					;(prompt "\n\t Wate [BREAK UTILITY GROOP] as Loading..")
;;---------------------------------------------------------------
;; This program is first at the "PARK DAE SIG"
;; date 1997. 2. 20
;;---------------------------------------------------------------
					;command name "BR" "BH" "BV" "BII"
					;(defun old-int()(setq olds(getvar "OSMODE"))(setvar "OSMODE" 32))
					;(defun new-sn()(if olds(setvar "OSMODE" olds))(setq olds nil)(prin1))
(defun os-int () (setvar "OSMODE" 32))
(defun os-non () (setvar "OSMODE" 0))
(setq bk1 200)

					;(defun myerror (s)
					;  (if (/= s "Function cancelled")
					;    (progn
					;      (new-sn)
					;      (princ (strcat "\nError: " s))
					;    )
					;  )
					;  (setq e1 nil)(new-sn)(setq *error* olderr)(princ)
					;)

;;----------------------------------------------------------------
;;----------------------------------------------------------------

(defun C:BR ()
  (setq	olderr	*error*
	*error*	myerror
	chm	0
  )
  (old-int)
  (setvar "CMDECHO" 0)
  (if (= b_mode nil)
    (setq b_mode "Horigental")
  )
  (if (or (= bk1 nil) (= bk1 0.00))
    (progn
      (prompt " Break Width is none [ 0.00 ] Press \"W\" or \"w\""
      )
      (SETQ BK1 0)
    )
    (progn
      (prompt "\t Break harf WIDTH is = ")
      (prin1 bk1)
    )
  )
  (setq temp T)
  (while temp
    (initget "Width Horigental Vertical")
    (prompt "\n\t Width/Horigental/Vertical/<")
    (prin1 b_mode)
    (prompt ">: ")
    (setq b_word (getkword))
    (cond
      ((= b_word "Width") (bkw))
      ((= b_word "Horigental") (bah 1))
      ((= b_word "Vertical") (bah 0))
      ((null b_word) (b_pre))
    )
  )
  (new-sn)
)

;;----------------------------------------------------------------------
(defun b_pre ()
  (if (= b_mode "Width")
    (bkw)
  )
  (if (= b_mode "Horigental")
    (bah 1)
  )
  (if (= b_mode "Vertical")
    (bah 0)
  )
)

;;------------------------------------------------------------------------

(defun bah (_s / p1 p2 p3 e1 o1 nl n i e2 ed t0)
  (setq s-a 1)
  (setq s-b 0)
  (if (= _s 1)
    (setq b_mode "Horigental")
    (setq b_mode "Vertical")
  )
  (while (> s-a s-b)
    (setq i 0)
    (prompt "\t Enter TARGET of the Break's ")
    (prin1 b_mode)
    (prompt "-harf width is (")
    (prin1 bk1)
    (prompt
      ")- \n If you Change of Width at Typing the [DWGS] or [BKW]"
    )
    (setq e1 (ssget))
    (IF	(/= e1 nil)
      (progn
	(prompt "\n Enter Break Point ?")
	(prin1 b_mode)
	(setq P1 (getpoint))
	(if (= _s 1)
	  (progn
	    (setq p2 (list (+ (car p1) BK1) (cadr p1)))
	    (setq p3 (list (- (car p1) BK1) (cadr p1)))
	  )
	  (progn
	    (setq p2 (list (CAR P1) (+ (CADR P1) BK1)))
	    (setq p3 (list (CAR P1) (- (CADR P1) BK1)))
	  )
	)
	(setq nl (sslength e1))
	(setq n (- nl 1))
	(while (<= i n)
	  (setq ed (entget (setq e2 (ssname e1 i))))
	  (setq t0 (cdr (assoc 0 ed)))
	  (if (or (= "LINE" t0) (= "POLYLINE" t0) (= "LWPOLYLINE" t0))
	    (progn
	      (os-non)
	      (command "break" e2 p2 p3)
	      (os-int)
	    )
	  )
	  (setq i (1+ i))
	)
      )
      (setq s-b 2)
    )
  )
  (setq Temp nil)
)
;;------------------------------------------------------------------------
(defun BKW (/ bsp bk2)
  (if (= bk1 nil)
    (setq bk2 200)
    (setq bk2 bk1)
  )
  (prompt "\n\t Pleas Typing the Break harf spase <")
  (prin1 bk2)
  (prompt "> : ")
  (setq bsp (getreal))
  (if (= bsp nil)
    (setq bk1 bk2)
    (setq bk1 bsp)
  )
  (setvar "userr2" bk1)
  (setq b_mode "Horigental")
)

(setq bk1 (getvar "userr2"))

(defun C:BKW () (old-int) (terpri) (bkw) (c:br) (NEW-SN))
(defun C:BH () (old-int) (terpri) (bah 1) (NEW-SN))
(defun C:BV () (old-int) (terpri) (bah 0) (NEW-SN))

;;--------------------------------------------------------------------------

(defun C:BB () ;_s / p1 p2 p3 e1 o1 nl n i e2 ed t0)
  (setq s-a 1)
  (setq s-b 0)
  (while (> s-a s-b)
    (setq i 0)
    (prompt "\t Enter TARGET of the Break's ")
    (prin1 b_mode)
    (prompt "-harf width is (")
    (prin1 bk1)
    (prompt
      ")- \n If you Change of Width at Typing the [DWGS] or [BKW]"
    )
    (setq e1 (ssget))
    (IF	(/= e1 nil)
      (progn
	(prompt "\n Enter Break Point ?")
	(prin1 b_mode)
	(old-int)
	(setq P1 (getpoint))
	(setq nl (sslength e1))
	(setq n (- nl 1))
	(while (<= i n)
	  (setq ed (entget (setq e2 (ssname e1 i))))
	  (setq t0 (cdr (assoc 0 ed)))
	  (if (= "LINE" t0)
	    (progn
	      (os-non)
	      (setq pps (cdr (assoc 10 ed)))
	      (setq ppe (cdr (assoc 11 ed)))
	      (setq ang-bb (angle pps ppe))
	      (setq p2 (polar p1 ang-bb bk1))
	      (setq p3 (polar p1 (- ang-bb (dtr 180)) bk1))
	      (command "break" e2 p2 p3)
	      (os-int)
	    )
	  )
	  (setq i (1+ i))
	)
	(new-sn)
      )
      (setq s-b 2)
    )
  )
  (setq Temp nil)
)

(defun C:BII ()				;/ p1 e1 o1 nl n i e2 ed t0)
  (OLD-INT)
  (setq aaaaa 1)
  (setq bbbbb 0)
  (while (> aaaaa bbbbb)
    (setq i 0)
    (prompt
      "\n Enter TARGET of the Break's (Select Object)-- \n"
    )
    (setq e1 (ssget))
    (IF	(/= e1 nil)
      (PROGN
	(SETQ P1 (GETPOINT "\n ENTER BREAK POINT ? (First Point) :"))
	(setq nl (sslength e1))
	(setq n (- nl 1))
	(while (<= i n)
	  (setq ed (entget (setq e2 (ssname e1 i))))
	  (setq t0 (cdr (assoc 0 ed)))
	  (if (or (= "LINE" t0) (= "POLYLINE" t0))
	    (progn
	      (os-non)
	      (command "break" e2 P1 P1)
	      (os-int)
	    )
	  )
	  (setq i (1+ i))
	)
      )
      (setq bbbbb 2)
    )
  )
  (new-sn)
  (setq Temp nil)
)

					;(prompt ".. Loadig is Complete!!")
					;(prompt "\n\t Command Name is \"BR\" \"BH\" \"BV\" \"BII\" ")
(prin1)

					;CHS.LSP
(defun ssx_fe (/ x data fltr ent)
  (setq ent (car (entsel "\nSelect object/<None>: ")))
  (if ent
    (progn (setq data (entget ent))
	   (foreach x '(0 2 6 7 8 39 62 66 90 210) ; do not include 38
	     (if (assoc x data)
	       (setq fltr (cons (assoc x data) fltr))
	     )
	   )
	   (reverse fltr)
    )
  )
)
(defun ssx_re (element alist)
  (append
    (reverse (cdr (member element (reverse alist))))
    (cdr (member element alist))
  )
)
(defun ssx_er (s)			; If an error (such as CTRL-C) occurs
					; while this command is active...
  (if (/= s "Function cancelled")
    (princ (strcat "\nError: " s))
  )
  (if olderr
    (setq *error* olderr)
  )					; Restore old *error* handler
  (princ)
)
(defun ssx (/ olderr)
  (gc)					; close any sel-sets
  (setq	olderr	*error*
	*error*	ssx_er
  )
  (setq fltr (ssx_fe))
  (ssx_gf fltr)
)
(defun ssx_gf (f1 / t1 t2 t3 f1 f2)
  (while
    (progn
      (cond (f1 (prompt "\nFilter: ") (prin1 f1)))
      (initget
	"Block Color Entity Flag LAyer LType Pick Style Thickness Vector"
      )
      (setq t1 (getkword (strcat
			   "\n>>Block name/Color/Entity/Flag/"
			   "LAyer/LType/Pick/Style/Thickness/Vector: "
			 )
	       )
      )
    )
     (setq t2
	    (cond
	      ((eq t1 "Block") 2)
	      ((eq t1 "Color") 62)
	      ((eq t1 "Entity") 0)
	      ((eq t1 "LAyer") 8)
	      ((eq t1 "LType") 6)
	      ((eq t1 "Style") 7)
	      ((eq t1 "Thickness") 39)
	      ((eq t1 "Flag") 66)
	      ((eq t1 "Vector") 210)
	      (T t1)
	    )
     )
     (setq t3
	    (cond
	      ((= t2 2)
	       (getstring "\n>>Block name to add/<RETURN to remove>: ")
	      )
	      ((= t2 62)
	       (initget 4 "?")
	       (cond
		 ((or (eq (setq
			    t3 (getint
				 "\n>>Color number to add/?/<RETURN to remove>: "
			       )
			  )
			  "?"
		      )
		      (> t3 256)
		  )
		  (ssx_pc)		; Print color values.
		  nil
		 )
		 (T
		  t3			; Return t3.
		 )
	       )
	      )
	      ((= t2 0)
	       (getstring "\n>>Entity type to add/<RETURN to remove>: ")
	      )
	      ((= t2 8)
	       (getstring "\n>>Layer name to add/<RETURN to remove>: ")
	      )
	      ((= t2 6)
	       (getstring "\n>>Linetype name to add/<RETURN to remove>: ")
	      )
	      ((= t2 7)
	       (getstring "\n>>Text style name to add/<RETURN to remove>: "
	       )
	      )
	      ((= t2 39)
	       (getreal "\n>>Thickness to add/<RETURN to remove>: ")
	      )
	      ((= t2 66)
	       (if (assoc 66 f1)
		 nil
		 1
	       )
	      )
	      ((= t2 210)
	       (getpoint "\n>>Extrusion Vector to add/<RETURN to remove>: "
	       )
	      )
	      (T nil)
	    )
     )
     (cond
       ((= t2 "Pick")
	(setq f1 (ssx_fe)
	      t2 nil
	)
       )				; get entity
       ((and f1 (assoc t2 f1))		; already in the list
	(if (and t3 (/= t3 ""))
	  (setq f1 (subst (cons t2 t3) (assoc t2 f1) f1))
	  (setq f1 (ssx_re (assoc t2 f1) f1))
	)
       )
       ((and t3 (/= t3 "")) (setq f1 (cons (cons t2 t3) f1)))
       (T nil)
     )
  )
  (if f1
    (setq f2 (ssget "x" f1))
  )
  (setq *error* olderr)
  (if (and f1 f2)
    (progn
      (princ (strcat "\n" (itoa (sslength f2)) " found. "))
      f2
    )
    (progn (princ "\n0 found.") (prin1))
  )
)
(defun ssx_pc ()
  (if textpage
    (textpage)
    (textscr)
  )
  (princ
    "\n                                                     "
  )
  (princ
    "\n                 Color number   |   Standard meaning "
  )
  (princ
    "\n                ________________|____________________"
  )
  (princ
    "\n                                |                    "
  )
  (princ
    "\n                       0        |      <BYBLOCK>     "
  )
  (princ
    "\n                       1        |      Red           "
  )
  (princ
    "\n                       2        |      Yellow        "
  )
  (princ
    "\n                       3        |      Green         "
  )
  (princ
    "\n                       4        |      Cyan          "
  )
  (princ
    "\n                       5        |      Blue          "
  )
  (princ
    "\n                       6        |      Magenta       "
  )
  (princ
    "\n                       7        |      White         "
  )
  (princ
    "\n                    8...255     |      -Varies-      "
  )
  (princ
    "\n                      256       |      <BYLAYER>     "
  )
  (princ
    "\n                                               \n\n\n"
  )
)
(defun c:CHS () (ssx) (princ) (command "change" "p" ""))

;;수정할여지가 많음.......
(defun C:TRA ()
  (if tra_data
    (command "trim" tra_data "")
    (progn
      (setq tra_data (ssx))
      (command "trim" tra_data "")
    )
  )
  (princ)
)
(defun c:traa () (setq tra_data nil) (c:tra))

(defun C:ESS () (ssx) (princ) (command "erase" "p"))
					;(princ "\n\tType \"CHS\" at a [CHANGE] Command: prompt or ")
					;(princ "\n\tType \"ESS\" at a [ERASE] Command: prompt or ")
					;(princ "\n\t(ssx) at any object selection prompt. ")(princ)
(defun c:sslt (/ xxx lt-ta lt-tt)
  (setq lt-ta (strcase (getstring "\n Line Type ? :")))
  (setq lt-tt (strcase (getstring "\n Line Type !!! :")))
  (setq xxx (ssget "X" (list (cons 6 lt-ta))))
  (if xxx
    (command "chprop" xxx "" "lt" lt-tt "")
  )
)

					;BLK.LSP
(defun C:BLK (/kkk key)
  (setq kkk 1)
  (while (> kkk 0)
    (initget "Erase Select CHange COunt ?")
    (setq key
	   (getkword
	     "\n\t Option was Select/Erase/COunt/CHange/? : <Count>"
	   )
    )
    (cond
      ((= key "Erase") (c:ebk))
      ((= key "Select") (c:sbk))
      ((= key "COunt") (c:ctt))
      ((= key "CHange") (c:chbb))
      ((= key "?") (c:jinkey))
      (T (c:ctt))
    )
  )
)

					;(prompt "\n\t Wait [ BLOCK UTILITY ] as Loading .... ")
;;;---------------------------------------------------------------
;;; this program is first at the "park dae sig"
;;; date 1997. 2. 20
;;;---------------------------------------------------------------
					;command name is "EBK" "SBK" "CTT" "CHBB"
					;select, erase, change, rotate, scale......

					;------------ selection-set for BLOCK
(defun b_sel (a)
  (ssget "X" (list (cons 0 "INSERT") (cons 2 a)))
)

					;------------ block's NAME & command SETTING
(defun b_set_run (a)
  (cond
    ((= a "DEL")
     (setq b_set  " -DELETE- "
	   b_comm "ERASE"
     )
    )
    ((= a "SEL")
     (setq b_set  " -SELECT- "
	   b_comm "SELECT"
     )
    )
    ((= a "COU") (setq b_set " -COUNT- "))
    ((= a "CHB1") (setq b_set " -TARGET- "))
    ((= a "CHB2") (setq b_set " -SERVICE- "))
    (T (setq b_set " -COUNT- "))
  )
  (prompt (strcat "\n* Pick an object to be" b_set "block :"))
  (setq blk1 (car (entsel)))
  (if (= blk1 nil)
    (progn
      (prompt
	(strcat "\n* Typing block name to be" b_set "block :")
      )
      (setq bna (strcase (GETSTRING)))
    )
    (progn
      (setq bna (cdr (assoc 2 (entget blk1))))
      (prompt (strcat "....Select Block Name is [" bna "] :"))
    )
  )
  (prin1)
)

;;------------ block's EDITING COMMAND (Select or Erase)
(defun blk_comm	(a)
  (setvar "cmdecho" 0)
  (setq qtts 0)
  (command b_comm a "")
  (setq qtts (sslength a))
  (setq a nil)
  (prompt (strcat "\n"		    "* Thank-you! Target ["
		  bna		    "] block(s) to"   B_SET
		  " = "
		 )
  )
  (prin1 qtts)
)

;;----- ERASE BLOCK
(defun C:EBK (/ qtts bna blk1 ebl a)
  (b_set_run "DEL")
  (setq ebl (B_SEL BNA))
  (BLK_COMM ebl)
  (prin1)
)

;;----- SELECT BLOCK
(defun C:SBK (/ qtts bna blk1 ebl a)
  (b_set_run "SEL")
  (setq ebl (B_SEL BNA))
  (BLK_COMM ebl)
  (prin1)
)

;;----- COUNT BLOCK
(defun C:CTT (/ qtts bna blk1 ebl a i nl n ctts bna0 bna1 ed e2)
  (setq	ctts 0
	i 0
  )
  (b_set_run "COU")
  (prompt "\n Select Object the Count...!! ")
  (setq ebl (ssget (list (cons 2 bna))))
  (prompt "\n\t Wating please Counting.....")
  (setq nl (sslength ebl))
  (setq n (- nl 1))
  (while (<= i n)
    (setq ed (entget (setq e2 (ssname ebl i))))
    (setq bna0 (cdr (assoc 0 ed)))
    (if	(= "INSERT" bna0)
      (progn
	(setq bna1 (cdr (assoc 2 ed)))
	(if (= (strcase bna) (strcase bna1))
	  (setq ctts (+ ctts 1))
	)
      )
    )
    (setq i (1+ i))
  )
  (setq cccc (strcat "[" bna "] block's count = " (rtos ctts 2 0)))
  (grtext -1 cccc)
  (prompt (strcat "\n* Thank-you! Target ["
		  bna		      "] block(s) to"
		  B_SET		      " = "
		 )
  )
  (prin1 ctts)
  (prin1)
)


					;--------------------------------------------------------------------------
					;(defun c:chbb (/ i os_old olderr myerror blk1 t-bna s_blk1
					;               s-bna ebl nl l1 e2 ed ban0 p1 y0)
					;   (setq ch1 0 i 0 b-sel 1 c-sel 1 olderr *error* *error* myerror chm 0)
					;   (setvar "CMDECHO" 0)
					;   (setq os_old (getvar "OSMODE"))
					;   (setvar "OSMODE" 0)
					;   (while b-sel (b_set_run "CHB1")(if bna (setq b-sel nil)))
					;   (setq t-bna bna)
					;   (while c-sel (b_set_run "CHB2")(if bna (setq c-sel nil)))
					;   (setq s-bna bna)(setq bna nil)
					;   (prompt "\n\t\t  *** select the block's *** : ")
					;   (setq ebl (ssget (list (cons 2 t-bna))))
					;   (prompt "\n\t\t    *** wate - changing ***")
					;   (setq nl (sslength ebl))(setq l1 (- nl 1))
					;   (while (<= i l1)
					;      (setq e2 (ssname ebl i))
					;      (setq ed (entget e2))
					;      (setq bna0 (cdr (assoc 2 ed)))
					;      (setq blsc (cdr (assoc 41 ed)))
					;      (setq p1 (cdr (assoc 10 ed)))
					;      (if (= t-bna bna0)
					;         (progn
					;            (command "erase" e2 "")
					;            (command "insert" s-bna p1 blsc "" "")
					;            (setq ch1 (+ ch1 1))
					;            (setq y0 (cdr (assoc 50 ed)))
					;            (setq y0 (/ (* y0 180.0) pi))
					;            (if (/= y0 0.0)
					;               (command "rotate" "l" "" p1 y0)
					;            )
					;         )
					;      )
					;      (setq i (+ i 1))
					;   )
					;   (prompt "\n\t\t    *** changing complete ***")
					;   (prompt (strcat "\n Thank-you! Changing Block ["t-bna"]-->["s-bna"] Total is = "))
					;   (prin1 ch1) (setvar "osmode" os_old)(prin1)
					;)

					;(prompt ".. Loading is Complete !! ")
					;(prompt "\n\t Command name is \"EBK\" \"SBK\" \"CTT\" \"CHBB\" ")

					;CUT.LSP
;; Make PDS
					;(defun C:CT(/ OLDS)
					;   (old-endint)
					;   (if (or (= wire-scale 0.0)(= wire-sacle 0))
					;      (prompt "\n [wire-scale] is Nothing ...
					;               \n First Running command [W-SC] ")
					;      (command "insert" "cct-f" pause wire-scale "" "NEA" pause)
					;   )
					;   (new-sn)
					;)

(defun c:ct1 (/ po1 po2 angs1)
  (old-qua)
  (if (or (= wire-scale 0.0) (= wire-sacle 0))
    (prompt
      "\n [wire-scale] is Nothing ...
               \n First Running command [W-SC] "
    )
    (progn
      (setq po1 (getpoint "\n At Circuit Start Point ? <QUA> :"))
      (setvar "OSMODE" 0)
      (setq po2 (getpoint po1 "\n At Circuit End Point ? <none> :"))
      (setq angs1 (angle po2 po1))
      (command "line" po1 po2 "")
      (command "INSERT" "CCT-F" po2 wire-scale "" (rtd angs1))
    )
  )
  (new-sn)
)

(defun c:ct2 (/ po1 po2 po3 angs1 a b)
  (old-qua)
  (if (or (= wire-scale 0.0) (= wire-sacle 0))
    (prompt
      "\n [wire-scale] is Nothing ...
               \n First Running command [W-SC] "
    )
    (progn
      (setq po1 (getpoint "\n At Circuit Start Point ? <QUA> :"))
      (setvar "OSMODE" 0)
      (setq po2 (getpoint po1 "\n At Circuit Second Point ? <none> :"))
      (setq po3 (getpoint po2 "\n At Circuit Last Point ? <none> :"))
      (setq angs1 (angle po3 po2))
      (command "line" po1 po2 "")
      (setq a (entlast))
      (command "line" po2 po3 "")
      (setq b (entlast))
      (command "INSERT" "CCT-F" po3 wire-scale "" (rtd angs1))
      (command "FILLET" a b)
    )
  )
  (new-sn)
)

(defun c:ct3 (/ ango ortho po1 po2 po3 po4 pt4 pt5 dist1 dist2)
  (old-qua)
  (if (or (= wire-scale 0.0) (= wire-sacle 0))
    (prompt
      "\n [wire-scale] is Nothing ...
               \n First Running command [W-SC] "
    )
    (progn
      (setq ango (getvar "SNAPANG"))
      (setq ortho (getvar "ORTHOMODE"))
      (setq po1 (getpoint "\n At Circuit Start Point ? <QUA> :"))
      (setvar "OSMODE" 0)
      (setq po2 (getpoint po1 "\n At Circuit End Point ? <none> :"))
      (setq angs1 (angle po1 po2))
      (setq dist1 (distance po1 po2))
      (setq dist2 (/ dist1 2))
      (setvar "SNAPANG" angs1)
      (setvar "ORTHOMODE" 1)
      (setq po3 (polar po1 angs1 dist2))
      (setq po4 (getpoint po3 "\n At Circuit Center Point ? :"))
      (setq angs2 (angle po3 po4))
      (setq pt4 (polar po4 angs1 dist2))
      (setq pt5 (polar pt4 (+ (dtr 180) angs1) dist1))
      (command "pline" po1 "w" 0 0 pt5 "a" pt4 "l" po2 "")
      (command "explode" "l")
      (command "INSERT" "CCT-F" po2 wire-scale "" (rtd angs2))
					;(command "line" po1 pt5 "")
					;(command "line" po2 pt4 "")
					;(command "arc" "s" pt5 "e" pt4 po4)
      (setvar "SNAPANG" ango)
      (setvar "ORTHOMODE" ortho)
    )
  )
  (new-sn)
  (prin1)
)

					;WIRE.LSP
					;*****************************************************
					; - This program is Wiring in Drawing (WIRE.LSP)     /
					;   command:"LL?, ?-L, ?-L2"                         /
;;;------------------------------                    /
;;; Make by Park Dae-sig                             /
;;; Date is 1995-00-00                               /
;;; Where is "JIN" Electric co.                      /
;;; (HP) 018-250-7324                                /
;;;------------------------------                    /
					; - Last Up-Date is 1998-10-13 (P.D.S)               /
					;*****************************************************

					;------------------------ Base Setting -------------------------------------

(defun dtr (a) (* pi (/ a 180.0)))
(defun rtd (a) (/ (* a 180.0) pi))

(defun new-sn ()
  (setvar "osmode" olds)
  (setq olds nil)
  (prin1)
)
(defun old-nea ()
  (setq	olderr	*error*
	*error*	wierror
	chm	0
  )
  (setq snap-ang (getvar "snapang"))
  (setq olds (getvar "osmode"))
  (setvar "osmode" 512)
)

(defun old-mid ()
  (setq olds (getvar "osmode"))
  (setvar "osmode" 2)
)
(defun old-non ()
  (setq olds (getvar "osmode"))
  (setvar "osmode" 0)
)

(defun wierror (s)
  (if (/= s "function cancelled")
    (princ (strcat "\nerror: " s))
  )
  (setvar "osmode" olds)
  (setq *error* olderr)
  (princ)
)

					;------------------------ Break width Setting ------------------------------

(setq key-n (getvar "USERR5"))
(if (or (= key-n 0.0) (= key-n nil))
  (setq key-n (getvar "LTSCALE"))
)

(defun sel00 ()
  (cond
    ((= bl_in "LINE-TV") (setq wd_in (* key-n 2.3)))
    ((= bl_in "LINE-EX") (setq wd_in (* key-n 2.3)))
    ((= bl_in "LINE-ES") (setq wd_in (* key-n 2.3)))
    ((= bl_in "LINE-DC") (setq wd_in (* key-n 2.3)))
    ((= bl_in "LINE-OA") (setq wd_in (* key-n 2.3)))
    ((= bl_in "LINE-TD") (setq wd_in (* key-n 2.3)))
    ((= bl_in "LINE-TVV") (setq wd_in (* key-n 2.3)))
    ((= bl_in "LINE-INT") (setq wd_in (* key-n 2.3)))
    (T (setq wd_in (* key-n 1.5)))
  )
)

(defun sel45 ()
  (cond
    ((< 75 bbb 115) (setq wd_in (* key-n 2.15)))
    ((= bl_in "LINE-DC") (setq wd_in (* key-n 2.4)))
    ((= bl_in "LINE-TV") (setq wd_in (* key-n 2.4)))
    ((= bl_in "LINE-EX") (setq wd_in (* key-n 2.4)))
    ((= bl_in "LINE-ES") (setq wd_in (* key-n 2.4)))
    ((= bl_in "LINE-OA") (setq wd_in (* key-n 2.4)))
    ((= bl_in "LINE-TD") (setq wd_in (* key-n 2.4)))
    (T (setq wd_in (* key-n 2)))
  )
)
(defun sel45 ()
  (cond
    ((< 75 bbb 115) (setq wd_in (* key-n 2.15)))
    ((= bl_in "LINE-TVV") (setq wd_in (* key-n 2.4)))
    ((= bl_in "LINE-INT") (setq wd_in (* key-n 2.4)))
    (T (setq wd_in (* key-n 2)))
  )
)

					;------------------------ Main Program -------------------------------------

(defun wire_in (bl_in /	p1 p2 p3 p4 p5 ang_l1 sel_l1 dis_l1 aaa	bbb
		wd_in os-inp)
  (if (= line-work "Light")
    (setq os-inp "mid")
    (setq os-inp "nea")
  )
  (setq	olderr	*error*
	*error*	wierror
	chm	0
  )
  (prompt "\n Change Break-Width as Typing -> [DWGS] ")
  (prompt "\n where block [")
  (prin1 bl_in)
  (prompt "] insert point ? :")
  (prompt "..")
  (prin1 os-inp)
  (prompt "..")
  (setq sel_line (entsel))
  (setq sel_l1 (entget (car sel_line)))
  (if (= (cdr (assoc 0 sel_l1)) "LINE")
    (progn
      (old-non)
      (setq p1 (cdr (assoc 10 sel_l1)))
      (setq p2 (cdr (assoc 11 sel_l1)))
      (setq dis_l1 (distance p1 p2))
      (setq ang_l1 (angle p1 p2))
      (setq aaa (fix (/ (rtd ang_l1) 180)))
      (setq bbb (- (rtd ang_l1) (* aaa 180)))
      (if (< 30 bbb 160)
	(sel45)
	(sel00)
      )
      (if (= os-inp "mid")
	(setq p3 (osnap (cadr sel_line) "mid"))
	(setq p3 (osnap (cadr sel_line) "nea"))
      )
      (setq p4 (polar p3 ang_l1 wd_in))
      (setq p5 (polar p3 (- ang_l1 (dtr 180)) wd_in))
      (command "Break" sel_line	"F" p4 p5 "insert" bl_in p3 wire-scale
	       "" "")
      (new-sn)
    )
    (if	(or (= (cdr (assoc 0 sel_l1)) "LWPOLYLINE")
	    (= (cdr (assoc 0 sel_l1)) "POLYLINE")
	)
      (progn
	(old-non)
	(if sel_ang
	  (setq key-xx sel_ang)
	  (setq sel_ang "Horigental")
	)
	(setq key-xx sel_ang)
	(initget "Horigental Vertical  ")
	(prompt "\n Enter Horigental/Vertical <")
	(prin1 key-xx)
	(setq key-xx (getkword "> ? :"))
	(if (or (= key-xx nil) (= key-xx ""))
	  (setq key-xx sel_ang)
	  (setq sel_ang key-xx)
	)
	(if (= sel_ang "Horigental")
	  (progn (setq bbb 0) (setq ang_l1 (dtr 0)))
	)
	(if (= sel_ang "Vertical")
	  (progn (setq bbb 90) (setq ang_l1 (dtr 90)))
	)
	(if (< 30 bbb 160)
	  (sel45)
	  (sel00)
	)
	(if (= os-inp "mid")
	  (setq p3 (osnap (cadr sel_line) "mid"))
	  (setq p3 (osnap (cadr sel_line) "nea"))
	)
	(setq p4 (polar p3 ang_l1 wd_in))
	(setq p5 (polar p3 (- ang_l1 (dtr 180)) wd_in))
	(command "Break" sel_line "F" p4 p5 "insert" bl_in p3 wire-scale
		 "" "")
	(new-sn)
      )
      (prompt
	"\n Select is Not \"LINE\" or \"PLINE\" Tri-Again....."
      )
    )
  )
)

					;------------------------ Call Program -------------------------------------

(defun C:LLE () (wire_in "LINE-E"))
(defun C:LLEX () (wire_in "LINE-EX"))
(defun C:LLES () (wire_in "LINE-ES"))
(defun C:LLT () (wire_in "LINE-T"))
(defun C:LLTV () (wire_in "LINE-TV"))
(defun C:LLU2 () (wire_in "LINE-U2"))
(defun C:LLU3 () (wire_in "LINE-U3"))
(defun C:LLS () (wire_in "LINE-S"))
(defun C:LLF () (wire_in "LINE-F"))
(defun C:LLOA () (wire_in "LINE-OA"))
(defun C:LLDC () (wire_in "LINE-DC"))
(defun C:LLU () (wire_in "LINE-U"))
(defun C:LLD () (wire_in "LINE-D"))
(defun C:LLTD () (wire_in "LINE-TD"))
(defun C:LLTVV () (wire_in "LINE-TVV"))
(defun C:LLINT () (wire_in "LINE-INT"))
(defun C:LLG () (wire_in_g "*LINE-G"))
(defun C:LLC () (wire_in "LINE-C"))
(defun C:LLPA () (wire_in "LINE-PA"))

(defun C:1 () (wire_in "LINE-E"))
					;(defun C:2() (wire_in "LINE-DC"))
(defun C:3 () (wire_in "LINE-T"))
(defun C:4 () (wire_in "LINE-TV"))
(defun C:5 () (wire_in "LINE-OA"))
(defun C:6 () (wire_in "LINE-U"))
(defun C:7 () (wire_in "LINE-S"))
(defun C:8 () (wire_in "LINE-F"))
(defun C:9 () (wire_in "LINE-EX"))
(defun C:10 () (wire_in "LINE-ES"))
					;(defun C:LLG() (wire_in_g "*LINE-G"))

(defun wire_in_g
       (bl_in / p1 p2 p3 p4 p5 ang_l1 sel_l1 dis_l1 aaa bbb wd_in)
  (setq	olderr	*error*
	*error*	wierror
	chm	0
  )
  (prompt "\n Change Break-Width as Typing -> [DWGS] ")
  (prompt "\n where block [")
  (prin1 bl_in)
  (prompt "] insert point ? :")
  (setq sel_line (entsel))
  (setq sel_l1 (entget (car sel_line)))
  (if (= (cdr (assoc 0 sel_l1)) "LINE")
    (progn
      (old-non)
      (setq p1 (cdr (assoc 10 sel_l1)))
      (setq p2 (cdr (assoc 11 sel_l1)))
      (setq dis_l1 (distance p1 p2))
      (setq ang_l1 (angle p1 p2))
      (setq aaa (fix (/ (rtd ang_l1) 180)))
      (setq bbb (- (rtd ang_l1) (* aaa 180)))
					;      (if (< 30 bbb 160) (sel45) (sel00))
      (sel00)
      (setq p3 (osnap (cadr sel_line) "nea"))
      (setq p4 (polar p3 ang_l1 (* wd_in 2)))
      (setq p5 (polar p3 (- ang_l1 (dtr 180)) (* wd_in 2)))
      (command "Break"
	       sel_line
	       "F"
	       p4
	       p5
	       "insert"
	       bl_in
	       p3
	       (* wire-scale 2)
	       ""
	       ""
      )
      (new-sn)
    )
    (if	(= (cdr (assoc 0 sel_l1)) "POLYLINE")
      (progn
	(old-non)
	(if sel_ang
	  (setq key-xx sel_ang)
	  (setq sel_ang "Horigental")
	)
	(setq key-xx sel_ang)
	(initget "Horigental Vertical  ")
	(prompt "\n Enter Horigental/Vertical <")
	(prin1 key-xx)
	(setq key-xx (getkword "> ? :"))
	(if (or (= key-xx nil) (= key-xx ""))
	  (setq key-xx sel_ang)
	  (setq sel_ang key-xx)
	)
	(if (= sel_ang "Horigental")
	  (progn (setq bbb 0) (setq ang_l1 (dtr 0)))
	)
	(if (= sel_ang "Vertical")
	  (progn (setq bbb 90) (setq ang_l1 (dtr 90)))
	)
	(if (< 30 bbb 160)
	  (sel45)
	  (sel00)
	)
	(setq p3 (osnap (cadr sel_line) "nea"))
	(setq p4 (polar p3 ang_l1 (* wd_in 2)))
	(setq p5 (polar p3 (- ang_l1 (dtr 180)) (* wd_in 2)))
	(command "Break"
		 sel_line
		 "F"
		 p4
		 p5
		 "insert"
		 bl_in
		 p3
		 (* wire-scale 2)
		 ""
		 ""
	)
	(new-sn)
      )
      (prompt
	"\n Select is Not \"LINE\" or \"PLINE\" Tri-Again....."
      )
    )
  )
)

;;------------------------ End of Program ----------------------------------
;;--------------------------------------------------------------------------

(defun c:g-l (/ olderr p1 p2 p3)
  (old-nea)
  (setq	olderr	*error*
	*error*	wierror
	chm	0
  )
  (setq p1 (getpoint "\n where block \" e3 \" insert point ? (hor) :"))
  (pp-selh1 p1 br-wdh3)
  (command "break"
	   p1
	   "f"
	   p2
	   p3
	   "insert"
	   "*LINE-G"
	   p1
	   (* (GETVAR "LTSCALE") 0.02)
	   ""
  )
  (new-sn)
)

(defun c:g-l2 (/ olderr p1 p2 p3)
  (old-nea)
  (setq	olderr	*error*
	*error*	wierror
	chm	0
  )
  (setq p1 (getpoint "\n where block \" e3 \" insert point ? (ver) :"))
  (pp-selv1 p1 br-wdv3)
  (command "break"
	   p1
	   "f"
	   p2
	   p3
	   "insert"
	   "*LINE-G"
	   p1
	   (* (GETVAR "LTSCALE") 0.02)
	   ""
  )
  (new-sn)
)

;;;------------------------------------------------------------------

					;(princ "\n Type \"[LL??]\" => ?? in block { DC,E,EX,F,S,OA,T,TV,U,D,TVV,TD }")

;;;------------------------------------------------------------------

					;---OLD VERSION---

					;(defun c:br-h(/ key key-d)
					;   (if key-n (setq key-d key-n)(setq key-d (getvar "LTSCALE")))
					;   (prompt "\n WIRE's Break-Width Option ? <")(prin1 key-d)
					;   (setq key(getreal "> :"))
					;   (if (or (= key nil)(= key 0.0))(setq key key-d))
					;   (if key 
					;      (progn
					;         (setq br-wdh1 (* key 1.5))
					;         (setq br-wdv1 (* key 2.0))
					;         (setq br-wdh2 (* key 2.3))
					;         (setq br-wdh3 (* key 3.2))
					;         (setq br-wdv3 (* key 2.3))
					;         (setq key-n key)
					;      )
					;   )
					;)

(defun br-harf ()
  (setq br-wdh1 (* (getvar "ltscale") 1.5))
  (setq br-wdv1 (* (getvar "ltscale") 2.0))
  (setq br-wdh2 (* (getvar "ltscale") 2.3))
  (setq br-wdh3 (* (getvar "ltscale") 3.2))
  (setq br-wdv3 (* (getvar "ltscale") 2.3))
)

(if (or (= br-wdh1 nil) (= br-wdh1 0.0))
  (br-harf)
)

(defun pp-selh1	(a b)
  (setvar "osmode" 0)
  (setq p2 (list (+ (car a) b) (cadr a)))
  (setq p3 (list (- (car a) b) (cadr a)))
)

(defun pp-selhx	(a b)
  (setvar "osmode" 0)
  (setq p2x (polar a snap-ang b))
  (setq p3x (polar a (- snap-ang (dtr 180)) b))
)

(defun pp-selv1	(a b)
  (setvar "osmode" 0)
  (setq p2 (list (car a) (+ (cadr a) b)))
  (setq p3 (list (car a) (- (cadr a) b)))
)

;;;------------------------------------------------------------------

(defun wx-in (w-x _s / olderr p1 p2 p3 w-x)
  (old-nea)
  (setq	olderr	*error*
	*error*	wierror
	chm	0
  )
  (prompt "\n Change Break-Width as Typing -> [DWGS] ")
  (prompt "\n where block \"")
  (prin1 w-x)
  (prompt "\" insert point ? :")
  (setq p1 (getpoint))
  (cond
    ((= _s "X") (pp-selh1 p1 br-wdh1))
    ((= _s "X2") (pp-selh1 p1 br-wdh2))
    ((= _s "Y") (pp-selv1 p1 br-wdv1))
    (t nil)
  )
  (command "break" p1 "f" p2 p3	"insert" w-x p1	wire-scale "" 0)
  (new-sn)
)

;;;------------------------------------------------------------------

(defun c:e-l () (wx-in "LINE-E" "X"))
(defun c:e-l2 () (wx-in "LINE-E" "Y"))
(defun c:f-l () (wx-in "LINE-F" "X"))
(defun c:f-l2 () (wx-in "LINE-F" "Y"))
(defun c:D-l () (wx-in "LINE-D" "X"))
(defun c:D-l2 () (wx-in "LINE-D" "Y"))
(defun c:s-l () (wx-in "LINE-S" "X"))
(defun c:s-l2 () (wx-in "LINE-S" "Y"))
(defun c:t-l () (wx-in "LINE-T" "X"))
(defun c:t-l2 () (wx-in "LINE-T" "Y"))
(defun c:tv-l () (wx-in "LINE-TV" "X2"))
(defun c:TD-l () (wx-in "LINE-TD" "X2"))
(defun c:tv-l2 () (wx-in "LINE-TV" "Y"))
(defun c:tD-l2 () (wx-in "LINE-TD" "Y"))
(defun c:TVV-l () (wx-in "LINE-TVV" "X2"))
(defun c:TVV-l2 () (wx-in "LINE-TVV" "Y"))
(defun c:ex-l () (wx-in "LINE-EX" "X2"))
(defun c:ex-l2 () (wx-in "LINE-EX" "Y"))
(defun c:es-l () (wx-in "LINE-ES" "X2"))
(defun c:es-l2 () (wx-in "LINE-ES" "Y"))
(defun c:dc-l () (wx-in "LINE-DC" "X2"))
(defun c:dc-l2 () (wx-in "LINE-DC" "Y"))
(defun c:oa-l () (wx-in "LINE-OA" "X2"))
(defun c:oa-l2 () (wx-in "LINE-OA" "Y"))
(defun c:u-l () (wx-in "LINE-U" "X"))
(defun c:u-l2 () (wx-in "LINE-U" "Y"))


					;(DEFUN C:ELL()
					;   (setq entty (entsel "\nPick Point: "))
					;   (setq _ent (entget (car entty)))
					;   (setq p1 (getvar "LASTPOINT"))
					;   (setq po-s (eeee _ent 10))
					;   (setq po-e (eeee _ent 11))
					;   (setq ang-wi (angle po-s po-e))
					;   (setq p2 (polar p1 br-wdh1))
					;   (setq p3 (polar p1 br-wdh1))
					;   (command "break" _entty "f" p2 p3 "insert" "LINE-E" p1 wire-scale "" "")
					;)

					;(defun eeee(a b)(setq ent-des (cdr (assoc b a))))

					;(defun C:ENTSEL()
					;   (setq entty (entsel "\nSelect object/<None>: "))
					;   (setq i 0 ent-des nil)(setq _ent (entget (car entty)))
					;   (while i
					;      (eeee _ent i)
					;      (if ent-des
					;         (progn
					;            (prompt "\n -")(prin1 i)(prompt "- is => ")(prin1 ent-des)
					;         )
					;      )
					;      (setq ent-des nil)(setq i (1+ i))(if (> i 255)(setq i nil))
					;   )
					;)


					;CHPP.LSP
;;-----------------------------
;;       Change "Z" Point
;;-----------------------------

(defun cp-ch1011 (a1)
  (setq n (sslength a1))
  (setq index 0)
  (repeat n
    (setq b1 (entget (ssname a1 index)))
    (setq c1 (assoc 10 b1))
    (setq c2 (list 10 (car (cdr c1)) (car (cdr (cdr c1))) 0))
    (setq c3 (subst c2 c1 b1))
    (entmod c3)
    (setq c1 (assoc 11 b1))
    (setq c2 (list 11 (car (cdr c1)) (car (cdr (cdr c1))) 0))
    (setq c3 (subst c2 c1 b1))
    (entmod c3)
    (setq index (+ index 1))
  )
)

(defun cp-chdim	(a1)
  (setq n (sslength a1))
  (setq index 0)
  (repeat n
    (setq b1 (entget (ssname a1 index)))
    (setq c1 (assoc 10 b1))
    (setq c2 (list 10 (car (cdr c1)) (car (cdr (cdr c1))) 0))
    (setq c3 (subst c2 c1 b1))
    (entmod c3)
    (setq c1 (assoc 11 b1))
    (setq c2 (list 11 (car (cdr c1)) (car (cdr (cdr c1))) 0))
    (setq c3 (subst c2 c1 b1))
    (entmod c3)
    (setq c1 (assoc 12 b1))
    (setq c2 (list 12 (car (cdr c1)) (car (cdr (cdr c1))) 0))
    (setq c3 (subst c2 c1 b1))
    (entmod c3)
    (setq c1 (assoc 13 b1))
    (setq c2 (list 13 (car (cdr c1)) (car (cdr (cdr c1))) 0))
    (setq c3 (subst c2 c1 b1))
    (entmod c3)
    (setq c1 (assoc 14 b1))
    (setq c2 (list 14 (car (cdr c1)) (car (cdr (cdr c1))) 0))
    (setq c3 (subst c2 c1 b1))
    (entmod c3)
    (setq c1 (assoc 15 b1))
    (setq c2 (list 15 (car (cdr c1)) (car (cdr (cdr c1))) 0))
    (setq c3 (subst c2 c1 b1))
    (entmod c3)
    (setq c1 (assoc 16 b1))
    (setq c2 (list 16 (car (cdr c1)) (car (cdr (cdr c1))) 0))
    (setq c3 (subst c2 c1 b1))
    (entmod c3)
    (setq index (+ index 1))
  )
)

(defun cp-chxx (a1 xx)
  (setq n (sslength a1))
  (setq index 0)
  (repeat n
    (setq b1 (entget (ssname a1 index)))
    (setq c1 (assoc xx b1))
    (setq c2 (list xx (car (cdr c1)) (car (cdr (cdr c1))) 0))
    (setq c3 (subst c2 c1 b1))
    (entmod c3)
    (setq index (+ index 1))
  )
)

(defun cp-ch10 (a1)
  (setq n (sslength a1))
  (setq index 0)
  (repeat n
    (setq b1 (entget (ssname a1 index)))
    (setq c1 (assoc 10 b1))
    (setq c2 (list 10 (car (cdr c1)) (car (cdr (cdr c1))) 0))
    (setq c3 (subst c2 c1 b1))
    (entmod c3)
    (setq index (+ index 1))
  )
)

(defun cp-ch11 (a1)
  (setq n (sslength a1))
  (setq index 0)
  (repeat n
    (setq b1 (entget (ssname a1 index)))
    (setq c1 (assoc 11 b1))
    (setq c2 (list 11 (car (cdr c1)) (car (cdr (cdr c1))) 0))
    (setq c3 (subst c2 c1 b1))
    (entmod c3)
    (setq index (+ index 1))
  )
)

;;-----------------------------
;;       Select Object
;;-----------------------------

(defun cp-block	()
  (graphscr)
  (setq i 0)
  (setq a1 (ssget "x" (list (cons 0 "INSERT"))))
  (if a1
    (cp-ch10 a1)
  )
)

(defun cp-pline	()
  (graphscr)
  (setq i 0)
  (setq a1 (ssget "x" (list (cons 0 "POLYLINE"))))
  (if a1
    (cp-ch10 a1)
  )
)

(defun cp-solid	()
  (graphscr)
  (setq i 0)
  (setq a1 (ssget "x" (list (cons 0 "SOLID"))))
  (if a1
    (cp-chxx a1 10)
  )
  (setq a1 nil)
  (setq a1 (ssget "x" (list (cons 0 "SOLID"))))
  (if a1
    (cp-chxx a1 11)
  )
  (setq a1 nil)
  (setq a1 (ssget "x" (list (cons 0 "SOLID"))))
  (if a1
    (cp-chxx a1 12)
  )
  (setq a1 nil)
  (setq a1 (ssget "x" (list (cons 0 "SOLID"))))
  (if a1
    (cp-chxx a1 13)
  )
)

(defun cp-arc ()
  (graphscr)
  (setq a1 (ssget "x" (list (cons 0 "ARC"))))
  (if a1
    (cp-ch10 a1)
  )
)

(defun cp-circle ()
  (graphscr)
  (setq a1 (ssget "x" (list (cons 0 "CIRCLE"))))
  (if a1
    (cp-ch10 a1)
  )
)

(defun cp-text ()
  (graphscr)
  (setq a1 (ssget "x" (list (cons 0 "TEXT"))))
  (if a1
    (cp-ch11 a1)
  )
  (setq a1 nil)
  (setq a1 (ssget "x" (list (cons 0 "ATTDEF"))))
  (if a1
    (cp-ch1011 a1)
  )
)

(defun cp-dimm ()
  (graphscr)
  (setq a1 (ssget "x" (list (cons 0 "DIMENSION"))))
  (if a1
    (cp-chxx a1 10)
  )
  (setq a1 nil)
  (setq a1 (ssget "x" (list (cons 0 "DIMENSION"))))
  (if a1
    (cp-chxx a1 11)
  )
  (setq a1 nil)
  (setq a1 (ssget "x" (list (cons 0 "DIMENSION"))))
  (if a1
    (cp-chxx a1 12)
  )
  (setq a1 nil)
  (setq a1 (ssget "x" (list (cons 0 "DIMENSION"))))
  (if a1
    (cp-chxx a1 13)
  )
  (setq a1 nil)
  (setq a1 (ssget "x" (list (cons 0 "DIMENSION"))))
  (if a1
    (cp-chxx a1 14)
  )
  (setq a1 nil)
  (setq a1 (ssget "x" (list (cons 0 "DIMENSION"))))
  (if a1
    (cp-chxx a1 15)
  )
  (setq a1 nil)
  (setq a1 (ssget "x" (list (cons 0 "DIMENSION"))))
  (if a1
    (cp-chxx a1 16)
  )
)


					;(defun cp-dimm ()
					;  (graphscr) 
					;  (setq a1 (ssget "x" (list (cons 0 "DIMENSION"))))
					;  (if a1 (cp-chdim a1))
					;) 

(defun cp-line ()
  (setq a1 (ssget "x" (list (cons 0 "LINE"))))
  (if a1
    (cp-ch10 a1)
  )
  (setq a1 nil)
  (setq a1 (ssget "x" (list (cons 0 "LINE"))))
  (if a1
    (cp-ch11 a1)
  )
)

(defun cp-all ()
  (cp-line)
  (cp-block)
  (cp-arc)
  (cp-circle)
  (cp-text)
  (cp-pline)
  (cp-solid)
)

;;------------------------------
;; Select Option & Main Funtion
;;------------------------------

(defun c:chpp ()
  (prompt "\n\t Change at \"Z\" Point to --> \"0\" ")
  (initget 1 "Line Block Arc Circle Text All Pline Solid Dim")
  (setq	key_chpp
	 (getkword
	   "\n Select Changing Object ?
                            \n Line/Pline/Solid/Block/Arc/Dim/Circle/Text/All: ? "
	 )
  )
  (cond	((= key_chpp "Line") (cp-line))
	((= key_chpp "Block") (cp-block))
	((= key_chpp "Arc") (cp-arc))
	((= key_chpp "Circle") (cp-circle))
	((= key_chpp "Text") (cp-text))
	((= key_chpp "Pline") (cp-pline))
	((= key_chpp "Solid") (cp-solid))
	((= key_chpp "Dim") (cp-dimm))
	((= key_chpp "All") (cp-all))
	(T (prompt "\n Select is Fail "))
  )
)


					;JPLUD.LSP
(defun c:pipe-con (/ p1)
  (old-end)
  (LA-SET "100" 4)
  (setq p1 (getpoint "\n Pick Pipe-end Point (end) :"))
  (command "insert" "end" p1 wire-scale "" "")
  (command "circle" p1 (* dwg-scale 300))
  (command "chprop" "l" "" "lt" "elp" "")
  (LA-BACK)
  (new-sn)
)

(defun c:tray-con (/ p1 p2 p3 p4 p5 ang1 dist1)

  (old-end)
  (LA-SET "100" 4)
  (setq p1 (getpoint "\n Pick Tray's First End Point (end) : "))
  (setq p2 (getpoint p1 "\n Pick Tray's Second End Point (end) : "))
  (setq ang1 (angle p1 p2))
  (setq dist1 (distance p1 p2))
  (setq p3 (polar p1 ang1 (/ dist1 2)))
  (setq p4 (polar p3 (+ ang1 (dtr 90)) (/ dist1 3)))
  (setq p5 (polar p3 (+ ang1 (dtr 180)) (* (distance p3 p4) 2.5)))

  (setvar "OSMODE" 0)
  (command "line" p1 p2 "")
  (command "scale" "l" "" p3 1.5)
  (command "insert" "end" p3 wire-scale "" (+ (rtd ang1) 90))
  (command "ellipse" "c" p3 p4 p5)
  (command "chprop" "l" "" "lt" "elp" "")

  (LA-BACK)
  (new-sn)

  (JPLUD)

)

(defun jplud (/ plud_ss pline_info old new)
  (setq plud_ss (entlast))
  (setq pline_info (entget plud_ss))
  (setq old (assoc '70 pline_info))
  (setq new (cons 70 (logior (cdr old) 128)))
  (entmod (subst new old pline_info))
  (prin1)
)

;;;---------------------------------------------------------------------------;
;;; Internal error handler.
;;;---------------------------------------------------------------------------;

(defun plud_err	(s)
  (if (/= s "Function cancelled")
    (princ (strcat "\nError: " s))
  )
  (setq *error* old_err)
  (princ)
)
;;;---------------------------------------------------------------------------;

;;;---------------------------------------------------------------------------;
;;; The Main Function.
;;;---------------------------------------------------------------------------;

(defun c:plud (/ a method plud_ss pline_info old new)

  (setq	old_err	*error*
	*error*	plud_err
  )
  (setq a 0)
  (setq	plud_ss
	 (ssget
	   (list
	     (cons 0 "POLYLINE")
	     (cons -4 "<NOT")
	     (cons -4 "&")
	     (cons 70 248)
	     (cons -4 "NOT>")
	   )
	 )
  )
  (while (< a (sslength plud_ss))
    (setq pline_info (entget (ssname plud_ss a)))
    (setq old (assoc '70 pline_info))
    (setq new (cons 70 (logior (cdr old) 128)))
    (entmod (subst new old pline_info))
    (setq a (1+ a))
  )
  (princ (strcat (itoa a) " Polyline(s) updated."))
  (princ)
)

;;;---------------------------------------------------------------------------;


;;==================================================================
;;==================================================================

					;XPP.LSP
					;*****************************************
					; - This program is Xpp.lsp              /
;;;------------------------------        /
;;; Make by Park Dae-sig                 /
;;; Date is 2001-12-07                   /
;;; Where is "JIN" Electric co.          /
;;; T) 017-292-7324 (pds0311@empal.com)  /
;;;------------------------------        /
					; - Last Up-Date is 2001-12-07 (P.D.S)   /
					;*****************************************

					;"XPLODE.LSP"에서 빌려온 리습이므로 기존 "XP"명령이 중복된당....확인하고 쓰길바래!!! ^.^
					;(old-sn),(new-sn)은 오스냅관련 콘트롤이니까 알아서 고치던지 말던지....후후

;;; --------------------------------------------------------------------------;
(defun la-set (a b)
  (setq old-la (getvar "CLAYER"))
  (if (tblsearch "LAYER" a)
    (command "layer" "s" a "")
    (command "layer" "m" a "c" b a "")
  )
)


(defun new_blk (/ a pt1 aa aaa e0 en bb)
  (old-sn)
  (la-set "E-PLAN" 253)
  (prompt "\n Select Inserting-Block : ")
					;	(setq a (entsel))
					;	(setq pt1 (cdr (assoc 10 (entget (setq aaa (car a))))))
  (setq a (entlast))
  (setq pt1 (cdr (assoc 10 (entget (setq aaa a)))))
  (setq e0 (entlast))
  (setq en (entnext e0))
  (while (not (null en))		; find the last entity
    (setq e0 en)
    (setq en (entnext e0))
  )
  (command "explode" (xp_val -1 aaa nil))
					;	(command "explode" a)
  (setq aa (ssadd))
  (while (entnext e0)
    (ssadd (setq e0 (entnext e0)) aa)
  )

  (setq color (xp_scn))
  (setq layer (xp_sla))

  (prompt "\n Block explode complete....")
  (prompt
    "\n Select Remove Entity's of New-Block's ? <All is Enter> : "
  )
  (setq bb (ssget))
  (if bb
    (progn
      (command "chprop" aa "R" bb "" "c" color "la" layer "")
      (command "block" bl-n "Y" pt1 aa "R" bb "")
    )
    (progn
      (command "chprop" aa "" "c" color "la" layer "")
      (command "block" bl-n "Y" pt1 aa "")
    )
  )
  (new-sn)
)

(defun c:xpp (/ a1 a2 po1 bl-n)
  (setq a1 (entsel " Enter Pick for \"Xplode\" : "))
  (if a1
    (setq bl-n (cdr (assoc 2 (setq a2 (entget (car a1))))))
  )
  (prompt " Enter Block ")
  (prin1 bl-n)
  (setq po1 (getpoint " Isert-Point ? : "))
  (command "insert" bl-n po1 "" "" "")
  (new_blk)
)

(defun xp_val (n e f)
  (if f
    (cdr (assoc n e))
    (cdr (assoc n (entget e)))
  )
)

;;; --------------------------------------------------------------------------;
;;; xp_scn == XPlode_Set_Color_Number
;;; --------------------------------------------------------------------------;

(defun xp_scn ()
  (setq arg 257)
  (while (> arg 256)
    (initget 2
	     "Red Yellow Green Cyan Blue Magenta White BYLayer BYBlock"
    )
    (setq arg (getint (strcat "\n\nNew color for exploded entities.  "
			      "\nRed/Yellow/Green/Cyan/Blue/"
			      "Magenta/White/BYLayer/BYBlock/<"
			      (if (= (type (getvar "cecolor")) 'INT)
				(itoa (getvar "cecolor"))
				(getvar "cecolor")
			      )
			      ">: "
		      )
	      )
    )
    (cond
      ((= arg "BYLayer") (setq arg 0))
      ((= arg "Red") (setq arg 1))
      ((= arg "Yellow") (setq arg 2))
      ((= arg "Green") (setq arg 3))
      ((= arg "Cyan") (setq arg 4))
      ((= arg "Blue") (setq arg 5))
      ((= arg "Magenta") (setq arg 6))
      ((= arg "White") (setq arg 7))
      ((= arg "BYBlock") (setq arg 256))
      ((= arg nil) (setq arg (atoi (getvar "CECOLOR"))))
      (T
       (if (= (type arg) 'INT)
	 (if (> arg 255)
	   (progn
	     (princ "\nColor number out of range 1 - 255. ")
	     (setq arg 257)
	   )
	 )
	 (setq arg
		(if (= (type (setq arg (getvar "cecolor"))) 'INT)
		  (getvar "cecolor")
		  (cond
		    ((= arg "BYLAYER") (setq arg 0))
		    ((= arg "BYBLOCK") (setq arg 256))
		  )
		)
	 )
       )
      )
    )
  )
					;	(prin1 arg)(pause)
  (cond
    ((= arg 0) (setq arg "BYBLOCK"))
    ((= arg 256) (setq arg "BYLAYER"))
  )
  arg
)

;;; --------------------------------------------------------------------------;
;;; xp_slt == XPlode_Set_Line_Type
;;; --------------------------------------------------------------------------;

(defun xp_slt ()
  (princ "\n\nChoose from the following list of linetypes. ")
  (tblnext "ltype" T)
  (setq	xp_lta "CONTINUOUS,CONT BYLayer BYBlock"
	xp_ltb "BYBlock/BYLayer/CONTinuous"
  )
  (while (setq xp_lt (cdr (assoc 2 (tblnext "ltype"))))
    (setq xp_lta (strcat xp_lta " " xp_lt)
	  xp_ltb (strcat xp_ltb "/" xp_lt)
    )
  )
  (initget xp_lta)
  (princ
    (strcat "\nEnter new linetype name. \n"
	    xp_ltb
	    "/<"
	    (getvar "celtype")
	    "> : "
    )
  )
  (setq xp_nln (getkword))
  (if (or (= xp_nln nil) (= xp_nln ""))
    (setq xp_nln (getvar "celtype"))
  )
  xp_nln
)

;;; --------------------------------------------------------------------------;
;;; xp_sla == XPlode_Set_LAyer
;;; --------------------------------------------------------------------------;

(defun xp_sla (/ temp)
  (while (null temp)
    (initget 1)
    (setq temp (getstring (strcat "\n\nXPlode onto what layer?  <"
				  (getvar "clayer")
				  ">: "
			  )
	       )
    )
    (if	(or (= temp "") (null temp))
      (setq temp (getvar "clayer"))
      (if (not (tblsearch "layer" temp))
	(progn
	  (princ "\nInvalid layer name. ")
	  (setq temp nil)
	)
      )
    )
  )
  temp
)

;;; --------------------------------------------------------------------------;
;;; --------------------------------------------------------------------------;

(defun c:xp () (c:xpp))
(defun c:xplode () (c:xpp))

;(princ "\n\tC:XPP loaded.  Start command with XPP or XP or XPLODE.")
;(princ)



;JCMARK.LSP
;*---------------drag & radian----------------------------
(defun dtr (a) (* pi (/ a 180.0)))
(defun rtd (a) (/ (* a 180.0) pi))

					;*---------------osnap mode-------------------------------
(defun old-non () (set-os 0))

(defun set-os (a)
  (setq olds (getvar "osmode"))
  (setvar "osmode" a)
  (prompt " \"OSMODE\" is Change at [")
  (prin1 a)
  (prompt "] ")
)

(defun new-sn ()
  (setvar "OSMODE" olds)
  (prompt "\n \"OSMODE\" is Return at [")
  (prin1 olds)
  (prompt "] ")
  (setq olds nil)
  (prin1)
)

(DEFUN SNAP-RO () (SETVAR "ORTHOMODE" 1))

;;================= Main Program -1 =========================
(defun c:cmm4 ()
					;  (call_cmm_size)
	(la-set "Revision_e" 7)
	(cmark-4)
	(la-back)
)

(defun call_cmm_size (/ a)
  (if (= cmm_key nil)
    (setq cmm_key 800.0)
  )
  (prompt "\n ARC Radius ? *800/1200/1600* :<")
  (prin1 cmm_key)
  (prompt "> : ")
  (setq a (getint))
  (if (or (= a nil) (= a ""))
    (setq a cmm_key)
  )
  (setq cmm_key a)
)

(defun cmark-4
	       (/	p1	p2	p3	p4	po-x1	po-x2
		po-y1	po-y2	ps	ps2	ps2c	po-xlw	po-xhi
		po-ylw	po-yhi	lt-scale	r-dist	x-dist	x-mdist
		y-dist	y-mdist	x-ang	p1s	key	key_1	key_2
	       )
  (old-non)
  (snap-ro)

  (if (= cmm_key nil)
    (call_cmm_size)
  )

  (prompt "\n First Point for C-mark ? <")
  (prin1 cmm_key)
  (setq p1 (getpoint "> :"))

  (if (= p1 nil)
    (progn
      (call_cmm_size)
      (setq p1 (getpoint "\n First Point for C-mark ? :"))
    )
  )

  (setq	p1s p1
	key 3
	key_1 1
	key_2 nil
  )
  (setq lt-scale (getvar "LTSCALE"))
  (setq r-dist (* cmm_key (/ lt-scale 100)))
  (while key
    (setq p2 nil)
    (setq p2 (getpoint p1 "\n Second Point ? :"))
    (if	p2
      (progn
	(setq x-dist (distance p1 p2))
	(setq x-ang (angle p1 p2))
	(setq x-mdist (fix (/ x-dist (* cmm_key (/ lt-scale 100)))))
	(if (< x-mdist 1)
	  (setq x-mdist 1)
	)
	(setq x-dist (/ x-dist x-mdist))
	(setq ps p1)
	(if key_1
	  (command "PLINE" ps "W" 0 0 "A")
	)
	(repeat	x-mdist
	  (setq
	    ps2c (polar ps (dtr (+ (rtd x-ang) 327)) (/ r-dist 1.9))
	  )
	  (setq ps2 (polar ps x-ang x-dist))
	  (command "S" ps2c ps2)
	  (setq ps ps2)
	)
	(setq p1 p2)
	(setq key_1 nil)
      )
      (progn

;;; <Enter> key is End-Point=Start-Point --> C-Mark is Close......
					;        (setq p2 p1s)
					;        (setq x-dist (distance p1 p2))
					;        (setq x-ang(angle p1 p2))
					;        (setq x-mdist (fix (/ x-dist (* cmm_key (/ lt-scale 100)))))
					;        (if (< x-mdist 1)(setq x-mdist 1))
					;        (setq x-dist (/ x-dist x-mdist))
					;        (setq ps p1)
					;        (if key_1 (command "PLINE" ps "W" 0 0 "A"))
					;        (repeat x-mdist
					;          (setq ps2c (polar ps (dtr (+ (rtd x-ang) 327)) (/ r-dist 1.9)))
					;          (setq ps2 (polar ps x-ang x-dist))
					;          (command "S" ps2c ps2)
					;          (setq ps ps2)
					;        )
					;        (command "")
;;; End of Close......

	(prompt "\n ** Game is Over **  By By By....")
	(prompt "\n Press *CANCEL* *CANCEL* *CANCEL* ")
	(setq key nil
	      key_2 2
	)
      )
    )
  )
  (if key_2
    (command "")
  )
  (new-sn)
  (prin1)
)
;;=================== End Program -1 =========================

;;================= Main Program -2 =========================
(defun C:CMM1 () (la-set "Revision_e" 7)(setq cmm_key 800) (c-mark)(la-back))
(defun C:CMM2 () (la-set "Revision_e" 7)(setq cmm_key 1200) (c-mark)(la-back))
(defun C:CMM3 () (la-set "Revision_e" 7)(setq cmm_key 1600) (c-mark)(la-back))

(defun C:CMM ()
					;  (call_cmm_size)
	(la-set "Revision_e" 7)
	(c-mark)
	(la-back)
)

(defun C-MARK
	      (/	p1	 p2	  p3	   p4	    po-x1
	       po-x2	po-y1	 po-y2	  ps	   ps2	    ps2c
	       po-xlw	po-xhi	 po-ylw	  po-yhi   lt-scale r-dist
	       x-dist	x-mdist	 y-dist	  y-mdist
	      )

  (old-sn)
  (snap-ro)

  (if (= cmm_key nil)
    (call_cmm_size)
  )

  (prompt "\n First Point for C-mark ? <")
  (prin1 cmm_key)
  (setq p1 (getpoint "> :"))

  (if (= p1 nil)
    (progn
      (call_cmm_size)
      (setq p1 (getpoint "\n First Point for C-mark ? :"))
    )
  )

  (setq p2 (getcorner p1 "\n Second Point ? :"))

  ;;----------------- Getpoint p1 p2 p3 p4
  (setq	po-x1 (car p1)
	po-x2 (car p2)
	po-y1 (cadr p1)
	po-y2 (cadr p2)
  )

  (if (< po-x1 po-x2)
    (setq po-xlw po-x1
	  po-xhi po-x2
    )
    (setq po-xlw po-x2
	  po-xhi po-x1
    )
  )
  (if (< po-y1 po-y2)
    (setq po-ylw po-y1
	  po-yhi po-y2
    )
    (setq po-ylw po-y2
	  po-yhi po-y1
    )
  )

  (setq p1 (list po-xlw po-ylw))
  (setq p2 (list po-xhi po-ylw))
  (setq p3 (list po-xhi po-yhi))
  (setq p4 (list po-xlw po-yhi))

  ;;----------------- Drawing Pline's Arc-mode
					;- Xlw -> Xhi
  (setq lt-scale (getvar "LTSCALE"))
  (setq r-dist (* cmm_key (/ lt-scale 100)))

  (setq x-dist (distance p1 p2))
  (setq x-mdist (fix (/ x-dist (* cmm_key (/ lt-scale 100)))))
  (if (< x-mdist 1)
    (setq x-mdist 1)
  )
  (setq x-dist (/ x-dist x-mdist))

  (setq ps p1)
  (command "PLINE" ps "W" 0 0 "A")
  (repeat x-mdist
    (setq ps2c (polar ps (dtr (+ 0 327)) (/ r-dist 1.9)))
    (setq ps2 (polar ps (dtr 0) x-dist))
    (command "S" ps2c ps2)
    (setq ps ps2)
  )
					;  (command "")

					;- Xhi -> Yhi
  (setq y-dist (distance p1 p4))
  (setq y-mdist (fix (/ y-dist (* cmm_key (/ lt-scale 100)))))
  (if (< y-mdist 1)
    (setq y-mdist 1)
  )
  (setq y-dist (/ y-dist y-mdist))

  (setq ps p2)
					;  (command "PLINE" ps "W" 0 0 "A")
  (repeat y-mdist
    (setq ps2c (polar ps (dtr (+ 90 327)) (/ r-dist 1.9)))
    (setq ps2 (polar ps (dtr 90) y-dist))
    (command "S" ps2c ps2)
    (setq ps ps2)
  )
					;  (command "")

					;- Yhi -> Ylw
  (setq ps p3)
					;  (command "PLINE" ps "W" 0 0 "A")
  (repeat x-mdist
    (setq ps2c (polar ps (dtr (+ 180 327)) (/ r-dist 1.9)))
    (setq ps2 (polar ps (dtr 180) x-dist))
    (command "S" ps2c ps2)
    (setq ps ps2)
  )
					;  (command "")

					;- Yhi -> Ylw
  (setq ps p4)
					;  (command "PLINE" ps "W" 0 0 "A")
  (repeat y-mdist
    (setq ps2c (polar ps (dtr (+ 270 327)) (/ r-dist 1.9)))
    (setq ps2 (polar ps (dtr 270) y-dist))
    (command "S" ps2c ps2)
    (setq ps ps2)
  )
  (command "")
  (new-sn)
  (prin1)
)
;;=================== End Program -2 =========================

(defun draw_cmm_mark (cmm_key cp1 cp2)
  (setq lt-scale (getvar "LTSCALE"))
  (setq r-dist (* cmm_key (/ lt-scale 100)))
  (setq x-dist (distance cp1 cp2))
  (setq x-ang (angle cp1 cp2))
  (setq x-mdist (fix (/ x-dist (* cmm_key (/ lt-scale 100)))))
  (if (< x-mdist 1)
    (setq x-mdist 1)
  )
  (setq x-dist (/ x-dist x-mdist))
  (setq ps cp1)
  (repeat x-mdist
    (setq ps2c (polar ps (dtr (+ (rtd x-ang) 327)) (/ r-dist 1.9)))
    (setq ps2 (polar ps x-ang x-dist))
    (command "S" ps2c ps2)
    (setq ps ps2)
  )
)

					;WLTG.LSP
(defun c:sw1 () (command "insert" "sw1"))
(defun c:sw2 () (command "insert" "sw2"))
(defun c:sw3 () (command "insert" "sw3"))
(defun c:sw4 () (command "insert" "sw4"))
(defun c:swg () (command "insert" "swg"))

					;JBLOCK.LSP
					;*****************************************************
					; - This program is Block-Control (JBLOCK.LSP)       /
					;   command:"JBLOCK, JJB, S8, S9, MIEP, SS9"         /
;;;------------------------------                    /
;;; Make by Park Dae-sig                             /
;;; Date is 1997-08-05                               /
;;; Where is "JIN" Electric co.                      /
;;; (HP) 018-250-7324                                /
;;;------------------------------                    /
					; - Last Up-Date is 1998-10-10 (P.D.S)               /
					;*****************************************************

					;--------------------------------------------------------------------------
(setq jinbox_bl (load_dialog "jblock"))	; Loading Dialog-Box

(defun help_jjb () (acad_helpdlg "lisp-hlp.hlp" "block"))

(defun C:JJB () (c:jblock))
(defun C:JBLOCK	(/ jinbox xxx)
  (if (= jinbox_bl nil)
    (setq jinbox_bl (load_dialog "jblock"))
  )
  (new_dialog "jinblock" jinbox_bl)
  (setq	xxx  3
	jkey nil
  )
  (action_tile "jbct" "(setq jkey 1)(done_dialog)")
  (action_tile "jbeb" "(setq jkey 2)(done_dialog)")
  (action_tile "jbsb" "(setq jkey 3)(done_dialog)")
  (action_tile "jbch" "(setq jkey 4)(done_dialog)")
  (action_tile "jbep1" "(setq jkey 5)(done_dialog)")
  (action_tile "jbep2" "(setq jkey 6)(done_dialog)")
  (action_tile "jbep3" "(setq jkey 7)(done_dialog)")
  (action_tile "jbwb" "(setq jkey 8)(done_dialog)")
  (action_tile "jbbl" "(setq jkey 9)(done_dialog)")
  (action_tile "jbxp" "(setq jkey 10)(done_dialog)")
  (action_tile "jdel1" "(setq jkey 11)(done_dialog)")
  (action_tile "jbs7" "(setq jkey 12)(done_dialog)")
  (action_tile "pds_key" "(setq jkey 98)(done_dialog)")
  (action_tile "help" "(help_jjb)")
  (setq xxx (start_dialog))
  (action_tile "accept" "(done_dialog)")
  (action_tile "cancel" "(setq jkey 11)(done_dialog)")
  (done_dialog)
  (if jkey
    (jsel_run_b jkey)
  )
  (prin1)
)

(defun jsel_run_b (a)
  (cond
    ((= a 1) (c:ctt))
    ((= a 2) (c:ebk))
    ((= a 3) (c:sbk))
    ((= a 4) (c:chbb))
    ((= a 5) (blep))
    ((= a 6) (c:miep))
    ((= a 7) (c:blo_exp))
    ((= a 8) (command "wblock" "~"))
    ((= a 9) (command "block"))
    ((= a 10) (c:xp))
    ((= a 11) (jsel_not))
    ((= a 12) (c:s7))
    ((= a 98) (pds_key))
  )
)

(defun jsel_not () (prompt "\n Select is \"Cancel\"... "))

(defun blep ()
  (setq a (sel_block))
  (setq nl (sslength a))
  (setq n (- nl 1))
  (setq i 0)
  (while (<= i n)
    (setq e2 (entget (setq e1 (ssname a i))))
    (command "explode" e1)
    (setq i (1+ i))
  )
)

(defun C:MIEP (/ sold tag bl bl1 i n nl p3)
  (setq	olderr	*error*
	*error*	myerror
	chm	0
  )
  (setq lay (getvar "CLAYER"))
  (prompt "\n\t Exploding at [Mirring Block] Only")
  (old-non)
  (setq tag (sel_block))
  (if tag
    (progn
      (setq i 0)
      (setq nl (sslength tag))
      (setq n (- nl 1))
      (while (<= i n)
	(setq bl (entget (setq bl1 (ssname tag i))))
	(setq x (cdr (assoc 41 bl)))
	(setq y (cdr (assoc 42 bl)))
	(setq z (cdr (assoc 43 bl)))
	(cond
	  ((< x 0.0) (miep bl1))
	  ((< y 0.0) (miep bl1))
	  ((< z 0.0) (miep bl1))
	  (T (miep2 bl1))
	)
	(setq i (1+ i))
      )
    )
  )
  (prompt "\n !! Mirror & Explode was Complete !! ")
  (new-sn)
)

(defun miep (bl1)
  (setq p3 (getvar "VIEWCTR"))
  (command "Mirror" bl1 "" p3 "@100<90" "Y")
  (command "Explode" bl1)
  (command "Mirror" "P" "" p3 "@100<90" "Y")
)

(defun miep2 (bl1) (command "Explode" bl1))

;;-------------------------------------------------------------------------
;;-------------------------------------------------------------------------
;;-------------------------------------------------------------------------
(defun c:s7 () (jblock_s7 nil))
(defun jblock_s7 (sel_na / b_name sbl_na sbl_sc)
  (prompt
    "\t *** Block Groop Scale - ( Mong-DDang Scale ) ***"
  )
  (if (null sel_na)
    (progn
      (setq b_name (car (entsel "\n\t [ Pick the BLOCK ] :")))
      (if (= b_name nil)
	(setq sbl_na
	       (strcase	(getstring "\n [ What is the Block name ? ] :")
	       )
	)
	(setq sbl_na (cdr (assoc 2 (entget b_name))))
      )
      (if (= b_name nil)
	(prompt "\Block Scale ????")
	(setq sbl_sc (cdr (assoc 41 (entget b_name))))
      )
    )
    (progn
      (setq sbl_na sel_na)
      (prompt "\Block Scale ????")
    )
  )
  (setq jinbox2 (load_dialog "jblock"))
  (new_dialog "jinblock2" jinbox2)
  (set_tile "jsbn" sbl_na)
  (if sbl_sc
    (set_tile "jsbs" (rtos sbl_sc 2 4))
  )
  (setq	xxx  3
	jkey nil
  )
  (while (> xxx 2)
    (action_tile "jsa" "(setq jkey 1)(done_dialog)")
    (action_tile "jsr" "(setq jkey 2)(done_dialog)")
    (action_tile "jsn" "(setq jkey 3)(done_dialog)")
    (action_tile "jss" "(setq jkey $value)(done_dialog)")
    (setq xxx (start_dialog))
  )
  (action_tile "accept" "(jsel_run_b2 jkey)(done_dialog)")
  (action_tile "cancel" "(setq jkey nil)(done_dialog)")
  (done_dialog)
  (if jkey
    (jsel_run_b2 jkey)
  )
  (unload_dialog jinbox2)
  (prin1)
)

(defun jsel_run_b2 (jkey)
  (cond
    ((= jkey 1) (scale_n "A"))
    ((= jkey 2) (scale_n "R"))
    ((= jkey 3) (scale_n "N"))
    (T (scale_n "S"))
  )
)

;;;------------------------------------------------------------------------
(defun scale_n (jja)
  (old-non)
  (prompt
    "\n *!*!* Select of Changing Block / [Enter] is Select-All : "
  )
  (setq a (ssget (list (cons 0 "INSERT") (cons 2 sbl_na))))
  (if (= a nil)
    (setq a (ssget "X" (list (cons 0 "INSERT") (cons 2 sbl_na))))
  )
  (setq nl (sslength a))
  (setq n (- nl 1))
  (prompt "\n Select Block [")
  (prin1 sbl_na)
  (prompt "] is => ")
  (prin1 nl)
  (prompt "EA :")
  (setq	i 0
	tr1 0
  )

  (if (= jja "N")
    (setq old-sc (getreal "\n\t Enter Select Block-Scale ? : "))
  )
  (if (= jja "N")
    (setq new-sc (getreal "\n\t Enter New Setting Scale ? : "))
  )
  (if (= jja "R")
    (setq old-sc (getreal "\n\t Enter Defaoult Scale ? : "))
  )
  (if (= jja "R")
    (setq new-sc (getreal "\n\t Enter New Setting Scale ? : "))
  )
  (if (= jja "A")
    (setq old-sc 1)
  )
  (if (= jja "A")
    (setq new-sc (getreal "\n\t Enter New Setting Scale ? : "))
  )
  (if (= jja "S")
    (setq old-sc 1)
  )
  (if (= jja "S")
    (setq new-sc (atof jkey))
  )

  (while (<= i n)
    (setq ed (entget (setq e2 (ssname a i))))
    (setq sca (ABS (cdr (assoc 41 ed))))
    (if	(= jja "A")
      (setq old-sc sca)
    )
    (setq sca-1 (rtos sca 2 8))
    (cond
      ((= jja "N")
       (if (= sca-1 (rtos old-sc 2 8))
	 (ch-sc old-sc new-sc)
       )
      )
      ((= jja "R") (ch-sc old-sc new-sc))
      ((= jja "A") (ch-sc old-sc new-sc))
      ((= jja "S") (ch-sc old-sc new-sc))
      (T (err))
    )
    (setq i (+ i 1))
  )
  (setq scc nil)
  (new-sn)
  (prompt "\n\t changed block is [")
  (prin1 sbl_na)
  (prompt "] ---> ")
  (prin1 tr1)
  (prompt "/")
  (prin1 i)
)

;;------------------------------------------------------------------------
(defun ch-sc (old-sc new-sc)
  (setq pnt (cdr (assoc 10 ed)))
  (command "scale" e2 "" pnt "r" old-sc new-sc)
  (setq tr1 (+ tr1 1))
)


;;----------------------------------------------------------------------------
;;----------------------------------------------------------------------------
(defun C:S9 (/ sold tag bl bl1 i n nl p3)
  (setq	olderr	*error*
	*error*	myerror
	chm	0
  )
  (if (= bl-sc9 nil)
    (setq bl-sc9 1.0)
  )
  (prompt "\n\t SCALE at [")
  (prin1 bl-sc9)
  (prompt "] ")
  (prompt " and Select Object / Scale(Enter) : ")
  (setq tag (ssget))
  (if tag
    (progn
      (old-non)
      (setq p3 (getpoint "\n Enter Base Point ? : "))
      (command "Scale" tag "" p3 bl-sc9)
      (new-sn)
    )
    (progn
      (setq bl-sc9 (getreal "\n Enter Scale Factor ? : "))
    )
  )
  (prin1)
)

;;----------------------------------------------------------------------------
(DEFUN C:S8 (/ a b c)
  (IF KEY-S8
    (progn
      (prompt "\t Scale command { S8 } : Working ")
      (old-sn)
      (setq a (getpoint "\n First corner ? : "))
      (setq b (getcorner a "\t Other corner ? : "))
      (setvar "OSMODE" 32)
      (setq c (getpoint "\n Enter Base Point ? : <Int>"))
      (COMMAND "SCALE" "C" a b "" c KEY-S8)
      (new-sn)
    )
    (PROGN
      (prompt "\t Scale command { S8 } : Setting ")
      (SETQ A (GETREAL "\n Enter Old Scale ? :"))
      (setq b (getreal "\n Enter New Scale ? :"))
      (setq key-s8 (/ b a))
      (prompt "\n KEY-S8 is { ")
      (prin1 key-s8)
      (prompt " }... ")
    )
  )
  (prompt "\n Change Scale is --> SS8 !! ")
  (prin1)
)

(defun c:ss8 () (setq key-s8 nil) (c:s8))


					;JDWGS.LSP
					;*****************************************************
					; - This program is Drawing Base-Setting             /
					;   command:"DWGS"                                   /
;;;------------------------------                    /
;;; Make by Park Dae-sig                             /
;;; Date is 1998-07-02                               /
;;; Where is "JIN" Electric co.                      /
;;; (HP) 018-250-7324                                /
;;;------------------------------                    /
					; - Last Up-Date is 1998-10-10 (P.D.S)               /
					;*****************************************************

					;-------------------------------------------------------------------------
(defun Y3NAME (/ x1 x2 y1 y2)
  (setq x1 (strlen (setq x2 (getvar "dwgprefix"))))
  (setq y1 (strlen (setq y2 (getvar "dwgname"))))
  (cond
    ((< y1 9) (setq y3 y2))
    ((= x1 y1) (setq y3 y2))
    ((> y1 x1) (setq y3 (substr y2 (+ x1 1) y1)))
    ((< y1 x1) (setq y3 y2))
  )
  (setq _dwgname y3)
)

					;----------------------------------------------------------------------------
					;----------------------------------------------------------------------------
(defun brfsett (key)
  (setq	br-wdh1	(* key 1.5)
	br-wdv1	(* key 2.0)
	br-wdh2	(* key 2.3)
	br-wdh3	(* key 3.2)
	br-wdv3	(* key 2.3)
	key-n	key
  )
  (setvar "userr5" key-n)
  (prompt ",[brf OK!],")
					;   (prompt "\n !!! Wire's Break-Width : ")(prin1 key-n)
)

(defun brksett (bbb)
  (setq bk1 bbb)
  (setvar "userr2" bk1)
  (prompt ",[brk OK!],")
)

(defun wirsett (wir)
  (setq wire-scale wir)
  (setvar "USERR3" wire-scale)
  (prompt ",[wir OK!],")
)

(defun dwgsett (dwg)
  (setq dwg-scale (/ dwg 100))
  (setvar "LTSCALE" dwg)
  (setvar "USERR1" dwg-scale)
  (setq ard nil)
  (setq	lmx "0,0"
	lmy (list (* dwg 841) (* dwg 594))
  )
  (command "limits" lmx lmy)
					;   (setq key-n dwg)
					;   (prompt "\n !!! Return of Wire's Break-Width !!! ")
  (prompt ",[dwg OK!],")
  (prin1)
)

(defun dimsett (dsc / p1 a)
  (command "layer" "unlock" "*" "")
  (setq p1 (getvar "VIEWCTR"))
  (command ".insert"
	   "dimdot"
	   p1
	   ""
	   ""
	   ""
	   "ERASE"
	   (entlast)
	   ""
  )
  (command "dim"      "dimblk"	 "dimdot"   "dimasz"   "1.3"
	   "dimcen"   "-1"	 "dimdle"   "2"	       "dimblk1"
	   "dimdot"   "dimblk2"	 "dimdot"   "dimdli"   "8"
	   "dimexe"   "2"	 "dimexo"   "2"	       "dimlfac"
	   "1"	      "dimtad"	 "1"	    "dimtih"   "off"
	   "dimtix"   "on"	 "dimtm"    "0"	       "dimtoh"
	   "on"	      "dimtol"	 "off"	    "dimtxt"   "2.5"
	   "dimse1"   "off"	 "dimse2"   "off"      "dimassoc"
	   "1"	      "dimclre"	 "bylayer"  "dimclrd"  "bylayer"
	   "dimclrt"  "bylayer"	 "dimtofl"  "on"       "dimgap"
	   1	      "dimunit"	 2	    "dimdec"   0
	   "exit"
	  )
  (setvar "dimscale" dsc)
  (prompt ",[dim OK!],")
  (setq a (ssget "X" (list (cons 0 "DIMENSION"))))
  (if a
    (command "dim1" "update" a "")
  )
)

					;----------------------------------------------------------------------------
					;----------------------------------------------------------------------------
(defun jget (a) (get_tile a))

(defun nosetting ()
  (setq	ddwgs nil
	djbrw nil
	djwis nil
	djiss nil
	djbrf nil
	ooo nil
	sss nil
	bbb nil
	ggg nil
	jdot nil
	getxx nil
  )
)

(defun dwgsetting ()
  (if ooo
    (setvar "ORTHOMODE" (atoi ooo))
  )
  (if sss
    (setvar "SNAPMODE" (atoi sss))
  )
  (if ggg
    (setvar "GRIDMODE" (atoi ggg))
  )
  (if bbb
    (setvar "BLIPMODE" (atoi bbb))
  )
  (if jdot
    (setvar "LUPREC" jdot)
  )
  (if jdot
    (setvar "DIMDEC" jdot)
  )
)

(defun sc_def ()
  (setq getxx (atoi (get_tile "jds_li")))
  (cond
    ((= 0 getxx) (setq sc_li 1))
    ((= 1 getxx) (setq sc_li 2))
    ((= 2 getxx) (setq sc_li 10))
    ((= 3 getxx) (setq sc_li 20))
    ((= 4 getxx) (setq sc_li 30))
    ((= 5 getxx) (setq sc_li 40))
    ((= 6 getxx) (setq sc_li 50))
    ((= 7 getxx) (setq sc_li 60))
    ((= 8 getxx) (setq sc_li 75))
    ((= 9 getxx) (setq sc_li 80))
    ((= 10 getxx) (setq sc_li 100))
    ((= 11 getxx) (setq sc_li 150))
    ((= 12 getxx) (setq sc_li 200))
    ((= 13 getxx) (setq sc_li 250))
    ((= 14 getxx) (setq sc_li 300))
    ((= 15 getxx) (setq sc_li 400))
    ((= 16 getxx) (setq sc_li 500))
    ((= 17 getxx) (setq sc_li 600))
    ((= 18 getxx) (setq sc_li 700))
    ((= 19 getxx) (setq sc_li 750))
    ((= 20 getxx) (setq sc_li 800))
  )
  (setq ddwgs sc_li)
  (setq djwis (/ sc_li 100.0))
  (setq djiss sc_li)
  (setq djbrw (* sc_li 2))
  (setq djbrf sc_li)
  (set_tile "jdws" (rtos ddwgs 2 0))
  (set_tile "jwis" (rtos djwis 2 4))
  (set_tile "jdis" (rtos djiss 2 0))
  (set_tile "jbrw" (rtos djbrw 2 0))
  (set_tile "jbrf" (rtos djbrf 2 4))
  (setq ddwgs (rtos ddwgs 2 0))
  (setq djwis (rtos djwis 2 4))
  (setq djiss (rtos djiss 2 0))
  (setq djbrw (rtos djbrw 2 0))
  (setq djbrf (rtos djbrf 2 4))

)

					;----------------------------------------------------------------------------
					;-------------------------  Main Program  -----------------------------------
					;----------------------------------------------------------------------------

(defun lt_sc_get (/ lt_sc)
  (setq lt_sc (getvar "LTSCALE"))
  (setq lt_sc_key nil)
  (cond
    ((= 1.0 lt_sc) (setq lt_sc_key "0"))
    ((= 2.0 lt_sc) (setq lt_sc_key "1"))
    ((= 10.0 lt_sc) (setq lt_sc_key "2"))
    ((= 20.0 lt_sc) (setq lt_sc_key "3"))
    ((= 30.0 lt_sc) (setq lt_sc_key "4"))
    ((= 40.0 lt_sc) (setq lt_sc_key "5"))
    ((= 50.0 lt_sc) (setq lt_sc_key "6"))
    ((= 60.0 lt_sc) (setq lt_sc_key "7"))
    ((= 75.0 lt_sc) (setq lt_sc_key "8"))
    ((= 80.0 lt_sc) (setq lt_sc_key "9"))
    ((= 100.0 lt_sc) (setq lt_sc_key "10"))
    ((= 150.0 lt_sc) (setq lt_sc_key "11"))
    ((= 200.0 lt_sc) (setq lt_sc_key "12"))
    ((= 250.0 lt_sc) (setq lt_sc_key "13"))
    ((= 300.0 lt_sc) (setq lt_sc_key "14"))
    ((= 400.0 lt_sc) (setq lt_sc_key "15"))
    ((= 500.0 lt_sc) (setq lt_sc_key "16"))
    ((= 600.0 lt_sc) (setq lt_sc_key "17"))
    ((= 700.0 lt_sc) (setq lt_sc_key "18"))
    ((= 750.0 lt_sc) (setq lt_sc_key "19"))
    ((= 800.0 lt_sc) (setq lt_sc_key "20"))
    (T (prompt "\n Drawing Scale is Not-Matching "))
  )
)

(setq jinbox_dw (load_dialog "jdwgs"))	; Loading Dialog-Box
(defun help_dwgs () (acad_helpdlg "lisp-hlp.hlp" "dwgs"))

(defun C:DWGS (/  o-m	b-m	s-m	g-m	ddwgs	djwis
						djiss	djbrw	djbrf	xxx	jdot	ooo	sss
						ggg	bbb	dim-scale	lt-scale		jinbox_dw
						kkkk	jlww	kkkk2
					)
	(setq pds-xxx nil)
	(setq jlww nil)
	(setq	kkkk nil
			kkkk2 nil
	)
	(command "Ucsicon" "on")
	(command "UCSICON" "N")
	(setvar "LUNITS" 2)
	(setq	lt-scale   (GETVAR "LTSCALE")
			bk1	   (GETVAR "USERR2")
			wire-scale (GETVAR "USERR3")
			key-n	   (GETVAR "USERR5")
			dim-scale  (GETVAR "DIMSCALE")
			o-m	   (GETVAR "ORTHOMODE")
			b-m	   (GETVAR "BLIPMODE")
			s-m	   (GETVAR "SNAPMODE")
			g-m	   (GETVAR "GRIDMODE")
	)
	(lt_sc_get)
	(if (= jinbox_dw nil)
		(setq jinbox_dw (load_dialog "jdwgs"))
	)
	(setq xxx 3)
	(new_dialog "jinbox" jinbox_dw)
	(if lt-scale
		(set_tile "jdws" (rtos lt-scale 2 1))
	)
	(if wire-scale
		(set_tile "jwis" (rtos wire-scale 2 4))
	)
	(if dim-scale
		(set_tile "jdis" (rtos dim-scale 2 1))
	)
	(if bk1
		(set_tile "jbrw" (rtos bk1 2 1))
	)
	(if key-n
		(set_tile "jbrf" (rtos key-n 2 1))
	)
	(if lt_sc_key
		(set_tile "jds_li" lt_sc_key)
	)

	(setq lll (getvar "LUPREC"))
	(cond
		((= lll 0) (set_tile "jdot0" "1"))
		((= lll 2) (set_tile "jdot2" "1"))
		((= lll 4) (set_tile "jdot4" "1"))
		(T (set_tile "jdot4" "1"))
	)
	(setq lll nil)

	(if (= line-work "Light")
		(set_tile "jlww1" "1")
		(set_tile "jlww2" "1")
	)

	(set_tile "jotm" (itoa o-m))
	(set_tile "jblm" (itoa b-m))
	(set_tile "jsnm" (itoa s-m))
	(set_tile "jgrm" (itoa g-m))
	(set_tile "jname" (getvar "DWGNAME"))
	(while (> xxx 2)
		(action_tile "jdws" "(setq ddwgs $value)")
		(action_tile "jwis" "(setq djwis $value)")
		(action_tile "jdis" "(setq djiss $value)")
		(action_tile "jbrw" "(setq djbrw $value)")
		(action_tile "jbrf" "(setq djbrf $value)")
		(action_tile "jotm" "(setq ooo $value)")
		(action_tile "jsnm" "(setq sss $value)")
		(action_tile "jgrm" "(setq ggg $value)")
		(action_tile "jblm" "(setq bbb $value)")
		(action_tile "jlimit" "(setq kkkk 1)(done_dialog)")
		(action_tile "jdot0" "(setq jdot 0)")
		(action_tile "jdot2" "(setq jdot 2)")
		(action_tile "jdot4" "(setq jdot 4)")
		(action_tile "jlww1" "(setq jlww 1)")
		(action_tile "jlww2" "(setq jlww 2)")
		(action_tile "jlltsc1" "(setq kkkk2 1)(done_dialog)")
		(action_tile "pds_key" "(setq pds-xxx 1)(done_dialog)")
		(action_tile "jds_li" "(sc_def)")
		(action_tile "accept" "(dwgsetting)(done_dialog)")
		(action_tile "cancel" "(nosetting)(done_dialog)")
		(action_tile "help" "(help_dwgs)")
		(setq xxx (start_dialog))
	)
	(action_tile "accept" "(dwgsetting)")
	(done_dialog)
	(if kkkk2
		(progn
			(command "layer" "u" "*" "" "chprop" "all" "" "ltscale" "1" "")
			(setvar "CELTSCALE" 1)
		)
	)
	(if ddwgs
		(dwgsett (atof ddwgs))
	)
	(if djbrw
		(brksett (atof djbrw))
	)
	(if djwis
		(wirsett (atof djwis))
	)
	(if djiss
		(dimsett (atof djiss))
	)
	(if djbrf
		(brfsett (atof djbrf))
	)
	(if jlww
		(line-ww jlww)
	)
	(if kkkk
		(c:zaa)
	)
	(if (= pds-xxx 1)
		(pds_key)
	)
	(princ)
)

;; End of Program
;;----------------------------------------------------------------------------

					;----------------------- DCL end ---------------------------------------
					;JWIRE.LSP
					;*****************************************************
					; - This program is Wiring in Drawing (JWIRE.LSP)    /
					;   command:"JJW, JWIRE"                             /
;;;------------------------------                    /
;;; Make by Park Dae-sig                             /
;;; Date is 1997-07-02                               /
;;; Where is "JIN" Electric co.                      /
;;; (HP) 018-250-7324                                /
;;;------------------------------                    /
					; - Last Up-Date is 1998-10-18 (P.D.S)               /
					;*****************************************************

					;--------------------------------------------------------------------------
(defun dtr (a) (* pi (/ a 180.0)))
(defun rtd (a) (/ (* a 180.0) pi))

(defun new-sn ()
  (setvar "osmode" olds)
  (setq olds nil)
  (prin1)
)
(defun old-nea ()
  (setq	olderr	*error*
	*error*	wierror
	chm	0
  )
  (setq snap-ang (getvar "snapang"))
  (setq olds (getvar "osmode"))
  (setvar "osmode" 512)
)
					;
(defun old-mid ()
  (setq olds (getvar "osmode"))
  (setvar "osmode" 2)
)
(defun wierror (s)
  (if (/= s "function cancelled")
    (princ (strcat "\nerror: " s))
  )
  (setvar "osmode" olds)
  (setq *error* olderr)
  (princ)
)

;;-------------------------------------------------------------------------
;;-------------------------------------------------------------------------
(defun jw_ty_set (a)
  (cond
    ((= a 0) (mode_tile "ww1" 2))
    ((= a 1) (mode_tile "ww2" 2))
    ((= a 2) (mode_tile "ww3" 2))
    ((= a 3) (mode_tile "ww4" 2))
    ((= a 4) (mode_tile "ww5" 2))
    ((= a 5) (mode_tile "ww6" 2))
    ((= a 6) (mode_tile "ww7" 2))
    ((= a 7) (mode_tile "ww8" 2))
    ((= a 8) (mode_tile "ww9" 2))
    ((= a 10) (mode_tile "wr2" 2))
    ((= a 11) (mode_tile "wr3" 2))
    ((= a 12) (mode_tile "wr4" 2))
    ((= a 13) (mode_tile "wr5" 2))
    ((= a 14) (mode_tile "wr6" 2))
    ((= a 15) (mode_tile "wr7" 2))
    ((= a 16) (mode_tile "wr8" 2))
    ((= a 17) (mode_tile "wr9" 2))
    ((= a 18) (mode_tile "wh2" 2))
    ((= a 19) (mode_tile "wh3" 2))
    ((= a 20) (mode_tile "wh4" 2))
    ((= a 21) (mode_tile "wh5" 2))
    ((= a 22) (mode_tile "wh6" 2))
    ((= a 23) (mode_tile "wh7" 2))
    ((= a 24) (mode_tile "wh8" 2))
    ((= a 25) (mode_tile "wh9" 2))
    ((= a 41) (mode_tile "lle" 2))
    ((= a 42) (mode_tile "llt" 2))
    ((= a 43) (mode_tile "lltv" 2))
    ((= a 44) (mode_tile "llf" 2))
    ((= a 45) (mode_tile "lls" 2))
    ((= a 46) (mode_tile "llex" 2))
    ((= a 47) (mode_tile "lldc" 2))
    ((= a 48) (mode_tile "llu" 2))
    ((= a 49) (mode_tile "lloa" 2))
  )
)

;;-------------------------------------------------------------------------
(defun jsel_run_w (a)
  (cond
    ((= a 0) (c:w1))
    ((= a 10) (c:wr2))
    ((= a 18) (c:wh2))
    ((= a 1) (c:w2))
    ((= a 11) (c:wr3))
    ((= a 19) (c:wh3))
    ((= a 2) (c:w3))
    ((= a 12) (c:wr4))
    ((= a 20) (c:wh4))
    ((= a 3) (c:w4))
    ((= a 13) (c:wr5))
    ((= a 21) (c:wh5))
    ((= a 4) (c:w5))
    ((= a 14) (c:wr6))
    ((= a 22) (c:wh6))
    ((= a 5) (c:w6))
    ((= a 15) (c:wr7))
    ((= a 23) (c:wh7))
    ((= a 6) (c:w7))
    ((= a 16) (c:wr8))
    ((= a 24) (c:wh8))
    ((= a 7) (c:w8))
    ((= a 17) (c:wr9))
    ((= a 25) (c:wh9))
    ((= a 8) (c:w9))
    ((= a 9) (c:w10))
    ((= a 41) (setq jw_ty 41) (c:lle))
    ((= a 42) (setq jw_ty 42) (c:llt))
    ((= a 43) (setq jw_ty 43) (c:lltv))
    ((= a 44) (setq jw_ty 44) (c:llf))
    ((= a 45) (setq jw_ty 45) (c:lls))
    ((= a 46) (setq jw_ty 46) (c:llex))
    ((= a 47) (setq jw_ty 47) (c:lldc))
    ((= a 48) (setq jw_ty 48) (c:llu))
    ((= a 49) (setq jw_ty 49) (c:lloa))
    ((= a 98) (pds_key))
  )
  (prin1)
)

;;-------------------------------------------------------------------------
(setq jinbox_wi (load_dialog "jwire"))	; Loading Dialog-Box
(defun help_jjw () (acad_helpdlg "lisp-hlp.hlp" "wire"))
;;-------------------------------------------------------------------------

;;-------------------------------------------------------------------------
(defun C:WW () (c:jwire))
(defun C:JWIRE (/ jinbox xxx jkey acc)
  (setq acc nil)
  (if (= jinbox_wi nil)
    (setq jinbox_wi (load_dialog "jwire"))
  )
  (new_dialog "jinwire" jinbox_wi)
  (if (= jw_ty nil)
    (setq jw_ty 41)
  )
  (jw_ty_set jw_ty)
  (setq	xxx  3
	jkey nil
  )
  (while (> xxx 2)
    (action_tile
      "ww1"
      "(setq jw_ty 0)(setq acc 1)(done_dialog)"
    )
    (action_tile
      "ww2"
      "(setq jw_ty 1)(setq acc 1)(done_dialog)"
    )
    (action_tile
      "ww3"
      "(setq jw_ty 2)(setq acc 1)(done_dialog)"
    )
    (action_tile
      "ww4"
      "(setq jw_ty 3)(setq acc 1)(done_dialog)"
    )
    (action_tile
      "ww5"
      "(setq jw_ty 4)(setq acc 1)(done_dialog)"
    )
    (action_tile
      "ww6"
      "(setq jw_ty 5)(setq acc 1)(done_dialog)"
    )
    (action_tile
      "ww7"
      "(setq jw_ty 6)(setq acc 1)(done_dialog)"
    )
    (action_tile
      "ww8"
      "(setq jw_ty 7)(setq acc 1)(done_dialog)"
    )
    (action_tile
      "ww9"
      "(setq jw_ty 8)(setq acc 1)(done_dialog)"
    )
    (action_tile "ww0" "(setq jw_ty 9)(done_dialog)")

    (action_tile
      "wr2"
      "(setq jw_ty 10)(setq acc 1)(done_dialog)"
    )
    (action_tile
      "wr3"
      "(setq jw_ty 11)(setq acc 1)(done_dialog)"
    )
    (action_tile
      "wr4"
      "(setq jw_ty 12)(setq acc 1)(done_dialog)"
    )
    (action_tile
      "wr5"
      "(setq jw_ty 13)(setq acc 1)(done_dialog)"
    )
    (action_tile
      "wr6"
      "(setq jw_ty 14)(setq acc 1)(done_dialog)"
    )
    (action_tile
      "wr7"
      "(setq jw_ty 15)(setq acc 1)(done_dialog)"
    )
    (action_tile
      "wr8"
      "(setq jw_ty 16)(setq acc 1)(done_dialog)"
    )
    (action_tile "wr9" "(setq jw_ty 17)(done_dialog)")

    (action_tile
      "wh2"
      "(setq jw_ty 18)(setq acc 1)(done_dialog)"
    )
    (action_tile
      "wh3"
      "(setq jw_ty 19)(setq acc 1)(done_dialog)"
    )
    (action_tile
      "wh4"
      "(setq jw_ty 20)(setq acc 1)(done_dialog)"
    )
    (action_tile
      "wh5"
      "(setq jw_ty 21)(setq acc 1)(done_dialog)"
    )
    (action_tile
      "wh6"
      "(setq jw_ty 22)(setq acc 1)(done_dialog)"
    )
    (action_tile
      "wh7"
      "(setq jw_ty 23)(setq acc 1)(done_dialog)"
    )
    (action_tile
      "wh8"
      "(setq jw_ty 24)(setq acc 1)(done_dialog)"
    )
    (action_tile "wh9" "(setq jw_ty 25)(done_dialog)")

    (action_tile
      "lle"
      "(setq jw_ty 41)(setq acc 1)(done_dialog)"
    )
    (action_tile
      "llt"
      "(setq jw_ty 42)(setq acc 1)(done_dialog)"
    )
    (action_tile
      "lltv"
      "(setq jw_ty 43)(setq acc 1)(done_dialog)"
    )
    (action_tile
      "llf"
      "(setq jw_ty 44)(setq acc 1)(done_dialog)"
    )
    (action_tile
      "lls"
      "(setq jw_ty 45)(setq acc 1)(done_dialog)"
    )
    (action_tile
      "llex"
      "(setq jw_ty 46)(setq acc 1)(done_dialog)"
    )
    (action_tile
      "lldc"
      "(setq jw_ty 47)(setq acc 1)(done_dialog)"
    )
    (action_tile
      "llu"
      "(setq jw_ty 48)(setq acc 1)(done_dialog)"
    )
    (action_tile
      "lloa"
      "(setq jw_ty 49)(setq acc 1)(done_dialog)"
    )

    (action_tile "pds_key" "(setq acc 2)(done_dialog)")
    (action_tile "help" "(help_jjw)")
    (setq xxx (start_dialog))
  )
  (action_tile
    "accept"
    "(setq jw_ty jw_ty)(setq acc 1)(done_dialog)"
  )
  (action_tile "cancel" "(done_dialog)")
  (done_dialog)
  (if (= acc 1)
    (jsel_run_w jw_ty)
  )
  (if (= acc 2)
    (pds_key)
  )
)


					;JLAYER.LSP
					;*****************************************************
					; - This program is Entty Setting change             /
					;   command : "JJL" or "JLAYER"                      /
;;;------------------------------                    /
;;; Make by Park Dae-sig                             /
;;; Date is 1998-07-01                               /
;;; Where is "JIN" Electric co.                      /
;;; (HP) 018-250-7324                                /
;;;------------------------------                    /
					; - Last Up-Date is 1998-07-10 (P.D.S)               /
					;*****************************************************

;;-------------------------------------------------------------------------
(defun j_empty () (prompt "\n\t Select is \"Cancel\" ...."))
(defun jsel_run_l (a)
  (cond
    ((= a 1) (c:on))
    ((= a 11) (c:cc))
    ((= a 21) (c:lt1))
    ((= a 2) (c:off))
    ((= a 12) (c:cl))
    ((= a 22) (c:lt2))
    ((= a 3) (c:lla))
    ((= a 13) (c:ch1))
    ((= a 23) (c:lt3))
    ((= a 4) (c:ula))
    ((= a 14) (c:ch3))
    ((= a 24) (c:lt4))
    ((= a 5) (c:lock))
    ((= a 15) (c:ch2))
    ((= a 25) (c:lt1a))
    ((= a 6) (c:uula))
    ((= a 16) (c:ch4))
    ((= a 26) (c:lt1b))
    ((= a 7) (c:oon))
    ((= a 17) (j_empty))
    ((= a 27) (c:lt2a))
    ((= a 8) (j_empty))
    ((= a 18) (j_empty))
    ((= a 28) (c:lty))
    ((= a 9) (j_empty))
    ((= a 19) (j_empty))
    ((= a 29) (c:ltt))

    ((= a 31) (c:c1))
    ((= a 40) (c:c10))
    ((= a 32) (c:c2))
    ((= a 41) (c:c11))
    ((= a 33) (c:c3))
    ((= a 42) (c:c12))
    ((= a 34) (c:c4))
    ((= a 43) (c:c15))
    ((= a 35) (c:c5))
    ((= a 44) (j_empty))
    ((= a 36) (c:c6))
    ((= a 45) (j_empty))
    ((= a 37) (c:c7))
    ((= a 46) (j_empty))
    ((= a 38) (c:c8))
    ((= a 47) (j_empty))
    ((= a 39) (c:c9))
    ((= a 48) (c:coo))

    ((= a 98) (pds_key))
  )
  (prin1)
)

(setq jinbox_la (load_dialog "jlayer"))	; Loading Dialog-Box
(defun help_jjl () (acad_helpdlg "lisp-hlp.hlp" "layer"))

(defun C:JJL () (c:jlayer))
(defun C:JLAYER	(/ jinbox xxx jkey)
  (setq jinbox_la (load_dialog "jlayer"))
  (new_dialog "jinlayer" jinbox_la)
  (setq	xxx  3
	jkey nil
  )
  (while (> xxx 2)
    (action_tile "jct1" "(setq jkey 1)(done_dialog)")
    (action_tile "jct2" "(setq jkey 2)(done_dialog)")
    (action_tile "jct3" "(setq jkey 3)(done_dialog)")
    (action_tile "jct4" "(setq jkey 4)(done_dialog)")
    (action_tile "jct5" "(setq jkey 5)(done_dialog)")
    (action_tile "jct6" "(setq jkey 6)(done_dialog)")
    (action_tile "jct7" "(setq jkey 7)(done_dialog)")
    (action_tile "jct8" "(setq jkey 8)(done_dialog)")
    (action_tile "jct9" "(setq jkey 9)(done_dialog)")
    (action_tile "jla1" "(setq jkey 11)(done_dialog)")
    (action_tile "jla2" "(setq jkey 12)(done_dialog)")
    (action_tile "jla3" "(setq jkey 13)(done_dialog)")
    (action_tile "jla4" "(setq jkey 14)(done_dialog)")
    (action_tile "jla5" "(setq jkey 15)(done_dialog)")
    (action_tile "jla6" "(setq jkey 16)(done_dialog)")
    (action_tile "jla7" "(setq jkey 17)(done_dialog)")
    (action_tile "jla8" "(setq jkey 18)(done_dialog)")
    (action_tile "jla9" "(setq jkey 19)(done_dialog)")
    (action_tile "jlt1" "(setq jkey 21)(done_dialog)")
    (action_tile "jlt2" "(setq jkey 22)(done_dialog)")
    (action_tile "jlt3" "(setq jkey 23)(done_dialog)")
    (action_tile "jlt4" "(setq jkey 24)(done_dialog)")
    (action_tile "jlt5" "(setq jkey 25)(done_dialog)")
    (action_tile "jlt6" "(setq jkey 26)(done_dialog)")
    (action_tile "jlt7" "(setq jkey 27)(done_dialog)")
    (action_tile "jlt8" "(setq jkey 28)(done_dialog)")
    (action_tile "jlt9" "(setq jkey 29)(done_dialog)")
    (action_tile "jco1" "(setq jkey 31)(done_dialog)")
    (action_tile "jco2" "(setq jkey 32)(done_dialog)")
    (action_tile "jco3" "(setq jkey 33)(done_dialog)")
    (action_tile "jco4" "(setq jkey 34)(done_dialog)")
    (action_tile "jco5" "(setq jkey 35)(done_dialog)")
    (action_tile "jco6" "(setq jkey 36)(done_dialog)")
    (action_tile "jco7" "(setq jkey 37)(done_dialog)")
    (action_tile "jco8" "(setq jkey 38)(done_dialog)")
    (action_tile "jco9" "(setq jkey 39)(done_dialog)")
    (action_tile "jco10" "(setq jkey 40)(done_dialog)")
    (action_tile "jco11" "(setq jkey 41)(done_dialog)")
    (action_tile "jco12" "(setq jkey 42)(done_dialog)")
    (action_tile "jco13" "(setq jkey 43)(done_dialog)")
    (action_tile "jco14" "(setq jkey 44)(done_dialog)")
    (action_tile "jco15" "(setq jkey 45)(done_dialog)")
    (action_tile "jco16" "(setq jkey 46)(done_dialog)")
    (action_tile "jco17" "(setq jkey 47)(done_dialog)")
    (action_tile "jco18" "(setq jkey 48)(done_dialog)")
    (action_tile "pds_key" "(setq jkey 98)(done_dialog)")
    (action_tile "help" "(help_jjl)")
    (setq xxx (start_dialog))
  )
  (action_tile "accept" "(done_dialog)")
  (done_dialog)
  (jsel_run_l jkey)
)


					;JLIST.LSP
					;*****************************************************
					; - This program is Object List Command              /
					;   command:"LI, JLIST"                              /
;;;------------------------------                    /
;;; Make by Park Dae-sig                             /
;;; Date is 1997-08-05                               /
;;; Where is "JIN" Electric co.                      /
;;; (HP) 018-250-7324                                /
;;;------------------------------                    /
					; - Last Up-Date is 1999-07-12 (P.D.S)               /
					;*****************************************************

;;;-------------------------- LIST ------------------------------------
(defun jli_ch (a)
  (cond
    ((= a 1) (jli_ch_la entty))		; Layer = 
    ((= a 2) (jli_ch_co entty))		; Color = 62
    ((= a 3) (jli_ch_lt entty))		; Ltype = 
    ((= a 4) (jli_ch_po entty))		; Insert(Start) Point = 
    ((= a 51) (jli_ch_te1 entty))	; 
    ((= a 52) (jli_ch_te2 entty))	; 
    ((= a 53) (jli_ch_te3 entty))	; Text Height = 
    ((= a 54) (jli_ch_te4 entty))	; Text Style = 7
    ((= a 6) (jli_ch_dt entty))		; 
    ((= a 7) (jblock_s7 x2))		; Block's Scale
    ((= a 8) (jli_ch_ep entty))		; Entty Explode
    ((= a 9) (jli_ch_va entty))		; Dimension Value Text = 
    ((= a 98) (pds_key))		; Program Maker Name = Park Dae Sig
  )
)

					;-----------1
(defun jli_ch_la (a)
  (done_dialog)
  (setq name (getstring "\n Enter Change-Layer Name ? : "))
  (command "CHPROP" a "" "LAYER" name "")
)

					;-----------2
(defun jli_ch_co (a)
  (setq name (getstring "\n Enter Change-Color Name ? : "))
  (command "CHPROP" a "" "COLOR" name "")
)

					;-----------3
(defun jli_ch_lt (a)
  (setq name (getstring "\n Enter Change-Ltype Name ? : "))
  (command "CHPROP" a "" "LTYPE" name "")
)

					;-----------4
(defun jli_ch_po (a)
  (setq p1 (getpoint "\n Pick Change-Point ? : "))
  (command "CHANGE" a "" p1)
)

					;-----------51
(defun jli_ch_te1 (a)
  (setq _text (getstring "\n New Text ? : " 1))
  (command "CHANGE" a "" "" "" "" "" "" _text)
)
					;-----------52
(defun jli_ch_te2 (a)
  (setq p1 (getpoint "\n Pick Change-Point ? : "))
  (command "CHANGE" a "" p1 "" "" "" "" "")
)
					;-----------53
(defun jli_ch_te3 (a)
  (setq _hi (getint "\n New Higth ? : "))
  (command "CHANGE" a "" "" "" "" _hi "" "")
)
					;-----------54
(defun jli_ch_te4 (a)
  (setq _st (getstring "\n New Style ? : "))
  (command "CHANGE" a "" "" "" _st "" "" "")
)

					;-----------7
(if (= nil jblock_s7)
  (load "JBLOCK")
)

					;-----------8
(defun jli_ch_ep (a)
  (command "EXPLODE" a)
)

					;-----------9
(defun jli_ch_va (a)
  (setq _text (getstring "\n New Dimension-Text ? : " 1))
  (command "DIM1" "NEW" _text a "")
)

					;============================================================================
(defun help_li () (acad_helpdlg "lisp-hlp.hlp" "list"))
(defun c:jlist () (c:li))
(defun C:LI (/ entty list1 list2)
  (old-non)
  (setq entty (entsel "\nSelect object/<None>: "))
  (if entty
    (setq list1 (cdr (assoc 0 (setq list2 (entget (car entty))))))
  )
  (if (= jinbox_li nil)
    (setq jinbox_li (load_dialog "jlist"))
  )
  (setq ch_key nil)
  (cond
    ((= list1 "LINE") (list_li list2))
    ((= list1 "INSERT") (list_bl list2))
    ((= list1 "CIRCLE") (list_ci list2))
    ((= list1 "POLYLINE") (list_pl list2))
    ((= list1 "LWPOLYLINE") (list_pl list2))
    ((= list1 "TEXT") (list_te list2))
    ((= list1 "MTEXT") (list_te list2))
    ((= list1 "ARC") (list_ci list2))
    ((= list1 "DIMENSION") (list_di list2))
    (T (list_oth entty))
  )
  (if (= entty nil)
    (progn
      (prompt "\n Select is Cancel -- Now [List] command")
      (command "list")
    )
;	 (command "list" entty "")
  )
  (done_dialog)
  (new-sn)
)

					;---------------------------------------------------
(defun li_find (a b) (setq data1 (cdr (assoc a b))))
(defun f_x (a) (setq datap (rtos (car a) 2 2)))
(defun f_y (a) (setq datap (rtos (cadr a) 2 2)))
(defun f_z (a) (setq datap (rtos (caddr a) 2 2)))

;;===========================================================
(defun list_oth (A) (command "list" "si" a) (prin1))

;;===========================================================
(defun list_li (x / ch_key)
  (new_dialog "jinlist_li" jinbox_li)
  (setq x0 (li_find 0 x))
  (setq x8 (li_find 8 x))
  (setq x6 (li_find 6 x))
  (setq x62 (li_find 62 x))
  (if (= x6 nil)
    (setq x6 "BYLAYER")
    (if	(= x6 0)
      (setq x6 "BYBLOCK")
    )
  )
  (if (= x62 nil)
    (setq x62 "BYLAYER")
    (if	(= x62 0)
      (setq x62 "BYBLOCK")
      (setq x62 (rtos x62 2 0))
    )
  )
  (setq x10 (li_find 10 x))
  (setq x11 (li_find 11 x))
  (setq xa (rtos (rtd (angle x10 x11)) 2 8))
  (setq x12 (rtos (distance x10 x11) 2 8))
  (setq x10 (strcat (f_x x10) ", " (f_y x10) ", " (f_z x10)))
  (setq x11 (strcat (f_x x11) ", " (f_y x11) ", " (f_z x11)))
  (set_tile "jli0" x0)
  (set_tile "jli8" x8)
  (set_tile "jli6" x6)
  (set_tile "jli62" x62)
  (set_tile "jli10" x10)
  (set_tile "jli11" x11)
  (set_tile "jli12" x12)
  (set_tile "jlia" xa)
  (action_tile "ch_la" "(setq ch_key 1)(done_dialog)")
  (action_tile "ch_co" "(setq ch_key 2)(done_dialog)")
  (action_tile "ch_lt" "(setq ch_key 3)(done_dialog)")
  (action_tile "ch_po" "(setq ch_key 4)(done_dialog)")
  (action_tile "pds_key" "(setq ch_key 98)(done_dialog)")
  (action_tile "help" "(help_li)")
  (setq xxx (start_dialog))
  (action_tile "accept" "(done_dialog)")
  (if ch_key
    (progn (done_dialog) (jli_ch ch_key))
  )
)
;;===========================================================

;;===========================================================
(defun list_bl (x)
  (new_dialog "jinlist_bl" jinbox_li)
  (setq x0 (li_find 0 x))
  (setq x2 (li_find 2 x))
  (setq x8 (li_find 8 x))
  (setq x41 (rtos (li_find 41 x) 2 8))
  (setq x42 (rtos (li_find 42 x) 2 8))
  (setq x43 (rtos (li_find 43 x) 2 8))
  (setq x50 (rtos (rtd (li_find 50 x)) 2 8))
  (setq x10 (li_find 10 x))
  (setq x10 (strcat (f_x x10) ", " (f_y x10) ", " (f_z x10)))
  (set_tile "jli0" x0)
  (set_tile "jli2" x2)
  (set_tile "jli8" x8)
  (set_tile "jli41" x41)
  (set_tile "jli42" x42)
  (set_tile "jli43" x43)
  (set_tile "jli50" x50)
  (set_tile "jli10" x10)
  (action_tile "ch_la" "(setq ch_key 1)(done_dialog)")
  (action_tile "ch_s7" "(setq ch_key 7)(done_dialog)")
  (action_tile "ch_po" "(setq ch_key 4)(done_dialog)")
  (action_tile "ch_ep" "(setq ch_key 8)(done_dialog)")
  (action_tile "pds_key" "(setq ch_key 98)(done_dialog)")
  (action_tile "help" "(help_li)")
  (setq xxx (start_dialog))
  (action_tile "accept" "(done_dialog)")
  (if ch_key
    (progn (done_dialog) (jli_ch ch_key))
  )
)
;;===========================================================

;;===========================================================
(defun list_ci (x)
  (new_dialog "jinlist_ci" jinbox_li)
  (setq x0 (li_find 0 x))
  (setq x8 (li_find 8 x))
  (setq x6 (li_find 6 x))
  (setq x62 (li_find 62 x))
  (if (= x6 nil)
    (setq x6 "BYLAYER")
    (if	(= x6 0)
      (setq x6 "BYBLOCK")
    )
  )
  (if (= x62 nil)
    (setq x62 "BYLAYER")
    (if	(= x62 0)
      (setq x62 "BYBLOCK")
      (setq x62 (rtos x62 2 0))
    )
  )
  (setq x40 (rtos (li_find 40 x) 2 8))
  (setq x10 (li_find 10 x))
  (setq x10 (strcat (f_x x10) ", " (f_y x10) ", " (f_z x10)))
  (set_tile "jli0" x0)
  (set_tile "jli8" x8)
  (set_tile "jli6" x6)
  (set_tile "jli40" x40)
  (set_tile "jli62" x62)
  (set_tile "jli10" x10)
  (action_tile "ch_la" "(setq ch_key 1)(done_dialog)")
  (action_tile "ch_co" "(setq ch_key 2)(done_dialog)")
  (action_tile "ch_lt" "(setq ch_key 3)(done_dialog)")
  (action_tile "ch_po" "(setq ch_key 4)(done_dialog)")
  (action_tile "pds_key" "(setq ch_key 98)(done_dialog)")
  (action_tile "help" "(help_li)")
  (setq xxx (start_dialog))
  (action_tile "accept" "(done_dialog)")
  (if ch_key
    (progn (done_dialog) (jli_ch ch_key))
  )
)
;;===========================================================
(defun find_flag (a)
  (setq f72 (li_find 72 a))
  (setq f73 (li_find 73 a))
  (cond
    ((and (= f72 1) (= f73 0)) (setq x7x "Center"))
    ((and (= f72 2) (= f73 0)) (setq x7x "Right"))
    ((and (= f72 3) (= f73 0)) (setq x7x "Align"))
    ((and (= f72 4) (= f73 0)) (setq x7x "Middle"))
    ((and (= f72 5) (= f73 0)) (setq x7x "Fit"))
    ((and (= f72 0) (= f73 1)) (setq x7x "BL"))
    ((and (= f72 1) (= f73 1)) (setq x7x "BC"))
    ((and (= f72 2) (= f73 1)) (setq x7x "BR"))
    ((and (= f72 0) (= f73 2)) (setq x7x "ML"))
    ((and (= f72 1) (= f73 2)) (setq x7x "MC"))
    ((and (= f72 2) (= f73 2)) (setq x7x "MR"))
    ((and (= f72 0) (= f73 3)) (setq x7x "TL"))
    ((and (= f72 1) (= f73 3)) (setq x7x "TC"))
    ((and (= f72 2) (= f73 3)) (setq x7x "TR"))
    (T (setq x7x "Normal"))
  )
  (if (or (< 0 f72 5) (< 0 f73 4))
    (setq x10 (li_find 11 x))
    (setq x10 (li_find 10 x))
  )
  (setq x10 (strcat (f_x x10) ", " (f_y x10) ", " (f_z x10)))
)

;;===========================================================
(defun list_te (x)
  (new_dialog "jinlist_te" jinbox_li)
  (setq x0 (li_find 0 x))
  (setq x1 (li_find 1 x))
  (setq x7 (li_find 7 x))
  (setq xft1 (strcase (cdr (assoc 3 (tblsearch "STYLE" x7)))))
  (setq xft2 (strcase (cdr (assoc 4 (tblsearch "STYLE" x7)))))
  (if (or (= xft2 "") (= xft2 nil))
    (setq xft xft1)
    (setq xft (strcat xft1 "+" xft2))
  )
  (setq x8 (li_find 8 x))
  (setq x6 (li_find 6 x))
  (setq x62 (li_find 62 x))
  (if (= x6 nil)
    (setq x6 "BYLAYER")
    (if	(= x6 0)
      (setq x6 "BYBLOCK")
    )
  )
  (if (= x62 nil)
    (setq x62 "BYLAYER")
    (if	(= x62 0)
      (setq x62 "BYBLOCK")
      (setq x62 (rtos x62 2 0))
    )
  )
  (setq x40 (rtos (li_find 40 x) 2 8))
  (setq x41 (rtos (li_find 41 x) 2 8))
  (setq x50 (rtos (rtd (li_find 50 x)) 2 8))
  (find_flag x)
  (set_tile "jli0" x0)
  (set_tile "jli1" x1)
  (set_tile "jli7" x7)
  (set_tile "jli8" x8)
  (set_tile "jli6" x6)
  (set_tile "jli40" x40)
  (set_tile "jli41" x41)
  (set_tile "jli50" x50)
  (set_tile "jli62" x62)
  (set_tile "jli10" x10)
  (set_tile "jli7x" x7x)
  (set_tile "jlift" xft)
  (action_tile "ch_la" "(setq ch_key 1)(done_dialog)")
  (action_tile "ch_co" "(setq ch_key 2)(done_dialog)")
  (action_tile "ch_te" "(setq ch_key 51)(done_dialog)")
  (action_tile "ch_po" "(setq ch_key 52)(done_dialog)")
  (action_tile "ch_hi" "(setq ch_key 53)(done_dialog)")
  (action_tile "ch_st" "(setq ch_key 54)(done_dialog)")
  (action_tile "pds_key" "(setq ch_key 98)(done_dialog)")
  (action_tile "help" "(help_li)")
  (setq xxx (start_dialog))
  (action_tile "accept" "(done_dialog)")
  (if ch_key
    (progn (done_dialog) (jli_ch ch_key))
  )
)
;;===========================================================

;;===========================================================
(defun list_pl (x)
  (new_dialog "jinlist_pl" jinbox_li)
  (setq x0 (li_find 0 x))
  (setq x8 (li_find 8 x))
  (setq x6 (li_find 6 x))
  (setq x62 (li_find 62 x))
  (if (= x6 nil)
    (setq x6 "BYLAYER")
    (if	(= x6 0)
      (setq x6 "BYBLOCK")
    )
  )
  (if (= x62 nil)
    (setq x62 "BYLAYER")
    (if	(= x62 0)
      (setq x62 "BYBLOCK")
      (setq x62 (rtos x62 2 0))
    )
  )
  (setq x40 (rtos (li_find 40 x) 2 8))
  (setq x41 (rtos (li_find 41 x) 2 8))
  (set_tile "jli0" x0)
  (set_tile "jli8" x8)
  (set_tile "jli6" x6)
  (set_tile "jli62" x62)
  (set_tile "jli40" x40)
  (set_tile "jli41" x41)
  (action_tile "ch_la" "(setq ch_key 1)(done_dialog)")
  (action_tile "ch_co" "(setq ch_key 2)(done_dialog)")
  (action_tile "ch_lt" "(setq ch_key 3)(done_dialog)")
  (action_tile "ch_ep" "(setq ch_key 8)(done_dialog)")
  (action_tile "pds_key" "(setq ch_key 98)(done_dialog)")
  (action_tile "help" "(help_li)")
  (setq xxx (start_dialog))
  (action_tile "accept" "(done_dialog)")
  (if ch_key
    (progn (done_dialog) (jli_ch ch_key))
  )
)
;;===========================================================

;;===========================================================
(defun list_di (x)
  (new_dialog "jinlist_di" jinbox_li)
  (setq x0 (li_find 0 x))
  (setq x8 (li_find 8 x))
  (setq x6 (li_find 6 x))
  (setq x62 (li_find 62 x))
  (if (= x6 nil)
    (setq x6 "BYLAYER")
    (if	(= x6 0)
      (setq x6 "BYBLOCK")
    )
  )
  (if (= x62 nil)
    (setq x62 "BYLAYER")
    (if	(= x62 0)
      (setq x62 "BYBLOCK")
      (setq x62 (rtos x62 2 0))
    )
  )
  (setq x13 (li_find 13 x))
  (setq x14 (li_find 14 x))
  (setq x12 (rtos (distance x13 x14) 2 8))
  (setq x13 (strcat (f_x x13) ", " (f_y x13) ", " (f_z x13)))
  (setq x14 (strcat (f_x x14) ", " (f_y x14) ", " (f_z x14)))
  (setq x1 (li_find 1 x))
  (if (= x1 "")
    (setq x1 "Is Default")
  )
  (set_tile "jli0" x0)
  (set_tile "jli8" x8)
  (set_tile "jli6" x6)
  (set_tile "jli62" x62)
  (set_tile "jli13" x13)
  (set_tile "jli14" x14)
  (set_tile "jli12" x12)
  (set_tile "jli1" x1)
  (action_tile "ch_la" "(setq ch_key 1)(done_dialog)")
  (action_tile "ch_co" "(setq ch_key 2)(done_dialog)")
  (action_tile "ch_ep" "(setq ch_key 8)(done_dialog)")
  (action_tile "ch_va" "(setq ch_key 9)(done_dialog)")
  (action_tile "pds_key" "(setq ch_key 98)(done_dialog)")
  (action_tile "help" "(help_li)")
  (setq xxx (start_dialog))
  (action_tile "accept" "(done_dialog)")
  (if ch_key
    (progn (done_dialog) (jli_ch ch_key))
  )
)
;;===========================================================
(setq jinbox_li (load_dialog "jlist"))	; Loading Dialog-Box
;;===========================================================

;; defun name's list
					; Entty Type  ================= _type   (0)
					; Entty Layer ================= _layer  (8)
					; Entty Name  ================= _name   (2)
					; Entty Color ================= _color  (62)
					; Entty Linetype ============== _ltype  (6)
					; Entty Rotation Angle ======== _rotate (50,51)
					; Distance & Angle ============ _dist   (start=10, end=11)
					; Circle or Arc Center Point == _center (10)
					; Circle or Arc Radius ======== _radius (40)
					; Polyline Width ============== _width
					; Text Description ============ _des    (1)
					; Text Style ================== _style
					; Text Higth ================== _hight
					; Text Width ================== t-wd

					;JCAL1.LSP
(defun c:cal1 (/	  act_key    set_dis	back_sp	   change_calstr
	       cal_answer _item	     _len	_cut	   _cnt
	       _str	  _chkdot    _chknum	_chk	   _s
	       _dia	  _dianame   _keylist
	      )
  (defun act_key (LIST)
    (foreach _item LIST
      (action_tile
	_item
	"(setq @CALSTR (strcat @CALSTR $key))(set_dis)"
      )
    )
  )
  (defun set_dis ()
    (setq _len (strlen @CALSTR))
    (setq _cut (- _len 17))

    (if	(< _cut 1)
      (setq _cut 1)
    )
    (setq _str (substr @CALSTR _cut 20))
    (set_tile "dis" _str)
  )
  (defun back_sp ()
    (setq _len (strlen @CALSTR))
    (if	(> _len 0)
      (setq @CALSTR (substr @CALSTR 1 (1- _len)))
    )
    (set_dis)
  )
  (defun cal_answer ()
    (setq _str (change_calstr))
    (setq test _str)
    (setq _str (c:cal _str))
    (if	_str
      (progn
	(setq _str (rtos _str 2 5))
	(set_tile "answer" _str)
      )
      (set_tile "answer" "!!Error")
    )
  )
  (defun change_calstr ()
    (setq _cnt 1
	  _chk 'T
	  _chknum nil
	  _chkdot nil
	  _str ""
    )
    (setq _len (strlen @CALSTR))
    (if	(< _len 1)
      (setq _chk nil)
    )
    (repeat _len
      (setq _s (strcat (substr @CALSTR _cnt 1)))
      (cond
	((and (>= _s "0") (<= _s "9"))
	 (setq _str (strcat _str _s))
	 (setq _chknum 'T)
	)
	((= _s ".")
	 (setq _str (strcat _str _s))
	 (setq _chknum nil
	       _chkdot 'T
	 )
	)
	('T
	 (if (and (= _chknum 'T) (= _chkdot nil))
	   (setq _str (strcat _str ".0" _s))
	   (setq _str (strcat _str _s))
	 )
	 (setq _chknum nil
	       _chkdot nil
	 )
	)
      )
      (setq _cnt (1+ _cnt))
    )
    (if	(and (= _chknum 'T) (= _chkdot nil))
      (setq _str (strcat _str ".0"))
    )
    _str
  )
  (_autoxload "geomcal")
  (setq _dia (load_dialog "jcal1"))
  (setq _dianame (new_dialog "cal" _dia))

  (setq	_keylist '("0"	 "1"   "2"   "3"   "4"	 "5"   "6"   "7"
		   "8"	 "9"   "+"   "-"   "/"	 "*"   "("   ")"
		   "."
		  )
  )

  (setq @CALSTR "")

  (act_key _keylist)
  (action_tile "<" "(back_sp)")
  (action_tile "=" "(cal_answer)")
  (action_tile
    "clear"
    "(setq @CALSTR \"\") (set_dis) (set_tile \"answer\" \"\")"
  )
  (start_dialog)
  (unload_dialog _dia)
)
(princ)

					;JCALS.LSP
					;*****************************************************
					; - This program is Lighting Array & Lumination      /
					;   command:"CALS,CALS2,TAMP3,CALL,CAL6,CAL60,T6     /
;;;------------------------------                    /
;;; Make by Park Dae-sig                             /
;;; Date is 1995-00-00                               /
;;; Where is "JIN" Electric co.                      /
;;; (HP) 018-250-7324                                /
;;;------------------------------                    /
					; - Last Up-Date is 1998-10-14 (P.D.S)               /
					;*****************************************************

;;-------------------------------------------------------------------------
(defun BLOCK-LIST () (acad_helpdlg "BLK-LIST.hlp" "fl"))

(setq jinbox_ca (load_dialog "jcals"))	; Loading Dialog-Box
(defun help_cals () (acad_helpdlg "lisp-hlp.hlp" "cals"))
(defun set_cals_key (a)
  (cond
    ((= a 1) (set_tile "cals_b1" "1"))
    ((= a 2) (set_tile "cals_b2" "1"))
    ((= a 3) (set_tile "cals_b3" "1"))
    ((= a 4) (set_tile "cals_b4" "1"))
    ((= a 5) (set_tile "cals_b5" "1"))
    ((= a 6) (set_tile "cals_b6" "1"))
    ((= a 7) (set_tile "cals_b7" "1"))
    ((= a 8) (set_tile "cals_b8" "1"))
    (T nil)
  )
)

;===김희태리습인용.

;(str_chk_erase  삭제문자 , 문자열 , 대소문자여부)
;(str_chk_erase  "a"  "ab c1a"  nil)-> "b c1"
;(str_chk_erase  "ab"  "AB12 ba ab"  T)-> "12 ba "
;일치하는 것이 없으면 그대로 문자열 리턴

(defun str_chk_erase (b a c / alen blen n str_cat org-a) 
	(setq org-a a)
	(If c (setq a (strcase a) b (strcase b)) )
	(setq alen (strlen a) blen (strlen b) n 1 str_cat "")
	(while (<= n alen)
      (if (= (substr a n 1) (substr b 1 1))
        (if (= (substr a n blen) b)
          (setq str_cat (strcat str_cat (str_chk_erase b (substr org-a (+ n blen)) c))  n 10000000  )
          (setq str_cat (strcat str_cat (substr org-a n 1)) n (1+ n))
        )
        (setq str_cat (strcat str_cat (substr org-a n 1)) n (1+ n))
      )
    )  
    str_cat
)  
;===김희태리습인용.

(defun C:CALS (/ cal_key)
  (setq cal_key nil)
  (if (= jinbox_ca nil)
    (setq jinbox_ca (load_dialog "jcals"))
  )
  (new_dialog "jincals" jinbox_ca)
  (set_cals_key cals_key)
  (action_tile "cals1" "(setq cal_key 1)(done_dialog)")
  (action_tile "cals2" "(setq cal_key 2)(done_dialog)")
  (action_tile "cals3" "(setq cal_key 3)(done_dialog)")
  (action_tile "cals4" "(setq cal_key 4)(done_dialog)")
  (action_tile "cals5" "(setq cal_key 5)(done_dialog)")
  (action_tile "cals6" "(setq cal_key 6)(done_dialog)")
  (action_tile "cals7" "(setq cal_key 7)(done_dialog)")
  (action_tile "cals8" "(setq cal_key 8)(done_dialog)")
  (action_tile "cals_b1" "(setq cal_key 1)(done_dialog)")
  (action_tile "cals_b2" "(setq cal_key 2)(done_dialog)")
  (action_tile "cals_b3" "(setq cal_key 3)(done_dialog)")
  (action_tile "cals_b4" "(setq cal_key 4)(done_dialog)")
  (action_tile "cals_b5" "(setq cal_key 5)(done_dialog)")
  (action_tile "cals_b6" "(setq cal_key 6)(done_dialog)")
  (action_tile "cals_b7" "(setq cal_key 7)(done_dialog)")
  (action_tile "cals_b8" "(setq cal_key 8)(done_dialog)")
  (action_tile "pds_key" "(setq cal_key 98)(done_dialog)")
  (action_tile "help" "(help_cals)")
  (action_tile
    "accept"
    "(setq cal_key cals_key)(done_dialog)"
  )
  (action_tile "cancel" "(setq cal_key 100)(done_dialog)")
  (start_dialog)
					;  (action_tile "accept" "(setq cal_key cals_key)(done_dialog)")
					;  (action_tile "cancel" "(setq cal_key 100)(done_dialog)")
					;  (if (= cal_key nil)(setq cal_key cals_key))
  (if cal_key
    (if	(> 8 cal_key)
      (setq cals_key cal_key)
    )
  )
  (j_calsx cal_key)
)

(defun j_calsx (cal_key)
  (setq olds nil)
  (old-non)
  (cond
    ((= cal_key 1) (j_cals))
    ((= cal_key 2) (j_cals2))
    ((= cal_key 3) (j_tamp3))
    ((= cal_key 4) (j_call))
    ((= cal_key 5) (j_cal6))
    ((= cal_key 6) (j_cal60))
    ((= cal_key 7) (j_t6))
    ((= cal_key 98) (pds_key))
    (T (prompt "\n Terminated............"))
  )
  (new-sn)
)

					;===================================================================

;;----------------------------STARTING OF LISP'S---------------------------------
;;----------------------------setting's defuolt-------------------------------

(defun dtr (a) (* pi (/ a 180.0)))
(defun rtd (a) (/ (* a 180.0) PI))
(defun old-non ()
  (setq olds (getvar "OSMODE"))
  (setvar "OSMODE" 0)
)
(defun new-sn () (setvar "OSMODE" olds))

;;-------------------------------------------------------------------------
(defun count-sel-text (sel-t1 / n1 i count1 sel-tn sel-td)
  (setq n1 (sslength sel-t1))
  (setq i 0)
  (setq count1 0)
  (setq n1 (- n1 1))
  (while (<= i n1)
    (setq sel-tn (entget (ssname sel-t1 i)))
    (setq sel-td (atof (str_chk_erase "," (cdr (assoc 1 sel-tn)) nil)))	 ; 김희태리습인용
    (setq count1 (+ count1 sel-td))
    (setq i (+ i 1))
  )
  (setq total-text count1)
  (setq m_data (strcat "Calcurator Number is =[" (rtos count1) "]"))
;  (command "MODEMACRO" m_data)
  (prin1)
)

					;----------------------------------------------------------------------------
(defun J_CALS (/ sel-t1 p1)
  (prompt "\n\n ****PICK NUMBER MULTIPLE--(ONLY NUMBER)****")
  (setq sel-t1 (sel_text))

  (COUNT-SEL-TEXT sel-t1)

  (prompt "\n\n ****  THANK YOU! CONTED NUMBER'S = [")
  (prin1 total-text)
  (prompt "] ****")
  (prin1)
  (setq total-text (rtos total-text 2))
  (setq p1 (getpoint "\n ENTER TEXT START POINT ?"))
  (command "TEXT" P1 "250" "" total-text)
)

					;---------------------------------------------------------------------------
(defun J_CALL (/ CA1 N1 I TT T1 T2 TOTAL ETT KKK TN)
  (prompt
    "\n\n ><>< ****PICK NUMBER MULTIPLE--(ONLY NUMBER)**** ><><"
  )
  (setq sel-t1 (sel_text))

  (COUNT-SEL-TEXT sel-t1)

  (prompt "\n\n ****  THANK YOU! CONTED NUMBER'S = [")
  (prin1 total-text)
  (prompt "] ****")
  (prin1)
  (setq total-text (rtos total-text 2))
  (setq ETT (entsel "\n ->->-> SELECT TEXT FOR TOTAL ? <-<-<-"))
  (if ETT
    (command "CHANGE" ETT "" "" "" "" "" "" total-text)
  )
)

					;--------------------------------------------------------------------------
(defun J_TAMP3 (/ E1 NL N I CHM E2 T0 TT1 TT2 ED vvv ppp)
  (setq	OLDERR	*ERROR*
	*ERROR*	TEXERROR
	CHM	0
  )
  (setq I 0)
  (if (or (= amp_volt "") (= amp_volt nil))
    (setq amp_volt "380")
  )
  (if (or (= amp_pole "") (= amp_pole nil))
    (setq amp_pole "3")
  )
  (setq vvv amp_volt)
  (setq ppp amp_pole)
  (setq E1 (sel_text))
  (prompt "\n Enter Pole ? (ex - 1P,3P) <")
  (prin1 ppp)
  (setq amp_pole (getstring "> ? : "))
  (if (or (= amp_pole nil) (= amp_pole ""))
    (setq amp_pole ppp)
  )
  (prompt "\n Enter Voltage ? (ex - 208,220,380,440) <")
  (prin1 vvv)
  (setq amp_volt (getstring "> ? : "))
  (if (or (= amp_volt nil) (= amp_volt ""))
    (setq amp_volt vvv)
  )
  (if E1
    (progn
      (setq NL (sslength E1))
      (setq N (- NL 1))
      (while (<= I N)
	(setq ED (entget (setq E2 (ssname E1 I))))
	(setq T0 (cdr (assoc 0 ED)))
	(setq TT1 (assoc 1 ED))
	(setq TT2 (cdr TT1))
	(prompt "\nLoad is ")
	(prin1 TT2)
	(prompt "(kVA) -> ")
	(if (= "3" amp_pole)
	  (cals_amp3 amp_volt)
	)
	(if (= "1" amp_pole)
	  (cals_amp1 amp_volt)
	)
	(prompt " Amp. is :")
	(prin1 TT)
	(prompt "(A)")
	(if (= TT "0.0")
	  (prompt " !! Select is Not Number's !! ")
	  (progn
	    (setq TT (strcat TT "A"))
	    (setq ED (SUBST (CONS 1 TT) (assoc 1 ED) ED))
	    (entmod ED)
	  )				; progn end
	)				; if end
	(setq I (1+ I))
      )					; while end
    )					; progn end
  )					; if end
  (prin1)
)					; defun end

					;--------------------------------------------------------------------------
(defun cals_amp3 (a)
  (cond
    ((= a "380")
     (setq TT (rtos (/ (atof TT2) (* 0.38 (sqrt 3))) 2 1))
    )
    ((= a "440")
     (setq TT (rtos (/ (atof TT2) (* 0.44 (sqrt 3))) 2 1))
    )
    ((= a "208")
     (setq TT (rtos (/ (atof TT2) (* 0.208 (sqrt 3))) 2 1))
    )
    ((= a "220")
     (setq TT (rtos (/ (atof TT2) (* 0.22 (sqrt 3))) 2 1))
    )
    (T
     (setq TT (rtos (/ (atof TT2) (* (/ (atof a) 1000) (sqrt 3))) 2 1))
    )
  )
)

					;--------------------------------------------------------------------------
(defun cals_amp1 (a)
  (cond
    ((= a "380") (setq TT (rtos (/ (atof TT2) 0.38) 2 1)))
    ((= a "440") (setq TT (rtos (/ (atof TT2) 0.44) 2 1)))
    ((= a "208") (setq TT (rtos (/ (atof TT2) 0.208) 2 1)))
    ((= a "220") (setq TT (rtos (/ (atof TT2) 0.22) 2 1)))
    (T
     (setq TT (rtos (/ (atof TT2) (* (/ (atof a) 1000) (sqrt 3))) 2 1))
    )
  )
)


					;--------------------------------------------------------------------------
(defun J_CAL60 (/    K1	  K2   K3   K4	 K5   K6   tol	kw   fac  flo
		par  tl1  tl2  dl1  dl2	 ts1  ts2  l	l1   t1	  t2
		tn   tl	  dl   df   t-load    d-load	factor	  p1
		p2   p3
	       )
  (setq	TOL "TOTAL LOAD : "
	KW  " (VA)"
	FAC "DEMAND FACTOR : "
	FLO "DEMAND LOAD : "
	PAR " (%)"
  )

					;---------------Select Demand Load
  (prompt "\n\t >>***** SELCET DEMAND-LOAD : *****<<")
  (setq TS1 (CAR (entsel)))
  (setq dem-total (atof (cdr (assoc 1 (entget TS1)))))
  (prompt "\n Demand Load => [")
  (prin1 dem-total)
  (prompt "] ")

					;---------------Select Total Load
  (prompt "\n\t <<===== SELCET TOTAL-LOAD : =====>>")
  (setq sel-t1 (sel_text))
  (count-sel-text sel-t1)
  (setq gra-total total-text)
  (prompt "\n Total Load => [")
  (prin1 gra-total)
  (prompt "] ")

					;---------------Calcuration
  (setq dem-factor (rtos (* (/ dem-total gra-total) 100) 2 2))
  (setq g-total (strcat tol (rtos gra-total 2 0) kw))
  (setq d-total (strcat flo (rtos dem-total 2 0) kw))
  (setq factor (strcat fac dem-factor par))

					;---------------TEXT TYPING
  (setq P1 (getpoint " TEXT START POINT?"))
  (setq P2 (POLAR P1 (DTR 270) 450))
  (setq P3 (POLAR P2 (DTR 270) 450))
  (command "TEXT" P1 "250" "0" g-total)
  (command "TEXT" P2 "250" "0" FACTOR)
  (command "TEXT" P3 "250" "0" d-total)
)

					;-------------------------------------------------------------------------
(defun J_CALS2 (/    p	  l    n    e	 os   as   ns	st   s	  nsl
		osl  sl	  si   chf  couu total	   total2    si	  CA1
		N1   I	  TT   T1   T2
	       )
  (prompt "\n\n ****PICK NUMBER MULTIPLE--(ONLY NUMBER)****")
  (TERPRI)
  (setq sel-t1 (sel_text))

  (count2 sel-t1)
  (count-sel-text sel-t1)
  (setq TOTAL (rtos total-text 2 3))

  (setq total2 (strcat total " / " (rtos couu 2 3)))
  (prompt "\n\n ****  THANK YOU! CONTED NUMBER'S = [")
  (prompt total2)
  (prompt "] ****")
  (prin1)
  (setq P1 (getpoint "\n ENTER TEXT START POINT ?"))
  (command "TEXT" P1 "250" "" TOTAL2)
)

					;-------------------------------------------------------------------------
(defun count2 (p)
	(if p
		(progn
			(setq couu 0 osl 1 os "/")
			(setq nsl 1 ns "")
			(setq l 0 n (sslength p))
			(while (< l n)
				(setq e (entget (ssname p l)))
				(setq chf nil si  1)
				(setq s (cdr (setq as (assoc 1 e))))
				(while (= osl (setq sl (strlen (setq st (substr s si osl)))))
					(if (= st os)
						(progn
							(setq s (strcat ns (substr s (+ si osl))))
							(setq chf t)
							(setq si (+ si nsl))
						)
						(setq si (1+ si))
					)
				)
				(if chf
					(setq couu (+ (atof (str_chk_erase "," s nil)) couu))	; 김희태리습 인용
				)
				(setq l (1+ l))
	      )
		)
	)
)

;;;--------------------------------------------------------------------------
;;;---------------MAIN SETTING---------------------

(defun J_CAL6 (/    K1	 K2   K3   K4	K5   K6	  tol  kw   fac	 flo
	       par  tl1	 tl2  dl1  dl2	ts1  ts2  l    l1   t1	 t2
	       tn   tl	 dl   df   t-load    d-load    factor	 p1
	       p2   p3
	      )

  (setq	TOL "TOTAL LOAD : "
	KW  " (VA)"
	FAC "DEMAND FACTOR : "
	FLO "DEMAND LOAD : "
	PAR " (%)"
  )

					;---------------Select 60% Load-----------------
  (prompt "\n\t >>***** SELCET 60%-LOAD : *****<<")
  (setq sel-t1 (sel_text))
  (count-sel-text sel-t1)
  (setq gra-total60 total-text)
  (prompt "\n 60% Total Load => [")
  (prin1 gra-total60)
  (prompt "] ")

					;---------------Select 100% Load-----------------
  (prompt "\n\t <<===== SELCET TOTAL-LOAD : =====>>")
  (setq sel-t1 (sel_text))
  (count-sel-text sel-t1)
  (setq gra-total100 total-text)
  (prompt "\n 100% Total Load => [")
  (prin1 gra-total100)
  (prompt "] ")

					;---------------Calcuration -------------
  (setq dem-total (+ (* gra-total60 0.6) gra-total100))
  (setq gra-total (+ gra-total60 gra-total100))
  (setq dem-factor (rtos (* (/ dem-total gra-total) 100) 2 2))
  (setq g-total (strcat tol (rtos gra-total 2 0) kw))
  (setq d-total (strcat flo (rtos dem-total 2 0) kw))
  (setq factor (strcat fac dem-factor par))

					;---------------TEXT TYPING-----------------
  (setq P1 (getpoint " TEXT START POINT?"))
  (setq P2 (POLAR P1 (DTR 270) 450))
  (setq P3 (POLAR P2 (DTR 270) 450))
  (command "TEXT" P1 "250" "0" g-total)
  (command "TEXT" P2 "250" "0" FACTOR)
  (command "TEXT" P3 "250" "0" d-total)
)

;;;--------------------------------------------------------------------------
					;(prompt "\n TYPE command : CALS ")
;;;--------------------------------------------------------------------------

					;JTRAY.LSP
					;*****************************************************
					; - This program is Wiring in Drawing (JWIRE.LSP)    /
					;   command:"JTR, JTRAY"                             /
;;;------------------------------                    /
;;; Make by Park Dae-sig                             /
;;; Date is 1997-11-06                               /
;;; Where is "JIN" Electric co.                      /
;;; (HP) 018-250-7324                                /
;;;------------------------------                    /
					; - Last Up-Date is 1998-11-06 (P.D.S)               /
					;*****************************************************

					;--------------------------------------------------------------------------
(defun dtr (a) (* pi (/ a 180.0)))
(defun rtd (a) (/ (* a 180.0) pi))
(defun wierror (s)
  (if (/= s "function cancelled")
    (princ (strcat "\nerror: " s))
  )
  (setvar "osmode" olds)
  (setq *error* olderr)
  (princ)
)
;;-------------------------------------------------------------------------
(defun in_tr (a) (command ".insert" a))
(defun in_tr_1 (a) (command ".insert" a "nea"))
(defun in_tr_2 (a) (command ".insert" a "end" PAUSE "" ""))

;;-------------------------------------------------------------------------
(defun jsel_run_tr (a)
  (cond
    ((= a 1) (in_tr "te-3"))
    ((= a 2) (in_tr "tt-3"))
    ((= a 3) (in_tr "tc-3"))
    ((= a 4) (in_tr "te-4"))
    ((= a 5) (in_tr "tt-4"))
    ((= a 6) (in_tr "tc-4"))
    ((= a 7) (in_tr "te-6"))
    ((= a 8) (in_tr "tt-6"))
    ((= a 9) (in_tr "tc-6"))
    ((= a 10) (in_tr "te-7"))
    ((= a 11) (in_tr "tt-7"))
    ((= a 12) (in_tr "tc-7"))
    ((= a 13) (in_tr "te-9"))
    ((= a 14) (in_tr "tt-9"))
    ((= a 15) (in_tr "tc-9"))
    ((= a 16) (in_tr "te-12"))
    ((= a 17) (in_tr "tt-12"))
    ((= a 18) (in_tr "tc-12"))

    ((= a 21) (in_tr_1 "t-dt3"))
    ((= a 22) (in_tr_1 "t-dt4"))
    ((= a 23) (in_tr_1 "t-dt6"))
    ((= a 24) (in_tr_1 "t-dt7"))
    ((= a 25) (in_tr_1 "t-dt9"))
    ((= a 26) (in_tr_1 "t-dt12"))
    ((= a 27) (in_tr_1 "t-dt3a"))
    ((= a 28) (in_tr_1 "t-dt4a"))
    ((= a 29) (in_tr_1 "t-dt6a"))
    ((= a 30) (in_tr_1 "t-dt7a"))
    ((= a 31) (in_tr_1 "t-dt9a"))
    ((= a 32) (in_tr_1 "t-dt12a"))

    ((= a 41) (in_tr "tray300"))
    ((= a 42) (in_tr "tray450"))
    ((= a 43) (in_tr "tray600"))
    ((= a 44) (in_tr "tray750"))
    ((= a 45) (in_tr "tray900"))
    ((= a 46) (in_tr "tray1200"))

    ((= a 51) (in_tr_2 "t-end"))
    ((= a 52) (in_tr_2 "t-end2"))
    ((= a 53) (in_tr_1 "t-end3"))

    ((= a 98) (pds_key))
  )
  (setq jkey nil)
  (prin1)
)

;;-------------------------------------------------------------------------
(setq jinbox_tr (load_dialog "jtray"))	; Loading Dialog-Box
(defun help_jjw () (acad_helpdlg "lisp-hlp.hlp" "wire"))
;;-------------------------------------------------------------------------

;;-------------------------------------------------------------------------
(defun C:JTR () (c:jtray))
(defun C:JTRAY (/ jinbox xxx jkey)
  (if (= jinbox_tr nil)
    (setq jinbox_tr (load_dialog "jtray"))
  )
  (new_dialog "jintray" jinbox_tr)
  (setq	xxx  3
	jkey nil
  )
  (while (> xxx 2)
    (action_tile "te3" "(setq jkey 1)(done_dialog)")
    (action_tile "tt3" "(setq jkey 2)(done_dialog)")
    (action_tile "tc3" "(setq jkey 3)(done_dialog)")
    (action_tile "te4" "(setq jkey 4)(done_dialog)")
    (action_tile "tt4" "(setq jkey 5)(done_dialog)")
    (action_tile "tc4" "(setq jkey 6)(done_dialog)")
    (action_tile "te6" "(setq jkey 7)(done_dialog)")
    (action_tile "tt6" "(setq jkey 8)(done_dialog)")
    (action_tile "tc6" "(setq jkey 9)(done_dialog)")
    (action_tile "te7" "(setq jkey 10)(done_dialog)")
    (action_tile "tt7" "(setq jkey 11)(done_dialog)")
    (action_tile "tc7" "(setq jkey 12)(done_dialog)")
    (action_tile "te9" "(setq jkey 13)(done_dialog)")
    (action_tile "tt9" "(setq jkey 14)(done_dialog)")
    (action_tile "tc9" "(setq jkey 15)(done_dialog)")
    (action_tile "te12" "(setq jkey 16)(done_dialog)")
    (action_tile "tt12" "(setq jkey 17)(done_dialog)")
    (action_tile "tc12" "(setq jkey 18)(done_dialog)")

    (action_tile "dt3" "(setq jkey 21)(done_dialog)")
    (action_tile "dt4" "(setq jkey 22)(done_dialog)")
    (action_tile "dt6" "(setq jkey 23)(done_dialog)")
    (action_tile "dt7" "(setq jkey 24)(done_dialog)")
    (action_tile "dt9" "(setq jkey 25)(done_dialog)")
    (action_tile "dt12" "(setq jkey 26)(done_dialog)")
    (action_tile "dt3a" "(setq jkey 27)(done_dialog)")
    (action_tile "dt4a" "(setq jkey 28)(done_dialog)")
    (action_tile "dt6a" "(setq jkey 29)(done_dialog)")
    (action_tile "dt7a" "(setq jkey 30)(done_dialog)")
    (action_tile "dt9a" "(setq jkey 31)(done_dialog)")
    (action_tile "dt12a" "(setq jkey 32)(done_dialog)")

    (action_tile "tpl3" "(setq jkey 41)(done_dialog)")
    (action_tile "tpl4" "(setq jkey 42)(done_dialog)")
    (action_tile "tpl6" "(setq jkey 43)(done_dialog)")
    (action_tile "tpl7" "(setq jkey 44)(done_dialog)")
    (action_tile "tpl9" "(setq jkey 45)(done_dialog)")
    (action_tile "tpl12" "(setq jkey 46)(done_dialog)")

    (action_tile "t_end" "(setq jkey 51)(done_dialog)")
    (action_tile "t_end2" "(setq jkey 52)(done_dialog)")
    (action_tile "t_end3" "(setq jkey 53)(done_dialog)")

    (action_tile "pds_key" "(setq jkey 98)(done_dialog)")
    (action_tile "help" "(help_jjw)")
    (setq xxx (start_dialog))
  )
  (action_tile "accept" "(setq jkey 97)(done_dialog)")
  (action_tile "cancel" "(done_dialog)")
  (done_dialog)
  (if jkey
    (jsel_run_tr jkey)
  )
)

					;JCUB.LSP
					;*****************************************************
					; - This program is Cublcle Plan or MCC Diagram      /
					;   command : "CUB, PNL, MCC"                        /
;;;------------------------------                    /
;;; Make by Park Dae-sig                             /
;;; Date is 1995-00-00                               /
;;; Where is "JIN" Electric co.                      /
;;; (HP) 018-250-7324                                /
;;;------------------------------                    /
					; - Last Up-Date is 1998-10-14 (P.D.S)               /
					;*****************************************************

;;-------------------------------------------------------------------------

(defun BLOCK-LIST () (acad_helpdlg "BLK-LIST.hlp" "fl"))

(setq jinbox_cub (load_dialog "jcub"))	; Loading Dialog-Box
(defun help_cub () (acad_helpdlg "lisp-hlp.hlp" "cub"))

(defun C:CUB (/)
  (setq cub_key nil)
  (if (= jinbox_cub nil)
    (setq jinbox_cub (load_dialog "jcub"))
  )
  (new_dialog "jincub" jinbox_cub)
  (action_tile "lvp" "(setq cub_key 1)(done_dialog)")
  (action_tile "trp" "(setq cub_key 2)(done_dialog)")
  (action_tile "shp" "(setq cub_key 3)(done_dialog)")
  (action_tile "mcc" "(setq cub_key 4)(done_dialog)")
  (action_tile "mdia" "(setq cub_key 5)(done_dialog)")
  (action_tile "pdia" "(setq cub_key 6)(done_dialog)")
  (action_tile "cdrl" "(setq cub_key 7)(done_dialog)")
  (action_tile "cdrt" "(setq cub_key 8)(done_dialog)")
  (action_tile "cdrs" "(setq cub_key 9)(done_dialog)")
  (action_tile "pds_key" "(setq cub_key 98)(done_dialog)")
  (action_tile "help" "(help_cub)")
  (start_dialog)
  (action_tile "accept" "(done_dialog)")
  (action_tile "cancel" "(setq cub_key 100)(done_dialog)")
  (j_cub cub_key)
)

(defun j_cub (cub_key)
  (old-non)
  (LA-SET "CUB" 103)
  (cond
    ((= cub_key 1) (j_pnl-lvp))
    ((= cub_key 2) (j_pnl-trp))
    ((= cub_key 3) (j_pnl-shp))
    ((= cub_key 4) (j_pnl-mcc))
    ((= cub_key 5) (j_dia-mcc))
    ((= cub_key 6) (j_dia-pnl))
    ((= cub_key 7) (make-door-1 50))
    ((= cub_key 8) (make-door-2 200))
    ((= cub_key 9) (make-door-2 50))
    ((= cub_key 98) (pds_key))
    ((= key "?") (acad_helpdlg "lisp-hlp.hlp" "cub"))
    (T (prompt "\n Terminated............"))
  )
  (new-sn)
  (la-back)
  (prin1)
)

					;===================================================================
(defun j_pnl-mcc ()
  (setq pnl-w (getreal "\n Panel Width Size ? <600> :"))
  (if (= pnl-w nil)
    (setq pnl-w 600)
  )
  (setq pnl-d (getreal "\n Panel Depth Size ? <600> :"))
  (if (= pnl-d nil)
    (setq pnl-d 600)
  )
  (make-body)
  (setq p5 (polar p3 (dtr 135) 70))
  (setq p6 (polar p4 (dtr 45) 70))
  (command "line" p1 p3 "" "line" p5 p6 "")
)

(defun j_pnl-lvp ()
  (setq pnl-w (getreal "\n Panel Width Size ? <800> :"))
  (if (= pnl-w nil)
    (setq pnl-w 800)
  )
  (setq pnl-d (getreal "\n Panel Depth Size ? <1600> :"))
  (if (= pnl-d nil)
    (setq pnl-d 1600)
  )
  (make-body)
  (make-doorx 3)
)

(defun j_pnl-trp ()
  (setq pnl-w (getreal "\n Panel Width Size ? <2000> :"))
  (if (= pnl-w nil)
    (setq pnl-w 2000)
  )
  (setq pnl-d (getreal "\n Panel Depth Size ? <2000> :"))
  (if (= pnl-d nil)
    (setq pnl-d 2000)
  )
  (make-body)
  (make-doorx 2)
)

(defun j_pnl-shp ()
  (setq pnl-w (getreal "\n Panel Width Size ? <1200> :"))
  (if (= pnl-w nil)
    (setq pnl-w 1200)
  )
  (setq pnl-d (getreal "\n Panel Depth Size ? <2500> :"))
  (if (= pnl-d nil)
    (setq pnl-d 2500)
  )
  (make-body)
  (make-doorx 1)
)

					;---------------------------------------------------------------------------
(defun make-body ()
  (initget 1)
  (setq p1 (getpoint "\n Panel Insert Point ? :"))
  (setq p2 (polar p1 0 pnl-w))
  (setq p3 (polar p2 (dtr 90) pnl-d))
  (setq p4 (polar p1 (dtr 90) pnl-d))
  (command "pline" p1 "W" 0 "" p2 p3 p4 "c")
)

(defun make-doorx
       (p-key / d-p1 d-p2 d-p3 d-p4 d-p5 d-p6 d-p7 ang1 ang2 dist1)
  (cond
    ((= p-key 1) (setq d-size 50))
    ((= p-key 2) (setq d-size 200))
    ((= p-key 3) (setq d-size 50))
  )
  (command "Color" 5)
  (repeat 2
    (setq d-p1 p4)
    (setq d-p2 p3)
    (setvar "OSMODE" 0)
    (setq ang1 (angle d-p1 d-p2))
    (setq ang2 (angle d-p2 d-p1))
    (setq d-p3 (polar d-p1 ang1 d-size))
    (setq d-p4 (polar d-p2 ang2 d-size))
    (if	(= p-key 3)
      (setq dist1 (distance d-p3 d-p4))
      (setq dist1 (/ (distance d-p3 d-p4) 2))
    )
    (setq d-p5 (polar d-p3 (+ ang1 (dtr 30)) dist1))
    (if	(/= p-key 3)
      (progn
	(setq d-p6 (polar d-p4 (- ang2 (dtr 30)) dist1))
	(setq d-p7 (polar d-p3 ang1 dist1))
	(command "line" d-p3 d-p5 "" "arc" "c" d-p3 d-p7 d-p5)
	(command "line" d-p4 d-p6 "" "arc" "c" d-p4 d-p6 d-p7)
      )
      (progn
	(command "line" d-p3 d-p5 "" "arc" "c" d-p3 d-p4 d-p5)
      )
    )
    (setq p4 p2
	  p3 p1
    )
  )
  (command "Color" "Bylayer")
)

					; SH-cubicle's door
(defun c:cdr2 (/ d-size)
  (prompt "\n SH-Cubicle's Door Make (offset is 50) ")
  (old-endint)
  (la-set "CUB" 103)
  (make-door-2 50)
  (new-sn)
  (la-back)
  (prin1)
)

					; TR-cubicle's door
(defun c:cdr3 (/ d-size)
  (prompt "\n TR-Cubicle's Door Make (offset is 200) ")
  (old-endint)
  (la-set "CUB" 103)
  (make-door-2 200)
  (new-sn)
  (la-back)
  (prin1)
)

					; Two-door system drawing
(defun make-door-2 (d-size / p1 p2 p3 p4 p5 p6 p7 ang1 ang2 dist1)
  (setvar "OSMODE" 33)
  (setq p1 (getpoint "\n First Fance at \"Door-Post [LEFT]\" select :"))
  (setq	p2 (getpoint
	     "\n Second Fance at \"Door-Post [RIGHT]\" select :"
	   )
  )
  (setvar "OSMODE" 0)
  (setq ang1 (angle p1 p2))
  (setq ang2 (angle p2 p1))
  (setq p3 (polar p1 ang1 d-size))
  (setq p4 (polar p2 ang2 d-size))
  (setq dist1 (/ (distance p3 p4) 2))
  (setq p5 (polar p3 (+ ang1 (dtr 30)) dist1))
  (setq p6 (polar p4 (- ang2 (dtr 30)) dist1))
  (setq p7 (polar p3 ang1 dist1))
  (command "Color" 5)
  (command "line" p3 p5 "" "arc" "c" p3 p7 p5)
  (command "line" p4 p6 "" "arc" "c" p4 p6 p7)
  (command "Color" "Bylayer")
)

					; Single-door system drawing
(defun c:cdr1 ()
  (old-endint)
  (la-set "CUB" 103)
  (prompt "\n LV-Cubicle's Door Make (offset is 50) ")
  (make-door-1 50)
  (new-sn)
  (la-back)
  (prin1)
)

(defun make-door-1 (d-size / p1 p2 p3 p4 p5 ang1 ang2 dist1)
  (setvar "OSMODE" 33)
  (setq p1 (getpoint "\n First Fance at \"Door-Post\" select :"))
  (setq p2 (getpoint "\n Second Fance at \"Door-Handle\" select :"))
  (setvar "OSMODE" 0)
  (setq ang1 (angle p1 p2))
  (setq ang2 (angle p2 p1))
  (setq p3 (polar p1 ang1 d-size))
  (setq p4 (polar p2 ang2 d-size))
  (setq dist1 (distance p3 p4))
  (setq p5 (polar p3 (+ ang1 (dtr 30)) dist1))
  (command "Color" 5)
  (command "line" p3 p5 "")
  (command "arc" "c" p3 p4 p5)
  (command "Color" "Bylayer")
)

					;(prompt "\n Cubicle Drawing -> [CUB], Door only -> [CDR1,CDR2,CDR3] ")

;;=====================================================================
;;;--------------------------------------------------------------------
;;; M.C.C Schedule & Diagram

(defun c:mcc ()
  (old-non)
  (la-set "LINE" 3)
  (j_dia-mcc)
  (la-back)
  (new-sn)
)

(defun j_dia-mcc (/	po1   po2   po3	  po4	po5   po6   po7	  key
		  v-dis	mo-n  mo-n2 no	  nn	pox   pox2  pox3  olds
		 )
					;-- New setting
  (command "color" "bylayer" "linetype" "s" "bylayer" "")

					;-- Schedule Type Receav
  (setq key1 1)
  (while key1
    (initget "Full Simple ?")
    (setq key
	   (getkword
	     "\n Mcc-Schedule Type ? = Full(9)/Simple(4)/?:<S> "
	   )
    )
    (if	(or (= key "") (= key nil))
      (setq key "Simple")
    )
    (cond
      ((= key "Simple") (setq v-dis 4000) (setq key1 nil))
      ((= key "Full") (setq v-dis 9000) (setq key1 nil))
      ((= key "?")
       (acad_helpdlg "lisp-hlp.hlp" "Top")
       (setq key nil)
      )
      (T (acad_helpdlg "lisp-hlp.hlp" "Top") (setq key nil))
    )
  )

					;-- Main MCCB-Diagram insert
  (setq po1 (getpoint "\n Pick the MCC-SCHEDULE point ? <Upper-Left>:"))
  (setq po2 (polar po1 (dtr 352.22) 3693.59))
  (setq po3 (polar po1 (dtr 351.822) 3725.9))
  (setq po4 (polar po1 (dtr 351.431) 3758.39))
  (setq po5 (polar po1 (dtr 357.7) 13322.8))
  (setq po6 (polar po1 (dtr 311.909) 13213.6))
  (setq po7 (polar po6 0 6000))
  (command "insert" "*mo-main" po1 "" "") ; main mccb
  (if (= key "Simple")
    (command "insert" "*mo-sc4" po6 "" "") ; wire-schedule
    (command "insert" "*mo-sc9" po6 "" "") ; wire-schedule
  )
  (setq mo-n (getreal "\n Enter Motor's Count ? <Number>:"))

					;-- Draw the Mcc-Diagram Insert Point
  (setq mo-n2 mo-n)
  (setvar "PDMODE" 3)
  (setvar "PDSIZE" -3)
  (while (>= mo-n 1)
    (command "point" po5)
    (setq po5 (polar po5 0 3000))
    (setq mo-n (1- mo-n))
  )

					;-- Draw the Note Column ( Vertical line )
  (command "color" 6)
  (while (>= mo-n2 1)
    (if	(= mo-n2 1.0)
      (command "color" 3)
    )
    (command "line" po7 (polar po7 (dtr 270) v-dis) "")
    (if	(>= mo-n2 2.0)
      (setq po7 (polar po7 0 3000))
    )
    (setq mo-n2 (1- mo-n2))
  )

					;-- Draw the Note Column ( Horigental line )
  (if (= key "Simple")
    (setq no 5
	  nn no
    )
    (setq no 10
	  nn no
    )
  )
  (repeat no
    (cond
      ((or (= no nn) (= no 1)) (command "color" 3))
      (T (command "color" 6))
    )
    (command "line" po6 po7 "")
    (setq po6 (polar po6 (dtr 270) 1000))
    (setq po7 (polar po7 (dtr 270) 1000))
    (setq no (1- no))
  )

					;-- Draw the Main-Bus line
  (command "color" 9)
  (command "line" po2 (list (car po7) (cadr po2)) "")
  (command "line" po3 (list (car po7) (cadr po3)) "")
  (command "line" po4 (list (car po7) (cadr po4)) "")

					;-- Draw the Body line for Diagram
  (command "color" 15 "linetype" "s" "elp" "")
  (setq pox (list (+ (car po7) 1500) (cadr po1)))
  (setq pox2 (polar pox (dtr 270) 7422.21))
  (setq pox3 (polar po1 (dtr 270) 7422.21))
  (command "line" po1 pox pox2 pox3 "")

					;-- Insert Ground-Terminal
  (command "insert" "*mo-gt" pox "" "")
  (command "color" "bylayer" "linetype" "s" "bylayer" "")

					;-- Setting's Return & End of Lisp
)

;;=====================================================================
;;;--------------------------------------------------------------------
;;; PANEL BOARD Diagram

(defun c:pnl ()
  (old-endint)
  (la-set "LINE" 3)
  (j_dia-pnl)
  (la-back)
  (new-sn)
)

(defun cb_array	(po cb_count cb_name cb_dist / po33)
  (setq po33 po)
  (while (>= cb_count 1)
    (command "insert" cb_name po33 "" "")
    (setq po33 (polar po33 (dtr 270) cb_dist))
    (setq cb_count (1- cb_count))
  )
  (setq po3 po33)
)

(defun j_dia-pnl (/	 po1	po2    po3    po4    po4-1  po4-2
		  po4-3	 po4-4	co-4   co-3   co-2   co-1   po5-1
		  po5-2	 po5-3	po5-4  olds
		 )
  (setvar "OSMODE" 33)
  (setq po1 (getpoint "\n Panel Diagram corner point ? <Upper-Left>:"))
  (setvar "OSMODE" 0)
  (setq po2 (polar po1 (dtr 270) 2969.58))
  (setq po3 (polar po2 0 2537.86))
  (setq	po4-1 po3
	po4-2 (polar po4-1 0 700)
	po4-3 (polar po4-2 0 700)
	po4-4 (polar po4-3 0 700)
  )
  (command "insert" "*m-main" po1 "" "")
  (setq co-4 (getreal "\n Enter 4-Pole Break Number's ? :"))
  (setq co-3 (getreal "\n Enter 3-Pole Break Number's ? :"))
  (setq co-2 (getreal "\n Enter 2-Pole Break Number's ? :"))
  (setq co-1 (getreal "\n Enter 1-Pole Break Number's ? :"))

  (cb_array po3 co-4 "*m-m4p" 1500)
  (cb_array po3 co-3 "*m-m3p" 1200)
  (cb_array po3 co-2 "*m-e2p" 900)
  (cb_array po3 co-1 "*m-m1p" 600)

  (command "insert" "*m-gtnt" po3 "" "")
  (setq	po5-1 (polar po3 (dtr 270) 900)
	po5-2 (polar po5-1 0 700)
	po5-3 (polar po5-2 0 700)
	po5-4 (polar po5-3 0 700)
	po5-4 (polar po5-4 (dtr 270) 1069.29)
  )
  (command "color" "9")
  (command "line" po4-1 po5-1 "")
  (command "line" po4-2 po5-2 "")
  (command "line" po4-3 po5-3 "")
  (command "line" po4-4 po5-4 "")
  (command "color" "bylayer")
  (prin1)
)

;;JCHBB.LSP
;;;---------------------------------------------------------------
;;; this program is first at the "park dae sig"
;;; date 1995. 5. 23
;;; date 1999. 3. 19
;;;---------------------------------------------------------------
;;(prompt "\n please wait [ CHBB ] as loding .... ")


(defun chbb_name_1 (/ a)
  (setq a2 nil)
  (setq a (entsel "\n\t* Pick an object to be Select-block : "))
  (if a
    (setq name1 (cdr (assoc 2 (entget (car a)))))
    (setq a2 T)
  )
)

(defun chbb_name_2 (/ a)
  (setq a (entsel "\n\t* Pick an object to be Service-block : "))
  (if a
    (setq name2 (cdr (assoc 2 (entget (car a)))))
  )
)

(defun chbb_set_1 ()
  (chbb_name_1)
  (set_tile "chbb_name1" name1)
)

(defun chbb_set_2 () (set_tile "chbb_name2" name2))

(defun chbb_call ()
  (setq name1 (get_tile "chbb_name1"))
  (setq name2 (get_tile "chbb_name2"))
  (setq op1 (get_tile "chbb_op1"))
  (setq op2 (get_tile "chbb_op2"))
  (setq op3 (get_tile "chbb_op3"))
)

(defun c:chbb (/ name1 name2 op1 op2 op3 xxx a2 kkk kkk1 kkk2)
	(command "undo" "group")
  (chbb_name_1)
  (chbb_name_2)
  (setq kkk 333)
  (while kkk
    (CHBB-MAIN)
    (if	kkk1
      (chbb_name_1)
    )
    (if	kkk2
      (chbb_name_2)
    )
  )
  (command "undo" "end")
)

(defun CHBB-MAIN ()

  (setq	kkk1 nil
	kkk2 nil
  )
  (if (= jinbox_chbb nil)
    (setq jinbox_chbb (load_dialog "jchbb"))
  )
  (new_dialog "jinchbb" jinbox_chbb)

  (if name1
    (set_tile "chbb_name1" name1)
  )
  (if name2
    (set_tile "chbb_name2" name2)
  )
  (set_tile "chbb_op1" "1")
  (set_tile "chbb_op2" "1")
  (set_tile "chbb_op3" "0")
  (if a2
    (mode_tile "chbb_name1" 2)
    (mode_tile "chbb_name2" 2)
  )
  (setq xxx 3)

  (while (> xxx 2)
    (action_tile
      "chbb_na1"
      "(setq kkk1 333 name1 nil)(done_dialog)"
    )
    (action_tile
      "chbb_na2"
      "(setq kkk2 333 name2 nil)(done_dialog)"
    )
    (action_tile "chbb_name1" "(setq name1 $value)")
    (action_tile "chbb_name2" "(setq name2 $value)")
    (action_tile "chbb_op1" "(setq op1 $value)")
    (action_tile "chbb_op2" "(setq op2 $value)")
    (action_tile "chbb_op3" "(setq op3 $value)")
					;    (action_tile "accept" "(chbb_call)(done_dialog)")
    (action_tile
      "cancel"
      "(setq name2 nil kkk1 nil kkk2 nil kkk nil)(done_dialog)"
    )
    (setq xxx (start_dialog))
  )
  (if (and (/= name1 nil) (/= name2 nil))
    (if	(and (/= name1 "") (/= name2 ""))
      (progn
	(setq kkk1 nil
	      kkk2 nil
	      kkk  nil
	)
	(chbb name1 name2 op1 op2 op3)
      )
    )
					;    (prompt "\n Defun is Error")
  )
)

(defun chbb (bna    s_name op1	  op2	 op3	/      i      os_old
	     olderr myerror	  blk1	 s_blk1	ebl    nl     l1
	     e2	    ed	   ban0	  p1	 y0
	    )
  (setq bna (strcase bna))
  (setq s_name (strcase s_name))
  (setq ch1 0)
  (setq i 0)
  (setvar "CMDECHO" 0)
  (setq os_old (getvar "OSMODE"))
  (setvar "OSMODE" 0)
  (setq	olderr	*error*
	*error*	myerror
	chm	0
  )
  (prompt "\n\t\t  *** select the block's *** : ")
  (setq ebl (ssget (list (cons 2 bna))))
  (prompt "\n\n\n\t\t    *** pless wate - changed ***")
  (setq nl (sslength ebl))
  (setq l1 (- nl 1))
  (while (<= i l1)
    (setq e2 (ssname ebl i))
    (setq ed (entget e2))
    (setq bna0 (cdr (assoc 2 ed)))
    (if	(= op1 "0")
      (setq blag (rtd 0))
      (setq blag (rtd (cdr (assoc 50 ed))))
    )
    (if	(= op2 "0")
      (setq blsc 1)
      (setq blsc (cdr (assoc 41 ed)))
    )
    (setq blla (cdr (assoc 8 ed)))
    (setq p1 (cdr (assoc 10 ed)))
    (if	(= (strcase bna) (strcase bna0))
      (progn
	(command "erase" e2 "")
	(command ".insert" s_name p1 blsc "" blag)
	(if (= op3 "1")
	  (command "chprop" (entlast) "" "la" blla "")
	)
	(setq ch1 (+ ch1 1))
      )
    )
    (setq i (+ i 1))
  )
  (prompt (strcat
	    "\n\t"	      "thank you! changed ["
	    bna		      "]-->["		s_name
	    "] count is = "
	   )
  )
  (prin1 ch1)
  (setvar "osmode" os_old)
  (prin1)
  (setq	m_data (strcat "CHBB //"
		       bna
		       "// --> //"
		       s_name
		       "// count is = <"
		       (itoa ch1)
		       ">"
	       )
  )
;  (command "MODEMACRO" m_data)
)

					;(prompt " loaded ! ")
					;(prompt "\n*** type the [ chbb ] is change-block *** ")

					;(setq tdata nil tblist nil lynm nil)

					;(defun tnlist (/ tdata tblist lynm)
					;    (while (setq tdata (tblnext "block" (not tdata)))
					;        (setq lynm (assoc 2 tdata))
					;        (if (/= lynm "")
					;            (setq tblist (append tblist (list lynm)))
					;        )
					;    )
					;    tblist
					;)


;;--------------- Simpley Function Key 

;;---------------------------------------------------------------------------
;;--------------- Fillet-Function
;;---------------------------------------------------------------------------

(defun fill-comm (a)
  (prompt "\n\t Now Fillet-radious as [")
  (prin1 a)
  (prompt "].. Thank-you ! ")
  (setvar "FILLETRAD" a)
  (prin1)
)

;;--------------- Simpley Fillet-Function
(defun c:f05 () (fill-comm 50) (command "fillet" ""))
(defun c:f1 () (fill-comm 100) (command "fillet" ""))
(defun c:f15 () (fill-comm 150) (command "fillet" ""))
(defun c:f2 () (fill-comm 200) (command "fillet" ""))
(defun c:f25 () (fill-comm 250) (command "fillet" ""))
(defun c:f3 () (fill-comm 300) (command "fillet" ""))
(defun c:f35 () (fill-comm 350) (command "fillet" ""))
(defun c:f4 () (fill-comm 400) (command "fillet" ""))
(defun c:f45 () (fill-comm 450) (command "fillet" ""))
(defun c:f0 () (fill-comm 0.0) (command "fillet" ""))
(defun c:f5 () (fill-comm 500) (command "fillet" ""))
(defun c:f55 () (fill-comm 550) (command "fillet" ""))
(defun c:f6 () (fill-comm 600) (command "fillet" ""))
(defun c:f65 () (fill-comm 650) (command "fillet" ""))
(defun c:f7 () (fill-comm 700) (command "fillet" ""))

;(DEFUN C:Fc ()
;  (prompt
;    "\n\t The Fillet command as [CROSSING].. Thank-you ! "
;  )
;  (COMMAND "FILLET" "C")
;)

(DEFUN C:cmc ()
  (prompt
    "\n\t The chamfer command as [CROSSING].. Thank-you ! "
  )
  (COMMAND "chamfer" "C")
)
;;-------------------------------------------------------------------------
;;--------------- Line-Line Fillet-Function (H,V)
(defun line-fill (key / pnt1 pnt2 pnt3 pnt4 a b)
  (graphscr)
  (old-qua)
  (setvar "OSMODE" 16)
  (prompt "\n\t Extend-Fillet command -Radious is [")
  (prin1 (getvar "FILLETRAD"))
  (prompt "] - :")
  (setq pnt1 (getpoint "\nFirst corner of rectangle : "))
  (setq pnt3 (getpoint "\nSecond corner of rectangle : "))
  (setvar "osmode" 0)
  (if (= key 1)
    (progn
      (setq pnt2 (list (car pnt3) (cadr pnt1)))
      (setq pnt4 (list (car pnt1) (cadr pnt3)))
      (setq f-new1 (distance pnt1 pnt2))
      (setq f-new2 (distance pnt3 pnt2))
    )
    (progn
      (setq pnt4 (list (car pnt3) (cadr pnt1)))
      (setq pnt2 (list (car pnt1) (cadr pnt3)))
      (setq f-new1 (distance pnt1 pnt2))
      (setq f-new2 (distance pnt3 pnt2))
    )
  )
  (if (< f-new1 f-new2)
    (setq f-new f-new1)
    (setq f-new f-new2)
  )
  (command "line" pnt1 pnt2 "")
  (setq a (entlast))
  (command "line" pnt2 pnt3 "")
  (setq b (entlast))
  (new-sn)
  (setq f-dir (getvar "FILLETRAD"))
  (setq f-old f-dir)
  (if (< f-new f-dir)
    (setq f-dir (- f-new 1))
  )
  (setvar "FILLETRAD" f-dir)
  (command "fillet" a b)
  (setvar "FILLETRAD" f-old)
  (prin1)
)

(defun C:LH () (line-fill 1) (prin1))
(defun C:LV () (line-fill 2) (prin1))

;;--------------- Line-Line Fillet-Function2
(defun po-get ()
  (setvar "ORTHOMODE" 1)
  (setq xx 1)
  (setq po1 (getpoint "\n First point : "))
  (if po1
    (progn
      (setvar "osmode" 0)
      (setq po2 (getpoint po1 "\t Second point : "))
      (command "line" po1 po2 "")
      (setq xx 0)
    )
  )
)

(defun po-get2 (p1 p2 / ang-first po2 xp1 xp2 yp1 yp2)
  (setvar "ORTHOMODE" 1)
  (setq ang-first (rtd (angle p1 p2)))
  (if (<= ang-first 45)
    (setq ang1 0)
    (if	(<= ang-first 135)
      (setq ang1 90)
      (if (<= ang-first 225)
	(setq ang1 180)
	(if (<= ang-first 315)
	  (setq ang1 270)
	)
      )
    )
  )
  (setq stp1 (getpoint p2 "\n Select Second Block : (QUA Point)"))
  (setvar "OSMODE" 0)
  (setq	xp1 (car p1)
	yp1 (cadr p1)
  )
  (setq	xp2 (car stp1)
	yp2 (cadr stp1)
  )
  (if (or (= ang1 0) (= ang1 180))
    (if	(> yp1 yp2)
      (setq stp2 (polar stp1 (dtr 90) (- yp1 yp2)))
      (if (< yp1 yp2)
	(setq stp2 (polar stp1 (dtr 270) (- yp2 yp1)))
      )
    )
  )
  (if (or (= ang1 90) (= ang1 270))
    (if	(> xp1 xp2)
      (setq stp2 (polar stp1 (dtr 0) (- xp1 xp2)))
      (if (< xp1 xp2)
	(setq stp2 (polar stp1 (dtr 180) (- xp2 xp1)))
      )
    )
  )
  (command "line" stp1 stp2 "")
)

(defun ll-msg ()
  (graphscr)
  (prompt "\t Extend-Fillet command -Radious is[")
  (prin1 (getvar "FILLETRAD"))
  (prompt "] :")
)

(defun fdi-get ()
  (setq pnt5 (inters pnt1 pnt2 pnt3 pnt4 nil))
  (setq f-dis1 (distance pnt1 pnt5))
  (setq f-dis2 (distance pnt3 pnt5))
  (setq f-old (getvar "FILLETRAD"))
  (setq f-rad f-old)
  (if (> f-dis1 f-dis2)
    (setq f-dis f-dis2)
    (setq f-dis f-dis1)
  )
  (if (> f-rad f-dis)
    (setq f-rad (- f-dis 1))
  )
  (if (= f-old f-rad)
    (setq f-rad nil)
    (setvar "FILLETRAD" f-rad)
  )
)

(defun C:LL (/ po1 po2 pnt1 pnt2 pn3 pnt4 pnt5 a b f-dis1 f-dis2 f-dia
	     f-rad f-old)
  (setq	a nil
	b nil
	f-rad nil
	xx 0
	po1 nil
  )
  (old-qua)
  (LL-MSG)
  (PO-GET)
  (setq	pnt1 po1
	pnt2 po2
  )
  (setq a (entlast))
  (setvar "osmode" 16)
  (PO-GET2 pnt1 pnt2)
  (if (= xx 0)
    (progn
      (setq pnt3 stp1
	    pnt4 stp2
      )
      (setq b (entlast))
      (FDI-GET)
      (setvar "OSMODE" 0)
      (command "fillet" a b)
      (if f-rad
	(setvar "FILLETRAD" f-old)
      )
    )
  )
  (new-sn)
)

;;;-----------------------------------------------------------------------
;;--------------- Line-Line Fillet-Function3
(defun C:LR (/ xx po1 po2 po1-c po1-e po2-c po2-e fil-r dist1 ang1)
  (setq xx nil)
  (setq fil-r (getvar "FILLETRAD"))
  (if (> fil-r 1)
    (setq xx 1)
    (setq xx 0)
  )
  (if (= fil-r 0)
    (prompt "\n Radius < 1 --> Program is **cancel** ")
    (progn
      (old-qua)
      (setq po1 (getpoint "\n Enter First Point :"))
      (setq po2 (getpoint po1 "\n Enter Second Point :"))
      (setq dist1 (distance po1 po2))
      (if (< dist1 (* fil-r 2))
	(progn
	  (setq xx 0)
	  (prompt "\n Distance < Radius --> Program is **cancel** ")
	)
      )
      (while (= xx 1)
	(setvar "OSMODE" 0)
	(setq ang1 (angle po1 po2))
	(setq po1-c (polar po1 (+ (dtr 0) ang1) fil-r)) ;
	(setq po1-e (polar po1-c (+ (dtr 90) ang1) fil-r)) ;
	(setq po2-c (polar po2 (+ (dtr 180) ang1) fil-r))
	(setq po2-e (polar po2-c (+ (dtr 90) ang1) fil-r))
	(command "arc" "c" po1-c po1-e po1) ; Drawing
	(command "arc" "c" po2-c po2 po2-e) ; Drawing
	(command "line" po1-e po2-e "")	; Drawing
	(setq xx 0)
      )
      (new-sn)
    )
  )
)					; End of Lisp

;;--------------- Line-Line Fillet-Function2 + Line-Type Marking
(defun c:ell () (c:ll) (c:lle))
(defun c:exll () (c:ll) (c:llex))
(defun c:tll () (c:ll) (c:llt))
(defun c:tvll () (c:ll) (c:lltv))
(defun c:fll () (c:ll) (c:llf))
(defun c:sll () (c:ll) (c:lls))
(defun c:dcll () (c:ll) (c:lldc))
(defun c:oall () (c:ll) (c:lloa))
(defun c:ull () (c:ll) (c:llu))


;;--------------- Object-Setting Change
(defun C:CL2 (/ a1 a2 b2 la-name)
  (setq	olderr	*error*
	*error*	myerror
	chm	0
  )
  (prompt "\n ** Select entities to be changed : ")
  (setq a1 (ssget))
  (if a1
    (progn
      (prompt "\n ** Point to entity on target layer : ")
      (setq a2 (entsel))
      (if a2
	(progn
	  (setq b2 (entget (car a2)))
	  (setq la-name (cdr (assoc 8 b2)))
	  (setq lt-name (cdr (assoc 6 b2)))
	  (setq co-name (cdr (assoc 62 b2)))
	  (if (= lt-name nil)
	    (setq lt-name "bylayer")
	  )
	  (if (= co-name nil)
	    (setq co-name "bylayer")
	  )
	)
	(setq la-name (getstring "\n Enter target Layer Name : "))
      )
      (command "CHPROP"	a1 "" "layer" la-name "c" co-name "lt" lt-name
	       "")
    )
  )
)

;;--------------- Insert Block for Title 
(defun c:ti1 () (command "insert" "ti1"))
(defun c:ti2 () (command "insert" "ti2"))
;;--------------- End of Lisp

;;=================
(DEFUN C:OF (/ kk aa p1)
	(prompt "\n\t Cable Tray's Border Box Drawing :[")
	(prin1 of_key)
	(prompt "]")
	(if (= of_key nil)
		(set_of_key)
	)
	(setq kk 1)
	(if (= nil (SETQ AA (ENTSEL "\n Select of the Tray Box : <Pick>")))
		(set_of_key)
		(progn
			(redraw (car aa) 3)
			(setq p1 (getpoint "\n Enter Inside Position of Tray box : "))
			(command "offset" of_key aa p1 "")
			(command "chprop" "last" "" "color" 7 "")
			(while kk
				(SETQ AA (ENTSEL "\n Select of the Tray Box : <Pick>"))
				(if aa
					(progn
						(redraw (car aa) 3)
						(setq p1 (getpoint "\n Enter Inside Position of Tray box : "))
						(command "offset" of_key aa p1 "")
						(command "chprop" "last" "" "color" 7 "")
					)
					(setq kk nil)
				)
			)
		)
	)
)

(defun set_of_key (/ a)
	(prompt "\n Enter Border Space = <")
	(prin1 of_key)
	(setq a (getdist "> ? :"))
	(if a
		(setq of_key a)
	)
)

;;(defun c:ooo()(set_of_key)(c:of))
;;;Purge할때 "Y"누르기 싫으면 사용하세요...
;;
;;
;;사용방법:PP.LSP를 Load한후 PP를 입력하세요.
;;그럼 Text window가 나타나며 Purge상황을 보여 줍니다.
;;Purge는 지울게 더이상 없을때 까지 계속해서 반복합니다.
;;
;;
;;
;;연락처...
;;천리안 : ykafox
;;email  : ykafox@chollian.net

;;== ERROR
(defun myerr (msg)
  (if (/= msg "Function cancelled")
    (princ (strcat "\nError: " msg))
  )
  (setq *error* err)
  (princ)
)

;;== MAIN
(defun c:pp ()
  (setq	err *error*
	*error*	myerr
  )
  (textscr)
  (setvar "cmdecho" 0)
  (if (= "DIM" (getvar "cmdnames"))
    (command "exit")
  )
  (setvar "cmdecho" 1)
  (fp)
  (while (/= fm "") (rp) (fp))
  (setq *error* err)
  (GRAPHSCR)
  (princ)
)

(defun fp ()
  (command "purge")
  (command "all")
  (princ "\n")
  (command "")
  (princ "\n")
  (command "")
  (setq	fm (getvar "cmdnames")
	cm fm
  )
)

(defun rp ()
  (while (/= cm "")
    (command "y")
    (setq cm (getvar "cmdnames"))
  )
)

;;(Princ "\nC:PP  AutoPurge.  1999.11.16")
;;(princ)

;;== END

;;====에라나서 뒤로 빼 옮겻음.....
(defun C:TA (/ e1 nl n tt i e2 ed t0 tt1 tt2)
					; Multiple Text-line Change
  (setq	olderr	*error*
	*error*	TEXERROR
	chm	0
  )
  (prompt " = Text Change -> All Line ")
  (setq ts (sel_text))
  (if ts
    (progn (setq l (sslength ts))
	   (setq sz (getstring "New Text :" t))
	   (setq m_data (strcat "New Text All = <" sz ">"))
;	   (command "MODEMACRO" m_data)
	   (chg_text ts sz 1)
    )
  )
)

(defun c:i (/ a olds)
  (setq	olderr	*error*
	*error*	TEXERROR
	chm	0
  )
  (old-non)
  (setq b (strcase (getvar "INSNAME")))
  (prompt "\n Insert Block Name ? : <")
  (prin1 b)
  (setq a (strcase (getstring "> ? :")))
  (if (or (= a nil) (= a ""))
    (setq a b)
  )
  (setq m_data (strcat "InsertT Block Name = <" a ">"))
;  (command "MODEMACRO" m_data)
  (command "_.insert" a)
  (new-sn)
  (prin1)
)

(princ)
(prin1)


;;////////////////////////////// End-List Other Lisp Program File's ///////////////////


;;=======가감승제...@(^.^)@..
					;(defun c:+()(jin_cal_sym "+"))
					;(defun c:-()(jin_cal_sym "-"))
					;(defun c:*()(jin_cal_sym "*"))
					;(defun c:/()(jin_cal_sym "/"))

					;(defun JIN_CAL_SYM (giho / sel_t1 e1 nl n i chm e2 t0 tt1 tt2 ed tt xx ttn)
					;   (prompt " = Text No. Typical Calcurator : [ ")(prin1 giho)(prompt " ]")
					;   (setq olderr  *error* *error* TEXERROR chm 0)
					;   (setq e1(sel_text))
					;      (if e1
					;         (progn
					;            (setq tt 0 xx 0)
					;            (initget 4)
					;						(cond
					;							((= giho "+")(setq XX (getreal "\n Enter Addition Number ? +<1> :")))
					;							((= giho "-")(setq XX (getreal "\n Enter Subtraction Number ? -<1> :")))
					;							((= giho "*")(setq XX (getreal "\n Enter Multiplication Number ? *<1> :")))
					;							((= giho "/")(setq XX (getreal "\n Enter Division Number ? /<1> :")))
					;							(T nil)
					;						)
					;           (if (or (= XX nil)(= XX "")) (setq XX 1))
					;           (setq nl(sslength e1))
					;            (setq i 0)
					;            (setq nl(sslength e1))
					;            (setq n(- nl 1))
					;            (while (<= i n)
					;               (setq ed(entget (ssname e1 i)))
					;								(setq tt(atof (cdr (assoc 1 ed))))
					;								(if (/= tt 0.0)
					;									(progn
					;										(cond
					;											((= giho "+")(setq tt(+ tt xx)))
					;											((= giho "-")(setq tt(- tt xx)))
					;											((= giho "*")(setq tt(* tt xx)))
					;											((= giho "/")(setq tt(/ tt xx)))
					;											(T nil)
					;										)
					;   	                (setq ttn (rtos tt))
					;		                (setq ed(subst (cons 1 ttn)(assoc 1 ed) ed))
					;			              (entmod ed)
					;									)
					;								)
					;								(setq i(1+ i))
					;            )
					;            (prompt "\n Calcurator is Complete...: ")(prin1 xx)(prin1)
					;         )
					;      )
					;   (prin1)
					;)
					;(prin1)


;-----
; 자 료 명 : AUTO-PURGE
; 파 일 명 : APG.LSP
; 실 행 명 : APG
; 만 든 이 : 김 판 성  (pskim@mail.knm.net)
; 배 포 처 : http://my.netian.com/~daeho71/
;-----

;;++++++++++++++++++++++++++ xoutside.com +++++++++++++++++++++++++++++++++++++++
(defun filefind (dirs file / *getdirs*)
;; 하위폴더 경로를 모두 찾는 재귀함수다.
	(defun *getdirs* (dirs / dirs)
	;; 리턴받은 경로의 하위폴더명을 저장하고
		(setq dirs
			(mapcar '(lambda (x)	(strcat dirs "/" x))
          (cddr (vl-directory-files dirs "*" -1))
			)
      )
      ;; 경로를 리스트로 묶어 리턴한다.
      (apply 'append
        (mapcar
         '(lambda (x)
            (cond
              ((null x)    nil)
              ((listp x)   x)
              (t           (list x))
            )
          )
          ;; 자신의 함수로 보내 경로들의 하위경로를 리턴받는다.
          ;; 하위경로가 존재하지 않으면 (mapcar '*getdirs* nil) 은 실행되지 않는다.
          (cons dirs 
            (mapcar '*getdirs* dirs)
          )
        )
      )
    )
    ;; 하위경로를 포함한 모든 경로에서 file 이름들을 찾아 리스트로 리턴한다.
    (apply 'append
      (mapcar
       '(lambda (d)
          (mapcar

;             '(lambda (f) (strcat d "/" f)) ; /가 에라가 나오는거 같음...
             '(lambda (f) (strcat d f))

				 (vl-directory-files d file 1)
          )
        )
        ;; 하위경로와 자신의 경로를 리스트로 만든다.
        (cons dirs (*getdirs* dirs))
      )
    )
)
;;******************************************************************************

(defun APG2 (DWG FH)
    (write-line "open" fh)
    (write-line "Y" fh)
    (write-line DWG FH)
    (write-line "JPLOTA3R" fh)
);;defun


(defun C:APG2 (/ ALIST FH ITEM)
    (setq 
		ALIST (acad_strlsort (filefind (getvar "DWGPREFIX") "*.DWG"))
		atest alist
		FH (open (strcat (getvar "DWGPREFIX") "APG.SCR") "w"))
    (WRITE-LINE "")
    (foreach ITEM ALIST
    (APG2 ITEM FH))
    (write-line "end"fh)
    (setq FH (close FH))
    (prompt "\nAutomatic PURGE...")
	 (setq scr_name (strcat (getvar "DWGPREFIX") "APG"))
    (command "SCRIPT" scr_name)
)

;;***************** Running Program ********************
;;******************************************************************************

(defun APG3 (DWG FH)
    (write-line "open" fh)
    (write-line "N" fh)
    (write-line DWG FH)
    (write-line "ZE" fh)
    (write-line "JSHEETNEW" fh)
    (write-line "ZE" fh)
    (write-line "ERASELAST" fh)
    (write-line "REGEN" fh)
    (write-line "ZE" fh)
);;defun


(defun C:APG3 (/ ALIST FH ITEM)
    (setq 
		ALIST (acad_strlsort (filefind (getvar "DWGPREFIX") "*.DWG"))
		atest alist
		FH (open (strcat (getvar "DWGPREFIX") "APG.SCR") "w"))
    (WRITE-LINE "")
    (foreach ITEM ALIST
    (APG3 ITEM FH))
    (write-line "end"fh)
    (setq FH (close FH))
    (prompt "\nAutomatic PURGE...")
	 (setq scr_name (strcat (getvar "DWGPREFIX") "APG"))
    (command "SCRIPT" scr_name)
)

;;***************** Running Program ********************
(defun	C:PG()
	(terpri)(princ "  퍼지  <불필요한 것 삭제 > " )
	(setvar "cmdecho" 0)
	(command "purge" "ALL" "" "N") (princ))

(defun	c:ZE()
	(terpri)(princ "ZOOM EXTENTS" )
	(setvar "cmdecho" 0)
         (command "ZOOM" "E") (princ))

(defun	c:JSHEETNEW()
	(terpri)(princ "SHEET CHANGE" )
	(setvar "cmdecho" 0)
   (command "-INSERT" "SSS=" "0,0" "" "" "") (princ))

(defun	c:ERASELAST()
	(terpri)(princ "SHEET ERASE" )
	(setvar "cmdecho" 0)
	(command "ERASE" "LAST" "") (princ))

(defun C:JPLOTA3R()
	(setq pl_p1(getvar "EXTMIN")
			pl_p2(getvar "EXTMAX"))
	(command "_.plot"
	"Y"					; 상세구성?
	"model"				; 배치,모형

	"a3.pc3"
;	"jinplot.pc3"						; 출력장치 -> 밑에보고 필요한것으로 바꿈.
;	"jin14.pc3"							; 출력장치 -> 밑에보고 필요한것으로 바꿈.

;	"ISO A4 (210.00 x 297.00 MM)"
	"ISO A3 (297.00 x 420.00 MM)"	; 용지규격 -> 밑에보고 필요한것으로 바꿈.

	"M"					; 용지단위 (인치/미리)
	"L"					; 용지(가로/세로)
	"N"					; 뒤집어서출력?
	"W" pl_p1 pl_p2	; 화면/한계/리미트/뷰/윈도
	"Fit"					; 스케일
	"중심"					; 간격띄우기 x,y/중심
	"Y"					; 유형적용?
	"Aclt_WB_A3.ctb"	; 유형이름?
	"Y"					; 선가중치적용?
	"N"					; 은선제거?
	"N"					; 파일로출력?
	"Y"					; 변경사항저장?
	"Y"					; 출력ok?
	)
)

;;***************** END OF PROGRAM *********************
