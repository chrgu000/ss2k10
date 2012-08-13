FOR EACH t_co_mstr:
    FIND FIRST b_co_mstr EXCLUSIVE-LOCK WHERE b_co_code = t_co_code.
    ASSIGN b_co_lot = {1}.

    RELEASE b_co_mstr.
END.

