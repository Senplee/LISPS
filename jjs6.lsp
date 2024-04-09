;-----
; �� �� �� : AUTO-PLOT
; �� �� �� : APG.LSP
; �� �� �� : APG
; �� �� �� : �� �� ��  (pskim@mail.knm.net)
; �� �� ó : http://my.netian.com/~daeho71/
;-----

;;++++++++++++++++++++++++++ xoutside.com +++++++++++++++++++++++++++++++++++++++
(defun filefind (dirs file / *getdirs*)
;; �������� ��θ� ��� ã�� ����Լ���.
	(defun *getdirs* (dirs / dirs)
	;; ���Ϲ��� ����� ������������ �����ϰ�
		(setq dirs
			(mapcar '(lambda (x)	(strcat dirs "/" x))
          (cddr (vl-directory-files dirs "*" -1))
			)
      )
      ;; ��θ� ����Ʈ�� ���� �����Ѵ�.
      (apply 'append
        (mapcar
         '(lambda (x)
            (cond
              ((null x)    nil)
              ((listp x)   x)
              (t           (list x))
            )
          )
          ;; �ڽ��� �Լ��� ���� ��ε��� ������θ� ���Ϲ޴´�.
          ;; ������ΰ� �������� ������ (mapcar '*getdirs* nil) �� ������� �ʴ´�.
          (cons dirs 
            (mapcar '*getdirs* dirs)
          )
        )
      )
    )
    ;; ������θ� ������ ��� ��ο��� file �̸����� ã�� ����Ʈ�� �����Ѵ�.
    (apply 'append
      (mapcar
       '(lambda (d)
          (mapcar

;             '(lambda (f) (strcat d "/" f)) ; /�� ���� �����°� ����...
             '(lambda (f) (strcat d f))

				 (vl-directory-files d file 1)
          )
        )
        ;; ������ο� �ڽ��� ��θ� ����Ʈ�� �����.
        (cons dirs (*getdirs* dirs))
      )
    )
)
;;******************************************************************************
;;***************** SHEET Changing Program ********************
(defun APGchbb (DWG FH)
    (write-line "open" fh)
    (write-line "Y" fh)
    (write-line DWG FH)
    (write-line "JSHEETNEW1" fh)
    (write-line "ZE" fh)
    (write-line "IMAGEFRAME" fh)
    (write-line "OFF" fh)
    (write-line "ERASELAST" fh)
    (write-line "QSAVE" fh)
    (write-line "ZE" fh)
);;defun

(defun C:APGCHBB (/ ALIST FH ITEM)
    (setq 
		ALIST (acad_strlsort (filefind (getvar "DWGPREFIX") "*.DWG"))
		atest alist
		FH (open (strcat (getvar "DWGPREFIX") "APG.SCR") "w"))
    (WRITE-LINE "")
    (foreach ITEM ALIST
    (APGCHBB ITEM FH))
    (write-line "end"fh)
    (setq FH (close FH))
    (prompt "\nAutomatic PURGE...")
	 (setq scr_name (strcat (getvar "DWGPREFIX") "APG"))
    (command "SCRIPT" scr_name)
)

(defun	c:ZE()
	(terpri)(princ "ZOOM EXTENTS" )
	(setvar "cmdecho" 0)
         (command "ZOOM" "E") (princ))

(defun	c:JSHEETNEW1()
	(terpri)(princ "SHEET CHANGE" )
	(setvar "cmdecho" 0)
   (command "-INSERT" "���ϴ�-��-�ҹ�=" "0,0" "" "" "") (princ))



(defun	c:ERASELAST()
	(terpri)(princ "SHEET ERASE" )
	(setvar "cmdecho" 0)
	(command "ERASE" "LAST" "") (princ))

;;***************** End Program ********************
