/* ppcprp.p - CUSTOMER ITEMS REPORT                                     */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.5.1.6 $                                                     */
/*V8:ConvertMode=FullGUIReport                                          */
/* REVISION: 7.3            CREATED: 06/10/96   BY: tzp *G1XV*          */
/* REVISION: 8.6      LAST MODIFIED: 10/07/97   BY: mzv *K0MC*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 05/02/00   BY: *N09M* Peter Faherty      */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb                */
/* Revision: 1.5.1.5  BY: Paul Donnelly (SB)  DATE: 06/28/03 ECO: *Q00K*      */
/* $Revision: 1.5.1.6 $ BY: Katie Hilbert       DATE: 10/16/03  ECO: *Q04B*   */
/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* ����Ϊ�汾��ʷ */                                                             
/* SS - 090218.1 By: Bill Jiang */

/*����Ϊ����˵�� */
/* SS - 090218.1 - RNB
�����б�׼��
SS - 090218.1 - RNE */

/* DISPLAY TITLE */
/*
{mfdtitle.i "1+ "}
*/
/* ��ʾ���µİ汾��.ע����淶 */
{mfdtitle.i "090218.1"}

/* SS - 090218.1 - B */
/* ��һ�����ù������ʱ��.ע������� */
{xxppcprp0001.i "new"}
/* SS - 090218.1 - E */

define variable part  like cp_part no-undo.
define variable part1 like cp_part no-undo.
define variable cust  like cp_cust no-undo.
define variable cust1 like cp_cust no-undo.
define variable desc1 like pt_desc1 format "x(49)" no-undo.

/* SELECT FORM */
form
   part           colon 15
   part1          label "To" colon 49 skip
   cust           colon 15
   cust1          label "To" colon 49 skip
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* REPORT BLOCK */

{wbrp01.i}
repeat:

   if part1 = hi_char then part1 = "".
   if cust1 = hi_char then cust1 = "".

   if c-application-mode <> 'web' then
      update
         part part1
         cust cust1
      with frame a.

   {wbrp06.i &command = update &fields = "  part part1 cust cust1"
      &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      bcdparm = "".
      {mfquoter.i part   }
      {mfquoter.i part1  }
      {mfquoter.i cust   }
      {mfquoter.i cust1  }

      if part1 = "" then part1 = hi_char.
      if cust1 = "" then cust1 = hi_char.
   end.

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
   /* SS - 090218.1 - B            
   ��ֹ��׼ҳü��ҳ�ŵ����,ͬʱ������Ӧ�ļ���,��Ϊ���ñ����๫�ó���
   {mfphead.i}

   for each cp_mstr
      where cp_domain = global_domain
       and (cp_part >= part and cp_part <= part1)
       and (cp_cust >= cust and cp_cust <= cust1)
   no-lock break by cp_part with frame b width 132 no-box:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).

      desc1 = "".
      find pt_mstr
         where pt_domain = global_domain
          and  pt_part = cp_part no-lock no-error.
      if available pt_mstr then desc1 = pt_desc1 + " " + pt_desc2.
      if first-of (cp_part) then do:
         if page-size - line-counter < 6 then page.
         display.

         put
            skip
            {gplblfmt.i
               &FUNC=getTermLabel(""ITEM"",8)
               &CONCAT="': '"}
            cp_part space(1)
            desc1.
      end.

      display
         space(6)
         cp_cust
         cp_cust_part
         cp_cust_partd
         cp_cust_eco.
      {mfrpchk.i}
   end.

   /* REPORT TRAILER  */
   {mfrtrail.i}
   SS - 090218.1 - E */

   /* SS - 090218.1 - B */
   /* �������ʼ���е�ʱ�� */
   PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.

   /* �����ʱ�� */
   EMPTY TEMP-TABLE ttxxppcprp0001.

   /* ���ñ����๫�ó��� */
   {gprun.i ""xxppcprp0001.p"" "(
      input part,
      input part1,
      input cust,
      input cust1
      )"}

   /* ����÷ֺŷָ��ı���,����ʱ����ֶ�����,Ϊ�˼����,��������ʱ��ı���;ע�������ֶ� */
   EXPORT DELIMITER ";" "cp_part" "desc1" "cp_cust" "cp_cust_part" "cp_cust_partd" "cp_cust_eco".
   /* ����÷ֺŷָ�����ʱ�� */
   FOR EACH ttxxppcprp0001:
      EXPORT DELIMITER ";" ttxxppcprp0001.
   END.

   /* �������������е�ʱ��,�Ա��뿪ʼ���е�ʱ��һ�����������Ч�� */
   PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.

   /* ��ֹ�˱�׼ҳ�ŵ���� */
   {xxmfrtrail.i}
   /* SS - 090218.1 - E */
end.

{wbrp04.i &frame-spec = a}
