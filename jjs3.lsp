(defun rrbI:LayerFiltersDelete  (strKeepWC / objXDict)
 ;; This function insures that an Extension Dictionary exists, and works on both locations for layer filters
 (vl-load-com)                                                                  ; load ActiveX if needed
 (vl-catch-all-apply                                                            ; trap error if no extension dictionary
  (function
   (lambda ()
    (setq objXDict (vla-GetExtensionDictionary                                  ; bind dictionary to variable
                    (vla-get-Layers (vla-get-ActiveDocument (vlax-get-acad-object))))))))
 (cond (objXDict                                                                ; if the extension dictionary exists
        (or                                                                     ; use OR to return T for success
         (rrbI:DeleteAllXRecs objXDict "ACAD_LAYERFILTERS" strKeepWC)           ; pre-2005 layer filters
         (rrbI:DeleteAllXRecs objXDict "AcLyDictionary" strKeepWC)))))          ; 2005 layer filters

(defun rrbI:DeleteAllXRecs  (objXDict dictName strKeepWC / objDict i)
 ;; This function performs the chore of deleting each filer that doesn''t match the wildcard
 (vl-catch-all-apply                                                            ; trap errors
  (function
   (lambda ()
    (setq objDict (vla-Item objXDict dictName))                                 ; get layer filters dictionary
    (vlax-for objXRec  objDict                                                  ; loop thru all XRecords in the dictionary
     (cond ((not (and strKeepWC (wcmatch (vla-Get-Name objXRec) strKeepWC)))    ; if deleting all filters, or current doesn''t match wildcard
            (setq i (1+ (cond (i)                                               ; increment counter
                              (0))))                                            ; initialize counter
            (vla-Delete objXRec)))))))                                          ; delete filter
 (cond (i (princ (strcat "\n" (itoa i) " filters deleted.")))))                 ; if counter is bound, report number of filters deleted

(defun C:LFD  (/ inpKeep)
 ;; Main command-line function
 (setq inpKeep (getstring
                "\nWildcard mask for filters to keep, or <Enter> to delete all: "))
 (rrbI:LayerFiltersDelete (cond ((/= inpKeep "") inpKeep)))                     ; pass nil to subr if user hit <Enter>
 (princ))                                                                       ; clean exit

