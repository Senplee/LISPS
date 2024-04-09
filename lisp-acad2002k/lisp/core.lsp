;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; core.lsp =      cim.lstp + cimcad98.lsp
;;         
;;         기존 cimcad98 의 3부분을 모은것임 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;        


;;=============================================================================
;;    Function Name     : read_ini_section_item (ini_name section_name item_name)
;;
;;    Function         : read info from *.ini file 혹은 *.* Text File
;;    
;;    In                : ini_name             읽을 정보를 가지고 있는 파일 이름
;;                    : section_name         section name [xxxxx]
;;                    : item_name            section name 에 포함된 Item Name
;;
;;    Out                : item_contents        item_name이 포함하고 이쓴 내용
;;                                        item_name=xxxxxxx        
;;=============================================================================


(defun read_ini_section_item (ini_name section_name item_name)

    (setq env (strcat (getenv "windir") (chr 92)))     ;; chr 92 ("\") 
    (setq env (strcat env ini_name))
    (setq file_desc (open env "r"))        ; file open(error 혹은 없는경우 null로 온다
    
    (if file_desc
        (progn
            (setq bb (read-line file_desc))
            (while (= (substr bb 1 1) "\073") (setq bb (read-line file_desc)))    ;;; 073  : ";"의 8진법 Value,comment 통과
            
            (setq true02 T)    ; 위에서 한 Line을 읽은상태이다.
            
            (while true02
                (setq true03 (= (substr bb 1 1) "["))
                (if true03
                    (progn    ; then
                        (setq true05 T)
                        (while true05                
                            (setq true04 (= (substr bb 2 (strlen section_name)) section_name))    ;; 소문자 대문자 구분 하지 않는다.
                            (if true04
                                (progn    ;then
                                    (setq bb (read-line file_desc))        ; next line    
                                    (setq true06 T)
                                    (while true06        ; find item_name
                                        (setq true07 (= (substr bb 1 (strlen item_name)) item_name))
                                        (if true07
                                            (progn    ;then item_name 까지 찿은경우
                                                (setq item_contents (substr bb (+ (strlen item_name) 2)))  
                                                
                                                (setq true06 nil)
                                                (setq true05 nil)
                                                (setq true02 nil)
                                            )
                                            (progn    ;else, item_name을 찿지 못한경우    
                                                (setq bb (read-line file_desc))        ; next line    
                                            )
                                        )    
                                    )
                                )
                                (progn    ;else    section_name이 같지 않은경우
                                    (setq bb (read-line file_desc))        ; next line    
                                    (setq true05 nil)
                                )
                            )
                        )    
                    )
                    (progn    ;else
                    
                        (setq bb (read-line file_desc))        ; next line    
                        (setq true02 T)    
                    )
                )
                (if (= bb nil)    (setq true02 nil))        ; the end of file
            )
          (close file_desc)
        )    
        (progn
            (setq item_contents nil)                      ; NULL Value
            (princ "\n파일을 찾을 수 없읍니다....")
        )
    )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Error Processing
;;         
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;        

(defun ai_err_on ()
  
  (setq err:color (getvar "cecolor")
      err:layer (getvar "clayer")
       err:lin (getvar "celtype")
       err:style (getvar "textstyle")
       err:osmode (getvar "osmode")
       err:blipmode (getvar "blipmode")
       err:highlight (getvar "highlight")
    ;err:ortho (getvar "orthomode")
    
  )
  (setvar "cmdecho" 0)
  (setvar "regenmode" 0)
  (setvar "blipmode" 0)
  
(defun *error* (s)
   (if (and (/= s "Function cancelled") (/= s "quit / exit abort"))
     (princ (strcat "\nError: " s))
   )
   (setvar "cmdecho" 0)
   (setvar "regenmode" 1)
   (setvar "cecolor" err:color)
   (setvar "clayer" err:layer)
   (setvar "celtype" err:lin)
   (setvar "textstyle" err:style)
   (setvar "osmode" err:osmode)
   (setvar "blipmode" err:blipmode)
   (setvar "highlight" err:highlight)
   ;(setvar "orthomode" err:ortho)
   
   (princ)
 )
)

(defun ai_err_off ()
   (setvar "cmdecho" 1)
   (setvar "regenmode" 1)
   (setvar "cecolor" err:color)
   (setvar "clayer" err:layer)
   (setvar "celtype" err:lin)
   (setvar "textstyle" err:style)
   (setvar "osmode" err:osmode)
   (setvar "blipmode" err:blipmode)
   (setvar "highlight" err:highlight)
   ;(setvar "orthomode" err:ortho)
   
   (princ)
)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cim.lsp + cimcad98.lsp
;;         
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;        


;;; Globar Variable 목록

(setq g_searchpath1 "")        ; search path 로 사용된다.
(setq g_searchpath2 "")        
(setq g_searchpath3 "")        


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 아래 부분은 CIM.LSP을 가져온것이다.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun ai_abort (app msg)
    (defun *error* (s)
        (if old_error (setq *error* old_error))
        (princ)
    )
    (if msg
       (alert (strcat " 응용프로그램 애러 " app " \n\n  " msg "  \n"))
    )
    (exit)
)


;;; Main function : 현재 사용하지 않기 때문에 그냥 Return한다. 

(defun cad_lock ()
    (princ)
)

(defun instr (smm cmm / imm lmm c_m)
    (setq imm 1 lmm (strlen smm) c_m (strlen cmm))
      (while (and (<= imm lmm)(/= (substr smm imm c_m) cmm)) (setq imm (1+ imm)))
      (if (> imm lmm) nil imm)
)




(defun @ffile (@wkf @ext / @wk)
    
    ;(setq @pathlsp (strcat (getenv "ACADLISP") (chr 92))) ;; chr 92 ("\") 
    
    
      ;(if (null (setq @wk (findfile (strcat @pathlsp @wkf @ext))))
    ;     (if (null (setq @wk (findfile (strcat @wkf @ext))))
    ;        (setq @wk (findfile (strcat @wkf @ext)))
    ;     )
      ;)
      
    ;(setq @wk (findfile (strcat @wkf @ext)))
      
      (setq @wk "d:\\ArchiFree 2000\\lisp\\core.set")            ; 일단 이것으로 한다.(지정 Dir)
      @wk
)


(defun @open (/ @wk @wkk)

      (if (setq @wk (@ffile "core" ".set"))
          (progn
              (setq a_a (open @wk "r"))        ; file open
          )
          (progn
              (princ @wk)
            (alert     (strcat "File ArchiFree.set not found in the following path(s)\n\t" 
                           (getvar "dwgprefix") "\073 "
                           (if (setq @wkk (getenv "acad"))
                              @wkk
                              "set ACAD=path1,path2 가 없읍니다."
                           )
                      )
             )
          )

      )
      (princ)
)

(defun opencoreset (/ wk path1)

    (setq path1 (strcat g_searchpath1 (chr 92) "core.set"))

      (if (setq wk (findfile path1))
        (setq a_a (open wk "r"))        ; file open
        (alert     (strcat "File core.set not found in the following path(s)\n\t" g_searchpath1))
      )
      (princ)
)


(defun ci_blank (text / nkx stn)
  (setq nkx  (instr text " ")
        stn  (strlen text)
  )
  (while (/= nkx nil)
    (if (= nkx 1)
      (setq text (substr text 2 (1- stn)))
      (setq text (substr text 1 (1- nkx)))
    )
    (setq nkx (instr text " ")
          stn (strlen text)
    )
  )

  text

)



(defun setup (/ a_a bb sn)

    ;; 여기서는 설치 dir 정보를 읽어들여 g_searchpath1,g_searchpath2,g_searchpath3 에 저장한 다음 사용한다.

    (read_ini_section_item "ArchiFree2002.ini" "SearchPath" "1")        ;; 소문자 대문자 구분 하지 않는다.    
    (setq g_searchpath1 item_contents)
    (read_ini_section_item "ArchiFree2002.ini" "SearchPath" "2")        ;; 소문자 대문자 구분 하지 않는다.    
    (setq g_searchpath2 item_contents)
      (read_ini_section_item "ArchiFree2002.ini" "SearchPath" "3")        ;; 소문자 대문자 구분 하지 않는다.    
    (setq g_searchpath3 item_contents)
    ;;(princ g_searchpath1)

    ;; 여기서는 기본적인 core.set(설치 dir에서) 를 읽어들려 초기화 한다.
    
    (opencoreset)    
    
    
    (setq bb (read-line a_a))
    (while (= (substr bb 1 1) "\073") (setq bb (read-line a_a)))    ;;; 073  : ";"의 8진법 Value
    
    (if (= (substr bb 1 2) "ON")
        (setq ci_f_inf "ON")
        (setq ci_f_inf nil)
    )
    
    (setq bb (read-line a_a))
    (while (= (substr bb 1 1) "\073") (setq bb (read-line a_a)))
    (setq co_2 (strcase (substr bb 12 9)))
    (if (setq sn (instr co_2 " "))
        (setq co_2 (substr co_2 1 (1- sn)))
    )
    
    (setq bb (read-line a_a))
    (setq co_3 (strcase (substr bb 12 9)))
    (if (setq sn (instr co_3 " "))
        (setq co_3 (substr co_3 1 (1- sn)))
    )
    
    (setq bb (read-line a_a))
    (setq co_5 (strcase (substr bb 12 9)))
    (if (setq sn (instr co_5 " "))
        (setq co_5 (substr co_5 1 (1- sn)))
    )
    
    
    (setq bb (read-line a_a))
    (while (= (substr bb 1 1) "\073") (setq bb (read-line a_a)))
    (setq co_i (strcase (substr bb 12 9)))
    (if (setq sn (instr co_i " "))
        (setq co_i (substr co_i 1 (1- sn)))
    )
    (setq li_i (strcase (substr bb 22 12)))
    (if (setq sn (instr li_i " "))
        (setq li_i (substr li_i 1 (1- sn)))
    )
    
    (setq bb (read-line a_a))
    (while (= (substr bb 1 1) "\073") (setq bb (read-line a_a)))
    (setq co_0 (strcase (substr bb 12 9)))
    (if (setq sn (instr co_0 " "))
        (setq co_0 (substr co_0 1 (1- sn)))
    )
    (setq li_0 (strcase (substr bb 22 12)))
    (if (setq sn (instr li_0 " "))
        (setq li_0 (substr li_0 1 (1- sn)))
    )
    
    (setq bb (read-line a_a))
    (setq co_cen (strcase (substr bb 12 9)))
    (if (setq sn (instr co_cen " "))
        (setq co_cen (substr co_cen 1 (1- sn)))
    )
    (setq li_cen (strcase (substr bb 22 12)))
    (if (setq sn (instr li_cen " "))
        (setq li_cen (substr li_cen 1 (1- sn)))
    )
    (setq bb (read-line a_a))
    (setq co_col (strcase (substr bb 12 9)))
    (if (setq sn (instr co_col " "))
        (setq co_col (substr co_col 1 (1- sn)))
    )
    (setq li_col (strcase (substr bb 22 12)))
    (if (setq sn (instr li_col " "))
        (setq li_col (substr li_col 1 (1- sn)))
    )
    (setq bb (read-line a_a))
    (setq co_doo (strcase (substr bb 12 9)))
    (if (setq sn (instr co_doo " "))
        (setq co_doo (substr co_doo 1 (1- sn)))
    )
    (setq li_doo (strcase (substr bb 22 12)))
    (if (setq sn (instr li_doo " "))
        (setq li_doo (substr li_doo 1 (1- sn)))
    )
    
    (setq bb (read-line a_a))
    (setq co_hat (strcase (substr bb 12 9)))
    (if (setq sn (instr co_hat " "))
        (setq co_hat (substr co_hat 1 (1- sn)))
    )
    
    (setq li_hat (strcase (substr bb 22 12)))
    (if (setq sn (instr li_hat " "))
        (setq li_hat (substr li_hat 1 (1- sn)))
    )
    
    (setq bb (read-line a_a))
    (setq co_til (strcase (substr bb 12 9)))
    (if (setq sn (instr co_til " "))
        (setq co_til (substr co_til 1 (1- sn)))
    )
    (setq li_til (strcase (substr bb 22 12)))
    (if (setq sn (instr li_til " "))
        (setq li_til (substr li_til 1 (1- sn)))
    )
    
    (setq bb (read-line a_a))
    (setq co_tre (strcase (substr bb 12 9)))
    (if (setq sn (instr co_tre " "))
        (setq co_tre (substr co_tre 1 (1- sn)))
    )
    
    (setq bb (read-line a_a))
    (setq co_wal (strcase (substr bb 12 9)))
    (if (setq sn (instr co_wal " "))
        (setq co_wal (substr co_wal 1 (1- sn)))
    )
    
    (setq li_wal (strcase (substr bb 22 12)))
    (if (setq sn (instr li_wal " "))
        (setq li_wal (substr li_wal 1 (1- sn)))
    )
    
    (setq bb (read-line a_a))
    (setq co_win (strcase (substr bb 12 9)))
    (if (setq sn (instr co_win " "))
        (setq co_win (substr co_win 1 (1- sn)))
    )
    
    (setq li_win (strcase (substr bb 22 12)))
    (if (setq sn (instr li_win " "))
        (setq li_win (substr li_win 1 (1- sn)))
    )
    
    (setq bb (read-line a_a))
    (while (= (substr bb 1 1) "\073") (setq bb (read-line a_a)))
    (setq door_gap (atof (substr bb 1)))
    
    (setq bb (read-line a_a))
    (while (= (substr bb 1 1) "\073") (setq bb (read-line a_a)))
    (setq window_gap (atof (substr bb 1)))
    (close a_a)
    (princ)
    

)


(princ "\n\t ArchiFree 2002 for AutoCAD LT 2002.")
(princ "\n\t Loading...")

;;
;;

(setq version "2002")

(defun ci_ss (pt / p1 p2 p3 p4 dis pic vie)
  (setq pic (getvar "pickbox")
        vie (getvar "viewsize")
  )
  (setq dis (* 0.00142857 pic vie))
  (setq p1  (polar pt (dtr 45)  (* dis (sqrt 2.0)))
        p2  (polar pt (dtr 135) (* dis (sqrt 2.0)))
        p3  (polar pt (dtr 225) (* dis (sqrt 2.0)))
        p4  (polar pt (dtr 315) (* dis (sqrt 2.0)))
  )
  
  (ssget "CP" (list p1 p2 p3 p4))
  
)

(defun cim_inf (/ nkx stn)
  (setq cim_dir (getvar "dwgprefix")
        cim_dir (substr cim_dir 1 (1- (strlen cim_dir)))
        cim_dir (strcat "DIRECTORY: " cim_dir)
  )
  (setq cim_fln (getvar "dwgname"))
  (setq nkx  (instr cim_fln (chr 92))
        stn  (strlen cim_fln)
  )
  (while (/= nkx nil)
    (setq cim_fln (substr cim_fln (1+ nkx)))
    (setq nkx (instr cim_fln (chr 92))
          stn (strlen cim_fln)
    )
  )
  (setq cim_fln (strcat "FILE NAME: " cim_fln))
  (setq cim_scl (rtos (getvar "ltscale") 2 0)
        cim_scl (strcat "DWG.SCALE: 1/" cim_scl)
  )
)

(defun file_init (/ f_l f_f)
      (setq f_l (tblsearch "layer" "FILE"))
      (if (= f_l nil)
        (progn
              (SetQ OLDLAY (GetVar "CLAYER"))
              (Command "_.LAYER" "_M" "FILE" "_S" OLDLAY "")
        )
      )
)

(princ ".")

(defun cim_file (/ ss p1 p2 p3 p4 k cim_sty cim_col dmm f1 f2 smx)
  (setvar "cmdecho" 0)
  (cim_inf)
  (cim_udt)
  (setq ss (ssget "X" '((0 . "TEXT") (8 . "FILE"))))
  (if (= ss nil)
    (progn
      (setq p1 (list (- (car (getvar "limmax")) (* (getvar "ltscale") 50))
                 (- (cadr (getvar "limmax")) (* (getvar "ltscale") 8)))
      )
      (setq p2 (polar p1 (dtr 270) (* (getvar "ltscale") 4)))
      (setq p3 (polar p2 (dtr 270) (* (getvar "ltscale") 4)))
      (setq p4 (polar p3 (dtr 270) (* (getvar "ltscale") 4)))
      (setq cim_sty (getvar "textstyle"))
      (setq cim_col (getvar "cecolor"))
      (setvar "blipmode" 0)
      (SETLAY "FILE")
      (setvar "textstyle" "sim")
      (command "color" co_i)
      (command "_.text" p1 (* (getvar "ltscale") 2) 0 cim_dir)
      (command "_.text" p2 (* (getvar "ltscale") 2) 0 cim_fln)
      (command "_.text" p3 (* (getvar "ltscale") 2) 0 cim_dat)
      (command "_.text" p4 (* (getvar "ltscale") 2) 0 cim_scl)
      (command "_.color" cim_col)
      (setvar "textstyle" cim_sty)
      (RTNLAY)
    )
  )
  (setq k 0)
  (if ss
    (repeat (sslength ss)
      (setq dmm (entget (ssname ss k)) f1 (assoc '1 dmm) smx (cdr f1))
      (cond
        ((= (substr smx 1 9) "DATE/TIME")
          (setq f2 (subst (cons 1 cim_dat) f1 dmm))
          (entmod f2)
        )
        ((= (substr smx 1 9) "FILE NAME")
          (setq f2 (subst (cons 1 cim_fln) f1 dmm))
          (entmod f2)
        )
      )
      (setq k (1+ k))
    )
  )
  (princ)
)

(defun cim_init (/ ss p1 p2 p3 p4 k cim_sty cim_col dmm f1 f2 smx)
  (setvar "cmdecho" 0)
  (cim_inf)
  (ai_udt)
  (setq ss (ssget "X" '((0 . "TEXT") (8 . "FILE"))))
  (if (= ss nil)
    (progn
      (setq p1 (list (- (car (getvar "limmax")) (* (getvar "ltscale") 50))
                 (- (cadr (getvar "limmax")) (* (getvar "ltscale") 8)))
      )
      (setq p2 (polar p1 (dtr 270) (* (getvar "ltscale") 4)))
      (setq p3 (polar p2 (dtr 270) (* (getvar "ltscale") 4)))
      (setq p4 (polar p3 (dtr 270) (* (getvar "ltscale") 4)))
      (setq cim_sty (getvar "textstyle"))
      (setq cim_col (getvar "cecolor"))
      (setvar "blipmode" 0)
      (SETLAY "FILE")
      (setvar "textstyle" "sim")
      (command "_.color" co_i)
      (command "_.text" p1 (* (getvar "ltscale") 2) 0 cim_dir)
      (command "_.text" p2 (* (getvar "ltscale") 2) 0 cim_fln)
      (command "_.text" p3 (* (getvar "ltscale") 2) 0 cim_dat)
      (command "_.text" p4 (* (getvar "ltscale") 2) 0 cim_scl)
      (command "_.color" cim_col)
      (setvar "textstyle" cim_sty)
      (RTNLAY)
    )
  )
  (setq k 0)
  (if ss
    (repeat (sslength ss)
      (setq dmm (entget (ssname ss k)) f1 (assoc '1 dmm) smx (cdr f1))
      (cond
        ((= (substr smx 1 9) "DIRECTORY")
          (setq f2 (subst (cons 1 cim_dir) f1 dmm))
          (entmod f2)
        )
        ((= (substr smx 1 9) "FILE NAME")
          (setq f2 (subst (cons 1 cim_fln) f1 dmm))
          (entmod f2)
        )
      )
      (setq k (1+ k))
    )
  )
  (princ)
)

(princ ".")

(defun ai_udt (/ td time j y d m hh mm time)
  (setq td (getvar "tdupdate"))
  (setq time (* 86400.0 (- td (setq j (fix td)))))
  (setq j (- j 1721119.0))
  (setq y (fix (/ (1- (* 4 j)) 146097.0)))
  (setq j (- (* j 4.0) 1.0 (* 146097.0 y)))
  (setq d (fix (/ j 4.0)))
  (setq j (fix (/ (+ (* 4.0 d) 3.0) 1461.0)))
  (setq d (- (+ (* 4.0 d) 3.0) (* 1461.0 j)))
  (setq d (fix (/ (+ d 4.0) 4.0)))
  (setq m (fix (/ (- (* 5.0 d) 3) 153.0)))
  (setq d (- (* 5.0 d) 3.0 (* 153.0 m)))
  (setq d (fix (/ (+ d 5.0) 5.0)))
  (setq y (+ (* 100.0 y) j))
  (if (< m 10.0)
    (setq m (+ m 3))
    (progn    
      (setq m (- m 9))
      (setq y (1+ y))
    )
  )

; Determine the clock time from the fraction of the day

  (setq hh (fix (/ time 3600.0)))
  (setq time (- time (* hh 3600.00)))
  (setq mm (fix (/ time 60.0)))
  (if (< (fix m) 10)
    (setq m (strcat "0" (itoa (fix m))))
    (setq m (itoa (fix m)))
  )
  (if (< (fix d) 10)
    (setq d (strcat "0" (itoa (fix d))))
    (setq d (itoa (fix d)))
  )
  (if (< hh 10)
    (setq hh (strcat "0" (itoa hh)))
    (setq hh (itoa hh))
  )
  (if (< mm 10)
    (setq mm (strcat "0" (itoa mm)))
    (setq mm (itoa mm))
  )
  (setq y (substr (itoa (fix y)) 3))
  (setq cim_dat (strcat "DATE/TIME: " y "." m "." d "/" hh ":" mm))
)

(princ ".")

(defun cim_udt (/ d_d)
  (setq d_d (rtos (getvar "cdate") 2 4))
  (setq cim_dat (strcat "DATE/TIME: " (substr d_d 3 2) "." (substr d_d 5 2) "." (substr d_d 7 2) "/" (substr d_d 10 2) ":" (substr d_d 12 2)))
)

(defun what_pos (item the_list / pos)
  (setq pos (- (length the_list)
               (length (member item the_list)))
  )
)
  
(defun do_blank (image col)
      (start_image image)
      (fill_image
        0 0
        (- (dimx_tile image) 1)
        (- (dimy_tile image) 1)
        col
      )
      (end_image)
)

(princ ".")


(defun cim_save (/ temp sname)
  (setq sname (getvar "dwgname"))
  (if (/= (setq temp (strcase (getstring (strcat "File name <" sname ">: "))))  "")
    (setq sname temp)
  )
  (setvar "cmdecho" 0)
  (if (= sname (getvar "dwgname"))
    (progn
      (if (= ci_f_inf "ON")
        (cim_file)
      )
      (setvar "cmdecho" 0)
      (command ".save" sname)
    )
    (command ".save" sname)
  )
  (setvar "cmdecho" 1)
  (princ)
)

(defun cim_qsave ()
  (if (= ci_f_inf "ON")
    (cim_file)
  )
  (setvar "cmdecho" 0)
  (command ".qsave")
  (setvar "cmdecho" 1)
  (princ)
)

(defun cim_end ()
  (if (= ci_f_inf "ON")
    (cim_file)
  )
  (setvar "cmdecho" 0)
  (command ".end")
  (setvar "cmdecho" 1)
  (princ)
)

;;(command "_.undefine" "save")
;;(defun C:SAVE () (cim_save))

;;(command "_.undefine" "qsave")
;;(defun C:QSAVE () (cim_qsave))

;;(command "_.undefine" "end")
;;(defun C:END () (cim_end))

(defun cim_ofs ()
  ;(menucmd "s=osnapb")
  (setvar "osmode" 33)
  (initget 1)
  (setq strtpt (getpoint "\nOffset from: "))
  ;(wang)
  (initget 1)
  (setvar "osmode" (+ 512 33))
  (setq nextpt (getpoint strtpt "\nOffset toward: "))
  (setq dist (getdist strtpt (strcat
    "\nEnter the offset distance <" (rtos (distance strtpt nextpt)) ">: ")))
  (setq dist (if (or (= dist "") (null dist))
               (distance strtpt nextpt)
               (if (< dist 0)
                 (* (distance strtpt nextpt) (/ (abs dist) 100.0))
                 dist
               )
             )
  )
  (setq strtpt (polar strtpt
                      (angle strtpt nextpt)
                      dist
               )
  )
  (menucmd "s= ")
  (setq temp nil tem T)
)

(defun fld_st (num lst)
  (cdr (assoc num lst))
)

(defun lacolor (laname / x)
  (setq x (tblsearch "layer" laname))
  (if x
    (abs (fld_st 62 x))
  )
)

(defun laltype (laname / x)
  (setq x (tblsearch "layer" laname))
  (if x
    (fld_st 6 x)
  )
)

(defun stysearch (stname / x)
  (setq x (tblsearch "style" stname))
  (if x
    (fld_st 2 x)
  )
)
(defun dimsearch (dimstname / x)
  (setq x (tblsearch "dimstyle" dimstname))
  (if x
    (fld_st 2 x)
  )
)
(defun blksearch (blname / x)
  (setq x (tblsearch "block" blname))
  (if x
    (fld_st 2 x)
  )
)

(defun blklayer (blname / x)
  (setq x (ssget "X" (list (cons 0  "INSERT") (cons 2  blname))))
  (if x
    (fld_st 8 (entget (ssname x 0)))
  )
)

  (princ ".")

(defun styleset (style_n /)
  (setq style_n (strcase style_n))
  (cond
    ((= style_n "SIM")
      (_sstya "SIM" "romans")
    )
    ((or (= style_n "CIHS") (= style_n "CIHSC") (= style_n "CIHSW"))
      (_sstya style_n "romans,whgtxt")
    )
    ((or (= style_n "CIHD") (= style_n "CIHDC") (= style_n "CIHDW"))
      (_sstya style_n "romand,whgdtxt")
    )
    ((or (= style_n "CIHT") (= style_n "CIHTC") (= style_n "CIHTW"))
      (_sstya style_n "romand,whtgtxt")
    )
    ((or (= style_n "CIHM") (= style_n "CIHMC") (= style_n "CIHMW"))
      (_sstya style_n "romand,whtmtxt")
    )
 
    ((= style_n "CIHC")
      (_sstya "CIHC" "romand,whtgtxt")
    )
    ((= style_n "CIHG")
      (_sstya "CIHG" "romanc,whtmtxt")
    )
    ((= style_n "HTXT")
      (_sstya "HTXT" "txt,htxtw")
    )
    ((= style_n "HSH")
      (_sstya "HSH" "romans,hsw")
    )
    ((= style_n "HDH")
      (_sstya "HDH" "helved,hdw")
    )
;; true type 한글 폰트
    ((or (= style_n "CITB") (= style_n "CITBC") (= style_n "CITBW"))
      (_ssty style_n "바탕체")  
    )
    ((or (= style_n "CITG") (= style_n "CITGC") (= style_n "CITGW"))
      (_ssty style_n "궁서체")  
    ) 
    ((OR (= style_n "CITD") (= style_n "CITDC") (= style_n "CITDW"))
      (_ssty style_n "돋움체")  
    )
    ((OR (= style_n "CITL") (= style_n "CITLC") (= style_n "CITLW"))
      (_ssty style_n "굴림체")  
    ) 
;;;
    ((= style_n "HGH")
      (_sstya "HGH" "romand,hgw")
    )
    ((= style_n "HRB1")
      (_sstya "HRB1" "helved,hrb1w")
    )
    ((= style_n "HRB7")
      (_sstya "HRB7" "helved,hrb7w")
    )
    ((= style_n "HBB1")
      (_sstya "HBB1" "helved,hbb1w")
    )
    ((= style_n "HBB7")
      (_sstya "HBB7" "helved,hbb7w")
    )
    ((= style_n "HRM1")
      (_sstya "HRM1" "helved,hrm1w")
    )
    ((= style_n "HRM7")
      (_sstya "HRM7" "helved,hrm7w")
    )
    ((= style_n "HBM1")
      (_sstya "HBM1" "helved,hbm1w")
    )
    ((= style_n "HBM7")
      (_sstya "HBM7" "helved,hbm7w")
    )
    ((= style_n "HRL1")
      (_sstya "HRL1" "helved,hrl1w")
    )
    ((= style_n "HRL7")
      (_sstya "HRL7" "helved,hrl7w")
    )
    ((= style_n "HBL1")
      (_sstya "HBL1" "helved,hbl1w")
    )
    ((= style_n "HBL7")
      (_sstya "HBL7" "helved,hbl7w")
    )
    ((= style_n "HSC")
      (_sstya "HSC" "txt,hscw")
    )
    ((= style_n "HRLC7")
      (_sstya "HRLC7" "helved,hrlc7w")
    )
    ((= style_n "GHS")
      (_ssty "GHS" "romans,ghs")
    )
    ((= style_n "GHD")
      (_ssty "GHD" "outline,ghd")
    )
    ((= style_n "GHJ")
      (_ssty "GHJ" "handlet,ghj")
    )
    ((= style_n "GCHM")
      (_ssty "GCHM" "gem2,gchm")
    )
    ((= style_n "GHG1")
      (_ssty "GHG1" "geg1,ghg1")
    )
    ((= style_n "GHM1")
      (_ssty "GHM1" "gem1,ghm1")
    )
    ((= style_n "GHG2")
      (_ssty "GHG2" "geg2,ghg2")
    )
    ((= style_n "CGS")
      (_ssty "CGS" "cgse,cgs")
    )
    ((= style_n "CGD")
      (_ssty "CGD" "cgde,cgd")
    )
    ((= style_n "CGD2")
      (_ssty "CGD2" "cgde2,cgd2")
    )
    ((= style_n "CMD")
      (_ssty "CMD" "cmde,cmd")
    )
    ((= style_n "CGUD")
      (_ssty "CGUD" "cgude,cgud")
    )
    ((= style_n "CGRD")
      (_ssty "CGRD" "cgrde,cgrd")
    )
    ((= style_n "CSD")
      (_ssty "CSD" "cgde,csd")
    )
    ((= style_n "CYD")
      (_ssty "CYD" "cgde,cyd")
    )
    ((= style_n "CADSG")
      (_ssty "CADSG" "romans,cadsg")
    )
    ((= style_n "cadhd")
      (_ssty "CYD" "cada03,cadhd")
    )
    ((= style_n "cadkm")
      (_ssty "CYD" "romand,cadkm")
    )
    ((= style_n "CIBT")
      (_sstya "CityBlueprint" "cibt____.pfb")
    )
    ((= style_n "COBT")
      (_sstya "CountryBlueprint" "cobt____.pfb")
    )
    ((= style_n "EUR")
      (_sstya "EuroRoman" "eur_____.pfb")
    )
    ((= style_n "EURO")
      (_sstya "EuroRomanOblique" "euro____.pfb")
    )
    ((= style_n "PAR")
      (_sstya "PanRoman" "par_____.pfb")
    )
    ((= style_n "ROM")
      (_sstya "Romantic" "rom_____.pfb")
    )
    ((= style_n "ROMB")
      (_sstya "RomanticBold" "romb____.pfb")
    )
    ((= style_n "ROMI")
      (_sstya "RomanticItalic" "romi____.pfb")
    )
    ((= style_n "SAS")
      (_sstya "SansSerif" "sas_____.pfb")
    )
    ((= style_n "SASB")
      (_sstya "SansSerifBold" "sasb____.pfb")
    )
    ((= style_n "SASBO")
      (_sstya "SansSerifBoldOblique" "sasbo___.pfb")
    )
    ((= style_n "SASO")
      (_sstya "SansSerifOblique" "saso____.pfb")
    )
    ((= style_n "SUF")
      (_sstya "SuperFrench" "suf_____.pfb")
    )
    ((= style_n "TE")
      (_sstya "Technic" "te______.pfb")
    )
    ((= style_n "TEB")
      (_sstya "TechnicBold" "teb_____.pfb")
    )
    ((= style_n "TEL")
      (_sstya "TechnicLight" "tel_____.pfb")
    )
    
    (T
      (if (findfile (strcat style_n ".shx"))
        (_sstya style_n style_n)
        (progn
         ; (alert "글꼴이름이 부적절합니다.")
         ; (exit)
      (_ssty style_n "굴림")
      (exit)
      
        )
      )
    )
  )
  (princ)
)

  (princ ".")

(defun _SSTY (style fonts / dl_ote sty_wid_factor)
  (setq dl_ocm (getvar "cmdecho"))
  (setq dl_ote (getvar "textstyle"))
  (setvar "cmdecho" 0)
  (cond ((= style "CIHSC") (setq sty_wid_factor 0.6))
    ((or (= style "CIHS") (= style "CIHDC") (= style "CIHTC")(= style "CIHMC")) (setq sty_wid_factor 0.8))
    ((or (= style "CIHDW") (= style "CIHTW")(= style "CIHMW")) (setq sty_wid_factor 1.2))
    (T (setq sty_wid_factor 1))
  )
  (if (= (stysearch style) nil)
    (command "_.style" style fonts 0 sty_wid_factor 0 "n" "n")  ;;변경
  )
  (setvar "textstyle" dl_ote)
  (setvar "cmdecho" dl_ocm)
)

(defun _SSTYA (style fonts / dl_ote sty_wid_factor)
  (setq dl_ocm (getvar "cmdecho"))
  (setq dl_ote (getvar "textstyle"))
  (setvar "cmdecho" 0)
  (cond ((= style "CIHSC") (setq sty_wid_factor 0.6))
    ((or (= style "CIHS") (= style "CIHDC") (= style "CIHTC")(= style "CIHMC")) (setq sty_wid_factor 0.8))
    ((or (= style "CIHDW") (= style "CIHTW")(= style "CIHMW")) (setq sty_wid_factor 1.2))
    (T (setq sty_wid_factor 1))
  )
  (if (= (stysearch style) nil)
    (command "_.style" style fonts 0 sty_wid_factor 0 "n" "n" "n")  ;;변경
  )
  (setvar "textstyle" dl_ote)
  (setvar "cmdecho" dl_ocm)
)

(defun SSTY (style fonts wid)
  (setq dl_ocm (getvar "cmdecho"))
  (setvar "cmdecho" 0)
  (if (= (stysearch style) nil)
    (command "_.style" style fonts 0 wid 0 "n" "n")
    (command "_.style" style "" 0 wid 0 "n" "n")
  )
  (setvar "cmdecho" dl_ocm)
  (princ (strcat "현재의 글꼴은 " style " 입니다."))
  (princ)
)

(defun SSTYA (style fonts wid)
  (setq dl_ocm (getvar "cmdecho"))
  (setvar "cmdecho" 0)
  (if (= (stysearch style) nil)
    (command "_.style" style fonts 0 wid 0 "n" "n" "n")
    (command "_.style" style "" 0 wid 0 "n" "n" "n")
  )
  (setvar "cmdecho" dl_ocm)
  (princ (strcat "현재의 글꼴은 " style " 입니다."))
  (princ)
)

(defun SLTY (ltype)
  (setvar "cmdecho" 0)
  (command "_.linetype" "_s" ltype "")
  (setvar "cmdecho" 1)
  (princ (strcat "현재의 라인타입은 " ltype " 입니다."))
  (princ)
)

(defun SLAY (lay)
  (setvar "cmdecho" 0)
  (command "_.layer" "_m" lay "")
  (setvar "cmdecho" 1)
  (princ (strcat "현재의 레이어는 " lay " 입니다."))
  (princ)
)

(defun SCOL (col)
  (setvar "cmdecho" 0)
  (command "_.color" col)
  (setvar "cmdecho" 1)
  (princ (strcat "현재의 색상은 " col " 입니다."))
  (princ)
)

  (princ ".")


;;; 수정날짜: 2001년 8월 20일
;;; 작업자  : 박율구
;;; 수정내용: command->layer 오류 수정
(defun SETLAY(ci_layer / layinfo)
  (setvar "cmdecho" 0)
  (setq OLDLAY (getvar "CLAYER"))
  (if (setq layinfo (tblsearch "layer" ci_layer))
    (while layinfo
      (cond
        ((= (logand (cdr (assoc 70 layinfo)) 1) 1)
          (command "_.layer" "_T" ci_layer "")
          (setq layinfo (tblsearch "layer" ci_layer))
        )
        ((= (logand (cdr (assoc 70 layinfo)) 4) 4)
          (command "_.layer" "_U" ci_layer "")
          (setq layinfo (tblsearch "layer" ci_layer))
        )
        ((minusp (cdr (assoc 62 layinfo)))
          (command "_.layer" "_ON" ci_layer "")
          (setq layinfo (tblsearch "layer" ci_layer))
        )
        (T
	  ; 고친 부분
          ;(command "_.layer" "_s" ci_layer "")
	  (setvar "CLAYER" ci_layer)
          (setq layinfo nil)
        )
      )
    )
    (command "_.layer" "_m" ci_layer "")
  )
)
(defun RTNLAY()
  ; 고친 부분
  ;(command "_.LAYER" "_S" OLDLAY "")
  (setvar "CLAYER" OLDLAY)
  (princ)
)

;;; 수정날짜: 2001년 8월 20일
;;; 작업자  : 박율구
;;; 수정내용: CVS변수의 오류 수정
(defun COMMA (RVAL FIXED / DP CNO buho) 
  (if (< RVAL 0)
     (setq buho -1)
     (setq buho 1)
  )
  (setq RVAL (* RVAL buho))
 ;;; 고친부분
  (setq CVS (myrtos RVAL FIXED))
  (setq DP  (- (strlen CVS) FIXED)
        CNO (fix (/ (1- DP) 3.0))
        CNO (if (= (rem (1- DP) 3) 0) (1- CNO) CNO)
  )
  (if (= CNO 0) (setq CNO 1))
  (if (>= RVAL 1000)
    (while (and (> CNO 0) (> DP 4))
      (setq CVS (strcat (substr CVS 1 (- DP 4)) "," (substr CVS (- DP 3)))
            DP  (- DP 3)
	    CNO (1- CNO)
      )
    )
  )	
  (if (= FIXED 0) (setq CVS (substr CVS 1 (1- (strlen CVS)))))
  (if (< buho 0) (setq CVS (strcat "-" CVS)))
;;; 고친부분
  (setq CVS CVS)
)
(princ ".")

(defun rtd (a)
  (/ (* a 180.0) pi)
)

(defun RMV (/ k e ll la lsame)
  (setq k 0)
  (repeat (sslength ss)
    (setq e (entget (ssname ss k)))
    (setq ll (cdr (assoc 6 e)))
    (setq la (cdr (assoc 8 e)))
    (if (= ll nil)
      (setq ll (bylayerLtype e))
    )
    (if (or (wcmatch (strcase ll) "CEN*") (wcmatch (strcase la) "CEN*"))
      (ssdel (ssname ss k) ss)
      (setq k (1+ k))
    )
  )
  (setq no -1)
  (setq ls (sslength ss))
)

  (princ ".")

(defun CCO (/ cec ss e c2)
  (setq cec (getvar "CECOLOR"))
  (command "_.chprop" "_L" "" "_C" cec "")
)

(defun CLA (/ cla ss e l2)
  (setq cla (getvar "CLAYER"))
  (command "_.chprop" "_L" "" "_LA" cla "")
)

(defun CLT (/ clt ss e t2)
  (setq clt (getvar "CELTYPE"))
  (command "_.CHPROP" "_L" "" "_LT" clt "")
)

(defun RMC (/ COMMA COM)
  (setq COMMA nil)
  (while (= COMMA nil)
    (setq COM (instr smx ","))
    (if (= COM nil)
      (setq COMMA not)
      (setq smx (strcat (substr smx 1 (1- COM)) (substr smx (1+ COM))))
    )
  )
)

(defun wang (/ dl_ucs ss e mp0 kp0 ang)
  (if (setq ss (ci_ss strtpt))
    (progn
      (setq dl_ucs (getvar "worlducs"))
      (setq e (entget (ssname ss 0)))
      (if(= (fld_st 0 e) "LINE")
        (progn
          (setq mp0 (fld_st 10 e)
                kp0 (fld_st 11 e)
          )
          (setq ang (angle mp0 kp0))
          (if (= dl_ucs 1)
            (setvar "snapang" ang)
          )
          (setvar "snapbase" (list (car strtpt) (cadr strtpt)))
        )
      )
    )
  )
)

(defun getWall_property(/ nnn e found old_@Type tmpprop)
  (setq nnn 0 )
  (SETQ E (ENTGET (SSNAME ss nnn)))
  (while (and (< nnn (sslength ss)) (not found))
      (SETQ E (ENTGET (SSNAME ss nnn)))
        (setq nnn (1+ nnn))
        (if (wcmatch (CDR (ASSOC 8 E)) "*WAL") (setq found T))
  )
  (if found
    (progn
      (SETQ *wal_col (CDR (ASSOC 62 E)))
      (setq *wal_lin (cdr (assoc 6 e)))
      (SETQ *wal_lay (CDR (ASSOC 8 E)))
     )
    (progn
      (setq old_@Type @TYPE)
      ;;(readF "PropType.dat" "prop")
      (setq tmpprop (Prop_search "wall" "wall"))
      (SETQ *wal_col (nth 3 tmpprop))
      (setq *wal_lin (nth 4 tmpprop))
      (SETQ *wal_lay (nth 2 tmpprop))
      (setq @TYPE old_@Type)
     )
   )
   
)
;;;(defun wall_count(/ n m wn ent)
;;;  (setq n (setq wn (sslength ss)) m 0)
;;;  (repeat n
;;;    (if (wcmatch (cdr (ASSOC 8 (ENTGET (SSNAME ss m)))) "FINISH")
;;;      (setq wn (1- wn))
;;;    )
;;;    (setq m (1+ m))
;;;  )
;;;  wn
;;;)
(defun brkl (flag / cet col ss k mp kp mp0 mp1 kp0 kp1 pk1 pk2 pk3 pk0 pk0e pk2e
         *wal_lay *wal_col *wal_lin t_ent1 t_ent2)
  (setq ss (ssget "C" pt2 pt4 '((0 . "LINE"))))
  (RMV)
  (getWall_property)
  (SETQ s1 (SSGET "C" PT2 PT2) )
  (setq s2 (ssget "C" pt4 pt4))
  (setq cet (getvar "celtype"))
  (setq col (getvar "cecolor"))
  
  (ssdel (ssname s1 0) ss)
  (ssdel (ssname s2 0) ss)
  (setvar "cmdecho" 0)
  (command "_.break" (ssname s1 0) pt1 pt2)
  (command "_.break" (ssname s2 0) pt1 pt2)
  (setq mp0 (cdr (assoc 10 (entget (ssname ss 0))))
        kp0 (cdr (assoc 11 (entget (ssname ss 0)))))
  (setq mp1 (cdr (assoc 10 (entget (ssname ss 1))))
        kp1 (cdr (assoc 11 (entget (ssname ss 1)))))
  (setq pk0 (inters mp0 kp0 pt1 pt3)
        pk1 (inters mp1 kp1 pt1 pt3))
  (setq pk0e pk0                 ;수정
        pk0 (polar pk0 (+ ang (dtr 180)) 90)    
        pk1 (polar pk1 (+ ang (dtr 180)) 90))
  (setq pk2 (polar pk0 ang (+ d1 180))
    pk2e (polar pk0e ang d1)        ;수정
        pk3 (polar pk1 ang (+ d1 180)))
  (if (< (distance pt1 pk0) (distance pt1 pk1))
      (setq t_ent1 (ssname ss 1)
        t_ent2 (ssname ss 0)
      )
          (setq t_ent1 (ssname ss 0)
        t_ent2 (ssname ss 1)
       )
  )
  (if (= flag "wall_2")                      ;;수정 
      (command "_.break" t_ent1 pk0e pk2e)
      (command "_.break" t_ent1 pk0 pk2)
  ) 
  (command "_.break" t_ent2 pk1 pk3)
  (SETLAY *wal_lay)
  (COMMAND "_.COLOR" *wal_col)
  (command "_.linetype" "_S" *wal_lin "")
  (command "_.LINE" pt1 pt3 "")
  (command "_.LINE" pt2 pt4 "")
  (command "_.LINE" pk0 pk1 "")
  (command "_.LINE" pk2 pk3 "")
  (command "_.linetype" "_S" cet "")
  (COMMAND "_.COLOR" col)
  (RTNLAY)
  (setvar "BLIPMODE" 0)
  (setvar "cmdecho" 0)
)

(defun brk_s (/ ls ss col cet no *wal_lay *wal_col *wal_lin)
  (setq ss  (ssget "C"(polar pt2 (angle pt2 pt1) (/ (distance pt1 pt2) 2))
          (polar pt4 (angle pt2 pt1) (/ (distance pt1 pt2) 2)) 
              '((-4 . "<OR") (0 . "LINE") (0 . "*POLYLINE") (-4 . "OR>"))))
  (RMV)
  (getWall_property)
  
  (setq cet (getvar "celtype"))
  (setq col (getvar "cecolor"))
  (if (= cc nil)  (setq cc  "BYLAYER"))
  (if (= clt nil) (setq clt "BYLAYER"))
  (setvar "cmdecho" 0)
  (repeat ls
    (setq no  (1+ no))
    (command "_.break" (ssname ss no) pt1 pt2)
  )
  (SETLAY *wal_lay)
  (COMMAND "_.COLOR" *wal_col)
  (command "_.linetype" "_S" *wal_lin "")
  (command "_.LINE" pt1 pt3 "")
  (command "_.line" pt2 pt4 "")
  (command "_.color" col)
  (command "_.linetype" "_S" cet "")
  (RTNLAY)
  (setvar "cmdecho" 0)
  (setvar "blipmode" 0)
)

(defun brk_a (/ cept ss cet col  no *wal_lay *wal_col *wal_lin)
  (setvar "cmdecho" 0)
  (setq cet (getvar "celtype"))
  (setq col (getvar "cecolor"))
  (command "_.regen")
  (setq ss (ssget "C" pt1 pt3
             '((-4 . "<OR") (0 . "ARC") (0 . "CIRCLE") (-4 . "OR>"))))
  (RMV)
  (getWall_property)
    
  (setq cept (fld_st 10 e))
  (setq ang3 (angle pt1 pt3))
  (if (and (> ang (dtr 270)) (< ang3 (dtr 135)))
    (setq ang (- ang (dtr 360)))
  )
  (if (and (> ang3 (dtr 270)) (< ang (dtr 135)))
    (setq ang (+ ang (dtr 360)))
  )
  (if (<= (abs (- ang3 (+ ang (dtr 90)))) (dtr 30))
    (setq ang3 (+ ang (dtr 90)))
  )
  (if (<= (abs (- ang3 (- ang (dtr 90)))) (dtr 30))
    (setq ang3 (- ang (dtr 90)))
  )
  (if (> ar_r1 ar_r2)
    (setq pb3 (polar pt1 ang3 d2)
          pb1 (polar pb3 (angle cept pb3) d2)
          pb4 (polar pt2 ang3 d2)
          pb2 (polar pb4 (angle cept pb4) d2)
    )
    (setq pb1 pt1
          pb3 (polar pb1 (angle cept pb1) d2)
          pb2 pt2
          pb4 (polar pb2 (angle cept pb2) d2)
    )
  )
  (setq pt3 (polar pt1 ang3 d2))
  (repeat ls
    (setq no  (1+ no))
    (if (> (angle cept pb1) (angle cept pb2))
      (command "_.break" (ssname ss no) pb2 pb1)
      (command "_.break" (ssname ss no) pb1 pb2)
    )
  )
  (SETLAY *wal_lay)
  (COMMAND "_.COLOR" *wal_col)
  (command "_.linetype" "_S" *wal_lin "")
  (command "_.LINE" pb1 pb3 "")
  (command "_.line" pb2 pb4 "")
  (command "_.color" col)
  (command "_.linetype" "_S" cet "")
  (RTNLAY)
  (setvar "cmdecho" 0)
  (setvar "blipmode" 0)
)

  (princ ".")

(defun brk_aw (/ ss cet cel no *wal_lay *wal_col *wal_lin)
  (setvar "cmdecho" 0)
  
  (setq ss  (ssget "C" pt1 pt3
              '((-4 . "<OR") (0 . "ARC") (0 . "CIRCLE") (-4 . "OR>"))))
  (RMV)
  (getWall_property)

  (setq cel  (cdr (assoc 8 e)))
  (setq cept (fld_st 10 e))
  (repeat ls
    (setq no  (1+ no))
    (command "_.break" (ssname ss no) pt1 pt2)
  )
  (SETLAY *wal_lay)
  (COMMAND "_.COLOR" *wal_col)
  (command "_.linetype" "_S" *wal_lin "")
  (command "_.LINE" pt1 pt3 "")
  (command "_.line" pt2
           (if (> ar_r1 ar_r2)
             (setq pt4 (polar pt2 (angle pt2 cept) d2))
             (setq pt4 (polar pt2 (angle cept pt2) d2))
           ) "")
  (RTNLAY)
  (setvar "cmdecho" 0)
  (setvar "blipmode" 0)
)

  (princ ".")

(defun dtr (a)
  (* pi (/ a 180.0))
)

(defun Midpick (/ p1 p2)
  (setq p1 (getpoint "\First point: "))
  (setq p2 (getpoint "\Second point: "))
  (setvar "LASTPOINT"
    (polar p1 (angle p1 p2)
    (/ (distance p1 p2) 2))
  )
)

(DEFUN SELL ()
  (SETQ S (GETSTRING "Layer Name: "))
)

(defun SELLS (/ e temp)
  (setq temp T)
  (while temp
    (setq e (entsel "Select Entity on Layer: "))
    (if e
      (progn
        (setq e (entget (car e)))
        (setq s (cdr (assoc 8 e)))
        (prompt "<Layer Name: ")
        (princ s)
        (princ "> ")
        (setq temp nil)
      )
      (progn
        (alert "Entity not selected -- Try again. ")
        (princ "\n\t         ")
      )
    )
  )
)

(defun SELB (/ e temp)
  (setq temp T)
  (while temp
    (setq e (entsel "Select Block: "))
    (if e
      (progn
        (setq e (entget (car e)))
        (if (assoc 2 e)
          (progn
            (setq s (cdr (assoc 2 e)))
            (prompt "<Block Name: ")
            (princ s)
            (princ "> ")
            (setq temp nil)
          )
          (progn
            (alert "블록이 아닙니다. 다시 선택하십시요.")
            (princ "\n\t         ")
          )
        )
      )
      (progn
        (alert "선택되지 않았습니다. 다시 선택하십시요. ")
        (princ "\n\t         ")
      )
    )
  )
)

  (princ ".")

(DEFUN SELC ()
  (SETQ S (GETINT "Number of Color: "))
)

(defun SELCS (/ e temp)
  (setq temp T)
  (while temp
    (setq e (entsel "Select Entity of Color: "))
    (if e
      (progn
        (setq e (entget (car e)))
        (setq s (cdr (assoc 62 e)))
        (prompt "<Color Number: ")
        (princ s)
        (princ "> ")
        (setq temp nil)
      )
      (progn
        (alert "선택되지 않았습니다. 다시 선택하십시요. ")
        (princ "\n\t         ")
      )
    )
  )
)

(defun SELT ()
  (setq s (getstring "Linetype Name: "))
)

(defun SELTS (/ e temp)
  (setq temp T)
  (while temp
    (setq e (entsel "Select Entity of LineType: "))
    (if e
      (progn
        (setq e (entget (car e)))
        (setq s (cdr (assoc 6 e)))
        (prompt "<Linetype Name: ")
        (princ s)
        (princ "> ")
        (setq temp nil)
      )
      (progn
        (alert "선택되지 않았습니다. 다시 선택하십시요. ")
        (princ "\n\t         ")
      )
    )
  )
)

(defun SELE (/ e temp)
  (setq temp T)
  (while temp
    (setq e (entsel "Select Entity: "))
    (if e
      (progn
        (setq e (entget (car e)))
        (setq s (cdr (assoc 0 e)))
        (prompt "<Entity Name: ")
        (princ s)
        (princ "> ")
        (setq temp nil)
      )
      (progn
        (alert "선택되지 않았습니다. 다시 선택하십시요. ")
        (princ "\n\t         ")
      )
    )
  )
)

(defun SELS (/ e temp)
  (setq temp T)
  (while temp
    (setq e (entsel "Select Text Style: "))
    (if e
      (progn
        (setq e (entget (car e)))
        (if (assoc 7 e)
          (progn
            (setq s (cdr (assoc 7 e)))
            (prompt "<Style Name: ")
            (princ s)
            (princ "> ")
            (setq temp nil)
          )
          (progn
            (alert "문자가 아닙니다. 다시 선택하십시요. ")
            (princ "\n\t         ")
          )
        )
      )
      (progn
        (alert "선택되지 않았습니다. 다시 선택하십시요. ")
        (princ "\n\t         ")
      )
    )
  )
)

(defun SELST ()
  (setq s (getstring "Text Style Name: "))
)

  (princ ".")

  (defun get_num (tcolor)
    (if (= (type tcolor) 'STR)
      (setq tcolor (strcase tcolor))
    )
    (cond
      ((= tcolor "RED")
        1
      )
      ((= tcolor "YELLOW")
        2
      )
      ((= tcolor "GREEN")
        3
      )
      ((= tcolor "CYAN")
        4
      )
      ((= tcolor "BLUE")
        5
      )
      ((= tcolor "MAGENTA")
        6
      )
      ((= tcolor "WHITE")
        7
      )
      ((= tcolor "BYBLOCK")
        0
      )
      ((= tcolor "BYLAYER")
        256
      )
      ((= (type tcolor) 'STR)
        (atoi tcolor)
      )
      (T
        tcolor
      )
    )
  )
  ;;
  ;; Function to set the color tiles. 
  ;;
  (defun set_color (tcolor color image / layname layinfo colnum)
    (cond 
      ((= 0 tcolor)
        (set_tile color "BYBLOCK")
        (col_tile image 0 nil)
      )
      ((= 1 tcolor)
        (set_tile color "1 red")
        (col_tile image 1 nil)
      )
      ((= 2 tcolor)
        (set_tile color "2 yellow")
        (col_tile image 2 nil)
      )
      ((= 3 tcolor)
        (set_tile color "3 green")
        (col_tile image 3 nil)
      )
      ((= 4 tcolor)
        (set_tile color "4 cyan")
        (col_tile image 4 nil)
      )
      ((= 5 tcolor)
        (set_tile color "5 blue")
        (col_tile image 5 nil)
      )
      ((= 6 tcolor)
        (set_tile color "6 magenta")
        (col_tile image 6 nil)
      )
      ((= 7 tcolor)
        (set_tile color "7 white")
        (col_tile image 7 nil)
      )
      ((= 256 tcolor) 
        (if (and lay-idx laynmlst)
          (setq layname (nth lay-idx laynmlst))
          (setq layname (getvar "clayer"))
        )
        (setq layinfo (tblsearch "layer" layname))
        (setq colnum (abs (cdr (assoc 62 layinfo))))
        (set_tile color (by_layer_col))
        (col_tile image colnum nil)
      )
      (T
        (set_tile color (itoa tcolor))
        (col_tile image tcolor nil)
      )
    )
  )

  (princ ".")

  ;;
  ;; this function pops a dialogue box consisting of a list box, image tile, and 
  ;; edit box to allow the user to select or  type a linetype.  It returns the 
  ;; linetype selected.
  ;;
  (defun get_ltype (/ old-idx)
    (if (not ltnmlst)
      (make_ltlists)          ; linetype lists - ltnmlst, mdashlist
    )
    (setq lt-idx (get_index ltname ltnmlst))
    (if (or (= (get_tile "error") "")(= (get_tile "error") nil))
     (progn
      (if (not (new_dialog "setltype" dcl_id)) (exit))
      (start_list "list_lt")
      (mapcar 'add_list ltnmlst)  ; initialize list box
      (end_list)
      (setq old-idx lt-idx)
      (lt_list_act (itoa lt-idx))

      (action_tile "list_lt" "(lt_list_act $value)")
      (action_tile "edit_lt" "(lt_edit_act $value)")
      (action_tile "accept" "(test_ok)")
      (action_tile "cancel" "(reset_lt)")

      (if (= (start_dialog) 1) ; User pressed OK
        (cond 
          ((= lt-idx 0)
            (set_tile "t_ltype" (by_layer_lt))
            "BYLAYER"
          )
          ((= lt-idx 1)
            (set_tile "t_ltype" "BYBLOCK")
            "BYBLOCK"
          )
          (T  (set_tile "t_ltype" ltname) ltname)
        )
        eltype
      )
     )
     eltype
    )
  )
  ;;
  ;; Edit box entries end up here
  (defun lt_edit_act (ltvalue)
    (setq ltvalue (strcase ltvalue))
    (if (or (= ltvalue "BYLAYER") (= ltvalue "BY LAYER"))
      (setq ltvalue "BYLAYER")
    )
    (if (or (= ltvalue "BYBLOCK") (= ltvalue "BY BLOCK"))
      (setq ltvalue "BYBLOCK")
    )
    (if (setq lt-idx (get_index ltvalue ltnmlst))
      (progn
        (set_tile "error" "")
        (lt_list_act (itoa lt-idx))
        (mode_tile "list_lt" 2)
      )
      (progn
        (set_tile "error" "라인타입이 부적절합니다.")
        (setq lt-idx old-idx)
        (mode_tile "edit_lt" 2)
      )
    )
  )
  ;;
  ;; List selections end up here.  Update the list box, edit box, and color 
  ;; tile.
  ;;
  (defun lt_list_act (index / dashdata)
    (set_tile "error" "")
    (setq lt-idx (atoi index))
    (setq ltname (nth lt-idx ltnmlst))
    (setq dashdata (nth lt-idx mdashlist))
    (col_tile "show_image" 0 dashdata)
    (set_tile "list_lt" (itoa lt-idx))
    (set_tile "edit_lt" ltname)
  )
  ;;
  ;; Color a tile, draw linetype, and draw a border around it
  ;;
  (defun col_tile (tile color patlist / x y)
    (setq x (dimx_tile tile))
    (setq y (dimy_tile tile))
    (start_image tile)
    (fill_image 0 0 x y color)
    (if (= color 7)
      (progn
        (if patlist (draw_pattern x (/ y 2) patlist 0))
        (tile_crect 0 0 x y 0)
      )
      (progn
        (if patlist (draw_pattern x (/ y 2) patlist (if ecolor ecolor 7)))
        (tile_crect 0 0 x y 7)
      )
    )
    (end_image)
  )
  ;;
  ;; Edit box selections end up here.  Convert layer entry to upper case.  If 
  ;; layer name is valid, clear error string, call (lay_list_act) function,
  ;; and change focus to list box.  Else print error message.
  ;;
  (defun lay_edit_act (layvalue)
    (setq layvalue (strcase layvalue))
    (if (setq lay-idx (get_index layvalue laynmlst))
      (progn
        (set_tile "error" "")
        (lay_list_act (itoa lay-idx))
      )
      (progn
        (set_tile "error" "Invalid layer name.")
        (mode_tile "edit_lay" 2)
        (setq lay-idx old-idx)
      )
    )
  )

  (princ ".")

  ;;
  ;; List entry selections end up here.
  ;;
  (defun lay_list_act (index / layinfo color dashdata)
    ;; Update the list box, edit box, and color tile.
    (set_tile "error" "")
    (setq lay-idx (atoi index))
    (setq layname (nth lay-idx laynmlst))
    (setq layinfo (tblsearch "layer" layname))
    (setq color (cdr (assoc 62 layinfo)))
    (setq color (abs color))
    (setq colname (color_name color))
    (set_tile  "list_lay" (itoa lay-idx))
    (set_tile  "edit_lay" layname)
    (mode_tile "list_lay" 2)
  )
  ;;
  ;; this function makes a list called laynmlst which consists of all the layer
  ;; names in the drawing.  It also creates a list called longlist which 
  ;; consists of strings which contain the layer name, color, linetype, etc.  
  ;; Longlist is later mapped into the layer listbox.  Both are ordered the 
  ;; same.
  ;;
  (defun make_laylists (/ layname onoff frozth color linetype vpf vpn ss 
                           cvpname xdlist vpldata sortlist name templist
                           bit-70
                        )
    (if (= (setq tilemode (getvar "tilemode")) 0)
      (progn
        (setq ss (ssget "x" (list (cons 0 "VIEWPORT")
                                  (cons 69 (getvar "CVPORT"))
                            )
                 )
        )
        (setq cvpname (ssname ss 0))
        (setq xdlist (assoc -3 (entget cvpname '("acad"))))
        (setq vpldata (cdadr xdlist))
      )
    )
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
    (setq laynmlst sortlist)
    (setq longlist nil)
    (setq layname (car sortlist))
    (while layname
      (setq laylist (tblsearch "LAYER" layname))
      (setq color (cdr (assoc 62 laylist)))
      (if (minusp color)
        (setq onoff ".")
        (setq onoff "On")
      )
      (setq color (abs color))
      (setq colname (color_name color))
      (setq bit-70 (cdr (assoc 70 laylist)))
      (if (= (logand bit-70 1) 1)
        (setq frozth "F")
        (setq frozth ".")
      )
      (if (= (logand bit-70 2) 2)
        (setq vpn "N")
        (setq vpn ".")
      )
      (if (= (logand bit-70 4) 4)
        (setq lock "L")
        (setq lock ".")
      )
      (setq linetype (cdr (assoc 6 laylist)))
      (setq layname (substr layname 1 31))
      (if (= tilemode 0)
        (progn
          (if (member (cons 1003 layname) vpldata)
            (setq vpf "C")
            (setq vpf ".")
          )
        )
        (setq vpf ".")
      )
      (setq ltabstr (strcat layname "\t"
                              onoff "\t"
                             frozth "\t"
                               lock "\t"
                                vpf "\t"
                                vpn "\t"
                            colname "\t"
                           linetype
                    )
      )
      (setq longlist (append longlist (list ltabstr)))
      (setq sortlist (cdr sortlist))
      (setq layname (car sortlist))
    )
  )

  (princ ".")
  ;;
  ;; this function makes 2 list - ltnmlst & mdashlist.
  ;; Ltnmlst is a list of linetype names read from the symbol table.  Mdashlist 
  ;; is list consisting of lists which define the linetype pattern - numbers 
  ;; stp:xsiat indicate dots, dashes, and spaces taken from group code 49.  the list 
  ;; corresponds to the order of names in ltnmlst.
  ;;
  (defun make_ltlists (/ fname aa bb cc)
    (setq ltnmlst nil)
    (setq mdashlist nil)
    (if (not (setq fname (findfile "ACLT.LIN")))
      (progn
        (princ "\n>>> ACLT.LIN not found. ")
        (exit)
      )
    )
    (setq ltnmlst (cons "BYLAYER" ltnmlst))
    (setq mdashlist (cons nil mdashlist))
    (setq ltnmlst (cons "BYBLOCK" ltnmlst))
    (setq mdashlist (cons nil mdashlist))
    (setq ltnmlst (cons "CONTINUOUS" ltnmlst))
    (setq mdashlist (cons "CONT" mdashlist))
    (setq aa (open fname "r"))
    (while (setq bb (read-line aa))
      (if (= (instr bb "*") 1)
        (setq ltnmlst (cons (substr bb 2 (- (instr bb ",") 2)) ltnmlst))
      )
      (if (= (instr bb "A,") 1)
        (progn
          (setq cc (substr bb 3))
          (setq mdlist nil)
          (while (setq nc (instr cc ","))
            (setq mdlist (cons (/ (atof (substr cc 1 (1- nc))) 6) mdlist))
            (setq cc (substr cc (1+ nc)))
          )
          (setq mdlist (reverse (cons (/ (atof cc) 6) mdlist)))
          (setq mdashlist (cons mdlist mdashlist))
        )
      )
    )
    (close aa)
    (setq ltnmlst   (reverse ltnmlst))
    (setq mdashlist (reverse mdashlist))
    (setq ltlist (tblnext "LTYPE" T))
    (setq ltname (cdr (assoc 2 ltlist)))
    (if (not (get_index ltname ltnmlst))
      (progn
        (setq ltnmlst (append ltnmlst (list ltname)))
        (setq mdashlist
              (append mdashlist (list (ci_add_mdash ltlist)))
        )
      )
    )
    (while (setq ltlist (tblnext "LTYPE"))
      (setq ltname (cdr (assoc 2 ltlist)))
      (if (not (get_index ltname ltnmlst))
        (progn
          (setq ltnmlst (append ltnmlst (list ltname)))
          (setq mdashlist
              (append mdashlist (list (ci_add_mdash ltlist)))
          )
        )
      )
    )
  )
  ;;
  ;; Get all the group code 49 values for a linetype and put them in a list 
  ;; (pen-up, pen-down info).
  ;;
  (defun ci_add_mdash (ltlist1 / dashlist assoclist dashsize)
    (setq dashlist nil)
    (while (setq assoclist (car ltlist1))
      (if (= (car assoclist) 49)
        (progn
          (setq dashsize (cdr assoclist))
          (setq dashlist (cons dashsize dashlist))
        )
      )
      (setq ltlist1 (cdr ltlist1))
    )
    (setq dashlist (reverse dashlist))
  )
  ;;
  ;; Draw a border around a tile
  ;;
  (defun tile_crect (x1 y1 x2 y2 color)
    (setq x2 (- x2 1))
    (setq y2 (- y2 1))
    (vector_image x1 y1 x2 y1 color)
    (vector_image x2 y1 x2 y2 color)
    (vector_image x2 y2 x1 y2 color)
    (vector_image x1 y2 x1 y1 color)
  )
  ;;
  ;; Draw the linetype pattern in a tile.  Boxlength is the length of the image 
  ;; tile, y2 is the midpoint of the height of the image tile, pattern is a 
  ;; list of numbers stp:xsiat define the linetype, and color is the color of the 
  ;; tile.
  ;;
  (defun draw_pattern (boxlength y2 pattern color / x1 x2
                      patlist dash)
    (setq x1 0 x2 0)
    (setq patlist pattern)
    (if (= patlist "CONT")
      (progn (setq dash boxlength)
        (v_i)
        (setq x1 boxlength)
      )
    )
    (while (< x1 boxlength)
      (if (setq dash (car patlist))
        (progn
          (setq dash (fix (* 30 dash)))
          (cond 
            ((= dash 0) (setq dash 1) (v_i))
            ((> dash 0) (v_i))
            (T 
              (if (< (abs dash) 2)
               (setq dash 2)
              )
              (setq x2 (+ x2 (abs dash)))
            )
          )
          (setq patlist (cdr patlist))
          (setq x1 x2)
        )
        (setq patlist pattern)
      )
    )
  )

  (princ ".")

  ;;
  ;; Draw a dash or dot in image tile
  ;;
  (defun v_i ()
    (setq x2 (+ x2 dash))
    (vector_image x1 y2 x2 y2 color)
  )
  ;;
  ;; If an item is a member of the list, then return its index number, else 
  ;; return nil.
  ;;
  (defun get_index (item itemlist / m n)
    (setq n (length itemlist))
    (if (> (setq m (length (member item itemlist))) 0)
      (- n m)
      nil
    )
  )
  ;;
  ;; this function is called if the linetype is set "BYLAYER". It finds the 
  ;; ltype of the layer so it can be displayed  beside the linetype button.
  ;;
  (defun by_layer_lt (/ layname layinfo ltype)
    (cond
      ((= (type lay-idx) 'STR)
        (strcat "BYLAYER (" (getvar "celtype") ")")
      )
      ((not lt-idx)
        "BYLAYER"
      )
      (T
        (if (and lay-idx laynmlst)
          (setq layname (nth lay-idx laynmlst))
          (setq layname (getvar "clayer"))
        )
        (setq layinfo (tblsearch "layer" layname))
        (setq ltype (cdr (assoc 6 layinfo)))
        (strcat "BYLAYER (" ltype ")")
      )
    )
  )

  (defun bylayerLtype (entname / layname layinfo ltype)
    (setq layname (fld_st 8 entname))
    (setq layinfo (tblsearch "layer" layname))
    (setq ltype (cdr (assoc 6 layinfo)))
  )
  ;;
  ;; this function is called if the color is set "BYLAYER".  It finds the color 
  ;; of the layer so it can be displayed beside the color button.
  ;;
  (defun by_layer_col (/ layname layinfo color)
    (cond
      ((= (type lay-idx) 'STR)
        (setq cn (atoi (getvar "cecolor")))
        (strcat "BYLAYER (" (color_name cn) ")")
      )
      ((not lay-idx)
        (setq cn 0)
        "BYLAYER"
      )
      (T
        (if (and lay-idx laynmlst)
          (setq layname (nth lay-idx laynmlst))
          (setq layname (getvar "clayer"))
        )
        (setq layinfo (tblsearch "layer" layname))
        (setq color (abs (cdr (assoc 62 layinfo))))
        (setq cn color)
        (strcat "BYLAYER (" (color_name color) ")")
      )
    )
  )



(defun bylayerColor (entname / layname layinfo color)
    (setq layname (fld_st 8 entname))
    (setq layinfo (tblsearch "layer" layname))
    (setq color (abs (cdr (assoc 62 layinfo))))
)

;;
;; Used to set the color name in layer subdialogue.
;;

(defun color_name (colnum)
    (setq cn (abs colnum))
    (cond     ((= cn 1) "red")
              ((= cn 2) "yellow")
              ((= cn 3) "green")
              ((= cn 4) "cyan")
              ((= cn 5) "blue")
              ((= cn 6) "magenta")
              ((= cn 7) "white")
              (T (itoa cn))
    )
)


(princ ".")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cimcad에 필요한(공통) 사항 Setting한다.
;;

(setup)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(cond
  ((= (strcase co_i) "WHITE")
    (setq co_i "7")
  )
  
  
;  ((= (strcase co_i) "RED")
;    (SETQ CO_I 1)
;  )
;  ((= (strcase co_i) "YELLOW")
;    (SETQ CO_I 2)
;  )
;  ((= (strcase co_i) "CYAN")
;    (SETQ CO_I 4)
;  )
;  ((= (strcase co_i) "GREEN")
;    (SETQ CO_I 3)
;  )
;  ((= (strcase co_i) "BLUE")
;    (SETQ CO_I 5)
;  )
;  ((= (strcase co_i) "MAGENTA")
;    (SETQ CO_I 6)
;  )
;
)



(setq ai_CO1 (getvar "cecolor"))
(setq ai_LA1 (getvar "clayer"))
(setq ai_LT1 (getvar "CELTYPE"))

(if (= ci_f_inf "ON")
    (progn
      (file_init)
      (cim_init)
    )
)
  
(princ ".")



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 아래 부분은 CIMCAD98.LSP을 가져온것이다.(ARX부분은 빼고)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;---------------------------------------------------------------------------
; Individual functions for autocad 2000 core lisp routines (common)
;---------------------------------------------------------------------------

(defun library(sym /)
    (setvar "cmdecho" 0)
    (if (not addlib) (arxload "cimcad14"))
    (addlib sym)
    (command "_rotate" "l" "" "@")
)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; --------------------- CIMCAD14 ERROR HANDLER ----------------------
; Error handler for bonus lisp routines.
; INIT_CIMCAD_ERROR initializes error routine. RESTORE_CIM_OLD_ERROR
; resets environment.
; -------------------------------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;GLOBAL INFO.;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Functions created as result of loading file: cimcad14_rk.lsp
;  CI_RESTORE_SYSVARS       
;  CI_RESTORE_UNDO          
;  CI_SET_SYSVARS           
;  CIMCAD_ERROR             
;  INIT_CIMCAD_ERROR                 
;  RESTORE_CIM_OLD_ERROR             
;
; Variables created as result of loading file: CIMCAD14_rk.lsp
;
; Functions created as a result of executing the commands in: cimcad14_rk.lsp
;
; Variables created as a result of executing the commands in: cimcad14_rk.lsp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;GLOBAL INFO.;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;init_cimcad_error
;This routine initializes the error handler
;It should be called at the top of your lisp routine 
;
;Arguments:
;  init_err Takes a list as an argument. 
;This list can be nil or can contain the following elements:
;(list ("sysvar" value "sysvar" value ...)
;      undo_enable
;      (additional specialized clean up function)
;);list
;  The arguments explained:
;  1. - The first element of the argument list:
;       This is a list of system variables paired with
;       the values you want to set them to. 
;  2. - The second element of the list is a flag
;       If it is true, then in the event of an error 
;       the custom *error* routine will utilize UNDO 
;       as a cleanup mechanism.
;  3. - The third element is a quoted function call.
;       You pass a quoted call to the function you
;       wish to execute if an error occurs. 
;        i.e. '(my_special_stuff arg1 arg2...)
;       Use this arg if you want to do some specialized clean up 
;       things that are not already done by the standard cimcad_error 
;       function.
;        
;The reason a list is provided as the argument is for upward
;compatability. Other arguments can be placed in the list at a later
;time and not affect previous versions.
;


(defun init_cimcad_error ( lst / ss undo_init)
 
      ;;;;;;;local function;;;;;;;;;;;;;;;;;;;;
  
      (defun undo_init ( / undo_ctl)
           (ci_set_sysvars (list "cmdecho" 0))
           (setq undo_ctl (getvar "undoctl")) 
           (if (equal 0 (getvar "UNDOCTL")) ;Make sure undo is fully enabled.
               (command "_.undo" "_all")
           )
           (if (or (not (equal 1 (logand 1 (getvar "UNDOCTL"))))  
               (equal 2 (logand 2 (getvar "UNDOCTL")))
           )
           (command "_.undo" "_control" "_all") 
       )
    
       ;; Ensure undo auto is off
       
       (if (equal 4 (logand 4 (getvar "undoctl")))
        (command "_.undo" "_Auto" "_off")
       )
   
       ;; Place an end mark down if needed.
       
       (if (equal 8 (logand 8 (getvar "undoctl")))
           (progn
            (command "_.undo" "_end")
           )
       )          
       (command "_.undo" "_begin")                 
       (ci_restore_sysvars) 
       
       ;; return original value of undoctl
       
       undo_ctl
      );defun undo_init

    ;;;;;;;;;;;;;begin the work of init_cimcad error;;;;;;;;;;;;;
     (setq ss (ssgetfirst))
     (if (not cimcad_alive)
         (setq cimcad_alive 0)
     )
     (setq cimcad_alive (1+ cimcad_alive))
     
     (if (<= cimcad_alive 0)   
         (progn 
              (setq cimcad_alive 0);undo settings will be restored 
                          ;along with setting *error* back to cimcad_old_error.
                          ;No call to ci_restore_sysvars will be made.
                          ;If it is decided, this thing should do variable clean 
                          ;up also then set cimcad_alive to 1 before calling
                          ;restore_cim_old_error
              (restore_cim_old_error);quietly restore cimcad_old_error and undo status.
              (setq cimcad_alive 1)
         )
     )
     (if (= cimcad_alive 1)
         (progn
              (if (and *error*
                       (or (not (equal 'LIST (type *error*)))
                           (not (equal "cimcad_error" (cadr *error*)))
                       );or 
                  );and 
          (setq cimcad_old_error *error*);save the *error* only if it 
                                        ;looks like the standard one or is some other 
                                        ;user defined one. Don't want to save it if 
                                        ;it's ours because we already have it.
      );if
      (if (cadr lst)
          (setq cimcad_undoctl (undo_init)) 
          (setq cimcad_undoctl nil)
      );if
    );progn then this is a top level call, or in other words, the first time through.
 );if 
 (ci_set_sysvars (car lst))
 (if (= cimcad_alive 1)
     (progn
      (setq *error* cimcad_error);setq
      (if (caddr lst)
          (setq *error* (append (reverse (cdr (reverse *error*))) 
                                (list (caddr lst)
                                      (last *error*) ;'(princ)
                                );list
                        );append
          );setq ;then add additional routine name to the error function.
      );if
     );progn
 );if
 (if (and ss
          (equal 1 (logand 1 (getvar "pickfirst")))
     );and
     (sssetfirst (car ss) (cadr ss))
 );if
);defun init_cimcad_error


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun cimcad_error ( msg / )

"cimcad_error"
;(print "cimcad_error")

(setq cimcad_alive -1)
(print msg)

;;Get out of any active command.
(while (not (equal (getvar "cmdnames") "")) (command nil))

;If undo global variable flag is set then use undo as a cleanup helper.
(if cimcad_undoctl
    (progn
     (setvar "cmdecho" 0)
     ;(print "Doing undo _end")
     ;(print 'undoctl)
     ;(print (getvar "undoctl"))

     (command "_.undo" "_end");the routine that just failed created an undo 
                              ;begin mark, so we need to close it off with 
                              ;and "end" mark.

     ;(print 'undoctl)
     ;(print (getvar "undoctl"))


     (command "_.undo" "1")   ;now back up to the begining.

     ;(print 'undoctl)
     ;(print (getvar "undoctl"))


    );progn
);if

(ci_restore_sysvars)
(ci_restore_undo)

     ;(print 'undoctl)
     ;(print (getvar "undoctl"))



;Restore original error handler
(if cimcad_old_error
    (setq *error* cimcad_old_error)
);if

(setq cimcad_alive 0)

;(princ "\nDone")
(princ)
);defun cimcad_error

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;restore_cim_old_error
;This function should be the last thing called in a lisp 
;defined command. It does a (princ) at the end for a quiet 
;finish.
(defun restore_cim_old_error ( / )

;(print "restore_cim_old_error")

(setq cimcad_alive (- cimcad_alive 1))
(if (>= cimcad_alive 0)
    (ci_restore_sysvars)
    (setq cimcad_varlist nil)
);if
(if (<= cimcad_alive 0)
    (progn
     (ci_restore_undo)
     (if cimcad_old_error
         (setq *error* cimcad_old_error);put the old error routine back.
     );if
    );progn then
);if

(princ)
);defun restore_cim_old_error



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun ci_restore_undo ()

;(print "restore_undo")

(if cimcad_undoctl
    (progn
      (ci_set_sysvars (list "cmdecho" 0))

      (if (not (equal cimcad_undoctl (getvar "undoctl")))
          (progn
           (cond 
            ((equal 0 cimcad_undoctl) 
             (command "_.undo" "_control" "_none")
            )
            ((equal 2 (logand 2 cimcad_undoctl))
             (command "_.undo" "_control" "_one")
            )    
           );;cond 
           (if (equal 4 (logand 4 cimcad_undoctl))
               (command "_.undo" "_auto" "_on") 
           );if 

           (if (equal 8 (logand 8 (getvar "undoctl")))
               (progn
                ;(print "doing undo end in restore_undo") 
                (command "_.undo" "_end")
               );progn
           );if
  
         );progn then restore undoctl to the status the user had it set to. 
      );if
      (if (not (equal 2 (logand 2 (getvar "undoctl"))))
          (ci_restore_sysvars)
      );if
    );progn then restore undo to it's original setting
);if
(setq cimcad_undoctl nil)

);defun ci_restore_undo


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;This has no error checking. You must
;provide a list of even length in the 
;following form
;( "sysvar1" value
;  "sysvar2" value2
;)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ci_set_sysvars (lst / lst2 lst3 a b n)
;;

(defun ci_set_sysvars (lst / lst2 lst3 a b n)

    (setq lst3 (car cimcad_varlist))

    (setq n 0)
    (repeat (/ (length lst) 2)
         (setq     a (strcase (nth n lst))
                   b (nth (+ n 1) lst)
         )
         (setq lst2 (append lst2
        (list (list a (getvar a)))
            );append
         );setq 
         (if (and cimcad_varlist 
          (not (assoc a lst3))
         );and
         (setq lst3 (append lst3 
                   (list (list a (getvar a)))
                );append
         );setq 
         );if

         (setvar a b)

        (setq n (+ n 2));setq
    );repeat
    
    (if cimcad_varlist
        (setq cimcad_varlist     (append (list lst3) 
                                    (cdr cimcad_varlist)
                                    (list lst2) 
                                )
        )
        (setq cimcad_varlist (list lst2))
    )
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ci_restore_sysvars ( / lst n a b)
;;

(defun ci_restore_sysvars ( / lst n a b)

     (if (<= cimcad_alive 0)
         (setq lst (car cimcad_varlist)
               cimcad_varlist (list lst)
         )
         (setq lst (last cimcad_varlist)) 
     )

    (setq n 0)
    
    (repeat (length lst)
        (setq     a (nth n lst)
                   b (cadr a)
                   a (car a)
        )
         (setvar a b)
         (setq n (+ n 1))
     )
     (setq cimcad_varlist (reverse (cdr (reverse cimcad_varlist))))
)

;;; 수정날짜: 2001년 8월 20일
;;; 작업자  : 박율구
;;; 수정내용: CVS변수의 오류 수정
;;소수점 자리수 셋팅 함수.
(defun Myrtos (Myrtos::input Myrtos::len / CVS old_str 0num wheredot)
  (setq 0num Myrtos::len)
;;; 고친부분
  (setq CVS (rtos Myrtos::input 2 Myrtos::len))
  (setq old_str	(rtos Myrtos::input 2))
  (if (= (strlen old_str) (strlen CVS))
    (progn
      (if (setq wheredot (instr CVS "."))
	(setq 0num (- 0num (- (strlen old_str) wheredot)))
	(setq cvs (strcat cvs "."))
      )
      (while (> 0num 0)
	(setq cvs (strcat cvs "0"))
	(setq 0num (1- 0num))
      )
    )
  )
  cvs
)

(defun cim_help(help_category)
    (help (findfile "Cimcad.hlp") help_category)
)

(defun set_dtl:wid (?sty?)
(if (or (= ?sty? "CITBC")
     (= ?sty? "CITGC")
     (= ?sty? "CITDC")
     (= ?sty? "CITLC")
     (= ?sty? "CIHSC")
     (= ?sty? "CIHDC")
     (= ?sty? "CIHTC")
     (= ?sty? "CIHMC")
     )
   (setq dtl:wid 0.8)
   (if (or (= ?sty? "CITBW")
       (= ?sty? "CITGW")
       (= ?sty? "CITDW")
       (= ?sty? "CITLW")
       (= ?sty? "CIHSW")
       (= ?sty? "CIHDW")
       (= ?sty? "CIHTW")
       (= ?sty? "CIHMW")
       )
     (setq dtl:wid 1.2)
     (setq dtl:wid 1.0)
   )

 )
  (princ)
)


;;=============================================================================
;;    Function Name     : read_ai_dim_dat (ai_dim_file_name)
;;
;;     Function         : Variable Value을 읽어온다. (from "ai_dim.dat")
;;    
;;        
;;    In                :             ai_dim_file_name      읽을 File name
;;
;;
;;=============================================================================

;; 변수 초기화 해둔다.

(defun read_ai_dim_dat (ai_dim_file_name / file_name fd bb cc typeX valueX kind)

    (setq file_name (strcat g_searchpath3 (strcat (chr 92) ai_dim_file_name)))
    (setq fd (open file_name "r"))    ; file open (error 혹은 file 이 없는경우 null로 온다
    
    (if fd
        (progn
        
            (setq bb (read-line fd))
        
            (setq true02 T)    ; 위에서 한 Line을 읽은상태이다.
            
            (while true02
                (setq true03 (= (substr bb 1 3) "***"))
                (if true03
                    (progn
                        (setq cc (substr bb 5 (- (strlen bb) 4)))        ;; name
                        (progn
                            (setq bb (read-line fd))            ; 다음 Line 은 ** 칸이 된다.
                            (setq typeX (substr bb 3 (- (strlen bb) 2)))    ;; typeX
                            
                            (setq bb (read-line fd))            ; 다음 Line 은 * 칸이 된다. (일단 지금은 쓰지 않는다.)
                            (setq kind (substr bb 2 (- (strlen bb) 1)))
                            
                            (setq bb (read-line fd))
                            (setq valueX (substr bb 2))            ; "=" 이후 전부 취한다.
                            
                            ;(princ valueX)
                            ;(princ "\n")
                                
                            (if (= typeX "1")                        ; boolean 정수처럼 취급
                                (setvar cc (atoi valueX))
                            )
                            
                            (if (= typeX "2")                        ; 정수
                                (setvar cc (atoi valueX))
                            )
                                
                            (if (= typeX "3")                        ; 실수
                                (setvar cc (atof valueX))
                            )    
                            (if (= typeX "7")                        ; 치수관련 치수스타일 이름과 텍스트 높이
                                (progn
                                    (if (= cc "DIMTXT01")
                                        (setq dimtxt01 valueX)
                                    )    
                                    (if (= cc "DIMTXT02")
                                        (setq dimtxt02 valueX)
                                    )    
                                    (if (= cc "DIMTXT03")
                                        (setq dimtxt03 valueX)
                                    )    
                                    (if (= cc "DIMSTYLENAME01")
                                        (setq dimstylename01 valueX)
                                    )    
                                    (if (= cc "DIMSTYLENAME02")
                                        (setq dimstylename02 valueX)
                                    )    
                                    (if (= cc "DIMSTYLENAME03")
                                        (setq dimstylename03 valueX)
                                    )
                                )
                                ;;(setvar cc (atof valueX))
                                ;;(princ "1111...")
                                
                            )    
                        ); progn
                    );progn
                );if
                
                (setq bb (read-line fd))
                (if (= bb nil)    (setq true02 nil))        ; the end of file
                
            );while
            (close fd)
        ); progn
        
    )    ; if fd
)
(defun read_ai_dim_dat2 (ai_dim_file_name / file_name fd bb cc typeX valueX kind)

    (setq file_name (strcat g_searchpath3 (strcat (chr 92) ai_dim_file_name)))
    (setq fd (open file_name "r"))    ; file open (error 혹은 file 이 없는경우 null로 온다
    
    (if fd
        (progn
        
            (setq bb (read-line fd))
        
            (setq true02 T)    ; 위에서 한 Line을 읽은상태이다.
            
            (while true02
                (setq true03 (= (substr bb 1 3) "***"))
                (if true03
                    (progn
                        (setq cc (substr bb 5 (- (strlen bb) 4)))        ;; name
                        (progn
                            (setq bb (read-line fd))            ; 다음 Line 은 ** 칸이 된다.
                            (setq typeX (substr bb 3 (- (strlen bb) 2)))    ;; typeX
                            
                            (setq bb (read-line fd))            ; 다음 Line 은 * 칸이 된다. (일단 지금은 쓰지 않는다.)
                            (setq kind (substr bb 2 (- (strlen bb) 1)))
                            
                            (setq bb (read-line fd))
                            (setq valueX (substr bb 2))            ; "=" 이후 전부 취한다.
                            
                            ;(princ valueX)
                            ;(princ "\n")
                                
                            (if (= typeX "1")                        ; boolean 정수처럼 취급
                                (setvar cc (atoi valueX))
                            )
                            
                            (if (= typeX "2")                        ; 정수
                                (setvar cc (atoi valueX))
                            )
                                
                            (if (= typeX "3")                        ; 실수
                                (setvar cc (atof valueX))
                            )    
                            (if (= typeX "7")                        ; 치수관련 치수스타일 이름과 텍스트 높이
                                (progn
                                    ;(if (= cc "DIMTXT01")
                                    ;    (setq dimtxt01 valueX)
                                    ;)    
                                    ;(if (= cc "DIMTXT02")
                                    ;    (setq dimtxt02 valueX)
                                    ;)    
                                    ;(if (= cc "DIMTXT03")
                                    ;    (setq dimtxt03 valueX)
                                    ;)    
                                    (if (= cc "DIMSTYLENAME01")
                                        (setq dimstylename01 valueX)
                                    )    
                                    (if (= cc "DIMSTYLENAME02")
                                        (setq dimstylename02 valueX)
                                    )    
                                    (if (= cc "DIMSTYLENAME03")
                                        (setq dimstylename03 valueX)
                                    )
                                )
                                ;;(setvar cc (atof valueX))
                                ;;(princ "1111...")
                                
                            )    
                        ); progn
                    );progn
                );if
                
                (setq bb (read-line fd))
                (if (= bb nil)    (setq true02 nil))        ; the end of file
                
            );while
            (close fd)
        ); progn
        
    )    ; if fd
)


;; =========================================================================================
;; 추가날짜: 2000.6.23
;; 작업자: 박율구
;; 함수명: ai_dim()

(defun ai_dim ()

    (read_ai_dim_dat2 "ai_dim.dat"); dimstylename01, 02, 03을 얻어옴!
    
    ;; 치수 스타일 정의
    (if (not (dimsearch dimstylename03))            ;; user style
        (progn
          ;; 치수 관련 변수 Setting
              (read_ai_dim_dat "ai_dim.dat")
              ;; block and 기본 style 
              (setvar "DRAGMODE" 2)
                  (setvar "FILLETRAD" 0)
                  (setvar "LUNITS" 2)
                  (setvar "LUPREC" 2)
                  (setvar "MIRRTEXT" 0)
                  (setvar "PICKBOX" 3)
                  (setvar "APERTURE" 6)
                  (setvar "TEXTSIZE" (* 3 (getvar "LTSCALE")))
                  (setvar "COORDS" 2)
                  (setvar "cmdecho" 0)
                  (command "-insert" "dotk" (getvar "viewctr") "" "" "")
                  (entdel (entlast))
                  (command "dimblk" "dotk")
        
              (if (not (stysearch "SIM"))
                (styleset "SIM")       ;; 기본 치수문자유형 설정  (고정)
              )
                  (setvar "DIMTXSTY" "SIM")
          
            (setvar "cmdecho" 1)
            (princ (strcat "\n치수스타일 " dimstylename03 "이 올려짐"))
            (setvar "cmdecho" 0)
            (setvar "DIMTXT" (atof dimtxt03))       ;; 치수글자의 크기            (권장값 : 2)
            (command "dim1" "_save" dimstylename03)
        )  
    )      

    (if (not (dimsearch dimstylename01))
        (progn
          ;; 치수 관련 변수 Setting
              (read_ai_dim_dat "ai_dim.dat")
              ;; block and 기본 style 
              (setvar "DRAGMODE" 2)
                  (setvar "FILLETRAD" 0)
                  (setvar "LUNITS" 2)
                  (setvar "LUPREC" 2)
                  (setvar "MIRRTEXT" 0)
                  (setvar "PICKBOX" 3)
                  (setvar "APERTURE" 6)
                  (setvar "TEXTSIZE" (* 3 (getvar "LTSCALE")))
                  (setvar "COORDS" 2)
                  (setvar "cmdecho" 0)
                  (command "-insert" "dotk" (getvar "viewctr") "" "" "")
                  (entdel (entlast))
                  (command "dimblk" "dotk")
        
              (if (not (stysearch "SIM"))
                (styleset "SIM")       ;; 기본 치수문자유형 설정  (고정)
              )
                  (setvar "DIMTXSTY" "SIM")
          
            (setvar "cmdecho" 1)
            (princ (strcat "\n치수스타일 " dimstylename01 "이 올려짐"))
            (setvar "cmdecho" 0)
            (setvar "DIMTXT" (atof dimtxt01))       ;; 치수글자의 크기            (권장값 : 2)
            (command "dim1" "_save" dimstylename01)
        )  
    )      
    
    (if (not (dimsearch dimstylename02))
        (progn
          ;; 치수 관련 변수 Setting
              (read_ai_dim_dat "ai_dim.dat")
              ;; block and 기본 style 
              (setvar "DRAGMODE" 2)
                  (setvar "FILLETRAD" 0)
                  (setvar "LUNITS" 2)
                  (setvar "LUPREC" 2)
                  (setvar "MIRRTEXT" 0)
                  (setvar "PICKBOX" 3)
                  (setvar "APERTURE" 6)
                  (setvar "TEXTSIZE" (* 3 (getvar "LTSCALE")))
                  (setvar "COORDS" 2)
                  (setvar "cmdecho" 0)
                  (command "-insert" "dotk" (getvar "viewctr") "" "" "")
                  (entdel (entlast))
                  (command "dimblk" "dotk")
        
              (if (not (stysearch "SIM"))
                (styleset "SIM")       ;; 기본 치수문자유형 설정  (고정)
              )
                  (setvar "DIMTXSTY" "SIM")
          
            (setvar "cmdecho" 1)
            (princ (strcat "\n치수스타일 " dimstylename02 "이 올려짐"))
            (setvar "cmdecho" 0)
            (setvar "DIMTXT" (atof dimtxt02))       ;; 치수글자의 크기            (권장값 : 2)
            (command "dim1" "_save" dimstylename02)
        )  
    )      

    (command "_.dimstyle" "r" (getvar "dimstyle")); "유형재지정"이라는 메시지 삭제시켜줌  
    (setvar "cmdecho" 1)
    ;;================================================================================
    ;;치수환경 설정 끝
    ;;================================================================================
    
    (princ)
)


(princ ".")


;;파일 및 스트링 핸들링 함수..서동석
;파일 읽을때 (readF "file_name") - (Field_match "필드명" row)
;Row 지우기 (rowdel row what_List) row:0,1,2....


(defun writeF (@myfilename FLAG / filename fd len1 len2 n TTMPP)
   
  (setq filename
     (if (instr @myfilename "\\")
       @myfilename
     (strcat g_searchpath3 (strcat "/" @myfilename)))
  )
  (setq fd (open filename "w"))
  (if (null fd) (alert (strcat filename "파일을 열 수 없습니다.")))
  (setq len1 (length (if (= flag "prop") @Prop_field @Type_field)))
  (setq n 0)
  (repeat len1
    (princ (strcat (nth n (if (= flag "prop") @Prop_field @Type_field)) (chr 59)) fd)
    (setq n (1+ n))
  )
  (princ "\n" fd)
  (setq len2 (length (if (= flag "prop") @Prop @Type)))
  (setq ii 0)
  (repeat len2
          (setq TTMPP (cdr (nth ii (if (= flag "prop") @Prop @Type))))
      (setq n 0)
      (if (= flag T)
    (princ TTMPP fd)
        (repeat (length TTMPP)
        (princ (strcat (nth n TTMPP) (chr 59)) fd)
        (setq n (1+ n))
    )
      )
    (setq ii (1+ ii))
    (princ "\n" fd)
  )
  (close fd)
)
 ;;파일명으로 파일을 읽어서 리스트로 저장..

(defun readF (@myfilename flag / filename fd ttmp n)
  
  (setq filename
     (if (instr @myfilename "\\")
       @myfilename
       (strcat g_searchpath3 (strcat "/" @myfilename)))
  )
  (setq fd (open filename "r"))
  (if (null fd) (alert (strcat filename "파일을 열 수 없습니다.")))
  (if (= flag "prop") (setq @Prop nil) (setq @Type nil))
  (setq o_o (read-line fd))
  (if (= flag "prop") (setq  @Prop_field (split o_o (chr 59))) (setq  @TYPE_field (split o_o (chr 59))) ) 
 
  (setq n 1)
  (while (setq o_o (read-line fd))
        (cond
      ((= flag nil) (setq @Type (cons (cons n (split o_o (chr 59))) @Type)))
          ((= flag T) (setq @Type (cons (cons n o_o) @Type)))
      ((= flag "prop") (setq @Prop (cons (cons n (split o_o (chr 59))) @Prop)))
        )
        (setq n (1+ n))
  )
  (if (= flag "prop")
  (setq @Prop (reverse @Prop))
  (setq @Type (reverse @Type)))
  (close fd)  
)

;; 찾고자 하는 필드명과 row로 데이타를 찾음
(defun Field_match (search_field search_row / idx tmp)
  (setq idx (get_index search_field @Type_field))
  (if (= idx nill) (exit))
  (if (= (setq tmp (nth search_row @Type)) nil) (exit))
  (nth idx (cdr tmp))
)

(defun Prop_search (prop_type content / tmplist n len Found)
  (if (null @@prop)
    (progn (readF "PropType.dat" "prop")
           (setq @@prop @Prop)
    )
  )
  (setq len (length @@prop) 
        n 0)
  (while (and (= Found nil) (< n len))
    (setq tmplist (cdr (nth n @@prop)))
     (if (and (= (nth 0 tmplist) prop_type) (= (nth 1 tmplist) content))
       (setq Found T))
    (setq n (1+ n)))
  
  (if Found (prop_layer_setting tmplist) 
    nil)
)

(defun Prop_Save ( CH_list_name /  tmplist n mm len Found changlist)
 (setq mm 0
       len (length @@Prop)
 )
 (repeat (length CH_list_name)
  (setq changlist (eval (nth mm CH_list_name)))
  (setq n 0 Found nil)
  (while (and (= Found nil) (< n len))
    (setq tmplist (nth n @@Prop))
     (if (and (= (nth 0 (cdr tmplist)) (nth 0 changlist))
          (= (nth 1 (cdr tmplist)) (nth 1 changlist)))
       (setq Found T))
    (setq n (1+ n)))
  
  (if Found (setq @@Prop (subst (cons n changlist) tmplist @@Prop)))
  (setq mm (1+ mm))
 )
 (setq @prop @@prop)
 (WriteF "PropType.dat" "prop")
)

(defun prop_layer_setting (proplist /  cecol layer1 tcol1 tcol2 line1 line2 r_mode echo_mode)
  
  (setq r_mode (getvar "regenmode"))
  (setq echo_mode (getvar "cmdecho"))
  (setvar "regenmode" 0)
  (setvar "cmdecho" 0)
  (setq layer1 (nth 2 proplist)
    tcol1 (propcolor proplist)
    tcol2 (atoi (nth 7 proplist))
        line1 (nth 4 proplist)
    line2 (nth 8 proplist)
  )
  ;layer setting;;;;;
  (if (setq cecol (lacolor layer1))        ; if layer existed?
    (progn
      (if (= (nth 5 proplist) "1")
        (setq proplist (set_property proplist 3 (itoa cecol)))    ;??? Set DB's Defined layer color to drawing color's layer color
      )
      (if (= (nth 6 proplist) "1")
          (setq proplist (set_property proplist 4 (laltype layer1)))
      )
    )
    (progn
       (setlay layer1)
              (command "_.layer" "_C" tcol2 "" "")
              (if (= (nth 5 proplist) "1")
                  (setq proplist (set_property proplist 3 (nth 7 proplist)))
          )
        (command "_.layer" "_LT" line2 "" "")
              (if (= (nth 6 proplist) "1")
          (setq proplist (set_property proplist 4 (nth 8 proplist)))
              )
       (RTNLAY)

    )
   )
 (setvar "regenmode" r_mode)
 (setvar "cmdecho" echo_mode)
   proplist
)

(defun propcolor (proplist)
  (atoi (nth 3 proplist))
 )

(defun set_property (proplist propnum setstring /  tmplist n len)
   (setq len (length proplist)
         n 0 )
   (while (< n len)
     (setq tmplist (cons (if (= n propnum) setstring (nth n proplist)) tmplist)
       n (1+ n))
   )
   (reverse tmplist)
)

(defun strconvT (strA findS chgS / t1 len treturn n) ;;string change
 (setq t1 (split strA findS))
 (setq len (length t1))
 (setq n 0)
 (setq treturn "")
 (while (> len n)
   (setq treturn (strcat treturn (strcat (nth n t1) chgS)))
   (setq  n (1+ n))
 )
    treturn
)
(princ ".")
;;split 함수.
(defun split (String1 match1 / outlist tmp! len tmpnum mylist)
  (setq len (strlen string1))

  (while (> len 0)
    (setq tmpnum (instr string1 match1))
    (if (= tmpnum nil)
      (progn
      (setq mylist (cons string1 mylist )) (setq string1 ""))
      (progn
      (setq mylist (cons (substr string1 1 (- tmpnum 1)) mylist))
      (setq string1 (substr string1 (+ tmpnum 1)))) 
    )
     
    (setq len (strlen string1))
  )
  (setq mylist (reverse mylist))
)

(defun rowdel (rowN what_List / tmplist len n)
 (setq len (length what_List))
 (setq n 0)
 (if (< rowN len)
  (progn
     (while (> len n)
       (if (/= n rowN)
        (setq tmplist (cons (nth n what_List) tmplist))
        ) 
       (setq n (1+ n))
     )
      (setq what_List (reverse tmplist))
   )
 )
  
)

(defun List2Tab (list1 / len treturn nn)
 (setq len (length list1))
 (setq nn 0)
 (setq treturn "")
 (while (> len nn)
   (setq  treturn (strcat treturn (strcat (nth nn list1) "\t")))
   (setq  nn (1+ nn))
 )
    treturn
)

(defun ci_image (key slb / image_x image_y)
    (do_blank key 0)
    (start_image key)
    (slide_image
      0 0
      (- (setq image_x (dimx_tile key)) 1)
      (- (setq image_y (dimy_tile key)) 1)
      slb
    )
    (end_image)
)
;;256(bylayer)를 현재 레이어색상 값으로 돌려줌
  (defun 256toCnum (!layname / layinfo color)
        (setq layinfo (tblsearch "layer" !layname))
        (setq color (abs (cdr (assoc 62 layinfo))))
  )


(defun Find_index ( tmpstr / found1 len n)
 (setq len (length @type))
 (setq n 0)
  (while (and (= found1 nil) (> len n))
   (setq found1 (get_index tmpstr (cdr (nth n @type))))
   (setq n (1+ n))
  )
    (1- n)
)

(defun list_view (/ n len )
 
      (start_list "list_type")
      (setq len (length @Type))      
      (setq n 0)
      (while (> len n)
        (add_list (List2Tab (cdr (nth n @Type))) )
        (setq n (1+ n))
      )
      (end_list)
 
)
(defun list_view2 (/ n len )

      (start_list "list_text")
      (setq len (length @Type))      
      (setq n 0)
      (while (> len n)    
        (add_list (cdr (nth n @Type)) ) 
        (setq n (1+ n))
      )
      (end_list)
)
(defun pop_set(pop_txt_style / tmplist n)
  (if (not stnmlst)
    (make_stlists)
  )
  (setq n (length stnmlst))
 (while (> n 0)
   (setq n (1- n))
   (setq tmplist (append (list (strcat (nth n stnmlst) " [" (nth n fontlst) "]") ) tmplist))
   
 )
    (start_list pop_txt_style)
    (mapcar 'add_list tmplist ) 
        (end_list)
)

(defun eb_delete_F(/ n len)
 
 (if (and (>= L_index 0) (/= (get_tile "list_text") ""))
  (progn  
  (setq @Type (rowdel L_index @Type))
  (if (>= L_index (length @type)) (setq L_index (1- L_index)))
  (list_view2)
  (set_tile "list_text" (itoa L_index))
  )))
  
(defun eb_add_F(/ n tmplist)
  (setq n (1+ (length @type)))
  (setq tmplist (get_tile "ed_text"))
  (if (and (/= tmplist nil) (/= tmplist ""))
  (setq @Type (append @type (list (cons n tmplist)))))    
  (list_view2)
)
  
(defun DoubleClick? (index / splitchar)
 (setq L_index (atoi index))
 (if (= index preindex)
   (progn
     (if (= (get_tile "ed_text") "") (setq splitchar "") (setq splitchar (strcat (chr 59) "-")))
     (set_tile "ed_text" (strcat  (get_tile "ed_text") splitchar (cdr (nth (atoi index) @Type))))
              
     (setq preindex nil)
     )
   (setq preindex index) 
 )
)
(princ ".")  
(defun renameIdx (What_type / tname temp_o temp_n)
 ;subst
  (setq tname (get_tile "ed_type_name"))
  (if (= L_index  nil)
    (alert "항목을 선택하시기 바랍니다. ")
  (if (member tname (cdr (nth L_index @Type)))
    (alert "타입명이 이미 존재합니다. ")
    (progn
      (setq temp_o (nth L_index @Type))
      (setq temp_n (cons (car temp_o) (subst tname (nth 0 (cdr temp_o)) (cdr temp_o))))
      (setq @Type (subst temp_n temp_o @Type))
      (set What_type tname)

      (list_view)
    ))
    )
)
(defun newIdx (What_type / tmplist tname n_n temp_o)
 
 (setq tname (get_tile "ed_type_name"))
 (if (= L_index  nil) (setq L_index (length @type)))
 (if (member tname (cdr (nth L_index @Type)))
    (alert "타입명이 이미 존재합니다. ")
    (progn
     
        (setq temp_o (nth L_index @Type))
        (setq n_n (1+ (length @type)))
    (setq tmplist (subst tname (nth 0 (cdr temp_o)) (cdr temp_o)) )
    (setq @Type (append @type (list (cons N_n tmplist))))
        (setq L_index (1- n_n))
        (set What_type tname)

        (list_view)
    ))
  
)
(defun deleteIdx(What_type /)
   (if (/= (length @Type) 1)
     (progn
      (setq @Type (rowdel L_index @Type))(list_view)
      (if (>= L_index (length @type)) (setq L_index (1- L_index)))
      (set What_type (nth 0 (cdr (nth L_index @Type))))

     )
      (alert "최소 1개 이상 타입이 필요합니다. 삭제할 수 없습니다.")
   )
)
(defun wall_select_rect (pt factor / p1 p2 dis tmp_angle) ;p3 p4
  (if (not (null pt))
    (progn
      (setq dis (* factor 2))
      (setq p1  (polar pt (* pi 0.25) dis)
            p2  (polar pt (* pi 1.25) dis)
      )
      
      (ssget "C" p1 p2 )
    )
  )
)
      
(defun wall_point (/ tmpall tmpent factor  tttpt finish_lay)
  (setq finish_lay (nth 2 (Prop_search "wall" "finish")))
  (setq factor (/ (distance strtpt pt3) 8))
  (setq tmpall (wall_select_rect strtpt factor))
  (if (and (not (null tmpall)) (> (sslength tmpall) 1))
    (progn
      (setq tmpent (entget (ssname (ssget "P"
                       (append '((-4 . "<AND") (-4 . "<NOT")) (list (cons 8 finish_lay))
                           '((-4 . "NOT>")(-4 . "<NOT")(8 . "CEN*")(-4 . "NOT>")
                             (-4 . "<NOT") (8 . "0") (-4 . "NOT>")(-4 . "AND>"))
                       )
                   ) 0)))
      (setq strtpt (perpoint strtpt tmpent))
    ))
  (setq tmpall (wall_select_rect nextpt factor))
  (if (and (not (null tmpall)) (> (sslength tmpall) 1))
    (progn
      (setq tmpent (entget (ssname (ssget "P"
                       (append '((-4 . "<AND") (-4 . "<NOT")) (list (cons 8 finish_lay))
                           '((-4 . "NOT>")(-4 . "<NOT")(8 . "CEN*")(-4 . "NOT>")
                             (-4 . "<NOT") (8 . "0") (-4 . "NOT>")(-4 . "AND>"))
                       )
                   ) 0)))
      (setq nextpt (perpoint nextpt tmpent))
    )
  )

    (setq tmpall (wall_select_rect pt3 factor))
      (if (and (not (null tmpall)) (> (sslength tmpall) 1))
        (progn
          (setq tmpent (entget (ssname (ssget "P"
                       (append '((-4 . "<AND") (-4 . "<NOT")) (list (cons 8 finish_lay))
                           '((-4 . "NOT>")(-4 . "<NOT")(8 . "CEN*")(-4 . "NOT>")
                             (-4 . "<NOT") (8 . "0") (-4 . "NOT>")(-4 . "AND>"))
                       )
                   ) 0)))
          (setq pt3 (perpoint pt3 tmpent))
        ))
  
 )
(defun perpoint (pp0 entity / stpt edpt  delta cta tmppoint)
  (setq stpt (cdr (assoc 10 entity))
    edpt (cdr (assoc 11 entity))
    delta (angle stpt edpt)
    cta (angle stpt pp0)
    len (distance stpt pp0) 
    )
  (setq tmppoint (polar stpt delta (* len (abs (cos (- delta cta))))))
  
  ;;(command "_line" pp0 tmppoint "")
)
(defun drawImage_box (tmpXp tmpYp tmpXd tmpYd tmpCol / x1 x2 y1 y2)
 (setq x1 tmpxp x2 (+ tmpxp tmpxd)
       y1 tmpyp  y2 (+ tmpyp tmpyd)
 )
 (vector_image x1 y1 x2 y1 tmpcol)
 (vector_image x2 y1 x2 y2 tmpcol)
 (vector_image x2 y2 x1 y2 tmpcol)
 (vector_image x1 y2 x1 y1 tmpcol)

)

(defun MYget_ltype (/ old-idx)
    (if (not ltnmlst)
      (make_ltlists)          ; linetype lists - ltnmlst, mdashlist
    )
    (setq lt-idx (get_index (get_tile "t_ltype") ltnmlst))
     (if (null lt-idx) (setq lt-idx (get_index (substr (get_tile "t_ltype") 1 7) ltnmlst)))
    (if (= (get_tile "error") "")
     (progn
      (if (not (new_dialog "setltype" dcl_id)) (exit))
      (start_list "list_lt")
      (mapcar 'add_list ltnmlst)  ; initialize list box
      (end_list)
      (setq old-idx lt-idx)
      (lt_list_act (itoa lt-idx))

      (action_tile "list_lt" "(lt_list_act $value)")
      (action_tile "edit_lt" "(lt_edit_act $value)")
      (action_tile "accept" "(litest_ok)")
      (action_tile "cancel" "(done_dialog 0)")

      (if (= (start_dialog) 1) ; User pressed OK
        (cond 
          ((= lt-idx 0)
            (set_tile "t_ltype" (by_layer_lt))
            "BYLAYER"
          )
          ((= lt-idx 1)
            (set_tile "t_ltype" "BYBLOCK")
            "BYBLOCK"
          )
          (T  (set_tile "t_ltype" ltname) ltname)
        )
        eltype
      )
     )
     eltype
    )
)
 (defun MYgetlayer (flag / old-idx layname on off frozth linetype)
    (if (/= flag nil) (setq dcl_id (load_dialog "setprop.dcl")))
        
    (make_laylists)                   ; layer list - laynmlst
    (setq lay-idx (get_index (if (/= flag nil) flag (get_tile "t_layer")) laynmlst))
    (if (/= lay-idx nil) (progn
    (if (or (= (get_tile "error") "") (null (get_tile "error") ))
     (progn
      (if (not (new_dialog "setlayer" dcl_id)) (exit))
      (set_tile "cur_layer" (getvar "clayer"))
      (start_list "list_lay")
      (mapcar 'add_list longlist)  ; initialize list box
      (end_list)
      (setq old-idx lay-idx)
      (lay_list_act (itoa lay-idx))
      (action_tile "list_lay" "(lay_list_act $value)")
      (action_tile "edit_lay" "(lay_edit_act $value)")
      (action_tile "accept" "(latest_ok)")
      (action_tile "cancel" "(done_dialog 0)")
      (if (= (start_dialog) 1) ; User pressed OK
    layname)
    ))))
  )
 (defun MYgetcolor (precolor / ecol tmp_col)
    (setq ecol
        (if (= (type precolor) 'STR) (get_num (strcase precolor)) precolor)
    )
    (if (numberp (setq ecol (acad_colordlg ecol nil)))
    (progn

        (if (and (/= ecol 256) (/= ecol 0))
            (command "_.layer" "_C" ecol "" "")
        )
            ecol
    )precolor)
 )
 (defun latest_ok ()
    (if (= (get_tile "error") "")
      (done_dialog 1))
  )
 (defun litest_ok ()
    (if (= (get_tile "error") "")
      (done_dialog 1))
  )

 
(princ ".")

;;; 수정날짜: 2001년 8월 20일
;;; 작업자  : 김병전
;;; 수정내용: command->layer반복으로 인한 오류를 시스템변수 CLAYER를 이용해서 수정 
(defun set_col_lin_lay ( Tproplist / tcol tlin )

  ;; Layer Change 
  
  (if (= (tblsearch "Layer" (nth 2 Tproplist)) nil)
    (progn
      (command "_.Layer" "_M" (nth 2 Tproplist) "")
    )
    (progn

      (if (/= (getvar "CLayer") (nth 2 Tproplist))
        (progn
          (setvar "CLayer" (nth 2 Tproplist))
      ))  ;;  pr . if 
      
  ))  ;;  pr . if 

  ;; Color Change 

  (if (= (nth 5 Tproplist) "1")

    (if (/= (getvar "cecolor") "BYLAYER")
      (command "_.color" "BYLAYER")
    )
    (command "_.color" (propcolor Tproplist))

  )

  ;; LineType Change 

  (if (= (nth 6 Tproplist) "1")

    (if (/= (strcase (getvar "celtype")) "BYLAYER")
      (command "_.linetype" "_S" "BYLAYER" "")
    )
    (command "_.linetype" "_S" (nth 4 Tproplist) "")
  )
    
)


(defun make_stlists (/ fname aa bb cc n1)
  (setq stnmlst nil
        slblist nil
        fontlst nil
    widlst nil
  )
  (if (not (setq fname (findfile "CIM.FON")))
    (progn
      (princ "\n>>> CIM.FON not found. ")
      (exit)
    )
  )
  (setq aa (open fname "r"))
  (while (setq bb (read-line aa))
    (setq n1 (instr bb "(")
          n2 (instr bb ",")
          n3 (instr bb ")")
    )
    (setq stnmlst (cons (strcase (substr bb (1+ n1) (- n2 n1 1))) stnmlst)
          slblist (cons (strcat (if (= (substr bb 2 (- n2 2)) "acad(sim")
                                  "acad(romans"
                                  (substr bb 2 (- n2 2))
                                ) ")") slblist)
          fontlst (cons (substr bb (1+ n2) (- n3 n2 1)) fontlst)
      widlst (cons (substr bb (+ n3 2)) widlst)
     )
  )
  (close aa)
  (setq stnmlst (reverse stnmlst)
        slblist (reverse slblist)
        fontlst (reverse fontlst)
    widlst (reverse widlst)
  )
)
(defun messagebox ( msg_str msg_str2 / dcl_id)
 (setq dcl_id (load_dialog "dlist.dcl"))
 (if (not (new_dialog "messagebox" dcl_id)) (exit))
  (set_tile "tx_message" msg_str)
  (set_tile "tx_message2" msg_str2)
  (action_tile "accept" "(done_dialog 1)")
  (action_tile "cancel" "(done_dialog 0)")
  (if (= (start_dialog) 1) ; User pressed OK
    T nil)

)

(defun fix_90_ang(o_ang T_ang / D_ang) ; return pi/2 or -pi/2
  (setq D_ang (- T_ang o_ang))
  (if (> D_ang 0)
    (if (> D_ang pi)
        (* (/ pi 2) -1)
        (/ pi 2)
    )
    (if (< D_ang (* pi -1))
        (/ pi 2)
        (* (/ pi 2) -1)
    )
  )
)

;;property function

(defun @bylayer_do (flag / preflag)
   (if flag
     (progn
        (setq @eval_prop (set @prop_title (set_property @eval_prop 5 (get_tile "c_bylayer"))))
        (if (= (nth 5 @eval_prop) "1")
      (setq @eval_prop (set @prop_title (set_property @eval_prop 3 (itoa (lacolor (nth 2 @eval_prop))))))
    )
      )
     (progn
        (setq @eval_prop (set @prop_title (set_property @eval_prop 6 (get_tile "t_bylayer"))))
        (if (= (nth 6 @eval_prop) "1")
      (setq @eval_prop (set @prop_title (set_property @eval_prop 4 (laltype (nth 2 @eval_prop)))))
    )
     )
   )
  (@prop_radio_do)
 )

  (defun @prop_radio_do (/ tmpcol)
    (set_tile "c_bylayer" (nth 5 @eval_prop))
    (set_tile "t_bylayer" (nth 6 @eval_prop))
    (set_color (propcolor @eval_prop) "t_color" "color_image")
    
    (set_tile "t_layer" (nth 2 @eval_prop))
    (set_tile "t_ltype" (strcase (nth 4 @eval_prop)))
    (if (= (get_tile "c_bylayer") "1")
      (set_tile "t_color" (strcat "BYLAYER (" (get_tile "t_color") ")" ))
    )

)
  
(defun @getlin(/ tmplin)
    (if (setq tmplin (MYget_ltype))
     (progn
        (if (/= (strcase tmplin) (strcase (nth 4 @eval_prop)))
         (progn
        (if (= tmplin "BYLAYER")
             (progn
                 (setq tmplin (laltype (nth 2 @eval_prop)))
                 (setq @eval_prop (set @prop_title (set_property @eval_prop 6 "1")))
             )
             (setq @eval_prop (set @prop_title (set_property @eval_prop 6 "0")))
        )
            (setq @eval_prop (set @prop_title (set_property @eval_prop 4 tmplin)))
            (@prop_radio_do)
          )
     )
      )
     )
  )
 
(defun @getlayer (/ tmplla)
    (if (setq tmplla (MYgetlayer nil))
        (progn
            (if (/= tmpla (nth 2 @eval_prop))
                (progn
                    (setq @eval_prop (set @prop_title (set_property @eval_prop 2 tmplla)))
                    (setq @eval_prop (set @prop_title (set_property @eval_prop 3 (itoa (lacolor tmplla)))))
                    (setq @eval_prop (set @prop_title (set_property @eval_prop 4 (laltype tmplla))))
                    (setq @eval_prop (set @prop_title (set_property @eval_prop 5 "1" )))
                    (setq @eval_prop (set @prop_title (set_property @eval_prop 6 "1" )))
                    (@prop_radio_do)
                )
            )
        )
    )
)
 
(defun @get_eval_prop (?prop ?all_prop / n1 tmp_str found tmpco tmpli)
    (setq  tmp_str (substr ?prop 4))
    (setq prop_len (length ?all_prop) n1 0 found T)
    
    (while (and found (< n1 (length ?all_prop)))
        ;;(princ "\n\t x005....\n")
        ;;(princ (eval (nth n1 ?all_prop)))
        ;;(princ "\n\t x006....\n")

        (if (= tmp_str (nth 1 (eval (nth n1 ?all_prop))))
            (progn
                ;;(princ "\n\t x007....\n")
                (setq found nil)
                (setq n1 (1- n1))
            )
        )
        (setq n1 (1+ n1))
    )

    ;;(princ "\n\t x008....\n")

    (if (>= n1 prop_len)
        (progn 
            (alert (strcat "Archi_Free Error code 001 \n 타입명" tmp_str "을 찾을 수 없습니다.")) 
            (exit)
        )
    )

    (setq @prop_title (nth n1 ?all_prop) @eval_prop (eval (nth n1 ?all_prop))) 

    (if (and (/= (setq tmpco (itoa (lacolor (nth 2 @eval_prop)))) (nth 3 @eval_prop))
        (= (nth 5 @eval_prop) "1"))
        (setq @eval_prop (set @prop_title (set_property @eval_prop 3 tmpco)))
    )

    (if (and (/= (setq tmpli (strcase (laltype (nth 2 @eval_prop)))) (strcase (nth 4 @eval_prop)))
         (= (nth 6 @eval_prop) "1"))
        (setq @eval_prop (set @prop_title (set_property @eval_prop 4 tmpco)))
    )
    
    (@prop_radio_do)
)

               
(defun @getcolor (/ tmpcol ecol )
    
    (setq ecol (atoi (nth 3 @eval_prop)))

    (if (setq tmpcol (acad_colordlg ecol nil))
        (progn    
            (if (not (null tmpcol))
                (progn
                    (setq @eval_prop (set @prop_title (set_property @eval_prop 5 "0")))
                    (setq @eval_prop (set @prop_title (set_property @eval_prop 3 (itoa tmpcol))))
                )
            )
            (@prop_radio_do)
        )
    )
)

(defun @verify_d(tile value old-value flag / coord valid errmsg ci_coord)
    (setq valid nil errmsg "Invalid input value.")
    (if (setq coord (distof value))
      (progn
    (cond ((= flag 1)
            (if (> coord 0)
                   (setq valid T)
                   (setq errmsg "Value must be positive or non zero.")
            )
          )
          ((= flag 2)
            (if (>= coord 0)
                   (setq valid T)
                   (setq errmsg "Value must be positive or zero.")
            )
          )
    )
      )
    )

    (if valid
      (progn 
        (set_tile "error" "")
         coord
      )
      (progn
        (mode_tile tile 2)
        (set_tile "error" errmsg)
      )
    )
)

;;;;;;;;;;;;;;;;;;;;;;;;;One_key_Setting;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq lfn01 0 lfn02 0 lfn03 0 lfn04 0 lfn05 0
      lfn06 0 lfn07 0 lfn08 0 lfn09 0 lfn10 0
      lfn11 0 lfn12 0 lfn13 0 lfn14 0 lfn15 0
      lfn16 0 lfn17 0 lfn18 0 lfn19 0 lfn20 0
      lfn21 0 lfn22 0 lfn23 0 lfn24 0 lfn25 0
      lfn26 0 lfn27 0 lfn28 0 lfn29 0 lfn30 0
      lfn31 0 lfn32 0 lfn33 0 lfn34 0 lfn35 0
      lfn36 0 lfn37 0 lfn38 0 lfn39 0 lfn40 0
      lfn41 0 lfn42 0 lfn43 0 lfn44 0 lfn45 0
      lfn46 0 lfn47 0
)

;;; Last

(princ "\n\t Core Loading Completed...\n")
(princ)

