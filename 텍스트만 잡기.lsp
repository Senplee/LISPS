(defun c:at(/ ss OS )

(defun *error* (msg)(princ "error: ")(princ msg) 
(setvar "osmode" os) (command "clayer" "0") (princ) )
(setq os (getvar "osmode"))

  (prompt "\n�ؽ�Ʈ���͸�-��ü��Ʈ�� �����ϼ���")
  (setq ss (ssget (list (cons 0 "text"))))
  (sssetfirst nil ss) 
(princ)
)