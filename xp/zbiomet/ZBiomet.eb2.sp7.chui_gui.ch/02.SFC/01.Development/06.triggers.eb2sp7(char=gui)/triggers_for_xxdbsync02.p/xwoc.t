TRIGGER PROCEDURE FOR CREATE OF wo_mstr .


/*
do:
    find first xwo_mstr 
	where xwo_lot = wo_lot
    no-error .
    if not avail xwo_mstr then do:
	{xwo_mstr.i}
    end.
    else /*if 
	 xwo_nbr <> wo_nbr
      or xwo_status <> wo_status
      or xwo_lot_next <> wo_lot_next 
    then*/ do:
	delete xwo_mstr .
	{xwo_mstr.i}
    end. 

end.
*/