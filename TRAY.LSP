
(defun dtr (a)
  (* pi (/ a 180.00))
) 
(defun rtd (a)
 (/ (* a 180.00) pi)
)

(defun myerr(msg)
	 (if (/= msg "Function cancelled")
		 (princ (strcat "\nError: " msg))
   )
   (setq *error* err)
   (COMMAND "UCS" "")
   (princ)
)

(defun c:tray( /  DF TLEN FSTR OS WDH WDH2 TT GUBUN )
  (PRINC "\n자~ TRAY 폭을 정하고 시작해볼까요?")
  (SETQ TLEN 100000)  ; TRAY 단위 길이를 설정합니다.
  (SETQ FSTR 100)   ; FITTING 직선길이를 설정합니다.
  (SETQ OS (GETVAR "OSMODE"))
  (setq err *error* *error* myerr)
  (SETQ CO "")
  (SETQ WDH (GETREAL "\nTRAY WIDTH : "))
  (SETQ WDH2 (/ WDH 2))
  (SETQ TT "")
   (WHILE (= TT "")
        
       (SETQ GUBUN (STRCASE (GETSTRING "\nS)traight / F)itting / E)xit : ")))

       (cond
         ((= GUBUN "S") (STR)) 
         ((= GUBUN "F") (FITT))
	 ((= GUBUN "E") (SETQ DF "A"))
	 (T NIL)
       )
     
;=====================================================================================
        
      (IF (= DF "A")
        (SETQ TT 2)  
        (SETQ TT "")
      )
            

   );END OF WHILE
  (PRIN1)
  (PRINC)
  (COMMAND "OSNAP" "END,MID,CEN,INT,QUA,PER,NEA")
  (COMMAND "UCS" "")
  
  (setq *error* err)
);DEFUN

(DEFUN STR()
   (COMMAND "OSNAP" "END,MID")
   (IF (= CO 1)
      (PROGN 
;        (SETQ PT1 PT2)
	(COMMAND "UCS" "E")
	(SETQ AP (GETPOINT))
	(COMMAND AP "")
	(SETQ PT1 (GETPOINT "\nSELECT START POINT "))
      )	
      (SETQ PT1 (GETPOINT "\nSELECT START POINT "))
   )
  
   (SETQ PT2 (GETPOINT PT1 "\nSELECT END POINT "))
   (SETQ ANG1 (RTD (ANGLE PT1 PT2))
         DIST (DISTANCE PT1 PT2)
         NUM (FIX (/ DIST TLEN))
	 PT3 PT2
	 
   )
   (COMMAND "OSNAP" "")
   (IF (>= DIST TLEN)
      (PROGN 
        (REPEAT NUM
	  (SETQ PT2 (POLAR PT1 (DTR ANG1) TLEN))
          (SETQ PA1 (POLAR PT1 (DTR (- ANG1 90)) WDH2)
		PA2 (POLAR PA1 (DTR ANG1) TLEN)
		PA3 (POLAR PA2 (DTR (+ ANG1 90)) WDH)
		PA4 (POLAR PT1 (DTR (+ ANG1 90)) WDH2)
	  )	
           
          (COMMAND "PLINE" PA1 PA2 PA3 PA4 "C")
	  (SETQ PT1 PT2)
        ) ;REPEAT

          (SETQ PA1 (POLAR PT3 (DTR (- ANG1 90)) WDH2)
		PA4 (POLAR PT3 (DTR (+ ANG1 90)) WDH2)
	  )	
          
          (COMMAND "PLINE" PA1 PA2 PA3 PA4 "C")
    	  (SETQ PT2 PT3)

      );PROGN
 
      (PROGN
	  (SETQ PA1 (POLAR PT1 (DTR (- ANG1 90)) WDH2)
		PA2 (POLAR PA1 (DTR ANG1) DIST)
		PA3 (POLAR PA2 (DTR (+ ANG1 90)) WDH)
		PA4 (POLAR PT1 (DTR (+ ANG1 90)) WDH2)
	  )	
           
          (COMMAND "PLINE" PA1 PA2 PA3 PA4 "C")
	);PROGN
     
   );IF  
   
  (SETQ CO 1)
  (COMMAND "OSNAP" "END,MID,CEN,INT,QUA,PER,NEA")
) 


(DEFUN FITT()
    (COMMAND "OSNAP" "END,MID")
    (IF (/= FIT_R NIL)
      (PROGN
       (princ "FITTING RADIOUS <") (princ FIT_R) (princ ">? : ")
       
         (SETQ FIT_NR (GETREAL ))
	; (PRIN1 (RTOS FIT_R 2 2)) (PRIN1 "> : ")
	; (PRIN1 "FITTING RADIOUS < ") (PRINC FIT_R) (PRIN1 "> : ") (PRINC)
	 (IF (= FIT_NR NIL)
	     (SETQ FIT_R FIT_R)
	     (SETQ FIT_R FIT_NR)
	 )  
      )
      (SETQ FIT_R (GETREAL "\nFITTING RADIOUS (300/600/900) : " ))
    )  
    (SETQ WI WDH
	WI-BAN (/ WI 2)
	ANG-DIR (STRCASE (GETSTRING "\nINPUT ANG <L**/R**/Tee>:"))
	DIR (SUBSTR ANG-DIR 1 1)
;	ANG (DTR (ATOF (SUBSTR ANG-DIR 2 2)))
	RAD FIT_R
        SP (GETPOINT "\nSTART POINT :") 
    )
     (IF (= DIR "L")
           (SETQ ANG (DTR (ATOF (SUBSTR ANG-DIR 2 2)))
	         P1 (POLAR SP 0 WI-BAN)
	         P2 (POLAR P1 (DTR 90) FSTR)
	         CEN (POLAR P2 PI (+ WI RAD))
	         P3 (POLAR CEN  ANG (+ WI RAD))
	         P4 (POLAR P3 (+ (/ PI 2) ANG) FSTR)
	         P5 (POLAR P4 (+ PI ANG) WI)
	         P6 (POLAR P5 (+ (/ PI 2) PI ANG) FSTR)
	         P8 (POLAR SP PI WI-BAN)
	         P7 (POLAR P8 (/ PI 2) 125)
		 EP (POLAR P4 (+ PI ANG) WI-BAN)
		
           )
       );if
  
   (IF (= DIR "R")
           (SETQ ANG (DTR (ATOF (SUBSTR ANG-DIR 2 2)))
	         P1 (POLAR SP PI WI-BAN)
	         P2 (POLAR P1 (DTR 90) FSTR)
	         CEN (POLAR P2 0 (+ WI RAD))
	         P3 (POLAR CEN (- PI ANG) (+ WI RAD))
	         P4 (POLAR P3 (- PI (+ (/ PI 2) ANG)) FSTR)
	         P5 (POLAR P4 (- ANG) WI)
	         P6 (POLAR P3 (- ANG) WI)
	         P8 (POLAR SP 0 WI-BAN)
	         P7 (POLAR P8 (/ PI 2) FSTR)
		 EP (POLAR P4 (+ PI ANG) WI-BAN)
		
           )
   
     );IF

     (IF (= DIR "T")
           (SETQ ANG (/ PI 2)
		 P1 (POLAR SP 0 WI-BAN)
	         P2 (POLAR P1 (DTR 90) FSTR)
	         CEN1 (POLAR P2 PI (+ WI RAD))
	         P3 (POLAR CEN1  ANG (+ WI RAD))
	         P4 (POLAR P3 (+ (/ PI 2) ANG) FSTR)
	         P5 (POLAR P4 (+ PI ANG) WI)
	         P6 (POLAR P5 (+ (/ PI 2) PI ANG) FSTR)
	         P8 (POLAR SP PI WI-BAN)
	         P7 (POLAR P8 (/ PI 2) FSTR)
		 EP (POLAR P4 (+ PI ANG) WI-BAN)

		 
	         CEN2 (POLAR P7 0 (+ WI RAD))
		 P12 (POLAR CEN2 (- PI ANG) (+ WI RAD))
	         P11 (POLAR P12 (- PI (+ (/ PI 2) ANG)) FSTR)
	         P10 (POLAR P11 (- ANG) WI)
	         P9 (POLAR P12 (- ANG) WI)
		
           )
   
     );IF
  
   (COMMAND "OSNAP" "")
   (IF (OR (= DIR "R") (= DIR "L"))
      (COMMAND "PLINE" P1 P2 "A" P3 "L" P4 P5 P6 "A" P7 "L" P8 P1 "")
   )

  (IF (= DIR "T")
      (COMMAND "PLINE" P1 P2 "A" P9 "L" P10 P11 P4 P5 P6 "A" P7 "L" P8 P1 "")
   )  
  
 ; (COMMAND "ROTATE" "L" "" SP (- ANG1 90))
   (COMMAND "OSNAP" "END,MID")
   (COMMAND "ROTATE" "L" "" SP )
   (SETQ EEP (GETPOINT SP "\nROTATE POINT :"))
   (COMMAND EEP)
   (SETQ CO 1)
   (COMMAND "OSNAP" "END,MID,CEN,INT,QUA,PER,NEA")
   (PRIN1)
   (PRINC)
 ;  (COMMAND "UCS" "")
 )

(PROMPT "\n명령어 : TRAY ")