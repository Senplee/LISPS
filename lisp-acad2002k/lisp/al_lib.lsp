
(defun al_Ptree(ptn / cont     uctr     tem      tdx      e
        ptr_oco  ptr_ola  p1       ptrend   temp ptn)
 ;(setq ptn (getstring))

    (ai_err_on)
    (ai_undo_on)
    (command "_.undo" "_group")

(if (null ptr:tprop) (setq ptr:tprop  (Prop_search "ptr" "tree")))
(if (null ptr:prop) (setq ptr:prop '(ptr:tprop)))
(if (null ptr_prop_type) (setq ptr_prop_type "rd_tree"))

    (setq cont T temp T uctr 0)
    (while cont
        (ptr_m1 "R" "ptr_prop_type" "ptr:prop" nil)
        (ptr_m2 "cmqs")
    )
    (command "_.undo" "_en")
    (ai_err_off)
    (ai_undo_off)

    (princ)
)



(defun ptr_m1 (flag tprop_name tmp_prop nowlin / falg1 tmpcol tmplay tmplin cancel_check)

    (@get_eval_prop (eval (read tprop_name)) (eval (read tmp_prop)))

    (while temp
        (if (> uctr 0)
            (progn
                (initget "Dialog Undo")
                (setq p1 (getpoint "\nDialog/Undo/<Insertion Point>: "))
            )
            (progn
                (initget "Dialog")
                (setq p1 (getpoint "\nDialog/<Insertion Point>: "))
            )
        )

        (cond
                ((= p1 "Dialog")
             (if (/= nowlin nil)
               (progn
                  (setq dcl_id (ai_dcl "setprop"))
                  (if (not (new_dialog "set_prop_c_la_li" dcl_id)) (exit))
                  (@get_eval_prop (eval (read tprop_name))  (eval (read tmp_prop)))
                  
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
                    (PROP_SAVE (eval (read tmp_prop)))
                  )

               )
               (progn
                      (setq dcl_id (ai_dcl "setprop"))
                  (if (not (new_dialog "set_prop_c_la" dcl_id)) (exit))
                  (@get_eval_prop (eval (read tprop_name)) (eval (read tmp_prop)))
                  
                  (action_tile "b_name" "(@getlayer)")
                  (action_tile "b_color" "(@getcolor)")
                  (action_tile "color_image"  "(@getcolor)")
                  (action_tile "c_bylayer" "(@bylayer_do T)")
                  (action_tile "cancel" "(setq cancel_check T)(done_dialog)")
                  (start_dialog)
                  (done_dialog)
                  (if (= cancel_check nil)
                    (PROP_SAVE (eval (read tmp_prop)))
                  )
               )
             )
            )
            ((= p1 "Undo")
                (command "_.undo" "_B")
                (setq uctr (1- uctr))
            )
            (T
                (setq temp nil)
            )
        )
    )
        (set_col_lin_lay @eval_prop) ;; setting_ layer _ color _line type
    (if (and p1 (/= flag nil))
        (progn
          (setq flag1 (substr flag 1 1))
           (if (= flag1 "R")
              (progn
                (if (/= (type ptr_td) 'REAL)
                    (setq ptr_td 1000)
                  )
                  (setq tdx 
                      (getdist p1 
                        (strcat "\nEnter or Pick Radius/Size<" (rtos ptr_td) ">: ")
                      )
                   )
              (if (numberp tdx) (setq ptr_td tdx))
             )
            )
          (command "_.undo" "_m")
           (cond ((= flag1 "R") 
                (command "_.insert" ptn p1 ptr_td "" "")
              )
             ((= flag1 "A")
                  (command "_.insert" ptn p1)
                (princ "\nPick shape: ")
                (command pause)
                (princ "\nRotation Angle <0>: ")
                (command pause)
              )
             ((= flag1 "S")
                  (command "_.insert" ptn p1)
                (princ "\nPick shape: ")
                (command pause "")
             )
             ((= flag1 "F")
                  (command "_.insert" ptn p1 1 "" "")
              )
             ((= flag1 "Z")
                  (princ "\nEnter or Pick Rotation Angle <0>: ")
                (command "_.insert" ptn p1 1 "" pause)
              )
           )
            (setq tem T)
            (setq uctr (1+ uctr))
        )
        (setq cont nil)
    )
)

(defun ptr_m2 (FLAG )
    (while tem
      (cond ((= flag "cmmqr")
             (initget "Copy mIrror mOve Quit Rotate Undo  ")
            (setq ptrend (getkword "\n>>>Copy/mIrror/mOve/Rotate/Undo/<Quit>: "))
         )
        ((= flag "cmqs")
        (initget "Copy Move Quit Scale Undo  ")
        (setq ptrend (getkword "\n>>>Copy/Move/Scale/Undo/<Quit>: "))
         )
        ((= flag "cmmq")
         (initget "Copy mIrror mOve Quit Undo  ")
         (setq ptrend (getkword "\n>>>Copy/mIrror/mOve/Undo/<Quit>: "))
        )
        ((= flag "cmqrs")
         (initget "Copy Move Quit Rotate Scale Undo  ")
         (setq ptrend (getkword "\n>>>Copy/Move/Rotate/Scale/Undo/<Quit>: "))
        )
      )
        (setq e (entget (entlast)))
        (setq p1 (fld_st 10 e))
        (cond
            ((= ptrend "Copy")
                (princ "\n\tSecond point of displacement: ")
                (command "_.undo" "_m")
                (command "_.copy" "_L" "" p1 pause)
                (setq uctr (1+ uctr))
            )
            ((or (= ptrend "Move")(= ptrend "mOve"))
                (princ "\n\tSecond point of displacement: ")
                (command "_.undo" "_m")
                (command "_.move" "_L" "" p1 pause)
                (setq uctr (1+ uctr))
            )
            ((= ptrend "mIrror")
                (princ "\nFirst point of mirror line: ")
                (command "_.undo" "_m")
                (command "_.mirror" "_L" "")
                (setvar "cmdecho" 1)
                (command pause pause)
                (setvar "cmdecho" 0)
                (command pause)
                (setq uctr (1+ uctr))
                )
            ((= ptrend "Rotate")
                (command "_.undo" "_m")
                (setq e (subst (cons 50 0) (assoc 50 e) e))
                (entmod e)
                (princ "\n\t<Rotation angle>/Reference: ")
                (command "_.rotate" "_L" "" p1 pause)
                (setq uctr (1+ uctr))
                )
            ((= ptrend "Scale")
                (princ "\n\t<Scale factor>/Reference: ")
                (command "_.undo" "_m")
                (command "_.scale" "_L" "" p1 pause)
                (setq uctr (1+ uctr))
            )
            ((= ptrend "Undo")
                (command "_.undo" "_B")
                (setq uctr (1- uctr))
                (if (= uctr 0)
                    (setq tem nil temp T)
                )
            )
            (T
                (setq tem nil temp T)
            )
        )
    )
)


(defun al_Etree (iconetree / uctr tem e ptr_ola ptr_oco p1 ptrend temp cont ptn)
  (setq ptn iconetree)

(ai_err_on)
(ai_undo_on)

(command "_.undo" "_group")

(if (null ptr:tprop) (setq ptr:tprop  (Prop_search "ptr" "tree")))
(if (null ptr:prop) (setq ptr:prop '(ptr:tprop)))
(if (null ptr_prop_type) (setq ptr_prop_type "rd_tree"))

  
(setq cont T temp T uctr 0)
(while cont
(PTR_m1 "A" "ptr_prop_type" "ptr:prop" nil)
(ptr_m2 "cmqs")
)

(command "_.undo" "_en")
  (ai_err_off)
(ai_undo_off)

(princ)
)



(defun al_Toil (icontoil / uctr tem e fix_ola fix_oco p1 fixend temp cont ptn)
  (setq ptn icontoil)
(ai_err_on)
(ai_undo_on)
(command "_.undo" "_group")

(if (null fix:fprop) (setq fix:fprop  (Prop_search "fixu" "fixu")))
(if (null fix:prop) (setq fix:prop '(fix:fprop)))
(if (null fix_prop_type) (setq fix_prop_type "rd_fixu"))

(setq cont T temp T uctr 0)
(while cont
(ptr_m1 "F" "fix_prop_type" "fix:prop" nil)
(ptr_m2 "cmmq")
)

(command "_.undo" "_en")
(ai_err_off)
(ai_undo_off)
(princ)
)

(defun al_Toilz (icontoilz / uctr cont tem e fix_ola fix_oco p1 fixend temp ptn)
  (setq ptn icontoilz)
(ai_err_on)
(ai_undo_on)
(command "_.undo" "_group")

(if (null fix:fprop) (setq fix:fprop  (Prop_search "fixu" "fixu")))
(if (null fix:prop) (setq fix:prop '(fix:fprop)))
(if (null fix_prop_type) (setq fix_prop_type "rd_fixu"))


(setq cont T temp T uctr 0)
(while cont
(ptr_m1 "Z" "fix_prop_type" "fix:prop" nil)
(ptr_m2 "cmmqr")
)

(command "_.undo" "_en")
(ai_err_off)
(ai_undo_off)
(setvar "cmdecho" 1)
(princ)
)

;;==========================================================================================
;; (defun c:al_furn (/ uctr tem e furn_ola furn_oco furn_oli p1 furnend temp cont ptn)
;;==========================================================================================

(defun al_furn (iconfurn / uctr tem e furn_ola furn_oco furn_oli p1 furnend temp cont ptn)

    (setq ptn iconfurn)

    (princ ptn)

    (ai_err_on)
    (ai_undo_on)
    (command "_.undo" "_group")
 
    (if (null furn:fprop)       (setq furn:fprop      (Prop_search "furn" "furn")))
    (if (null furn:prop)        (setq furn:prop      '(furn:fprop)))
    (if (null furn_prop_type)   (setq furn_prop_type  "rd_furn"))

    (setq cont T temp T uctr 0)
    (while cont
        (ptr_m1 "ZL" "furn_prop_type" "furn:prop" T)
        (ptr_m2 "cmmqr")
    )

    (command "_.undo" "_en")
    (ai_err_off)
    (ai_undo_off)
    (princ)
)


(defun al_kitc (iconkitc / ptn)
    (setq ptn iconkitc)

    (ai_err_on)
    (ai_undo_on)  
    (if (>= (getvar "dimscale") 200)
        (setq ptn (strcat ptn "s"))
    )

    (if (null kic:kprop) (setq kic:kprop  (Prop_search "kic" "kict")))
    (if (null kic:prop) (setq kic:prop '(kic:kprop)))
    (if (null kic_prop_type) (setq kic_prop_type "rd_kict"))

    (setq cont T temp T uctr 0)
    (while cont
        (ptr_m1 "ZL" "kic_prop_type" "kic:prop" T)
        (ptr_m2 "cmmqr")
    )

    (command "_.undo" "_en")
    (ai_err_off)
    (ai_undo_off)
    (princ)
)



(defun al_matr ( iconmatr / uctr tem e mat_ola mat_oco p1 matend temp cont ptn)
  (setq ptn iconmatr)

(ai_err_on)
(ai_undo_on)
(command "_.undo" "_group")


(if (null mat:mprop) (setq mat:mprop  (Prop_search "mat" "mat")))
(if (null mat:prop) (setq mat:prop '(mat:mprop)))
(if (null mat_prop_type) (setq mat_prop_type "rd_mat"))

(setq cont T temp T uctr 0)
(while cont
(ptr_m1 "S" "mat_prop_type" "mat:prop" nil)
(ptr_m2 "cmmqr")
)

(command "_.undo" "_en")
(ai_err_off)
(ai_undo_off)

(princ)
)

(defun c:al_batha  (/ cont temp tem uctr strtpt sc bhtk p1 bh1_ola bh1_oco)

(ai_err_on)
(ai_undo_on)
(command "_.undo" "_group")

(if (null bh1:bprop) (setq bh1:bprop  (Prop_search "bh1" "bath")))
(if (null bh1:prop) (setq bh1:prop '(bh1:bprop)))
(if (null bh1_prop_type) (setq bh1_prop_type "rd_bath"))
  
(setq cont T temp T uctr 0)
(while cont
(bht_ma)
(ptr_m1 "Z" "bh1_prop_type" "bh1:prop" nil)
(ptr_m2 "cmmqr")
)

(command "_.undo" "_en")
(ai_err_off)
(ai_undo_off)

(princ)
)

(defun c:al_BATHB  (/ cont temp tem uctr strtpt sc bhtk p1 bh1_ola bh1_oco)

(ai_err_on)
(ai_undo_on)
(command "_.undo" "_group")

(if (null bh1:bprop) (setq bh1:bprop  (Prop_search "bh1" "bath")))
(if (null bh1:prop) (setq bh1:prop '(bh1:bprop)))
(if (null bh1_prop_type) (setq bh1_prop_type "rd_bath"))

(setq cont T temp T uctr 0)
(while cont
(bht_mb)
(ptr_m1 "Z" "bh1_prop_type" "bh1:prop" nil)
(ptr_m2 "cmmqr")
)

(command "_.undo" "_en")
 (ai_err_off)
(ai_undo_off)

(princ)
)

(defun al_BATHC  (iconbathc / cont temp tem uctr uctn strtpt sc p1 bh1_ola bh1_oco ptn)
(setq ptn iconbathc)
(ai_err_on)
(ai_undo_on)
(command "_.undo" "_group")

(if (null bh1:bprop) (setq bh1:bprop  (Prop_search "bh1" "bath")))
(if (null bh1:prop) (setq bh1:prop '(bh1:bprop)))
(if (null bh1_prop_type) (setq bh1_prop_type "rd_bath"))
  
(setq cont T temp T uctr 0 uctn 0)
(while cont
(bht_mc)
(ptr_m1 "Z" "bh1_prop_type" "bh1:prop" nil)
(ptr_m2 "cmmqr")
)

(command "_.undo" "_en")
  (ai_err_off)
(ai_undo_off)

(princ)
)

(defun bht_ma ()
(initget "A B C")
(if (and (/= bht_a "A") (/= bht_a "B") (/= bht_a "C"))
(setq bht_a "C")
)
(setq ptn (getkword (strcat
"\nLength of bathtub A(1,200)/B(1,300)/C(1,400)/<" bht_a ">: ")))
(if (member ptn '("A" "B" "C")) (setq bht_a ptn))
(cond
((= bht_a "A")
(setq ptn "18AK12")
)
((= bht_a "B")
(setq ptn "18AK13")
)
((= bht_a "C")
(setq ptn "18AK14")
)
)
(if (>= sc 100) (setq ptn (strcat ptn "S")))
)

(defun bht_mb ()
(initget "A B C")
(if (and (/= bht_b "A") (/= bht_b "B") (/= bht_b "C"))
(setq bht_b "C")
)
(setq ptn (getkword (strcat
"\nLength of bathtub A(1,500)/B(1,600)/C(1,700)/<" bht_b ">: ")))
(if (member ptn '("A" "B" "C")) (setq bht_b ptn))
(cond
((= bht_b "A")
(setq ptn "18BK15")
)
((= bht_b "B")
(setq ptn "18BK16")
)
((= bht_b "C")
(setq ptn "18BK17")
)
)
(if (>= sc 100) (setq ptn (strcat ptn "S")))
)

(defun bht_mc ()
(princ "\n     >>> This bathtub size is 1,500x700. <<<")
(if (and (>= sc 100) (= uctn 0))
(setq ptn (strcat ptn "S"))
)
(setq uctn (1+ uctn))
)


;;

(defun al_ETC (iconetc / uctr tem e vcl_ola vcl_oco vcl_oli p1 vclend temp cont ptn)
  (setq ptn iconetc)
(ai_err_on)
(ai_undo_on)
(command "_.undo" "_group")

(if (null vcl:lprop) (setq vcl:lprop  (Prop_search "vcl" "lib")))
(if (null vcl:prop) (setq vcl:prop '(vcl:lprop)))
(if (null vcl_prop_type) (setq vcl_prop_type "rd_lib"))

(setq cont T temp T uctr 0)
(while cont
(ptr_m1 "ZL" "vcl_prop_type" "vcl:prop" T)
(ptr_m2 "cmmqr")
)

(command "_.undo" "_en")
(ai_err_off)
(ai_undo_off)
(princ)
)



(defun al_CAR (iconcar / uctr tem e vic_ola vic_oco vic_oli p1 vicend temp cont ptn)
  (setq ptn iconcar)
(ai_err_on)
(ai_undo_on)
(command "_.undo" "_group")

(if (null vic:cprop) (setq vic:cprop  (Prop_search "vic" "car")))
(if (null vic:prop) (setq vic:prop '(vic:cprop)))
(if (null vic_prop_type) (setq vic_prop_type "rd_car"))
  
(setq cont T temp T uctr 0)
(while cont
(ptr_m1 "ZL" "vic_prop_type" "vic:prop" T)
(ptr_m2 "cmmqr")
)

(command "_.undo" "_en")
(ai_err_off)
(ai_undo_off)
(setvar "cmdecho" 1)
(princ)
)




;;(defun c:al_SMBL ( / cont uctr tem tdx e lib_oco lib_ola p1 libend temp ptn)
(defun al_SMBL (iconsmbl / cont uctr tem tdx e lib_oco lib_ola p1 libend temp ptn)
;;(setq ptn (getstring))
(setq ptn iconsmbl)

(ai_err_on)
(ai_undo_on)
(command "_undo" "_group")

(if (null lib:sprop) (setq lib:sprop  (Prop_search "lib" "sym")))
(if (null lib:prop) (setq lib:prop '(lib:sprop)))
(if (null lib_prop_type) (setq lib_prop_type "rd_sym"))
  
(setq temp T cont T uctr 0)
(while cont
(lib_m1)
(ptr_m2 "cmqrs")
)

(command "_undo" "_en")
  (ai_err_off)
(ai_undo_off)
(setvar "cmdecho" 1)
(princ)
)

(defun lib_m1 ()
(ptr_m1 nil "lib_prop_type" "lib:prop" nil)
(if p1
(progn
(if (/= (type lib_td) 'REAL)
(setq lib_td 1500)
)
(setq tdx (getdist p1 (strcat "\nEnter or Pick Radius/Size<" (rtos lib_td) ">: ")))
(if (numberp tdx) (setq lib_td tdx))
(princ "\nEnter or Pick Rotation Angle <0>: ")
(command "_undo" "_m")
(command "_insert" ptn p1 lib_td "" pause)
(setq uctr (1+ uctr))
(setq tem T)
)
(setq cont nil)
)
)


(defun al_HSMBL (iconhsmbl / cont uctr tem e ss tdx libend sc p1 temp lib_oco lib_ola pt_list ss_list ptn )
  (setq ptn iconhsmbl)

(SETQ SC (GETVAR "dimscale"))

(ai_err_on)
(ai_undo_on)
(command "_undo" "_group")

(if (null lib:sprop) (setq lib:sprop  (Prop_search "lib" "sym")))
(if (null lib:prop) (setq lib:prop '(lib:sprop)))
(if (null lib_prop_type) (setq lib_prop_type "rd_sym"))
  
(setq cont T uctr 0 temp T pt_list nil ss_list nil)
(while cont
(libn_m1)
(libn_m2)
)

 
(command "_undo" "_en")
   (ai_err_off)
(ai_undo_off)
(setvar "cmdecho" 1)
(princ)
)

(defun libn_m1 ()
(ptr_m1 nil "lib_prop_type" "lib:prop" nil)
(if p1
(progn
(if (/= (type libn_td) 'REAL)
(setq libn_td 1500)
)
(setq tdx (getdist p1 (strcat
    "\nEnter or Pick Radius/Size<" (rtos libn_td) ">: ")))
(if (numberp tdx) (setq libn_td tdx))
(command "_undo" "_m")
(command "_insert" ptn p1 libn_td "" pause)
(command "_chprop" "_L" "" "_LA" lib:lay "")  ;; 레이어 변경
(setq ss (ssadd))
(ssadd (entlast) ss)
(command "_hatch" "line" (* SC 0.2) 0 "_L" "")
(ssadd (entlast) ss)
(setq e (entlast))
(princ "\n\t<Rotation angle>/Reference: ")
(command "_rotate" ss "" p1 pause)
(setq uctr (1+ uctr))
(setq tem T)
(setq pt_list (cons p1 pt_list)
ss_list (cons ss ss_list)
)
)
(setq cont nil)
)
)

(defun libn_m2 ()
(while tem
(initget "Copy Move Quit Rotate Scale Undo  ")
(setq libend (getkword "\n>>>Copy/Move/Rotate/Scale/Undo/<Quit>: "))
(cond
((= libend "Copy")
(princ "\n\tSecond point of displacement: ")
(setq p1 (nth 0 pt_list)
  ss (nth 0 ss_list)
)
(command "_undo" "_m")
(command "_copy" ss "" p1 pause)
(setq ss (ssadd))
(ssadd (entnext e) ss)
(ssadd (entlast) ss)
(setq e (entlast))
(setq uctr (1+ uctr))
(setq pt_list (cons (getvar "lastpoint") pt_list)
  ss_list (cons ss ss_list)
) 
)
((= libend "Move")
(princ "\n\tSecond point of displacement: ")
(setq p1 (nth 0 pt_list)
  ss (nth 0 ss_list)
)
(command "_undo" "_m")
(command "_move" ss "" p1 pause)
(setq uctr (1+ uctr))
(setq pt_list (cons (getvar "lastpoint") pt_list)
  ss_list (cons ss ss_list)
)
)
((= libend "Rotate")
(setq p1 (nth 0 pt_list)
  ss (nth 0 ss_list)
)
(command "_undo" "_m")
(command "_erase" ss "")
(command "_insert" LB p1 libn_td 0)
(command "_chprop" "_L" "" "_LA" lib:lay "")
(setq ss (ssadd))
(ssadd (entlast) ss)
(command "_hatch" "line" (* SC 0.25) 0 "_L" "")
(ssadd (entlast) ss)
(setq e (entlast))
(princ "\n\t<Rotation angle>/Reference: ")
(command "_rotate" ss "" p1 pause)
(setq uctr (1+ uctr))
(setq pt_list (cons (getvar "lastpoint") pt_list)
  ss_list (cons ss ss_list)
)
)
((= libend "Scale")
(princ "\n\t<Scale factor>/Reference: ")
(setq p1 (nth 0 pt_list)
  ss (nth 0 ss_list)
)
(command "_undo" "_m")
(command "_scale" ss "" p1 pause)
(setq uctr (1+ uctr))
(setq pt_list (cons (getvar "lastpoint") pt_list)
  ss_list (cons ss ss_list)
)
)
((= libend "Undo")
(command "_undo" "_b")
(setq uctr (1- uctr))
(if (= uctr 0)
(setq tem nil temp T)
(setq pt_list (cdr pt_list)
    ss_list (cdr ss_list)
)
)
)
(T
(setq tem nil cont nil)
)
)
)
)

;;(defun c:al_SMBL2 (iconsmbl2 / uctr tem e lib_ola lib_oco p1 libend temp cont ptn)
(defun al_SMBL2 (iconsmbl2 / uctr tem e lib_ola lib_oco p1 libend temp cont ptn)
  (setq ptn iconsmbl2)

(ai_err_on)
(ai_undo_on)
(command "_undo" "_group")

(if (null lib:sprop) (setq lib:sprop  (Prop_search "lib" "sym")))
(if (null lib:prop) (setq lib:prop '(lib:sprop)))
(if (null lib_prop_type) (setq lib_prop_type "rd_sym"))
  
(setq cont T temp T uctr 0)
(while cont
(ptr_m1 "A" "lib_prop_type" "lib:prop" nil)
(ptr_m2 "cimqr")
)
(command "_undo" "_en")

(ai_err_off)
(ai_undo_off)
(setvar "cmdecho" 1)
(princ)
)



(defun al_LIB (iconlib / symstyle  ptn  tlay tcol ptn ttt)

    (setq symstyle iconlib)

    (setq symlist (split symstyle " ")
          tcol    (nth 0 symlist)
          tlay    (nth 2 symlist)
          ptn     (nth 1 symlist))
  
    (ai_err_on)
    (ai_undo_on)
    (command "_.undo" "_group")
  
    (if (setq ttt (lacolor tlay)) (setq tcol (itoa ttt)))

    (setq allib:sprop (append '("allib" "library") (list (strcase tlay) tcol "CONTINUOUS" "1" "1" tcol "CONTINUOUS")))
    (prop_layer_setting allib:sprop)

    (setq allib:prop '(allib:sprop))
    (setq allib_prop_type "rd_library")

    (setq cont T temp T uctr 0)
    (while cont
        (PTR_m1 "Z" "allib_prop_type" "allib:prop" nil)
        (ptr_m2 "cmmqr")
    )

    (command "_.undo" "_en")
    (ai_err_off)
    (ai_undo_off)
    (princ)
)

;;=============================================================================

;;(princ "\n\t al_lib Loading Completed...\n")
(princ)

