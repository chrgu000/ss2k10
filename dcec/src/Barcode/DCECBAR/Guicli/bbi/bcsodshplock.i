FIND FIRST b_ex_sod WHERE b_ex_so = {1} AND b_ex_soln = STRING({2}) EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAILABLE b_ex_sod THEN DO:
    CREATE b_ex_sod.
    ASSIGN 
        b_ex_so = {1}
       b_ex_soln = STRING({2}).
       FIND FIRST b_ex_sod WHERE b_ex_so = {1} AND b_ex_soln = STRING({2}) EXCLUSIVE-LOCK NO-ERROR.
END.
