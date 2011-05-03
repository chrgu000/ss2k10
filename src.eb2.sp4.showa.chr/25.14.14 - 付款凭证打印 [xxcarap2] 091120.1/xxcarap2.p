/* apckrp.p - AP CHECK REGISTER AUDIT REPORT                              */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                    */
/* All rights reserved worldwide.  This is an unpublished work.           */
/* $Revision: 1.8.1.12 $                                                         */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                    */
/*V8:ConvertMode=FullGUIReport                                   */
/* REVISION: 1.0      LAST MODIFIED: 10/20/86   BY: PML                   */
/* REVISION: 6.0      LAST MODIFIED: 02/22/91   BY: mlv *D361*            */
/*                                   04/03/91   BY: mlv *D494*            */
/* REVISION: 7.0      LAST MODIFIED: 01/27/92   BY: mlv *F098*            */
/*                                   05/19/92   BY: mlv *F509*(rev only)  */
/*                                   05/21/92   BY: mlv *F461*            */
/* REVISION: 7.3      LAST MODIFIED: 09/27/93   BY: jcd *G247*            */
/*                                   04/12/93   BY: jms *G937* (rev only) */
/*                                   04/17/93   BY: jms *G967* (rev only) */
/*                                   07/22/93   BY: wep *GD59* (rev only) */
/*                                   09/16/93   BY: bcm *GF38* (rev only) */
/* REVISION: 7.4      LAST MODIFIED: 09/21/93   BY: bcm *H110* (rev only) */
/*                                   11/24/93   BY: wep *H245*            */
/* REVISION: 7.4      LAST MODIFIED: 10/27/94   BY: ame *FS90*            */
/* REVISION: 7.4      LAST MODIFIED: 02/11/95   BY: ljm *G0DZ*            */
/*                                   04/10/96   BY: jzw *G1LD*            */
/* REVISION: 8.6      LAST MODIFIED: 10/14/97   BY: ckm *K0QV*            */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan     */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00 BY: *N0KK* jyn                 */
/* REVISION: 9.1      LAST MODIFIED: 09/21/00 BY: *N0W0* BalbeerS Rajput  */
/* REVISION: 9.0    LAST MODIFIED: 10 NOV 2000 BY: *N0X7* Ed van de Gevel */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.8.1.6.2.3 BY: Ed van de Gevel     DATE: 11/05/01  ECO: *N15M*  */
/* Revision: 1.8.1.10  BY: Orawan S. DATE: 05/03/02 ECO: *P0QW* */
/* $Revision: 1.8.1.12 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00B* */
/*-Revision end---------------------------------------------------------------*/

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

外币的时候转换成原本

[091120.1]

SS - 091120.1 - RNE */

/* SS - 091120.1 - B */
 
{xxapckrp0001.i "new"}

{xxcarap2a.i "new"}

define NEW shared variable ttxxapckrp0001_recno  as recid         no-undo.
define NEW shared variable line_tt1  as INTEGER         no-undo.

DEFINE VARIABLE tot_dr_amt AS DECIMAL.

/* SS - 091120.1 - E */

/*
{mfdtitle.i "2+ "}
*/
{mfdtitle.i "091120.1"}

{cxcustom.i "APCKRP.P"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE apckrp_p_1 "Supplier Type"
/* MaxLen: Comment: */

&SCOPED-DEFINE apckrp_p_2 "Summary/Detail"
/* MaxLen: Comment: */

&SCOPED-DEFINE apckrp_p_3 "Sort by Supplier"
/* MaxLen: Comment: */

&SCOPED-DEFINE apckrp_p_4 "Check"
/* MaxLen: Comment: */

&SCOPED-DEFINE apckrp_p_5 "Print GL Detail"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define new shared variable vend         like ap_vend.
define new shared variable vend1        like ap_vend.
define new shared variable batch        like ap_batch.
define new shared variable batch1       like ap_batch.
define new shared variable apdate       like ap_date.
define new shared variable apdate1      like ap_date.
define new shared variable effdate      like ap_effdate.
define new shared variable effdate1     like ap_effdate.
define new shared variable bank         like ck_bank.
define new shared variable bank1        like ck_bank.
{&APCKRP-P-TAG1}
/*V8-*/
define new shared variable nbr          like ck_nbr.
define new shared variable nbr1         like ck_nbr.
/*V8+*/ /*V8!
define new shared variable nbr          as integer format ">999999"
label {&apckrp_p_4}.
define new shared variable nbr1         as integer format ">999999". */
{&APCKRP-P-TAG2}
define new shared variable entity       like ap_entity.
define new shared variable entity1      like ap_entity.
define new shared variable ckfrm        like ap_ckfrm.
define new shared variable ckfrm1       like ap_ckfrm.
define new shared variable summary      like mfc_logical
   format {&apckrp_p_2} label {&apckrp_p_2}.
define new shared variable gltrans      like mfc_logical initial no
   label {&apckrp_p_5}.
define new shared variable base_rpt     like ap_curr.

define new shared variable vdtype       like vd_type
   label {&apckrp_p_1}.
define new shared variable vdtype1      like vdtype.
define new shared variable sort_by_vend like mfc_logical
   label {&apckrp_p_3}.
define new shared variable duedate      like vo_due_date.
define new shared variable duedate1     like vo_due_date.

/* SS - 091120.1 - B
define new shared variable user1_ap          like ap_user1.
define new shared variable user1_ap1          like ap_user1.
SS - 091120.1 - E */

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

{&APCKRP-P-TAG13}
{&APCKRP-P-TAG3}
{&APCKRP-P-TAG11}
form
   batch          colon 15
   batch1         label {t001.i} colon 49 skip
   nbr            colon 15 format "999999"
   nbr1           label {t001.i} colon 49 format "999999" skip
   /* SS - 091120.1 - B
   user1_ap            colon 15 /* format "999999" */
   user1_ap1           label {t001.i} colon 49 /* format "999999" */ skip
   SS - 091120.1 - E */
   bank           colon 15
   bank1          label {t001.i} colon 49 skip
   ckfrm          colon 15                format "x(1)"
   ckfrm1         label {t001.i} colon 49 format "x(1)" skip
   entity         colon 15
   entity1        label {t001.i} colon 49 skip
   vend           colon 15
   vend1          label {t001.i} colon 49 skip
   vdtype         colon 15
   vdtype1        label {t001.i} colon 49 skip
   apdate         colon 15
   apdate1        label {t001.i} colon 49 skip
   effdate        colon 15
   effdate1       label {t001.i} colon 49
   duedate        colon 15
   duedate1       label {t001.i} colon 49 skip(1)
   /* SS - 091120.1 - B */
   /*
   summary        colon 25
   sort_by_vend   colon 25
   gltrans        colon 25
   */
   /* SS - 091120.1 - E */
   base_rpt       colon 25
with frame a side-labels width 80.
{&APCKRP-P-TAG12}
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
   {&APCKRP-P-TAG14}
   if nbr1     = 999999   then nbr1     = 0.
   {&APCKRP-P-TAG15}
   {&APCKRP-P-TAG4}
   if batch1   = hi_char  then batch1   = "".
   if bank1    = hi_char  then bank1    = "".
   if vend1    = hi_char  then vend1    = "".
   if apdate   = low_date then apdate   = ?.
   if apdate1  = hi_date  then apdate1  = ?.
   if effdate  = low_date then effdate  = ?.
   if effdate1 = hi_date  then effdate1 = ?.
   if duedate  = low_date then duedate  = ?.
   if duedate1 = hi_date  then duedate1 = ?.
   if entity1  = hi_char  then entity1  = "".
   if vdtype1  = hi_char  then vdtype1  = "".
   if ckfrm1   = hi_char  then ckfrm1   = "".
   /* SS - 091120.1 - B
   if user1_ap1   = hi_char  then user1_ap1   = "".
   SS - 091120.1 - E */

   /* SS - 091120.1 - B */
   /*
   if c-application-mode <> 'web' then
   {&APCKRP-P-TAG5}
   update batch batch1
      nbr nbr1
      bank bank1
      ckfrm ckfrm1
      entity entity1
      vend vend1
      vdtype vdtype1
      apdate apdate1
      effdate effdate1
      duedate duedate1
      summary
      sort_by_vend
      gltrans
      {&APCKRP-P-TAG16}
      base_rpt with frame a.

   {&APCKRP-P-TAG6}
   {&APCKRP-P-TAG17}
   {wbrp06.i &command = update &fields = "  batch batch1 nbr nbr1 bank bank1
        ckfrm ckfrm1 entity entity1 vend vend1 vdtype vdtype1 apdate apdate1 effdate effdate1
        duedate duedate1 summary  sort_by_vend gltrans base_rpt" &frm = "a"}
  */
   if c-application-mode <> 'web' then
   {&APCKRP-P-TAG5}
   update batch batch1
      nbr nbr1
      /* SS - 091120.1 - B
      user1_ap
      user1_ap1
      SS - 091120.1 - E */
      bank bank1
      ckfrm ckfrm1
      entity entity1
      vend vend1
      vdtype vdtype1
      apdate apdate1
      effdate effdate1
      duedate duedate1
      base_rpt with frame a.

   {&APCKRP-P-TAG6}
   {&APCKRP-P-TAG17}
   {wbrp06.i &command = update &fields = "  batch batch1 nbr nbr1 bank bank1
      /* SS - 091120.1 - B
      user1_ap
      user1_ap1
      SS - 091120.1 - E */
        ckfrm ckfrm1 entity entity1 vend vend1 vdtype vdtype1 apdate apdate1 effdate effdate1
        duedate duedate1 base_rpt" &frm = "a"}
   /* SS - 091120.1 - E */

   {&APCKRP-P-TAG18}
   {&APCKRP-P-TAG10}
   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      {&APCKRP-P-TAG19}
      bcdparm = "".
      {mfquoter.i batch}
      {mfquoter.i batch1}
      {mfquoter.i nbr}
      {mfquoter.i nbr1}
      {mfquoter.i bank}
      {mfquoter.i bank1}
      {mfquoter.i ckfrm  }
      {mfquoter.i ckfrm1  }
      {mfquoter.i entity}
      {mfquoter.i entity1}
      {mfquoter.i vend}
      {mfquoter.i vend1}
      {mfquoter.i vdtype  }
      {mfquoter.i vdtype1  }
      {mfquoter.i apdate}
      {mfquoter.i apdate1}
      {mfquoter.i effdate}
      {mfquoter.i effdate1}
      {mfquoter.i duedate}
      {mfquoter.i duedate1}
      {&APCKRP-P-TAG7}
      {mfquoter.i summary}
      {mfquoter.i sort_by_vend}
      {mfquoter.i gltrans}
      {mfquoter.i base_rpt}
      /* SS - 091120.1 - B
      {mfquoter.i user1_ap}
      {mfquoter.i user1_ap1}
      SS - 091120.1 - E */
      {&APCKRP-P-TAG20}
      {&APCKRP-P-TAG8}

      {&APCKRP-P-TAG21}
      if nbr1 = 0     then nbr1     = 999999.
      {&APCKRP-P-TAG22}
      {&APCKRP-P-TAG9}
      if batch1 = ""  then batch1   = hi_char.
      if bank1 = ""   then bank1    = hi_char.
      if vend1 = ""   then vend1    = hi_char.
      if apdate = ?   then apdate   = low_date.
      if apdate1 = ?  then apdate1  = hi_date.
      if effdate = ?  then effdate  = low_date.
      if effdate1 = ? then effdate1 = hi_date.
      if duedate = ?  then duedate  = low_date.
      if duedate1 = ? then duedate1 = hi_date.
      if entity1 = "" then entity1  = hi_char.
      if vdtype1 = "" then vdtype1  = hi_char.
      if ckfrm1 = ""  then ckfrm1   = hi_char.
      /* SS - 091120.1 - B
      if user1_ap1 = ""  then user1_ap1   = hi_char.
      SS - 091120.1 - E */

   end.

   {xxSoftspeedLic.i "SoftspeedCAR.lic" "SoftspeedCAR"}

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
   /* SS - 091120.1 - B */
   /*
   {&APCKRP-P-TAG23}
   {mfphead.i}
   {&APCKRP-P-TAG24}

   /* DELETE GL WORKFILE ENTRIES */
   if gltrans = yes then do:

      for each gltw_wkfl exclusive-lock
             where gltw_userid =
             mfguser:
         delete gltw_wkfl.
      end.
   end.

   if sort_by_vend then do:
      {gprun.i ""apckrpb.p""}
   end.
   else do:
      {gprun.i ""apckrpa.p""}
   end.

   /* PRINT GL DISTRIBUTION */
   if gltrans then do:
      page.
      {gprun.i ""gpglrp.p""}
   end.
   /* REPORT TRAILER */
   {mfrtrail.i}
   */
   /* 输出到BI */
   PUT UNFORMATTED "#def REPORTPATH=$/QAD Addons/BI Report/" + SUBSTRING(execname, 1, LENGTH(execname) - 2) SKIP.
   PUT UNFORMATTED "#def :end" SKIP.

   EMPTY TEMP-TABLE ttxxapckrp0001.
   EMPTY TEMP-TABLE ttxxapckrp0001a.

   {gprun.i ""xxapckrp0001.p"" "(
      input batch        ,
      input batch1       ,
      input nbr          ,
      input nbr1         ,
      input bank         ,
      input bank1        ,
      input ckfrm        ,
      input ckfrm1       ,
      input entity       ,
      input entity1      ,
      input vend         ,
      input vend1        ,
      input vdtype       ,
      input vdtype1      ,
      input apdate       ,
      input apdate1      ,
      input effdate      ,
      input effdate1     ,
      input duedate      ,
      input duedate1     ,
      input base_rpt     
      )"}

   tot_dr_amt = 0.
   LINE_tt1 = 0.
   EMPTY TEMP-TABLE tt1.
   EMPTY TEMP-TABLE tt2.
   FOR EACH ttxxapckrp0001
      ,EACH ac_mstr NO-LOCK
      WHERE ac_code = ttxxapckrp0001_ckd_acct
      AND INDEX("ALIE",ac_type) > 0
      ,EACH sb_mstr NO-LOCK
      WHERE sb_sub = ttxxapckrp0001_ckd_sub
      ,EACH cc_mstr NO-LOCK
      WHERE cc_ctr = ttxxapckrp0001_ckd_cc
      /*
      ,EACH pj_mstr NO-LOCK
      WHERE pj_proj = ttxxapckrp0001_ckd_project
      */
      BREAK BY ttxxapckrp0001_ck_ref 
      :
      LINE_tt1 = LINE_tt1 + 1.

      /* line */
      CREATE tt1.
      ASSIGN
         tt1_ref = ttxxapckrp0001_ck_ref
         tt1_line = LINE_tt1
         tt1_effdate = STRING(YEAR(ttxxapckrp0001_ap_effdate)) + "." +  STRING(MONTH(ttxxapckrp0001_ap_effdate)) + "." +  STRING(DAY(ttxxapckrp0001_ap_effdate))
         tt1_desc = ttxxapckrp0001_ckd_type + ttxxapckrp0001_ckd_voucher
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
         tt1_dr_amt = ttxxapckrp0001_base_ckd_amt + ttxxapckrp0001_base_disc
         .
      tot_dr_amt = tot_dr_amt + tt1_dr_amt.
            
      IF ac_curr <> base_curr THEN DO:
         ASSIGN
            /* SS - 091120.1 - B
            tt1_curramt = ABS(ttxxapckrp0001_ckd_amt + ttxxapckrp0001_ckd_disc)
            SS - 091120.1 - E */
            /* SS - 091120.1 - B */
            tt1_curramt = ABS((ttxxapckrp0001_ckd_amt + ttxxapckrp0001_ckd_disc )* ttxxapckrp0001_ap_ex_rate / ttxxapckrp0001_ap_ex_rate2)
            /* SS - 091120.1 - E */
            tt1_ex_rate = ac_curr + "汇" + STRING(ttxxapckrp0001_ap_ex_rate2 / ttxxapckrp0001_ap_ex_rate ) 
            .
   
         /* SS - 091120.1 - B */
         /* 凭证兑换率 */
         IF UPPER(ttxxapckrp0001_ckd_type) = "VO" THEN DO:
            FIND FIRST ap_mstr
               WHERE ap_type = "VO"
               AND ap_ref = ttxxapckrp0001_ckd_voucher
               NO-LOCK NO-ERROR.
            IF AVAILABLE ap_mstr THEN DO:
               ASSIGN
                  tt1_ex_rate = ac_curr + "汇" + STRING(ap_ex_rate2 / ap_ex_rate ) 
                  /* SS - 091120.1 - B */
                  tt1_curramt = ABS(ap_amt)
                  /* SS - 091120.1 - E */

                  .
            END.
         END.
         /* SS - 091120.1 - E */
      END.

      IF ttxxapckrp0001_base_disc <> 0 THEN DO:
         ttxxapckrp0001_recno = RECID(ttxxapckrp0001).
         LINE_tt1 = line_tt1 + 1.
         {gprun.i ""xxcarap2b.p""}
      END.

      /* ref */
      IF LAST-OF(ttxxapckrp0001_ck_ref) THEN DO:
         ttxxapckrp0001_recno = RECID(ttxxapckrp0001).

         /* SS - 091120.1 - B */
         /* 兑换损益 */
         /* SS - 091120.1 - B
         LINE_tt1 = line_tt1 + 1.
         SS - 091120.1 - E */
         {gprun.i ""xxcarap2c.p"" "(
            INPUT-OUTPUT tot_dr_amt
            )"}
         /* SS - 091120.1 - E */

         /* SS - 091120.1 - B
         LINE_tt1 = line_tt1 + 1.
         SS - 091120.1 - E */
         {gprun.i ""xxcarap2a.p""}

         CREATE tt2.
         ASSIGN 
            tt2_ref = ttxxapckrp0001_ck_ref
            tt2_decimal1 = ABS(tot_dr_amt)
            tt2_effdate = STRING(YEAR(ttxxapckrp0001_ap_effdate)) + "." +  STRING(MONTH(ttxxapckrp0001_ap_effdate)) + "." +  STRING(DAY(ttxxapckrp0001_ap_effdate))
            tt2_cp_desc = NAME_reports
            tt2_as_desc = "由 " + name_usr + " 打印 " + "(日期: " + string(year(today)) + "." + string(month(today)) + "." + string(day(today)) + ", " + "时间: " + STRING(TIME,"HH:MM:SS") + ")" 
            /* 6 - 供应商 */
            tt2_ex_rate = "供应商: " + ttxxapckrp0001_ap_vend + " " + ttxxapckrp0001_name
            /* 7 - 批处理 */
            tt2_char1 = "批处理: " + ttxxapckrp0001_ap_batch
            .

         {gprun.i ""xxcaren.p"" "(
            INPUT ttxxapckrp0001_ap_entity,
            INPUT-OUTPUT tt2_cp_desc
            )"}

         /* 8 - 银行 */
         FIND FIRST bk_mstr WHERE bk_code = ttxxapckrp0001_ck_bank NO-LOCK NO-ERROR.
         IF AVAILABLE bk_mstr THEN DO:
            ASSIGN
               tt2_user2 = "银行: " + string(ttxxapckrp0001_ck_bank) + " " + bk_desc
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
      END. /* IF LAST-OF(ttxxapckrp0001_ck_ref) THEN DO: */
   END. /* for each vo_hist */

   /* SS - 091120.1 - B
   /* 更新了支票 */
   FOR EACH tt2:
      FIND FIRST ap_mstr 
         WHERE ap_type = 'CK'
         AND ap_ref = tt2_ref
         NO-LOCK NO-ERROR.
      IF AVAILABLE ap_mstr AND ap_user1 <> "" THEN DO:
         ASSIGN
            tt2_ref = ap_user1
            .
         /* SS - 091120.1 - B
         IF NOT (tt2_ref >= user1_ap AND tt2_ref <= user1_ap1) THEN DO:
            DELETE tt2.
         END.
         SS - 091120.1 - E */
      END.
   END.

   FOR EACH tt1:
      FIND FIRST ap_mstr 
         WHERE ap_type = 'CK'
         AND ap_ref = tt1_ref
         NO-LOCK NO-ERROR.
      IF AVAILABLE ap_mstr AND ap_user1 <> "" THEN DO:
         ASSIGN
            tt1_ref = ap_user1
            .
         /* SS - 091120.1 - B
         IF NOT (tt1_ref >= user1_ap AND tt1_ref <= user1_ap1) THEN DO:
            DELETE tt1.
         END.
         SS - 091120.1 - E */
      END.
   END.
   SS - 091120.1 - E */

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

end.

{wbrp04.i &frame-spec = a}


