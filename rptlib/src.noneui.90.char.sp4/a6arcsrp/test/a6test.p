/* arcsrp.p - ACCOUNTS RECEIVABLE CUST BALANCE REPORT                    */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.  */
/*F0PN*/ /*V8:ConvertMode=FullGUIReport                                           */
/* REVISION: 5.0      LAST MODIFIED: 12/14/88   BY: MLB                  */
/* REVISION: 7.0      LAST MODIFIED: 02/26/92   by: jms   *F239*         */
/* REVISION: 7.0      LAST MODIFIED: 06/10/94   by: dpm   *FO76*         */
/* REVISION: 7.0      LAST MODIFIED: 08/22/94   by: rxm   *FQ43*         */
/* REVISION: 8.6      LAST MODIFIED: 10/10/97   by: bvm   *K0Q9*         */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane     */
/* REVISION: 8.6E     LAST MODIFIED: 23 apr 98  BY: *L00M* D. Sidel      */
/* REVISION: 8.6E     LAST MODIFIED: 06/24/98   BY: *L01G* R. McCarthy   */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98   BY: *L02Q* Brenda Milton */
/* REVISION: 8.6E     LAST MODIFIED: 08/19/98   BY: *L059* Jean Miller   */
/* REVISION: 8.6E     LAST MODIFIED: 09/08/98   BY: *L08W* Russ Witt     */
/* REVISION: 8.6E     LAST MODIFIED: 08/05/05   BY: *SS - 20050805* Bill Jiang     */
/* SS - 20050805 - B */
{a6arcsrp.i "new"}
/* SS - 20050805 - E */

          {mfdtitle.i "e+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE arcsrp_p_1 "包括零余额"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp_p_2 "只打印超过信贷限额的客户"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp_p_3 "只打印负值余额"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp_p_4 " 报表合计:"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/*L02Q*/  /* THESE ARE NEEDED FOR FULL GUI REPORTS */
/*L02Q*/  {gprunpdf.i "mcpl" "p"}
/*L02Q*/  {gprunpdf.i "mcui" "p"}

          define variable code like cm_addr.
          define variable code1 like cm_addr.
          define variable name like ad_name.
          define variable name1 like ad_name.
          define variable type like cm_type.
          define variable type1 like cm_type.
          define variable neg_only like mfc_logical
             label {&arcsrp_p_3} initial no.
          define variable over_only like mfc_logical
             label {&arcsrp_p_2} initial no.
          define variable inc_zero like mfc_logical
             label {&arcsrp_p_1} initial no.

/*L00M*BEGIN ADDED SECTION*/
          {etrpvar.i &new = "new"}
          {etvar.i   &new = "new"}
          {eteuro.i}
          define variable et_cm_balance     like cm_balance.
          define variable et_cm_cr_limit    like cm_balance.
          define variable et_org_cm_balance like cm_balance.
/*L02Q*   define variable display_curr      like ex_curr. */
/*L02Q*   define variable input_curr        like ex_curr. */
/*L00M*END ADDED SECTION*/

          form
             code       colon 15   code1    label {t001.i} colon 49
             name       colon 15   name1    label {t001.i} colon 49
             type       colon 15   type1    label {t001.i} colon 49 skip(1)
             neg_only   colon 29
             over_only  colon 29
             inc_zero   colon 29
/*L02Q*/     et_report_curr colon 29 skip(1)
/*L02Q* /*L00M*/  et_report_txt to 29 no-label */
/*L02Q* /*L00M*/  et_report_curr no-label /*colon 29*/ */
/*L02Q* /*L00M*/  et_rate_txt to 29 no-label */
/*L02Q* /*L00M*/  et_report_rate no-label /*colon 29*/ skip(1) */
          with frame a side-labels
/*L00M*/  no-attr-space
          width 80.

          {wbrp01.i}

          repeat:

/*L00M*/     find first gl_ctrl no-lock.

             if code1 = hi_char then code1 = "".
             if name1 = hi_char then name1 = "".
             if type1 = hi_char then type1 = "".

/*L02Q* /*L00M*/ display et_report_txt */
/*L02Q* /*L00M*/         et_rate_txt with frame a. */

             if c-application-mode <> "WEB":U then
                update code code1 name name1 type type1 neg_only over_only
                       inc_zero
/*L00M*/               et_report_curr
/*L02Q* /*L00M*/       et_report_rate */
                with frame a.

             {wbrp06.i &command = update &fields = "  code code1 name
                 name1 type type1 neg_only over_only inc_zero
/*L00M*/         et_report_curr
/*L02Q /*L00M*/  et_report_rate */
                 " &frm = "a"}

/*L02Q* /*L00M*/if et_report_curr = "" then assign display_curr = base_curr. */
/*L02Q* /*L00M*/else assign display_curr = et_report_curr. */

/*L02Q* /*L00M*/{etcurval.i &curr     = "et_report_curr"  &errlevel = "4" */
/*L02Q* /*L00M*/            &action   = "next"     &prompt   = "pause" }  */

/*L00M*/     assign et_eff_date = today.

/*L02Q* /*L00M*/   input_curr = "". */
/*L02Q* /*L00M*/{gprun.i ""etrate.p"" "(input input_curr)" } */

             if (c-application-mode <> "WEB":U) or
                (c-application-mode = "WEB":U and
                (c-web-request begins "DATA":U)) then do:

                   /*CREATE BATCH INPUT */
                bcdparm = "".
                {mfquoter.i code      }
                {mfquoter.i code1     }
                {mfquoter.i name      }
                {mfquoter.i name1     }
                {mfquoter.i type      }
                {mfquoter.i type1     }
                {mfquoter.i neg_only  }
                {mfquoter.i over_only }
                {mfquoter.i inc_zero  }
/*L00M*/        {mfquoter.i et_report_curr }
/*L02Q* /*L00M*/   {mfquoter.i et_report_rate } */

                if code1 = "" then code1 = hi_char.
                if name1 = "" then name1 = hi_char.
                if type1 = "" then type1 = hi_char.

/*L02Q*/        if et_report_curr <> "" then do:
/*L02Q*/           {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
                     "(input et_report_curr,
                       output mc-error-number)"}
/*L02Q*/           if mc-error-number = 0
/*L02Q*/           and et_report_curr <> base_curr then do:
/*L08W*               CURRENCIES AND RATES REVERSED BELOW...             */
/*L02Q*/              {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
                        "(input et_report_curr,
                          input base_curr,
                          input "" "",
                          input et_eff_date,
                          output et_rate2,
                          output et_rate1,
                          output mc-seq,
                          output mc-error-number)"}
/*L02Q*/           end.  /* if mc-error-number = 0 */

/*L02Q*/           if mc-error-number <> 0 then do:
/*L02Q*/              {mfmsg.i mc-error-number 3}
/*L02Q*/              if c-application-mode = "WEB":U then return.
/*L02Q*/              else next-prompt et_report_curr with frame a.
/*L02Q*/              undo, retry.
/*L02Q*/           end.  /* if mc-error-number <> 0 */
/*L02Q*/           else if et_report_curr <> base_curr then do:
/*L08W*               CURRENCIES AND RATES REVERSED BELOW...             */
/*L02Q*/              {gprunp.i "mcui" "p" "mc-ex-rate-output"
                        "(input et_report_curr,
                          input base_curr,
                          input et_rate2,
                          input et_rate1,
                          input mc-seq,
                          output mc-exch-line1,
                          output mc-exch-line2)"}
/*L02Q*/              {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
                        "(input mc-seq)"}
/*L02Q*/           end.  /* else do */
/*L02Q*/        end.  /* if et_report_curr <> "" */

/*L02Q*/        if et_report_curr = "" or et_report_curr = base_curr then
/*L02Q*/        assign
/*L02Q*/           mc-exch-line1 = ""
/*L02Q*/           mc-exch-line2 = ""
/*L02Q*/           et_report_curr = base_curr.

             end.  /* if (c-application-mode <> "WEB":U) ... */

             /* SELECT PRINTER */
             {mfselbpr.i "printer" 132}
             /* SS - 20050805 - B */
             /*
             {mfphead.i}

             form header
                skip(1)
/*L02Q*/        mc-curr-label et_report_curr skip
/*L02Q*/        mc-exch-label mc-exch-line1 skip
/*L02Q*/        mc-exch-line2 at 23 skip(1)
             with frame p1 page-top
             width 132.
             view frame p1.

             for each cm_mstr where cm_addr >= code and cm_addr <= code1 and
                                    cm_sort >= name and cm_sort <= name1 and
                                    cm_type >= type and cm_type <= type1 and
                                    (cm_balance <> 0 or inc_zero = yes) and
                                    (cm_balance < 0 or neg_only = no) and
                                    (cm_cr_limit <= cm_balance or
                                    over_only = no)
             no-lock break by cm_sort with frame b
             width 132 no-box:

/*L00M*/        /*CONVERT TO REPORT CURRENCY*/
/*L02Q* /*L00M*/   {etrpconv.i cm_cr_limit et_cm_cr_limit    } */
/*L02Q* /*L00M*/   {etrpconv.i cm_balance  et_cm_balance     } */
/*L02Q*/        if et_report_curr <> base_curr then do:
/*L02Q*/           {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input base_curr,
                       input et_report_curr,
                       input et_rate1,
                       input et_rate2,
                       input cm_cr_limit,
                       input true,    /* ROUND */
                       output et_cm_cr_limit,
                       output mc-error-number)"}
/*L02Q*/           if mc-error-number <> 0 then do:
/*L02Q*/              {mfmsg.i mc-error-number 2}
/*L02Q*/           end.
/*L02Q*/           {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input base_curr,
                       input et_report_curr,
                       input et_rate1,
                       input et_rate2,
                       input cm_balance,
                       input true,    /* ROUND */
                       output et_cm_balance,
                       output mc-error-number)"}
/*L02Q*/           if mc-error-number <> 0 then do:
/*L02Q*/              {mfmsg.i mc-error-number 2}
/*L02Q*/           end.
/*L02Q*/        end.  /* if et_report_curr <> base_curr */
/*L02Q*/        else assign et_cm_cr_limit = cm_cr_limit
/*L02Q*/                    et_cm_balance = cm_balance.

/*L00M*/        et_cm_cr_limit = round(et_cm_cr_limit , 0).

                find ad_mstr where ad_addr = cm_addr no-lock.
                display ad_addr  ad_name format "X(25)"
                        ad_attn format "X(22)" ad_phone
                        ad_ext cm_cr_terms cm_pay_date
/*L00M*                 cm_cr_limit    cm_balance. */
/*L00M*/                et_cm_cr_limit format ">>>,>>>,>>>,>>9" @ cm_cr_limit
/*L00M*/                et_cm_balance.

                accumulate cm_balance (total).
/*L00M*/        accumulate et_cm_balance (total).

                {mfrpexit.i}

                if last(cm_sort) then do:
/*L00M*            underline cm_balance.*/
/*L00M*/           underline et_cm_balance.

/*L00M*/           /*DETERMINE AND CONVERT ORIGINAL TOTAL*/
/*L00M*/           assign et_org_cm_balance = accum total(cm_balance).
/*L02Q* /*L00M*/   {etrpconv.i et_org_cm_balance et_org_cm_balance} */
/*L02Q*/           if et_report_curr <> base_curr then do:
/*L02Q*/              {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input base_curr,
                          input et_report_curr,
                          input et_rate1,
                          input et_rate2,
                          input et_org_cm_balance,
                          input true,    /* ROUND */
                          output et_org_cm_balance,
                          output mc-error-number)"}
/*L02Q*/              if mc-error-number <> 0 then do:
/*L02Q*/                 {mfmsg.i mc-error-number 2}
/*L02Q*/              end.
/*L02Q*/           end.  /* if et_report_curr <> base_curr */

/*L00M*            display accum total(cm_balance) @ cm_balance.*/
/*L02Q* /*L00M*/   display "    " + display_curr @ cm_pay_date */
/*L02Q*/           display "     " + et_report_curr @ cm_pay_date
/*L059* /*L00M*/   " Report Totals:"             @ cm_cr_limit */
/*L00M*/           {&arcsrp_p_4}                 @ cm_cr_limit
/*L00M*/           accum total(et_cm_balance)    @ et_cm_balance.
/*L00M*/           down 2.

/*L01G* /*L00M*/   if et_show_diff and */
/*L01G*/           if et_ctrl.et_show_diff and
/*L00M*/              ((accum total(et_cm_balance)) - et_org_cm_balance) <> 0
/*L00M*/           then do:
/*L00M*/              display et_diff_txt @ ad_name
/*L00M*/                 ((accum total(et_cm_balance)) - et_org_cm_balance)
/*L00M*/                 @ et_cm_balance.
/*L00M*/           end. /* IF ET_SHOW_DIFF */

                end.  /* if last-of(cm_sort) */
             end.  /* for each cm_mstr */

             /* REPORT TRAILER  */
             {mfrtrail.i}
             */
             FOR EACH tta6arcsrp:
                 DELETE tta6arcsrp.
             END.

             {gprun.i ""a6arcsrp.p"" "(
                 INPUT CODE,
                 INPUT code1,
                 INPUT NAME,
                 INPUT name1,
                 INPUT TYPE,
                 INPUT type1,
                 INPUT neg_only,
                 INPUT over_only,
                 INPUT inc_zero,
                 INPUT et_report_curr
             )"}

             EXPORT DELIMITER ";" "addr" "balance".
             FOR EACH tta6arcsrp:
                 EXPORT DELIMITER ";" tta6arcsrp_addr tta6arcsrp_balance.
             END.

             {a6mfrtrail.i}
             /* SS - 20050805 - E */

          end.  /* repeat */

          {wbrp04.i &frame-spec = a}
