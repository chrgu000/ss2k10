/*Cai last modified by 06/14/2004*/
/*last modified by Tracy 11/17/2004 *zx01* */
UpdBlock:
DO ON ENDKEY UNDO, LEAVE
    ON ERROR UNDO, LEAVE :

    FIND xkgpd_det WHERE RECID(xkgpd_det) = w-rid[FRAME-LINE(f-errs)] NO-ERROR .
    IF NOT AVAILABLE xkgpd_det THEN LEAVE UpdBlock .

    UPDATE xkgpd_urgcard /*zx01*/ xkgpd__log01 WITH FRAME f-errs .
    
END.
       
