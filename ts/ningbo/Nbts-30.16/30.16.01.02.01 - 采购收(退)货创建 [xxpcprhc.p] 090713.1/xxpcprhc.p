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

/* SS - 090713.1 By: Bill Jiang */

/* SS - 090713.1 - RNB
[090713.1]

1.限库存(tr_ship_type="")事务类型:RCT-PO,ISS-PRV
2.计算成本,不可设置

错误:总账日历没维护,总账日历已结,上期未结,本期已结!

警告:记录已经存在,是否继续?

[090713.1]

SS - 090713.1 - RNE */

/* DISPLAY TITLE */
{mfdtitle.i "090713.1"}

{xxpoporp0601.i "new"}

define variable per like glc_per.
define variable yr like glc_year.
define variable entity like glcd_entity.

DEFINE VARIABLE date1 AS DATE.
define variable l_yn        like mfc_logical             no-undo.
DEFINE VARIABLE TYPE_xxpcprh LIKE xxpcprh_type.

define variable rdate           like prh_rcp_date.
define variable rdate1          like prh_rcp_date.
define variable vendor          like po_vend.
define variable vendor1         like po_vend.
define variable part            like pt_part.
define variable part1           like pt_part.
define variable site            like pt_site.
define variable site1           like pt_site.
define variable pj              like prj_nbr.
define variable pj1             like prj_nbr.
define variable fr_ps_nbr       like prh_ps_nbr .
define variable to_ps_nbr       like prh_ps_nbr .
define variable sel_inv         like mfc_logical.
define variable sel_sub         like mfc_logical.
define variable ers-only         like mfc_logical.
define variable sel_mem         like mfc_logical.
define variable uninv_only      like mfc_logical.
define variable supplier_consign as   character.
define variable use_tot         like mfc_logical.
define variable show_sub        like mfc_logical.
define variable base_rpt        like po_curr.
define variable l_inc_log     LIKE mfc_logical.

DEFINE VARIABLE site_xxpcprh LIKE xxpcprh_site.

ASSIGN
   sel_inv = YES
   sel_sub = NO
   ers-only = NO
   sel_mem = NO
   uninv_only = NO
   supplier_consign = "Exclude"
   USE_tot = NO
   show_sub = NO
   base_rpt = ""
   l_inc_log = NO
   .

{glcabmeg.i} /* module closing engine include. */

/* SELECT FORM */
form
   /*
   entity colon 20    
   en_name NO-LABEL
   */
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
         /*
         entity 
         */
         yr 
         per
      with frame a.

   {wbrp06.i &command = update &fields = "  
      /*
      entity 
      */
      yr per" &frm = "a"}
      
   /*
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
   */

   FOR EACH en_mstr NO-LOCK
      WHERE en_domain = GLOBAL_domain
      :
      {gprun.i ""xxpcprhcv.p"" "(
         INPUT en_entity,
         INPUT yr,
         INPUT per,
         INPUT-OUTPUT rdate,
         INPUT-OUTPUT rdate1
         )"}
      IF RETURN-VALUE = "no" THEN DO:
         UNDO,RETRY.
      END.
   END.

   /* 已经创建 */
   FOR EACH en_mstr NO-LOCK
      WHERE en_domain = GLOBAL_domain
      /*
      AND en_entity = entity
      */
      ,EACH si_mstr NO-LOCK
      WHERE si_domain = GLOBAL_domain
      AND si_entity = en_entity
      ,EACH xxpcprh_hist NO-LOCK
      WHERE xxpcprh_domain = GLOBAL_domain
      AND xxpcprh_site = si_site
      AND xxpcprh_year = yr
      AND xxpcprh_per = per
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

   EMPTY TEMP-TABLE ttxxpoporp0601.
   {gprun.i ""xxpoporp0601.p"" "(
      INPUT rdate,
      INPUT rdate1,
      INPUT vendor,
      INPUT vendor1,
      INPUT part,
      INPUT part1,
      INPUT site,
      INPUT site1,
      INPUT pj,
      INPUT pj1,
      INPUT fr_ps_nbr,
      INPUT TO_ps_nbr,
      INPUT sel_inv,
      INPUT sel_sub,
      INPUT ers-only,
      INPUT sel_mem,
      INPUT uninv_only,
      INPUT supplier_consign,
      INPUT USE_tot,
      INPUT show_sub,
      INPUT base_rpt,
      INPUT l_inc_log
      )"}

   DO TRANSACTION ON STOP UNDO:
      /* 删除已有的数据 */
      FOR EACH xxpcprh_hist EXCLUSIVE-LOCK
         WHERE xxpcprh_domain = GLOBAL_domain
         /*
         AND xxpcprh_site = si_site
         */
         AND xxpcprh_year = yr
         AND xxpcprh_per = per
         :
         DELETE xxpcprh.
      END.

      /* 写入 */
      FOR EACH ttxxpoporp0601
         ,EACH prh_hist NO-LOCK
         WHERE prh_domain = GLOBAL_domain
         AND prh_receiver = ttxxpoporp0601_prh_receiver
         AND prh_line = ttxxpoporp0601_prh_line
         BREAK
         BY prh_po_site
         BY ttxxpoporp0601_prh_part
         BY ttxxpoporp0601_prh_vend
         BY ttxxpoporp0601_prh_rcp_type
         :
         ACCUMULATE ttxxpoporp0601_qty_open (TOTAL BY prh_po_site BY ttxxpoporp0601_prh_part BY ttxxpoporp0601_prh_vend BY ttxxpoporp0601_prh_rcp_type).
         ACCUMULATE ttxxpoporp0601_pur_ext (TOTAL BY prh_po_site BY ttxxpoporp0601_prh_part BY ttxxpoporp0601_prh_vend BY ttxxpoporp0601_prh_rcp_type).

         IF LAST-OF(ttxxpoporp0601_prh_rcp_type) THEN DO:
            IF ttxxpoporp0601_prh_rcp_type = "" THEN DO:
               type_xxpcprh = "RCT-PO".
            END.
            ELSE DO:
               type_xxpcprh = "ISS-PRV".
            END.

            /*
            FIND FIRST xxpcprh_hist
               WHERE xxpcprh_domain = GLOBAL_domain
               AND xxpcprh_site = prh_po_site
               AND xxpcprh_year = yr
               AND xxpcprh_per = per
               AND xxpcprh_part = ttxxpoporp0601_prh_part
               AND xxpcprh_vend = ttxxpoporp0601_prh_vend
               AND xxpcprh_type = type_xxpcprh
               EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE xxpcprh_hist THEN DO:
            */
            CREATE xxpcprh_hist.
            ASSIGN
               xxpcprh_domain = GLOBAL_domain
               xxpcprh_site = prh_po_site
               xxpcprh_year = yr
               xxpcprh_per = per
               xxpcprh_part = ttxxpoporp0601_prh_part
               xxpcprh_vend = ttxxpoporp0601_prh_vend
               xxpcprh_type = TYPE_xxpcprh
               .
            /*
            END.
            */

            ASSIGN
               xxpcprh_qty = (ACCUMULATE TOTAL BY ttxxpoporp0601_prh_rcp_type ttxxpoporp0601_qty_open)
               xxpcprh_mtl_tot = (ACCUMULATE TOTAL BY ttxxpoporp0601_prh_rcp_type ttxxpoporp0601_pur_ext)
               .
         END. /* IF LAST-OF(ttxxpoporp0601_prh_rcp_type) THEN DO: */
      END. /* FOR EACH ttxxpoporp0601 */
   END. /* DO TRANSACTION ON STOP UNDO: */

   PUT UNFORMATTED "#def REPORTPATH=$/QAD Addons/BI Report/" + SUBSTRING(execname, 1, LENGTH(execname) - 2) SKIP.
   PUT UNFORMATTED "#def :end" SKIP.

   EXPORT DELIMITER ";" 
      "地点"
      "年份"
      "期间"
      "零件代码"
      "零件说明"
      "供应商"
      "类型"
      "数量"
      "总料"
      .
   FOR EACH en_mstr NO-LOCK
      WHERE en_domain = GLOBAL_domain
      /*
      AND en_entity = entity
      */
      ,EACH si_mstr NO-LOCK
      WHERE si_domain = GLOBAL_domain
      AND si_entity = en_entity
      ,EACH xxpcprh_hist NO-LOCK
      WHERE xxpcprh_domain = GLOBAL_domain
      AND xxpcprh_site = si_site
      AND xxpcprh_year = yr
      AND xxpcprh_per = per
      ,EACH pt_mstr NO-LOCK
      WHERE pt_domain = GLOBAL_domain
      AND pt_part = xxpcprh_part
      BY xxpcprh_site
      BY xxpcprh_year
      BY xxpcprh_per
      BY xxpcprh_part
      BY xxpcprh_vend
      BY xxpcprh_type
      :
      EXPORT DELIMITER ";"
         xxpcprh_site
         xxpcprh_year
         xxpcprh_per
         xxpcprh_part
         (pt_desc1 + " " + pt_desc2)
         xxpcprh_vend
         xxpcprh_type
         xxpcprh_qty
         xxpcprh_mtl_tot
         .
   END.
   
   {xxmfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
