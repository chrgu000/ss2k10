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
{mfdeclre.i}
{xxwoworp02io.i}

/*35*/ define input parameter inbr         like wo_nbr.
/*35*/ define input parameter inbr1        like wo_nbr.
/*35*/ define input parameter isite        like wo_site no-undo.
/*35*/ define input parameter isite1       like wo_site no-undo.
/*35*/ define input parameter ilot         like wo_lot.
/*35*/ define input parameter ipart        like wo_part.
/*35*/ define input parameter ipart1       like wo_part.
/*35*/ define input parameter iwobatch     like wo_batch.
/*35*/ define input parameter iwobatch1    like wo_batch.
/*35*/ define input parameter idue         like wo_due_date.
/*35*/ define input parameter idue1        like wo_due_date.
/*35*/ define input parameter ivend        like wo_vend.
/*35*/ define input parameter iso_job      like wo_so_job.
/*35*/ define input parameter idesc1       like pt_desc1.
/*35*/ define input parameter iopen_ref    like wo_qty_ord label "Qty Open".
/*35*/ define input parameter iparts       like mfc_logical initial yes
/*35*/                             label "Print Work Order Bill Detail".
/*35*/ define input parameter ioperations  like mfc_logical initial yes
/*35*/                             label "Print Routing Detail".


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
define variable skpage      like mfc_logical initial yes
                            label "Page Break on Work Order".
define variable stat        like wo_status.
define variable firstwo     like mfc_logical.
define variable rcpt_date   as date no-undo.
define variable rcpt_userid as character no-undo.

define temp-table tt_tr_hist no-undo
   fields tt_date    like tr_date
   fields tt_trnbr   like tr_trnbr
   fields tt_userid  like tr_userid
   index tx_date is primary unique tt_date tt_trnbr.

/*35 form                                                                  */
/*35    nbr         colon 15                                               */
/*35    nbr1        label {t001.i} colon 49 skip                           */
/*35    site        colon 15                                               */
/*35    site1       label {t001.i} colon 49 skip                           */
/*35    part        colon 15                                               */
/*35    part1       label {t001.i} colon 49 skip                           */
/*35    wobatch     colon 15                                               */
/*35    wobatch1    label {t001.i} colon 49 skip                           */
/*35    due         colon 15                                               */
/*35    due1        label {t001.i} colon 49 skip (1)                       */
/*35    lot         colon 30 skip                                          */
/*35    so_job      colon 30 skip                                          */
/*35    vend        colon 30 skip                                          */
/*35    stat        colon 30 skip (1)                                      */
/*35    parts       colon 30                                               */
/*35    operations  colon 30                                               */
/*35    skpage      colon 30                                               */
/*35 with frame a side-labels width 80 attr-space.                         */

/*35 /* SET EXTERNAL LABELS */            */
/*35 setFrameLabels(frame a:handle).      */

/*35 form                                                                   */
/*35    wo_nbr                 colon 15                                     */
/*35    wo_lot                 colon 45                                     */
/*35    wo_batch               colon 71                                     */
/*35    wo_rmks                colon 71                                     */
/*35    wo_part                colon 15                                     */
/*35    wo_so_job              colon 45                                     */
/*35    wo_qty_ord             colon 71                                     */
/*35    wo_ord_date            colon 104                                    */
/*35    desc1                  at 17     no-label                           */
/*35    wo_qty_comp            colon 71                                     */
/*35    wo_rel_date            colon 104                                    */
/*35    wo_status              colon 15                                     */
/*35    wo_vend                colon 45                                     */
/*35    wo_qty_rjct            colon 71                                     */
/*35    wo_due_date            colon 104                                    */
/*35    rcpt_userid            colon 15  label "Received By"                */
/*35    rcpt_date              colon 45  label "Receipt Date"               */
/*35    wo_stat_close_userid   colon 71  label "WO Closed By"               */
/*35    wo_stat_close_date     colon 104                                    */
/*35 with frame b side-labels width 132 no-attr-space.                      */

/*35 /* SET EXTERNAL LABELS */              */
/*35 setFrameLabels(frame b:handle).        */


/*35  repeat on error undo, retry:                                            */

/*35   if nbr1     = hi_char  then nbr1     = "".                             */
/*35   if site1    = hi_char  then site1    = "".                             */
/*35   if part1    = hi_char  then part1    = "".                             */
/*35   if wobatch1 = hi_char  then wobatch1 = "".                             */
/*35   if due      = low_date then due      = ?.                              */
/*35   if due1     = hi_date  then due1     = ?.                              */
/*35                                                                          */
/*35   if c-application-mode <> "WEB" then                                    */
/*35   update                                                                 */
/*35      nbr      nbr1                                                       */
/*35      site     site1                                                      */
/*35      part     part1                                                      */
/*35      wobatch  wobatch1                                                   */
/*35      due      due1                                                       */
/*35      lot                                                                 */
/*35      so_job                                                              */
/*35      vend                                                                */
/*35      stat                                                                */
/*35      parts                                                               */
/*35      operations                                                          */
/*35      skpage                                                              */
/*35   with frame a.                                                          */
/*35                                                                          */
/*35 {wbrp06.i &command = update &fields = "  nbr nbr1 site site1 part part1  */
/*35  wobatch wobatch1 due due1 lot so_job vend stat parts operations skpage" */
/*35  &frm = "a"}                                                             */

/*35*/ assign nbr      =   inbr
/*35*/        nbr1     =   inbr1
/*35*/        site     =   isite
/*35*/        site1    =   isite1
/*35*/        lot      =   ilot
/*35*/        part     =   ipart
/*35*/        part1    =   ipart1
/*35*/        wobatch  =   iwobatch
/*35*/        wobatch1 =   iwobatch1
/*35*/        due      =   idue
/*35*/        due1     =   idue1
/*35*/        vend     =   ivend
/*35*/        so_job   =   iso_job
/*35*/        desc1    =   idesc1
/*35*/        open_ref =   iopen_ref
/*35*/        parts    =   iparts.

/*35 if (c-application-mode <> "WEB") or                                 */
/*35    (c-application-mode = "WEB" and                                  */
/*35    (c-web-request begins "DATA")) then do:                          */

/*35    bcdparm = "".                                                    */
/*35    {mfquoter.i nbr        }                                         */
/*35    {mfquoter.i nbr1       }                                         */
/*35    {mfquoter.i site       }                                         */
/*35    {mfquoter.i site1      }                                         */
/*35    {mfquoter.i part       }                                         */
/*35    {mfquoter.i part1      }                                         */
/*35    {mfquoter.i wobatch    }                                         */
/*35    {mfquoter.i wobatch1   }                                         */
/*35    {mfquoter.i due        }                                         */
/*35    {mfquoter.i due1       }                                         */
/*35    {mfquoter.i lot        }                                         */
/*35    {mfquoter.i so_job     }                                         */
/*35    {mfquoter.i vend       }                                         */
/*35    {mfquoter.i stat       }                                         */
/*35    {mfquoter.i parts      }                                         */
/*35    {mfquoter.i operations }                                         */
/*35    {mfquoter.i skpage     }                                         */
/*35                                                                     */
/*35    if nbr1     = "" then nbr1     = hi_char.                        */
/*35    if site1    = "" then site1    = hi_char.                        */
/*35    if part1    = "" then part1    = hi_char.                        */
/*35    if wobatch1 = "" then wobatch1 = hi_char.                        */
/*35    if due      = ?  then due      = low_date.                       */
/*35    if due1     = ?  then due1     = hi_date.                        */
/*35                                                                     */
/*35    if index("PFEARCB", stat) = 0 and stat <> ""                     */
/*35    then do with frame a:                                            */
/*35       if c-application-mode = "WEB" then return.                    */
/*35       else next-prompt stat.                                        */
/*35       undo, retry.                                                  */
/*35    end.                                                             */
/*35                                                                     */
/*35 end.                                                                */
/*35                                                                     */
/*35 /* SELECT PRINTER */                                                */
/*35 {gpselout.i                                                         */
/*35     &printType = "printer"                                          */
/*35     &printWidth = 132                                               */
/*35     &pagedFlag = " "                                                */
/*35     &stream = " "                                                   */
/*35     &appendToFile = " "                                             */
/*35     &streamedOutputToTerminal = " "                                 */
/*35     &withBatchOption = "yes"                                        */
/*35     &displayStatementType = 1                                       */
/*35     &withCancelMessage = "yes"                                      */
/*35     &pageBottomMargin = 6                                           */
/*35     &withEmail = "yes"                                              */
/*35     &withWinprint = "yes"                                           */
/*35     &defineVariables = "yes"}                                       */
/*35                                                                     */
/*35 {mfphead.i}                                                         */

   firstwo = yes.

   /* FIND AND DISPLAY */
   for each wo_mstr
      fields (wo_batch    wo_domain wo_due_date wo_lot     wo_nbr
              wo_ord_date wo_part   wo_qty_comp wo_qty_ord wo_qty_rjct
              wo_rel_date wo_rmks   wo_site     wo_so_job  wo_status
              wo_stat_close_date    wo_stat_close_userid   wo_vend)
      where wo_mstr.wo_domain = global_domain
       and ((wo_nbr >= nbr and wo_nbr <= nbr1)
       and (wo_lot = lot or lot = "")
       and (wo_part >= part and wo_part <= part1)
       and (wo_site >= site and wo_site <= site1)
       and (wo_batch >= wobatch and wo_batch <= wobatch1)
       and (wo_due_date >= due and wo_due_date <= due1)
       and (wo_vend = vend or vend = "")
       and (wo_so_job = so_job or so_job = "")
       and (wo_status = stat or stat = "")
    ) no-lock break by wo_nbr by wo_lot:

      for first pt_mstr
         fields (pt_domain pt_desc1 pt_desc2 pt_part pt_pm_code)
         where pt_mstr.pt_domain = global_domain
         and   pt_part           = wo_part
         no-lock:
      end. /* FOR FIRST pt_mstr */

      for first ptp_det
         fields (ptp_domain ptp_part ptp_pm_code ptp_site)
         where ptp_det.ptp_domain = global_domain
         and   ptp_part           = wo_part
         and   ptp_site           = wo_site
         no-lock:
      end. /* FOR FIRST ptp_det */

      /* IF WO_STATUS = P (PLANNED ORDERS) PRINT ONLY */
      /* PM_CODE = M OR SPACE OR L                    */
      if wo_status = "P" and
         ((available ptp_det and
           ptp_pm_code <> "M" and ptp_pm_code <> "" and ptp_pm_code <> "L")
      or (not available ptp_det and available pt_mstr and
          pt_pm_code <> "M" and pt_pm_code <> "" and pt_pm_code <> "L"))
      then
         next.

/*35      if not firstwo and skpage then              */
/*35         page.                                    */
/*35                                                  */
/*35      if not firstwo and not skpage then          */
/*35         display                                  */
/*35            fill("=",130) format "x(130)"         */
/*35         with width 132 no-attr-space.            */
/*35                                                  */
       firstwo = no.

      desc1 = "".

      if available pt_mstr then desc1 = pt_desc1.

      open_ref= max(wo_qty_ord - wo_qty_comp - wo_qty_rjct,0).

      if wo_status = "C" then
         open_ref = 0.

      if first-of (wo_lot)
      then do:

         /* GET LAST RECEIPT INFORMATION */
         for each tr_hist
            fields(tr_domain tr_trnbr tr_userid tr_date tr_nbr tr_lot tr_type)
            where tr_domain = global_domain
            and   tr_nbr    = wo_nbr
            and   tr_lot    = wo_lot
            and   tr_type   = "RCT-WO"
            no-lock
            use-index tr_nbr_eff:

            create tt_tr_hist.
            assign tt_date   = tr_date
                   tt_trnbr  = tr_trnbr
                   tt_userid = tr_userid.

         end. /* FOR EACH tr_hist */

         find last tt_tr_hist no-error.
         if available tt_tr_hist
         then do:
            assign
               rcpt_userid = tt_userid
               rcpt_date   = tt_date.
            empty temp-table tt_tr_hist.
         end. /* IF AVAILABLE tt_tr_hist */
         else
            assign
               rcpt_userid = ""
               rcpt_date   = ?.

      end. /* IF FIRST-OF (wo_lot) */

/*35      display                                                 */
/*35         wo_nbr                                               */
/*35         wo_lot                                               */
/*35         wo_batch                                             */
/*35         wo_qty_ord                                           */
/*35         wo_ord_date                                          */
/*35         wo_part                                              */
/*35         desc1                                                */
/*35         wo_qty_comp                                          */
/*35         wo_rel_date                                          */
/*35         wo_so_job                                            */
/*35         wo_qty_rjct                                          */
/*35         wo_due_date                                          */
/*35         wo_vend                                              */
/*35         wo_status                                            */
/*35         wo_rmks                                              */
/*35         rcpt_userid                                          */
/*35         rcpt_date                                            */
/*35         wo_stat_close_userid                                 */
/*35         wo_stat_close_date                                   */
/*35      with frame b side-labels width 132.                     */

        if parts then do:
           {xxmfwarp02io.i}
        end.

        if operations then do:
          {xxmfoprp02io.i}
        end.

/*35  {mfrpchk.i}                                                 */

   end.

/*35   {mfrtrail.i} */

/*35 end.                        */
/*35 {wbrp04.i &frame-spec = a}  */
