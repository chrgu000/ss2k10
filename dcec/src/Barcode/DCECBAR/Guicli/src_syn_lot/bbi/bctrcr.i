
CREATE b_tr_hist.
b_tr_trnbr = NEXT-VALUE(b_tr_sq01) .
b_tr_nbr = {&ord}.
b_tr_line = INTEGER({&mline}).
b_tr_part = {&b_part}.
b_tr_serial = {&b_lot}.
b_tr_lot = {&id}.
b_tr_qty_req = {&b_qty_req}.
b_tr_qty_loc = {&b_qty_loc}.
b_tr_qty_chg = {&b_qty_chg}.
b_tr_um = {&b_um}.
b_tr_date = {&mdate1}.
b_tr_effdate = {&mdate_eff}.
b_tr_type = {&b_typ}.
b_tr_time = {&mtime}.
b_tr_loc = {&b_loc}.
b_tr_site = {&b_site}.
b_tr_userid = {&b_usrid}.
b_tr_ref = {&b_code}.
b_tr_addr = {&b_addr}.
b_tr_qty_short = {&b_qty_short}.


FIND FIRST b_ld_det WHERE b_ld_site = {&b_site} AND b_ld_loc = {&b_loc} AND b_ld_part = {&b_part} AND b_ld_lot = {&b_lot} /*and b_ld_ref = {&b_code}*/ EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAILABLE b_ld_det  THEN do:
    
    CREATE b_ld_det.
     ASSIGN
      b_ld_date = {&mdate1}
      b_ld_ref = {&b_code}   
      b_ld_site = {&b_site}
      b_ld_loc = {&b_loc}
      b_ld_part = {&b_part}
      b_ld_lot = {&b_lot}
      b_ld_qty_oh = {&b_qty_loc}.
      
END.
ELSE DO:
    /*b_ld_site = {&b_site}
      b_ld_loc = {&b_loc}
      b_ld_part = {&b_part}
      b_ld_lot = {&b_lot}*/
      b_ld_qty_oh =  b_ld_qty_oh + {&b_qty_loc}.
END.
  
