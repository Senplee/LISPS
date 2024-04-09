
;단축키 관련 변수 정의 부분 -맨 뒤로..
(defun cwe_Draw_Image_X( / )
(defun cwe_DrawImage (cwe_key !cwetype! / fcolor ccolor mcolor  cx cy dx dy)
  (setq fcolor (propcolor cwe:fprop))
  (setq ccolor (propcolor cwe:cprop))  
  (setq mcolor (propcolor cwe:mprop)) 
  
  
    (do_blank cwe_key 0)
    (start_image cwe_key)
    (setq cx (dimx_tile cwe_key)
	  cy (dimy_tile cwe_key)
	  dx (/ cx 30) 
	  dy (/ cy 20) )
     (drawCWEwinImage)
    (end_image)
)


(defun drawCWEwinImage(/  px py px1 px2 py1 py2 v h)

	(drawImage_box dx (* dy 2) (* dx 29) (* dy 17) fcolor)
	(if (/= cwe:VHF "flat") 
		(drawImage_box (* dx 2) (* dy 3) (* dx 27) (* dy 15) fcolor))
	
	(cond ((= cwe:VHF "vertical")
	        (setq h 0)
		(repeat 3 
			(setq px1 (+ (* dx 2) (* dx 7 h))
			      px2 (+ px1 (* dx 6)))
		  	(setq v 0)
			(repeat 3 
				(setq py (+ (* dy 6) (* dy 4 v)))
				(vector_image px1 py px2 py ccolor)
				(vector_image px1 (+ py dy) px2 (+ py dy) ccolor)
			  	(setq v (1+ v))
			)
			(vector_image px2 (* dy 3) px2 (* dy 18) mcolor)
			(vector_image (+ px2 dx) (* dy 3) (+ px2 dx) (* dy 18) mcolor)
		 	(setq h (1+ h))
		)
		(setq px1 (* dx 23) px2 (* dx 29))
		(setq v 0)
		(repeat 3 
			(setq py (+ (* dy 6) (* dy 4 v)))
			(vector_image px1 py px2 py ccolor)
			(vector_image px1 (+ py dy) px2 (+ py dy) ccolor)
		  	(setq v (1+ v))
		)
	       )
	      ((= cwe:VHF "horizon")
	        (setq v 0)
		(repeat 3 
		  (setq py1 (+ (* dy 3) (* dy 4 v))
			py2 (+ py1 (* dy 3)))
		        (setq h 0)
			(repeat 3 
				(setq px (+ (* dx 8) (* dx 7 h)))
				(vector_image px py1 px py2 mcolor)
				(vector_image (+ px dx) py1 (+ px dx) py2 mcolor)
			  	(setq h (1+ h))
			)
			(vector_image (* dx 2) py2 (* dx 29) py2 ccolor)
			(vector_image (* dx 2) (+ py2 dy) (* dx 29) (+ py2 dy) ccolor)
		  	(setq v (1+ v))
		)
		(setq py1 (* dy 15) py2 (* dy 18))
	        (setq h 0)
		(repeat 3  
			(setq px (+ (* dx 8) (* dx 7 h)))
			(vector_image px py1 px py2 mcolor)
			(vector_image (+ px dx) py1 (+ px dx) py2 mcolor)
		  	(setq h (1+ h))
		)
	       )
	      (T
	        (setq h 0)
		(repeat 4 
			(setq px (+ (* dx 2) (* dx 7 h)))
		  	(setq v 0)
			(repeat 4 
				(setq py (+ (* dy 3) (* dy 4 v)))
				(drawImage_box px py (* dx 6) (* dy 3) fcolor)
			  	(setq v (1+ v))
			)
		  (setq h (1+ h))
		  ))
	      )
)
)
  
(defun m:cwe (/
             ang      ang1     ang2     ang3     sc       pt1      pt2
             pt3      pt4      pt5      pt6      pt7      pt8      pt9
             pt10     pt11     pt12     pt13     pt14     pt15     pt16
             pt17     pt18     pt19     pt20     pt21     pt1x     pt1y
             pt2x     pt2y     pt3x     pt3y     pt4x     pt4y     pte
             strtpt   nextpt   uctr     cont     temp     tem      ptd
             
	     n  )
  
  
  (setq sc (getvar "dimscale"))
  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")

 (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n미서기창 + 고정창호 입면 그리기 명령 입니다.")

  (setq cont T temp T uctr 0)

  (while cont
    (cwe_m1)
    (if (and (= cwe:owid_chk "1") tem) (progn
			   (setq nextpt (polar strtpt cwe:anh cwe:wid))
			   (setq tem     nil
                                 ptd     T
                		 cwe:wid (distance strtpt nextpt)
                	         cwe:anh (angle strtpt nextpt)))
    (cwe_m2))
    (if (and (= cwe:ohig_chk "1") ptd) (progn
			   (setq cwe:anv (+ cwe:anh (/ pi 2)))	     
			   (setq pt4 (polar strtpt cwe:anv cwe:hgh))
			  (command "_.undo" "_m")
	    		  (setvar "osmode" 0)(setvar "blipmode" 0)
            		  (cwe_ex)
            		  (setq uctr (1+ uctr))
            		  (setq ptd nil temp T))
    (cwe_m3))
    ;;(cwe_m4)
  )

  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ)
)

(defun cwe_m1 ()
  (while temp
    (setvar "osmode" (+ 1 32 128))
    (setvar "blipmode" 1)
    (if (> uctr 0)
      (progn
        (princ (strcat "\nGap_size:" (rtos cwe:gap)

                       "\n창문 너비:"    (rtos cwe:wid)
                       "  창문 높이"   (rtos cwe:hgh)))
        (initget "/ Dialog Offset Undo")
        (setq strtpt (getpoint
          "\n>>> Dialog/Offset/Undo/<좌측 하단>: "))
      )
      (progn

        (initget "/ Dialog Ofcwet")
        (setq strtpt (getpoint
         "\n>>> Dialog/Offset/<좌측 하단>: "))
      )
    )
    (cond
      ((= strtpt "Dialog")
        (DD_cwe)
      )
      ((= strtpt "Ofcwet")
        (cim_ofs)
      )
      ((= strtpt "/")
        (cim_help "cwe")
      )
      ((= strtpt "Undo")
        (command "_.undo" "_b")
        (setq uctr (1- uctr))
      )
      ((null strtpt)
        (setq cont nil temp nil)
      )
      (T
        (setq temp nil tem T)
      )
    )
  )
)
 
(defun cwe_m2 ()
  (while tem
    (setvar "blipmode" 1)
    (setvar "snapbase" (list (car strtpt) (cadr strtpt)))
    (initget "/ Dialog Undo")
    (setq nextpt (getpoint strtpt (strcat
      "\n>>> Dialog/Undo/<width:"
      (rtos cwe:wid) " Angle:" (angtos cwe:anh) ">: ")))
    (setvar "blipmode" 0)
    
    (cond
      ((= nextpt "Dialog")
        (DD_cwe)
      )
      ((= nextpt "/")
        (cim_help "cwe")
      )
      ((= nextpt "Undo")
        (setq tem nil temp T)
      )
      ((null nextpt)
        (setq tem nil ptd T)
      )
      (T
          (setq tem     nil
                ptd     T
                cwe:wid (distance strtpt nextpt)
                cwe:anh (angle strtpt nextpt)
        )
      )
    )
  )
)

(defun cwe_m3 ()
  (while ptd
    (setvar "blipmode" 1)
    
    (initget "/ Dialog Undo")
    (setq pt3 (getpoint strtpt (strcat
      "\n>>> Dialog/Undo/<height:"
      (rtos cwe:hgh) " Angle:" (angtos cwe:anv) ">: ")))
    (setvar "blipmode" 0)
   
    (cond
   
      ((= pt3 "Dialog")
        (DD_cwe)
      )
      ((= pt3 "/")
        (cim_help "cwe")
      )
      ((= pt3 "Undo")
        (setq ptd nil tem T)
      )
      ((null pt3)
        (command "_.undo" "_m")
        (cwe_ex)
        (setq uctr (1+ uctr))
        (setq ptd nil temp T)
      )
      (T
	    (command "_.undo" "_m")
            (setq cwe:hgh (distance strtpt pt3)
                  cwe:anv (+ cwe:anh (/ pi 2))
            )
	    (cwe_ex)
            (setq ptd nil temp T)

      )
    )
  )
)

(defun cwe_ex (/ tmpgap)
 
  (setvar "osmode" 0)
  (setq tmpgap (if (= cwe:gap_chk "0") 0 cwe:gap)
        pt1  strtpt
        pt2	(polar pt1 cwe:anh cwe:wid)
        pt4	(polar pt1 cwe:anv cwe:hgh)
        pt3  (polar pt2 cwe:anv cwe:hgh) 
        ang  cwe:anh
        ang1 (angle pt2 pt1)
        ang2 cwe:anv
        ang3 (angle pt4 pt1)
        pt5  (polar pt1  ang  tmpgap)
        pt5  (polar pt5  ang2 tmpgap)
        pt6  (polar pt2  ang1 tmpgap)
        pt6  (polar pt6  ang2 tmpgap)
        pt7  (polar pt3  ang1 tmpgap)
        pt7  (polar pt7  ang3 tmpgap)
        pt8  (polar pt4  ang  tmpgap)
        pt8  (polar pt8  ang3 tmpgap)
        dw   (distance pt5 pt6)
        dh   (distance pt5 pt8)
        dx   (/ (- dw (* cwe:mwi (1- cwe:xnm)) (* 2 cwe:frw)) cwe:xnm)
        dy   (/ (- dh (* cwe:twi (1- cwe:ynm)) (* 2 cwe:frw)) cwe:ynm)
        pt9  (polar pt5 ang  cwe:frw)
        pt9  (polar pt9 ang2 cwe:frw)
        pt10 (polar pt6  ang1 cwe:frw)
        pt10 (polar pt10 ang2 cwe:frw)
        pt11 (polar pt7  ang1 cwe:frw)
        pt11 (polar pt11 ang3 cwe:frw)
        pt12 (polar pt8  ang  cwe:frw)
        pt12 (polar pt12 ang3 cwe:frw)
        pt1x (polar pt1 ang1 (* sc 5))
        pt1y (polar pt1 ang3 (* sc 5))
        pt2x (polar pt2 ang  (* sc 5))
        pt2y (polar pt2 ang3 (* sc 5))
        pt3x (polar pt3 ang  (* sc 5))
        pt3y (polar pt3 ang2 (* sc 5))
        pt4x (polar pt4 ang1 (* sc 5))
        pt4y (polar pt4 ang2 (* sc 5))
  )
 (if (and (/= cwe:gap 0) (/= cwe:gap_chk "0"))
    (progn
      (set_col_lin_lay cwe:gprop)
      (command "_.LINE" pt1x pt2x "")
      (command "_.LINE" pt2y pt3y "")
      (command "_.LINE" pt3x pt4x "")
      (command "_.LINE" pt4y pt1y "")
    )
  )
  (set_col_lin_lay cwe:fprop)
  (command "_.pline" pt5 pt6 pt7 pt8 "_C")
  (if (/= cwe:VHF "flat") (command "_.PLINE" pt9 pt10 pt11 pt12 "_C"))
  (setq pt9x pt9)
  (cond ((= cwe:VHF "flat")
	  (set_col_lin_lay cwe:fprop)
	  (repeat cwe:ynm
	    (repeat cwe:xnm
	      (setq pt10 (polar pt9  ang  dx)
	            pt11 (polar pt10 ang2 dy)
	            pt12 (polar pt11 ang1 dx)
	      )
	      (command "_.pline" pt9 pt10 pt11 pt12 "_C")
	      (setq pt9 (polar pt10 ang cwe:mwi))
	    )
	    (setq pt12 (polar pt12 ang1 (* (+ dx cwe:mwi) (1- cwe:xnm))))
	    (setq pt9  (polar pt12 ang2 cwe:twi))
	  ))
	((= cwe:VHF "vertical")
	  (set_col_lin_lay cwe:mprop)
	  (repeat (1- cwe:xnm)
	    (setq pt13 (polar pt9  ang dx)
	          pt14 (polar pt12 ang dx)
	          pt15 (polar pt13 ang cwe:mwi)
	          pt16 (polar pt14 ang cwe:mwi)
	    )
	    (command "_.line" pt13 pt14 "")
	    (command "_.line" pt15 pt16 "")
	    (setq pt9 pt15 pt12 pt16)
	  )
	  (set_col_lin_lay cwe:cprop)
	  (repeat (1- cwe:ynm)
	    (repeat cwe:xnm
	      (setq pt17 (polar pt9x ang2 dy)
	            pt18 (polar pt17 ang  dx)
	            pt19 (polar pt17 ang2 cwe:twi)
	            pt20 (polar pt19 ang  dx)
	      )
	      (command "_.line" pt17 pt18 "")
	      (command "_.line" pt19 pt20 "")
	      (setq pt9x (polar pt9x ang (+ dx cwe:mwi)))
	    )
	    (setq pt9x (polar pt19 ang1 (* (+ dx cwe:mwi) (1- cwe:xnm))))
	  ))
	((= cwe:VHF "horizon")
	  (set_col_lin_lay cwe:cprop)
	  (repeat (1- cwe:ynm)
	    (setq pt13 (polar pt9  ang2 dy)
	          pt14 (polar pt10 ang2 dy)
	          pt15 (polar pt13 ang2 cwe:twi)
	          pt16 (polar pt14 ang2 cwe:twi)
	    )
	    (command "_.line" pt13 pt14 "")
	    (command "_.line" pt15 pt16 "")
	    (setq pt9 pt15 pt10 pt16)
	  )
	  (set_col_lin_lay cwe:mprop)
	  (repeat (1- cwe:xnm)
	    (repeat cwe:ynm
	      (setq pt17 (polar pt9x ang dx)
	            pt18 (polar pt17 ang2 dy)
	            pt19 (polar pt17 ang cwe:mwi)
	            pt20 (polar pt19 ang2 dy)
	      )
	      (command "_.line" pt17 pt18 "")
	      (command "_.line" pt19 pt20 "")
	      (setq pt9x (polar pt9x ang2 (+ dy cwe:twi)))
	    )
	    (setq pt9x (polar pt19 ang3 (* (+ dy cwe:twi) (1- cwe:xnm))))
	  )
	 )
 )
	 
  (princ (strcat "\nMullion_distance:" (rtos (+ dx cwe:mwi))
                 "  Transom_distance:" (rtos (+ dy cwe:twi))))
)



;;-----------------------------------------------------



(defun cwe_init ()

  (defun cwe_set (/ chnaged?)
    (PROP_SAVE cwe:prop)
  )

  ;;
  ;; Common properties for all entities
  ;;
 
  
  (defun set_tile_props ()
    
    (set_tile "error" "")
    (set_tile cwe_prop_type "1")                ;; prop radio
    (@get_eval_prop cwe_prop_type cwe:prop)
    
    (set_tile cwe:VHF "1")
    (s_radio_do)
    
    (set_tile "tx_type" C_cwe_type)
    
    (set_tile "tg_gap_size" cwe:gap_chk)
    (mode_tile "ed_gap_size" (if (= cwe:gap_chk"1") 0 1)) 
    (set_tile "tg_opn_width" cwe:owid_chk)
    (mode_tile "ed_opn_width" (if (= cwe:owid_chk"1") 0 1)) 
    (set_tile "tg_opn_height" cwe:ohig_chk)
    (mode_tile "ed_opn_height" (if (= cwe:ohig_chk"1") 0 1)) 

    (set_tile "ed_gap_size" (rtos cwe:gap))
    (set_tile "f_size" (rtos cwe:frw))
    (set_tile "c_size" (rtos cwe:frwc))
    (set_tile "size_1" (rtos cwe:mwi))
    (set_tile "size_2" (rtos cwe:twi))
    
    (set_tile "num_1" (itoa cwe:xnm))
    (set_tile "num_2" (itoa cwe:ynm))
   
    (set_tile "ed_opn_width" (rtos cwe:wid))
    (set_tile "ed_opn_height" (rtos cwe:hgh))

    (cwe_DrawImage "elev_image" T)
  )

 
  
  (defun set_action_tiles ()

    (action_tile "b_name"       "(@getlayer)(cwe_DrawImage \"elev_image\" T)")    
    (action_tile "b_color"      "(@getcolor)(cwe_DrawImage \"elev_image\" T)")
    (action_tile "color_image"  "(@getcolor)(cwe_DrawImage \"elev_image\" T)")
    (action_tile "b_line"       "(@getlin)(cwe_DrawImage \"elev_image\" T)")
    (action_tile "c_bylayer"    "(@bylayer_do T)(cwe_DrawImage \"elev_image\" T)")
    (action_tile "t_bylayer"    "(@bylayer_do nil)(cwe_DrawImage \"elev_image\" T)")

    (action_tile "bn_type"       "(ttest)")
    
    (action_tile "prop_radio" "(setq cwe_prop_type $Value)(@get_eval_prop cwe_prop_type cwe:prop)(cwe_DrawImage \"elev_image\" T)")
    
    (action_tile "vertical"       "(setq cwe:vhf \"vertical\")(s_radio_do) (cwe_DrawImage \"elev_image\" T)")
    (action_tile "horizon"       "(setq cwe:vhf \"horizon\")(s_radio_do) (cwe_DrawImage \"elev_image\" T)")
    (action_tile "flat"       "(setq cwe:vhf \"flat\")(s_radio_do) (cwe_DrawImage \"elev_image\" T)")
        
    (action_tile "tg_gap_size" 	"(radio_gaga \"gap\")")
    (action_tile "tg_opn_width" "(radio_gaga \"width\")")
    (action_tile "tg_opn_height" "(radio_gaga \"height\")")

    (action_tile "ed_gap_size"  "(getfsize $value \"ed_gap_size\")")
    (action_tile "f_size"       "(getfsize $value \"f_size\")")
    
    (action_tile "size_1"       "(getfsize $value \"size_1\")")
    (action_tile "size_2"       "(getfsize $value \"size_2\")")
    (action_tile "num_1"       "(getfsize $value \"num_1\")")
    (action_tile "num_2"       "(getfsize $value \"num_2\")")
    
    (action_tile "ed_opn_width"       "(getfsize $value \"ed_opn_width\" )")
    (action_tile "ed_opn_height"       "(getfsize $value \"ed_opn_height\")")
    
    (action_tile "accept"       "(dismiss_dialog 1)")
    (action_tile "cancel"       "(dismiss_dialog 0)")
    (action_tile "help"         "(cim_help \"WN2\")")
    (action_tile "bn_type_save"   "(readF \"CweType.dat\" nil)(ValueToList)(writeF \"CweType.dat\" nil)")
  )

  (defun cwe:mark_chk_do ()
    (setq cwe:mark_chk (get_tile "opn_mark"))
;;;    (if (= cwe:mark_chk "1") (progn (mode_tile "a_type" 0) (mode_tile "b_type" 0))
;;;                         (progn (mode_tile "a_type" 1) (mode_tile "b_type" 1)))
    )
  (defun s_radio_do()
    (cond ((= cwe:VHF "flat") (mode_tile "c_radio" 1)(mode_tile "m_radio" 1)
	   (if (or (= cwe_prop_type "c_radio")(= cwe_prop_type "m_radio"))
	     (progn (setq cwe_prop_type "f_radio") (set_tile cwe_prop_type "1")
	       (prop_radio_do))))
	  (T (mode_tile "c_radio" 0)(mode_tile "m_radio" 0))
    )
  )
  
  (defun radio_gaga (pushed)
    
    (cond 
      ((= pushed "gap")
        (setq cwe:gap_chk (get_tile "tg_gap_size"))(mode_tile "ed_gap_size" (if (= cwe:gap_chk "1") 0 1))
      )
      ((= pushed "width")
	(setq cwe:owid_chk (get_tile "tg_opn_width"))(mode_tile "ed_opn_width" (if (= cwe:owid_chk "1") 0 1))
      )
      ((= pushed "height")
	(setq cwe:ohig_chk (get_tile "tg_opn_height"))(mode_tile "ed_opn_height" (if (= cwe:ohig_chk "1") 0 1))
      ))
    
  )


  (defun getfsize (value tiles)
    (cond ((= tiles "ed_gap_size") 
	      (setq cwe:gap (verify_d tiles value cwe:gap)))  
	  ((= tiles "f_size")
	   (setq cwe:frw (verify_d tiles value cwe:frw)))
	  ((= tiles "size_1")
	   (setq cwe:mwi (verify_d tiles value cwe:mwi)))
	  ((= tiles "size_2")
	   (setq cwe:twi (verify_d tiles value cwe:twi)))
	  ((= tiles "num_1")
	   (setq cwe:xnm (verify_d tiles value cwe:xnm)))
	  ((= tiles "num_2")
	   (setq cwe:ynm (verify_d tiles value cwe:ynm)))
	  ((= tiles "ed_opn_width")
	   (setq cwe:wid (verify_d tiles value cwe:wid)))
	  ((= tiles "ed_opn_height")
	   (setq cwe:hgh (verify_d tiles value cwe:hgh))) 
    ) )
 
  ;;
  (defun verify_d (tile value old-value / coord valid errmsg ci_coord)
    (setq valid nil errmsg "Invalid input value.")
    (if (setq coord (distof value))
      (progn
        (cond
          ((or (= tile "num_1") (= tile "num_2"))
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
        (set_tile tile (if (or (= tile "num_1") (= tile "num_2")) (itoa ci_coord) (rtos coord)))
        (setq errchk 0)
        (setq last-tile tile)
        (if (or (= tile "num_1") (= tile "num_2"))
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
        (done_dialog action)
      )
    )
    
  )
;list _ box handle
(defun ttest (/ old_cwe_type)
 (readF "CweType.dat" nil)
 (setq  old_cwe_type C_cwe_type)
 (setq L_index (Find_index old_cwe_type))
    (progn
      (setq zin_old (getvar "dimzin"))
      (setvar "dimzin" 8)
      (if (not (new_dialog "set_cwintype_name" dcl_id)) (exit)) 
      (set_tile "title" "List of Entities")
      
      (list_view)
      (Set_tileS)
      (action_Tiles)
      (start_dialog)
      (setvar "dimzin" zin_old)
     ))

(defun set_tileS ()
 (if (= L_index nil) (setq L_index 0 ))
 (setq C_cwe_type (nth 0 (cdr (nth L_index @Type))))  
 (set_tile "list_type" (rtos L_index)) 
 (set_tile "current_type" old_cwe_type)
 (set_tile "ed_type_name" C_cwe_type) 
)
 
(defun action_Tiles ()
 (action_tile "list_type" "(setq C_cwe_type (Field_match \"타입명\" (setq L_index (atoi $value))))(set_tileS)")
 (action_tile "accept" "(qqqq)")
 (action_tile "cancel" "(setq C_cwe_type old_cwe_type)")
 (action_tile "eb_del_type" "(deleteIdx C_cwe_type)(set_tileS)")
 (action_tile "eb_ren_type" "(renameIdx C_cwe_type)(set_tileS)")
 (action_tile "eb_new_type" "(newIdx C_cwe_type)(set_tileS)")
)
(defun qqqq()
  (Set_cwe_Value)(writeF "CweType.dat" nil)(done_dialog 1)(set_tile_props)
)
;list _ box handle

) ; end wn2_init

(defun cwe_do ()
  (if (not (new_dialog "dd_cwin" dcl_id)) (exit))
  (set_tile_props)
  (set_action_tiles)
  (setq dialog-state (start_dialog))
  (if (= dialog-state 0)
   (setq reset_flag t)
  )
)

(defun cwe_return ()
  
  (setq cwe:fprop  old_fprop
        cwe:cprop  old_cprop
        cwe:mprop  old_mprop
	cwe:gprop  old_gprop
      ;  cwe:typ  old_typ
        cwe:numc  old_num
        cwe:num  old_num2 
  )
)


(defun dd_cwe (/           
           ci_mode          dcl_id           dialog-state     dismiss_dialog
           getfsize     old_num		old_typ           radio_gaga
           reset_flag	set_action_tiles set_tile_props   sortlist
           action_Tiles  qqqq   ttest   set_tileS   verify_d  ValueToList
	   cwe_DrawImage
	   drawCWEwinImage  s_radio_do	)

(defun ValueToList(/ tmptype tmplist tmm newlist)
 
  (setq tmplist (nth L_index @type))
  
  (setq tmptype (strcat (strcase (substr cwe:vhf 1 1)) (substr cwe:vhf 2)))
  (setq tmm (list C_cwe_type tmptype (rtos cwe:wid) (rtos cwe:hgh) (itoa cwe:xnm) (itoa cwe:ynm) 
		  (rtos cwe:mwi) (rtos cwe:twi) (rtos cwe:frw)
		  (rtos cwe:gap) cwe:gap_chk cwe:owid_chk cwe:ohig_chk ))
  (setq newlist (cons (1+ L_index) tmm))
  (setq @type (subst newlist tmplist @Type) )
)
  (setvar "cmdecho" (cond (  (or (not *debug*) (zerop *debug*)) 0)
                          (t 1)))

  (setq old_fprop  cwe:fprop
        old_cprop  cwe:cprop
        old_mprop  cwe:mprop
        old_gprop  cwe:gprop
        old_num  cwe:numc
	old_num2  cwe:num
  )

  (princ ".")
  (cond
     (  (not (setq dcl_id (Load_dialog "WINELEV.dcl"))))   ; is .DLG file loaded?

     (t (ai_undo_push)
        (princ ".")
        (cwe_Draw_Image_X)
        (cwe_init)                              ; everything okay, proceed.
        (princ ".")
        (cwe_do)
     )
  )
  (if reset_flag
    (cwe_return)
    (cwe_set)
  )
  (if dcl_id (unload_dialog dcl_id))
)


(defun Set_cwe_Value(/ tnnp ttmpp1)

  
  (setq cwe:VHF (strcase (Field_match "커튼월타입" L_index) T))
  (setq cwe:wid (atof (Field_match "width" L_index) ))
  (setq cwe:hgh (atof (Field_match "height" L_index)))
  (setq cwe:xnm (atoi (Field_match "num_x" L_index)))
  (setq cwe:ynm (atoi (Field_match "num_y" L_index))) 
  (setq cwe:gap (atof (Field_match "gap_sizes" L_index)))
  (setq cwe:frw (atof (Field_match "frame_size" L_index)))
  
  (setq cwe:mwi (atof (Field_match "mullion_size" L_index)))
  (setq cwe:twi (atof (Field_match "transom_size" L_index)))
  (setq cwe:gap_chk  (Field_match "gap_chk" L_index))
  (setq cwe:owid_chk (Field_match "opnwid_chk" L_index))
  (setq cwe:ohig_chk (Field_match "opnhig_chk" L_index))
  
)
(if (null C_cwe_type)
   (progn
   
   (setq cwe:fprop  (Prop_search "cwe" "frame"))
   (setq cwe:cprop  (Prop_search "cwe" "mullion"))
   (setq cwe:mprop  (Prop_search "cwe" "transom"))
   (setq cwe:gprop  (Prop_search "cwe" "openline"))
   (setq cwe:prop '(cwe:fprop cwe:cprop cwe:mprop cwe:gprop))
   (readF "CweType.dat" nil) (setq L_index 0)
   (setq C_cwe_type (nth 0 (cdr (nth L_index @Type))))
   (Set_cwe_Value)
)) 


(if (null cwe:gap) (setq cwe:gap window_gap))
(if (null cwe:wid) (setq cwe:wid 2400))
(if (null cwe:anh) (setq cwe:anh 0))
(if (null cwe:anv) (setq cwe:anv (/ pi 2)))
(if (null cwe:hgh) (setq cwe:hgh 1800))
(if (null cwe:frwc) (setq cwe:frwc 50))

(if (null cwe:fprop) (setq cwe:fprop (list "cwe" "frame" "WINELEV" "6" "CONTINUOUS" "1" "1")))
(if (null cwe:cprop) (setq cwe:cprop (list "cwe" "mullion" "WINELEV" "6" "CONTINUOUS" "1" "1")))
(if (null cwe:mprop) (setq cwe:mprop (list "cwe" "transom" "WINELEV" "6" "CONTINUOUS" "1" "1")))
(if (null cwe:gprop) (setq cwe:gprop (list "cwe" "openline" "WINELEV" "6" "CONTINUOUS" "1" "1")))

(if (null cwe_prop_type) (setq cwe_prop_type "rd_frame"))

(if (null cwe:gap_chk) (setq cwe:gap_chk "0"))
(if (null cwe:owid_chk) (setq cwe:owid_chk "1"))
(if (null cwe:ohig_chk) (setq cwe:ohig_chk "1"))

(if (null cwe:frw) (setq cwe:frw 50))
(if (null cwe:mwi) (setq cwe:mwi 50))
(if (null cwe:twi) (setq cwe:twi 50))
(if (null cwe:VHF) (setq cwe:VHF "flat"))
(if (null cwe:xnm) (setq cwe:xnm 2))
(if (null cwe:ynm) (setq cwe:ynm 2))

(defun C:cimcwe () (m:cwe))
(setq lfn34 1)
(princ)
