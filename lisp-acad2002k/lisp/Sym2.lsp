; 수정날짜: 2001년 8월 13일
; 작업자: 박율구
; 명령어
        ;CIMPBOX
        ;CIMPPB
        ;CIMSC
        ;CIMSCD
        ;CIMSSL
        ;CIMCM
        ;CIMWAT
        ;CIMBL
        ;CIMESS
        ;CIMELM
        ;CIMLEM
        ;CIMSTS
(setq lfn07 1)
;=============================================================
; PBOX

(defun pbx_user ()
     
     (setq p1 (getpoint "\n시작점: "))
     (if (null p1) (exit))
     (setq lx (getdist p1 "\n가로 길이(mm) of Pbox: "))
     (if (null lx) (exit))
     (setq ly (getdist p1 "\n세로 길이(mm) of Pbox: "))
     (if (null ly) (exit))
)

;    Draw PBOX

(defun pbx_draw ()
     (command "pline"
         (setq p p1)
         (setq p (polar p 0 lx))
         (setq p (polar p (dtr 90) ly))
         (polar p (dtr 180) lx)
         "close"
     )
)

;Execute command, calling constituent functions

(defun m:PBOX ()
  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")
     (pbx_user)
     
     (setq scmde (getvar "cmdecho"))
     
     (pbx_draw)
     (command "rotate" "l" "" p1)
     
     (setvar "cmdecho" scmde)
     (princ "가로 길이(mm) :  ")
     (princ lx)
     (princ "세로 길이(mm) :  ")
     (princ LY)
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
     (princ)
)

(defun C:CIMPBOX () (m:pbox))
(princ)


;==============================================================
;                     부분상세 표기
;==============================================================
(defun m:PPB (/ cet cec p1 p2 p3 p4 p5 p6 p7 p8 p9 sc d1 a1 pnx snx)
  (princ "\nArchiFree 2002 for AutoCAD LT 2002")
  (princ "\n상세 부분 표기")
  
  (setq sc (getvar "dimscale"))
  (setq cec (getvar "cecolor"))
  (setq cet (getvar "TEXTSTYLE"))
  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")
  
  (setq p1 (getpoint "\n>>>좌측 하단 점 :   "))
  (if (null p1) (exit))
  (setq p2 (getcorner p1 "\n>>>우측 상단 점: "))
  (if (null p2) (exit))
  (setq p8 (list (car p2) (cadr p1)))
  (setq p9 (list (car p1) (cadr p2)))
  (setq a1 (angle p1 p2))
  (if (/= (type pn) 'INT) (setq pn 1))
  (initget (+ 2 4))
  (setq pnx (getint (strcat "\n상세 도면 번호 <" (itoa pn) ">: ")))
  (if (numberp pnx) (setq pn pnx))
  (if (null sn) (setq sn "A-1"))
  (setq snx (getstring (strcat "도면 번호 <" sn ">: ") T))
  (if (/= snx "") (setq sn snx))
  (if (and (> a1 (dtr 90)) (< a1 (dtr 270)))
    (setq a2 (dtr 180))
    (setq a2 0)
  )
  (setq p3 (polar p2 a1 (* sc 10)))
  (setq p4 (polar p3 a2 (* sc 20)))
  (setq p5 (polar p3 a2 (* sc 14)))
  (setq p6 (polar p5 (dtr 90) (* sc 2.5)))
  (setq p7 (polar p5 (dtr 270) (* sc 2.5)))
  (setlay "SYMBOL")
  (setvar "osmode"0)
  (command "color" co_5)
  (command "pline" p1 "w" 0 0 p8 p2 p9 "C")
  (command "chprop" "l" "" "LT" "PHANTOM" "")
  (command "FILLET" "R" (* sc 3))
  (command "FILLET" "P" "L")
  (command "line" p2 p3 p4 "")
  (command "color" cec)
  (command "circle" p5 (* sc 6))
  (if (= (stysearch "SIM") nil)
    (styleset "SIM")
  )
  (command "dim1" "style" "SIM")
  (command "TEXT" "M" p6 (* sc 2.5) 0 pn)
  (command "TEXT" "M" p7 "" "" sn)
  (command "dim1" "style" cet)

  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ)
)

(defun C:CIMPPB () (m:ppb))
(princ)


;====================================================
;                단면표기(단선)                      
;====================================================
(defun m:SC (/ bm sc  p1 p2 p3 p4 p5 p6 p7 d1 a1 )
  
    
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n단면표시 기호(단선)를 그리는 명령입니다.")
  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")
  ;(setlay sc:lay)
  (setlay "ETCS")
  ;(command "_.layer" "_C" sc:col "" "")
  
  (setq sc (getvar "dimscale"))
  
  (setvar "osmode" 7)
  (setq p1 (getpoint "\nPick First Point:   "))
  (if (/= p1 nil) (progn
  (setq p2 (getpoint p1 "Pick Second Point: "))
  (if (/= p2 nil) (progn
	  (setq d1 (distance p1 p2))
	  (setq a1 (angle p1 p2))
	  (setq p3 (polar p1 a1 (/ d1 2))
	        p4 (polar p3 (+ a1 (dtr 180)) (* sc 1))
	        p5 (polar p3 (+ a1 (dtr 270)) (* sc 2.5))
	        p6 (polar p3 (+ a1 (dtr 90)) (* sc 2.5))
	        p7 (polar p3 a1 (* sc 1))
	  )
	  (setvar "osmode" 0)	  
	  (command "pline" p1 p4 p5 p6 p7 p2 "")
  ))))
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ)
)
;(if (null sc:lay) (setq sc:lay "ETCS"))
;(if (null sc:col) (setq sc:col 5))
(defun C:CIMSC () (m:sc))
(princ)


;===============================================================
;                단면표기(복선)                                 
;===============================================================
(defun m:SCD (/ bm sc p1 p2 p3 p4 p5 p6 p7 p8 p9 d1 a1 k ss ls)
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n단면표시 기호(복선)를 그리는 명령입니다.")
  (setq sc (getvar "dimscale"))
  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")
  (setlay "ETCS")
  
  (setvar "osmode" 7)
  (setq p1 (getpoint "\nPick First Point:   "))
  (if (null p1) (exit))
  (setq p2 (getpoint p1 "Pick Second Point: "))
  (if (null p2) (exit))
  (setq d1 (distance p1 p2))
  (setq a1 (angle p1 p2))
  (setq p3 (polar p1 a1 (/ d1 2))
        p4 (polar p3 (+ a1 (dtr 180)) (* sc 1))
        p5 (polar p3 (+ a1 (dtr 270)) (* sc 2.5))
        p6 (polar p3 (+ a1 (dtr 90)) (* sc 2.5))
        p7 (polar p3 a1 (* sc 1))
        p8 (polar p3 (+ a1 (dtr 270)) (* sc 1))
        p9 (polar p8 a1 (* sc 0.4))
  )
  
  (setvar "cmdecho" 0)
  (setvar "osmode" 0) 
  (command "pline" p1 p4 p5 p6 p7 p2 "")
  (command "copy" "L" "" p3 (polar p3 (+ a1 (dtr 90)) (* sc 1)))
  (command "move" "P" "" p3 p9)
  (setq ss (ssget "C" p1 p2))
  (setq ls (sslength ss))
  (setq k 0)
  (while (/= k ls)
  (redraw (ssname ss k))
  (setq k (1+ k))
  )
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ)
)

(defun C:CIMSCD () (m:scd))
(princ)


;=====================================================================
;                   단면기호 작성                                     
;=====================================================================
(defun m:SSL (/ bm sc cet p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11 p12 p13 p14
	        p15 p16 p17 p18 p19 p20 d1 a1 a2 senx shnx cec direction)
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n단면기호를 작성하는 명령입니다.")
  
  (setq sc (getvar "dimscale"))
  (setq cec (getvar "cecolor"))
  (setq cet (getvar "textstyle"))
  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")
  
  
  (setq p1 (getpoint "\n>>>Pick 1st Point of Section Symbol: "))
  (if (null p1) (exit))
  (setq p2 (getpoint p1 "\n>>>Pick 2nd Point of Section Symbol: "))
  (if (null p2) (exit))
  (setvar "orthomode" 0)
  (setq direction (getpoint p1 "\n>>>방향: "))
  (if (null direction) (exit))
  
  (setq direction (fix_90_ang (angle p1 p2) (angle p1 direction)))
  (if (/= (type SEN) 'INT) (setq SEN 1))
  (initget (+ 2 4))
  (setq senx (getint (strcat "\nEnter Section Number<" (itoa SEN) ">: ")))
  (if (numberp senx) (setq SEN senx))
  (if (null SHN) (setq SHN "A-1"))
  (setq shnx (strcase (getstring (strcat "Enter Sheet Number<" SHN ">: ") T)))
  (if (/= shnx "") (setq SHN shnx))
  
  (setq d1 (distance p1 p2))
  (setq a1 (angle p1 p2))
  (setq a2 a1)
;;;  (if (and (> a1 (dtr 90)) (< a1 (dtr 180)))
;;;    (setq a1 (+ a1 (dtr 180)))
;;;  )
;;;  (if (and (>= a1 (dtr 180)) (<= a1 (dtr 270)))
;;;    (setq a1 (- a1 (dtr 180)))
;;;  )
  (setq p3 (polar p1 (+ a1 direction) (* sc 10)))
  (setq p4 (polar p3 (dtr 180) (* sc 6)))
  (setq p5 (polar p3 0 (* sc 6)))
  (setq p6 (polar p2 (+ a1 direction) (* sc 10)))
  (setq p7 (polar p2 (+ a2 (dtr 180)) (* sc 2)))
  (setq p8 (polar p1 a2 (/ d1 2)))
  (setq p9 (polar p8 (+ a2 (dtr 180)) (* sc 0.5)))
  (setq p10 (polar p8 a2 (* sc 0.5)))
  (setq p11 (polar p8 (+ a2 (dtr 180)) (* sc 2)))
  (setq p12 (polar p8 a2 (* sc 2)))
  (setq p13 (polar p1 a2 (* sc 27.5)))
  (setq p14 (polar p1 a2 (* sc 29)))
  (setq p15 (polar p1 a2 (* sc 30)))
  (setq p16 (polar p2 (+ a2 (dtr 180)) (* sc 27.5)))
  (setq p17 (polar p2 (+ a2 (dtr 180)) (* sc 29)))
  (setq p18 (polar p2 (+ a2 (dtr 180)) (* sc 30)))
  (setq p19 (polar p3 (dtr 90) (* sc 2.5)))
  (setq p20 (polar p3 (dtr 270) (* sc 2.5)))
  (setlay "SYMBOL")
  (setvar "osmode"0)
  (command "insert" "ssh" p1 sc "" (* (/ (+ a1 (if (< direction 0) pi 0) ) pi) 180))
  (command "line" p4 p5 "")
  (command "color" co_5)
  (if (<= d1 (* sc 60))
    (progn
      (command "line" p1 p11 "")
      (command "line" p9 p10 "")
      (command "line" p12 p2 p6 p7 "")
    )
    (progn
      (command "line" p1 p13 "")
      (command "line" p14 p15 "")
      (command "line" p18 p17 "")
      (command "line" p16 p2 p6 p7 "")
    )
 )
 (command "color" cec)
 (if (= (stysearch "SIM") nil)
   (styleset "SIM")
  )
 (command "dim1" "style" "SIM")
 (command "text" "M" p19 (* sc 2.5) 0 SEN)
 (command "text" "M" p20 "" "" SHN)
 (command "dim1" "style" cet)
 (rtnlay)
 (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ)
)

(defun C:CIMSSL () (m:ssl))
(princ)


;==============================================================
;         숫자에 콤마(,) 삽입하기                              
;==============================================================
(defun m:cm (/ CVS lumx k smx dmm f1 f2 ai_cm comd num dn)
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n숫자에 콤마(,)를 삽입하거나 제거하는 명령입니다.")
  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")
  (setq ss (ssget '((0 . "TEXT"))))
  (if ss
    (progn
	  (initget 1 "I R  ")
	  (if (not (member cm_com '("I" "R"))) (setq cm_com "I"))
	  (setq comd (getkword (strcat
	             "\n>>>    Number Comma <I>nsert/<R>emove <" cm_com ">? ")))
	  (if (member comd '("I" "R")) (setq cm_com comd))
	  (if (= cm_com "I")
	    (progn
		  (initget 4)
		  (if (/= (type lum) 'INT)
		    (setq lum (getvar "luprec"))
		  )
		  (setq lumx (getint
		    (strcat "소수점 이하 자릿수<" (itoa lum) ">: "))
		  )
		  (if (numberp lumx) (setq lum lumx))
 	  	  (princ "\n\tComma creating...")
		)
	    (princ "\n\tComma removing...")
	  )
	  (setq k 0)
	  (repeat (sslength ss)
	    (princ ".")
	    (setq dmm (entget (ssname ss k))
	    	  f1  (assoc '1 dmm)
	    	  smx (cdr f1)
	    )
	    (if (= (instr smx "(") 1)
	      (setq smx   (substr smx 2)
	      		ai_cm "Y"
	      )
	    )
	    (if (/= (instr smx ")") nil)
	      (setq smx   (substr smx 1 (1- (instr smx ")")))
	      		ai_cm "Y"
	      )
	    )
	    (RMC)
	    (if (/= (atof smx) 0)
	      (progn
	  		(if (= cm_com "I")
			  (progn
		        (COMMA (atof smx) lum)
		        (if (= ai_cm "Y")
		          (setq CVS (strcat "(" CVS ")"))
		        )
		        (setq f2 (subst (cons 1 CVS) f1 dmm))
			  )
			  (progn
	    		(if (setq dn (instr smx "."))
				  (progn
				  	(setq num (substr smx (1+ dn)))
					(if (= (atoi num) 0)
					  (setq smx (substr smx 1 (1- dn)))
					  (setq smx (strcat (substr smx 1 (1- dn)) "." (itoa (atoi num))))
					)
				  )
				)
		        (if (= ai_cm "Y")
		          (setq smx (strcat "(" smx ")"))
		        )
		        (setq f2 (subst (cons 1 smx) f1 dmm))
			  )
			)
	        (entmod f2)
	      )
	    )
	    (setq k (1+ k))
	    (setq ai_cm nil)
	  )
	  (princ "  done!")
	)
  )
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ)
)

(defun C:CIMCM () (m:cm))
(princ)

;===============================================================
; Revision 1990. 2. 9.
; 오배수 라인 그리기
(defun m:WAT (/ sc ww p1 ps pe p2 p3 p4 p5 dw sng sf )
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n오수관, 우수관 그리기입니다.")
  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")
  
  (setq sc (getvar "dimscale"))
  (initget 1 "W R  ")
  (if (not (member wd '("W" "R"))) (setq wd "W"))
  (setq ww (getkword (strcat
        "\n오수관<W>, 우수관<R>  <" wd ">? ")))
  (if (member ww '("W" "R")) (setq wd ww))
  
  (setvar "osmode" (+ 33 512))
  (setq p1 (getpoint "시작점:   "))
  (while (not (null p1))
	  (setq pe (getpoint p1 "끝점: "))
	  (if (null pe) (exit))
	  (setq dw (distance p1 pe)
	        sng (angle p1 pe))
	  (setq ps p1)
	  (setq sf (fix (/ dw (* 20 sc))))
	  (setq p2 (polar p1 sng (* 17 sc))
	        p3 (polar p2 (- sng (dtr 90)) (* 1.5 sc))
	        p5 (polar p2 (+ sng (dtr 90)) (* 1.5 sc))
	        p4 (polar p2 sng (* 1.5 sc)))
	 
	  (setvar "osmode" 0) 
	  (SETLAY wat:lay)
	  (command "_.layer" "_C" wat:col "" "")
	  (repeat sf
	    (command "line" p1 p2 "")
	    (if (= wd "W")
	      (command "ARC" p3 p4 p5)
	      (command "line" p3 p4 p5 ""))
	    (setq p1 (polar p1 sng (* 20 sc))
	          p2 (polar p1 sng (* 17 sc))
	          p3 (polar p2 (- sng (dtr 90)) (* 1.5 sc))
	          p4 (polar p2 sng (* 1.5 sc))
	          p5 (polar p2 (+ sng (dtr 90)) (* 1.5 sc))
	    )
	  )
	  (setq p1 (polar ps sng (* sf 20 sc)))
	  (command "line" p1 pe "")
	  (if (= wd "W")
	    (princ "\n오수관 길이(M): ")
	    (princ "\n우수관 길이(M): ")
	  )
	  (princ (/ dw 1000))
	  (RTNLAY)
  	 (setq p1 (getpoint "\n시작점: "))
  )
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ)
)
(if (null wat:lay) (setq wat:lay "ETCS"))
(if (null wat:col) (setq wat:col 5))
(defun C:CIMWAT () (m:wat))
(princ)


;=============================================================
; Break Line 그리기                                           
;=============================================================
(defun m:BL (/ sc nk SP EP DS BBK HTK ST NU AN DX P1 P2 P3 P4 P5 ss)
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n잘라낸 부분을 표시하는 명령입니다.")
  (setq sc (getvar "dimscale"))
  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")
  
  
  (setq SP (getpoint "\nStart of Break Line: "))
  (setq nk 1)
  (while (/= SP nil)
    (setq EP (getpoint SP "\nEnd of Break Line: "))
    (if (null ep) (exit))
    (if (= nk 1)
      (progn
        (setq DS (distance SP EP))
        (if (/= (type BB) 'REAL)
          (setq BB (* sc 8))
        )
        (setq BBK (getdist SP (strcat
                  "\nPick or Enter ditance between breaks <" (rtos BB) ">: ")))
        (if (numberp BBK) (setq BB BBK))
        (if (/= (type HT) 'REAL)
          (setq HT (* sc 2))
        )
        (setq HTK (getdist SP (strcat
          "\nPick or Enter Height of vertex <" (rtos HT) ">: ")))
        (if (numberp HTK) (setq HT HTK))
      )
    )
   
    (setvar "OSMODE" 0)
    (setq ST (/ BB 1.2)
          NU (/ DS (+ BB HT))
          AN (angle SP EP)
          DX (+ HT BB)
          P1 (polar SP AN ST)
          P2 (polar P1 (+ AN (* PI 1.58)) HT)
          P3 (polar P2 (+ AN (* PI 0.42)) (* HT 2))
          P4 (polar P1 AN HT)
          P5 (polar P4 AN BB)
    )
    (command "_.LINE" SP P1 "")
    (repeat (fix NU)
      (command "_.LINE" P1 P2 P3 P4 P5 "")
      (setq P1 (polar P1 AN DX)
            P2 (polar P2 AN DX)
            P3 (polar P3 AN DX)
            P4 (polar P4 AN DX)
            P5 (polar P5 AN DX)
      )
    )
    (if (<= (distance SP P1) DS)
      (command "_.LINE" P1 EP "")
      (command "_.BREAK" "_L" EP P1)
    )
    (setq ss (ssget "F" (list SP EP) '((0 . "LINE"))))
    (command "_.PEDIT" "_L" "_Y" "_J" ss "" "")
    
    (princ "\n\n종료를 원하시면 Enter를 치십시오. ")
    (princ "\n")
    (setq SP (getpoint "Start of Break Line <exit>: "))
    (setq nk (1+ nk))
  )
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ)
)

(defun C:CIMBL () (m:bl))
(princ)


;=================================================================
;  전개도 기호 그리기                                             
;=================================================================
(defun m:ESS (/ cet sc p1 p2 p3 wid ttext)
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n전개도 기호를 그리는 명령입니다.")
  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")
  
  (setq sc (getvar "dimscale"))
  (setq cet (getvar "TEXTSTYLE"))
  (initget (+ 2 4))
  (setq p1 (getpoint "\n삽입점을 선택하십시오: "))
  (if (/= p1 nil)
    (progn
	  (setq p2 (polar p1 (dtr 90) (* sc 3.5)))
	  (setq p3 (polar p1 0 (* sc 3.5)))
	  (setq p4 (polar p1 (dtr 270) (* sc 3.5)))
	  (setq p5 (polar p1 (dtr 180) (* sc 3.5)))
	  (setlay "SYMBOL")
	  (setvar "osmode" 0)
	  (command "insert" "ESS" p1 sc "" 0)
	  (if (= (stysearch "SIM") nil)
	    (styleset "SIM")
	  )
	  (setvar "textstyle" "SIM")
	  (princ "\nEnter Number of ELEV. Clockwise...")
	  ;(princ "\nText: ")
          (setq ttext (getstring "\nText: "))
	  (command "text" "M" p2 (* sc 3) 0 ttext )
          (setq ttext (getstring "\nText: "))
	  (command "text" "M" p3 "" "" ttext )
      	  (setq ttext (getstring "\nText: "))
	  (command "text" "M" p4 "" "" ttext )
      	  (setq ttext (getstring "\nText: "))
	  (command "text" "M" p5 "" "" ttext )
	  
	  (rtnlay)
	 
    )
  )
	  (command "_.undo" "_en")
	  (ai_err_off)
	  (ai_undo_off)
	  (princ)
  
 
)
(defun C:CIMESS () (m:ess))
(princ)

;=============================================================
;
;   ELMARK.LSP   Version 3.10
;

(defun m:elm (/ temp      cont      uctr      _col
                p1        p2        p3        p4        p5        p6
                p7        el:txt    strtpt    lay-idx   old-idx   ecolor
                elayer    temp_color
                el_osc    el_ost
                el_oli    el_ola old_pt old_txt)

  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n입면도 높이를 표시하는 명령입니다.")

  (setq el_ost (getvar "textstyle")
        el_osc (getvar "dimscale")
  )
  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")
  
;;;  (command "_.LINETYPE" "_S" "CONTINUOUS" "")
  (if (lacolor el:lay)
    (setq el:col (lacolor el:lay))
    (command "_.layer" "_M" el:lay "_C" el:col el:lay "")
  )
  (if (lacolor el:tla)
    (setq el:tco (lacolor el:tla))
    (command "_.layer" "_M" el:tla "_C" el:tco el:tla "")
  )
  
 
  (if (not (stysearch el:sty))
    (styleset el:sty)
  )
  (setvar "textstyle" el:sty)

  (setq cont T uctr 0 temp T)

  (while cont
    (el_m1)
  )
  
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ)
)

(defun el_m1 (/ )
  (while temp
   
    (setvar "osmode" (+ 1 512))
    (if (numberp el:tco) (setq el:tco (color_name el:tco)))
    (princ (strcat "\n\nText_Style:<" el:sty "> Text_Size:<" (rtos el:the)
                   "> Text_Color:<" el:tco "> Text_Layer:<" el:tla ">"))
    (if (> uctr 0)
      (progn
        (initget "Color Layer Text Undo")
        (setq strtpt (getpoint
            "\n>>> Color/Layer/Text/Undo/<insertion point>: NEAREST to "))
      )
      (progn
        (initget "Color Layer Text")
        (setq strtpt (getpoint
            "\n>>> Color/Layer/Text/<insertion point>: NEAREST to "))
      )
    )
    
    (setvar "osmode" 0)
    (cond
      ((= strtpt "Color")
        (el_col T)
      )
      ((= strtpt "Layer")
        (el_lay T)
      )
      ((= strtpt "Text")
        (el_tex)
      )
      ((= strtpt "Undo")
        (command "_.undo" "_B")
        (setq uctr (1- uctr))
      )
      
      ((null strtpt)
        (setq cont nil temp nil)
      )
      (T
        (command "_.Undo" "_M")
        (el_ex)
        (setq uctr (1+ uctr))
      )
    )
  )
)

(defun el_ex (/ txt_tmp tmp_dist)
  (setq p2 strtpt
        p1 (polar p2 (dtr 135) (* el_osc (* el:the (/ 2 3.0)) (sqrt 2.0)))
        p3 (polar p2 (dtr 45) (* el_osc (* el:the (/ 2 3.0)) (sqrt 2.0)))
        p4 (polar p2 (dtr 90) (* el_osc (* el:the (/ 2 3.0))))
        p5 (polar p4 (dtr 90) (* el_osc (/ el:the 2.0)))
        p6 (polar p5 0 (* el_osc el:the 5))
        p7 (polar p5 (dtr 90) (* el_osc (* el:the 0.75)))
	p7 (polar p7 0 (* (distance p5 p6) 0.5))
  )
  
  (setlay el:tla)
  (if (not (null old_txt))
    (setq el:txt (comma (+ (atof old_txt) (- (cadr strtpt) (cadr old_pt))) 0))
    (setq el:txt (itoa 0))
  )
    
  (if (and buho_flag (> (atof el:txt) 0)) (setq el:txt (strcat "+" el:txt)))
  
  (setq txt_tmp (getstring (strcat "\nText<" el:txt ">: ")))
  (if (= txt_tmp "")
    (setq txt_tmp el:txt)
    (progn
        (if (= (substr txt_tmp 1 1) "+") (setq buho_flag 1) (setq buho_flag nil))
    	(setq old_txt txt_tmp)
        (setq old_pt strtpt)
    )
  )
  
  
  (command "_.text" "MC" p7 (* el_osc el:the) 0 txt_tmp)
  (setlay el:lay)
  (command "_.pline" p1 p2 p3 p4 p5 p6 "")

  (if (null old_pt) (setq old_pt strtpt))
  (if (null old_txt) (setq old_txt txt_tmp))
)

(defun el_tex (/ str tem)
  (setq tem T)
  (while tem
    (initget 1 "Color Height Layer Style  ")
    (if (numberp el:tco) (setq el:tco (color_name el:tco)))
    (princ (strcat "\n\nText_Style:<" el:sty "> Text_Size:<" (rtos el:the)
                   "> Text_Color:<" el:tco "> Text_Layer:<" el:tla ">"))
    (setq str (getkword "\n>>>Text_Color/Height/Layer/Style/<exit>: "))
    (cond
      ((= str "Color")
        (el_col nil)
      )
      ((= str "Height")
        (el_the)
      )
      ((= str "Layer")
        (el_lay nil)
      )
      ((= str "Style")
        (el_sty)
      )
      (T
        (setq tem nil)
      )
    )
  )
)

(defun el_the (/ the)
  (initget 6)
  (setq the (getreal (strcat "\nNew text height<" (rtos el:the) ">: ")))
  (if (numberp the) (setq el:the the))
)

(defun el_sty (/ sty)
  (menucmd "i=fonts2")
  (menucmd "i=*")
  (setq sty (getstring (strcat "\nNew text style<" el:sty ">: ")))
  (if (/= sty "") (setq el:sty sty))
  (if (not (stysearch el:sty))
    (styleset el:sty)
  )
  (setvar "textstyle" el:sty)
)

(defun el_col (x)
  (if x
    (setq _col el:col)
    (setq _col el:tco)
  )
  (setq ecolor
    (if (= (type _col) 'STR) (get_num (strcase _col)) _col)
  )
  (if (numberp (setq temp_color (acad_colordlg ecolor t)))
    (progn
      (setq ecolor temp_color)
      (setq _col ecolor)
      (if (and (/= _col 256) (/= _col 0))
        (command "_.layer" "_C" _col (if x el:lay el:tla) "")
      )
    )
  )
  (if x
    (setq el:col _col)
    (setq el:tco _col)
  )
)
;;
;; This function pops a dialogue box consisting of a list box,image tile, and 
;; edit box to allow the user to select or type a layer name.  It returns the 
;; layer name selected.  It also has a button to find the status (On, Off, 
;; Frozen, etc.) of any layer selected.
;;
(defun el_lay (x / old-idx layname on off frozth)
  (if x
    (setq elayer el:lay)
    (setq elayer el:tla)
  )

  (cond
    (  (not (ai_acadapp)))                      ; ACADAPP.EXP xloaded?
    (  (not (setq dcl_id (ai_dcl "dd_prop"))))  ; is .DLG file loaded?
    (t (ai_undo_push)
       (make_laylists)                          ; layer list - laynmlst
       (setq lay-idx (get_index elayer laynmlst))
    )
  )
  (if (not (new_dialog "setlayer" dcl_id))
    (exit)
  )
  (set_tile "cur_layer" (getvar "clayer"))
  (start_list "list_lay")
  (mapcar 'add_list longlist)  ; initialize list box
  (end_list)
  (setq old-idx lay-idx)
  (lay_list_act (itoa lay-idx))
  (action_tile "list_lay" "(lay_list_act $value)")
  (action_tile "edit_lay" "(el_lay_edit $value)")
  (action_tile "accept"   "(el_ok)")
  (action_tile "cancel"   "(reset_lay)")
  (if (= (start_dialog) 1)    ; User pressed OK
    (progn
    (setq ecolor (if x el:col el:tco))
    (setlay el:tla)
    (setlay el:lay)
    (command "_.layer" "_C" ecolor layname ""))
    )
)
;;
;; Reset to original layer when cancel is selected.
;;
(defun reset_lay ()
  (setq lay-idx old-idx)
  (done_dialog 0)
)

(defun el_ok ()
  (if x
    (setq el:lay layname)
    (setq el:tla layname)
  )
  (if (lacolor layname)
    (if x
      (setq el:col (lacolor layname))
      (setq el:tco (lacolor layname))
    )
  )
  (done_dialog 1)
)
;;
;; Edit box selections end up here.  Convert layer entry to upper case.  If 
;; layer name is valid, clear error string, call (lay_list_act) function,
;; and change focus to list box.  Else print error message.
;;
(defun el_lay_edit (layvalue)
  (setq layvalue (strcase layvalue))
  (if (setq lay-idx (get_index layvalue laynmlst))
    (progn
      (set_tile "error" "")
      (lay_list_act (itoa lay-idx))
    )
    (progn
      (set_tile "error" "")
      (setq layname layvalue)
    )
  )
)

(if (null el:lay) (setq el:lay "SYMBOL"))
(if (null el:tla) (setq el:tla "SYMBOL"))
(if (null el:col) (setq el:col co_2))
(if (null el:tco) (setq el:tco co_3))
(if (null el:the) (setq el:the 3))
(if (null el:sty)
  (cond
    ((findfile "WHGTXT.SHX")
      (setq el:sty "CIHS"
      )
    )

    (T
      (setq el:sty "SIM")
    )
  )
)

(defun C:CIMELMARK () (m:elm))
(defun C:CIMELM () (m:elm))
(princ)


;=============================================================
; 레벨 마크 그리기                                            
;=============================================================
(defun m:LEMARK (/ cec cet p1 p2 sc hsk tck)
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n레벨 마크를 그리는 명령입니다.")
  
  (setq sc (getvar "dimscale"))
  
  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")
  (initget (+ 2 4))
  (setvar "osmode" 33)
  (setq p1 (getpoint "\n>>>Level Mark의 삽입기준점을 선택하십시오: "))
  (if (null p1) (exit))
;;;  (if (/= (type lem:hs) 'REAL) (setq hs (* sc 3)))
  (initget (+ 2 4))
  (setq hsk (getreal (strcat "\nEnter Text Height <" (rtos lem:hs 2) ">: ")))
  (if (numberp hsk) (setq lem:hs hsk))
  (SETLAY "SYMBOL")
	  (while (/= p1 nil)
		  (if (/= (type tc) 'STR) (setq tc "FL: %%p0"))
		  (setq tck (getstring 2 (strcat "\nEnter Text <" tc ">: ") ))
		  (if (/= tck "") (setq tc tck))
	           
		  (setq p2 (list (+ (car p1) (* sc lem:hs 3)) (+ (cadr p1) (* sc (* lem:hs 0.5)))))
		  
		  (setvar "osmode" 0)
		  (command "_.insert" "LEMARK" p1 (* sc (* lem:hs 0.5)) "" "")
		  
		  (if (= (stysearch "SIM") nil)
		    (styleset "SIM")
		  )
		  (setvar "textstyle" "SIM")
		  (command "_.text" p2 (* sc lem:hs)  "0" tc)
		  (setvar "osmode" 33)
		  (setq p1 (getpoint "\n>>>Level Mark의 삽입기준점을 선택하십시오: "))
	  )
  
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ)
)
(if (null lem:hs) (setq lem:hs 3))
(defun C:CIMLEMARK () (m:lemark))
(defun C:CIMLEM () (m:lemark))
(princ)

  
;===================================================================
; 계단 단면 기호 그리기                                             
;===================================================================
(defun m:STS (/ bm sc p1 p2 p3 p4 p5 p5x p6 p7 p8 p8x d1 d2 a1 a2)
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n계단 단면 기호를 그리는 명령입니다.")
  
  (setq sc (getvar "dimscale"))
  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")
  ;(initget 1)
  (setq p1 (getpoint "\nFirst Point:   "))
  (if (null p1) (exit))
  (setq p2 (getpoint p1 "Second Point: "))
  (if (null p2) (exit))
  (setq d1 (distance p1 p2))
  (setq a1 (angle p1 p2))
  (setq p3 (polar p2 (+ a1 (dtr 90)) (* d1 0.4))
        d2 (distance p1 p3)
        a2 (angle p1 p3)
        p4 (polar p1 a2 (/ d2 2))
        p5 (polar p4 (+ a1 (dtr 180)) 75)
        p7 (polar p4 (+ a1 (dtr 90)) 200)
        p6 (polar p4 (+ a1 (dtr 270)) 200)
        p8 (polar p4 a1 75)
        p5x (inters p1 p3 p6 p5 nil)
        p8x (inters p1 p3 p7 p8 nil)
  )
  (setvar "osmode" 0)
  (command "pline" p1 p5x p6 p7 p8x p3 "")
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ)
)

(defun C:CIMSTS () (m:sts))
(princ)
