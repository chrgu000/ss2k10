   
   
   
FIND LAST b_tr_hist NO-LOCK NO-ERROR.
IF AVAILABLE b_tr_hist THEN mcount = b_tr_id + 1.
ELSE mcount = 1.
CREATE b_tr_hist.
b_tr_id = mcount .
b_tr_nbr = {&ord}.
b_tr_line = INTEGER({&mline}).
b_tr_code = {&b_code}.
b_tr_part = {&b_part}.
b_tr_lot = {&b_lot}.
b_tr_ser = {&b_ser}.
b_tr_qty_ord = {&b_qty_ord}.
b_tr_qty_loc = {&b_qty_loc}.
b_tr_qty_chg = {&b_qty_chg}.
b_tr_um = {&b_um}.
b_tr_date = {&mdate1}.
b_tr_tr_date = {&mdate2}.
b_tr_eff_date = {&mdate_eff}.
b_tr_type = {&b_typ}.
b_tr_time = {&mtime}.
b_tr_loc = {&b_loc}.
b_tr_site = {&b_site}.
b_tr_usrid = {&b_usrid}.
