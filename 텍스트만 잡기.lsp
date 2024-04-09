(defun c:at(/ ss OS )

(defun *error* (msg)(princ "error: ")(princ msg) 
(setvar "osmode" os) (command "clayer" "0") (princ) )
(setq os (getvar "osmode"))

  (prompt "\n텍스트필터링-객체세트를 선택하세요")
  (setq ss (ssget (list (cons 0 "text"))))
  (sssetfirst nil ss) 
(princ)
)