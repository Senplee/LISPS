(defun c:odc( / A_enam Aod_tbl B_enam)

  (setq olderr *error*) (setq *error* error)
  (setvar "CMDECHO" 0) (graphscr)
  (command "undo" "g")

  (while (or
           (= nil (setq A_enam (car (entsel "\n복사할 속성을 가진 객체 선택 :"))))
           (= nil (car (ade_odgettables A_enam)))
         )
  )

  (setq Aod_tbl (car (ade_odgettables A_enam)))
  (setq B_enam (car (entsel "\n속성을 넣을 객체 선택 :")))

  (setq A_ent (entget A_enam)
        B_ent (entget B_enam)
        old (assoc 8 B_ent)
        new (assoc 8 A_ent)
        chg (subst new old B_ent)
  )
  (entmod chg)

  (ade_odaddrecord B_enam Aod_tbl)

  (Od_cp A_enam Aod_tbl B_enam)

  (command "undo" "e")
  (setvar "highlight" 1)
  (setvar "osmode" Get_osmode)
  (princ)

)  
	   

(defun Od_cp(A_enam Aod_tbl B_enam / Od_lst Od_fld Od_enam A_fldv)
  (setq Od_lst (ade_odtabledefn Aod_tbl))
  (setq Od_fld (cdr (assoc "Columns" Od_lst)))

  (while (setq Od_enam (cdr (assoc "ColName" (car Od_fld))))
    (setq A_fldv (ade_odgetfield A_enam Aod_tbl Od_enam 0))
    (ade_odsetfield B_enam Aod_tbl Od_enam 0 A_fldv)
    (setq Od_fld (cdr Od_fld))
  )
  (command "undo" "e")
  (princ)
)