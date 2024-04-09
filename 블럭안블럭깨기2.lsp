;┌─────────────────────┐
;│              ♥ 블럭안 블럭깨기 ♥
;│        Program By.   Jeong Kil Bok
;│        E-mail:   810storm@Daum.net
;│        Sep  19, 2008
;└─────────────────────┘

(defun c:exx ( / doc blocks ss n obj bname bnamelst)
    (vl-load-com)
	(setq doc (vla-get-activedocument (vlax-get-acad-object)))
    (setq blocks (vla-get-blocks doc)) 
	(prompt "\n>> 블럭 선택[도면 전체(엔터)]:")
	(if (setq ss (ssget '((0 . "insert"))))
		(progn
			(setq n 0)
			(repeat (sslength ss)
				(setq obj (vlax-ename->vla-object (ssname ss n)))
				(setq bname (vla-get-name obj))
				(setq bnamelst (append bnamelst (list bname)))
				(setq n (1+ n))
			)
			(vlax-for item blocks
				(setq bname (vla-get-name item))
				(if (and (/= (substr (vla-get-name item) 1 1) "*") (member bname bnamelst))
					(xplode item)
				)
			)
		)
		(progn
			(vlax-for item blocks                 
				(if (/= (substr (vla-get-name item) 1 1) "*")
					(xplode item)
				)
			)
		)
	)
	(princ)
)

(defun xplode(xtem  / err i tn)
	(setq i 0 tn t)
	(while tn							
		(vlax-for obj xtem 
			(if (= (vla-get-objectname obj) "AcDbBlockReference")
				(progn
					(setq err (vl-catch-all-error-p (vl-catch-all-apply 'vla-explode (list obj))))
					(if (not err) (vla-delete obj))
				)
			)
		)
		(setq tn nil)
		(vlax-for obj xtem 
			(if (= (vla-get-objectname obj) "AcDbBlockReference")
				(setq tn t)
			)
		)
		(if (equal i 100) (setq tn nil))
		(setq i (1+ i))
	)
)