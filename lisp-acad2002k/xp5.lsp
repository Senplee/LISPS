
;; xclip된 블럭을 삽입된 형태로 분해함. (explode 및 trim이용)
(defun c:xp5()
  (command "Undo" "Be")
  (ai_sysvar '(("osmode" . 0)("cmdecho" . 0)))
  (setq k T)
  
  ;; 블럭의 이름을 받아들임.
  (while k
    (setq x-ent (entsel "\n\t Xref-Block Select ?:"))
    (if (= (cdr (assoc 0 (setq x-entl (entget (car x-ent))))) "INSERT")
      (setq k nil b_name (cdr (assoc 2 x-entl)))
      (prompt "\t ??Select is Not Block?? Select again ")
    )
  )
  
  ;; 블럭의 회전 및 축척 등을 기본으로 조정함.
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
;;;  ;; 블럭의 삽입점에 블럭의 이름을 기입.  
;;;  (command "TEXT" xref-10 300 "" b_name)

  ;; 블럭의 경계선을 생성하여 포인트리스트를 받아들임.
  (command "XCLIP" x-ent "" "P")
  (setq p-pl1 (entget (setq pl1 (entlast))))
  (setq p-ptl (getpolyvtx p-pl1))

  (prompt "\n\t block-explode point")
  ;; 블럭을 분해하여 전체개체를 선택함.(이후에 erase및 trim을 하기위함) 
  (setq entx (entlast) x-ents (ssadd))
  (command "explode" x-ent)
  (while (setq ent (entnext entx))
    (setq x-ents (ssadd ent x-ents))
    (setq entx ent)
  )

  (prompt "\n\t select outside entty")
  ;; 경계선의 바깥에 존재하는 개체를 선택하여 지움.
  (setq x-ents2 (ssget "CP" p-ptl))
  (setq i 0)
  (repeat (sslength x-ents2)
    (ssdel (ssname x-ents2 i) x-ents)
    (setq i (1+ i))
  )
  (command "erase" x-ents "")

  (prompt "\n\t first trim")
  ;; 경계선의 바깥점 한곳을 선택해서 경계선을 옵셋하고 포인트리스트를 받아
  ;; 트림할 개체를 선택함.
  (setq p2 (getpoint "\n\t Box의 바깥쪽 한지점을 선택하시오. ?:"))
  (command "offset" "T" pl1 p2 "")
  (setq p-pl2 (entget (setq pl2 (entlast))))
  (setq p-ptl2 (getpolyvtx p-pl2))
  (setq p-ptl2 (append p-ptl2 (list (nth 0 p-ptl2))))
  (command "erase" pl2 "") ; 옵셋된 경계선 삭제
  (repeat 2
    (command "Trim" pl1 "" "F")
    (mapcar 'command p-ptl2)
    (command "" "" )
  )
  
;;;  (prompt "\n\t other trim")
;;;  ;; 울타리 외곽에서 트림되지 아니한 객체(block)를 발견시 분해하고 다시 트림
;;;  (setq key-xp5 1) ; 무한반복 방지용.
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
;;;    ;; 혹시나 분해되지 아니하는 개체가 있을경우 무한반복을 방지.
;;;    (setq key-xp5 (1+ key-xp5))
;;;    (if (> key-xp5 3)
;;;      (exit)
;;;    )
;;;  )

  (ai_sysvar nil)
  (command "Undo" "End")
)

