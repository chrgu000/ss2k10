/* arparp.p - DETAIL PAYMENT AUDIT REPORT                               */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.19.1.19 $                                                         */
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
/* $Revision: 1.19.1.19 $         BY: Priya Idnani       DATE: 05/23/05   ECO: *P3LZ* */
/*-Revision end---------------------------------------------------------------*/


/*V8:ConvertMode=FullGUIReport                                               */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 091120.1 By: Bill Jiang */

/* SS - 091120.1 - RNB
[091120.1]

适用于在一张A4纸上输出两个凭证

每个凭证固定为四行

单位名称取"会计单位代码维护[glenmt.p]"的"说明[en_name]"

仅限于以下类型的账户:ALIE

对于已收款的发票或通知单,其<摘要>显示为<类型: 参考号>
  - 发票类型: I
  - 通知单类型: M

[091120.1]

SS - 091120.1 - RNE */

/* SS - 091120.1 - B */
{ssarparp0001.i "new"}

{xxcarar2a.i "new"}

define NEW shared variable ttssarparp0001_recno  as recid         no-undo.
define NEW shared variable line_tt1  as INTEGER         no-undo.

DEFINE VARIABLE tot_dr_amt AS DECIMAL.
/* SS - 091120.1 - E */

/*
{mfdtitle.i "1+ "}
*/
{mfdtitle.i "091120.1"}
{cxcustom.i "ARPARP.P"}

/* DEFINE NEW SHARED WORKFILE AP_WKFL FOR CURRENCY SUMMARY */
{gpacctp.i "new"}

{gldydef.i new}
{gldynrm.i new}

{&ARPARP-P-TAG1}
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

/* SS - 091120.1 - B */
/* 报表名称 */
FIND FIRST ad_mstr 
   WHERE 
   ad_addr = "~~reports" 
   NO-LOCK 
   NO-ERROR
   .
IF AVAILABLE ad_mstr THEN DO:
    ASSIGN
       NAME_reports = ad_name
       .
END.
ELSE DO:
   ASSIGN
      NAME_reports = ""
      .
END.

/* 用户名称 */
FIND FIRST usr_mstr WHERE usr_userid = global_userid NO-LOCK NO-ERROR.
IF AVAIL USr_mstr THEN DO:
   ASSIGN 
      NAME_usr = usr_name
      .
END.
ELSE DO:
   ASSIGN 
      NAME_usr = ""
      .
END.
/* SS - 091120.1 - E */

{&ARPARP-P-TAG2}
form
   batch                         colon 18
   batch1         label {t001.i} colon 49 skip
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

   /* SS - 091120.1 - B */
   /*
   if can-find(first ap_wkfl)
   then do:
      for each ap_wkfl
      exclusive-lock:
         delete ap_wkfl.
      end. /* FOR EACH ap_wkfl */
   end. /* IF CAN-FIND(FIRST ap_wkfl) */
   */
   /* SS - 091120.1 - E */
   if batch1 = hi_char
   then
      batch1 = "".
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
      &fields  = "  batch batch1 check_nbr check1 cust cust1 entity entity1
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

   {xxSoftspeedLic.i "SoftspeedCAR.lic" "SoftspeedCAR"}

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
   /* SS - 091120.1 - B */
   /*
   {mfphead.i}
   {&ARPARP-P-TAG17}

   /* DELETE GL WORKFILE ENTRIES */
   if gltrans = yes
   then
      for each gltw_wkfl
          where gltw_userid = mfguser
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
   /* 输出到BI */
   PUT UNFORMATTED "#def REPORTPATH=$/QAD Addons/BI Report/" + SUBSTRING(execname, 1, LENGTH(execname) - 2) SKIP.
   PUT UNFORMATTED "#def :end" SKIP.
   
   EMPTY TEMP-TABLE ttssarparp0001.
   
   {gprun.i ""ssarparp0001.p"" "(
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
   
   tot_dr_amt = 0.
   LINE_tt1 = 0.
   EMPTY TEMP-TABLE tt1.
   EMPTY TEMP-TABLE tt2.
   FOR EACH ttssarparp0001
      ,EACH ac_mstr NO-LOCK
      WHERE ac_code = ttssarparp0001_ard_acct
      AND INDEX("ALIE",ac_type) > 0
      ,EACH sb_mstr NO-LOCK
      WHERE sb_sub = ttssarparp0001_ard_sub
      ,EACH cc_mstr NO-LOCK
      WHERE cc_ctr = ttssarparp0001_ard_cc
      /*
      ,EACH pj_mstr NO-LOCK
      WHERE pj_proj = ttssarparp0001_ard_project
      */
      BREAK BY ttssarparp0001_ar_nbr 
      :
      LINE_tt1 = LINE_tt1 + 1.

      /* line */
      CREATE tt1.
      ASSIGN
         tt1_ref = ttssarparp0001_ar_nbr
         tt1_line = LINE_tt1
         tt1_effdate = STRING(YEAR(ttssarparp0001_ar_effdate)) + "." +  STRING(MONTH(ttssarparp0001_ar_effdate)) + "." +  STRING(DAY(ttssarparp0001_ar_effdate))
         tt1_desc = ttssarparp0001_ard_type 
         /* SS - 091120.1 - B */
         + ": "
         /* SS - 091120.1 - E */
         + ttssarparp0001_ard_ref
         tt1_ascp  = ac_code
         tt1_as_desc = ac_desc
         .
                                              
      {gprun.i ""ssGetInt"" "(
         INPUT tt1_line,
         INPUT 4,
         OUTPUT tt1_page
         )"}

      IF sb_sub <> "" THEN DO:
         ASSIGN
            tt1_ascp = tt1_ascp + "-" + sb_sub
            tt1_as_desc = tt1_as_desc + "-" + sb_desc
            .
      END.

      IF cc_ctr <> "" THEN DO:
         ASSIGN
            tt1_ascp = tt1_ascp + "-" + cc_ctr
            tt1_cp_desc = cc_desc
            .
      END.

      /*
      IF pj_project <> "" THEN DO:
         ASSIGN 
            tt1_ascp = tt1_ascp + "-" + pj_project
            .
         IF tt1_cp_desc = "" THEN DO:
            ASSIGN 
               tt1_cp_desc = pj_desc
               .
         END.
         ELSE DO:
            ASSIGN 
               tt1_cp_desc = tt1_cp_desc + "-" + pj_desc 
               .
         END.
      END.
      */

      assign 
         tt1_cr_amt = ttssarparp0001_ard_base_amt + ttssarparp0001_ard_base_disc
         .
      tot_dr_amt = tot_dr_amt + tt1_cr_amt.
            
      IF ac_curr <> base_curr THEN DO:
         ASSIGN
            tt1_curramt = ABS(ttssarparp0001_ard_amt + ttssarparp0001_ard_disc)
            tt1_ex_rate = ac_curr + "汇" + STRING(ttssarparp0001_ar_ex_rate2 / ttssarparp0001_ar_ex_rate ) 
            .
      END.

      IF ttssarparp0001_ard_base_disc <> 0 THEN DO:
         ttssarparp0001_recno = RECID(ttssarparp0001).
         LINE_tt1 = line_tt1 + 1.
         {gprun.i ""xxcarar2b.p""}
      END.



      /* ref */
      IF LAST-OF(ttssarparp0001_ar_nbr) THEN DO:
         ttssarparp0001_recno = RECID(ttssarparp0001).
         LINE_tt1 = line_tt1 + 1.
         {gprun.i ""xxcarar2a.p""}

         CREATE tt2.
         ASSIGN 
            tt2_ref = ttssarparp0001_ar_nbr
            tt2_decimal1 = ABS(tot_dr_amt)
            tt2_effdate = STRING(YEAR(ttssarparp0001_ar_effdate)) + "." +  STRING(MONTH(ttssarparp0001_ar_effdate)) + "." +  STRING(DAY(ttssarparp0001_ar_effdate))
            tt2_cp_desc = NAME_reports
            tt2_as_desc = "由 " + name_usr + " 打印 " + "(日期: " + string(year(today)) + "." + string(month(today)) + "." + string(day(today)) + ", " + "时间: " + STRING(TIME,"HH:MM:SS") + ")" 
            /* 6 - 客户 */
            tt2_ex_rate = "客户: " + ttssarparp0001_ar_bill + " " + ttssarparp0001_ad_name
            /* 7 - 批处理 */
            tt2_char1 = "批处理: " + ttssarparp0001_ar_batch
            .

         {gprun.i ""xxcaren.p"" "(
            INPUT ttssarparp0001_ar_entity,
            INPUT-OUTPUT tt2_cp_desc
            )"}

         /* 8 - 银行 */
         FIND FIRST bk_mstr WHERE bk_code = ttssarparp0001_ar_bank NO-LOCK NO-ERROR.
         IF AVAILABLE bk_mstr THEN DO:
            ASSIGN
               tt2_user2 = "银行: " + string(ttssarparp0001_ar_bank) + " " + bk_desc
               .
         END.

         {gprun.i ""ssGetInt"" "(
            INPUT line_tt1,
            INPUT 4,
            OUTPUT tt2_page
            )"}

         {gprun.i ""ssGetCN"" "(
            INPUT tot_dr_amt,
            OUTPUT tt2_desc
            )"}

         ASSIGN 
            tt2_ascp = "审核:                              复核:                              制单: "
            .

         tot_dr_amt = 0.
         LINE_tt1 = 0.
      END. /* IF LAST-OF(ttssarparp0001_ar_nbr) THEN DO: */
   END. /* for each vo_hist */

   FOR EACH tt2:
       EXPORT DELIMITER ";" 
          tt2_ref 
          tt2_line 
          tt2_desc 
          tt2_ascp 
          tt2_as_desc 
          tt2_ex_rate 
          tt2_char1 
          tt2_user2 
          tt2_effdate 
          tt2_dr_amt 
          tt2_cr_amt 
          tt2_decimal1 
          tt2_curramt 
          tt2_cp_desc 
          ""
          .
       FOR EACH tt1 WHERE tt1_ref = tt2_ref:
          EXPORT DELIMITER ";" 
             tt1_ref 
             tt1_line 
             tt1_desc 
             tt1_ascp 
             tt1_as_desc 
             tt1_ex_rate 
             tt1_char1 
             tt1_user2 
             tt1_effdate 
             tt1_dr_amt 
             tt1_cr_amt 
             tt1_decimal1 
             tt1_curramt 
             (STRING(tt1_page) + "/" + STRING(tt2_page))
             tt1_cp_desc 
             .
       END.
   END.

   {xxmfrtrail.i}
   /* SS - 091120.1 - E */

end. /* REPEAT */

{wbrp04.i &frame-spec = a}
