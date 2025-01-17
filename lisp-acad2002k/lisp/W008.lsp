; 작업날짜: 2001년 8월 13일
; 작업자: 박율구
; 명령어: CIM2DE

; 2Door Elevation loaded. Start command with CIM2DE.
;
(setq lfn35 1)

(defun m:2de (/ bm       osm
                ang      ang1     ang2     ang3     sc       pt1      pt2
                pt3      pt4      pt5      pt6      pt7      pt8      pt9
                pt10     pt11     pt12     pt13     pt14     pt15     pt16
                pt17     pt18     pt19     pt20     pt21     pt22     pt1x
                pt1y     pt2x     pt2y     pt3x     pt3y     pt4x     pt4y
                pt15x    pt16x    fnt      ptd
                strtpt   nextpt   uctr     cont     temp     tem
                2de_ola  2de_oco  2de_err  2de_oer  2de_oli)

  (setq 2de_oco (getvar "cecolor")
        2de_ola (getvar "clayer")
        2de_oli (getvar "celtype")
        sc      (getvar "dimscale")
        bm      (getvar "blipmode")
        osm     (getvar "osmode")
  )
  
  ;;
  ;; Internal error handler defined locally
  ;;
  (defun 2de_err (s)                   ; If an error (such as CTRL-C) occurs
                                       ; while this command is active...
    (if (/= s "Function cancelled")
      (if (= s "quit / exit abort")
        (princ)
        (princ (strcat "\nError: " s))
      )
    )
    (setvar "cmdecho" 0)
    (if 2de_oer                        ; If an old error routine exists
      (setq *error* 2de_oer)           ; then, reset it 
    )
    
    (setvar "blipmode" 1)
    (setvar "snapbase" '(0 0))
    (command "_.undo" "_en")
    (ai_undo_off)
    
    (setvar "cecolor" 2de_oco)
    (setvar "clayer" 2de_ola)
    (setvar "celtype" 2de_oli)
    (setvar "blipmode" bm)
    (setvar "osmode" osm)
    (setvar "cmdecho" 1)
    (princ)
  )
  ;; Set our new error handler
  (if (not *DEBUG*)
    (if *error*                     
      (setq 2de_oer *error* *error* 2de_err) 
      (setq *error* 2de_err) 
    )
  )

  (setvar "cmdecho" 0)
  ;(ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")

  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n쌍여닫이 문(입면)을 그리는 명령입니다.")
  
  (setq cont T temp T uctr 0)

  (while cont
    (2de_m1)
    (2de_m2)
    (2de_m3)
  )
  
  (command "_.undo" "_en")
  (ai_undo_off)

  (setvar "cecolor" 2de_oco)
  (setvar "clayer" 2de_ola)
  (setvar "celtype" 2de_oli)
  (setvar "osmode" osm)
  (setvar "blipmode" bm)
  (setvar "cmdecho" 1)
  (princ)
) ; end m:2de

(defun 2de_m1 ()
  (while temp
    (setq strtpt nil nextpt nil pt3 nil)
    (setvar "osmode" 167)
    (setvar "blipmode" 0)
    (if (> uctr 0)
      (progn
        (initget "Dialog Offset Undo")
        (setq strtpt (getpoint
          "\n>>> Dialog/Offset/Undo/<좌측 하단>: "))
      )
      (progn
        (initget "Dialog Offset")
        (setq strtpt (getpoint
          "\n>>> Dialog/Offset/<좌측 하단>: "))
      )
    )
    (cond
      ((= strtpt "Dialog")
        (2de_dd)
      )
      ((= strtpt "Offset")
        (my_cim_ofs)
      )
      ((= strtpt "Undo")
        (command "_.undo" "_b")
        (setq uctr (1- uctr))
      )
      ((null strtpt)
        (setq cont nil temp nil tem nil ptd nil) ; end
      )
      (T
        (cond ((= 2de_check 0)(setq temp nil tem T   ptd T  ))
              ((= 2de_check 1)(setq temp nil tem nil ptd T  ))
              ((= 2de_check 2)(setq temp nil tem T   ptd nil))
              ((= 2de_check 3)(setq temp T   tem nil ptd nil)
               (command "_.undo" "_m")
               (2de_ex)
               (setq uctr (1+ uctr))
              )
        )
      )
    )
  )
  (setvar "osmode" 0)
)
(defun 2de_m2 ()
  (while tem
    (setvar "osmode" 167)
    (setvar "blipmode" 1)
    ;(setvar "snapbase" (list (car strtpt) (cadr strtpt)))
    (initget "Undo")
    (setq nextpt (getpoint strtpt (strcat
      "\n>>> Undo/<width:"
      (rtos 2de:wid) " Angle:" (angtos 1de:ang) ">: ")))
    (setvar "blipmode" 0)
    ;(setvar "snapbase" '(0 0))
    (cond
      ((= nextpt "Undo")
        (setq temp T tem nil ptd nil)
      )
      ((null nextpt)
       (cond ((= 2de_check 0)(setq temp T tem nil    ptd T  ))
              ;((= 2de_check 1)                               )
              ((= 2de_check 2)(setq temp T tem nil  ptd nil)
               (command "_.undo" "_m")
               (2de_ex)
               (setq uctr (1+ uctr))
              )
              ;((= 2de_check 3)                               )
        )
      )
      (T
        (if (< (distance strtpt nextpt) 600)
          (alert "Insufficient width -- Value is not less than 600")
          (cond ((= 2de_check 0)(setq temp T tem nil  ptd T)
                 (setq 2de:wid (distance strtpt nextpt)
                       1de:ang (angle    strtpt nextpt)
                 )   
                )
                ;((= 2de_check 1)                             )
                ((= 2de_check 2)(setq temp T tem nil  ptd nil)
                 (setq 2de:wid (distance strtpt nextpt)
                       1de:ang (angle    strtpt nextpt)
                 )
                 (command "_.undo" "_m")      
                 (2de_ex)
                 (setq uctr (1+ uctr))
                )
                ;((= 2de_check 3)(setq temp nil tem nil ptd nil))
          )
        )
      )
    )
  )
)

(defun 2de_m3 ()
  (while ptd
    (setvar "osmode" 167)
    (setvar "blipmode" 1)
    ;(setvar "snapbase" (list (car strtpt) (cadr strtpt)))
    (initget "Undo")
    (setq pt3 (getdist strtpt (strcat
      "\n>>> Undo/<height:"
      (rtos 1de:hgh) ">: ")))
    (setvar "blipmode" 0)
    ;(setvar "snapbase" '(0 0))
    (cond
      ((= pt3 "Undo")
       (cond ((= 2de_check 0)(setq temp nil tem T   ptd nil))
             ((= 2de_check 1)(setq temp T   tem nil ptd nil))
             ;((= 2de_check 2)                              )
             ;((= 2d3_check 3)                              )
       )
      )
      ((null pt3)
        (command "_.undo" "_m")
        (2de_ex)
        (setq uctr (1+ uctr))
        (setq ptd nil temp T)
      )
      (T
        (if (< pt3 200)
          (alert "Insufficient height -- Value is not less than 200")
          (progn
            (setq temp T ptd nil)
            (setq 1de:hgh pt3)
            (command "_.undo" "_m")
            (2de_ex)
            (setq uctr (1+ uctr))
          )  
        )
      )
    )
  )
)
(defun my_cim_ofs ()
  (setvar "osmode" 167)
  (initget 1)
  (setq strtpt2 (getpoint "\nOffset from: "))
  (initget 1)
  (setq nextpt2 (getpoint strtpt2 "\nOffset toward: "))
  (setq dist (getdist strtpt2 (strcat
    "\nEnter the offset distance <" (rtos (distance strtpt2 nextpt2)) ">: ")))
  (setq dist (if (or (= dist "") (null dist))
               (distance strtpt2 nextpt2)
               (if (< dist 0)
                 (* (distance strtpt2 nextpt2) (/ (abs dist) 100.0))
                 dist
               )
             )
  )
  (setq temp T)
  (setvar "osmode" 0)
)
(defun 2de_dd(/ dcl_id)
  (setq old:fprop 2de:fprop old:oprop 2de:oprop old:uprop 2de:uprop)
  (setq cancel_check nil); cancel button init
  (setq dcl_id (ai_dcl "de"))
  (if (not (new_dialog "dd_de" dcl_id)) (exit))

  (set_tile 2de_prop_type "1")
  (@get_eval_prop 2de_prop_type 2de:prop)
  
  (set_tile "ed_gap" (itoa 1de:gap))
  (set_tile "ed_frame" (itoa 1de:fra))
  (set_tile "ed_finish" (itoa 1de:fin))
  (setq 2de:wid (fix 2de:wid)
        1de:hgh (fix 1de:hgh)
  )
  (set_tile "ed_open_width" (itoa 2de:wid))
  (set_tile "ed_open_height" (itoa 1de:hgh))
  (if (= out_check nil)
    (progn
      (set_tile "tg_gap" "0")
      (mode_tile "ed_gap" 1)
    )
    (progn
      (set_tile "tg_gap" "1")
      (mode_tile "ed_gap" 0)
    )
  )
  (if (= 1de:ths "ON")(set_tile "tg_threshold" "1")(set_tile "tg_threshold" "0"))
  (cond ((= 2de_check 0)
         (set_tile "tg_open_width" "0")(mode_tile "ed_open_width" 1)
         (set_tile "tg_open_height" "0")(mode_tile "ed_open_height" 1)
        )
        ((= 2de_check 1)
         (set_tile "tg_open_width" "1")(mode_tile "ed_open_width" 0)
         (set_tile "tg_open_height" "0")(mode_tile "ed_open_height" 1)
        )
        ((= 2de_check 2)
         (set_tile "tg_open_width" "0")(mode_tile "ed_open_width" 1)
         (set_tile "tg_open_height" "1")(mode_tile "ed_open_height" 0)
        )
        ((= 2de_check 3)
         (set_tile "tg_open_width" "1")(mode_tile "ed_open_width" 0)
         (set_tile "tg_open_height" "1")(mode_tile "ed_open_height" 0)
        )
  )
  (mode_tile "tg_door_width" 1)
  (mode_tile "ed_door_width" 1)
  (mode_tile "tg_door_height" 1)
  (mode_tile "ed_door_height" 1)
  (ci_image "door_type" "al_door(2de)")
  (cond ((= door_ring1 T)(ci_image "door_ring" "al_door(doorhandle1)"))
        ((= door_ring2 T)(ci_image "door_ring" "al_door(doorhandle2)"))
        ((= door_ring3 T)(ci_image "door_ring" "al_door(doorhandle3)"))
        ((= door_ring4 T)(ci_image "door_ring" "al_door(doorhandle4)"))
        ((= door_ring5 T)(ci_image "door_ring" "al_door(doorhandle5)"))
        (T (ci_image "door_ring" "al_door(doorhandle1)")(setq door_ring1 T))
  )

  (action_tile "b_color" "(@getcolor)")
  (action_tile "color_image" "(@getcolor)")
  (action_tile "b_line" "(@getlin)")
  (action_tile "b_name" "(@getlayer)")
  (action_tile "c_bylayer" "(@bylayer_do T)")
  (action_tile "t_bylayer" "(@bylayer_do nil)")
  (action_tile "rd_attribute" "(setq 2de_prop_type $value)(@get_eval_prop 2de_prop_type 2de:prop)")
  
  (action_tile "tg_gap" "(enable_ed_gap)")
  (action_tile "bn_door" "(door_select)")
  (action_tile "tg_open_width" "(enable_ed_open_width)")
  (action_tile "tg_open_height" "(enable_ed_open_height)")
  (action_tile "accept" "(press_ok4)")
  (action_tile "cancel" "(setq cancel_check T)(done_dialog)")
  (start_dialog)
  (done_dialog)
  (if (= cancel_check T)
    (setq 2de:fprop old:fprop 2de:oprop old:oprop 2de:uprop old:uprop)
  )
)

;======================door handle select routine start===========================
(defun door_select()
  (if (not (new_dialog "dd_de_sub" dcl_id)) (exit))
  (ci_image "door1" "al_door(doorhandle1)")
  (ci_image "door2" "al_door(doorhandle2)")
  (ci_image "door3" "al_door(doorhandle3)")
  (ci_image "door4" "al_door(doorhandle4)")
  (ci_image "door5" "al_door(doorhandle5)")
  (cond ((= door_ring1 T) (mode_tile "door1" 2)(setq old_ring 1))
        ((= door_ring2 T) (mode_tile "door2" 2)(setq old_ring 2))
        ((= door_ring3 T) (mode_tile "door3" 2)(setq old_ring 3))
        ((= door_ring4 T) (mode_tile "door4" 2)(setq old_ring 4))
        ((= door_ring5 T) (mode_tile "door5" 2)(setq old_ring 5))
  )        
  (action_tile "door1" "(dh1)")
  (action_tile "door2" "(dh2)")
  (action_tile "door3" "(dh3)")
  (action_tile "door4" "(dh4)")
  (action_tile "door5" "(dh5)")
  (action_tile "cancel" "(reset_door)")
  (action_tile "accept" "(set_door)")
  (start_dialog)
)
(defun set_door()
  (done_dialog)
  (cond ((= door_ring1 T)(ci_image "door_ring" "al_door(doorhandle1)"))
        ((= door_ring2 T)(ci_image "door_ring" "al_door(doorhandle2)"))
        ((= door_ring3 T)(ci_image "door_ring" "al_door(doorhandle3)"))
        ((= door_ring4 T)(ci_image "door_ring" "al_door(doorhandle4)"))
        ((= door_ring5 T)(ci_image "door_ring" "al_door(doorhandle5)"))
  )
)  
(defun reset_door()
  (setq door_ring1 nil door_ring2 nil door_ring3 nil
        door_ring4 nil door_ring5 nil 
  )
  (cond ((= old_ring 1)(setq door_ring1 T))
        ((= old_ring 2)(setq door_ring2 T))
        ((= old_ring 3)(setq door_ring3 T))
        ((= old_ring 4)(setq door_ring4 T))
        ((= old_ring 5)(setq door_ring5 T))
  )
  (done_dialog)
)                
(defun dh1()
  (setq door_ring1 nil door_ring2 nil door_ring3 nil
        door_ring4 nil door_ring5 nil 
  )
  (setq door_ring1 T)
)
(defun dh2()
  (setq door_ring1 nil door_ring2 nil door_ring3 nil
        door_ring4 nil door_ring5 nil 
  )
  (setq door_ring2 T)
)
(defun dh3()
  (setq door_ring1 nil door_ring2 nil door_ring3 nil
        door_ring4 nil door_ring5 nil 
  )
  (setq door_ring3 T)
)
(defun dh4()
  (setq door_ring1 nil door_ring2 nil door_ring3 nil
        door_ring4 nil door_ring5 nil 
  )
  (setq door_ring4 T)
)
(defun dh5()
  (setq door_ring1 nil door_ring2 nil door_ring3 nil
        door_ring4 nil door_ring5 nil 
  )
  (setq door_ring5 T)
)
;======================door handle select routine end==============================
(defun press_ok4(/ err_cnt)
  (setq err_cnt 0)
  (PROP_SAVE 2de:prop)
  (if (< (atoi (get_tile "ed_open_width")) 600) ;(< (distance strtpt nextpt) 600)
    (alert "Insufficient open width -- Value is not less than 600")
    (setq err_cnt (+ err_cnt 1))
  )
  (if (< (atoi (get_tile "ed_open_height")) 200)
    (alert "Insufficient open height -- Value is not less than 200")
    (setq err_cnt (+ err_cnt 1))
  )
  (if (= (get_tile "tg_gap") "0")(setq out_check nil)(setq out_check T))

  (setq 2de_check 0)
  (if (= (get_tile "tg_open_width") "1")(setq 2de_check (+ 2de_check 1)))
  (if (= (get_tile "tg_open_height") "1")(setq 2de_check (+ 2de_check 2)))

  (if (= (get_tile "tg_threshold") "0")(setq 1de:ths "OFf")(setq 1de:ths "ON"))
  (if (= err_cnt 2)
    (progn
       (setq 1de:gap (atoi (get_tile "ed_gap"))
             1de:fra (atoi (get_tile "ed_frame"))
             1de:fin (atoi (get_tile "ed_finish"))
             1de:ang 0
             2de:wid (atoi (get_tile "ed_open_width"))
             1de:hgh (atoi (get_tile "ed_open_height"))
        )
        (done_dialog)
    )
  )
)
(defun enable_ed_gap()
  (if (/= (get_tile "tg_gap") "0")
    (mode_tile "ed_gap" 0)
    (mode_tile "ed_gap" 1)
  )
)
(defun enable_ed_open_width()
  (if (/= (get_tile "tg_open_width") "0")
    (mode_tile "ed_open_width" 0)
    (mode_tile "ed_open_width" 1)
  )
)
(defun enable_ed_open_height()
  (if (/= (get_tile "tg_open_height") "0")
    (mode_tile "ed_open_height" 0)
    (mode_tile "ed_open_height" 1)
  )  
)  

(defun 2de_ex ()
  (setvar "osmode" 0)
  (if (and (/= dist nil) (/= dist 0)) (setq strtpt (polar strtpt (angle strtpt2 nextpt2) dist)))
  (setq pt1  strtpt
        pt2 (polar pt1 1de:ang 2de:wid)
        fnt  (if (= 1de:gap 0)
               0
               1de:fin
             )
        ang  1de:ang
        ang1 (angle pt2 pt1)
        ang2 (dtr 90)
        ang3 (dtr 270)
        pt3  (polar pt2  ang2 1de:hgh)
        pt4  (polar pt1  ang2 1de:hgh)
        pt5  (polar pt1  ang  1de:gap)
        pt6  (polar pt5  ang2 (- 1de:hgh 1de:gap))
        pt7  (polar pt6  ang  (- 2de:wid (* 2 1de:gap)))
        pt8  (polar pt7  ang3 (- 1de:hgh 1de:gap))
        pt9  (polar pt8  ang1 1de:fra)
        pt10 (polar pt9  ang2 (- 1de:hgh (+ 1de:gap 1de:fra)))
        pt11 (polar pt10 ang1 (- 2de:wid (+ (* 2 1de:gap) (* 2 1de:fra))))
        pt12 (polar pt11 ang3 (- 1de:hgh (+ 1de:gap 1de:fra)))
        pt13 (polar pt1  ang2 fnt)
        pt13 (polar pt13 ang1 (* sc 5))
        pt14 (polar pt2  ang2 fnt)
        pt14 (polar pt14 ang  (* sc 5))
  )
  (if (= 1de:ths "OFf")
    (setq pt15 (polar pt12 ang2 (+ fnt 10))
          pt16 (polar pt9  ang2 (+ fnt 10))
    )
    (setq pt15  (polar pt12 ang2 (+ fnt 20))
          pt16  (polar pt9  ang2 (+ fnt 20))
          pt15x (polar pt12 ang2 (- fnt 20))
          pt16x (polar pt9  ang2 (- fnt 20))
    )
  )
  (setq pt17 (polar pt15 ang2 (/ (distance pt11 pt15) 2.0))
        pt18 (polar pt11 ang  (/ (distance pt10 pt11) 2.0))
        pt19 (polar pt16 ang2 (/ (distance pt10 pt16) 2.0))
        pt20 (polar pt15 ang  (/ (distance pt15 pt16) 2.0))
        pt21 (polar pt20 ang2 (if (>= (/ 1de:hgh 2) 1000)
                                990
                                (/ 1de:hgh 2)
                              )
             )
        pt21 (polar pt21 ang1 60)
        pt22 (polar pt21 ang  120)
  )
  (if (/= 1de:gap 0)
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
      ; draw "outline"
      (if (= out_check T)
        (progn
          (set_col_lin_lay 2de:uprop)
          (command "_.LINE" pt1x pt2x "")
          (command "_.LINE" pt2y pt3y "")
          (command "_.LINE" pt3x pt4x "")
          (command "_.LINE" pt4y pt1y "")
          (command "_.LINE" pt13 pt14 "")
        )
      )        
    )
  )
  ;draw "open mark"
  (set_col_lin_lay 2de:oprop)
  (command "_.pline" pt17 pt18 pt19 pt20 "_c")
  
  ; draw "frame"
  (set_col_lin_lay 2de:fprop)
  (command "_.pline" pt5 pt6 pt7 pt8 pt9 pt10 pt11 pt12 "_C")
  (command "_.line" pt15 pt16 "")
  (command "_.line" pt18 pt20 "")
  (if (and (= 1de:ths "ON") (/= 1de:gap 0))
    (command "_.line" pt15x pt16x "")
  )
  (if (= 1de:gap 0)
    (command "_.line" pt12 pt9 "")
  )
  ; draw "door handle"
  (setq mirror_pt1 pt18 mirror_pt2 pt20)
  (setq pt18 pt21)
  (cond ((= door_ring1 T)
         (command "_.circle" pt18 40)
         (command "_.circle" pt18 30)
         (command "_.circle" pt18 15)
         (command "_.circle" pt22 40)
         (command "_.circle" pt22 30)
         (command "_.circle" pt22 15)
        )
        ((= door_ring2 T)
         (setq pt18_tem (polar pt18   (dtr 180) 50))
         (setq pt18_1 (polar pt18_tem (dtr 90)  150))
         (setq pt18_2 (polar pt18_1 (dtr 0)   100))
         (setq pt18_3 (polar pt18_2 (dtr 270) 300))
         (setq pt18_4 (polar pt18_3 (dtr 180) 100))
         (command "_.pline" pt18_1 pt18_2 pt18_3 pt18_4 "_C")
         (setq set_last (ssget "L"))
         (command "_.mirror" (ssget "L") "" mirror_pt1 mirror_pt2 "")
        ) 
        ((= door_ring3 T)
         (setq pt18_1 (polar pt18   (dtr 90)  100))
         (setq pt18_2 (polar pt18_1 (dtr 0)   28))
         (setq pt18_3 (polar pt18_2 (dtr 270) 200))
         (setq pt18_4 (polar pt18_3 (dtr 180) 28))
         (command "_.pline" pt18_1 pt18_2 pt18_3 pt18_4 "_C")
         (setq set_last (ssget "L"))
         (command "_.mirror" (ssget "L") "" mirror_pt1 mirror_pt2 "")
        )
        ((= door_ring4 T)
         (setq pt18_1 (polar pt18   (dtr 90)  100))
         (setq pt18_2 (polar pt18_1 (dtr 0)   28))
         (setq pt18_3 (polar pt18_2 (dtr 270) 228))
         (setq pt18_4 (polar pt18_3 (dtr 180) 528))
         (setq pt18_5 (polar pt18_4 (dtr 90)  28))
         (setq pt18_6 (polar pt18_5 (dtr 0)   500))
         (command "_.pline" pt18_1 pt18_2 pt18_3 pt18_4 pt18_5 pt18_6 "_C")
         (setq set_last (ssget "L"))
         (command "_.mirror" (ssget "L") "" mirror_pt1 mirror_pt2 "")
        )
        ((= door_ring5 T)
         (setq pt18_tem (polar pt18 (dtr 180)  130))
         (setq pt18_1 (polar pt18_tem (dtr 90)  75))
         (setq pt18_2 (polar pt18_1 (dtr 0)   150))
         (setq pt18_3 (polar pt18_2 (dtr 270) 150))
         (setq pt18_4 (polar pt18_3 (dtr 180) 150))
         (command "_.pline" pt18_1 pt18_2 pt18_3 pt18_4 "_C")
         (setq set_last (ssget "L"))
         (command "_.mirror" (ssget "L") "" mirror_pt1 mirror_pt2 "")
        )
  ); end draw "door handle"
)

(if (null 1de:gap) (setq 1de:gap 10))
(if (null 1de:fra) (setq 1de:fra 40))
(if (null 2de:wid) (setq 2de:wid 1800))
(if (null 1de:ang) (setq 1de:ang 0))
(if (null 1de:hgh) (setq 1de:hgh 2200))
(if (null 1de:fin) (setq 1de:fin 30))
(if (null 2de_check)(setq 2de_check 3))
(if (not (member 1de:ths '("ON" "OFf"))) (setq 1de:ths "OFf"))
; door handle init
(cond ((= door_ring1 T) )
      ((= door_ring2 T) )
      ((= door_ring3 T) )
      ((= door_ring4 T) )
      ((= door_ring5 T) )
      (T (setq door_ring1 T))
)

(setq 2de:fprop (Prop_search "2de" "frame"))
(setq 2de:oprop (Prop_search "2de" "open"))
(setq 2de:uprop (Prop_search "2de" "outline"))
(setq 2de:prop '(2de:fprop 2de:oprop 2de:uprop))

(if (null 2de_prop_type) (setq 2de_prop_type "rd_frame"))

(defun C:CIM2DE () (m:2de))
;(cad_lock)
;(princ "\n\tC:2Door Elevation loaded. Start command with 2DE. ")
(princ)

