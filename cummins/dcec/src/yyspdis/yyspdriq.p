/* GUI CONVERTED from pppciq.p (converter v1.78) Fri Oct 29 14:37:37 2004 */
/* pppciq.p - PRICE LIST INQUIRY                                        */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.12 $                                                     */
/*V8:ConvertMode=Report                                                 */
/* REVISION: 6.0      LAST MODIFIED: 02/20/91   BY: afs *D355**/
/* REVISION: 7.3      LAST MODIFIED: 11/04/92   BY: afs *G244**/
/* REVISION: 7.3      LAST MODIFIED: 11/19/92   By: jcd *G339**/
/* REVISION: 7.4      LAST MODIFIED: 09/01/94   BY: afs *H502**/
/* REVISION: 7.4      LAST MODIFIED: 10/17/94   BY: afs *FS51**/
/* REVISION: 8.6      LAST MODIFIED: 11/10/99   BY: bvm *K19B**/
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb              */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.11     BY: Paul Donnelly (SB)  DATE: 06/28/03  ECO: *Q00K*     */
/* $Revision: 1.12 $    BY: Katie Hilbert       DATE: 10/17/03  ECO: *Q04B*   */
/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE          */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "121110.1"}

define variable entity     like en_entity    no-undo.
define variable i          as integer        no-undo.
define variable curr       like pc_curr      no-undo.
define variable cust       like cm_addr      no-undo.
define variable cmname     like ad_name      no-undo.
define variable end_dt     like pc_expire    no-undo.

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/
   entity
   cust
   curr
with frame a no-underline width 80 attr-space THREE-D /*GUI*/.

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}

repeat:

   if c-application-mode <> 'web' then
      update
         entity
         cust
         curr
      with frame a.

   {wbrp06.i &command = update &fields = "entity cust curr" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      hide frame b.
      hide frame c.
      hide frame d.
      hide frame e.
   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "terminal"
               &printWidth = 223
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "no"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}

      for each yyspares_disc
         where yysparesdisc_domain = global_domain
          and (yysparesdisc_entity = entity or entity = "")
          and (yysparesdisc_cust = cust  or cust = "")
          and (yysparesdisc_curr = curr or curr = "")
          no-lock
      with frame b width 223 no-attr-space:
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame b:handle).
         assign cmname = "".
         find first cm_mstr no-lock where cm_domain = global_domain
                and cm_addr = yysparesdisc_cust no-error.
         if availabl cm_mstr then do:
            assign cmname = cm_sort.
         end.
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
      display yysparesdisc_entity
              yysparesdisc_cust
              cmname
              yysparesdisc_curr
              yysparesdisc_effdate
              yysparesdisc_due_date
              yysparesdisc_ovh_mtl
              yysparesdisc_service
              with stream-io.

   end.
   {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}
end.

{wbrp04.i &frame-spec = a}
