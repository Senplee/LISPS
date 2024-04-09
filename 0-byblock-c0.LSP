;FixBlock.lsp  [June 30, 1998]
 ;
 ; Copyright 1996 - 1998 ManuSoft
 ;
 ; Freeware from:
 ;   ManuSoft
 ;   http://www.manusoft.com
 ;
 ; Load function, then enter FIXBLOCK to redefine selected blocks
 ;  so that all entities are on layer '0', color 'BYBLOCK'.
 ;
;;===================================================================
;;  09/29/2004  CAB modified to remove the 71 code from block def.   
;;===================================================================
(defun c:c0 (/ ss cnt idx blkname donelist DXF Update)
  (defun DXF (gcode el) (cdr (assoc gcode el)))
  (defun Update (bname / ename elist)
    (setq ename (tblobjname "BLOCK" bname))
    (if
      (and ename (zerop (logand 52 (DXF 70 (entget ename '("*"))))))
      (progn
        (while ename
          (setq elist (entget ename '("*"))
                elist (subst '(8 . "0") (assoc 8 elist) elist)
                elist (if (assoc 62 elist)
                        (subst '(62 . 0) (assoc 62 elist) elist)
                        (append elist '((62 . 0)))))
          ;;  CAB added - filter (71 .1) from BLOCK
          (if (and (= (cdr(assoc 0 elist)) "BLOCK") (assoc 71 elist))
            (setq elist (vl-remove '(71 . 1) elist))
          );  end CAB add
          (entmake elist)
          (setq ename (entnext ename)))
          (if (= "ENDBLK" (DXF 0 elist)); CAB revised was /=
            T ; CAB added, might use this as a 'empty block' counter
            ;; ELSE return true if created successfully - CAB added
            (not(null(entmake '((0 . "ENDBLK") (8 . "0") (62 . 0)))))
            ;;(entmake '((0 . "ENDBLK") (8 . "0") (62 . 0))) ; CAB removed
          )
        ;;'T   CAB removed
        ); progn
      ); endif
; (vl-load-com)
; (vla-update elist)
 (princ)
  ); defun
  
  
  ;;=====================  Start  =======================
  (if (> (logand (DXF 70 (tblsearch "layer" "0")) 1) 0)
    (princ "\nLayer 0 must be thawed before running FIXBLOCK!\n")
    (progn
      (if
        (progn
          (princ "\nPress <Enter> to fix ALL defined blocks\n")
          (setq cnt 0
                ss (ssget '((0 . "INSERT")))))
        (progn
          (setq idx (sslength ss))
          (while (>= (setq idx (1- idx)) 0)
            (if (not (member (setq blkname (DXF 2 (entget (ssname ss idx)))) donelist))
              (progn
                (if (Update blkname) (setq cnt (1+ cnt)))
                (setq donelist (cons blkname donelist))))))
        (while (setq blkname (DXF 2 (tblnext "BLOCK" (not blkname))))
          (if (Update blkname) (setq cnt (1+ cnt)))))
      (princ (strcat "\n" (itoa cnt) " block" (if (= cnt 1) "" "s") " redefined\n"))))
  (princ)
)
;;(prompt "\nFix Block Loaded. Enter FixBlock to run.")
;;(princ)
;End-of-file







