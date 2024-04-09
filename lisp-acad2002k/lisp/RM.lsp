; 작업일자: 2001.8.11
; 작업자:  박 율 구
; 명령어: CIMRM

; 작업일자: 2000.8.11
; 작업자: 김 병 용
; 명령어: DCL 추가

;---------------------------------------------------------------------------;
;   RM.LSP   Version 3.10
;   거실명 기입 
;     Copyright (C) 1993 by Korea CIM, LTD.
;     
;     Permission to use, copy, modify, and distribute this software 
;     for any purpose and without fee is hereby granted, provided 
;     that the above copyright notice appears in all copies and that 
;     both that copyright notice and this permission notice appear in 
;     all supporting documentation.
;
;     THIS SOFTWARE IS PROVIDED "AS IS" WITHOUT EXPRESS OR IMPLIED
;     WARRANTY.  ALL IMPLIED WARRANTIES OF FITNESS FOR ANY PARTICULAR
;     PURPOSE AND OF MERCHANTABILITY ARE HEREBY DISCLAIMED.
;
;   
;---------------------------------------------------------------------------;
;
;  DESCRIPTION
;
;    Implements a AN command to calculate a plottage and plot the site by
;    trigonometry.
;
;---------------------------------------------------------------------------;
;;;
;;; Main function
;;;
;단축키 관련 변수 정의 부분
(setq lfn25 1)

(defun m:rn (/  bm        temp      cont      uctr      _col      che
                p1        p2        p3        p4        p5        p6
                p7        p8        p9        p10       strtpt
                lay-idx   old-idx   ecolor    elayer    temp_color
                p_list    p_leng    lx_1      lx_2      lx_3      leng_1
                leng_2    leng_3    pt1       pt2       pt3       pt4
                pt5       pt6
                rn_osm    rn_err    rn_oer    rn_oco    rn_osc    
                rn_oli    rn_ola
                rn:col:dcl rn:tco:dcl rn:lay:dcl rn:the:dcl
	        rn:ost:dcl rn:che:dcl rn:sch:dcl rn:num:dcl rn:type:dcl
                cancel_check ok_check color_check)

  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n실명을 작성하는 명령입니다.")

  (setq rn_osc (getvar "dimscale"))  

	
  (ai_err_on) 
  (ai_undo_on)
  ;기본 setting
  (rn_init)
  
  (setvar "osmode" 0)  
  (setvar "blipmode" 0)  

  (setq cont T uctr 0 temp T)

  (while cont
    (rn_m1)
  )
  
  (command "_.undo" "_en")
  (ai_undo_off)
  (ai_err_off)

  (princ)
)

;변수가 null값을때 기본 setting 
(defun rn_init ()  
  (if (= rn:type nil) (setq rn:type "3"))  
  (if (/= (type rn:num) 'INT) (setq rn:num 101) )
  (if (= rn:nhead nil) (setq rn:nhead ""))
  (if (> rn:num -1)
  	(setq rn:ntxt (strcat rn:nhead (itoa rn:num))) 
  	(setq rn:ntxt rn:nhead) 
  )    
  (if (= rn:txt nil) (setq rn:txt ""))
  (if (or (= rn:che nil) (= rn:che "")) (setq rn:che "2400"))
  (if (or (= rn:sch nil) (= rn:sch "")) (setq rn:sch "25")) 
  (if (null rn:sty) (setq rn:sty "CIHS"))
  (if (null rn:the) (setq rn:the 3))  
)

(defun rn_m1 ()
  (while temp 
    (if (> uctr 0)
      (progn      
        (initget "Dialog Undo")
        (setq strtpt (getpoint
            "\n>>> Dialog/Undo/<위치>: "))
      )
      (progn
        (initget "Dialog")
        (setq strtpt (getpoint
            "\n>>> Dialog/<위치>: "))
      )
    )    
    (cond
      ((= strtpt "Dialog")
        (rn_dialog)
      )
      ((= strtpt "Undo")
        (command "_.undo" "_B")
        (setq uctr (1- uctr))
      )
      ((null strtpt)
        (setq cont nil temp nil)
      )
      (T
        (command "_.Undo" "_M")
        (rn_ex)
        (setq uctr (1+ uctr))
      )
    )
  )
)

;쓸 변수들을 dcl용 변수로 임시로 저장
(defun rnval_to_dclval ()
	(setq rn:the:dcl rn:the)	     ;텍스트 높이
	(setq rn:sty:dcl (strcase rn:sty))   ;텍스트 스타일 
	(setq rn:che:dcl rn:che)             ;천정고
	(setq rn:sch:dcl rn:sch)	     ;면적
	(setq rn:nhead:dcl rn:nhead)         ;실번호의 텍스트 부분	
	(setq rn:num:dcl rn:num)	     ;실번호 정수부분
	(setq rn:ntxt:dcl rn:ntxt)	     ;실번호
	(setq rn:type:dcl rn:type)	     ;실명 타입
	(setq rn:txt:dcl rn:txt)	     ;실명
)

(defun dclval_to_rnval ()
	(setq rn:the rn:the:dcl)
	(setq rn:sty rn:sty:dcl)
	(setq rn:che rn:che:dcl)
	(setq rn:sch rn:sch:dcl)
	(setq rn:nhead rn:nhead:dcl)
	(setq rn:num rn:num:dcl)
	(setq rn:ntxt rn:ntxt:dcl)
	(setq rn:type rn:type:dcl)
	(setq rn:txt rn:txt:dcl)	   
)

;Main Dialog 
(defun rn_dialog ()  
  
  (rnval_to_dclval)   
  ; for user press cancel
  (setq old:nprop rm:nprop
	old:bprop rm:bprop
  )	
  
  (setq ok_check nil tog_check nil color_check nil)
  (readf "rmtitle.dat" T)
  (setq dcl_id (ai_dcl "rm"))
  (if (not (new_dialog "dd_rm" dcl_id)) (exit))
  
  ;============<<<  2  >>>====================================
  (set_tile rm_prop_type "1")
  (@get_eval_prop rm_prop_type rm:prop)
  ;===========================================================
  
  ;특성 부분    
  ;====================<<<  3  >>>================================================================
  (action_tile "b_name" "(@getlayer)")
  (action_tile "b_color" "(@getcolor)")
  (action_tile "color_image" "(@getcolor)")
  (action_tile "c_bylayer" "(@bylayer_do T)"); T=color or nil=linetype
  (action_tile "prop_radio" "(setq rm_prop_type $value)(@get_eval_prop rm_prop_type rm:prop)")
  ;===============================================================================================    
  
  ;symbol option
  (set_tile "ed_number" rn:ntxt:dcl)
  (set_tile "ed_height" rn:che:dcl)
  (set_tile "ed_schedule" rn:sch:dcl)  
  (dcl:name_type rn:type:dcl)	;radio_button set_tile 
  (action_tile "rn_type_radio" "(rn_get_type)")
  (action_tile "ed_number" "(ntxt_nhead $value)")
  (action_tile "ed_height" "(setq rn:che:dcl $value)")
  (action_tile "ed_schedule" "(setq rn:sch:dcl $value)")
 
  ;실명
  (list_view2)
  (set_tile "ed_text" rn:txt:dcl)
  (action_tile "ed_text" "(setq rn:txt:dcl $Value)")
  (action_tile "list_text" "(rn_DoubleClick? $Value)")
  (action_tile "eb_delete"      "(eb_delete_F)")
  (action_tile "eb_add"         "(eb_add_F)")  
  
  ;텍스트 옵션
  (pop_set "pop_textstyle")    
  (set_tile "pop_textstyle" (itoa (get_index rn:sty:dcl stnmlst)))  
  (set_tile "ed_textsize" (rtos rn:the:dcl)) 
  (ci_image "text_image" (nth (atoi (get_tile "pop_textstyle")) slblist)) 
  (action_tile "pop_textstyle" "(get_style)")
  (action_tile "ed_textsize"   "(setq rn:the:dcl $value)(setq rn:the:dcl (distof rn:the:dcl))")    
  
  (action_tile "accept" "(setq ok_check T)(done_dialog)")
  (action_tile "cancel" "(setq ok_check nil)(done_dialog)")
  (start_dialog)  
  (done_dialog)  
  (writeF "rmtitle.dat" T) 
  
  (if (= ok_check T)
  	(progn
  	  	;==================<<<  4  >>>====================
  		(prop_save rm:prop)
  		;=================================================
		(dclval_to_rnval)  	
  	)
  	(progn 
  	    (setq  rm:bprop old:bprop
		   rm:nprop old:nprop 
	    )
	)    
  )
)

;DCL list바꿔짐
(defun rn_DoubleClick? (index / splitchar)
 (setq L_index (atoi index))
 (if (= index preindex)
   (progn     
     (set_tile "ed_text" (cdr (nth (atoi index) @Type)))
     (setq rn:txt:dcl (cdr (nth (atoi index) @Type))  )
     (setq preindex nil)
   )
   (setq preindex index) 
 )
)

;DCL-텍스트 스타일 바꿔짐
(defun get_style (/ idx)
  (setq idx (atoi (get_tile "pop_textstyle")))  
  (ci_image "text_image" (nth idx slblist))   
  (setq rn:sty:dcl (nth idx stnmlst))
) 

;실번호 입력되는 값을 숫자값과 문자값으로 나누는 함수
(defun ntxt_nhead (rn:value / rn:temp1 rn:temp2)	
	(if (/= rn:value nil) 
		(progn		
			(if (/= -1 (what_num rn:value))
				(progn				
					(setq rn:temp1 (what_num rn:value))
					(setq rn:num:dcl (atoi rn:temp1))
				)
				(progn
					(setq rn:temp1 "")
					(setq rn:num:dcl -1)
				)
			)
			(setq rn:temp2 (substr rn:value 1 (- (strlen rn:value) (strlen rn:temp1)) )   )
			(setq rn:ntxt:dcl rn:value)										
			(if (/= rn:temp2 nil)
				(setq rn:nhead:dcl rn:temp2)
				(setq rn:nhead:dcl "")
			)
		)
	)	
)

;타입 라디오 버튼 클릭
(defun rn_get_type ()		
	(cond 
		((/= "0" (get_tile "rd_type1")) 
			(progn  (dcl:name_type "1")
			)
		)
		((/= "0" (get_tile "rd_type2"))  
			(progn  (dcl:name_type "2")
			)
		)		
		((/= "0" (get_tile "rd_type3")) 
			(progn  (dcl:name_type "3")
			)
		)		
		((/= "0" (get_tile "rd_type4"))  
			(progn  (dcl:name_type "4")
			)
		)
		
	)
)

;type 에 따른 실명 option editor박스 활성화에 관한...
(defun dcl:name_type (value)	
	(cond
		((= value "1")
		(progn			
			(set_tile "rd_type1" "1")			
			(mode_tile "ed_number" 1)
			(mode_tile "ed_height" 1)
			(mode_tile "ed_schedule" 1)
			(ci_image "bn_room_image" "al_core(rm01)")    
			(setq rn:type:dcl "1")
		)
		)
		((= value "2")
		(progn		
			(set_tile "rd_type2" "1")		
			(mode_tile "ed_number" 0)
			(mode_tile "ed_height" 1)
			(mode_tile "ed_schedule" 1)
			(ci_image "bn_room_image" "al_core(rm02)")    
			(setq rn:type:dcl "2")
		)
		)
		((= value "3")
		(progn			
			(set_tile "rd_type3" "1")			
			(mode_tile "ed_number" 0)
			(mode_tile "ed_height" 0)
			(mode_tile "ed_schedule" 1)
			(ci_image "bn_room_image" "al_core(rm03)")    
			(setq rn:type:dcl "3")
		)
		)		
		((= value "4")
		(progn			
			(set_tile "rd_type4" "1")
			(mode_tile "ed_number" 0)
			(mode_tile "ed_height" 0)
			(mode_tile "ed_schedule"0)
			(ci_image "bn_room_image" "al_core(rm04)")    
			(setq rn:type:dcl "4")
		)
		)
	)
)

;=====================================================================
;실번호,실명,천정고 그리기  Main
;=====================================================================
(defun rn_ex ()
  (if (not (stysearch rn:sty))
    (styleset rn:sty)
  )  
  (setvar "textstyle" rn:sty)  
  
  (cond 
  	((= rn:type "1")
  		(rn_ex1)
  	)
  	((= rn:type "2")
  		(rn_ex2)
  	)
  	((= rn:type "3")
  		(rn_ex3)
  	)
  	((= rn:type "4")
  		(rn_ex4)
  	)
  )
)

;=====================================================================
;실명 그리기  type1
;=====================================================================
(defun rn_ex1 (/ text_1 )
  
  (setq p1 (polar strtpt (dtr 90) (* rn_osc (+ 3 rn:the))) 
        pt1 (polar p1 (dtr 270) (* rn_osc (+ rn:the 1.5)))
        pt1 (polar pt1 0 (* 1.5 rn_osc))     
  ) 
 
  ;텍스트
  (set_col_lin_lay rm:nprop)
  (command "_.text" pt1 (* rn_osc rn:the) 0 rn:txt)
  (setq p_list (textbox (entget (entlast))))			;Number,Name,Height중 가장 긴 길이에 맞춤(여기선 Number)   
 
  ;박스라인
  (setq p_leng (- (car (nth 1 p_list)) (car (nth 0 p_list))))
  (setq leng_1 (+ p_leng (* rn_osc 3.5)))
  (setq pt4 (polar pt1 0 leng_1))
  (setq lx_1 (+ p_leng (* rn_osc 3)))  
  (setq lx_2 (max leng_1))
  (setq lx_3 (* rn_osc (+ 3 rn:the)))
  (setq p2  (polar p1 0 lx_2)
        p3  (polar p2 (dtr 270) lx_3)
        p4  (polar p1 (dtr 270) lx_3)       
  )
  
  (set_col_lin_lay rm:bprop)
  (command "_.pline" p1 p2 p3 p4 "_C")
)

;=====================================================================
;실번호,실명 그리기  type2
;=====================================================================
(defun rn_ex2 (/ text_1 text_2 text_3)
  (setq p1 (polar strtpt (dtr 90) (* (* rn_osc (+ 3 rn:the)) 2)) 
        pt1 (polar p1 (dtr 270) (* rn_osc (+ rn:the 1.5)))
        pt1 (polar pt1 0 (* 1.5 rn_osc))     
        pt2 (polar pt1 (dtr 270) (* rn_osc (+ 3 rn:the)))
  ) 
 
  (setq text_1 "실번호"
       text_2 "실  명"
  )
  ;텍스트
  (set_col_lin_lay rm:nprop)
  (command "_.text" pt1 (* rn_osc rn:the) 0 text_1)
  (setq p_list (textbox (entget (entlast))))			;Number,Name,Height중 가장 긴 길이에 맞춤(여기선 Number) 
  (command "_.text" pt2 (* rn_osc rn:the) 0 text_2)  
  ;(command "_.color" "_bylayer")  
  (setq p_leng (- (car (nth 1 p_list)) (car (nth 0 p_list))))
  (setq leng_1 (+ p_leng (* rn_osc 3.5)))
  (setq pt4 (polar pt1 0 leng_1)
        pt5 (polar pt2 0 leng_1)
  )
  (setq lx_1 (+ p_leng (* rn_osc 3)))
   
  ; 실번호 
  (command "_.text" pt4 (* rn_osc rn:the) 0 rn:ntxt)
  (setq p_list (textbox (entget (entlast))))
  (setq p_leng (- (car (nth 1 p_list)) (car (nth 0 p_list))))
  (setq leng_1 (+ p_leng (* rn_osc 4)))
  
  ;실명
  (command "_.text" pt5 (* rn_osc rn:the) 0 rn:txt)
  (setq p_list (textbox (entget (entlast))))
  (setq p_leng (- (car (nth 1 p_list)) (car (nth 0 p_list))))
  (setq leng_2 (+ p_leng (* rn_osc 4)))  
  
  (setq lx_2 (max leng_1 leng_2))
  (setq lx_3 (* rn_osc (+ 3 rn:the)))
  (setq p2  (polar p1 0 (+ lx_1 lx_2))
        p3  (polar p2 (dtr 270) (* 2 lx_3))
        p4  (polar p1 (dtr 270) (* 2 lx_3))
        p5  (polar p1 (dtr 270) lx_3)
        p6  (polar p2 (dtr 270) lx_3)        
        p9  (polar p1 0 lx_1)
        p10 (polar p4 0 lx_1)
  )
  (set_col_lin_lay rm:bprop)
  (command "_.pline" p1 p2 p3 p4 "_C")
  (command "_.line" p5 p6 "")  
  (command "_.line" p9 p10 "")
)


;=====================================================================
;실번호,실명,천정고 그리기  type3
;=====================================================================
(defun rn_ex3 (/ text_1 text_2 text_3)
  (setq p1 (polar strtpt (dtr 90) (* (* rn_osc (+ 3 rn:the)) 3)) 
        pt1 (polar p1 (dtr 270) (* rn_osc (+ rn:the 1.5)))
        pt1 (polar pt1 0 (* 1.5 rn_osc))
        pt2 (polar pt1 (dtr 270) (* rn_osc (+ 3 rn:the)))
        pt3 (polar pt2 (dtr 270) (* rn_osc (+ 3 rn:the)))
  )
 
 (setq text_1 "실번호"
       text_2 "실  명"
       text_3 "천정고"
       text_4 "면  적"
 ) 
  ;텍스트
  (set_col_lin_lay rm:nprop)
  (command "_.text" pt1 (* rn_osc rn:the) 0 text_1)
  (setq p_list (textbox (entget (entlast))))			;Number,Name,Height중 가장 긴 길이에 맞춤(여기선 Number) 
  (command "_.text" pt2 (* rn_osc rn:the) 0 text_2)
  (command "_.text" pt3 (* rn_osc rn:the) 0 text_3)
  ;(command "_.color" "_bylayer")  
  (setq p_leng (- (car (nth 1 p_list)) (car (nth 0 p_list))))
  (setq leng_1 (+ p_leng (* rn_osc 3.5)))
  (setq pt4 (polar pt1 0 leng_1)
        pt5 (polar pt2 0 leng_1)
        pt6 (polar pt3 0 leng_1)
  )
  (setq lx_1 (+ p_leng (* rn_osc 3)))  
   
  ; 실번호 
  (command "_.text" pt4 (* rn_osc rn:the) 0 rn:ntxt)
  (setq p_list (textbox (entget (entlast))))
  (setq p_leng (- (car (nth 1 p_list)) (car (nth 0 p_list))))
  (setq leng_1 (+ p_leng (* rn_osc 4)))
  
  ;실명
  (command "_.text" pt5 (* rn_osc rn:the) 0 rn:txt)
  (setq p_list (textbox (entget (entlast))))
  (setq p_leng (- (car (nth 1 p_list)) (car (nth 0 p_list))))
  (setq leng_2 (+ p_leng (* rn_osc 4)))
  
  
  ;천정고      
  (command "_.text" pt6 (* rn_osc rn:the) 0 (strcat rn:che "mm"))  
  
  ;나머지 라인 그리기
  (setq p_list (textbox (entget (entlast))))
  (setq p_leng (- (car (nth 1 p_list)) (car (nth 0 p_list))))
  (setq leng_3 (+ p_leng (* rn_osc 4)))
  (setq lx_2 (max leng_1 leng_2 leng_3))
  (setq lx_3 (* rn_osc (+ 3 rn:the)))
  (setq p2  (polar p1 0 (+ lx_1 lx_2))
        p3  (polar p2 (dtr 270) (* 3 lx_3))
        p4  (polar p1 (dtr 270) (* 3 lx_3))
        p5  (polar p1 (dtr 270) lx_3)
        p6  (polar p2 (dtr 270) lx_3)
        p7  (polar p5 (dtr 270) lx_3)
        p8  (polar p6 (dtr 270) lx_3)
        p9  (polar p1 0 lx_1)
        p10 (polar p4 0 lx_1)
  )
  (set_col_lin_lay rm:bprop)
  (command "_.pline" p1 p2 p3 p4 "_C")
  (command "_.line" p5 p6 "")
  (command "_.line" p7 p8 "")
  (command "_.line" p9 p10 "")
)

;=====================================================================
;실번호,실명,천정고,면적 그리기  type4
;=====================================================================
(defun rn_ex4 (/ text_1 text_2 text_3 text_4 pt11 pt12)
  ;pt1,pt2,pt3,pt4 텍스트 위치
  (setq p1 (polar strtpt (dtr 90) (* (* rn_osc (+ 3 rn:the)) 2)) 
        pt1 (polar p1 (dtr 270) (* rn_osc (+ rn:the 1.5)))
        pt1 (polar pt1 0 (* 1.5 rn_osc))     
        pt2 (polar pt1 (dtr 270) (* rn_osc (+ 3 rn:the)))        
  ) 
 
  (setq text_1 "실번호"
       text_2 "실  명"
       text_3 "천장고"
       text_4 "면  적"
  )
  ;텍스트 (실번호,실명)
  (set_col_lin_lay rm:nprop)
  (command "_.text" pt1 (* rn_osc rn:the) 0 text_1)
  (setq p_list (textbox (entget (entlast))))			;Number,Name,Height중 가장 긴 길이에 맞춤(여기선 Number) 
  (command "_.text" pt2 (* rn_osc rn:the) 0 text_2)  
  ;(command "_.color" "_bylayer")  
  (setq p_leng (- (car (nth 1 p_list)) (car (nth 0 p_list))))
  (setq leng_1 (+ p_leng (* rn_osc 3.5)))
  (setq pt4 (polar pt1 0 leng_1)
        pt5 (polar pt2 0 leng_1)
  )
  (setq lx_1 (+ p_leng (* rn_osc 3)))
     
  ; 실번호 
  (command "_.text" pt4 (* rn_osc rn:the) 0 rn:ntxt)
  (setq p_list (textbox (entget (entlast))))
  (setq p_leng (- (car (nth 1 p_list)) (car (nth 0 p_list))))
  (setq leng_1 (+ p_leng (* rn_osc 4)))
  
  ;실명
  (command "_.text" pt5 (* rn_osc rn:the) 0 rn:txt)
  (setq p_list (textbox (entget (entlast))))
  (setq p_leng (- (car (nth 1 p_list)) (car (nth 0 p_list))))
  (setq leng_2 (+ p_leng (* rn_osc 4)))    
  (setq lx_2 (max leng_1 leng_2))
  (setq lx_3 (* rn_osc (+ 3 rn:the)))
  (setq p2  (polar p1 0 (+ lx_1 lx_2))
        p3  (polar p2 (dtr 270) (* 2 lx_3))
        p4  (polar p1 (dtr 270) (* 2 lx_3))  
        p5  (polar p1 (dtr 270) lx_3)
        p6  (polar p2 (dtr 270) lx_3)        
        p9  (polar p1 0 lx_1)
        p10 (polar p4 0 lx_1)
  )
  
  ;텍스트(천장고,면적) 
  (setq  pt1_1 (polar p2 (dtr 270) (* rn_osc (+ rn:the 1.5)))
         pt1_1 (polar pt1_1 0 (* 1.5 rn_osc))       
         pt2_1 (polar pt1_1 (dtr 270) (* rn_osc (+ 3 rn:the)))        
  )  
  (command "_.text" pt1_1 (* rn_osc rn:the) 0 text_3)
  (setq p_list (textbox (entget (entlast))))			;Number,Name,Height중 가장 긴 길이에 맞춤(여기선 Number) 
  (command "_.text" pt2_1 (* rn_osc rn:the) 0 text_4)  
  ;(command "_.color" "_bylayer")  
  (setq p_leng (- (car (nth 1 p_list)) (car (nth 0 p_list))))
  (setq leng_3 (+ p_leng (* rn_osc 3.5)))
  (setq pt4_1 (polar pt1_1 0 leng_3)
        pt5_1 (polar pt2_1 0 leng_3)
  )
 ; (setq lx_1 (+ p_leng (* rn_osc 3)))  
  
  ; 천정고
  (command "_.text" pt4_1 (* rn_osc rn:the) 0 (strcat rn:che "mm"))
  (setq p_list (textbox (entget (entlast))))
  (setq p_leng (- (car (nth 1 p_list)) (car (nth 0 p_list))))
  (setq leng_1 (+ p_leng (* rn_osc 4)))
  
  ;면적
  (command "_.text" pt5_1 (* rn_osc rn:the) 0 (strcat rn:sch "m2"))
  (setq p_list (textbox (entget (entlast))))
  (setq p_leng (- (car (nth 1 p_list)) (car (nth 0 p_list))))
  (setq leng_2 (+ p_leng (* rn_osc 4)))    
  
  (setq lx_2 (max leng_1 leng_2)) 
  (setq p11 p2
  	p12 p3
  	p2  (polar p2 0 (+ lx_1 lx_2))
        p3  (polar p2 (dtr 270) (* 2 lx_3))                
        p6  (polar p2 (dtr 270) lx_3)        
        p9_1  (polar p11 0 lx_1)
        p10_1 (polar p12 0 lx_1)
  )
    
  (set_col_lin_lay rm:bprop)
  (command "_.pline" p1 p2 p3 p4 "_C")
  (command "_.line" p5 p6 "")  
  (command "_.line" p9 p10 "")
  (command "_.line" p9_1 p10_1 "")
  (command "_.line" p11 p12 "")
)


;문자입력을 하면 끝에 있는 숫자만 리턴됨
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
   "-1"
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

;====================<< 1 >>=====================================
(setq rm:bprop  (Prop_search "rm" "box"))
(setq rm:nprop  (Prop_search "rm" "name"))
(setq rm:prop '(rm:bprop rm:nprop))

(if (null rm_prop_type) (setq rm_prop_type "rd_box"))
;======================================================================

(defun C:CIMRM () (m:rn))
(princ)