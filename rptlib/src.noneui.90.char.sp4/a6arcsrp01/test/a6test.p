/* arcsrp01.p - AR AGING REPORT FROM DUE DATE                                */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.      */
/*F0PN*/ /*K0PN*/
/*V8:ConvertMode=Report                                                      */
/*L02Q*/ /*V8:RunMode=Character,Windows                                      */
/* REVISION: 6.0      LAST MODIFIED: 08/30/90   BY: afs *D059*               */
/* REVISOIN: 6.0      LAST MODIFIED: 08/31/90   BY: afs *D066*               */
/* REVISION: 6.0      LAST MODIFIED: 10/16/90   BY: afs *D101*               */
/* REVISION: 6.0      LAST MODIFIED: 01/02/91   BY: afs *D283*   (rev only)  */
/* REVISION: 6.0      LAST MODIFIED: 06/24/91   BY: afs *D723*               */
/* REVISION: 6.0      LAST MODIFIED: 07/12/91   BY: afs *D760*   (rev only)  */
/* REVISION: 7.0      LAST MODIFIED: 11/25/91   BY: afs *F041*   (rev only)  */
/* REVISION: 7.0      LAST MODIFIED: 02/27/92   BY: jjs *F237*   (rev only)  */
/* REVISION: 7.0      LAST MODIFIED: 03/17/92   BY: TMD *F288*   (rev only)  */
/* REVISION: 7.0      LAST MODIFIED: 04/01/92   BY: tjs *F337*               */
/*                                   05/11/92   by: jms *F481*   (rev only)  */
/*                                   06/18/92   by: jjs *F670*               */
/*                                   07/29/92   by: jms *F829*   (rev only)  */
/*                                   09/15/94   by: ljm *GM57*   (rev only)  */
/*                                   04/10/96   by: jzw *G1P6*               */
/* REVISION: 8.6      LAST MODIFIED: 10/09/97   BY: bvm *K0PN*               */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 04/23/98   BY: *L00M* D. Sidel          */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98   BY: *L02Q* Brenda Milton     */
/* REVISION: 8.6E     LAST MODIFIED: 09/08/98   BY: *L08W* Russ Witt         */
/* REVISION: 8.6E     LAST MODIFIED: 10/14/98   BY: *L0BZ* Steve Goeke       */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.0      LAST MODIFIED: 08/08/05   BY: *SS - 20050808* Bill Jiang        */
/* SS - 20050808 - B */
{a6arcsrp01.i "new"}
/* SS - 20050808 - E */

/*****************************************************************************/

/*L0BZ*/ /* Changed ConvertMode from FullGUIReport to Report                 */

/*L00M*  {mfdtitle.i "f+ "} */
/*L00M*/ {mfdtitle.i "f+ "}

         /* ********** Begin Translatable Strings Definitions ********* */

         &SCOPED-DEFINE arcsrp01_p_1 "客户类型"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE arcsrp01_p_2 "去除有争议金额"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE arcsrp01_p_3 "帐龄日期"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE arcsrp01_p_4 "栏目天数"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE arcsrp01_p_5 "S-汇总/D-明细"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE arcsrp01_p_6 "打印发票说明"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE arcsrp01_p_7 "打印客户采购单"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE arcsrp01_p_8 "打印付款明细"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE arcsrp01_p_9 "打印主说明"
         /* MaxLen: Comment: */

         /* ********** End Translatable Strings Definitions ********* */

/*L02Q*/ /* THESE ARE NEEDED FOR FULL GUI REPORTS */
/*L02Q*/ {gprunpdf.i "mcpl" "p"}
/*L02Q*/ {gprunpdf.i "mcui" "p"}

         define new shared variable cust like ar_bill.
         define new shared variable cust1 like ar_bill.
         define new shared variable cust_type like cm_type
            label {&arcsrp01_p_1}.
         define new shared variable cust_type1 like cm_type.
         define new shared variable nbr like ar_nbr.
         define new shared variable nbr1 like ar_nbr.
         define new shared variable slspsn like sp_addr.
         define new shared variable slspsn1 like slspsn.
         define new shared variable acct_type like ar_acct.
         define new shared variable acct_type1 like ar_acct.
         define new shared variable due_date like ar_due_date.
         define new shared variable due_date1 like ar_due_date.
         define new shared variable name like ad_name.
         define new shared variable age_days as integer extent 5
            label {&arcsrp01_p_4}.
         define new shared variable age_range as character extent 5
            format "X(16)".
         define new shared variable i as integer.
         define new shared variable age_amt like ar_amt extent 5.
         define new shared variable age_period as integer.
         define new shared variable cm_recno as recid.
         define new shared variable balance like cm_balance.
         define new shared variable age_paid like ar_amt extent 5.
         define new shared variable sum_amt  like ar_amt extent 5.
         define new shared variable show_pay_detail like mfc_logical
            label {&arcsrp01_p_8} initial no.
         define new shared variable summary_only like mfc_logical
            format {&arcsrp01_p_5} label {&arcsrp01_p_5} initial no.
         define new shared variable show_po like mfc_logical
            label {&arcsrp01_p_7} initial no.
         define new shared variable inv_tot like ar_amt.
         define new shared variable memo_tot like ar_amt.
         define new shared variable fc_tot like ar_amt.
         define new shared variable drft_tot like ar_amt.
         define new shared variable paid_tot like ar_amt.
         define new shared variable base_amt like ar_amt.
         define new shared variable base_applied like ar_applied.
         define new shared variable base_rpt like ar_curr.
         define new shared variable age_date like ar_due_date
            label {&arcsrp01_p_3}
            initial today.
         define new shared variable due-date like ar_date.
         define new shared variable applied-amt like ar_applied.
         define new shared variable amt-due like ar_amt.
         define new shared variable this-applied like ar_applied.
         define new shared variable closed like mfc_logical.
         define new shared variable multi-due like mfc_logical.
         define new shared variable deduct_contest like mfc_logical
            label {&arcsrp01_p_2}.
         define new shared variable contested as character format "x(5)".
         define new shared variable curr_amt like ar_amt.
         define new shared variable show_comments like mfc_logical
            label {&arcsrp01_p_6} initial no.
         define new shared variable show_mstr_comments like mfc_logical
            label {&arcsrp01_p_9} initial no.
         define new shared variable mstr_type like cd_type initial "AR".
         define new shared variable mstr_lang like cd_lang.
         define new shared variable entity like gl_entity.
         define new shared variable entity1 like gl_entity.
         define new shared variable lstype like ls_type.

/*L02Q*/ define new shared variable mc-rpt-curr like ar_curr no-undo.
/*L02Q*/ define variable mc-dummy-fixed like so_fix_rate no-undo.


/*L00M*  * BEGIN ADDED SECTION */
         {etrpvar.i &new = "new"}
         {etvar.i   &new = "new"}
         {eteuro.i}
/*L02Q*  define variable input_curr   like ex_curr no-undo. */
/*L02Q*  define new shared variable display_curr like base_rpt no-undo. */
/*L00M*  * END ADDED SECTION */

         form
            cust           colon 15
            cust1          label {t001.i} colon 49 skip
            cust_type      colon 15
            cust_type1     label {t001.i} colon 49 skip
            due_date       colon 15
            due_date1      label {t001.i} colon 49 skip
            nbr            colon 15
            nbr1           label {t001.i} colon 49 skip
            slspsn         colon 15
            slspsn1        label {t001.i} colon 49
            acct_type      colon 15
            acct_type1     label {t001.i} colon 49 skip
            entity         colon 15
            entity1        label {t001.i} colon 49
            lstype         colon 15 /*L00M skip(1) */
/*L00M*/    skip
/*L00M*     age_date        colon 18  show_po            colon 50 */
/*L00M*/    age_date        colon 22  show_po            colon 58
/*L00M*     summary_only    colon 18  show_pay_detail    colon 50 */
/*L00M*/    summary_only    colon 22  show_pay_detail    colon 58
/*L00M*     base_rpt        colon 18  show_comments      colon 50 */
/*L00M*/    base_rpt        colon 22  show_comments      colon 58
/*L02Q*/    et_report_curr  colon 22
/*L02Q* /*L00M*/ et_report_txt   to 22     no-label */
/*L02Q* /*L00M*/ et_report_curr  /*colon 22*/  no-label */
/*L00M*/    deduct_contest     colon 58
/*L00M*/    mstr_lang
/*L00M      deduct_contest    colon 18  show_mstr_comments  colon 50 */
/*L02Q* /*L00M*/ et_rate_txt     to 22     no-label */
/*L02Q* /*L00M*/ et_report_rate    /*colon 22*/ no-label */
/*L00M*/    show_mstr_comments        colon 58
            mstr_type
            /*V8! space(.2) */
            mstr_lang skip (1)
/*L00M*     /*V8! space(.2) */ mstr_lang */ skip
            space(1)
            age_days[1]
            age_days[2]    label "[2]"
            age_days[3]    label "[3]"
            age_days[4]    label "[4]"  skip (1)
/*L00M* (1) */
         with frame a side-labels
/*L00M*/ no-attr-space
         width 80.

/*L02Q*  {wbrp01.i} */

         repeat:

            if nbr1 = hi_char then nbr1 = "".
            if cust1 = hi_char then cust1 = "".
            if cust_type1 = hi_char then cust_type1 = "".
            if due_date = low_date then due_date = ?.
            if due_date1 = hi_date then due_date1 = ?.
            if slspsn1 = hi_char then slspsn1 = "".
            if acct_type1 = hi_char then acct_type1 = "".
            if entity1 = hi_char then entity1 = "".
            do i = 1 to 5:
               if age_days[i] = 0 then age_days[i] = ((i - 1) * 30).
            end.

/*L02Q* /*L00M*/ display et_report_txt */
/*L02Q* /*L00M*/ et_rate_txt */
/*L02Q* /*L00M*/ with frame a. */

/*L02Q*     if c-application-mode <> 'web':u then */
            update
               cust cust1 cust_type cust_type1 due_date due_date1 nbr nbr1
               slspsn slspsn1 acct_type acct_type1
               entity entity1
               lstype
               age_date summary_only base_rpt
/*L00M*/       et_report_curr
/*L02Q* /*L00M*/  et_report_rate */
/*L00M*        deduct_contest */
               show_po show_pay_detail show_comments
/*L00M*/       deduct_contest
               show_mstr_comments
/*L00M*/       mstr_lang
               mstr_type
/*L00M*        mstr_lang */
               age_days[1 for 4]
               with frame a.

/*L00M*     * SECTION REMOVED *
 *          {wbrp06.i &command = update &fields = "  cust cust1 cust_type
 *           cust_type1 due_date due_date1 nbr nbr1 slspsn slspsn1 acct_type
 *           acct_type1 entity entity1 lstype age_date summary_only base_rpt
 *           deduct_contest show_po show_pay_detail
 *           show_comments  show_mstr_comments mstr_type mstr_lang
 *           age_days [ 1 for 4 ]" &frm = "a"}
 */

/*L00M*     * ADD SECTION */
/*L02Q*     {wbrp06.i &command = update &fields = "  cust cust1 cust_type
 *           cust_type1 due_date due_date1 nbr nbr1 slspsn slspsn1 acct_type
 *           acct_type1 entity entity1  lstype age_date summary_only base_rpt
 *           et_report_curr
 *           et_report_rate
 *           show_po show_pay_detail deduct_contest
 *           show_comments  show_mstr_comments mstr_lang mstr_type
 *           age_days [ 1 for 4 ]"
 *           &frm = "a"}
 *L02Q*/
/*L00M*     * END ADD SECTION */

/*L02Q* /*L00M*/ if et_report_curr = "" then assign display_curr = base_rpt. */
/*L02Q* /*L00M*/ else assign display_curr = et_report_curr. */

/*L02Q* /*L00M*/ {etcurval.i &curr   = "et_report_curr" &errlevel = "4" */
/*L02Q* /*L00M*/             &action = "next"           &prompt   = "pause" } */

/*L00M*/    assign et_eff_date = age_date.
/*L02Q* /*L00M*/ if base_rpt = "base" then assign input_curr = "". */
/*L02Q* /*L00M*/ else assign input_curr = base_rpt. */
/*L02Q* /*L00M*/ {gprun.i ""etrate.p"" "(input input_curr)"} */

/*L02Q*     if (c-application-mode <> 'web':u) or */
/*L02Q*     (c-application-mode = 'web':u and */
/*L02Q*     (c-web-request begins 'data':u)) then do: */

/*L08W*     Code below to be wrapped in a 'do' code block for correct GUI conversion  */
/*L08W*/    do:

            bcdparm = "".
            {mfquoter.i cust        }
            {mfquoter.i cust1       }
            {mfquoter.i cust_type   }
            {mfquoter.i cust_type1  }
            {mfquoter.i due_date    }
            {mfquoter.i due_date1   }
            {mfquoter.i nbr         }
            {mfquoter.i nbr1        }
            {mfquoter.i slspsn      }
            {mfquoter.i slspsn1     }
            {mfquoter.i acct_type   }
            {mfquoter.i acct_type1  }
            {mfquoter.i entity      }
            {mfquoter.i entity1     }
            {mfquoter.i lstype      }
            {mfquoter.i age_date    }
            {mfquoter.i summary_only}
            {mfquoter.i base_rpt    }
/*L00M*/    {mfquoter.i et_report_curr }
/*L02Q* /*L00M*/  {mfquoter.i et_report_rate } */
/*L00M*     {mfquoter.i deduct_contest} */
            {mfquoter.i show_po     }
            {mfquoter.i show_pay_detail}
            {mfquoter.i show_comments}
/*L00M*/    {mfquoter.i deduct_contest}
            {mfquoter.i show_mstr_comments}
/*L00M*/    {mfquoter.i mstr_lang   }
            {mfquoter.i mstr_type   }
/*L00M*     {mfquoter.i mstr_lang   } */
            {mfquoter.i age_days[1] }
            {mfquoter.i age_days[2] }
            {mfquoter.i age_days[3] }
            {mfquoter.i age_days[4] }

            if cust1 = "" then cust1 = hi_char.
            if cust_type1 = "" then cust_type1 = hi_char.
            if due_date = ? then due_date = low_date.
            if due_date1 = ? then due_date1 = hi_date.
            if nbr1 = "" then nbr1 = hi_char.
            if slspsn1 = "" then slspsn1 = hi_char.
            if acct_type1 = "" then acct_type1 = hi_char.
            if entity1 = "" then entity1 = hi_char.

/*L0BZ*/    /* Validate currency */
/*L0BZ*/    run ip-chk-valid-curr
/*L0BZ*/       (input  base_rpt,
/*L0BZ*/        output mc-error-number).

/*L0BZ*/    if mc-error-number <> 0 then do:
/*L0BZ*/       next-prompt base_rpt with frame a.
/*L0BZ*/       undo, retry.
/*L0BZ*/    end.

/*L0BZ*/    /* Validate reporting currency */
/*L0BZ*/    run ip-chk-valid-curr
/*L0BZ*/       (input  et_report_curr,
/*L0BZ*/        output mc-error-number).

/*L0BZ*/    if mc-error-number = 0 then do:

/*L0BZ*/       /* Default currencies if blank */
/*L0BZ*/       mc-rpt-curr = if base_rpt = "" then base_curr else base_rpt.
/*L0BZ*/       if et_report_curr = "" then et_report_curr = mc-rpt-curr.

/*L0BZ*/       /* Prompt for exchange rate and format for output */
/*L0BZ*/       run ip-ex-rate-setup
/*L0BZ*/          (input  et_report_curr,
/*L0BZ*/           input  mc-rpt-curr,
/*L0BZ*/           input  " ",
/*L0BZ*/           input  et_eff_date,
/*L0BZ*/           output et_rate2,
/*L0BZ*/           output et_rate1,
/*L0BZ*/           output mc-exch-line1,
/*L0BZ*/           output mc-exch-line2,
/*L0BZ*/           output mc-error-number).

/*L0BZ*/    end.  /* if mc-error-number = 0 */

/*L0BZ*/    if mc-error-number <> 0 then do:
/*L0BZ*/       next-prompt et_report_curr with frame a.
/*L0BZ*/       undo, retry.
/*L0BZ*/    end.

/*L0BZ* /*L02Q*/ if base_rpt <> "" then
 *L0BZ* /*L02Q*/    mc-rpt-curr = base_rpt.
 *L0BZ* /*L02Q*/ else mc-rpt-curr = base_curr.
 *L0BZ* /*L02Q*/ if et_report_curr <> "" then do:
 *L0BZ* /*L02Q*/    {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
 *L0BZ*               "(input et_report_curr,
 *L0BZ*                 output mc-error-number)"}
 *L0BZ* /*L02Q*/    if mc-error-number = 0
 *L0BZ* /*L02Q*/    and et_report_curr <> mc-rpt-curr then do:
 *L0BZ* /*L08W*        CURRENCIES AND RATES REVERSED BELOW...             */
 *L0BZ* /*L02Q*/       {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
 *L0BZ*                  "(input et_report_curr,
 *L0BZ*                    input mc-rpt-curr,
 *L0BZ*                    input "" "",
 *L0BZ*                    input et_eff_date,
 *L0BZ*                    output et_rate2,
 *L0BZ*                    output et_rate1,
 *L0BZ*                    output mc-seq,
 *L0BZ*                    output mc-error-number)"}
 *L0BZ* /*L02Q*/    end.  /* if mc-error-number = 0 */
 *L0BZ* /*L02Q*/    if mc-error-number <> 0 then do:
 *L0BZ* /*L02Q*/       {mfmsg.i mc-error-number 3}
 *L0BZ* /*L02Q*/       next-prompt et_report_curr with frame a.
 *L0BZ* /*L02Q*/       undo, retry.
 *L0BZ* /*L02Q*/    end.  /* if mc-error-number <> 0 */
 *L0BZ* /*L02Q*/    else if et_report_curr <> mc-rpt-curr then do:
 *L0BZ* /*L08W*        CURRENCIES AND RATES REVERSED BELOW...             */
 *L0BZ* /*L02Q*/       {gprunp.i "mcui" "p" "mc-ex-rate-input"
 *L0BZ*                  "(input et_report_curr,
 *L0BZ*                    input mc-rpt-curr,
 *L0BZ*                    input et_eff_date,
 *L0BZ*                    input mc-seq,
 *L0BZ*                    input false,
 *L0BZ*                    input 5,
 *L0BZ*                    input-output et_rate2,
 *L0BZ*                    input-output et_rate1,
 *L0BZ*                    input-output mc-dummy-fixed)"}
 *L0BZ* /*L08W*        CURRENCIES AND RATES REVERSED BELOW...             */
 *L0BZ* /*L02Q*/       {gprunp.i "mcui" "p" "mc-ex-rate-output"
 *L0BZ*                  "(input et_report_curr,
 *L0BZ*                    input mc-rpt-curr,
 *L0BZ*                    input et_rate2,
 *L0BZ*                    input et_rate1,
 *L0BZ*                    input mc-seq,
 *L0BZ*                    output mc-exch-line1,
 *L0BZ*                    output mc-exch-line2)"}
 *L0BZ* /*L02Q*/       {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
 *L0BZ*                  "(input mc-seq)"}
 *L0BZ* /*L02Q*/    end.  /* else do */
 *L0BZ* /*L02Q*/ end.  /* if et_report_curr <> "" */
 *L0BZ* /*L02Q*/ if et_report_curr = "" or et_report_curr = mc-rpt-curr then
 *L0BZ* /*L02Q*/    assign
 *L0BZ* /*L02Q*/       mc-exch-line1 = ""
 *L0BZ* /*L02Q*/       mc-exch-line2 = ""
 *L0BZ* /*L02Q*/       et_report_curr = mc-rpt-curr.
 *L0BZ*/

/*L02Q*     end.  /* if (c-application-mode <> 'web':u) ... */ */
/*L08W*/    end.

            /* SELECT PRINTER */
            {mfselbpr.i "printer" 132}

                /* SS - 20050808 - B */
                /*
            {gprun.i ""arcsrp1a.p""}

            {mfrtrail.i}
                */
                FOR EACH tta6arcsrp01:
                    DELETE tta6arcsrp01.
                END.

                {gprun.i ""a6arcsrp01.p"" "(
                INPUT cust,
                INPUT cust1,
                INPUT cust_type,
                INPUT cust_type1,
                INPUT due_date,
                INPUT due_date1,
                INPUT nbr,
                INPUT nbr1,
                INPUT slspsn,
                INPUT slspsn1,
                INPUT acct_type,
                INPUT acct_type1,
                INPUT entity,
                INPUT entity1,
                INPUT lstype,

                INPUT age_date,
                INPUT SUMMARY_only,
                INPUT base_rpt,
                INPUT et_report_curr,
                INPUT show_po,
                INPUT show_pay_detail,
                INPUT show_comments,
                INPUT deduct_contest,
                INPUT mstr_lang,
                INPUT show_mstr_comments,
                INPUT mstr_type,

                INPUT age_days[1],
                INPUT age_days[2],
                INPUT age_days[3],
                INPUT age_days[4],
                INPUT age_days[5]
                )"}

                EXPORT DELIMITER ";" "bill" "acct" "cc" "nbr" "type" "due_date" "amt1" "amt2" "amt3" "amt4" "amt5" "amt".
                FOR EACH tta6arcsrp01:
                    EXPORT DELIMITER ";" tta6arcsrp01_bill tta6arcsrp01_acct tta6arcsrp01_cc tta6arcsrp01_nbr tta6arcsrp01_type tta6arcsrp01_due_date tta6arcsrp01_amt1 tta6arcsrp01_amt2 tta6arcsrp01_amt3 tta6arcsrp01_amt4 tta6arcsrp01_amt5 tta6arcsrp01_amt.
                END.

                {a6mfrtrail.i}
                /* SS - 20050808 - E */

         end.  /* repeat */

/*L02Q*  {wbrp04.i &frame-spec = a} */


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
                  {mfmsg.i o_error 3}
               end.

            end.  /* do transaction */


         end procedure.  /* ip-ex-rate-setup */
