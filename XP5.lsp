

;;////////////// ERROR 메세지 처리 ///////////////////////////

(defun jin4error (msg)
  (if (/= s "Function cancelled")
    (PRIN1 (strcat "\nError: " msg))
  )
  (if olderr (setq *error* olderr olderr nil))
  (if olds (setvar "Osmode" olds))
  (if old-la (setvar "Clayer" old-la))
  (if chm (setvar "Cmdecho" chm))
  (if os (setvar "Osmode" os))
  (if bl (setvar "Blipmode" bl))
  (setq msg nil os nil olds nil bl nil old-la nil chm nil p nil)
  (princ)
;  (gc)
)

;;; xclip된 블럭을 삽입된 형태로 분해함. (explode 및 trim이용) - Revision-1.0
(defun c:xp5 (/ k xref-10 x-ent pl1 p-pl1 p-ptl entx x-ents x-ents2
                p2 pl2 p-pl2 p-ptl2 x-ents3 x-ent3 i olds chm)
  (prompt "\n\t xclip된 블럭을 삽입된 형태로 분해함. (explode 및 trim이용) ")
  (command "Undo" "Be")

  (setq *error* jin4error)
  (setq olds (getvar "Osmode"))
  (setq chm (getvar "Cmdecho"))
  (setvar "Osmode" 0)
  (setvar "Cmdecho" 0)

  (setq k T)

  ;; 블럭의 이름을 받아들임.
  (while k
    (setq x-ent (entsel "\n\t Xref-Block Select ?:"))
    (if (= (cdr (assoc 0 (setq x-entl (entget (car x-ent))))) "INSERT")
      (setq k nil b_name (cdr (assoc 2 x-entl)))
      (prompt "\t ??Select is Not Block?? Select again ")
    )
  )

  ;; 블럭의 회전 및 축척 등을 기본으로 조정함.
  (setq xref-10 (cdr (assoc 10 x-entl)))

  ;; 블럭의 경계선을 생성하여 포인트리스트를 받아들임.
  (vl-cmdf "XCLIP" x-ent "" "P")
  (setq ent_zoom (entlast))
  (setq p-pl1 (entget (setq pl1 (entlast))))
  (setq p-ptl (getpolyvtx p-pl1))
  (setq p-ptl (append p-ptl (list (nth 0 p-ptl))))

  (setq ptlst (getpolyvtx (entget ent_zoom)))
  (sort-lst_max-min ptlst 'maxpt 'minpt)
  (vl-cmdf "'Zoom" "W" minpt maxpt)
  (vl-cmdf "'Zoom" "0.95x")

  (prompt "\n\t block-explode point")
  ;; 블럭을 분해하여 전체개체를 선택함.(이후에 erase및 trim을 하기위함)
  (setq entx (entlast) x-ents (ssadd))
  (vl-cmdf "explode" x-ent)

(setq xp5k 0) ; check-0
  (setq x-ents (ssget "P"))

(setq xp5k 2) ; check-2

  (prompt "\n\t select outside entty")
  ;; 1. 경계선의 바깥에 존재하는 개체를 선택하여 지움.
  (defun #erase-outside (p-ptl x-ents / i x-ents2)
    (setq x-ents2 (ssget "CP" p-ptl))
    (setq i 0)
    (repeat (sslength x-ents2)
      (ssdel (ssname x-ents2 i) x-ents)
      (setq i (1+ i))
    )
    (if x-ents (vl-cmdf "erase" x-ents ""))
  )
  ;; 2. 경계선의 걸치는 블럭을 분해함. 그리고 경계넘어 지움.
  (defun #explode-box (p-ptl / x-ents4 ii)
    (setq x-ents4 (ssget "F" p-ptl (list (cons 0 "INSERT"))))
;(setq xp5k 33) ; check-33
    (if x-ents4
      (progn
        (setq ii 0)
        (repeat (sslength x-ents4)
          (setq ss (ssname x-ents4 ii))
          (vl-cmdf "_.Explode" ss)
          (setq ss (ssget "P"))
          (#erase-outside p-ptl ss)
          (setq ii (1+ ii))
        )
      )
    )
  )
  
  (#erase-outside p-ptl x-ents)
(setq xp5k 3) ; check-3
  (#explode-box p-ptl)
  
(setq xp5k 4) ; check-4

  (prompt "\n\t first trim")
  ;; 경계선의 바깥점 한곳을 선택해서 경계선을 옵셋하고 포인트리스트를 받아
  ;; 트림할 개체를 선택함.
  (setq ptlst (getpolyvtx (entget ent_zoom)))
  (sort-lst_max-min ptlst 'maxpt 'minpt)
  (vl-cmdf "'Zoom" "W" minpt maxpt)
  (vl-cmdf "'Zoom" "0.95x")
  (setq p2 (getpoint "\n\t Box의 바깥쪽 한지점을 선택하시오. ?:"))
  (vl-cmdf "offset" "T" pl1 p2 "")
  (setq p-pl2 (entget (setq pl2 (entlast))))
  (setq p-ptl2 (getpolyvtx p-pl2))
  (setq p-ptl2 (append p-ptl2 (list (nth 0 p-ptl2))))
  (vl-cmdf "erase" pl2 "") ; 옵셋된 경계선 삭제
  (repeat 3
    (vl-cmdf "Trim" pl1 "" "F")
    (mapcar 'command p-ptl2)
    (vl-cmdf "" "" )
  )

  (setvar "Osmode" olds)
  (setvar "Cmdecho" chm)
  (vl-cmdf "Undo" "End")
)

(defun GetPolyVtx(EntList)
  (setq VtxList '())
  (foreach x EntList
   (if (= (car x) 10)
    (setq VtxList (append VtxList (list (cdr x))))
   )
  )
VtxList
)

(defun sort-lst_max-min (ptlst pt1 pt2 / ent0 ptlst b-ent ps pe ptl pt max-x max-y min-x min-y maxp minp) ; sub
  (setq max-x (apply 'max (mapcar '(lambda (x) (car x)) ptlst))) ; x좌표중큰값
  (setq max-y (apply 'max (mapcar '(lambda (x) (cadr x)) ptlst))) ; y좌표중큰값
  (setq min-x (apply 'min (mapcar '(lambda (x) (car x)) ptlst))) ; x좌표중작은값
  (setq min-y (apply 'min (mapcar '(lambda (x) (cadr x)) ptlst))) ; x좌표중작은값

  (setq maxp (list max-x max-y) minp (list min-x min-y))
  (set (eval 'pt1) maxp)
  (set (eval 'pt2) minp)
)

;;; END OF XP5

