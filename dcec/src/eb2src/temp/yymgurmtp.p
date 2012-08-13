/* GUI CONVERTED from mgurmtp.p (converter v1.76) Mon Jul  8 16:03:32 2002 */
/* mgurmtp.p - USER PASSWORD MAINTENANCE                                      */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.10.1.10 $                                                      */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.0      LAST MODIFIED: 06/24/92   BY: rwl *F675*                */
/* REVISION: 7.3      LAST MODIFIED: 02/11/93   BY: rwl *G671*                */
/* REVISION: 7.3      LAST MODIFIED: 02/12/93   BY: mpp *G679*                */
/* REVISION: 7.3      LAST MODIFIED: 02/22/93   BY: rwl *G727*                */
/* REVISION: 7.5      LAST MODIFIED: 01/06/95   BY: mwd *J034*                */
/* REVISION: 8.5      LAST MODIFIED: 08/13/96   BY: taf *H0MB*                */
/* REVISION: 8.5          OBSOLETED: 12/10/96   BY: jpm *J1BK*                */
/* REVISION: 8.5         REINSTATED: 08/20/97   BY: *J1XP* Cynthia Terry      */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KR* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.10.1.2      BY: Katie Hilbert     DATE: 11/03/01  ECO: *P00B*  */
/* Revision: 1.10.1.3      BY: Vinod Nair        DATE: 03/18/02  ECO: *N1D5*  */
/* Revision: 1.10.1.4      BY: Jean Miller       DATE: 04/11/02  ECO: *P05F*  */
/* Revision: 1.10.1.7      BY: Jean Miller       DATE: 06/19/02  ECO: *P09H*  */
/* $Revision: 1.10.1.10 $   BY: Katie Hilbert     DATE: 07/01/02  ECO: *P0B1*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*cj* add password security control*/
{mfdtitle.i "2+ "}

define variable ans         like mfc_logical no-undo.
define variable user_passwd like usr_passwd no-undo.
define variable l-confirm-passwd like usr_passwd label "Confirm Password"
   no-undo.

{mf1.i}


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
usr_userid  colon 10
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
usr_name           colon 12
   usr_lang           colon 12
   user_passwd        colon 12
   usr_last_date      colon 60
   usr_groups         colon 12  view-as editor no-box size 63 by 2
   usr_restrict       colon 12
 SKIP(.4)  /*GUI*/
with frame b side-labels width 80 attr-space THREE-D /*GUI*/.

 DEFINE VARIABLE F-b-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
 RECT-FRAME-LABEL:HIDDEN in frame b = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame b =
  FRAME b:HEIGHT-PIXELS - RECT-FRAME:Y in frame b - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME b = FRAME b:WIDTH-CHARS - .5.  /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
l-confirm-passwd colon 23
 SKIP(.4)  /*GUI*/
with frame conf-passwd overlay side-labels
width 45 attr-space column 20 row 8 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-conf-passwd-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame conf-passwd = F-conf-passwd-title.
 RECT-FRAME-LABEL:HIDDEN in frame conf-passwd = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame conf-passwd =
  FRAME conf-passwd:HEIGHT-PIXELS - RECT-FRAME:Y in frame conf-passwd - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME conf-passwd = FRAME conf-passwd:WIDTH-CHARS - .5.  /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame conf-passwd:handle).

{gpaud.i &uniq_num1 = 01
   &uniq_num2 = 02
   &db_file = usr_mstr
   &db_field = usr_addr}

loopa:
do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.


   innerloop:
   repeat on endkey undo, leave loopa:
/*GUI*/ if global-beam-me-up then undo, leave.


      display global_userid @ usr_userid with frame a.

      find usr_mstr where usr_userid = global_userid
      exclusive-lock no-error.

      if not available usr_mstr then do:
         /* User ID not found in file */
         {pxmsg.i &MSGNUM=5538 &ERRORLEVEL=4}
         pause.
         leave loopa.
      end.

      {gpaud1.i &uniq_num1 = 01
         &uniq_num2 = 02
         &db_file = usr_mstr
         &db_field = usr_addr}

      user_passwd = usr_passwd.

      display
         usr_name
         usr_lang
         usr_last_date
         usr_groups
         usr_restrict
      with frame b.

      loopb:
      do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


         set
            usr_name
            usr_lang
            user_passwd blank
         with frame b.

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
               undo loopb, retry loopb.
          end.
/*cj*add*end*/

            display
               l-confirm-passwd
            with frame conf-passwd.

            set
               l-confirm-passwd blank
            with frame conf-passwd.

            hide frame conf-passwd.

            if l-confirm-passwd <> user_passwd
            then do:
               /* PASSWORDS DO NOT MATCH */
               {pxmsg.i &MSGNUM=5548 &ERRORLEVEL=3}
               user_passwd:screen-value = "".
               next-prompt user_passwd with frame b.
               undo loopb, retry loopb.
            end. /* IF l-confirm-passwd <> user_passwd */

         end. /* IF user_passwd <> "" */

      end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* LOOPB */

      /* ASK TO CONTINUE */
      ans = yes.
      {pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=ans
               &CONFIRM-TYPE='LOGICAL'}
      if not ans then do:
         clear frame a.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
         clear frame b.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
         undo loopa, retry loopa.
      end.

      /* Check that the password has been updated and that the previous */
      /* password does not match the new password. If so, update the    */
      /* password and exit.                                             */
      if user_passwd <> usr_passwd and
         encode(user_passwd) <> usr_passwd
      then
         assign
            usr_passwd = encode(user_passwd)
            usr_last_date = today.

      leave innerloop.

   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /*INNERLOOP*/

   {gpaud2.i &uniq_num1 = 01
      &uniq_num2 = 02
      &db_file = usr_mstr
      &db_field = usr_addr
      &db_field1 = """"}

end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* LOOPA */

{gpaud3.i &uniq_num1 = 01
   &uniq_num2 = 02
   &db_file = usr_mstr
   &db_field = usr_addr}
