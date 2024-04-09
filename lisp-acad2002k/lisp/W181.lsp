; 작업자; 김병용
; 작업일자: 2001년 8월 11일
; 명령어: CIMSECL

;단축키 관련 변수 정의
(SETQ lfn47 1)

(defun m:SECL (/ a2 b2 C1 C2 L1 L2)
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n현재로 바꿀 색상과 Layer의 물체를 선택하는 명령입니다.")
  (while (= a2 nil)
    (setq a2 (entsel))
  )
  (setq b2 (entget (car a2)))
  (setq C1 (assoc 62 b2))
  (setq L1 (assoc 8 b2))
  (setq L2 (cdr L1))
  (if (= C1 nil)
    (setq C2 "Bylayer")
    (setq C2 (cdr C1))
  )
  (setvar "cmdecho" 0)
  (command "_.Color" C2)
  (command "_.layer" "_s" L2 "")
  (setvar "cmdecho" 1)
  (if (numberp C2)
    (progn
      (setq C2 (itoa C2))
      (princ (strcat C2 " 번색과 " L2 " Layer가 설정되었습니다."))
    )
    (princ (strcat C2 " 색과 " L2 " Layer가 설정되었습니다."))
  )
  (princ)
)

(defun C:cimSECL () (m:secl))
(princ)
