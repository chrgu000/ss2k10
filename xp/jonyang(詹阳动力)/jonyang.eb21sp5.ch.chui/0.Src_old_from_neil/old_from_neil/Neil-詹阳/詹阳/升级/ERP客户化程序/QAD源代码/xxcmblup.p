/* GUI CONVERTED from arcsrp01.p (converter v1.71) Thu Oct 15 10:01:30 1998 */
/* arcsrp01.p - AR AGING REPORT FROM DUE DATE                                */
/* REVISION: 8.6E     LAST MODIFIED: 09/08/98   BY: *L08W* Russ Witt         */
/* REVISION: 8.6E     LAST MODIFIED: 10/14/98   BY: *L0BZ* Steve Goeke       */

/*L00M*  {mfdtitle.i "e+ "} */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*L00M*/ {mfdtitle.i "e+ "}

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
            format {&arcsrp01_p_5} label {&arcsrp01_p_5} initial yes.
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

         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
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
                  space(.2)   
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
         width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



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


/*L00M*/    assign et_eff_date = age_date.

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

/*L02Q*     end.  /* if (c-application-mode <> 'web':u) ... */ */
/*L08W*/    end.

            /* SELECT PRINTER */
            {mfselbpr.i "printer" 132}
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.


            {gprun.i ""xxcmblup1a.p""}

            {mfrtrail.i}

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
