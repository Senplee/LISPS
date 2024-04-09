;수정날짜 :2001.8.11 
;작업자 :김 병 용 
;명령어 :C:cimWSH1 / cimBH1 /c:cimfixu /c:cimfixue

;단축키 관련 변수 정의 부분
(setq lfn10 1)

(defun m:bh1 (/ sc       strtpt   nextpt   ptd      uctr
             )

  (setq sc (getvar "dimscale"))

  ;;
  ;; Internal error handler defined locally
  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")
 
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n변기+세면기+욕조를 그리는 명령입니다.")

  (setq cont T temp T uctr 0)

  (while cont
    (bh1_m1)
    (bh1_m2)
    (bh1_m3)
  )


  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (princ)
)

(defun bh1_m1 (/ omode)
  
  (while temp 
    (setvar "osmode" 33)
    (if (> uctr 0)
      (progn
        (initget "Dialog Undo")
        (setq strtpt (getpoint "\n>>> Dialog/Undo/<시작점>: "))
      )
      (progn
        (initget "Dialog")
        (setq strtpt (getpoint "\n>>> Dialog/<시작점>: "))
      )
    )
    
    (setvar "osmode" 0)
    
    (cond
      ((= strtpt "Dialog")
        (dd_bh1)
      )
      
      ((= strtpt "Undo")
        (command "_.Undo" "_B")
        (setq uctr (1- uctr))
      )
      ((null strtpt)
        (setq temp nil cont nil)
      )
      (T
        (setq temp nil tem T)
      )
    )
  )
)

(defun bh1_m2 ()
  (while tem
    (initget "Dialog Undo")    
    (setvar "osmode" 33)
    (setq nextpt (getpoint strtpt "\n    Dialog/Undo/<다음점>: "))
    
    (setvar "osmode" 0)
    (cond
      ((= nextpt "Undo")
        (setq tem nil nextpt nil temp T)
      )
      ((= nextpt "Dialog")
        (dd_bh1)
      )
      
      ((= (type nextpt) 'LIST)
        (if (< (distance strtpt nextpt) 1800)                   
          (alert "두 점사이의 거리가 1800mm이상이어야 합니다." )
          (setq tem nil ptd T)
        )
      )
      (T
        (setq tem nil cont nil)
      )
    )
  )
)

(defun bh1_m3 ()
  (while ptd
    (initget "Dialog Undo")
    
    (setvar "osmode" 33)
    (setq ptd (getpoint nextpt
      "\n    Dialog/Undo/<third point>: "))
    
    (setvar "osmode" 0)
    (cond
      ((= ptd "Undo")
        (setq ptd nil temp nil)
      )
      ((= ptd "Dialog")
        (dd_bh1)
      )
      ((= (type ptd) 'LIST)
        (if (< (distance nextpt ptd) 1200)
          (alert "두 점사이의 거리가 1200mm이상이어야 합니다." )
          (progn
            (command "_.undo" "_M")
            (bh1_ex)
            (setq ptd nil temp T)
            (princ " \n")
            (setq uctr (1+ uctr))
          )
        )
      )
      (T
        (setq ptd nil cont nil)
      )
    )
  )
)

(defun bh1_ex (/ pt1 pt2 pt3 pt4 pt5 pt6 pt7 pt8 pt9 pt10 pt11 pt12 pt13 pt14
                 d1 d2 d3 pb1 pb2 pb3 ang ang1 ang2 ang3 bsw bsh bath omode)
  (setq omode (getvar "osmode"))
  (setq pt1  strtpt
        d1   (distance pt1 nextpt)
        d2   (distance nextpt ptd)
        ang  (angle pt1 nextpt)
        ang1 (angle nextpt ptd)
        ang2 (angle nextpt pt1)
        ang3 (+ ang1 (dtr 180))
        bsw  (if (< d2 1300) 760 700)

        bsh  (if (< d2 2600)
               d2
               (if (>= d1 3200)
                 2300
                 (if (>= d2 2900)
                   2300
                   d2
                 )
               )
             )
        pt2  (polar pt1 ang
               (cond
                 ((< d1 1900) 1200)
                 ((and (>= d1 1900) (< d1 2100)) 1300)
                 ((and (>= d1 2100) (< d1 2300)) (- d1 (+ bsw 100)))
                 ((>= d1 2300) 1500)
               )
             )
        d3   (distance pt1 pt2)
        pt3  (polar pt1 ang1 230)
        pt4  (polar pt3 ang  (if (<= d3 1450) 240 290))
        pt5  (polar pt4 ang  220)
        pb1  (polar pt4 ang  110)
        pt6  (polar pt5 ang  (if (<= d3 1450) (- d3 1060) 390))
        pt7  (polar pt6 ang  300)
        pb2  (polar pt7 ang3 230)
        pt8  (polar pt7 ang  300)
        pt7  (polar pt7 ang1 300)
        pt9  (polar pt2 ang1 15)
        pt10 (polar pt1 ang1 15)
        pt11 (polar nextpt ang2 bsw)
        pt12 (polar pt11 ang1 bsh)
        pb3  (polar pt11 ang (/ bsw 2));; (if (<= bsw 1360) (/ bsw 2) 650))

  )
  (if (< bsh d2)
    (setq pt13 (polar pt12 ang (if (<= bsw 1360) bsw 1300)))
  )
  (if (and pt13 (>= bsw 1600))
    (setq pt14 (polar pt13 ang3 bsh))
  )
  (set_col_lin_lay bh1:bprop)
  (setvar "osmode" 0)
  (command "_.pline" pt2 pt1 pt3 pt4 "")
  (ssget "l")
  (command "_.insert" "*feces" pb1 "" (rtd ang1))
  (command "_.pedit" "_L" "_J" "_P" "" "")
  (ssget "L")
  (if (< sc 200)
    (command "_.insert" "feces1" pb1 "" "" (rtd ang1))
  )
  (command "_.line" pt4 pt5 "")
  (command "_.pline" pt5 pt6 "")
  (command "_.pedit" "_L" "_J" "_P" "" "")
  (ssget "L")
  (if (< sc 200)
    (command "_.insert" "wshb1"  pb2 "" "" (rtd ang1))
    (command "_.insert" "wshb1S" pb2 "" "" (rtd ang1))
  )
  (command "_.arc" pt6 pt7 pt8)
  (command "_.pedit" "_L" "_Y" "_J" "_P" "" "")
  (ssget "L")
  (command "_.pline" pt8 pt2 "")
  (command "_.pedit" "_L" "_J" "_P" "" "")
  (if (< sc 200)
    (command "_.line" pt9 pt10 "")
  )
  (setq bath (cond
               ((< bsh 1300) "18AK12")
               ((and (>= bsh 1300) (< bsh 1400)) "18AK13")
               ((and (>= bsh 1400) (< bsh 1500)) "18AK14")
               ((and (>= bsh 1500) (< bsh 1600)) "18AK15")
               ((and (>= bsh 1600) (< bsh 1700)) "18BK16")
               ((>= bsh 1700) "18BK17")
             )
  )
  (if (>= sc 200)
    (setq bath (strcat bath "S"))
  )
  (command "_.insert" bath pb3 "" "" (rtd ang1))

  (setvar "osmode" omode)
)


(defun dd_bh1 (/ cancel_check ok_check tog_check)
  
  (setq dcl_id (ai_dcl "setprop"))
  (if (not (new_dialog "set_prop_c_la" dcl_id)) (exit))
  (@get_eval_prop bh1_prop_type bh1:prop)
  
  (action_tile "b_name" "(@getlayer)")
  (action_tile "b_color" "(@getcolor)")
  (action_tile "color_image"  "(@getcolor)")
  (action_tile "c_bylayer" "(@bylayer_do T)")
  (action_tile "cancel" "(setq cancel_check T)(done_dialog)")
  (start_dialog)
  (done_dialog)
  (if (= cancel_check nil)
	(PROP_SAVE bh1:prop)
  )

)
;
(setq bh1:bprop  (Prop_search "bh1" "bath"))
(setq bh1:prop '(bh1:bprop))
(if (null bh1_prop_type) (setq bh1_prop_type "rd_bath"))


(defun C:cimBH1 () (m:bh1))
(princ)

;----------------------------------------------------------------
; Created by N.J.K. 1992. 4. 19.
; 소변기 평면 그리기
(defun m:fixu (/ pt1      pt2      ptd      sc       d1       cont
                 temp     tem      uctr
                 ang      ang1     ang2     strtpt   nextpt   
                 )

  (setq sc (getvar "dimscale"))

  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")

  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n소변기 평면을 배열하는 명령입니다.")

  (setq cont T temp T uctr 0)
  (while cont
    (fixu_m1)
    (fixu_m2)
    (fixu_m3)
  )

 
  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
 
  (princ)
)

(defun fixu_m1 ()
  (while temp
    (setvar "osmode" 33)
    (setvar "orthomode" 1)
    (if (> uctr 0)
      (progn
        (initget "Dialog Undo")
        (setq strtpt (getpoint "\n>>> Dialog/Undo/<시작점>: "))
      )
      (progn
        (initget "Dialog")
        (setq strtpt (getpoint "\n>>> Dialog/<시작점>: "))
      )
    )
  
    (setvar "osmode" 0)
    (setvar "orthomode" 0)
    (cond
      ((= strtpt "Dialog")
        (fixu_typ)
      )
      ((null strtpt)
        (setq cont nil nextpt nil temp nil)
      )
      ((= strtpt "Undo")
        (command "_.undo" "_b")
        (setq uctr (1- uctr))
      )
      (T
        (setq temp nil tem T)
      )
    )
  )
)

(defun fixu_m2 ()
  (while tem
    (initget "Dialog Undo")
    
    (setvar "osmode" 33)
    ;(setvar "orthomode" fix_oor)
    (setvar "orthomode" 1)
    (setvar "snapbase" (list (car strtpt) (cadr strtpt)))
    (setq nextpt (getpoint strtpt 
       "\n    Dialoge/Undo/<다음점>: "))
    
    (setvar "osmode" 0)
    ;(setvar "snapbase" '(0 0))
    (cond
      ((= nextpt "Dialog")
        (fixu_typ)
      )
      ((= nextpt "Undo")
        (setq tem nil nextpt nil temp T)
      )      
      ((null nextpt)
        (setq cont nil tem nil)
      )
      (T
        (if (< (distance strtpt nextpt) 600)
          (alert "두 점사이의 거리가 600mm이상이어야 합니다." )
          (setq tem nil ptd T)
        )
      )
    )
  )
)

(defun fixu_m3 ()
  (while ptd
    (initget "Dialog Undo")
        
    (setvar "orthomode" 0)    
    (setq ptd (getpoint strtpt 
       "\n    Dialog/Undo/<그리기 방향 지정>: "))
    
    (cond
      ((= ptd "Dialog")
        (fixu_typ)
      )
      ((= ptd "Undo")
        (setq ptd nil temp nil tem T)
      )      
      ((= (type ptd) 'LIST)
        (command "_.undo" "_m")
        (fixu_ex)
        (setq uctr (1+ uctr))
        (setq ptd nil temp T)
      )
      (T
        (setq ptd nil cont nil)
      )
    )
  )
)

;소변기 평면그리기 type부분임
;수정날짜:2001.8.11 
;작성자 :김병용
;수정내용: dcl로 나오게 한다.

;수정전 icon 형식  icon = urinal
;(defun fixu_typ (/ typ)  
;  (menucmd "i=urinal") (menucmd "i=*")
;  (setq typ (getstring "\n    New urinal_type: "))
;  (if (/= typ "") (setq fixu:typ (strcat typ "p")))  
;)  

;수정후 dcl로..
(defun fixu_typ (/ typ dcl_id cancel_check)    
  (setq ok_check nil cancel_check nil typ nil fixu:f_name nil); ok,cancel button init
  (setq dcl_id (ai_dcl "bath1"))
  (if (not (new_dialog "dd_fixu" dcl_id)) (exit))    
  (@get_eval_prop fixu_prop_type fixu:prop)
  ;(ci_image "keycu301p" "al_toil(cu-301p)")  
  (ci_image "keycu301p" "cim2(cu-301p)")  
  (ci_image "keycu302p" "al_toil(cu-302p)") 
  (ci_image "keycu303p" "al_toil(cu-303p)")  
  (ci_image "keycu304p" "al_toil(cu-304p)")  
  (ci_image "keycu301ps" "al_toil(cu-301ps)")  
  (ci_image "keycu302ps" "al_toil(cu-302ps)") 
  (ci_image "keycu303ps" "al_toil(cu-303ps)")  
  (ci_image "keycu304ps" "al_toil(cu-304ps)")      
  ;속성  
  (action_tile "b_name" "(@getlayer)")
  (action_tile "b_color" "(@getcolor)")
  (action_tile "color_image"  "(@getcolor)")
  (action_tile "c_bylayer" "(@bylayer_do T)")
   
  (action_tile "keycu301p" "(setq typ 1)")
  (action_tile "keycu302p" "(setq typ 2)")
  (action_tile "keycu303p" "(setq typ 3)")
  (action_tile "keycu304p" "(setq typ 4)")
  (action_tile "keycu301ps" "(setq typ 5)")
  (action_tile "keycu302ps" "(setq typ 6)")
  (action_tile "keycu303ps" "(setq typ 7)")
  (action_tile "keycu304ps" "(setq typ 8)")
  (action_tile "f_search" "(fixu_file_open)")  
  (action_tile "f_name" "(setq fixu:f_name $value)")         
  (action_tile "cancel" "(setq cancel_check T)(done_dialog)")  
  (start_dialog)
  (done_dialog)       
   
  (if (/= cancel_check T)
  	
  	(progn
  		;소변기 타입 정하기	 		
  		(if (/= fixu:f_name nil)
  		    (progn
  		    	(if (/= (findfile fixu:f_name) nil)  		       		
  		       		(progn (setq fixu:typ fixu:f_name))
  		       		(progn (alert (strcat fixu:f_name "을 찾을 수가 없습니다."))  		       			
					(fixu_typ)
				 )
  		       	)
  		    )	
  		    (progn
  			(cond 
  				((= typ 1)
  					(setq fixu:typ "cu-301p")
  				)
  				((= typ 2)
  					(setq fixu:typ "cu-302p")
  				)		
  				((= typ 3)
  					(setq fixu:typ "cu-303p")
  				)
  				((= typ 4)
  					(setq fixu:typ "cu-304p")
  				)
  				((= typ 5)
  					(setq fixu:typ "cu-301ps")
  				)  	
  				((= typ 6)
  					(setq fixu:typ "cu-302ps")
  				)  	
  				((= typ 7)
  					(setq fixu:typ "cu-303ps")
  				)  	
  				((= typ 8)
  					(setq fixu:typ "cu-304ps")
  				)  	
   			)  		  		
   		    )
   		)   	
   		
   		(PROP_SAVE fixu:prop)
  	)
  )  
)

(defun fixu_file_open (/ f$$)        
    (setq f$$ (getfiled "읽을 파일명" "" "dwg" 8))
    (if (/= f$$ nil)
    	(progn
    		(set_tile "f_name" f$$)
    		(setq fixu:f_name f$$)
    	)
    )    	  
)

(defun fixu_ex (/ nf pti ds en)
  (setq pt1  strtpt
        pt2  nextpt
        ang (angle pt1 pt2)
        ang1 (angle pt1 ptd)
        d1 (distance pt1 pt2)
  )
  ;;2001.8.11 김병용
  ;dimscale에 따라서 달리 그려지는 부분이었음..  
   (setq en fixu:typ)
  ; (if (< sc 200)
  ;   (setq en fixu:typ)
  ;   (setq en (strcat fixu:typ "s"))  
  ;)
  (if (and (> ang1 ang) (< ang1 (+ ang (dtr 180))))
    (setq ang2 (+ ang (dtr 90.0)))
    (progn
    (if (and (>= ang (dtr 270)) (< ang1 pi))
    (setq ang2 (+ ang (dtr 90)))
    (setq ang2 (- ang (dtr 90))))
     )
  ) 
  (setq nf (1+ (fix (/ (- d1 900) 700))))
  (if (<= nf 1)
    (setq pti (polar pt1 ang (/ d1 2))
          ds 0)
    (progn
    (setq ds (/ (- d1 900) (1- nf)))
    (setq pti (polar pt1 ang 450)))
  )
  (if (> ds 900)
    (setq ds 900
          pti (polar pt1 ang (/ (- d1 (* 900 (1- nf))) 2)))
  )
  (set_col_lin_lay fixu:fprop)
  (repeat nf
    (command "_.insert" en pti "" "" (rtd ang2))
    (setq pti (polar pti ang ds))
  )
  (princ "\n>>> 그려진 소변기 개수: ")
  (princ nf)
  (if (/= ds 0) (progn
    (princ "   소변기 간격: ")
    (princ ds)
    (princ "mm"))
  )
)

(if (null fixu:typ) (setq fixu:typ "cu-301p"))
(setq fixu:fprop  (Prop_search "fixu" "fixu"))
(setq fixu:prop '(fixu:fprop))
(if (null fixu_prop_type) (setq fixu_prop_type "rd_fixu"))

(defun C:cimFIXU () (m:fixu))
(princ)

;--------------------------------------------------------------
; Created by N.J.K. 1992. 4. 19.
; 소변기 입면 그리기
(defun m:fixue (/ pt1      pt2      ptd      sc       d1       cont
                 temp     tem      uctr
                 ang      ang1     ang2     strtpt   nextpt 
                 )
  
  (setq sc (getvar "dimscale"))

  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")

  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n소변기 입면을 배열하는 명령입니다.")

  (setq cont T temp T uctr 0)
  (while cont
    (fixue_m1)
    (fixue_m2)
    (fixue_m3)
  )

  (ai_err_off)
  (ai_undo_off)
  (setvar "cmdecho" 1)
  
  (princ)
)

(defun fixue_m1 ()
  (while temp
    
    (setvar "osmode" 33)
    (if (> uctr 0)
      (progn
        (initget "Dialog Undo")
        (setq strtpt (getpoint "\n>>> Dialog/Undo/<시작점>: "))
      )
      (progn
        (initget "Dialog")
        (setq strtpt (getpoint "\n>>> Dialog/<시작점>: "))
      )
    )
    
    (setvar "osmode" 0)
    (cond
       ((= strtpt "Dialog")
         (fixue_typ)
      	 )
      ((= strtpt "Undo")
        (command "_.undo" "_B")
        (setq uctr (1- uctr))
      )
      ((null strtpt)
        (setq cont nil temp nil)
      )
      (T
        (setq temp nil tem T)
      )
    )
  )
)

(defun fixue_m2 ()
  (while tem
    (initget "Dialog Undo")
    (setvar "osmode" 33)
    ;(setvar "orthomode" fix_oor)
    (setvar "orthomode" 1)
    (setvar "snapbase" (list (car strtpt) (cadr strtpt)))
    (setq nextpt (getpoint strtpt 
       "\n    Dialoge/Undo/<다음점>: "))
    (setvar "osmode" 0)
    ;(setvar "snapbase" '(0 0))
    (cond
      ((= nextpt "Dialog")
        (fixue_typ)
      )
      ((= nextpt "Undo")
        (setq tem nil nextpt nil temp T)
      )      
      ((null nextpt)
        (setq cont nil tem nil)
      )
      (T
        (if (< (distance strtpt nextpt) 600)
          (alert "두 점사이의 거리가 600mm이상이어야 합니다." )
          (setq tem nil ptd T)
        )
      )
    )
  )
)

(defun fixue_m3 ()
  (while ptd
    (initget "Dialog Undo")       
    (setvar "orthomode" 0)    
    (setq ptd (getpoint strtpt 
       "\n    Dialog/Undo/<그리기 방향 지정>: "))
    (cond
      ((= ptd "Dialog")
        (fixue_typ)
      )
      ((= ptd "Undo")
        (setq ptd nil temp nil tem T)
      )      
      ((= (type ptd) 'LIST)
        (command "_.undo" "_m")
        (fixue_ex)
        (setq uctr (1+ uctr))
        (setq ptd nil temp T)
      )
      (T
        (setq ptd nil cont nil)
      )
    )
  )
)


(defun fixue_typ (/ typ dcl_id cancel_check)    
  (setq ok_check nil cancel_check nil typ nil fixue:f_name nil); ok,cancel button init
  (setq dcl_id (ai_dcl "bath1"))
  (if (not (new_dialog "dd_fixue" dcl_id)) (exit))   
  (@get_eval_prop fixu_prop_type fixu:prop)
  (action_tile "b_name" "(@getlayer)")
  (action_tile "b_color" "(@getcolor)")
  (action_tile "color_image"  "(@getcolor)")
  (action_tile "c_bylayer" "(@bylayer_do T)")
  
  (ci_image "keycu301e" "cim2(cu-301e)")  
  (ci_image "keycu302e" "cim2(cu-302e)") 
  (ci_image "keycu308e" "kcim(ktu-308e)")        
  ;속성
  
  (action_tile "keycu301e" "(setq typ 1)")
  (action_tile "keycu302e" "(setq typ 2)")
  (action_tile "keycu308e" "(setq typ 3)")    
  (action_tile "f_search" "(fixue_file_open)")  
  (action_tile "f_name" "(setq fixue:f_name $value)")       
  (action_tile "cancel" "(setq cancel_check T)(done_dialog)")  
  (start_dialog)
  (done_dialog)       
   
  (if (/= cancel_check T)
  
  	(progn
  		;소변기 타입 정하기	 		
  		(if (/= fixue:f_name nil)
  		    (progn
  		    	(if (/= (findfile fixue:f_name) nil)  		       		
  		       		(progn (setq fixue:typ fixue:f_name))
  		       		(progn (alert (strcat fixue:f_name "을 찾을 수가 없습니다."))  		       			
  		       			(fixue_typ)
  		       		)
  		       	)
  		    )	
  		    (progn
  			(cond 
  				((= typ 1)
  					(setq fixue:typ "cu-301e")
  				)
  				((= typ 2)
  					(setq fixue:typ "cu-302e")
  				)		
  				((= typ 3)
  					(setq fixue:typ "Ktu-308e")
  				)  				
   			)  		  		
   		    )
   		)   	
   	
   		(PROP_SAVE fixu:prop)	
  	)
  )  
)

(defun fixue_file_open (/ f$$)        
    (setq f$$ (getfiled "읽을 파일명" "" "dwg" 8))
    (if (/= f$$ nil)
    	(progn
    		(set_tile "f_name" f$$)
    		(setq fixue:f_name f$$)
    	)
    )    	  
)

(defun fixue_ex (/ nf pti ds)
  (setq pt1  strtpt
        pt2  nextpt
        ang (angle pt1 pt2)          
        ang1 (angle pt1 ptd)
        d1 (distance pt1 pt2)
  )
  
  (if (and (> ang1 ang) (< ang1 (+ ang (dtr 180))))
    (setq ang2 (+ ang (dtr 90.0)))
    (progn
    (if (and (>= ang (dtr 270)) (< ang1 pi))
    (setq ang2 (+ ang (dtr 90)))
    (setq ang2 (- ang (dtr 90))))
     )
  ) 
  
  (setq nf (1+ (fix (/ (- d1 900) 700))))  
  (if (<= nf 1)
    (setq pti (polar pt1 ang (/ d1 2))
          ds 0)
    (progn
    (setq ds (/ (- d1 900) (1- nf)))
    (setq pti (polar pt1 ang 450)))
  )
  (if (> ds 900)
    (setq ds 900
          pti (polar pt1 ang (/ (- d1 (* 900 (1- nf))) 2)))
  )
  (set_col_lin_lay fixu:fprop)
  (repeat nf
    (command "_.insert" fixue:typ pti "" "" (+ (rtd ang2) 270))    
    (setq pti (polar pti ang ds))
  )
  (princ "\n>>> 그려진 소변기 개수: ")
  (princ nf)
  (if (/= ds 0) (progn
    (princ "   소변기 간격: ")
    (princ ds)
    (princ "mm"))
  )
)


(if (null fixue:typ) (setq fixue:typ "cu-301e"))

(defun C:cimFIXUE () (m:fixue))
(princ)

;--------------------------------------------------------------------------
; Created by N.J.K. 1992. 4. 19.
; 세면기 평면
(defun m:fixw (/ pt1      pt2      ptd      d1       pt3      pt4
                 pt5      pt6      ang      ang1     ang2     sc
                 strtpt   nextpt   cont     tem      temp     uctr )

  (setq sc (getvar "dimscale"))

  ;;
  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")

  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n세면기 평면을 배열하는 명령입니다.")

  (setq cont T temp T uctr 0)
  (while cont
    (fixw_m1)
    (fixw_m2)
    (fixw_m3)
  )

  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  (setvar "cmdecho" 1)
  (princ)
)

(defun fixw_m1 ()
  (while temp
    
    (setvar "osmode" 33)
    (if (> uctr 0)
      (progn
        (initget "Dialog Undo")
        (setq strtpt (getpoint "\n>>> Dialog/Undo/<시작점>: "))
      )
      (progn
        (initget "Dialog")
        (setq strtpt (getpoint "\n>>> Dialog/<시작점>: "))
      )
    )
    
    (setvar "osmode" 0)
    (cond      
      ((= strtpt "Dialog")
        (fixw_typ)
      )
      ((= strtpt "Undo")
        (command "_.undo" "_B")
        (setq uctr (1- uctr))
      )
      ((null strtpt)
        (setq cont nil temp nil)
      )
      (T
        (setq temp nil tem T)
      )
    )
  )
)

(defun fixw_m2 ()
  (while tem
    (initget "Dialog Undo")
    
    (setvar "osmode" 33)
    (setvar "orthomode" 1)
    (setvar "snapbase" (list (car strtpt) (cadr strtpt)))
    (setq nextpt (getpoint strtpt "\n    Dialog/Undo/<다음점>: "))
    
    (setvar "osmode" 0)
    ;(setvar "snapbase" '(0 0))
    (cond
      ((= nextpt "Undo")
        (setq tem nil temp T)
      )
      ((= nextpt "Dialog")
        (fixw_typ)
      )      
      ((null nextpt)
        (setq cont nil tem nil)
      )
      (T
        (if (< (distance strtpt nextpt) 500)
          (alert "두 점사이의 거리가 500mm이상이어야 합니다." )
          (setq tem nil ptd T)
        )
      )
    )
  )
)

(defun fixw_m3 ()
  (while ptd
    (initget "Dialog Undo")
    
    (setvar "orthomode" 0)
    (setq ptd (getpoint strtpt "\n    Dialog/Undo/<그리기 방향 지정>: "))
        
    (cond
      ((= ptd "Undo")
        (setq ptd nil tem T)
      )
      ((= ptd "Dialog")
        (fixw_typ)
      )      
      ((= (type ptd) 'LIST)
        (command "_.undo" "_m")
        (fixw_ex)
        (setq uctr (1+ uctr))
        (setq ptd nil temp T)
      )
      (T
        (setq ptd nil cont nil)
      )
    )
  )
)

(defun fixw_typ (/ typ dcl_id cancel_check)    
  (setq ok_check nil cancel_check nil typ nil fixw:f_name nil); ok,cancel button init
  (setq dcl_id (ai_dcl "bath1"))
  (if (not (new_dialog "dd_fixw" dcl_id)) (exit))    
  (@get_eval_prop fixu_prop_type fixu:prop)
  
  (ci_image "keywshb1" "al_toil(wshb1)")    
  (ci_image "keywshb2" "al_toil(wshb2)")  
  (ci_image "keywshb3" "al_toil(wshb3)")  
  (ci_image "keywshb1s" "al_toil(wshb1s)")    
  (ci_image "keywshb2s" "al_toil(wshb2s)")  
  (ci_image "keywshb3s" "al_toil(wshb3s)")  
  ;속성  
  
  (action_tile "b_name" "(@getlayer)")
  (action_tile "b_color" "(@getcolor)")
  (action_tile "color_image"  "(@getcolor)")
  (action_tile "c_bylayer" "(@bylayer_do T)")
  
  (action_tile "keywshb1" "(setq typ 1)")
  (action_tile "keywshb2" "(setq typ 2)")
  (action_tile "keywshb3" "(setq typ 3)")
  (action_tile "keywshb1s" "(setq typ 4)")
  (action_tile "keywshb2s" "(setq typ 5)")
  (action_tile "keywshb3s" "(setq typ 6)")
  (action_tile "f_search" "(fixw_file_open)")  
  (action_tile "f_name" "(setq fixw:f_name $value)")       
  (action_tile "cancel" "(setq cancel_check T)(done_dialog)")  
  (start_dialog)
  (done_dialog)       
   
  (if (/= cancel_check T)
  
  	(progn
  		;소변기 타입 정하기	 		
  		(if (/= fixw:f_name nil)
  		    (progn
  		    	(if (/= (findfile fixw:f_name) nil)  		       		
  		       		(progn (setq fixw:typ fixw:f_name))
  		       		(progn (alert (strcat fixw:f_name "을 찾을 수가 없습니다."))  		       			
  		       			(fixw_typ)
  		       		)
  		       	)
  		    )	
  		    (progn
  			(cond 
  				((= typ 1)
  					(setq fixw:typ "wshb1")
  				)
  				((= typ 2)
  					(setq fixw:typ "wshb2")
  				)		
  				((= typ 3)
  					(setq fixw:typ "wshb3")
  				)
  				((= typ 4)
  					(setq fixw:typ "wshb1s")
  				)  	
  				((= typ 5)
  					(setq fixw:typ "wshb2s")
  				)  	
  				((= typ 6)
  					(setq fixw:typ "wshb3s")
  				)  				
   			)  		  		
   		    )
   		)   	
   		;레이어 바꾸기    		
   		(PROP_SAVE fixu:prop)
  	)
  )  
)

(defun fixw_file_open (/ f$$)        
    (setq f$$ (getfiled "읽을 파일명" "" "dwg" 8))
    (if (/= f$$ nil)
    	(progn
    		(set_tile "f_name" f$$)
    		(setq fixw:f_name f$$)
    	)
    )    	  
)

(defun fixw_ex (/ nf pti ds en)
  (setq pt1  strtpt
        pt2  nextpt
        ang (angle pt1 pt2)
        ang1 (angle pt1 ptd)
        d1 (distance pt1 pt2)
  )
  ;주석처리
  ;scale에 따라 타입 바뀜.. 관련 내용 이하 3줄 
  (setq en fixw:typ)  ;en는 insert 할 블럭 
  ;(if (< sc 200)
  ;  (setq en "wshb1")
  ;  (setq en "wshb1s")
  ;)  
  
  (if (and (> ang1 ang) (< ang1 (+ ang (dtr 180))))
    (setq ang2 (+ ang (dtr 90.0)))
    (progn
    (if (and (>= ang (dtr 270)) (< ang1 pi))
    (setq ang2 (+ ang (dtr 90)))
    (setq ang2 (- ang (dtr 90))))
    )
  ) 
  (setq pt3 (polar pt2 ang2 540)
        pt4 (polar pt1 ang2 540)
        pt5 (polar pt1 ang2 15)
        pt6 (polar pt2 ang2 15)
  )
  (set_col_lin_lay fixu:fprop)
  (command "_.pline" pt1 pt2 pt3 pt4 "_C")
  
  ;2002.6.21
  ;scale에 상관없이 라인 그려짐
  ;(if (< sc 200)
    (command "_.line" pt5 pt6 "")
  ;)
    
  (setq nf (1+ (fix (/ (- d1 900) 700))))
  (if (<= nf 1)
    (setq pti (polar pt1 ang (/ d1 2))
          ds 0)
    (progn
    (setq ds (/ (- d1 900) (1- nf)))
    (setq pti (polar pt1 ang 450)))
  )
  (if (> ds 900.0)
    (setq ds 900.0
          pti (polar pt1 ang (/ (- d1 (* 900 (1- nf))) 2)))
  )
  (repeat nf
    (command "_.insert" en pti "" "" (rtd ang2))
    (setq pti (polar pti ang ds))
  )
  (princ "\n>>> 그려진 세면기 개수: ")
  (princ nf)
  (if (/= ds 0) (progn
    (princ "   세면기 간격: ")
    (princ ds)
    (princ "mm"))
  )
)


(if (null fixw:typ) (setq fixw:typ "wshb1"))

(defun C:cimFIXW () (m:fixw))
(princ)

;-----------------------------------------------------------------------
; Created by N.J.K. 1992. 4. 19.
; 세면기 입면 그리기
(defun m:fixwe (/ pt1      pt2      ptd      d1       pt3      pt4
                 pt5      pt6      ang      ang1     ang2     sc
                 strtpt   nextpt   cont     tem      temp     uctr )
 
  (setq sc (getvar "dimscale"))

  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")

  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n세면기 입면을 배열하는 명령입니다.")

  (setq cont T temp T uctr 0)
  (while cont
    (fixwe_m1)
    (fixwe_m2)
    (fixwe_m3)
  )

  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  
  (princ)
)

(defun fixwe_m1 ()
  (while temp
    
    (setvar "osmode" 33)
    (if (> uctr 0)
      (progn
        (initget "Dialog Undo")
        (setq strtpt (getpoint "\n>>> Dialog/Undo/<시작점>: "))
      )
      (progn
        (initget "Dialog")
        (setq strtpt (getpoint "\n>>> Dialog/<시작점>: "))
      )
    )
    
    (setvar "osmode" 0)
    (cond   
      ((= strtpt "Dialog")
        (fixwe_typ)
      )         
      ((= strtpt "Undo")
        (command "_.undo" "_b")
        (setq uctr (1- uctr))
      )
      ((null strtpt)
        (setq cont nil temp nil)
      )
      (T
        (setq temp nil tem T)
      )
    )
  )
)

(defun fixwe_m2 ()
  (while tem
    (initget "Dialog Undo")
    
    (setvar "osmode" 33)
    (setvar "orthomode" 1)
    (setvar "snapbase" (list (car strtpt) (cadr strtpt)))
    (setq nextpt (getpoint strtpt "\n    Dialog/Undo/<다음점>: "))
    
    (setvar "osmode" 0)
    ;(setvar "snapbase" '(0 0))
    (cond
      ((= nextpt "Undo")
        (setq tem nil temp T)
      )
      ((= nextpt "Dialog")
        (fixwe_typ)
      )      
      ((null nextpt)
        (setq cont nil tem nil)
      )
      (T
        (if (< (distance strtpt nextpt) 500)
          (alert "두 점사이의 거리가 500mm이상이어야 합니다." )
          (setq tem nil ptd T)
        )
      )
    )
  )
)

(defun fixwe_m3 ()
  (while ptd
    (initget "Dialog Undo")    
    (setvar "orthomode" 0)
    (setq ptd (getpoint strtpt "\n    Dialog/Undo/<그리기 방향 지정>: "))
    
    (cond
      ((= ptd "Undo")
        (setq ptd nil tem T)
      )
      ((= ptd "Dialog")
        (fixwe_typ)
      )      
      ((= (type ptd) 'LIST)
        (command "_.undo" "_m")
        (fixwe_ex)
        (setq uctr (1+ uctr))
        (setq ptd nil temp T)
      )
      (T
        (setq ptd nil cont nil)
      )
    )
  )
)

(defun fixwe_typ (/ typ dcl_id cancel_check)    
  (setq cancel_check nil typ nil fixwe:f_name nil); ok,cancel button init
  (setq dcl_id (ai_dcl "bath1"))
  (if (not (new_dialog "dd_fixwe" dcl_id)) (exit))    
  (@get_eval_prop fixu_prop_type fixu:prop)
  (action_tile "b_name" "(@getlayer)")
  (action_tile "b_color" "(@getcolor)")
  (action_tile "color_image"  "(@getcolor)")
  (action_tile "c_bylayer" "(@bylayer_do T)")
  
  (ci_image "keycmwe" "cim2(cmwe1)")       
  (ci_image "keycmwe2" "cim2(cmwe2)")       
  (ci_image "keycmwe3" "cim2(cmwe3)")       
  ;속성  
  
  (action_tile "keycmwe" "(setq typ 1)")
  (action_tile "keycmwe2" "(setq typ 2)")
  (action_tile "keycmwe3" "(setq typ 3)")
  (action_tile "f_search" "(fixwe_file_open)")  
  (action_tile "f_name" "(setq fixwe:f_name $value)")       
  (action_tile "cancel" "(setq cancel_check T)(done_dialog)")  
  (start_dialog)
  (done_dialog)
  (if (/= cancel_check T)
  	(progn
  		;소변기 타입 정하기	 		
  		(if (/= fixwe:f_name nil)
  		    (progn
  		    	(if (/= (findfile fixwe:f_name) nil)  		       		
  		       		(progn (setq fixwe:typ fixwe:f_name))
  		       		(progn (alert (strcat fixwe:f_name "을 찾을 수가 없습니다."))  		       			
  		       			(fixwe_typ)
  		       		)
  		       	)
  		    )	
  		    (progn
  			(cond 
  				((= typ 1)
  					(setq fixwe:typ "cmwe1")
				        (setq mask_pipe nil)
  				)
  				((= typ 2)
  					(setq fixwe:typ "cmwe2")
				        (setq mask_pipe nil)
  				)		
  				((= typ 3)
				        (setq mask_pipe T)
  				) 	  							
   			)  		  		
   		    )
   		)   	
   		;레이어 바꾸기    		
   		(PROP_SAVE fixu:prop)
  	)
  )  
)
(defun fixwe_file_open (/ f$$)        
    (setq f$$ (getfiled "읽을 파일명" "" "dwg" 8))
    (if (/= f$$ nil)
    	(progn
    		(set_tile "f_name" f$$)
    		(setq fixwe:f_name f$$)
    	)
    )    	  
)

(defun fixwe_ex (/ ang d1 nf pti ds pt1 pt2 pt3 pt4 pt5 pt6 pt7 pt8 ang3)
  (setq pt1  strtpt
        pt2  nextpt
        ang (angle pt1 pt2)        
        ang1 (angle pt1 ptd)
        d1 (distance pt1 pt2)
  )
   
   (if (and (> ang1 ang) (< ang1 (+ ang (dtr 180))))
    (setq ang2 (+ ang (dtr 90.0)))
    (progn
    (if (and (>= ang (dtr 270)) (< ang1 pi))
    (setq ang2 (+ ang (dtr 90)))
    (setq ang2 (- ang (dtr 90))))
    )
   ) 
   
   ;insert할 세면기 angle ang3
   (if (and (> ang1 ang) (< ang1 (+ ang (dtr 180))))
    (setq ang3 (+ ang (dtr 0))) 
    (progn
    (if (and (>= ang (dtr 270)) (< ang1 pi))
    (setq ang3 (+ ang (dtr 0)))
    (setq ang3 (- ang (dtr 180))))
    )
   ) 
  
  ;(setq pt3 (polar pt1 (dtr 90) 610)
  ;      pt4 (polar pt2 (dtr 90) 610)
  ;      pt5 (polar pt4 (dtr 90) 170)
  ;      pt6 (polar pt3 (dtr 90) 170)
  ;      pt7 (polar pt3 (dtr 90) 120)
  ;      pt8 (polar pt4 (dtr 90) 120)
  ;)
  
  (setq pt3 (polar pt1 ang2 610)
        pt4 (polar pt2 ang2 610)
        pt5 (polar pt4 ang2 170)
        pt6 (polar pt3 ang2 170)
        pt7 (polar pt3 ang2 120)
        pt8 (polar pt4 ang2 120)
  )
  (set_col_lin_lay fixu:fprop)
    
  (command "_.pline" pt3 pt4 pt5 pt6 "_C")
  (command "_.line" pt7 pt8 "")
  (setq nf (1+ (fix (/ (- d1 900) 700))))
  (if (<= nf 1)
    (setq pti (polar pt1 ang (/ d1 2))
          ds 0)
    (progn
    (setq ds (/ (- d1 900) (1- nf)))
    (setq pti (polar pt1 ang 450)))
  )
  (if (> ds 900.0)
    (setq ds 900.0
          pti (polar pt1 ang (/ (- d1 (* 900 (1- nf))) 2)))
  )
  (repeat nf
    ;타입에 따라서 틀리게 세면기 입면이 들어가야 한다.
    (if (= mask_pipe nil)
      (command "_.insert" fixwe:typ pti "" "" (rtd ang3))
    )  
    (setq pti (polar pti ang ds))
  )
  (princ "\n>>> 그려진 세면기 개수: ")
  (princ nf)
  (if (/= ds 0)
    (progn
      (princ "   세면기 간격: ")
      (princ ds)
      (princ "mm")
    )
  )
)

(if (null fixwe:typ) (setq fixwe:typ "cmwe1"))

(defun C:cimFIXWE () (m:fixwe))
(princ)

;------------------------------------------------------------------------------
; Created by N.J.K. 1992. 4. 19.
; 세면기 좌변기 평면 그리기
(defun m:wsh1 (/ pt1      pt2      ptd      d1       pt4      pt5      pt6
                 pt7      pt8      pt9      pt10     pt11     ang      ang1
                 ang2     ang3     ang4     sc       pb1      pb2
                 strtpt   nextpt   cont     tem      temp     uctr
                 )

  (setq sc (getvar "dimscale"))

  (ai_err_on)
  (ai_undo_on)
  (command "_.undo" "_group")

  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n변기+세면기를 그리는 명령입니다.")
  (setq cont T temp T uctr 0)
  (while cont
    (wsh1_m1)
    (wsh1_m2)
    (wsh1_m3)
  )

  (command "_.undo" "_en")
  (ai_err_off)
  (ai_undo_off)
  
  (princ)
)


(defun wsh1_m1 ()
  (while temp
    
    (setvar "osmode" 33)
    (if (> uctr 0)
      (progn
        (initget "Dialog Undo")
        (setq strtpt (getpoint "\n>>> Dialog/Undo/<시작점>: "))
      )
      (progn
        (initget "Dialog Layer")
        (setq strtpt (getpoint "\n>>> Dialog/<시작점>: "))
      )
    )
    
    (setvar "osmode" 0)
    (cond
      ((= strtpt "Dialog")
        (dd_wsh)
      )
      ((= strtpt "Undo")
        (command "_.undo" "_b")
        (setq uctr (1- uctr))
      )
      ((null strtpt)
        (setq cont nil temp nil)
      )
      (T
        (setq temp nil tem T)
      )
    )
  )
)

(defun wsh1_m2 ()
  (while tem
    (initget "Dialog Undo")
    
    (setvar "osmode" 512)
    (setvar "snapbase" (list (car strtpt) (cadr strtpt)))
    (setq nextpt (getpoint strtpt
      "\n    Dialog/Undo/<다음점>: NEAREST to "))
    
    (setvar "osmode" 0)
    (setvar "snapbase" '(0 0))
    (cond
      ((= nextpt "Undo")
        (setq tem nil temp T)
      )
      ((= nextpt "Dialog")
        (dd_wsh)
      )
      ((null nextpt)
        (setq cont nil tem nil)
      )
      (T
        (if (< (distance strtpt nextpt) 1200)
          (alert "두 점사이의 거리가 1200mm이상이어야 합니다." )
          (setq tem nil ptd T)
        )
      )
    )
  )
)

(defun wsh1_m3 ()
  (while ptd
    (initget "Dialog Undo")
    
    (setvar "orthomode" 0)
    (setq ptd (getpoint strtpt "\n    Dialog/Undo/<그리기 방향 지정>: "))
    
    
    (cond
      ((= ptd "Undo")
        (setq ptd nil tem T)
      )
      ((= ptd "Dialog")
        (dd_wsh)
      )
      ((= (type ptd) 'LIST)
        (command "_.undo" "_M")
        (wsh1_ex)
        (setq uctr (1+ uctr))
        (setq ptd nil temp T)
        (princ " \n")
      )
      (T
        (setq ptd nil cont nil)
      )
    )
  )
)

(defun wsh1_ex ()
  (setq pt1  strtpt
        pt2  nextpt
        d1   (distance pt1 pt2)
        ang (angle pt1 pt2)
        ang3 (angle pt2 pt1)
        ang1 (angle pt1 ptd)
  )
  (if (and (> ang1 ang) (< ang1 (+ ang (dtr 180))))
    (setq ang2 (+ ang (dtr 90.0)))
    (progn
    (if (and (>= ang (dtr 270)) (< ang1 pi))
    (setq ang2 (+ ang (dtr 90)))
    (setq ang2 (- ang (dtr 90))))
    )
  )
  (setq ang4 (+ ang2 (dtr 180))
        pt3  (polar pt1 ang2 230)
        pt4  (polar pt3 ang  (if (<= d1 1450) 240 290))
        pt5  (polar pt4 ang  220)
        pb1  (polar pt4 ang  110)
        pt6  (polar pt5 ang  (if (<= d1 1450) (- d1 1060) 390))
        pt7  (polar pt6 ang  300)
        pb2  (polar pt7 ang4 230)
        pt8  (polar pt7 ang  300)
        pt7  (polar pt7 ang2 300)
        pt9  (polar pt8 ang  (- d1 1500))
        pt10 (polar pt2 ang2 15)
        pt11 (polar pt1 ang2 15)
  )
  (set_col_lin_lay fixu:fprop)
  (command "_.pline" pt2 pt1 pt3 pt4 "")
  (ssget "L")
  (command "_.insert" "*feces" pb1 "" (rtd ang2))
  (command "_.pedit" "_L" "_J" "_P" "" "")
  (ssget "L")
  (if (< sc 200)
    (command "_.insert" "feces1" pb1 "" "" (rtd ang2))
  )
  (command "_.line" pt4 pt5 "")
  (command "_.pline" pt5 pt6 "")
  (command "_.pedit" "_L" "_J" "_P" "" "")
  (ssget "L")
  (if (< sc 200)
    (command "_.insert" "wshb1"  pb2 "" "" (rtd ang2))
    (command "_.insert" "wshb1S" pb2 "" "" (rtd ang2))
  )
  (command "_.arc" pt6 pt7 pt8)
  (command "_.pedit" "_L" "_Y" "_J" "_P" "" "")
  (ssget "L")
  (if (<= d1 1500)
    (command "_.pline" pt8 pt2 "")
    (command "_.pline" pt8 pt9 pt2 "")
  )
  (command "_.pedit" "_L" "_J" "_P" "" "")
  (if (< sc 200)
    (command "_.line" pt10 pt11 "")
  )
)

(defun dd_wsh (/ cancel_check ok_check tog_check)
  
  (setq dcl_id (ai_dcl "setprop"))
  (if (not (new_dialog "set_prop_c_la" dcl_id)) (exit))
  (@get_eval_prop fixu_prop_type fixu:prop)
  
  (action_tile "b_name" "(@getlayer)")
  (action_tile "b_color" "(@getcolor)")
  (action_tile "color_image"  "(@getcolor)")
  (action_tile "c_bylayer" "(@bylayer_do T)")
  (action_tile "cancel" "(setq cancel_check T)(done_dialog)")
  (start_dialog)
  (done_dialog)
  (if (= cancel_check nil)
	(PROP_SAVE fixu:prop)
  )

)

(defun C:cimWSH () (m:wsh1))
(princ)

