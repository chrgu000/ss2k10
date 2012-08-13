/* Rev: eb2+ sp7      Last Modified: 05/07/07      BY: judy Liu         */

{mfdtitle.i}
def var vendor     as char extent 6.
def var pdate      as date initial today.    /***��ӡ����***/.
def var revision   as char.    /***�ɹ����汾***/.
def var vend_phone as char format "x(20)". /***��Ӧ�̵绰***/
def var rmks       as char format "x(80)". /***��ע***/
def var nbr as char.
def var receiver as char.
def var pageno as integer.  /***ҳ��***/.
def var duplicate as char format "x(6)".   /***����***/.
def var i as integer.
def var rcv_from label "��ⵥ/����֪ͨ��" like tr_nbr.
def var rcv_to   label "��" like tr_nbr.
def var mov_from label "ת�Ƶ���" like tr_nbr.
def var mov_to   label "��" like tr_nbr.
def var rmk_from   label "��ע" like tr_rmks.
def var rmk_to     label "��" like tr_rmks.
def var mo_date_from  label "�������" like tr_effdate.
def var mo_date_to    label "��" like tr_effdate.
/*Jch*/
def var site1 like tr_site label "��  ��" initial "DCEC-B".
def var site2 like tr_site label "��" initial "DCEC-C". 
def var flag1    as logical label "ֻ��ӡδ��ӡ�����ջ���".
form  "DCP-03-17-00-02 F002" skip(1)
     "��ⵥ "      at 33 skip(1)
     duplicate  no-labels   at 60
     "��ע:�������ⵥ��" at 1
     "��Ӧ������:"  at 1 ad_name no-labels at 13
     "ҳ��:" at 60  pageno  no-labels at 66 
     "��ӡ����:"   at 1 pdate  no-label  at 9
     "�������/֪ͨ��:" at 30 prh_receiver  no-labels at 46
     "����֪ͨ����:" at 60  prh_rcp_date  no-labels at 74
     "��Ӧ��:"   at 1 prh_vend  no-label at 9
     "�ɹ���:"  at 30  prh_nbr no-labels at 38   
     "�ɹ����汾:" at 60 revision no-label at 72 
     "�绰:"   at 1 vend_phone no-label at 7
     "����������:"   at 30  po_due_date no-labels at 42
     "װ�䵥:"  at 60     prh_ps_nbr   no-labels at 68
     "����Ա:" at 1 pt_article no-label at 9
     "��ע:" at 1 tr_rmks  no-label at 7
/*     "������ⵥ:"  at 1
     tr_nbr        no-labels at 13     */
     SKIP(1)
     "�����           �������                �ص�      ��λ           ������     �������� ������ ��ע"  SKIP
     skip "---------------------------------------------------------------------------------------------"
     with no-box side-labels width 180 frame b.     
        
     
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

 FORM /*GUI*/ 
	     
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
rcv_from colon 20
rcv_to colon 48 skip
/*mov_from colon 20
mov_to colon 48 skip */
mo_date_from colon 20
mo_date_to colon 48 skip
site1 colon 20 
site2 colon 48 skip(1)
flag1 colon 24   
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.
 

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = " ѡ������ ".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

/*judy 07/07/05*/   /* SET EXTERNAL LABELS */
/*judy 07/07/05*/   setFrameLabels(frame a:handle).


	  /* REPORT BLOCK */

	  
/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

    if rcv_to = hi_char then rcv_to = "".
/*    if mov_to = hi_char then mov_to = "". */
    if mo_date_from = low_date then mo_date_from = ?.
    if mo_date_to = hi_date then mo_date_to = ?.
    
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:
	     bcdparm = "".
	     {mfquoter.i rcv_from}
	     {mfquoter.i rcv_to}
/*	     {mfquoter.i mov_from}
	     {mfquoter.i mov_to} */
	     {mfquoter.i mo_date_from}
    	     {mfquoter.i mo_date_to}
	     {mfquoter.i flag1}


/*J0VG *** MOVED TO BELOW QUOTER CALLS - CAUSED PROBLEMS HERE ***************/
/*J034* ** MOVED HI_ VALUES SETTINGS + SITE RANGE CHECK ABOVE QUOTER CALLS */

    if rcv_to = "" then rcv_to = hi_char.
/*    if mov_to = "" then rmk_to = hi_char. */
    if mo_date_from = ? then mo_date_from = low_date.
    if mo_date_to = ? then mo_date_to = hi_date.
/* SELECT PRINTER */
	     
/*GUI*/ end procedure. /* p-report-quote */

/*GUI*/ procedure p-report:

/*GUI*/   {gpprtrpa.i  "window" 132} 
/*{MFSELPRT.I "terminal" 80} */

pageno = 1.
i =1.
for each  tr_hist  no-lock where  (tr_nbr >= rcv_from) and (tr_nbr <= rcv_to)
/*                  and tr_rmks >= mov_from and tr_rmks<=mov_to*/
                  and tr_effdate>=mo_date_from and tr_effdate<=mo_date_to
                 and (tr__log01 = no or (not flag1)) 
                  and (tr_type = "RCT-TR") 
                   and (tr_site >= site1 and tr_site <= site2)  
                  use-index TR_NBR_eff   
                  break by tr_nbr:        
 
   find first prh_hist  where  (prh_receiver = TR_NBR) 
                                        and (prh_part = tr_part) no-lock no-error.
   if available prh_hist then do:

      find first pt_mstr where pt_part = prh_part no-lock no-error.
      find first po_mstr where po_nbr=prh_nbr no-lock no-error.
      find first pod_det where pod_nbr=prh_nbr and pod_line=prh_line no-lock no-error.
      if (not(available pt_mstr)) or ((available pt_mstr and PT_INSP_RQD = yes)) then do:
             find first ad_mstr where ad_addr = prh_vend no-lock no-error.
             if  i = 1  and tr__log01 = no then  do:
                 duplicate = "ԭ��" .
                 disp duplicate ad_name pageno pdate prh_receiver prh_rcp_date prh_vend prh_nbr revision vend_phone
                      po_due_date prh_ps_nbr pt_article tr_rmks with frame b.
             end.
             if  i = 1  and tr__log01 = yes then   do:
                 duplicate = "**����".
                 disp duplicate ad_name pageno pdate prh_receiver prh_rcp_date prh_vend prh_nbr revision vend_phone
                      po_due_date prh_ps_nbr pt_article tr_rmks with frame b.
                 /*tr__log01=no.*/
             end.
             i = i + 1.         
             if available pt_mstr then
                disp tr_part pt_desc2 tr_site pt_um format "x(2)" tr_qty_chg prh_qty_ord pod_due_date /*prh_rcvd */
                     with no-box no-labels width 250 frame c down.
             else
                disp tr_part pt_desc2 tr_site pt_um  format "x(2)" tr_qty_chg prh_qty_ord pod_due_date "����Ų�����" /*prh_rcvd */
                          with no-box no-labels width 250 frame c1 down.
             disp  "---------------------------------------------------------------------------------------"  at 1
                    with width 241 no-box frame f.
             if i >= 6 or last-of(tr_nbr) then do:
                   display "�ɹ�Ա��               �ʼ�Ա��                ����Ա��              ��Ӧ�̣�" 
                     at 1 with width 241 no-box frame f.   
                   pageno = pageno + 1.
                   i = 1.
                   page.
             end.
      end.          
   end.
end. /****end of for each prh_hist...****/   

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
	     {mfphead.i}
if dev = "printer" or dev="print-sm" or dev="PRNT88" or dev="PRNT80" then do:
for each  tr_hist where  (tr_nbr >= rcv_from) and (tr_nbr <= rcv_to)
/*                 and    (tr_rmks >= mov_from) and (tr_rmks <= mov_to) */
                  and tr_effdate>=mo_date_from and tr_effdate<=mo_date_to
                 and (tr__log01 = no or (not flag1)) 
                 and (tr_type = "RCT-TR") 
                 break by tr_nbr:
   find first prh_hist where  (prh_receiver = TR_NBR) 
                                        and (prh_part = tr_part) no-lock no-error.
   if available prh_hist then do:
      find first pt_mstr where pt_part = prh_part no-lock no-error.
      if (not(available pt_mstr)) or ((available pt_mstr and PT_INSP_RQD = yes)) then 
          tr__log01 = yes.
   end.          
end.                          
end.

/*judy 07/07/05*/  {mfreset.i}
end procedure.


/*GUI*/ {mfguirpb.i &flds="rcv_from rcv_to mo_date_from mo_date_to site1 site2  flag1"} /*Drive the Report*/
    



