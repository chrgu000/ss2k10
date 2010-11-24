/* xxporp01.p   *********** PURCHASE ORDER PRINT                      */
/* Copyright 2004-2004 PegSoft GZ                                     */
/* All rights reserved worldwide.  This is an unpublished work.       */
/* By: Neil Gao Date: 20070323 ECO: * ss 200703230* */
/* By: Neil Gao Date: 20080109 ECO: * ss 20080109 * */
/* By: Neil Gao Date: 20080126 ECO: * ss 20080126 * */
/* By: Neil Gao Date: 20080226 ECO: * ss 20080226 * */

	{mfdtitle.i "b+ "}

	DEFINE VARIABLE vend      LIKE po_vend       NO-UNDO.
	DEFINE VARIABLE vend1     LIKE po_vend       NO-UNDO.
	DEFINE VARIABLE ponbr     LIKE po_nbr        NO-UNDO.
	DEFINE VARIABLE ponbr1    LIKE po_nbr        NO-UNDO.
	DEFINE VARIABLE due_date  LIKE pod_due_date    NO-UNDO.
	DEFINE VARIABLE due_date1 LIKE pod_due_date    NO-UNDO.
	DEFINE VARIABLE ord_date  LIKE po_ord_date     NO-UNDO.
	DEFINE VARIABLE ord_date1 LIKE po_ord_date     NO-UNDO.
	DEFINE VARIABLE pobuyer   LIKE po_buyer   NO-UNDO.
	DEFINE VARIABLE pobuyer1  LIKE po_buyer  NO-UNDO.
	DEFINE VARIABLE wpage     AS integer format ">>>" init 1.
	DEFINE VARIABLE wct_desc  LIKE ct_desc NO-UNDO.
	DEFINE VARIABLE i		AS	INTEGER.
/* ss 20070323 - b */
	DEFINE VARIABLE xxrmk as char format "x(15)" label "��ע".
	DEFINE VARIABLE xxi   as int label "��" format ">>>" .
	define variable new_only like mfc_logical initial yes.
	define variable open_only like mfc_logical initial yes.
	define variable v_ok  as logical.
	define variable adname like ad_name.
	define variable j as integer.
	define buffer tpt_mstr for pt_mstr.
	define variable xxtemp as character.
	define variable usrname like usr_name.
	define variable usrremark like usr_remark.
	define variable usrmailaddress like usr_mail_address.
/* ss 20070323 - e */
/* ss 20070126 - b */
	define variable mrp_only as logical init no.
/* ss 20070126 - e */


	FORM
		ponbr          COLON 18 label "�ɹ�����"
		ponbr1         LABEL {t001.i} COLON 49   
		vend           COLON 18
		vend1          LABEL {t001.i} COLON 49
		pobuyer        COLON 18 label "�ɹ�Ա"
		pobuyer1       COLON 49 label "��"   
		due_date       COLON 18
		due_date1      LABEL {t001.i} COLON 49              
		ord_date       COLON 18 label "�µ�����"                
		ord_date1       COLON 49 label "��" skip(1)
		open_only       colon 35 label "����δ��Ĳɹ���"
		new_only      colon 35 label "����δ��ӡ���Ĳɹ���"
		mrp_only      colon 35 label "����mrp�����Ĳɹ���"
		skip(1)
	WITH FRAME a SIDE-LABELS WIDTH 80 attr-space.
	setFrameLabels(FRAME a:HANDLE).

	pobuyer = global_userid.
	pobuyer1 = global_userid.
		

	{wbrp01.i}
	REPEAT ON ENDKEY UNDO, LEAVE:
		IF vend1		= hi_char	THEN vend1		= "".
		IF ponbr1			= hi_char	THEN ponbr1		= "".
		IF pobuyer1 = hi_char THEN pobuyer1 = "".
		IF due_date		= low_date	THEN due_date	= ?.
		IF due_date1	= hi_date	THEN due_Date1	= ?.
		IF ord_date = low_date THEN ord_date = ?.
		IF ord_date1 = hi_date THEN ord_date1 = ?.
		
		
		IF c-application-mode <> 'web':u THEN
			UPDATE
				ponbr ponbr1 vend vend1 pobuyer pobuyer1 due_date due_date1 ord_date ord_date1
				open_only new_only mrp_only
			WITH FRAME a.

		{wbrp06.i &command = UPDATE
			&fields = "ponbr ponbr1 vend vend1 due_date due_date1 ord_date ord_date1 open_only new_only mrp_only "
			&frm = "a"}

		IF (c-application-mode <> 'web':u) OR
			(c-application-mode = 'web':u AND
			(c-web-request begins 'data':u)) THEN DO:
			bcdparm = "".
			{mfquoter.i vend   }
			{mfquoter.i vend1 }
			{mfquoter.i ponbr   }
			{mfquoter.i ponbr1   }
			{mfquoter.i pobuyer}
			{mfquoter.i pobuyer1}
			{mfquoter.i due_date}
			{mfquoter.i due_date1}
			{mfquoter.i ord_date}
			{mfquoter.i ord_date1}

			IF vend1		= ""	THEN vend1		= hi_char.
			IF ponbr1			= ""	THEN ponbr1		= hi_char.
			IF pobuyer1 = "" THEN pobuyer1 = hi_char.
			IF due_date		= ?		THEN due_date	= low_date.
			IF due_date1	= ?		THEN due_date1	= hi_date.
			IF ord_date		= ?		THEN ord_date	= low_date.
			IF ord_date1	= ?		THEN ord_date1	= hi_date.
		END.

        {mfselprt.i "printer" 132}

		wpage = 0.
		xxi   = 1.
	
		FOR EACH po_mstr WHERE po_domain = global_domain and  po_nbr >= ponbr AND po_nbr <= ponbr1
			AND po_vend >= vend AND po_vend <= vend1 
			and (po_print or not new_only)
			and po_buyer >= pobuyer and po_buyer <= pobuyer1
			and po_ord_date >=ord_date and po_ord_date <= ord_date1
			and ( po_stat = "" or not open_only )  NO-LOCK,
		EACH pod_det WHERE pod_domain = global_domain and pod_nbr = po_nbr
			AND pod_due_date >= due_date AND pod_due_date <= due_date1 
			and ( pod_status = "" or not open_only ) 
			and ( pod_req_nbr <> "" or not mrp_only ) NO-LOCK,
		EACH pt_mstr WHERE pt_domain = global_domain and pt_part = pod_part 
/* ss 20080226  and pt_buyer >= pobuyer and pt_buyer <= pobuyer1*/
		NO-LOCK break by po_nbr:

			/*Kaine*  ACCUMULATE pod_qty_ord * pod_pur_cost (total by po_nbr).  */

			FIND FIRST ad_mstr WHERE ad_domain = global_domain and ad_addr = po_vend NO-LOCK NO-ERROR.
			FIND FIRST ct_mstr  WHERE ct_domain = global_domain and ct_code = po_cr_terms NO-LOCK NO-ERROR.
			find first cp_mstr where cp_domain = global_domain and cp_part = pt_part no-lock no-error.
			
			IF AVAILABLE ct_mstr THEN DO:
				wct_desc = ct_desc.
			END.
			ELSE DO:
				wct_desc = "".
			END.
			
			if avail ad_mstr then adname = ad_name.
			else adname = "".

/*      find first cp_mstr where cp_domain = global_domain and cp_cust = "C0001" and cp_part = tr_part no-lock no-error.   */
      find first usr_mstr where usr_mstr.usr_userid = po_buyer  no-lock no-error.
      find first cd_det where cd_domain = global_domain and cd_ref = pod_part and cd_type = "SC" and
				cd_lang = "ch" no-lock no-error.
			find first vp_mstr where vp_domain = global_domain and vp_part = pod_part and  vp_vend = po_vend no-lock no-error.
			find first tpt_mstr where tpt_mstr.pt_domain = global_domain and tpt_mstr.pt_part = substring(cd_cmmt[1],1,4) no-lock no-error.

      if po_print = no then 
      	 xxtemp = "�ش�".
      
      if avail usr_mstr then do:
      	usrname = usr_name.
      	usrremark = usr_remark.
      	usrmailaddress = usr_mail_address.
      end.
			    

/* ss 20070323 - b */
			FORM  HEADER
			  "¡�ι�ҵ��˾���ֳ�����" at 50
			  "�ɹ�����" at 56 xxtemp at 120 skip
			  "��Ӧ�̱��:" at 44 po_vend skip
				"����:" at 1 "¡�ι�ҵ��˾���ֳ�����" "�ɹ�Ա:" at 44 usrname format "X(8)"  "Tel:" at 62 usrremark format "x(11)" "FAX:" at 90 usrmailaddress  format "x(11)" skip
				"����:" at 1 adname "��ϵ��:" at 44 ad_attn format "X(8)"  "Tel:" at 62 ad_phone format "X(15)" "FAX:" at 90 ad_fax  skip
				"�ɹ�������:" AT 1 po_nbr 
/*SS 20080311 - B*/
				"����ȷ��:" at 44
/*SS 20080311 - E*/
				"��������:" at 90 today string(time,"hh:mm am")      
			WITH STREAM-IO FRAME phead PAGE-TOP WIDTH 132 NO-BOX.
/* ss 20070323 - e */

			VIEW FRAME phead.


/* ss 20080109 - b */
			xxrmk = "".
			if pt_mstr.pt_rev = "D" then do:
				/*xxrmk = pod_so_job.*/
				find first wo_mstr where wo_domain = global_domain and wo_lot = pod_so_job no-lock no-error.
				if avail wo_mstr then do:
					xxrmk = wo_so_job.
				end.
			end.
/* ss 20080109 - e */

			DISPLAY
				pod_line	COLUMN-LABEL "��"
				pod_part	COLUMN-LABEL "���ϱ���" format "x(20)"
				vp_vend_part when avail vp_mstr column-label "�������" format "X(16)"
				pt_mstr.pt_Desc1  column-label "��������" format "x(20)"
				pt_mstr.pt_draw when avail pt_mstr column-label "ͼֽͼ��" 
				tpt_mstr.pt_desc1 when avail tpt_mstr column-label "�ɻ��ͺ�" format "x(14)"
				pod_qty_ord	COLUMN-LABEL "����" format "->>>>>>>9"
				pod_um COLUMN-LABEL "��λ"
				pod_due_date	COLUMN-LABEL "��������"
				xxrmk  COLUMN-LABEL "��ע"
			WITH STREAM-IO WIDTH 200.
			
       put "�������:" at 5.
			 do j = 1 to 15 : 
        	if (avail cd_det and cd_cmmt[j] <> "") then put cd_cmmt[j].
        	else 
        	do:
        		  if (not avail cd_det and avail pt_mstr) then
        		  do:
		        			put pt_mstr.pt_desc2.
		        			leave.
        		  end.
          end.
        end.
        
        usrname = "".
      	usrremark = "".
      	usrmailaddress = "".

/*			 
       put "LK15ͼ��:" at 45 . 
			 if avail cp_mstr then put cp_cust_eco.
			 put "������:" at 65.
			 if avail cp_mstr then put cp_cust_partd.
*/

			xxi = xxi + 1.
/*			
			if xxi = 10 then 
			do:
				put skip(1).
				put "����Ҫ��" skip . 
				put "1��������ַ�������о�����������԰���������99�����ֳ��ⷿ" skip.
				put "2������ṩ������Ʒ�ļ�ⱨ�棬����Ҫ���ɹ�����������ʦȷ����" skip.
				put "3�������װ���谴����Ҫ��İ�װ�淶����ʶ��ʽ���������ͱ�����" skip.
				put "4������Ӧ�ڽӵ��˼ƻ���2���ڸ��ݺ�ͬ�涨��������ǩ�ָ��º�����ظ���������" skip.
				put "����ȷ�ϣ�                                      " .
				put "������ȫ��Ⲣ���ռƻ���" skip.
			  put "���ײ�:                                         ".
			  put "ǩ��:" skip.
			  put " " skip(1).
			  if po_print = no then put "�ش�".
			  page.
			  xxi = 1.
			end.
			else
			do:
*/
				if last-of(po_nbr) then do:
					put skip(1).
					put "����Ҫ��" skip . 
					put "1��������ַ�������о�����������԰���������99�����ֳ��ⷿ" skip.
					put "2������ṩ������Ʒ�ļ�ⱨ�棬����Ҫ���ɹ�����������ʦȷ����" skip.
					put "3�������װ���谴����Ҫ��İ�װ�淶����ʶ��ʽ���������ͱ�����" skip.
					put "4������Ӧ�ڽӵ��˼ƻ���2���ڸ��ݺ�ͬ�涨��������ǩ�ָ��º�������ʼ��ظ���������" skip(2).
					put "                                                      ".
					put "����ȷ��:" skip.				  
				  xxi = 1.
				  if not last(po_nbr) then page.
				 end.
		END.


		{mfreset.i}
		{mfgrptrm.i}
		
		v_ok = true.
   /* Have all documents printed correctly? */
   {pxmsg.i &MSGNUM=7158 &ERRORLEVEL=1 &CONFIRM=v_ok }
   if v_ok then do:
   		FOR EACH po_mstr use-index po_buyer	WHERE po_domain = global_domain and  po_nbr >= ponbr AND po_nbr <= ponbr1
					AND po_vend >= vend AND po_vend <= vend1 and po_print
					and po_buyer >= pobuyer and po_buyer <= pobuyer1
					and po_ord_date >=ord_date and po_ord_date <= ord_date1
					and po_stat = "" ,
				EACH pod_det WHERE pod_domain = global_domain and pod_nbr = po_nbr
					AND pod_due_date >= due_date AND pod_due_date <= due_date1 
					and pod_status = "" 
					and ( pod_req_nbr <> "" or not mrp_only ) no-lock:
					po_print = no.
			end.
   end.
	END.
	{wbrp04.i &frame-spec = a}

    