/* arparp.p - DETAIL PAYMENT AUDIT REPORT                               */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.19.1.19 $                                               */
/* REVISION: 2.0      LAST MODIFIED: 12/09/86   BY: PML        */
/* REVISION: 4.0      LAST MODIFIED: 02/16/88   BY: FLM *A175* */
/* REVISION: 4.0      LAST MODIFIED: 07/27/88   BY: JC *C0028* */
/* REVISION: 4.0      LAST MODIFIED: 12/06/88   BY: JLC*C0028* */
/* REVISION: 5.0      LAST MODIFIED: 05/12/89   BY: MLB *B099* */
/* REVISION: 5.0      LAST MODIFIED: 06/23/89   BY: MLB *B159* */
/* REVISION: 5.0      LAST MODIFIED: 09/14/89   BY: MLB *B289* */
/* REVISION: 5.0      LAST MODIFIED: 10/04/89   BY: MLB *B326* */
/* REVISION: 5.0      LAST MODIFIED: 10/05/89   BY: MLB *B324* */
/* REVISION: 6.0      LAST MODIFIED: 08/29/90   BY: afs *D059* */
/* REVISION: 6.0      LAST MODIFIED: 08/31/90   BY: MLB *D055* */
/* REVISION: 6.0      LAST MODIFIED: 10/29/90   BY: MLB *D153* */
/* REVISION: 6.0      LAST MODIFIED: 02/28/91   BY: afs *D387* */
/* REVISION: 6.0      LAST MODIFIED: 03/15/91   BY: bjb *D461* */
/* REVISION: 6.0      LAST MODIFIED: 03/19/91   BY: MLB *D444* */
/* REVISION: 6.0      LAST MODIFIED: 04/17/91   BY: bjb *D515* */
/* REVISION: 7.0      LAST MODIFIED: 10/28/91   BY: MLV *F028* */
/* REVISION: 6.0      LAST MODIFIED: 11/18/19   BY: afs *D935* */
/* REVISION: 7.0      LAST MODIFIED: 03/04/92   BY: jms *F237* */
/* REVISION: 7.0      LAST MODIFIED: 03/17/92   BY: TMD *F258* */
/*                                   05/04/92   by: jms *F466* */
/* REVISION: 7.3      LAST MODIFIED: 08/03/92   by: jms *G024* */
/*                                   09/30/92   by: jms *G111* */
/*                                   09/27/93   by: jcd *G247* */
/*                                   11/23/92   by: mpp *G351* */
/*                                   03/17/93   by: bcm *G834* */
/*                                   04/20/93   by: bcm *G981* */
/* REVISION: 7.3      LAST MODIFIED: 06/29/93   by: pcd *GC86* REV ONLY */
/*                                   08/17/93   by: jjs *GE34*          */
/*                                           (split off arparpa.p)      */
/*                                   08/23/94   by: rxm *GL40*          */
/* Oracle changes (share-locks)    09/11/94           BY: rwl *FR14*    */
/* REVISION: 7.4      LAST MODIFIED: 10/27/94   by: ame *GN63*          */
/* REVISION: 8.5      LAST MODIFIED: 12/13/95   by: taf *J053*          */
/*                                   04/09/96   by: jzw *G1T9*          */
/* REVISION: 8.6      LAST MODIFIED: 03/18/97   BY: *K082* E. HUGHART   */
/* REVISION: 8.6      LAST MODIFIED: 10/16/97   BY: bvm *K0QK*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/*                                   8 apr 98   by: rup *L00K*              */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan       */
/* REVISION: 8.6E     LAST MODIFIED: 07/21/98   BY: *L01K* Jaydeep Parikh   */
/* REVISION: 9.1      LAST MODIFIED: 10/13/99   BY: *L0K5* Hemali Desai     */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn              */
/* REVISION: 9.1      LAST MODIFIED: 10/25/00   BY: *N0T7* Jean Miller      */
/* REVISION: 9.1      LAST MODIFIED: 09/13/00 BY: *N0VV* BalbeerS Rajput    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* Revision: 1.19.1.8  BY: Mercy C.        DATE: 03/21/02  ECO: *M1WF*      */
/* Revision: 1.19.1.9  BY: Karel Groos     DATE: 03/26/02  ECO: *N1B4*      */
/* Revision: 1.19.1.10 BY: Patrick de Jong DATE: 05/31/02  ECO: *P07H*      */
/* Revision: 1.19.1.11 BY: Manjusha Inglay DATE: 07/29/02  ECO: *N1P4*      */
/* Revision: 1.19.1.12 BY: Nishit V        DATE: 11/20/02  ECO: *N1ZZ*      */
/* Revision: 1.19.1.13  BY: Narathip W.        DATE: 05/19/03   ECO: *P0SH* */
/* Revision: 1.19.1.15  BY: Paul Donnelly (SB) DATE: 06/26/03   ECO: *Q00B* */
/* Revision: 1.19.1.16  BY: Preeti Sattur      DATE: 10/30/04   ECO: *P2S3* */
/* Revision: 1.19.1.17  BY: Reena Ambavi       DATE: 11/30/04   ECO: *P2XC* */
/* Revision: 1.19.1.18  BY: Preeti Sattur      DATE: 02/15/05   ECO: *P37L* */
/* $Revision: 1.19.1.19 $ BY: Priya Idnani       DATE: 05/23/05   ECO: *P3LZ* */
/*-Revision end---------------------------------------------------------------*/


/*V8:ConvertMode=FullGUIReport                                               */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 100705.1 By: Bill Jiang */

/* SS - 100705.1 - B */
{xxarparp0001.i "new"}
/* SS - 100705.1 - E */
/* ss - 120229.1 - B /
 * add var cc cc1 for ttxxarparp0001_ard_cc 筛选条件
 * ss - 120229.1 - E*/


{mfdtitle.i "120229.1"}
{cxcustom.i "ARPARP.P"}

/* DEFINE NEW SHARED WORKFILE AP_WKFL FOR CURRENCY SUMMARY */
{gpacctp.i "new"}

{gldydef.i new}
{gldynrm.i new}

{&ARPARP-P-TAG1}
define new shared variable cc        like wo_cc no-undo.
define new shared variable cc1       like wo_cc no-undo.
define new shared variable bank      like ar_bank no-undo.
define new shared variable bank1     like bank no-undo.
define new shared variable rndmthd   like rnd_rnd_mthd.
/* DEFINE OLD_CURR FOR CALL TO GPACCTP.P */
define new shared variable old_curr  like ar_curr initial "".
define new shared variable cust      like ar_bill.
define new shared variable cust1     like ar_bill.
define new shared variable check_nbr like ar_check.
define new shared variable check1    like ar_check.
define new shared variable batch     like ar_batch.
define new shared variable batch1    like ar_batch.
define new shared variable entity    like ar_entity.
define new shared variable entity1   like ar_entity.
define new shared variable ardate    like ar_date.
define new shared variable ardate1   like ar_date.
define new shared variable effdate   like ar_effdate.
define new shared variable effdate1  like ar_effdate.
define new shared variable summary   like mfc_logical format "Summary/Detail"
                                     initial no label "Summary/Detail".
define new shared variable gltrans   like mfc_logical initial no
                                     label "Print GL Detail".
define new shared variable base_rpt  like ar_curr no-undo.
define new shared variable mixed_rpt like mfc_logical initial no
                                     label "Mixed Currencies".
define new shared variable ptype     like ar_type initial " "
                           label "Payment Type (<blank>,U,N)" no-undo.

/* FIELD l_unassign WILL HELP TO DECIDE WHETHER */
/* OPEN OR COMPLETE AMOUNT WILL BE DISPLAYED */

define new shared variable l_unassign  like mfc_logical
                                       format "Historical/Current"
                                       initial no
                                       label "Unassigned Unapplied Amount".
{&ARPARP-P-TAG9}

{&ARPARP-P-TAG18}

{etvar.i   &new = "new"}
{etrpvar.i &new = "new"}

{&ARPARP-P-TAG2}
form
   batch                         colon 18
   batch1         label {t001.i} colon 49 skip
   cc                            colon 18
   cc1            label {t001.i} colon 49 skip
   check_nbr                     colon 18
   check1         label {t001.i} colon 49 skip
   cust                          colon 18
   cust1          label {t001.i} colon 49 skip
   entity                        colon 18
   entity1        label {t001.i} colon 49 skip
   ardate                        colon 18
   ardate1        label {t001.i} colon 49 skip
   effdate                       colon 18
   effdate1       label {t001.i} colon 49 skip
   bank                          colon 18
   bank1          label {t001.i} colon 49 skip (1)
   ptype                         colon 28
   summary                       colon 28
   gltrans                       colon 28
   base_rpt                      colon 28
   mixed_rpt                     colon 28
   l_unassign                    colon 28
   {&ARPARP-P-TAG10}
with frame a side-labels width 80.

{&ARPARP-P-TAG3}
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}

repeat:

   /* SS - 100705.1 - B */
   /*
   if can-find(first ap_wkfl)
   then do:
      for each ap_wkfl
      exclusive-lock:
         delete ap_wkfl.
      end. /* FOR EACH ap_wkfl */
   end. /* IF CAN-FIND(FIRST ap_wkfl) */
   */
   /* SS - 100705.1 - E */
   if batch1 = hi_char
   then
      batch1 = "".
   if cc1 = hi_char
   then
      cc1 = "".
   if check1 = hi_char
   then
      check1 = "".
   if cust1  = hi_char
   then
      cust1  = "".
   if entity1 = hi_char
   then
      entity1 = "".
   if ardate  = low_date
   then
      ardate  = ?.
   if ardate1 = hi_date
   then
      ardate1 = ?.
   if effdate = low_date
   then
      effdate = ?.
   if effdate1 = hi_date
   then
      effdate1 = ?.
   if bank1    = hi_char
   then
      bank1    = "".
   {&ARPARP-P-TAG4}

   if c-application-mode <> 'web'
   then
      update
         batch     batch1
         cc        cc1
         check_nbr check1
         cust      cust1
         entity    entity1
         ardate    ardate1
         effdate   effdate1
         bank      bank1
         {&ARPARP-P-TAG5}
         ptype
         summary   gltrans
         base_rpt
         mixed_rpt
         l_unassign
         {&ARPARP-P-TAG11}
      with frame a.

   {&ARPARP-P-TAG6}
   {&ARPARP-P-TAG12}
   {wbrp06.i
      &command = update
      &fields  = " batch batch1 cc cc1 check_nbr check1 cust cust1 entity entity1
                   ardate ardate1 effdate effdate1 bank bank1 ptype summary
                   gltrans base_rpt
                   mixed_rpt
                   l_unassign"
      &frm     = "a"}
   {&ARPARP-P-TAG13}
   {&ARPARP-P-TAG7}

   if (c-application-mode <> 'web')
   or (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      {&ARPARP-P-TAG14}

      bcdparm = "".
      {mfquoter.i batch    }
      {mfquoter.i batch1   }
      {mfquoter.i cc       }
      {mfquoter.i cc1      }
      {mfquoter.i check_nbr}
      {mfquoter.i check1   }
      {mfquoter.i cust     }
      {mfquoter.i cust1    }
      {mfquoter.i entity   }
      {mfquoter.i entity1  }
      {mfquoter.i ardate   }
      {mfquoter.i ardate1  }
      {mfquoter.i effdate  }
      {mfquoter.i effdate1 }
      {mfquoter.i bank     }
      {mfquoter.i bank1    }
      {&ARPARP-P-TAG8}
      {mfquoter.i ptype    }
      {mfquoter.i summary  }
      {mfquoter.i gltrans  }
      {mfquoter.i base_rpt}
      {mfquoter.i mixed_rpt}
      {mfquoter.i l_unassign}
      {&ARPARP-P-TAG15}

      if batch1 = ""
      then
         batch1 = hi_char.
      if cc1 = ""
      then
         batch1 = hi_char.
      if check1 = ""
      then
         check1 = hi_char.
      if cust1  = ""
      then
         cust1  = hi_char.
      if entity1 = ""
      then
         entity1 = hi_char.
      if ardate  = ?
      then
         ardate  = low_date.
      if ardate1 = ?
      then
         ardate1 = hi_date.
      if effdate = ?
      then
         effdate  = low_date.
      if effdate1 = ?
      then
         effdate1 = hi_date.
      if bank1    = ""
      then
     bank1    = hi_char.

   end. /* IF (c-application-mode <> 'web') */

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i
      &printType = "printer"
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
   {&ARPARP-P-TAG16}
   /* SS - 100705.1 - B */
   /*
   {mfphead.i}
   {&ARPARP-P-TAG17}

   /* DELETE GL WORKFILE ENTRIES */
   if gltrans = yes
   then
      for each gltw_wkfl
          where gltw_wkfl.gltw_domain = global_domain and  gltw_userid = mfguser
      exclusive-lock:
         delete gltw_wkfl.
      end. /* FOR EACH gltw_wkfl */

   /* PRINT BODY OF REPORT */

   {&ARPARP-P-TAG19}

   {gprun.i ""arparpa.p""}

   {&ARPARP-P-TAG20}

   /* PRINT GL DISTRIBUTION */
   if gltrans
   then do:
      page.

      /* CHANGED GPGLRP.P TO GPGLRP1.P WHICH PRINTS GL DISTRIBUTION */
      /* TAKING INTO CONSIDERATION THE ROUNDING METHOD OF THE       */
      /* CURRENCY SPECIFIED IN SELECTION CRITERIA.                  */
      {gprun.i ""gpglrp1.p""}

      {&ARPARP-P-TAG21}
   end. /* IF gltrans */

   /*  DISPLAY CURRENCY TOTALS.                                     */
   if  base_rpt = ""
   and mixed_rpt
   then do:
      {gprun.i ""gpacctp.p""}.
   end. /* IF base_rpt = "" AND... */

   display
      getTermLabel("NOTE",6) + ": " +
      getTermLabel("GAIN/LOSS_IS_EXCLUDED_FROM_AR_AMT",47) format "x(55)"
   with frame f.

   /* REPORT TRAILER */
   {mfrtrail.i}
   */
   PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.

   EMPTY TEMP-TABLE ttxxarparp0001.

   {gprun.i ""xxarparp0001.p"" "(
      INPUT BATCH,
      INPUT BATCH1,
      INPUT CHECK_nbr,
      INPUT CHECK1,
      INPUT cust,
      INPUT cust1,
      INPUT entity,
      INPUT entity1,
      INPUT ardate,
      INPUT ardate1,
      INPUT effdate,
      INPUT effdate1,
      INPUT bank,
      INPUT bank,
      INPUT ptype,
      INPUT base_rpt,
      INPUT mixed_rpt,
      INPUT l_unassign
      )"}

   EXPORT DELIMITER ";" "ar_batch" "ar_check" "ar_bank" "ar_po" "ar_type"
                        "ar_date" "ar_entity" "ar_acct" "ar_sub" "ar_cc"
                        "ar_bill" "ad_name" "ex_rate_relation1" "ar_ex_rate"
                        "ar_ex_rate2" "ar_effdate" "ar_disc_acct" "ar_disc_sub"
                        "ar_disc_cc" "ex_rate_relation2" "ar_curr" "ar_amt"
                        "ar_base_amt" "ard_ref" "ard_type" "ard_type_desc"
                        "ard_entity" "ard_acct" "ard_sub" "ard_cc" "disp_curr"
                        "ard_amt" "ard_base_amt" "ard_disc" "ard_base_disc"
                        "aramt" "base_aramt" "unamt" "base_unamt" "nonamt"
                        "base_nonamt" "ar_nbr".
   EXPORT DELIMITER ";" "批处理" "支票" "银行" "备注!名称" "类型" "日期"
          "会计单位" "账户" "明细账户" "成本中心" "票据开往" "客户名称"
          "兑换率" "兑换率" "兑换率2" "生效日期" "折扣账户" "折扣明细账户"
          "折扣成本中心" "兑换率2" "货币" "金额" "基本金额" "参考" "类型"
          "类型说明" "会计单位" "账户" "明细账户" "成本中心" "货币" "金额"
          "基本金额" "折扣" "折扣" "应收帐款" "基本应收金额" "未指定用途金额"
          "基本未指定金额" "非应收金额" "基本非应收金额" "参考".
   FOR EACH ttxxarparp0001 where ttxxarparp0001_ard_cc >= cc and
           (ttxxarparp0001_ard_cc <= cc1 or cc1 = ""):
      EXPORT DELIMITER ";" ttxxarparp0001.
   END.

   PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.

   {xxmfrtrail.i}
   /* SS - 100705.1 - E */

end. /* REPEAT */

{wbrp04.i &frame-spec = a}
