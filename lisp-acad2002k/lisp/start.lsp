; ������¥: 2001.8.13
; �۾���: ������
; ��ɾ�: CIMSTART

(setq lfn15 1)
;====================================================================
;               �ʱ�ȭ ����                                          
;====================================================================
(defun m:STRT (/ bm gm fixw sc c_sc ds dim pt st ts se so ss dcl_id)

;;;  (setq bm (getvar "blipmode"))
;;;  (setq gm (getvar "gridmode"))
    (ai_err_on)
    (ai_undo_on)
    (command "_.undo" "_group")
    (princ "\nArchiFree 2002 for AutoCAD LT 2002.")
    (princ "\n�ʱ� ȯ�漳�� ����Դϴ�.")
    (initget (+ 1 2 4))
    (setq c_sc (getvar "dimscale"))
    (princ "\n���� ��ô�� : " )
    (princ c_sc)
    (princ "�Դϴ�.")
    (setq sc (getint "\n���� ��ô�� �Է��Ͻÿ�. : 1 / "))
  
    (while (= ds nil)
     (setq ds (strcase (getstring
      "Drawing Sheet <A0/A1/A2/A3/A4/Detail...etc.>: ")))
     (setq fixw (strcat ds ".DWG"))
     (if (= (findfile fixw) nil)
       (progn
         (princ fixw)
         (princ " file not found. ") (terpri)
         (princ "\nAnother ")
         (setq ds nil)
       )
     )
    )

     (setq pt (list 0 0))
     (setvar "cmdecho" 0)
     (setvar "blipmode" 0)
     (setvar "GRIDmode" 0)
  (if (setq ss (ssget "X" (list (cons 8 "FILE"))))
    (command "_erase" ss "")
  )
  
     (setq st (* sc 3))
     (setq se (* sc 4))
     (setq so (* sc 2))
     (setvar "cmdecho" 0)
     (setvar "LTSCALE" sc)
     (setvar "DIMSCALE" sc)    ;; ġ������ ��ô(ġ������ndim,sdim ���� 1)
     (setvar "snapunit" (list sc sc))
     (setvar "gridunit" (list se se))
        (SETLAY ds)
        (command "_.Insert" ds pt sc "" 0)
        (RTNLAY)
     (setvar "cmdecho" 0)

         (setvar "regenmode" 1)
     (command "_Zoom" "_E")
     (command "_.Zoom" "_E")
     (command "_.viewres" "_Y" "500")
     (command "_.Limits" (GETVAR "EXTMIN") (GETVAR "EXTMAX"))
     (if (= ci_f_inf "ON")
       (progn
         (file_init)
         (cim_file)
       )
     )
    
;; ���� ġ�� ȯ�漳���� core.lsp�� ai_dim�Լ��� ����� 
    (ai_dim)
    (setvar "dimscale" sc)
  
;; ================================================================================
;; ġ��ȯ�� ���� ���� 
;; ================================================================================
;;        (setvar "DRAGMODE" 2)
;;        
;;        (setvar "DIMALT"  0)
;;        (setvar "DIMALTD" 1)
;;        (setvar "DIMASSOC"  1)       ;; ����ġ��                  (�⺻�� : �ѱ�)
;;        (setvar "DIMASZ"  1)       ;; ȭ������ ũ��             (�⺻�� : 1)
;;
;;        (setvar "DIMCEN"  5)       ;; center ǥ��ũ��           (�⺻�� : 5)
;;        (setvar "DIMCLRD" 2)      ;; ġ���� ����                (�⺻�� : YELLOW)
;;        (setvar "DIMCLRE" 2)      ;; ġ�������� ����            (�⺻�� : YELLOW)
;;        (setvar "DIMCLRT" 6)      ;; ġ������ ����              (�⺻�� : MAGENTA)
;;        
;;          (setvar "DIMDEC" 0)       ;; �Ҽ��� �ڸ���              (�⺻�� : 0)
;;        (setvar "DIMDLE" 0)       ;; ġ������ ������ ġ���������� ����
;;        (setvar "DIMDLI" 8)       ;; ġ���� ���� ����           (�⺻�� : 8)
;;
;;        (setvar "DIMEXE" 2)       ;; ġ�������� ���弱          (�⺻�� : 2)
;;        (setvar "DIMEXO" 5)      ;; ġ�������� �������� ����  (�⺻�� : ����)
;;        
;;          (setvar "DIMFIT" 3)       ;; ġ���������� ������ �������� ���� ���(���� : 0 - 5)
;;        
;;        (setvar "DIMGAP" 1)       ;; ġ������ ���ڿ��� ����     (�⺻�� : 1)
;;
;;        (setvar "DIMLIM" 0)       ;; DIMTOL�� �Բ� ����Ͽ� ������ ǥ��(�⺻�� : 0)
;;        
;;        (setvar "DIMRND" 0.25)    ;; �ݿø� 
;;
;;            (setvar "DIMSAH" 0)       ;; �и� ȭ��ǥ ���           (�⺻�� : ����)
;;        
;;        (setvar "DIMSE1" 0)       ;; ù��° ġ�������� ����     (�⺻�� : 0)
;;        (setvar "DIMSE2" 0)       ;; �ι�° ġ�������� ����     (�⺻�� : 0)
;;      (setvar "DIMSOXD" 0)
;;        (setvar "DIMTAD" 1)       ;; ���ڸ� ġ������������ ���� (�⺻�� : 1)
;;        (setvar "DIMTDEC" 2)
;;        (setvar "DIMTIH" 0)       ;; ���弱 ������ ���ڴ� ������(�⺻�� : 0)
;;        (setvar "DIMTIX" 1)       ;; ���弱 ���ο� ���ڳ���     (�⺻�� : 1)
;;        (setvar "DIMTOFL" 1)      ;; ġ���� ���η� �� �о� �ֱ� (�⺻�� : �ѱ�)
;;        (setvar "DIMTOL" 0)       ;; DIMLIM�� �Բ� ����Ͽ� ������ ǥ��(�⺻�� : 0)
;;        (setvar "DIMTSZ" 0)       ;; ����ũ��
;;            (setvar "DIMUNIT" 8)      ;; �޸� �ֱ�                  (�⺻�� : 8 /�޸����ֱ� : 7)
;;      (setvar "DIMZIN" 0)
;;      (setvar "FILLETRAD" 0)
;;      (setvar "LUNITS" 2)
;;      (setvar "LUPREC" 2)
;;      (setvar "MIRRTEXT" 0)
;;      (setvar "PICKBOX" 3)
;;      (setvar "APERTURE" 6)
;;      (setvar "TEXTSIZE" st)
;;      (SETVAR "COORDS" 2)
;;        
;;        ( if         ( not ( stysearch "SIM"))
;;                ( styleset "SIM")
;;        )
;;      (setvar "DIMTXSTY" "SIM")
;;
;;      (if     ( not ( dimsearch "sdim"))
;;          (progn
;;                (setvar "DIMTXT" 2)       ;; ġ�������� ũ��            (���尪 : 2)
;;                (command "_dim1" "_save" "sdim" )
;;            )  
;;        )            
;;      (if     ( not (stysearch  "ndim"))
;;            (progn
;;                (setvar "DIMTXT" 3)       ;; ġ�������� ũ��            (���尪 : 3)
;;                (command "_dim1" "_save" "ndim" )
;;            )  
;;        )
  
;;      (setvar "cmdecho" 1)
;;        (princ "\nġ����Ÿ�� sdim,ndim�� �÷���")(terpri)
;;
;;  
;;     
;;   (command "_.insert" "dotk" (getvar "viewctr") "" "" "")
;;   (entdel (entlast))
;;   (command "_.dimblk" "dotk")
     
;;================================================================================
;;ġ��ȯ�� ���� ��
;;================================================================================

  ; CIHS ���������˻��ؼ� ������ �����ϰ� ���� ������������ ��ȯ
     (setvar "cmdecho" 0)
     (if (not (stysearch "CIHS"))
         (progn
            (styleset "CIHS")
            (COMMAND "_TEXTSTYLE" "CIHS")
         )
     )
  
  ; ������ dimscale�� cimstart����� ���� �Է¹��� �������� ���� ġ������ ����
  (if (/= c_sc sc)
     (progn
       (setq dim (getvar "dimstyle"))
       (setvar "cmdecho" 1)
       (princ (strcat "�� ġ������" dim "�� DIMSCALE=" (itoa sc) " �߰� ������ ��..."))
       (setvar "cmdecho" 0)
       (command "_dim1" "_save" (getvar "dimstyle") "Y")
     )
  )  
           
   
     (setvar "cmdecho" 1)
     (setvar "blipmode" 1)
  
     (princ "\n���� ��������: 1 / ")     
     (princ sc)
     (princ "\n���� ����ũ��: ")
     (princ ds)
     (princ "\n���� ġ������: ")
     (princ (getvar "DIMSTYLE"))
     (princ "\n���� ��������: ")
     (princ (getvar "TEXTSTYLE"))
     (princ "\nSnap: ")
     (princ sc)
     (princ "  Grid: ")
     (princ se)
;;;  (setvar "blipmode" bm)
;;;  (setvar "gridmode" gm)
     (princ)
  
  ;;==============================================================================
  ;; ��ȭ���ڷ� ������
     (setq dcl_id (ai_dcl "start"))
     (new_dialog "informbox" dcl_id)
     (set_tile "scale" (strcat "1 / " (itoa sc)))
     (set_tile "size" ds)
     (set_tile "dim" (getvar "DIMSTYLE"))
     (set_tile "style" (getvar "TEXTSTYLE"))
     (set_tile "snap" (itoa sc))
     (set_tile "grid" (itoa se))
     (start_dialog)
     (action_tile "accept" "(done_dialog)")
     ;(unload_dialog dcl_id) ��ȭ���ڸ� �ι�° ����ú��� ������� ��
     
  (ai_err_off)
  (ai_undo_off)
  (setvar "textstyle" "CIHS")
  (princ)
  ;;==============================================================================
)

(defun C:CIMSTART () (m:STRT))
(princ)
