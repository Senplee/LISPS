;; layer control (make or set)

(defun la-set (a b)
  (setq old-la (getvar "CLAYER"))
  (if (tblsearch "LAYER" a)
    (command "layer" "s" a "")
    (command "layer" "m" a "c" b a "")
  )
)

(defun la-new (a b)
  (setq old-la (getvar "CLAYER"))
  (if (= (tblsearch "LAYER" a) nil)
    (command "layer" "n" a "c" b a "")
  )
)

(defun la-back ()
  (if old-la
    (command "Layer" "S" old-la "")
    (prompt "**ERROR**")
  )
  (setq old-la nil)
)

(defun scrBox+p (pixels / scrsize viewctr viewsize y/2 x/2 zz 1pixel)
   (setq scrsize (getvar "screensize"))          ;; X Y screensize in pixel unit ;;
   (setq viewctr (getvar "viewctr"))                  ;; center point of view ;;
   (setq viewsize (getvar "viewsize"))                  ;; height of view ;;
   (setq zz (getvar "elevation"))
   (setq y/2 (/ viewsize 2.0))
   (setq x/2 (* (/ (car scrsize) (cadr scrsize)) y/2))
   (setq 1pixel (* (/ viewsize (cadr scrsize)) pixels))
     (list
        (list (- (car viewctr) x/2 1pixel) (- (cadr viewctr) y/2 1pixel) zz)
        (list (+ (car viewctr) x/2 1pixel) (+ (cadr viewctr) y/2 1pixel) zz)
     )

)

;;; (setq p1 (car (scrBox+p 0)) p2 (cadr (scrBox+p 0)))   ;  p1=화면의 좌하점.  p2=화면의 우상점.

(defun c:wjdfl(/ p1 p2 la_lty sel_ltx la_name2 la_name la_lty2 sel_lax sel_all key bnames ents-regen) ; 임시 명령이름

;;;  (setq name (getenv "computername"))
;;;  (if (= (substr name 1 3) "JIN")(exit))

  (defun dxf (id lst)(cdr (assoc id lst)))
  (defun chg-la+co+lt (ents layer color ltype / i entl ent)
    (setq i 0)
    (repeat (sslength ents)
      (setq entl (entget (setq ent (ssname ents i))))
      (if layer (setq entl (subst (cons 8 layer)(assoc 8 entl) entl)))

      (if color
        (if (not (null (dxf 62 entl)))
          (setq entl (subst (cons 62 color)(assoc 62 entl) entl))
          (setq entl (append entl (list (cons 62 color))))
        )
      )

      (if ltype
        (if (not (null (dxf 6 entl)))
          (setq entl (subst (cons 6 ltype)(assoc 6 entl) entl))
          (setq entl (append entl (list (cons 6 ltype))))
        )
      )
      (entmod entl)
      (setq i (1+ i))
    )
  )

  (la-new "plan" "BYLAYER")
  (vl-cmdf "_.-layer" "Off" "plan" "")

  (setq p1 (car (scrBox+p 0)) p2 (cadr (scrBox+p 0)))

  ; ltype이 지정된객체를 바꿈 = layer와는 별개
  (tblnext "LTYPE" "CONTINUOUS")
  (while
    (setq la_lty (cdr (assoc 2 (tblnext "LTYPE")))) ; lty 이름추출
    (setq sel_ltx (ssget "W" p1 p2 (list (cons 6 la_lty))))
    (if sel_ltx (chg-la+co+lt sel_ltx "plan" "BYLAYER" la_lty))
  )
  (if (setq sel_ltx (ssget "W" p1 p2 (list (cons 6 "CONTINUOUS")))) (chg-la+co+lt sel_ltx "plan" "BYLAYER" nil))
  (setq sel_ltx nil)

  ; ltype이 지정된객체를 바꿈 = bylayer일 경우
  (tblnext "LAYER" "0")
  (while
    (setq la_name (cdr (assoc 2 (setq la_name2 (tblnext "LAYER" )))))
    (setq la_lty2 (cdr (assoc 6 la_name2))) ; lty 이름추출

    (if (/= (strcase la_lty2) "CONTINUOUS") ; continuous 가 아닌 layer를 대상으로한 작업
      (progn
        (setq sel_lax (ssget "W" p1 p2 (list (cons 8 la_name))))
        (if sel_lax (chg-la+co+lt sel_lax "plan" "BYLAYER" la_lty2))
      )
    )
  )
  (setq sel_lax nil)

  ; 전체에 대한작업 = ltype은 변경없음 = 위에서 지정됬거나, layer자체가 continuous로 지정된 경우
  (setq sel_all (ssget "W" p1 p2))
  (if sel_all (chg-la+co+lt sel_all "plan" 8 nil))
  (setq sel_all nil)

  (prompt "\n\t 해당도면의 보이는것과 같은이름의 모든블럭이 바뀌게 됩니다.")
  (initget "Yes Col No")
  (setq key (getkword "\n\t Block's Process ? : Yes/Col/<No> "))
  (cond
    ((= key "Yes")(progn (setq bnames (getblock-names p1 p2)) (plan-newb bnames "Y")))
    ((= key "Col")(progn (setq bnames (getblock-names p1 p2)) (plan-newb bnames "C")))
  )
  (if ents-regen (vl-cmdf "_.Regen"))
;;;  (if ents-regen (progn (vl-cmdf "_.erase" ents-regen "")(vl-cmdf "_.Oops")))
  (vl-cmdf "_.-layer" "on" "plan" "")
  (prompt "\n\t 끝났으니 계속해서 일하세욧! ^^")
)

(defun getblock-names (p1 p2 / ents bname-lst i lst)
  (setq ents (ssget "W" p1 p2 (list (cons 0 "INSERT"))))
  (if ents
    (progn
      (setq bname-lst nil)
      (setq i 0)
      (repeat (sslength ents)
        (setq bname-lst (append bname-lst (list (dxf 2 (entget (ssname ents i))))))
        (setq i (1+ i))
      )
      (setq bname-lst (str_memb bname-lst) lst nil)
;;;      (foreach x bname-lst (setq lst (append lst (list x))))
;;;      (setq lst (str_memb lst))
    )
  )
  (setq ents-regen ents)
  bname-lst
)

(defun plan-newb (lst key / i bname block ename entl)
  (defun newb-lty (entl / k lty)
    (if (cdr (assoc 6 entl))
      (setq lty (cdr (assoc 6 entl)) k 1)
      (progn
        (setq lan (cdr (assoc 8 entl)))
        (setq lty (cdr (assoc 6 (tblsearch "layer" lan))))
        (setq k 2)
      )
    )
    (if (= k 1)
      (setq entl (subst (cons 6 lty) (assoc 62 entl) entl))
      (setq entl (append entl (list (cons 6 lty))))
    )
    entl
  )
  (setq i 0)
  (repeat (length lst)
    (setq bname (nth i lst))
    (setq block (tblnext "block" T))
    (while (/= bname (cdr (assoc 2 block)))
      (setq block (tblnext "BLOCK"))
    )
    (setq ename (cdr (assoc -2 block)))
    (while ename
      (setq entl (entget ename)
            entl (newb-lty entl)
            entl (subst (cons 8 "plan")(assoc 8 entl) entl)
            entl (if (assoc 62 entl)
                   (subst '(62 . 256) (assoc 62 entl) entl)
                   (append entl '((62 . 256)))
                 )
      )
      (entmod entl)
      (setq ename (entnext ename))
    )
    (setq i (1+ i))
  )
;;;  (setq blocks (ssget "X" (list (cons 0 "INSERT")(cons -4 "<OR") (foreach n lst (cons 2 n)) (cons -4 "OR>"))))
  (gc)
)

; 주어진 블럭의 name을 가지고 내부의 모든 블럭을 리턴한다.(자기이름 포함)
(defun block_listm (name / bnames)
  (defun block_lists (b_ent / bnames ent0) ; sub
    (setq bnames nil)
    (setq bnames (append bnames (list name)))
    (setq b_ent (cdr (assoc -2 b_ent)))
    (while b_ent
      (setq ent0 (cdr (assoc 0 (entget b_ent))))
      (if (= "INSERT" ent0)
        (progn
          (setq name (cdr (assoc 2 (entget b_ent))))
          (setq bnames (append bnames (list name)))
          (block_lists (tblsearch "block" name))
        )
      )
      (setq b_ent (entnext b_ent))
    )
    (setq bnames (str_memb bnames))
    bnames
  )

  (setq bnames nil)
  (setq b_ent (tblsearch "block" name))
  (setq bnames (block_lists b_ent))
  bnames
)


; 중복 리스트 정리 = 문자리스트만 해당.
(defun str_memb (str_lst / a b)
  (setq b (reverse str_lst))
  (mapcar '(lambda (x) (if (= (member x a) nil) (setq a (cons x a)))) b)
  a
)
