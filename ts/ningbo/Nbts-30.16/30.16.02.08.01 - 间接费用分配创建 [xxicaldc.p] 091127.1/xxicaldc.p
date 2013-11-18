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

/* SS - 091127.1 By: Bill Jiang */

/* SS - 091127.1 - RNB
[091127.1]

����˳������:
1. ɾ��������
2. ������������ϸ�ļ��ĵ���������
2.1 �����ڵ���ʱ����
3. �ֱ�ÿһ����ӷ��ø�ʽλ�ü�����䷶Χ
3.1 ����������˳�����:
3.1.1 ���
3.1.2 ��Ʒ��
3.1.3 ����Ʒ�ɱ�����(�����ڱ�׼�ӹ���)
3.1.4 ������(�������ۼƼӹ���)
3.2 �������ڼӹ���[�ڳ�����] + [�ڼ���������] <> 0�ļ�¼
3.3 ������䷶ΧΪ��,����ʾ���´���:
3.3.1 301601 - �ǿ���ʽλ��#�������Ϊ0
4. ���ڷ��䷶Χ�ͷ��������ϸ�ļ���������ʹ�õķ������:
4.1 ���ܵĴ���: 
4.1.1 301602 - û�����ü�ӳɱ���������ļ� [xxicpm01.p]
4.1.2 301614 - �Ҳ�����ӷ���<#>(��ʽλ��<#>)�ķ������
4.1.3 301615 - ��ӷ���<#>(��ʽλ��<#>)�ķ������Ϊ0
4.1.4 301601 - �ǿ���ʽλ��#�������Ϊ0
4.2 ���������˳����������ֶ���Ϣ:
4.2.1 ��ӷ��ø�ʽλ�� [ttwo_fpos]
4.2.2 ������� [ttwo_ar]
4.2.3 ��� [ttwo_part]
4.2.4 �ӹ�����־(ID) [ttwo_lot]
4.2.5 ���� [ttwo_usage_tot]
4.3 �ֱ��һ����ӷ��ø�ʽλ�ü�������ʹ�õķ������
4.4 ��ӷ��ø�ʽλ�õ����һ��������� = 1 - ��ǰ���ۼƷ������
5. ���ķ���:
5.1 ���ܵĴ���:
5.1.1 301601 - �ǿ���ʽλ��#�������Ϊ0(����ǰ��Ĳ������ֵ����0.000001)
5.2 ��ӷ��õ����һ�������� = ��ӷ��÷���ǰ�Ľ�� - ��ǰ���ۼƷ�����
 
����ɹ�,��˳�����������:
1. ��Ƶ�λ
2. ���
3. �ڼ�
4. ����
5. ����
6. �ɱ�Ҫ��
7. ���

���ܵĴ���:
1. �ڼ�δ����

���ܵľ���:
1. �����Ѿ�����
1.1 �п�ѡ��ļ���ִ��(�������е�����)
1.2 ����ִֹ��

ע������:
1. ��������κ��쳣,���Ѿ�ִ�е����񽫱�����,��Ҫôȫ���ɹ�,Ҫôȫ��ʧ��

[091127.1]

SS - 091127.1 - RNE */

/* DISPLAY TITLE */
{mfdtitle.i "091127.1"}

/* ���� */
{xxiceyp1.i}
{xxicaldc.i "new"}

{wbrp01.i}

/* REPORT BLOCK */
mainloop:
repeat:
   {xxiceyp2.i}

   /* �Ѿ����� */
   FOR EACH en_mstr NO-LOCK
      WHERE en_domain = GLOBAL_domain
      AND en_entity = entity
      ,EACH xxical_mstr NO-LOCK
      WHERE xxical_domain = GLOBAL_domain
      AND xxical_entity = en_entity
      AND xxical_year = yr
      AND xxical_per = per
      :
      /* Do you want to continue? */
      {pxmsg.i &MSGNUM=6398 &ERRORLEVEL=2 &CONFIRM=l_yn}

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
      /* ɾ�� */
      {gprun.i ""xxicaldcdel.p"" "(
         INPUT entity,
         INPUT yr,
         INPUT per
         )"}

      /* ������� */
      {gprun.i ""xxicaldcar.p"" "(
         INPUT entity,
         INPUT yr,
         INPUT per
         )"}

      /* ���䷶Χ */
      {gprun.i ""xxicaldcto.p"" "(
         INPUT entity,
         INPUT yr,
         INPUT per
         )"}
      IF RETURN-VALUE = "no" THEN DO:
         STOP.
      END.

      /* ���䷶Χ���� */
      {gprun.i ""xxicaldctoar.p"" "(
         INPUT entity,
         INPUT yr,
         INPUT per
         )"}
      IF RETURN-VALUE = "no" THEN DO:
         STOP.
      END.

      /* ���� */
      {gprun.i ""xxicaldcal.p"" "(
         INPUT entity,
         INPUT yr,
         INPUT per
         )"}
      IF RETURN-VALUE = "no" THEN DO:
         STOP.
      END.
   END. /* DO TRANSACTION ON STOP UNDO: */

   PUT UNFORMATTED "#def REPORTPATH=$/QAD Addons/BI Report/" + SUBSTRING(execname, 1, LENGTH(execname) - 2) SKIP.
   PUT UNFORMATTED "#def :end" SKIP.

   EXPORT DELIMITER ";" 
      "��Ƶ�λ"
      "���"
      "�ڼ�"
      "����"
      "����"
      "�ɱ�Ҫ��"
      "���"
      .
   FOR EACH en_mstr NO-LOCK
      WHERE en_domain = GLOBAL_domain
      AND en_entity = entity
      ,EACH xxical_mstr NO-LOCK
      WHERE xxical_domain = GLOBAL_domain
      AND xxical_entity = entity
      AND xxical_year = yr
      AND xxical_per = per
      BY xxical_entity
      BY xxical_year
      BY xxical_per
      BY xxical_part
      BY xxical_lot
      BY xxical_element
      :
      EXPORT DELIMITER ";"
         xxical_entity
         xxical_year
         xxical_per
         xxical_part
         xxical_lot
         xxical_element
         xxical_cst
         .
   END.
   
   {xxmfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
