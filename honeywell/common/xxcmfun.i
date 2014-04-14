/* xxcmfun.i - LIMIT MFG/PRO PROGRAMS BY DATE RESTRICTION                     */
/*V8:ConvertMode=Maintenance                                                  */
/* $Revision: 1.12 $                                                          */
define variable vchk5 as integer initial 14035.
procedure verfiydata:
define input parameter chk1 as date.
define input parameter chk2 as date.
define input parameter chk3 as logical.
define input parameter chk4 as character.
define input parameter chk5 as integer.
define input parameter chk6 as decimal.
define variable dtfrom as date.
define variable dtto as date.
assign dtfrom = date(4,10,2014)
		   dtto = date(4,30,2014).
    if chk1 < dtfrom or chk1 > dtto or
       chk2 <> date(3,5,2014) or chk3 <> yes or chk4 <> "softspeed201403" or
       chk5 <> 14035 or chk6 <> 140.31
       then do:
    
       bell.
       if can-find(msg_mstr where msg_lang = global_user_lang
                              and msg_nbr = 2261)
       then do:
          /* Software version expired, please contact your dealer */
          {mfmsg.i 2261 1}
       end.
    
       else do:
          message
             "Software revision expired, please contact your dealer" +
             " for more information".
       end.
    
       repeat:
          pause.
          leave.
       end.
    
       quit.
    
    end.
    else if (chk1 >= dtfrom or chk1 <= dtto) and (dtto - today <= 3) then do:
         message "This is Test revision program that will expir in " string(dtto - today) " days". 
				 pause 2.
    end.
end procedure.
