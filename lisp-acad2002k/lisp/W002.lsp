; 작업일자: 2001.8.13
; 작업자: 박율구
; 명령어: CIM1DT
;
; 1Door with Transom elevation loaded. Start command with CIM1DT.
;
;단축키 관련 변수 정의 부분
(setq lfn23 1)

(defun m:1dt (/ bm    osm
             ang1     ang2     ang3     sc       ang1     ang3     pt1
             pt2      pt3      pt4      pt5      pt6      pt7      pt8
             pt9      pt10     pt11     pt12     pt13     pt14     pt15
             pt16     pt17     pt18     pt1x     pt1y     pt2x     pt2y
             pt3x     pt3y     pt4x     pt4y     pt10x    pt11x    pt15x
             pt16x    ptd      pte
             strtpt   nextpt   uctr     cont     temp     tem
             1dt_ola  1dt_oco  1dt_err  1dt_oer  1dt_oli)

  (setq 1dt_oco (getvar "cecolor")
        1dt_ola (getvar "clayer")
        1dt_oli (getvar "celtype")
        sc      (getvar "dimscale")
        bm      (getvar "blipmode")
        osm     (getvar "osmode")
  )
  
  ;;
  ;; Internal error handler defined locally
  ;;
  (defun 1dt_err (s)                   ; If an error (such as CTRL-C) occurs
                                       ; while this command is active...
    (if (/= s "Function cancelled")
      (if (= s "quit / exit abort")
        (princ)
        (princ (strcat "\nError: " s))
      )
    )
    (setvar "cmdecho" 0)
    (if 1dt_oer                        ; If an old error routine exists
      (setq *error* 1dt_oer)           ; then, reset it 
    )
    (setvar "cecolor" 1dt_oco)
    (setvar "clayer" 1dt_ola)
    (setvar "celtype" 1dt_oli)
    
    (setvar "blipmode" 1)
    (setvar "snapbase" '(0 0))
    (command "_.undo" "_en")
    (ai_undo_off)
    (setvar "cmdecho" 1)
    (setvar "blipmode" bm)
    (setvar "osmode" osm)
    (princ)
  )
  ;; Set our new error handler
  (if (not *DEBUG*)
    (if *error*                     
      (setq 1dt_oer *error* *error* 1dt_err) 
      (setq *error* 1dt_err) 
    )
  )
  (setvar "cmdecho" 0)
  
  (ai_undo_on)
  (command "_.undo" "_group")


  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n채광창이 있는 외여닫이 문(입면)을 그리는 명령입니다.")

  (setq cont T temp T uctr 0)

  (while cont
    (1dt_m1)
    (1dt_m2)
    (1dt_m3)
    (1dt_m4)
  )
  
  (command "_.undo" "_en")
  (ai_undo_off)
  
  (setvar "cecolor" 1dt_oco)
  (setvar "clayer" 1dt_ola)
  (setvar "celtype" 1dt_oli)
  (setvar "cmdecho" 1)
  (setvar "blipmode" bm)
  (setvar "osmode" osm)
  (princ)
) ; end m:1dt

(defun 1dt_m1 ()
  (while temp
    (setq strtpt nil nextpt nil hgh nil dhg nil)
    (setvar "osmode" 167)
    (setvar "blipmode" 1)
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
    (setvar "blipmode" 0)
    (cond
      ((= strtpt "Dialog")
        (1dt_dd)
      ) 
      ((= strtpt "Offset")
        (my_cim_ofs)
      )
      ((= strtpt "Undo")
        (command "_.undo" "_b")
        (setq uctr (1- uctr))
      )
      ((null strtpt)
       (setq cont nil temp nil tem nil ptd nil pte nil) ; end              
      )
      (T
       (cond ((= 1dt_check 0)(setq temp nil tem T   ptd T   pte T  ))
             ((= 1dt_check 1)(setq temp nil tem nil ptd T   pte T  ))
             ((= 1dt_check 2)(setq temp nil tem T   ptd nil pte T  ))
             ((= 1dt_check 3)(setq temp nil tem nil ptd nil pte T  ))
             ((= 1dt_check 4)(setq temp nil tem T   ptd T   pte nil))
             ((= 1dt_check 5)(setq temp nil tem nil ptd T   pte nil))
             ((= 1dt_check 6)(setq temp nil tem T   ptd nil pte nil))
             ((= 1dt_check 7)(setq temp T   tem nil ptd nil pte nil)
              (command "_.undo" "_m")
              (1dt_ex)
              (setq uctr (1+ uctr))
             )
       )   
      )
    )
  )
)
(defun 1dt_m2 ()
  (while tem
    (setvar "osmode" 167)
    (setvar "blipmode" 1)
    ;(setvar "snapbase" (list (car strtpt) (cadr strtpt)))
    (initget "Undo")
    (setq nextpt (getpoint strtpt (strcat
      "\n>>> Undo/<width:"
      (rtos 1de:wid) " Angle:" (angtos 1de:ang) ">: ")))
    (setvar "blipmode" 0)
    ;(setvar "snapbase" '(0 0))
    (cond
      ((= nextpt "Undo")
        (setq temp T tem nil ptd nil pte nil)
      )
      ((null nextpt)
        ;(setq tem nil ptd T)
       (cond ((= 1dt_check 0)(setq temp T tem nil ptd T   pte T  ))
             ;((= 1dt_check 1)(setq temp nil tem nil ptd T   pte T  ))
             ((= 1dt_check 2)(setq temp T tem nil ptd nil pte T  ))
             ;((= 1dt_check 3)(setq temp nil tem nil ptd nil pte T  ))
             ((= 1dt_check 4)(setq temp T tem nil ptd T   pte nil))
             ;((= 1dt_check 5)(setq temp nil tem nil ptd T   pte nil))
             ((= 1dt_check 6)(setq temp T tem nil ptd nil pte nil)
              (command "_.undo" "_m")
              (1dt_ex)
              (setq uctr (1+ uctr))
             )
             ;((= 1dt_check 7)(setq temp T   tem nil ptd nil pte nil))
       )
      )
      (T
        (if (< (distance strtpt nextpt) 200)
          (alert "Insufficient width -- Value is not less than 200")
          (cond ((= 1dt_check 0)(setq temp T tem nil ptd T   pte T)
                 (setq 1de:wid (distance strtpt nextpt)
                       1de:ang (angle    strtpt nextpt)
                 )
                )
                ;((= 1dt_check 1)(setq temp nil tem nil ptd T   pte T  ))
                ((= 1dt_check 2)(setq temp T tem nil ptd nil pte T  )
                 (setq 1de:wid (distance strtpt nextpt)
                       1de:ang (angle    strtpt nextpt)
                 )
                ) 
                ;((= 1dt_check 3)(setq temp nil tem nil ptd nil pte T  ))
                ((= 1dt_check 4)(setq temp T tem nil ptd T   pte nil)
                 (setq 1de:wid (distance strtpt nextpt)
                       1de:ang (angle    strtpt nextpt)
                 )
                )
                ;((= 1dt_check 5)(setq temp T   tem nil ptd T   pte nil))
                ((= 1dt_check 6)(setq temp T tem nil ptd nil pte nil)
                 (setq 1de:wid (distance strtpt nextpt)
                       1de:ang (angle    strtpt nextpt)
                 )      
                 (command "_.undo" "_m")
                 (1dt_ex)
                 (setq uctr (1+ uctr))
                ) 
                ;((= 1dt_check 7)(setq temp T   tem nil ptd nil pte nil))
          )
        )
      )
    )
  )
)

(defun 1dt_m3 ()
  (while ptd
    (setvar "osmode" 167)
    (setvar "blipmode" 1)
    ;(setvar "snapbase" (list (car strtpt) (cadr strtpt)))
    (initget "Undo")
    (setq hgh (getdist strtpt (strcat
      "\n>>> Undo/<opening_height:"
      (rtos 1dt:hgh) ">: ")))
    (setvar "blipmode" 0)
    ;(setvar "snapbase" '(0 0))
    (cond
      ((= hgh "Undo")
       (cond ((= 1dt_check 0)(setq temp nil tem T   ptd nil pte nil  ))
               ((= 1dt_check 1)(setq temp T   tem nil ptd nil pte nil  ))
             ;((= 1dt_check 2)(setq temp T   tem nil ptd nil pte nil  ))
             ;((= 1dt_check 3)(setq temp nil tem nil ptd nil pte T  ))
             ((= 1dt_check 4)(setq temp nil tem T   ptd nil pte nil))
             ((= 1dt_check 5)(setq temp T   tem nil ptd nil pte nil))
             ;((= 1dt_check 6)(setq temp nil tem T   ptd nil pte nil))
             ;((= 1dt_check 7)(setq temp T   tem nil ptd nil pte nil))
       )
      )
      ((null hgh)
       (cond ((= 1dt_check 0)(setq temp T tem T ptd nil   pte T  ))
             ((= 1dt_check 1)(setq temp T tem T ptd nil   pte T  ))
             ;((= 1dt_check 2)(setq temp nil tem T   ptd nil pte T  ))
             ;((= 1dt_check 3)(setq temp nil tem nil ptd nil pte T  ))
             ((= 1dt_check 4)(setq temp T tem T ptd nil   pte nil)
              (command "_.undo" "_m")
              (1dt_ex)
              (setq uctr (1+ uctr))
             )
             ((= 1dt_check 5)(setq temp T tem T ptd nil   pte nil)
              (command "_.undo" "_m")
              (1dt_ex)
              (setq uctr (1+ uctr))
             )
             ;((= 1dt_check 6)(setq temp nil tem T   ptd nil pte nil))
             ;((= 1dt_check 7)(setq temp T   tem nil ptd nil pte nil))
       )
      )
      (T
        (if (< hgh 1600)
          (alert "Insufficient height -- Value is not less than 1,600")
          (cond ((= 1dt_check 0)(setq temp T   tem T   ptd nil pte T  )
                 (setq 1dt:hgh hgh)
                )
                ((= 1dt_check 1)(setq temp T   tem T   ptd nil pte T  )
                 (setq 1dt:hgh hgh)
                )
                ;((= 1dt_check 2)(setq temp nil tem T   ptd nil pte T  ))
                ;((= 1dt_check 3)(setq temp nil tem nil ptd nil pte T  ))
                ((= 1dt_check 4)(setq temp T   tem T   ptd nil pte nil)
                 (setq 1dt:hgh hgh)
                 (command "_.undo" "_m")
                 (1dt_ex)
                 (setq uctr (1+ uctr))
                )
                ((= 1dt_check 5)(setq temp T   tem T   ptd nil pte nil)
                 (setq 1dt:hgh hgh)
                 (command "_.undo" "_m")
                 (1dt_ex)
                 (setq uctr (1+ uctr))
                )
                ;((= 1dt_check 6)(setq temp nil tem T   ptd nil pte nil))
                ;((= 1dt_check 7)(setq temp T   tem nil ptd nil pte nil))
          )
        )
      )
    )
  )
)

(defun 1dt_m4 ()
  (while pte
    (setvar "osmode" 167)
    (setvar "blipmode" 1)
    ;(setvar "snapbase" (list (car strtpt) (cadr strtpt)))
    (initget "Undo")
    (if (> 1dt:dhg (- 1dt:hgh 100)) (setq 1dt:dhg (- 1dt:hgh 100)))
    (setq dhg (getdist strtpt (strcat
      "\n>>> Undo/<door_height:"
      (rtos 1dt:dhg) ">: ")))
    (setvar "blipmode" 0)
    ;(setvar "snapbase" '(0 0))
    (cond
      ((= dhg "Undo")
       (cond ((= 1dt_check 0)(setq temp nil tem nil ptd T   pte nil))
             ((= 1dt_check 1)(setq temp nil tem nil ptd T   pte nil))
             ((= 1dt_check 2)(setq temp nil tem T   ptd nil pte nil))
             ((= 1dt_check 3)(setq temp T   tem nil ptd nil pte nil))
             ;((= 1dt_check 4)(setq temp nil tem T   ptd T   pte nil))
             ;((= 1dt_check 5)(setq temp nil tem nil ptd T   pte nil))
             ;((= 1dt_check 6)(setq temp nil tem T   ptd nil pte nil))
             ;((= 1dt_check 7)(setq temp T   tem nil ptd nil pte nil))
       )
      )
      ((null dhg)
        (setq temp T pte nil)
        (command "_.undo" "_m")
        (1dt_ex)
        (setq uctr (1+ uctr))
      )
      (T
        (cond
          ((> dhg (- 1dt:hgh 100))
            (alert (strcat
              "Invalid height -- Value is less than " (rtos (- 1dt:hgh 100))))
          )
          ((< dhg 1500)
            (alert "Invalid height -- Value is not less than 1,500")
          )
          (T
           (setq temp T pte nil)
           (setq 1dt:dhg dhg)
           (command "_.undo" "_m")
           (1dt_ex)
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
(defun 1dt_dd(/ dcl_id cancel_check)
  (setq old:fprop 1dt:fprop old:oprop 1dt:oprop old:uprop 1dt:uprop)
  (setq cancel_check nil); cancel button init
  (setq dcl_id (ai_dcl "de"))
  (if (not (new_dialog "dd_de" dcl_id)) (exit))
  
  (set_tile 1dt_prop_type "1")
  (@get_eval_prop 1dt_prop_type 1dt:prop)
  
  (set_tile "ed_gap" (itoa 1de:gap))
  (set_tile "ed_frame" (itoa 1de:fra))
  (set_tile "ed_finish" (itoa 1de:fin))
  (setq 1de:wid (fix 1de:wid)
        1dt:hgh (fix 1dt:hgh)
        1dt:dhg (fix 1dt:dhg)
  )        
  (set_tile "ed_open_width" (itoa 1de:wid))
  (set_tile "ed_open_height" (itoa 1dt:hgh))
  (set_tile "ed_door_height" (itoa 1dt:dhg))
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
  (cond ((= 1dt_check 0)
         (set_tile "tg_open_width" "0")(mode_tile "ed_open_width" 1)
         (set_tile "tg_open_height" "0")(mode_tile "ed_open_height" 1)
         (set_tile "tg_door_height" "0")(mode_tile "ed_door_height" 1)
        )
        ((= 1dt_check 1)
         (set_tile "tg_open_width" "1")(mode_tile "ed_open_width" 0)
         (set_tile "tg_open_height" "0")(mode_tile "ed_open_height" 1)
         (set_tile "tg_door_height" "0")(mode_tile "ed_door_height" 1)
        )
        ((= 1dt_check 2)
         (set_tile "tg_open_width" "0")(mode_tile "ed_open_width" 1)
         (set_tile "tg_open_height" "1")(mode_tile "ed_open_height" 0)
         (set_tile "tg_door_height" "0")(mode_tile "ed_door_height" 1)
        )
        ((= 1dt_check 3)
         (set_tile "tg_open_width" "1")(mode_tile "ed_open_width" 0)
         (set_tile "tg_open_height" "1")(mode_tile "ed_open_height" 0)
         (set_tile "tg_door_height" "0")(mode_tile "ed_door_height" 1)
        )
        ((= 1dt_check 4)
         (set_tile "tg_open_width" "0")(mode_tile "ed_open_width" 1)
         (set_tile "tg_open_height" "0")(mode_tile "ed_open_height" 1)
         (set_tile "tg_door_height" "1")(mode_tile "ed_door_height" 0) 
        )
        ((= 1dt_check 5)
         (set_tile "tg_open_width" "1")(mode_tile "ed_open_width" 0)
         (set_tile "tg_open_height" "0")(mode_tile "ed_open_height" 1)
         (set_tile "tg_door_height" "1")(mode_tile "ed_door_height" 0)
        )
        ((= 1dt_check 6)
         (set_tile "tg_open_width" "0")(mode_tile "ed_open_width" 1)
         (set_tile "tg_open_height" "1")(mode_tile "ed_open_height" 0)
         (set_tile "tg_door_height" "1")(mode_tile "ed_door_height" 0)
        )
        ((= 1dt_check 7)
         (set_tile "tg_open_width" "1")(mode_tile "ed_open_width" 0)
         (set_tile "tg_open_height" "1")(mode_tile "ed_open_height" 0)
         (set_tile "tg_door_height" "1")(mode_tile "ed_door_height" 0)
        ) 
  )
  (mode_tile "tg_door_width" 1)
  (mode_tile "ed_door_width" 1)
  (ci_image "door_type" "al_door(1dt)")
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
  (action_tile "rd_attribute" "(setq 1dt_prop_type $value)(@get_eval_prop 1dt_prop_type 1dt:prop)")
  
  (action_tile "tg_gap" "(enable_ed_gap)")
  (action_tile "bn_door" "(door_select)")
  (action_tile "tg_open_width" "(enable_ed_open_width)")
  (action_tile "tg_open_height" "(enable_ed_open_height)")
  (action_tile "tg_door_height" "(enable_ed_door_height)")
  (action_tile "accept" "(press_ok2)")
  (action_tile "cancel" "(setq cancel_check T)(done_dialog)")
  (start_dialog)
  (done_dialog)
  (if (= cancel_check T) ; user press cancel
    (setq 1dt:fprop old:fprop 1dt:oprop old:oprop 1dt:uprop old:uprop)
  )
)
;========property control end

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
(defun press_ok2(/ err_cnt)
  (setq err_cnt 0)
  (PROP_SAVE 1dt:prop)
  
  (if (< (atoi (get_tile "ed_open_width")) 200) ;(< (distance strtpt nextpt) 200)
    (alert "Insufficient open width -- Value is not less than 200")
    (setq err_cnt (+ err_cnt 1))
  )
  (if (< (atoi (get_tile "ed_open_height")) 1600)
    (alert "Insufficient open height -- Value is not less than 1,600")
    (setq err_cnt (+ err_cnt 1))
  )
  (if (< (atoi (get_tile "ed_door_height")) 1500)
    (alert "Invalid door height -- Value is not less than 1,500")
    (progn 
       (setq err_cnt (+ err_cnt 1))
       (if (> (atoi (get_tile "ed_door_height")) (- (atoi (get_tile "ed_open_height")) 100))
         (alert (strcat "Invalid door height -- Value is less than " (rtos (- (atoi (get_tile "ed_open_height")) 100))))
         (setq err_cnt (+ err_cnt 1))
       )         
     )
  )
  (if (= (get_tile "tg_gap") "0")(setq out_check nil)(setq out_check T))
  (if (= (get_tile "tg_threshold") "0")(setq 1de:ths "OFf")(setq 1de:ths "ON"))
 
  (setq 1dt_check 0)
  (if (= (get_tile "tg_open_width") "1")(setq 1dt_check (+ 1dt_check 1)))
  (if (= (get_tile "tg_open_height") "1")(setq 1dt_check (+ 1dt_check 2)))
  (if (= (get_tile "tg_door_height") "1")(setq 1dt_check (+ 1dt_check 4)))
  
  (if (= err_cnt 4)
    (progn 
       (setq 1de:gap (atoi (get_tile "ed_gap"))
             1de:fra (atoi (get_tile "ed_frame"))
             1de:fin (atoi (get_tile "ed_finish"))
             1de:ang 0
             1de:wid (atoi (get_tile "ed_open_width"))
             1dt:hgh (atoi (get_tile "ed_open_height"))
             1dt:dhg (atoi (get_tile "ed_door_height"))
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
(defun enable_ed_door_height()
  (if (/= (get_tile "tg_door_height") "0")
    (mode_tile "ed_door_height" 0)
    (mode_tile "ed_door_height" 1)
  )  
)  

(defun 1dt_ex (/ pt18_tem pt18_1 pt18_2 pt18_3 pt18_4 pt18_5 pt18_6)
  (setvar "osmode" 0)
  (if (and (/= dist nil) (/= dist 0)) (setq strtpt (polar strtpt (angle strtpt2 nextpt2) dist)))
  (setq pt1   strtpt
        pt2   (polar pt1 1de:ang 1de:wid)
        fnt   (if (= 1de:gap 0)
                0
                1de:fin
              )
        ang   1de:ang
        ang1  (angle pt2 pt1)
        ang2  (dtr 90)
        ang3  (dtr 270)
        pt3   (polar pt2   ang2 1dt:hgh)
        pt4   (polar pt1   ang2 1dt:hgh)
        pt5   (polar pt1   ang  1de:gap)
        pt6   (polar pt5   ang2 (- 1dt:hgh 1de:gap))
        pt7   (polar pt6   ang  (- 1de:wid (* 2 1de:gap)))
        pt8   (polar pt7   ang3 (- 1dt:hgh 1de:gap))
        pt9   (polar pt8   ang1 1de:fra)
        pt10  (polar pt9   ang2 (- 1dt:hgh (+ 1de:gap 1de:fra)))
        pt10x (polar pt9   ang2 1dt:dhg)
        pt11  (polar pt10  ang1 (- 1de:wid (+ (* 2 1de:gap) (* 2 1de:fra))))
        pt11x (polar pt10x ang1 (- 1de:wid (+ (* 2 1de:gap) (* 2 1de:fra))))
        pt12  (polar pt11  ang3 (- 1dt:hgh (+ 1de:gap 1de:fra)))
        pt13  (polar pt1   ang2 fnt)
        pt13  (polar pt13  ang1 (* sc 5))
        pt14  (polar pt2   ang2 fnt)
        pt14  (polar pt14  ang  (* sc 5))
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
  (setq pt17 (polar pt15 ang2 (/ (distance pt11x pt15) 2))
        pt18 (polar pt16 ang2 (if (>= (/ 1dt:dhg 2) 1000)
                                990
                                (/ 1dt:dhg 2)
                              )
             )
        pt18 (polar pt18 ang1 60)
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
          (set_col_lin_lay 1dt:uprop)
          (command "_.LINE" pt1x pt2x "")
          (command "_.LINE" pt2y pt3y "")
          (command "_.LINE" pt3x pt4x "")
          (command "_.LINE" pt4y pt1y "")
          (command "_.LINE" pt13 pt14 "")
        )
      )        
    )
  )
  ; draw "frame"
  (set_col_lin_lay 1dt:fprop)
  (command "_.pline" pt5 pt6 pt7 pt8 pt9 pt10 pt11 pt12 "_C")
  (command "_.line" pt15  pt16 "")
  (command "_.line" pt10x pt11x "")
  (if (and (= 1de:ths "ON") (/= 1de:gap 0))
    (command "_.line" pt15x pt16x "")
  )
  
  ; draw "door handle"
  (cond ((= door_ring1 T)
         (command "_.circle" pt18 40)
         (command "_.circle" pt18 30)
         (command "_.circle" pt18 15)
        )
        ((= door_ring2 T)
         (setq pt18_tem (polar pt18   (dtr 180) 50))
         (setq pt18_1 (polar pt18_tem (dtr 90)  150))
         (setq pt18_2 (polar pt18_1 (dtr 0)   100))
         (setq pt18_3 (polar pt18_2 (dtr 270) 300))
         (setq pt18_4 (polar pt18_3 (dtr 180) 100))
         (command "_.pline" pt18_1 pt18_2 pt18_3 pt18_4 "_C")
        ) 
        ((= door_ring3 T)
         (setq pt18_1 (polar pt18   (dtr 90)  100))
         (setq pt18_2 (polar pt18_1 (dtr 0)   28))
         (setq pt18_3 (polar pt18_2 (dtr 270) 200))
         (setq pt18_4 (polar pt18_3 (dtr 180) 28))
         (command "_.pline" pt18_1 pt18_2 pt18_3 pt18_4 "_C")
        )
        ((= door_ring4 T)
         (setq pt18_1 (polar pt18   (dtr 90)  100))
         (setq pt18_2 (polar pt18_1 (dtr 0)   28))
         (setq pt18_3 (polar pt18_2 (dtr 270) 228))
         (setq pt18_4 (polar pt18_3 (dtr 180) 528))
         (setq pt18_5 (polar pt18_4 (dtr 90)  28))
         (setq pt18_6 (polar pt18_5 (dtr 0)   500))
         (command "_.pline" pt18_1 pt18_2 pt18_3 pt18_4 pt18_5 pt18_6 "_C")
        )
        ((= door_ring5 T)
         (setq pt18_tem (polar pt18 (dtr 180)  130))
         (setq pt18_1 (polar pt18_tem (dtr 90)  75))
         (setq pt18_2 (polar pt18_1 (dtr 0)   150))
         (setq pt18_3 (polar pt18_2 (dtr 270) 150))
         (setq pt18_4 (polar pt18_3 (dtr 180) 150))
         (command "_.pline" pt18_1 pt18_2 pt18_3 pt18_4 "_C")
        )
  ); end draw "door handle"
  (if (= 1de:gap 0)
    (command "_.line" pt12 pt9 "")
  )
  ; draw "open mark"
  (set_col_lin_lay 1dt:oprop)
  (command "_.pline" pt16 pt17 pt10x "")
  
)



(if (null 1de:gap) (setq 1de:gap 10))
(if (null 1de:fra) (setq 1de:fra 40))
(if (null 1de:wid) (setq 1de:wid 900))
(if (null 1de:ang) (setq 1de:ang 0))
(if (null 1dt:hgh) (setq 1dt:hgh 2400))
(if (null 1dt:dhg) (setq 1dt:dhg 2100))
(if (null 1de:fin) (setq 1de:fin 30))
(if (null 1dt_check)(setq 1dt_check 7))
(if (not (member 1de:ths '("ON" "OFf"))) (setq 1de:ths "OFf"))
; door handle init
(cond ((= door_ring1 T) )
      ((= door_ring2 T) )
      ((= door_ring3 T) )
      ((= door_ring4 T) )
      ((= door_ring5 T) )
      (T (setq door_ring1 T))
)

(setq 1dt:fprop (Prop_search "1dt" "frame"))
(setq 1dt:oprop (Prop_search "1dt" "open"))
(setq 1dt:uprop (Prop_search "1dt" "outline"))
(setq 1dt:prop '(1dt:fprop 1dt:oprop 1dt:uprop))

(if (null 1dt_prop_type) (setq 1dt_prop_type "rd_frame"))

(defun C:CIM1DT () (m:1dt))
;(cad_lock)
;(princ "\n\tC:1Door with Transom elevation loaded. Start command with 1DT. ")
(princ)
