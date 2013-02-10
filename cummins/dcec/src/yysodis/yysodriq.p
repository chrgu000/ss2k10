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

define variable pclist     like pc_list      no-undo.
define variable itemnbr    like pt_part      no-undo.
define variable cmname     like ad_name      no-undo.
define variable i          as integer        no-undo.
define variable curr       like pc_curr      no-undo.
define variable start_dt   like pc_start     no-undo.
define variable end_dt     like pc_expire    no-undo.


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   pclist
   curr
   itemnbr
   start_dt
   end_dt
with frame a no-underline width 80 attr-space THREE-D /*GUI*/.

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}

repeat:

   if c-application-mode <> 'web' then
      update
         pclist
         curr
         itemnbr
         start_dt
         end_dt
      with frame a.

   {wbrp06.i &command = update &fields = "pclist curr itemnbr  start_dt end_dt " &frm = "a"}

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

      for each yp_mstr
         where yp_domain = global_domain 
          and (yp_list = pclist or pclist = "")
          and (yp_curr = curr or curr = "")
          and (yp_part >= itemnbr)
          no-lock
      with frame b width 600 no-attr-space:
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame b:handle).
         assign cmname = "".
         find first cm_mstr no-lock where cm_domain = global_domain 
         				and cm_addr = yp_cust no-error.
         if availabl cm_mstr then do:
         		assign cmname = cm_sort.
         end.
/*GUI* / {mfguichk.i } / *Replace mfrpchk*/
			display 
							yp_list
							yp_curr
							yp_part
							yp_cust
							cmname
							yp_market
/*                             yysalesdisc_part */
/*                             yysalesdisc_um   */
							yp_start
							yp_expir
							yp_amt_type
							yp_min_qty[1]
							yp_amt[1]
							yp_min_qty[2]
							yp_amt[2]
							yp_min_qty[3]
							yp_amt[3]
							yp_min_qty[4]
							yp_amt[4]
							yp_min_qty[5]
							yp_amt[5].
							down.
		 display	yp_min_qty[6] @ yp_min_qty[1]
							yp_amt[6] @ yp_amt[1]
							yp_min_qty[7]  @ yp_min_qty[2]
							yp_amt[7]  @ yp_amt[2]
							yp_min_qty[8] @ yp_min_qty[3]
							yp_amt[8] @ yp_amt[3]
							yp_min_qty[9]  @ yp_min_qty[4]
							yp_amt[9] @ yp_amt[4]
							yp_min_qty[10]  @ yp_min_qty[5]
							yp_amt[10] @ yp_amt[5].
							down.
	    display yp_min_qty[11]  @ yp_min_qty[1]
							yp_amt[11] @ yp_amt[1]
							yp_min_qty[12]  @ yp_min_qty[2]
							yp_amt[12] @ yp_amt[2]
							yp_min_qty[13]  @ yp_min_qty[3]
							yp_amt[13] @ yp_amt[3]
							yp_min_qty[14]  @ yp_min_qty[4]
							yp_amt[14] @ yp_amt[4]
							yp_min_qty[15]  @ yp_min_qty[5]
							yp_amt[15] @ yp_amt[5]
							with stream-io.
 
   end.
   {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}
end.

{wbrp04.i &frame-spec = a}

