DEFINE INPUT PARAMETER ref LIKE glt_ref .
DEFINE OUTPUT PARAMETER out_ref LIKE glt_ref .
DEFINE OUTPUT PARAMETER v_error AS LOGICAL .

DEFINE VAR v_ref AS CHAR .
DEFINE VAR i AS INT .


v_ref = SUBSTRING(ref,1,9) .
i   = INT (SUBSTRING(ref,10,5)) .
FIND LAST glt_det WHERE glt_tr_type = "JL" AND SUBSTRING(glt_ref , 1, 9) = v_ref AND (  INT (SUBSTRING(glt_ref,10,5)) ) < i use-index glt_tr_type NO-LOCK NO-ERROR .
IF AVAILABLE glt_det  THEN DO:
    IF (  INT (SUBSTRING(glt_ref,10,5)) )  + 1 <> i   THEN DO:
        v_error = YES .
        out_ref =  v_ref + STRING(   (  INT (SUBSTRING(glt_ref,10,5)) )  + 1, "99999")  .
    END.
END.

/*
v_ref = SUBSTRING(ref,1,8) .   glt_tr_type
i   = INT (SUBSTRING(ref,9,6)) .
FIND LAST glt_det WHERE SUBSTRING(glt_ref , 1, 8) = v_ref AND (  INT (SUBSTRING(glt_ref,9,6)) ) < i  NO-LOCK NO-ERROR .
IF AVAILABLE glt_det  THEN DO:
    IF (  INT (SUBSTRING(glt_ref,9,6)) )  + 1 <> i   THEN DO:
        v_error = YES .
        out_ref =  v_ref + STRING(   (  INT (SUBSTRING(glt_ref,9,6)) )  + 1, "99999")  .
    END.
END.

*/
