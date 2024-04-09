; 수정날짜: 2001.8.10
; 작업자: 박율구
; 명령어: CIMCNT 숫자 계산
;	  	CIMAP 알파벳 쓰기
;	  	CIMAL 호의 길이 구하기
;	  	CIMAT 연속되는 숫자 쓰기
;	  	CIMAS 연속되는 알파벳 쓰기
;		CIMPY 평으로 환산!
;		CIMM2 M2로 환산
;		CIMDDI
;단축키 관련 변수 정의 부분
(setq lfn01 1)


;=============================================================================
;                            숫자 계산                                        
;=============================================================================
(defun m:cnt (/ enx xx svk ss CVS lum k smx dmm temp ai_smx ai_smx1
                f1  f2 val p tjk e rr  ai_cm cnt_snp lumx)
  (princ "\nArchiFree 2002 for AutoCAD LT2002.")
  (princ "\n도면에 그려진 숫자를 이용하여 연산할 경우에 사용하는 명령입니다.")
  (setq cnt_snp (getvar "snapmode"))
  ;;
  ;; Internal error handler defined locally
  ;;

  (defun cnt_err (s)                   ; If an error (such as CTRL-C) occurs
                                      ; while this command is active...
    (if (/= s "Function cancelled")
      (if (= s "quit / exit abort")
        (princ)
        (princ (strcat "\nError: " s))
      )
    )
    (setvar "cmdecho" 0)
    (command "_.undo" "_en")
    (ai_undo_off)
    (if cnt_oer                        ; If an old error routine exists
      (setq *error* cnt_oer)           ; then, reset it 
    )
    (if cnt_snp (setvar "snapmode" cnt_snp))
    
    (setvar "highlight" 1)
    (setvar "blipmode" 1)
    (setvar "cmdecho" 1)
    (menucmd "s= ")
    (menucmd "s= ")
    (princ)
  )
  
  ;; Set our new error handler
  (if (not *DEBUG*)
    (if *error*                     
      (setq cnt_oer *error* *error* cnt_err) 
      (setq *error* cnt_err) 
    )
  )

  (setvar "cmdecho" 0)
  (ai_undo_on)
  (command "_.undo" "_group")
  (menucmd "S=X")
  (menucmd "S=CAL")
  (if (= sv +) (setq sv "+")) (if (= sv -) (setq sv "-"))
  (if (= sv *) (setq sv "*")) (if (= sv /) (setq sv "/"))
  (if (= svx nil) (setq svx "+"))
  (initget 1 "+ - * /  ")
  (if (or (= sv nil) (= sv "=")) (setq sv svx))
  (setq svk (getkword (strcat "\nSelect of (+ - * /) <" sv ">: ")))
  (if (member svk '("+" "-" "*" "/"))(setq sv svk))
  (setq xx nil val 0 rr nil)
  (setvar "snapmode" 0)
  (while (/= sv "=")
    (if (= sv "+")
      (progn
        (setq ss (ssget '((0 . "TEXT"))))
        (setq k 0)
        (if (and ss (> (sslength ss) 0))
          (repeat (sslength ss)
            (setq dmm (entget (ssname ss k)) f1 (assoc '1 dmm) smx (cdr f1))
            (if (instr smx "=")
              (setq smx (substr smx (1+ (instr smx "="))))
            )
            (ai_rem)
            (RMC)
            (if (= lum nil)
              (if (instr smx ".")
                (setq lum (- (strlen smx) (instr smx ".")))
                (setq lum 0)
              )
            )
            (if (and lum (instr smx ".") (> (- (strlen smx) (instr smx ".")) lum))
              (setq lum (- (strlen smx) (instr smx ".")))
            )
            (if (/= (setq ai_smx (atof smx)) 0)
              (setq val (+ val ai_smx))
            )
            (setq k (1+ k))
          )
        )
      )
      (progn
        (if (= sv "-") (setq sv -))
        (if (= sv "*") (setq sv *))
        (if (= sv "/") (setq sv / rr T))
        (if (= xx nil)
          (progn
            (setq temp T)
            (while temp
              (setq e (entsel "Select First Number/<None>: "))
              (if (and e (= (cdr (assoc 0 (entget (car e)))) "TEXT"))
                (progn
                  (setq dmm (entget (car e)))
                  (setq smx (cdr (assoc '1 dmm)))
                  (if (instr smx "=")
                    (setq smx (substr smx (1+ (instr smx "="))))
                  )
                  (ai_rem)
                  (RMC)
                  (if (instr smx ".")
                    (setq lum (- (strlen smx) (instr smx ".")))
                    (setq lum 0)
                  )
                  (if (/= (setq ai_smx (atof smx)) 0)
                    (setq temp nil)
                    (princ "\nInvalid value -- please ")
                  )
                )
                (if e (princ "\nInvalid value -- please "))
              )
              (if (= e nil)
                (progn
                  (initget 1)
                  (setq en (getreal (strcat "\nEnter first Number: ")))
                  (setq ai_smx en temp nil)
                )
              )
            )
            (prompt "\nValue is < ") (princ ai_smx) (princ " >.  ")
          )
          (setq ai_smx val)
        )
        (setq ai_smx1 ai_smx)
        (setq temp T)
        (while temp
          (setq e (entsel "Select Next Number/<None>: "))
          (if (and e (= (cdr (assoc 0 (entget (car e)))) "TEXT"))
            (progn
              (setq dmm (entget (car e)))
              (setq smx (cdr (assoc '1 dmm)))
              (if (instr smx "=")
                (setq smx (substr smx (1+ (instr smx "="))))
              )
              (ai_rem)
              (RMC)
              (if (= lum nil)
                (if (instr smx ".")
                  (setq lum (- (strlen smx) (instr smx ".")))
                  (setq lum 0)
                )
              )
              (if (and lum (instr smx ".") (> (- (strlen smx) (instr smx ".")) lum))
                (setq lum (- (strlen smx) (instr smx ".")))
              )
              (setq val (atof smx))
              (if (/= (atof smx) 0)
                (setq temp nil)
                (princ "\nInvalid value -- please ")
              )
            )
            (if e (princ "\nInvalid value -- please "))
          )
          (if (= e nil)
            (progn
              (initget (+ 2 4))
              (if (= en nil) (setq en 100))
              (setq enx (getreal (strcat "\nEnter Next Number (" (rtos en) "): ")))
              (if (numberp enx) (setq en enx))
              (setq val en temp nil)
            )
          )
        )
        (setq ai_smx ai_smx1)
        (setq val (sv ai_smx val))
      )
    )
    (prompt "\nValue is < ") (princ val) (princ " >.")
    (setq xx "ok")
    (if (= sv +) (setq sv "+"))
    (if (= sv -) (setq sv "-"))
    (if (= sv *) (setq sv "*"))
    (if (= sv /) (setq sv "/"))
    (initget 1 "+ - * / =  ")
    (if (= sv nil) (setq sv "+"))
    (setq svx sv)
    (setq svk (getkword (strcat "\nSelect of (+ - * / =) <" sv ">: ")))
    (if (member svk '("+" "-" "*" "/" "="))
      (setq sv svk)
    )
  )
  (setvar "snapmode" 1)
  (setq p (getpoint ">>>Point Location: "))
  (setvar "snapmode" cnt_snp)
  (if (/= p nil)
    (progn
      (if (or rr (= lum nil))
        (progn
          (initget 4)
          (if (= lum nil) (setq lum (getvar "luprec")))
          (setq lumx (getint (strcat "\nEnter decimal precision <" (itoa lum) ">: ")))
          (if (numberp lumx) (setq lum lumx))
        )
      )
      (if dmm 
        (setq th (assoc '40 dmm) th (cdr th))
        (setq th (getvar "textsize"))
      )
      (if (= ai_tj nil) (setq ai_tj "R"))
      (setq tjk (strcase (getstring (strcat
"\nText Justify Left/Center/Middle/Right/TL/TC/TR/ML/MC/MR/BL/BC/BR <" ai_tj ">: "))))
      (if (/= tjk "") (setq ai_tj tjk))
      (if (< val 0)
        (progn
          (COMMA (abs val) lum)
          (setq CVS (strcat "-" CVS))
        )
        (comma val lum)
      )
      (if (and (instr CVS "E") (instr CVS ","))
        (setq CVS (strcat (substr CVS 1 (1- (instr CVS ",")))
                          (substr CVS (1+ (instr CVS ","))))
        )
      )
      (if (= ai_cm "Y")
        (setq CVS (strcat "<" CVS ">"))
      )
      (if (= ai_tj "L")
        (command "_.TEXT" p th "" CVS)
        (command "_.TEXT" "_J" ai_tj p th "" CVS)
      )
    )
  )
  (command "_.undo" "_en")
  (ai_undo_off)
  (setvar "cmdecho" 1)
  (princ)
)

(defun ai_rem ()
  (if (= (instr smx "<") 1)
    (setq smx (substr smx 2) ai_cm "Y")
  )
  (if (/= (instr smx ">") nil)
    (setq smx (substr smx 1 (1- (instr smx ">"))) ai_cm "Y")
  )
)

(defun C:CIMCNT () (m:cnt))
(princ)



;=======================================================================
;                       알파벳 쓰기                                     
;=======================================================================
(defun m:ALPHABET (/ bm sc PT PT2 HG AN HM N2 plk STK LT NO LR)
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n알파벳 문자를 주어진 거리에 맞추어서 입력하는 명령입니다.")
  (setq bm (getvar "blipmode"))
  (setvar "blipmode" 1)
  (setq sc (getvar "dimscale"))
  (if (/= (TYPE NR) 'INT) (setq NR 65))
  (setq LT (- NR 1))
  (if (= NR 65) (setq LT 90))
  (if (= NR 97) (setq LT 122))
  (setq LR (getstring
  (strcat "\n이전의 마지막 문자<" (chr LT) "> 시작 문자<" (chr NR) ">: ")))
    (if (= LR "") (setq LR (chr NR)))
  (setq NR (ascii LR))
  (setq NO LR)
    (if (or
           (or (< NR 65) (> NR 122))
           (and (> NR 90) (< NR 97)))
        (progn
        (prompt "INVALID CHARACTER!")
        (exit))
    )
  (initget 1)
  (setq PT (getpoint "시작점: "))
  (if (/= (TYPE ZZ) 'REAL)
    (setq ZZ 0)
  )
  (if (/= (TYPE SANG) 'REAL)
     (setq SANG 0)
  )
  (setq PT2 (getpoint PT (strcat
           "\n간격지정<현재간격:" (rtos ZZ) " 현재각도:" (angtos SANG 0) ">: ")))
    (if (/= PT2 nil)
     (progn
      (setq XCORD (- (car PT2) (car PT)))
      (setq YCORD (- (cadr PT2)
       (cadr PT)))
      (setq X XCORD)
      (setq Y YCORD)
      (setq ZZ (distance PT PT2))
      (setq SANG (angle PT PT2)))
      (progn (setq XCORD X)
      (setq YCORD Y))
    )
  ; CIHS문자스타일을 검색해서 없으면 만들고 현 문자스타일로 꿈
  (if (not (stysearch "CIHS"))
         (progn
            (styleset "CIHS")
	    (setvar "TEXTSTYLE" "CIHS")
	 )
     )
  (if (/= (type STY) 'STR) (setq STY (getvar "textstyle")))
  (setq STK (strcase (getstring
            (strcat "\n문자스타일<" STY ">: "))))
  (if (/= STK "") (setq STY STK))
  (setvar "CMDECHO" 0)
  (if (= (stysearch STY) nil)
    (styleset STY)
  )
  (command "_.dim1" "_style" STY)
  (if (/= (type HT) 'REAL) (setq HT (* sc 3)))
  (initget (+ 2 4))
  (setq HG (getreal (strcat "문자크기<" (rtos HT) ">: ")))
  (if (numberp HG) (setq HT HG))
  (if (/= (type RT) 'REAL) (setq RT 0))
  (setq AN (getreal (strcat "각도<" (rtos RT) ">: ")))
  (if (numberp AN) (setq RT AN))
  (initget 1 "L C M R  ")
  (if (/= (type plc) 'STR) (setq plc "C"))
  (setq plk (getkword
          (strcat "문자기준점 <L>eft,<C>enter,<M>iddle,<R>ight <" plc ">? ")))   (if (/= plk "") (setq plc plk))
  (if (/= (type n) 'INT) (setq n 1))
  (initget (+ 2 4))
  (setq HM (getint (strcat "글자의 개수<" (itoa n) ">: ")))
  (if (numberp HM) (setq n HM))
  (setq N2 0)
  (setvar "blipmode" 0)
  (if (= plc "L")
    (while (/= N2 n)
      (COMMAND "_.TEXT" PT HT RT NO)
      (setq NR (+ NR 1))
        (if (OR (= NR 91) (= NR 123))
          (setq NR (- NR 26)))
      (setq NO (chr NR))
      (setq PT (list (+ XCORD (car PT))
        (+ YCORD (cadr PT))))
      (setq N2 (1+ N2))
    )
    (while (/= N2 n)
      (COMMAND "_.TEXT" plc PT HT RT NO)
      (setq NR (+ NR 1))
        (if (OR (= NR 91) (= NR 123))
          (setq NR (- NR 26)))
      (setq NO (chr NR))
      (setq PT (list (+ XCORD (car PT))
        (+ YCORD (cadr PT))))
      (setq N2 (1+ N2))
    )
  )
  (setvar "cmdecho" 1)
  (setvar "blipmode" bm)
  (princ)
)

(defun C:CIMAP () (m:ALPHABET))
(princ)


;=============================================================================
;                         호의 길이 구하기                                    
;=============================================================================
(defun m:ARCLEN (/ sc bm Unit Prec osmode EntList StrPt EndPt StrAng EndAng ChordLen
		   CenPt pt ola oco aa)

  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n호의 길이를 구하는 명령입니다.")
  (setq Unit  (getvar "LUNITS")
	sc    (getvar "dimscale")
        Prec  (getvar "LUPREC")
	ChordLen   nil
	circle_len nil
  )
  (setvar "LUPREC" 4)
  (ai_err_on)  
  (if (= al:lup nil)(setq al:lup (getvar "LUPREC")))
  (if (= al:the nil)(setq al:the 3))
  (if (= al:ang nil)(setq al:ang 0))
   
  (while (null EntList)
    (setq aa (car (entsel "\n원이나 호를 선택하십시오: ")))
    (if (/= aa nil)
      (progn
	(setq EntList (entget aa))
	(setq EntType (cdr (assoc 0 EntList)))
        (if (and (/= "ARC" EntType) (/= "CIRCLE" EntType))
          (progn
            (alert "원이나 호가 아닙니다!")
            (setq EntList nil)
          )
        )
      )
      (setq EntList nil)
    )
  )
  (cond
    ((= "CIRCLE" EntType)
      ;선택한 원의 중심점 추출
      (setq CenPt (cdr (assoc 10 EntList)))
      (setvar "OSMODE" 161)
      (setq circle_len (* 2 pi (cdr (assoc 40 EntList))))
      (setq StrPt (getpoint CenPt "\n호의 시작점을 선택하십시오(반시계방향으로 측정됩니다.): "))
      (if (not (null StrPt))
        (progn
          (initget 1)
          (setq
            EndPt  (getpoint CenPt "\n호의 끝점을 선택하십시오: ")
            StrAng (angle CenPt StrPt)
            EndAng (angle CenPt EndPt)
          )
          (princ "\n선택한 호의 길이는 ")
        )
        (progn
          (princ "\n측정된 호의 길이는 ")
          (setq ChordLen (* 2 PI (cdr (assoc 40 EntList))))
        )
      )
    )
    ((= "ARC" EntType)
      (setq
        StrAng (cdr (assoc 50 EntList))
        EndAng (cdr (assoc 51 EntList))
      )
      (princ "\n선택한 호의 길이는 ")
    )
  )
  (if (not (null StrAng))
    (if (> StrAng EndAng)
      (setq ArcAng (+ (- (* 2 PI) StrAng) EndAng))
      (setq ArcAng (- EndAng StrAng))
    )
  )
  
  (if (null ChordLen)
    (setq ChordLen (* PI (/ ArcAng (* 2 PI)) (* 2 (cdr (assoc 40 EntList)))))
  )
  (setq ChordLen (rtos ChordLen Unit 4))
  (princ ChordLen)
  (princ " 입니다.")
  (setvar "CMDECHO" 0)
  
  (al_dd)
  
  (setvar "blipmode" 1)
  (if (= al:insert T)
    (progn
      (setvar "osmode" 7)
      (setq pt (getpoint (strcat "\n>>> 삽입점을 선택하십시오: ")))
      (cond
	((= pt nil)       )
	(T
	 (setvar "cmdecho" 0)
	 (set_col_lin_lay text:tprop)
	 (command "_.text" "_m" pt (* sc al:the) al:ang
		  (if (= al:unit1 nil)
		    (if (= al:arc_cir T) ChordLen (rtos circle_len 2 al:lup))
		    (if (= al:arc_cir T)(strcat ChordLen al:unit)(strcat (rtos circle_len 2 al:lup) al:unit))
		  )
	 )	  
        )
      )
    )
  )
  (ai_err_off)  
  (setvar "LUPREC" Prec)
  (princ)
)
(defun al_dd(/ message) ; 이 대화상자는 CIMAHA(Area.lsp)에서 참조하여 만들었음.
  (setq old:alprop text:tprop )  	
    
  (if (= al:unit nil) (setq al:unit "mm"))  
  (setq dcl_id (ai_dcl "al")) ; load al.dcl
  (setq message (strcat "호(원)의 길이는 " ChordLen "입니다."))
  (if (not (new_dialog "al" dcl_id)) (exit))
  
  (start_list "pop_unit")
  (add_list "mm")(add_list "cm")(add_list "m")
  (end_list)
  
  (set_tile "t_top" message)
  (if (/= circle_len nil)
    (set_tile "t_top2" (strcat "선택한 윈의 원주는 " (rtos circle_len) "입니다."))
    (set_tile "t_top2" "호를 선택하셨습니다.")
  )
  ;(set_tile "t_layer" al:lay)
  ;(set_color al:col "t_color" "color_image")
  (set_tile "ed_point" (itoa al:lup))
  (set_tile "ed_size"  (itoa al:the))
  (set_tile "ed_angle" (itoa al:ang))
  (set_tile "rd_arc" "1")
  (if (= al:insert T)
    (progn
      (set_tile "tg_insert" "1")
      (if (= circle_len nil)(mode_tile "rd_cir" 1)(mode_tile "rd_cir" 0))
      (mode_tile "rd_arc" 0)
      (mode_tile "ed_point" 0)
      (mode_tile "ed_size" 0)
      (mode_tile "ed_angle" 0)
      (mode_tile "tg_unit" 0)
      (mode_tile "pop_unit" 0)
    )
    (progn
      (set_tile "tg_insert" "0")
      (mode_tile "rd_cir" 1)
      (mode_tile "rd_arc" 1)
      (mode_tile "ed_point" 1)
      (mode_tile "ed_size" 1)
      (mode_tile "ed_angle" 1)
      (mode_tile "tg_unit" 1)
      (mode_tile "pop_unit" 1)
    )
  )
  (action_tile "tg_insert" "(al_ins $value)")
  (action_tile "tg_unit"   "(al_unit $value)")
  ;==================================================================
  (set_tile al_prop_type "1")    
  (@get_eval_prop al_prop_type al:prop)     
  (action_tile "b_name"    	"(@getlayer)")
  (action_tile "b_color"   	"(@getcolor)(setq a b)")
  (action_tile "color_image" 	"(@getcolor)")
  (action_tile "c_bylayer" 	"(@bylayer_do T)"); T=color or nil=linetype  
  ;==================================================================
  ;(action_tile "bn_layer" "(al_layer)")
  ;(action_tile "bn_color" "(al_color)")
  ;(action_tile "color_image" "(al_color)")
  ;(action_tile "tg_bylayer" "(al_bylayer $value)")
  (action_tile "accept" 	"(al_dd_ok)")
  (action_tile "cancel" 	"(al_dd_cancel)")
  (start_dialog)
  (done_dialog)
 
)
(defun al_unit (value)
  (if (/= value "0")
    (setq al:unit1 T)
    (setq al:unit1 nil)
  )  
)
(defun al_ins (value)
  (if (/= value "0")
    (progn
      (mode_tile "rd_arc" 0)
      (if (= circle_len nil)(mode_tile "rd_cir" 1)(mode_tile "rd_cir" 0))
      (mode_tile "ed_point" 0)
      (mode_tile "ed_size" 0)
      (mode_tile "ed_angle" 0)
      (mode_tile "tg_unit" 0)
      (mode_tile "pop_unit" 0)
      (setq al:insert T)
    )
    (progn
      (mode_tile "rd_arc" 1)
      (mode_tile "rd_cir" 1)
      (mode_tile "ed_point" 1)
      (mode_tile "ed_size" 1)
      (mode_tile "ed_angle" 1)
      (set_tile  "tg_unit" "0")
      (mode_tile "tg_unit" 1)
      (mode_tile "pop_unit" 1)
      (setq al:insert nil)
    )
  )
)

(defun al_dd_ok()
   (prop_save al:prop)	
  (if (/= (get_tile "tg_insert") "0")
    (progn
      (setq al:insert T
            al:lup (atoi (get_tile "ed_point"))
	    al:the (atoi (get_tile "ed_size"))
	    al:ang (atoi (get_tile "ed_angle"))
      )
      ;(if (/= (get_tile "tg_unit") "0")
      ;  (setq al:unit (get_tile "ed_unit"))
      ;  (setq al:unit nil)
      ;)
      (if (/= (get_tile "rd_arc") "0")
        (setq al:arc_cir T)
        (setq al:arc_cir nil)
      )
      (if (/= (get_tile "tg_unit") "0") (setq al:unit1 T)(setq al:unit1 nil))
      (cond ((= "0" (get_tile "pop_unit")) (setq al:unit "mm"))
	    ((= "1" (get_tile "pop_unit"))
	     (setq al:unit "cm")(setq ChordLen (/ (atof ChordLen) 10.0))(setq ChordLen (rtos ChordLen))
	     (if (/= circle_len nil)(setq circle_len (/ circle_len 10.0)))
            )
	    ((= "2" (get_tile "pop_unit"))
	     (setq al:unit "m")(setq ChordLen (/ (atof ChordLen) 1000.0))(setq ChordLen (rtos ChordLen))
	     (if (/= circle_len nil)(setq circle_len (/ circle_len 1000.0)))
	    )
      )
    )  
    (setq al:insert nil) 
  )
  (setq ChordLen (rtos (atof ChordLen) 2 al:lup))
  (done_dialog)
)
(defun al_dd_cancel()
  (setq 
  	;al:lay dd_layer
	;al:col dd_color
	text:tprop old:alprop
	al:insert nil
  )
  (done_dialog)
)

;======================================================
(setq text:tprop  (Prop_search "text" "text"))
(setq al:prop '(text:tprop))

(if (null al_prop_type) (setq al_prop_type "rd_text"))
;======================================================

(defun C:CIMAL() (m:ARCLEN))
(princ)


;==========================================================
;            연속되는 숫자 쓰기                            
;==========================================================
(defun m:AUTON (/ bm sc P1 P2 plk AN HG HM NSS NII N2 STK)
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n연속되는 숫자를 기입하는 명령입니다.")
  (setq bm (getvar "blipmode"))
  (setvar "blipmode" 1)
  (setq sc (getvar "dimscale"))
  (initget 1)
  (setq p1 (getpoint "\n시작점: "))
  (if (/= (type zz) 'REAL)
    (setq zz 0)
  )
  (if (/= (type sang) 'REAL)
    (setq sang 0)
  )
  (setq p2 (getpoint p1 (strcat
    "\n간격지정<현재간격:" (rtos zz) " 현재각도:" (angtos sang 0) ">: ")))
  (if (= p2 nil) (setq p2 (polar p1 sang zz)))
  (if (/= p2 nil)
    (progn
      (setq XCORD (- (car p2) (car p1)))
      (setq YCORD (- (cadr p2) (cadr p1)))
      (setq X XCORD)
      (setq Y YCORD)
      (setq zz (distance p1 p2))
      (setq sang (angle p1 p2))
    )
    (progn (setq XCORD X) (setq YCORD Y))
  )
  (if (/= (type STY) 'STR) (setq STY (getvar "textstyle")))
  (setq STK (strcase (getstring
            (strcat "\n문자스타일<" STY ">: "))))
  (if (/= STK "") (setq STY STK))
  (setvar "CMDECHO" 0)
  (if (= (stysearch STY) nil)
    (styleset STY)
  )
  (command "_.dim1" "_style" STY)
  (if (= HT nil) (setq HT (* sc 2)))
  (initget (+ 2 4))
  (setq HG (getreal (strcat "\n문자크기<" (rtos HT) ">: ")))
  (if (numberp HG) (setq HT HG))
  (if (= RT nil) (setq RT 0))
  (setq AN (getint (strcat "각도<" (itoa RT) ">: ")))
  (if (numberp AN) (setq RT AN))
  (initget 1 "L C M R  ")
  (if (= plc nil) (setq plc "C"))
  (setq plk (getkword
          (strcat "기준점 <L>eft,<C>enter,<M>iddle,<R>ight <" plc ">? ")))    (if (/= plk "") (setq plc plk))
  (if (= n nil) (setq n 1))
  (setq HM n)
  (initget (+ 2 4))
  (setq n (getint (strcat "숫자의 개수<" (itoa n) ">: ")))
  (if (= n nil) (setq n HM))
  (if (= ns nil) (setq ns 1))
  (if (= ni nil)
    (setq np (1- ns))
    (setq np (- ns ni))
  )
  (setq nss (getint (strcat "이전의 마지막 숫자<" (itoa np) "> 시작 숫자<" (itoa ns) ">: ")))
  (if (numberp nss) (setq ns nss))
  (if (= ni nil) (setq ni 1))
  (initget 2)
  (setq nii (getint (strcat "숫자의 증가치<" (itoa ni) ">: ")))
  (if (numberp nii) (setq ni nii))
  (setq N2 0)
  (setvar "blipmode" 0)
  (if (= plc "L")
  (while (/= N2 n)
    (command "_.text" p1 HT RT ns)
    (setq ns (+ ns ni))
    (setq p1 (list (+ XCORD (car p1))
      (+ YCORD (cadr p1))))
    (setq N2 (1+ N2))
  )
  (while (/= N2 n)
    (command "_.text" plc p1 HT RT ns)
    (setq ns (+ ns ni))
    (setq p1 (list (+ XCORD (car p1))
      (+ YCORD (cadr p1))))
    (setq N2 (1+ N2))
  )
  )
  (setvar "cmdecho" 1)
  (setvar "blipmode" bm)
  (princ)
)

(defun C:CIMAT () (m:auton))
(princ)


;=========================================================
;                 계단 숫자 쓰기                          
;=========================================================
(defun m:AUTOS (/ bm sc P1 P2 temp plk AN HG HM NSS NII N2 STK)
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n계단 숫자 쓰기 명령입니다.")
  (setq bm (getvar "blipmode"))
  (setvar "blipmode" 1)
  (setq sc (getvar "dimscale"))
  (initget 1)
  (setq p1 (getpoint "\n시작점: "))
    (if (or (= zz nil) (= sang nil))
       (progn
         (setq zz 0)
         (setq sang 0)
       )
       (prin1)
    )
  (setq p2 (getpoint p1 (strcat
    "\n간격지정<현재간격:" (rtos zz) " 현재각도:" (angtos sang 0) ">: ")))
    (if (= p2 nil) (progn
      (setq p1 (list (car p1) (+ (cadr p1) sc)))
      (setq p2 (polar p1 sang zz)))
    )
    (if (/= p2 nil)
     (progn
      (setq p1 (list (car p1) (+ (cadr p1) sc)))
      (setq p2 (list (car p2) (+ (cadr p2) sc)))
      (setq XCORD (- (car p2) (car p1)))
      (setq YCORD (- (cadr p2) (cadr p1)))
      (setq X XCORD)
      (setq Y YCORD)
      (setq zz (distance p1 p2))
      (setq sang (angle p1 p2)))
      (progn (setq XCORD X) (setq YCORD Y))
    )
  (if (/= (type STY) 'STR) (setq STY (getvar "textstyle")))
  (setq STK (strcase (getstring
            (strcat "\n문자스타일<" STY ">: "))))
  (if (/= STK "") (setq STY STK))
  (setvar "CMDECHO" 0)
  (if (= (stysearch STY) nil)
    (styleset STY)
  )
  (command "_.dim1" "_style" STY)
  (if (= HT nil) (setq HT (* sc 2)))
  (initget (+ 2 4))
  (setq HG (getreal (strcat "\n문자크기<" (rtos HT) ">: ")))
  (if (numberp HG) (setq HT HG))
  (if (= RT nil) (setq RT 0))
  (setq AN (getint (strcat "각도<" (itoa RT) ">: ")))
  (if (numberp AN) (setq RT AN))
  (initget 1 "L C M R  ")
  (if (= plc nil) (setq plc "C"))
  (setq plk (getkword
          (strcat "문자기준점 <L>eft,<C>enter,<M>iddle,<R>ight <" plc ">? ")))    (if (/= plk "") (setq plc plk))
  (if (= n nil) (setq n 1))
  (setq HM n)
  (initget (+ 2 4))
  (setq n (getint (strcat "계단의 개수<" (itoa n) ">: ")))
  (if (= n nil) (setq n HM))
  (if (= ns nil) (setq ns 1))
  (if (= ni nil)
    (setq np (1- ns))
    (setq np (- ns ni))
  )
  (setq nss (getint (strcat "이전의 마지막 숫자<" (itoa np) "> 시작숫자<" (itoa ns) ">: ")))
  (if (numberp nss) (setq ns nss))
  (if (= ni nil) (setq ni 1))
  (initget 2)
  (setq nii (getint (strcat "숫자의 증가치<" (itoa ni) ">: ")))
  (if (numberp nii) (setq ni nii))
  (setq N2 0)
  (setvar "blipmode" 0)
  (if (= plc "L")
  (while (/= N2 n)
    (command "_.text" p1 HT RT ns)
    (setq temp p1)
    (setq temp (list (car temp)
		     (+ (/ HT 2) (cadr temp))
	       )
    )	  		     
    (command "_.circle" temp HT)
    (setq ns (+ ns ni))
    (setq p1 (list (+ XCORD (car p1))
      (+ YCORD (cadr p1))))
    (setq N2 (1+ N2))
  )
  (while (/= N2 n)
    (command "_.text" plc p1 HT RT ns)
    (setq temp p1)
    (setq temp (list (car temp)
		     (+ (/ HT 2) (cadr temp))
	       )
    )	  		     
    (command "_.circle" temp HT)
    (setq ns (+ ns ni))
    (setq p1 (list (+ XCORD (car p1))
                   (+ YCORD (cadr p1))
	     )
    )
    (setq N2 (1+ N2))
  )
  )
  (setvar "cmdecho" 1)
  (setvar "blipmode" bm)
  (princ)
)

(defun C:CIMAS () (m:autos))
(princ)

  
;=========================================================
;           면적을 평으로 계산 한다.                      
;=========================================================
(defun m:py (/ temp ss CVS lumx k ktx0 ktx smx dmm f1 f2 pt height tlayer tlen)
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n숫자를 평으로 계산하는 명령입니다.")

  (setvar "cmdecho" 0)
  (setq temp T)
  (while temp
    (setq ss (ssget '((0 . "*TEXT"))))
    (if ss
      (setq temp nil)
      (alert "Entity not selected -- Try again.")
    )
  )

  (initget 4)
  (if (/= (type lum) 'INT) (setq lum 2))
  (setq lumx (getint (strcat "소수점 이하 자릿수<" (itoa lum) ">: ")))
  (if (numberp lumx) (setq lum lumx))

  (initget 1 "Y N  ")
  (if (not (member kt0 '("Y" "N"))) (setq kt0 "Y"))
  (setq ktx0 (getkword (strcat "기존의 면적표기를 지우시겠습니까?<" kt0 "> ")))
  (if (member ktx0 '("Y" "N")) (setq kt0 ktx0))

  (if (or (= kt0 "N") (= kt0 "n"));괄호를 넣을지를 묻는 건 기존의 면적을 남길경우에만...
      (setq kt "Y")
      (progn
	  (initget 1 "Y N  ")
          (if (not (member kt '("Y" "N"))) (setq kt "Y"))
          (setq ktx (getkword (strcat "괄호()를 넣을까요?<" kt "> ")))
          (if (member ktx '("Y" "N")) (setq kt ktx))
      )
  )
  
  (setq k 0)
  ; '평'이라는 단위를 붙이기 위해 한글 문자 스타일 지정
  
  (if (not (stysearch "CIHS"))
      (progn
          (styleset "CIHS")
          (setvar "TEXTSTYLE" "CIHS")
      )
      (setvar "TEXTSTYLE" "CIHS")
  )
  
  
  (repeat (sslength ss)
    (setq dmm (entget (ssname ss k)) f1 (assoc '1 dmm) smx (cdr f1))
    (setq tlen (strlen smx)) ;문자열의 길이 저장
   
    (if (= (instr smx "(") 1)
      (setq smx (substr smx 2))
    )
    (if (/= (instr smx ")") nil)
      (setq smx (substr smx 1 (1- (instr smx ")"))))
    )
    (RMC)
    (if (/= (atof smx) 0)
      (progn
        (setq smx (/ (atof smx) 3.3058))
;(princ "ygpark")
        (if (< smx 0)
          (progn
;(princ "ygpark---")
            (comma (abs smx) lum)
            (setq CVS (strcat "-" CVS))
          )
          (COMMA smx lum)
        )
;(princ "ygpark+++")	
	(setq CVS (strcat CVS "평")) ; 면적에 평단위넣기
        (if (= kt "Y") ;괄호 넣기 여부 검사
          (setq CVS (strcat "(" CVS ")" ))
        )

	(if (= kt0 "N") ;기존의 면적 지움 여부 검사
	  (progn
	     ; 기존의 면적 옆에 평단위의 면적 록
	     (setq pt (cdr (assoc 10 dmm)))
	     (setq height (cdr (assoc 40 dmm)))
	     (setq tlayer (cdr (assoc 8 dmm)))
	     (setq pt (list (+ (* tlen height) (car pt))
	                    (cadr pt) 
		            (caddr pt)
		      )
	     )      
             (setvar "cmdecho" 0)
	     (setlay tlayer)
	     (command "text" pt height "" CVS)
	     (RTNLAY)
	     (setvar "cmdecho" 1)
	  )
	  (progn
	     ; 기존의 면적을 없애고 평단위의 면적 기록
             (setq f2 (subst (cons 1 CVS) f1 dmm))
             (entmod f2)
	  )
	)
      )
    )
    (setq k (1+ k))
  )
  (setvar "cmdecho" 1)
  (princ)
)

(defun C:CIMPY () (m:py))
(princ)


;==================================================================
;                   면적을 m2로 계산 한다.                         
;==================================================================
(defun m:m2 (/ temp ss CVS lumx k ktx0 ktx smx dmm f1 f2 pt height tlayer tlen) 
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n면적을 m2로 계산하는 명령입니다.")

  (setq temp T)
  (while temp
    (setq ss (ssget '((0 . "*TEXT"))))
    (if ss
      (setq temp nil)
      (alert "Entity not selected -- Try again.")
    )
  )
  
  (initget 4)
  (if (/= (type lum) 'INT) (setq lum 2))
  (setq lumx (getint (strcat "소수점 이하 자릿수<" (itoa lum) ">: ")))
  (if (numberp lumx) (setq lum lumx))

  (initget 1 "Y N  ")
  (if (not (member kt0 '("Y" "N"))) (setq kt0 "Y"))
  (setq ktx0 (getkword (strcat "기존의 면적을 지울까요?<" kt0 "> ")))
  (if (member ktx0 '("Y" "N")) (setq kt0 ktx0))

  (if (or (= kt0 "N") (= kt0 "n"));괄호를 넣을지를 묻는 건 기존의 면적을 지우지 않을경우에만...
      (setq kt "Y")
      (progn 
          (initget 1 "Y N  ")
          (if (not (member kt '("Y" "N"))) (setq kt "Y"))
          (setq ktx (getkword (strcat "괄호()를 넣을까요?<" kt "> ")))
          (if (member ktx '("Y" "N")) (setq kt ktx))
      )
  )
  
  (setq k 0)
  (repeat (sslength ss)
    (setq dmm (entget (ssname ss k)) f1 (assoc '1 dmm) smx (cdr f1))
    (setq tlen (strlen smx)) ;문자열의 길이 저장
   
    (if (= (instr smx "(") 1)
      (setq smx (substr smx 2))
    )
    (if (/= (instr smx ")") nil)
      (setq smx (substr smx 1 (1- (instr smx ")"))))
    )
    (RMC)
    (if (/= (atof smx) 0)
      (progn
        (setq smx (* (atof smx) 3.3058))
        (if (< smx 0)
          (progn
            (comma (abs smx) lum)
            (setq CVS (strcat "-" CVS))
          )
          (COMMA smx lum)
        )
	(setq CVS (strcat CVS "m2")) ; 면적에 M2단위넣기
        (if (= kt "Y") ;괄호 넣기 여부 검사
          (setq CVS (strcat "(" CVS ")" ))
        )
	(if (= kt0 "N") ;기존의 면적 지움 여부 검사
	  (progn
	     ; 기존의 면적 옆에 m2단위의 면적 기록
	     (setq pt (cdr (assoc 10 dmm)))
	     (setq height (cdr (assoc 40 dmm)))
	     (setq tlayer (cdr (assoc 8 dmm)))
	     (setq pt (list (+ (* tlen height) (car pt))
	                    (cadr pt) 
		            (caddr pt)
		      )
	     )      
             (setvar "cmdecho" 0)
	     (setlay tlayer)
	     (command "text" pt height "" CVS)
	     (RTNLAY)
	     (setvar "cmdecho" 1)
	  )
	  (progn
	     ; 기존의 면적을 없애고 m2단위의 면적 기록
             (setq f2 (subst (cons 1 CVS) f1 dmm))
             (entmod f2)
	  )
	)
      )
    )
    (setq k (1+ k))
  )
  (princ)
)

(defun C:CIMM2 () (m:m2))
(princ)




;=========================================================
;;;----------------------------------------------------------------------------
;;;
;;;   DDI.LSP   Version 0.5
;;;
;;;   Copyright (C) 1991-1993 by Korea CIM, LTD.
;;;      
;;;   Permission to use, copy, modify, and distribute this software 
;;;   for any purpose and without fee is hereby granted, provided 
;;;   that the above copyright notice appears in all copies and that 
;;;   both that copyright notice and this permission notice appear in 
;;;   all supporting documentation.
;;;      
;;;   THIS SOFTWARE IS PROVIDED "AS IS" WITHOUT EXPRESS OR IMPLIED
;;;   WARRANTY.  ALL IMPLIED WARRANTIES OF FITNESS FOR ANY PARTICULAR
;;;   PURPOSE AND OF MERCHANTABILITY ARE HEREBY DISCLAIMED.
;;;   
;;;----------------------------------------------------------------------------
;;;   DESCRIPTION
;;;
;;;   An AutoLISP implementation of the AutoCAD INSERT command with a dialogue
;;;   interface.  Answers the oft requested feature of being able to select
;;;   at Insert time either an internal or external drawing.
;;;
;;;   The user is presented with a dialogue allowing the selection from nested
;;;   dialogues of either an internal or external block.  Edit fields can be
;;;   used to enter or preset the insertion point, scale, and rotation angle,
;;;   or alternatively, these can be set dynamically as in the INSERT command.
;;;
;;;   
;;;----------------------------------------------------------------------------
;;;   Prefixes in command and keyword strings: 
;;;      "."  specifies the built-in AutoCAD command in case it has been           
;;;           redefined.
;;;      "_"  denotes an AutoCAD command or keyword in the native language
;;;           version, English.
;;;
;;;----------------------------------------------------------------------------
;;;
;;; ===========================================================================
;;; ===================== load-time error checking ============================
;;;

  (defun ai_abort (app msg)
     (defun *error* (s)
        (if old_error (setq *error* old_error))
        (princ)
     )
     (if msg
       (alert (strcat " Application error: "
                      app
                      " \n\n  "
                      msg
                      "  \n"
              )
       )
     )
     (exit)
  )

;;; Check to see if AI_UTILS is loaded, If not, try to find it,
;;; and then try to load it.
;;;
;;; If it can't be found or it can't be loaded, then abort the
;;; loading of this file immediately, preserving the (autoload)
;;; stub function.


;;========================================================================
;; 밑의 주석은 error file not find때문에 했음  (작업자:박율구)            
;;========================================================================
  ;;(cond
  ;;   (  (and ai_dcl (listp ai_dcl)))          ; it's already loaded.
  ;;
  ;;   (  (not (findfile "ai_utils.lsp"))                     ; find it
  ;;      (ai_abort "DDI"
  ;;                (strcat "Can't locate file AI_UTILS.LSP."
  ;;                        "\n Check lisp directory.")))
  ;;
  ;;   (  (eq "failed" (load "ai_utils" "failed"))            ; load it
  ;;      (ai_abort "DDI" "Can't load file AI_UTILS.LSP"))
  ;;)
;=====================여기까지===========================================


  ;(if (not (ai_acadapp))               ; defined in AI_UTILS.LSP
  ;    (ai_abort "DDI" nil)             ; a Nil <msg> supresses
  ;)                                    ; ai_abort's alert box dialog.

;;; ==================== end load-time operations ===========================


;;=======================================================================================
; DIMCOMMA.LSP v1.10
; 치수에 콤마 넣기, 빼기

(defun delzro (smm / lmm wmm)
  (setq lmm (strlen smm))
  (while (= "0" (substr smm lmm 1))
     (setq smm (substr smm 1 (setq lmm (1- lmm))))
  )
  (cond ((= "." (substr smm lmm 1)) (substr smm 1 (1- lmm)))
        (T smm)
  )
)

(defun fldim (typ)
  (cdr (assoc typ dmm))
)

(defun ac (smm / wmm kmm imm dmm lmm)
  (setq lmm (strlen smm) kmm 3)
  (if (null (setq dmm (instr smm ".")))(setq dmm (1+ lmm)))
  (setq imm (- lmm dmm -1) wmm (delzro (substr smm dmm imm)))
  (while (< (setq imm (+ kmm imm)) lmm)
    (setq dmm (- dmm kmm) wmm (strcat "," (substr smm dmm kmm) wmm))
  )
  (strcat (substr smm 1 (1- dmm)) wmm)
)

(defun c:cimdci( / ent)
    (princ "\nArchiFree 2002 for AutoCAD LT 2002")
    (princ "\n치수에 콤마를 삽입하는 명령입니다.")
    (setvar "cmdecho" 0)
	(setvar "dimunit" 8)
	(setq ent (ssget))
	(if (/= ent nil)
		(command "_dim1" "Up" ent "")
	)	
	(setvar "cmdecho" 1)
)

(defun c:cimdcr( / ent)
	(princ "\nArchiFree 2002 for AutoCAD LT 2002")
    (princ "\n치수의 콤마를 제거하는 명령입니다.")
    (setvar "cmdecho" 0)
	(setvar "dimunit" 2)
	(setq ent (ssget))
	(if (/= ent nil)
 		(command "_dim1" "Up" ent "")
 	)	
 	(setvar "cmdecho" 1)
)
(princ)