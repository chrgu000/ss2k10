/* xxarcsrp06.p - AR AGING REPORT FROM AR EFF DATE                          */
/* GUI CONVERTED from arcsrp05.p (converter v1.71) Thu Oct 15 10:01:33 1998 */
/* arcsrp05.p - AR AGING REPORT FROM AR EFF DATE                             */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.      */
/*F0PN*/ /*K0Q0*/ /*V8#ConvertMode=WebReport                                 */
/*V8:ConvertMode=Report                                                      */
/*L02Q*/ /*V8:WebEnabled=No                                                  */
/* REVISION: 4.0      LAST MODIFIED: 08/26/88   BY: pml                      */
/* REVISION: 6.0      LAST MODIFIED: 09/07/90   BY: afs *D059*               */
/* REVISION: 6.0      LAST MODIFIED: 09/07/90   BY: afs *D066*               */
/* REVISION: 6.0      LAST MODIFIED: 10/16/90   BY: afs *D101*               */
/* REVISION: 6.0      LAST MODIFIED: 01/02/91   BY: afs *D283*   (rev only)  */
/* REVISION: 6.0      LAST MODIFIED: 06/24/91   BY: afs *D723*               */
/* REVISION: 7.0      LAST MODIFIED: 11/26/91   BY: afs *F041*   (rev only)  */
/* REVISION: 7.0      LAST MODIFIED: 02/27/92   BY: jjs *F237*   (rev only)  */
/* REVISION: 7.0      LAST MODIFIED: 04/01/92   BY: tjs *F337*               */
/* REVISION: 7.0      LAST MODIFIED: 04/30/92   BY: MLV *F446*               */
/*                                   05/12/92   by: jms *F481*   (rev only)  */
/*                                   06/18/92   by: jjs *F670*               */
/*                                   07/29/92   by: jms *F829*   (rev only)  */
/* REVISION: 7.3      LAST MODIFIED: 03/10/93   by: jms *G795*   (rev only)  */
/*                                   03/18/93   by: jjs *G843*   (rev only)  */
/*                                   04/12/93   by: jjs *G944*   (rev only)  */
/*                                   04/08/94   by: wep *FN23*               */
/*                                   08/23/94   by: rxm *GL40*               */
/*                                   09/10/94   by: rxm *FQ94*               */
/*                                   04/10/96   by: jzw *G1P6*               */
/* REVISION: 8.6      LAST MODIFIED: 10/09/97   by: bvm *K0Q0*               */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 05/05/98   BY: *L00S* D. Sidel          */
/* REVISION: 8.6E     LAST MODIFIED: 07/06/98   BY: *L02Q* Brenda Milton     */
/* REVISION: 8.6E     LAST MODIFIED: 09/08/98   BY: *L08W* Russ Witt         */
/* REVISION: 8.6E     LAST MODIFIED: 10/14/98   BY: *L0BZ* Steve Goeke       */
/* REVISION: 8.6E     LAST MODIFIED: 10/14/2000   BY: *JY003* **Frankie Xu*  */

/*****************************************************************************/

/*L0BZ*/ /* Changed ConvertMode from FullGUIReport to Report                 */

/*L00S*  {mfdtitle.i "e+ "} */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*L00S*/ {mfdtitle.i "e+ "}

         /* ********** Begin Translatable Strings Definitions ********* */

         &SCOPED-DEFINE arcsrp05_p_1 "必须是 DUE, EFF, 或 INV, 请重新输入。"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE arcsrp05_p_2 "栏目天数"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE arcsrp05_p_3 "按日期(DUE,EFF,INV)算帐龄"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE arcsrp05_p_4 "客户类型"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE arcsrp05_p_5 "打印客户采购单"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE arcsrp05_p_6 "打印主说明"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE arcsrp05_p_7 "打印付款明细"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE arcsrp05_p_8 "打印发票说明"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE arcsrp05_p_9 "S-汇总/D-明细"
         /* MaxLen: Comment: */

         /* ********** End Translatable Strings Definitions ********* */

/*L02Q*/  /* THESE ARE NEEDED FOR FULL GUI REPORTS */
/*L02Q*/  {gprunpdf.i "mcpl" "p"}
/*L02Q*/  {gprunpdf.i "mcui" "p"}

          define new shared variable cust like ar_bill.
          define new shared variable cust1 like ar_bill.
          define new shared variable cust_type like cm_type
             label {&arcsrp05_p_4}.
          define new shared variable cust_type1 like cm_type.
          define new shared variable nbr like ar_nbr.
          define new shared variable nbr1 like ar_nbr.
          define new shared variable slspsn like sp_addr.
          define new shared variable slspsn1 like slspsn.
          define new shared variable acct_type like ar_acct.
          define new shared variable acct_type1 like ar_acct.
          define new shared variable effdate1 like ar_effdate initial today.
          define new shared variable summary_only like mfc_logical
             label {&arcsrp05_p_9} format {&arcsrp05_p_9} initial no.
          define new shared variable base_rpt like ar_curr.
          define new shared variable show_po like mfc_logical
             label {&arcsrp05_p_5} initial no.
          define new shared variable show_pay_detail like mfc_logical
             label {&arcsrp05_p_7} initial no.
          define new shared variable show_comments like mfc_logical
             label {&arcsrp05_p_8} initial no.
          define new shared variable show_mstr_comments like mfc_logical
             label {&arcsrp05_p_6} initial no.
          define new shared variable age_days as integer extent 4
             label {&arcsrp05_p_2}.
          define new shared variable mstr_type like cd_type initial "AR".
          define new shared variable mstr_lang like cd_lang.
          define variable i as integer.
          define new shared variable entity like gl_entity.
          define new shared variable entity1 like gl_entity.
          define new shared variable lstype like ls_type.
          define new shared variable age_by as character format "x(3)" label
             {&arcsrp05_p_3} initial "DUE".

/*L02Q*/  define new shared variable mc-rpt-curr like base_rpt no-undo.
/*L02Q*/  define variable mc-dummy-fixed like so_fix_rate no-undo.

/*L00S*   * BEGIN ADDED SECTION */
          {etrpvar.i &new = "new"}
          {etvar.i   &new = "new"}
          {eteuro.i}
/*L02Q*   define variable input_curr   like ex_curr. */
/*L02Q*   define new shared variable display_curr like base_rpt. */
/*L00S*   * END ADDED SECTION */

          
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
             
							cust            colon 15
             cust1           label {t001.i} colon 49 skip
             cust_type       colon 15
             cust_type1      label {t001.i} colon 49 skip
             nbr             colon 15
             nbr1            label {t001.i} colon 49 skip
             slspsn          colon 15
             slspsn1         label {t001.i} colon 49 skip
             acct_type       colon 15
             acct_type1      label {t001.i} colon 49 skip
             entity          colon 15
             entity1         label {t001.i} colon 49
             lstype          colon 15 /*L00S skip(1)*/
/*L00S*/     skip
/***jy003*****
             age_by         colon  26
                validate((lookup(age_by,"DUE,EFF,INV") <> 0),
                {&arcsrp05_p_1})
             show_po            colon 60
             effdate1        colon 26  show_pay_detail    colon 60
             summary_only    colon 26  show_comments      colon 60
             base_rpt        colon 26  show_mstr_comments colon 60
/*L02Q*/     et_report_curr  colon 26
/*L02Q* /*L00S*/ et_report_txt   to    26 no-label */
/*L02Q* /*L00S*/ et_report_curr  /*colon 26*/ no-label */
             mstr_type colon 60
/*L00S*      mstr_lang */
/*L00S*      skip(1) */
/*L02Q* /*L00S*/ et_rate_txt    to    26 no-label */
/*L02Q* /*L00S*/ et_report_rate /*colon 26*/ no-label */
/*L00S*/     mstr_lang colon 60
/*L00S*/     skip(1)
             space(1)
             age_days[1]
             age_days[2]    label "[2]"
             age_days[3]    label "[3]" skip(1)
***jy003****/  skip(1)
          with frame a side-labels
/*L00S*/  no-attr-space
          width 80.

setFrameLabels(frame a:handle).
	
/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/*L00S*   form.... */
          FORM /*GUI*/  header
/*L02Q* /*L00S*/  et_report_txt to 65 et_disp_curr */
/*L02Q*/     mc-curr-label to 65 et_report_curr skip
/*L02Q*/     mc-exch-label to 65 mc-exch-line1 skip
/*L02Q*/     mc-exch-line2 at 67 skip(1)
          with STREAM-IO /*GUI*/  frame phead2
/*L02Q*   overlay */
          no-labels page-top
/*L02Q*/  width 132.

/*L02Q*   {wbrp01.i} */

          repeat:

             if cust1 = hi_char then cust1 = "".
             if cust_type1 = hi_char then cust_type1 = "".
             if nbr1 = hi_char then nbr1 = "".
             if slspsn1 = hi_char then slspsn1 = "".
             if acct_type1 = hi_char then acct_type1 = "".
             if entity1 = hi_char then entity1 = "".

             do i = 1 to 4:
                if age_days[i] = 0 then age_days[i] = (i * 30).
             end.

/*L02Q* /*L00S*/ display et_report_txt */
/*L02Q* /*L00S*/         et_rate_txt with frame a. */

/*L02Q*      if c-application-mode <> 'web':u then */
                update cust cust1 cust_type cust_type1 nbr nbr1 slspsn slspsn1
                       acct_type acct_type1 entity entity1
                       lstype
/***jy003****
                       age_by
                       effdate1 summary_only base_rpt
/*L00S*/               et_report_curr
/*L02Q* /*L00S*/       et_report_rate */
                       show_po show_pay_detail show_comments
                       show_mstr_comments mstr_type mstr_lang
                       age_days[1 for 3]
***jy003*****/
                with frame a.

/*L02Q*      {wbrp06.i &command = update &fields = "  cust cust1 cust_type
 *            cust_type1 nbr nbr1 slspsn slspsn1 acct_type acct_type1
 *            entity entity1  lstype   age_by
 *            effdate1 summary_only base_rpt
 *            show_po show_pay_detail
 *            show_comments
 * /*L00S*/   et_report_curr
 * /*L00S*/   et_report_rate
 *            show_mstr_comments mstr_type mstr_lang age_days [ 1 for 3 ]"
 *            &frm = "a"}
 *L02Q*/

/*L02Q* /*L00S*/ if et_report_curr = "" then assign display_curr = base_rpt. */
/*L02Q* /*L00S*/ else assign display_curr = et_report_curr. */

/*L02Q* /*L00S*/ {etcurval.i &curr   = "et_report_curr" &errlevel = "4" */
/*L02Q* /*L00S*/             &action = "next"           &prompt   = "pause" } */
/*L00S*/     assign et_eff_date = effdate1.
/*L02Q* /*L00S*/ if base_rpt = "base" then assign input_curr = "". */
/*L02Q* /*L00S*/ else assign input_curr = base_rpt. */
/*L02Q* /*L00S*/ {gprun.i ""etrate.p"" "(input input_curr)"} */

/*L02Q*      if (c-application-mode <> 'web':u) or */
/*L02Q*      (c-application-mode = 'web':u and */
/*L02Q*      (c-web-request begins 'data':u)) then do: */

/*L08W*     Code below to be wrapped in a 'do' code block for correct GUI conversion  */
/*L08W*/    do:
                bcdparm = "".
                {mfquoter.i cust        }
                {mfquoter.i cust1       }
                {mfquoter.i cust_type   }
                {mfquoter.i cust_type1  }
                {mfquoter.i nbr         }
                {mfquoter.i nbr1        }
                {mfquoter.i slspsn      }
                {mfquoter.i slspsn1     }
                {mfquoter.i acct_type   }
                {mfquoter.i acct_type1  }
                {mfquoter.i entity      }
                {mfquoter.i entity1     }
                {mfquoter.i lstype      }
                {mfquoter.i age_by     }
                {mfquoter.i effdate1    }
                {mfquoter.i summary_only}
                {mfquoter.i base_rpt    }
/*L00S*/        {mfquoter.i et_report_curr }
/*L02Q* /*L00S*/{mfquoter.i et_report_rate } */
                {mfquoter.i show_po     }
                {mfquoter.i show_pay_detail}
                {mfquoter.i show_comments}
                {mfquoter.i show_mstr_comments}
                {mfquoter.i mstr_type   }
                {mfquoter.i mstr_lang   }
                {mfquoter.i age_days[1] }
                {mfquoter.i age_days[2] }
                {mfquoter.i age_days[3] }

                if cust1 = "" then cust1 = hi_char.
                if cust_type1 = "" then cust_type1 = hi_char.
                if nbr1 = "" then nbr1 = hi_char.
                if slspsn1 = "" then slspsn1 = hi_char.
                if acct_type1 = "" then acct_type1 = hi_char.
                if entity1 = "" then entity1 = hi_char.

/*L0BZ*/        /* Validate currency */
/*L0BZ*/        run ip-chk-valid-curr
/*L0BZ*/           (input  base_rpt,
/*L0BZ*/            output mc-error-number).

/*L0BZ*/        if mc-error-number <> 0 then do:
/*L0BZ*/           next-prompt base_rpt with frame a.
/*L0BZ*/           undo, retry.
/*L0BZ*/        end.

/*L0BZ*/        /* Validate reporting currency */
/*L0BZ*/        run ip-chk-valid-curr
/*L0BZ*/           (input  et_report_curr,
/*L0BZ*/            output mc-error-number).

/*L0BZ*/        if mc-error-number = 0 then do:

/*L0BZ*/           /* Default currencies if blank */
/*L0BZ*/           mc-rpt-curr = if base_rpt = "" then base_curr else base_rpt.
/*L0BZ*/           if et_report_curr = "" then et_report_curr = mc-rpt-curr.

/*L0BZ*/           /* Prompt for exchange rate and format for output */
/*L0BZ*/           run ip-ex-rate-setup
/*L0BZ*/              (input  et_report_curr,
/*L0BZ*/               input  mc-rpt-curr,
/*L0BZ*/               input  " ",
/*L0BZ*/               input  et_eff_date,
/*L0BZ*/               output et_rate2,
/*L0BZ*/               output et_rate1,
/*L0BZ*/               output mc-exch-line1,
/*L0BZ*/               output mc-exch-line2,
/*L0BZ*/               output mc-error-number).

/*L0BZ*/        end.  /* if mc-error-number = 0 */

/*L0BZ*/        if mc-error-number <> 0 then do:
/*L0BZ*/           next-prompt et_report_curr with frame a.
/*L0BZ*/           undo, retry.
/*L0BZ*/        end.

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

/*L02Q*      end.  /* if (c-application-mode <> 'web':u) ... */ */
/*L08W*/     end.

             /* SELECT PRINTER */
             {mfselbpr.i "printer" 132}

             {mfphead.i}

/*L00S*/     view frame phead2.


/*jy003**     {gprun.i ""arcsrp5a.p""}     **/
/*jy003*/     {gprun.i ""xxarcsrp6a.p""}


/*L00S*/     hide frame phead2.

             /* REPORT TRAILER */
             {mfrtrail.i}

          end.  /* repeat */

/*L02Q*   {wbrp04.i &frame-spec = a} */


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
