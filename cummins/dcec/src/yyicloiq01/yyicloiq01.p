/* GUI CONVERTED from icloiq01.p (converter v1.78) Fri Oct 29 14:37:07 2004 */
/* icloiq01.p - LOCATION PART INQUIRY                                         */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.14 $                                                          */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 6.0      LAST MODIFIED: 05/11/90   BY: PML */
/* REVISION: 6.0      LAST MODIFIED: 05/18/90   BY: WUG */
/* REVISION: 6.0      LAST MODIFIED: 10/03/91   BY: alb *D887**/
/* REVISION: 7.0      LAST MODIFIED: 04/06/92   BY: pma *F361**/
/* REVISION: 7.0      LAST MODIFIED: 05/26/92   BY: pma *F528**/
/* REVISION: 7.0      LAST MODIFIED: 07/09/92   BY: pma *F751**/
/* REVISION: 7.0      LAST MODIFIED: 07/15/92   BY: pma *F767**/
/* REVISION: 7.0      LAST MODIFIED: 09/15/92   BY: pma *F897**/
/* Revision: 7.3        Last edit: 11/19/92     By: jcd *G339* */
/* REVISION: 7.3      LAST MODIFIED: 12/23/93   BY: ais *GI30**/
/* REVISION: 7.3      LAST MODIFIED: 09/14/94   BY: pxd *FR03**/
/* REVISION: 7.3      LAST MODIFIED: 03/09/95   BY: pxd *F0LZ**/
/* REVISION: 8.6      LAST MODIFIED: 02/17/98   BY: *K1HQ* Beena Mol          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 04/14/00   BY: *L0W4* Kirti Desai        */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 09/18/00   BY: *N0S1* Dave Caveney       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.12  BY: Jean Miller DATE: 04/06/02 ECO: *P056* */
/* $Revision: 1.14 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00G* */
/* $Revision:eb21sp12  $ BY: Jordan Lin            DATE: 09/19/12  ECO: *SS-20120919.1*   */

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

{mfdtitle.i "120919.1"}

define variable part like pt_part.
define variable loc like ld_loc.
define variable site like ld_site.
define variable stat  like ld_status.
define variable lot like ld_lot.
define variable lotref like ld_ref.

find first icc_ctrl  where icc_ctrl.icc_domain = global_domain no-lock no-error.

if available icc_ctrl and global_site = "" then
   global_site = icc_site.

part = global_part.
site = global_site.


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   part
   site
   loc
   lot
   stat
with frame a no-underline width 80 THREE-D /*GUI*/.

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}

repeat:

   if c-application-mode <> 'web' then
      update part site loc lot stat with frame a
   editing:

      assign
         global_part = input part
         global_site = input site
         global_loc  = input loc.

      if frame-field = "part" then do:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i pt_mstr part  " pt_mstr.pt_domain = global_domain and pt_part
         "  part pt_part pt_part}
         if recno <> ? then do:
            part = pt_part.
            display part with frame a.
         end.
      end.

      else if frame-field = "site" then do:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i si_mstr site  " si_mstr.si_domain = global_domain and si_site
         "  site si_site si_site}
         if recno <> ? then do:
            site = si_site.
            display site with frame a.
         end.
      end.

      else do:
         status input.
         readkey.
         apply lastkey.
      end.

   end.

   {wbrp06.i &command = update &fields = "  part site loc lot stat"
      &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      /* Check for exiting item number */
      if not can-find(first pt_mstr  where pt_mstr.pt_domain = global_domain
      and  pt_part = part) then do:
         {pxmsg.i &MSGNUM=16  &ERRORLEVEL=3}
         if c-application-mode = 'web' then return.
         else next-prompt part with frame a.
         undo.
      end.
      hide frame b.
      hide frame c.

   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "terminal"
               &printWidth = 80
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

   loopa:
   for each in_mstr  where in_mstr.in_domain = global_domain and (  in_part =
   part
         and (in_site = site or site = "")
         and (can-find(first ld_det  where ld_det.ld_domain = global_domain and
         (  ld_part = in_part
         and ld_site = in_site
         and ld_loc = loc)) or loc = "")
   ) no-lock:

      
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/


      find pt_mstr no-lock  where pt_mstr.pt_domain = global_domain and
      pt_part = in_part.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).

      display
 /* *SS-20120919.1*   */         pt_desc2
         in_site
         pt_um
         space(3)
         in_qty_oh column-label "QOH Nettable" format "->>>,>>>,>>9.9<<<<<<<<<"
         space(3)
         in_qty_nonet format "->>>,>>>,>>9.9<<<<<<<<<"
      with no-underline frame b width 80 STREAM-IO /*GUI*/ .

      for each ld_det no-lock  where ld_det.ld_domain = global_domain and (
      ld_part = pt_part
            and ld_site = in_site
            and (ld_loc = loc or loc = "" )
            and (ld_status = stat or stat = "")
            and (ld_lot = lot or lot = "")
      ) on endkey undo, leave loopa with frame c width 80:

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame c:handle).

         
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/


         find is_mstr  where is_mstr.is_domain = global_domain and  is_status
         = ld_status no-lock no-error.

         display
            ld_loc
            ld_lot    column-label "Lot/Serial!Ref"
            ld_status
            ld_date   column-label "Created!Expire"
            ld_qty_oh format "->>>,>>>,>>9.9<<<<<<<<<"
            ld_grade WITH STREAM-IO /*GUI*/ .

         if available is_mstr then display is_net format "/no" WITH STREAM-IO /*GUI*/ .

         if ld_ref <> "" or ld_expire <> ? then do with frame c:
            down 1.

            display
               ld_ref format "x(8)" @ ld_lot
               ld_expire            @ ld_date WITH STREAM-IO /*GUI*/ .
         end.

      end.

   end.

   global_part = part.
   global_site = site.

   {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}

end.

{wbrp04.i &frame-spec = a}
