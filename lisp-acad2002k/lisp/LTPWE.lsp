
;단축키 관련 변수 정의 부분 -맨 뒤로..
(defun pwe_Draw_Image_X( / )
(defun pwe_DrawImage (pwe_key !pwetype! / fcolor ccolor mcolor  cx cy ox oy dx dy x1 x2 x3 y1 y2)
  (setq fcolor (propcolor pwe:fprop))
  (setq ccolor (propcolor pwe:cprop))  
  (setq mcolor (propcolor pwe:mprop)) 
  ;(setq gcolor (propcolor pwe:gprop))
  
    (do_blank pwe_key 0)
    (start_image pwe_key)	  
    (setq cx (dimx_tile pwe_key)
	  cy (dimy_tile pwe_key)
	  dx (/ cx 30) 
	  dy (/ cy 20) 
;	ox = cx / 60 oy = cy / 40
	  x1 dx x2 (* dx 2) x3 (* dx 16) y1 (* dy 2) y2 (* dy 3))

;;;	(if (= pwe:gap_chk "1")
;;;		(drawImage_box ox oy * 3 ox * 60 oy * 34 ep->wes.std.color))
	(drawImage_box x1 y1 (* dx 29) (* dy 16) fcolor)
	(drawImage_prj x2 y2 dx dy)
	(drawImage_prj x3 y2 dx dy)
    (end_image)
)


(defun drawImage_prj(xp yp dx dy / x1 x2 x3 x4 x5 x6 x7 y1 y2 y3 y4)
      (setq 
	x1 (+ xp dx) x2 (+ xp (* dx 3)) x3 (+ xp (* dx 6)) x4 (+ xp (* dx 7))
	x5 (+ xp (* dx 8)) x6 (+ xp (* dx 10)) x7 (+ xp (* dx 13))
	y1 (* dy 11) y2 (* dy 12) y3 (* dy 13) y4 (* dy 17))
  
	(drawImage_box xp yp (* dx 13) (* dy 8) fcolor)
	(drawImage_box xp y2 (* dx 6) (* dy 5) fcolor)
	(drawImage_box x4 y2 (* dx 6) (* dy 5) fcolor)
	(drawImage_box x1 y3 (* dx 4) (* dy 3) ccolor)
	(drawImage_box x5 y3 (* dx 4) (* dy 3) ccolor)
	(if (= pwe:mark_chk "1")
		(if (= prj:typ "a") (progn
			(vector_image xp y2 x2 y4 mcolor)
			(vector_image x2 y4 x3 y2 mcolor)
			(vector_image x4 y2 x6 y4 mcolor)
			(vector_image x6 y4 x7 y2 mcolor))
		(progn
			(vector_image xp y4 x2 y2 mcolor)
			(vector_image x2 y2 x3 y4 mcolor)
			(vector_image x4 y4 x6 y2 mcolor)
			(vector_image x6 y2 x7 y4 mcolor)
		))
	)
)
)
  
(defun m:prj (/
             ang      ang1     ang2     ang3     sc       pt1      pt2
             pt3      pt4      pt5      pt6      pt7      pt8      pt9
             pt10     pt11     pt12     pt13     pt14     pt15     pt16
             pt17     pt18     pt19     pt20     pt21     pt1x     pt1y
             pt2x     pt2y     pt3x     pt3y     pt4x     pt4y     pte
             strtpt   nextpt   uctr     cont     temp     tem      ptd
             ;prj_ola  prj_oco  prj_err  prj_oer  prj_oli bmode omode 
	     n  )

  (setq sc     (getvar "dimscale"))
  ;;
  ;; Internal error handler defined locally
  ;;
  (ai_err_on) 
  (ai_undo_on)
  (command "_.undo" "_group")

 (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n미들창 + 고정창 입면 그리기 명령 입니다.")

  (setq cont T temp T uctr 0)

  (while cont
    (prj_m1)
    (if (and (= pwe:owid_chk "1") tem) (progn
			   (setq nextpt (polar strtpt prj:anh prj:wid))
			   (setq tem     nil
                                 ptd     T
                		 prj:wid (distance strtpt nextpt)
                	         prj:anh (angle strtpt nextpt)))
    (prj_m2))
    (if (and (= pwe:ohig_chk "1") ptd) (progn
			   (setq prj:anv (+ prj:anh (/ pi 2)))	     
			   (setq pt4 (polar strtpt prj:anv prj:hgh))
			  (command "_.undo" "_m")
	    		  (setvar "osmode" 0)(setvar "blipmode" 0)
            		  (prj_ex)
            		  (setq uctr (1+ uctr))
            		  (setq ptd nil temp T))
    (prj_m3))
    ;;(prj_m4)
  )


  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ)
)

(defun prj_m1 ()
  (while temp
    (setvar "osmode" (+ 1 32 128))
    (setvar "blipmode" 1)
    (if (> uctr 0)
      (progn
        (princ (strcat "\nGap_size:" (rtos prj:gap)
                       "  미들창개수" (itoa prj:num)
                       "  미들창높이:" (rtos prj:phg)
                       ;"  Linetype:" prj:lin
                       "\n창문 너비:"    (rtos prj:wid)
                       "  창문 높이"   (rtos prj:hgh)))
        (initget "/ Dialog Offset Undo")
        (setq strtpt (getpoint
          "\n>>> Dialog/Offset/Undo/<좌측 하단>: "))
      )
      (progn
        (princ (strcat "\n미들창개수" (itoa prj:num)
		       "  미들창높이:" (rtos prj:phg)
		       "  고정창개수:" (itoa prj:numc)
                       ))
        (initget "/ Dialog Offset")
        (setq strtpt (getpoint
         "\n>>> Dialog/Offset/<좌측 하단>: "))
      )
    )
    (cond
      ((= strtpt "Dialog")
        (DD_PWE)
      )
      ((= strtpt "Offset")
        (cim_ofs)
      )
      ((= strtpt "/")
        (cim_help "PRJ")
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

(defun prj_m2 ()
  (while tem
    (setvar "blipmode" 1)
    (setvar "snapbase" (list (car strtpt) (cadr strtpt)))
    (initget "/ Dialog Undo")
    (setq nextpt (getpoint strtpt (strcat
      "\n>>> Dialog/Undo/<width:"
      (rtos prj:wid) " Angle:" (angtos prj:anh) ">: ")))
    (setvar "blipmode" 0)
    
    (cond
      ((= nextpt "Dialog")
        (DD_PWE)
      )
      ((= nextpt "/")
        (cim_help "PRJ")
      )
      ((= nextpt "Undo")
        (setq tem nil temp T)
      )
      ((null nextpt)
        (setq tem nil ptd T)
      )
      (T
        (if (< (distance strtpt nextpt) (* prj:num 300))
          (alert (strcat "Insufficient width -- Value is not less than"
                   (rtos (* prj:num 300))))
          (setq tem     nil
                ptd     T
                prj:wid (distance strtpt nextpt)
                prj:anh (angle strtpt nextpt)
          )
        )
      )
    )
  )
)

(defun prj_m3 ()
  (while ptd
    (setvar "blipmode" 1)
    
    (initget "/ Dialog Undo")
    (setq pt3 (getpoint strtpt (strcat
      "\n>>> Dialog/Undo/<height:"
      (rtos prj:hgh) " Angle:" (angtos prj:anv) ">: ")))
    (setvar "blipmode" 0)
   
    (cond
   
      ((= pt3 "Dialog")
        (DD_PWE)
      )
      ((= pt3 "/")
        (cim_help "PRJ")
      )
      ((= pt3 "Undo")
        (setq ptd nil tem T)
      )
      ((null pt3)
        (command "_.undo" "_m")
        (prj_ex)
        (setq uctr (1+ uctr))
        (setq ptd nil temp T)
      )
      (T
        (if (< (distance strtpt pt3) 600)
          (alert "Insufficient height -- Value is not less than 600")
          (progn
	    (command "_.undo" "_m")
            (setq prj:hgh (distance strtpt pt3)
                  prj:anv (+ prj:anh (/ pi 2))
            )
	    (prj_ex)
            (setq ptd nil temp T)
	    
          )
        )
      )
    )
  )
)

(defun prj_ex (/ tmpgap)
  (setvar "osmode" 0)
  (setq tmpgap (if (= pwe:gap_chk "0") 0 prj:gap)
    	pt1  strtpt
        pt2
               (polar pt1 prj:anh prj:wid)
        pt4
               (polar pt1 prj:anv prj:hgh)
        pt3  (polar pt2 prj:anv prj:hgh) 
        ang  prj:anh
        ang1 (angle pt2 pt1)
        ang2 prj:anv
        ang3 (angle pt4 pt1)
        pt5  (polar pt1  ang  tmpgap)
        pt5  (polar pt5  ang2 tmpgap)
        pt6  (polar pt2  ang1 tmpgap)
        pt6  (polar pt6  ang2 tmpgap)
        pt7  (polar pt3  ang1 tmpgap)
        pt7  (polar pt7  ang3 tmpgap)
        pt8  (polar pt4  ang  tmpgap)
        pt8  (polar pt8  ang3 tmpgap)
       
  )
  (if (and (/= prj:gap 0) (/= pwe:gap_chk "0"))
    (progn
      (setq pt1x (polar pt1 ang1 (* sc 5))
            pt1y (polar pt1 ang3 (* sc 5))
            pt2x (polar pt2 ang  (* sc 5))
            pt2y (polar pt2 ang3 (* sc 5))
            pt3x (polar pt3 ang  (* sc 5))
            pt3y (polar pt3 ang2 (* sc 5))
            pt4x (polar pt4 ang1 (* sc 5))
            pt4y (polar pt4 ang2 (* sc 5))
      )
;;;      (command "_.layer" "_s" "CEN" "")
      (set_col_lin_lay pwe:gprop)
      (command "_.LINE" pt1x pt2x "")
      (command "_.LINE" pt2y pt3y "")
      (command "_.LINE" pt3x pt4x "")
      (command "_.LINE" pt4y pt1y "")
;;;      (command "_.layer" "_s" prj:lay "")
    )
  )
  (set_col_lin_lay pwe:fprop)
  (command "_.pline" pt5 pt6 pt7 pt8 "_C")
  
;; prj:numc
  (setq n 0)
  (repeat (* prj:num prj:numc)
    (if (= (rem n prj:num) 0)
    (progn
    (setq  pt9  (polar pt5  ang  prj:frw)
        pt9  (polar pt9  ang2 (+ (- prj:phg tmpgap ) (/ prj:frw 2) ))
        pt10 (polar pt9  ang  (/ (- prj:wid (* prj:frw 2) (* tmpgap 2) (* prj:frw (1- prj:numc))) prj:numc))  
        pt11 (polar pt10  ang2 (- prj:hgh prj:phg (* prj:frw 1.5)))
        pt12 (polar pt9  ang2 (- prj:hgh prj:phg (* prj:frw 1.5))))
    (set_col_lin_lay pwe:fprop)
    (command "_.pline" pt9 pt10 pt11 pt12 "_C")
    ))
    
    (setq pt13 (polar pt5  ang  prj:frw)
          pt13 (polar pt13 ang2 prj:frw)
          pt14 (polar pt13 ang
                 (/ (- prj:wid (* prj:frw 2) (* tmpgap 2) (* prj:frw (1- (* prj:num prj:numc)))) (* prj:num prj:numc))
               )
          pt15 (polar pt14 ang2 (- prj:phg tmpgap (* prj:frw 1.5)))
          pt16 (polar pt13 ang2 (- prj:phg tmpgap (* prj:frw 1.5)))
          pt17 (polar pt13 ang  (* prj:frw 0.6))
          pt17 (polar pt17 ang2 (* prj:frw 0.6))
          pt18 (polar pt14 ang1 (* prj:frw 0.6))
          pt18 (polar pt18 ang2 (* prj:frw 0.6))
          pt19 (polar pt15 ang1 (* prj:frw 0.6))
          pt19 (polar pt19 ang3 (* prj:frw 0.6))
          pt20 (polar pt16 ang  (* prj:frw 0.6))
          pt20 (polar pt20 ang3 (* prj:frw 0.6))
          pt21 (polar pt17 ang (/ (distance pt17 pt18) 2))
	  pt22 (polar pt20 ang (/ (distance pt19 pt20) 2))
    )
    (set_col_lin_lay pwe:fprop)
    (command "_.pline" pt13 pt14 pt15 pt16 "_C")
    (set_col_lin_lay pwe:cprop)
    (command "_.pline" pt17 pt18 pt19 pt20 "_C")

    (if (= pwe:mark_chk "1")(progn
    (set_col_lin_lay pwe:mprop)
    (if (= prj:typ "a")
    (command "_.pline" pt20 pt21 pt19 "") 
    (command "_.pline" pt17 pt22 pt18 "") )))
    
    (setq pt5 (polar pt14 ang3 prj:frw))
    (setq n (1+ n))
  )
)

;;-----------------------------------------------------



(defun pwe_init ()

  (defun pwe_set (/ chnaged?)
    (PROP_SAVE pwe:prop)
  )

  ;;
  ;; Common properties for all entities
  ;;
 
  
  (defun set_tile_props ()
    
    (set_tile "error" "")
    (set_tile pwe_prop_type "1")                ;; prop radio
    
    (@get_eval_prop pwe_prop_type pwe:prop)
    (set_tile "tx_type" C_pwe_type)
    (set_tile (strcat prj:typ "_type") "1")
    (set_tile "opn_mark" pwe:mark_chk)
    (set_tile "tg_gap_size" pwe:gap_chk)
    (mode_tile "ed_gap_size" (if (= pwe:gap_chk"1") 0 1)) 
    (set_tile "tg_opn_width" pwe:owid_chk)
    (mode_tile "ed_opn_width" (if (= pwe:owid_chk"1") 0 1)) 
    (set_tile "tg_opn_height" pwe:ohig_chk)
    (mode_tile "ed_opn_height" (if (= pwe:ohig_chk"1") 0 1)) 

    (set_tile "ed_gap_size" (rtos prj:gap))
    (set_tile "f_size" (rtos prj:frw))
    ;(set_tile "c_size" (rtos c_size))
    (set_tile "num_1" (itoa prj:numc))
    (set_tile "num_2" (itoa prj:num))
    (set_tile "hght_2" (rtos prj:phg))
    (set_tile "ed_opn_width" (rtos prj:wid))
    (set_tile "ed_opn_height" (rtos prj:hgh))

    (pwe_DrawImage "elev_image" T)
  )

   
  (defun set_action_tiles ()

    (action_tile "b_name"       "(@getlayer)(pwe_DrawImage \"elev_image\" T)")    
    (action_tile "b_color"      "(@getcolor)(pwe_DrawImage \"elev_image\" T)")
    (action_tile "color_image"  "(@getcolor)(pwe_DrawImage \"elev_image\" T)")
    (action_tile "b_line"       "(@getlin)(pwe_DrawImage \"elev_image\" T)")
    (action_tile "c_bylayer"    "(@bylayer_do T)(pwe_DrawImage \"elev_image\" T)")
    (action_tile "t_bylayer"    "(@bylayer_do nil)(pwe_DrawImage \"elev_image\" T)")

    (action_tile "bn_type"       "(ttest)")
    
    (action_tile "prop_radio" "(setq pwe_prop_type $Value)(@get_eval_prop pwe_prop_type pwe:prop)(pwe_DrawImage \"elev_image\" T)")

    (action_tile "a_type"       "(setq prj:typ \"a\") (pwe_DrawImage \"elev_image\" T)")
    (action_tile "b_type"       "(setq prj:typ \"b\") (pwe_DrawImage \"elev_image\" T)")
    (action_tile "opn_mark" 	"(pwe:mark_chk_do)(pwe_DrawImage \"elev_image\" T)")
    (action_tile "tg_gap_size" 	"(radio_gaga \"gap\")")
    (action_tile "tg_opn_width" "(radio_gaga \"width\")")
    (action_tile "tg_opn_height" "(radio_gaga \"height\")")

    (action_tile "ed_gap_size"  "(getfsize $value \"ed_gap_size\")")
    (action_tile "f_size"       "(getfsize $value \"f_size\")")
    ;(action_tile "c_size"       "(getfsize $value \"c_size\")")
    (action_tile "num_1"       "(getfsize $value \"num_1\")")
    (action_tile "num_2"       "(getfsize $value \"num_2\")")
    (action_tile "hght_2"       "(getfsize $value \"hght_2\")")
    
    (action_tile "ed_opn_width"       "(getfsize $value \"ed_opn_width\" )")
    (action_tile "ed_opn_height"       "(getfsize $value \"ed_opn_height\")")
    
    (action_tile "accept"       "(dismiss_dialog 1)")
    (action_tile "cancel"       "(dismiss_dialog 0)")
    (action_tile "help"         "(cim_help \"WN2\")")
    (action_tile "bn_type_save"   "(readF \"PweType.dat\" nil)(ValueToList)(writeF \"PweType.dat\" nil)")
  )

  (defun pwe:mark_chk_do ()
    (setq pwe:mark_chk (get_tile "opn_mark"))
    (if (= pwe:mark_chk "1") (progn (mode_tile "a_type" 0) (mode_tile "b_type" 0))
                         (progn (mode_tile "a_type" 1) (mode_tile "b_type" 1)))
    )
  (defun radio_gaga (pushed)
    
    (cond 
      ((= pushed "gap")
        (setq pwe:gap_chk (get_tile "tg_gap_size"))(mode_tile "ed_gap_size" (if (= pwe:gap_chk "1") 0 1))
      )
      ((= pushed "width")
	(setq pwe:owid_chk (get_tile "tg_opn_width"))(mode_tile "ed_opn_width" (if (= pwe:owid_chk "1") 0 1))
      )
      ((= pushed "height")
	(setq pwe:ohig_chk (get_tile "tg_opn_height"))(mode_tile "ed_opn_height" (if (= pwe:ohig_chk "1") 0 1))
      ))
    
  )
 
  (defun getfsize (value tiles)
    (cond ((= tiles "ed_gap_size") 
	      (setq prj:gap (verify_d tiles value prj:gap)))  
	  ((= tiles "f_size")
	   (setq prj:frw (verify_d tiles value prj:frw)))
	  ((= tiles "num_2")
	   (setq prj:num (verify_d tiles value prj:num)))
	  ((= tiles "num_1")
	   (setq prj:numc (verify_d tiles value prj:numc)))
	  ((= tiles "hght_2")
	   (setq prj:phg (verify_d tiles value prj:phg)))
	  ((= tiles "ed_opn_width")
	   (setq prj:wid (verify_d tiles value prj:wid)))
	  ((= tiles "ed_opn_height")
	   (setq prj:hgh (verify_d tiles value prj:hgh))) 
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
;;---------- list box handle
(defun ttest (/ old_pwe_type)
 (readF "pweType.dat" nil)
 (setq  old_pwe_type C_pwe_type)
 (setq L_index (Find_index old_pwe_type))
    (progn
      (setq zin_old (getvar "dimzin"))
      (setvar "dimzin" 8)
      (if (not (new_dialog "set_pwintype_name" dcl_id)) (exit)) 
      (set_tile "title" "List of Entities")
      
      (list_view)
      (Set_tileS)
      (action_Tiles)
      (start_dialog)
      (setvar "dimzin" zin_old)
     ))

(defun set_tileS ()
 (if (= L_index nil) (setq L_index 0 ))
  (setq C_pwe_type (nth 0 (cdr (nth L_index @Type))))  
 (set_tile "list_type" (rtos L_index)) 
 (set_tile "current_type" old_pwe_type)
 (set_tile "ed_type_name" C_pwe_type) 
)
 
(defun action_Tiles ()
 (action_tile "list_type" "(setq C_pwe_type (Field_match \"타입명\" (setq L_index (atoi $value))))(set_tileS)")
 (action_tile "accept" "(qqqq)")
 (action_tile "cancel" "(setq C_pwe_type old_pwe_type)")
 (action_tile "eb_del_type" "(deleteIdx C_pwe_type)(set_tileS)")
 (action_tile "eb_ren_type" "(renameIdx C_pwe_type)(set_tileS)")
 (action_tile "eb_new_type" "(newIdx C_pwe_type)(set_tileS)")
)
(defun qqqq()
  (Set_pwe_Value)(writeF "pweType.dat" nil)(done_dialog 1)(set_tile_props)
)
;;---------- list box handle
 
) ; end wn2_init

(defun pwe_do ()
  (if (not (new_dialog "dd_pwin" dcl_id)) (exit))
  (set_tile_props)
  (set_action_tiles)
  (setq dialog-state (start_dialog))
  (if (= dialog-state 0)
   (setq reset_flag t)
  )
)

(defun pwe_return ()
  
  (setq pwe:fprop  old_fprop
        pwe:cprop  old_cprop
        pwe:mprop  old_mprop
	pwe:glin  old_gprop
        prj:typ  old_typ
        prj:numc  old_num
        prj:num  old_num2 
  )
)


(defun dd_PWE (/
                      
           dcl_id       dialog-state     dismiss_dialog
           getfsize     old_num		old_typ           radio_gaga
           reset_flag	set_action_tiles set_tile_props
	   action_Tiles  qqqq   ttest   set_tileS   verify_d  ValueToList
	   pwe_DrawImage
	   drawImage_prj pwe:mark_chk_do)

(defun ValueToList(/ tmptype tmplist tmm newlist)
  ;타입명;창문타입;width;height;frame_size;case_num;project_num;project_height
  ;gap_sizes;pwe:gap_chk;opnwid_chk;opnhig_chk;pwe:mark_chk;
  (setq tmplist (nth L_index @type))
  (setq tmptype (strcat (strcase prj:typ) "-Type"))
    
  (setq tmm (list C_pwe_type tmptype (rtos prj:wid) (rtos prj:hgh) (rtos prj:frw) (itoa prj:numc)
		  (itoa prj:num) (rtos prj:phg) (rtos prj:gap) pwe:gap_chk pwe:owid_chk pwe:ohig_chk pwe:mark_chk))
  (setq newlist (cons (1+ L_index) tmm))
  (setq @type (subst newlist tmplist @Type) )
)
  (setvar "cmdecho" (cond (  (or (not *debug*) (zerop *debug*)) 0)
                          (t 1)))

  (setq old_fprop  pwe:fprop
        old_cprop  pwe:cprop
        old_mprop  pwe:mprop
        old_gprop  pwe:gprop
        old_typ  prj:typ
        old_num  prj:numc
	old_num2  prj:num
  )

  (princ ".")
  (cond
     (  (not (setq dcl_id (Load_dialog "WINELEV.dcl"))))   ; is .DLG file loaded?

     (t (ai_undo_push)
        (princ ".")
        (pwe_Draw_Image_X)
        (pwe_init)                              ; everything okay, proceed.
        (princ ".")
        (pwe_do)
     )
  )
  (if reset_flag
    (pwe_return)
    (pwe_set)
  )
  (if dcl_id (unload_dialog dcl_id))
)


(defun Set_Pwe_Value(/ tnnp ttmpp1)
 
  (setq prj:typ (strcase (substr (Field_match "창문타입" L_index) 1 1) T))
  (setq prj:wid (atof (Field_match "width" L_index) ))
  (setq prj:hgh (atof (Field_match "height" L_index)))
  (setq prj:num (atoi (Field_match "project_num" L_index))) 
  (setq prj:phg (atof (Field_match "project_height" L_index)))
  (setq prj:gap (atof (Field_match "gap_size" L_index)))
  (setq prj:frw (atof (Field_match "frame_size" L_index)))
  (setq prj:numc (atoi (Field_match "case_num" L_index)))
  (setq pwe:gap_chk  (Field_match "gap_chk" L_index))
  (setq pwe:owid_chk (Field_match "opnwid_chk" L_index))
  (setq pwe:ohig_chk (Field_match "opnhig_chk" L_index))
  (setq pwe:mark_chk (Field_match "mark_chk" L_index))
)
(if (null C_pwe_type)
   (progn
   (setq pwe:fprop  (Prop_search "pwe" "frame"))
   (setq pwe:cprop  (Prop_search "pwe" "casement"))
   (setq pwe:mprop  (Prop_search "pwe" "open_mark"))
   (setq pwe:gprop  (Prop_search "pwe" "outline"))
   (setq pwe:prop '(pwe:fprop pwe:cprop pwe:mprop pwe:gprop))
   (readF "PweType.dat" nil) (setq L_index 0)
   (setq C_pwe_type (nth 0 (cdr (nth L_index @Type))))
   (Set_Pwe_Value)
)) 


(if (null prj:gap) (setq prj:gap window_gap))
(if (null prj:wid) (setq prj:wid 2400))
(if (null prj:anh) (setq prj:anh 0))
(if (null prj:anv) (setq prj:anv (/ pi 2)))
(if (null prj:hgh) (setq prj:hgh 1800))
(if (null prj:phg) (setq prj:phg 400))
(if (null prj:num) (setq prj:num 2))

(if (null pwe:fprop) (setq pwe:fprop (list "pwe" "frame" "WINELEV" "6" "CONTINUOUS" "1" "1")))
(if (null pwe:cprop) (setq pwe:cprop (list "pwe" "casement" "WINELEV" "6" "CONTINUOUS" "1" "1")))
(if (null pwe:mprop) (setq pwe:mprop (list "pwe" "open_mark" "WINELEV" "6" "CONTINUOUS" "1" "1")))
(if (null pwe:gprop) (setq pwe:gprop (list "pwe" "outline" "WINELEV" "6" "CONTINUOUS" "1" "1")))

(if (null pwe_prop_type) (setq pwe_prop_type "rd_frame"))
(if (null prj:typ) (setq prj:typ "a"))
(if (null pwe:mark_chk) (setq pwe:mark_chk "1"))
(if (null pwe:gap_chk) (setq pwe:gap_chk "0"))
(if (null pwe:owid_chk) (setq pwe:owid_chk "1"))
(if (null pwe:ohig_chk) (setq pwe:ohig_chk "1"))

(if (null prj:frw) (setq prj:frw 40))

(if (null prj:numc) (setq prj:numc 2))


(defun C:CIMPWE () (m:prj))
(setq lfn32 1)
(princ)
