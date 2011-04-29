/* woworl01.p - RELEASE / PRINT WORK ORDERS SELECT RANGE OF ORDERS      */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.15 $                                                    */
/*V8:ConvertMode=Report                                                 */
/* REVISION: 6.0      LAST MODIFIED: 05/10/90   BY: mlb *D024*          */
/* REVISION: 6.0      LAST MODIFIED: 07/06/90   BY: emb *D040*          */
/* REVISION: 6.0      LAST MODIFIED: 08/24/90   BY: wug *D054*          */
/* REVISION: 6.0      LAST MODIFIED: 03/14/91   BY: emb *D413*          */
/* REVISION: 6.0      LAST MODIFIED: 07/02/91   BY: emb *D741*          */
/* REVISION: 6.0      LAST MODIFIED: 07/23/91   BY: ram *D787*          */
/* REVISION: 6.0      LAST MODIFIED: 10/07/91   BY: alb *D887*(rev only)*/
/* REVISION: 6.0      LAST MODIFIED: 10/17/91   BY: emb *D900*          */
/* REVISION: 7.0      LAST MODIFIED: 04/01/92   BY: ram *F351*          */
/* REVISION: 7.0      LAST MODIFIED: 09/14/92   BY: ram *F896*          */
/* REVISION: 7.3      LAST MODIFIED: 09/27/93   BY: jcd *G247*          */
/* REVISION: 7.3      LAST MODIFIED: 11/03/92   BY: emb *G268*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 03/25/93   BY: emb *G870*          */
/* REVISION: 7.3      LAST MODIFIED: 04/29/93   BY: ksp *GA63*(rev only)*/
/* REVISION: 7.3      LAST MODIFIED: 06/01/93   BY: qzl *GB43*          */
/* REVISION: 7.3      LAST MODIFIED: 09/01/94   BY: ljm *FQ67*          */
/* REVISION: 7.5      LAST MODIFIED: 10/05/94   BY: taf *J035*          */
/* REVISION: 7.3      LAST MODIFIED: 10/31/94   BY: WUG *GN76*          */
/* REVISION: 7.5      LAST MODIFIED: 02/07/95   BY: tjs *J027*          */
/* REVISION: 7.3      LAST MODIFIED: 11/20/95   BY: rvw *G1DW*          */
/* REVISION: 8.5      LAST MODIFIED: 06/10/96   BY: sxb *J0RK*                */
/* REVISION: 8.5      LAST MODIFIED: 06/11/96   BY: rvw *G1XY*                */
/* REVISION: 8.5      LAST MODIFIED: 02/04/97   BY: *J1GW* Julie Milligan     */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 01/31/00   BY: *J3NZ* Kirti Desai        */
/* REVISION: 9.0      LAST MODIFIED: 02/23/00   BY: *M0JN* Kirti Desai        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* myb                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.12     BY: Katie Hilbert         DATE: 04/05/01 ECO: *P008*    */
/* Revision: 1.13  BY: Inna Fox DATE: 06/13/02 ECO: *P04Z* */
/* $Revision: 1.15 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00N* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "2+ "}

define new shared variable comp like ps_comp.
define new shared variable qty as decimal.
define new shared variable eff_date as date.
define new shared variable wo_recno as recid.
define new shared variable leadtime like pt_mfg_lead.
define new shared variable prev_status like wo_status.
define new shared variable prev_release like wo_rel_date.
define new shared variable prev_due like wo_due_date.
define new shared variable prev_qty like wo_qty_ord.
define new shared variable del-yn like mfc_logical initial no.
define new shared variable deliv like wod_deliver.
define new shared variable barcode like mfc_logical
   label "Print Bar Code".
define new shared variable wo_des like pt_desc1.
define new shared variable wo_qty like wo_qty_ord.
define new shared variable wo_um like pt_um.
define new shared variable wc_description like wc_desc.
define new shared variable critical-part  like wod_part    no-undo.
define new shared variable critical_flg   like mfc_logical no-undo.
define new shared variable prd_recno as recid.
define new shared variable joint_type like wo_joint_type.
define new shared variable wonbr like wo_nbr.
define new shared variable wonbr1 like wo_nbr.
define new shared variable wolot like wo_lot.
define new shared variable wolot1 like wo_lot.
define new shared variable part like wo_part.
define new shared variable part1 like wo_part.
define new shared variable woreldate like wo_rel_date.
define new shared variable woreldate1 like wo_rel_date.
define new shared variable wotype like wo_type.
define new shared variable planner  like pt_buyer.
define new shared variable planner1 like pt_buyer.
define new shared variable wostatus like wo_status.
define new shared variable ptplanner like pt_buyer.
define new shared variable ptphantom like pt_phantom.
define new shared variable move like woc_move.
define new shared variable print_pick like mfc_logical
   label "Print Picklist" initial yes.
define new shared variable print_rte like mfc_logical
   label "Print Routing" initial yes.
define new shared variable print_jp like mfc_logical
   label "Print Co/By-Products" initial yes.
define new shared variable phantom like mfc_logical initial no
   label "Include Phantom Items".
define new shared variable wobatch like wo_batch.
define new shared variable wobatch1 like wo_batch.
define new shared variable site  like wo_site no-undo.
define new shared variable site1 like wo_site no-undo.

{mfworlb1.i &new="new" &row="13"}

eff_date = today.

find first woc_ctrl  where woc_ctrl.woc_domain = global_domain no-lock no-error.
if available woc_ctrl then move = woc_move.
release woc_ctrl.

form
   skip (1)
   wonbr          colon 20
   wonbr1         colon 45 label {t001.i}
   wolot          colon 20
   wolot1         colon 45 label {t001.i}
   wobatch        colon 20
   wobatch1       colon 45 label {t001.i}
   woreldate      colon 20
   woreldate1     colon 45 label {t001.i}
   part           colon 20
   part1          colon 45 label {t001.i}
   site           colon 20
   site1          colon 45 label {t001.i}
   planner        colon 20
   planner1       colon 45 label {t001.i}
   skip (1)
   wostatus       colon 40
   wotype         colon 40
   print_pick     colon 40
   print_rte      colon 40
   print_jp       colon 40
   barcode        colon 40
   move           colon 40
   phantom        colon 40
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

wostatus = "F".

repeat with frame a:

   if wonbr1     = hi_char  then wonbr1     = "".
   if wolot1     = hi_char  then wolot1     = "".
   if wobatch1   = hi_char  then wobatch1   = "".
   if woreldate1 = hi_date  then woreldate1 = ?.
   if woreldate  = low_date then woreldate  = ?.
   if part1      = hi_char  then part1      = "".
   if site1      = hi_char  then site1      = "".
   if planner1   = hi_char  then planner1   = "".

   if not batchrun then do:
      update
         wonbr wonbr1
         wolot wolot1
         wobatch wobatch1
         woreldate woreldate1
         part part1
         site site1
         planner planner1
         wostatus
         wotype
         print_pick
         print_rte
         print_jp
         barcode
         move
         phantom.

      /* Order Type Flow not allowed. */
      if wotype = "W" then do:
         {pxmsg.i &MSGNUM=5288 &ERRORLEVEL=3}
         next-prompt wotype with frame a.
         undo, retry.
      end.

      if print_pick or print_jp then
         update
            incl_zero_reqd  when (print_pick)
            incl_zero_open  when (print_pick)
            incl_pick_qtys  when (print_pick)
            incl_floor_stk  when (print_pick)
            jp_1st_last_doc when (print_jp)
         with frame a1.
   end.
   else do:
      update
         wonbr wonbr1
         wolot wolot1
         wobatch wobatch1
         woreldate woreldate1
         part part1
         site site1
         planner planner1
         wostatus
         wotype
         print_pick
         print_rte
         print_jp
         barcode
         move
         phantom
         incl_zero_reqd
         incl_zero_open
         incl_pick_qtys
         incl_floor_stk
         jp_1st_last_doc
      with frame batch.

      display
         wonbr wonbr1
         wolot wolot1
         wobatch wobatch1
         woreldate woreldate1
         part part1
         site site1
         planner planner1
         wostatus
         wotype
         print_pick
         print_rte
         barcode
         move
         phantom
         print_jp
      with frame a.
   end.

   if wostatus = "" then do:
      {pxmsg.i &MSGNUM=544 &ERRORLEVEL=2}
   end.

   bcdparm = "".
   {mfquoter.i wonbr  }
   {mfquoter.i wonbr1 }
   {mfquoter.i wolot  }
   {mfquoter.i wolot1 }
   {mfquoter.i wobatch  }
   {mfquoter.i wobatch1 }
   {mfquoter.i woreldate}
   {mfquoter.i woreldate1}
   {mfquoter.i part   }
   {mfquoter.i part1  }
   {mfquoter.i site   }
   {mfquoter.i site1  }
   {mfquoter.i planner }
   {mfquoter.i planner1}
   {mfquoter.i wostatus}
   {mfquoter.i wotype  }
   {mfquoter.i print_pick}
   {mfquoter.i print_rte}
   {mfquoter.i print_jp}
   {mfquoter.i barcode}
   {mfquoter.i move}
   {mfquoter.i phantom}
   {mfquoter.i incl_zero_reqd}
   {mfquoter.i incl_zero_open}
   {mfquoter.i incl_pick_qtys}
   {mfquoter.i incl_floor_stk}
   {mfquoter.i jp_1st_last_doc}

   if wonbr1 = "" then wonbr1 = hi_char.
   if wolot1 = "" then wolot1 = hi_char.
   if wobatch1 = "" then wobatch1 = hi_char.
   if woreldate1 = ? then woreldate1 = hi_date.
   if woreldate = ? then woreldate = low_date.
   if part1 = "" then part1 = hi_char.
   if site1 = "" then site1 = hi_char.
   if planner1 = "" then planner1 = hi_char.

   /* FIND IF A SITE CANNOT BE ACCESSED BY A USER */
   {gprun.i ""gpsirvr.p"" "(input site, input site1, output return_int)"}
   if return_int = 0 then do:
      if c-application-mode = 'WEB' then return.
      next-prompt site with frame a.
      undo, retry.
   end. /* IF RETURN_INT = 0 */

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer" &printWidth = 80
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}

   /* SAVE prd_det RECID FOR BAR-CODES LATER */
   find prd_det where prd_dev = dev no-lock no-error.
   if available prd_det then prd_recno = recid(prd_det).

   {gprun.i ""woworl2.p""}

   /* REPORT TRAILER */
   {mfrtrail.i}

end.
