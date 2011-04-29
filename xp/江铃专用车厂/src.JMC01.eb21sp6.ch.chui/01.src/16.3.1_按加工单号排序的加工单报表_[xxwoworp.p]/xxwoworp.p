/* woworp.p - WORK ORDER REPORT                                               */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.18 $                                                         */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 1.0     LAST MODIFIED: 04/15/86    BY: pml                       */
/* REVISION: 1.0     LAST MODIFIED: 05/01/86    BY: emb                       */
/* REVISION: 2.1     LAST MODIFIED: 10/19/87    BY: wug *A94*                 */
/* REVISION: 2.1     LAST MODIFIED: 12/29/87    BY: emb                       */
/* REVISION: 4.0     LAST MODIFIED: 02/16/88    BY: flm *A175*                */
/* REVISION: 4.0     LAST MODIFIED: 03/23/88    BY: rl  *A171*                */
/* REVISION: 5.0     LAST MODIFIED: 04/10/89    BY: mlb *B096*                */
/* REVISION: 5.0     LAST MODIFIED: 10/26/89    BY: emb *B357*                */
/* REVISION: 5.0     LAST MODIFIED: 01/24/90    BY: ftb *B531*                */
/* REVISION: 5.0     LAST MODIFIED: 02/13/91    BY: emb *B893*                */
/* REVISION: 6.0     LAST MODIFIED: 01/22/91    BY: bjb *D248*                */
/* REVISION: 7.3     LAST MODIFIED: 11/19/92    BY: jcd *G348*                */
/* REVISION: 7.3     LAST MODIFIED: 04/23/93    BY: ram *GA24*                */
/* REVISION: 7.3     LAST MODIFIED: 09/23/94    BY: cpp *FQ88*                */
/* REVISION: 7.5     LAST MODIFIED: 10/07/94    BY: TAF *J035*                */
/* REVISION: 7.4     LAST MODIFIED: 03/29/95    BY: dzn *F0PN*                */
/* REVISION: 8.6     LAST MODIFIED: 10/13/97    BY: ays *K0WH*                */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane          */
/* REVISION: 8.6E    LAST MODIFIED: 10/04/98    BY: *J314* Alfred Tan         */
/* REVISION: 9.0     LAST MODIFIED: 01/21/99    BY: *M066* Patti Gaultney     */
/* REVISION: 9.0     LAST MODIFIED: 03/13/99    BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1     LAST MODIFIED: 08/12/00    BY: *N0KC* Mark Brown         */
/* REVISION: 9.1     LAST MODIFIED: 11/06/00    BY: *N0TN* Jean Miller        */
/* Revision: 1.13       BY: Jyoti Thatte        DATE: 04/03/01 ECO: *P008*    */
/* Revision: 1.16  BY: Vivek Gogte DATE: 04/30/01 ECO: *P001* */
/* $Revision: 1.18 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00N* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 101022.1  By: Roger Xiao */  /*add下料尺寸pt_article */
/*-Revision end---------------------------------------------------------------*/


/* DISPLAY TITLE */
{mfdtitle.i "101022.1"}

define variable vend     like wo_vend.
define variable nbr      like wo_nbr.
define variable nbr1     like wo_nbr.
define variable lot      like wo_lot.
define variable site     like wo_site no-undo.
define variable site1    like wo_site no-undo.
define variable part     like wo_part.
define variable part1    like wo_part.
define variable wobatch  like wo_batch.
define variable wobatch1 like wo_batch.
define variable rel      like wo_rel_date.
define variable rel1     like wo_rel_date.
define variable due      like wo_due_date.
define variable due1     like wo_due_date.
define variable so_job   like wo_so_job.
define variable so_job1  like wo_so_job.
define variable qty_open like wo_qty_ord label "Qty Open".
define variable stat     like wo_status.

/* SS - 101022.1 - B */
define var v_size  as char format "x(18)" label "下料尺寸" .
/* SS - 101022.1 - E */

form
   nbr         colon 15
   nbr1        label {t001.i} colon 49 skip
   site        colon 15
   site1       label {t001.i} colon 49 skip
   part        colon 15
   part1       label {t001.i} colon 49 skip
   wobatch     colon 15
   wobatch1    label {t001.i} colon 49 skip
   rel         colon 15
   rel1        label {t001.i} colon 49 skip
   due         colon 15
   due1        label {t001.i} colon 49 skip
   so_job      colon 15
   so_job1     label {t001.i} colon 49 skip (1)
   lot         colon 15 skip
   vend        colon 15 skip
   stat        colon 15 skip
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}

repeat on error undo, retry:

   if nbr1 = hi_char then nbr1 = "".
   if site1 = hi_char then site1 = "".
   if part1 = hi_char then part1 = "".
   if wobatch1 = hi_char then wobatch1 = "".
   if due = low_date then due = ?.
   if due1 = hi_date then due1 = ?.
   if rel = low_date then rel = ?.
   if rel1 = hi_date then rel1 = ?.

   if c-application-mode <> "WEB" then
   update
      nbr      nbr1
      site     site1
      part     part1
      wobatch  wobatch1
      rel      rel1
      due      due1
      so_job   so_job1
      lot
      vend
      stat
   with frame a.

   {wbrp06.i &command = update &fields = "  nbr nbr1 site site1 part part1
         wobatch wobatch1 rel rel1 due due1 so_job so_job1 lot vend stat"
         &frm = "a"}

   if (c-application-mode <> "WEB") or
      (c-application-mode = "WEB" and
      (c-web-request begins "DATA"))
   then do:

      bcdparm = "".
      {mfquoter.i nbr     }
      {mfquoter.i nbr1    }
      {mfquoter.i site    }
      {mfquoter.i site1   }
      {mfquoter.i part    }
      {mfquoter.i part1   }
      {mfquoter.i wobatch }
      {mfquoter.i wobatch1}
      {mfquoter.i rel     }
      {mfquoter.i rel1    }
      {mfquoter.i due     }
      {mfquoter.i due1    }
      {mfquoter.i so_job  }
      {mfquoter.i so_job1 }
      {mfquoter.i lot     }
      {mfquoter.i vend    }
      {mfquoter.i stat    }

      if nbr1 = "" then nbr1 = hi_char.
      if site1 = "" then site1 = hi_char.
      if part1 = "" then part1 = hi_char.
      if wobatch1 = "" then wobatch1 = hi_char.
      if due = ? then due = low_date.
      if due1 = ? then due1 = hi_date.
      if rel = ? then rel = low_date.
      if rel1 = ? then rel1 = hi_date.

      if index("PFEARCB",stat) = 0 and stat <> ""
      then do with frame a:
         {pxmsg.i &MSGNUM=19 &ERRORLEVEL=3}
         if c-application-mode = "WEB" then return.
         else next-prompt stat.
         undo, retry.
      end.

   end.

   /* SELECT PRINTER */
   {gpselout.i
       &printType = "printer"
       &printWidth = 132
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

   {mfphead.i}

   /* FIND AND DISPLAY */
   for each wo_mstr  where wo_mstr.wo_domain = global_domain and (
           (wo_nbr >= nbr and wo_nbr <= nbr1)
       and (wo_lot = lot or lot = "")
       and (wo_part >= part and wo_part <= part1)
       and (wo_site >= site and wo_site <= site1)
       and (wo_batch >= wobatch and wo_batch <= wobatch1)
       and (wo_vend = vend or vend = "")
       and (wo_due_date >= due and wo_due_date <= due1)
       and (wo_rel_date >= rel and wo_rel_date <= rel1)
       and (wo_so_job >= so_job) and (wo_so_job <= so_job1 or so_job1 = "")
       and (wo_status = stat or stat = "")
   ) no-lock by wo_nbr with frame b 
   width 160 /*133*/ /* SS - 101022.1 */
   no-attr-space:

      setFrameLabels(frame b:handle).

      find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
      wo_part no-lock no-error.
/* SS - 101022.1 - B */
v_size = if avail pt_mstr then pt_article else "" .
/* SS - 101022.1 - E */

      find ptp_det  where ptp_det.ptp_domain = global_domain and
           ptp_part = wo_part and
           ptp_site = wo_site
      no-lock no-error.

      /* PLANNED ORDERS (WO_STATUS = P) PRINT ONLY PM_CODE = M OR SPACE OR L */
      if wo_status = "P"
         and ((available ptp_det and
         ptp_pm_code <> "M" and ptp_pm_code <> "" and ptp_pm_code <> "L")
      or (not available ptp_det and available pt_mstr and
         pt_pm_code <> "M" and pt_pm_code <> "" and pt_pm_code <> "L"))
      then
         next.

      qty_open = max(wo_qty_ord - wo_qty_comp - wo_qty_rjct,0).

      if wo_status = "C" then
         qty_open = 0.

      if page-size - line-counter < 3 then page.

      display
         wo_nbr column-label "Work Order!Batch"
         wo_lot
         wo_part     format "x(24)"
/* SS - 101022.1 - B */
        v_size
/* SS - 101022.1 - E */
         wo_qty_comp
         wo_qty_rjct
         qty_open
         wo_ord_date column-label "Ord Date!Rel Date"
         wo_due_date
         wo_so_job
         wo_vend
         wo_status.

      down 1.
      display
         wo_batch @ wo_nbr.

      if available pt_mstr and pt_desc1 <> ""
      then
         display
            pt_desc1 @ wo_part.

      display
         wo_rel_date @ wo_ord_date.

      if available pt_mstr and pt_desc2 <> "" and pt_desc1 <> ""
      then
         down 1.

      if available pt_mstr and pt_desc2 <> ""
      then
         display
            pt_desc2 @ wo_part.

      {mfrpchk.i}

   end.

   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
