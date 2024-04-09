

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 작업 일자 : 2001. 08. 11 
;; 작 업 자  : 김병전 
;; 명 령 어  : C:CIMFLIST - 도면 일람표 
;; 수정 사항 : DD_FLIST() - 함수 안에 있는 변수와 변수 사이의 탭 스페이스 수정 
;; 	       탭이 있는 경우 로딩이 되지 않음 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(setq lfn39 1)


;; 도면일람표 작성프로그램. 명령어: fLIST


(defun fin_Dlt (/ e x a_a @win n column_div)
  (setq @win "~")
  (while (= "~" @win)
    (if (= 1 (setq f$$ (getfiled
          "읽어들일 화일을 선택하십시오." (strcat g_searchpath2 "\\") "itd" 4)))
      (progn
        (setq @win (getstring
          (strcat "\n>>>실내 재료 마감표 화일이름: ")))
        (if (and (/= @win "~") (/= @win ""))
          (setq cdwg @win)
        )
        (if (/= @win "~") (setq @win cdwg))
      )
      (if (/= f$$ nil) 
      (progn
        (setq @win f$$)
        (setq cdwg (substr f$$ 1 (1- (instr f$$ "."))))
        (princ (strcat "\n\실내 재료 마감표 화일이름: " cdwg))
      )(exit))
    )
  )
)

(defun suf1 (/ cdwg )
  (while (= f$$ nil)
    (fin_Dlt)
    (setq filename (strcat cdwg ".itd"))
    (if (= (setq filename (findfile filename)) nil)
      (progn
        (alert (strcat filename " 화일을 찾을 수 없습니다."))
        (setq f$$ nil)
      )
    )
  )
  (setq aa (open filename "r"))
)

(defun suff (/ tmpdist rtnvalue n1 p old_listcount tmpselection)
  	 
  (setq sc (getvar "Dimscale")
	lx (- dx (* sc 10 2))
	SC2 (* (/ 1 61.00) lx))
  (setq pr (fix (/ (- dy (* sc 10)(* sc fin:hgt3 4) (* sc 1) (* sc fin:hgt1 2)) (* sc fin:hgt2 2))))
  
  (setq fin_hangmok1 '("층 별" "실번호" "실 명" "바     닥" "" "" "걸 레 받 이" "" ""
		       "벽" "" "" "천     정" "" "" "상세번호" "비 고" )
	fin_hangmok2 '("" "" ""
		       "바탕 재료" "마감 재료" "두께" "바탕 재료" "마감 재료" "높이"
		       "바탕 재료" "마감 재료" "두께" "바탕 재료" "마감 재료" "천정고")
        text_4 "실 내 재 료  마 감 표"
	column_div '( 3 2 4 5 5 1.5 5 5 1.5 5 5 1.5 5 5 1.5 2 4)
  	tmplist '(4 5 7 8 10 11 13 14)
  )

  (setq n1 1 n2 0) ;;테이블변수
  
  (if fin_new_table_chk
  (progn
    	  (setq rtnvalue T kkkk 0)
	  (while rtnvalue  
	;;  (setq ly (/ (- dy (* sc 10) (* sc fin:hgt3 4) (* sc 1) (* sc fin:hgt1 4)) pr))
	;(if (< (- dy (* sc 10) (* sc fin:hgt3 4) (* sc 1) (* sc fin:hgt1 2)) (* sc fin:hgt2 listcount 2))
	    	(if (> listcount pr)
		    (progn
			(setq old_listcount listcount
			      listcount pr
			 )
		        (setq text_4 (strcat "실 내 재 료  마 감 표 (" (itoa (1+ kkkk)) ")"))
		      	(fin_table_draw)
		        (setq nnn (* kkkk pr) lenN listcount)
 			(fin_text_draw)
		        (setq tmpselection (ssget pw2))
		        (if (/= tmpselection nil)
		        (command "_copy" "P" "" pw2 (polar pw2 0 (+ dx (* sc 10))))
		        )
			(setq listcount (- old_listcount pr)
			      pw4 (polar pw2 0 (* sc 10))
			      pw2 (polar pw2 0 dx)
			      kkkk (1+ kkkk)
			      )
		      
		    )
		    (progn
		  	(fin_table_draw)
		      	(setq nnn (* kkkk pr) lenN listcount)
 			(fin_text_draw)
		    (setq rtnvalue nil)
		    )
		  )
	  )
  )
  (progn
 	(fin_table_draw)
    	(setq nnn 0 lenN listcount)
 	(fin_text_draw)
  )
 )
)

(defun fin_table_draw(/ hor_line_cnt)
  (setq pw4 (polar pw4 0 (* sc 10))
        pw4 (polar pw4 (dtr 270) (* sc fin:hgt3 4))
	pt6 (polar pw4 0 (/ (- dx (* sc 10 2)) 2))
	pt6 (polar pt6 (dtr 90) (* sc fin:hgt3))
  )
    ;-------- 항목
  (setq pw5 pw4 pw6 pw4)
  (command "_line" pw4 (polar pw4 0 lx) "")
 
  (setq pw4 (polar pw4 (dtr 270) (* sc fin:hgt1 2)))
  (command "_line" (polar pw4 0 (*  sc2 9)) (polar pw4 0 (- lx (* 6 sc2))) "")
  
  (setq pw4 (polar pw4 (dtr 270) (* sc fin:hgt1 2)))
  (command "_line" pw4 (polar pw4 0 lx) "")
  
  (setq pw4 (polar pw4 (dtr 270) (* sc 1))
	pw7 pw4)
  (command "_line" pw4 (polar pw4 0 lx) "")

  (setq pw4 (polar pw4 (dtr 270) (* sc fin:hgt2 2)))
  ;-------- 가로줄
  
  (repeat (setq hor_line_cnt (if null_tbl_chk listcount pr ))
    (if (or (null (nth n2 flore_count)) (<= hor_line_cnt 1))
      (command "_line" pw4 (polar pw4 0 lx) "")
      (progn
	    (if (< n1 (atoi (nth n2 flore_count)))
		(command "_line" (polar pw4 0 (* sc2 3)) (polar pw4 0 lx) "")
	        (progn (command "_line" pw4 (polar pw4 0 lx) "") (setq n1 0) (setq n2 (1+ n2)))
	    )
	)
     )
	  	(setq pw4 (polar pw4 (dtr 270) (* sc fin:hgt2 2))
		      n1 (1+ n1)
		      hor_line_cnt (1- hor_line_cnt))
     
  )
  ;-------- ver
  
  (setq tmpdist (- (distance pw4 pw5) (* sc fin:hgt2 2)))
  (setq n3 0)
  (repeat (length column_div)
    (if (member n3 tmplist)
     (command "line" (polar pw5 (* pi 1.5) (* sc fin:hgt2 2)) (polar pw5 (dtr 270) tmpdist) "")
     (command "line" pw5 (polar pw5 (dtr 270) tmpdist) "")
    )
     (setq pw5 (polar pw5 0 (* sc2  (nth n3 column_div))))
     (setq n3 (1+ n3))
  )
  
  (command "line" pw5 (polar pw5 (dtr 270) tmpdist) "")
)

(defun fin_text_draw(/ pre_text)
  ;----- 항목 text
  (if (not (stysearch fin:sty1))
    (styleset fin:sty1)
  )
  (setq n3 0)
  (setvar "textstyle" fin:sty1)
  (setq pw6 (polar pw6 (dtr 270) (* sc (* fin:hgt1 2))) )
  (setq pw6_1 (polar pw6 (* pi 0.5) (* sc fin:hgt1 )))
  (setq pw6_2 (polar pw6 (* pi 1.5) (* sc fin:hgt1 )))
  ;;;(setq pw6 (polar pw6 0 (/ (* (nth n3  column_div) sc2) 2.0)))

  (repeat (length column_div)
    (setq pw6 (polar pw6 0 (/ (*(nth n3 column_div) sc2)2.0))) 
    (if (and (> n3 2) (< n3 15))
      (progn
	(command "_text" "_MC" (polar pw6 (* pi 1.5) (* fin:hgt1 sc)) (* fin:hgt1 sc) 0 (nth n3 fin_hangmok2))
	(command "_text" "_MC" (polar (polar pw6 0 (* sc2 3.25)) (* pi 0.5) (* fin:hgt1 sc)) (* fin:hgt1 sc) 0 (nth n3 fin_hangmok1))
      )
      (command "_text" "_MC" pw6 (* fin:hgt1 sc) 0 (nth n3 fin_hangmok1))  
    )
     (setq pw6 (polar pw6 0 (/ (*(nth n3 column_div) sc2) 2.0)))
     (setq n3 (1+ n3)) 
  )

 
  (command "_.color" 1)
  (if (not (stysearch fin:sty3))
    (styleset fin:sty3)
  )
  (setvar "textstyle" fin:sty3)
  (command "_.text" "_C" pt6 (* fin:hgt3 sc) 0 text_4)
  (setq p_list (textbox (entget (entlast))))
  (setq p_leng (- (car (nth 1 p_list)) (car (nth 0 p_list))))
  (setq p_leng (+ p_leng (* sc 10)))
  (setq pt6x (polar pt6 (dtr 180) (/ p_leng 2))
        pt61 (polar pt6x (dtr 270) (* sc 1.5))
        pt62 (polar pt6x (dtr 270) (* sc 2))
  )
  (command "_.line" pt61 (polar pt61 0 p_leng) "")
  (command "_.line" pt62 (polar pt62 0 p_leng) "")



  ;; -- 내용 text
  (if (not (stysearch fin:sty2))
    (styleset fin:sty2)
  )
  
  (command "_.color" "BYLAYER")
  (setvar "textstyle" fin:sty2)
  
  (setq ;;pw7 (polar pw7 0 (/ (* (nth n3  column_div) sc2) 2.0))
	pw7 (polar pw7 (dtr 270) (* sc fin:hgt2))
	pw8 pw7)

  
  (setq mmm 0  lenM (length column_div))
  
  
  (repeat lenN    
    (repeat lenM     
      (setq pw8 (polar pw8 0  (/ (* (nth mmm  column_div) sc2) 2.0)))
      (setq tmp_text (nth mmm (nth nnn fin:data)))
        (cond ((= mmm 0)
	       (if (/= pre_text tmp_text) 
		 (command "_text" "_MC" pw8 (* fin:hgt2 sc) 0 tmp_text)
	       ))
	      (T
 	      (if (/= tmp_text "")
	      	 (command "_text" "_MC" pw8 (* fin:hgt2 sc) 0 tmp_text)
	      ))
	)
     	
      (setq pw8 (polar pw8 0  (/ (* (nth mmm  column_div) sc2) 2.0)))
		(if (and (/= mmm 15) (/= mmm 16) (= tmp_text ""))
		  (progn
	    		(command "_line" (polar pw8 (* pi 0.5) (* fin:hgt2 sc))
				 (polar (polar pw8 (* pi 1.5) (* fin:hgt2 sc)) pi (* (nth mmm  column_div) sc2) )""
			)
		  )
   		)
	(setq mmm (1+ mmm))
        
    )
    (setq pre_text (nth 0 (nth nnn fin:data)))
      	(setq pw8 (polar (list (car pw7) (cadr pw8)) (dtr 270) (* sc fin:hgt2 2)))
        (setq nnn (1+ nnn) mmm 0)
  )
)
(defun m:fLIST (/
               cec      sc       pw1      pw2      pw3      pw4      pw5
               pw6      pw7      pw8      pt6x     pt61     pt62
               pt3      pt4      pt6      
               dx       dy       aa       bb            
               pr       
                            lx       ly         
               filename
               p_list   p_leng      
               text_1   text_2   text_3   text_4   chech_table
               listcount nnn step1 step2 f$$ fin_hangmok1 fin_hangmok2
		flore_name flore_count fin:DAta tmplist delete_wast ) ;)
  
(defun delete_wast (tmp_list  / len1 nn1 tmp1 tmplist)
  (setq tmplist '(6 7 11 12 16 17)
	len1 (length tmp_list)
	nn1 0)
 (repeat len1
   (if (not (member nn1 tmplist))
   	(setq tmp1 (cons (nth nn1 tmp_list) tmp1))
   )
   (setq nn1 (1+ nn1 ))
 )
  (setq tmp1 (reverse tmp1))
)

  
  (setq cec (getvar "CECOLOR"))
  
  ;;
  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n실내 재료 마감표를 작성하는 명령입니다.")
  
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
  (setlay fin:lay)
  (setvar "blipmode" 1)
  (setvar "osmode" 33)
  (setvar "highlight" 0)
  (setq Step1 T Step2 T)
  (while Step1
    	  (initget "Dialog ")
	  (setq pw1 (getpoint "\n>>> Dialog/<좌측 하단>: "))
	  (cond ((= pw1 "Dialog") (dd_flist))
    	  	(T (setq step1 nil))
		)
  )
  
  (if (null pw1 ) (exit))
    
	(while Step2
	   (initget "Dialog ")
	   (setq pw2 (getcorner pw1
	              "\n>>> Dialog/<우측 상단>: "))
	   
	  	(cond ((= pw2 "Dialog") (dd_flist))
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
	 (if (null f$$) (suf1))
	  
	  (setq listcount 0)
	  
	  (setq bb (read-line aa) fin:DAta nil)
  	   ;(setq listcount (1- (atoi bb))) ;;(substr bb 1 (- (strlen bb) 1)
  	  (setq bb (read-line aa))
  	   (setq flore_count (split bb "|"))
	  (setq bb (read-line aa))
  	   (setq flore_name (split bb "|"))
  	  (setq bb (read-line aa))
	  (while (and (/= bb "") (/= bb nil))
	    (setq fin:DAta (cons (delete_wast (split bb (chr 126))) fin:DAta))
	    (setq bb (read-line aa))
	  )
	  
	  (close aa)
	  (setq fin:DAta (reverse fin:DAta) listcount (length fin:DAta))
 
	  (suff)
 
  
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
 
  (princ)
)

;---------------------------------------------------------------------------------
(defun flist_init ()

  ;; Common properties for all entities

  
  (defun set_tile_props ()
    (set_tile "error" "")
   
    (set_tile "ed_textsize1" (rtos fin:hgt1))
    (set_tile "ed_textsize2" (rtos fin:hgt2))
    (set_tile "ed_textsize3" (rtos fin:hgt3))
 
    (pop_set "pop_textstyle1")
    (pop_set "pop_textstyle2")
    (pop_set "pop_textstyle3")

    (set_tile "pop_textstyle1" (itoa (get_index fin:sty1 stnmlst)))
    (set_tile "pop_textstyle2" (itoa (get_index fin:sty2 stnmlst)))
    (set_tile "pop_textstyle3" (itoa (get_index fin:sty3 stnmlst)))    
    (get_style "pop_textstyle1")

    (set_tile "tg_table_auto" (if null_tbl_chk "1" "0"))    
    (set_tile "tg_next_auto" (if fin_new_table_chk "1" "0")) 
  )

  (defun set_action_tiles ()
 
    (action_tile "pop_textstyle1" "(get_style \"pop_textstyle1\")")
    (action_tile "pop_textstyle2" "(get_style \"pop_textstyle2\")")
    (action_tile "pop_textstyle3" "(get_style \"pop_textstyle3\")")
    
    (action_tile "ed_textsize1"  "(getfsize $value \"ed_textsize1\")")
    (action_tile "ed_textsize2"  "(getfsize $value \"ed_textsize2\")")
    (action_tile "ed_textsize3"  "(getfsize $value \"ed_textsize3\")")
    
    (action_tile "tg_table_auto" "(setq null_tbl_chk (if (= $value \"1\" ) T nil))")    
    (action_tile "tg_next_auto" "(setq fin_new_table_chk (if (= $value \"1\" ) T nil))")   
    
    (action_tile "bn_file_open"  "(suf1)(set_tile \"ed_file_name\" f$$)")
    (action_tile "ed_file_name"  "(check_filename_exist)")
    
    (action_tile "accept"       "(dismiss_dialog 1)")
    (action_tile "cancel"       "(dismiss_dialog 0)")
  )
 

  (defun getfsize (value tiles)
    (cond 
	  ((= tiles "ed_textsize1")
	   (setq fin:hgt1 (verify_d tiles value fin:hgt1)))
	  ((= tiles "ed_textsize2")
	   (setq fin:hgt2 (verify_d tiles value fin:hgt2)))
	  ((= tiles "ed_textsize3")
	   (setq fin:hgt3 (verify_d tiles value fin:hgt3)))
	  

    )
    )
  
  (defun verify_d (tile value old-value / coord valid errmsg ci_coord)
    (setq valid nil errmsg "Invalid input value.")
    (if (setq coord (distof value))
      (progn
	(cond
          
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
 
        (setq last-tile tile)
              
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
        (done_dialog action))
    )
  )

 (defun get_style (tmp_tile_name / idx rd_idx tmpstyle)
  (setq idx (atoi (get_tile tmp_tile_name)))   
  (ci_image "text_image" (nth idx slblist))
  (setq tmpstyle (nth idx stnmlst))  
  (cond ((= tmp_tile_name "pop_textstyle1")
	 (setq fin:sty1 tmpstyle))
	((= tmp_tile_name "pop_textstyle2")
	 (setq fin:sty2 tmpstyle))
	((= tmp_tile_name "pop_textstyle3")
	 (setq fin:sty3 tmpstyle))
  )
 )
  
) ; end wn2_init
(defun flist_do ()
  (if (not (new_dialog "dd_Flist" dcl_id)) (exit))
  (set_tile_props)
  (set_action_tiles)
  (setq dialog-state (start_dialog))
  (if (= dialog-state 0)
   (setq reset_flag t)
  )
)

(defun flist_return ()
  
  (setq fin:hgt1 old_hgt1  
        fin:hgt2 old_hgt2  
        fin:hgt3 old_hgt3  
        fin:sty1 old_sty1  
	fin:sty2 old_sty2  
	fin:sty3 old_sty3  
        fin:Autoflag old_autoflag 
        fin:pc old_pc	
      
  )
)

(defun dd_flist ( / old_hgt1 old_hgt2 old_hgt3 old_sty1 old_sty2 old_sty3
		    old_autoflag old_pc reset_flag dismiss_dialog get_style verify_d getfsize  set_action_tiles set_tile_props )
  

  (setq old_hgt1  fin:hgt1
        old_hgt2  fin:hgt2
        old_hgt3  fin:hgt3
        old_sty1  fin:sty1
	old_sty2  fin:sty2
	old_sty3  fin:sty3
        old_autoflag  fin:Autoflag
        old_pc  fin:pc
  )
  
  (cond

    ((not (setq dcl_id (Load_dialog "DList.dcl")) ))   ; is .DLG file loaded?

    (t
     ;(ai_undo_push)
     ;(princ ".")
     ;(flist_Draw_Image_X)
     ;(readf "Dwgtitle.dat" T)
     (flist_init)                              ; everything okay, proceed.
     (princ ".")
     (flist_do)
    )  

  )  ;;  cond
  
  (if reset_flag
    (flist_return)
    ;(flist_set)
  )
  
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(if (null fin:lay) (setq fin:lay "TABLE"))
(if (null fin:hgt1) (setq fin:hgt1 4))
(if (null fin:hgt2) (setq fin:hgt2 4))
(if (null fin:hgt3) (setq fin:hgt3 7))
(if (null fin_new_table_chk) (setq fin_new_table_chk T))
(if (null null_tbl_chk) (setq null_tbl_chk T))
(if (null fin:sty3) (setq fin:sty3 "CIHD"))
(if (null fin:sty2) (setq fin:sty2 "CIHS"))
(if (null fin:sty1) (setq fin:sty1 "CIHD"))
(if (null fin:pc) (setq fin:pc 3))

(defun C:cimfLIST () (m:flist))

(princ)
