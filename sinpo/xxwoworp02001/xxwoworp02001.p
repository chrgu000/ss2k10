/* woworp02.p - WORK ORDER STATUS REPORT                                      */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.19 $                                                          */
/* REVISION: 1.0     LAST MODIFIED: 05/01/86    BY: emb                       */
/* REVISION: 2.1     LAST MODIFIED: 09/11/87    BY: wug *A94*                 */
/* REVISION: 4.0     LAST MODIFIED: 02/16/88    BY: flm *A175*                */
/* REVISION: 4.0     LAST MODIFIED: 03/23/88    BY: rl  *A171*                */
/* REVISION: 5.0     LAST MODIFIED: 10/26/89    BY: emb *B357*                */
/* REVISION: 5.0     LAST MODIFIED: 01/24/90    BY: ftb *B531*                */
/* REVISION: 5.0     LAST MODIFIED: 01/28/91    BY: ram *B882*                */
/* REVISION: 7.3     LAST MODIFIED: 11/19/92    BY: jcd *G348*                */
/* REVISION: 7.3     LAST MODIFIED: 04/23/93    BY: ram *GA24*                */
/* REVISION: 7.3     LAST MODIFIED: 09/09/94    BY: cpp *FQ88*                */
/* REVISION: 7.5     LAST MODIFIED: 10/07/94    BY: TAF *J035*                */
/* REVISION: 7.4     LAST MODIFIED: 03/29/95    BY: dzn *F0PN*                */
/* REVISION: 8.6     LAST MODIFIED: 10/14/97    BY: ays *K0Y5*                */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane          */
/* REVISION: 8.6E    LAST MODIFIED: 10/04/98    BY: *J314* Alfred Tan         */
/* REVISION: 9.0     LAST MODIFIED: 01/21/99    BY: *M066* Patti Gaultney     */
/* REVISION: 9.0     LAST MODIFIED: 03/13/99    BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1     LAST MODIFIED: 08/12/00    BY: *N0KC* Mark Brown         */
/* Revision: 1.12    BY: Jyoti Thatte           DATE: 04/03/01 ECO: *P008*    */
/* Revision: 1.15    BY: Vivek Gogte            DATE: 04/30/01 ECO: *P001*    */
/* Revision: 1.16    BY: Robin McCarthy         DATE: 11/26/01 ECO: *P023*    */
/* Revision: 1.18    BY: Paul Donnelly (SB)     DATE: 06/28/03 ECO: *Q00N*    */
/* $Revision: 1.19 $ BY: Manish Dani        DATE: 09/18/03 ECO: *P13H* */
/*-Revision end---------------------------------------------------------------*/


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:ConvertMode=Report                                                       */

/* DISPLAY TITLE */
{mfdtitle.i "120305.1"}
{xxwoworp02io.i "new"}
define variable nbr         like wo_nbr.
define variable nbr1        like wo_nbr.
define variable site        like wo_site no-undo.
define variable site1       like wo_site no-undo.
define variable lot         like wo_lot.
define variable part        like wo_part.
define variable part1       like wo_part.
define variable wobatch     like wo_batch.
define variable wobatch1    like wo_batch.
define variable due         like wo_due_date.
define variable due1        like wo_due_date.
define variable vend        like wo_vend.
define variable so_job      like wo_so_job.
define variable desc1       like pt_desc1.
define variable open_ref    like wo_qty_ord label "Qty Open".
define variable parts       like mfc_logical initial yes
                            label "Print Work Order Bill Detail".
define variable operations  like mfc_logical initial yes
                            label "Print Routing Detail".
define variable stat        like wo_status.
define variable firstwo     like mfc_logical.
define variable rcpt_date   as date no-undo.
define variable rcpt_userid as character no-undo.

define temp-table tt_tr_hist no-undo
   fields tt_date    like tr_date
   fields tt_trnbr   like tr_trnbr
   fields tt_userid  like tr_userid
   index tx_date is primary unique tt_date tt_trnbr.

form
   nbr         colon 15
   nbr1        label {t001.i} colon 49 skip
   site        colon 15
   site1       label {t001.i} colon 49 skip
   part        colon 15
   part1       label {t001.i} colon 49 skip
   wobatch     colon 15
   wobatch1    label {t001.i} colon 49 skip
   due         colon 15
   due1        label {t001.i} colon 49 skip (1)
   lot         colon 30 skip
   so_job      colon 30 skip
   vend        colon 30 skip
   stat        colon 30 skip (1)
   parts       colon 30
   operations  colon 30
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   wo_nbr                 colon 15
   wo_lot                 colon 45
   wo_batch               colon 71
   wo_rmks                colon 71
   wo_part                colon 15
   wo_so_job              colon 45
   wo_qty_ord             colon 71
   wo_ord_date            colon 104
   desc1                  at 17     no-label
   wo_qty_comp            colon 71
   wo_rel_date            colon 104
   wo_status              colon 15
   wo_vend                colon 45
   wo_qty_rjct            colon 71
   wo_due_date            colon 104
   rcpt_userid            colon 15  label "Received By"
   rcpt_date              colon 45  label "Receipt Date"
   wo_stat_close_userid   colon 71  label "WO Closed By"
   wo_stat_close_date     colon 104
with frame b side-labels width 132 no-attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

{wbrp01.i}
repeat on error undo, retry:

   if nbr1     = hi_char  then nbr1     = "".
   if site1    = hi_char  then site1    = "".
   if part1    = hi_char  then part1    = "".
   if wobatch1 = hi_char  then wobatch1 = "".
   if due      = low_date then due      = ?.
   if due1     = hi_date  then due1     = ?.

   if c-application-mode <> "WEB" then
   update
      nbr      nbr1
      site     site1
      part     part1
      wobatch  wobatch1
      due      due1
      lot
      so_job
      vend
      stat
      parts
      operations
   with frame a.

   {wbrp06.i &command = update &fields = "  nbr nbr1 site site1 part part1
    wobatch wobatch1 due due1 lot so_job vend stat parts operations "
    &frm = "a"}

   if (c-application-mode <> "WEB") or
      (c-application-mode = "WEB" and
      (c-web-request begins "DATA")) then do:

      bcdparm = "".
      {mfquoter.i nbr        }
      {mfquoter.i nbr1       }
      {mfquoter.i site       }
      {mfquoter.i site1      }
      {mfquoter.i part       }
      {mfquoter.i part1      }
      {mfquoter.i wobatch    }
      {mfquoter.i wobatch1   }
      {mfquoter.i due        }
      {mfquoter.i due1       }
      {mfquoter.i lot        }
      {mfquoter.i so_job     }
      {mfquoter.i vend       }
      {mfquoter.i stat       }
      {mfquoter.i parts      }
      {mfquoter.i operations }

      if nbr1     = "" then nbr1     = hi_char.
      if site1    = "" then site1    = hi_char.
      if part1    = "" then part1    = hi_char.
      if wobatch1 = "" then wobatch1 = hi_char.
      if due      = ?  then due      = low_date.
      if due1     = ?  then due1     = hi_date.

      if index("PFEARCB", stat) = 0 and stat <> ""
      then do with frame a:
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
   PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.
   empty temp-table xxwoworp02wod no-error.
   empty temp-table xxwoworp02wr no-error.
 {gprun.i ""xxwoworp02io.p"" "(
      INPUT nbr,
      INPUT nbr1,
      INPUT site,
      INPUT site1,
      INPUT lot,
      INPUT part,
      INPUT part1,
      INPUT wobatch,
      INPUT wobatch1,
      INPUT due,
      INPUT due1,
      INPUT vend,
      INPUT so_job,
      INPUT desc1,
      INPUT open_ref,
      INPUT parts,
      INPUT operations
      )"}
if parts then do:
  export delimiter ";" "wod_status" getTermLabel("MATERIAL_ORDER",24).
  export delimiter ";" "wo_nbr"
                       "wo_lot"
                       "wo_batch"
                       "wo_qty_ord"
                       "wo_ord_date"
                       "wo_part"
                       "desc1"
                       "wo_qty_comp"
                       "wo_rel_date"
                       "wo_so_job"
                       "wo_qty_rjct"
                       "wo_due_date"
                       "wo_vend"
                       "wo_status"
                       "wo_rmks"
                       "rcpt_userid"
                       "rcpt_date"
                       "wo_stat_close_userid"
                       "wo_stat_close_date"
                       "wod_part"
                       "pt_desc1"
                       "wod_qty_req"
                       "wod_qty_all"
                       "wod_qty_pick"
                       "wod_qty_iss"
                       "qty_open"
                       "wod_iss_date"
                       "wod_deliver".

   export delimiter ";" getTermLabel("WORK_ORDER",16)
                        getTermLabel("ID",16)
                        getTermLabel("BATCH",16)
                        getTermLabel("QUANTITY_ORDERED",16)
                        getTermLabel("ORDER_DATE",16)
                        getTermLabel("ITEM_NUMBER",16)
                        getTermLabel("DESCRIPTION",16)
                        getTermLabel("QUANTITY_COMPLETED",16)
                        getTermLabel("RELEASE_DATE",16)
                        getTermLabel("SALES/JOB",16)
                        getTermLabel("QTY_REJECT",16)
                        getTermLabel("DUE_DATE",16)
                        getTermLabel("SUPPLIER",16)
                        getTermLabel("WORK_ORDER_STATUS",16)
                        getTermLabel("REMARKS",16)
                        getTermLabel("RECIPIENT",16)
                        getTermLabel("RECEIVED_DATE",16)
                        getTermLabel("WORK_ORDER_CLOSED_BY",16)
                        getTermLabel("WORK_ORDER_CLOSE_DATE",16)
                        getTermLabel("ITEM_NUMBER",16)
                        getTermLabel("DESCRIPTION",16)
                        getTermLabel("QTY_REQUIRED",16)
                        getTermLabel("QUANTITY_ALLOCATED",16)
                        getTermLabel("QTY_PICKED",16)
                        getTermLabel("QUANTITY_ISSUED",16)
                        getTermLabel("QUANTITY_OPEN",16)
                        getTermLabel("ISSUE_DATE",16)
                        getTermLabel("DELIVER_TO",16)
                        .
   for each xxwoworp02wod no-lock:
       find first wo_mstr  use-index wo_lot no-lock where
                  wo_domain = global_domain and wo_lot = xx_wod_lot no-error.
       if available wo_mstr then do:
          export delimiter ";" wo_nbr
                               wo_lot
                               wo_batch
                               wo_qty_ord
                               wo_ord_date
                               wo_part
                               xx_wod_desc1
                               wo_qty_comp
                               wo_rel_date
                               wo_so_job
                               wo_qty_rjct
                               wo_due_date
                               wo_vend
                               wo_status
                               wo_rmks
                               xx_wod_rcpt_user
                               xx_wod_rcpt_date
                               wo_stat_close_userid
                               wo_stat_close_date
                               xx_wod_part
                               xx_wod_pt_desc
                               xx_wod_qty_req
                               xx_wod_qty_all
                               xx_wod_qty_pick
                               xx_wod_qty_iss
                               xx_wod_open_ref
                               xx_wod_iss_date
                               xx_wod_deliver.
       end.

   end.
   PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.
end.
if operations then do:
   put skip(2).
   export delimiter ";" "wr_status" getTermLabel("WORK_CENTER",24).
   export delimiter ";" "wo_nbr"
                        "wo_lot"
                        "wo_batch"
                        "wo_qty_ord"
                        "wo_ord_date"
                        "wo_part"
                        "desc1"
                        "wo_qty_comp"
                        "wo_rel_date"
                        "wo_so_job"
                        "wo_qty_rjct"
                        "wo_due_date"
                        "wo_vend"
                        "wo_status"
                        "wo_rmks"
                        "rcpt_userid"
                        "rcpt_date"
                        "wo_stat_close_userid"
                        "wo_stat_close_date"
                        "wr_op"
                        "wr_std_op"
                        "wr_desc"
                        "wr_wkctr"
                        "wr_start"
                        "wr_due"
                        "wr_setup"
                        "runtime"
                        "qty_open"
                        "op_status"
                        "wc_desc"
                        .
   export delimiter ";" getTermLabel("WORK_ORDER",16)
                        getTermLabel("ID",16)
                        getTermLabel("BATCH",16)
                        getTermLabel("QUANTITY_ORDERED",16)
                        getTermLabel("ORDER_DATE",16)
                        getTermLabel("ITEM_NUMBER",16)
                        getTermLabel("DESCRIPTION",16)
                        getTermLabel("QUANTITY_COMPLETED",16)
                        getTermLabel("RELEASE_DATE",16)
                        getTermLabel("SALES/JOB",16)
                        getTermLabel("QTY_REJECT",16)
                        getTermLabel("DUE_DATE",16)
                        getTermLabel("SUPPLIER",16)
                        getTermLabel("WORK_ORDER_STATUS",16)
                        getTermLabel("REMARKS",16)
                        getTermLabel("RECIPIENT",16)
                        getTermLabel("RECEIVED_DATE",16)
                        getTermLabel("WORK_ORDER_CLOSED_BY",16)
                        getTermLabel("WORK_ORDER_CLOSE_DATE",16)
                        getTermLabel("OPERATION",16)
                        getTermLabel("STANDARD_OPERATION",16)
                        getTermLabel("OPERATION_DESCRIPTION",16)
                        getTermLabel("WORK_CENTER",16)
                        getTermLabel("START_DATE",16)
                        getTermLabel("DUE_DATE",16)
                        getTermLabel("STD_SETUP_TIME",16)
                        getTermLabel("RUN_TIME",16)
                        getTermLabel("QUANTITY_OPEN",16)
                        getTermLabel("STATUS",16)
                        getTermLabel("DESCRIPTION",16)
                        .
   for each xxwoworp02wr no-lock:
       find first wo_mstr use-index wo_lot no-lock where
                  wo_domain = global_domain and wo_lot = xx_wr_wo_lot no-error.
       if available wo_mstr then do:
          export delimiter ";" wo_nbr
                               wo_lot
                               wo_batch
                               wo_qty_ord
                               wo_ord_date
                               wo_part
                               xx_wr_desc1
                               wo_qty_comp
                               wo_rel_date
                               wo_so_job
                               wo_qty_rjct
                               wo_due_date
                               wo_vend
                               wo_status
                               wo_rmks
                               xx_wr_rcpt_userid
                               xx_wr_rcpt_date
                               wo_stat_close_userid
                               wo_stat_close_date
                               xx_wr_op
                               xx_wr_std_op
                               xx_wr_desc
                               xx_wr_wkctr
                               xx_wr_start
                               xx_wr_due
                               xx_wr_setup
                               xx_wr_runtime
                               xx_wr_open_ref
                               xx_wr_op_status
                               xx_wr_wc_desc
                               .
       end.
   end.
   PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.
end.   
   {mfreset.i}

end.

{wbrp04.i &frame-spec = a}
