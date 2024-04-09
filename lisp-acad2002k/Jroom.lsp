;;-------------------------------------------------------------------------
;;JROOM.LSP
;;*****************************************************
;; - This program is Lighting Array & Lumination      /
;;   command : "LID"                                  /
;;------------------------------                    /
;; Make by Park Dae-sig                             /
;; Date is 1995-00-00                               /
;; Where is "JIN" Electric co.                      /
;; (HP) 018-250-7324                                /
;;------------------------------                    /
;; - Last Up-Date is 1998-10-21 (P.D.S)               /
;;*****************************************************

;;-------------------------------------------------------------------------
(defun BLOCK-LIST () (acad_helpdlg "BLK-LIST.hlp" "fl"))

;;------------------------------------------------------------------------
;;-------- Get Fixture-Name 
(defun GET-NAME	(/ keyy bna)
  (setvar "OSMODE" 0)
  (setq keyy 1)
  (if (= bl_name1 nil)
    (setq bnam "FL240")
    (setq bnam bl_name1)
  )
  (while keyy
    (prompt "\n Set Block name of Light <")
    (prin1 BNAM)
    (setq bna (getstring "> / ? : "))
    (if	(= bna "?")
      (BLOCK-LIST)
      (progn
	(if (or (= bna nil) (= bna ""))
	  (setq bna bnam)
	  (setq bnam bna)
	)
	(setq bnam (strcase bnam))
	(setq keyy nil)
      )
    )
  )
  (setq bl_name1 bnam)
)

					;-------- Loading Dialog Box
(setq jinbox_rm (load_dialog "jroom"))

					;-------- If Help
(defun help_lid () (acad_helpdlg "lisp-hlp.hlp" "lid"))

					;--------- Calcurator = Lux-Calcuration & %-Calcuration
(defun room_reset_1 ()
  (set_tile "room_cal"	
		(strcat "계산조도 :  " (rtos (setq room_cal (/ (* room_ea room_lum room_f room_u) room_a))  2  2) " lux "))
  (set_tile "room_pus"
	   (strcat "백분율(%) :  " (rtos (* (/ room_cal room_lux) 100) 2 2) " (%)"))
;  (set_tile
;    "room_cal"
;    (rtos (setq room_cal (/ (* room_ea room_lum room_f room_u) room_a))
;	  2
;	  2
;    )
;  )
;  (set_tile "room_pus"
;	    (rtos (* (/ room_cal room_lux) 100) 2 2)
;  )
)

					;--------- Calcurator = Lighting-Count & Lux-Calcuration & %-Calcuration
(defun room_reset_2 ()
  (set_tile "room_ea"
		(rtos (setq room_ea (/ (* room_a room_lux) (* room_lum room_u room_f))) 2 2)
  )
  (set_tile "room_cal"	
		(strcat "계산조도 :  " (rtos (setq room_cal (/ (* room_ea room_lum room_f room_u) room_a))  2  2) " lux"))
  (set_tile "room_pus"
	   (strcat "백분율(%) :  " (rtos (* (/ room_cal room_lux) 100) 2 2) " (%)"))
)

					;--------- Calcurator = DDD-Calcuration
(defun room_reset_3 ()
  (setq room_d (/ room_a (* room_h (+ room_w room_l))))
  (get_roomds room_d)
  (set_tile "room_d" (strcat "실지수 :  " (rtos room_d 2 2) "=>" room_ds))
)

(defun get_roomds (a)
  (cond
    ((< a 0.7) (setq room_ds "J"))
    ((< a 0.9) (setq room_ds "I"))
    ((< a 1.125) (setq room_ds "H"))
    ((< a 1.375) (setq room_ds "G"))
    ((< a 1.75) (setq room_ds "F"))
    ((< a 2.25) (setq room_ds "E"))
    ((< a 2.75) (setq room_ds "D"))
    ((< a 3.5) (setq room_ds "C"))
    ((< a 4.5) (setq room_ds "B"))
    (T (setq room_ds "A"))
  )
)

					;(defun room_reset_0()
					;  (setq room_area (/ (* room_w room_l) 1000000))
					;  (set_tile "room_a" (rtos room_area 2 2))
					;  (room_reset_3)
					;  (room_reset_2)
					;)

					;--------- Calcurator = Detector-Count Calcuration
(defun room_recet_4 ()
  (if (= (strcase bnam) "DETS")
    (progn
      (set_tile "room_det_u" (rtos (/ room_a 150) 2 2))
      (set_tile "room_det_o" (rtos (/ room_a 75) 2 2))
    )
    (if	(= (strcase bnam) "DETC")
      (progn
	(set_tile "room_det_u" (rtos (/ room_a 60) 2 2))
	(set_tile "room_det_o" (rtos (/ room_a 30) 2 2))
      )
      (progn
	(set_tile "room_det_u" (rtos (/ room_a 70) 2 2))
	(set_tile "room_det_o" (rtos (/ room_a 35) 2 2))
      )
    )
  )
)

					;-------- Fixture-Slide Image Setting
(defun room_img_set (a / img_name x y)
  (setq img_name (strcat "sym(" a ")"))
  (setq x (dimx_tile "ltg_img"))
  (setq y (dimy_tile "ltg_img"))
  (start_image "ltg_img")
  (fill_image 0 0 x y 7)
  (fill_image 0 0 x y 0)
  (slide_image 0 0 x y img_name)
  (end_image)
)

					;-------- Fixture Name Setting
(defun ltg_set_name (a)
  (set_tile "ltg_sel" a)
)

					;-------- Select of Fixture Name & Image Setting
(defun jget_img	(/ key)
  (setq key nil)
  (new_dialog "jinroom_ltg" jinbox_rm)
  (set_tile "ltg_sel" (strcase bnam))
  (mode_tile "ltg_sel" 2)

  (action_tile "fl120" "(setq bnam $key)(done_dialog)")
  (action_tile "fl120b" "(setq bnam $key)(done_dialog)")
  (action_tile "fl220" "(setq bnam $key)(done_dialog)")
  (action_tile "fpl336" "(setq bnam $key)(done_dialog)")
  (action_tile "fl132" "(setq bnam $key)(done_dialog)")
  (action_tile "fl132b" "(setq bnam $key)(done_dialog)")
  (action_tile "fl232" "(setq bnam $key)(done_dialog)")
  (action_tile "fl332" "(setq bnam $key)(done_dialog)")
  (action_tile "fpl4336a" "(setq bnam $key)(done_dialog)")

  (action_tile "fl120e" "(setq bnam $key)(done_dialog)")
  (action_tile "fl120be" "(setq bnam $key)(done_dialog)")
  (action_tile "fl220e" "(setq bnam $key)(done_dialog)")
  (action_tile "fpl336ae" "(setq bnam $key)(done_dialog)")
  (action_tile "fl132e" "(setq bnam $key)(done_dialog)")
  (action_tile "fl132be" "(setq bnam $key)(done_dialog)")
  (action_tile "fl232e" "(setq bnam $key)(done_dialog)")
  (action_tile "fl332e" "(setq bnam $key)(done_dialog)")
  (action_tile "fpl436ae" "(setq bnam $key)(done_dialog)")

  (action_tile "fpl213" "(setq bnam $key)(done_dialog)")
  (action_tile "fpl213e" "(setq bnam $key)(done_dialog)")
  (action_tile "il60" "(setq bnam $key)(done_dialog)")
  (action_tile "il60e" "(setq bnam $key)(done_dialog)")
  (action_tile "il60b" "(setq bnam $key)(done_dialog)")
  (action_tile "il60br" "(setq bnam $key)(done_dialog)")
  (action_tile "ilo1" "(setq bnam $key)(done_dialog)")

  (action_tile "detd" "(setq bnam $key)(done_dialog)")
  (action_tile "dets" "(setq bnam $key)(done_dialog)")
  (action_tile "detc" "(setq bnam $key)(done_dialog)")

  (action_tile "ltg_sel" "(setq bnam $value)")
  (start_dialog)
  (action_tile "accept" "(done_dialog)")
  (set_tile "jblm" (strcase bnam))
  (room_img_set bnam)
  (mode_tile "jblm" 2)
  (room_recet_4)
)

					;------------------------------------------------------------------------
					;---------- Main Program of Lightin-Fixture Array -----------------------
					;------------------------------------------------------------------------
(defun c:liderr	()
  (setq	lid_key	nil
	room_h nil
	room_d nil
	room_u nil
	room_f nil
	room_lux nil
	room_lum nil
  )
)

(defun C:LID (/	xxx olds fp1 fp2 fp3 fp4 angh angv arh arv hd vd fp5 X1
	      X2 X3 Y1 Y2 Y3)

  (POINT-LIB)				; In-put of Lighting Area

  (setq xxx 3)
  (setq lid_key nil)
  (if (= jinbox_rm nil)
    (setq jinbox_rm (load_dialog "jroom"))
  )
  (new_dialog "jinroom" jinbox_rm)

  (set_tile "room_w"
	    (strcat "가로폭 :  " (rtos (setq room_w (/ (distance fp1 fp4) 1000)) 2 2) " M")
  )
  (set_tile "room_l"
	    (strcat "세로폭 :  " (rtos (setq room_l (/ (distance fp1 fp2) 1000)) 2 2) " M")
  )
  (set_tile "room_a"
	    (strcat "실면적 :  " (rtos (setq room_a (/ (getvar "AREA") 1000000)) 2 2) " MxM")
  )

  (if (= room_h nil)
    (setq room_h 2.2)
  )
  (set_tile "room_h" (rtos room_h 2 2))

;  (mode_tile "room_w" 1)
;  (mode_tile "room_l" 1)
;  (mode_tile "room_a" 1)


  (room_reset_3)
					;  (set_tile "room_d"
					;    (rtos (setq room_d (/ room_a (* room_h (+ room_w room_l)))) 2 2))

  (if (= room_u nil)
    (setq room_u 0.7)
  )
  (if (= room_f nil)
    (setq room_f 0.7)
  )
  (if (= room_lux nil)
    (setq room_lux 500)
  )
  (if (= room_lum nil)
    (setq room_lum 5800)
  )
  (set_tile "room_u" (rtos room_u 2 2))
  (set_tile "room_f" (rtos room_f 2 2))
  (set_tile "room_lux" (rtos room_lux 2 2))
  (set_tile "room_lum" (rtos room_lum 2 2))

  (room_reset_2)
					;  (set_tile "room_ea"
					;    (rtos (setq room_ea (/ (* room_a room_lux) (* room_lum room_u room_f))) 2 2))
					;  (set_tile "room_cal"
					;    (rtos (setq room_cal (/ (* room_ea room_lum room_f room_u) room_a )) 2 2))
					;  (set_tile "room_pus" (rtos (* (/ room_cal room_lux) 100) 2 2))

;  (mode_tile "room_cal" 1)
;  (mode_tile "room_pus" 1)

  (if (= bl_name1 nil)
    (setq bnam "FL240")
    (setq bnam bl_name1)
  )
  (set_tile "jblm" (strcase bnam))
  (room_img_set bnam)
  (mode_tile "jblm" 2)

  (room_recet_4)

  (while (> xxx 2)
    (action_tile
      "room_ea"
      "(setq room_ea  (atof $value))(room_reset_1)"
    )
    (action_tile
      "room_f"
      "(setq room_f   (atof $value))(room_reset_2)"
    )
    (action_tile
      "room_u"
      "(setq room_u   (atof $value))(room_reset_2)"
    )
    (action_tile
      "room_lux"
      "(setq room_lux (atof $value))(room_reset_2)"
    )
    (action_tile
      "room_lum"
      "(setq room_lum (atof $value))(room_reset_2)"
    )
    (action_tile
      "room_h"
      "(setq room_h   (atof $value))(room_reset_3)"
    )
					;    (action_tile "room_w"   "(setq room_w   (atof $value))(room_reset_0)")
					;    (action_tile "room_l"   "(setq room_l   (atof $value))(room_reset_0)")

    (action_tile "img_ty" "(jget_img)")
    (action_tile "jblm" "(setq bnam $value)")
    (action_tile "jxno" "(jgetname 1)(done_dialog)")
    (action_tile "jxdi" "(jgetname 2)(done_dialog)")
    (action_tile "jsin" "(jgetname 3)(done_dialog)")
    (action_tile "pds_key" "(setq lid_key 98)(done_dialog)")
    (action_tile "help" "(help_lid)")
    (setq xxx (start_dialog))
  )
  (action_tile "accept" "(setq lid_key 99)(done_dialog)")
  (action_tile "cancel" "(setq lid_key 100)(done_dialog)")
  (command "undo" "group")
  (j_room lid_key)
  (command "undo" "end")
)

					;===================================================================
(defun jgetname	(a)
  (setq lid_key a)
  (setq bnam (get_tile "jblm"))
)

					;===================================================================
(defun j_room (lid_key)
  (setq	olderr	*error*
	*error*	rmerror
	chm	0
  )
  (setq olds nil)
  (old-inte)
  (cond
    ((= lid_key 3) (j_lid3))
    ((= lid_key 2) (j_lid2))
    ((= lid_key 1) (j_lid1))
    ((= lid_key 0) (j_lid0))
    ((= lid_key 98) (pds_key))
    ((= lid_key 99)
     (prompt
       "\n Select was O.K, but Program is Terminated, If error's Typing LIDERR.."
     )
    )
    ((= lid_key 100)
     (prompt
       "\n Select was CANCEL, Program is Terminated, If error's Typing LIDERR.."
     )
    )
    (T
     (prompt
       "\n Select was CANCEL, Program is Terminated, If error's Typing LIDERR.."
     )
    )
  )
  (setq bl_name1 bnam)
  (new-sn)
)

					;===================================================================
(defun rmerror (s)
  (if (/= s "Function cancelled")
    (princ (strcat "\nError: " s))
  )
  (setvar "osmode" olds)
  (setvar "orthomode" oldo)
  (setq p nil)
  (setq *error* olderr)
  (princ)
)

;;----------------------------STARTING OF LISP'S---------------------------------
;;----------------------------setting's defuolt-------------------------------

(defun dtr (a) (* pi (/ a 180.0)))
(defun rtd (a) (/ (* a 180.0) PI))
(defun old-inte	()
  (setq olds (getvar "OSMODE"))
  (setvar "OSMODE" 33)
)
(defun old-non ()
  (setq olds (getvar "OSMODE"))
  (setvar "OSMODE" 0)
)
(defun new-sn () (setvar "OSMODE" olds))

;;-------------------------------------------------------------------------
(DEFUN J_LID1 ()

  (ARR-CONT)				; In-put of Lighting Area

  (setvar "OSMODE" 0)
  (setq	ana  ang
	ANGH (angle FP4 FP1)
	ANGV (angle FP2 FP1)
	HD   (distance FP1 FP4)
	VD   (distance FP1 FP2)
	HDD  (/ HD (* HN 2.0))
	VDD  (/ VD (* VN 2.0))
	ARH  (* 2 HDD)
	ARV  (* 2 VDD)
	IP   (polar FP3 ANGV VDD)
	IP   (polar IP ANGH HDD)
  )
  (command ".insert" bnam IP "" "" ANG)
  (if (> VN 1.1)
    (if	(> hn 1)
      (command "ARRAY" "L" "" "R" VN HN ARV ARH)
      (command "array" "l" "" "r" vn hn arv)
    )
    (if	(> hn 1)
      (command "ARRAY" "L" "" "R" VN HN ARH)
    )
  )
  (prompt "\n Hor-Dis = : ")
  (prin1 arh)
  (prompt " Ver-Dis = :")
  (prin1 arv)
)

;;-------------------------------------------------------------------------
(DEFUN J_LID2 ()
  (setq po-mid (inters fp1 fp3 fp2 fp4))
  (if (= hsid nil)
    (setq hsid 3000.0)
  )
  (prompt "\n How many OFFSET in Horizontal {---} <")
  (prin1 hsid)
  (prompt "> : ")
  (setq hsize (getint))
  (if (or (= hsize nil) (= hsize ""))
    (setq hsize hsid)
  )
  (setq hsid hsize)
  (if (= vsid nil)
    (setq vsid 3000.0)
  )
  (prompt "\n How many OFFSET in Vertical {|||} <")
  (prin1 vsid)
  (prompt "> : ")
  (setq vsize (getint))
  (if (or (= vsize nil) (= vsize ""))
    (setq vsize vsid)
  )
  (setq vsid vsize)
  (setq hna (/ (distance fp4 fp1) hsize))
  (setq vna (/ (distance fp1 fp2) vsize))
  (if (> (rem hna 1.0) 0.5)
    (setq hna (1+ (fix hna)))
    (setq hna (fix hna))
  )
  (if (> (rem vna 1.0) 0.5)
    (setq vna (1+ (fix vna)))
    (setq vna (fix vna))
  )
  (if (< vna 1)
    (setq vna 1)
  )
  (if (< hna 1)
    (setq hna 1)
  )

  (ARR-CONT)

  (setq hhh (/ (* (- hna 1) hsize) 2))
  (setq vvv (/ (* (- vna 1) vsize) 2))
  (setq po-sta (list (- (car po-mid) hhh) (- (cadr po-mid) vvv)))
  (setvar "OSMODE" 0)
  (command ".insert" bnam po-sta "" "" ang)
  (if (> vna 1.0)
    (if	(> hna 1.0)
      (command "array"
	       "last"
	       ""
	       "r"
	       vna
	       hna
	       (list 0 0)
	       (list hsize vsize)
      )
      (command "array" "last" "" "r" vna hna vsize)
    )
    (if	(> hna 1.0)
      (command "array" "last" "" "r" vna hna hsize)
    )
  )
  (prompt "\n Hor-Dis = : ")
  (prin1 hsize)
  (prompt " Ver-Dis = :")
  (prin1 vsize)
)

;;-------------------------------------------------------------------------
(DEFUN J_LID3 ()
  (setvar "OSMODE" 0)
  (grdraw fp1 fp3 6)
  (setq l-ang (angle fp1 fp3))
  (setq l-dis (/ (distance fp1 fp3) 2))
  (setq fp5 (polar fp1 l-ang l-dis))
  (if (= ana nil)
    (setq ana 0)
  )
  (prompt "\n How To Rotaion for Lighting Fixture { Angle } <"
  )
  (prin1 ana)
  (prompt "> : ")
  (setq ang (getint))
  (if (or (= ang nil) (= ang ""))
    (setq ang ana)
  )
  (SETQ ANA ANG)
  (command ".insert" BNAM FP5 "" "" ANG)
)

;;-------------------------------------------------------------------------
(defun point-lib (/ point1 point2 x1 x2 y1 y2 lx hx ly hy)
					;fp1, fp2 fp3, fp4
  (old-endint)
  (prompt "\n Pick First corner <")
  (prin1 point_1)
  (setq POINT1 (getpoint "> : "))
  (if (= point1 nil)
    (setq point1 point_1)
  )
  (prompt "\n Pick Second corner <")
  (prin1 point_2)
  (setq POINT2 (getcorner POINT1 "> : "))
  (if (= point2 nil)
    (setq point2 point_2)
  )
  (setq	point_1	point1
	point_2	point2
  )
  (setvar "OSMODE" 0)
  (setq	X1 (car POINT1)
	X2 (car POINT2)
	Y1 (cadr POINT1)
	Y2 (cadr POINT2)
  )

  (if (> x1 x2)
    (progn (setq lx x2
		 hx x1
	   )
    )
    (progn (setq lx x1
		 hx x2
	   )
    )
  )
  (if (> y1 y2)
    (progn (setq ly y2
		 hy y1
	   )
    )
    (progn (setq ly y1
		 hy y2
	   )
    )
  )

  (setq	fp3 (list lx ly)
	fp4 (list lx hy)
	fp1 (list hx hy)
	fp2 (list hx ly)
  )

  (grdraw fp1 fp2 6)
  (grdraw fp2 fp3 6)
  (grdraw fp3 fp4 6)
  (grdraw fp4 fp1 6)

  (command "area" fP1 fP2 fP3 fP4 "")
  (setq r-area (/ (getvar "area") 1000000.0))
  (setq r-width (rtos (/ (distance fp1 fp4) 1000.0) 2 1))
  (setq r-lenth (rtos (/ (distance fp1 fp2) 1000.0) 2 1))

  (prompt "\n The Room Area is -> W:")
  (prin1 r-width)
  (prompt " x L:")
  (prin1 r-lenth)
  (prompt " = AREA:")
  (prin1 (rtos r-area 2 2))
  (prompt "(m2) .., If error's Typing LIDERR..")
  (new-sn)
)

(defun arr-cont	()			;hna, vna, ang
  (if (= hna nil)
    (setq hna 2)
  )
  (prompt "\n How many LIGHT in Horizontal {---} <")
  (prin1 hna)
  (prompt "> : ")
  (setq hn (getint))
  (if (or (= hn nil) (= hn ""))
    (setq hn hna)
  )
  (setq hna hn)
  (if (= vna nil)
    (setq vna 2)
  )
  (prompt "\n How many LIGHT in Vertical {|||} <")
  (prin1 vna)
  (prompt "> : ")
  (setq vn (getint))
  (if (or (= vn nil) (= vn ""))
    (setq vn vna)
  )
  (setq vna vn)
  (if (= ana nil)
    (setq ana 0)
  )
  (prompt "\n How To Rotaion for Lighting Fixture {Angle} <")
  (prin1 ana)
  (prompt "> : ")
  (setq ang (getint))
  (if (or (= ang nil) (= ang ""))
    (setq ang ana)
  )
)

					;------------------------------------------------------------------------
(defun c:lid1 ()
  (point-lib)
  (get-name)
  (old-non)
  (j_lid1)
  (new-sn)
)
(defun c:lid2 ()
  (point-lib)
  (get-name)
  (old-non)
  (j_lid2)
  (new-sn)
)
(defun c:lid3 ()
  (point-lib)
  (get-name)
  (old-non)
  (j_lid3)
  (new-sn)
)

					;------------------------------------------------------------------------
					;(prompt "\n JROOM.LSP is loaded.... command is : [LID, LID1, LID2, LID3] ")
