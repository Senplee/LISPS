;단축키 관련 변수 정의 부분_맨뒤


;;;  참조 외부 file
; LTdoor.dcl , cim2.slb , cim1.slb


(defun DoorTypeDlg(/ dr_list dr_key drn dr_mode)
    (if (not (new_dialog "set_door_type" dcl_id)) (exit))
    (setq dr_list '("A" "B" "C" "D" "E" "F" "G" "H"))
    (foreach drn dr_list
      (setq dr_key (strcat "ib_door_" drn))
      (door_DrawImage dr_key drn )
 
    )
    (setq dr_mode (strcat "ib_door_" (strcase d1:dtype)))
    (mode_tile dr_mode 4)

    (foreach drn dr_list
      (action_tile (strcat "ib_door_" drn)
        "(mode_tile dr_mode 4)(setq dr_mode $key)(mode_tile dr_mode 4)"
      )
    )

    (if (= (start_dialog) 1) ; User pressed OK
      (if (/= d1:dtype (strcase (substr dr_mode 9)))
        (progn
          (setq d1:dtype (strcase (substr dr_mode 9)))
	  (door_DrawImage "door_type" (substr dr_mode 9))
	  (if (= d1:dtype "H")
            (progn (mode_tile "ed_1st_panel_size" 0) (mode_tile "tx_2nd_panel_size" 0))
	    (progn (mode_tile "ed_1st_panel_size" 1) (mode_tile "tx_2nd_panel_size" 1))
	  )
        )
      )
    )
     (if (and (>= (ascii (strcase d1:dtype)) 69) (<= (ascii (strcase d1:dtype)) 72) ) ;두짝문.
       (progn	
          (setq d1:owd d1:2owd)(set_tile "ed_opn_size" (rtos d1:owd))
       )
       (progn	
          (setq d1:owd d1:1owd)(set_tile "ed_opn_size" (rtos d1:owd))
       )
     )
  )

(defun door_DrawImage (key !Doortype! / !p_p_col !p_f_col !p_a_col !p_s_col)
  (setq !p_p_col (propcolor dor:pprop))
  (setq !p_f_col (propcolor dor:fprop))
  (setq !p_a_col (propcolor dor:aprop))
  (setq !p_s_col (propcolor dor:sprop))
  
    (setq !Doortype! (strcase !Doortype! T))
    (do_blank key 0)
    (start_image key)	  
   (cond
     ((= !Doortype! "a") (Door_image_a))
     ((= !Doortype! "b") (Door_image_b))
     ((= !Doortype! "c") (Door_image_c))
     ((= !Doortype! "d") (Door_image_d))
     ((= !Doortype! "e") (Door_image_e))
     ((= !Doortype! "f") (Door_image_f))
     ((= !Doortype! "g") (Door_image_g))
     ((= !Doortype! "h") (Door_image_h))

   )
    (end_image)
)
(defun Door_image_a (/ cx cy dx dy x1 x2 x3 x4 x5 x6
		  	           y1 y2 y3 y4 y5 y6)
    (setq cx (dimx_tile key)
	  cy (dimy_tile key)
	  dx (/ cx 40)
	  dy (/ cy 20)
	  x1 (* dx 12) x2 (* dx 13) x3 (* dx 14) x4 (* dx 20) x5 (* dx 24) x6 (* dx 26)
	  y1 (* dy 2) y2 (* dy 4) y3 (* dy 8) y4 (* dy 14) y5 (* dy 15) y6 (* dy 17)
    )
      	(vector_image x3 y4 x3 y1 !p_a_col)
	(vector_image x3 y1 x4 y2 !p_a_col)
	(vector_image x4 y2 x5 y3 !p_a_col)
	(vector_image x5 y3 x6 y4 !p_a_col)
  (if (= d1:typ "detail")
    (progn
  	(drawImage_box x1 y4 dx (* dy 3) !p_f_col)
	(drawImage_box x2 y1 dx (* dy 12) !p_p_col)
	(drawImage_box x6 y4 dx (* dy 3) !p_f_col)
    )
   )
  (if (/= d1:sty "None")
    	(vector_image x3 y4 x6 y4 !p_s_col)
   )
  (if (= d1:sty "Sill")
        (vector_image x2 y5 x6 y5 !p_s_col)
   )
  (if (= d1:sty "Threshold")
        (vector_image x2 y6 x6 y6 !p_s_col)
   )
)

(defun Door_image_b (/ cx cy dx dy x1 x2 x3 x4 x5 x6 x7 x8
		  	           y1 y2 y3 y4 y5 y6 y7)
    (setq cx (dimx_tile key)
	  cy (dimy_tile key)
	  dx (/ cx 40)
	  dy (/ cy 20)
	  x1 (* dx 10) x2 (* dx 12) x3 (* dx 13) x4 (* dx 14) x5 (* dx 22) x6 (* dx 23) x7 (* dx 26) x8 (* dx 28)
	  y1 (* dy 4) y2 (* dy 5) y3 (* dy 8) y4 (* dy 14) y5 (* dy 15) y6 (* dy 16) y7 (* dy 18)
    )
      	(vector_image x2 y4 x5 y1 !p_a_col)
	(vector_image x5 y1 x7 y3 !p_a_col)
	(vector_image x7 y3 x8 y4 !p_a_col)

  (if (= d1:typ "detail")
    (progn
  	(vector_image x2 y4 x5 y1 !p_p_col)
	(vector_image x5 y1 x6 y2 !p_p_col)
	(vector_image x6 y2 x3 y5 !p_p_col)
	(vector_image x3 y5 x2 y4 !p_p_col)
  	(drawImage_box x1 y4 (* dx  2) (* dy 3) !p_f_col)
	(drawImage_box x8 y4 (* dx  2) (* dy 4) !p_f_col)
     )
  )
  (if (/= d1:sty "None")
    	(vector_image x4 y4 x8 y4 !p_s_col)
   )
  (if (= d1:sty "Sill")
        (vector_image x2 y6 x8 y6 !p_s_col)
   )
  (if (= d1:sty "Threshold")
        (vector_image x2 y7 x8 y7 !p_s_col)
   )  
)

(defun Door_image_c (/ cx cy dx dy x1 x2 x3 x4 x5 x6 x7 x8 x9
		  	           y1 y2 y3 y4 y5 y6 y7)
    (setq cx (dimx_tile key)
	  cy (dimy_tile key)
	  dx (/ cx 40)
	  dy (/ cy 20)
	  x1 (* dx 9) x2 (* dx 11) x3 (* dx 15) x4 (* dx 19) x5 (* dx 20) x6 (* dx 21) x7 (* dx 25) x8 (* dx 29) x9 (* dx 31)
	  y1 (* dy 3) y2 (* dy 4) y3 (* dy 8) y4 (* dy 13) y5 (* dy 14) y6 (* dy 15) y7 (* dy 17)
	
   )
      	(vector_image x5 y4 x1 y4 !p_a_col)
	(vector_image x1 y4 x2 y3 !p_a_col)
	(vector_image x2 y3 x3 y2 !p_a_col)
  	(vector_image x3 y2 x4 y1 !p_a_col)
  	(vector_image x4 y1 x6 y1 !p_a_col)
  	(vector_image x6 y1 x7 y2 !p_a_col)
  	(vector_image x7 y2 x8 y3 !p_a_col)
  	(vector_image x8 y3 x9 y4 !p_a_col)
  	(vector_image x9 y4 x9 y5 !p_a_col)
 (if (= d1:typ "detail")
    (progn
  	(drawImage_box x4 y5 dx (* dy 3) !p_f_col)
	(drawImage_box x1 y4 (* dx  11) dy !p_p_col)
	(drawImage_box x9 y5 dx (* dy 3) !p_f_col)
     )
 )
  (if (/= d1:sty "None")
    	(vector_image x5 y5 x9 y5 !p_s_col)
   )
  (if (= d1:sty "Sill")
        (vector_image x5 y6 x9 y6 !p_s_col)
   )
  (if (= d1:sty "Threshold")
        (vector_image x5 y7 x9 y7 !p_s_col)
   )  
)

(defun Door_image_d (/ cx cy dx dy x1 x2 x3 x4 x5 x6 x7 x8 
		  	           y1 y2 y3 y4 y5 y6 )
    (setq cx (dimx_tile key)
	  cy (dimy_tile key)
	  dx (/ cx 40)
	  dy (/ cy 20)
	  x1 (* dx 6) x2 (* dx 12) x3 (* dx 13) x4 (* dx 22) x5 (* dx 23) x6 (* dx 26) x7 (* dx 28) x8 (* dx 34) 
	  y1 (* dy 4) y2 (* dy 5) y3 (* dy 8) y4 (* dy 14) y5 (* dy 15) y6 (* dy 16) 
   )

  	(vector_image x1 y4 x2 y4 !p_p_col)
	(vector_image x2 y4 x2 y6 !p_p_col)
	(vector_image x2 y6 x1 y6 !p_p_col)
	(vector_image x2 y4 x4 y1 !p_a_col)
	(vector_image x4 y1 x6 y3 !p_a_col)
	(vector_image x6 y3 x7 y4 !p_a_col)
	(vector_image x8 y4 x7 y4 !p_p_col)
	(vector_image x7 y4 x7 y6 !p_p_col)
	(vector_image x7 y6 x8 y6 !p_p_col)
  (if (= d1:typ "detail")
    (progn
	(vector_image x2 y4 x4 y1 !p_p_col)
	(vector_image x4 y1 x5 y2 !p_p_col)
	(vector_image x5 y2 x3 y5 !p_p_col)
	(vector_image x3 y5 x2 y4 !p_p_col)
    )
  )
)

(defun Door_image_e (/ cx cy dx dy x1 x2 x3 x4 x5 x6 x7 x8 x9 x10
		  	           y1 y2 y3 y4 y5 y6 )
    (setq cx (dimx_tile key)
	  cy (dimy_tile key)
	  dx (/ cx 40)
	  dy (/ cy 20)
	  x1 (* dx 6) x2 (* dx 7) x3 (* dx 8) x4 (* dx 14) x5 (* dx 18) x6 (* dx 20) x7 (* dx 22) x8 (* dx 26) x9 (* dx 32) x10 (* dx 33) 
	  y1 (* dy 2) y2 (* dy 4) y3 (* dy 8) y4 (* dy 14) y5 (* dy 15) y6 (* dy 17) 
	  )

	(vector_image x3 y4 x3 y1 !p_a_col)
	(vector_image x3 y1 x4 y2 !p_a_col)
	(vector_image x4 y2 x5 y3 !p_a_col)
	(vector_image x5 y3 x6 y4 !p_a_col)
	(vector_image x6 y4 x7 y3 !p_a_col)
	(vector_image x7 y3 x8 y2 !p_a_col)
	(vector_image x8 y2 x9 y1 !p_a_col)
	(vector_image x9 y1 x9 y4 !p_a_col)
  (if (= d1:typ "detail")
    (progn
	(drawImage_box x1 y4 dx (* dy 3) !p_f_col)
	(drawImage_box x2 y1 dx (* dy 12) !p_p_col)
	(drawImage_box x9 y1 dx (* dy 12) !p_p_col)
	(drawImage_box x10 y4 dx (* dy 3) !p_f_col)
    )
  )
  (if (/= d1:sty "None")
    	(vector_image x3 y4 x9 y4 !p_s_col)
   )
  (if (= d1:sty "Sill")
        (vector_image x2 y5 x10 y5 !p_s_col)
   )
  (if (= d1:sty "Threshold")
        (vector_image x2 y6 x10 y6 !p_s_col)
   )  
 )
(defun Door_image_f (/ cx cy dx dy x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14
		  	           y1 y2 y3 y4 y5 y6 y7)
    (setq cx (dimx_tile key)
	  cy (dimy_tile key)
	  dx (/ cx 40)
	  dy (/ cy 20)
	  x1 (* dx 2) x2 (* dx 4) x3 (* dx 5) x4 (* dx 6) x5 (* dx 14) x6 (* dx 15) x7 (* dx 18)
	  x8 (* dx 20) x9 (* dx 22) x10 (* dx 25) x11 (* dx 26) x12 (* dx 34) x13 (* dx 35) x14 (* dx 36) 
	  y1 (* dy 4) y2 (* dy 5) y3 (* dy 8) y4 (* dy 14) y5 (* dy 15) y6 (* dy 16) y7 (* dy 18)
    )
	(vector_image x2 y4 x5 y1 !p_a_col)
	(vector_image x5 y1 x7 y3 !p_a_col)
	(vector_image x7 y3 x8 y4 !p_a_col)
	(vector_image x8 y4 x9 y3 !p_a_col)
	(vector_image x9 y3 x11 y1 !p_a_col)
	(vector_image x11 y1 x14 y4 !p_a_col)
  (if (= d1:typ "detail")
    (progn
	(vector_image x2 y4 x5 y1 !p_p_col)
	(vector_image x5 y1 x6 y2 !p_p_col)
	(vector_image x6 y2 x3 y5 !p_p_col)
	(vector_image x3 y5 x2 y4 !p_p_col)
	(vector_image x14 y4 x11 y1 !p_p_col)
	(vector_image x11 y1 x10 y2 !p_p_col)
	(vector_image x10 y2 x13 y5 !p_p_col)
	(vector_image x13 y5 x14 y4 !p_p_col)
      (drawImage_box x1 y4 (* dx 2) (* dy 4) !p_f_col)
      (drawImage_box x14 y4 (* dx 2) (* dy 4) !p_f_col)
     )
   )
  (if (/= d1:sty "None")
    	(vector_image x4 y4 x12 y4 !p_s_col)
   )
  (if (= d1:sty "Sill")
        (vector_image x2 y6 x14 y6 !p_s_col)
   )
  (if (= d1:sty "Threshold")
        (vector_image x2 y7 x14 y7 !p_s_col)
   )
)
(defun Door_image_g (/ cx cy dx dy x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15
		  	           y1 y2 y3 y4 y5 y6 y7)
    (setq cx (dimx_tile key)
	  cy (dimy_tile key)
	  dx (/ cx 40)
	  dy (/ cy 20)
	  x1 (* dx 0) x2 (* dx 2) x3 (* dx 6) x4 (* dx 9) x5 (* dx 10) x6 (* dx 14) x7 (* dx 18)
	  x8 (* dx 20)  x9 (* dx 22)  x10 (* dx 26) x11 (* dx 30) x12 (* dx 31) x13 (* dx 34) x14 (* dx 38) x15 (* dx 40) 
	  y1 (* dy 3) y2 (* dy 4) y3 (* dy 8) y4 (* dy 13) y5 (* dy 14) y6 (* dy 15) y7 (* dy 17)
    )
	(vector_image x5 y4 x1 y4 !p_a_col)
	(vector_image x1 y4 x2 y3 !p_a_col)
	(vector_image x2 y3 x3 y2 !p_a_col)
	(vector_image x3 y2 x5 y1 !p_a_col)
	(vector_image x5 y1 x6 y2 !p_a_col)
	(vector_image x6 y2 x7 y3 !p_a_col)
	(vector_image x7 y3 x8 y5 !p_a_col)
	(vector_image x8 y5 x9 y3 !p_a_col)
	(vector_image x9 y3 x10 y2 !p_a_col)
	(vector_image x10 y2 x11 y1 !p_a_col)
	(vector_image x11 y1 x13 y2 !p_a_col)
	(vector_image x13 y2 x14 y3 !p_a_col)
	(vector_image x14 y3 x15 y4 !p_a_col)
	(vector_image x15 y4 x11 y4 !p_a_col)
  (if (= d1:typ "detail")
    (progn
        (drawImage_box x4 y5 dx (* dy 3) !p_f_col)
	(drawImage_box x1 y4 (* dx 10) dy !p_p_col)
	(drawImage_box x11 y5 dx (* dy 3) !p_f_col)
	(drawImage_box x11 y4 (* dx 10) dy !p_p_col)
    )
  )
  (if (/= d1:sty "None")
    	(vector_image x5 y5 x11 y5 !p_s_col)
   )
  (if (= d1:sty "Sill")
        (vector_image x5 y6 x11 y6 !p_s_col)
   )
  (if (= d1:sty "Threshold")
        (vector_image x5 y7 x11 y7 !p_s_col)
   )
)
(defun Door_image_h (/ cx cy dx dy x1 x2 x3 x4 x5 x6 x7 x8 x9 x10
		  	           y1 y2 y3 y4 y5 y6 y7 y8 y9)
    (setq cx (dimx_tile key)
	  cy (dimy_tile key)
	  dx (/ cx 40)
	  dy (/ cy 20)
	  x1 (* dx 10) x2 (* dx 11) x3 (* dx 12) x4 (* dx 16) x5 (* dx 19) x6 (* dx 20)
	  x7 (* dx 22) x8 (* dx 26)  x9 (* dx 32)  x10 (* dx 33) 
	  y1 (* dy 2) y2 (* dy 4) y3 (* dy 6) y4 (* dy 7) y5 (* dy 8) y6 (* dy 10)
	  y7 (* dy 14) y8 (* dy 15) y9 (* dy 17)
    )

	(vector_image x3 y7 x3 y3 !p_a_col)
	(vector_image x3 y3 x4 y4 !p_a_col)
	(vector_image x4 y4 x5 y6 !p_a_col)
	(vector_image x5 y6 x6 y7 !p_a_col)
	(vector_image x6 y7 x7 y5 !p_a_col)
	(vector_image x7 y5 x8 y2 !p_a_col)
	(vector_image x8 y2 x9 y1 !p_a_col)
	(vector_image x9 y1 x9 y7 !p_a_col)
  (if (= d1:typ "detail")
    (progn
        (drawImage_box x1 y7 dx (* dy 3) !p_f_col)
	(drawImage_box x2 y3 dx (* dy 8) !p_p_col)
	(drawImage_box x9 y1 dx (* dy 12) !p_p_col)
	(drawImage_box x10 y7 dx (* dy 3) !p_f_col)
    )
  )
  (if (/= d1:sty "None")
    	(vector_image x3 y7 x9 y7 !p_s_col)
   )
  (if (= d1:sty "Sill")
        (vector_image x2 y8 x10 y8 !p_s_col)
   )
  (if (= d1:sty "Threshold")
        (vector_image x2 y9 x10 y9 !p_s_col)
   )
)

(defun drawImage_box (tmpXp tmpYp tmpXd tmpYd tmpCol / x1 x2 y1 y2)
 (setq x1 tmpxp x2 (+ tmpxp tmpxd)
       y1 tmpyp  y2 (+ tmpyp tmpyd)
 )
 (vector_image x1 y1 x2 y1 tmpcol)
 (vector_image x2 y1 x2 y2 tmpcol)
 (vector_image x2 y2 x1 y2 tmpcol)
 (vector_image x1 y2 x1 y1 tmpcol)

)


;;; ==================== end load-time operations ===========================
;;; Main function
(defun m:dp (/
            pt1      pt2      pt3      d1       d2       d3       dx
            d1frw    uctr     pt4      pt5      pt6      pt7      pt8
            pt9      pt10     pt11     pt12     pt13     pt14     pt14_1 pt15 pt15_1
	    pt16_1 pt17_1  
            pt16     pt17     pt18     pt10x    ptc      ptcn     ang
            ang1     ang2     ang3     ang4     ss       ls       no
            cont     temp     tem      uctr
            d1_osm   d1_oco   d1_oli   d1_ola   d1_oor      d1_err
            d1_oer   
	    ltypeSet key      rd_property     tmpC tmplen 
	     )
  
 
  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")
  
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n문을 그리는 명령입니다.")

  (setq cont T
	uctr 0
	temp T)

  (while cont
    (d1_m1)
    (d1_m2)
    (d1_m3)
    
  )

 
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)

  (princ)
)


(defun d1_m1 ()
  (while temp
    (setvar "blipmode" 1)
    (setvar "osmode" (+ 512 32) )
    (if (> uctr 0)
      (progn
        (initget "~ / Dialog Offset Undo")
          (setq strtpt (getpoint
            "\n>>> Dialog/Offset/Undo/<start point>: NEAREST to "))
      )
      (progn
        (initget "~ / Dialog Offset ")
          (setq strtpt (getpoint
            "\n>>> Dialog/Offset/<start point>: NEAREST to "))
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
      ( (= strtpt "Dialog")   ;;)(or (= strtpt "~")
        (princ "\t>>> Please waite -- dialog loading...")
        (dd_d1)
      )
      ((= strtpt "/")
        (princ "\t>>> Please waite -- help_dialog loading...")
        (cim_help "Door")
      )
      ((null strtpt)

          (setq cont nil temp nil)
      )
      (T
        (if (not (ssget strtpt))
          (alert "Wall entity not selected -- Try again.")
          (setq temp nil tem T)
        )
      )
    )
  )
)

(defun d1_m2 ()
  (while tem
    (initget "~ / Dialog Undo")
    (setvar "blipmode" 1)
    (setvar "osmode" (+ 512 32))

    (setq nextpt (getpoint strtpt
            "\n    Dialog/Undo/<strike point>: NEAREST to "))

    (setvar "blipmode" 0)
    (setvar "osmode" 0)
    (cond
      ((= nextpt "Undo")
        (setq tem nil temp T)
      )
      ((= nextpt "Dialog") 
        (princ "\t>>> Please waite -- dialog loading...")
        (dd_d1)
      )
      ((= nextpt "/")
        (princ "\t>>> Please waite -- help_dialog loading...")
        (cim_help "Door")
      )
      ((null nextpt)
        (setq cont nil tem nil)
      )
      (T
        (if (not (ssget nextpt))
          (alert "Wall entity not selected -- Try again.")
          (if (equal strtpt nextpt 100)
            (alert "Coincident point -- Try again.")
            (setq tem nil pt3 T)
          )
        )
      )
    )
  )
)

(defun d1_m3 (/ ar_r1 ar_r2 d1:wf1 d1:wf2 aa p)
 
  (while pt3
    (initget "~ / Dialog Undo")
    (setvar "blipmode" 1)
    (setvar "osmode" 128)
    (setvar "orthomode" 0)

    (setq pt3 (getpoint strtpt
            "\n   Dialog/lUndo/<other side of the wall>: PERPEND to "))

    (setvar "osmode" 0) 
    (setvar "blipmode" 0)
    (cond
      ((= pt3 "Undo")
        (setq pt3 nil tem T)
      )
     
      ( (= pt3 "Dialog") 
        (princ "\t>>> Please waite -- dialog loading...")
        (dd_d1)
      )
      ((= pt3 "/")
        (princ "\t>>> Please waite -- help_dialog loading...")
        (cim_help "Door")
      )
      ((= (type pt3) 'LIST)
       (if (= d1:offsetauto "1")                ;;; offset checked
         (progn
          (setq strtpt (polar strtpt (angle strtpt nextpt) d1:odt))
	  (setq nextpt (polar nextpt (angle strtpt nextpt) d1:odt))
	  (setq pt3 (polar pt3 (angle strtpt nextpt) d1:odt))
       ))
        (if (not (ssget pt3))
          (alert "Wall entity not selected -- Try again.")
          (if (= (inters strtpt nextpt nextpt pt3 nil) nil)
            (alert "Other side of the wall not selected -- Try again.")
            (progn
	      (autonextpt?) 
              (command "_.undo" "_M")
              (d1_ex)
              (if (= d1:typ "simple")
		(cond 
		  ((and (>= (ascii (strcase d1:dtype)) 65) (<= (ascii (strcase d1:dtype)) 68)) (d1_sd))
		  ((and (>= (ascii (strcase d1:dtype)) 69) (<= (ascii (strcase d1:dtype)) 72)) (d2_sd))
		)
		(cond
		  ((and (>= (ascii (strcase d1:dtype)) 65) (<= (ascii (strcase d1:dtype)) 68)) (d1_dd))
		  ((and (>= (ascii (strcase d1:dtype)) 69) (<= (ascii (strcase d1:dtype)) 72)) (d2_dd))
		)
              )
              (command "_.color" d1:col)
              (setq uctr (1+ uctr))
              (setq pt3 nil temp T)
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
(defun autonextpt? (/ sign tmp_ang)
  (setq sign (if (> (setq tmp_ang (- (angle strtpt nextpt) (angle strtpt pt3))) 0) 1 -1))
  (if (and (= d1:widauto "1") (/= d1:owd nil))
    (setq nextpt (polar strtpt
			(+ (angle strtpt pt3)
			   (if (< (abs tmp_ang) pi) (* pi 0.5 sign)(* pi 1.5 sign))) d1:owd))
  )
)
;---------------------------------------------------------------------------------------------------
(defun d1_ex (/ k e tmp:wal)
  ;(if (and (/= d1:wal  "wall_4")(/= d1:typ "simple"))(wall_point))
  ;d1:typ
  (if (= d1:typ "simple") (setq tmp:wal d1:wal d1:wal "wall_1"))
  (wall_point)
  (setq pt1  strtpt
        pt2  nextpt
        ang  (angle pt1 pt2)
        d2   (distance pt1 pt3)
        d1   (distance pt1 pt2)
        d3   (if (/= d1:wal "wall_4")(- d1 (* 2 (+ door_gap 25))) d1 )
        pt4  (polar pt3 ang d1)
  )
  
  (if (and (>= (ascii (strcase d1:dtype)) 69) (<= (ascii (strcase d1:dtype)) 72))
    (progn
    (setq d3  (if (/= d1:wal "wall_4")
                (/ (- d1 (* 2 (+ door_gap 25))) 2.0)
                (/ d1 2.0)
              )
         pt4  (polar pt3 ang d1)
    ))	  
  )
  (setq ang1 (angle pt3 pt1)
        ang2 (/ (+ ang ang1) 2)
        ang3 (angle pt1 pt3)
        ang4 (angle pt2 pt1)
        ptc  (polar pt3 ang (/ d1 2.0))
        ptcn (polar ptc ang1 d2)
  )
  (if (> (abs (- (rtd ang1) (rtd ang2))) 45.1)
    (setq ang2 (+ ang2 (dtr 180)))
  )

  
  (get_fin_dist)
  
  
  (set_frame_value)
  
  
  (if (= d1:typ "simple")
    (cond ((or (= d1:dtype "A") (= d1:dtype "B") (= d1:dtype "C") (= d1:dtype "D"))
	  	(break_d1 3)
	   )
	  (T (break_d1 4))
	  )
    (cond ((or (= d1:dtype "A") (= d1:dtype "B") (= d1:dtype "C"))
	  	(break_d1 1)
	   )
	  ((= d1:dtype "D")
	   	(break_d1 3)
	   )
	  (T (break_d1 2))
    )
    )
  
  
  (setq ss (ssget "C"  pt2 pt4
             '((-4 . "<OR")
                (0 . "LINE") (0 . "ARC") (0 . "CIRCLE") (0 . "*POLYLINE")
              (-4 . "OR>"))))
  (if ss
    (progn
    (RMV)
  ;;(and (= ls 4) (or (= d1:wal "wall_1") (= d1:wal "wall_3")))
    
      (setq k 0)
      (repeat (sslength ss)
        (setq e (entget (ssname ss k)))
        (if (wcmatch (fld_st 0 e) "*POLYLINE")
          (command "_.explode" (ssname ss k))
        )
        (setq k (1+ k))
      )
    )
  )
  (setq ss (ssget "C" (polar pt1 ang (/ d1 2)) (polar pt3 ang (/ d1 2)) ;pt2 pt4
             '((-4 . "<OR")
                (0 . "LINE") (0 . "ARC") (0 . "CIRCLE") (0 . "POLYLINE")
              (-4 . "OR>"))))
  (RMV)
  (setq e (entget (ssname ss 0)))
  (setq cpt nil)
  (if (or (= (fld_st 0 e) "ARC")
          (= (fld_st 0 e) "CIRCLE")
      )
    (progn
      (setq ar_r1 (fld_st 40 (entget (ssname (ssget "C" pt1 pt1) 0)))
            ar_r2 (fld_st 40 (entget (ssname (ssget "C" pt3 pt3) 0)))
      )
      (brk_a)
      (setq cpt (fld_st 10 e))
    )
    (if (or (= d1:wal "wall_4")(= d1:wal "wall_3"))
      (brk_s)
      (if (= ls 4)
        (brkl d1:wal)
        (brk_s)
      )
    )
  )
  (if (= d1:typ "simple") (setq d1:wal tmp:wal))
)

(defun interang (angA angB /)
	(if (> (- angA angB) (dtr 270)) (+ angA (dtr 20)) (/ (+ angA angB) 2))
)

(defun d1_sd (/ spt5 spt6)     ;; 도아1 simple
  (cond
    ((= (strcase d1:dtype) "A") (setq spt5 (polar pt1 ang1 d1))(setq spt6 (polar pt1 ang2 d1)))
    ((or (= (strcase d1:dtype) "B")(= (strcase d1:dtype) "D")) (setq spt5 (polar pt1 ang2 d1))(setq spt6 (polar pt1 (interang ang2 ang) d1)))
    ((= (strcase d1:dtype) "C") (setq spt5 (polar pt1 ang4 d1))(setq spt6 (polar pt1 ang2 d1)))
  )
  
  ;; arc_color
  (set_col_lin_lay dor:aprop)
   
  (command "_.line" pt1 spt5 "")
  (ssget "L")
  (command "_.arc" spt5 spt6 pt2)
  (command "_.pedit" "_L" "_Y" "_J" "_P" "" "")
)

(defun d2_sd (/  pt5_1 pt6_1 spt5 spt6)
  
  (setq tmplen (* d1 (/ d1:pn1 (float (+ d1:pn1 d1:pn2)))))  ;; 문크기 다를때
  (setq tmpC (polar pt1 ang tmplen))                         ;; 그때 중심점
 
(cond
    ((= (strcase d1:dtype) "E") (setq spt5 (polar pt1 ang1 (/ d1 2.0)))(setq spt6 (polar pt1 ang2 (/ d1 2.0))))
    ((= (strcase d1:dtype) "F") (setq spt5 (polar pt1 ang2 (/ d1 2.0)))(setq spt6 (polar pt1 (interang ang2 ang) (/ d1 2.0))))
    ((= (strcase d1:dtype) "G") (setq spt5 (polar pt1 ang4 (/ d1 2.0)))(setq spt6 (polar pt1 ang2 (/ d1 2.0))))
    ((= (strcase d1:dtype) "H") (setq spt5 (polar pt1 ang1 tmplen))
     				(setq spt6 (polar pt1 ang2 tmplen))
     				(setq pt5_1 (polar pt2 ang1 (- d1 tmplen)))
     				(setq pt6_1 (polar pt2 (+ (- ang1 ang) ang2) (- d1 tmplen))))
)
  
  (set_col_lin_lay dor:aprop)
  
  (command "_.line" pt1 spt5 "")
  (ssget "L")

  (if (/= (strcase d1:dtype) "H")
    (progn
	  (command "_.arc" spt5 spt6 ptcn)
	  (command "_.pedit" "_L" "_Y" "_J" "_P" "" "")
	  (command "_.mirror" "_L" "" ptc ptcn "")
     )
    (progn
          (command "_.line" pt2 pt5_1 "")
      	  (command "_.arc" spt5 spt6 tmpC)
      	  (command "_.pedit" "_L" "_Y" "_J" "_P" "" "")

      	  (command "_.arc" pt5_1 pt6_1 tmpC)
      	  (command "_.pedit" "_L" "_Y" "_J" "_P" "" "")          
     )
   )
)
(defun break_d1(flag / eee)
  (if ;(and (/= d1:wal "wall_4")
           (setq ss (ssget "C" pt6 (polar pt6 ang3 (+ 12 d1:wf1))
                      '((-4 . "<OR")
                          (0 . "LINE") (0 . "ARC") (0 . "CIRCLE")
                       (-4 . "OR>"))));)
    (progn
      (RMV)
      (setq pb1 (if (> flag 2) (polar (polar pt6 ang4 door_gap) ang3 12) (polar pt6 ang3 12))
            pb2 (polar pb1 ang
			(cond
			  ((= flag 1) (+ d3 50 ))
			  ((= flag 2) (if (= d1:wal "wall_4") (+ d1 50)  (- d1 door_gap door_gap)))
			  ((= flag 3) (+ d3 50 door_gap door_gap))
			  (T (+ (- d1 10) door_gap door_gap))
			  ))
      )
      
      (repeat ls
        (setq no (1+ no))
	(if (= (cdr (assoc 8 (entget (ssname ss no)))) (nth 2 (Prop_search "wall" "finish")))
	  
	  (progn
	    	(setq eee (entget (ssname ss no)))
	        (if (and cpt (> (angle cpt pt2) (angle cpt pt1)))
	          (command "_.break" (ssname ss no) pb1 pb2)
	          (command "_.break" (ssname ss no) pb2 pb1)
	        )
	))
      )
      (if (and (> flag 2)(/= d1:wf1 0))
	(progn
	  	
	  	(command "_.color" (if (fld_st 62 eee) (fld_st 62 eee) "bylayer"))
	        (command "_.linetype" "_S" (if (fld_st 6 eee) (fld_st 6 eee) "bylayer") "")
	        (command "_.layer" "_S" (fld_st 8 eee) "")
		(command "_line" pt1 (polar pt1 ang1 d1:wf1) "")
	  	(command "_line" pt2 (polar pt2 ang1 d1:wf1) "")
	 )
      )
	
    )
  )
  (if ;(and (/= d1:wal "wall_4")
;;;	   (> d1frw (+ d2 d1:wf1 12))
           (setq ss (ssget "C" pt12 (polar pt12 ang1 (+ 12 d1:wf2))
                 '((-4 . "<OR")
                    (0 . "LINE") (0 . "ARC") (0 . "CIRCLE")
                  (-4 . "OR>"))));)
    (progn
      (RMV)
      (setq pb1 (if (> flag 2) (polar (polar pt12 ang4 door_gap) ang3 12) (polar pt12 ang1 12))
            pb2 (polar pb1  ang  (cond
			  ((= flag 1) (+ d3 50 ))
			  ((= flag 2) (if (= d1:wal "wall_4") (+ d1 50) (- d1 door_gap door_gap)))
			  ((= flag 3) (+ d3 50 door_gap door_gap))
			  (T (+(- d1 10) door_gap door_gap))
			  ))
      )
      (repeat ls
        (setq no (1+ no))
	(if (= (cdr (assoc 8 (entget (ssname ss no)))) (nth 2 (Prop_search "wall" "finish")))
	  (progn
	    	(setq eee (entget (ssname ss no)))
	        (if (and cpt (> (angle cpt pt2) (angle cpt pt1)))
	          (command "_.break" (ssname ss no) pb1 pb2)
	          (command "_.break" (ssname ss no) pb2 pb1)
	        )
	    ))
      )
      (if (and (> flag 2) (/= d1:wf2 0))
	(progn
	  	(command "_.color" (if (fld_st 62 eee) (fld_st 62 eee) "bylayer"))
	        (command "_.linetype" "_S" (if (fld_st 6 eee) (fld_st 6 eee) "bylayer") "")
	        (command "_.layer" "_S" (fld_st 8 eee) "")
		(command "_line" pt3 (polar pt3 ang3 d1:wf2) "")
	  	(command "_line" pt4 (polar pt4 ang3 d1:wf2) "")
	 )
      )
    )
  )
)
(defun d1_draw_frame()
  (set_col_lin_lay dor:fprop)

  (cond
    ((= d1:frt "A")
      (command "_.pline" pt5 pt6 pt7 pt8 pt9 pt10 pt11 pt12 pt13 "")
    )
    ((= d1:frt "B")
      (command "_.pline" pt5 pt6 pt7 pt8 pt9 pt10 pt10x pt11 pt12 pt13 "")
    )
    ((= d1:frt "C")
      (command "_.pline" pt5 pt6 pt7 pt8 pt9 pt11 pt12 pt13 "")
    )
    ((= d1:frt "D")
      (command "_.pline" pt6 pt7 pt8 pt9 pt10 pt11 pt12 "_c")
    )
    ((= d1:frt "E")
      (command "_.pline" pt6 pt7 pt8 pt9 pt10 pt10x pt11 pt12 "_c")
    )
    ((= d1:frt "F")
      (command "_.pline" pt6 pt7 pt8 pt9 pt11 pt12 "_c")
    )
  )
)
(defun get_fin_dist(/ factor)
  (setq factor (/ (distance strtpt pt3) 8))

  (if (> d1:wft 60)
    (setq aa d1:wft)
    (setq aa 60)
  )
  
  (if (setq ss (wall_select_rect (setq p (polar pt1 ang (/ d1 2))) factor))
    (progn
      (RMV)
	(if (> ls 1)
	  (progn
	    (if (< (setq d1:wf1 (distance p (perpoint p (entget (ssname ss 0))))) 0.01)
	      (setq d1:wf1 (distance p (perpoint p (entget (ssname ss 1)))))
	    )
	  )
	 )
     )
  )
  (if (= d1:wf1 nil)
    (setq d1:wf1 0);d1:wft)
  )
  
 
  (if (setq ss (wall_select_rect (setq p (polar pt3 ang (/ d1 2))) factor))
    (progn
      (RMV)
	(if (> ls 1)
	  (progn
	    (if (< (setq d1:wf2 (distance p (perpoint p (entget (ssname ss 0))))) 0.01)
	      (setq d1:wf2 (distance p (perpoint p (entget (ssname ss 1)))))
	    )
	  )
	 )
     )
  )
  (if (= d1:wf2 nil)
    (setq d1:wf2 0);d1:wft)
  )

)

(defun set_frame_value()
  (if (/= d1:wal "wall_4")
    (progn
      (setq pt5 (polar pt1 ang door_gap))
      (if (= d1:wf1 0)
        (setq pt5 (polar pt5 ang3 0)
              pt6 (polar pt5 ang1 12)
        )
        (setq pt5 (polar pt5 ang1 d1:wf1)
              pt6 (polar pt5 ang1 (+ d1:wf1 2))
        )
      )
      (setq pt7 (polar pt6 ang 25)
            pt8 (polar pt7 ang3 d1:dpt)
            pt9 (polar pt8 ang 15)
      )
    )
    (setq d1:dpt (if (>= d2 (+ 6 d1:dpt)) d1:dpt (- d2 6))
          pt5    (polar pt1 ang4 25)
          pt6    (polar pt5 ang1 12)
          pt7    (polar pt6 ang 25)
          pt8    (polar pt7 ang3 d1:dpt)
          pt9    (polar pt8 ang 15)
    )
  )
  (if (and (= d1_frw_chk "1") (< d1:frw (+ d2 (+ d1:wf1  d1:wf2 24))))
    (setq d1frw d1:frw
          dx    (- d1:frw (+ d1:dpt (+ door_gap 25)))
    )
    (setq d1frw (+ d2 (+ d1:wf1 d1:wf2 (* (distance pt5 pt6) 2)))
          dx    (- d1frw (+ d1:dpt (+ door_gap 25)))
    )
  )
  (if (= d1:wal "wall_4")
    (setq d1frw (+ d2 24)
          dx    (- d1frw (+ d1:dpt (+ door_gap 25)))
    )
  )
  (if (< dx 15) (setq dx 15))
  (setq pt10  (polar pt9 ang3 dx)
        pt10x (polar pt10 ang4 15)
        pt11  (if (or (= d1:frt "C") (= d1:frt "F"))
                (polar pt9 ang3 (- d1frw d1:dpt))
                (polar pt7 ang3 d1frw)
              )
        pt12  (if (or (= d1:frt "C") (= d1:frt "F"))
                (polar pt11 ang4 40)
                (polar pt11 ang4 25)
              )
        pt13  (polar pt12 ang1 (if (/= d1:wal "wall_4")
              (if (or (<= d1frw (+ d2 d1:wf1 12)) (= d1:wf2 0))
                 (distance pt5 pt6) (- d1frw (distance pt5 pt6) d2 d1:wf1 d1:wf2)) 12)) ;

  )
)

(defun d1_extend_finish ()
    (if (setq ss (ssget "C" (setq p (polar pt3 ang (/ d1 2))) (polar p ang3 aa)
                 '((-4 . "<OR")
                    (0 . "LINE") (0 . "ARC") (0 . "CIRCLE")
                  (-4 . "OR>"))))
    (progn
      (RMV)
      (repeat ls
        (setq no (1+ no))
        (setq e (entget (ssname ss no)))
        (if (or (= (fld_st 0 e) "ARC") (= (fld_st 0 e) "CIRCLE"))
          (progn
            (setq d1:ww2 (abs (- (fld_st 40 e) ar_r2)))
          )
          (progn
            (setq mp0 (fld_st 10 e)
                  mp1 (fld_st 11 e)
            )
            (setq p2 (inters mp0 mp1 p (polar p ang3 aa)))
            (setq d1:ww2 (distance p p2))
          )
        )
        (if (<= d1:ww2 30)
          (setq d1wf2 30)
          (setq d1wf2 (if (> d1:ww2 60) 60 d1:ww2))
        )
        (if (and (>= d1wf2 40) (/= kn 1) (or (= d1:frt "A") (= d1:frt "D")))
          (setq pt11 (polar pt11 ang 15) kn 1)
        )
        (if (and (>= d1wf2 40) (/= kn 1) (or (= d1:frt "B") (= d1:frt "E")))
          (setq pt10X (polar pt11 ang 15) kn 1)
        )
        (setq p1 (polar pt3 ang d1wf2)
              p1 (polar p1 ang3 d1:ww2)
              p2 (polar p1 ang (- d1 (* d1wf2 2)))
        )
        (if (and cpt (> (angle cpt pt2) (angle cpt pt1)))
          (command "_.break" (ssname ss no) p1 p2)
          (command "_.break" (ssname ss no) p2 p1)
        )
        (command "_.color" (if (fld_st 62 e) (fld_st 62 e) "bylayer"))
        (command "_.linetype" "_S" (if (fld_st 6 e) (fld_st 6 e) "bylayer") "")
        (command "_.layer" "_S" (fld_st 8 e) "")
        (command "_.line"
                 p1 (polar p1 ang1 (- (+ d1:ww2 d2 d1:wf1 12) d1frw)) "")
        (command "_.line"
                 p2 (polar p2 ang1 (- (+ d1:ww2 d2 d1:wf1 12) d1frw)) "")
       
      )
    )
  )
 )

(defun d1_dd (/ kn d1wf2 d1ww2 p1 p2 pk1 pk2 poly)  ; 도아1 complex

  (cond
    ((= (strcase d1:dtype) "A") 
      (setq
        pt14  (polar pt7 ang (- d1:dpt 5))
        pt15  (polar pt14 ang1 d3)
        pt16  (polar pt7 ang1 d3)
        pt17  (polar pt7 ang2 d3)
      )
    )
    ((= (strcase d1:dtype) "B")
      (setq
        pt14  (polar pt7 (-  (* ang 2) ang2) (- d1:dpt 5))
        pt15  (polar pt14 ang2 d3)
        pt16  (polar pt7  ang2 d3)
        pt17  (polar pt7 (interang ang2 ang) d3)
      )
    )
    ((= (strcase d1:dtype) "C")
      (setq
	pt14  (polar pt7  ang1 (- d1:dpt 5))
        pt15  (polar pt14 ang4 d3)
        pt16  (polar pt7  ang4 d3)
        pt17  (polar pt7  ang1 d3)
	)
    )	
    ((= (strcase d1:dtype) "D") 
      (setq
	pt7 pt1
        pt14  (polar pt1 (-  (* ang 2) ang2) d1:wft )
        pt15  (polar pt14 ang2 d1)
        pt16  (polar pt1 ang2 d1)
        pt17  (polar pt1 (interang ang2 ang) d1)
      )
    )    
  )
  (if (/= (strcase d1:dtype) "D")
    
  	(setq pt18 (polar pt7 ang d3))
        (setq pt18 pt2)
  
   )
  
 (d1_extend_finish)
;;; 프레임..?
 (if (/= (strcase d1:dtype) "D")
  (progn 
  (d1_draw_frame)
  
  (command "_.mirror" "_L" "" ptc ptcn "")
  )
 )  
;; 판넬..?
  (set_col_lin_lay dor:pprop)
  
  (command "_.pline" pt7 pt14 pt15 pt16 "_C")
;; arc...?
  (set_col_lin_lay dor:aprop)
  (command "_.arc" pt15 pt17 pt18)
;; sill...
  (if (/= d1:sty "None")
    (progn
      (set_col_lin_lay dor:sprop)
      (cond
	((= (strcase d1:dtype) "A")
	 (command "_.line" pt14 (polar pt14 ang (- d3 (- d1:dpt 5))) ""))
	((= (strcase d1:dtype) "B")
	 (command "_.line" (setq p (polar (polar pt14 ang1 (/ (distance pt14 pt7) (sqrt 2) )) ang (/ (distance pt14 pt7) (sqrt 2))))
		      		  (polar p ang (- d3 (* (/ (distance pt14 pt7) (sqrt 2)) 2))) ""))
	((= (strcase d1:dtype) "C")
	 (command "_.line" pt7 (polar pt7 ang d3) ""))
	
	)
     (if (/= (strcase d1:dtype) "D")
     	(command "_.line" pt9 (polar pt9 ang (- d3 30)) "")
      )
      
      (if (= d1:sty "Threshold")
        (if (or (= d1:frt "C") (= d1:frt "F"))
          (command "_.line" pt11 (polar pt11 ang (- d3 30)) "")
          (command "_.line" pt11 (polar pt11 ang d3) "")
        )
      )
    )
  )
)
;------------------------------------------------------------d2 complex

(defun d2_dd (/ kn d1wf2 d1ww2 p1 p2 pk1 pk2 poly)
 
 (setq 
  tmplen (* (* 2 d3) (/ d1:pn1 (float (+ d1:pn1 d1:pn2))))  ;; 문크기 다를때	
  tmpC (polar pt7 ang tmplen)                               ;; 그때 중점
 )
  (cond
    ((= (strcase d1:dtype) "E") 
      (setq
        pt14  (polar pt7 ang (- d1:dpt 5))
        pt15  (polar pt14 ang1 d3)
        pt16  (polar pt7 ang1 d3)
        pt17  (polar pt7 ang2 d3)
      )
    )
    ((= (strcase d1:dtype) "F")                                 
      (setq
        pt14  (polar pt7 (-  (* ang 2) ang2) (- d1:dpt 5))
        pt15  (polar pt14 ang2 d3)
        pt16  (polar pt7  ang2 d3)
        pt17  (polar pt7 (interang ang2 ang) d3)
      )
    )

    
    ((= (strcase d1:dtype) "G")
      (setq
	pt14  (polar pt7  ang1 (- d1:dpt 5))
        pt15  (polar pt14 ang4 d3)
        pt16  (polar pt7  ang4 d3)
        pt17  (polar pt7  ang1 d3)
	)
    )	
    ((= (strcase d1:dtype) "H") 
      (setq

	
	pt14  (polar pt7 ang (- d1:dpt 5))
        pt15  (polar pt14 ang1 tmplen)
        pt16  (polar pt7 ang1 tmplen)
        pt17  (polar pt7 ang2 tmplen)
	
	pt7_1 (polar pt7 ang (* 2 d3))

	pt14_1  (polar pt7_1 (+ (dtr 180) ang) (- d1:dpt 5))
        pt15_1  (polar pt14_1 ang1 (- (* 2 d3) tmplen))
        pt16_1  (polar pt7_1 ang1 (- (* 2 d3) tmplen))
        pt17_1  (polar pt7_1 (+ (- ang1 ang) ang2) (- (* 2 d3) tmplen))
	;tmpC (polar tmpc ang1 (- d1:dpt 5))

      )
    )    
  )

  (d1_extend_finish)
;;; 프레임..?
  (d1_draw_frame)
  (setq ptcn (polar pt7 ang d3))
  (command "_.mirror" "_L" "" ptc ptcn "")

 (if (/= (strcase d1:dtype) "H")
  (progn
 	;; 판넬..?
	  (set_col_lin_lay dor:pprop)   
	  (command "_.pline" pt7 pt14 pt15 pt16 "_C")
	  (ssget "L")
	;; arc...?
	  (set_col_lin_lay dor:aprop)
	 (command "_.arc" pt15 pt17 ptcn)
	 (command "_.mirror" "_L" "_P" "" ptc ptcn "")
  )
    (progn
	 ;; 판넬..?
	  (set_col_lin_lay dor:pprop)   
	  (command "_.pline" pt7 pt14 pt15 pt16 "_C")
      
	  ;(ssget "L")
	;; arc...?
	  (set_col_lin_lay dor:aprop)
	  (command "_.arc" pt15 pt17 tmpC)
	  (set_col_lin_lay dor:pprop)
	  (command "_.pline" pt7_1 pt14_1 pt15_1 pt16_1 "_C")
	  ;(ssget "L")
	  (set_col_lin_lay dor:aprop)
	  (command "_.arc" pt15_1 pt17_1 tmpC)
             
     )
   )

 ;;;sill...?   
  (if (/= d1:sty "None")
    (progn
      (set_col_lin_lay dor:sprop)
      (if (/= (strcase d1:dtype) "F")
	(if (= (strcase d1:dtype) "G")
	  	(command "_.line" pt7 (polar pt7 ang (* d3 2)) "")
      		(command "_.line" pt14 (polar pt14 ang (* (- d3 (- d1:dpt 5)) 2)) "")
	)
	(command "_.line" (setq p (polar (polar pt14 ang1 (/ (distance pt14 pt7) (sqrt 2) )) ang (/ (distance pt14 pt7) (sqrt 2))))
		          (polar p ang (* (- d3 (* (/ (distance pt14 pt7) (sqrt 2)) 2)) 2)) "")
      )
      (command "_.line" pt9 (polar pt9 ang (- (* 2 d3) 30)) "")
      (if (= d1:sty "Threshold")
        (if (or (= d1:frt "C") (= d1:frt "F"))
          (command "_.line" pt11 (polar pt11 ang (- (* 2 d3) 30)) "")
          (command "_.line" pt11 (polar pt11 ang (* 2 d3)) "")
        )
      )
    )
  )
)




(defun d1_init ()

  ;;
  ;; Resets entity list to original values.  Called when the dialogue or function 
  ;; is cancelled.
  ;;
  (defun reset ()
    (if (not d1:dpt) (setq d1:dpt (+ 25 door_gap)))
    (setq reset_flag t)
  )

  (defun d1_set (/ changed?)

    (cond
      ((= ci_mode "ib_wall_1")
        (setq d1:wal  "wall_1")
      )
      ((= ci_mode "ib_wall_2")
        (setq d1:wal  "wall_2")
      )
      ((= ci_mode "ib_wall_3")
        (setq d1:wal  "wall_3")
      )      
      ((= ci_mode "ib_wall_4")
        (setq d1:wal  "wall_4")
        (setq d1_frw_chk "0")
        (if (= d1:frt "D") (setq d1:frt "A"))
        (if (= d1:frt "E") (setq d1:frt "F"))
        (if (= d1:frt "F") (setq d1:frt "C"))
      )
    )
  (PROP_SAVE dor:prop)
  (if changed? (WriteF "PropType.dat" "prop"))
  )

  ;;
  ;; Common properties for all entities
  ;;
  (defun set_tile_props ()

    (set_tile "error" "")
    (set_tile rd_door_prop_type "1")
    (@get_eval_prop rd_door_prop_type dor:prop)
    
    (cond
      ((= d1:wal "wall_1") 
        (setq ci_mode "ib_wall_1")
      )
      ((= d1:wal "wall_2")
        (setq ci_mode "ib_wall_2")
      )
      ((= d1:wal "wall_3")
        (setq ci_mode "ib_wall_3")
      )
      
      ((= d1:wal "wall_4")
       (setq ci_mode "ib_wall_4")
      )
    )
    
    
    (set_tile "tx_type" C_door_type)
    
    ; sill타입 셑
    (radio_si)
    ; 도아타입 셑
   
    ;door_option
    (set_tile "ed_opn_size" (rtos d1:owd))
    (set_tile "ed_panel_thick" (rtos d1:dpt))
    (set_tile "ed_1st_panel_size" (rtos d1:pn1))    
    (set_tile "tx_2nd_panel_size" (rtos d1:pn2))
    (radio_do)
;frame_option
    (set_tile "ed_frame_size" (rtos d1:frw)) ;;이전 프레임 두께..
    (set_tile "ed_gap_size" (rtos door_gap))
    (set_tile "ed_offset" (rtos d1:odt))
(toggle_set)
;체크박스 와 그에 따른 옵션
(toggle_do)
    
    (ci_image "ib_frame_type" (strcat "cim1(fr" (strcase d1:frt T) ")"))
    

    (door_DrawImage "door_type" d1:dtype)
    
;; 벽 마감 타입 
    
    (wallImage d1:typ)
  
    (mode_tile ci_mode 4)
    
)
;;;
  (defun toggle_set (/)
    (if (= d1:widauto "1")
      (set_tile "tg_opn_size" "1")
      (set_tile "tg_opn_size" "0")
    )
    (if (= d1:offsetauto "1")
      (set_tile "tg_offset" "1")
      (set_tile "tg_offset" "0")
    )
    
    (if (= d1_frw_chk "1")
      (progn
	(set_tile "tg_frame_size" "1")
      )
      (progn
        (set_tile "tg_frame_size" "0")
	(mode_tile "f_size" 1)
      )
    )
   )

  

  ;; Set common action tiles
  ;;
  ;; Defines action to be taken when pressing various widgets.  It is called 
  ;; for every entity dialogue.  Not all widgets exist for each entity dialogue,
  ;; but defining an action for a non-existent widget does no harm.
  (defun set_action_tiles ()

   ;;;도아타입 
    (action_tile "door_type"	"(DoorTypeDlg)(radio_do)")
    (action_tile "simple"       "(radio_gaga \"simple\")")
    (action_tile "detail"       "(radio_gaga \"detail\")")

   ;property 라디오 버튼 
    (action_tile "prop_radio" "(setq rd_door_prop_type $Value)(@get_eval_prop rd_door_prop_type dor:prop)(door_DrawImage \"door_type\" d1:dtype)")

    ;; property 버튼
    (action_tile "b_color"      "(@getcolor)(door_DrawImage \"door_type\" d1:dtype)")
    (action_tile "color_image"  "(@getcolor)(door_DrawImage \"door_type\" d1:dtype)")
    (action_tile "b_name"       "(@getlayer)(door_DrawImage \"door_type\" d1:dtype)")
    (action_tile "b_line"       "(@getlin)(door_DrawImage \"door_type\" d1:dtype)")
    (action_tile "bn_type"       "(ttest)")
    
   ;; c_bylayer
   ;; t_bylayer 삽입
    (action_tile "c_bylayer"       "(@bylayer_do T)(door_DrawImage \"door_type\" d1:dtype)")
    (action_tile "t_bylayer"       "(@bylayer_do nil)(door_DrawImage \"door_type\" d1:dtype)")
    

   ;; Door_option
    
    (action_tile "tg_opn_size" "(toggle_do)")
    (action_tile "ed_opn_size" "(getValuechk $value \"ed_opn_size\")")
    (action_tile "ed_panel_thick" "(getValuechk $value \"ed_panel_thick\")")
    (action_tile "ed_1st_panel_size" "(getValuechk $value \"ed_1st_panel_size\")")
    (action_tile "tx_2nd_panel_size" "(getValuechk $value \"tx_2nd_panel_size\")")

    
   ;;frame option 
    (action_tile "ib_frame_type"   "(get_ftype)")
    (action_tile "bn_frame_type"   "(get_ftype)")
    (action_tile "ed_frame_size"   "(getValuechk $value \"ed_frame_size\")")
    (action_tile "ed_gap_size"     "(getValuechk $value \"ed_gap_size\")");;
    (action_tile "ed_offset"       "(getValuechk $value \"ed_offset\")");;

    ;; check box
    (action_tile "tg_frame_size"   "(toggle_do)")
    (action_tile "tg_offset"       "(toggle_do)")
    (action_tile "tg_opn_size"     "(toggle_do)");;;
  
     
   ;sill 라디오 
    (action_tile "rd_sill_2"         "(radio_gaga \"sill\")")
    (action_tile "rd_thres"        "(radio_gaga \"thres\")")
    (action_tile "rd_none"         "(radio_gaga \"none\")")
   ;; 벽 마감입
    (action_tile "ib_wall_1"         "(mode_tile ci_mode 4)(setq ci_mode \"ib_wall_1\")(mode_tile \"ib_wall_1\" 4)(setq d1:wal \"wall_1\") ")
    (action_tile "ib_wall_2"         "(mode_tile ci_mode 4)(setq ci_mode \"ib_wall_2\")(mode_tile \"ib_wall_2\" 4)(setq d1:wal \"wall_2\") ")
    (action_tile "ib_wall_3"         "(mode_tile ci_mode 4)(setq ci_mode \"ib_wall_3\")(mode_tile \"ib_wall_3\" 4)(setq d1:wal \"wall_3\") ")
    (action_tile "ib_wall_4"         "(mode_tile ci_mode 4)(setq ci_mode \"ib_wall_4\")(mode_tile \"ib_wall_4\" 4)(setq d1:wal \"wall_4\") ")
    (action_tile "bn_type_save"      "(readF \"DoorType.dat\" nil)(ValueToList)(writeF \"DoorType.dat\" nil)")
;; 
    (action_tile "accept"       "(dismiss_dialog 1)")
    (action_tile "cancel"       "(dismiss_dialog 0)")
    (action_tile "help"         "(cim_help \"D1\")")
  )
  
  (defun wallImage (pushed)
   (cond
     ((= pushed "simple")
	(ci_image "ib_wall_1" "cim2(d1s_5)")
	(ci_image "ib_wall_2" "cim2(d1s_8)")
        (ci_image "ib_wall_3" "cim2(d1s_6)")
	(ci_image "ib_wall_4" "cim2(d1s_7)")
      )
     ((= pushed "detail")
        (ci_image "ib_wall_1" "cim2(d1_5)")
        (ci_image "ib_wall_2" "cim2(d1_8)")
        (ci_image "ib_wall_3" "cim2(d1_6)")
        (ci_image "ib_wall_4" "cim2(d1_7)")
      )
  )
 )



  (defun radio_gaga (pushed)
    (cond 
      ((= pushed "simple")
        (set_tile "simple" "1")
        (mode_tile "sill_type_radio" 1)

        (set_tile "rd_none" "1") (setq d1:sty "None")
        (mode_tile "rd_prop_panel" 1)
        (mode_tile "rd_prop_frame" 1)
        (mode_tile "rd_prop_sill" 1)
        (set_tile "rd_prop_arc" "1") ;(propSet "p_arc")
 
        (mode_tile "ed_panel_thick" 1)   
        (wallImage pushed)
        (mode_tile ci_mode 4)
        (setq d1:typ "simple")
      
      )
      ((= pushed "detail")
        (set_tile "detail" "1")
        (mode_tile "sill_type_radio" 0)
        (mode_tile "rd_prop_panel" 0)
        (mode_tile "rd_prop_frame" 0)
        (mode_tile "rd_prop_sill" 0)

        (mode_tile "finish" 0)

        (mode_tile "ed_panel_thick" 0)
        (setq d1:typ "detail")
 

       
        (if  (not d1:sty);;;;;(or (not d1:sil) (= d1:sil "None"))
          (progn
            (mode_tile "s_color" 1)
            (mode_tile "sill_color" 1)
            (mode_tile "st_color" 1)
          )
        )
     
	(wallImage pushed)
        (mode_tile ci_mode 4)
        (setq d1:typ "detail")
        (if (= d1_frw_chk "0")
          (mode_tile "ed_frame_size" 1)
        )
      )           
      ((= pushed "sill")
        (setq d1:sty "Sill")
        
      )
      ((= pushed "thres")
        (setq d1:sty "Threshold")
       
      )  
      ((= pushed "none")
        (setq d1:sty "None")
       
      )           
    )
         (door_DrawImage "door_type" d1:dtype )
    	 
  )


  (defun radio_do ()
    (cond
      ((= d1:typ "simple")
        (radio_gaga "simple" )
      )
      ((= d1:typ "detail")
        (radio_gaga  "detail" )
      )
    )
    (if (= (strcase d1:dtype) "H")
            (progn (mode_tile "ed_1st_panel_size" 0) (mode_tile "tx_2nd_panel_size" 0) (set_tile "tx_2nd_panel_size" (rtos (- d1:owd d1:pn1))))
	    (progn (mode_tile "ed_1st_panel_size" 1) (mode_tile "tx_2nd_panel_size" 1) (set_tile "tx_2nd_panel_size" ""))
    )   
  )

  (defun radio_si ()
    (cond
      ((= d1:sty "Sill")
        (set_tile "rd_sill_2" "1")
      )
      ((= d1:sty "Threshold")
        (set_tile "rd_thres" "1")
      )
      (T
        (set_tile "rd_none" "1")
      )
    )
  )

  (defun toggle_do ()
    (setq d1_frw_chk (get_tile "tg_frame_size"))
    (setq d1:widauto (get_tile "tg_opn_size"))
    (setq d1:offsetauto (get_tile "tg_offset"))
  ;  (setq doorwid (get_tile "ed_opn_size"))
    (cond
      ((= d1:offsetauto "1")
       (mode_tile "ed_offset" 0)
       (setq d1:odt (atof (get_tile "ed_offset")))
      )
      ((= d1:offsetauto "0")
       (mode_tile "ed_offset" 1)
      )
    )    
    (cond
      ((= d1:widauto "1")       
       (mode_tile "ed_opn_size" 0)
       (setq d1:owd (atof (get_tile "ed_opn_size")))
      )
      ((= d1:widauto "0")
       (mode_tile "ed_opn_size" 1)
      )
    )  
    (cond
        
        ((= d1_frw_chk "1")
	  (mode_tile "ed_frame_size" 0)
	  (setq d1:frw (atof (get_tile "ed_frame_size")))
	)
	((= d1_frw_chk "0")
	  (mode_tile "ed_frame_size" 1)
        )
 	)
    
    
  )



  (defun get_ftype (/ fr_list fr_key frn $key fr_mode)
    (if (not (new_dialog "set_frame_type" dcl_id)) (exit))
    (setq fr_list '("a" "b" "c" "d" "e" "f"))
    (foreach frn fr_list
      (setq fr_key (strcat "ib_frame_" frn))
      (start_image fr_key)
      (slide_image
        0 0
        (- (dimx_tile fr_key) 1)
        (- (dimy_tile fr_key) 1)
        (strcat "cim1(fr" frn ")")
      )
      (if (= (strcase frn) d1:frt)
        (mode_tile fr_key 2)
      )
      (end_image)
    )
    (setq fr_mode (strcat "ib_frame_" (strcase d1:frt T)))
    (mode_tile fr_mode 4)

    (foreach frn fr_list
      (action_tile (strcat "ib_frame_" frn)
        "(mode_tile fr_mode 4)(setq fr_mode $key)(mode_tile fr_mode 4)"
      )
    )

    (if (= (start_dialog) 1) ; User pressed OK
      (if (/= d1:frt (strcase (substr fr_mode 10)))
        (progn
          (setq d1:frt (strcase (substr fr_mode 10)))
          (ci_image "ib_frame_type" (strcat "cim1(fr" (substr fr_mode 10) ")"))
        )
      )
    )
  )


  ;;
  ;; Checks validity of thickness from edit box.
  (defun getValuechk (value key_val)
   (cond
     ((= key_val "ed_opn_size") (setq d1:owd (verify_d "ed_opn_size" value d1:owd)))    
     ((= key_val "ed_panel_thick") (setq d1:dpt (verify_d "ed_panel_thick" value d1:dpt)))
     ((= key_val "ed_1st_panel_size") (setq d1:pn1 (verify_d "ed_1st_panel_size" value d1:pn1)))
     ;((= key_val "ed_2nd_panel_size") (setq d1:pn2 (verify_d "ed_2nd_panel_size" value d1:pn2)))
     
     ((= key_val "ed_gap_size") (setq door_gap (verify_d "ed_gap_size" value door_gap)))
     ((= key_val "ed_frame_size") (setq d1:frw (verify_d "ed_frame_size" value d1:frw)))
;     ((= key_val "finish") (setq d1:wft (verify_d "finish" value d1:wft)))
     ((= key_val "ed_offset") (setq d1:odt (verify_d "ed_offset" value d1:odt)))

   )
  )


  (defun verify_d (tile value old-value / coord valid errmsg)
    (setq valid nil errmsg "Invalid input value.")
    (if (setq coord (distof value))
      (progn
        (cond
	  ((and (= tile "ed_opn_size")(= (strcase d1:dtype) "H"))
	   (if (> coord 0)
	   (progn
	     (setq valid T)
	     (setq d1:pn2 (- coord d1:pn1 ))
	     (if (< d1:pn2 0) (setq d1:pn2 0))
	     (set_tile "tx_2nd_panel_size" (rtos d1:pn2))
	   )
	   (setq errmsg "Value must be positive and nonzero.")
            )
          
	  )
          ((= tile "ed_1st_panel_size")
            (if (>= coord 0)
	      (progn
              	(setq valid T)
		(setq d1:pn2 (- d1:owd coord))
		(if (< d1:pn2 0) (setq d1:pn2 0))
		(set_tile "tx_2nd_panel_size" (rtos d1:pn2))
	      )
              (setq errmsg "Value must be positive and nonzero.")
            )
          )
          ((or (= tile "ed_panel_thick") 
	       (= tile "ed_gap_size") (= tile "ed_offset"))
            (if (>= coord 0)
              (setq valid T)
              (setq errmsg "Value must be positive or zero.")
            )
          )
          ((= tile "ed_frame_size")
            (if (> coord 0)
              (if (>= coord (+ 10 d1:dpt))
                (setq valid T)
                (setq errmsg (strcat
                  "Value must be not less than \"panel_Thickness + 10: "
                  (rtos (+ 10 d1:dpt)) "\".")
                )
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
      (done_dialog 0)
      (if (= (get_tile "error") "")
        (done_dialog action)
      )
    )
  )

  
  
(defun ttest (/ old_door_type)
 (readF "DoorType.dat" nil)
 (setq  old_door_type C_door_type)
 (setq L_index (Find_index old_door_type))
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
    )

)
(defun set_tileS ()
 
 (if (= L_index nil) (setq L_index 0 ))
 (setq C_door_type (nth 0 (cdr (nth L_index @Type))))  
 (set_tile "list_type" (rtos L_index)) 
 (set_tile "current_type" old_door_type)
 (set_tile "ed_type_name" C_door_type)
)
  
(defun action_Tiles ()
 (action_tile "list_type" "(setq C_door_type (Field_match \"타입명\" (setq L_index (atoi $value))))(set_tileS)")
 (action_tile "accept" "(qqqq)")
 (action_tile  "cancel" "(setq C_door_type old_door_type)")
 (action_tile "eb_del_type" "(deleteIdx 'C_door_type)(set_tileS)")
 (action_tile "eb_ren_type" "(renameIdx 'C_door_type)(set_tileS)")
 (action_tile "eb_new_type" "(newIdx 'C_door_type)(set_tileS)")
)
(defun qqqq()
  (Set_Door_Value)(writeF "Doortype.dat" nil)(done_dialog 1)(set_tile_props)
)  
) ; end d1_init

(defun d1_do ()
  (if (not (new_dialog "dd_door" dcl_id)) (exit))
  (set_tile_props)
  (set_action_tiles)
  (setq dialog-state (start_dialog))
  (if (= dialog-state 0)
    (reset)
  )
)

(defun d1_return ()
  (setq dor:pprop old_pprop 
	dor:fprop old_fprop 
	dor:sprop old_sprop 
	dor:aprop old_aprop 
        d1:dpt  old_dpt
        d1:frt  old_frt
        d1:typ  old_typ
        d1:wal  old_wal
        
        d1:wft  old_wft
      ;;  d1:sil  old_sil
        d1:sty  old_sty
  )
)
;;; ================== (dd_d1) - Main program ========================
;;;
;;; Before (dd_d1) can be called as a subroutine, it must
;;; be loaded first.  It is up to the calling application to
;;; first determine this, and load it if necessary.

(defun dd_d1 (/
           dcl_id           dialog-state     dismiss_dialog
           getfsize
           ltest_ok          
           old_dpt          old_frt
           old_typ          old_wal          old_wtyp         old_wft
           old_sil          radio_do         radio_gaga
           reset            reset_flag       
           set_action_tiles set_tile_props
           toggle_do        verify_d
           old_sty          toggle_set
	   ttest  set_tileS action_Tiles qqqq 
	   ValueToList  )
  




(defun ValueToList(/ tmplist newlist opning tnnp tmm widauto frauto 1or2)
  (setq tmplist (nth L_index @type))
  (setq widauto (if (= d1:widauto "1") "o" "x"))
  (setq  frauto  (if (= d1_frw_chk "1") "o" "x"))
  (setq opning (cond ((or (= d1:dtype "A") (= d1:dtype "E") (= d1:dtype "H")) "90'")
		     ((or (= d1:dtype "B") (= d1:dtype "D") (= d1:dtype "F")) "45'")
		     ((or (= d1:dtype "C") (= d1:dtype "G")) "180'")))
  (setq tnnp (cond
	         ((= d1:wal  "wall_4") "D-Type")
		 ((= d1:wal "wall_1") "A-Type")
		 ((= d1:wal "wall_2") "B-Type")
		 ((= d1:wal "wall_3") "C-Type")))
  (setq 1or2 (if (or (= d1:dtype "A") (= d1:dtype "B")(= d1:dtype "C")(= d1:dtype "D")) "1" "2"))
  (setq tmm (list C_door_type (strcat 1or2 "-Door[" (strcase d1:dtype) "]") (rtos d1:owd) opning (rtos d1:dpt) 
		  (strcat d1:frt "-Type") d1:sty tnnp d1:typ
		  (rtos door_gap) widauto frauto (get_tile "ed_frame_size")))
  (setq newlist (cons (1+ L_index) tmm))
  (setq @type (subst newlist tmplist @Type) )
)


;;;  (setvar "cmdecho" (cond (  (or (not *debug*) (zerop *debug*)) 0)
;;;                          (t 1)))
  (setq old_pprop dor:pprop
	old_fprop dor:fprop
	old_sprop dor:sprop
	old_aprop dor:aprop
        old_dpt  d1:dpt
        old_frt  d1:frt
        old_typ  d1:typ
        old_wal  d1:wal
        
        old_wft  d1:wft
   ;;     old_sil  d1:sil
        old_sty  d1:sty
  )

 
  (cond

     (  (not (ai_acadapp)))                      ; ACADAPP.EXP xloaded?
     ((not (setq dcl_id (load_dialog "LtDoor.dcl")))) ;;;(ai_dcl "doorLT"))))     ; is .DLG file loaded?

     (t (ai_undo_push)
        (d1_init)                              ; everything okay, proceed.
        (d1_do)
     )
  )
  (if reset_flag
    (d1_return)
    (d1_set)
  )
  (if dcl_id (unload_dialog dcl_id))
)




(defun Set_Door_Value(/ tnnp)
  
  (setq d1:dtype (strcase (substr (Field_match "문타입" L_index) 8 1)))
  (setq d1:frt (substr (Field_match "프레임타입" L_index) 1 1))
  (setq d1:typ (Field_match "디테일" L_index))
  
  (setq d1:owd (atof (Field_match "문폭" L_index)))

  (setq tnnp (Field_match "벽마감타입" L_index))
  (setq d1:wal (cond
		 ((= tnnp "A-Type") "wall_1")
		 ((= tnnp "B-Type") "wall_2")
		 ((= tnnp "C-Type") "wall_3")
		 (T "wall_4")
		 ))
  (setq d1:frw (atof (Field_match "프레임크기" L_index)))
  (setq d1:sty (Field_match "Sill_Type" L_index))
  (setq door_gap (atof (Field_match "door_gap" L_index)))
  (setq d1:widauto (if (= (field_match "문크기고정" L_index) "o") "1" "0"))
  (setq d1_frw_chk (if (= (field_match "프레임크기고정" L_index) "o") "1" "0"))
)

 (if (null C_door_type)
   (progn
   (setq dor:pprop  (Prop_search "door" "panel"))
   (setq dor:fprop  (Prop_search "door" "frame"))
   (setq dor:sprop  (Prop_search "door" "sill"))
   (setq dor:aprop  (Prop_search "door" "arc"))
   (setq dor:prop '(dor:pprop dor:fprop dor:sprop dor:aprop))
   (readF "DoorType.dat" nil) (setq L_index 0)
   (setq C_door_type (nth 0 (cdr (nth L_index @Type))))
   (Set_Door_Value)
   ))

	(if (null d1:dpt)  (setq d1:dpt (+ 25 door_gap)))  ;판넬 두께

	(if (null d1:wal) (setq d1:wal "wall_1"))
	(if (null d1:wft)  (setq d1:wft 18))

	(if (null rd_door_prop_type) (setq rd_door_prop_type "rd_panel"))

   	(if (null d1:1owd) (setq d1:1owd 900))      ;문 너비  한짝문일때..
        (if (null d1:2owd) (setq d1:2owd 1800))
        (if (and (>= (ascii (strcase d1:dtype)) 69) (<= (ascii (strcase d1:dtype)) 72) ) ;두짝문.
	  (setq d1:owd d1:2owd)
	  (setq d1:owd d1:1owd)
	)
  
  	(if (null d1:pn1) (setq d1:pn1 600))    ; 1번문 너비
  	(if (null d1:pn2) (setq d1:pn2 1200))   ; 2번문 너비


  	(if (null d1:odt) (setq d1:odt 0))	;offset distance
	(if (null d1:widauto) (setq d1:widauto "1"))

(defun C:CIMDOOR () (m:dp))
(setq lfn18 1)
(princ)