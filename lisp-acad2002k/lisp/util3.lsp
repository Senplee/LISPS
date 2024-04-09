;������¥ :2001.8.10
;�۾���: ������
;��ɾ�	
;	C:cimBB () 	�� ���̸� �̿��� box�׸��� & Rotate ���
;	C:cimBO () 	3���� �̿��� �簢�� �׸���
;	C:cimVV () 		���� V ��ȣ�� �׸��� ���
;	C:cimKk () 		������ȣ�� �׸��� ���
;	C:cimCEN () 	�߽ɼ� �׸��� (���̾� cen,color Yellow)
;   C:cimXX () 		x�ױ�
;   C:cimbx() 	�ڽ��� void line�ױ�
;	C:cimCHCO	color ����
;	C:cimCHLA	layer ���� 
;	C:cimCHLD	��ȭ���� �̿� layer ����



;����Ű ���� ���� ���� �κ�
(setq lfn03 1)

(defun m:PBOX ( / p1 lx ly p)
  (ai_err_on) 
  (ai_undo_on)
  (command "_.undo" "_group")
  
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n�������� �ڽ��� �׸��� ����Դϴ�.")

     (initget 1)
     (setq p1 (getpoint "\n���� �ϴ� ��: "))
     (initget 1)
     (setq lx (getdist p1 "\n���α��� �Է� �Ǵ� ����(mm): "))
     (initget 1)
     (setq ly (getdist p1 "\n���α��� �Է� �Ǵ� ����(mm): "))
     
     (setvar "blipmode" 0)
     (setvar "cmdecho" 0)
     (setvar "osmode" 0)

     (command "pline"
         (setq p p1)
         (setq p (polar p 0 lx))
         (setq p (polar p (dtr 90) ly))
         (polar p (dtr 180) lx)
         "close"
     )     
     (princ "\n���α���(mm): ")
     (princ lx)
     (princ "     ���α���(mm): ")
     (princ LY)
     
     (setvar "osmode" 167)
     (princ "\nȸ�� ���� ���� �Ǵ� [����(R)]: ")
     (setvar "cmdecho" 0)
     (command "rotate" "l" "" p1 pause) ; "pause" string is use for autocad command STOP!
  
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
     (PRINC)
)

(defun C:cimBB () (m:pbox))
(princ)


;===========================================================================
;��ɾ� C:CIMBO () 3���� �̿��� �簢�� �׸���                              
;===========================================================================
(defun m:RECT (/ PT1 PT2 PT3 PT4 PT3X A1 A2 THETA LENX LEN ANGL  )
  (ai_err_on) 
  (ai_undo_on)
  (command "_.undo" "_group")
  
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n������ �̿��� �ڽ��� �׸��� ����Դϴ�.")
  
  
  ;(initget 1)
  (setq PT1 (getpoint "\n���� �ϴ� ��:  "))
  (while (/= pt1 nil)
	  (setq PT2 (getpoint PT1 "\n���α���:  "))
    		(if (null pt2) (exit))
	  (setq PT3X (getpoint PT2 "\n���α���:  "))
    		(if (null pt3x) (exit))
	  (setq A1 (angle PT1 PT2))
	  (setq A2 (angle PT2 PT3X))
	  (setq THETA (abs (+ (/ PI 2.0)
	    (- A1 A2))))
	  (setq LENX (distance PT2 PT3X))
	  (setq LEN (* (cos THETA) LENX))
	  (setq ANGL (+ (/ PI 2.0) A1))
	  (setq PT3 (polar PT2 ANGL LEN))
	  (setq PT4 (polar PT1 ANGL LEN))
	  
	  (setvar "osmode" 0)
	  
	  (command "PLINE" PT1 PT2 PT3 PT4 "C")
	  (setq PT1 (getpoint "\n���� �ϴ� ��: "))
  )
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (PRINC)
)

(defun C:CIMBO () (m:rect))

;=========================================================================
;��ɾ� C:cimV () ���� V ��ȣ�� �׸��� ���                               
;=========================================================================
(defun m:VV (/ p1 p2 p3 p4)
  (ai_err_on) 
  (ai_undo_on)
  (command "_.undo" "_group")
  
(princ "\nArchiFree 2002 for AutoCAD LT 2002.")
(princ "\n������ȣ�� �׸��� ����Դϴ�.")
  (setvar "blipmode" 1)
  (setvar "osmode" 33)
  ;(initget 1)
  (setq p1 (getpoint "\n���� ������ �������� �����Ͻʽÿ�. :    "))
  (while (/= p1 nil)
	  (setq p2 (getcorner p1 "�밢�� ������ �������� �����Ͻʽÿ�. : "))
    		(if (null p2) (exit))
	  (setvar "osmode" 0)
	  (setq p3 (list (car p1) (cadr p2)))
	  (setq p4 (list (/ (+ (car p1) (car p2)) 2) (cadr p1)))
	  
	  (command "linetype" "S" "dashdot" "")
	  (command "pline" p3 p4 p2 "")
	  
	  (setq p1 (getpoint "\n���� ������ �������� �����Ͻʽÿ�. :    "))
  )
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ)
)

(defun C:cimVV () (m:vv))
(princ)


;========================================================================
;��ɾ� C:cimKK () ������ȣ�� �׸��� ���                                 
;========================================================================
(defun m:KK (/ p1 p2 p3 p4 cel)
  (ai_err_on) 
  (ai_undo_on)
  (command "_.undo" "_group")
  
(princ "\nArchiFree 2002 for AutoCAD LT 2002.")
(princ "\n���� ��ȣ�� �׸��� ����Դϴ�.")
  (command "linetype" "S" "dashdot" "")
  (setvar "blipmode" 1)
  (setvar "osmode" 33)
  (initget 1)
  (setq p1 (getpoint "\n���� ������ �������� �����Ͻʽÿ�. :    "))
  (while (/= p1 nil)
	  (setq p2 (getcorner p1 "�밢�� ������ �������� �����Ͻʽÿ�.: "))
    		(if (null p2) (exit))
	  (setvar "osmode" 0)
	  (setq p3 (list (car p2) (cadr p1)))
	  (setq p4 (list (car p1) (/ (+ (cadr p1) (cadr p2)) 2)))
	  (command "pline" p3 p4 p2 "")
	  (setq p1 (getpoint "\n���� ������ �������� �����Ͻʽÿ�. :    "))
  )
  
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ)
)

(defun C:cimKK () (m:kk))
(princ)


;===================================================================
;��ɾ� :C:cimCEN () �߽ɼ� �׸��� (���̾� cen,color Yellow)        
;��������: 194 �ּ�ó��(�� ���κ��� ��������,������ ����)           
;===================================================================
(defun m:cen (/
            cen_snp  )

;;;  (setq 
;;;        cen_snp (getvar "snapmode")
;;;  )

  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")

;;;  (if (lacolor cen:lay)
;;;    (setq cen:col (lacolor cen:lay)
;;;          cen:lin (laltype cen:lay)
;;;    )
;;;    (command "_.layer" "_M" cen:lay
;;;                       "_C" cen:col cen:lay "_L" cen:lin cen:lay "")
;;;  )
;;;  (command "_.color" "_BYLAYER")
;;;  (command "_.LINETYPE" "_S" "_BYLAYER" "")
;;;  (setlay cen:lay)

  
 (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
 (princ "\n�߽ɼ��� �׸��� ����Դϴ�.")

;;;  (setvar "blipmode" 1)
;;;  (setvar "snapmode" 1)
  
  (setq cont T uctr 0 temp T)
  (set_col_lin_lay cen:cprop)
  (while cont
    (cen_m1)
    (cen_m2)
  )

;;;  (if cen_snp (setvar "snapmode" cen_snp))

  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  
  (princ)
)

(defun cen_m1 ()
  (setvar "osmode" 167)
  (while temp
    (if (> uctr 0)
      (progn
        (initget "/ Dialog Offset Undo")
        (setq strtpt (getpoint
              "\n>>> Dialog/Offset/Undo/<������>: "))
      )
      (progn
        (initget "/ Dialog Offset")
        (setq strtpt (getpoint
            "\n>>> Dialog/Offset/<������>: "))
      )
    )
    (cond
      ((= strtpt "Color")
        (cen_col)
      )
      ((= strtpt "Dialog")
        (dd_cen)
      )
      ((= strtpt "Offset")
        (cen_ofs)
      )  
      ((= strtpt "Undo")
        (command "_.undo" "_B")
        (setq uctr (1- uctr))
      )
      ((null strtpt)
        (setq cont nil temp nil tem nil) ; end
      )
      (T
        (setq temp nil tem T)
      )
    )
  )
)

(defun cen_m2 ()
  (while tem
    (initget "/ Dialog Undo")
    (setq nextpt (getpoint strtpt "\n>>> Dialog/Undo/<����>: "))
    (cond
      ((= nextpt "Color")
        (cen_col)
      )
      ((= nextpt "Dialog")
        (dd_cen)
      )
      ((null nextpt)
        (setq cont nil tem nil)
      )
      (T
        (command "_.Undo" "_M")
        (set_col_lin_lay cen:cprop)
        (if (and (/= dist nil) (/= dist 0)) 
          (setq strtpt (polar strtpt (angle strtpt2 nextpt2) dist)
                nextpt (polar nextpt (angle strtpt2 nextpt2) dist)
          )
        )
        (setvar "osmode" 0)
        (command "_.line" strtpt nextpt "")
        (setq uctr (1+ uctr))
        (setq tem nil temp T)
      )
    )
  )
)
(defun cen_ofs ()
  (setvar "osmode" 167)
  (initget 1)
  (setq strtpt2 (getpoint "\nOffset from: "))
  (initget 1)
  (setq nextpt2 (getpoint strtpt2 "\nOffset toward: "))
  (setq dist (getdist strtpt2 (strcat
    "\nEnter the offset distance <" (rtos (distance strtpt2 nextpt2)) ">: ")))
  (setq dist (if (or (= dist "") (null dist))
               (distance strtpt2 nextpt2)
               (if (< dist 0)
                 (* (distance strtpt2 nextpt2) (/ (abs dist) 100.0))
                 dist
               )
             )
  )
  (setq temp T)
  (setvar "osmode" 0)
)
(defun dd_cen (/ cancel_check dcl_id)
  
  (setq dcl_id (ai_dcl "setprop"))
  (if (not (new_dialog "set_prop_c_la_li" dcl_id)) (exit))
  (@get_eval_prop cen_prop_type cen:prop)
  
  (action_tile "b_name" "(@getlayer)")
  (action_tile "b_color" "(@getcolor)")
  (action_tile "color_image"  "(@getcolor)")
  (action_tile "b_line"       "(@getlin)")
  (action_tile "c_bylayer" "(@bylayer_do T)")
  (action_tile "t_bylayer" "(@bylayer_do nil)")
  (action_tile "cancel" "(setq cancel_check T)(done_dialog)")
  (start_dialog)
  (done_dialog)
  (if (= cancel_check nil)
	(PROP_SAVE cen:prop)
  )

)

(setq cen:cprop  (Prop_search "cen" "cen"))
(setq cen:prop '(cen:cprop))
(if (null cen_prop_type) (setq cen_prop_type "rd_cen"))

(defun C:cimCEN () (m:cen))
(princ)


;=================================================================
;                        void �׸���                              
;=================================================================
(defun m:XX (/ p1 p2 p3 p4 cel)
  (ai_err_on) 
  (ai_undo_on)
  (command "_.undo" "_group")
  (setq cel (getvar "CELTYPE"))
 (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
 (princ "\nVoid�� ǥ���ϴ� ����Դϴ�.")
  (command "linetype" "S" "dashdot" "")
  (setvar "osmode" 33)
  ;(initget 1)
  (setq p1 (getpoint "\nPick First Corner:    "))
  (while (/= p1 nil)
	  (setq p2 (getcorner p1 "Pick Other Corner: "))
    		(if (= p2 nil) (exit))
	  (setvar "osmode" 0)
	  (setq p3 (list (car p2) (cadr p1)))
	  (setq p4 (list (car p1) (cadr p2)))
	  
	  
	  (command "line" p1 p2 "")
	  (command "line" p3 p4 "")
	  (command "linetype" "S" cel "")
	  (setq p1 (getpoint "\nPick First Corner:    "))
  )
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ)
)

(defun C:cimXX () (m:xx))
(princ)



;========================================================================
;                   �ڽ��� void line�� �׸���                            
;========================================================================
(defun m:rectx (/ ECHO PT1 PT2 pt3 pt4 old_Ltype old_Color )

  (ai_err_on) 
  (ai_undo_on)
  (command "_.undo" "_group")
  
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n�簢���� Void Line�� �׸��� ����Դϴ�.")
  
  ;(initget 1)
  (setq PT1 (getpoint "\n���� �ϴ� ��:  "))
   (if (null pt1) (exit))
  (setq PT3 (getcorner PT1 "���� ��� ��:  "))
   (if (null pt3) (exit))
  (setq pt2 (list (car pt3) (cadr pt1) (caddr pt1))) 
  (setq pt4 (list (car pt1) (cadr pt3) (caddr pt1))) 

  (setvar "osmode" 0)
  (command "_PLINE" PT1 PT2 PT3 PT4 "C")
  
  (command "_.LINETYPE" "_S" "DASHDOT" "")
  (command "_line" pt2 pt4 "")
  (command "_line" pt1 pt3 "")
  
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
)

(defun c:cimbx()
  (m:rectx)
)


;========================================================================
;                           Color ����                                   
;========================================================================
;Change Color. Start command with CHCO.
(defun m:CHCO (/ a1 a2 n index b1 b2 d1 d2 b3)
  (ai_err_on) 
  (ai_undo_on)
  (command "_.undo" "_group")
  
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n��ü�� ���������ν� color���� �����ϴ� ����Դϴ�.")
  
  (princ "\nSelect objects to be changed...")
  (while (not a1)
    (setq a1 (ssget))
  )
  (princ "Point to object on target Color...")
  (while (not a2)
    (setq a2 (entsel))
  )
  (setq n (sslength a1))
  (setq index 0)
  (setq b2 (entget (car a2)))
  (setq l2 (assoc 8 b2))
  (setq d2 (assoc 62 b2))
  (if (not d2)
    (setq d2a (lacolor (cdr l2)))
  )
  (repeat n
    (setq b1 (entget (ssname a1 index)))
    (setq d1 (assoc 62 b1))
    (if (and d1 d2)
      (progn
        (setq b3 (subst d2 d1 b1))
        (entmod b3)
      )
      (if (not d2)
        (command "_.chprop" (ssname a1 index) "" "_C" d2a "")
        (command "_.chprop" (ssname a1 index) "" "_C" (cdr d2) "")
      )
    )
    (setq index (+ index 1))
  )
  
  (princ (strcat "\n\tColor: " (if d2 (color_name (cdr d2)) (color_name d2a))))
  
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ)
)
(defun C:CIMCHCO () (m:chco))

(princ)
;========================================================================
;                           Layer ����                                   
;========================================================================
; Change Layer. Start command with CIMCHLA.
(defun m:CHLA (/ a1 a2 n index b1 b2 d1 d2 b3)
  (ai_err_on) 
  (ai_undo_on)
  (command "_.undo" "_group")
  
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n�����ϰ����ϴ� layer�� ��ü�� ���������μ� layer�� �����ϴ� ����Դϴ�.")
  
  (princ "\n�����ϰ��� �ϴ� ��ü�� �����Ͻʽÿ�...")
  (while (= a1 nil)
  (setq a1 (ssget)))
  (princ "������ �������� ��ü�� �����Ͻʽÿ�...")
  (while (= a2 nil)
  (setq a2 (entsel)))
  (setq n (sslength a1))
  (setq index 0)
  (setq b2 (entget (car a2)))
  (setq d2 (assoc 8 b2))
  (repeat n
    (setq b1 (entget (ssname a1 index)))
    (setq d1 (assoc 8 b1))
    (setq b3 (subst d2 d1 b1))
    (entmod b3)
    (setq index (+ index 1))
  )
  (princ (strcat "\n\tLayer: " (cdr d2)))
  
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ)
)

(defun C:CIMCHLA () (m:chla))
(princ)


;========================================================================
;                     Layer (��ȭ����) ����                              
;========================================================================
; Change Layer used Dialog. Start command with CIMCHLD.
(defun c:cimCHLD(/ curlay num templist name sortlist laylist ent ent_list)
  (ai_err_on) 
  (ai_undo_on)
  (command "_.undo" "_group")
  
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n��ȭ���ڸ� ���� layer�� �����ϴ� ����Դϴ�.")
  
  (while (setq ent (entsel "\n������ ��ü�� �����Ͻÿ�: "))

    ; make layer_list
    (setq ent_list (entget (car ent)))
    (setq curlay (cdr (assoc 8 ent_list)))

    (setq sortlist nil)
    (setq templist (tblnext "LAYER" T))
    (while templist
      (setq name (cdr (assoc 2 templist)))
      (setq sortlist (cons name sortlist))
      (setq templist (tblnext "LAYER"))
    )
    (if (>= (getvar "maxsort") (length sortlist))
      (setq sortlist (acad_strlsort sortlist))
      (setq sortlist (reverse sortlist))
    )
    (setq laylist sortlist)

    ; ��ȭ���� ȣ��
    (setq num (load_dialog "layerlist"))
    (new_dialog "select_layer" num)
    (start_list "layer_list")
    (mapcar 'add_list laylist)
    (end_list)
    (set_tile "layer_edit" curlay)
    (action_tile "layer_list" "(set_layer)")
    (action_tile "accept" "(get_layer)(done_dialog)")
    (action_tile "cancel" "(setq curlay nil)")
    (start_dialog)
    (done_dialog)

    ; ������  ����
    (if curlay
      (progn
	(setlay curlay)
        (command "CHANGE" ent "" "P" "LA" curlay "")
      )
    )
  )
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ)
)
(defun get_layer(/ index)
    (setq curlay (get_tile "layer_edit"))
)
(defun set_layer(/ index)
  (setq index (get_tile "layer_list"))
  (setq curlay (nth (atoi index) laylist))
  (set_tile "layer_edit" curlay)
)
(princ)
