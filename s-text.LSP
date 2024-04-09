(defun chgterr (s)
   (if (/= s "Function cancelled") 
      (princ (strcat "\nError: " s))
   )
   (setq p nil)                    
   (setq *error* olderr)        
   (princ)
)

(defun c:sst (/ p l n e os as ns st s nsl osl sl si chf chm olderr)

   (setq olderr  *error*           
         *error* chgterr
         chm     0)
   (prompt "\n>> text를 선택하세요. 도면전체를 선택해도 text만 선택됩니다.")
   (setq p (ssget))                  
   (if p (progn                     
      (while (= 0 (setq osl (strlen (setq os 
             (getstring t "\n>> 바꾸고 싶은 text를 입력하세요: ")))))
             (princ "Null input invalid")
      )
      (setq nsl (strlen (setq ns (getstring t "\n>> 새로운 text를 입력하세요: "))))
      (setq l 0 n (sslength p))
      (while (< l n)                
         (if (= "TEXT"              
                (cdr (assoc 0 (setq e (entget (ssname p l))))))
            (progn
               (setq chf nil si 1)
               (setq s (cdr (setq as (assoc 1 e))))
               (while (= osl (setq sl (strlen
                             (setq st (substr s si osl)))))
                  (if (= st os)
                      (progn
                        (setq s (strcat (substr s 1 (1- si)) ns
                                        (substr s (+ si osl))))
                        (setq chf t)
                        (setq si (+ si nsl))
                      )
                      (setq si (1+ si))
                  )
               )
               (if chf (progn       
                  (setq e (subst (cons 1 s) as e))
                  (entmod e)        
                  (setq chm (1+ chm))
               ))
            )
         )
         (setq l (1+ l))
      )
   ))
   (princ "Changed ") 
   (princ chm)
   (princ " text lines.")
   (terpri)
   (setq *error* olderr)
   (princ)
)

(princ "\n\tChange Text loaded. Command: C:S-TEXT")
(princ)
