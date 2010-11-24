/* SS - 090403.1 By: Neil Gao */
/* SS - 090813.1 By: Neil Gao */
/* SS - 091021.1 By: Neil Gao */
/* SS - 100625.1 By: Kaine Zhang */

/* SS - 100625.1 - RNB
[100630.1]
    例如:
        供应商: 200204
        物料: 170020663-0001
        期初数量: 0
        本期采购入库: 1
        (1). 工单发料: 1
        (2). 工单发料: 10
        (3). 工单发料: -10
1. 工单发料的时候,发错了.此时,用户会发相同批号的负数. 对于这样的操作,本'出库处理'出来的结果是错的.
    本次修改,将对上述错误进行修正.
2. 超出入库数的发料,在'出库处理'出来的结果是错的.
    本次修改,将对上述错误进行修正.
[100630.1]
[100625.1]
出库的时候,扣减需按先进先出顺序.先扣减早期的xxld_det.
[100625.1]
SS - 100625.1 - RNE */

{mfdtitle.i "100630.3"}

define variable yr like glc_year.
define variable per like glc_per.
define variable part like mrp_part.
define variable part2 like mrp_part.
define variable date as date .
define variable date2 as date.
define variable effdate as date init today.
define variable xxdesc2 like pt_desc2.
define variable vend like po_vend.
define variable vend1 like po_vend.
define variable tqty1 like tr_qty_loc.
define variable ttprice like pt_price.
define variable ttamt like ar_amt.
define variable xxsg as logical format "Y)手工/D)导入".
define variable ponbr like po_nbr.
define variable poline like pod_line.
define buffer trhist for tr_hist. 
define var site like in_site init "10000".
/* SS 090813.1 - B */
define variable sonbr like so_nbr.
define variable wolot like wo_lot.
/* SS 090813.1 - E */

	DEFINE VARIABLE wpage     AS integer format ">>>" init 1.
	DEFINE VARIABLE wct_desc  LIKE ct_desc NO-UNDO.
	DEFINE VARIABLE i		AS	INTEGER.
	DEFINE VARIABLE xxrmk as char format "x(4)" label "其他".
	DEFINE VARIABLE xxi   as int label "序" format ">>>" .
	define variable v_ok  as logical.
	define variable adname like ad_name.
	define variable xxqty like tr_qty_loc.
	define variable xxqty2 like xxqty.
	define variable xxqty3 like xxqty.
	 
form
	 yr												colon 15 label "日期"
	 per											colon 15
	 xxsg											colon 15 label "Y)手工/D)导入"
   skip(1)
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
	vend colon 15
	part colon 15
	skip(1) 
/* SS 090813.1 - B */
	sonbr  colon 15
	wolot  colon 15
/* SS 090813.1 - E */
	xxqty colon 15 label "数量"
with frame b side-labels width 80 attr-space.

setframelabels(frame b:handle).
	
	
mainloop:
REPEAT ON ENDKEY UNDO, LEAVE:

		update
	   	yr
	   	per
	   	xxsg
			WITH FRAME a.

		 find first glc_cal where glc_domain = global_domain and glc_year = yr and glc_per = per no-lock no-error.
		 if not avail glc_cal then do:
		 	message "期间不存在".
		 	next.
		 end.
		 date 	= glc_start.
		 date2 = glc_end.
		  
		vend = "".
		part = "".
		if xxsg then repeat on error undo,leave:
			
			update vend part with frame b.
			
			find first vd_mstr where vd_domain = global_domain and vd_addr = vend no-lock no-error.
			if not avail vd_mstr then do:
				message "错误: 供应商代码不存在".
				next-prompt vend with frame b.
				undo,retry.
			end.
				
			find first pt_mstr where pt_domain = global_domain and pt_part = part no-lock no-error.
			if not avail pt_mstr then do:
				message "错误:物料号不存在".
				next-prompt part with frame b.
				undo,retry.
			end.
			
			sonbr = "".
			wolot = "".
			xxqty = 0.
			loop1:
			do on error undo,leave :
				
/* SS 090813.1 - B */
				update sonbr wolot xxqty with frame b.
/* SS 090821.1 - B */
/*
				find first so_mstr where so_domain = global_domain and so_nbr = sonbr no-lock no-error.
				if not avail so_mstr then do:
					message "错误: 订单号不存在".
					next-prompt sonbr with frame b.
					undo,retry.
				end.
				
				find first wo_mstr where wo_domain = global_domain and wo_lot = wolot no-lock no-error.
				if not avail wo_mstr then do:
					message "错误: 工单ID不存在".
					next-prompt wolot with frame b.
					undo,retry.
				end.
				else do:
					if wo_so_job <> sonbr then do:
						message "错误: 订单和工单ID不对应".
						next-prompt wolot with frame b.
						undo,retry.
					end.
				end.
*/
/* SS 090821.1 - E */
/* SS 090813.1 - E */
				if xxqty = 0 then do:
					message "错误: 数量不能为零".
					next-prompt xxqty with frame b.
					undo,retry.
				end.
				run cutlddet( input vend,input part,input xxqty, input sonbr ,input wolot,input today,input time,input "手工录入").
/* SS 090813.1 - E */		
			end. /* loop1: */
		end.
		else do:
			for each xxtr_hist where xxtr_domain = global_domain and xxtr_site = site and xxtr_sort = "out"
				and xxtr_year = yr and xxtr_per = per	no-lock:
				message "记录已存在,不能新增".
				next mainloop.
			end.
			
    	{mfselprt.i "printer" 650}
		
			for each tr_hist where tr_domain = global_domain and tr_site = site and tr_part < "A"
				and tr_effdate >= date and tr_effdate <= date2
				and tr_qty_loc <> 0	and tr_ship_type = "" and tr_loc <> "ic01" no-lock:
				
				vend = substring(tr_serial,7).
				
				if tr_serial begins "A" then do:

				end. /* if tr_serial begins "A" then do: */
				else do:
					if tr_type = "iss-wo" or tr_type = "iss-unp" or tr_type = "iss-so"
					then do:
					    run cutlddet( input vend,input tr_part,input ( - tr_qty_loc ), input tr_nbr ,input tr_lot,input tr_effdate,input tr_time,input "导入").
					end.
				end. /* else do */
			end. /* for each */
			vend = "".
			
		  /* 显示 */
			for each xxtr_hist where xxtr_domain = global_domain and xxtr_year = yr and xxtr_per = per 
				and xxtr_site = site		and xxtr_sort = "out" no-lock:
					disp xxtr_vend xxtr_part xxtr_nbr xxtr_qty 	with stream-io width 200.
			end.
			
			{mfreset.i}
			{mfgrptrm.i}
		end. /* else do: */
		hide frame b no-pause.
		
END.


procedure crtgltdet:
	define input parameter iptf1 like glc_year.
	define input parameter iptf2 like glc_per.
	define input parameter iptf3 as char.
	define input parameter iptf4 like po_nbr.
	define input parameter iptf9 like po_vend.
	define input parameter iptf5 like pt_part.
	define input parameter iptf6 like tr_qty_loc.
	define input parameter iptf7 like pt_price.
	define input parameter iptf8 like xxld_tax_pct.
	define input parameter iptf10 like so_nbr.
	define input parameter iptf11 like wo_lot.
	define input parameter iptf12 like tr_effdate.
	define input parameter iptf13 like tr_time.
	define input parameter iptf14 like tr_rmks.
	define var  optf1 as char format "x(18)".
	
	optf1 = iptf3 + substring(string(iptf1,"9999"),3,2) + string(iptf2,"99") .
	find last xxglt_det where xxglt_domain = global_domain and xxglt_ref begins optf1 no-error.
	if avail xxglt_det then optf1 = optf1 + string((int(substring(xxglt_ref,7,6)) + 1),"999999").
	else optf1 = optf1 + "000001".
	    
	create xxtr_hist.
				
	assign 	xxtr_domain = global_domain
					xxtr_site = site
					xxtr_year = iptf1
					xxtr_per	= iptf2
					xxtr_vend = iptf9
					xxtr_type = "iss-wo"
					xxtr_sort = "out"
					xxtr_part = iptf5
					xxtr_qty  = iptf6
					xxtr_price = iptf7
					xxtr_amt = xxtr_qty * xxtr_price
					xxtr_tax_pct = iptf8
					xxtr_glnbr = optf1
					xxtr_nbr   = iptf10
					xxtr_lot   = iptf11
					xxtr_rmks = "导入"
					xxtr_effdate = iptf12
					xxtr_time  = iptf13
					xxtr_rmks = iptf14
					.
	
	create 	xxglt_det.
	assign  xxglt_domain = global_domain
					xxglt_ref = optf1
					xxglt_year = iptf1
					xxglt_per  = iptf2
					xxglt_type = iptf3
					xxglt_nbr  = iptf4
					xxglt_effdate = today
					xxglt_date = today
					xxglt_time = time
					xxglt_price = iptf7 / ( 1 + iptf8 / 100 )
					xxglt_part  = iptf5
					xxglt_vend  = iptf9
					xxglt_qty   = iptf6
					xxglt_amt   = xxglt_price * xxglt_qty
					.

end procedure.

procedure cutlddet:
	
	define input parameter ipt1f1 like po_vend.
	define input parameter ipt1f2 like pod_part.
	define input parameter ipt1f3 as deci.
	define input parameter ipt1f4 like so_nbr.
	define input parameter ipt1f5 like wo_lot.
	define input parameter ipt1f6 like tr_effdate.
	define input parameter ipt1f7 like tr_time.
	define input parameter ipt1f8 like tr_rmks.
		
		
	/*  
	 *  20100630
	 *  todo
	 *  本procedure代码,可以按本说明的逻辑重写.
     *  1. 如果出库的是负数:
     *      首先从库存为负数的记录中扣数.
     *      如果没有库存为负数的,再从正数库存扣.
     *      如果所有库存都是0,那就从后向前扣.
     *  2. 如果出库的是正数:
     *      首先从库存为正数的记录中扣数.
     *      然后从后向前扣.
     */
    /* SS - 100630.1 - B */
    if ipt1f3 < 0 then do:
	    for each xxld_det 
	        where xxld_domain = global_domain 
	            and xxld_vend = ipt1f1 
	            and xxld_part = ipt1f2 
		        and xxld_nbr = "" 
		        and xxld_qty < 0
		    break 
		    by xxld_year 
		    by xxld_per 
		:
		    run crtgltdet ( input yr,input per,input 'wo' ,input xxld_nbr,input xxld_vend ,input xxld_part,
											input ipt1f3,input xxld_tax_price,input xxld_tax_pct,input ipt1f4,input ipt1f5,
											input ipt1f6,input ipt1f7,input ipt1f8 ) .
			xxld_qty = xxld_qty - ipt1f3.
			ipt1f3 = 0.
			leave.
	    end.
	end.
    /* SS - 100630.1 - E */
		
	for each xxld_det where xxld_domain = global_domain and xxld_vend = ipt1f1 and xxld_part = ipt1f2 
		and xxld_nbr = "" and xxld_qty > 0
		/* SS - 100625.1 - B */
		break by xxld_year by xxld_per
		/* SS - 100625.1 - E */
		:
		
		/* SS - 100630.1 - B
		if xxld_qty >= ipt1f3 then do:
			run crtgltdet ( input yr,input per,input 'wo' ,input xxld_nbr,input xxld_vend ,input xxld_part,
											input ipt1f3,input xxld_tax_price,input xxld_tax_pct,input ipt1f4,input ipt1f5,
											input ipt1f6,input ipt1f7,input ipt1f8 ) .
			xxld_qty = xxld_qty - ipt1f3.
			ipt1f3 = 0.
		end.
		else do:
			run crtgltdet ( input yr,input per,input 'wo' ,input xxld_nbr,input xxld_vend ,input xxld_part,
											input xxld_qty,input xxld_tax_price,input xxld_tax_pct,input ipt1f4,input ipt1f5,
											input ipt1f6,input ipt1f7,input ipt1f8 ) .
			ipt1f3 = ipt1f3 - xxld_qty.
			xxld_qty = 0.
		end.
		if ipt1f3 = 0 then leave.
		SS - 100630.1 - E */
		
		/* SS - 100630.1 - B */
		if ipt1f3 < 0 then do:
		    run crtgltdet ( input yr,input per,input 'wo' ,input xxld_nbr,input xxld_vend ,input xxld_part,
    											input ipt1f3,input xxld_tax_price,input xxld_tax_pct,input ipt1f4,input ipt1f5,
    											input ipt1f6,input ipt1f7,input ipt1f8 ) .
			xxld_qty = xxld_qty - ipt1f3.
			ipt1f3 = 0.
			leave.
		end.
		else if ipt1f3 > 0 then do:
		    if xxld_qty >= ipt1f3 then do:
    			run crtgltdet ( input yr,input per,input 'wo' ,input xxld_nbr,input xxld_vend ,input xxld_part,
    											input ipt1f3,input xxld_tax_price,input xxld_tax_pct,input ipt1f4,input ipt1f5,
    											input ipt1f6,input ipt1f7,input ipt1f8 ) .
    			xxld_qty = xxld_qty - ipt1f3.
    			ipt1f3 = 0.
    		end.
    		else do:
    			run crtgltdet ( input yr,input per,input 'wo' ,input xxld_nbr,input xxld_vend ,input xxld_part,
    											input xxld_qty,input xxld_tax_price,input xxld_tax_pct,input ipt1f4,input ipt1f5,
    											input ipt1f6,input ipt1f7,input ipt1f8 ) .
    			ipt1f3 = ipt1f3 - xxld_qty.
    			xxld_qty = 0.
    		end.
    		if ipt1f3 = 0 then leave.
		end.
		/* SS - 100630.1 - E */
	end.
	
	/* SS - 100629.1 - B */
	if ipt1f3 > 0 then do:
        for each xxld_det where xxld_domain = global_domain and xxld_vend = ipt1f1 and xxld_part = ipt1f2 
    		and xxld_nbr = ""
    		break by xxld_year descending by xxld_per descending
    		:
    		
			run crtgltdet ( input yr,input per,input 'wo' ,input xxld_nbr,input xxld_vend ,input xxld_part,
											input ipt1f3,input xxld_tax_price,input xxld_tax_pct,input ipt1f4,input ipt1f5,
											input ipt1f6,input ipt1f7,input ipt1f8 ) .
			xxld_qty = xxld_qty - ipt1f3.
			ipt1f3 = 0.
    		if ipt1f3 = 0 then leave.
    	end.
	end.
	else if ipt1f3 < 0 then do:
	    for each xxld_det 
	        where xxld_domain = global_domain 
	            and xxld_vend = ipt1f1 
	            and xxld_part = ipt1f2 
		        and xxld_nbr = "" 
		        and xxld_qty <= 0
		    break 
		    by xxld_year descending
		    by xxld_per descending
		:
		    run crtgltdet ( input yr,input per,input 'wo' ,input xxld_nbr,input xxld_vend ,input xxld_part,
											input ipt1f3,input xxld_tax_price,input xxld_tax_pct,input ipt1f4,input ipt1f5,
											input ipt1f6,input ipt1f7,input ipt1f8 ) .
			xxld_qty = xxld_qty - ipt1f3.
			ipt1f3 = 0.
			leave.
	    end.
	end.
	/* SS - 100629.1 - E */
	
	/* SS - 100630.1 - B
	if ipt1f3 <> 0 then do:	
		create xxld_det .
		assign xxld_domain = global_domain
			     xxld_vend   = ipt1f1
			     xxld_part   = ipt1f2
			     xxld_nbr    = ""
			     xxld_qty    = - ipt1f3
			     .
		{gprun.i ""xxgetprice.p"" "(input xxld_vend,input xxld_part,input today,output xxld_price)"} .
		
		run crtgltdet ( input yr,input per,input 'wo' ,input xxld_nbr,input xxld_vend ,input xxld_part,
										input xxld_qty,input xxld_tax_price,input xxld_tax_pct,input ipt1f4,input ipt1f5,
										input ipt1f6,input ipt1f7,input ipt1f8 ).
	end.
	SS - 100630.1 - E */

end procedure. /* cutlddet */
