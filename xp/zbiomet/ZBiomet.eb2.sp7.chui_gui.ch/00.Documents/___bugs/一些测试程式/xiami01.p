def var serial like tr_serial.
find wod_det no-lock where wod_nbr = "wo05070312" and wod_lot = "678".
disp recid(wod_det) with frame a down.
find first tr_hist no-lock where tr_nbr = wod_nbr and tr_lot = wod_lot
and tr_part = wod_part and tr_type begins "iss" no-error.
serial = tr_serial.
disp recid(tr_hist) tr_qty_loc tr_nbr tr_lot tr_serial tr_trnbr tr_type  with frame a.
disp tr_hist with frame a 2 columns.
find tr_hist no-lock where tr_part = wod_part and tr_serial = serial
and tr_type = "rct-wo".
down 1 with frame a.
disp recid(tr_hist) tr_nbr tr_lot tr_serial tr_trnbr tr_type with frame a
.
disp tr_hist with frame a 2 columns.