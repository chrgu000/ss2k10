
        do transaction on error undo, retry:
           find first xxdn_ctrl where xxdn_code = substr(receivernbr,1,1) and xxdn_year = string(year(today))no-error.
	   if available xxdn_ctrl then do:
	      receivernbr = xxdn_code + xxdn_value + fill("0",5 - length(string(integer(xxdn_nbr) + 1))) + string(integer(xxdn_nbr) + 1) + "A".
	      xxdn_nbr = fill("0",5 - length(string(integer(xxdn_nbr) + 1))) + string(integer(xxdn_nbr) + 1).
	   end.
           if recid(xxdn_ctrl) = ? then .
           release xxdn_ctrl.
	end. /*do transaction*/
