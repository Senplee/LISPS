;;���� Ÿ��Ʋ�� ������ ������ Ÿ��Ʋ �۾����� (������ ��+�۾�����*2) ��ŭ ������ �Ÿ��� ����
;; 2003-10-06 ����
;; 2014-05-30 ����
(defun c:tit()
	(prompt "Ÿ��Ʋ ������ ������ ������ Ÿ��Ʋ �۾����� ")
	(prompt "\n (������ ��+�۾�����*1.3) ��ŭ �������� ��������")
;	(prompt "\n\t Select of Title Line & Text (Only 3EA) ? :")
  (set_title "R")
)
(defun c:tit2()
	(prompt "Ÿ��Ʋ ������ ������ ������ Ÿ��Ʋ �۾����� ")
	(prompt "\n (������ ��+�۾�����*1.3) ��ŭ �������� ��������")
;	(prompt "\n\t Select of Title Line & Text (Only 3EA) ? :")
  (set_title "L")
)

(defun set_title (flag / ss ss-text ss-elt1 ss-elt2 ss-th1 ss-th2 ssx 
      ss-title ss-scale ss-line ss-ell p1 p2 ps pe t1_p2 t1_pe2 t2_p2 t2_pe2)

  (defun dxf (id lst)(cdr (assoc id lst)))

	(setq ss (ssget ":L" (list (cons 0 "TEXT,LINE"))))
  
  (sssetfirst nil ss)
  (setq ss-text (ssget (list (cons 0 "TEXT"))))
  (setq ss-elt1 (entget (ssname ss-text 0)) ss-elt2 (entget (ssname ss-text 1)))
  (setq ss-th1 (dxf 40 ss-elt1) ss-th2 (dxf 40 ss-elt2))
  (setq ssx (ssadd))
  (if (> ss-th1 ss-th2)
    (setq ss-title ss-elt1 ss-scale ss-elt2 ssx (ssadd (ssname ss-text 1)))
    (setq ss-title ss-elt2 ss-scale ss-elt1 ssx (ssadd (ssname ss-text 0)))
  )  
  
  (sssetfirst nil ss)
  (setq ss-line (ssget (list (cons 0 "LINE"))))
  (setq ss-ell (entget (ssname ss-line 0)))
  (setq p1 (dxf 10 ss-ell) p2 (dxf 11 ss-ell))
  (if (< (car p1) (car p2))
    (setq ps p1 pe p2)
    (setq ps p2 pe p1)
  )

	(setq l1_pe pe)	; ������ ��
	(setq t1_pe (tp_get ss-title)) ; �����ʳ�
	(setq t1_pe2 (polar t1_pe 0 (* 1.3 (dxf 40 ss-title))))
	(setq ss-ell (entmod (subst (cons 11 (list (car t1_pe2) (cadr pe) 0.0)) (assoc 11 ss-ell) ss-ell)))
	;���γ� �����Ϸ�

  (if (= flag "R")
    (progn
      (setq t2_pe (tp_get ss-scale))
    	(setq t2_pe2 (list (car t1_pe) (cadr t2_pe) 0.0))
      (vl-cmdf "_.move" ssx "" "non" t2_pe "non" t2_pe2)
      (setq ssx nil)
    )
    (progn
      (setq t2_ps (dxf 10 ss-scale))
    	(setq t2_ps2 (list (car (dxf 10 ss-title)) (cadr t2_ps) 0.0))
      (vl-cmdf "_.move" ssx "" "non" t2_ps "non" t2_ps2)
      (setq ssx nil)
    )
  )    
  ; Scale ���� �̵��Ϸ�
  
)

(defun tp_get (t1 / t1_ps t1_ptb ptb_p1 ptb_p2 ptb_p3 ptb_p4 t1_pe)
	(setq t1_ps (cdr (assoc 10 t1)))	; Ÿ��Ʋ ������
	(setq t1_ptb (textbox t1))			; Ÿ��Ʋ textbox point
	(setq ptb_p1 (car t1_ptb) ptb_p2 (cadr t1_ptb))	; �����ϴ�, �����ʻ��
	(setq ptb_p3 (list (car ptb_p1) (cadr ptb_p2)))	; ���ʻ��
	(setq ptb_p4 (list (car ptb_p2) (cadr ptb_p1)))	; �������ϴ�
	(setq t1_pe (polar t1_ps 0 (distance ptb_p1 ptb_p4)))	; ������ ����
	t1_pe
;	(cadr t1_ptb)
;	(setq t1_pe2 (polar t1_pe 0 (* 2 (cdr (assoc 40 t1)))))	; 
)

