OUTPUT TO c:\SO20680.
FOR EACH tr_hist  WHERE tr_lot = "2654182"  NO-LOCK:
    DISP  tr_trnbr  tr_part  tr_type tr_qty_loc  tr_loc  tr_effdate  tr_date  tr_userid tr_program WITH WIDTH 180.
END.
