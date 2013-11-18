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

/* SS - 091111.1 By: Bill Jiang */

/* SS - 091111.1 - RNB
[091111.1]

使用了以下保留字段:
  - decfld[1]
  - last_date
  - last_time
  - last_userid
  - last_program

[091111.1]

SS - 091111.1 - RNE */

/* DISPLAY TITLE */
{mfdtitle.i "091111.1"}

define variable per like glc_per.
define variable yr like glc_year.
define variable entity like glcd_entity.
DEFINE VARIABLE date1 AS DATE.
define variable per1 like glc_per.
define variable yr1 like glc_year.
DEFINE VARIABLE find-can AS LOGICAL.
define variable l_yn        like mfc_logical             no-undo.

DEFINE VARIABLE qty_xxpcinb LIKE xxpcinb_qty.

DEFINE TEMP-TABLE tt1
   FIELD tt1_site LIKE tr_site
   FIELD tt1_part LIKE tr_part
   FIELD tt1_qty LIKE tr_qty_loc
   INDEX index1 tt1_site tt1_part
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

   {xxSoftspeedLic.i "SoftspeedPC.lic" "SoftspeedPC"}

   {gprun.i ""xxpcinbda.p"" "(
      INPUT entity,
      INPUT yr,
      INPUT per,
      INPUT-OUTPUT yr1,
      INPUT-OUTPUT per1
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
      ,EACH xxpcinb_mstr NO-LOCK
      WHERE xxpcinb_domain = GLOBAL_domain
      AND xxpcinb_site = si_site
      AND xxpcinb_year = yr
      AND xxpcinb_per = per
      :
      /* 301606 - 记录已经存在.是否继续? */
      {pxmsg.i &MSGNUM=301606 &ERRORLEVEL=2 &CONFIRM=l_yn}

      if not l_yn then do:
         next-prompt per.
         UNDO mainloop, retry.
      end. /* IF NOT l_yn */

      LEAVE.
   END.

   DO TRANSACTION ON STOP UNDO:
      /* 清除 */
      /*
      FOR EACH en_mstr NO-LOCK
         WHERE en_domain = GLOBAL_domain
         AND en_entity = entity
         ,EACH si_mstr NO-LOCK
         WHERE si_domain = GLOBAL_domain
         AND si_entity = en_entity
         ,EACH xxpcinb_mstr EXCLUSIVE-LOCK
         WHERE xxpcinb_domain = GLOBAL_domain
         AND xxpcinb_site = si_site
         AND xxpcinb_year = yr
         AND xxpcinb_per = per
         :
         DELETE xxpcinb_mstr.
      END.
      */

      /* 更新或创建 */
      /* 上期期间 */
      FOR EACH tt1:
         DELETE tt1.
      END.
      FOR EACH en_mstr NO-LOCK
         WHERE en_domain = GLOBAL_domain
         AND en_entity = entity
         ,EACH si_mstr NO-LOCK
         WHERE si_domain = GLOBAL_domain
         AND si_entity = en_entity
         ,EACH xxpctr_hist NO-LOCK
         WHERE xxpctr_domain = GLOBAL_domain
         AND xxpctr_site = si_site
         AND xxpctr_year = yr1
         AND xxpctr_per = per1
         BREAK
         BY xxpctr_site
         BY xxpctr_part
         :
         ACCUMULATE xxpctr_qty (TOTAL BY xxpctr_site BY xxpctr_part).
         IF LAST-OF(xxpctr_part) THEN DO:
            qty_xxpcinb = (ACCUMULATE TOTAL BY xxpctr_part xxpctr_qty).

            IF qty_xxpcinb <> 0 THEN DO:
               CREATE tt1.
               ASSIGN
                  tt1_site = xxpctr_site
                  tt1_part = xxpctr_part
                  tt1_qty = qty_xxpcinb
                  .
            END.
         END. /* IF LAST-OF(xxpctr_part) THEN DO: */
      END.

      /* 上期期初 */
      FOR EACH en_mstr NO-LOCK
         WHERE en_domain = GLOBAL_domain
         AND en_entity = entity
         ,EACH si_mstr NO-LOCK
         WHERE si_domain = GLOBAL_domain
         AND si_entity = en_entity
         ,EACH xxpcinb_mstr NO-LOCK
         WHERE xxpcinb_domain = GLOBAL_domain
         AND xxpcinb_site = si_site
         AND xxpcinb_year = yr1
         AND xxpcinb_per = per1
         AND xxpcinb_qty <> 0
         :
         CREATE tt1.
         ASSIGN
            tt1_site = xxpcinb_site
            tt1_part = xxpcinb_part
            tt1_qty = xxpcinb_qty
            .
      END.

      /* 重建 */
      FOR EACH tt1
         BREAK
         BY tt1_site
         BY tt1_part
         :
         ACCUMULATE tt1_qty (TOTAL BY tt1_site BY tt1_part).
         IF LAST-OF(tt1_part) THEN DO:
            /*
            IF (ACCUMULATE TOTAL BY tt1_part tt1_qty) <> 0 THEN DO:
            */
               FIND FIRST xxpcinb_mstr
                  WHERE xxpcinb_domain = global_domain
                  AND xxpcinb_site = tt1_site
                  AND xxpcinb_year = yr
                  AND xxpcinb_per = per
                  AND xxpcinb_part = tt1_part
                  EXCLUSIVE-LOCK NO-ERROR.
               IF NOT AVAILABLE xxpcinb_mstr THEN DO:
                  CREATE xxpcinb_mstr.
                  ASSIGN
                     xxpcinb_domain = global_domain
                     xxpcinb_site = tt1_site
                     xxpcinb_year = yr
                     xxpcinb_per = per
                     xxpcinb_part = tt1_part
                     xxpcinb_decfld[1] = (ACCUMULATE TOTAL BY tt1_part tt1_qty) - xxpcinb_qty
                     xxpcinb_qty = (ACCUMULATE TOTAL BY tt1_part tt1_qty)
                     xxpcinb_last_date = TODAY
                     xxpcinb_last_time = TIME
                     xxpcinb_last_userid = GLOBAL_userid
                     xxpcinb_last_program = execname
                     .
               END. /* IF NOT AVAILABLE xxpcinb_mstr THEN DO: */
               ELSE DO:
                  IF xxpcinb_qty <> (ACCUMULATE TOTAL BY tt1_part tt1_qty) THEN DO:
                     ASSIGN
                        xxpcinb_decfld[1] = (ACCUMULATE TOTAL BY tt1_part tt1_qty) - xxpcinb_qty
                        xxpcinb_qty = (ACCUMULATE TOTAL BY tt1_part tt1_qty)
                        xxpcinb_last_date = TODAY
                        xxpcinb_last_time = TIME
                        xxpcinb_last_userid = GLOBAL_userid
                        xxpcinb_last_program = execname
                        .
                  END. /* IF xxpcinb_qty <> (ACCUMULATE TOTAL BY tt1_part tt1_qty) THEN DO: */
               END. /* ELSE DO: */
            /*
            END. /* IF (ACCUMULATE TOTAL BY tt1_part tt1_qty) <> 0 THEN DO: */
            */
         END. /* IF LAST-OF(tt1_part) THEN DO: */
      END. /* FOR EACH tt1 */

      FOR EACH en_mstr NO-LOCK
         WHERE en_domain = GLOBAL_domain
         AND en_entity = entity
         ,EACH si_mstr NO-LOCK
         WHERE si_domain = GLOBAL_domain
         AND si_entity = en_entity
         ,EACH xxpcinb_mstr EXCLUSIVE-LOCK
         WHERE xxpcinb_domain = GLOBAL_domain
         AND xxpcinb_site = si_site
         AND xxpcinb_year = yr
         AND xxpcinb_per = per
         :
         FIND FIRST tt1
            WHERE tt1_site = xxpcinb_site
            AND tt1_part = xxpcinb_part
            NO-LOCK NO-ERROR.
         IF NOT AVAILABLE tt1 THEN DO:
            ASSIGN
               xxpcinb_decfld[1] = 0 - xxpcinb_qty
               xxpcinb_qty = 0
               xxpcinb_last_date = TODAY
               xxpcinb_last_time = TIME
               xxpcinb_last_userid = GLOBAL_userid
               xxpcinb_last_program = execname
               .
         END.
      END.
   END. /* DO TRANSACTION ON STOP UNDO: */

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      /* CREATE BATCH INPUT STRING */
      bcdparm = "".
      {mfquoter.i entity }
      {mfquoter.i yr     }
      {mfquoter.i per     }
   end.

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

   PUT UNFORMATTED "#def REPORTPATH=$/QAD Addons/BI Report/" + SUBSTRING(execname, 1, LENGTH(execname) - 2) SKIP.
   PUT UNFORMATTED "#def :end" SKIP.

   EXPORT DELIMITER ";" 
      "地点"
      "年份"
      "期间"
      "零件"
      "数量"
      "重建差异"
      .
   FOR EACH en_mstr NO-LOCK
      WHERE en_domain = GLOBAL_domain
      AND en_entity = entity
      ,EACH si_mstr NO-LOCK
      WHERE si_domain = GLOBAL_domain
      AND si_entity = en_entity
      ,EACH xxpcinb_mstr NO-LOCK
      WHERE xxpcinb_domain = GLOBAL_domain
      AND xxpcinb_site = si_site
      AND xxpcinb_year = yr
      AND xxpcinb_per = per
      BY xxpcinb_site
      BY xxpcinb_year
      BY xxpcinb_per
      BY xxpcinb_part
      :
      IF xxpcinb_decfld[1] = 0 THEN DO:
         NEXT.
      END.

      EXPORT DELIMITER ";"
         xxpcinb_site
         xxpcinb_year
         xxpcinb_per
         xxpcinb_part
         xxpcinb_qty
         xxpcinb_decfld[1]
         .
   END.
   
   {xxmfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
