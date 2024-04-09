
;단축키 관련 변수 정의 부분 .. 맨뒤로
 
(defun Draw_Image_X( / )
(defun swe_DrawImage (swe_key !swetype! / fcolor ccolor mcolor  )
  (setq fcolor (propcolor swe:fprop))
  (setq ccolor (propcolor swe:cprop))  
  (setq mcolor (propcolor swe:mprop)) 
;  (setq gcolor (propcolor swe:gprop))
  
    (do_blank swe_key 0)
    (start_image swe_key)          
           (cond
             ((= !swetype! 0) (drawSwinImage_3))
             ((<= !swetype! 2) (drawSwinImage_1))
             ((= !swetype! 3) (drawSwinImage_2))
           )
    (end_image)
)

(defun drawSwinImage_1(/ cx cy dx dy x1 x2 x3 x4 x5 
                                     y1 y2 y3 y4 mx1 mx2 mx3 mx4 my1 my2 my3)

  (setq cx (dimx_tile swe_key)
          cy (dimy_tile swe_key)
          dx (/ cx 30) 
          dy (/ cy 20) 
          x1 (* dx 2) x2 (* dx 3) x3 (* dx 4) x4 (* dx 15) x5 (* dx 16)         
          y1 (* dy 2) y2 (* dy 3) y3 (* dy 4) y4 (* dy 17) 
          mx1 (* dx 13) mx2 (* dx 14) mx3 (* dx 17) mx4 (* dx 18)
          my1 (* dy 9) my2 (* dy 10) my3 (* dy 11)
    )

;;;        (if (= swe:gap_chk "1")
;;;                (drawImage_box (* dx 1) (* dy 1) (* dx 29) (* dy 18) gcolor))
        (drawImage_box x1 y1 (* dx 27) (* dy 16) fcolor)
        (drawImage_box x2 y2 (* dx 25) (* dy 14) fcolor)
        (drawImage_box x3 y3 (* dx 11) (* dy 12) ccolor)
        (drawImage_box x5 y3 (* dx 11) (* dy 12) ccolor)
        (if (= swe:typ "a")
                (vector_image  x4 y2 x4 y4 ccolor)
                (vector_image  x5 y2 x5 y4 ccolor))
        (if (= swe:mark_chk "1") (progn
                (vector_image  mx1 my1 mx2 my2 mcolor)
                (vector_image  mx2 my2 mx1 my3 mcolor)
                (vector_image  mx1 my3 mx1 my1 mcolor)
                (vector_image  mx3 my2 mx4 my1 mcolor)
                (vector_image  mx4 my1 mx4 my3 mcolor)
                (vector_image  mx4 my3 mx3 my2 mcolor)
         ))
)

(defun drawSwinImage_2( / cx cy dx dy 
                x1 x2 x3 x4 x5        x6 x7 y1 y2 y3 y4 mx1 mx2 mx3 mx4 mx5 mx6 my1 my2 my3)
 (setq    cx (dimx_tile swe_key)
          cy (dimy_tile swe_key)
          dx (/ cx 30) 
          dy (/ cy 20) 
          x1 (* dx 2)  x2 (* dx 3) x3 (* dx 4) x4 (* dx 11)
          x5 (* dx 12) x6 (* dx 19) x7 (* dx 20)
          y1 (* dy 2) y2 (* dy 3) y3 (* dy 4) y4 (* dy 17)
          mx1 (* dx 9) mx2 (* dx 10) mx3 (* dx 13) mx4 (* dx 14)
          mx5 (* dx 21) mx6 (* dx 22)
          my1 (* dy 9) my2 (* dy 10) my3 (* dy 11))

;;;        (if (= swe:gap_chk "1")
;;;                (drawImage_box (* dx 1) (* dy 1) (* dx 29) (* dy 18) gcolor))
        (drawImage_box x1 y1 (* dx 27) (* dy 16) fcolor)
        (drawImage_box x2 y2 (* dx 25) (* dy 14) fcolor)
        (drawImage_box x3 y3 (* dx 7)  (* dy 12) ccolor)
        (drawImage_box x5 y3 (* dx 7)  (* dy 12) ccolor)
        (drawImage_box x7 y3 (* dx 7)  (* dy 12) ccolor)
        (if (= swe:typ "a")(progn        
                (vector_image  x4 y2 x4 y4 ccolor)
                (vector_image  x7 y2 x7 y4 ccolor))
        (progn
                (vector_image  x5 y2 x5 y4 ccolor)
                (vector_image  x6 y2 x6 y4 ccolor)))
        
        (if (= swe:mark_chk "1")(progn
                (vector_image  mx1 my1 mx2 my2 mcolor)
                (vector_image  mx2 my2 mx1 my3 mcolor)
                (vector_image  mx1 my3 mx1 my1 mcolor)
                (vector_image  mx3 my2 mx4 my1 mcolor)
                (vector_image  mx4 my1 mx4 my3 mcolor)
                (vector_image  mx4 my3 mx3 my2 mcolor)
                (vector_image  mx5 my2 mx6 my1 mcolor)
                (vector_image  mx6 my1 mx6 my3 mcolor)
                (vector_image  mx6 my3 mx5 my2 mcolor))
        )
)

(defun drawSwinImage_3(/ cx cy dx dy 
                x1 x2 x3 x4 x5        x6 x7 x8 x9 y1 y2 y3 y4
                mx1 mx2 mx3 mx4 mx5 mx6 mx7 mx8 my1 my2 my3)
 (setq    cx (dimx_tile swe_key)
          cy (dimy_tile swe_key)
          dx (/ cx 30) 
          dy (/ cy 20)
        x1 dx x2  (* dx 2) x3 (* dx 3) x4 (* dx 8) x5 (* dx 9)
        x6  (* dx 15) x7  (* dx 16) x8  (* dx 21) x9  (* dx 22)
        y1  (* dy 2) y2  (* dy 3) y3  (* dy 4) y4  (* dy 17)
        mx1  (* dx 6) mx2  (* dx 7) mx3  (* dx 10) mx4  (* dx 11)
        mx5  (* dx 19) mx6  (* dx 20) mx7  (* dx 23) mx8  (* dx 24)
        my1  (* dy 9) my2  (* dy 10) my3  (* dy 11))
 
;;;        ( if (= swe:gap_chk "1")
;;;                (drawImage_box (* dx 1) (* dy 1) (* dx 29) (* dy 18) gcolor))
        (drawImage_box x1 y1 (* dx 28) (* dy 16) fcolor)
        (drawImage_box x2 y2 (* dx 26) (* dy 14) fcolor)
        (drawImage_box x3 y3 (* dx 5)  (* dy 12) ccolor)
        (drawImage_box x5 y3 (* dx 5)  (* dy 12) ccolor)
        (drawImage_box x7 y3 (* dx 5)  (* dy 12) ccolor)
        (drawImage_box x9 y3 (* dx 5)  (* dy 12) ccolor)
        (vector_image  x6 y2 x6 y4 ccolor)
        (if (= swe:typ "a")(progn
                (vector_image  x4 y2 x4 y4 ccolor)
                (vector_image  x9 y2 x9 y4 ccolor))
                (progn
                (vector_image  x5 y2 x5 y4 ccolor)
                (vector_image  x8 y2 x8 y4 ccolor)))
        (if (= swe:mark_chk "1")(progn
                (vector_image  mx1 my1 mx2 my2 mcolor)
                (vector_image  mx2 my2 mx1 my3 mcolor)
                (vector_image  mx1 my3 mx1 my1 mcolor)
                (vector_image  mx3 my2 mx4 my1 mcolor)
                (vector_image  mx4 my1 mx4 my3 mcolor)
                (vector_image  mx4 my3 mx3 my2 mcolor)
                (vector_image  mx5 my1 mx6 my2 mcolor)
                (vector_image  mx6 my2 mx5 my3 mcolor)
                (vector_image  mx5 my3 mx5 my1 mcolor)
                (vector_image  mx7 my2 mx8 my1 mcolor)
                (vector_image  mx8 my1 mx8 my3 mcolor)
                (vector_image  mx8 my3 mx7 my2 mcolor)))
)
)

(defun m:swe4 (/
             ang      ang1     ang2     ang3     sc       pt1      pt2
             pt3      pt4      pt5      pt6      pt7      pt8      pt9
             pt10     pt11     pt12     pt13     pt14     pt15     pt16
             pt17     pt18     pt19     pt20     pt21     pt22     pt23
             pt24     pt25     pt26     pt1x     pt1y     pt2x     pt2y
             pt3x     pt3y     pt4x     pt4y
             strtpt   nextpt   uctr     cont     temp     tem      ptd
             ;swe4_ola swe4_oco swe4_err swe4_oer swe4_oli
             dist_V  dist_H  swe:c_size04 swe:c_size06 )
  (setq sc (getvar "dimscale"))
  (ai_err_on) 
  (ai_undo_on)
  (command "_.undo" "_group")

  
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n주택용 창호 입면 그리기 명령 입니다.")

  (setq cont T temp T uctr 0)

  (while cont
    (swe4_m1)
    (if (and (= swe:owid_chk "1") tem) (progn
                           (setq nextpt (polar strtpt swe:anh swe:wid))
                           (setq tem     nil
                                 ptd     T
                                 swe:wid (distance strtpt nextpt)
                                 swe:anh (angle strtpt nextpt)))
    (swe4_m2))
    (if (and (= swe:ohig_chk "1") ptd) (progn
                           (setq swe:anv (+ swe:anh (/ pi 2)))             
                           (setq pt4 (polar strtpt swe:anv swe:hgh))
                          (command "_.undo" "_m")
                              (setvar "osmode" 0)(setvar "blipmode" 0)
                              (swe4_ex)
                              (setq uctr (1+ uctr))
                              (setq ptd nil temp T))
    (swe4_m3))
  )

 

  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)


  (princ)
)

(defun swe4_m1 ()
  (while temp
   (setvar "osmode" (+ 1 32 128))
    (setvar "blipmode" 1)
    (if (> uctr 0)
      (progn
        (princ (strcat "\nGap_size:" (rtos swe:gap)
                       
                       "\nWidth:"    (rtos swe:wid)
                       "  Height:"   (rtos swe:hgh)))
        (initget "/ Dialog Offset Undo")
        (setq strtpt (getpoint
          "\n>>> Dialog/Offset/Undo/<좌측 하단>: "))
      )
      (progn
        (princ (strcat "\nGap_size:" (rtos swe:gap)))
                      
        (initget "/ Dialog Offset")
        (setq strtpt (getpoint
         "\n>>> Dialog/Offset/<좌측 하단>: "))
      )
    )
    (cond

      ((= strtpt "Dialog")
        (DD_swe)
      )
      ((= strtpt "Offset")
        (cim_ofs)
      )
      ((= strtpt "/")
        (cim_help "SWE4")
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

(defun swe4_m2 ()
  (while tem
    
    ;(setvar "snapbase" (list (car strtpt) (cadr strtpt)))
    (initget "/ Dialog Undo")
    (setq nextpt (getpoint strtpt (strcat
      "\n>>> Dialog/Undo/<width:"
      (rtos swe:wid) ">: ")))
    ;(setvar "blipmode" 0)

    (cond

      ((= nextpt "Dialog")
        (DD_swe)
      )
      ((= nextpt "/")
        (cim_help "SWE4")
      )
      ((= nextpt "Undo")
        (setq tem nil temp T)
      )
      ((null nextpt)
        (setq tem nil ptd T)
      )
      (T
        (if (< (distance strtpt nextpt) 600)
          (alert "Insufficient width -- Value is not less than 600")
          (setq tem     nil
                ptd     T
                swe:wid (distance strtpt nextpt)
                swe:anh (angle strtpt nextpt)
          )
        )
      )
    )
  )
)

(defun swe4_m3 ()
  (while ptd
    (setvar "blipmode" 1)
    ;(setvar "snapbase" (list (car strtpt) (cadr strtpt)))
    (initget "/ Color Gap LAyer LInetype Undo")
    (setq pt3 (getpoint strtpt (strcat
      "\n>>> Color/Gap/LAyer/LInetype/Undo/<height:"
      (rtos swe:hgh) ">: ")))
    (setvar "blipmode" 0)
    (setvar "snapbase" '(0 0))
    (cond

      ((= pt3 "Dialog")
        (DD_swe)
      )
      ((= pt3 "/")
        (cim_help "SWE4")
      )
      ((= pt3 "Undo")
        (setq ptd nil tem T)
      )
      ((null pt3)
        (command "_.undo" "_m")
        (setvar "osmode" 0)
        (swe4_ex)
        (setq uctr (1+ uctr))
        (setq ptd nil temp T)
      )
      (T
        (if (< (distance strtpt pt3) 200)
          (alert "Insufficient height -- Value is not less than 200")
          (progn
            (setq swe:hgh (distance strtpt pt3)
                  swe:anv (+ swe:anh (/ pi 2))
            )
            (command "_.undo" "_m")
            (setvar "osmode" 0)
            (swe4_ex)
            (setq uctr (1+ uctr))
            (setq ptd nil temp T)
          )
        )
      )
    )
  )
)

(defun swe4_ex (/ Tang Tang1 tmpgap)
  (setq tmpgap (if (= swe:gap_chk "0") 0 swe:gap)
            pt1  strtpt
        pt2  (polar pt1 swe:anh swe:wid)
        pt4  (polar pt1 swe:anv swe:hgh)
        pt3  (polar pt2 swe:anv swe:hgh)
        ang  swe:anh
        ang1 (+ swe:anh pi ) ;;(angle pt2 pt1)
        ang2 swe:anv
        ang3 (+ swe:anv pi );(angle pt4  pt1)
        pt5  (polar pt1  ang  tmpgap)
        pt5  (polar pt5  ang2 tmpgap)
        pt6  (polar pt2  ang1 tmpgap)
        pt6  (polar pt6  ang2 tmpgap)
        pt7  (polar pt3  ang1 tmpgap)
        pt7  (polar pt7  ang3 tmpgap)
        pt8  (polar pt4  ang  tmpgap)
        pt8  (polar pt8  ang3 tmpgap)
        pt9  (polar pt5  ang  swe:frw)    ;;; 40 프레임
        pt9  (polar pt9  ang2 swe:frw)
        pt10 (polar pt6  ang1 swe:frw)
        pt10 (polar pt10 ang2 swe:frw)
        pt11 (polar pt7  ang1 swe:frw)
        pt11 (polar pt11 ang3 swe:frw)
        pt12 (polar pt8  ang  swe:frw)
        pt12 (polar pt12 ang3 swe:frw)
        pt13 (polar pt11 (angle pt11 pt12) (/ (distance pt11 pt12) 2) )
        pt14 (polar pt9 (angle pt9 pt10) (/ (distance pt9 pt10) 2) )
        dist_V (distance pt13 pt14)
        dist_H (distance pt11 pt12)

  )

  (setq swe:c_size04 (* swe:c_size 0.4))
  (setq swe:c_size06 (* swe:c_size 0.6))
  
  (if (and (/= swe:gap 0) (/= swe:gap_chk "0"))
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
;;;      (command "_.layer" "_s" "CEN" "")
      (set_col_lin_lay swe:gprop)
      (command "_.LINE" pt1x pt2x "")
      (command "_.LINE" pt2y pt3y "")
      (command "_.LINE" pt3x pt4x "")
      (command "_.LINE" pt4y pt1y "")
;;;      (command "_.layer" "_s" prj:lay "")
    )
  )
  (set_col_lin_lay swe:fprop)
  (command "_.pline" pt5 pt6 pt7 pt8 "_C")
  (command "_.pline" pt9 pt10 pt11 pt12 "_C")

  
(if (= (rem swe:num 2) 1)
   (Draw_winelev1)
   (Draw_winelev2))
);; end swe4_ex

(defun Draw_winelev1()
 (setq distn (/ (- dist_H (* 0.2 swe:c_size))  swe:num )
       dn pt12)
 
 (setq k 0)
 (repeat swe:num
   (if (= swe:typ "a")
     (progn
   (cond ((= (rem k 3) 0) (swe_type dn "a"))
         ((= (rem k 3) 2) (swe_type dn "c"))
         (T (swe_type dn "b"))))
     (progn
   (cond ((= (rem k 3) 1) (swe_type dn "d"))
         ;((= (rem k 3) 2) (swe_type dn "a"))
         (T (swe_type dn "b"))))
   )  
   (setq k (1+ k))
   (setq dn (polar dn ang distn))
  )
)

(defun Draw_winelev2( / k fixn)
 (setq fixn (fix (/ swe:num 4)))
 (setq distn (/ (- dist_H (* fixn swe:c_size) (* 0.2 swe:c_size))  swe:num )
       dn pt12)
 
 (setq k 0)
 
 (repeat swe:num
   (if (= (rem k 4) 2)(progn
     (setq dn (polar dn ang swe:c_size06)) 
     (command "_.line" dn (polar dn ang3 dist_v) "")
     (setq dn (polar dn ang swe:c_size04))) )
   
   (if (= swe:typ "a")
     (progn
   (cond ((= (rem k 4) 0) (swe_type dn "a"))
         ((= (rem k 4) 3) (swe_type dn "c"))
         (T (swe_type dn "b"))))
     (progn
   (cond ((= (rem k 4) 1) (swe_type dn "c"))
         ((= (rem k 4) 2) (swe_type dn "a"))
         (T (swe_type dn "b"))))
   )  
   (setq k (1+ k))
   (setq dn (polar dn ang distn))
  )
)



;;; 
(defun swe_type (pp0 eltype / pp1 pp2 pp3 pp4 pp5 pp6 pp7 pp8)
   
  
   (setq pp1 (polar pp0 ang swe:c_size06) ;(if (= (rem k 2) 0) swe:c_size06 swe:c_size04))
          pp1 (polar pp1 ang3 swe:c_size06)
         pp2 (polar pp1 ang (- distn swe:c_size))
         pp3 (polar pp2 ang3 (- dist_V (* swe:c_size06 2)))
          pp4 (polar pp1 ang3 (- dist_V (* swe:c_size06 2)))
         pp5 (polar pp1 ang2 swe:c_size06)
         pp6 (polar pp4 ang3 swe:c_size06)
         pp7 (polar pp2 ang2 swe:c_size06)
         pp8 (polar pp3 ang3 swe:c_size06)
         pp9 (polar pp7 ang3 (/ dist_V 2))
         pp9 (polar pp9 ang1 swe:c_size)
         pp10 (polar pp5 ang3 (/ dist_V 2))
         pp10 (polar pp10 ang swe:c_size)
         )
  
 (set_col_lin_lay swe:cprop)
 (cond
  ((= eltype "a") (command "_.pline" pp2 pp1 pp4 pp3 "")
                    (command "_.line" pp7 pp8 "")
                  )
  ((= eltype "b") (command "_.pline" pp2 pp1 pp4 pp3 "_c") )
  ((= eltype "c") (command "_.pline" pp1 pp2 pp3 pp4 "")
                   (command "_.line" pp5 pp6 "" )
                  )
   ((= eltype "d")(command "_.line" pp1 pp2 "" )
                 (command "_.line" pp3 pp4 "" )
                  (command "_.line" pp5 pp6 "" )
                  (command "_.line" pp7 pp8 "" )))

  (if (= swe:mark_chk "1")
    (progn
      (set_col_lin_lay swe:mprop)
  (if (or (= k (1- swe:num)) (= (rem k 2) 1))
    (command "_.solid" (polar pp10 ang2 (/ swe:c_size06 2))
                     (polar pp10 ang3 (/ swe:c_size06 2))
                     (polar pp10 ang1 swe:c_size06 )  "" "")
    (command "_.solid" (polar pp9 ang2 (/ swe:c_size06 2))
                     (polar pp9 ang3 (/ swe:c_size06 2))
                     (polar pp9 ang swe:c_size06 )  "" ""))))

)




(defun swe_init ()

  (defun swe_set (/ chnaged?)
    (PROP_SAVE swe:prop)
  )

  ;;
  ;; Common properties for all entities
  ;;
 
  
  (defun set_tile_props ()
    
    (set_tile "error" "")
    (set_tile swe_prop_type "1")                ;; prop radio
    
    (@get_eval_prop swe_prop_type swe:prop)
    (swe_DrawImage "elev_image" (rem swe:num 4))
    (set_tile "tx_type" C_swe_type)
    (set_tile (strcat swe:typ "_type") "1")
    (set_tile "opn_mark" swe:mark_chk)
    (set_tile "tg_gap_size" swe:gap_chk)
    (mode_tile "ed_gap_size" (if (= swe:gap_chk"1") 0 1)) 
    (set_tile "tg_opn_width" swe:owid_chk)
    (mode_tile "ed_opn_width" (if (= swe:owid_chk"1") 0 1)) 
    (set_tile "tg_opn_height" swe:ohig_chk)
    (mode_tile "ed_opn_height" (if (= swe:ohig_chk"1") 0 1)) 

    (set_tile "ed_gap_size" (rtos swe:gap))
    (set_tile "f_size" (rtos swe:frw))
    (set_tile "c_size" (rtos swe:c_size))
    (set_tile "num_1" (itoa swe:num))
    (set_tile "ed_opn_width" (rtos swe:wid))
    (set_tile "ed_opn_height" (rtos swe:hgh))

    
  )

  (defun set_action_tiles ()

    (action_tile "b_name"       "(@getlayer)(swe_DrawImage \"elev_image\" (rem swe:num 4))")    
    (action_tile "b_color"      "(@getcolor)(swe_DrawImage \"elev_image\" (rem swe:num 4))")
    (action_tile "color_image"  "(@getcolor)(swe_DrawImage \"elev_image\" (rem swe:num 4))")
    (action_tile "b_line"       "(@getlin)(swe_DrawImage \"elev_image\" (rem swe:num 4))")
    (action_tile "c_bylayer"    "(@bylayer_do T)(swe_DrawImage \"elev_image\" (rem swe:num 4))")
    (action_tile "t_bylayer"    "(@bylayer_do nil)(swe_DrawImage \"elev_image\" (rem swe:num 4))")

    (action_tile "bn_type"       "(ttest)")
    (action_tile "prop_radio" "(setq swe_prop_type $Value)(@get_eval_prop swe_prop_type swe:prop)(swe_DrawImage \"elev_image\" (rem swe:num 4))")
     
    (action_tile "a_type"       "(setq swe:typ \"a\") (swe_DrawImage \"elev_image\" (rem swe:num 4))")
    (action_tile "b_type"       "(setq swe:typ \"b\") (swe_DrawImage \"elev_image\" (rem swe:num 4))")
    (action_tile "opn_mark"         "(setq swe:mark_chk (get_tile \"opn_mark\"))(swe_DrawImage \"elev_image\" (rem swe:num 4))")
    (action_tile "tg_gap_size"         "(radio_gaga \"gap\")")
    (action_tile "tg_opn_width" "(radio_gaga \"width\")")
    (action_tile "tg_opn_height" "(radio_gaga \"height\")")

    (action_tile "ed_gap_size"  "(getfsize $value \"ed_gap_size\")")
    (action_tile "f_size"       "(getfsize $value \"f_size\")")
    (action_tile "swe:c_size"       "(getfsize $value \"swe:c_size\")")
    (action_tile "num_1"       "(getfsize $value \"num_1\")(swe_DrawImage \"elev_image\" (rem swe:num 4))")
;;;    (action_tile "hght_2"       "(getfsize $value \"hght_2\")")
    
    (action_tile "ed_opn_width"       "(getfsize $value \"ed_opn_width\" )")
    (action_tile "ed_opn_height"       "(getfsize $value \"ed_opn_height\")")
    
;;;    (action_tile "tg_offset"     "(setq off_chk $Value)(toggle_do)")

    (action_tile "accept"       "(dismiss_dialog 1)")
    (action_tile "cancel"       "(dismiss_dialog 0)")
    (action_tile "help"         "(cim_help \"WN2\")")
    (action_tile "bn_type_save"   "(readF \"SweType.dat\" nil)(ValueToList)(writeF \"SweType.dat\" nil)")
  )


  (defun radio_gaga (pushed)
    
    (cond 
      ((= pushed "gap")
        (setq swe:gap_chk (get_tile "tg_gap_size"))(mode_tile "ed_gap_size" (if (= swe:gap_chk "1") 0 1))
      )
      ((= pushed "width")
        (setq swe:owid_chk (get_tile "tg_opn_width"))(mode_tile "ed_opn_width" (if (= swe:owid_chk "1") 0 1))
      )
      ((= pushed "height")
        (setq swe:ohig_chk (get_tile "tg_opn_height"))(mode_tile "ed_opn_height" (if (= swe:ohig_chk "1") 0 1))
      ))
    
  )
  
 
        
  (defun getfsize (value tiles)
    (cond ((= tiles "ed_gap_size") 
              (setq swe:gap (verify_d tiles value swe:gap)))  
          ((= tiles "f_size")
           (setq swe:frw (verify_d tiles value swe:frw)))
          ((= tiles "swe:c_size")
           (setq swe:c_size (verify_d tiles value swe:c_size)))
          ((= tiles "num_1")
           (setq swe:num (verify_d tiles value swe:num)))
;;;          ((= tiles "hght_2")
;;;           (setq wn2:num (verify_d tiles value wn2:num)))
          ((= tiles "ed_opn_width")
           (setq swe:wid (verify_d tiles value swe:wid)))
          ((= tiles "ed_opn_height")
           (setq swe:hgh (verify_d tiles value swe:hgh))) 
    ) )
 
  ;;
  (defun verify_d (tile value old-value / coord valid errmsg ci_coord)
    (setq valid nil errmsg "Invalid input value.")
    (if (setq coord (distof value))
      (progn
        (cond
          ((= tile "num_1")
            (setq ci_coord (fix coord))
            (if (>= ci_coord 1)
              (if (= (- ci_coord coord) 0)
                (setq valid T)
                (setq errmsg "Value must be positive integer.")
              )
              (setq errmsg "Value must be positive integer more than 1.")
            )
          )
         
          (T
            (if (>= coord 0)
              (setq valid T)
              (setq errmsg "Value must be positive or zero.")
            ))
        )
      )
      (setq valid nil)
    )
    (if valid
      (progn 
       (if (or (= errchk 0) (= tile last-tile))
          (set_tile "error" "")
        )
        (set_tile tile (if (= tile "num_1") (itoa ci_coord) (rtos coord)))
        (setq errchk 0)
        (setq last-tile tile)
        (if (= tile "num_1")
          ci_coord
          coord
        )
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
  (defun dismiss_dialog (action)
    (if (= action 0)
      (done_dialog 0)
      (if (= (get_tile "error") "")
        (done_dialog action)
      )
    )
  )

(defun ttest (/ old_swe_type)
 (readF "SweType.dat" nil)
 (setq  old_swe_type C_swe_type)
 (setq L_index (Find_index old_swe_type))
    (progn
      (setq zin_old (getvar "dimzin"))
      (setvar "dimzin" 8)
      (if (not (new_dialog "set_sfwintype_name" dcl_id)) (exit)) 
      (set_tile "title" "List of Entities")
      
      (list_view)
      (Set_tileS)
      (action_Tiles)
      (start_dialog)
      (setvar "dimzin" zin_old)
     ))

(defun set_tileS ()
 (if (= L_index nil) (setq L_index 0 ))
 (setq C_swe_type (nth 0 (cdr (nth L_index @Type))))  
 (set_tile "list_type" (rtos L_index)) 
 (set_tile "current_type" old_swe_type)
 (set_tile "ed_type_name" C_swe_type) 
)
 
(defun action_Tiles ()
 (action_tile "list_type" "(setq C_swe_type (Field_match \"타입명\" (setq L_index (atoi $value))))(set_tileS)")
 (action_tile "accept" "(qqqq)")
 (action_tile "cancel" "(setq C_swe_type old_swe_type)")
 (action_tile "eb_del_type" "(deleteIdx C_swe_type)(set_tileS)")
 (action_tile "eb_ren_type" "(renameIdx C_swe_type)(set_tileS)")
 (action_tile "eb_new_type" "(newIdx C_swe_type)(set_tileS)")
)
(defun qqqq()
  (Set_swe_Value)(writeF "SweType.dat" nil)(done_dialog 1)(set_tile_props)
)

) ; end wn2_init

(defun swe_do ()
  (if (not (new_dialog "dd_swin" dcl_id)) (exit))
  (set_tile_props)
  (set_action_tiles)
  (setq dialog-state (start_dialog))
  (if (= dialog-state 0)
   (setq reset_flag t)
  )
)

(defun swe_return ()
  
  (setq swe:fprop  old_fprop
        swe:cprop  old_cprop
        swe:mprop  old_mprop
        swe:glin  old_gprop
        swe:typ  old_typ
        swe:num  old_num

  )
)

(defun dd_SWE (/
                      
           ci_mode          dcl_id           dialog-state     dismiss_dialog
           getfsize     old_num                old_typ           radio_gaga
           reset_flag        set_action_tiles set_tile_props    
           action_Tiles  qqqq   ttest   set_tileS   verify_d  ValueToList
           swe_DrawImage
           drawSwinImage_1        drawSwinImage_2        drawSwinImage_3)

(defun ValueToList(/ tmptype tmplist tmm newlist)
  
  (setq tmplist (nth L_index @type))
  (setq tmptype (strcat (strcase swe:typ) "-Type"))
    
  (setq tmm (list C_swe_type tmptype (rtos swe:wid) (rtos swe:hgh) (rtos swe:gap)
                   (rtos swe:frw) (rtos swe:c_size) (itoa swe:num) swe:gap_chk swe:owid_chk swe:ohig_chk swe:mark_chk))
  (setq newlist (cons (1+ L_index) tmm))
  (setq @type (subst newlist tmplist @Type) )
)
  (setvar "cmdecho" (cond (  (or (not *debug*) (zerop *debug*)) 0)
                          (t 1)))

  (setq old_fprop  swe:fprop
        old_cprop  swe:cprop
        old_mprop  swe:mprop
        old_gprop  swe:gprop
        old_typ  swe:typ
        old_num  swe:num
  )

  (princ ".")
  (cond
     ( (not (setq dcl_id (Load_dialog "WINELEV.dcl"))))   ; is .DLG file loaded?

     (t (ai_undo_push)
        (princ ".")
        (Draw_Image_X)
        (swe_init)                              ; everything okay, proceed.
        (princ ".")
        (swe_do)
     )
  )
  (if reset_flag
    (swe_return)
    (swe_set)
  )
)


(defun Set_swe_Value(/ tnnp ttmpp1)
  
  (setq swe:typ (strcase (substr (Field_match "창문타입" L_index) 1 1) T))
  (setq swe:wid (atof (Field_match "width" L_index) ))
  (setq swe:hgh (atof (Field_match "height" L_index)))
  (setq swe:gap (atof (Field_match "gap_sizes" L_index)))
  (setq swe:frw (atof (Field_match "frame_size" L_index)))
  (setq swe:c_size  (atof (Field_match "case_size" L_index)))
  (setq swe:num (atoi (Field_match "case_num" L_index)))
  (setq swe:gap_chk  (Field_match "gap_chk" L_index))
  (setq swe:owid_chk (Field_match "opnwid_chk" L_index))
  (setq swe:ohig_chk (Field_match "opnhig_chk" L_index))
  (setq swe:mark_chk (Field_match "mark_chk" L_index))
)


(if (null C_swe_type)
   (progn
           
           (setq swe:fprop  (Prop_search "swe" "frame"))
           (setq swe:cprop  (Prop_search "swe" "casement"))
           (setq swe:mprop  (Prop_search "swe" "open_mark"))
           (setq swe:gprop  (Prop_search "swe" "outline"))
                (setq swe:prop '(swe:fprop swe:cprop swe:mprop swe:gprop))
           (readF "SweType.dat" nil) (setq L_index 0)
           (setq C_swe_type (nth 0 (cdr (nth L_index @Type))))
           (Set_swe_Value)
   )
) 

;;;(if (null prj:lay) (setq prj:lay "WIN"))
(if (null swe:gap) (setq swe:gap window_gap))
(if (null swe:wid) (setq swe:wid 2400))
(if (null swe:anh) (setq swe:anh 0))
(if (null swe:anv) (setq swe:anv (/ pi 2)))
(if (null swe:hgh) (setq swe:hgh 1200))

(if (null swe:fprop) (setq swe:fprop (list "swe" "frame" "WINELEV" "6" "CONTINUOUS" "1" "1")))
(if (null swe:cprop) (setq swe:cprop (list "swe" "casement" "WINELEV" "6" "CONTINUOUS" "1" "1")))
(if (null swe:mprop) (setq swe:mprop (list "swe" "open_mark" "WINELEV" "6" "CONTINUOUS" "1" "1")))
(if (null swe:gprop) (setq swe:gprop (list "swe" "outline" "WINELEV" "6" "CONTINUOUS" "1" "1")))

(if (null swe_prop_type) (setq swe_prop_type "rd_frame"))
(if (null swe:typ) (setq swe:typ "a"))
(if (null swe:mark_chk) (setq swe:mark_chk "1"))
(if (null swe:gap_chk) (setq swe:gap_chk "0"))
(if (null swe:owid_chk) (setq swe:owid_chk "1"))
(if (null swe:ohig_chk) (setq swe:ohig_chk "1"))

(if (null swe:gap) (setq swe:gap 5))
(if (null swe:frw) (setq swe:frw 40))
(if (null swe:c_size) (setq swe:c_size 50))
(if (null swe:num) (setq swe:num 2))
(if (null swe:c_size) (setq swe:c_size 100))

(defun C:CIMSWE () (m:swe4))
(setq lfn30 1)
(princ)
