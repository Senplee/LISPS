
;; xclip�� ���� ���Ե� ���·� ������. (explode �� trim�̿�)
(defun c:xp5()
  (command "Undo" "Be")
  (ai_sysvar '(("osmode" . 0)("cmdecho" . 0)))
  (setq k T)
  
  ;; ���� �̸��� �޾Ƶ���.
  (while k
    (setq x-ent (entsel "\n\t Xref-Block Select ?:"))
    (if (= (cdr (assoc 0 (setq x-entl (entget (car x-ent))))) "INSERT")
      (setq k nil b_name (cdr (assoc 2 x-entl)))
      (prompt "\t ??Select is Not Block?? Select again ")
    )
  )
  
  ;; ���� ȸ�� �� ��ô ���� �⺻���� ������.
  (setq xref-10 (cdr (assoc 10 x-entl)))
  (setq xref-41 (cdr (assoc 41 x-entl)))
  (setq xref-42 (cdr (assoc 42 x-entl)))
  (setq xref-43 (cdr (assoc 43 x-entl)))
  (setq xref-50 (cdr (assoc 50 x-entl)))

;;;  (setq x-entl (subst (cons 41 1.0)(assoc 41 x-entl) x-entl))
;;;  (setq x-entl (subst (cons 42 1.0)(assoc 42 x-entl) x-entl))
;;;  (setq x-entl (subst (cons 43 1.0)(assoc 43 x-entl) x-entl))
;;;  (setq x-entl (subst (cons 50 0  )(assoc 50 x-entl) x-entl))
;;;  (entmod x-entl)
;;;
;;;  ;; ���� �������� ���� �̸��� ����.  
;;;  (command "TEXT" xref-10 300 "" b_name)

  ;; ���� ��輱�� �����Ͽ� ����Ʈ����Ʈ�� �޾Ƶ���.
  (command "XCLIP" x-ent "" "P")
  (setq p-pl1 (entget (setq pl1 (entlast))))
  (setq p-ptl (getpolyvtx p-pl1))

  (prompt "\n\t block-explode point")
  ;; ���� �����Ͽ� ��ü��ü�� ������.(���Ŀ� erase�� trim�� �ϱ�����) 
  (setq entx (entlast) x-ents (ssadd))
  (command "explode" x-ent)
  (while (setq ent (entnext entx))
    (setq x-ents (ssadd ent x-ents))
    (setq entx ent)
  )

  (prompt "\n\t select outside entty")
  ;; ��輱�� �ٱ��� �����ϴ� ��ü�� �����Ͽ� ����.
  (setq x-ents2 (ssget "CP" p-ptl))
  (setq i 0)
  (repeat (sslength x-ents2)
    (ssdel (ssname x-ents2 i) x-ents)
    (setq i (1+ i))
  )
  (command "erase" x-ents "")

  (prompt "\n\t first trim")
  ;; ��輱�� �ٱ��� �Ѱ��� �����ؼ� ��輱�� �ɼ��ϰ� ����Ʈ����Ʈ�� �޾�
  ;; Ʈ���� ��ü�� ������.
  (setq p2 (getpoint "\n\t Box�� �ٱ��� �������� �����Ͻÿ�. ?:"))
  (command "offset" "T" pl1 p2 "")
  (setq p-pl2 (entget (setq pl2 (entlast))))
  (setq p-ptl2 (getpolyvtx p-pl2))
  (setq p-ptl2 (append p-ptl2 (list (nth 0 p-ptl2))))
  (command "erase" pl2 "") ; �ɼµ� ��輱 ����
  (repeat 2
    (command "Trim" pl1 "" "F")
    (mapcar 'command p-ptl2)
    (command "" "" )
  )
  
;;;  (prompt "\n\t other trim")
;;;  ;; ��Ÿ�� �ܰ����� Ʈ������ �ƴ��� ��ü(block)�� �߽߰� �����ϰ� �ٽ� Ʈ��
;;;  (setq key-xp5 1) ; ���ѹݺ� ������.
;;;  (while (setq x-ents3 (ssget "F" p-ptl2))
;;;    (setq i 0)
;;;    (repeat (sslength x-ents3)
;;;      (setq ename (cdr (assoc 0 (entget (setq ent (ssname x-ents3 i))))))
;;;      (if (= ename "INSERT")
;;;        (command "Explode" ent)
;;;      )
;;;      (setq i (1+ i))
;;;    )
;;;    (command "Trim" pl1 "" "F")
;;;    (mapcar 'command p-ptl2)
;;;    (command "" "" )
;;;    
;;;    ;; Ȥ�ó� ���ص��� �ƴ��ϴ� ��ü�� ������� ���ѹݺ��� ����.
;;;    (setq key-xp5 (1+ key-xp5))
;;;    (if (> key-xp5 3)
;;;      (exit)
;;;    )
;;;  )

  (ai_sysvar nil)
  (command "Undo" "End")
)

