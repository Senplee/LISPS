(defun c:az (/ ent obj ss)
 (and
  (setq ent (entsel "\n기준 블럭 선택: "))
  (setq obj (vlax-ename->vla-object (car ent)))
  (= (vla-get-objectname obj) "AcDbBlockReference")
  (setq ss (ssget "_x"(list (cons 0 "insert")(cons 2 (vla-get-name obj)))))
  (sssetfirst nil ss)
 )
)