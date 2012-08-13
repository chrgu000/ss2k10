/* GUI CONVERTED from mgurmt.p (converter v1.77) Thu Sep 11 02:10:44 2003 */
/* mgurmt.p - USER MAINTENANCE                                                */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.8.1.36.3.4 $                                                  */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.0      LAST MODIFIED: 06/24/92   BY: rwl *F675*                */
/*                                   01/14/93   BY: sas *G519*                */
/*                                   02/11/93   BY: rwl *G671*                */
/*                                   02/11/93   BY: mpp *G679*                */
/*                                   02/22/93   BY: rwl *G727*                */
/* REVISION: 7.4      LAST MODIFIED: 11/16/93   BY: rwl *H231*                */
/*                                   06/09/94   BY: rmh *FO45*                */
/* REVISION: 8.5      LAST MODIFIED: 01/06/95   BY: mwd *J034*                */
/* REVISION: 7.4      LAST MODIFIED: 01/30/95   BY: yep *H0B0*                */
/* REVISION: 7.4      LAST MODIFIED: 09/20/95   BY: dxb *G0XB*                */
/* REVISION: 8.5      LAST MODIFIED: 02/07/97   BY: jpm *J1H4*                */
/* REVISION 8.6       LAST MODIFIED: 04/15/97   BY: *J1W5* Patrick Rowan      */
/* REVISION 8.6       LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION 9.1       LAST MODIFIED: 08/13/00   BY: *N0KR* myb                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.8.1.2       BY: Katie Hilbert     DATE: 11/03/01  ECO: *P00B*  */
/* Revision: 1.8.1.4       BY: Katie Hilbert     DATE: 11/28/01  ECO: *P02D*  */
/* Revision: 1.8.1.5       BY: Vinod Nair        DATE: 03/18/02  ECO: *N1D5*  */
/* Revision: 1.8.1.6       BY: Jean Miller       DATE: 04/11/02  ECO: *P05F*  */
/* Revision: 1.8.1.13      BY: Rajesh Lokre      DATE: 06/03/02  ECO: *P06S*  */
/* Revision: 1.8.1.16      BY: Jean Miller       DATE: 06/19/02  ECO: *P09H*  */
/* Revision: 1.8.1.19      BY: Katie Hilbert     DATE: 07/01/02  ECO: *P0B1*  */
/* Revision: 1.8.1.24      BY: Jean Miller       DATE: 07/24/02  ECO: *P08G*  */
/* Revision: 1.8.1.26      BY: Jean Miller       DATE: 08/13/02  ECO: *P0F5*  */
/* Revision: 1.8.1.27      BY: Nishit V          DATE: 08/16/02  ECO: *N1R3*  */
/* Revision: 1.8.1.28      BY: Jean Miller       DATE: 08/20/02  ECO: *P0FX*  */
/* Revision: 1.8.1.31      BY: Jean Miller       DATE: 08/21/02  ECO: *P0G3*  */
/* Revision: 1.8.1.32      BY: Jean Miller       DATE: 09/06/02  ECO: *P0HY*  */
/* Revision: 1.8.1.36      BY: Jean Miller       DATE: 11/21/02  ECO: *P0KS*  */
/* Revision: 1.8.1.36.3.1  BY: Seema Tyagi       DATE: 06/20/03  ECO: *P0VV*  */
/* Revision: 1.8.1.36.3.2  BY: Deepak Rao        DATE: 07/10/03  ECO: *P0WV*  */
/* Revision: 1.8.1.36.3.3  BY: Orlando D'Abreo   DATE: 08/19/03  ECO: *P103*  */
/* $Revision: 1.8.1.36.3.4 $ BY: Jean Miller     DATE: 09/10/03  ECO: *P12V*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*cj* 08/26/05 add password security control*/

{mfdtitle.i "2+ "}

{pxmaint.i}
{pxphdef.i gpurxr}

/* E-MAIL VARIABLES */
{mgem02.i}
{gprunpdf.i "lvgenpl" "p"}

&SCOPED-DEFINE CONCURRENT-SESSIONS 0
&SCOPED-DEFINE NAMED-USERS         1
&SCOPED-DEFINE LOCATION-USERS      2
&SCOPED-DEFINE CAPACITY-UNITS      3
&SCOPED-DEFINE FIXED-PRICE         4

define variable del-yn        like mfc_logical initial no no-undo.
define variable ans           like mfc_logical initial no no-undo.
define variable l_undo        as   logical        no-undo.
define variable l-err-nbr     like msg_nbr        no-undo.
define variable prev-acc-loc  like usr_access_loc no-undo.
define variable l_aud_date    as date       no-undo.
define variable l_aud_ddate   as date       no-undo.

define buffer   usrldet  for usrl_det.

{mgurmt.i}

{mf1.i}

{gpaud.i
   &uniq_num1 = 01
   &uniq_num2 = 02
   &db_file = usr_mstr
   &db_field = usr_userid}

loopa:
repeat for usr_mstr:
/*GUI*/ if global-beam-me-up then undo, leave.


   innerloop:
   repeat on endkey undo, leave loopa:
/*GUI*/ if global-beam-me-up then undo, leave.


      prompt-for usr_userid with frame a
      editing:

         {mfnp05.i
            usr_mstr usr_userid yes usr_userid "input usr_userid"}

         if recno <> ?
         then do:

            /* CONVERT usr_type INTO IT'S ALPHA MNEMONIC */
            {gplngn2a.i &file  = ""usr_mstr""
                     &field    = ""usr_type""
                     &code     = usr_type
                     &mnemonic = l_usrtype_code
                     &label    = l_usrtype_desc}

            display
               usr_userid
               usr_name
            with frame a.

            user_passwd = usr_passwd.

            for first uip_mstr
               fields (uip_hypertext_help uip_style
                       uip_userid uip__qad01)
               where uip_userid = usr_userid
            no-lock: end.

            if available uip_mstr then
               l-ui-menu-sub = (uip_mstr.uip__qad01 = "TRUE").
            else
               l-ui-menu-sub = no.

            display
               usr_lang
               usr_ctry_code
               usr_variant_code
               l_usrtype_code
               usr_restrict
               usr_timezone
               usr_access_loc
               usr_last_date
               l_email
               usr_mail_address
               usr__qad02
               l_preferences
               l-ui-menu-sub
               menu_options
               usr_groups
            with frame b.

            if available uip_mstr then
               display
                  uip_style
                  uip_hypertext_help
               with frame b.
            else
               display
                  "A" @ uip_style
                  getTermLabel("YES",6) @ uip_hypertext_help
               with frame b.

         end. /* IF recno <> ? */

      end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* EDITING */

      /* ADD/MOD/DELETE  */
      find usr_mstr using usr_userid exclusive-lock no-error.

      if not available usr_mstr then do:

         /* ADDING NEW RCORD */
         {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}

         create usr_mstr.
         assign
            usr_userid
            usr_passwd = encode("").

         /* GET DEFAULT TIMEZONE */
         for first gl_ctrl
            fields (gl_timezone)
         no-lock :
            usr_timezone = gl_timezone.
         end. /*FOR FIRST gl_ctrl */

         prev-acc-loc = "".

         /* Default Access Location */
         if not can-find(first code_mstr where
                               code_fldname = "usr_access_loc" and
                               code_value  <> "PRIMARY") and
            can-find(code_mstr where
                     code_fldname = "usr_access_loc" and
                     code_value   = "PRIMARY")
         then
            usr_access_loc = "PRIMARY".


      end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* IF NOT AVAILABLE usr_mstr */


      find uip_mstr where uip_userid = usr_userid exclusive-lock no-error.

      if not available uip_mstr then do:
         create uip_mstr.
         assign
            uip_userid         = usr_userid
            uip_style          = "A"
            uip_hypertext_help = true
            uip__qad01         = "FALSE"
            l-ui-menu-sub      = no.
      end. /* IF NOT AVAILABLE uip_mstr */

      assign
         l-ui-menu-sub = (uip_mstr.uip__qad01 = "TRUE")
         prev-acc-loc  = usr_access_loc.

      {gpaud1.i
         &uniq_num1 = 01
         &uniq_num2 = 02
         &db_file = usr_mstr
         &db_field = usr_userid}

      if new usr_mstr then do:

         /* VERIFY IF USERID ENTERED IS A DEFINED CUSTOMER */
         for first cm_mstr
            fields (cm_addr cm_sort)
            where cm_addr = usr_userid
         no-lock:

            for first ad_mstr
               fields (ad_addr ad_type ad_timezone)
               where ad_addr = cm_addr
                 and ad_type = "Customer"
            no-lock:
               usr_timezone   = ad_timezone.
            end. /* FOR FIRST ad_mstr */

           /* ASSIGN DEFAULT USER TYPE CUSTOMER */
            assign
               usr_name       = cm_sort
               usr_type       = "2"
               usr_restrict   = yes.

         end. /*FOR FIRST cm_mstr */

      end. /* IF NEW usr_mstr */

      display
         usr_userid
         usr_name
      with frame a.

      loopb:
      do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

         set
            usr_name
         with frame a.
      end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* DO ON ERROR ... */

      user_passwd = usr_passwd.

      ststatus = stline[2].
      status input ststatus.

      /* CONVERT usr_type INTO IT'S ALPHA MNEMONIC */
      {gplngn2a.i &file     = ""usr_mstr""
                  &field    = ""usr_type""
                  &code     = usr_type
                  &mnemonic = l_usrtype_code
                  &label    = l_usrtype_desc}

      display
         usr_lang
         usr_ctry_code
         usr_variant_code
         user_passwd
         l_usrtype_code
         usr_restrict
         usr_timezone
         usr_access_loc
         usr_last_date
         l_email
         usr_mail_address
         usr__qad02
         l_preferences
         uip_style
         menu_options
         uip_hypertext_help
         l-ui-menu-sub
         usr_groups
      with frame b.

      loopc:
      do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


         set
            usr_lang
            usr_ctry_code
            usr_variant_code
            user_passwd blank
            l_usrtype_code
            usr_restrict
            usr_timezone
            usr_access_loc
            usr_mail_address
            usr__qad02
            uip_style
            uip_hypertext_help
            l-ui-menu-sub
            usr_groups
         go-on(F5 CTRL-D) with frame b.

         del-yn = no.

         /* DELETE */
         if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
         then do:

            /* Find out when this user last accessed the system */
            /* and if they have any activity recorded           */
            for first usrl_det where usrl_userid = usr_userid and
                                     usrl_product = "MFG/PRO"
            no-lock: end.

            for first lua_det where lua_userid = usr_userid
            no-lock: end.
/*GUI*/ if global-beam-me-up then undo, leave.


            /* Get Last Audit Date */
            {gprunp.i "lvgenpl" "p" "getAuditDates"
               "(input 'MFG/PRO',
                 output l_aud_date,
                 output l_aud_ddate)"}

            if (available usrl_det and usrl__qadt01 <> ?
                                   and (usrl__qadt01 > l_aud_date or
                                        l_aud_date = ?)) or
               available lua_det
            then do:
               /* Delete not allowed.  User has been active */
               {pxmsg.i &MSGNUM=5594 &ERRORLEVEL=4}
               next loopa.
            end.

            /* Allow the delete if userid never used */
            else do:

               for first pcld_det
                  field(pcld_id)
                  where pcld_id = usr_userid
                  no-lock:
               end. /* FOR FIRST pcld_det */

               if available pcld_det
               then do:
                  /* Delete operation will also remove the user from the PCC */
                  /* Group                                                   */
                  {pxmsg.i &MSGNUM=6249 &ERRORLEVEL=2}
               end. /* IF AVAILABLE pcld_det */

               del-yn = yes.
               /* Please confirm delete */
               {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
               if del-yn = no then next loopa.

               {pxrun.i &PROC='processDelete' &PROGRAM='gpurxr.p'
                        &HANDLE=ph_gpurxr
                        &PARAM="(buffer usr_mstr)"
                        &NOAPPERROR=true
                        &CATCHERROR=true}

               clear frame a.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
               clear frame b.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
               leave innerloop.

            end.

         end.

         /* Validate Country code */
         if usr_ctry_code = "" or
            not can-find (first ctry_mstr where
                                ctry_ctry_code = input usr_ctry_code)
         then do:
             /*Country code does not exist */
            {pxmsg.i &MSGNUM=861 &ERRORLEVEL=3}
            next-prompt usr_ctry_code with frame b.
            undo loopc, retry loopc.
         end.

         /* Make sure Alternate Country code is defined in Country code master*/
         for first ctry_mstr
            where ctry_ctry_code = usr_ctry_code
         no-lock: end.

         if available ctry_mstr and ctry_code1 = "" then do:
            /* Alternate Code must be defined for this Country Code */
            {pxmsg.i &MSGNUM=5436 &ERRORLEVEL=3}
            next-prompt usr_ctry_code with frame b.
            undo loopc, retry loopc.
         end.

         /* VALIDATE USR_TYPE MNEMONIC AGAINST lngd_det */
         {gplngv.i &file     = ""usr_mstr""
                   &field    = ""usr_type""
                   &mnemonic = l_usrtype_code:screen-value
                   &isvalid  = l_valid_mnemonic}

         if not l_valid_mnemonic
         then do:
            /* INVALID MNEMONIC */
            {pxmsg.i &MSGNUM=3169 &ERRORLEVEL=3 &MSGARG1=l_usrtype_code}
            next-prompt l_usrtype_code with frame b.
            undo loopc, retry loopc.
         end. /* IF NOT l_valid_mnemonic */

         /* CONVERT l_usrtype_code INTO usr_type NUMERIC */
         {gplnga2n.i &file     = ""usr_mstr""
                     &field    = ""usr_type""
                     &mnemonic = l_usrtype_code
                     &code     = usr_type
                     &label    = l_usrtype_desc}

         /* TIME ZONE VALIDATION  */
         if not can-find(tzo_mstr
                   where tzo_label = usr_timezone)
         then do:
            /* INVALID TIMEZONE */
            {pxmsg.i &MSGNUM=1685 &ERRORLEVEL=3}
            next-prompt usr_timezone with frame b.
            undo loopc, retry loopc.
         end. /* IF NOT CAN-FIND(tzo_mstr ...) */

         /* Validate usr_access_loc is not blank */
         if usr_access_loc = "" then do:
            /* Blank not allowed */
            {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}
            next-prompt usr_access_loc with frame b.
            undo loopc, retry loopc.
         end.

         /* VALIDATE usr_access_loc FROM code_mstr */
         if not ({gpcode.v usr_access_loc "usr_access_loc"})
         then do:
            /* VALUE MUST EXIST IN GENERALIZED CODES */
            {pxmsg.i &MSGNUM=716 &ERRORLEVEL=3}
            next-prompt usr_access_loc with frame b.
            undo loopc, retry loopc.
         end. /* IF CAN-FIND(code_mstr */

         /* Check the Location Licenses, if the Access Location */
         /* is changed and user has already been authorized     */
         if not new usr_mstr and
            usr_access_loc <> prev-acc-loc
         then do:

            run checkLocationLicenses
               (input usr_userid,
                input usr_access_loc,
                output l_undo).

            /* If a hard error occurred */
            if l_undo then do:
               next-prompt usr_access_loc with frame b.
               undo loopc, retry loopc.
            end.

         end.

         /* FOR EXISTING USER IF PRODUCT IS ACTIVE */
         /* THEN DO NOT VALIDATE                   */
         if not can-find(first usrl_det
                         where usrl_userid  = usr_userid
                           and usrl_product = "MFG/PRO"
                           and usrl_active  = yes)
         then do:

            /* PERFORM LICENSED USER COUNTING AND VALIDATION */
            {gprunp.i "lvgenpl" "p" "validateDefinedUserCount"
               "(input 'MFG/PRO',
                 input usr_userid,
                 input usr_access_loc,
                 input yes,
                 output l_undo)"}

            if l_undo then
               undo innerloop, retry innerloop.

             run createApplicationList
               (input usr_userid,
                input "MFG/PRO",
                output l_active ).

         end. /* IF NOT CAN-FIND (FIRST usrl_det */

         /* CHANGES TO BELOW LOGIC MUST ALSO */
         /* BE INCORPORATED IN mgurmtp.p     */
         /* CONFIRM ENTERED PASSWORD */
         l-confirm-passwd = "".

         if frame-field = "user_passwd"
         and (lastkey = keycode("F8")
         or keyfunction(lastkey) = "CLEAR")
         then
            user_passwd = "".

         /* Check to see if the password has been changed */
         if user_passwd  <> usr_passwd and
            encode(user_passwd) <> usr_passwd
         then do:

/*cj*add*beg*/
              {gprun.i ""yyusr.p"" "(input usr_userid ,
                  INPUT user_passwd ,
                  OUTPUT ans)"
               }
              if not ans then do:
                   user_passwd:screen-value = "".
                   next-prompt user_passwd with frame b.
                   undo loopc, retry loopc.
              end. /* IF NOT ans */
/*cj*add*end*/

            display l-confirm-passwd  with frame conf-passwd.
            set
               l-confirm-passwd blank with frame conf-passwd.
            hide frame conf-passwd.
            if l-confirm-passwd <> user_passwd
            then do:
               /* PASSWORDS DO NOT MATCH */
               {pxmsg.i &MSGNUM=5548 &ERRORLEVEL=3}
               user_passwd:screen-value = "".
               next-prompt user_passwd with frame b.
               undo loopc, retry loopc.
            end. /* IF l-confirm-passwd <> user_passwd */
         end. /* IF user_passwd <> "" */

         /* MENU STYLE VALIDATION */
         if (lookup(uip_style,"A,B,C") = 0)
         then do:
            /* MENU STYLE SELECTION MUST BE A, B, or C */
            {pxmsg.i &MSGNUM=2648 &ERRORLEVEL=3}
            next-prompt uip_style with frame b.
            undo loopc, retry loopc.
         end. /* IF (LOOKUP(uip_style, ... */

      end. /* LOOPC */

      /* IF THIS IS A CUSTOMER THEN CHECK THE  */
      /* CM_MSTR FOR A RECORD.                 */
      if usr_type = "2"
        and not can-find(first cm_mstr
                         where cm_addr  = usr_userid)
      then do:
         /* CUSTOMER DOES NOT EXIST IN CUSTOMER MASTER */
         {pxmsg.i &MSGNUM=7220 &ERRORLEVEL=3}
         undo innerloop, retry innerloop.
      end. /* IF usr_type ="2" */


      /**************************************************************/
      /* IF THE E-MAIL SYSTEM HAS BEEN ENTERED, CHECK THE EM_MSTR   */
      /**************************************************************/
      /* VALID E-MAIL SYSTEMS ARE ACTIVE; WITH AN END EFFECTIVYITY  */
      /* LATER THAN TODAY OR NO END EFFECTIVITY.                    */
      /**************************************************************/
      if usr__qad02 <> ""
      then do:

         if can-find(first qad_wkfl where
                           qad_key1 = email_record_name and
                           qad_charfld[1] = usr__qad02)
         then do:

            if not can-find(first qad_wkfl where
                                  qad_key1 = email_record_name and
                                  qad_charfld[1] = usr__qad02  and
               (qad_datefld[2] > today or qad_datefld[2] = ?))
            then do:
               /* E-mail system is not active */
               {pxmsg.i &MSGNUM=1849  &ERRORLEVEL=3}
               undo innerloop, retry innerloop.
            end. /*IF NOT CAN-FIND (FIRST qad_wkfl ... */

         end.  /* if can-find(first em_mstr) */

         else do:
            /* Invalid e-mail system */
            {pxmsg.i &MSGNUM=1791  &ERRORLEVEL=3}
            undo innerloop, retry innerloop.
         end. /* IF can-find ... ELSE DO */

      end.  /* if usr__qad02 <> "" */

      ststatus = stline[3].
      status input ststatus.

      hide frame b.
      clear frame c all no-pause.

      if new usr_mstr and
         can-find (first pin_mstr where pin_product <> "MFG/PRO" and
                                        pin_product <> "XMFG/PRO")
      then do:

         /* Authorize User for all Licensed Products */
         {pxmsg.i &MSGNUM=5583 &ERRORLEVEL=1 &CONFIRM=ans}

         if ans then do:

            for each pin_mstr where pin_product <> "MFG/PRO"
                                and pin_product <> "AUDIT"
            no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.


               if pin_product begins "X" then next.

               /* PERFORM LICENSED USER COUNTING AND VALIDATION */
               {gprunp.i "lvgenpl" "p" "validateDefinedUserCount"
                  "(input pin_product,
                    input usr_userid,
                    input usr_access_loc,
                    input no,
                    output l_undo)"}

               if not l_undo then
                  run createApplicationList
                     (input usr_userid,
                      input pin_product,
                      output l_active ).

            end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* for each */

         end.

      end.

      /*DISPLAY EXISTING RECORDS IN APPLICATION LIST */
      for each usrl_det
         where usrl_userid = usr_userid
      no-lock with frame c:
/*GUI*/ if global-beam-me-up then undo, leave.


         /* Validate Application and see if licensed */
         {gprunp.i "lvgenpl" "p" "validateApplicationRegistered"
            "(input  usrl_product,
              input  no,
              output l_appl_desc,
              output l-err-nbr)"}

         if usrl_active then
            l_active_date = usrl_active_date.
         else
            l_active_date = usrl_deactive_date.

         display
            usrl_product @ l_application
            l_appl_desc
            usrl_active  @ l_active
            l_active_date
            usrl__qadt01 when (usrl__qadt01 <> ?).
         down.

         {gpwait.i &INSIDELOOP=YES &FRAMENAME=c}

      end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH usrl_det */

      {gpwait.i &OUTSIDELOOP=YES}

      loopd :
      repeat with frame c on endkey undo, leave :
/*GUI*/ if global-beam-me-up then undo, leave.


         assign
            l_application = ""
            l_appl_desc   = "".

         set
            l_application
         editing:

            /* SCROLL BY UP/DOWN ARROWS TO SEE APPLICATIONS AVAILABLE */
            {mfnp.i pin_mstr l_application pin_product l_application pin_product
               pin_product}

            if recno <> ?
            then do :

               for first lpm_mstr where lpm_product = pin_product
               no-lock: end.

               if available lpm_mstr then do:

                  /* DO NOT DISPLAY ACTIVE/INACTIVE STATUS FOR */
                  /* APPLICATIONS NOT ATTACHED TO THE USER     */
                  display
                     lpm_product @ l_application
                     lpm_desc    @ l_appl_desc
                     ""          @ l_active.

                  /* DISPLAY ACTIVE/INACTIVE STATUS AS APPLICATIONS */
                  /* ARE SCROLLED BY UP/DOWN ARROW                  */
                  for first usrl_det
                     where usrl_userid  = usr_userid
                     and   usrl_product = lpm_product
                  no-lock:

                     if usrl_active then
                        l_active_date = usrl_active_date.
                     else
                        l_active_date = usrl_deactive_date.

                     display
                        usrl_active @ l_active
                        l_active_date
                        usrl__qadt01
                     with frame c.

                  end. /* FOR FIRST usrl_det */

               end. /* if available lpm_mstr */

            end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* IF recno <> ? */

         end. /* EDITING */

         if l_application = ""
         then do:
            /* BLANK NOT ALLOWED */
            {pxmsg.i &MSGNUM=40  &ERRORLEVEL=3}
            undo loopd, next loopd.
         end. /* IF l_application = "" */

         if l_application begins "X" then do:
            /* APPLICATION NOT FOUND IN LICENSED APPLICATION MASTER */
            {pxmsg.i &MSGNUM=5336 &ERRORLEVEL=3}
            undo loopd, next loopd.
         end.

         /* FIND IF BASE MODULE (MFG/PRO) IS AVAILABLE AND INACTIVE */
         if l_application <> "MFG/PRO"
         then do:

            for first usrl_det
               fields (usrl_userid usrl_product usrl_active)
                 where usrl_userid  = usr_userid
                   and usrl_product = "MFG/PRO"
            no-lock: end.

            if not available usrl_det
            then do:
               /* BASE MODULE NOT FOUND */
               {pxmsg.i &MSGNUM=5334  &ERRORLEVEL=3}
               undo loopd, retry loopd.
            end. /* IF NOT AVAILABLE usrl_det */

            else if usrl_active = no
            then do:
               /* BASE MODULE INACTIVE */
               {pxmsg.i &MSGNUM=5335  &ERRORLEVEL=3}
               undo loopd, retry loopd.
            end. /* IF usrl_active = NO */

         end. /* IF l_application <> "MFG/PRO" */

         /* Validate Application and see if licensed */
         {gprunp.i "lvgenpl" "p" "validateApplicationRegistered"
            "(input  l_application,
              input  yes,
              output l_appl_desc,
              output l-err-nbr)"}

         if return-value =  {&INVALID-LICENSE} then
            undo loopd, retry loopd.

         if new usrl_det then do:
            /* ADDING NEW RECORD */
            {pxmsg.i &MSGNUM=1  &ERRORLEVEL=1}
         end.

         /* CREATE usrl_det RECORD */
         run createApplicationList
            (input usr_userid,
             input l_application,
             output l_active ).

         ststatus = stline[2].
         status input ststatus.

         /* UPDATE l_active */
         loope:
         do on error undo, retry :
/*GUI*/ if global-beam-me-up then undo, leave.


            if l_active then
               l_active_date = usrl_active_date.
            else
               l_active_date = usrl_deactive_date.

            display
               l_appl_desc
               l_active
               l_active_date
            with frame c.

            set
               l_active.

            /* DEACTIVATING THE USER  FOR AN APPLICATION */
            if usrl_det.usrl_active  = yes
               and l_active = no
            then do:

               /* IF MFG/PRO IS DEACTIVATED, DEACTIVATE ALL OTHER */
               /* ACTIVE APPLICATIONS ATTACHED TO THE USER        */
               if l_application = "MFG/PRO"
               then do:

                  for each usrldet
                     where usrldet.usrl_userid = usr_userid
                       and usrldet.usrl_active =  yes
                  exclusive-lock:
                     assign
                        usrldet.usrl_active        = no
                        usrldet.usrl_deactive_by   = global_userid
                        usrldet.usrl_deactive_date = today
                        usrldet.usrl_mod_date      = today
                        usrldet.usrl_mod_userid    = global_userid.
                  end. /* FOR EACH usrldet */
               end. /* IF l_application = "MFG/PRO" */

               else do:

                  assign
                     usrl_det.usrl_active        = no
                     usrl_det.usrl_deactive_by   = global_userid
                     usrl_det.usrl_deactive_date = today
                     usrl_det.usrl_mod_date      = today
                     usrl_det.usrl_mod_userid    = global_userid.

                  display today @ l_active_date.

               end.
            end. /* IF usrl_active = yes AND ... */

            /* ACTIVATE/REACTIVATE THE USER */
            if (usrl_det.usrl_active = no and l_active = yes) or
               new usrl_det
            then do:

               /* PERFORM LICENSED USER COUNTING AND VALIDATION */
               {gprunp.i "lvgenpl" "p" "validateDefinedUserCount"
                  "(input l_application,
                    input usrl_det.usrl_userid,
                    input usr_access_loc,
                    input yes,
                    output l_undo)"}

               if l_undo then
                  undo loope, retry loope.

               assign
                  usrl_det.usrl_active      = l_active
                  usrl_det.usrl_active_date = today
                  usrl_det.usrl_mod_date    = today
                  usrl_det.usrl_mod_userid  = global_userid.

               display today @ l_active_date.

            end. /* IF (usrl_det.usrl_active = NO AND ... */

            down with frame c.

         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* LOOPE */

      end.    /* LOOPD */

      ans = yes.
      /* IS ALL INFORMATION CORRECT */
      {pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=ans}

      if not ans then do:
         hide frame c.
         clear frame b.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
         view frame b.
         undo loopa, retry loopa.
      end. /* IF NOT ans */
      else do:
         hide frame c.
         view frame b.
      end.

      /* Check that the password has been updated and that the previous */
      /* password does not match the new password. If so, update the    */
      /* password and last modified date and issue message.             */
      if user_passwd <> usr_passwd and
         encode(user_passwd) <> usr_passwd
      then do:
         usr_passwd = encode(user_passwd).
         usr_last_date = today.
         display usr_last_date with frame b.
         /* Change password process complete */
         {pxmsg.i &MSGNUM=720 &ERRORLEVEL=1}
      end. /* IF user_passwd <> "" */

      /*Menu Substitution switch is stored temporarily in uip__qad01*/
      /*as a character representation a boolean value.              */
      if l-ui-menu-sub
      then
         uip_mstr.uip__qad01 = "TRUE".
      else
         uip_mstr.uip__qad01 = "FALSE".

      if usr_mstr.usr_userid = global_userid
      then do:
         if l-ui-menu-sub
         then
            assign
               global-menu-substitution    = true
               global-do-menu-substitution = true.
         else
            assign
               global-menu-substitution    = false
               global-do-menu-substitution = false.
      end. /*IF usr_mstr.usr_userid = global_userid */

      leave innerloop.

   end. /*INNERLOOP*/

   {gpaud2.i
      &uniq_num1 = 01
      &uniq_num2 = 02
      &db_file = usr_mstr
      &db_field = usr_userid
      &db_field1 = """"}

end. /*LOOPA*/

{gpaud3.i
   &uniq_num1 = 01
   &uniq_num2 = 02
   &db_file   = usr_mstr
   &db_field  = usr_userid}

PROCEDURE checkLocationLicenses :
/* -------------------------------------------------------------------------
   Purpose :  If the user's access location changes, we need to check
              if all authorized products with Location License are still in
              Compliance
   Parameters : input userid and access location
                output p_undo
   Notes:
  -------------------------------------------------------------------------*/
   define input  parameter p_userid  like usr_userid     no-undo.
   define input  parameter p_userLoc like usr_access_loc no-undo.
   define output parameter p_undo   as   logical         no-undo.

   define variable l_licenseType    as   integer    no-undo.
   define variable l_licenseDesc    as   character  no-undo.

   define buffer usrl_det for usrl_det.

   p_undo = no.

   appsloop:
   for each usrl_det where usrl_userid = p_userid
   no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.


      /* Get the License Type */
      {gprunp.i "lvgenpl" "p" "getLicenseType"
         "(input usrl_product,
           input no,
           output l_licenseType,
           output l_licenseDesc)"}

      /* If this is a Location License, validate the Count */
      if l_licenseType = {&LOCATION-USERS} then do:
         {gprunp.i "lvgenpl" "p" "validateDefinedUserCount"
            "(input usrl_product,
              input usrl_userid,
              input p_userLoc,
              input yes,
              output p_undo)"}
      end.

      if p_undo then
         leave appsloop.

   end.
/*GUI*/ if global-beam-me-up then undo, leave.


END PROCEDURE.

PROCEDURE createApplicationList :
/* -------------------------------------------------------------------------
   Purpose :  Create new Application List record or get active/inactive
              status for existing record.
   Parameters : Userid, application name, output l_active
   Notes:
  -------------------------------------------------------------------------*/
   define input  parameter p_userid      like usr_userid no-undo.
   define input  parameter p_application like usrl_product no-undo.
   define output parameter p_active      like mfc_logical no-undo.

   for first usrl_det
      where usrl_userid  = p_userid
      and   usrl_product = p_application
   exclusive-lock: end.

   if not available usrl_det
   then do:
      create usrl_det.
      assign
         usrl_userid       = p_userid
         usrl_product      = p_application
         usrl_active       = yes
         usrl_active_date  = today
         usrl_mod_userid   = global_userid
         usrl_mod_date     = today
         p_active          = yes.
      if recid(usrl_det)   = -1
      then .
   end. /* IF NOT AVAILABLE usrl_det  */
   else
      p_active = usrl_active.

END PROCEDURE.
