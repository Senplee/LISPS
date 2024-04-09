;;;CADALYST 10/06   Tip2159: BigPurge.lsp   Big Purge   (c) Mark Newman 

;; Created by Mark Newman January 2001
;;
;;; Revised : May 2006... For AutoCAD 2006...
;;
;;  ----
(DEFUN C:BP (/ CE RM)
  ;;  ----
  (DEFUN *ERROR* (MSG)
    (IF
      (OR
	(/= MSG "Function cancelled")
	(= MSG "quit / exit abort")
      ) ;_ end of OR
       (PRINC (STRCAT "\n\tERROR : " MSG "\n"))
       (PRINC)
    ) ;_ end of IF
    (IF	RM
      (SETVAR "REGENMODE" RM)
    ) ;_ end of IF
    (IF	XP
      (SETVAR "EXPERT" XP)
    ) ;_ end of IF
    (COMMAND "_.Undo" "_End")
    (COMMAND "_.U")
    (IF	CE
      (SETVAR "CMDECHO" CE)
    ) ;_ end of IF
    (PRINC)
  ) ;_ end of DEFUN
  ;;  ----
  (SETQ CE (GETVAR "CMDECHO"))
  (SETVAR "CMDECHO" 0)
  (COMMAND "_.Undo" "_Begin")
  ;;  ----
  (SETQ RM (GETVAR "REGENMODE"))
  (SETVAR "REGENMODE" 0)
  (SETQ XP (GETVAR "EXPERT"))
  (SETVAR "EXPERT" 1)
  ;;  ----
  (COMMAND "_.Zoom" "_Extents")
  (COMMAND "_.Zoom" ".96x") ;|Revised for AutoCAD 2006|;
  (COMMAND "_.Purge" "_All" "*" "_No")
  (COMMAND "_.Purge" "_ALL" "*" "_No")
  (COMMAND "_.Purge" "_All" "*" "_No")
  (COMMAND "_.Purge" "_All" "*" "_No")
  ;;  ----
  (SETVAR "REGENMODE" RM)
  (SETVAR "EXPERT" XP)
  (COMMAND "_.RegenAll")
  (COMMAND "_.Undo" "_End")
  (SETVAR "CMDECHO" CE)
  (PRINC)
)
;;  ----