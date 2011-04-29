/* GUI CONVERTED from apvorp04.p (converter v1.71) Thu Oct 15 10:01:29 1998 */
/* apvorp04.p - AP AGING REPORT as of effective date                         */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.      */
/*F0PN*/ /*K0P6*/ /*V8#ConvertMode=WebReport                                 */
/*V8:ConvertMode=Report                                                      */
/*L03L*/ /*V8:WebEnabled=No                                                  */
/* Revision: 4.0      LAST MODIFIED: 08/26/88   BY: pml  A412                */
/* REVISION: 6.0      LAST MODIFIED: 04/12/91   BY: MLV *D519*               */
/*                                   04/12/91   BY: MLV *D523*               */
/*                                   06/28/91   BY: MLV *D733*               */
/*                                   07/30/91   BY: bjb *D795*               */
/* REVISION: 7.0      LAST MODIFIED: 08/20/91   BY: MLV *F002*               */
/*                                   01/13/92   BY: MLV *F082*               */
/*                                   01/27/92   BY: MLV *F098*               */
/*                                   03/16/92   BY: TMD *F260*               */
/*                                   04/09/92   BY: MLV *F373*               */
/*                                   04/29/92   BY: MLV *F446*               */
/* REVISION: 7.3      LAST MODIFIED: 02/26/93   by: jms *G757*               */
/*                                   04/22/93   by: bcm *GA08*               */
/*                                   02/28/94   by: pmf *GI88*               */
/*                                   04/16/94   by: pcd *GJ41*               */
/*                                   08/24/94   by: cpp *GL39*               */
/*                                   09/10/94   by: rxm *FQ94*               */
/*                                   11/23/94   by: pmf *FU04*               */
/* REVISION: 8.5      LAST MODIFIED: 12/24/95   by: mwd *J053*               */
/*                                   04/08/96   by: jzw *G1LD*               */
/* REVISION: 8.6      LAST MODIFIED: 10/09/97   by: ckm *K0P6*               */
/* REVISION: 8.6      LAST MODIFIED: 01/06/98   BY: *J295* Irine D'mello     */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 04/17/98   BY: *J2G3* Niranjan R.       */
/* REVISION: 8.6E     LAST MODIFIED: 04/28/98   BY: *L00S* D. Sidel          */
/* REVISION: 8.6E     LAST MODIFIED: 05/14/98   BY: *L00Z* AWe               */
/* REVISION: 8.6E     LAST MODIFIED: 06/24/98   BY: *L01G* R. McCarthy       */
/* REVISION: 8.6E     LAST MODIFIED: 07/07/98   BY: *L03L* Brenda Milton     */
/* REVISION: 8.6E     LAST MODIFIED: 08/21/98   BY: *J2SQ* Abbas Hirkani     */
/* REVISION: 8.6E     LAST MODIFIED: 08/21/98   BY: *L06R* Brenda Milton     */
/* REVISION: 8.6E     LAST MODIFIED: 08/25/98   BY: *J2PS* Dana Tunstall     */
/* REVISION: 8.6E     LAST MODIFIED: 09/08/98   BY: *L08W* Russ Witt         */
/* Old ECO marker removed, but no ECO header exists *B660*                   */
/* REVISION: 8.6E     LAST MODIFIED: 10/14/98   BY: *L0BZ* Steve Goeke       */

/*****************************************************************************/

/*J2PS*/ /* ADDED NO-UNDO TO LOCAL VARIABLES, ADDED ASSIGN TO ASSIGNMENT     */
/*J2PS*/ /* STATEMENTS, CHANGED FOR FIRST/LAST TO FOR EACH                   */

/*L0BZ*/ /* Changed ConvertMode from FullGUIReport to Report                 */

         /* DISPLAY PROGRAM TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

         {mfdtitle.i "e+ "}

         /* ********** Begin Translatable Strings Definitions ********* */

         &SCOPED-DEFINE apvorp04_p_1 "报表"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp04_p_2 "凭证        "
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp04_p_3 "  合计:"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp04_p_4 "供应商"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp04_p_5 "供应商类型"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp04_p_6 "    合计金额"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp04_p_7 "凭证类型"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp04_p_8 "    天           "
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp04_p_9 "必须是 DUE, EFF, 或 INV, 请重新输入。"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp04_p_10 "按日期(DUE,EFF,INV)算帐龄"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp04_p_11 "兑换率  "
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp04_p_12 "多个"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp04_p_13 "栏目天数"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp04_p_14 "生效日期"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp04_p_15 "    按帐龄日期兑换率计算的合计金额-"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp04_p_16 "货币         "
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp04_p_17 "         差异:"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp04_p_18 "支付方式"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp04_p_19 "按基本货币计算的帐龄合计金额:"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp04_p_20 "到期日期"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp04_p_21 "       小于 "
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp04_p_22 " 超过 "
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp04_p_23 "发票        "
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp04_p_24 "发票日期"
         /* MaxLen: Comment: */

/*J2G3*/ /* HARDCODED LABEL  "Base     Supplier Totals:" HAS BEEN REPLACED */
         &SCOPED-DEFINE apvorp04_p_25 "基本        供应商合计:"
         /* MaxLen: 25 Comment: NO BLANK CHARACTERS SHOULD BE CONVERTED AND TRIMED */

/*J2G3*/ /* HARDCODED LABEL  "Base     Report   Totals:" HAS BEEN REPLACED */
         &SCOPED-DEFINE apvorp04_p_26 "基本        报表合计:"
         /* MaxLen: 25 Comment: NO BLANK CHARACTERS SHOULD BE CONVERTED AND TRIMED */

/*J2G3*/ /* HARDCODED LABEL  "      Supplier Totals:" HAS BEEN REPLACED */
         &SCOPED-DEFINE apvorp04_p_27 "      供应商合计:"
         /* MaxLen: 22 Comment: NO BLANK CHARACTERS SHOULD BE CONVERTED AND TRIMED */

/*J2G3*/ /* HARDCODED LABEL  "      Report   Totals:" HAS BEEN REPLACED */
         &SCOPED-DEFINE apvorp04_p_28 "      报表合计:"
         /* MaxLen: 22 Comment: NO BLANK CHARACTERS SHOULD BE CONVERTED AND TRIMED */

/*L03L*/ &SCOPED-DEFINE apvorp04_p_29 " 合计 "
         /* MaxLen: Comment: */

/*L03L*/ &SCOPED-DEFINE apvorp04_p_30 " 帐龄:"
         /* MaxLen: Comment: */

/*J2SQ*/ &SCOPED-DEFINE apvorp04_p_31 "付款"
         /* MaxLen: Comment: */
&SCOPED-DEFINE arcsrp2a_p_42 " 供应商    "
&scoped-define arcsrp2a_p_43 "       名称                  "
&SCOPED-DEFINE arcsrp2a_p_44 " 0----30天     　"
&SCOPED-DEFINE arcsrp2a_p_45 " 31----60天      "
&SCOPED-DEFINE arcsrp2a_p_46 " 61----90天      "
&SCOPED-DEFINE arcsrp2a_p_47 " 91----120天     "
&SCOPED-DEFINE arcsrp2a_p_48 "121---150天      "
&SCOPED-DEFINE arcsrp2a_p_49 "151---180天        "
&SCOPED-DEFINE arcsrp2a_p_50 "181---360天        "
&SCOPED-DEFINE arcsrp2a_p_51 " >360天　      "
&SCOPED-DEFINE arcsrp2a_p_52 " 合计金额       "

         /* ********** End Translatable Strings Definitions ********* */

/*L0BZ* /*L03L*/ /* THESE ARE NEEDED FOR FULL GUI REPORTS */
 *L0BZ* /*L03L*/ {gprunpdf.i "mcpl" "p"}
 *L0BZ* /*L03L*/ {gprunpdf.i "mcui" "p"}
 *L0BZ*/

/*L03L*/ {gprunpdf.i "mcpl" "p"}
/*L03L*/ {gprunpdf.i "mcui" "p"}

         define variable vend like ap_vend.
         define variable vend1 like ap_vend.
/*L0BZ*  define variable tempvend like ap_vend.  *L0BZ*/
         define variable ref like ap_ref.
         define variable ref1 like ap_ref.
         define variable voucherno like ap_ref.
/*L0BZ*  define variable tempref like ap_ref.  *L0BZ*/
         define variable vodate1 like ap_effdate initial today.
         define variable name like ad_name.
/*L0BZ*  define variable type like ap_type format "X(12)".  *L0BZ*/
         define variable age_days as integer extent 8 label {&apvorp04_p_13}.
         define variable age_range as character extent 4 format "X(17)".
         define variable i as integer.
         define variable age_amt like ap_amt extent 8
            format "->>>>,>>>,>>>.99".
         define variable net like ap_amt.
         define variable age_period as integer.
         define variable newvend like mfc_logical.
         define variable base_rpt like ap_curr.
         define variable base_applied like vo_applied.
         define variable base_amt like ap_amt.
         define variable curr_amt like ar_amt.
         define variable invoice like vo_invoice.
         define variable effdate like ap_effdate.
         define variable voflag like mfc_logical.
         define variable ckdtotal like vo_applied.
         define variable voidtotal like vo_applied.
         define variable hold as character format "x(1)".
         define variable entity like ap_entity.
         define variable entity1 like ap_entity.
         define variable votype like vo_type label {&apvorp04_p_7}.
         define variable votype1 like votype.
         define variable vdtype like vd_type label {&apvorp04_p_5}.
         define variable vdtype1 like vdtype.
         define variable age_by as character format "x(3)" label
            {&apvorp04_p_10} initial "DUE".
         define variable age_by_date like ap_date.
         define variable duedate like vo_due_date.
         define variable invdate like ap_date.
         define variable due-date like ap_date.
         define variable applied-amt like vo_applied.
         define variable amt-due like ap_amt.
         define variable tot-amt like ap_amt.
         define variable vo-tot like ap_amt.
         define variable multi-due like mfc_logical.
/*J2G3*/ define variable l_label1 as character format "x(25)" no-undo.
/*J2G3*/ define variable l_label2 as character format "x(25)" no-undo.
/*L03L*/ define variable exdrate like exr_rate.
/*L03L*/ define variable exdrate2 like exr_rate2.
/*L03L*/ define variable mc-rpt-curr like base_rpt no-undo.
/*L03L*/ define variable mc-dummy-fixed like po_fix_rate no-undo.
         define variable addr like ap_vend.
/*L00S*  BEGIN ADDED SECTION*/
         {etrpvar.i &new = "new"}
         {etvar.i   &new = "new"}
         {eteuro.i  }
/*L0BZ* /*L03L*  define variable et_select_curr   like ex_curr. */  *L0BZ*/
         define variable et_age_amt       like ap_amt extent 8.
         define variable et_base_amt      like ap_amt.
/*L0BZ*  define variable et_base_applied  like vo_applied.  *L0BZ*/
/*L0BZ*  define variable et_base_hold_amt like vo_hold_amt.  *L0BZ*/
         define variable et_curr_amt      like ap_amt.
/*L0BZ*  define variable et_adj_amt       like vo_hold_amt.  *L0BZ*/
         define variable et_org_age_amt   like ap_amt extent 8.
         define variable et_org_amt       like ap_amt.
         define variable et_org_curr_amt  like ap_amt.
/*L0BZ* /*L03L*  define variable input_curr       like ex_curr. */  *L0BZ*/
         define variable et_diff_exist    like mfc_logical.
/*L00S*  END ADDED SECTION*/

/*L0BZ*/ define variable v_ckd_net        like ckd_amt no-undo.

         define buffer apmaster for ap_mstr.

         find first gl_ctrl where gl_domain = global_domain  /*---Add by davild 20090205.1*/
		 no-lock.

         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
						vend colon 15
            vend1          label {t001.i} colon 49
            vdtype         colon 15
            vdtype1        label {t001.i} colon 49
            entity         colon 15
            entity1        label {t001.i} colon 49
            ref            colon 15
            ref1           label {t001.i} colon 49
            votype         colon 15
            votype1        label {t001.i} colon 49 skip (1)
            vodate1        colon 30
            age_by         colon 30
               validate((lookup(age_by,"DUE,EFF,INV") <> 0),
               {&apvorp04_p_9})
/*L00S*     base_rpt        colon 30 skip (1) */
/*L00S*/    base_rpt        colon 30
/*L03L*/    et_report_curr  colon 30 skip(1)
/*L03L* /*L00S*/    et_report_txt   to 30 no-label */
/*L03L* /*L00S*/    et_report_curr        no-label */
/*L00Z*     colon 30 */
/*L03L* /*L00S*/    et_rate_txt     to 30 no-label */
/*L03L* /*L00S*/    et_report_rate */
/*L00Z*     colon 30 */
/*L03L* /*L00S*/    no-label skip (1) */

            space(1)
            age_days[1]
            age_days[2]    label "[2]"
            age_days[3]    label "[3]" skip (1)
            age_days[4]
            space(1)
            age_days[5]
            age_days[6]
            age_days[7]
            skip(1)    
         with frame a side-labels width 80.

			setFrameLabels(frame a:handle).
				
/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/*L03L*  {wbrp01.i} */
         repeat:
           assign
              age_days[1] = 30
              age_days[2] = 60
              age_days[3] = 90
              age_days[4] = 120
              age_days[5] = 150
              age_days[6] = 180
              age_days[7] =360
              age_days[8] = 390.


/*L0BZ*/    run ip-param-init.

/*L01G* /*L00S*/    display */
/*L01G* /*L00S*/       et_report_txt when (et_tk_active) */
/*L01G* /*L00S*/       et_rate_txt when (et_tk_active) */
/*L01G* /*L00S*/    with frame a. */

/*L03L*     if c-application-mode <> 'web':u then */
               update
                  vend vend1
                  vdtype vdtype1
                  entity entity1
                  ref ref1
                  votype votype1
                  vodate1
                  age_by
                  base_rpt
/*L00S*/          et_report_curr
/*L03L* /*L00S*/  et_report_rate */
                  age_days[1 for 7]
               with frame a.

/*L03L*
 *          {wbrp06.i &command = update
 *                    &fields = "  vend vend1 vdtype vdtype1
 *                                 entity entity1 ref ref1 votype votype1
 *                                 vodate1   age_by base_rpt
 *                       et_report_curr
 *                       et_report_rate
 *                                 age_days [ 1 for 7 ]" &frm = "a" } 
 * L03L */

/*L03L* /*L00S*/    if et_report_curr = "" then et_disp_curr = base_rpt. */
/*L03L* /*L00S*/    else et_disp_curr = et_report_curr. */

/*L03L* /*L00S*/    {etcurval.i &curr = "et_report_curr"  &errlevel = "4" */
/*L03L* /*L00S*/                &action = "next"   &prompt   = "pause" } */

/*L00S*/    et_eff_date = vodate1.
/*L03L* /*L00S*/    if base_rpt = "base" then input_curr = "". */
/*L03L* /*L00S*/    else input_curr = base_rpt. */
/*L03L* /*L00S*/    {gprun.i ""etrate.p"" "(input input_curr)"} */

/*L03L*     if (c-application-mode <> 'web':u) or */
/*L03L*        (c-application-mode = 'web':u and */
/*L03L*        (c-web-request begins 'data':u)) then do: */

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

/*L0BZ* /*L03L*/ if base_rpt <> "" then
 *L0BZ* /*L03L*/    mc-rpt-curr = base_rpt.
 *L0BZ* /*L03L*/ else mc-rpt-curr = base_curr.
 *L0BZ* /*L03L*/ if et_report_curr <> "" then do:
 *L0BZ* /*L03L*/    {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
 *L0BZ*               "(input et_report_curr,
 *L0BZ*                 output mc-error-number)"}
 *L0BZ* /*L03L*/    if mc-error-number = 0
 *L0BZ* /*L03L*/    and et_report_curr <> mc-rpt-curr then do:
 *L0BZ* /*L08W*        CURRENCIES AND RATES REVERSED BELOW...             */
 *L0BZ* /*L03L*/       {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
 *L0BZ*                  "(input et_report_curr,
 *L0BZ*                    input mc-rpt-curr,
 *L0BZ*                    input "" "",
 *L0BZ*                    input et_eff_date,
 *L0BZ*                    output et_rate2,
 *L0BZ*                    output et_rate1,
 *L0BZ*                    output mc-seq,
 *L0BZ*                    output mc-error-number)"}
 *L0BZ* /*L03L*/    end.  /* if mc-error-number = 0 */
 *L0BZ* /*L03L*/    if mc-error-number <> 0 then do:
 *L0BZ* /*L03L*/       {mfmsg.i mc-error-number 3}
 *L0BZ* /*L03L*/       next-prompt et_report_curr with frame a.
 *L0BZ* /*L03L*/       undo, retry.
 *L0BZ* /*L03L*/    end.  /* if mc-error-number <> 0 */
 *L0BZ* /*L03L*/    else if et_report_curr <> mc-rpt-curr then do:
 *L0BZ* /*L08W*        CURRENCIES AND RATES REVERSED BELOW...             */
 *L0BZ* /*L03L*/       {gprunp.i "mcui" "p" "mc-ex-rate-input"
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
 *L0BZ* /*L03L*/       {gprunp.i "mcui" "p" "mc-ex-rate-output"
 *L0BZ*                  "(input et_report_curr,
 *L0BZ*                    input mc-rpt-curr,
 *L0BZ*                    input et_rate2,
 *L0BZ*                    input et_rate1,
 *L0BZ*                    input mc-seq,
 *L0BZ*                    output mc-exch-line1,
 *L0BZ*                    output mc-exch-line2)"}
 *L0BZ* /*L03L*/       {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
 *L0BZ*                  "(input mc-seq)"}
 *L0BZ* /*L03L*/    end.  /* else do */
 *L0BZ* /*L03L*/ end.  /* if et_report_curr <> "" */
 *L0BZ* /*L03L*/ if et_report_curr = "" or et_report_curr = mc-rpt-curr then
 *L0BZ* /*L03L*/    assign
 *L0BZ* /*L03L*/       mc-exch-line1 = ""
 *L0BZ* /*L03L*/       mc-exch-line2 = ""
 *L0BZ* /*L03L*/       et_report_curr = mc-rpt-curr.
 *L0BZ*/

/*L03L*     end.  /* if (c-application-mode <> 'web':u) ... */ */
/*L08W*/    end.

/*J2G3*/    /* DISPLAY THE TOTAL LABELS AS CONTINUOUS STRINGS FOR CORRECT */
/*J2G3*/    /* TRANSLATION                                                */

/*J2G3*/    if base_rpt = ""
/*L03L*/    and et_report_curr = base_curr
/*J2G3*/    then
/*J2G3*/       assign
/*J2G3*/          l_label1 = {&apvorp04_p_25}
/*J2G3*/          l_label2 = {&apvorp04_p_26}.
/*J2G3*/       else assign
/*L03L* /*J2G3*/  l_label1 = string(base_rpt,"x(3)") + {&apvorp04_p_27} */
/*L03L* /*J2G3*/  l_label2 = string(base_rpt,"x(3)") + {&apvorp04_p_28}. */
/*L03L*/          l_label1 = string(et_report_curr,"x(3)") + {&apvorp04_p_27}
/*L03L*/          l_label2 = string(et_report_curr,"x(3)") + {&apvorp04_p_28}.

/*L01G* /*L00S*/  if et_tk_active and et_disp_curr <> "" */
/*L03L* /*L01G*/  if et_disp_curr <> "" */
/*L03L* /*L00S*/  then assign */
/*L03L* /*L00S*/   l_label1 = string(et_disp_curr,"x(3)") + {&apvorp04_p_27} */
/*L03L* /*L00S*/   l_label2 = string(et_disp_curr,"x(3)") + {&apvorp04_p_28}.*/

            /* SELECT PRINTER */
            {mfselbpr.i "printer" 132}

            {mfphead.i}

            /* CREATE REPORT HEADER */
              FORM /*GUI*/ 
             {&arcsrp2a_p_42}
             {&arcsrp2a_p_43}
             {&arcsrp2a_p_44}
             {&arcsrp2a_p_45}
             {&arcsrp2a_p_46}
             {&arcsrp2a_p_47}
             {&arcsrp2a_p_48}
             {&arcsrp2a_p_49}
             {&arcsrp2a_p_50}
             {&arcsrp2a_p_51} 
             {&arcsrp2a_p_52}skip
             "--------"
             "--------------------------------"
             "--------------"          
             "------------------ "
             "----------------"
             "----------------"
             "----------------"
             "------------------"
             "------------------"
             "----------------"
             "----------------"
             skip
            with STREAM-IO /*GUI*/  frame phead1 width 256 page-top.           
            view frame phead1.
            FORM /*GUI*/  with STREAM-IO /*GUI*/  frame c width 256 no-labels no-attr-space no-box down.


/*L00S*/    FORM /*GUI*/ 
/*L00S*/       addr
               name
/*L00S*/       et_age_amt[1]  format "->>>>>,>>>,>>9.99"
/*L00S*/       et_age_amt[2]  format "->>>>>,>>>,>>9.99"
/*L00S*/       et_age_amt[3]  format "->>>>>,>>>,>>9.99"
/*L00S*/       et_age_amt[4]  format "->>>>>,>>>,>>9.99"
               et_age_amt[5]  format "->>>>>,>>>,>>9.99"
               et_age_amt[6]  format "->>>>>,>>>,>>9.99"
               et_age_amt[7]  format "->>>>>,>>>,>>9.99"
               et_age_amt[8]  format "->>>>>,>>>,>>9.99"
/*L00S*/       et_base_amt    format "->>>>>,>>>,>>9.99"
/*L00S*/    with STREAM-IO /*GUI*/  frame e width 256 no-labels no-attr-space no-box down.

/*J2PS**    for each vd_mstr where (vd_addr >= vend and vd_addr <= vend1) */
/*J2PS*/    for each vd_mstr fields (vd_addr vd_sort vd_type)
/*J2PS*/       where 
				vd_domain = global_domain and /*---Add by davild 20090205.1*/
				(vd_addr >= vend and vd_addr <= vend1)
                 and (vd_type >= vdtype and vd_type <= vdtype1)
                 use-index vd_sort no-lock break by vd_sort:

/*J2PS*/       assign
                  newvend = yes
                  name    = "".
                  addr    = " ".
/*J2PS*/       for first ad_mstr
/*J2PS*/          fields (ad_addr ad_attn ad_ext ad_name ad_phone)
/*J2PS*/          where 
					ad_domain = global_domain and /*---Add by davild 20090205.1*/
					ad_addr = vd_addr no-lock:
/*L0BZ*/          name = ad_name.                
/*J2PS*/       end.
/*J2PS*/       for each ap_mstr
/*J2PS*/          fields (ap_amt  ap_curr ap_date ap_effdate ap_entity
/*L08W*/                  ap_base_amt ap_exru_seq ap_ex_rate2 ap_ex_ratetype
/*L08W*/                  ap_ex_rate ap_ref ap_type ap_vend)
/*J2PS*/          where 
					ap_domain = global_domain and /*---Add by davild 20090205.1*/
					(ap_vend = vd_addr)
                    and (ap_entity >= entity and ap_entity <= entity1)
                    and (ap_ref >= ref and ap_ref <= ref1)
                    and (ap_type = "VO")
                    and ((ap_curr = base_rpt)
                      or (base_rpt = ""))
/*J2PS*/            and (ap_date >= 1/1/1850 or ap_date = ?)
/*J2PS*/          use-index ap_vend_date no-lock:
/*J2PS*/          for each vo_mstr
/*J2PS*/             fields (vo_applied  vo_confirmed vo_cr_terms vo_due_date
/*J2PS*/                     vo_hold_amt vo_invoice   vo_ref      vo_type)
/*J2PS*/             where 
						vo_domain = global_domain and /*---Add by davild 20090205.1*/
						vo_ref = ap_ref and vo_confirmed = yes
                       and (vo_type >= votype and vo_type <= votype1)
/*J2PS*/             no-lock:
                         addr = ap_vend.
/*L0BZ*/             run ip-set-vars.

/*J2PS**             BEGIN DELETE
 *                   for each ckd_det where ckd_voucher = ap_mstr.ap_ref no-lock,
 *                       each ck_mstr where ck_ref = ckd_ref and
 *J2PS**             END DELETE */

/*J2PS*/             for each ckd_det
/*J2PS*/                fields (ckd_amt ckd_cur_amt ckd_cur_disc ckd_disc
/*J2PS*/                        ckd_ref ckd_voucher)
/*J2PS*/                where 
						ckd_domain = global_domain and /*---Add by davild 20090205.1*/
						ckd_voucher = ap_mstr.ap_ref no-lock,
/*J2PS*/                each ck_mstr
/*J2PS*/                   fields (ck_curr ck_ref ck_voideff)
/*J2PS*/                   where ck_domain = global_domain and /*---Add by davild 20090205.1*/
								 ck_ref = ckd_ref and
                                         (ck_voideff = ? or
                                          ck_voideff > vodate1)
                           no-lock:

/*J2PS**                BEGIN DELETE
 *                      find apmaster where ap_ref = ckd_ref and
 *                      ap_type = "CK" no-lock
 *                      /*F373*/     no-error.
 *J2PS**                END DELETE */

/*J2PS*/                for first apmaster
/*J2PS*/                   fields (ap_amt    ap_curr   ap_date    ap_effdate
/*L08W*J2PS*                       ap_entity ap_ent_ex ap_ex_rate ap_ref     */
/*L08W*/                           ap_entity           ap_ex_rate ap_ref
/*L08W*/                           ap_base_amt ap_exru_seq ap_ex_rate2
/*L08W*/                           ap_ex_ratetype
/*J2PS*/                           ap_type   ap_vend)
/*J2PS*/                   where 
								ap_domain = global_domain and /*---Add by davild 20090205.1*/
								ap_ref = ckd_ref and
/*J2PS*/                         ap_type = "CK" no-lock: end.
                        if not available apmaster or
/*L0BZ*                    available apmaster and  *L0BZ*/
                           apmaster.ap_effdate <= vodate1 then do:

/*L0BZ*                    if voflag = no and available apmaster then do:
 *L0BZ*                       age_period = 8.
 *L0BZ*                       do i = 1 to 8:
 *L0BZ*                          if (vodate1 - age_days[i]) <= apmaster.ap_effdate
 *L0BZ*                             then age_period = i.
 *L0BZ*                          if age_period <> 8 then leave.
 *L0BZ*                       end.
 *L0BZ*                       if apmaster.ap_effdate = ? then age_period = 1.
 *L0BZ* /*L03L*/              assign
 *L0BZ*                          voucherno = apmaster.ap_ref
 *L0BZ* /*J2SQ**                 invoice   = "PAYMENT" */
 *L0BZ* /*J2SQ*/                 invoice   = {&apvorp04_p_31}
 *L0BZ*                          effdate   = apmaster.ap_effdate
 *L0BZ*                          invdate   = apmaster.ap_date
 *L0BZ*                          duedate   = ?.
 *L0BZ*                    end.
 *L0BZ*/

/*L0BZ*/                   run ip-set-ap.

/*L0BZ*                    if ck_curr <> ap_mstr.ap_curr then
 *L0BZ*                       net = net - ckd_cur_amt - ckd_cur_disc.
 *L0BZ*                    else
 *L0BZ*                       net = net - ckd_amt - ckd_disc.
 *L0BZ*/
                        end. /* if not available apmaster ... */

/*L0BZ*/                v_ckd_net =
/*L0BZ*/                   if ck_curr <> ap_mstr.ap_curr
/*L0BZ*/                      then ckd_cur_amt + ckd_cur_disc
/*L0BZ*/                      else ckd_amt     + ckd_disc.

/*L0BZ*/                if not available apmaster or
/*L0BZ*/                   apmaster.ap_effdate <= vodate1 then
/*L0BZ*/                   net = net - v_ckd_net.

/*L0BZ*/                ckdtotal = ckdtotal + v_ckd_net.

/*L0BZ*/                /* TOTAL THE AMOUNT VOIDED AFTER REPORT EFFDATE */
/*L0BZ*/                if ck_voideff <> ? then
/*L0BZ*/                   voidtotal = voidtotal + v_ckd_net.

/*L0BZ*                 if ck_curr <> ap_mstr.ap_curr then
 *L0BZ* /*J2PS*/           assign
 *L0BZ*                       ckdtotal = ckdtotal + ckd_cur_amt + ckd_cur_disc.
 *L0BZ*                 else
 *L0BZ*                    ckdtotal = ckdtotal + ckd_amt + ckd_disc.
 *L0BZ*                 /* TOTAL THE AMOUNT VOIDED AFTER REPORT EFFDATE */
 *L0BZ*                 if ck_voideff <> ? then
 *L0BZ*                    if ck_curr <> ap_mstr.ap_curr then
 *L0BZ*                       voidtotal = voidtotal + ckd_cur_amt + ckd_cur_disc.
 *L0BZ*                    else
 *L0BZ*                       voidtotal = voidtotal + ckd_amt + ckd_disc.
 *L0BZ*/
                     end.  /* for each ckd_det */

                     /* IF CKDTOTAL <> VO_APPLIED THEN ASSUME CK WAS DELETED */
                     if ckdtotal <> (vo_applied + voidtotal) then
                        net = net - (vo_applied - ckdtotal).

/*L03L*/             assign
                        curr_amt = net
                        base_amt = net.
                     if base_rpt = "" and ap_mstr.ap_curr <> base_curr then do:
/*L03L*                 base_amt = base_amt / ap_mstr.ap_ex_rate. */
/*L06R*/                /* ONLY CONVERT BASE AMOUNT IF IT NO LONGER EQUALS */
/*L06R*/                /* AP_AMT (MEANING CHECKS HAVE BEEN APPLIED TO IT  */
/*L06R*/                /* IN THE ABOVE SECTION)                           */

/*L06R*/                if net <> ap_amt then do:
/*L03L*/                   /* CONVERT FROM FOREIGN TO BASE CURRENCY */

/*L0BZ* /*L03L*/           {gprunp.i "mcpl" "p" "mc-curr-conv"
 *L0BZ*                       "(input ap_mstr.ap_curr,
 *L0BZ*                          input base_curr,
 *L0BZ*                          input ap_mstr.ap_ex_rate,
 *L0BZ*                          input ap_mstr.ap_ex_rate2,
 *L0BZ*                          input base_amt,
 *L0BZ*                          input true, /* ROUND */
 *L0BZ*                          output base_amt,
 *L0BZ*                          output mc-error-number)"}
 *L0BZ* /*L03L*/           if mc-error-number <> 0 then do:
 *L0BZ* /*L03L*/              {mfmsg.i mc-error-number 2}
 *L0BZ* /*L03L*/           end.
 *L0BZ*/

/*L0BZ*/                   run ip-curr-conv
/*L0BZ*/                      (input  ap_mstr.ap_curr,
/*L0BZ*/                       input  base_curr,
/*L0BZ*/                       input  ap_mstr.ap_ex_rate,
/*L0BZ*/                       input  ap_mstr.ap_ex_rate2,
/*L0BZ*/                       input  base_amt,
/*L0BZ*/                       input  true, /* ROUND */
/*L0BZ*/                       output base_amt).

/*L06R*/                end.
/*L06R*/                else base_amt = ap_base_amt.

/*L03L*                 {gprun.i ""gpcurrnd.p"" "(input-output base_amt, */
/*L03L*                    input gl_rnd_mthd)"} */
/*L03L*                 find last exd_det where exd_curr = ap_curr and */
/*L03L*                    exd_eff_date <= */
/*L03L*                    vodate1 and exd_end_date >= vodate1 no-lock no-error. */
/*L03L*                 if available exd_det */
/*L03L*/                /* GET EXCHANGE RATE */

/*L0BZ* /*L03L*/        {gprunp.i "mcpl" "p" "mc-get-ex-rate"
 *L0BZ*                    "(input ap_curr,
 *L0BZ*                      input base_curr,
 *L0BZ*                      input ap_ex_ratetype,
 *L0BZ*                      input vodate1,
 *L0BZ*                      output exdrate,
 *L0BZ*                      output exdrate2,
 *L0BZ*                      output mc-error-number)"}
 *L0BZ*/

/*L0BZ*/                run ip-get-ex-rate
/*L0BZ*/                   (input  ap_curr,
/*L0BZ*/                    input  base_curr,
/*L0BZ*/                    input  ap_ex_ratetype,
/*L0BZ*/                    input  vodate1,
/*L0BZ*/                    output exdrate,
/*L0BZ*/                    output exdrate2,
/*L0BZ*/                    output mc-error-number).

/*L03L*/                if mc-error-number <> 0 then do:
/*L03L*/                   {mfmsg.i mc-error-number 2}
/*L03L*/                end.
/*L03L*                 if available exr_rate then */
/*L03L*/                if mc-error-number = 0 then do:
/*L03L*                    curr_amt = curr_amt / exd_rate. */
/*L03L*/                   /* CONVERT FROM FOREIGN TO BASE CURRENCY */

/*L0BZ* /*L03L*/           {gprunp.i "mcpl" "p" "mc-curr-conv"
 *L0BZ*                       "(input ap_mstr.ap_curr,
 *L0BZ*                         input base_curr,
 *L0BZ*                         input exdrate,
 *L0BZ*                         input exdrate2,
 *L0BZ*                         input curr_amt,
 *L0BZ*                         input true, /* ROUND */
 *L0BZ*                         output curr_amt,
 *L0BZ*                         output mc-error-number)"}
 *L0BZ* /*L03L*/           if mc-error-number <> 0 then do:
 *L0BZ* /*L03L*/              {mfmsg.i mc-error-number 2}
 *L0BZ* /*L03L*/           end.
 *L0BZ*/

/*L0BZ*/                   run ip-curr-conv
/*L0BZ*/                      (input  ap_mstr.ap_curr,
/*L0BZ*/                       input  base_curr,
/*L0BZ*/                       input  exdrate,
/*L0BZ*/                       input  exdrate2,
/*L0BZ*/                       input  curr_amt,
/*L0BZ*/                       input  true, /* ROUND */
/*L0BZ*/                       output curr_amt).

/*L03L*/                end.
                        /* IF NO EXCHANGE RATE FOR TODAY, USE THE VOUCHER RATE */
                        else
/*L03L*/                do:
/*L03L*                    curr_amt = curr_amt / ap_mstr.ap_ex_rate. */
/*L03L*/                   /* CONVERT FROM FOREIGN TO BASE CURRENCY */

/*L0BZ* /*L03L*/           {gprunp.i "mcpl" "p" "mc-curr-conv"
 *L0BZ*                       "(input ap_mstr.ap_curr,
 *L0BZ*                         input base_curr,
 *L0BZ*                         input ap_mstr.ap_ex_rate,
 *L0BZ*                         input ap_mstr.ap_ex_rate2,
 *L0BZ*                         input curr_amt,
 *L0BZ*                         input true, /* ROUND */
 *L0BZ*                         output curr_amt,
 *L0BZ*                         output mc-error-number)"}
 *L0BZ* /*L03L*/           if mc-error-number <> 0 then do:
 *L0BZ* /*L03L*/              {mfmsg.i mc-error-number 2}
 *L0BZ* /*L03L*/           end.
 *L0BZ*/

/*L0BZ*/                   run ip-curr-conv
/*L0BZ*/                      (input  ap_mstr.ap_curr,
/*L0BZ*/                       input  base_curr,
/*L0BZ*/                       input  ap_mstr.ap_ex_rate,
/*L0BZ*/                       input  ap_mstr.ap_ex_rate2,
/*L0BZ*/                       input  curr_amt,
/*L0BZ*/                       input  true, /* ROUND */
/*L0BZ*/                       output curr_amt).

/*L03L*/                end.
/*L03L*                 {gprun.i ""gpcurrnd.p"" "(input-output curr_amt, */
/*L03L*                    input gl_rnd_mthd)"} */

                     end.

                     multi-due = no.
/*J2PS**             find ct_mstr where ct_code = vo_cr_terms no-lock no-error.*/
/*J2PS*/             for first ct_mstr
/*J2PS*/                fields (ct_code ct_dating ct_due_date ct_due_days
/*J2PS*/                        ct_from_inv)
/*J2PS*/                where 
	ct_domain = global_domain and /*---Add by davild 20090205.1*/
	ct_code = vo_cr_terms
/*J2PS*/                no-lock:
/*J2PS*/             end.
                     if available ct_mstr and ct_dating and age_by = "DUE" then
                        do:
/*L03L*/                assign
                           multi-due   = yes
                           tot-amt     = 0
                           vo-tot      = 0
                           applied-amt = base_applied.
/*J2PS**                for each ctd_det where ctd_code = vo_cr_terms no-lock*/
/*J2PS*/                for each ctd_det
/*J2PS*/                   fields (ctd_code ctd_date_cd ctd_pct_due)
/*J2PS*/                   where 
	ctd_domain = global_domain and /*---Add by davild 20090205.1*/
	ctd_code = vo_cr_terms no-lock
/*J295**                   use-index ctd_cdseq: */
/*J295*/                   break by ctd_code:

/*J2PS**                   BEGIN DELETE
 *                         find ct_mstr where ct_code = ctd_date_cd no-lock
 *                            no-error.
 *J2PS**                   END DELETE */
/*J2PS*/                   for first ct_mstr
/*J2PS*/                      fields (ct_code ct_dating ct_due_date
/*J2PS*/                              ct_due_days ct_from_inv)
/*J2PS*/                      where 
	ct_domain = global_domain and /*---Add by davild 20090205.1*/
	ct_code = ctd_date_cd no-lock:

/*L0BZ* /*J2PS*/           end.
 *L0BZ*                    if available ct_mstr then do:
 *L0BZ*                       if (ct_from_inv = 1) then
 *L0BZ*                          due-date  = ap_date + ct_due_days.
 *L0BZ*                       else       /* From end of month */
 *L0BZ* /*J2PS*/                 assign
 *L0BZ*                             due-date =
 *L0BZ*                                date((month(ap_date) + 1) mod 12 +
 *L0BZ*                                        if month(ap_date) = 11
 *L0BZ*                                           then 12 else 0,
 *L0BZ*                                     1,
 *L0BZ*                                     year(ap_date) +
 *L0BZ*                                        if month(ap_date) >= 12
 *L0BZ*                                           then 1 else 0) +
 *L0BZ*                                integer(ct_due_days) -
 *L0BZ*                                if ct_due_days <> 0 then 1 else 0.
 *L0BZ*                       if ct_due_date <> ? then due-date = ct_due_date.
 *L0BZ*                       if last-of(ctd_code) then
 *L0BZ*                          amt-due = base_amt - tot-amt.
 *L0BZ*                       else
 *L0BZ*                          amt-due = base_amt * (ctd_pct_due / 100).
 *L0BZ*/

/*L0BZ*/                      run ip-set-due-date.

/*L0BZ*/                      /* Calculate the amt-due less the applied */
/*L0BZ*/                      /* for this segment.  To prevent rounding */
/*L0BZ*/                      /* errors, assign last bucket = rounded   */
/*L0BZ*/                      /* total - running total */

/*L0BZ*/                      amt-due =
/*L0BZ*/                         if last-of(ctd_code)
/*L0BZ*/                            then base_amt - tot-amt
/*L0BZ*/                            else base_amt * (ctd_pct_due / 100).

/*L03L*                       {gprun.i ""gpcurrnd.p"" "(input-output amt-due, */
/*L03L*                                                 input gl_rnd_mthd)"} */
/*L03L*/                      {gprunp.i "mcpl" "p" "mc-curr-rnd"
                                 "(input-output amt-due,
                                   input gl_rnd_mthd,
                                   output mc-error-number)"}
/*L03L*/                      if mc-error-number <> 0 then do:
/*L03L*/                         {mfmsg.i mc-error-number 2}
/*L03L*/                      end.

                              if applied-amt >= amt-due then do:
/*L03L*/                         assign
                                    applied-amt = applied-amt - amt-due
                                    tot-amt     = tot-amt + amt-due.
                                 next. /* THIS SEGMENT IS CLOSED */
                              end.
                              else
/*L03L*                       do: */
/*L03L*/                         assign
                                    tot-amt     = tot-amt + amt-due
                                    amt-due     = amt-due - applied-amt
                                    applied-amt = 0.
/*L03L*                       end. */
                              age_period = 8.
                              do i = 1 to 8:
                                 if (vodate1 - age_days[i]) <= due-date then
                                    age_period = i.
                                 if age_period <> 8 then leave.
                              end.
/*L03L*/                      assign
                                 age_amt[age_period] = age_amt[age_period] +
                                    (amt-due)
                                 vo-tot = vo-tot + (amt-due).

                              if tot-amt >= ap_amt then leave.
                           end.  /* for first ct_mstr */
                        end.  /* for each ctd_det */
                     end.  /* if available ct_mstr &  ct_dating = yes ... */

                     else
                        age_amt[age_period] = base_amt.  /* net */

/*L03L* /*L00S*/     {etrpconv.i age_amt[1]   et_age_amt[1]  } */
/*L03L* /*L00S*/     {etrpconv.i age_amt[2]   et_age_amt[2]  } */
/*L03L* /*L00S*/     {etrpconv.i age_amt[3]   et_age_amt[3]  } */
/*L03L* /*L00S*/     {etrpconv.i age_amt[4]   et_age_amt[4]  } */
/*L03L* /*L00S*/     {etrpconv.i base_amt     et_base_amt    } */
/*L03L* /*L00S*/     {etrpconv.i curr_amt     et_curr_amt    } */

/*L03L*/             do i = 1 to 8:
/*L03L*/                if et_report_curr <> mc-rpt-curr then do:

/*L0BZ* /*L03L*/           {gprunp.i "mcpl" "p" "mc-curr-conv"
 *L0BZ*                       "(input mc-rpt-curr,
 *L0BZ*                         input et_report_curr,
 *L0BZ*                         input et_rate1,
 *L0BZ*                         input et_rate2,
 *L0BZ*                         input age_amt[i],
 *L0BZ*                         input true,  /* ROUND */
 *L0BZ*                         output et_age_amt[i],
 *L0BZ*                         output mc-error-number)"}
 *L0BZ* /*L03L*/           if mc-error-number <> 0 then do:
 *L0BZ* /*L03L*/              {mfmsg.i mc-error-number 2}
 *L0BZ* /*L03L*/           end.
 *L0BZ*/

/*L0BZ*/                   run ip-curr-conv
/*L0BZ*/                      (input  mc-rpt-curr,
/*L0BZ*/                       input  et_report_curr,
/*L0BZ*/                       input  et_rate1,
/*L0BZ*/                       input  et_rate2,
/*L0BZ*/                       input  age_amt[i],
/*L0BZ*/                       input  true,  /* ROUND */
/*L0BZ*/                       output et_age_amt[i]).

/*L03L*/                end.  /* if et_report_curr <> mc-rpt-curr */
/*L03L*/                else et_age_amt[i] = age_amt[i].
/*L03L*/             end.  /* do i = 1 to 4 */
/*L03L*/             if et_report_curr <> mc-rpt-curr then do:

/*L0BZ* /*L03L*/        {gprunp.i "mcpl" "p" "mc-curr-conv"
 *L0BZ*                    "(input mc-rpt-curr,
 *L0BZ*                      input et_report_curr,
 *L0BZ*                      input et_rate1,
 *L0BZ*                      input et_rate2,
 *L0BZ*                      input base_amt,
 *L0BZ*                      input true,  /* ROUND */
 *L0BZ*                      output et_base_amt,
 *L0BZ*                      output mc-error-number)"}
 *L0BZ* /*L03L*/           if mc-error-number <> 0 then do:
 *L0BZ* /*L03L*/              {mfmsg.i mc-error-number 2}
 *L0BZ* /*L03L*/           end.
 *L0BZ*/

/*L0BZ*/                run ip-curr-conv
/*L0BZ*/                   (input  mc-rpt-curr,
/*L0BZ*/                    input  et_report_curr,
/*L0BZ*/                    input  et_rate1,
/*L0BZ*/                    input  et_rate2,
/*L0BZ*/                    input  base_amt,
/*L0BZ*/                    input  true,  /* ROUND */
/*L0BZ*/                    output et_base_amt).

/*L0BZ* /*L03L*/        {gprunp.i "mcpl" "p" "mc-curr-conv"
 *L0BZ*                    "(input mc-rpt-curr,
 *L0BZ*                      input et_report_curr,
 *L0BZ*                      input et_rate1,
 *L0BZ*                      input et_rate2,
 *L0BZ*                      input curr_amt,
 *L0BZ*                      input true,  /* ROUND */
 *L0BZ*                      output et_curr_amt,
 *L0BZ*                      output mc-error-number)"}
 *L0BZ* /*L03L*/           if mc-error-number <> 0 then do:
 *L0BZ* /*L03L*/              {mfmsg.i mc-error-number 2}
 *L0BZ* /*L03L*/           end.
 *L0BZ*/

/*L0BZ*/                run ip-curr-conv
/*L0BZ*/                   (input  mc-rpt-curr,
/*L0BZ*/                    input  et_report_curr,
/*L0BZ*/                    input  et_rate1,
/*L0BZ*/                    input  et_rate2,
/*L0BZ*/                    input  curr_amt,
/*L0BZ*/                    input  true,  /* ROUND */
/*L0BZ*/                    output et_curr_amt).

/*L03L*/             end.  /* if et_report_curr <> mc-rpt-curr */
/*L03L*/             else assign
/*L03L*/                et_curr_amt = curr_amt
/*L03L*/                et_base_amt = base_amt.

/*L00S*/             accumulate et_curr_amt (total).
/*L00S*/             accumulate et_age_amt  (total).
/*L00S*/             accumulate et_base_amt (total).

                     accumulate age_amt (total).
                     accumulate base_amt (total).
                     accumulate curr_amt (total).

/*L0BZ*              if vo_hold_amt <> 0 then hold = "H".
 *L0BZ*              else hold = "".
 *L0BZ*/

/*L0BZ*/             hold = if vo_hold_amt <> 0 then "H" else "".

/*L0BZ*/             run ip-disp-voucher.

                     
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/

/*J2PS*/          end. /* FOR EACH VO_MSTR ... */
               end. /* for each ap_mstr ... */

               if newvend = no then do with frame c:
            /*      underline
/*L00S*/             et_age_amt et_base_amt
/*L00S*/          with frame c. */

/*J2G3*/          display
                     addr
                     name
/*J2G3*/             accum total (et_age_amt[1]) @ et_age_amt[1]
                     accum total (et_age_amt[2]) @ et_age_amt[2]
                     accum total (et_age_amt[3]) @ et_age_amt[3]
                     accum total (et_age_amt[4]) @ et_age_amt[4]
                     accum total (et_age_amt[5]) @ et_age_amt[5]
                     accum total (et_age_amt[6]) @ et_age_amt[6]
                     accum total (et_age_amt[7]) @ et_age_amt[7]
                     accum total (et_age_amt[8]) @ et_age_amt[8]
                     accum total et_base_amt     @ et_base_amt
/*J2G3*/          with frame e STREAM-IO /*GUI*/ .
                down 1 with frame e.
               end.

               
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/

            end.  /* for each vd_mstr ... */

     /*       underline
/*L00S*/       et_age_amt[1 for 8] et_base_amt
            with frame c. */

/*L01G* /*L00S*/    if et_tk_active = no then do: */
/*L03L* /*L00S*/       if base_rpt = "" then et_disp_curr = "Base". */
/*L03L* /*L00S*/       else et_disp_curr = base_rpt. */
/*L01G* /*L00S*/    end. */


/*J2G3*/    display
/*J2G3*/       l_label2                 @ name
               accum total (et_age_amt[1]) @ et_age_amt[1]
               accum total (et_age_amt[2]) @ et_age_amt[2]
               accum total (et_age_amt[3]) @ et_age_amt[3]
               accum total (et_age_amt[4]) @ et_age_amt[4]
               accum total (et_age_amt[5]) @ et_age_amt[5]
               accum total (et_age_amt[6]) @ et_age_amt[6]
               accum total (et_age_amt[7]) @ et_age_amt[7]
               accum total (et_age_amt[8]) @ et_age_amt[8]
               accum total et_base_amt     @ et_base_amt
/*J2G3*/    with frame e STREAM-IO /*GUI*/ .
/*J2G3*/    down 1 with frame e.

/*L00S*     BEGIN ADDED SECTION*/

            /* DETERMINE ORIGINAL TOTALS, NOT YET CONVERTED */
            assign
               et_org_age_amt[1] = accum total (age_amt[1])
               et_org_age_amt[2] = accum total (age_amt[2])
               et_org_age_amt[3] = accum total (age_amt[3])
               et_org_age_amt[4] = accum total (age_amt[4])
               et_org_age_amt[5] = accum total (age_amt[5])
               et_org_age_amt[6] = accum total (age_amt[6])
               et_org_age_amt[7] = accum total (age_amt[7])
               et_org_age_amt[8] = accum total (age_amt[8])
               et_org_amt        = accum total (base_amt)
               et_org_curr_amt   = accum total curr_amt.

            /*CONVERT AMOUNTS*/
/*L03L*     {etrpconv.i et_org_age_amt[1] et_org_age_amt[1]} */
/*L03L*     {etrpconv.i et_org_age_amt[2] et_org_age_amt[2]} */
/*L03L*     {etrpconv.i et_org_age_amt[3] et_org_age_amt[3]} */
/*L03L*     {etrpconv.i et_org_age_amt[4] et_org_age_amt[4]} */
/*L03L*     {etrpconv.i et_org_amt        et_org_amt       } */
/*L03L*     {etrpconv.i et_org_curr_amt   et_org_curr_amt  } */

/*L03L*/    do i = 1 to 8:
/*L03L*/       if et_report_curr <> mc-rpt-curr then do:

/*L0BZ* /*L03L*/  {gprunp.i "mcpl" "p" "mc-curr-conv"
 *L0BZ*              "(input mc-rpt-curr,
 *L0BZ*                input et_report_curr,
 *L0BZ*                input et_rate1,
 *L0BZ*                input et_rate2,
 *L0BZ*                input et_org_age_amt[i],
 *L0BZ*                input true,  /* ROUND */
 *L0BZ*                output et_org_age_amt[i],
 *L0BZ*                output mc-error-number)"}
 *L0BZ* /*L03L*/  if mc-error-number <> 0 then do:
 *L0BZ* /*L03L*/     {mfmsg.i mc-error-number 2}
 *L0BZ* /*L03L*/  end.
 *L0BZ*/

/*L0BZ*/          run ip-curr-conv
/*L0BZ*/             (input mc-rpt-curr,
/*L0BZ*/              input et_report_curr,
/*L0BZ*/              input et_rate1,
/*L0BZ*/              input et_rate2,
/*L0BZ*/              input et_org_age_amt[i],
/*L0BZ*/              input true,  /* ROUND */
/*L0BZ*/              output et_org_age_amt[i]).

/*L03L*/       end.  /* if et_report_curr <> mc-rpt-curr */
/*L03L*/    end.  /* do i = 1 to 4 */
/*L03L*/    if et_report_curr <> mc-rpt-curr then do:

/*L0BZ* /*L03L*/ {gprunp.i "mcpl" "p" "mc-curr-conv"
 *L0BZ*           "(input mc-rpt-curr,
 *L0BZ*             input et_report_curr,
 *L0BZ*             input et_rate1,
 *L0BZ*             input et_rate2,
 *L0BZ*             input et_org_amt,
 *L0BZ*             input true,  /* ROUND */
 *L0BZ*             output et_org_amt,
 *L0BZ*             output mc-error-number)"}
 *L0BZ* /*L03L*/ if mc-error-number <> 0 then do:
 *L0BZ* /*L03L*/  {mfmsg.i mc-error-number 2}
 *L0BZ* /*L03L*/ end.
 *L0BZ*/

/*L0BZ*/       run ip-curr-conv
/*L0BZ*/          (input  mc-rpt-curr,
/*L0BZ*/           input  et_report_curr,
/*L0BZ*/           input  et_rate1,
/*L0BZ*/           input  et_rate2,
/*L0BZ*/           input  et_org_amt,
/*L0BZ*/           input  true,  /* ROUND */
/*L0BZ*/           output et_org_amt).

/*L0BZ* /*L03L*/ {gprunp.i "mcpl" "p" "mc-curr-conv"
 *L0BZ*           "(input mc-rpt-curr,
 *L0BZ*             input et_report_curr,
 *L0BZ*             input et_rate1,
 *L0BZ*             input et_rate2,
 *L0BZ*             input et_org_curr_amt,
 *L0BZ*             input true,  /* ROUND */
 *L0BZ*             output et_org_curr_amt,
 *L0BZ*             output mc-error-number)"}
 *L0BZ* /*L03L*/ if mc-error-number <> 0 then do:
 *L0BZ* /*L03L*/  {mfmsg.i mc-error-number 2}
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

/*L03L*/    end.  /* if et_report_curr <> mc-rpt-curr */

            /* DISPLAY CONVERTED REPORT AMOUNTS */
/*L01G*     if et_show_diff and et_tk_active */
/*L01G*/    if et_ctrl.et_show_diff
            and (
                ((accum total et_age_amt[1]) - et_org_age_amt[1] <> 0 )
            or  ((accum total et_age_amt[2]) - et_org_age_amt[2] <> 0 )
            or  ((accum total et_age_amt[3]) - et_org_age_amt[3] <> 0 )
            or  ((accum total et_age_amt[4]) - et_org_age_amt[4] <> 0 )
            or  ((accum total et_age_amt[5]) - et_org_age_amt[5] <> 0 )
            or  ((accum total et_age_amt[6]) - et_org_age_amt[6] <> 0 )
            or  ((accum total et_age_amt[7]) - et_org_age_amt[7] <> 0 )
            or  ((accum total et_age_amt[8]) - et_org_age_amt[8] <> 0 )
            or  ((accum total et_base_amt)   - et_org_amt        <> 0 )
                )
            then do:

               /* DISPLAY REPORT DIFFRENCCES */
/*L03L       display
/*L03L*/          (trim(substring(et_diff_txt,1,36)) + ":")
/*L03L*/          format "x(37)" @ l_label1
                  ((accum total et_age_amt[1]) - et_org_age_amt[1])
/*L03L*           to 57 */
/*L03L*/          @ et_age_amt[1]
                  ((accum total et_age_amt[2]) - et_org_age_amt[2])
/*L03L*           to 75 */
/*L03L*/          @ et_age_amt[2]
                  ((accum total et_age_amt[3]) - et_org_age_amt[3])
/*L03L*           to 93 */
/*L03L*/          @ et_age_amt[3]
                  ((accum total et_age_amt[4]) - et_org_age_amt[4])
/*L03L*           to 111 */
/*L03L*/          @ et_age_amt[4]
                  ((accum total  (et_base_amt)) - et_org_amt)
/*L03L*           to 129. */
/*L03L*/          @ et_base_amt
/*L03L*/       with frame e STREAM-IO /*GUI */ . */
            end. /* IF ET_SHOW_DIFF */
/*L00S*     END ADD */

/*L00S*     ADD */
/*L0BZ*     et_diff_exist = false.  *L0BZ*/
/*L01G*     if et_tk_active and et_show_diff and */
/*L0BZ* /*L01G*/    if  *L0BZ*/

/*L0BZ*/    et_diff_exist =
/*L01G*/       et_ctrl.et_show_diff and
               (
               (((accum total (et_base_amt)) - et_org_amt)      <> 0) or
               (((accum total (et_curr_amt)) - et_org_curr_amt) <> 0) or
               ((((accum total (et_curr_amt)) - et_org_curr_amt) -
                 ((accum total (et_base_amt)) - et_org_amt) ) <> 0)
               ).

/*L0BZ*     then et_diff_exist = true.  *L0BZ*/
/*L00S*     END ADD */

   /*         if base_rpt = "" then
/*L00S*/    do on endkey undo, leave:
               display
/*L00S*/          et_diff_txt to 96 when (et_diff_exist)
/*L00S*           "     Total Base Aging:" to 44 */

/*L03L* /*L00S*/  "Total " + et_disp_curr + fill(" ",4 - length(et_disp_curr))*/
/*L03L* /*L00S*/  + " Aging:" format "x(17)" to 44 */
/*L03L*/          {&apvorp04_p_29} + et_report_curr + {&apvorp04_p_30}
/*L03L*/          format "x(17)" to 45

/*L00S*           (accum total (base_amt)) */
/*L00S*/          (accum total (et_base_amt))
                     format "->>>>>,>>>,>>9.99" at 46

/*L00S*/          ((accum total (et_base_amt)) - et_org_amt)
/*L00S*/             format "->>>>>,>>>,>>9.99" at 77
/*L00S*/             when (et_diff_exist)

                  {&apvorp04_p_15} +
                     string(vodate1) + ":"
                     format "x(44)" to 44
/*L00S*           accum total (curr_amt) */
/*L00S*/          accum total et_curr_amt
                     format "->>>>>,>>>,>>9.99" at 46

/*L00S*/          ((accum total(et_curr_amt)) - et_org_curr_amt)
/*L00S*/             format "->>>>>,>>>,>>9.99" at 77
/*L00S*/             when (et_diff_exist)

                  {&apvorp04_p_17} to 44
/*L00S*           (accum total (curr_amt)) - (accum total (base_amt)) */
/*L00S*/          (accum total (et_curr_amt)) - (accum total (et_base_amt))
                     format "->>>>>,>>>,>>9.99" at 46

/*L00S*/          ( ( (accum total (et_curr_amt)) - et_org_curr_amt) -
/*L00S*/          ( (accum total (et_base_amt))    - et_org_amt) )
/*L00S*/             format "->>>>>,>>>,>>9.99" at 77
/*L00S*/             when (et_diff_exist)

               with frame d width 132 no-labels STREAM-IO /*GUI*/ . 

/*L00S*/    end. /* IF BASE-RPT = "" */  */

            /* REPORT TRAILER */
            hide frame phead1.
            {mfrtrail.i}

         end.

/*L03L*  {wbrp04.i &frame-spec = a} */


/*L0BZ*/ procedure ip-param-init:


            if ref1    = hi_char then ref1    = "".
            if vend1   = hi_char then vend1   = "".
            if vodate1 = hi_date then vodate1 = ?.
            if entity1 = hi_char then entity1 = "".
            if votype1 = hi_char then votype1 = "".
            if vdtype1 = hi_char then vdtype1 = "".
          assign
              age_days[1] = 30
              age_days[2] = 60
              age_days[3] = 90
              age_days[4] = 120
              age_days[5] = 150
              age_days[6] = 180
              age_days[7] =360
              age_days[8] = 390.
           end procedure.  /* ip-param-init */


/*L0BZ*/ procedure ip-param-quoter:


            bcdparm = "".
            {mfquoter.i vend           }
            {mfquoter.i vend1          }
            {mfquoter.i vdtype         }
            {mfquoter.i vdtype1        }
            {mfquoter.i entity         }
            {mfquoter.i entity1        }
            {mfquoter.i ref            }
            {mfquoter.i ref1           }
            {mfquoter.i votype         }
            {mfquoter.i votype1        }
            {mfquoter.i vodate1        }
            {mfquoter.i age_by         }
            {mfquoter.i base_rpt       }
            {mfquoter.i et_report_curr }
            {mfquoter.i age_days[1]    }
            {mfquoter.i age_days[2]    }
            {mfquoter.i age_days[3]    }
            {mfquoter.i age_days[4]    }
            {mfquoter.i age_days[5]    }
            {mfquoter.i age_days[6]    }
            {mfquoter.i age_days[7]    }
            if ref1    = "" then ref1    = hi_char.
            if vend1   = "" then vend1   = hi_char.
            if vodate1 = ?  then vodate1 = hi_date.
            if entity1 = "" then entity1 = hi_char.
            if votype1 = "" then votype1 = hi_char.
            if vdtype1 = "" then vdtype1 = hi_char.
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


/*L0BZ*/ procedure ip-get-ex-rate:


            define input  parameter i_curr1 as character no-undo.
            define input  parameter i_curr2 as character no-undo.
            define input  parameter i_type  as character no-undo.
            define input  parameter i_date  as date      no-undo.
            define output parameter o_rate  as decimal   no-undo.
            define output parameter o_rate2 as decimal   no-undo.
            define output parameter o_error as integer   no-undo.


            {gprunp.i "mcpl" "p" "mc-get-ex-rate"
               "(input  i_curr1,
                 input  i_curr2,
                 input  i_type,
                 input  i_date,
                 output o_rate,
                 output o_rate2,
                 output o_error)" }


         end procedure.  /* ip-get-ex-rate */


/*L0BZ*/ procedure ip-disp-voucher:


            if net <> 0 then do:
               if newvend then
           /*       display
                     ap_mstr.ap_vend no-label
                     name            no-label                  
                  with frame e side-labels width 256 STREAM-IO /*GUI*/ .*/

               newvend = no.
            /*   display
                  voucherno
                  space(5)
                  invdate
                  effdate
                  vo_mstr.vo_cr_terms
                  et_age_amt  format "->>>>>,>>>,>>9.99"
                  et_base_amt format "->>>>>,>>>,>>9.99"
                  hold
               with frame c STREAM-IO /*GUI*/ .*/

         /*      if multi-due then put invoice at 1 {&apvorp04_p_12} at 14.
               else put invoice at 1 duedate at 14.*/

               if base_curr <> ap_mstr.ap_curr then
            /*      put
                     (ap_mstr.ap_ex_rate / ap_mstr.ap_ex_rate2) at 22 space(1)
                     ap_mstr.ap_curr.*/
            end.


         end procedure.  /* ip-disp-voucher */


/*L0BZ*/ procedure ip-set-vars:


            assign
               ckdtotal   = 0
               voidtotal  = 0
               age_amt    = 0
               et_age_amt = 0
               voflag     = ap_mstr.ap_effdate <= vodate1
               net        = 0
               age_period = 8.

            if voflag then do:

               assign
                  age_by_date =
                     if age_by = "EFF"
                        then ap_effdate
                        else
                           if age_by = "INV"
                              then ap_date
                              else vo_mstr.vo_due_date
                  age_period = 8.

               do i = 1 to 8:
                  if (vodate1 - age_days[i]) <= age_by_date then
                     age_period = i.
                  if age_period <> 8 then leave.
               end.
               if age_by_date = ? then age_period = 1.

               assign
                  voucherno = ap_ref
                  effdate   = ap_effdate
                  invoice   = vo_invoice
                  duedate   = vo_due_date
                  invdate   = ap_date
                  net       = ap_amt.
            end.  /* if vo_flag */


         end procedure.  /* ip-set-vars */


/*L0BZ*/ procedure ip-set-due-date:


            due-date =
               if ct_mstr.ct_due_date <> ?
                  then ct_due_date
                  else
                     if ct_from_inv = 1
                        then ap_mstr.ap_date + ct_due_days
                        else
                           date((month(ap_date) + 1) mod 12 +
                                   if month(ap_date) = 11
                                      then 12 else 0,
                                1,
                                year(ap_date) +
                                   if month(ap_date) >= 12
                                      then 1 else 0) +
                           integer(ct_due_days) -
                           if ct_due_days <> 0 then 1 else 0.


         end procedure.  /* ip-set-due-date */


/*L0BZ*/ procedure ip-set-ap:


            if voflag = no and available apmaster then do:
               age_period = 8.
               do i = 1 to 8:
                  if (vodate1 - age_days[i]) <= apmaster.ap_effdate
                     then age_period = i.
                  if age_period <> 8 then leave.
               end.
               if apmaster.ap_effdate = ? then age_period = 1.
               assign
                  voucherno = apmaster.ap_ref
                  invoice   = {&apvorp04_p_31}
                  effdate   = apmaster.ap_effdate
                  invdate   = apmaster.ap_date
                  duedate   = ?.
            end.


         end procedure.  /* ip-set-ap */
