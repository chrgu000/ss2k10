/*Cai last modified by 05/20/2004*/
/*CJ modified on Oct. 22 2004 *cj*/

UpdBlock:
DO ON ENDKEY UNDO, LEAVE
    ON ERROR UNDO, LEAVE :

    FIND rctkb WHERE RECID(rctkb) = w-rid[FRAME-LINE(f-errs)] NO-ERROR .
    IF NOT AVAILABLE rctkb THEN LEAVE UpdBlock .
    DISPLAY seq11
            kbid
            part
            qty
            rct
         WITH FRAME f-errs .
    
    rct = not rct.

END.

