(setq file_name_list nil)
(setq file_list nil)

(defun loadpaper(actlay / PAPERList)
	(setq lst (vlax-safearray->list (vlax-variant-value (vla-GetCanonicalMediaNames ActLay))))
	(foreach i lst
		(setq PAPERList (cons i PAPERList))
	);용지불러오기
	(setq PAPERList (vl-sort PAPERList '(lambda (a b) (< (strcase a) (strcase b))))) ;용지값 정렬
)

(defun loadprint(actlay / PRINTList)
	(setq lst (vlax-safearray->list (vlax-variant-value (vla-GetPlotDeviceNames ActLay))))
	(foreach i lst
		(setq PRINTList (cons i PRINTList))
	);프린터불러오기
	(setq PRINTList (vl-sort printList '(lambda (a b) (< (strcase a) (strcase b))))) ;프린트값 정렬
)

(defun loadctb(actlay / CTBList)
	(setq lst (vlax-safearray->list (vlax-variant-value (vla-GetPlotStyleTableNames ActLay))))
	(foreach i lst
		(setq CTBList (cons i CTBList))
	);ctb불러오기
	(setq CTBList (vl-sort ctbList '(lambda (a b) (< (strcase a) (strcase b))))) ;ctb값 정렬
)

(defun c:mpl_print(/ e_name prt_name paper_name ctb_name bn nblist sslist ss1 j ptlayout prt_layout r_ctab ss1)
	(vl-load-com)
	(setq bnlist nil)
	(setq r_ctab(getvar "ctab"))
	(setq e_name (getstring "도곽이름"))
	(setq prt_name (getstring t "플로터이름"))
	(setq paper_name (getstring t "용지이름"))
	(setq ctb_name (getstring t "ctb이름"))
	(setq pset (getstring "출력방향"))
	(setq file_path (getstring t "저장 경로"))
	(setq prb (getstring "플롯대상"))
	(setq sslist (ssadd))
	(cond
		((= prb "prb0")
			(command "setvar" "tilemode" 1)
			(setq prt_layout (list (getvar "ctab")))
			(setq prt_layout (append prt_layout (layoutlist)))
			
		)
		((= prb "prb1")
			(command "setvar" "tilemode" 1)
			(setq prt_layout (list (getvar "ctab")))
		)
		((= prb "prb2")
			(setq prt_layout (layoutlist))
			(command "setvar" "ctab" (nth 0 prt_layout))			
		)
	)
	(foreach ptlayout prt_layout
	(command "setvar" "ctab" ptlayout)
	(setq ActLay (vla-get-ActiveLayout (setq ActDoc(vla-get-activedocument(vlax-get-acad-object)))))
	(vla-put-ConfigName actlay prt_name)
	(vla-put-CanonicalMediaName actlay paper_name)
	(vla-put-StyleSheet actlay ctb_name)
	(if (= file_path (getvar "dwgprefix"))
		(setq file_path (getvar "dwgprefix"))
		(setq file_path (strcat file_path "\\"))
	)
	(setq bn (list e_name))
	(setq bnlist (append bnlist bn))
	(setq sslist (ssadd))
	(setq i 0)
	(foreach x bnlist
		(setq ss1 (ssget "x" (list (cons 0 "insert") (cons 2 x))))
		(setq j 0 ptlist '())
		(repeat (sslength ss1)
			(vla-GetBoundingBox (vlax-ename->vla-object (ssname ss1 j)) 'minpt 'maxpt)
			(setq pt(vlax-safearray->list minpt))
			(setq pt1(list (car pt)(cadr pt)))
			(setq pt(vlax-safearray->list maxpt))
			(setq pt2(list (car pt)(cadr pt)))
			(setq ptlist(append ptlist(list(list pt1 pt2))))
			(setq j (+ j 1))
		)
		(setq Lst(vl-sort (vl-sort ptlist '(lambda (a b) (< (caar a) (caar b)))) '(lambda (a b) (< (caadr a) (caadr b)))))
		(setq j 0)
;------------------------출력부분 시작------------------------------------
		(repeat (sslength ss1)
			(setq pt1 (car (nth j lst)))
			(setq pt2 (cadr (nth j lst)))
			(setq j (+ j 1))
			(setq i (+ i 1))
			
			(setq filename (vl-string-right-trim ".dwg" (getvar "dwgname")))
			
			(setq filename (strcat file_path filename))
			(setq filename (strcat filename "("))
			(setq filename (strcat filename (itoa i)))
			(setq filename (strcat filename ")"))
			(command "-plot" "y" "" "" "" "m" pset "n" "w" pt1 pt2 "f" "c" "y" ctb_name "y" "w" filename "y" "y")

			(princ "\n")
			(princ i)
			(princ pt1)

		)
;--------------------출력부분 종료-------------------------------------------
	);foreach 종료
	(princ)
	)
	(command "setvar" "ctab" r_ctab)
	(princ)

)
(defun c:mpl(/ CTBList PRINTList PAPERList num0 num1 num2 pset prt_name ctb_name paper_name ok bb sslist e_name file_name_list filename dwglist ptlist)

(PROMPT "\nMPL select")
(setq dcl_box (load_dialog "mpl.dcl")) 	; 해당 파일을 호출합니다.
(setq ok 2)
(setq bb 0)
(setq sslist nil)
(setq file_name_list nil)
(setq file_path nil)
(vl-load-com)					;vlisp함수 로드
(setq ActLay (vla-get-ActiveLayout (setq ActDoc(vla-get-activedocument(vlax-get-acad-object)))))
(vla-RefreshPlotDeviceInfo ActLay)

(setq printlist (loadprint actlay))			;프린터 설정 불러오기
(setq paperlist (loadpaper actlay))			;기본 프린터와 연결된 용지설정 불러오기
(setq ctblist (loadctb actlay))				;ctb설정 불러오기
(setq prt_name (vla-get-ConfigName actLay ))		;기본 프린터 설정
(setq ctb_name (vla-get-StyleSheet actLay))		;기본 CTB 설정
(setq paper_name (vla-get-CanonicalMediaName actLay))	;기본 용지 저장
;(vla-put-ConfigName actLay prt_name)			;기본 프린터 저장
;(vla-put-CanonicalMediaName actLay paper_name)		;기본 용지 저장
;(vla-put-StyleSheet actLay ctb_name)			;기본 CTB 저장
(setq pset "L" prb "prb1" rb "rb0" aa "0" prt_file_path "")
(setq dwglist nil)
(while (= ok 2)
	(new_dialog "mpl" dcl_box)

	(start_list "printlist")
	(mapcar 'add_list PRINTList)
	(end_list)

	(start_list "plotlist")
	(mapcar 'add_list CTBList)
	(end_list)

	(start_list "paperlist")
	(mapcar 'add_list PAPERList)
	(end_list)

	(start_list "dwg_list")
	(mapcar 'add_list file_name_list)
	(end_list)

	(setq i 0)
		(defun plot_row(rb)
			(cond
				((= rb "rb0") (setq pset "L"))
				((= rb "rb1") (setq pset "P"))
			)
		)

	(defun print_list(num0 / num)
		(setq num (atoi num0))
		(setq prt_name (nth num PRINTList))
		(vla-put-ConfigName actLay prt_name)
		(setq paperlist (loadpaper actlay))
		(start_list "paperlist")
		(mapcar 'add_list PAPERList)
		(end_list)
		(setq paper_name (nth 0 PAPERList))
		(vla-put-CanonicalMediaName actLay paper_name)
	)

	(defun paper_list(num1 / num)
		(setq num (atoi num1))
		(setq paper_name (nth num PAPERList))
		(vla-put-CanonicalMediaName actLay paper_name)
	)

	(defun plot_list(num2 / num)
		(setq num (atoi num2))
		(setq ctb_name (nth num CTBList))
		(vla-put-StyleSheet actLay ctb_name)
	)

	(defun file_plus(/ file_name)
		(vl-load-com)
		(setq file_path (getvar "dwgprefix"))
		(setq file_name (getfiled "file_open" file_path "dwg" 8))
		(if ( = file_name nil)
			(alert "파일선택을 취소하였습니다.")
			(progn
			(setq file_path_name (strcat file_path file_name))
			(setq file_path_name (list file_path_name))
			(setq file_list (append file_list file_path_name))
			(setq file_name (list file_name))
			(setq file_name_list (append file_name_list file_name))
			(start_list "dwg_list")
			(mapcar 'add_list file_name_list)
			(end_list)
			)
		)
	)

	(defun file_minus(/ fnum fn templist templist1)
		(if (= dwglist nil)
			(progn
			(if (= file_name_list nil)
				(alert"삭제할 파일이 없습니다.")
				(alert "삭제할 파일을 선택하세요.")
			))
			(progn
			(setq dwglist (atoi dwglist))
			(setq fnum (length file_name_list))
			(setq fn 0)
			(setq templist nil)
			(while (< fn fnum)
				(if (/= dwglist fn)
					(progn
					(if (= templist nil)
						(setq templist (list (nth fn file_name_list)))
						(setq templist (append templist (list(nth fn file_name_list))))
					)
					)
				)
				(setq fn (+ fn 1))
			)
			;(princ templist)
			
			(setq file_name_list templist)
			(start_list "dwg_list")
			(mapcar 'add_list file_name_list)
			(end_list)
		 	)
		)
	)

	(defun file_up_list(/ fnum fn templist temp1 temp)
		(if (= dwglist nil)
		(princ)
		(progn
			(setq dwglist (atoi dwglist))
			(if (= dwglist 0)
				(princ)
				(progn
				(setq temp1 (list (nth dwglist file_name_list))) ;temp1=b;
				(setq dwglist (- dwglist 1))
				(setq fnum (length file_name_list))
				(setq temp (list (nth dwglist file_name_list))) ;temp=a;
				(setq fn 0)
				(setq templist nil)
				(while (< fn fnum)
					(if (= fn dwglist)
						(progn
						(setq fn (+ fn 1))
						(if (= templist nil)
							(setq templist temp1)				;a=b
							(setq templist (append templist temp1))		;a=b
						)
						(setq templist (append templist temp))			;b=a
						)
						(progn
						(if (= templist nil)
							(setq templist (list (nth fn file_name_list)))
							(setq templist (append templist (list(nth fn file_name_list))))
						)
						)
					)
					(setq fn (+ fn 1))
				)
				;(princ templist)
				(setq file_name_list templist)
				(start_list "dwg_list")
				(mapcar 'add_list file_name_list)
				(end_list)))
			(setq dwglist nil))
		)
	)

    (defun file_down_list(/ fnum fn templist temp1 temp)

      (if (= dwglist nil)
	(alert "test")
	(progn
	  (setq dwglist (atoi dwglist))
	  (setq fnum (length file_name_list))
	  (if (= dwglist (- fnum 1))
	    (alert "test1")
	    (progn
	      (setq temp1 (list (nth dwglist file_name_list))) ;temp1=b;
	      (setq dwglist (+ dwglist 1))
	      (setq temp (list (nth dwglist file_name_list))) ;temp=a;
	      (setq fn 0)
	      (setq templist nil)

	      (while (< fn fnum)
		(if (= fn (- dwglist 1))
		  (progn
		    (setq fn (+ fn 1))
		    (if (= templist nil)
		      (setq templist temp)				;a=b
		      (setq templist (append templist temp))		;a=b
		      )
		    (setq templist (append templist temp1))			;b=a
		    
			)
		  (progn
		    (if (= templist nil)
		      (setq templist (list (nth fn file_name_list)))
		      (setq templist (append templist (list(nth fn file_name_list))))
		      )
		    )
		  )
		(setq fn (+ fn 1))
		)
	      ;(princ templist)
	      (setq file_name_list templist)
	      (start_list "dwg_list")
	      (mapcar 'add_list file_name_list)
	      (end_list)))
	  (setq dwglist nil)
	  ))
      )

    (defun path_enable(aa)
      (if (= aa "1")(progn
	(mode_tile "spath" 0)
	(set_tile "save" prt_file_path))
	(progn
	  (mode_tile "spath" 1)
	  (set_tile "save" "")
	  (setq prt_file_path "")
	)
      )
    )

    (defun BrowseforFolder (msg flag folder / oShell oFolder cFolder )
      (vl-load-com)
      (setq oShell (vla-getinterfaceobject (vlax-get-acad-object) "Shell.Application"))
      (if (setq oFolder (vlax-invoke-method oShell 'browseforfolder 0 msg flag folder))
	(setq cFolder (vlax-get (vlax-get oFolder "self") "path"))
	(setq cFolder prt_file_path)	
	)
      (vlax-release-object oShell)
      (set_tile "save" cFolder)
      )

    (repeat (length printlist)
      (if (= prt_name (nth i printlist))
	(set_tile "printlist" (itoa i))

	)
      (setq i (+ i 1))
      )
    (setq i 0)
    (repeat (length paperlist)
      (if (= paper_name (nth i paperlist))
	(set_tile "paperlist" (itoa i))
	)
      (setq i (+ i 1))
      )
    (setq i 0)
    (repeat (length ctblist)
      (if (= ctb_name (nth i ctblist))
	(set_tile "plotlist" (itoa i))
	)
      (setq i (+ i 1))
      )
    (set_tile "prb_key" prb)
    (set_tile "rb_key" rb)
    
    ;(path_enable(aa))
	
    (action_tile "printlist" "(print_list (setq num0 $value))")
    (action_tile "paperlist" "(paper_list (setq num1 $value))")
    (action_tile "plotlist" "(plot_list (setq num2 $value))")
    (action_tile "rb_key" "(plot_row(setq rb $value))")
    (action_tile "prb_key" "(setq prb $value)")
    (action_tile "sidline" "(setq ok 2 bb 1)(done_dialog)")
    (action_tile "fplus" "(file_plus)")
    (action_tile "dwg_list" "(setq dwglist $value)")
    (action_tile "fminus" "(file_minus)")
    (action_tile "arrayup" "(file_up_list)")
    (action_tile "arraydown" "(file_down_list)")
    (action_tile "accept" "(setq ok 1)(done_dialog)")
    (action_tile "cancel" "(setq ok 0)")
    (action_tile "esave" "(path_enable(setq aa $value))")
    (action_tile "spath" "(setq prt_file_path(BrowseforFolder \"저장경로 선택\" (+ 256 512) oldfolder)))")
    (start_dialog)
    (if (= ok 2)
      (if (= bb 1)
	(progn
	  ;(setq os (getvar "osmode"))
	  (setq qdwgs (car (entsel "\n 도곽을 선택하세요")))
	  (setq e_name (cdr (nth 9 (entget qdwgs))))

	  ));if종료
      );if 종료
    (setq ptlist '())
;----------------------------------------------------------------------------
    ;(princ)
    (if (= ok 1)
      (progn	
      	(if (= e_name nil)
       		(alert "출력에 실패하였습니다.\n도곽을 잡아주세요.")
      		(progn
      			(if(= file_name_list nil)
      				(alert "출력할 파일이 없습니다.")
      				(progn
      				(setq scrfile "D:/aaa.scr")
      				(setq stream (open scrfile "w"))
      				(foreach ptfile_name file_name_list
      					(setq ptfile_path (vl-filename-directory ptfile_name))
					(setq ptfile_name (vl-string-left-trim ptfile_path ptfile_name))
      					(if (= ptfile_path "")
    						(setq ptfile_path (getvar "dwgprefix"))
      					)
					(setq prt_file_name (strcat ptfile_path ptfile_name))
      					(setq prt_file_name (strcat "\"" prt_file_name "\""))
					(if (= prt_file_path "")
						(setq prt_file_path (getvar "dwgprefix"))
					)
					(if (= ptfile_name (getvar "dwgname"))
					(progn
					(write-line
      						(strcat "mpl_print " e_name " " prt_name "\n" paper_name "\n" ctb_name "\n" pset " " prt_file_path "\n" prb)
					stream))
					(progn
      					(write-line
      						(strcat "open " prt_file_name "\nmpl_print " e_name " " prt_name "\n" paper_name "\n" ctb_name "\n" pset " " prt_file_path "\n" prb " close n")
						;(strcat "open " ptfile_name ""(c:mpl_print \"" e_name "\" \"" prt_name "\" \"" paper_name "\" \"" ctb_name "\" \"" pset "\" \"" prt_file_path "\" \"" prb "\") close n")
      					stream)))
      				)
      				(close stream)				;스크립트 작성 종료
      				(command "script" scrfile)		;스크립트 실행
      				(vl-file-delete scrfile)		;스크립트파일 삭제
      			))
      		)
      	)
      	  (princ)
    ))
    );while 종료
  (unload_dialog dcl_box)
  ; dcl 처리 끝..
  (princ)
  )