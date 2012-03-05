/* apvorp02.p - AP AGING REPORT FROM AP DATE                                 */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.30 $                                                         */
/*V8:ConvertMode=Report                                                      */
/* Revision: 1.0      LAST MODIFIED: 09/08/86   BY: PML                      */
/* REVISION: 6.0      LAST MODIFIED: 04/16/91   BY: MLV *D523*               */
/* REVISION: 6.0      LAST MODIFIED: 06/28/91   BY: MLV *D733*               */
/* REVISION: 6.0      LAST MODIFIED: 07/29/91   BY: bjb *D795*               */
/* REVISION: 7.0      LAST MODIFIED: 08/20/91   BY: MLV *F002*               */
/* REVISION: 7.0      LAST MODIFIED: 10/16/91   BY: MLV *F021*               */
/* REVISION: 7.0      LAST MODIFIED: 12/26/91   BY: MLV *F079*               */
/* REVISION: 7.0      LAST MODIFIED: 01/13/92   BY: MLV *F082*               */
/* REVISION: 7.0      LAST MODIFIED: 01/27/92   BY: MLV *F098*               */
/* REVISION: 7.0      LAST MODIFIED: 03/16/92   BY: TMD *F260*               */
/* REVISION: 7.3      LAST MODIFIED: 09/28/92   BY: MPP *G475*               */
/*                                   08/24/94   BY: cpp *GL39*               */
/* REVISION: 8.5      LAST MODIFIED: 12/24/95   BY: mwd *J053*               */
/*                                   04/08/96   BY: jzw *G1LD*               */
/* REVISION: 8.6      LAST MODIFIED: 10/09/97   BY: ckm *K0P2*               */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 04/17/98   BY: *J2G3* Niranjan R.       */
/* REVISION: 8.6E     LAST MODIFIED: 04/28/98   BY: *L00S* D. Sidel          */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton      */
/* REVISION: 8.6E     LAST MODIFIED: 06/24/98   BY: *L01G* R. McCarthy       */
/* REVISION: 8.6E     LAST MODIFIED: 07/07/98   BY: *L03L* Brenda Milton     */
/* REVISION: 8.6E     LAST MODIFIED: 08/21/98   BY: *L06R* Brenda Milton     */
/* REVISION: 8.6E     LAST MODIFIED: 09/08/98   BY: *L08W* Russ Witt         */
/* REVISION: 8.6E     LAST MODIFIED: 10/14/98   BY: *L0BZ* Steve Goeke       */
/* Changed ConvertMode from FullGUIReport to Report                          */
/* REVISION: 8.6E     LAST MODIFIED: 10/20/98   BY: *L0CB* Jeff Wootton      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 06/02/00   BY: *N0C9* Inna Lyubarsky    */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* REVISION: 9.1      LAST MODIFIED: 10/19/00   BY: *N0VQ* BalbeerS Rajput   */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Revision: 1.29     BY: Ed van de Gevel       DATE: 11/09/01  ECO: *N15N*  */
/* $Revision: 1.30 $       BY: Lena Lim              DATE: 06/05/02  ECO: *P07V*  */
/* $Revision: 1.30 $       BY: Bill Jiang              DATE: 01/10/06  ECO: *SS - 20060110*  */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*****************************************************************************/

/*L00S   {mfdtitle.i "2+ "} */
{mfdtitle.i "2+ "}
{cxcustom.i "APVORP02.P"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE apvorp02_p_2 "Voucher Type"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorp02_p_3 "Supplier Type"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorp02_p_5 "Summary Only"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorp02_p_8 "Column Days"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorp02_p_11 "Aging Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorp02_p_14 "Deduct Hold Amounts"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */
{&APVORP02-P-TAG1}

/* THESE ARE NEEDED FOR FULL GUI REPORTS */
{gprunpdf.i "mcpl" "p"}
{gprunpdf.i "mcui" "p" }

define variable vend like ap_vend.
define variable vend1 like ap_vend.
define variable ref like ap_ref.
define variable ref1 like ap_ref.
define variable apdate like ap_date.
define variable apdate1 like ap_date.
/* SS - 20060110 - B */
DEFINE VARIABLE acct LIKE ap_acct.
DEFINE VARIABLE acct1 LIKE ap_acct.
DEFINE VARIABLE sub LIKE ap_sub.
DEFINE VARIABLE sub1 LIKE ap_sub.
DEFINE VARIABLE cc LIKE ap_cc.
DEFINE VARIABLE cc1 LIKE ap_cc.
/* SS - 20060110 - E */
define variable name like ad_name.
define variable type like ap_type format "x(12)".
define variable age_days as integer extent 5 label {&apvorp02_p_8}.
define variable age_range as character extent 5 format "x(17)".
define variable i as integer.
define variable age_amt like ar_amt extent 5.
define variable age_period as integer.
define variable vd_recno as recid.
define variable vend_detail like mfc_logical.
define variable hold as character format "x(1)".
define variable hold_calc like mfc_logical label {&apvorp02_p_14}
   initial no.
define variable adj_amt like vo_hold_amt.
define variable summary_only like mfc_logical label {&apvorp02_p_5}
   initial no.
define variable base_amt like ap_amt.
define variable base_applied like vo_applied.
define variable base_hold_amt like vo_hold_amt.
define variable base_rpt like ap_curr.
define variable age_date like ap_date initial today
   label {&apvorp02_p_11}.
define variable curr_amt like ar_amt.
define variable entity like ap_entity.
define variable entity1 like ap_entity.
define variable votype like vo_type label {&apvorp02_p_2}.
define variable votype1 like votype.
define variable vdtype like vd_type label {&apvorp02_p_3}.
define variable vdtype1 like vdtype.

define variable exdrate like exr_rate.

define variable exdrate2 like exr_rate2.
define variable mc-rpt-curr like base_rpt no-undo.
define variable mc-dummy-fixed like po_fix_rate no-undo.

{etrpvar.i &new = "new"}
{etvar.i   &new = "new"}
{eteuro.i  }

define variable et_age_amt       like ap_amt extent 5.
define variable et_base_amt      like ap_amt.
define variable et_base_applied  like vo_applied.
define variable et_base_hold_amt like vo_hold_amt.
define variable et_curr_amt      like ap_amt.
define variable et_adj_amt       like vo_hold_amt.
define variable et_org_age_amt   like ap_amt extent 5.
define variable et_org_amt       like ap_amt.
define variable et_org_curr_amt  like ap_amt.

define variable et_diff_exist    like mfc_logical.

define variable l_label1 as character format "x(38)" no-undo.
define variable l_label2 as character format "x(38)" no-undo.

find first gl_ctrl no-lock.
form
   vend           colon 15
   vend1          label {t001.i} colon 49 skip
   vdtype         colon 15
   vdtype1        label {t001.i} colon 49 skip
   apdate         colon 15
   apdate1        label {t001.i} colon 49 skip
   /* SS - 20060110 - B */
   acct         colon 15
   acct1        label {t001.i} colon 49 skip
   sub         colon 15
   sub1        label {t001.i} colon 49 skip
   cc         colon 15
   cc1        label {t001.i} colon 49 skip
   /* SS - 20060110 - E */
   entity         colon 15
   entity1        label {t001.i} colon 49 skip
   ref            colon 15 format "x(8)"
   ref1           label {t001.i} colon 49 format "x(8)" skip
   votype         colon 15
   votype1        label {t001.i} colon 49 skip (0)
   age_date       colon 21 skip
   hold_calc      colon 21 skip
   summary_only   colon 21 skip

   base_rpt        colon 21
   et_report_curr  colon 21 skip(0)

   space(1)
   age_days[1]
   age_days[2]    label "[2]"
   age_days[3]    label "[3]" skip (0)
with frame a side-labels no-attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

repeat:

   if ref1 = hi_char then ref1 = "".
   if vend1 = hi_char then vend1 = "".
   if apdate = low_date then apdate = ?.
   if apdate1 = hi_date then apdate1 = ?.
   /* SS - 20060110 - B */
   if acct1 = hi_char then acct1 = "".
   if sub1 = hi_char then sub1 = "".
   if cc1 = hi_char then cc1 = "".
   /* SS - 20060110 - E */
   if entity1 = hi_char then entity1 = "".
   if votype1 = hi_char then votype1 = "".
   if vdtype1 = hi_char then vdtype1 = "".
   do i = 1 to 5:
      if age_days[i] = 0 then age_days[i] = (i * 30).
   end.

   update
      vend vend1
      vdtype vdtype1
      apdate apdate1
      /* SS - 20060110 - B */
      acct acct1
      sub sub1
      cc cc1
      /* SS - 20060110 - E */
      entity entity1
      ref ref1
      votype votype1
      age_date
      hold_calc
      summary_only
      base_rpt
      et_report_curr

      age_days[1 for 3]
   with frame a.

   assign et_eff_date = age_date.

   do:

      run ip-param-quoter.

      /* Validate currency */
      run ip-chk-valid-curr
         (input  base_rpt,
         output mc-error-number).

      if mc-error-number <> 0 then do:
         next-prompt base_rpt with frame a.
         undo, retry.
      end.

      /* Validate reporting currency */
      run ip-chk-valid-curr
         (input  et_report_curr,
         output mc-error-number).

      if mc-error-number = 0 then do:

         /* Default currencies if blank */
         mc-rpt-curr = if base_rpt = "" then base_curr else base_rpt.
         if et_report_curr = "" then et_report_curr = mc-rpt-curr.

         /* Prompt for exchange rate and format for output */
         run ip-ex-rate-setup
            (input  et_report_curr,
            input  mc-rpt-curr,
            input  " ",
            input  et_eff_date,
            output et_rate2,
            output et_rate1,
            output mc-exch-line1,
            output mc-exch-line2,
            output mc-error-number).

      end.  /* if mc-error-number = 0 */

      if mc-error-number <> 0 then do:
         next-prompt et_report_curr with frame a.
         undo, retry.
      end.

   end.

   /* DISPLAY THE TOTAL LABELS AS CONTINUOUS STRINGS FOR CORRECT */
   /* TRANSLATION                                                */

   if base_rpt = ""
      and et_report_curr = base_curr
      then
   assign

      l_label1 = " " + getTermLabel("BASE_CURRENCY",7) + " " +
      getTermLabelRt("SUPPLIER",15) + " " +
      getTermLabel("TOTALS",11) + ":"
      l_label2 = " " + getTermLabel("BASE_CURRENCY",7) + " " +
      getTermLabelRt("REPORT",15) + " " +
      getTermLabel("TOTALS",11) + ":".
   else
   assign
      l_label1 = " " + string(et_report_curr,"x(3)") + " " +
      getTermLabelRt("SUPPLIER",17) + " " +
      getTermLabel("TOTALS",11) + ":"
      l_label2 =  " " + string(et_report_curr,"x(3)") +  " " +
      getTermLabelRt("REPORT",17) + " " +
      getTermLabel("TOTALS",11) + ":".

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
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

   /* CREATE REPORT HEADER */
   do i = 2 to 4:

      age_range[i] = getTermLabelRt("DAYS_OVER",8)
      + string(age_days[i - 1],"->>>9").
   end.

   age_range[1] = getTermLabelRt("LESS_THAN",11) +
   string(age_days[1],"->>>9").

   form
      header
      mc-curr-label at 1 et_report_curr skip
      mc-exch-label at 1 mc-exch-line1 skip
      mc-exch-line2 at 23 skip(1)

      getTermLabel("AGING_DATE",20) + " " format "x(21)"   at 1
      age_date       skip
      space(22)
      getTermLabel("DATE",8) format "x(8)"
      getTermLabel("CREDIT_TERMS",8) format "x(8)"
      age_range[1]  /* space (5) */
      age_range[2]  /* space (1) */
      age_range[3]  /* space (1) */
      age_range[4]  skip
      getTermLabel("VOUCHER",8) format "x(8)"
      getTermLabel("INVOICE",12) format "x(12)"
      getTermLabel("EXCHANGE_RATE",8) format "x(8)"
      getTermLabel("CURRENCY",8) format "x(8)"
      getTermLabelCentered("DAYS_OLD",16) format "x(16)" space(1)
      getTermLabelCentered("DAYS_OLD",16) format "x(16)" space(1)
      getTermLabelCentered("DAYS_OLD",16) format "x(16)" space(1)
      getTermLabelCentered("DAYS_OLD",16) format "x(16)"
      getTermLabelRt("TOTAL_AMOUNT",16) format "x(16)"  skip

      "--------"
      "------------"
      "--------"
      "--------"
      "----------------"
      "----------------"
      "----------------"
      "----------------"
      "----------------" skip
   with frame phead1 width 132 page-top.
   view frame phead1.

   form
      ap_ref      format "x(8)"
      vo_invoice  format "x(12)"
      ap_date
      vo_cr_terms
      et_age_amt[1]
      et_age_amt[2]
      et_age_amt[3]
      et_age_amt[4]
      ap_amt
      hold
   with frame c width 132
      no-attr-space no-box no-labels down.

   form
      l_label1   to 38
      age_amt[1] to 56 format "->>>>,>>>,>>9.99"
      age_amt[2]       format "->>>>,>>>,>>9.99"
      age_amt[3]       format "->>>>,>>>,>>9.99"
      age_amt[4]       format "->>>>,>>>,>>9.99"
      ap_amt           format "->>>>,>>>,>>9.99"
   with frame e width 132 no-labels no-attr-space no-box down.

   {&APVORP02-P-TAG2}
   for each vd_mstr where (vd_addr >= vend)
         and (vd_addr <=vend1)
         and (vd_type >= vdtype and vd_type <= vdtype1)
      no-lock use-index vd_sort
         by vd_sort:
      vend_detail = no.
      for each ap_mstr where (ap_vend = vd_addr)
            and (ap_entity >= entity and ap_entity <= entity1)
            and (ap_ref >= ref and ap_ref <= ref1)
            and (ap_date >= apdate and ap_date <= apdate1)
            and (ap_open = yes)
            and (ap_type = "VO")
            and ((ap_curr = base_rpt)
            or base_rpt = "")
         /* SS - 20060110 - B */
         AND (ap_acct >= acct AND ap_acct <= acct1)
         AND (ap_sub >= sub AND ap_sub <= sub1)
         AND (ap_cc >= cc AND ap_cc <= cc1)
         /* SS - 20060110 - E */
         no-lock use-index ap_open,
            each vo_mstr where vo_ref = ap_ref and vo_confirmed = yes
            and (vo_type >= votype and vo_type <= votype1)
         no-lock by ap_open by ap_vend by ap_date:
         {&APVORP02-P-TAG3}

         assign
            age_amt     = 0
            et_age_amt  = 0
            vend_detail = yes.

         if (not available ad_mstr) or (ad_addr <> vd_addr) then
      do with frame b:
            name = "".
            find ad_mstr where ad_addr = ap_vend no-lock
               no-wait no-error.

            vd_recno = recid(vd_mstr).

            if available ad_mstr then name = ad_name.
            /* SET EXTERNAL LABELS */
            setFrameLabels(frame b:handle).
            display
               ap_vend no-label
               name no-label
               ad_attn
               ad_phone ad_ext no-label
            with frame b
               side-labels width 132.
         end.
         {&APVORP02-P-TAG4}

         if summary_only = no then
         display
            ap_ref      format "x(8)"
            vo_invoice  format "x(12)"
            ap_date
            vo_cr_terms
         with frame c.

         age_period = 4.
         do i = 1 to 4:
            if (age_date - age_days[i]) <= ap_date then
               age_period = i.
            if age_period <> 4 then leave.
         end.

         assign
            curr_amt = ap_amt - vo_applied
            base_amt = ap_amt
            base_applied = vo_applied
            base_hold_amt = vo_hold_amt.
         if base_rpt = ""
            and ap_curr <> base_curr then do:
            assign
               base_amt = ap_base_amt
               base_applied = vo_base_applied
               base_hold_amt = vo_base_hold_amt.

            /* GET EXCHANGE RATE */
            {gprunp.i "mcpl" "p" "mc-get-ex-rate"
               "(input ap_curr,
                 input base_curr,
                 input ap_ex_ratetype,
                 input age_date,
                 output exdrate,
                 output exdrate2,
                 output mc-error-number)"}

            if mc-error-number = 0 then do:

               /* CONVERT FROM FOREIGN TO BASE CURRENCY */
               /* CHANGED AP_EX_RATE TO EXDRATE AND     */
               /* AP_EX_RATE2 TO EXDRATE2 BELOW         */

               run ip-curr-conv
                  (input  ap_curr,
                  input  base_curr,
                  input  exdrate,
                  input  exdrate2,
                  input  curr_amt,
                  input  true, /* ROUND */
                  output curr_amt).

            end.
            /* IF NO EXCHANGE RATE FOR TODAY, */
            /* USE THE VOUCHER RATE */
            else
               do:

               /* CONVERT FROM FOREIGN TO BASE CURRENCY */

               run ip-curr-conv
                  (input  ap_curr,
                  input  base_curr,
                  input  ap_ex_rate,
                  input  ap_ex_rate2,
                  input  curr_amt,
                  input  true, /* ROUND */
                  output curr_amt).

            end.

         end. /* IF BASE_RPT = "" */

         if ap_date = ? then age_period = 1.
         if vo_hold_amt <> 0 then hold = "H".
         else hold = "".
         if hold_calc = yes then adj_amt = base_hold_amt.
         else adj_amt = 0.
         age_amt[age_period] = base_amt - base_applied - adj_amt.

         do i = 1 to 4:
            if et_report_curr <> mc-rpt-curr then do:

               run ip-curr-conv
                  (input  mc-rpt-curr,
                  input  et_report_curr,
                  input  et_rate1,
                  input  et_rate2,
                  input  age_amt[i],
                  input  true,  /* ROUND */
                  output et_age_amt[i]).

            end.  /* if et_report_curr <> mc-rpt-curr */
            else et_age_amt[i] = age_amt[i].
         end.  /* do i = 1 to 4 */
         if et_report_curr <> mc-rpt-curr then do:

            run ip-curr-conv
               (input  mc-rpt-curr,
               input  et_report_curr,
               input  et_rate1,
               input  et_rate2,
               input  curr_amt,
               input  true,  /* ROUND */
               output et_curr_amt).

            run ip-curr-conv
               (input  mc-rpt-curr,
               input  et_report_curr,
               input  et_rate1,
               input  et_rate2,
               input  base_amt,
               input  true,  /* ROUND */
               output et_base_amt).

            run ip-curr-conv
               (input  mc-rpt-curr,
               input  et_report_curr,
               input  et_rate1,
               input  et_rate2,
               input  base_applied,
               input  true,  /* ROUND */
               output et_base_applied).

            run ip-curr-conv
               (input  mc-rpt-curr,
               input  et_report_curr,
               input  et_rate1,
               input  et_rate2,
               input  adj_amt,
               input  true,  /* ROUND */
               output et_adj_amt).

         end.  /* if et_report_curr <> mc-rpt-curr */
         else
         assign
            et_curr_amt = curr_amt
            et_base_amt = base_amt
            et_base_applied = base_applied
            et_adj_amt = adj_amt.

         {&APVORP02-P-TAG5}
         accumulate curr_amt (total).
         accumulate age_amt (total).
         accumulate base_amt - base_applied - adj_amt(total).

         accumulate et_curr_amt (total).
         accumulate et_age_amt (total).
         accumulate et_base_amt - et_base_applied - et_adj_amt
            (total).

         if summary_only = no then do with frame c
               down:
            {&APVORP02-P-TAG6}
            display

               et_age_amt[1 for 4]

               (et_base_amt - et_base_applied - et_adj_amt)

               @ ap_amt
               hold
            with frame c.
            down 1 with frame c.
            if vo_curr <> base_curr then

            put (ap_ex_rate / ap_ex_rate2)
               format ">>>>>9.9<<<<<"
               at 23
               space(1)

               vo_curr skip.
         end.
         {&APVORP02-P-TAG7}
      end. /*for each ap_mstr*/
      if vend_detail then do with frame c:
         if page-size - line-counter < 4 then page.
         if summary_only = no then
         underline

            et_age_amt[1 for 4]
            ap_amt
         with frame c.

         {&APVORP02-P-TAG8}
         display
            l_label1

            accum total (et_age_amt[1]) @ age_amt[1]
            accum total (et_age_amt[2]) @ age_amt[2]
            accum total (et_age_amt[3]) @ age_amt[3]
            accum total (et_age_amt[4]) @ age_amt[4]

            accum total (et_base_amt - et_base_applied - et_adj_amt)

            @ ap_amt
         with frame e.
         {&APVORP02-P-TAG9}

      end.
      {mfrpchk.i}
   end. /* FOR EACH VD_MSTR */
   if page-size - line-counter < 4 then page.

   else down 2 with frame e.
   underline

      et_age_amt[1 for 4]
      ap_amt
   with frame c.

   {&APVORP02-P-TAG10}
   display
      l_label2                                     @ l_label1

      accum total (et_age_amt[1]) @ age_amt[1]
      accum total (et_age_amt[2]) @ age_amt[2]
      accum total (et_age_amt[3]) @ age_amt[3]
      accum total (et_age_amt[4]) @ age_amt[4]

      accum total (et_base_amt - et_base_applied - et_adj_amt)
      @ ap_amt

   with frame e.
   {&APVORP02-P-TAG11}

   /* DETERMINE ORIGINAL TOTALS, NOT YET CONVERTED */
   assign
      et_org_age_amt[1] = accum total (age_amt[1])
      et_org_age_amt[2] = accum total (age_amt[2])
      et_org_age_amt[3] = accum total (age_amt[3])
      et_org_age_amt[4] = accum total (age_amt[4])
      et_org_amt = accum total (base_amt - base_applied - adj_amt)
      et_org_curr_amt   = accum total curr_amt.

   /*CONVERT AMOUNTS*/

   do i = 1 to 4:
      if et_report_curr <> mc-rpt-curr then do:

         run ip-curr-conv
            (input  mc-rpt-curr,
            input  et_report_curr,
            input  et_rate1,
            input  et_rate2,
            input  et_org_age_amt[i],
            input  true,  /* ROUND */
            output et_org_age_amt[i]).

      end.  /* if et_report_curr <> mc-rpt-curr */
   end.  /* do i = 1 to 4 */
   if et_report_curr <> mc-rpt-curr then do:

      run ip-curr-conv
         (input  mc-rpt-curr,
         input  et_report_curr,
         input  et_rate1,
         input  et_rate2,
         input  et_org_curr_amt,
         input  true,  /* ROUND */
         output et_org_curr_amt).

      run ip-curr-conv
         (input  mc-rpt-curr,
         input  et_report_curr,
         input  et_rate1,
         input  et_rate2,
         input  et_org_amt,
         input  true,  /* ROUND */
         output et_org_amt).

   end.  /* if et_report_curr <> mc-rpt-curr */

   if et_ctrl.et_show_diff
      and (((accum total et_age_amt[1]) - et_org_age_amt[1] <> 0 )
      or   ((accum total et_age_amt[2]) - et_org_age_amt[2] <> 0 )
      or   ((accum total et_age_amt[3]) - et_org_age_amt[3] <> 0 )
      or   ((accum total et_age_amt[4]) - et_org_age_amt[4] <> 0 )
      or  ((accum total (et_base_amt - et_base_applied - et_adj_amt))
      - et_org_amt  <> 0 ))
      then do
      with frame e:
      down.
      /* DISPLAY REPORT DIFFERENCES */

      display
         (trim(substring(et_diff_txt,1,36)) + ":")
         format "x(37)" @ l_label1
         ((accum total et_age_amt[1]) - et_org_age_amt[1])

         @ age_amt[1]
         ((accum total et_age_amt[2]) - et_org_age_amt[2])

         @ age_amt[2]
         ((accum total et_age_amt[3]) - et_org_age_amt[3])

         @ age_amt[3]
         ((accum total et_age_amt[4]) - et_org_age_amt[4])

         @ age_amt[4]
         ((accum total  (et_base_amt -  et_base_applied -
         et_adj_amt)) - et_org_amt)

         @ ap_amt.
   end.
   down 2
   with frame e.

   et_diff_exist = false.

   if et_ctrl.et_show_diff and
      ((((accum total (et_base_amt - et_base_applied - et_adj_amt))
      - et_org_amt) <> 0) or
      (((accum total (et_curr_amt))
      - et_org_curr_amt) <> 0) or
      (( (((accum total (et_curr_amt))
      - (accum total (et_base_amt - et_base_applied - et_adj_amt))))
      - (et_org_curr_amt - et_org_amt)) <> 0))
      then et_diff_exist = true.

   if base_rpt = "" then
   do on endkey undo, leave:
      display
         et_diff_txt to 96  when (et_diff_exist)

         getTermLabelRt("TOTAL",10) + " " + et_report_curr + " " +
         getTermLabelRtColon("AGING",6)
         format "x(21)" to 44

         (accum total (et_base_amt - et_base_applied - et_adj_amt))
         format "->>>>>,>>>,>>9.99" at 46
         (accum total (et_base_amt - et_base_applied - et_adj_amt))
         - et_org_amt
         when (et_diff_exist)
         format "->>>>>,>>>,>>9.99" at 77

         getTermLabelRt("AGING_AT_EXCHANGE_RATES_FOR",34) + " " +
         string(age_date) + ":"
         format "x(44)" to 44

         accum total (et_curr_amt)
         format "->>>>>,>>>,>>9.99" at 46
         ((accum total (et_curr_amt))
         - et_org_curr_amt)
         when (et_diff_exist)
         format "->>>>>,>>>,>>9.99" at 77

         getTermLabelRt("VARIANCE",16) + ":" format "x(17)" to 44

         ( (accum total (et_curr_amt))
         - (accum total (et_base_amt - et_base_applied - et_adj_amt)))
         format "->>>>>,>>>,>>9.99" at 46

         ( (((accum total (et_curr_amt))
         - (accum total (et_base_amt - et_base_applied - et_adj_amt))))
         - (et_org_curr_amt - et_org_amt))
         when (et_diff_exist)
         format "->>>>>,>>>,>>9.99" at 77

      with frame d width 132 no-labels.
   end.

   /* REPORT TRAILER */
   hide frame phead1.
   {mfrtrail.i}

end. /*repeat*/

/*------------------------------------------------------------------*/

PROCEDURE ip-param-quoter:

   bcdparm = "".
   {mfquoter.i vend           }
   {mfquoter.i vend1          }
   {mfquoter.i vdtype         }
   {mfquoter.i vdtype1        }
   {mfquoter.i apdate         }
   {mfquoter.i apdate1        }
   /* SS - 20060110 - B */
   {mfquoter.i acct         }
   {mfquoter.i acct1        }
   {mfquoter.i sub         }
   {mfquoter.i sub1        }
   {mfquoter.i cc         }
   {mfquoter.i cc1        }
   /* SS - 20060110 - E */
   {mfquoter.i entity         }
   {mfquoter.i entity1        }
   {mfquoter.i ref            }
   {mfquoter.i ref1           }
   {mfquoter.i votype         }
   {mfquoter.i votype1        }
   {mfquoter.i age_date       }
   {mfquoter.i hold_calc      }
   {mfquoter.i summary_only   }
   {mfquoter.i base_rpt       }
   {mfquoter.i et_report_curr }
   {mfquoter.i age_days[1]    }
   {mfquoter.i age_days[2]    }
   {mfquoter.i age_days[3]    }

   if ref1    = "" then ref1    = hi_char.
   if vend1   = "" then vend1   = hi_char.
   if apdate  = ?  then apdate  = low_date.
   if apdate1 = ?  then apdate1 = hi_date.
   /* SS - 20060110 - B */
   if acct1 = "" then acct1 = hi_char.
   if sub1 = "" then sub1 = hi_char.
   if cc1 = "" then cc1 = hi_char.
   /* SS - 20060110 - E */
   if entity1 = "" then entity1 = hi_char.
   if votype1 = "" then votype1 = hi_char.
   if vdtype1 = "" then vdtype1 = hi_char.

END PROCEDURE.  /* ip-param-quoter */

/*------------------------------------------------------------------*/

PROCEDURE ip-chk-valid-curr:

   define input  parameter i_curr  as character no-undo.
   define output parameter o_error as integer   no-undo initial 0.

   if i_curr <> "" then do:

      {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
         "(input  i_curr,
           output o_error)" }

      if o_error <> 0 then do:
         {pxmsg.i &MSGNUM=o_error &ERRORLEVEL=3}
      end.

   end.  /* if i_curr */

END PROCEDURE.  /* ip-chk-valid-curr */

/*------------------------------------------------------------------*/

PROCEDURE ip-ex-rate-setup:

   define input  parameter i_curr1      as character no-undo.
   define input  parameter i_curr2      as character no-undo.
   define input  parameter i_type       as character no-undo.
   define input  parameter i_date       as date      no-undo.

   define output parameter o_rate       as decimal   no-undo initial 1.
   define output parameter o_rate2      as decimal   no-undo initial 1.
   define output parameter o_disp_line1 as character no-undo
      initial "".
   define output parameter o_disp_line2 as character no-undo
      initial "".
   define output parameter o_error      as integer   no-undo initial 0.

   define variable v_seq                as integer   no-undo.
   define variable v_fix_rate           as logical no-undo.

   do transaction:

      /* Get exchange rate and create usage records */
      {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
         "(input  i_curr1,
           input  i_curr2,
           input  i_type,
           input  i_date,
           output o_rate,
           output o_rate2,
           output v_seq,
           output o_error)" }

      if o_error = 0 then do:

         /* Prompt user to edit exchange rate */
         {gprunp.i "mcui" "p" "mc-ex-rate-input"
            "(input        i_curr1,
              input        i_curr2,
              input        i_date,
              input        v_seq,
              input        false,
              input        5,
              input-output o_rate,
              input-output o_rate2,
              input-output v_fix_rate)" }

         /* Format exchange rate for output */
         {gprunp.i "mcui" "p" "mc-ex-rate-output"
            "(input  i_curr1,
              input  i_curr2,
              input  o_rate,
              input  o_rate2,
              input  v_seq,
              output o_disp_line1,
              output o_disp_line2)" }

         /* Delete usage records */
         {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
            "(input v_seq)" }

      end.  /* if o_error */

      else do:
         {pxmsg.i &MSGNUM=o_error &ERRORLEVEL=3}
      end.

   end.  /* do transaction */

END PROCEDURE.  /* ip-ex-rate-setup */

/*------------------------------------------------------------------*/

PROCEDURE ip-curr-conv:

   define input  parameter i_src_curr  as character no-undo.
   define input  parameter i_targ_curr as character no-undo.
   define input  parameter i_src_rate  as decimal   no-undo.
   define input  parameter i_targ_rate as decimal   no-undo.
   define input  parameter i_src_amt   as decimal   no-undo.
   define input  parameter i_round     as logical   no-undo.
   define output parameter o_targ_amt  as decimal   no-undo.

   define variable mc-error-number as integer no-undo.

   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input  i_src_curr,
        input  i_targ_curr,
        input  i_src_rate,
        input  i_targ_rate,
        input  i_src_amt,
        input  i_round,
        output o_targ_amt,
        output mc-error-number)" }

   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.

END PROCEDURE.  /* ip-curr-conv */

/*------------------------------------------------------------------*/
{&APVORP02-P-TAG12}
