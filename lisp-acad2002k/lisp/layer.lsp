; 작업날짜: 2000.4.25
; 작업자: 박율구
; 명령어; 도면층관련 명령들(SELF,SEOF,SL,SLF,SLN,SLO)

;	layer utility...
;	1997. 11. 
;	Designed by Outsider...
;
;

;단축키 관련 변수 정의 부분
(setq lfn04 1)

;Select layer off
(defun m:CIMsellayeron (/ cla a2 b2 L1 L2) 
	(princ "\nArchiFree 2002 for AutoCAD LT 2002.")
	(princ "\n선택한 객체의 도면층만을 보이게 하는 명령입니다.")
	(setvar "cmdecho" 1)
	(while (= a2 nil)
		(setq a2 (entsel))
	)
	(setq b2 (entget (car a2)))
	(setq L1 (assoc 8 b2))
	(setq L2 (cdr L1))
	(setvar "cmdecho" 0)
	(command "_layer" "_set" L2 "_off" "*" "" "_on" "" "")
	(setvar "cmdecho" 1)
	(princ l2)
	(princ)
	(setvar "cmdecho" 0)
)
(defun c:CIMSLO() (m:CIMsellayeron))

;Select layer on
(defun m:CIMlayeron()
	(princ "\nArchiFree 2002 for AutoCAD LT 2002.")
        (princ "\n모든 도면층을 켜주는 명령입니다.")
	(setvar "cmdecho" 0)
	(command "_layer" "_on" "*" "")
	(princ "\nfinished......")
)
(defun c:CIMSLN() (m:CIMlayeron))

;Select layer Freeze
(defun m:CIMsellayerFreeze (/ cla a2 b2 L1 L2) 
	(princ "\nArchiFree 2002 for AutoCAD LT 2002.")
        (princ "\n선택한 객체의 도면층외의 모든 도면층을 얼리게 하는 명령입니다.")
	(setvar "cmdecho" 1)
	(while (= a2 nil)
		(setq a2 (entsel))
	)
	(setq b2 (entget (car a2)))
	(setq L1 (assoc 8 b2))
	(setq L2 (cdr L1))
	(setq clayer (setvar "CLAYER" L2))
	(setvar "cmdecho" 0)
	(command "_layer" "_set" L2 "_freeze" "*" "")
	(setvar "cmdecho" 1)
	(princ l2)
	(princ)
	(setvar "cmdecho" 0)
)
(defun c:CIMSLF() (m:CIMsellayerFreeze))

;Select layer Thaw
(defun m:CIMlayerThaw()
	(princ "ArchiFree 2002 for AutoCAD LT 2002.")
	(princ "\n모든 도면층의 동결을 해제해주는 명령입니다.")
	(setvar "cmdecho" 0)
	(command "_layer" "_thaw" "*" "")
	(princ "\nfinished......")
)
(defun c:CIMSTN() (m:CIMlayerThaw))

(defun m:CIMselfreeze (/ cla a2 b2 L1 L2)
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n선택한 객체를 얼리고자 할때 사용하는 명령입니다.")
  (setq cla (getvar "CLAYER"))
  (while (= a2 nil)
    (setq a2 (entsel))
  )
  (setq b2 (entget (car a2)))
  (setq L1 (assoc 8 b2))
  (setq L2 (cdr L1))
  (setvar "cmdecho" 0)
  (if (/= cla L2)
    (progn
      (command "_.layer" "_F" L2 "")
      (princ "Layer ")
      (princ L2)
      (princ " Freezed....")
    )
    (progn
      (princ "Cannot freeze layer ")
      (princ L2)
      (princ ".  It is the CURRENT layer.")
    )
  )
  (setvar "cmdecho" 1)
  (PRINC)
)
(defun c:CIMSEOF() (m:CIMselfreeze))
       
(defun m:CIMselOff (/ cla a2 b2 L1 L2)
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n선택한 객체의 도면층을 끄는 명령입니다.")
  (setq cla (getvar "CLAYER"))
  (while (= a2 nil)
    (setq a2 (entsel))
  )
  (setq b2 (entget (car a2)))
  (setq L1 (assoc 8 b2))
  (setq L2 (cdr L1))
  (setvar "cmdecho" 0)
  (if (/= cla L2)
    (progn
      (command "_.layer" "_OFF" L2 "")
      (princ "Layer ")
      (princ L2)
      (princ " Offed....")
    )
    (progn
      (command "_.layer" "_OFF" L2 "_y" "")
      (princ "Layer ")
      (princ L2)
      (princ " Off....")
    )
  )
  (setvar "cmdecho" 1)
  (PRINC)
)
(defun c:CIMSELF() (m:CIMseloff))

;;;=== Make Object's Layer Current =============================

;; Makes the layer of the selected object current.  If there is one
;; object in the pickfirst set, it's layer is made current without
;; prompting for an object.  Else a prompt is issued.
(defun m:CIMsetclayer(/ old_error end_undo old_cmdecho set1 ent undo_control)

  ;; Simple error handling.
  (defun molc_error (s)
    ;; Reset error handling.
	(if old_error (setq *error* old_error))
	;; End undo if we started one.
	(if (eq end_undo 1) (command "_undo" "_end"))
	;; Reset command echo
	(if old_cmdecho (setvar "cmdecho" old_cmdecho))
	;; Silent exit.
	(princ)
  )
  (princ "\nArchiFree 2002 for AutoCAD LT 2002")
  (princ "\n선택한 객체의 도면층을 현재 도면층으로 변경하는 명령입니다.")
  ;; Save current error function.
  (setq old_error *error*)
  
  ;; Set error handling to molc's error function.
  (setq *error* molc_error)
  
  ;; Save cmdecho setting.
  (setq old_cmdecho (getvar "cmdecho"))
  
  ;; Turn off cmdecho
  (setvar "cmdecho" 0)
   
  ;; If Pickfirst is on and the selction set contains 
  ;; one object, then use it, else prompt for one.
  (if (and (eq 1 (logand 1 (getvar "pickfirst")))
            (setq set1 (ssget  "_i"))
	        (eq 1 (sslength set1))
	  )
     (progn 
	   (setq ent (entget (ssname set1 0)))   	 
       (sssetfirst nil nil)
	 )
	 (progn 
	   (sssetfirst nil nil)
	   (setq ent (entget (car (entsel))))
	 )
  )
  
  ;; Get undo setting.
  (setq undo_control (getvar "undoctl"))
  
  ;; Initialize flag to to end undo.
  (setq end_undo 0)
  
  ;; Begin Undo group if need be.
  (if (and (= 1 (logand 1 undo_control))   ; undo on
           (/= 2 (logand 2 undo_control))  ; not single undo
      	   (/= 8 (logand 8 undo_control))  ; no active group
	  )
	  (progn 
	    ;; Begin a new one
		(command "_undo" "_begin")
   		;; Set flag so that we know to end undo.
	    (setq end_undo 1)
      )
  )

  ;; Make object's layer current.
  (setvar "clayer" (cdr (assoc '8 ent)))
  
  ;; Print message
  (princ "\n현재 도면층이 ")
  (princ (strcat (getvar "clayer") "(으)로 변경되었습니다."))
    
  ;; Undo end
  (if (eq 1 end_undo)
    (command "_undo" "_end")
  )
  
  ;; Turn on cmdecho
  (setvar "cmdecho" old_cmdecho)
  
  ;; Reset error function.
  (setq *error* old_error)
  
  ;; Silent exit.
  (princ)
)
(defun c:CIMSL() (m:CIMsetclayer))