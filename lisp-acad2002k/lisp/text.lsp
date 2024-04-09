;수정날짜 :2001.8.10 
;작업자 :김병용
;명령어 :c:cimctx 문자열 바꾸기.
;        C:cimtjus c:cimtj text삽입기준점 바기
;	 c:cimtsize c:cimtz 글자크기 바기
;	 c:cimtsty c:cimts 스타일 바기
;	 c:cimtwid c:cimtw 장평 바기
;	 c:cimchtxt c:cimchx 문단 바꾸기
;	 c:cimcht 글자 높이 위치 삽입기준 장평 스타일 텍스트 바꾸기
;	 c:cimchs 글자 내용 바꾸기


;수정사항 : Mtext도 수정 가능하게. (삽입기준점 / 장평 제외)
;단축키 관련 변수 정의 부분..end



(defun CHGTEXT (/ ct_ost p l n e os as ns st s nsl osl sl si chf chm t_type)
 
  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")

 (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
 (princ "\n문장의 일부를 새로운 문장으로 변경하는 명령입니다.")
  (setq chm 0)
  (princ "\n바꿀 문자열을 선택하십시오. ")
  (setq p (ssget))                  ; Select objects
  (if p
    (progn                          ; If any objects selected
      (setq t_type (substr (cdr (assoc 7 (entget (ssname p 0)))) 1 2))
      (setvar "textstyle" (cdr (assoc 7 (entget (ssname p 0)))))
      (setq os  (getstring t "\nMatch string: ")
            osl (strlen os)
      )
      (if (> osl 0)
        (progn
          (setq ns  (getstring t "  New string: ")
                nsl (strlen ns)
          )
          (setq l 0 n (sslength p))
          (while (< l n)                 ; For each selected object...
            (if (or (= "TEXT"                ; Look for TEXT entity type (group 0)
              (cdr (assoc 0 (setq e (entget (ssname p l))))))
	      (= "MTEXT"                ; Look for TEXT entity type (group 0)
              (cdr (assoc 0 (setq e (entget (ssname p l))))))
		    )
              (progn
                (setq chf nil si 1)
                (setq s (cdr (setq as (assoc 1 e))))
                (while (= osl (setq sl (strlen
                             (setq st (substr s si osl)))))
                  (if (= st os)
                    (progn
                      (setq s (strcat (substr s 1 (1- si)) ns
                                      (substr s (+ si osl))))
                      (setq chf t) ; Found old string
                      (setq si (+ si nsl))
                    )
                    (setq si (1+ si))
                  )
                )
                (if chf
                  (progn        ; Substitute new string for old
                    (setq e (subst (cons 1 s) as e))
                    (entmod e)         ; Modify the TEXT entity
                    (setq chm (1+ chm))
                  )
                )
              )
            )
            (setq l (1+ l))
          )
        )
      )
    )
  )
  
  (if (> chm 1)
    (princ (strcat (itoa chm) "개의 문장이 바뀌었습니다."))
  )
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ)
)

(defun C:CIMCTX () (chgtext))
(princ)

;====================================================================
; Change Existing Text Style
; Created 1991. 1. 18.

(defun m:TJUS (/ p11 p10 p11n p10n ss pe m s n hg e t2)
 (ai_err_on)
 (ai_undo_on)
 (command "_.undo" "_group")
  
 (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
 (princ "\n문장의 삽입기준점을 변경하는 명령입니다.")
  (while (= ss nil)
    (setq ss (ssget '((0 . "TEXT"))))
  )

  
  (if ss 
    (progn
      (setq m 0 s 0 n (sslength ss))
      (while (< m n)
        (setq e (entget (ssname ss m)))
        (setq pe (entget (ssname ss m))
              pe (cdr (assoc 72 pe))
              m n
        )
      )
      (setq m 0)
      (cond
        ((= pe 0) (setq pe "L"))
        ((= pe 1) (setq pe "C"))
        ((= pe 4) (setq pe "M"))
        ((= pe 2) (setq pe "R"))
      )
      (initget 1 "L C M R  ")
      (setq hg (getkword (strcat
        "\n<L>eft, <C>enter, <M>iddle, <R>ight Justification<" pe ">: ")))
      (cond
        ((= hg "")  (setq hg pe))
        ((= hg "L") (setq hg 0))
        ((= hg "C") (setq hg 1))
        ((= hg "M") (setq hg 4))
        ((= hg "R") (setq hg 2))
      )
      (while (< m n)
        (setq e (entget (ssname ss m)))
        (setq t2  (assoc 72 e)
              p11 (assoc 11 e)
              p10 (assoc 10 e)
        )
        (if (= (cdr t2) 0) (setq p11n (cons 11 (cdr p10))))
        (if (= (cdr t2) 0) (setq e (subst p11n p11 e)))
        (if (/= (cdr t2) 0)
          (setq p10n (cons 10 (cdr p11))
                e    (subst p10n p10 e)
          )
        )
        (setq e (subst (cons 72 hg) t2 e))
        (entmod e)
        (setq s (1+ s))
        (setq m (1+ m))
      )
    )
  )
  (if ss
    (princ (strcat "\n" (itoa s) "개의 문자(열)이 바뀌었습니다. "))
  )
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ)
)

(defun C:CIMTJUS () (m:tjus))
(defun C:CIMTJ () (m:tjus))

(princ)

;====================================================================
; Change Existing Text Size
; Revision 1991. 1. 18.

(defun m:TSIZE (/ ss pe m s n hg e t2 Noeq Prepe)

 (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")
 (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
 (princ "\n문자크기를 바꾸는 명령입니다.")
 
  (while (not ss)
    (setq ss (ssget '((0 . "*TEXT"))))
  )
  (if ss 
    (progn
      (setq m 0 s 0 n (sslength ss))
      (while (< m n)
        (setq e (entget (ssname ss m)))
        (setq pe (entget (ssname ss m))
              pe (cdr (assoc 40 pe))
            ;;  m n
        )
	(if (= Prepe nil) (setq Prepe pe))
	(if (/= Prepe pe) (setq Noeq T))
	(setq Prepe pe)
	(setq m (1+ m))
      )
      
      (setq m 0)
      (setq hg (getdist (strcat
        "\nEnter new text height<" (if Noeq "???" (rtos pe)) ">: ")))
      (if (= hg nil) (setq hg pe))
      (while (< m n)
        (setq e (entget (ssname ss m)))
        (setq t2 (assoc 40 e))
        (princ "\nExisting Text Height: ")
        (princ (cdr (assoc 40 e)))
        (setq e (subst (cons 40 hg) t2 e))
        (entmod e)
        (princ "  New Text Height: ")
        (princ hg)
        (setq s (1+ s))
        (setq m (1+ m))
      )
    )
  )
  (if ss
    (princ (strcat "\n" (itoa s) "개의 문자(열)이 바뀌었습니다. "))
  )
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ)
)

(defun C:CIMTSIZE () (m:tsize))
(defun C:CIMTZ () (m:tsize))

(princ)

;====================================================================
; Change Existing Text Style
; Created 1991. 1. 18.

(defun m:TSTY (/ ss pe m s n hg e t2 t3)
 (ai_err_on)
 (ai_undo_on)
 (command "_.undo" "_group")
  
 (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
 (princ "\n문자 스타일을 변경하는 명령입니다.")
  (while (= ss nil)
    (setq ss (ssget '((0 . "*TEXT"))))
  )
  (if ss 
    (progn
      (setq m 0 s 0 n (sslength ss))
      (while (< m n)
        (setq e  (entget (ssname ss m)))
        (setq pe (entget (ssname ss m))
              pe (cdr (assoc 7 pe))
              m  n
        )
      )
      (setq m 0)
      (setq hg (strcase (getstring (strcat
        "\nEnter New Text Style <Dialog/" pe ">: "))))
      (if (or (= hg "D") (= hg "DIALOG"))
        (progn
          (menucmd "i=al_style")
          (menucmd "i=*")
          (setq hg (getstring "\nNew Text Style: "))
        )
      )
      (if (= hg "") (setq hg pe))
      (if (= (stysearch hg) nil)
        (styleset hg)
      )
      (setq nestyle_wid (assoc 41 (tblsearch "style" hg))) 
      (while (< m n)
        (setq e (entget (ssname ss m)))
        (setq t2 (assoc 7 e))
	(setq t3 (assoc 41 e))
        (princ "\nExisting Text Style: ")
        (princ (cdr (assoc 7 e)))
        (setq e (subst (cons 7 hg) t2 e))
	(setq e (subst nestyle_wid t3 e))
        (entmod e)
        (princ "  New Text Style: ")
        (princ hg)
        (setq s (1+ s))
        (setq m (1+ m))
      )
    )
  )
  (if ss
    (princ (strcat "\n" (itoa s) "개의 문자(열)이 바뀌었습니다. "))
  )

  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ)
)

(defun C:CIMTSTY () (m:tsty))
(defun C:CIMTS () (m:tsty))

(princ)

;====================================================================
; Change Existing Text Size
; Created 1991. 3. 29.

(defun m:TWID (/ ss pe m s n hg e t2)
 (ai_err_on)
 (ai_undo_on)
 (command "_.undo" "_group")
 (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
 (princ "\n문자 장평을 변경하는 명령입니다.")
  (while (= ss nil)
    (setq ss (ssget '((0 . "TEXT"))))
  )
  (if ss 
    (progn
      (setq m 0 s 0 n (sslength ss))
      (while (< m n)
        (setq e  (entget (ssname ss m)))
        (setq pe (entget (ssname ss m))
              pe (cdr (assoc 41 pe))
              m  n
        )
      )
      (setq m 0)
      (setq hg (getdist (strcat
        "\nEnter new text width ratio<" (rtos pe) ">: ")))
      (if (= hg nil) (setq hg pe))
      (while (< m n)
        (setq e (entget (ssname ss m)))
        (setq t2 (assoc 41 e))
        (princ "\nExisting Text Width Ratio: ")
        (princ (cdr (assoc 41 e)))
        (setq e (subst (cons 41 hg) t2 e))
        (entmod e)
        (princ "  New Text Width Ratio: ")
        (princ hg)
        (setq s (1+ s))
        (setq m (1+ m))
      )
    )
  )
  (if ss
    (princ (strcat "\n" (itoa s) "개의 문자(열)이 바뀌었습니다. "))
  )
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ)
)

(defun C:CIMTWID () (m:twid))
(defun C:CIMTW () (m:twid))

(princ)

;=================================================================================================
;=================================================================================================

(defun m:CHTXT (/ A B C D E t_type )
	(ai_err_on)
  
  	(ai_undo_on)
  	(command "_.undo" "_group")

 	(princ "\nArchiFree 2002 for AutoCAD LT 2002.")
 (princ "\n문장을 변경하는 명령입니다.")
  (prompt "\n바꿀 문단을 선택하십시오. ")
  (setq A (ssget))
  (if (null A) (exit))
  (setq B (sslength A))
  (setq C 0)
  (while (<= 1 B)
    (setq D (ssname A C))
    (if (or (eq (cdr (assoc 0 (entget D))) "TEXT") (eq (cdr (assoc 0 (entget D))) "MTEXT"))
      (progn
        (redraw D 3)
        (setvar "textstyle" (cdr (assoc 7 (entget D))))
        (princ "Old text: ")
        (princ (cdr (assoc 1 (entget d))))
        (setq t_type (substr (cdr (assoc 7 (entget D))) 1 2))
        (setq E (getstring T "\tNew text: "))
        (if (= E "")
          (setq E (cdr (assoc 1 (entget D))))
        )
        (entmod (subst (cons 1 E) (assoc 1 (entget D)) (entget D)))
        (redraw D 4)
      )
    )
    (setq B (- B 1))
    (setq C (+ C 1))
  )
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ )
)

(defun C:CIMCHTXT () (m:chtxt))
(defun C:CIMCHX () (m:chtxt))
(princ)

;==============================================================
;                   CIMCHT                                     
;==============================================================
(defun m:chtconfig(/ ent org_text)
  
	(ai_err_on)
  	(ai_undo_on)

  	(princ "\nArchiFree 2002 for AutoCAD LT 2002.")
 	(princ "\n글자의 속성을 변경하는 명령입니다.")
  	(setq stnmlst nil)
    (setq cont T ent nil)
    (while cont 
    	(setq ent (entsel "\n문자를 선택하십시오: "))
	    
	    (if (null ent)
		    (setq cont nil)
		    (progn
	    		(setq entl (entget (car ent)))
	    		(if (= (cdr (assoc 0 entl)) "TEXT")
			    (progn
			      	(setq org_lay (cdr (assoc 8 entl)))
			      	(setq org_col (cdr (assoc 62 entl)))
		  		(cht_m1)
			      	(setq org_text (entlast))
			      	(if (= org_col nil)
			      	    (command "CHANGE" org_text "" "P" "LA" org_lay "")
				    (command "CHANGE" org_text "" "P" "LA" org_lay "C" org_col "")
				)
			    )  
		    	    (alert "문자가 아닙니다.")
			)
		    )
 	    )  
    )

    (ai_err_off)
    (ai_undo_off)
    (princ)
)
(defun cht_m1() 
    (setq old_con  (cdr (assoc 1  entl))
	      old_hei  (cdr (assoc 40 entl))
		  old_jush (cdr (assoc 72 entl))
		  old_jusv (cdr (assoc 73 entl))
		  old_rot  (* (/ (cdr (assoc 50 entl)) pi) 180)
		  old_sty  (cdr (assoc 7  entl))
		  old_wid  (cdr (assoc 41 entl))
		  old_str  (cdr (assoc 10 entl))
	)
    (setq old_jus (justifi old_jush old_jusv))
    (cht_dd)
)
(defun justifi(hori vert)
  	(cond
	  	((and (= hori 0) (= vert 0)) (setq return "Left"    j_index 0))
		((and (= hori 1) (= vert 0)) (setq return "Center"  j_index 1))
		((and (= hori 2) (= vert 0)) (setq return "Right"   j_index 2))
		((and (= hori 3) (= vert 0)) (setq return "Aligned" j_index 3))
		((and (= hori 5) (= vert 0)) (setq return "Fit"     j_index 4))
		((and (= hori 0) (= vert 3)) (setq return "TLeft"   j_index 5))
		((and (= hori 1) (= vert 3)) (setq return "TCenter" j_index 6))
		((and (= hori 2) (= vert 3)) (setq return "TRight"  j_index 7))
		((and (= hori 0) (= vert 2)) (setq return "MLeft"   j_index 8))
		((and (= hori 4) (= vert 0)) (setq return "Middle"  j_index 9))
		((and (= hori 1) (= vert 2)) (setq return "MCenter" j_index 10))
		((and (= hori 2) (= vert 2)) (setq return "MRight"  j_index 11))
		((and (= hori 0) (= vert 1)) (setq return "BLeft"   j_index 12))
		((and (= hori 1) (= vert 1)) (setq return "BCenter" j_index 13))
		((and (= hori 2) (= vert 1)) (setq return "BRight"  j_index 14))
		(T (setq return "Left" j_index 0) )
	)
    (setq return return)
)
  
(defun cht_dd(/ dcl_id cnt tmplst stn sortlst)
    
    (setq ok_check nil)
  	(setq dcl_id (ai_dcl "cht"))
	(if (not (new_dialog "dd_cht" dcl_id)) (exit))
  
    (setq just_list (list "Left" "Center" "Right" "Aligned" "Fit" "TLeft" "TCenter" "TRight"
			        	  "MLeft" "Middle" "MCenter" "MRight" "BLeft" "BCenter" "BRight"
		            )
	)	  
    (start_list "pop_newj")
    (setq cnt 0)
    (repeat 15
    	(add_list (nth cnt just_list))
	    (setq cnt (+ cnt 1))
	)
    (end_list)
    
    (set_tile "ed_content" old_con)
  	(set_tile "ed_oldh" (itoa (fix (+ old_hei 0.5))))
    (set_tile "ed_newh" (itoa (fix (+ old_hei 0.5))))
    (set_tile "ed_oldj" old_jus)
    (set_tile "pop_newj" (itoa j_index))
    (set_tile "ed_oldr" (itoa (fix (+ old_rot 0.5))))
    (set_tile "ed_newr" (itoa (fix (+ old_rot 0.5))))
    (set_tile "ed_olds" old_sty)
    (pop_set "pop_news")
    (setq tmplst (tblnext "STYLE" T))
    (while tmplst
	  	(setq stn (cdr (assoc 2 tmplst)))
	    (cond ((= stn "CIHSC")  )((= stn "CIHS")  )((= stn "CIHSW")  )
			  ((= stn "CIHDC")  )((= stn "CIHD")  )((= stn "CIHDW")  )
			  ((= stn "CIHTC")  )((= stn "CIHT")  )((= stn "CIHTW")  )
			  ((= stn "CIHMC")  )((= stn "CIHM")  )((= stn "CIHMW")  )
			  ((= stn "CITBC")  )((= stn "CITB")  )((= stn "CITBW")  )
              ((= stn "CITGC")  )((= stn "CITG")  )((= stn "CITGW")  )
			  ((= stn "CITDC")  )((= stn "CITD")  )((= stn "CITDW")  )
			  ((= stn "CITLC")  )((= stn "CITL")  )((= stn "CITLW")  )
			  (T (setq stnmlst (append stnmlst (list stn))))
		)	  
	    (setq tmplst (tblnext "STYLE"))
    )
    (start_list "pop_news")
    (setq cnt 0)
    (repeat (length stnmlst)
	  	(add_list (nth cnt stnmlst))
	    (setq cnt (+ cnt 1))
	)  
    (end_list)
    (set_tile "pop_news" (itoa (get_index old_sty stnmlst)))
    (set_tile "ed_oldw" (rtos old_wid))
    (set_tile "ed_neww" (rtos old_wid))
    (mode_tile "ed_oldh" 1)
    (mode_tile "ed_oldj" 1)
    (mode_tile "ed_oldr" 1)
    (mode_tile "ed_olds" 1)
    (mode_tile "ed_oldw" 1)
    (action_tile "accept" "(cht_ok)")
    (start_dialog)
    (done_dialog)

  	(if (= ok_check T)
	  	(cht_ex)
	)
    (setq stnmlst nil)
)
(defun cht_ok()
	(setq new_con (get_tile "ed_content")
    	  new_hei (atoi (get_tile "ed_newh"))
		  new_jus (nth (atoi (get_tile "pop_newj")) just_list)
		  new_rot (* (/ (atoi (get_tile "ed_newr")) 180.0) pi)
		  new_sty (nth (atoi (get_tile "pop_news")) stnmlst)
		  new_wid (atof (get_tile "ed_neww"))
		  ok_check T
	)
    (done_dialog)
)
(defun cht_ex(/ pt1 pt2)		 
    (if (not (stysearch new_sty)) ; textstyle 지정
	  	(styleset new_sty)
	)
  
    (cond ((= new_jus "Aligned")
		   (if (= old_jus new_jus)
               (progn
			 		(setq entl (subst (cons 1  new_con) (assoc  1 entl) entl)
		  				  entl (subst (cons 40 new_hei) (assoc 40 entl) entl)
		  			      entl (subst (cons 50 new_rot) (assoc 50 entl) entl)
		  			 	  entl (subst (cons	7  new_sty) (assoc 7  entl) entl)
		  			      entl (subst (cons 41 new_wid) (assoc 41 entl) entl)
	                )
				    (entmod entl)
			   )	  
			   (progn
				    (setvar "osmode" 7)
				    (setq pt1 (getpoint old_str "\n문자 기준선의 첫번재 끝점을 지정: "))
				    (if (null pt1) (setq pt1 old_str))
				    (princ pt1)
				    (initget 1)
			  		(setq pt2 (getpoint pt1 "\n문자 기준선의 두번째 끝점을 지정: "))
				    (princ pt2)
				    (entdel (car ent))
			   	 	(command "_.TEXT" "_S" new_sty "_J" "_A" pt1 pt2 new_con)
			   )	  
		   )
		  )
		  ((= new_jus "Fit")
		   (if (= old_jus new_jus)
			   (progn
			   		(setq entl (subst (cons 1  new_con) (assoc  1 entl) entl)
		  			      entl (subst (cons 40 new_hei) (assoc 40 entl) entl)
		  			 	  entl (subst (cons 50 new_rot) (assoc 50 entl) entl)
		  			 	  entl (subst (cons	7  new_sty) (assoc 7  entl) entl)
		  			 	  entl (subst (cons 41 new_wid) (assoc 41 entl) entl)
	                )
				    (entmod entl)
			   )	 		
			   (progn
				    (setvar "osmode" 7)
				    (setq pt1 (getpoint old_str "\n문자 기준선의 첫번재 끝점을 지정: "))
				    (if (null pt1) (setq pt1 old_str))
				    (princ pt1)
				    (initget 1)
			  		(setq pt2 (getpoint pt1 "\n문자 기준선의 두번째 끝점을 지정: "))
				    (princ pt2)
				    (entdel (car ent))
			   	 	(command "_.TEXT" "_S" new_sty "_J" "_F" pt1 pt2 new_hei new_con)
			   )	  
		   )
		  )
		  (T
		   (if (= new_jus "Left")
			   (progn
				   (entdel (car ent))
			   	   (command "_.TEXT" "_S" new_sty old_str new_hei new_rot new_con)
			   )	 
			   (if (/= new_jus old_jus)
				   (progn
					   (entdel (car ent))
		       	   	   (command "_.TEXT" "_S" new_sty "_J" new_jus old_str new_hei new_rot new_con)
				   )	 
				   (progn
					   (setq entl (subst (cons 1  new_con) (assoc  1 entl) entl)
							 entl (subst (cons 40 new_hei) (assoc 40 entl) entl)
							 entl (subst (cons 50 new_rot) (assoc 50 entl) entl)
							 entl (subst (cons 7  new_sty) (assoc 7  entl) entl)
							 entl (subst (cons 41 new_wid) (assoc 41 entl) entl)
					   )
					   (entmod entl)
				   )
			   )	 
		   )    
		  ) 
	)
)  	
(defun c:cimcht() (m:chtconfig))

;==============================================================
;                   CIMCHS                                     
;==============================================================
(defun C:CIMCHS (/ ss ent m n text e t2 cnt)
  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n객체를 선택하여 문자를 변경하는 명령입니다.")
 
  (princ "\n>>>변경할 문자를 선택하십시오.")
  (setq ss (ssget '((0 . "*TEXT"))))
 
  (if ss 
    (progn
      (setvar "ERRNO" 7)
      (while (and (not ent) (= 7 (getvar "ERRNO")))
        (setq ent (entsel "\n문자를 선택하세요:"))
      )
      (if ent
	(progn
	  (setq e    (entget (car ent)))
	  (setq text (cdr (assoc 1 e)))
	  (setq m 0 cnt 0 n (sslength ss))
	    (while (< m n)
       	      (setq e (entget (ssname ss m)))
              (setq t2 (assoc 1 e))
              (setq e (subst (cons 1 text) t2 e))
              (entmod e)
              (setq m   (1+ m))
	      (setq cnt (1+ cnt))
            )
	    (princ (strcat "\n" (itoa cnt) "개의 문자(열)이 바뀌었습니다. "))
	  )
	)
      )
    )
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ)
)


  
(setq lfn05 1)
(princ)
