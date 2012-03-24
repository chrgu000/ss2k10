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
assign mac = getMAC().

if not can-find(first usrw_wkfl no-lock where {xxusrwdom1.i} {xxand.i}
       usrw_key1 = {1} and (usrw_key2 = "" or usrw_key2 = mac)) then do:
   {pxmsg.i &MSGNUM=5349 &ERRORLEVEL=3 &MSGARG1={1}}
   pause 10.
   return.
end.
else do: /* else not can-find(first usrw_wkfl */
     for each usrw_wkfl no-lock where {xxusrwdom1.i} {xxand.i}
              usrw_key1 = {1} and (usrw_key2 = "" or usrw_key2 = mac)
              BREAK BY usrw_key1 BY usrw_key2:
         /*优先使用有记录MAC地址的*/
         if last-of(usrw_key1) then do:
            if lookup(global_userid,usrw_key3) = 0 and
               usrw_key3 <> "" then do:
                {pxmsg.i &MSGNUM=5349 &ERRORLEVEL=3 &MSGARG1={1}}
                pause 5.
                return.
            end. /* if lookup(global_userid,usrw_key3) = 0 and */
            else do:
                 assign vc = getEncode(usrw_key1,usrw_key2,usrw_key3,
                                   dts(usrw_datefld[1]), usrw_key4,
                                       usrw_key5,usrw_key6).
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
                 if usrw_datefld[1] - today <= {2} and
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
         end. /*if last-of(usrw_key1) then do:*/
     end.
end. /* else not can-find(first usrw_wkfl */
