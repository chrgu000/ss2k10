/* xxchklv.i - check licence avaiable                                         */
/*V8:ConvertMode=Maintenance                                                  */
/* Revision: 9.1     Last modified: 08/17/00    By: *N0LJ* Mark Brown         */
/******************************************************************************/
/*-----------------------------------------------------------------------------
 *  API:
 *   {xxchklv.i application promptDays}
 *   application
 *   promptDays: remaining days prompt.
 *
 *----------------------------------------------------------------------------*/
{xxecdc.i}
define variable remainingdays as integer.
define variable mac as character.
define variable vc  as character.
define variable noAccess as logical.
assign mac = getMAC().

find first usrw_wkfl no-lock where {xxusrwdom1.i} {xxand.i}
           usrw_key1 = {1} and usrw_key2 = mac no-error.
if not available usrw_wkfl then do:
      find first usrw_wkfl no-lock where {xxusrwdom1.i} {xxand.i}
                 usrw_key1 = {1} and usrw_key2 = "" no-error.
end.
if not available usrw_wkfl then do:
   {pxmsg.i &MSGNUM=5349 &ERRORLEVEL=3 &MSGARG1={1}}
   pause 5.
   return.
end.
else do: /* else not can-find(first usrw_wkfl */
     if lookup(global_userid,usrw_key3) = 0 and
        usrw_key3 <> "" then do:
         {pxmsg.i &MSGNUM=5349 &ERRORLEVEL=3 &MSGARG1={1}}
         pause 5.
         return.
     end. /* if lookup(global_userid,usrw_key3) = 0 and */
     else do:
          assign vc = getEncode(usrw_key1 + "year!",
                                usrw_key2 + "month@",
                                usrw_key3 + "week#",
                            dts(usrw_datefld[1]) + "day$",
                                usrw_key4 + "hour%",
                                usrw_key5 + "minutes^",
                                usrw_key6 + "second&").
          if usrw_charfld[1] <> entry(1,vc,",") or
             usrw_charfld[2] <> entry(2,vc,",") or
             usrw_charfld[3] <> entry(3,vc,",") or
             usrw_charfld[4] <> entry(4,vc,",") or
             usrw_charfld[5] <> entry(5,vc,",") or
             usrw_charfld[6] <> entry(6,vc,",") or
             usrw_charfld[7] <> entry(7,vc,",") then do:
                 {pxmsg.i &MSGNUM=5349 &ERRORLEVEL=3 &MSGARG1={1}}
                 pause 5.
                 return.
          end.
          else if usrw_datefld[1] - today <= {2} and
             usrw_datefld[1] - today > 0 then do:
             assign remainingDays = usrw_datefld[1] - today.
             {pxmsg.i &MSGNUM=2697 &ERRORLEVEL=2
                      &MSGARG1=remainingdays}
          end.
          else if usrw_datefld[1] - today < 0 then do:
             {pxmsg.i &MSGNUM=2696 &ERRORLEVEL=3}
             pause 5.
             return.
          end.
     end. /* else lookup(global_userid,usrw_key3) = 0 and */

end. /* else not can-find(first usrw_wkfl */
