
;;=======================================================================================

;;    도면틀 (블럭으로된거)을 선택하여 A3로 자동프린트 
;;    도면스케일 관계없이 축척에 맟쳐 LTSCALE 자동변화됨
;;    프린터 설정은 (설계실)            
;;    2015년 고인석
;;    지정한 것만 A3용지로출력됨(A3사용이99.9% 이상) 
;;    다중선택 가능함

;========================================================================================

 (setq ikploter "HP LaserJet 5200 Series PCL 5");프린터이름 현재 사용중인거
 (setq ikctb "삼현이엔지(흑백).ctb") ;

 (defun c:p1( / ent pwgs ss1  ppw1 ppw2 vpw1 vpw2 pwwsel pdgscc1 pdgscc pdgscc4 ) 
 (defun *error* (msg)(princ "error: ")(princ msg)
 (setvar "osmode" 0)
 (princ))
 (vl-load-com)
 (setq ent nil)

 (prompt "\n 프린트 할 도면을 선택하세요(블록으로된 도면외곽) !!" ) 
 (setq pwgs (ssget (list (cons 0 "insert"))))

  (if pwgs
   (progn
    (setq ss1 pwgs)
    (setq n 0)
    (repeat (sslength ss1)
    (setq ent (ssname ss1 n))
 
  (vla-GetBoundingBox (vlax-ename->vla-object ent) 'MinPt 'MaxPt)

  (setq ppw1 (vlax-safearray->list MinPt)) 
  (setq ppw2 (vlax-safearray->list MaxPt))

  (setq vpw1 (list (car ppw2) (cadr ppw1)));우하점
  (setq vpw2 (list (car ppw1) (cadr ppw2))) ;좌상점

  (setq pwwsel (ssget "W" ppw1 ppw2 ));전체도면
  (setq pdgscc1 (distance ppw1 ppw2))
  (setq pdgscc (/ pdgscc1 487.656 )) ; 도면척도 대각길이로 나눈값 A3기준

  (setq pdgscc4 (* pdgscc 4 )) ;ltscale 스케일의4배
  (setvar "ltscale"  pdgscc4) ; 치수스케일 도면축척과 동일 

  (setvar "osmode" 191)
; (command "zoom" ppw1 ppw2) ; 사용안함 어지러움
   
      (command "-PLOT"  
               "Y" 
               ""                        
               ikploter               ;프린터이름
               "A3"                   ;용지 크기
               "M"  
               "L"                    ;페이지회전
               "N" 
               "W"
               ppw2 ppw1
               "f"
               "c"
               "Y"   
               ikctb
               "y"                    ;선가중치플롯
               "a"                    ;음영플롯설정 / 표시되는 대로(A)/와이어프레임(W)/숨김(H)/뷰 스타일(V)/렌더(R)
               "n"                    ;플롯출력을 파일로
               "n"                    ;페이지설정 저장
               "y"                    ;플롯진행
       )                     

       (setq n (1+ n))
    )
   )
  ) 
  (prompt "\n 행복한 하루 되세요! ") 

)



