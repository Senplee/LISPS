;;-----------------------=={ Copy or Swap Text }==----------------------;;
;;                                                                      ;;
;;  This program enables a user to either copy the text content from    ;;
;;  a multitude of 'source' objects to a selection of 'destination'     ;;
;;  objects, or swap the text content between two objects.              ;;
;;                                                                      ;;
;;  To copy text, the program may be called with 'ctx' at the AutoCAD   ;;
;;  command line. The user may then select either a Text, MText,        ;;
;;  Attribute, or Multileader object and proceed to copy the associated ;;
;;  text content to a selection of any of the aforementioned objects.   ;;
;;                                                                      ;;
;;  The objects to which the text is copied may be selected             ;;
;;  individually or, alternatively, upon selecting the 'Multiple'       ;;
;;  option, the user may make a selection of multiple objects to which  ;;
;;  the text string will be copied.                                     ;;
;;                                                                      ;;
;;  The program also provides functionality to allow the user to        ;;
;;  switch the text content between two objects. Upon calling the       ;;
;;  program with 'stx' at the command line, the user may select two     ;;
;;  objects whose text content will be swapped.                         ;;
;;                                                                      ;;
;;  If the user choose the 'Settings' option when running the           ;;
;;  program, they may alter whether formatting overrides present in     ;;
;;  selected source objects is applied to selected destination objects  ;;
;;  which permit the use of such formatting. If the user opts to        ;;
;;  remove the formatting, the program will remove all formatting       ;;
;;  from the text string prior to copying or swapping it.               ;;
;;                                                                      ;;
;;----------------------------------------------------------------------;;
;;  Author:  Lee Mac, Copyright © 2010  -  www.lee-mac.com              ;;
;;----------------------------------------------------------------------;;
;;  Version 1.0    -    2010-12-16                                      ;;
;;                                                                      ;;
;;  - First release.                                                    ;;
;;----------------------------------------------------------------------;;
;;  Version 1.1    -    2010-12-17                                      ;;
;;                                                                      ;;
;;  - Added ability to retain/remove MText formatting. Setting is       ;;
;;    stored as a global variable (*retain*)                            ;;
;;----------------------------------------------------------------------;;
;;  Version 1.2    -    2010-12-20                                      ;;
;;                                                                      ;;
;;  - Entire program rewritten to include SwapText capability.          ;;
;;----------------------------------------------------------------------;;
;;  Version 1.3    -    2011-01-05                                      ;;
;;                                                                      ;;
;;  - Fixed minor formatting bugs.                                      ;;
;;----------------------------------------------------------------------;;
;;  Version 1.4    -    2015-02-23                                      ;;
;;                                                                      ;;
;;  - Program entirely rewritten.                                       ;;
;;----------------------------------------------------------------------;;

(defun c:ctx nil (copyswaptext nil))
(defun c:stx nil (copyswaptext   t))

;;----------------------------------------------------------------------;;

(defun copyswaptext ( flg / *error* des fun idx mt1 mt2 obj ret rgx src st1 st2 )

    (defun *error* ( msg )
        (if (and (= 'vla-object (type rgx)) (not (vlax-object-released-p rgx)))
            (vlax-release-object rgx)
        )
        (copyswaptext:endundo (copyswaptext:acdoc))
        (if (and msg (not (wcmatch (strcase msg t) "*break,*cancel*,*exit*")))
            (princ (strcat "\nError: " msg))
        )
        (princ)
    )

    (copyswaptext:startundo (copyswaptext:acdoc))
    (if (not (setq copyswaptext:retain (getenv "LMac\\copytext-retain")))
        (setenv "LMac\\copytext-retain" (setq copyswaptext:retain "Yes"))
    )
    (if (setq src (copyswaptext:gettext (if flg "\nSelect text to swap [Settings/Exit]: " "\nSelect source text [Settings/Exit]: ") "Settings Exit"))
        (if (setq rgx (copyswaptext:regex))
            (progn
                (setq mt1 (copyswaptext:allowsformatting (car src))
                      st1 (copyswaptext:unformat rgx (cadr src) mt1)
                )
                (if flg
                    (if (setq des (copyswaptext:gettext "\nAnd text to swap it with [Settings/Exit]: " "Settings Exit"))
                        (progn
                            (setq mt2 (copyswaptext:allowsformatting (car des))
                                  st2 (copyswaptext:unformat rgx (cadr des) mt2)
                                  ret (= "Yes" copyswaptext:retain)
                            )
                            (mapcar 'vla-put-textstring (list (car src) (car des))
                                (cond
                                    (   (and mt1 mt2 ret) (list (cadr des) (cadr src)))
                                    (   (and mt1 mt2)     (list (car  st2) (car  st1)))
                                    (   mt1 (list (car  st2) (cadr st1)))
                                    (   mt2 (list (cadr st2) (car  st1)))
                                    (   ret (list (cadr des) (cadr src)))
                                    (       (list (cadr st2) (cadr st1)))
                                )
                            )
                        )
                    )
                    (progn
                        (setq fun
                            (lambda ( obj mt1 mt2 ret )
                                (cond
                                    (   (and mt1 mt2 ret) (vla-put-textstring obj (cadr src)))
                                    (   (and mt1 mt2)     (vla-put-textstring obj (car  st1)))
                                    (   mt1 (vla-put-textstring obj (cadr st1)))
                                    (   mt2 (vla-put-textstring obj (car  st1)))
                                    (   ret (vla-put-textstring obj (cadr src)))
                                    (       (vla-put-textstring obj (cadr st1)))
                                )
                            )
                        )
                        (while
                            (progn
                                (setq des (copyswaptext:gettext "\nSelect destination text [Multiple/Settings/Exit]: " "Multiple Settings Exit")
                                      ret (= "Yes" copyswaptext:retain)
                                )
                                (cond
                                    (   (null des) nil)
                                    (   (= 'pickset (type des))
                                        (repeat (setq idx (sslength des))
                                            (setq obj (vlax-ename->vla-object (ssname des (setq idx (1- idx)))))
                                            (if (= "AcDbBlockReference" (vla-get-objectname obj))
                                                (foreach att (vlax-invoke obj 'getattributes)
                                                    (fun att mt1 (copyswaptext:allowsformatting att) ret)
                                                )
                                                (fun obj mt1 (copyswaptext:allowsformatting obj) ret)
                                            )
                                        )
                                        nil
                                    )
                                    (   (progn (fun (car des) mt1 (copyswaptext:allowsformatting (car des)) ret) t))
                                )
                            )
                        )
                    )
                )
            )
        )
    )
    (*error* nil)
    (princ)
)

;;----------------------------------------------------------------------;;

(defun copyswaptext:gettext ( msg ini / rtn sel str tmp )
    (while
        (progn
            (setvar 'errno 0)
            (initget ini)
            (setq sel (nentsel (strcat "\nFormatting retained: " copyswaptext:retain msg)))
            (cond
                (   (= 7 (getvar 'errno))
                    (princ "\nMissed, try again.")
                )
                (   (or (null sel) (= "Exit" sel))
                    nil
                )
                (   (= "Settings" sel)
                    (initget "Yes No")
                    (if (setq tmp (getkword (strcat "\nRetain mtext formatting? [Yes/No] <" (getenv "LMac\\copytext-retain") ">: ")))
                        (setenv "LMac\\copytext-retain" (setq copyswaptext:retain tmp))
                    )
                    t
                )
                (   (= "Multiple" sel)
                    (not
                        (setq rtn
                            (copyswaptext:ssget "\nSelect destination text <back>: "
                               '(   "_:L"
                                    (
                                        (-4 . "<OR")
                                            (0 . "TEXT,MTEXT,MULTILEADER")
                                            (-4 . "<AND")
                                                (00 . "INSERT")
                                                (66 . 1)
                                            (-4 . "AND>")
                                        (-4 . "OR>")
                                    )
                                )
                            )
                        )
                    )
                )
                (   (= 4 (logand 4 (cdr (assoc 70 (tblsearch "layer" (cdr (assoc 8 (entget (car sel)))))))))
                    (princ "\nSelected object is on a locked layer.")
                )
                (   (setq tmp (copyswaptext:gettextstring (car sel)))
                    (not (setq rtn (list (vlax-ename->vla-object (car sel)) tmp)))
                )
                (   (princ "\nInvalid object selected."))
            )
        )
    )
    rtn
)

;;----------------------------------------------------------------------;;

(defun copyswaptext:gettextstring ( ent / enx itm str typ )
    (setq enx (entget ent)
          typ (cdr (assoc 0 enx))
    )
    (cond
        (   (wcmatch typ "TEXT,*DIMENSION")
            (cdr (assoc 1 (reverse enx)))
        )
        (   (and (= "MULTILEADER" typ)
                 (= acmtextcontent (cdr (assoc 172 (reverse enx))))
            )
            (cdr (assoc 304 enx))
        )
        (   (wcmatch typ "ATTRIB,MTEXT")
            (setq str (cdr (assoc 1 (reverse enx))))
            (while (setq itm (assoc 3 enx))
                (setq str (strcat (cdr itm) str)
                      enx (cdr (member itm enx))
                )
            )
            str
        )
    )
)

;;----------------------------------------------------------------------;;

(defun copyswaptext:allowsformatting ( obj )
    (or (wcmatch (vla-get-objectname obj) "AcDbMText,AcDbMLeader")
        (and (= "AcDbAttribute" (vla-get-objectname obj))
             (vlax-property-available-p obj 'mtextattribute)
             (= :vlax-true (vla-get-mtextattribute obj))
        )
    )
)

;;----------------------------------------------------------------------;;

(defun copyswaptext:regex ( / rgx )
    (setq rgx (vl-catch-all-apply 'vlax-get-or-create-object '("vbscript.regexp")))
    (if (or (null rgx) (vl-catch-all-error-p rgx))
        (prompt (strcat "\nUnable to interface with RegExp object: " (vl-catch-all-error-message rgx)))
        (progn
            (vlax-put-property rgx 'global     actrue)
            (vlax-put-property rgx 'ignorecase acfalse)
            (vlax-put-property rgx 'multiline  actrue)
            rgx
        )
    )
)

;;----------------------------------------------------------------------;;

(defun copyswaptext:unformat ( rgx str mtx / rtn )
    (if
        (null
            (vl-catch-all-error-p
                (setq rtn
                    (vl-catch-all-apply
                       '(lambda nil
                            (foreach pair
                                (if mtx
                                   '(
                                        ("\032"     . "\\\\\\\\")
                                        (" "        . "\\\\P|\\n|\\t")
                                        ("$1"       . "\\\\(\\\\[ACcFfHKkLlOopQTW])|\\\\[ACcFfHKkLlOopQTW][^\\\\;]*;|\\\\[ACcFfKkHLlOopQTW]")
                                        ("$1$2/$3"  . "([^\\\\])\\\\S([^;]*)[/#\\^]([^;]*);")
                                        ("$1$2"     . "\\\\(\\\\S)|[\\\\](})|}")
                                        ("$1"       . "[\\\\]({)|{")
                                    )
                                   '(
                                        ("\032"     . "\\\\")
                                        (""         . "%%[OoUu]")
                                    )
                                )
                                (vlax-put-property rgx 'pattern (cdr pair))
                                (setq str (vlax-invoke rgx 'replace str (car pair)))
                            )
                            (mapcar
                               '(lambda ( lst / tmp )
                                    (setq tmp str)
                                    (foreach pair lst
                                        (vlax-put-property rgx 'pattern (cdr pair))
                                        (setq tmp (vlax-invoke rgx 'replace tmp (car pair)))
                                    )
                                    tmp
                                )
                               '(
                                    (
                                        ("\\$1$2$3" . "(\\\\[ACcFfHKkLlOoPpQSTW])|({)|(})")
                                        ("\\\\"     . "\032")
                                    )
                                    (
                                        ("\\"       . "\032")
                                    )
                                )
                            )
                        )
                    )
                )
            )
        )
        rtn
    )
)

;;----------------------------------------------------------------------;;

(defun copyswaptext:ssget ( msg arg / sel )
    (princ msg)
    (setvar 'nomutt 1)
    (setq sel (vl-catch-all-apply 'ssget arg))
    (setvar 'nomutt 0)
    (if (not (vl-catch-all-error-p sel)) sel)
)

;;----------------------------------------------------------------------;;

(defun copyswaptext:startundo ( doc )
    (copyswaptext:endundo doc)
    (vla-startundomark doc)
)

;;----------------------------------------------------------------------;;

(defun copyswaptext:endundo ( doc )
    (while (= 8 (logand 8 (getvar 'undoctl)))
        (vla-endundomark doc)
    )
)

;;----------------------------------------------------------------------;;

(defun copyswaptext:acdoc nil
    (eval (list 'defun 'copyswaptext:acdoc 'nil (vla-get-activedocument (vlax-get-acad-object))))
    (copyswaptext:acdoc)
)

;;----------------------------------------------------------------------;;

(vl-load-com)
(princ
    (strcat
        "\n:: CopySwapText.lsp | Version 1.4 | \\U+00A9 Lee Mac "
        (menucmd "m=$(edtime,0,yyyy)")
        " www.lee-mac.com ::"
        "\n:: \"ctx\" to Copy | \"stx\" to Swap ::"
    )
)
(princ)

;;----------------------------------------------------------------------;;
;;                             End of File                              ;;
;;----------------------------------------------------------------------;;