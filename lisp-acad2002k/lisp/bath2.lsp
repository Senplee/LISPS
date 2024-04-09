;수정날짜 :2001.08.11
;작업자 :김병용
;명령어 :cimtt1 () 변기와 한쪽 파티션벽 그리기
;        cimtt2 ()  변기와 파티션벽 그리기.

;단축키 관련 변수 정의 부분.. 맨 뒤로.


; 화장실 그리기
(defun m:tt1 (ttflag /
             pt1      pt2      pt3      ptd      d1       d2       nf
             ds       en       ang      ang1     ang2     ang3     ang4
             ang5     ang6     sc       strtpt   nextpt   uctr     cont
             temp     tem
             )

  (setq sc (getvar "dimscale"))
  ;;
  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")

 (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
 (princ "\n변기와 한쪽 파티션 벽을 그리는 명령입니다.")


  (setq cont T temp T uctr 0)

  (while cont
    (tt1_m1)
    (tt1_m2)
    (tt1_m3)
  )

  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)

  (princ)
)

(defun tt1_m1 ()
  (while temp
    (setvar "osmode" 33)
    (if (> uctr 0)
      (progn
        (initget "/ Dialog Undo")
        (setq strtpt (getpoint "\n>>> Dialog/Undo/<start point>: "))
      )
      (progn
        (initget "/ Dialog")
        (setq strtpt (getpoint "\n>>> Dialog/<start point>: "))
      )
    )

    (cond
      ((= strtpt "Dialog")
        (dd_tt1)
      )

      ((= strtpt "/")
        (cim_help ttflag)
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

(defun tt1_m2 ()
  (while tem
    (initget "/ Dialog Undo")
    (setvar "osmode" 33)
    ;(setvar "snapbase" (list (car strtpt) (cadr strtpt)))
    (setq nextpt (getpoint strtpt
      "\n    Dialog/Undo/<next point>: "))
    ;(setvar "snapbase" '(0 0))
    (cond
      ((= nextpt "Undo")
        (setq tem nil temp T)
      )
      ((= nextpt "Dialog")
        (dd_tt1)
      )

      ((= nextpt "/")
        (cim_help ttflag)
      )
      ((null nextpt)
        (setq cont nil tem nil)
      )
      (T
        (if (< (distance strtpt nextpt) 850)
          (alert "Insufficient width -- Value is not less than 850")
          (setq tem nil ptd T)
        )
      )
    )
  )
)

(defun tt1_m3 ()
  (while ptd
    (initget "/ Dialog Undo")
    
    (setvar "osmode" 33)
    ;(setvar "snapbase" (list (car strtpt) (cadr strtpt)))
    (setq ptd (getpoint strtpt
      "\n    Dialog/Undo/<depth & direct.>: "))
    ;(setvar "snapbase" '(0 0))
    (setvar "osmode" 0)
    (cond
      ((= ptd "Undo")
        (setq ptd nil tem T)
      )
      ((= ptd "Dialog")
        (dd_tt1)
      )

      ((= ptd "/")
        (cim_help ttflag)
      )
      ((= (type ptd) 'LIST)
        (if (< (distance strtpt ptd) 1050)
          (alert "Insufficient depth -- Value is not less than 1,050")
          (progn
            (command "_.undo" "_m")
            (tt1_ex)
	    (if (= ttflag "tt1")
	            (if (= tt1:simple "1")
		      (tt1_exs)
	              (tt1_exd)
	            )
	      	    (if (= tt1:simple "1")
		      (tt2_exs)
	              (tt2_exd)
	            )
	    )
            (setq uctr (1+ uctr))
            (princ (strcat
              "\n>>> Toilet_booth size: " (rtos ds) " x " (rtos d2))
            )
            (setq ptd nil temp T)
          )
        )
      )
      (T
        (setq ptd nil cont nil)
      )
    )
  )
)



(defun tt1_ex ()
  (setq pt1  strtpt
        pt2  nextpt
        pt3  ptd
        ang  (angle pt1 pt2)
        ang1 (angle pt1 pt3)
        ang2 (angle pt2 pt1)
        ang3 (angle pt3 pt1)
        d1   (distance pt1 pt2)
        d2   (distance pt1 pt3)
  )
  (if (>= d2 1200)
    (if (or (equal (rtd (- ang3 ang2)) -90.0 0.1)
            (equal (rtd (- ang3 ang2)) 270.0 0.1))
      (setq ang4 (- ang2 (dtr 30.0))
            ang5 (- ang2 (dtr 15.0))
            ang6 (+ ang4 (dtr 90.0)))
      (setq ang4 (+ ang2 (dtr 30.0))
            ang5 (+ ang2 (dtr 15.0))
            ang6 (- ang4 (dtr 90.0)))
    ) 
    (if (or (equal (rtd (- ang1 ang2)) -90.0 0.1)
            (equal (rtd (- ang1 ang2)) 270.0 0.1))
      (setq ang4 (- ang2 (dtr 30.0))
            ang5 (- ang2 (dtr 15.0))
            ang6 (+ ang4 (dtr 90.0)))
      (setq ang4 (+ ang2 (dtr 30.0))
            ang5 (+ ang2 (dtr 15.0))
            ang6 (- ang4 (dtr 90.0)))
    ) 
  )
  ;(if (< sc 200)
    (setq en tt1:typ)
  ;  (setq en (strcat tt1:typ "s"))
  ;)
  (setq nf (fix (/ d1 850)))
  (setq ds (/ d1 nf))
  (if (and (> nf 1) (> ds 1050))
    (setq ds 1050)
  )
)

(defun tt1_exs (/ pta ptb pti k pt4 pt5 pt6 pt7 pt8 pt9)
  (setq pta pt1 ptb pt3)
  (set_col_lin_lay tt1:pprop)
  (repeat (1- nf)
    (setq pt4 (polar pta ang  ds)
          pt5 (polar pt4 ang1 d2)
    )
    (command "_.line" pt4 pt5 "")
    (setq pta (polar pta ang ds))
  )
  (setq pt6 (polar ptb ang  (- ds 650))
        pt7 (polar pt6 ang  550)
        pt8 (polar pt7 ang4 550)
        pt9 (polar pt7 ang5 550)
  )
  (setq k 0)
  (repeat nf
    (setq k (1+ k))
    (command "_.line" ptb pt6 "")
    (command "_.line" pt7 pt8 "")
    ;(command "_.color" tt1_oco)
    (command "_.arc" pt8 pt9 pt6)
    ;(command "_.color" "_bylayer")
    (setq ptb (polar ptb ang (if (= k 1) (- ds 100) ds))
          pt6 (polar pt6 ang ds)
          pt7 (polar pt7 ang ds)
          pt8 (polar pt8 ang ds)
          pt9 (polar pt9 ang ds)
    )
  )
  (command "_.line" ptb (polar pt2 ang1 d2) "")
  ;(command "_.layer" "_s" tt1:sla "")
  (set_col_lin_lay tt1:tprop)
  (repeat nf
    (setq pti (polar pt1 ang (/ ds 2)))
    (command "_.insert" en pti "" "" (rtd ang1))
    (setq pt1 (polar pt1 ang ds))
  )
  ;(command "_.layer" "_s" tt1:pla "")
)

(defun tt1_exd (/ pta ptb pti p41 p42 p43 p44 p31 p61 ptc pc1 p81 p82
                  pt4 pt5 pt6 pt7 pt8 pt9 k)
  (setq pta pt1 ptb pt3)
  (set_col_lin_lay tt1:pprop)
  (repeat (1- nf)
    (setq pt4 (polar pta ang  ds)
          p41 (polar pt4 ang2 (/ tt1:thk 2.0))
          p42 (polar p41 ang1 (- d2 tt1:thk))
          p43 (polar p42 ang  tt1:thk)
          p44 (polar p43 ang3 (- d2 tt1:thk))
    )
    (command "_.pline" p41 p42 p43 p44 "_c")
    (setq pta (polar pta ang ds))
  )
  (setq pt6 (polar ptb ang  (- ds 650))
        pt7 (polar pt6 ang  550)
        ptc (if (>= d2 1200) (polar pt7 ang3 tt1:thk) pt7)
        pt8 (polar ptc ang4 550)
        pt9 (polar ptc ang5 550)
  )
  (setq k 0)
  (repeat nf
    (setq k (1+ k))
    (setq p31 (polar ptb ang3 tt1:thk)
          p61 (polar pt6 ang3 tt1:thk)
          pc1 (if (>= d2 1200) p61 pt6)
          p81 (polar pt8 ang6 tt1:thk)
          p82 (polar ptc ang6 tt1:thk)
    )
    (command "_.pline" ptb pt6 p61 p31 "_c")
    (command "_.pline" ptc pt8 p81 p82 "_c")
    ;(command "_.color" tt1_oco)
    (command "_.arc" p81 pt9 pc1)
    ;(command "_.color" "_bylayer")
    (setq ptb (polar ptb ang (if (= k 1) (- ds 100) ds))
          pt6 (polar pt6 ang ds)
          ptc (polar ptc ang ds)
          pt8 (polar pt8 ang ds)
          pt9 (polar pt9 ang ds)
    )
  )
  (command "_.pline" ptb (setq p (polar pt2 ang1 d2))
           (polar p ang3 tt1:thk) (polar ptb ang3 tt1:thk) "_c")
  ;(command "_.layer" "_s" tt1:sla "")
  (set_col_lin_lay tt1:tprop)
  (repeat nf
    (setq pti (polar pt1 ang (/ ds 2)))
    (command "_.insert" en pti "" "" (rtd ang1))
    (setq pt1 (polar pt1 ang ds))
  )
  ;(command "_.layer" "_s" tt1:pla "")
)


(defun tt2_exs (/ pta ptb pti k pt6 pt7 pt8 pt9)
  (setq pta pt1 ptb pt3)
  (set_col_lin_lay tt1:pprop)
  (repeat nf
    (command "_.line" pta (polar pta ang1 d2) "")
    (setq pta (polar pta ang ds))
  )
  (setq pt6 (polar ptb ang  (- ds 650))
        pt7 (polar pt6 ang  550)
        pt8 (polar pt7 ang4 550)
        pt9 (polar pt7 ang5 550)
  )
  (setq k 0)
  (repeat nf
    (setq k (1+ k))
    (command "_.line" ptb pt6 "")
    (command "_.line" pt7 pt8 "")
    ;(command "_.color" tt2_oco)
    (command "_.arc" pt8 pt9 pt6)
    ;(command "_.color" "_bylayer")
    (setq ptb (polar ptb ang (if (= k 1) (- ds 100) ds))
          pt6 (polar pt6 ang ds)
          pt7 (polar pt7 ang ds)
          pt8 (polar pt8 ang ds)
          pt9 (polar pt9 ang ds)
    )
  )
  (command "_.line" ptb (polar pt2 ang1 d2) "")
  ;(command "_.layer" "_s" tt1:sla "")
  (set_col_lin_lay tt1:tprop)
  (repeat nf
    (setq pti (polar pt1 ang (/ ds 2)))
    (command "_.insert" en pti "" "" (rtd ang1))
    (setq pt1 (polar pt1 ang ds))
  )
  
)

(defun tt2_exd (/ pta ptb pti p41 p42 p43 p44 p30 p31 p61 ptc pc1 p81 p82
                  pt4 pt5 pt6 pt7 pt8 pt9 k)
  (set_col_lin_lay tt1:pprop)
  (setq pta pt1 ptb pt3)
  (repeat nf
    (setq p41 (polar pta ang2 (/ tt1:thk 2.0))
          p42 (polar p41 ang1 (- d2 tt1:thk))
          p43 (polar p42 ang  tt1:thk)
          p44 (polar p43 ang3 (- d2 tt1:thk))
    )
    (command "_.pline" p41 p42 p43 p44 "_c")
    (setq pta (polar pta ang ds))
  )
  (setq pt6 (polar ptb ang  (- ds 650))
        pt7 (polar pt6 ang  550)
        ptc (if (>= d2 1200) (polar pt7 ang3 tt1:thk) pt7)
        pt8 (polar ptc ang4 550)
        pt9 (polar ptc ang5 550)
        p30 (polar ptb ang2 (/ tt1:thk 2.0))
  )
  (setq k 0)
   
  (repeat nf
    (setq k (1+ k))
    (setq p31 (polar p30 ang3 tt1:thk)
          p61 (polar pt6 ang3 tt1:thk)
          pc1 (if (>= d2 1200) p61 pt6)
          p81 (polar pt8 ang6 tt1:thk)
          p82 (polar ptc ang6 tt1:thk)
    )
    (command "_.pline" p30 pt6 p61 p31 "_c")
    (command "_.pline" ptc pt8 p81 p82 "_c")
    ;(command "_.color" tt2_oco)
    (command "_.arc" p81 pt9 pc1)
    ;(command "_.color" "_bylayer")
    (setq p30 (polar p30 ang (if (= k 1) (+ (/ tt1:thk 2.0) (- ds 100)) ds))
          pt6 (polar pt6 ang ds)
          ptc (polar ptc ang ds)
          pt8 (polar pt8 ang ds)
          pt9 (polar pt9 ang ds)
    )
  )
  (command "_.pline" p30 (setq p (polar pt2 ang1 d2))
           (polar p ang3 tt1:thk) (polar p30 ang3 tt1:thk) "_c")
  (set_col_lin_lay tt1:tprop)
  (repeat nf
    (setq pti (polar pt1 ang (/ ds 2)))
    (command "_.insert" en pti "" "" (rtd ang1))
    (setq pt1 (polar pt1 ang ds))
  )
 
)


(defun dd_tt1 (/  typ dcl_id cancel_check ci_lst lst)

  (setq ok_check nil cancel_check nil typ nil tt1:f_name nil); ok,cancel button init
  (setq dcl_id (ai_dcl "bath2"))
  (if (not (new_dialog "dd_tt1" dcl_id)) (exit))
  (set_tile tt1_prop_type "1")
  (@get_eval_prop tt1_prop_type tt1:prop)
  (set_tile "eb_frame_width" (rtos tt1:thk))
  (set_tile "tg_simple" tt1:simple)
  
  (ci_image "cc-102p" "al_toil(cc-102p)")  
  (ci_image "cc-12p" "al_toil(cc-12p)") 
  (ci_image "cc-13p" "al_toil(cc-13p)")  
  (ci_image "cc-302p" "al_toil(cc-302p)")  
  (ci_image "cc-102ps" "al_toil(cc-102ps)")  
  (ci_image "cc-12ps" "al_toil(cc-12ps)") 
  (ci_image "cc-13ps" "al_toil(cc-13ps)")  
  (ci_image "cc-302ps" "al_toil(cc-302ps)")
  (mode_tile tt1:typ 4)
  ;속성  
  (action_tile "b_name" "(@getlayer)")
  (action_tile "b_color" "(@getcolor)")
  (action_tile "color_image"  "(@getcolor)")
  (action_tile "c_bylayer" "(@bylayer_do T)")

  (action_tile "eb_frame_width" "(setq tt1:thk (@verify_d \"eb_frame_width\" $value tt1:thk 1))")
  
  (action_tile "prop_radio" "(setq tt1_prop_type $Value)(@get_eval_prop tt1_prop_type tt1:prop)")
  (action_tile "tg_simple" "(setq tt1:simple (get_tile \"tg_simple\"))") 

  (setq ci_lst '("cc-102p" "cc-12p" "cc-13p" "cc-302p"
		 "cc-102ps" "cc-12ps" "cc-13ps" "cc-302ps"))
    (foreach lst ci_lst
      (action_tile lst
        "(mode_tile tt1:typ 4)(setq tt1:typ $key)(mode_tile tt1:typ 4)"
      )
  )
  
  (action_tile "f_search" "(fixu_file_open)")  
  (action_tile "f_name" "(setq tt1:f_name $value)")         
  (action_tile "cancel" "(setq cancel_check T)(done_dialog)")  
  (start_dialog)
  (done_dialog)       
   
  (if (= cancel_check nil)
    (progn
      	(if (= (findfile (strcat tt1:typ ".dwg")) nil)  		       		
       		;(progn (setq tt1:typ tt1:f_name))
 		(progn (alert (strcat tt1:f_name "을 찾을 수가 없습니다."))  		       			
;			(dd_tt1)
		 )
	)
	(PROP_SAVE tt1:prop)
    )	
  
  )  
)

(setq tt1:tprop  (Prop_search "tt" "tt"))
(setq tt1:pprop  (Prop_search "tt" "partition"))
(setq tt1:prop '(tt1:tprop tt1:pprop))
(if (null tt1_prop_type) (setq tt1_prop_type "rd_tt"))
(if (null tt1:simple) (setq tt1:simple "0"))
(if (null tt1:thk) (setq tt1:thk 30))
(if (null tt1:typ) (setq tt1:typ "cc-102p"))


(defun C:cimtt1 () (m:tt1 "tt1"))
(defun C:cimtt2 () (m:tt1 "tt2"))

(setq lfn11 1)
(princ)
