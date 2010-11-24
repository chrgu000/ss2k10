/* By: Neil Gao Date: 07/04/21 ECO: * ss 20070421.1 */

{mfdeclre.i}

define input-output parameter lcsn as char.
define input parameter sntype as char.
define input parameter sndate as date.
define output parameter snresult as logical.
define var snbegin as char format "x(2)".

do on error undo:

		if sndate = ? then sndate = today.
    snresult = no.
    snbegin = substring(sntype,5,2).
    
    if lcsn = "" then do:
   		find last usrw_wkfl where usrw_domain = global_domain and usrw_key1 = sntype no-lock no-error.
   		if avail usrw_wkfl then do:
   			lcsn = snbegin +  substring( string(year(sndate)) , 3 , 2 ) + string ( month(sndate),"99" )
   						+ string(day(sndate),"99") .
   			if usrw_key2 > lcsn then lcsn = lcsn + string( ( int ( substring(usrw_key2,9,3) )  + 1  ),"999" ).
   			else lcsn = lcsn + "001".
   		end.
   		else do:
   			lcsn = snbegin + substring( string(year(sndate) )  , 3 , 2  ) + string ( month(sndate),"99" )
   						+ string(day(sndate),"99") + "001" .
   		end. /* else do: */
   		
				find first usrw_wkfl where usrw_domain = global_domain and usrw_key1 = sntype  and usrw_key2 = lcsn no-error.
				if not avail usrw_wkfl then do:
   			 	create 	usrw_wkfl.
  				assign 	usrw_domain = global_domain
  								usrw_key1 = sntype 
  								usrw_key2 = lcsn
  								usrw_key3 = global_userid
  								usrw_datefld[1] = sndate.
				end. /* if not avail usrw_wkfl */
				else usrw_datefld[2] = today.
  	end. /* if lcsn = "" */
  	else do:
  		find first usrw_wkfl where usrw_domain = global_domain and usrw_key1 = sntype  and usrw_key2 = lcsn no-lock no-error.
  		if not avail usrw_wkfl then do:
  			message "单据号不存在".
  			return.
  			
  		end.
/*  		if usrw_key4 <> "" then do:
  			message "单据号不能修改".
  			return.
  		end.*/
  		if usrw_datefld[2] <> ? then do:
  			message "已打印，不能修改".
  			return.
  		end. 
  		if usrw_key3 <> global_userid then do:
  			message "用户不相同，不能修改".
  			return.
  		end.
  	end.
  	snresult = yes. /* 执行成功 */
end. /* do on error undo */  	