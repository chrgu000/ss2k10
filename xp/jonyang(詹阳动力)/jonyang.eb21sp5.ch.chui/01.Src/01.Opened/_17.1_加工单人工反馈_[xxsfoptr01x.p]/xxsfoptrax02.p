{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{xxsfoptrax01.i}


for each temp1:

    find first wr_route 
        where wr_domain = global_domain 
        and wr_lot = t1_lot 
        and wr_op  = t1_op
    no-error .
    if avail wr_route then do:
        assign wr_status = t1_stat .
    end.
end. /*for each temp1*/



