;2001년 08월 11일 
;명령어 :C:CIMLEADER () 인출선 그기
;        c:cimld()
;단축키 관련 변수 정의 부분 -맨 뒤로..
(defun LD_DrawImage (LD_key !LDtype! / ldc ldtc)
  (setq ldc (propcolor ld:fprop))
  (setq ldtc (propcolor text:tprop))  
    
    
    (do_blank LD_key 0)
    (start_image LD_key)	  
	   (cond
	     ((= !LDtype! "Complex") (LD_image_a))
	     ((= !LDtype! "Simple") (LD_image_b))
	   )
    (end_image)
)
(defun LD_image_a (/ cx cy dx dy x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16
		  	           y1 y2 y3 y4 y5 y6 y7 y8)
    (setq cx (dimx_tile LD_key)
	  cy (dimy_tile LD_key)
	  dx (/ cx 36)
	  dy (/ cy 34)
	  x1 (* dx 4) x2 (* dx 6) x3 (* dx 9) x4 (* dx 11) x5 (* dx 13) x6 (* dx 17)
	  x7 (* dx 18) x8 (* dx 19) x9 (* dx 20) x10 (* dx 21) x11 (* dx 23) x12 (* dx 24)
	  x13 (* dx 26) x14 (* dx 27) x15 (* dx 28) x16 (* dx 29)
	  y1 (* dy 2) y2 (* dy 4) y3 (* dy 6) y4 (* dy 8) y5 (* dy 12) y6 (* dy 20) y7 (* dy 21) y8 (* dy 22)
    )
     
       	(vector_image x1 y6 x1 y8 ldc)
	(vector_image x1 y8 x2 y7 ldc)
	(vector_image x1 y8 x5 y2 ldc)
	(vector_image x5 y2 x6 y2 ldc)

	(if (= ld:tof "ON")
	  (progn
		(vector_image x7  y1 x9  y1 ldtc)
		(vector_image x8  y1 x8  y3 ldtc)
		(vector_image x11 y1 x10 y1 ldtc)
		(vector_image x10 y1 x10 y3 ldtc)
		(vector_image x10 y3 x11 y3 ldtc)
		(vector_image x10 y2 x11 y2 ldtc)
		(vector_image x12 y1 x13 y3 ldtc)
		(vector_image x13 y1 x12 y3 ldtc)
		(vector_image x14 y1 x16 y1 ldtc)
		(vector_image x15 y1 x15 y3 ldtc)
	   ))
  
)

(defun LD_image_b (/ cx cy dx dy x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13
		  	           y1 y2 y3 y4 y5 )
    (setq cx (dimx_tile LD_key)
	  cy (dimy_tile LD_key)
	  dx (/ cx 36)
	  dy (/ cy 24)
	  x1 (* dx 4) x2 (* dx 6) x3 (* dx 13) x4 (* dx 14) x5 (* dx 15) x6 (* dx 16) x7 (* dx 18) x8 (* dx 19)
	  x9 (* dx 21) x10 (* dx 22) x11 (* dx 23) x12 (* dx 24) x13 (* dx 32)
	  y1 (* dy 7) y2 (* dy 9) y3 (* dy 11) y4 (* dy 12) y5 (* dy 13) 
    )
      	(vector_image x2 y3 x1 y4 ldc)
	(vector_image x1 y4 x2 y5 ldc)
	(vector_image x1 y4 x13 y4 ldc)

        (if (= ld:tof "ON")
	  (progn
		(vector_image x3  y1 x5  y1 ldtc)
		(vector_image x4  y1 x4  y3 ldtc)
		(vector_image x7  y1 x6  y1 ldtc)
		(vector_image x6  y1 x6  y3 ldtc)
		(vector_image x6  y3 x7  y3 ldtc)
		(vector_image x6  y2 x7  y2 ldtc)
		(vector_image x8  y1 x9  y3 ldtc)
		(vector_image x9  y1 x8  y3 ldtc)
		(vector_image x10 y1 x12 y1 ldtc)
		(vector_image x11 y1 x11 y3 ldtc)
	 ))	    
 
)

;;;
;;; Main function
;;;
(defun m:ld (/
            pt1      pt2      pt3      d1       d2       d3       dx
            d1frw    uctr     pt4      pt5      pt6      pt7      pt8
            pt9      pt10     pt11     pt12     pt13     pt14     pt15
            pt16     pt17     pt18     pt10x    ptc      ptcn     ang
            ang1     ss       ls       no
            cont     temp     tem      uctr              
            ld_osc   )
  
   
  (setq ld_text_value "")
  (setq ld_osc (getvar "dimscale"))
  
  ;;
  ;; Internal error handler defined locally
  ;;

  ;; 밑의 코드는 (ai_err_on)함수의 localize
  (setq err:color (getvar "cecolor")
  	err:layer (getvar "clayer")
   	err:lin (getvar "celtype")
   	err:style (getvar "textstyle")
   	err:osmode (getvar "osmode")
   	err:blipmode (getvar "blipmode")
   	err:highlight (getvar "highlight")
	;err:ortho (getvar "orthomode")
	
  )
  (setvar "cmdecho" 0)
  (setvar "regenmode" 0)
  (setvar "blipmode" 0)
  
 (defun *error* (s)
   (if (= ygpark T)
     (command "")
   )
   (setq ygark nil)
   (if (and (/= s "Function cancelled") (/= s "quit / exit abort"))
     (princ (strcat "\nError: " s))
   )
   (setvar "cmdecho" 0)
   (setvar "regenmode" 1)
   (setvar "cecolor" err:color)
   (setvar "clayer" err:layer)
   (setvar "celtype" err:lin)
   (setvar "textstyle" err:style)
   (setvar "osmode" err:osmode)
   (setvar "blipmode" err:blipmode)
   (setvar "highlight" err:highlight)
   ;(setvar "orthomode" err:ortho)
   
   (princ)
 )
 
  (ai_undo_on)
  (command "_.undo" "_group")
  (setvar "orthomode" 0)
  (command "_.color" "_bylayer")
  
 
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n인출선을 그리는 명령입니다.")
  
  (setq cont T uctr 0 temp T)

  (while cont
    
    (ld_m1)
    (ld_m2)
  )

  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)

  (setvar "cmdecho" 1)
  (princ)
)

(defun ld_m1 ()
  (while temp
    (if (> uctr 0)
      (progn
        (initget "Dialog Undo")
        (setq strtpt (getpoint "\n>>> Dialog/Undo/<인출선 시작점>: "))
      )
      (progn
        (initget "Dialog")
        (setq strtpt (getpoint "\n>>> Dialog/<인출선 시작점>: "))
      )
    )
    (setvar "osmode" 0)
    (cond
      ((= strtpt "Undo")
        (command "_.undo" "_b")
        (setq uctr (1- uctr))
      )
      ((= strtpt "Dialog")
        (dd_lead)
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

(defun ld_m2 ()
  (while tem
    (initget "Undo")
    (setq nextpt (getpoint strtpt "\n    Undo/<next point>: "))
    (cond
      ((= nextpt "Undo")
        (setq tem nil temp T)
      )
      ((= (type nextpt) 'LIST)
        (command "_.undo" "_m")
        (ld_lx)
        (setq uctr (1+ uctr))
        (princ " \n")
      )
      (T
        (setq tem nil cont nil)
      )
    )
  )
)

(defun ld_lx (/ leng uctn uctm ptlist t_of p1 p2 p3 ptx ang1 ang2 t_just ss_e1
                ld:arc textn esim)
  (setq pt1  strtpt
        pt2  nextpt
        ptx  nextpt
        ang  (angle pt1 pt2)
        leng (* ld:siz ld_osc)
        pt3  (polar pt1 ang leng)
  )
  (set_col_lin_lay ld:fprop)
  (setq con T uctn 0 ptlist nil)
  (setq ptlist (cons pt2 ptlist))
  (setvar "blipmode" 0)
  (cond
    ((= ld:mty "mark_1")
      (command "_.pline" pt1 "W" 0 (/ LENG 3.0) pt3 "W" 0 0 pt2)
    )
    ((= ld:mty "mark_2")
      (command "_.undo" "_M")
      (command "_.donut" 0 leng pt1 "")
      (command "_.pline" pt1 pt2)
    )
    ((= ld:mty "mark_3")
      (command "_.undo" "_M")
      (command "_.circle" pt1 (/ leng 2))
      (command "_.pline" (polar pt1 ang (/ leng 2)) pt2)
    )
    ((= ld:mty "mark_4")
      (command "_.pline" (setq p (polar pt1 ang (* leng 0.425)))
               (polar p (- ang (dtr 90)) (/ leng 2)) pt1
               (polar p (+ ang (dtr 90)) (/ leng 2)) p pt2)
    )
    ((= ld:mty "mark_5")
      (command "_.undo" "_M")
      (command "_.insert" "arrowx" pt1 leng "" (+ (rtd ang) 180))
      (command "_.pline" pt1 pt2)
    )
    ((= ld:mty "mark_6")
      (if (< ang (dtr 90))
	(setq p (polar pt1 (+ ang (dtr 27)) leng))
	(setq p (polar pt1 (- ang (dtr 27)) leng)))
      (command "_.pline" p pt1 pt2)
    )
  )
  (setvar "blipmode" 1)
  (if (= ld:sim "Simple")
	(progn
  		(setq pt2 (polar pt1 ang (/ (distance pt1 pt2) 2)))
    	(command "")
    	(setq con nil tem nil temp T t_of T)
  	)
	(progn   
  		(while con
    		(setvar "orthomode" 1)
                (setq ygpark T)
    		(if (= ld:mul "Multi")
      			(progn
        			(initget "Undo")
        			(setq nextpt (getpoint pt2 "\nUndo/<next point>: "))
      			)
      			(progn
        			(initget "Arc Undo")
        			(setq nextpt (getpoint pt2 "\nArc/Undo/<next point>: "))
      			)
    		)
                (setq ygpark nil)
    		(setvar "orthomode" 0)
    		(cond
      			((= nextpt "Undo")
        		 	(command "U")
        			(if (= uctn 0)
          				(progn
            				(cond
          						((= ld:mty "mark_1")
                					(command "U")
                					(command "")
              					)
              					((= ld:mty "mark_4")
                					(command "U")
                					(command "U")
                					(command "U")
                					(command "U")
                					(command "")
              					)
              					(T
                					(command "")
                					(command "_.Undo" "_B")
              					)
            				)
            				(setq uctr (1- uctr))
            				(setq con nil t_of nil)
          				)
          				(progn
            				(setq ptlist (member (nth 1 ptlist) ptlist))
            				(setq pt2 (nth 0 ptlist))
          				)
        			)
        			(setq uctn (1- uctn))
      			)
      			((= nextpt "Arc")
        			(command "A")
        			(setq ld:arc T)
        			(setq ptn (nth 0 ptlist))
        			(while ld:arc
          				(princ "\nLine/Undo/<nextpoint>: ")
          				(command pause)
          				(setq pt2 (getvar "lastpoint"))
          				(if (equal pt2 (nth 0 ptlist) 0.1)
            				(setq ld:arc nil)
            				(if (equal ptn pt2 0.1)
              					(setq ld:arc nil)
              					(if (member pt2 ptlist)
                					(setq ptlist (member pt2 ptlist))
                					(setq ptlist (cons pt2 ptlist))
              					)
            				)
          				)
        			)
      			)
      			((= (type nextpt) 'LIST) ;;;(= ld:sim "Simple")
        			(command nextpt)
        			(setq pt2 nextpt)
        			(setq uctn (1+ uctn))
        			(setq ptlist (cons pt2 ptlist))
        			(if (and (= ld:mul "Multi") (= uctn 1))
         				(progn
            				(setq con nil tem nil temp T t_of T)
            				(command "")
          				)
        			)
     		 	)
      			(T
        			(command "")
        			(setq con nil tem nil temp T t_of T)
      			)
    		);end cond
    	);while
	);end progn
  );end if
  
  (if (and (= ld:tof "ON") t_of)
    (progn
      (if (not (stysearch ld:tst))
        (styleset ld:tst)
      )
      (setvar "textstyle" ld:tst)
      (setq ang1 (getvar "lastangle"))
      (setq p1   (polar pt2 ang1 (* 2 ld_osc)))
      (if (or (<= (abs (rtd ang1)) 90) (> (abs (rtd ang1)) 270))
        (setq t_just "ML"
              t_ang  (rtd ang1)
              ang2   (- ang1 (dtr 90))
        )
        (setq t_just "MR"
              t_ang  (- (rtd ang1) 180)
              ang2   (+ ang1 (dtr 90))
        )
      )
      (if (= ld:sim "Simple")
	    (progn
	      (setq t_just "M")
	      (setq p1 pt2 ) 
	    )
	  )
      
      (setvar "blipmode" 0)
      (setq e1 (entlast))
      (while (entnext e1)
        (setq e1 (entnext e1))
      )
      
      (set_col_lin_lay text:tprop)
      (setq textn 0)
      (if (or (= ld_text_value "") (= ld_text_value nil) )
	    (progn
	      (princ "\nText: ")
          (command "_.dtext"  t_just p1 (* ld:tht ld_osc) t_ang)
	    )
	    (LDtextArray) ;;;;
      )
      (rtnlay)
      (setvar "cmdecho" 0)
 ;;     (if (= ld:mul "Multi")
        (progn
          (setvar "blipmode" 0)
         ;; (setq e1 (entnext e1))
          (if e1
            (progn
	      (setq esim e1 )
              (while (and (setq e1 (entnext e1))
                          (= (fld_st 0 (entget e1)) "TEXT")
                     )
		(setq textn (1+ textn))
                (setq p1 (fld_st 11 (entget e1))
                      p2 (polar p1 (+ ang1 (dtr 180)) (* 2 ld_osc))
                      p3 (inters p1 p2 strtpt ptx T)
                )
                (if (not p3)
                  (setq p3 (polar p2 (+ ang1 (dtr 180)) (* 4 ld_osc)))
                )
		
		(setq edd (entget e1))  
		(setq tmptxt (cdr (assoc 1 edd)))		
		(if (= (substr tmptxt 1 1) "-") 
		  (progn

		    (setq edd (subst (cons 1 (substr tmptxt 2)) (cons 1 tmptxt) edd))
		    (entmod edd)
		    (set_col_lin_lay ld:fprop)
		    (if (/= ld:sim "Simple") (command "_.line" p2 p3 ""))
		  )) 	
                );end while
	      (if (= ld:sim "Simple")
	      (progn
	        (while (and (setq esim (entnext esim))
                          (= (fld_st 0 (entget esim)) "TEXT"))
                  (setq edd (entget esim))
		  (setq tmppt1 (cdr (assoc 10 edd)))
		  (setq tmppt2 (cdr (assoc 11 edd)))
		  (setq edd (subst (cons 10 (polar tmppt1 (+ ang2 (dtr 180)) (* (+ ld:tht (/ ld:tht 2.5)) ld_osc textn))) (cons 10 tmppt1) edd))
		  (entmod edd)
		  (setq edd (subst (cons 11 (polar tmppt2 (+ ang2 (dtr 180)) (* (+ ld:tht (/ ld:tht 2.5)) ld_osc textn))) (cons 11 tmppt2) edd))
		  (entmod edd)
		  )
		))
              (cond
                ((= uctn 0)
                  (setq ptx (polar ptx (+ ang1 (dtr 180)) (* 4 ld_osc)))
                  ;(command "_.line" ptx p3 "")
                )
                ((equal ang (angle ptx p3) 0.01)
                  ;(command "_.line" ptx p3 "")
                )
              )
            )

          )
          ;(setvar "blipmode" 1)
        )
      )
    )
 ;; );if
)

(defun LDtextArray(/ text_array tmpn len ttext)
  (setq text_array (split ld_text_value (chr 59)))
  (setq len (length text_array))
  (setq tmpn 0)
 
   (while (> len tmpn)
        (setq ttext (nth tmpn text_array))
        
        (if (= tmpn 0)
	  (command "_.text" t_just p1 (* ld:tht ld_osc) t_ang ttext)
	  (command "_.text" "" ttext)
	  )
        (setq tmpn (1+ tmpn))
   )
  
)



(defun ld_init ()

 
  (defun reset ()
    (setq reset_flag t)
  )

  (defun ld_set ()
    (PROP_SAVE ld:prop)
    (writeF "Leader.dat" T)
  )
  ;; Common properties for all entities
  ;;
  (defun set_tile_props ()
    (list_view2)
    (set_tile "error" "")
    (set_tile ld_prop_type "1")
    ;(mode_tile "ed_ratio" 1)
    
    (set_tile "ed_text" ld_text_value)
    (set_tile "ed_size" (rtos ld:siz))
    (if (= ld:tof "ON")
      (set_tile "rd_text_on" "1")
      (set_tile "rd_text_off" "1")
    )
    (@get_eval_prop ld_prop_type ld:prop)

;;bn_arrow_image
    (ci_image "bn_arrow_image" (strcat "cim3d(" ld:mty ")"))
    (LD_Drawimage "bn_leader_image" ld:sim)
    
;;text_style
    (set_tile "pop_textstyle" (itoa st-idx))
    (get_style)
    (set_tile "ed_textsize" (rtos ld:tht))
    
    (if (= ld:tof "OFf")
      (mode_tile "text_op" 1)
    )
  )

  (defun set_action_tiles ()
    (action_tile "bn_leader_image"  "(if (= ld:sim \"Complex\") (setq ld:sim \"Simple\") (setq ld:sim \"Complex\")) (LD_Drawimage \"bn_leader_image\" ld:sim)")
    (action_tile "bn_arrow_image" "(next_ARR_image)")
    (action_tile "b_name"       "(@getlayer)(LD_DrawImage \"bn_leader_image\" ld:sim)") 
    (action_tile "b_color"      "(@getcolor)(LD_DrawImage \"bn_leader_image\" ld:sim)") 
    (action_tile "color_image"      "(@getcolor)(LD_DrawImage \"bn_leader_image\" ld:sim)") 
    (action_tile "c_bylayer"	"(@bylayer_do T)(LD_DrawImage \"bn_leader_image\" ld:sim)")

    (action_tile "rd_text_on"      "(radio_gaga \"text_on\")(LD_Drawimage \"bn_leader_image\" ld:sim)")
    (action_tile "rd_text_off"      "(radio_gaga \"text_off\")(LD_Drawimage \"bn_leader_image\" ld:sim)")

    (action_tile "prop_radio" "(setq ld_prop_type $Value)(@get_eval_prop ld_prop_type ld:prop)(LD_Drawimage \"bn_leader_image\" ld:sim)")
    
    (action_tile "eb_clear"       "(set_tile \"ed_text\" \"\")")
    (action_tile "eb_delete"      "(eb_delete_F)")
    (action_tile "eb_add"         "(eb_add_F)")
    (action_tile "list_text"      "(DoubleClick? $Value)")

    (action_tile "ed_size"       "(ld_get_size $value)")
    ;(action_tile "ed_ratio"      "(getfsize $value)")
    (action_tile "ed_textsize"   "(ld_get_tsize $value)")
  
    (action_tile "pop_textstyle"   "(get_style)")

    (action_tile "accept"       "(dismiss_dialog 1)")
    (action_tile "cancel"       "(dismiss_dialog 0)")
    ;(action_tile "help"         "(cim_help \"LEADER\")")
  )

  (defun next_ARR_image(/ curn)
    (setq curn (atoi (substr ld:mty 6)))
    (setq curn (rem curn 6))
    (setq curn (1+ curn))
    (setq ld:mty ( strcat "mark_" (itoa curn)))
    (ci_image "bn_arrow_image" (strcat "cim3d(" ld:mty ")"))
   )
 (defun radio_gaga (pushed)
    (cond 
      ((= pushed "text_on")
       
        (mode_tile "text_op" 0)
        (setq ld:tof "ON")
      )
      ((= pushed "text_off")
       
        (mode_tile "text_op" 1)
        (setq ld:tof "OFf")
      )
      
            
    )
 )
 (defun get_style (/ old-idx)   ;;; 수정 요망  
  (setq st-idx (atoi (get_tile "pop_textstyle")))
      
      (ci_image "text_image" (nth st-idx slblist))
      (setq ld:tst (nth st-idx stnmlst))
      ;(set_tile "ed_ratio" (nth st-idx widlst))
      
 )  

  ;; Checks validity of thickness from edit box.
  
  (defun ld_get_size(value)
	(setq ld:siz (atof value))
  )
  (defun ld_get_tsize(value)
    (setq ld:tht (atof value))
  )				
  ;;
  ;; If their is no error message, then close the dialogue.
  ;;
  (defun dismiss_dialog (action)
    (if (= action 0)
      (done_dialog 0)
      (if (= (get_tile "error") "")
	(progn
        (setq ld_text_value (get_tile "ed_text"))
	;(writeF "Leader.dat" T)
	(done_dialog action)
	)
      )
    )
  )


) ; end ld_init

(defun ld_do ()
  (if (not (new_dialog "dd_leader" dcl_id)) (exit))
  (pop_set "pop_textstyle")
  (set_tile_props)
  (set_action_tiles) 
  (setq dialog-state (start_dialog))
          
  (if (= dialog-state 0)
    (reset)
  )
)

(defun ld_return ()
  (setq old_fprop  ld:fprop
        old_cprop  text:tprop
        ld:mul  old_mul
        ld:tof  old_tof
        ld:mty  old_mty
        ld:siz  old_siz
        ld:tht  old_tht
        ;ld:twi  old_twi
        ld:tob  old_tob
  )
)

(defun reset_st ()
  (setq stname ld:tst)
  (done_dialog 0)
)
;;; ================== (dd_lead) - Main program ========================
;;;
;;; Before (dd_lead) can be called as a subroutine, it must
;;; be loaded first.  It is up to the calling application to
;;; first determine this, and load it if necessary.

(defun dd_lead (/
           dcl_id
           dialog-state     dismiss_dialog   
           old_mul          old_mty          old_siz
           old_tht          old_tob          old_twi          old_tco
           old_tst          old-idx          radio_gaga       
           reset            reset_flag               
           set_action_tiles 
	   action_Tiles  verify_d  
	   	   
           toggle_do        verify_d
           old_typ	    old_fprop old_cprop
	   next_ARR_image   preindex  L_index get_style getfsize)
  
  (setvar "cmdecho" (cond (  (or (not *debug*) (zerop *debug*)) 0)
                          (t 1)))
  (setq old_fprop  ld:fprop
        old_cprop  text:tprop
        old_mul  ld:mul
        old_tof  ld:tof
        old_mty  ld:mty
        old_siz  ld:siz
        old_tht  ld:tht
        old_tob  ld:tob
        
  )

  
  (princ ".")
  (cond
     ((not (setq dcl_id (load_dialog "Ltleader.dcl"))))
     (t (ai_undo_push)
        (princ ".")
        (readf "leader.dat" T)
        (ld_init)                                ; everything okay, proceed.
        (princ ".")
        (ld_do)
 
     )
  )
  (if reset_flag
    (ld_return)
    (ld_set)
  )
   (if dcl_id (unload_dialog dcl_id))
)

(setq ld:fprop  (Prop_search "leader" "leader"))
(setq text:tprop  (Prop_search "text" "text"))
(setq ld:prop '(ld:fprop text:tprop))

(if (null ld:fprop) (setq ld:fprop (list "leader" "leader" "LEADER" "7" "CONTINUOUS" "1" "1")))
(if (null text:tprop) (setq text:tprop (list "leader" "text" "TEXT" "3" "CONTINUOUS" "1" "1")))

(if (null arr_image_num) (setq arr_image_num 0))
(if (null ld_prop_type) (setq ld_prop_type "rd_leader"))
(if (null ld:sim)(setq ld:sim "Complex"))
(if (null st-idx) (setq st-idx 1))
  
(if (null ld:mty) (setq ld:mty "mark_1"))
(if (null ld:mul) (setq ld:mul "Single"))
(if (null ld:tht) (setq ld:tht 2.5))
(if (null ld:tob) (setq ld:tob 0))
(if (null ld:tof) (setq ld:tof "ON"))
(if (null ld:siz) (setq ld:siz 3))
(if (null ygpark) (setq ygpark nil))
(if (null ld:tst) 
  (cond
    ((findfile "WHGTXT.SHX")
      (setq ld:tst "CIHS"
            
      )
    )

    (T
      (setq ld:tst "SIM")
    )
  )
)

(defun C:CIMLEADER () (m:ld))
(setq lfn21 1)
(princ)
