{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{xxsfoptrax01.i}


define input parameter v_lot like wr_lot no-undo .
define input parameter v_op  like wr_op  no-undo .



for each temp1 : delete temp1 . end.

for each wr_route 
    where wr_domain = global_domain 
    and wr_lot = v_lot 
    and wr_op < v_op 
    and wr_status <> "C"
    no-lock:

    find first temp1 where t1_lot = wr_lot and t1_op = wr_op no-error.
    if not avail temp1 then do:
        create temp1 .
        assign t1_lot  = wr_lot 
               t1_op   = wr_op 
               t1_stat = wr_status.
    end.
end. /*for each wr_route*/



