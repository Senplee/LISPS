(defun wbm_main (sht_size wbm_no / bname temp ent os bp scale tp sp ep spdist epdist ss index
                                   tsp tep ss2 savepath savename fname svnum)
  (command "undo" "g")
  (command "-layer" "u" "*" "" )
  (setq bname nil)
  (setq temp t)
  (while temp
    (setq temp (entsel "\n 도각을 선택하세요 : "))
    (setq ent (entget (car temp)))
    (if (= (cdr (assoc 0 ent)) "INSERT")
      (progn
        (setq bname (cdr (assoc 2 ent)))
        (setq temp nil)
      )
      (princ "\n 도각블럭을 선택해주세요!")
    )
  )
  (if bname
    (progn
      (setq os (getvar "osmode"))
      (setvar "osmode" 0)
      (setq bp (cdr (assoc 10 ent)))
      (setq scale (cdr (assoc 41 ent)))
      (setq blkl (tblsearch "BLOCK" bname))
      (pds_GetBoundingBox blkl 'maxpt 'minpt)
      (setq boxpt2 (list (car maxpt)(cadr minpt)) boxpt4 (list (car minpt)(cadr maxpt)))
      (setq boxpt1 minpt boxpt3 maxpt)
      (setq di-h (distance minpt boxpt2) di-v (distance minpt boxpt4))
      (setq sht_size (list di-h di-v))
      (setq tp (mapcar '+ bp (mapcar '* sht_size (list scale scale))))

      (command "zoom" bp tp)
      (setvar "osmode" 33)
      (setq sp (getpoint "\n 저장될 파일명으로 사용될 텍스트가 있는 구역을 선택하세요 : "))
      (if sp
        (progn
          (setq ep (getcorner sp "\n 다음점 : "))
          (if (= wbm_no 2)
            (progn
              (setq sp_2 (getpoint "\n 두번째 텍스트가 있는 구역을 선택하세요 : "))
              (if sp_2
                (setq ep_2 (getcorner sp_2 "\n 다음점 : "))
              )
            )
          )
          (if ep
            (progn
              (setvar "osmode" 0)
              (setq spdist (mapcar '/ (mapcar '- sp bp) (list scale scale)))
              (setq epdist (mapcar '/ (mapcar '- ep bp) (list scale scale)))

              (if ep_2
                (progn
                  (setq spdist_2 (mapcar '/ (mapcar '- sp_2 bp) (list scale scale)))
                  (setq epdist_2 (mapcar '/ (mapcar '- ep_2 bp) (list scale scale)))
                )
              )

              (setq ss (ssget "x" (list (cons 0 "insert") (cons 2 bname))))
              (setq index 0)
              (repeat (sslength ss)
                (setq ent (entget (ssname ss index)))
                (setq bp (cdr (assoc 10 ent)))
                (setq scale (cdr (assoc 41 ent)))
                (setq tp (mapcar '+ bp (mapcar '* sht_size (list scale scale))))
                (command "zoom" bp tp)
                (setq tsp (mapcar '+ bp (mapcar '* spdist (list scale scale))))
                (setq tep (mapcar '+ bp (mapcar '* epdist (list scale scale))))
                (setq ss2 (ssget "c" tsp tep (list (cons 0 "text")))) ; file name select

                (if ep_2
                  (progn
                    (setq tsp_2 (mapcar '+ bp (mapcar '* spdist_2 (list scale scale))))
                    (setq tep_2 (mapcar '+ bp (mapcar '* epdist_2 (list scale scale))))
                    (setq ss2_2 (ssget "c" tsp_2 tep_2 (list (cons 0 "text")))) ; file name select
                  )
                )

                (if ss2
                  (progn
                    (setq savepath (getvar "DWGPREFIX"))

                    ; name support
                    (setq ss2 (pds_sortx->list ss2 '> '<)) ; 가로좌->우, 세로상->하 정렬
                    (setq fname "" i_name 0)
                    (repeat (sslength ss2)
                      (setq fname (strcat fname (cdr (assoc 1 (entget (ssname ss2 i_name))))))
                      (setq i_name (1+ i_name))
                    )
                    (if ss2_2
                      (progn
                        (setq ss2_2 (pds_sortx->list ss2_2 '> '<)) ; 가로좌->우, 세로상->하 정렬
                        (setq i_name 0)
                        (repeat (sslength ss2_2)
                          (setq fname (strcat fname "(" (cdr (assoc 1 (entget (ssname ss2_2 i_name)))) ")" ))
                          (setq i_name (1+ i_name))
                        )
                      )
                    )
                    ; name support end

                    (setq fname (change-wildcard fname "\"" "_"))
                    (setq fname (change-wildcard fname "/" "-"))
                    (setq savename (strcat savepath fname))
                    (setq svnum 0)
                    (while (findfile (strcat savename ".dwg"))
                      (setq savename (strcat savepath fname "_" (rtos (setq svnum (1+ svnum)) 2 0)))
                      (prompt "\n Drawing-File Name was Exist - Check!!! ")
                    )
                    (command "wblock" savename "" bp "w" bp tp "")
                  )
                  (prompt "\n Drawing-File Name is Nothing - Check!!! ")
                ) ; end of file name

                (setq index (1+ index)) ; index return
              )
            )
          )
        )
      )
      (setvar "osmode" os)
    )
  )
  (command "undo" "e")
  (princ)
)

(defun dxf (id lst)(cdr (assoc id lst)))

(defun c:wbm()
  (prompt "\n\t A1도곽으로 만들어진 도면들을 개별도면으로 내보냅니다. :")
  (prompt "\n\t 도면명 기준은 번호용 구역을 한번만 지정합니다. :")
  (setq sht_size (list 841 594))
  (wbm_main sht_size 1)
)

(defun c:wbm3()
  (prompt "\n\t A3도곽으로 만들어진 도면들을 개별도면으로 내보냅니다. :")
  (prompt "\n\t 도면명 기준은 번호용 구역을 한번만 지정합니다. :")
  (setq sht_size (list 420 290))
  (wbm_main sht_size 1)
)

(defun c:wbma()
  (prompt "\n\t A1도곽으로 만들어진 도면들을 개별도면으로 내보냅니다. :")
  (prompt "\n\t 도면명 기준은 번호용 구역을 두번 지정합니다. :")
  (setq sht_size (list 841 594))
  (wbm_main sht_size 2)
)

(defun c:wbm3a()
  (prompt "\n\t A3도곽으로 만들어진 도면들을 개별도면으로 내보냅니다. :")
  (prompt "\n\t 도면명 기준은 번호용 구역을 두번 지정합니다. :")
  (setq sht_size (list 420 290))
  (wbm_main sht_size 2)
)

(defun change-wildcard (str key key2 / po str2 po2 str3) ; " -> _(Under-Bar), / -> -
  (while (setq po (vl-string-position (ascii key) str))
    (setq str (strcat (substr str 1 po) key2 (substr str (+ po 2))))
  )
  str
)

; sample...
; (setq ents (pds_sortx->list ents '> '<)) ; 가로좌->우,세로상->하 방향 우선정렬

; 가로축 우선정렬
(defun pds_sortx->list (a k1 k2 / b c e1 e2 ix2 xxx)
  ; a=셀렉션션세트, k1은 첫번째 비교자, k2는 두번째 비교자.
  (setq c nil)
  (setq ix2 0)
  (repeat (sslength a)
    (setq c (cons (entget (ssname a ix2)) c))
    (setq ix2 (1+ ix2))
  )
  (setq c
    (vl-sort c
      (function
  (lambda (e1 e2)
    (if (not (equal (cadr (cdr (assoc 10 e1))) (cadr (cdr (assoc 10 e2))) (* (getvar "ltscale") 0.5))) ; 정밀도
            ((eval k1)  ; 비교 < or >
       (cadr (cdr (assoc 10 e1))) ; cadr은 y축
       (cadr (cdr (assoc 10 e2))) ; car은 x축
      )
            ((eval k2)  ; 비교 < or >
       (car (cdr (assoc 10 e1))) ; cadr은 y축
       (car (cdr (assoc 10 e2))) ; car은 x축
      )
    )
  )
      )
    )
  )
  (setq xxx (ssadd))
  (setq xxx (foreach x c (ssadd (cdr (assoc -1 x)) xxx)))
      ; xxx는 리스트 c의 요소이름으로 셀렉션셑트를 리턴함.
  xxx
;  c ; 리턴은 리스트형태임. ( (entlist1)(entlist2)(entlist3)..... )
)


(defun pds_GetShtEnt (ent1 / entl etype bname maxpt minpt angs ange dists diste ps pe ents ent id10 id11 id41 id50 i blkl)
  (if (= dxf nil)(defun dxf (id lst) (cdr (assoc id lst))))
  (setq entl (entget ent1) etype (dxf 0 entl))
  (cond
    ((= etype "INSERT")
      (progn
	      (setq blkl (tblsearch "BLOCK" (setq bname (dxf 2 entl))))
	      (pds_GetBoundingBox blkl 'maxpt 'minpt)
	      (setq pt0 (list 0 0 0))
	      (setq angs (angle pt0 minpt) dists (distance pt0 minpt))
	      (setq ange (angle pt0 maxpt) diste (distance pt0 maxpt))
	      (setq ents (ssget "X" (list (cons 0 "INSERT")(cons 2 bname))))
	      (setq i 0)
	      (repeat (sslength ents)
	        (setq entl (entget (setq ent (ssname ents i))))
	        (setq id10 (dxf 10 entl))
	        (setq id41 (dxf 41 entl))
		(setq id50 (dxf 50 entl))
	        (setq ps (polar id10 (+ angs id50) (* id41 dists)))
	        (setq pe (polar id10 (+ ange id50) (* id41 diste)))
	        (command "line" ps pe "")
  	      (setq i (1+ i))
	      )
      )
    )
  )
)

(defun pds_GetBoundingBox (blkl pt1 pt2 / ent0 ptlst b-ent ps pe ptl pt max-x max-y min-x min-y maxp minp) ; sub
  (setq ptlst nil)
  (setq b_ent (cdr (assoc -2 blkl)))
  (while b_ent
    (setq ent0 (dxf 0 (setq entl (entget b_ent))))
    (cond
      ((= ent0 "LINE")      (setq ps (dxf 10 entl) pe (dxf 11 entl) ptlst (append ptlst (list ps pe))))
      ((= ent0 "LWPOLYLINE")(setq ptl (GetpolyVtx entl) ptlst (append ptlst ptl)))
      ((= ent0 "POINT")     (setq pt (dxf 10 entl) ptlst (append ptlst (list pt))))
      (T nil)
    )
    (setq b_ent (entnext b_ent))
  )
  (setq max-x (apply 'max (mapcar '(lambda (x) (car x)) ptlst))) ; x좌표중큰값
  (setq max-y (apply 'max (mapcar '(lambda (x) (cadr x)) ptlst))) ; y좌표중큰값
  (setq min-x (apply 'min (mapcar '(lambda (x) (car x)) ptlst))) ; x좌표중작은값
  (setq min-y (apply 'min (mapcar '(lambda (x) (cadr x)) ptlst))) ; x좌표중작은값

  (setq maxp (list max-x max-y) minp (list min-x min-y))
  (set (eval 'pt1) maxp)
  (set (eval 'pt2) minp)
)

(defun GetPolyVtx(EntList / VtxList AA X) ; 폴리라인정점 추출
  ;폴리라인의 정점을 저장할 변수다.
  (setq VtxList '())
  ;폴리라인이 2D 폴리라인인지 3D 폴리라인인지를 판단한다.
  ;2D 폴리라인과 3D 폴리라인은 형식이 틀리기 때문이다.
  (IF (= "LWPOLYLINE" (CDR (ASSOC 0 EntList)))
   ; 2D 폴리라인일때의 정점을 추출한다.
   ; 2D 폴리라인은 10 번 코드가 정점정보이므로 10번만 추출하면 된다.
   (mapcar '(lambda (x) (if (= 10 (car x)) (setq VtxList (append VtxList (list (cdr x))) ) ) ) EntList)
   ; 3D 폴리라인일때의 정점을 추출한다.
   ; 3D 폴리라인은 entnext 함수를 이용하여 정점을 정보를 알아내고
   ; 마지막 정점표기 "seqend" 가 나오면 정점추출을 끝낸다.
   (PROGN
    (SETQ AA (ENTGET(ENTNEXT (CDR (ASSOC -1 EntList)))))
    (WHILE (/= "SEQEND" (CDR (ASSOC 0 AA)))
      (setq VtxList (append VtxList (list (cdr (ASSOC 10 AA)))))
      (SETQ AA (ENTGET(ENTNEXT (CDR (ASSOC -1 AA)))))
    )
  ))
  VtxList
)

(defun c:asd( / a)
  (setq a (car (entsel"\n\t Select Sheet-Box ?:")))
  (pds_GetShtEnt a)
)
