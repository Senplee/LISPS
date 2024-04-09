; 수정날짜: 2002.8.10
; 작업자: 박율구
; 명령어: 
;	CIMME 멀티 extend
;	CIMMOVER
;	CIMMTRIM
;	CIMRC
;       CIMMC
;       CIMMF
;	CIMMFF
;	CIMMOF
;	CIMOFC
;	cimOFE
;	CIMXT
;	CIMCHA
;	CIMCHB
;	CIMCCL
;	CIMCT
;	CIMSNGP
;	CIMSSNG
;	CIMCLT
;	CIMZ4
;	CIMZ3
;	CIMZ2
;	CIMZ1
;	cimcdedit
;	cimcdnew

;단축키 관련 변수 정의 부분
(setq lfn02 1)


;==============================================================
(defun m:MEXT (/ CE SS LS NO PNT1 PNT2 temp tem)
  (ai_err_on) 
  (ai_undo_on)
  (command "_.undo" "_group")
  
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n다중 연장 명령입니다.")
  (setvar "BLIPMODE" 1)
  (setq temp T)
  (while temp
    (princ "\n>>> Select extending edge")
    (setq CE (ssget
               '((-4 . "<OR")
                  (0 . "LINE") (0 . "ARC") (0 . "CIRCLE") (0 . "POLYLINE")
		  (0 . "LWPOLYLINE")
                (-4 . "OR>"))))
    (if (= ce nil)
      (alert "Entity not selected -- Try again.")
      (setq temp nil tem T)
    )
  )
  (while tem
    (princ "\n>>> Select objects to extend:")
    (initget 1)
    (setq PNT1 (getpoint "\n\tFirst point:   "))
    (if (null pnt1) (exit))
    (setq PNT2 (getpoint PNT1 "2nd point: "))
    (if (not pnt2)
      (progn
        (exit)
        (princ)
      )
    )
    (setq SS (ssget "F" (list pnt1 pnt2)
               '((-4 . "<OR")
                  (0 . "LINE") (0 . "ARC") (0 . "POLYLINE")
		  (0 . "LWPOLYLINE")
                (-4 . "OR>"))))
    (if ss
      (progn
        (setq ls (sslength ss) no -1)
        (repeat ls
          (setq no (1+ no))
          (setq e (entget (ssname ss no)))
          (if (or (= (fld_st 0 e) "POLYLINE") (= (fld_st 0 e) "LWPOLYLINE"))
            (command "_.explode" (ssname ss no))
          )
        )
        (setq SS (ssget "F" (list pnt1 pnt2)
                   '((-4 . "<OR") (0 . "LINE") (0 . "ARC") (-4 . "OR>"))))
        (setq tem nil)
      )
      (alert "Entity not selected -- Try again.")
    )
  )
  (setvar "CMDECHO" 0)
  (command "_.EXTEND" CE "")
  (setq ls (sslength ss) no -1)
  (repeat LS
    (setq NO (1+ NO))
    (setq e (entget (ssname ss no)))
    (cond
      ((= (fld_st 0 e) "ARC")
        (command (list (ssname SS NO) pnt2))
      )
      (T
        (command (list (ssname ss no)
                       (inters pnt1 pnt2 (fld_st 10 e) (fld_st 11 e)))
        )
      )
    )
  )
  (command "")
  
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ)
)

(defun C:CIMME () (m:mext))
(princ)


;===========================================================================
;                       move,copy,rotate                                    
;===========================================================================
(defun m:mover (/ p1       pt_list  ss_list  e        b        ss
                  uctr     cont     temp     mov_err  mov_oer)
  ;; Internal error handler defined locally
  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")

  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\nmove,copy,rotate등을 한번에 실행하는 명령입니다.")
  
  (setq cont T temp T uctr 0)

  (while cont
    (mov_m1)
    (mov_m2)
  )

  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)

  (princ)
)

(defun mov_m1 ()
  (setq pt_list nil ss_list nil)
  (setq ss (ssget))
  (if ss
    (while temp
      (setvar "osmode" (+ 33 128 ))
      (initget "/")
      (setq p1 (getpoint "\n기준점을 지정하십시오: "))
      (cond
        ((= p1 "/")
          (cim_help "MOVER")
        )
        ((null p1)
          (setq temp nil cont nil)
        )
        (T
          (setq pt_list (cons p1 pt_list)
                ss_list (cons ss ss_list)
          )
          (setq temp nil tem T)
        )
      )
    )
    (setq cont nil)
  )
)

(defun mov_m2 ()
  (while tem
    (initget "Copy mIrror mOve Quit Rotate Undo  ")
    (setq movend (getkword "\n>>>Copy/mIrror/mOve/Rotate/Undo/<Quit>: "))
    (cond
      ((= movend "Copy")
        (princ "\n\tSecond point of displacement: ")
        (setq p1 (nth 0 pt_list)
              ss (nth 0 ss_list)
        )
        (setq e (entlast))
        (while (entnext e)
          (setq e (entnext e))
        )
        (command "_.undo" "_m")
        (command "_.copy" ss "" p1 pause)
        (setq uctr (1+ uctr))
        (setq ss (ssadd))
        (while (entnext e)
          (setq e (entnext e))
          (setq b (entget e))
          (if (and (/= (fld_st 0 b) "VERTEX") (/= (fld_st 0 b) "SEQEND"))
            (ssadd e ss)
          )
        )
        (setq pt_list (cons (getvar "lastpoint") pt_list)
              ss_list (cons ss ss_list)
        )
      )
      ((= movend "mOve")
        (princ "\n\tSecond point of displacement: ")
        (setq p1 (nth 0 pt_list)
              ss (nth 0 ss_list)
        )
        (command "_.undo" "_m")
        (command "_.move" ss "" p1 pause)
        (setq uctr (1+ uctr))
        (setq pt_list (cons (getvar "lastpoint") pt_list)
              ss_list (cons ss ss_list)
        )
      )
      ((= movend "mIrror")
        (princ "\nFirst point of mirror line: ")
        (setq ss (nth 0 ss_list))
        (command "_.undo" "_m")
        (command "_.mirror" ss "")
        (setvar "cmdecho" 1)
        (command pause)
        (setq pt1 (getvar "lastpoint"))
        (command pause)
        (setq pt2 (getvar "lastpoint"))
        (setvar "cmdecho" 0)
        (command pause)
        (setq uctr (1+ uctr))
        (if (not (entnext e))
          (setq ang (angle pt1 pt2)
                p1  (inters pt1 pt2 (nth 0 pt_list)
                      (polar (nth 0 pt_list) (+ ang (dtr 90)) 100) nil)
                dl  (distance (nth 0 pt_list) p1)
                p1  (polar p1 (angle (nth 0 pt_list) p1) dl)
                pt_list (cons p1 pt_list)
                ss_list (cons ss ss_list)
          )
          (setq pt_list (cons (nth 0 pt_list) pt_list)
                ss_list (cons ss ss_list)
          )
        )
        (setq e (entlast))
        (while (entnext e)
          (setq e (entnext e))
        )
      )
      ((= movend "Rotate")
        (setq p1 (nth 0 pt_list)
              ss (nth 0 ss_list)
        )
        (command "_.undo" "_m")
        (princ "\n\t<Rotation angle>/Reference: ")
        (command "_.rotate" ss "" p1 pause)
        (setq uctr (1+ uctr))
        (setq pt_list (cons p1 pt_list)
              ss_list (cons ss ss_list)
        )
      )
      ((= movend "Undo")
        (command "_.undo" "_b")
        (if (= uctr 0)
          (setq tem nil temp T)
          (progn
            (setq uctr (1- uctr))
            (setq pt_list (cdr pt_list)
                  ss_list (cdr ss_list)
                  e       (nth 0 ss_list)
            )
            (setq e (ssname e 0))
            (while (entnext e)
              (setq e (entnext e))
            )
          )
        )
      )
      (T
        (setq tem nil cont nil)
      )
    )
  )
)

(defun C:CIMMOVER () (m:mover))


;================================================================
;                   다중 잘라내기                                
;================================================================
(defun m:MTRIM (/ bm uctr uctk CE SS LS NO PNT1 PNT2 temp tem ltype)

  (ai_err_on) 
  (ai_undo_on)
  (command "_.undo" "_group")
  
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n다중 잘라내기 명령입니다.")
  (setq bm (getvar "blipmode"))
  (setvar "BLIPMODE" 1)
  (setq temp T)
  (while temp
    (princ "\n>>> Select trim edge")
    (setq CE (ssget
               '((-4 . "<OR")
                  (0 . "LINE") (0 . "ARC") (0 . "CIRCLE") (0 . "*POLYLINE")
                (-4 . "OR>"))))
    (if (= ce nil)
      (exit);(alert "Entity not selected -- Try again.")
      (setq temp nil tem T)
    )
  )
  (while tem
    (princ "\n>>> Select objects to trim: ")
    (initget 1)
    (setq PNT1 (getpoint "\n\tFirst point:   "))
    (setq PNT2 (getpoint PNT1 "2nd point: "))
    (if (not pnt2)
      (progn
        (exit)
        (princ)
      )
    )
    (setq SS (ssget "F" (list pnt1 pnt2)
               '((-4 . "<OR")
                  (0 . "LINE") (0 . "ARC") (0 . "CIRCLE") (0 . "*POLYLINE")
                (-4 . "OR>"))))
    (if ss
      (progn
        (setq uctr T ls (sslength ss) no -1)
        (repeat ls
          (setq no (1+ no))
          (setq e (entget (ssname ss no)))
          (setq ltype (fld_st 6 e))
          (if (= ltype nil)
            (setq ltype (bylayerLtype e))
          )
          (if (and uctr (wcmatch ltype "CEN*"))
            (progn
              (initget 1 "Y N  ")
              (if (not (member mtm_y '("Y" "N"))) (setq mtm_y "Y"))
              (setq uctk (getkword (strcat
                           "\n중심선도 자르시겠습니까?<" mtm_y "> ")))
              (if (member uctk '("Y" "N")) (setq mtm_y uctk))
              (setq uctr nil)
            )
          )
          (if (= (fld_st 0 e) "*POLYLINE")
            (command "_.explode" (ssname ss no))
          )
        )
        (setq SS (ssget "F" (list pnt1 pnt2)
                   '((-4 . "<OR")
                      (0 . "LINE") (0 . "ARC") (0 . "CIRCLE")
                    (-4 . "OR>"))))
        (if (= mtm_y "N")
          (RMV)	  
        )
        (if (> (sslength ss) 0)
          (setq tem nil)
        )
      )
      (alert "Entity not selected -- Try again.")
    )
  )
  (setvar "CMDECHO" 0)
  (setq ls (sslength ss) no -1)
  (command "_.TRIM" CE "")
  (repeat LS
    (setq NO (1+ NO))
    (setq e (entget (ssname ss no)))
    (cond
      ((or (= (fld_st 0 e) "ARC") (= (fld_st 0 e) "CIRCLE"))
        (command (list (ssname SS NO) pnt2))
      )
      (T
        (command (list (ssname ss no)
                       (inters pnt1 pnt2 (fld_st 10 e) (fld_st 11 e)))
        )
      )
    )
  )
  (command "")
  
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ)
)

(defun C:CIMMTRIM () (m:mtrim))
(princ)

;===================================================
;                     회전 복사                     
;===================================================
(defun m:rotate_copy ( / temp ss dist pt1 pt2 ang ang_degree ent ss1)

  (setvar "CMDECHO" 0)
  (command "_.undo" "_group")
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n회전복사 명령입니다.")

  (defun *error* (s)
    (if (and (/= s "Function cancelled") (/= s "quit / exit abort"))
      (princ (strcat "\nError: " s))
    )
    (setvar "cmdecho" 0)
    (princ)
  )
  
  (setq temp T)
  (while temp 
    (prompt "\n>>> 회전복사할 객체 선택: ")
    (setq ss (ssget)) ; Select object to Rotate Copy
    
    (if ss 
      (progn 
        (setvar "OSMODE" 167)
        (setq pt1 (getpoint "\n기준점: "))
        (setq ang (getangle pt1 "\n회전 각도를 입력하세요: "))
	(setq ang_degree (* ang (/ 180 PI))) ; ROTATE명령시 사용할 degree각

	(setq pt2 (getpoint pt1 "\n회전복사 위치를 입력하세요: "))
	
	(setq ent (entlast)) ; mark up ss1
	(command "COPY" ss "" pt1 pt2)
	(setq ss1 (ssadd))
	(while (setq ent (entnext ent))
	  (ssadd ent ss1)
	)
	(command "ROTATE" ss1 "" pt2 ang_degree)
      ) ;end progn
      
      (setq temp nil)
    ) ;end if
  ) ;end while
  
  (command "_.undo" "_en")
  (setvar "CMDECHO" 1)
  (princ)
)
(defun C:CIMRC () (m:rotate_copy))
(princ)

;===================================================
;                     다중복사
;===================================================
(defun m:mcopy ( / temp ss tmp_dist dist pt1 pt2 ang)

  (ai_err_on) 
  (ai_undo_on)
  (command "_.undo" "_group")
  
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n다중 복사 명령입니다.")
  
  (setq temp T)
  (while temp 
    (setq tmp_dist 0)
    (prompt "\n>>> Select object to copy: ")
    (setq ss (ssget))
    
    (if ss 
      (progn 
        (setvar "OSMODE" 167)
        (setq pt1 (getpoint "\n기준점: "))
        (setq pt2 (getpoint pt1 "복사방향을 선택하세요. "))
        (setq ang (angle pt1 pt2))
        (while (and (setq dist (udist 1 "" "\n복사간격(if END=0) ? " dist pt1))
                 (/= dist 0.0)
               )
          (setq tmp_dist (+ tmp_dist dist))
          (setq pt2 (polar pt1 ang tmp_dist))
          (command "COPY" ss "" pt1 pt2)
        ) ;end while
      ) ;end progn
      
      (alert "Entity not selected -- Try again.")
    ) ;end if
    (if (= dist 0) (setq temp nil))
  ) ;end while
  
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ)
)
(defun C:CIMMC () (m:mcopy))
(princ)
;==============================================================
;         UDIST --- User interface distance function
;==============================================================
(defun udist (bit kwd msg def bpt / inp)
  (if def
    (setq msg (strcat "\n" msg " <" (rtos def) ">: ")
          bit (* 2 (fix (/ bit 2)))
    )
    (setq msg (strcat "\n" msg ": "))
  )
  (initget bit kwd)
  (setq inp
    (if bpt
       (getdist msg bpt)
       (getdist msg)
    )
  )
  (if inp inp def)
)  
(defun upoint (bit kwd msg def bpt / inp)
   (if def 
      (setq pts (strcat (rtos (car def)) "," (rtos (cadr def))
                        (if (and (caddr def) (= 0 (getvar "flatland")))
                            (strcat "," (rtos (caddr def)))
                            ""
                         )
                 )
             msg (strcat "\n" msg " <" pts ">: ")
             bit (* 2 (fix (/ bit 2)))
       )
       (setq msg (strcat "\n" msg ": "))
    )
    (initget bit kwd)
    (setq inp (if bpt
                  (getpoint msg bpt)
                  (getpoint msg)
              )
    )
    (if inp inp def)
);def upoint

;=====================================================================
;                      다중 fillet
;=====================================================================
(defun m:mfillet (/ temp pt1 pt2 ss ss_list hor_ss ver_ss hor_dist ver_dist 
                    hor_ent ver_ent len)
  (ai_err_on) 
  (ai_undo_on)
  (command "_.undo" "_group")
  
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n다중 모깎기 명령입니다.")
  
  (setq temp T pt nil)
  (while temp
    (setq pt1 (getpoint "\n>>> First corner: "))
    (if pt1
      (progn
        (initget 1)
        (setq pt2 (getcorner pt1 "\n Other corner: "))
        (setq ss (ssget "C" pt1 pt2))
        (if ss
          (progn  
            (setq ss      (Check_line ss))
            (setq ss_list (Check_ang ss pt1)) 
            (if ss_list
              (progn
                (setq hor_ss (Check_dist pt1 (car  ss_list)))
                (setq hor_dist dist_list)
                (setq ver_ss (Check_dist pt1 (cadr ss_list)))
                (setq ver_dist dist_list)
              )
            )
            (if hor_ss (setq hor_ss (List_sort hor_dist hor_ss)))
            (if ver_ss (setq ver_ss (List_sort ver_dist ver_ss)))
            (if (and hor_ss ver_ss) 
              (progn
                (setq len 0)
                (repeat (length hor_ss)
                  
                  (setq hor_ent (nth len hor_ss))
                  (setq ver_ent (nth len ver_ss))
                  (command "Fillet" hor_ent ver_ent)
                  (setq len (+ len 1))
                )
              )  
            )
          )
        )    
      ) ; end progn
      (setq temp nil)
    ) ; end if
  ) ; end while 
  
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ)
)

(defun Check_line (ss / len ent e_list)
  (setq len 0)
  (repeat (sslength ss)
    (setq ent  (ssname ss len))
    (setq e_list (entget ent))
    (if (/= (cdr (assoc 0 e_list)) "LINE")
      (ssdel ent ss)
    )
    (setq len (+ len 1))
  )
  (setq ss ss)
)
(defun Check_ang (ss pt1 / len ss1 ss2  ent e_list stpt endpt ss_list ang1 ang2 ang3)
  (setq len 0)
  (setq ss1 (ssadd) ss2 (ssadd))
  (repeat (sslength ss)
    (setq ent (ssname ss len))
    (setq e_list (entget ent))
    (setq stpt (cdr (assoc 10 e_list)))
    (setq endpt (cdr (assoc 11 e_list)))
    (if (< (distance pt1 stpt) (distance pt1 endpt))
      (setq ang1 (angle stpt endpt))
      (setq ang1 (angle endpt stpt))
    )
    (if (= ang2 nil) (setq ang2 ang1))
    (if (= ang2 ang1)
      (ssadd ent ss1)
      (progn
        (if (= ang3 nil)  (setq ang3 ang1))
        (if (= ang3 ang1) (ssadd ent ss2))
      )
    )
    (setq len (+ len 1))
  )
  (setq ss_list (list ss1 ss2))
)
(defun Check_dist (pt1 ss / len ent e_list stpt endpt Tp1 ent_list)
  (setq len      0
        dist_list   '()
        ent_list '())
  (while (< len (sslength ss))
    (setq ent   (ssname ss len))
    (setq e_list (entget ent))
    (setq stpt  (cdr (assoc 10 e_list)))
    (setq endpt  (cdr (assoc 11 e_list)))
    (if (< (distance pt1 stpt) (distance pt1 endpt))
      (progn
        (setq dist_list   (append dist_list (list (distance pt1 stpt)))
              ent_list    (append ent_list (list ent)))
      )
      (progn
        (setq dist_list   (append dist_list (list (distance pt1 stpt)))
              ent_list    (append ent_list (list ent)))
      )
    )
    (setq len (+ len 1))
  )
  (setq ent_list ent_list)
)
(defun List_sort (dist ss / n lst lstx n1 n2 small memb rev xx)
  (setq n     0
        plist dist)
  (setq xx   (mapcar '(lambda (x) (setq n (1+ n))
                                  (list x n)
                      )
                      plist
             )
  )
  (setq   lst nil    pst '())
  (while (/= (length lst) (- (length plist) 1))
    (setq   small   (apply 'min (mapcar 'car xx)))
    (setq   memb    (assoc small xx))
    (setq   n1      (member (cadr memb) (mapcar 'cadr xx)))
    (setq   n2      (member (cadr memb) (mapcar 'cadr (reverse xx))))
    (setq   pst     (append pst (list (nth (- (car n2) 1) ss))))
    (setq   rev     (mapcar 'reverse xx))
    (setq   lst     (append lst (reverse (cdr (assoc (car n1) rev)))))
    (setq   lstx    nil)
    (if (cdr n1) (foreach n (cdr n1) (setq lstx (append lstx (list (assoc n rev))))))
    (if (cdr n2) (foreach n (cdr n2) (setq lstx (append lstx (list (assoc n rev))))))
    (setq  xx    (mapcar 'reverse lstx))
  );End of while
  (setq lst (append lst (list (nth 0 (car xx)))))
  ;(if (= sym <) lst (reverse lst))
  (setq ss (append pst (list (nth (- (cadr (car xx)) 1) ss))))
)

(defun C:CIMMF () (m:mfillet))
(princ)

;================================================================================
;                      불연속 간격 띄우기                                        
;================================================================================
(defun C:CIMMFF ( / ent spt tdist dist)
  (ai_err_on) 
  (ai_undo_on)
  (command "_.undo" "_group")
  
   (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
   (princ "\n불연속 간격 띄우기 명령입니다.")
   (setq tdist 0
         ent (entsel "\n옵셋할 객체를 선택하십시오: ")
         spt (upoint 1 "" "옵셋 방향을 지정하십시오." nil (cadr ent))
   )
   (while (and
            (setq dist (udist 1 "" "\n옵셋 간격(if END=0) ? " dist nil))
            (/= dist 0.0))
        (setq tdist (+ tdist dist))
        (command "offset" tdist ent spt "")
   )
  
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
   (princ)
)


;========================================================================
;               다중 간격 띄우기                                         
;========================================================================
(defun m:MOF ( / bm uctr  ENT SPT DIST1 k_t)

  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n다중 간격 띄우기 명령입니다.")
  (setvar "orthomode" 0)
  (setvar "osmode" 0)    
  (if (/= (type #MDIST) 'REAL) (setq #MDIST 100))
  (initget (+ 2 4))
  (setq #MDIST (UDIST 1 "" "옵셋 간격을 입력하십시오." #MDIST nil))
  (setq temp T uctr 0)
  (while temp
    (setq tem T)
    (while tem
      (if (= uctr 0)
        (progn
          (initget " ")
          (setq ENT (entsel)) ; 객체 선택:
          (cond
            ((not ent)
              (alert "Entity not selected -- Try again.")
              (princ "\n")
            )
            ((= ent "")
              (exit)
            )
            (T
              (setq e (entget (car ent)))
              (if (and (/= (fld_st 0 e) "LINE")   (/= (fld_st 0 e) "ARC")
                       (/= (fld_st 0 e) "CIRCLE") (/= (fld_st 0 e) "POLYLINE")
		       (/= (fld_st 0 e) "LWPOLYLINE") 
                  )
                (alert "Invalid entity selected -- Try again.")
                (progn
                  (setq tem nil)
                  (setq SPT (UPOINT 1 "" "옵셋 방향을 지정하십시오." nil (cadr ENT)))
                  (setq DIST1 #MDIST)
                )
              )
            )
          )
        )
        (progn
          (initget "Undo eXit")
          (setq k_t (getkword "\nUndo/eXit<계속>: "))
          (if (= k_t "Undo")
            (progn
              (entdel (entlast))
              (setq uctr (1- uctr))
            )
            (setq tem nil)
          )
	  (if (= k_t "eXit")
	      (setq temp nil)
	  )  
        )
      )
    )
    (if (/= temp nil)
      (progn
         (setvar "cmdecho" 0)
         (setq uctr (1+ uctr))
         (command "_.OFFSET" (* uctr DIST1) ENT SPT "")
         (princ (strcat "\n" (itoa uctr) " 번째 입니다.\n"))
      )
    )  
  )

  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  
  (princ)
)


(defun C:CIMMOF () (m:mof))
(princ)


;====================================================================
;             현재 도면층으로 offset                                 
;====================================================================
(defun m:OFC ( / uctr ENT SPT DIST1)

  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n현재 도면층으로 간격 띄우기 명령입니다.")
  (setvar "orthomode" 0)
  (setvar "osmode" 0)
  (if (/= (type #MDIST) 'REAL) (setq #MDIST 20))
  (initget (+ 2 4))
  (setq #MDIST (UDIST 1 "" "옵셋 간격을 입력하십시오" #MDIST nil))
  (setq temp T uctr 0)
  (while temp
    (setq tem T)
    (while tem
      (initget " ")
      (setq ENT (entsel)); 객체 선택
      (cond
        ((not ent)
          (alert "Entity not selected -- Try again.")
          (princ "\n")
        )
        ((= ent "")
          (exit)
        )
        (T
          (setq e (entget (car ent)))
          (if (and (/= (fld_st 0 e) "LINE")   (/= (fld_st 0 e) "ARC")
                   (/= (fld_st 0 e) "CIRCLE") (/= (fld_st 0 e) "POLYLINE")
              )
            (alert "Invalid entity selected -- Try again.")
            (setq tem nil)
          )
        )
      )
    )
    (setq SPT (UPOINT 1 "" "옵셋 방향을 지정하십시오" nil (cadr ENT)))
    (if (not spt)
      (exit)
    )
    (setq DIST1 #MDIST)
    (setvar "cmdecho" 0)
    (command "_.OFFSET" DIST1 ENT SPT "")
    (setq uctr (1+ uctr))
    (CCO)
    (CLA)
    (CLT)
    (princ (strcat "\n" (itoa uctr) " 번째 입니다.\n"))
  )

  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)

  (princ)
)


(defun C:CIMOFC () (m:ofc))
(princ)


;=======================================================================
;                        offset후 erase                                 
;=======================================================================
(defun m:OFE ( / uctr  ENT SPT DIST1)

  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n객체를 offset하고난 후 erase하는 명령입니다.")  
  (setvar "orthomode" 0)
  (setvar "osmode" 0)    
  (if (/= (type #MDIST) 'REAL) (setq #MDIST 100))
  (initget (+ 2 4))
  (setq #MDIST (UDIST 1 "" "옵셋 간격을 입력하십시오" #MDIST nil))
  (setq temp T uctr 0)
  (while temp
    (setq tem T)
    (while tem
      (initget " ")
      (setq ENT (entsel)); 객체 선택
      (cond
        ((not ent)
          (alert "Entity not selected -- Try again.")
          (princ "\n")
        )
        ((= ent "")
          (exit)
        )
        (T
          (setq e (entget (car ent)))
          (if (and (/= (fld_st 0 e) "LINE")   (/= (fld_st 0 e) "ARC")
                   (/= (fld_st 0 e) "CIRCLE") (/= (fld_st 0 e) "POLYLINE")
              )
            (alert "Invalid entity selected -- Try again.")
            (setq tem nil)
          )
        )
      )
    )
    (setq SPT (UPOINT 1 "" "옵셋 방향을 지정하십시오" nil (cadr ENT)))
    (if (not spt)
      (exit)
    )
    (setq DIST1 #MDIST)
    (setvar "cmdecho" 0)
    (command "_.OFFSET" DIST1 ENT SPT "")
    (command "_.erase" ent "")
    (setq uctr (1+ uctr))
    (princ "\n")
  )

  
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)

  (princ)
)

(defun C:cimOFE () (m:ofe))
(princ)


;=========================================================================================
;                                교차선 정리                                              
;=========================================================================================
(defun poly_explode( _pt1 _pt2 / e k)
  (setq ss (ssget "C" _pt1 _pt2
             '((-4 . "<OR") (0 . "LINE") (0 . "*POLYLINE") (-4 . "OR>")))) 
  
  (if (null ss) (exit))
    (progn
      (RMV)
      (setq k 0)
      (repeat (sslength ss)
        (setq e (entget (ssname ss k)))
        (if (wcmatch (fld_st 0 e) "*POLYLINE")
          (command "_.explode" (ssname ss k))
        )
        (setq k (1+ k))
      )
   )
  
)


(defun m:XT (/ temp strtpt pcs pcs1 pce ss ls ss1 ss2 pt_olist ent_list count wall_n ppt1 ppt2 ppt3 innerended? )
  (ai_err_on) 
  (ai_undo_on)
  (command "_.undo" "_group")
  (command "_fillet" "R" 0)
  (princ "\nArchiFree 2002 AutoCAD LT 2002.")
  (princ "\n벽체 및 다른 선들이 교차하는 것을 정리하고자 할 경우에 사용하는 명령입니다.")
  
  (setvar "osmode" 0)
  (while (null temp)
	  (initget "3points")
	  (setq pcs (getpoint "\n3points/<Pick first corner>...   "))
	  (if (null pcs) (exit))
	  (if (= pcs "3points")
	    (progn
	    	(setq pcs (getpoint "\nPick first point... "))
	        (if (null pcs) (exit))
	        (setq pcs1 (getpoint pcs "\nPick second point... "))
	        (if (null pcs1) (exit))
	        (setq pce (getpoint pcs1 "\nPick third point... "))
	        (if (null pce) (exit))
	        (setq pt_olist (list pcs pcs1
			         pce (polar pce (angle pcs1 pcs) (distance pcs pcs1))))
	     )
	    (progn
	    	(setq pce (getcorner pcs "Pick other corner... "))
	        (if (null pce) (exit))
	        (setq pt_olist (list pcs (list (car pce) (cadr pcs) (caddr pcs))
			         pce (list (car pcs) (cadr pce) (caddr pcs))))
	     )
	  )
	    
	    (poly_explode pcs pce)
	    
	    (setq innerended? nil)
	    (repeat 2
		    (setq nnn 1)
		    (repeat 4
		      (setq ppt1 (nth (1- nnn) pt_olist)
			    ppt2 (nth (rem nnn 4) pt_olist)
			    ppt3 (nth (rem (1+ nnn) 4) pt_olist)
		      )
		      (if (and  (not (null (setq ss1 (ssget "F" (list ppt1 ppt2) '((0 . "LINE"))))
					   ))	  
			  	(not (null (setq ss2 (ssget "F" (list ppt2 ppt3) '((0 . "LINE"))))
					   ))	     
			  	(= (progn (setq ss ss1)(rmv) ) (progn (setq ss ss2)(rmv) ))
			  )
		         (if innerended? (xt_fillet_1) (xt_brk_1) )
			);end if
		      (setq nnn (1+ nnn))
		    );end inner repeat
	      (command "_.ERASE" "_W" pcs pce "")
	      (setq innerended? T)
	    );end outter repeat
	    
  );end while
  
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ)
)
(defun xt_brk_1()
	(setq ss  (ssget "F"
			(list ppt1 ppt2 ppt3)
			'((0 . "LINE"))
		  )
	)
	(RMV)
	(setq wall_n (/ (sslength ss) 2))
	 
	(setq count 0 ent_list nil )
	(repeat (sslength ss) 
	 	(setq ent_list (cons (ssname ss count) ent_list)
		      count (1+ count))
	)
	(setq ent_list (reverse ent_list))
	(setq count 0)
  
	(repeat (/ wall_n 2)
		
		(command "_break" (setq ent1 (nth (+ count wall_n) ent_list))
			      (ent_inters (entget ent1) (entget (nth count ent_list)))
			      (ent_inters (entget ent1) (entget (nth (- (1- wall_n) count) ent_list)))
		)
		(setq count (1+ count))
	)
	
)

(defun xt_fillet_1()
	(setq ss  (ssget "F"
			(list ppt1 ppt2 ppt3)
			'((0 . "LINE"))
		  )
	)
	(RMV)
	(setq wall_n (/ (sslength ss) 2))
	 
	(setq count 0 ent_list nil )
	(repeat (sslength ss) 
	 	(setq ent_list (cons (ssname ss count) ent_list)
		      count (1+ count))
	)
	(setq ent_list (reverse ent_list))
	(setq count 0)

	(repeat (/ wall_n 2)
		(command "_fillet" (nth (- (1- wall_n) count) ent_list)
			      	   (nth (+ wall_n count) ent_list)
		)
		(setq count (1+ count))
	)
)

(defun ent_inters (ent1 ent2 / ep1 ep2 tp1 tp2)
  (setq ep1 (cdr (assoc 10 ent1))
	ep2 (cdr (assoc 11 ent1))
	tp1 (cdr (assoc 10 ent2))
	tp2 (cdr (assoc 11 ent2))
  )
  (inters ep1 ep2 tp1 tp2 nil)
)
(defun C:CIMXT () (m:xt))
(princ)


;==================================================================
;              각도로 회전하기                                     
;==================================================================
(defun m:CHA (/ ss p1 a1 a2 a3 )
  (ai_err_on) 
  (ai_undo_on)
  (command "_.undo" "_group")
  
  (if (= cha:ang nil)(setq cha:ang 0))
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n객체에 각도를 주어서 회전하는 명령입니다.")
  (setvar "cmdecho" 0)
  (setvar "blipmode" 1)
  (setq ss (ssget))
  (if (= ss nil) (progn (setvar "cmdecho" 1) (exit)))
  (setvar "osmode" 1)
  (initget 1)
  (setq p1 (getpoint "기준점 지정: "))
  (setvar "osmode" 512)
  (initget "Reference")
  (setq a1 (getangle p1 "\n회전 각도 지정 또는 [참조(R)]: "))
  (if (/= a1 nil)
    (progn
      (if (/= a1 "Reference")
        (progn
          (princ (rtd a1))
          (command "_.rotate" ss "" p1 (rtd a1))
        )  
        (progn
          (setq a2 (getangle (strcat "\n참조 각도를 지정 <" (rtos cha:ang) ">: ")))
          (if (/= a2 nil)
            (progn
	      (setvar "cmdecho" 1)(princ (rtd a2))(setvar "cmdecho" 0)
	      (setq a3 (getangle p1 "\n새로운 각도를 지정: "))
              (if (and (/= a2 nil) (/= a3 nil))
		(progn 
                  (command "_.rotate" ss "" p1 "r" (rtd a2) (rtd a3))
		  (setq cha:ang (rtd a2))
		) 
	      )
            )
	    (progn
	      (setq a2 cha:ang)
	      (setq a3 (getangle p1 "\n새로운 각도를 지정: "))
              (if (and (/= a2 nil) (/= a3 nil))
                (command "_.rotate" ss "" p1 "r" a2 (rtd a3))
	      )
            )
          )
        )
      )
    )
  )
  
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ)
)

(defun C:CIMCHA () (m:cha))
(princ)


;===========================================================================
;                         블록 대체                                         
;===========================================================================
(defun m:blch (/ test e1 e bn sseto ssetn ls index rbn b1 b2 b3 d1 d2 yn)
  (ai_err_on) 
  (ai_undo_on)
  (command "_.undo" "_group")
  
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "이미 삽입되어 있는 블록을 새로운 블록으로 대치하는 명령입니다.")
  (setvar "blipmode" 1)
  (setq test T)
  (while test
    (setq e1 (entsel "\n바꾸고자 하는 블럭을 선택하십시오: "))
    (if (/= e1 nil)
      (progn
        (setq e (entget (car e1)))
        (if (/= (cdr (assoc 0 e)) "INSERT")
          (alert "블럭이 아닙니다. -- 다시 선택하십시오.")
	  (setq test nil)
        )
      )
      (alert "블럭이 선택되지 않았습니다. -- 다시 선택하십시오.")
    )
  )
  (setq bn (cdr (assoc 2 e))) ; get block name!
  (setq sseto (ssget "X" (list (cons 2 bn)))) 
  (setq ls (sslength sseto))
  (princ (strcat (itoa ls) " Block< " bn " > selected. "))
  (setq rbn (getfiled "교체할 블럭 찾기" "" "dwg" 2))
  (initget "Y N")
  (setq yn (getkword "\n모든 블록을 다 교체하시겠습니까?(Y/n) "))
  (if (= yn "N") ; 사용자가 선택한 블록을 sseto에서 가르치는 인덱스 찾음
    (progn
      (setq index 0)
      (repeat ls
	(if (= (cdr (assoc 5 e)) (cdr (assoc 5 (entget (ssname sseto index)))))
	  (setq bn_index index)
	)
	(setq index (1+ index))
      )	 
      (setq ls 1)
    )
  )
  (if (/= rbn nil)
    (progn
      (setvar "blipmode" 0)
      (setvar "cmdecho" 0)
      (command "_.INSERT" rbn (getvar "VIEWCTR") "" "" "")
      (setq ssetn (ssget "L"))
      (if (= yn "N") (setq index bn_index)(setq index 0))  
      (setq b2 (entget (ssname ssetn 0)))
      (setq d2 (assoc 2 b2))
      (entdel (entlast))
      (repeat ls
        (setq b1 (entget (ssname sseto index)))
        (setq d1 (assoc 2 b1))
        (setq b3 (subst d2 d1 b1))
        (entmod b3)
        (setq index (1+ index))
      )
    )
  )  
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ)
)

(defun C:CIMCHB () (m:blch))
(princ)

;===========================================================================
;                       모서리 정리                                         
;===========================================================================
(defun m:ccl (/ pt1 pt2 pt3 pt4  re n ss la lb a b)

  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")
  
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n모서리를 정리하는 명령입니다.")
  (setvar "BLIPMODE" 1)
  (command "fillet" "R" 0)
  ;(initget 1)
  (setq pt1 (getpoint "\n>>>Pick First Corner.....   "))
  (while (/= pt1 nil)
    (initget 1)
    (setq pt2 (getcorner pt1 "Other Corner... "))
    (setq pt3 (list (car pt2) (cadr pt1))
          pt4 (list (car pt1) (cadr pt2))
          n   0
          temp T
    )
    (while temp
      (cond
        ((= n 0) (setq pt_list (list pt1 pt4)))
        ((= n 1) (setq pt_list (list pt2 pt4)))
        ((= n 2) (setq pt_list (list pt2 pt3)))
        ((= n 3) (setq pt_list (list pt1 pt3)))
        (T (exit))
      )
      (setq ss (ssget "F" pt_list '((0 . "LINE"))))
      (if (and ss (> (rmv) 0)) ; (rmv)-ss에서 layer가 cen*이거나 linetype cen*인 entity 삭제
        (setq re n
              temp nil
        )
      )
      (setq n (1+ n))
    )
    (setq a ss la ls)
    (setq temp T n 0)
    (cond
      ((= re 0)
        (while temp
          (cond
            ((= n 0) (setq pt_list (list pt1 pt3)))
            ((= n 1) (setq pt_list (list pt2 pt4)))
            ((= n 2) (setq pt_list (list pt2 pt3)))
            (T (setq temp nil))
          )
          (setq ss (ssget "F" pt_list '((0 . "LINE"))))
          (if (and ss (> (rmv) 0))
            (setq temp nil)
          )
          (setq n (1+ n))
        )
      )
      ((= re 1)
        (while temp
          (cond
            ((= n 0) (setq pt_list (list pt2 pt3)))
            ((= n 1) (setq pt_list (list pt1 pt3)))
            (T (setq temp nil))
          )
          (setq ss (ssget "F" pt_list '((0 . "LINE"))))
          (if (and ss (> (rmv) 0))
            (setq temp nil)
          )
          (setq n (1+ n))
        )
      )
      ((= re 2)
        (setq ss (ssget "F" (list pt1 pt3) '((0 . "LINE"))))
        (if ss (RMV))
      )
    )
    (if (or (= re 3) (= ss nil) (= ls 0))
      (progn
	;(princ "\nTHERE!!!")
        (repeat (/ la 2)
          (setq no (1+ no))
          (command "_.fillet" (ssname a no) (ssname a (- (1- la) no)))
        )
      )
      (progn
        (setq b ss lb ls)
        (setq ls (min la lb))
        (repeat ls
          (setq no (1+ no))
          (command "_.fillet" (ssname a no) (ssname b no))
        )
      )
    )
    (command "_.ERASE" "_W" pt1 pt2 "")
    (setq pt1 (getpoint "\n>>>Pick First Corner.....   "))
  )
  
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)

  (princ)
)

(defun C:CIMCCL () (m:ccl))
(princ)


;================================================================================
;                             부분 잘라내기                                      
;================================================================================
(defun m:CUTW (/ pt1 pt2 pt3 pt4 pb1 pb2 e  ss ls no inp kk temp
                 uctr ltype )
  
  (ai_err_on) 
  (ai_undo_on)
  (command "_.undo" "_group")
  
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n부분 잘라내기 명령입니다.")
  (setvar "OSMODE" 1)
  
  (setq pt1 (getpoint "\nPick First corner:   "))
  (if (null pt1) (exit))
  (setq pt2 (getcorner pt1 "Pick Other corner: "))
  (if (null pt2) (exit))
  (setvar "BLIPMODE" 0)
  (setq pt3 (list (car pt2) (cadr pt1))
        pt4 (list (car pt1) (cadr pt2))
  )
  (setvar "cmdecho" 0)
  (setq ss (ssget "C" pt1 pt2 '((-4 . "<OR")
                                 (0 . "LWPOLYLINE") (0 . "INSERT")(0 . "POLYLINE")
                               (-4 . "OR>")))
  )
  (if ss
    (progn
      (setq temp T)
      (while temp
        (setq k 0 uctr 0)
        (repeat (sslength ss)
          (setq e (entget (ssname ss k)))
          (if (or (and (= (fld_st 0  e) "INSERT")
                       (= (fld_st 41 e) (fld_st 42 e))
                  )
                  (= (fld_st 0 e) "LWPOLYLINE")
		  (= (fld_st 0 e) "POLYLINE")
              )
            (progn
              (command "_.explode" (ssname ss k))
              (setq uctr (1+ uctr))
            )
          )
          (setq k (1+ k))
        )
        (if (= uctr 0)
          (setq temp nil)
        )
      )
    )
  )
  (setq ss (ssget "W" pt1 pt2))
  (if ss
    (command "erase" ss "")
  )
  (setq ss (ssget "C" pt1 pt2 '((0 . "LINE"))))
  (if ss
    (setq ls (sslength ss)
          no -1
    )
    (progn
      (setvar "cmdecho" 1)
      (exit)
    )
  )
  (while (< no (1- ls))
    (setq no (1+ no))
    (setq e (entget (ssname ss no)))
    (setq ltype (fld_st 6 e))
    (if (= ltype nil)
      (setq ltype (bylayerLtype e))
    )
    (if (wcmatch ltype "CEN*")
      (setq no ls kk "OK")
    )
  )
  (if (= kk "OK")
    (progn
      (initget 1 "Y N  ")
      (if (not (member mtm '("Y" "N"))) (setq mtm "Y"))
      (setq inp (getkword (strcat
                "\n중심선이 선택되었습니다. 자를까요? <" mtm "> ")))
      (if (member inp '("Y" "N")) (setq mtm inp))
      (if (= mtm "N") (RMV))
    )
  )
  (setq ls (sslength ss) no -1)
  (setvar "osmode" 0)
  (repeat ls
    (setq no (1+ no))
    (setq e (entget (ssname ss no)))
    (setq p10 (cdr (assoc 10 e))
          p11 (cdr (assoc 11 e))
    )
    (setq pb1 (inters pt1 pt3 p10 p11)
          pb2 (inters pt2 pt4 p10 p11)
    )
    (if (and (= pb1 nil) (= pb2 nil))
      (progn
        (setq pb1 (inters pt1 pt4 p10 p11)
              pb2 (inters pt3 pt2 p10 p11)
	)
        (if (= pb1 nil)
          (setq pb1 pb2 pb2 pt1)
        )
        (if (= pb2 nil)
          (setq pb2 pt2)
        )
      )
      (progn
        (if (and (= pb1 nil) pb2)
          (progn
            (setq pb1 pb2
                  pb2 (inters pt1 pt4 p10 p11))
            (if (= pb2 nil)
              (setq pb2 (inters pt2 pt3 p10 p11))
            )
            (if (= pb2 nil)
              (setq pb2 pt1)
            )
          )
        )
        (if (and (= pb2 nil) pb1)
          (progn
            (setq pb2 (inters pt2 pt3 p10 p11))
            (if (= pb2 nil)
              (setq pb2 (inters pt1 pt4 p10 p11))
            )
            (if (= pb2 nil)
              (setq pb2 pt2)
            )
          )
        )
      )
    )
    
    (command "_.break" (ssname ss no) pb1 pb2)
  )
  
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ)
)

(defun C:CIMCT () (m:cutw))
(princ)


;====================================================================
;                   작업축 원위치                                    
;====================================================================
(defun m:SNGP (/ snpax)
  
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n작업축을 원위치 시켜주는 명령입니다.")
  (if (/= (getvar "snapang") 0)
    (setq snpak 0
          snpa  (rtd (getvar "snapang"))
    )
  )
  (if (or (= snpak nil) (= spkx "no"))
    (progn
      (princ "\n저장된 작업축 각도가 없습니다. ")
      (setq snpak 0 spkx "no")
    )
  )
  (setq snpax snpak snpak snpa)
  (setvar "snapang" (dtr snpax))
  (princ (strcat "\n현 작업축 각도는 " (rtos snpax 2) "입니다."))
  (setq snpa snpax)
  (princ)
)

(defun C:CIMSNGP () (m:sngp))
(princ)


;====================================================================
;                   작업축 변경                                      
;====================================================================
(defun m:SSNG (/ a1 b1 snpk mp0 mp1)
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n작업축을 변경시켜 주는 명령입니다.")
  (setq spkx nil)
  (if (= snpa nil)
    (setq snpa (getvar "snapang")
          snpa (rtd snpa))
  )
  (setq snpak snpa)
  (princ "\n작업축 각도를 입력하거나 물체를 선택하십시오. ")
  (setq a1 (entsel))
  (if (= a1 nil)
    (progn
      (setq snpk (getreal (strcat "작업축 각도 입력 <" (rtos snpa 2) ">: ")))
      (if (numberp snpk) (setq snpa snpk))
      (setvar "snapang" (dtr snpa))
    )
    (progn
      (setq b1 (entget (car a1)))
      (setq mp0 (cdr (assoc 10 b1)))
      (setq mp1 (cdr (assoc 11 b1)))
      (setq snpa (angle mp0 mp1)
            snpa (rtd snpa)
      )
      (if (>= snpa 180) (setq snpa (- snpa 180)))
      (setvar "snapang" (dtr snpa))
      (print)
    )
  )
  (princ (strcat "\n현 작업축 각도는 " (rtos snpa 2) "입니다."))
  (princ)
)
(defun C:CIMSSNG () (m:ssng))
(princ)


;====================================================================
;                 라인타입 & 색상 변경                               
;====================================================================
(defun m:CLT (/ a1 a2 n index b1 b2 d1 d2 b3)
  (ai_err_on) 
  (ai_undo_on)
  (command "_.undo" "_group")
  
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n객체 선택을 통해 라인타입을 변경하는 명령입니다.")
 
  (setvar "blipmode" 1)
  (setvar "cmdecho" 0)
  (princ "\n>>> 변경하고자 하는 라인을 선택하십시오.")
  (while (= a1 nil)
    (setq a1 (ssget))
  )
  (princ "\n>>> 새로운 라인타입을 선택하십시오.")
  (while (= a2 nil)
    (setq a2 (entsel))
  )
  (setq n (sslength a1))
  (setq index 0)
  (setq b2 (entget (car a2)))
  (setq l2 (assoc 8 b2))
  (setq d2 (assoc 6 b2))
  (if (not d2)
    (setq d2a (laltype (cdr l2)))
  )
  (repeat n
    (setq b1 (entget (ssname a1 index)))
    (setq d1 (assoc 6 b1))
    (if (and d1 d2)
      (progn
        (setq b3 (subst d2 d1 b1))
        (entmod b3)
      )
      (if (not d2)
        (command "_.chprop" (ssname a1 index) "" "_LT" d2a "")
        (command "_.chprop" (ssname a1 index) "" "_LT" (cdr d2) "")
      )
    )
    (setq index (+ index 1))
  )
  
  (princ (strcat "\n\t적용된 라인타입: " (if d2 (cdr d2) d2a)))

  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ)
)
(defun C:CIMCLT () (m:clt))
(princ)


;====================================================================
(DEFUN m:ZZ (ZN) 
  (SETQ XY (CDR (GETVAR "LIMMAX"))) 
  (SETQ YO (APPLY '+ XY))
  (SETQ XM (CDR (GETVAR "LIMMIN"))) 
  (SETQ YM (APPLY '+ XM))
  (SETQ YD (/ (- YO YM) ZN)) 
  (SETQ CP (GETPOINT "\n중심점 지정 :"))
  (COMMAND "_.ZOOM" "_C" CP YD)
)

(DEFUN C:CIMZ4 ()
  (setvar "cmdecho" 0)
  (m:ZZ 16)
  (setvar "cmdecho" 1)
  (princ)
)

(DEFUN C:CIMZ3 ()
  (setvar "cmdecho" 0)
  (m:ZZ 8)
  (setvar "cmdecho" 1)
  (princ)
)

(DEFUN C:CIMZ2 ()
  (setvar "cmdecho" 0)
  (m:ZZ 4)
  (setvar "cmdecho" 1)
  (princ)
)

(DEFUN C:CIMZ1 ()
  (setvar "cmdecho" 0)
  (m:ZZ 2)
  (setvar "cmdecho" 1)
  (princ)
)

(defun c:cimcdedit(/ txt ss)
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n치수를 수정하는 명령입니다.")
	(setq txt (getstring "\n변경될 치수를 입력하십시오: "))
	(prompt "바꾸고자 하는 치수를 선택하십시오: ")
	(setq ss (ssget))
	(setvar "cmdecho" 0)
	(command "_dim1" "_newtext" txt ss "")
  	(setvar "cmdecho" 1)
  	(princ)
)

(defun c:cimcdnew(/ txt ss)
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n변경된 치수를 원래의 치수로 복구해주는 명령입니다.")
	(prompt "\n복구 할 치수를 선택하십시오: ")
	(setq ss (ssget))
	(setvar "cmdecho" 0)
	(command "_dim1" "_newtext" "" ss "")
  	(setvar "cmdecho" 1)
	(princ)
)




