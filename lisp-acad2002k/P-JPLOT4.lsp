
(defun c:ppz()
	(setq a (getvar "extmin") b (getvar "extmax"))
	(command "line" a b "")
	(command "rectangle" a b)
)

(defun scrBox+p (pixels / scrsize viewctr viewsize y/2 x/2 zz 1pixel)
	(setq scrsize (getvar "screensize"))	;; X Y screensize in pixel unit ;;
	(setq viewctr (getvar "viewctr"))		;; center point of view ;;
	(setq viewsize (getvar "viewsize"))		;; height of view ;;
	(setq zz (getvar "elevation"))
	(setq y/2 (/ viewsize 2.0))
	(setq x/2 (* (/ (car scrsize) (cadr scrsize)) y/2))
	(setq 1pixel (* (/ viewsize (cadr scrsize)) pixels))
	(list
		(list (- (car viewctr) x/2 1pixel) (- (cadr viewctr) y/2 1pixel) zz)
		(list (+ (car viewctr) x/2 1pixel) (+ (cadr viewctr) y/2 1pixel) zz)
	)
)

;run to plot
(defun ppp (/ pl_p1 pl_p2 pl_sc)
	
	; extend, limits
	(cond
		((= jplot_w "W")(setq pl_p1(getpoint "\n\t 왼쪽하단 출력점 ? :")
									 pl_p2(getcorner pl_p1 "\n\t 오른쪽상단 출력점 ? :")))
		((= jplot_w "E")(setq pl_p1(getvar "EXTMIN")
									 pl_p2(getvar "EXTMAX")))
		((= jplot_w "L")(setq pl_p1(getvar "LIMMIN")
									 pl_p2(getvar "LIMMAX")))
		((= jplot_w "D")(setq pl_p1 (car  (scrBox+p 0))
									 pl_p2 (cadr (scrBox+p 0))))
	)

	(if (= jplot10 10)(setq jplot_file "Y")(setq jplot_file "N"))
	(if (= jplot_na "jinhp.pc3")(exit))
	(command "_.plot"
	"Y"					; 상세구성?
	"model"				; 배치,모형
	jplot_na				; 출력장치
	jplot_size			; 용지규격 
	"M"					; 용지단위 (인치/미리)
	"L"					; 용지(가로/세로)
	"N"					; 뒤집어서출력?
	"W" pl_p1 pl_p2	; 화면/한계/리미트/뷰/윈도
	jplot_sc				; 스케일
	"중심"					; 간격띄우기 x,y/중심
	"Y"					; 유형적용?
	jplot_pen			; 유형이름?
	"Y"					; 선가중치적용?
	"N"					; 은선제거?
	jplot_file			; 파일로출력?
	"Y"					; 변경사항저장?
	"Y"					; 출력ok?
	(if (= jplot10 10)(command "N"))
	)
	(prompt "\n 범위=>\"")(prin1 pl_p1)(prompt ",")(prin1 pl_p2)
	(prompt "\"\n 장치=>")(prin1 jplot_na)(prompt ", 축척=>")(prin1 jplot_sc)(prompt "")
	(prompt ", 용지=>")(prin1 jplot_size)(prin1)
	(if (= jplot10 10)(command "preview"))
)

;XP or 98SE

(COND
	((= (getvar "PLATFORM") "Microsoft Windows NT Version 5.1 (x86)")(setq os_ver "XP"))
)

;old setting call
(defun jplot_run_old(/ aa)
	(cond 
		((= jplot_w "L")(set_tile "jplot4_b" "1"))
		((= jplot_w "D")(set_tile "jplot4_c" "1"))
		((= jplot_w "E")(set_tile "jplot4_d" "1"))
		(T (set_tile "jplot4_a" "1"))
	)

;	(setq ab 1)
	(cond 
		((= jplot_na "\\\\Kiheung\\기흥-LJ5K-2F")			(set_tile "jplot1_a" "1"))
		((= jplot_na "\\\\Kiheung\\HP LaserJet 4V")		(set_tile "jplot1_b" "1"))
		((= jplot_na "\\\\jin99\\HP DESIGNJet 500 42+HPGL2 Card")	(set_tile "jplot1_c" "1"))
		((= jplot_na "a3.pc3")				(set_tile "jplot1_d" "1"))
		(T (set_tile "jplot1_a" "1"))
	)

;	(setq ab 2)
	(cond 
		((= jplot_size "A3")(set_tile "jplot2_a" "1"))
		((= jplot_size "A4")(set_tile "jplot2_b" "1"))
		((= jplot_size "확장 크기:ISO A1  (세로방향)")	(set_tile "jplot2_c" "1"))
		((= jplot_size "확장 크기:ISO A1  (가로방향)")	(set_tile "jplot2_d" "1"))
		(T (set_tile "jplot2_a" "1"))
	)

;	(setq ab 3)
	(cond 
		((= jplot_pen "Aclt_WB_A3.ctb")(set_tile "jplot11_a" "1"))
		((= jplot_pen "Aclt_CO_A3.ctb")(set_tile "jplot11_b" "1"))
		((= jplot_pen "Aclt_WB_A1.ctb")(set_tile "jplot11_c" "1"))
		((= jplot_pen "Aclt_CO_A1.ctb")(set_tile "jplot11_d" "1"))
		(T (set_tile "jplot11_a" "1"))
	)

;	(setq ab 4)
	(setq aa (strcat "1:" (rtos (* (getvar "LTSCALE") 2) 2 0)))
	(setq bb (strcat "1:" (rtos (getvar "LTSCALE") 2 0)))

;	(setq ab 5)
	(cond 
		((= jplot_sc "Fit")	(set_tile "jplot3_d" "1"))
		((= jplot_sc aa)		(set_tile "jplot3_c" "1"))
		((= jplot_sc bb)		(set_tile "jplot3_b" "1"))
		((= jplot_sc nil)		(set_tile "jplot3_d" "1"))
		(T							(set_tile "jplot3_aa" (substr jplot_sc 3 10))(set_tile "jplot3_a" "1"))
	)

;	(setq ab 6)
)

;atcion 1,2,11
(defun jplot_run1() ; 장치
	(setq jplot_na0	"\\\\Kiheung\\기흥-LJ5K-2F")
	(setq jplot_na1	"\\\\Kiheung\\HP LaserJet 4V")
	(setq jplot_na2	"\\\\jin99\\HP DESIGNJet 500 42+HPGL2 Card")
	(setq jplot_na10	"a3.pc3")
	(cond
		((= (get_tile "jplot1_a") "1")	(setq jplot_na jplot_na0))
		((= (get_tile "jplot1_b") "1")	(setq jplot_na jplot_na1))
		((= (get_tile "jplot1_c") "1")	(setq jplot_na jplot_na2))
		((= (get_tile "jplot1_d") "1")	(setq jplot_na jplot_na10))
	)
)

(defun jplot_run2() ; 용지
	(setq jplot_11 "A3")
	(setq jplot_12 "A4")
	(setq jplot_13 "확장 크기:ISO A1  (세로방향)")
	(setq jplot_14 "확장 크기:ISO A1  (가로방향)")
	(cond
		((= (get_tile "jplot2_a") "1")(setq jplot_size jplot_11))
		((= (get_tile "jplot2_b") "1")(setq jplot_size jplot_12))
		((= (get_tile "jplot2_c") "1")(setq jplot_size jplot_13))
		((= (get_tile "jplot2_d") "1")(setq jplot_size jplot_14))
	)
)

;action 3,4,5
(defun jplot_run3() ; scale
	(setq aa (strcat "1:" (rtos (* (getvar "LTSCALE") 2) 2 0)))
	(setq bb (strcat "1:" (rtos (getvar "LTSCALE") 2 0)))
	(setq cc (strcat "1:" (get_tile "jplot3_aa")))
	(cond
		((= (get_tile "jplot3_a") "1")(setq jplot_sc cc))
		((= (get_tile "jplot3_b") "1")(setq jplot_sc bb))
		((= (get_tile "jplot3_c") "1")(setq jplot_sc aa))
		((= (get_tile "jplot3_d") "1")(setq jplot_sc "Fit"))
		(T (jplot_sc "Fit"))
	)
)

;action 6,7,8,9
(defun jplot_run6()
	(cond
		((= (get_tile "jplot4_a") "1")(setq jplot_w "W"))
		((= (get_tile "jplot4_b") "1")(setq jplot_w "L"))
		((= (get_tile "jplot4_c") "1")(setq jplot_w "V"))
		((= (get_tile "jplot4_d") "1")(setq jplot_w "E"))
		(T (setq jplot_w "W"))
	)
)

(defun get_jpoint () ; window
	(if (= jplot_w "W")
		(progn
			(setq pl_p1(getpoint "\n\t 왼쪽하단 출력점 ? :")
					pl_p2(getcorner pl_p1 "\n\t 오른쪽상단 출력점 ? :")
			)
		)
	)
)

(defun jplot_run11() ; 색상
	(cond
		((= (get_tile "jplot11_a") "1")(setq jplot_pen "Aclt_WB_A3.ctb"))
		((= (get_tile "jplot11_b") "1")(setq jplot_pen "Aclt_CO_A3.ctb"))
		((= (get_tile "jplot11_c") "1")(setq jplot_pen "Aclt_WB_A1.ctb"))
		((= (get_tile "jplot11_d") "1")(setq jplot_pen "Aclt_CO_A1.ctb"))
		(T (setq jplot_pen "Aclt_WB_A3.ctb"))
	)
)

;main
(setq jinbox_plot nil)

(defun plan-color (a / la-1)
	(if (setq la-1 (tblsearch "layer" "plan"))
		(command "layer" "color" 9 "plan,arch,back" "")
	)
)

(defun jplot_a1()
	(set_tile "jplot2_c" "1")
	(set_tile "jplot3_b" "1")
	(set_tile "jplot11_c" "1")
)

(defun jplot_edit3a(a)
	(if (= a 1)
		(set_tile "jplot3_a" "1")
		(if (= a 2)
			(mode_tile "jplot3_aa" 2)
		)
	)
)

(defun C:PPP(/ xxx pl_p1 pl_p2 jplot10)
	(plan-color 9)	;	건축도면색상을 9번으로 맞춤....
	(ai_sysvar '(("osmode" . 41)("cmdecho" . 0)))
	(if (= jinbox_plot nil)(setq jinbox_plot(load_dialog "jplot4")))
	(setq xxx 3 jplot10 nil)
	(while (> 998 xxx 1)
		(new_dialog "jinbox_plot" jinbox_plot)

		(jplot_run_old)
		(mode_tile "jplot1_d" 1)
		(set_tile "jplot3_ab" (strcat "1 : " (rtos (getvar "LTSCALE") 2 0)))
		(set_tile "jplot3_ac" (strcat "1 : " (rtos (* (getvar "LTSCALE") 2) 2 0)))

;		(action_tile "jplot1_a"  "(jplot_run1 a)")	;	플롯장치
;		(action_tile "jplot1_b"  "(jplot_run1 a)")	;	플롯장치
		(action_tile "jplot1_c"  "(jplot_a1)")	;	플롯장치
;		(action_tile "jplot1_d"  "(jplot_run1 a)")	;	플롯장치
		
;		(action_tile "jplot2_a"  "(setq a $value)(jplot_run2 a)")	;	플롯용지
;		(action_tile "jplot2_b"  "(setq a $value)(jplot_run2 a)")	;	플롯용지
;		(action_tile "jplot2_c"  "(setq a $value)(jplot_run2 a)")	;	플롯용지
;		(action_tile "jplot2_d"  "(setq a $value)(jplot_run2 a)")	;	플롯용지

;		(action_tile "jplot11_a" "(setq a $value)(jplot_run11 a)")	;	플롯색상
;		(action_tile "jplot11_b" "(setq a $value)(jplot_run11 a)")	;	플롯색상
;		(action_tile "jplot11_c" "(setq a $value)(jplot_run11 a)")	;	플롯색상
;		(action_tile "jplot11_d" "(setq a $value)(jplot_run11 a)")	;	플롯색상
		
		(action_tile "jplot3_aa" "(jplot_edit3a 1)")	;	축척지정
		(action_tile "jplot3_a" "(jplot_edit3a 2)")	;	축척지정
;		(action_tile "jplot3_b" "(jplot_run3 3)")	;	축척=라인스케일
;		(action_tile "jplot3_c" "(jplot_run3 4)")	;	축척=라인스케일*2
;		(action_tile "jplot3_d" "(jplot_run3 5)")	;	축척=없음

;		(action_tile "jplot4_a"  "(jplot_run6 6)")	;	출력범위 선택
;		(action_tile "jplot4_b"  "(jplot_run6 7)")	;	리미트값 출력
;		(action_tile "jplot4_c"  "(jplot_run6 8)")	;	보이는상태 출력
;		(action_tile "jplot4_d"  "(jplot_run6 9)")	;	전체를 출력
		
		(action_tile "jplot10" "(get_plot_setx)(setq jplot10 10)(done_dialog 999)")	;	미리보기로 출력

		(action_tile "pds_key" "(setq cal_key 98)(done_dialog 0)")
		(action_tile "help" "(help_cals)")
		(action_tile "cancel" "(done_dialog 0)")
		(action_tile "accept" "(get_plot_setx)(done_dialog 999)")
		(setq xxx (start_dialog))
	)
	(if (= xxx 999) (ppp))
	(ai_sysvar nil)
	(prin1)
)

(defun get_plot_setx()
	(jplot_run1)
	(jplot_run2)
	(jplot_run3)
	(jplot_run6)
	(jplot_run11)
)

(defun get_plot_set() ; get_tile

	(jplot_run1 (get_tile "jplot1"))
	(jplot_run2 (get_tile "jplot2"))

	(if (= (get_tile "jplot5") "1") 
		(setq jplot_sc "Fit")
		(if (= (get_tile "jplot4") "1") 
			(setq jplot_sc (strcat "1:" (rtos (* (getvar "LTSCALE") 2) 2 0)))
			(setq jplot_sc (strcat "1:" (get_tile "jplot3a")))
		)
	)

	(jplot_run11 (get_tile "jplot11"))

	(setq jplot10 (get_tile "jplot10"))

	(if (= (get_tile "jplot9a") "1")
		(setq jplot_w "E")
		(if (= (get_tile "jplot8a") "1")
			(setq jplot_w "D")
			(if (= (get_tile "jplot7a") "1")
				(setq jplot_w "L")
				(if (/= jplot_w "Complet")
					(setq jplot_w "W")
				)
			)
		)
	)
)

