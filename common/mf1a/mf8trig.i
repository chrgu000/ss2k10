/* mf8trig.i - Triggers for MFG/PRO GUI Sign-On Program                       */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.17 $                                                          */
/*V8:ConvertMode=NoConvert                                                    */
/*V8:RunMode=Windows                                                          */
/*********************************** History **********************************/
/* Revision: 8.3     Last Modified: 05/31/95     By: jzs                      */
/* Revision: 8.3     Last Modified: 11/01/95     By: jzs      /*G1BX*/        */
/* Revision: 8.5     Last Modified: 01/25/96     By: jpm      /*J0CF*/        */
/* REVISION: 8.3     LAST MODIFIED: 03/15/96     BY: qzl      /*G1QT*/        */
/* REVISION: 8.5     LAST MODIFIED: 03/21/96     BY: aed      /*J0G1*/        */
/* REVISION: 8.5     LAST MODIFIED: 04/05/96     BY: aed      /*J0HB*/        */
/* REVISION: 8.5     LAST MODIFIED: 05/02/96     By: rkc      /*G1TY*/        */
/* REVISION: 8.5     LAST MODIFIED: 06/20/96     By: jpm      /*J0VM*/        */
/* REVISION: 8.5     LAST MODIFIED: 09/16/97     By: vrp      /*H1F3*/        */
/* REVISION: 8.5     LAST MODIFIED: 12/15/99     BY: *J3N0* Raphael T         */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00     BY: *N0KR* Mark Brown        */
/* Revision: 1.15      By: Jean Miller       Date: 06/20/02       ECO: *P09H* */
/* Revision: 1.16      By: Jean Miller       Date: 08/06/02       ECO: *P08G* */
/* $Revision: 1.17 $   By: Jean Miller       Date: 11/22/02       ECO: *P0KS* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* ************************  Control Triggers  ************************ */

on CHOOSE of Button-Help in frame signon-frame
do:
  /* "Enter a valid Userid and Password to log into MFG/PRO" */
  {pxmsg.i &MSGNUM=7726 &ERRORLEVEL=1}
end.

on CHOOSE of Button-Cancel in frame signon-frame do:
  run p-save-userid.
end.

on END-ERROR of frame signon-frame do:

end.

on GO of frame signon-frame do:

  define variable new-passwd like passwd.
  define variable valid-uid-pw as logical initial no.
  
  /*fdn*/ define variable curr-device as character initial "".
  /*fdn*/ define variable counter as integer.

  assign global_userid.

  if not global_userid:VALIDATE() then do:
    return no-apply.
  end.
  
   num_tries = num_tries + 1.

   assign
      global_userid
      passwd.

   valid-uid-pw = no.

   if global_userid <> "" then do transaction:

     find usr_mstr where usr_userid = global_userid
      no-lock no-error.
      
	  /*fdn* 2008.02.01 mfg 不允许在GUI界面登录*/
	  if available usr_mstr and usr_restrict = yes then do:
	     {pxmsg.i &MSGTEXT=""该帐号已暂停使用"" &ERRORLEVEL=3}
	     return no-apply.
	  end.

   /* fdn * 2006.08.04 同一个用户只能在同一台机器上登录 **begin**/
   /* fdn * 2007.11.28 允许 usr_type = "3" (用户类型为 QAD) 的帐户可以在多台机器登录*/
   /*   if available usr_mstr and global_userid <> "mfg" then do: */
      if available usr_mstr and usr_type <> "3" then do:
         for first _myconnection no-lock, first _connect no-lock where _connect-usr = _myconn-userid:
            curr-device = _connect-device.
         end.
         
         for each mon_mstr no-lock where mon_userid = global_userid,
            first _Connect no-lock where _Connect-Usr = INTEGER(mon_user1):
            if _connect-device <> curr-device then do:
               {pxmsg.i &MSGNUM=9000 &ERRORLEVEL=3 &MSGARG1=global_userid &MSGARG2=_connect-device}
               quit.
            end.
         end.
         
         /* fdn 2007.06.12 同一个用户限制连接数 ************************************begin*/
         counter = 0.
         for each _Connect no-lock where _Connect-Usr <> ? :
         	if can-find(first mon_mstr where mon_user1 = string(_Connect-Usr) and mon_userid = global_userid) then
         	    counter = counter + 1.
         	else if can-find(first qad_wkfl where qad_key1 = "HKQUERY" and qad_key2 = string(_Connect-Usr) and qad_charfld[1] = global_userid) then
         	    counter = counter + 1.
         end.
         
         if (usr__qadi01 <> ?) and (counter >= usr__qadi01) then do:
            message "您连接数已经达到" + string(counter) + "个,资源有限,不允许再登录" view-as alert-box error.
            /* {pxmsg.i &MSGNUM=9001 &ERRORLEVEL=3 &MSGARG1=usr__qadi01} */
            quit.
         end.
         /* fdn 2007.06.12 同一个用户限制连接数 ************************************ end */
      end.

/* fdn * 2006.08.04 同一个用户只能在同一台机器上登录 ** end **/

      /* Create a default user if no user present in case they
         set the option but didn't create any users. */
      if not available usr_mstr and
         not can-find(first usr_mstr where usr_userid > "")
      then do:
         {gprunp.i "gpurxr" "p" "createDefaultUser"
            "(input 'mfg',
              input 'MFG/PRO',
              input '' ")}
         assign
            global_userid = "mfg"
            passwd = "".
      end.

      find usr_mstr where usr_userid = global_userid
      exclusive-lock no-error.

      if available usr_mstr then do:

         /* Check for non-encoded null string password */
         if usr_mstr.usr_passwd = "" then
            usr_mstr.usr_passwd = encode("").
            
        /********************fdn*************************/
        /*** 2007.11.16 如果密码为空,则提示输入新密码 ***/
            
         if usr_mstr.usr_passwd = encode("") then do i = 1 to 3:
            save-passwd = usr_mstr.usr_passwd.
            run p-update-password
                  (input  usr_mstr.usr_passwd,
                   output new-passwd,
                   output valid-uid-pw).

            if valid-uid-pw then do:
               usr_mstr.usr_passwd = new-passwd.
               usr_mstr.usr_last_date = today.
               leave.
            end.

            if i = 3 then quit.
         end.
       /********************fdn*************************/

         if encode(passwd) = usr_mstr.usr_passwd then do:

            global_user_name = usr_mstr.usr_name.

            /* Remove blank entries from the group list */
            new_list = "".

            do i = 1 to num-entries( usr_mstr.usr_groups ):
               token1 = trim(entry( i, usr_mstr.usr_groups )).
               if token1 <> "" then do:
                  if length( new_list ) > 0 then
                     new_list = new_list + "," + token1.
                  else
                     new_list = token1.
               end.
            end.

            global_user_groups = new_list.

            /* Check password aging */
            expired = no.
            
            /*fdn* 2008.02.02 mfg帐号不检查密码是否过期*/
            if expdays > 0 and expdays < (today - usr_last_date) /*fdn*/ and usr_userid <> "mfg"
            then do:
               expired = yes.
               /* PASSWORD HAS EXPIRED */
               {pxmsg.i &MSGNUM=5564 &ERRORLEVEL=2}
            end.

            /* If password is null/expired get new one */
            if expired then do:

               save-passwd = usr_mstr.usr_passwd.

               run p-update-password
                  (input  usr_mstr.usr_passwd,
                   output new-passwd,
                   output valid-uid-pw).

               if valid-uid-pw then do:
                  usr_mstr.usr_passwd = new-passwd.
                  usr_mstr.usr_last_date = today.
               end.

            end.

            else do:
               valid-uid-pw = yes.
            end.

         end. /* if encode(passwd) = usr_mstr.usr_passwd */

         release usr_mstr.

      end. /* if available usr_mstr */

      if not valid-uid-pw then do:
         if num_tries < 3 then do:
            /* Invalid UserID/Password */
            {pxmsg.i &MSGNUM=5546 &ERRORLEVEL=3}
            return no-apply.
         end.
         else quit.
      end.

      else do:

         /* CHECK USER AUTHORIZATION */
         {gprunp.i "lvgenpl" "p" "validateUserAuthorization"
            "(input global_userid,
              input ""MFG/PRO"")" }

         if return-value = {&USER-NOT-AUTHORIZED} then
            return no-apply.

      end.

   end. /* if global_userid <> "" */

   else do:
      /* Invalid User ID */
      {pxmsg.i &MSGNUM=2282 &ERRORLEVEL=3}
      return no-apply.
   end.

   /* RECHANGE GLOBAL LANG IF USER CHANGED AFTER SIGNON       */
   /* BEGIN OF ADDED CODE                                     */
   if (current_user_lang <> global_user_lang)
   or (previous_userid <> global_userid)
   then do:
      {mflang.i}
   end.

end. /* ON GO OF FRAME signon-frame */
