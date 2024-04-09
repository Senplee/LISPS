;수정날짜 :2001.8.13 
;작업자 :박율구
;명령어 c:cimFST 기초태그 심볼
;        c:cimCST 기둥 태그 심볼
;        c:cimGST 보 태그 심볼
;        c:cimWST 벽 태그 심볼
;        c:cimSST 슬라브 태그 심볼
;수정사항 ; 파일을 전부 합치고, 모듈화. 대화식(\nStyle/Height/Number< >)형태로, 번호 자동증가 추가

;단축키 관련 변수 정의 부분
(setq lfn17 1)

(defun m:ssymbol (m:ssym_cmd / cts tst tx cec lt p1 fts STK omode snum tstr
                  )
 (ai_err_on)
 (ai_undo_on)
 (command "_.undo" "_group")
 (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
 (cond
  ((= m:ssym_cmd "fs")
   (princ "\n기초 심볼태그를 그리는 명령입니다.")
   (setq ssym:name FST:text)
  )
  ((= m:ssym_cmd "cts")
   (princ "\n기둥 심볼태그를 그리는 명령입니다.")
   (setq ssym:name CTS:text)
  )
  ((= m:ssym_cmd "gr")
   (princ "\n보 심볼태그를 그리는 명령입니다.")
   (setq ssym:name GST:text)
  )
  ((= m:ssym_cmd "rw")
   (princ "\n벽 심볼태그를 그리는 명령입니다.")
   (setq ssym:name WST:text)
  )
  ((= m:ssym_cmd "sl")
   (princ "\n슬라브 심볼태그를 그리는 명령입니다.")
   (setq ssym:name SST:text)
  )
 )
  
 
  (setvar "blipmode" 1)
  (setq lt (getvar "dimscale"))
  (if (null ssym:ts) (setq ssym:ts 3))
  (setq tx (* ssym:ts lt))
  (setq snum (atoi (what_num ssym:name)))
   (ssymbol_m1)

(cond
  ((= m:ssym_cmd "fs")
   (setq FST:text ssym:name )
  )
  ((= m:ssym_cmd "cts")
   (setq CTS:text ssym:name )
  )
  ((= m:ssym_cmd "gr")
   (setq GST:text ssym:name )
  )
  ((= m:ssym_cmd "rw")
   (setq WST:text ssym:name )
  )
  ((= m:ssym_cmd "sl")
   (setq SST:text ssym:name )
  )
)
  
  (command "_.undo" "_en")

  
  (ai_err_off)
  (ai_undo_off)
  (princ)
)

(defun ssymbol_m1 (/ temp strtpt prenum pretxt)
  (setq temp T)
  (while temp
  
    (initget "Style Height Number Auto")
    (setvar "osmode" 33)
    (setq strtpt (getpoint
      (strcat "\nStyle/Height/Auto_numbering<" sym:autonum ">/Number<" ssym:name ">/<insert point>: ")))
    (setvar "blipmode" 0)
    (setvar "osmode" 0)
    (cond
      ((= strtpt "Style")
        (ssy_Style)
      )
      ((= strtpt "Height")
        (ssy_Height)
      )
      ((= strtpt "Number")
        (ssy_Number)
      )
      ((= strtpt "Auto")
        (ssy_auto)
      )      
      ((null strtpt)
          (setq temp nil)
      )
      (T
       (setq p1 strtpt)
       
        (setq prenum (itoa snum))
       (if (> snum -1)
         (progn
                  (setq pretxt (substr ssym:name 1 (- (strlen ssym:name) (strlen (itoa snum)))))
                  (setq ssym:name (strcat pretxt prenum))
         )
        )
       (ssymbol_draw)
      )
    );end cond
    
  
 ) ;end while


)
(defun ssy_Style (/)
  (if (/= (type STY) 'STR) (setq STY (getvar "textstyle")))
  (setq STK (strcase (getstring
            (strcat "\nEnter Text Style<" STY ">: "))))
  (if (/= STK "") (setq STY STK))
  (setvar "CMDECHO" 0)
  (if (= (stysearch STY) nil)
    (styleset STY)
  )
  (command "dim1" "style" STY)
)

(defun ssy_Height (/)
 ; (if (/= (type ts) 'REAL) (setq ts 3))
  (initget (+ 2 4))
  (setq tst (getreal (strcat "Enter Text Height <" (rtos ssym:ts 2) ">: ")))
  (if (numberp tst) (setq ssym:ts tst))
  (setq tx (* ssym:ts lt)) 
)

(defun ssy_auto (/ temss tmmt )
  (setq tmmt T)
  (while tmmt 
         (initget "ON OFF")
         (setq temss (getkword (strcat "\nAuto_numbering[ON/OFF]<" sym:autonum ">:")))
         (progn
             (cond
               ((= temss "ON")(setq sym:autonum "ON" tmmt nil))
               ((= temss "OFF")(setq sym:autonum "OFF" tmmt nil))
               ((= temss "")(setq tmmt nil))
             )
          )
         
  )
)

(defun ssy_Number ()
  (setq fts (getstring (strcat "\nEnter Value <" ssym:name ">: ")))
  (if (/= fts "")
   (progn
    (setq ssym:name fts)
     (setq snum (atoi (what_num ssym:name)))
   ) ;end progn
  )
 
)

(defun what_num(tstr / len o_len i ttmp chk return)
 (setq o_len (setq len (strlen tstr)))
 (setq ttmp T)
 (while (and ttmp (> len 0))
   (setq chk (substr tstr len 1))
   (setq ttmp (Isnum chk))
   (setq len (1- len))
 )
 (if (null ttmp) (setq len (1+ len)))
 (if (= (strlen tstr) len)
   (setq return "-1")
   (substr tstr (1+ len))
 )
)

(defun Isnum (chked / ty)
 (setq ty (ascii chked))
 (if (and (>= ty 48) (<= ty 57))
   T
   nil
 )
)
(defun ssymbol_draw (/ p2 pa pb pc pd)
; (while (/= p1 nil)
  (setvar "blipmode" 0)
  (setvar "osmode" 0)
  (SETLAY "SYMBOL")
  (command "color" "BYLAYER")
  (cond
    ((= m:ssym_cmd "fs")
          (command "_polygon" "5" p1 "I" (* 1.75 tx))
    )
    ((= m:ssym_cmd "cts")
        (command "_polygon" "6" p1 "I" (* 1.75 tx))
    )
    ((= m:ssym_cmd "rw")   
        (command "_insert" "*rw" p1 (/ tx 6) 0)
    )
    ((= m:ssym_cmd "sl")
        (setq p2 (polar p1 0 (* 2 tx)))
            (command "_ellipse" "C" p1 p2 tx)
    )
    (T (command "_rectangle" (polar (polar p1 (* pi 1.5) tx) pi (* 1.75 tx))
                             (polar (polar p1 (* pi 0.5) tx) 0 (* 1.75 tx))))
  )
  (command "color" co_3)
  (command "text" "m" p1 tx "0" ssym:name)
  (command "color" cec)
  (RTNLAY)
  (if (and (= sym:autonum "ON")(> snum -1))
    (progn
          (setq snum (1+ snum))
            (setq ssym:name (strcat pretxt (itoa snum)))
     )
  )
  
  ; (setq p1 (getpoint "\n>>>Pick Insertion Point of FTG. Symbol: "))
 ;)
)
(if (null sym:autonum) (setq sym:autonum "OFF"))
(if (null FST:text) (setq FST:text "F1"))
(if (null CTS:text) (setq CTS:text "C1"))
(if (null GST:text) (setq GST:text "G1"))
(if (null WST:text) (setq WST:text "R1"))
(if (null SST:text) (setq SST:text "S1"))

 
(defun C:cimFST () (m:ssymbol "fs"))
(defun C:cimCTS () (m:ssymbol "cts"))
(defun C:cimGST () (m:ssymbol "gr"))
(defun C:cimWST () (m:ssymbol "rw"))
(defun C:cimSST () (m:ssymbol "sl"))
(princ)
