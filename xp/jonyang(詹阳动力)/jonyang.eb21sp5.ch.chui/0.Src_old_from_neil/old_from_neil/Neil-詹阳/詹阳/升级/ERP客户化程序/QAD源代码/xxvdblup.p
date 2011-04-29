/* GUI CONVERTED from apvorp01.p (converter v1.71) Thu Oct 15 10:01:25 1998 */
/* apvorp01.p - AP AGING REPORT FROM DUE DATE                                */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.      */
/* REVISION: 8.6E     LAST MODIFIED: 10/14/98   BY: *L0BZ* Steve Goeke       */

/*****************************************************************************/

/*L0BZ*/ /* Changed ConvertMode from FullGUIReport to Report                 */

/*L00S   {mfdtitle.i "e+ "} */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*L00S*/ {mfdtitle.i "e+ "}

         /* ********** Begin Translatable Strings Definitions ********* */

         &SCOPED-DEFINE apvorp01_p_1 "    报表"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp01_p_2 "超过"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp01_p_3 "兑换率  "
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp01_p_4 "  天"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp01_p_5 "多个"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp01_p_6 "货币"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp01_p_7 "-相对于基本货币:"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp01_p_8 "帐龄日期   "
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp01_p_9 "扣除暂留金额"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp01_p_10 " 至"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp01_p_11 "帐龄日期"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp01_p_12 "支付方式"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp01_p_13 " 兑换率的合计:"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp01_p_14 "帐龄日为 "
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp01_p_15 "到期日期"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp01_p_16 "       合计金额"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp01_p_17 "栏目天数"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp01_p_18 "过期"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp01_p_19 "        基本"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp01_p_20 "发票        "
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp01_p_21 "凭证    "
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp01_p_22 "只打印汇总"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp01_p_23 "  合计:"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp01_p_24 "差异-"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp01_p_25 "供应商"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp01_p_26 "供应商类型"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp01_p_27 "以基本货币计算的帐龄金额合计:"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp01_p_28 "凭证类型"
         /* MaxLen: Comment: */

/*J2G3*/ /* HARDCODED LABEL  "Base Supplier Totals:" HAS BEEN REPLACED */
         &SCOPED-DEFINE apvorp01_p_29 "基本        供应商合计:"
         /* MaxLen: 21 Comment: NO BLANK CHARACTERS SHOULD BE CONVERTED AND TRIMED */

/*J2G3*/ /* HARDCODED LABEL  "Base   Report Totals:" HAS BEEN REPLACED */
         &SCOPED-DEFINE apvorp01_p_30 "基本        报表合计:"
         /* MaxLen: 21 Comment: NO BLANK CHARACTERS SHOULD BE CONVERTED AND TRIMED */

/*J2G3*/ /* HARDCODED LABEL  "  Supplier Totals:" HAS BEEN REPLACED */
         &SCOPED-DEFINE apvorp01_p_31 "  供应商合计:"
         /* MaxLen: 18 Comment: NO BLANK CHARACTERS SHOULD BE CONVERTED AND TRIMED */

/*J2G3*/ /* HARDCODED LABEL  "    Report Totals:" HAS BEEN REPLACED */
         &SCOPED-DEFINE apvorp01_p_32 "    报表合计:"
         /* MaxLen: 18 Comment: NO BLANK CHARACTERS SHOULD BE CONVERTED AND TRIMED */

/*L03L*/ &SCOPED-DEFINE apvorp01_p_33 " 合计 "
         /* MaxLen: Comment: */

/*L03L*/ &SCOPED-DEFINE apvorp01_p_34 " 帐龄:"
         /* MaxLen: Comment: */

         /* ********** End Translatable Strings Definitions ********* */

/*L03L*/ /* THESE ARE NEEDED FOR FULL GUI REPORTS */
/*L03L*/ {gprunpdf.i "mcpl" "p"}
/*L03L*/ {gprunpdf.i "mcui" "p" }

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
            initial yes.
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
/*L03L*  define variable exdrate like exd_rate. */
/*L03L*/ define variable exdrate like exr_rate.
/*L03L*  /*L00Y*/ define variable exdrate2 like exd_rate. */
/*L03L*/ define variable exdrate2 like exr_rate2.
/*L03L*/ define variable mc-rpt-curr like base_rpt no-undo.
/*L03L*/ define variable mc-dummy-fixed like po_fix_rate no-undo.

/*L00S*  BEGIN ADDED SECTION*/
         {etrpvar.i &new = "new"}
         {etvar.i   &new = "new"}
         {eteuro.i  }
/*L03L*  define variable et_select_curr   like ex_curr. */
         define variable et_age_amt       like ap_amt extent 4.
/*L03L*  define variable et_vo-tot        like ap_amt. */
/*L03L*/ /* CHANGED et_vo-tot TO et_vo_tot THROUGHOUT THIS PROGRAM */
/*L03L*/ define variable et_vo_tot        like ap_amt.
         define variable et_base_amt      like ap_amt.
         define variable et_base_applied  like vo_applied.
         define variable et_base_hold_amt like vo_hold_amt.
         define variable et_curr_amt      like ap_amt.
         define variable et_adj_amt       like vo_hold_amt.
         define variable et_org_age_amt   like ap_amt extent 4.
/*L03L*  define variable et_org_vo-tot    like ap_amt. */
/*L03L*/ /* CHANGED et_org_vo-tot TO et_org_vo_tot THROUGHOUT THIS PROGRAM */
/*L03L*/ define variable et_org_vo_tot    like ap_amt.
         define variable et_org_curr_amt  like ap_amt.
/*L03L*  define variable input_curr       like ex_curr. */
         define variable et_diff_exist    like mfc_logical.
/*L00S*  END ADDED SECTION*/

/*J2G3*/ define variable l_label1 as character format "x(21)" no-undo.
/*J2G3*/ define variable l_label2 as character format "x(21)" no-undo.

/*jy000*/ define variable vdbal like ap_amt  format "->>>>>,>>>,>>9.999"  label {&apvorp01_p_16}.

         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
vend           colon 15
            vend1          label {t001.i} colon 49 skip
            vdtype         colon 15
            vdtype1        label {t001.i} colon 49 skip
            due_date       colon 15
            due_date1      label {t001.i} colon 49 skip
            entity         colon 15
            entity1        label {t001.i} colon 49 skip
            ref            colon 15
            ref1           label {t001.i} colon 49 skip
            votype         colon 15
            votype1        label {t001.i} colon 49 skip (1)
            age_date       colon 24 label {&apvorp01_p_11}
            hold_calc      colon 24 skip
            summary_only   colon 24 skip
/*L00S*/    base_rpt       colon 24
/*L03L*/    et_report_curr colon 24 skip(1)
            space(1)
            age_days [1]
            age_days [2]            label "[2]"
            age_days [3]            label "[3]"
            skip (1)
         with frame a side-labels no-attr-space width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/*L03L*  {wbrp01.i} */
         repeat:

            if ref1 = hi_char then ref1 = "".
            if vend1 = hi_char then vend1 = "".
            if vdtype1 = hi_char then vdtype1 = "".
            if due_date = low_date then due_date = ?.
            if due_date1 = hi_date then due_date1 = ?.
            if entity1 = hi_char then entity1 = "".

            do i = 1 to 3:
               if age_days[i] = 0 then age_days[i] = ((i - 1) * 30).
            end.

/*L01G* /*L00S*/    display */
/*L01G* /*L00S*/       et_report_txt when (et_tk_active) */
/*L01G* /*L00S*/       et_rate_txt when (et_tk_active) */
/*L01G* /*L00S*/    with frame a. */

/*L03L*     if c-application-mode <> 'web':u then */
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
/*L00S*/          et_report_curr
/*L03L* /*L00S*/  et_report_rate */
                  age_days[1 for 3]
               with frame a.

            et_eff_date = age_date.

/*L08W*     Code below to be wrapped in a 'do' code block for correct GUI conversion  */
/*L08W*/    do:

/*L0BZ*/       run ip-param-quoter.

/*L0BZ*/       /* Validate currency */
/*L0BZ*/       run ip-chk-valid-curr
/*L0BZ*/          (input  base_rpt,
/*L0BZ*/           output mc-error-number).

/*L0BZ*/       if mc-error-number <> 0 then do:
/*L0BZ*/          next-prompt base_rpt with frame a.
/*L0BZ*/          undo, retry.
/*L0BZ*/       end.

/*L0BZ*/       /* Validate reporting currency */
/*L0BZ*/       run ip-chk-valid-curr
/*L0BZ*/          (input  et_report_curr,
/*L0BZ*/           output mc-error-number).

/*L0BZ*/       if mc-error-number = 0 then do:

/*L0BZ*/          /* Default currencies if blank */
/*L0BZ*/          mc-rpt-curr = if base_rpt = "" then base_curr else base_rpt.
/*L0BZ*/          if et_report_curr = "" then et_report_curr = mc-rpt-curr.

/*L0BZ*/          /* Prompt for exchange rate and format for output */
/*L0BZ*/          run ip-ex-rate-setup
/*L0BZ*/             (input  et_report_curr,
/*L0BZ*/              input  mc-rpt-curr,
/*L0BZ*/              input  " ",
/*L0BZ*/              input  et_eff_date,
/*L0BZ*/              output et_rate2,
/*L0BZ*/              output et_rate1,
/*L0BZ*/              output mc-exch-line1,
/*L0BZ*/              output mc-exch-line2,
/*L0BZ*/              output mc-error-number).

/*L0BZ*/       end.  /* if mc-error-number = 0 */

/*L0BZ*/       if mc-error-number <> 0 then do:
/*L0BZ*/          next-prompt et_report_curr with frame a.
/*L0BZ*/          undo, retry.
/*L0BZ*/       end.

/*L03L*     end.  /* if (c-application-mode <> 'web':u) ... */ */
/*L08W*/    end.

/*J2G3*/    /* DISPLAY THE TOTAL LABELS AS CONTINUOUS STRINGS FOR CORRECT */
/*J2G3*/    /* TRANSLATION                                                */

/*J2G3*/    if base_rpt = ""
/*L03L*/    and et_report_curr = base_curr
/*J2G3*/    then
/*J2G3*/       assign
/*J2G3*/          l_label1 = {&apvorp01_p_29}
/*J2G3*/          l_label2 = {&apvorp01_p_30}.
/*J2G3*/    else assign
/*L03L* /*J2G3*/  l_label1 = string(base_rpt,"x(3)") + {&apvorp01_p_31} */
/*L03L* /*J2G3*/  l_label2 = string(base_rpt,"x(3)") + {&apvorp01_p_32}. */
/*L03L*/       l_label1 = string(et_report_curr,"x(3)") + {&apvorp01_p_31}
/*L03L*/       l_label2 = string(et_report_curr,"x(3)") + {&apvorp01_p_32}.

            /* SELECT PRINTER */
            {mfselbpr.i "printer" 132}
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.

            {mfphead.i}

            /* CREATE REPORT HEADER */
            do i = 1 to 3:
               age_range[i] = {&apvorp01_p_10}
                            + string(age_days[i],"->>>9")
                            + {&apvorp01_p_4}.
            end.
            age_range[4] = {&apvorp01_p_2}
                         + string(age_days[3],"->>>9")
                         + {&apvorp01_p_4}.

            FORM /*GUI*/ 
               header
/*L03L*/       mc-curr-label at 1 et_report_curr skip
/*L03L*/       mc-exch-label at 1 mc-exch-line1 skip
/*L03L*/       mc-exch-line2 at 23 skip(1)
               {&apvorp01_p_8}  at 1
               age_date       skip space (22)
               {&apvorp01_p_15}
               {&apvorp01_p_12}
               age_range[1 for 4] skip
               {&apvorp01_p_21}
               {&apvorp01_p_20}
               {&apvorp01_p_3}
               {&apvorp01_p_6}
               {&apvorp01_p_18}
               {&apvorp01_p_18}
               {&apvorp01_p_18}
               {&apvorp01_p_18}
               {&apvorp01_p_16} skip
               "--------"
               "------------"
               "--------"
               "--------"
               "----------------"
               "----------------"
               "----------------"
               "----------------"
               "----------------" skip
            with STREAM-IO /*GUI*/  frame phead1 width 132 page-top.
            view frame phead1.

            FORM /*GUI*/  with STREAM-IO /*GUI*/  frame c width 132 no-labels no-attr-space no-box down.

/*L03L*/    FORM /*GUI*/ 
/*L03L*/       l_label1   to 38
/*L03L*/       age_amt[1] to 56 format "->>>>,>>>,>>9.99"
/*L03L*/       age_amt[2]       format "->>>>,>>>,>>9.99"
/*L03L*/       age_amt[3]       format "->>>>,>>>,>>9.99"
/*L03L*/       age_amt[4]       format "->>>>,>>>,>>9.99"
/*L03L*/       vo-tot           format "->>>>,>>>,>>9.99"
/*L03L*/    with STREAM-IO /*GUI*/  frame e width 132 no-labels no-attr-space no-box down.

            for each vd_mstr where (vd_addr >= vend)
            and (vd_addr <= vend1)
            and (vd_type >= vdtype and vd_type <= vdtype1)
            exclusive-lock
            use-index vd_sort
            break by vd_addr by vd_sort:
               vend_detail = no.
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

/*L0BZ*/          assign
/*L0BZ*/             age_amt     = 0
/*L0BZ*/             et_age_amt  = 0
                     vend_detail = yes.

                  if not available ad_mstr or ad_addr <> vd_addr then do:
/*L0BZ*              name = "".  *L0BZ*/
                     find ad_mstr where ad_addr = ap_vend no-lock no-wait
                     no-error.
/*L0BZ*/             name = if available ad_mstr then ad_name else "".
                     vd_recno = recid(vd_mstr).
/*L0BZ*              if available ad_mstr then name = ad_name.  *L0BZ*/
                     if page-size - line-counter < 4 then page.
                     display
                        ap_vend no-label
                        name no-label
                        ad_attn
                        ad_phone ad_ext no-label
                     with frame b side-labels width 132 STREAM-IO /*GUI*/ .
                  end.

/*L03L*/          assign
                     curr_amt = ap_amt - vo_applied
                     base_amt = ap_amt
                     base_applied = vo_applied
                     base_hold_amt = vo_hold_amt.
                  if base_rpt = ""
                  and ap_curr <> base_curr then do:
                     assign
/*L03L*/                base_amt = ap_base_amt
/*L03L*/                base_applied = vo_base_applied
/*L03L*/                base_hold_amt = vo_base_hold_amt.

/*L03L*              base_amt = base_amt / ap_ex_rate */
/*L03L*              base_applied = base_applied / ap_ex_rate */
/*L03L*              base_hold_amt = base_hold_amt / ap_ex_rate. */

/*L03L*              {gprun.i ""gpcurrnd.p"" "(input-output base_amt, */
/*L03L*                 input gl_rnd_mthd)"} */
/*L03L*              {gprun.i ""gpcurrnd.p"" "(input-output base_applied, */
/*L03L*                 input gl_rnd_mthd)"} */
/*L03L*              {gprun.i ""gpcurrnd.p"" "(input-output base_hold_amt, */
/*L03L*                 input gl_rnd_mthd)"} */

/*L03L*              {gpgtex8.i &ent_curr = base_curr */
/*L03L*                         &curr = ap_curr */
/*L03L*                         &date = age_date */
/*L03L*                         &exch_from = exd_rate */
/*L03L*                         &exch_to =  exdrate } */
/*L03L*/             /* GET EXCHANGE RATE */
/*L03L*/             {gprunp.i "mcpl" "p" "mc-get-ex-rate"
                       "(input ap_curr,
                         input base_curr,
                         input ap_ex_ratetype,
                         input age_date,
                         output exdrate,
                         output exdrate2,
                         output mc-error-number)"}
/*L03L*              if available exd_det then */
                     if mc-error-number = 0 then do:
/*L03L*                 curr_amt = curr_amt / exdrate. */
/*L03L*/                /* CONVERT FROM FOREIGN TO BASE CURRENCY */

/*L0BZ*/                run ip-curr-conv
/*L0BZ*/                   (input  ap_curr,
/*L0BZ*/                    input  base_curr,
/*L0BZ*/                    input  exdrate,
/*L0BZ*/                    input  exdrate2,
/*L0BZ*/                    input  curr_amt,
/*L0BZ*/                    input  true, /* ROUND */
/*L0BZ*/                    output curr_amt).

/*L03L*/             end.
                     /* IF NO EXCHANGE RATE FOR TODAY, USE THE VOUCHER RATE */
                     else
/*L03L*/             do:
/*L03L*                 curr_amt = curr_amt / ap_ex_rate. */
/*L03L*/                /* CONVERT FROM FOREIGN TO BASE CURRENCY */

/*L0BZ*/                run ip-curr-conv
/*L0BZ*/                   (input  ap_curr,
/*L0BZ*/                    input  base_curr,
/*L0BZ*/                    input  ap_ex_rate,
/*L0BZ*/                    input  ap_ex_rate2,
/*L0BZ*/                    input  curr_amt,
/*L0BZ*/                    input  true, /* ROUND */
/*L0BZ*/                    output curr_amt).

/*L03L*/             end.
/*L03L*              {gprun.i ""gpcurrnd.p"" "(input-output curr_amt, */
/*L03L*                 input gl_rnd_mthd)"} */
                  end.  /* if base_rpt = "" and ap_curr <> base_curr */

                  multi-due = no.
                  find ct_mstr where ct_code = vo_cr_terms no-lock no-error.
                  if available ct_mstr and ct_dating then do:
/*L03L*/             assign
                        multi-due = yes
                        tot-amt = 0
                        vo-tot = 0
                        applied-amt = base_applied.
                     for each ctd_det where ctd_code = vo_cr_terms no-lock
                     break by ctd_code:
                        find ct_mstr where ct_code = ctd_date_cd no-lock
                        no-error.
                        if available ct_mstr then do:

/*L0BZ*/                   assign
/*L0BZ*/                      due-date =
/*L0BZ*/                         if ct_due_date <> ?
/*L0BZ*/                            then ct_due_date
/*L0BZ*/                            else
/*L0BZ*/                               if ct_from_inv = 1
/*L0BZ*/                                  then ap_date + ct_due_days
/*L0BZ*/                                  else
/*L0BZ*/                                     date((month(ap_date) + 1) mod 12 +
/*L0BZ*/                                             if month(ap_date) = 11
/*L0BZ*/                                                then 12 else 0,
/*L0BZ*/                                          1,
/*L0BZ*/                                          year(ap_date) +
/*L0BZ*/                                             if month(ap_date) >= 12
/*L0BZ*/                                                then 1 else 0) +
/*L0BZ*/                                     integer(ct_due_days) -
/*L0BZ*/                                     if ct_due_days <> 0 then 1 else 0

/*L0BZ*/                      /* Calculate the amt-due less the applied */
/*L0BZ*/                      /* for this segment.  To prevent rounding */
/*L0BZ*/                      /* errors, assign last bucket = rounded   */
/*L0BZ*/                      /* total - running total */

/*L0BZ*/                      amt-due =
/*L0BZ*/                         if last-of(ctd_code)
/*L0BZ*/                            then base_amt - tot-amt
/*L0BZ*/                            else base_amt * (ctd_pct_due / 100).

/*L03L*                    {gprun.i ""gpcurrnd.p"" "(input-output amt-due, */
/*L03L*                                              input gl_rnd_mthd)"} */
/*L03L*/                   {gprunp.i "mcpl" "p" "mc-curr-rnd"
                             "(input-output amt-due,
                               input gl_rnd_mthd,
                               output mc-error-number)"}
/*L03L*/                   if mc-error-number <> 0 then do:
/*L03L*/                      {mfmsg.i mc-error-number 2}
/*L03L*/                   end.

                           if applied-amt >= amt-due then do:
/*L03L*/                      assign
                                 applied-amt = applied-amt - amt-due
                                 tot-amt = tot-amt + amt-due.
                              next. /*THIS SEGMENT IS CLOSED*/
                           end.
                           else do:
/*L03L*/                      assign
                                 tot-amt = tot-amt + amt-due
                                 amt-due = amt-due - applied-amt
                                 applied-amt = 0.
                           end.
                           if hold_calc = yes then do:
                              if (ap_amt - (tot-amt - amt-due )) <= vo_hold_amt
                              then adj_amt = amt-due.
                              else adj_amt = max(vo_hold_amt -
                              (ap_amt - tot-amt),0).
                           end.
                           else adj_amt = 0.
                           age_period = 4.
                           do i = 1 to 4:
                              if (age_date - age_days[i]) <= due-date then
                                 age_period = i.
                              if age_period <> 4 then leave.
                           end.
/*L03L*/                   assign
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
/*L03L*/             assign
                        age_amt[age_period] = base_amt - base_applied - adj_amt
                        vo-tot = base_amt - base_applied - adj_amt.
                  end.
                  if vo_hold_amt <> 0 then hold = "H".
                  else hold = "".

                  if summary_only = no then do:
                     display ap_ref vo_invoice with frame c STREAM-IO /*GUI*/ .
                     if multi-due = no then display
                     vo_due_date with frame c STREAM-IO /*GUI*/ .
                     else display {&apvorp01_p_5} @ vo_due_date with frame c STREAM-IO /*GUI*/ .
                     display vo_cr_terms with frame c STREAM-IO /*GUI*/ .
                  end.

/*L03L*/          do i = 1 to 4:
/*L03L*/             if et_report_curr <> mc-rpt-curr then do:

/*L0BZ*/                run ip-curr-conv
/*L0BZ*/                   (input  mc-rpt-curr,
/*L0BZ*/                    input  et_report_curr,
/*L0BZ*/                    input  et_rate1,
/*L0BZ*/                    input  et_rate2,
/*L0BZ*/                    input  age_amt[i],
/*L0BZ*/                    input  true,  /* ROUND */
/*L0BZ*/                    output et_age_amt[i]).

/*L03L*/             end.  /* if et_report_curr <> mc-rpt-curr */
/*L03L*/             else et_age_amt[i] = age_amt[i].
/*L03L*/          end.  /* do i = 1 to 4 */
/*L03L*/          if et_report_curr <> mc-rpt-curr then do:

/*L0BZ*/             run ip-curr-conv
/*L0BZ*/                (input  mc-rpt-curr,
/*L0BZ*/                 input  et_report_curr,
/*L0BZ*/                 input  et_rate1,
/*L0BZ*/                 input  et_rate2,
/*L0BZ*/                 input  curr_amt,
/*L0BZ*/                 input  true,  /* ROUND */
/*L0BZ*/                 output et_curr_amt).

/*L0BZ*/             run ip-curr-conv
/*L0BZ*/                (input  mc-rpt-curr,
/*L0BZ*/                 input  et_report_curr,
/*L0BZ*/                 input  et_rate1,
/*L0BZ*/                 input  et_rate2,
/*L0BZ*/                 input  vo-tot,
/*L0BZ*/                 input  true,  /* ROUND */
/*L0BZ*/                 output et_vo_tot).

/*L03L*/          end.  /* if et_report_curr <> mc-rpt-curr */
/*L03L*/          else assign
/*L03L*/             et_curr_amt = curr_amt
/*L03L*/             et_vo_tot = vo-tot.

/*L00S*/          accumulate et_curr_amt (total).
/*L00S*/          accumulate et_age_amt (total).
/*L00S*/          accumulate et_vo_tot (total).

                  accumulate age_amt(total).
                  accumulate
                     vo-tot(total).
                  accumulate curr_amt (total).
                  if summary_only = no then do:

/*L00S*/             display et_age_amt[1 for 4] et_vo_tot

                     hold with frame c STREAM-IO /*GUI*/ .
                     down 1 with frame c.
                     if base_curr <> ap_curr then
/*L03L*                 put ap_ent_ex  to 34  */
/*L03L*/                put (ap_ex_rate / ap_ex_rate2) to 34
                            space(1) ap_curr skip.
                  end.
               end. /*for each ap_mstr, each vo_mstr*/
               if vend_detail then do:
                  if page-size - line-counter < 4 then page.
                  if summary_only = no then
                  underline

/*L00S*              age_amt vo-tot with frame c. */
/*L00S*/             et_age_amt et_vo_tot with frame c.

/*J2G3*/          display
/*J2G3*/            l_label1

/*L03L*/            accum total (et_age_amt[1]) @ age_amt[1]
/*L03L*/            accum total (et_age_amt[2]) @ age_amt[2]
/*L03L*/            accum total (et_age_amt[3]) @ age_amt[3]
/*L03L*/            accum total (et_age_amt[4]) @ age_amt[4]

/*L03L*/            accum total (et_vo_tot)     @ vo-tot

/*J2G3*/         with frame e STREAM-IO /*GUI*/ .
                 
                 down 1 with frame e.
                 
               end.
                 
               assign vdbal =  accum total (et_vo_tot) .
              
               if last-of(vd_addr) then do:
                
                  /***
                  display vd_addr vd_sort vd_balance 
                          vdbal format "->>>>>,>>>,>>9.999" with frame mytest.
                          *********/
                  assign vd_balance = vdbal.
                          
                  vdbal = 0.
               end.
               
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/

           end.
           if page-size - line-counter < 4 then page.
/*J2G3*/   down 1 with frame e.

/*J2G3*/    display
/*J2G3*/       l_label2 @ l_label1


/*L00S*       BEGIN ADD */
               accum total (et_age_amt[1]) @ age_amt[1]
               accum total (et_age_amt[2]) @ age_amt[2]
               accum total (et_age_amt[3]) @ age_amt[3]
               accum total (et_age_amt[4]) @ age_amt[4]
/*L03L*        accum total (et_vo-tot)     @ et_vo-tot */
/*L03L*/       accum total (et_vo_tot)     @ vo-tot
/*L00S*       END ADD */

/*J2G3*/    with frame e STREAM-IO /*GUI*/ .

/*L00S*     down 2.*/
/*L00S*/    down with frame e.

/*L00S*     BEGIN ADDED SECTION*/

            /*DETERMINE ORIGINAL TOTALS, NOT YET CONVERTED*/
            assign
               et_org_age_amt[1] = accum total (age_amt[1])
               et_org_age_amt[2] = accum total (age_amt[2])
               et_org_age_amt[3] = accum total (age_amt[3])
               et_org_age_amt[4] = accum total (age_amt[4])
               et_org_vo_tot     = accum total (vo-tot)
               et_org_curr_amt   = accum total curr_amt.

            /*CONVERT AMOUNTS*/
/*L03L*     {etrpconv.i et_org_age_amt[1] et_org_age_amt[1]} */
/*L03L*     {etrpconv.i et_org_age_amt[2] et_org_age_amt[2]} */
/*L03L*     {etrpconv.i et_org_age_amt[3] et_org_age_amt[3]} */
/*L03L*     {etrpconv.i et_org_age_amt[4] et_org_age_amt[4]} */
/*L03L*     {etrpconv.i et_org_curr_amt   et_org_curr_amt  } */
/*L03L*     {etrpconv.i et_org_vo-tot     et_org_vo-tot    } */

/*L03L*/    do i = 1 to 4:
/*L03L*/       if et_report_curr <> mc-rpt-curr then do:

/*L0BZ* /*L03L*/  {gprunp.i "mcpl" "p" "mc-curr-conv"
 *L0BZ*             "(input mc-rpt-curr,
 *L0BZ*               input et_report_curr,
 *L0BZ*               input et_rate1,
 *L0BZ*               input et_rate2,
 *L0BZ*               input et_org_age_amt[i],
 *L0BZ*               input true,  /* ROUND */
 *L0BZ*               output et_org_age_amt[i],
 *L0BZ*               output mc-error-number)"}
 *L0BZ* /*L03L*/  if mc-error-number <> 0 then do:
 *L0BZ* /*L03L*/     {mfmsg.i mc-error-number 2}
 *L0BZ* /*L03L*/  end.
 *L0BZ*/

/*L0BZ*/          run ip-curr-conv
/*L0BZ*/             (input  mc-rpt-curr,
/*L0BZ*/              input  et_report_curr,
/*L0BZ*/              input  et_rate1,
/*L0BZ*/              input  et_rate2,
/*L0BZ*/              input  et_org_age_amt[i],
/*L0BZ*/              input  true,  /* ROUND */
/*L0BZ*/              output et_org_age_amt[i]).

/*L03L*/       end.  /* if et_report_curr <> mc-rpt-curr */
/*L03L*/    end.  /* do i = 1 to 4 */
/*L03L*/    if et_report_curr <> mc-rpt-curr then do:

/*L0BZ* /*L03L*/ {gprunp.i "mcpl" "p" "mc-curr-conv"
 *L0BZ*            "(input mc-rpt-curr,
 *L0BZ*              input et_report_curr,
 *L0BZ*              input et_rate1,
 *L0BZ*              input et_rate2,
 *L0BZ*              input et_org_curr_amt,
 *L0BZ*              input true,  /* ROUND */
 *L0BZ*              output et_org_curr_amt,
 *L0BZ*              output mc-error-number)"}
 *L0BZ* /*L03L*/ if mc-error-number <> 0 then do:
 *L0BZ* /*L03L*/    {mfmsg.i mc-error-number 2}
 *L0BZ* /*L03L*/ end.
 *L0BZ* /*L03L*/ {gprunp.i "mcpl" "p" "mc-curr-conv"
 *L0BZ*            "(input mc-rpt-curr,
 *L0BZ*              input et_report_curr,
 *L0BZ*              input et_rate1,
 *L0BZ*              input et_rate2,
 *L0BZ*              input et_org_vo_tot,
 *L0BZ*              input true,  /* ROUND */
 *L0BZ*              output et_org_vo_tot,
 *L0BZ*              output mc-error-number)"}
 *L0BZ* /*L03L*/ if mc-error-number <> 0 then do:
 *L0BZ* /*L03L*/    {mfmsg.i mc-error-number 2}
 *L0BZ* /*L03L*/ end.
 *L0BZ*/

/*L0BZ*/       run ip-curr-conv
/*L0BZ*/          (input  mc-rpt-curr,
/*L0BZ*/           input  et_report_curr,
/*L0BZ*/           input  et_rate1,
/*L0BZ*/           input  et_rate2,
/*L0BZ*/           input  et_org_curr_amt,
/*L0BZ*/           input  true,  /* ROUND */
/*L0BZ*/           output et_org_curr_amt).
/*L0BZ*/       run ip-curr-conv
/*L0BZ*/          (input  mc-rpt-curr,
/*L0BZ*/           input  et_report_curr,
/*L0BZ*/           input  et_rate1,
/*L0BZ*/           input  et_rate2,
/*L0BZ*/           input  et_org_vo_tot,
/*L0BZ*/           input  true,  /* ROUND */
/*L0BZ*/           output et_org_vo_tot).

/*L03L*/    end.  /* if et_report_curr <> mc-rpt-curr */

            /* DISPLAY CONVERTED REPORT AMOUNTS */
/*L01G*     if et_show_diff and */
/*L01G*/    if et_ctrl.et_show_diff and
            (
            ((accum total et_age_amt[1]) - et_org_age_amt[1] <> 0 ) or
            ((accum total et_age_amt[2]) - et_org_age_amt[2] <> 0 ) or
            ((accum total et_age_amt[3]) - et_org_age_amt[3] <> 0 ) or
            ((accum total et_age_amt[4]) - et_org_age_amt[4] <> 0 ) or
            ((accum total et_vo_tot)     - et_org_vo_tot     <> 0 )
            )
            then do:

               /* DISPLAY REPORT DIFFRENCCES */
/*L03L*        put et_diff_txt to 38 */
/*L03L*/       display
/*L03L*/          (trim(substring(et_diff_txt,1,36)) + ":")
/*L03L*/          format "x(37)" @ l_label1
                  ((accum total et_age_amt[1]) - et_org_age_amt[1])
/*L03L*/          @ age_amt[1]
/*L03L*           to 57 */
                  ((accum total et_age_amt[2]) - et_org_age_amt[2])
/*L03L*           to 75 */
/*L03L*/          @ age_amt[2]
                  ((accum total et_age_amt[3]) - et_org_age_amt[3])
/*L03L*           to 93 */
/*L03L*/          @ age_amt[3]
                  ((accum total et_age_amt[4]) - et_org_age_amt[4])
/*L03L*           to 111 */
/*L03L*/          @ age_amt[4]
                  ((accum total (et_vo_tot)) - et_org_vo_tot)
/*L03L*/          @ vo-tot
/*L03L*/          with frame e STREAM-IO /*GUI*/ .
/*L03L*           to 129. */
            end. /* CONVERTED AMOUNTS DON'T MATCH */

/*L00S*     END ADD*/

/*L00S*     BEGIN ADD*/
            et_diff_exist = false.
/*L01G*     if et_show_diff and */
/*L01G*/    if et_ctrl.et_show_diff and
               (
               (((accum total (et_vo_tot))  - et_org_vo_tot)    <> 0) or
               (((accum total (et_curr_amt)) - et_org_curr_amt) <> 0) or
               (((((accum total (et_curr_amt)) - et_org_curr_amt)) -
               (((accum total (et_vo_tot)) - et_org_vo_tot))) <> 0)
                  )
                  then et_diff_exist = true.
/*L00S*     END ADD*/

            if base_rpt = "" then
/*L00S*/    do on endkey undo, leave:
               display
                  et_diff_txt to 96 when (et_diff_exist)
/*L00S*           "Total Base Aging:" to 34                           */
/*L03L* /*L00S*/  "Total " + et_disp_curr + fill(" ",4 - length(et_disp_curr))*/
/*L03L* /*L00S*/  + " Aging:" format "x(17)" to 34 */
/*L03L*/          {&apvorp01_p_33} + et_report_curr + {&apvorp01_p_34}
/*L03L*/          format "x(17)" to 35

/*L00S*           (accum total (vo-tot)) format "->>>>>,>>>,>>9.99" at 36 */
/*L00S*/          (accum total (et_vo_tot)) format "->>>>>,>>>,>>9.99" at 36

/*L00S*/          ((accum total (et_vo_tot))
/*L00S*/             - et_org_vo_tot) when (et_diff_exist)
/*L00S*/             format "->>>>>,>>>,>>9.99" at 77

                  {&apvorp01_p_14} + string(age_date) + {&apvorp01_p_13}
                     format "x(32)" to 34

/*L00S*           accum total (curr_amt) format "->>>>>,>>>,>>9.99" at 36 */
/*L00S*/          accum total (et_curr_amt) format "->>>>>,>>>,>>9.99" at 36

/*L00S*/          ((accum total (et_curr_amt))
/*L00S*/             - et_org_curr_amt) when (et_diff_exist)
/*L00S*/             format "->>>>>,>>>,>>9.99" at 77

                  {&apvorp01_p_24}
                     + string(age_date)
                     + {&apvorp01_p_7}
                     format "x(29)" to 34
/*L00S*           (accum total (curr_amt)) -                              */
/*L00S*           (accum total (vo-tot)) format "->>>>>,>>>,>>9.99" at 36 */
/*L00S*/          (accum total (et_curr_amt)) -
/*L00S*/          (accum total (et_vo_tot)) format "->>>>>,>>>,>>9.99" at 36

/*L00S*/          ((((accum total (et_curr_amt))
/*L00S*/             - et_org_curr_amt)) -
/*L00S*/          (((accum total (et_vo_tot))
/*L00S*/             - et_org_vo_tot))) when (et_diff_exist)
/*L00S*/             format "->>>>>,>>>,>>9.99" at 77

               with frame d width 132 no-labels STREAM-IO /*GUI*/ .

/*L00S*/    end. /* IF BASE-RPT = "" */

            /* REPORT TRAILER */
            hide frame phead1.
            {mfrtrail.i}

         end. /* REPEAT */

/*L03L*  {wbrp04.i &frame-spec = a} */


/*L0BZ*/ procedure ip-param-quoter:


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


         end procedure.  /* ip-param-quoter */


/*L0BZ*/ procedure ip-chk-valid-curr:


            define input  parameter i_curr  as character no-undo.
            define output parameter o_error as integer   no-undo initial 0.


            if i_curr <> "" then do:

               {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
                  "(input  i_curr,
                    output o_error)" }

               if o_error <> 0 then do:
                  {mfmsg.i o_error 3}
               end.

            end.  /* if i_curr */


         end procedure.  /* ip-chk-valid-curr */


/*L0BZ*/ procedure ip-ex-rate-setup:

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
            define variable v_fix_rate           like mfc_logical no-undo.


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
                  {mfmsg.i o_error 3}
               end.

            end.  /* do transaction */


         end procedure.  /* ip-ex-rate-setup */


/*L0BZ*/ procedure ip-curr-conv:


            define input  parameter i_src_curr  as character no-undo.
            define input  parameter i_targ_curr as character no-undo.
            define input  parameter i_src_rate  as decimal   no-undo.
            define input  parameter i_targ_rate as decimal   no-undo.
            define input  parameter i_src_amt   as decimal   no-undo.
            define input  parameter i_round     like mfc_logical   no-undo.
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
               {mfmsg.i mc-error-number 2}
            end.


         end procedure.  /* ip-curr-conv */
