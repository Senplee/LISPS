;수정날짜 :2001.8.13 
;작업자 :박율구
;명령어 :C:CIMRUB () 잡석그리기
;       C:CIMINSUL () 단열선 그리기
;       C:CIMHB () 박스해치기
;       C:CIMPA () 패터 해치기
;       C:CIMPK () 주차장 그리기
;       C:CIMRD () 루프드레인 그리기
;수정라인:

;단축키 관련 변수 정의 부분
(setq lfn06 1)

;;=============================================================================
; 잡석 그리기
(defun m:rub (/
             ang      strtpt   nextpt   uctr     cont     temp     tem
             rub_osa)

  (setq rub_osa (getvar "snapang"))
  ;;
  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")

  (command "_.color" "_bylayer")

  (if (lacolor rub:lay)
    (setq rub:col (lacolor rub:lay)
    )
    (setq rub:col co_2
    )
  )

  (setlay rub:lay)
  (command "_.layer" "_C" rub:col ""  "")

 (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
 (princ "\n잡석을 그리는 명령입니다.")

  (setq cont T temp T uctr 0)

  (while cont
    (rub_m1)
    (rub_m2)
    (rub_m3)
  )

  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ)
)

(defun rub_m1 ()
  (while temp
    
    (setvar "osmode" 33)
    (princ (strcat "\nThickness:" (rtos rub:thk)
                   ))
    (if (> uctr 0)
      (progn
        (initget "/ Color Layer Thickness Undo")
        (setq strtpt (getpoint
          "\n>>> Color/Layer/Thickness/Undo/<start point>: "))
      )
      (progn
        (initget "/ Color Layer Thickness")
        (setq strtpt (getpoint "\n>>> Color/Layer/Thickness/<start point>: "))
      )
    )
    (cond
      ((= strtpt "Color")
        (rub_col)
      )
      ((= strtpt "Layer")
        (rub_lay)
      )
      
      ((= strtpt "Thickness")
        (rub_thk)
      )
      ((= strtpt "/")
        (cim_help "RUB")
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

(defun rub_m2 ()
  (while tem
    (setvar "blipmode" 1)
    (setvar "snapbase" (list (car strtpt) (cadr strtpt)))
    (initget "/ Color Layer Thickness Undo")
    (setq nextpt (getpoint strtpt
      "\n>>> Color/Layer/Thickness/Undo/<next point>: "))
    (setvar "blipmode" 0)
    (setvar "snapbase" '(0 0))
    (setvar "osmode" 0)
    (cond
      ((= nextpt "Color")
        (rub_col)
      )
      ((= nextpt "Layer")
        (rub_lay)
      )
     
      ((= nextpt "Thickness")
        (rub_thk)
      )
      ((= nextpt "/")
        (cim_help "RUB")
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
          (setq tem nil pt3 T)
          
        )
      )
    )
  )
)
(defun rub_m3 (/ ar_r1 ar_r2 90ang)
  (while pt3
    (initget "~ / Color Layer THickness Undo")
    (setvar "blipmode" 1)
    (setvar "osmode" 128)
    (setq pt3 (getpoint strtpt
          (strcat "\n    Color/Layer/THickness/Undo/<Thickness:" (rtos rub:thk) ">: ")))
    (setvar "blipmode" 0)
    (setvar "osmode" 0)
    (cond
      ((= pt3 "Undo")
        (setq pt3 nil tem T)
      )
      ((= pt3 "Color")
        (rub_col)
      )
      ((= pt3 "Layer")
        (rub_lay)
      )
      
      ((= pt3 "THickness")
        (rub_thk)
      )
     
      
      ((or (= (type pt3) 'LIST) (null pt3))
                   (setq 90ang (fix_90_ang (angle strtpt nextpt) (angle strtpt pt3)))
                (if (null pt3)
                  (setq pt3 (polar strtpt (+ (angle strtpt nextpt) (/ pi 2)) rub:thk))
                  (setq pt3 (polar strtpt 90ang (distance strtpt pt3)))
                )
                  
            (command "_.undo" "_m")
            (rub_ex)
            (setq uctr (1+ uctr))
            (setq pt3     nil
                  temp    T
            ) 
      )
      (T
        (setq pt3 nil cont nil)
      )
    )
  )
)
(defun rub_ex (/ p1 p2 ang l)
  (setq p1  strtpt
        p2  nextpt
        rub:thk (distance p1 pt3)
        ang (angle p1 p2)
        l   (distance p1 p2)
  )
  (command "_.insert" "rubble" p1 rub:thk "" (rtd ang))
  (if (< 90ang 0) (command "_mirror" "L" ""  p1 p2 "Y"))
  
  (setvar "snapang" ang)
  (command "_.array" "l" "" "_r" 1
           (fix (/ l (* 0.6 rub:thk))) (* 0.6 rub:thk))
  (setvar "snapang" rub_osa)
)

(defun rub_thk (/ thk)
  (initget (+ 2 4))
  (setq thk (getint (strcat "\n    Rubble_thickness <" (rtos rub:thk) ">: ")))
  (if (numberp thk) (setq rub:thk thk))
)

(defun rub_col ()
  (setq ecolor
    (if (= (type rub:col) 'STR) (get_num rub:col) rub:col)
  )
  (if (numberp (setq temp_color (acad_colordlg ecolor t)))
    (progn
      (setq ecolor temp_color)
      (setq rub:col ecolor)
      (if (and (/= rub:col 256) (/= rub:col 0))
        (command "_.layer" "_C" rub:col "" "")
      )
    )
  )
)
;;
;; This function pops a dialogue box consisting of a list box,image tile, and 
;; edit box to allow the user to select or type a layer name.  It returns the 
;; layer name selected.  It also has a button to find the status (On, Off, 
;; Frozen, etc.) of any layer selected.
;;
(defun rub_lay (/ old-idx layname on off frozth)
  (setq elayer  rub:lay)

  (cond
;;    (  (not (ai_notrans)))                      ; Not transparent?
    (  (not (ai_acadapp)))                      ; ACADAPP.EXP xloaded?
    (  (not (setq dcl_id (ai_dcl "dd_prop"))))  ; is .DLG file loaded?
    (t (ai_undo_push)
       (make_laylists)                          ; layer list - laynmlst
       (setq lay-idx (get_index elayer laynmlst))
    )
  )
  (if (not (new_dialog "setlayer" dcl_id))
    (exit)
  )
  (set_tile "cur_layer" (getvar "clayer"))
  (start_list "list_lay")
  (mapcar 'add_list longlist)  ; initialize list box
  (end_list)
  (setq old-idx lay-idx)
  (lay_list_act (itoa lay-idx))
  (action_tile "list_lay" "(lay_list_act $value)")
  (action_tile "edit_lay" "(rub_lay_edit $value)")
  (action_tile "accept"   "(rub_ok)")
  (action_tile "cancel"   "(reset_lay)")
  (if (= (start_dialog) 1)                         ; User pressed OK
    (setq ecolor rub:col
         
    )
  )
  (setlay rub:lay)
  (command "_.layer" "_C" rub:col ""  "")
)


;;
;; Reset to original layer when cancel is selected.
;;
(defun reset_lay ()
  (setq lay-idx old-idx)
  (done_dialog 0)
)

(defun rub_ok ()
  (setq rub:lay layname)
  (if (lacolor layname)
    (prop_save ins:prop)
    (setq rub:col (lacolor layname)
    )
  )
  (done_dialog 1)
)
;;
;; Edit box selections end up here.  Convert layer entry to upper case.  If 
;; layer name is valid, clear error string, call (lay_list_act) function,
;; and change focus to list box.  Else print error message.
;;
(defun rub_lay_edit (layvalue)
  (setq layvalue (strcase layvalue))
  (if (setq lay-idx (get_index layvalue laynmlst))
    (progn
      (set_tile "error" "")
      (lay_list_act (itoa lay-idx))
    )
    (progn
      (set_tile "error" "")
      (setq layname layvalue)
    )
  )
)

(if (null rub:lay) (setq rub:lay "MATR"))
(if (null rub:thk) (setq rub:thk 200))

(defun C:CIMRUB () (m:rub))
(princ)

;=============================================================================
; 단열재 그리기
(defun m:ins (/
            ins      d2       d3       pt1      pt2      pt3      pt4
            pt5      pt5x     pt6      pt7      pt8      pt9      pt10
            pt11     pt12     pt13     pt14     ptc      ptcn     ptc1
            ptc2     strtpt   nextpt   ang      ang1     ang2     ss
            ls       ins_oor no       ins_osm  ins_oco  ins_oli
            ins_ola  ins_ang  ins_err  ins_oer  uctr
            ins_ssget ins_entlast)
  
  
  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")

 (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
 (princ "\n단열재를 그리는 명령입니다.")

  (setq cont T temp T uctr 0)

  (while cont
    (ins_m1)
    (ins_m2)
    (ins_m3)
   
  )

  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)

  (princ)
)

(defun ins_m1 ()
  (while temp
    (setvar "blipmode" 1)
    (setvar "osmode" 33)
    (if (> uctr 0)
      (progn
        (initget "Dialog Undo")
        (setq strtpt (getpoint
          "\n>>> Dialog/Undo/<start point>: "))
      )
      (progn
        (initget "Dialog")
        (setq strtpt (getpoint
              "\n>>> Dialog/<start point>: "))
      )
    )
    (setvar "osmode" 0)
    (setvar "blipmode" 0)
    (cond
      ((= strtpt "Dialog")
        (dd_ins)
      )
      ((= strtpt "Undo")
        (command "_.undo" "_B")
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

(defun ins_m2 ()
  (while tem
    (initget "Dialog Undo")
    (setvar "blipmode" 1)
    (setvar "osmode" 33)
    (setq nextpt (getpoint strtpt
          "\n    Dialog/Undo/<next point>: "))
    (setvar "blipmode" 0)
    (setvar "osmode" 0)
    (cond
      ((= nextpt "Undo")
        (setq tem nil temp T)
      )
      ((= nextpt "Dialog")
        (dd_ins)
      )
      ((null nextpt)
        (setq cont nil tem nil)
      )
      (T
        (if (equal strtpt nextpt (* 0.4 ins:thk))
          (alert "Invalid length -- Try again.")
          (setq tem nil pt3 T)
        )
      )
    )
  )
)

(defun ins_m3 (/ ar_r1 ar_r2 90ang)
  (while pt3
    (setvar "blipmode" 1)
    (setvar "osmode" 128)
    (setvar "orthomode" 0)
    (initget "Dialog Undo")
    (if (/= tg_thick T)
            (progn
                    (setq pt3 (getpoint strtpt
                  (strcat "\n    Dialog/Undo/<Direction>: ")))
        )
        (progn
                (setq pt3 (getpoint strtpt
                  (strcat "\n    Dialog/Undo/<Thickness>: ")))
        )
    )          
    (setvar "blipmode" 0)
    (setvar "osmode" 0)
       
    (cond
      ((= pt3 "Undo")
        (setq pt3 nil tem T)
      )
      ((= pt3 "Dialog")
        (dd_ins)
      )
      ;((or (= (type pt3) 'LIST) (= pt3 nil))
      ((= (type pt3) 'LIST)
        (setq 90ang (fix_90_ang (angle strtpt nextpt) (angle strtpt pt3)))
        (if (null pt3)
          (setq pt3 (polar strtpt (+ (angle strtpt nextpt) (/ pi 2)) ins:thk))
          (setq pt3 (polar strtpt 90ang (distance strtpt pt3)))
        )
        (command "_.undo" "_M")
        (ins_ex)
        (setq uctr (1+ uctr))
        (setq pt3 nil temp T)
        (princ " \n")
      )     
      (T
        (setq pt3 nil cont nil)
      )
    )
  )
)

(defun ins_ex (/ sa ssget_pt ssget_pt1)
  (setq sa (getvar "snapang"))
  (if (= tg_thick T) (setq ins:thk (distance strtpt pt3)))
  (setq pt1  strtpt
        pt2  nextpt
        ang  (angle pt1 pt2)
        ang1 (angle pt1 pt3)
        d1   (distance pt1 pt2)
  )

  (set_col_lin_lay ins:insprop)
  (command "_.insert" "*insul" pt1 ins:thk (Rtd ang) )
  (if (< 90ang 0) (command "_mirror" "L" ""  pt1 pt2 "Y"))
  
  (if (= ins:typ "Curve")
    (command "_.pedit" "_L" "_F" "")
  )
  
  (command "_.chprop" "_L" "" "_LA" (getvar "clayer") "_C" (getvar "cecolor") "")  
  
  (setvar "snapang" ang)  
  (setq ins_entlast (entlast))
  (command "_.array" "_l" "" "_r" 1 (fix (/ d1 (* 0.4 ins:thk)))
           (* 0.4 ins:thk))                
  (setq ins_ssget (ssget "C" (polar pt1 90ang 0.5) (polar pt2 90ang 0.8))  )    
  (command "_.pedit" ins_entlast "j" ins_ssget "" "") 
    
  (setvar "snapang" sa)
)

(if (null ins:typ) (setq ins:typ "Line"))
(if (null ins:thk) (setq ins:thk  50))

(defun ins_init ()
  ;;
  ;; Resets entity list to original values.  Called when the dialogue or function 
  ;; is cancelled.
  ;;
  (defun reset ()
    (if (not ins:thk) (setq ins:thk 50))
    (setq reset_flag t)
  )

  ;;
  ;; Common properties for all entities
  ;;
  (defun set_tile_props ()
    
    (cond
      ((= ins:typ "Line")
        (ci_image "ins_type" "cim2(ins_1)")
      )
      ((= ins:typ "Curve")
        (ci_image "ins_type" "cim2(ins_2)")
      )
    )
    (radio_do)

    (set_tile "l_thickness" (rtos ins:thk))
    (if (= tg_thick nil)
      (progn
        (set_tile "tg_thick" "1")
        (mode_tile "l_thickness" 0)
      )
      (progn
        (set_tile "tg_thick" "0")
        (mode_tile "l_thickness" 1)
      )         
    )
  )

  ;; Set common action tiles
  ;;
  ;; Defines action to be taken when pressing various widgets.  It is called 
  ;; for every entity dialogue.  Not all widgets exist for each entity dialogue,
  ;; but defining an action for a non-existent widget does no harm.
  (defun set_action_tiles ()
    (action_tile "line"         "(radio_gaga \"line\")")
    (action_tile "curve"        "(radio_gaga \"curve\")")    
    (set_tile ins_prop_type "1")    
    (@get_eval_prop ins_prop_type ins:prop)     
    (action_tile "b_name" "(@getlayer)")
    (action_tile "b_color" "(@getcolor)")
    (action_tile "color_image" "(@getcolor)")
    (action_tile "c_bylayer" "(@bylayer_do T)"); T=color or nil=linetype    
    (action_tile "l_thickness"  "(getthickness $value)")
    (action_tile "tg_thick"     "(sel_thick $value)")
    (action_tile "accept"       "(dismiss_dialog 1)")
    (action_tile "cancel"       "(dismiss_dialog 0)")
    ;(action_tile "help"         "(cim_help \"INSUL\")")
  )
  (defun sel_thick(value)
    (if (= value "0")
      (progn
        (mode_tile "l_thickness" 1)
        (setq tg_thick T)
      )
      (progn
        (mode_tile "l_thickness" 0)
        (setq tg_thick nil)
      )        
    )  
  )  
  ;; As OW doesn't support disabling of individual radio buttons within 
  ;; clusters, a check must be performed as to the legitimacy of the 
  ;; button pushed and reset if necessary.
  (defun radio_gaga (pushed)
    (cond 
      ((= pushed "line")
        (set_tile "line" "1")
        (ci_image "ins_type" "cim2(ins_1)")
        (setq ins:typ "Line")
      )
      ((= pushed "curve")
        (set_tile "curve" "1")
        (ci_image "ins_type" "cim2(ins_2)")
        (setq ins:typ "Curve")
      )
    )
  )

  (defun radio_do ()
    (cond
      ((= ins:typ "Line")
        (set_tile "line" "1")
      )
      ((= ins:typ "Curve")
        (set_tile "curve" "1")
      )
    )
  )

  ;;
  ;; Reset to original linetype when cancel it selected
  ;;
  (defun reset_lt ()
    ;(setq ltname ins:lin)
    (done_dialog 0)
  )
  
  ;;
  ;; Reset to original layer when cancel is selected.
  ;;
  (defun reset_lay ()
    (setq lay-idx old-idx)
    (done_dialog 0)
  )
  ;;
  ;; Checks validity of thickness from edit box.
  (defun getthickness (value)
    (setq ins:thk (verify_d "l_thickness" value ins:thk))
  )
  ;;
  ;; Verification functions
  ;;
  ;; Verify distance function.  This takes a new X, Y, or Z coordinate or 
  ;; distance value, the tile name, and the previous value as arguments.
  ;; If the distance is valid, it returns the distance and resets the tile.
  ;; Otherwise, it returns the previous value, sets the error tile and keeps
  ;; focus on the tile.  Shifting focus to the tile with invalid value can
  ;; trigger a callback from another tile whose value is valid.  In order
  ;; to keep the error message from being cleared by this secondary callback,
  ;; the variable errchk is set and checked.  The last-tile variable is set
  ;; and checked to ensure the error message is properly cleared when the
  ;; user corrects the value and hits return.
  ;;
  (defun verify_d (tile value old-value / coord valid errmsg)
    (setq valid nil errmsg "Invalid input value.")
    (if (setq coord (distof value))
      (progn
        (cond
          ((= tile "l_thickness")
            (if (> coord 0)
              (if (>= coord 1)
                (setq valid T)
                (setq errmsg "Value must be not less than 1.")
              )
              (setq errmsg "Value must be positive and nonzero.")
            )
          )
          (T (setq valid T))
        )
      )
      (setq valid nil)
    )
    (if valid
      (progn 
        (if (or (= errchk 0) (= tile last-tile))
          (set_tile "error" "")
        )
        (set_tile tile (rtos coord))
        (setq errchk 0)
        (setq last-tile tile)
        coord
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


  ;;
  ;; If their is no error message, then close the dialogue.
  ;;
  (defun dismiss_dialog (action)
    (if (= action 0)
      (progn 
                   (setq ins:insprop old:insprop)
             (done_dialog 0)
      )
      (if (= (get_tile "error") "")
              (progn             
             (done_dialog action)
        )
      )
    )
  )

  (defun test_ok ()
    (if (= (get_tile "error") "")
      (progn
        (done_dialog 1)
      )
    )
  )

  (defun cancel ()
    (done_dialog 0)
  )
) ; end ins_init

(defun ins_do ()
    
  (if (not (new_dialog "dd_ins" dcl_id)) (exit))
  (set_tile_props)
  (set_action_tiles)
  (setq dialog-state (start_dialog))
  (if (= dialog-state 0)
    (reset)
  )
)

(defun ins_return ()
  (setq   
        ins:col old_col        
        ins:typ old_typ
        ins:thk old_thk
  )
)
;;; ================== (dd_ins) - Main program ========================
;;;
;;; Before (dd_ins) can be called as a subroutine, it must
;;; be loaded first.  It is up to the calling application to
;;; first determine this, and load it if necessary.

(defun dd_ins (/
           cancel           color            dialog-state     
           dismiss_dialog   ecolor           elayer           eltype
           getdrag          getthickness     lay-idx          laylist          layname
           laynmlst         layvalue         longlist         lst
           lt-idx           ltabstr          ltest_ok         ltname
           ltvalue          old_lay
           old_col          old_lin          old_thk          old_typ
           old-idx          old_thk          radio_do         radio_gaga
           reset            reset_flag       reset_lay        reset_lt
           set_action_tiles set_tile_props   sortlist         tcolor
           temp_color       test_ok          tile             tilemode
           toggle_do        value            verify_d)

  (setvar "cmdecho" (cond (  (or (not *debug*) (zerop *debug*)) 0)
                          (t 1)))

  (setq old:insprop ins:insprop)
  (setq 
        old_col ins:col
        old_typ ins:typ        
        old_thk ins:thk
  )

   (princ ".")
  (cond
;;     (  (not (ai_notrans)))                      ; Not transparent?
     (  (not (ai_acadapp)))                      ; ACADAPP.EXP xloaded?
     (  (not (setq dcl_id (ai_dcl "dd_lib"))))   ; is .DLG file loaded?

     (t (ai_undo_push)
        (princ ".")
        (ins_init)                              ; everything okay, proceed.
        (princ ".")
        (ins_do)
     )
  )
  (if reset_flag
    (ins_return)    
  )
)
;====================<< 1 >>=====================================
(setq ins:insprop  (Prop_search "ins" "ins"))
(setq ins:prop '(ins:insprop))

(if (null ins_prop_type) (setq ins_prop_type "rd_ins"))
;======================================================================


(defun C:CIMINSUL () (m:ins))
(princ)

    
;=============================================================================
;                           박스 해치하기                                     
;=============================================================================
(defun m:hb (/ bm
             sc       strtpt   nextpt   uctr     cont     temp     tem
             hb_ola   hb_oco   hb_err   hb_oer   hb_osm   )

  (setq hb_oco (getvar "cecolor")
        hb_ola (getvar "clayer")
        hb_osm (getvar "osmode")
        sc     (getvar "dimscale")
        bm     (getvar "blipmode")
  )
  ;;
  ;; Internal error handler defined locally
  ;;
  (defun hb_err (s)                   ; If an error (such as CTRL-C) occurs
                                       ; while this command is active...
    (if (/= s "Function cancelled")
      (if (= s "quit / exit abort")
        (princ)
        (princ (strcat "\nError: " s))
      )
    )
    (setvar "cmdecho" 0)
    (if hb_oer                        ; If an old error routine exists
      (setq *error* hb_oer)           ; then, reset it 
    )
    (if hb_oco (command "_.color" hb_oco))
    (if hb_ola (command "_.layer" "_s" hb_ola ""))
    (if hb_osm (setvar "osmode" hb_osm))
    
    (setvar "blipmode" 1)
    (setvar "snapbase" '(0 0))
    (ai_undo_off)
    (command "_.undo" "_en")
    (setvar "blipmode" bm)
    (setvar "cmdecho" 1)
    (princ)
  )
  ;; Set our new error handler
  (if (not *DEBUG*)
    (if *error*                     
      (setq hb_oer *error* *error* hb_err) 
      (setq *error* hb_err) 
    )
  )

  (setvar "cmdecho" 0)
  (ai_undo_on)
  (command "_.undo" "_group")

  (command "_.color" "_bylayer")

  (if (lacolor hb:lay)
    (setq hb:col (lacolor hb:lay))
    (setq hb:col co_2)
  )

  (setlay hb:lay)

  (command "_.layer" "_C" hb:col "" "")

 (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
 (princ "\n박스형태로 해칭하는 명령입니다.")

  (setq cont T temp T uctr 0)

  (while cont
    (hb_m1)
    (hb_m2)
  )

  (if hb_oco (command "_.color" hb_oco))
  (if hb_ola (command "_.layer" "_S" hb_ola ""))
  (if hb_osm (setvar "osmode" hb_osm))

  (command "_.undo" "_en")
  (ai_undo_off)

  (setvar "cmdecho" 1)
  (setvar "blipmode" bm)
  (princ)
)

(defun hb_m1 ()
  (while temp
    (setvar "blipmode" 1)
    (setvar "osmode" 33)
    (princ (strcat "\nPattern:" hb:pat
                   "  Scale:" (rtos hb:sca)
                   "  Angle:" (angtos hb:ang)
                   "  Thickness:" (rtos hb:thk)))
    (if (> uctr 0)
      (progn
        (initget "/ Angle Color Layer Pattern Scale Thickness Undo")
        (setq strtpt (getpoint
          "\n>>> Angle/Color/Layer/Pattern/Scale/Thickness/Undo/<start point>: "))
      )
      (progn
        (initget "/ Angle Color Layer Pattern Scale Thickness")
        (setq strtpt (getpoint
          "\n>>> Angle/Color/Layer/Pattern/Scale/Thickness/<start point>: "))
      )
    )
    (cond
      ((= strtpt "Angle")
        (hb_ang)
      )
      ((= strtpt "Color")
        (hb_col)
      )
      ((= strtpt "Layer")
        (hb_lay)
      )
      ((= strtpt "Pattern")
        (hb_pat)
      )
      ((= strtpt "Scale")
        (hb_sca)
      )
      ((= strtpt "Thickness")
        (hb_thk)
      )
      ((= strtpt "/")
        (cim_help "HB")
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

(defun hb_m2 ()
  (while tem
    (setvar "blipmode" 1)
    (setvar "snapbase" (list (car strtpt) (cadr strtpt)))
    (initget "/ Angle Color Layer Pattern Scale Thickness Undo")
    (setq nextpt (getpoint strtpt
      "\n>>> Angle/Color/Layer/Pattern/Scale/Thickness/Undo/<next point>: "))
    (setvar "blipmode" 0)
    (setvar "snapbase" '(0 0))
    (setvar "osmode" 0)
    (cond
      ((= nextpt "Angle")
        (hb_ang)
      )
      ((= nextpt "Color")
        (hb_col)
      )
      ((= nextpt "Layer")
        (hb_lay)
      )
      ((= nextpt "Pattern")
        (hb_pat)
      )
      ((= nextpt "Scale")
        (hb_sca)
      )
      ((= nextpt "Thickness")
        (hb_thk)
      )
      ((= nextpt "/")
        (cim_help "HB")
      )
      ((= nextpt "Undo")
        (setq tem nil temp T)
      )
      ((null nextpt)
        (setq tem nil cont nil)
      )
      (T
        (if (< (distance strtpt nextpt) 1)
          (alert "Coincident point -- Try again.")
          (progn
            (command "_.undo" "_m")
            (hb_ex)
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

(defun hb_ex (/ p1 p2 ang l p3 p4 ss k)
  (setq p1  strtpt
        p2  nextpt
        ang (angle p1 p2)
        l   (distance p1 p2)
        p3  (polar p2 (+ ang (dtr 90)) hb:thk)
        p4  (polar p3 (+ ang pi) l)
  )
  (command "_.pline" p1 p2 p3 p4 "_c")
  (command "_.hatch" hb:pat hb:sca (rtd hb:ang) "_l" "")
  (command "_.erase" "_p" "")
  (setq ss (ssget "C" p1 p3))
  (setq k 0)
  (while (ssname ss k)
    (redraw (ssname ss k))
    (setq k (1+ k))
  )
)

(defun hb_ang (/ sca)
  (setq ang (getangle (strcat "\n    Pattern_angle <" (angtos hb:ang) ">: ")))
  (if (numberp ang) (setq hb:ang ang))
)

(defun hb_pat (/ pat)
  (setq pat (getstring (strcat "\n    Pattern_name <" hb:pat "/?>: ")))
  (if (/= pat "") (setq hb:pat pat))
  (while (= hb:pat "?")
    (menucmd "i=hatch1z")
    (menucmd "i=*")
    (princ ">>>해치 패턴 이름: ")
    (setq pat (getstring))
    (if (/= pat "") (setq hb:pat pat))
    (princ " \n")
  )
  (cond
    ((instr hb:pat "@")
      (setq hb:scl 1)
    )
    ((instr hb:pat "$")
      (setq hb:scl sc)
    )
  )
  (if (or (= hb:sca nil) (= hb:sca 1))
    (setq hb:sca sc)
  )
  (if hb:scl
    (setq hb:sca hb:scl)
  )
  (if (or (instr hb:pat "@") (instr hb:pat "$"))
    (progn
      (setq hb:pat (substr hb:pat 2))
      (princ "\n>>>This pattern is recommended the default scale.\n")
    )
  )
  (initget (+ 2 4))
  (setq inp (getreal (strcat "해치 축척 <" (rtos hb:sca) ">: ")))
  (if (numberp inp) (setq hb:sca inp))
  (setq inp (getangle (strcat "해치 축척<" (angtos hb:ang) ">: ")))
  (if (numberp inp) (setq hb:ang inp))
)

(defun hb_sca (/ sca)
  (initget (+ 2 4))
  (setq sca (getreal (strcat "\n해치 축척 <" (rtos hb:sca) ">: ")))
  (if (numberp sca) (setq hb:sca sca))
)

(defun hb_thk (/ thk)
  (initget (+ 2 4))
  (setq thk (getreal (strcat "\n    Hatching_thickness <" (rtos hb:thk) ">: ")))
  (if (numberp thk) (setq hb:thk thk))
)

(defun hb_col ()
  (setq ecolor
    (if (= (type hb:col) 'STR) (get_num hb:col) hb:col)
  )
  (if (numberp (setq temp_color (acad_colordlg ecolor t)))
    (progn
      (setq ecolor temp_color)
      (setq hb:col ecolor)
      (if (and (/= hb:col 256) (/= hb:col 0))
        (command "_.layer" "_C" hb:col "" "")
      )
    )
  )
)
;;
;; This function pops a dialogue box consisting of a list box,image tile, and 
;; edit box to allow the user to select or type a layer name.  It returns the 
;; layer name selected.  It also has a button to find the status (On, Off, 
;; Frozen, etc.) of any layer selected.
;;
(defun hb_lay (/ old-idx layname on off frozth)
  (setq elayer  hb:lay)

  (cond
 ;;   (  (not (ai_notrans)))                      ; Not transparent?
    (  (not (ai_acadapp)))                      ; ACADAPP.EXP xloaded?
    (  (not (setq dcl_id (ai_dcl "dd_prop"))))  ; is .DLG file loaded?
    (t (ai_undo_push)
       (make_laylists)                          ; layer list - laynmlst
       (setq lay-idx (get_index elayer laynmlst))
    )
  )
  (if (not (new_dialog "setlayer" dcl_id))
    (exit)
  )
  (set_tile "cur_layer" (getvar "clayer"))
  (start_list "list_lay")
  (mapcar 'add_list longlist)  ; initialize list box
  (end_list)
  (setq old-idx lay-idx)
  (lay_list_act (itoa lay-idx))
  (action_tile "list_lay" "(lay_list_act $value)")
  (action_tile "edit_lay" "(hb_lay_edit $value)")
  (action_tile "accept"   "(hb_ok)")
  (action_tile "cancel"   "(reset_lay)")
  (if (= (start_dialog) 1)                         ; User pressed OK
    (setq ecolor hb:col
          eltype hb:lin
    )
  )
  (setlay hb:lay)
  (command "_.layer" "_C" hb:col "" "_L" hb:lin "" "")
)

(defun hb_lin (/ old-idx on off frozth test_ok reset_lt)
  ;;
  ;; this function pops a dialogue box consisting of a list box, image tile, and 
  ;; edit box to allow the user to select or  type a linetype.  It returns the 
  ;; linetype selected.
  ;;
  (defun hb_ltype (/ old-idx)
    (if (not ltnmlst)
      (make_ltlists)                    ; linetype lists - ltnmlst, mdashlist
    )
    (setq lt-idx (get_index eltype ltnmlst))
    (if (not (new_dialog "setltype" dcl_id)) (exit))
    (start_list "list_lt")
    (mapcar 'add_list ltnmlst)                        ; initialize list box
    (end_list)
    (setq old-idx lt-idx)
    (lt_list_act (itoa lt-idx))

    (action_tile "list_lt" "(lt_list_act $value)")
    (action_tile "edit_lt" "(lt_edit_act $value)")
    (action_tile "accept"  "(test_ok)")
    (action_tile "cancel"  "(reset_lt)")

    (if (= (start_dialog) 1) ; User pressed OK
      (cond 
        ((= lt-idx 0)
          "BYLAYER"
        )
        ((= lt-idx 1)
          "BYBLOCK"
        )
        (T
          ltname
        )
      )
      eltype
    )
  )

  (defun test_ok ()
    (if (= (get_tile "error") "")
      (progn
        (if (and (/= ltname "BYBLOCK") (/= ltname "BYLAYER"))
          (setq hb:lin ltname)
        )
        (done_dialog 1)
      )
    )
  )
  ;;
  ;; Reset to original linetype when cancel it selected
  ;;
  (defun reset_lt ()
    (setq ltname hb:lin)
    (done_dialog 0)
  )

  (setq ltname hb:lin
        eltype hb:lin
  )
  (setq ecolor
    (if (= (type hb:col) 'STR) (get_num hb:col) hb:col)
  )

  (cond
;;    (  (not (ai_notrans)))                      ; Not transparent?
    (  (not (ai_acadapp)))                      ; ACADAPP.EXP xloaded?
    (  (not (setq dcl_id (ai_dcl "dd_prop"))))  ; is .DLG file loaded?
    (t (ai_undo_push)
      (setq eltype (hb_ltype))
      (command "_.layer" "_L" hb:lin "" "")
    )
  )
)
;;
;; Reset to original layer when cancel is selected.
;;
(defun reset_lay ()
  (setq lay-idx old-idx)
  (done_dialog 0)
)

(defun hb_ok ()
  (setq hb:lay layname)
  (if (lacolor layname)
    (setq hb:col (lacolor layname)
          hb:lin (laltype layname)
    )
  )
  (done_dialog 1)
)
;;
;; Edit box selections end up here.  Convert layer entry to upper case.  If 
;; layer name is valid, clear error string, call (lay_list_act) function,
;; and change focus to list box.  Else print error message.
;;
(defun hb_lay_edit (layvalue)
  (setq layvalue (strcase layvalue))
  (if (setq lay-idx (get_index layvalue laynmlst))
    (progn
      (set_tile "error" "")
      (lay_list_act (itoa lay-idx))
    )
    (progn
      (set_tile "error" "")
      (setq layname layvalue)
    )
  )
)

(if (null hb:lay) (setq hb:lay "HATCH"))
(if (null hb:thk) (setq hb:thk (* (getvar "dimscale") 5)))
(if (null hb:sca) (setq hb:sca (getvar "dimscale")))
(if (null hb:ang) (setq hb:ang 0))
(if (null hb:pat) (setq hb:pat "earth"))

(defun C:CIMHB () (m:hb))
(princ)

;=============================================================================
; 해치하기
(defun m:PA (/ pa_err pa_oer pa_oco pa_osm sc p1 p1x p1y ss
               pa_ola hpnk hpsk hpak hpdk hp_scl pa:col)
 (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
 (princ "\n해칭하는 명령입니다.")

  (setq sc (getvar "dimscale"))
  ;;
  (ai_err_on)
  (ai_undo_on)
  (setvar "blipmode" 1)
  (command "_.undo" "_group")
  ;(princ "\n해치 영역 선택 ")
  (setq ss (ssget))
  (if (= ss nil)
    (exit)
  )
  (setvar "osmode" 32)
  (initget 1)
  (setq p1 (getpoint "기준점: INTERSEC of "))
  (setvar "osmode" 0)
  (setq p1x (car p1)
        p1y (cadr p1)
  )
  (if (= hp_n nil) (setq hp_n "net"))
  (setq hpnk (getstring (strcat "\n해치 종류 <" hp_n "/?>: ")))
  (if (/= hpnk "") (setq hp_n hpnk))
  (while (= hp_n "?")
    (menucmd "i=hatch1z")
    (menucmd "i=*")
    (princ ">>>사용된 해치 이름 : ")
    (setq hpnk (getstring))
    (if (/= hpnk "") 
            (setq hp_n hpnk)
    )
    (princ " \n")
  )
  (if (= (instr hp_n "@") 1)
    (setq hp_scl 1)
  )
  (if (= (instr hp_n "&") 1)
    (setq hp_scl sc)
  )
  (if (or (= hp_sc nil) (= hp_sc 1))
    (setq hp_sc sc)
  )
  (if hp_scl
    (setq hp_sc hp_scl)
  )
  (if (= (instr hp_n "@") 1)
    (progn
      (setq hp_n (substr hp_n 2))
      (princ "\n>>>지금의 해치는 축척을 1로 하십시요.\n")
    )
  )
  (if (= (instr hp_n "&") 1) 
    (progn
      (setq hp_n (substr hp_n 2))
      (princ "\n>>>지금의 해치는 출력 축척과 같게 하십시요.\n")
    )
  )
  (initget (+ 2 4))
  (setq hpsk (getreal (strcat "해치 축척 <" (rtos hp_sc 2) ">: ")))
  (if (numberp hpsk) (setq hp_sc hpsk))
  (if (/= (type hp_dr) 'REAL) (setq hp_dr 0))
  (setvar "osmode" 512)
  (setq hpdk (getangle p1 (strcat
    "\nEnter 또는 해치 방향 지정 <" (angtos hp_dr)  ">: NEAREST to ")))
  (if (numberp hpdk) (setq hp_dr hpdk))
  (setvar "osmode" 0)
  (if (/= (type hp_an) 'REAL) (setq hp_an 0))
  (setq hpak (getangle (strcat
    "\n해치 각도 지정<" (angtos hp_an)  ">: ")))
  (if (numberp hpak) (setq hp_an hpak))
  (setvar "snapbase" (list p1x p1y))
  (if (lacolor "tile")
    (setq pa:col (lacolor "tile"))
    (setq pa:col co_til)
  )
  (setlay "tile")
  (command "_.layer" "_C" pa:col "" "")
  (command "_.color" "_bylayer")
  (command "_.hatch" hp_n hp_sc (rtd (+ hp_an hp_dr)) ss "")
  (command "_.color" pa_oco)
  (setvar "snapbase" '(0 0))
  (rtnlay)
  
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  
  (princ)
)

(defun C:CIMPA () (m:pa))
(princ)

;;=============================================================================
;;주차 구획 그리기

;;; Main function
;;;
(defun m:pk (/ strtpt   nextpt   pk:num
               cont     temp     tem      uctr     ptd
               )

  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")

  (command "_.color" "_bylayer")
  (command "_.linetype" "_S" "_bylayer" "")

  (if (lacolor pk:lay)
    (setq pk:col (lacolor pk:lay)
          pk:lin (strcase (laltype pk:lay))
    )
    (setq pk:col co_2
          pk:lin "CONTINUOUS"
    )
  )

  (setlay pk:lay)

  (command "_.layer" "_C" pk:col "" "_L" pk:lin "" "")

 (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
 (princ "\n주차 구획을 그리는 명령입니다.")

  (setq cont T temp T uctr 0)
  (if (null (stysearch "SIM")) (styleset "SIM"))
  (while cont
    (pk_m1)
    (pk_m2)
    (pk_m3)
  )

  
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  
  (princ)
)

(defun pk_m1 ()
  (while temp
    (setvar "blipmode" 1)
    (setvar "osmode" 33)
    (if (> uctr 0)
      (progn
        (princ (strcat ;"\nLinetype:" pk:lin
                       "\n주차각도:" (angtos pk:ang)
                       "  Diagonal:" pk:dia
                       "  기준점:" pk:bas
                       "\n주차구획 수:" (itoa pk:num)
                       "  총 주차구획 수:" (if (> total:pk:num 0) (itoa (1- total:pk:num)) "0") ))
        (initget "/ Angle Base Color Diagonal Number LAyer LInetype Offset Undo")
        (setq strtpt (getpoint
              "\n>>> Angle/Base/Color/Diagonal/Number/LAyer/LInetype/Offset/Undo/<start point>: "))
      )
      (progn
        (princ (strcat ; "\nLinetype:" pk:lin
                       "\n주차각도:" (angtos pk:ang)
                       "  Diagonal:" pk:dia
                       "  기준점:" pk:bas
                       "  시작번호:" (itoa total:pk:num)))
        (initget "Angle Base Diagonal Number Color LAyer LInetype Offset")
        (setq strtpt (getpoint
          "\n>>> Angle/Base/Color/Diagonal/Number/LAyer/LInetype/Offset/<start point>: "))
      )
    )
    (setvar "osmode" 0)
    (cond
      ((= strtpt "Angle")
        (pk_ang)
      )
      ((= strtpt "Base")
        (pk_bas)
      )
      ((= strtpt "Color")
        (pk_col)
      )
      ((= strtpt "Diagonal")
        (pk_dia)
      )
      ((= strtpt "LAyer")
        (pk_lay)
      )
      ((= strtpt "LInetype")
        (pk_lin)
      )
      ((= strtpt "Offset")
        (cim_ofs)
      )
      ((= strtpt "Number")
        (pk_num)
      )
      ((= strtpt "Undo")
        (command "_.undo" "_B")
        (setq total:pk:num (- total:pk:num pk:num))
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

(defun pk_m2 ()
  (while tem
    (initget "Angle Base Color Diagonal Number LAyer LInetype Undo")
    (setvar "blipmode" 1)
    (setvar "osmode" 33)
    ;(setvar "snapbase" (list (car strtpt) (cadr strtpt)))
    (setq nextpt (getpoint strtpt
      "\n Angle/Base/Color/Diagonal/Number/LAyer/LInetype/Undo/<next point>: "))
    (setvar "osmode" 0)
    ;(setvar "snapbase" '(0 0))
    (cond
      ((= nextpt "Undo")
        (setq tem nil temp T)
      )
      ((= nextpt "Angle")
        (pk_ang)
      )
      ((= nextpt "Base")
        (pk_bas)
      )
      ((= nextpt "Color")
        (pk_col)
      )
      ((= nextpt "Diagonal")
        (pk_dia)
      )
      ((= nextpt "LAyer")
        (pk_lay)
      )
      ((= nextpt "LInetype")
        (pk_lin)
      )
      ((= nextpt "Number")
        (pk_num)
      )
      ((null nextpt)
        (setq cont nil tem nil)
      )
      (T
        (if (< (distance strtpt nextpt) 2300)
          (alert "폭 지정이 부족합니다. -- 최소 2,300mm이상이어야 합니다.")
          (setq tem nil ptd T)
        )
      )
    )
  )
)

(defun pk_m3 (/ othmd)
  (while ptd
    (initget "Angle Base Color Diagonal Number LAyer LInetype Undo")
    (setq othmd (getvar "orthomode"))
    (setvar "orthomode" 0)
    (setq ptd (getpoint strtpt
          "\n Angle/Base/Color/Diagonal/Number/LAyer/LInetype/Undo/<direction>: "))
    (setvar "orthomode" othmd)
    (setvar "blipmode" 0)
    (cond
      ((= ptd "Undo")
        (setq ptd nil tem T)
      )
      ((= ptd "Angle")
        (pk_ang)
      )
      ((= ptd "Base")
        (pk_bas)
      )
      ((= ptd "Color")
        (pk_col)
      )
      ((= ptd "Diagonal")
        (pk_dia)
      )
      ((= ptd "LAyer")
        (pk_lay)
      )
      ((= ptd "LInetype")
        (pk_lin)
      )
      ((= ptd "Number")
        (pk_num)
      )
      ((= (type ptd) 'LIST)
        (command "_.undo" "_m")
        (if (= pk:ang (/ pi 2))
          (pk_ex)
          (pk_ax)
        )
        (setq uctr (1+ uctr))
        (setq ptd nil temp T)
      )
      (T
        (setq ptd nil cont nil)
      )
    )
  )
)

(defun pk_ex (/ pt1 pt2 ang ang1 ang2 d1 d2 pt1x pt2x ptcc)
  (setq pt1  strtpt
        pt2  nextpt
        ang  (angle pt1 pt2)
        ang1 (angle pt1 ptd)
        d1   (distance pt1 pt2)
  )
  (if (and (> ang1 ang) (< ang1 (+ ang pi)))
    (setq ang2 (+ ang pk:ang))
    (if (and (>= ang (dtr 270)) (< ang1 pi))
      (setq ang2 (+ ang pk:ang))
      (setq ang2 (- ang pk:ang))
    )
  )
  (setq pk:num (fix (/ d1 2300)))
  (cond
    ((= pk:bas "Start")
      (setq d2 0)
    )
    ((= pk:bas "End")
      (setq d2 (- d1 (* 2300 pk:num)))
    )
    ((= pk:bas "Center")
      (setq d2 (/ (- d1 (* 2300 pk:num)) 2))
    )
  )
  (setq pt1  (polar pt1 ang  d2)
        pt2  (polar pt1 ang2 5000)
        pt1x pt1
        pt2x pt2
  )
  (if (not (ssget "C" (polar pt1 ang2 2500) (polar pt1 ang2 2500)))
    (command "_.line" pt1 pt2 "")
  )
  
  (repeat pk:num
    (if (= pk:num:on "On") (progn
            (setq ptcc (polar (polar pt1 ang 400) ang2 400))
            (command "_text" "_S" "SIM" "MC" ptcc (if (> total:pk:num 99) 180 200) 0 (itoa total:pk:num))
            (command "_circle" ptcc 300)
            (setq total:pk:num (1+ total:pk:num))
            ))
    (setq pt1 (polar pt1 ang 2300))
    (if (= pk:dia "ON")
      (command "_.line" pt2 pt1 "") ;대각선
    )
    (setq pt2 (polar pt1 ang2 5000))
    (command "_.line" pt1 pt2 "")   ;위로.
    
  )
  (if (= pk:dia "ON")
    (progn
      (if (not (ssget "C" (polar pt1x ang 1250) (polar pt1x ang 1250)))
        (command "_.line" pt1x pt1 "")
      )
      (if (not (ssget "C" (polar pt2x ang 1250) (polar pt2x ang 1250)))
        (command "_.line" pt2x pt2 "")
      )
    )
  )
)

(defun pk_ax ()
  (setq pt1  strtpt
        pt2  nextpt
        ang  (angle pt1 pt2)
        ang1 (angle pt1 ptd)
        d1   (distance pt1 pt2)
  )
  (if (and (> ang1 ang) (< ang1 (+ ang pi)))
    (setq ang2 (+ ang  pk:ang)
          ang3 (+ ang2 (dtr 90)))
    (if (and (>= ang (dtr 270)) (< ang1 pi))
      (setq ang2 (+ ang  pk:ang)
            ang3 (+ ang2 (dtr 90)))
      (setq ang2 (- ang  pk:ang)
            ang3 (- ang2 (dtr 90)))
    )
  )
  (setq da (/ 2300 (cos (- (/ pi 2) pk:ang)))
        db (* 2300 (cos (- (/ pi 2) pk:ang)))
        dc (* 5000 (cos pk:ang))
        pk:num (fix (1+ (/ (- d1 db dc) da)))
  )
  (cond
    ((= pk:bas "Start")
      (setq d2 0)
    )
    ((= pk:bas "End")
      (setq d2 (- d1 (+ db dc (* da (1- pk:num)))))
    )
    ((= pk:bas "Center")
      (setq d2 (/ (- d1 (+ db dc (* da (1- pk:num)))) 2))
    )
  )
  (setq pt1 (polar pt1 ang (+ d2 db)))
  (repeat pk:num
    (if (= pk:num:on "On") (progn
            (setq ptcc (polar (polar pt1 ang3 1900) ang2 400))
            (command "_text" "_S" "SIM" "MC" ptcc (if (> total:pk:num 99) 180 200) 0 (itoa total:pk:num))
            (command "_circle" ptcc 300)
            (setq total:pk:num (1+ total:pk:num))
            ))
    (setq pt2 (polar pt1 ang2 5000)
          pt3 (polar pt2 ang3 2300)
          pt4 (polar pt3 (+ ang2 pi) 5000)
    )
    (if (= pk:dia "ON")
      (command "_.pline" pt1 pt2 pt3 pt4 pt1 pt3 "")
      (command "_.pline" pt1 pt2 pt3 pt4 "_C")
    )
    (setq pt1 (polar pt1 ang da))
  )
)

(defun pk_num (/ Tmpnum onoff tmp_1)

  
  (setq Tmpnum (getint (strcat "\n  시작번호 <" (itoa total:pk:num) ">:")))
  (if (/= tmpnum nil) (setq total:pk:num Tmpnum) )

  (setq tmp_1 T)
  (while tmp_1
          (initget "On OFf")
          (setq onoff (getkword  (strcat "\n  주차대수 표기 On/OFf/<" pk:num:on ">")))
          (if (or (= onoff "On") (= onoff "OFf") (= onoff nil)) (setq tmp_1 nil))
  )
  (if (/= onoff nil) (setq pk:num:on onoff))

)

(defun pk_ang (/ ang)
  (setq ang (getangle (strcat "\n    Parking_angle <" (angtos pk:ang) ">: ")))
  (if (numberp ang) (setq pk:ang ang))
)

(defun pk_bas (/ bas)
  (initget 1 "Center End Start  ")
  (cond
    ((= pk:bas "Start")
      (setq bas (getkword "\n    Base point Center/End/<Start>: "))
    )
    ((= pk:bas "Center")
      (setq bas (getkword "\n    Base point End/Start/<Center>: "))
    )
    ((= pk:bas "End")
      (setq bas (getkword "\n    Base point Center/Start/<End>: "))
    )
  )
  (if (member bas '("Center" "End" "Start")) (setq pk:bas bas))
)

(defun pk_dia (/ dia)
  (initget 1 "ON OFf  ")
  (if (= pk:dia "OFf")
    (progn
      (setq dia (getkword "\n    Diagonal ON/<OFf>: "))
      (if (member dia '("ON" "OFf")) (setq pk:dia dia))
    )
    (progn
      (setq dia (getkword "\n    Diagonal OFf/<ON>: "))
      (if (member dia '("ON" "OFf")) (setq pk:dia dia))
    )
  )
)

(defun pk_col ()
  (setq ecolor
    (if (= (type pk:col) 'STR) (get_num pk:col) pk:col)
  )
  (if (numberp (setq temp_color (acad_colordlg ecolor t)))
    (progn
      (setq ecolor temp_color)
      (setq pk:col ecolor)
      (if (and (/= pk:col 256) (/= pk:col 0))
        (command "_.layer" "_C" pk:col "" "")
      )
    )
  )
)
;;
;; This function pops a dialogue box consisting of a list box,image tile, and 
;; edit box to allow the user to select or type a layer name.  It returns the 
;; layer name selected.  It also has a button to find the status (On, Off, 
;; Frozen, etc.) of any layer selected.
;;
(defun pk_lay (/ old-idx layname on off frozth)
  (setq elayer  pk:lay)

  (cond
    (  (not (ai_notrans)))                      ; Not transparent?
    (  (not (ai_acadapp)))                      ; ACADAPP.EXP xloaded?
    (  (not (setq dcl_id (ai_dcl "dd_prop"))))  ; is .DLG file loaded?
    (t (ai_undo_push)
       (make_laylists)                          ; layer list - laynmlst
       (setq lay-idx (get_index elayer laynmlst))
    )
  )
  (if (not (new_dialog "setlayer" dcl_id))
    (exit)
  )
  (set_tile "cur_layer" (getvar "clayer"))
  (start_list "list_lay")
  (mapcar 'add_list longlist)  ; initialize list box
  (end_list)
  (setq old-idx lay-idx)
  (lay_list_act (itoa lay-idx))
  (action_tile "list_lay" "(lay_list_act $value)")
  (action_tile "edit_lay" "(pk_lay_edit $value)")
  (action_tile "accept"   "(pk_ok)")
  (action_tile "cancel"   "(reset_lay)")
  (if (= (start_dialog) 1)                         ; User pressed OK
    (setq ecolor pk:col
          eltype pk:lin
    )
  )
  (setlay pk:lay)
  (command "_.layer" "_C" pk:col "" "_L" pk:lin "" "")
)

(defun pk_lin (/ old-idx on off frozth test_ok reset_lt)
  ;;
  ;; this function pops a dialogue box consisting of a list box, image tile, and 
  ;; edit box to allow the user to select or  type a linetype.  It returns the 
  ;; linetype selected.
  ;;
  (defun pk_ltype (/ old-idx)
    (if (not ltnmlst)
      (make_ltlists)                    ; linetype lists - ltnmlst, mdashlist
    )
    (setq lt-idx (get_index eltype ltnmlst))
    (if (not (new_dialog "setltype" dcl_id)) (exit))
    (start_list "list_lt")
    (mapcar 'add_list ltnmlst)                        ; initialize list box
    (end_list)
    (setq old-idx lt-idx)
    (lt_list_act (itoa lt-idx))

    (action_tile "list_lt" "(lt_list_act $value)")
    (action_tile "edit_lt" "(lt_edit_act $value)")
    (action_tile "accept"  "(test_ok)")
    (action_tile "cancel"  "(reset_lt)")

    (if (= (start_dialog) 1) ; User pressed OK
      (cond 
        ((= lt-idx 0)
          "BYLAYER"
        )
        ((= lt-idx 1)
          "BYBLOCK"
        )
        (T
          ltname
        )
      )
      eltype
    )
  )

  (defun test_ok ()
    (if (= (get_tile "error") "")
      (progn
        (if (and (/= ltname "BYBLOCK") (/= ltname "BYLAYER"))
          (setq pk:lin ltname)
        )
        (done_dialog 1)
      )
    )
  )
  ;;
  ;; Reset to original linetype when cancel it selected
  ;;
  (defun reset_lt ()
    (setq ltname pk:lin)
    (done_dialog 0)
  )

  (setq ltname pk:lin
        eltype pk:lin
  )
  (setq ecolor
    (if (= (type pk:col) 'STR) (get_num pk:col) pk:col)
  )

  (cond
;;    (  (not (ai_notrans)))                      ; Not transparent?
    (  (not (ai_acadapp)))                      ; ACADAPP.EXP xloaded?
    (  (not (setq dcl_id (ai_dcl "dd_prop"))))  ; is .DLG file loaded?
    (t (ai_undo_push)
      (setq eltype (pk_ltype))
      (command "_.layer" "_L" pk:lin "" "")
    )
  )
)
;;
;; Reset to original layer when cancel is selected.
;;
(defun reset_lay ()
  (setq lay-idx old-idx)
  (done_dialog 0)
)

(defun pk_ok ()
  (setq pk:lay layname)
  (if (lacolor layname)
    (setq pk:col (lacolor layname)
          pk:lin (laltype layname)
    )
  )
  (done_dialog 1)
)
;;
;; Edit box selections end up here.  Convert layer entry to upper case.  If 
;; layer name is valid, clear error string, call (lay_list_act) function,
;; and change focus to list box.  Else print error message.
;;
(defun pk_lay_edit (layvalue)
  (setq layvalue (strcase layvalue))
  (if (setq lay-idx (get_index layvalue laynmlst))
    (progn
      (set_tile "error" "")
      (lay_list_act (itoa lay-idx))
    )
    (progn
      (set_tile "error" "")
      (setq layname layvalue)
    )
  )
)

(if (null pk:lay) (setq pk:lay "PARKING"))
(if (null pk:dia) (setq pk:dia "ON"))
(if (null pk:bas) (setq pk:bas "Center"))
(if (null pk:ang) (setq pk:ang (/ pi 2)))
(if (null total:pk:num) (setq total:pk:num 1))
(if (null pk:num:on) (setq pk:num:on "On"))
(defun C:CIMPK () (m:pk))
(princ)

;===============================================================
; 루프드레인 그리기
(defun m:RD (/ p1 rdk)
 (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
 (princ "\n루프드레인을 그리는 명령입니다.")
  
  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")
  
  (setq p1 (getpoint "\n삽입점: "))
  (if (null p1) (exit))
  (if (/= (type rdd) 'INT) (setq rdd 100))
  (initget (+ 2 4))
  (setq rdk (getint (strcat "\n관경(지름) <" (rtos rdd) ">: ")))
  (if (numberp rdk) (setq rdd rdk))
  (while (/= p1 nil)
  (setlay "SYMBOL")
  (command "insert" "RD" p1 rdd "" "0")
  (rtnlay)
  (setq p1 (getpoint "\n삽입점 : "))
  )
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ)
)

(defun C:CIMRD () (m:rd))
(princ)
