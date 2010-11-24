/* By: Neil Gao Date: 07/04/21 ECO: * ss 20070421.1 */

{mfdeclre.i}

define input parameter iptf1 as char.
define input parameter iptf2 as char.
define input parameter iptf3 as char.
define input parameter iptf4 as char.
define input parameter iptf5 as int.
define input parameter iptf6 as char.
define output parameter optf1 as char.
define var lcsn as char.
define var lcint as int.

do on error undo:
    	
    	lcsn = iptf2 + iptf3 + iptf4.
    	
    	find last usrw_wkfl where usrw_domain = global_domain and usrw_key1 = iptf1 and usrw_key2 begins lcsn no-lock no-error.
   		if avail usrw_wkfl then do:
   			
   			if usrw_key2 > lcsn then do:
   				lcint = int( substring(usrw_key2,length(lcsn) + 1,iptf5)) no-error.
   				if lcint = 0 then do:
   					message "错误: 有错误数据存在".
   					return.
   				end.
   				lcsn = lcsn + string( ( lcint  + 1 ),fill( "9", iptf5) ).
   			end.
   			else lcsn = lcsn + fill( "0",iptf5 - 1) + "1".
   		end.
   		else do:
   			lcsn = lcsn + fill( "0",iptf5 - 1) + "1".
   		end. /* else do: */
   		
   		lcsn = lcsn + iptf6.
   		
			find first usrw_wkfl where usrw_domain = global_domain and usrw_key1 = iptf1 and usrw_key2 = lcsn no-error.
			if not avail usrw_wkfl then do:
   		 	create 	usrw_wkfl.
  			assign 	usrw_domain = global_domain
  							usrw_key1 = iptf1 
  							usrw_key2 = lcsn
  							usrw_key3 = global_userid
  							usrw_key4 = iptf3
  							usrw_datefld[1] = today.
			end. /* if not avail usrw_wkfl */
			else do:
				message "错误: 有错误数据存在".
				return.
			end.
			optf1 = lcsn.
end. /* do on error undo */  	