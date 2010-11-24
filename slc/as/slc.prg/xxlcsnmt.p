/* By: Neil Gao Date: 07/04/21 ECO: * ss 20070421.1 */

{mfdeclre.i}

define input parameter lcsn as char.
define input parameter sntype as char.
define input parameter sntrnbr like tr_trnbr.
define output parameter snresult as logical.

define variable xxi as int.

do on error undo:

      snresult = no.
    
    	find first usrw_wkfl where usrw_domain = global_domain and usrw_key1 = sntype  and usrw_key2 = lcsn no-error.
			if avail usrw_wkfl then do:
				snresult = yes. /* Ö´ÐÐ³É¹¦ */
				repeat xxi = 1 to 15 :
					if usrw_charfld[xxi] = "" then do:
						usrw_charfld[xxi] = string(sntrnbr).					
						leave.
					end.
					if xxi = 15 then usrw_charfld[xxi] = usrw_charfld[xxi] + "," + string(sntrnbr) .				
				end. /* repeat */
			end.
			
end. /* do on error undo */  	