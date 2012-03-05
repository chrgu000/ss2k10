/* rwwcrp.p - WORK CENTER REPORT                                        */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.7.1.5 $                                                     */
/*V8:ConvertMode=FullGUIReport                                          */
/* REVISION: 1.0      LAST MODIFIED: 05/12/86   BY: PML       */
/* REVISION: 4.0      LAST MODIFIED: 02/17/88   BY: RL  *A171**/
/* REVISION: 4.0      LAST MODIFIED: 02/24/88   BY: WUG *A175**/
/* REVISION: 4.0      LAST MODIFIED: 03/28/88   BY: EMB *A192**/
/* REVISION: 6.0      LAST MODIFIED: 05/04/90   BY: RAM *D018**/
/* REVISION: 6.0      LAST MODIFIED: 11/02/90   BY: emb *D175**/
/* REVISION: 7.3      LAST MODIFIED: 02/24/93   BY: sas *G729*/
/* REVISION: 8.5      LAST MODIFIED: 07/31/96   BY: *J12T* Sue Poland         */
/* REVISION: 8.6      LAST MODIFIED: 10/15/97   BY: *K0ZV* bvm                */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb                */
/* Revision: 1.7.1.4  BY: Paul Donnelly (SB)  DATE: 06/28/03  ECO: *Q00L*     */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.7.1.5 $ BY: Katie Hilbert       DATE: 11/14/03  ECO: *Q04M*  */
/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* ����Ϊ�汾��ʷ */                                                             
/* SS - 090224.1 By: Ellen Xu */

/*����Ϊ����˵�� */
/* SS - 090224.1 - RNB
�����б�׼��
SS - 090224.1 - RNE */
/* DISPLAY TITLE */
/*
{mfdtitle.i "1+ "}
*/
/* ��ʾ���µİ汾��.ע����淶 */
{mfdtitle.i "090224.1"}

/* SS - 090224.1 - B */
/* ��һ�����ù������ʱ��.ע������� */
{xxrwwcrp0001.i "new"}
/* SS - 090224.1 - E */

define variable wkctr   like wc_wkctr no-undo.
define variable wkctr1  like wc_wkctr no-undo.
define variable last_wc like wc_wkctr no-undo.

/* SELECT FORM */
form
   wkctr          colon 25
   wkctr1         label "To"
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* REPORT BLOCK */

{wbrp01.i}

repeat:

   if wkctr1 = hi_char then wkctr1 = "".

   if c-application-mode <> 'web' then
      update
         wkctr wkctr1
      with frame a.

   {wbrp06.i &command = update &fields = "  wkctr wkctr1" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      if wkctr1 = "" then wkctr1 = hi_char.

      bcdparm = "".
      {mfquoter.i wkctr  }
      {mfquoter.i wkctr1 }

      last_wc = ?.

   end.

   /* SELECT PRINTER - USES VARIABLES DEV AND PGE */
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
   /* SS - 090224.1 - B            
   ��ֹ��׼ҳü��ҳ�ŵ����,ͬʱ������Ӧ�ļ���,��Ϊ���ñ����๫�ó���
   {mfphead.i}

   for each wc_mstr
      where wc_domain = global_domain
       and (wc_wkctr >= wkctr) and (wc_wkctr <= wkctr1)
   no-lock with frame b width 132 no-attr-space:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).

      /* DON'T PRINT 'SERVICE' WORK CENTERS */
      if wc_fsm_type = "FSM" then next.

      if last_wc <> ? and last_wc <> wc_wkctr then put skip(1).
      if page-size - line-counter < 2 then do:
         page.
         last_wc = ?.
      end.
      if last_wc <> wc_wkctr then display wc_wkctr with frame b.
      last_wc = wc_wkctr.

      display
         wc_mch
         wc_dept
         wc_men_mch column-label "Run Crew"
         wc_mch_op
         wc_lbr_rate
         wc_bdn_rate
         wc_bdn_pct
         wc_mch_bdn
         wc_queue
         wc_wait
         wc_mch_wkctr.

      put skip wc_desc at 10.

      {mfrpchk.i}

   end.    /* for each wc_mstr */

   /* REPORT TRAILER  */
   {mfrtrail.i}
   SS - 090224.1 - E */

   /* SS - 090224.1 - B */
   /* �������ʼ���е�ʱ�� */
   PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.

   /* �����ʱ�� */
   EMPTY TEMP-TABLE ttxxrwwcrp0001.

   /* ���ñ����๫�ó��� */
   {gprun.i ""xxrwwcrp0001.p"" "(
      input wkctr,
      input wkctr1
      )"}

   /* ����÷ֺŷָ��ı���,����ʱ����ֶ�����,Ϊ�˼����,��������ʱ��ı���;ע�������ֶ� */
   EXPORT DELIMITER ";" "wc_wkctr" "wc_mch" "wc_dept" "wc_men_mch" "wc_mch_op" "wc_lbr_rate" "wc_bdn_rate" "wc_bdn_pct" "wc_mch_bdn" "wc_queue" "wc_wait" "wc_mch_wkctr".
   /* ����÷ֺŷָ�����ʱ�� */
   FOR EACH ttxxrwwcrp0001:
      EXPORT DELIMITER ";" ttxxrwwcrp0001.
   END.

   /* �������������е�ʱ��,�Ա��뿪ʼ���е�ʱ��һ�����������Ч�� */
   PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.

   /* ��ֹ�˱�׼ҳ�ŵ���� */
   {xxmfrtrail.i}
   /* SS - 090224.1 - E */

end.   /* repeat */

{wbrp04.i &frame-spec = a}
