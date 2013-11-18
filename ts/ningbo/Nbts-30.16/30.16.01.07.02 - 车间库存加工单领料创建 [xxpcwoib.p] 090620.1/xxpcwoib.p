/* glcalrp.p - GENERAL LEDGER CALENDAR REPORT                           */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.9 $                                                     */
/*V8:ConvertMode=FullGUIReport                                          */
/* REVISION: 1.0      LAST MODIFIED: 09/18/86   BY: JMS                 */
/*                                   01/29/88   by: jms                 */
/*                                   02/24/88   by: jms                 */
/* REVISION: 4.0      LAST MODIFIED: 02/29/88   BY: WUG  *A175*         */
/* REVISION: 5.0      LAST MODIFIED: 06/22/89   BY: JMS  *B066*         */
/* REVISION: 6.0      LAST MODIFIED: 07/03/90   by: jms  *D034*         */
/* REVISION: 7.0      LAST MODIFIED: 10/04/91   by: jms  *F058*         */
/* REVISION: 7.4      LAST MODIFIED: 07/20/93   by: pcd  *H040*         */
/*                                   09/03/94   by: srk  *FQ80*         */
/* REVISION: 8.6      LAST MODIFIED: 10/11/97   BY: ays  *K0TT*         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* Revision: 1.7  BY: Katie Hilbert DATE: 08/03/01 ECO: *P01C* */
/* $Revision: 1.9 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 090620.1 By: Bill Jiang */

/* SS - 090620.1 - RNB
[090620.1]

库存事务历史记录文件 - 数量:                                       
   1.发放原则为否(pt_iss_pol = no)
   2.事务类型的转换: ISS-UNP => ISS-WO
   3.非车间库存可使用其他事务类型,例如数量为负的计划外入库(RCT-UNP)
   4.异常记录: 加工单车间库存物料清单历史记录不存在,无法分配和转换
   5.异常标识: charfld[1] = FS(Floor Stock)

加工单领料历史记录文件:
   1.创建或追加车间库存加工单领料历史记录
   2.与<库存事务历史记录文件 - 数量>.[事务类型]的转换同步进行

错误:总账日历没维护,总账日历已结,上期未结,本期已结!

警告:记录已经存在,是否继续?

[090620.1]

SS - 090620.1 - RNE */

/* DISPLAY TITLE */
{mfdtitle.i "090620.1"}

define variable per like glc_per.
define variable yr like glc_year.
define variable entity like glcd_entity.

DEFINE VARIABLE date1 AS DATE.
define variable l_yn        like mfc_logical             no-undo.

define variable part like tr_part.
define variable part1 like tr_part.
define variable nbr like tr_nbr.
define variable nbr1 like tr_nbr.
define variable so_job like tr_so_job.
define variable so_job1 like tr_so_job.
define variable lot like tr_lot.
define variable lot1 like tr_lot.
define variable loc like tr_loc.
define variable loc1 like tr_loc.
define variable efdate like tr_effdate.
define variable efdate1 like tr_date.
define variable glref  like trgl_gl_ref.
define variable glref1 like trgl_gl_ref.
/*
define variable entity like en_entity.
*/
define variable entity1 like en_entity.
define variable acct like glt_acct.
define variable acct1 like glt_acct.
define variable sub like glt_sub.
define variable sub1 like glt_sub.
define variable cc like glt_cc.
define variable cc1 like glt_cc.
define variable proj like glt_project.
define variable proj1 like glt_project.
define variable trdate like tr_date.
define variable trdate1 like tr_date.
define variable trtype like tr_type.

DEFINE VARIABLE qty_tot_xxpcwod LIKE xxpcwod_qty_tot.
DEFINE VARIABLE qty_acc_xxpcwod LIKE xxpcwod_qty_tot.

ASSIGN
   glref = "IC"
   glref1 = "ID"
   trtype = "ISS-WO"
   .

{glcabmeg.i} /* module closing engine include. */

/* SELECT FORM */
form
   entity colon 20    
   en_name NO-LABEL
   yr     colon 20    
   per     colon 20    
   skip
with frame a side-labels attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

date1 = DATE(MONTH(TODAY),1,YEAR(TODAY)) - 1.
FIND FIRST glc_cal 
   WHERE glc_domain = GLOBAL_domain
   AND glc_start <= date1
   AND glc_end >= date1
   NO-LOCK NO-ERROR.
IF AVAILABLE glc_cal THEN DO:
   yr = glc_year.
   per = glc_per.
END.

{wbrp01.i}

/* REPORT BLOCK */
mainloop:
repeat:
   if c-application-mode <> 'web' then
      update
         entity 
         yr 
         per
      with frame a.

   {wbrp06.i &command = update &fields = "  entity yr per" &frm = "a"}
      
   FIND FIRST en_mstr 
      WHERE en_domain = GLOBAL_domain
      AND en_entity = entity
      NO-LOCK NO-ERROR.
   IF AVAILABLE en_mstr THEN DO:
      DISPLAY
         en_name
         WITH FRAME a.
   END.
   ELSE DO:
      DISPLAY
         "" @ en_name
         WITH FRAME a.
   END.

   {gprun.i ""xxpcprhcv.p"" "(
      INPUT entity,
      INPUT yr,
      INPUT per,
      INPUT-OUTPUT efdate,
      INPUT-OUTPUT efdate1
      )"}
   IF RETURN-VALUE = "no" THEN DO:
      UNDO,RETRY.
   END.

   /* 已经创建 */
   FOR EACH en_mstr NO-LOCK
      WHERE en_domain = GLOBAL_domain
      AND en_entity = entity
      ,EACH si_mstr NO-LOCK
      WHERE si_domain = GLOBAL_domain
      AND si_entity = en_entity
      ,EACH xxpcwod_hist NO-LOCK
      WHERE xxpcwod_domain = GLOBAL_domain
      AND xxpcwod_site = si_site
      AND xxpcwod_year = yr
      AND xxpcwod_per = per
      AND xxpcwod_qty_iss <> 0
      :
      /* 301606 - 记录已经存在.是否继续? */
      {pxmsg.i &MSGNUM=301606 &ERRORLEVEL=2 &CONFIRM=l_yn}

      if not l_yn then do:
         next-prompt per.
         UNDO mainloop, retry.
      end. /* IF NOT l_yn */

      LEAVE.
   END.

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      /* CREATE BATCH INPUT STRING */
      bcdparm = "".
      {mfquoter.i entity }
      {mfquoter.i yr     }
      {mfquoter.i per     }
   end.

   {xxSoftspeedLic.i "SoftspeedPC.lic" "SoftspeedPC"}

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 80
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

   DO TRANSACTION ON STOP UNDO:
      /* 删除已有的数据 */
      FOR EACH si_mstr NO-LOCK
         WHERE si_domain = GLOBAL_domain
         AND si_entity = entity
         ,EACH xxpcwod_hist EXCLUSIVE-LOCK
         WHERE xxpcwod_domain = GLOBAL_domain
         AND xxpcwod_site = si_site
         AND xxpcwod_year = yr
         AND xxpcwod_per = per
         :

         FOR EACH xxpcwoi_hist EXCLUSIVE-LOCK
            WHERE xxpcwoi_domain = GLOBAL_domain
            AND xxpcwoi_site = xxpcwod_site
            AND xxpcwoi_year = yr
            AND xxpcwoi_per = per
            AND xxpcwoi_par = xxpcwod_par
            AND xxpcwoi_lot = xxpcwod_lot
            AND xxpcwoi_comp = xxpcwod_comp
            :
            ASSIGN
               xxpcwoi_qty = xxpcwoi_qty - xxpcwod_qty_iss
               .
         END.

         ASSIGN
            xxpcwod_qty_iss = 0
            xxpcwod_cst_iss = 0
            .
      END.

      /* 写入xxpcwod,xxpctr */
      FOR EACH si_mstr NO-LOCK
         WHERE si_domain = GLOBAL_domain
         AND si_entity = entity
         ,EACH xxpctr_hist EXCLUSIVE-LOCK
         WHERE xxpctr_domain = GLOBAL_domain
         AND xxpctr_site = si_site
         AND xxpctr_year = yr
         AND xxpctr_per = per
         AND xxpctr_type = "ISS-UNP"
         ,EACH pt_mstr NO-LOCK
         WHERE pt_domain = GLOBAL_domain
         AND pt_part = xxpctr_part
         AND pt_iss_pol = NO
         :
         IF xxpctr_qty = 0 THEN DO:
            NEXT.
         END.

         qty_tot_xxpcwod = 0.
         FOR EACH xxpcwod_hist NO-LOCK
            WHERE xxpcwod_domain = GLOBAL_domain
            AND xxpcwod_site = si_site
            AND xxpcwod_year = yr
            AND xxpcwod_per = per
            AND xxpcwod_comp = xxpctr_part
            :
            qty_tot_xxpcwod = qty_tot_xxpcwod + xxpcwod_qty_tot.
         END.

         IF qty_tot_xxpcwod = 0 THEN DO:
            ASSIGN
               xxpctr_charfld[1] = "FS"
               .

            NEXT.
         END.

         /* xxpcwod */
         qty_acc_xxpcwod = 0.
         FOR EACH xxpcwod_hist EXCLUSIVE-LOCK
            WHERE xxpcwod_domain = GLOBAL_domain
            AND xxpcwod_site = si_site
            AND xxpcwod_year = yr
            AND xxpcwod_per = per
            AND xxpcwod_comp = xxpctr_part
            BREAK
            BY xxpcwod_comp
            :

            IF LAST-OF(xxpcwod_comp) THEN DO:
               ASSIGN
                  xxpcwod_qty_iss = xxpctr_qty - qty_acc_xxpcwod
                  .
            END.
            ELSE DO:
               ASSIGN
                  xxpcwod_qty_iss = xxpctr_qty * xxpcwod_qty_tot / qty_tot_xxpcwod
                  qty_acc_xxpcwod = qty_acc_xxpcwod + xxpcwod_qty_iss
                  .
            END.
            ASSIGN
               xxpcwod_cst_iss = xxpcwod_qty_iss * xxpcwod_cst
               .
         END.

         /* xxpctr */
         ASSIGN
            xxpctr_type = "ISS-WO"
            xxpctr_charfld[1] = "FS"
            .
      END. /* FOR EACH si_mstr NO-LOCK */

      /* 写入xxpcwoi */
      FOR EACH si_mstr NO-LOCK
         WHERE si_domain = GLOBAL_domain
         AND si_entity = entity
         ,EACH xxpcwod_hist EXCLUSIVE-LOCK
         WHERE xxpcwod_domain = GLOBAL_domain
         AND xxpcwod_site = si_site
         AND xxpcwod_year = yr
         AND xxpcwod_per = per
         :

         FIND FIRST xxpcwoi_hist 
            WHERE xxpcwoi_domain = GLOBAL_domain
            AND xxpcwoi_site = xxpcwod_site
            AND xxpcwoi_year = yr
            AND xxpcwoi_per = per
            AND xxpcwoi_par = xxpcwod_par
            AND xxpcwoi_lot = xxpcwod_lot
            AND xxpcwoi_comp = xxpcwod_comp
            EXCLUSIVE-LOCK NO-ERROR.
         IF NOT AVAILABLE xxpcwoi_hist THEN DO:
            CREATE xxpcwoi_hist.
            ASSIGN
               xxpcwoi_domain = GLOBAL_domain
               xxpcwoi_site = xxpcwod_site
               xxpcwoi_year = yr
               xxpcwoi_per = per
               xxpcwoi_par = xxpcwod_par
               xxpcwoi_lot = xxpcwod_lot
               xxpcwoi_comp = xxpcwod_comp
               .
         END.
         ASSIGN
            xxpcwoi_qty = xxpcwoi_qty + xxpcwod_qty_iss
            .
      END.
   END. /* DO TRANSACTION ON STOP UNDO: */

   PUT UNFORMATTED "#def REPORTPATH=$/QAD Addons/BI Report/" + SUBSTRING(execname, 1, LENGTH(execname) - 2) SKIP.
   PUT UNFORMATTED "#def :end" SKIP.

   EXPORT DELIMITER ";" 
      "地点"
      "年份"
      "期间"
      "父件"
      "父名"
      "工单"
      "子件"
      "标准单量"
      "标准单成"
      "标准总量"
      "标准总成"
      "领料总量"
      "领料总成"
      .
   FOR EACH en_mstr NO-LOCK
      WHERE en_domain = GLOBAL_domain
      AND en_entity = entity
      ,EACH si_mstr NO-LOCK
      WHERE si_domain = GLOBAL_domain
      AND si_entity = en_entity
      ,EACH xxpcwod_hist NO-LOCK
      WHERE xxpcwod_domain = GLOBAL_domain
      AND xxpcwod_site = si_site
      AND xxpcwod_year = yr
      AND xxpcwod_per = per
      ,EACH pt_mstr NO-LOCK
      WHERE pt_domain = GLOBAL_domain
      AND pt_part = xxpcwod_par
      BY xxpcwod_site
      BY xxpcwod_year
      BY xxpcwod_per
      BY xxpcwod_par
      BY xxpcwod_lot
      BY xxpcwod_comp
      :
      EXPORT DELIMITER ";"
         xxpcwod_site
         xxpcwod_year
         xxpcwod_per
         xxpcwod_par
         (pt_desc1 + " " + pt_desc2)
         xxpcwod_lot
         xxpcwod_comp
         xxpcwod_qty
         xxpcwod_cst
         xxpcwod_qty_tot
         xxpcwod_cst_tot
         xxpcwod_qty_iss
         xxpcwod_cst_iss
         .
   END.
   
   {xxmfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
