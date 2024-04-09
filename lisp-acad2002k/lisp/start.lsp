; 수정날짜: 2001.8.13
; 작업자: 박율구
; 명령어: CIMSTART

(setq lfn15 1)
;====================================================================
;               초기화 설정                                          
;====================================================================
(defun m:STRT (/ bm gm fixw sc c_sc ds dim pt st ts se so ss dcl_id)

;;;  (setq bm (getvar "blipmode"))
;;;  (setq gm (getvar "gridmode"))
    (ai_err_on)
    (ai_undo_on)
    (command "_.undo" "_group")
    (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
    (princ "\n초기 환경설정 명령입니다.")
    (initget (+ 1 2 4))
    (setq c_sc (getvar "dimscale"))
    (princ "\n현재 축척은 : " )
    (princ c_sc)
    (princ "입니다.")
    (setq sc (getint "\n도면 축척을 입력하시요. : 1 / "))
  
    (while (= ds nil)
     (setq ds (strcase (getstring
      "Drawing Sheet <A0/A1/A2/A3/A4/Detail...etc.>: ")))
     (setq fixw (strcat ds ".DWG"))
     (if (= (findfile fixw) nil)
       (progn
         (princ fixw)
         (princ " file not found. ") (terpri)
         (princ "\nAnother ")
         (setq ds nil)
       )
     )
    )

     (setq pt (list 0 0))
     (setvar "cmdecho" 0)
     (setvar "blipmode" 0)
     (setvar "GRIDmode" 0)
  (if (setq ss (ssget "X" (list (cons 8 "FILE"))))
    (command "_erase" ss "")
  )
  
     (setq st (* sc 3))
     (setq se (* sc 4))
     (setq so (* sc 2))
     (setvar "cmdecho" 0)
     (setvar "LTSCALE" sc)
     (setvar "DIMSCALE" sc)    ;; 치수기입 축척(치수유형ndim,sdim 사용시 1)
     (setvar "snapunit" (list sc sc))
     (setvar "gridunit" (list se se))
        (SETLAY ds)
        (command "_.Insert" ds pt sc "" 0)
        (RTNLAY)
     (setvar "cmdecho" 0)

         (setvar "regenmode" 1)
     (command "_Zoom" "_E")
     (command "_.Zoom" "_E")
     (command "_.viewres" "_Y" "500")
     (command "_.Limits" (GETVAR "EXTMIN") (GETVAR "EXTMAX"))
     (if (= ci_f_inf "ON")
       (progn
         (file_init)
         (cim_file)
       )
     )
    
;; 밑의 치수 환경설정은 core.lsp의 ai_dim함수가 대신함 
    (ai_dim)
    (setvar "dimscale" sc)
  
;; ================================================================================
;; 치수환경 설정 시작 
;; ================================================================================
;;        (setvar "DRAGMODE" 2)
;;        
;;        (setvar "DIMALT"  0)
;;        (setvar "DIMALTD" 1)
;;        (setvar "DIMASSOC"  1)       ;; 연관치수                  (기본값 : 켜기)
;;        (setvar "DIMASZ"  1)       ;; 화살촉의 크기             (기본값 : 1)
;;
;;        (setvar "DIMCEN"  5)       ;; center 표시크기           (기본값 : 5)
;;        (setvar "DIMCLRD" 2)      ;; 치수선 색상                (기본값 : YELLOW)
;;        (setvar "DIMCLRE" 2)      ;; 치수보조선 색상            (기본값 : YELLOW)
;;        (setvar "DIMCLRT" 6)      ;; 치수문자 색상              (기본값 : MAGENTA)
;;        
;;          (setvar "DIMDEC" 0)       ;; 소숫점 자릿수              (기본값 : 0)
;;        (setvar "DIMDLE" 0)       ;; 치수선을 지나는 치수보조선의 길이
;;        (setvar "DIMDLI" 8)       ;; 치수선 간의 간격           (기본값 : 8)
;;
;;        (setvar "DIMEXE" 2)       ;; 치수선위로 연장선          (기본값 : 2)
;;        (setvar "DIMEXO" 5)      ;; 치수보조선 원점간격 띄우기  (기본값 : 임의)
;;        
;;          (setvar "DIMFIT" 3)       ;; 치수보조선의 간격이 좁을때의 정렬 방식(범위 : 0 - 5)
;;        
;;        (setvar "DIMGAP" 1)       ;; 치수선과 글자와의 간격     (기본값 : 1)
;;
;;        (setvar "DIMLIM" 0)       ;; DIMTOL과 함께 사용하여 공차를 표현(기본값 : 0)
;;        
;;        (setvar "DIMRND" 0.25)    ;; 반올림 
;;
;;            (setvar "DIMSAH" 0)       ;; 분리 화살표 블록           (기본값 : 끄기)
;;        
;;        (setvar "DIMSE1" 0)       ;; 첫번째 치수보조선 억제     (기본값 : 0)
;;        (setvar "DIMSE2" 0)       ;; 두번째 치수보조선 억제     (기본값 : 0)
;;      (setvar "DIMSOXD" 0)
;;        (setvar "DIMTAD" 1)       ;; 문자를 치수보조선위에 기입 (기본값 : 1)
;;        (setvar "DIMTDEC" 2)
;;        (setvar "DIMTIH" 0)       ;; 연장선 내부의 문자는 수평임(기본값 : 0)
;;        (setvar "DIMTIX" 1)       ;; 연장선 내부에 문자놓기     (기본값 : 1)
;;        (setvar "DIMTOFL" 1)      ;; 치수선 내부로 선 밀어 넣기 (기본값 : 켜기)
;;        (setvar "DIMTOL" 0)       ;; DIMLIM과 함께 사용하여 공차를 표현(기본값 : 0)
;;        (setvar "DIMTSZ" 0)       ;; 눈금크기
;;            (setvar "DIMUNIT" 8)      ;; 콤마 넣기                  (기본값 : 8 /콤마없애기 : 7)
;;      (setvar "DIMZIN" 0)
;;      (setvar "FILLETRAD" 0)
;;      (setvar "LUNITS" 2)
;;      (setvar "LUPREC" 2)
;;      (setvar "MIRRTEXT" 0)
;;      (setvar "PICKBOX" 3)
;;      (setvar "APERTURE" 6)
;;      (setvar "TEXTSIZE" st)
;;      (SETVAR "COORDS" 2)
;;        
;;        ( if         ( not ( stysearch "SIM"))
;;                ( styleset "SIM")
;;        )
;;      (setvar "DIMTXSTY" "SIM")
;;
;;      (if     ( not ( dimsearch "sdim"))
;;          (progn
;;                (setvar "DIMTXT" 2)       ;; 치수글자의 크기            (권장값 : 2)
;;                (command "_dim1" "_save" "sdim" )
;;            )  
;;        )            
;;      (if     ( not (stysearch  "ndim"))
;;            (progn
;;                (setvar "DIMTXT" 3)       ;; 치수글자의 크기            (권장값 : 3)
;;                (command "_dim1" "_save" "ndim" )
;;            )  
;;        )
  
;;      (setvar "cmdecho" 1)
;;        (princ "\n치수스타일 sdim,ndim이 올려짐")(terpri)
;;
;;  
;;     
;;   (command "_.insert" "dotk" (getvar "viewctr") "" "" "")
;;   (entdel (entlast))
;;   (command "_.dimblk" "dotk")
     
;;================================================================================
;;치수환경 설정 끝
;;================================================================================

  ; CIHS 문자유형검색해서 없으면 설정하고 현재 문자유형으로 전환
     (setvar "cmdecho" 0)
     (if (not (stysearch "CIHS"))
         (progn
            (styleset "CIHS")
            (COMMAND "_TEXTSTYLE" "CIHS")
         )
     )
  
  ; 기존의 dimscale과 cimstart명령을 통해 입력받은 축적값을 비교해 치수유형 저장
  (if (/= c_sc sc)
     (progn
       (setq dim (getvar "dimstyle"))
       (setvar "cmdecho" 1)
       (princ (strcat "현 치수유형" dim "에 DIMSCALE=" (itoa sc) " 추가 재지정 중..."))
       (setvar "cmdecho" 0)
       (command "_dim1" "_save" (getvar "dimstyle") "Y")
     )
  )  
           
   
     (setvar "cmdecho" 1)
     (setvar "blipmode" 1)
  
     (princ "\n현재 도면축적: 1 / ")     
     (princ sc)
     (princ "\n현재 도면크기: ")
     (princ ds)
     (princ "\n현재 치수유형: ")
     (princ (getvar "DIMSTYLE"))
     (princ "\n현재 문자유형: ")
     (princ (getvar "TEXTSTYLE"))
     (princ "\nSnap: ")
     (princ sc)
     (princ "  Grid: ")
     (princ se)
;;;  (setvar "blipmode" bm)
;;;  (setvar "gridmode" gm)
     (princ)
  
  ;;==============================================================================
  ;; 대화상자로 보여줌
     (setq dcl_id (ai_dcl "start"))
     (new_dialog "informbox" dcl_id)
     (set_tile "scale" (strcat "1 / " (itoa sc)))
     (set_tile "size" ds)
     (set_tile "dim" (getvar "DIMSTYLE"))
     (set_tile "style" (getvar "TEXTSTYLE"))
     (set_tile "snap" (itoa sc))
     (set_tile "grid" (itoa se))
     (start_dialog)
     (action_tile "accept" "(done_dialog)")
     ;(unload_dialog dcl_id) 대화상자를 두번째 실행시부터 띄워주지 음
     
  (ai_err_off)
  (ai_undo_off)
  (setvar "textstyle" "CIHS")
  (princ)
  ;;==============================================================================
)

(defun C:CIMSTART () (m:STRT))
(princ)
