;; 수정일짜: 2001.8.13
;; 작업자: 박율구
;; 명령어: CIMDM

;단축키 관련 변수 정의 부분
(setq lfn12 1)

;;;
;;; Main function
;;;
(defun m:DM(/ dm_aso        dm_err        dm_oer        dm_ola        dm_gri        dm_osm        dm_oco        dm_oli
                          dm_txt        dm_dts        dm_dbk        dm_dsa        strtpt        nextpt        sptlist        dm_sty
                          dm_ogr        uctr        mctr        cont        temp        tem                sc                bpt
                          ang                u_flag  blipmode)
        (setq        sc     (getvar "ltscale")
                dm_oco (getvar "cecolor")
                dm_oli (getvar "celtype")
                dm_ola (getvar "clayer")
                dm_gri (getvar "gridunit")
                dm_osm (getvar "OSMODE")
                dm_txt (getvar "textstyle")
                blipmode (getvar "blipmode")
        )
  ;;
  ;; Internal error handler defined locally
  ;;
  (defun dm_err (s)                   ; If an error (such as CTRL-C) occurs
                                      ; while this command is active...
    (if (/= s "Function cancelled")
      (if (= s "quit / exit abort")
        (princ)
        (princ (strcat "\nError: " s))
      )
    )
    (setvar "cmdecho" 0)
    (command "_.undo" "_en")
    (ai_undo_off)
    (if dm_oer                        ; If an old error routine exists
      (setq *error* dm_oer)           ; then, reset it 
    )
    (if dm_oco (setvar "cecolor" dm_oco))
    (if dm_oli (setvar "celtype" dm_oli))
    (if dm_osm (setvar "osmode" dm_osm))
    (if dm_ola (setvar "clayer" dm_ola))
    (if dm_gri (setvar "gridunit" dm_gri))
    (if dm_txt (setvar "textstyle" dm_txt))
        (if (not (equal dm_gri dm_ogr)) (redraw))
    
    (setvar "blipmode" blipmode)
    (setvar "cmdecho" 1)
    (princ)
  )
  
  ;; Set our new error handler
  (if (not *DEBUG*)
    (if *error*                     
      (setq dm_oer *error* *error* dm_err) 
      (setq *error* dm_err) 
    )
  )

  (setvar "cmdecho" 0)
  (setvar "blipmode" 1)
  (ai_undo_on)
  (command "_.undo" "_group")
  
  (setvar "cecolor" "bylayer")
  (setvar "celtype" "bylayer")
  (setlay "dim")
  (SETVAR "DIMASSOC" 1)
  (SETVAR "DIMALTD" 1)
  (SETVAR "DIMSE1" 0)
  (SETVAR "DIMSE2" 0)
  (SETVAR "DIMGAP" sc)
  (SETVAR "DIMDEC" 0)
  (setq dm_dts (getvar "dimtsz"))
  (setq dm_dbk (getvar "dimblk"))
  (setq dm_dsa (getvar "dimsah"))
  (if (= dbk1 nil) (setq dbk1 "dotk"))
  (if (= (blksearch dbk1) nil)
    (progn
      (setvar "blipmode" 0)
      (command "_.insert" dbk1 (getvar "viewctr") "" "" "")
      (setvar "blipmode" 1)
      (entdel (entlast))
    )
  )
  (command "_.DIMBLK1" dbk1)
  (command "_.DIMBLK2" dbk1)
  (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
  (princ "\n자동 치수 기입 명령입니다.")
  
   (ai_dim)
  
  (setvar "cmdecho" 0)
  (setq dm_sty (getvar "dimtxsty"))
  (if (not (stysearch dm_sty))
    (styleset dm_sty)
  )
  (if (null dm_cmd)
    (setq dm_cmd "_.dimlinear")
  )
  (command "_.dimstyle" "r" (getvar "dimstyle"))
  (dm:info)
  (setq cont T mctr 0 temp T tem nil u_flag nil)
  (while cont
    (dm_m1)
    (dm_m2)
  )
  
  (if dm_oco (setvar "cecolor" dm_oco))
  (if dm_oli (setvar "celtype" dm_oli))
  (if dm_osm (setvar "osmode" dm_osm))
  (if dm_ola (setvar "clayer" dm_ola))
  (if dm_gri (setvar "gridunit" dm_gri))
  (if dm_txt (setvar "textstyle" dm_txt))
  (if (not (equal dm_gri dm_ogr)) (redraw))
  (setvar "blipmode" blipmode)
  
  (command "_.UNDO" "_EN")
  (ai_undo_off)
  (setvar "cmdecho" 1)
  (princ)
)

(defun dm_m1 ()
  (setvar "OSMODE" 33)
  (while temp
        (if (= dm_cmd "_.dimlinear")
            (if (> mctr 0)
              (progn
                (initget "Undo Style Aligned")
                (setq strtpt (getpoint "\n>>> Undo/Style/Aligned<Linear: start point>: "))
              )
              (progn
                (initget "Style Aligned")
                (setq strtpt (getpoint "\n>>> Style/Aligned<Linear: start point>: "))
              )
            )
            (if (> mctr 0)
              (progn
                (initget "Undo Style Linear")
                (setq strtpt (getpoint "\n>>> Undo/Style/Linear<Aligned: start point>: "))
              )
              (progn
                (initget "Style Linear")
                (setq strtpt (getpoint "\n>>> Style/Linear<Aligned: start point>: "))
              )
            )
        )
    (cond
      ((= strtpt "Undo")
        (command "_.undo" "_b")
        (setq mctr (1- mctr))
      )
      ((= strtpt "Style")
            (command "_ddim")
            (dm:info)
            (command "_.dimblk" "dotk")
      )
      ((= strtpt "Linear")
        (setq dm_cmd "_.dimlinear")
      )
      ((= strtpt "Aligned")
        (setq dm_cmd "_.dimaligned")
      )
      ((null strtpt)
        (setq cont nil temp nil)
      )
      (T
        (setq temp nil tem T)
      )
    )
  )
)

(defun dm_m2 ()
  (setvar "OSMODE" 129)
  (setq sptlist nil
                  sptlist (cons strtpt sptlist)
                bpt     strtpt
        uctr    0 
  )
  (while tem
    (if (> uctr 0)
      (progn
        (initget "Undo")
            (setq nextpt (getpoint strtpt "\nUndo/<next point>: "))
      )
          (if (= dm_cmd "_.dimlinear")
              (progn
                (initget "Undo Style Aligned")
                    (setq nextpt (getpoint strtpt "\nUndo/Style/Aligned<Linear: next point>: "))
              )
              (progn
                (initget "Undo Style Linear")
                    (setq nextpt (getpoint strtpt "\nUndo/Style/Linear<Aligned: next point>: "))
              )
           )
    )
    (cond
      ((= nextpt "Undo")
                  (if (> uctr 0)
                  (progn
                (entdel (entlast))
            (setq sptlist (member (nth 1 sptlist) sptlist))
            (setq strtpt (nth 0 sptlist))
                (setq uctr (1- uctr))
                        (setq u_flag T)
                  )
          (setq tem nil temp T)
                )
      )
      ((= nextpt "Style")
                (command "_ddim")
                (dm:info)
                    (command "_.dimblk" "dotk")
      )
      ((= nextpt "Linear")
        (setq dm_cmd "_.dimlinear")
      )
      ((= nextpt "Aligned")
        (setq dm_cmd "_.dimaligned")
      )
      ((null nextpt)
                  (if (> uctr 1)
                  (dm_exe)
                  (if (= uctr 0)
                          (setq cont nil)
                  )
                )
        (setq temp T tem nil)
      )
      (T
                (if (= uctr 0)
                  (progn
                    (setq ang (angle strtpt nextpt))
                    (command "_.dimstyle" "r" (getvar "dimstyle"))
                    (command "_.undo" "_m")
                    (princ "\n    Dimension line location: ")
                    (command dm_cmd strtpt nextpt pause)
                    (setq strtpt nextpt)
                    (setq sptlist (cons strtpt sptlist))
                    (setq uctr (1+ uctr))
                    (setq mctr (1+ mctr))
                  )
                  (progn
                    (if u_flag
                          (progn
                                     (command "_.dimcontinue" strtpt nextpt "" "")
                                (setq u_flag nil)
                          )
                             (command "_.dimcontinue" nextpt "" "")
                        )
                (setq strtpt nextpt)
                (setq sptlist (cons strtpt sptlist))
                (setq uctr (1+ uctr))
                  )
                )
        (princ " \n")
      )
    )
  )
)

(defun dm_exe (/ zvk ent)
  (setvar "OSMODE" 0)
  (initget 1 "S D  ")
  (if (= dm_zv nil) (setq dm_zv "D"))
  (setq zvk (getkword (strcat "\n\n>>> <S>ingle or <D>ouble ? <" dm_zv "> : ")))
  (if (member zvk '("S" "D")) (setq dm_zv zvk))
  (if (= dm_zv "D")
    (progn
      (command "_.dimcontinue" (polar strtpt ang 1) "" "")
      (setq ent (entlast))
      (command "_.dimbaseline" bpt "" "")
          (entdel ent)
    )
  )
)

;; 밑의 adim은 일단 삭제함
;(defun dm:adim ()
;  (ai_dim)     ;; core.lsp의 ai_dim함수를 통해 CIMSTART의 치수 초기화
;  (setvar "DIMTSZ" 0)
;  (setvar "DIMSAH" 0)
;  (setvar "DIMASZ" (* 2 sc))
;  (setvar "DIMEXE" (* SC 3))
;  (SETVAR "DIMEXO" SC)
;  (SETVAR "DIMTXT" (* SC 2))
;  (SETVAR "DIMDLI" (* sc 6))
;  ;(if (not (stysearch "SIM"))  이 부분은 ai_dim()에 있음
;  ;  (styleset "SIM")
;  ;)
;  ;(setvar "dimtxsty" "SIM")
;  (setvar "dimblk" ".")
;  (command "_.dim1" "_save" "adim")
;)

;========================================================================
;;  밑의 sdim,ndim은 core.lsp의 ai_dim()으로 교체함 (작업자:박율구)
;========================================================================
;(defun dm:sdim ()
;  (ai_dim)       ;; core.lsp의 ai_dim함수를 통해 CIMSTART의 치수 초기화
;  (if (and (= dm_dts 0) (= dm_dbk ""))
;    (setvar "DIMASZ" (* 2 sc))
;  )
;  (if (/= dm_dts 0) (setvar "dimtsz" (* 1.5 sc)))
;  (if (and (= dm_dts 0) (= dm_dsa 1))
;    (setvar "DIMASZ" (* sc (/ 2.0 3)))
;  )
;  (setvar "DIMEXE" (* SC 3))
;  (SETVAR "DIMEXO" SC)
;  (SETVAR "DIMTXT" (* SC 2))
;  (SETVAR "DIMDLI" (* sc 6))
;  ;(if (not (stysearch "SIM"))   이 부분은 ai_dim()에 있음
;  ;  (styleset "SIM")
;  ;)
;  ;(setvar "dimtxsty" "SIM")
;  (command "_.dim1" "_save" "sdim")
;)
;(defun dm:ndim ()
;  (ai_dim)       ;; core.lsp의 ai_dim함수를 통해 CIMSTART의 치수 초기화
;  (if (and (= dm_dts 0) (= dm_dbk ""))
;    (setvar "DIMASZ" (* 3 sc))
;  )
;  (if (/= dm_dts 0) (setvar "dimtsz" (* 2 sc)))
;  (if (and (= dm_dts 0) (= dm_dsa 1))
;    (setvar "DIMASZ" sc)
;  )
;  (setvar "DIMEXE" (* SC 4))
;  (SETVAR "DIMEXO" (* SC 2))
;  (SETVAR "DIMTXT" (* SC 3))
;  (SETVAR "DIMDLI" (* sc 8))
;  ;(if (not (stysearch "SIM"))   이 부분은 ai_dim()에 있음
;  ;  (styleset "SIM")
;  ;)
;  ;(setvar "dimtxsty" "SIM")
;  (command "_.dim1" "_save" "ndim")
;)

(defun dm:info (/ gri ogr)
  (setq gri (/ (getvar "dimdli") 2.0))
  (setq ogr (car (getvar "gridunit")))
  (setvar "gridunit" (list gri gri))
  (if (and (/= gri ogr) (= (getvar "gridmode") 1))
    (redraw)
  )
  (princ "\n현재 도면축적: 1/")
  (princ sc)
  (princ "  현재 치수유형: ")
  (princ (getvar "dimstyle"))
  (princ "\n현재 문자유형: ")
  (princ (getvar "dimtxsty"))
  (princ "  현재 문자크기: ")
  (princ (getvar "dimtxt"))
  (princ "  Snap: ")
  (princ (getvar "snapunit"))
  (princ "  Grid: ")
  (princ (setq dm_ogr (getvar "gridunit")))
  (setvar "cmdecho" 0)
  (princ)  
)

(defun C:CIMDM () (m:dm))
;;(cad_lock)
;;(princ "\n\tC:autoDiMension loaded. Start command with DM. ")
(princ)
