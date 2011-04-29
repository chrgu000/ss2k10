TRIGGER PROCEDURE FOR WRITE  OF wr_route .


do :
    find first xwr_route 
	where xwr_lot = wr_lot
	and   xwr_op  = wr_op
    no-error .
    if not avail xwr_route then do:
	{xwr_route.i}
    end.
    else /*if 
	    xwr_nbr <> wr_nbr
    then*/ do:
	delete xwr_route .
	{xwr_route.i}
    end.
end. 