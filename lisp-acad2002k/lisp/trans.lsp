;수정날짜": 2001년 8월 13일
;작업자: 박율구
;명령어: CIMVD
;       CIMLIFT

(setq lfn43 1)

(defun vd_cut_fin(dist1 / factor eee)
  (setq factor (/ (distance strtpt nextpt) 8))
  (if (setq ss (wall_select_rect (setq p strtpt) factor))
    (progn
      (RMV)
      
      (repeat ls
        (setq no (1+ no))
        (if (= (cdr (assoc 8 (entget (ssname ss no)))) "FINISH")          
          (progn
                    (setq eee (entget (ssname ss no)))
                (command "_.break" (ssname ss no) (polar pb1 ang1 dist1) (polar pb2 ang2 dist1))
            
        ))
      )
    )
  )
  (if (setq ss (wall_select_rect (setq p nextpt) factor))
    (progn
      
      (RMV)
      (repeat ls
        (setq no (1+ no))
        (if (= (cdr (assoc 8 (entget (ssname ss no)))) "FINISH")
          (progn
                    (setq eee (entget (ssname ss no)))
                  (command "_.break" (ssname ss no)  pb1 pb2)
        ))
      )
    )
  )
 
)

(defun vd_fin_dist(/ factor)
  
  (setq factor (/ (distance strtpt nextpt) 8))
 
  (if (setq ss (wall_select_rect (setq p strtpt ) factor))
    (progn
      (RMV)
        (if (> ls 1)
          (progn
            (if (< (setq ele:wf1 (distance p (perpoint p (entget (ssname ss 0))))) 0.01)
              (setq ele:wf1 (distance p (perpoint p (entget (ssname ss 1)))))
            )
          )
         )
     )
  )
  (if (= ele:wf1 nil)
    (setq ele:wf1 0)
  )
  
 
  (if (setq ss (wall_select_rect (setq p nextpt ) factor))
    (progn
      (RMV)
        (if (> ls 1)
          (progn
            (if (< (setq ele:wf2 (distance p (perpoint p (entget (ssname ss 0))))) 0.01)
              (setq ele:wf2 (distance p (perpoint p (entget (ssname ss 1)))))
            )
          )
         )
     )
  )
  (if (= ele:wf2 nil)
    (setq ele:wf2 0)
  )
)
(defun m:ELE (/
             ele_ots  ele:celt ele:clt  ele:cel  ele:txt  ttx      dh
             dl       ele_scl  inp      en       pt1      pt2      pt3
             pt4      pt5      pt6      pt7      pt8      pt9      pt10
             pt11     ele:wf1  ele:wf2 p1       ptx      k        no       e
             p        ang3     d2       d3       ar_r1    ar_r2    aa
             ll       l        CC       ss       ls       ang      uctn
             ang1     ang2     ds       cont     temp     tem      uctr
             cept
             ele_scl  strtpt   angc1  nextpt  angc2
             )

  (setq ele_scl (getvar "dimscale"))
  ;;
  ;; Internal error handler defined locally
  ;;

  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")

(princ "\nArchiFree 2002 for AutoCAD LT 2002.")
(princ "\n엘리베이터를 그리는 명령입니다.")

  (setq cont T uctr T uctn 0)

  (while cont
    (ele_m1)
    (ele_m2)
    (ele_m3)
  )

   
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)

  (princ)
)

(defun ele_m1 ()
  (while uctr
    (initget 1 "8 9 10 11 13 15 17 20 24  ")
    (setq inp (getkword (strcat
                "\n>>> Persons 8/9/10/11/13/15/17/20/24/<" ele:per ">: ")))
    (if (/= inp "") (setq ele:per inp))
    (if (< ele_scl 100.0)
      (setq en (strcat "ELEV" ele:per))
      (setq en (strcat "ELEV" ele:per "S"))
    )
    (if (not (findfile (strcat en ".DWG")))
      (progn
        (alert (strcat en ".DWG file not found. -- Check your library. "))
        (exit)
      )
      (setq uctr nil temp T)
    )
  )
)

(defun ele_m2 ()
  (while temp
    (initget "Offset Dialog Undo /")
    (setvar "osmode" (+ 512 33))
    (setq strtpt (getpoint
                    "\n>>> Dialog/Offset/Undo/<벽체 안쪽선을 선택하십시요.>: NEAREST to "))
    (setvar "osmode" 0)
    (cond
      ((= strtpt "Offset")
        (cim_ofs)
      )
      ((= strtpt "Dialog")
        (dd_ele)
      )
      ((= strtpt "Undo")
        (setq temp nil strtpt nil uctr T)
      )
      ((= strtpt "/")
        (princ "\tPlease waite -- help_dialog loading...")
        (cim_help "ELE")
      )
      ((null strtpt)
        (setq cont nil temp nil)
      )
      (T
        (if (not (ssget strtpt))
          (alert "Wall entity not selected. -- Try again.")
          (setq temp nil)
        )
      )
    )
  )
)

(defun ele_m3 ()
  (if strtpt
    (setq tem T)
  )
  (while tem
    (initget "/ Dialog Undo")
    (setvar "osmode" 128)
    (setq nextpt (getpoint strtpt
                   "\n>>> Dialog/Undo/<벽체 바깥선을 표시하십시요.>: PERPEND to "))
    (setvar "osmode" 0)
    (cond
      ((= nextpt "Undo")
        (setq tem nil temp T)
      )
      ((= nextpt "Dialog")
        (dd_ele)
      )
      ((= nextpt "/")
        (princ "\tPlease waite -- help_dialog loading...")
        (cim_help "ELE")
      )
      ((null nextpt)
        (setq cont nil tem nil)
      )
      (T
        (if (not (ssget nextpt))
          (alert "Wall entity not selected. -- Try again.")
          (if (or (> (distance strtpt nextpt) 500)
                  (= (distance strtpt nextpt) 0)
              )
            (alert "Invalid wall selected. -- Try again.")
            (progn
              (ele_do1)
              (ele_do2)
              (setq uctn (1+ uctn))
              (setq tem nil temp T)
            )
          )
        )
      )
    )
  )
)

(defun ele_do1 ()
  
  (cond
    ((or (= ele:per "8") (= ele:per "9") (= ele:per "10")
         (= ele:per "11") (= ele:per "13"))
      (setq ds 500)
    ) 
    ((or (= ele:per "15") (= ele:per "17") (= ele:per "20"))
      (setq ds 600)
    ) 
    ((= ele:per "24")
      (setq ds 650)
    ) 
  )
  (setq pt3 nextpt nextpt nil)
  (wall_point)
  (setq nextpt pt3)
  (setq ang  (angle strtpt nextpt)
        ang1 (+ ang (dtr 90))
        ang2 (+ ang1 (dtr 180))
        ang3 (+ ang  (dtr 180))
        pt1  (polar nextpt ang1 ds)
        pt2  (polar nextpt ang2 ds)
        pt3  (polar strtpt ang1 ds)
        pt4  (polar strtpt ang2 ds)
        d2   (distance strtpt nextpt)
  )
 
  ; get_finish width
 (vd_fin_dist)
  (setq pt5  (polar pt2  ang1 10)
        pt6  (polar pt5  ang  (+ ele:wf1 12))
        pt7  (polar pt6  ang1 30)
        pt8  (polar pt7  ang1 60)
        pt8  (polar pt8  ang3 (+ d2 ele:wf2 2))
        pt9  (polar pt8  ang3 30)
        pt10 (polar pt9  ang2 70)
        pt11 (polar pt10 ang  20)
        d3   (* 2 ds)
  )
  (setq pb1 (polar pt6 ang3 12)
        pb2 (polar pb1 ang1 (- d3 20))
  )
 
  (vd_cut_fin 20)
  (setq ss (ssget "C" strtpt nextpt))
  (RMV)
  (brk_s)
  
  (setq ps1 strtpt)
  (set_col_lin_lay ele:eprop)
  
  (command "_.insert" en ps1 "" "" (rtd ang))
  (command "_.pline" pt5 pt6 pt7 pt8 pt9 pt10 pt11 "")
  (command "_.mirror" "_L" "" strtpt nextpt "")
  
)


(defun ele_do2 ()
  (if (= uctn 0)
    (progn
      (initget 1 "Y N  ")
      (if (not (member tt_x '("Y" "N"))) (setq tt_x "Y"))
      (setq ttx (getkword
                  (strcat "\n\t탑승인원을 표시할까요 <" tt_x ">? ")))
      (if (member ttx '("Y" "N")) (setq tt_x ttx))
    )
  )
  (if (= tt_x "Y")
    (progn
      (if (< ele_scl 100)
        (setq dh (* ele_scl 3))
        (setq dh (* ele_scl 2))
      )
      (cond
        ((or (= (substr ele:sty 1 2) "GH") (= (substr ele:sty 1 2) "GC")
             (= (substr ele:sty 1 1) "H") (= (substr ele:sty 1 2) "SH")
             (= (substr ele:sty 1 1) "C"))
          (setq ele:txt (strcat "(" ele:per "인승)"))
        )
        (T
          (setq ele:txt (strcat "(" ele:per "persons)"))
        )
      )
      (cond
        ((= ele:per "8")
          (setq dl 700)
        )
        ((= ele:per "9")
          (setq dl 750)
        )
        ((= ele:per "10")
          (setq dl 800)
        )
        ((or (= ele:per "11") (= ele:per "13") (= ele:per "15"))
          (setq dl 850)
        )
        ((= ele:per "17")
          (setq dl 950)
        )
        ((or (= ele:per "20") (= ele:per "24"))
          (setq dl 1050)
        )
      )
      ;(command "_.color" co_3)
      (if (not (stysearch ele:sty))
        (styleset ele:sty)
      )
      (setvar "textstyle" ele:sty)
      (command "_.text" "_M" (polar ps1 (+ ang (dtr 180)) dl)
               dh 0 ele:txt)
      
    )
  )
)

(defun dd_ele (/ cancel_check dcl_id)
  
  (setq dcl_id (ai_dcl "setprop"))
  (if (not (new_dialog "set_prop_c_la" dcl_id)) (exit))
  (@get_eval_prop ele_prop_type ele:prop)
  
  (action_tile "b_name" "(@getlayer)")
  (action_tile "b_color" "(@getcolor)")
  (action_tile "color_image"  "(@getcolor)")
  ;(action_tile "b_line"       "(@getlin)")
  (action_tile "c_bylayer" "(@bylayer_do T)")
  ;(action_tile "t_bylayer" "(@bylayer_do nil)")
  (action_tile "cancel" "(setq cancel_check T)(done_dialog)")
  (start_dialog)
  (done_dialog)
  (if (= cancel_check nil)
        (PROP_SAVE ele:prop)
  )

)

(if (null ele:sty)
  (cond
    ((findfile "WHGTXT.SHX")
      (setq ele:sty "CIHS")
    )        

    (T
      (setq ele:sty "SIM")
    )
  )
)

(setq ele:eprop  (Prop_search "vd" "elev"))
(setq ele:prop '(ele:eprop))
(if (null ele_prop_type) (setq ele_prop_type "rd_elev"))
(if (null ele:per) (setq ele:per "8"))

(defun c:CIMVD () (m:ele))
(princ)

(defun m:lift (/
             lif_ots  ttx      dh       dt
             dl       lif_scl  inp      en       pt1      pt2      pt3
             pt4      pt5      pt6      pt7      pt8      pt9      pt10
             pt51     pt61     pt71     pt81     pt91     px1      px2
             ele:wf1  ele:wf2  p1       ptx      k        no       e        ptx
             p        ang3     d2       ds1      ds2      pb1      pb2
             ss       ls       ang      uctn     tempt    angx     aa
             ang1     ang2     cont     temp     tem      uctr
             lif_oco  cept
             lif_scl  strtpt   nextpt)

  (setq lif_scl (getvar "dimscale")
        lif_ots (getvar "textstyle")
  )

  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")
  (setvar "orthomode" 0)
  
  (princ "\nArchiFree 2002 for AutoCAD LT 2002).")
  (princ "\n리프트 그리기 명령입니다.")
  (setq cont T uctr T uctn 0)

  (while cont
    (lif_m1)
    (lif_m2)
    (lif_m3)
    (lif_m4)
  )
  
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ)
)

(defun lif_m1 ()
  (while uctr
    (initget 1 "A B C D E F  ")
    (setq inp (getkword (strcat
"\nCapacity(ton) [A]0.75/[B]1.0/[C]1.5/[D]2.0/[E]2.5/[F]3.0/<" lif:cap ">: ")))
    (if (/= inp "") (setq lif:cap inp))
    (if (< lif_scl 100.0)
      (cond
        ((= lif:cap "A")
          (setq en "lift2s75")
        )
        ((= lif:cap "B")
          (setq en "lift2s10")
        )
        ((= lif:cap "C")
          (setq en "lift2s15")
        )
        ((= lif:cap "D")
          (setq en "lift2s20")
        )
        ((= lif:cap "E")
          (setq en "lift2u25")
        )
        ((= lif:cap "F")
          (setq en "lift2u30")
        )
      )
      (cond
        ((= lif:cap "A")
          (setq en "lifts75")
        )
        ((= lif:cap "B")
          (setq en "lifts10")
        )
        ((= lif:cap "C")
          (setq en "lifts15")
        )
        ((= lif:cap "D")
          (setq en "lifts20")
        )
        ((= lif:cap "E")
          (setq en "liftu25")
        )
        ((= lif:cap "F")
          (setq en "liftu30")
        )
      )
    )
    (if (not (findfile (strcat en ".DWG")))
      (progn
        (alert (strcat en ".DWG file not found. -- Check your library."))
        (exit)
      )
      (setq uctr nil temp T)
    )
  )
)

(defun lif_m2 ()
  
  (while temp
    (initget "Dialog Undo /")
    (setvar "osmode" (+ 33 512))
    (setq strtpt (getpoint "\n>>> Dialog/Undo/<door_side corner>: "))
    (setvar "osmode" 0)
    (cond
      ((= strtpt "Undo")
        (setq temp nil strtpt nil uctr T)
      )
      ((= strtpt "Dialog")
        (dd_lift)
      )
      ((= strtpt "/")
        (princ "\tPlease waite -- help_dialog loading...")
        (cim_help "LIFT")
      )
      ((null strtpt)
        (setq cont nil temp nil ptx nil)
      )
      (T
        (if (not (ssget strtpt))
          (alert "Wall entity not selected. -- Try again.")
          (setq temp nil)
        )
      )
    )
  )
)

(defun lif_m3 ()
  (if strtpt
    (setq tempt T)
  )
  (while tempt
    (initget "Dialog Undo /")
    (setvar "osmode" (+ 33 512))
    (setq ptx (getpoint strtpt "\n>>> Dialog/Undo/<Opposite corner>: "))
    (setvar "osmode" 0)
    (cond
      ((= ptx "Undo")
        (setq tempt nil ptx nil temp T)
      )
      ((= ptx "Dialog")
        (dd_lift)
      )
      ((= ptx "/")
        (princ "\tPlease waite -- help_dialog loading...")
        (cim_help "LIFT")
      )
      ((null ptx)
        (setq cont nil tempt nil)
      )
      (T
        (if (not (ssget ptx))
          (alert "Wall entity not selected. -- Try again.")
          (setq tempt nil)
        )
      )
    )
  )
)

(defun lif_m4 ()

 (if ptx
    (setq tem T)
  )
  (while tem
    (initget "/ Dialog Undo")
    (setvar "osmode" 128)
    (setq nextpt (getpoint strtpt
                   "\n>>> Dialog/Undo/<Touch Outside of Wall>: PERPEND to "))
    (setvar "osmode" 0)
    
    (cond
      ((= nextpt "Undo")
        (setq tem nil tempt T)
      )
      ((= nextpt "Dialog")
        (dd_lift)
      )
      
      ((= nextpt "/")
        (princ "\tPlease waite -- help_dialog loading...")
        (cim_help "LIFT")
      )
      ((null nextpt)
        (setq cont nil tem nil)
      )
      (T
        (if (not (ssget nextpt))
          (alert "Wall entity not selected. -- Try again.")
          (if (or (> (distance strtpt nextpt) 500)
                  (= (distance strtpt nextpt) 0)
              )
            (alert "Invalid wall selected. -- Try again.")
            (progn
              (lif_do1)
              (lif_do2)
              (setq uctn (1+ uctn))
              (setq tem nil temp T)
            )
          )
        )
      )
    )
  )
)

(defun lif_do1 ()
  (cond
    ((or (= lif:cap "A") (= lif:cap "B"))
      (setq ds1 100 
            ds2 1400
      )
    )
    ((= lif:cap "C")
      (setq ds1 100
            ds2 1600
      )
    )
    ((= lif:cap "D")
      (setq ds1 100
            ds2 1700
      )
    )
    ((= lif:cap "E")
      (setq ds1 725 
            ds2 1900
      )
    )
    ((= lif:cap "F")
      (setq ds1 675 
            ds2 2000
      )
    )
  )
  
  (setq pt3 nextpt nextpt ptx)
  (wall_point)
  (setq ptx nextpt nextpt pt3)
  
  (setq ang  (angle strtpt nextpt)
        ang1 (angle ptx strtpt)
        ang2 (angle strtpt ptx)
        ang3 (+ ang  (dtr 180))
        pt1  (polar nextpt ang2 ds1)
        pt2  (polar pt1    ang2 ds2)
        pt3  (polar strtpt ang2 ds1)
        pt4  (polar pt3    ang2 ds2)
        d2   (distance strtpt nextpt)
  )

  (setq px1 (polar pt3 ang3 150)
        px2 (polar pt4 ang3 150) 
  )
  
  (vd_fin_dist)
  (setq pt5  (polar pt1  ang2 20)
        pt6  (polar pt5  ang  (+ ele:wf1 12))
        pt7  (polar pt6  ang2 50)
        pt8  (polar pt7  ang2 80)
        pt8  (polar pt8  ang3 (+ d2 ele:wf2 -38))
        pt9  (polar pt8  ang3 70)
        pt10 (polar pt9  ang1 100)
        pt11 (polar pt10  ang 20)
        
        pt51 (polar pt2  ang1 20)
        pt61 (polar pt51 ang  (+ ele:wf1 12))
        pt71 (polar pt61 ang1 50)
        pt81 (polar pt71 ang1 80)
        pt81 (polar pt81 ang3 (+ d2 ele:wf2 -38))
        pt91 (polar pt81 ang3 70)
        pt101 (polar pt91 ang2 100)
        pt111 (polar pt101 ang 20)
  )
  (setq pb1 (polar pt6  ang3 12)
        pb2 (polar pt61 ang3 12)
  )
  (vd_cut_fin -30)
  (setq ss (ssget "C" strtpt nextpt))
  (RMV)
  (brk_s)
  (setq ps1 strtpt)
  (setvar "osmode" 0)
  (set_col_lin_lay lif:lprop)
  
  (command "_.insert" en ps1 "" "" (rtd ang))
  (setq angx (+ ang (dtr 90)))
  (if (>= (rtd angx) 360.0)
    (setq angx (- angx (dtr 360)))
  )
  (if (equal ang2 angx 0.01)
    (command "_.mirror" "_L" "" strtpt nextpt "_Y")
  )

  (command "_.line" px1 px2 "")
  ;(command "_.color" co_doo)
  (command "_.pline" pt5  pt6  pt7  pt8  pt9  pt10 pt11"")
  (command "_.pline" pt51 pt61 pt71 pt81 pt91 pt101 pt111"")
  ;(command "_.color" lif_oco)
)

(defun lif_do2 ()
  (if (= uctn 0)
    (progn
      (initget 1 "Y N  ")
      (if (not (member tt_x '("Y" "N"))) (setq tt_x "Y"))
      (setq ttx (getkword
                  (strcat "\n\tDisplay lift capacity <" tt_x ">? ")))
      (if (member ttx '("Y" "N")) (setq tt_x ttx))
    )
  )
  (if (= tt_x "Y")
    (progn
      (if (< lif_scl 100)
        (setq dh (* lif_scl 2))
        (setq dh (* lif_scl 2))
      )
      (setq pt1 strtpt)
      (cond
        ((= lif:cap "A")
          (setq p (polar pt1 ang3 1150)
                p (polar p   ang2 1100)
                dt "(0.75ton)"
          )
        )
        ((= lif:cap "B")
          (setq p (polar pt1 ang3 1250)
                p (polar p   ang2 1200)
                dt "(1.0ton)"
          )
        )
        ((= lif:cap "C")
          (setq p (polar pt1 ang3 1400)
                p (polar p   ang2 1300)
                dt "(1.5ton)"
          )
        )
        ((= lif:cap "D")
          (setq p (polar pt1 ang3 1700)
                p (polar p   ang2 1350)
                dt "(2.0ton)"
          )
        )
        ((= lif:cap "E")
          (setq p (polar pt1 ang3 1700)
                p (polar p   ang2 1700)
                dt "(2.5ton)"
          )
        )
        ((= lif:cap "F")
          (setq p (polar pt1 ang3 2000)
                p (polar p   ang2 1700)
                dt "(3.0ton)"
          )
        )
      )
      ;(command "_.color" co_3)
      (if (= (stysearch "SIM") nil)
        (styleset "SIM")
      )
      (setvar "textstyle" "SIM")
      (command "_.text" "_m" p dh 0 dt)
      (command "_.dim1" "_style" lif_ots)
      ;(command "_.color" lif_oco)
    )
  )
)

(defun dd_lift (/ cancel_check dcl_id)
  
  (setq dcl_id (ai_dcl "setprop"))
  (if (not (new_dialog "set_prop_c_la" dcl_id)) (exit))
  (@get_eval_prop lif_prop_type lif:prop)
  
  (action_tile "b_name" "(@getlayer)")
  (action_tile "b_color" "(@getcolor)")
  (action_tile "color_image"  "(@getcolor)")
  ;(action_tile "b_line"       "(@getlin)")
  (action_tile "c_bylayer" "(@bylayer_do T)")
  ;(action_tile "t_bylayer" "(@bylayer_do nil)")
  (action_tile "cancel" "(setq cancel_check T)(done_dialog)")
  (start_dialog)
  (done_dialog)
  (if (= cancel_check nil)
        (PROP_SAVE lif:prop)
  )

)

(setq lif:lprop  (Prop_search "lift" "lift"))
(setq lif:prop '(lif:lprop))
(if (null lif_prop_type) (setq lif_prop_type "rd_lift"))

(if (null lif:cap) (setq lif:cap "C"))

(defun C:CIMLIFT () (m:lift))
(princ)
