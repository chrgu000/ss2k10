/* apmcmta.p - AP MANUAL CHECK MAINTENANCE DETAIL                             */
/* Copyright 1986-2007 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* REVISION: 4.0      LAST MODIFIED: 12/23/88   BY: flm *C0028*               */
/* REVISION: 6.0      LAST MODIFIED: 04/23/91   BY: mlv *D567*                */
/*                                   04/24/91   BY: mlv *D595*                */
/*                                   05/31/91   BY: mlv *D667*                */
/*                                   06/06/91   BY: mlv *D674*                */
/*                                   07/08/91   BY: mlv *D753*                */
/*                                   08/02/91   BY: mlv *D809*                */
/* REVISION: 7.0      LAST MODIFIED: 08/23/91   BY: mlv *F002*                */
/*                                   09/17/91   BY: mlv *F015*                */
/*                                   10/28/91   BY: mlv *F028*                */
/*                                   12/16/91   BY: mlv *F074*                */
/*                                   02/21/92   BY: mlv *F224*                */
/*                                   05/18/92   BY: mlv *F508*                */
/*                                   07/06/92   BY: mlv *F725*                */
/* REVISION: 7.3      LAST MODIFIED: 07/24/92   BY: mpp *G004*                */
/*                                   08/14/92   BY: mlv *G029*                */
/*                                   09/04/92   BY: mlv *G042*                */
/*                                   12/18/92   BY: mpp *G475*                */
/*                                   04/17/93   BY: bcm *G969*                */
/* REVISION: 7.4      LAST MODIFIED: 09/16/93   BY: pcd *H117*                */
/*                                   09/21/93   BY: bcm *H110*                */
/*                                   10/28/93   BY: wep *H203*                */
/*                                   02/07/94   BY: wep *FM12*                */
/*                                   03/04/94   by: pmf *FM73*                */
/*                                   03/21/94   by: wep *FM91*                */
/*                                   03/30/94   by: wep *FL75*                */
/*                                   07/11/94   by: pmf *FP34*                */
/*                                   08/30/94   by: pmf *FQ59*                */
/* REVISION: 7.4      LAST MODIFIED: 09/12/94   by: slm *GM17*                */
/* REVISION: 7.4      LAST MODIFIED: 09/15/94   by: ljm *GM57*                */
/*                                   09/26/94   by: bcm *H509*                */
/*                                   10/17/94   by: ljm *GN36*                */
/*                                   11/06/94   by: ame *GO17*                */
/*                                   05/30/95   by: jzw *F0SJ*                */
/*                                   06/21/95   by: jzw *F0SV*                */
/*                                   11/20/95   by: jzw *H0H8*                */
/* REVISION: 8.5      LAST MODIFIED: 11/01/95   by: mwd *J053*                */
/* REVISION: 8.6      LAST MODIFIED: 11/25/96   by: jzw *K01X*                */
/* REVISION: 8.6      LAST MODIFIED: 12/20/96   by: rxm *J1C5*                */
/* REVISION: 8.6      LAST MODIFIED: 01/23/97   by: bjl *K01G*                */
/* REVISION: 8.6      LAST MODIFIED: 07/16/97   by: *J1VZ* Samir Bavkar       */
/* REVISION: 8.6      LAST MODIFIED: 10/14/97   by: *K0XM* Jean Miller        */
/* REVISION: 8.6      LAST MODIFIED: 11/03/97   BY: *J24H* Irine D'mello      */
/* REVISION: 8.6      LAST MODIFIED: 11/17/97   BY: *G2Q5* Samir Bavkar       */
/* REVISION: 8.6      LAST MODIFIED: 01/16/98   BY: *J2B7* Jim Josey          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/11/98   BY: *J2LC* Samir Bavkar       */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton       */
/* Pre-86E commented code removed, view in archive revision 1.21              */
/* REVISION: 8.6E     LAST MODIFIED: 07/23/98   BY: *L03K* Jeff Wootton       */
/* REVISION: 8.6E     LAST MODIFIED: 08/19/98   BY: *J2R5* Dana Tunstall      */
/* REVISION: 8.6E     LAST MODIFIED: 08/20/98   BY: *L06N* Dana Tunstall      */
/* REVISION: 8.6E     LAST MODIFIED: 09/10/98   BY: *L092* Steve Goeke        */
/* REVISION: 8.6E     LAST MODIFIED: 02/15/99   BY: *L0D7* Prashanth Narayan  */
/* REVISION: 9.0      LAST MODIFIED: 03/04/99   BY: *M09L* Jean Miller        */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 04/08/99   BY: *L0DT* Jose Alex          */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Paul Johnson       */
/* REVISION: 9.1      LAST MODIFIED: 09/24/99   BY: *L0JC* Hemali Desai       */
/* REVISION: 9.1      LAST MODIFIED: 11/27/99   BY: *J3MH* Atul Dhatrak       */
/* REVISION: 9.1      LAST MODIFIED: 01/11/00   BY: *J3MY* Atul Dhatrak       */
/* REVISION: 9.1      LAST MODIFIED: 01/19/00   BY: *N077* Vijaya Pakala      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 07/03/00   BY: *L10X* Shilpa Athalye     */
/* REVISION: 9.1      LAST MODIFIED: 07/06/00   BY: *L110* Shilpa Athalye     */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                */
/* REVISION: 9.1      LAST MODIFIED: 12/28/00   BY: *M0YR* Veena Lad          */
/* REVISION: 9.1      LAST MODIFIED: 10/23/00   BY: *N0W0* Mudit Mehta        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.46        BY: Katie Hilbert       DATE: 04/01/01  ECO: *P002*  */
/* Revision: 1.47        BY: Vihang Talwalkar    DATE: 05/02/01  ECO: *M168*  */
/* Revision: 1.48        BY: Seema Tyagi         DATE: 05/23/01  ECO: *M187*  */
/* Revision: 1.49        BY: Ed van de Gevel     DATE: 11/09/01  ECO: *N15N*  */
/* Revision: 1.50        BY: Ed van de Gevel     DATE: 12/03/01  ECO: *N16R*  */
/* Revision: 1.51        BY: Falguni Dalal       DATE: 01/24/02  ECO: *N18C*  */
/* Revision: 1.52        BY: Rajesh Kini         DATE: 01/30/02  ECO: *M1TZ*  */
/* Revision: 1.54        BY: Jean Miller         DATE: 04/03/02  ECO: *P053*  */
/* Revision: 1.54        BY: Ed van de Gevel     DATE: 04/17/02  ECO: *N1GR*  */
/* Revision: 1.55        BY: Paul Donnelly       DATE: 01/27/02  ECO: *N16J*  */
/* Revision: 1.56        BY: Paul Donnelly       DATE: 05/01/02  ECO: *N1HQ*  */
/* Revision: 1.58        BY: Vinod Nair          DATE: 07/09/02  ECO: *N1LY*  */
/* Revision: 1.59        BY: Ed van de Gevel     DATE: 08/21/02  ECO: *P0G2*  */
/* Revision: 1.60        BY: Ed van de Gevel     DATE: 09/05/02  ECO: *P0HQ*  */
/* Revision: 1.62        BY: Subramanian Iyer    DATE: 12/23/02  ECO: *N22F*  */
/* Revision: 1.63        BY: Orawan S.           DATE: 05/02/03  ECO: *P0R0*  */
/* Revision: 1.65        BY: Paul Donnelly (SB)  DATE: 06/26/03  ECO: *Q00B*  */
/* Revision: 1.66        BY: Orawan S.           DATE: 08/28/03  ECO: *P0YG*  */
/* Revision: 1.68        BY: Jean Miller         DATE: 09/22/03  ECO: *Q03S*  */
/* Revision: 1.70        BY: Shilpa Athalye      DATE: 11/04/03  ECO: *N2M6*  */
/* Revision: 1.71        BY: Ed van de Gevel     DATE: 12/08/03  ECO: *N2HH*  */
/* Revision: 1.72  BY: Vandna Rohira       DATE: 01/21/04  ECO: *P1KH*  */
/* Revision: 1.73  BY: Subramanian Iyer DATE: 02/19/04  ECO: *P1PJ*  */
/* Revision: 1.74  BY: Ed van de Gevel DATE: 05/17/04 ECO: *Q07S* */
/* Revision: 1.75  BY: Ed van de Gevel DATE: 05/19/04 ECO: *Q07V* */
/* Revision: 1.76  BY: Ed van de Gevel DATE: 06/22/04 ECO: *P272* */
/* Revision: 1.77  BY: Reena Ambavi DATE: 08/24/04 ECO: *P25B* */
/* Revision: 1.78  BY: Orawan S.    DATE: 12/21/04 ECO: *P2ZF* */
/* Revision: 1.78.1.1  BY: Ed van de Gevel    DATE: 08/03/05 ECO: *P3WM* */
/* Revision: 1.78.1.2 BY: Ed van de Gevel  DATE: 01/17/06  ECO: *Q0PS* */
/* Revision: 1.78.1.3    BY: Sarita Gonsalves  DATE: 06/27/06  ECO: *Q0VW* */
/* Revision: 1.78.1.4    BY: Ed van de Gevel DATE: 10/27/06 ECO: *P5C9* */
/* $Revision: 1.78.1.5 $ BY: Ed van de Gevel DATE: 01/24/07 ECO: *P5MD* */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110114.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/


/*V8:ConvertMode=Maintenance                                                 */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}

{cxcustom.i "APMCMTA.P"}

/* EXTERNAL LABEL INCLUDE */
{gplabel.i}
{pxpgmmgr.i}

{gldydef.i}
{gldynrm.i}

{xxgpdescm1.i }     /* SS - 110114.1 */


define new shared variable trtype       as   character     initial "man".
define new shared variable undo_all     like mfc_logical.
define new shared variable bank         like bk_code.
define new shared variable curr_amt     like glt_curr_amt.
define new shared variable curr_disc    like glt_curr_amt.
define new shared variable base_det_amt like glt_amt.

define shared variable ref           as   character format "X(14)".
define shared variable aprecid       as   recid.
define shared variable bkrecid       as   recid.
define shared variable ckrecid       as   recid.
define shared variable ckdrecid      as   recid.
define shared variable apbuffrecid   as   recid.
define shared variable vorecid       as   recid.
define shared variable apref         like ap_ref.
define shared variable jrnl          like glt_ref.
define shared variable batch_ctrl    like ap_amt    label "Batch Control".
define shared variable batch         like ap_batch  label "Batch".
define shared variable batch_total   like ap_amt    label "Total".
define shared variable aptotal       like ap_amt    label "Check Control"
{&APMCMTA-P-TAG1}
   format ">>>>>,>>>,>>9.99".
{&APMCMTA-P-TAG2}
define shared variable amt_open      like ap_amt       label "Balance".
define shared variable amt_disc      like ap_amt       label "Disc Bal".
define shared variable apply_amt     like ap_amt       label "Amt to Apply".
define shared variable apply_disc    like ap_amt       label "Amt to Disc".
define shared variable ckdamt        like ap_amt       label "Amt to Apply".
define shared variable disc_ok       like ap_amt.
define shared variable base_amt      like ap_amt.
define shared variable base_disc     like ap_amt.
define shared variable gain_amt      like ap_amt.
define shared variable check_amt     like ckd_amt.
define shared variable old_effdate   like ap_effdate.
define shared variable gen_desc      like glt_desc.
define shared variable ap_due_date   like ap_date      label "Due Date".
define shared variable for_curr_amt  like ckd_cur_amt.
define shared variable tot-vtadj     as   decimal.
define shared variable rndmthd       like rnd_rnd_mthd.
define shared variable old_curr      like ap_curr.
define shared variable ap_amt_fmt    as   character no-undo.
define shared variable ap_amt_old    as   character no-undo.

define variable sav-mthd         like rnd_rnd_mthd.
define variable aprndmthd        like rnd_rnd_mthd.
define variable exch_var         as   decimal.
define variable vat_ndisc        as   decimal.
define variable done             as   logical      initial false.
define variable reset_ok         like mfc_logical.
{&APMCMTA-P-TAG3}
define variable amt_to_apply     like ap_amt       label "Amt to Apply".
{&APMCMTA-P-TAG4}
define variable pmt_ex_rate      like ap_ex_rate.
define variable pmt_ex_rate2     like ap_ex_rate2.
define variable first_foreign    like mfc_logical.
define variable old_amt_to_apply like amt_to_apply.
define variable old_amt          like ckd_amt.
define variable old_disc         like ckd_disc.
define variable del-yn           like mfc_logical  initial no.
define variable glvalid          like mfc_logical.
define variable tax_tr_type      like tx2d_tr_type initial "29".
define variable old_tr_type      like tx2d_tr_type initial "22".
define variable tax_ref          like tx2d_ref.
define variable tax_nbr          like tx2d_nbr.
define variable det_ex_rate      like glt_ex_rate.
define variable det_ex_rate2     like glt_ex_rate2.
define variable det_ex_ratetype  like ap_ex_ratetype.
define variable draft_yn         like mfc_logical.
define variable due-date         like vo_due_date.
define variable disc-date        like vo_disc_date.
define variable amt-due          like ap_amt.
define variable amt-disc         like ap_amt.
define variable tot-amt-disc     like ap_amt.
define variable disc_pct         like ct_disc_pct.
define variable rndamt           like ap_amt.
define variable ckd_amt_fmt      as character            no-undo.
define variable ckd_amt_old      as character            no-undo.
define variable ckd_disc_fmt     as character            no-undo.
define variable ckd_disc_old     as character            no-undo.
define variable amt_apply_fmt    as character            no-undo.
define variable amt_apply_old    as character            no-undo.
define variable retval           as integer.
define variable l_disc           like ckd_disc           no-undo.
define variable l_pmt_disc       like tx2_pmt_disc       no-undo.
define variable l_rcpt_tax_point like tx2_rcpt_tax_point no-undo.
define variable l_tax_date       like tx2_effdate         no-undo.
define variable mc-error-number  like msg_nbr             no-undo.
define variable base_amount_1    like ap_amt              no-undo.
define variable base_amount_2    like ap_amt              no-undo.
define variable l_is_emu_curr    like mfc_logical         no-undo.

/* DEFINED TEMP TABLE FOR GETTING THE RECORDS ADDED IN apmcmta.p */
/* WITH INDEX SAME AS PRIMARY UNIQUE INDEX OF ckd_det.           */
{apdydef.i &type="shared"}

define new shared buffer apmstr for ap_mstr.

{&APMCMTA-P-TAG59}
define buffer apmstr1 for ap_mstr.
define buffer ckddet  for ckd_det.

define shared frame b.
{&APMCMTA-P-TAG5}

form
   apmstr.ap_curr no-label
   amt_to_apply
with frame seta_sub attr-space overlay side-labels
   row frame-row(b) + 5 column frame-col(b) + 35.
{&APMCMTA-P-TAG6}

/* SET EXTERNAL LABELS */
setFrameLabels(frame seta_sub:handle).

form
   ckd_voucher    colon 10
   ckdamt         colon 50
   ckd_type       colon 10
   ckd_amt        colon 50 label "Cash Amount"
   ckd_acct       colon 10
   ckd_sub                 no-label
   ckd_cc                  no-label
   ckd_disc       colon 50
with frame d side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

/* PERFORM INITIAL READS */

{&APMCMTA-P-TAG60}
find ap_mstr
   where recid(ap_mstr) = aprecid.

{&APMCMTA-P-TAG61}
for first bk_mstr
   fields(bk_domain bk_entity)
   where recid(bk_mstr) = bkrecid
   no-lock:
end. /* FOR FIRST ap_mstr */

find ck_mstr
   where recid(ck_mstr) = ckrecid.

for first apc_ctrl
   fields(apc_domain apc_ex_tol apc_multi_entity_pay)
    where apc_ctrl.apc_domain = global_domain no-lock:
end. /* FOR FIRST apc_ctrl */

for first gl_ctrl
   fields(gl_domain gl_verify)
    where gl_ctrl.gl_domain = global_domain no-lock:
end. /* FOR FIRST gl_ctrl */

{&APMCMTA-P-TAG62}
/* DEFINE  SELECTION FORM */
{apmcfmb.i}

display
   ck_nbr
with frame b.

assign
   ckd_amt_old   = ckd_amt:format      in frame d
   ckd_disc_old  = ckd_disc:format     in frame d
   amt_apply_fmt = amt_to_apply:format in frame seta_sub.

amtloop:

{&APMCMTA-P-TAG63}
repeat while not done:

   {&APMCMTA-P-TAG64}
   loope:
   repeat with frame d:

      {&APMCMTA-P-TAG65}
      clear frame d.
      {&APMCMTA-P-TAG86}

      assign
         ckd_disc_fmt     = ckd_disc_old
         ckd_amt_fmt      = ckd_amt_old.
      {&APMCMTA-P-TAG7}

      /* NOTE: RNDMTHD HAS ALREADY BEEN SET FOR THE CHECK CURRENCY, */
      /*       IN THE CALLING PROGRAM APMCMT.P                      */
      {gprun.i ""gpcurfmt.p""
         "(input-output ckd_amt_fmt,
           input rndmthd)"}
      {gprun.i ""gpcurfmt.p""
         "(input-output ckd_disc_fmt,
           input rndmthd)"}

      /* NOTE: THE VALUE OF AP_AMT_FMT WAS SET IN CALLING PROGRAM */

      ap_mstr.ap_amt:format in frame b = ap_amt_fmt.

      {&APMCMTA-P-TAG66}
      display
         ap_mstr.ap_amt
      with frame b.

      {&APMCMTA-P-TAG67}
      {&APMCMTA-P-TAG8}
      prompt-for ckd_voucher with frame d
         editing:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp01.i ckd_det ckd_voucher ckd_voucher ckd_ref
            " ckd_det.ckd_domain = global_domain and ck_ref "  ckd_ref}
         if recno <> ?
         then do:
            assign
               ckd_amt:format  in frame d = ckd_amt_fmt
               ckd_disc:format in frame d = ckd_disc_fmt.

            display
               ckd_voucher
               ckd_type
               ckd_acct
               ckd_sub
               ckd_cc
               ckd_amt
               {&APMCMTA-P-TAG68}
               ckd_disc
            with frame d.

            {&APMCMTA-P-TAG69}
            {&APMCMTA-P-TAG9}
         end. /* IF recno <> ? */
      end. /* PROMPT-FOR ckd_voucher WITH FRAME d */

      {&APMCMTA-P-TAG10}
      /* ADD/MOD/DELETE */
      find first ckd_det where ckd_det.ckd_domain = global_domain
                           and ckd_det.ckd_voucher = input ckd_voucher
                           and ckd_det.ckd_ref     = ap_mstr.ap_ref
      exclusive-lock no-error.

      {&APMCMTA-P-TAG97}
      setacct:
      do on error undo, retry:

         if input ckd_voucher = ""
         then do:

            display
               "N" @ ckd_type.

            {&APMCMTA-P-TAG11}
            {&APMCMTA-P-TAG89}
            prompt-for
               ckd_acct
               ckd_sub
               ckd_cc.

            /* INITIALIZE SETTINGS */
            {gprunp.i "gpglvpl" "p" "initialize"}

            /* SET PROJECT VERIFICATION TO NO */
            {gprunp.i "gpglvpl" "p" "set_proj_ver" "(input false)"}

            /* ACCT/SUB/CC/PROJ VALIDATION */
            {gprunp.i "gpglvpl" "p" "validate_fullcode"
               "(input input ckd_acct,
                 input input ckd_sub,
                 input input ckd_cc,
                 input """",
                 output glvalid)"}

            if glvalid = no
            then do:
               next-prompt ckd_acct with frame d.
               undo setacct, retry.
            end. /* IF glvalid = no */

            if input ckd_acct = ""
               and not gl_verify
            then do:
               /* INVALID ACCOUNT CODE */
               run p_pxmsg(input 3052,
                           input 2).

               if not batchrun
               then
                  pause.
            end. /* IF INPUT ckd_acct = "" AND ... */

            /* CHECK THAT ckd_acct IS IN BASE CURR OR BANK CURR */
            for first ac_mstr
               fields(ac_domain ac_active ac_code ac_curr ac_type)
               where ac_domain = global_domain
                 and ac_code = input ckd_acct
            no-lock: end.
            {&APMCMTA-P-TAG52}
            if available ac_mstr
               and ac_curr <> ap_curr
               and ap_curr <> base_curr
               and ac_curr <> base_curr
            then do:
               {&APMCMTA-P-TAG53}
               /* ACCOUNT CURRENCY MUST MATCH */
               /* BANK CURRENCY OR BASE */
               run p_pxmsg(input 2334,
                           input 3).
               next-prompt ckd_acct with frame d.
               undo setacct, retry.
            end. /* IF AVAILABLE ac_mstr */

            {&APMCMTA-P-TAG70}
            {&APMCMTA-P-TAG12}

            {&APMCMTA-P-TAG71}
            find first ckd_det where ckd_det.ckd_domain  = global_domain
                                 and ckd_det.ckd_voucher = ""
                                 and ckd_det.ckd_ref     = ap_mstr.ap_ref
                                 and ckd_det.ckd_acct    = input ckd_acct
                                 and ckd_det.ckd_sub     = input ckd_sub
                                 and ckd_det.ckd_cc      = input ckd_cc
            exclusive-lock no-error.

            {&APMCMTA-P-TAG72}
            {&APMCMTA-P-TAG13}
            {&APMCMTA-P-TAG90}

         end. /* IF INPUT ckd_voucher = "" */

      end. /* SETACCT */

      if not available ckd_det
      then do:

         /* MOVED THE CODE INTO INTERNAL PROCEDURE TO */
         /* AVOID ACTION CODE SEGMENT ERROR.          */

         run create_ckd_det
            (input input ckd_voucher,
             input bk_entity,
             input input ckd_acct,
             input input ckd_sub,
             input input ckd_cc
             {&APMCMTA-P-TAG96}).

      end. /*ADD*/

      else do: /*MODIFY*/

         {&APMCMTA-P-TAG74}
         assign
            undo_all = yes
            ckdrecid = recid(ckd_det).

         if ckd_voucher <> "" then do:
            find vo_mstr where vo_mstr.vo_domain = global_domain
                           and vo_mstr.vo_ref = ckd_voucher
            exclusive-lock no-error.
            find apmstr
            {&APMCMTA-P-TAG16}
            {&APMCMTA-P-TAG75}
                where apmstr.ap_domain = global_domain
                  and apmstr.ap_ref    = vo_mstr.vo_ref
                  and apmstr.ap_type   = "VO"
            exclusive-lock no-error.
            {&APMCMTA-P-TAG76}
            {&APMCMTA-P-TAG17}

            assign
               vorecid     = recid(vo_mstr)
               apbuffrecid = recid(apmstr)
               tax_nbr     = vo_ref.

            /* BACKOUT VENDOR BALANCE */
            amt_to_apply = ckd_amt + ckd_disc.

            if apmstr.ap_curr <> ap_mstr.ap_curr
            then do:
               if apmstr.ap_curr  <> base_curr and
                  ap_mstr.ap_curr =  base_curr
               then
                  amt_to_apply = ckd_cur_amt + ckd_cur_disc.
               else do:
                  /* CONVERT FROM BASE TO FOREIGN CURRENCY */
                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input base_curr,
                       input ck_curr,
                       input ck_ex_rate2,
                       input ck_ex_rate,
                       input amt_to_apply,
                       input true, /* ROUND */
                       output amt_to_apply,
                       output mc-error-number)"}.
                  if mc-error-number <> 0
                  then
                     run p_pxmsg(input mc-error-number,
                                 input 2).
               end. /* ELSE DO */

            end. /* IF apmstr.ap_curr <> ap_mstr.ap_curr */

            {&APMCMTA-P-TAG18}
            find vd_mstr where vd_domain = global_domain and
                               vd_addr = ap_vend
            exclusive-lock.
            {&APMCMTA-P-TAG19}

            /* CONVERT FROM FOREIGN TO BASE CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input vo_curr,
                 input base_curr,
                 input vo_ex_rate,
                 input vo_ex_rate2,
                 input amt_to_apply,
                 input true, /* ROUND */
                 output rndamt,
                 output mc-error-number)"}.
            if mc-error-number <> 0
            then
               run p_pxmsg(input mc-error-number,
                           input 2).

            {&APMCMTA-P-TAG20}
            assign
            {&APMCMTA-P-TAG102}
               vd_balance              = vd_balance + rndamt
               {&APMCMTA-P-TAG103}
               /* BACK OUT VOUCHER APPLIED */
               vo_mstr.vo_applied      = vo_mstr.vo_applied - amt_to_apply
               vo_mstr.vo_base_applied = vo_mstr.vo_base_applied - rndamt
               apmstr.ap_open          = apmstr.ap_amt <> vo_applied.

            if vo_applied = 0
            then
               vo_paid_date = ?.

            {&APMCMTA-P-TAG21}
         end. /* IF CKD_VOUCHER <> "" */
         {&APMCMTA-P-TAG22}

         /* BACK OUT GENERAL LEDGER TRANSACTIONS */
         assign
            base_amt = - ckd_amt
            curr_amt = - ckd_amt.

         /* SET curr_amt  IN TRANSACTION CURRENCY WHEN PAYING A     */
         /* FOREIGN CURRENCY VOUCHER IN BASE CURRENCY. curr_amt     */
         /* AND curr_disc WILL BE SET IN BASE CURRENCY IN APAPGL1.P */
         if ckd_voucher <> "" and
            apmstr.ap_curr <> ap_mstr.ap_curr
         then
            assign
               curr_amt  = - ckd_cur_amt
               curr_disc = - ckd_cur_disc.
         else
            curr_disc = - ckd_disc.

         base_det_amt = - (ckd_amt + ckd_disc).

         if base_curr <> ap_mstr.ap_curr
         then do:

            /* CONVERT FROM FOREIGN TO BASE CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input ck_curr,
                 input base_curr,
                 input ck_ex_rate,
                 input ck_ex_rate2,
                 input base_amt,
                 input true, /* ROUND */
                 output base_amt,
                 output mc-error-number)"}.
            if mc-error-number <> 0
            then
               run p_pxmsg(input mc-error-number,
                           input 2).

            if ckd_voucher <> ""
            then do:
               /* CONVERT FROM FOREIGN TO BASE CURRENCY */
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input vo_curr,
                    input base_curr,
                    input vo_ex_rate,
                    input vo_ex_rate2,
                    input base_det_amt,
                    input true, /* ROUND */
                    output base_det_amt,
                    output mc-error-number)"}.
            end. /* IF ckd_voucher */
            else do:
               /* CONVERT FROM FOREIGN TO BASE CURRENCY */
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input ck_curr,
                    input base_curr,
                    input ck_ex_rate,
                    input ck_ex_rate2,
                    input base_det_amt,
                    input true, /* ROUND */
                    output base_det_amt,
                    output mc-error-number)"}.
            end. /* ELSE DO OF IF ckd_voucher */

            if mc-error-number <> 0
            then
               run p_pxmsg(input mc-error-number,
                           input 2).

         end. /* IF base_curr <> ap_mstr.ap_curr */

         /*GET CURR_AMT AND CURR_DISC IF PAY FOREIGN IN BASE*/
         else if ckd_voucher    <> "" and
                 apmstr.ap_curr <> ap_mstr.ap_curr
         then do:
            /* RESTORED CONVERSION OF BASE_DET_AMT WHICH */
            /* WAS COMMENTED OUT ABOVE BY FM12; THIS LED */
            /* TO NO GAIN/LOSS TRANSACTIONS BEING        */
            /* CREATED WHEN PAYING A FOREIGN CURRENCY    */
            /* VOUCHER IN BASE CURRENCY                  */

            /* CONVERT FROM FOREIGN TO BASE CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input vo_curr,
                 input base_curr,
                 input vo_ex_rate,
                 input vo_ex_rate2,
                 input -(ckd_cur_amt + ckd_cur_disc),
                 input true, /* ROUND */
                 output base_det_amt,
                 output mc-error-number)"}.

            if mc-error-number <> 0
            then
               run p_pxmsg(input mc-error-number,
                           input 2).

         end. /* ELSE IF ckd_voucher <> "" ... */

         {&APMCMTA-P-TAG23}
         assign
            gain_amt     = 0
            for_curr_amt = - ckd_cur_amt.
         {&APMCMTA-P-TAG24}
         {gprun.i ""apapgl1.p"" "(input true)"}   /* REVERSAL */ 
         {&APMCMTA-P-TAG57}
         if undo_all
         {&APMCMTA-P-TAG58}
         then
            undo loope, leave.
         {&APMCMTA-P-TAG25}

         /* CONVERT FROM FOREIGN TO BASE CURRENCY */

         /* THE PARAMETERS ap_curr, ap_ex_rate & ap_ex_rate2     */
         /* ARE EXPLICITLY QUALIFIED WITH THE TABLE NAME ap_mstr */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input ap_mstr.ap_curr,
              input base_curr,
              input ap_mstr.ap_ex_rate,
              input ap_mstr.ap_ex_rate2,
              input ckd_amt,
              input true, /* ROUND */
              output rndamt,
              output mc-error-number)"}.

         if mc-error-number <> 0
         then
            run p_pxmsg(input mc-error-number,
                        input 2).

         {&APMCMTA-P-TAG26}

         /* BACK OUT PAYMENT  TOTAL */
         assign
            ap_mstr.ap_amt      = ap_mstr.ap_amt      - ckd_amt
            ap_mstr.ap_base_amt = ap_mstr.ap_base_amt - rndamt.
         {&APMCMTA-P-TAG27}

      end. /*IF MODIFY*/

      assign
         recno    = recid(ckd_det)
         del-yn   = no
         amt_disc = 0
         ckdamt   = 0.


      {&APMCMTA-P-TAG87}
      if ckd_voucher <> ""
      then do:

         find vo_mstr where vo_mstr.vo_domain = global_domain
                        and vo_mstr.vo_ref    = ckd_voucher
                        and vo_mstr.vo_recur  = no
         exclusive-lock no-error.

         if not available vo_mstr
         then do:
            /* VOUCHER DOESN'T EXIST */
            run p_pxmsg(input 135,
                        input 3).
            undo, retry.
         end. /* IF NOT AVAILABLE vo_mstr */

         else if vo_confirmed = no
         then do:
            /* VOUCHER NOT CONFIRMED */
            run p_pxmsg(input 141,
                        input 3).
            undo, retry.
         end. /* ELSE IF vo_confirmed = no */

         else do:

            find apmstr where apmstr.ap_domain = global_domain
                          and apmstr.ap_ref  = vo_ref
                          and apmstr.ap_type = "VO"
                          and apmstr.ap_vend = ap_mstr.ap_vend
                          {&APMCMTA-P-TAG77}
            exclusive-lock no-error.

            {&APMCMTA-P-TAG78}
            if not available apmstr
            then do:

               for first apmstr where apmstr.ap_domain = global_domain
                                  and apmstr.ap_ref = vo_ref
                                  and apmstr.ap_type = "VO"
               no-lock: end.

               /* VOUCHER EXISTS FOR A DIFFERENT SUPPLIER */
               {pxmsg.i &MSGNUM=2208 &ERRORLEVEL=3
                  &MSGARG1="if available apmstr then apmstr.ap_vend else ''"}
               undo, retry.

            end. /* IF NOT AVAILABLE apmstr */

            {&APMCMTA-P-TAG28}

            assign
               vorecid     = recid(vo_mstr)
               apbuffrecid = recid(apmstr)
               ckd_acct    = apmstr.ap_acct
               ckd_sub     = apmstr.ap_sub
               ckd_cc      = apmstr.ap_cc
               ckd_type    = apmstr.ap_type
               tax_nbr     = vo_ref.

            {&APMCMTA-P-TAG29}

            if apmstr.ap_curr <> ap_mstr.ap_curr
            then do:

               if ap_mstr.ap_curr <> base_curr
               then do:
                  /* IF CURRENCIES DON'T MATCH, PAYMENT CURRENCY */
                  /* MUST BE BASE                                */
                  run p_pxmsg(input 149,
                              input 3).
                  undo, retry.
               end. /* IF ap_mstr.ap_curr <> base_curr */

               else do:
                  /* MAKE SURE A DIFF FOREIGN CURRENCY */
                  /* NOT PAID BY THIS CHECK            */
                  do for ckddet:

                     for each ckddet
                         where ckddet.ckd_domain = global_domain
                           and ckddet.ckd_ref = ck_mstr.ck_ref
                           and ckddet.ckd_voucher <> ""
                     no-lock:

                        for first apmstr1
                            where apmstr1.ap_domain = global_domain
                              and apmstr1.ap_ref = ckddet.ckd_voucher
                              and apmstr1.ap_type = "VO"
                        no-lock: end.

                        if available apmstr1 and
                           apmstr1.ap_curr <> base_curr and
                           apmstr1.ap_curr <> apmstr.ap_curr
                        then do:
                           /* CHECK CANNOT PAY 2 DIFFERENT FOREIGN CURRENCIES */
                           run p_pxmsg(input 148,
                                       input 3).
                           undo loope, retry.
                        end. /* IF AVAILABLE apmstr1 ... */

                     end. /* FOR EACH ckddet */

                  end. /* DO FOR ckddet */

                  /* WARNING: VOUCHER CURR <> INVOICE CURR */
                  run p_pxmsg(input 146,
                              input 2).

                  /* IF FIRST OCCURRENCE OF FOREIGN VOUCHER, */
                  /* SET CK_EX_RATE                          */
                  /* LEAVE AP_MSTR.AP_EX_RATE = 1            */
                  /* FOR DISPLAY IN REPORTS                  */
                  if ck_ex_rate  = 1 and
                     ck_ex_rate2 = 1
                  then do:

                     /* VALIDATE EXCHANGE RATE */
                     /* GET EXCHANGE RATE */
                     {gprunp.i "mcpl" "p" "mc-get-ex-rate"
                        "(input apmstr.ap_curr,
                          input base_curr,
                          input ck_ex_ratetype,
                          input ap_mstr.ap_date,
                          output ck_ex_rate,
                          output ck_ex_rate2,
                          output mc-error-number)"}
                     if mc-error-number <> 0
                     then do:
                        run p_pxmsg(input mc-error-number,
                                    input 3).
                        undo, retry.
                     end. /* IF mc-error-number <> 0 */

                     first_foreign = yes.

                  end. /* IF ck_ex_rate = 1 */
                  else
                     first_foreign = no.

               end. /* ELSE DO OF IF ap_mstr.ap_curr <> base_curr */

            end. /* IF apmstr.ap_curr <> ap_mstr.ap_curr */

            if apmstr.ap_entity <> bk_entity and
               apc_multi_entity_pay = no
            then do:
               /* BANK ENTITY MUST MATCH VOUCHER ENTOTY */
               run p_pxmsg(input 115,
                           input 3).
               undo, retry.
            end.

            {&APMCMTA-P-TAG30}
            vat_ndisc = 0.

            for each tx2d_det where tx2d_domain = global_domain
                                and tx2d_ref    = vo_ref
                                and tx2d_tr_type = "22"
            no-lock:

               for first tx2_mstr
                  fields(tx2_domain tx2_pmt_disc tx2_rcpt_tax_point tx2_tax_code
                  {&APMCMTA-P-TAG100})
                  where tx2_domain   = global_domain
                    and tx2_tax_code = tx2d_tax_code
               no-lock: end.

               if not tx2_pmt_disc
               then
                  /* DO NOT DISCOUNT TAX AT PAYMENT.         */
                  /* ACCUMULATE TAX WHICH IS NOT DISCOUNTABLE */
                  vat_ndisc = vat_ndisc

                  /* THE (POSITIVE) TAX PAID TO THE SUPPLIER */
                  /* IS NOT DISCOUNTABLE.                    */
                            + tx2d_cur_tax_amt

                  /* THE (NEGATIVE) TAX RETAINED IS NOT   */
                  /* DISCOUNTABLE, BECAUSE IT IS NOT PART */
                  /* OF THE CHECK AMOUNT.                 */
                            + tx2d_cur_abs_ret_amt.

            end. /* FOR EACH tx2d_det */

            {&APMCMTA-P-TAG31}

         end. /* ELSE DO OF ELSE IF vo_confirmed = no */

         /* CALCULATE OPEN AMOUNT OF VOUCHER */
         amt_open = apmstr.ap_amt - vo_mstr.vo_applied - vo_mstr.vo_hold_amt.

         /* CALCULATE AMOUNT USED TO CALCULATE DISCOUNT           */
         if apmstr.ap_amt = 0
         then
            disc_ok = 0.

         if apmstr.ap_amt > 0
         then do:
            if (vo_mstr.vo_ndisc_amt + vat_ndisc) >=
               (apmstr.ap_amt - vo_mstr.vo_applied)
            then
               disc_ok = 0.
            else
               disc_ok = min(apmstr.ap_amt - vo_mstr.vo_ndisc_amt - vat_ndisc,
                             apmstr.ap_amt - vo_mstr.vo_applied   -
                             max(vo_mstr.vo_hold_amt,vo_mstr.vo_ndisc_amt)).
         end. /* IF apmstr.ap_amt > 0 */

         if apmstr.ap_amt < 0
         then do:
            if (vo_mstr.vo_ndisc_amt + vat_ndisc) <=
               (apmstr.ap_amt - vo_mstr.vo_applied)
            then
               disc_ok = 0.
            else
               disc_ok = max(apmstr.ap_amt - vo_mstr.vo_ndisc_amt - vat_ndisc,
                             apmstr.ap_amt - vo_mstr.vo_applied
                             - min(vo_mstr.vo_hold_amt,vo_mstr.vo_ndisc_amt)).
         end. /* IF apmstr.ap_amt < 0 */

         /* CALCULATE DISCOUNT */
         run p-calc-discount
           (input vo_mstr.vo_cr_terms,
            input vo_mstr.vo_applied,
            input apmstr.ap_date,
            input ap_mstr.ap_date,
            input vo_mstr.vo_disc_date).

         {&APMCMTA-P-TAG32}
         /* CALCULATE DISCOUNT PERCENTAGE ON DISCOUNTABLE AMOUNT     */
         /* RATHER THAN AMOUNT TO APPLY WHEN DISCOUNT TAX AT PAYMENT */
         /* SET TO NO                                                */

         assign
            ckdamt   = amt_open
            disc_pct =
               if ckdamt <> 0
               then
                  if vo_mstr.vo_applied = 0
                  then
                     (amt_disc / disc_ok) * 100
                  else
                     (amt_disc / ckdamt ) * 100
               else 0.

         /* SET CURR_AMT AND CURR_DISC*/
         if apmstr.ap_curr <> ap_mstr.ap_curr
         then do:
            if not new ckd_det
            then
               assign
                  curr_amt  = ckd_cur_amt
                  curr_disc = ckd_cur_disc.
            else
               assign
                  curr_disc    = amt_disc
                  curr_amt     = amt_open - curr_disc
                  ckd_cur_amt  = curr_amt
                  ckd_cur_disc = curr_disc.

            amt_to_apply = curr_amt + curr_disc.

            /* FIND AMOUNTS IN BASE, CONVERTING ONLY IF NEW */
            if new ckd_det
            then do:

               /* CONVERT FROM FOREIGN TO BASE CURRENCY */
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input ck_curr,
                    input base_curr,
                    input ck_ex_rate,
                    input ck_ex_rate2,
                    input amt_disc,
                    input true, /* ROUND */
                    output amt_disc,
                    output mc-error-number)"}

               /* CONVERT FROM FOREIGN TO BASE CURRENCY */
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input ck_curr,
                    input base_curr,
                    input ck_ex_rate,
                    input ck_ex_rate2,
                    input ckdamt,
                    input true, /* ROUND */
                    output ckdamt,
                    output mc-error-number)"}.
               if mc-error-number <> 0
               then
                  run p_pxmsg(input mc-error-number,
                              input 2).

               /* NOTE: THE FIELDS AMT_DISC AND CKDAMT ARE         */
               /* CALCULATED BASED ON THE VOUCHER DOCUMENT AMOUNTS,*/
               /* WHICH ARE IN DOCUMENT CURRENCY FOR THE VOUCHER.  */
               /* IF THE CHECK IS                                  */
               /* IN A DIFFERENT CURRENCY THAN THE VOUCHER,        */
               /* (WHICH THEN MEANS IT MUST BE IN BASE CURRENCY)   */
               /* THEN THESE AMOUNTS MUST BE CONVERTED TO BASE.    */

            end. /* IF NEW ckd_det */
            else
               /* THESE SHOULD ALREADY BE IN THE CORRECT CURRENCY  */
               /* SINCE THIS IS NOT A NEW CHECK.                   */
               assign
                  amt_disc = ckd_disc
                  ckdamt   = ckd_disc + ckd_amt.
         end. /* IF APMSTR.AP_CURR <> AP_MSTR.AP_CURR   */
              /* THIS MEANS IF PAYING FOREIGN WITH BASE */

         display
            apmstr.ap_type @ ckd_type
         with frame d.
      end. /* CKD_VOUCHER <> "" */

      assign
         ckdamt:format   in frame d = ckd_amt_fmt
         ckd_amt:format  in frame d = ckd_amt_fmt
         ckd_disc:format in frame d = ckd_disc_fmt.

      {&APMCMTA-P-TAG54}
      display
         ckd_type
         ckd_acct
         ckd_sub
         ckd_cc
         ckdamt
         (ckdamt - amt_disc) @ ckd_amt
         amt_disc @ ckd_disc
      with frame d.

      {&APMCMTA-P-TAG91}
      if new ckd_det
      then do:

         newchk:
         do with frame d on error undo, retry:
            /* NOTE: VALIDATE INPUT IN BASE IF NEW CHECK, */
            /* ELSE FOREIGN                               */
            update ckdamt with frame d.

            if ckdamt <> 0
            then do:
               {gprun.i ""gpcurval.p""
                  "(input ckdamt,
                    input rndmthd,
                    output retval)"}

               if retval <> 0
               then do:
                  next-prompt ckdamt with frame d.
                  undo newchk, retry newchk.
               end. /* IF retval <> 0 */
            end. /* IF ckdamt <> 0 */
         end. /* NEWCHK: */

         /* CALCULATE DISCOUNT */
         if ckdamt entered
         then do:

            if ckd_voucher <> ""
            then do:
               /***********************************************/
               /* DISCOUNT AVAILABLE =                        */
               /* MIN OF (OR MAX IF CREDIT VOUCHER):          */
               /* THE AMT TO APPLY LESS ANY NON-DISCOUNT AMT  */
               /* AND AMT TO APPLY LESS ANY HOLD AMOUNT       */
               /***********************************************/

               /* SET pmt_ex_rate TO CALCULATE                  */
               /* DISCOUNT OF FOREIGN VOUCHER PAID              */
               /* IN BASE AND TO SEE IF CKDAMT OVER AMOUNT OPEN */
               assign
                  pmt_ex_rate  = 1
                  pmt_ex_rate2 = 1.
               if apmstr.ap_curr <> ap_mstr.ap_curr
               then
                  assign
                     {&APMCMTA-P-TAG92}
                     pmt_ex_rate  = ck_ex_rate
                     {&APMCMTA-P-TAG93}
                     pmt_ex_rate2 = ck_ex_rate2.

               if apmstr.ap_amt = 0
               then
                  disc_ok = 0.
               else do:
                  /* CONVERT FROM FOREIGN TO BASE CURRENCY */
                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input ck_curr,
                       input base_curr,
                       input pmt_ex_rate,
                       input pmt_ex_rate2,
                       input (vo_mstr.vo_ndisc_amt
                       + vat_ndisc
                       - vo_mstr.vo_applied),
                       input false, /* DO NOT ROUND */
                       output base_amount_1,
                       output mc-error-number)"}

                  /* CONVERT FROM FOREIGN TO BASE CURRENCY */
                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input ck_curr,
                       input base_curr,
                       input pmt_ex_rate,
                       input pmt_ex_rate2,
                       input (apmstr.ap_amt
                       - vo_mstr.vo_applied
                       - vo_mstr.vo_hold_amt),
                       input false, /* DO NOT ROUND */
                       output base_amount_2,
                       output mc-error-number)"}

                  if apmstr.ap_amt > 0
                  then
                     disc_ok = min(ckdamt - max(base_amount_1,0),
                                   max(ckdamt,base_amount_2)).
                  if apmstr.ap_amt < 0
                  then
                     disc_ok = max(ckdamt - max(base_amount_1,0),
                                   max(ckdamt,base_amount_2)).
               end. /* ELSE DO OF IF apmstr.ap_amt = 0 */

               /* EXCLUDE NON DISCOUNTABLE AMOUNT FROM DISCOUNT */
               /* CALCULATION WHEN PREVIOUS PAYMENT IS APPLIED  */
               /* TO THE VOUCHER                                */

               if vo_mstr.vo_applied = 0
               then
                  ckd_disc = disc_ok * (disc_pct / 100).
               else
                  ckd_disc = ckdamt * (disc_pct / 100).

               {gprunp.i "mcpl" "p" "mc-curr-rnd"
                  "(input-output ckd_disc,
                    input rndmthd,
                    output mc-error-number)"}
               if mc-error-number <> 0
               then
                  run p_pxmsg(input mc-error-number,
                              input 2).

            end. /*CKD_VOUCHER <> ""*/
            else
               ckd_disc = 0.

            /* CONVERT FROM BASE TO FOREIGN CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input base_curr,
                 input ck_curr,
                 input ck_ex_rate2,
                 input ck_ex_rate,
                 input ckdamt,
                 input true, /* ROUND */
                 output amt_to_apply,
                 output mc-error-number)"}.
            if mc-error-number <> 0
            then
               run p_pxmsg(input mc-error-number,
                           input 2).

         end. /* CKDAMT ENTERED */

         else
         /* ON GO-KEY OR not entered INITIALIZE amt_to_apply */
         /* WITH OPEN AMOUNT                                 */
            assign
               ckd_disc     = amt_disc
               curr_disc    = amt_disc
               curr_amt     = amt_open - curr_disc
               amt_to_apply = curr_amt + curr_disc.

         ckd_amt = ckdamt - ckd_disc.

         /* CONVERT FROM FOREIGN TO BASE CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input ck_curr,
              input base_curr,
              input pmt_ex_rate,
              input pmt_ex_rate2,
              input amt_open,
              input false, /* DO NOT ROUND */
              output rndamt,
              output mc-error-number)"}.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output rndamt,
              input rndmthd,
              output mc-error-number)"}
         if mc-error-number <> 0
         then
            run p_pxmsg(input mc-error-number,
                        input 2).

         {&APMCMTA-P-TAG33}
         if ckdamt entered and
            (ckd_voucher <> "" and
            ((ckdamt > rndamt and amt_open >= 0) or
            (ckdamt < rndamt and amt_open  < 0)) )
            and not first_foreign
         then do:
            /* AMT APPLIED > AMT OPEN */
            run p_pxmsg(input 1157,
                        input 3).
            undo, retry.
         end. /* IF ckdamt ENTERED ... */

      end. /* IF NEW ckd_det */
      {&APMCMTA-P-TAG94}
      ststatus = stline[2].
      status input ststatus.
      display
         ckd_amt
         ckd_disc
      with frame d.
      assign
         old_amt = ckd_amt
         old_disc = ckd_disc.


/* SS - 110114.1 - B */
        {gprun.i ""xxgpdescm.p""
          "(input        frame-row(d) - 3 ,
            input-output ckd_user1 )"}
        {xxgpdescm2.i &table=ckd_det &desc=ckd_user1}
/* SS - 110114.1 - E */

      seta:
      do with frame d on error undo, retry:
         {&APMCMTA-P-TAG34}
         set ckd_amt ckd_disc go-on ("F5" "CTRL-D" ).
         /* DELETE */
         if lastkey = keycode("F5")
         or lastkey = keycode("CTRL-D")
         then do:
            del-yn = yes.
            /*CONFIRM DELETE*/
            {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
            if del-yn
            then
               leave seta.
         end. /* IF lastkey = ... */
         {&APMCMTA-P-TAG35}

         /* VALIDATE CURRENCY INPUT PER DOCUMENT (CHECK) */
         /* ROUNDING METHOD                              */
         if ckd_amt <> 0
         then do:
            {gprun.i ""gpcurval.p""
               "(input ckd_amt,
                 input rndmthd,
                 output retval)"}
            if retval <> 0
            then do:
               next-prompt ckd_amt with frame d.
               undo seta, retry seta.
            end. /* IF retval <> 0 */
         end. /* IF ckd_amt <> 0 */

         if ckd_disc <> 0
         then do:
            {gprun.i ""gpcurval.p""
               "(input ckd_disc,
                 input rndmthd,
                 output retval)"}
            if retval <> 0
            then do:
               next-prompt ckd_disc with frame d.
               undo seta, retry seta.
            end. /* IF retval <> 0 */
         end. /* IF ckd_disc <> 0 */

         /* IF VOUCHER CURR <> PAYMENT CURR THEN PROMPT FOR     */
         /* AMOUNT TO APPLY                                     */
         /* IN VOUCHER CURRENCY, THE DEFAULT WILL BE CALCULATED */
         /* USING CK_EX_RATE                                    */
         /* RECALCULATE IF NECESSARY CURR_AMT, CURR_DISC AND    */
         /* AMT_TO_APPLY                                        */

         aprndmthd = rndmthd.
         if ckd_voucher    <> "" and
            apmstr.ap_curr <> ap_mstr.ap_curr
         then do:

            {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
               "(input apmstr.ap_curr,
                 output aprndmthd,
                 output mc-error-number)"}

            if mc-error-number <> 0
            then do:
               run p_pxmsg(input mc-error-number,
                           input 3).
               undo seta, retry seta.
            end. /* IF mc-error-level <> 0 */

         end. /* IF ckd_voucher <> "" ... */

         if ckd_amt <> old_amt
         then do:

            /* CONVERT FROM BASE TO FOREIGN CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input base_curr,
                 input ck_curr,
                 input ck_ex_rate2,
                 input ck_ex_rate,
                 input ckd_amt,
                 input false, /* DO NOT ROUND */
                 output curr_amt,
                 output mc-error-number)"}.

            {gprunp.i "mcpl" "p" "mc-curr-rnd"
               "(input-output curr_amt,
                 input aprndmthd,
                 output mc-error-number)"}

            if mc-error-number <> 0
            then
               run p_pxmsg(input mc-error-number,
                           input 2).
         end. /* IF ckd_amt <. old_amt */

         if ckd_disc <> old_disc
         then do:

            /* CONVERT FROM BASE TO FOREIGN CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input base_curr,
                 input ck_curr,
                 input ck_ex_rate2,
                 input ck_ex_rate,
                 input ckd_disc,
                 input false, /* DO NOT ROUND */
                 output curr_disc,
                 output mc-error-number)"}.

            {gprunp.i "mcpl" "p" "mc-curr-rnd"
               "(input-output curr_disc,
                 input aprndmthd,
                 output mc-error-number)"}

            if mc-error-number <> 0
            then
               run p_pxmsg(input mc-error-number,
                           input 2).
         end. /* IF ckd_disc <> old_disc */

         /* THE AMOUNT FOR PAYMENT IN FOREIGN CURRENCY ckd_cur_amt */
         /* SHOULD BE ZERO WHEN ckd_amt IS EQUAL TO ZERO AND       */
         /* THE DISCOUNT AMOUNT IN FOREIGN CURRENCY ckd_cur_disc   */
         /* SHOULD BE ZERO WHEN ckd_disc IS EQUAL TO ZERO .        */

         if ckd_amt = 0
         then
            assign
               curr_amt    = 0
               ckd_cur_amt = 0.

         if ckd_disc = 0
         then
            assign
               curr_disc    = 0
               ckd_cur_disc = 0.

         if ckd_amt  <> old_amt
         or ckd_disc <> old_disc
         then
            amt_to_apply = curr_amt + curr_disc.

         if  ckd_voucher    <> ""
         and apmstr.ap_curr <> ap_mstr.ap_curr
         and amt_to_apply   <> 0
         then

            seta_sub:
            do on error undo, retry:

               /* AMOUNT TO APPLY IS THE CASH + DISC */
               /* IN THE VOUCHER'S CURR              */
               old_amt_to_apply = amt_to_apply.
               /* OF COURSE THIS CANNOT BE MORE THAN */
               /* THE AMT OPEN ON THE VOUCHER        */
               if apmstr.ap_amt > 0
               then
                  amt_to_apply = min(amt_to_apply,amt_open).
               else if apmstr.ap_amt < 0
               then
                  amt_to_apply = max(amt_to_apply,amt_open).

               assign
                  amt_apply_old = amt_to_apply:format
                  amt_apply_fmt = amt_apply_old.

               {gprun.i ""gpcurfmt.p"" "(input-output amt_apply_fmt,
                 input aprndmthd)"}
               amt_to_apply:format in frame seta_sub = amt_apply_fmt.

               display apmstr.ap_curr with frame seta_sub.
               update amt_to_apply with frame seta_sub.

           {&APMCMTA-P-TAG85}

               if amt_to_apply = 0
               then do:
                  /*ZERO NOT ALLOWED*/
                  run p_pxmsg(input 317,
                              input 3).
                  undo seta_sub, retry.
               end. /* IF amt_to_apply = 0 */

               /* IF VOUCHER AND BASE CURRENCY ARE BOTH PART OF    */
               /* EMU, FIELD amt_to_apply CAN NOT BE CHANGED SINCE */
               /* THERE WILL BE A FIXED RATE BETWEEN THE VOUCHER   */
               /* AND BASE CURRENCY                                */
               if amt_to_apply <> old_amt_to_apply
               then do:
                  run check_voucher_curr
                     (input  base_curr,
                      input  apmstr.ap_curr,
                      input  ap_mstr.ap_date,
                      output l_is_emu_curr).
                  if l_is_emu_curr
                  then do:
                     /* CAN NOT CHANGE AMOUNT TO APPLY */
                     /* FOR FIXED RATE CURRENCY        */
                     run p_pxmsg(input 2771,
                                 input 3).
                     undo seta_sub, retry.
                  end. /* IF l_is_emu_curr */
               end. /* IF amt_to_apply <> old_amt_to_apply */

               {gprun.i ""gpcurval.p""
                  "(input amt_to_apply,
                    input aprndmthd,
                    output retval)"}

               if retval <> 0
               then do:
                  next-prompt amt_to_apply with frame seta_sub.
                  undo seta_sub, retry seta_sub.
               end. /* IF retval <> 0 */

               /* FIND THE RESULTING EX RATE (foreign amt / base_amt) */
               if not first_foreign
               and amt_to_apply <> old_amt_to_apply
               then do:
                  /* CAN ONLY CHANGE AMOUNT TO APPLY */
                  /* FOR FIRST FOREIGN VOUCHER       */
                  run p_pxmsg(input 147,
                              input 3).
                  undo seta_sub, retry.
               end. /* IF NOT first_foreign */

               /* TO AVOID UPDATION OF INCORRECT AMT OPEN DUE TO      */
               /* ROUNDING DIFFERENCE WHEN NON-BASE CURRENCY VOUCHERS */
               /* ARE PAID IN BASE CURRENCY USING SINGLE/MULTIPLE     */
               /* CHECKS WHICH ARE DELETED AND ALSO WHEN VOUCHERS     */
               /* ARE PAID AGAIN                                      */

               if first_foreign
               and (amt_to_apply <> old_amt_to_apply
               or   ckd_amt      <> old_amt
               or   ckd_disc     <> old_disc)
               then do:

                  assign
                     pmt_ex_rate = amt_to_apply
                     pmt_ex_rate2 = ckd_amt + ckd_disc.

                  /* VALIDATE EXCHANGE RATE AGAINST TOLERANCE PERCENT         */
                  /* ck_ex_rate SHOULD STILL BE THE DAILY RATE SET FROM ABOVE */

                  exch_var = ((pmt_ex_rate / pmt_ex_rate2)
                           - (ck_ex_rate / ck_ex_rate2))
                           / (ck_ex_rate / ck_ex_rate2) * 100.

                  if exch_var < 0
                  then
                     exch_var = - exch_var.

                  if exch_var > apc_ex_tol
                  then do:

                     /* EXCHANGE RATE OUT OF TOLERANCE */
                     /* CANNOT APPLY THIS AMOUNT       */
                     {pxmsg.i &MSGNUM=145 &ERRORLEVEL=3
                        &MSGARG2=string(pmt_ex_rate)
                        &MSGARG3=string(pmt_ex_rate2)}
                     undo seta_sub, retry.
                  end. /* IF exch_var > apc_ex_tol */
                  else
                     assign
                        ck_ex_rate = pmt_ex_rate
                        ck_ex_rate2 = pmt_ex_rate2.
               end. /* IF first_foreign */

               /*IF AMT, DISC, OR AMT_TO APPLY CHANGED, SET CURR AMTS*/
               if ckd_amt entered
               or ckd_disc entered
               or amt_to_apply <> old_amt_to_apply
               or ckdamt entered
               then do:

                  /* CONVERT FROM BASE TO FOREIGN CURRENCY */
                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input base_curr,
                       input ck_curr,
                       input ck_ex_rate2,
                       input ck_ex_rate,
                       input ckd_amt,
                       input false, /* DO NOT ROUND */
                       output ckd_cur_amt,
                       output mc-error-number)"}.

                  /* CONVERT FROM BASE TO FOREIGN CURRENCY */
                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input base_curr,
                       input ck_curr,
                       input ck_ex_rate2,
                       input ck_ex_rate,
                       input ckd_disc,
                       input false, /* DO NOT ROUND */
                       output ckd_cur_disc,
                       output mc-error-number)"}.

                  {gprunp.i "mcpl" "p" "mc-curr-rnd"
                     "(input-output ckd_cur_amt,
                       input aprndmthd,
                       output mc-error-number)"}

                  {gprunp.i "mcpl" "p" "mc-curr-rnd"
                     "(input-output ckd_cur_disc,
                       input aprndmthd,
                       output mc-error-number)"}

                  if mc-error-number <> 0
                  then
                     run p_pxmsg(input mc-error-number,
                                 input 2).
               end. /* IF ckd_amt ENTERED ... */
            end. /* seta_sub */
         else
            amt_to_apply = ckd_disc + ckd_amt.
      end. /* seta */

      {&APMCMTA-P-TAG79}
      {&APMCMTA-P-TAG36}
      if del-yn
      then do:

         /* IF DELETE ONLY FOREIGN VO FROM BASE CK, */
         /* RESET CK_EX_RATE TO 1                   */
         if ckd_voucher <> "" and
            apmstr.ap_curr <> ap_mstr.ap_curr
         then do for ckddet:

            reset_ok = yes.

            for each ckddet where ckddet.ckd_domain = global_domain
                              and ckddet.ckd_ref    =  ck_mstr.ck_ref
                              and ckddet.ckd_voucher <> ""
                              and ckddet.ckd_voucher <> ckd_det.ckd_voucher
            no-lock:

               for first apmstr1 where apmstr1.ap_domain = global_domain
                                   and apmstr1.ap_ref = ckddet.ckd_voucher
                                   and apmstr1.ap_type = "VO"
               no-lock: end.

               if available apmstr1 and
                  apmstr1.ap_curr <> base_curr
               then do:
                  reset_ok = no.
                  leave.
               end. /* IF AVAILABLE apmstr1 */

            end. /* FOR EACH ckddet */

            if reset_ok then
               assign
                  ck_ex_rate  = 1
                  ck_ex_rate2 = 1.
         end. /* DO FOR ckddet */

         if daybooks-in-use
         then do:

            /* NRM SEQUENCE GENERATED ONLY WHEN GL REF IS NEW */
            if l_new_gl = yes
            then do:

               {gprunp.i "nrm" "p" "nr_dispense"
                  "(input  ap_mstr.ap_dy_code,
                    input  ap_mstr.ap_effdate,
                    output nrm-seq-num)"}

               l_new_gl = no.

            end. /* IF l_new_gl = yes */

            /* CALL assign_nrm_seq_number FOR ASSIGNING SEQUENCE  */
            /* ONLY TO glt_det FOR DELETED RECORDS.               */

            {pxrun.i
                &PROGRAM='apgl.p'
                &PROC='assign_nrm_seq_number'
                &PARAM= "(input nrm-seq-num,
                          input ap_mstr.ap_dy_code,
                          input ref,
                          input-output table tt_ckd_manual)"
             }

         end. /* IF daybooks-in-use */


         {gprun.i ""txdelete.p""
            "(input tax_tr_type,
              input ck_ref,
              input tax_nbr)" }

         {&APMCMTA-P-TAG37}
         {&APMCMTA-P-TAG80}
         delete ckd_det.

         clear frame d.
         del-yn = no.
         next loope.

      end. /* IF del-yn */

      if ckd_voucher <> ""
      then do:

         {&APMCMTA-P-TAG38}
         /* CHECK FOR OVERPAYMENT */
         if (apmstr.ap_amt - vo_applied - amt_to_apply
            - vo_mstr.vo_hold_amt < minimum(0,apmstr.ap_amt))
         or (apmstr.ap_amt < 0
         and apmstr.ap_amt - vo_applied - amt_to_apply
            - vo_mstr.vo_hold_amt > maximum(0,apmstr.ap_amt))
         then do:
            /* AMT APPLIED > AMT OPEN */
            run p_pxmsg(input 1157,
                        input 3).
            undo, retry.
         end. /* CHECK FOR OVERPAYMENT */

         /* UPDATE APPLIED AMOUNT */
         vo_applied = vo_applied + amt_to_apply.

         /* CONVERT FROM FOREIGN TO BASE CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input vo_curr,
              input base_curr,
              input vo_ex_rate,
              input vo_ex_rate2,
              input vo_applied,
              input true, /* ROUND */
              output vo_base_applied,
              output mc-error-number)"}.
         if mc-error-number <> 0
         then
            run p_pxmsg(input mc-error-number,
                        input 2).

         {&APMCMTA-P-TAG39}
         assign
            vo_paid_date   =
               if vo_applied = 0 then ? else ap_mstr.ap_date
            apmstr.ap_open = apmstr.ap_amt <> vo_applied.

         {&APMCMTA-P-TAG104}
         /*UPDATE VENDOR BALANCE*/
         find vd_mstr where vd_mstr.vd_domain = global_domain
                        and vd_mstr.vd_addr = apmstr.ap_vend
         exclusive-lock.
         {&APMCMTA-P-TAG105}

         /* CONVERT FROM FOREIGN TO BASE CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input vo_curr,
              input base_curr,
              input vo_ex_rate,
              input vo_ex_rate2,
              input amt_to_apply,
              input true, /* ROUND */
              output rndamt,
              output mc-error-number)"}.

         {&APMCMTA-P-TAG40}
         assign
            vd_balance       = vd_balance - rndamt
            /* REMOVE ANY AMOUNT SELECTED FOR AUTOMATIC PMT */
            vo_amt_chg       = 0
            vo_base_amt_chg  = 0
            vo_disc_chg      = 0
            vo_base_disc_chg = 0.

      end. /* IF CKD_VOUCHER <> "" */
      {&APMCMTA-P-TAG41}

      {&APMCMTA-P-TAG88}
      /* CALCULATE ANY TAX ADJUSTMENTS FOR DISCOUNT AT PAYMENT */

      for first apmstr where apmstr.ap_domain = global_domain
                       and   apmstr.ap_type   = "VO"
                       and   apmstr.ap_ref    = ckd_voucher
      no-lock :
      end. /* FOR FIRST apmstr */

      if available apmstr
      then do:
         /* GET THE TRANSACTION EXCHANGE RATE */
         l_disc =
            if ckd_voucher    <> "" and
               apmstr.ap_curr <> ap_mstr.ap_curr
            then
               ckd_cur_disc
            else
               ckd_disc.

         /* IN A MULTI-CURRENCY SETUP WHEN GTM IS OPERATING AS A VAT */
         /* ENVIRONMENT i.e. TAXES ACCRUED AT VOUCHER INSTEAD OF PO  */
         /* RECEIPT AND THE DISCOUNT TAX AT PAYMENT = YES THE        */
         /* VOUCHER EXCHANGE RATE IS USED TO CREDIT THE TAX DISCOUNT */
         /* PORTION AT PAYMENT,ELSE THE CHECK EXCHANGE RATE IS USED. */
         assign
            det_ex_rate     = ck_ex_rate
            det_ex_rate2    = ck_ex_rate2
            det_ex_ratetype = ck_ex_ratetype
            l_tax_date      = ap_mstr.ap_date.  /* CHECK DATE */

         if base_curr <> vo_curr
         then do:

            for first tx2d_det
               fields(tx2d_domain tx2d_cur_abs_ret_amt tx2d_cur_tax_amt
                      tx2d_ref tx2d_tax_code tx2d_tr_type)
                where tx2d_domain = global_domain
                  and tx2d_ref    = tax_nbr
                  and tx2d_tr_type = old_tr_type
            no-lock: end.

            if available tx2d_det
            then do:
               for first tx2_mstr
                  fields(tx2_domain tx2_pmt_disc tx2_rcpt_tax_point tx2_tax_code
                  {&APMCMTA-P-TAG100})
                  where tx2_domain   = global_domain
                    and tx2_tax_code = tx2d_tax_code
               no-lock: end.
               assign
                  l_pmt_disc       = tx2_pmt_disc
                  {&APMCMTA-P-TAG98}
                  l_rcpt_tax_point = tx2_rcpt_tax_point.
            end. /* IF AVAIL tx2d_det */

            if l_pmt_disc and
               {&APMCMTA-P-TAG99}
               not l_rcpt_tax_point
            then
               assign
                  det_ex_rate     = vo_ex_rate
                  det_ex_rate2    = vo_ex_rate2
                  det_ex_ratetype = vo_ex_ratetype
                  l_tax_date      = apmstr.ap_date. /* VOUCHER DATE */

         end. /*IF base_curr <> vo_curr */

         /* L_TAX_DATE IS USED IN txcalc29.p TO GET THE ENTITY   */
         /* EXCHANGE RATE. IT CONTAINS VOUCHER DATE IF VOUCHER   */
         /* EXCHANGE RATE IS PASSED to txcalc29.p, ELSE IT       */
         /* CONTAINS THE CHECK DATE.                             */

         /* CALCULATE TAX ADJUSTMENT & CREATE DETAIL */
         assign
            {&APMCMTA-P-TAG55}
            tax_ref  = string(ck_bank, "X(2)") + string(ck_nbr)
            {&APMCMTA-P-TAG56}
            sav-mthd = rndmthd.

         /* ADDED SECOND EXCHANGE RATE BELOW */
         /* ADDED DET_EX_RATETYPE BELOW */
         {gprun.i ""txcalc29.p""
            "(input  tax_tr_type,
              input  tax_ref,
              input  tax_nbr,
              input  0, /* ALL LINES */
              input  old_tr_type,
              input  ap_mstr.ap_date,
              input  det_ex_rate,
              input  det_ex_rate2,
              input  det_ex_ratetype,
              input  l_disc / apmstr.ap_amt,
              input  l_tax_date)" }

         rndmthd = sav-mthd.

      end. /* IF AVAILABLE apmstr  */

      /* UPDATE GL TRANSACTION FILE */
      assign
         undo_all = yes
         ckdrecid = recid(ckd_det)
         base_amt = ckd_amt
         curr_amt = ckd_amt.
      {&APMCMTA-P-TAG42}

      /* SET curr_amt  IN TRANSACTION CURRENCY WHEN PAYING A     */
      /* FOREIGN CURRENCY VOUCHER IN BASE CURRENCY. curr_amt     */
      /* AND curr_disc WILL BE SET IN BASE CURRENCY IN APAPGL1.P */
      if (ckd_det.ckd_voucher <> ""
      and apmstr.ap_curr <> ap_mstr.ap_curr)
      then
         assign
            curr_amt  = ckd_cur_amt
            curr_disc = ckd_cur_disc.
      else
         curr_disc = ckd_disc.

      base_det_amt = ckd_amt + ckd_disc.

      if base_curr <> ap_mstr.ap_curr
      then do:

         /* CONVERT FROM FOREIGN TO BASE CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input ck_mstr.ck_curr,
              input base_curr,
              input ck_ex_rate,
              input ck_ex_rate2,
              input base_amt,
              input true, /* ROUND */
              output base_amt,
              output mc-error-number)"}.
         if mc-error-number <> 0
         then
            run p_pxmsg(input mc-error-number,
                        input 2).

         if ckd_voucher <> ""
         then do:
            {&APMCMTA-P-TAG43}
            /* CONVERT FROM FOREIGN TO BASE CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input vo_curr,
                 input base_curr,
                 input vo_ex_rate,
                 input vo_ex_rate2,
                 input base_det_amt,
                 input true, /* ROUND */
                 output base_det_amt,
                 output mc-error-number)"}.
            {&APMCMTA-P-TAG44}
         end. /* IF ckd_voucher <> "" */
         else do:
            /* CONVERT FROM FOREIGN TO BASE CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input ck_curr,
                 input base_curr,
                 input ck_ex_rate,
                 input ck_ex_rate2,
                 input base_det_amt,
                 input true, /* ROUND */
                 output base_det_amt,
                 output mc-error-number)"}.
         end. /* ELSE DO OF IF ckd_voucher <> "" */
         if mc-error-number <> 0
         then
            run p_pxmsg(input mc-error-number,
                        input 2).
      end. /* IF base_curr <> ap_mstr.ap_curr */
      else if ckd_voucher    <> ""
          and apmstr.ap_curr <> base_curr
      then do:

         /* CONVERT FROM FOREIGN TO BASE CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input vo_curr,
              input base_curr,
              input vo_ex_rate,
              input vo_ex_rate2,
              input (ckd_cur_amt + ckd_cur_disc),
              input true, /* ROUND */
              output base_det_amt,
              output mc-error-number)"}.
         if mc-error-number <> 0
         then
            run p_pxmsg(input mc-error-number,
                        input 2).

      end. /* ELSE IF ckd_voucher <> "" */

      assign
         gain_amt     = 0
         for_curr_amt = ckd_cur_amt.

      {&APMCMTA-P-TAG45}
      {gprun.i ""apapgl1.p"" "(input false)"}   /* NOT A REVERSAL */ 
      if undo_all
      then
         undo loope, leave.

      /* CREATE THE TT_CKD_MANUAL FOR ALL THE CHECK DEATIL LINES */
      if daybooks-in-use
         and not can-find (tt_ckd_manual
                 where tt_ckd_ref     = ckd_ref
                 and   tt_ckd_voucher = ckd_voucher
                 and   tt_ckd_type    = ckd_type
                 and   tt_ckd_entity  = ckd_entity
                 and   tt_ckd_acct    = ckd_acct
                 and   tt_ckd_sub     = ckd_sub
                 and   tt_ckd_cc      = ckd_cc
                 and   tt_ckd_project = ckd_project)
      then do:
         create tt_ckd_manual.
         assign
            tt_ckd_ref     = ckd_ref
            tt_ckd_voucher = ckd_voucher
            tt_ckd_type    = ckd_type
            tt_ckd_entity  = ckd_entity
            tt_ckd_acct    = ckd_acct
            tt_ckd_sub     = ckd_sub
            tt_ckd_cc      = ckd_cc
            tt_ckd_project = ckd_project.
      end. /* IF daybooks-in-use */

      {&APMCMTA-P-TAG81}
      /* CONVERT FROM FOREIGN TO BASE CURRENCY */
      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input ap_mstr.ap_curr,
           input base_curr,
           input ap_mstr.ap_ex_rate,
           input ap_mstr.ap_ex_rate2,
           input ckd_amt,
           input true, /* ROUND */
           output rndamt,
           output mc-error-number)"}.
      if mc-error-number <> 0
      then
         run p_pxmsg(input mc-error-number,
                     input 2).

      /* UPDATE PAYMENT TOTAL */
      {&APMCMTA-P-TAG46}
      assign
         ap_mstr.ap_amt      = ap_mstr.ap_amt + ckd_amt
         ap_mstr.ap_base_amt = ap_mstr.ap_base_amt + rndamt
         ckd_dy_num          = nrm-seq-num.

      {&APMCMTA-P-TAG82}
   end. /* LOOPE */

   {&APMCMTA-P-TAG83}
   if ap_mstr.ap_amt >= 0
   then
      done = true.
   else do:
      /* CANNOT ACCEPT CHECK WITH NEGATIVE NET AMOUNT */
      run p_pxmsg(input 4017,
                  input 4).
   end. /* ELSE DO OF IF ap_mstr.ap_amt >= 0 */
   {&APMCMTA-P-TAG47}

end. /* AMTLOOP */

{&APMCMTA-P-TAG84}
hide frame d.
{&APMCMTA-P-TAG48}

PROCEDURE p-calc-discount:
/* -------------------------------------------------------------------------
   Purpose:     Calculates discount amount
   Parameters:  p-vo-cr-terms  Credit terms from voucher
                p-vo-applied   Amount applied from voucher
                p-ap-buf-date
                p-ap-mstr-date
                p-vo-disc-date Discount Date from voucher
   Notes:       Moved this code to internal procedure to avoid
                compile error
 --------------------------------------------------------------------------*/
   define input parameter p-vo-cr-terms  like vo_mstr.vo_cr_terms  no-undo.
   define input parameter p-vo-applied   like vo_mstr.vo_applied   no-undo.
   define input parameter p-ap-buf-date  like ap_mstr.ap_date      no-undo.
   define input parameter p-ap-mstr-date like ap_mstr.ap_date      no-undo.
   define input parameter p-vo-disc-date like vo_mstr.vo_disc_date no-undo.

   for first ct_mstr
      fields(ct_domain ct_base_date ct_base_days ct_code ct_dating ct_disc_date
             ct_disc_days ct_disc_pct ct_due_date ct_due_days ct_due_inv
             ct_from_inv ct_min_days)
       where ct_domain = global_domain
         and ct_code = p-vo-cr-terms
   no-lock: end.

   /* IF MULTIPLE CREDIT TERMS, GET DISCOUNT PERCENTAGES FROM */
   /* CREDIT TERMS DETAIL FILE                                */
   if available ct_mstr and
      ct_dating
   then do:

      tot-amt-disc = 0.

      for each ctd_det where ctd_domain = global_domain
                         and ctd_code = p-vo-cr-terms
      no-lock use-index ctd_cdseq:

         /* CALCULATE CREDIT TERMS */
         assign
            due-date = ?
            disc-date = ?.
         {&APMCMTA-P-TAG49}
         {adctrms.i
            &date = p-ap-buf-date
            &due_date = due-date
            &disc_date = disc-date
            &cr_terms = ctd_date_cd}
         {&APMCMTA-P-TAG50}

         if available ct_mstr
         then do:

            /* CALCULATE EACH SEGMENTS' AMT-DISC AND AMT-DUE      */
            /* AND SET THE TOT-AMT-DISC AND TOT-AMT-DUE TO        */
            /* GO INTO VO_AMT_CHG AND VO_AMT_DISC                 */

            /* EXCLUDE NON DISCOUNTABLE AMOUNT FROM DISCOUNT      */
            /* CALCULATIONS WHEN DISOCUNT TAX AT PAYMENT SET      */
            /* TO NO FOR MULTIPLE DUE DATES AND MULTIPLE PAYMENTS */

            if p-vo-applied = 0
            then
               amt-due = disc_ok  * (ctd_pct_due / 100).
            else
               amt-due = amt_open * (ctd_pct_due / 100).

            if disc-date >= p-ap-mstr-date
            then do:
               amt-disc = amt-due * (ct_disc_pct / 100).

               {gprunp.i "mcpl" "p" "mc-curr-rnd"
                  "(input-output amt-disc,
                    input rndmthd,
                    output mc-error-number)"}
               if mc-error-number <> 0
               then
                  run p_pxmsg(input mc-error-number,
                              input 2).

               tot-amt-disc = tot-amt-disc + amt-disc.
               if ctd_pct_due =  100 and
                  amt-disc    <> 0
               then
                  leave.
            end. /* IF disc-date >= p-ap-mstr-date */

         end. /* IF AVAILABLE ct_mstr */

      end. /* FOR EACH ctd_det */

      amt_disc = tot-amt-disc.

   end. /* IF AVAILABLE ct_mstr AND ct_dating */

   else do:

      assign
         amt_disc  = 0
         disc-date = p-vo-disc-date.

      if p-vo-disc-date >= p-ap-mstr-date
      then do:
         for first ct_mstr
            fields(ct_domain ct_base_date ct_base_days ct_code ct_dating
                   ct_disc_date ct_disc_days ct_disc_pct ct_due_date
                   ct_due_days ct_due_inv ct_from_inv ct_min_days)
             where ct_domain = global_domain
               and ct_code = p-vo-cr-terms
         no-lock: end.

         if available ct_mstr
         then do:

            /* EXCLUDE NON DISCOUNATBLE AMOUNT FROM DISCOUNT   */
            /* CALCULATIONS WHEN DISOCUNT TAX AT PAYMENT SET   */
            /* TO NO FOR SINGLE DUE DATE AND MULTIPLE PAYMENTS */
            if p-vo-applied = 0
            then
               amt_disc = disc_ok * (ct_disc_pct / 100).
            else
               amt_disc = amt_open * (ct_disc_pct / 100).

            {gprunp.i "mcpl" "p" "mc-curr-rnd"
               "(input-output amt_disc,
                 input rndmthd,
                 output mc-error-number)"}
            if mc-error-number <> 0
            then
               run p_pxmsg(input mc-error-number,
                           input 2).

         end. /* IF AVAILABLE ct_mstr */

      end. /* IF p-vo-disc-date */

   end. /* IF ct_dating = no */

END PROCEDURE. /* p-calc-discount */
{&APMCMTA-P-TAG51}

PROCEDURE check_voucher_curr:

   define input  parameter l_base_curr like gl_ctrl.gl_base_curr no-undo.
   define input  parameter l_ap_curr   like ap_curr              no-undo.
   define input  parameter l_ap_date   like ap_date              no-undo.
   define output parameter l_is_emu    like mfc_logical          no-undo.

   define variable l_union_curr_code   like ap_curr              no-undo.

   /* CHECK IF THE VOUCHER CURR IS AN EMU CURRENCY */
   /* AND BASE CURRENCY IS ALSO AN EMU CURRENCY    */
   l_union_curr_code = "".
   {gprunp.i "mcpl" "p" "mc-chk-member-curr"
      "(input  l_ap_curr,
        input  l_ap_date,
        output l_union_curr_code,
        output l_is_emu)" }

   if not l_is_emu
   then do:
      {gprunp.i "mcpl" "p" "mc-chk-union-curr"
         "(input  l_ap_curr,
           input  l_ap_date,
           output l_is_emu)" }
   end. /* IF NOT l_is_emu */

   if  l_base_curr <> l_union_curr_code
   and l_is_emu
   then do:
      {gprunp.i "mcpl" "p" "mc-chk-member-curr"
         "(input  l_base_curr,
           input  l_ap_date,
           output l_union_curr_code,
           output l_is_emu)" }

      if not l_is_emu
      then do:
         {gprunp.i "mcpl" "p" "mc-chk-union-curr"
            "(input  l_base_curr,
              input  l_ap_date,
              output l_is_emu)" }
      end. /* IF NOT l_is_emu */

   end. /* IF l_base_curr <> l_union_curr_code AND l_is_emu */

END PROCEDURE. /* PROCEDURE check_voucher_curr */

PROCEDURE p_pxmsg :

   define input parameter l_msgnum   like msg_nbr no-undo.
   define input parameter l_errlevel as   integer no-undo.

   {pxmsg.i &MSGNUM=l_msgnum &ERRORLEVEL=l_errlevel}

END PROCEDURE.  /* PROCEDURE p_pxmsg */


PROCEDURE create_ckd_det:

   define input parameter p_ckd_voucher like ckd_voucher no-undo.
   define input parameter p_bk_entity   like bk_entity   no-undo.
   define input parameter p_ckd_acct    like ckd_acct    no-undo.
   define input parameter p_ckd_sub     like ckd_sub     no-undo.
   define input parameter p_ckd_cc      like ckd_cc      no-undo.
   {&APMCMTA-P-TAG95}

   /* ADDING NEW RECORD */
   run p_pxmsg(input 1,
               input 1).

   create ckd_det.
   assign
      ckd_domain  = global_domain
      ckd_ref     = ap_mstr.ap_ref
      ckd_user1   = ap_mstr.ap_rmk    /* SS - 110114.1 */
      ckd_dy_code = dft-daybook
      ckd_voucher = p_ckd_voucher.

   if recid(ckd_det) = -1
   then .

   if ckd_voucher <> ""
   then
      for first apmstr
          where apmstr.ap_domain = global_domain
            and apmstr.ap_ref    = ckd_voucher
            and apmstr.ap_type   = "VO"
      no-lock:
      end. /* FOR FIRST apmstr */

   ap_mstr.ap_entity = p_bk_entity.

   if ckd_voucher = ""
   then do:
      {&APMCMTA-P-TAG14}
      /* CREATE NON-AP PAYMENT */
      run p_pxmsg(input 1162,
                  input 1).
      assign
         ckd_acct = p_ckd_acct
         ckd_sub  = p_ckd_sub
         ckd_cc   = p_ckd_cc
         ckd_type = "N".

      {&APMCMTA-P-TAG73}
   end. /* IF ckd_voucher */
   {&APMCMTA-P-TAG15}

END PROCEDURE. /* PROCEDURE create_ckd_det */
