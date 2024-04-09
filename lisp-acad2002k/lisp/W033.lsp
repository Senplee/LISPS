; 수정날짜: 2001.8.13
; 작업자: 박율구
; 명령어: CIMCLT

; Change Color & Linetype. Start command with CLT.

;단축키 관련 변수 정의
(SETQ lfn46 1)

(defun m:CHCLT (/ a1 a2 n index e1 e2 c1 c2 t1 t2)
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n객체를 선택함으써 color,line type등을 변경하는 명령입니다.")
  (setvar "blipmode" 1)
  (setvar "cmdecho" 0)
  (princ "\nSelect objects to be changed...")
  (while (= a1 nil)
    (setq a1 (ssget))
  )
  (princ "Pick object on target Color & LineType...")
  (while (= a2 nil)
    (setq a2 (entsel))
  )
  (setq n (sslength a1))
  (setq index 0)
  (setq e2 (entget (car a2)))
  (setq b2 (assoc 8 e2))
  (setq t2 (assoc 6 e2))
  (if (= t2 nil)
    (setq t2a (laltype (cdr b2)))
  )
  (setq c2 (assoc 62 e2))
  (if (= c2 nil)
    (setq c2a (lacolor (cdr b2)))
  )
  (repeat n
    (setq e1 (entget (ssname a1 index)))
    (setq t1 (assoc 6 e1))
    (setq c1 (assoc 62 e1))
    (if (and t1 t2 c1 c2)
      (progn
        (setq e1 (subst t2 t1 e1))
        (setq e1 (subst c2 c1 e1))
        (entmod e1)
      )
      (progn
        (if (not t2)
          (command "_chprop" (ssname a1 index) "" "_LT" t2a "")
          (command "_chprop" (ssname a1 index) "" "_LT" (cdr t2) "")
        )
        (if (not c2)
          (command "_chprop" (ssname a1 index) "" "_C" c2a "")
          (command "_chprop" (ssname a1 index) "" "_C" (cdr c2) "")
        )
      )
    )
    (setq index (+ index 1))
  )
  (setvar "cmdecho" 1)
  (princ (strcat "\n\tColor: " (if c2 (color_name (cdr c2)) (color_name c2a))
                 "  Linetype: " (if t2 (cdr t2) t2a)))
  (princ)
)
(defun C:cimCLT () (m:chclt))

(princ)
