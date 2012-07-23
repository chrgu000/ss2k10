/* apvorp04.p - AP AGING REPORT as of effective date                          */
/* Copyright 1986-2007 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* Revision: 4.0      LAST MODIFIED: 08/26/88   BY: pml  A412                 */
/* REVISION: 6.0      LAST MODIFIED: 04/12/91   BY: MLV *D519*                */
/*                                   04/12/91   BY: MLV *D523*                */
/*                                   06/28/91   BY: MLV *D733*                */
/*                                   07/30/91   BY: bjb *D795*                */
/* REVISION: 7.0      LAST MODIFIED: 08/20/91   BY: MLV *F002*                */
/*                                   01/13/92   BY: MLV *F082*                */
/*                                   01/27/92   BY: MLV *F098*                */
/*                                   03/16/92   BY: TMD *F260*                */
/*                                   04/09/92   BY: MLV *F373*                */
/*                                   04/29/92   BY: MLV *F446*                */
/* REVISION: 7.3      LAST MODIFIED: 02/26/93   by: jms *G757*                */
/*                                   04/22/93   by: bcm *GA08*                */
/*                                   02/28/94   by: pmf *GI88*                */
/*                                   04/16/94   by: pcd *GJ41*                */
/*                                   08/24/94   by: cpp *GL39*                */
/*                                   09/10/94   by: rxm *FQ94*                */
/*                                   11/23/94   by: pmf *FU04*                */
/* REVISION: 8.5      LAST MODIFIED: 12/24/95   by: mwd *J053*                */
/*                                   04/08/96   by: jzw *G1LD*                */
/* REVISION: 8.6      LAST MODIFIED: 10/09/97   by: ckm *K0P6*                */
/* REVISION: 8.6      LAST MODIFIED: 01/06/98   BY: *J295* Irine D'mello      */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 04/17/98   BY: *J2G3* Niranjan R.        */
/* REVISION: 8.6E     LAST MODIFIED: 04/28/98   BY: *L00S* D. Sidel           */
/* REVISION: 8.6E     LAST MODIFIED: 05/14/98   BY: *L00Z* AWe                */
/* REVISION: 8.6E     LAST MODIFIED: 06/24/98   BY: *L01G* R. McCarthy        */
/* REVISION: 8.6E     LAST MODIFIED: 07/07/98   BY: *L03L* Brenda Milton      */
/* REVISION: 8.6E     LAST MODIFIED: 08/21/98   BY: *J2SQ* Abbas Hirkani      */
/* REVISION: 8.6E     LAST MODIFIED: 08/21/98   BY: *L06R* Brenda Milton      */
/* REVISION: 8.6E     LAST MODIFIED: 08/25/98   BY: *J2PS* Dana Tunstall      */
/* REVISION: 8.6E     LAST MODIFIED: 09/08/98   BY: *L08W* Russ Witt          */
/* Old ECO marker removed, but no ECO header exists *B660*                    */
/* REVISION: 8.6E     LAST MODIFIED: 10/14/98   BY: *L0BZ* Steve Goeke        */
/* REVISION: 8.6E     LAST MODIFIED: 10/20/98   BY: *L0CB* Jeff Wootton       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 04/12/00   BY: *N07D* Antony Babu        */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                */
/* REVISION: 9.1      LAST MODIFIED: 08/19/00   BY: *N0MG* BalbeerS Rajput    */
/* REVISION: 9.1      LAST MODIFIED: 10/21/00   BY: *N0VQ* BalbeerS Rajput    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.32  BY: Vihang Talwalkar            DATE: 04/12/01 ECO: *M14T* */
/* Revision: 1.33  BY: Ed van de Gevel             DATE: 11/09/01 ECO: *N15N* */
/* Revision: 1.34  BY: Rajesh Kini                 DATE: 03/04/02 ECO: *N1BM* */
/* Revision: 1.35  BY: Jean Miller                 DATE: 04/08/02 ECO: *P056* */
/* Revision: 1.36  BY: Lena Lim                    DATE: 06/05/02 ECO: *P07V* */
/* Revision: 1.37  BY: Orawan S.                   DATE: 05/03/03 ECO: *P0R6* */
/* Revision: 1.39  BY: Paul Donnelly (SB)          DATE: 06/26/03 ECO: *Q00B* */
/* Revision: 1.40  BY: Shivanand H                 DATE: 02/24/04 ECO: *P1QK* */
/* Revision: 1.42  BY: Dayanand Jethwa       DATE: 08/23/04 ECO: *P2G7* */
/* Revision: 1.43  BY: Ed van de Gevel       DATE: 08/12/05 ECO: *P411* */
/* Revision: 1.44       BY: Swati Sharma          DATE: 12/28/05 ECO: *P4D7* */
/* Revision: 1.44.1.1    BY: Antony LejoS          DATE: 07/06/06 ECO: *P4Y4* */
/* $Revision: 1.44.1.2 $    BY: Sundeep Kalla              DATE: 04/19/07 ECO: *P5T7* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Report                                                       */

/* ����Ϊ�汾��ʷ */
/* SS - 090415.1 By: Bill Jiang */

/*����Ϊ����˵�� */
/* SS - 090415.1 - RNB
��090415.1��

�޸������±�׼�˵�����:
  - ����Ч���ڼ����Ӧ���˿����䱨�� [apvorp04.p]

��ο����ϱ�׼�˵��������ذ���

��ο����±�׼�˵����������֤:
  - ����Ч���ڼ����Ӧ���˿����䱨�� [apvorp04.p]

˳������������ֶ�:
  - ��׼���: ��Ӧ�̴���[ap_vend]
  - ��׼���: ��Ӧ������[name]
  - ��׼���: ��ϵ��[ad_attn]
  - ��׼���: �绰[ad_phone]
  - ��׼���: �ֻ�[ad_ext]
  - ��׼���: ƾ֤[voucherno]
  - ��׼���: ��Ʊ����[invdate]
  - ��׼���: ��Ч����[effdate]
  - ��׼���: ��ֹ����[duedate]
  - ��׼���: ֧����ʽ[vo_cr_terms]
  - ��׼���: ��������1[et_age_amt[1]]
  - ��׼���: ��������2[et_age_amt[2]]
  - ��׼���: ��������3[et_age_amt[3]]
  - ��׼���: ��������4[et_age_amt[4]]
  - ��׼���: ��������5[et_age_amt[5]]
  - ��׼���: ��������6[et_age_amt[6]]
  - ��׼���: ��������7[et_age_amt[7]]
  - ��׼���: ��������8[et_age_amt[8]]
  - ��׼���: ��������ϼ�[et_base_amt]
  - ��׼���: ��������[hold]
  - ��׼���: �һ���1[ap_ex_rate]
  - ��׼���: �һ���2[ap_ex_rate2]
  - ��׼���: ����[ap_curr]
  - ��׼���: �˻�[ap_acct]
  - ��׼���: ���˻�[ap_sub]
  - ��׼���: �ɱ�����[ap_cc]
  - ��׼���: ԭ������ϼ�[et_curr_amt]

��090415.1��

SS - 090415.1 - RNE */

/* SS - 090415.1 - B */
{xxapvorp0401.i "new"}
/* SS - 090415.1 - E */

/* DISPLAY PROGRAM TITLE */
/*
{mfdtitle.i "1+ "}
*/
{mfdtitle.i "090415.1"}
{cxcustom.i "APVORP04.P"}

/* THESE ARE NEEDED FOR FULL GUI REPORTS */
{gprunpdf.i "mcpl" "p"}
{gprunpdf.i "mcui" "p"}

define variable vend like ap_vend.
define variable vend1 like ap_vend.
define variable ref like ap_ref.
define variable ref1 like ap_ref.
define variable voucherno like ap_ref.
define variable vodate1 like ap_effdate initial today.
/* SS - 090415.1 - B */
DEFINE VARIABLE acct LIKE ap_acct.
DEFINE VARIABLE acct1 LIKE ap_acct.
DEFINE VARIABLE sub LIKE ap_sub.
DEFINE VARIABLE sub1 LIKE ap_sub.
DEFINE VARIABLE cc LIKE ap_cc.
DEFINE VARIABLE cc1 LIKE ap_cc.
/* SS - 090415.1 - E */
define variable name like ad_name.
/* SS - 090415.1 - B
define variable age_days as integer extent 4 label "Column Days".
define variable age_range as character extent 4 format "x(17)".
define variable i as integer.
define variable age_amt like ap_amt extent 4 format "->>>>,>>>,>>>.99".
SS - 090415.1 - E */
/* SS - 090415.1 - B */
define variable age_days as integer extent 8 label "Column Days".
define variable age_range as character extent 8 format "x(17)".
define variable i as integer.
define variable age_amt like ap_amt extent 8 format "->>>>,>>>,>>>.99".
/* SS - 090415.1 - E */
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
define variable votype like vo_type label "Voucher Type".
define variable votype1 like votype.
define variable vdtype like vd_type label "Supplier Type".
define variable vdtype1 like vdtype.
define variable lstype  like ls_type.
define variable l_agebylbl  as character  no-undo.
define variable age_by as character format "x(3)"
   label "Age by Date (Due,Eff,Inv)".
define variable age_by_date like ap_date.
define variable duedate like vo_due_date.
define variable invdate like ap_date.
define variable due-date like ap_date.
define variable applied-amt like vo_applied.
define variable amt-due like ap_amt.
define variable tot-amt like ap_amt.
define variable vo-tot like ap_amt.
define variable multi-due like mfc_logical.
define variable l_label1 as character format "x(25)" no-undo.
define variable l_label2 as character format "x(25)" no-undo.
define variable exdrate like exr_rate.
define variable exdrate2 like exr_rate2.
define variable mc-rpt-curr like base_rpt no-undo.
define variable mc-dummy-fixed like po_fix_rate no-undo.

define variable valid-mnemonic like mfc_logical   no-undo.
define variable l_frame_field as character no-undo.
define variable l_ageby as character format "x(1)"
   initial "1" no-undo .

{etrpvar.i &new = "new"}
{etvar.i   &new = "new"}
{eteuro.i  }

/* SS - 090415.1 - B
define variable et_age_amt       like ap_amt extent 4.
define variable et_base_amt      like ap_amt.
define variable et_curr_amt      like ap_amt.
define variable et_org_age_amt   like ap_amt extent 4.
SS - 090415.1 - E */
/* SS - 090415.1 - B */
define variable et_age_amt       like ap_amt extent 8.
define variable et_base_amt      like ap_amt.
define variable et_curr_amt      like ap_amt.
define variable et_org_age_amt   like ap_amt extent 8.
/* SS - 090415.1 - E */
define variable et_org_amt       like ap_amt.
define variable et_org_curr_amt  like ap_amt.
define variable et_diff_exist    like mfc_logical.
define variable v_ckd_net        like ckd_amt   no-undo.
define variable l_batchid        like bcd_batch no-undo.
define buffer apmaster for ap_mstr.

{&APVORP04-P-TAG35}
find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.

{&APVORP04-P-TAG1}
{&APVORP04-P-TAG36}
form
   vend colon 15
   vend1          label "To" colon 49
   vdtype         colon 15
   vdtype1        label "To" colon 49
   /* SS - 090415.1 - B */
   acct colon 15
   acct1          label "To" colon 49
   sub colon 15
   sub1          label "To" colon 49
   cc colon 15
   cc1          label "To" colon 49
   /* SS - 090415.1 - E */
   entity         colon 15
   entity1        label "To" colon 49
   ref            colon 15 format "x(8)"
   ref1           label "To" colon 49 format "x(8)"
   votype         colon 15
   votype1        label "To" colon 49
   lstype         colon 15   
   skip (1)
   vodate1        colon 30
   age_by         colon 30
   base_rpt       colon 30
   et_report_curr colon 30 
   skip(1)
   space(1)
   age_days[1]
   age_days[2]    label "[2]"
   age_days[3]    label "[3]" 
   /* SS - 090415.1 - B */
   age_days[4]    label "[4]"
   age_days[5]    label "[5]" 
   age_days[6]    label "[6]"
   age_days[7]    label "[7]" 
   /* SS - 090415.1 - E */
   /* SS - 090415.1 - B
   skip (1)
   SS - 090415.1 - E */
with frame a side-labels width 80.
{&APVORP04-P-TAG37}
{&APVORP04-P-TAG2}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

repeat:

   run ip-param-init.

   /* GET THE ATTRIBUTE MNEMONIC FOR DUE/EFF/INV */
   {gplngn2a.i
      &file     = ""due_eff_inv""
      &field    = ""l_ageby""
      &code     = l_ageby
      &mnemonic = age_by
      &label    = l_agebylbl}

   display
      age_by
      with frame a .

   {&APVORP04-P-TAG3}
   {&APVORP04-P-TAG38}
   update
      vend vend1
      vdtype vdtype1
      /* SS - 090415.1 - B */
      acct acct1
      sub sub1
      cc cc1
      /* SS - 090415.1 - E */
      entity entity1
      ref ref1
      votype votype1
      lstype
      vodate1
      age_by
      base_rpt
      et_report_curr
      /* SS - 090415.1 - B
      age_days[1 for 3]
      SS - 090415.1 - E */
      /* SS - 090415.1 - B */
      age_days[1 for 7]
      /* SS - 090415.1 - E */
   with frame a
      editing:

      readkey.
      if frame-field <> ""
      then
         l_frame_field = frame-field .

      apply lastkey.

      if (go-pending
          or (l_frame_field = "age_by" and
              frame-field  <> "age_by"))
      then do:
         valid-mnemonic = no.

         {gplngv.i
            &file     = ""due_eff_inv""
            &field    = ""l_ageby""
            &mnemonic = age_by:SCREEN-VALUE
            &isvalid  = valid-mnemonic}

         if not valid-mnemonic
         then do:
            /* Must be DUE, EFF, or INV */ /* IN RESPECTIVE LANGUAGE */
            {pxmsg.i &MSGNUM=3719 &ERRORLEVEL=3}
            if batchrun
            then
               undo, leave.
            else do:
               next-prompt age_by with frame a.
               next.
            end. /* IF NOT batchrun */
         end. /* IF NOT valid-mnemonic */
      end. /* IF (go-pending ...*/
   end. /* EDITING */

   /* GET ATTRIBUTE TO STORE FOR THE MNEMONIC DUE/EFF/INV */

   {gplnga2n.i
      &file     = ""due_eff_inv""
      &field    = ""l_ageby""
      &mnemonic = age_by:SCREEN-VALUE
      &code     = l_ageby
      &label    = l_agebylbl}


   {&APVORP04-P-TAG39}
   et_eff_date = vodate1.
   {&APVORP04-P-TAG4}

   /* Code below to be wrapped in a 'do' code block for correct GUI conversion */

   do:

      run ip-param-quoter.
      {&APVORP04-P-TAG5}

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

   if base_rpt = "" and et_report_curr = base_curr
      then
   assign
      l_label1 = getTermLabelRtColon("BASE_SUPPLIER_TOTALS",25)
      l_label2 = getTermLabelRtColon("BASE_REPORT_TOTALS",25) .
   else
   assign
      l_label1 = string(et_report_curr,"x(3)") + " "
      + getTermLabelRtColon("SUPPLIER_TOTALS",21)
      l_label2 = string(et_report_curr,"x(3)") + " "
      + getTermLabelRtColon("REPORT_TOTALS",21) .

   on go anywhere
      do:
      if frame-field = "batch_id"
         then
         l_batchid = frame-value.

      /* TO CHECK NON-BLANK VALUE OF BATCH ID WHEN CURSOR IS */
      /* IN BATCH ID OR OUTPUT FIELD                         */
      if ((frame-field       =  "batch_id"
         and frame-value   <> "")
         or (frame-field   =  "dev"
         and l_batchid <> ""))
         and (mc-rpt-curr  <> et_report_curr)
      then do:
         /* USER-INPUT EXCHANGE RATE WILL BE IGNORED IN BATCH MODE */
         {pxmsg.i &MSGNUM=4629 &ERRORLEVEL=2}
         pause.
      end. /* IF FRAME-FIELD = "batch_id" AND ... */
   end. /* ON GO ANYWHERE */

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

   /* SS - 090415.1 - B
   {&APVORP04-P-TAG40}
   {mfphead.i}
   {&APVORP04-P-TAG41}
   /* CREATE REPORT HEADER */
   SS - 090415.1 - E */

   /* SS - 090415.1 - B
   do i = 2 to 4:
   SS - 090415.1 - E */
   /* SS - 090415.1 - B */
   do i = 2 to 8:
   /* SS - 090415.1 - E */
      age_range[i] = getTermLabelCentered("OVER",6)
      + string(age_days[i - 1],"->>>9").
   end.
   age_range[1] = getTermLabelCentered("LESS_THAN",12)
   +  string(age_days[1],"->>>9").

   /* SS - 090415.1 - B
   {&APVORP04-P-TAG42}
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

   {&APVORP04-P-TAG43}
   view frame phead1.
   {&APVORP04-P-TAG6}
   {&APVORP04-P-TAG44}
   SS - 090415.1 - E */

   form
      voucherno format "x(8)"
      at 1
      space(5)
      invdate
      effdate
      vo_mstr.vo_cr_terms
      et_age_amt[1] to 57 format "->>>>>,>>>,>>9.99"
      et_age_amt[2]       format "->>>>>,>>>,>>9.99"
      et_age_amt[3]       format "->>>>>,>>>,>>9.99"
      et_age_amt[4]       format "->>>>>,>>>,>>9.99"
      /* SS - 090415.1 - B */
      et_age_amt[5]       format "->>>>>,>>>,>>9.99"
      et_age_amt[6]       format "->>>>>,>>>,>>9.99"
      et_age_amt[7]       format "->>>>>,>>>,>>9.99"
      et_age_amt[8]       format "->>>>>,>>>,>>9.99"
      /* SS - 090415.1 - E */
      et_base_amt         format "->>>>>,>>>,>>9.99"
   with frame c width 132 no-labels no-attr-space no-box down.
   {&APVORP04-P-TAG45}
   {&APVORP04-P-TAG7}

   {&APVORP04-P-TAG46}
   form
      l_label1
      to 40
      et_age_amt[1] to 57 format "->>>>>,>>>,>>9.99"
      et_age_amt[2]       format "->>>>>,>>>,>>9.99"
      et_age_amt[3]       format "->>>>>,>>>,>>9.99"
      et_age_amt[4]       format "->>>>>,>>>,>>9.99"
      /* SS - 090415.1 - B */
      et_age_amt[5]       format "->>>>>,>>>,>>9.99"
      et_age_amt[6]       format "->>>>>,>>>,>>9.99"
      et_age_amt[7]       format "->>>>>,>>>,>>9.99"
      et_age_amt[8]       format "->>>>>,>>>,>>9.99"
      /* SS - 090415.1 - E */
      et_base_amt         format "->>>>>,>>>,>>9.99"
   with frame e width 132 no-labels no-attr-space no-box down.

   /* SS - 090415.1 - B
   {&APVORP04-P-TAG47}
   for each vd_mstr fields( vd_domain vd_addr vd_sort vd_type)
          where vd_mstr.vd_domain = global_domain and  (vd_addr >= vend and
          vd_addr <= vend1)
         and (vd_type >= vdtype and vd_type <= vdtype1)
         use-index vd_sort no-lock break by vd_sort:

      assign
         newvend = yes
         name    = "".

      for first ad_mstr
         fields( ad_domain ad_addr ad_attn ad_ext ad_name ad_phone)
          where ad_mstr.ad_domain = global_domain and  ad_addr = vd_addr
          no-lock:
      name = ad_name.
      end.

      {&APVORP04-P-TAG48}
      {&APVORP04-P-TAG8}
      for each ap_mstr
            fields( ap_domain ap_amt  ap_curr ap_date ap_effdate ap_entity
            ap_base_amt ap_exru_seq ap_ex_rate2 ap_ex_ratetype
            {&APVORP04-P-TAG49}
            ap_ex_rate ap_ref ap_type ap_vend)
             where ap_mstr.ap_domain = global_domain and (  (ap_vend = vd_addr)
            and (ap_entity >= entity and ap_entity <= entity1)
            and (ap_ref >= ref and ap_ref <= ref1)
            and (ap_type = "VO")
            and ((ap_curr = base_rpt)
            or (base_rpt = ""))
            {&APVORP04-P-TAG50}
            and (ap_date >= 1/1/1850 or ap_date = ?)
            ) use-index ap_vend_date no-lock:
         {&APVORP04-P-TAG9}
         if lstype = ""
            or (lstype <> ""
                and can-find(first ls_mstr
                                where ls_domain = global_domain
                                and   ls_type   = lstype
                                and   ls_addr   = vd_addr))
         then do:

            for each vo_mstr
               fields( vo_domain vo_applied  vo_confirmed vo_cr_terms
               vo_due_date
               vo_hold_amt vo_invoice   vo_ref      vo_type)
               where vo_mstr.vo_domain = global_domain and  vo_ref = ap_ref
               and vo_confirmed = yes
               and (vo_type >= votype and vo_type <= votype1)
            no-lock:

               run ip-set-vars.

               for each ckd_det
                     fields( ckd_domain ckd_amt ckd_cur_amt ckd_cur_disc ckd_disc
                     ckd_ref ckd_voucher)
                      where ckd_det.ckd_domain = global_domain and (  ckd_voucher
                      = ap_mstr.ap_ref ) no-lock,
                     each ck_mstr
                     fields( ck_domain ck_curr ck_ref ck_voideff)
                      where ck_mstr.ck_domain = global_domain and (  ck_ref      =
                      ckd_ref and
                     (ck_voideff = ? or
                     ck_voideff  > vodate1)
                  ) no-lock:

                  for first apmaster
                     fields( ap_domain ap_amt    ap_curr   ap_date    ap_effdate
                     ap_entity           ap_ex_rate ap_ref
                     ap_base_amt ap_exru_seq ap_ex_rate2
                     ap_ex_ratetype ap_type   ap_vend)
                     where apmaster.ap_domain = global_domain and  ap_ref =
                     ckd_ref
                     and ap_type = "CK"
                  no-lock:
                  end.
                  if available apmaster
                     and apmaster.ap_effdate <= vodate1
                     {&APVORP04-P-TAG69}
                  then
                     run ip-set-ap.

                  v_ckd_net = if ck_curr <> ap_mstr.ap_curr
                     then
                  ckd_cur_amt + ckd_cur_disc
                  else ckd_amt     + ckd_disc.

                  if not available apmaster or
                     apmaster.ap_effdate <= vodate1
                     then
                     net = net - v_ckd_net.
                  {&APVORP04-P-TAG70}
                  ckdtotal = ckdtotal + v_ckd_net.

                  /* TOTAL THE AMOUNT VOIDED AFTER REPORT EFFDATE */
                  if ck_voideff <> ? then
                     voidtotal = voidtotal + v_ckd_net.

               end.  /* for each ckd_det */

               {&APVORP04-P-TAG10}
               /* IF CKDTOTAL <> VO_APPLIED THEN ASSUME CK WAS DELETED */
               if ckdtotal <> (vo_applied + voidtotal)
                  {&APVORP04-P-TAG68}
               then
                  net = net - (vo_applied - ckdtotal).

               assign
                  curr_amt = net
                  base_amt = net.
               {&APVORP04-P-TAG11}
               if base_rpt = "" and ap_mstr.ap_curr <> base_curr then do:

                  /* ONLY CONVERT BASE AMOUNT IF IT NO LONGER EQUALS */
                  /* AP_AMT (MEANING CHECKS HAVE BEEN APPLIED TO IT  */
                  /* IN THE ABOVE SECTION)                           */

                  if net <> ap_amt then
                  /* CONVERT FROM FOREIGN TO BASE CURRENCY */
                  run ip-curr-conv
                     (input ap_mstr.ap_curr,
                     input  base_curr,
                     input  ap_mstr.ap_ex_rate,
                     input  ap_mstr.ap_ex_rate2,
                     input  base_amt,
                     input  true, /* ROUND */
                     output base_amt).

                  else base_amt = ap_base_amt.

                  /* GET EXCHANGE RATE FOR OPEN VOUCHERS ONLY */

                  if net <> 0
                  then do:

                     {&APVORP04-P-TAG12}
                     run ip-get-ex-rate
                        (input ap_curr,
                         input  base_curr,
                         input  ap_ex_ratetype,
                         input  vodate1,
                         output exdrate,
                         output exdrate2,
                         output mc-error-number).
                     {&APVORP04-P-TAG13}

                  end. /* IF net <> 0 */

                  if mc-error-number <> 0 then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                  end.

                  if mc-error-number = 0 then
                  /* CONVERT FROM FOREIGN TO BASE CURRENCY */
                  run ip-curr-conv
                     (input ap_mstr.ap_curr,
                     input  base_curr,
                     input  exdrate,
                     input  exdrate2,
                     input  curr_amt,
                     input  true, /* ROUND */
                     output curr_amt).

                  /* IF NO EXCHANGE RATE FOR TODAY, USE THE VOUCHER RATE */
                  else
                  /* CONVERT FROM FOREIGN TO BASE CURRENCY */
                  run ip-curr-conv
                     (input  ap_mstr.ap_curr,
                     input  base_curr,
                     input  ap_mstr.ap_ex_rate,
                     input  ap_mstr.ap_ex_rate2,
                     input  curr_amt,
                     input  true, /* ROUND */
                     output curr_amt).

               end.

               {&APVORP04-P-TAG14}
               multi-due = no.

               for first ct_mstr
                  fields( ct_domain ct_code ct_dating ct_due_date ct_due_days
                  ct_from_inv)
                   where ct_mstr.ct_domain = global_domain and  ct_code =
                   vo_cr_terms
               no-lock:
               end.
               if available ct_mstr
               and ct_dating
               and l_ageby = "1"
               then do:
                  assign
                     multi-due   = yes
                     tot-amt     = 0
                     vo-tot      = 0
                     applied-amt = base_applied.

                  for each ctd_det
                        fields( ctd_domain ctd_code ctd_date_cd ctd_pct_due)
                         where ctd_det.ctd_domain = global_domain and  ctd_code =
                         vo_cr_terms no-lock
                        break by ctd_code:

                     for first ct_mstr
                        fields( ct_domain ct_code ct_dating ct_due_date
                        ct_due_days ct_from_inv)
                         where ct_mstr.ct_domain = global_domain and  ct_code =
                         ctd_date_cd
                     no-lock:

                     run ip-set-due-date.

                     /* Calculate the amt-due less the applied */
                     /* for this segment.  To prevent rounding */
                     /* errors, assign last bucket = rounded   */
                     /* total - running total */

                     amt-due = if last-of(ctd_code)
                        then
                     base_amt - tot-amt
                     else
                        base_amt * (ctd_pct_due / 100).

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
                              tot-amt     = tot-amt + amt-due.
                           next. /* THIS SEGMENT IS CLOSED */
                        end.
                        else
                        assign
                           tot-amt     = tot-amt + amt-due
                           amt-due     = amt-due - applied-amt
                           applied-amt = 0.

                        age_period = 4.
                        do i = 1 to 4:
                           if (vodate1 - age_days[i]) <= due-date then
                              age_period = i.
                           if age_period <> 4 then leave.
                        end.
                        assign
                           age_amt[age_period] = age_amt[age_period] +
                           (amt-due)
                           vo-tot = vo-tot + (amt-due).

                        if tot-amt >= ap_amt then leave.
                     end.  /* for first ct_mstr */
                  end.  /* for each ctd_det */
               end.  /* if available ct_mstr &  ct_dating = yes ... */

               else
                  age_amt[age_period] = base_amt.  /* net */
               {&APVORP04-P-TAG15}

               do i = 1 to 4:
                  if et_report_curr <> mc-rpt-curr then
                  run ip-curr-conv
                     (input  mc-rpt-curr,
                     input  et_report_curr,
                     input  et_rate1,
                     input  et_rate2,
                     input  age_amt[i],
                     input  true,  /* ROUND */
                     output et_age_amt[i]).

                  else et_age_amt[i] = age_amt[i].
               end.  /* do i = 1 to 4 */
               if et_report_curr <> mc-rpt-curr then do:

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
                     input  curr_amt,
                     input  true,  /* ROUND */
                     output et_curr_amt).

               end.  /* if et_report_curr <> mc-rpt-curr */
               else
               assign
                  et_curr_amt = curr_amt
                  et_base_amt = base_amt.

               {&APVORP04-P-TAG16}
               accumulate et_curr_amt (total).
               accumulate et_age_amt  (total).
               accumulate et_base_amt (total).
               accumulate age_amt (total).
               accumulate base_amt (total).
               accumulate curr_amt (total).
               {&APVORP04-P-TAG17}

               hold = if vo_hold_amt <> 0 then "H" else "".

               {&APVORP04-P-TAG51}
               run ip-disp-voucher.
               {&APVORP04-P-TAG52}
               {mfrpchk.i}
            end. /* FOR EACH VO_MSTR ... */
         end. /* IF lstype = "" */
         {&APVORP04-P-TAG18}
      end. /* for each ap_mstr ... */

      if newvend = no then do with frame c:

         {&APVORP04-P-TAG53}
         underline
            et_age_amt et_base_amt
         with frame c.

         {&APVORP04-P-TAG54}
         {&APVORP04-P-TAG19}
         display
            l_label1
            accum total (et_age_amt[1]) @ et_age_amt[1]
            accum total (et_age_amt[2]) @ et_age_amt[2]
            accum total (et_age_amt[3]) @ et_age_amt[3]
            accum total (et_age_amt[4]) @ et_age_amt[4]
            accum total et_base_amt     @ et_base_amt
            {&APVORP04-P-TAG55}
         with frame e.
         {&APVORP04-P-TAG20}
         {&APVORP04-P-TAG56}
      end.

      {mfrpchk.i}
   end.  /* for each vd_mstr ... */

   underline
      et_age_amt[1 for 4] et_base_amt
      {&APVORP04-P-TAG57}
   with frame c.

   {&APVORP04-P-TAG21}
   display
      l_label2                    @ l_label1
      accum total (et_age_amt[1]) @ et_age_amt[1]
      accum total (et_age_amt[2]) @ et_age_amt[2]
      accum total (et_age_amt[3]) @ et_age_amt[3]
      accum total (et_age_amt[4]) @ et_age_amt[4]
      accum total et_base_amt     @ et_base_amt
      {&APVORP04-P-TAG58}
   with frame e.

   down 1 with frame e.
   {&APVORP04-P-TAG22}

   /* DETERMINE ORIGINAL TOTALS, NOT YET CONVERTED */
   assign
      et_org_age_amt[1] = accum total (age_amt[1])
      et_org_age_amt[2] = accum total (age_amt[2])
      et_org_age_amt[3] = accum total (age_amt[3])
      et_org_age_amt[4] = accum total (age_amt[4])
      et_org_amt        = accum total (base_amt)
      et_org_curr_amt   = accum total curr_amt.

   {&APVORP04-P-TAG23}
   /*CONVERT AMOUNTS*/

   do i = 1 to 4:
      if et_report_curr <> mc-rpt-curr then
      run ip-curr-conv
         (input mc-rpt-curr,
         input et_report_curr,
         input et_rate1,
         input et_rate2,
         input et_org_age_amt[i],
         input true,  /* ROUND */
         output et_org_age_amt[i]).

   end.  /* do i = 1 to 4 */
   if et_report_curr <> mc-rpt-curr then do:

      run ip-curr-conv
         (input  mc-rpt-curr,
         input  et_report_curr,
         input  et_rate1,
         input  et_rate2,
         input  et_org_amt,
         input  true,  /* ROUND */
         output et_org_amt).

      run ip-curr-conv
         (input  mc-rpt-curr,
         input  et_report_curr,
         input  et_rate1,
         input  et_rate2,
         input  et_org_curr_amt,
         input  true,  /* ROUND */
         output et_org_curr_amt).

   end.  /* if et_report_curr <> mc-rpt-curr */
   {&APVORP04-P-TAG24}

   /* DISPLAY CONVERTED REPORT AMOUNTS */

   if et_ctrl.et_show_diff
      and (
      ((accum total et_age_amt[1]) - et_org_age_amt[1] <> 0 )
      or  ((accum total et_age_amt[2]) - et_org_age_amt[2] <> 0 )
      or  ((accum total et_age_amt[3]) - et_org_age_amt[3] <> 0 )
      or  ((accum total et_age_amt[4]) - et_org_age_amt[4] <> 0 )
      or  ((accum total et_base_amt)   - et_org_amt        <> 0 )
      )
   then do:

      /* DISPLAY REPORT DIFFRENCCES */

      display
         (trim(substring(et_diff_txt,1,36)) + ":")
         format "x(37)" @ l_label1
         ((accum total et_age_amt[1]) - et_org_age_amt[1])
         @ et_age_amt[1]
         ((accum total et_age_amt[2]) - et_org_age_amt[2])
         @ et_age_amt[2]
         ((accum total et_age_amt[3]) - et_org_age_amt[3])
         @ et_age_amt[3]
         ((accum total et_age_amt[4]) - et_org_age_amt[4])
         @ et_age_amt[4]
         ((accum total  (et_base_amt)) - et_org_amt)
         @ et_base_amt
      with frame e.
   end. /* IF ET_SHOW_DIFF */

   et_diff_exist = et_ctrl.et_show_diff and
      (
      (((accum total (et_base_amt)) - et_org_amt)      <> 0) or
      (((accum total (et_curr_amt)) - et_org_curr_amt) <> 0) or
      ((((accum total (et_curr_amt)) - et_org_curr_amt) -
      ((accum total (et_base_amt)) - et_org_amt) ) <> 0)
      ).

   {&APVORP04-P-TAG59}
   if base_rpt = "" then
   do on endkey undo, leave:
      {&APVORP04-P-TAG25}
      display
         et_diff_txt to 96 when (et_diff_exist)

         getTermLabel("TOTAL",5) + " " + et_report_curr + " "
         + getTermLabelRtColon("AGING",6)
         format "x(17)" to 45

         (accum total (et_base_amt))
         format "->>>>>,>>>,>>9.99" at 46

         ((accum total (et_base_amt)) - et_org_amt)
         format "->>>>>,>>>,>>9.99" at 77
         when (et_diff_exist)

         getTermLabelRt("AGING_AT_EXCHANGE_RATES_FOR",34) + " " +
         string(vodate1) + ":"
         format "x(44)" to 44

         accum total et_curr_amt
         format "->>>>>,>>>,>>9.99" at 46

         ((accum total(et_curr_amt)) - et_org_curr_amt)
         format "->>>>>,>>>,>>9.99" at 77
         when (et_diff_exist)

         getTermLabelRtcolon("VARIANCE",13) format "x(13)"  to 44

         (accum total (et_curr_amt)) - (accum total (et_base_amt))
         format "->>>>>,>>>,>>9.99" at 46

         ( ( (accum total (et_curr_amt)) - et_org_curr_amt) -
         ( (accum total (et_base_amt))    - et_org_amt) )
         format "->>>>>,>>>,>>9.99" at 77
         when (et_diff_exist)

      with frame d width 132 no-labels.
      {&APVORP04-P-TAG60}
   end. /* IF BASE-RPT = "" */

   /* REPORT TRAILER */
   hide frame phead1.
   {&APVORP04-P-TAG26}
   {mfrtrail.i}
   SS - 090415.1 - E */

   /* SS - 090415.1 - B */
   PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.

    EMPTY TEMP-TABLE ttxxapvorp0401.
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
    EXPORT DELIMITER ";" "��Ӧ�̴���" "��Ӧ������" "��ϵ��" "�绰" "�ֻ�" "ƾ֤" "��Ʊ����" "��Ч����" "��ֹ����" "֧����ʽ" "��������1" "��������2" "��������3" "��������4" "��������5" "��������6" "��������7" "��������8" "��������ϼ�" "��������" "�һ���1" "�һ���2" "����" "�˻�" "���˻�" "�ɱ�����" "ԭ������ϼ�".
    EXPORT DELIMITER ";" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��׼���" "��չ���" "��չ���" "��չ���" "��չ���".
    EXPORT DELIMITER ";" "ap_vend" "name" "ad_attn" "ad_phone" "ad_ext" "voucherno" "invdate" "effdate" "duedate" "vo_cr_terms" "et_age_amt[1]" "et_age_amt[2]" "et_age_amt[3]" "et_age_amt[4]" "et_age_amt[5]" "et_age_amt[6]" "et_age_amt[7]" "et_age_amt[8]" "et_base_amt" "hold" "ap_ex_rate" "ap_ex_rate2" "ap_curr" "ap_acct" "ap_sub" "ap_cc" "et_curr_amt".
    FOR EACH ttxxapvorp0401:
        EXPORT DELIMITER ";" ttxxapvorp0401.
    END.

    PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.

    {xxmfrtrail.i}
   /* SS - 090415.1 - E */

end.

PROCEDURE ip-param-init:

   if ref1    = hi_char then ref1    = "".
   if vend1   = hi_char then vend1   = "".
   if vodate1 = hi_date then vodate1 = ?.
   /* SS - 090415.1 - B */
   if acct1 = hi_char then acct1 = "".
   if sub1 = hi_char then sub1 = "".
   if cc1 = hi_char then cc1 = "".
   /* SS - 090415.1 - E */
   if entity1 = hi_char then entity1 = "".
   if votype1 = hi_char then votype1 = "".
   if vdtype1 = hi_char then vdtype1 = "".

   {&APVORP04-P-TAG61}
   /* SS - 090415.1 - B
   do i = 1 to 4:
   SS - 090415.1 - E */
   /* SS - 090415.1 - B */
   do i = 1 to 8:
   /* SS - 090415.1 - E */
      if age_days[i] = 0 then age_days[i] = (i * 30).
   end.

   {&APVORP04-P-TAG27}
END PROCEDURE.  /* ip-param-init */

PROCEDURE ip-param-quoter:

   bcdparm = "".
   {mfquoter.i vend           }
   {mfquoter.i vend1          }
   {mfquoter.i vdtype         }
   {mfquoter.i vdtype1        }
   {&APVORP04-P-TAG62}
   /* SS - 090415.1 - B */
   {mfquoter.i acct         }
   {mfquoter.i acct1        }
   {mfquoter.i sub         }
   {mfquoter.i sub1        }
   {mfquoter.i cc         }
   {mfquoter.i cc1        }
   /* SS - 090415.1 - E */
   {mfquoter.i entity         }
   {mfquoter.i entity1        }
   {mfquoter.i ref            }
   {mfquoter.i ref1           }
   {mfquoter.i votype         }
   {mfquoter.i votype1        }
   {mfquoter.i vodate1        }
   {&APVORP04-P-TAG28}
   {mfquoter.i age_by         }
   {&APVORP04-P-TAG29}
   {mfquoter.i base_rpt       }
   {mfquoter.i et_report_curr }
   {&APVORP04-P-TAG63}
   {mfquoter.i age_days[1]    }
   {mfquoter.i age_days[2]    }
   {mfquoter.i age_days[3]    }
   /* SS - 090415.1 - B */
   {mfquoter.i age_days[4]    }
   {mfquoter.i age_days[5]    }
   {mfquoter.i age_days[6]    }
   {mfquoter.i age_days[7]    }
   /* SS - 090415.1 - E */

   if ref1    = "" then ref1    = hi_char.
   if vend1   = "" then vend1   = hi_char.
   if vodate1 = ?  then vodate1 = hi_date.
   /* SS - 090415.1 - B */
   if acct1    = "" then acct1    = hi_char.
   if sub1    = "" then sub1    = hi_char.
   if cc1    = "" then cc1    = hi_char.
   /* SS - 090415.1 - E */
   if entity1 = "" then entity1 = hi_char.
   if votype1 = "" then votype1 = hi_char.
   if vdtype1 = "" then vdtype1 = hi_char.
   {&APVORP04-P-TAG64}
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
   define output parameter o_disp_line1 as character no-undo initial "".
   define output parameter o_disp_line2 as character no-undo initial "".
   define output parameter o_error      as integer   no-undo initial 0.
   define variable v_seq                as integer   no-undo.
   define variable v_fix_rate           as logical   no-undo.

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
         if not batchrun
         then do:
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
         end. /* IF NOT BATCHRUN */

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

PROCEDURE ip-get-ex-rate:

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

{&APVORP04-P-TAG65}
PROCEDURE ip-disp-voucher:

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
      {&APVORP04-P-TAG30}
      display
         voucherno
         invdate
         effdate
         vo_mstr.vo_cr_terms
         et_age_amt[1]
         et_age_amt[2]
         et_age_amt[3]
         et_age_amt[4]
         et_base_amt
         hold
      with frame c.
      down 1 with frame c.

      if multi-due then
      put invoice at 1 format "x(12)"
         {gplblfmt.i &FUNC=getTermLabel(""MULTIPLE"",10) } at 14.
      else put invoice at 1 format "x(12)"
               duedate at 14.

      if base_curr <> ap_mstr.ap_curr then
      put
         (ap_mstr.ap_ex_rate / ap_mstr.ap_ex_rate2)
         format ">>>>>9.9<<<<<"
         at 23
         space(1)
         ap_mstr.ap_curr.
   end.
   {&APVORP04-P-TAG31}

END PROCEDURE.  /* ip-disp-voucher */
{&APVORP04-P-TAG66}

PROCEDURE ip-set-vars:

   assign
      ckdtotal   = 0
      voidtotal  = 0
      {&APVORP04-P-TAG32}
      age_amt    = 0
      et_age_amt = 0
      {&APVORP04-P-TAG33}
      voflag     = ap_mstr.ap_effdate <= vodate1
      net        = 0
      age_period = 4.

   if voflag then do:

      /* SS - 090415.1 - B
      assign
         age_by_date = if l_ageby = "2"
         then ap_effdate
         else
      if l_ageby = "3"
         then ap_date
         else vo_mstr.vo_due_date
         age_period = 4.

      do i = 1 to 4:
         if (vodate1 - age_days[i]) <= age_by_date then
            age_period = i.
         if age_period <> 4 then leave.
      end.
      SS - 090415.1 - E */
      /* SS - 090415.1 - B */
      assign
         age_by_date = if l_ageby = "2"
         then ap_effdate
         else
      if l_ageby = "3"
         then ap_date
         else vo_mstr.vo_due_date
         age_period = 8.

      do i = 1 to 8:
         if (vodate1 - age_days[i]) <= age_by_date then
            age_period = i.
         if age_period <> 8 then leave.
      end.
      /* SS - 090415.1 - E */
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

PROCEDURE ip-set-due-date:

   due-date = if ct_mstr.ct_due_date <> ?
      then
   ct_due_date
   else
if ct_from_inv = 1
      then
   ap_mstr.ap_date + ct_due_days
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

PROCEDURE ip-set-ap:

   if voflag = no and available apmaster then do:
      /* SS - 090415.1 - B
      age_period = 4.
      do i = 1 to 4:
         if (vodate1 - age_days[i]) <= apmaster.ap_effdate
            then age_period = i.
         if age_period <> 4 then leave.
      end.
      SS - 090415.1 - E */
      /* SS - 090415.1 - B */
      age_period = 8.
      do i = 1 to 8:
         if (vodate1 - age_days[i]) <= apmaster.ap_effdate
            then age_period = i.
         if age_period <> 8 then leave.
      end.
      /* SS - 090415.1 - E */
      if apmaster.ap_effdate = ? then age_period = 1.
      assign
         voucherno = apmaster.ap_ref
         invoice   = getTermLabel("PAYMENT",12)
         effdate   = apmaster.ap_effdate
         invdate   = apmaster.ap_date
         duedate   = ?.
   end.

END PROCEDURE.  /* ip-set-ap */
{&APVORP04-P-TAG34}
{&APVORP04-P-TAG67}