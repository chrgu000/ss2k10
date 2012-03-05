/* apvorp01.p - AP AGING REPORT FROM DUE DATE                                */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.31 $                                                         */
/*V8:ConvertMode=Report                                                      */
/* Revision: 1.0      LAST MODIFIED: 09/08/86   BY: PML                      */
/* REVISION: 6.0      LAST MODIFIED: 04/16/91   BY: MLV *D523*               */
/* REVISION: 6.0      LAST MODIFIED: 06/28/91   BY: MLV *D733*               */
/* REVISION: 7.0      LAST MODIFIED: 08/20/91   BY: MLV *F002*               */
/* REVISION: 7.0      LAST MODIFIED: 10/16/91   BY: mlv *F021*               */
/* REVISION: 6.0      LAST MODIFIED: 12/12/91   BY: MLV *D964*               */
/* REVISION: 7.0      LAST MODIFIED: 01/13/92   BY: MLV *F082*               */
/* REVISION: 7.0      LAST MODIFIED: 01/27/92   BY: MLV *F098                */
/* REVISION: 7.0      LAST MODIFIED: 03/06/92   BY: mlv *F257*               */
/* REVISION: 7.0      LAST MODIFIED: 03/16/92   BY: TMD *F260*               */
/* REVISION: 7.3      LAST MODIFIED: 09/03/92   BY: afs *G045*               */
/* REVISION: 7.3      LAST MODIFIED: 09/28/92   BY: mpp *G475*               */
/*           7.3                     06/18/93   BY: skk *GC48** votype1      */
/*           7.3                     06/18/93   BY: srk *GI07*               */
/*           7.3                     08/24/94   BY: cpp *GL39*               */
/* REVISION: 8.5      LAST MODIFIED: 12/24/95   by: mwd *J053*               */
/*                                   04/08/96   by: jzw *G1LD*               */
/* REVISION: 8.6      LAST MODIFIED: 10/09/97   by: ckm *K0P1*               */
/* REVISION: 8.6      LAST MODIFIED: 01/06/98   BY: *J295* Irine D'mello     */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 04/17/98   BY: *J2G3* Niranjan R.       */
/* REVISION: 8.6E     LAST MODIFIED: 04/27/98   BY: *L00S* D. Sidel          */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton      */
/* REVISION: 8.6E     LAST MODIFIED: 06/24/98   BY: *L01G* R. McCarthy       */
/* REVISION: 8.6E     LAST MODIFIED: 07/07/98   BY: *L03L* Brenda Milton     */
/* REVISION: 8.6E     LAST MODIFIED: 09/08/98   BY: *L08W* Russ Witt         */
/* REVISION: 8.6E     LAST MODIFIED: 10/14/98   BY: *L0BZ* Steve Goeke       */
/* Changed ConvertMode from FullGUIReport to Report                          */
/* REVISION: 8.6E     LAST MODIFIED: 10/20/98   BY: *L0CB* Jeff Wootton      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 06/01/00   BY: *N0C9* Inna Lyubarsky    */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* REVISION: 9.1      LAST MODIFIED: 10/20/00   BY: *N0VQ* Mudit Mehta       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Revision: 1.30     BY: Ed van de Gevel       DATE: 11/09/01  ECO: *N15N*  */
/* $Revision: 1.31 $       BY: Lena Lim              DATE: 06/05/02  ECO: *P07V*  */
/* $Revision: 1.31 $       BY: Bill Jiang              DATE: 01/06/06  ECO: *SS - 20060106*  */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*****************************************************************************/

/* SS - 20060106 - B */
{a6apvorp0102.i "new"}
/* SS - 20060106 - E */

/*L00S   {mfdtitle.i "2+ "} */
{mfdtitle.i "2+ "}
{cxcustom.i "APVORP01.P"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE apvorp01_p_9 "Deduct Hold Amounts"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorp01_p_11 "Aging Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorp01_p_17 "Column Days"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorp01_p_22 "Summary Only"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorp01_p_26 "Supplier Type"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorp01_p_28 "Voucher Type"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/* THESE ARE NEEDED FOR FULL GUI REPORTS */
{gprunpdf.i "mcpl" "p"}
{gprunpdf.i "mcui" "p" }

define variable vend like ap_vend.
define variable vend1 like ap_vend.
define variable ref like ap_ref.
define variable ref1 like ap_ref.
define variable due_date like vo_due_date.
define variable due_date1 like vo_due_date.
define variable name like ad_name.
define variable type like ap_type format "X(12)".
define variable age_days as integer extent 4 label {&apvorp01_p_17}.
define variable age_range as character extent 5 format "x(17)".
define variable i as integer.
define variable age_amt like ap_amt extent 4.
define variable age_period as integer.
define variable vd_recno as recid.
define variable vend_detail like mfc_logical.
define variable hold as character format "x(1)".
define variable hold_calc like mfc_logical label {&apvorp01_p_9}
   initial no.
define variable adj_amt like vo_hold_amt.
define variable summary_only like mfc_logical label {&apvorp01_p_22}
   initial no.
define variable base_amt like ap_amt.
define variable base_applied like vo_applied.
define variable base_hold_amt like vo_hold_amt.
define variable base_rpt like ap_curr.
define variable age_date like ap_date initial today.
define variable due-date like ap_date.
define variable applied-amt like vo_applied.
define variable amt-due like ap_amt.
define variable tot-amt like ap_amt.
define variable vo-tot like ap_amt.
define variable multi-due like mfc_logical.
define variable curr_amt like ar_amt.
define variable entity like ap_entity.
define variable entity1 like ap_entity.
define variable votype like vo_type label {&apvorp01_p_28}.
define variable votype1 like votype.
define variable vdtype like vd_type label {&apvorp01_p_26}.
define variable vdtype1 like vdtype.
find first gl_ctrl no-lock.

define variable exdrate like exr_rate.

define variable exdrate2 like exr_rate2.
define variable mc-rpt-curr like base_rpt no-undo.
define variable mc-dummy-fixed like po_fix_rate no-undo.
{&APVORP01-P-TAG1}

{etrpvar.i &new = "new"}
{etvar.i   &new = "new"}
{eteuro.i  }

define variable et_age_amt       like ap_amt extent 4.

/* CHANGED et_vo-tot TO et_vo_tot THROUGHOUT THIS PROGRAM */
define variable et_vo_tot        like ap_amt.
define variable et_base_amt      like ap_amt.
define variable et_base_applied  like vo_applied.
define variable et_base_hold_amt like vo_hold_amt.
define variable et_curr_amt      like ap_amt.
define variable et_adj_amt       like vo_hold_amt.
define variable et_org_age_amt   like ap_amt extent 4.

/* CHANGED et_org_vo-tot TO et_org_vo_tot THROUGHOUT THIS PROGRAM */
define variable et_org_vo_tot    like ap_amt.
define variable et_org_curr_amt  like ap_amt.

define variable et_diff_exist    like mfc_logical.

define variable l_label1      as character format "x(37)" no-undo.
define variable l_label2      as character format "x(36)" no-undo.
define variable base_supp_tot as character format "x(37)" no-undo.
define variable base_rpt_tot  as character format "x(36)" no-undo.
define variable supp_tot      as character format "x(29)" no-undo.
define variable rpt_tot       as character format "x(27)" no-undo.

assign
   base_supp_tot = getTermLabelRt("BASE_CURRENCY",7) + " " +
   getTermLabel("SUPPLIER",14) + " " +
   getTermLabel("TOTALS",12) + ":"
   base_rpt_tot  = getTermLabelRt("BASE_CURRENCY",7) + " " +
   getTermLabel("REPORT",12) + " " +
   getTermLabel("TOTALS",12) + ":"
   supp_tot      = " " + getTermLabelRt("SUPPLIER",14) + " " +
   getTermLabel("TOTALS",12) + ":"
   rpt_tot       = " " + getTermLabelRt("REPORT",12) + " " +
   getTermLabel("TOTALS",12) + ":".

form
   vend           colon 15
   vend1          label {t001.i} colon 49 skip
   vdtype         colon 15
   vdtype1        label {t001.i} colon 49 skip
   due_date       colon 15
   due_date1      label {t001.i} colon 49 skip
   entity         colon 15
   entity1        label {t001.i} colon 49 skip
   ref            colon 15 format "x(8)"
   ref1           label {t001.i} colon 49 format "x(8)" skip
   votype         colon 15
   votype1        label {t001.i} colon 49 skip (1)
   age_date       colon 24 label {&apvorp01_p_11}
   hold_calc      colon 24 skip
   summary_only   colon 24 skip

   base_rpt       colon 24
   et_report_curr colon 24 skip(1)

   space(1)
   age_days [1]
   age_days [2]            label "[2]"
   age_days [3]            label "[3]"
   skip (1)
with frame a side-labels no-attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

repeat:

   {&APVORP01-P-TAG2}
   if ref1 = hi_char then ref1 = "".
   if vend1 = hi_char then vend1 = "".
   if vdtype1 = hi_char then vdtype1 = "".
   if due_date = low_date then due_date = ?.
   if due_date1 = hi_date then due_date1 = ?.
   if entity1 = hi_char then entity1 = "".

   do i = 1 to 3:
      if age_days[i] = 0 then age_days[i] = ((i - 1) * 30).
   end.
   {&APVORP01-P-TAG3}

   update
      vend vend1
      vdtype vdtype1
      due_date due_date1
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

   et_eff_date = age_date.

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

      l_label1 = base_supp_tot
      l_label2 = base_rpt_tot.
   else
   assign
      l_label1 = string(et_report_curr,"x(3)") + supp_tot
      l_label2 = string(et_report_curr,"x(3)") + rpt_tot.

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
   /* SS - 20060106 - B */            
   /*
   {mfphead.i}
   */
   /* SS - 20060106 - E */

   /* SS - 20060106 - B */
   /*
   /* CREATE REPORT HEADER */
   do i = 1 to 3:

      age_range[i] = getTermLabelRt("TO",3)
      + string(age_days[i],"->>>9")

         + " " + getTermLabel("DAYS",4).
   end.

   age_range[4] = getTermLabel("OVER",4)
   + string(age_days[3],"->>>9")

      + " " + getTermLabel("DAYS",4).

   form
      header
      mc-curr-label at 1 et_report_curr skip
      mc-exch-label at 1 mc-exch-line1 skip
      mc-exch-line2 at 23 skip(1)

      getTermLabel("AGING_DATE",20) + " " format "x(21)" at 1
      age_date       skip space (22)
      getTermLabel("DUE_DATE",8) format "x(8)"
      getTermLabel("CREDIT_TERMS",8) format "x(8)"
      age_range[1 for 4] skip
      getTermLabel("VOUCHER",8) format "x(8)"
      getTermLabel("INVOICE",12) format "x(12)"
      getTermLabel("EXCHANGE_RATE",8) format "x(8)"
      getTermLabel("CURRENCY",8) format "x(8)" space(1)
      getTermLabelCentered("PAST_DUE",16) format "x(16)" space(1)
      getTermLabelCentered("PAST_DUE",16) format "x(16)" space(1)
      getTermLabelCentered("PAST_DUE",16) format "x(16)" space(1)
      getTermLabelCentered("PAST_DUE",16) format "x(16)"
      getTermLabelRt("TOTAL_AMOUNT",15) format "x(15)" skip

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

   form with frame c width 132 no-labels no-attr-space no-box down.

   form
      l_label1   to 38
      age_amt[1] to 56 format "->>>>,>>>,>>9.99"
      age_amt[2]       format "->>>>,>>>,>>9.99"
      age_amt[3]       format "->>>>,>>>,>>9.99"
      age_amt[4]       format "->>>>,>>>,>>9.99"
      vo-tot           format "->>>>,>>>,>>9.99"
   with frame e width 132 no-labels no-attr-space no-box down.

   for each vd_mstr where (vd_addr >= vend)
         and (vd_addr <= vend1)
         and (vd_type >= vdtype and vd_type <= vdtype1)
      no-lock
         use-index vd_sort
         by vd_sort:
      vend_detail = no.
      {&APVORP01-P-TAG4}
      for each ap_mstr where (ap_vend = vd_addr)
            and (ap_entity >= entity and ap_entity <= entity1)
            and (ap_ref >= ref and ap_ref <= ref1)
            and (ap_type = "VO")
            and (ap_open = yes)
            and ((ap_curr = base_rpt)
            or  (base_rpt = ""))
         no-lock use-index ap_open,
            each vo_mstr where vo_ref = ap_ref and vo_confirmed = yes
            and (vo_type >= votype and vo_type <= votype1)
            and ((vo_due_date >= due_date and vo_due_date <= due_date1)
            or vo_due_date = ?) no-lock
            by ap_open by ap_vend by ap_ref with frame c:

         assign
            age_amt     = 0
            et_age_amt  = 0
            vend_detail = yes.
         {&APVORP01-P-TAG5}

         if not available ad_mstr or ad_addr <> vd_addr then
      do with frame b:
            /* SET EXTERNAL LABELS */
            setFrameLabels(frame b:handle).

            find ad_mstr where ad_addr = ap_vend no-lock no-wait
               no-error.
            name = if available ad_mstr then ad_name else "".
            vd_recno = recid(vd_mstr).

            if page-size - line-counter < 4 then page.
            display
               ap_vend no-label
               name no-label
               ad_attn
               ad_phone ad_ext no-label
            with frame b side-labels width 132.
         end.
         {&APVORP01-P-TAG6}

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

               run ip-curr-conv
                  (input  ap_curr,
                  input  base_curr,
                  input  exdrate,
                  input  exdrate2,
                  input  curr_amt,
                  input  true, /* ROUND */
                  output curr_amt).

            end.
            /* IF NO EXCHANGE RATE FOR TODAY, USE THE VOUCHER RATE */
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

         end.  /* if base_rpt = "" and ap_curr <> base_curr */

         multi-due = no.
         find ct_mstr where ct_code = vo_cr_terms no-lock no-error.
         if available ct_mstr and ct_dating then do:
            assign
               multi-due = yes
               tot-amt = 0
               vo-tot = 0
               applied-amt = base_applied.
            for each ctd_det where ctd_code = vo_cr_terms no-lock
                  break by ctd_code:
               find ct_mstr where ct_code = ctd_date_cd no-lock
                  no-error.
               if available ct_mstr then do:

                  {&APVORP01-P-TAG7}
                  assign
                     due-date =
                     if ct_due_date <> ?
                     then ct_due_date
                     else
                  if ct_from_inv = 1
                     then ap_date + ct_due_days
                     else
                     date((month(ap_date) + 1) modulo 12 +
                     if month(ap_date) = 11
                     then 12 else 0,
                     1,
                     year(ap_date) +
                     if month(ap_date) >= 12
                     then 1 else 0) +
                     integer(ct_due_days) -
                     if ct_due_days <> 0 then 1 else 0

                     /* Calculate the amt-due less the applied */

                     amt-due =
                     if last-of(ctd_code)
                     then base_amt - tot-amt
                     else base_amt * (ctd_pct_due / 100).
                  {&APVORP01-P-TAG8}

                  {gprunp.i "mcpl" "p" "mc-curr-rnd"
                     "(input-output amt-due,
                       input gl_rnd_mthd,
                       output mc-error-number)"}
                  if mc-error-number <> 0 then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                  end.

                  if applied-amt >= amt-due then do:
                     assign
                        applied-amt = applied-amt - amt-due
                        tot-amt = tot-amt + amt-due.
                     next. /*THIS SEGMENT IS CLOSED*/
                  end.
                  else do:
                     assign
                        tot-amt = tot-amt + amt-due
                        amt-due = amt-due - applied-amt
                        applied-amt = 0.
                  end.
                  if hold_calc = yes then do:
                     if (ap_amt - (tot-amt - amt-due )) <= vo_hold_amt
                        then adj_amt = amt-due.
                     else
                     adj_amt = max(vo_hold_amt -
                        (ap_amt - tot-amt),0).
                  end.
                  else adj_amt = 0.
                  age_period = 4.
                  do i = 1 to 4:
                     if (age_date - age_days[i]) <= due-date then
                        age_period = i.
                     if age_period <> 4 then leave.
                  end.
                  assign
                     age_amt[age_period] = age_amt[age_period] +
                     (amt-due - adj_amt)
                     vo-tot = vo-tot + (amt-due - adj_amt).
                  if tot-amt >= ap_amt then leave.
                  /* Multi disc date, 1 due */
               end. /*if avail ct_mstr*/
            end. /*for each ctd_det*/
         end. /*if available ct_mstr &  ct_dating = yes*/
         else do:
            age_period = 4.
            do i = 1 to 4:
               if (age_date - age_days[i]) <= vo_due_date then
                  age_period = i.
               if age_period <> 4 then leave.
            end.
            if vo_due_date = ? then age_period = 1.
            if hold_calc = yes then adj_amt = base_hold_amt.
            else adj_amt = 0.
            assign
               age_amt[age_period] = base_amt - base_applied - adj_amt
               vo-tot = base_amt - base_applied - adj_amt.
         end.
         if vo_hold_amt <> 0 then hold = "H".
         else hold = "".

         if summary_only = no then do:
            display
               ap_ref      format "x(8)"
               vo_invoice  format "x(12)"
            with frame c.

            if multi-due = no then
            display
               vo_due_date with frame c.

            else display getTermLabel("MULTIPLE",8) @ vo_due_date with frame c.
            display vo_cr_terms with frame c.
         end.

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
               input  vo-tot,
               input  true,  /* ROUND */
               output et_vo_tot).

         end.  /* if et_report_curr <> mc-rpt-curr */
         else
         assign
            et_curr_amt = curr_amt
            et_vo_tot = vo-tot.

         {&APVORP01-P-TAG9}
         accumulate et_curr_amt (total).
         accumulate et_age_amt (total).
         accumulate et_vo_tot (total).

         accumulate age_amt(total).
         accumulate
            vo-tot(total).
         accumulate curr_amt (total).
         {&APVORP01-P-TAG10}
         if summary_only = no then do:

            display et_age_amt[1 for 4] et_vo_tot

               hold with frame c.
            down 1 with frame c.
            if base_curr <> ap_curr then

            put (ap_ex_rate / ap_ex_rate2)
               format ">>>>>9.9<<<<<"
               at 23
               space(1) ap_curr skip.
         end.
      end. /*for each ap_mstr, each vo_mstr*/
      {&APVORP01-P-TAG11}
      if vend_detail then do:
         if page-size - line-counter < 4 then page.
         if summary_only = no then
         underline

            et_age_amt et_vo_tot with frame c.

         display
            l_label1

            {&APVORP01-P-TAG12}
            accum total (et_age_amt[1]) @ age_amt[1]
            accum total (et_age_amt[2]) @ age_amt[2]
            accum total (et_age_amt[3]) @ age_amt[3]
            accum total (et_age_amt[4]) @ age_amt[4]
            accum total (et_vo_tot)     @ vo-tot

         with frame e.

         down 1
         with frame e.
         {&APVORP01-P-TAG13}
      end.
      {mfrpchk.i}
   end.
   if page-size - line-counter < 4 then page.

   down 1 with frame e.

   display
      l_label2 @ l_label1

      {&APVORP01-P-TAG14}

      accum total (et_age_amt[1]) @ age_amt[1]
      accum total (et_age_amt[2]) @ age_amt[2]
      accum total (et_age_amt[3]) @ age_amt[3]
      accum total (et_age_amt[4]) @ age_amt[4]

      accum total (et_vo_tot)     @ vo-tot

   with frame e.

   down with frame e.
   {&APVORP01-P-TAG15}

   /*DETERMINE ORIGINAL TOTALS, NOT YET CONVERTED*/
   assign
      et_org_age_amt[1] = accum total (age_amt[1])
      et_org_age_amt[2] = accum total (age_amt[2])
      et_org_age_amt[3] = accum total (age_amt[3])
      et_org_age_amt[4] = accum total (age_amt[4])
      et_org_vo_tot     = accum total (vo-tot)
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
         input  et_org_vo_tot,
         input  true,  /* ROUND */
         output et_org_vo_tot).

   end.  /* if et_report_curr <> mc-rpt-curr */

   /* DISPLAY CONVERTED REPORT AMOUNTS */

   if et_ctrl.et_show_diff and
      (
      ((accum total et_age_amt[1]) - et_org_age_amt[1] <> 0 ) or
      ((accum total et_age_amt[2]) - et_org_age_amt[2] <> 0 ) or
      ((accum total et_age_amt[3]) - et_org_age_amt[3] <> 0 ) or
      ((accum total et_age_amt[4]) - et_org_age_amt[4] <> 0 ) or
      ((accum total et_vo_tot)     - et_org_vo_tot     <> 0 )
      )
   then do:

      /* DISPLAY REPORT DIFFRENCCES */

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
         ((accum total (et_vo_tot)) - et_org_vo_tot)
         @ vo-tot
      with frame e.

   end. /* CONVERTED AMOUNTS DON'T MATCH */

   et_diff_exist = false.

   if et_ctrl.et_show_diff and
      (
      (((accum total (et_vo_tot))  - et_org_vo_tot)    <> 0) or
      (((accum total (et_curr_amt)) - et_org_curr_amt) <> 0) or
      (((((accum total (et_curr_amt)) - et_org_curr_amt)) -
      (((accum total (et_vo_tot)) - et_org_vo_tot))) <> 0)
      )
      then et_diff_exist = true.

   if base_rpt = "" then
   do on endkey undo, leave:
      display
         et_diff_txt to 96 when (et_diff_exist)

         getTermLabelRt("TOTAL",10) + " " + et_report_curr + " " +
         getTermLabelRt("AGING",5) + ":"

         format "x(21)" to 34

         (accum total (et_vo_tot)) format "->>>>>,>>>,>>9.99" at 36

         ((accum total (et_vo_tot))
         - et_org_vo_tot) when (et_diff_exist)
         format "->>>>>,>>>,>>9.99" at 77

         getTermLabelRt("AGING_AT",8) + " " + string(age_date) + " " +
         getTermLabelRt("EXCHANGE_RATE",13) + ":"
         format "x(32)" to 34

         accum total (et_curr_amt) format "->>>>>,>>>,>>9.99" at 36

         ((accum total (et_curr_amt))
         - et_org_curr_amt) when (et_diff_exist)
         format "->>>>>,>>>,>>9.99" at 77

         getTermLabelRt("COST_VARIANCE_OF",14) + " "
         + string(age_date)

         + " " + getTermLabel("TO",2)
         + " " + getTermLabelRt("BASE_CURRENCY",4) + ":"

         format "x(32)" to 34

         (accum total (et_curr_amt)) -
         (accum total (et_vo_tot)) format "->>>>>,>>>,>>9.99" at 36

         ((((accum total (et_curr_amt))
         - et_org_curr_amt)) -
         (((accum total (et_vo_tot))
         - et_org_vo_tot))) when (et_diff_exist)
         format "->>>>>,>>>,>>9.99" at 77

      with frame d width 132 no-labels.

   end. /* IF BASE-RPT = "" */

   /* REPORT TRAILER */
   hide frame phead1.
   {mfrtrail.i}
   */
   PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.

    FOR EACH tta6apvorp0102:
        DELETE tta6apvorp0102.
    END.
    {gprun.i ""a6apvorp0102.p"" "(
        INPUT vend,
        INPUT vend1,
        INPUT vdtype,
        INPUT vdtype1,
        INPUT due_date,
        INPUT due_date1,
        INPUT entity,
        INPUT entity1,
        INPUT ref,  
        INPUT ref1,
        INPUT votype,
        INPUT votype1,
        INPUT age_date,
        INPUT hold_calc,
        INPUT SUMMARY_only,
        INPUT base_rpt,
        INPUT et_report_curr,
        INPUT age_days[1],
        INPUT age_days[2],
        INPUT age_days[3]
        )"}
    EXPORT DELIMITER ";" "ap_vend" "name" "ad_attn" "ad_phone" "ad_ext" "ap_ref" "vo_invoice" "vo_cr_terms" "vo_due_date" "et_age_amt1" "et_age_amt2" "et_age_amt3" "et_age_amt4" "et_vo_tot" "hold" "ap_ex_rate" "ap_ex_rate2" "ap_curr" "ap_acct" "ap_sub" "ap_cc" "ap_disc_acct" "ap_disc_acct" "ap_disc_cc".
    FOR EACH tta6apvorp0102:
        EXPORT DELIMITER ";" tta6apvorp0102.
    END.

    PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.

    {a6mfrtrail.i}
   /* SS - 20060106 - E */

end. /* REPEAT */

PROCEDURE ip-param-quoter:

   bcdparm = "".
   {mfquoter.i vend           }
   {mfquoter.i vend1          }
   {mfquoter.i vdtype         }
   {mfquoter.i vdtype1        }
   {mfquoter.i due_date       }
   {mfquoter.i due_date1      }
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

   if ref1      = "" then ref1      = hi_char.
   if vend1     = "" then vend1     = hi_char.
   if vdtype1   = "" then vdtype1   = hi_char.
   if votype1   = "" then votype1   = hi_char.
   if due_date  = ?  then due_date  = low_date.
   if due_date1 = ?  then due_date1 = hi_date.
   if entity1   = "" then entity1   = hi_char.

END PROCEDURE.  /* ip-param-quoter */

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
{&APVORP01-P-TAG16}
