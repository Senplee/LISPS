

;;;JCALS.LSP
;;;*****************************************************
;;; - This program is Lighting Array & Lumination      /
;;;   command:"CALS,CALS2,TAMP3,CALL,CAL6,CAL60,T6     /
;;;------------------------------                    /
;;; Make by Park Dae-sig                             /
;;; Date is 1995-00-00                               /
;;; Where is "JIN" Electric co.                      /
;;; (HP) 018-250-7324                                /
;;;------------------------------                    /
;;; - Last Up-Date is 2004-03-14 (P.D.S)               /
;;;*****************************************************

;;-------------------------------------------------------------------------
(defun set_cals_key (a)
  (cond
    ((= a 1) (set_tile "cals_b1" "1"))
    ((= a 2) (set_tile "cals_b2" "1"))
    ((= a 3) (set_tile "cals_b3" "1"))
    ((= a 4) (set_tile "cals_b4" "1"))
    ((= a 5) (set_tile "cals_b5" "1"))
    ((= a 6) (set_tile "cals_b6" "1"))
    ((= a 7) (set_tile "cals_b7" "1"))
    ((= a 8) (set_tile "cals_b8" "1"))
    (T nil)
  )
)
(load "kht-lisp")

;===±èÈñÅÂ¸®½ÀÀÎ¿ë.

(defun call_dot_set()
	(if cals_dot
		(cond
			((= cals_dot 0)(set_tile "cals_dot0" "1"))
			((= cals_dot 1)(set_tile "cals_dot1" "1"))
			((= cals_dot 2)(set_tile "cals_dot2" "1"))
			((= cals_dot 3)(set_tile "cals_dot3" "1"))
			(T (set_tile "cals_dot0" "1"))
		)
	)
	(if (= cals_chun 1)
		(set_tile "cals_dot4" "1")
	)
)

(defun call_chun()
	(setq a (get_tile "cals_dot4"))
	(if (= a "1")(setq cals_chun 1)(setq cals_chun 0))
)

(defun call_dot(/ a b c d e)
	(setq a (get_tile "cals_dot0"))
	(setq b (get_tile "cals_dot1"))
	(setq c (get_tile "cals_dot2"))
	(setq d (get_tile "cals_dot3"))
	(setq e (get_tile "cals_dot4"))
	(cond
		((= a "1")(setq cals_dot 0))
		((= b "1")(setq cals_dot 1))
		((= c "1")(setq cals_dot 2))
		((= d "1")(setq cals_dot 3))
		(T (setq cals_dot 0))
	)
	(if (= e "1")(setq cals_chun 1))
)

(defun C:CALS (/ cal_key)
  (setq cal_key nil)
  (if (= jinbox_ca nil)
    (setq jinbox_ca (load_dialog "jcals"))
  )
  (new_dialog "jincals" jinbox_ca)

	(call_dot_set)
	(call_dot)
;	(mode_tile "cals_dot4" 1)

  (set_cals_key cals_key)
  (action_tile "cals_dot0" "(setq cals_dot 0)")
  (action_tile "cals_dot1" "(setq cals_dot 1)")
  (action_tile "cals_dot2" "(setq cals_dot 2)")
  (action_tile "cals_dot3" "(setq cals_dot 3)")
  (action_tile "cals_dot4" "(call_chun)")

  (action_tile "cals1" "(setq cal_key 1)(done_dialog)")
  (action_tile "cals2" "(setq cal_key 2)(done_dialog)")
  (action_tile "cals3" "(setq cal_key 3)(done_dialog)")
  (action_tile "cals4" "(setq cal_key 4)(done_dialog)")
  (action_tile "cals5" "(setq cal_key 5)(done_dialog)")
  (action_tile "cals6" "(setq cal_key 6)(done_dialog)")
  (action_tile "cals7" "(setq cal_key 7)(done_dialog)")
  (action_tile "cals8" "(setq cal_key 8)(done_dialog)")
  (action_tile "cals_b1" "(setq cal_key 1)(done_dialog)")
  (action_tile "cals_b2" "(setq cal_key 2)(done_dialog)")
  (action_tile "cals_b3" "(setq cal_key 3)(done_dialog)")
  (action_tile "cals_b4" "(setq cal_key 4)(done_dialog)")
  (action_tile "cals_b5" "(setq cal_key 5)(done_dialog)")
  (action_tile "cals_b6" "(setq cal_key 6)(done_dialog)")
  (action_tile "cals_b7" "(setq cal_key 7)(done_dialog)")
  (action_tile "cals_b8" "(setq cal_key 8)(done_dialog)")
  (action_tile "pds_key" "(setq cal_key 98)(done_dialog)")
  (action_tile "help" "(help_cals)")
  (action_tile
    "accept"
    "(setq cal_key cals_key)(done_dialog)"
  )
  (action_tile "cancel" "(setq cal_key 100)(done_dialog)")
  (start_dialog)
					;  (action_tile "accept" "(setq cal_key cals_key)(done_dialog)")
					;  (action_tile "cancel" "(setq cal_key 100)(done_dialog)")
					;  (if (= cal_key nil)(setq cal_key cals_key))
  (if cal_key
    (if	(> 8 cal_key)
      (setq cals_key cal_key)
    )
  )
  (j_calsx cal_key)
)

(defun j_calsx (cal_key)
  (setq olds nil)
  (old-non)
  (cond
    ((= cal_key 1) (j_cals))
    ((= cal_key 2) (j_cals2))
    ((= cal_key 3) (j_tamp3))
    ((= cal_key 4) (j_call))
    ((= cal_key 5) (j_cal6))
    ((= cal_key 6) (j_cal60))
    ((= cal_key 7) (j_t6))
    ((= cal_key 98) (pds_key))
    (T (prompt "\n Terminated............"))
  )
  (new-sn)
)

					;===================================================================

;;----------------------------STARTING OF LISP'S---------------------------------
;;----------------------------setting's defuolt-------------------------------

(defun dtr (a) (* pi (/ a 180.0)))
(defun rtd (a) (/ (* a 180.0) PI))
(defun old-non ()
  (setq olds (getvar "OSMODE"))
  (setvar "OSMODE" 0)
)
(defun new-sn () (setvar "OSMODE" olds))

;;-------------------------------------------------------------------------
(defun count-sel-text (sel-t1 / n1 i count1 sel-tn sel-td)
  (setq n1 (sslength sel-t1))
  (setq i 0)
  (setq count1 0)
  (setq n1 (- n1 1))
  (while (<= i n1)
    (setq sel-tn (entget (ssname sel-t1 i)))
    (setq sel-td (atof (str_chk_erase "," (cdr (assoc 1 sel-tn)) nil)))	 ; ±èÈñÅÂ¸®½ÀÀÎ¿ë
    (setq count1 (+ count1 sel-td))
    (setq i (+ i 1))
  )
  (setq total-text count1)
	(if (= cals_chun 1)
		(setq m_data (cals_comma (strcat "Calcurator Number is =[" (rtos count1 2 cals_dot) "]")))
		(setq m_data (strcat "Calcurator Number is =[" (rtos count1 2 cals_dot) "]"))
	)
;  (command "MODEMACRO" m_data)
  (prin1)
)

					;----------------------------------------------------------------------------
(defun J_CALS (/ sel-t1 p1)
  (prompt "\n\n ****PICK NUMBER MULTIPLE--(ONLY NUMBER)****")
  (setq sel-t1 (sel_text))

  (COUNT-SEL-TEXT sel-t1)

  (prompt "\n\n ****  THANK YOU! CONTED NUMBER'S = [")
  (prin1 total-text)
  (prompt "] ****")
  (prin1)
	(if (= cals_chun 1)
		(setq total-text (cals_comma (rtos total-text 2 cals_dot)))
		(setq total-text (rtos total-text 2 cals_dot))
	)
  (setq p1 (getpoint "\n ENTER TEXT START POINT ?"))
  (command "TEXT" P1 "250" "" total-text)
)

					;---------------------------------------------------------------------------
(defun J_CALL (/ CA1 N1 I TT T1 T2 TOTAL ETT KKK TN)
  (prompt
    "\n\n ><>< ****PICK NUMBER MULTIPLE--(ONLY NUMBER)**** ><><"
  )
  (setq sel-t1 (sel_text))

  (COUNT-SEL-TEXT sel-t1)

  (prompt "\n\n ****  THANK YOU! CONTED NUMBER'S = [")
  (prin1 total-text)
  (prompt "] ****")
  (prin1)
  (setq total-text (rtos total-text 2 cals_dot))
  (setq ETT (entsel "\n ->->-> SELECT TEXT FOR TOTAL ? <-<-<-"))
  (if ETT
		(if (= cals_chun 1)
			(command "CHANGE" ETT "" "" "" "" "" "" (cals_comma total-text))
			(command "CHANGE" ETT "" "" "" "" "" "" total-text)
		)
  )
)

					;--------------------------------------------------------------------------
(defun J_TAMP3 (/ E1 NL N I CHM E2 T0 TT1 TT2 ED vvv ppp)
  (setq	OLDERR	*ERROR*
	*ERROR*	TEXERROR
	CHM	0
  )
  (setq I 0)
  (if (or (= amp_volt "") (= amp_volt nil))
    (setq amp_volt "380")
  )
  (if (or (= amp_pole "") (= amp_pole nil))
    (setq amp_pole "3")
  )
  (setq vvv amp_volt)
  (setq ppp amp_pole)
  (setq E1 (sel_text))
  (prompt "\n Enter Pole ? (ex - 1P,3P) <")
  (prin1 ppp)
  (setq amp_pole (getstring "> ? : "))
  (if (or (= amp_pole nil) (= amp_pole ""))
    (setq amp_pole ppp)
  )
  (prompt "\n Enter Voltage ? (ex - 208,220,380,440) <")
  (prin1 vvv)
  (setq amp_volt (getstring "> ? : "))
  (if (or (= amp_volt nil) (= amp_volt ""))
    (setq amp_volt vvv)
  )
  (if E1
    (progn
      (setq NL (sslength E1))
      (setq N (- NL 1))
      (while (<= I N)
	(setq ED (entget (setq E2 (ssname E1 I))))
	(setq T0 (cdr (assoc 0 ED)))
	(setq TT1 (assoc 1 ED))
	(setq TT2 (cdr TT1))
	(prompt "\nLoad is ")
	(prin1 TT2)
	(prompt "(kVA) -> ")
	(if (= "3" amp_pole)
	  (cals_amp3 amp_volt)
	)
	(if (= "1" amp_pole)
	  (cals_amp1 amp_volt)
	)
	(prompt " Amp. is :")
	(prin1 TT)
	(prompt "(A)")
	(if (= TT "0.0")
	  (prompt " !! Select is Not Number's !! ")
	  (progn
	    (setq TT (strcat TT "A"))
	    (setq ED (SUBST (CONS 1 TT) (assoc 1 ED) ED))
	    (entmod ED)
	  )				; progn end
	)				; if end
	(setq I (1+ I))
      )					; while end
    )					; progn end
  )					; if end
  (prin1)
)					; defun end

					;--------------------------------------------------------------------------
(defun cals_amp3 (a)
  (cond
    ((= a "380")
     (setq TT (rtos (/ (atof TT2) (* 0.38 (sqrt 3))) 2 cals_dot))
    )
    ((= a "440")
     (setq TT (rtos (/ (atof TT2) (* 0.44 (sqrt 3))) 2 cals_dot))
    )
    ((= a "208")
     (setq TT (rtos (/ (atof TT2) (* 0.208 (sqrt 3))) 2 cals_dot))
    )
    ((= a "220")
     (setq TT (rtos (/ (atof TT2) (* 0.22 (sqrt 3))) 2 cals_dot))
    )
    (T
     (setq TT (rtos (/ (atof TT2) (* (/ (atof a) 1000) (sqrt 3))) 2 cals_dot))
    )
  )
)

					;--------------------------------------------------------------------------
(defun cals_amp1 (a)
  (cond
    ((= a "380") (setq TT (rtos (/ (atof TT2) 0.38) 2 cals_dot)))
    ((= a "440") (setq TT (rtos (/ (atof TT2) 0.44) 2 cals_dot)))
    ((= a "208") (setq TT (rtos (/ (atof TT2) 0.208) 2 cals_dot)))
    ((= a "220") (setq TT (rtos (/ (atof TT2) 0.22) 2 cals_dot)))
    (T
     (setq TT (rtos (/ (atof TT2) (* (/ (atof a) 1000) (sqrt 3))) 2 cals_dot))
    )
  )
)


					;--------------------------------------------------------------------------
(defun J_CAL60 (/    K1	  K2   K3   K4	 K5   K6   tol	kw   fac  flo
		par  tl1  tl2  dl1  dl2	 ts1  ts2  l	l1   t1	  t2
		tn   tl	  dl   df   t-load    d-load	factor	  p1
		p2   p3
	       )
  (setq	TOL "TOTAL LOAD : "
	KW  " (VA)"
	FAC "DEMAND FACTOR : "
	FLO "DEMAND LOAD : "
	PAR " (%)"
  )

					;---------------Select Demand Load
  (prompt "\n\t >>***** SELCET DEMAND-LOAD : *****<<")
  (setq TS1 (CAR (entsel)))
  (setq dem-total (atof (cdr (assoc 1 (entget TS1)))))
  (prompt "\n Demand Load => [")
  (prin1 dem-total)
  (prompt "] ")

					;---------------Select Total Load
  (prompt "\n\t <<===== SELCET TOTAL-LOAD : =====>>")
  (setq sel-t1 (sel_text))
  (count-sel-text sel-t1)
  (setq gra-total total-text)
  (prompt "\n Total Load => [")
  (prin1 gra-total)
  (prompt "] ")

					;---------------Calcuration
  (setq dem-factor (rtos (* (/ dem-total gra-total) 100) 2 cals_dot))
  (setq g-total (strcat tol (rtos gra-total 2 cals_dot) kw))
  (setq d-total (strcat flo (rtos dem-total 2 cals_dot) kw))
  (setq factor (strcat fac dem-factor par))

					;---------------TEXT TYPING
  (setq P1 (getpoint " TEXT START POINT?"))
  (setq P2 (POLAR P1 (DTR 270) 450))
  (setq P3 (POLAR P2 (DTR 270) 450))
  (command "TEXT" P1 "250" "0" g-total)
  (command "TEXT" P2 "250" "0" FACTOR)
  (command "TEXT" P3 "250" "0" d-total)
)

					;-------------------------------------------------------------------------
(defun J_CALS2 (/    p	  l    n    e	 os   as   ns	st   s	  nsl
		osl  sl	  si   chf  couu total	   total2    si	  CA1
		N1   I	  TT   T1   T2
	       )
  (prompt "\n\n ****PICK NUMBER MULTIPLE--(ONLY NUMBER)****")
  (TERPRI)
  (setq sel-t1 (sel_text))

  (count2 sel-t1)
  (count-sel-text sel-t1)
  (setq TOTAL (rtos total-text 2 cals_dot))

  (setq total2 (strcat total " / " (rtos couu 2 cals_dot)))
  (prompt "\n\n ****  THANK YOU! CONTED NUMBER'S = [")
  (prompt total2)
  (prompt "] ****")
  (prin1)
  (setq P1 (getpoint "\n ENTER TEXT START POINT ?"))
  (command "TEXT" P1 "250" "" TOTAL2)
)

					;-------------------------------------------------------------------------
(defun count2 (p)
	(if p
		(progn
			(setq couu 0 osl 1 os "/")
			(setq nsl 1 ns "")
			(setq l 0 n (sslength p))
			(while (< l n)
				(setq e (entget (ssname p l)))
				(setq chf nil si  1)
				(setq s (cdr (setq as (assoc 1 e))))
				(while (= osl (setq sl (strlen (setq st (substr s si osl)))))
					(if (= st os)
						(progn
							(setq s (strcat ns (substr s (+ si osl))))
							(setq chf t)
							(setq si (+ si nsl))
						)
						(setq si (1+ si))
					)
				)
				(if chf
					(setq couu (+ (atof (str_chk_erase "," s nil)) couu))	; ±èÈñÅÂ¸®½À ÀÎ¿ë
				)
				(setq l (1+ l))
	      )
		)
	)
)

;;;--------------------------------------------------------------------------
;;;---------------MAIN SETTING---------------------

(defun J_CAL6 (/    K1	 K2   K3   K4	K5   K6	  tol  kw   fac	 flo
	       par  tl1	 tl2  dl1  dl2	ts1  ts2  l    l1   t1	 t2
	       tn   tl	 dl   df   t-load    d-load    factor	 p1
	       p2   p3
	      )

  (setq	TOL "TOTAL LOAD : "
	KW  " (VA)"
	FAC "DEMAND FACTOR : "
	FLO "DEMAND LOAD : "
	PAR " (%)"
  )

					;---------------Select 60% Load-----------------
  (prompt "\n\t >>***** SELCET 60%-LOAD : *****<<")
  (setq sel-t1 (sel_text))
  (count-sel-text sel-t1)
  (setq gra-total60 total-text)
  (prompt "\n 60% Total Load => [")
  (prin1 gra-total60)
  (prompt "] ")

					;---------------Select 100% Load-----------------
  (prompt "\n\t <<===== SELCET TOTAL-LOAD : =====>>")
  (setq sel-t1 (sel_text))
  (count-sel-text sel-t1)
  (setq gra-total100 total-text)
  (prompt "\n 100% Total Load => [")
  (prin1 gra-total100)
  (prompt "] ")

					;---------------Calcuration -------------
  (setq dem-total (+ (* gra-total60 0.6) gra-total100))
  (setq gra-total (+ gra-total60 gra-total100))
  (setq dem-factor (rtos (* (/ dem-total gra-total) 100) 2 cals_dot))
  (setq g-total (strcat tol (rtos gra-total 2 cals_dot) kw))
  (setq d-total (strcat flo (rtos dem-total 2 cals_dot) kw))
  (setq factor (strcat fac dem-factor par))

					;---------------TEXT TYPING-----------------
  (setq P1 (getpoint " TEXT START POINT?"))
  (setq P2 (POLAR P1 (DTR 270) 450))
  (setq P3 (POLAR P2 (DTR 270) 450))
  (command "TEXT" P1 "250" "0" g-total)
  (command "TEXT" P2 "250" "0" FACTOR)
  (command "TEXT" P3 "250" "0" d-total)
)

;;;--------------------------------------------------------------------------
					;(prompt "\n TYPE command : CALS ")
;;;--------------------------------------------------------------------------
