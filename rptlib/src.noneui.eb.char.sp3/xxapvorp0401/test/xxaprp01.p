/* apvorp04.p - AP AGING REPORT as of effective date                         */
/* Copyright 1986-2001 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/*F0PN*/ /*K0P6*/ /*                                                         */
/*V8:ConvertMode=Report                                                      */
/*L03L*/ /*V8:RunMode=Character,Windows                                      */
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
/*L0BZ*/ /* Changed ConvertMode from FullGUIReport to Report                 */
/* REVISION: 8.6E     LAST MODIFIED: 10/20/98   BY: *L0CB* Jeff Wootton      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 04/12/00   BY: *N07D* Antony Babu       */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* REVISION: 9.1      LAST MODIFIED: 08/19/00   BY: *N0MG* BalbeerS Rajput   */
/* REVISION: 9.1      LAST MODIFIED: 10/21/00   BY: *N0VQ* BalbeerS Rajput   */
/* REVISION: 9.1      LAST MODIFIED: 04/12/01   BY: *M14T* Vihang Talwalkar  */
/*****************************************************************************/

/*J2PS*/ /* ADDED NO-UNDO TO LOCAL VARIABLES, ADDED ASSIGN TO ASSIGNMENT     */
/*J2PS*/ /* STATEMENTS, CHANGED FOR FIRST/LAST TO FOR EACH                   */

/* 以下为版本历史 */
/* SS - 090317.1 By: Bill Jiang */

/*以下为发版说明 */
/* SS - 090317.1 - RNB
【090317.1】

修改于以下标准菜单程序:
  - 采购收货报表 [poporp06.p]

请参考以上标准菜单程序的相关帮助

请参考以下标准菜单程序进行验证:
  - 采购收货报表 [poporp06.p]

顺序输出了以下字段:
  - 供应商
  - 供应商名称
  - 凭证
  - 类型
  - 生效日期
  - 截止日期
  - 支付方式
  - 原币
  - 原币单位
  - 本币单位
  - 本币金额[1]
  - 本币金额[2]
  - 本币金额[3]
  - 本币金额[4]
  - 本币金额[5]
  - 本币金额[6]
  - 本币金额[7]
  - 本币金额[8]
  - 本币金额合计
  - 原币金额合计
  - 发票原币金额合计

【090317.1】

SS - 090317.1 - RNE */

         /* DISPLAY PROGRAM TITLE */
         /*
         {mfdtitle.i "b+ "}
         */
         {mfdtitle.i "090317.1"}

         /* SS - 090317.1 - B */
         {xxapvorp0401.i "new"}
         /* SS - 090317.1 - E */

/*N0VQ*/ {cxcustom.i "APVORP04.P"}

         /* ********** Begin Translatable Strings Definitions ********* */

         &SCOPED-DEFINE apvorp04_p_5 "Supplier Type"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp04_p_7 "Voucher Type"
         /* MaxLen: Comment: */

/*N0MG*
 *       &SCOPED-DEFINE apvorp04_p_9 "Must be DUE, EFF, or INV, Please re-enter."
 *       /* MaxLen: Comment: */
 *N0MG*/

         &SCOPED-DEFINE apvorp04_p_10 "Age by Date (DUE,EFF,INV)"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE apvorp04_p_13 "Column Days"
         /* MaxLen: Comment: */

/*N07D** -------------- BEGIN - COMMENT CODE ----------------------------
*        &SCOPED-DEFINE apvorp04_p_1 "Report"
*        /* MaxLen: Comment: */
*
*        &SCOPED-DEFINE apvorp04_p_2 "Voucher     "
*        /* MaxLen: Comment: */
*
*        &SCOPED-DEFINE apvorp04_p_3 "Totals:"
*        /* MaxLen: Comment: */
*
*        &SCOPED-DEFINE apvorp04_p_4 "Supplier"
*        /* MaxLen: Comment: */
*
*        &SCOPED-DEFINE apvorp04_p_6 "Total Amount"
*        /* MaxLen: Comment: */
*
*        &SCOPED-DEFINE apvorp04_p_8 "Days Old         "
*        /* MaxLen: Comment: */
*
*        &SCOPED-DEFINE apvorp04_p_11 "Exg Rate"
*        /* MaxLen: Comment: */
*
*        &SCOPED-DEFINE apvorp04_p_12 "Multiple"
*        /* MaxLen: Comment: */
*
*        &SCOPED-DEFINE apvorp04_p_14 "Eff Date"
*        /* MaxLen: Comment: */
*
*        &SCOPED-DEFINE apvorp04_p_15 "       Aging at Exchange Rates for "
*        /* MaxLen: Comment: */
*
*        &SCOPED-DEFINE apvorp04_p_16 "Currency     "
*        /* MaxLen: Comment: */
*
*        &SCOPED-DEFINE apvorp04_p_17 "     Variance:"
*        /* MaxLen: Comment: */
*
*        &SCOPED-DEFINE apvorp04_p_18 "Cr Terms"
*        /* MaxLen: Comment: */
*
*        &SCOPED-DEFINE apvorp04_p_19 "     Total Base Aging:"
*        /* MaxLen: Comment: */
*
*        &SCOPED-DEFINE apvorp04_p_20 "Due Date"
*        /* MaxLen: Comment: */
*
*        &SCOPED-DEFINE apvorp04_p_21 "  Less Than "
*        /* MaxLen: Comment: */
*
*        &SCOPED-DEFINE apvorp04_p_22 " Over "
*        /* MaxLen: Comment: */
*
*        &SCOPED-DEFINE apvorp04_p_23 "Invoice     "
*        /* MaxLen: Comment: */
*
*        &SCOPED-DEFINE apvorp04_p_24 "Inv Date"
*        /* MaxLen: Comment: */
*
* /*J2G3*/ /* HARDCODED LABEL  "Base     Supplier Totals:" HAS BEEN REPLACED */
*         &SCOPED-DEFINE apvorp04_p_25 "Base     Supplier Totals:"
*  /* MaxLen: 25 Comment: NO BLANK CHARACTERS SHOULD BE CONVERTED AND TRIMED */
*
* /*J2G3*/ /* HARDCODED LABEL  "Base     Report   Totals:" HAS BEEN REPLACED */
*        &SCOPED-DEFINE apvorp04_p_26 "Base     Report   Totals:"
*  /* MaxLen: 25 Comment: NO BLANK CHARACTERS SHOULD BE CONVERTED AND TRIMED */
*
* /*J2G3*/ /* HARDCODED LABEL  "      Supplier Totals:" HAS BEEN REPLACED */
*          &SCOPED-DEFINE apvorp04_p_27 "      Supplier Totals:"
*  /* MaxLen: 22 Comment: NO BLANK CHARACTERS SHOULD BE CONVERTED AND TRIMED */
*
* /*J2G3*/ /* HARDCODED LABEL  "      Report   Totals:" HAS BEEN REPLACED */
*         &SCOPED-DEFINE apvorp04_p_28 "      Report   Totals:"
*  /* MaxLen: 22 Comment: NO BLANK CHARACTERS SHOULD BE CONVERTED AND TRIMED */
*
* /*L03L*/ &SCOPED-DEFINE apvorp04_p_29 "Total "
*          /* MaxLen: Comment: */
*
* /*L03L*/ &SCOPED-DEFINE apvorp04_p_30 " Aging:"
*          /* MaxLen: Comment: */
*
* /*J2SQ*/ &SCOPED-DEFINE apvorp04_p_31 "Payment"
*          /* MaxLen: Comment: */
*
**N07D** -------------- END - COMMENT CODE ----------------------------*/

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

         /* SS - 090317.1 - B
/*L0BZ*  define variable type like ap_type format "X(12)".  *L0BZ*/
         define variable age_days as integer extent 4 label {&apvorp04_p_13}.
         define variable age_range as character extent 4 format "X(17)".
         define variable i as integer.
         define variable age_amt like ap_amt extent 4
            format "->>>>,>>>,>>>.99".
         SS - 090317.1 - E */

         /* SS - 090317.1 - B */
/*L0BZ*  define variable type like ap_type format "X(12)".  *L0BZ*/
         define variable age_days as integer extent 8 label {&apvorp04_p_13}.
         define variable age_range as character extent 8 format "X(17)".
         define variable i as integer.
         define variable age_amt like ap_amt extent 8
            format "->>>>,>>>,>>>.99".
         /* SS - 090317.1 - E */

         define variable net like ap_amt.
         define variable age_period as integer.
         define variable newvend as logical.
         define variable base_rpt like ap_curr.
         define variable base_applied like vo_applied.
         define variable base_amt like ap_amt.
         define variable curr_amt like ar_amt.
         define variable invoice like vo_invoice.
         define variable effdate like ap_effdate.
         define variable voflag as logical.
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
/*N0MG*     {&apvorp04_p_10} initial "DUE". */
/*N0MG*/    {&apvorp04_p_10}.
/*N0MG*/ define variable l_msg as character no-undo.
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

/*L00S*  BEGIN ADDED SECTION*/
         {etrpvar.i &new = "new"}
         {etvar.i   &new = "new"}
         {eteuro.i  }

         /* SS - 090317.1 - B
/*L0BZ* /*L03L*  define variable et_select_curr   like ex_curr. */  *L0BZ*/
         define variable et_age_amt       like ap_amt extent 4.
         define variable et_base_amt      like ap_amt.
/*L0BZ*  define variable et_base_applied  like vo_applied.  *L0BZ*/
/*L0BZ*  define variable et_base_hold_amt like vo_hold_amt.  *L0BZ*/
         define variable et_curr_amt      like ap_amt.
/*L0BZ*  define variable et_adj_amt       like vo_hold_amt.  *L0BZ*/
         define variable et_org_age_amt   like ap_amt extent 4.
         SS - 090317.1 - E */

         /* SS - 090317.1 - B */
/*L0BZ* /*L03L*  define variable et_select_curr   like ex_curr. */  *L0BZ*/
         define variable et_age_amt       like ap_amt extent 8.
         define variable et_base_amt      like ap_amt.
/*L0BZ*  define variable et_base_applied  like vo_applied.  *L0BZ*/
/*L0BZ*  define variable et_base_hold_amt like vo_hold_amt.  *L0BZ*/
         define variable et_curr_amt      like ap_amt.
/*L0BZ*  define variable et_adj_amt       like vo_hold_amt.  *L0BZ*/
         define variable et_org_age_amt   like ap_amt extent 8.
         /* SS - 090317.1 - E */

         define variable et_org_amt       like ap_amt.
         define variable et_org_curr_amt  like ap_amt.
/*L0BZ* /*L03L*  define variable input_curr       like ex_curr. */  *L0BZ*/
         define variable et_diff_exist    like mfc_logical.
/*L00S*  END ADDED SECTION*/

/*L0BZ*/ define variable v_ckd_net        like ckd_amt   no-undo.

/*M14T*/ define variable l_batchid        like bcd_batch no-undo.

         define buffer apmaster for ap_mstr.

         /* SS - 090317.1 - B */
         DEFINE VARIABLE acct LIKE ap_acct.
         DEFINE VARIABLE acct1 LIKE ap_acct.
         DEFINE VARIABLE sub LIKE ap_sub.
         DEFINE VARIABLE sub1 LIKE ap_sub.
         DEFINE VARIABLE cc LIKE ap_cc.
         DEFINE VARIABLE cc1 LIKE ap_cc.

         DEFINE VARIABLE TYPE_vo LIKE vo_type.
         DEFINE VARIABLE amt_ap LIKE ap_amt.
         /* SS - 090317.1 - E */

         find first gl_ctrl no-lock.

/*N0VQ*/ {&APVORP04-P-TAG1}
         form
            vend colon 15
            vend1          label {t001.i} colon 49
            vdtype         colon 15
            vdtype1        label {t001.i} colon 49
            /* SS - 090317.1 - B */
            acct colon 15
            acct1          label "To" colon 49
            sub colon 15
            sub1          label "To" colon 49
            cc colon 15
            cc1          label "To" colon 49
            /* SS - 090317.1 - E */
            entity         colon 15
            entity1        label {t001.i} colon 49
            ref            colon 15
            ref1           label {t001.i} colon 49
            votype         colon 15
            votype1        label {t001.i} colon 49 
            /* SS - 090317.1 - B
            skip (1)
            SS - 090317.1 - E */
            vodate1        colon 30
            age_by         colon 30
               validate((lookup(age_by,"DUE,EFF,INV") <> 0),
/*N0MG*        {&apvorp04_p_9})*/
/*N0MG*/       l_msg)
/*L00S*     base_rpt        colon 30 skip (1) */
/*L00S*/    base_rpt        colon 30
/*L03L*/    et_report_curr  colon 30 
            /* SS - 090317.1 - B
            skip(1)
            SS - 090317.1 - E */
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
            age_days[3]    label "[3]" 
            /* SS - 090317.1 - B */
            age_days[4]    label "[4]"
            age_days[5]    label "[5]" 
            age_days[6]    label "[6]"
            age_days[7]    label "[7]" 
            /* SS - 090317.1 - E */
            skip (1)
         with frame a side-labels width 80.
/*N0VQ*/ {&APVORP04-P-TAG2}

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).

/*N0MG*/ age_by = getTermLabel("DUE_DATE", 3).
/*N0MG*/ {pxmsg.i
          &MSGNUM = 3719
          &ERRORLEVEL = 3
          &MSGBUFFER = l_msg
         }

/*L03L*  {wbrp01.i} */
         repeat:

/*L0BZ*     if ref1    = hi_char then ref1    = "".
 *L0BZ*     if vend1   = hi_char then vend1   = "".
 *L0BZ*     if vodate1 = hi_date then vodate1 = ?.
 *L0BZ*     if entity1 = hi_char then entity1 = "".
 *L0BZ*     if votype1 = hi_char then votype1 = "".
 *L0BZ*     if vdtype1 = hi_char then vdtype1 = "".
 *L0BZ*     do i = 1 to 4:
 *L0BZ*        if age_days[i] = 0 then age_days[i] = (i * 30).
 *L0BZ*     end.
 *L0BZ*/

/*L0BZ*/    run ip-param-init.

/*L01G* /*L00S*/    display */
/*L01G* /*L00S*/       et_report_txt when (et_tk_active) */
/*L01G* /*L00S*/       et_rate_txt when (et_tk_active) */
/*L01G* /*L00S*/    with frame a. */

/*L03L*     if c-application-mode <> 'web' then */
/*N0VQ*/    {&APVORP04-P-TAG3}
               update
                  vend vend1
                  vdtype vdtype1
                  /* SS - 090317.1 - B */
                  acct acct1
                  sub sub1
                  cc cc1
                  /* SS - 090317.1 - E */
                  entity entity1
                  ref ref1
                  votype votype1
                  vodate1
                  age_by
                  base_rpt
/*L00S*/          et_report_curr
/*L03L* /*L00S*/  et_report_rate */
                  /* SS - 090317.1 - B
                  age_days[1 for 3]
                  SS - 090317.1 - E */
                  /* SS - 090317.1 - B */
                  age_days[1 for 7]
                  /* SS - 090317.1 - E */
               with frame a.

/*L03L*
 *          {wbrp06.i &command = update
 *                    &fields = "  vend vend1 vdtype vdtype1
 *                                 entity entity1 ref ref1 votype votype1
 *                                 vodate1   age_by base_rpt
 * /*L00S*/                        et_report_curr
 * /*L00S*/                        et_report_rate
 *                                 age_days [ 1 for 3 ]" &frm = "a"}
 *L03L*/

/*L03L* /*L00S*/    if et_report_curr = "" then et_disp_curr = base_rpt. */
/*L03L* /*L00S*/    else et_disp_curr = et_report_curr. */

/*L03L* /*L00S*/    {etcurval.i &curr = "et_report_curr"  &errlevel = "4" */
/*L03L* /*L00S*/                &action = "next"   &prompt   = "pause" } */

/*L00S*/    et_eff_date = vodate1.
/*N0VQ*/    {&APVORP04-P-TAG4}
/*L03L* /*L00S*/    if base_rpt = "base" then input_curr = "". */
/*L03L* /*L00S*/    else input_curr = base_rpt. */
/*L03L* /*L00S*/    {gprun.i ""etrate.p"" "(input input_curr)"} */

/*L03L*     if (c-application-mode <> 'web') or */
/*L03L*        (c-application-mode = 'web' and */
/*L03L*        (c-web-request begins 'data')) then do: */

/*L08W*     Code below to be wrapped in a 'do' code block for correct GUI conversion  */
/*L08W*/    do:

/*L0BZ*        bcdparm = "".
 *L0BZ*        {mfquoter.i vend       }
 *L0BZ*        {mfquoter.i vend1      }
 *L0BZ*        {mfquoter.i vdtype     }
 *L0BZ*        {mfquoter.i vdtype1    }
 *L0BZ*        {mfquoter.i entity     }
 *L0BZ*        {mfquoter.i entity1    }
 *L0BZ*        {mfquoter.i ref        }
 *L0BZ*        {mfquoter.i ref1       }
 *L0BZ*        {mfquoter.i votype     }
 *L0BZ*        {mfquoter.i votype1    }
 *L0BZ*        {mfquoter.i vodate1    }
 *L0BZ*        {mfquoter.i age_by     }
 *L0BZ*        {mfquoter.i base_rpt   }
 *L0BZ* /*L01G* /*L00S*/if et_tk_active then do: */
 *L0BZ* /*L00S*/          {mfquoter.i et_report_curr }
 *L0BZ* /*L03L* /*L00S*/  {mfquoter.i et_report_rate } */
 *L0BZ* /*L01G* /*L00S*/end. */
 *L0BZ*        {mfquoter.i age_days[1]}
 *L0BZ*        {mfquoter.i age_days[2]}
 *L0BZ*        {mfquoter.i age_days[3]}
 *L0BZ*        if ref1    = "" then ref1    = hi_char.
 *L0BZ*        if vend1   = "" then vend1   = hi_char.
 *L0BZ*        if vodate1 = ?  then vodate1 = hi_date.
 *L0BZ*        if entity1 = "" then entity1 = hi_char.
 *L0BZ*        if votype1 = "" then votype1 = hi_char.
 *L0BZ*        if vdtype1 = "" then vdtype1 = hi_char.
 *L0BZ*/

/*L0BZ*/       run ip-param-quoter.
/*N0VQ*/       {&APVORP04-P-TAG5}

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

/*L03L*     end.  /* if (c-application-mode <> 'web') ... */ */
/*L08W*/    end.

/*J2G3*/    /* DISPLAY THE TOTAL LABELS AS CONTINUOUS STRINGS FOR CORRECT */
/*J2G3*/    /* TRANSLATION                                                */

/*N07D**  -------------- BEGIN - COMMENT ----------------------------
* /*J2G3*/    if base_rpt = ""
* /*L03L*/    and et_report_curr = base_curr
* /*J2G3*/    then
* /*J2G3*/       assign
* /*J2G3*/          l_label1 = {&apvorp04_p_25}
* /*J2G3*/          l_label2 = {&apvorp04_p_26}.
* /*J2G3*/       else assign
* /*L03L* /*J2G3*/  l_label1 = string(base_rpt,"x(3)") + {&apvorp04_p_27} */
* /*L03L* /*J2G3*/  l_label2 = string(base_rpt,"x(3)") + {&apvorp04_p_28}. */
* /*L03L*/          l_label1 = string(et_report_curr,"x(3)") + {&apvorp04_p_27}
* /*L03L*/          l_label2 = string(et_report_curr,"x(3)") + {&apvorp04_p_28}.
**N07D**  -------------- END - COMMENT ----------------------------*/
/*N07D** -------------- BEGIN - ADD CODE  ------------------------*/
            if base_rpt = ""
            and et_report_curr = base_curr
            then
               assign
                  l_label1 = getTermLabelRtColon("BASE_SUPPLIER_TOTALS",25)
                  l_label2 = getTermLabelRtColon("BASE_REPORT_TOTALS",25) .
               else assign
                  l_label1 = string(et_report_curr,"x(3)") + " "
                  + getTermLabelRtColon("SUPPLIER_TOTALS",21)
                  l_label2 = string(et_report_curr,"x(3)") + " "
                  + getTermLabelRtColon("REPORT_TOTALS",21) .
/*N07D** -------------- END - ADD CODE ---------------------------*/

/*L01G* /*L00S*/  if et_tk_active and et_disp_curr <> "" */
/*L03L* /*L01G*/  if et_disp_curr <> "" */
/*L03L* /*L00S*/  then assign */
/*L03L* /*L00S*/   l_label1 = string(et_disp_curr,"x(3)") + {&apvorp04_p_27} */
/*L03L* /*L00S*/   l_label2 = string(et_disp_curr,"x(3)") + {&apvorp04_p_28}.*/

            /* SELECT PRINTER */

/*M14T*/    on go anywhere
/*M14T*/    do:
/*M14T*/       if frame-field = "batch_id":U
/*M14T*/       then
/*M14T*/          l_batchid = frame-value.

/*M14T*/       /* TO CHECK NON-BLANK VALUE OF BATCH ID WHEN CURSOR IS */
/*M14T*/       /* IN BATCH ID OR OUTPUT FIELD                         */
/*M14T*/       if ((frame-field       =  "batch_id":U
/*M14T*/            and frame-value   <> "")
/*M14T*/            or (frame-field   =  "dev":U
/*M14T*/                and l_batchid <> ""))
/*M14T*/            and (mc-rpt-curr  <> et_report_curr)
/*M14T*/       then do:
/*M14T*/          /* USER-INPUT EXCHANGE RATE WILL BE IGNORED IN BATCH MODE */
/*M14T*/          {mfmsg.i 4629 2}
/*M14T*/          pause.
/*M14T*/       end. /* IF FRAME-FIELD = "batch_id" AND ... */
/*M14T*/    end. /* ON GO ANYWHERE */

            {mfselbpr.i "printer" 132}
            /* SS - 090317.1 - B
            {mfphead.i}

            /* CREATE REPORT HEADER */
/*N07D**  -------------- BEGIN - COMMENT ----------------------------
*           do i = 2 to 4:
*              age_range[i] = {&apvorp04_p_22}
*                           + string(age_days[i - 1],"->>>9").
*           end.
*           age_range[1] = {&apvorp04_p_21} + string(age_days[1],"->>>9").
**N07D**  -------------- END - COMMENT ----------------------------*/
/*N07D** -------------- BEGIN - ADD CODE  ------------------------*/
            do i = 2 to 4:
               age_range[i] = getTermLabelCentered("OVER",6)
                            + string(age_days[i - 1],"->>>9").
            end.
            age_range[1] = getTermLabelCentered("LESS_THAN",12)
                 +  string(age_days[1],"->>>9").
/*N07D** -------------- END - ADD CODE ---------------------------*/

/*N07D**  -------------- BEGIN - COMMENT ----------------------------
*             form header
* /*L03L*/       mc-curr-label et_report_curr skip
* /*L03L*/       mc-exch-label mc-exch-line1 skip
* /*L03L*/       mc-exch-line2 at 23 skip(1)
*                {&apvorp04_p_2}
*                {&apvorp04_p_24}
*                {&apvorp04_p_14}
*                {&apvorp04_p_18}
*                age_range[1]       space (4)
*                age_range[2]       space (1)
*                age_range[3]       space (1)
*                age_range[4]    skip
*                {&apvorp04_p_23}
*                {&apvorp04_p_20}
*                {&apvorp04_p_11}
*                {&apvorp04_p_16}
*                {&apvorp04_p_8}
*                {&apvorp04_p_8}
*                {&apvorp04_p_8}
*                {&apvorp04_p_8}
*                {&apvorp04_p_6} skip
**N07D**  -------------- END - COMMENT ----------------------------*/

/*N07D** -------------- BEGIN - ADD CODE  ------------------------*/

            form header
               mc-curr-label et_report_curr skip
               mc-exch-label mc-exch-line1 skip
               mc-exch-line2 at 23 skip(1)
           (getTermLabel("VOUCHER",12))       format "x(12)"
           (getTermLabel("INVOICE_DATE",8))   format "x(8)"
           (getTermLabel("EFFECTIVE_DATE",8)) format "x(8)"
           (getTermLabel("CREDIT_TERMS",8))   format "x(8)"
               age_range[1]       space (4)
               age_range[2]       space (1)
               age_range[3]       space (1)
               age_range[4]    skip(0)
           (getTermLabel("INVOICE",12))          format "x(12)"
           (getTermLabel("DUE_DATE",8))          format "x(8)"
           (getTermLabel("EXCHANGE_RATE",8))     format "x(8)"
           (getTermLabel("CURRENCY",8))          format "x(8)"
           (getTermLabelCentered("DAYS_OLD",17)) format "x(17)"
           (getTermLabelCentered("DAYS_OLD",17)) format "x(17)"
           (getTermLabelCentered("DAYS_OLD",17)) format "x(17)"
           (getTermLabelCentered("DAYS_OLD",17)) format "x(17)"
           (getTermLabelRt("TOTAL_AMOUNT",17))   format "x(17)"
           skip
/*N07D** -------------- END - ADD CODE ---------------------------*/
               "------------"
               "--------"
               "--------"
               "--------"
               "-----------------"
               "-----------------"
               "-----------------"
               "-----------------"
               "-----------------" skip
            with frame phead1 width 132 page-top.

            view frame phead1.
/*L0CB*     form with frame c width 132 no-labels no-attr-space no-box down. */
/*N0VQ*/    {&APVORP04-P-TAG6}
/*L0CB*/    form
/*L0CB*/       voucherno
/*L0CB*/          at 1
/*L0CB*/       space(5)
/*L0CB*/       invdate
/*L0CB*/       effdate
/*L0CB*/       vo_mstr.vo_cr_terms
/*L0CB*/       et_age_amt[1] to 57 format "->>>>>,>>>,>>9.99"
/*L0CB*/       et_age_amt[2]       format "->>>>>,>>>,>>9.99"
/*L0CB*/       et_age_amt[3]       format "->>>>>,>>>,>>9.99"
/*L0CB*/       et_age_amt[4]       format "->>>>>,>>>,>>9.99"
/*L0CB*/       et_base_amt format "->>>>>,>>>,>>9.99"
/*L0CB*/    with frame c width 132 no-labels no-attr-space no-box down.
/*N0VQ*/    {&APVORP04-P-TAG7}

/*L00S
 . /*J2G3*/ form
 . /*J2G3*/    l_label1   at 14
 . /*J2G3*/    age_amt[1] to 57 format "->>>>>,>>>,>>9.99"
 . /*J2G3*/    age_amt[2]       format "->>>>>,>>>,>>9.99"
 . /*J2G3*/    age_amt[3]       format "->>>>>,>>>,>>9.99"
 . /*J2G3*/    age_amt[4]       format "->>>>>,>>>,>>9.99"
 . /*J2G3*/    base_amt         format "->>>>>,>>>,>>9.99"
 . /*J2G3*/ with frame e width 132 no-labels no-attr-space no-box down.
 *L00S*/

/*L00S*/    form
/*L00S*/       l_label1
/*L03L* /*L00S*/ at 14 */
/*L03L*/       to 40
/*L00S*/       et_age_amt[1] to 57 format "->>>>>,>>>,>>9.99"
/*L00S*/       et_age_amt[2]       format "->>>>>,>>>,>>9.99"
/*L00S*/       et_age_amt[3]       format "->>>>>,>>>,>>9.99"
/*L00S*/       et_age_amt[4]       format "->>>>>,>>>,>>9.99"
/*L00S*/       et_base_amt         format "->>>>>,>>>,>>9.99"
/*L00S*/    with frame e width 132 no-labels no-attr-space no-box down.

/*J2PS**    for each vd_mstr where (vd_addr >= vend and vd_addr <= vend1) */
/*J2PS*/    for each vd_mstr fields (vd_addr vd_sort vd_type)
/*J2PS*/       where (vd_addr >= vend and vd_addr <= vend1)
                 and (vd_type >= vdtype and vd_type <= vdtype1)
                 use-index vd_sort no-lock break by vd_sort:

/*J2PS*/       assign
                  newvend = yes
                  name    = "".
/*J2PS**       find ad_mstr where ad_addr = vd_addr no-lock no-wait no-error.*/
/*J2PS*/       for first ad_mstr
/*J2PS*/          fields (ad_addr ad_attn ad_ext ad_name ad_phone)
/*J2PS*/          where ad_addr = vd_addr no-lock:
/*L0BZ*/          name = ad_name.
/*J2PS*/       end.
/*L0BZ*        if available ad_mstr then name = ad_name.  *L0BZ*/

/*J2PS**       for each ap_mstr where (ap_vend = vd_addr) */
/*N0VQ*/       {&APVORP04-P-TAG8}
/*J2PS*/       for each ap_mstr
/*J2PS*/          fields (ap_amt  ap_curr ap_date ap_effdate ap_entity
/*L08W*/                  ap_base_amt ap_exru_seq ap_ex_rate2 ap_ex_ratetype
/*L08W*J2PS*              ap_ent_ex ap_ex_rate ap_ref ap_type ap_vend)  */
/*L08W*/                  ap_ex_rate ap_ref ap_type ap_vend)
/*J2PS*/          where (ap_vend = vd_addr)
                    and (ap_entity >= entity and ap_entity <= entity1)
                    and (ap_ref >= ref and ap_ref <= ref1)
                    and (ap_type = "VO")
                    and ((ap_curr = base_rpt)
                      or (base_rpt = ""))
/*J2PS*/            and (ap_date >= 1/1/1850 or ap_date = ?)
/*J2PS**          use-index ap_vend no-lock, */
/*J2PS*/          use-index ap_vend_date no-lock:
/*N0VQ*/          {&APVORP04-P-TAG9}

/*J2PS**          each vo_mstr where vo_ref = ap_ref and vo_confirmed = yes */
/*J2PS*/          for each vo_mstr
/*J2PS*/             fields (vo_applied  vo_confirmed vo_cr_terms vo_due_date
/*J2PS*/                     vo_hold_amt vo_invoice   vo_ref      vo_type)
/*J2PS*/             where vo_ref = ap_ref and vo_confirmed = yes
                       and (vo_type >= votype and vo_type <= votype1)
/*J2PS**             no-lock by ap_vend: */
/*J2PS*/             no-lock:

/*L0BZ*              do i = 1 to 4:
 *L0BZ* /*L03L*/        assign
 *L0BZ*                    age_amt[i]    = 0
 *L0BZ* /*L00S*/           et_age_amt[i] = 0.
 *L0BZ*              end.
 *L0BZ* /*L03L*/     assign
 *L0BZ*                 voflag     = yes
 *L0BZ*                 net        = 0
 *L0BZ*                 age_period = 4.
 *L0BZ*              if ap_effdate >  vodate1 then voflag = no.
 *L0BZ*              else do:
 *L0BZ*              if voflag then do:
 *L0BZ*                 if age_by = "EFF" then age_by_date = ap_effdate.
 *L0BZ*                 else if age_by = "INV" then age_by_date = ap_date.
 *L0BZ*                 else age_by_date = vo_due_date.
 *L0BZ*                 age_period = 4.
 *L0BZ*                 do i = 1 to 4:
 *L0BZ*                    if (vodate1 - age_days[i]) <= age_by_date then
 *L0BZ*                       age_period = i.
 *L0BZ*                    if age_period <> 4 then leave.
 *L0BZ*                 end.
 *L0BZ*                 if age_by_date = ? then age_period = 1.
 *L0BZ* /*L03L*/        assign
 *L0BZ*                    voucherno = ap_ref
 *L0BZ*                    effdate   = ap_effdate
 *L0BZ*                    invoice   = vo_invoice
 *L0BZ*                    duedate   = vo_due_date
 *L0BZ*                    invdate   = ap_date
 *L0BZ*                    net       = ap_amt.
 *L0BZ*              end.
 *L0BZ* /*L03L*/     assign
 *L0BZ*                 tempvend  = ap_vend
 *L0BZ*                 ckdtotal  = 0
 *L0BZ*                 voidtotal = 0.
 *L0BZ*/

/*L0BZ*/             run ip-set-vars.

/*J2PS**             BEGIN DELETE
 *                   for each ckd_det where ckd_voucher = ap_mstr.ap_ref no-lock,
 *                       each ck_mstr where ck_ref = ckd_ref and
 *J2PS**             END DELETE */

/*J2PS*/             for each ckd_det
/*J2PS*/                fields (ckd_amt ckd_cur_amt ckd_cur_disc ckd_disc
/*J2PS*/                        ckd_ref ckd_voucher)
/*J2PS*/                where ckd_voucher = ap_mstr.ap_ref no-lock,
/*J2PS*/                each ck_mstr
/*J2PS*/                   fields (ck_curr ck_ref ck_voideff)
/*J2PS*/                   where ck_ref = ckd_ref and
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
/*J2PS*/                   where ap_ref = ckd_ref and
/*J2PS*/                         ap_type = "CK" no-lock: end.
                        if not available apmaster or
/*L0BZ*                    available apmaster and  *L0BZ*/
                           apmaster.ap_effdate <= vodate1 then do:

/*L0BZ*                    if voflag = no and available apmaster then do:
 *L0BZ*                       age_period = 4.
 *L0BZ*                       do i = 1 to 4:
 *L0BZ*                          if (vodate1 - age_days[i]) <= apmaster.ap_effdate
 *L0BZ*                             then age_period = i.
 *L0BZ*                          if age_period <> 4 then leave.
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

/*N0VQ*/             {&APVORP04-P-TAG10}
                     /* IF CKDTOTAL <> VO_APPLIED THEN ASSUME CK WAS DELETED */
                     if ckdtotal <> (vo_applied + voidtotal) then
                        net = net - (vo_applied - ckdtotal).

/*L03L*/             assign
                        curr_amt = net
                        base_amt = net.
/*N0VQ*/             {&APVORP04-P-TAG11}
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

/*N0VQ*/                {&APVORP04-P-TAG12}
/*L0BZ*/                run ip-get-ex-rate
/*L0BZ*/                   (input  ap_curr,
/*L0BZ*/                    input  base_curr,
/*L0BZ*/                    input  ap_ex_ratetype,
/*L0BZ*/                    input  vodate1,
/*L0BZ*/                    output exdrate,
/*L0BZ*/                    output exdrate2,
/*L0BZ*/                    output mc-error-number).
/*N0VQ*/                {&APVORP04-P-TAG13}

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

/*N0VQ*/             {&APVORP04-P-TAG14}
                     multi-due = no.
/*J2PS**             find ct_mstr where ct_code = vo_cr_terms no-lock no-error.*/
/*J2PS*/             for first ct_mstr
/*J2PS*/                fields (ct_code ct_dating ct_due_date ct_due_days
/*J2PS*/                        ct_from_inv)
/*J2PS*/                where ct_code = vo_cr_terms
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
/*J2PS*/                   where ctd_code = vo_cr_terms no-lock
/*J295**                   use-index ctd_cdseq: */
/*J295*/                   break by ctd_code:

/*J2PS**                   BEGIN DELETE
 *                         find ct_mstr where ct_code = ctd_date_cd no-lock
 *                            no-error.
 *J2PS**                   END DELETE */
/*J2PS*/                   for first ct_mstr
/*J2PS*/                      fields (ct_code ct_dating ct_due_date
/*J2PS*/                              ct_due_days ct_from_inv)
/*J2PS*/                      where ct_code = ctd_date_cd no-lock:

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
                              age_period = 4.
                              do i = 1 to 4:
                                 if (vodate1 - age_days[i]) <= due-date then
                                    age_period = i.
                                 if age_period <> 4 then leave.
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
/*N0VQ*/             {&APVORP04-P-TAG15}

/*L03L* /*L00S*/     {etrpconv.i age_amt[1]   et_age_amt[1]  } */
/*L03L* /*L00S*/     {etrpconv.i age_amt[2]   et_age_amt[2]  } */
/*L03L* /*L00S*/     {etrpconv.i age_amt[3]   et_age_amt[3]  } */
/*L03L* /*L00S*/     {etrpconv.i age_amt[4]   et_age_amt[4]  } */
/*L03L* /*L00S*/     {etrpconv.i base_amt     et_base_amt    } */
/*L03L* /*L00S*/     {etrpconv.i curr_amt     et_curr_amt    } */

/*L03L*/             do i = 1 to 4:
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

/*N0VQ*/             {&APVORP04-P-TAG16}
/*L00S*/             accumulate et_curr_amt (total).
/*L00S*/             accumulate et_age_amt  (total).
/*L00S*/             accumulate et_base_amt (total).

                     accumulate age_amt (total).
                     accumulate base_amt (total).
                     accumulate curr_amt (total).
/*N0VQ*/             {&APVORP04-P-TAG17}

/*L0BZ*              if vo_hold_amt <> 0 then hold = "H".
 *L0BZ*              else hold = "".
 *L0BZ*/

/*L0BZ*/             hold = if vo_hold_amt <> 0 then "H" else "".

/*L0BZ*              if net <> 0 then do:
 *L0BZ*                 if newvend then
 *L0BZ*                    display
 *L0BZ*                       ap_mstr.ap_vend no-label
 *L0BZ*                       name            no-label
 *L0BZ*                       ad_attn
 *L0BZ*                       ad_phone
 *L0BZ*                       ad_ext          no-label
 *L0BZ*                    with frame b
 *L0BZ*                    side-labels width 132.
 *L0BZ*                 newvend = no.
 *L0BZ*                 display
 *L0BZ*                    voucherno
 *L0BZ*                    space(5)
 *L0BZ*                    invdate
 *L0BZ*                    effdate
 *L0BZ*                    vo_cr_terms
 *L0BZ* /*L00S*            age_amt */
 *L0BZ* /*L00S*/           et_age_amt
 *L0BZ* /*J2G3*/              format "->>>>>,>>>,>>9.99"
 *L0BZ* /*L00S*            base_amt */
 *L0BZ* /*L00S*/           et_base_amt
 *L0BZ* /*J2G3*/              format "->>>>>,>>>,>>9.99"
 *L0BZ*                    hold
 *L0BZ*                 with frame c.
 *L0BZ*                 if multi-due then put invoice at 1 {&apvorp04_p_12} at 14.
 *L0BZ*                 else
 *L0BZ*                    put invoice at 1 duedate at 14.
 *L0BZ*                 if base_curr <> ap_mstr.ap_curr then
 *L0BZ* /*L06R*            put ap_mstr.ap_ent_ex  at 22 space(1) */
 *L0BZ* /*L06R*/           put (ap_mstr.ap_ex_rate / ap_mstr.ap_ex_rate2)
 *L0BZ* /*L06R*/               at 22 space(1)
 *L0BZ*                        ap_mstr.ap_curr.
 *L0BZ*              end.
 *L0BZ*/

/*L0BZ*/             run ip-disp-voucher.

                     {mfrpexit.i}
/*J2PS*/          end. /* FOR EACH VO_MSTR ... */
/*N0VQ*/          {&APVORP04-P-TAG18}
               end. /* for each ap_mstr ... */

               if newvend = no then do with frame c:
                  underline
/*L00S*              age_amt base_amt.  */
/*L00S*/             et_age_amt et_base_amt
/*L00S*/          with frame c.

/*L01G* /*L00S*/  if et_tk_active = no then do: */
/*L03L* /*L00S*/     if base_rpt = "" then et_disp_curr = "Base". */
/*L03L* /*L00S*/     else et_disp_curr = base_rpt. */
/*L01G* /*L00S*/  end. */

/*J2G3*           *** BEGIN DELETE ***
 *                display
 *                   (if base_rpt = ""
 *                       then "Base"
 *                       else base_rpt)
 *                      @ invdate
 *                   {&apvorp04_p_4} @ effdate {&apvorp04_p_3} @ vo_cr_terms
 *                   accum total (age_amt[1])
 *                      format "->>>>>,>>>,>>9.99" @ age_amt[1]
 *                   accum total (age_amt[2])
 *                      format "->>>>>,>>>,>>9.99" @ age_amt[2]
 *                   accum total (age_amt[3])
 *                      format "->>>>>,>>>,>>9.99" @ age_amt[3]
 *                   accum total (age_amt[4])
 *                      format "->>>>>,>>>,>>9.99" @ age_amt[4]
 *                   accum total base_amt
 *                      format "->>>>>,>>>,>>9.99" @ base_amt with frame c.
 *J2G3*           *** END DELETE */

/*N0VQ*/          {&APVORP04-P-TAG19}
/*J2G3*/          display
/*J2G3*/             l_label1

/*L00S*              BEGIN DELETE
 . /*J2G3*/          accum total (age_amt[1]) @ age_amt[1]
 . /*J2G3*/          accum total (age_amt[2]) @ age_amt[2]
 . /*J2G3*/          accum total (age_amt[3]) @ age_amt[3]
 . /*J2G3*/          accum total (age_amt[4]) @ age_amt[4]
 . /*J2G3*/          accum total base_amt     @ base_amt
 *L00S*              END DELETE */

/*L00S*              BEGIN ADD */
                     accum total (et_age_amt[1]) @ et_age_amt[1]
                     accum total (et_age_amt[2]) @ et_age_amt[2]
                     accum total (et_age_amt[3]) @ et_age_amt[3]
                     accum total (et_age_amt[4]) @ et_age_amt[4]
                     accum total et_base_amt     @ et_base_amt
/*L00S*              END ADD */

/*J2G3*/          with frame e.
/*N0VQ*/          {&APVORP04-P-TAG20}

               end.

               {mfrpexit.i}
            end.  /* for each vd_mstr ... */

            underline
/*L00S*        age_amt[1 for 4] base_amt  */
/*L00S*/       et_age_amt[1 for 4] et_base_amt
            with frame c.

/*L01G* /*L00S*/    if et_tk_active = no then do: */
/*L03L* /*L00S*/       if base_rpt = "" then et_disp_curr = "Base". */
/*L03L* /*L00S*/       else et_disp_curr = base_rpt. */
/*L01G* /*L00S*/    end. */

/*J2G3*     *** BEGIN DELETE ***
 *          display
 *             (if base_rpt = ""
 *                 then "Base"
 *                 else base_rpt)
 *                @ invdate
 *             {&apvorp04_p_1} @ effdate {&apvorp04_p_3} @ vo_cr_terms
 *             accum total (age_amt[1])
 *                format "->>>>>,>>>,>>9.99" @ age_amt[1]
 *             accum total (age_amt[2])
 *                format "->>>>>,>>>,>>9.99" @ age_amt[2]
 *             accum total (age_amt[3])
 *                format "->>>>>,>>>,>>9.99" @ age_amt[3]
 *             accum total (age_amt[4])
 *                format "->>>>>,>>>,>>9.99" @ age_amt[4]
 *             accum total base_amt /* net*/
 *                format "->>>>>,>>>,>>9.99" @ base_amt with frame c.
 *J2G3*     *** END DELETE */

/*N0VQ*/    {&APVORP04-P-TAG21}
/*J2G3*/    display
/*J2G3*/       l_label2                 @ l_label1

/*L00S*        BEGIN DELETE
 . /*J2G3*/    accum total (age_amt[1]) @ age_amt[1]
 . /*J2G3*/    accum total (age_amt[2]) @ age_amt[2]
 . /*J2G3*/    accum total (age_amt[3]) @ age_amt[3]
 . /*J2G3*/    accum total (age_amt[4]) @ age_amt[4]
 . /*J2G3*/    accum total base_amt     @ base_amt
 *L00S*        END DELETE */

/*L00S*        BEGIN ADD */
               accum total (et_age_amt[1]) @ et_age_amt[1]
               accum total (et_age_amt[2]) @ et_age_amt[2]
               accum total (et_age_amt[3]) @ et_age_amt[3]
               accum total (et_age_amt[4]) @ et_age_amt[4]
               accum total et_base_amt     @ et_base_amt
/*L00S*        END ADD */

/*J2G3*/    with frame e.

/*J2G3**    down 1 with frame c. */
/*J2G3*/    down 1 with frame e.
/*N0VQ*/    {&APVORP04-P-TAG22}

/*L00S*     BEGIN ADDED SECTION*/

            /* DETERMINE ORIGINAL TOTALS, NOT YET CONVERTED */
            assign
               et_org_age_amt[1] = accum total (age_amt[1])
               et_org_age_amt[2] = accum total (age_amt[2])
               et_org_age_amt[3] = accum total (age_amt[3])
               et_org_age_amt[4] = accum total (age_amt[4])
               et_org_amt        = accum total (base_amt)
               et_org_curr_amt   = accum total curr_amt.

/*N0VQ*/    {&APVORP04-P-TAG23}
            /*CONVERT AMOUNTS*/
/*L03L*     {etrpconv.i et_org_age_amt[1] et_org_age_amt[1]} */
/*L03L*     {etrpconv.i et_org_age_amt[2] et_org_age_amt[2]} */
/*L03L*     {etrpconv.i et_org_age_amt[3] et_org_age_amt[3]} */
/*L03L*     {etrpconv.i et_org_age_amt[4] et_org_age_amt[4]} */
/*L03L*     {etrpconv.i et_org_amt        et_org_amt       } */
/*L03L*     {etrpconv.i et_org_curr_amt   et_org_curr_amt  } */

/*L03L*/    do i = 1 to 4:
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
/*N0VQ*/    {&APVORP04-P-TAG24}

            /* DISPLAY CONVERTED REPORT AMOUNTS */
/*L01G*     if et_show_diff and et_tk_active */
/*L01G*/    if et_ctrl.et_show_diff
            and (
                ((accum total et_age_amt[1]) - et_org_age_amt[1] <> 0 )
            or  ((accum total et_age_amt[2]) - et_org_age_amt[2] <> 0 )
            or  ((accum total et_age_amt[3]) - et_org_age_amt[3] <> 0 )
            or  ((accum total et_age_amt[4]) - et_org_age_amt[4] <> 0 )
            or  ((accum total et_base_amt)   - et_org_amt        <> 0 )
                )
            then do:

               /* DISPLAY REPORT DIFFRENCCES */
/*L03L*        put et_diff_txt to 38 */
/*L03L*/       display
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
/*L03L*/       with frame e.
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

            if base_rpt = "" then
/*L00S*/    do on endkey undo, leave:
/*N0VQ*/       {&APVORP04-P-TAG25}
               display
/*L00S*/          et_diff_txt to 96 when (et_diff_exist)
/*L00S*           "     Total Base Aging:" to 44 */

/*L03L* /*L00S*/  "Total " + et_disp_curr + fill(" ",4 - length(et_disp_curr))*/
/*L03L* /*L00S*/  + " Aging:" format "x(17)" to 44 */
/*N07D** /*L03L*/ {&apvorp04_p_29} + et_report_curr + {&apvorp04_p_30} */
/*N07D*/          getTermLabel("TOTAL",5) + " " + et_report_curr + " "
/*N07D*/          + getTermLabelRtColon("AGING",6)
/*L03L*/          format "x(17)" to 45

/*L00S*           (accum total (base_amt)) */
/*L00S*/          (accum total (et_base_amt))
                     format "->>>>>,>>>,>>9.99" at 46

/*L00S*/          ((accum total (et_base_amt)) - et_org_amt)
/*L00S*/             format "->>>>>,>>>,>>9.99" at 77
/*L00S*/             when (et_diff_exist)

/*N07D**         {apvorp04_p_15} + */
/*N07D*/          getTermLabelRt("AGING_AT_EXCHANGE_RATES_FOR",34) + " " +
                     string(vodate1) + ":"
                     format "x(44)" to 44
/*L00S*           accum total (curr_amt) */
/*L00S*/          accum total et_curr_amt
                     format "->>>>>,>>>,>>9.99" at 46

/*L00S*/          ((accum total(et_curr_amt)) - et_org_curr_amt)
/*L00S*/             format "->>>>>,>>>,>>9.99" at 77
/*L00S*/             when (et_diff_exist)

/*N07D**          {&apvorp04_p_17} to 44 */
/*N07D*/          getTermLabelRtcolon("VARIANCE",13) format "x(13)"  to 44

/*L00S*           (accum total (curr_amt)) - (accum total (base_amt)) */
/*L00S*/          (accum total (et_curr_amt)) - (accum total (et_base_amt))
                     format "->>>>>,>>>,>>9.99" at 46

/*L00S*/          ( ( (accum total (et_curr_amt)) - et_org_curr_amt) -
/*L00S*/          ( (accum total (et_base_amt))    - et_org_amt) )
/*L00S*/             format "->>>>>,>>>,>>9.99" at 77
/*L00S*/             when (et_diff_exist)

               with frame d width 132 no-labels.

/*L00S*/    end. /* IF BASE-RPT = "" */

            /* REPORT TRAILER */
            hide frame phead1.
/*N0VQ*/    {&APVORP04-P-TAG26}
            {mfrtrail.i}
            SS - 090317.1 - E */

            /* SS - 090317.1 - B */
            /*
            PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.
            */

            FOR EACH ttxxapvorp0401:
               DELETE ttxxapvorp0401.
            END.
         
            {gprun.i ""xxapvorp0401.p"" "(
               INPUT vend,
               INPUT vend1,
               INPUT vdtype,
               INPUT vdtype1,
               INPUT acct,
               INPUT acct1,
               INPUT sub,
               INPUT sub1,
               INPUT cc,
               INPUT cc1,
               INPUT entity,
               INPUT entity1,
               INPUT ref,  
               INPUT ref1,
               INPUT votype,
               INPUT votype1,
               INPUT vodate1,
               INPUT age_by,
               INPUT base_rpt,
               INPUT et_report_curr,
               INPUT age_days[1],
               INPUT age_days[2],
               INPUT age_days[3],
               INPUT age_days[4],
               INPUT age_days[5],
               INPUT age_days[6],
               INPUT age_days[7]
               )"}
         
            /* EXPORT DELIMITER ";" "供应商" "供应商名称" "凭证" "类型" "生效日期" "截止日期" "支付方式" "原币" "原币单位" "本币单位" "本币金额[1]" "本币金额[2]" "本币金额[3]" "本币金额[4]" "本币金额[5]" "本币金额[6]" "本币金额[7]" "本币金额[8]" "本币金额合计" "原币金额合计" "发票原币金额合计". */
            EXPORT DELIMITER ";" "Supplier Code" "Supplier Description" "Voucher" "Type" "Effective Date" "Due Date" "Terms" "Currency" "Voucher Currency Units" "Base Currency Units" 
               "Base Amoutn[1]" "Base Amoutn[2]" "Base Amoutn[3]" "Base Amoutn[4]" "Base Amoutn[5]" "Base Amoutn[6]" "Base Amoutn[7]" "Base Amoutn[8]" "Base Amount Toal" "Currency Amount Total" "Voucher Currency Amount Total".
            FOR EACH ttxxapvorp0401:
               FIND FIRST vo_mstr WHERE vo_ref = ttxxapvorp0401_voucherno NO-LOCK NO-ERROR.
               IF AVAILABLE vo_mstr THEN DO:
                  TYPE_vo = vo_type.
               END.
               ELSE DO:
                  TYPE_vo = "".
               END.

               FIND FIRST ap_mstr WHERE ap_type = "VO" AND ap_ref = ttxxapvorp0401_voucherno NO-LOCK NO-ERROR.
               IF AVAILABLE ap_mstr THEN DO:
                  amt_ap = ap_amt.
               END.
               ELSE DO:
                  amt_ap = 0.
               END.

               EXPORT DELIMITER ";" 
                  ttxxapvorp0401_ap_vend
                  ttxxapvorp0401_name
                  ttxxapvorp0401_voucherno
                  TYPE_vo
                  ttxxapvorp0401_effdate
                  ttxxapvorp0401_duedate
                  ttxxapvorp0401_vo_cr_terms
                  ttxxapvorp0401_ap_curr
                  ttxxapvorp0401_ap_ex_rate
                  ttxxapvorp0401_ap_ex_rate2
                  ttxxapvorp0401_et_age_amt[1]
                  ttxxapvorp0401_et_age_amt[2]
                  ttxxapvorp0401_et_age_amt[3]
                  ttxxapvorp0401_et_age_amt[4]
                  ttxxapvorp0401_et_age_amt[5]
                  ttxxapvorp0401_et_age_amt[6]
                  ttxxapvorp0401_et_age_amt[7]
                  ttxxapvorp0401_et_age_amt[8]
                  ttxxapvorp0401_et_base_amt
                  ttxxapvorp0401_et_curr_amt
                  amt_ap
                  .
            END.
         
            /*
            PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.
            */
         
            {xxmfrtrail.i}
            /* SS - 090317.1 - E */

         end.

/*L03L*  {wbrp04.i &frame-spec = a} */

/*L0BZ*/ PROCEDURE ip-param-init:

            if ref1    = hi_char then ref1    = "".
            if vend1   = hi_char then vend1   = "".
            if vodate1 = hi_date then vodate1 = ?.
            /* SS - 090317.1 - B */
            if acct1 = hi_char then acct1 = "".
            if sub1 = hi_char then sub1 = "".
            if cc1 = hi_char then cc1 = "".
            /* SS - 090317.1 - E */
            if entity1 = hi_char then entity1 = "".
            if votype1 = hi_char then votype1 = "".
            if vdtype1 = hi_char then vdtype1 = "".

            /* SS - 090317.1 - B
            do i = 1 to 4:
            SS - 090317.1 - E */
            /* SS - 090317.1 - B */
            do i = 1 to 8:
            /* SS - 090317.1 - E */
               if age_days[i] = 0 then age_days[i] = (i * 30).
            end.

/*N0VQ*/    {&APVORP04-P-TAG27}
         END PROCEDURE.  /* ip-param-init */

/*L0BZ*/ PROCEDURE ip-param-quoter:

            bcdparm = "".
            {mfquoter.i vend           }
            {mfquoter.i vend1          }
            {mfquoter.i vdtype         }
            {mfquoter.i vdtype1        }
            /* SS - 090317.1 - B */
            {mfquoter.i acct         }
            {mfquoter.i acct1        }
            {mfquoter.i sub         }
            {mfquoter.i sub1        }
            {mfquoter.i cc         }
            {mfquoter.i cc1        }
            /* SS - 090317.1 - E */
            {mfquoter.i entity         }
            {mfquoter.i entity1        }
            {mfquoter.i ref            }
            {mfquoter.i ref1           }
            {mfquoter.i votype         }
            {mfquoter.i votype1        }
            {mfquoter.i vodate1        }
/*N0VQ*/    {&APVORP04-P-TAG28}
            {mfquoter.i age_by         }
/*N0VQ*/    {&APVORP04-P-TAG29}
            {mfquoter.i base_rpt       }
            {mfquoter.i et_report_curr }
            {mfquoter.i age_days[1]    }
            {mfquoter.i age_days[2]    }
            {mfquoter.i age_days[3]    }
            /* SS - 090317.1 - B */
            {mfquoter.i age_days[4]    }
            {mfquoter.i age_days[5]    }
            {mfquoter.i age_days[6]    }
            {mfquoter.i age_days[7]    }
            /* SS - 090317.1 - E */

            if ref1    = "" then ref1    = hi_char.
            if vend1   = "" then vend1   = hi_char.
            if vodate1 = ?  then vodate1 = hi_date.
            /* SS - 090317.1 - B */
            if acct1    = "" then acct1    = hi_char.
            if sub1    = "" then sub1    = hi_char.
            if cc1    = "" then cc1    = hi_char.
            /* SS - 090317.1 - E */
            if entity1 = "" then entity1 = hi_char.
            if votype1 = "" then votype1 = hi_char.
            if vdtype1 = "" then vdtype1 = hi_char.

         END PROCEDURE.  /* ip-param-quoter */

/*L0BZ*/ PROCEDURE ip-chk-valid-curr:

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

         END PROCEDURE.  /* ip-chk-valid-curr */

/*L0BZ*/ PROCEDURE ip-ex-rate-setup:

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
/*M14T*/       if not batchrun
/*M14T*/       then do:
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
/*M14T*/       end. /* IF NOT BATCHRUN */

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

         END PROCEDURE.  /* ip-ex-rate-setup */

/*L0BZ*/ PROCEDURE ip-curr-conv:

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
               {mfmsg.i mc-error-number 2}
            end.

         END PROCEDURE.  /* ip-curr-conv */

/*L0BZ*/ PROCEDURE ip-get-ex-rate:

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

         END PROCEDURE.  /* ip-get-ex-rate */

/*L0BZ*/ PROCEDURE ip-disp-voucher:

            if net <> 0 then do:
               if newvend then do with frame b:
             /* SET EXTERNAL LABELS */
            setFrameLabels(frame b:handle).

                  display
                     ap_mstr.ap_vend no-label
                     name            no-label
                     ad_mstr.ad_attn
                     ad_phone
                     ad_ext          no-label
                  with frame b side-labels width 132.
               end. /* if newvend */

               newvend = no.
/*N0VQ*/       {&APVORP04-P-TAG30}
               display
                  voucherno
                  invdate
                  effdate
                  vo_mstr.vo_cr_terms
/*L0CB*           et_age_amt  format "->>>>>,>>>,>>9.99" */
/*L0CB*/          et_age_amt[1]
/*L0CB*/          et_age_amt[2]
/*L0CB*/          et_age_amt[3]
/*L0CB*/          et_age_amt[4]
/*L0CB*           et_base_amt format "->>>>>,>>>,>>9.99" */
/*L0CB*/          et_base_amt
                  hold
               with frame c.
/*L0CB*/       down 1 with frame c.

/*N07D**       if multi-due then put invoice at 1 {&apvorp04_p_12} at 14. */
/*N07D*/       if multi-due then
/*N07D*/           put invoice at 1
/*N07D*/               {gplblfmt.i &FUNC=getTermLabel(""MULTIPLE"",10) } at 14.
               else put invoice at 1 duedate at 14.

               if base_curr <> ap_mstr.ap_curr then
                  put
/*L0CB*              (ap_mstr.ap_ex_rate / ap_mstr.ap_ex_rate2) at 22 space(1)*/
/*L0CB*/             (ap_mstr.ap_ex_rate / ap_mstr.ap_ex_rate2)
/*L0CB*/                format ">>>>>9.9<<<<<"
/*L0CB*/                at 23
/*L0CB*/                space(1)
                     ap_mstr.ap_curr.
            end.
/*N0VQ*/    {&APVORP04-P-TAG31}

         END PROCEDURE.  /* ip-disp-voucher */

/*L0BZ*/ PROCEDURE ip-set-vars:

            assign
               ckdtotal   = 0
               voidtotal  = 0
/*N0VQ*/       {&APVORP04-P-TAG32}
               age_amt    = 0
               et_age_amt = 0
/*N0VQ*/       {&APVORP04-P-TAG33}
               voflag     = ap_mstr.ap_effdate <= vodate1
               net        = 0
               age_period = 4.

            if voflag then do:

               /* SS - 090317.1 - B
               assign
                  age_by_date =
                     if age_by = "EFF"
                        then ap_effdate
                        else
                           if age_by = "INV"
                              then ap_date
                              else vo_mstr.vo_due_date
                  age_period = 4.

               do i = 1 to 4:
                  if (vodate1 - age_days[i]) <= age_by_date then
                     age_period = i.
                  if age_period <> 4 then leave.
               end.
               SS - 090317.1 - E */

               /* SS - 090317.1 - B */
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
                  if age_period <> 4 then leave.
               end.
               /* SS - 090317.1 - E */
               if age_by_date = ? then age_period = 1.

               assign
                  voucherno = ap_ref
                  effdate   = ap_effdate
                  invoice   = vo_invoice
                  duedate   = vo_due_date
                  invdate   = ap_date
                  net       = ap_amt.
            end.  /* if vo_flag */

         END PROCEDURE.  /* ip-set-vars */

/*L0BZ*/ PROCEDURE ip-set-due-date:

            due-date =
               if ct_mstr.ct_due_date <> ?
                  then ct_due_date
                  else
                     if ct_from_inv = 1
                        then ap_mstr.ap_date + ct_due_days
                        else
                           date((month(ap_date) + 1) modulo 12 +
                                   if month(ap_date) = 11
                                      then 12 else 0,
                                1,
                                year(ap_date) +
                                   if month(ap_date) >= 12
                                      then 1 else 0) +
                           integer(ct_due_days) -
                           if ct_due_days <> 0 then 1 else 0.

         END PROCEDURE.  /* ip-set-due-date */

/*L0BZ*/ PROCEDURE ip-set-ap:

            if voflag = no and available apmaster then do:
               /* SS - 090317.1 - B
               age_period = 4.
               do i = 1 to 4:
                  if (vodate1 - age_days[i]) <= apmaster.ap_effdate
                     then age_period = i.
                  if age_period <> 4 then leave.
               end.
               SS - 090317.1 - E */
               /* SS - 090317.1 - B */
               age_period = 4.
               do i = 1 to 4:
                  if (vodate1 - age_days[i]) <= apmaster.ap_effdate
                     then age_period = i.
                  if age_period <> 4 then leave.
               end.
               /* SS - 090317.1 - E */
               if apmaster.ap_effdate = ? then age_period = 1.
               assign
                  voucherno = apmaster.ap_ref
/*N07D**          invoice   = {&apvorp04_p_31} */
/*N07D*/          invoice   = getTermLabel("PAYMENT",12)
                  effdate   = apmaster.ap_effdate
                  invdate   = apmaster.ap_date
                  duedate   = ?.
            end.

         END PROCEDURE.  /* ip-set-ap */
/*N0VQ*/ {&APVORP04-P-TAG34}
