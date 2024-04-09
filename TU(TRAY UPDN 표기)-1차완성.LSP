;;=================================================================================================================================
;;
;; TRAY UP DOWN 표기   BY lejkk5000@hanmail.net    명령어 TU
;;
;;
(defun c:tu(/ p1 p2 p3 p4 p5 ox1 ox2 xmax xmin ymax ymin pa pb pc pd )
    
	(setvar "orthomode" 1)
        (setvar "osmode" 179)
	(setq p1 (getpoint "\first point:"))
	(setq p3 (getcorner p1 "\n second point:"))
	(grdraw p1 p3 1 1)
	(command "rectang" p1 p3 "")
	(setq ox1(getpoint "\n 한점지정:"))
	(setq ox2(getpoint ox1 "\n 방향은:"))
	(grdraw ox1 ox2 1  1)
		
	(setq
		  p1(list (car p1) (cadr p1))
		  p2(list (car p1) (cadr p3))
		  p3(list (car p3) (cadr p3))
		  p4(list (car p3) (cadr p1))
	 	 
	)
	
	(setq	xmax(max (car p1) (car p2) (car p3) (car p4))
			xmin(min (car p1) (car p2) (car p3) (car p4))
			ymax(max (cadr p1) (cadr p2) (cadr p3) (cadr p4))
			ymin(min (cadr p1) (cadr p2) (cadr p3) (cadr p4))
	)
	(setq	pa(list xmin ymin)
			pb(list xmax ymin)
			pc(list xmin ymax)
			pd(list xmax ymax)
	)
	
	(if (and (< (car ox1) (car ox2)) (= (cadr ox1) (cadr ox2)))
		(progn
			(setq p5(list (car pb) (/ (+ (cadr pd) (cadr pa)) 2 )))
			(command "pline" pc p5 pa "c")
		)
	)
	(if (and (> (car ox1) (car ox2)) (= (cadr ox1) (cadr ox2)))
		(progn
			(setq p5(list (car pa) (/ (+ (cadr pa) (cadr pc)) 2 )))
			(command "pline" pd p5 pb "c")
		)
	)
	(if (and (< (cadr ox1) (cadr ox2)) (= (car ox1) (car ox2)))
		(progn
			(setq p5(list (/ (+ (car pa) (car pb)) 2) (cadr pc)))
			(command "pline" pa p5 pb "c")
		)
	)
	(if (and (> (cadr ox1) (cadr ox2)) (= (car ox1) (car ox2)))
		(progn 
			(setq p5(list (/ (+ (car pa) (car pb)) 2) (cadr pa)))
			(command "pline" pc p5 pd "c")
		)
	)
	


	(princ) 
)
	