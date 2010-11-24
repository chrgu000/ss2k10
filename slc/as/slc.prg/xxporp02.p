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
	DEFINE VARIABLE xxrmk as char format "x(15)" label "备注".
	DEFINE VARIABLE xxi   as int label "序" format ">>>" .
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
		ponbr          COLON 18 label "采购单号"
		ponbr1         LABEL {t001.i} COLON 49   
		vend           COLON 18
		vend1          LABEL {t001.i} COLON 49
		pobuyer        COLON 18 label "采购员"
		pobuyer1       COLON 49 label "至"   
		due_date       COLON 18
		due_date1      LABEL {t001.i} COLON 49              
		ord_date       COLON 18 label "下单日期"                
		ord_date1       COLON 49 label "至" skip(1)
		open_only       colon 35 label "仅限未结的采购单"
		new_only      colon 35 label "仅限未打印过的采购单"
		mrp_only      colon 35 label "仅限mrp产生的采购单"
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
      	 xxtemp = "重打".
      
      if avail usr_mstr then do:
      	usrname = usr_name.
      	usrremark = usr_remark.
      	usrmailaddress = usr_mail_address.
      end.
			    

/* ss 20070323 - b */
			FORM  HEADER
			  "隆鑫工业公司四轮车本部" at 50
			  "采购订单" at 56 xxtemp at 120 skip
			  "供应商编号:" at 44 po_vend skip
				"购方:" at 1 "隆鑫工业公司四轮车本部" "采购员:" at 44 usrname format "X(8)"  "Tel:" at 62 usrremark format "x(11)" "FAX:" at 90 usrmailaddress  format "x(11)" skip
				"供方:" at 1 adname "联系人:" at 44 ad_attn format "X(8)"  "Tel:" at 62 ad_phone format "X(15)" "FAX:" at 90 ad_fax  skip
				"采购订单号:" AT 1 po_nbr 
/*SS 20080311 - B*/
				"购方确认:" at 44
/*SS 20080311 - E*/
				"订单日期:" at 90 today string(time,"hh:mm am")      
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
				pod_line	COLUMN-LABEL "序"
				pod_part	COLUMN-LABEL "物料编码" format "x(20)"
				vp_vend_part when avail vp_mstr column-label "旧零件号" format "X(16)"
				pt_mstr.pt_Desc1  column-label "物料名称" format "x(20)"
				pt_mstr.pt_draw when avail pt_mstr column-label "图纸图号" 
				tpt_mstr.pt_desc1 when avail tpt_mstr column-label "旧机型号" format "x(14)"
				pod_qty_ord	COLUMN-LABEL "数量" format "->>>>>>>9"
				pod_um COLUMN-LABEL "单位"
				pod_due_date	COLUMN-LABEL "交货日期"
				xxrmk  COLUMN-LABEL "备注"
			WITH STREAM-IO WIDTH 200.
			
       put "规格描述:" at 5.
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
       put "LK15图号:" at 45 . 
			 if avail cp_mstr then put cp_cust_eco.
			 put "索引号:" at 65.
			 if avail cp_mstr then put cp_cust_partd.
*/

			xxi = xxi + 1.
/*			
			if xxi = 10 then 
			do:
				put skip(1).
				put "购方要求：" skip . 
				put "1、交货地址：重庆市九龙坡区九龙园区华龙大道99号四轮车库房" skip.
				put "2、随货提供该批产品的检测报告，具体要求由购方质量工程师确定。" skip.
				put "3、内外包装均需按购方要求的包装规范及标识格式进行制作和标贴。" skip.
				put "4、供方应在接到此计划后2日内根据合同规定，将订单签字盖章后书面回复给购方。" skip.
				put "购方确认：                                      " .
				put "供方完全理解并接收计划：" skip.
			  put "配套部:                                         ".
			  put "签名:" skip.
			  put " " skip(1).
			  if po_print = no then put "重打".
			  page.
			  xxi = 1.
			end.
			else
			do:
*/
				if last-of(po_nbr) then do:
					put skip(1).
					put "购方要求：" skip . 
					put "1、交货地址：重庆市九龙坡区九龙园区华龙大道99号四轮车库房" skip.
					put "2、随货提供该批产品的检测报告，具体要求由购方质量工程师确定。" skip.
					put "3、内外包装均需按购方要求的包装规范及标识格式进行制作和标贴。" skip.
					put "4、供方应在接到此计划后2日内根据合同规定，将订单签字盖章后书面或邮件回复给购方。" skip(2).
					put "                                                      ".
					put "供方确认:" skip.				  
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

    