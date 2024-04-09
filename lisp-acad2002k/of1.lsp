(DEFUN C:OF (/ aa p3)
	(command "undo" "group")
	(prompt "\n\t Cable Tray's Border Box Drawing :[")
	(prin1 of_key)
	(prompt "]")
	(if (= of_key nil)
		(set_of_key)
	)
	(prompt "\n Select of the Tray Box : (Enter is Width) ")
	(if (= nil (SETQ AA (sel_poly)))
		(set_of_key)
		(progn
			(old-non)
			(setq nl (sslength aa))
			(setq i 0)
			(setq n (- nl 1))
			(while (>= n i)
				(setq sel_pbox (ssname aa i))
				(get_pbox_cen sel_pbox)
				(command "offset" of_key sel_pbox p3 "")
				(command "chprop" "last" "" "color" 7 "")
				(setq i (1+ i))
			)
			(new-sn)
		)
	)
	(command "undo" "end")
)

(defun set_of_key (/ a)
	(prompt "\n Enter Border Space = <")
	(prin1 of_key)
	(setq a (getdist "> ? :"))
	(if a (setq of_key a))
)

(defun get_pbox_cen(a); / p1 p2 b c)
	(setq b (getpolyvtx (entget a)))
	(if (= 0 (rem (length b) 2))
		(setq c (1+ (fix (/ (length b) 2))))
		(setq c (fix (/ (length b) 2)))
	)
	(setq p1 (nth 1 b) p2 (nth c b))
	(setq p3 (polar p1 (angle p1 p2) (/ (distance p1 p2) 2)))
)

; 폴리라인의 정점을 추출한다. 
;이 함수의 특징은 2D 폴리라인이든 3D 폴라라인이든 모든 정점을 추출한다. 
;--------------------------------------------------------------------------------
;
;(GetPolyVtx Polyline_Entity_List) => (정점리스트)
;
;(GetPolyVtx (entget (car (entsel))))
;
;=> ((29703.0 30752.0) (30362.0 15178.0) (40686.0 17810.0)
;     (43652.0 31410.0) (48814.0 26694.0))
;
;코드 
;--------------------------------------------------------------------------------

(defun GetPolyVtx(EntList / VtxList AA X)
  (setq VtxList '())
  (IF (= "LWPOLYLINE" (CDR (ASSOC 0 EntList))) 
   (mapcar '(lambda (x) (if (= 10 (car x)) (setq VtxList (append VtxList (list (cdr x))) ) ) ) EntList)
   (PROGN
    (SETQ AA (ENTGET(ENTNEXT (CDR (ASSOC -1 EntList)))))
    (WHILE (/= "SEQEND" (CDR (ASSOC 0 AA)))
      (setq VtxList (append VtxList (list (cdr (ASSOC 10 AA)))))
      (SETQ AA (ENTGET(ENTNEXT (CDR (ASSOC -1 AA)))))
    )
  ))
  VtxList
)
;
;설명 
;--------------------------------------------------------------------------------
;
;
;(defun GetPolyVtx(EntList / VtxList AA X)
;  ;폴리라인의 정점을 저장할 변수다.
;  (setq VtxList '())
;  ;폴리라인이 2D 폴리라인인지 3D 폴리라인인지를 판단한다.
;  ;2D 폴리라인과 3D 폴리라인은 형식이 틀리기 때문이다.
;  (IF (= "LWPOLYLINE" (CDR (ASSOC 0 EntList))) 
;   ; 2D 폴리라인일때의 정점을 추출한다.
;   ; 2D 폴리라인은 10 번 코드가 정점정보이므로 10번만 추출하면 된다.
;   (mapcar '(lambda (x) (if (= 10 (car x)) (setq VtxList (append VtxList (list (cdr x))) ) ) ) EntList)
;   ; 3D 폴리라인일때의 정점을 추출한다.
;   ; 3D 폴리라인은 entnext 함수를 이용하여 정점을 정보를 알아내고
;   ; 마지막 정점표기 "seqend" 가 나오면 정점추출을 끝낸다.
;   (PROGN
;    (SETQ AA (ENTGET(ENTNEXT (CDR (ASSOC -1 EntList)))))
;    (WHILE (/= "SEQEND" (CDR (ASSOC 0 AA)))
;      (setq VtxList (append VtxList (list (cdr (ASSOC 10 AA)))))
;      (SETQ AA (ENTGET(ENTNEXT (CDR (ASSOC -1 AA)))))
;    )
;  ))
;  VtxList
;)

