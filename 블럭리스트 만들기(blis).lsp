; ��Ű��� ��� "�ູ���Ϸ�"
; http://cafe.daum.net/archimore
; �� ����Ʈ �����>> ����/���̸�/����
; 2007.10.02.

;- ���� ũ�⿡ ������� ����ũ��� ǥ�� (����ũ�⿡ �°� Ȯ�� ��ҵ�)
;- ������ ����
;- list�� ũ��� lts ���� �¿��...lts = �ؽ�Ʈ����
;- table�� �����߱� ������.. 2005 ���Ϲ��������� ��밡��

; 2013.11.21 
; ��ƾ���� , �ߺ���ü ����, ���ļ��� ����

(defun c:blis(/ lts vctr lt os Led LedList bed bn len maxlen LedList ss_insert BnameList ss_blockObjs
						SBnameList OBnameList WBnameList k op1 op2 op3 bbn ss1 in_ename nx key_last1 key_last2
						MinPt MaxPt hor_dis ver_dis dis)
	(vl-load-com)
	(prompt "\n>>�� ����Ʈ �����>> ����/���̸�/����,�ߺ� ��� ��ü����")
	(defun *error* (msg)(princ "error: ")(princ msg)(setvar "osmode" os)(princ))

	(setq lts (getvar "ltscale") vctr (getvar "viewctr") lt (getvar "ltscale") os (getvar "osmode"))
	
	;����Ʈ �ߺ�����
	(defun Harua_List_OverDel(lis)
		(if lis (cons (car lis)	(Harua_List_OverDel (vl-remove-if '(lambda (x)(equal (nth 2(car lis)) (nth 2 x) 0.001)) (cdr lis)))))
	)
	;����Ʈ�� �ߺ� ��ü ����
	(defun Haru_Delete_OverDel(lis)
		(if lis (cons (car lis)	
					(Haru_Delete_OverDel 
						(vl-remove-if '(lambda (x)(if (equal (nth 2(car lis)) (nth 2 x) 0.001)(vla-delete (nth 0 x)))) (cdr lis))
					)
				)
		)
	)
		
	;; ����Ʈ n ��° �����ͳ��� ����
	 (defun Sub_Samegroup (L num)
		(if L
				(cons
						(vl-remove-if-not '(lambda (a)(= (nth num  (car L)) (nth num a)))L)
						(Sub_Samegroup (vl-remove-if '(lambda (a) (= (nth num (car L)) (nth num a))) L) num)
				)
		)
	)
		
	(defun Sub_ssToObjList ( ss / k ObjList)
		(repeat (setq k (sslength ss))
			(setq ObjList (cons (vlax-ename->vla-object (ssname ss (setq k (1- k)))) ObjList))
		)
		ObjList
	)	
	
	;�Ӽ���
	(defun ins_att(ename / a)
		(setq a ename)
		(setq key_att 0)
		(while (setq a (entnext a))
			(if (= "ATTDEF" (cdr (assoc 0 (entget a))))
				(setq key_att (1+ key_att))
			)
		)
		key_att
	)
	
	;; ���̾� lock ����Ʈ ��������
	(setq Led (tblnext "LAYER" T)) 
	(setq LedList  nil)
	(while Led 
		(if (equal (assoc 70 Led) '(70 . 4)) 
		(setq LedList (append LedList (list (cons 8 (cdr (assoc 2 Led)))))) 
		) 
		(setq Led (tblnext "LAYER")) 
	)
	
	
	;; ����̸��� ����� ���� ���ϱ�
	(setq bed (tblnext "block" t) maxlen 0)
	(while bed
		(setq bn (cdr (assoc 2 bed)))
		(if (/= (substr bn 1 1) "*")
			(progn
				(setq len (car (cadr (textbox (list (cons 1 bn) (cons 40 lt))))))
				(setq maxlen (max maxlen len))
			)
		)
		(setq bed (tblnext "block"))
	)
	
	;; ����ƾ
	(if (= LedList nil)
		(setq ss_insert (ssget (list (cons 0 "insert"))))
		(setq ss_insert (ssget (append (list (cons -4 "<AND")) (list (cons 0 "insert"))  (list (cons -4 "<NOT")) LedList (list (cons -4 "NOT>")) (list (cons -4 "AND>")))))
	)
	(setq BnameList '())
	(setq ss_blockObjs (Sub_ssToObjList ss_insert))
	(mapcar '(lambda (a)(setq BnameList (append BnameList (list (list a (vla-get-name a) (vlax-get a 'InsertionPoint)))))) ss_blockObjs) 
	(setq SBnameList (Sub_Samegroup BnameList 1))
	(setq OBnameList (mapcar '(lambda (a) (Harua_List_OverDel a)) SBnameList)) ; �ߺ���� ����Ʈ���� ����
	(mapcar '(lambda (a) (Haru_Delete_OverDel a)) SBnameList) ; �ߺ���ü����
	(setq WBnameList (mapcar '(lambda (a)(list (cadr (car a)) (length a)))OBnameList))	
	
	(setq WBnameList (vl-sort WBnameList '(lambda (a b) (< (car a) (car b)))))
	
	(setq k 0)
	(and
		(setq op1 (getpoint "\nBlock-List�� ������ġ�� Ŭ�� ���ּ���:"))
		(setq op2 (polar op1 0 (* lt 5)))
		(setq op3 (polar op2 0 (* maxlen 1.2)))
		(progn
			(setvar "osmode" 0)
			(repeat (length WBnameList)
				(setq bbn  (car (nth k WBnameList)) Nnum (cadr (nth k WBnameList)))
				(setq ss1 (ssadd))
				(setq in_ename (cdr (assoc -2 (tblsearch "BLOCK" bbn))))
				(setq nx (ins_att in_ename))

				(command "insert" bbn vctr 1 "" 0)
				(while (> nx 0)
					(command "")
					(setq nx (1- nx))
				)

				(ssadd (entlast) ss1)

				(setq key_last1 (entlast))
				(setq key_last2 (ssname (ssget "L") 0))

				(if (eq key_last1 key_last2)
					(progn
						(vla-GetBoundingBox (vlax-ename->vla-object (entlast))'MinPt 'MaxPt)
						(setq MinPt (vlax-safearray->list MinPt))
						(setq MaxPt (vlax-safearray->list MaxPt))
						(setq hor_dis (distance minpt (list (car maxpt) (cadr minpt))))
						(setq ver_dis (distance minpt (list (car minpt) (cadr maxpt))))
						(if (>= hor_dis ver_dis)
							(setq dis hor_dis)
							(setq dis ver_dis)
						)
						(if (or (> dis (* lt 3)) (< dis (* lt 3)))
							(command "scale" ss1 "" minpt "r" dis (* lt 3))
						)
						(command "move"
											ss1
											""
											minpt
											(polar op1 (+ (/ pi 2) pi) (* (/ ver_dis 2) (/ (* lt 3) dis)))
						)
					)
					(entdel (entlast))
				)
				(command "text"
									(polar op2 (+ (/ pi 2) pi) (/ lt 2))
									lt
									0
									bbn
				)
				(command "text"
									(polar op3 (+ (/ pi 2) pi) (/ lt 2))
									lt
									0
									Nnum
				)
				(setq op1 (polar op1 (+ (/ pi 2) pi) (* lt 4)))
				(setq op2 (polar op2 (+ (/ pi 2) pi) (* lt 4)))
				(setq op3 (polar op3 (+ (/ pi 2) pi) (* lt 4)))
				(setq k (1+ k))
			)
			(setvar "osmode" os)
		)
	)

	(princ)
)
;defun




	



