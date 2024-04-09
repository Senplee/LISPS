;; BUB.LSP   Copyright (c) 1992, 1994 Steve Waskow
;; Draws item # bubble, leader, and numbers bubble
;; Example program to illustrate Analyzer features

(defun leader (/ i pt2 drawln)
;draws pline arrowhead and line leader

  (defun drawln ()
  ;draws one or more leader line segments
    (if (> (distance pt pt2) (* 0.1875 dimsc))
      (command ".line" pt pt2 "")
      (setq pt2 pt pt i i (prompt "\nToo short!"))
    )
    ;ask for another line segment
    (if (setq i pt pt pt2
          pt2 (getpoint pt "\nTo point: ")
        )
      (drawln) ;recursively draw next line segment
    )
  )

  (setq dimsc (getvar "dimscale") ;use for scale
    pt  (getpoint "\nPoint of arrowhead: ")
    pt2 (getpoint pt "\nLeader to point: ")
  )
  ;draw proportioned arrowhead
  (command ".pline" pt "W" 0 (* 0.0416 dimsc)
    (setq
      pt (polar pt (angle pt pt2) (* 0.125 dimsc))
    )
    ""
  )
  (drawln) ;draw first line segment
)

(defun bubble ()
;draws bubble centered on last point and item #
  (command ".circle" pt (* 0.1875 dimsc)
    ".trim" (entlast) "" pt ""
    ".text" "M" pt (* 0.125 dimsc) 0 item
  )
)

(defun C:BUB (/ i pt s dimsc)
;auto-incremented item bubble with arrow leader.
;press <enter> at point prompt to place bubble.
  (setq s (itoa (setq item (if item (1+ item) 1))))
  (if (setq i (getint (strcat "\nItem <" s ">: ")))
    (setq item i)
  )
  (leader)
  (bubble)
  (princ) ;exit with no echo
)
