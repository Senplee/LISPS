
(setq lfn41 1)  
;;; Main function
;;;
(defun DLG_clt (/ e x a_a @win n)
  (setq @win "~")
  (while (= "~" @win)
    (if (= 1 (setq f$$ (getfiled
          "읽어들일 화일을 선택하십시오." (strcat g_searchpath2 "\\") "col" 4)))
      (progn
        (setq @win (getstring
          (strcat "\n>>>기둥일람표 화일이름: ")))
        (if (and (/= @win "~") (/= @win ""))
          (setq cdwg @win)
        )
        (if (/= @win "~") (setq @win cdwg))
      )
      (progn
        (setq @win f$$)
        (setq cdwg (substr f$$ 1 (1- (instr f$$ "."))))
        (princ (strcat "\n\t기둥일람표 화일이름: " cdwg))
      )
    )
  )
)

(defun suc1 (/ cdwg f$$)
  (while (= f$$ nil)
    (dlg_clt)
    (setq filename (strcat cdwg ".COL"))
    (if (= (setq filename (findfile filename)) nil)
      (progn
        (alert (strcat filename " 화일을 찾을 수 없습니다."))
        (setq f$$ nil)
      )
    )
  )
  (setq aa (open filename "r"))
)

(defun suc2 ()
  (setq a (substr bb 19 5))
  (if (= (substr bb 19 1) "D")
    (setq a (atoi (substr bb 20 4))
          c_y T
    )
    (setq a (atoi a)
          c_y nil
    )
  )

  (setq la (- lx (* sc 20 2)))
  (setq la (* (fix (/ la 10)) 10))

  (if (not c_y)
    (progn
      (setq b  (atoi (substr bb 25 4))
            lb (- lh (* sc 16) (* sc 8))
            lb (* (fix (/ lb 10)) 10)
      )
      (if (> b lb) 
        (setq b-b b b lb)
        (setq b-b b)
      )
      (setq tb (itoa b-b))
      (if (>= (strlen tb) 4)
        (setq tb (strcat (substr tb 1 1) "," (substr tb 2 3)))
      )
    )
    (progn
      (setq b  (atoi (substr bb 20 4))
            lb (- lh (* sc 16) (* sc 8))
            lb (* (fix (/ lb 10)) 10)
      )
      (if (> la lb) 
        (setq la lb)
      )
    )
  )

  (if (> a la) 
    (setq a-a a a la)
    (setq a-a a)
  )
  (setq ta (itoa a-a))
  (if (>= (strlen ta) 4)
    (setq ta (strcat (substr ta 1 1) "," (substr ta 2 3)))
  )

  (setq t1 (substr bb 4 6))
  (setq t2 (ci_blank (strcase (substr bb 30 4))))

  (if c_y
    (setq t11 (atoi (substr bb 35 2)))
    (setq t11 (atoi (substr bb 35 1))
          t12 (atoi (substr bb 36 1))
    )
  )

  (setq t3  (ci_blank (strcase (substr bb 38 4))))
  (setq t31 (substr bb 43 3))

  (setq t4  (ci_blank (strcase (substr bb 47 4))))
  (setq t41 (substr bb 52 3))

  (setq t5 (ci_blank (strcase (substr bb 56 2))))
  (if (and (/= t5 "X") (/= t5 ""))
    (setq t51 (atoi (substr bb 56 1))
          t52 (atoi (substr bb 57 1))
    )
    (setq t51 0 t52 0)
  )
)

(defun suc3 ()
  (setq htr (strcat t3 " @" t31))
  (setq htl (strcat t4 " @" t41))
  (if c_y
    (setq hth (strcat (itoa t11) " - " t2))
    (setq hth (strcat (itoa (+ (* (+ t11 t12) 2) 4)) " - " t2))
  )
  (setq tt1 t11 tt2 t12)
)

(defun suc4 ()
  (command "_.pline" pa1
           (setq p (polar pa1 0 a))
           (setq p (polar p (dtr 270) b))
           (setq p (polar p (dtr 180) a))
           "_c"
  )

  (command "_.color" co_tre)

  (setq pb1 (polar pa1 0 30)
        pb1 (polar pb1 (dtr 270) 30)
  )
        
  (command "_.pline" pb1
           (setq p (polar pb1 (dtr 270) (- b 60)))
           (setq p (polar p 0 (- a 60)))      
           (setq p (polar p (dtr 90) (- b 60)))
           "_c"
  )				
                    
  (command "_.color" co_2)

  (setvar "DIMASSOC" 1)
  (setvar "DIMALTD" 1)

  (command "_.dim1" "HOR" pa1 (polar pa1 0 a)
           (polar pa1 (dtr 90) (* sc 8)) ta)
  (command "_.dim1" "VER" (setq p (polar pa1 0 a)) (polar p (dtr 270) b)
           (polar p 0 (* sc 12)) tb)

  (setq pc1 (polar pb1 0 (* sc 0.5))
        pc1 (polar pc1 (dtr 270) (* sc 0.5))
  )
  (setq pk1 pc1)
  (command "_.color" co_tre)

  (setq tt1 (+ tt1 2))
  (command "_.circle" pc1 (* sc 0.5))
  (command "_.array" "_L" "" "_R" "" tt1 (/ (- a 60 sc) (1- tt1)))

  (setq pc1 (polar pc1 (dtr 270) (- b 60 sc)))
  (command "_.circle" pc1 (* sc 0.5))
  (command "_.array" "_L" "" "_R" "" tt1 (/ (- a 60 sc) (1- tt1)))

  (if (>= tt2 1)
    (progn
      (setq pc1 (polar pc1 (dtr 90) (/ (- b 60 sc) (1+ tt2))))
      (command "_.circle" pc1 (* sc 0.5))
      (if (> tt2 1)
        (command "_.array" "_L" "" "_R" tt2 "" (/ (- b 60 sc) (1+ tt2)))
      )
      (setq pc1 (polar pc1 0 (- a 60 sc)))
      (command "_.circle" pc1 (* sc 0.5))
      (if (> tt2 1)
        (command "_.array" "_L" "" "_R" tt2 "" (/ (- b 60 sc) (1+ tt2)))
      )
    )
  )

  (command "_.color" co_2)
  (command "_.LINETYPE" "_S" "HIDDEN" "")

  (if (= t5 "X")
    (progn
      (setq pk1 (polar pk1 0 (* sc 0.5))
            pk4 (polar pk1 0 (- a 60 (* sc 2)))
            pk3 (polar pk1 (dtr 270) (- b 60 sc))
            pk2 (polar pk3 0 (- a 60 (* sc 2)))
      )
      (command "_.LINE" pk1 pk2 "")
      (command "_.LINE" pk3 pk4 "")
    )
  )

  (if (>= t51 1)
    (progn
      (setq p (polar pb1 0 (/ (- a 60) (1+ t51))))
      (repeat t51
        (command "_.line" p (polar p (dtr 270) (- b 60)) "")
        (setq p (polar p 0 (/ (- a 60) (1+ t51))))
      )
    )
  )

  (if (>= t52 1)
    (progn
      (setq p (polar pb1 (dtr 270) (/ (- b 60) (1+ t52))))
      (repeat t52
        (command "_.line" p (polar p 0 (- a 60)) "")
        (setq p (polar p (dtr 270) (/ (- b 60) (1+ t52))))
      )
    )
  )

  (command "_.LINETYPE" "_S" "CONTINUOUS" "")

  (setq pat1 (polar pw1 0 (/ lx 2.0))
        pat1 (polar pat1 (dtr 270) (- ly (* sc 2)))
  )

  (if (or (= t5 "X") (>= t51 1) (>= t52 1))
    (command "_.text" "_C" pat1 (* sc 3) 0 htl)
  )
  (command "_.text" "_C"
           (setq pat1 (polar pat1 (dtr 90) (* sc 8))) (* sc 3) 0 htr)
  (command "_.text" "_C"
           (setq pat1 (polar pat1 (dtr 90) (* sc 8))) (* sc 3) 0 hth)
)

(defun suc4a ()
  (command "_.circle" cen (/ a 2.0))

  (command "_.color" co_tre)

  (command "_.circle" cen (- (/ a 2.0) 30))
                    
  (command "_.color" co_2)

  (setvar "DIMASSOC" 1)
  (setvar "DIMALTD" 1)

  (command "_.dim1" "HOR" pa1 (polar pa1 0 a)
           (polar pa1 (dtr 90) (* sc 8)) ta)
  (command "_.dim1" "VER" (setq p (polar pa1 0 a)) (polar p (dtr 270) a)
           (polar p 0 (* sc 8)) ta)

  (setq pc1 (polar cen (dtr 90) (- (/ a 2.0) 30 (* sc 0.5))))
  (setq pk1 pc1)
  (command "_.color" co_tre)

  (command "_.circle" pc1 (* sc 0.5))
  (command "_.array" "_L" "" "_P" cen tt1 360 "")

  (command "_.color" co_2)

  (setq pat1 (polar pw1 0 (/ lx 2.0))
        pat1 (polar pat1 (dtr 270) (- ly (* sc 2)))
  )

  (command "_.text" "_C"
           (setq pat1 (polar pat1 (dtr 90) (* sc 8))) (* sc 3) 0 htr)
  (command "_.text" "_C"
           (setq pat1 (polar pat1 (dtr 90) (* sc 8))) (* sc 3) 0 hth)
)

(defun sucd ()
  
  
  (command "_.line" pw1 pw4 "")
  (command "_.line" pw9 pw10 "")
  (command "_.line" pw5 pw6 "")
  (command "_.line" pw7 pw8 "")
  (command "_.array" "_L" "" "_R" "" (+ pc 1) lx)
  (if (not (stysearch text_s))
    (styleset text_s)
  )
  (setvar "textstyle" text_s)
  (setq text_1 "부대근"
        text_2 "주대근"
        text_3 "주 근"
        text_4 "형 태"
        text_5 "및"
        text_6 "배 근"
        text_7 "~"
        text_8 (if pn
                 (strcat "기  둥  일  람  표" "  -  " pn)
                 "기  둥  일  람  표"
               )
        text_9 "층"
        text_10 "상 동"
        text_11 "부 호"
  )
  (repeat pr
    (setq pt1 (polar pw9 0 (* sc 9))
          pt1 (polar pt1 (dtr 90) (* sc 2))
          pt2 (polar pt1 (dtr 90) (* sc 8))
          pt3 (polar pt2 (dtr 90) (* sc 8))
          pt4 (polar pt3 (dtr 90) (+ (* sc 4) (/ lh 2)))
          pt5 (polar pt4 (dtr 180) (* sc 15))
          pt5x (polar pt5 (dtr 90) (* sc 10))
          pt5y (polar pt5 (dtr 270) (* sc 10))
          pt7 (polar pt3 (dtr 180) (* sc 15))
    )
    (command "_.color" co_2)
    (command "_.line" pw1 (polar pw1 0 (+ (* sc 30) (* lx pc))) "")
    (command "_.color" co_3)
    (command "_.text" "_C" pt1 (* sc 4) 0 text_1)
    (command "_.color" co_2)
    (command "_.line" (setq pp1 (polar pw9 (dtr 90) (* sc 8)))
                              (polar pp1 0 (+ (* sc 18) (* lx pc))) "")
    (command "_.color" co_3)
    (command "_.text" "_C" pt2 (* sc 4) 0 text_2)
    (command "_.color" co_2)
    (command "_.line" (setq pp1 (polar pp1 (dtr 90) (* sc 8)))
                              (polar pp1 0 (+ (* sc 18) (* lx pc))) "")
    (command "_.color" co_3)
    (command "_.text" "_C" pt3 (* sc 4) 0 text_3)
    (command "_.color" co_2)
    (command "_.line" (setq pp1 (polar pp1 (dtr 90) (* sc 8)))
                              (polar pp1 0 (+ (* sc 18) (* lx pc))) "")
    (command "_.color" co_3)
    (command "_.text" "_C" (polar pt4 (dtr 90) (* sc 10)) (* sc 4) 0 text_4)
    (command "_.text" "_C" pt4 (* sc 4) 0 text_5)
    (command "_.text" "_C" (polar pt4 (dtr 270) (* sc 10)) (* sc 4) 0 text_6)
    (command "_.color" co_2)
    (command "_.line" (setq pp1 (polar pw1 (dtr 90) (- ly (* sc 0.5))))
                              (polar pp1 0 (+ (* sc 30) (* lx pc))) "")
    (setq pw1 (polar pw1 (dtr 90) ly)
          pw9 (polar pw1 0 (* sc 12)))
  )
  (command "_.line" pw1 (polar pw1 0 (+ (* sc 30) (* lx pc))) "")
  (command "_.line" pw4 pw2 "")
  (setq pt8 (polar pw1 0 (* sc 6))
        pt8 (polar pt8 (dtr 90) (* sc 2))
        pt9 (polar pw9 0 (* sc 9))
        pt9 (polar pt9 (dtr 90) (* sc 2))
  )
  (command "_.color" co_3)
  (command "_.text" "_C" pt8 (* sc 4) 0 text_9)
  (command "_.text" "_C" pt9 (* sc 4) 0 text_11)
  (if (not (stysearch text_d))
    (styleset text_d)
  )
  (setvar "textstyle" text_d)
  (command "_.color" co_5)
  (command "_.text" "_C" pt6 (* sc 8) 0 text_8)
  (command "_.color" co_2)
  (setq p_list (textbox (entget (entlast))))
  (setq p_leng (- (car (nth 1 p_list)) (car (nth 0 p_list))))
  (setq p_leng (+ p_leng (* sc 10)))
  (setq pt6x (polar pt6 (dtr 180) (/ p_leng 2))
        pt61 (polar pt6x (dtr 270) (* sc 1.5))
        pt62 (polar pt6x (dtr 270) (* sc 2))
  )
  (command "_.line" pt61 (polar pt61 0 p_leng) "")
  (command "_.line" pt62 (polar pt62 0 p_leng) "")
  (if (not (stysearch "SIM"))
    (styleset "SIM")
  )
  (command "_.color" co_2)
  ;;(close aa)
  (setq aa (open filename "r"))
  (setq bb (read-line aa))
  (while (= bb "") (setq bb (read-line aa)))
  (repeat prn
    (setq lev (ci_blank (substr bb 11 7))
          stn (strlen lev)
    )

    (setq nk (instr lev ","))
    (setq nky (instr lev "-"))
    (command "_.color" co_3)
    (setvar "textstyle" "SIM")
    (cond
      (nky
        (command "_.text" "_c" pt5x (* sc 4) 0
                 (substr lev 1 (1- nky)))
        (command "_.text" "_ML" pt5 (* sc 4) 90 text_7)
        (command "_.text" "_c" pt5y (* sc 4) 0
                 (substr lev (1+ nky) (- stn nky)))
      )
      (nk
        (command "_.text" "_c" pt5x (* sc 4) 0
                   (substr lev 1 (1- nk)))
        (command "_.text" "_C" (polar pt5 (dtr 90) (* sc 2))
                   (* sc 4) 0 ",")
        (command "_.text" "_c" pt5y (* sc 4) 0
                   (substr lev (1+ nk) (- stn nk)))
      )
      (T
        (command "_.text" "_C" pt5 (* sc 4) 0 lev)
      )
    )
    (setvar "textstyle" text_s)
    (command "_.text" "_C" pt7 (* sc 4) 0 text_9)
    (command "_.color" co_2)
    (setvar "textstyle" "SIM")
    (setq bb (read-line aa))
    (setq pt5 (polar pt5 (dtr 270) ly)
          pt5x (polar pt5 (dtr 90) (* sc 10))
          pt5y (polar pt5 (dtr 270) (* sc 10))
          pt7 (polar pt7 (dtr 270) ly)
    )
  )
)

(defun m:clist (/
               cec      sc       pw1      pw2      pw3      pw4      pw5
               pw6      pw7      pw8      pw9      pw10     pt1      pt2
               pt3      pt4      pt5      pt5x     pt5y     pt6      pt7
               pt8      pt9      pt10     pp1      lev      stn      nk
               nkx      nky      t1p      a1       b1       p        pa1
               pb1      pc1      pk1      pk2      pk3      pk4      pwx
               dx       dy       aa       bb       po       n        prn
               pr       pn       pc       at       a        b        la
               lb       lh       lx       ly       a-a      b-b      tt1
               tt2      t1       t2       t3       t4       t5       t11
               t12      t31      t41      t51      t52      pat1     htr
               htl      hth      nx       ny       ta       tb       filename
               p_list   p_leng   pt6x     pt61     pt62     c_y      at
               text_s   text_d   text_1   text_2   text_3   text_4   text_5
               text_6   text_7   text_8   text_9   text_10  text_11
               clist_err clist_oer clist_ola clist_oli cen check_table)
  
(defun check_table(/ maxx maxy yorn)
  (setq sc (getvar "dimscale"))
  (setq pr (atoi pr) pc (atoi pc))
  (setq lx (/ (- dx (* sc 5 2) (* sc 30)) pc))
  (setq ly (/ (- dy (* sc 5) (* sc 30)) pr))
  (setq lh (- ly (* sc 8 3)))
  (setq pw1 (polar pw1 0 (* sc 5))
        pw1 (polar pw1 (dtr 90) (* sc 5))
        pw3 (polar pw1 0 (+ (* sc 30) (* lx pc)))
        pw2 (polar pw3 (dtr 90) (+ (* ly pr) (* sc 8)))
        pw4 (polar pw1 (dtr 90) (+ (* ly pr) (* sc 8)))
        pt6 (polar pw4 0 (/ (- dx (* sc 10)) 2))
        pt6 (polar pt6 (dtr 90) (* sc 5))
  )
  (setq pw5 (polar pw1 0 (* sc 29.5))
        pw6 (polar pw4 0 (* sc 29.5))
        pw7 (polar pw1 0 (* sc 30))
        pw8 (polar pw4 0 (* sc 30))
        pw9 (polar pw1 0 (* sc 12))
        pw10 (polar pw4 0 (* sc 12))
  )
  (setq aa (open filename "r"))
  (setq bb (read-line aa))
  (setq maxx (atof (substr bb 19 5))
 	maxy (atof (substr bb 25 4)))
  (while (and (/= (setq bb (read-line aa)) "") (/= bb nil)) 
    (if (< maxx (atof (substr bb 19 5))) (setq maxx (atof (substr bb 19 5))))
    (if (< maxy (atof (substr bb 25 4))) (setq maxx (atof (substr bb 25 4))))
  )
  (close aa)	       
  (if (or (> maxy (- lh (* sc 16) (* sc 8))) (> maxx (- lx (* sc 20 2))))
    (progn
      (initget "Yes No")
      (setq yorn (getkword "\n도면 스케일이 작아서 실제 치수로 그려지지 않습니다..\n계속하시겠습니까? (Y/N)"))
      (if (= yorn "No") (progn (princ "\nStart 명령 실행후 도면스케일을 조정하시기 바랍니다.") nil) T)
    )
    
    T)
)
  
  (setq cec (getvar "CECOLOR"))
  (ai_err_on)
  (ai_undo_on)
  (setlay tbl:lay)
  (command "_.undo" "_group")
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n기둥 일람표를 잘성하는 명령입니다.")
  (cond
    
    ((findfile "WHGTXT.SHX")
      (setq text_d "CIHD"
            text_s "CIHS"
      )
    )

    (T
      (alert "한글 글꼴을 찾을 수 없습니다.")
      ;(exit)
    )
  )
  (setvar "blipmode" 1)
  (setvar "osmode" 33)
  (setq pw1 (getpoint "\n>>>도면의 좌측 하단을 선택하십시오: ENDPOINT of "))
  (setq pw2 (getcorner pw1
              "\n>>>도면의 우측 상단을 선택하십시오: ENDPOINT of "))
  (setvar "osmode" 0)
  (setvar "blipmode" 0)
  (setvar "cmdecho" 0)
  (setq pw3 (list (car pw2) (cadr pw1)))
  (setq dx (distance pw1 pw3)
        dy (distance pw3 pw2)
  )
  (suc1)

  
  (setq bb (read-line aa))
  (while (= bb "") (setq bb (read-line aa)))

  (setq lev (ci_blank (substr bb 11 7))
        prn 1
  )
  (setq bb  (read-line aa))
  (setq t1p (ci_blank (substr bb 11 7)))
  (while (and (/= t1p "") (/= t1p lev))
    (setq bb  (read-line aa)
          t1p (ci_blank (substr bb 11 7))
          prn (1+ prn)
    )
  )

  (setq at bb)
  (while at
    (setq bb at)
    (setq at (read-line aa))
  )
  (setq pr (substr bb 2 1)
        pc (substr bb 1 1)
  )
  (if (setq pn (instr (getvar "dwgname") "-"))
    (setq pn (substr (getvar "dwgname") (1+ pn)))
  )
  (close aa)
  (if (check_table)  
  	(progn
  (sucd)
  (close aa)
  (setq aa (open filename "r"))
  (setq bb (read-line aa))
  (while (= bb "") (setq bb (read-line aa)))

  (setq pw1 (polar pw1 0 (* sc 30)))
  (setq a1  (car  pw1)
        b1  (cadr pw1)
  )

  (while bb
    (setq nx (atoi (substr bb 1 1))
          ny (atoi (substr bb 2 1))
    )
    (cond
      ((and (= ny 1) (/= (substr bb 4 1) " "))
        (setq at (ci_blank (strcase (substr bb 19 5))))
        (command "_.color" co_3)
        (setq pw1 (list (+ a1 (* lx (1- nx))) (- b1 (* ly (1- ny)))))
        (setq p   (polar pw1 0 (/ lx 2.0)))
        (setq p   (polar p (dtr 90) (* sc 2)))
        (setq lev (ci_blank (substr bb 4 6)))
        (command "_.text" "_C" p (* sc 4) 0 lev) 
        (command "_.color" co_2)
        (repeat prn
          (if (and (/= at "=") (/= at "X"))
            (progn 
              (suc2)
              (setq pw1 (list (+ a1 (* lx (1- nx)))
                              (- b1 (* ly (1- ny)))))
              (setq pa1 (polar pw1 0 (/ lx 2.0)))
              (setq pa1 (polar pa1 (dtr 270) (* sc 16)))
              (setq pa1 (polar pa1 (dtr 180) (/ a 2.0)))
              (suc3)
              (if c_y
                (progn
                  (setq cen (polar pa1 0 (/ a 2.0))
                        cen (polar cen (dtr 270) (/ a 2.0))
                  )
                  (suc4a)
                )
                (suc4)
              )
            )
            (progn
              (setq pw1 (list (+ a1 (* lx (1- nx)))
                              (- b1 (* ly (1- ny)))))
              (if (= at "=")
                (progn
                  (setq pa1 (polar pw1 0 (/ lx 2.0)))
                  (setq pa1 (polar pa1 (dtr 270) (/ lh 2.0)))
                  (setvar "textstyle" text_s)
                  (command "_.color" co_3)
                  (command "_.text" "_C" pa1 (* sc 4) 0 text_10)
                  (setvar "textstyle" "SIM")
                  (command "_.color" co_2)
                )
                (progn
                  (setq pwx (polar pw1 0 lx)
                        pwx (polar pwx (dtr 270) ly)
                  )
                  (command "_.line" pw1 pwx "")
                )
              )
            )
          )
          (setq bb (read-line aa))
          (if bb
            (setq at (ci_blank (strcase (substr bb 19 5))))
          )
          (setq ny (1+ ny))
        )
        (repeat (- pr prn)
          (setq bb (read-line aa))
        )
      )
      (T
        (setq bb (read-line aa))
      )
    )
  )
  (close aa)
  (command "_.undo" "_en")
  ))
  (ai_err_off)
  (ai_undo_off)
;;;  (setvar "cmdecho" 1)
;;;  (setvar "blipmode" 1)
  (princ)
)
(if (null tbl:lay) (setq tbl:lay "TABLE"))
(defun C:CIMCLIST () (m:clist))
(princ)

