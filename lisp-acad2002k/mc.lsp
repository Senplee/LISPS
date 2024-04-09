(defun C:MC (/ a i ddd olds)
  (prompt "\n Multiple Copy command :")
  (setq	olderr	*error*
	*error*	myerror
	chm	0
  )

  (snap-ro)
  (old-sn)

  (IF (= C_DIS NIL)
    (setq C_DIS 2000)
  )
  (prompt "\n Select the Multiple-Copy target <D=")
  (prin1 c_dis)
  (prompt "> ? : ")
  (setq a (ssget))
  (command "undo" "group")
  (if (= a nil)
    (progn
      (prompt "\n Enter coping DISTANCE <")
      (prin1 c_dis)
      (setq ddd (getdist "> ? : "))
      (if ddd
	(setq c_dis ddd)
      )
      (prompt "\n Select the COPYNG target ? : ")
      (setq a (ssget))
      (if a
	(copy_m a c_dis)
      )
    )
    (copy_m a c_dis)
  )
  (command "undo" "end")
  (new-sn)
)
