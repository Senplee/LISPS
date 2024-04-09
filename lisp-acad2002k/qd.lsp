;;===============================
;  Quick dimension(96-97-98cho_i)
;;-------------------------------
(defun c:qd(/ cl os ds bm lt cdw dx xy pt1 pt2 pt3 pt4 pt5 dp12h agp12 p12m d11 d22
               ag1 p1 p2 p3)
   (setq cl (getvar "clayer") os (getvar "osmode") otm (getvar "orthomode")
         ds (getvar "dimscale") bm (getvar "blipmode") lt (getvar "ltscale"))
   (setvar "osmode" 129) (setvar "orthomode" 0) (setvar "blipmode" 1)
   (prompt "\nCommand: Quick Dimension...")
   (initget "Hor Ver Ali")
   (setq cdw (getkword "\n   Hor , Ver & Ali <Hor or Ver>: "))
;   (laset "a-grid-dims")
   (setq pt1 (getpoint "\nFirst extension line origin-> end & per of"))
  (while (/= pt1 nil);while start-----
   (setq pt2 (getpoint pt1 "\nSecond & continue extension line origin-> end & per of"))
   (setvar "blipmode" 0)
   (if (/= pt2 nil) (progn
       (setq p1 pt1 p2 pt2)
       (setq pt3 (getpoint pt2 "\nDimension line location <Double>-> end of"))
       (if (= pt3 nil)(progn
           (setq dp12h (/ (distance p1 p2) 2) agp12 (angle p1 p2) )
           (setvar "osmode" 0)
           (setq p12m (polar p1 agp12 dp12h))
           (setvar "osmode" 129);end & per of
           (setq pt4 (getpoint p12m "\nText base point-> end & per of"))
           (setvar "osmode" 0)
           (setq pt5 (getpoint pt4 "Text other point->"))
           (setq ag1 (angle p12m pt4) d11 (distance p12m pt4)
                 d22 (distance p12m pt5))
           (if (> d11 d22) (setq ag1 (+ ag1 pi)) )
           (setq pt3 (polar pt4 ag1 (* ds 8)));double line 간격설정
       )   )
       (setq p3 pt3)
       (setvar "osmode" 0)
       (if (/= cdw "Ali") (progn
           (setq dx (abs (- (car p1) (car p2)))
                     dy (abs (- (cadr p1) (cadr p2))) )
           (if (> (- dx dy) 0) (setq cdw "hor") (setq cdw "ver"))
       ))
       (command "dim" cdw p1 p2 p3 "" "e")
       (setvar "osmode" 129)
   )   )
   (if (= pt2 nil) (progn
       (setvar "osmode" 0)  (setq p1 p2 p2 pt1)
       (if (/= cdw "Ali") (progn
           (setq dx (abs (- (car p1) (car p2)))
                     dy (abs (- (cadr p1) (cadr p2))) )
           (if (> (- dx dy) 0) (setq cdw "hor") (setq cdw "ver"))
       ))
       (command "dim" cdw p1 p2 p3 "" "e") (setvar "osmode" 1)
   )   )
   (setvar "blipmode" 1)
   (setq pt1 (getpoint "\nFirst & Second extension line origin-> end & per of"))
  );while end-----
   (setvar "osmode" os) (setvar "orthomode" otm)
   (setvar "clayer" cl) (setvar "blipmode" bm)
   (prin1)
)