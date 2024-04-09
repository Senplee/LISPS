수정날짜:2001년 8월 13일
;작업자 :박율구
;명령어 :C:CIMCOL () 기둥평면 작성 (rc,src,stl)
;	C:CIMSTLG () 철재보 그리기 

;단축키 관련 변수 정의 부분.. end


(defun cluser (/ cnn lx ly lw lh lxs lys tmp tmplay ttt)
 (setq tmp t)
 (while tmp
  
  (setvar "osmode" 33)
  (initget  "Dialog")
  (setq cnn (getpoint (strcat
            "\nDialog/<삽입점>:")))   
  (if (null cnn)(exit))
  (cond ((= cnn "Dialog")
	 (dd_column))
	((= (type cnn) 'LIST)
	 (setq cp cnn tmp nil)
	)
	((null cnn)
	 (setq cp nil) (setq tmp nil)
	)
  )
 )

)

;    Draw Column

(defun drawout (/ tt Tang)
  (set_col_lin_lay col:cprop)
  (setvar "osmode" 0)
  (if (/= col:type "sTeel")
    (progn
     (setq p1 (list (+ (/ col:wid 2) (car cp)) (+ (/ col:len 2) (cadr cp))))
     (command "pline"
         (setq p p1)
         (setq p (polar p (dtr 180) col:wid))
         (setq p (polar p (dtr 270) col:len))
         (polar p 0 col:wid)
         "c"
     )
    (ssget "L")
    )
  )
  (if (/= col:type "Rc") 
    (progn
	(princ "\nEnter or Pick Rotation Angle: ")
        (setvar "osmode" 135)
	(command "insert" "stl" cp col:swid col:slen pause)
        (setvar "osmode" 0)
	(setq Tang (cdr (assoc 50 (entget (entlast)))))
	(if (/= col:type "sTeel")
	   (command "_rotate" "p" "" cp (rtd Tang))
	)
    )
  )
  
)

(defun m:COLUMN (/ cec col_err col_oco col_ola omode cp)

 (ai_err_on)
 (ai_undo_on)
 (command "_.undo" "group")

 (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
 (princ "\n기둥을 그리는 명령입니다.")
  (setq cp T)
  (while (/= cp nil)
     (cluser)
     (drawout)
  )
 
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ)
)

(defun dd_column (/ cancel_check ok_check tog_check)
  
  (setq dcl_id (ai_dcl "stru"))
  (if (not (new_dialog "dd_column" dcl_id)) (exit))
  (set_tile col_prop_type "1")
  (@get_eval_prop col_prop_type col:prop)
  (set_tile (strcat "col_type_" col:type) "1")
  (cond ((= col:type "Rc")
	 (mode_tile "eb_stl_width" 1)
	 (mode_tile "eb_stl_length" 1)
	 (mode_tile "eb_col_width" 0)
	 (mode_tile "eb_col_length" 0)
	)
	((= col:type "Src")
	 (mode_tile "eb_stl_width" 0)
	 (mode_tile "eb_stl_length" 0)
	 (mode_tile "eb_col_width" 0)
	 (mode_tile "eb_col_length" 0)
	)
	((= col:type "sTeel")
	 (mode_tile "eb_stl_width" 0)
	 (mode_tile "eb_stl_length" 0)
	 (mode_tile "eb_col_width" 1)
	 (mode_tile "eb_col_length" 1)
	)
  )
  
  (set_tile "eb_col_width" (rtos col:wid))
  (set_tile "eb_col_length" (rtos col:len))
  (set_tile "eb_stl_width" (rtos col:swid))
  (set_tile "eb_stl_length" (rtos col:slen))
  
  (action_tile "b_name" "(@getlayer)")
  (action_tile "b_color" "(@getcolor)")
  (action_tile "color_image"  "(@getcolor)")
  (action_tile "b_line"       "(@getlin)")
  (action_tile "c_bylayer" "(@bylayer_do T)")
  (action_tile "t_bylayer"    "(@bylayer_do nil)")
  (action_tile "prop_radio" "(setq stlg_prop_type $Value)(@get_eval_prop stlg_prop_type stlg:prop)")

  (action_tile "eb_col_width" "(setq col:wid (@verify_d \"eb_col_width\" $value col:wid 1))")
  (action_tile "eb_col_length" "(setq col:len (@verify_d \"eb_col_length\" $value col:len 1))")
  (action_tile "eb_stl_width" "(setq col:swid (@verify_d \"eb_stl_width\" $value col:swid 1))")
  (action_tile "eb_stl_length" "(setq col:slen (@verify_d \"eb_stl_length\" $value col:slen 1))")
  (action_tile "col_type" "(column_type)")
    
  (action_tile "cancel" "(setq cancel_check T)(done_dialog)")
  (start_dialog)
  (done_dialog)
  (if (= cancel_check nil)
	(PROP_SAVE col:prop)
  )
)
(defun column_type()
  (cond ((= (get_tile "col_type_Rc") "1")
	 (setq col:type "Rc")
	 (mode_tile "eb_col_width" 0)
	 (mode_tile "eb_col_length" 0)
	 (mode_tile "eb_stl_width" 1)
	 (mode_tile "eb_stl_length" 1)
	)
	((= (get_tile "col_type_Src") "1")
	 (setq col:type "Src")
	 (mode_tile "eb_col_width" 0)
	 (mode_tile "eb_col_length" 0)
	 (mode_tile "eb_stl_width" 0)
	 (mode_tile "eb_stl_length" 0)
	)
	((= (get_tile "col_type_sTeel") "1")
	 (setq col:type "sTeel")
	 (mode_tile "eb_col_width" 1)
	 (mode_tile "eb_col_length" 1)
	 (mode_tile "eb_stl_width" 0)
	 (mode_tile "eb_stl_length" 0)
	)
  )
)  

(setq col:cprop  (Prop_search "col" "column"))
(setq col:prop '(col:cprop))
(if (null col_prop_type) (setq col_prop_type "rd_column"))
(if (null col:type) (setq col:type "Rc"))
(if (null col:wid) (setq col:wid 600))
(if (null col:len) (setq col:len 600))
(if (null col:swid) (setq col:swid 400))
(if (null col:slen) (setq col:slen 400))

(defun C:CIMCOL () (m:column))
(princ)

;--------------------------------------------------------------------------------------

(defun m:stlg (/
             sc       strtpt   nextpt   uctr     cont     temp     tem
             )

  (setq sc       (getvar "dimscale"))

  ;;
  (ai_err_on) 
  (ai_undo_on)
  (command "_.undo" "_group")

 (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
 (princ "\n보를 그리는 명령입니다.")

  (setq cont T temp T uctr 0)

  (while cont
    (stlg_m1)
    (stlg_m2)
  )

  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ)
)

(defun stlg_m1 ()
  (while temp
    (setvar "osmode" 32)
    (princ (strcat "\nWidth:" (rtos stlg:wid)))
    (if (> uctr 0)
      (progn
        (initget "/ Dialog Width Undo")
        (setq strtpt (getpoint
          "\n>>> Dialog/Width/Undo/<start point>: INTERSEC OF "))
      )
      (progn
        (initget "/ Dialog Width")
        (setq strtpt (getpoint "\n>>> Dialog/Width/<start point>: INTERSEC OF "))
      )
    )
    (cond
      ((= strtpt "Dialog")
        (dd_stlg)
      )

      ((= strtpt "Width")
        (stlg_wid)
      )
      ((= strtpt "/")
        (cim_help "STLG")
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

(defun stlg_m2 ()
  (while tem
  
    (initget "/ Dialog Width Undo")
    (setq nextpt (getpoint strtpt
      "\n>>> Dialog/Width/Undo/<next point>: INTERSEC OF "))
    
   
    
    (cond
      ((= nextpt "Dialog")
        (dd_stlg)
      )
     
      ((= nextpt "Width")
        (stlg_wid)
      )
      ((= nextpt "/")
        (cim_help "STLG")
      )
      ((= nextpt "Undo")
        (setq tem nil temp T)
      )
      ((null nextpt)
        (setq tem nil cont nil)
      )
      (T
        (if (< (distance strtpt nextpt) 200)
          (alert "Insufficient width -- Value is not less than 200")
          (progn
            (command "_.undo" "_m")
            (stlg_ex)
            (setq uctr (1+ uctr))
            (setq tem     nil
                  temp    T
            )
          )
        )
      )
    )
  )
)

(defun stlg_ex (/ p1 p2 ang p11 p22 p3 p4 l)
  (setq p1  strtpt
        p2  nextpt
        ang (angle p1  p2)
        p1  (polar p1  ang stlg:ost)
        p2  (polar p2  (+ ang (dtr 180)) stlg:ost)
        l   (distance  p1 p2)
        p11 (polar p1  (- ang (dtr 90)) (/ stlg:wid 2))
        p22 (polar p11 ang l)
        p4  (polar p11 (+ ang (dtr 90)) stlg:wid)
        p3  (polar p4  ang l)
  )
  (setvar "osmode" 0)
  (set_col_lin_lay stlg:sprop)
  (command "_.pline" p11 p22 p3 p4 "_C")
  (set_col_lin_lay cen:cprop)
  (command "_.line" p1 p2 "")
  
)

(defun stlg_wid (/ wid)
  (initget (+ 2 4))
  (setq wid (getint (strcat "\n    Girder_width <" (rtos stlg:wid) ">: ")))
  (if (numberp wid) (setq stlg:wid wid))
)

(defun dd_stlg (/ cancel_check ok_check tog_check)
  
  (setq dcl_id (ai_dcl "stru"))
  (if (not (new_dialog "dd_stlg" dcl_id)) (exit))
  (set_tile stlg_prop_type "1")
  (@get_eval_prop stlg_prop_type stlg:prop)
  (set_tile "eb_stlg_width" (rtos stlg:wid))
  (set_tile "eb_stlg_offset" (rtos stlg:ost))
  
  (action_tile "b_name" "(@getlayer)")
  (action_tile "b_color" "(@getcolor)")
  (action_tile "color_image"  "(@getcolor)")
  (action_tile "b_line"       "(@getlin)")
  (action_tile "c_bylayer" "(@bylayer_do T)")
  (action_tile "t_bylayer"    "(@bylayer_do nil)")
  (action_tile "prop_radio" "(setq stlg_prop_type $Value)(@get_eval_prop stlg_prop_type stlg:prop)")

  (action_tile "eb_stlg_width" "(setq stlg:wid (@verify_d \"eb_stlg_width\" $value stlg:wid 1))")
  (action_tile "eb_stlg_offset" "(setq stlg:ost (@verify_d \"eb_stlg_offset\" $value stlg:ost 2))")

  (action_tile "cancel" "(setq cancel_check T)(done_dialog)")
  (start_dialog)
  (done_dialog)
  (if (= cancel_check nil)
	(PROP_SAVE stlg:prop)
  )

)

(setq stlg:sprop  (Prop_search "stlg" "stlg"))
(setq cen:cprop  (Prop_search "cen" "cen"))
(setq stlg:prop '(stlg:sprop cen:cprop))
(if (null stlg_prop_type) (setq stlg_prop_type "rd_stlg"))

;(if (null stlg:lay) (setq stlg:lay "SBEAM"))

(if (null stlg:wid) (setq stlg:wid 400))
(if (null stlg:ost) (setq stlg:ost 0))
(defun C:CIMSTLG () (m:stlg))

(setq lfn16 1)
(princ)

