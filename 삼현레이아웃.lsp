(defun SET_LAYER_TEXT (get_str / nn COLOR)
  (setq nn (str_ get_str))
  (if (= (substr nn 1 6) "콘센트")
    (cond ((= "GPS 220V" (vl-string-trim "콘센트 " nn))(SETQ COLOR 31))
	  ((= "GPS 440V" (vl-string-trim "콘센트 " nn))(SETQ COLOR 4))
	  ((= "UPS 220V" (vl-string-trim "콘센트 " nn))(SETQ COLOR 123))
	  ((= "UPS 440V" (vl-string-trim "콘센트 " nn))(SETQ COLOR 191)))
  )
    (cond ((= "GPS 220V" nn)(SETQ COLOR 3))
	  ((= "GPS 440V" nn)(SETQ COLOR 4))
	  ((= "UPS 220V" nn)(SETQ COLOR 1))
	  ((= "UPS 440V" nn)(SETQ COLOR 191))
	  ((= "VDP 220V" nn)(SETQ COLOR 2))
	  ((= "VDP 440V" nn)(SETQ COLOR 21)))
  
 (SETQ LST (LIST NN COLOR)) 
)
(defun M_LAYER (A B / A B)
 (setvar   "cmdecho" 0)
 ;(cond ((= a )
 (if (= (tblsearch "layer" a) nil)
    (PROGN 
    (command "-layer" "m" a "C" B "" "")
    (command "-layer" "m" (STRCAT a "-수용률") "C" B "" "")) ; 입력받은 레이어가 없으면 만든다
 (command "layer" "S" a ""))    ; 입력받은 레이어가 현재 레이어로 된다
   
 )

(DEFUN str_ (STR / STR 1_ST 2_ST N1 N2 LST_)
   
 (SETQ 1_ST (substr STR 1 (SETQ N1 (VL-STRING-SEARCH "_" STR))))
 
 (SETQ N2 (VL-STRING-SEARCH "_" (substr STR (+ 2 N1))))
  (IF (= (substr STR 1 6) "콘센트")
(SETQ 2_ST (substR (substr STR (+ 9 N2)) 1 N2))
 (SETQ 2_ST (substR (substr STR (+ 2 N2)) 1 N2))
)
  (COND ((= 2_ST "208")(SETQ 2_ST "220V") )
	((= 2_ST "440")(SETQ 2_ST "440V") ))
 (SETQ LST_ (STRCAT 1_ST " " 2_ST))
  
  )

(DEFUN lala (nn / NN )
 (SETQ NN (SET_LAYER_TEXT nn)) ;;레이어만들고
 (M_LAYER (CAR NN) (CADR NN))
 nn
)



(defun make_text (txt_ pt _72 _73 _LAYER / TXT_ PT _72 _73 )
  
(entmake (list (cons 0 "TEXT") ;***
               (cons 1 txt_) ;***
               (cons 6 "BYLAYER")
               (cons 7 "STANDARD") ;***
               (cons 8 _LAYER)
               (cons 10 pt) ;***
               (cons 11 pt) ;***
               (cons 39 0.0)
               (cons 40 200) ;***
	       (cons 41 0.6)
               (cons 72 _72)
	       (cons 73 _73)
               ))
)

(DEFUN D_POLAR ( PT DIS ANG / PT DIS ANG)
  (POLAR PT (/ (* pi ANG) 180) DIS)
  )

(defun c:layo (/ TXT_LST _layer _LAY )
  
  (setq ss (car(entsel)))
  (setq ent1 (cdr (assoc 1 (ENTGET ss))))
  (setq ent10 (cdr (assoc 10 (ENTGET ss))))
  
  (setq value_ ent1)
  (SETQ TXT_LST (LAYOSUB value_))

  (IF (= TXT_LST NIL)
   (PROGN
     (ENTMOD (APPEND (ENTGET SS) (LIST (CONS 62 1)) ))
   )
   (PROGN
  (setq txy (D_POLAR ent10 1000 270))
  (setq ee '(0 2500 1450 850))
  (setq txy_ing txy)
	 
  (foreach x TXT_LST
    (repeat (fix(NTH 4 x))
    (setq pt txy_ing)
    (setq i 0)
    
    (foreach y ee
      (setq pt (D_POLAR pt y 0))
      
      (IF (OR (= y 2500) (= y 1450))
	  (SETQ _72 1) (SETQ _72 0))
      
      (if (= i 0) (setq _layer (car(lala (NTH I x)))))
       
      (IF (= y 1450)
      (progn 
        (SETQ _LAY (STRcat _layer "-수용률" )) 
        (make_text (NTH I x) pt _72 2 _LAY))
      (progn
	(make_text (NTH I x) pt _72 2 _layer)
      )
      )
      
      
      (setq i (1+ i))
      
    )
    (SETQ txy_ing (D_POLAR txy_ing 450 270))
    (setq pt txy_ing)
  ))
  ));PROGN IF END
  
)