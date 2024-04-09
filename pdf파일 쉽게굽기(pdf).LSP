(defun dtr (a) (* pi (/ a 180.0)))
(defun rtd (a) (/ (* a 180.0) pi))
;;=======================================================================================
;;    2015년 고인석
;;    지정한 것만 A3용지로출력됨(A3사용이99.9% 이상) 
;;    PDF파일로저장 저장경로는 원도면이 있는폴더에 << 도면번호.pdf>> 로 저장
;;    LT 스케일 자동변경됨 (척도 X 4배)
;;    다중선택 가능
;;    도면번호구간은 도면폼에 따라 위치추적변수를 수정후 사용하시요
;;=======================================================================================


  (setq f-ploter "DWG To PDF.pc3")  ; PDF용 프린터
;  (setq f-ploter "Adobe PDF") 

  (setq ikctb "sheng.ctb") ; 개인ctb 올흑백,선가중치=0.2, 변경할것 색상번호 1=0.13, 3=0.09, 4=0.15, 6=0.09, 8=0.13

 
  (defun c:pdf() 
   (defun *error* (msg)(princ "error: ")(princ msg)
   (setvar "osmode" 0)
   (princ))
   (vl-load-com)
   (setq ent nil)

   (prompt "\n PDF파일로 저장할 도면을 선택하세요(블록으로된 도면외곽) !! " ) 

   (setq qdwgs (ssget (list (cons 0 "insert"))))
   (if qdwgs
   (progn
    (setq ss1 qdwgs)
    (setq n 0)
    (repeat (sslength ss1)
    (setq ent (ssname ss1 n))



  (vla-GetBoundingBox (vlax-ename->vla-object ent) 'MinPt 'MaxPt)

  (setq qpw1 (vlax-safearray->list MinPt)) 
  (setq qpw2 (vlax-safearray->list MaxPt))

  (setq vpw1 (list (car qpw2) (cadr qpw1)));도곽 우하점
;  (setq vpw2 (list (car qpw1) (cadr qpw2)));도곽 좌상점 사용안함

  (command "zoom" qpw1 qpw2)
  (setq qwwsel (ssget "w" qpw1 qpw2 ))
  (setq qdgscc1 (distance qpw1 qpw2)) 
  (setq qdgscc (/ qdgscc1 487.656 )) ; 도면척도 대각길이로 나눈값 A3기준 (qdgscc1값을 변경하세요)

  (setq qdwlen (* qdgscc 22)) ; 도면명구역내 text 선택 거리
  (setq qdwlx  (* qdgscc 65)) ; 외곽 테두리에서부터 간격
  
  (setq qdis1nm  (polar vpw1 (dtr 160) qdwlx));도면명구역 우하점(위치추적)
  (setq qdis2nm (polar qdis1nm (dtr 172 ) qdwlen));도면명구역 좌상점(위치추적)

  (setq qdgscc4 (* qdgscc 4 )) ;ltscale 스케일의4배
  (setvar "dimscale"  qdgscc) ; 치수스케일 도면축척과 동일 
  (setvar "ltscale"  qdgscc4) ; 치수스케일 도면축척과 동일 

  (setq qwwsa1 (ssget "c" qdis1nm qdis2nm  (list (cons 0 "text"))))
  (setq qwwsa (vlax-ename->vla-object (ssname qwwsa1 0)))
  (setq qwwsan1 (vla-get-textstring qwwsa))
  (setq qwwfile1 (strcat qwwsan1 ".pdf" )) 
 
  
  (setq qwwfile (strcat (getvar "dwgprefix") qwwfile1"")) ;저장할 파일경로


(princ)     
 (command
   "-plot"
   "y"
   ""
   f-ploter                           ;프린터이름
   "ISO A3 (297.00 x 420.00 mm)"      ;용지 크기
   "M"
   "L"
   "n"
   "W"  
   qpw1 qpw2
   "f"
   "c"
   "y"
   ikctb
   "y"
   "w"
   qwwfile
   "y"
   "y"
  )

  (setq n (1+ n)) )))
  

  (prompt "\n 행복한 하루 되세요! ")
 
 
)

