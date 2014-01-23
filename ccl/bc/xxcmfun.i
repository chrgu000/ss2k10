/* xxcmfun.i - LIMIT MFG/PRO PROGRAMS BY DATE RESTRICTION                     */
/*V8:ConvertMode=Maintenance                                                  */
/* $Revision: 1.12 $                                                          */

if today < date(12,10,2013) or today > date(01,31,2014) then do:

   bell.
   if can-find(msg_mstr where msg_lang = "us"
                          and msg_nbr = 2261)
   then do:
      message "Software version expired, please contact your dealer".
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
