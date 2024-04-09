(defun @tx_num_lst(tx / txn k tx1 tx2 tx3 txnum-lst)
  (setq txn (strlen tx)  tx2 "" txnum-lst nil k 1  )
  (repeat (+ txn 1)
    (setq tx1 (substr tx k 1))
    (if (or (= 46 (ascii tx1)) (<= 48 (ascii tx1) 57))
        (setq tx2 (strcat tx2 tx1))
        (progn
          (if (/= tx2 "")(setq txnum-lst (append txnum-lst (list (atof tx2)))) )
          (setq tx2 "")
        )  )
    (setq k (1+ k))
  )
txnum-lst)

(defun subLoadExcel (/ excelPath)

        (if (and

                (setq excelPath

                    (vl-registry-read

                        "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\App Paths\\Excel.exe"

                        "Path"

                    )

                )

                (setq excelPath (strcat excelPath "Excel.exe"))

            )

            (progn

                (if (not msxl-acos)

                    (vlax-import-type-library

                        :tlb-filename excelPath

                        :methods-prefix "msxl-"

                        :properties-prefix "msxl-"

                        :constants-prefix "msxl-"

                    )

                )

                (setq ExcelApp (vlax-get-or-create-object "Excel.Application"))

            )

        )

        ExcelApp

    )

(defun ssam ()
 (setq ExcelApp (subLoadExcel))
 (vlax-put Excelapp "visible" :vlax-true)
 (setq Workbooks (vlax-get-property ExcelApp 'Workbooks))
 (setq Sheets (vlax-get-property ExcelApp 'Sheets))
 (setq AcSheet (vlax-get-property ExcelApp 'ActiveSheet)) 
  
(setq SheetNameList '())

            (vlax-for item Sheets

                (setq SheetNameList (append SheetNameList (list (vla-get-name item))))

            )

(setq AcSheetName (vla-get-name AcSheet))

)
  ;; 엑셀에서 찾기
  (defun find_excel (STARTCELL LASTCELL value_ / MYCELL MYROW MYROW_LST LASTCELL STARTCELL FIND_RANGS)
    
    (SETQ FIND_RANGS (vlax-get-property AcSheet'RANGE LASTCELL STARTCELL))
    (SETQ MYCELL STARTCELL)
    (SETQ I 0)
    (WHILE (= I 0)
      
      
      
      (IF (equal (vlax-get (SETQ MYROW (vlax-invoke-method FIND_RANGS  "Find" (vlax-make-variant value_) MYCELL -4163 1 1 1 nil nil)) 'address) (CAR MYROW_LST))

	 (PROGN (SETQ I 1))
	 (PROGN
    	   (IF (= MYROW_LST NIL)
           (SETQ MYROW_LST (LIST (VLAX-GET MYROW 'ADDRESS))) (SETQ MYROW_LST (APPEND MYROW_LST (LIST (VLAX-GET MYROW 'ADDRESS)))))
    	   (SETQ MYCELL MYROW)
	 )
       )
	  
    )
    
    (vlax-release-object FIND_RANGS)
    
    MYROW_LST
    
    
)

(DEFUN EXL_VALUE (ADDRESS value_ / value_ RANGE)
  
  (SETQ value_ (vlax-get-property (vlax-get-property AcSheet'RANGE ADDRESS ) 'VALUE ))
  
)

(DEFUN EXL_OFFSET_VALUE (ADDRESS value_ OFFSET_X OFFSET_Y / value_ OFF_RANGE ADDRESS OFFSET_X OFFSET_Y )
  
  (SETQ OFF_RANGE (vlax-get-property (vlax-get-property AcSheet'RANGE ADDRESS) 'OFFSET OFFSET_X OFFSET_Y))
  (SETQ value_ (vlax-get-property OFF_RANGE 'VALUE))
  VALUE_
  
)
(DEFUN OFFSET_LST (STARTCELL LASTCELL value_ EXCEL_OFFSET_lst / qq ITEM_LST item_lst_ed )
      
     (setq qq (find_excel STARTCELL LASTCELL value_)) 
    (foreach x1 qq
     
    (mapcar '(lambda (x)
    (SETQ ITEM_LST (APPEND ITEM_LST (list (VLAX-VARIANT-VALUE (EXL_OFFSET_VALUE x1 value_ 0 x)))))
             ) EXCEL_OFFSET_lst)
      
    (setq item_lst_ed (append item_lst_ed (list item_lst)))
    (setq item_lst nil)
    )
  item_lst_ed
    )

(defun LAYOSUB (value_ / ExcelApp Workbooks Sheets AcSheet LASTCELL STARTCELL EXCEL_OFFSET_lst item_lst item item_lst_ed TXT TXT_LST NUM1 num2 num3 num4 lst)
     (ssam)
    
    (SETQ LASTCELL (vlax-get-property (vlax-get-property AcSheet'RANGE "J100000") "END" -4162))  ;; 설비명Sub
    (SETQ STARTCELL (vlax-get-property AcSheet'RANGE "J2"))
    (SETQ EXCEL_OFFSET_lst (list 3 4 5))
    (if (vl-catch-all-error-p (vl-catch-all-apply '(lambda ()(setq kk (OFFSET_LST STARTCELL LASTCELL value_ EXCEL_OFFSET_lst)))))
      (progn (setq lst nil))
      (progn
    
  
    (setq item_lst (OFFSET_LST STARTCELL LASTCELL value_ EXCEL_OFFSET_lst)) 
    (SETQ NUM1 (D_LIST_INSERT_TXT item_lst "_" ))

    (SETQ EXCEL_OFFSET_lst (list 7)) ;; 사용량
    (setq num2 (mapcar '(lambda(x) (rtos (car x) 2 2)) (OFFSET_LST STARTCELL LASTCELL value_ EXCEL_OFFSET_lst)))
     
    (SETQ EXCEL_OFFSET_lst (list 7 12)) ;; 사용량 * 수용률
    (setq item_lst (OFFSET_LST STARTCELL LASTCELL value_ EXCEL_OFFSET_lst))
    (setq num3 (mapcar '(lambda(x)(rtos (* (car x)(cadr x) )2 2) ) item_lst))

    
    (SETQ EXCEL_OFFSET_lst (list -6 -5 0 1 13)) ;; 부하 명칭 불러오기
    (setq item_lst (OFFSET_LST STARTCELL LASTCELL value_ EXCEL_OFFSET_lst)) 
    (setq num4 (D_LIST_INSERT_TXT item_lst "_" ))

    (SETQ EXCEL_OFFSET_lst (list 6)) ;;노즐 수량
    (setq item_lst (OFFSET_LST STARTCELL LASTCELL value_ EXCEL_OFFSET_lst))
    (SEtQ num5 item_lst)
    
    
    (setq lst (mapcar '(lambda (x y z a b) (append (list x) (list y) (list z) (list a) b)) NUM1 NUM2 NUM3 NUM4 NUM5)))
    );if

    
   
    (vlax-release-object ExcelApp)
    (vlax-release-object Workbooks)
    (vlax-release-object Sheets)
    (vlax-release-object AcSheet)
    (vlax-release-object LASTCELL)
    (vlax-release-object STARTCELL)
    
    lst
    
)
(DEFUN D_LIST_INSERT_TXT (LST I_TXT / TXT I UNIT UNITS TXT_LST)
(FOREACH X LST
      (SETQ TXT NIL)
      (SETQ I 0)
      (SETQ UNIT (if (numberp (CAR X)) (rtos(CAR X) 2 2) (CAR X) ))
      (SETQ UNITS (CDR X))
      
    (WHILE (< I (LENGTH X))
      (IF (NOT (= UNIT NIL))
	(PROGN
	 (IF (= TXT NIL) (SETQ TXT UNIT)(SETQ TXT (STRCAT TXT I_TXT UNIT)))
        (SETQ UNIT (if (numberp (CAR UNITS)) (rtos(CAR UNITS) 2 2) (CAR UNITS) ))
        (SETQ UNITS (CDR UNITS))
	))
      
      
      (SETQ I (1+ I))
    )
      (SETQ TXT_LST (APPEND TXT_LST (LIST TXT)))
    )
  TXT_LST
)