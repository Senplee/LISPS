; �۾���; �躴��
; �۾�����: 2001�� 8�� 11��
; ��ɾ�: CIMSECL

;����Ű ���� ���� ����
(SETQ lfn47 1)

(defun m:SECL (/ a2 b2 C1 C2 L1 L2)
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n����� �ٲ� ����� Layer�� ��ü�� �����ϴ� ����Դϴ�.")
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
      (princ (strcat C2 " ������ " L2 " Layer�� �����Ǿ����ϴ�."))
    )
    (princ (strcat C2 " ���� " L2 " Layer�� �����Ǿ����ϴ�."))
  )
  (princ)
)

(defun C:cimSECL () (m:secl))
(princ)
