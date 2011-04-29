

/* $Created  BY: softspeed Roger Xiao         DATE: 2007/11/04  ECO: *xp001*  */  
/* $MODIFIED BY: softspeed Roger Xiao         DATE: 2008/01/16  ECO: *xp002*  */  /*记录PO修改历史记录*/
/*-Revision end---------------------------------------------------------------*/

{mfdeclre.i}

/*variables for pod cim create */
define variable use-log-acctg          as logical        no-undo.


/*variables for cimload */
define variable outfile   as char format "x(40)"  no-undo.  /*for cimload*/
define variable outfile1  as char format "x(40)"  no-undo.  /*for cimload*/
define variable quote     as char initial '"'     no-undo.  /*for cimload*/
define variable v_ok      like mfc_logical initial yes no-undo.  /*for cimload*/
define variable v_all_ok  like mfc_logical initial yes no-undo.  /*for cimload*/
define var v_poc_pt_req like poc_pt_req initial no .  /*for cimload*/
define var v_poc_pl_req like poc_pl_req initial no .  /*防止错误:默认价格,'高于价格表最高价格'*/
define var v_po_pr_list2  like po_pr_list2 .  /* 防止错误:默认价格,'高于价格表最高价格'*/
define var v_po_pr_list   like po_pr_list .   /* 防止错误:默认价格,'高于价格表最高价格'*/


define var v_wk as char label "历史记录的周别" .
define var v_hist   like mfc_logical initial no .  /*xp002*/



define shared temp-table temp 
	field t_select   as char  format "x(1)"   
	field t_nbr      like po_nbr              
	field t_line     like pod_line 
	field t_part     like pod_part      
	field t_date_to  like pod_need
	field t_date1    like pod_need
	field t_date     like po_ord_date            
	field t_qty      like pod_qty_ord 	
	field t_detail   as char format "x(4)"
	field t_app      as logical format "Y/N" label "审" . 





{pocnvars.i}  /*for po_consignment ,pod_consignment*/
/***********************************end define ********************************************************/

/* VALIDATE IF LOGISTICS ACCOUNTING IS TURNED ON */
{gprun.i ""lactrl.p"" "(output use-log-acctg)"}

/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
	"(input ENABLE_SUPPLIER_CONSIGNMENT,
	input 11,
	input ADG,
	input SUPPLIER_CONSIGN_CTRL_TABLE,
	output using_supplier_consignment)"}

v_wk = "" .
{gprun.i ""xxmpwks.p"" "(input today ,output v_wk)"}	


find first poc_ctrl where poc_domain = global_domain no-error .
if not avail poc_ctrl then do:
	message "错误:采购模块未启用." view-as alert-box.
end.
v_poc_pt_req = poc_pt_req .
v_poc_pl_req = poc_pl_req .
poc_pt_req = no .
poc_pl_req = no .
find first mfc_ctrl  where  mfc_domain = global_domain and mfc_field = "poc_pt_req" no-error .
if avail mfc_ctrl then do:
	v_poc_pt_req = mfc_logical  .
	mfc_logical = no .
end.
else do:
	create mfc_ctrl.
	assign
		mfc_domain = global_domain
		mfc_label = "Price Table Required"
		mfc_field = "poc_pt_req"
		mfc_type = "L"
		mfc_module = "PO"
		mfc_seq = 17
		mfc_logical = no.
	v_poc_pt_req = mfc_logical  .
end.
release poc_ctrl .
release  mfc_ctrl .




updateloop:
do on error undo, leave :
/** 主程式先检查所有计划都有对应pod,且锁定pod ****************************************************************/


/*part1: 不做调整部分******************************************************************************/
for each xchg_det exclusive-lock 
		where c_domain = global_domain 
		and c_stat02 = yes 
		and c_detail = "" ,
	each temp 
		where t_nbr = c_nbr and t_line = c_line 
		and t_app = yes no-lock
	break by c_nbr by c_line by c_date_to :

	create xchg_hist .
	assign 
		xch_domain = global_domain
		xch_wk	   = v_wk 
		xch_site   = c_site 
		xch_nbr    = c_nbr
		xch_line   = c_line
		/**/ xch_detail = c_detail
		xch_part      = c_part
		xch_date_to	  = c_date_to
		xch_date_from = c_date_from 
		xch_qty		  = c_qty 
		xch_qty_to    = c_qty_to 
		xch_date01    = c_date01
		xch_date02    = c_date02
		xch_user01    = c_user01
		xch_user02    = c_user02 
		xch_req_nbr   = c_req_nbr 
		xch_req_line  = c_req_line 
		xch_id        = c_id .

delete xchg_Det.
end.


/*part2: 调整日期部分******************************************************************************/

for each xchg_det exclusive-lock 
		where c_domain = global_domain 
		and c_stat02 = yes 
		and c_detail = "C" ,
	each temp 
		where t_nbr = c_nbr and t_line = c_line 
		and t_app = yes no-lock
	break by c_nbr by c_line by c_date_to :
	if first-of( c_nbr) then do:
	/*xp002*/
	v_hist = no .
	{gprun.i ""xxhist001.p"" "(input ""PO"" ,input c_nbr ,input 1,output v_hist )"}
	/*xp002*/	
	end.


	find first pod_det 
		where pod_domain = global_domain 
		and pod_nbr = c_nbr 
		and pod_line = c_line 
	no-error.
	if avail pod_det then do:
	
		assign pod_due_date = c_date_to .
		release pod_det .
		
		create xchg_hist .
		assign 
			xch_domain = global_domain
			xch_wk	   = v_wk 
			xch_site   = c_site 
			xch_nbr    = c_nbr
			xch_line   = c_line
			/**/ xch_detail = c_detail
			xch_part      = c_part
			xch_date_to	  = c_date_to
			xch_date_from = c_date_from 
			xch_qty		  = c_qty 
			xch_qty_to    = c_qty_to 
			xch_date01    = c_date01
			xch_date02    = c_date02
			xch_user01    = c_user01
			xch_user02    = c_user02 
			xch_req_nbr   = c_req_nbr 
			xch_req_line  = c_req_line 
			xch_id        = c_id .
	end.

	if last-of( c_nbr) then do:
		/*xp002*/
		v_hist = no .
		{gprun.i ""xxhist001.p"" "(input ""PO"" ,input c_nbr ,input 1,output v_hist )"}
		if v_hist then do:
			find first po_mstr where po_domain = global_domain and po_nbr = c_nbr no-error .
			if avail po_mstr then do:
				po__chr01 = "" . /*改为未发行版本*/
				po_rev  = po_rev + 1 .
			end.
		end.
		/*xp002*/
	end.

	find first pod_det 
		where pod_domain = global_domain 
		and pod_nbr  = c_nbr 
		and pod_line = c_line 
		and pod_due_date = c_date_to
	no-lock no-error.
	if avail pod_det then do:
		delete xchg_Det.
	end.

end. /*for each xchg_det*/


/*part3: 取消部分******************************************************************************/
v_all_ok = yes .
for each xchg_det no-lock 
		where c_domain = global_domain 
		and c_stat02 = yes 
		and c_detail = "x"  ,
	each temp 
		where t_nbr = c_nbr and t_line = c_line 
		and t_app = yes no-lock
	break by c_nbr by c_line by c_date_to :

	if first-of(c_nbr) then do :
			v_po_pr_list = "" .
			v_po_pr_list2 = "" .			
			find first po_mstr where po_domain = global_domain and po_nbr = c_nbr  no-error .
			if avail po_mstr then do:
				v_po_pr_list  = po_pr_list .
				v_po_pr_list2 = po_pr_list2 .
				po_pr_list = "" .
				po_pr_list2 = "" .
				release po_mstr .
			end.
			/* start output ***************************************************************************/
			outfile = "mppocrt"
			        + TRIM ( string(year(TODAY)) 
					+ string(MONTH(TODAY)) 
					+ string(DAY(TODAY)))  
					+ trim(STRING(TIME)) 
					+ trim(string(RANDOM(1,100))) 
					+ ".i".
			outfile1 = outfile + ".o" .


			output to value( outfile ) .
				/*start po_mstr 头*/
				find first po_mstr where po_domain = global_domain and po_nbr = c_nbr no-lock no-error .
				if avail po_mstr then do:
					
					put unformatted	quote trim(po_nbr)      quote space skip .
					put unformatted	 " - " skip .
					put unformatted	 " - " skip .
					if po_print = no then put skip .
					put unformatted	 " -  -  -  -  -  -  -  - " .
					put unformatted	 " -  -  -  -  - " .
					put unformatted	 " -  -  -  -  -  -  -  -  -  N " skip .
					if ( not can-find(first prh_hist where prh_domain = global_domain and prh_nbr = po_nbr)) and  po_curr <> base_curr then 
						put unformatted	 " -  - "skip . /*外币汇率*/
					put unformatted	 " -  -  -  -  - " skip . /*纳税*/	
					if use-log-acctg  then 
						put unformatted	 " -  - " skip .  /*po_tot_terms_cod*/
					if using_supplier_consignment and po_consignment  = yes then do:
						put unformatted	 " -  - " skip .  /*寄售天数,成本点*/ 
					end.
				end.
				/*end  po_mstr 头*/
				
	end. /*if first-of(c_nbr) */

		find first pod_Det where pod_domain = global_domain and pod_nbr = c_nbr and pod_line = c_line  no-lock no-error .
		if avail pod_det then do:
			put unformatted	trim(string(c_line))       space skip .
			if pod_qty_rcvd = 0 then 
				put unformatted	" - " skip . /*site*/
			put unformatted	" - " skip . /*qty*/
			put unformatted " -  - " skip .  /*cost ,disc*/
			if pod_qty_rcvd = 0 then 
				put unformatted	" - " . /*单批:pod_lot_rcpt*/
			put unformatted " -  - " .	
			if c_detail = "X" then 
				 put unformatted quote trim(c_detail)     quote    space "-" space  .	
			else put unformatted " -  - " .	
			put unformatted " -  -  -  -  -  -  -  -  -  -  -  -  -  -  - " skip  .
			if pod_taxable then 
								put unformatted	 " -  -  -  -  - " skip . /*纳税*/
			if using_supplier_consignment and
				can-find(pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
				pod_part)
			then do:
				put unformatted " - " skip .
				if pod_consignment = yes then put unformatted " - " skip .
			end .

			if can-find (first vp_mstr where vp_mstr.vp_domain = global_domain
										and vp_mstr.vp_part >= ""
										and  vp_mstr.vp_vend >= ""
										and  vp_mstr.vp_vend_part >= "")
			then do:
				find first po_mstr where po_domain = global_domain and po_nbr = pod_nbr no-lock no-error .
				
				find first vp_mstr where vp_domain = global_domain
									and  vp_part = pod_part 
									and  vp_vend = po_vend 
				no-lock no-error.
				if available vp_mstr then do:
					if vp_q_price <> pod_pur_cost 
						and vp_um = pod_um
						and vp_curr = po_curr 
						and pod_qty_ord >= vp_q_qty
					then do:
						put unformatted "N" space skip . /*不更新报价*/
					end.
				end.
			end.  /*if can-find (first vp_mstr*/			

		end. /*if avail pod_det */

	
	if last-of(c_nbr) then do:

			/*start po_mstr 尾*/
				put unformatted  "." skip.
				put unformatted  "." skip.
				put unformatted  " - " skip .
				put unformatted  " -  -  -  -  -  -  -  -  -  -  - " skip .
			/*end  po_mstr 尾*/
		output close .
		/* end  output ***************************************************************************/

		/* start 执行***/
		batchrun = yes .
		input from value ( outfile ) .
			output to  value ( outfile1) .
				{gprun.i ""pomt.p"" "(input false)"}						
			output close.
		input close.
		
		
		/*errorlog*/
		v_ok = yes .
		run write_error_to_log(input outfile,input outfile1 ,output v_ok) . 
		if v_ok = no and v_all_ok = yes then do:
				v_all_ok = no .
		end.
		/* end  执行***/
		
			find first po_mstr where po_domain = global_domain and po_nbr = c_nbr  no-error .
			if avail po_mstr then do:
				po_pr_list  = v_po_pr_list .
				po_pr_list2 = v_po_pr_list2 .
				v_po_pr_list = "" .
				v_po_pr_list2 = "" .
				release po_mstr .
			end.

	end. /*if last-of(c_nbr) then*/
end.  /*for each xchg_det no-lock*/


for each xchg_det exclusive-lock 
		where c_domain = global_domain 
		and c_stat02 = yes 
		and c_detail = "x" ,  
	each temp 
		where t_nbr = c_nbr and t_line = c_line 
		and t_app = yes no-lock
	break by c_nbr by c_line by c_date_to :
	
	find first pod_Det where pod_domain = global_domain and pod_nbr = c_nbr and pod_line = c_line  no-lock no-error .
	if avail pod_det then do:
		if pod_statu = "X" then do:
			create xchg_hist .
			assign 
				xch_domain = global_domain
				xch_wk	   = v_wk 
				xch_site   = c_site 
				xch_nbr    = c_nbr
				xch_line   = c_line
				/**/ xch_detail = c_detail
				xch_part      = c_part
				xch_date_to	  = c_date_to
				xch_date_from = c_date_from 
				xch_qty		  = c_qty 
				xch_qty_to    = c_qty_to 
				xch_date01    = c_date01
				xch_date02    = c_date02
				xch_user01    = c_user01
				xch_user02    = c_user02 
				xch_req_nbr   = c_req_nbr 
				xch_req_line  = c_req_line 
				xch_id        = c_id .	
			delete xchg_Det.
		end.
		/*****
		else do: /*出错*/
			create xchg_hist .
			assign 
				xch_domain = global_domain
				xch_wk	   = v_wk 
				xch_site   = c_site 
				xch_nbr    = c_nbr
				xch_line   = c_line
				/**/ xch_detail = ""
				xch_part      = c_part
				xch_date_to	  = c_date_to
				xch_date_from = c_date_from 
				xch_qty		  = c_qty 
				xch_qty_to    = c_qty_to 
				xch_date01    = c_date01
				xch_date02    = c_date02
				xch_user01    = c_user01
				xch_user02    = c_user02 
				xch_req_nbr   = c_req_nbr 
				xch_req_line  = c_req_line 
				xch_id        = c_id .	
		end.
		*****/
	end.
/*****
	else do:
			create xchg_hist .
			assign 
				xch_domain = global_domain
				xch_wk	   = v_wk 
				xch_site   = c_site 
				xch_nbr    = c_nbr
				xch_line   = c_line
				/**/ xch_detail = ""
				xch_part      = c_part
				xch_date_to	  = c_date_to
				xch_date_from = c_date_from 
				xch_qty		  = c_qty 
				xch_qty_to    = c_qty_to 
				xch_date01    = c_date01
				xch_date02    = c_date02
				xch_user01    = c_user01
				xch_user02    = c_user02 
				xch_req_nbr   = c_req_nbr 
				xch_req_line  = c_req_line 
				xch_id        = c_id .	
	end.  /*出错*/
****/

end.  /*for each xchg_det */


/*part4:删除已执行的修改计划***********************************/
/*for each xchg_det exclusive-lock 
		where c_domain = global_domain 
		and c_stat02 = yes  ,
	each temp 
		where t_nbr = c_nbr and t_line = c_line 
		and t_app = yes no-lock
	break by c_nbr by c_line by c_date_to :

	delete xchg_Det.
end.  for each xchg_det */



end. /*updateloop:*/



if v_poc_pt_req then do:
	find first poc_ctrl where poc_domain = global_domain  no-error .
	if avail poc_ctrl then assign poc_pt_req = yes .
    find first mfc_ctrl  where mfc_domain = global_domain and  mfc_field = "poc_pt_req" no-error.
    if avail mfc_ctrl then mfc_logical = yes .

	release  poc_ctrl .
	release  mfc_ctrl .
end.
if v_poc_pl_req then do:
	find first poc_ctrl  where poc_domain = global_domain  no-error .
	if avail poc_ctrl then assign poc_pl_req = yes .
	release  poc_ctrl .
end.



if v_all_ok = no then do:
			message "有错误发生,请参考log.err" view-as alert-box.
end. 
else do:
			message "...计划执行完成..."  .
end.

/********************************************************/

procedure write_error_to_log:
	define input parameter file_name as char .
	define input parameter file_name_o as char .
	define output parameter v_ok as logical .
	define variable linechar as char .
	define variable woutputstatment as char.

	linechar = "" .
	input from value (file_name_o) .

		repeat: 
			import unformatted woutputstatment.                         

			IF  index (woutputstatment,"ERROR:")   <> 0 OR    /* for us langx */ 
				index (woutputstatment,"错误:")	<> 0 OR    /* for ch langx */
				index (woutputstatment,"岿粇:")	<> 0       /* for tw langx */ 		     
			then do:			  
				output to  value ( "log.err") APPEND.
					put unformatted today " " string (time,"hh:mm:ss")  " " file_name_o " " woutputstatment  skip.
				output close.
				linechar = "ERROR" .			  
			end.		     
		End.

	input close.
/* */
	if linechar <> "ERROR" then do:
		unix silent value ("rm -f "  + trim(file_name)).
		unix silent value ("rm -f "  + trim(file_name_o)).
	end. 

	v_ok = if linechar = "ERROR" then no else yes .

end. /*PROCEDURE write_error_to_log*/