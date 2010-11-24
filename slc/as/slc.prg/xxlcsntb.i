/* By: Neil Gao Date: 07/04/23 ECO: *ss 20070423.1 - b *  */

define variable xxi as int.
define variable xxj as int.
define variable trnbr as char.

do on error undo,return :
	
	repeat xxi = 1 to 15 :
		if {1}[xxi] = "" then leave.
		xxj = 1.
		repeat :
			trnbr = entry(xxj,{1}[xxi] ) no-error.
			if trnbr = ? or trnbr = "" then leave.
			find first tr_hist where tr_domain = global_domain and tr_trnbr = int(trnbr) and 
			tr_part >= part and tr_part <= part1 and 
			tr_site >= site and tr_site <= site1 no-lock no-error.
			if not avail tr_hist then leave.
			find first xxlcsn where xxlcsn_type = usrw_key1 and xxlcsn_sn 	= usrw_key2 and 
				xxlcsn_nbr = trnbr no-lock no-error.
			if avail xxlcsn then leave.
			create 	xxlcsn .
			assign 	xxlcsn_type = usrw_key1
							xxlcsn_sn 	= usrw_key2
							xxlcsn_nbr = trnbr.
			if sntype = "LCSNCZ" or sntype = "LCSNLZ" then do:
				if xxi <> 15 then assign 	xxi = xxi + 1
																	xxlcsn_nbr1 = {1}[xxi].
				else assign xxj = xxj + 1  
										xxlcsn_nbr1 = entry(xxj,{1}[xxi] ) no-error.
			end.
			if xxi <> 15 then leave.
			xxj = xxj + 1 .
		end. /* repeat */

	end. /* repeat xxi = 1 to 15 */
end. /* do on error undo,return */