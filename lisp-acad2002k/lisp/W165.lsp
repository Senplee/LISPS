; �۾���¥: 2001.8.11
; �۾���: �躴��
; ��ɾ�: CIMWDS
; C:door & WinDow Symbol loaded. Start command with CIMWDS.

;����Ű ���� ���� ���� �κ�
(setq lfn04 26)

(defun m:WDS (/ bm cet cec sc p1 p2 p3 wid wds_err wds_oer)
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n���� â���� �ɺ� �±׸� �����ϴ� ����Դϴ�.")
  (setq bm (getvar "blipmode"))
  (setvar "blipmode" 1)
  (setq sc (getvar "dimscale"))
  (setq cec (getvar "CECOLOR"))
  (setq cet (getvar "textstyle"))

  (defun wds_err (s)
    (if (/= s "Function cancelled")
      (if (= s "quit / exit abort")
        (princ)
        (princ (strcat "\nError: " s))
      )
    )
    (if WDS_oer
       (setq *error* WDS_oer)
    )
    (setvar "blipmode" bm)
  )

  (if (not *DEBUG*)
    (if *error*                     
      (setq wds_oer *error* *error* wds_err) 
      (setq *error* wds_err) 
    )
  )
  
  (initget 1)
  (setq p1 (getpoint "\n>>>������: "))
  (if (/= (type wdn) 'STR) (setq wdn "SD"))
  	(setq wid 
  		(strcase 
  			(getstring 
  				(strcat "\nâȣ �̸� �Է�<" wdn ">: ")
  			)
  		)
  	)
  	(if (/= wid "") (setq wdn wid))
  	(if (/= (type wdk) 'INT) (setq wdk 1))
  	(while (/= p1 nil)
  		(initget (+ 2 4))
  (setq wid (getint 
  	(strcat "\nâȣ �̸� �Է�<" (itoa wdk) ">: ")))
  (if (numberp wid) (setq wdk wid))
  (setlay "SYMBOL")
  (setvar "blipmode" 0)
  (setq p2 (polar p1 (dtr 90) (* sc 2)))
  (setq p3 (polar p1 (dtr 270) (* sc 2)))
  (command "insert" "WDS" p1 sc "" "0")
  (command "color" co_3)
;;====================================================
;; text style "sim"�� ã�� ������ �����.
  (if (= (stysearch "SIM") nil)
    	(styleset "SIM")
  )  
  (setvar "textstyle" "sim")
  (command "text" "M" p3 (* sc 2) 0 wdn)
  (command "text" "M" p2 "" "" wdk)
  (setvar "textstyle" cet)
  (command "color" cec)
  (rtnlay)
  (setq p1 (getpoint "\n>>>������ : "))
  )
  (setvar "blipmode" bm)
  (princ)
)

(defun C:cimWDS () (m:wds))
(princ)