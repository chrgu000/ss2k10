/* appm.p - AP CONTROL PARAMETER MAINTAINCE                                   */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.9.2.11 $                                                      */
/* REVISION: 1.0      LAST MODIFIED: 08/18/86   BY: PML                       */
/* REVISION: 6.0      LAST MODIFIED: 05/03/91   BY: mlv *D595*                */
/* REVISION: 7.0      LAST MODIFIED: 08/09/91   BY: mlv *F002*                */
/*                                   11/15/91   BY: mlv *F037*                */
/*                                   07/10/92   BY: mlv *F725*                */
/* REVISION: 7.3      LAST MODIFIED: 07/24/92   By: mpp *G004*                */
/*                                   08/17/92   BY: mlv *G031*                */
/*                                   09/04/92   BY: mlv *G042*                */
/*                                   02/17/93   by: jms *G698*                */
/* REVISION: 7.4      LAST MODIFIED: 11/30/93   BY: pcd *H249*                */
/*                                   11/30/93   BY: pcd *H255*(rev only)      */
/*                                   11/30/93   BY: wep *H201*                */
/*                                   09/28/94   BY: bcm *H479*                */
/* REVISION: 7.4      LAST MODIFIED: 10/27/94   BY: ame *FS90*                */
/* REVISION: 8.5      LAST MODIFIED: 02/27/96   BY: *J0CV* Brandy J Ewing     */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 06/30/98   BY: *J2P4* Samir Bavkar       */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Murali Ayyagari    */
/* REVISION: 9.1      LAST MODIFIED: 05/25/99   BY: *N00D* Adam Harris        */
/* REVISION: 9.1      LAST MODIFIED: 01/19/00   BY: *N077* Vijaya Pakala      */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* Jacolyn Neder      */
/* REVISION: 9.1      LAST MODIFIED: 08/21/00   BY: *N0MH* Arul Victoria      */
/* REVISION: 9.1      LAST MODIFIED: 08/04/00   BY: *N0VN* BalbeerS Rajput    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.9.2.9       BY: Paul Donnelly      DATE: 12/18/01  ECO: *N16J* */
/* Revision: 1.9.2.10    BY: Jean Miller        DATE: 05/07/02  ECO: *P066* */
/* $Revision: 1.9.2.11 $   BY: Orawan S.          DATE: 04/17/03  ECO: *P0Q3* */

/* ����Ϊ�汾��ʷ */                                                             
/* SS - 090927.1 By: Bill Jiang */
/* SS - 090928.1 BY: JACK */  /*  �޸İ汾Ϊ eb2 */

/*����Ϊ����˵�� */
/* SS - 090927.1 - RNB
[090927.1]

�����ֶ�����:
  - SoftspeedIR_rqm_nbr: ����ǰ׺����һ������
  - SoftspeedIR_rqm_next: ��һ������
  - SoftspeedIR_Max: ��Ʊ�޶�
  - SoftspeedIR_Tol: ��Ʊ�޶��ݲ�,����Ʊ������޶�֮��С����ڴ��ݲ�ʱ������Ʊ
  - SoftspeedIR_VAT: ��һ����Ʊ,����д�ڷ���"��ע"��,�Ա��ο�
  - SoftspeedIR_so_pre1: ���ֶ���ǰ׺����һ�����ֶ���
  - SoftspeedIR_so_pre2: ��ʽ����ǰ׺����һ����ʽ����
  - SoftspeedIR_sod_type1: ���ֶ�������
  - SoftspeedIR_sod_type2: ��ʽ��������
  - SoftspeedIR_inv_pre1: ���ַ�Ʊǰ׺����һ�����ַ�Ʊ
  - SoftspeedIR_inv_pre2: ��ʽ��Ʊǰ׺����һ����ʽ��Ʊ
  - SoftspeedIR_inv_pre: ��ֵ˰ר�÷�Ʊǰ׺
  - SoftspeedIR_inv: ��һ����ֵ˰ר�÷�Ʊ
  -   1)Ӧ����"��Ʊ����ȷ��[xxssdii1.p]"
  -   2)����ǰ,����"������Ʊά��[soivmt.p]"��"�ɹ�����[so_po]"�ֶ��޸�
  -   3)���˺�.����"��/����֪ͨ��ά��[ardrmt.p]"��"��ע[ar_po]"�ֶ��޸�
  -   4)�������ڹ��˺��޸������ֶ�,�Ӷ�ȷ������һ����
  - SoftspeedIR_trnbr: ��ʼ����������
  -   Ӧ���ڳ�ʼ��
  -   ��ʼ����һ������:
  -   1)�����������еĴ�����Ʊ
  -   2)��ѯ<������ϸ��ѯ [ictriq.p]>,�������Ŀ�������
  -   3)���ñ��ֶβ���

[090927.1]

SS - 090927.1 - RNE */
/*
{mfdtitle.i "090927.1"}
*/
{mfdtitle.i "090929.1"}


define variable SoftspeedIR_rqm_nbr like mfc_char FORMAT "x(2)".
define variable SoftspeedIR_rqm_next like mfc_integer.
define variable SoftspeedIR_Max like mfc_decimal.
define variable SoftspeedIR_Tol like mfc_decimal.
define variable SoftspeedIR_VAT like mfc_integer.
define variable SoftspeedIR_so_pre1 like mfc_char FORMAT "x(2)".
define variable SoftspeedIR_so_pre2 like mfc_char FORMAT "x(2)".
define variable SoftspeedIR_sod_type1 like mfc_char FORMAT "x(1)".
define variable SoftspeedIR_sod_type2 like mfc_char FORMAT "x(1)".
define variable SoftspeedIR_inv_pre1 like mfc_char FORMAT "x(2)".
define variable SoftspeedIR_inv_pre2 like mfc_char FORMAT "x(2)".
define variable SoftspeedIR_inv_pre like mfc_char FORMAT "x(2)".
define variable SoftspeedIR_inv like mfc_integer.
define variable SoftspeedIR_trnbr like mfc_integer.

/* DISPLAY SELECTION FORM */
{&APPMFRM-I-TAG1}
form
   SoftspeedIR_rqm_nbr          colon 25
   SoftspeedIR_rqm_next          colon 25 LABEL "�¸������"
   SoftspeedIR_Max           colon 25
   SoftspeedIR_Tol           colon 25
   SoftspeedIR_VAT           colon 25 LABEL "��һ����Ʊ��"
   /*
   SKIP (1)
   SoftspeedIR_so_pre1          colon 25
   SoftspeedIR_so_pre2          colon 25
   SoftspeedIR_sod_type1          colon 25
   SoftspeedIR_sod_type2          colon 25
   SoftspeedIR_inv_pre1          colon 25
   SoftspeedIR_inv_pre2          colon 25
   */
   SKIP (1)
   SoftspeedIR_inv_pre           colon 25 LABEL "��Ʊǰ׺"
   SoftspeedIR_inv           colon 25 
   SKIP (1)
   SoftspeedIR_trnbr           colon 25 LABEL "��ʼ���������"
with frame appm-a width 80 side-labels attr-space
/*V8! title color normal (getFrameTitle("ACCOUNTS_PAYABLE_CONTROL",41)) */.
{&APPMFRM-I-TAG2}

/* SET EXTERNAL LABELS */
setFrameLabels(frame appm-a:handle).
{&APPMFRM-I-TAG3}

/* DISPLAY */
ststatus = stline[3].
status input ststatus.
view frame appm-a.

repeat with frame appm-a:

   /* ADD MFC_CTRL FIELD SoftspeedIR_rqm_nbr */
   for first mfc_ctrl where /* mfc_domain = global_domain and */ mfc_field = "SoftspeedIR_rqm_nbr" exclusive-lock: end.
   if not available mfc_ctrl then do:
      create mfc_ctrl.
      assign
       /*  mfc_domain = GLOBAL_domain */
         mfc_field   = "SoftspeedIR_rqm_nbr"
         mfc_type    = "C"
         mfc_module  = "SoftspeedIR_rqm_nbr"
         mfc_seq     = 10
         mfc_char = "IR"
         /* �ر�� */
         mfc_integer = 1
         .
   end.
   assign
      SoftspeedIR_rqm_nbr = mfc_char
      SoftspeedIR_rqm_next = mfc_integer
      .

   /* ADD MFC_CTRL FIELD SoftspeedIR_Max */
   for first mfc_ctrl where  /* mfc_domain = global_domain and  */ mfc_field = "SoftspeedIR_Max" exclusive-lock: end.
   if not available mfc_ctrl then do:
      create mfc_ctrl.
      assign
        /* mfc_domain = GLOBAL_domain */
         mfc_field   = "SoftspeedIR_Max"
         mfc_type    = "D"
         mfc_module  = "SoftspeedIR_Max"
         mfc_seq     = 20
         mfc_decimal = 1000000
         .
   end.
   assign
      SoftspeedIR_Max = mfc_decimal
      .

   /* ADD MFC_CTRL FIELD SoftspeedIR_Tol */
   for first mfc_ctrl where /* mfc_domain = global_domain and  */ mfc_field = "SoftspeedIR_Tol" exclusive-lock: end.
   if not available mfc_ctrl then do:
      create mfc_ctrl.
      assign
       /*  mfc_domain = GLOBAL_domain */
         mfc_field   = "SoftspeedIR_Tol"
         mfc_type    = "D"
         mfc_module  = "SoftspeedIR_Tol"
         mfc_seq     = 30
         mfc_decimal = 10000
         .
   end.
   assign
      SoftspeedIR_Tol = mfc_decimal
      .

   /* ADD MFC_CTRL FIELD SoftspeedIR_VAT */
   for first mfc_ctrl where /* mfc_domain = global_domain and */ mfc_field = "SoftspeedIR_VAT" exclusive-lock: end.
   if not available mfc_ctrl then do:
      create mfc_ctrl.
      assign
        /* mfc_domain = GLOBAL_domain */
         mfc_field   = "SoftspeedIR_VAT"
         mfc_type    = "I"
         mfc_module  = "SoftspeedIR_VAT"
         mfc_seq     = 40
         mfc_integer = 1
         .
   end.
   assign
      SoftspeedIR_VAT = mfc_integer
      .

   /*
   /* ADD MFC_CTRL FIELD SoftspeedIR_so_pre1 */
   for first mfc_ctrl where mfc_domain = global_domain and mfc_field = "SoftspeedIR_so_pre1" exclusive-lock: end.
   if not available mfc_ctrl then do:
      create mfc_ctrl.
      assign
         mfc_domain = GLOBAL_domain
         mfc_field   = "SoftspeedIR_so_pre1"
         mfc_type    = "C"
         mfc_module  = "SoftspeedIR_so_pre1"
         mfc_seq     = 50
         mfc_char = "SR"
         /* �ر�� */
         mfc_integer = 1
         .
   end.
   assign
      SoftspeedIR_so_pre1 = mfc_char
      .

   /* ADD MFC_CTRL FIELD SoftspeedIR_so_pre2 */
   for first mfc_ctrl where mfc_domain = global_domain and mfc_field = "SoftspeedIR_so_pre2" exclusive-lock: end.
   if not available mfc_ctrl then do:
      create mfc_ctrl.
      assign
         mfc_domain = GLOBAL_domain
         mfc_field   = "SoftspeedIR_so_pre2"
         mfc_type    = "C"
         mfc_module  = "SoftspeedIR_so_pre2"
         mfc_seq     = 60
         mfc_char = "SI"
         /* �ر�� */
         mfc_integer = 1
         .
   end.
   assign
      SoftspeedIR_so_pre2 = mfc_char
      .

   /* ADD MFC_CTRL FIELD SoftspeedIR_sod_type1 */
   for first mfc_ctrl where mfc_domain = global_domain and mfc_field = "SoftspeedIR_sod_type1" exclusive-lock: end.
   if not available mfc_ctrl then do:
      create mfc_ctrl.
      assign
         mfc_domain = GLOBAL_domain
         mfc_field   = "SoftspeedIR_sod_type1"
         mfc_type    = "C"
         mfc_module  = "SoftspeedIR_sod_type1"
         mfc_seq     = 70
         mfc_char = "R"
         .
   end.
   assign
      SoftspeedIR_sod_type1 = mfc_char
      .

   /* ADD MFC_CTRL FIELD SoftspeedIR_sod_type2 */
   for first mfc_ctrl where mfc_domain = global_domain and mfc_field = "SoftspeedIR_sod_type2" exclusive-lock: end.
   if not available mfc_ctrl then do:
      create mfc_ctrl.
      assign
         mfc_domain = GLOBAL_domain
         mfc_field   = "SoftspeedIR_sod_type2"
         mfc_type    = "C"
         mfc_module  = "SoftspeedIR_sod_type2"
         mfc_seq     = 80
         mfc_char = "I"
         .
   end.
   assign
      SoftspeedIR_sod_type2 = mfc_char
      .

   /* ADD MFC_CTRL FIELD SoftspeedIR_inv_pre1 */
   for first mfc_ctrl where mfc_domain = global_domain and mfc_field = "SoftspeedIR_inv_pre1" exclusive-lock: end.
   if not available mfc_ctrl then do:
      create mfc_ctrl.
      assign
         mfc_domain = GLOBAL_domain
         mfc_field   = "SoftspeedIR_inv_pre1"
         mfc_type    = "C"
         mfc_module  = "SoftspeedIR_inv_pre1"
         mfc_seq     = 90
         mfc_char = "IR"
         /* �ر�� */
         mfc_integer = 1
         .
   end.
   assign
      SoftspeedIR_inv_pre1 = mfc_char
      .

   /* ADD MFC_CTRL FIELD SoftspeedIR_inv_pre2 */
   for first mfc_ctrl where mfc_domain = global_domain and mfc_field = "SoftspeedIR_inv_pre2" exclusive-lock: end.
   if not available mfc_ctrl then do:
      create mfc_ctrl.
      assign
         mfc_domain = GLOBAL_domain
         mfc_field   = "SoftspeedIR_inv_pre2"
         mfc_type    = "C"
         mfc_module  = "SoftspeedIR_inv_pre2"
         mfc_seq     = 100
         mfc_char = "II"
         /* �ر�� */
         mfc_integer = 1
         .
   end.
   assign
      SoftspeedIR_inv_pre2 = mfc_char
      .
   */

   /* ADD MFC_CTRL FIELD SoftspeedIR_inv_pre */
   for first mfc_ctrl where  /* mfc_domain = global_domain and  */ mfc_field = "SoftspeedIR_inv_pre" exclusive-lock: end.
   if not available mfc_ctrl then do:
      create mfc_ctrl.
      assign
        /* mfc_domain = GLOBAL_domain */
         mfc_field   = "SoftspeedIR_inv_pre"
         mfc_type    = "C"
         mfc_module  = "SoftspeedIR_inv_pre"
         mfc_seq     = 100
         mfc_char = "IV"
         .
   end.
   assign
      SoftspeedIR_inv_pre = mfc_char
      .

   /* ADD MFC_CTRL FIELD SoftspeedIR_inv */
   for first mfc_ctrl where /* mfc_domain = global_domain and */ mfc_field = "SoftspeedIR_inv" exclusive-lock: end.
   if not available mfc_ctrl then do:
      create mfc_ctrl.
      assign
         /* mfc_domain = GLOBAL_domain */
         mfc_field   = "SoftspeedIR_inv"
         mfc_type    = "I"
         mfc_module  = "SoftspeedIR_inv"
         mfc_seq     = 110
         mfc_integer = 1
         .
   end.
   assign
      SoftspeedIR_inv = mfc_integer
      .

   /* ADD MFC_CTRL FIELD SoftspeedIR_trnbr */
   for first mfc_ctrl where /* mfc_domain = global_domain and */ mfc_field = "SoftspeedIR_trnbr" exclusive-lock: end.
   if not available mfc_ctrl then do:
      create mfc_ctrl.
      assign
         /* mfc_domain = GLOBAL_domain */
         mfc_field   = "SoftspeedIR_trnbr"
         mfc_type    = "I"
         mfc_module  = "SoftspeedIR_trnbr"
         mfc_seq     = 120
         mfc_integer = 0
         .
   end.
   assign
      SoftspeedIR_trnbr = mfc_integer
      .
   
   display
      SoftspeedIR_rqm_nbr
      SoftspeedIR_rqm_next
      SoftspeedIR_Max
      SoftspeedIR_Tol
      SoftspeedIR_VAT
      /*
      SoftspeedIR_so_pre1
      SoftspeedIR_so_pre2
      SoftspeedIR_sod_type1
      SoftspeedIR_sod_type2
      SoftspeedIR_inv_pre1
      SoftspeedIR_inv_pre2
      */
      SoftspeedIR_inv_pre
      SoftspeedIR_inv
      SoftspeedIR_trnbr
   with frame appm-a.

   seta:
   do on error undo, retry:
      set
         SoftspeedIR_rqm_nbr
         SoftspeedIR_rqm_next
         SoftspeedIR_Max
         SoftspeedIR_Tol
         SoftspeedIR_VAT
         /*
         SoftspeedIR_so_pre1
         SoftspeedIR_so_pre2
         SoftspeedIR_sod_type1
         SoftspeedIR_sod_type2
         SoftspeedIR_inv_pre1
         SoftspeedIR_inv_pre2
         */
         SoftspeedIR_inv_pre
         SoftspeedIR_inv
         SoftspeedIR_trnbr
         with frame appm-a.
         {&APPM-P-TAG3}

      /* VALIDATE DIRECTORY */
      /*
      if SoftspeedIR_rqm_nbr = "" then do:
         /* Blank not allowed */
         {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}
         next-prompt SoftspeedIR_rqm_nbr.
         undo seta, retry.
      end.
      */

      find first mfc_ctrl where /* mfc_domain = global_domain and */ mfc_field = "SoftspeedIR_rqm_nbr" no-error.
      if available mfc_ctrl THEN DO:
         mfc_char = SoftspeedIR_rqm_nbr.
         mfc_integer = SoftspeedIR_rqm_next.
      END.

      find first mfc_ctrl where /* mfc_domain = global_domain and */ mfc_field = "SoftspeedIR_Max" no-error.
      if available mfc_ctrl then
         mfc_decimal = SoftspeedIR_Max.
   
      find first mfc_ctrl where /* mfc_domain = global_domain and */ mfc_field = "SoftspeedIR_Tol" no-error.
      if available mfc_ctrl then
         mfc_decimal = SoftspeedIR_Tol.
   
      find first mfc_ctrl where /* mfc_domain = global_domain and */ mfc_field = "SoftspeedIR_VAT" no-error.
      if available mfc_ctrl then
         mfc_integer = SoftspeedIR_VAT.

      /*
      find first mfc_ctrl where mfc_domain = global_domain and mfc_field = "SoftspeedIR_so_pre1" no-error.
      if available mfc_ctrl then
         mfc_char = SoftspeedIR_so_pre1.

      find first mfc_ctrl where mfc_domain = global_domain and mfc_field = "SoftspeedIR_so_pre2" no-error.
      if available mfc_ctrl then
         mfc_char = SoftspeedIR_so_pre2.

      find first mfc_ctrl where mfc_domain = global_domain and mfc_field = "SoftspeedIR_sod_type1" no-error.
      if available mfc_ctrl then
         mfc_char = SoftspeedIR_sod_type1.

      find first mfc_ctrl where mfc_domain = global_domain and mfc_field = "SoftspeedIR_sod_type2" no-error.
      if available mfc_ctrl then
         mfc_char = SoftspeedIR_sod_type2.

      find first mfc_ctrl where mfc_domain = global_domain and mfc_field = "SoftspeedIR_inv_pre1" no-error.
      if available mfc_ctrl then
         mfc_char = SoftspeedIR_inv_pre1.

      find first mfc_ctrl where mfc_domain = global_domain and mfc_field = "SoftspeedIR_inv_pre2" no-error.
      if available mfc_ctrl then
         mfc_char = SoftspeedIR_inv_pre2.
      */

      find first mfc_ctrl where /* mfc_domain = global_domain and  */ mfc_field = "SoftspeedIR_inv_pre" no-error.
      if available mfc_ctrl then
         mfc_char = SoftspeedIR_inv_pre.

      find first mfc_ctrl WHERE /* mfc_domain = global_domain and */ mfc_field = "SoftspeedIR_inv" no-error.
      if available mfc_ctrl then
         mfc_integer = SoftspeedIR_inv.

      find first mfc_ctrl where /* mfc_domain = global_domain and */ mfc_field = "SoftspeedIR_trnbr" no-error.
      if available mfc_ctrl then
         mfc_integer = SoftspeedIR_trnbr.
   END.
end.

status input.
