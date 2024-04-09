;2001.08.11
;작업자 : 김병용
;; 창문 그리기
;; cimWIN

;단축키 관련 변수 정의 부분.. 맨뒤..


(defun winTypeDlg(/ dr_list dr_key drn dr_mode)
    (if (not (new_dialog "set_window_type" dcl_id)) (exit))
    (setq dr_list '("a" "b" "c" "d" "e" "f" ))
    (foreach drn dr_list
      (setq dr_key (strcat "ib_win_" drn))
      (wn_DrawImage dr_key drn )
 
    )
    (setq dr_mode (strcat "ib_win_" (strcase wn:type)))
    (mode_tile dr_mode 4)

    (foreach drn dr_list
      (action_tile (strcat "ib_win_" drn)
        "(mode_tile dr_mode 4)(setq dr_mode $key)(mode_tile dr_mode 4)"
      )
    )

    (if (= (start_dialog) 1) ; User pressed OK
      (if (/= wn:type (strcase (substr dr_mode 8) T ))
        (progn
          (setq wn:type (substr dr_mode 8))
	  (wn_DrawImage "ib_win_type" (substr dr_mode 8))
        )
      )
    )
  )

(defun wn_DrawImage (wn_key !wntype! / wng wnf wnm)
  (setq wng (propcolor wnn:gprop))
  (setq wnf (propcolor wnn:fprop))
  (setq wnm (propcolor wnn:mprop))
    
    (do_blank wn_key 0)
    (start_image wn_key)	  
	   (cond
	     ((= !wntype! "a") (wn_image_a))
	     ((= !wntype! "b") (wn_image_b))
	     ((= !wntype! "c") (wn_image_c))
	     ((= !wntype! "d") (wn_image_d))
	     ((= !wntype! "e") (wn_image_e))
	     ((= !wntype! "f") (wn_image_f))
	   )
    (end_image)
)


(defun wn_image_a (/ cx cy dx dy x1 x2 x3 x4 x5 x6 x7 x8 x9
		  	           y1 y2 y3 y4 y5 y6 y7 y8 y9 y10)

    (setq cx (dimx_tile wn_key)
	  cy (dimy_tile wn_key)
	  dx (/ cx 20)
	  dy (/ cy 20)
	  x1 (* dx 1) x2 (* dx 2) x3 (* dx 4) x4 (* dx 9) x5 (* dx 10) 	
	  x6 (* dx 11) x7 (* dx 16) x8 (* dx 18) x9 (* dx 19)	 
	  y1 (* dy 2) y2 (* dy 5) y3 (* dy 6) y4 (* dy 7) y5 (* dy 8) 
	  y6 (* dy 9) y7 (* dy 10) y8 (* dy 11) y9 (* dy 16) y10 (* dy 18) 
    )

	(vector_image x5 y1 x5 y10 wnm)
	(if (= wn1:typ "simple") (progn
		(vector_image x1 y4 x6 y4 wng)
		(vector_image x4 y6 x9 y6 wng))
            (progn	
		(drawImage_box x1 y2 dx (* dy 6)  wnf)
		(drawImage_box x8 y2 dx (* dy 6)  wnf)
		(vector_image x2 y2 x8 y2 wnm)
		(vector_image x2  y8  x8  y8  wnm)
		(drawImage_box x2  y3  (* dx 2) (* dy 2)  wnf)
		(drawImage_box x4  y3  (* dx 2) (* dy 4)  wnf)
		(vector_image x4  y5  x6  y5  wnf)
		(drawImage_box x7  y5  (* dx 2) (* dy 2)  wnf)
		(vector_image x3  y4  x4  y4  wng)
		(vector_image x6  y6  x7  y6  wng)
		(if (= stool_chk "1") (progn
			(drawImage_box x1  y8  dx (* dy 5)  wnf)
			(drawImage_box x8  y8  dx (* dy 5)  wnf)
			(vector_image x2  y9  x8  y9  wnm)
		)))
	)
)

(defun wn_image_b (/ cx cy dx dy x1 x2 x3 x4 x5 x6 x7 x8 x9
		  	           y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13 y14 y15)

    (setq cx (dimx_tile wn_key)
	  cy (dimy_tile wn_key)
	  dx (/ cx 20)
	  dy (/ cy 20)
	  x1 (* dx 1) x2 (* dx 2) x3 (* dx 4) x4 (* dx 9) x5 (* dx 10) 	
	  x6 (* dx 11) x7 (* dx 16) x8 (* dx 18) x9 (* dx 19)	 
	  y1 (* dy 2) y2 (* dy 4) y3 (* dy 5) y4 (* dy 6) y5 (* dy 7) 
	  y6 (* dy 8) y7 (* dy 9) y8 (* dy 10) y9 (* dy 11) y10 (* dy 12) 
	  y11 (* dy 13) y12 (* dy 14) y13 (* dy 15) y14 (* dy 16) y15 (* dy 18) 
    )

	(vector_image x5 y1 x5 y15 wnm)
	(if (= wn1:typ "simple") (progn
		(vector_image x1 y4 x6 y4 wng)
		(vector_image x4 y6 x9 y6 wng)
		(vector_image x1 y10 x6 y10 wng)
		(vector_image x4 y12 x9 y12 wng))
            (progn	
 		(drawImage_box x1 y2 dx (* dy 12) wnf)
		(vector_image x1 y8  x2 y8  wnf)
		(drawImage_box x8 y2 dx (* dy 12) wnf)
		(vector_image x8 y8  x9 y8  wnf)

		(vector_image x2 y2  x8 y2  wnm)
		(vector_image x2 y8  x8 y8  wnm)
		(vector_image x2 y14 x8 y14 wnm)

		(drawImage_box x2 y3 (* dx 2) (* dy 2) wnf)
		(drawImage_box x4 y3 (* dx 2) (* dy 4) wnf)
		(vector_image x4 y5 x6 y5 wnf)
		(drawImage_box x7 y5 (* dx 2) (* dy 2) wnf)
		(vector_image x3 y4 x4 y4 wng)
		(vector_image x6 y6 x7 y6 wng)

		(drawImage_box x2 y9 (* dx 2) (* dy 2) wnf)
		(drawImage_box x4 y9 (* dx 2) (* dy 4) wnf)
		(vector_image x4 y11 x6 y11 wnf)
		(drawImage_box x7 y11 (* dx 2) (* dy 2) wnf)
		(vector_image x3 y10 x4 y10 wng)
		(vector_image x6 y12 x7 y12 wng))
	)
)



(defun wn_image_c (/ cx cy dx dy x1 x2 x3 x4 x5 x6
		  	           y1 y2 y3 y4 )

    (setq cx (dimx_tile wn_key)
	  cy (dimy_tile wn_key)
	  dx (/ cx 40)
	  dy (/ cy 10)
	  x1 (* dx 2) x2 (* dx 4) x3 (* dx 19) x4 (* dx 21) x5 (* dx 36) x6 (* dx 38) 
	  y1 (* dy 4) y2 (* dy 5) y3 (* dy 6) y4 (* dy 8)  
    )

      (if (= wn1:typ "simple")
		(vector_image x1 y2 x6 y2 wng)
	 (progn
		(drawImage_box x1 y1 (* dx 2) (* dy 2) wnf)
		(drawImage_box x3 y1 (* dx 2) (* dy 2) wnf)
		(drawImage_box x5 y1 (* dx 2) (* dy 2) wnf)
		(vector_image x2 y1 x3 y1 wnm)
		(vector_image x2 y3 x3 y3 wnm)
		(vector_image x4 y1 x5 y1 wnm)
		(vector_image x4 y3 x5 y3 wnm)
		(vector_image x2 y2 x3 y2 wng)
		(vector_image x4 y2 x5 y2 wng)
		(if (= stool_chk "1") (progn
			(drawImage_box x1 y3 (* dx 2) (* dy 2) wnf)
			(drawImage_box x5 y3 (* dx 2) (* dy 2) wnf)
			(vector_image x2 y4 x5 y4 wnm))
		))
	)
)

(defun wn_image_d (/ cx cy dx dy x1 x2 x3 x4 x5 x6 x7 x8 x9 
		  	           y1 y2 y3 y4 y5 y6 y7 y8 y9 y10)

    (setq cx (dimx_tile wn_key)
	  cy (dimy_tile wn_key)
	  dx (/ cx 20)
	  dy (/ cy 20)
	  x1 (* dx 1) x2 (* dx 2) x3 (* dx 4) x4 (* dx 7) x5 (* dx 8) 	
	  x6 (* dx 9) x7 (* dx 16) x8 (* dx 18) x9 (* dx 19)	 
	  y1 (* dy 2) y2 (* dy 6) y3 (* dy 7) y4 (* dy 8) y5 (* dy 9) 
	  y6 (* dy 10) y7 (* dy 11) y8 (* dy 12) y9 (* dy 16) y10 (* dy 18) 
    )

	(vector_image x5 y1 x5 y10 wnm)
	 (if (= wn1:typ "simple")(progn
		(vector_image x1 y4 x6 y4 wng)
		(vector_image x4 y6 x9 y6 wng))
	(progn
		(drawImage_box x1 y2 dx (* dy 6) wnf)
		(drawImage_box x8 y2 dx (* dy 6) wnf)
		(vector_image x2 y2 x8 y2 wnm)
		(vector_image x2 y8 x8 y8 wnm)
		(drawImage_box x2 y5 (* dx 2) (* dy 2) wnf)
		(drawImage_box x4 y3 (* dx 2) (* dy 4) wnf)
		(vector_image x4 y5 x6 y5 wnf)
		(drawImage_box x7 y3 (* dx 2) (* dy 2) wnf)
		(vector_image x3 y6 x4 y6 wng)
		(vector_image x6 y4 x7 y4 wng)
		(if (= stool_chk "1") (progn
			(drawImage_box x1 y8 dx (* dy 4) wnf)
			(drawImage_box x8 y8 dx (* dy 4) wnf)
			(vector_image x2 y9 x8 y9 wnm)))
	))
)

(defun wn_image_e (/ cx cy dx dy x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12
		  	           y1 y2 y3 y4 y5 y6 y7 y8 y9 y10)

    (setq cx (dimx_tile wn_key)
	  cy (dimy_tile wn_key)
	  dx (/ cx 40)
	  dy (/ cy 20)
	  x1 (* dx 2) x2 (* dx 4) x3 (* dx 6) x4 (* dx 11) x5 (* dx 12) 	
	  x6 (* dx 13) x7 (* dx 27) x8 (* dx 28) x9 (* dx 29) x10 (* dx 34) x11 (* dx 36) x12 (* dx 38)			 
	  y1 (* dy 2) y2 (* dy 6) y3 (* dy 7) y4 (* dy 8) y5 (* dy 9) 
	  y6 (* dy 10) y7 (* dy 11) y8 (* dy 12) y9 (* dy 16) y10 (* dy 18) 
    )

	(vector_image x5 y1 x5 y10 wnm)
	(vector_image x8 y1 x8 y10 wnm)
	 (if (= wn1:typ "simple")(progn
		(vector_image x1 y6 x6  y6 wng)
		(vector_image x4 y4 x9  y4 wng)
		(vector_image x7 y6 x12 y6 wng))
	(progn
		(drawImage_box x1 y2 (* dx 2) (* dy 6) wnf)
		(drawImage_box x11 y2 (* dx 2) (* dy 6) wnf)
		(vector_image x2  y2 x11 y2 wnm)
		(vector_image x2  y8 x11 y8 wnm)
		(drawImage_box x2 y5 (* dx 2) (* dy 2) wnf)
		(drawImage_box x4 y3 (* dx 2) (* dy 4) wnf)
		(vector_image x4 y5 x6 y5 wnf)
		(drawImage_box x7 y3 (* dx 2) (* dy 4) wnf)
		(vector_image x7 y5 x9 y5 wnf)
		(drawImage_box x10 y5 (* dx 2) (* dy 2) wnf)
		(vector_image x3  y6 x4  y6 wng)
		(vector_image x6  y4 x7  y4 wng)
		(vector_image x9  y6 x10 y6 wng)
		(if (= stool_chk "1") (progn
			(drawImage_box x1 y8 (* dx 2) (* dy 4) wnf)
			(drawImage_box x11 y8 (* dx 2) (* dy 4) wnf)
			(vector_image x2  y9 x11 y9 wnm))
		))
	)
)

(defun wn_image_f (/ cx cy dx dy x1 x2 x3 x4 x5 x6 
		  	           y1 y2 y3 y4 y5)

    (setq cx (dimx_tile wn_key)
	  cy (dimy_tile wn_key)
	  dx (/ cx 40)
	  dy (/ cy 10)
	  x1 (* dx 2) x2 (* dx 10) x3 (* dx 11) x4 (* dx 29) x5 (* dx 30) 	
	  x6 (* dx 38) 	 
	  y1 (* dy 4) y2 (* dy 6) y3 (* dy 5) y4 (fix (* dy 4.5)) y5 (fix (* dy 5.5))
    )


	(vector_image x1 y1 x2 y1 wnf)
	;(vector_image x2 y1 x2 y2 2)
	(vector_image x2 y2 x1 y2 wnf)
	(vector_image x6 y1 x5 y1 wnf)
	;(vector_image x5 y1 x5 y2 5)
	(vector_image x5 y2 x6 y2 wnf)
  	
	 (progn
		(drawImage_box x2 y1 dx (* dy 2) wnf)
		(drawImage_box x4 y1 dx (* dy 2) wnf)
		(vector_image x3 y1 x4 y1 wnm)
		(vector_image x3 y2 x4 y2 wnm)
	 )
  	(if (= wn1:typ "detail")
	  (progn
	  (vector_image x3 y3 x4 y3 wng)
	  (vector_image x3 y4 x4 y4 wnf)
	  (vector_image x3 y5 x4 y5 wnf)
	  )
	 )
)

(defun m:wn2 (/
             pt1      pt2      pt3      cont     temp     tem      uctr
             d1       d2       sc       pt4      ang      ang1     ang3
             ang4     ss       ls       no	sc
             
               wn2_ang  wn2_oor )
  (if win_@Type (setq @Type win_@Type) (setq win_@Type @Type))
  (setq wn2_oor (getvar "orthomode")
        sc     (getvar "dimscale")
  )
 
  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")

  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n창문을 그리는 명령입니다.")

  (setq cont T uctr 0 temp T)

  (while cont
    (wn2_m1)
;;;    (if strtpt
;;;      (wang)
;;;    )
    (wn2_m2)
    (wn2_m3)
  )


  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ)
)

(defun wn2_m1 ()
  (while temp
    (setvar "blipmode" 1)
    (setvar "osmode" (+ 512 32))
    (if (> uctr 0)
      (progn
        (initget "~ / Dialog Offset Undo")
        (if (= wn1:typ "Detail")
          (setq strtpt (getpoint
            "\n>>> Dialog/Offset/Undo/<start point>: NEAREST to "))
          (setq strtpt (getpoint
            "\n>>> Dialog/Offset/<start point>: NEAREST to "))
        )
      )
      (progn
        (initget "~ / Dialog Offset")
        (if (= wn1:typ "Detail")
          (setq strtpt (getpoint
            "\n>>> Dialog/Offset/<start point>: NEAREST to "))
          (setq strtpt (getpoint
            "\n>>> Dialog/Offset/<start point>: NEAREST to "))
        )
      )
    )
    (setvar "osmode" 0)
    (cond

      ((= strtpt "Offset")
        (cim_ofs)
      )
      ((= strtpt "Undo")
        (command "_.undo" "_B")
        (setq uctr (1- uctr))
      )
      ((= strtpt "Dialog")
        (dd_wn2)
      )
      ((= strtpt "/")
        (princ "\t>>> Please waite -- help_dialog loading...")
        (cim_help "WN2")
      )
      ((null strtpt)
          (setq cont nil temp nil)
      )
      (T
        (if (= (ssget strtpt) nil)
          (alert "Wall entity not selected -- Try again.")
          (setq temp nil tem T)
        )
      )
    )
  )
)

(defun wn2_m2 ()
  (while tem
    (initget "~ / Dialog Undo ")
    (setvar "blipmode" 1)
    (setvar "osmode" (+ 512 32))
    (if (= wn1:typ "Detail")
      (setq nextpt (getpoint strtpt
            "\n    Dialog/Undo/<second point>: NEAREST to "))
      (setq nextpt (getpoint strtpt
            "\n    Dialog/Undo/<second point>: NEAREST to "))
    )
    (setvar "blipmode" 0)
    (setvar "osmode" 0)
    (cond
      ((= nextpt "Undo")
        (setq tem nil temp T)
      )

      ((= nextpt "Dialog")
        (dd_wn2)
      )
      ((= nextpt "/")
        (princ "\t>>> Please waite -- help_dialog loading...")
        (cim_help "WN2")
      )
      ((null nextpt)
        (setq cont nil tem nil)
      )
      (T
        (if (= (ssget nextpt) nil) 
          (alert "Wall entity not selected -- Try again.")
          (if (equal strtpt nextpt 200)
            (alert "Coincident point -- Try again.")
            (setq tem nil pt3 T)
          )
        )
      )
    )
  )
)

(defun wn2_m3 (/ wn1:wf1 wn1:wf2 d1wf1 d1wf2 frw  frt p   p1  p2 )
  (while pt3
    (initget "~ / Dialog Undo ")
    (setvar "blipmode" 1)
    (setvar "osmode" 128)
    (setvar "orthomode" 0)
    (if (= wn1:typ "Detail")
      (setq pt3 (getpoint strtpt
            "\n    Dialog/Undo/<other side of the wall>: PERPEND to "))
      (setq pt3 (getpoint strtpt
            "\n    Dialog/Undo/<other side of the wall>: PERPEND to "))
    )
    (setvar "blipmode" 0)
    (setvar "osmode" 0)
    (setvar "orthomode" WN2_OOR)
    (cond
      ((= pt3 "Undo")
        (setq pt3 nil tem T)
      )

      ((= pt3 "Dialog")
        (dd_wn2)
      )
      ((= pt3 "/")
        (princ "\t>>> Please waite -- help_dialog loading...")
        (cim_help "WN2")
      )
      ((= (type pt3) 'LIST)
        (if (= (ssget pt3) nil) 
          (alert "Wall entity not selected -- Try again.")
          (if (= (inters strtpt nextpt nextpt pt3 nil) nil)
            (alert "Other side of the wall not selected -- Try again.")
            (progn
              (command "_.undo" "_M")
	      (autonextpt_win)
	            
              (wn2_ex)                           ;; 벽자르기
              (if (= wn1:typ "simple")
                (sdProc)                         ;; simple
              ;;  (if (= wn2:sof "OFF")            ;; detail
              ;;    (wn2_dd)         
                  (wn2_dds)                      ;; + stool
              ;;  )
              )
              (command "_.color" wn1:col)                 ;;;;;
              (command "_.layer" "_S" wn1:lay "")
              (setq pt3 nil temp T)
              (setq uctr (1+ uctr))
              (princ " \n")
            )
          )
        )
      )
      (T
        (setq pt3 nil cont nil)
      )
    )
  )
)

(defun autonextpt_win (/ sign tmp_ang)
  (setq sign (if (> (setq tmp_ang (- (angle strtpt nextpt) (angle strtpt pt3))) 0) 1 -1))
  (if (= opn_chk "1")
  (setq nextpt (polar strtpt
			(+ (angle strtpt pt3)
			   (if (< (abs tmp_ang) pi) (* pi 0.5 sign)(* pi 1.5 sign))) wn2:ops))
  )
)
(defun wn2_ex (/ k e delss tmppt hidden_line)
			   
  ;(if (and (/= wn1:wal  "wall_4")(/= wn1:typ "simple"))(wall_point)) ;;;(/= wn2:sof "OFF")
  (wall_point)
  (setq pt1 strtpt
        pt2 nextpt
        ang (angle pt1 pt2)
        d2  (distance pt1 pt3)
        d1  (distance pt1 pt2)
        pt4 (polar pt3 ang d1)
  )
  (setq ang1 (angle pt3 pt1)
        ang3 (angle pt1 pt3)
        ang4 (angle pt2 pt1)
        p1c (polar pt1 ang3 (/ d2 2))
  )
  (setq p2c (polar pt2 ang3 (/ d2 2)))
  (if (= off_chk "1") (setq p1c (polar p1c ang1 wn2:ofs))
		      (setq p2c (polar p2c ang3 wn2:ofs)))
  
  (Get_finwid)  ;; cutting finish & extend
  
  (setq ss (ssget "C" pt2 pt4
             '((-4 . "<OR") (0 . "LINE") (0 . "*POLYLINE") (-4 . "OR>"))))
  
  (RMV)
  ;(if (and (= ls 4) (or (= wn1:wal "wall_1"))
  ;  (progn
      (setq k 0)
      (repeat (sslength ss)
        (setq e (entget (ssname ss k)))
        (if (wcmatch (fld_st 0 e) "*POLYLINE")
          (command "_.explode" (ssname ss k))
        )
        (setq k (1+ k))
      )
  ;  )
  ;)

	  
  (setq ss (ssget "C" (polar pt2 (- ang (dtr 180)) (/ (distance pt1 pt2) 2))
		  (polar pt4 (- ang (dtr 180)) (/ (distance pt1 pt2) 2)) 
             '((-4 . "<OR") (0 . "LINE") (0 . "POLYLINE") (-4 . "OR>"))))

  (RMV)
  (setq e (entget (ssname ss 0)))
  (if (or (= wn1:wal "wall_3") (= wn1:wal "wall_4"))
    (brk_s)
    (if (= ls 4)  ;;(= d1:wtyp "Cavity");;;
      (brkl wn1:wal)
      (brk_s)
    )
  )

  (set_col_lin_lay wnn:mprop)
  (command "_.line" (nth 0 hidden_line) (nth 1 hidden_line) "")
  (if (> (length hidden_line) 2)
	  (command "_.line" (nth 2 hidden_line ) ;(/ (length hidden_line) 2)
		   	    (nth 3 hidden_line ) "") ;(1+ (/ (length hidden_line) 2))
  )
)

(defun sdProc(/ pt5 factor dn)           ;;; Simple Win
  
;;;  (set_col_lin_lay wnn:mprop)
;;;  (command "_.line" pt1 pt2 "")
;;;  (command "_.line" pt3 pt4 "")
  
  (set_col_lin_lay wnn:gprop)
  (setq dn  (/ d1 wn2:num) 
        pt5 (polar p1c ang1 25)
        pt7 (polar p1c ang dn))
  (cond
    ((= wn:type "c")
     (command "_.line" p1c p2c ""))
    ((= wn:type "a")
     (setq factor 50)      
     (wn2_sd))
    ((= wn:type "b")
      (setq factor 25) 
      (setq pt5 (polar p1c ang1 37.5))
      (wn2_sd))
    ((= wn:type "d")
      (setq pt5 (polar p1c ang3 25)           
            pt7 (polar p1c ang wn4:opn1)
	    pt7 (polar pt7 ang3 (+ (/ d2 2) (* sc 5)))
            pt6 (polar pt5 ang (+ wn4:opn1 25)))
	  (command "_.line" pt5 pt6 "")
	  
          (set_col_lin_lay cen:cprop)
	  (command "_.line" (setq p (polar pt7 ang1 (* sc 3)))
	                  (setq p (polar p ang1 (+ d2 (* sc 4)))) "")
	  (setq pt5 (polar pt6 ang4 50))
	  (setq pt5 (polar pt5 ang1 50))
          (set_col_lin_lay wnn:gprop)
	  (command "_.line" pt5 (polar p2c ang1 25) "")
    )
   ((= wn:type "e")
       (setq pt5 (polar p1c ang3 25)           
            pt7 (polar p1c ang wn4:opn1)
	    pt7 (polar pt7 ang3 (+ (/ d2 2) (* sc 5)))
            pt6 (polar pt5 ang (+ wn4:opn1 25)))
	  
	  (command "_.line" pt5 pt6 "")
	  (setq pt5 (polar pt6 ang4 50)
	        pt5 (polar pt5 ang1 50)
	        pt6 (polar p2c ang4 (- wn4:opn2 25))
	        pt6 (polar pt6 ang1 25)
	  )
	  (command "_.line" pt5 pt6 "")
	  (setq pt5 (polar pt6 ang4 50)
	        pt5 (polar pt5 ang3 50)
	        pt6 (polar p2c ang3 25)
	  )
	  (command "_.line" pt5 pt6 "")
	  
          (set_col_lin_lay cen:cprop)
	  (command "_.line" (setq p (polar pt7 ang1 (* sc 3)))
	                  (setq p (polar p ang1 (+ d2 (* sc 4)))) "")
	  (setq pt7 (polar p2c ang4 wn4:opn2)
	        pt7 (polar pt7 ang3 (+ (/ d2 2) (* sc 5)))
	  )
	  (command "_.line" (setq p (polar pt7 ang1 (* sc 3)))
	                  (setq p (polar p ang1 (+ d2 (* sc 4)))) "")
	  
    ))
)


(defun wn2_sd (/ k  pt6 )
  (setq pt7 (polar pt7 ang3 (+ (/ d2 2) (* sc 5))))

  (setq k 0)
  
  (if (= (rem wn2:num 2) 1)
    (progn
      (repeat (1- wn2:num)
        (setq k (1+ k))
        (if (= k 1)
          (setq pt6 (polar pt5 ang (+ dn 25)))
          (setq pt6 (polar pt5 ang (+ dn 50)))
        )
	(set_col_lin_lay wnn:gprop)
        (command "_.line" pt5 pt6 "")

	(cond ((= wn:type "b")
	              (command "_.line" (setq p (polar pt5 ang3 50))
	              (polar p ang (distance pt5 pt6)) "")
	              
	       )
	)
	(set_col_lin_lay cen:cprop)
        (command "_.line" (setq p (polar pt7 ang1 (* sc 3)))
                        (setq p (polar p ang1 (+ d2 (* sc 4)))) "")
        (setq pt5 (polar pt6 ang4 50))
        (if (= (rem k 2) 1)
          (setq pt5 (polar pt5 ang3 factor));;
          (setq pt5 (polar pt5 ang1 factor));;
        )
        (setq pt7 (polar pt7 ang dn))
      );;; end repeat
      (setq pt6 (polar pt5 ang (+ dn 25)));;
      
      (set_col_lin_lay wnn:gprop)
      (command "_.line" pt5 pt6 "")

      (cond ((= wn:type "b")
          (command "_.line" (setq p (polar pt5 ang3 50))
          (polar p ang (distance pt5 pt6)) ""))
     )
    )
    (progn
      (setq angz ang3)
      (repeat (1- wn2:num)
        (setq k (1+ k))
        (setq pt6 (polar pt5 ang (+ dn 25)))
        (command "_.line" pt5 pt6 "")
(cond ((= wn:type "b")
      (command "_.line" (setq p (polar pt5 ang3 50))
                       (polar p ang (distance pt5 pt6)) "")
       ))
	(set_col_lin_lay cen:cprop)
        (command "_.line" (setq p (polar pt7 ang1 (* sc 3)))
                        (setq p (polar p ang1 (+ d2 (* sc 4)))) "")
        (if (= (rem k 2) 0)
          (setq pt5 pt6)
          (setq pt5  (polar pt6 ang4 50)
                pt5  (polar pt5 ang3 factor)
                angz (+ angz (dtr 180))
          )
        )
        (setq pt7 (polar pt7 ang dn))
      )
      (setq pt6 (polar pt5 ang (+ dn 25)))
      (set_col_lin_lay wnn:gprop)
      (command "_.line" pt5 pt6 "")
(cond ((= wn:type "b")
       (command "_.line" (setq p (polar pt5 ang3 50))
                      (polar p ang (distance pt5 pt6)) ""))
)
    )
  )
)



(defun Cut_fin ( pass1 flag  / ppp1 ppp2 tmpang1 tmpang3 wn1:ww1)   ;마감선 자르고 정리
  (setq tmpang1 (if (= flag T) ang1 ang3))
  (setq tmpang3 (if (= flag T) ang3 ang1))
  (setq wn1:ww1 (distance p pass1))

  (if (or (= wn1:typ "simple") (= wn1:wal "wall_4"))
    (setq ppp1 (if (= flag T) (polar pt1 ang1 wn1:ww1) (polar pt3 ang3 wn1:ww1))
	  ppp2 (polar ppp1 ang d1)
    )
    (progn
	  (if (<= wn1:ww1 30)
	     (setq d1wf1 30)
	     (setq d1wf1 (if (> wn1:ww1 55) 55 wn1:ww1))
	  )
	  (setq ppp1 (if (= flag T) (polar pt1 ang d1wf1) (polar pt3 ang d1wf1))
	        ppp1 (polar ppp1 tmpang1 wn1:ww1)
	        ppp2 (polar ppp1 ang (- d1 (* d1wf1 2)))
	  )
     )
   )

  (if (or (and (null flag) (= stool_chk "1"))
	  (and (null flag)(= wn:type "b") (> wn2:fww (/ d2 2)))) ; is stool ON?
    (progn
     (setq ppp1 (polar pt3 ang window_gap)
	   ppp2 (polar ppp1 ang (- d1 (* 2 window_gap))))
     (command "_.break" (ssname ss no) ppp1 ppp2)
    )
    (progn
        (command "_.break" (ssname ss no) ppp1 ppp2)                                    ;;마감선 커팅1
        (command "_.color" (if (fld_st 62 e) (fld_st 62 e) "bylayer"))
        (command "_.linetype" "_S" (if (fld_st 6 e) (fld_st 6 e) "bylayer") "")
        (command "_.layer" "_S" (fld_st 8 e) "")
	  (if (or (= wn1:typ "simple")(= wn1:wal "wall_4"))
	    (progn 
	      (command "_.line" ppp1 (polar ppp1 tmpang3 wn1:ww1) "")
	      (command "_.line" ppp2 (polar ppp2 tmpang3 wn1:ww1) "")
	    )
	    (progn	       
	        (command "_.line"
	              ppp1 (polar ppp1 tmpang3 (- (+ wn1:ww1 (/ d2 2))
						  (if (/= wn:type "b") (/ wn2:frw 2.0)
						     (if (= flag T) (+ wn2:faw 5) wn2:fww)) (if (= off_chk "1") (* wn2:ofs (if (= flag T) 1 -1)) 0) )) "")       ;;마감연장선1
	        (command "_.line"
	              ppp2 (polar ppp2 tmpang3 (- (+ wn1:ww1 (/ d2 2)) (if (/= wn:type "b")
									 (/ wn2:frw 2.0) (if (= flag T) (+ wn2:faw 5) wn2:fww)
									 )(if (= off_chk "1") (* wn2:ofs (if (= flag T) 1 -1)) 0))) "")
	    )
	   )
       (setq hidden_line (append (list ppp1 ppp2) hidden_line))
    )
  );end if  _is stool_on?
)

(defun Get_finwid(/ factor p)                                   ;;; 마감선 구하고.. 자르는 부분 콜
  (if (> d1:wft 60)
    (setq aa d1:wft)
    (setq aa 60)
  )
  (setq factor (/ (distance strtpt pt3) 8))
  (if (= wn2:fra "Aluminum")
    (setq wn2:frw wn2:faw frt 50)
    (setq wn2:frw wn2:fww frt 80)
  )
  (if (setq ss (wall_select_rect (setq p (polar pt1 ang (/ d1 2))) factor))
    (progn
      (RMV)
	(if (> ls 1)
	  (progn
	    (if (< (setq wn1:wf1 (distance p (setq p1 (perpoint p (entget (ssname ss 0)))))) 0.01)
	      (setq wn1:wf1 (distance p (setq p1 (perpoint p (entget (ssname ss 1))))))
	    )
	  )
	 )
     )
  )
  (if (= wn1:wf1 nil)
    (progn
     (setq wn1:wf1 0)
     (setq hidden_line (append (list pt1 pt2) hidden_line))
    )
    (repeat ls
        (setq no (1+ no))
	(if (= (cdr (assoc 8 (entget (ssname ss no)))) (nth 2 (Prop_search "wall" "finish")))
	  (progn
	    (setq e (entget (ssname ss no)))
	    (Cut_fin p1 T)
	  )
	)
    )
    
  )
  

  (if (setq ss (wall_select_rect (setq p (polar pt3 ang (/ d1 2))) factor))
    (progn
      (RMV)
	(if (> ls 1)
	  (progn
	    (if (< (setq wn1:wf2 (distance p (setq p2 (perpoint p (entget (ssname ss 0)))))) 0.01)
	      (setq wn1:wf2 (distance p (setq p2 (perpoint p (entget (ssname ss 1))))))
	    )
	  )
	 )
     )
  )

	  (if (= wn1:wf2 nil)
	    (progn
	      (setq wn1:wf2 0)
	      (if (= stool_chk "0")
	      	(setq hidden_line (append (list pt3 pt4) hidden_line))
	      )
	     )
	    (repeat ls
        	(setq no (1+ no))
		(if (= (cdr (assoc 8 (entget (ssname ss no)))) (nth 2 (Prop_search "wall" "finish")))
		  (progn
	    		(setq e (entget (ssname ss no)))
	  		(Cut_fin p2 nil)
		  )
		)
    	    )
	  )
)

(defun wn2_dds (/  p3  p4    angz p5  p6 p7 p9 p10
                  pt5 pt6 pt7 pt8 pt9 pt10 pt11 pt12 pv7 dk
                  pk5 pk6 pk7 pk8 pk9 pk10 pk11 pk12 dn  tmpn
		)
 
 
 (cond ((= wn:type "a") (Wintype_a))
       ((= wn:type "c") (Wintype_c))
       ((= wn:type "f") (setq tmpn wn2:num wn2:num 1) (Wintype_c) (setq wn2:num tmpn))
       ((= wn:type "b") (Wintype_b))
       ((= wn:type "d") (Wintype_d))
       ((= wn:type "e") (Wintype_e))
 )
;;;; stool option ON
 (if (/= wn:type "b")
 	(Draw_stool)
 )

)
(defun Draw_stool( / ppp)
 
 (if (/= stool_chk "0")
  (progn
   (if (= wn:type "d") (setq pt7 (polar pt8 (+ ang (dtr 180)) 40)) )
   (setq pt6  (polar pt7  ang3 5)
         pt5  (polar pt6  ang  40)
         pt7  (polar pt3  ang  window_gap)
         pt7  (polar pt7  ang3 (+ wn1:wf2 12))
         pt8  (polar pt7  ang  40)
  )

 (set_col_lin_lay wnn:fprop)
 
  (command "_.pline" pt5 pt6 pt7 pt8 "_C")
  (ssget "L")
  (command "_.mirror" "_P" "" (polar pt1 ang (/ d1 2))
                          (polar pt3 ang (/ d1 2)) "")
  (command "_.line" pt5 (polar pt5 ang (- d1 (* 2 (+ window_gap 40)))) "")
  (command "_.line" pt8 (polar pt8 ang (- d1 (* 2 (+ window_gap 40)))) "")
  ))
 )
(defun Draw_frame1 (flag / temang1 temang3)
  (setq temang1 (if (= flag T) ang1 ang3))
  (setq temang3 (if (= flag T) ang3 ang1))
  (if (/= wn:type "b")
    (progn
	   (setq pt5  (polar p1c ang  window_gap)      
	         pt6  (polar pt5 temang1 (/ wn2:frw 2.0))
	   )
	   (setq  dn  (/ (- d1 (if (= wn2:fra "Aluminum")
		                      (* 2 (+ window_gap 55))
		                      (* 2 (+ window_gap 70))
	                       )
	              	  )wn2:num))
     )
  )
   
  (setq pt5  (polar pt6  ang  40)
        pt7  (polar pt6  temang3 wn2:frw)
        pt8  (polar pt7  ang  40)
        pt9  (polar pt8  temang1 (/ wn2:frw 2.0))
        pt10 (polar pt9  ang4 20)
        pt11 (polar pt10 temang1 (if (= wn2:fra "Aluminum")
                                	(/ wn2:frw 2.0)
                                	(- (/ wn2:frw 2.0) 10)
                                 )
             )
        pt12 (polar pt11 ang 20)
  )
  (setq p5  (polar pt9 ang4 10)
        p5  (polar p5  temang1 2)
        pv7 (polar p1c ang (+ (if (= wn2:fra "Aluminum")
                                (+ window_gap 55)
                                (+ window_gap 70)
                              ) dn))
        pv7 (polar pv7 temang3 (+ (/ d2 2) (* sc 5)))
        frw (if (= wn2:fra "Aluminum")
              (- (/ wn2:frw 2.0) 4)
              (- (/ wn2:frw 2.0) 14)
            )
  )

  (set_col_lin_lay wnn:fprop)
  (if (= wn2:fra "Aluminum")
    (command "_.pline" pt5 pt6 pt7 pt8 pt9 pt10 pt11 "")
    (command "_.pline" pt5 pt6 pt7 pt8 pt9 pt10 pt11 pt12 "_C")
  ) 
)
(defun DrawF_box(flag distn / tmpang1 tmpang3)

  (setq tmpang1 (if flag ang1 ang3))
  (setq tmpang3 (if flag ang3 ang1))
  
        (setq p6  (polar p5  tmpang1 frw)
              p7  (polar p6  ang  frt)
              p8  (polar p7  tmpang3 frw)
              p9  (polar p7  tmpang3 ;(if (= wn2:fra "Aluminum")
                                     ; (/ (- frw 12) 2)
                                      (/ frw 2)
                                     ; )
                  )
              p10 (polar p9  tmpang3 12)
        )

        (set_col_lin_lay wnn:fprop)
        (command "_.pline" p5 p6 p7 p8 "_C")
        (command "_.pline" (setq p5 (polar p5 ang distn))
                         (setq p  (polar p5 tmpang1 frw))
                         (setq p  (polar p  ang  frt))
                         (setq p  (polar p  tmpang3 frw))
                         "_C")

        (set_col_lin_lay wnn:gprop)
        (command "_.line" p9  (polar p9  ang (- distn frt)) "")
  (if (or (= wn:type "d")(= wn:type "e"))(progn
  (setq pv7 (polar p5 ang (/ frt 2) )
        pv7 (polar pv7 tmpang3 (+ (/ d2 2) (* sc 5))))))
  (set_col_lin_lay wnn:fprop)
   ;;     (if (= wn2:fra "Aluminum")
   ;;       (command "_.line" p10 (polar p10 ang (- distn frt)) "")
   ;;     )
  ;;      (command "_.color" co_til)                                  ;;  too detail
       (command "_.line" p7  (polar p7  ang (- distn frt)) "")
        (command "_.line" p8  (polar p8  ang (- distn frt)) "")

      
)
(defun Wintype_e(/ )
  (draw_frame1 nil)
  (ssget "L")
  (if (= wn2:fra "Aluminum") (DrawF_box nil (- wn4:opn1 (+ window_gap 55)))
                            (DrawF_box nil (- wn4:opn1 (+ window_gap 70))))
 ;;중심선
  (set_col_lin_lay cen:cprop)
  
  (command "_.line" (setq p (polar pv7 ang3 (* sc 3)))
                  (setq p (polar p ang3 (+ d2 (* sc 4)))) "")
   
 ;;
  
  (setq p5 (polar p5 ang1 (+ 4 frw)))
  (if (= wn2:fra "Aluminum") (DrawF_box nil (- d1  wn4:opn1 wn4:opn2)) ;(+ (* 2 window_gap) 50 )
			    (DrawF_box nil (- d1  wn4:opn1 wn4:opn2))) ;(+ (* 2 window_gap) 65 )
  (set_col_lin_lay cen:cprop)
  (setq pv7 (polar pv7 ang3 (+ 4 frw))) 
  (command "_.line" (setq p (polar pv7 ang3 (* sc 3)))
                  (setq p (polar p ang3 (+ d2 (* sc 4)))) "")
    
 (setq p5 (polar p5 ang3 (+ 4 frw)))
 (if (= wn2:fra "Aluminum") (DrawF_box nil (- wn4:opn2 (+ window_gap 55)))
                            (DrawF_box nil (- wn4:opn2 (+ window_gap 70))))
 (command "_.mirror" "_P" "" (polar pt1 ang (/ d1 2))
                               (polar pt3 ang (/ d1 2)) "")
 
 ;(set_col_lin_lay wnn:fprop) 
 (command "_.line" pt5  (polar pt5  ang (- d1 (* 2 (+  window_gap 40)) )) "")
 (command "_.line" pt8  (polar pt8  ang (- d1 (* 2 (+  window_gap 40)) )) "")
 (setq pt7 pt6)
)




(defun Wintype_b (/  tmppp k tmpwid)
  
  (setq pt5  (polar p1c ang window_gap)
        pt6  (polar pt5 ang1 (+ wn2:faw 5))
        dn  (/ (- d1 (* 2 (+ 55 window_gap))) wn2:num)
  )

  (setq tmppp wn2:fra)
  (setq wn2:fra "Aluminum")
  (setq frt 50 wn2:frw wn2:faw)
  (Draw_frame1 T)
    
  (ssget "L")
  (setq k 0)
  (if (= (rem wn2:num 2) 1)
    (progn
      (repeat (1- wn2:num)
        (setq k (1+ k))

	(DrawF_box T dn)

        (set_col_lin_lay cen:cprop)
        (command "_.line" (setq p (polar pv7 ang1 (* sc 3)))
                  (setq p (polar p ang1 (+ d2 (* sc 4)))) "")

        (if (= (rem k 2) 1)
          (setq p5 (polar p5 ang3 (+ frw 4)))
          (setq p5 (polar p5 ang1 (+ frw 4)))
        )
        (setq pv7 (polar pv7 ang dn))
      )

      (DrawF_box T dn)

      (command "_.mirror" "_P" "" (polar pt1 ang (/ d1 2))
                               (polar pt3 ang (/ d1 2)) "")
      ;(set_col_lin_lay wnn:fprop)
      (command "_.line" pt5 (polar pt5 ang (- d1 (* 2 (+ window_gap 40)))) "")
      (command "_.line" pt8 (polar pt8 ang (- d1 (* 2 (+ window_gap 40)))) "")
    )
    (progn
      (setq angz ang3)
      (repeat (1- wn2:num)
        (setq k (1+ k))
        (if (= k 1)
          (setq dk dn)
          (setq dk (- dn (/ frt 2)))
        )

	(DrawF_box T dk)

	(set_col_lin_lay cen:cprop)
        (command "_.line" (setq p (polar pv7 ang1 (* sc 3)))
                  (setq p (polar p ang1 (+ d2 (* sc 4)))) "")
        (if (= (rem k 2) 0)
          (setq p5   (polar p5 ang 50))
          (setq p5   (polar p5 angz (+ frw 4))
                angz (+ angz (dtr 180))
          )
        )
        (setq pv7 (polar pv7 ang dn))
      )

      (DrawF_box T dn)

      (if (= (rem wn2:num 4) 0)
        (command "_.mirror" "_P" "" (polar pt1 ang (/ d1 2))
                                 (polar pt3 ang (/ d1 2)) "")
        (progn

	(command "_.mirror" "_P" "" (polar pt1 ang (/ d1 2))
                                 (polar pt3 ang (/ d1 2)) "")
	(command "_.mirror" "_l" "" pt9 pt10 "y")
        )
      )
      ;(set_col_lin_lay wnn:fprop)
      (command "_.line" pt5 (polar pt5 ang (- d1 (* 2 (+ window_gap 40)))) "")
      (command "_.line" pt8 (polar pt8 ang (- d1 (* 2 (+ window_gap 40)))) "")
    )
  )

  ;;wood
  (setq wn2:fra "Wood")
  (setq frt 80)
  (if (/= stool_chk "0")  
    (setq tmpwid (+ (/ d2 2) wn1:wf2 12))
    (setq tmpwid wn2:fww))
  (setq wn2:frw tmpwid)

  (setq pt6  (polar p1c ang window_gap)
        dn  (/ (- d1 (* 2 (+ window_gap 70))) wn2:num)
  )
  (Draw_frame1 T)

  (ssget "L")
  (setq k 0)
  (if (= (rem wn2:num 2) 1)
    (progn
      (repeat (1- wn2:num)
        (setq k (1+ k))
	(DrawF_box T dn)


        (if (= (rem k 2) 1)
          (setq p5 (polar p5 ang3 (/(- tmpwid 20) 2)))
          (setq p5 (polar p5 ang1 (/(- tmpwid 20) 2)))
        )
      )
      (DrawF_box T dn)


      (command "_.mirror" "_P" "" (polar pt1 ang (/ d1 2))
                               (polar pt3 ang (/ d1 2)) "")
      ;(set_col_lin_lay wnn:fprop)
      (command "_.line" pt5 (polar pt5 ang (- d1 (* 2 (+ window_gap 40)))) "")
      (command "_.line" pt8 (polar pt8 ang (- d1 (* 2 (+ window_gap 40)))) "")
    )
    (progn
      (setq angz ang3)
      (repeat (1- wn2:num)
        (setq k (1+ k))
        (if (= k 1)
          (setq dk dn)
          (setq dk (- dn (/ frt 2.0)))
        )
	(DrawF_box T dk)

        (if (= (rem k 2) 0)
          (setq p5   (polar p5 ang (- tmpwid 20)))
          (setq p5   (polar p5 angz (/ (- tmpwid 20) 2))
                angz (+ angz (dtr 180))
          )
        )
      )
      (DrawF_box T dn)

      (if (= (rem wn2:num 4) 0)
        (command "_.mirror" "_P" "" (polar pt1 ang (/ d1 2))
                                 (polar pt3 ang (/ d1 2)) "")
        (progn
  	(command "_.mirror" "_P" "" (polar pt1 ang (/ d1 2))
                                 (polar pt3 ang (/ d1 2)) "")
	(command "_.mirror" "_l" "" pt9 pt10 "y")
        )
      )
      ;(set_col_lin_lay wnn:fprop)
      (command "_.line" pt5 (polar pt5 ang (- d1 (* 2 (+ window_gap 40)))) "")
      (command "_.line" pt8 (polar pt8 ang (- d1 (* 2 (+ window_gap 40)))) "")
    )
  )
  (setq wn2:fra tmppp)
  (setq wn2:frw wn2:fww)
  )

(defun Wintype_d()
  (draw_frame1 nil)
  ;;(ssget "L")

  (if (= wn2:fra "Aluminum") (DrawF_box nil (- wn4:opn1 (+ window_gap 55)))
                            (DrawF_box nil (- wn4:opn1 (+ window_gap 70))))

  
  (set_col_lin_lay cen:cprop)
  (command "_.line" (setq p (polar pv7 ang3 (* sc 3)))
                  (setq p (polar p ang3 (+ d2 (* sc 4)))) "")
  

  (setq p5 (polar p5 ang1 (+ 4 frw)))

  (if (= wn2:fra "Aluminum") (DrawF_box nil (- d1 (+ (* 2 window_gap) 50 ) wn4:opn1 ))
			    (DrawF_box nil (- d1 (+ (* 2 window_gap) 65 ) wn4:opn1 )))
  
  ;(set_col_lin_lay wnn:fprop)
  (command "_.line" pt5  (polar pt5  ang (- d1 (* 2 (+  window_gap 40)) )) "")
  (command "_.line" pt8  (polar pt8  ang (- d1 (* 2 (+  window_gap 40)) )) "")
  
  (progn
   ;(command "_.copy" "_P" "" '(0 0 0) '(0 0 0) "")
   ;(command "_.rotate" "_p" "" (polar (polar pt1 ang3 (/ (distance pt3 pt1) 2)) ang (/ d1 2)) "180" "")
   (Draw_frame1 T )
   (ssget "_L")
   (command "_.mirror" "_P" "" (polar pt1 ang (/ d1 2))
                                 (polar pt3 ang (/ d1 2)) "_Y")
  )
  (setq pt7 pt6 )
        										       

)


(defun Wintype_c(/ tmpn tmppt)
  
  ;;(if (/= wn1:wal "wall_4")
    (setq pt5 (polar p1c ang window_gap)
          pt5 (polar pt5 ang1 (/ wn2:frw 2.0))
          dn  (/ (- d1 (* 2 (+ 20 window_gap))) wn2:num)
    )
;;;    (setq pt5 pt1
;;;          dn  (/ (- d1 40) wn2:num)
;;;          wn2:frw d2
;;;    )
  ;;)
  (setq tmppt (polar pt5 ang3 wn2:frw))
  (repeat wn2:num
    (setq pt6  (polar pt5 ang  40)    ; 프레임 폭1
          pt7  (polar pt6 ang3 wn2:frw)
          pt8  (polar pt7 ang4 40)
          pt9  (polar pt6 ang3 15)
          pt10 (polar pt6 ang3 (/ wn2:frw 2 ))
    )
    (set_col_lin_lay wnn:fprop)
    (command "_.pline" pt5 pt6 pt7 pt8 "_C")
    (ssget "L")
    (if (/= wn:type "h") (command "_.line" pt10 (polar pt10 ang (- dn 40)) ""))
   
    ;(set_col_lin_lay wnn:fprop)
    (command "_.line" pt6 (polar pt6 ang (- dn 40)) "")
    (command "_.line" pt7 (polar pt7 ang (- dn 40)) "")
    (setq pt5 (polar pt5 ang dn))
  )
  (setq pt6  (polar pt5 ang  40)
        pt7  (polar pt6 ang3 wn2:frw)
        pt8  (polar pt7 ang4 40)
        pt9  (polar pt6 ang3 15)
        pt10 (polar pt9 ang3 12)
  )
  
  ;(set_col_lin_lay wnn:fprop)
  (command "_.pline" pt5 pt6 pt7 pt8 "_C")
  (setq pt7 tmppt)
)

(defun Wintype_a ()

  (draw_frame1 T)
  (ssget "L")
  
  (setq k 0)
  (if (= (rem wn2:num 2) 1)                                    ;; 홀수개 일때..
    (progn
      (repeat (1- wn2:num) 
        (setq k (1+ k))
	(DrawF_box T dn)
  
	(set_col_lin_lay cen:cprop)
        (command "_.line" (setq p (polar pv7 ang1 (* sc 3)))
                  (setq p (polar p ang1 (+ d2 (* sc 4)))) "")
      
        (if (= (rem k 2) 1)
          (setq p5 (polar p5 ang3 (+ frw 4)))
          (setq p5 (polar p5 ang1 (+ frw 4)))
        )
        (setq pv7 (polar pv7 ang dn))
      )
      (DrawF_box T dn)
      (command "_.mirror" "_P" "" (polar pt1 ang (/ d1 2))
                               (polar pt3 ang (/ d1 2)) "")
      ;(set_col_lin_lay wnn:fprop)
      (command "_.line" pt5 (polar pt5 ang (- d1
               (if (/= wn1:wal "wall_4") (* 2 (+ window_gap 40)) 80))) "")
      (command "_.line" pt8 (polar pt8 ang (- d1
               (if (/= wn1:wal "wall_4") (* 2 (+ window_gap 40)) 80))) "")
    )
  (progn                                                                ;; 짝수개 일때..
      (setq angz ang3)
      (repeat (1- wn2:num)
        (setq k (1+ k))
        (if (= k 1)
          (setq dk dn)
          (setq dk (- dn (/ frt 2.0)))
        )
	(DrawF_box T dk)
        
	(set_col_lin_lay cen:cprop)
        (command "_.line" (setq p (polar pv7 ang1 (* sc 3)))
                  (setq p (polar p ang1 (+ d2 (* sc 4)))) "")
        (if (= (rem k 2) 0)
          (setq p5   (polar p5 ang frt))
          (setq p5   (polar p5 angz (+ frw 4))
                angz (+ angz (dtr 180))
          )
        )
        (setq pv7 (polar pv7 ang dn))
      )

      (DrawF_box T dn)
      (if (= (rem wn2:num 4) 0)
        (command "_.mirror" "_P" "" (polar pt1 ang (/ d1 2))
                                 (polar pt3 ang (/ d1 2)) "")
	(progn
	(command "_.mirror" "_P" "" (polar pt1 ang (/ d1 2))
                                 (polar pt3 ang (/ d1 2)) "")
	(command "_.mirror" "_l" "" pt9 pt10 "y"))

      )
      ;(set_col_lin_lay wnn:fprop)
      (command "_.line" pt5 (polar pt5 ang (- d1
               (if (/= wn1:wal "wall_4") (* 2 (+ window_gap 40)) 80))) "")
      (command "_.line" pt8 (polar pt8 ang (- d1
               (if (/= wn1:wal "wall_4") (* 2 (+ window_gap 40)) 80))) "")
    )
  )
)


(defun wn2_init ()
  ;;
  ;; Resets entity list to original values.  Called when the dialogue or function 
  ;; is cancelled.
  ;;
  
  (defun wn2_set (/ changed?)    
    (cond
      ((= ci_mode "ib_wall_1")
        (setq wn1:wal  "wall_1")
      )
      ((= ci_mode "ib_wall_2")
        (setq wn1:wal  "wall_2")
      )
      ((= ci_mode "ib_wall_3")
        (setq wn1:wal  "wall_3")
      )
      ((= ci_mode "ib_wall_4")
        (setq wn1:wal  "wall_4")
        
      )
    )
    (PROP_SAVE wnn:prop)
  )

  ;;
  ;; Common properties for all entities
  ;;
  (defun set_tile_props ()
    (set_tile "error" "")
    
    (set_tile (strcat "rd_" wn1:typ) "1")
    
    (set_tile wn_prop_type "1")
    (@get_eval_prop wn_prop_type wnn:prop)
    
    (cond ((= wn2:fra "Aluminum") (set_tile "rd_alumin" "1"))
	  ((= wn2:fra "Wood") (set_tile "rd_wood" "1"))
	  ((= wn2:fra "AlWood") (set_tile "rd_alwd" "1"))
    )
    (radio_gaga wn1:typ)
    
    (set_tile "tg_stool" stool_chk)
    (set_tile "tg_offset" off_chk)
    (set_tile "tg_opn_size" opn_chk)
    
     ;; edit_box
    (set_tile "ed_gap_size" (rtos window_gap))
    (set_tile "ed_offset" (rtos wn2:ofs))
    (set_tile "ed_opn_size" (rtos wn2:ops))
    (set_tile "ed_case_num" (itoa wn2:num))
    (set_tile "ed_1st_sld_size" (rtos wn4:opn1))
    (set_tile "ed_2nd_sld_size" (rtos wn4:opn2))
    
    (set_tile "ed_frame_size"
	      (if (= wn2:fra "Wood")
	       (rtos wn2:fww)
	       (rtos wn2:faw)    
	      ))
    (set_tile "tx_type" C_win_type)
    (window_option_set)
    (frame_option_set)
    (wn_DrawImage "ib_win_type" wn:type)

    (ci_image  "ib_wall_1" "cim95(wn_1)")
    (ci_image  "ib_wall_2" "cim95(wn_2)")
    (ci_image  "ib_wall_3" "cim95(wn_3)")
    (ci_image  "ib_wall_4" "cim2(ws2_3)")
    (Wall_type_set)
  )

  
  
  (defun set_action_tiles ()
    (action_tile "rd_simple"       "(setq wn1:typ \"simple\")(radio_gaga \"simple\")(wn_DrawImage \"ib_win_type\" wn:type)")
    (action_tile "rd_detail"       "(setq wn1:typ \"detail\")(radio_gaga \"detail\")(wn_DrawImage \"ib_win_type\" wn:type)")
    (action_tile "b_name"       "(@getlayer)(wn_DrawImage \"ib_win_type\" wn:type)")
    
    (action_tile "b_color"      "(@getcolor)(wn_DrawImage \"ib_win_type\" wn:type)")
    (action_tile "color_image"  "(@getcolor)(wn_DrawImage \"ib_win_type\" wn:type)")
    (action_tile "b_line"       "(@getlin)(wn_DrawImage \"ib_win_type\" wn:type)")
    (action_tile "c_bylayer"    "(@bylayer_do T)(wn_DrawImage \"ib_win_type\" wn:type)")
    (action_tile "t_bylayer"    "(@bylayer_do nil)(wn_DrawImage \"ib_win_type\" wn:type)")

    (action_tile "prop_radio" "(setq wn_prop_type $Value)(@get_eval_prop wn_prop_type wnn:prop)(wn_DrawImage \"ib_win_type\" wn:type)")

    (action_tile "bn_type"       "(ttest)")

    (action_tile "ib_win_type"     "(WinTypeDlg)(window_option_set)")
    (action_tile "rd_alumin"       "(setq wn2:fra \"Aluminum\") (radio_gaga \"detail\")")
    (action_tile "rd_wood"         "(setq wn2:fra \"Wood\") (radio_gaga \"detail\")")
    (action_tile "rd_alwd" 	   "(setq wn2:fra \"AlWood\") (radio_gaga \"detail\")")
    
    (action_tile "ed_frame_size"       "(getfsize $value \"ed_frame_size\")")
    (action_tile "ed_gap_size"       "(getfsize $value \"ed_gap_size\")")
    (action_tile "ed_offset"       "(getfsize $value \"ed_offset\")")
    (action_tile "ed_opn_size"       "(getfsize $value \"ed_opn_size\")")
    (action_tile "ed_case_num"       "(getfsize $value \"ed_case_num\" )")
    (action_tile "ed_1st_sld_size"       "(getfsize $value \"ed_1st_sld_size\")")
    (action_tile "ed_2nd_sld_size"       "(getfsize $value \"ed_2nd_sld_size\")")

    (action_tile "tg_stool"        "(setq stool_chk $Value)(wn_DrawImage \"ib_win_type\" wn:type)")
    (action_tile "tg_opn_size"     "(setq opn_chk $Value)(toggle_do)")
    (action_tile "tg_offset"     "(setq off_chk $Value)(toggle_do)")

    (setq ci_lst '("1" "2" "3" "4"))
    (foreach lst ci_lst
      (action_tile (strcat "ib_wall_" lst)
        "(mode_tile ci_mode 4)(setq ci_mode $key)(mode_tile ci_mode 4)(if(= ci_mode \"ib_wall_4\")(mode_tile \"stool\" 1)(mode_tile \"stool\" 0))"
      )
    )
    ;(action_tile "finish"       "(getfinish $value)")

    (action_tile "accept"       "(dismiss_dialog 1)")
    (action_tile "cancel"       "(dismiss_dialog 0)")
    (action_tile "help"         "(cim_help \"WN2\")")
    (action_tile "bn_type_save"   "(readF \"WinType.dat\" nil)(ValueToList)(writeF \"WinType.dat\" nil)")
  )
  
(defun window_option_set()
  (if (= (get_tile "tg_opn_size") "1") (mode_tile "ed_opn_size" 0)(mode_tile "ed_opn_size" 1))
  (cond ((or (= wn:type "a")(= wn:type "b")(= wn:type "c")) (mode_tile "ed_case_num" 0)(mode_tile "ed_1st_sld_size" 1)(mode_tile "ed_2nd_sld_size" 1))
	((= wn:type "d") (mode_tile "ed_case_num" 1)(mode_tile "ed_1st_sld_size" 0)(mode_tile "ed_2nd_sld_size" 1))
	((= wn:type "e") (mode_tile "ed_case_num" 1)(mode_tile "ed_1st_sld_size" 0)(mode_tile "ed_2nd_sld_size" 0))
	((= wn:type "f") (mode_tile "ed_case_num" 1)(mode_tile "ed_1st_sld_size" 1)(mode_tile "ed_2nd_sld_size" 1)))

  (cond ((= wn:type "b") (setq wn2:fra "AlWood")(set_tile "rd_alwd" "1")
	 	         (mode_tile "rd_alwd" 0)(mode_tile "rd_alumin" 1)
	 	         (mode_tile "rd_wood" 1)(set_tile "ed_frame_size" (rtos wn2:faw)))
	(T (mode_tile "rd_alwd" 1)(mode_tile "rd_alumin" 0)(mode_tile "rd_wood" 0)
	   (if (= (get_tile "rd_alwd") "1")
	        (progn
			(setq wn2:fra "Aluminum")
		 	(set_tile "rd_alumin" "1")
		)
	   )
	 )
  )
)
(defun frame_option_set()

    (if (= stool_chk "1")
      (set_tile "tg_stool" "1") (set_tile "tg_stool" "0")
    )
    (if (= (get_tile "tg_offset") "1") (mode_tile "ed_offset" 0)(mode_tile "ed_offset" 1))
    
)
  
(defun Wall_type_set()
   (cond
      ((= wn1:wal "wall_1")
        (setq ci_mode "ib_wall_1")
      )
      
      ((= wn1:wal "wall_2") 
        (setq ci_mode "ib_wall_2")
      )
      ((= wn1:wal "wall_3") 
        (setq ci_mode "ib_wall_3")
      )
      ((= wn1:wal "wall_4")
       (setq ci_mode "ib_wall_4")
      )
    )
   (mode_tile ci_mode 4)
)

  (defun radio_gaga (pushed)
    ;(setq wn1:typ pushed)
    (cond 
      ((= pushed "simple")
        (mode_tile "frame_type_radio" 1)
        (setq stool_chk "0")
        (set_tile "tg_stool" "0")
        (mode_tile "tg_stool" 1)
      )
      ((= pushed "detail")
        (mode_tile "frame_type_radio" 0)
       (mode_tile "tg_stool" 0)
       (cond
        ((= wn2:fra "Aluminum")
 	        (mode_tile "rd_alwd" 1)
            	(set_tile "rd_alumin" "1")
                (set_tile "ed_frame_size" (rtos wn2:faw))
        )
        ((= wn2:fra "Wood")
		(mode_tile "rd_alwd" 1)
            (set_tile "rd_wood" "1")
            (set_tile "ed_frame_size" (rtos wn2:fww))
        )
        (T
          (mode_tile "rd_alimin" 1)
          (mode_tile "rd_wood" 1)
        ))
      ))
  )


  (defun toggle_do ()
    ;(if (= stool_chk "0") (setq stool_chk "0") (setq wn2:sof "ON"))
    (if (= opn_chk "0") (mode_tile "ed_opn_size" 1) (mode_tile "ed_opn_size" 0))
    (if (= off_chk "0") (mode_tile "ed_offset" 1) (mode_tile "ed_offset" 0))
  )


  ;; Checks validity of thickness from edit box.
 
  (defun getfsize (value tiles)
    (cond ((= tiles "ed_frame_size") 
	    (if (= wn2:fra "Wood")
	      (setq wn2:fww (verify_d tiles value wn2:fww))
	      (setq wn2:faw (verify_d tiles value wn2:faw))    
	    ))
	  ((= tiles "ed_gap_size")
	   (setq Window_gap (verify_d tiles value Window_gap)))
	  ((= tiles "ed_offset")
	   (setq wn2:ofs (verify_d tiles value wn2:ofs)))
	  ((= tiles "ed_opn_size")
	   (setq wn2:ops (verify_d tiles value wn2:ops)))
	  ((= tiles "ed_case_num")
	   (setq wn2:num (verify_d tiles value wn2:num)))
	  ((= tiles "ed_1st_sld_size")
	   (setq wn4:opn1 (verify_d tiles value wn4:opn1)))
	  ((= tiles "ed_2nd_sld_size")
	   (setq wn4:opn2 (verify_d tiles value wn4:opn2))) 
    ) )
 
  ;;
  (defun verify_d (tile value old-value / coord valid errmsg ci_coord)
    (setq valid nil errmsg "Invalid input value.")
    (if (setq coord (distof value))
      (progn
        (cond
          ((= tile "ed_case_num")
            (setq ci_coord (fix coord))
            (if (>= ci_coord 2)
              (if (= (- ci_coord coord) 0)
                (setq valid T)
                (setq errmsg "Value must be positive integer.")
              )
              (setq errmsg "Value must be positive integer more than 1.")
            )
          )
	  ((= tile "ed_opn_size")
            (if (< coord 0)
	      (setq errmsg "Value must be positive or zero.")
	      (progn
	      (if (<= coord (+ wn4:opn1 wn4:opn2))
		(setq wn4:opn1 coord wn4:opn2 0))
	      (if (<= coord wn4:opn1 )
		(setq wn4:opn1 coord wn4:opn2 0))
	      (set_tile "ed_1st_sld_size" (rtos wn4:opn1))
	      (set_tile "ed_2nd_sld_size" (rtos wn4:opn2))
              (setq valid T))
            )
          )
	  ((= tile "ed_1st_sld_size")
            (if (< coord 0)
	      (setq errmsg "Value must be positive or zero.")
	      (progn
		(if (>= coord wn2:ops)
		  (setq wn2:ops coord wn4:opn2 0)
		)
		(set_tile "ed_opn_size" (rtos wn2:ops))
	        (set_tile "ed_2nd_sld_size" (rtos wn4:opn2))
              (setq valid T))
            )
          )
          ((= tile "ed_2nd_sld_size")
            (if (< coord 0)
	      (setq errmsg "Value must be positive or zero.")
	      (progn
		(if (>= coord wn2:ops)
		  (setq wn2:ops coord wn4:opn1 0)
		  )
		(set_tile "ed_opn_size" (rtos wn2:ops))
	        (set_tile "ed_1st_sld_size" (rtos wn4:opn1))
              (setq valid T))
            )
          )
	  ((= tile "ed_gap_size")
            (if (>= coord 0)
              (setq valid T)
              (setq errmsg "Value must be positive or zero.")
            )
          )
	  ((= tile "ed_frame_size")
            (if (> coord 0)
              (setq valid T)
              (setq errmsg "Value must be positive or Nonzero.")
            )
          ) 
          (T (setq valid T))
        )
      )
      (setq valid nil)
    )
    (if valid
      (progn 
       ;(if (or (= errchk 0) (= tile last-tile))
          (set_tile "error" "")
       ; )
        (set_tile tile (if (= tile "ed_case_num") (itoa ci_coord) (rtos coord)))
        (setq errchk 0)
        (setq last-tile tile)
        (if (= tile "ed_case_num")
          ci_coord
          coord
        )
      )
      (progn
	(if (and (/= tile "ed_opn_size") (/= tile "ed_2nd_sld_size") (/= tile "ed_1st_sld_size"))
        (mode_tile tile 2))
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

  ;;
  ;; If their is no error message, then close the dialogue.
  ;;
;-- list_box handling  
(defun ttest (/ old_win_type)
 (readF "WinType.dat" nil)
 (setq  old_Win_type C_Win_type)
 (setq L_index (Find_index old_win_type))
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
 (setq C_win_type (nth 0 (cdr (nth L_index @Type))))    
 (set_tile "list_type" (rtos L_index)) 
 (set_tile "current_type" old_Win_type)
 (set_tile "ed_type_name" C_Win_type) 
)
(defun action_Tiles ()
 (action_tile "list_type" "(setq C_Win_type (Field_match \"타입명\" (setq L_index (atoi $value))))(set_tileS)")
 (action_tile "accept" "(qqqq)")
 (action_tile "cancel" "(setq C_win_type old_win_type)")
 (action_tile "eb_del_type" "(deleteIdx 'C_Win_type)(set_tileS)")
 (action_tile "eb_ren_type" "(renameIdx 'C_Win_type)(set_tileS)")
 (action_tile "eb_new_type" "(newIdx 'C_Win_type)(set_tileS)")
)
(defun qqqq()
  (Set_win_Value)(writeF "WinType.dat" nil)(done_dialog 1)(set_tile_props)
)
;-- list_box handling  

) ; end wn2_init

(defun wn2_do ()
  (if (not (new_dialog "dd_window" dcl_id)) (exit))
  (set_tile_props)
  (set_action_tiles)
  (setq dialog-state (start_dialog))
  (if (= dialog-state 0)
    (setq reset_flag t)
  )
)

(defun wn2_return ()
  (setq old_fprop  wnn:fprop
        old_gprop  wnn:gprop
        old_mprop  wnn:mprop
        wn1:sco  old_sco
        wn1:typ  old_typ
        wn1:wal  old_wal
        
        wn2:num  old_num
        wn2:faw  old_faw
        wn2:fww  old_fww
        wn2:fra  old_fra
        
        d1:wft   old_wft
  )
)
;;; ================== (dd_wn2) - Main program ========================
;;;
;;; Before (dd_wn2) can be called as a subroutine, it must
;;; be loaded first.  It is up to the calling application to
;;; first determine this, and load it if necessary.

(defun dd_wn2 (/
           cancel           color            ci_lst           
           ci_mode          dcl_id           dialog-state     dismiss_dialog
           ecolor           elayer           eltype           getcolor
           getdrag          getlaname        wngetlayer         getscolor 
           getnumber        getfinish        getfsize         getf_type
           lay-idx          laylist          layname          laynmlst
           layvalue         longlist         lst              lt-idx
           ltabstr          ltest_ok         ltname           old_sof
           ltvalue          old_fprop        old_gprop        old_wft
           old_mprop        old_num          old_fra	old_sco
           old_typ          old_wal          old_wtyp         old_faw
           old_fww          old-idx          radio_gaga
                       reset_flag       reset_lay        reset_lt
           scolor           set_action_tiles set_tile_props   sortlist
           tcolor           temp_color       test_ok          tile 
           tilemode         toggle_do
	   action_Tiles qqqq    value      ttest   set_tileS   verify_d 
	   Wall_type_set)

  (setvar "cmdecho" (cond (  (or (not *debug*) (zerop *debug*)) 0)
                          (t 1)))

  (setq old_fprop  wnn:fprop
        old_gprop  wnn:gprop
        old_mprop  wnn:mprop
	old_typ  wn1:typ  
        old_sco  wn1:sco  
        old_num  wn2:num
        old_faw  wn2:faw
        old_fww  wn2:fww
        old_fra  wn2:fra
        old_wft  d1:wft
	old_wal  wn1:wal  
       
  )

  (princ ".")
  (cond
     ((not (setq dcl_id (Load_dialog "LTwin.dcl"))))   ; is .DLG file loaded?

     (t (ai_undo_push)
        (princ ".")
        (wn2_init)                              ; everything okay, proceed.
        (princ ".")
        (wn2_do)
     )
  )
  (if reset_flag
    (wn2_return)
    (wn2_set)
  )
  (if dcl_id (unload_dialog dcl_id))
)

(defun Set_Win_Value(/ tnnp ttmpp1)
  
  (setq wn:type (strcase (substr (Field_match "창문타입" L_index) 2 1) T))
  (setq wn1:typ (Field_match "디테일" L_index) )
  (setq wn2:ops (atof (Field_match "크기" L_index)))
  (setq wn2:num (atoi (Field_match "창갯수" L_index)))
  (setq wn2:fra (Field_match "프레임" L_index))
  (if (= wn2:fra "Wood") (progn
  (setq wn2:fww (atof (Field_match "프레임크기" L_index)))(setq wn2:faw (atof (Field_match "Otherframewid" L_index))))
    (progn
  (setq wn2:faw (atof (Field_match "프레임크기" L_index)))(setq wn2:fww (atof (Field_match "Otherframewid" L_index))))
   ) 
  
  (setq stool_chk (if (= (Field_match "Stool" L_index) "o") "1" "0"))
  ;(setq wn2:sof (if (= stool_chk "1") "ON" "OFF"))
  (setq wn4:opn1 (atof (Field_match "1st_size" L_index)))
  (setq wn4:opn2 (atof (Field_match "2nd_size" L_index)))
  (setq wn2:ofs (atof (Field_match "Offset" L_index)))
  (setq window_gap (atof (Field_match "Gap" L_index)))
 
  (setq wn1:wal (strcat "wall_" (Field_match "Wall_frame" L_index)))

  (setq off_chk (if (= (Field_match "off_chk" L_index) "o") "1" "0"))
  (setq opn_chk (if (= (Field_match "opn_chk" L_index) "o") "1" "0"))

)

(defun ValueToList(/ tmpType tmpstool newlist tmm tmpopn tmpopn tnnp )
  (setq tmptype (strcat "[" (strcase wn:type) "]-type"))
  
  (setq tmplist (nth L_index @type))
  (setq tmpstool (if (= stool_chk "1") "o" "x"))
  (setq  tmpoff  (if (=  off_chk "1") "o" "x"))
  (setq  tmpopn  (if (=  opn_chk "1") "o" "x"))
  
  (setq tmpauto (cond ((= cw:ecp 4) "Auto") ((= cw:ecp 3) "Both")
		      ((= cw:ecp 2) "End") ((= cw:ecp 1) "Start") ((= cw:ecp 0) "None")))
  (setq tnnp (substr wn1:wal 6 1))
  (setq tmm (list C_Win_type tmptype wn1:typ (rtos wn2:ops) (itoa wn2:num) wn2:fra
		  (if (= wn2:fra "Wood") (rtos wn2:fww) (rtos wn2:faw)) tmpstool
		   (rtos wn4:opn1) (rtos wn4:opn2) (rtos wn2:ofs) (rtos window_gap) tnnp
		    tmpoff tmpopn (if (= wn2:fra "Wood") (rtos wn2:faw)(rtos wn2:fww))))
  (setq newlist (cons (1+ L_index) tmm))
  (setq @type (subst newlist tmplist @Type) )
)

(if (null C_Win_type)
   (progn
   
   (setq wnn:fprop  (Prop_search "win" "frame"))
   (setq wnn:gprop  (Prop_search "win" "glass"))
   (setq wnn:mprop  (Prop_search "win" "misc"))
   (setq cen:cprop  (Prop_search "cen" "cen"))
   (setq wnn:prop '(wnn:fprop wnn:gprop wnn:mprop))
   (readF "WinType.dat" nil) (setq L_index 0)
   (setq C_Win_type (nth 0 (cdr (nth L_index @Type))))
   (Set_Win_Value)
))

(if (null wn1:typ)  (setq wn1:typ  "detail"))
(if (null wn1:wal)  (setq wn1:wal  "wall_1"))

(if (null wn_prop_type) (setq wn_prop_type "rd_glass"))
(if (null off_chk) (setq off_chk "0"))
(if (null opn_chk) (setq opn_chk "1"))
(if (null stool_chk) (setq stool_chk "0"))
(if (null wn2:ofs) (setq wn2:ofs 0))

(if (null wn2:ops)  (setq wn2:ops 1200))
(if (null wn2:num)  (setq wn2:num  2))
(if (null wn2:fww)  (setq wn2:fww  100))
(if (null wn2:faw)  (setq wn2:faw  80))
(if (null wn2:fra)  (setq wn2:fra  "Aluminum"))
;(if (null wn2:sof)  (setq wn2:sof  "OFF"))
(if (null d1:wft)   (setq d1:wft 18))
(if (null wn:type) (setq  wn:type "a"))
(if (null wn4:opn1) (setq wn4:opn1 400))
(if (null wn4:opn2) (setq wn4:opn2 400))

(defun C:cimWIN() (m:wn2))
(setq lfn29 1)
(princ)
