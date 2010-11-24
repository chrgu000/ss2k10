/* By: Neil Gao Date: 07/04/25 ECO: * ss 20070425.1 * */

{mfdeclre.i}  
{gplabel.i} 

define input parameter iptrcvr like prh_receiver.
define variable nbr like prh_nbr.
define variable nbr1 like prh_nbr.
define variable vend like prh_vend.
define variable vend1 like prh_vend.
define variable rcvr like prh_receiver.
define variable rcvr1 like prh_receiver.
define variable rcv_date like prh_rcp_date.
define variable rcv_date1 like prh_rcp_date.
define variable new_only like mfc_logical initial yes.
define variable revision like po_rev.
define variable buyer like po_buyer.
define variable tranqty like tr_qty_chg.
define variable pdate like prh_rcp_date.
define variable pages as integer.
define variable old_receiver like prh_receiver.
define variable location like pt_loc.
define variable det_lines as integer.
define variable vendor as character format "x(38)" extent 6.
define variable vend_phone like ad_phone.
define variable duplicate as character format "x(11)".
define variable newline like mfc_logical initial yes.
define variable continue_yn like mfc_logical initial no.
define variable mc-error-number like msg_nbr no-undo.
define variable carnum as character.

define new shared variable prh_recno as recid.

define variable printwo like mfc_logical initial yes.
define variable rmks like po_rmks.
define new shared variable printcmts like mfc_logical initial no.
define variable i as integer.
define variable cont_lbl as character format "x(12)".
define new shared variable tr_count as integer.
define new shared variable maint like mfc_logical initial false no-undo.
define new shared variable po_recno as recid. /* USED FOR RCVR NBR */
define new shared variable receivernbr like prh_receiver.
define new shared variable eff_date like glt_effdate.
define buffer prhhist for prh_hist.
define new shared variable fiscal_id      like prh_receiver.
define new shared variable fiscal_rec     as logical initial false.
define new shared variable msg            as character format "x(60)".

define variable oldsession as character no-undo.
define variable l_prh_recno as recid no-undo.

define variable err-flag as integer no-undo.
define variable old_db like si_db no-undo.

define variable j as integer.
define buffer tpt_mstr for pt_mstr.

find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock no-error.

{pocurvar.i "NEW"}
{txcurvar.i "NEW"}
/* DEFINE TRAILER VARS AS NEW, SO THAT CORRECT _OLD FORMATS */
/* CAN BE ASSIGNED BASED ON INITIAL DEFINE                  */
{potrldef.i "NEW"}
assign
   nontax_old         = nontaxable_amt:format
   taxable_old        = taxable_amt:format
   lines_tot_old      = lines_total:format
   tax_tot_old        = tax_total:format
   order_amt_old      = order_amt:format
   prepaid_old        = po_prepaid:format.

form
   nbr            colon 15
   nbr1           label {t001.i} colon 49
   rcvr           colon 15
   rcvr1          label {t001.i} colon 49
   vend           colon 15
   vend1          label {t001.i} colon 49
   rcv_date       colon 15
   rcv_date1      label {t001.i} colon 49
   carnum         label "���복��" colon 15
   skip(1)
   new_only       colon 30 label "����δ��ӡ�����ջ���"
with frame a attr-space side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
	
nbr  = iptrcvr.
nbr1 = iptrcvr.

view frame a.
find first poc_ctrl  where poc_ctrl.poc_domain = global_domain no-lock no-error.
if available poc_ctrl and poc_rcv_typ = 0 then do:
   continue_yn = no.
   bell.
   {mfmsg01.i 353 2 continue_yn}
   if continue_yn = no then leave.
end.

assign
   rcv_date   = today
   rcv_date1  = today
   oldsession = SESSION:numeric-format.

repeat:
   if nbr1 = hi_char then nbr1 = "".
   if rcvr1 = hi_char then rcvr1 = "".
   if vend1 = hi_char then vend1 = "".
   if rcv_date = low_date then rcv_date = ?.
   if rcv_date1 = hi_date then rcv_date1 = ?.

   update
      nbr nbr1 rcvr rcvr1 vend vend1 rcv_date rcv_date1 carnum new_only
   with frame a.

   bcdparm = "".
   {mfquoter.i nbr}
   {mfquoter.i nbr1}
   {mfquoter.i rcvr}
   {mfquoter.i rcvr1}
   {mfquoter.i vend}
   {mfquoter.i vend1}
   {mfquoter.i rcv_date}
   {mfquoter.i rcv_date1}
   {mfquoter.i new_only}

   if nbr1 = "" then nbr1 = hi_char.
   if rcvr1 = "" then rcvr1 = hi_char.
   if vend1 = "" then vend1 = hi_char.
   if rcv_date = ? then rcv_date = low_date.
   if rcv_date1 = ? then rcv_date1 = hi_date.

   /* SELECT PRINTER */
   {mfselbpr.i "printer" 80}

   assign
      pages = 0
      pdate = today
      old_receiver = ?.

   for each prh_hist no-lock
          where prh_hist.prh_domain = global_domain and (  (prh_nbr >= nbr) and
          (prh_nbr <=nbr1)
         and (prh_receiver >= rcvr) and (prh_receiver <= rcvr1)
         and (prh_vend >= vend) and (prh_vend <= vend1)
         and (prh_rcp_date >= rcv_date) and (prh_rcp_date <= rcv_date1)
         and (prh_print = yes or not new_only)
         and prh_rcp_type = "R"
         ) use-index prh_rcp_date 
   break by prh_nbr by prh_receiver by prh_line:

      assign
         prh_recno = recid(prh_hist).

/*
      if prh_print = no then
      duplicate = "*" + caps(getTermLabel("DUPLICATE",9)) + "*".
*/
/*			if not first(prh_nbr) then page.  */
			
			find pt_mstr 	where pt_domain = global_domain and pt_part = prh_part no-lock no-error.
			find ad_mstr  where ad_mstr.ad_domain = global_domain and  ad_addr = prh_vend  no-lock no-error.
      find po_mstr  where po_mstr.po_domain = global_domain and  po_nbr  = prh_nbr no-lock no-error.
      if not avail po_mstr then next .
      find first pod_det where pod_domain = global_domain and pod_nbr = prh_nbr and 
			pod_line = prh_line no-lock no-error.
      	find first tr_hist where tr_domain = global_domain and tr_nbr = prh_nbr and tr_line = prh_line and
				tr_part = prh_part and tr_lot = prh_receiver and
				tr_type = "cn-rct" no-lock no-error.
				if not avail tr_hist then 
      	find first tr_hist where tr_domain = global_domain and tr_part = prh_part 
				and tr_nbr = prh_nbr and tr_lot = prh_receiver 
				and tr_line = prh_line and tr_type = "iss-prv"	no-lock no-error.

/*   find first cp_mstr where cp_domain = global_domain and cp_cust = "C0001" and cp_part = prh_part no-lock no-error.   */
			find first usr_mstr where usr_userid = global_userid no-lock no-error.
			find first cd_det where cd_domain = global_domain and cd_ref = prh_part and cd_type = "SC" and
				cd_lang = "ch" no-lock no-error.
			find first vp_mstr where vp_domain = global_domain and vp_part = prh_part and  vp_vend = prh_vend no-lock no-error.
			find first tpt_mstr where tpt_mstr.pt_domain = global_domain and tpt_mstr.pt_part = substring(cd_cmmt[1],1,4) no-lock no-error.
/*				
				put "¡�ι�ҵ���޹�˾���ֳ�����" at 40 skip.
				put "�˻���/���ŵ�" at 42 skip(1).
				put "�ɹ�����:" prh_nbr. 
				put "�Ƶ�����:" at 30 today. 
				put " " string(time,"hh:mm am").
				put "���ݺ�:" at 80 prh_receiver skip.
				put "��Ӧ�̴���:" prh_vend.
				put "��Ӧ������:" at 30 ad_name skip.
				put "��������������������������������������������������������������������������������������������������" skip.
				put "�������:" prh_part.
				put "�������:" at 30 pt_mstr.pt_desc1.
				put "��λ:" at 75 pt_mstr.pt_um skip.
				put "���״̬:".
				do j = 1 to 15 : 
        	if (avail cd_det and cd_cmmt[j] <> "") then put cd_cmmt[j] skip.
        	else 
        	do:
        		  if (not avail cd_det and avail pt_mstr) then 
        		  do:
	        			put pt_mstr.pt_desc2 skip.
	        			leave.
	        		end.
          end.
        end.
				put "�˻�����:" string( - prh_rcvd ).    
				put "�˻�ԭ��:" at 30 prh_reason.
				put "��λ:" at 75. 
				if avail tr_hist then 
					put tr_loc.
				put skip.
				put "�ɺ�:" vp_vend_part.
				put "�ɻ���:" at 30 tpt_mstr.pt_desc1 skip.
				put "��������������������������������������������������������������������������������������������������������������" skip. 
				put "�Ƶ�Ա:".
				if avail usr_mstr then  
				  put global_userid.
				put "���Ա:             ����Ա:                 �˻�������: "  at 30 skip.
				put "[����:��� ����:���� ����:��Ӧ�� ����:����]".
*/
				FORM  HEADER
				    "¡�ι�ҵ���޹�˾���ֳ�����" at 40 skip
						"�˻�/���ŵ�" at 48 skip(1)
						"�ɹ�����:" prh_nbr
						"�Ƶ�����:" at 30 today string(time,"hh:mm am")
						"���ݺ�:" at 80 prh_receiver skip
						"��Ӧ�̴���:" prh_vend
						"��Ӧ������:" at 30 ad_name
				WITH STREAM-IO FRAME ph1 PAGE-TOP WIDTH 120 NO-BOX.
				
        view frame ph1.
        
        disp
        	prh_part label "���ϱ���:"
        	vp_vend_part label "�ɺ�" when avail vp_mstr format "x(18)"
        	tpt_mstr.pt_desc1 label "�ɻ���" when avail tpt_mstr format "x(12)"
        	pt_mstr.pt_um label "��λ" 
        	- prh_rcvd label "�˻�����"
        	prh_reason label "ԭ��" 
        	tr_loc label "��λ" 
        with stream-io width 200.
        put pt_mstr.pt_desc1.
        put "����:".
        do j = 1 to 15 : 
        	if (avail cd_det and cd_cmmt[j] <> "") then put cd_cmmt[j] skip.
        	else 
        	do:
        		  if (not avail cd_det and avail pt_mstr) then 
        		  do:
	        			put pt_mstr.pt_desc2 skip.
	        			leave.
	        		end.
          end.
        end. 
  if last-of(prh_nbr) then do:   
		put "��������������������������������������������������������������������������������������������������������������" skip.
		put "�˻�������:" at 1.
		put "����ǩ��:" at 20.
		put "�Ƶ�Ա:" at 40 usr_name format "x(8)".
		put	"���Ÿ���:" at 70 skip. 
		put "[����:��� ����:���� ����:��Ӧ�� ����:����]" at 1.
		put "���䳵��:" at 40 carnum.
		if not last(prh_nbr) then page.
	end.
      {mfrpexit.i}

      /* TRAILER */
      
      find prhhist where recid(prhhist) = prh_recno exclusive-lock.
      /* CHANGE PRINT FLAG TO "NO" */
      if available prhhist then
         prhhist.prh_print = no.

   end.
   /* End Processing prh_hist */
   {mfreset.i}

end.
SESSION:numeric-format = oldsession.
hide frame a no-pause.
