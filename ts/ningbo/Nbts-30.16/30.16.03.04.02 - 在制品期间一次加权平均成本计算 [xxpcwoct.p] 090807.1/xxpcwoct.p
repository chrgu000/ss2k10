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

/* SS - 090807.1 By: Bill Jiang */

/* SS - 090807.1 - RNB
[090807.1]
             
             �ڳ��ɱ� + �ڼ����ӳɱ�(������,�������2,3��6)
1.�ڼ���� = -----------------------------------------------
             �ڳ����� + �ڼ��������� - ���Ƴɱ����ڼ䱨������

2.��ĩ�ɱ� = <�ӹ������������ļ�>.��ĩ���� * �ڼ����

ƽ���ɱ��������������������:
1) ���㱨�ϳɱ�: ƽ���ɱ� = (�ڳ��ܳ� + �ڼ��´��ܳ�) / (�ڳ����� + �ڼ��´�����)
2) ���Ʊ��ϳɱ�:
2.1) �ڳ����� + �ڼ��´����� = �ڼ䱨������: ƽ���ɱ� = (�ڳ��ܳ� + �ڼ��´��ܳ�) / (�ڳ����� + �ڼ��´�����)
2.2) �ڳ����� + �ڼ��´����� <> �ڼ䱨������:ƽ���ɱ� = (�ڳ��ܳ� + �ڼ��´��ܳ�) / (�ڳ����� + �ڼ��´����� - �ڼ䱨������)
���������������ͳһΪ: ƽ���ɱ� = (�ڳ��ܳ� + �ڼ��´��ܳ�) / (�ڳ����� + �ڼ��´����� - ���Ƴɱ����ڼ䱨������)

���"�ڳ����� + �ڼ��´����� = �ڼ䱨������"(��ȫ������),�򲻹��������,������㱨�ϳɱ�:
����,һ�㹫ʽ����:
�ڳ��ɱ� + �´�ɱ� = ���ɱ� + ���ϳɱ� + ��ĩ�ɱ�
����,���ϳɱ�����������������²�Ϊ��:
1) ���㱨�ϳɱ�,�ұ���������Ϊ��
2) �����㱨�ϳɱ�,��"�ڳ����� + �ڼ��´����� = �ڼ䱨������"(��ȫ������)

[090807.1]

SS - 090807.1 - RNE */

/* DISPLAY TITLE */
{mfdtitle.i "090807.1"}

define variable per like glc_per.
define variable yr like glc_year.
define variable entity like glcd_entity.
DEFINE VARIABLE date1 AS DATE.
DEFINE VARIABLE find-can AS LOGICAL.
define variable l_yn        like mfc_logical             no-undo.
DEFINE VARIABLE qty0 AS DECIMAL.
DEFINE VARIABLE qty1 AS DECIMAL.

DEFINE VARIABLE continue AS LOGICAL NO-UNDO.

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

   {gprun.i ""xxpcincpv.p"" "(
      INPUT entity,
      INPUT yr,
      INPUT per
      )"}
   IF RETURN-VALUE = "no" THEN DO:
      UNDO,RETRY.
   END.

   /* �Ѿ����� */
   FOR EACH en_mstr NO-LOCK
      WHERE en_domain = GLOBAL_domain
      AND en_entity = entity
      ,EACH si_mstr NO-LOCK
      WHERE si_domain = GLOBAL_domain
      AND si_entity = en_entity
      ,EACH xxpcwoc_det NO-LOCK
      WHERE xxpcwoc_domain = GLOBAL_domain
      AND xxpcwoc_site = si_site
      AND xxpcwoc_year = yr
      AND xxpcwoc_per = per
      AND (xxpcwoc_cst_tot <> 0 OR xxpcwoc_end <> 0)
      :
      /* 301606 - ��¼�Ѿ�����.�Ƿ����? */
      {pxmsg.i &MSGNUM=301606 &ERRORLEVEL=2 &CONFIRM=l_yn}

      if not l_yn then do:
         next-prompt per.
         UNDO mainloop, retry.
      end. /* IF NOT l_yn */

      LEAVE.
   END.

   continue = YES.
   DO TRANSACTION ON STOP UNDO:
      /* ��� */
      FOR EACH en_mstr NO-LOCK
         WHERE en_domain = GLOBAL_domain
         AND en_entity = entity
         ,EACH si_mstr NO-LOCK
         WHERE si_domain = GLOBAL_domain
         AND si_entity = en_entity
         ,EACH xxpcwoc_det exclusive-LOCK
         WHERE xxpcwoc_domain = GLOBAL_domain
         AND xxpcwoc_site = si_site
         AND xxpcwoc_year = yr
         AND xxpcwoc_per = per
         :
         ASSIGN
            xxpcwoc_cst_tot = 0
            xxpcwoc_end = 0
            .
      END.

      /* ���� */
      FOR EACH en_mstr NO-LOCK
         WHERE en_domain = GLOBAL_domain
         AND en_entity = entity
         ,EACH si_mstr NO-LOCK
         WHERE si_domain = GLOBAL_domain
         AND si_entity = en_entity
         ,EACH xxpcwoc_det exclusive-LOCK
         WHERE xxpcwoc_domain = GLOBAL_domain
         AND xxpcwoc_site = si_site
         AND xxpcwoc_year = yr
         AND xxpcwoc_per = per
         BREAK 
         BY xxpcwoc_site
         BY xxpcwoc_part
         BY xxpcwoc_lot
         :
         IF FIRST-OF(xxpcwoc_lot) THEN DO:
            qty0 = 0.
            qty1 = 0.

            FOR EACH xxpcwo_mstr NO-LOCK
               WHERE xxpcwo_domain = GLOBAL_domain
               AND xxpcwo_site = xxpcwoc_site
               AND xxpcwo_year = yr
               AND xxpcwo_per = per
               AND xxpcwo_part = xxpcwoc_part
               AND xxpcwo_lot = xxpcwoc_lot
               :
               qty0 = qty0 + xxpcwo_qty_beg + xxpcwo_qty_ord - xxpcwo_qty_rjct0.
               qty1 = qty1 + xxpcwo_qty_end.
            END.
         END.

         IF (xxpcwoc_beg + xxpcwoc_rct + xxpcwoc_rct_wo) = 0 THEN DO:
            ASSIGN
               xxpcwoc_cst_tot = 0
               xxpcwoc_end = xxpcwoc_cst_tot * qty1
               .
         END.
         ELSE DO:
            IF qty0 = 0 THEN DO:
               /*
               /* 301610 - �ڳ�����+�ڼ���������-�ڼ䲻�Ƴɱ���������=0:���[#],�ӹ���[#] */
               {pxmsg.i &MSGNUM=301610 &ERRORLEVEL=3 &MSGARG1=xxpcwoc_part &MSGARG2=xxpcwoc_lot}

               continue = NO.
               STOP.
               */

               ASSIGN
                  xxpcwoc_cst_tot = 0
                  xxpcwoc_end = xxpcwoc_cst_tot * qty1
                  .
               NEXT.
            END.

            ASSIGN
               xxpcwoc_cst_tot = (xxpcwoc_beg + xxpcwoc_rct + xxpcwoc_rct_wo) / qty0
               xxpcwoc_end = xxpcwoc_cst_tot * qty1
               .
         END.
      END. /* FOR EACH en_mstr NO-LOCK */
   END. /* DO TRANSACTION ON STOP UNDO: */
   IF continue = NO THEN DO:
      next-prompt per.
      UNDO mainloop, RETRY mainloop.
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
      "�ص�"
      "���"
      "�ڼ�"
      "���"
      "����"
      "�ɱ�Ҫ��"
      "�ڼ�һ�μ�Ȩƽ���ɱ�"
      "��ĩ�ܳ�"
      .
   FOR EACH en_mstr NO-LOCK
      WHERE en_domain = GLOBAL_domain
      AND en_entity = entity
      ,EACH si_mstr NO-LOCK
      WHERE si_domain = GLOBAL_domain
      AND si_entity = en_entity
      ,EACH xxpcwoc_det NO-LOCK
      WHERE xxpcwoc_domain = GLOBAL_domain
      AND xxpcwoc_site = si_site
      AND xxpcwoc_year = yr
      AND xxpcwoc_per = per
      BY xxpcwoc_site
      BY xxpcwoc_year
      BY xxpcwoc_per
      BY xxpcwoc_part
      BY xxpcwoc_lot
      BY xxpcwoc_element
      :
      EXPORT DELIMITER ";"
         xxpcwoc_site
         xxpcwoc_year
         xxpcwoc_per
         xxpcwoc_part
         xxpcwoc_lot
         xxpcwoc_element
         xxpcwoc_cst_tot
         xxpcwoc_end
         .
   END.
   
   {xxmfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
