MESSAGE "d" VIEW-AS ALERT-BOX.
    FIND FIRST  b_co_mstr  NO-LOCK WHERE  b_co_code = tmp-lot   NO-ERROR.
    IF NOT AVAILABLE b_co_mstr THEN
    DO:

CREATE b_co_mstr.
ASSIGN b_co_code = tmp-lot
       b_co_part = tmp-part
       b_co_um = ""
       b_co_lot = SUBSTRING(tmp-lot,1,8)
       b_co_status = "FINI-COMP"
       b_co_desc1 = pt_desc1
       b_co_desc2 = pt_desc2
       b_co_qty_ini = qty
       b_co_qty_cur = qty
       b_co_qty_std = qty
       b_co_ser = 0
       b_co_ref = ""
       b_co_format = "".
                                    
     END.
