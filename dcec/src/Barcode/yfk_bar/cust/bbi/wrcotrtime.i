/*FIND FIRST b_cot_det  /*EXCLUSIVE-LOCK*/  WHERE b_cot_code = {1} AND 
        b_cot_status = {2} NO-ERROR.
    IF AVAILABLE b_cot_det THEN DO:
        ASSIGN b_cot_date = TODAY
            b_cot_time = TIME.
    END.
    ELSE DO:
        CREATE b_cot_det.
        ASSIGN b_cot_code = {1}
            b_cot_status = {2}
            b_cot_date = TODAY
            b_cot_time = TIME.
    END.

    RELEASE b_cot_det.*/
    
