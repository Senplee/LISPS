;단축키 관련 변수 정의 부분 -맨 뒤로..

(defun sfe_Draw_Image_X( / )
(defun sfe_DrawImage (sfe_key !sfetype! / fcolor ccolor mcolor  cx cy ox oy dx dy x1 x2 x3 y1 y2)
  (setq fcolor (propcolor sfe:fprop))
  (setq ccolor (propcolor sfe:cprop))  
  (setq mcolor (propcolor sfe:mprop)) 
  ;(setq gcolor (propcolor sfe:gprop))
  
    (do_blank sfe_key 0)
    (start_image sfe_key)
    (cond ((= sfe:lra "left") (drawSFwinImage_1))
          ((= sfe:lra "right") (drawSFwinImage_2))
          (T (drawSFwinImage_3)))
    (end_image)
)


(defun drawSFwinImage_1(/ dx dy x1 x2 x3 x4 x5 y1 y2 y3 y4 mx1 mx2 my1 my2 my3)

    (setq cx (dimx_tile sfe_key)
          cy (dimy_tile sfe_key)
          dx (/ cx 30) 
          dy (/ cy 20) 
        x1 dx x2 (* dx 2) x3 (* dx 3) x4 (* dx 8) x5 (* dx 9)
        y1 (* dy 2) y2 (* dy 3) y3 (* dy 4) y4 (* dy 17)
        mx1 (* dx 6) mx2 (* dx 7)
        my1 (* dy 9) my2 (* dy 10) my3 (* dy 11)
        )
        (drawImage_box x1 y1 (* dx 28) (* dy 16) fcolor)
        (if (= sfe:typ "a")(progn
                (drawImage_box x3 y3 (* dx 5)  (* dy 12) ccolor)
                (drawImage_box x2 y2 (* dx 6)  (* dy 14) fcolor)
                (drawImage_box x5 y2 (* dx 19) (* dy 14) fcolor)
        )(progn
                (drawImage_box x2 y2 (* dx 26) (* dy 14) fcolor)
                (drawImage_box x3 y3 (* dx 5)  (* dy 12) ccolor)
                (vector_image x5 y2 x5 y4 ccolor)
        ))
        (if (= sfe:mark_chk "1")(progn
                (vector_image mx1 my1 mx2 my2 mcolor)
                (vector_image mx2 my2 mx1 my3 mcolor)
                (vector_image mx1 my3 mx1 my1 mcolor)
        ))
)
(defun drawSFwinImage_2 (/ dx dy x1 x2 x3 x4 y1 y2 y3 y4 mx1 mx2 my1 my2 my3)
(setq cx (dimx_tile sfe_key)
      cy (dimy_tile sfe_key)
          dx (/ cx 30) 
          dy (/ cy 20) 
        x1 dx x2 (* dx 2) x3 (* dx 21) x4 (* dx 22)
        y1 (* dy 2) y2 (* dy 3) y3 (* dy 4) y4 (* dy 17)
        mx1 (* dx 23) mx2 (* dx 24)
        my1 (* dy 9) my2 (* dy 10) my3 (* dy 11)
        )
        (drawImage_box x1 y1 (* dx 28) (* dy 16) fcolor)
        (if (= sfe:typ "a")(progn
                (drawImage_box x2 y2 (* dx 19) (* dy 14) fcolor)
                (drawImage_box x4 y3 (* dx 5)  (* dy 12) ccolor)
                (drawImage_box x4 y2 (* dx 6)  (* dy 14) fcolor)
        )(progn
                (drawImage_box x2 y2 (* dx 26) (* dy 14) fcolor)
                (drawImage_box x4 y3 (* dx 5)  (* dy 12) ccolor)
                (vector_image x3 y2 x3 y4 ccolor)
        ))
        (if (= sfe:mark_chk "1")(progn
                (vector_image mx1 my2 mx2 my1 mcolor)
                (vector_image mx2 my1 mx2 my3 mcolor)
                (vector_image mx2 my3 mx1 my2 mcolor)
        ))
)
(defun drawSFwinImage_3(/ dx dy x1 x2 x3 x4 x5 x6 x7 y1 y2 y3 y4 mx1 mx2 mx3 mx4 my1 my2 my3)

      (setq cx (dimx_tile sfe_key)
          cy (dimy_tile sfe_key)
          dx (/ cx 30) 
          dy (/ cy 20) 

        dx (/ cx 30) dy (/ cy 20)
        ox (/ cx 60) oy (/ cy 40)
        x1 dx x2 (* dx 2) x3 (* dx 3) x4 (* dx 8) x5 (* dx 9) x6 (* dx 21) x7 (* dx 22)
        y1 (* dy 2) y2 (* dy 3) y3 (* dy 4) y4 (* dy 17)
        mx1 (* dx 6) mx2 (* dx 7) mx3 (* dx 23) mx4 (* dx 24)
        my1 (* dy 9) my2 (* dy 10) my3 (* dy 11)
        )
        (drawImage_box x1 y1 (* dx 28) (* dy 16) fcolor)
        (if (= sfe:typ "a")(progn
                (drawImage_box x3 y3 (* dx 5)  (* dy 12) ccolor)
                (drawImage_box x2 y2 (* dx 6)  (* dy 14) fcolor)
                (drawImage_box x5 y2 (* dx 12) (* dy 14) fcolor)
                (drawImage_box x7 y3 (* dx 5)  (* dy 12) ccolor)
                (drawImage_box x7 y2 (* dx 6)  (* dy 14) fcolor)
        )(progn
                (drawImage_box x2 y2 (* dx 26) (* dy 14) fcolor)
                (drawImage_box x3 y3 (* dx 5)  (* dy 12) ccolor)
                (vector_image x5 y2 x5 y4 ccolor)
                (drawImage_box x7 y3 (* dx 5)  (* dy 12) ccolor)
                (vector_image x6 y2 x6 y4 ccolor)
        ))
        (if (= sfe:mark_chk "1")(progn
                (vector_image mx1 my1 mx2 my2 mcolor)
                (vector_image mx2 my2 mx1 my3 mcolor)
                (vector_image mx1 my3 mx1 my1 mcolor)
                (vector_image mx3 my2 mx4 my1 mcolor)
                (vector_image mx4 my1 mx4 my3 mcolor)
                (vector_image mx4 my3 mx3 my2 mcolor)
        ))
)


)
  
(defun m:sfe (/
             ang      ang1     ang2     ang3     sc       pt1      pt2
             pt3      pt4      pt5      pt6      pt7      pt8      pt9
             pt10     pt11     pt12     pt13     pt14     pt15     pt16
             pt17     pt18     pt19     pt20     pt21     pt1x     pt1y
             pt2x     pt2y     pt3x     pt3y     pt4x     pt4y     pte
             strtpt   nextpt   uctr     cont     temp     tem      ptd
             ;sfe_ola  sfe_oco  sfe_err  sfe_oer  sfe_oli  bmode omode
             n  )
  

  (setq sc     (getvar "dimscale"))
        
  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")


 (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n미서기창 + 고정창호 입면 그리기 명령 입니다.")

  (setq cont T temp T uctr 0)

  (while cont
    (sfe_m1)
    (if (and (= sfe:owid_chk "1") tem) (progn
                           (setq nextpt (polar strtpt sfe:anh sfe:wid))
                           (setq tem     nil
                                 ptd     T
                                 sfe:wid (distance strtpt nextpt)
                                 sfe:anh (angle strtpt nextpt)))
    (sfe_m2))
    (if (and (= sfe:ohig_chk "1") ptd) (progn
                           (setq sfe:anv (+ sfe:anh (/ pi 2)))             
                           (setq pt4 (polar strtpt sfe:anv sfe:hgh))
                          (command "_.undo" "_m")
                              (setvar "osmode" 0)(setvar "blipmode" 0)
                              (sfe_ex)
                              (setq uctr (1+ uctr))
                              (setq ptd nil temp T))
    (sfe_m3))
    ;;(sfe_m4)
  )


  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)

  (princ)
)

(defun sfe_m1 ()
  (while temp
    (setvar "osmode" (+ 1 32 128))
    (setvar "blipmode" 1)
    (if (> uctr 0)
      (progn
        (princ (strcat "\nGap_size:" (rtos sfe:gap)

                       "\n창문 너비:"    (rtos sfe:wid)
                       "  창문 높이"   (rtos sfe:hgh)))
        (initget "/ Dialog Ofsfet Undo")
        (setq strtpt (getpoint
          "\n>>> Dialog/Ofsfet/Undo/<좌측 하단>: "))
      )
      (progn
        (initget "/ Dialog Ofsfet")
        (setq strtpt (getpoint
         "\n>>> Dialog/Ofsfet/<좌측 하단>: "))
      )
    )
    (cond
      ((= strtpt "Dialog")
        (DD_sfe)
      )
      ((= strtpt "Ofsfet")
        (cim_ofs)
      )
      ((= strtpt "/")
        (cim_help "sfe")
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

(defun sfe_m2 ()
  (while tem
    (setvar "blipmode" 1)
    (setvar "snapbase" (list (car strtpt) (cadr strtpt)))
    (initget "/ Dialog Undo")
    (setq nextpt (getpoint strtpt (strcat
      "\n>>> Dialog/Undo/<width:"
      (rtos sfe:wid) " Angle:" (angtos sfe:anh) ">: ")))
    (setvar "blipmode" 0)
    
    (cond
      ((= nextpt "Dialog")
        (DD_sfe)
      )
      ((= nextpt "/")
        (cim_help "sfe")
      )
      ((= nextpt "Undo")
        (setq tem nil temp T)
      )
      ((null nextpt)
        (setq tem nil ptd T)
      )
      (T
;;;        (if (< (distance strtpt nextpt) (* sfe:siz1 300))
;;;          (alert (strcat "Insufficient width -- Value is not less than"
;;;                   (rtos (* sfe:numc 300))))
          (setq tem     nil
                ptd     T
                sfe:wid (distance strtpt nextpt)
                sfe:anh (angle strtpt nextpt)
;;;          )
        )
      )
    )
  )
)

(defun sfe_m3 ()
  (while ptd
    (setvar "blipmode" 1)
    
    (initget "/ Dialog Undo")
    (setq pt3 (getpoint strtpt (strcat
      "\n>>> Dialog/Undo/<height:"
      (rtos sfe:hgh) " Angle:" (angtos sfe:anv) ">: ")))
    (setvar "blipmode" 0)
   
    (cond
   
      ((= pt3 "Dialog")
        (DD_sfe)
      )
      ((= pt3 "/")
        (cim_help "sfe")
      )
      ((= pt3 "Undo")
        (setq ptd nil tem T)
      )
      ((null pt3)
        (command "_.undo" "_m")
        (sfe_ex)
        (setq uctr (1+ uctr))
        (setq ptd nil temp T)
      )
      (T
;;;        (if (< (distance strtpt pt3) sfe:phg)
;;;          (alert (strcat "Insufficient height -- Value is not less than " (rtos (+ sfe:phg sfe:frwc))))
;;;          (progn
            (command "_.undo" "_m")
            (setq sfe:hgh (distance strtpt pt3)
                  sfe:anv (+ sfe:anh (/ pi 2))
            )
            (sfe_ex)
            (setq ptd nil temp T)
            
;;;          )
;;;        )
      )
    )
  )
)

(defun sfe_ex ( / dist1 tmpgap)
  (setvar "osmode" 0)
  (setq tmpgap (if (= sfe:gap_chk "0") 0 sfe:gap)
        pt1  strtpt
        pt2        (polar pt1 sfe:anh sfe:wid)
        pt4        (polar pt1 sfe:anv sfe:hgh)
        pt3  (polar pt2 sfe:anv sfe:hgh) 
        ang  sfe:anh
        ang1 (angle pt2 pt1)
        ang2 sfe:anv
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
  (if (and (/= sfe:gap 0) (/= sfe:gap_chk "0"))
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

      (set_col_lin_lay sfe:gprop)
      (command "_.LINE" pt1x pt2x "")
      (command "_.LINE" pt2y pt3y "")
      (command "_.LINE" pt3x pt4x "")
      (command "_.LINE" pt4y pt1y "")

    )
  )
 (set_col_lin_lay sfe:fprop)
  (command "_.pline" pt5 pt6 pt7 pt8 "_C")
 (setq pt5 (polar (polar pt5 ang sfe:frw) ang2 sfe:frw)
       pt6 (polar (polar pt6 ang1 sfe:frw) ang2 sfe:frw)
       pt7 (polar (polar pt7 ang1 sfe:frw) ang3 sfe:frw)
       pt8 (polar (polar pt8 ang sfe:frw) ang3 sfe:frw))
  
 (setq  pt9  (polar pt5  ang  (* sfe:frwc 0.6))
        pt9  (polar pt9  ang2 (* sfe:frwc 0.6))
        pt10 (polar pt9  ang  (- sfe:siz1 (/ sfe:frwc 2) sfe:frw))
        pt11 (polar pt10  ang2 (- sfe:hgh (* sfe:frw 2) (* sfe:frwc 1.2) (* tmpgap 2)))
        pt12 (polar pt11  ang1 (distance pt10 pt9))

        pt13  (polar pt6  ang1  (* sfe:frwc 0.6))
        pt13  (polar pt13  ang2 (* sfe:frwc 0.6))
        pt14 (polar pt13  ang1  (- sfe:siz2 (/ sfe:frwc 2) sfe:frw))
        pt15 (polar pt14  ang2 (- sfe:hgh (* sfe:frw 2) (* sfe:frwc 1.2) (* tmpgap 2)))
        pt16 (polar pt15  ang (distance pt10 pt9))
                    
        pt17 (polar pt11 ang2 (* sfe:frwc 0.6))
        pt18 (polar pt10 ang3 (* sfe:frwc 0.6))
        pt19 (polar pt17 ang sfe:frwc)
        pt20 (polar pt18 ang sfe:frwc)
        pt21 (polar pt15 ang2 (* sfe:frwc 0.6))
        pt22 (polar pt14 ang3 (* sfe:frwc 0.6))
        pt23 (polar pt21 ang1 sfe:frwc)
        pt24 (polar pt22 ang1 sfe:frwc)
  )
  
  
  (if (= sfe:typ "b")
    (command "_.pline" pt5 pt6 pt7 pt8 "_C")
    (cond ((= sfe:LRA "left")
           (command "_pline" pt5 pt18 pt17 pt8 "_C")(command "_pline" pt20 pt6 pt7 pt19 "_C"))
          ((= sfe:LRA "right")
           (command "_pline" pt5 pt24 pt23 pt8 "_C")(command "_pline" pt22 pt6 pt7 pt21 "_C"))
          (T
           (command "_pline" pt5 pt18 pt17 pt8 "_C")(command "_pline" pt22 pt6 pt7 pt21 "_C")
           (command "_pline" pt20 pt24 pt23 pt19 "_C"))))
  
   (set_col_lin_lay sfe:cprop)
  (if (= sfe:typ "b")
    (progn
    (if (/= sfe:LRA "left") (progn (command "_pline" pt14 pt13 pt16 pt15 "_c") (command "_line" pt23 pt24 "")) )
    (if (/= sfe:LRA "right") (progn (command "_pline" pt10 pt9 pt12 pt11 "_c") (command "_line" pt19 pt20 "")) )
    )
    (progn
      (if (/= sfe:LRA "left") (command "_pline" pt14 pt13 pt16 pt15 ""))
      (if (/= sfe:LRA "right") (command "_pline" pt10 pt9 pt12 pt11 "") )
  ))

    (if (= sfe:mark_chk "1")(progn
    (setq pp9 (polar pt17 ang3 (/ (distance pt17 pt18) 2))
          pp9 (polar pp9 ang1 (* (distance pt9 pt10) 0.1))
          pp10  (polar pt21 ang3 (/ (distance pt21 pt22) 2))
          pp10 (polar pp10 ang (* (distance pt14 pt13) 0.1)))
    
    (set_col_lin_lay sfe:mprop)
    (if (/= sfe:LRA "left")
    (command "_.solid" pp10 
                     (polar pp10 (- ang (/ pi 4)) (* (distance pt14 pt13)0.1))
                     (polar pp10 (+ ang (/ pi 4)) (* (distance pt14 pt13) 0.1))  "" ""))
    (if (/= sfe:LRA "right")
    (command "_.solid" pp9
                     (polar pp9 (- ang1 (/ pi 4)) (* (distance pt9 pt10) 0.1))
                     (polar pp9 (+ ang1 (/ pi 4)) (* (distance pt9 pt10) 0.1))  "" ""))
    
    ))
 
)

;;-----------------------------------------------------



(defun sfe_init ()

  (defun sfe_set (/ chnaged?)
    (PROP_SAVE sfe:prop)
  )

  ;;
  ;; Common properties for all entities
 
  (defun set_tile_props ()
    
    (set_tile "error" "")
    (set_tile sfe_prop_type "1")                ;; prop radio

    (@get_eval_prop sfe_prop_type sfe:prop)
    
    (set_tile sfe:LRA "1")
    (s_radio_do)
    
    (set_tile "tx_type" C_sfe_type)
    (set_tile (strcat sfe:typ "_type") "1")
          
    (set_tile "opn_mark" sfe:mark_chk)
    (set_tile "tg_gap_size" sfe:gap_chk)
    (mode_tile "ed_gap_size" (if (= sfe:gap_chk"1") 0 1)) 
    (set_tile "tg_opn_width" sfe:owid_chk)
    (mode_tile "ed_opn_width" (if (= sfe:owid_chk"1") 0 1)) 
    (set_tile "tg_opn_height" sfe:ohig_chk)
    (mode_tile "ed_opn_height" (if (= sfe:ohig_chk"1") 0 1)) 

    (set_tile "ed_gap_size" (rtos sfe:gap))
    (set_tile "f_size" (rtos sfe:frw))
    (set_tile "c_size" (rtos sfe:frwc))
    (set_tile "size_1" (rtos sfe:siz1))
    (set_tile "size_2" (rtos sfe:siz2))
    
    (set_tile "hght_2" (rtos sfe:phg))
    (set_tile "ed_opn_width" (rtos sfe:wid))
    (set_tile "ed_opn_height" (rtos sfe:hgh))

    (sfe_DrawImage "elev_image" T)
  )

  (defun set_action_tiles ()

    (action_tile "b_name"       "(@getlayer)(sfe_DrawImage \"elev_image\" T)")    
    (action_tile "b_color"      "(@getcolor)(sfe_DrawImage \"elev_image\" T)")
    (action_tile "color_image"  "(@getcolor)(sfe_DrawImage \"elev_image\" T)")
    (action_tile "b_line"       "(@getlin)(sfe_DrawImage \"elev_image\" T)")
    (action_tile "c_bylayer"    "(@bylayer_do T)(sfe_DrawImage \"elev_image\" T)")
    (action_tile "t_bylayer"    "(@bylayer_do nil)(sfe_DrawImage \"elev_image\" T)")

    (action_tile "bn_type"       "(ttest)")

    (action_tile "prop_radio" "(setq sfe_prop_type $Value)(@get_eval_prop sfe_prop_type sfe:prop)(sfe_DrawImage \"elev_image\" T)")
    
    (action_tile "a_type"       "(setq sfe:typ \"a\") (sfe_DrawImage \"elev_image\" T)")
    (action_tile "b_type"       "(setq sfe:typ \"b\") (sfe_DrawImage \"elev_image\" T)")
    (action_tile "opn_mark"         "(sfe:mark_chk_do)(sfe_DrawImage \"elev_image\" T)")
    
    (action_tile "left"                "(setq sfe:lra \"left\")(s_radio_do)(sfe_DrawImage \"elev_image\" T)")
    (action_tile "right"        "(setq sfe:lra \"right\")(s_radio_do)(sfe_DrawImage \"elev_image\" T)")
    (action_tile "all"                "(setq sfe:lra \"all\")(s_radio_do)(sfe_DrawImage \"elev_image\" T)")
    
    (action_tile "tg_gap_size"         "(radio_gaga \"gap\")")
    (action_tile "tg_opn_width" "(radio_gaga \"width\")")
    (action_tile "tg_opn_height" "(radio_gaga \"height\")")

    (action_tile "ed_gap_size"  "(getfsize $value \"ed_gap_size\")")
    (action_tile "f_size"       "(getfsize $value \"f_size\")")
    (action_tile "c_size"       "(getfsize $value \"c_size\")")
    (action_tile "size_1"       "(getfsize $value \"size_1\")")
    (action_tile "size_2"       "(getfsize $value \"size_2\")")
    
    (action_tile "ed_opn_width"       "(getfsize $value \"ed_opn_width\" )")
    (action_tile "ed_opn_height"       "(getfsize $value \"ed_opn_height\")")
    
    (action_tile "accept"       "(dismiss_dialog 1)")
    (action_tile "cancel"       "(dismiss_dialog 0)")
    (action_tile "help"         "(cim_help \"WN2\")")
    (action_tile "bn_type_save"   "(readF \"SfeType.dat\" nil)(ValueToList)(writeF \"SfeType.dat\" nil)")
  )

  (defun sfe:mark_chk_do ()
    (setq sfe:mark_chk (get_tile "opn_mark"))
;;;    (if (= sfe:mark_chk "1") (progn (mode_tile "a_type" 0) (mode_tile "b_type" 0))
;;;                         (progn (mode_tile "a_type" 1) (mode_tile "b_type" 1)))
    )
  (defun s_radio_do()
    (cond ((= sfe:lra "left") (mode_tile "size_2" 1)(mode_tile "size_1" 0)
           (set_tile "fix_size" (rtos (- sfe:wid sfe:siz1))))
          ((= sfe:lra "right") (mode_tile "size_1" 1)(mode_tile "size_2" 0)
           (set_tile "fix_size" (rtos (- sfe:wid sfe:siz2))))
          (T (mode_tile "size_1" 0)(mode_tile "size_2" 0)
           (set_tile "fix_size" (rtos (- sfe:wid sfe:siz1 sfe:siz2))))
          )
  )
  
  (defun radio_gaga (pushed)
    
    (cond 
      ((= pushed "gap")
        (setq sfe:gap_chk (get_tile "tg_gap_size"))(mode_tile "ed_gap_size" (if (= sfe:gap_chk "1") 0 1))
      )
      ((= pushed "width")
        (setq sfe:owid_chk (get_tile "tg_opn_width"))(mode_tile "ed_opn_width" (if (= sfe:owid_chk "1") 0 1))
      )
      ((= pushed "height")
        (setq sfe:ohig_chk (get_tile "tg_opn_height"))(mode_tile "ed_opn_height" (if (= sfe:ohig_chk "1") 0 1))
      ))
    
  )
  
  (defun getfsize (value tiles)
    (cond ((= tiles "ed_gap_size") 
              (setq sfe:gap (verify_d tiles value sfe:gap)))  
          ((= tiles "f_size")
           (setq sfe:frw (verify_d tiles value sfe:frw)))
          ((= tiles "c_size")
           (setq sfe:frwc (verify_d tiles value sfe:frwc)))
          ((= tiles "num_1")
           (setq sfe:numc (verify_d tiles value sfe:numc)))
          ((= tiles "hght_2")
           (setq sfe:phg (verify_d tiles value sfe:phg)))
          ((= tiles "ed_opn_width")
           (setq sfe:wid (verify_d tiles value sfe:wid)))
          ((= tiles "ed_opn_height")
           (setq sfe:hgh (verify_d tiles value sfe:hgh))) 
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
;; list _ box handle
(defun ttest (/ old_sfe_type)
 (readF "SfeType.dat" nil)
 (setq  old_sfe_type C_sfe_type)
 (setq L_index (Find_index old_sfe_type))
    (progn
      (setq zin_old (getvar "dimzin"))
      (setvar "dimzin" 8)
      (if (not (new_dialog "set_sfwintype_name" dcl_id)) (exit)) 
      (set_tile "title" "List of Entities")
      
      (list_view)
      (Set_tileS)
      (action_Tiles)
      (start_dialog)
      (setvar "dimzin" zin_old)
     ))

(defun set_tileS ()
 (if (= L_index nil) (setq L_index 0 ))
 (setq C_sfe_type (nth 0 (cdr (nth L_index @Type))))  
 (set_tile "list_type" (rtos L_index)) 
 (set_tile "current_type" old_sfe_type)
 (set_tile "ed_type_name" C_sfe_type) 
)
 
(defun action_Tiles ()
 (action_tile "list_type" "(setq C_sfe_type (Field_match \"타입명\" (setq L_index (atoi $value))))(set_tileS)")
 (action_tile "accept" "(qqqq)")
 (action_tile "cancel" "(setq C_sfe_type old_sfe_type)")
 (action_tile "eb_del_type" "(deleteIdx C_sfe_type)(set_tileS)")
 (action_tile "eb_ren_type" "(renameIdx C_sfe_type)(set_tileS)")
 (action_tile "eb_new_type" "(newIdx C_sfe_type)(set_tileS)")
)
(defun qqqq()
  (Set_sfe_Value)(writeF "SfeType.dat" nil)(done_dialog 1)(set_tile_props)
)
;; list _ box handle

) ; end wn2_init

(defun sfe_do ()
  (if (not (new_dialog "dd_sfwin" dcl_id)) (exit))
  (set_tile_props)
  (set_action_tiles)
  (setq dialog-state (start_dialog))
  (if (= dialog-state 0)
   (setq reset_flag t)
  )
)

(defun sfe_return ()
  
  (setq sfe:fprop  old_fprop
        sfe:cprop  old_cprop
        sfe:mprop  old_mprop
        sfe:gprop  old_gprop
      ;  sfe:typ  old_typ
        sfe:numc  old_num
        sfe:num  old_num2 
  )
)


(defun dd_sfe (/
           ci_lst           
           dcl_id       dialog-state     dismiss_dialog
           getfsize     old_num                old_typ           radio_gaga
           reset_flag        set_action_tiles set_tile_props   sortlist
           test_ok      tile 
           action_Tiles  qqqq   ttest   set_tileS   verify_d  ValueToList
           sfe_DrawImage
           drawSFwinImage_1 drawSFwinImage_2 drawSFwinImage_3 sfe:mark_chk_do s_radio_do)

(defun ValueToList(/ tmptype tmpwh tmplist tmm newlist)
 
  (setq tmplist (nth L_index @type))
  (setq tmptype (strcat (strcase sfe:typ) "-Type"))
  (setq tmpwh (strcat (strcase (substr sfe:lra 1 1)) (substr sfe:lra 2)))
    
  (setq tmm (list C_sfe_type tmptype tmpwh (rtos sfe:wid) (rtos sfe:hgh)
                  (rtos sfe:siz1) (rtos sfe:siz2) (rtos sfe:frw) (rtos sfe:frwc)
                  (rtos sfe:gap) sfe:gap_chk sfe:owid_chk sfe:ohig_chk sfe:mark_chk))
  (setq newlist (cons (1+ L_index) tmm))
  (setq @type (subst newlist tmplist @Type) )
)
  (setvar "cmdecho" (cond (  (or (not *debug*) (zerop *debug*)) 0)
                          (t 1)))

  (setq old_fprop  sfe:fprop
        old_cprop  sfe:cprop
        old_mprop  sfe:mprop
        old_gprop  sfe:gprop
        old_num  sfe:numc
        old_num2  sfe:num
  )

  (princ ".")
  (cond
     (  (not (setq dcl_id (Load_dialog "WINELEV.dcl"))))   ; is .DLG file loaded?

     (t (ai_undo_push)
        (princ ".")
        (sfe_Draw_Image_X)
        (sfe_init)                              ; everything okay, proceed.
        (princ ".")
        (sfe_do)
     )
  )
  (if reset_flag
    (sfe_return)
    (sfe_set)
  )
  (if dcl_id (unload_dialog dcl_id))
)


(defun Set_sfe_Value(/ tnnp ttmpp1)
 
 
  (setq sfe:typ (strcase (substr (Field_match "창문타입" L_index) 1 1) T))
  (setq sfe:LRA (strcase (Field_match "열림위치" L_index) T))
  (setq sfe:wid (atof (Field_match "width" L_index) ))
  (setq sfe:hgh (atof (Field_match "height" L_index)))
  ;(setq sfe:num (atoi (Field_match "project_num" L_index))) 
  ;(setq sfe:phg (atof (Field_match "sliding_height" L_index)))
  (setq sfe:gap (atof (Field_match "gap_sizes" L_index)))
  (setq sfe:frw (atof (Field_match "frame_size" L_index)))
  (setq sfe:frwc  (atof (Field_match "case_size" L_index)))
  ;(setq sfe:numc (atoi (Field_match "case_num" L_index)))
  (setq sfe:siz1 (atof (Field_match "left_size" L_index)))
  (setq sfe:siz2 (atof (Field_match "right_size" L_index)))
  (setq sfe:gap_chk  (Field_match "gap_chk" L_index))
  (setq sfe:owid_chk (Field_match "opnwid_chk" L_index))
  (setq sfe:ohig_chk (Field_match "opnhig_chk" L_index))
  (setq sfe:mark_chk (Field_match "mark_chk" L_index))
)
(if (null C_sfe_type)
   (progn
   (setq sfe:fprop  (Prop_search "sfe" "frame"))
   (setq sfe:cprop  (Prop_search "sfe" "casement"))
   (setq sfe:mprop  (Prop_search "sfe" "open_mark"))
   (setq sfe:gprop  (Prop_search "sfe" "outline"))
   (setq sfe:prop '(sfe:fprop sfe:cprop sfe:mprop sfe:gprop))
   (readF "SfeType.dat" nil) (setq L_index 0)
   (setq C_sfe_type (nth 0 (cdr (nth L_index @Type))))
   (Set_sfe_Value)
)) 


(if (null sfe:gap) (setq sfe:gap window_gap))
(if (null sfe:wid) (setq sfe:wid 2400))
(if (null sfe:anh) (setq sfe:anh 0))
(if (null sfe:anv) (setq sfe:anv (/ pi 2)))
(if (null sfe:hgh) (setq sfe:hgh 1800))
(if (null sfe:phg) (setq sfe:phg 400))
(if (null sfe:frwc) (setq sfe:frwc 50))

(if (null sfe:fprop) (setq sfe:fprop (list "sfe" "frame" "WINELEV" "6" "CONTINUOUS" "1" "1")))
(if (null sfe:cprop) (setq sfe:cprop (list "sfe" "casement" "WINELEV" "6" "CONTINUOUS" "1" "1")))
(if (null sfe:mprop) (setq sfe:mprop (list "sfe" "open_mark" "WINELEV" "6" "CONTINUOUS" "1" "1")))
(if (null sfe:gprop) (setq sfe:gprop (list "sfe" "outline" "WINELEV" "6" "CONTINUOUS" "1" "1")))

(if (null sfe_prop_type) (setq sfe_prop_type "rd_frame"))
(if (null sfe:mark_chk) (setq sfe:mark_chk "1"))
(if (null sfe:gap_chk) (setq sfe:gap_chk "0"))
(if (null sfe:owid_chk) (setq sfe:owid_chk "1"))
(if (null sfe:ohig_chk) (setq sfe:ohig_chk "1"))

(if (null sfe:frw) (setq sfe:frw 40))
(if (null sfe:numc) (setq sfe:numc 2))

(if (null sfe:siz1) (setq sfe:siz1 600))
(if (null sfe:siz2) (setq sfe:siz2 600))
(if (null sfe:lra) (setq sfe:lra "left"))


(defun C:cimsfe () (m:sfe))
(setq lfn31 1)
(princ)
