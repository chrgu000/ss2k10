/* Creation: eB21SP3 Chui Last Modified: 20071214 By: Davild Xu *ss-20071214.1*/
/* Creation: eB21SP3 Chui Last Modified: 20080104 By: Davild Xu *ss-20080104.1*/
/*---Add Begin by davild 20080104.1*/
/*
1. 对指定件在子件料号前加*号
2. 状态说明可以用户选择要不要打印
*/
/*---Add End   by davild 20080104.1*/
/*工单差缺查询*/
    {mfdtitle.i "b+ "}
    DEFINE VARIABLE printpar as logi .
    DEFINE VARIABLE printcomp as logi .
 	DEFINE VARIABLE lot       LIKE wo_lot       no-UNDO.
	DEFINE VARIABLE lot1      LIKE wo_lot       NO-UNDO.
	DEFINE VARIABLE nbr       LIKE wo_nbr        NO-UNDO .
	DEFINE VARIABLE nbr1      LIKE wo_nbr        NO-UNDO .
	DEFINE VARIABLE rel   like wo_rel_date.
	DEFINE VARIABLE rel1  like wo_rel_date.
	DEFINE VARIABLE line  LIKE pt_prod_line .
	DEFINE VARIABLE line1 LIKE pt_prod_line .
	DEFINE VARIABLE tmp_char as char format "x(76)" label "状态说明" .
	DEFINE VARIABLE i as integer .
	DEFINE VARIABLE k as integer .
	define variable sw_reset     like mfc_logical. 
	DEFINE VARIABLE update-yn as logi .

define temp-table xuseq_mstr
	field xuseq_site like xxseq_site
	field xuseq_priority like xxseq_priority
	field xuseq_ii like xxseq_priority
	field xuseq_wod_lot like xxseq_wod_lot
	field xuseq_wod_nbr like xxseq_wod_lot
	field xuseq_wod_qty like xxseq_qty_req
	field xuseq_sod_nbr like xxseq_sod_nbr
	field xuseq_sod_line like xxseq_sod_line   
	field xuseq_rel_date like wo_rel_date   
	field xuseq_line like xxseq_line       
	field xuseq_part like xxseq_part       
	field xuseq_qty_ord like xxseq_qty_req
	field xuseq_qty_pick like xxseq_qty_req
	field xuseq_pick_rmks as char
	field xuseq_qty2 like xxseq_qty_req
	field xuseq_chgtype as char
	field xuseq_shift1 like xxseq_shift1
	field xuseq_status as char format "x(1)"
	index xuseq_ii	xuseq_ii
	index xuseq_priority xuseq_priority .
DEFINE VARIABLE v_comp_part as char  .
DEFINE temp-table tmpd_det
	field	tmpd_ii			like xxseq_priority
	field	tmpd_par_part		like wod_part
	field	tmpd_comp_part		like wod_part
	field	tmpd_zhiding 		like wod_part
	field	tmpd_zhuanpi 		like wod_part
	field	tmpd_wo_nbr		like wo_nbr
	field	tmpd_wo_lot		like wo_lot
	field	tmpd_so_nbr		like so_nbr
	field	tmpd_sod_line		like sod_line
	field	tmpd_sod_qty		like sod_qty_ord
	field	tmpd_rel_date		like wo_rel_date
	field	tmpd_tot_qty_no_all  	like wod_qty_req
	field	tmpd_qty_all	   	like wod_qty_req
	field	tmpd_tot_qty_short 	like wod_qty_req
	field	tmpd_qty_short		like wod_qty_req 
	field	tmpd_qty_req		like wod_qty_req 
	field	tmpd_wo_qty_ord		like wod_qty_req 
	field	tmpd_ld_qty_oh		like wod_qty_req 
	field	tmpd_ld_qty_ic		like wod_qty_req 
	field	tmpd_vend		like ad_addr
	field	tmpd_comp_desc		as char extent 30
	field	tmpd_par_desc		as char extent 30
	index tmpd_ii tmpd_ii tmpd_comp_part 
	index tmpd_comp_part tmpd_comp_part .

DEFINE temp-table tmp_mstr
	field tmp_part like wod_part 
	field tmp_zhiding  like wod_part 
	field tmp_zhuanpi  like wod_part 
	field	tmp_tot_qty_no_all  	like wod_qty_req
	field	tmp_tot_qty_wo_short 	like wod_qty_req
	field	tmp_tot_qty_wo_req 	like wod_qty_req
	index tmp_part tmp_part .






define buffer s1 for xuseq_mstr.
DEFINE VARIABLE tmpqty like xuseq_ii .
DEFINE VARIABLE inpqty like xuseq_ii .
DEFINE VARIABLE zhuanpi as char .
				DEFINE VARIABLE zhiding as char .


	FORM
		nbr            COLON 18
		nbr1           LABEL {t001.i} COLON 49
		lot           COLON 18
		lot1          LABEL {t001.i} COLON 49
		line           COLON 18
		line1          LABEL {t001.i} COLON 49
		rel       COLON 18
		rel1      LABEL {t001.i} COLON 49 
		printpar  colon 18 label "打印成品状态说明"
		printcomp colon 49 label "打印子件状态说明"
	WITH FRAME a SIDE-LABELS WIDTH 80 attr-space .
	setFrameLabels(FRAME a:HANDLE).

form
   xuseq_ii   column-label "序号" format ">>>>>9.9"
   xuseq_rel_date   column-label "生产日期"
   /*xuseq_line       column-label "生产线"*/
   xuseq_part       column-label "物料号"
   xuseq_qty_ord    column-label "数量"
   xuseq_sod_nbr    column-label "SO Nbr"
   /*xuseq_qty_pick   column-label "成套库存"
   xuseq_pick_rmks  column-label "缺料情况"
   xuseq_status     column-label "R"*/
   
with frame d down no-attr-space width 80
title color normal (getFrameTitle("AVAILABLE_SEQUENCE_RECORDS",34)).
/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

printpar  = yes .
printcomp = yes .
	{wbrp01.i}
	REPEAT ON ENDKEY UNDO, LEAVE:
	for each xuseq_mstr :
		delete xuseq_mstr.
	end.
	FOR EACH  tmp_mstr :
		delete tmp_mstr .
	END.
	FOR EACH  tmpd_det :
		delete tmpd_det .
	END.
hide all no-pause .
view frame dtitle .
	   /*输入参数的初始化-BEGIN*/
		IF lot1	= hi_char	THEN lot1	= "".
		IF line1	= hi_char	THEN line1	= "".
		IF nbr1		= hi_char	THEN nbr1	= "".
		IF rel	= low_date	THEN rel	= ?.
		IF rel1	= hi_date	THEN rel1	= ?.


		IF c-application-mode <> 'web':u THEN
			UPDATE
				nbr nbr1 lot lot1 line line1 rel rel1 printpar printcomp
			WITH FRAME a.

		{wbrp06.i &command = UPDATE
			&fields = "nbr nbr1 lot lot1 line line1 rel rel1 printpar printcomp"
			&frm = "a"}

		IF (c-application-mode <> 'web':u) OR
			(c-application-mode = 'web':u AND
			(c-web-request begins 'data':u)) THEN DO:
			bcdparm = "".
			{mfquoter.i lot   }
			{mfquoter.i lot1  }
			{mfquoter.i nbr    }
			{mfquoter.i nbr1   }
			{mfquoter.i line   }
			{mfquoter.i line1  }
			{mfquoter.i rel }
			{mfquoter.i rel1}

			IF lot1	= ""	THEN lot1	= hi_char.
			IF line1	= ""	THEN line1	= hi_char.
			IF nbr1		= ""	THEN nbr1	= hi_char.
			IF rel	= ?	THEN rel	= low_date.
			IF rel1	= ?	THEN rel1	= hi_date.
		END.
          /*输入参数的初始化-END*/
          
        /*{mfselprt.i "printer" 130} */		/*---Remark by davild 20071214.1*/
	
	i = 1 .
	FOR EACH wo_mstr  where wo_domain = global_domain
		and wo_nbr >= nbr and wo_nbr <= nbr1
		and wo_lot >= lot and wo_lot <= lot1
		and wo_rel_date >= rel and wo_rel_date <= rel1
		and wo_vend >= line and wo_vend <= line1
		and wo_status <> "P" and wo_status <> "C"
		NO-LOCK
		by wo_rel_date by wo_vend :
		create xuseq_mstr.
   		assign xuseq_ii       = i
			 xuseq_site     = wo_site
			 /*xuseq_priority = ""*/
			 xuseq_rel_date = wo_rel_date
			 xuseq_line     = ""
			 xuseq_part     = wo_part
			 xuseq_qty_ord  = wo_qty_ord
			 /*xuseq_wod_qty  = xxseq_qty_req*/
			 xuseq_wod_lot  = wo_lot
			 xuseq_wod_nbr  = wo_nbr
			 xuseq_sod_nbr  = wo_so_job
			 xuseq_sod_line = integer(substring(wo_nbr,9,3))
			 /*xuseq_sod_line = xxseq_sod_line
			 xuseq_shift1   = xxseq_shift1*/
			 .
		 i = i + 1.
	END.
	
	find first xuseq_mstr no-lock no-error.
	if not avail xuseq_mstr then next.

	view frame d.
	pause 0.
	sw_reset = yes.

	scroll_loop:
	repeat with frame d:
	
		do transaction:
	
	        {xxddrescrad.i 
		xuseq_mstr 
		"use-index xuseq_ii" 
		xuseq_ii
		"xuseq_ii xuseq_rel_date xuseq_wod_nbr xuseq_wod_lot xuseq_part xuseq_qty_ord xuseq_sod_nbr"
		xuseq_ii 
		d
		"1 = 1"
		" "
		" "
		" "
		}
		end.

		if keyfunction(lastkey) = "end-error" then do:
			update-yn = no.
			{pxmsg.i &MSGNUM=36 &ERRORLEVEL=1 &CONFIRM=update-yn}
			if update-yn = yes then leave.
		end.

		if keyfunction(lastkey) = "return" and recno <> ?
			then do transaction on error undo, retry:
			tmpqty = xuseq_ii.
			prompt-for xuseq_ii with frame d
			editing: /* active in scrolling window   */

				{mfnp06.i xuseq_mstr xuseq_ii
				" 1  = 1 "
			      xuseq_ii xuseq_ii
			      xuseq_ii xuseq_ii}

			  if recno <> ? then do:
				display  xuseq_ii
				     xuseq_rel_date 
				     xuseq_part 
				     xuseq_wod_nbr 
				     xuseq_wod_lot 
				     xuseq_qty_ord 
				     xuseq_sod_nbr
				     with frame d.
			  end.
			end.	/*prompt-for xuseq_ii with frame d*/
			
			inpqty = input xuseq_ii.
			if inpqty = 0 then do:
				message "不能为0".
				undo,retry.
			end.
			
			if tmpqty <> inpqty then do:
				find first xuseq_mstr using xuseq_ii no-error.
				if avail xuseq_mstr then do:
					assign xuseq_ii = 0.
					
					find first xuseq_mstr where xuseq_ii = tmpqty no-error.
					if avail xuseq_mstr then xuseq_ii = input xuseq_ii.
					
					find first xuseq_mstr where xuseq_ii = 0 no-error.
					if avail xuseq_mstr then do:
						xuseq_ii = tmpqty.	
					end.
					
					sw_reset = yes.
				end. /* if avail */
				else do:
					find first xuseq_mstr where xuseq_ii = tmpqty no-error.
					if avail xuseq_mstr then xuseq_ii = 0 .
					for each xuseq_mstr use-index xuseq_priority 
						where xuseq_ii >= min(inpqty,tmpqty) and xuseq_ii <= max(inpqty,tmpqty) :
						if inpqty < tmpqty then xuseq_ii = xuseq_ii + 1.
						else	xuseq_ii = xuseq_ii - 1.
					end.
					find first xuseq_mstr where xuseq_ii = 0 no-error.
					if avail xuseq_mstr then do:
						if inpqty < tmpqty then xuseq_ii = truncate(inpqty,0) + 1.
						else xuseq_ii = truncate(inpqty,0).
					end.
					sw_reset = yes.
					
				end.
			end.	/*if tmpqty <> inpqty then do:*/
			
			/**/
		end.	/*if keyfunction(lastkey) = "return" and recno <> ?*/


	end. /*scroll_loop:*/

	/*清除临时表*/
	FOR EACH  tmp_mstr :
		delete tmp_mstr .
	END.
	FOR EACH  tmpd_det :
		delete tmpd_det .
	END.

	{mfselprt.i "printer" 130} 
	/*报表输出结果*/
	FOR EACH xuseq_mstr 
		:
		FOR EACH  wod_det where wod_domain = global_domain  and wod_lot = xuseq_wod_lot
			NO-LOCK:
			/*加总 总需求(wod_qty_req - wod_qty_all) 然后和 总未备料量(in_qty_avail - in_qty_all) */
				/*---Add by davild 20071228.1*/
				find first xxsob_det where xxsob_domain = global_domain and xxsob_nbr = xuseq_sod_nbr
					and xxsob_line = xuseq_sod_line 
					and xxsob_part = wod_part
					/*and xxsob_user2 <> ""*/	/*专批*/
					no-lock no-error.
				assign zhuanpi = "" zhiding = "".
				if avail xxsob_det then do:
					if xxsob_user2 <> "" then assign zhuanpi = xxsob_user2 .  /*专批--销售订单*/
					if xxsob_user1 <> "" then assign zhiding = xxsob_user1 .  /*指定--厂商*/
				end.
				
				/*message string(xuseq_sod_line) + " " +  xuseq_sod_nbr + zhiding + zhuanpi view-as alert-box .*/
				assign zhuanpi = trim(zhuanpi) 
				       zhiding = trim(zhiding).
				/*---Add End   by davild 20071228.1*/
			find first tmp_mstr where tmp_part = wod_part 
				and tmp_zhiding = zhiding
				and tmp_zhuanpi = zhuanpi 
				no-error.
			if not avail tmp_mstr then do:
				
				/*---Add by davild 20071224.1*/
				create tmp_mstr .
				   assign tmp_part = wod_part 
				   tmp_zhiding = zhiding 
				   tmp_zhuanpi = zhuanpi .
				/*1.有专批和指定件的要特别对待--*--begin*/
				
				if zhuanpi <> "" then do:
					for each ld_det where ld_domain = global_domain and ld_part = wod_part 
						and ld_ref = zhuanpi no-lock,					/*REF = SO NBR*/
						each is_mstr where is_domain = global_domain and is_status = ld_status and is_avail no-lock:
					   
						assign tmp_tot_qty_no_all = tmp_tot_qty_no_all + (ld_qty_oh - ld_qty_all).  /*总未备料量*/
						
					end.
					if zhiding <> "" then do:
						for each ld_det where ld_domain = global_domain and ld_part = wod_part 
						and substring(ld_lot,10 ,6) = zhiding no-lock,	/*LOT后6位=厂商*/
							each is_mstr where is_domain = global_domain and is_status = ld_status and is_avail no-lock:
						   
							assign tmp_tot_qty_no_all = tmp_tot_qty_no_all + (ld_qty_oh - ld_qty_all).  /*总未备料量*/
							
						end.
					end.
				end.
				else do:
					if zhiding <> "" then do:
						for each ld_det where ld_domain = global_domain and ld_part = wod_part 
							and substring(ld_lot,10 ,6) = zhiding no-lock,	/*LOT后6位=厂商*/
							each is_mstr where is_domain = global_domain and is_status = ld_status and is_avail no-lock:
						   
							assign tmp_tot_qty_no_all = tmp_tot_qty_no_all + (ld_qty_oh - ld_qty_all).  /*总未备料量*/
							
						end.
					end.
					else do:
						
						for each ld_det where ld_domain = global_domain and ld_part = wod_part 
							and ld_ref = "" no-lock,	/*除了专批的库存*/
							each is_mstr where is_domain = global_domain and is_status = ld_status and is_avail no-lock:
						   
							assign tmp_tot_qty_no_all = tmp_tot_qty_no_all + (ld_qty_oh - ld_qty_all).  /*总未备料量*/
							
						end.
					end.
				end.
				/*1.有专批和指定件的要特别对待--*--end*/
				
				if tmp_tot_qty_no_all < 0 then tmp_tot_qty_no_all = 0 .		/*SIMON 1224*/
				/*---Add End   by davild 20071224.1*/
			end.
			/*把发料原则为N的备料量为需求量--begin*/
			find first pt_mstr where pt_domain = global_domain and pt_part = wod_part no-lock no-error.
			if pt_iss_pol = no then 
			assign tmp_tot_qty_wo_req = tmp_tot_qty_wo_req + (wod_qty_req) .	/*总需求*/
			else
			/*把发料原则为N的备料量为需求量--end*/
			assign tmp_tot_qty_wo_req = tmp_tot_qty_wo_req + (wod_qty_req - wod_qty_iss - wod_qty_pick) .	/*总需求*/
			if tmp_tot_qty_no_all < tmp_tot_qty_wo_req then do:	/*算差缺*/

				assign tmp_tot_qty_wo_short = tmp_tot_qty_wo_req - tmp_tot_qty_no_all . /*总差缺*/

				
				find first tmpd_det where tmpd_comp_part = wod_part 
					/*---Add Begin by davild 20080107.1
					and tmpd_zhiding = zhiding
					and tmpd_zhuanpi = zhuanpi
					---Add End   by davild 20080107.1*/
					no-error.
				if not avail tmpd_det then do:
					create tmpd_det .
					assign tmpd_par_part = xuseq_part	/*父件*/
					       tmpd_comp_part = wod_part	/*子件*/
					       tmpd_zhiding = tmp_zhiding	/*---Add by davild 20080104.1*/
					       tmpd_zhuanpi = tmp_zhuanpi	/*---Add by davild 20080104.1*/
					       tmpd_ii	 = xuseq_ii
					       tmpd_wo_nbr  = xuseq_wod_nbr
					       tmpd_wo_lot  = xuseq_wod_lot
					       tmpd_so_nbr  = xuseq_sod_nbr
					       tmpd_rel_date = xuseq_rel_date
					       tmpd_tot_qty_no_all = tmp_tot_qty_no_all				/*总未备料量*/
					       tmpd_qty_all = wod_qty_all					/*本工单备料量*/
					       tmpd_tot_qty_short = tmp_tot_qty_wo_short			/*总差缺*/
					       tmpd_qty_short = tmp_tot_qty_wo_req - tmp_tot_qty_no_all		/*本工单差缺*/
					       tmpd_qty_req	= wod_qty_req					/*本工单需求*/
					       tmpd_vend	= ""						/*厂家代码*/
					       .
				end.
				else do:
					/*1.改变原来共用零件的总差缺量*/
					for each tmpd_det where tmpd_comp_part = wod_part 
						/*---Add Begin by davild 20080107.1
						and tmpd_zhiding = zhiding
						and tmpd_zhuanpi = zhuanpi
						---Add End   by davild 20080107.1*/						
						:
						assign tmpd_tot_qty_short = tmp_tot_qty_wo_short .
					end.
					/*本工单差缺量*/
					create tmpd_det .
					assign tmpd_par_part = xuseq_part	/*父件*/
					       tmpd_comp_part = wod_part	/*子件*/
					       tmpd_zhiding = tmp_zhiding	/*---Add by davild 20080104.1*/
					       tmpd_zhuanpi = tmp_zhuanpi	/*---Add by davild 20080104.1*/
					       tmpd_ii	 = xuseq_ii
					       tmpd_wo_nbr  = xuseq_wod_nbr
					       tmpd_wo_lot  = xuseq_wod_lot
					       tmpd_so_nbr  = xuseq_sod_nbr
					       tmpd_rel_date = xuseq_rel_date
					       tmpd_tot_qty_no_all = tmp_tot_qty_no_all				/*总未备料量*/
					       tmpd_qty_all = wod_qty_all					/*本工单备料量*/
					       tmpd_tot_qty_short = tmp_tot_qty_wo_short			/*总差缺*/
					       tmpd_qty_short = wod_qty_req - wod_qty_iss - wod_qty_pick			/*本工单差缺*/
					       tmpd_qty_req	= wod_qty_req					/*本工单需求*/
					       tmpd_vend	= ""						/*厂家代码*/
					       .
				end.	
				/*取状态描述--begin*/
				/*成品状态*/
				tmp_char = "" .
				find first pt_mstr where pt_domain = wod_domain and pt_part = xuseq_part no-lock no-error.
				if avail pt_mstr then assign tmp_char = "(" + trim(pt_desc1) + ")" . 
				
				find first cd_det where cd_domain = wod_domain
					and cd_ref = xuseq_part   /*成品状态*/
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
				k = 1 .
				run getstring(input tmp_char ,input 82, output tmp_char ,output k) .
				do i = 1 to k:
					assign tmpd_par_desc[i] = ENTRY(i, tmp_char, "^") .		/*状态描述*/
				end.
				/*子件状态*/
				tmp_char = "" .
				find first pt_mstr where pt_domain = wod_domain and pt_part = wod_part no-lock no-error.
				if avail pt_mstr then assign tmp_char = "(" + trim(pt_desc1) + ")" . 
				
				find first cd_det where cd_domain = wod_domain
					and cd_ref = wod_part   /*子件状态*/
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
				k = 1 .
				run getstring(input tmp_char ,input 82, output tmp_char ,output k) .
				do i = 1 to k:
					assign tmpd_comp_desc[i] = ENTRY(i, tmp_char, "^") .		/*状态描述*/
				end.
				/*取状态描述--end*/
				assign tmpd_wo_qty_ord =xuseq_qty_ord .
			end.
		END.	/*FOR EACH  wod_det where wod_domain*/
	END.
	
	FOR EACH  tmpd_det where tmpd_qty_short <> 0 break by tmpd_ii by tmpd_comp_part :
		
		find first in_Mstr where in_domain = global_domain 
			and in_site = "10000" 
			and in_part = tmpd_comp_part
			no-lock no-error.
		if avail in_Mstr then do:
			assign tmpd_ld_qty_oh = in_qty_avail .				
		end.
		for each ld_det where ld_domain = global_domain 
			and ld_site = "10000" 
			and ld_part = tmpd_comp_part and ld_loc begins "IC"
			no-lock :
 			assign tmpd_ld_qty_ic = tmpd_ld_qty_ic + ld_qty_oh .				
		end.
		find first wo_mstr where wo_domain = global_domain 
			and wo_lot = tmpd_wo_lot no-lock no-error.
		if avail wo_mstr then assign tmpd_vend = wo_vend .

		if first-of(tmpd_ii) then do:
			i = 1 .
			

			/*输出工单头*/
			put unformatted "销售订单	项	  工单ID               成品号                       工单数量" at 1 .
			put unformatted "-----------------------------------------------------------------------------------" at 1 .
			put unformatted tmpd_so_nbr at i.			i = i + 17 .
			put unformatted substring(tmpd_wo_nbr,9,3) to i .	i = i + 15 .
			put unformatted tmpd_wo_lot		 to i - 2.	i = i + 27 .
			put unformatted tmpd_par_part		 to i.		i = i + 23 .
			put unformatted tmpd_wo_qty_ord		 to i.	/*工单数量*/
			do i = 1 to 30 :
				if trim(tmpd_par_desc[i]) <> "" and printpar then do:
 					put unformatted tmpd_par_desc[i] at 3 .		/*成品状态说明*/
 				end.
			end.
			
			put unformatted " 差缺零件编码       日期   线            未备料   总差缺     差缺     库存     待检" at 1 .
			put unformatted " ----------------------------------------------------------------------------------" at 1 .
			
		end.
 			i = 1 .
			v_comp_part = tmpd_comp_part .
			if tmpd_zhiding <> "" then assign v_comp_part = "*" + v_comp_part .	/*---Add by davild 20080104.1*/
			if tmpd_zhuanpi <> "" then assign v_comp_part = "#" + v_comp_part .	/*---Add by davild 20080104.1*/
			put unformatted v_comp_part at i + 1 .	i = i + 46 .
			put unformatted string(tmpd_rel_date,"999999") at 21 .	
			put unformatted tmpd_vend  at 28 .	
			put unformatted tmpd_tot_qty_no_all to  i .	i = i + 9 .	/*总未备料量*/
			put unformatted tmpd_tot_qty_short to  i .	i = i + 9 .	/*总差缺*/
			put unformatted tmpd_qty_short to  i .		i = i + 9 .	/*本工单差缺*/
			put unformatted tmpd_ld_qty_oh to  i .		i = i + 9 .	/*库存*/
			put unformatted tmpd_ld_qty_ic to  i .			.	/*待检*/
			put unformatted tmpd_zhiding at i + 2.
			/*put unformatted " " + tmpd_zhuanpi .*/
			do i = 1 to 30 :
				if trim(tmpd_comp_desc[i]) <> "" and printcomp then do:
					put unformatted tmpd_comp_desc[i] at 3 .					
				end.
			end.
 		if last-of(tmpd_ii) then 
			put unformatted "-----------------------------------------------------------------------------------" at 1 .
			

	END.
	
	for each xuseq_mstr :
		delete xuseq_mstr.
	end.
	FOR EACH  tmp_mstr :
		delete tmp_mstr .
	END.
	FOR EACH  tmpd_det :
		delete tmpd_det .
	END.
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
			if substring(optstring,xxj,1) = "^" then assign xxk = xxk + 1 .
		end.
		/*---Add End   by davild 20071220.1*/


END PROCEDURE.