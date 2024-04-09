
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 작업 일자 : 2001. 08. 10 
;; 작 업 자  : 김병전 
;; 명 령 어  : C:CIMWALL - 벽기 
;; 수정 사항 : IComTools 에서 문자열 인식 문제 - action_tile "(setq a 10)" New Line 금지, 한줄로 쓰기 
;;	       (action_tile "list" "(setq Wall_type (setq L_index (atoi $value))) (set_tileS)")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; 단축키 관련 변수 정의 부분 .. 맨뒤로


(defun wl_DrawImage (wl_key !wltype! / wlc wlcc wlfc)
  (setq wlc (propcolor wal:wprop))
  (setq wlfc (propcolor wal:fprop)) 
  (setq wlcc wlc)
    
    (do_blank wl_key 0)
    (start_image wl_key)	  
	   (cond
	     ((= !wltype! "single") (wl_image_a))
	     ((= !wltype! "double") (wl_image_b))
	   )
    (end_image)
)
(defun wl_image_a (/ cx cy dx dy x1 x2 
		  	           y1 y2 y3 y4 )
    (setq cx (dimx_tile wl_key)
	  cy (dimy_tile wl_key)
	  dx (/ cx 12)
	  dy (/ cy 10)
	  x1 (* dx 1) x2 (* dx 11) 	 
	  y1 (* dy 2) y2 (* dy 3) y3 (* dy 7) y4 (* dy 8) 
    )
  
       	(vector_image x1 y2 x2 y2 wlc)
	(vector_image x1 y3 x2 y3 wlc)

	(if (> cw:fin1 0) (vector_image x1 y1 x2 y1 wlfc))
        (if (> cw:fin2 0) (vector_image x1 y4 x2 y4 wlfc))
  
)
(defun wl_image_b (/ cx cy dx dy x1 x2 
		  	           y1 y2 y3 y4 y5 y6)
    (setq cx (dimx_tile wl_key)
	  cy (dimy_tile wl_key)
	  dx (/ cx 12)
	  dy (/ cy 10)
	  x1 (* dx 1) x2 (* dx 11) 	 
	  y1 (* dy 1) y2 (* dy 2) y3 (* dy 4) y4 (* dy 6) y5 (* dy 8) y6 (* dy 9) 
    )
  
       	(vector_image x1 y2 x2 y2 wlc)
	(vector_image x1 y3 x2 y3 wlcc)
        (vector_image x1 y4 x2 y4 wlcc)
	(vector_image x1 y5 x2 y5 wlc)
  
	(if (> cw:fin1 0) (vector_image x1 y1 x2 y1 wlfc))
        (if (> cw:fin2 0) (vector_image x1 y6 x2 y6 wlfc))
  
)




;;; Main function
;;;
(defun m:cw (/
            strtpt   nextpt   pt1      pt2      spts     wnames   ipt
            uctr     temp     ans      v        lst      dist     elast
            cpt      rad      spt      ept      pt       en1      cont
            en2      npt      flg      flg2     flgn     ang      tmp
            brk_e1   brk_e2   bent1    bent2    nn       MAXSNP   fang
            cw_oem   cw_opb     
            ange     savpts
            cw:aln   savpt1   savpt2   savpt3   savpt4   savpt5   savpt6
            savpt7   savpt8   savpt9   savpt10   savpt11   savpt12   uctn
	    cw_preeset uct_list rev_list )
  
  ;; Reset this value higher for ADI drivers.

  
 
  (setq MAXSNP 19)              

  (setq cw_oem (getvar "expert")
        cw_opb (getvar "pickbox")
  )
  
  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")
  
  (if sw:opb (setvar "pickbox" sw:opb))
  (if (null sw:opb) (setq sw:opb (getvar "pickbox")))

  (setq nextpt "Straight")
 
  ;; Get the first segment's start point

  (graphscr)
  (command "_.undo" "_en")
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n벽을 그리는 명령입니다.")
  (setvar "blipmode" 0)
  (setq cont T uctn 0 uct_list nil)

  (while cont
    (cw_m1)
    ;; Ready to draw successive Cavity_Wall segments
    (if (/= nextpt "Quit")
    (cw_m2))
  )
  
  (if cw_oem (setvar "expert" cw_oem))
  (if cw_opb (setvar "pickbox" cw_opb))

  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)

  (princ)
  
)
;;;
;;; Main function subsection 1.


(defun cavityoffset ( ptt1 ptt2 flag / ange ptt1_1 ptt2_1 ent1 ent2 ed1 ed2 cawid)
  (setq cawid (if (> cw:sno cw:sno1)  cw:sno cw:sno1))
  (if (and (/= ptt1 nil) (/= ptt2 nil) )
  (progn
  (setq ange (- (angle ptt1 ptt2) (/ pi 2)))
  (setq ptt1_1 (polar ptt1 ange cawid))
  (setq ptt2_1 (polar ptt2 ange cawid))
  (setq ent1 (if (= flag T) (nth 2 wnames) (nth (- (length wnames) 3) wnames) ))
  (setq ent2 (if (= flag T) (nth 3 wnames) (nth (- (length wnames) 4) wnames) ))
   (setq ed1 (entget ent1))
   (setq ed2 (entget ent2))
 
   (setq ed1 (subst (cons 10 ptt1_1) (cons 10 ptt1) ed1 ))
   (setq ed1 (subst (cons 11 ptt1_1) (cons 11 ptt1) ed1 ))
   (entmod ed1)
 
   (setq ed2 (subst (cons 10 ptt2_1) (cons 10 ptt2) ed2 ))
   (setq ed2 (subst (cons 11 ptt2_1) (cons 11 ptt2) ed2 ))
   (entmod ed2)
    
  (command "_.line"  ptt2_1 ptt1_1 "")))
)

(defun finishex ( ptt1 ptt2 flag / ange ptt1_1 ptt2_1 ent1 ent2 pttex1 pttex2 ed1 ed2 finwid)
 (setq finwid (if (> cw:fin1 cw:fin2) cw:fin1 cw:fin2))
 (setq ange (- (angle ptt1 ptt2) (/ pi 2)))
 (setq ptt1_1 (polar ptt1 ange finwid))
 (setq ptt2_1 (polar ptt2 ange finwid))
(setq ent1 (if (= flag T) (nth 4 wnames) (nth (- (length wnames) 1) wnames) ))
(setq ent2 (if (= flag T) (nth 5 wnames) (nth (- (length wnames) 2) wnames) ))

(if (and (/= "NON" ent1) (= (cw_val 8 ent1) "FINISH") )
  (progn
   (setq ed1 (entget ent1))
   (setq ed1 (subst (cons 10 ptt1_1) (cons 10 ptt1) ed1 ))
   (setq ed1 (subst (cons 11 ptt1_1) (cons 11 ptt1) ed1 ))(entmod ed1))
   (command "_.line" ptt1_1 ptt1 ""))
    
(if (and (/= "NON" ent2) (= (cw_val 8 ent2) "FINISH") )
  (progn
    (setq ed2 (entget ent2))
   (setq ed2 (subst (cons 10 ptt2_1) (cons 10 ptt2) ed2 ))
   (setq ed2 (subst (cons 11 ptt2_1) (cons 11 ptt2) ed2 ))(entmod ed2))
  (command "_.line" ptt2_1 ptt2 ""))    
 (command "_.line" ptt1_1 ptt2_1 "")

)

(defun cw_m1 (/ ss)
  (setq temp T
        uctr nil 
  )
  (setq nextpt "Line")
  (setvar "osmode" (+ 128 33))
  (while temp
  (initget "~ Dialog Offset Undo /")
    (setq strtpt (getpoint
	"\nDialog/Offset/Undo/<start point>: "))
    (cond

      ((= strtpt "Offset")
        (cw_ofs)
      )

      ((= strtpt "Dialog")
         (ddcw)
      )
      ((= strtpt "Undo")
        (princ "\nAll segments already undone. ")
        (setq temp T)
      )

      ((null strtpt)
        (setq temp nil cont nil nextpt "Quit")
      )
 
      (T
        (setq ss (wall_select_rect strtpt (max cw:fin1 cw:fin2 (/ cw:snw 20)) ))
        (setq k 0)
        (if ss
          (repeat (sslength ss)
            (if (= (cdr (assoc 0 (entget (ssname ss k)))) "POLYLINE")
              (command "_.explode" (ssname ss k))
            )
            (setq k (1+ k))
          )
        )
        (setq temp nil)
      )
    )
  )
)
;;;
;;; Main function subsection 2.

(defun cw_m2 (/ temp ss)
  (setq spts (list strtpt)
        uctr 0 
  )
  
    (cw_ved "brk_e1" strtpt)
    (cw_ved "brk_e0" strtpt)
    
  
  (while (and nextpt (/= nextpt "Close"))
    (setvar "osmode" (+ 128 33))
    (if (/= nextpt "Quit")
      (progn
        (initget "~ / Dialog Close Undo")
        
        (setq nextpt (getpoint strtpt
          "\nDialog/Close/Undo/<next point>: ")
        )
        
      )
    )
   (setvar "osmode" 0)	
          
    (cond

      ((= nextpt "Undo")
        (cond
          
          ((= uctr 0) (setq nextpt nil) )
          ((> uctr 0) 
            (repeat (1+ (nth 0 uct_list))
              (command "_.u")
            )
            (setq spts   (cw_lsu spts 1))
            (setq savpts (cw_lsu savpts 6))
            (setq wnames (cw_lsu wnames 6))
            (setq uctr (- uctr 6))
            (setq strtpt (last spts))
            (if (> (length uct_list) 1)
              (progn
                (setq k 1 rev_list nil)
                (repeat (1- (length uct_list))
                  (setq rev_list (cons (nth k uct_list) rev_list))
                  (setq k (1+ k))
                )
                (setq uct_list (reverse rev_list))
              )
              (setq uct_list nil)
            )
          )
        ) 
       
          (if (= uctr 0)
            (cw_ved "brk_e1" strtpt)) 
       
      )

      ((= nextpt "Close")
        (cw_cls)
      )
      ((= nextpt "/")
       (cim_help "CW")
      )
      ((= nextpt "Dialog")

        (command "_.undo" "_group")
        (ddcw)
        (command "_.undo" "_en")
        (setq uctn (1+ uctn))
      )
      ((= (type nextpt) 'LIST)
        (setq ss (wall_select_rect nextpt (max cw:fin1 cw:fin2 (/ cw:snw 20))))
        (setq k 0)
        (if ss
          (repeat (sslength ss)
            (if (= (cdr (assoc 0 (entget (ssname ss k)))) "*POLYLINE")
              (command "_.explode" (ssname ss k))
            )
            (setq k (1+ k))
          )
        )
        (cw_ds)
        (setq uct_list (cons uctn uct_list))
        (setq uctn 0)
      )
      (T
        (command "_.undo" "_group") 
        (setq nextpt nil cont nil)
        (if (> uctr 1)
	  (if (null brk_e2 )
           (progn                                     ;;교차벽이 없을때..
	    
	    (if (= (logand 4 cw:ecp) 4) 
            (progn	      ;; auto
	      (if (null brk_e1)
	       (progn
		(set_col_lin_lay wal:wprop) (cavityoffset savpt5 savpt6 T)
		(if (or (/= savpt9 nil) (/= savpt10 nil))(progn
		(set_col_lin_lay wal:fprop) (finishex (if (null savpt9) savpt1 savpt9)
						     (if (null savpt10) savpt2 savpt10) T)))
		(set_col_lin_lay wal:wprop)(command "_.line" savpt1 savpt2 "")
	      ))
       ;;       (cw_ssp)              
	      (set_col_lin_lay wal:wprop)(cavityoffset savpt8 savpt7 nil)
	      (if (or (/= savpt11 nil) (/= savpt12 nil))(progn	
	      (set_col_lin_lay wal:fprop) (finishex (if (null savpt12) savpt4 savpt12)
						   (if (null savpt11) savpt3 savpt11) nil)))
	      (set_col_lin_lay wal:wprop)(command "_.line" savpt3 savpt4 "")
            )
	   (progn                                   ;; not auto
               (if (= (logand 1 cw:ecp) 1)            ;; left
		(progn                
		(set_col_lin_lay wal:wprop)(cavityoffset savpt5 savpt6 T)		
		(if (or (/= savpt9 nil) (/= savpt10 nil))(progn
		(set_col_lin_lay wal:fprop) (finishex (if (null savpt9) savpt1 savpt9)
						     (if (null savpt10) savpt2 savpt10) T)))
		(set_col_lin_lay wal:wprop)(command "_.line" savpt1 savpt2 "")
	      ))              
              (if (= (logand 2 cw:ecp) 2)            ;; right
                (progn
     ;;             (cw_ssp)                  
		  (set_col_lin_lay wal:wprop)(cavityoffset savpt8 savpt7 nil)		  
		  (if (or (/= savpt11 nil) (/= savpt12 nil))(progn
		  (set_col_lin_lay wal:fprop) (finishex (if (null savpt12) savpt4 savpt12)
						       (if (null savpt11) savpt3 savpt11) nil)))
		  (set_col_lin_lay wal:wprop)(command "_.line" savpt3 savpt4 "")
                ))
            )
	      ))
	   (progn       				;;교차벽이 있으면 무조건 closing..
   ;;         (cw_ssp)
	    (set_col_lin_lay wal:wprop) 

	    (if (and (= sw:brk "1") (/= savpt7 nil) (/= savpt8 nil))  (command "_line" savpt7 savpt8 ""))
	    (if (and brk_e3 savpt11 savpt12) (command "_break" brk_e3 savpt11 savpt12))
	    ;;(if (and  
	 )); if
        )
        (if brk_e0 (setq brk_e0 nil))
        (if brk_e1 (setq brk_e1 nil))
        (if brk_e3 (setq brk_e3 nil))
        (if brk_e2 (setq brk_e2 nil))
 
     )                    ;T           ; end of inner cond  
    )                                 ; end of outer cond  
  )                                   ; end of while
  
)
;;; ------------------ End Main Functions ---------------------------
;;; ---------------- Begin Support Functions ------------------------


(defun cw_cls ()
  (if (< uctr 8)
    (progn
      (alert "Cannot Close -- too few segments. ")
      (setq nextpt "Line")
    )
    (progn
      (command "_.undo" "_group")
      (setq nextpt (nth 0 spts))
      ;; Close with line segments
      (cw_mlf 3)
      ;; set nextpt to "Close" which will cause an exit.
      (setq nextpt "Close"
            cont   nil
      )
    )
  )
)

;;; cw_ds == Cavity_Wall_Do_Segment
;;;
(defun cw_ds ()
  (if (equal strtpt nextpt 0.0001)
    (progn
      (alert "Coincident point -- please try again. ")
      (setq nextpt "Line")
    )
    (progn
      (command "_.undo" "_group")
      (setq nextpt (list (car nextpt) (cadr nextpt) (caddr strtpt)))
     
        (cw_ved "brk_e2" nextpt)
        (cw_ved "brk_e3" nextpt)
        (cw_mlf 1)

      (if (and brk_e2 (= sw:atc "1")) (setq nextpt "Quit"))
    )
  )
)
;;;

;;; cw_ofs == Cavity_Wall_OFfset_Startpoint
;;;
(defun cw_ofs ()
  (menucmd "s=osnapb")
  (initget 1)

  (setq strtpt (getpoint "\nOffset from: "))
  (initget 1)
  (setq nextpt (getpoint strtpt "\nOffset toward: "))
  
  (setq dist (getdist strtpt (strcat
    "\nEnter the offset distance <" (rtos (distance strtpt nextpt)) 
    ">: ")))
 
  (setq dist (if (or (= dist "") (null dist))
               (distance strtpt nextpt)
               (if (< dist 0)
                 (* (distance strtpt nextpt) (/ (abs dist) 100.0))
                 dist
               )
             )
  )              
  (setq strtpt (polar strtpt
                      (angle strtpt nextpt)
                      dist
               ) 
  )
  (setq temp nil)
  (command "_.undo" "_group")
)
;;;

(defun cw_ved (vent pt / ss ls no)
  ;; Get entity to break if the user snapped to a Cavity_Wall.
  ;; Make sure that it is a line or arc and that its extrusion
  ;; direction is parallel to the current UCS.
  (if (setq ss (wall_select_rect pt (max cw:fin1 cw:fin2  (/ cw:snw 20))))
    (RMV)
  )
  (if ss
    (if (or (= vent "brk_e1")(= vent "brk_e2"))
      (setq ss (ssget "P" (list (cons 8 (nth 2 (Prop_search "wall" "wall")) )) ))
      (setq ss (ssget "P" (list (cons 8 (nth 2 (Prop_search "wall" "finish")) )) ))
      )
    )
    
  (if (and ss (/= ls 0) (set (read vent) ss))
    (progn
      (set (read vent) (ssname (eval (read vent)) 0))
      (if (and 
            (or (= (cw_val 0 (eval (read vent))) "ARC")
                (= (cw_val 0 (eval (read vent))) "LINE")
            )
            (equal (caddr(cw_val 210 (eval (read vent))))
                   (caddr(trans '(0 0 1) 1 0)) 0.001)
          )
        (princ)
        ;(progn
          ;(alert (strcat
          ;  "Entity found is not an arc or line, "
          ;  "or is not parallel to the current UCS. "))
          (set (read vent) nil)
        ;)
      )
    )
  )
  (eval (read vent))
)
;;;
;;; Verify nextpt.
;;; Get the point on the arc at the opposite 
;;; end from the start point (strtpt).
;;;
;;; cw_vnp == Cavity_Wall_Verify_NextPt
;;;
(defun cw_vnp (/ temp cpt ang rad)

  (setq temp (entlast))
  (if (= (cw_val 0 temp) "LINE")
    (setq nextpt (if (equal strtpt (cw_val 10 temp) 0.001)
                   (cw_val 11 temp)
                   (cw_val 10 temp)
                 )
    )
    ;; Then it must be an arc...
    (progn
      ;; get its center point
      (setq cpt  (trans (cw_val 10 temp) (cw_val -1 temp) 1)
            ang  (cw_val 50 temp)     ; starting angle
            rad  (cw_val 40 temp)     ; radius
      )
      (setq ange (trans '(1 0 0) (cw_val -1 temp) 1)
            ange (angle '(0 0 0) ange)
            ang (+ ang ange)
      )
      (if (> ang (* 2 pi))
        (setq ang (- ang (* 2 pi)))
      )
      (setq nextpt (if (equal strtpt (polar cpt ang rad) 0.01)
                     (polar cpt (cw_val 51 temp) rad)
                     (polar cpt ang rad)
                   )
      )
    )
  )
)
;;; ----------------- Main Line Drawing Function -------------------
;;;
;;; Draw the lines.
;;;
;;; cw_mlf == Cavity_Wall_Main_Line_Function
;;;
(defun cw_mlf (flg / temp1 temp2 temp3 temp4 temp5 temp6 newang ang1 ang2 
                     ent cpt ang rad1 rad2 sent1 sent2
                     tmpt1 tmpt2 tmpt3 tmpt4 tmp_flag)

  ;; Verify nextpt
  (if (null nextpt) (setq nextpt (cw_vnp)))
  
  (if (equal nextpt (nth 0 spts) 0.01)
    (setq flg 3)
  )
   
  (setq temp1  (+ (/ cw:snw 2.0) cw:osd)
        temp2  (- cw:snw temp1)
        temp3  (- temp2 cw:sno)
        temp4  (- temp3 cw:snc)
	temp5  (+ temp1 cw:fin1)
	temp6  (+ temp2 cw:fin2)
        newang (angle strtpt nextpt)
        ang1   (+ (angle strtpt nextpt) (/ pi 2))
        ang2   (- (angle strtpt nextpt) (/ pi 2))
  )
  (set_col_lin_lay wal:wprop)
  (cond    
    ((= flg 1)                        ; if drawing lines
      (cw_dls nil ang1 temp1)         ; Draw line segment 1
      (cw_dls nil ang2 temp2)         ; Draw line segment 2
    (if (= cw:wty "double")
      (progn
      (set_col_lin_lay wal:wprop) 	
      (cw_dls nil ang2 temp3)         ; Draw line segment 3
      (cw_dls nil ang2 temp4)         ; Draw line segment 4
      )(progn (cw_dls T ang2 temp3)(cw_dls T ang2 temp4)))
     (set_col_lin_lay wal:fprop) 
     (if (> cw:fin1 0)(cw_dls nil ang1 temp5)(cw_dls T ang1 temp5))
     (if (> cw:fin2 0)(cw_dls nil ang2 temp6)(cw_dls T ang2 temp6))
    )
    ((= flg 3)                        ; if straight closing
      (setq nextpt (nth 0 spts)
            ang1   (+ (angle strtpt nextpt) (/ pi 2))
            ang2   (- (angle strtpt nextpt) (/ pi 2))
      )
      (cw_dls 0 ang1 temp1)
      (cw_dls 1 ang2 temp2)
      
     (if (= cw:wty "double")
      (progn
      (set_col_lin_lay wal:wprop) 	
      (cw_dls 2 ang2 temp3)
      (cw_dls 3 ang2 temp4))(progn (cw_dls T ang2 temp3)(cw_dls T ang2 temp4)))
     (set_col_lin_lay wal:fprop) 
     (if (> cw:fin1 0)(cw_dls 4 ang1 temp5)(cw_dls T ang1 temp5))
     (if (> cw:fin2 0)(cw_dls 5 ang2 temp6)(cw_dls T ang2 temp6))
      ;; set nextpt to "Close" which will cause an exit.
      (setq nextpt "Close"
            cont   nil
      )
    )
    (T
      (alert "ERROR:  Value out of range. ")
      (exit)
    )
  )
  (setq strtpt nextpt   
        spts   (append spts (list strtpt))
        savpts (append savpts (list savpt3))
        savpts (append savpts (list savpt4))
        savpts (append savpts (list savpt7))
        savpts (append savpts (list savpt8))
  )
  (command "_.undo" "_e")  ; only end when Cavity_Wall's have been drawn
)

;;; Straight Cavity_Wall function
;;;
;;; cw_dls == Cavity_Wall_Draw_Line_Segment
;;;
(defun cw_dls (flgn ang temp / j k pt1 pt2 tmp1 ent1 p1 p2)
  (if (/= flgn T) (progn
  (mapcar                             ; get endpoints of the offset line
    '(lambda (j k)
       (set j (polar (eval k) ang temp))
     )      
     '(pt1 pt2)
     '(strtpt nextpt)
  )
  (cond
    ((= uctr 0)
      (setq p1 (if (cw_l01 brk_e1 "1" pt1 pt2 strtpt) ipt savpt1)) 
      (setq pt2 (if (cw_l01 brk_e2 "3" pt2 pt1 nextpt) ipt savpt3))
      (setq pt1 p1)
    )
    ((= uctr 1)
      
      (setq p1 (if (cw_l01 brk_e1 "2" pt1 pt2 strtpt) ipt savpt2))
      (setq pt2 (if (cw_l01 brk_e2 "4" pt2 pt1 nextpt) ipt savpt4))
      (setq pt1 p1)

      (if (and (= sw:brk "1") brk_e1)
         (command "_.break" brk_e1 savpt1 savpt2)
            
      )
      (if (and (= sw:brk "1") brk_e2)
        (progn
          (if (eq brk_e1 brk_e2)
            (progn
               (entdel (nth 0 wnames))  
              (cw_ved "brk_e2" nextpt)
             
              (entdel (nth 0 wnames))
            )
          )
            (command "_.break" brk_e2 savpt3 savpt4)
        )
      )

    )
    ((= uctr 2)
      (setq p1 (if (cw_l01 brk_e1 "5" pt1 pt2 strtpt) ipt savpt5))
      (setq pt2 (if (cw_l01 brk_e2 "7" pt2 pt1 nextpt) ipt savpt7))
      (setq pt1 p1)  
    )
    ((= uctr 3)
      (setq p1 (if (cw_l01 brk_e1 "6" pt1 pt2 strtpt) ipt savpt6))
      (setq pt2 (if (cw_l01 brk_e2 "8" pt2 pt1 nextpt) ipt savpt8))
      (setq pt1 p1)
      (if (and (= sw:brk "1") brk_e1)
            (command "_.line" savpt5 savpt6 "")
      )
      )
     ((= uctr 4)
      (setq p1 (if (cw_l01 brk_e0 "9" pt1 pt2 strtpt) ipt savpt9))
      (setq pt2 (if (cw_l01 brk_e3 "11" pt2 pt1 nextpt) ipt savpt11))
      (setq pt1 p1)
       )
     ((= uctr 5)
      (setq p1 (if (cw_l01 brk_e0 "10" pt1 pt2 strtpt) ipt savpt10))
      (setq pt2 (if (cw_l01 brk_e3 "12" pt2 pt1 nextpt) ipt savpt12))
      (setq pt1 p1)
      (if (and (= sw:brk "1") brk_e0)
          (command "_.break" brk_e0 savpt9 savpt10 )
	(if (and brk_e0 savpt9 savpt10) (command "_.break" brk_e0 savpt9 savpt10))
      )

      (if (and (= sw:brk "1") brk_e3)
        (progn
          (if (eq brk_e1 brk_e3)
            (progn
              (entdel (nth 0 wnames))  
              (cw_ved "brk_e3" nextpt)
 
              (entdel (nth 0 wnames))
            )
          )
            
            (command "_.break" brk_e3 savpt11 savpt12)
        )
	)
    )
    ((= (rem uctr 6.0) 0)
      (setq fang nil)
      (setq p1 (cw_dl2 pt1))          ; Draw line part 2
      (setq pt2 (if (cw_l01 brk_e2 "3" pt2 pt1 strtpt)
                  ipt
                  savpt3
                )
      )
      (setq pt1 p1)
      (if flgn                        ; if closing
        (progn
          (setq tmp1 (nth flgn wnames)
                ent1 (entget tmp1)    ; get the corresponding prev. entity
          )
          (setq pt2 (cw_mls nil 10))           
        )                             
      )
    )
    ((= (rem uctr 6.0) 1)    
      (setq fang nil)
      (setq p1 (cw_dl2 pt1))          ; Draw line part 2
      (setq pt2 (if (cw_l01 brk_e2 "4" pt2 pt1 strtpt)
                  ipt
                  savpt4
                )
      )
      (setq pt1 p1)
      (if flgn                        ; if closing
        (progn
          (setq tmp1 (nth flgn wnames)
                ent1 (entget tmp1)    ; get the corresponding prev. entity
;;		brk_e1 nil    brk_e2 nil
          )
          (setq pt2 (cw_mls nil 10))           
        )                             
      )
      (if (and (= sw:brk "1") brk_e2)
   
        (command "_.break" brk_e2 savpt3 savpt4)
      )
    )
    ((= (rem uctr 6.0) 2)    
      (setq fang nil)
      (setq p1 (cw_dl2 pt1))          ; Draw line part 2
      (setq pt2 (if (cw_l01 brk_e2 "7" pt2 pt1 strtpt)
                  ipt
                  savpt7
                )
      )
      (setq pt1 p1)
      (if flgn                        ; if closing
        (progn
          (setq tmp1 (nth flgn wnames)
                ent1 (entget tmp1)    ; get the corresponding prev. entity
          )
          (setq pt2 (cw_mls nil 10))           
        )                             
      )
    )
    ((= (rem uctr 6.0) 3)
      (setq p1 (cw_dl2 pt1))          ; Draw line part 2
      (setq pt2 (if (cw_l01 brk_e2 "8" pt2 pt1 nextpt)
                  ipt
                  savpt8
                )
      )
      (setq pt1 p1)
      (if flgn                        ; if closing
        (progn
          (setq tmp1 (nth flgn wnames)
                ent1 (entget tmp1)    ; get the corresponding prev. entity
          )
          (setq pt2 (cw_mls nil 10))           
        )                             
      )
      ;; Do not set brk_e2 nil... it will be set later.
    )
    ((= (rem uctr 6.0) 4)
     (setq fang nil)
      (setq p1 (cw_dl2 pt1))          ; Draw line part 2
      (setq pt2 (if (cw_l01 brk_e3 "11" pt2 pt1 strtpt)
                  ipt
                  savpt11
                )
      )
      (setq pt1 p1)
      (if flgn                        ; if closing
        (progn
          (setq tmp1 (nth flgn wnames)
                ent1 (entget tmp1)    ; get the corresponding prev. entity
          )
          (setq pt2 (cw_mls nil 10))           
        )                             
      )
     )
    ((= (rem uctr 6.0) 5)
          (setq p1 (cw_dl2 pt1))          ; Draw line part 2
      (setq pt2 (if (cw_l01 brk_e3 "12" pt2 pt1 nextpt)
                  ipt
                  savpt12
                )
      )
      (setq pt1 p1)
      (if flgn                        ; if closing
        (progn
          (setq tmp1 (nth flgn wnames)
                ent1 (entget tmp1)    ; get the corresponding prev. entity
  ;;              brk_e0 nil   brk_e3 nil
          )
          (setq pt2 (cw_mls nil 10))           
        )                             
      )
      (if (and (= sw:brk "1") brk_e3)
        (command "_.break" brk_e3 savpt11 savpt12)
      )
     )
)  
  (command "_.line" pt1 pt2 "")         ; draw the line
));end if
  
  (setq wnames (if (null wnames) 
                 (list (setq elast (entlast)) )
		 (append wnames
		 (if (equal (nth (- (length wnames) 1) wnames) (entlast))
                   '("NON") (list (setq elast (entlast))))))
        uctr   (1+ uctr)
  )
  wnames
)
;;;
;;; Set pt1 or pt2 based on whether there is an arc or line to be broken.
;;;
;;; cw_l01 == Cavity_Wall_draw_Lines_0_and_1
;;;
(defun cw_l01 (bent1 n p1 p2 pt / temp)
  (setq n (strcat "savpt" n))
  (setq spt nil)
  (if bent1
    (if (= (cw_val 0 bent1) "LINE")
      (progn
        (setq temp (inters (trans (cw_val 10 bent1) 0 1)
                            (trans (cw_val 11 bent1) 0 1)
                            p1
                            p2
                            nil
                    )
        ) 
        (if temp
          (set (read n) temp)
          (progn
            (set (read n) p1)
            (setq brk_e1 nil)
          )
        )
      )
      (progn
        (set (read n) (cw_ial bent1 p1 p2 pt))
        (if spt
          (progn
            (setq ipt (eval (read n)))
            (set (read n) spt)
          )
        )
      )
    )
    (set (read n) p1)
  )
  (if spt
    T
    nil
  )
)

;;; cw_dl2 == Cavity_Wall_Draw_Line_segment_part_2
;;;
(defun cw_dl2 (npt)
    
  (setq tmp1 (nth (- uctr 6) wnames)
        ent1 (entget tmp1))           ; get the corresponding prev. entity
   
  ;; Check angles 0 180, -180  and 360...   
  (if (or  (equal (angle strtpt nextpt)
                 (angle (trans (cw_val 10 tmp1) 0 1)
                        (trans (cw_val 11 tmp1) 0 1)) 0.001)
           (equal (angle strtpt nextpt)
                 (angle (trans (cw_val 11 tmp1) 0 1)
                        (trans (cw_val 10 tmp1) 0 1)) 0.001)
           (equal (+ (* 2 pi) (angle strtpt nextpt))
                 (angle (trans (cw_val 10 tmp1) 0 1)
                        (trans (cw_val 11 tmp1) 0 1)) 0.001)
      )
    (progn
      (setq brk_e2 nil)
      (if (not (equal (trans (cw_val 11 tmp1) 0 1) pt1 0.00001))
      	(command "_.line" (trans (cw_val 11 tmp1) 0 1) pt1 "")
 	)
      pt1
    )
    (cw_mls nil 11)
  )
)
;;;
;;; Modify line endpoint
;;;
;;; cw_mls == Cavity_Wall_Modify_Line_Segment
;;;
(defun cw_mls (flg2 nn / spt ept pt)     ; flg2 = nil if line to line
                                         ;      = T   if line to arc

  ;; This is the previous entity; a line
  (setq spt (trans (cw_val 10 tmp1) 0 1)   
        ept (trans (cw_val 11 tmp1) 0 1)
  )
  (if flg2
    ;; find intersection with arc; tmp == ename of arc
    (progn
      ;; Find arc intersection with line; tmp == ename of arc.
      (setq pt (cw_ial tmp spt ept (if flgn nextpt strtpt)))
    )

    ;; find intersection with line
    (setq pt (inters spt ept pt1 pt2 nil)) 
  )
  ;; modify the previous line
  (if pt 
    (entmod (subst (cons nn (trans pt 1 0)) 
                   (assoc nn ent1) 
                   ent1))
    (setq pt pt2)
  )
  pt
)

;;; cw_g2p == Cavity_Wall_Get_2_Points
;;;
(defun cw_g2p (npt / temp l theta)
  (if (equal d 0.0 0.01)
    (setq theta pi2
          nang (+ ang pi2)
    )
    (setq l     (sqrt (abs (- (expt rad 2) (expt d 2))))
          theta (abs (atan (/ l d)))
    )
  )
  (setq ipt1 (polar cpt (- nang theta) rad))
  (setq ipt2 (polar cpt (+ nang theta) rad))
  ;; Set the Closer of the two points to npt to be ipt1.
  (if (< (distance ipt2 npt) (distance ipt1 npt))
    ;; Swap points
    (setq temp ipt1
          ipt1 ipt2
          ipt2 temp
    )
    (if (equal (distance ipt2 npt) (distance ipt1 npt) 0.01)
      (exit)
    )
  )
  ipt1
)

;;; cw_ial == Cavity_Wall_Intersect_Arc_with_Line
;;;
(defun cw_ial (arc pt_1 pt_2 npt / d pi2 rad ang nang temp ipt)
  
  (setq cpt  (trans (cw_val 10 arc) (cw_val -1 arc) 1)
        pi2  (/ pi 2)                 ; 1/2 pi
        ang  (angle pt_1 pt_2)                   
        nang (+ ang pi2)              ; Normal to "ang"
        temp (inters pt_1 pt_2 cpt (polar cpt nang 1) nil)
        nang (angle cpt temp)
  )
  (setq d (distance cpt temp))

  (cond
    ((equal (setq rad (cw_val 40 arc)) d 0.01)
      (setq ipt temp)
    )
    ((< rad d)                       
      ;; No intersection.             
      (setq spt (polar cpt nang rad)
            ipt temp
      )
      (command "_.line" spt ipt "")
      ipt
    )
    (T
      (if (and cw_arc fang (> uctr 1))
        (setq npt (polar cpt fang rad))
      )
      (cw_g2p npt)
      (setq ipt (cw_bp arc pt_1 pt_2 ipt1 ipt2))
      (if fang
        (setq fang nil)
        (if cw_arc (setq fang (angle cpt ipt)))
      )
      ipt
    )
  )
)
;;; cw_onl == DLine_ON_Line_segment
;;;
(defun cw_onl (sp ep pt / cpt sa ea ang)
  (if (inters sp ep pt
              (polar pt (+ (angle sp ep) (/ pi 2))
                     (/ cw:snw 10.0)
              )
              T)
    T
    nil
  )
)

;;; cw_ona == DLine_ON_Arc_segment
;;;
(defun cw_ona (arc pt / cpt sa ea ang)
  (setq cpt (trans (cw_val 10 arc) (cw_val -1 arc) 1)
        sa  (cw_val 50 arc)           ; angle of current ent start point
        ea  (cw_val 51 arc)           ; angle of current ent end point
        ang (angle cpt pt)            ; angle to pt.
  )
  (if (> sa ea)
    (if (or (and (> ang sa) (< ang (+ ea (* 2 pi))))
            (and (> ang (- ea (* 2 pi))) (< ang ea))
        )
      T
      nil
    )
    (if (and (> ang sa) (< ang ea)) T nil)
  )
)

;;; cw_bp == Cavity_Wall_Best_Point_of_arc_and_line
;;;
(defun cw_bp (en1 p1 p2 pp1 pp2 / temp temp1 temp2)
  (setq temp1 (cw_onl p1 p2 pp2)
        temp2 (cw_ona en1 pp2)
        temp  (if (or (= flg 1) (= flg 3)) T nil)
  )
  (if (and temp1 temp2)
    (if (and (< uctr 2)
             (and brk_e1 brk_e2))
      pp1
      (if (and temp (not fang)) pp1 pp2)
    )
    pp1
  )
)

;;; The value of the assoc number of <ename>
;;;
(defun cw_val (v temp)
  (cdr(assoc v (entget temp)))
)
;;;
;;; List stripper : strips the last "v" members from the list
;;;
(defun cw_lsu (lst v / m)
  (setq m 0 temp '())
  (repeat (- (length lst) v)
    (progn
      (setq temp (append temp (list (nth m lst))))
      (setq m (1+ m))
  ) )
  temp
)
;;;
;;; Set these defaults when loading the routine.
;;;


(defun ddcw_init ()

  (defun reset ()

    ;(if (not ethickness) (setq ethickness 0))
    (setq reset_flag t)
  )

  (defun cw_set (/ chnaged?)
    
    (PROP_SAVE wal:prop)
    
    (if (/= old_opb sw:opb)                    
      (setvar "pickbox" sw:opb)
    )
    
      (if (= uctr 0)
        (cw_ved "brk_e1" strtpt)
      ) 
    
  )

  (defun draw_size (intsize)
    (setq x1 (- (/ x_aperture 2) (1+ intsize) ))
    (setq x2 (+ (/ x_aperture 2) (1+ intsize) ))
    (setq y1 (- (/ y_aperture 2) (1+ intsize) ))
    (setq y2 (+ (/ y_aperture 2) (1+ intsize) ))
    (start_image "pickbox_image")
    (fill_image 0 0 x_aperture y_aperture -2)
    (vector_image x1 y1 x2 y1 -1)
    (vector_image x2 y1 x2 y2 -1)
    (vector_image x2 y2 x1 y2 -1)
    (vector_image x1 y2 x1 y1 -1)
    (end_image)
  )
  ;;
  ;; Common properties for all entities
  ;;
  (defun set_tile_props ()
    
    (set_tile "error" "")
    (set_tile wl_prop_type "1")
    (@get_eval_prop wl_prop_type wal:prop)

    
    (if (= cw:wty "single") (set_tile "rd_single" "1") (set_tile "rd_double" "1"))
    (wl_DrawImage "wall_image" cw:wty)
    
    (set_tile "ed_drag" (rtos cw:osd))
    (set_tile "eb_finish_left" (rtos cw:fin1))
    (set_tile "eb_finish_right" (rtos cw:fin2))
    
    (set_tile "eb_total_width" (rtos cw:snw))
    (set_tile "tx_cave_width" (rtos cw:snc))
    (set_tile "eb_right_width" (rtos cw:sno))
    (set_tile "eb_left_width" (rtos cw:sno1))
    (set_tile "tx_type" C_wall_type)
      
    (set_tile (cond ((= cw:ecp 4) "rd_auto") ((= cw:ecp 3) "rd_both") ((= cw:ecp 2) "rd_end") ((= cw:ecp 1) "rd_start") ((= cw:ecp 0) "rd_none")) "1")
    
    (set_tile "tg_break" sw:brk)
    (set_tile "tg_attach" sw:atc)

  )
  (defun value_chk? ()
    (if (and (<= (atof (get_tile "tx_cave_width")) 0) (= cw:wty "double"))
       (alert "공간벽 두께는 0보다 커야 합니다.")
       (dismiss_dialog 1)
    )
  )
  (defun set_action_tiles ()
    (action_tile "cancel"       "(dismiss_dialog 0)")
    (action_tile "accept"       "(value_chk?)")
    
    (action_tile "b_color"      "(@getcolor)(wl_DrawImage \"wall_image\" cw:wty)")
    (action_tile "color_image"   "(@getcolor)(wl_DrawImage \"wall_image\" cw:wty)")
    (action_tile "b_name"       "(@getlayer)(wl_DrawImage \"wall_image\" cw:wty)")
    (action_tile "b_line"       "(@getlin)(wl_DrawImage \"wall_image\" cw:wty)")
    (action_tile "c_bylayer"    "(@bylayer_do T)(wl_DrawImage \"wall_image\" cw:wty)")
    (action_tile "t_bylayer"    "(@bylayer_do nil)(wl_DrawImage \"wall_image\" cw:wty)")
    
    (action_tile "prop_radio" "(setq wl_prop_type $Value) (@get_eval_prop wl_prop_type wal:prop) (wl_DrawImage \"wall_image\" cw:wty)")

    (action_tile "bn_type"       "(ttest)")

    (action_tile "rd_single"    "(setq cw:wty \"single\")(radio_do)(wl_DrawImage \"wall_image\" cw:wty)")
    (action_tile "rd_double"    "(setq cw:wty \"double\")(radio_do)(wl_DrawImage \"wall_image\" cw:wty)")
    (action_tile "ed_drag"      "(getfsize $value \"ed_drag\")")
    
    (action_tile "eb_total_width"     "(getfsize $value \"eb_total_width\")")
    (action_tile "eb_right_width"    "(getfsize $value \"eb_right_width\")")
    (action_tile "eb_left_width"    "(getfsize $value \"eb_left_width\")")
    (action_tile "eb_finish_left"   "(getfsize $value \"eb_finish_left\")")
    (action_tile "eb_finish_right"  "(getfsize $value \"eb_finish_right\")")
          
    (action_tile "rd_auto" "(setq cw:ecp 4)")
    (action_tile "rd_both" "(setq cw:ecp 3)")
    (action_tile "rd_start" "(setq cw:ecp 1)")
    (action_tile "rd_end" "(setq cw:ecp 2)")
    (action_tile "rd_none" "(setq cw:ecp 0)")

    (action_tile "pickbox_slider"
                 "(draw_size (setq sw:opb (atoi $value)))")

    (action_tile "tg_break"       "(setq sw:brk $value)")
    (action_tile "tg_attach"       "(setq sw:atc $value)")
    (action_tile "bn_type_save"   "(readF \"WallType.dat\" nil)(ValueToList)(writeF \"WallType.dat\" nil)")

    ;;***
    
  )

  (defun radio_do ()
   (if (= cw:wty "single")
     (progn
       (mode_tile "eb_right_width" 1)
       (mode_tile "eb_left_width" 1)
       (mode_tile "tx_cave_width" 1))
     (progn
       (mode_tile "eb_right_width" 0)
       (mode_tile "eb_left_width" 0)
       (mode_tile "tx_cave_width" 0))
    )
  )


  (defun getfsize (value tiles)
    (cond ((= tiles "ed_drag")
    		(setq cw:osd (verify_d tiles value cw:osd))
	   )
	  ((= tiles "eb_total_width")
    		(setq cw:snw (verify_d tiles value cw:snw))
	   )
	  ((= tiles "eb_right_width")
	   	(setq cw:sno (verify_d tiles value cw:sno))
	   )
	  ((= tiles "eb_left_width")
	   	(setq cw:sno1 (verify_d tiles value cw:sno1))
	   )
	  ((= tiles "eb_finish_left")
	   	(setq cw:fin1 (verify_d tiles value cw:fin1))
	   )
	  ((= tiles "eb_finish_right")
	   	(setq cw:fin2 (verify_d tiles value cw:fin2))
	   )
	  )
  )
  (defun verify_d (tile value old-value / coord valid errmsg cw:sni)
    (setq valid nil errmsg "Invalid input value.")
    (if (setq coord (distof value))
      (progn
        (cond
          ((= tile "eb_total_width")
            (if (> coord 0)
              
                (setq valid  T
                      cw:sni (- coord cw:sno cw:sno1)
                )

              (setq errmsg "Value must be positive and nonzero.")
            )
          )
          ((= tile "eb_right_width")
            (if (> coord 0)
              (if (<= coord cw:snw )
                (setq valid  T
                      cw:sni (- cw:snw coord cw:sno1)
                )
                (setq errmsg (strcat "Value must be less than " (rtos cw:snw )))
              )
              (setq errmsg "Value must be positive and nonzero.")
            )
          )
          ((or (= tile "eb_finish_left") (= tile "eb_finish_right"))
	   (if (>= coord 0)
	     (setq valid  T
		   cw:sni (- cw:snw cw:sno cw:sno1))
	     (setq errmsg "Value must be positive or zero.")
	     ))
	  ((= tile "eb_left_width")
            (if (> coord 0)
              (if (<= coord cw:snw )
                (setq valid  T
                      cw:sni (- cw:snw cw:sno coord)
                )
                (setq errmsg (strcat "Value must be less than " (rtos cw:snw )))
              )
              (setq errmsg "Value must be positive and nonzero.")
            )
          )
	  
          (T
            (setq valid T)
            (setq cw:sni (- cw:snw cw:sno cw:sno1))
          )
        )
      )
      (setq valid nil)
    )
    (if valid
      (progn
      (set_tile "tx_cave_width" (rtos cw:sni))
      (setq cw:snc cw:sni)
      (progn 
        (if (or (= errchk 0) (= tile last-tile))
          (set_tile "error" "")
        )
        (set_tile tile (rtos coord))
        (set_tile "tx_cave_width" (rtos cw:sni))
        (setq errchk 0)
        (setq last-tile tile)
        coord
      ))
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

;;-- list box handle  
(defun ttest (/ old_wall_type zin_old)
 (readF "WallType.dat" nil)
 (setq  old_Wall_type C_Wall_type)
 (setq L_index (Find_index old_Wall_type))
    (progn
      (setq zin_old (getvar "dimzin"))
      (setvar "dimzin" 8)
      (if (not (new_dialog "set_type_name" dcl_id)) (exit)) 
      (set_tile "title" "List of Entities")
      
      (list_view)
      (Set_tileS)
      (action_Tiles)
      (start_dialog)
      (setvar "dimzin" zin_old)
     ))

(defun set_tileS ()
 
 (if (= L_index nil) (setq L_index 0 ))
 (setq C_Wall_type (nth 0 (cdr (nth L_index @Type))))  
 (set_tile "list_type" (rtos L_index)) 
 (set_tile "current_type" old_Wall_type)
 (set_tile "ed_type_name" C_Wall_type) 
)

(defun action_Tiles ()
 (action_tile "list_type" "(setq C_Wall_type (Field_match \"타입명\" (setq L_index (atoi $value))))(set_tileS)")
 (action_tile "accept" "(qqqq)")
 (action_tile  "cancel" "(setq C_wall_type old_wall_type)")
 (action_tile "eb_del_type" "(deleteIdx 'C_Wall_type)(set_tileS)")
 (action_tile "eb_ren_type" "(renameIdx 'C_Wall_type)(set_tileS)")
 (action_tile "eb_new_type" "(newIdx 'C_Wall_type)(set_tileS)")
)
(defun qqqq()
  (Set_Wall_Value)(writeF "WallType.dat" nil)(done_dialog 1)(set_tile_props)
)
;-- list box gandle

) ; end ddcw_init

(defun ddcw_do ()
  (if (not (new_dialog "dd_wall" dcl_id)) (exit))
  (set_tile_props)
  (radio_do)
  
 
  (if (< 19 sw:opb) (setq sw:opb 19))
  (if (> 0 sw:opb) (setq sw:opb 0))
  (setq sw:opb_init sw:opb)

  (setq x_aperture (dimx_tile "pickbox_image"))
  (setq y_aperture (dimy_tile "pickbox_image"))
  (set_tile "pickbox_slider" (itoa sw:opb))

  (draw_size sw:opb)

  (set_action_tiles)
  (setq dialog-state (start_dialog))
  (if (= dialog-state 0)
    (reset)
  )
)

(defun cw_return ()
  (setq wal:wprop old_wprop  
        wal:fprop old_fprop  
          
        cw:ecp old_ecp
        cw:osd old_osd
        sw:brk old_brk
        
        sw:opb old_opb
        cw:snw old_wid
        cw:sno old_sno
        cw:snc old_snc
  )
)
;;; ================== (ddcw) - Main program ========================
;;;
;;; Before (ddcw) can be called as a subroutine, it must
;;; be loaded first.  It is up to the calling application to
;;; first determine this, and load it if necessary.

(defun ddcw (/      
               dcl_id           dialog-state    dismiss_dialog 
               elist            
               cw_set           draw_size       
      		getfsize
               old_wprop  old_fprop      old_ecp
               old_osd          old_wid         old_brk        
               old_opb          old-idx         old_sno        old_snc
               reset            reset_flag      set_action_tiles sortlist temp_color
               tile            set_tile_props
               value            verify_d        
               x_aperture       y_aperture
	       ttest  set_tileS action_Tiles ValueToList qqqq
	       )

  (setvar "cmdecho" (cond (  (or (not *debug*) (zerop *debug*)) 0)
                          (t 1)))
  (setq old_wprop  wal:wprop
        old_fprop  wal:fprop
        
        old_ecp cw:ecp
        old_osd cw:osd
        old_wid cw:snw
        old_sno cw:sno
	old_sno1 cw:sno1
        old_snc cw:snc
        old_brk sw:brk
        
        old_opb sw:opb
  )
    
(defun ValueToList(/ tmpBreak newlist tmm tmpAttach tmpauto )
  (setq tmplist (nth L_index @type))
  (setq tmpBreak (if (= sw:brk "1") "o" "x"))
  (setq  tmpAttach  (if (=  sw:atc "1") "o" "x"))
  (setq tmpauto (cond ((= cw:ecp 4) "Auto") ((= cw:ecp 3) "Both")
		      ((= cw:ecp 2) "End") ((= cw:ecp 1) "Start") ((= cw:ecp 0) "None")))
  
  (setq tmm (list C_Wall_type cw:wty (rtos cw:snw) (rtos cw:sno) (rtos cw:sno1)
		   (rtos cw:fin1) (rtos cw:fin2) tmpauto tmpBreak tmpAttach (rtos cw:osd)))
  (setq newlist (cons (1+ L_index) tmm))
  (setq @type (subst newlist tmplist @Type) )
)

 
  (cond
 
     (  (not (ai_acadapp)))                      ; ACADAPP.EXP xloaded?
     

     (t (setq dcl_id (load_dialog "LTWall.dcl"))     ; is .DLG file loaded?
        (ai_undo_push)
        (ddcw_init)                          ; everything okay, proceed.
        (ddcw_do)
        
     )
  )
  (if reset_flag
    (cw_return)
    (cw_set)
  )
  (if dcl_id (unload_dialog dcl_id))
)
;;;
;;; These are the c: functions.
;;;
(defun Set_Wall_Value(/ tnnp ttmpp1)
  
  (setq cw:wty (strcase (Field_match "벽타입" L_index) T))
  (setq cw:snw (atof (Field_match "총두께" L_index) ))
  (setq cw:sno (atof (Field_match "왼쪽두께" L_index)))
  (setq cw:sno1 (atof (Field_match "오른쪽두께" L_index)))
  (setq cw:fin1 (atof (Field_match "밖마감" L_index)))
  (setq cw:fin2 (atof (Field_match "안마감" L_index)))
  (setq cw:ecp (cond ((=(setq ttmpp1 (Field_match "Caps" L_index)) "None") 0)
		     ((= ttmpp1 "Start") 1) ((= ttmpp1 "End") 2)
		     ((= ttmpp1 "Both") 3) ((= ttmpp1 "Auto") 4)))
  (setq sw:brk (if (=(Field_match "Break" L_index) "o") "1" "0"))
  (setq sw:atc (if (=(Field_match "Attach" L_index) "o") "1" "0"))
  (setq dist (atof (Field_match "Dragdist" L_index)))
)
(if (null C_Wall_type)
   (progn
   (setq wal:wprop  (Prop_search "wall" "wall"))
   (setq wal:fprop  (Prop_search "wall" "finish"))
   (setq wal:prop '(wal:wprop wal:fprop ))
   (readF "WallType.dat" nil) (setq L_index 0)
   (setq C_Wall_type (nth 0 (cdr (nth L_index @Type))))
   (Set_wall_Value)
))

  (if (null wal:wprop) (setq wal:wprop (list "wall" "wall" "WALL" "6" "CONTINUOUS" "1" "1")))
  (if (null wal:fprop) (setq wal:fprop (list "wall" "finish" "FINISH" "4" "CONTINUOUS" "1" "1")))
  
  (if (null cw:wty) (setq cw:wty "double"))
  (if (null cw:fin1) (setq cw:fin1 10))
  (if (null cw:fin2) (setq cw:fin2 10))
  (if (null sw:brk) (setq sw:brk "1"))    ; default to breaking ON
  (if (null cw:osd) (setq cw:osd 0))    ; default to center alignment
  (if (null cw:snw) (setq cw:snw 250))  ; default to Cavity_Wall_width
  (if (null cw:sno) (setq cw:sno 90))   ; default to Outside_Wall_width
  (if (null cw:snc) (setq cw:snc 90))   ; default to Cavity_width
  (if (null cw:sno1) (setq cw:sno1 (- cw:snw cw:sno cw:snc)))
  (if (null cw:col) (setq cw:col (get_num co_wal)))
  (if (null cw:lin) (setq cw:lin li_wal))
  (if (null cw:lay) (setq cw:lay "WALL"))

  (if (null cw:ecp) (setq cw:ecp 4))
  (if (null sw:atc) (setq sw:atc "1"))
  (if (null wl_prop_type) (setq wl_prop_type "rd_wall"))


(defun c:cimwall () (m:cw))
(setq lfn28 1)
(princ)



