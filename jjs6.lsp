;-----
; 자 료 명 : AUTO-PLOT
; 파 일 명 : APG.LSP
; 실 행 명 : APG
; 만 든 이 : 김 판 성  (pskim@mail.knm.net)
; 배 포 처 : http://my.netian.com/~daeho71/
;-----

;;++++++++++++++++++++++++++ xoutside.com +++++++++++++++++++++++++++++++++++++++
(defun filefind (dirs file / *getdirs*)
;; 하위폴더 경로를 모두 찾는 재귀함수다.
	(defun *getdirs* (dirs / dirs)
	;; 리턴받은 경로의 하위폴더명을 저장하고
		(setq dirs
			(mapcar '(lambda (x)	(strcat dirs "/" x))
          (cddr (vl-directory-files dirs "*" -1))
			)
      )
      ;; 경로를 리스트로 묶어 리턴한다.
      (apply 'append
        (mapcar
         '(lambda (x)
            (cond
              ((null x)    nil)
              ((listp x)   x)
              (t           (list x))
            )
          )
          ;; 자신의 함수로 보내 경로들의 하위경로를 리턴받는다.
          ;; 하위경로가 존재하지 않으면 (mapcar '*getdirs* nil) 은 실행되지 않는다.
          (cons dirs 
            (mapcar '*getdirs* dirs)
          )
        )
      )
    )
    ;; 하위경로를 포함한 모든 경로에서 file 이름들을 찾아 리스트로 리턴한다.
    (apply 'append
      (mapcar
       '(lambda (d)
          (mapcar

;             '(lambda (f) (strcat d "/" f)) ; /가 에라가 나오는거 같음...
             '(lambda (f) (strcat d f))

				 (vl-directory-files d file 1)
          )
        )
        ;; 하위경로와 자신의 경로를 리스트로 만든다.
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
   (command "-INSERT" "도하단-폼-소방=" "0,0" "" "" "") (princ))



(defun	c:ERASELAST()
	(terpri)(princ "SHEET ERASE" )
	(setvar "cmdecho" 0)
	(command "ERASE" "LAST" "") (princ))

;;***************** End Program ********************
