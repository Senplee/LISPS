

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 작업 일자 : 2001. 08. 11 
;; 작 업 자  : 김병전 
;; 명 령 어  : C:CIMDLIST - 도면 일람표 
;; 수정 사항 : DD_DLIST() - 함수 안에 있는 변수와 변수 사이의 탭 스페이스 수정 
;; 	       탭이 있는 경우 로딩이 되지 않음 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(setq lfn38 1)
;;;
;; 도면일람표 작성프로그램. 명령어: DLIST

(defun DLG_Dlt (/ e x a_a @win n)
  (setq @win "~")
  (while (= "~" @win)
    (if (= 1 (setq f$$ (getfiled
          "읽어들일 화일을 선택하십시오." (strcat g_searchpath2 "\\") "lst" 4)))
      (progn
        (setq @win (getstring
          (strcat "\n>>>도면일람표 화일이름: ")))
        (if (and (/= @win "~") (/= @win ""))
          (setq cdwg @win)
        )
        (if (/= @win "~") (setq @win cdwg))
      )
      (if (/= f$$ nil) 
      (progn
        (setq @win f$$)
        (setq cdwg (substr f$$ 1 (1- (instr f$$ "."))))
        (princ (strcat "\n\t도면일람표 화일이름: " cdwg))
      )(exit))
    )
  )
)

(defun sud1 (/ cdwg )
  (while (= f$$ nil)
    (dlg_Dlt)
    (setq filename (strcat cdwg ".lst"))
    (if (= (setq filename (findfile filename)) nil)
      (progn
        (alert (strcat filename " 화일을 찾을 수 없습니다."))
        (setq f$$ nil)
      )
    )
  )
  (setq aa (open filename "r"))
)

(defun sudd (/ tmpdist rtnvalue)
  (setq sc (getvar "Dimscale")
	rtnvalue T)
  
  (while rtnvalue
	  (setq pr (fix (/ listcount dls:pc)))
	  (setq lx (/ (- dx (* sc 10 2)) dls:pc))
	  
	  ;(setq ly (/ (- dy (* sc 10) (* sc dls:hgt3 4) (* sc 1) (* sc dls:hgt1 2)) pr))

	  (if (< (- dy (* sc 10) (* sc dls:hgt3 4) (* sc 1) (* sc dls:hgt1 2)) (* sc dls:hgt2 pr 2))
	    (setq rtnvalue (messagebox "표가 영역을 벗어납니다. 단 수를 늘리시겠습니까?"
				(strcat  "현재 단 수:" (itoa dls:pc))))
	    (setq rtnvalue nil
		  pr (fix (/ (- dy (* sc 10)(* sc dls:hgt3 4) (* sc 1) (* sc dls:hgt1 2)) (* sc dls:hgt2 2))))
	  )
    (if rtnvalue (setq dls:pc (1+ dls:pc)))
  )


  
;;;  (if dLs:Autoflag
;;;    (progn 
;;;	 (setq  dls:hgt1 (/ (fix (* ly 0.5)) sc) dls:hgt2 (/ (fix (/ ly 2)) sc))
;;;    (cond ((>= dls:pc 3)  
;;;       (if (> dls:hgt1 8) (setq dls:hgt1 8))
;;;       (if (> dls:hgt2 8) (setq dls:hgt2 8)))
;;;	  ((= dls:pc 2)  
;;;       (if (> dls:hgt1 12) (setq dls:hgt1 12))
;;;       (if (> dls:hgt2 12) (setq dls:hgt2 12)))
;;;	  ((= dls:pc 1)  
;;;       (if (> dls:hgt1 24) (setq dls:hgt1 24))
;;;       (if (> dls:hgt2 24) (setq dls:hgt2 24)))
;;;	)
;;;     (setq dls:hgt3 (* dls:hgt2 1.5))
;;;     ) 
;;;  )
  
;;;  (setq dls:hgt3 (* dls:hgt1 1.5))
  
  (setq pw4 (polar pw4 0 (* sc 10))
        pw4 (polar pw4 (dtr 270) (* sc dls:hgt3 4))
	pt6 (polar pw4 0 (/ (- dx (* sc 10 2)) 2))
	pt6 (polar pt6 (dtr 90) (* sc dls:hgt3))
  )
 
  
  
  (setq pw5 pw4 pw6 pw4)
  (command "_line" pw4 (polar pw4 0 (- dx (* sc 20))) "")
 
  (setq pw4 (polar pw4 (dtr 270) (* sc dls:hgt1 2)))
	 
  (command "_line" pw4 (polar pw4 0 (- dx (* sc 20))) "")
  (setq pw4 (polar pw4 (dtr 270) (* sc 1))
	pw7 pw4)
  (repeat (+ pr 2)
	(command "_line" pw4 (polar pw4 0 (- dx (* sc 20))) "")
  	(setq pw4 (polar pw4 (dtr 270) (* sc dls:hgt2 2)))
  )

  (setq tmpdist (- (distance pw4 pw5) (* sc dls:hgt2 2)))
  (repeat dls:pc
     (command "line" pw5 (polar pw5 (dtr 270) tmpdist) "")  
     (setq pw5 (polar pw5 0 (* lx  0.2)))
     (command "line" pw5 (polar pw5 (dtr 270) tmpdist) "")
     (setq pw5 (polar pw5 0 (* lx 0.6)))
     (command "line" pw5 (polar pw5 (dtr 270) tmpdist) "")
     (setq pw5 (polar pw5 0 (* lx 0.2)))
   )
  (command "line" pw5 (polar pw5 (dtr 270) tmpdist) "")
  
   
  ;(setvar "textstyle" dls:sty)
  (setq text_1 "도면 번호"
        text_2 "도  면  명"
        text_3 "축 척"
        text_4 "도  면  목  록  표"
  )

  (if (not (stysearch dls:sty1))
    (styleset dls:sty1)
  )
  (setvar "textstyle" dls:sty1)
  (setq pw6 (polar pw6 (dtr 270) (* sc dls:hgt1)) )
  (setq pw6 (polar pw6 0 (* lx  0.1)) )
  (repeat dls:pc
     (command "_text" "_MC" pw6 (* dls:hgt1 sc) 0 text_1)  
     (setq pw6 (polar pw6 0 (* lx  0.4)))
     (command "_text" "_MC" pw6 (* dls:hgt1 sc) 0 text_2)
     (setq pw6 (polar pw6 0 (* lx 0.4)))
     (command "_text" "_MC" pw6 (* dls:hgt1 sc) 0 text_3)
     (setq pw6 (polar pw6 0 (* lx 0.2)))
  )

 
  (command "_.color" 1)
  (if (not (stysearch dls:sty3))
    (styleset dls:sty3)
  )
  (setvar "textstyle" dls:sty3)
  (command "_.text" "_C" pt6 (* dls:hgt3 sc) 0 text_4)
  (setq p_list (textbox (entget (entlast))))
  (setq p_leng (- (car (nth 1 p_list)) (car (nth 0 p_list))))
  (setq p_leng (+ p_leng (* sc 10)))
  (setq pt6x (polar pt6 (dtr 180) (/ p_leng 2))
        pt61 (polar pt6x (dtr 270) (* sc 1.5))
        pt62 (polar pt6x (dtr 270) (* sc 2))
  )
  (command "_.line" pt61 (polar pt61 0 p_leng) "")
  (command "_.line" pt62 (polar pt62 0 p_leng) "")


  (if (not (stysearch dls:sty2))
    (styleset dls:sty2)
  )
  (command "_.color" "BYLAYER")
  (setvar "textstyle" dls:sty2)
  (setq pw7 (polar pw7 0 (* lx  0.1))
	pw7 (polar pw7 (dtr 270) (* sc dls:hgt1))
	pw8 pw7)

  
  (setq nnn 0)
  (repeat dls:pc
    
    (repeat (1+ pr)
      (if (> listcount nnn)
	(progn
	(if (/= (nth 0 (nth nnn dlt:data)) nil)	
  		(command "_text" "_MC" pw8 (* dls:hgt2 sc) 0 (nth 0 (nth nnn dlt:data)))
	  )
      	(setq pw8 (polar pw8 0 (* lx  0.4)))
    	(if (/= (nth 2 (nth nnn dlt:data)) nil)
     		(command "_text" "_MC" pw8 (* dls:hgt2 sc) 0 (nth 2 (nth nnn dlt:data)))
	  )
     	(setq pw8 (polar pw8 0 (* lx 0.4)))
    	(if (/= (nth 4 (nth nnn dlt:data)) nil)
		(command "_text" "_MC" pw8 (* dls:hgt2 sc) 0 (nth 4 (nth nnn dlt:data)))
	  )
     	(setq pw8 (polar pw8 0 (* lx 0.2)))
      	(setq pw8 (polar (list (car pw7) (cadr pw8)) (dtr 270) (* sc dls:hgt2 2)))
        (setq nnn (1+ nnn))
	)
      )
    )
  (setq pw7 (polar pw7 0 lx) pw8 pw7)
  ) 
)

(defun m:DLIST (/
               cec      sc       pw1      pw2      pw3      pw4      pw5
               pw6      pw7      pw8      pt6x     pt61     pt62
               pt3      pt4      pt6      
               dx       dy       aa       bb            
               pr       
                            lx       ly         
               filename
               p_list   p_leng      
               text_1   text_2   text_3   text_4   chech_table
               listcount nnn step1 step2 f$$) ;dlt:DAta)

  (setq cec (getvar "CECOLOR"))

  ;;
  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n도면 일람표를 작성하는 명령입니다.")
  
;;;  (cond
;;;
;;;    ((findfile "WHGTXT.SHX")
;;;      (setq text_d "CIHD"
;;;            text_s "CIHS"
;;;      )
;;;    )
;;;    (T
;;;      (alert "한글 글꼴을 찾을 수 없습니다.")
;;;      ;(exit)
;;;    )
;;;  )
  (setlay dls:lay)
  (setvar "blipmode" 1)
  (setvar "osmode" 33)
  
  (setq Step1 T Step2 T)
  (while Step1
    	  (initget "Dialog ")
	  (setq pw1 (getpoint "\n>>> Dialog/<좌측 하단>: "))
	  (cond ((= pw1 "Dialog") (dd_dlist))
    	  	(T (setq step1 nil))
		)
  )
  
  (if (null pw1 ) (exit))
    
	(while Step2
	   (initget "Dialog ")
	   (setq pw2 (getcorner pw1
	              "\n>>> Dialog/<우측 상단>: "))
	   
	  	(cond ((= pw2 "Dialog") (dd_dlist))
		    (T (setq step2 nil))
		 )
	 )
  (if (null pw2 ) (exit))
	  (setvar "osmode" 0)
	  (setvar "blipmode" 0)
	  (setvar "cmdecho" 0)
	  (setq pw3 (list (car pw2) (cadr pw1)))
	  (setq pw4 (list (car pw1) (cadr pw2)))
	  (setq dx (distance pw1 pw3)
	        dy (distance pw3 pw2)
	  )
	 (if (null f$$) (sud1))
	  
	  (setq listcount 0)
	  
	  (setq bb (read-line aa) dlt:DAta nil)
	  (while (and (/= bb "") (/= bb nil))
	    (setq dlt:DAta (cons (split bb "\\") dlt:DAta))
	    (setq bb (read-line aa))
	  )
	  
	  (close aa)
	  (setq dlt:DAta (reverse dlt:DAta) listcount (length dlt:DAta))
	  (sudd)
 
  
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
 
  (princ)
)

;---------------------------------------------------------------------------------
(defun dlist_init ()

;;;  (defun dlist_set (/ chnaged?)
;;;   (p
;;;  )

  ;; Common properties for all entities

  
  (defun set_tile_props ()
    (set_tile "error" "")
   
    (set_tile "ed_textsize1" (rtos dls:hgt1))
    (set_tile "ed_textsize2" (rtos dls:hgt2))
    (set_tile "ed_textsize3" (rtos dls:hgt3))
 
    (pop_set "pop_textstyle1")
    (pop_set "pop_textstyle2")
    (pop_set "pop_textstyle3")

    ;(set_tile (strcat "rd_" (itoa dls:pc)) "1")
    (set_tile "ed_field_size" (itoa dls:pc))
    (set_tile "pop_textstyle1" (itoa (get_index dls:sty1 stnmlst)))
    (set_tile "pop_textstyle2" (itoa (get_index dls:sty2 stnmlst)))
    (set_tile "pop_textstyle3" (itoa (get_index dls:sty3 stnmlst)))    
    (get_style "pop_textstyle1")

    ;(set_tile "tg_text_auto" (if dls:autoflag "1" "0"))    
    ;(text_auto_set)
  )

  (defun set_action_tiles ()
    ;(action_tile "tg_text_auto" "(setq dls:autoflag (if (= (get_tile \"tg_text_auto\") \"1\")
    ; T nil)) (text_auto_set)")
    (action_tile "pop_textstyle1" "(get_style \"pop_textstyle1\")")
    (action_tile "pop_textstyle2" "(get_style \"pop_textstyle2\")")
    (action_tile "pop_textstyle3" "(get_style \"pop_textstyle3\")")
    
    (action_tile "ed_textsize1"  "(getfsize $value \"ed_textsize1\")")
    (action_tile "ed_textsize2"  "(getfsize $value \"ed_textsize2\")")
    (action_tile "ed_textsize3"  "(getfsize $value \"ed_textsize3\")")

;;;    (action_tile "rd_1"  "(dlist_radio_set)")
;;;    (action_tile "rd_2"  "(dlist_radio_set)")
;;;    (action_tile "rd_3"  "(dlist_radio_set)")
	(action_tile "ed_field_size" "(getfsize $value \"ed_field_size\")")
    
    (action_tile "bn_file_open"  "(sud1)(set_tile \"ed_file_name\" f$$)")
    (action_tile "ed_file_name"  "(check_filename_exist)")
    
    (action_tile "accept"       "(dismiss_dialog 1)")
    (action_tile "cancel"       "(dismiss_dialog 0)")
  )
 
;;;  (defun dlist_radio_set (/ tmpidx )
;;;    (setq tmpidx (get_tile "tbl_radio"))
;;;    (setq dls:pc (atoi (substr tmpidx 4 1)))
;;;    
;;;  )
  
;;;  (defun text_auto_set ()
;;;    
;;;    (if (= (get_tile "tg_text_auto") "1")
;;;      (progn
;;;	(mode_tile "ed_textsize1" 1)
;;;	(mode_tile "ed_textsize2" 1)
;;;	(mode_tile "ed_textsize3" 1)
;;;	)
;;;      (progn
;;;	(mode_tile "ed_textsize1" 0)
;;;	(mode_tile "ed_textsize2" 0)
;;;	(mode_tile "ed_textsize3" 0)
;;;	)
;;;      )					    
;;;  )
  
  (defun getfsize (value tiles)
    (cond 
	  ((= tiles "ed_textsize1")
	   (setq dls:hgt1 (verify_d tiles value dls:hgt1)))
	  ((= tiles "ed_textsize2")
	   (setq dls:hgt2 (verify_d tiles value dls:hgt2)))
	  ((= tiles "ed_textsize3")
	   (setq dls:hgt3 (verify_d tiles value dls:hgt3)))
	  ((= tiles "ed_field_size")
	   (setq dls:pc (verify_d tiles value dls:pc)))

    )
    )
  
  (defun verify_d (tile value old-value / coord valid errmsg ci_coord)
    (setq valid nil errmsg "Invalid input value.")
    (if (setq coord (distof value))
      (progn
	(cond
          ((= tile "ed_field_size")
            (setq ci_coord (fix coord))
            (if (>= ci_coord 1)
              (if (= (- ci_coord coord) 0)
                (setq valid T)
                (setq errmsg "Value must be positive integer.")
              )
              (setq errmsg "Value must be positive integer more than 1.")
            )
          )
	  (T
	    (if (> coord 0)
              (setq valid T)
              (setq errmsg "Value must be positive or non zero.")
            )
	   )
	  )
	)
          (setq valid nil)
    )
    (if valid
      (progn 
       (if (= tile last-tile)
          (set_tile "error" "")
        )
        (set_tile tile (if (= tile "ed_field_size")  (itoa ci_coord) (rtos coord)))
        (setq last-tile tile)
        (if (= tile "ed_field_size") 
          ci_coord
          coord
        )
       
      )
      (progn
        (mode_tile tile 2)
        (set_tile "error" errmsg)
        (setq last-tile tile)
        old-value
      )
    )
  )
  
  (defun dismiss_dialog (action)
    (if (= action 0)
      (done_dialog 0)
      (if (= (get_tile "error") "")
;;;	(progn
;;;	(setq dlist:text (get_tile "ed_text"))
;;;	(setq dlist:sch (get_tile "ed_dwgtype"))
;;;	(setq dlist:snum (atoi (get_tile "ed_dwgno")))
        (done_dialog action))
;;;      )
    )
  )

 (defun get_style (tmp_tile_name / idx rd_idx tmpstyle)
  (setq idx (atoi (get_tile tmp_tile_name)))   
  (ci_image "text_image" (nth idx slblist))
  (setq tmpstyle (nth idx stnmlst))  
  (cond ((= tmp_tile_name "pop_textstyle1")
	 (setq dls:sty1 tmpstyle))
	((= tmp_tile_name "pop_textstyle2")
	 (setq dls:sty2 tmpstyle))
	((= tmp_tile_name "pop_textstyle3")
	 (setq dls:sty3 tmpstyle))
  )
 )
  
) ; end wn2_init
(defun dlist_do ()
  (if (not (new_dialog "dd_dlist" dcl_id)) (exit))
  (set_tile_props)
  (set_action_tiles)
  (setq dialog-state (start_dialog))
  (if (= dialog-state 0)
   (setq reset_flag t)
  )
)

(defun dlist_return ()
  
  (setq dls:hgt1 old_hgt1  
        dls:hgt2 old_hgt2  
        dls:hgt3 old_hgt3  
        dls:sty1 old_sty1  
	dls:sty2 old_sty2  
	dls:sty3 old_sty3  
        dLs:Autoflag old_autoflag 
        dls:pc old_pc	
  )
  
)

(defun dd_dlist ( / old_hgt1 old_hgt2 old_hgt3 old_sty1 old_sty2 old_sty3
		    old_autoflag old_pc reset_flag dismiss_dialog
		    get_style verify_d getfsize set_action_tiles set_tile_props )

  (setq old_hgt1 dls:hgt1 old_hgt2 dls:hgt2 old_hgt3 dls:hgt3
	old_sty1 dls:sty1 old_sty2 dls:sty2 old_sty3 dls:sty3
        old_autoflag dLs:Autoflag old_pc dls:pc)

  (cond
     ((not (setq dcl_id (Load_dialog "DList.dcl")) ))   ; is .DLG file loaded?

     (t
      ;(ai_undo_push)
      ;(princ ".")
      ;(dlist_Draw_Image_X)
      ;(readf "Dwgtitle.dat" T)
      (dlist_init)                              ; everything okay, proceed.
      (princ ".")
      (dlist_do)
     )  
  )  ;;  cond
  
  (if reset_flag
    (dlist_return)
    ;(dlist_set)
  )
  
)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(if (null dls:lay) (setq dls:lay "TABLE"))
(if (null dls:hgt1) (setq dls:hgt1 4))
(if (null dls:hgt2) (setq dls:hgt2 4))
(if (null dls:hgt3) (setq dls:hgt3 7))
(if (null dLs:Autoflag) (setq dLs:Autoflag T))
(if (null dls:sty3) (setq dls:sty3 "CIHD"))
(if (null dls:sty2) (setq dls:sty2 "CIHS"))
(if (null dls:sty1) (setq dls:sty1 "CIHD"))
(if (null dls:pc) (setq dls:pc 3))

(defun C:cimDLIST () (m:dlist))
(princ)

