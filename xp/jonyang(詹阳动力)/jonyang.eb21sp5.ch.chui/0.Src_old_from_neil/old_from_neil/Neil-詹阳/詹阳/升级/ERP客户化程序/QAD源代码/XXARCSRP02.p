/* GUI CONVERTED from arcsrp02.p (converter v1.71) Thu Oct 15 10:01:31 1998 */
/* arcsrp02.p - AR AGING REPORT FROM AR DATE                                 */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.      */
/*F0PN*/ /*K0PY*/ /*V8#ConvertMode=WebReport                                 */
/*V8:ConvertMode=Report                                                      */
/*L02Q*/ /*V8:WebEnabled=No                                                  */
/* REVISION: 1.0      LAST MODIFIED: 08/14/86   BY: PML-01                   */
/* REVISION: 6.0      LAST MODIFIED: 09/06/90   BY: afs *D059*               */
/* REVISION: 6.0      LAST MODIFIED: 09/06/90   BY: afs *D066*               */
/* REVISION: 6.0      LAST MODIFIED: 10/16/90   BY: afs *D101*               */
/* REVISION: 6.0      LAST MODIFIED: 01/02/91   BY: afs *D283*   (rev only)  */
/* REVISION: 6.0      LAST MODIFIED: 06/24/91   BY: afs *D723*               */
/* REVISION: 7.0      LAST MODIFIED: 11/26/91   BY: afs *F041*   (rev only)  */
/* REVISION: 7.0      LAST MODIFIED: 02/27/92   BY: jjs *F237*   (rev only)  */
/* REVISION: 7.0      LAST MODIFIED: 04/01/92   BY: tjs *F337*               */
/*                                   05/11/92   by: jms *F481*   (rev only)  */
/*                                   06/18/92   by: jjs *F670*               */
/*                                   07/29/92   by: jms *F829*   (rev only)  */
/* REVISION: 7.3      LAST MODIFIED: 08/10/93   by: jms *GE05*   (rev only)  */
/* REVISION: 7.3      LAST MODIFIED: 09/15/94   by: ljm *GM57*   (rev only)  */
/* REVISION: 7.3      LAST MODIFIED: 04/10/96   by: jzw *G1P6*               */
/* REVISION: 8.6      LAST MODIFIED: 10/09/97   by: bvm *K0PY*               */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 04/23/98   BY: *L00S* D. Sidel          */
/* REVISION: 8.6E     LAST MODIFIED: 05/14/98   BY: *L00Z* AWe               */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98   BY: *L02Q* Brenda Milton     */
/* REVISION: 8.6E     LAST MODIFIED: 09/08/98   BY: *L08W* Russ Witt         */
/* REVISION: 8.6E     LAST MODIFIED: 10/02/98   BY: *L0B4* Brenda Milton     */
/* REVISION: 8.6E     LAST MODIFIED: 10/14/98   BY: *L0BZ* Steve Goeke       */

/*****************************************************************************/

/*L0BZ*/ /* Changed ConvertMode from FullGUIReport to Report                 */

/*L00S*  {mfdtitle.i "e+ "} */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*L00S*/ {mfdtitle.i "e+ "}

         /* ********** Begin Translatable Strings Definitions ********* */

         &SCOPED-DEFINE arcsrp02_p_1 "打印主说明"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE arcsrp02_p_2 "打印付款明细"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE arcsrp02_p_3 "打印发票说明"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE arcsrp02_p_4 "打印客户采购单"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE arcsrp02_p_5 "S-汇总/D-明细"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE arcsrp02_p_6 "栏目天数"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE arcsrp02_p_7 "帐龄日期"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE arcsrp02_p_8 "去除有争议金额"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE arcsrp02_p_9 "客户类型"
         /* MaxLen: Comment: */

         /* ********** End Translatable Strings Definitions ********* */

/*L02Q*/  /* THESE ARE NEEDED FOR FULL GUI REPORTS */
/*L02Q*/  {gprunpdf.i "mcpl" "p"}
/*L02Q*/  {gprunpdf.i "mcui" "p"}

          define new shared variable cust like ar_bill.
          define new shared variable cust1 like ar_bill.
          define new shared variable cust_type like cm_type
             label {&arcsrp02_p_9}.
          define new shared variable cust_type1 like cm_type.
          define new shared variable ardate like ar_date.
          define new shared variable ardate1 like ar_date.
          define new shared variable nbr like ar_nbr.
          define new shared variable nbr1 like ar_nbr.
          define new shared variable slspsn like sp_addr.
          define new shared variable slspsn1 like slspsn.
          define new shared variable acct_type like ar_acct.
          define new shared variable acct_type1 like ar_acct.
          define new shared variable age_date like ar_due_date
             label {&arcsrp02_p_7} initial today.
          define new shared variable summary_only like mfc_logical
             label {&arcsrp02_p_5} initial no format {&arcsrp02_p_5}.
          define new shared variable base_rpt like ar_curr.
          define new shared variable deduct_contest like mfc_logical
             label {&arcsrp02_p_8} initial no.
          define new shared variable show_po like mfc_logical
             label {&arcsrp02_p_4} initial no.
          define new shared variable show_pay_detail like mfc_logical
             label {&arcsrp02_p_2} initial no.
          define new shared variable show_comments like mfc_logical
             label {&arcsrp02_p_3} initial no.
          define new shared variable show_mstr_comments like mfc_logical
             label {&arcsrp02_p_1} initial no.
          define new shared variable age_days as integer extent 4
             label {&arcsrp02_p_6}.
          define new shared variable mstr_type like cd_type initial "AR".
          define new shared variable mstr_lang like cd_lang.
          define new shared variable entity like gl_entity.
          define new shared variable entity1 like gl_entity.
          define new shared variable lstype like ls_type.

          define variable i as integer.

/*L02Q*/  define new shared variable mc-rpt-curr like ar_curr no-undo.
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
             
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
cust           colon 15
             cust1          label {t001.i} colon 49 skip
             cust_type      colon 15
             cust_type1     label {t001.i} colon 49 skip
             ardate         colon 15
             ardate1        label {t001.i} colon 49 skip
             nbr            colon 15
             nbr1           label {t001.i} colon 49 skip
             slspsn         colon 15
             slspsn1        label {t001.i} colon 49 skip
             acct_type      colon 15
             acct_type1     label {t001.i} colon 49 skip
             entity         colon 15
             entity1        label {t001.i} colon 49
             lstype         colon 15  skip(1)
/*L00S*/     skip
/*L00S*      age_date        colon 18  show_po            colon 50 */
/*L00S*/     age_date        colon 22  show_po            colon 58
/*L00S*      summary_only    colon 18  show_pay_detail    colon 50 */
/*L00S*/     summary_only    colon 22  show_pay_detail    colon 58
/*L00S*      base_rpt        colon 18  show_comments      colon 50 */
/*L00S*/     base_rpt        colon 22  show_comments      colon 58
/*L02Q*/     et_report_curr  colon 22
/*L02Q* /*L00S*/ et_report_txt   to 22 no-label */
/*L02Q* /*L00S*/ et_report_curr  no-label */
/*L00Z       colon 22 */
/*L00S*/     deduct_contest     colon 58
/*L00S*/     mstr_lang
/*L00S       deduct_contest  colon 18  show_mstr_comments  colon 50 */
/*L02Q* /*L00S*/ et_rate_txt to 22 no-label */
/*L02Q* /*L00S*/ et_report_rate   no-label */
/*L00Z       colon 22 */
/*L00S*/     show_mstr_comments  colon 58
             mstr_type
/*L00S /*V8! space(.2) */ mstr_lang */
             space(1)
             age_days[1]
             age_days[2]    label "[2]"
             age_days[3]    label "[3]" skip (1)
/*L00S*      (1) */
          with frame a side-labels
/*L00S*/  no-attr-space
          width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/*L00S*   form... */
/*L02Q*   form header */
/*L02Q* /*L00S*/   et_report_txt to 65 et_disp_curr */
/*L02Q*   with frame phead2 width 132 no-labels page-top. */

/*L02Q*   {wbrp01.i} */

          repeat:

             if cust1 = hi_char then cust1 = "".
             if cust_type1 = hi_char then cust_type1 = "".
             if ardate = low_date then ardate = ?.
             if ardate1 = hi_date then ardate1 = ?.
             if nbr1 = hi_char then nbr1 = "".
             if slspsn1 = hi_char then slspsn1 = "".
             if acct_type1 = hi_char then acct_type1 = "".
             if entity1 = hi_char then entity1 = "".

             do i = 1 to 4:
                if age_days[i] = 0 then age_days[i] = (i * 30).
             end.

/*L02Q* /*L00S*/ display et_report_txt */
/*L02Q* /*L00S*/ et_rate_txt with frame a. */

/*L02Q*      if c-application-mode <> 'web':u then */
                update cust cust1 cust_type cust_type1 ardate ardate1 nbr nbr1
                       slspsn slspsn1 acct_type acct_type1 entity entity1
                       lstype
                       age_date summary_only base_rpt
/*L00S*/               et_report_curr
/*L02Q* /*L00S*/       et_report_rate */
/*L00S*                deduct_contest */
                       show_po show_pay_detail show_comments
/*L00S*/               deduct_contest
                       show_mstr_comments
/*L00S*/               mstr_lang
                       mstr_type
/*L00S*                mstr_lang */
                       age_days[1 for 3] with frame a.

/*L00S*      * DELETED SECTION *
 *           {wbrp06.i &command = update &fields = "  cust cust1 cust_type
 *            cust_type1 ardate ardate1 nbr nbr1 slspsn slspsn1 acct_type
 *            acct_type1 entity entity1 lstype age_date summary_only base_rpt
 *            deduct_contest show_po show_pay_detail show_comments
 *            show_mstr_comments mstr_type mstr_lang age_days [ 1 for 3 ]"
 *            &frm = "a"}
 */

/*L00S*      * ADD SECTION */
/*L02Q*      {wbrp06.i &command = update &fields = "  cust cust1 cust_type
 *            cust_type1 ardate ardate1 nbr nbr1 slspsn slspsn1 acct_type
 *            acct_type1 entity  entity1 lstype age_date summary_only base_rpt
 *            et_report_curr
 *            et_report_rate
 *            show_po show_pay_detail deduct_contest
 *            show_comments  show_mstr_comments mstr_lang mstr_type
 *            age_days [ 1 for 3 ]"   &frm = "a"}
 *L02Q*/
/*L00S*      * END ADD SECTION */

/*L02Q* /*L00S*/ if et_report_curr = "" then assign display_curr = base_rpt. */
/*L02Q* /*L00S*/ else assign display_curr = et_report_curr. */

/*L02Q*
 *  /*L00S*/ {etcurval.i &curr     = "et_report_curr"  &errlevel = "4"
 *  /*L00S*/             &action   = "next"            &prompt   = "pause" }
 *  /*L00S*/ assign et_eff_date = age_date.
 *  /*L00S*/ if base_rpt = "base" then assign input_curr = "".
 *  /*L00S*/ else assign input_curr = base_rpt.
 *  /*L00S*/ {gprun.i ""etrate.p"" "(input input_curr)"}
 *L02Q*/

/*L02Q*      if (c-application-mode <> 'web':u) or */
/*L02Q*      (c-application-mode = 'web':u and */
/*L02Q*      (c-web-request begins 'data':u)) then do: */

/*L08W*     Code below to be wrapped in a 'do' code block for  */
/*L08W*     correct GUI conversion  */
/*L08W*/    do:
               bcdparm = "".
               {mfquoter.i cust         }
               {mfquoter.i cust1        }
               {mfquoter.i cust_type    }
               {mfquoter.i cust_type1   }
               {mfquoter.i ardate       }
               {mfquoter.i ardate1      }
               {mfquoter.i nbr          }
               {mfquoter.i nbr1         }
               {mfquoter.i slspsn       }
               {mfquoter.i slspsn1      }
               {mfquoter.i acct_type    }
               {mfquoter.i acct_type1   }
               {mfquoter.i entity       }
               {mfquoter.i entity1      }
               {mfquoter.i lstype }
               {mfquoter.i age_date     }
               {mfquoter.i summary_only }
               {mfquoter.i base_rpt     }
/*L00S*/       {mfquoter.i et_report_curr }
/*L02Q* /*L00S*/{mfquoter.i et_report_rate } */
/*L00S*        {mfquoter.i deduct_contest} */
               {mfquoter.i show_po      }
               {mfquoter.i show_pay_detail}
               {mfquoter.i show_comments}
/*L00S*/       {mfquoter.i deduct_contest}
               {mfquoter.i show_mstr_comments}
/*L00S*/       {mfquoter.i mstr_lang   }
               {mfquoter.i mstr_type    }
/*L00S*        {mfquoter.i mstr_lang   } */
               {mfquoter.i age_days[1]  }
               {mfquoter.i age_days[2]  }
               {mfquoter.i age_days[3]  }

               if cust1 = "" then cust1 = hi_char.
               if cust_type1 = "" then cust_type1 = hi_char.
               if ardate = ? then ardate = low_date.
               if ardate1 = ? then ardate1 = hi_date.
               if nbr1 = "" then nbr1 = hi_char.
               if slspsn1 = "" then slspsn1 = hi_char.
               if acct_type1 = "" then acct_type1 = hi_char.
               if entity1 = "" then entity1 = hi_char.
/*L0B4*/       et_eff_date = age_date.

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
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.

             {mfphead.i}

/*L02Q* /*L00S*/     view frame phead2. */

             {gprun.i ""xxarcsrp2a.p""}

/*L02Q* /*L00S*/     hide frame phead2 no-pause. */

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
