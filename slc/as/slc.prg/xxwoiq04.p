/* Creation: eB21SP3 Chui Last Modified: 20071214 By: Davild Xu *ss-20071214.1*/
/*�ɹ��ƻ�����
1.  ��ר���Ķ���Ҫ�б��--*--��IDǰ	20071225
2. ���������������ɸѡ���������깤+δ�깤/���깤/δ�깤��
�깤��������ת��Ʒ�ϸ������֮�ͣ����������������������֮��

*/
    {mfdtitle.i "b+ "}
 	DEFINE VARIABLE lot       LIKE wo_lot       no-UNDO.
	DEFINE VARIABLE lot1      LIKE wo_lot       NO-UNDO.
	DEFINE VARIABLE nbr       LIKE wo_nbr        NO-UNDO .
	DEFINE VARIABLE nbr1      LIKE wo_nbr        NO-UNDO .
	DEFINE VARIABLE status2    as char.
	DEFINE VARIABLE status1   as char .
	DEFINE VARIABLE rel   like wo_rel_date.
	DEFINE VARIABLE rel1  like wo_rel_date.
	DEFINE VARIABLE line  LIKE pt_prod_line .
	DEFINE VARIABLE line1 LIKE pt_prod_line .
	DEFINE VARIABLE tmp_char as char format "x(76)" label "״̬˵��" .
	DEFINE VARIABLE tmp_plan_type as char format "x(8)" .
	DEFINE VARIABLE tmp_qty_ord like wo_qty_ord .
	DEFINE VARIABLE i as integer .
	DEFINE VARIABLE k as integer .
	DEFINE VARIABLE tmp_seq as integer .
	define variable yn1 as logical.
	define variable oldname like pt_desc1.

define temp-table xxwo_mstr
	field 	xxwo_rel_date	like wo_rel_date	
	field 	xxwo_vend	like wo_vend	
	field 	xxwo_seq	as inte 	
	field 	xxwo_part	like wo_part	
	field 	xxwo_qty_ord	like wo_qty_ord	
	field 	xxwo_char	as char format "x(108)" extent 30 
	field 	xxwo_lot	like wo_lot	
	field 	xxwo_nbr	like wo_nbr	
	field 	xxwo_qty_comp	like wo_qty_comp	
	field 	xxwo_plan_type	as char 
	field 	xxwo_so_saler	as char 
	field 	xxwo_time	as inte
	field 	xxwo_qty_line	like wo_qty_comp
	field 	xxwo_qty_pack	like wo_qty_comp
	field 	xxwo_qty_rct	like wo_qty_comp
	field 	xxwo_sod_qty_ord like wo_qty_comp
	index xxdatetime xxwo_vend xxwo_rel_date xxwo_time
	
	.
DEFINE VARIABLE sel as inte .
/*---Add Begin by davild 20080107.1*/
DEFINE VARIABLE qty_pack like ld_qty_oh .
DEFINE VARIABLE qty_line like ld_qty_oh .
DEFINE VARIABLE qty_ruku like ld_qty_oh .
DEFINE VARIABLE qty_cuku like ld_qty_oh .
/*---Add End   by davild 20080107.1*/
sel = 4 .
	FORM
		nbr            COLON 18
		nbr1           LABEL {t001.i} COLON 49
		lot           COLON 18
		lot1          LABEL {t001.i} COLON 49
		status1           COLON 18
		status2          LABEL {t001.i} COLON 49
		line           COLON 18
		line1          LABEL {t001.i} COLON 49
		rel       COLON 18
		rel1      LABEL {t001.i} COLON 49
		yn1       label "�Ƿ���ʾ��Ʒ����" colon 18 skip(1)
		sel	colon 18 label "ѡ��" format ">9"	skip
		"1. ��  ��" colon 18
		"2. δ�깤" colon 18
		"3. δ����" colon 18
		"4. ȫ  ��" colon 18	skip (1)
	WITH FRAME a SIDE-LABELS WIDTH 80 attr-space .
	setFrameLabels(FRAME a:HANDLE).

	{wbrp01.i}
	REPEAT ON ENDKEY UNDO, LEAVE:
hide all no-pause .
view frame dtitle .
	   /*��������ĳ�ʼ��-BEGIN*/
		IF lot1	= hi_char	THEN lot1	= "".
		IF line1	= hi_char	THEN line1	= "".
		IF nbr1		= hi_char	THEN nbr1	= "".
		IF rel	= low_date	THEN rel	= ?.
		IF rel1	= hi_date	THEN rel1	= ?.
		IF status2	= hi_char	THEN status2	= "".


		IF c-application-mode <> 'web':u THEN
			UPDATE
				nbr nbr1 lot lot1 status1 status2 line line1 rel rel1 sel yn1
			WITH FRAME a.

		{wbrp06.i &command = UPDATE
			&fields = "nbr nbr1 lot lot1 status1 status2 line line1 rel rel1 sel yn1"
			&frm = "a"}

		IF (c-application-mode <> 'web':u) OR
			(c-application-mode = 'web':u AND
			(c-web-request begins 'data':u)) THEN DO:
			bcdparm = "".
			{mfquoter.i lot   }
			{mfquoter.i lot1  }
			{mfquoter.i status2  }
			{mfquoter.i status1  }
			{mfquoter.i nbr    }
			{mfquoter.i nbr1   }
			{mfquoter.i line   }
			{mfquoter.i line1  }
			{mfquoter.i rel }
			{mfquoter.i rel1}
			{mfquoter.i sel}
			{mfquoter.i yn1}

			IF lot1		= ""	THEN lot1	= hi_char.
			IF status2	= ""	THEN status2	= hi_char.
			IF line1	= ""	THEN line1	= hi_char.
			IF nbr1		= ""	THEN nbr1	= hi_char.
			IF rel	= ?	THEN rel	= low_date.
			IF rel1	= ?	THEN rel1	= hi_date.
		END.
          /*��������ĳ�ʼ��-END*/
          /*{mfselprt.i "printer" 132}*/	/*---Remark by davild 20071214.1*/
        {gpselout.i
            &printType = "printer"
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
            &defineVariables = "yes"
        }
	
	FOR EACH  xxwo_mstr :
		delete xxwo_mstr .
	END.
	FOR EACH wo_mstr  where wo_domain = global_domain
		and wo_nbr >= nbr and wo_nbr <= nbr1
		and wo_lot >= lot and wo_lot <= lot1
		and wo_status >= status1 and wo_status <= status2
		and wo_rel_date >= rel and wo_rel_date <= rel1
		and wo_vend >= line and wo_vend <= line1
		and (wo_status = "a" or wo_status = "r" or wo_status = "c")
		
		NO-LOCK
		break by wo_vend by wo_rel_date:

		tmp_char = "" .
		find first cd_det where cd_domain = wo_domain
			and cd_ref = wo_part
			and cd_type = "SC"
			and cd_lang = "CH"
			and cd_seq  = 0
			no-lock no-error.
		if avail cd_det then do:
			do i = 1 to 15 :
				if trim(cd_cmmt[i]) <> "" then
				assign tmp_char = tmp_char + trim(cd_cmmt[i]) .
			end.			
		end.
		/*20071223����Ҫ��--״̬˵��+����˵��--BEGIN*/
		find first sod_det where sod_domain = wo_domain and sod_nbr = substring(wo_nbr,1,8) 
					and sod_line = inte(substring(wo_nbr,9,3)) no-lock no-error.
		if avail sod_det then do:
			
			find first cmt_det where cmt_domain = wo_domain and cmt_indx = sod_cmtindx 
				and cmt_seq = 0		/*�û���������1 ,��ϵͳ���0*/
				no-lock no-error.
			if avail cmt_det then do:
				do i = 1 to 15 :
					if trim(cmt_cmmt[i]) <> "" then do:
						if i = 1 then assign tmp_char = tmp_char + "(" .
						
						assign tmp_char = tmp_char + trim(cmt_cmmt[i]) .
					end.
					else do: 
						if i > 1 then assign tmp_char = tmp_char + ")" . 
						leave . 
					end .
				end.
			end.
		end.
		/*20071223״̬˵��+����˵��--END*/
		k = 1 .
		run getstring(input tmp_char ,input 108, output tmp_char ,output k) .
		
		if substring(wo_nbr,1,1) = "1" then assign tmp_plan_type = "��ó" .
		else if substring(wo_nbr,1,1) = "2" then assign tmp_plan_type = "Ӫ��" .
		else if substring(wo_nbr,1,1) = "3" then assign tmp_plan_type = "����" .
		else assign tmp_plan_type = "" .
		tmp_qty_ord = wo_qty_ord .
		find first so_mstr where so_domain = wo_domain and so_nbr = wo_so_job no-lock no-error.
		
		/*�ɹ�����+������3+���+��Ʒ״̬��+�ɹ���+״̬����+�ɹ���+�ɹ�����+�����+�ƻ�����+ҵ��Ա 
		Sort by ������3+���*/		/*����20071218Ҫ��---Remark by davild 20071218.1*/


		/*����ֻ�� �ɹ�����+������+��ţ�2λ��
		 +��Ʒ״̬��+�ɹ�����3λ������
		 +�ɹ���+״̬������40λ���У�+ҵ��Ա*/	/*����20071219Ҫ��---Add by davild 20071219.1*/
		if avail so_mstr then do:
			find first ad_mstr where ad_domain = so_domain and ad_addr = so_slspsn[1] no-lock no-error.
		end.
		
		create xxwo_mstr .
		assign 
			xxwo_rel_date	=	wo_rel_date	
			xxwo_vend	=	wo_vend		
			/*xxwo_seq	=	2 /*tmp_seq*/ 	  	*/	/*---Remark by davild 20071214.1*/
			xxwo_part	=	wo_part		
			xxwo_qty_ord	=	wo_qty_ord	
			/*xxwo_char	=	tmp_char*/	
			xxwo_lot	=	wo_lot		
			xxwo_nbr	=	wo_nbr		
				
			xxwo_time	=	wo__dec01	/*-Data from neil--Add by davild 20071220.1*/	
			xxwo_plan_type	=	tmp_plan_type	
			xxwo_so_saler	=	if avail ad_mstr then ad_name else "" 
			.
			
			/*FOR EACH  tr_hist where tr_domain =  global_domain 				
				and tr_part = wo_part
				/*and tr_nbr = wo_nbr 
				and tr_lot = lot */
				and tr_type = "iss-tr" 
				and substr(tr_loc,1,1) = "w"	/*�����߲�λ--SIMON*/
				NO-LOCK:
				/*�����= VIN�� --SIMON ��ϵͳ���̲�һ����������20071225--*/
				find first xxsovd_det where xxsovd_domain = global_domain 
					and xxsovd_id1 = tr_serial no-lock no-error.
				if avail xxsovd_det and xxsovd_wolot = xxwo_lot then
				assign xxwo_qty_comp	= xxwo_qty_comp + (0 - tr_qty_chg) .		/*�깤��������ת��Ʒ�ϸ������֮��*/
			END.
			*/
			/*---Add Begin by Billy 20081227*/
			  /*
			  input wolot ����ID
			  output qty_pack ������
			  output qty_line ������
			  output qty_ruku �����
			  output qty_cuku ������
			  */
			 {gprun.i ""xxddgetxxsovdqty.p"" 
   			"(input wo_lot,
   				output qty_pack,
   				output qty_line,
   				output qty_ruku,
   				output qty_cuku)"
   				}

			/*---Add End   by davild 20080107.1*/
			do i = 1 to k:
				assign xxwo_char[i] = ENTRY(i, tmp_char, "^") .
			end.
			/*---Add Begin by davild 20071214.1*/
			find first sod_det where sod_domain = wo_domain and sod_nbr = wo_so_job and sod_part = wo_part no-lock no-error.
			assign
			xxwo_qty_line	= qty_pack		/*���������������������֮��*/
			xxwo_qty_pack	= qty_line
			xxwo_qty_rct	= qty_ruku
			xxwo_qty_comp   = qty_ruku
			xxwo_sod_qty_ord = if avail sod_det then sod_qty_ord else 0 .

			/*---Add End   by davild 20071214.1*/

	END.
	
	/*�����������--BEGIN*/
	FOR EACH  xxwo_mstr  
		NO-LOCK break by xxwo_rel_date by xxwo_vend by xxwo_time :
		if first-of(xxwo_vend) then k = 1.
		assign xxwo_seq = k .
			
			/*��ͷFORM--BEGIN*/
			FORM  HEADER
			        skip(1)
                        "�ɹ����´��ѯ����" AT 50
			        "��ӡʱ��:" AT 80 TODAY STRING(TIME,"HH:MM") skip
	                  SKIP(1) 
			WITH STREAM-IO FRAME phead PAGE-TOP WIDTH 132 NO-BOX.
			VIEW FRAME phead.
			/*VIEW FRAME pbottomc.*/
			/*��ͷFORM--END*/
		/*1.��ר���Ķ���Ҫ�б��--*--begin*/
		find first xxsob_det where xxsob_domain = global_domain and xxsob_nbr = substring(xxwo_nbr,1,8)
			and xxsob_line = integer(substring(xxwo_nbr,9,3)) and xxsob_user2 <> "" no-lock no-error.
		if avail xxsob_det then assign xxwo_lot = "*" + xxwo_lot .
		/*1.��ר���Ķ���Ҫ�б��--*--end*/

		/*2.�깤��������ת��Ʒ�ϸ������֮�ͣ����������������������֮��--begin*/

		/*2.�깤��������ת��Ʒ�ϸ������֮�ͣ����������������������֮��--end*/
		if sel = 1 and xxwo_qty_ord <> xxwo_qty_comp then next .	/*�깤*/
		if sel = 2 and xxwo_qty_ord = xxwo_qty_comp then next .		/*δ�깤*/
		if sel = 3 and xxwo_qty_line <> 0 then next.
		
		find first pt_mstr where pt_domain = global_domain and pt_part = xxwo_part no-lock no-error.
		if avail pt_mstr then
			oldname = pt_desc1.
    
    if yn1 then 
    	do:
				display 
					xxwo_rel_date	column-label "�ɹ�����"              
					xxwo_vend	column-label "��"	format "x(3)"
					string(xxwo_time,"HH:MM")	column-label "ʱ��"  
					xxwo_part	column-label "��Ʒ"            
					oldname   column-label "�ϻ���"   
					xxwo_sod_qty_ord column-label "����!��"  format ">>>9"	/*---Add by davild 20071221.1*/
					xxwo_qty_ord	column-label "�ɹ�!��"   format ">>>9"
					/*xxwo_char[1]	column-label "״̬����"              */		
					/*--״̬�����ڵڶ��д�80�з���-Remark by davild 20071228.1*/             
					xxwo_lot	column-label "�ɹ���"      format "x(9)"          
					xxwo_nbr	column-label "�ɹ�����"	             
					xxwo_qty_line	column-label "��!����"  format ">>>9" 
					xxwo_qty_pack	column-label "����"  format ">>>9" 
					xxwo_qty_rct	column-label "���"  format ">>>9" 					
					xxwo_plan_type	column-label "�ƻ�!����"	format "x(4)"
					xxwo_so_saler	column-label "ҵ��Ա"  
					with stream-io width 300.
		
				/*---Add Begin by davild 20071219.1*/
				k = k + 1 .
				do i = 1 to 15 :
					if trim(xxwo_char[i]) <> "" then do:			
						PUT xxwo_char[i] AT 1  .				
					end.			
				end.
				put skip (1).
			end.
		else
			do:
				display 
					xxwo_rel_date	column-label "�ɹ�����"              
					xxwo_vend	column-label "��"	format "x(3)"
					string(xxwo_time,"HH:MM")	column-label "ʱ��"
					xxwo_part	column-label "��Ʒ"            
					oldname   column-label "�ϻ���"   
					xxwo_sod_qty_ord column-label "����!��"  format ">>>9"	/*---Add by davild 20071221.1*/
					xxwo_qty_ord	column-label "�ɹ�!��"   format ">>>9"
					/*xxwo_char[1]	column-label "״̬����"              */		
					/*--״̬�����ڵڶ��д�80�з���-Remark by davild 20071228.1*/             
					xxwo_lot	column-label "�ɹ���"      format "x(9)"          
					xxwo_nbr	column-label "�ɹ�����"	             
					xxwo_qty_line	column-label "��!����"  format ">>>9" 
					xxwo_qty_pack	column-label "����"  format ">>>9" 
					xxwo_qty_rct	column-label "���"  format ">>>9" 					
					xxwo_plan_type	column-label "�ƻ�!����"	format "x(4)"
					xxwo_so_saler	column-label "ҵ��Ա"  
					with stream-io width 300.
		  end.		
		
		
		/*---Add End   by davild 20071219.1*/

		/*---Add Begin by davild 20071228.1*/
		/*������������С��*/
		accumulate xxwo_qty_ord (total by xxwo_vend by xxwo_rel_date) .
		if last-of(xxwo_rel_date) then do:
			/*down 1.*/
			underline xxwo_rel_date xxwo_vend xxwo_part xxwo_qty_ord .
			down 1.
			display 
				xxwo_rel_date @ xxwo_rel_date
				xxwo_vend @ xxwo_vend
				"С  ��:" @ xxwo_part
				(accum total by xxwo_rel_date xxwo_qty_ord ) @ xxwo_qty_ord .
			down 1 .
		end.
		/*---Add End   by davild 20071228.1*/
	END.
	/*�����������--END*/
	
	{mfreset.i}
	{mfgrptrm.i}

	END.

	{wbrp04.i &frame-spec = a}


PROCEDURE getstring:
		define input  parameter iptstring as char.
		define input  parameter iptlength as int.
		define output parameter optstring as char.
		define output parameter xxk as int.	/*---Add by davild 20071220.1*/
		define var xxs as char.
		define var xxss as char.
		define var xxi as int.
		define var xxj as int.
		
		optstring = "".
		xxss = "".
		xxi = 1.
		
		if iptlength < 2 then return.
		
		repeat while xxi <= length(iptstring,"RAW") :
			xxs = substring(iptstring,xxi,1).
			if length( xxss + xxs , "RAW") > iptlength then do:
				optstring = optstring + xxss + "^".
				xxss = "".
				next.
			end.
			xxi = xxi + 1.
			xxss = xxss + xxs.
		end.
		optstring = optstring + xxss.

		/*---Add Begin by davild 20071220.1*/
		xxk = 1 .
		do xxj = 1 to length(optstring):
			if substring(optstring,xxj,1) = "^" then assign xxk = xxk + 1.
		end.
		/*---Add End   by davild 20071220.1*/
END PROCEDURE.