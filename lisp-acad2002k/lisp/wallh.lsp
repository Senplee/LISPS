; 작업날짜: 2001년 8월 11일
; 작업자: 김병용
; 명령어: CIMWLH, CIMWLB, CIMCONC


(defun m:wlh (wlh:hat / temp strtpt nextpt 
                ss ls uctr 
                wlh_err wlh_oer wlh_osm wlh_obm wlh_oco wlh_ola wlh_oce)

  (setq wlh_osm (getvar "osmode")
        wlh_obm (getvar "blipmode")
        wlh_oco (getvar "cecolor")
        wlh_ola (getvar "clayer")
        wlh_oce (getvar "cmdecho")
  )

  ;;
  ;; Internal error handler defined locally
  ;;

  (defun wlh_err (s)                   ; If an error (such as CTRL-C) occurs
                                      ; while this command is active...
    (if (/= s "Function cancelled")
      (if (= s "quit / exit abort")
        (princ)
        (princ (strcat "\nError: " s))
      )
    )
    (setvar "cmdecho" 0)
    (if wlh_oer                        ; If an old error routine exists
      (setq *error* wlh_oer)           ; then, reset it 
    )
    (if wlh_osm (setvar "osmode" wlh_osm))
    (if wlh_oco (command "-color" wlh_oco))
    (if wlh_ola (command "-layer" "_s" wlh_ola ""))
    
    (setvar "blipmode" wlh_obm)
    (command "_undo" "_en")
    (ai_undo_off)
    (setvar "cmdecho" 1)
    (princ)
  )
  
  ;; Set our new error handler
  (if (not *DEBUG*)
    (if *error*                     
      (setq wlh_oer *error* *error* wlh_err) 
      (setq *error* wlh_err) 
    )
  )

  (setvar "cmdecho" 0)
  (ai_undo_on)
  (command "_undo" "_group")
  
  (setq cont T temp T uctr 0)
  (while cont
    (wlh_m1)
    (wlh_m2)
  )

  (if wlh_osm (setvar "osmode" wlh_osm))
  (if wlh_obm (setvar "blipmode" wlh_obm))
  (if wlh_oco (command "-color" wlh_oco))
  (if wlh_ola (command "-layer" "_S" wlh_ola ""))

  (command "_undo" "_en")
  (ai_undo_off)

  (if wlh_oce (setvar "cmdecho" wlh_oce))
  (princ)
)

(defun wlh_m1 (/ exp_undo)
  (while temp
    (setvar "blipmode" 1)
    (setvar "osmode" 512)
    (setq exp_undo nil
	  pt1      nil
	  pt2      nil
    )
    (if (> uctr 0)
      (progn
        (initget "Dialog Undo")
        (setq strtpt (getpoint
          "\n>>> Dialog/Undo/<Select first point>: "))
      )
      (progn
        (initget "Dialog")
        (setq strtpt (getpoint
          "\n>>> Dialog/<Select first point>: "))
      )
    )
    (setvar "blipmode" 0)
    (setvar "osmode" 0)
    (cond
      ((= strtpt "Dialog")
        (wlh_dd)
      )
      ((= strtpt "Undo")
        (command "_.undo" "_b")
        (setq uctr (1- uctr))
      )
      ((null strtpt)
        (setq cont nil temp nil tem nil) ; end
      )
      (T
        (if (ssget strtpt) ; 무언가 잡혔으면...
	  (progn
	    (setq ss (ssget "c" strtpt strtpt))
	    (setq e (entget (ssname ss 0)))
	    (if (or (= (fld_st 0 e) "POLYLINE")
		    (= (fld_st 0 e) "LWPOLYLINE")
		)    
	      (progn (command "_.undo" "m")
		     (command "_.explode" ss)
		     (setq exp_undo T)
	      )
	    )  
	    (setq ss (ssget "c" strtpt strtpt))
	    (setq e (entget (ssname ss 0)))
	    (if (= (fld_st 0 e) "LINE")
              (setq temp nil
		    pt1  (fld_st 10 e) 
		    pt2  (fld_st 11 e)
		    tem T
	      )
	      (alert "벽선이 아닙니다. 다시 시도하십시요.")
	    )  
	    (if (= exp_undo T)(command "_.undo" "b"))
	  )  
          (alert "벽선이 아닙니다. 다시 시도하십시요.")
        )
      )
    )
  )
)
(defun wlh_m2 (/ exp_undo)
  (while tem
    (setvar "blipmode" 1)
    (setvar "osmode" 512)
    (setq exp_undo nil
	  pt3      nil
	  pt4      nil
    )
    (setq nextpt (getpoint "\n>>> Select second point: "))
    (setvar "blipmode" 0)
    (setvar "osmode" 0)
    (cond
      ((null nextpt)
        (setq tem nil)
      )
      (T
        (if (ssget nextpt) ; 무언가 잡혔으면...
	  (progn
	    (setq ss (ssget "c" nextpt nextpt))
	    (setq e (entget (ssname ss 0)))
	    (if (or (= (fld_st 0 e) "POLYLINE")
		    (= (fld_st 0 e) "LWPOLYLINE")
		)    
	      (progn (command "_.undo" "m")
		     (command "_.explode" ss)
		     (setq exp_undo T)
	      )
	    )  
	    (setq ss (ssget "c" nextpt nextpt))
	    (setq e (entget (ssname ss 0)))
	    (if (= (fld_st 0 e) "LINE")
              (progn
		(setq tem nil
		      pt3  (fld_st 10 e) 
		      pt4  (fld_st 11 e)
		)
		(if (= exp_undo T) (command "_.undo" "b"))
		(if (and (not (inters pt1 pt2 pt3 pt4))
			 (not (or (equal pt1 pt3) (equal pt1 pt4)))
		    )
		  (progn
		    (command "_.undo" "m")
		    (setq temp T tem nil
		          uctr (1+ uctr)
		    )
		    (wlh_ex)
		  )
		  (progn
	 	    (alert "선택한 두 선이 일치하거나 교차점이 있습니다.")
		    (setq temp T tem nil)
		  )  
		)  
	      )
	      (alert "벽선이 아닙니다. 다시 시도하십시요.")
	    )
	  )  
          (alert "벽선이 아닙니다. 다시 시도하십시요.")
        )
      )
    )
  )
)
(defun wlh_dd(/ cancel_check)
  (setq cancel_check nil)
  (setq dcl_id (ai_dcl "wallh"))
  (if (not (new_dialog "dd_wallh" dcl_id)) (exit))
  (@get_eval_prop wlh_prop_type wlh:prop)
  
  (action_tile "b_name" "(@getlayer)")
  (action_tile "b_color" "(@getcolor)")
  (action_tile "color_image"  "(@getcolor)")
  (action_tile "c_bylayer" "(@bylayer_do T)")
  (action_tile "cancel" "(setq cancel_check T)(done_dialog)")
  (start_dialog)
  (done_dialog)
  (if (= cancel_check nil)
	(PROP_SAVE wlh:prop)
  )
)
(defun wlh_ex(/ dist1 dist2 temp_pt ent)
  ; pt1, pt2, pt3, pt4를 어느 순서로 연결할것인지 정한다.
  (setq dist1 (distance pt1 pt3)
	dist2 (distance pt1 pt4)
  )
  (if (> dist1 dist2)
    (setq temp_pt pt3
	  pt3     pt4
	  pt4     temp_pt
    )
  )  
  (command "_.pline" pt1 pt2 pt4 pt3 "_c")
  (setq ent (entlast))
  (set_col_lin_lay wlh:Hprop)
  (command "_.HATCH" wlh:hat wlh:sca "" ent "")
  (command "_.ERASE" ent "")
  
)

(if (null wlh:sca) (setq wlh:sca (getvar "dimscale")))

(setq wlh:Hprop  (Prop_search "walhat" "hatch"))
(setq wlh:prop '(wlh:Hprop))

(if (null wlh_prop_type) (setq wlh_prop_type "rd_hatch"))

(defun C:cimwlb ()
	(princ "\nArchiFree 2002 for AutoCAD LT 2002.")
	(princ "\n블럭(BLOCK) 해치 명령입니다.")	
	(m:wlh "block")
)
(defun C:CIMWLH () 
	(princ "\nArchiFree 2002 for AutoCAD LT 2002.")
	(princ "\n벽돌(BRICK) 해치 명령입니다.")	
	(m:wlh "brick")
)
(defun C:cimconc ()
	(princ "\nArchiFree 2002 for AutoCAD LT 2002.")
	(princ "\n콘크리트(CONC) 해치 명령입니다.")	
	(m:wlh "conc")
)

(princ)
