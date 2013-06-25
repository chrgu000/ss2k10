/* editrrq.p - EDI HISTORY INQUIRY                                           */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.16.1.1 $                                                          */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/25/99   BY: *N002* Steve Nugent       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Old ECO marker removed, but no ECO header exists *K04X*                    */
/* Revision: 1.12  BY: Jean Miller DATE: 04/06/02 ECO: *P056* */
/* Revision: 1.14  BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00G* */
/* Revision: 1.15  BY: Pawel Grzybowski   DATE: 04/08/03 ECO: *P0YY* */
/* Revision: 1.16  BY: Michael Hansen     DATE: 07/14/04 ECO: *Q06H*          */
/* $Revision: 1.16.1.1 $  BY: John Pison  DATE: 12/18/06 ECO: *Q10F*          */
/*-Revision end---------------------------------------------------------------*/


/* DISPLAY TITLE */
{mfdtitle.i "1+ "}
{cxcustom.i "EDITRRQ.P"}

/* DEFINE VARIABLES */
{ictriq2.i}
define variable edigroup like edi_group.
{&ICTRIQ-P-TAG1}
define variable h_wiplottrace_funcs as handle no-undo.
{wlfnc.i} /* FUNCTION DECLARATIONS FOR WIP LOT TRACING */

{&ICTRIQ-P-TAG2}

form
   edigroup    label "�������"  colon 10
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
/* setFrameLabels(frame a:handle). */

find last edi_hist  no-lock no-error.

{wbrp01.i}
seta:
repeat with frame a:

   view frame a.
   view frame b.

   if available edi_hist then
      display edi_group @ edigroup.

   if not {gpiswrap.i} then
      recno = recid(edi_hist).


   if c-application-mode <> 'web' then
   set
      edigroup
   with frame a editing: /* Editing phrase ... */

      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp.i edi_hist edigroup  " edi_group
      "  edigroup edi_group edi_group}

      if recno <> ? then do:

         if available edi_hist then do:

            display edi_group @ edigroup.

            assign
               desc1 = ""
               desc2 = ""
               name = ""
               trtime = string(edi_time,"HH:MM").

            find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part
            = edi_part no-lock no-wait
            no-error.
            if available pt_mstr then do:
               desc1 = pt_desc1.
               desc2 = pt_desc2.
            end.

            find ad_mstr  where ad_addr
            = edi_addr no-lock no-wait
            no-error.

            if available ad_mstr then
               name = ad_name.


            {&ICTRIQ-P-TAG3}

	    
	    display
     	       edi_group       label "�������" colon 10 
	       edi_type        label "����"   colon 55 skip

	       edi_nbr         label "����"   colon 10
               edi_line        label "��"     colon 34  
       	       edi_action      label "����"   colon 55 skip


	       edi_sourcedomain label "Դ��" colon 10
	       edi_entity       label "��Ƶ�λ" colon 34
	       edi_site         label "�ص�" colon 55 skip





	       edi_addr        label "��ַ" colon 10
               name         no-label  format "x(20)"      
              edi_TransQty     label "��������" colon 55 skip(1)

	       edi_part        label "�Ϻ�"   colon 10                                    
       	       edi_trnbr       label "���׺�" colon 55 skip
	       

               edi_Translot    label "����"   colon 10
	       edi_curr        label "�ұ�"   colon 55 skip                           

	       edi_Transref    label "�ο���" colon 10             
	       edi_TransLoc    label "��λ"   colon 55 skip


       

	       edi_qty_ord     label "������" colon 10       
	       edi_due_date    label "������"   colon 34          
	       edi_price       label "�۸�"     colon 55 skip(1)

/*               edi_old_qty_ord  label "�ɶ�����" colon 10
               edi_old_due_date label "�ɵ�����" colon 34
               edi_old_price    label "�ɼ۸�"     colon 55 skip (1)  */


  
	       edi_Sucess       label "�������" colon 10
	       edi_ExposePreSO  label "ǰչ���" colon 34                           
	       edi_ExposeNextSO label "��չ���" colon 55 skip
	       edi_errormsg     label "������Ϣ" colon 10 skip(1)
 

	       edi_targetdomain label "Ŀ����"  colon 10
               edi_ReceiptPO    label "Ŀ�굥��" colon 55 skip

	       if length(edi_userid) = 20 then "EDI" else edi_userid       label "�û���" format "x(18)" colon 10
 	       string(edi_time,"HH:MM")     label "ʱ��"   colon 55 skip


	               
         
             with frame bb side-labels width 80 attr-space.

/*            with frame b. */

         end.
      end.
   end.


   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "terminal"
               &printWidth = 80
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "no"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}

   {mfreset.i}
   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}


end.

{wbrp04.i &frame-spec = a}
