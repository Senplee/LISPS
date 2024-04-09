; �۾�����; 2001.8.14
; �۾���: �躴��
; ��ɾ�: CIMIPL
;       
;
; Initial PLan loaded. Start command with CIMIPL.
;
;����Ű ���� ���� ���� �κ�
(setq lfn27 1)


(defun m:ipl (/ bm old_cmd original_layer original_color original_ltype
	        sc ;pt1 pt2 pt3 pw1 pw2 pw3 pw4 pw2x pw2y
                ds  osm
	        ipl_ola  ipl_oco  ipl_err  ipl_oer  ipl_oli
	        ;dx dy lx ly sp spk bt xw yw yn cx cy p pt ns filename
	        ;aa bb cth cthp ctha exta extp cvn cvnk cn cd rn rd
	        );po pxt pxb pyl pyr lty dl1 dl2)

  
  

  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n�ʱ�ȭ ���, �༱, �߽ɼ� �׸��� ����� �׷��ִ� ����Դϴ�.")
  (princ)

  (ai_undo_on)
  
  
  (setvar "cmdecho" 0)  
  (setq sc      (getvar "dimscale")        
	ds      (getvar "dimstyle")
	bm      (getvar "blipmode")
	ipl_ola (getvar "clayer")
	ipl_oco (getvar "cecolor")
	ipl_oli (getvar "celtype")
	osm     (getvar "osmode")
	com_cen  nil com_bal  nil com_tex  nil com_dim  nil com_col  nil
	com_cen1 nil com_bal1 nil com_tex1 nil com_dim1 nil com_col1 nil
	original_layer c_layer original_color c_color original_ltype c_ltype
	draw_cen nil draw_cen1 nil draw_cen2 nil
	draw_bal nil draw_bal1 nil draw_bal2 nil
	draw_tex nil draw_tex1 nil draw_tex2 nil
	draw_dim nil draw_dim1 nil draw_dim2 nil
	draw_col nil draw_col1 nil draw_col2 nil
	key      "ok"
  )

  ;;
  ;; Internal error handler defined locally
  ;;
  (defun ipl_err (s)                   ; If an error (such as CTRL-C) occurs
                                       ; while this command is active...
    (if (/= s "Function cancelled")
      (if (= s "quit / exit abort")
        (princ)
        (princ (strcat "\nError: " s))
      )
    )
    (setvar "cmdecho" 0)
    (if ipl_oer                        ; If an old error routine exists
      (setq *error* ipl_oer)           ; then, reset it 
    )
    (setvar "cecolor" ipl_oco)
    (setvar "clayer" ipl_ola)
    (setvar "celtype" ipl_oli)
    
    (setvar "blipmode" 1)
    (setvar "snapbase" '(0 0))
    (command "_.undo" "_en")
    (ai_undo_off)
    (setvar "blipmode" bm)
    (setvar "cmdecho" 0)
    (command "_.DIMSTYLE" "_R" ds)
    (setvar "cmdecho" 1)
    (setvar "osmode" osm)
    (princ)
  )
  ;; Set our new error handler
  (if (not *DEBUG*)
    (if *error*                     
      (setq ipl_oer *error* *error* ipl_err) 
      (setq *error* ipl_err) 
    )
  )
  (command "_.undo" "_group")
;;; 
  (cond
     (  (not (setq dcl_id (ai_dcl "Initplan")))
        (alert "initplan.dcl file not found") ; is .DCL file loaded?
     )      
     (t ;(ai_undo_push)                           ; Everything's cool,
        (bound_in)                               ; so proceed!
        ;(ai_undo_pop)
     )
  )

  (command "_.undo" "_en")
  (ai_undo_off)
  (setvar "cecolor" ipl_oco)
  (setvar "clayer" ipl_ola)
  (setvar "celtype" ipl_oli)
  (setvar "blipmode" bm)
  (setvar "osmode"  osm)
  (setvar "cmdecho" 0)
  (command "_.DIMSTYLE" "_R" ds)
  (setvar "cmdecho" 1)
  
  (princ)
) ; end m:ipl

;==========================================================================================
(defun bound_in(/ ipl:pw1 ipl:pw2)

  (setvar "osmode" 1)
  (setvar "blipmode" 1)
  (setq ipl:pw1 T ipl:pw2 T)
  
  ;=========================================================================
  ;�⺻ setting �ϱ�..�׷���...
  ;=========================================================================  
  (ip_val_set) ;�ʿ亯�� setting
  
  (while ipl:pw1
  	(initget 1 "Dialog")  
  	(setq ipl:pw1 (getpoint "\n>>>Dialog/������ ���� �ϴ��� ���� : ENDPOINT of "))  	
  	(cond
  	    ((= ipl:pw1 "Dialog")  		
  	    	(setq pw1 ipl:pw1)
  		(ipl_dialog)
            ) 	
            (T  		
  		(setq pw1 ipl:pw1)
  		(setq ipl:pw1 nil)
            )    	
  	)
  )
  
  (while ipl:pw2
  	(initget 1 "Dialog")
  	(setq ipl:pw2 (getcorner pw1
        	      "\n>>>Dialog/������ ���� ����� ����: ENDPOINT of "))              
        (cond
  	    ((= ipl:pw2 "Dialog")  		
  	    	(setq pw2 ipl:pw1)  		
  		(ipl_dialog)
            ) 	
            (T
            	(setq pw2 ipl:pw2)
  		(setq ipl:pw2 nil)  		
            )    	
  	)
  )
  
  (setvar "osmode" 0)
  (setvar "blipmode" 0)
  (setq pw2x (car pw2) pw2y (cadr pw2))
  (if (> (rem pw2x (* sc 4)) (* sc 2))
    (setq pw2x (* sc 4 (1+ (fix (/ pw2x (* sc 4))))))
    (setq pw2x (* sc 4 (fix (/ pw2x (* sc 4)))))
  )
  (if (> (rem pw2y (* sc 4)) (* sc 2))
    (setq pw2y (* sc 4 (1+ (fix (/ pw2y (* sc 4))))))
    (setq pw2y (* sc 4 (fix (/ pw2y (* sc 4)))))
  )
  (setq pw2 (list pw2x pw2y))
  (setq pw3 (list (car pw2) (cadr pw1)))
  (setq pw4 (list (car pw1) (cadr pw2)))
  (setq dx (distance pw1 pw3) dy (distance pw3 pw2))  
  (setq sp "M")  
    
  ;=========================================================================
  ;�⺻ setting �ϱ�..�׷���...
  ;=========================================================================  
  (cen_distance2)
  (new_ipl)    ;�׷���...
)

;main���̾� �ڽ� loading�Ѵ�~
(defun ipl_dialog ()	
	(call_ipl)
)

;�ʿ��� ���� �⺻ setting �ϱ�..
(defun ip_val_set ()    
  (if (= exn nil)(setq exn "5"))    
  (if (= eyn nil)(setq eyn "5"))  
  (if (= edia nil)(setq edia "12"))  
  (if (= last_ed_diameter nil)(setq last_ed_diameter edia))  
  (if (= exs nil)(setq exs "500"))  
  (if (= last_ed_x_size nil)(setq last_ed_x_size exs))  
  (if (= eys nil)(setq eys "500"))
  (if (= last_ed_y_size nil)(setq last_ed_y_size eys))    
)

;================================================================================================
;=============================new_ipl============================================================
;================================================================================================
(defun new_ipl(/ sc_diameter balloon_hand)                             
  ;gogogo draw it (produced by Y.G Park)
  
  (command "_.DIMSTYLE" "_R" last_pop_dimstyle) ; dimstyle ����
  
  (setq cn  x_number ; x_number is (get_tile "ed_x_number")
        rn  y_number ; y_number is (get_tile "ed_y_number")
        lx  0
        ly  0
	c_x last_ed_x_size ; ��� ���� ũ�� ����
	c_y last_ed_y_size ; ��� ���� ũ�� ����
  )
  (cond ((/= last_rd_number   "0")(setq b_t "1")) ; ǳ�� ���� ����
	((/= last_rd_alphabet "0")(setq b_t "A"))
	((/= last_rd_xy       "0")(setq b_t "X"))
	((T)                      (setq b_t "1"))
  )
  (if (= last_tg_balloon   "0") (setq b_t  "N"))                ; ǳ�� ���Կ���
  (if (= last_tg_dimension "0") (setq y_n2 "N") (setq y_n2 "Y")); ġ�� ���Կ���
  (if (= last_tg_column    "0") (setq y_n  "N") (setq y_n  "Y")); ��� ���Կ���
  (setq cnt 0)
  (repeat (1- cn)
    (setq bb  (nth cnt column_data)
	  lx  (+ lx (atoi bb))
	  cnt (+ cnt 1)
    ) 
  )
  (setq cnt 0)
  (repeat (1- rn)
    (setq bb  (nth cnt row_data)
	  ly  (+ ly (atoi bb))
	  cnt (+ cnt 1)
    )
  ) ; �̻� 16���� lx �� ly�� ���ϱ� ���� ����
  
  (cond
    ((= sp "UL")
      (setq po (list (+ (car pw4) (* sc 52)) (- (cadr pw4) (* sc 68))))
    )
    ((= sp "UM")
      (setq po (list (+ (car pw4) (/ dx 2)) (- (cadr pw4) (* sc 68)))
            po (list (- (car po) (/ lx 2)) (cadr po))
      )
    )
    ((= sp "UR")
      (setq po (list (- (car pw2) (* sc 68) lx) (- (cadr pw2) (* sc 68))))
    )
    ((= sp "L")
      (setq po (list (+ (car pw1) (* sc 52)) (+ (cadr pw1) (/ dy 2) (/ ly 2))))
    )
    ((= sp "M")
      (setq po (list (+ (car pw1) (/ dx 2)) (+ (cadr pw1) (/ dy 2) (/ ly 2)))
            po (list (- (car po) (/ lx 2)) (cadr po))
      )
    )
    ((= sp "R")
      (setq po (list (- (car pw2) (* sc 68) lx)
                     (+ (cadr pw1) (/ dy 2) (/ ly 2))))
    )
    ((= sp "LL")
      (setq po (list (+ (car pw1) (* sc 52)) (+ (cadr pw1) (* sc 48) ly)))
    )
    ((= sp "LM")
      (setq po (list (+ (car pw1) (/ dx 2)) (+ (cadr pw1) (* sc 48) ly))
            po (list (- (car po) (/ lx 2)) (cadr po))
      )
    )
    ((= sp "LR")
      (setq po (list (- (car pw3) (* sc 68) lx) (+ (cadr pw3) (* sc 48) ly)))
    )
  )
  (setq pxt (polar po (dtr 90) (* sc 16))
        pxb (polar po (dtr 270) (+ ly (* sc 16)))
  )
  (if (= draw_cen nil)(setq draw_cen old_cen_lay))
  (if (= draw_cen1 nil)(setq draw_cen1 old_cen_col))
  (if (= draw_cen2 nil)(setq draw_cen2 old_cen_ltype))
  (set_col_lin_lay ipl:cprop)
  (command "line" pxt pxb "")
  
  (setq cnt 0)
  (repeat (1- cn)
    (setq bb (nth cnt column_data))
    (setq pxt (polar pxt 0 (atoi bb))
          pxb (polar pxb 0 (atoi bb))
    )
    (command "line" pxt pxb "")
    (setq cnt (+ cnt 1))
  )	 
   
  (setq pyl (polar po (dtr 270) ly)
        pyl (polar pyl (dtr 180) (* sc 16))
        pyr (polar pyl 0 (+ lx (* sc 32)))
  )
  
  (command "line" pyl pyr "")
  (setq cnt 0)
  (repeat (1- rn)
    (setq bb (nth cnt row_data))
    (setq pyl (polar pyl (dtr 90) (atoi bb))
          pyr (polar pyr (dtr 90) (atoi bb))
    )
    (command "line" pyl pyr "")
    (setq cnt (+ cnt 1))
  )
  ;(RTNLAY)

;=================================================================ġ�� �׸��� ����
(if (= y_n2 "Y")
 (progn
  (setvar "blipmode" 0)
  (if (= draw_dim nil)  (setq draw_dim  old_dim_lay))
  (if (= draw_dim1 nil) (setq draw_dim1 old_dim_col))
  (if (= draw_dim2 nil) (setq draw_dim2 old_dim_ltype))
  (set_col_lin_lay ipl:dprop)
  
  ( if 	( not ( stysearch "SIM")); "ã�� ������ ����"�̶� error�� �����ϱ� ����...
	( styleset "SIM")        
  )
  (command "dim1" "style" "sim")
  
  (setq pt1 (polar po (dtr 90) (* sc 16))
        dl1 (polar po (dtr 90) (* sc 36))
        dl2 (polar dl1 (dtr 90) (* sc 8))
  )
  (setq cnt 0)
  (setq bb (nth cnt column_data))
  (setq pt2 (polar pt1 0 (atoi bb)))
  (command "dim1" "hor" pt1 pt2 dl1 "")
  (setq cnt (+ cnt 1))
     (repeat (- cn 2)
        (setq bb (nth cnt column_data))
        (command "dim1" "con" (setq pt2 (polar pt2 0 (atoi bb))) "")
        (setq cnt (+ cnt 1))
      )
  (command "dim1" "hor" pt1 pt2 dl2 "")
  
  ; ���� �ּ��� �������� ġ���� �������� �ű�� ���� ��ģ����
  (setq pt1 (polar po (dtr 180) (* sc 16)) ; (setq pt1 (polar po 0 (+ lx (* sc 16)))
        pt1 (polar pt1 (dtr 270) ly)
        dl1 (polar pt1 (dtr 180) (* sc 20)) ; dl1 (polar pt1 0 (* sc 20))
        dl2 (polar dl1 (dtr 180) (* sc 8)) ; dl2 (polar dl1 0 (* sc 8))
  )
  (setq cnt 0)
  (setq bb (nth cnt row_data))
  (setq pt2 (polar pt1 (dtr 90) (atoi bb)))
  (command "dim1" "ver" pt1 pt2 dl1 "")
  (setq cnt (+ cnt 1))
     (repeat (- rn 2)
        (setq bb (nth cnt row_data))
        (command "dim1" "con" (setq pt2 (polar pt2 (dtr 90) (atoi bb))) "")
        (setq cnt (+ cnt 1))
      )
  (command "dim1" "ver" pt1 pt2 dl2 "")
  (set_col_lin_lay ipl:bprop)  
  
 ) ; end progn
) ; end if(= y_n2 "Y")  
  ;===============================================================ġ�� �׸��� �ϼ�

  ; ���� sc_diameter�� ����ڰ� �Է��� ǳ�������� �ݿ��ϱ� ���Ѱ���
  (setq sc_diameter (* sc (/ (atoi last_ed_diameter) 12.0)))        ; balloon����� ������=12
  (setq balloon_hand (* sc (/ (* (atoi last_ed_diameter) 4) 12.0))) ; balloon����� ������ ����
  ;=========================================================ǳ��(1A��) �׸��� ����
  (setq pt1 (polar po (dtr 90) (* sc 48)) 
        pt2 (polar pt1 (dtr 90) (+ balloon_hand (/ (* sc (atoi last_ed_diameter)) 2.0)))  ; pt2 (polar pt1 (dtr 90) (* sc 10))
  )
  ;===================balloon & balloon_text����================
  (if (= draw_bal nil) (setq draw_bal  old_bal_lay))
  (if (= draw_bal1 nil)(setq draw_bal1 old_bal_col))
  (if (= draw_bal2 nil)(setq draw_bal2 old_bal_ltype))  
  (if (= draw_tex nil) (setq draw_tex  old_tex_lay))
  (if (= draw_tex1 nil)(setq draw_tex1 old_tex_col))
  (if (= draw_tex2 nil)(setq draw_tex2 old_tex_ltype))
  ;============================================================ 
  (if (/= b_t "N")
    (progn
      (set_col_lin_lay ipl:bprop)      
      (setvar "blipmode" 0)
      (setq ns 1)
    )
  )
  
  (if (= b_t "1")
    (progn
      (command "insert" "balloon" pt1 sc_diameter "" -90) ; Draw balloon!~
      (set_col_lin_lay ipl:tprop)
      (command "text" "m" pt2 (* sc 5) 0 ns)
      (set_col_lin_lay ipl:bprop)      
      (setq cnt 0)
      (repeat (1- cn)
        (setq bb  (nth cnt column_data)
              pt1 (polar pt1 0 (atoi bb))
              pt2 (polar pt2 0 (atoi bb))
	      ns  (1+ ns)
	)      
        (command "insert" "balloon" pt1 sc_diameter "" -90) ; Draw balloon!~
	(set_col_lin_lay ipl:tprop)
        (command "text" "m" pt2 (* sc 5) 0 ns)
        (set_col_lin_lay ipl:bprop)
	(setq cnt (+ cnt 1))
      )
    )
  )
  ;���� �ּ��� ǳ��(1A)�� �����ʿ��� �������� �ű�� ���ؼ� ��ģ����
  (setq pt1 (polar po (dtr 180) (* sc 48)); (setq pt1 (polar po 0 (+ lx (* sc 48)))
        pt1 (polar pt1 (dtr 270) ly)
        pt2 (polar pt1 (dtr 180) (+ balloon_hand (/ (* sc (atoi last_ed_diameter)) 2.0))); pt2 (polar pt1 0 (* sc 10))
        ns  65
  )
  (if (= b_t "1")
    (progn
      (command "insert" "balloon" pt1 sc_diameter "" 0) ; Draw balloon!~
      (set_col_lin_lay ipl:tprop)
      (command "text" "m" pt2 (* sc 5) 0 (chr ns))
      (set_col_lin_lay ipl:bprop)      
      (setq cnt 0)
      (repeat (1- rn)
        (setq bb  (nth cnt row_data)
              pt1 (polar pt1 (dtr 90) (atoi bb))
              pt2 (polar pt2 (dtr 90) (atoi bb))
              ns  (1+ ns)
	)
        (command "insert" "balloon" pt1 sc_diameter "" 0) ; Draw balloon!~
	(set_col_lin_lay ipl:tprop)
        (command "text" "m" pt2 (* sc 5) 0 (chr ns))
        (set_col_lin_lay ipl:bprop)
	(setq cnt (+ cnt 1))
      )
    )
  )
;=========================================================ǳ��(1A��) �׸��� �ϼ�
;=========================================================ǳ��(A1��) �׸��� ����
  (setq pt1 (polar po (dtr 90) (* sc 48))
        pt2 (polar pt1 (dtr 90) (+ balloon_hand (/ (* sc (atoi last_ed_diameter)) 2.0)))
	ns 65
  )
  
  (if (= b_t "A")
    (progn
      (command "insert" "balloon" pt1 sc_diameter "" -90) ; Draw balloon!~
      (set_col_lin_lay ipl:tprop)
      (command "text" "m" pt2 (* sc 5) 0 (chr ns))
      (set_col_lin_lay ipl:bprop)      
      (setq cnt 0)
      (repeat (1- cn)
        (setq bb  (nth cnt column_data)
              pt1 (polar pt1 0 (atoi bb))
              pt2 (polar pt2 0 (atoi bb))
	      ns  (1+ ns)
	)
	(set_col_lin_lay ipl:bprop)      
        (command "insert" "balloon" pt1 sc_diameter "" -90) ; Draw balloon!~
	(set_col_lin_lay ipl:tprop)
        (command "text" "m" pt2 (* sc 5) 0 (chr ns))
        (set_col_lin_lay ipl:bprop)	
	(setq cnt (+ cnt 1))
      )
    )
  )
  ;���� �ּ��� ǳ��(A1)�� �����ʿ��� �������� �ű�� ���ؼ� ��ģ����
  (setq pt1 (polar po (dtr 180) (* sc 48)); (setq pt1 (polar po 0 (+ lx (* sc 48)))
        pt1 (polar pt1 (dtr 270) ly)
        pt2 (polar pt1 (dtr 180) (+ balloon_hand (/ (* sc (atoi last_ed_diameter)) 2.0))); pt2 (polar pt1 0 (* sc 10))
        ns  1
  )
  (if (= b_t "A")
    (progn
      (set_col_lin_lay ipl:bprop)
      (command "insert" "balloon" pt1 sc_diameter "" 0) ; Draw balloon!~
      (set_col_lin_lay ipl:tprop)
      (command "text" "m" pt2 (* sc 5) 0 ns)
      (set_col_lin_lay ipl:bprop)      
      (setq cnt 0)
      (repeat (1- rn)
        (setq bb  (nth cnt row_data)
              pt1 (polar pt1 (dtr 90) (atoi bb))
              pt2 (polar pt2 (dtr 90) (atoi bb))
              ns  (1+ ns)
	)
	(set_col_lin_lay ipl:bprop)
        (command "insert" "balloon" pt1 sc_diameter "" 0) ; Draw balloon!~
	(set_col_lin_lay ipl:tprop)
        (command "text" "m" pt2 (* sc 5) 0 ns)
        (set_col_lin_lay ipl:bprop)	
	(setq cnt (+ 1 cnt))
      )
    )
  )
  ;=========================================================ǳ��(A1��) �׸��� �ϼ� 
  ;=========================================================ǳ��(xy��) �׸��� ����
  (setq pt1 (polar po (dtr 90) (* sc 48))
        pt2 (polar pt1 (dtr 90) (+ balloon_hand (/ (* sc (atoi last_ed_diameter)) 2.0)))
        pt2 (polar pt2 (dtr 270) (* sc 2.5))
        pt3 (polar pt2 0 (* sc 1.2))
        ns  1
  )
  (if (= b_t "X")
    (progn
      (set_col_lin_lay ipl:bprop)
      (command "insert" "balloon" pt1 sc_diameter "" -90) ; Draw balloon!~
      (set_col_lin_lay ipl:tprop)
      (command "text" "r" pt2 (* sc 5) 0 "X")
      (command "text" pt3 (* sc 3) 0 ns)
      (set_col_lin_lay ipl:bprop)      
      (setq cnt 0)
      (repeat (1- cn)
        (setq bb (nth cnt column_data)
             pt1 (polar pt1 0 (atoi bb))
             pt2 (polar pt2 0 (atoi bb))
             pt3 (polar pt3 0 (atoi bb))
             ns  (1+ ns)
	)      
        (command "insert" "balloon" pt1 sc_diameter "" -90) ; Draw balloon!~
	(set_col_lin_lay ipl:tprop)
        (command "text" "r" pt2 (* sc 5) 0 "X")
        (command "text" pt3 (* sc 3) 0 ns)
        (set_col_lin_lay ipl:bprop)	
	(setq cnt (+ cnt 1))
      )
    )
  )
  ; ���� �ּ��� ǳ��(xy��)�� �����ʿ��� �������� �ű�� ���� ��ģ����.
  (setq pt1 (polar po (dtr 180) (* sc 48)) ; (setq pt1 (polar po 0 (+ lx (* sc 48)))
        pt1 (polar pt1 (dtr 270) ly)
        pt2 (polar pt1 (dtr 180) (+ balloon_hand (/ (* sc (atoi last_ed_diameter)) 2.0))) ; pt2 (polar pt1 0 (* sc 10))
        pt2 (polar pt2 (dtr 270) (* sc 2.5))
        pt3 (polar pt2 (dtr 180) (* sc 0.3)) ; pt3 (polar pt2 0 sc)
  )
  (setq ns 1)
  (if (= b_t "X")
    (progn
      (set_col_lin_lay ipl:bprop)
      (command "insert" "balloon" pt1 sc_diameter "" 0) ; Draw balloon!~
      (set_col_lin_lay ipl:tprop)
      (command "text" "r" pt2 (* sc 5) 0 "Y")
      (command "text" pt3 (* sc 3) 0 ns)
      (set_col_lin_lay ipl:bprop)      
      (setq cnt 0)
      (repeat (1- rn)
        (setq bb  (nth cnt row_data)
              pt1 (polar pt1 (dtr 90) (atoi bb))
              pt2 (polar pt2 (dtr 90) (atoi bb))
              pt3 (polar pt3 (dtr 90) (atoi bb))
              ns  (1+ ns)
	)      
	(set_col_lin_lay ipl:bprop)
        (command "insert" "balloon" pt1 sc_diameter "" 0) ; Draw balloon!~
	(set_col_lin_lay ipl:tprop)
        (command "text" "r" pt2 (* sc 5) 0 "Y")
        (command "text" pt3 (* sc 3) 0 ns)
        (set_col_lin_lay ipl:bprop)	
	(setq cnt (+ cnt 1))
      )
    )
  )
  (if (/= b_t "N")
	(set_col_lin_lay ipl:bprop)
    ;(RTNLAY)(setvar "cmdecho" 0)
  )
  ;=========================================================ǳ��(xy��) �׸��� �ϼ�
  ;=========================================================��� �׸��� ����  
  (if (= draw_col nil) (setq draw_col old_col_lay))
  (if (= draw_col1 nil) (setq draw_col1 old_col_col))
  (if (= draw_col2 nil) (setq draw_col2 old_col_ltype))  
  (setq c_x (atoi c_x))
  (setq c_y (atoi c_y))  
  (if (= y_n "Y")
    (progn
      (set_col_lin_lay ipl:mprop)
      (setvar "blipmode" 0)
      (setq p (polar po (dtr 270) ly)
            p (polar p (dtr 270) (/ c_y 2.0))
            p (polar p (dtr 180) (/ c_x 2.0))
            cnt2 0
      )
      (repeat rn
        (setq po p)
        (command "pline" p (setq pt (polar p 0 c_x))
                  (setq pt (polar pt (dtr 90) c_y)) (setq pt (polar pt (dtr 180) c_x)) "C")
	(setq cnt 0)
        (repeat (1- cn)
              (setq bb (nth cnt column_data))
              (setq p (polar p 0 (atoi bb)))
              (command "pline" p (setq pt (polar p 0 c_x))
                  (setq pt (polar pt (dtr 90) c_y)) (setq pt (polar pt (dtr 180)
                   c_x)) "C")
	      (setq cnt (+ 1 cnt)) 
        ) ; end repeat(1- cn)
	(setq bb (nth cnt2 row_data))
	(if (/= bb nil)
          (setq p (polar po (dtr 90) (atoi bb)))
	)  
	(setq cnt2 (+ cnt2 1))
      ) ; end repeat rn
      (set_col_lin_lay ipl:bprop)
    ) ; end progn
  ) ; end if(= y_n "Y")
  ;=======================================================================��� �׸��� �ϼ�
  ;======================================================================BYLAYER ���� ����
  (setvar "cmdecho" 0)
  ;======================================================================BYLAYER ���� �ϼ�  
  (princ)
)
;=====================================================================================
;=====================================================================================
;==================================new logic==========================================
;=====================================================================================
;=====================================================================================

(defun slide_tile(tile slide / x y)
  (setq x (dimx_tile tile))
  (setq y (dimx_tile tile))
  (start_image tile)
  (fill_image 0 0 x y -2) ; <<-2>> is BGLCOLOR(current background of the AutoCAD graphic screen
  (slide_image 0 0 x y slide)
  (end_image)
)

(defun balloon_type()
  (cond ((/= "0" (get_tile "rd_number"))
	 (progn (setq balloon_type_number 1) (slide_tile "balloon_image" "al_core(bal_1A)"))
	)
	((/= "0" (get_tile "rd_alphabet"))
	 (progn (setq balloon_type_number 2) (slide_tile "balloon_image" "al_core(bal_A1)"))
	)
	((/= "0" (get_tile "rd_xy"))
	 (progn (setq balloon_type_number 3)(slide_tile "balloon_image" "al_core(bal_xy)"))
	) 
  ); balloon_type_number�� ���������� ���� ǳ�� �׸��� ��ƾ���� �Ѱ���
)  
(defun call_ipl(/ ok_all clear_all tmplst dsn)
  (setq ok_all nil clear_all nil dimstyle_list nil) ; ok, cancel��ư �ʱ�ȭ
  (setq old:cprop ipl:cprop
	old:bprop ipl:bprop
	old:tprop ipl:tprop
	old:dprop ipl:dprop
	old:mprop ipl:mprop
  )
  (setq tmplst (tblnext "DIMSTYLE" T))
  (while tmplst
  	(setq dsn (cdr (assoc 2 tmplst))
  	      dimstyle_list (append dimstyle_list (List dsn))
  	      tmplst (tblnext "DIMSTYLE")
  	)
  )	      
  (if (not (new_dialog "dd_ipl" dcl_id)) (exit))
  
  (start_list "pop_dimstyle")
  (setq cnt 0 dim_num nil)
  (repeat (length dimstyle_list)
  	(add_list (nth cnt dimstyle_list))
  	(if (= (getvar "DIMSTYLE") (nth cnt dimstyle_list))
  	  (setq dim_num cnt)
  	)
  	(setq cnt (+ cnt 1))
  )
  (end_list)
  (set_tile "pop_dimstyle" (itoa dim_num))	
  (set_tile "tg_balloon" "1")
  (set_tile "tg_dimension" "1")
  (set_tile "tg_column" "1")
  (set_tile "rd_number" "1")
  (if (= exn nil)(setq exn "5"))  
  (set_tile "ed_x_number" exn)
  (if (= eyn nil)(setq eyn "5"))
  (set_tile "ed_y_number" eyn)
  (if (= edia nil)(setq edia "12"))
  (set_tile "ed_diameter" edia)
  (if (= exs nil)(setq exs "500"))
  (set_tile "ed_x_size" exs)
  (if (= eys nil)(setq eys "500"))
  (set_tile "ed_y_size" eys)
  (slide_tile "initplan_image" "al_core(init_all)") ; slide_tile�� ���� ���� �Լ���.
  (slide_tile "balloon_image" "al_core(bal_1A)")
  ;==================================================================
  (set_tile ipl_prop_type "1")    
  (@get_eval_prop ipl_prop_type ipl:prop)     
  (action_tile "b_name" "(@getlayer)")
  (action_tile "b_color" "(@getcolor)")
  (action_tile "b_line" "(@getlin)")
  (action_tile "color_image" "(@getcolor)")
  (action_tile "c_bylayer" "(@bylayer_do T)"); T=color or nil=linetype
  (action_tile "t_bylayer" "(@bylayer_do nil)"); T=color or nil=linetype
  (action_tile "prop_radio" "(setq ipl_prop_type $value)(@get_eval_prop ipl_prop_type ipl:prop)")         
  ;==================================================================  
  (action_tile "bn_distance" "(cen_distance)")
  (action_tile "tg_balloon" "(init_plan)")
  (action_tile "tg_dimension" "(init_plan)")
  (action_tile "tg_column" "(init_plan)")
  (action_tile "balloon_type_radio" "(balloon_type)")
  ;(action_tile "pop_dimstyle" "(pop_dimstyle $value)")
  (action_tile "accept" "(press_ok)(done_dialog)")
  (action_tile "cancel" "(press_cancel)(done_dialog)")
  (start_dialog)
  (done_dialog)
  
  ;(if (= key "ok")
  ;    (progn (cen_distance2); ����ڰ� �߽ɼ� ������ �Է����� �ʰ� OK�� ���������� ���!
  ;	     (new_ipl)
  ;    )
  ;)
  (if (= key "cancel") (reset_dialog))
)

(defun press_cancel()
  	(setq key "cancel")
  	(setq ipl:cprop old:cprop
	      ipl:bprop old:bprop
	      ipl:tprop old:tprop
	      ipl:dprop old:dprop
	      ipl:mprop old:mprop
	)
  )
(defun press_ok()
  (prop_save ipl:prop)
  (setq last_tg_balloon   (get_tile "tg_balloon")
        last_tg_dimension (get_tile "tg_dimension")
	last_tg_column    (get_tile "tg_column")
	last_rd_number    (get_tile "rd_number")
	last_rd_alphabet  (get_tile "rd_alphabet")
	last_rd_xy        (get_tile "rd_xy")
	last_ed_diameter  (get_tile "ed_diameter")
	last_ed_x_size    (get_tile "ed_x_size")
	last_ed_y_size    (get_tile "ed_y_size")
	last_pop_dimstyle (nth (atoi (get_tile "pop_dimstyle")) dimstyle_list)
	exn               (get_tile "ed_x_number")
	eyn               (get_tile "ed_y_number")
	exs               (get_tile "ed_x_size")
	eys               (get_tile "ed_y_size")
	edia              (get_tile "ed_diameter")
  )
  (setq key "ok")
)
(defun cen_distance2() ; ����ڰ� �߽ɼ� ������ �Է����� �ʰ� OK�� ���������� ���!
  (setq x_num (atoi exn)
	y_num (atoi eyn)
	 cnt        1   x_number    x_num  y_number y_num
	 column_idx nil column_data nil    dd nil
	 row_idx    nil row_data    nil
   )
   (setq filename_ipl (strcat "init_plan" exn "_" eyn ".spl"))
   (setq dd (open filename_ipl "r"))
   (while (< 1 x_num)
     (setq column_idx (append column_idx (list cnt))) ; counted "column_idx"
     (if (= dd nil) ; ������ �������� ������...
       (setq column_data (append column_data (list "6000"))) ; save "column_data" "3000"
       (progn
	 (setq ee (read-line dd))
	 (setq column_data (append column_data (list ee))) ; save "column_data" ee
       )
     )
     (setq cnt (+ 1 cnt) x_num (- x_num 1))
   )
   
   (setq cnt 1)
   (while (< 1 y_num)
     (setq row_idx (append row_idx (list cnt)))
     (if (= dd nil) ; ������ �������� ������...
       (setq row_data (append row_data (list "6000"))) ; save "row_data" "3000"
       (progn
	 (setq ee (read-line dd))
	 (setq row_data (append row_data (list ee))) ; save "row_data" ee
       )
     )  
     (setq cnt (+ 1 cnt) y_num (- y_num 1))
   )
   (if (/= nil dd)(close dd))
)

(defun cen_distance(/ x_num y_num cnt dd ee)
   (setq x_num (atoi (get_tile "ed_x_number"))
	 y_num (atoi (get_tile "ed_y_number"))
	 cnt        1   x_number    x_num  y_number y_num
	 column_idx nil column_data nil    dd nil
	 row_idx    nil row_data    nil
	 c_idx      nil r_idx       nil
   )
   (setq filename_ipl (strcat "init_plan" (get_tile "ed_x_number") "_" (get_tile "ed_y_number") ".spl"))
   (setq dd (open filename_ipl "r"))
   (if (not (new_dialog "set_distance" dcl_id)) (exit))
   (start_list "list_column")
   (while (< 1 x_num)
     (setq column_idx (append column_idx (list cnt))) ; counted "column_idx"
     (if (= dd nil) ; ������ �������� ������...
       (progn  
         (add_list (strcat "NO. " (itoa cnt) "           6000"))
	 (setq column_data (append column_data (list "6000"))) ; save "column_data" "3000"
       ) 	  
       (progn
	 (setq ee (read-line dd))
         (add_list (strcat "NO. " (itoa cnt) "           " ee))
	 (setq column_data (append column_data (list ee))) ; save "column_data" ee
       )
     )
     (setq cnt (+ 1 cnt) x_num (- x_num 1))
   )
   (end_list) ; end "list_column"
  
   (setq cnt 1)
   (start_list "list_row")
   (while (< 1 y_num)
     (setq row_idx (append row_idx (list cnt)))
     (if (= dd nil) ; ������ �������� ������...
       (progn 
         (add_list (strcat "NO. " (itoa cnt) "           6000"))
	 (setq row_data (append row_data (list "6000"))) ; save "row_data" "3000"
       )
       (progn
	 (setq ee (read-line dd))
	 (add_list (strcat "NO. " (itoa cnt) "           " ee))
	 (setq row_data (append row_data (list ee))) ; save "row_data" ee
       )
     )  
     (setq cnt (+ 1 cnt) y_num (- y_num 1))
   )
   (end_list) ; end "list_column"
   (if (/= nil dd)(close dd))
   (action_tile "list_column" "(column_act)")
   (action_tile "list_row" "(row_act)")
   (action_tile "bn_save" "(save_act)")
   (action_tile "accept" "(ok_act)") 
   (start_dialog)
)
(defun ok_act(/ dd cnt x_cnt y_cnt)
   (setq x_cnt x_number y_cnt y_number cnt 0)
   (setq filename_ipl (strcat "init_plan" (itoa x_number) "_" (itoa y_number) ".spl"))
   (setq dd (open filename_ipl "w"))
   (while (< 1 x_cnt)
      (write-line (nth cnt column_data) dd)
      (setq x_cnt (- x_cnt 1) cnt (+ cnt 1))
   )
   (setq cnt 0)
   (while (< 1 y_cnt)
      (write-line (nth cnt row_data) dd)
      (setq y_cnt (- y_cnt 1) cnt (+ cnt 1))
   )
   (close dd)
   (done_dialog 1)
)  
(defun column_act(/ c_idx2 cnt cnt2)
   (setq cnt 1 cnt2 y_number r_idx nil)
   (start_list "list_row")	 
   (while (< 1 cnt2)
     (add_list (strcat "NO. " (itoa cnt) "           " (nth (- cnt 1) row_data)))
     (setq cnt (+ 1 cnt) cnt2 (- cnt2 1))
   )
   (end_list)
   (setq c_idx (get_tile "list_column"))
   (setq c_idx2 (nth (atoi c_idx) column_data))
   (set_tile "ed_distance" c_idx2)
)
(defun row_act(/ r_idx2 cnt cnt2)
   (setq cnt 1 cnt2 x_number c_idx nil)
   (start_list "list_column")
   (while (< 1 cnt2)
     (add_list (strcat "NO. " (itoa cnt) "           " (nth (- cnt 1) column_data)))
     (setq cnt (+ 1 cnt) cnt2 (- cnt2 1))
   )
   (end_list)
   (setq r_idx (get_tile "list_row"))
   (setq r_idx2 (nth (atoi r_idx) row_data))
   (set_tile "ed_distance" r_idx2)
)

(defun save_act(/ a b c d cnt x_cnt x_cnt2 y_cnt y_cnt2 c_idx_list r_idx_list c_leng r_leng)
  (if (or (/= c_idx nil) (/= r_idx nil))
   (progn 
   (setq x_cnt 0 x_cnt2 x_number y_cnt 0 y_cnt2 y_number) ; x_number = get_tile "ed_x_number"
   (if (= r_idx nil) ; ���ο��̸� 
     (progn
       (setq a (strlen c_idx)
	 b 1
       )
       (while (<= b a)
         (setq c (substr c_idx b 1))
         (if (/= c " ")(setq d (append d (list c))))
         (setq b (+ 1 b))
       ) ; �̻� 8���� c_idx�� ����Ʈȭ ���ִ� ��ƾ��.(������ ���ڿ�)
       (setq c_idx_list d
             c_leng     (length c_idx_list)
       )
       (while (< x_cnt c_leng)
          (setq column_data (change_list_item (nth x_cnt c_idx_list) column_data (get_tile "ed_distance")))
          (setq x_cnt (+ 1 x_cnt))
       )
       (setq cnt 1)
       (start_list "list_column")
       (while (< 1 x_cnt2)
          (add_list (strcat "NO. " (itoa cnt) "           " (nth (- cnt 1) column_data)))
          (setq cnt (+ 1 cnt) x_cnt2 (- x_cnt2 1))
       )
       (end_list)
     ) ; end progn
   )
   (if (= c_idx nil) ; ���ο��̸�
     (progn
       (setq a (strlen r_idx)
	 b 1
       )
       (while (<= b a)
         (setq c (substr r_idx b 1))
         (if (/= c " ")(setq d (append d (list c))))
         (setq b (+ 1 b))
       ) ; �̻� 8���� r_idx�� ����Ʈȭ ���ִ� ��ƾ��.
       (setq r_idx_list d
	     r_leng     (length r_idx_list)
       )
       (while (< y_cnt r_leng)
          (setq row_data (change_list_item (nth y_cnt r_idx_list) row_data (get_tile "ed_distance")))
          (setq y_cnt (+ 1 y_cnt))
       )
       (setq cnt 1)
       (start_list "list_row")
       (while (< 1 y_cnt2)
          (add_list (strcat "NO. " (itoa cnt) "           " (nth (- cnt 1) row_data)))
          (setq cnt (+ 1 cnt) y_cnt2 (- y_cnt2 1))
       )
       (end_list)
     ) ; end progn 
   ) ; end if
  )
 )   
)  
(defun change_list_item(n old_list new_item / list_leng cnt temp_list)
  (setq list_leng (length old_list)
        cnt       0
	temp_list nil
  )
  (while (< cnt list_leng)
      (if (= (atoi n) cnt)
	    (setq temp_list (append temp_list (list new_item)))
	    (setq temp_list (append temp_list (list (nth cnt old_list))))
      )
      (setq cnt (+ 1 cnt))
  )
  temp_list
)  

(defun init_plan(); �࿭,ġ��,����� ���Կ��θ� initplan_image�� ��Ÿ��
    (if (/= "0" (get_tile "tg_balloon"))
        (progn   ; ���� mode_tile���� enable�Ӽ� ����
	     (mode_tile "rd_number" 0)(mode_tile "rd_alphabet" 0)(mode_tile "rd_xy" 0)(mode_tile "ed_diameter" 0)
	     (if (/= "0" (get_tile "tg_dimension"))
	         (progn
		      (mode_tile "pop_dimstyle" 0)
		      (if (/= "0" (get_tile "tg_column"))
			 (progn
			   (mode_tile "ed_x_size" 0)(mode_tile "ed_y_size" 0)
		           (slide_tile "initplan_image" "al_core(init_all)")
			 )
			 (progn
			   (mode_tile "ed_x_size" 1)(mode_tile "ed_y_size" 1)
		           (slide_tile "initplan_image" "al_core(init_b_d)")
			 )  
		      )
		 )  
		 (progn
		      (mode_tile "pop_dimstyle" 1)
                      (if (/= "0" (get_tile "tg_column"))
			 (progn
			   (mode_tile "ed_x_size" 0)(mode_tile "ed_y_size" 0)
		           (slide_tile "initplan_image" "al_core(init_c_b)")  
			 )
			 (progn
			   (mode_tile "ed_x_size" 1)(mode_tile "ed_y_size" 1)
		           (slide_tile "initplan_image" "al_core(init_bal)")
			 )  
		      )
		 )
	     )
	 ) 
	 (progn
	     (mode_tile "rd_number" 1)(mode_tile "rd_alphabet" 1)(mode_tile "rd_xy" 1)(mode_tile "ed_diameter" 1)
	     (if (/= "0" (get_tile "tg_dimension"))
	         (progn
		      (mode_tile "pop_dimstyle" 0)
		      (if (/= "0" (get_tile "tg_column"))
			 (progn
			    (mode_tile "ed_x_size" 0)(mode_tile "ed_y_size" 0)
		            (slide_tile "initplan_image" "al_core(init_c_d)")
			 )
			 (progn
			    (mode_tile "ed_x_size" 1)(mode_tile "ed_y_size" 1)
		            (slide_tile "initplan_image" "al_core(init_dim)")
			 )  
		      )
		 )  
		 (progn
		      (mode_tile "pop_dimstyle" 1)
                      (if (/= "0" (get_tile "tg_column"))
			 (progn
			   (mode_tile "ed_x_size" 0)(mode_tile "ed_y_size" 0) 
		           (slide_tile "initplan_image" "al_core(init_col)")
			 )
			 (progn
			   (mode_tile "ed_x_size" 1)(mode_tile "ed_y_size" 1) 
		           (slide_tile "initplan_image" "al_core(init)")
			 )  
		      )
		 )
	     )
	 )
     )
)
(defun reset_dialog()
  (done_dialog)  
)  
;===========================================================
(setq ipl:cprop  (Prop_search "ipl" "center"))
(setq ipl:bprop  (Prop_search "ipl" "balloon"))
(setq ipl:tprop  (Prop_search "ipl" "text"))
(setq ipl:dprop  (Prop_search "ipl" "dimension"))
(setq ipl:mprop  (Prop_search "ipl" "column"))
(setq ipl:prop '(ipl:cprop ipl:bprop ipl:tprop ipl:dprop ipl:mprop))

(if (null ipl_prop_type) (setq ipl_prop_type "rd_center"))
;======================================================

(defun C:CIMIPL () (m:ipl))
(princ)