; 작업날짜: 2001년 8월 13일
; 작업자: 박율구
; 명령어: CIMMCD

(setq lfn42 1)

(defun m:mcd (/ bm      osm 
                mcd_err mcd_oer mcd_oco mcd_ola mcd_oli mcd_snap mcd_dim
             )
  
  (setq bm       (getvar "blipmode")
        osm      (getvar "osmode")
        mcd_oco  (getvar "cecolor")
        mcd_ola  (getvar "clayer")
        mcd_oli  (getvar "celtype")
        mcd_snap (getvar "snapang")
        mcd_dim  (getvar "dimstyle")
        sc       (fix (getvar "dimscale"))
  )
  (if (= module_cnt   nil)(setq module_cnt    0)) ; init ( defun set_module() )
  (if (= cur_module   nil)(setq cur_module    0)) ; init
  (if (= mcd:size     nil)(setq mcd:size      7)) ; mcd:size is integer!!!
  (if (= mcd:position nil)(setq mcd:position  "3"))
  (if (= mcd:dir      nil)(setq mcd:dir       0))
  ;;
  ;; Internal error handler defined locally
  ;;
  (defun mcd_err (s)                   ; If an error (such as CTRL-C) occurs
                                       ; while this command is active...
    (if (/= s "Function cancelled")
      (if (= s "quit / exit abort")
        (princ)
        (princ (strcat "\nError: " s))
      )
    )
    (setvar "cmdecho" 0)
    (if mcd_oer                        ; If an old error routine exists
      (setq *error* mcd_oer)           ; then, reset it 
    )
    (setvar "cecolor" mcd_oco)
    (setvar "clayer" mcd_ola)
    (setvar "celtype" mcd_oli)
    (command "_.undo" "_en")
    (ai_undo_off)
    (setvar "blipmode" bm)
    (setvar "snapang" mcd_snap)
    (command "_.dimstyle" "r" mcd_dim)
    (setvar "cmdecho" 1)
    (setvar "osmode" osm)
    (princ)
  )
  ;; Set our new error handler
  (if (not *DEBUG*)
    (if *error*                     
      (setq mcd_oer *error* *error* mcd_err) 
      (setq *error* mcd_err) 
    )
  )

  (setvar "cmdecho" 0)
  (ai_undo_on)
  (command "_.undo" "_group")

  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n안목치수를 그리는 명령입니다.")

  (if (= mcd:sym_lay nil)
    (setq mcd:sym_lay "SYMBOL"    mcd:sym_col 7
          mcd:dim_lay "DIMENSION" mcd:dim_col 7
    )
  )
  (setlay "SYMBOL")
  (setlay "DIMENSION")
  
  (setq cont T temp T uctr 0)
  (while cont
    (mcd_m1)
  )

  (command "_.undo" "_en")
  (ai_undo_off)
  
  (setvar "cecolor" mcd_oco)
  (setvar "clayer" mcd_ola)
  (setvar "celtype" mcd_oli)
  (setvar "snapang" mcd_snap)
  (command "_.dimstyle" "r" mcd_dim)
  (setvar "cmdecho" 1)
  (setvar "blipmode" bm)
  (setvar "osmode" osm)
  (princ)
) ; end m:mcd


(defun mcd_m1(/ undo_check dd_check)
  (setq undo_check nil dd_check nil)
  (while temp
    (setvar "osmode" 513)
    (setvar "orthomode" 0)
    (setvar "blipmode" 0)
    (if (< mcd:dir 2) (setvar "snapang" 0)) 
    (if (> uctr 0) 
      (progn
        (if (/= undo_check T)
          (if (/= dd_check T)
            (progn
              (setq tem4 T) 
              (mcd_m6)
            )
          )
        )  
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
    (cond
      ((= strtpt "Dialog")
        (mcd_dd)
        (setq dd_check T)
      )
      ((= strtpt "Undo")
        (command "_.undo" "_b")
        (setq uctr (1- uctr)
              undo_check T
        )
      )
      ((null strtpt)
        (setq cont nil temp nil)
      )
      (T
        (setq tem T)
        (mcd_m2)
        (setq dd_check   nil
              undo_check nil
        )
      )
    )
  )
)
(defun mcd_m2()
  (while tem
    (setq second_pt (getpoint "\nSelect second point: "))
    (cond
      ((null second_pt)
        (setq tem nil)
      )
      (T
        (setq tem1 T)
        (mcd_m3)
      )
    )
  )
)
(defun mcd_m3()
  (while tem1
    (if (= mcd:dir 2)
      (setvar "snapang" (angle strtpt second_pt))
      (setvar "snapang" 0)
    )
    (setvar "orthomode" 1)
    (setq dim1_pt (getpoint strtpt "\nSelect start point of dimension: "))
    (cond
      ((null dim1_pt)
        (setq tem1 nil tem nil)
      )
      (T
        (setq tem2 T)
        (mcd_m4)
      )
    )
  )
)
(defun mcd_m4()
  (while tem2
    (setq dim2_pt (getpoint dim1_pt "\nSelect location point of dimension: "))
    (cond
      ((null dim2_pt)
        (setq tem2 nil tem1 nil tem nil)
      )
      (T
        (setq tem3 T)
        (mcd_m5)
      )
    )
  )
)
(defun mcd_m5()
  (while tem3
    (setq balloon_pt (getpoint dim1_pt "\nSelect start point of symbol: "))
    (cond
      ((null balloon_pt)
        (setq tem3 nil tem2 nil tem1 nil tem nil)
      )
      (T
        (command "_.undo" "_m")
        (mcd_ex)
        (setq opt1 strtpt opt2 second_pt opt3 dim1_pt opt4 dim2_pt opt5 balloon_pt)
        (setq uctr (1+ uctr))
        (setq tem3 nil tem2 nil tem1 nil tem nil)
      )
    )
  )
)
(defun mcd_m6()
  (setvar "osmode" 513)
  (while tem4
    (setq pt_e1 (getpoint second_pt "\nSelect extend start point: "))
    (cond ((null pt_e1) (setq tem4 nil))
          ((= mcd:dir 0) ;수평이면...
           (if (< (car opt1) (car opt2))
             (if (> (car opt2) (car pt_e1))
               (princ "\nInvalid direction!")
               (progn (setq pt_e2 (getpoint pt_e1 "\nSelect extend second point: "))
                      (cond ((null pt_e2) (setq tem4 nil))
                            ((> (car pt_e1) (car pt_e2)) (princ "\nInvalid direction!"))
                            (T (mcd_ex2))
                      )
               )             
             )
             (if (< (car opt2) (car pt_e1))
               (princ "\nInvalid direction!")
               (progn (setq pt_e2 (getpoint pt_e1 "\nSelect extend second point: "))
                      (cond ((null pt_e2) (setq tem4 nil))
                            ((< (car pt_e1) (car pt_e2)) (princ "\nInvalid direction!"))
                            (T (mcd_ex2))
                      )
               )
             )
           )
          )
          ((= mcd:dir 1) ;수직이면...
           (if (< (cadr opt1) (cadr opt2))
             (if (> (cadr opt2) (cadr pt_e1))
               (princ "\nInvalid direction!")
               (progn (setq pt_e2 (getpoint pt_e1 "\nSelect extend second point: "))
                      (cond ((null pt_e2) (setq tem4 nil))
                            ((> (cadr pt_e1) (cadr pt_e2)) (princ "\nInvalid direction!"))
                            (T (mcd_ex2))
                      )
               )             
             )
             (if (< (cadr opt2) (cadr pt_e1))
               (princ "\nInvalid direction!")
               (progn (setq pt_e2 (getpoint pt_e1 "\nSelect extend second point: "))
                      (cond ((null pt_e2) (setq tem4 nil))
                            ((< (cadr pt_e1) (cadr pt_e2)) (princ "\nInvalid direction!"))
                            (T (mcd_ex2))
                      )
               )
             )
           )
          )
          ((= mcd:dir 2) ;기울기라면...
           (setq snap1 (- (angle opt1 opt2) (/ pi 2))
                 snap2 (+ (angle opt1 opt2) (/ pi 2))
           )
           (if (< snap1 0) (setq snap1 (+ snap1 (* 2 pi))))
           (if (< snap2 0) (setq snap2 (+ snap2 (* 2 pi))))
           (if (> snap1 (* 2 pi)) (setq snap1 (- snap1 (* 2 pi))))
           (if (> snap2 (* 2 pi)) (setq snap2 (- snap2 (* 2 pi))))
           (cond ((and (< (car opt1) (car opt2)) (< (cadr opt1) (cadr opt2)))
                  (if (and (< (angle opt2 pt_e1) snap1) (> (angle opt2 pt_e1) snap2))
                    (princ "\nInvalid direction!")
                    (progn (setq pt_e2 (getpoint pt_e1 "\nSelect extend second point: "))
                           (cond ((null pt_e2) (setq tem4 nil))
                                       ((and (< (angle pt_e1 pt_e2) snap1) (> (angle pt_e1 pt_e2) snap2))
                                  (princ "\nInvalid direction!")
                                 )
                                 (T (mcd_ex2))
                           )
                    )
                  )
                 )
                 ((and (> (car opt1) (car opt2)) (< (cadr opt1) (cadr opt2)))
                  (if (and (> (angle opt2 pt_e1) snap1) (< (angle opt2 pt_e1) snap2))
                    (progn (setq pt_e2 (getpoint pt_e1 "\nSelect extend second point: "))
                           (cond ((null pt_e2) (setq tem4 nil))
                                       ((and (> (angle pt_e1 pt_e2) snap1) (< (angle pt_e1 pt_e2) snap2))
                                 (mcd_ex2)
                                 )
                                 (T (princ "\nInvalid direction!"))
                           )
                    )
                    (princ "\nInvalid direction!")
                  )
                 )
                 ((and (> (car opt1) (car opt2)) (> (cadr opt1) (cadr opt2)))
                  (if (and (> (angle opt2 pt_e1) snap1) (< (angle opt2 pt_e1) snap2))
                    (progn (setq pt_e2 (getpoint pt_e1 "\nSelect extend second point: "))
                           (cond ((null pt_e2) (setq tem4 nil))
                                       ((and (> (angle pt_e1 pt_e2) snap1) (< (angle pt_e1 pt_e2) snap2))
                                 (mcd_ex2)
                                 )
                                 (T (princ "\nInvalid direction!"))
                           )
                    )
                    (princ "\nInvalid direction!")
                  )
                 )
                 ((and (< (car opt1) (car opt2)) (> (cadr opt1) (cadr opt2)))
                  (if (and (< (angle opt2 pt_e1) snap1) (> (angle opt2 pt_e1) snap2))
                    (princ "\nInvalid direction!")
                    (progn (setq pt_e2 (getpoint pt_e1 "\nSelect extend second point: "))
                           (cond ((null pt_e2) (setq tem4 nil))
                                       ((and (< (angle pt_e1 pt_e2) snap1) (> (angle pt_e1 pt_e2) snap2))
                                 (princ "\nInvalid direction!")
                                 )
                                 (T (mcd_ex2))
                           )
                    )
                  )
                 )
           )         
           
           
          ) 
    ) ; end cond
  ) ; end while
  
)  
;======================================================================================
;======================================================================================
;================================   mcd_ex2   =========================================
;======================================================================================
;======================================================================================

(defun mcd_ex2(/ pt1 pt3 pt3_1 pt3_2 pt3_3 pt3_4 pt3_c pt4 pt5) ;except pt2
  (setq pt2_ex2 pt2)
  (setvar "osmode" 0)
  (setq mcd:size (* mcd:size sc))
  (cond ((= mcd:dir 0) ; 수평이면...
         (setq strtpt     (list (car pt_e1) (cadr opt1))
                      second_pt  (list (car pt_e2) (cadr opt2))
               dim1_pt    (list (car pt_e1) (cadr opt3))
               dim2_pt    (list (car pt_e1) (cadr opt4))
               balloon_pt (list (car pt_e1) (cadr opt5))
         )
         (setq ;pt1 (list (car strtpt)    (cadr dim1_pt))
               pt2 (list (car second_pt) (cadr dim1_pt))
               pt3 (list (car second_pt) (cadr balloon_pt)); other balloon point
         )      
         (if (< (cadr opt3) (cadr opt4)) ; y축 증가하면?
           (setq pt3_1 (polar balloon_pt (dtr 90)  (* mcd:size 2))
                 pt3_2 (polar pt3        (dtr 90)  (* mcd:size 2))
                 pt3_3 (polar pt3_1      (dtr 270) (/ mcd:size 2))
                 pt3_4 (polar pt3_2      (dtr 270) (/ mcd:size 2))
                 pt3_l (polar balloon_pt (dtr 90)     mcd:size   )
                 pt3_r (polar pt3        (dtr 90)     mcd:size   )
           )
           (setq pt3_1 (polar balloon_pt (dtr 270) (* mcd:size 2))
                 pt3_2 (polar pt3        (dtr 270) (* mcd:size 2))
                 pt3_3 (polar pt3_1      (dtr 90)  (/ mcd:size 2))
                 pt3_4 (polar pt3_2      (dtr 90)  (/ mcd:size 2))
                 pt3_l (polar balloon_pt (dtr 270)     mcd:size   )
                 pt3_r (polar pt3        (dtr 270)     mcd:size   )
           )
         )         
        )
        ((= mcd:dir 1) ; 수직이면...
         (setq strtpt     (list (car opt1) (cadr pt_e1))
                      second_pt  (list (car opt2) (cadr pt_e2))
               dim1_pt    (list (car opt3) (cadr pt_e1))
               dim2_pt    (list (car opt4) (cadr pt_e1))
               balloon_pt (list (car opt5) (cadr pt_e1))
         )
         (setq ;pt1 (list (car dim1_pt) (cadr strtpt)   )
               pt2 (list (car dim1_pt) (cadr second_pt))
               pt3 (list (car balloon_pt) (cadr second_pt)); other balloon point
         )      
         (if (< (car dim1_pt) (car dim2_pt)) ; x축 증가하면?
           (setq pt3_1 (polar balloon_pt (dtr 0)   (* mcd:size 2))
                 pt3_2 (polar pt3        (dtr 0)   (* mcd:size 2))
                 pt3_3 (polar pt3_1      (dtr 180) (/ mcd:size 2)); center of Arc
                 pt3_4 (polar pt3_2      (dtr 180) (/ mcd:size 2)); center of Arc
                 pt3_l (polar balloon_pt (dtr 0)     mcd:size   )
                 pt3_r (polar pt3        (dtr 0)     mcd:size   )
           )
           (setq pt3_1 (polar balloon_pt (dtr 180) (* mcd:size 2))
                 pt3_2 (polar pt3        (dtr 180) (* mcd:size 2))
                 pt3_3 (polar pt3_1      (dtr 0)   (/ mcd:size 2)); center of Arc
                 pt3_4 (polar pt3_2      (dtr 0)   (/ mcd:size 2)); center of Arc
                 pt3_l (polar balloon_pt (dtr 180)     mcd:size   )
                 pt3_r (polar pt3        (dtr 180)     mcd:size   )
           )
         )
        )
        ((= mcd:dir 2) ;기울기라면...
         (setq snapangle (angle opt1 opt2)
               snap_e1 (angle opt2 pt_e1)
               snap_e2 (angle pt_e1 pt_e2)
               dist_e1 (distance opt2 pt_e1)
               dist_e2 (distance pt_e1 pt_e2)
         )      
         (cond ((and (< (car opt1) (car opt2)) (< (cadr opt1) (cadr opt2)));1사분면
                (if (< (cadr opt2) (cadr pt_e1))
                  (if (< snapangle snap_e1)
                    (setq ang (- snap_e1 snapangle))
                    (setq ang (- snapangle snap_e1))
                  )
                  (setq ang (+ snapangle (- (* 2 pi) snap_e1))) 
                )
                (setq strtpt (polar opt2 snapangle (* (cos ang) dist_e1)))
                (if (< (cadr pt_e1) (cadr pt_e2))
                  (if (< snapangle snap_e2)
                    (setq ang (- snap_e2 snapangle))
                    (setq ang (- snapangle snap_e2))
                  )
                  (setq ang (+ snapangle (- (* 2 pi) snap_e2))) 
                )
                (setq second_pt (polar strtpt snapangle (* (cos ang) dist_e2)))
                (setq dim1_pt    (polar opt3 snapangle (distance opt1 strtpt))
                      dim2_pt    (polar opt4 snapangle (distance opt1 strtpt))
                      balloon_pt (polar opt5 snapangle (distance opt1 strtpt))
                )      
               )
               ((and (> (car opt1) (car opt2)) (< (cadr opt1) (cadr opt2)));2사분면
                (if (< snapangle snap_e1)
                  (setq ang (- snap_e1 snapangle))
                  (setq ang (- snapangle snap_e1))
                )
                (setq strtpt (polar opt2 snapangle (* (cos ang) dist_e1)))
                (if (< snap_e1 snap_e2)
                  (setq ang (- snap_e2 snap_e1))
                  (setq ang (- snap_e1 snap_e2))
                )
                (setq second_pt (polar strtpt snapangle (* (cos ang) dist_e2)))
                (setq dim1_pt    (polar opt3 snapangle (distance opt1 strtpt))
                      dim2_pt    (polar opt4 snapangle (distance opt1 strtpt))
                      balloon_pt (polar opt5 snapangle (distance opt1 strtpt))
                )
               )
               ((and (> (car opt1) (car opt2)) (> (cadr opt1) (cadr opt2)));3사분면
                (if (< snapangle snap_e1)
                  (setq ang (- snap_e1 snapangle))
                  (setq ang (- snapangle snap_e1))
                )
                (setq strtpt (polar opt2 snapangle (* (cos ang) dist_e1)))
                (if (< snap_e1 snap_e2)
                  (setq ang (- snap_e2 snap_e1))
                  (setq ang (- snap_e1 snap_e2))
                )
                (setq second_pt (polar strtpt snapangle (* (cos ang) dist_e2)))
                (setq dim1_pt    (polar opt3 snapangle (distance opt1 strtpt))
                      dim2_pt    (polar opt4 snapangle (distance opt1 strtpt))
                      balloon_pt (polar opt5 snapangle (distance opt1 strtpt))
                )  
               )
               ((and (< (car opt1) (car opt2)) (> (cadr opt1) (cadr opt2)));4사분면
                (if (< (cadr opt2) (cadr pt_e1))
                  (setq ang (- (* 2 pi) (- snapangle snap_e1)))
                  (if (< snapangle snap_e1)
                    (setq ang (- snap_e1 snapangle))
                    (setq ang (- snapangle snap_e1))
                  )
                )
                (setq strtpt (polar opt2 snapangle (* (cos ang) dist_e1)))
                (if (< (cadr pt_e1) (cadr pt_e2))
                  (setq ang (- (* 2 pi) (- snapangle snap_e2)))
                  (if (< snapangle snap_e2)
                    (setq ang (- snap_e2 snapangle))
                    (setq ang (- snapangle snap_e2))
                  )
                )
                (setq second_pt (polar strtpt snapangle (* (cos ang) dist_e2)))
                (setq dim1_pt    (polar opt3 snapangle (distance opt1 strtpt))
                      dim2_pt    (polar opt4 snapangle (distance opt1 strtpt))
                      balloon_pt (polar opt5 snapangle (distance opt1 strtpt))
                )
               )
         )
         ;(setq snapangle (angle strtpt second_pt))
         (setq dist (distance strtpt second_pt))
         (setq ang90  (+ snapangle (dtr 90)))
         (setq ang270 (+ snapangle (dtr 270)))
         
         (setq ;pt1 (list (car strtpt)    (cadr dim1_pt))
               pt2 (polar dim1_pt snapangle dist)
               pt3 (polar balloon_pt snapangle dist); other balloon point
         )
         (cond ((and (< (car dim1_pt) (car dim2_pt)) (< (cadr dim1_pt) (cadr dim2_pt)));1사분면
                (if (< (car strtpt) (car second_pt))
                  (setq pt3_1 (polar balloon_pt ang90  (* mcd:size 2))
                        pt3_2 (polar pt3        ang90  (* mcd:size 2))
                        pt3_3 (polar pt3_1      ang270 (/ mcd:size 2))
                        pt3_4 (polar pt3_2      ang270 (/ mcd:size 2))
                        pt3_l (polar balloon_pt ang90     mcd:size   )
                        pt3_r (polar pt3        ang90     mcd:size   )
                  )
                  (setq pt3_1 (polar balloon_pt ang270 (* mcd:size 2))
                        pt3_2 (polar pt3        ang270 (* mcd:size 2))
                        pt3_3 (polar pt3_1      ang90  (/ mcd:size 2))
                        pt3_4 (polar pt3_2      ang90  (/ mcd:size 2))
                        pt3_l (polar balloon_pt ang270     mcd:size   )
                        pt3_r (polar pt3        ang270     mcd:size   )
                  )
                )
               ) 
               ((and (> (car dim1_pt) (car dim2_pt)) (< (cadr dim1_pt) (cadr dim2_pt)));2사분면
                (if (< (car strtpt) (car second_pt))
                  (setq pt3_1 (polar balloon_pt ang90  (* mcd:size 2))
                        pt3_2 (polar pt3        ang90  (* mcd:size 2))
                        pt3_3 (polar pt3_1      ang270 (/ mcd:size 2))
                        pt3_4 (polar pt3_2      ang270 (/ mcd:size 2))
                        pt3_l (polar balloon_pt ang90     mcd:size   )
                        pt3_r (polar pt3        ang90     mcd:size   )
                  )
                  (setq pt3_1 (polar balloon_pt ang270 (* mcd:size 2))
                        pt3_2 (polar pt3        ang270 (* mcd:size 2))
                        pt3_3 (polar pt3_1      ang90  (/ mcd:size 2))
                        pt3_4 (polar pt3_2      ang90  (/ mcd:size 2))
                        pt3_l (polar balloon_pt ang270     mcd:size   )
                        pt3_r (polar pt3        ang270     mcd:size   )
                  )
                )
               )
               ((and (> (car dim1_pt) (car dim2_pt)) (> (cadr dim1_pt) (cadr dim2_pt)));3사분면
                (if (< (car strtpt) (car second_pt))
                  (setq pt3_1 (polar balloon_pt ang270 (* mcd:size 2))
                        pt3_2 (polar pt3        ang270 (* mcd:size 2))
                        pt3_3 (polar pt3_1      ang90  (/ mcd:size 2))
                        pt3_4 (polar pt3_2      ang90  (/ mcd:size 2))
                        pt3_l (polar balloon_pt ang270     mcd:size   )
                        pt3_r (polar pt3        ang270     mcd:size   )
                  )
                  (setq pt3_1 (polar balloon_pt ang90  (* mcd:size 2))
                        pt3_2 (polar pt3        ang90  (* mcd:size 2))
                        pt3_3 (polar pt3_1      ang270 (/ mcd:size 2))
                        pt3_4 (polar pt3_2      ang270 (/ mcd:size 2))
                        pt3_l (polar balloon_pt ang90     mcd:size   )
                        pt3_r (polar pt3        ang90     mcd:size   )
                  )
                )
               )
               ((and (< (car dim1_pt) (car dim2_pt)) (> (cadr dim1_pt) (cadr dim2_pt)));4사분면
                (if (< (car strtpt) (car second_pt))
                  (setq pt3_1 (polar balloon_pt ang270 (* mcd:size 2))
                        pt3_2 (polar pt3        ang270 (* mcd:size 2))
                        pt3_3 (polar pt3_1      ang90  (/ mcd:size 2))
                        pt3_4 (polar pt3_2      ang90  (/ mcd:size 2))
                        pt3_l (polar balloon_pt ang270     mcd:size   )
                        pt3_r (polar pt3        ang270     mcd:size   )
                  )
                  (setq pt3_1 (polar balloon_pt ang90  (* mcd:size 2))
                        pt3_2 (polar pt3        ang90  (* mcd:size 2))
                        pt3_3 (polar pt3_1      ang270 (/ mcd:size 2))
                        pt3_4 (polar pt3_2      ang270 (/ mcd:size 2))
                        pt3_l (polar balloon_pt ang90     mcd:size   )
                        pt3_r (polar pt3        ang90     mcd:size   )
                  )
                )
               )
         )         
        ) 
  )
  ; draw "dimension"
  (set_col_lin_lay mcd:dprop)
  (if (/= mcd:dir 2)
    (progn (command "_.dimlinear" pt2_ex2 dim1_pt dim2_pt)
           (command "_.dimlinear" dim1_pt pt2 dim2_pt)
    )
    (progn (command "_.dimaligned" pt2_ex2 dim1_pt dim2_pt)
           (command "_.dimaligned" dim1_pt pt2 dim2_pt)
    )  
  )
  
  ; draw "balloon=symbol"
  (set_col_lin_lay mcd:sprop)
  (setq invert 0)
  (cond ((= cur_module 0) ; "비모듈-모듈-비모듈"
         (cond ((= mcd:dir 0) ; 수평이라면...==========================================
                (if (< (cadr dim1_pt) (cadr dim2_pt)) ; y축 증가하면?
                  (setq space_ang -180)
                  (setq space_ang  180
                        invert    (+ invert 1)
                  )
                )
                (if (> (car strtpt) (car second_pt)); user pick right, then left
                  (setq space_ang (* space_ang -1)
                        invert    (+ invert     1)
                  )
                )
                (if (= invert 1) ; 좌우가 바뀌었으면...
                  (cond ((= mcd:position "0")        )
                        ((= mcd:position "1")
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                        ((= mcd:position "2")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                        )
                        ((= mcd:position "3")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                  )
                  (cond ((= mcd:position "0")        )
                        ((= mcd:position "1")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                        )
                        ((= mcd:position "2")
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                        ((= mcd:position "3")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                  )
                )
               )         
                
               ((= mcd:dir 1) ; 수직이라면...===========================================
                (if (< (car dim1_pt) (car dim2_pt)) ; x축 증가하면?
                  (setq space_ang -180)
                  (setq space_ang  180
                        invert    (+ invert 1)
                  )
                )
                (if (< (cadr strtpt) (cadr second_pt)); user pick bottom, then top
                  (setq space_ang (* space_ang -1)
                        invert    (+ invert     1)
                  )
                )
                (if (= invert 1) ; 좌우가 바뀌었으면...
                  (cond ((= mcd:position "0")        )
                        ((= mcd:position "1")
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                        ((= mcd:position "2")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                        )
                        ((= mcd:position "3")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                  )
                  (cond ((= mcd:position "0")        )
                        ((= mcd:position "1")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                        )
                        ((= mcd:position "2")
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                        ((= mcd:position "3")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                  )
                )
               )
               
               ((= mcd:dir 2) ; 기울기라면...===========================================
                (cond ((and (< (car dim1_pt) (car dim2_pt)) (< (cadr dim1_pt) (cadr dim2_pt)));1사분면
                       (if (> (car strtpt) (car second_pt)); user pick right, then left
                         (setq space_ang  180
                               invert    (+ invert 1)
                         )
                         (setq space_ang -180)
                       )
                      )
                      ((and (> (car dim1_pt) (car dim2_pt)) (< (cadr dim1_pt) (cadr dim2_pt)));2사분면
                       (if (> (car strtpt) (car second_pt)); user pick right, then left
                         (setq space_ang  180
                               invert    (+ invert 1)
                         )      
                         (setq space_ang -180)
                       )
                      )
                      ((and (> (car dim1_pt) (car dim2_pt)) (> (cadr dim1_pt) (cadr dim2_pt)));3사분면
                       (if (< (car strtpt) (car second_pt)); user pick right, then left
                         (setq space_ang  180
                               invert    (+ invert 1)
                         )      
                         (setq space_ang -180)
                       )
                      )
                      ((and (< (car dim1_pt) (car dim2_pt)) (> (cadr dim1_pt) (cadr dim2_pt)));4사분면
                       (if (< (car strtpt) (car second_pt)); user pick right, then left
                         (setq space_ang  180
                               invert    (+ invert 1)
                         )
                         (setq space_ang -180)
                       )
                      )
                )
                (if (= invert 1) ; 좌우가 바뀌었으면...
                  (cond ((= mcd:position "0")        )
                        ((= mcd:position "1")
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                        ((= mcd:position "2")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                        )
                        ((= mcd:position "3")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                  )
                  (cond ((= mcd:position "0")        )
                        ((= mcd:position "1")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                        )
                        ((= mcd:position "2")
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                        ((= mcd:position "3")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                  )
                )      
               )
         ) ; end inner cond
        ) ; end "비모듈-모듈-비모듈"
        
        ((= cur_module 1) ; "모듈-비모듈-모듈"
         (cond ((= mcd:dir 0) ; 수평이라면...
                (if (< (cadr dim1_pt) (cadr dim2_pt)) ; y축 증가하면?
                  (setq space_ang  180)
                  (setq space_ang -180
                        invert    (+ invert 1)
                  )
                )
                (if (> (car strtpt) (car second_pt)); user pick right, then left
                  (setq space_ang (* space_ang -1)
                        invert    (+ invert 1)
                  )
                )
                (if (= invert 1) ; 좌우가 바뀌었으면...
                  (cond ((= mcd:position "0")        )
                        ((= mcd:position "1")
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                        ((= mcd:position "2")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                        )
                        ((= mcd:position "3")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                  )
                  (cond ((= mcd:position "0")        )
                        ((= mcd:position "1")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                        )
                        ((= mcd:position "2")
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                        ((= mcd:position "3")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                  )
                )
               )
               ((= mcd:dir 1) ; 수직이라면...
                (if (< (car dim1_pt) (car dim2_pt)) ; x축 증가하면?
                  (setq space_ang  180)
                  (setq space_ang -180
                        invert    (+ invert 1)
                  )
                )
                (if (< (cadr strtpt) (cadr second_pt)); user pick bottom, then top
                  (setq space_ang (* space_ang -1)
                        invert    (+ invert 1)
                  )
                )
                (if (= invert 1) ; 좌우가 바뀌었으면...
                  (cond ((= mcd:position "0")        )
                        ((= mcd:position "1")
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                        ((= mcd:position "2")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                        )
                        ((= mcd:position "3")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                  )
                  (cond ((= mcd:position "0")        )
                        ((= mcd:position "1")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                        )
                        ((= mcd:position "2")
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                        ((= mcd:position "3")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                  )
                )
               )
               ((= mcd:dir 2) ; 기울기라면...
                (cond ((and (< (car dim1_pt) (car dim2_pt)) (< (cadr dim1_pt) (cadr dim2_pt)));1사분면
                       (if (> (car strtpt) (car second_pt)); user pick right, then left
                         (setq space_ang -180
                               invert    (+ invert 1)
                         )
                         (setq space_ang  180)
                       )
                      )
                      ((and (> (car dim1_pt) (car dim2_pt)) (< (cadr dim1_pt) (cadr dim2_pt)));2사분면
                       (if (> (car strtpt) (car second_pt)); user pick right, then left
                         (setq space_ang -180
                               invert    (+ invert 1)
                         )
                         (setq space_ang  180)
                       )
                      )
                      ((and (> (car dim1_pt) (car dim2_pt)) (> (cadr dim1_pt) (cadr dim2_pt)));3사분면
                       (if (< (car strtpt) (car second_pt)); user pick right, then left
                         (setq space_ang -180
                               invert    (+ invert 1)
                         )
                         (setq space_ang  180)
                       )
                      )
                      ((and (< (car dim1_pt) (car dim2_pt)) (> (cadr dim1_pt) (cadr dim2_pt)));4사분면
                       (if (< (car strtpt) (car second_pt)); user pick right, then left
                         (setq space_ang -180
                               invert    (+ invert 1)
                         )
                         (setq space_ang  180)
                       )
                      )
                )
                (if (= invert 1) ; 좌우가 바뀌었으면...
                  (cond ((= mcd:position "0")        )
                        ((= mcd:position "1")
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                        ((= mcd:position "2")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                        )
                        ((= mcd:position "3")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                  )
                  (cond ((= mcd:position "0")        )
                        ((= mcd:position "1")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                        )
                        ((= mcd:position "2")
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                        ((= mcd:position "3")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                  )
                )
               )
         ) ; end inner cond
        ) ; end "모듈-비모듈-모듈"

        ((= cur_module 2) ; "모듈-모듈-모듈"
         (cond ((= mcd:dir 0) ; 수평이라면...
                (if (> (cadr dim1_pt) (cadr dim2_pt)) ; y축 증가하지 않으면?
                  (setq invert (+ invert 1))
                )
                (if (> (car strtpt) (car second_pt)); user pick right, then left
                  (setq invert (+ invert 1))
                )
                (if (= invert 1)
                  (cond ((= mcd:position "0")     )
                        ((= mcd:position "1")
                         (command "_.line" pt3 pt3_r "")
                         (command "_.circle" pt3_4 (/ mcd:size 2)); draw "Right balloon"
                        )
                        ((= mcd:position "2")
                         (command "_.line" balloon_pt pt3_l "")
                         (command "_.circle" pt3_3 (/ mcd:size 2)); draw "Left balloon"
                        )
                        ((= mcd:position "3")
                         (command "_.line" pt3 pt3_r "")
                         (command "_.circle" pt3_4 (/ mcd:size 2)); draw "Right balloon"
                         (command "_.line" balloon_pt pt3_l "")
                         (command "_.circle" pt3_3 (/ mcd:size 2)); draw "Left balloon"
                        )
                  )
                  (cond ((= mcd:position "0")      )
                        ((= mcd:position "1")
                         (command "_.line" balloon_pt pt3_l "")
                         (command "_.circle" pt3_3 (/ mcd:size 2)); draw "Left balloon"
                        )
                        ((= mcd:position "2")
                         (command "_.line" pt3 pt3_r "")
                         (command "_.circle" pt3_4 (/ mcd:size 2)); draw "Right balloon"
                        )
                        ((= mcd:position "3")
                         (command "_.line" balloon_pt pt3_l "")
                         (command "_.circle" pt3_3 (/ mcd:size 2)); draw "Left balloon"
                         (command "_.line" pt3 pt3_r "")
                         (command "_.circle" pt3_4 (/ mcd:size 2)); draw "Right balloon"
                        )
                  )
                )  
               )
               ((= mcd:dir 1) ; 수직이라면...
                (if (> (car dim1_pt) (car dim2_pt)) ; x축 증가하지 않으면?
                  (setq invert (+ invert 1))
                )
                (if (< (cadr strtpt) (cadr second_pt)); user pick bottom, then top
                  (setq invert    (+ invert 1))
                )
                (if (= invert 1)
                  (cond ((= mcd:position "0")     )
                        ((= mcd:position "1")
                         (command "_.line" pt3 pt3_r "")
                         (command "_.circle" pt3_4 (/ mcd:size 2)); draw "Right balloon"
                        )
                        ((= mcd:position "2")
                         (command "_.line" balloon_pt pt3_l "")
                         (command "_.circle" pt3_3 (/ mcd:size 2)); draw "Left balloon"
                        )
                        ((= mcd:position "3")
                         (command "_.line" pt3 pt3_r "")
                         (command "_.circle" pt3_4 (/ mcd:size 2)); draw "Right balloon"
                         (command "_.line" balloon_pt pt3_l "")
                         (command "_.circle" pt3_3 (/ mcd:size 2)); draw "Left balloon"
                        )
                  )
                  (cond ((= mcd:position "0")      )
                        ((= mcd:position "1")
                         (command "_.line" balloon_pt pt3_l "")
                         (command "_.circle" pt3_3 (/ mcd:size 2)); draw "Left balloon"
                        )
                        ((= mcd:position "2")
                         (command "_.line" pt3 pt3_r "")
                         (command "_.circle" pt3_4 (/ mcd:size 2)); draw "Right balloon"
                        )
                        ((= mcd:position "3")
                         (command "_.line" balloon_pt pt3_l "")
                         (command "_.circle" pt3_3 (/ mcd:size 2)); draw "Left balloon"
                         (command "_.line" pt3 pt3_r "")
                         (command "_.circle" pt3_4 (/ mcd:size 2)); draw "Right balloon"
                        )
                  )
                )
               )
               ((= mcd:dir 2) ; 기울기라면...
                (cond ((and (< (car dim1_pt) (car dim2_pt)) (< (cadr dim1_pt) (cadr dim2_pt)));1사분면
                       (if (> (car strtpt) (car second_pt)); user pick right, then left
                         (setq invert (+ invert 1))
                       )
                      )
                      ((and (> (car dim1_pt) (car dim2_pt)) (< (cadr dim1_pt) (cadr dim2_pt)));2사분면
                       (if (> (car strtpt) (car second_pt)); user pick right, then left
                         (setq invert (+ invert 1))
                       )
                      )
                      ((and (> (car dim1_pt) (car dim2_pt)) (> (cadr dim1_pt) (cadr dim2_pt)));3사분면
                       (if (< (car strtpt) (car second_pt)); user pick right, then left
                         (setq invert (+ invert 1))
                       )
                      )
                      ((and (< (car dim1_pt) (car dim2_pt)) (> (cadr dim1_pt) (cadr dim2_pt)));4사분면
                       (if (< (car strtpt) (car second_pt)); user pick right, then left
                         (setq invert (+ invert 1))
                       )
                      )
                )
                (if (= invert 1)
                  (cond ((= mcd:position "0")     )
                        ((= mcd:position "1")
                         (command "_.line" pt3 pt3_r "")
                         (command "_.circle" pt3_4 (/ mcd:size 2)); draw "Right balloon"
                        )
                        ((= mcd:position "2")
                         (command "_.line" balloon_pt pt3_l "")
                         (command "_.circle" pt3_3 (/ mcd:size 2)); draw "Left balloon"
                        )
                        ((= mcd:position "3")
                         (command "_.line" pt3 pt3_r "")
                         (command "_.circle" pt3_4 (/ mcd:size 2)); draw "Right balloon"
                         (command "_.line" balloon_pt pt3_l "")
                         (command "_.circle" pt3_3 (/ mcd:size 2)); draw "Left balloon"
                        )
                  )
                  (cond ((= mcd:position "0")      )
                        ((= mcd:position "1")
                         (command "_.line" balloon_pt pt3_l "")
                         (command "_.circle" pt3_3 (/ mcd:size 2)); draw "Left balloon"
                        )
                        ((= mcd:position "2")
                         (command "_.line" pt3 pt3_r "")
                         (command "_.circle" pt3_4 (/ mcd:size 2)); draw "Right balloon"
                        )
                        ((= mcd:position "3")
                         (command "_.line" balloon_pt pt3_l "")
                         (command "_.circle" pt3_3 (/ mcd:size 2)); draw "Left balloon"
                         (command "_.line" pt3 pt3_r "")
                         (command "_.circle" pt3_4 (/ mcd:size 2)); draw "Right balloon"
                        )
                  )
                )
               )
         ) ; end inner cond
        ) ; end "모듈-모듈-모듈"
        
  ) ; end outer cond
  (setq mcd:size (/ mcd:size sc))
  (setq opt1 strtpt opt2 second_pt opt3 dim1_pt opt4 dim2_pt opt5 balloon_pt)
); end mcd_ex2

;======================================================================================
;======================================================================================
;======================================================================================
;======================================================================================
;======================================================================================

(defun mcd_dd( / cnt dim_num tmplst dsn)
  ; for user press cancel
  (setq old:sprop mcd:sprop
        old:dprop mcd:dprop
  )        
  (setq ok_check nil cancel_check nil dimstyle_list nil)
  (setq tmplst (tblnext "DIMSTYLE" T))
  (while tmplst 
          (setq dsn (cdr (assoc 2 tmplst))
                dimstyle_list (append dimstyle_list (List dsn))
                tmplst (tblnext "DIMSTYLE")
          )
  )              
  (setq dcl_id (ai_dcl "mcd"))
  (if (not (new_dialog "mcd" dcl_id)) (exit))
  (start_list "pop_dim")
  (setq cnt 0 dim_num nil)
  (repeat (length dimstyle_list)
          (add_list (nth cnt dimstyle_list))
          (if (= (getvar "DIMSTYLE") (nth cnt  dimstyle_list))
            (setq dim_num cnt)
          )  
          (setq cnt (+ cnt 1))
  )
  (end_list)
  (set_tile "pop_dim" (itoa dim_num))        
  ;============<<<  2  >>>====================================
  (set_tile mcd_prop_type "1")
  (@get_eval_prop mcd_prop_type mcd:prop)
  ;===========================================================
  (set_tile "pop_position" mcd:position)
  (cond ((= cur_module 0)
         (cond ((= mcd:position "0")(ci_image "img_space" "mcd(0m0)"))
               ((= mcd:position "1")(ci_image "img_space" "mcd(0m0L)"))
               ((= mcd:position "2")(ci_image "img_space" "mcd(0m0R)"))
               ((= mcd:position "3")(ci_image "img_space" "mcd(0m02)"))
         )           
         (set_tile "txt_module" "       비모듈-모듈-비모듈")
         (setq module_cnt 1)
        )
        ((= cur_module 1)
         (cond ((= mcd:position "0")(ci_image "img_space" "mcd(m0m)"))
               ((= mcd:position "1")(ci_image "img_space" "mcd(m0mL)"))
               ((= mcd:position "2")(ci_image "img_space" "mcd(m0mR)"))
               ((= mcd:position "3")(ci_image "img_space" "mcd(m0m2)"))
         )      
         (set_tile "txt_module" "        모듈-비모듈-모듈")
         (setq module_cnt 2)
        )
        ((= cur_module 2)
         (cond ((= mcd:position "0")(ci_image "img_space" "mcd(mmm)"))
               ((= mcd:position "1")(ci_image "img_space" "mcd(mmmL)"))
               ((= mcd:position "2")(ci_image "img_space" "mcd(mmmR)"))
               ((= mcd:position "3")(ci_image "img_space" "mcd(mmm2)"))
         )
         (set_tile "txt_module" "          모듈-모듈-모듈")
         (setq module_cnt 0)
        )
  )
  (cond ((= mcd:dir 0)(set_tile "rd_hor" "1"))
        ((= mcd:dir 1)(set_tile "rd_ver" "1"))
        ((= mcd:dir 2)(set_tile "rd_ali" "1"))
  )        
  
  (set_tile "ed_size" (itoa mcd:size))
  ;====================<<<  3  >>>================================================================
  (action_tile "bn_layer" "(@getlayer)")
  (action_tile "bn_color" "(@getcolor)")
  (action_tile "color_image" "(@getcolor)")
  (action_tile "c_bylayer" "(@bylayer_do T)"); T=color or nil=linetype
  (action_tile "rd_laycol" "(setq mcd_prop_type $value)(@get_eval_prop mcd_prop_type mcd:prop)")
  ;===============================================================================================
  (action_tile "pop_position" "(set_position $value)")
  (action_tile "img_space" "(set_module)")
  (action_tile "accept" "(mcd_ok)")
  (action_tile "cancel" "(press_cancel)")
  (start_dialog)
  (done_dialog)
  (if (= ok_check T)
    (command "_.dimstyle" "r" mcd:dim); dimstyle apply
  )   
)

(defun set_position(value)
  (cond ((= value "0")
         (cond ((= cur_module 0)
                (ci_image "img_space" "mcd(0m0)")
               )
               ((= cur_module 1)
                (ci_image "img_space" "mcd(m0m)")
               )
               ((= cur_module 2)
                (ci_image "img_space" "mcd(mmm)")
               )
         )
        )
        ((= value "1")
         (cond ((= cur_module 0)
                (ci_image "img_space" "mcd(0m0L)")
               )
               ((= cur_module 1)
                (ci_image "img_space" "mcd(m0mL)")
               )
               ((= cur_module 2)
                (ci_image "img_space" "mcd(mmmL)")
               )
         )
        )
        ((= value "2")
         (cond ((= cur_module 0)
                (ci_image "img_space" "mcd(0m0R)")
               )
               ((= cur_module 1)
                (ci_image "img_space" "mcd(m0mR)")
               )
               ((= cur_module 2)
                (ci_image "img_space" "mcd(mmmR)")
               )
         )
        )
        ((= value "3")
         (cond ((= cur_module 0)
                (ci_image "img_space" "mcd(0m02)")
               )
               ((= cur_module 1)
                (ci_image "img_space" "mcd(m0m2)")
               )
               ((= cur_module 2)
                (ci_image "img_space" "mcd(mmm2)")
               )
         )
        ) 
  )                  
) 
(defun set_module()
  (cond ((= (get_tile "pop_position") "0")
         (cond ((= module_cnt 0)
                (ci_image "img_space" "mcd(0m0)")
                (set_tile "txt_module" "       비모듈-모듈-비모듈")
                (setq module_cnt 1)(setq cur_module 0)
               )
               ((= module_cnt 1)
                (ci_image "img_space" "mcd(m0m)")
                (set_tile "txt_module" "        모듈-비모듈-모듈")
                (setq module_cnt 2)(setq cur_module 1)
               )
               ((= module_cnt 2)
                (ci_image "img_space" "mcd(mmm)")
                (set_tile "txt_module" "          모듈-모듈-모듈")
                (setq module_cnt 0)(setq cur_module 2)
               )
         )
        )
        ((= (get_tile "pop_position") "1")
         (cond ((= module_cnt 0)
                (ci_image "img_space" "mcd(0m0L)")
                (set_tile "txt_module" "       비모듈-모듈-비모듈")
                (setq module_cnt 1)(setq cur_module 0)
               )
               ((= module_cnt 1)
                (ci_image "img_space" "mcd(m0mL)")
                (set_tile "txt_module" "        모듈-비모듈-모듈")
                (setq module_cnt 2)(setq cur_module 1)
               )
               ((= module_cnt 2)
                (ci_image "img_space" "mcd(mmmL)")
                (set_tile "txt_module" "          모듈-모듈-모듈")
                (setq module_cnt 0)(setq cur_module 2)
               )
         )
        )
        ((= (get_tile "pop_position") "2")
         (cond ((= module_cnt 0)
                (ci_image "img_space" "mcd(0m0R)")
                (set_tile "txt_module" "       비모듈-모듈-비모듈")
                (setq module_cnt 1)(setq cur_module 0)
               )
               ((= module_cnt 1)
                (ci_image "img_space" "mcd(m0mR)")
                (set_tile "txt_module" "        모듈-비모듈-모듈")
                (setq module_cnt 2)(setq cur_module 1)
               )
               ((= module_cnt 2)
                (ci_image "img_space" "mcd(mmmR)")
                (set_tile "txt_module" "          모듈-모듈-모듈")
                (setq module_cnt 0)(setq cur_module 2)
               )
         )
        )
        ((= (get_tile "pop_position") "3")
         (cond ((= module_cnt 0)
                (ci_image "img_space" "mcd(0m02)")
                (set_tile "txt_module" "       비모듈-모듈-비모듈")
                (setq module_cnt 1)(setq cur_module 0)
               )
               ((= module_cnt 1)
                (ci_image "img_space" "mcd(m0m2)")
                (set_tile "txt_module" "        모듈-비모듈-모듈")
                (setq module_cnt 2)(setq cur_module 1)
               )
               ((= module_cnt 2)
                (ci_image "img_space" "mcd(mmm2)")
                (set_tile "txt_module" "          모듈-모듈-모듈")
                (setq module_cnt 0)(setq cur_module 2)
               )
         )
        ) 
  )                  
)  
(defun press_cancel()
  (setq mcd:sprop old:sprop
        mcd:dprop old:dprop
  )
  (done_dialog)
)  
(defun mcd_ok()
  ;==================<<<  4  >>>====================
  (prop_save mcd:prop)
  ;=================================================
  (if (/= (get_tile "rd_hor") "0")(setq mcd:dir 0))
  (if (/= (get_tile "rd_ver") "0")(setq mcd:dir 1))
  (if (/= (get_tile "rd_ali") "0")(setq mcd:dir 2))
  (setq mcd:size     (atoi (get_tile "ed_size"))
        mcd:position (get_tile "pop_position")
        mcd:dim      (nth (atoi (get_tile "pop_dim")) dimstyle_list)
        ok_check     T
  )
  (done_dialog)        
)


;====================================================================================
;====================================================================================
;=============================     mcd_ex    ========================================
;====================================================================================
;====================================================================================

(defun mcd_ex(/ pt1 pt3 pt3_1 pt3_2 pt3_3 pt3_4 pt3_c pt4 pt5) ;except pt2
  (setvar "osmode" 0)
  (setq mcd:size (* mcd:size sc))
  (cond ((= mcd:dir 0) ;수평이면...
         (setq ;pt1 (list (car strtpt)    (cadr dim1_pt))
               pt2 (list (car second_pt) (cadr dim1_pt))
               pt3 (list (car second_pt) (cadr balloon_pt)); other balloon point
         )      
         (if (< (cadr dim1_pt) (cadr dim2_pt)) ; y축 증가하면?
           (setq pt3_1 (polar balloon_pt (dtr 90)  (* mcd:size 2))
                 pt3_2 (polar pt3        (dtr 90)  (* mcd:size 2))
                 pt3_3 (polar pt3_1      (dtr 270) (/ mcd:size 2))
                 pt3_4 (polar pt3_2      (dtr 270) (/ mcd:size 2))
                 pt3_l (polar balloon_pt (dtr 90)     mcd:size   )
                 pt3_r (polar pt3        (dtr 90)     mcd:size   )
           )
           (setq pt3_1 (polar balloon_pt (dtr 270) (* mcd:size 2))
                 pt3_2 (polar pt3        (dtr 270) (* mcd:size 2))
                 pt3_3 (polar pt3_1      (dtr 90)  (/ mcd:size 2))
                 pt3_4 (polar pt3_2      (dtr 90)  (/ mcd:size 2))
                 pt3_l (polar balloon_pt (dtr 270)     mcd:size   )
                 pt3_r (polar pt3        (dtr 270)     mcd:size   )
           )
         )         
        )
        ((= mcd:dir 1) ;수직이면...
         (setq ;pt1 (list (car dim1_pt) (cadr strtpt)   )
               pt2 (list (car dim1_pt) (cadr second_pt))
               pt3 (list (car balloon_pt) (cadr second_pt)); other balloon point
         )      
         (if (< (car dim1_pt) (car dim2_pt)) ; x축 증가하면?
           (setq pt3_1 (polar balloon_pt (dtr 0)   (* mcd:size 2))
                 pt3_2 (polar pt3        (dtr 0)   (* mcd:size 2))
                 pt3_3 (polar pt3_1      (dtr 180) (/ mcd:size 2)); center of Arc
                 pt3_4 (polar pt3_2      (dtr 180) (/ mcd:size 2)); center of Arc
                 pt3_l (polar balloon_pt (dtr 0)     mcd:size   )
                 pt3_r (polar pt3        (dtr 0)     mcd:size   )
           )
           (setq pt3_1 (polar balloon_pt (dtr 180) (* mcd:size 2))
                 pt3_2 (polar pt3        (dtr 180) (* mcd:size 2))
                 pt3_3 (polar pt3_1      (dtr 0)   (/ mcd:size 2)); center of Arc
                 pt3_4 (polar pt3_2      (dtr 0)   (/ mcd:size 2)); center of Arc
                 pt3_l (polar balloon_pt (dtr 180)     mcd:size   )
                 pt3_r (polar pt3        (dtr 180)     mcd:size   )
           )
         )
        )
        ((= mcd:dir 2) ;기울기라면...
         (setq snapangle (angle strtpt second_pt))
         (setq dist (distance strtpt second_pt))
         (setq ang90  (+ snapangle (dtr 90)))
         (setq ang270 (+ snapangle (dtr 270)))
         
         (setq ;pt1 (list (car strtpt)    (cadr dim1_pt))
               pt2 (polar dim1_pt snapangle dist)
               pt3 (polar balloon_pt snapangle dist); other balloon point
         )
         (cond ((and (< (car dim1_pt) (car dim2_pt)) (< (cadr dim1_pt) (cadr dim2_pt)));1사분면
                (if (< (car strtpt) (car second_pt))
                  (setq pt3_1 (polar balloon_pt ang90  (* mcd:size 2))
                        pt3_2 (polar pt3        ang90  (* mcd:size 2))
                        pt3_3 (polar pt3_1      ang270 (/ mcd:size 2))
                        pt3_4 (polar pt3_2      ang270 (/ mcd:size 2))
                        pt3_l (polar balloon_pt ang90     mcd:size   )
                        pt3_r (polar pt3        ang90     mcd:size   )
                  )
                  (setq pt3_1 (polar balloon_pt ang270 (* mcd:size 2))
                        pt3_2 (polar pt3        ang270 (* mcd:size 2))
                        pt3_3 (polar pt3_1      ang90  (/ mcd:size 2))
                        pt3_4 (polar pt3_2      ang90  (/ mcd:size 2))
                        pt3_l (polar balloon_pt ang270     mcd:size   )
                        pt3_r (polar pt3        ang270     mcd:size   )
                  )
                )
               ) 
               ((and (> (car dim1_pt) (car dim2_pt)) (< (cadr dim1_pt) (cadr dim2_pt)));2사분면
                (if (< (car strtpt) (car second_pt))
                  (setq pt3_1 (polar balloon_pt ang90  (* mcd:size 2))
                        pt3_2 (polar pt3        ang90  (* mcd:size 2))
                        pt3_3 (polar pt3_1      ang270 (/ mcd:size 2))
                        pt3_4 (polar pt3_2      ang270 (/ mcd:size 2))
                        pt3_l (polar balloon_pt ang90     mcd:size   )
                        pt3_r (polar pt3        ang90     mcd:size   )
                  )
                  (setq pt3_1 (polar balloon_pt ang270 (* mcd:size 2))
                        pt3_2 (polar pt3        ang270 (* mcd:size 2))
                        pt3_3 (polar pt3_1      ang90  (/ mcd:size 2))
                        pt3_4 (polar pt3_2      ang90  (/ mcd:size 2))
                        pt3_l (polar balloon_pt ang270     mcd:size   )
                        pt3_r (polar pt3        ang270     mcd:size   )
                  )
                )
               )
               ((and (> (car dim1_pt) (car dim2_pt)) (> (cadr dim1_pt) (cadr dim2_pt)));3사분면
                (if (< (car strtpt) (car second_pt))
                  (setq pt3_1 (polar balloon_pt ang270 (* mcd:size 2))
                        pt3_2 (polar pt3        ang270 (* mcd:size 2))
                        pt3_3 (polar pt3_1      ang90  (/ mcd:size 2))
                        pt3_4 (polar pt3_2      ang90  (/ mcd:size 2))
                        pt3_l (polar balloon_pt ang270     mcd:size   )
                        pt3_r (polar pt3        ang270     mcd:size   )
                  )
                  (setq pt3_1 (polar balloon_pt ang90  (* mcd:size 2))
                        pt3_2 (polar pt3        ang90  (* mcd:size 2))
                        pt3_3 (polar pt3_1      ang270 (/ mcd:size 2))
                        pt3_4 (polar pt3_2      ang270 (/ mcd:size 2))
                        pt3_l (polar balloon_pt ang90     mcd:size   )
                        pt3_r (polar pt3        ang90     mcd:size   )
                  )
                )
               )
               ((and (< (car dim1_pt) (car dim2_pt)) (> (cadr dim1_pt) (cadr dim2_pt)));4사분면
                (if (< (car strtpt) (car second_pt))
                  (setq pt3_1 (polar balloon_pt ang270 (* mcd:size 2))
                        pt3_2 (polar pt3        ang270 (* mcd:size 2))
                        pt3_3 (polar pt3_1      ang90  (/ mcd:size 2))
                        pt3_4 (polar pt3_2      ang90  (/ mcd:size 2))
                        pt3_l (polar balloon_pt ang270     mcd:size   )
                        pt3_r (polar pt3        ang270     mcd:size   )
                  )
                  (setq pt3_1 (polar balloon_pt ang90  (* mcd:size 2))
                        pt3_2 (polar pt3        ang90  (* mcd:size 2))
                        pt3_3 (polar pt3_1      ang270 (/ mcd:size 2))
                        pt3_4 (polar pt3_2      ang270 (/ mcd:size 2))
                        pt3_l (polar balloon_pt ang90     mcd:size   )
                        pt3_r (polar pt3        ang90     mcd:size   )
                  )
                )
               )
         )         
        ) 
  )
  ; draw "dimension"
  (set_col_lin_lay mcd:dprop)
  (setvar "DIMASSOC" 1)
  (if (/= mcd:dir 2)
    (command "_.dimlinear" dim1_pt pt2 dim2_pt)
    (command "_.dimaligned" dim1_pt pt2 dim2_pt)
  )
  
  ; draw "balloon=symbol"
  (set_col_lin_lay mcd:sprop)
  (setq invert 0)
  (cond ((= cur_module 0) ; "비모듈-모듈-비모듈"
         (cond ((= mcd:dir 0) ; 수평이라면...==========================================
                (if (< (cadr dim1_pt) (cadr dim2_pt)) ; y축 증가하면?
                  (setq space_ang -180)
                  (setq space_ang  180
                        invert    (+ invert 1)
                  )
                )
                (if (> (car strtpt) (car second_pt)); user pick right, then left
                  (setq space_ang (* space_ang -1)
                        invert    (+ invert     1)
                  )
                )
                (if (= invert 1) ; 좌우가 바뀌었으면...
                  (cond ((= mcd:position "0")        )
                        ((= mcd:position "1")
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                        ((= mcd:position "2")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                        )
                        ((= mcd:position "3")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                  )
                  (cond ((= mcd:position "0")        )
                        ((= mcd:position "1")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                        )
                        ((= mcd:position "2")
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                        ((= mcd:position "3")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                  )
                )
               )         
                
               ((= mcd:dir 1) ; 수직이라면...===========================================
                (if (< (car dim1_pt) (car dim2_pt)) ; x축 증가하면?
                  (setq space_ang -180)
                  (setq space_ang  180
                        invert    (+ invert 1)
                  )
                )
                (if (< (cadr strtpt) (cadr second_pt)); user pick bottom, then top
                  (setq space_ang (* space_ang -1)
                        invert    (+ invert     1)
                  )
                )
                (if (= invert 1) ; 좌우가 바뀌었으면...
                  (cond ((= mcd:position "0")        )
                        ((= mcd:position "1")
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                        ((= mcd:position "2")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                        )
                        ((= mcd:position "3")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                  )
                  (cond ((= mcd:position "0")        )
                        ((= mcd:position "1")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                        )
                        ((= mcd:position "2")
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                        ((= mcd:position "3")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                  )
                )
               )
               
               ((= mcd:dir 2) ; 기울기라면...===========================================
                (cond ((and (< (car dim1_pt) (car dim2_pt)) (< (cadr dim1_pt) (cadr dim2_pt)));1사분면
                       (if (> (car strtpt) (car second_pt)); user pick right, then left
                         (setq space_ang  180
                               invert    (+ invert 1)
                         )
                         (setq space_ang -180)
                       )
                      )
                      ((and (> (car dim1_pt) (car dim2_pt)) (< (cadr dim1_pt) (cadr dim2_pt)));2사분면
                       (if (> (car strtpt) (car second_pt)); user pick right, then left
                         (setq space_ang  180
                               invert    (+ invert 1)
                         )      
                         (setq space_ang -180)
                       )
                      )
                      ((and (> (car dim1_pt) (car dim2_pt)) (> (cadr dim1_pt) (cadr dim2_pt)));3사분면
                       (if (< (car strtpt) (car second_pt)); user pick right, then left
                         (setq space_ang  180
                               invert    (+ invert 1)
                         )      
                         (setq space_ang -180)
                       )
                      )
                      ((and (< (car dim1_pt) (car dim2_pt)) (> (cadr dim1_pt) (cadr dim2_pt)));4사분면
                       (if (< (car strtpt) (car second_pt)); user pick right, then left
                         (setq space_ang  180
                               invert    (+ invert 1)
                         )
                         (setq space_ang -180)
                       )
                      )
                )
                (if (= invert 1) ; 좌우가 바뀌었으면...
                  (cond ((= mcd:position "0")        )
                        ((= mcd:position "1")
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                        ((= mcd:position "2")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                        )
                        ((= mcd:position "3")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                  )
                  (cond ((= mcd:position "0")        )
                        ((= mcd:position "1")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                        )
                        ((= mcd:position "2")
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                        ((= mcd:position "3")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                  )
                )      
               )
         ) ; end inner cond
        ) ; end "비모듈-모듈-비모듈"
        
        ((= cur_module 1) ; "모듈-비모듈-모듈"
         (cond ((= mcd:dir 0) ; 수평이라면...
                (if (< (cadr dim1_pt) (cadr dim2_pt)) ; y축 증가하면?
                  (setq space_ang  180)
                  (setq space_ang -180
                        invert    (+ invert 1)
                  )
                )
                (if (> (car strtpt) (car second_pt)); user pick right, then left
                  (setq space_ang (* space_ang -1)
                        invert    (+ invert 1)
                  )
                )
                (if (= invert 1) ; 좌우가 바뀌었으면...
                  (cond ((= mcd:position "0")        )
                        ((= mcd:position "1")
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                        ((= mcd:position "2")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                        )
                        ((= mcd:position "3")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                  )
                  (cond ((= mcd:position "0")        )
                        ((= mcd:position "1")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                        )
                        ((= mcd:position "2")
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                        ((= mcd:position "3")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                  )
                )
               )
               ((= mcd:dir 1) ; 수직이라면...
                (if (< (car dim1_pt) (car dim2_pt)) ; x축 증가하면?
                  (setq space_ang  180)
                  (setq space_ang -180
                        invert    (+ invert 1)
                  )
                )
                (if (< (cadr strtpt) (cadr second_pt)); user pick bottom, then top
                  (setq space_ang (* space_ang -1)
                        invert    (+ invert 1)
                  )
                )
                (if (= invert 1) ; 좌우가 바뀌었으면...
                  (cond ((= mcd:position "0")        )
                        ((= mcd:position "1")
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                        ((= mcd:position "2")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                        )
                        ((= mcd:position "3")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                  )
                  (cond ((= mcd:position "0")        )
                        ((= mcd:position "1")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                        )
                        ((= mcd:position "2")
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                        ((= mcd:position "3")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                  )
                )
               )
               ((= mcd:dir 2) ; 기울기라면...
                (cond ((and (< (car dim1_pt) (car dim2_pt)) (< (cadr dim1_pt) (cadr dim2_pt)));1사분면
                       (if (> (car strtpt) (car second_pt)); user pick right, then left
                         (setq space_ang -180
                               invert    (+ invert 1)
                         )
                         (setq space_ang  180)
                       )
                      )
                      ((and (> (car dim1_pt) (car dim2_pt)) (< (cadr dim1_pt) (cadr dim2_pt)));2사분면
                       (if (> (car strtpt) (car second_pt)); user pick right, then left
                         (setq space_ang -180
                               invert    (+ invert 1)
                         )
                         (setq space_ang  180)
                       )
                      )
                      ((and (> (car dim1_pt) (car dim2_pt)) (> (cadr dim1_pt) (cadr dim2_pt)));3사분면
                       (if (< (car strtpt) (car second_pt)); user pick right, then left
                         (setq space_ang -180
                               invert    (+ invert 1)
                         )
                         (setq space_ang  180)
                       )
                      )
                      ((and (< (car dim1_pt) (car dim2_pt)) (> (cadr dim1_pt) (cadr dim2_pt)));4사분면
                       (if (< (car strtpt) (car second_pt)); user pick right, then left
                         (setq space_ang -180
                               invert    (+ invert 1)
                         )
                         (setq space_ang  180)
                       )
                      )
                )
                (if (= invert 1) ; 좌우가 바뀌었으면...
                  (cond ((= mcd:position "0")        )
                        ((= mcd:position "1")
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                        ((= mcd:position "2")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                        )
                        ((= mcd:position "3")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                  )
                  (cond ((= mcd:position "0")        )
                        ((= mcd:position "1")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                        )
                        ((= mcd:position "2")
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                        ((= mcd:position "3")
                         (command "_.pline" balloon_pt pt3_1 "A" "CE" pt3_3 "A" space_ang ""); draw "Left balloon"
                         (command "_.pline" pt3        pt3_2 "A" "CE" pt3_4 "A" (* space_ang -1) ""); draw "Right balloon"
                        )
                  )
                )
               )
         ) ; end inner cond
        ) ; end "모듈-비모듈-모듈"

        ((= cur_module 2) ; "모듈-모듈-모듈"
         (cond ((= mcd:dir 0) ; 수평이라면...
                (if (> (cadr dim1_pt) (cadr dim2_pt)) ; y축 증가하지 않으면?
                  (setq invert (+ invert 1))
                )
                (if (> (car strtpt) (car second_pt)); user pick right, then left
                  (setq invert (+ invert 1))
                )
                (if (= invert 1)
                  (cond ((= mcd:position "0")     )
                        ((= mcd:position "1")
                         (command "_.line" pt3 pt3_r "")
                         (command "_.circle" pt3_4 (/ mcd:size 2)); draw "Right balloon"
                        )
                        ((= mcd:position "2")
                         (command "_.line" balloon_pt pt3_l "")
                         (command "_.circle" pt3_3 (/ mcd:size 2)); draw "Left balloon"
                        )
                        ((= mcd:position "3")
                         (command "_.line" pt3 pt3_r "")
                         (command "_.circle" pt3_4 (/ mcd:size 2)); draw "Right balloon"
                         (command "_.line" balloon_pt pt3_l "")
                         (command "_.circle" pt3_3 (/ mcd:size 2)); draw "Left balloon"
                        )
                  )
                  (cond ((= mcd:position "0")      )
                        ((= mcd:position "1")
                         (command "_.line" balloon_pt pt3_l "")
                         (command "_.circle" pt3_3 (/ mcd:size 2)); draw "Left balloon"
                        )
                        ((= mcd:position "2")
                         (command "_.line" pt3 pt3_r "")
                         (command "_.circle" pt3_4 (/ mcd:size 2)); draw "Right balloon"
                        )
                        ((= mcd:position "3")
                         (command "_.line" balloon_pt pt3_l "")
                         (command "_.circle" pt3_3 (/ mcd:size 2)); draw "Left balloon"
                         (command "_.line" pt3 pt3_r "")
                         (command "_.circle" pt3_4 (/ mcd:size 2)); draw "Right balloon"
                        )
                  )
                )  
               )
               ((= mcd:dir 1) ; 수직이라면...
                (if (> (car dim1_pt) (car dim2_pt)) ; x축 증가하지 않으면?
                  (setq invert (+ invert 1))
                )
                (if (< (cadr strtpt) (cadr second_pt)); user pick bottom, then top
                  (setq invert    (+ invert 1))
                )
                (if (= invert 1)
                  (cond ((= mcd:position "0")     )
                        ((= mcd:position "1")
                         (command "_.line" pt3 pt3_r "")
                         (command "_.circle" pt3_4 (/ mcd:size 2)); draw "Right balloon"
                        )
                        ((= mcd:position "2")
                         (command "_.line" balloon_pt pt3_l "")
                         (command "_.circle" pt3_3 (/ mcd:size 2)); draw "Left balloon"
                        )
                        ((= mcd:position "3")
                         (command "_.line" pt3 pt3_r "")
                         (command "_.circle" pt3_4 (/ mcd:size 2)); draw "Right balloon"
                         (command "_.line" balloon_pt pt3_l "")
                         (command "_.circle" pt3_3 (/ mcd:size 2)); draw "Left balloon"
                        )
                  )
                  (cond ((= mcd:position "0")      )
                        ((= mcd:position "1")
                         (command "_.line" balloon_pt pt3_l "")
                         (command "_.circle" pt3_3 (/ mcd:size 2)); draw "Left balloon"
                        )
                        ((= mcd:position "2")
                         (command "_.line" pt3 pt3_r "")
                         (command "_.circle" pt3_4 (/ mcd:size 2)); draw "Right balloon"
                        )
                        ((= mcd:position "3")
                         (command "_.line" balloon_pt pt3_l "")
                         (command "_.circle" pt3_3 (/ mcd:size 2)); draw "Left balloon"
                         (command "_.line" pt3 pt3_r "")
                         (command "_.circle" pt3_4 (/ mcd:size 2)); draw "Right balloon"
                        )
                  )
                )
               )
               ((= mcd:dir 2) ; 기울기라면...
                (cond ((and (< (car dim1_pt) (car dim2_pt)) (< (cadr dim1_pt) (cadr dim2_pt)));1사분면
                       (if (> (car strtpt) (car second_pt)); user pick right, then left
                         (setq invert (+ invert 1))
                       )
                      )
                      ((and (> (car dim1_pt) (car dim2_pt)) (< (cadr dim1_pt) (cadr dim2_pt)));2사분면
                       (if (> (car strtpt) (car second_pt)); user pick right, then left
                         (setq invert (+ invert 1))
                       )
                      )
                      ((and (> (car dim1_pt) (car dim2_pt)) (> (cadr dim1_pt) (cadr dim2_pt)));3사분면
                       (if (< (car strtpt) (car second_pt)); user pick right, then left
                         (setq invert (+ invert 1))
                       )
                      )
                      ((and (< (car dim1_pt) (car dim2_pt)) (> (cadr dim1_pt) (cadr dim2_pt)));4사분면
                       (if (< (car strtpt) (car second_pt)); user pick right, then left
                         (setq invert (+ invert 1))
                       )
                      )
                )
                (if (= invert 1)
                  (cond ((= mcd:position "0")     )
                        ((= mcd:position "1")
                         (command "_.line" pt3 pt3_r "")
                         (command "_.circle" pt3_4 (/ mcd:size 2)); draw "Right balloon"
                        )
                        ((= mcd:position "2")
                         (command "_.line" balloon_pt pt3_l "")
                         (command "_.circle" pt3_3 (/ mcd:size 2)); draw "Left balloon"
                        )
                        ((= mcd:position "3")
                         (command "_.line" pt3 pt3_r "")
                         (command "_.circle" pt3_4 (/ mcd:size 2)); draw "Right balloon"
                         (command "_.line" balloon_pt pt3_l "")
                         (command "_.circle" pt3_3 (/ mcd:size 2)); draw "Left balloon"
                        )
                  )
                  (cond ((= mcd:position "0")      )
                        ((= mcd:position "1")
                         (command "_.line" balloon_pt pt3_l "")
                         (command "_.circle" pt3_3 (/ mcd:size 2)); draw "Left balloon"
                        )
                        ((= mcd:position "2")
                         (command "_.line" pt3 pt3_r "")
                         (command "_.circle" pt3_4 (/ mcd:size 2)); draw "Right balloon"
                        )
                        ((= mcd:position "3")
                         (command "_.line" balloon_pt pt3_l "")
                         (command "_.circle" pt3_3 (/ mcd:size 2)); draw "Left balloon"
                         (command "_.line" pt3 pt3_r "")
                         (command "_.circle" pt3_4 (/ mcd:size 2)); draw "Right balloon"
                        )
                  )
                )
               )
         ) ; end inner cond
        ) ; end "모듈-모듈-모듈"
        
  ) ; end outer cond
  (setq mcd:size (/ mcd:size sc))
); end mcd_ex

;=========================<<< 1 >>>====================================
(readF "PropType.dat" "prop")  
(setq mcd:sprop  (Prop_search "mcd" "symbol"))
(setq mcd:dprop  (Prop_search "mcd" "dimension"))
(setq mcd:prop '(mcd:sprop mcd:dprop))

(if (null mcd_prop_type) (setq mcd_prop_type "rd_symbol"))
;======================================================================

(defun c:CIMMCD() (m:mcd))
(princ)
              

