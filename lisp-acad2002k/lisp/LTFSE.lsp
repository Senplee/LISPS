
;단축키 관련 변수 정의 부분 -맨 뒤로..
(defun fse_Draw_Image_X( / )
(defun fse_DrawImage (fse_key !fsetype! / fcolor ccolor mcolor  cx cy ox oy dx dy x1 x2 x3 y1 y2)
  (setq fcolor (propcolor fse:fprop))
  (setq ccolor (propcolor fse:cprop))  
  (setq mcolor (propcolor fse:mprop)) 
    
    (do_blank fse_key 0)
    (start_image fse_key)	  
    (setq cx (dimx_tile fse_key)
	  cy (dimy_tile fse_key)
	  dx (/ cx 30) 
	  dy (/ cy 20) 
	  x1 dx x2 (* dx 2) x3 (* dx 16) y1 (* dy 2) y2 (* dy 3))

        (drawImage_box x1 y1 (* dx 29) (* dy 17) fcolor)
	(drawImage_fse x2 y2 dx dy)
	(drawImage_fse x3 y2 dx dy)
    (end_image)
)


(defun drawImage_fse(xp yp dx dy / x1 x2 y1 y2 y3
		mx1 mx2 mx3 mx4 my1 my2 my3)
 
      (setq 
	x1 (+ xp dx) x2 (+ xp (* dx 7))
	y1 (* dy 12) y2 (* dy 13) y3 (* dy 18)
	mx1 (+ xp (* dx 4)) mx2 (+ xp (* dx 5)) mx3 (+ xp (* dx 8)) mx4 (+ xp (* dx 9))
	my1 (* dy  14) my2 (* dy 15) my3 (* dy  16))
  
  	(drawImage_box xp yp (* dx 13) (* dy 8) fcolor)
	(drawImage_box xp y1 (* dx 13) (* dy 6) fcolor)
	(vector_image x2 y1 x2 y3 ccolor)
	(drawImage_box x1 y2 (* dx 5) (* dy 4) ccolor)
	(drawImage_box x2 y2 (* dx 5) (* dy 4) ccolor)
	(if (= fse:mark_chk "1")(progn
		(vector_image mx1 my1 mx2 my2 mcolor)
		(vector_image mx2 my2 mx1 my3 mcolor)
		(vector_image mx1 my3 mx1 my1 mcolor)
		(vector_image mx3 my2 mx4 my1 mcolor)
		(vector_image mx4 my1 mx4 my3 mcolor)
		(vector_image mx4 my3 mx3 my2 mcolor)))
)  
)
  
(defun m:fse (/
             ang      ang1     ang2     ang3     sc       pt1      pt2
             pt3      pt4      pt5      pt6      pt7      pt8      pt9
             pt10     pt11     pt12     pt13     pt14     pt15     pt16
             pt17     pt18     pt19     pt20     pt21     pt1x     pt1y
             pt2x     pt2y     pt3x     pt3y     pt4x     pt4y     pte
             strtpt   nextpt   uctr     cont     temp     tem      ptd
             fse_ola  fse_oco  fse_err  fse_oer  fse_oli 
	     n  bmode omode )
  

  
  (setq sc (getvar "dimscale"))
  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")

 (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n고정창 + 미서기창호 입면 그리기 명령 입니다.")

  (setq cont T temp T uctr 0)

  (while cont
    (fse_m1)
    (if (and (= fse:owid_chk "1") tem) (progn
			   (setq nextpt (polar strtpt fse:anh fse:wid))
			   (setq tem     nil
                                 ptd     T
                		 fse:wid (distance strtpt nextpt)
                	         fse:anh (angle strtpt nextpt)))
    (fse_m2))
    (if (and (= fse:ohig_chk "1") ptd) (progn
			   (setq fse:anv (+ fse:anh (/ pi 2)))	     
			   (setq pt4 (polar strtpt fse:anv fse:hgh))
			  (command "_.undo" "_m")
	    		  (setvar "osmode" 0)(setvar "blipmode" 0)
            		  (fse_ex)
            		  (setq uctr (1+ uctr))
            		  (setq ptd nil temp T))
    (fse_m3))
    ;;(fse_m4)
  )

  (if fse_oco (command "_.color" fse_oco))
  (if fse_ola (command "_.layer" "_S" fse_ola ""))
  (if fse_oli (command "_.linetype" "_s" fse_oli ""))

  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)


  (princ)
)

(defun fse_m1 ()
  (while temp
    (setvar "osmode" (+ 1 32 128))
    (setvar "blipmode" 1)
    (if (> uctr 0)
      (progn
        (princ (strcat "\nGap_size:" (rtos fse:gap)
;;;                       "  미들창개수" (itoa fse:num)
                       "  미서기창높이:" (rtos fse:phg)
                       ;"  Linetype:" fse:lin
                       "\n창문 너비:"    (rtos fse:wid)
                       "  창문 높이"   (rtos fse:hgh)))
        (initget "/ Dialog Offset Undo")
        (setq strtpt (getpoint
          "\n>>> Dialog/Offset/Undo/<좌측 하단>: "))
      )
      (progn
        (princ (strcat ;"\n미들창개수" (itoa fse:num)
		       "\n  미서기창높이:" (rtos fse:phg)
		       "  고정창개수:" (itoa fse:numc)
                       ))
        (initget "/ Dialog Offset")
        (setq strtpt (getpoint
         "\n>>> Dialog/Offset/<좌측 하단>: "))
      )
    )
    (cond
      ((= strtpt "Dialog")
        (DD_fse)
      )
      ((= strtpt "Offset")
        (cim_ofs)
      )
      ((= strtpt "/")
        (cim_help "fse")
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

(defun fse_m2 ()
  (while tem
    (setvar "blipmode" 1)
    (setvar "snapbase" (list (car strtpt) (cadr strtpt)))
    (initget "/ Dialog Undo")
    (setq nextpt (getpoint strtpt (strcat
      "\n>>> Dialog/Undo/<width:"
      (rtos fse:wid) " Angle:" (angtos fse:anh) ">: ")))
    (setvar "blipmode" 0)
    
    (cond
      ((= nextpt "Dialog")
        (DD_fse)
      )
      ((= nextpt "/")
        (cim_help "fse")
      )
      ((= nextpt "Undo")
        (setq tem nil temp T)
      )
      ((null nextpt)
        (setq tem nil ptd T)
      )
      (T
        (if (< (distance strtpt nextpt) (* fse:numc 300))
          (alert (strcat "Insufficient width -- Value is not less than"
                   (rtos (* fse:numc 300))))
          (setq tem     nil
                ptd     T
                fse:wid (distance strtpt nextpt)
                fse:anh (angle strtpt nextpt)
          )
        )
      )
    )
  )
)

(defun fse_m3 ()
  (while ptd
    (setvar "blipmode" 1)
    
    (initget "/ Dialog Undo")
    (setq pt3 (getpoint strtpt (strcat
      "\n>>> Dialog/Undo/<height:"
      (rtos fse:hgh) " Angle:" (angtos fse:anv) ">: ")))
    (setvar "blipmode" 0)
   
    (cond
   
      ((= pt3 "Dialog")
        (DD_fse)
      )
      ((= pt3 "/")
        (cim_help "fse")
      )
      ((= pt3 "Undo")
        (setq ptd nil tem T)
      )
      ((null pt3)
        (command "_.undo" "_m")
        (fse_ex)
        (setq uctr (1+ uctr))
        (setq ptd nil temp T)
      )
      (T
        (if (< (distance strtpt pt3) fse:phg)
          (alert (strcat "Insufficient height -- Value is not less than " (rtos (+ fse:phg fse:frwc))))
          (progn
	    (command "_.undo" "_m")
            (setq fse:hgh (distance strtpt pt3)
                  fse:anv (+ fse:anh (/ pi 2))
            )
	    (fse_ex)
            (setq ptd nil temp T)
	    
          )
        )
      )
    )
  )
)

(defun fse_ex ( / dist1 tmpgap)
  (setvar "osmode" 0)
  (setq tmpgap (if (= fse:gap_chk "0") 0 fse:gap)
    	pt1  strtpt
        pt2
               (polar pt1 fse:anh fse:wid)
        pt4
               (polar pt1 fse:anv fse:hgh)
        pt3  (polar pt2 fse:anv fse:hgh) 
        ang  fse:anh
        ang1 (angle pt2 pt1)
        ang2 fse:anv
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
  (if (and (/= fse:gap 0) (/= fse:gap_chk "0"))
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
      (set_col_lin_lay fse:gprop)
      (command "_.LINE" pt1x pt2x "")
      (command "_.LINE" pt2y pt3y "")
      (command "_.LINE" pt3x pt4x "")
      (command "_.LINE" pt4y pt1y "")
;;;      (command "_.layer" "_s" fse:lay "")
    )
  )
  (set_col_lin_lay fse:fprop)
  (command "_.pline" pt5 pt6 pt7 pt8 "_C")
  
;; fse:numc
  (setq n 0)
  (repeat fse:numc
     (setq  pt9  (polar pt5  ang  fse:frw)
        pt9  (polar pt9  ang2 (+ (- fse:phg tmpgap ) (/ fse:frw 2) ))
        pt10 (polar pt9  ang  (/ (- fse:wid (* fse:frw 2) (* tmpgap 2) (* fse:frw (1- fse:numc))) fse:numc))  
        pt11 (polar pt10  ang2 (- fse:hgh fse:phg (* fse:frw 1.5)))
        pt12 (polar pt9  ang2 (- fse:hgh fse:phg (* fse:frw 1.5)))
        pt13 (polar pt5  ang  fse:frw)
        pt13 (polar pt13 ang2 fse:frw)
        pt14 (polar pt13 ang
                 (/ (- fse:wid (* fse:frw 2) (* tmpgap 2) (* fse:frw (1- fse:numc))) fse:numc)
               )
        pt15 (polar pt14 ang2 (- fse:phg tmpgap (* fse:frw 1.5)))
        pt16 (polar pt13 ang2 (- fse:phg tmpgap (* fse:frw 1.5))))

      (set_col_lin_lay fse:fprop)
    (command "_.pline" pt9 pt10 pt11 pt12 "_C")
     (set_col_lin_lay fse:fprop)
    (command "_.pline" pt13 pt14 pt15 pt16 "_C")
    
    
    (setq 
          pt17 (polar pt13 ang  (* fse:frwc 0.6))
          pt17 (polar pt17 ang2 (* fse:frwc 0.6))
          pt18 (polar pt17 ang (- (/ (distance pt13 pt14) 2) (* fse:frwc 1.1) ))
          pt19 (polar pt18 ang2 (- (distance pt14 pt15) (* fse:frwc 1.2)))
          pt20 (polar pt19 ang1 (distance pt17 pt18) )
          pt21 (polar pt18 ang  fse:frwc ) pt21 (polar pt21 ang3  (* fse:frwc 0.6) )
          pt22 (polar pt19 ang  fse:frwc ) pt22 (polar pt22 ang2  (* fse:frwc 0.6) )

    )
   
    (set_col_lin_lay fse:cprop)
    
    (command "_.pline" pt17 pt18 pt19 pt20 "_C")
    (command "_.line" pt21 pt22 "")
    (setq dist1 (+ (distance pt17 pt18) fse:frwc ))
    (command "_.pline" (polar pt17 ang dist1) (polar pt18 ang dist1)
	     		(polar pt19 ang dist1) (polar pt20 ang dist1) "")
    (if (= fse:mark_chk "1")(progn
    (setq pp9 (polar pt19 ang3 (/ (distance pt18 pt19) 2))
	  pp9 (polar pp9 ang1 fse:frwc)
	  pp10  (polar (polar pt20 ang dist1) ang3 (/ (distance pt18 pt19) 2))
	  pp10 (polar pp10 ang fse:frwc))
    
    (set_col_lin_lay fse:mprop)
    (command "_.solid" (polar pp10 ang2 (* fse:frwc 0.3))
	             (polar pp10 ang3 (* fse:frwc 0.3))
                     (polar pp10 ang1 (* fse:frwc 0.6) )  "" "")
    (command "_.solid" (polar pp9 ang2 (* fse:frwc 0.3))
	             (polar pp9 ang3 (* fse:frwc 0.3))
                     (polar pp9 ang (* fse:frwc 0.6) )  "" "")
    ))
    (setq pt5 (polar pt14 ang3 fse:frw))
   
    (setq n (1+ n))
 )
)

;;-----------------------------------------------------



(defun fse_init ()

  (defun fse_set (/ chnaged?)
    (PROP_SAVE fse:prop)
    (if changed? (WriteF "PropType.dat" "prop"))
  )

  ;;
  ;; Common properties for all entities
  ;;
 
  
  (defun set_tile_props ()
    
    (set_tile "error" "")
    (set_tile fse_prop_type "1")                ;; prop radio
    (@get_eval_prop fse_prop_type fse:prop)
    
    (fse_DrawImage "elev_image" T)
    (set_tile "tx_type" C_fse_type)
    
    (mode_tile "a_type" 1)(mode_tile "b_type" 1)
    
    (set_tile "opn_mark" fse:mark_chk)
    (set_tile "tg_gap_size" fse:gap_chk)
    (mode_tile "ed_gap_size" (if (= fse:gap_chk"1") 0 1)) 
    (set_tile "tg_opn_width" fse:owid_chk)
    (mode_tile "ed_opn_width" (if (= fse:owid_chk"1") 0 1)) 
    (set_tile "tg_opn_height" fse:ohig_chk)
    (mode_tile "ed_opn_height" (if (= fse:ohig_chk"1") 0 1)) 

    (set_tile "ed_gap_size" (rtos fse:gap))
    (set_tile "f_size" (rtos fse:frw))
    (set_tile "c_size" (rtos fse:frwc))
    (set_tile "num_1" (itoa fse:numc))
    ;(set_tile "num_2" (itoa fse:num))
    (set_tile "hght_2" (rtos fse:phg))
    (set_tile "ed_opn_width" (rtos fse:wid))
    (set_tile "ed_opn_height" (rtos fse:hgh))

    (fse_DrawImage "elev_image" T)
  )


  
  (defun set_action_tiles ()

    (action_tile "b_name"       "(@getlayer)(fse_DrawImage \"elev_image\" T)")    
    (action_tile "b_color"      "(@getcolor)(fse_DrawImage \"elev_image\" T)")
    (action_tile "color_image"  "(@getcolor)(fse_DrawImage \"elev_image\" T)")
    (action_tile "b_line"       "(@getlin)(fse_DrawImage \"elev_image\" T)")
    (action_tile "c_bylayer"    "(@bylayer_do T)(fse_DrawImage \"elev_image\" T)")
    (action_tile "t_bylayer"    "(@bylayer_do nil)(fse_DrawImage \"elev_image\" T)")

    (action_tile "bn_type"       "(ttest)")
    
    (action_tile "prop_radio" "(setq fse_prop_type $Value)(@get_eval_prop fse_prop_type fse:prop)(fse_DrawImage \"elev_image\" T)")
    
    (action_tile "opn_mark" 	"(fse:mark_chk_do)(fse_DrawImage \"elev_image\" T)")
    (action_tile "tg_gap_size" 	"(radio_gaga \"gap\")")
    (action_tile "tg_opn_width" "(radio_gaga \"width\")")
    (action_tile "tg_opn_height" "(radio_gaga \"height\")")

    (action_tile "ed_gap_size"  "(getfsize $value \"ed_gap_size\")")
    (action_tile "f_size"       "(getfsize $value \"f_size\")")
    (action_tile "c_size"       "(getfsize $value \"c_size\")")
    (action_tile "num_1"       "(getfsize $value \"num_1\")")
   
    (action_tile "hght_2"       "(getfsize $value \"hght_2\")")
    
    (action_tile "ed_opn_width"       "(getfsize $value \"ed_opn_width\" )")
    (action_tile "ed_opn_height"       "(getfsize $value \"ed_opn_height\")")
    
    (action_tile "accept"       "(dismiss_dialog 1)")
    (action_tile "cancel"       "(dismiss_dialog 0)")
    (action_tile "help"         "(cim_help \"WN2\")")
    (action_tile "bn_type_save"   "(readF \"FseType.dat\" nil)(ValueToList)(writeF \"FseType.dat\" nil)")
  )

  (defun fse:mark_chk_do ()
    (setq fse:mark_chk (get_tile "opn_mark"))
  )
  (defun radio_gaga (pushed)
    
    (cond 
      ((= pushed "gap")
        (setq fse:gap_chk (get_tile "tg_gap_size"))(mode_tile "ed_gap_size" (if (= fse:gap_chk "1") 0 1))
      )
      ((= pushed "width")
	(setq fse:owid_chk (get_tile "tg_opn_width"))(mode_tile "ed_opn_width" (if (= fse:owid_chk "1") 0 1))
      )
      ((= pushed "height")
	(setq fse:ohig_chk (get_tile "tg_opn_height"))(mode_tile "ed_opn_height" (if (= fse:ohig_chk "1") 0 1))
      ))
    
  )
 	
  (defun getfsize (value tiles)
    (cond ((= tiles "ed_gap_size") 
	      (setq fse:gap (verify_d tiles value fse:gap)))  
	  ((= tiles "f_size")
	   (setq fse:frw (verify_d tiles value fse:frw)))
	  ((= tiles "c_size")
	   (setq fse:frwc (verify_d tiles value fse:frwc)))
	  ((= tiles "num_1")
	   (setq fse:numc (verify_d tiles value fse:numc)))
	  ((= tiles "hght_2")
	   (setq fse:phg (verify_d tiles value fse:phg)))
	  ((= tiles "ed_opn_width")
	   (setq fse:wid (verify_d tiles value fse:wid)))
	  ((= tiles "ed_opn_height")
	   (setq fse:hgh (verify_d tiles value fse:hgh))) 
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
;;; --- list box handle
(defun ttest (/ old_fse_type)
 (readF "FseType.dat" nil)
 (setq  old_fse_type C_fse_type)
 (setq L_index (Find_index old_fse_type))
    (progn
      (setq zin_old (getvar "dimzin"))
      (setvar "dimzin" 8)
      (if (not (new_dialog "set_fswintype_name" dcl_id)) (exit)) 
      (set_tile "title" "List of Entities")
      
      (list_view)
      (Set_tileS)
      (action_Tiles)
      (start_dialog)
      (setvar "dimzin" zin_old)
     ))

(defun set_tileS ()
 (if (= L_index nil) (setq L_index 0 ))
 (setq C_fse_type (nth 0 (cdr (nth L_index @Type))))  
 (set_tile "list_type" (rtos L_index)) 
 (set_tile "current_type" old_fse_type)
 (set_tile "ed_type_name" C_fse_type) 
)
 
(defun action_Tiles ()
 (action_tile "list_type" "(setq C_fse_type (Field_match \"타입명\" (setq L_index (atoi $value))))(set_tileS)")
 (action_tile "accept" "(qqqq)")
 (action_tile "cancel" "(setq C_fse_type old_fse_type)")
 (action_tile "eb_del_type" "(deleteIdx C_fse_type)(set_tileS)")
 (action_tile "eb_ren_type" "(renameIdx C_fse_type)(set_tileS)")
 (action_tile "eb_new_type" "(newIdx C_fse_type)(set_tileS)")
)
(defun qqqq()
  (Set_fse_Value)(writeF "FseType.dat" nil)(done_dialog 1)(set_tile_props)
)
;;; --- list box handle
  
) ; end wn2_init

(defun fse_do ()
  (if (not (new_dialog "dd_fswin" dcl_id)) (exit))
  (set_tile_props)
  (set_action_tiles)
  (setq dialog-state (start_dialog))
  (if (= dialog-state 0)
   (setq reset_flag t)
  )
)

(defun fse_return ()
  
  (setq fse:fprop  old_fprop
        fse:cprop  old_cprop
        fse:mprop  old_mprop
	fse:gprop  old_gprop
        fse:numc  old_num
        fse:num  old_num2 
  )
)


(defun dd_fse (/
                      
           ci_mode          dcl_id           dialog-state     dismiss_dialog
	   old_fprop old_cprop old_mprop old_gprop
           getfsize     old_num		old_typ           radio_gaga
           reset_flag	set_action_tiles set_tile_props   sortlist
           test_ok      tile 
	   action_Tiles  qqqq   ttest   set_tileS   verify_d  ValueToList
	   fse_DrawImage
	   drawImage_fse fse:mark_chk_do ) 

(defun ValueToList(/ tmptype tmplist tmm newlist)
  (setq tmplist (nth L_index @type))
  (setq tmm (list C_fse_type (rtos fse:wid) (rtos fse:hgh) (rtos fse:frw) (rtos fse:frwc)(itoa fse:numc)
		  (rtos fse:phg) (rtos fse:gap) fse:gap_chk fse:owid_chk fse:ohig_chk fse:mark_chk))
  (setq newlist (cons (1+ L_index) tmm))
  (setq @type (subst newlist tmplist @Type) )
)
  (setvar "cmdecho" (cond (  (or (not *debug*) (zerop *debug*)) 0)
                          (t 1)))

  (setq old_fprop  fse:fprop
        old_cprop  fse:cprop
        old_mprop  fse:mprop
        old_gprop  fse:gprop
        old_num  fse:numc
	old_num2  fse:num
  )

  (princ ".")
  (cond
     (  (not (setq dcl_id (Load_dialog "WINELEV.dcl"))))   ; is .DLG file loaded?

     (t (ai_undo_push)
        (princ ".")
        (fse_Draw_Image_X)
        (fse_init)                              ; everything okay, proceed.
        (princ ".")
        (fse_do)
     )
  )
  (if reset_flag
    (fse_return)
    (fse_set)
  )
  (if dcl_id (unload_dialog dcl_id))
)


(defun Set_fse_Value(/ tnnp ttmpp1)
 
  (setq fse:wid (atof (Field_match "width" L_index) ))
  (setq fse:hgh (atof (Field_match "height" L_index)))
  (setq fse:phg (atof (Field_match "sliding_height" L_index)))
  (setq fse:gap (atof (Field_match "gap_sizes" L_index)))
  (setq fse:frw (atof (Field_match "frame_size" L_index)))
  (setq fse:frwc  (atof (Field_match "case_size" L_index)))
  (setq fse:numc (atoi (Field_match "case_num" L_index)))
  (setq fse:gap_chk  (Field_match "gap_chk" L_index))
  (setq fse:owid_chk (Field_match "opnwid_chk" L_index))
  (setq fse:ohig_chk (Field_match "opnhig_chk" L_index))
  (setq fse:mark_chk (Field_match "mark_chk" L_index))
)
(if (null C_fse_type)
   (progn
   (setq fse:fprop  (Prop_search "fse" "frame"))
   (setq fse:cprop  (Prop_search "fse" "casement"))
   (setq fse:mprop  (Prop_search "fse" "open_mark"))
   (setq fse:gprop  (Prop_search "fse" "outline"))
   (setq fse:prop '(fse:fprop fse:cprop fse:mprop fse:gprop))
   (readF "FseType.dat" nil) (setq L_index 0)
   (setq C_fse_type (nth 0 (cdr (nth L_index @Type))))
   (Set_fse_Value)
)) 

(if (null fse:gap) (setq fse:gap window_gap))
(if (null fse:wid) (setq fse:wid 2400))
(if (null fse:anh) (setq fse:anh 0))
(if (null fse:anv) (setq fse:anv (/ pi 2)))
(if (null fse:hgh) (setq fse:hgh 1800))
(if (null fse:phg) (setq fse:phg 400))
(if (null fse:frwc) (setq fse:frwc 50))

(if (null fse:fprop) (setq fse:fprop (list "fse" "frame" "WINELEV" "6" "CONTINUOUS" "1" "1")))
(if (null fse:cprop) (setq fse:cprop (list "fse" "casement" "WINELEV" "6" "CONTINUOUS" "1" "1")))
(if (null fse:mprop) (setq fse:mprop (list "fse" "open_mark" "WINELEV" "6" "CONTINUOUS" "1" "1")))
(if (null fse:gprop) (setq fse:gprop (list "fse" "outline" "WINELEV" "6" "CONTINUOUS" "1" "1")))

(if (null fse_prop_type) (setq fse_prop_type "rd_frame"))
(if (null fse:mark_chk) (setq fse:mark_chk "1"))
(if (null fse:gap_chk) (setq fse:gap_chk "0"))
(if (null fse:owid_chk) (setq fse:owid_chk "1"))
(if (null fse:ohig_chk) (setq fse:ohig_chk "1"))

(if (null fse:frw) (setq fse:frw 40))

(if (null fse:numc) (setq fse:numc 2))


(defun C:cimfse () (m:fse))
(setq lfn33 1)
(princ)
