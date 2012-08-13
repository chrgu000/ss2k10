FIND FIRST b_ex_sod WHERE b_ex_so = bc_so_nbr AND b_ex_soln = bc_so_line EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAILABLE b_ex_sod THEN DO:
    CREATE b_ex_sod.
    ASSIGN 
        b_ex_so = bc_so_nbr
       b_ex_soln = bc_so_line.
       FIND FIRST b_ex_sod WHERE b_ex_so = bc_so_nbr AND b_ex_soln = bc_so_line EXCLUSIVE-LOCK NO-ERROR.
END.
