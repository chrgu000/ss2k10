FIND FIRST sod_det WHERE sod_nbr = {1} AND sod_part = b_co_part AND sod_site = b_co_site AND (sod_qty_ord - sod_qty_ship) * (IF sod_um_conv <> 0 THEN sod_um_conv ELSE 1) >= b_co_qty_cur NO-LOCK NO-ERROR.

IF AVAILABLE sod_det THEN DO:
mline = STRING(sod_line).
FIND FIRST b_ex_sod WHERE b_ex_so = {1} AND b_ex_soln = STRING(sod_line) EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAILABLE b_ex_sod THEN DO:
    CREATE b_ex_sod.
    ASSIGN 
        b_ex_so = {1}
       b_ex_soln = STRING(sod_line).
       FIND FIRST b_ex_sod WHERE b_ex_so = {1} AND b_ex_soln = STRING(sod_line) EXCLUSIVE-LOCK NO-ERROR.
END.

END.
