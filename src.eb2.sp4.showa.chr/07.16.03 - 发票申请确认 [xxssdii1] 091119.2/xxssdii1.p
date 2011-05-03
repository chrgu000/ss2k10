/* rqrqrp4.p - REQUISITION HISTORY REPORT                                     */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.5.1.5 $                                                         */
/*                                                             */
/*V8:ConvertMode=FullGUIReport                                                */
/* Revision: 8.6    LAST MODIFIED BY: 04/22/97  By: B. Gates          *J1Q2*  */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 04/29/98   BY: A. Shobha         *K1NZ*  */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb                */
/* Revision: 1.5.1.3  BY: Tiziana Giustozzi DATE: 07/03/01 ECO: *N104* */
/* $Revision: 1.5.1.5 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00L* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* ss - 091112.1 by: jack */

/* SS - 090511.1 By: Bill Jiang */
/* ss - 090824.1 by: jack */
/* ss - 090831.1 by: jack */ /* ȡ�۸��ʵ�ʼ۸�*/
/* ss - 090902.1 by: jack */
/* ss - 090903.1 by: jack */
/* ss - 090904.1 by: jack */ /* ȷ�ϼ۸�ȡ�ͻ����ļ۸��*/
/* ss - 090916.1 by: jack */
/* ss - 091119.1 by: jack */  /* �ݹ��������*/

/* SS - 090511.1 - RNB
[090511.1]

�޸������±�׼����:
  - �ɹ�������ʷ��¼ [rqrqrp4.p]
  
�ݹ���Ʊ����ȷ��(�����Ѵ�ӡ)

ע��:
  - �����ļ���������Ϊ<����¼>,���򽫻����
  - �����Ƿ�<����>,���������ͷ�Ʊ����˳�����
  -   ����ʱ,�����ֶ��ڿ����ļ����޸�,���򽫻���ֶϺ�
  - �����Ƿ�<����>,��ֵ˰�Ŷ���˳�����,����ʱ,ͨ����Ҫ���ֶ��޸�

ȷ��ʱ,���Զ����ݹ���Ʊ(��Ʊ+����+��)��������������Ʊ:
  - ���ֶ���
  - ��ʽ����

�����ֶε�ֵ�����ر���(��˳��):
  - ����: �������ļ��е�ǰ׺����һ���������Զ�����
  - �ɹ�����: ��ֵ˰ר�÷�Ʊ,���ڴ��������ǰ�ֶ��޸�
  - ���: No
  - �����˷�: No
  - ��ʾ����: No
  - ����/���: No
  - ˵��: No
  - ��Ʊ����: ���ֶ���Ϊ��,��ʽ����Ϊ��
  - ����: ʼ���뾻����ͬ
  - �ۿ�: ʼ��Ϊ��
  - ��/���: <�ݹ���Ʊ+����+��>�����һ�������
  - ����: �������ļ��е������Զ�ά��
  - ˵��: No
  - ��Ʊ: �������ļ��е�ǰ׺����һ����Ʊ���Զ�����

�����ֶ�ȡϵͳĬ��ֵ(��˳��):
  - ��������
  - ��������
  - ��ֹ����
  - ��������
  - ��������
  - ��Ŀ����
  - �ֹ�
  - �ϴη���
  - ����
  - ��˰
  - ��
  - Ƿ����
  - ��λ
  - �ο�
  - ��������
  - ��ֹ����
  - ��������
  - ����
  - �˼۱�
  - ��ӡ��Ʊ
  - ����

�����ֶ�ȡ�ݹ���Ʊ��Ӧ��ֵ

[090511.1]

SS - 090511.1 - RNE */

/*        
{mfdtitle.i "2+ "}
*/
/*
{mfdtitle.i "090511.1"}
*/
/*
{mfdtitle.i "090831.1"}
*/
/*
{mfdtitle.i "090902.1"}
*/
/*
{mfdtitle.i "091112.1"}
*/
{mfdtitle.i "091119.2"}

/* SS - 090511.1 - B */
{xxcimimp.i "new"}
/* SS - 090511.1 - E */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE rqrqrp4_p_1 "Display E-mail Ids"
/* MaxLen: Comment: */

&SCOPED-DEFINE rqrqrp4_p_2 "Email!Sent To"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define variable nbr like rqm_mstr.rqm_nbr no-undo.
define variable nbr1 like rqm_mstr.rqm_nbr label {t001.i} no-undo.
define variable enterdate like rqh_date no-undo.
define variable enterdate1 like rqh_date label {t001.i} no-undo.
define variable apr_userid like rqh_apr_userid no-undo.
define variable apr_userid1 like rqh_apr_userid label {t001.i} no-undo.
define variable show_email_ids like mfc_logical
   label {&rqrqrp4_p_1} no-undo.
define variable email_sent_to as character
   column-label {&rqrqrp4_p_2}.

define variable dummychar as character no-undo.
define variable numentries as integer no-undo.
define variable i as integer no-undo.

/* SS - 090511.1 - B */
DEFINE VARIABLE SoftspeedDI_inv LIKE mfc_integer.
/* SS - 090511.1 - E */

{rqconst.i}

form
   nbr             colon 20
   nbr1            colon 49
   enterdate       colon 20
   enterdate1      colon 49
   apr_userid      colon 20
   apr_userid1     colon 49
   skip(1)
   /* SS - 090511.1 - B */
   SoftspeedDI_inv colon 30
   /* SS - 090511.1 - E */
   show_email_ids  colon 30
   skip
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}

repeat:
   /* SS - 090511.1 - B */
   /* ��ֵ˰ר�÷�Ʊ */
   /* ss - 090824.1 -b
   FIND FIRST mfc_ctrl 
      WHERE mfc_domain = GLOBAL_domain 
      AND mfc_field = "SoftspeedDI_inv"
      EXCLUSIVE-LOCK NO-ERROR.
    ss - 090824.1 -e */
    /* ss - 090824.1 -b */
       FIND FIRST mfc_ctrl 
      WHERE  mfc_field = "SoftspeedDI_inv"
      EXCLUSIVE-LOCK NO-ERROR.
    /* ss - 090824.1 -e */
   IF NOT AVAILABLE mfc_ctr THEN DO:
      /* Control table error.  Check applicable control tables */
      {pxmsg.i &MSGNUM=594 &ERRORLEVEL=3}
      undo, RETURN.
   END.
   ASSIGN
      SoftspeedDI_inv = mfc_integer
      .
   DISPLAY
      SoftspeedDI_inv
      WITH FRAME a.
   /* SS - 090511.1 - E */

   if nbr1 = hi_char then nbr1 = "".
   if enterdate = low_date then enterdate = ?.
   if enterdate1 = hi_date then enterdate1 = ?.
   if apr_userid1 = hi_char then apr_userid1 = "".

   if c-application-mode <> 'WEB' then
   update
      nbr
      nbr1
      enterdate
      enterdate1
      apr_userid
      apr_userid1
      /* SS - 090511.1 - B */
      SoftspeedDI_inv
      /* SS - 090511.1 - E */
      show_email_ids
   with frame a.

   {wbrp06.i &command = update
      &fields = "  nbr nbr1 enterdate enterdate1
                        apr_userid apr_userid1 
      /* SS - 090511.1 - B */
      SoftspeedDI_inv
      /* SS - 090511.1 - E */
      show_email_ids"
      &frm = "a"}
      
   /* SS - 090511.1 - B */
   /* ��ֵ˰ר�÷�Ʊ */
   /* ss - 090824.1 -b
   FIND FIRST mfc_ctrl 
      WHERE mfc_domain = GLOBAL_domain 
      AND mfc_field = "SoftspeedDI_inv"
      EXCLUSIVE-LOCK NO-ERROR.
   ss - 090824.1 -e */
   /* ss - 090824.1 -b */
      FIND FIRST mfc_ctrl 
      WHERE mfc_field = "SoftspeedDI_inv"
      EXCLUSIVE-LOCK NO-ERROR.

   /* ss - 090824.1 -e */

   IF NOT AVAILABLE mfc_ctr THEN DO:
      /* Control table error.  Check applicable control tables */
      {pxmsg.i &MSGNUM=594 &ERRORLEVEL=3}
      undo, RETURN.
   END.
   ASSIGN
      mfc_integer = SoftspeedDI_inv
      .
   /* SS - 090511.1 - E */

   if (c-application-mode <> 'WEB') or
      (c-application-mode = 'WEB' and
      (c-web-request begins 'DATA')) then do:

      bcdparm = "".
      {mfquoter.i nbr}
      {mfquoter.i nbr1}
      {mfquoter.i enterdate}
      {mfquoter.i enterdate1}
      {mfquoter.i apr_userid}
      {mfquoter.i apr_userid1}
      /* SS - 090511.1 - B */
      {mfquoter.i SoftspeedDI_inv}
      /* SS - 090511.1 - E */
      {mfquoter.i show_email_ids}

      if nbr1 = "" then nbr1 = hi_char.
      if enterdate = ? then enterdate = low_date.
      if enterdate1 = ? then enterdate1 = hi_date.
      if apr_userid1 = "" then apr_userid1 = hi_char.

   end.

   /* SS - 090511.1 - B */
   {gprun.i ""xxsscimqp.p""}
   /* SS - 090511.1 - E */

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
   {mfphead.i}

   /* SS - 090511.1 - B */
   {gprun.i ""xxssdii1a.p"" "(
      INPUT nbr,
      INPUT nbr1,
      INPUT enterdate,
      INPUT enterdate1,
      INPUT apr_userid,
      INPUT apr_userid1,
      INPUT SoftspeedDI_inv,
      INPUT show_email_ids
      )"}
   /* SS - 090511.1 - E */

   /* SS - 090511.1 - B
   for each rqh_hist no-lock
          where rqh_hist.rqh_domain = global_domain and  rqh_nbr >= nbr and
          rqh_nbr <= nbr1
         and rqh_date >= enterdate and rqh_date <= enterdate1
         and rqh_apr_userid >= apr_userid and rqh_apr_userid <= apr_userid1
         use-index rqh_nbr
         break by rqh_nbr by rqh_date by rqh_time by rqh_seq_nbr with frame b:
      {gplngn2a.i
         &file=""rqh_hist""
         &field=""rqh_action""
         &code=rqh_action
         &mnemonic=dummychar
         &label=action_desc}

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).

      display
         rqh_nbr
         rqh_line
         rqh_date
         string(rqh_time,"HH:MM:SS") @ rqh_time
         action_desc @ rqh_action
         rqh_apr_userid
         rqh_ent_userid
         rqh_rtto_userid
      with width 132.

      if show_email_ids then do:
         numentries = num-entries(rqh_email_list).

         do i = 1 to numentries:
            if i > 1 then down 1.
            email_sent_to = entry(i,rqh_email_list).
            display email_sent_to.
         end.
      end.
   end.
   SS - 090511.1 - E */

   {mfrtrail.i}
end.

{wbrp04.i &frame-spec = a}
