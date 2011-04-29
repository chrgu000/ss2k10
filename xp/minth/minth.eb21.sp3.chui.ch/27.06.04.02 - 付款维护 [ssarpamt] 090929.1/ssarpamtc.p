/* arpamtc.p - AR PAYMENT MAINTENANCE line items                              */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.62.1.75 $                                                               */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 6.0      LAST MODIFIED: 05/02/91   BY: mlv *D595*                */
/*                                   05/31/91   BY: mlv *D667*                */
/*                                   06/17/91   BY: afs *D709*                */
/*                                   07/08/91   BY: mlv *D753*                */
/*                                   08/11/91   BY: afs *D817*                */
/* REVISION: 7.0      LAST MODIFIED: 09/17/91   BY: mlv *F015*                */
/*                                   10/28/91   BY: mlv *F028*                */
/*                                   03/18/92   BY: jjs *F294*                */
/*                                   03/25/92   BY: jms *F332*                */
/*                                   04/16/92   BY: mlv *F401*                */
/* REVISION: 7.3      LAST MODIFIED: 08/26/92   BY: jms *G003*                */
/*                                   10/08/92   BY: jms *G146*                */
/*                                   10/20/92   BY: jms *G210*                */
/*                                   11/11/92   BY: mpp *G310*                */
/*                                   11/18/92   BY: jjs *G332*                */
/*                                   12/04/92   BY: mpp *G476*                */
/*                                   03/10/93   BY: bcm *G796*                */
/*                                   04/23/93   BY: jms *GA27*                */
/* REVISION: 7.4      LAST MODIFIED: 07/10/93   BY: pcd *H027*                */
/*                                   08/10/93   BY: wep *H105*                */
/*                                   09/22/93   BY: bcm *H133*                */
/*                                   10/22/93   BY: jms *H191*                */
/*                                   11/17/93   by: bcm *H228*                */
/*                                   12/13/93   by: bcm *GH92*                */
/*                                   12/28/93   by: wep *FL05*                */
/*                                   05/20/94   by: pmf *FO34*                */
/*                                   07/18/94   by: pmf *GK77*                */
/*                                   09/08/94   BY: bcm *H577*                */
/*                                   10/17/94   BY: ljm *GN36*                */
/*                                   11/06/94   by: srk *FS79*                */
/*                                   11/12/94   by: pmf *FT64*                */
/*                                   12/12/94   by: str *FU51*                */
/*                                   01/20/95   by: srk *H09T*                */
/*                                   04/24/95   by: wjk *H0CS*                */
/*                                   06/07/95   by: str *G0N9*                */
/*                                   11/27/95   by: mys *G1DZ*                */
/*                                   01/02/96   by: mys *H0HN*                */
/* REVISION: 8.5      LAST MODIFIED: 01/13/96   by: ccc *J053*                */
/*                                   07/22/96   by: *J0VY* M. Deleeuw         */
/*                                   07/29/96   by: *J101* T Farnsworth       */
/*                                   09/18/96   by: rxm *G2FK*                */
/* REVISION: 8.6      LAST MODIFIED: 01/23/97   by: bjl *K01G*                */
/*                                   02/17/97   by: *K01R* E. Hughart         */
/*                                   03/05/97   by: bkm *K06T*                */
/*                                   03/07/97   by: bkm *J1J5*                */
/* REVISION: 8.6      LAST MODIFIED: 08/04/97   BY: *H1CT* Irine D'mello      */
/* REVISION: 8.6      LAST MODIFIED: 11/26/97   BY: *J26Z* Irine D'mello      */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 04/07/98   by: *L00K* rup                */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton       */
/* REVISION: 8.6E     LAST MODIFIED: 06/19/98   BY: *L02L* Karel Groos        */
/* REVISION: 8.6E     LAST MODIFIED: 07/09/98   BY: *L01K* Jaydeep Parikh     */
/* REVISION: 8.6E     LAST MODIFIED: 08/24/98   BY: *L075* Jaydeep Parikh     */
/* REVISION: 8.6E     LAST MODIFIED: 08/26/98   BY: *L087* Jaydeep Parikh     */
/* REVISION: 8.6E     LAST MODIFIED: 09/10/98   BY: *L092* Steve Goeke        */
/* REVISION: 8.6E     LAST MODIFIED: 09/16/98   BY: *J305* Rajesh Talele      */
/* REVISION: 8.6E     LAST MODIFIED: 10/01/98   BY: *L09V* Jeff Wootton       */
/* REVISION: 8.6E     LAST MODIFIED: 10/09/98   BY: *J31C* Abbas Hirkani      */
/* REVISION: 9.0      LAST MODIFIED: 01/13/99   BY: *J359* Hemali Desai       */
/* REVISION: 9.0      LAST MODIFIED: 01/28/99   BY: *J37X* Prashanth Narayan  */
/* REVISION: 9.0      LAST MODIFIED: 02/09/99   BY: *L0D9* Jose Alex          */
/* REVISION: 9.0      LAST MODIFIED: 02/17/99   BY: *L0DF* Abbas Hirkani      */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B6* Katie Hilbert      */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 03/23/99   BY: *L0DG* Jose Alex          */
/* REVISION: 9.0      LAST MODIFIED: 04/06/99   BY: *J3CH* Hemali Desai       */
/* REVISION: 9.0      LAST MODIFIED: 04/20/99   BY: *L0CS* Brenda Milton      */
/* REVISION: 9.1      LAST MODIFIED: 06/10/99   BY: *J3GB* Jose Alex          */
/* REVISION: 9.1      LAST MODIFIED: 06/21/99   BY: *L0F7* Anup Pereira       */
/* REVISION: 9.1      LAST MODIFIED: 06/30/99   BY: *L0F8* Ranjit Jain        */
/* REVISION: 9.0      LAST MODIFIED: 07/28/99   BY: *M0CX* Paul Dreslinski    */
/* REVISION: 9.0      LAST MODIFIED: 08/11/99   BY: *J3KD* Ranjit Jain        */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Paul Johnson       */
/* REVISION: 9.1      LAST MODIFIED: 01/19/00   BY: *N077* Vijaya Pakala      */
/* REVISION: 9.1      LAST MODIFIED: 03/01/00   BY: *N03S* Jeff Wootton       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 06/29/00   BY: *L10F* Shilpa Athalye     */
/* REVISION: 9.1      LAST MODIFIED: 07/06/00   BY: *L111* Vihang Talwalkar   */
/* REVISION: 9.1      LAST MODIFIED: 07/10/00   BY: *L11F* Shilpa Athalye     */
/* REVISION: 9.1      LAST MODIFIED: 07/19/00   BY: *N0DP* Murali Ayyagari    */
/* REVISION: 9.1      LAST MODIFIED: 07/31/00   BY: *N0CL* Arul Victoria      */
/* REVISION: 9.1      LAST MODIFIED: 08/07/00   BY: *L11T* Vivek Gogte        */
/* REVISION: 9.1      LAST MODIFIED: 08/10/00   BY: *L127* Shilpa Athalye     */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                */
/* REVISION: 9.1      LAST MODIFIED: 09/07/00   BY: *L136* Veena Lad          */
/* REVISION: 9.1      LAST MODIFIED: 09/22/00   BY: *L14G* Mark Christian     */
/* REVISION: 9.1      LAST MODIFIED: 12/23/00   BY: *M0YS* Vinod Nair         */
/* REVISION: 9.1      LAST MODIFIED: 01/03/01   BY: *M0Y4* Jose Alex          */
/* REVISION: 9.1      LAST MODIFIED: 12/23/00   BY: *M0YS* Vinod Nair         */
/* REVISION: 9.1      LAST MODIFIED: 01/03/01   BY: *M0Y4* Jose Alex          */
/* REVISION: 8.6E     LAST MODIFIED: 01/23/01   BY: *L17C* Jean Miller        */
/* REVISION: 9.1      LAST MODIFIED: 01/29/01   BY: *M108* Rajesh Lokre       */
/* REVISION: 9.1      LAST MODIFIED: 10/20/00   BY: *N0WP* BalbeerS Rajput    */
/* REVISION: 9.1      LAST MODIFIED: 03/16/01   BY: *M12B* Abbas Hirkani      */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.62.1.33       BY: Katie Hilbert    DATE: 03/21/01  ECO: *L18P* */
/* Revision: 1.62.1.33       BY: Vihang Talwalkar DATE: 05/02/01  ECO: *M15J* */
/* Revision: 1.62.1.35       BY: Alok Thacker     DATE: 06/12/01  ECO: *M18Y* */
/* Revision: 1.62.1.35       BY: Seema Tyagi      DATE: 07/03/01  ECO: *M19B* */
/* Revision: 1.62.1.36       BY: Chris Green      DATE: 07/27/01  ECO: *N101* */
/* Revision: 1.62.1.37       BY: Vinod Nair       DATE: 09/06/01  ECO: *M1K4* */
/* Revision: 1.62.1.38       BY: Ed van de Gevel  DATE: 12/03/01  ECO: *N16R* */
/* Revision: 1.62.1.39       BY: Mark Christian   DATE: 01/23/02  ECO: *N17K* */
/* Revision: 1.62.1.40       BY: Ashwini G.       DATE: 02/26/02  ECO: *N1B9* */
/* Revision: 1.62.1.41       BY: Kirti Desai      DATE: 03/07/02  ECO: *M1WB* */
/* Revision: 1.62.1.43       BY: Vivek Dsilva     DATE: 04/09/02  ECO: *M1X8* */
/* Revision: 1.62.1.44       BY: Vivek Dsilva     DATE: 04/29/02  ECO: *M1Y3* */
/* Revision: 1.62.1.45       BY: Patrick de Jong  DATE: 05/08/02  ECO: *P077* */
/* Revision: 1.62.1.49       BY: Anitha Gopal     DATE: 06/06/02  ECO: *N1DM* */
/* Revision: 1.62.1.50       BY: Hareesh V.       DATE: 06/13/02  ECO: *M1Z9* */
/* Revision: 1.62.1.51       BY: Ed van de Gevel  DATE: 07/04/02  ECO: *P0B4* */
/* Revision: 1.62.1.52       BY: Hareesh V.       DATE: 09/12/02  ECO: *M209* */
/* Revision: 1.62.1.54       BY: Jose Alex        DATE: 10/10/02  ECO: *N1WN* */
/* Revision: 1.62.1.55       BY: Geeta Kotian     DATE: 11/14/02  ECO: *N1ZL* */
/* Revision: 1.62.1.57       BY: Shoma Salgaonkar DATE: 01/09/03  ECO: *N23N* */
/* Revision: 1.62.1.58       BY: Shoma Salgaonkar DATE: 01/21/03  ECO: *N24K* */
/* Revision: 1.62.1.59       BY: W.Palczynski     DATE: 05/13/03  ECO: *P0R8* */
/* Revision: 1.62.1.60       BY: Orawan S.        DATE: 05/20/03  ECO: *P0RX* */
/* Revision: 1.62.1.61 BY: Ed van de Gevel DATE: 05/28/03 ECO: *N2DV* RevOnly */
/* Revision: 1.62.1.63 BY: Paul Donnelly (SB)     DATE: 06/26/03  ECO: *Q00B* */
/* Revision: 1.62.1.64 BY: K Paneesh              DATE: 08/08/03  ECO: *N2JT* */
/* Revision: 1.62.1.67 BY: P. Grzybowski          DATE: 09/01/03  ECO: *P10G* */
/* Revision: 1.62.1.68 BY: Somesh Jeswani         DATE: 11/07/03  ECO: *P18P* */
/* Revision: 1.62.1.69 BY: Ed van de Gevel        DATE: 12/08/03  ECO: *P19N* */
/* Revision: 1.62.1.70 BY: Manish Dani            DATE: 03/03/04  ECO: *P1RJ* */
/* Revision: 1.62.1.71 BY: Veena Lad              DATE: 04/06/04  ECO: *P1WZ* */
/* Revision: 1.62.1.72  BY: Veena Lad    DATE: 05/13/04 ECO: *P21F* */
/* Revision: 1.62.1.73  BY: Ed van de Gevel       DATE: 05/19/04 ECO: *Q07V* */
/* Revision: 1.62.1.74  BY: Vinay Nayak-Sujir DATE:10/07/04 ECO: *P2NK* */
/* $Revision: 1.62.1.75 $ BY: Sachin Deshmukh  DATE:10/27/04 ECO: *P2RD* */
/*-Revision end---------------------------------------------------------------*/
/*****************************************************************************/
/* All patch markers and commented out code have been removed from the source*/
/* code below. For all future modifications to this file, any code which is  */
/* no longer required should be deleted and no in-line patch markers should  */
/* be added.  The ECO marker should only be included in the Revision History.*/
/*****************************************************************************/

/* SS - 080830.1 By: Bill Jiang */

{mfdeclre.i}
{cxcustom.i "ARPAMTC.P"}

/* EXTERNAL LABEL INCLUDE */
{gplabel.i}

/* COMMON EURO TOOLKIT VARIABLES */
{etvar.i}
{gldydef.i}
{gldynrm.i}

/* MUST INCLUDE gprunpdf.i IN THE MAIN BLOCK OF THE PROGRAM SO THAT */
/* CALLS TO gprunp.i FROM ANY OF THE INTERNAL PROCEDURES SKIPS  */
/* DEFINITION OF SHARED VARS OF gprunpdf.i */
/* FOR FURTHER INFO REFER TO HEADER COMMENTS IN gprunp.i */
{gprunpdf.i "mcpl" "p"}

/* SS - 080830.1 - B */
define variable l_round_amt      like ar_base_applied no-undo.
/* SS - 080830.1 - E */
define new shared variable base_det_amt like glt_amt.

define shared variable rndmthd      like rnd_rnd_mthd.
define shared variable ar_recno     as recid.
define shared variable arddet_recno as recid.
define shared variable ard_recno    as recid.
define shared variable arbuff_recno as recid.
define shared variable unappamt     like ar_amt label "Unapplied".
define shared variable artotal      like ar_amt label "Check Control".
define shared variable type         like ard_type.
define shared variable base_amt     like ar_amt.
define shared variable gain_amt     like ar_amt.
define shared variable curr_amt     like ar_amt.
define shared variable curr_disc    like glt_curr_amt.
define shared variable undo_all     like mfc_logical.
define shared variable old_doccurr  like ar_curr.
define shared variable apply2_rndmthd      like rnd_rnd_mthd.

/* L_AR_BASE_AMT PASSES CORRECT FOREIGN CURRENCY AMOUNT TO */
/* CASH BOOK MAINTENANCE WHEN A PAYMENT IS MADE THROUGH IT */
define shared variable l_ar_base_amt like ar_base_amt no-undo.
define shared variable cash_book     like mfc_logical.
define shared variable l_batch_err   like mfc_logical no-undo.

define variable tmpamt              as decimal.
define variable retval              as integer.
define variable amt_app_old  as character initial "->>>>,>>>,>>9.99".
define variable amt_app_fmt         as character.
define variable oldmthd             like rnd_rnd_mthd.
define variable vat_ndisc           as decimal.
define variable l_trl_ndisc         as decimal no-undo.
define variable exch_var            as decimal.
define variable disc-date           as date.
define variable del-yn              like mfc_logical initial no.
define variable amt_open            like cm_balance.
define variable amt_disc            like ar_amt label "Disc Bal".
define variable ardamt              like ard_amt label "Amt to Apply".
define variable open_amt            like ar_amt.
define variable amt-to-pay          like ar_amt.
define variable applied-amt         like ar_applied.
define variable amt-due             like ar_amt.
define variable amt-disc            like ar_amt.
{&ARPAMTC-P-TAG1}
define variable amt_to_apply        like ar_amt label "Amt to Apply".
{&ARPAMTC-P-TAG2}
define variable first_foreign       like mfc_logical.
define variable reset_ok            like mfc_logical.
define variable old_amt_to_apply    like amt_to_apply.
define variable l_calc_amt_to_apply like amt_to_apply no-undo.
define variable old_amt             like ard_amt.
define variable old_disc            like ard_disc.
define variable ref_nu              like ard_ref label "N/U Ref".
define variable bill_taxc           like ard_tax_at.
define variable valid_acct          like mfc_logical.
define variable tax_tr_type         like tx2d_tr_type initial "19".
define variable inv_type            like tx2d_tr_type initial "16".
define variable hold_ard_ref        like ard_ref.
define variable base_amt_expected   like ar_amt no-undo.
define variable inv_amt_paid        like ar_amt no-undo.
/*AMT PAID INV CURR*/
define variable base_amt_paid       like ar_amt no-undo.
define variable base_amt_disc       like ar_amt no-undo.
define variable inv_amt_disc        like ar_amt no-undo.
/*DISC IN INV CURR*/
define variable base_amt_to_settle  like ar_amt no-undo.
define variable is_transparent      like mfc_logical no-undo.
/*VARS. inv_to_base_rate, rate2 REPLACES ar__dec01 INTRODUCED IN ETK */
define variable inv_to_base_rate    like ar_ex_rate no-undo.
define variable inv_to_base_rate2   like ar_ex_rate2 no-undo.
define variable comb_exch_rate      like ar_ex_rate no-undo.
define variable comb_exch_rate2     like ar_ex_rate2 no-undo.
define variable paymnt_rndmthd      like rnd_rnd_mthd no-undo.

/* THE *_unrounded VARS ARE USED TO AVOID THE ROUNDING DIFFERENCES   */
/* THAT MIGHT CROP UP WHEN PMT AND INV/MEMO ARE IN DIFFERENT FOREIGN */
/* CURRENCIES. THESE VARS ARE ONLY FOR DISPLAY OF AMOUNTS, THEY      */
/* ARE NOT FOR THE PURPOSE OF UPDATING ANY FIELD.                    */
define variable ard_amt_unrounded /* UNROUNDED EQUIVALENT OF ard_amt */
   like ard_amt no-undo.
define variable ardamt_unrounded /* UNROUNDED EQUIVALENT OF ardamt */
   like ardamt no-undo.
define variable ard_disc_unrounded /*UNROUNDED EQUIVALENT OF ard_disc*/
   like ard_disc no-undo.
define variable old_ard_amt_unrounded  like ard_amt     no-undo.
define variable old_ard_disc_unrounded like ard_disc    no-undo.
define variable union_curr_code        like ar_curr     no-undo.
define variable is_emu_curr            like mfc_logical no-undo.
define variable base_amt_total         like ar_amt      no-undo.
define variable inv_amt_open           like ar_amt      no-undo.
define variable old_ardamt             like ar_amt      no-undo.
define variable ardamt_entered         like mfc_logical no-undo.
define variable ard_amt_entered        like mfc_logical no-undo.
define variable ard_disc_entered       like mfc_logical no-undo.
define variable inv_amt_to_apply       like ar_amt      no-undo.

/* REMOVED NO-UNDO SO THAT cust_bal IS UNDONE AUTOMATICALLY WHEN    */
/* USER TRIES BUT DOES NOT MODIFY THE PAYMENT WITHOUT COMING OUT OF */
/* PAYMENT APPLICATION MAINTENANCE FRAME                            */
define shared variable cust_bal  like cm_balance.

define variable l_oldamt         like ard_amt     no-undo.
define variable l_olddisc        like ard_amt     no-undo.
define variable l1_ar_base_amt   like ar_base_amt no-undo.
define variable l2_ar_base_amt   like ar_base_amt no-undo.
define variable l_entity_ok      like mfc_logical no-undo.
define variable l_ard_tax_at     like ard_tax_at  no-undo.
define variable l_unrnd_amt      like ar_amt      no-undo.
define variable l_rnd_amt        like ar_base_amt no-undo.

define buffer armstr  for ar_mstr.
define buffer armstr1 for ar_mstr.
define buffer armstr2 for ar_mstr.

define buffer arddet1 for ard_det.
define buffer arddet2 for ard_det.

define shared frame b1.
define shared frame c.
define shared frame d.

/* DEFINED TEMP TABLE FOR GETTING THE RECORDS ADDED IN ARPAMTC.P WITH INDEX */
/* SAME AS PRIMARY UNIQUE INDEX OF ard_det.                                 */
{ardydef.i &type="shared"}

{&ARPAMTC-P-TAG47}
/* GET ENTITY SECURITY INFORMATION */
{glsec.i}

/*DEFINE CONTROL TOTALS FRAME */
form
   ar_check       colon 10
   artotal
   ar_amt         label "  Total"
   ar_bill        colon 10
   cm_sort        no-label
   unappamt
with frame b1 side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b1:handle).

/*DEFINE DOCUMENT SCROLLING FRAME                                  */
/* SINCE 'SWINDAR.I' SCROLLING FRAME HANDLER LACKS ANY 'SPECIAL    */
/* PROCESSING' FEATURE WHICH WOULD ALLOW SPECIFICATION OF A FORMAT */
/* VARIABLE, FRAME C HAS BEEN MODIFIED TO ALLOW FOR THE GREATEST   */
/* POSSIBLE NUMBER OF DECIMAL POSITIONS.                           */
/* CORRECTION TO J053: ALLOW FOR LARGEST NUMBER OF ALL POSITIONS   */
form
   ard_ref
   ard_type
   ref_nu              label "N/U Ref"
   armstr1.ar_due_date
   open_amt            label "Balance"
   format "->>>>,>>>,>>9.999"
   ard_amt             label "Applied Amount"
   format "->>>>,>>>,>>9.999"
with frame c width 80 6 down.

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

{&ARPAMTC-P-TAG3}
form
   ard_ref       colon 10 label "Ref"
   type          colon 28 format "!"  /*CONVERT TO UPPERCASE*/
   ard_entity    colon 50
   ard_tax       colon 10 label "N/U Ref" format "x(8)"
   ardamt        colon 50
   ard_acct      colon 10
   ard_sub                no-label
   ard_cc                 no-label
   ard_amt       colon 50 label "Cash Amount"
   ard_tax_at    colon 10
   ard_disc      colon 50
with frame d side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

form
   armstr.ar_curr no-label
   amt_to_apply
   /* DO NOT DISPLAY VAR ACCT & CC SINCE GAIN AND LOSS ARE */
   /* SEPARATE ACCOUNTS NOW                                */
with frame set2_sub attr-space overlay side-labels
   row frame-row(b1) + 10 column frame-col(b1) + 34.
{&ARPAMTC-P-TAG4}

/* SET EXTERNAL LABELS */
setFrameLabels(frame set2_sub:handle).

/*PERFORM INITIAL READS */
find ar_mstr
   where recid(ar_mstr) = ar_recno.

{&ARPAMTC-P-TAG61}
/* GET INVOICE OR MEMO TO BASE EXCHANGE RATE FROM qad_wkfl */
{argetwfl.i
   ar_mstr.ar_nbr
   inv_to_base_rate
   inv_to_base_rate2}
{&ARPAMTC-P-TAG62}

for first cm_mstr
  fields( cm_domain cm_addr cm_ar_acct cm_ar_cc cm_ar_sub cm_sort           {&ARPAMTC-P-TAG64})
    where cm_mstr.cm_domain = global_domain and  cm_addr = ar_mstr.ar_bill
   no-lock:
end. /* FOR FIRST cm_mstr */

global_addr = ar_bill.

find first gl_ctrl   where gl_ctrl.gl_domain = global_domain no-lock.
find first arc_ctrl  where arc_ctrl.arc_domain = global_domain no-lock.

loope:
repeat with frame d on endkey undo, leave:

   {&ARPAMTC-P-TAG63}

   assign
      curr_amt       = 0
      l1_ar_base_amt = 0
      l2_ar_base_amt = 0.

   clear frame d.

   unappamt = artotal - ar_mstr.ar_amt.
   display
      ar_mstr.ar_amt
      unappamt
   with frame b1.

   /* DISPLAY THE ITEM SELECTED (IF ANY) AND ALLOW  */
   /* THE USER TO OVERRIDE                          */
   if arddet_recno <> ?
   then do:

      find ard_det
         where recid(ard_det) = arddet_recno.
      display ard_ref.

      assign
         ref_nu       = ard_tax
         arddet_recno = ?.

      /* CUSTOMER BALANCE SHOULD NOT BE UPDATED IF CASH AMOUNT */
      /* AND DISCOUNT AMOUNT ARE NOT CHANGED                   */
      if l_oldamt  = ard_det.ard_amt and
         l_olddisc = ard_disc
      then
         cust_bal = 0.

   end. /* IF arddet_recno <> ? */
   {&ARPAMTC-P-TAG5}

   prompt-for ard_ref
   editing:
      {&ARPAMTC-P-TAG6}
      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp01.i ard_det
                ard_ref
                ard_ref
                ard_nbr
                 " ard_det.ard_domain = global_domain and ar_mstr.ar_nbr "
                ard_nbr}

      if recno <> ?
      then do:

         run p-get-term-ard-tax-at
            (input  ard_tax_at,
             output l_ard_tax_at).

         display
            ard_ref
            ard_type @ type
            ard_acct
            ard_sub
            ard_cc
            l_ard_tax_at @ ard_tax_at
            ard_amt
            ard_disc
         with frame d.
      end. /* IF recno <> ? */

   end. /* EDITING BLOCK */
   {&ARPAMTC-P-TAG7}

   /* START AUTO APPLICATION */
   if input ard_ref = "*"
   then do:

      display "" @ ard_ref with frame d.
      hide frame b1 no-pause.
      hide frame c no-pause.
      hide frame d no-pause.

      {gprun.i ""arpamtb.p""}
      undo_all = no.
      leave loope.
   end. /* IF INPUT ard_ref = "*" */


   /* IF UNAPPLIED PAYMENT, ENTER REFERENCE CODE */
   type = "".
   if input ard_ref = ""
   then do:

      /* CREATE UNAPPLIED or NON-AR RECEIPT */
      run p_pxmsg(input 1160,
                  input 2).

      set1a:
      do on error undo, retry:
         set type with frame d.
         if index("UN",type) = 0
         then do:

            run p_pxmsg(input 1158,
                        input 3).

            next-prompt type with frame d.
            undo set1a.
         end. /* IF index("UN",type) = 0 */
      end. /* set1a */

      prompt-for ard_tax with frame d
      editing:

         {mfnp01.i ard_det
                   ard_tax
                   ard_tax
                   ard_nbr
                    " ard_det.ard_domain = global_domain and ar_mstr.ar_nbr "
                   ard_nbr}
         if recno <> ?
         then
            display ard_tax with frame d.
         ref_nu = input ard_tax.
      end. /* EDITING BLOCK */

   end. /* IF INPUT ard_ref = "" */
   else
       ref_nu = "".

   {&ARPAMTC-P-TAG37}

   /* ADD/MOD/DELETE  */
   find first ard_det  where ard_det.ard_domain = global_domain and  ard_ref =
   input ard_ref and
      ard_nbr = ar_mstr.ar_nbr and
      ard_tax = input ard_tax
      no-error.

   {&ARPAMTC-P-TAG38}
   /* NOT AVAILABLE ==> ADD */
   if not available ard_det
   then do:

      /* FIND THE *DOCUMENT* TO WHICH TO APPLY THE PAYMENT */
      for first armstr
         fields( ar_domain ar_acct ar_amt ar_applied ar_base_amt ar_base_applied
                 ar_bill ar_cc ar_check ar_contested ar_cr_terms ar_curr
                 ar_date ar_dd_curr ar_dd_ex_rate ar_dd_ex_rate2
                 ar_disc_date ar_draft ar_due_date ar_dy_code ar_effdate
                 ar_entity ar_exru_seq ar_ex_rate ar_ex_rate2
                 ar_ex_ratetype ar_nbr ar_open ar_paid_date ar_sub
                 ar_type ar_xslspsn1)
          where armstr.ar_domain = global_domain and  armstr.ar_nbr = input
          ard_ref
         no-lock:
      end. /* FOR FIRST armstr */

      if available armstr and armstr.ar_type = "D"
         and not armstr.ar_draft
      then do:

         {&ARPAMTC-P-TAG44}
         /* UNAPPROVED DRAFTS CANNOT BE PAID */
         run p_pxmsg(input 3533,
                     input 3).

         undo loope, retry.
         {&ARPAMTC-P-TAG45}
      end. /* IF AVAILABLE armstr AND... */

      {&ARPAMTC-P-TAG8}
      if available armstr and
         not armstr.ar_open
      then do:

         /* CANNOT APPLY TO CLOSED ITEMS */
         run p_pxmsg(input 3541,
                     input 3).

         undo loope, retry.
      end. /* IF AVAILABLE armstr AND NOT... */

      /* FIND ROUND METHOD ASSOCIATED WITH DOCUMENT CURRENCY */
      if available armstr
      then do:

         if armstr.ar_curr <> ar_mstr.ar_curr
         then do:

            /* SINCE PAYMENT CAN *ONLY* BE IN BASE CURR  */
            /* OR IN APPLIED-TO-DOCUMENT CURRENCY, THEN: */
            /* armstr.ar_curr (THE DOC) IS FOREIGN CURR  */
            /* & ar_mstr.ar_curr  (THE PMT) IS BASE.     */
            /* ar_mstr.ar_ex_rate IS THE EXCHANGE RATE    */
            /* BETWEEN BASE AND THE DOC CURRENCY AT THE   */
            /* TIME PAYMENT WAS MADE (ar_type 'P' REC EFFDATE */
            /* A CHECK (PMT) CAN ONLY BE APPLIED TO       */
            /* DOCUMENTS OF *ONE* FOREIGN CURRENCY.       */

            if armstr.ar_curr <> old_doccurr
               or (old_doccurr = "")
            then do:

               oldmthd = rndmthd.

               /* GET ROUNDING METHOD FROM CURRENCY MASTER */
               {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                  "(input armstr.ar_curr,
                    output rndmthd,
                    output mc-error-number)"}.
               if mc-error-number <> 0
               then do:

                  run p_pxmsg(input mc-error-number,
                              input 3).

                  undo loope, next loope.
               end. /* IF mc-error-number <> 0 */

               assign
                  apply2_rndmthd = rndmthd
                  rndmthd        = oldmthd
                  old_doccurr    = armstr.ar_curr.

            end. /* IF armstr.ar_curr <> old-doccurr... */
         end. /* IF armstr.ar_curr (DOC) <> ar_mstr.curr (PMT) */
      end. /* IF AVAILABLE armstr */

      else do:
         if ar_mstr.ar_curr <> old_doccurr
            or (old_doccurr = "")
         then do:

            oldmthd = rndmthd.

            /* GET ROUNDING METHOD FROM CURRENCY MASTER */
            {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
               "(input ar_mstr.ar_curr,
                 output rndmthd,
                 output mc-error-number)"}.
            if mc-error-number <> 0
            then do:

               run p_pxmsg(input mc-error-number,
                           input 3).

               undo loope, next loope.
            end. /* IF mc-error-number <> 0 */

            assign
               apply2_rndmthd = rndmthd
               rndmthd        = oldmthd
               old_doccurr    = ar_mstr.ar_curr.

         end. /* IF ar_mstr.ar_curr <> old-doccurr... */
      end. /* ELSE DO */

      /* ADDING NEW RECORD */
      run p_pxmsg(input 1,
                  input 1).

      create ard_det. ard_det.ard_domain = global_domain.

      assign
         ard_nbr  = ar_mstr.ar_nbr
         ard_type = type
         ard_ref
         ard_tax.

      if ard_ref = ""
      then
         ard_tax_at = bill_taxc.
      /* IF ard_ref IS ENTERED,                 */
      /* THEN N/U REF (ard_tax) SHOULD BE BLANK */
      else
         ard_tax = "".

   end. /* IF NOT AVAILABLE ard_det */

   /*---------------------------------------------------------------*/

   else do:
      /* Available ==> MODIFY */

      assign
         l_oldamt  = ard_amt
         {&ARPAMTC-P-TAG48}
         l_olddisc = ard_disc.

      /*IF UNAPPLIED REFERENCE,CHECK TO SEE IF IT HAS BEEN APPLIED*/
      /*(OR PARTIALLY APPLIED). IF SO, DO NOT ALLOW MODIFICATION  */
      /*THE MUST FIRST BACK OUT THE APPLIED REFERENCE BEFORE      */
      /*MODIFICATION IS TO BE ALLOWED.                            */
      if ard_ref = "" and
         ard_type = "U"
      then do for armstr2:
            find first armstr2  where armstr2.ar_domain = global_domain and
               armstr2.ar_check = input ar_mstr.ar_check and
               armstr2.ar_bill  = ar_mstr.ar_bill and
               armstr2.ar_xslspsn1 = ard_tax and
               armstr2.ar_type = "A" and
               armstr2.ar_nbr <> ar_mstr.ar_nbr
               no-lock no-error.
            if available armstr2
            then do:

               /* CANNOT MODIFY; UNAPPLIED PAYMENT HAS ALREADY BEEN APPLIED */
               run p_pxmsg(input 749,
                           input 3).

               undo loope, retry loope.
            end. /* IF AVAILABLE armstr2 */
         end. /* IF ard_def = "" AND... */

         /* BACK OUT GENERAL LEDGER TRANSACTIONS                     */
         /* STORE OLD AMT TO UNDO EXCHANGE GAIN/LOSS DURING GL UPDATE*/
         assign
            base_amt     = - ard_amt
            {&ARPAMTC-P-TAG9}
            base_det_amt = - (ard_amt + ard_disc)
            gain_amt     = 0
            curr_amt     = - ard_amt
            curr_disc    = - ard_disc.

         if ard_ref <> ""
         then do:

            find armstr
                where armstr.ar_domain = global_domain and  armstr.ar_nbr =
                ard_ref.

            /* DETERMINE ROUND METHOD OF *DOCUMENT* CURRENCY */
            if armstr.ar_curr <> ar_mstr.ar_curr
            then do:

               if armstr.ar_curr <> old_doccurr
                  or (old_doccurr = "")
               then do:

                  oldmthd = rndmthd.

                  /* GET ROUNDING METHOD FROM CURRENCY MASTER */
                  {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                     "(input armstr.ar_curr,
                       output rndmthd,
                       output mc-error-number)"}.
                  if mc-error-number <> 0
                  then do:

                     run p_pxmsg(input mc-error-number,
                                 input 3).

                     undo loope, next loope.
                  end. /* IF mc-error-number <> 0 */

                  assign
                     apply2_rndmthd = rndmthd
                     rndmthd        = oldmthd
                     old_doccurr    = armstr.ar_curr.

               end. /* IF armstr.ar_curr <> old-doccurr... */
            end. /* IF armstr.ar_curr (DOC) <> ar_mstr.curr (PMT) */

            /* IF THIS IS A DRAFT ar_mstr AND THE DRAFT WAS        */
            /* DISCOUNTED USE THE DISCOUNT EXCHANGE RATE AND       */
            /* CURRENCY                                            */
            /* PER DRAFT DISCOUNTING PROGRAM 'DMDISC.P', CURRENCY  */
            /* IN ar_slspsn[1] MAY **ONLY*** BE ar_curr OR BASE    */

            if armstr.ar_type = "D" and
               ( ar_dd_ex_rate <> 1 or
                 ar_dd_ex_rate2 <> 1 or
                 ar_dd_curr <> "" )
            then do:

               /* USE NEW VARS DEFINED FOR DRAFT DISCOUNTING CURRENCY */
               if armstr.ar_dd_curr   = base_curr
               then
                  rndmthd = gl_rnd_mthd.
               else
               if armstr.ar_dd_curr   <> ar_mstr.ar_curr
               then
                  undo loope, retry loope.
               /*USE NEW VARS DEFINED FOR DRAFT DISC CURR & RATE*/

               assign
                  ar_mstr.ar_ex_rate  = armstr.ar_dd_ex_rate
                  ar_mstr.ar_ex_rate2 = armstr.ar_dd_ex_rate2
                  ar_mstr.ar_curr     = armstr.ar_dd_curr.

            end. /* IF armstr.ar_type = "D" AND... */
         end. /* IF ard_ref <> "" */

         /* BACKOUT GL TRANS */
         run compute_amt_applied_in_base (-1).

         /* UPDATE GL DETAIL POSTINGS */
         ard_recno = recid(ard_det).
         if available armstr
         then
            arbuff_recno = recid(armstr).
         undo_all = yes.

         {&ARPAMTC-P-TAG46}
         /* FIRST INPUT PARAMETER INDICATES REVERSAL AND SECOND INPUT     */
         /* INPUT PARAMETER INDICATES THAT THE SEQUENCE NUMBER GENERATION */
         /* WILL BE DELAYED.                                              */
         {gprun.i ""arargl1.p""
            "(input true,
              input true)"}

         if undo_all
         then
            undo loope, leave.

         {&ARPAMTC-P-TAG49}
         /* BACK OUT PAYMENT TOTAL */
         {&ARPAMTC-P-TAG10}
         if ard_ref <> ""
         then
            assign
               ar_mstr.ar_amt = ar_mstr.ar_amt - ard_amt
               l_unrnd_amt    = ard_amt.
         else
            assign
               ar_mstr.ar_amt = ar_mstr.ar_amt - (ard_amt + ard_disc)
               l_unrnd_amt    = ard_amt + ard_disc.

         {&ARPAMTC-P-TAG11}

         /* CONVERT FROM FOREIGN TO BASE CURRENCY             */
         /* ADDED INTERNAL PROCEDURE  convert_fgn_to_base     */
         /* TO AVOID ACTION SEGMENT ERROR                     */

         run convert_fgn_to_base.

         run p-chk-mc-error-3.

         ar_mstr.ar_base_amt = ar_mstr.ar_base_amt - l_rnd_amt.

         if cash_book
         then
            run ip-cal-base-amt(output l2_ar_base_amt).

         run backout_customer_balance.
         run backout_memo_applied.

         assign
            ard_amt_unrounded  = ard_det.ard_amt
            ard_disc_unrounded = ard_det.ard_disc.

      end. /*IF MODIFY*/

      /*---------------------------------------------------------------*/

      assign
         recno    = recid(ard_det)
         del-yn   = no
         amt_disc = 0
         ardamt   = 0.

      if ard_ref <> ""
      then do:

         find armstr
             where armstr.ar_domain = global_domain and  armstr.ar_nbr =
             ard_ref no-error.

         if not available armstr or index("PC",armstr.ar_type) <> 0
            or (armstr.ar_bill <> ar_mstr.ar_bill)
         then do:

            /* REFERENCE DOES NOT EXIST */
            run p_pxmsg(input 1156,
                        input 3).

            undo, retry.
         end. /* IF NOT AVAILABLE armstr OR... */
         else do:

            /* IF THIS IS A DRAFT ar_mstr AND THE DRAFT WAS        */
            /* DISCOUNTED USE THE DISCOUNT EXCHANGE RATE AND       */
            /* CURRENCY                                            */
            /* PER DRAFT DISCOUNTING PROGRAM 'DMDISC.P', CURRENCY  */
            /* IN ar_slspsn[1] MAY **ONLY*** BE ar_curr OR BASE    */

            if armstr.ar_type = "D"
            then do:

               /*DRAFT CURR MUST MATCH PAYMENT FOR DISCOUNTED DRAFT  */
               /*BUT FOR NON-DISCOUNTED DRAFT, BASE CURR ALSO ALLOWED*/
               if armstr.ar_curr <> ar_mstr.ar_curr
               then
               if ( ar_mstr.ar_curr <> base_curr and
                  armstr.ar_dd_ex_rate = 1 and
                  armstr.ar_dd_ex_rate2 = 1 and
                  armstr.ar_dd_curr = "" ) or
                  armstr.ar_dd_ex_rate <> 1 or
                  armstr.ar_dd_ex_rate2 <> 1 or
                  armstr.ar_dd_curr <> ""
               then do:

                  /*DRAFT CURR <> PMT*/
                  run p_pxmsg(input 2751,
                              input 3).

                  undo, retry.
               end. /* IF (ar_mstr.ar_curr <> base_curr AND... */
               if armstr.ar_curr  = base_curr
               then
                  rndmthd = gl_rnd_mthd.
               if armstr.ar_dd_ex_rate <> 1 or
                  armstr.ar_dd_ex_rate2 <> 1 or
                  armstr.ar_dd_curr <> ""
               then do:

                  /*DISCOUNTED DRAFT*/
                  assign
                     ar_mstr.ar_ex_rate  = armstr.ar_dd_ex_rate
                     ar_mstr.ar_ex_rate2 = armstr.ar_dd_ex_rate2.

                  {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
                     "(input ar_mstr.ar_exru_seq)" }
                  {gprunp.i "mcpl" "p" "mc-copy-ex-rate-usage"
                     "(input armstr.ar_exru_seq,
                           output ar_mstr.ar_exru_seq)" }
               end. /* IF armstr.ar_dd_ex_rate <> 1 OR... */
            end. /* IF armstr.ar_type = "D" */

            if armstr.ar_curr <> base_curr or
               ar_mstr.ar_curr <> base_curr
            then do:

               run is_euro_transparent
                  (input ar_mstr.ar_curr,
                  input armstr.ar_curr,
                  input base_curr,
                  input ar_mstr.ar_effdate,
                  output is_transparent).

               if ar_mstr.ar_curr <> base_curr
                  and not is_transparent
                  and armstr.ar_curr <> ar_mstr.ar_curr
               then do:

                  /* IF CURRENCIES DON'T MATCH, PAYMENT CURR MUST BE BASE */
                  run p_pxmsg(input 149,
                              input 3).

                  undo, retry.
               end. /* IF ar_mstr.ar_curr <>base_curr AND NOT... */

               /* MAKE SURE A DIFF FOREIGN CURR NOT */
               /* PAID BY THIS CHECK                */

               do for arddet1:
                  for each arddet1  where arddet1.ard_domain = global_domain
                  and
                        arddet1.ard_nbr = ar_mstr.ar_nbr
                        and arddet1.ard_ref <> "":

                     for first armstr1
                        fields( ar_domain ar_acct ar_amt ar_applied ar_base_amt
                                ar_base_applied ar_bill ar_cc ar_check
                                ar_contested ar_cr_terms ar_curr ar_date
                                ar_dd_curr ar_dd_ex_rate ar_dd_ex_rate2
                                ar_disc_date ar_draft ar_due_date
                                ar_dy_code ar_effdate ar_entity ar_exru_seq
                                ar_ex_rate ar_ex_rate2 ar_ex_ratetype ar_nbr
                                ar_open ar_paid_date ar_sub ar_type ar_xslspsn1)
                         where armstr1.ar_domain = global_domain and
                         armstr1.ar_nbr = arddet1.ard_ref
                        no-lock:
                     end. /* FOR FIRST armstr1 */

                     if available armstr1
                        and armstr1.ar_curr <> base_curr
                        and armstr1.ar_curr <> armstr.ar_curr
                     then do:

                        /* CHECK CANNOT PAY 2 DIFFERENT FOREIGN CURRENCIES*/
                        run p_pxmsg(input 148,
                                    input 3).

                        undo loope, retry.
                     end. /* IF AVAILABLE armstr1 AND... */
                  end. /* FOR EACH arddet1 */
               end. /* DO FOR arddet1 */

               if armstr.ar_curr <> ar_mstr.ar_curr
               then do:

                  /* WARNING: INVOICE CURR <> CHECK CURR */
                  run p_pxmsg(input 144,
                              input 2).

               end. /* IF armstr.ar_curr <> ar_mstr.ar_curr */

               if armstr.ar_curr <> old_doccurr
                  or (old_doccurr = "")
               then do:

                  oldmthd = rndmthd.

                  /* GET ROUNDING METHOD FROM CURRENCY MASTER */
                  {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                     "(input armstr.ar_curr,
                       output rndmthd,
                       output mc-error-number)"}.
                  if mc-error-number <> 0
                  then do:

                     run p_pxmsg(input mc-error-number,
                                 input 3).

                     undo loope, next loope.
                  end. /* IF mc-error-number <> 0 */

                  assign
                     apply2_rndmthd = rndmthd
                     rndmthd        = oldmthd
                     old_doccurr    = armstr.ar_curr.

               end. /* IF armstr.ar_curr <> old-doccurr OR... */

               /* IF FIRST OCCURRENCE OF FOREIGN  */
               /* INVOICE, SET ar_ex_rate         */
               /* DON'T PICK UP A NEW EXCHANGE    */
               /* IF PAYMENT IS FOR A DISCOUNTED  */
               /* DRAFT. armstr.ar_sales_amt      */
               /* CONTAINS THE DISCOUNT EXCH RATE */

               /* ASSIGNING EXCHANGE RATE TO inv_to_base_rate AND */
               /* inv_to_base_rate2 FOR DISCOUNTED DRAFTS ALSO    */

               /* RESETTING THE VALUES OF inv_to_base_rate AND */
               /* inv_to_base_rate2                            */
               run get-qad-wkfl
                  (input ar_mstr.ar_nbr).

               if new ard_det
                  and inv_to_base_rate  = 1
                  and inv_to_base_rate2 = 1
               then do:

                  if base_curr <> armstr.ar_curr or
                     base_curr <> ar_mstr.ar_curr
                  then do:

                     if armstr.ar_curr <> ar_mstr.ar_curr
                     then do:

                        /* GET INV TO BASE RATE ON PMT DATE */
                        {gprunp.i "mcpl" "p" "mc-get-ex-rate"
                           "(input armstr.ar_curr,
                             input base_curr,
                             input ar_mstr.ar_ex_ratetype,
                             input ar_mstr.ar_effdate,
                             output inv_to_base_rate,
                             output inv_to_base_rate2,
                             output mc-error-number)"}
                        if mc-error-number <> 0
                        then do:

                           run p_pxmsg(input mc-error-number,
                                       input 2).

                           undo, retry.
                        end. /* IF mc-error-number <> 0 */

                     end. /* IF armstr.ar_curr <> ar_mstr.ar_curr */
                     else
                        assign
                           inv_to_base_rate  = ar_mstr.ar_ex_rate
                           inv_to_base_rate2 = ar_mstr.ar_ex_rate2.

                     first_foreign = yes.
                  end. /* IF base_curr <> armstr.ar_curr OR... */
                  else
                     assign
                        inv_to_base_rate  = 1
                        inv_to_base_rate2 = 1
                        first_foreign     = no.

                  /*UPD INV OR MEMO TO BASE EXCH RATE IN qad_wkfl*/
                  {arupdwfl.i  ar_mstr.ar_nbr
                     inv_to_base_rate
                     inv_to_base_rate2}
               end.  /* IF NEW ard_det AND ... */
               else
                  first_foreign = no.

            end.  /* IF armstr.ar_curr <> base_curr OR ... */

            else do:
               assign
                  apply2_rndmthd    = rndmthd
                  old_doccurr       = ar_mstr.ar_curr
                  inv_to_base_rate  = ar_mstr.ar_ex_rate
                  inv_to_base_rate2 = ar_mstr.ar_ex_rate2.

               /*UPDATE INV OR MEMO TO BASE EXCH RATE IN qad_wkfl*/
               {arupdwfl.i  ar_mstr.ar_nbr
                  inv_to_base_rate
                  inv_to_base_rate2}
            end. /* ELSE DO */

            assign
               ard_acct   = armstr.ar_acct
               ard_sub    = armstr.ar_sub
               ard_cc     = armstr.ar_cc
               ard_entity = armstr.ar_entity
               ard_type   = armstr.ar_type.

         end.  /* ELSE DO */
         amt_open = armstr.ar_amt - armstr.ar_applied.

         /* WARN USER IF DOCUMENT IS CONTESTED */
         if armstr.ar_contested
         then do:

            run p_pxmsg(input 627,
                        input 2).

         end. /* IF armstr.ar_contested */

         /* CHANGED FIRST PARAMETER FROM armstr.ar_curr */
         /* TO ar_mstr.ar_curr                          */
         /* OBTAIN CURRENCY ROUNDING METHOD OF PAYMENT  */
         {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
            "(input ar_mstr.ar_curr,
              output paymnt_rndmthd,
              output mc-error-number)"}

         if mc-error-number <> 0
         then do:

            run p_pxmsg(input mc-error-number,
                        input 3).

            undo loope, next loope.
         end. /* IF mc-error-number <> 0 */

         /* CALCULATE DISCOUNT */

         /* WHEN DISCOUNT TAX AT PAYMENT IS 'NO', THE TAX IS */
         /* SUBTRACTED FROM THE OPEN AMOUNT, BEFORE PASSING  */
         /* TO THE DISCOUNT CALCULATION ROUTINE ardiscal.i.  */
         /* vat_ndisc = 0  IF DISCOUNT TAX AT PAYMENT = YES  */
         /* vat_ndisc >= 0 IF DISCOUNT TAX AT PAYMENT = NO   */

         if ard_det.ard_type = "I"
         then
            inv_type = "16".
         else
         if ard_det.ard_type = "M"
         then inv_type = "18".

         {gprun.i ""arpamtc1.p"" "(input-output vat_ndisc,
                                   input ard_det.ard_ref,
                                   input inv_type)"
            }

         /*ASSUME NDISC AMT TAKEN FROM APPLIED*/
         vat_ndisc = max( vat_ndisc - armstr.ar_applied,0).

         /* INSERT LOGIC TO SUBTRACT NON-DISC TRAILER CHARGES FROM  */
         /* THE OPEN AMOUNT, BEFORE PASSING TO THE DISCOUNT CALC    */
         /* ROUTINE ardiscal.i.                                     */
         /* l_trl_ndisc = 0 IF DISCOUNT TRAILER CHARGE = YES        */
         /* l_trl_ndisc >= 0 IF DISCOUNT TRAILER CHARGE = NO        */

         run ip_get_trlamt.

         amt_open = if amt_open >= 0
            then max(amt_open - vat_ndisc - l_trl_ndisc,0)
            else min(amt_open - vat_ndisc - l_trl_ndisc,0).

         run p_calc_disc
            ( input-output amt_disc,
              input        amt_open).


         /* NOW THAT THE DISCOUNT HAS BEEN CALCULATED, WE NEED TO    */
         /* REINSTATE THE AMT TO APPLY BACK TO THE ORIGINAL OPEN AMT */
         /* AMT TO APPLY (ardamt) SHOULD BE EQUAL TO THE OPEN AMT    */

         assign
            ardamt             = armstr.ar_amt - armstr.ar_applied
            ard_disc_unrounded = amt_disc
            {&ARPAMTC-P-TAG57}
            ardamt_unrounded   = ardamt.

         /* SET curr_amt AND curr_disc */
         run ip-curr-amt-disc in this-procedure.

         display armstr.ar_type @ type with frame d.
      end. /* IF ard_ref <> "" */

      /*---------------------------------------------------------------*/

      /* IF NOT UNAPPLIED AMOUNT BACK IT OUT */
      if ard_type <> "U"
      then
         assign
            ar_mstr.ar_applied = ar_mstr.ar_applied - ard_amt
            l_unrnd_amt        = ard_amt.

      if ard_type <> "U"
      then do:

         {&ARPAMTC-P-TAG39}

         /* CHANGES MADE TO CONVERT ard_amt TO BASE CURRENCY   */
         /* AND THEN ACCUMULATE IT TO ar_base_applied TO AVOID */
         /* ROUNDING DIFFERENCE BETWEEN AR AND GL ENTRIES.     */

         /* CONVERT FROM FOREIGN TO BASE CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input ar_mstr.ar_curr,
              input base_curr,
              input ar_mstr.ar_ex_rate,
              input ar_mstr.ar_ex_rate2,
              input l_unrnd_amt,
              input true, /* ROUND */
              output l_rnd_amt,
              output mc-error-number)"}.
         run p-chk-mc-error-3.

         ar_mstr.ar_base_applied = ar_mstr.ar_base_applied - l_rnd_amt.

         {&ARPAMTC-P-TAG40}
      end. /* IF ard_type <> "U" */

      run p-get-term-ard-tax-at
         (input  ard_tax_at,
          output l_ard_tax_at).

      display ard_type @ type
         ard_acct
         ard_sub
         ard_cc
         ardamt
         ardamt - amt_disc @ ard_amt
         amt_disc @ ard_disc
         l_ard_tax_at @ ard_tax_at
      with frame d.

      /*---------------------------------------------------------------*/

      if new ard_det
      then do:

         {&ARPAMTC-P-TAG12}
         if ard_ref = ""
         then do:

            /* MISC OR UNAPPLIED */
            run p_pxmsg(input 1158,
                        input 1).

            set1:
            do on error undo, retry:

               assign
                  ard_acct = cm_ar_acct
                  ard_sub  = cm_ar_sub
                  ard_cc   = cm_ar_cc.

               if ard_type = "N" and
                  available gl_ctrl
               then
               assign
                  ard_acct = gl_sls_acct
                  ard_sub  = gl_sls_sub
                  ard_cc   = gl_sls_cc.

            end. /*set1*/

            display
               ard_acct
               ard_sub
               ard_cc
            with frame d.

            set2:
            do on error undo, retry:
               set
                  ard_acct
                  ard_sub
                  ard_cc
               with frame d.

               if ar_mstr.ar_curr <> base_curr
               then do:

                  if can-find (first ac_mstr  where ac_mstr.ac_domain =
                  global_domain and  ac_code =
                     ard_acct and
                     ac_curr <> ar_mstr.ar_curr and
                     ac_curr <> base_curr)
                  then do:

                     /* ACCT CURRENCY MUST MATCH TRANSACTION OR */
                     /* BASE CURRENCY                           */
                     run p_pxmsg(input 134,
                                 input 3).

                     next-prompt ard_acct with frame d.
                     undo set2, retry.
                  end. /* IF CAN-FIND(FIRST ac_mstr..) */
               end. /* IF ar_curr <> base_curr */

               /* INITIALIZE SETTINGS */
               {gprunp.i "gpglvpl" "p" "initialize"}
               /* SET PROJECT VERIFICATION TO NO */
               {gprunp.i "gpglvpl" "p" "set_proj_ver" "(input false)"}
               /* ACCT/SUB/CC VALIDATION */
               {gprunp.i "gpglvpl" "p" "validate_fullcode"
                  "(input ard_acct,
                    input ard_sub,
                    input ard_cc,
                    input """",
                    output valid_acct)"}

               if valid_acct = false
               then do:

                  next-prompt ard_acct with frame d.
                  undo set2, retry.
               end. /* IF valid_acct = false */

               /* VALIDATE VAT-CLASS FOR UNAPPLIED PAYMENT DATE */
               if ard_tax_at <> ""
               then do:

                  find last vt_mstr where vt_class = ard_tax_at
                     and vt_start <=  ar_mstr.ar_effdate
                     and vt_end >= ar_mstr.ar_effdate no-lock no-error.
                  if not available vt_mstr
                  then do:

                     /* VAT CLASS MUST EXIST */
                     run p_pxmsg(input 111,
                                 input 3).

                     next-prompt ard_tax_at with frame d.
                     undo set2, retry.
                  end. /* IF NOT AVAILABLE vt_mstr */
               end. /* IF ard_tax_at <> "" */

               {&ARPAMTC-P-TAG50}
               /* PROMPT FOR AND VALIDATE ENTITY */
               do on error undo, retry:
                  ard_entity = ar_mstr.ar_entity.

                  update ard_entity with frame d.

                  if ard_entity <> ar_mstr.ar_entity
                  then do:

                     for first en_mstr
                        fields( en_domain en_entity)
                         where en_mstr.en_domain = global_domain and  en_entity
                         = ard_entity
                        no-lock:
                     end. /* FOR FIRST en_mstr */

                     if not available en_mstr
                     then do:

                        /*INVALID ENTITY*/
                        run p_pxmsg(input 3061,
                                    input 3).

                        next-prompt ard_entity
                        with frame d.
                        undo, retry.
                     end. /* IF NOT AVAILABLE en_mstr */
                  end. /* IF ard_entity <> ar_mstr.ar_entity */

               end. /* DO ON ERROR UNDO, RETRY */
            end. /* set2 */
         end. /* IF ard_ref = "" */

         /* CHECK ENTITY SECURITY */
         {glenchk.i &entity=ard_entity &entity_ok=l_entity_ok}
         if not l_entity_ok
         then
            if not batchrun
            then do:

               next-prompt ard_ref with frame d.
               undo loope, retry loope.
            end. /* IF NOT batchrun */

            else do:
               l_batch_err = yes.
               undo loope, leave loope.
            end. /* IF batchrun */

         /* VALIDATE ENTITY FOR DAYBOOKS*/
         if daybooks-in-use
         then do:

            {gprun.i ""gldyver.p"" "(input ""AR"",
                                     input ar_mstr.ar_type,
                                     input ar_mstr.ar_dy_code,
                                     input ard_entity,
                                     output daybook-error)"}
            if daybook-error
            then do:

               run p_pxmsg(input 1674,
                           input 2).

               /* WARNING: DAYBOOK DOES NOT MATCH ANY DEFAULT */
               if not batchrun then
               do on endkey undo, leave:
                  pause.
               end. /* IF NOT batchrun */

            end. /* IF daybook-error */
         end. /* IF daybooks-in-use */

         {&ARPAMTC-P-TAG13}
         old_ardamt = ardamt.

         updt_ardamt:
         do on error undo, retry:
            update ardamt with frame d.

            /* VALIDATE ardamt PER PAYMENT CURRENCY RNDMTHD.  */
            /* PAYMENT CURRENCY IS BASE IF PAYMENT CURRENCY   */
            /* IS DIFFERENT FROM APPLY-TO DOCUMENT CURRENCY   */
            if (ardamt <> 0)
            then do:

               {gprun.i ""gpcurval.p"" "(input ardamt,
                                         input rndmthd,
                                         output retval)"}
               if (retval <> 0)
               then do:

                  next-prompt ardamt with frame d.
                  undo updt_ardamt, retry updt_ardamt.
               end. /* IF (retval <> 0) */
            end. /* IF (ardamt <> 0) */

            /* PARTIAL PAYMENT OF THE CREDIT MEMO/INVOICE SHOULD */
            /* BE ALLOWED.                                       */

            if ard_ref <> ""
            then do:

               /* CHECK IF AMOUNT TO APPLY FOR A CREDIT MEMO/INVOICE */
               /* IS POSITIVE.                                       */
               /* AND IS NOT FIRST FOREIGN CURRENCY MEMO/INVOICE     */
               if ((old_ardamt < 0            and
                  (ardamt      > 0            or
                  ardamt       < old_ardamt)) or
                  old_ardamt   > 0            and
                  ardamt       > old_ardamt)
                  and not first_foreign
               then do:

                  /* CANNOT EXCEED AMOUNT OPEN */
                  run p_pxmsg(input 1157,
                              input 3).

                  undo updt_ardamt, retry.
               end. /* IF ((old_ardamt < 0 AND... */

               /* CHECK IF AMOUNT TO APPLY FOR A DEBIT MEMO/INVOICE */
               /* IS NEGATIVE.                                      */
               if old_ardamt > 0 and
                  ardamt     < 0
               then do:

                  /* AMOUNT TO APPLY IS NOT A POSITIVE VALUE */
                  run p_action (input 2405, input ardamt).
                  undo updt_ardamt, retry.
               end. /* IF old_ardamt > 0 AND... */

            end. /* IF ard_ref <> "" */

         end. /* updt-ardamt */
         {&ARPAMTC-P-TAG41}

         if ardamt entered
         then do:

            ardamt_entered = true.

            if ard_ref <> ""
            then do:

               /* PUT BACK TO FOREIGN FOR DISC CALC */
               /* IF FOREIGN PAID IN BASE           */
               {&ARPAMTC-P-TAG14}
               if armstr.ar_curr <> ar_mstr.ar_curr
               then do:

               {&ARPAMTC-P-TAG15}
                  /* CONVERT FOREIGN TO BASE TO FOREIGN */
                  run proc_ard_amt_to_memo.
                  run p-chk-mc-error-3.
               end. /* IF armstr.ar_curr <> ar_mstr.ar_curr */

               /* SAVE AMT TO APPLY BEFORE CALCULATING THE ELIGIBLE */
               /* AMOUNT FOR DISCOUNT                               */
               assign
                  amt_open = ardamt
                  ardamt   = if ardamt >= 0
                             then max(ardamt - vat_ndisc - l_trl_ndisc,0)
                             else min(ardamt - vat_ndisc - l_trl_ndisc,0).

               run p_calc_disc
                  ( input-output ard_disc,
                    input        ardamt).

               /* SET curr_amt AND curr_disc IN APPLY-TO DOCUMENT CURRENCY */
               assign
                  ardamt    = amt_open
                  curr_amt  = ardamt - ard_disc
                  curr_disc = ard_disc.

               {&ARPAMTC-P-TAG16}
               if armstr.ar_curr <> ar_mstr.ar_curr
               then do:

                 {&ARPAMTC-P-TAG17}

                  run combine_ex_rates_curr_conv_comb.
                  run p-chk-mc-error-3.

                  /* STORE NEW VALUE ENTERED BY THE USER */
                  ardamt_unrounded = ardamt.

                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input armstr.ar_curr,
                       input ar_mstr.ar_curr,
                       input comb_exch_rate,
                       input comb_exch_rate2,
                       input ard_disc,
                       input true,  /* ROUND */
                       output ard_disc,
                       output mc-error-number)"}

                  run p-chk-mc-error-3.

                  /* STORE NEW VALUE ENTERED BY THE USER */
                  ard_disc_unrounded = ard_disc.

                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input armstr.ar_curr,
                       input ar_mstr.ar_curr,
                       input comb_exch_rate,
                       input comb_exch_rate2,
                       input vat_ndisc,
                       input true,  /* ROUND */
                       output vat_ndisc,
                       output mc-error-number)"}

                  run p-chk-mc-error-3.

               end.  /* IF armstr.ar_curr <> ar_mstr.ar_curr */

            end. /*IF ard_ref <> ""*/
            else
               ard_amt = ardamt.

            /* COMBINE EXCHANGE RATES BEFORE CONVERTING */
            run combine_ex_rates_ar_inv_comb.

            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input ar_mstr.ar_curr,
                 input (if avail armstr then armstr.ar_curr
                        else base_curr),
                 input comb_exch_rate,
                 input comb_exch_rate2,
                 input ardamt_unrounded,
                 input true,  /* ROUND */
                 output amt_to_apply,
                 output mc-error-number)"}

            run p-chk-mc-error-3.

            /* TO AVOID ROUNDING PROBLEM FOR APPLIED */
            /* PAYMENT WHEN MEMO CURR AND PAYMENT    */
            /* CURR ARE DIFFERENT                    */

            if  ard_ref <> ""
            and armstr.ar_curr <> ar_mstr.ar_curr
            and ardamt = old_ardamt
            then
               amt_to_apply = ard_det.ard_cur_amt +
                              ard_det.ard_cur_disc.

         end. /*IF ardamt entered*/
         else
            ard_disc = amt_disc.

         ard_amt     = ardamt - ard_disc.

         /* ASSIGN NEW AMOUNTS TO PAYMENT DETAIL INVOICE CURR FIELDS */
         if ard_ref <> ""
         /* INVOICE/MEMO IS ATTACHED */
            and armstr.ar_curr <> ar_mstr.ar_curr
         /* INVOICE/MEMO CURRENCY NOT SAME AS PAYMENT CURRENCY */
            and ardamt <> old_ardamt
         /* AMOUNT-TO-APPLY WAS CHANGED */
         then do:

            run combine_ex_rates_ar_inv_comb.

            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input ar_mstr.ar_curr,
                 input armstr.ar_curr,
                 input comb_exch_rate,
                 input comb_exch_rate2,
                 input ard_amt,
                 input true, /* ROUND */
                 output ard_cur_amt,
                 output mc-error-number)"}

            run p-chk-mc-error-3.
            run combine_ex_rates_ar_inv_comb.

            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input ar_mstr.ar_curr,
                 input (if avail armstr then armstr.ar_curr
                        else base_curr),
                 input comb_exch_rate,
                 input comb_exch_rate2,
                 input ard_disc,
                 input true, /* ROUND */
                 output ard_cur_disc,
                 output mc-error-number)"}

            run p-chk-mc-error-3.

         end. /* IF ard_ref <> "" */

         /* COMPUTE THE EQUIVALENT VALUE FROM UNROUNDED FIGURES */
         ard_amt_unrounded = ardamt_unrounded - ard_disc_unrounded.

      end. /*IF NEW ard_det*/

      /*---------------------------------------------------------------*/

      ststatus = stline[2].
      status input ststatus.

      display
         ard_amt
         ard_disc
      with frame d.

      assign
         old_amt                = ard_amt
         old_disc               = ard_disc
         old_ard_amt_unrounded  = ard_amt_unrounded
         old_ard_disc_unrounded = ard_disc_unrounded.

      set2:
      do with frame d on error undo, retry:
         set ard_amt ard_disc
            when (ard_type <> "N")
            go-on ("F5" "CTRL-D" ).

         /* DELETE */
         if lastkey = keycode("F5") or
            lastkey = keycode("CTRL-D")
         then do:

            del-yn = yes.
            {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn
                     &CONFIRM-TYPE='LOGICAL'}

            if not del-yn then undo.
         end. /* IF lastkey = keycode("F5") OR... */

         {&ARPAMTC-P-TAG51}
         /* VALIDATE ard_amt PER PAYMENT CURRENCY RNDMTHD.  */
         /* PAYMENT CURRENCY IS BASE IF PAYMENT CURRENCY    */
         /* IS DIFFERENT FROM APPLY-TO DOCUMENT CURRENCY    */
         if (ard_amt <> 0)
         then do:

            {gprun.i ""gpcurval.p"" "(input ard_amt,
                                      input rndmthd,
                                      output retval)"}
            if (retval <> 0)
            then do:

               next-prompt ard_amt with frame d.
               undo set2, retry set2.
            end. /* IF (retval <> 0) */
         end. /* IF (ard_amt <> 0) */

         /* VALIDATE disc_amt PER PAYMENT CURRENCY RNDMTHD.  */
         /* PAYMENT CURRENCY IS BASE IF PAYMENT CURRENCY     */
         /* IS DIFFERENT FROM APPLY-TO DOCUMENT CURRENCY     */
         if (ard_disc <> 0)
         then do:

            {gprun.i ""gpcurval.p"" "(input ard_disc,
                                      input rndmthd,
                                      output retval)"}
            if (retval <> 0)
            then do:

               next-prompt ard_disc with frame d.
               undo set2, retry set2.
            end. /* IF (retval <> 0) */
         end. /* If (ard_disc <> 0) */

         /* PARTIAL PAYMENT OF THE CREDIT MEMO/INVOICE SHOULD BE */
         /* ALLOWED.                                             */
         if ard_ref   <> ""
         then do:

            /* CHECK IF CASH AMOUNT FOR A CREDIT MEMO/INVOICE IS */
            /* POSITIVE.                                         */
            if ardamt  < 0 and
               ard_amt > 0
            then do:

               /* AMOUNT APPLIED IS GREATER THAN AMOUNT OPEN */
               run p_pxmsg(input 1157,
                           input 3).

               undo set2, retry set2.
            end. /* IF ardamt < 0 AND ard_amt > 0 */

            /* CHECK IF CASH AMOUNT FOR A DEBIT MEMO/INVOICE IS */
            /* NEGATIVE.                                        */
            if ardamt  > 0  and
               ard_amt < 0
            then do:

               /* CANNOT ACCEPT CHECK WITH NEGATIVE NET AMOUNT */
               run p_pxmsg(input 4017,
                           input 3).

               undo set2, retry set2.
            end. /* IF ardamt > 0 AND ard_amt < 0 */

         end. /* IF ard_ref <> "" */
         {&ARPAMTC-P-TAG18}

         /* IF INVOICE AND BASE CURRENCY ARE BOTH PART OF EMU THEN   */
         /* CASH AMOUNT PLUS DISCOUNT CAN NOT BE GREATER THAN        */
         /* AMOUNT TO APPLY SINCE THERE WILL BE A FIXED RATE BETWEEN */
         /* THE INVOICE AND BASE CURRENCY                            */

         if ard_ref <> ""
         then
            run check_invoice_curr.

         if ard_amt + ard_disc > ardamt and
            is_emu_curr
         then do:

            /* AMOUNT APPLIED IS GREATER THAN AMOUNT OPEN */
            run p_pxmsg(input 1157,
                        input 3).

            next-prompt ard_amt with frame d.
            undo set2, retry set2.
         end. /* IF ard_amt + ard_disc > ardamt AND... */
         {&ARPAMTC-P-TAG19}

         /* RECALCULATE IF NECESSARY curr_amt,   */
         /* curr_disc AND amt_to_apply           */
         /* IN APPLY-TO DOCUMENT CURRENCY        */
         if ard_amt <> old_amt
         then do:

            run combine_ex_rates_ar_inv_comb.

            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input ar_mstr.ar_curr,
                 input (if avail armstr then armstr.ar_curr
                        else base_curr),
                 input comb_exch_rate,
                 input comb_exch_rate2,
                 input ard_amt,
                 input true, /* ROUND */
                 output curr_amt,
                 output mc-error-number)"}

            run p-chk-mc-error-3.

         end. /* IF ard_amt <> old_amt */

         if is_transparent
         then
            ard_det.ard_cur_amt = curr_amt.

         if ard_disc <> old_disc
         then do:

            run proc_curr_disc_to_memo.
            run p-chk-mc-error-3.
         end. /* IF ard_disc <> old_disc */

         /* CHECK IF THE CASH + DISCOUNT AMOUNT EXCEEDS OPEN AMOUNT */
         /* FOR THE FOREIGN CURRENCY INVOICE/MEMO                   */
         if not first_foreign
            and not del-yn
            and ard_ref        <> " "
            and armstr.ar_curr <> ar_mstr.ar_curr
            and amt_to_apply   <  curr_amt + curr_disc
         then do:

            /* AMOUNT APPLIED IS GREATER THAN AMOUNT OPEN */
            run p_pxmsg(input 1157,
                        input 3).

            undo set2, retry set2.

         end. /* IF NOT first_foreign AND NOT...*/

         assign
            ard_amt_entered  = (old_amt <> ard_amt)
            ard_disc_entered = (old_disc <> ard_disc).

         /* STORE THE NEW VALUES ENTERED BY USER */
         if ard_amt entered or
            ard_disc entered
         then
            assign
               ard_amt_unrounded  = if old_amt = ard_amt then
                                    old_ard_amt_unrounded else ard_amt
               ard_disc_unrounded = if old_disc = ard_disc then
                                    old_ard_disc_unrounded else ard_disc.

         if ard_amt = 0
         then
            ard_cur_amt = 0.
         if ard_disc = 0
         then
            ard_cur_disc = 0.

         if ard_amt  <> old_amt or
            ard_disc <> old_disc
         then
            if ard_amt + ard_disc <> ardamt
            then
               amt_to_apply = curr_amt + curr_disc.

         /* IF INVOICE CURR <> PAYMENT CURR  */
         /* THEN PROMPT FOR AMOUNT TO APPLY  */
         /* IN INVOICE CURR; THE DEFAULT WILL*/
         /* BE CALCULATED USING PMT EXG RATE */
         /* BUT DON'T CHANGE THE EXCH RATE   */
         /* IF IT'S A DISCOUNTED DRAFT.      */

         /* CONTAINS THE DISCOUNT EXCH RATE  */
         /*(SKIP THESE PROMPTS IF APPLICATION IS BEING DELETED) */
         {&ARPAMTC-P-TAG20}
         if not del-yn and
            ard_ref <> ""
         then
         {&ARPAMTC-P-TAG21}
            if armstr.ar_curr <> ar_mstr.ar_curr
               and amt_to_apply <> 0
               and not (armstr.ar_type = "D"
               and (armstr.ar_dd_ex_rate <> 1 or
                    armstr.ar_dd_ex_rate2 <> 1 or
                    armstr.ar_dd_curr <> "" ) )
            then do:

               run multi-currency-data-frame.
               if keyfunction(lastkey) = "end-error"
               then
                  undo set2, retry set2.
            end. /* IF armstr.ar_curr <> ar_mstr.ar_curr AND... */

            else
               amt_to_apply = ard_disc + ard_amt.
         else
            amt_to_apply = ard_disc + ard_amt.
      end. /*set2*/

      if del-yn
      then do:

         run delete_proc.
         {&ARPAMTC-P-TAG36}
            l_ar_base_amt = l_ar_base_amt - l2_ar_base_amt.
         delete ard_det.
         clear frame d.
         del-yn = no.

         /* RESET THE VARIABLES inv_to_base_rate , inv_to_base_rate2 AND   */
         /* DELETE THE qad_wkfl ONLY WHEN THERE ARE NO ard_det RECORDS     */
         /* WITH CURRENCY DIFFERENT FROM THE PAYMENT CURRENCY              */

         if ar_mstr.ar_curr <> base_curr
         then do:

            for first ard_det
               fields( ard_domain  ard_acct ard_amt ard_cc ard_cur_amt
               ard_cur_disc
                       ard_disc ard_dy_code ard_dy_num ard_entity ard_nbr
                       ard_ref ard_sub ard_tax ard_tax_at ard_type )
                where ard_det.ard_domain = global_domain and  ard_nbr =
                ar_mstr.ar_nbr
               no-lock:
            end. /* FOR FIRST ard_det */

         end. /* IF ar_mstr.ar_curr <> base_curr */
         else do:

            for first ard_det
               fields( ard_domain  ard_acct ard_amt ard_cc ard_cur_amt
               ard_cur_disc
                       ard_disc ard_dy_code ard_dy_num ard_entity ard_nbr
                       ard_ref ard_sub ard_tax ard_tax_at ard_type )
                where ard_det.ard_domain = global_domain and  ard_nbr =
                ar_mstr.ar_nbr
                 and can-find (first armstr
                                   where armstr.ar_domain = global_domain and
                                   armstr.ar_nbr  = ard_ref
                                     and armstr.ar_curr <> ar_mstr.ar_curr
                                  use-index ar_nbr no-lock )
               no-lock :
            end. /* FOR FIRST ard_det */

         end. /* ELSE DO */

         if not available ard_det
         then do:

            for each  qad_wkfl
                where qad_wkfl.qad_domain = global_domain and  qad_key1 =
                "AR_MSTR"
                 and qad_key2 = ar_mstr.ar_nbr
               exclusive-lock :
               delete qad_wkfl.
            end. /* FOR EACH  qad_wkfl . */

            assign
               first_foreign     = no
               inv_to_base_rate  = 1
               inv_to_base_rate2 = 1.

         end. /* IF NOT AVAILABLE ard_det */

         next loope.
      end. /* IF del-yn */

      if ard_ref <> ""
      then do:

         /* CHECK FOR OVERPAYMENT           */
         /* DON'T LET THE APPLICATION DRIVE */
         /* THE OPEN AMOUNT ACROSS ZERO.    */
         {&ARPAMTC-P-TAG22}
         if ( armstr.ar_amt - armstr.ar_applied < amt_to_apply
            and armstr.ar_amt - armstr.ar_applied > 0
            and amt_to_apply > 0 )
            or( armstr.ar_amt - armstr.ar_applied > amt_to_apply
            and armstr.ar_amt - armstr.ar_applied < 0
            and amt_to_apply < 0 )
            {&ARPAMTC-P-TAG58}
         then do:

            run p_pxmsg(input 1157,
                        input 3).

            undo, retry.
         end. /* If (armstr.ar_amt - armstr.ar_applied < amt_to_apply AND... */

         /* UPDATE MEMO APPLIED AMOUNT */
         {&ARPAMTC-P-TAG23}

     assign
        armstr.ar_applied = armstr.ar_applied + amt_to_apply
        l_unrnd_amt       = amt_to_apply.

         /* CHANGES MADE TO CONVERT amt_to_apply TO BASE CURRENCY */
         /* AND THEN ACCUMULATE IT TO ar_base_applied TO AVOID    */
         /* ROUNDING DIFFERENCE BETWEEN AR AND GL ENTRIES.        */

         /* CONVERT FROM FOREIGN TO BASE CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input armstr.ar_curr,
              input base_curr,
              input armstr.ar_ex_rate,
              input armstr.ar_ex_rate2,
              input l_unrnd_amt,
              input true, /* ROUND */
              output l_rnd_amt,
              output mc-error-number)"}.
         run p-chk-mc-error-3.

         armstr.ar_base_applied = armstr.ar_base_applied + l_rnd_amt.

         {&ARPAMTC-P-TAG24}
         assign
            armstr.ar_paid_date = if armstr.ar_applied = 0
                                  then ? else ar_mstr.ar_date
            {&ARPAMTC-P-TAG25}
            armstr.ar_open      = armstr.ar_amt <> armstr.ar_applied.

          /* SS - 080830.1 - B */
          if armstr.ar_open          = no
             and armstr.ar_base_amt <> armstr.ar_base_applied
             and armstr.ar_amt       = armstr.ar_applied
             and armstr.ar_curr     <> base_curr
             and ar_mstr.ar_curr     = base_curr
             THEN DO:
             assign
                l_round_amt = armstr.ar_base_amt - armstr.ar_base_applied
                armstr.ar_base_applied = armstr.ar_base_applied + l_round_amt
                .
          END.
          /* SS - 080830.1 - E */
      end. /* IF ard_ref <> "" */

      if ard_type <> "U"
      then do:

         /* UPDATE PAYMENT APPLIED AMOUNT */
         assign
            ar_mstr.ar_applied = ar_mstr.ar_applied + ard_amt
            l_unrnd_amt        = ard_amt.
        {&ARPAMTC-P-TAG59}

         if ard_ref <> ""
         /* INVOICE/MEMO ATTACHED */
            and ard_cur_amt + ard_cur_disc <> 0
         /* PAYMENT DETAIL HAS A FOREIGN CURRENCY AMOUNT */
            and ard_cur_amt + ard_cur_disc = armstr.ar_amt
         /* PAYMENT FOREIGN CURRENCY AMOUNT EQUALS */
         /*  INVOICE/MEMO AMOUNT */
         then do:

            base_amt_disc = armstr.ar_base_amt
                            /* USE INVOICE/MEMO BASE AMOUNT */
                            * ard_disc
                            / (ard_amt + ard_disc).
                            /* IN SAME PROPORTION AS DISCOUNT */

            /* ROUND TO BASE METHOD */
            {gprunp.i "mcpl" "p" "mc-curr-rnd"
               "(input-output base_amt_disc,
                 input gl_ctrl.gl_rnd_mthd,
                 output mc-error-number)"}
            run p-chk-mc-error-3.

            /* MAKE PAYMENT + DISCOUNT BALANCE TO INVOICE/MEMO */
            ar_mstr.ar_base_applied = armstr.ar_base_amt
                                      + ar_mstr.ar_base_amt
                                      - base_amt_disc.
         end. /* IF ard_ref <> "" AND... */
         else do:

            /* CHANGES MADE TO CONVERT ard_amt TO BASE CURRENCY   */
            /* AND THEN ACCUMULATE IT TO ar_base_applied TO AVOID */
            /* ROUNDING DIFFERENCE BETWEEN AR AND GL ENTRIES.     */

            /* CONVERT FROM FOREIGN TO BASE CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input ar_mstr.ar_curr,
                 input base_curr,
                 input ar_mstr.ar_ex_rate,
                 input ar_mstr.ar_ex_rate2,
                 input l_unrnd_amt,
                 input true, /* ROUND */
                 output l_rnd_amt,
                 output mc-error-number)"}.
            run p-chk-mc-error-3.

            ar_mstr.ar_base_applied = ar_mstr.ar_base_applied + l_rnd_amt.

         end. /* ELSE DO */
      end. /* IF ard_type <> "U" */

      if ard_det.ard_ref <> "" then
         run p-calculate-tax.

      /* UPDATE GL TRANSACTION FILE */
      assign
         base_amt     = ard_amt
         {&ARPAMTC-P-TAG26}
         gain_amt     = 0
         curr_amt     = ard_amt
         curr_disc    = ard_disc
         base_det_amt = ard_amt + ard_disc.

      run compute_amt_applied_in_base (1).

      /* CREATE GL POSTINGS */
      ard_recno = recid(ard_det).
      if available armstr
      then
         arbuff_recno = recid(armstr).
      undo_all = yes.
      {&ARPAMTC-P-TAG27}

      if not can-find (first arddet2
                          where arddet2.ard_domain = global_domain
                          and      arddet2.ard_nbr = ar_mstr.ar_nbr
                          and      arddet2.ard_ref = ard_det.ard_ref)
         or l_oldamt  <> ard_det.ard_amt
         or l_olddisc <> ard_det.ard_disc
      then do:

      /* FIRST INPUT PARAMETER INDICATES NOT A REVERSAL AND SECOND INPUT */
      /* INPUT PARAMETER INDICATES THAT THE SEQUENCE NUMBER GENERATION   */
      /* WILL BE DELAYED.                                                */

        {gprun.i ""arargl1.p""
               "(input false,
                 input true)"}
      end. /* IF NOT CAN-FIND(FIRST arddet2..) */

      if undo_all
      then
         undo loope, leave.

      /* ASSIGNMENT OF DAYBOOK AND NRM SEQUENCE TO ARD_DET REMOVED */
      /* FROM HERE BECAUSE THIS IS TAKEN CARE IN arpamtm.p.        */

      if daybooks-in-use
         and not can-find (tt_ard_manual
         where tt_ard_nbr    = ard_nbr
         and   tt_ard_ref    = ard_ref
         and   tt_ard_type   = ard_type
         and   tt_ard_tax_at = ard_tax_at
         and   tt_ard_entity =  ard_entity
         and   tt_ard_acct   =  ard_acct
         and   tt_ard_sub    = ard_sub
         and   tt_ard_cc     = ard_cc
         and   tt_ard_tax    = ard_tax)
      then do:
         create tt_ard_manual.
            assign
               tt_ard_nbr    = ard_nbr
               tt_ard_ref    = ard_ref
               tt_ard_type   = ard_type
               tt_ard_tax_at = ard_tax_at
               tt_ard_entity = ard_entity
               tt_ard_acct   = ard_acct
               tt_ard_sub    = ard_sub
               tt_ard_cc     = ard_cc
               tt_ard_tax    = ard_tax.
      end. /* IF daybooks-in-use */


      if cash_book
      then do:

         run ip-cal-base-amt(output l1_ar_base_amt).

         /* STORE THE ar_base_amt */
            l_ar_base_amt = l_ar_base_amt + l1_ar_base_amt
                          - l2_ar_base_amt.
      end. /* IF cash_book */

      run update_customer_balance.

      /* UPDATE PAYMENT TOTAL */
      {&ARPAMTC-P-TAG28}
      if ard_ref <> ""
      then
         assign
            ar_mstr.ar_amt = ar_mstr.ar_amt + ard_amt
            l_unrnd_amt    = ard_amt.
      else
         assign
            ar_mstr.ar_amt = ar_mstr.ar_amt + ard_amt + ard_disc
            l_unrnd_amt    = ard_amt + ard_disc.

      {&ARPAMTC-P-TAG29}

      if ard_ref <> ""
         /* INVOICE/MEMO ATTACHED */
         and ard_cur_amt + ard_cur_disc <> 0
         /* PAYMENT DETAIL HAS A FOREIGN CURRENCY AMOUNT */
         and ard_cur_amt + ard_cur_disc = armstr.ar_amt
         /* PAYMENT FOREIGN CURRENCY AMOUNT EQUALS */
         /*  INVOICE/MEMO AMOUNT */
      then do:

         base_amt_disc = armstr.ar_base_amt
                       /* USE INVOICE/MEMO BASE AMOUNT */
                       * ard_disc
                       / (ard_amt + ard_disc).
                       /* IN SAME PROPORTION AS DISCOUNT */
         /* ROUND TO BASE METHOD */
         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output base_amt_disc,
              input gl_ctrl.gl_rnd_mthd,
              output mc-error-number)"}
         run p-chk-mc-error-3.

         /* MAKE PAYMENT + DISCOUNT BALANCE TO INVOICE/MEMO */
         ar_mstr.ar_base_amt = armstr.ar_base_amt - base_amt_disc
                                                  + ar_mstr.ar_base_amt.
      end. /* IF ard_ref <> "" AND... */
      else do:

         /* CHANGES MADE TO CONVERT ard_amt OR (ard_amt + ard_disc) */
         /* TO BASE CURRENCY AND THEN ACCUMULATE IT TO ar_base_amt  */
         /* TO AVOID ROUNDING DIFFERENCE BETWEEN AR AND GL ENTRIES. */

         /* CONVERT FROM FOREIGN TO BASE CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input ar_mstr.ar_curr,
              input base_curr,
              input ar_mstr.ar_ex_rate,
              input ar_mstr.ar_ex_rate2,
              input l_unrnd_amt,
              input true, /* ROUND */
              output l_rnd_amt,
              output mc-error-number)"}.
         run p-chk-mc-error-3.

         ar_mstr.ar_base_amt = ar_mstr.ar_base_amt + l_rnd_amt.

      end. /* ELSE DO */

      /*REFRESH FRAME C */
      view frame c.
      clear frame c all no-pause.
      hold_ard_ref = ard_ref.

      refreshc:
      for each ard_det
         fields( ard_domain ard_acct ard_amt ard_cc ard_cur_amt ard_cur_disc
                 ard_disc ard_dy_code ard_dy_num ard_entity ard_nbr
                 ard_ref ard_sub ard_tax ard_tax_at ard_type)
          where ard_det.ard_domain = global_domain and  ard_nbr =
          ar_mstr.ar_nbr and
               ard_ref >= hold_ard_ref
         no-lock:

         if available ard_det
         then do:

            /* FIND THE ASSOCIATED MASTERFILE RECORD */
            for first armstr1
               fields( ar_domain ar_acct ar_amt ar_applied ar_base_amt
               ar_base_applied
                       ar_bill ar_cc ar_check ar_contested ar_cr_terms ar_curr
                       ar_date ar_dd_curr ar_dd_ex_rate ar_dd_ex_rate2
                       ar_disc_date ar_draft ar_due_date ar_dy_code ar_effdate
                       ar_entity ar_exru_seq ar_ex_rate ar_ex_rate2
                       ar_ex_ratetype ar_nbr ar_open ar_paid_date ar_sub
                       ar_type ar_xslspsn1)
                where armstr1.ar_domain = global_domain and  armstr1.ar_nbr =
                ard_ref
               no-lock:
            end. /* FOR FIRST armstr1 */

            pause 0.

            if available armstr1
            then do:

               tmpamt = armstr1.ar_amt - armstr1.ar_applied.
               {&ARPAMTC-P-TAG60}
               if armstr1.ar_curr <> ar_mstr.ar_curr
               then
                  /* CONVERT FROM INVOICE/MEMO CURR TO PAYMENT CURR */
                  run proc_tmpamt_to_pay.
            end. /* IF AVAILABLE armstr1 */

            display
               ard_ref
               ard_type
               ard_tax @ ref_nu
               armstr1.ar_due_date when (available armstr1)
               tmpamt when (available armstr1) @ open_amt
               ard_amt
            with frame c down.
            if frame-line(c) = frame-down(c) then leave.
            pause 0.
            down 1 with frame c.
         end. /* IF AVAILABLE ard_det */
         else leave.
      end. /* FOR EACH ard_det */

   end.  /* loope */
   {&ARPAMTC-P-TAG52}

   /*------------------------------------------------------------------*/

   PROCEDURE multi-currency-data-frame:

      define variable base_gain_loss like ard_amt no-undo.
      define variable base_amt_date  like ar_date no-undo.

      define variable c-invoice1    as character no-undo.
      define variable c-payment1    as character no-undo.
      define variable c-invoice2    as character no-undo.
      define variable c-payment2    as character no-undo.
      define variable c-discount    as character no-undo.
      define variable c-amt-2-apply as character format "x(15)" no-undo.
      define variable c-gn-or-loss  as character format "x(9)" no-undo.
      define variable c-base        as character no-undo.
      define variable c-base-value  as character format "x(10)" no-undo.

      assign
         c-invoice1    = getTermLabelRt("INVOICE",8)
         c-payment1    = getTermLabel("PAYMENT",7)
         c-invoice2    = getTermLabel("INVOICE",7)
         c-payment2    = getTermLabel("PAYMENT",7)
         c-discount    = getTermLabel("DISCOUNT",8)
         c-amt-2-apply = getTermLabel("AMOUNT_T0_APPLY",15)
         c-gn-or-loss  = getTermLabel("GAIN/LOSS",9)
         c-base        = getTermLabelRt("BASE",8)
         c-base-value  = getTermLabel("BASE_VALUE",10).

      define frame et_set2_sub
         c-payment1      at 36
         c-invoice1      to 59
         c-base          to 76
         ar_mstr.ar_curr to 42
         armstr.ar_curr to  59
         gl_ctrl.gl_base_curr to 76
         c-invoice2     at 2
         armstr.ar_date at 16
         ":" at 25
         inv_amt_open to 59
         base_amt_expected to 76
         skip(1)
         c-payment2 at 2
         ar_mstr.ar_date at 16
         ":" at 25
         ard_det.ard_amt to 42
         inv_amt_paid to 59
         base_amt_paid to 76
         c-discount   at 2
         ar_mstr.ar_cr_terms at 16
         ":" at 25
         ard_disc to 42
         inv_amt_disc to 59
         base_amt_disc to 76
         "================" to 59
         "================" to 76
         c-amt-2-apply at 2
         ":" at 25
         amt_to_apply to 59
         base_amt_total to 76
         skip(1)
         c-base-value at 2
         base_amt_date at 16
         ":" at 25
         base_amt_to_settle to 76
         c-gn-or-loss  at 2
         ":" at 25
         base_gain_loss to 76
      with no-label width 80 overlay row 5.

      set2_sub:
      do on error undo, retry:

         /* SAVE amt_to_apply FOR CALCULATION OF NEW */
         /* EXCHANGE RATE AND TOLERANCE VALIDATION   */
         l_calc_amt_to_apply = amt_to_apply.

         /* OF COURSE THIS CAN'T BE MORE */
         /* THAN IS OPEN ON THE INVOICE  */

         if armstr.ar_amt > 0
         then
            amt_to_apply =
            min(amt_to_apply,armstr.ar_amt - armstr.ar_applied).
         else
         if armstr.ar_amt < 0
         then
            amt_to_apply =
            max(amt_to_apply,armstr.ar_amt - armstr.ar_applied).

         /* AMOUNT TO APPLY IN THE INVOICE CURRENCY */
         old_amt_to_apply = amt_to_apply.

         /* FORMAT amt_to_apply PER DOCUMENT CURR */
         amt_app_fmt = amt_app_old.

         {gprun.i ""gpcurfmt.p"" "(input-output amt_app_fmt,
                                   input apply2_rndmthd)"}
         assign
            amt_to_apply:format in frame set2_sub    = amt_app_fmt
            amt_to_apply:format in frame et_set2_sub = amt_app_fmt.

         {gprunp.i "mcpl" "p" "mc-combine-ex-rates"
            "(input ar_mstr.ar_ex_rate,
              input ar_mstr.ar_ex_rate2,
              input armstr.ar_ex_rate2,
              input armstr.ar_ex_rate,
              output comb_exch_rate,
              output comb_exch_rate2)"}

         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input ar_mstr.ar_curr,
              input armstr.ar_curr,
              input comb_exch_rate,
              input comb_exch_rate2,
              input ardamt_unrounded,
              input true, /* ROUND */
              output inv_amt_to_apply,
              output mc-error-number)"}

         if is_transparent
         then do:

            /* FOLLOWING PROCEDURE GETS VARIOUS VALUES BEING    */
            /* DISPLAYED IN ETK ACTIVE MODE. THE VALUES ARE     */
            /* POPULATED IN FOLLOWING FIELDS base_amt_expected, */
            /* inv_amt_paid (AMT PAID IN INVOICE CURRENCY),     */
            /* base_amt_paid, base_amt_disc, inv_amt_disc (DISC */
            /* IN INVOICE CURR), base_amt_to_apply,             */
            /* base_amt_to_settle.                              */

            run get_etk_screen_values.

            display
               c-payment1
               c-invoice1
               c-base
               ar_mstr.ar_curr
               armstr.ar_curr
               gl_base_curr
               c-invoice2
               armstr.ar_date
               inv_amt_open
               base_amt_expected when (available armstr)
               c-payment2
               ar_mstr.ar_date
               ard_amt
               inv_amt_paid
               base_amt_paid
               c-discount
               ar_mstr.ar_cr_terms
               ard_disc
               inv_amt_disc
               base_amt_disc
               c-amt-2-apply
               amt_to_apply
               base_amt_total
               c-base-value
               armstr.ar_date
               @ base_amt_date
               base_amt_to_settle
               c-gn-or-loss
               (base_amt_paid + base_amt_disc
               - base_amt_to_settle)
               @ base_gain_loss
            with frame et_set2_sub.

            update amt_to_apply
            with frame et_set2_sub.

            /* IF INVOICE AND BASE CURRENCY ARE BOTH PART OF   */
            /* EMU, FIELD amt_to_apply CAN NOT BE CHANGED SINCE*/
            /* THERE WILL BE A FIXED RATE BETWEEN THE INVOICE  */
            /* AND BASE CURRENCY                               */
            if is_emu_curr and
               amt_to_apply <> old_amt_to_apply
            then do:

               run p_pxmsg(input 2271,
                           input 3).

               /* CAN NOT CHANGE AMOUNT TO APPLY           */
               /* FOR CURRENCIES WITH FIXED EXCHANGE RATE. */
               undo set2_sub, retry.
            end. /* IF is_emu_curr AND... */
         end. /* IF is-transparent */
         else do:
            display
               armstr.ar_curr
            with frame set2_sub.
            update
               amt_to_apply
            with frame set2_sub.
         end. /* ELSE DO */
         if amt_to_apply = 0
         then do:

            /*ZERO NOT ALLOWED*/
            run p_pxmsg(input 317,
                        input 3).

            undo set2_sub, retry.
         end. /* IF amt_to_apply = 0 */
         else do:

            {gprun.i ""gpcurval.p"" "(input amt_to_apply,
                                      input apply2_rndmthd,
                                      output retval)"}
            if (retval <> 0)
            then do:

               if is_transparent
               then
                  next-prompt amt_to_apply with frame et_set2_sub.
               else
                  next-prompt amt_to_apply with frame set2_sub.
               undo set2_sub, retry set2_sub.
            end. /* If (retval <> 0) */
         end. /* ELSE DO */

         /* FIND THE RESULTING EXCHANGE   */
         /* RATE (foreign amt / base_amt) */
         if not first_foreign and
            amt_to_apply <> old_amt_to_apply
         then do:

            /* CAN ONLY CHANGE AMOUNT TO APPLY FOR FIRST FOREIGN INVOICE */
            run p_pxmsg(input 143,
                        input 3).

            undo set2_sub, retry.
         end. /* IF NOT first_foreign AND... */

         /* USE THE SAVED l_calc_amt_to_apply */

         if first_foreign
            and (amt_to_apply <> l_calc_amt_to_apply
                 or ard_amt   <> old_amt
                 or ard_disc  <> old_disc)
         then do:

            exch_var = 100 * ( (amt_to_apply / l_calc_amt_to_apply) - 1 ).

            if exch_var < 0
            then
               exch_var = - exch_var.

            /* DO NOT VALIDATE IF EXCHANGE TOLERANCE IS SET TO ZERO */
            if exch_var > arc_ctrl.arc_ex_tol
               and arc_ctrl.arc_ex_tol <> 0
            then do:

               run p_action (input 145, input exch_var).
               /* EXCHANGE RATE OUT OF TOLERANCE, */
               /* CANNOT APPLY THIS AMOUNT        */
               undo set2_sub, retry.
            end. /* IF exch_var > arc_ctrl.arc_ex_tol */
            else do:

               /* RECOMPUTE INVOICE TO BASE CURRENCY RELATION     */
               /* SINCE THE USER CHANGED INVOICE CURRENCY "AMOUNT */
               /* TO APPLY" (amt_to_apply in frame set2_sub)      */

               run combine_ex_rates_ar_inv_comb.

               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input  ar_mstr.ar_curr,
                    input  (if avail armstr
                            then
                               armstr.ar_curr
                            else
                               base_curr),
                    input  comb_exch_rate,
                    input  comb_exch_rate2,
                    input  ard_amt + ard_disc,
                    input  false,  /* DO NOT ROUND */
                    output l_calc_amt_to_apply,
                    output mc-error-number)"}

               run p-chk-mc-error-3.

               inv_to_base_rate = (amt_to_apply / l_calc_amt_to_apply)
                                  * inv_to_base_rate.

               /* UPDATE INV OR MEMO TO BASE EXCH RATE IN qad_wkfl */
               {arupdwfl.i
                  ar_mstr.ar_nbr
                  inv_to_base_rate
                  inv_to_base_rate2}

            end. /* ELSE DO */

         end. /* IF first_foreign AND... */

         /* IF AMT, DISC, OR AMT_TO APPLY CHANGED, SET CURR AMTS */
         if ard_amt_entered
            or ard_disc_entered
            or amt_to_apply <> old_amt_to_apply
            or ardamt_entered
         then do:

            /* CONVERT FROM FOREIGN TO BASE TO FOREIGN */

            run combine_ex_rates_ar_inv_comb.

            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input ar_mstr.ar_curr,
                 input (if avail armstr then armstr.ar_curr
                        else base_curr),
                 input comb_exch_rate,
                 input comb_exch_rate2,
                 input ard_amt,
                 input true, /* ROUND */
                 output ard_cur_amt,
                 output mc-error-number)"}

            if mc-error-number <> 0
            then do:

               run p_pxmsg(input mc-error-number,
                           input 3).

            end. /* IF mc-error-number <> 0 */

            assign
               ard_cur_amt  = min(ard_cur_amt, amt_to_apply)
               ard_cur_disc = amt_to_apply - ard_cur_amt.

            if ard_cur_disc <> 0
               and ard_disc =  0
            then
               assign
                  ard_cur_amt  = ard_cur_amt + ard_cur_disc
                  ard_cur_disc = 0.

         end. /* IF ard_amt_entered OR... */

      end. /*set2_sub*/

      hide frame et_set2_sub no-pause.

   END PROCEDURE. /* PROCEDURE multi_currency_data_frame */

   /*------------------------------------------------------------------*/

   PROCEDURE get_etk_screen_values:

      /* CONVERT FROM FOREIGN TO BASE CURRENCY */
      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input armstr.ar_curr,
           input base_curr,
           input armstr.ar_ex_rate,
           input armstr.ar_ex_rate2,
           input (armstr.ar_amt - armstr.ar_applied),
           input false, /* DO NOT ROUND */
           output base_amt_expected, /*AMT EXPECTED IN BASE CURR*/
           output mc-error-number)"}.
      if mc-error-number <> 0
      then do:

         run p_pxmsg(input mc-error-number,
                     input 3).

      end. /* IF mc-error-number <> 0 */

      /* CONVERT FROM FOREIGN TO BASE TO FOREIGN                 */
      /* USE ard_amt_unrounded VALUE IN PLACE OF ard_det.ard_amt */
      /* SO THAT THE ROUNDING DIFFERENCE INVOICE AMOUNT TO APPLY */
      /* AND INVOICE AMOUNT EXPECTED CAN BE AVOIDED              */

      if new ard_det or
         ard_amt_entered or
         ard_disc_entered or
         ardamt_entered
      then do:

         run combine_ex_rates_ar_inv_comb.

         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input ar_mstr.ar_curr,
              input armstr.ar_curr,
              input comb_exch_rate,
              input comb_exch_rate2,
              input ard_amt_unrounded,
              input no, /* DO NOT ROUND */
              output inv_amt_paid,
              output mc-error-number)"}

      end. /* IF NEW ard_det OR ard_amt_entered OR ... */

      else
      inv_amt_paid = if ar_mstr.ar_curr <> armstr.ar_curr and
      ard_det.ard_cur_amt <> 0 then
         ard_det.ard_cur_amt
      else ard_det.ard_amt.

      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output inv_amt_paid,
           input apply2_rndmthd,
           output mc-error-number)"}.

      inv_amt_paid = min(inv_amt_paid, amt_to_apply).

      /* CONVERT FROM FOREIGN TO BASE CURRENCY                   */
      /* USE ard_amt_unrounded VALUE IN PLACE OF ard_det.ard_amt */
      /* SO THAT THE ROUNDING DIFFERENCE INVOICE AMOUNT TO APPLY */
      /* AND INVOICE AMOUNT EXPECTED CAN BE AVOIDED              */
      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input ar_mstr.ar_curr,
           input base_curr,
           input ar_mstr.ar_ex_rate,
           input ar_mstr.ar_ex_rate2,
           input ard_det.ard_amt,
           input true, /* DO NOT ROUND */
           output base_amt_paid,  /* AMT PAID IN BASE CURRENCY */
           output mc-error-number)"}.
      if mc-error-number <> 0
      then do:

         run p_pxmsg(input mc-error-number,
                     input 3).

      end. /* IF mc-error-number <> 0 */

      /* CONVERT FROM FOREIGN TO BASE CURRENCY                     */
      /* USE ard_disc_unrounded VALUE IN PLACE OF ard_det.ard_disc */
      /* SO THAT THE ROUNDING DIFFERENCE INVOICE AMOUNT TO APPLY   */
      /* AND INVOICE AMOUNT EXPECTED CAN BE AVOIDED                */

      if new ard_det or
         ard_amt_entered or
         ard_disc_entered or
         ardamt_entered
      then do:

         if ard_det.ard_disc <> 0
         then
            inv_amt_disc = inv_amt_to_apply - inv_amt_paid.
         else do:
            run combine_ex_rates_ar_inv_comb.

            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input ar_mstr.ar_curr,
                 input armstr.ar_curr,
                 input comb_exch_rate,
                 input comb_exch_rate2,
                 input ard_disc_unrounded,
                 input no, /* DO NOT ROUND */
                 output inv_amt_disc,
                 output mc-error-number)"}
         end. /* ELSE DO */

         inv_amt_disc = inv_amt_disc +
            amt_to_apply - (inv_amt_paid + inv_amt_disc).

         if inv_amt_disc <> 0
            and ard_disc =  0
         then
            assign
               inv_amt_paid = inv_amt_paid + inv_amt_disc
               inv_amt_disc = 0.

      end. /* IF new ard_det OR ard_amt_entered OR ... */

      else
      inv_amt_disc = if ar_mstr.ar_curr <> armstr.ar_curr and
      ard_det.ard_cur_disc <> 0 then
         ard_det.ard_cur_disc
      else ard_det.ard_disc.

      /* CONVERT FROM FOREIGN TO BASE CURRENCY                     */
      /* USE ard_disc_unrounded VALUE IN PLACE OF ard_det.ard_disc */
      /* SO THAT THE ROUNDING DIFFERENCE INVOICE AMOUNT TO APPLY   */
      /* AND INVOICE AMOUNT EXPECTED CAN BE AVOIDED                */
      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input ar_mstr.ar_curr,
           input base_curr,
           input ar_mstr.ar_ex_rate,
           input ar_mstr.ar_ex_rate2,
           input ard_det.ard_disc,
           input true, /* ROUND */
           output base_amt_disc, /* DISCOUNT IN BASE CURRENCY */
           output mc-error-number)"}.
      if mc-error-number <> 0
      then do:

         run p_pxmsg(input mc-error-number,
                     input 3).

      end. /* IF mc-error-number <> 0 */

      if ard_det.ard_ref <> ""
         /* INVOICE/MEMO ATTACHED */
         and ard_det.ard_cur_amt + ard_det.ard_cur_disc <> 0
         /* PAYMENT DETAIL HAS A FOREIGN CURRENCY AMOUNT */
         and ard_det.ard_cur_amt + ard_det.ard_cur_disc
         = armstr.ar_amt
         /* PAYMENT FOREIGN CURRENCY AMOUNT EQUALS */
         /*  INVOICE/MEMO AMOUNT                   */
         and inv_to_base_rate  = armstr.ar_ex_rate
         and inv_to_base_rate2 = armstr.ar_ex_rate2
         /* INVOICE TO BASE RATE ON PMT DATE EQUALS THAT ON INV DATE */
      then do:

         base_amt_disc = armstr.ar_base_amt
                       /* USE INVOICE/MEMO BASE AMOUNT */
                       * ard_det.ard_disc
                       / (ard_det.ard_amt + ard_det.ard_disc).
                       /* IN SAME PROPORTION AS DISCOUNT */
         /* ROUND TO BASE METHOD */
         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output base_amt_disc,
              input gl_ctrl.gl_rnd_mthd,
              output mc-error-number)"}
         if mc-error-number <> 0
         then do:

            run p_pxmsg(input mc-error-number,
                        input 3).

         end. /* If mc-error-number <> 0 */
         /* MAKE PAYMENT + DISCOUNT BALANCE TO INVOICE/MEMO */
         base_amt_paid = armstr.ar_base_amt - base_amt_disc.
      end. /* IF ard_det.ard_ref <> "" AND... */

      if ard_det.ard_ref <> ""
         /* INVOICE/MEMO ATTACHED            */
         and ard_det.ard_cur_amt + ard_det.ard_cur_disc <> 0
         /* PAYMENT DETAIL HAS A FOREIGN CURRENCY AMOUNT */
         and ard_det.ard_cur_amt + ard_det.ard_cur_disc
         = armstr.ar_amt
         /* PAYMENT FOREIGN CURRENCY AMOUNT EQUALS */
         /*  INVOICE/MEMO APPLIED AMOUNT           */
         then
         base_amt_to_settle = armstr.ar_base_amt.
         /* (USE INVOICE/MEMO BASE APPLIED AMOUNT) */
      else
      do:
         run combine_ex_rates_ar_inv_arm_comb.

         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input ar_mstr.ar_curr,
              input base_curr,
              input comb_exch_rate,
              input comb_exch_rate2,
              input (ard_det.ard_amt + ard_det.ard_disc),
              input false, /* DO NOT ROUND */
              output base_amt_to_settle,
              output mc-error-number)"}

         base_amt_to_settle = min(base_amt_expected, base_amt_to_settle).
      end. /* ELSE DO */

      assign
         inv_amt_open   = armstr.ar_amt - armstr.ar_applied
         base_amt_total = base_amt_paid + base_amt_disc.

   END PROCEDURE. /*get_etk_screen_values */

   /*------------------------------------------------------------------*/

   PROCEDURE compute_amt_applied_in_base:

      define input parameter op_mode as integer.
      /* op_mode -1 TO BACKOUT TRANS ELSE 1 */

      /* base_amt = PAYMENT ard_amt                */
      /* base_det_amt = PAYMENT ard_amt + ard_disc */

      /* DETERMINE THE AMOUNT APPLIED IN BASE CURRENCY */
      if ar_mstr.ar_curr <> base_curr
      then do:

         if ard_det.ard_ref <> ""
            /* INVOICE/MEMO ATTACHED */
            and base_amt = op_mode * ard_det.ard_amt
            /* base_amount CAME FROM PAYMENT AMOUNT */
            and ard_det.ard_cur_amt + ard_det.ard_cur_disc <> 0
            /* PAYMENT DETAIL HAS A FOREIGN CURRENCY AMOUNT */
            and ard_det.ard_cur_amt + ard_det.ard_cur_disc
            = armstr.ar_amt
            /* PAYMENT FOREIGN CURRENCY AMOUNT EQUALS */
            /*  INVOICE/MEMO AMOUNT                   */
            and inv_to_base_rate  = armstr.ar_ex_rate
            and inv_to_base_rate2 = armstr.ar_ex_rate2
            /* INVOICE TO BASE RATE ON PMT DATE EQUALS THAT ON INV DATE */
         then do:

            base_amt_disc = armstr.ar_base_applied
                          /* USE INVOICE/MEMO BASE APPLIED AMOUNT */
                          * ard_det.ard_disc
                          / (ard_det.ard_amt + ard_det.ard_disc).
                          /* IN SAME PROPORTION AS DISCOUNT */
            /* ROUND TO BASE METHOD */
            {gprunp.i "mcpl" "p" "mc-curr-rnd"
               "(input-output base_amt_disc,
                 input gl_ctrl.gl_rnd_mthd,
                 output mc-error-number)"}
            if mc-error-number <> 0
            then do:

               run p_pxmsg(input mc-error-number,
                           input 3).

            end. /* IF mc-error-number <> 0 */
            /* MAKE PAYMENT + DISCOUNT BALANCE TO INVOICE/MEMO */
                base_amt = op_mode * (armstr.ar_base_amt - base_amt_disc).
         end. /* IF ard_det.ard_ref <> "" AND... */

         else do:
            /* CONVERT FROM FOREIGN TO BASE CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input ar_mstr.ar_curr,
                 input base_curr,
                 input ar_mstr.ar_ex_rate,
                 input ar_mstr.ar_ex_rate2,
                 input base_amt,
                 input true, /* ROUND */
                 output base_amt,
                 output mc-error-number)"}.
            if mc-error-number <> 0
            then do:

               run p_pxmsg(input mc-error-number,
                           input 3).

            end. /* IF mc-error-number <> 0 */
         end. /* ELSE DO */

         if ard_det.ard_ref <> ""
         then do:

            /* INVOICE */
            if base_det_amt = op_mode *
               (ard_det.ard_amt + ard_det.ard_disc)
               /* base_det_amount CAME FROM PAYMENT AMOUNT */
               and ard_det.ard_cur_amt + ard_det.ard_cur_disc <> 0
               /* (PAYMENT DETAIL HAS A FOREIGN CURRENCY AMOUNT) */
               and ard_det.ard_cur_amt + ard_det.ard_cur_disc
               = armstr.ar_amt
               /* PAYMENT FOREIGN CURRENCY AMOUNT EQUALS */
               /*  INVOICE/MEMO APPLIED AMOUNT           */
               then

            base_det_amt = op_mode * armstr.ar_base_amt.
            /* USE INVOICE/MEMO BASE AMOUNT */
            else do:
               /* PAYMENT CURR -> BASE -> INV CURR -> BASE */
               run combine_ex_rates_ar_inv_arm_comb.

               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input ar_mstr.ar_curr,
                   input base_curr,
                   input comb_exch_rate,
                   input comb_exch_rate2,
                   input base_det_amt,
                   input true, /* ROUND */
                   output base_det_amt,
                   output mc-error-number)"}

               if mc-error-number <> 0
               then do:

                  run p_pxmsg(input mc-error-number,
                              input 3).

               end. /* IF mc-error-number <> 0 */
            end. /* ELSE DO */
         end. /* IF ard_det.ard_ref <> "" */
         else do:
            /* CONVERT FROM FOREIGN TO BASE CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input ar_mstr.ar_curr,
                 input base_curr,
                 input ar_mstr.ar_ex_rate,
                 input ar_mstr.ar_ex_rate2,
                 input base_det_amt,
                 input true, /* ROUND */
                 output base_det_amt,
                 output mc-error-number)"}.
            if mc-error-number <> 0
            then do:

               run p_pxmsg(input mc-error-number,
                           input 3).

            end. /* IF mc-error-number <> 0 */
         end. /* ELSE DO */
         {&ARPAMTC-P-TAG30}
      end. /* IF ar_mstr.ar_curr <> base_curr */
      else
      if ard_det.ard_ref <> ""
      then
         if armstr.ar_curr <> base_curr
         then do:

            /* CHANGED 6TH INPUT PARAMETER FROM FALSE TO */
            /* TRUE TO GET curr_amt AS A ROUNDED VALUE   */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input armstr.ar_curr,
                 input base_curr,
                 input inv_to_base_rate2,
                 input inv_to_base_rate,
                 input ard_amt,
                 input true, /* ROUND */
                 output curr_amt,
                 output mc-error-number)"}.

            if mc-error-number <> 0
            then do:

               run p_pxmsg(input mc-error-number,
                           input 3).

            end. /* IF mc-error-number <> 0 */

            /* CHANGED 6TH INPUT PARAMETER FROM FALSE TO */
            /* TRUE TO GET curr_disc AS A ROUNDED VALUE  */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input armstr.ar_curr,
                 input base_curr,
                 input inv_to_base_rate2,
                 input inv_to_base_rate,
                 input ard_disc,
                 input true, /* ROUND */
                 output curr_disc,
                 output mc-error-number)"}.

            if mc-error-number <> 0
            then do:

               run p_pxmsg(input mc-error-number,
                           input 3).

            end. /* IF mc-error-number <> 0 */

            assign
               curr_amt  = op_mode * curr_amt
               curr_disc = op_mode * curr_disc.

         /* CONVERT FROM FOREIGN TO BASE CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input armstr.ar_curr,
               input base_curr,
               input armstr.ar_ex_rate,
               input armstr.ar_ex_rate2,
               input (curr_amt + curr_disc),
               input true, /* ROUND */
               output base_det_amt,
               output mc-error-number)"}.
         /* SS - 080830.1 - B */
         base_det_amt = base_det_amt + l_round_amt.
         /* SS - 080830.1 - E */
         if mc-error-number <> 0
         then do:

            run p_pxmsg(input mc-error-number,
                        input 3).

         end. /* IF mc-error-number <> 0 */
      end.  /* IF armstr.ar_curr <> base_curr */

   END PROCEDURE.  /* compute_amt_applied_in_base */

   /*------------------------------------------------------------------*/

   PROCEDURE delete_proc:

      /*THIS CODE MOVED HERE TO AVOID ACTION SEGMENT SIZE PROBLEM (63K).*/
      /*IT USED arddet1 buffer WHEN IT WAS PART OF MAIN PROCEDURE       */
      /*NOW A NEW LOCAL BUFFER arddet_del HAS BEEN USED IN ITS PLACE.   */
      define buffer arddet_del for ard_det.

      /* IF DELETE ONLY FOREIGN MEMO      */
      /* FROM BASE CK, RESET ex_rate TO 1 */

      if ard_det.ard_ref <> ""
         and ar_mstr.ar_curr = base_curr
      then do:

         do for arddet_del:  /* PREVIOUSLY WAS arddet1 IN MAIN PROC */
            reset_ok = yes.
            for each arddet_del  where arddet_del.ard_domain = global_domain
            and  arddet_del.ard_nbr = ar_mstr.ar_nbr
                  and arddet_del.ard_ref <> ""
                  and arddet_del.ard_ref <> ard_det.ard_ref:

               for first armstr1
                   fields( ar_domain ar_acct ar_amt ar_applied ar_base_amt
                   ar_base_applied
                           ar_bill ar_cc ar_check ar_contested ar_cr_terms
                           ar_curr ar_date ar_dd_curr ar_dd_ex_rate
                           ar_dd_ex_rate2 ar_disc_date ar_draft ar_due_date
                           ar_dy_code ar_effdate ar_entity ar_exru_seq
                           ar_ex_rate ar_ex_rate2 ar_ex_ratetype ar_nbr ar_open
                           ar_paid_date ar_sub ar_type ar_xslspsn1)
                   where armstr1.ar_domain = global_domain and  armstr1.ar_nbr
                   = arddet_del.ard_ref
                  no-lock:
               end. /* FOR FIRST armstr1 */

               if available armstr1
                  and armstr1.ar_curr <> base_curr
               then do:

                  reset_ok = no.
                  leave.
               end. /* IF AVAILABLE armstr1 AND... */
            end. /* FOR EACH arddet_del */
            if reset_ok
            then
               assign
                  ar_mstr.ar_ex_rate2 = 1
                  ar_mstr.ar_ex_rate  = 1.
         end. /* DO FOR arddet_del */
      end. /* IF ard_det.ard_ref <> "" AND... */
   END PROCEDURE. /* delete_proc */

   /*------------------------------------------------------------------*/

   PROCEDURE backout_customer_balance:

      /* BACKOUT CUSTOMER BALANCE */
      if ard_det.ard_type <> "n"
      then do:

         if ard_det.ard_ref <> ""
         then do:

            amt_to_apply = ard_det.ard_amt + ard_det.ard_disc.
            if armstr.ar_curr <> ar_mstr.ar_curr
            then do:

               run combine_ex_rates_ar_inv_comb.

               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input ar_mstr.ar_curr,
                    input armstr.ar_curr,
                    input comb_exch_rate,
                    input comb_exch_rate2,
                    input amt_to_apply,
                    input true, /* ROUND */
                    output amt_to_apply,
                    output mc-error-number)"}

               if mc-error-number <> 0
               then do:

                  run p_pxmsg(input mc-error-number,
                              input 3).

               end. /* IF mc-error-number <> 0 */

               /* TO AVOID ROUNDING PROBLEM FOR APPLIED  */
               /* PAYMENT WHEN MEMO CURR IS SAME AS BASE */
               /* CURR AND PAYMENT IS IN FOREIGN CURR    */

               if armstr.ar_curr = base_curr
               then
                  amt_to_apply = ard_det.ard_cur_amt +
                                 ard_det.ard_cur_disc.

            end. /* IF armstr.ar_curr <> ar_mstr.ar_curr */


            /* FIX DESCRIBED IN ECO J2ML APPLIED BY L01K ON TOP OF   */
            /* THE ETK CHANGES OF ECO L00K -                         */
            /* USE ORIGINAL INVOICE EXCHANGE RATE IN PLACE OF        */
            /* THE LATEST EXCHANGE RATE APPLICABLE ON PAYMENT DATE   */
            /* AND CONVERT THE FOREIGN AMOUNT FROM amt_to_apply.     */
            /* OLD LOGIC WORKS OK EXCEPT WHEN INV AND PMT CURR       */
            /* ARE SAME BUT THERE IS RATE FLUCTUATION BETWEEN        */
            /* THE TWO.                                              */
            /* ard_det.ard_amt + ard_det.ard_disc REPLACED WITH      */
            /* amt_to_apply,                                         */
            /* ar_mstr.ar_ex_rate REPLACED WITH armstr.ar_ex_rate,   */
            /* ar_mstr.ar_ex_rate2 REPLACED WITH armstr.ar_ex_rate2. */

            /* CONVERT FROM FOREIGN TO BASE CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input ar_mstr.ar_curr,
                 input base_curr,
                 input armstr.ar_ex_rate,
                 input armstr.ar_ex_rate2,
                 input amt_to_apply,
                 input true, /* ROUND */
                 output tmpamt,
                 output mc-error-number)"}.
            if mc-error-number <> 0
            then do:

               run p_pxmsg(input mc-error-number,
                           input 3).

            end. /* IF mc-error-number <> 0 */

               cust_bal = cust_bal + tmpamt.
         end.  /* IF ard_det.ard_ref <> "" */
         else do:
            if ar_mstr.ar_curr <> base_curr
            then do:

               /* CONVERT FROM FOREIGN TO BASE CURRENCY             */

               /* PAYMENT EXCHANGE RATE SHOULD BE PASSED INSTEAD OF */
               /* INVOICE TO BASE RATE FOR UNAPPLIED PAYMENT        */

               /* MODIFIED THIRD PARAMETER FROM inv_to_base_rate TO */
               /* ar_mstr.ar_ex_rate AND FOURTH PARAMETER FROM      */
               /* inv_to_base_rate2 TO ar_mstr.ar_ex_rate2          */
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input ar_mstr.ar_curr,
                          input base_curr,
                          input ar_mstr.ar_ex_rate,
                          input ar_mstr.ar_ex_rate2,
                          input (ard_det.ard_amt + ard_det.ard_disc),
                          input true, /* ROUND */
                          output tmpamt,
                          output mc-error-number)"}.

               if mc-error-number <> 0
               then do:

                  run p_pxmsg(input mc-error-number,
                              input 3).

               end. /* IF mc-error-number <> 0 */

                  cust_bal = cust_bal + tmpamt.
            end. /* IF ar_mstr.ar_curr <> base_curr */

            else
               cust_bal = cust_bal + ard_det.ard_amt +
                                     ard_det.ard_disc.
         end. /* ELSE DO */
      end.  /* IF ard_det.ard_type <> "n" */

   END PROCEDURE. /* PROCEDURE backout_customer_balance */

   /*------------------------------------------------------------------*/

   PROCEDURE backout_memo_applied:

      /* BACK OUT MEMO APPLIED */
      if ard_det.ard_ref <> ""
      then do:

         /* TO AVOID ROUNDING DIFF WHILE BACKING OUT MEMO/INVOICE     */
         /* VALUE OF amt_to_apply IS RECOMPUTED FROM ard_curr* FIELDS */
         /* WHEN FOREIGN CURRENCY IS INVOLVED                         */
         if available ard_det and
            armstr.ar_curr <> base_curr and
            ar_mstr.ar_curr <> armstr.ar_curr
         then do:

            if ard_det.ard_cur_amt + ard_det.ard_cur_disc <> 0
            then
               amt_to_apply = ard_det.ard_cur_amt +
                              ard_det.ard_cur_disc.
         end. /* IF AVAILABLE ard_det AND... */

         assign
            armstr.ar_applied = armstr.ar_applied - amt_to_apply
            l_unrnd_amt       = amt_to_apply.

         armstr.ar_open = (armstr.ar_amt <> armstr.ar_applied).
         {&ARPAMTC-P-TAG65}
         if armstr.ar_applied = 0
         then
            armstr.ar_paid_date = ?.

         /* CHANGES MADE TO CONVERT amt_to_apply TO BASE CURRENCY */
         /* AND THEN ACCUMULATE IT TO ar_base_applied TO AVOID    */
         /* ROUNDING DIFFERENCE BETWEEN AR AND GL ENTRIES.        */

         /* CONVERT FROM FOREIGN TO BASE CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input armstr.ar_curr,
              input base_curr,
              input armstr.ar_ex_rate,
              input armstr.ar_ex_rate2,
              input l_unrnd_amt,
              input true, /* ROUND */
              output l_rnd_amt,
              output mc-error-number)"}.
         if mc-error-number <> 0
         then do:

            run p_pxmsg(input mc-error-number,
                        input 3).
         end. /* IF mc-error-number <> 0 */

         armstr.ar_base_applied = armstr.ar_base_applied - l_rnd_amt.

      end. /* IF ard_det.ard_ref <> "" */

   END PROCEDURE. /* PROCEDURE backout_memo_applied */

   /*------------------------------------------------------------------*/

   PROCEDURE update_customer_balance:
      /* UPDATE CUSTOMER BALANCE */
      if ard_det.ard_type <> "N"
      then do:

         if ard_det.ard_ref <> ""
         then do:

            /*IF PAYMENT IS TOWARDS A DRAFT,     */
            /*THEN GET THE EXCHANGE RATE FROM    */
            /*THE ITEMS WHICH THE DRAFT PAID FOR.*/

            /* FIX DESCRIBED IN ECO J2ML APPLIED BY L01K -          */
            /* USE ORIGINAL INVOICE EXCHANGE RATE IN PLACE OF       */
            /* THE LATEST EXCHANGE RATE APPLICABLE ON PAYMENT DATE. */
            /* inv_to_base_rate replaced with armstr.ar_ex_rate     */
            /* inv_to_base_rate2 replaced with armstr.ar_ex_rate2   */

            /* CONVERT FROM FOREIGN TO BASE CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input armstr.ar_curr,
                 input base_curr,
                 input armstr.ar_ex_rate,
                 input armstr.ar_ex_rate2,
                 input amt_to_apply,
                 input true, /* ROUND */
                 output tmpamt,
                 output mc-error-number)"}.
            if mc-error-number <> 0
            then do:

               run p_pxmsg(input mc-error-number,
                           input 3).
            end. /* IF mc-error-number <> 0 */

               cust_bal = cust_bal - tmpamt.

            {&ARPAMTC-P-TAG53}
         end. /* IF ard_det.ard_ref <> "" */
         else do:
            if ar_mstr.ar_curr <> base_curr
            then do:

               /* CONVERT FROM FOREIGN TO BASE CURRENCY */
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input ar_mstr.ar_curr,
                    input base_curr,
                    input ar_mstr.ar_ex_rate,
                    input ar_mstr.ar_ex_rate2,
                    input (ard_det.ard_amt + ard_det.ard_disc ),
                    input true, /* ROUND */
                    output tmpamt,
                    output mc-error-number)"}.
               if mc-error-number <> 0
               then do:

                  run p_pxmsg(input mc-error-number,
                              input 3).

               end. /* IF mc-error-number <> 0 */

                  cust_bal = cust_bal - tmpamt.
               {&ARPAMTC-P-TAG54}
            end. /* If ar_mstr.ar_curr <> base_curr */

            else
               {&ARPAMTC-P-TAG55}
               cust_bal = cust_bal -
               (ard_det.ard_amt + ard_det.ard_disc).
            {&ARPAMTC-P-TAG56}
         end. /* ELSE DO */
      end. /* IF ard_det.ard_type <> "N" */

   END PROCEDURE. /* PROCEDURE update_customer_balance */

   /*------------------------------------------------------------------*/

   PROCEDURE check_invoice_curr:

      /* CHECK IF THE INVOICE CURR IS AN EMU CURRENCY */
      /* AND BASE CURRENCY IS ALSO AN EMU CURRENCY    */
      union_curr_code = "".
      {gprunp.i "mcpl" "p" "mc-chk-member-curr"
         "(input armstr.ar_curr,
           input ar_effdate,
           output union_curr_code,
           output is_emu_curr)" }
      if not is_emu_curr
      then do:

         {gprunp.i "mcpl" "p" "mc-chk-union-curr"
            "(input armstr.ar_curr,
              input ar_effdate,
              output is_emu_curr)" }
      end. /* IF NOT is_emu_curr */
      if base_curr <> union_curr_code
         and is_emu_curr
      then do:

         {gprunp.i "mcpl" "p" "mc-chk-member-curr"
            "(input base_curr,
              input ar_effdate,
              output union_curr_code,
              output is_emu_curr)" }
         if not is_emu_curr
         then do:

            {gprunp.i "mcpl" "p" "mc-chk-union-curr"
               "(input base_curr,
                 input ar_effdate,
                 output is_emu_curr)" }
         end. /* IF NOT is_emu_curr */
      end. /* IF base_curr <> union_curr_code AND... */

   END PROCEDURE. /* PROCEDURE check_invoice_curr */

   /*------------------------------------------------------------------*/

   {gpacctet.i}   /* DEFINES procedure is_euro_transparent */

   /*------------------------------------------------------------------*/

   {&ARPAMTC-P-TAG35}
   PROCEDURE proc_amt_disc_to_pay:

      /* COMBINE EXCHANGE RATES BEFORE CONVERTING */
      {gprunp.i "mcpl" "p" "mc-combine-ex-rates"
         "(input inv_to_base_rate,
           input inv_to_base_rate2,
           input ar_mstr.ar_ex_rate2,
           input ar_mstr.ar_ex_rate,
           output comb_exch_rate,
           output comb_exch_rate2)"}

      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input armstr.ar_curr,
           input ar_mstr.ar_curr,
           input comb_exch_rate,
           input comb_exch_rate2,
           input amt_disc,
           input false,  /* DO NOT ROUND */
           output amt_disc,
           output mc-error-number)"}

      /* PRESERVE UNROUNDED VALUE */
      ard_disc_unrounded = amt_disc.

      /* USE PAYMENT ROUNDING METHOD, NOT      */
      /* ROUNDING METHOD OF APPLY-TO MEMO/INV. */
      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output amt_disc,
           input paymnt_rndmthd,
           output mc-error-number)"}

   END PROCEDURE. /* proc_amt_disc_to_pay */

   /*------------------------------------------------------------------*/

   PROCEDURE proc_ard_amt_to_pay:

      /* COMBINE EXCHANGE RATES BEFORE CONVERTING */
      {gprunp.i "mcpl" "p" "mc-combine-ex-rates"
         "(input inv_to_base_rate,
           input inv_to_base_rate2,
           input ar_mstr.ar_ex_rate2,
           input ar_mstr.ar_ex_rate,
           output comb_exch_rate,
           output comb_exch_rate2)"}

      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input armstr.ar_curr,
           input ar_mstr.ar_curr,
           input comb_exch_rate,
           input comb_exch_rate2,
           input ardamt,
           input false,  /* DO NOT ROUND */
           output ardamt,
           output mc-error-number)"}

      /* PRESERVE UNROUNDED VALUE */
      ardamt_unrounded = ardamt.

      /* USE PAYMENT ROUNDING METHOD, NOT      */
      /* ROUNDING METHOD OF APPLY-TO MEMO/INV. */
      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output ardamt,
           input paymnt_rndmthd,
           output mc-error-number)"}

   END PROCEDURE. /* proc_ard_amt_to_pay */

   /*------------------------------------------------------------------*/

   PROCEDURE proc_ard_amt_to_memo:

      /* COMBINE EXCHANGE RATES BEFORE CONVERTING */

      run combine_ex_rates_ar_inv_comb.

      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input ar_mstr.ar_curr,
           input armstr.ar_curr,
           input comb_exch_rate,
           input comb_exch_rate2,
           input ardamt,
           input false,  /* DO NOT ROUND */
           output ardamt,
           output mc-error-number)"}

      ardamt_unrounded = ardamt.
      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output ardamt,
           input apply2_rndmthd,
           output mc-error-number)"}

   END PROCEDURE. /* proc_ard_amt_to_memo */

   /*------------------------------------------------------------------*/

   PROCEDURE proc_curr_disc_to_memo:

      run combine_ex_rates_ar_inv_comb.

      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input ar_mstr.ar_curr,
           input (if avail armstr then armstr.ar_curr
                  else base_curr),
           input comb_exch_rate,
           input comb_exch_rate2,
           input ard_det.ard_disc,
           input true, /* ROUND */
           output curr_disc,
           output mc-error-number)"}

   END PROCEDURE. /* proc_curr_disc_to_memo */

   /*------------------------------------------------------------------*/

   PROCEDURE proc_tmpamt_to_pay:

      /* CONVERT FROM INVOICE/MEMO CURR TO PAYMENT CURR */
      {gprunp.i "mcpl" "p" "mc-combine-ex-rates"
         "(input ar_mstr.ar_ex_rate2,
           input ar_mstr.ar_ex_rate,
           input armstr1.ar_ex_rate,
           input armstr1.ar_ex_rate2,
           output comb_exch_rate,
           output comb_exch_rate2)"}

      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input armstr1.ar_curr,
           input ar_mstr.ar_curr,
           input comb_exch_rate,
           input comb_exch_rate2,
           input tmpamt,
           input true, /* ROUND */
           output tmpamt,
           output mc-error-number)"}

      if mc-error-number <> 0
      then do:

         run p_pxmsg(input mc-error-number,
                     input 4).

      end. /* IF mc-error-number <> 0 */

   END PROCEDURE. /* proc_tmpamt_to_pay */

   /*------------------------------------------------------------------*/

   PROCEDURE p-chk-mc-error-3:
      if mc-error-number <> 0
      then do:

         run p_pxmsg(input mc-error-number,
                     input 3).

      end. /* If mc-error-number <> 0 */
   END PROCEDURE. /* PROCEDURE p-chk-mc-error-3 */

    PROCEDURE p-calculate-tax:

       define variable det_ex_rate         like glt_ex_rate.
       define variable det_ex_rate2        like glt_ex_rate2.
       define variable det_ex_ratetype     like glt_ex_ratetype.
       define variable aramount            like ar_amt.
       define variable l_tax_date          like tx2_effdate no-undo.

         /* SET DISCOUNT AMOUNT  */

         aramount = armstr.ar_amt.

         /* EXCLUDE TAX AMOUNTS WHERE DISCOUNT TAX AT PAYMENT IS NO */
         for each tx2d_det
            fields( tx2d_domain tx2d_ref tx2d_tr_type tx2d_tax_code
                   tx2d_cur_tax_amt)
             where tx2d_det.tx2d_domain = global_domain and  tx2d_ref     =
             ard_det.ard_ref
            and   tx2d_tr_type = inv_type
            no-lock:

            if can-find(tx2_mstr  where tx2_mstr.tx2_domain = global_domain
            and
               tx2_tax_code = tx2d_tax_code and not tx2_pmt_disc)
            then
               aramount = aramount - tx2d_cur_tax_amt.
         end. /* FOR EACH tx2d_det */

         /* GET THE TRANSACTION EXCHANGE RATE */
         assign
            l_tax_date      = ar_mstr.ar_effdate
            det_ex_rate     = ar_mstr.ar_ex_rate
            det_ex_rate2    = ar_mstr.ar_ex_rate2
            det_ex_ratetype = ar_mstr.ar_ex_ratetype.

         /* CALCULATE TAX AMOUNT USING INVOICE/MEMO EXCHANGE RATE */
         /* WHEN DISCOUNT TAX AT PAYMENT IS SET TO YES            */

         /* CALCULATE TAX AMOUNT FOR EURO USING INVOICE/MEMO EXCHANGE */
         /* RATE WHEN DISCOUNT TAX AT PAYMENT IS SET TO YES           */

         if armstr.ar_curr  <> base_curr
           or is_transparent
         then do:

            for first tx2d_det
               fields( tx2d_domain tx2d_ref tx2d_tr_type tx2d_tax_code)
                where tx2d_det.tx2d_domain = global_domain and  tx2d_ref =
                ard_det.ard_ref and
               tx2d_tr_type   = inv_type
               no-lock:
            end. /* FOR FIRST tx2d_det */

            if available tx2d_det
            then do:

               for first tx2_mstr
                  {&ARPAMTC-P-TAG42}
                  fields(tx2_tax_code tx2_pmt_disc)
                  {&ARPAMTC-P-TAG43}
                   where tx2_mstr.tx2_domain = global_domain and  tx2_tax_code
                   = tx2d_tax_code
                  no-lock:
               end. /* FOR FIRST tx2_mstr */

               if available tx2_mstr and tx2_pmt_disc
               then
                  assign
                     l_tax_date      = armstr.ar_effdate
                     det_ex_rate     = armstr.ar_ex_rate
                     det_ex_rate2    = armstr.ar_ex_rate2
                     det_ex_ratetype = armstr.ar_ex_ratetype.

               release tx2_mstr.
               release tx2d_det.
            end. /* IF AVAILABLE tx2d_det */
         end.    /* IF armstr.ar_curr  <> base_curr ... */

         /* CALCULATE TAX ADJUSTMENT & CREATE DETAIL */
         {gprun.i ""txcalc19.p""
            "(
             input  tax_tr_type,
             input  ard_det.ard_nbr,
             input  ard_det.ard_ref,
             input  0,
             input  inv_type,
             input  ar_mstr.ar_effdate,
             input  det_ex_rate,
             input  det_ex_rate2,
             input  det_ex_ratetype,
             input  if available armstr and
                       armstr.ar_curr = ar_mstr.ar_curr
                    then
                       ard_det.ard_disc / aramount
                    else ard_det.ard_cur_disc / aramount,
             input  l_tax_date
                          )" }


   END PROCEDURE. /* PROCEDURE p-calculate-tax */

   PROCEDURE combine_ex_rates_ar_inv_comb:
      {gprunp.i "mcpl" "p" "mc-combine-ex-rates"
         "(input ar_mstr.ar_ex_rate,
           input ar_mstr.ar_ex_rate2,
           input inv_to_base_rate2,
           input inv_to_base_rate,
           output comb_exch_rate,
           output comb_exch_rate2)"}
   END PROCEDURE. /* PROCEDURE combine_ex_rates_ar_inv_comb */

   PROCEDURE combine_ex_rates_ar_inv_arm_comb:
      define variable temp_exch_rate      like ar_ex_rate no-undo.
      define variable temp_exch_rate2     like ar_ex_rate2 no-undo.

      {gprunp.i "mcpl" "p" "mc-combine-ex-rates"
         "(input ar_mstr.ar_ex_rate,
           input ar_mstr.ar_ex_rate2,
           input inv_to_base_rate2,
           input inv_to_base_rate,
           output temp_exch_rate,
           output temp_exch_rate2)"}

      {gprunp.i "mcpl" "p" "mc-combine-ex-rates"
         "(input temp_exch_rate,
           input temp_exch_rate2,
           input armstr.ar_ex_rate,
           input armstr.ar_ex_rate2,
           output comb_exch_rate,
           output comb_exch_rate2)"}
   END PROCEDURE. /* PROCEDURE combine_ex_rates_ar_inv_arm_comb */

   PROCEDURE p_action:

      define input parameter l_err_nbr as integer   no-undo.
      define input parameter l_err_var as decimal   no-undo.

      {mfmsg03.i l_err_nbr 3 "l_err_var" """" """"}

   END PROCEDURE. /* PROCEDURE p_action */

   PROCEDURE combine_ex_rates_curr_conv_comb:

      /* COMBINE EXCHANGE RATES BEFORE CONVERTING */
      {gprunp.i "mcpl" "p" "mc-combine-ex-rates"
         "(input inv_to_base_rate,
           input inv_to_base_rate2,
           input ar_mstr.ar_ex_rate2,
           input ar_mstr.ar_ex_rate,
           output comb_exch_rate,
           output comb_exch_rate2)"}

      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input armstr.ar_curr,
           input ar_mstr.ar_curr,
           input comb_exch_rate,
           input comb_exch_rate2,
           input ardamt_unrounded,
           input true,  /* ROUND */
           output ardamt,
           output mc-error-number)"}
   END PROCEDURE. /* PROCEDURE combine_ex_rates_curr_conv_comb */


   PROCEDURE ip-cal-base-amt:

      define output parameter l3_ar_base_amt like ar_base_amt no-undo.

      /* CONVERT FROM FOREIGN TO BASE CURRENCY */
      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input ar_mstr.ar_curr,
           input base_curr,
           input ar_mstr.ar_ex_rate,
           input ar_mstr.ar_ex_rate2,
           input ard_det.ard_amt,
           input true, /* ROUND */
           output l3_ar_base_amt,
           output mc-error-number)"}.

      if mc-error-number <> 0
      then do:

         run p_pxmsg(input mc-error-number,
                     input 3).

      end. /* IF mc-error-number <> 0 */

   END PROCEDURE. /* PROCEDURE ip-cal-base-amt */

   PROCEDURE ip-curr-amt-disc :

      if armstr.ar_curr <> ar_mstr.ar_curr
      then do:

         if not new ard_det
         then
            assign
               curr_amt  = ard_det.ard_cur_amt
               curr_disc = ard_det.ard_cur_disc.
         else
            assign
               curr_disc            = amt_disc
               curr_amt             = amt_open     + vat_ndisc
                                    + l_trl_ndisc - curr_disc
               ard_det.ard_cur_amt  = curr_amt
               ard_det.ard_cur_disc = curr_disc.

         amt_to_apply = curr_amt + curr_disc.

         if new ard_det
         then do:

            /* INVOICE TO BASE TO PAYMENT CURRENCY */

            run proc_amt_disc_to_pay in this-procedure.
            run p-chk-mc-error-3 in this-procedure.

            run proc_ard_amt_to_pay in this-procedure.
            run p-chk-mc-error-3 in this-procedure.

         end. /* IF NEW ard_det */
         else
            assign
               amt_disc           = ard_det.ard_disc
               ard_disc_unrounded = amt_disc
               ardamt             = ard_det.ard_disc + ard_det.ard_amt
               ardamt_unrounded   = ardamt.

       end. /* IF armstr.ar_curr <> ar_mstr.ar_curr */

    END PROCEDURE. /* PROCEDURE ip-curr-amt-disc */

    PROCEDURE ip_get_trlamt:
       l_trl_ndisc = 0.

       if inv_type = "16"
       then do:

          for first ih_hist
              fields( ih_domain ih_inv_nbr ih_trl1_cd ih_trl2_cd ih_trl3_cd
                     ih_trl1_amt ih_trl2_amt ih_trl3_amt)
               where ih_hist.ih_domain = global_domain and  ih_inv_nbr =
               ard_det.ard_ref
              no-lock:
          end. /* FOR FIRST ih_hist */

          if available ih_hist
             and (ih_trl1_cd    <> ""
               or ih_trl2_cd <> ""
               or ih_trl3_cd <> "")
          then do:

             if can-find(first trl_mstr
                 where trl_mstr.trl_domain = global_domain and  trl_code    =
                 ih_trl1_cd
                  and trl__qadc01 = "no")
             then
                l_trl_ndisc = l_trl_ndisc + ih_trl1_amt.

             if can-find(first trl_mstr
                 where trl_mstr.trl_domain = global_domain and  trl_code    =
                 ih_trl2_cd
                  and trl__qadc01 = "no")
             then
                l_trl_ndisc = l_trl_ndisc + ih_trl2_amt.

             if can-find(first trl_mstr
                 where trl_mstr.trl_domain = global_domain and  trl_code    =
                 ih_trl3_cd
                  and trl__qadc01 = "no")
             then
                l_trl_ndisc = l_trl_ndisc + ih_trl3_amt.

          end.   /* IF AVAILABLE ih_hist AND...*/
       end.   /* IF inv_type = "16" */

    END PROCEDURE. /* ip_get_trlamt */

PROCEDURE get-qad-wkfl:
   define input parameter p-arnbr like ar_mstr.ar_nbr.

   {argetwfl.i
      p-arnbr
      inv_to_base_rate
      inv_to_base_rate2}

END PROCEDURE. /* PROCEDURE get_qad_wkfl */

PROCEDURE convert_fgn_to_base:

   /* CHANGES MADE TO CONVERT ard_amt OR (ard_amt + ard_disc) */
   /* TO BASE CURRENCY AND THEN ACCUMULATE IT TO ar_base_amt  */
   /* TO AVOID ROUNDING DIFFERENCE BETWEEN AR AND GL ENTRIES. */

   {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input ar_mstr.ar_curr,
              input base_curr,
              input ar_mstr.ar_ex_rate,
              input ar_mstr.ar_ex_rate2,
              input l_unrnd_amt,
              input true, /* ROUND */
              output l_rnd_amt,
              output mc-error-number)"}.

END PROCEDURE. /* convert_fgn_to_base */

PROCEDURE p-get-term-ard-tax-at:

   define input  parameter p_ard_tax_at like ard_tax_at no-undo.
   define output parameter l_ard_tax_at like ard_tax_at no-undo.

   if p_ard_tax_at = "YES"
   then
      l_ard_tax_at = getTermLabel("YES",6).
   else
   if p_ard_tax_at = "NO"
   then
      l_ard_tax_at = getTermLabel("NO",4).
   else
      l_ard_tax_at = p_ard_tax_at.

END PROCEDURE. /* PROCEDURE p-get-term-ard-tax-at */

PROCEDURE p_pxmsg :

   define input parameter l_msgnum   like msg_nbr no-undo.
   define input parameter l_errlevel as   integer no-undo.

   {pxmsg.i &MSGNUM=l_msgnum &ERRORLEVEL=l_errlevel}

END PROCEDURE.  /* PROCEDURE p_pxmsg */

PROCEDURE p_calc_disc:
   define input-output parameter l_disc_amt like ar_amt no-undo.
   define input        parameter l_open_amt like ar_amt no-undo.

   {ardiscal.i l_disc_amt l_open_amt}
END PROCEDURE . /* p_calc_disc */
