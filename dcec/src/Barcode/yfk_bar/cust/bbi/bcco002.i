FOR EACH t_co_mstr WHERE t_userid = mfguser:
    FIND FIRST b_co_mstr EXCLUSIVE-LOCK WHERE b_co_code = t_co_code.
    ASSIGN b_co_status = {1}
        b_co_site = t_co_site
        b_co_loc = t_co_loc.
 
    RELEASE b_co_mstr.

/*    FIND FIRST b_cot_det  WHERE b_cot_code = t_co_code AND 
        b_cot_status = {1} NO-ERROR.
    IF AVAILABLE b_cot_det THEN DO:
        ASSIGN b_cot_date = TODAY
            b_cot_time = TIME.
    END.
    ELSE DO:
        CREATE b_cot_det.
        ASSIGN b_cot_code = t_co_code
            b_cot_status = {1}
            b_cot_date = TODAY
            b_cot_time = TIME.
    END.

    RELEASE b_cot_det.*/
END.

FOR EACH t_co_mstr WHERE t_userid = mfguser:
    DELETE t_co_mstr.
END.
