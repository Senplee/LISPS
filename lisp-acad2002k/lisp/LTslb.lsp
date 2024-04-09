(setq lfn44 1)
(defun m:slb (/ reset_flag )
  (ai_err_on)
  (ai_undo_on)
  
  (command "_.undo" "_group")
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n슬라브 일람표를 작성하는 명령입니다.")
  (dd_slb)
  (if (null reset_flag)
   (draw_slb)
  )
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
 
  (princ)
)
;-----------------------------------------------------
(defun draw_slb(/ cec listcount pw1 pw2 pw3 pw4)
  
  

  (setlay "TABLE")
  (setvar "blipmode" 1)
  (setvar "osmode" 33)
  (setvar "highlight" 0)
  (setq Step1 T Step2 T)
  (while Step1
    	  (initget "Dialog ")
	  (setq pw1 (getpoint "\n>>> Dialog/<좌측 하단>: "))
	  (cond ((= pw1 "Dialog") (dd_slb))
    	  	(T (setq step1 nil))
		)
  )
  
  (if (null pw1 ) (exit))
    
	(while Step2
	   (initget "Dialog ")
	   (setq pw2 (getcorner pw1
	              "\n>>> Dialog/<우측 상단>: "))
	   
	  	(cond ((= pw2 "Dialog") (dd_slb))
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
	  
	  (setq listcount (length @type))
	   
	  (slb_sub)
  
)

(defun slb_sub(/ text_4 hangmok0 hangmok1  pr pw5 ins_point pt6 pw6 pw7 pw8)
  (setq sc (getvar "Dimscale")
	lx (- dx (* sc 10 2))
	SC2 (* (/ 1 61.00) lx))
  (setq pr (fix (/ (- dy (* sc 10) (* sc hgt3 4) (* sc hgt1 2) (* lx 0.2 (/ 4.0 3.0))) (* sc hgt2 2))))
  
  (setq hangmok0 '("TYPE\"A\"" "TYPE\"B\"" "TYPE\"C\"" "TYPE\"D\"" "TYPE\"E\"")
    	hangmok1 '("NAME" "TYPE" "THK" "단변 (Lx)" "장변 (Ly)"
		   "X1" "X2" "X3" "X4" "X5" "Y1" "Y2" "Y3" "Y4" "Y5")
        text_4 "슬 라 브 일 람 표"
	
  )
  (slb_table_draw)
  (slb_txt_draw)

)
(defun slb_table_draw(/ hor_line_cnt  tmpdist1 tmpdist2 p
		        )
  (setq pw4 (polar pw4 0 (* sc 10))
        pw4 (polar pw4 (dtr 270) (* sc hgt3 4))
	pt6 (polar pw4 0 (/ (- dx (* sc 10 2)) 2))
	pt6 (polar pt6 (dtr 90) (* sc hgt3))
  )
    ;-------- 목
 
  (setq pw5 pw4 pw6 pw4)
  (command "_line" pw4 (polar pw4 0 lx) "")
 
  (setq pw4 (polar pw4 (dtr 270) (* sc hgt1 2))
	ins_point pw4)
  (command "_line" pw4 (polar pw4 0 lx) "")
  
  (setq pw4 (polar pw4 (dtr 270) (* lx 0.2 (/ 4.0 3.0)))
	pw7 pw4 pw8 pw4	)
  (command "_line" pw4 (polar pw4 0 lx) "")
  
  (setq pw4 (polar pw4 (dtr 270) (* sc hgt2 2)))
  (command "_line" (polar pw4 0 (* lx 0.2)) (polar pw4 0 lx) "")

  ;-------- 가로줄
  
  (repeat (1- pr )
      (command "_line" (setq pw4 (polar pw4 (dtr 270) (* sc hgt2 2))) (polar pw4 0 lx) "")
  )
  ;-------- ver
  
  (setq tmpdist1 (distance pw4 pw5)
	tmpdist2 (distance pw5 pw7))
  (command "_line" pw5 (polar pw5 (dtr 270) tmpdist1) "")
  (setq p pw5)
  (repeat 2
	  (command "_line" (setq p (polar p 0 (* 0.2 lx))) (polar p (* pi 1.5) tmpdist1) "")
	  (command "_line" (setq p (polar p 0 (* 0.2 lx))) (polar p (* pi 1.5) tmpdist2) "")
  )
  (command "_line" (setq p (polar p 0 (* 0.2 lx))) (polar p (* pi 1.5) tmpdist1) "")
  
  (command "_line" (setq pw7 (polar pw7 0 (* lx (/ 1 15.0)))) (polar pw7 (dtr 270) (- tmpdist1 tmpdist2 )) "")
  (command "_line" (setq pw7 (polar pw7 0 (* lx (/ 1 15.0)))) (polar pw7 (dtr 270) (- tmpdist1 tmpdist2 )) "")
  (setq pw7 (polar pw7 (dtr 270) (* sc hgt2 4)))
  (setq pw7 (polar pw7 0 (* lx (/ 1 15.0)))
	pw7 (polar pw7 (/ pi 2) (* sc hgt2 2)))
  (repeat 4
    (command "_line" (setq pw7 (polar pw7 0 (* lx (/ 2 25.0))))
	     (polar pw7 (dtr 270) (- tmpdist1 tmpdist2 (* sc hgt2 2))) "")
  )
  (setq pw7 (polar pw7 0 (* lx (/ 2 25.0))))
  (repeat 4
    (command "_line" (setq pw7 (polar pw7 0 (* lx (/ 2 25.0)))) (polar pw7 (dtr 270) (- tmpdist1 tmpdist2 (* sc hgt2 2))) "")
  )
)




(defun slb_txt_draw(/ p_list p_leng pt6x pt61 pt62 n1 n2 nn mm pwa pwb tmptxt)
  (command "_insert" "slabtype" "_S" (/ lx 76350.0) ins_point 0 )
;------ 슬라브 일람표
  (if (not (stysearch "CIHD"))
    (styleset "CIHD")
  )
  (command "_.color" 1)
  (setvar "textstyle" "CIHD")

  (command "_.text" "_C" pt6 (* hgt3 sc) 0 text_4)
  (setq p_list (textbox (entget (entlast))))
  (setq p_leng (- (car (nth 1 p_list)) (car (nth 0 p_list))))
  (setq p_leng (+ p_leng (* sc 10)))
  (setq pt6x (polar pt6 (dtr 180) (/ p_leng 2))
        pt61 (polar pt6x (dtr 270) (* sc 1.5))
        pt62 (polar pt6x (dtr 270) (* sc 2))
  )
  (command "_.line" pt61 (polar pt61 0 p_leng) "")
  (command "_.line" pt62 (polar pt62 0 p_leng) "")
  (command "_.color" 7)
;;------ 항목1
  (setq pw6 (polar pw6 (dtr 270) (* sc hgt1))
	n1 0)
  
  (repeat 5
    (setq pw6 (polar pw6 0 (* lx 0.1))) 
    (command "_text" "_MC" pw6 (* hgt1 sc) 0 (nth n1 hangmok0))
    (setq pw6 (polar pw6 0 (* lx 0.1))
	  n1 (1+ n1)) 
  )
;;------ 항목2
   (if (not (stysearch "CIHS"))
    (styleset "CIHS")
   )
   (setvar "textstyle" "CIHS")
  (setq 
    	pw8 (polar pw8 (dtr 270) (* sc (* hgt1 2)))
	pwa (polar pw8 (dtr 270) (* sc (* hgt1 2)))
	n2 0
	pw8 (polar pw8 0 (* lx (/ 1 30.0))))
  
  (repeat 3
    (command "_text" "_MC" pw8 (* hgt1 sc) 0 (nth n2 hangmok1))
    (setq pw8 (polar pw8 0 (* lx (/ 1 15.0))))
    (setq n2 (1+ n2))
  )

   (setq pw9 pw8 
	 pw8 (polar pw8 (/ pi 2) (* sc hgt1))
	 pw8 (polar pw8 0 (* lx 0.2)))
  (repeat 2
    (command "_text" "_MC" pw8 (* hgt1 sc) 0 (nth n2 hangmok1))
    (setq pw8 (polar pw8 0 (* lx 0.4)))
    (setq n2 (1+ n2))
  )
   (setq pw9 (polar pw9 0 (* lx (- (/ 1 25.0) (/ 1 30.0))))
	 pw9 (polar pw9 (dtr 270) (* sc hgt1)))
  (repeat 10
    (command "_text" "_MC" pw9 (* hgt1 sc) 0 (nth n2 hangmok1))
    (setq pw9 (polar pw9 0 (* lx (/ 2 25.0))))
    (setq n2 (1+ n2))
  )
 ;; ----내용 
  (setq nn 0 )
  (setq pwa (polar pwa (dtr 270) (* sc hgt2))
	pwb (polar pwa 0 (* lx (/ 3 15.0)))
	)
  (repeat listcount
    (setq p1 (polar pwa 0 (* lx (/ 1 30.0)))
	  p2 (polar pwb 0 (* lx (/ 1 25.0)))
	  mm 0)
    (repeat 13
	(if (< mm 3)
	  (progn
	    (if (/= (setq tmptxt (nth mm (cdr (nth nn @TYPE)))) "")
	    	(command "_text" "_MC" p1 (* hgt2 sc) 0 tmptxt)
	      	(command "_line" (polar (polar p1 (dtr 270) (* hgt2 sc)) pi (* lx (/ 1 30.0)))
			 	 (polar (polar p1 (dtr 90) (* hgt2 sc)) 0 (* lx (/ 1 30.0))) "")
	    )
	    (setq p1 (polar p1 0 (* lx (/ 1 15.0))))
	  )
	  (progn
	    (if (/= (setq tmptxt (nth mm (cdr (nth nn @TYPE)))) "")
	    	(command "_text" "_MC" p2 (* hgt2 sc) 0 tmptxt)
	      	(command "_line" (polar (polar p2 (dtr 270) (* hgt2 sc)) pi (* lx (/ 1 25.0)))
			 	 (polar (polar p2 (dtr 90) (* hgt2 sc)) 0 (* lx (/ 1 25.0))) "")
	    )
	    (setq p2 (polar p2 0 (* lx (/ 2 25.0))))
	  )
	)
        (setq mm (1+ mm))
    ); repeat
    (setq pwa (polar pwa (dtr 270) (* hgt2 sc 2 ))
	  pwb (polar pwb (dtr 270) (* hgt2 sc 2 ))
	  nn (1+ nn)
	)
  ); repeat
)
(defun slb_init ()
  

  (defun set_tile_props (/ what_slb_type)
    
    (set_tile (strcat (setq what_slb_type (strcase (nth 2 (nth L_index @TYPE)) T)) "type") "1")
    (set_tile "ssym" (nth 1 (nth L_index @TYPE)))
    (set_tile "sthk" (nth 3 (nth L_index @TYPE)))
    (set_tile "x1" (nth 4 (nth L_index @TYPE)))
    (set_tile "x2" (nth 5 (nth L_index @TYPE)))
    (set_tile "x3" (nth 6 (nth L_index @TYPE)))
    (set_tile "x4" (nth 7 (nth L_index @TYPE)))
    (set_tile "x5" (nth 8 (nth L_index @TYPE)))
    (set_tile "y1" (nth 9 (nth L_index @TYPE)))
    (set_tile "y2" (nth 10 (nth L_index @TYPE)))
    (set_tile "y3" (nth 11 (nth L_index @TYPE)))
    (set_tile "y4" (nth 12 (nth L_index @TYPE)))
    (set_tile "y5" (nth 13 (nth L_index @TYPE)))
    (set_tile "height1" (rtos hgt1))
    (set_tile "height2" (rtos hgt2))
    (set_tile "height3" (rtos hgt3))
  )

  
  (defun set_action_tiles ()
   
	 (action_tile "append" "(newIndex)")
    	 (action_tile "modify" "(modifyIdx)")
	 (action_tile "insert" "(insIdx)")
	 (action_tile "delete" "(deleteIdx \"C_slb_type\")(set_tileS)")
	 (action_tile "open" "(open_slb_flie)")
   	 (action_tile "save" "(save_slb_flie)")
    
    (action_tile "atype" 	"(ci_image \"type\" \"struct(SLABA)\")")
    (action_tile "btype" 	"(ci_image \"type\" \"struct(SLABB)\")")
    (action_tile "ctype" 	"(ci_image \"type\" \"struct(SLABC)\")")
    (action_tile "dtype" 	"(ci_image \"type\" \"struct(SLABD)\")")
    (action_tile "etype" 	"(ci_image \"type\" \"struct(SLABE)\")")
    
    (action_tile "ok"       "(dismiss_dialog 1)")
    (action_tile "cancel"       "(dismiss_dialog 0)")
	(action_tile "height1" "(getfsize $value \"height1\")")
    	(action_tile "height2" "(getfsize $value \"height2\")")
    	(action_tile "height3" "(getfsize $value \"height3\")")	
    
  )
  (defun getfsize (value tiles)
    (cond 
	  ((= tiles "height1")
	   (setq hgt1 (verify_d tiles value hgt1)))
	  ((= tiles "height2")
	   (setq hgt2 (verify_d tiles value hgt2)))
	  ((= tiles "height3")
	   (setq hgt3 (verify_d tiles value hgt3)))
     )
  )
  
  (defun verify_d (tile value old-value / coord valid errmsg ci_coord)
    (setq valid nil errmsg "Invalid input value.")
    (if (setq coord (distof value))
      (progn
	(if (> coord 0)
              (setq valid T)
              (setq errmsg "Value must be positive or non zero.")
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
          coord
      )
      (progn
        (mode_tile tile 2)
        (set_tile "error" errmsg)
        (setq last-tile tile)
        old-value
      )
    )
  )

  (defun save_slb_flie(/ f$$ f_file_name)
    (modifyIdx)
    (setq f_file_name (substr C_slb_flie 1 (- (strlen C_slb_flie) 4)))
    (setq f$$ (getfiled
          "저장할 파일명" Long_slb_file "sdt" 1))
    (if (/= f$$ nil)
    	(writeF f$$ nil)
    )
  )
  (defun open_slb_flie(/ f$$ f_file_name)
    ;;(setq f_file_name Long_slb_file)
    (setq f$$ (getfiled
          "읽을 파일명" Long_slb_file "sdt" 8))
    (if (/= f$$ nil)
      (progn
	(setq C_slb_flie f$$)
	(setq Long_slb_file (findfile C_slb_flie))
    	(readF Long_slb_file nil)
	(setq L_index 0)
     	(setq C_slb_type (nth 0 (cdr (nth L_index @Type))))
	(list_view)
	(set_tileS)
	(set_tile_props)
      )
    )
  )  
  (defun newindex(/ temp_o n_n )
    	(setq temp_o (cdr (nth L_index @Type)))
        (setq n_n (1+ (length @type)))
	(setq @Type (append @type (list (cons N_n temp_o))))
    	(setq L_index (1- n_n))
        (list_view)
  )
  (defun insIdx(/ temp_o n_n tmpType n)
	(setq temp_o (valueTolist))
    	(setq n_n (1+ L_index) n 0 m 0)
        (repeat (length @Type)
	  (if (= n n_n)
	    (progn
	      	(setq tmpType (append tmpType (list (cons (1+ n_n) temp_o))))
	    	(setq n (1+ n))   
	      )		
	  )
	  (setq tmpType (append tmpType (list (cons (1+ n) (cdr (nth m @type))))))
	  (setq n (1+ n) m (1+ m))
	)
    	(setq @type tmpType)
	(list_view)
        (setq L_index (1+ L_index))
        (set_tileS)
  )
  (defun modifyIdx(/ temp_o new_data tmp)
    	(setq temp_o (cdr (nth L_index @Type)))
    	(setq tmm (valueTolist))
    	(setq new_data (cons (1+ L_index) tmm))
    	(setq @TYPE (subst new_data (cons (1+ L_index) temp_o) @Type))
    	(list_view)
    	(set_tileS)
  )
  (defun valueTolist()
    (list (if (null (setq tmp (get_tile "ssym"))) "" tmp) (if (null (setq tmp (strcase (substr (get_tile "rd_type") 1 1)))) "" tmp)
		  (if (null (setq tmp (get_tile "sthk"))) "" tmp) (if (null (setq tmp (get_tile "x1"))) "" tmp)
		  (if (null (setq tmp (get_tile "x2"))) "" tmp) (if (null (setq tmp (get_tile "x3"))) "" tmp)
		  (if (null (setq tmp (get_tile "x4"))) "" tmp) (if (null (setq tmp (get_tile "x5"))) "" tmp)
	  	  (if (null (setq tmp (get_tile "y1"))) "" tmp) (if (null (setq tmp (get_tile "y2"))) "" tmp)
		  (if (null (setq tmp (get_tile "y3"))) "" tmp) (if (null (setq tmp (get_tile "y4"))) "" tmp)
		  (if (null (setq tmp (get_tile "y5"))) "" tmp)
		)
    )
  (defun dismiss_dialog (action)
    (if (= action 0)
      (done_dialog 0)
      (done_dialog action)
    )
  )

(defun ttest (/ old_slb_type)
 (readF Long_slb_file nil)

    (progn
      (setq zin_old (getvar "dimzin"))
      (setvar "dimzin" 8)
      (list_view)
      (Set_tileS)
      (action_tile "list_type" "(setq C_slb_type (Field_match \"타입명\" (setq L_index (atoi $value))))(set_tileS)(set_tile_props)")
      (setvar "dimzin" zin_old)
))

(defun set_tileS ()
 (if (= L_index nil) (setq L_index 0 ))
 (set_tile "list_type" (rtos L_index)) 
)
;;; 
;;;(defun qqqq()
;;;  (Set_slb_Value)(writeF "slbType.dat" nil)(done_dialog 1)(set_tile_props)
;;;)
;;;
;;;(defun cancel ()
;;;    (done_dialog 0)
;;;)
) ; end wn2_init

(defun slb_do ()
  (if (not (new_dialog "slab" dcl_id)) (exit))
  (set_tile_props)
  (ci_image "type" (strcat "struct(SLAB" (strcat (setq what_slb_type (nth 2 (nth L_index @TYPE)) ) ")" )))
  (ttest)
  (set_action_tiles)
  (setq dialog-state (start_dialog))
  (if (= dialog-state 0)
   (setq reset_flag t)
  )
)

(defun slb_return ()
  
  (setq L_index old_idx )
)



(defun dd_slb (/ getfsize verify_d
                      
           dcl_id           dialog-state     dismiss_dialog
           	set_action_tiles set_tile_props    
	   action_Tiles ttest   set_tileS 	valueTolist 
	       
	   modifyIdx insIdx newindex) 


  (setvar "cmdecho" (cond (  (or (not *debug*) (zerop *debug*)) 0)
                          (t 1)))

  (setq old_idx L_index)

  (princ ".")
  (cond
     (  (not (setq dcl_id (Load_dialog "slab.dcl"))))   ; is .DLG file loaded?

     (t (ai_undo_push)
        (princ ".")
        (slb_init)                             ; everything okay, proceed.
        (princ ".")
        (slb_do)
     )
  )
  (if reset_flag
    (slb_return) 
  )
  (if dcl_id (unload_dialog dcl_id))
)

(if (null C_slb_flie)
   (progn
     (setq C_slb_flie (strcat "Sample" ".sdt"))
     (setq Long_slb_file (strcat g_searchpath2 "\\" C_slb_flie))
     (setq L_index 0)
     (readF Long_slb_file nil) (setq L_index 0)
     (setq C_slb_type (nth 0 (cdr (nth L_index @Type))))
   )
)

(if (null slb:lay) (setq slb:lay "TABLE"))
(if (null hgt1) (setq hgt1 4))
(if (null hgt2) (setq hgt2 4))
(if (null hgt3) (setq hgt3 8))
(defun C:cimslb ()
  (m:slb)
)
(princ)