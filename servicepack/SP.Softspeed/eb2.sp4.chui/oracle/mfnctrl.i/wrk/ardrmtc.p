/* ardrmtc.p - AR DR/CR MEMO MAINTENANCE Create Tax Lines and Display   */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.9.1.8 $                                                 */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 7.4      CREATED      : 07/13/93             BY: wep *H021**/
/*                                   03/17/94             BY: bcm *H296**/
/* REVISION: 8.5      CREATED      : 01/08/96             BY: taf *J053**/
/*                                   07/25/96             by: mwd *J0VY**/
/* REVISION: 8.6      LAST MODIFIED: 09/03/96             BY: jzw *K008**/
/* REVISION: 8.6E     LAST MODIFIED: 11/25/96             BY: jzw *K01X**/
/*                                   12/30/96   BY: *K03F* Jeff Wootton */
/*                                   01/23/97             BY: bjl *K01G**/
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 06/04/98   BY: *L01K* Jaydeep Parikh */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Jeff Wootton      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* REVISION: 9.1      LAST MODIFIED: 08/05/00   BY: *N0VV* Mudit Mehta       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Revision: 1.9.1.7     BY: Vinod Nair     DATE: 06/11/01 ECO: *M18H*     */
/* $Revision: 1.9.1.8 $    BY: Vihang Talwalkar DATE: 10/22/01 ECO: *P01V*     */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* THIS LOGIC CONTROLS THE GENERATION OF THE ARD_DET RECORDS FOR THE TAX
   DISTRIBUTION AND THE GENERATION OF THE GL TRANSACTIONS FOR THE TAXLINES.
   THIS PROGRAM process for THE new TAX MANAGEMENT ONLY.
*/

{mfdeclre.i}
{cxcustom.i "ARDRMTC.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE ardrmtc_p_1 "Control"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{gldydef.i}
{gldynrm.i}

/* HANDLE TO PROCESSING-LOGIC SUBPROGRAM ARDRMTPL.P */
define shared variable h_rules as handle no-undo.

/* DEFINE FOR CALL TO ARARGL.P */
define shared variable rndmthd      like rnd_rnd_mthd.
define shared variable ard_amt_fmt  as character.
define shared variable undo_txdist  like mfc_logical.
define shared variable base_det_amt like glt_amt.
define shared variable base_amt     like ap_amt.
define shared variable curr_amt     like glt_curr_amt.
define shared variable artotal      like ar_amt label {&ardrmtc_p_1}.
define shared variable ar_recno     as recid.
define shared variable ba_recno     as recid.
define shared variable ard_recno    as recid.
define shared variable undo_all     like mfc_logical.
define shared variable jrnl         like glt_ref.
define shared variable recalc_tax   like mfc_logical initial true.

define variable tax_tr_type   like tx2d_tr_type.
define variable tax_nbr       like tx2d_nbr.
define variable tax_env       like txed_tax_env.
define variable tax_acct      like ard_acct.
define variable tax_sub       like ard_sub.
define variable tax_cc        like ard_cc.
define variable tax_total     like tx2d_totamt.
define variable tax_edit      like mfc_logical initial false.
define variable recalc_frame  like mfc_logical initial false.
define variable edit_frame    like mfc_logical initial false.
define variable undo_edittx   like mfc_logical initial false.
define variable undo_recalctx like mfc_logical initial false.
define variable update_vchr   like mfc_logical initial false.

define shared frame tax_dist.

/* DEFINE SHARED FRAME B */
{ardrfmb.i}

/* DEFINE FORM TO DISPLAY TAX DISTRIBUTION */
form
   ard_acct
   ard_sub
   ard_cc
   ard_entity
   ard_project
   ard_desc format "x(15)"
   ard_amt
with frame tax_dist
   13 down width 80
   title color normal (getFrameTitle("TAX_DISTRIBUTION",24)).

/* SET EXTERNAL LABELS */
setFrameLabels(frame tax_dist:handle).

find ba_mstr where recid(ba_mstr) = ba_recno exclusive-lock no-error.
find ar_mstr where recid(ar_mstr) = ar_recno exclusive-lock no-error.
find first gl_ctrl no-lock.
find first arc_ctrl no-lock.

ard_amt:format in frame tax_dist = ard_amt_fmt.

/* CREATE TAX LINES IN ARD_DET */
for each tx2d_det where
   tx2d_ref = ar_nbr   and
   tx2d_nbr = tax_nbr  and
   tx2d_tr_type = "18" and
   tx2d_cur_tax_amt <> 0:

   /* USE EXPENSE ACCOUNT IF AVAILABLE */
   find tx2_mstr where tx2_tax_code = tx2d_tax_code
      no-lock no-error.
   if tx2_ar_acct <> "" then do:
      /* CHECK FOR AR ABSORBED ACCOUNT */
      if tx2d_cur_abs_ret_amt <> 0
         and tx2_ara_use
      then do:
         assign
            tax_acct = tx2_ara_acct
            tax_sub = tx2_ara_sub
            tax_cc = tx2_ara_cc.
         find first ard_det
            where ard_nbr = ar_nbr
            and ard_tax = "t"
            and ard_acct = tax_acct
            and ard_sub = tax_sub
            and ard_cc = tax_cc
            exclusive-lock no-error.
         if not available ard_det then do:
            create ard_det.
            assign
               ard_entity  = ar_entity
               ard_nbr     = ar_nbr
               ard_acct    = tax_acct
               ard_sub     = tax_sub
               ard_cc      = tax_cc
               ard_tax     = "t"
               ard_tax_at  = "no"
               ard_amt     = tx2d_cur_abs_ret_amt
               ard_dy_code = dft-daybook
               ard_dy_num  = nrm-seq-num.

            if can-find(ac_mstr where ac_code = ard_acct)
            then do:
               find ac_mstr where ac_code = ard_acct
                  no-lock no-error.
               if available ac_mstr then
                  ard_desc = ac_desc.
            end.
         end.
         else
            ard_amt = ard_amt + tx2d_cur_abs_ret_amt.
      end.
      /* ASSIGN LIABILITY ACCOUNT */
      assign
         tax_acct = tx2_ar_acct
         tax_sub  = tx2_ar_sub
         tax_cc = tx2_ar_cc.
   end.
   else  /* USE ACCOUNT FROM LINE */
      assign
         tax_acct = ard_acct
         tax_sub  = ard_sub
         tax_cc   = ard_cc.
   {&ARDRMTC-P-TAG1}
   release ard_det.

   find first ard_det
      where ard_nbr = ar_nbr
      and ard_tax = "t"
      and ard_acct = tax_acct
      and ard_sub = tax_sub
      and ard_cc = tax_cc
      exclusive-lock no-error.
   if not available ard_det then do:
      create ard_det.
      assign
         ard_entity = ar_entity
         ard_nbr    = ar_nbr
         ard_acct   = tax_acct
         ard_sub    = tax_sub
         ard_cc     = tax_cc
         ard_tax    = "t"
         ard_tax_at = "no"
         ard_amt    = tx2d_cur_tax_amt
         ard_dy_code = dft-daybook
         ard_dy_num  = nrm-seq-num.

      if can-find(ac_mstr where ac_code = ard_acct)
      then do:
         find ac_mstr where ac_code = ard_acct
            no-lock no-error.
         if available ac_mstr then
            ard_desc = ac_desc.
      end.
   end.
   else
      ard_amt = ard_amt + tx2d_cur_tax_amt.
end.
tax_edit = false.
release ard_det.

clear frame tax_dist all no-pause.

/* INCREMENT JOURNAL FOR FIRST CALL TO arargl.p */
if jrnl = ""
then do:
   /* GET NEXT JOURNAL REFERENCE NUMBER  */
   {mfnctrl.i arc_ctrl arc_jrnl glt_det glt_ref jrnl}
   release glt_det.
end. /* IF jrnl = "" */

/* DISPLAY TAX DISTRIBUTION */
for each ard_det where ard_nbr = ar_nbr and
   ard_tax = "t":
   display
      ard_acct
      ard_sub
      ard_cc
      ard_entity
      ard_project
      ard_desc
      ard_amt
   with frame tax_dist.
   down with frame tax_dist.

   /* UPDATE GL TRANSACTION FILE */
   /* CONVERT INTO BASE HERE.*/
   curr_amt = ard_amt.
   run calc_base_amt in h_rules
      (ard_amt,
       buffer ar_mstr,
       buffer gl_ctrl,
       output base_amt).
   assign
      ard_recno = recid(ard_det)
      undo_all = yes
      base_det_amt = base_amt.
   {gprun.i ""arargl.p""}
   if undo_all then leave.

   run update_ar_amt in h_rules
      (ard_amt,
       buffer ar_mstr).

   find cm_mstr where cm_addr = ar_bill
      exclusive-lock.
   run update_cm_balance in h_rules
      (base_amt,
       buffer ar_mstr,
       buffer cm_mstr).

   run update_ba_total in h_rules
      (ard_amt,
       buffer ba_mstr).

end.
run update_ar_base_amt in h_rules
   (buffer ar_mstr).
view frame tax_dist.
