;;-----------------------=={ Viewport Outline }==-----------------------;;
;;                                                                      ;;
;;  Generates an LWPolyline in Modelspace representing the outline of   ;;
;;  a selected Paperspace Viewport. Compatible with all Rectangular     ;;
;;  and Polygonal Viewports (including those with Arc segments), and    ;;
;;  with all views & construction planes.                               ;;
;;----------------------------------------------------------------------;;
;;  Author:  Lee Mac, Copyright © 2015  -  www.lee-mac.com              ;;
;;----------------------------------------------------------------------;;
;;  Version 1.0    -    2015-01-02                                      ;;
;;                                                                      ;;
;;  - First release.                                                    ;;
;;----------------------------------------------------------------------;;
;;  Version 1.1    -    2016-08-11                                      ;;
;;                                                                      ;;
;;  - Program modified to account for polygonal viewports represented   ;;
;;    by 2D (Heavy) Polylines.                                          ;;
;;----------------------------------------------------------------------;;

(defun c:vpo ( / *error* cen ent lst ocs vpe vpt )

    (defun *error* ( msg )
        (LM:endundo (LM:acdoc))
        (if (not (wcmatch (strcase msg t) "*break,*cancel*,*exit*"))
            (princ (strcat "\nError: " msg))
        )
        (princ)
    )

    (LM:startundo (LM:acdoc))
    (cond
        (   (/= 1 (getvar 'cvport))
            (princ "\nCommand not available in Modelspace.")
        )
        (   (setq vpt (LM:ssget "\nSelect viewport: " '("_+.:E:S" ((0 . "VIEWPORT")))))
            (setq vpt (entget (ssname vpt 0)))
            (if (setq ent (cdr (assoc 340 vpt)))
                (setq lst (vpo:polyvertices ent))
                (setq cen (mapcar 'list (cdr (assoc 10 vpt))
                              (list
                                  (/ (cdr (assoc 40 vpt)) 2.0)
                                  (/ (cdr (assoc 41 vpt)) 2.0)
                              )
                          )
                      lst (mapcar
                             '(lambda ( a ) (cons (mapcar 'apply a cen) '(42 . 0.0)))
                             '((- -) (+ -) (+ +) (- +))
                          )
                )
            )
            (setq vpe (cdr (assoc -1 vpt))
                  ocs (cdr (assoc 16 vpt))
            )
            (entmake
                (append
                    (list
                       '(000 . "LWPOLYLINE")
                       '(100 . "AcDbEntity")
                       '(100 . "AcDbPolyline")
                        (cons 90 (length lst))
                       '(070 . 1)
                       '(410 . "Model")
                    )
                    (apply 'append (mapcar '(lambda ( x ) (list (cons 10 (trans (pcs2wcs (car x) vpe) 0 ocs)) (cdr x))) lst))
                    (list (cons 210 ocs))
                )
            )
        )
    )
    (LM:endundo (LM:acdoc))
    (princ)
)

(defun vpo:polyvertices ( ent )
    (apply '(lambda ( foo bar ) (foo bar))
        (if (= "LWPOLYLINE" (cdr (assoc 0 (entget ent))))
            (list
                (lambda ( enx )
                    (if (setq enx (member (assoc 10 enx) enx))
                        (cons (cons  (cdr (assoc 10 enx)) (assoc 42 enx)) (foo (cdr enx)))
                    )
                )
                (entget ent)
            )
            (list
                (lambda ( ent / enx )
                    (if (= "VERTEX" (cdr (assoc 0 (setq enx (entget ent)))))
                        (cons (cons (cdr (assoc 10 enx)) (assoc 42 enx)) (foo (entnext ent)))
                    )
            	)
                (entnext ent)
            )
        )
    )
)

;; ssget  -  Lee Mac
;; A wrapper for the ssget function to permit the use of a custom selection prompt
;; msg - [str] selection prompt
;; arg - [lst] list of ssget arguments

(defun LM:ssget ( msg arg / sel )
    (princ msg)
    (setvar 'nomutt 1)
    (setq sel (vl-catch-all-apply 'ssget arg))
    (setvar 'nomutt 0)
    (if (not (vl-catch-all-error-p sel)) sel)
)

;; PCS2WCS (gile)
;; Translates a PCS point to WCS based on the supplied Viewport
;; (PCS2WCS pt vp) is the same as (trans (trans pt 3 2) 2 0) when vp is active
;; pnt : PCS point
;; ent : Viewport ename

(defun PCS2WCS ( pnt ent / ang enx mat nor scl )
    (setq pnt (trans pnt 0 0)
          enx (entget ent)
          ang (- (cdr (assoc 51 enx)))
          nor (cdr (assoc 16 enx))
          scl (/ (cdr (assoc 45 enx)) (cdr (assoc 41 enx)))
          mat (mxm
                  (mapcar (function (lambda ( v ) (trans v 0 nor t)))
                     '(   (1.0 0.0 0.0)
                          (0.0 1.0 0.0)
                          (0.0 0.0 1.0)
                      )
                  )
                  (list
                      (list (cos ang) (- (sin ang)) 0.0)
                      (list (sin ang)    (cos ang)  0.0)
                     '(0.0 0.0 1.0)
                  )
              )
    )
    (mapcar '+
        (mxv mat
            (mapcar '+
                (vxs pnt scl)
                (vxs (cdr (assoc 10 enx)) (- scl))
                (cdr (assoc 12 enx))
            )
        )
        (cdr (assoc 17 enx))
    )
)

;; Matrix Transpose  -  Doug Wilson
;; Args: m - nxn matrix

(defun trp ( m )
    (apply 'mapcar (cons 'list m))
)

;; Matrix x Matrix  -  Vladimir Nesterovsky
;; Args: m,n - nxn matrices

(defun mxm ( m n )
    ((lambda ( a ) (mapcar '(lambda ( r ) (mxv a r)) m)) (trp n))
)

;; Matrix x Vector  -  Vladimir Nesterovsky
;; Args: m - nxn matrix, v - vector in R^n

(defun mxv ( m v )
    (mapcar '(lambda ( r ) (apply '+ (mapcar '* r v))) m)
)

;; Vector x Scalar  -  Lee Mac
;; Args: v - vector in R^n, s - real scalar

(defun vxs ( v s )
    (mapcar '(lambda ( n ) (* n s)) v)
)

;; Start Undo  -  Lee Mac
;; Opens an Undo Group.

(defun LM:startundo ( doc )
    (LM:endundo doc)
    (vla-startundomark doc)
)

;; End Undo  -  Lee Mac
;; Closes an Undo Group.

(defun LM:endundo ( doc )
    (while (= 8 (logand 8 (getvar 'undoctl)))
        (vla-endundomark doc)
    )
)

;; Active Document  -  Lee Mac
;; Returns the VLA Active Document Object

(defun LM:acdoc nil
    (eval (list 'defun 'LM:acdoc 'nil (vla-get-activedocument (vlax-get-acad-object))))
    (LM:acdoc)
)

;;----------------------------------------------------------------------;;

(princ
    (strcat
        "\n:: VPOutline.lsp | Version 1.1 | \\U+00A9 Lee Mac "
        (menucmd "m=$(edtime,0,yyyy)")
        " www.lee-mac.com ::"
        "\n:: Type \"vpo\" to Invoke ::"
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;