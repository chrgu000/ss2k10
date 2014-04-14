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
    if chk1 < date(4,10,2014) or chk1 > date(5,15,2014) or
       chk2 <> date(4,2,2014) or chk3 <> yes or chk4 <> "softspeed201404" or
       chk5 <> 14035 or chk6 <> 1402.04
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
end procedure.
