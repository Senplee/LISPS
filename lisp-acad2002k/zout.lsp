;; by Joe Burke

;; Please send bug reports to me directly at lowercase@hawaii.rr.com 
;; or post to the SuperFlatten topic at theswamp under "Show your stuff".

;; General notes:

;; Use this program with CAUTION! Yes, it's DANGEROUS!
;; Recommended: make a copy of the original file and run it on
;; the copy. Xref the original to the copy to compare the two.

;; Disclaimer: if the program wrecks your drawing, it ain't my fault.

;; The program is intended to be used with "vanilla" ACAD versions
;; 2000 and later. It has not been tested within vertical applications.
;; Testing with versions prior to 2006 is very limited at this point.
;; It has been tested with 2006 and 2008.

;; The program flattens objects to the WCS plane.
;; It may be run from any view. For instance an isometric view
;; may be useful so you can see what it's doing. Suggested method,
;; choose Top view then choose an isometric view like SouthWest.
;; This is still considered WCS, so the program will not switch 
;; views while the selection set is processed. The selection set
;; is processed before blocks are processed.

;; Some objects may be erased. For instance, a line which when
;; flattened has a length close or equal to zero.

;; Some objects may change type. For instance, an arc which
;; is parallel to Front view is converted to a line. A circle
;; or arc which is not parallel to WCS is converted to an an ellipse.
;; An ellipse with an odd normal is converted to a polyline.

;; Locked layers are temporarily unlocked.

;; A block reference (insert) with an odd normal is exploded and  
;; the resulting objects are flattened. Including any nested blocks.
;; A count of exploded references, if any, is provided at the command line.
;; Attributes in exploded blocks are converted to text.

;; Objects inside block definitions are flattened as needed.
;; A side effect of this is unexpected results may occur when the
;; entire drawing is not flattened. In that case, exploding selected 
;; blocks before running the routine may be helpful.

;; Note, some block references simply cannot be exploded. 
;; AutoCAD may create such blocks while exploding NUS (non uniformly scaled) 
;; nested blocks. These blocks are anonymous and have a name like this *E<number>.
;; I think these are rare so there's no attempt to deal with them.
;; The report at the end will indicate a block reference could not
;; be flattened and how many.

;; -----------------------------------
;; Program options at the command line:
;; > SuperFlatten options [Rename blocks/Explodable blocks/Overkill/Proxies] < >:

;; All options are offered when using 2006 or later and 
;; Express Tools is loaded. Fewer options are offered when using
;; 2005 or ealier and depending on whether ET is loaded or not.

;; The Rename blocks option is always available.
;; > SuperFlatten options [Rename blocks/Explodable blocks/Overkill/Proxies] < >: r
;; > Block name options: [Prefix/Suffix] <S>: p
;; > Block name prefix: flat-
;; Example: there's a block named "BlockA" which contains objects 
;; which need to be flattened. If Rename blocks is chosen, the block
;; name is changed to "flat-BlockA". Note, a block is not renamed
;; if it does not contain object which need to be flattened.

;; If the option isn't used, block definitions are flattened and not renamed.

;; Any renamed blocks are listed at the command line. 
;; Thanks to Steve Doman for his input here.

;; The Proxies option is always available.
;; > SuperFlatten options [Rename blocks/Explodable blocks/Overkill/Proxies] < >: p
;; > Flatten proxy objects? [Yes/No] <N>:
;; If Yes is chosen, proxy objects are flattened.
;; There's a report at the command line regarding how many proxy objects
;; were selected at the first pass through options.

;; The Explodable blocks option is presented when using 2006 or later.
;; > SuperFlatten options [Rename blocks/Explodable blocks/Overkill/Proxies] < >: e
;; > Temporarily set all blocks explodable? [Yes/No] <N>:

;; 2006 introduced the idea a block definition may be set so any reference 
;; to it cannot be exploded. If Yes is chosen, all block defintions are 
;; temporarly set to allow explode. They are reset as needed after the 
;; program ends.

;; The Overkill option is presented when Express Tools is loaded.
;; > SuperFlatten options [Rename blocks/Explodable blocks/Overkill/Proxies] < >: o
;; > Run Overkill after flattening? [Yes/No] <N>:

;; If Yes is chosen Overkill is called. The option is particularly useful 
;; when 3D solids are exploded in order to flatten. Many duplicate objects 
;; may be deleted.
;; -----------------------------------

;; Programming notes:

;; Block definitions are flattened by copying the objects contained
;; in a definition to a temporary layout. This is done to allow use
;; of (command "explode") for objects which cannot be exploded using
;; the ActiveX Explode method. Thanks to Doug Broad for that idea.
;; The original objects in a definition are deleted and the flattened
;; objects are copied back to the definition.

;; When Overkill is called, the function used is (acet-ss-remove-dups...)
;; My testing indicates the function as called is not sensitive to the
;; current Overkill settings. Example, if Ignore Layers is checked in 
;; the Overkill dialog, duplicate objects on different layers are not deleted.
;; IOW, it seems safe in terms of doing the minimum comparison of objects
;; considered equal.

;; Object types supported: AcDbLine AcDbArc AcDbCircle AcDbEllipse
;; AcDbPolyline AcDb2dPolyline AcDb3dPolyline AcDbFace AcDbSpline
;; AcDbPoint AcDbBlockReference AcDbText AcDbMText AcDbAttribute
;; AcDbAttributeDefinition AcDbTable AcDbHatch AcDbSolid AcDbTrace
;; AcDbLeader Dimensions AcDbRay AcDbXline AcDbMline AcDbWipeout
;; AcDbRasterImage AcDbRegion AcDbShape AcDbPolyFaceMesh AcDbPolygonMesh 
;; AcDbMInsertBlock AcDbFcf (tolerance obj) AcDbHelix AcDbZombieEntity
;; AcDb3dSolid and AcDbBody (types which can be exploded) AcDbSurface.

;; "AcDbPlaneSurface" "AcDbFace" (cannot explode already above)
;; "AcDbCamera" "AcDbLight"

;; Normals when objects are drawn in these planes.
;; Top: (0.0 0.0 1.0)
;; Bottom: (0.0 0.0 -1.0)
;; Front: (0.0 -1.0 0.0)
;; Back: (0.0 1.0 0.0)
;; Left (-1.0 0.0 0.0)
;; Right (1.0 0.0 0.0)

;; ----------------------------------------------------------------
;; Version history:

;; Version SuperFlatten 1.0 - 7/23/2007.
;; Changed the program name from ZZero to SuperFlatten. Thanks to 
;; Steve Doman for clearing my head on this issue.  :-)
;; Internalized toolbox functions.

;; Version SuperFlatten 1.0a - 7/24/2007.
;; Added support for AeccDbContour, AeccDbPoint and AcDbZombieEntity
;; object types. The zombie type is a proxy object. Some proxy objects
;; can be exploded using command explode, though I'm not sure which ones.
;; AeccDbContour and AeccDbPoint are two which can. Currently under testing.

;; Version SuperFlatten 1.0b - 7/25/2007.
;; Refined the changes/additions in version 1.0a. Limited testing indicates
;; the program should be able to flatten drawings created in Architectural
;; Desktop. The results will differ depending on what version of ACAD is in
;; use and/or whether an ADT object enabler is installed. 
;; If Properties says an ADT object is a proxy (zombie), the proxy is  
;; exploded and the resulting objects are flattened. The likely result will 
;; be a large file with many duplicate objects. Consider using the Overkill 
;; option, though it may take a long time to finish.
;; If Properties says an ADT object is something like an AEC_WALL (AecDbWall)
;; then the result of exploding the object is an anonymous block. The objects
;; within those block definitions are subsequently flattened. So the result 
;; is likely many anonymous blocks, without a huge increase in the number
;; of primary objects contained in the drawing. The Overkill option won't be
;; much help in this case.

;; Whether the program should deal with ADT proxy objects is open to question.
;; 2008 has the -ExportToAutoCAD command which converts ADT objects to standard
;; ACAD objects. But it does not flatten them as far as I've seen. So if that's
;; what you want, you would have to run SuperFlatten anyway, after 
;; -ExportToAutoCAD. Note, versions prior to 2008, 2006 for instance, also
;; support the -ExportToAutoCAD command when the 2006 ADT object enabler 
;; is installed.

;; IOW, you can flatten an ADT drawing using SuperFlatten alone, without 
;; the intermediate step of using ExportToAutoCAD. Hopefully this allows 
;; someone using ACAD 2002 to flatten an ADT drawing. Not tested under 2002, 
;; but it works as tested under 2006.

;; Other changes:

;; Bug fix at sub-function TwoPointObj.
;; Revised the version checking in program options.

;; Version SuperFlatten 1.0c - 7/26/2007.
;; Revised the FlatEllipse sub-function so the program works with the Autodesk 
;; sample file named 3D House.

;; Version SuperFlatten 1.0d - 7/27/2007.
;; Revised the FlatEllipse, FlatCircle and FlatArc sub-functions so the program 
;; works with the Autodesk sample file named Welding Fixture Model.

;; Version SuperFlatten 1.0e - 7/28/2007.
;; Removed the reverse function at the end of sub-function SSVLAList. 
;; Speed testing with the Hotel Model example file indicates the program is 
;; consistently about 14% faster when the selection set list is not reversed. 
;; 42 seconds vs 49. I'm not sure why. Plus the visual integrity of what 
;; ends up on top of what when objects overlap is more faithful to the 
;; pre-flattened drawing.

;; Version SuperFlatten 1.0f - 8/7/2007.
;; Object selection now occurs before program options.
;; The current options are displayed while the user sets options.
;; The variables *overkillans* (for run Overkill) and 
;; *expans* (allow unexplodable blocks to be exploded)
;; are global now so the Yes/No settings are recalled when the 
;; program is run more than once. The Prefix/Suffix string for
;; the Rename blocks option is not global by design.

;; Version SuperFlatten 1.0g - 8/9/2007.
;; Revised the FlatDimension sub-routine to check for dimension types
;; which have point data associated. For instance, an angular dimension
;; has an ExtLine1StartPoint property.
;; Added sub-function ValidItem. Used to check whether the name of a
;; block may already exist when attempting to rename a block.
;; Added the notrenamedlst variable. It's a list of block names
;; which could not be renamed due to an existing block name conflict.
;; Added a report at the end which lists such block names.
;; Restored reverse list call at the SSVLAList function.
;; Revised the FlatHatch function. Added error checking at the Evaluate
;; call. Also moved it into the "and" condition.

;; Version SuperFlatten 1.0h - 8/10/2007.
;; Revised the FlatHatch function. Added zoom to selection set of
;; recreated boundary objects.

;; Version SuperFlatten 1.1 - 8/16/2007.
;; Commented out the timer functions and calls to those functions.

;; Version SuperFlatten 1.1a - 8/20/2007.
;; Bug fix at FlatSpline sub-function.
;; Revised Text and MText handling in terms of the angle of the object
;; when it has an odd normal. An old set of issues finally solved.

;; Version SuperFlatten 1.1a beta - 8/24/2007.
;; Revised AEC object handling to use Matt's suggestion. All AEC 
;; objects are processed using this (wcmatch objname "Aec*,AEC*").
;; Revised the CommandExplode function so when an AEC object
;; is exploded, the program does not assume only one anonymous
;; block was created as in version 1.1a.
;; Added a check before blocks are processed to ensure all the block 
;; names in blknamelst are still contained in the blocks collection.
;; Remove any which are not to avoid key not found error.

;; Version SuperFlatten 1.2 - 8/27/2007.
;; Removed support for AEC objects because I don't have the vertical
;; apps to test these objects and the -ExportToAutoCAD command does a 
;; better job flattening them anyway. Note, -ExportToAutoCAD does not
;; always flatten the objects it deals with even when the view is Top WCS.
;; SF will flatten any such remaining objects.
;; Added an interface option for proxy (zombie) objects. See program
;; options above.
;; Added SpinBar call while the selection set is evaluated for block 
;; names and proxy objects.
;; Bug fix at the CommandExplode function. Test for a possible empty
;; object to avoid a false report regarding objects not flattened.
;; A proxy object may be empty, contain no objects.
;; Aside regarding proxy objects. While researching the bug I found
;; this comment by Owen Wengerd in a thread dated 2003.
;; "If the proxy objects are marked as unerasable, then you'll need to use a 
;; third party tool such as my SuperPurge utility." I find no other
;; references on the web to an unerasable proxy. This may point to
;; another possible bug?

;; Version SuperFlatten 1.2a - 9/9/2007.
;; Added FlatLeader sub-function. It deals with twitchy leaders which have 
;; a hookline per James Allen's example file. Move the leader rather than
;; change its coordinates if that's sufficient to flatten it.
;; Otherwise pass the leader to the FlatCoordinates sub-function.
;; In that case if it has a hookline the leader will likely change shape.
;; No solution found for that problem.
;; Split former FlatSolidOrTrace function into two separate functions.
;; Added (setvar "pickstyle" 0) so groups will not interfere with 
;; command explode. Variable reset in the error handler.
;; Revised FlatMInsert so one with an odd normal is "exploded" like other 
;; blocks. Thanks to Jason Piercey for his code example.
;; Light objects are deleted now. Camera objects are not. There's a
;; commented out condition within ProcessList which can be restored so
;; camera objects are deleted.
;; Revised the FlatHatch sub-function. If 2006 or later and a hatch object 
;; has an odd normal and the pattern name is AR-CONC, AR-SAND or SOLID, 
;; attempt to flatten by recreating the object. Otherwise explode and flatten 
;; the results. The idea is only random patterns should be recreated. 
;; Others should be exploded in order to maintain visual integrity.
;; Revised the TestZNormal function to handle planar objects like arcs, 
;; circles, polylines etc. Removed the TwoPointObj function.
;; Added support for helix objects. Convert to a flat spline.

;; Version SuperFlatten 1.2b - 9/22/2007.
;; Added FlatMLeader sub-function. Marginal support for multileader objects.
;; Added the GetHatchScale function within FlatHatch. It adjusts the
;; hatch scale of a recreated hatch if the source hatch was created with a 
;; modified version of acad.pat or acadiso.pat.
;; Thanks to James Allen for his input on this topic.
;; Thanks to Marco Alessi for internationalizing command functions.
;; Added the CheckBlock and DeleteBlockProxies functions to delete
;; proxy objects in blocks. Should be a very rare case since the block
;; command does not allow proxies to be included in a block definition.
;; Revised the FlatDimension sub-function.

;; Version SuperFlatten 1.2c - 1/10/2008.
;; Revised the block reference condition in sub-function ProcessList.
;; Added some layer checking to the situation where a block which only
;; contains other blocks is exploded. Not uploaded yet to theswamp.

;; Version SuperFlatten 1.2d - 1/2/2010.
;; Revised the FlatDimension sub-function to move points in a dimension
;; to Z zero. The method used in version 1.2c proved unreliable.

;; Version SuperFlatten 1.2e - 1/12/2010.
;; Revised the FlatDimension sub-function to change associative dimensions
;; to non-associative. Added support for multiline attributes and preservation
;; of symbols in multiline attributes and fields in both attribute types
;; when a block is exploded in order to flatten. Revised the CommandExplode
;; function to preserve symbols and fields in expoded dimensions.
;; Revised the CommandExplode and FlatMLeader functions to allow flattening 
;; of mleader objects. As noted within the FlatMLeader function, the 
;; misbehaving solid object arrow heads are deleted. I will check versions
;; later than 2008 to see if the explode mleader bug has been fixed by
;; Autodesk.

;; Version SuperFlatten 2.0a beta - 2/10/2011.
;; WMFOutIn function added which handles 3DSolid and some other 3D object
;; types using WMF ActiveX methods. Requires ACAD 2005 or later.
;; Earlier ACAD versions use the CommandExplode function as previous versions
;; of SuperFlatten did.
;; Consider using the overkill option when 3DSolid objects are flattened
;; since the WMF process may create duplicate objects on top of each other.
;; Camera and Light object types are deleted.
;; Added support for AcDbPlaneSurface objects.
;; Thanks to Peter B (screen name peterba) at TheSwamp for suggesting the 
;; use of WMF.

;; Version SuperFlatten 2.0b beta - 3/6/2011.
;; Fixed internationalization at five locations.
;; Example: (ssget "p") changed to (ssget "_p").

;; ----------------------------------------------------------------

;; The shortcut is SF

(vl-load-com)

(defun LM:EffectiveName ( blockentity / name repbtag )
 ;;;http://www.theswamp.org/index.php?topic=37493.0
  (if (wcmatch (setq name (cdr (assoc 2 (entget blockentity)))) "`**")
    (if
      (and
        (setq repbtag
          (cdadr
            (assoc -3
              (entget
                (cdr
                  (assoc 330
                    (entget (tblobjname "BLOCK" name))
                  )
                )
               '("AcDbBlockRepBTag")
              )
            )
          )
        )
        (setq repbtag (handent (cdr (assoc 1005 repbtag))))
      )
      (setq name (cdr (assoc 2 (entget repbtag))))
    )
  )
  name
)

(defun c:SuperFlatten ( / *error* acad doc cnt ss expm locklst blocks layouts 
                      views mspace mspacecnt lst blknamelst patlst hpa 
                      templayout blkdef inoutlst actlayout notflatlst 
                      expblklst expblkcnt renameflag newname newnamelst 
                      notrenamedlst optans presufstr templst orig ucsfol 
                      renameans validlst testlst obj objname proxylst 
                      proxyreport pksty slu proxyerror version elevms elevps 
                      sscol WNFflag UCSflag

                      TestNormal TestZNormal ZZeroPoint ZZeroCoord 
                      ProcessList SF:MakeLWPolyline GetBlock PointList 
                      RotateToNormal ApplyProps FlatMText FlatText 
                      FlatPointObj FlatLine FlatACE FlatCircle FlatArc 
                      FlatPline FlatSpline FlatDimension FlatXref FlatShape 
                      FlatHatch FlatSolid FlatTrace FlatRayOrXline 
                      FlatWipeoutOrRaster FlatMline FlatTable FlatTolerance 
                      FlatRegion FlatPolyFaceMesh FlatCoordinates FlatMInsert 
                      AttributesToText ExpBlockMethod CommandExplode 
                      ModBlockScale SF:TraceObject CheckRename PrefixSuffix 
                      Spinbar LstACADPAT UnlockLayers RelockLayers 
                      SSVLAList SSAfterEnt Round GetNestedNames ValidItem 
                      FlatMLeader CheckBlock DeleteBlockProxies SF:GetFields 
                      SF:SymbolString WMFOutIn)

                      ;; Global variables: *expans* *overkillans* *proxyans*

  (defun *error* (msg / i)
    (cond
      ((not msg))
      ((wcmatch (strcase msg) "*QUIT*,*CANCEL*")
        (if blknamelst
          (princ "\n ** CANCELLED - UNDO RECOMMENED ** \n")
        )
      )
      (T (princ (strcat "\nError: " msg)))
    )
    (setvar "cmdecho" 1)
    ;; Restore any unexplodable blocks.
    (foreach x expblklst (vlax-put x 'Explodable acFalse))
    (RelockLayers locklst)
    (if hpa (setvar "hpassoc" hpa))
    (if slu (setvar "showlayerusage" slu))
    (if elevms (vlax-put doc 'ElevationModelSpace elevms))
    (if elevps (vlax-put doc 'ElevationPaperSpace elevps))
    (if expm (setvar "explmode" expm))
    (if pksty (setvar "pickstyle" pksty))
    (if 
      (and
        templayout
        (not (vlax-erased-p templayout))
      )        
      (vla-delete templayout)
    )
    ;; Moved down from above 2/4/2011.
    (if ucsfol (setvar "ucsfollow" ucsfol))
    (if (= 0 (vlax-get doc 'ActiveSpace))
      (vlax-put doc 'ActiveSpace 1)
    )
    (vla-EndUndoMark doc)
    (princ)
  ) ;end error
  
  ;;;;;;; START SuperFlatten SUB-FUNCTIONS ;;;;;;;

  ;|
  (defun StartTimer ()
    (setq *start* (getvar "date")))
  (defun EndTimer (/ end)
    (setq end (* 86400 (- (getvar "date") *start*)))
    (princ (strcat "\nTimer: " (rtos end 2 8) " seconds\n")))
  |;

  ;; Added 1/27/2011. Revised 2/23/2011.
  ;; Argument: vla-object.
  ;; The zoom to object command was added in 2005 which is version 16.1.
  ;; The sub-function calls that zooom command.
  (defun WMFOutIn (obj / doc space tmp tmpwmf blkref space lay clr lt  
                         explst pts newobj UpperLeft ActiveXSS 2DPoints)
    (setq doc (vla-get-activedocument (vlax-get-acad-object))
          space (vlax-get (vla-get-ActiveLayout doc) 'Block)
    )

    ;; Returns the coordinates of the upper left corner of the current
    ;; view as a 3D point. Revised 2/24/2011.
    (defun UpperLeft ( / scrn ang vsiz vcen pt d)
      (setq scrn (getvar "screensize")
            ang (angle (list (car scrn) 0.0 0.0) (list 0.0 (cadr scrn) 0.0))
            vsiz (/ (getvar "viewsize") 2.0)
            vcen (getvar "viewctr")
            ;; View top middle point.
            pt (polar vcen (/ pi 2.0) vsiz)
            d (distance pt vcen)
            ;; Do the triangle math. Get the distance from view center 
            ;; to upper left corner.
            d (/ d (sin (- pi ang)))
      )
      ;; Point at upper left of screen.
      (polar vcen ang d)
    ) ; end UpperLeft

    ;; Argument: vla-object
    ;; Returns: an ActiveX selection set object.
    (defun ActiveXSS (obj / ssobj i)
      (if (setq i (ValidItem sscol "tempss"))
        (vla-delete i)
      )
      (setq ssobj (vlax-invoke sscol 'Add "tempss"))
      (vlax-invoke ssobj 'AddItems (list obj))
      (vla-item sscol "tempss")
    ) ; end ActiveXSS

    ;; Remove every third element from flat list of 3D points.
    (defun 2DPoints (coord / lst)
      (repeat (/ (length coord) 3)
        (setq lst (cons (car coord) lst)
              lst (cons (cadr coord) lst)
              coord (cdddr coord)
        )
      )
      (reverse lst)
    ) ; end 2DPoints

    ;; Added test for model space 2/9/2011. Aviods a non-fatal error message
    ;; at the command line regarding no active model space viewport when
    ;; flattening a block definition in paper space.
    (if (= 1 (vlax-get doc 'ActiveSpace))
      (command "._view" "_orthographic" "_top")
    )
    (if
      (and
        ;; get a temp filename
        (setq tmp (vl-filename-mktemp nil nil nil))
        (setq tmpwmf (strcat tmp ".WMF"))
      )
      (progn
        ;; WMFout
        (setq lay (vlax-get obj 'Layer)
              clr (vlax-get obj 'Color)
              lt (vlax-get obj 'Linetype)
        )
        ;; Requires 2005 or later for the zoom object command.
        (command "._zoom" "_object" (vlax-vla-object->ename obj) "")
        (vla-update obj)
        (vlax-invoke doc 'Export tmp "WMF" (ActiveXSS obj))
        ;; WMFin
        (if (not (vl-catch-all-error-p
          (setq blkref (vl-catch-all-apply 'vlax-invoke 
            (list doc 'Import tmpwmf (UpperLeft) 2.0)))))
          (progn
            (princ "Flattening solid objects, please do not Cancel... ")
            (print)            
            (setq name (vlax-get blkref 'Name))
            (setq explst (vlax-invoke blkref 'Explode))
            (vla-delete blkref)
            (command "._purge" "_blocks" name "_no")
            (foreach x explst 
              ;; Convert heavy plines from WMFin to lines or lightweight plines.
              (setq pts (vlax-get x 'Coordinates))
              (vla-delete x)
              (if
                (or
                  ;; Convert two point object to a line.
                  (= 6 (length pts))
                  ;; Given a three point object and the first and third points
                  ;; are the same, convert to a line.
                  (and
                    (= 9 (length pts))
                    (equal (car pts) (nth 6 pts) 1e-8)
                    (equal (cadr pts) (nth 7 pts) 1e-8)
                  )
                )
                (setq newobj (vlax-invoke space 'AddLine
                  (list (car pts) (cadr pts) 0.0)
                  (list (nth 3 pts) (nth 4 pts) 0.0)
                ))
                ;; Else convert to lwpline.
                (setq newobj (vlax-invoke space 'AddLightWeightPolyline (2DPoints pts)))
              )             
              (vlax-put newobj 'Layer lay)
              (vlax-put newobj 'Color clr)
              (vlax-put newobj 'Linetype lt)
            )
            (vla-delete obj)
            ;; There's a slight speed penalty for doing restore view here within 
            ;; the function. The reason it's here, rather than in the error function,
            ;; is when placed in the error function and the user cancels the routine,
            ;; an error would occur in the error function. I'm not sure why.
            (if 
              (and
                (= 1 (vlax-get doc 'ActiveSpace)) ;; model space
                (tblobjname "view" "SFview")
              )
              (command "._view" "_restore" "SFview")
            )
          )
          ;; else
          (CommandExplode obj)
        )
        (vl-file-delete tmpwmf)
      )
    )
  )  ; end WMFOutIn

  ;; Argument: an ename or vla-object.
  ;; Return T if normal is (0.0 0.0 1.0) or (0.0 0.0 -1.0) within fuzz.
  (defun TestNormal (obj / n)
    (if (= (type obj) 'VLA-object)
      (setq n (vlax-get obj 'Normal))
      (setq n (cdr (assoc 210 (entget obj))))
    )
    (or
      (equal n '(0.0 0.0 1.0) 1e-8)
      (equal n '(0.0 0.0 -1.0) 1e-8)
    )
  ) ;end

  ;; Revised 9/8/2007.
  ;; Example: a circle with a normal like this (0.819152 -0.573576 0.0)
  ;; looks like a line in top view. Convert to a like using the 
  ;; bounding box points.
  (defun TestZNormal (obj / n mn mx newobj)
    (if (= (type obj) 'VLA-object)
      (setq n (vlax-get obj 'Normal))
      (setq n (cdr (assoc 210 (entget obj)))
            obj (vlax-ename->vla-object obj)
      )
    )
    (if (equal 0.0 (caddr n) 1e-8)
      (progn
        (vla-GetBoundingBox obj 'mn 'mx)
        (setq mn (ZZeroPoint (vlax-safearray->list mn))
              mx (ZZeroPoint (vlax-safearray->list mx))
        )
        (cond
          ((or             
             ;; Back (0.0 1.0 0.0) or Right (1.0 0.0 0.0).
             (equal 1.0 (apply '+ n) 1e-8)
             ;; Includes Left (-1.0 0.0 0.0).
             (and
               (minusp (car n))
               (not (minusp (cadr n)))
             )
             ;; Includes Front (0.0 -1.0 0.0).
             (and
               (not (minusp (car n)))
               (minusp (cadr n))
             )
            )
            (setq newobj (vlax-invoke (GetBlock) 'AddLine mn mx))
          )
          ;; Or use the other two corners of the bounding box.
          (T
            (setq newobj 
              (vlax-invoke (GetBlock) 'AddLine 
                (list (car mx) (cadr mn) 0.0)
                (list (car mn) (cadr mx) 0.0)
              )
            )
          )
        )
        (ApplyProps obj newobj)
        ;; Return T to condition calls.
        (setq renameflag T)
      ) ;progn
    ) ;if
  ) ;end

  ;Argument: a single 3D point list.
  (defun ZZeroPoint (lst)
    (list (car lst) (cadr lst) 0.0)
  ) ;end

  ;; Argument: a flat 3D coordinate list.
  ;; (setq l '(414.576 572.128 0.0 494.558 637.135 20.0 562.58 575.117 30.0))
  ;; Returns:
  ;; (414.576 572.128 0.0 494.558 637.135 0.0 562.58 575.117 0.0)
  (defun ZZeroCoord (coord / lst)
    (repeat (/ (length coord) 3)
      (setq lst (cons (car coord) lst)
            lst (cons (cadr coord) lst)
            lst (cons 0.0 lst)
            coord (cdddr coord)
      )
    )
    (reverse lst)
  ) ;end

  (defun GetBlock ()
    (vlax-get (vla-get-ActiveLayout doc) 'Block)
  ) ;end

  ;; Called in the ProcessList sub-function.
  ;; Author unknown.
  (defun Spinbar (sbar) 
    (cond ((= sbar "\\") "|")
          ((= sbar "|") "/")
          ((= sbar "/") "-")
          (t "\\")
    )
  ) ;end

  ;; Arguments: an existing value and a test value.
  ;; The order of the arguments passed doesn't matter.
  ;; It determines whether a block definition should be renamed
  ;; or not by setting the renameflag variable.
  (defun CheckRename (exval testval)
    (if (and renameans presufstr)
      (or 
        (equal exval testval 1e-6)
        (setq renameflag T)
      )
    )
  ) ;end

  ;; Check for item in a collection by Doug Broad.
  (defun ValidItem (collection item / res)
    (vl-catch-all-apply
      '(lambda ()
        (setq res (vla-item collection item))))
    res
  )

  ;; Argument: either "prefix" or "suffix" string.
  ;; Called from program options.
  ;; snvalid returns nil when passed a string with 
  ;; leading or trailing spaces.
  (defun PrefixSuffix (argstr / str StripSpaces)
    ;Remove leading and trailing spaces for snvalid check.
    (defun StripSpaces (str)
      (vl-string-right-trim " " (vl-string-left-trim " " str))
    )

    (setq str (getstring T (strcat "\nBlock name " argstr ": ")))

    (if (eq argstr "prefix")
      (setq str (vl-string-left-trim " " str))
      (setq str (vl-string-right-trim " " str))
    )

    (cond
      ((eq "" str)
        (princ "\nBlocks will not be renamed. ")
      )
      ((not (snvalid (StripSpaces str) 0))
        (while
          (and 
            (not (eq "" str))
            (not 
              (snvalid
                (setq str (StripSpaces (getstring T (strcat "\nInvalid " argstr ": ")))) 0
              )
            )
          )
        )
      )
    )
    (if (not (eq "" str))
      str
    )
  ) ;end

  ;; Entmake a lwpline. 
  ;; Returns a lwpline vla-object if successful.
  (defun SF:MakeLWPolyline (ptlst width)
    (if 
      (and
        (> (length ptlst) 1)
        (apply 'and ptlst)
      )
      (if (entmake
            (append
              (list
                '(0 . "LWPOLYLINE")
                '(100 . "AcDbEntity")
                '(100 . "AcDbPolyline")
                 (cons 90 (length ptlst))
                 (cons 43 width)
              )
              (mapcar '(lambda (x) (cons 10 x)) ptlst)
            )
          )
        (progn
          (setq renameflag T)
          (vlax-ename->vla-object (entlast))
        )
      )
    )
  ) ;end

  ;; Arguments: two vla-objects.
  ;; Apply the properties of the old object to new object 
  ;; and delete the old object. Also set renameflag T.
  (defun ApplyProps (old new)
    (if 
      (and 
        old 
        new
        (not (vlax-erased-p old))
        (not (vlax-erased-p new))
      )
      (progn
        (mapcar '(lambda (x) (vlax-put new x (vlax-get old x)))
          '("Color" "Layer" "Linetype" "LinetypeScale" "Lineweight")
        )
        (vl-catch-all-apply
          '(lambda () 
            (vlax-put new 'LinetypeGeneration (vlax-get old 'LinetypeGeneration))
          )
        )
        (vla-delete old)
        (setq renameflag T)
      )
    )
  ) ;end

  ;; Returns a nested point list from a flat point list.
  (defun PointList (obj / coord lst)
    (setq coord (vlax-get obj 'Coordinates))
    (cond
      ((eq "AcDbPolyline" (vlax-get obj 'ObjectName))
        (repeat (/ (length coord) 2)
          (setq lst (cons (list (car coord) (cadr coord)) lst)
                coord (cddr coord)
          )
        )
      )
      (T
        (repeat (/ (length coord) 3)
          (setq lst (cons (list (car coord) (cadr coord) (caddr coord)) lst)
                coord (cdddr coord)
          )
        )
      )
    )
    (reverse lst)
  ) ;end

  ;; Revised 1/10/2010.
  ;; Convert a list of attribute reference objects to text objects.
  ;; Attributes may be either either text or multiline attribute.
  ;; Returns: a list of text and/or mtext vla-objects.
  ;; Note: the calling function must check the object passed
  ;; is not on a locked layer. Otherwise these functions will
  ;; cause "On locked layer" errors.
  ;; The function does not delete the object passed. The calling
  ;; function must to do that.
  (defun AttributesToText (attlst / n elst str obj res AlignMtext UCSAng)

    ;; Argument: text or attribute, including mutiline, vla-object.
    ;; Returns: the appropriate AttachmentPoint property for an mtext object.
    ;; Based on code by by Lee McDonnell.
    (defun AlignMtext (obj / align)
      (setq align (vlax-get obj 'Alignment))
      (cond 
        ((<= 0 align 2) (1+ align))
        ((<= 3 align 5) 1)
        (T (- align 5))
      )
    ) ;end

    ;; Mtext angle (code 50) is in terms of UCS.
    ;; Text rotation is expressed in WCS.
    ;; Convert angle from WCS to UCS by John Uhden.
    (defun UCSAng (ang)
      (angle
        (trans '(0 0 0) 0 1)
        (trans (polar '(0 0 0) ang 1) 0 1)
      )
    )
    (foreach attobj attlst 
      (setq n (vlax-get attobj 'Normal))
      (setq elst (entget (vlax-vla-object->ename attobj)))
      (setq str (SF:GetFields attobj))
      (if 
        (and
          (vlax-property-available-p attobj 'MTextAttribute)
          (= -1 (vlax-get attobj 'MTextAttribute))
        )
        ;; multiline attribute
        (progn
          (if
            (entmake
              (list
                '(0 . "MTEXT")
                '(100 . "AcDbEntity")
                '(100 . "AcDbMText")
                (cons 1 (vlax-get attobj 'TextString))
                ;(cons 1 str)
                (cons 7 (vlax-get attobj 'StyleName))
                (cons 8 (vlax-get attobj 'Layer))
                ;(cons 10 (vlax-get x 'InsertionPoint))
                (cons 10 (vlax-get attobj 'TextAlignmentPoint))
                ;; this is AttachmnetPoint property
                (cons 71 (AlignMtext attobj))
                (cons 40 (vlax-get attobj 'Height))
                (cons 50 (UCSAng (vlax-get attobj 'Rotation)))
                ;(cons 50 (vlax-get attobj 'Rotation))
                (cons 62 (vlax-get attobj 'Color))
                ;; Added in 2.3 12/10/2009 mtext width
                (cons 41 (vlax-get attobj 'MTextBoundaryWidth))
                ;(cons 210 (vlax-get attobj 'Normal))
                (assoc 410 elst)
              )
            ) ;make
            (progn
              (if (assoc 90 elst)
                (entmod 
                  (append 
                    (entget (entlast))
                    (vl-member-if '(lambda (x) (= 90 (car x))) elst)
                  )
                )
              )
              (setq obj (vlax-ename->vla-object (entlast)))
              (vlax-put obj 'Normal n)
              (setq res (cons (FlatMText obj) res))
            )
          )
        ) ; progn
        ;; standard text attribute
        (progn
          (if
            (entmake
              (list
                '(0 . "TEXT")
                (cons 1 (vlax-get attobj 'TextString))
                (cons 7 (vlax-get attobj 'StyleName))
                (cons 8 (vlax-get attobj 'Layer))
                (cons 10 (vlax-get attobj 'InsertionPoint))
                (cons 11 (vlax-get attobj 'TextAlignmentPoint))
                (cons 40 (vlax-get attobj 'Height))
                (cons 41 (vlax-get attobj 'ScaleFactor))
                (cons 50 (vlax-get attobj 'Rotation))
                (cons 51 (vlax-get attobj 'ObliqueAngle))
                (cons 62 (vlax-get attobj 'Color))
                ;; Added 10/29/2009
                ;(cons 210 (vlax-get attobj 'Normal))
                (cons 67 (cdr (assoc 67 elst)))
                (cons 71 (cdr (assoc 71 elst)))
                (cons 72 (cdr (assoc 72 elst)))
                ;; Revised 10/29/2009
                ;; Vertical text justification type
                ;; DXF code 74 in an attribute and
                ;; code 73 in a text object.
                ;(cons 73 (cdr (assoc 73 elst)))
                (cons 73 (cdr (assoc 74 elst)))
                (assoc 410 elst)
              )
            ) ; make
            (progn
              (setq obj (vlax-ename->vla-object (entlast)))
              (vlax-put obj 'Normal n)
              (if (= 0 (vlax-get obj 'Alignment))
                (vlax-put obj 'InsertionPoint 
                  (vlax-get attobj 'InsertionPoint)
                )
                (vlax-put obj 'TextAlignmentPoint 
                  (vlax-get attobj 'TextAlignmentPoint)
                )
              )
              (setq res (cons (FlatText obj) res))
            )
          )
        )
      )
      ;; Preserve symbols and fields.
      (if (and str obj) (vlax-put obj 'TextString str))
    ) ;foreach
    res
  ) ;end AttributesToText

  ;; Argument: ename or vla-object.
  ;; Object types: mtext, attribute, mleader or dimension.
  ;; Returns: a string with symbols intact.
  (defun SF:SymbolString (obj / e typ str name String blocks)
    ;; A multiline attributue may contain two 1 DXF codes and multiple
    ;; 3 DXF codes. In either case the first code 1 should be ingored
    ;; since it contains a string which is not displayed on screen.
    ;; Apparently this odd condition occurs when text is pasted on top
    ;; of existing text. The old text is stored in the first DXF code 1
    ;; and the text displayed on screen is stored in the second DXF code 1.
    (defun String (ename / str lst)
      (setq str "")
      (setq lst
        (vl-remove-if-not
          '(lambda (x) (or (= 3 (car x)) (= 1 (car x)))) (entget ename)
        )
      )
      (if (and (< 1 (length lst)) (= 1 (caar lst)))
        (setq lst (cdr lst))
      )
      (foreach x lst
        (setq str (strcat str (cdr x)))
      )
    ) ; end String

    (if (= (type obj) 'VLA-OBJECT)
      (setq e (vlax-vla-object->ename obj))
      (progn
        (setq e obj)
        (setq obj (vlax-ename->vla-object obj))
      )
    )
    (setq typ (vlax-get obj 'ObjectName))
    (cond
      ((or
         (eq typ "AcDbMText")
         (eq typ "AcDbAttribute")
        )
        (setq str (String e))
      )
      ((eq typ "AcDbMLeader")
        (setq str (cdr (assoc 304 (entget e))))
      )
      ((and
         (wcmatch typ "*Dimension*")
         (setq name (cdr (assoc 2 (entget e))))
         (wcmatch name "`*D*")
         (setq blocks 
           (vla-get-blocks
             (vla-get-activedocument
               (vlax-get-acad-object)
             )
           )
         )
       )
       (vlax-for x (vla-item blocks name)
         (if (eq "AcDbMText" (vlax-get x 'ObjectName))
           (progn
             (setq str (String (vlax-vla-object->ename x)))
             ;; Preserve symbols. This also updates the string returned
             ;; by the FieldCode method so it contains symbols.
             (vlax-put x 'TextString str)
             ;; Modified version of the standard SymbolString function
             ;; in order to preserve fields when a dimension is exploded
             ;; in order to flatten using the CommandExplode function.
             (setq str (vlax-invoke x 'FieldCode))
           )
         )
       )
     )
    )
    str
  ) ; end SF:SymbolString
  
  ;; Argument: source vla-object.
  ;; Returns: the same string as the FieldCode method, but works with 
  ;; fields in attributes and mleaders. FieldCode does not work with 
  ;; attributes or mleaders. Returns the source text string if no fields 
  ;; found in an attribute or mleader.
  (defun SF:GetFields (obj / srcdict srcdictename srcTEXTdict
                             srcfieldename targdict targdictename
                             fieldelst fielddict dicts actlay
                             tempobj lockflag res)
    
    (cond 
      ;; If the object does not have an extension dictionary or
      ;; the dictionary can be deleted because it is empty.
      ((or
         (= 0 (vlax-get obj 'HasExtensionDictionary))
         (not 
           (vl-catch-all-error-p
             (vl-catch-all-apply 'vlax-invoke
               (list (vlax-invoke obj 'GetExtensionDictionary) 'Delete)
             )
           )
         )
       )
       (setq res (SF:SymbolString obj))
      )
      ;; Source is an attribute or mleader and it contains one or more fields.
      ;; Create a new temporary mtext object. Apply source field dictionaries
      ;; to it. Then get the FieldCode from temp object and erase it.
      ;; For some reason mtext objects in tables do not behave well when
      ;; a dictionary is added. In fact, the updatefield command seems
      ;; to destroy such fields. This method avoids that problem.
      ((and
        (= -1 (vlax-get obj 'HasExtensionDictionary))
        (setq srcdict (vlax-invoke obj 'GetExtensionDictionary))
        (setq srcdictename (vlax-vla-object->ename srcdict))
        (setq srcTEXTdict (dictsearch srcdictename "ACAD_FIELD"))
        (setq srcfieldename (cdr (assoc 360 srcTEXTdict)))
       )
        ;; Check for active layer locked.
        (setq actlay (vlax-get doc 'ActiveLayer))
        (if (= -1 (vlax-get actlay 'Lock))
          (progn
            (vlax-put actlay 'Lock 0)
            (setq lockflag T)
          )
        )
        (setq tempobj (vlax-invoke (GetBlock) 'AddMText '(0.0 0.0 0.0) 0.0 "xx"))
        (setq targdict (vlax-invoke tempobj 'GetExtensionDictionary)
              targdictename (vlax-vla-object->ename targdict)
              fieldelst (entget srcfieldename)
              ;; not sure about the need for these
              fieldelst (vl-remove (assoc 5 fieldelst) fieldelst)
              fieldelst (vl-remove (assoc -1 fieldelst) fieldelst)
              fieldelst (vl-remove (assoc 102 fieldelst) fieldelst)
              fieldelst (vl-remove-if '(lambda (x) (= 330 (car x))) fieldelst)
        )
        (foreach x fieldelst
          (if (= 360 (car x))
            (progn
              (setq dicts (cons (cdr x) dicts))
            )
          )
        )
        ;; remove all 360s from fieldelst
        (setq fieldelst (vl-remove-if '(lambda (x) (= 360 (car x))) fieldelst))  
        (foreach x (reverse dicts)
          (setq fieldelst (append fieldelst (list (cons 360 (entmakex (entget x))))))
        )
        (setq fielddict
          (dictadd targdictename "ACAD_FIELD"
            (entmakex
              '(
                (0 . "DICTIONARY")
                (100 . "AcDbDictionary")
                (280 . 1)
                (281 . 1)
              )
            )
          )
        )
        (dictadd fielddict "TEXT" 
          (entmakex fieldelst)
        )
        (vlax-put tempobj 'TextString (SF:SymbolString tempobj))
        (setq res (vlax-invoke tempobj 'FieldCode))
        (vla-delete tempobj)
        (if lockflag (vlax-put actlay 'Lock -1))
      )
      ;; This really isn't needed given first conditon, but leave it.
      (T (setq res (SF:SymbolString obj)))
    )
    res
  ) ;end SF:GetFields

  ;; Modify the X, Y and Z scale factors of a block
  ;; reference if they are close to equal so the explode
  ;; method can be used.
  ;; Return T if successful, otherwise nil.
  ;; If nil, call CommandExplode.
  ;; Note, the explode method works if a block has for
  ;; instance a negative X scale factor. The block was mirrored.
  ;; I'm not sure this is a complete solution in terms of
  ;; other possible negative values.
  (defun ModBlockScale (blk / xsf ysf zsf)
    (setq xsf (vlax-get blk 'XScaleFactor)
          ysf (vlax-get blk 'YScaleFactor)
          zsf (vlax-get blk 'ZScaleFactor)
    )
    (if
      (and
        (or
          (equal xsf ysf 1e-2)
          (equal (- xsf) ysf 1e-2)
        )
        (equal ysf zsf 1e-2)
      )
      (progn
        (vlax-put blk 'XScaleFactor (Round xsf 1e-2))
        (vlax-put blk 'YScaleFactor (Round ysf 1e-2))
        (vlax-put blk 'ZScaleFactor (Round zsf 1e-2))
        T
      )
    )
  ) ;end

  ;; Explode a block reference using the Explode method.
  ;; If the reference passes the TestNormal test it's not exploded.
  (defun ExpBlockMethod (blkref / ip blkdef flag lay attlst exlst)
;;; (setq blkdef (vla-item blocks (vlax-get blkref 'Name)))  ;_Comment VVA
    (setq blkdef (vla-item blocks (LM:EffectiveName (vlax-vla-object->ename blkref)))) ;_ Add VVA
    (if 
      (or 
        (not (vlax-property-available-p blkdef 'Explodable))
        (eq acTrue (vlax-get blkdef 'Explodable))
      )
      (setq flag T)
    )
    (cond
      ((TestNormal blkref)
        (setq ip (vlax-get blkref 'InsertionPoint))
        (CheckRename ip (ZZeroPoint ip))
        (vlax-put blkref 'InsertionPoint (ZZeroPoint ip))
        (setq attlst (vlax-invoke blkref 'GetAttributes))
        (foreach x attlst (FlatText x))
      )
      ;; Block can be exploded using the explode method and the Explodable property
      ;; is acTrue if that property exists.
      ((and flag (ModBlockScale blkref))    
        (setq lay (vlax-get blkref 'Layer)
              attlst (vlax-invoke blkref 'GetAttributes)
              exlst (vlax-invoke blkref 'Explode)
        )
        (if exlst
          (progn
            (setq renameflag T)
            (setq expblkcnt (1+ expblkcnt))
            (AttributesToText attlst)
            (vla-delete blkref)
            (foreach x exlst
              (if (eq "AcDbAttributeDefinition" (vlax-get x 'ObjectName))
                (vla-delete x)
              )
            )
            (setq exlst (vl-remove-if 'vlax-erased-p exlst))
            (foreach x exlst
              (if (eq "0" (vlax-get x 'Layer))
                (vlax-put x 'Layer lay)
              )
              (if (zerop (vlax-get x 'Color))
                (vlax-put x 'Color 256)
              )
            )
            (ProcessList exlst)
          )
          (progn
            (setq cnt (1+ cnt))
            (if (not (vl-position "AcDbBlockReference" notflatlst))
              (setq notflatlst (cons "AcDbBlockReference" notflatlst))
            )
          )
        )
      )
      ;; Otherwise use command because the block is not uniformly scaled.
      ;; Which the Exlpode method can't handle.
      (T (CommandExplode blkref))
    ) ;cond
  ) ;end

  ;; The types of objects which may be exploded with this function:
  ;; A hatch with an odd normal which can't be recreated because
  ;; the hatch pattern isn't available.
  ;; Dimensions with an odd normal.
  ;; AcDb3dSolid and AcDbBody objects. Some can be exploded, others can't.
  ;; Block references when the ExpBlockMethod function above can't do it 
  ;; because the reference is not uniformly scaled.
  (defun CommandExplode (obj / lay mark objname attlst name exlst)
    (setq mark (entlast)
          objname (vlax-get obj 'ObjectName)
    )
    (cond
      ((or 
         (eq "AcDb3dSolid" objname)
         ;; Body objects cannot be expoded.
         ;; sphere explode twice = body
         ;; Removed 2/7/2011.
         ;; (eq "AcDbBody" objname)
         (eq "AcDbSurface" objname)
         (eq "AcDbHatch" objname)
         (eq "AcDbHelix" objname)
         (eq "AcDbZombieEntity" objname)
         (eq "AcDbPlaneSurface" objname)
        )
        (command "._explode" (vlax-vla-object->ename obj))
        (if (not (eq mark (entlast)))
          (setq exlst (SSVLAList (ssget "_p")))
        )
      )
      ;; Added 1/11/2010.
      ((wcmatch objname "*Dimension*")
        (setq str (SF:SymbolString obj))
        (command "._explode" (vlax-vla-object->ename obj))
        (if 
          (and 
            (not (eq mark (entlast)))
            (setq exlst (SSVLAList (ssget "_p")))
          )
          (foreach x exlst
            (if (eq "AcDbMText" (vlax-get x 'ObjectName))
              (vlax-put x 'TextString str)
            )
          )
        )
      )
      ;; Added 1/12/2010.
      ((eq "AcDbMLeader" objname)
        (command "._explode" (vlax-vla-object->ename obj))
        (if 
          (and 
            (not (eq mark (entlast)))
            (setq exlst (SSVLAList (ssget "_p")))
          )
          (foreach x exlst
            (if (eq "AcDbSolid" (vlax-get x 'ObjectName))
              (progn
                (vla-delete x)
                (setq exlst (vl-remove x exlst))
              )
            )
          )
        )
      )
      ((eq "AcDbBlockReference" objname)
         (setq lay (vlax-get obj 'Layer)
               attlst (vlax-invoke obj 'GetAttributes)
         )
         (command "._explode" (vlax-vla-object->ename obj))
         ;; Had some problems here with blocks which cannot be exploded.
         ;; The following test seems to fix it.
         (if 
           (and 
             (not (eq mark (entlast)))
             (setq exlst (SSVLAList (ssget "_p")))
           )
           (progn
             (setq expblkcnt (1+ expblkcnt))
             (AttributesToText attlst)
             (foreach x exlst
               (if (eq "AcDbAttributeDefinition" (vlax-get x 'ObjectName))
                 (vla-delete x)
               )
             )
             (setq exlst (vl-remove-if 'vlax-erased-p exlst))
             ;If an exlpoded object is on layer 0, put it on the
             ;layer of the exploded object. If its color is byBlock, 
             ;change color to byLayer.
             (foreach x exlst
               (if (eq "0" (vlax-get x 'Layer))
                 (vlax-put x 'Layer lay)
               )
               (if (zerop (vlax-get x 'Color))
                 (vlax-put x 'Color 256)
               )
             )
           )
         )
       )
    ) ;cond    
    (cond
      (exlst
        (setq renameflag T)
        (ProcessList exlst)
      )
      ;; Testing for an empty object, such as a proxy.
      ;; If explode list is nil and the object was erased 
      ;; by command "explode" then it was an empty object.
      ;; So don't count it and don't add it to notflatlst.
      ;; Revised 8/27/2007.
      ((not (vlax-erased-p obj))
        (setq cnt (1+ cnt))
        (if (eq "AcDbZombieEntity" objname)
          (setq objname "DbProxy")
        )
        (if (not (vl-position objname notflatlst))
          (setq notflatlst (cons objname notflatlst))
        )
      )
    )
  ) ;end CommandExplode

  ;; Arguments: vla-object and a normal vector.
  ;; Called from FlatXref and FlatShape.
  ;; The check for the normal Z value approaching 1 or -1 is because
  ;; it seems within that range the display of the object simply
  ;; shows its rotation. There's an example of this in Ken Luk's
  ;; test file from customer files.
  ;; Note, put rotation could be like this.
  ;; (vlax-put obj 'Rotation (+ (* pi 0.5) (atan (cadr n) (car n))))
  (defun RotateToNormal (obj n)
    (if
      (and
        (not (equal 1.0 (caddr n) 1e-5))
        (not (equal -1.0 (caddr n) 1e-5))
      )
      (vlax-put obj 'Rotation 
        (+ (vlax-get obj 'Rotation) (+ (* pi 0.5) (angle '(0 0) n)))
      )
    )
  ) ;end

  ;;; TRACE ;;;
  (defun SF:TraceObject (obj / typlst typ ZZeroList TracePline TraceACE 
                               TraceType1Pline TraceType23Pline)

    ;;;; start trace sub-functions ;;;;

    ;; Argument: 2D or 3D point list.
    ;; Returns: 3D point list with zero Z values.
    (defun ZZeroList (lst)
      (mapcar '(lambda (p) (list (car p) (cadr p) 0.0)) lst)
    )

    ;; Argument: vla-object, a heavy or lightweight pline.
    ;; Returns: WCS point list if successful.
    ;; Notes: Duplicate adjacent points are removed.
    ;; The last closing point is included given a closed pline.
    (defun TracePline (obj / param endparam anginc tparam pt blg 
                             ptlst delta inc arcparam flag)

      (setq param (vlax-curve-getStartParam obj)
            endparam (vlax-curve-getEndParam obj)
            anginc (* pi (/ 7.5 180.0))
      )

      (while (<= param endparam)
        (setq pt (vlax-curve-getPointAtParam obj param))
        ;Avoid duplicate points between start and end.
        (if (not (equal pt (car ptlst) 1e-12))
          (setq ptlst (cons pt ptlst))
        )
        ;A closed pline returns an error (invalid index) 
        ;when asking for the bulge of the end param.
        (if 
          (and 
            (/= param endparam)
            (setq blg (abs (vlax-invoke obj 'GetBulge param)))
            (/= 0 blg)
          )
          (progn
            (setq delta (* 4 (atan blg)) ;included angle
                  inc (/ 1.0 (1+ (fix (/ delta anginc))))
                  arcparam (+ param inc)
            )
            (while (< arcparam (1+ param))
              (setq pt (vlax-curve-getPointAtParam obj arcparam)
                    ptlst (cons pt ptlst)
                    arcparam (+ inc arcparam)
              )
            )
          )
        )
        (setq param (1+ param))
      ) ;while

      (if (> (length ptlst) 1)
        (progn
          (setq ptlst (vl-remove nil ptlst))
          (ZZeroList (reverse ptlst))
        )
      )
    ) ;end

    ;; Argument: vla-object, an arc, circle or ellipse.
    ;; Returns: WCS point list if successful.
    (defun TraceACE (obj / startparam endparam anginc 
                           delta div inc pt ptlst)
      ;start and end angles
      ;circles don't have StartAngle and EndAngle properties.
      (setq startparam (vlax-curve-getStartParam obj)
            endparam (vlax-curve-getEndParam obj)
            ;anginc (* pi (/ 7.5 180.0))
            anginc (* pi (/ 2.5 180.0))
      )

      (if (equal endparam (* pi 2) 1e-6)
        (setq delta endparam)
        ;added abs 6/23/2007, testing
        (setq delta (abs (- endparam startparam)))
      )

      ;Divide delta (included angle) into an equal number of parts.
      (setq div (1+ (fix (/ delta anginc)))
            inc (/ delta div)
      )

      ;Or statement allows the last point on an open ellipse
      ;rather than using (<= startparam endparam) which sometimes
      ;fails to return the last point. Not sure why.
      (while
        (or
          (< startparam endparam)
          (equal startparam endparam 1e-12)
          ;(equal startparam endparam)
        )
        (setq pt (vlax-curve-getPointAtParam obj startparam)
              ptlst (cons pt ptlst)
              startparam (+ inc startparam)
        )
      )
      (ZZeroList (reverse ptlst))
    ) ;end

    ;; Explode curve fit pline and gather point list from arcs.
    ;; This sub-function deletes objects.
    (defun TraceType1Pline (obj / ptlst objlst lst)
      (setq ptlst (list (vlax-curve-getStartPoint obj))
            objlst (vlax-invoke obj 'Explode)
      )
      (foreach x objlst 
        (setq lst (TraceACE x))
        (if (not (equal (car lst) (last ptlst) 1e-8))
          (setq lst (reverse lst))
        )
        (setq ptlst (append ptlst (cdr lst)))
        (vla-delete x)
      )
      (ZZeroList ptlst)
    ) ;end

    ;; Explode quadratic and cubic plines and gather point list from lines.
    ;; Produces an exact trace.
    ;; This sub-function deletes objects.
    (defun TraceType23Pline (obj / objlst ptlst lastpt)
      (setq objlst (vlax-invoke obj 'Explode)
            lastpt (vlax-get (last objlst) 'EndPoint)
      )
      (foreach x objlst
        (setq ptlst (cons (vlax-get x 'StartPoint) ptlst))
        (vla-delete x)
      )
      (ZZeroList (reverse (cons lastpt ptlst)))
    ) ;end
    ;;;; end trace sub-functions ;;;;

    ;;;; primary trace function ;;;;
    (setq typlst '("AcDb2dPolyline" "AcDbPolyline"  
                   "AcDbCircle" "AcDbArc" "AcDbEllipse")
    )
    (or 
      (eq (type obj) 'VLA-OBJECT)
      (setq obj (vlax-ename->vla-object obj))
    )

    (setq typ (vlax-get obj 'ObjectName))

    (if (vl-position typ typlst)
      (cond
         ((or (eq typ "AcDb2dPolyline") (eq typ "AcDbPolyline")) 
            (cond
              ((or
                 (not (vlax-property-available-p obj 'Type))
                 (= 0 (vlax-get obj 'Type))
                )
                (TracePline obj)
              )
              ((or (= 3 (vlax-get obj 'Type)) (= 2 (vlax-get obj 'Type)))
                (TraceType23Pline obj)
              )
              ((= 1 (vlax-get obj 'Type))
                (TraceType1Pline obj)
              )
            )
         )
         ((or (eq typ "AcDbCircle") (eq typ "AcDbArc") (eq typ "AcDbEllipse"))
           (TraceACE obj)
         )
      )
    )
  ) ;end SF:TraceObject
  ;;; TRACE ;;;
  
  ;; Based on code by Luis Esquivel.
  ;; Returns a list of pattern names from acad.pat.
  (defun LstACADPAT ( / file line tmp lst )
    (setq file (open (findfile "acad.pat") "r"))
    (while (setq line (read-line file))
      (setq tmp (cons line tmp))
    )
    (close file)
    (setq tmp (reverse tmp))
    (setq lst (vl-remove-if-not
      '(lambda (string)
        (if (eq (substr string 1 1) "*") string)) tmp))

    (mapcar
      '(lambda (string)
        (substr string 2 (- (vl-string-search "," string) 1))) lst)
  ) ;end

  (defun UnlockLayers (doc / laylst)
    (vlax-for x (vla-get-Layers doc)
      ;filter out xref layers
      (if 
        (and 
          (not (vl-string-search "|" (vlax-get x 'Name)))
          (eq :vlax-true (vla-get-lock x))
        )
        (progn
          (setq laylst (cons x laylst))
          (vla-put-lock x :vlax-false)
        )
      )
    )
    laylst
  ) ;end

  (defun RelockLayers (lst)
    (foreach x lst
      (vl-catch-all-apply 'vla-put-lock (list x :vlax-true))
    )
  ) ;end

  (defun SSVLAList (ss / obj lst i)
    (setq i 0)
    (if ss
      (repeat (sslength ss)
        (setq obj (vlax-ename->vla-object (ssname ss i))
              lst (cons obj lst)
              i (1+ i)
        )
      )
    )
    (reverse lst)
  ) ;end

  ;; Filter out sub-entities and entities not in current space.
  ;; Returns a selection set of primary entities after ename ent
  ;; or nil if ent equals entlast.
  (defun SSAfterEnt (ent / ss entlst)
    (and
      (setq ss (ssadd))
      (while (setq ent (entnext ent))
        (setq entlst (entget ent))
        (if 
          (and
            (not (wcmatch (cdr (assoc 0 entlst)) "ATTRIB,VERTEX,SEQEND"))
            (eq (cdr (assoc 410 entlst)) (getvar "ctab"))
          )
          (ssadd ent ss)
         )
       )
     )
    (if (> (sslength ss) 0) ss)
  ) ;end

  ;; Arguments: a blocks collection and a block name string.
  ;; Returns a list of block names nested in blkname if any.
  (defun GetNestedNames (blkcol blkname / name namelst temp1 temp2)
    ;first nested level

            ;;; (setq name (vlax-get obj 'Name)) ;_Comment VVA
	    (setq name (LM:EffectiveName (vlax-vla-object->ename obj))) ;_ Add VVA
    
    (vlax-for x (vla-item blkcol blkname)
      (if 
        (and
          (= "AcDbBlockReference" (vlax-get x 'ObjectName))
          ;;; (not (vl-position (setq name (vlax-get x 'Name)) namelst)) ;_Comment VVA
	  (not (vl-position (setq name (LM:EffectiveName (vlax-vla-object->ename x))) namelst)) ;_Add VVA
        )
        (setq namelst (cons name namelst))
      )
    )
    ;nested deeper
    (setq temp1 namelst)
    (while temp1
      (foreach x temp1
        (vlax-for x (vla-item blkcol x)
          (if 
            (and
              (= "AcDbBlockReference" (vlax-get x 'ObjectName))
              ;;; (not (vl-position (setq name (vlax-get x 'Name)) namelst))  ;_Comment VVA
	      (not (vl-position (setq name (LM:EffectiveName (vlax-vla-object->ename x))) namelst)) ;_Add VVA
            )
            (setq namelst (cons name namelst)
                  temp2 (cons name temp2)
            )
          )
        )
      )
      (setq temp1 temp2 temp2 nil)
    )
    (reverse namelst)
  ) ;end

  ;; Joe Burke 2/23/03
  (defun Round (value to)
    (if (zerop to) value
      (* (atoi (rtos (/ (float value) to) 2 0)) to)))

  ;; Added 9/22/2007. Check a block definition for an object type.
  ;; Return T if object type found.
  ;; Example: (CheckBlock <blkname> "AcDbZombieEntity")
  (defun CheckBlock (blkname objtyp / flag)
    (setq objtyp (strcase objtyp))
    (vlax-for x (vla-item blocks blkname)
      (if (eq objtyp (strcase (vlax-get x 'ObjectName)))
        (setq flag T)
      )
    )
    flag
  )

  ;; Added 9/22/2007.
  ;; Works in conjunction with the CheckBlock function above.
  ;; Example:
  ;; (if (CheckBlock <blkname> "AcDbZombieEntity") 
  ;;   (DeleteBlockProxies <blkname>)
  ;; )
  ;; The main reason for this function is a proxy object cannot be deleted
  ;; from a block definition using (vla-delete <proxy obj>). An error occurs.
  ;; If the block contains only proxies, delete all references (inserts) 
  ;; including nested and delete the block definition.
  ;; If the block contains proxies and other object types, copy the objects 
  ;; to a temporary block. The proxies are ignored in the process. Then change
  ;; the name of all block references to the temporary block name. Delete the
  ;; original block definition, which deletes the proxy objects. 
  ;; Then change the name of the temporary block back to the original block name.
  (defun DeleteBlockProxies (blkname / blkdef tempname org copylst tempblk)
    (setq blkdef (vla-item blocks blkname))
    (vlax-for x blkdef (setq copylst (cons x copylst)))

                ;;; (setq name (vlax-get obj 'Name)) ;_Comment VVA
	    (setq name (LM:EffectiveName (vlax-vla-object->ename obj))) ;_ Add VVA

    
    ;; This could be if...
    (cond 
      ;; Block only contains proxy objects.
      ((vl-every 
        '(lambda (x) 
          (eq "AcDbZombieEntity" (vlax-get x 'ObjectName))
         )
         copylst
        )
        (vlax-for x blocks
          (if (eq acFalse (vlax-get x 'IsXref))
            (vlax-for i x
              (if 
                (and 
                  (eq "AcDbBlockReference" (vlax-get i 'ObjectName))
                 ;;; (eq (strcase blkname) (strcase (vlax-get i 'Name)))  ;_Comment VVA
		  (eq (strcase blkname) (strcase (LM:EffectiveName (vlax-vla-object->ename i))))  ;_Add VVA
                )
                (vla-delete i)
              )
            )
          )
        )
        (if (vl-catch-all-error-p 
              (vl-catch-all-apply 'vla-delete (list blkdef))
            )
          (setq proxyerror T)
        )
      )
      ;; Block contains proxy objects and other object types.
      (T 
        (if
          (and
            (setq tempname (strcat "%%%" blkname))
            (not (ValidItem blocks tempname))
            (setq org (vlax-get blkdef 'Origin))
            (setq tempblk (vlax-invoke blocks 'Add org tempname))
          )
          (progn
            (vlax-invoke doc 'CopyObjects (reverse copylst) tempblk)
            ;; Should catch all nested blocks.
            (vlax-for x blocks
              (if (eq acFalse (vlax-get x 'IsXref))
                (vlax-for i x
                  (if 
                    (and 
                      (eq "AcDbBlockReference" (vlax-get i 'ObjectName))
                     ;;; (eq (strcase blkname) (strcase (vlax-get i 'Name))) ;_Comment VVA
		      (eq (strcase blkname) (strcase (LM:EffectiveName (vlax-vla-object->ename i))))  ;_Add VVA
                    )
                    (vlax-put i 'Name tempname)
                  )
                )
              )
            )
            (if 
              (not 
                (vl-catch-all-error-p 
                  (vl-catch-all-apply 'vla-delete (list blkdef))
                )
              )
              (vlax-put tempblk 'Name blkname)
              (setq proxyerror T)
            )
          )
        ) ;if
      ) ;cond T
    ) ;cond
  ) ;end

  ;;;;;;;; START FLATTEN SUB-FUNCTIONS ;;;;;;;;;

  (defun FlatPointObj (obj / coord)
    (if (not (TestNormal obj))
      (vlax-put obj 'Normal '(0.0 0.0 1.0))
    )
    (setq coord (vlax-get obj 'Coordinates))
    (CheckRename coord (ZZeroPoint coord))
    (vlax-put obj 'Coordinates (ZZeroPoint coord))
    (CheckRename (vlax-get obj 'Thickness) 0)
    (vlax-put obj 'Thickness 0.0)
  ) ;end

  (defun FlatLine (obj / stpt enpt)
    (if (not (TestNormal obj))
      (progn
        (vlax-put obj 'Normal '(0.0 0.0 1.0))
        (setq renameflag T)
      )
    )
    (setq stpt (vlax-get obj 'StartPoint))
    (CheckRename stpt (ZZeroPoint stpt))
    (vlax-put obj 'StartPoint (ZZeroPoint stpt))
    (setq enpt (vlax-get obj 'EndPoint))
    (CheckRename enpt (ZZeroPoint enpt))
    (vlax-put obj 'EndPoint (ZZeroPoint enpt))
    (CheckRename (vlax-get obj 'Thickness) 0)
    (vlax-put obj 'Thickness 0.0)
    ;; If flattening made the length very short, delete line. 
    (if (equal 0.0 (vlax-get obj 'Length) 1e-6)
      (progn
        (vla-delete obj)
        (setq renameflag T)
      )
    )
  ) ;end

  ;; Revised 8/19/2007.
  (defun FlatMText (obj / ip apt ang ip1 ip2)
    (setq ip (vlax-get obj 'InsertionPoint))
    (CheckRename ip (ZZeroPoint ip))
    (if (TestNormal obj)
      (vlax-put obj 'InsertionPoint (ZZeroPoint ip))
      (progn
        (setq apt (vlax-get obj 'AttachmentPoint))
        (vlax-put obj 'AttachmentPoint 1)
        (setq ip1 (vlax-get obj 'InsertionPoint))
        (vlax-put obj 'AttachmentPoint 2)
        (setq ip2 (vlax-get obj 'InsertionPoint))
        (setq ang (angle ip1 ip2))
        (vlax-put obj 'Normal '(0.0 0.0 1.0))       
        (vlax-put obj 'Rotation ang)
        (vlax-put obj 'AttachmentPoint apt)
        (vlax-put obj 'InsertionPoint (ZZeroPoint ip))
        (setq renameflag T)
      )
    )
  ) ;end

  ;; Revised 8/19/2007.
  (defun FlatText (obj / pt ip ap algn ang)
    (CheckRename (vlax-get obj 'Thickness) 0)
    (vlax-put obj 'Thickness 0.0)
    (if (TestNormal obj)
      (if (= 0 (vlax-get obj 'Alignment))
        (progn
          (setq ip (vlax-get obj 'InsertionPoint))
          (CheckRename ip (ZZeroPoint ip))
          (vlax-put obj 'InsertionPoint (ZZeroPoint ip))
        )
        (progn
          (setq ap (vlax-get obj 'TextAlignmentPoint))
          (CheckRename ap (ZZeroPoint ap))
          (vlax-put obj 'TextAlignmentPoint (ZZeroPoint ap))
        )
      )
      ;; If the text object has an odd normal.
      (progn
        (setq algn (vlax-get obj 'Alignment))
        (if (= 0 algn)
          (setq pt (vlax-get obj 'InsertionPoint))
          (setq pt (vlax-get obj 'TextAlignmentPoint))
        )
        ; Center alignment to get the angle.
        (vlax-put obj 'Alignment 1)
        (setq ang 
          (angle 
            (vlax-get obj 'InsertionPoint)
            (vlax-get obj 'TextAlignmentPoint)
          )
        )
        ; Restore previous alignment.
        (vlax-put obj 'Alignment algn)
        (vlax-put obj 'Normal '(0.0 0.0 1.0))
        (if (= 0 algn)
          (vlax-put obj 'InsertionPoint (ZZeroPoint pt))
          (vlax-put obj 'TextAlignmentPoint (ZZeroPoint pt))
        )
        (vlax-put obj 'Rotation ang)
        (setq renameflag T)
      ) ;progn odd normal
    ) ;if
    ;; Revised to return the result object 9/3/2007.
    obj
  ) ;end

  ;; Convert a circle with odd normal to an ellipse or otherwise.
  (defun FlatCircle (obj / ratio cen pt rad newobj)
    (cond
      ((TestNormal obj)
        (setq cen (vlax-get obj 'Center))
        (CheckRename cen (ZZeroPoint cen))
        (vlax-put obj 'Center (ZZeroPoint cen))
        (CheckRename (vlax-get obj 'Thickness) 0)
        (vlax-put obj 'Thickness 0.0)
      )
      ((TestZNormal obj))
      (T
        (setq ratio (abs (caddr (vlax-get obj 'Normal)))
              cen (ZZeroPoint (vlax-get obj 'Center))
              pt (ZZeroPoint (vlax-curve-getPointAtParam obj 0))
              rad (vlax-get obj 'Radius)
        )
        (cond
          ((equal ratio 0.0 1e-4)
            (FlatACE obj)
          ) 
          ((equal ratio 1.0 1e-4)
            (if (setq newobj (vlax-invoke (GetBlock) 'AddCircle cen rad))
              (ApplyProps obj newobj)
            )
          )
          (T
            (setq newobj (vlax-invoke (GetBlock) 
              'AddEllipse cen (mapcar '- cen pt) (abs ratio))
            )
            (ApplyProps obj newobj)
          )
        )
      )
    )
  ) ;end

  ;; Convert an arc with odd normal to an ellipse or otherwise.
  (defun FlatArc (obj / ratio cen pt stpt enpt pt rad
                        newobj stparam enparam flag)
    (cond
      ((TestNormal obj)
        (setq cen (vlax-get obj 'Center))
        (CheckRename cen (ZZeroPoint cen))
        (vlax-put obj 'Center (ZZeroPoint cen))
        (CheckRename (vlax-get obj 'Thickness) 0)
        (vlax-put obj 'Thickness 0.0)
      )
      ((TestZNormal obj))
      (T
        (setq ratio (caddr (vlax-get obj 'Normal))
              cen (ZZeroPoint (vlax-get obj 'Center))
              stpt (ZZeroPoint (vlax-get obj 'StartPoint))
              enpt (ZZeroPoint (vlax-get obj 'EndPoint))
              rad (vlax-get obj 'Radius)
        )
        (if (minusp ratio)
          (setq ratio (abs ratio) flag T)
        )
        (cond
          ((< ratio 1e-4)
            (FlatACE obj)
          )
          ((equal ratio 1.0 1e-4)
            (if
              ;; Revised 9/14/2007 to remove the "stpt" argument per
              ;; Marco's comment at theswamp.
              (setq newobj (vlax-invoke (GetBlock)
                'AddArc cen rad (angle cen stpt) (angle cen enpt))
              )
              (ApplyProps obj newobj)
            )
          )
          (T
            (vlax-put obj 'StartAngle 0.0)
            (setq pt (ZZeroPoint (vlax-curve-getStartPoint obj)))
            (setq newobj (vlax-invoke (GetBlock)
              'AddEllipse cen (mapcar '- cen pt) ratio)
            )

            ;; This idea from BreakMethod seems to do the trick.
            (setq pt (vlax-curve-getClosestPointTo newobj stpt)
                  stparam (vlax-curve-getParamAtPoint newobj pt)
                  pt (vlax-curve-getClosestPointTo newobj enpt)
                  enparam (vlax-curve-getParamAtPoint newobj pt)
            )
            ;; If the ratio (last value of normal) 
            ;; was negative which param goes where is reversed.
            (if flag
              (progn
                (vlax-put newobj 'StartParameter enparam)
                (vlax-put newobj 'EndParameter stparam)
              )
              (progn
                (vlax-put newobj 'StartParameter stparam)
                (vlax-put newobj 'EndParameter enparam)
              )
            )
            (ApplyProps obj newobj)
          )
        ) ;cond
      ) ;progn
    ) ;if
  ) ;end

  ;; Revised 7/27/2007. An ellipse with an odd normal which fails the 
  ;; first two conditions is traced and converted to a pline.
  ;; This avoids potential "degenerate geometry" errors which are
  ;; not worth the risk invloved trying to preserve an ellipse.
  (defun FlatEllipse (obj / cen) 
    (cond
      ((TestNormal obj)
        (setq cen (vlax-get obj 'Center))
        (CheckRename cen (ZZeroPoint cen))
        (vlax-put obj 'Center (ZZeroPoint cen))
      )
      ((TestZNormal obj))
      (T (FlatACE obj))
    )
  ) ;end

  ;; Revised 7/26/2007. Trace an object when there's
  ;; no other safe way to flatten it.
  (defun FlatACE (obj / ptlst newobj objname)
    (setq ptlst (SF:TraceObject obj))
    (if (setq newobj (SF:MakeLWpolyline ptlst 0.0))
      (ApplyProps obj newobj)
      (progn
        (setq objname (vlax-get obj 'ObjectName)
              cnt (1+ cnt)
        )
        (if (not (vl-position objname notflatlst))
          (setq notflatlst (cons objname notflatlst))
        )
      )
    )
  ) ;end

  ;; Heavy and lightweight plines.
  ;; A heavy pline is converted to lightweight if it is 
  ;; traced using SF:TraceObject.
  (defun FlatPline (obj / width ptlst newobj)
    (cond 
      ((TestNormal obj)
        (CheckRename (vlax-get obj 'Elevation) 0)
        (vlax-put obj 'Elevation 0.0)
        (CheckRename (vlax-get obj 'Thickness) 0)
        (vlax-put obj 'Thickness 0.0)
      )
      ((TestZNormal obj))
      (T   
        ;; If a pline had various widths, the new width is zero.
        ;; Seems nothing can be done about that.
        (if 
          (vl-catch-all-error-p 
            (setq width 
              (vl-catch-all-apply 'vlax-get (list obj 'ConstantWidth))
            )
          )
          (setq width 0.0)
        )
        (setq ptlst (SF:TraceObject obj))
        (if (setq newobj (SF:MakeLWpolyline ptlst width))
          (ApplyProps obj newobj)
        )
      )
    )
  ) ;end

  ;; A PolyFaceMesh object with one face needs to be exploded to a 
  ;; 3D Face before FlatCoordinates below can process it.
  (defun FlatPolyFaceMesh (obj / mark)
    (if (/= 1 (vlax-get obj 'NumberOfFaces))
      (FlatCoordinates obj)
      (progn
        (setq mark (entlast))
        (command "._explode" (vlax-vla-object->ename obj))
        (if (not (eq mark (entlast)))
          (FlatCoordinates (vlax-ename->vla-object (entlast)))
        )
      )
    )
  ) ;end
 
  ;; Added function 9/11/2007. See version history 1.2b.
  (defun FlatMLeader (obj / mn mx n1 n2)
    (vla-GetBoundingBox obj 'mn 'mx)
    (setq n1 (caddr (vlax-safearray->list mn)))
    (setq n2 (caddr (vlax-safearray->list mx)))
    (cond
      ;; Doesn't need to be flattened.
      ((and 
         (equal 0 n1 1e-8)
         (equal 0 n2 1e-8)
       )
      )
      ;; Move if it's parallel to WCS.
      ((equal n1 n2 1e-8)
        (vlax-invoke obj 'Move (list 0.0 0.0 n1) '(0.0 0.0 0.0))
      )

      ;; This is what should happen, but there's a bug in 2008 with SP1
      ;; which causes the leader arrows to go flying off in space.
      ;; Revised 1/12/2010 to allow flattening of mleader objects.
      ;; Note, within the CommandExplode function the misbehaving solid 
      ;; object arrows are deleted. I think that's a better alternative
      ;; than not flattening mleaders as before.
      (T (CommandExplode obj))

      ;(T
      ;  (setq cnt (1+ cnt)
      ;        objname (vlax-get obj 'ObjectName)
      ;  )
      ;  (if (not (vl-position objname notflatlst))
      ;    (setq notflatlst (cons objname notflatlst))
      ;  )
      ;)
    )
  ) ;end FlatMLeader

  ;; ObjectName "AcDbMLeader"
  ;; Argument: an mleader vla-object. Trying to change the coordinates
  ;; does not work for some unknown reason.
  ;(defun FlatMLeader (obj / idx vert)
  ;  (setq idx 0)
  ;  (repeat (vlax-get obj 'LeaderCount)
  ;    (setq vert (vlax-invoke obj 'GetLeaderLineVertices idx))
  ;    (vlax-invoke obj 'SetLeaderLineVertices idx (ZZeroCoord vert))
  ;    (setq idx (1+ idx))
  ;  )
  ;)

  ;; Added function 8/29/2007. See version history 1.2a.
  (defun FlatLeader (obj / coord zlst n)
    (setq coord (vlax-get obj 'Coordinates))
    (repeat (/ (length coord) 3)
      (setq zlst (cons (caddr coord) zlst)
            coord (cdddr coord)
      )
    )
    (setq n (car zlst))
    (cond
      ((vl-every '(lambda (z) (equal 0.0 z 1e-6)) zlst))
      ((vl-every '(lambda (z) (equal n z 1e-6)) (cdr zlst))
        (vlax-invoke obj 'Move (list 0.0 0.0 n) '(0.0 0.0 0.0))
      )
      (T 
        (FlatCoordinates obj)
      )
    )
  ) ;end

  ;; Handles 3DPoly, 3DFace, PolyFaceMesh, PolygonMesh and Leader objects.
  ;; A PolyFaceMesh object may need pre-processing. See the above function.
  ;; Note, it seems changing the coordinates of a leader when not
  ;; in WCS can change its normal. One reason the program flattens in WCS.
  (defun FlatCoordinates (obj / coord objname)
    (setq coord (vlax-get obj 'Coordinates))
    (if 
      (vl-catch-all-error-p
        (vl-catch-all-apply
          '(lambda () (vlax-put obj 'Coordinates (ZZeroCoord coord)))
        )
      )
      (progn
        (setq cnt (1+ cnt)
              objname (vlax-get obj 'ObjectName)
        )
        (if (not (vl-position objname notflatlst))
          (setq notflatlst (cons objname notflatlst))
        )
      )
    )
    (CheckRename (vlax-get obj 'Coordinates) coord)
  ) ;end
  
  ;; The normal of a spline is not exposed under Active X.
  ;; There is no normal if the spline is not planar.
  ;; See the IsPlanar property. So if it is planar and the
  ;; coordinate lists are equal with fuzz, the spline does
  ;; not need to be modified.
  ;; If it is modified the spline should not change shape.
  ;; What will happen is any fit points may be lost.
  ;; Seems OK since fit points are sometimes removed during
  ;; spline edit operations anyway. Or it may not have 
  ;; fit points in the first place.
  (defun FlatSpline (obj / ctrlpts testpts kts)
    (setq ctrlpts (vlax-get obj 'ControlPoints)
          testpts (ZZeroCoord ctrlpts)         
    )
    ;; Revised 8/17/2007 - bug fix.
    (if 
      (or 
        (eq acFalse (vlax-get obj 'IsPlanar))
        (not (equal ctrlpts testpts 1e-8))
      )
      (progn
        (setq kts (vlax-get obj 'Knots))
        (vlax-put obj 'ControlPoints testpts)
        (vlax-put obj 'Knots kts)
        (setq renameflag T)
      )
    )
  ) ;end

  ;|
  ;; Not currently used.
  ;; Argument: the ename of a dimension
  ;; Example given a rotated or aligned dimension
  ;; Returns: 1 if first dimension point is associative
  ;;          2 if second dimension point is associative
  ;;          3 if both points are associative
  ;;          nil if the dimension is not associative
  ;; Note: the value returned is the bitsum of the associativity flag.
  ;; 1 = First point reference
  ;; 2 = Second point reference
  ;; 4 = Third point reference
  ;; 8 = Fourth point reference
  (defun DimAssoc (dim / elst dict)
    (if (= (type dim) 'VLA-OBJECT)
      (setq dim (vlax-vla-object->ename dim))
    )
    (and 
      (setq elst (entget dim))
      (setq dict (cdr (assoc 360 elst))) ;dictionary ename
      (setq elst (entget dict))
      (setq elst (entget (cdr (assoc 360 elst)))) ;DIMASSOC elst
    )
    (cdr (assoc 90 elst))
  ) ;end
  |;

  ;; The explode method doesn't work with dimension objects.
  ;; Spent some time with this one. Explode dims with odd normals
  ;; seems the best approach for now.
  (defun FlatDimension (obj / z pt proplst e elst dxf13 dxf14)
    (if (TestNormal obj)
      (progn
        ;; Added 1/8/2010.
        (command "._dimdisassociate" (vlax-vla-object->ename obj) "")
        (setq z (caddr (vlax-get obj 'TextPosition)))
        (CheckRename z 0)
        (if (not (zerop z))
          (vlax-invoke obj 'Move (list 0.0 0.0 z) '(0.0 0.0 0.0))
        )

        ;; Revised 9/22/2007. Condensed if statements.
        (setq proplst '("ExtLine1Point" "ExtLine2Point" "ExtLine1StartPoint" 
                        "ExtLine2StartPoint" "ExtLine1EndPoint" "ExtLine2EndPoint")
        )
        (foreach p proplst
          (if (vlax-property-available-p obj p)
            (progn
              (setq pt (vlax-get obj p))
              (CheckRename pt (ZZeroPoint pt))
              (vlax-put obj p (ZZeroPoint pt))
            )
          )
        )
        ;; Revised 1/2/2010. Ensure points in the dimension are at Z zero.
        (setq e (vlax-vla-object->ename obj))
        (setq elst (entget e))
        (if (setq dxf13 (assoc 13 elst))
          (progn
            (setq dxf13 (list 13 (cadr dxf13) (caddr dxf13) 0.0))
            (entmod (subst dxf13 (assoc 13 elst) elst))
            (setq elst (entget e))
          )
        )
        (if (setq dxf14 (assoc 14 elst))
          (progn
            (setq dxf14 (list 14 (cadr dxf14) (caddr dxf14) 0.0))
            (entmod (subst dxf14 (assoc 14 elst) elst))
          )
        )
      )
      (CommandExplode obj)
    )
  )

  ;; Change the normal first and then the IP.
  (defun FlatXref (obj / ip nrml)
    (setq ip (vlax-get obj 'InsertionPoint)
          nrml (vlax-get obj 'Normal)
    )
    (if (not (TestNormal obj))
      (progn 
        (vlax-put obj 'Normal '(0.0 0.0 1.0))
        (RotateToNormal obj nrml)
      )
    )
    (vlax-put obj 'InsertionPoint (ZZeroPoint ip))
  ) ;end

  (defun FlatTolerance (obj / ip nrml)
    (setq ip (vlax-get obj 'InsertionPoint)
          nrml (vlax-get obj 'Normal)
    ) 
    (if (not (TestNormal obj))
      (progn
        (vlax-put obj 'Normal '(0.0 0.0 1.0))
        (setq renameflag T)
      )
    )
    (CheckRename ip (ZZeroPoint ip))
    (vlax-put obj 'InsertionPoint (ZZeroPoint ip))
  ) ;end
  
  ;; Revised 9/4/2007. 
  ;; Flatten an minsert with an odd normal based on code by Jason Piercey.
  ;; Such objects are treated the same as a regular block with an odd normal.
  ;; Explode and flatten the results.
  (defun FlatMInsert (obj / ip attlst colcnt rowcnt colspc rowspc collst 
                            rowlst xfac yfac inspt rot bname blknum index 
                            inslst attlst txtlst vlaip newip nrml newblk 
                            newobj blklst)
    (if (TestNormal obj)
      (progn
        (setq ip (vlax-get obj 'InsertionPoint))
        (CheckRename ip (ZZeroPoint ip))
        (vlax-put obj 'InsertionPoint (ZZeroPoint ip))
        (setq attlst (vlax-invoke obj 'GetAttributes))
        (foreach x attlst
          (CheckRename (vlax-get x 'Thickness) 0)
          (vlax-put x 'Thickness 0.0)         
          ;; FlatText checks for rename.
          (FlatText x)
        )
      )
      (progn
        (setq colcnt (vlax-get obj 'Columns)
              rowcnt (vlax-get obj 'Rows)
        )
        (if (or (> colcnt 1) (> rowcnt 1))
          (progn 
            (setq bname (vlax-get obj 'Name) 
                  lay (vlax-get obj 'Layer)
                  xfac (vlax-get obj 'XScaleFactor) 
                  yfac (vlax-get obj 'YScaleFactor) 
                  rot (vlax-get obj 'Rotation) 
                  colspc (vlax-get obj 'ColumnSpacing) 
                  rowspc (vlax-get obj 'RowSpacing)
                  nrml (vlax-get obj 'Normal)
                  blknum (* rowcnt colcnt)
            )
            (if (setq attlst (vlax-invoke obj 'GetAttributes))
              (setq txtlst (AttributesToText attlst))
            )
            ;; The insertion point of an minsert returned by entget is not the 
            ;; same as what properties shows and what this (vlax-get obj 
            ;; 'InsertionPoint) returns when the object has an odd normal.
            ;; But this (inspt) is the point which works. Not sure why.
            (setq inspt (cdr (assoc 10 (entget (vlax-vla-object->ename obj))))
                  vlaip (ZZeroPoint (vlax-get obj 'InsertionPoint))
            )
            (setq index 1)
            (repeat (1- colcnt)
              (setq collst (cons (polar inspt rot (* index colspc)) collst))
              (setq index (1+ index)) 
            )
            (setq collst (cons inspt collst))
            (setq index 1)
            (foreach x collst 
              (progn 
                (repeat (1- rowcnt) 
                  (progn 
                    (setq rowlst (cons (polar x (+ rot (* pi 0.5)) (* index rowspc)) rowlst)) 
                    (setq index (1+ index))
                  ) 
                ) 
                (setq index 1)
              ) 
            ) 
            (foreach x rowlst (setq inslst (cons x inslst)))
            (foreach x collst (setq inslst (cons x inslst)))
            (setq index 0)
            (repeat blknum 
              (entmake (list '(0 . "INSERT") 
                             '(100 . "AcDbEntity") 
                             (cons 8 lay) 
                             '(100 . "AcDbBlockReference") 
                             (cons 2 bname) 
                             (cons 10 (nth index inslst)) 
                             (cons 41 xfac) 
                             (cons 42 yfac) 
                             (cons 50 rot)                    
                             (cons 210 nrml)
                       )
              )
              (setq newblk (vlax-ename->vla-object (entlast))
                    blklst (cons newblk blklst)
                    newip (ZZeroPoint (vlax-get newblk 'InsertionPoint))
              )
              (foreach i txtlst
                (setq newobj (vlax-invoke i 'Copy))
                (vlax-invoke newobj 'Move vlaip newip)
              )
              (setq index (1+ index))
            ) ;repeat
            ;; Delete the minsert object.
            (vla-delete obj)
            ;; Delete the text objects initially created.
            (mapcar 'vla-delete txtlst)
            (setq renameflag T)
            ;; Pass new block objects to ProcessList for flattening.
            ;; New text objects if any are already flat.
            (ProcessList blklst)
          ) ;progn
        ) ;progn
      ) ;if
    ) ;if
  ) ;end

  ;; The explode method doesn't work with hatch objects.
  ;; The patlst var is local in primary function.

  ;; If a hatch has an odd normal and the hatch pattern name is
  ;; AR-CONC or AR-SAND the hatch is recreated to flatten it.
  ;; Otherwise the hatch is exploded and the result is flattened
  ;; in order to maintain visual integrity.

  ;; The HatchObjectType property specifies either a regular
  ;; hatch (zero) or a gradient hatch (one). Gradient hatch
  ;; was new in ACAD 2004. Like a solid hatch, a gradient hatch
  ;; cannot be exploded. If a gradient hatch has an odd normal
  ;; it's converted to a solid hatch to allow flattening.
  ;; The -hatchedit command does not work with a gradient hatch.
  ;; Gradients must be edited using the hatchedit dialog.

  ;; The HatchStyle style property determines Normal, Outer, Ignore.
  ;; The Style of the argument object is applied to the new hatch
  ;; if one is created.

  ;; Fixed a problem here when the hatch spacing of the existing
  ;; hatch is too dense so new hatch (or recreate boundary) fails.
  ;; Due to someone changed a standard hatch pattern definition?

  (defun FlatHatch (obj / rtd patname mark ss sset newobj 
                          mn mx scale GetHatchScale)

    ;radians to degrees
    (defun rtd (radians)
       (/ (* radians 180.0) pi)
    ) ;end

    ;; Added 9/14/2007.
    ;; Argument: hatch vla-object.
    ;; Returns a corrected scale value when a hatch object was created
    ;; using a non-standard hatch definition.
    ;; Note, it only checks the first y offset. A pattern definition may
    ;; contain multiple y offsets.
    (defun GetHatchScale (obj / stdoffsetlst patname elst scl ang 
                                xoff yoff yspacing offset)

      ;; Example ("ANSI31" 0.125 3.175)
      ;; 0.125 - the y offset in acad.pat.
      ;; 3.175 - the y offset in acadiso.pat.
      ;; (* 0.125 25.4) = 3.175.
      ;; Add to this list as needed.
      (setq stdoffsetlst 
        '(("AR-SAND" 1.567 39.8018)
          ("AR-CONC" -5.89789472 -149.807)
          ("ANSI31" 0.125 3.175)
          ("ANSI32" 0.375 9.525)
          ("ANSI33" 0.25 6.35)
          ("ANSI34" 0.75 19.05)
          ("ANSI35" 0.25 6.35)
          ("ANSI36" 0.125 3.175)
          ("ANSI37" 0.125 3.175)
          ("ANSI38" 0.125 3.175))
      )
      (setq patname (vlax-get obj 'PatternName))
      (if (vl-position patname (mapcar 'car stdoffsetlst))
        (progn
          (setq
            scl (vlax-get obj 'PatternScale)
            elst (entget (vlax-vla-object->ename obj))
            ;; Don't use the PatternAngle property here.
            ;; It may not agree with what DXF code 53 returns.
            ang (cdr (assoc 53 elst))
            xoff (cdr (assoc 45 elst))
            yoff (cdr (assoc 46 elst))
            yspacing (/ (- (* yoff (cos ang)) (* xoff (sin ang))) scl)
          )
          (if (zerop (getvar "measurement"))
            (setq offset (car (cdr (assoc patname stdoffsetlst))))
            (setq offset (cadr (cdr (assoc patname stdoffsetlst))))
          )
          (abs (* scl (/ yspacing offset)))
        )
      )
    ) ;end

    (cond 
      ((TestNormal obj)
        (CheckRename (vlax-get obj 'Elevation) 0)
        (vlax-put obj 'Elevation 0.0)
      )
      ((TestZNormal obj))
      ;; Added 7/21/2007.
      ;; A gradient hatch can be changed to a solid.
      ((and
         (vlax-property-available-p obj 'HatchObjectType)
         (= 1 (vlax-get obj 'HatchObjectType))
        )
        (vlax-put obj 'HatchObjectType 0)
        (ProcessList (list obj))
      )     
      ;; Attempting to recreate the boundary and create a new hatch.
      ;; Revised 9/8/2007. Limited to patterns AR-CONC and AR-SAND 
      ;; because they are random. Include SOLID and ANSI patterns.
      ((and
         ;; Recreate boundary introduced at 2006.
         (>= (atof (getvar "AcadVer")) 16.2)
         (or patlst (setq patlst (LstACADPAT)))
         (setq patname (vlax-get obj 'PatternName))
         (vl-position patname patlst)
         (or 
           (if (eq "SOLID" patname) (setq scale 1.0))
           (setq scale (GetHatchScale obj))
         )
         ;; Avoid the hatch boundary associativity removed message.
         (not (vlax-put obj 'AssociativeHatch 0))
         (setq mark (entlast))
         (not (command "._hatchedit" (vlax-vla-object->ename obj) "_b" "_p" "_n"))
         ;; Selection set of the boundary object(s).
         (setq sset (SSAfterEnt mark))
         ;; Added 7/10/2007 to prevent what's likely a rare problem.
         ;; The hatch command includes an object which is not part of the
         ;; selection set when zoomed way out. Seems like an ACAD bug.
         (not (command "._zoom" "_object" sset ""))
         (if hpa (setvar "hpassoc" 0))
         (not (command "._hatch" patname scale
                (rtd (vlax-get obj 'PatternAngle)) "_s" sset ""
              )
         )
         ;; Restore previous zoom.
         (not (command "._zoom" "_previous"))
         ;; Delete boundary objects here rather than later.
         (if sset
           (mapcar 'vla-delete (SSVLAList sset))
         )
         (setq newobj (vlax-ename->vla-object (entlast)))
         (eq "AcDbHatch" (vlax-get newobj 'ObjectName))
         ;; Updates the hatch.
         (not (vl-catch-all-error-p 
           (vl-catch-all-apply 'vlax-invoke 
             (list newobj 'Evaluate))))
       ) ;and
        (vlax-put newobj 'HatchStyle (vlax-get obj 'HatchStyle))
        ;; Should not be needed.
        ;(vlax-put newobj 'AssociativeHatch 0)
        (ApplyProps obj newobj)
      )
      (T (CommandExplode obj))
    ) ;cond
  ) ;end

  ;; AcDbSolid 
  ;; Added 9/1/2007. Split former FlatSolidOrTrace function.
  ;; Though Properties shows an Elevation value for a solid,
  ;; the vla-object does not have an elevation property.
  ;; Get the coord first, then change the normal, then put zzerocoord.
  (defun FlatSolid (obj / coord)
    (CheckRename (vlax-get obj 'Thickness) 0)
    (vlax-put obj 'Thickness 0.0)
    (setq coord (vlax-get obj 'Coordinates))
    (cond
      ((TestNormal obj)
        (CheckRename coord (ZZeroCoord coord))
        (vlax-put obj 'Coordinates (ZZeroCoord coord))
      )
      ((TestZNormal obj))
      (T
        (vlax-put obj 'Normal '(0.0 0.0 1.0))
        (vlax-put obj 'Coordinates (ZZeroCoord coord))
        (setq renameflag T)
      )
    )
  ) ;end
  
  ;; AcDbTrace
  ;; Added 9/1/2007. Split former FlatSolidOrTrace function.             
  (defun FlatTrace (obj / coord)
    (CheckRename (vlax-get obj 'Thickness) 0)
    (vlax-put obj 'Thickness 0.0)
    (setq coord (vlax-get obj 'Coordinates))
    (cond
      ((TestNormal obj)
        (CheckRename coord (ZZeroCoord coord))
        (vlax-put obj 'Coordinates (ZZeroCoord coord))
      )
      (T
        (vlax-put obj 'Normal '(0.0 0.0 1.0))
        (vlax-put obj 'Coordinates (ZZeroCoord coord))
        (setq renameflag T)
      )
    )
  ) ;end

  (defun FlatShape (obj / ip nrml)
    (CheckRename (vlax-get obj 'Thickness) 0)
    (vlax-put obj 'Thickness 0.0)
    (setq ip (vlax-get obj 'InsertionPoint)
          nrml (vlax-get obj 'Normal)
    )
    (if (not (TestNormal obj))
      (progn 
        (vlax-put obj 'Normal '(0.0 0.0 1.0))
        (RotateToNormal obj nrml)
        (setq renameflag T)
      )
    )
    (CheckRename ip (ZZeroPoint ip))
    (vlax-put obj 'InsertionPoint (ZZeroPoint ip))
  ) ;end

  (defun FlatRayOrXline (obj / bp sp dv)
    (setq bp (vlax-get obj 'BasePoint))
    (CheckRename bp (ZZeroPoint bp))
    (vlax-put obj 'BasePoint (ZZeroPoint bp))
    (setq sp (vlax-get obj 'SecondPoint))
    (CheckRename sp (ZZeroPoint sp))
    (vlax-put obj 'SecondPoint (ZZeroPoint sp))
    (setq dv (vlax-get obj 'DirectionVector))
    (CheckRename dv (ZZeroPoint dv))
    (vlax-put obj 'DirectionVector (ZZeroPoint dv))
  ) ;end

  ;; AcDbRasterImage or AcDbWipeout
  ;; Flatten raster (image) objects and wipeouts which are not 
  ;; parallel to WCS. Discovered by accident, changing the rotation 
  ;; property flattens ones which are not parallel to WCS.
  (defun FlatWipeoutOrRaster (obj / org)
    (vlax-put obj 'Rotation (vlax-get obj 'Rotation))
    (setq org (vlax-get obj 'Origin))
    (CheckRename org (ZZeroPoint org))
    (vlax-put obj 'Origin (ZZeroPoint org))
  ) ;end

  ;; Like a Table object the Normal property is not exposed.
  ;; Modify the normal using entmod.
  (defun FlatMline (obj / ename elst mark lst ptlst pts z line)
    (setq ename (vlax-vla-object->ename obj))
    (cond
      ((TestZNormal ename))
      ;; Flatten mline with an odd normal.
      ((not (TestNormal ename))
        (setq elst (entget ename))
        (entmod (subst (cons 210 '(0.0 0.0 1.0)) (assoc 210 elst) elst))
        ;; This is needed to flatten, though not at Z zero. Strange.
        (vlax-put obj 'Coordinates (ZZeroCoord (vlax-get obj 'Coordinates)))
        ;; All the Z values should be the same at this point.
        (setq z (caddr (vlax-get obj 'Coordinates)))
        (if (not (zerop z))
          (vlax-invoke obj 'Move (list 0.0 0.0 z) '(0.0 0.0 0.0))
        )
        (setq renameflag T)
      )
      ;; Flatten to Z zero coordinates. Move because this
      ;; (vlax-put obj 'Coordinates (ZZeroCoord (vlax-get obj 'Coordinates)))
      ;; does not work to change the Z vlaues.
      (T
        (setq z (caddr (vlax-get obj 'Coordinates)))
        (CheckRename z 0)
        (if (not (zerop z))
          (vlax-invoke obj 'Move (list 0.0 0.0 z) '(0.0 0.0 0.0))
        )
      )
    )
  ) ;end

  ;; The Direction property is similar to angle or rotation property.
  ;; The normal isn't exposed under Active X, but is
  ;; available using entget. Use entmod to change it.
  (defun FlatTable (obj / ename elst nrml ip dir)
    (setq ename (vlax-vla-object->ename obj)
          elst (entget ename)
          nrml (cdr (assoc 210 elst))
          ;The original ip for case where the normal is modified.
          ip (vlax-get obj 'InsertionPoint)
          dir (vlax-get obj 'Direction)
    )
    (if 
      (not
        (or
          ;; removed fuzz 6/6/2007
          (equal nrml '(0.0 0.0 1.0))
          (equal nrml '(0.0 0.0 -1.0))
        )
      )
      (progn
        (entmod (subst (cons 210 '(0.0 0.0 1.0)) (assoc 210 elst) elst))
        (setq renameflag T)
      )
    )
    (CheckRename ip (ZZeroPoint ip))
    (vlax-put obj 'InsertionPoint (ZZeroPoint ip))
    (CheckRename dir (ZZeroPoint dir))
    ;; Fix case when direction Z value is like this (0.569751 0.0 0.821818).
    (vlax-put obj 'Direction (ZZeroPoint dir))
    (vlax-invoke obj 'RecomputeTableBlock acTrue)
  ) ;end

  ;; Regions are exploded. Seems there's no other way to deal with them.
  ;; Revised 9/9/2007 - added condition.
  ;; Revised 1/18/2011 with thanks to Peter B at the swap for his bug
  ;; report regarding the fact some regions cannot be exploded.
  ;; That caused an error in version SF 1.2e.
  (defun FlatRegion (obj / lst)
    (cond
      ((TestZNormal obj))
      (T 
       (if
         (not (vl-catch-all-error-p 
           (setq lst (vl-catch-all-apply 'vlax-invoke (list obj 'Explode)))))
          (progn
            (vla-delete obj)
            (setq renameflag T)
            (ProcessList lst)
          )
          ;Else send object to WMFOutIn if 2005 or later.
          (if (>= version 16.2)
            (WMFOutIn obj)
            ;; Else count as not flattened.
            (progn
              (setq cnt (1+ cnt))
              (if (not (vl-position "AcDbRegion" notflatlst))
                (setq notflatlst (cons "AcDbRegion" notflatlst))
              )
            )
          )
        )
      )
    )
  ) ;end

  ;;;;;;;; END FLATTEN SUB-FUNCTIONS ;;;;;;;;;;;;;

  ;; ProcessList
  ;; Argument: a list of vla-objects.
  ;; It's primary function is send vla-objects to other sub-functions
  ;; for processing. All objects pass through this function.
  ;; It handles the progress indicator Spinbar. 
  ;; It also checks for objects passed which may be erased elsewhere.
  ;; And it does some pre-processing to check for very small objects,
  ;; which are deteted.
  
  (defun ProcessList (lst / objname)
    
    ;; Report either block definitions are being 
    ;; flattened or the selection set.
    ;if inoutlst
    (if (or inoutlst WMFflag)
      (princ 
        (strcat "\rFlattening complex objects, please do not Cancel... " 
          (setq *sbar (Spinbar *sbar)) "\t")
      )    
      (princ 
        (strcat "\rFlattening selection... " 
          (setq *sbar (Spinbar *sbar)) "\t")
      )
    )

    (foreach x lst
      (if (not (vlax-erased-p x))
        (progn
          (setq objname (vlax-get x 'ObjectName))
          (cond
            ((eq "AcDbLine" objname)
              (if (< (vlax-get x 'Length) 1e-6)
                (vla-delete x)
                (FlatLine x)
              )
            )
            ((eq "AcDbCircle" objname)
              (if (< (vlax-get x 'Radius) 1e-6)
                (vla-delete x)
                (FlatCircle x)
              )
            )
            ((eq "AcDbArc" objname)
              (if 
                (or
                  (< (vlax-get x 'TotalAngle) 1e-6)
                  (< (vlax-get x 'Radius) 1e-6)
                )
                (vla-delete x)
                (FlatArc x)
              )
            )
            ((eq "AcDbEllipse" objname)
              (if
                (and
                  (< (vlax-get x 'MajorRadius) 1e-6)
                  (< (vlax-get x 'MinorRadius) 1e-6)
                )
                (vla-delete x)
                (FlatEllipse x)
              )
            )
            ((or
                (eq "AcDbPolyline" objname)
                (eq "AcDb2dPolyline" objname)
              )
              (if (< (vlax-curve-getDistAtParam x (vlax-curve-getEndParam x)) 1e-6)
                (vla-delete x)
                (FlatPLine x)
              )
            )
            ((eq "AcDbSpline" objname)
              (if (< (vlax-curve-getEndParam x) 1e-6)
                (vla-delete x)
                (FlatSpline x)
              )
            )
            ;; Added 9/11/2007.
            ((eq "AcDbMLeader" objname) 
              (FlatMLeader x)
            )
            ;; Added 8/29/2007.
            ((eq "AcDbLeader" objname)
              (FlatLeader x)
            )
            ((or
                (eq "AcDb3dPolyline" objname)
                (eq "AcDbFace" objname)
                (eq "AcDbPolygonMesh" objname)
              )
              (FlatCoordinates x)
            )
            ((eq "AcDbPolyFaceMesh" objname)
              (FlatPolyFaceMesh x)
            )
            ((eq "AcDbPoint" objname)
              (FlatPointObj x)
            )
            ((and 
                (eq "AcDbBlockReference" objname)
                (vlax-property-available-p x 'Path)
              )
              (FlatXref x)
            )
            ;; Revised 7/16/2007 - explode a block which only
            ;; contains other blocks. It won't work if the block
            ;; reference is NUS beyond what ModBlockScale does.
                
            ((eq "AcDbBlockReference" objname)
              ;;; (vlax-for y (vla-item blocks (vlax-get x 'Name))  ;_Comment VVA
	     (vlax-for y (vla-item blocks (LM:EffectiveName (vlax-vla-object->ename x))) ;_ Add VVA
                (setq templst (cons y templst))
              )
              (if 
                (and 
                  (vl-every '(lambda (z)
                    (eq "AcDbBlockReference" (vlax-get z 'ObjectName))) 
                      templst)
                  (ModBlockScale x)
                )
                (progn
                  ;; Revised 1/10/2008. Added the layer checking typically
                  ;; done in ExpBlockMethod and CommandExplode.
                  (setq lay (vlax-get x 'Layer))
                  (setq templst (vlax-invoke x 'Explode))
                  (foreach i templst
                    (if (eq "0" (vlax-get i 'Layer))
                      (vlax-put i 'Layer lay)
                    )
                    (if (zerop (vlax-get x 'Color))
                      (vlax-put x 'Color 256)
                    )
                  )
                  (ProcessList templst)
                  (vla-delete x)
                )
                (ExpBlockMethod x)
              ) ;if
              (setq templst nil lay nil)
            )
            ((or
               (eq "AcDbText" objname)
               (eq "AcDbAttribute" objname)
               (eq "AcDbAttributeDefinition" objname)
              )
              (FlatText x)
            )
            ((eq "AcDbMText" objname)
              (FlatMText x)
            )          
            ((eq "AcDbTable" objname)
              (FlatTable x)
            )
            ((eq "AcDbHatch" objname)
              (FlatHatch x)
            )
            ((wcmatch objname "*Dimension*")
              (FlatDimension x)
            )
            ((eq "AcDbRegion" objname)
              (FlatRegion x)
            )
            ;; Keep in mind the 2008 "flatshot" command 
            ;; for flattening 3D solids.
            ((or
               (eq "AcDb3dSolid" objname) 
               (eq "AcDbSurface" objname)
               ;; Added 2/4/2011.
               (eq "AcDbPlaneSurface" objname)
              )
              ;; Added 2/6/2011. Use WMF out in with 2005 or later.
              ;; Otherwise use the CommandExplode function.
              (if (>= version 16.1)
                (WMFOutIn x)
                (CommandExplode x)
              )
            )
            ;; Added 2/7/2011.
            ;; Body objects cannot be exploded.
            ((eq "AcDbBody" objname)
              (if (>= version 16.1)
                (WMFOutIn x)
                (progn
                  (setq cnt (1+ cnt))
                  (if (not (vl-position "AcDbBody" notflatlst))
                    (setq notflatlst (cons "AcDbBody" notflatlst))
                  )
                )
              )
            )
            ((eq "AcDbShape" objname)
              (if (>= version 16.1)
                (WMFOutIn x)
                (CommandExplode x)
              )
            )
            ;; Added 9/1/2007.
            ((eq "AcDbSolid" objname)
              (FlatSolid x)
            )
            ;; Added 9/1/2007.
            ((eq "AcDbTrace" objname)
              (FlatTrace x)
            )
            ((or
               (eq "AcDbRay" objname)
               (eq "AcDbXline" objname)
              )
              (FlatRayOrXline x)
            )
            ;; Cannot be exploded.
            ((eq "AcDbMInsertBlock" objname)
              (FlatMInsert x)
            )
            ((eq "AcDbMline" objname)
              (FlatMline x)
            )
            ((or
               (eq "AcDbWipeout" objname)   
               (eq "AcDbRasterImage" objname)
              )
              (FlatWipeoutOrRaster x)
            )
            ((eq "AcDbFcf" objname)
              (FlatTolerance x)
            )
            ;; Removed support for AEC objects 8/25/2007. 
            ((wcmatch (strcase objname) "AEC*")
              (setq cnt (1+ cnt))
              (if (not (vl-position "DbAecObject" notflatlst))
                (setq notflatlst (cons "DbAecObject" notflatlst))
              )
            )
            ;; Added 9/9/2007. Explodes to a spline.
            ((eq "AcDbHelix" objname)
              (CommandExplode x)
            )
            ;; Added proxy option 8/25/2007.
            ((eq "AcDbZombieEntity" objname)
              (CommandExplode x)
            )
            ;; Revised 2/4/2011. Both object types deleted.
            ((or
               (eq "AcDbLight" objname)
               (eq "AcDbCamera" objname)
               (eq "AcDbSun" objname)
             )
              (vla-delete x)
            )
            ;; Ignore viewports.
            ((eq "AcDbViewport" objname))
            ;; Any object not included above.
            (T 
              (setq cnt (1+ cnt))
              (if (not (vl-position objname notflatlst))
                (setq notflatlst (cons objname notflatlst))
              )
            )
          ) ;cond
        ) ;progn
      ) ;if not erased
    ) ;foreach
  ) ;end ProcessList

  ;;;;;;; END SuperFlatten SUB-FUNCTIONS ;;;;;;;

  ;;;;;;; START PRIMARY ROUTINE ;;;;;;;
  
  ;;;;;;; START BEFORE SELECTION ;;;;;;;

  (setq 
     acad (vlax-get-acad-object)
     doc (vla-get-ActiveDocument acad)
     views (vla-get-Views doc)
  )
  ;; Delete SFview if it exists.
  (if (setq i (ValidItem views "SFview"))
    (vl-catch-all-apply 'vla-delete (list i))
  )
 
  (vla-StartUndoMark doc)

  ;; Ensure model space is active.
  (if (= 0 (vlax-get doc 'ActiveSpace))
    (progn
      (princ "\n SupperFlatten is designed to run in model space. Switching to model. ")
      (vlax-put doc 'ActiveSpace 1)
    )
  )
  
  ;;;;;;; END BEFORE SELECTION ;;;;;;;

  ;;;;;;; GET SELECTION SET ;;;;;;

  (if (setq ss (ssget (list (cons 410 (getvar "ctab")))))
    ;; Long progn...
    (progn
      ;; 2004 or later.
      (if (>= version 16)
        (setq hpa (getvar "hpassoc"))
      )
      ;; 2006 or later. Added 9/14/2007.
      (if (>= version 16.2)
        (progn
          (setq slu (getvar "showlayerusage"))
          (setvar "showlayerusage" 0)
        )
      )
      (setq  
         blocks (vla-get-Blocks doc)
         layouts (vla-get-Layouts doc)
         sscol (vla-get-SelectionSets doc)
         mspace (vla-get-ModelSpace doc)
         mspacecnt (vlax-get mspace 'Count)
         elevms (vlax-get doc 'ElevationModelSpace)
         elevps (vlax-get doc 'ElevationPaperSpace)
         version (atof (getvar "AcadVer"))
         locklst (UnlockLayers doc)
         expm (getvar "explmode")
         ucsfol (getvar "ucsfollow")
         pksty (getvar "pickstyle")
         cnt 0
         expblkcnt 0
      )
      (vlax-put doc 'ElevationModelSpace 0.0)
      (vlax-put doc 'ElevationPaperSpace 0.0)
      (setvar "ucsfollow" 0)
      (setvar "cmdecho" 0)
      (setvar "explmode" 1)
      (setvar "pickstyle" 0)
      ;; UCSflag is used at the end of the routine to restore the previous UCS
      ;; if it was not world originally.
      (if (= 0 (getvar "worlducs"))
        (setq UCSflag T)
      )
      ;; Flattening needs to be done in WCS due to how some
      ;; objects behave while interacting with the code.
      (command "._ucs" "_world")
      ;; Convert the selection set to a list of vla-objects.
      (setq lst (SSVLAList ss))
      ;; Moved the following to this location 8/25/2007.
      ;; Make a list of block names selected including nested names.
      ;; Also test for proxy objects.
      (setq testlst lst)
      (while testlst
        (princ 
          (strcat "\rAnalyzing selection... " 
            (setq *sbar (Spinbar *sbar)))
        )        
        (setq obj (car testlst)
              objname (vlax-get obj 'ObjectName)
        )
        (if 
          (or 
            (eq "AcDb3dSolid" objname) 
            (eq "AcDbBody" objname)
            (eq "AcDbSurface" objname)
            (eq "AcDbPlaneSurface" objname)
          )
          (setq WMFflag T)
        )
        (if 
          (and 
            (eq "AcDbBlockReference" objname)
            (not (vlax-property-available-p obj 'Path))
          )
          (progn
	    
            ;;; (setq name (vlax-get obj 'Name)) ;_Comment VVA
	    (setq name (LM:EffectiveName (vlax-vla-object->ename obj))) ;_ Add VVA
            (if (not (vl-position name blknamelst))
              (setq blknamelst (cons name blknamelst))
            )
            (foreach i (GetNestedNames blocks name)
              (if (not (vl-position i blknamelst))
                (setq blknamelst (cons i blknamelst))
              )
            )
          )
        )
        (if (eq "AcDbZombieEntity" objname)
          (setq proxylst (cons obj proxylst))
        )        
        (setq testlst (cdr testlst))        
      ) ;while
      ;; Added 9/22/2007 to deal with proxy objects within blocks.
      (foreach x blknamelst
        (if (CheckBlock x "AcDbZombieEntity") 
          (DeleteBlockProxies x)
        )
        ;; Added 2/9/2011. Check for these object types in selected blocks.      
        (if (not WMFflag)
          (if 
            (or
              (CheckBlock x "AcDb3dSolid")
              (CheckBlock x "AcDbBody")
              (CheckBlock x "AcDbSurface")
              (CheckBlock x "AcDbPlaneSurface")
            )
            (setq WMFflag T)
          )
        )
      )
      ;; Added here 2/19/2011. SFview is only needed wnen flattening 3D solids 
      ;; and similar object types. If SFview pre-existed, it was deleted above.
      (if WMFflag
        (progn
          (command "._view" "_save" "SFview")
          ;; Visual styles were added in 2007. Two reasons for the following
          ;; command calls. First, set the view style to 2d wireframe.
          ;; Second, in some cases beta testing showed if the view was set to
          ;; 2d wireframe and then the view was saved, the saved wiew was not
          ;; 2d wirefame as expected. Seems like a bug. Whatever, this fixes
          ;; that problem and eliminates the need for the user to set the view
          ;; to 2d wireframe before running the routine. 
          ;; Exmaple file: 2008 Sample folder Visualization - Conference Room.dwg.
          (if (>= version 17)
            (progn
              (command "._view" "_settings" "_visual" "SFview" "2d wireframe"
                       "_background" "SFview" "_none" "" "")
              (command "._view" "_restore" "SFview")
            )
          )
        )
      )     
      (cond
        ((not WMFflag))
        ((and
            WMFflag
           (not (>= version 16.1))
         )
         (princ "\n  Flattening 3D solids using WMF out/in requires 2005 or later. ")
        )
        ((and
           WMFflag
           (>= version 16.1)
         )
         (princ "\n  Flattening 3D solids using WMF out/in. ")
        )
      )

      ;;; ----- START PROGRAM OPTIONS ----- ;;;

      ;; Added program options 7/10/2007.
      ;; Thanks to Steve Doman for his help with the interface.
      ;; Revised for proxy objects 7/25/2007.

      (or *expans* (setq *expans* "No"))
      (or *overkillans* (setq *overkillans* "No"))
      (or *proxyans* (setq *proxyans* "No"))
      
      (setq optans T)
      
      (cond
        ;; pre 2006 and ET is not loaded
        ((and (< version 16.2) (not acet-ss-remove-dups))
          (while optans

            (if presufstr 
              (princ (strcat "\nCurrent options: Rename=" renameans "> " presufstr))
              (princ (strcat "\nCurrent options: Rename=Unspecified"))
            )

            (princ (strcat "  Proxies=" *proxyans*))

            (initget "Rename Proxies")
            (setq optans
              (getkword 
                "\nSuperFlatten options [Rename blocks/Proxies] < >: ")
            )
            (cond 
              ((eq optans "Rename")
                (initget "Prefix Suffix")
                (setq renameans 
                  (getkword "\nBlock name options: [Prefix/Suffix] <S>: ")
                )
                (if (not renameans) (setq renameans "Suffix"))
                (cond
                  ((eq renameans "Prefix")
                    (setq presufstr (PrefixSuffix "prefix"))
                  )
                  ((eq renameans "Suffix")
                    (setq presufstr (PrefixSuffix "suffix"))
                  )
                )
              )
              ((eq optans "Proxies")
                (initget "Yes No")
                (setq *proxyans* 
                  (getkword "\nFlatten proxy objects? [Yes/No] <N>: ")
                )
                (if (not *proxyans*) (setq *proxyans* "No"))
              )
            )
          )
        )

        ;; pre 2006 and ET is loaded
        ((and (< version 16.2) acet-ss-remove-dups)
          (while optans

            (if presufstr 
              (princ (strcat "\nCurrent options: Rename=" renameans "> " presufstr))
              (princ (strcat "\nCurrent options: Rename=Unspecified"))
            )

            (princ (strcat "  Overkill=" *overkillans*
                           "  Proxies=" *proxyans*
                   )
            )
            
            (if (not proxyreport)
              (progn
                (if proxylst 
                  (princ (strcat "\n  " (itoa (length proxylst)) " proxies selected. "))
                  (princ "\n  No proxies selected. ")
                )
                (setq proxyreport T)
              )
            )

            (initget "Rename Overkill Proxies")
            (setq optans
              (getkword 
                "\nSuperFlatten options [Rename blocks/Overkill/Proxies] < >: ")
            )
            (cond 
              ((eq optans "Rename")
                (initget "Prefix Suffix")
                (setq renameans 
                  (getkword "\nBlock name options: [Prefix/Suffix] <S>: ")
                )
                (if (not renameans) (setq renameans "Suffix"))
                (cond
                  ((eq renameans "Prefix")
                    (setq presufstr (PrefixSuffix "prefix"))
                  )
                  ((eq renameans "Suffix")
                    (setq presufstr (PrefixSuffix "suffix"))
                  )
                )
              )
              ((eq optans "Overkill")
                (initget "Yes No")
                (setq *overkillans* 
                  (getkword "\nRun Overkill after flattening? [Yes/No] <N>: ")
                )
                (if (not *overkillans*) (setq *overkillans* "No"))
              )
              ((eq optans "Proxies")
                (initget "Yes No")
                (setq *proxyans* 
                  (getkword "\nFlatten proxy objects? [Yes/No] <N>: ")
                )
                (if (not *proxyans*) (setq *proxyans* "No"))
              )
            )
          )
        )

        ;; 2006 or later and ET is not loaded
        ((and (>= version 16.2) (not acet-ss-remove-dups))
          (while optans
            (if presufstr 
              (princ (strcat "\nCurrent options: Rename=" renameans "> " presufstr))
              (princ (strcat "\nCurrent options: Rename=Unspecified"))
            )            

            (princ (strcat "  Explodable=" *expans*
                           "  Proxies=" *proxyans*
                   )
            )

            (if (not proxyreport)
              (progn
                (if proxylst 
                  (princ (strcat "\n  " (itoa (length proxylst)) " proxies selected. "))
                  (princ "\n  No proxies selected. ")
                )
                (setq proxyreport T)
              )
            )

            (initget "Rename Explodable Proxies")
            (setq optans
              (getkword 
                "\nSuperFlatten options [Rename blocks/Explodable blocks/Proxies] < >: ")
            )
            (cond 
              ((eq optans "Rename")
                (initget "Prefix Suffix")
                (setq renameans 
                  (getkword "\nBlock name options: [Prefix/Suffix] <S>: ")
                )
                (if (not renameans) (setq renameans "Suffix"))
                (cond
                  ((eq renameans "Prefix")
                    (setq presufstr (PrefixSuffix "prefix"))
                  )
                  ((eq renameans "Suffix")
                    (setq presufstr (PrefixSuffix "suffix"))
                  )
                )
              )
              ((eq optans "Explodable")
                (initget "Yes No")
                (setq *expans* 
                  (getkword 
                    "\nTemporarily set all blocks explodable? [Yes/No] <N>: ")
                )
                (if (not *expans*) (setq *expans* "No"))
              )
              ((eq optans "Proxies")
                (initget "Yes No")
                (setq *proxyans* 
                  (getkword "\nFlatten proxy objects? [Yes/No] <N>: ")
                )
                (if (not *proxyans*) (setq *proxyans* "No"))
              )
            )
          )
        )

        ;; 2006 or later and ET is loaded
        ((and (>= version 16.2) acet-ss-remove-dups)
          (while optans            
            (if presufstr 
              (princ (strcat "\nCurrent options: Rename=" renameans "> " presufstr))
              (princ (strcat "\nCurrent options: Rename=Unspecified"))
            )

            (princ (strcat "  Explodable=" *expans*
                           "  Overkill=" *overkillans*
                           "  Proxies=" *proxyans*
                   )
            )
            
            (if (not proxyreport)
              (progn
                (if proxylst 
                  (princ (strcat "\n  " (itoa (length proxylst)) " proxies selected. "))
                  (princ "\n  No proxies selected. ")
                )
                (setq proxyreport T)
              )
            )

            (initget "Rename Explodable Overkill Proxies")
            (setq optans
              (getkword 
                "\nSuperFlatten options [Rename blocks/Explodable blocks/Overkill/Proxies] < >: ")
            )
            (cond 
              ((eq optans "Rename")
                (initget "Prefix Suffix")
                (setq renameans 
                  (getkword "\nBlock name options: [Prefix/Suffix] <S>: ")
                )
                (if (not renameans) (setq renameans "Suffix"))
                (cond
                  ((eq renameans "Prefix")
                    (setq presufstr (PrefixSuffix "prefix"))
                  )
                  ((eq renameans "Suffix")
                    (setq presufstr (PrefixSuffix "suffix"))
                  )
                )
              )
              ((eq optans "Explodable")
                (initget "Yes No")
                (setq *expans* 
                  (getkword 
                    "\nTemporarily set all blocks explodable? [Yes/No] <N>: ")
                )
                (if (not *expans*) (setq *expans* "No"))
              )
              ((eq optans "Overkill")
                (initget "Yes No")
                (setq *overkillans* 
                  (getkword "\nRun Overkill after flattening? [Yes/No] <N>: ")
                )
                (if (not *overkillans*) (setq *overkillans* "No"))
              )
              ((eq optans "Proxies")
                (initget "Yes No")
                (setq *proxyans* 
                  (getkword "\nFlatten proxy objects? [Yes/No] <N>: ")
                )
                (if (not *proxyans*) (setq *proxyans* "No"))
              )
            )
          )
        )
      ) ; end options cond
      
      ;;; ----- END PROGRAM OPTIONS ----- ;;;

      ;(starttimer)
      
      ;; Added 6/25/2007 to deal with the 2006 Explodable blocks option.
      ;; It might be smarter by looking at selected
      ;; blocks and then decide whether anything needs to be done.
      ;; But that seems a bit of overkill since in most cases the
      ;; user will select all. The following seems sufficient.
      (if (eq "Yes" *expans*)
        (vlax-for x blocks 
          (if 
            (and
              (vlax-property-available-p x 'Explodable)
              (eq acFalse (vlax-get x 'Explodable))
            )
            (progn
              (setq expblklst (cons x expblklst))
              (vlax-put x 'Explodable acTrue)
            )
          )
        )
      )
      ;; Remove proxy objects from the selection list if proxyans is No.
      (if (eq "No" *proxyans*)
        (foreach x proxylst
          (setq lst (vl-remove x lst))
        )
      )

      ;; Process the selected objects before flattening block defintions.
      ;; Moved to this location 7/19/2007. It needs to be here rather than
      ;; after flatten definitions so the condition for block references
      ;; in ProcessList does what it should. Explode blocks which only
      ;; contain other blocks.
      (ProcessList lst)

      ;; Added 8/23/2007.
      ;; Check the names in blknamelst are still valid items
      ;; in the blocks collection.
      (foreach x blknamelst
        (if (ValidItem blocks x)
          (setq validlst (cons x validlst))
        )
      )
      (setq blknamelst (reverse validlst))

      ;; Check for for empty blocks.
      ;; Causes an error with copy objects.
      ;; Empty block named "CIRCULAR STAIRS" found in Ken Luk's 
      ;; customer files example file.
      (if blknamelst
        (progn
          ;; Delete the temporary layout if it already exists.
          (vl-catch-all-apply '(lambda () (vla-delete (vla-item layouts "SuperFlatten layout"))))
          (setq actlayout (vlax-get doc 'ActiveLayout)
                templayout (vlax-invoke layouts 'Add  "SuperFlatten layout")
                layoutblk (vlax-get templayout 'Block)
          )
          (vlax-put doc 'ActiveLayout templayout)
          (foreach x blknamelst
            (setq blkdef (vla-item blocks x)
                  inoutlst nil
                  renameflag nil
            )
            ;; added 7/16/2007 - from Steve's large example file:
            ;; a block definition
            ;; Name = "3D-BASE-STREET-TREES"
            ;; Origin = (66965.5 13010.2 -354.0)
            (setq orig (vlax-get blkdef 'Origin))
            (CheckRename orig (ZZeroPoint orig))
            (vlax-put blkdef 'Origin (ZZeroPoint (vlax-get blkdef 'Origin)))
            ;; List objects in source block and filter out viewports.
            (vlax-for i blkdef
              (or
                (eq "AcDbViewport" (vlax-get i 'ObjectName))
                (setq inoutlst (cons i inoutlst))
              )
            )
            (if inoutlst
              (progn
                ;; Copy list to the layout block.
                (setq inoutlst (vlax-invoke doc 'CopyObjects inoutlst layoutblk))

                ;; Empty the source block, except for viewports.
                (vlax-for i blkdef
                  (or
                    (eq "AcDbViewport" (vlax-get i 'ObjectName))
                    (vl-catch-all-apply 'vla-delete (list i))
                  )
                )
                ;; Flatten objects in layout.
                (ProcessList inoutlst)                
                (setq inoutlst nil)
                ;; List the flattened objects, filter out viewports.
                (vlax-for i layoutblk
                  (or
                    (eq "AcDbViewport" (vlax-get i 'ObjectName))
                    (setq inoutlst (cons i inoutlst))
                  )
                )
                ;; Copy the flattened objects in the layout back into
                ;; the block definition and delete objects in the layout.
                (if inoutlst
                  (progn
                    (vlax-invoke doc 'CopyObjects inoutlst blkdef)
                    (mapcar 'vla-delete inoutlst)
                  )
                )
              )
            )
            (if 
              (and 
                ;; Cannot rename anonymous blocks.
                (not (vl-string-search "*" x))
                renameflag 
                renameans
                presufstr
              )
              (cond
                ((and
                   (eq renameans "Prefix")
                   (setq newname (strcat presufstr x))
                  )
                  ;; Added existing block name check 8/9/2007.
                  (if (ValidItem blocks newname)
                    (setq notrenamedlst (cons x notrenamedlst))
                    (progn
                      (vlax-put blkdef 'Name newname)
                      (setq newnamelst (cons newname newnamelst))
                    )
                  )
                )
                ((and
                   (eq renameans "Suffix")
                   (setq newname (strcat x presufstr))
                  )
                  ;; Added existing block name check 8/9/2007.
                  (if (ValidItem blocks newname)
                    (setq notrenamedlst (cons x notrenamedlst))
                    (progn
                      (vlax-put blkdef 'Name newname)
                      (setq newnamelst (cons newname newnamelst))
                    )
                  )
                )
              )
            )
          ) ;foreach
          (vlax-put doc 'ActiveLayout actlayout)
          ;templayout is deleted in the error handler.
        ) ;progn
      ) ;if blknamelst
      (if blknamelst
        (vla-regen doc acActiveViewport)
      )
      (if 
        (and 
          (eq "Yes" *overkillans*)
          (setq ss 
            (cadr 
              (acet-ss-remove-dups 
                (ssget "_x" '((410 . "Model"))) 1e-6 nil)
            )
          )
        )
        (command "._erase" ss "")
      )
      (if (or newnamelst notrenamedlst)
        (textscr)
      )
      (if newnamelst
        (progn
          (princ "\nThe following blocks were renamed: ")
          (foreach x newnamelst
            (print x)
          )
        )
      )
      (if notrenamedlst
        (progn
          (princ "\nThe following blocks were not renamed due to existing block name conflict: ")
          (foreach x notrenamedlst
            (print x)
          )
        )
      )
      (if (> expblkcnt 0)
        (princ (strcat "\nNumber of blocks exploded: " (itoa expblkcnt)))
      )
      (princ 
        (strcat "\nNumber of objects in model space before: " 
          (itoa mspacecnt) " after: " (itoa (vlax-get mspace 'Count)) " \n"
        )
      )
      (if (> cnt 0)
        (progn
          (princ 
            (strcat "\nNumber of objects not processed or flattened: " (itoa cnt) " \n")
          )
          (if notflatlst
            (progn
              (princ "\nObject types not flattened: ")
              (foreach x notflatlst
                (setq pos (+ 3 (vl-string-search "Db" x)))
                (princ (strcat (substr x pos) " "))
              )
              (print)
            )
          )
        )
      )
      (if proxyerror (princ "\nA problem occurred with proxies inside blocks. "))
      (if UCSflag (command "._ucs" "_previous"))
      (if (setq i (ValidItem views "SFview"))
        (vl-catch-all-apply 'vla-delete (list i))
      )
      
      ;(endtimer)
    
    ) ; end long progn
    ;; Else
    (princ "\nNothing selected. ")
  ) ;if
  (*error* nil)

) ;; end SuperFlatten

;;;;;;; END PRIMARY ROUTINE ;;;;;;;;

;shortcut
(defun c:zout () (c:SuperFlatten))