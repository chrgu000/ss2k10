/* GUI CONVERTED from reschex.p (converter v1.75) Sat Aug 12 23:08:54 2000 */
/* reschex.p  - REPETITIVE   REPETITIVE SCHEDULE EXPLODE                      */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*J07G* *F0PN* *V 8:Convert Mode=Full GUIReport                         */
/*J07G*/ /*V8:ConvertMode=Report                                        */
/*J23R*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 7.3               LAST MODIFIED: 10/31/94   BY: WUG *GN77*       */
/* REVISION: 8.5               LAST MODIFIED: 05/12/95   BY: pma *J04T*       */
/* REVISION: 8.5               LAST MODIFIED: 09/05/95   BY: srk *J07G*       */
/* REVISION: 8.5               LAST MODIFIED: 03/13/96   BY: jym *G1PZ*       */
/* REVISION: 8.5               LAST MODIFIED: 06/20/96   BY: taf *J0VG*       */
/* REVISION: 8.6           LAST MODIFIED: 02/27/98   BY: *J23R* Santhosh Nair */
/* REVISION: 8.6           LAST MODIFIED: 05/23/98   BY: *H1L6* Thomas Ferns  */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00 BY: *N0KP* myb                  */
/* REVISION: 9.1      LAST MODIFIED: 07/06/04 BY: *zhxxx* mage                 */


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

         {mfdtitle.i "b+ "}

         define variable part like wo_part.
         define variable part1 like wo_part label {t001.i}.
         define variable site like wo_site.
         define variable site1 like wo_site label {t001.i}.
         define variable line like wo_line.
         define variable line1 like wo_line label {t001.i}.
/*J23R*/ define new shared buffer gl_ctrl for gl_ctrl.

/*H1L6*/ {rescttdf.i "new shared"}

         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
 /*           
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
 */
part                 colon 20
            part1                colon 45
            site                 colon 20
            site1                colon 45
            line                 colon 20
            line1                colon 45
         with frame a side-labels width 80 attr-space. 
	 /* NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/
*/
/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).

         find mfc_ctrl where mfc_field = "rpc_using_new" no-lock no-error.
         if not available mfc_ctrl or mfc_logical = false then do:
            {mfmsg.i 5119 3}
            message.
            message.
            leave.
         end.

        /* DO NOT RUN PROGRAM UNLESS QAD_WKFL RECORDS HAVE */
        /* BEEN CONVERTED SO THAT QAD_KEY2 HAS NEW FORMAT  */
/*G1PZ*/ if can-find(first qad_wkfl where qad_key1 = "rpm_mstr") then do:
/*G1PZ*/   {mfmsg.i 5126 3}
/*G1PZ*/   message.
/*G1PZ*/   message.
/*G1PZ*/   leave.
/*G1PZ*/ end.

/*J04T*/ mainloop:
         repeat:
            if part1 = hi_char then part1 = "".
            if site1 = hi_char then site1 = "".
            if line1 = hi_char then line1 = "".

            update
               part
               part1
               site
               site1
               line
               line1
            with frame a.

/*J07G*     ** PUT THESE BACK WHERE YOU FOUND THEM **
 * /*J04T*/    /* MOVED HI_CHAR SETTINGS ABOVE MFQUOTER CALLS*/
 * /*J04T*/    if part1 = "" then part1 = hi_char.
 * /*J04T*/    if site1 = "" then site1 = hi_char.
 * /*J04T*/    if line1 = "" then line1 = hi_char.
 *J07G*/

            bcdparm = "".
            {mfquoter.i part}
            {mfquoter.i part1}
            {mfquoter.i site}
            {mfquoter.i site1}
            {mfquoter.i line}
            {mfquoter.i line1}

/*J04T*/    /* MOVED HI_CHAR SETTINGS ABOVE MFQUOTER CALLS*****************
 *          if part1 = "" then part1 = hi_char.
 *          if site1 = "" then site1 = hi_char.
 *          if line1 = "" then line1 = hi_char.
/*J04T*/    **************************************************************/

/*J07G*/    /*THESE SHOULD BE HERE. THEY NEVER SHOULD HAVE BEEN MOVED*/
            if part1 = "" then part1 = hi_char.
            if site1 = "" then site1 = hi_char.
            if line1 = "" then line1 = hi_char.

/*J0VG********** MOVED BELOW HI_CHAR SETTING *************************/
/*J04T*/    /*SITE (RANGE-OF) SECURITY CHECK*/
/*J04T*/   if not batchrun then do:
/*J04T*/       {gprun.i ""gpsirvr.p""
                "(input site, input site1, output return_int)"}
/*J04T*/       if return_int = 0 then do:
/*J04T*/          next-prompt site with frame a.
/*J04T*/          undo mainloop, retry mainloop.
/*J04T*/       end.
/*J04T*/   end.
/*J0VG********** MOVED BELOW HI_CHAR SETTING *************************/

            {mfselbpr.i "printer" 132}
/* /*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2. */

            {mfphead.i}

/*zhxxx*/            {gprun.i ""xxreschexa.p""
            "(input part, input part1, input site, input site1,
            input line, input line1, input yes)"}

            {mfrtrail.i}
         end.
