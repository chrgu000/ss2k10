TRIGGER PROCEDURE FOR DELETE OF wr_route .


do :
    find first xwr_route 
	where xwr_lot = wr_lot
	and   xwr_op  = wr_op
    no-error .
    if avail xwr_route then do:
	delete xwr_route .
    end.
end. 