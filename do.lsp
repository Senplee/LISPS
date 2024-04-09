;;=======================================================
;  솔리드 뒤로 보내기(2007.07.28 주말농부)
;  ->hatch,trace로 작성된 객체는 뒤로 보내고
;    text,mtext,dimension은 앞으로 보내는 명령어
;;------ draworder --------------------------------------
(defun c:do(/ ss)
   (prompt " 솔리드 뒤로 보내기...")
   (setq ss (ssget "x" '((0 . "HATCH,TRACE"))) )
   (vl-cmdf "draworder" ss "" "b")
   (setq ss (ssget "x" '((0 . "TEXT,MTEXT,DIMENSION"))) )
   (vl-cmdf "draworder" ss "" "f")
   (prompt "\n솔리드을 뒤로 텍스트을 앞으로 보냄.")
(prin1))