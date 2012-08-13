FIND FIRST b_ex_ld WHERE b_ex_site = {1} AND b_ex_loc = {2} AND b_ex_part = {3} EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAILABLE b_ex_ld THEN DO:
    CREATE b_ex_ld.
    ASSIGN 
        b_ex_site = {1}
       b_ex_loc = {2}
        b_ex_part = {3}.
       FIND FIRST b_ex_ld WHERE b_ex_site = {1} AND b_ex_loc = {2} AND b_ex_part = {3} EXCLUSIVE-LOCK NO-ERROR.
END.
