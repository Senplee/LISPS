;수정날짜 :2001.8.10
;작업자: 박율구
;명령어	
;	C:cimDTL ()   도면제목 작성하기 	



;단축키 관련 변수 정의 부분 -맨 뒤로..

(defun dtl_Draw_Image_X( / )
(defun dtl_DrawImage (dtl_key !dtltype! / fcolor ccolor ncolor dcolor tcolor scolor cx cy dx dy )
  (setq ccolor (propcolor dtl:cprop))
  (setq ncolor (propcolor dtl:nprop))  
  (setq dcolor (propcolor dtl:dprop)) 
  (setq tcolor (propcolor dtl:tprop))
  (setq scolor (propcolor dtl:sprop))
    (do_blank dtl_key 0)
    (start_image dtl_key)	  
 	(drawImage_dtl)
    (end_image)
)

(defun drawImage_dtl (/ cx cy dx dy x1 x2 x3 x4 x5 x6 x7 x8 x9 x10
		x11 x12 x13 x14 x15 x16 x17 x18 x19 x20 x21
		x22 x23 x24 x25 x26 x27 x28 x29
		y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11)
	
 (setq  cx (dimx_tile dtl_key)
	cy (dimy_tile dtl_key)
	dx   (/ cx 36) dy  (/ cy 24)
	x1   0 x2  (* dx 2) x3  (* dx 3) x4  (* dx 4) x5  (* dx 5)
	x6   (* dx 6) x7  (* dx 7) x8  (* dx 8) x9  (* dx 9) x10  (* dx 10)
	x11  (* dx 12) x12  (* dx 14) x13  (* dx 16) x14  (* dx 17) x15  (* dx 18)
	x16  (* dx 19) x17  (* dx 20) x18  (* dx 22) x19  (* dx 23) x20  (* dx 24)
	x21  (* dx 25) x22  (* dx 26) x23  (* dx 27) x24  (* dx 28) x25  (* dx 29)
	x26  (* dx 30) x27  (* dx 31) x28  (* dx 32) x29  (* dx 34)
	y1   (* dy 7) y2  (* dy 8) y3  (* dy 9) y4  (* dy 11) y5  (* dy 12)
	y6   (* dy 13) y7  (* dy 14) y8  (* dy 15) y9  (* dy 16) y10  (* dy 18) y11  (* dy 10)
 )

  	(vector_image x2  y4 x3  y3 ccolor)
	(vector_image x3  y3 x5  y2 ccolor)
	(vector_image x5  y2 x7  y2 ccolor)
	(vector_image x7  y2 x9  y3 ccolor)
	(vector_image x9  y3 x10 y4 ccolor)
	(vector_image x10 y4 x10 y6 ccolor)
	(vector_image x10 y6 x9  y8 ccolor)
	(vector_image x9  y8 x7  y9 ccolor)
	(vector_image x7  y9 x5  y9 ccolor)
	(vector_image x5  y9 x3  y8 ccolor)
	(vector_image x3  y8 x2  y6 ccolor)
	(vector_image x2  y6 x2  y4 ccolor)
	(vector_image x10 y5 x29 y5 ccolor)

	(vector_image x11 y1 x13 y1 tcolor)
	(vector_image x12 y1 x12 y4 tcolor)
	(vector_image x14 y1 x16 y1 tcolor)
	(vector_image x15 y1 x15 y4 tcolor)
	(vector_image x14 y4 x16 y4 tcolor)
	(vector_image x17 y1 x20 y1 tcolor)
	(vector_image x18 y1 x18 y4 tcolor)
	(vector_image x21 y1 x21 y4 tcolor)
	(vector_image x21 y4 x24 y4 tcolor)
	(vector_image x28 y1 x25 y1 tcolor)
	(vector_image x25 y1 x25 y4 tcolor)
	(vector_image x25 y4 x28 y4 tcolor)
	(vector_image x25 y3 x28 y3 tcolor)

	(vector_image x20 y6 x19 y6 scolor)
	(vector_image x19 y6 x19 y7 scolor)
	(vector_image x19 y7 x20 y7 scolor)
	(vector_image x20 y7 x20 y8 scolor)
	(vector_image x20 y8 x19 y8 scolor)
	(vector_image x22 y6 x21 y6 scolor)
	(vector_image x21 y6 x21 y8 scolor)
	(vector_image x21 y8 x22 y8 scolor)
	(vector_image x23 y8 x23 y6 scolor)
	(vector_image x23 y6 x24 y6 scolor)
	(vector_image x24 y6 x24 y8 scolor)
	(vector_image x23 y7 x24 y7 scolor)
	(vector_image x25 y6 x25 y8 scolor)
	(vector_image x25 y8 x26 y8 scolor)
	(vector_image x28 y6 x27 y6 scolor)
	(vector_image x27 y6 x27 y8 scolor)
	(vector_image x27 y8 x28 y8 scolor)
	(vector_image x27 y7 x28 y7 scolor)
	(if (= dtl:opt "A") (progn
		(vector_image x5 y4  x6 y11 ncolor)
		(vector_image x6 y11 x6 y7  ncolor)
		(vector_image x5 y7  x7 y7  ncolor)
	) (progn
		(vector_image x1 y5 x10 y5 ccolor)
		(vector_image x6 y3 x6  y4 ncolor)
		(vector_image x4 y8 x4  y6 dcolor)
		(vector_image x4 y6 x5  y6 dcolor)
		(vector_image x5 y6 x5  y8 dcolor)
		(vector_image x4 y7 x5  y7 dcolor)
		(vector_image x8 y6 x8  y8 dcolor)
		(if (= dtl:opt "B") 
			(vector_image x6 y7 x7 y7 dcolor)
			(vector_image x6 y5 x6 y10 ccolor)
		)))
	
 )
)
;;; Main function
;;;
(defun m:dtl (/ temp      cont      uctr      _col
                p1        p2        p3        p4        p5        p6
                p7           strtpt    lay-idx   old-idx   
                temp_color
                dtl_osc)

  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n도면 타이틀을 작성하는 명령입니다.")

  (setq dtl_osc (getvar "dimscale"))
  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")

  (setvar "osmode" 0)

  (setq cont T uctr 0 temp T)

  (while cont
    (dtl_m1)
  )
  
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)

  (princ)
)

(defun dtl_m1 ()
  (while temp
    (setvar "blipmode" 1)
    ;(if (numberp dtl:tco) (setq dtl:tco (color_name dtl:tco)))

    (if (> uctr 0)
      (progn
        (initget "/ Dialog Undo")
        (setq strtpt (getpoint
            "\n>>> Dialog/Undo/<위치>: "))
      )
      (progn
        (initget "/ Dialog")
        (setq strtpt (getpoint
            "\n>>> Dialog/<위치>: "))
      )
    )
    (setvar "blipmode" 0)
    (cond

      ((= strtpt "Undo")
        (command "_.undo" "_B")
        (setq uctr (1- uctr))
      )
      ((= strtpt "Dialog")
        
        (DD_DTL)
      )
      ((null strtpt)
        (setq cont nil temp nil)
      )
      (T
        (command "_.Undo" "_M")
        (dtl_ex)
        (setq uctr (1+ uctr))
      )
    )
  )
)

(defun dtl_ex (/ ) ;rad)
  (setq rad (* dtl_osc dtl:rad))
  (setq p1 strtpt
        p2 (polar p1 0 rad)
        p3 (polar p2 0 (* dtl_osc 4))
        p3 (polar p3 (dtr 90) (* dtl_osc 2))
	p6 (polar p1 (dtr 180) (* rad 1.4))
	p7 (polar p1 (dtr 270) (* rad 1.4))
  )
   
  (if (/= (type dtl:num) 'INT) (setq dtl:num 0))

  (if (or (= dtl:text nil) (= dtl:text ""))
  	(setq dtl:text (getstring "도면명을 입력하시오: " T))
  )
  (cond
    ((or (= (substr dtl:sty 1 2) "GH") (= (substr dtl:sty 1 2) "GC") (= (substr dtl:sty 1 1) "H")
         (= (substr dtl:sty 1 2) "SH") (= (substr dtl:sty 1 1) "C"))
      (setq dtl:txs "축 척")
    )
    (T
      (setq dtl:txs "SCALE")
    )
  )
  (set_col_lin_lay dtl:nprop)
	   	(if (null (stysearch dtl:n_sty)) (styleset dtl:n_sty))
  		(setvar "textstyle" dtl:n_sty)
  
  (if (> dtl:num 0)
    (cond ((= dtl:opt "A")
	   	
    		(command "_.text" "_M" p1 (* dtl_osc dtl:n_shg 2) 0 dtl:num))
	  (T
	   
	   (command "_.text" "_M" (polar p1 (/ pi 2) (/ rad 2)) (* dtl_osc dtl:n_shg) 0 dtl:num)
	   (set_col_lin_lay dtl:dprop)
  		(if (null (stysearch dtl:d_sty)) (styleset dtl:d_sty))
  		(setvar "textstyle" dtl:d_sty) 
	   (if (= dtl:opt "B")
	    (command "_.text" "_M" (polar p1 (* pi 1.5) (* rad 0.4)) (* dtl_osc dtl:d_shg ) 0
		     (strcat dtl:sch "-" (if (< dtl:snum 10) (strcat "0" (itoa dtl:snum)) (itoa dtl:snum))))
	    (progn
	      (command "_.text" "_M" (polar p1 (* pi 1.25) (* (* rad 0.4) (sqrt 2))) (* dtl_osc dtl:d_shg)
		     0 dtl:sch)
	      (command "_.text" "_M" (polar p1 (* pi 1.75) (* (* rad 0.4) (sqrt 2))) (* dtl_osc dtl:d_shg)
		     0 (if (< dtl:snum 10)(strcat "0" (itoa dtl:snum))(itoa dtl:snum)))
	    )
	   )
	  )
    ))
  (set_col_lin_lay dtl:tprop)
  (if (null (stysearch dtl:t_sty)) (styleset dtl:t_sty))
  (setvar "textstyle" dtl:t_sty)
  (command "_.text" p3 (* dtl_osc dtl:t_shg) 0 dtl:text)
  
  (setq p_list (textbox (entget (entlast))))
  (setq p_leng (- (car (nth 1 p_list)) (car (nth 0 p_list))))

  (setq p4 (polar p2 0 (+ p_leng (* dtl_osc 8)))
        p5 (polar p4 (dtr 180) (* dtl_osc 4))
        p5 (polar p5 (dtr 270) (* dtl_osc (+ 2 dtl:s_shg)))
  )
 
  (set_col_lin_lay dtl:cprop)
  (command "_.circle" p1 rad)
  (cond ((= dtl:opt "A")  (command "_.line" p2 p4 ""))
	((= dtl:opt "B") (command "_.line" p6 p4 ""))
	(T (command "_.line" p6 p4 "")(command "_.line" p1 p7 "")))

  (set_col_lin_lay dtl:sprop)
  (if (null (stysearch dtl:s_sty)) (styleset dtl:s_sty))
  (setvar "textstyle" dtl:s_sty)
  (setq dtl:txs (strcat dtl:txs ": 1/" (rtos dtl_osc 2 0)))
  (command "_.text" "_R" p5 (* dtl_osc dtl:s_shg) 0 dtl:txs)
 
  (setq dtl:num (if (= dtl:opt "A") (1+ dtl:num) dtl:num ))
  (setq dtl:snum (if (/= dtl:opt "A") (1+ dtl:snum) dtl:snum ))
)

;;-----------------------------------------------------



(defun dtl_init ()

  (defun dtl_set ()       
	  (PROP_SAVE dtl:prop)
	  (writeF "Dwgtitle.dat" T)
  )

  ;; Common properties for all entities

  
  (defun set_tile_props ()
    (set_tile "error" "")
    (set_tile dtl_prop_type "1")
    
    (@get_eval_prop dtl_prop_type dtl:prop)
    
    (if (= dtl:opt "A") (bn_image_do T)(bn_image_do nil))
    
    
    (dtl_DrawImage "bn_dtl_image" T)

    (set_tile "ed_text" dtl:text)
    (set_tile "ed_diameter" (rtos (* dtl:rad 2)))
    (set_tile "ed_number" (itoa  dtl:num))
    (set_tile "ed_dwgtype" dtl:sch)
    (set_tile "ed_dwgno" (if (< dtl:snum 10)
			   (strcat "0" (itoa dtl:snum))(itoa dtl:snum)))
    (pop_set "pop_textstyle")
    (list_view2)
    (set_tile "pop_textstyle" (itoa (get_index "CIHS" stnmlst)))
    (get_style)
    (set_tile "rd_st_number" "1")
    (radio_gaga)
    (mode_tile "ed_ratio" 1)
  )

  (defun set_action_tiles ()

    (action_tile "b_name"       "(@getlayer)(dtl_DrawImage \"bn_dtl_image\" T)")    
    (action_tile "b_color"      "(@getcolor)(dtl_DrawImage \"bn_dtl_image\" T)")
    (action_tile "color_image"  "(@getcolor)(dtl_DrawImage \"bn_dtl_image\" T)")
    
    (action_tile "c_bylayer"    "(@bylayer_do T)(dtl_DrawImage \"bn_dtl_image\" T)")
    (action_tile "t_bylayer"    "(@bylayer_do nil)(dtl_DrawImage \"bn_dtl_image\" T)")

    (action_tile "prop_radio" "(setq dtl_prop_type $Value)(@get_eval_prop dtl_prop_type dtl:prop)(dtl_DrawImage \"bn_dtl_image\" T)")
    
    (action_tile "bn_dtl_image" "(cond ((= dtl:opt \"A\") (setq dtl:opt \"B\") (bn_image_do nil))((= dtl:opt \"B\") (setq dtl:opt \"C\")(bn_image_do nil))((= dtl:opt \"C\") (setq dtl:opt \"A\")(bn_image_do T)))(dtl_DrawImage \"bn_dtl_image\" T)")
    (action_tile "eb_delete"      "(eb_delete_F)")
    (action_tile "eb_add"         "(eb_add_F)")
    (action_tile "list_text"      "(DTL_DoubleClick? $Value)")


    (action_tile "rd_st_number" "(radio_gaga )")
    (action_tile "rd_st_dwgno" "(radio_gaga )")
    (action_tile "rd_st_title" "(radio_gaga )")
    (action_tile "rd_st_scale" "(radio_gaga )")

    (action_tile "ed_diameter"  "(getfsize $value \"ed_diameter\")")
    (action_tile "ed_number"       "(getfsize $value \"ed_number\")")
    (action_tile "ed_textsize"   "(getfsize $value \"ed_textsize\")(get_style)")

    ;(action_tile "ed_ratio"      "(getfsize $value \"ed_ratio\")")
    (action_tile "pop_textstyle" "(get_style)")
    
    (action_tile "accept"       "(dismiss_dialog 1)")
    (action_tile "cancel"       "(dismiss_dialog 0)")

  )

 
 (defun bn_image_do ( flag )
   (cond
     ((= flag T)
   	(mode_tile "rd_dwgno" 1)(mode_tile "rd_st_dwgno" 1)
   	(if (= (get_tile "rd_dwgno") "1") (progn (setq dtl_prop_type "rd_circle")
    					(set_tile "rd_circle" "1")))
	(if (= (get_tile "rd_st_dwgno") "1") (progn (setq rd_st_prop "rd_st_number")
    					(set_tile "rd_st_number" "1"))))
     (T (mode_tile "rd_dwgno" 0)(mode_tile "rd_st_dwgno" 0))
   )
   
  )
  (defun radio_gaga (/ tmpidx tmp)
    (setq tmpidx (get_tile "style_radio"))
    (cond 
      ((= tmpidx "rd_st_number")
       (set_tile "pop_textstyle" (itoa (setq tmp (get_index dtl:n_sty stnmlst))))
       (set_tile "ed_textsize" (rtos dtl:n_shg)) 
      )
      ((= tmpidx "rd_st_dwgno")
	(set_tile "pop_textstyle" (itoa (setq tmp (get_index dtl:d_sty stnmlst))))
       (set_tile "ed_textsize" (rtos dtl:d_shg))
       )
      ((= tmpidx "rd_st_title")
	(set_tile "pop_textstyle" (itoa (setq tmp (get_index dtl:t_sty stnmlst))))
       (set_tile "ed_textsize" (rtos dtl:t_shg))
       )
      ((= tmpidx "rd_st_scale")
	(set_tile "pop_textstyle" (itoa (setq tmp (get_index dtl:s_sty stnmlst))))
       (set_tile "ed_textsize" (rtos dtl:s_shg))
      ))
    (set_tile "text_image " (nth tmp slblist))     
  )

 
(defun dtl_DoubleClick? (index / splitchar)
 (setq L_index (atoi index))
 (if (= index preindex)
   (progn   
     (set_tile "ed_text" (cdr (nth (atoi index) @Type)))
     (setq preindex nil)
   )
   (setq preindex index) 
 )
)


  (defun getfsize (value tiles)
    (cond ((= tiles "ed_text_size") 
	      (set_tile "ed_text_size" (rtos (verify_d tiles value
						       (atof (get_tile "ed_text_size"))))))
	  ((= tiles "ed_diameter")
	   (setq dtl:rad (/ (verify_d tiles value dtl:rad) 2) ))
	  ((= tiles "ed_number")
	   (setq dtl:num (verify_d tiles value dtl:num)))

    ) )
 
  ;;
  (defun verify_d (tile value old-value / coord valid errmsg ci_coord)
    (setq valid nil errmsg "Invalid input value.")
    (if (setq coord (distof value))
      (progn
        (cond
          ((= tile "ed_number")
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
	    (if (>= coord 0)
              (setq valid T)
              (setq errmsg "Value must be positive or zero.")
            ))
        )
      )
      (setq valid nil)
    )
    (if valid
      (progn 
       (if (or (= errchk 0) (= tile last-tile))
          (set_tile "error" "")
        )
        (set_tile tile (if (= tile "ed_number")  (itoa ci_coord) (rtos coord)))
        (setq errchk 0)
        (setq last-tile tile)
        (if (= tile "ed_number") 
          ci_coord
          coord
        )
      )
      (progn
        (mode_tile tile 2)
        (set_tile "error" errmsg)
        (setq errchk 1)
        (setq last-tile tile)
        old-value
      )
    )
  )
  (defun dismiss_dialog (action)
    (if (= action 0)
      (done_dialog 0)
      (if (= (get_tile "error") "")
	(progn
	(setq dtl:text (get_tile "ed_text"))
	(setq dtl:sch (get_tile "ed_dwgtype"))
	(setq dtl:snum (atoi (get_tile "ed_dwgno")))
        (done_dialog action))
      )
    )
  )

 (defun get_style (/ idx rd_idx)   ;;; 수정 요
  (setq idx (atoi (get_tile "pop_textstyle")))
  (setq rd_idx (get_tile "style_radio"))
      (ci_image "text_image" (nth idx slblist))
      (set_tile "ed_ratio" (nth idx widlst))
   (cond ((= rd_idx "rd_st_number")
	  (setq dtl:n_sty (nth idx stnmlst)
	  dtl:n_shg (atof (get_tile "ed_textsize"))))
	 ((= rd_idx "rd_st_dwgno")
	  (setq dtl:d_sty (nth idx stnmlst)
	  dtl:d_shg (atof (get_tile "ed_textsize"))))
	 ((= rd_idx "rd_st_title")
	  (setq dtl:t_sty (nth idx stnmlst)
	  dtl:t_shg (atof (get_tile "ed_textsize"))))
	 ((= rd_idx "rd_st_scale")
	  (setq dtl:s_sty (nth idx stnmlst)
	  dtl:s_shg (atof (get_tile "ed_textsize")))))
 )  
) ; end wn2_init

(defun dtl_do ()
  (if (not (new_dialog "dd_dtl" dcl_id)) (exit))
  (set_tile_props)
  (set_action_tiles)
  (setq dialog-state (start_dialog))
  (if (= dialog-state 0)
   (setq reset_flag t)
  )
)

(defun dtl_return ()
  
  (setq dtl:cprop  old_cprop
        dtl:nprop  old_nprop
        dtl:dprop  old_dprop 
	dtl:tprop  old_tprop
	dtl:sprop  old_sprop 
      
  )
)


(defun dd_dtl (/
                      
           dcl_id           dialog-state     dismiss_dialog
           
           getfsize     old_num		old_typ           radio_gaga
           reset_flag	set_action_tiles set_tile_props   
                 
	   verify_d  
	   dtl_DrawImage
	   drawImage_dtl dtl:mark_chk_do dtl_DoubleClick? get_style)


  (setq old_cprop  dtl:cprop
        old_nprop  dtl:nprop
        old_dprop  dtl:dprop
        old_tprop  dtl:tprop
	old_sprop  dtl:sprop
  )

  (princ ".")
  (cond
     ((not (setq dcl_id (Load_dialog "Dwgtitle.dcl"))))   ; is .DLG file loaded?
     (t
        (ai_undo_push)
        (princ ".")
        (dtl_Draw_Image_X)
        (readf "Dwgtitle.dat" T)
        (dtl_init)                              ; everything okay, proceed.
        (princ ".")
        (dtl_do)
     )  
  )
  (if reset_flag
    (dtl_return)
    (dtl_set)
  )
  (if dcl_id (unload_dialog dcl_id))
)

;;;(if (null Loaded:CIMDTL)
;;;   (progn
;(readF "PropType.dat" "prop")  
(setq dtl:cprop (Prop_search "dtl" "circle"))
(setq dtl:nprop (Prop_search "dtl" "number"))
(setq dtl:dprop (Prop_search "dtl" "dwgno"))
(setq dtl:tprop (Prop_search "dtl" "title"))
(setq dtl:sprop (Prop_search "dtl" "scale"))
(setq dtl:prop '(dtl:cprop dtl:nprop dtl:dprop dtl:tprop dtl:sprop))
;(setq Loaded:CIMDTL T)
;;;   )
;;;)

(if (null dtl:cprop) (setq dtl:cprop (list "dtl" "circle" "DTL" "7" "CONTINUOUS" "1" "1")))
(if (null dtl:nprop) (setq dtl:nprop (list "dtl" "number" "DTL" "1" "CONTINUOUS" "0" "1")))
(if (null dtl:dprop) (setq dtl:dprop (list "dtl" "dwgno" "DTL" "1" "CONTINUOUS" "0" "1")))
(if (null dtl:tprop) (setq dtl:tprop (list "dtl" "title" "DTL" "1" "CONTINUOUS" "0" "1")))
(if (null dtl:sprop) (setq dtl:sprop (list "dtl" "scale" "DTL" "1" "CONTINUOUS" "0" "1")))

(if (null dtl_prop_type) (setq dtl_prop_type "rd_circle"))
(if (null dtl:opt) (setq dtl:opt "A"))

(if (null dtl:num) (setq dtl:num 1))
(if (null dtl:sch) (setq dtl:sch "A"))
(if (null dtl:snum) (setq dtl:snum 1))
(if (null dtl:text) (setq dtl:text ""))

(if (null dtl:t_sty) (setq dtl:t_sty "CIHD"))
(if (null dtl:t_shg) (setq dtl:t_shg 7))
(if (null dtl:n_sty) (setq dtl:n_sty "CIHD"))
(if (null dtl:n_shg) (setq dtl:n_shg 3.5))
(if (null dtl:d_sty) (setq dtl:d_sty "CIHS"))
(if (null dtl:d_shg) (setq dtl:d_shg 3.5))
(if (null dtl:s_sty) (setq dtl:s_sty "CIHS"))
(if (null dtl:s_shg) (setq dtl:s_shg 3))

(if (null dtl:rad) (setq dtl:rad (+ 2 dtl:t_shg)))

(if (null dtl:sty) 
  (cond
    ((findfile "WHGTXT.SHX")
     (setq dtl:sty "CIHD"
	   dtl:sts "CIHS"
     )
         
    )
    (T
      (setq dtl:sty "SIM"
            dtl:sts "SIM"
      )
    )
    
))

(defun C:CIMDTL() (m:dtl))

;단축키 관련 변수 정의 부분 -맨 뒤로..
(setq lfn19 1)
(princ)
