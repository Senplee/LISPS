; 수정일자: 2001.8.13
; 작업자: 박율구        
; 명령어: CIMCHAL

; CHAL(Change Color/Ltype/Layer) loaded. Start command with CHAL.

;단축키 관련 변수 정의
(SETQ lfn45 1)

(defun m:CHAL (/ a1 a2 b1 b2 n index e1 e2 c1 c2 t1 t2)
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n객체를 선택함으써 color,line type,layer등을 변경하는 명령입니다.")
  (setvar "blipmode" 1)
  (setvar "cmdecho" 0)
  (princ "\nSelect objects to be changed...")
  (while (= a1 nil)
    (setq a1 (ssget))
  )
  (princ "Pick object on target Color/Ltype/Layer...")
  (while (= a2 nil)
    (setq a2 (entsel))
  )
  (setq n (sslength a1))
  (setq index 0)
  (setq e2 (entget (car a2)))
  (setq b2 (assoc 8 e2))
  (setq t2 (assoc 6 e2))
  (setq c2 (assoc 62 e2))
  (repeat n
    (setq e1 (entget (ssname a1 index)))
    (setq t1 (assoc 6 e1))
    (setq c1 (assoc 62 e1))
    (setq b1 (assoc 8 e1))
    (if (and t1 t2 c1 c2)
      (progn
        (setq e1 (subst t2 t1 e1))
        (setq e1 (subst c2 c1 e1))
        (setq e1 (subst b2 b1 e1))
        (entmod e1)
      )
      (progn
        (setq e1 (subst b2 b1 e1))
        (entmod e1)
        (if (not t2)
          (command "_chprop" (ssname a1 index) "" "_LT" "_BYLAYER" "")
          (command "_chprop" (ssname a1 index) "" "_LT" (cdr t2) "")
        )
        (if (not c2)
          (command "_chprop" (ssname a1 index) "" "_C" "_BYLAYER" "")
          (command "_chprop" (ssname a1 index) "" "_C" (cdr c2) "")
        )
      )
    )
    (setq index (+ index 1))
  )
  (setvar "cmdecho" 1)
  (princ (strcat "\nColor: " (if c2 (color_name (cdr c2)) "bylayer")
                 "  Linetype: " (if t2 (cdr t2) "bylayer")
                 "  Layer: " (cdr b2)))
  (princ)
)
(defun C:CIMCHAL () (m:chal))

(princ)
