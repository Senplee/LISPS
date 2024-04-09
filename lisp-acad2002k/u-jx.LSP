;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  ★내  용 : 현도면에서 지번크기 변경   ;;
;;  ★만든날 : 2002년 2월 6일             ;;
;;  ★만든이 : 노 태 완                   ;;
;;  ★설  명 : 한번 셋팅으로 지번크기 변경;;
;;  ★명령어 : jx                         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(DEFUN C:jx ( ) ;/ INDEX SSG USER JURGE1 SSL SSN GET OLD NEW SUB)  

	(SETQ SSG     (SSGET))
	(IF (OR (= SSG "") (= SSG NIL)) 
		(alert " Error !!!  Select ...   Jibyun&Jimok ")
		(PROGN
		  (setq js_dcl_id (load_dialog "ph.DCL"))
		  (if (not (new_dialog "JIBYUN_scale" js_dcl_id)) (exit))
		  (mode_tile "jxsize" 2)
		  (action_tile "jxsize" "(setq user (atof $value))")
		  (if (= (start_dialog) 1) (f:jxx_sub))
		)
	)        
)
   
(defun f:jxx_sub ( )
	(SETQ INDEX 0)
	(SETQ SSL     (SSLENGTH SSG))
	(REPEAT SSL 
		(SETQ SSN   (SSNAME SSG INDEX)
			  GET   (ENTGET SSN)
		)
		(if (= (CDR (ASSOC 0 GET)) "INSERT") (COMMAND "SCALE" SSN "" (CDR (ASSOC 10 GET)) (/ user (* (cdr (assoc 41 get)) 3))))
		(setq INDEX (+ INDEX 1))
	);REPEAT_END
	(PRINC)
)
