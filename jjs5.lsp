(defun wbm_main (sht_size wbm_no / bname temp ent os bp scale tp sp ep spdist epdist ss index
                                   tsp tep ss2 savepath savename fname svnum)
  (command "undo" "g")
  (command "-layer" "u" "*" "" )
  (setq bname nil)
  (setq temp t)
  (while temp
    (setq temp (entsel "\n ������ �����ϼ��� : "))
    (setq ent (entget (car temp)))
    (if (= (cdr (assoc 0 ent)) "INSERT")
      (progn
        (setq bname (cdr (assoc 2 ent)))
        (setq temp nil)
      )
      (princ "\n �������� �������ּ���!")
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
      (setq sp (getpoint "\n ����� ���ϸ����� ���� �ؽ�Ʈ�� �ִ� ������ �����ϼ��� : "))
      (if sp
        (progn
          (setq ep (getcorner sp "\n ������ : "))
          (if (= wbm_no 2)
            (progn
              (setq sp_2 (getpoint "\n �ι�° �ؽ�Ʈ�� �ִ� ������ �����ϼ��� : "))
              (if sp_2
                (setq ep_2 (getcorner sp_2 "\n ������ : "))
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
                    (setq ss2 (pds_sortx->list ss2 '> '<)) ; ������->��, ���λ�->�� ����
                    (setq fname "" i_name 0)
                    (repeat (sslength ss2)
                      (setq fname (strcat fname (cdr (assoc 1 (entget (ssname ss2 i_name))))))
                      (setq i_name (1+ i_name))
                    )
                    (if ss2_2
                      (progn
                        (setq ss2_2 (pds_sortx->list ss2_2 '> '<)) ; ������->��, ���λ�->�� ����
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
  (prompt "\n\t A1�������� ������� ������� ������������ �������ϴ�. :")
  (prompt "\n\t ����� ������ ��ȣ�� ������ �ѹ��� �����մϴ�. :")
  (setq sht_size (list 841 594))
  (wbm_main sht_size 1)
)

(defun c:wbm3()
  (prompt "\n\t A3�������� ������� ������� ������������ �������ϴ�. :")
  (prompt "\n\t ����� ������ ��ȣ�� ������ �ѹ��� �����մϴ�. :")
  (setq sht_size (list 420 290))
  (wbm_main sht_size 1)
)

(defun c:wbma()
  (prompt "\n\t A1�������� ������� ������� ������������ �������ϴ�. :")
  (prompt "\n\t ����� ������ ��ȣ�� ������ �ι� �����մϴ�. :")
  (setq sht_size (list 841 594))
  (wbm_main sht_size 2)
)

(defun c:wbm3a()
  (prompt "\n\t A3�������� ������� ������� ������������ �������ϴ�. :")
  (prompt "\n\t ����� ������ ��ȣ�� ������ �ι� �����մϴ�. :")
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
; (setq ents (pds_sortx->list ents '> '<)) ; ������->��,���λ�->�� ���� �켱����

; ������ �켱����
(defun pds_sortx->list (a k1 k2 / b c e1 e2 ix2 xxx)
  ; a=�����ǼǼ�Ʈ, k1�� ù��° ����, k2�� �ι�° ����.
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
    (if (not (equal (cadr (cdr (assoc 10 e1))) (cadr (cdr (assoc 10 e2))) (* (getvar "ltscale") 0.5))) ; ���е�
            ((eval k1)  ; �� < or >
       (cadr (cdr (assoc 10 e1))) ; cadr�� y��
       (cadr (cdr (assoc 10 e2))) ; car�� x��
      )
            ((eval k2)  ; �� < or >
       (car (cdr (assoc 10 e1))) ; cadr�� y��
       (car (cdr (assoc 10 e2))) ; car�� x��
      )
    )
  )
      )
    )
  )
  (setq xxx (ssadd))
  (setq xxx (foreach x c (ssadd (cdr (assoc -1 x)) xxx)))
      ; xxx�� ����Ʈ c�� ����̸����� �����ǙVƮ�� ������.
  xxx
;  c ; ������ ����Ʈ������. ( (entlist1)(entlist2)(entlist3)..... )
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
  (setq max-x (apply 'max (mapcar '(lambda (x) (car x)) ptlst))) ; x��ǥ��ū��
  (setq max-y (apply 'max (mapcar '(lambda (x) (cadr x)) ptlst))) ; y��ǥ��ū��
  (setq min-x (apply 'min (mapcar '(lambda (x) (car x)) ptlst))) ; x��ǥ��������
  (setq min-y (apply 'min (mapcar '(lambda (x) (cadr x)) ptlst))) ; x��ǥ��������

  (setq maxp (list max-x max-y) minp (list min-x min-y))
  (set (eval 'pt1) maxp)
  (set (eval 'pt2) minp)
)

(defun GetPolyVtx(EntList / VtxList AA X) ; ������������ ����
  ;���������� ������ ������ ������.
  (setq VtxList '())
  ;���������� 2D ������������ 3D �������������� �Ǵ��Ѵ�.
  ;2D �������ΰ� 3D ���������� ������ Ʋ���� �����̴�.
  (IF (= "LWPOLYLINE" (CDR (ASSOC 0 EntList)))
   ; 2D ���������϶��� ������ �����Ѵ�.
   ; 2D ���������� 10 �� �ڵ尡 ���������̹Ƿ� 10���� �����ϸ� �ȴ�.
   (mapcar '(lambda (x) (if (= 10 (car x)) (setq VtxList (append VtxList (list (cdr x))) ) ) ) EntList)
   ; 3D ���������϶��� ������ �����Ѵ�.
   ; 3D ���������� entnext �Լ��� �̿��Ͽ� ������ ������ �˾Ƴ���
   ; ������ ����ǥ�� "seqend" �� ������ ���������� ������.
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
