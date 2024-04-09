;;;┌─────────────────────────────┐
;;;│파 일 명 : blc.lsp                                        │
;;;├─────────────────────────────┤
;;;│홈페이지 : http://you92.oranc.co.kr                       │
;;;│작 성 자 : easylisp                                       │
;;;│배 포 일 : 2006. 09. 05.                                  │
;;;├─────────────────────────────┤
;;;│ 안깨지는 블럭을 깨지는 블럭으로 변경합니다.              │
;;;└─────────────────────────────┘
(defun c:blc (/ nam b en ss old0 os blss bname blp old70 old10 old8 old41 old50 ent tempindex index entlists insp tbp1 tbp2 base10 entlist addents)
(defun dtr (a) (* pi (/ a 180.0)))
(defun rtd (a) (/ (* a 180.0) pi))
(defun dxf (n ed) (cdr (assoc n ed)))

  (setq ss (entsel "\n 블럭선택 : "))
  (if ss
    (progn
      (command "undo" "g")
      (setq os (getvar "osmode"))
      (setvar "osmode" 0)
      (setq bnam (dxf 2 (entget (car ss))))
      (setq old10 (dxf 10 (entget (car ss))))
      (setq old8 (dxf 8 (entget (car ss))))
      (setq old50 (dxf 50 (entget (car ss))))
      (setq old70 (dxf 70 (entget (car ss))))
      (setq old41 (dxf 41 (entget (car ss))))
      (setq bname "sampless")
      (if (setq b (tblsearch "block" bnam))
	(if (setq en (dxf -2 b))
	  (progn
	    (setq blp (cdr (assoc 10 b)))
	    (setq ent (entget en))
	    (entmake
	      (append
		'((0 . "BLOCK"))
		(list (cons 2 bname))
		(list (cons 70 0))
		(list (cons 10 blp))
              )
	    )
	    (setq addents (addent ent))
	    (if addents
	      (progn
		(while (setq en (entnext en))
		  (setq ent (entget en))
		  (setq addents (addent ent))
		)
	      )
	    )
	    (setq bname (entmake '((0 . "ENDBLK"))))
	    (setq bname "sampless")
	    (setq ss (ssget "x" (list (cons 2 bnam))))
	    (if ss
	      (progn
		(setq index 0)
		(repeat (sslength ss)
		  (setq ssent (ssname ss index))
		  (setq ent (entget ssent))
		  (setq old8 (cdr (assoc 8 ent)))
		  (setq old10 (cdr (assoc 10 ent)))
		  (setq old41 (cdr (assoc 41 ent)))
		  (setq old42 (cdr (assoc 42 ent)))
		  (setq old43 (cdr (assoc 43 ent)))
		  (setq old50 (cdr (assoc 50 ent)))
		  (entdel ssent)
		  (entmake
		    (append
		      '((0 . "INSERT"))
		      (list (cons 2 bname))
		      (list (cons 10 old10))
		      (list (cons 41 old41))
		      (list (cons 42 old42))
		      (list (cons 43 old43))
		      (list (cons 50 old50))
		    )
		  )
		  (setq index (1+ index))
		)
		(command "purge" "b" bnam "n")
		(command "rename" "b" bname bnam)
              )
	    )
	  )
	)
      )
      (command "undo" "e")
    )
    (setvar "osmode" os)
  )
  (princ)
)

(defun addent (ent / index removenum entlist tempindex)
  (setq index 0)
  (setq removenum (list -1 330 5))
  (setq entlist nil)
  (repeat (length ent)
    (setq tempindex (car (nth index ent)))
    (if (not (member tempindex removenum))
      (progn
	(setq entlist (append entlist (list (nth index ent))))
      )
    )
    (setq index (1+ index))
  )
  (entmake
    (append
      (mapcar
	'(lambda (x)
	   x
	 )
	entlist
      )
    )
  )
  t
)


