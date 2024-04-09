
(defun c:cc3( / a la-name la-type sign_70 la-namec)
	(prompt "\n\nt Change Layer as Current Layer : by Lock")
	(setq a (ssget))
	(if a
		(progn
			(setq la-name (cdr (assoc 8 (entget (ssname a 0)))))
			(setq la-type (tblsearch "layer" name))
			(setq sign_70 (cdr (assoc 70 la-type)))
			(if (= sign_70 4)(command "-layer" "unlock" la-name ""))
			(setq la-namec (getvar "CLAYER"))
			(command "CHPROP" a "" "layer" la-namec "c" "bylayer" "")
			(if (= sign_70 4)(command "-layer" "lock" la-name ""))
		)
	)
)
