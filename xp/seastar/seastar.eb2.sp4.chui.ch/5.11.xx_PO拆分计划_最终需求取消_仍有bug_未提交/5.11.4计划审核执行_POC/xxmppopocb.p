{mfdeclre.i}

/*variables for pod delete */
define variable use-log-acctg          as logical        no-undo.
define new shared variable podnbr      like pod_nbr.
define new shared variable podline     like pod_line.
define new shared variable blanket     like mfc_logical.
define new shared variable qty_ord     like pod_qty_ord.
define new shared variable del-yn      like mfc_logical.
define variable v_file   as char format "x(40)" .


/*variables for cimload */
define variable outfile   as char format "x(40)"  no-undo.  /*for cimload*/
define variable outfile1  as char format "x(40)"  no-undo.  /*for cimload*/
define variable quote     as char initial '"'     no-undo.  /*for cimload*/
define variable v_ok      like mfc_logical initial yes no-undo.  /*for cimload*/
define variable v_all_ok  like mfc_logical initial yes no-undo.  /*for cimload*/
define var v_poc_pt_req like poc_pt_req initial no .  /*for cimload*/
define var v_poc_pl_req like poc_pl_req initial no .  /*for cimload*/
define var v_po_pr_list2  like po_pr_list2 .  /* 防止错误:默认价格,'高于价格表最高价格'*/
define var v_po_pr_list   like po_pr_list .   /* 防止错误:默认价格,'高于价格表最高价格'*/



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
	field t_detail2  as char format "X(2)"
	field t_id       as integer 
	field t_app      as logical format "Y/N" label "审" . 



/*temp-table for pod delete : xpod_det in database */
/*temp-table for pod delete : xrqpo_ref */
define temp-table xrqpo_ref 
	field xrqpo_req_nbr  like  rqpo_req_nbr 
	field xrqpo_req_line like  rqpo_req_line
	field xrqpo_po_nbr   like  rqpo_po_nbr
	field xrqpo_po_line  like  rqpo_po_line 
	field xrqpo_qty_ord  like  rqpo_qty_ord 
	field xrqd_status    like  rqd_status 
	field xrqd_open      like  rqd_open .

/*temp-table for all new pod waitting for cimload */
define var i as integer label "t_newline" . 
define temp-table xx_det 
	field x_nbr      like po_nbr              
	field x_newline  like pod_line   /*new pod line*/    
	field x_oldline  like pod_line   /*old pod line*/   
	field x_part     like pod_part 
	field x_date     like po_ord_date
	field x_qty      like pod_qty_ord 
	field x_id       as integer . 

define temp-table ok_det field ok_nbr like po_nbr .  /*-->记录中途有错发生,但是之前正确已完成的单号*/

define var v_wk as char label "历史记录的周别" .

{pocnvars.i}  /*for po_consignment ,pod_consignment*/
/***********************************end define ********************************************************/

for each ok_det : delete ok_det .  end.


updateloop:
do on error undo, leave :
/** 主程式先检查所有计划都有对应pod,且锁定pod ****************************************************************/


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


/*
c_detail 含义: 1码C-change X-cancel 2码N-normal R-received X-cancel
组合后 
CN,XN 要拆分法更新
CR,XR,XX 直接字段更新
空,不更新
*/
/*part1: 不做调整部分******************************************************************************/
/* c_detail = ""  */
for each xchg_det 
		where  c_stat02 = yes 
		and c_detail = "" exclusive-lock ,
	each temp 
		where t_id = c_id 
		and t_app = yes no-lock
	break by c_nbr by c_line by c_date_to :

	create xchg_hist .
	assign 
		xch_wk	   = v_wk 
		xch_site   = c_site 
		xch_nbr    = c_nbr
		xch_line   = c_line
		xch_podline   = c_line
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

delete xchg_det .
end.


/*part2: 仅调整日期部分******************************************************************************/
/* c_detail = "CR,XR,XX"  */
for each xchg_det exclusive-lock 
		where c_stat02 = yes 
		and ( c_detail = "CR" or c_detail = "XR" or c_detail = "XX") ,
	each temp 
		where t_id = c_id 
		and t_app = yes no-lock
	break by c_nbr by c_line by c_date_to :

	find first pod_det 
		where pod_nbr = c_nbr 
		and pod_line = c_line 
	exclusive-lock no-error.
	if avail pod_det then do:
		assign pod_due_date = c_date_to .
		
		create xchg_hist .
		assign 
			xch_wk	   = v_wk 
			xch_site   = c_site 
			xch_nbr    = c_nbr
			xch_line   = c_line
			xch_podline   = c_line
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

		delete xchg_det .
	end.
end.




/*part3: 做拆分部分******************************************************************************/
/* c_detail = "CN,XN"  */

v_all_ok = yes . /*所有拆分导入无误*/
v_file = "xpoddet" + mfguser + ".d" .
find first poc_ctrl no-error .
if not avail poc_ctrl then do:
	message "错误:采购模块未启用." view-as alert-box.
end.
v_poc_pl_req = poc_pl_req .
poc_pt_req = no .
poc_pl_req = no .
find first mfc_ctrl  where mfc_field = "poc_pt_req" no-error .
if avail mfc_ctrl then do:
	v_poc_pt_req = mfc_logical  .
	mfc_logical = no .
end.
else do:
	create mfc_ctrl.
	assign
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


for each xchg_det exclusive-lock 
		where c_stat02 = yes  
		and ( c_detail = "CN" or c_detail = "XN") ,
	each temp 
		where t_id = c_id 
		and t_app = yes no-lock	
	break by c_nbr by c_line by c_date_to :

	if first-of(c_nbr) then do :

			for each xpod_det where xpod_nbr = c_nbr exclusive-lock :
				delete xpod_Det .
			end.

			for each xrqpo_ref :
				delete xrqpo_ref .
			end.

			for each xx_det :
				delete xx_Det .
			end.

			i = 0 .
			v_po_pr_list = "" .
			v_po_pr_list2 = "" .	
			find first po_mstr where po_nbr = c_nbr  no-error .
			if avail po_mstr then do:
				v_po_pr_list  = po_pr_list .
				v_po_pr_list2 = po_pr_list2 .
				po_pr_list = "" .
				po_pr_list2 = "" .
			end.
	end. /*if first-of(c_nbr) */

	i = i + 1 .
	create  xx_Det .
	assign  x_nbr = c_nbr 
			x_oldline = c_line
			x_part    = c_part
			x_date    = c_date_to
			x_qty     = c_qty_to 
			x_id      = c_id 
			x_newline    = i .
	
	/*预写入历史,如不成功再删掉*/
	find first xchg_hist where xch_wk = v_wk and xch_id = c_id exclusive-lock no-error. 
	if not avail xchg_hist then do:
		create xchg_hist .
		assign 
			xch_wk	   = v_wk 
			xch_site   = c_site 
			xch_nbr    = c_nbr
			xch_line   = c_line
			xch_podline   = 0 /*新项:正确后更新*/
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
	
	if last-of(c_nbr) then do:

		for each pod_det  use-index pod_nbrln  
					where pod_nbr = c_nbr 
					and pod_stat = "" 
					and pod_qty_rcvd = 0 
					exclusive-lock 
					break by pod_nbr by pod_line :

			find first xpod_det 
				where xpod_nbr = pod_nbr 
				and xpod_line  = pod_line
				and xpod_part  = pod_part
				and xpod_qty_ord = pod_qty_ord 
			no-lock no-error .
			if not avail xpod_det then do :
				output to value(v_file) .
				export pod_det .
				output close .
				input from  value(v_file) .
				create xpod_det .
				import xpod_det .
				input close .

				release xpod_det.

				/*start 不需做修改的未收料项次,也需删除调整项次*/
				find first xx_det where x_nbr = pod_nbr and x_oldline = pod_line no-lock no-error .
				if not avail xx_det then do:
					i = i + 1 .
					create  xx_Det .
					assign  x_nbr = pod_nbr 
							x_oldline = pod_line
							x_part    = pod_part
							x_date    = pod_due_date
							x_qty     = pod_qty_ord 
							x_newline    = i .
				end.
				/*end 不需做修改的未收料项次,也需删除调整项次*/

			end. /*if not avail xpod_det */

			find first xpod_det 
				where xpod_nbr = pod_nbr 
				and xpod_line  = pod_line
				and xpod_part  = pod_part
				and xpod_qty_ord = pod_qty_ord 
			no-lock no-error .
			if avail xpod_det then do :
				/******begin 删除old*/
					/* DELETE LOGISTICS ACCOUNTING tx2d_det RECORDS FOR THIS LINE */
					if use-log-acctg then do:
						 {gprunmo.i &module = "LA" &program = "lataxdel.p"
									&param  = """(input '48',
												  input pod_nbr,
												  input pod_line)"""}
					end.

					/* 执行delete like : popomth.p --> 
					{pxrun.i &PROC = 'deletePurchaseOrderLine' 
							 &PROGRAM   = 'popoxr1.p' */	
					assign   podnbr  = xpod_nbr 
							 podline = xpod_line
							 del-yn  = yes.
					{gprun.i ""popomta2.p""}
					
					/*删除后,PR改为open*/
					for each rqm_mstr exclusive-lock
							where rqm_nbr = xpod_req_nbr  ,
						each rqd_det exclusive-lock 
							where rqd_nbr = xpod_req_nbr and rqd_line = xpod_req_line  :

							find first rqpo_ref where rqpo_req_nbr = rqd_nbr 
												and rqpo_req_line = rqd_line 
												and rqpo_po_nbr = podnbr 
												and rqpo_po_line = podline 
							exclusive-lock no-error .
							if avail rqpo_ref then do:
								create xrqpo_ref .
								assign 
									xrqpo_req_nbr  =  rqpo_req_nbr 
									xrqpo_req_line =  rqpo_req_line 
									xrqpo_po_nbr   =  rqpo_po_nbr 
									xrqpo_po_line  =  rqpo_po_line 
									xrqpo_qty_ord  =  rqpo_qty_ord 
									xrqd_status    =  rqd_status 
									xrqd_open      =  rqd_open  .
								delete rqpo_ref .
							end.


						/* from popomth.p --> popodel.p */ 
						assign  rqd_status = "" 
								rqd_open   = true
								rqm_status = ""
								rqm_open   = true
								rqm_rtdto_purch = true /*rqm_rtdto_purch , add by roger */.   
					end.
				/******end 删除old*/
			end. /*if avail xpod_det */
		end. /*for each pod_det*/


		/* start output ***************************************************************************/
		outfile = "mppocrt"
				+ TRIM ( string(year(TODAY)) 
				+ string(MONTH(TODAY)) 
				+ string(DAY(TODAY)))  
				+ trim(STRING(TIME)) 
				+ trim(string(RANDOM(1,100))) 
				+  ".i"  .
		outfile1 = outfile + ".o" .

		output to value(outfile) .	
				/*start po_mstr 头*/
				find first po_mstr where po_nbr = c_nbr no-lock no-error .
				if avail po_mstr then do:
					
					put unformatted	quote trim(po_nbr)      quote space skip .
					put unformatted	 " - " skip .
					put unformatted	 " - " skip .
					if po_print = no then put skip .
					put unformatted	 " -  -  -  -  -  -  -  - " .
					put unformatted	 " -  -  -  -  - " .
					put unformatted	 " -  -  -  -  -  -  -  -  -  - " skip .
					if ( not can-find(first prh_hist where prh_nbr = po_nbr)) and  po_curr <> base_curr then 
							put unformatted	 " -  - "skip . /*外币汇率*/
					put unformatted	 " -  -  -  -  - " skip . /*纳税*/	
					if use-log-acctg  then 
						put unformatted	 " -  - " skip .  /*po_tot_terms_cod*/
					if using_supplier_consignment and po_consignment  = yes then do:
						put unformatted	 " -  - " skip .  /*寄售天数,成本点*/ 
					end.
				end.
				/*end  po_mstr 头*/


				i = 0 .
				for each xx_det exclusive-lock break by x_nbr by x_part by x_date :
						/*start 依次寻找可写入的项号*/
						repeat :
							i = i + 1 .
							find first pod_det use-index pod_nbrln where pod_nbr = x_nbr and pod_line = i no-lock no-error .
							if avail pod_Det then do:
								repeat :
									i = i + 1 .
									find next pod_det use-index pod_nbrln where pod_nbr = x_nbr and pod_line = i no-lock no-error .
									if not avail pod_Det then leave.
								end. /*repeat :*/					
								leave .
							end.
							else leave .
						end. /* repeat : */

						x_newline = i .
						/*end  依次寻找可写入的项号*/
						
						find first xpod_Det where xpod_nbr = x_nbr and xpod_line = x_oldline  no-lock no-error .
						if avail xpod_det then do:
							put unformatted	trim(string(x_newline))       space skip .
							put unformatted	quote trim(xpod_site)      quote    space skip .
							put unformatted	quote trim(xpod_req_nbr)   quote space 
											trim(string(xpod_req_line))  space skip .
							put unformatted	" - " skip . /*part*/
							put unformatted x_qty  space "-" space skip .
							put unformatted " -  - " skip . /*截止日/利息*/
							put unformatted xpod_pur_cost   space "-" space skip .
							put unformatted " -  -  -  -  -  " .
							put unformatted trim(string(x_date))   space .
							put unformatted	trim(string(xpod_per_date))   space
											trim(string(xpod_need))       space 
											" -  -  -  -  -  -  -  -  -  -  -  - " skip  .

							if xpod_taxable then 
								put unformatted	 " -  -  -  -  - " skip . /*纳税*/

							if can-find (first vp_mstr where vp_mstr.vp_part >= ""
														and  vp_mstr.vp_vend >= ""
														and  vp_mstr.vp_vend_part >= "")
							then do:
								find first po_mstr where po_nbr = xpod_nbr no-lock no-error .
								
								find first vp_mstr where vp_part = x_part 
													and  vp_vend = po_vend 
								no-lock no-error.
								if available vp_mstr then do:
									if vp_q_price <> xpod_pur_cost 
										and vp_um = xpod_um
										and vp_curr = po_curr 
										and xpod_qty_ord >= vp_q_qty
									then do:
										put unformatted "N" space skip . /*不更新报价*/
									end.
								end.
							end.  /*if can-find (first vp_mstr*/
						end. /*if avail xpod_det*/
				end. /*for each xx_det no-lock*/

			/*start po_mstr 尾*/
				put unformatted  "." skip.
				put unformatted  "." skip.
				put unformatted  " - " skip .
				put unformatted  " -  -  -  -  -  -  -  -  -  -  - " skip .
			/*end  po_mstr 尾*/
		output close .
		
		/* end  output ***************************************************************************/

		/* start 执行新增**************************************************************************/
		batchrun = yes .
		input from value (outfile) .
			output to  value ( outfile1) .
				{gprun.i ""pomt.p"" "(input false)"}						
			output close.
		input close.

		find first po_mstr where po_nbr = c_nbr  no-error .
		if avail po_mstr then do:
			po_pr_list  = v_po_pr_list .
			po_pr_list2 = v_po_pr_list2 .
			v_po_pr_list = "" .
			v_po_pr_list2 = "" .
		end.
		
		/*errorlog*/
		v_ok = yes .
		run write_error_to_log(input outfile,input outfile1 ,output v_ok) . 
		if v_ok = no then do:
				
				/**删除新增的POD项次*********/
				for each pod_det  
							where pod_nbr = c_nbr 
							and pod_stat = "" 
							and pod_qty_rcvd = 0 
							exclusive-lock 
							break by pod_nbr by pod_line :

						/******begin 删除*/
							/* DELETE LOGISTICS ACCOUNTING tx2d_det RECORDS FOR THIS LINE */
							if use-log-acctg then do:
								 {gprunmo.i &module = "LA" &program = "lataxdel.p"
											&param  = """(input '48',
														  input pod_nbr,
														  input pod_line)"""}
							end.

							/* 执行delete like : popomth.p --> 
							{pxrun.i &PROC = 'deletePurchaseOrderLine' 
									 &PROGRAM   = 'popoxr1.p' */	
							assign   podnbr  = pod_nbr 
									 podline = pod_line
									 del-yn  = yes.
							{gprun.i ""popomta2.p""}

						
							/*删除后,PR改为open*/
							for each rqm_mstr exclusive-lock
									where rqm_nbr = pod_req_nbr  ,
								each rqd_det exclusive-lock 
									where rqd_nbr = pod_req_nbr and rqd_line = xpod_req_line  :

									find first rqpo_ref where rqpo_req_nbr = rqd_nbr 
														and rqpo_req_line = rqd_line 
														and rqpo_po_nbr = podnbr 
														and rqpo_po_line = podline 
									exclusive-lock no-error .
									if avail rqpo_ref then do:
										delete rqpo_ref .
									end.


								/* from popomth.p --> popodel.p */ 
								assign  rqd_status = "" 
										rqd_open   = true
										rqm_status = ""
										rqm_open   = true
										rqm_rtdto_purch = true /*rqm_rtdto_purch , add by roger */.   
							end.
						/******end 删除*/
				end. /*for each pod_det*/


				/**rebuild old Pod_det*********/
				for each xpod_det  
							where xpod_nbr = c_nbr 
							and xpod_stat = "" 
							and xpod_qty_rcvd = 0 
							exclusive-lock 
							break by xpod_nbr by xpod_line :
					find first pod_det 
						where pod_nbr = xpod_nbr 
						and pod_line  = xpod_line
						and pod_part  = xpod_part
						and pod_qty_ord = xpod_qty_ord 
					no-lock no-error .
					if not avail pod_det then do :
						output to value(v_file) .
						export xpod_det .
						output close .
						input from  value(v_file) .
						create pod_det .
						import pod_det .
						input close .

						release pod_det.

					end. /*if not avail pod_det */


					delete xpod_det .  /*删除xpod_det备份资料*/
				end. /*for each xpod_det*/

				/**rebuild old rqpo_ref & close or open rqd_det .*********/
				for each xrqpo_ref no-lock :
						find first rqpo_ref where rqpo_req_nbr = xrqpo_req_nbr  
											and rqpo_req_line = xrqpo_req_line 
											and rqpo_po_nbr = xrqpo_po_nbr 
											and rqpo_po_line = xrqpo_po_line 
						exclusive-lock no-error .
						if not avail rqpo_ref then do:
							create rqpo_ref .
							assign 
								rqpo_req_nbr  =  xrqpo_req_nbr 
								rqpo_req_line =  xrqpo_req_line 
								rqpo_po_nbr   =  xrqpo_po_nbr 
								rqpo_po_line  =  xrqpo_po_line 
								rqpo_qty_ord  =  xrqpo_qty_ord   .
						end.
						else do:
							if rqpo_qty_ord  <>  xrqpo_qty_ord then do:
								delete rqpo_ref .
								create rqpo_ref .
								assign 
									rqpo_req_nbr  =  xrqpo_req_nbr 
									rqpo_req_line =  xrqpo_req_line 
									rqpo_po_nbr   =  xrqpo_po_nbr 
									rqpo_po_line  =  xrqpo_po_line 
									rqpo_qty_ord  =  xrqpo_qty_ord   .
							end.
						end.
						find first rqd_det where rqd_nbr = rqpo_req_nbr and  rqd_line = rqpo_req_line exclusive-lock no-error .
						if avail rqd_det then do:
							assign rqd_open = xrqd_open rqd_status = xrqd_status .
						end.
				end. /*for each xrqpo_ref*/



				/**mrp_det丢了 ,再run才准****************************************************************/
				/******************************************************************/
				/******************************************************************/
				/******************************************************************/
				/******************************************************************/



				/*删掉预写入的历史*/
				for each xx_det no-lock :					
					find first xchg_hist 
							where xch_wk = v_wk 
							and xch_id = x_id 
							/*and xch_nbr = x_nbr 
							and xch_line = x_oldline 
							and xch_podline   = 0 
							and ( xch_detail = "CN" or xch_detail = "XN") 排除xx_det包含的非拆分项*/
					exclusive-lock no-error. 
					if avail xchg_hist then do:
						delete xchg_hist .
					end.
				end. /*for each xx_det*/

				if v_all_ok = yes then v_all_ok = no .
				if v_all_ok =  no then do:
					message "错误:拆分更新不成功,请参考log.err" view-as alert-box.
					undo updateloop, leave updateloop.
				end.


		end.   /*if v_ok = no */
		else do:  /*if v_ok = yes */

			/*start 写回原项次的PR转PO审核信息*/
			for each xx_det no-lock break by x_nbr by x_newline :
				find first xchg_hist 
						where xch_wk = v_wk 
						and xch_id = x_id 
						/*and xch_nbr = x_nbr 
						and xch_line = x_oldline 
						and xch_part = x_part
						and xch_date_to = x_date 
						and xch_qty_to = x_qty 
						and xch_podline   = 0 
						and ( xch_detail = "CN" or xch_detail = "XN") 排除xx_det包含的非拆分项*/
				exclusive-lock no-error. 
				if avail xchg_hist then do:
					xch_podline = x_newline .
				end.
				
				find first xpod_det where xpod_nbr = x_nbr 
									and xpod_line = x_oldline 
				no-lock no-error .
				if avail xpod_det then do :
					find first pod_det where pod_nbr  = xpod_nbr 
										 and pod_line = x_newline 
										 and pod_req_nbr  = xpod_req_nbr 
										 and pod_req_line = xpod_req_line 
					exclusive-lock no-error .
					if avail pod_det then do :
							assign  pod__chr01  = xpod__chr01
									pod__chr02	= xpod__chr02
									pod__chr03	= xpod__chr03
									pod__dte01	= xpod__dte01 .
					end.
				end.
			end.  
			/*end 写回原项次的PR转PO审核信息*/


			/*删除xpod_det等备份资料*/
			for each xpod_det where xpod_nbr = c_nbr exclusive-lock :
				delete xpod_Det .
			end.

			for each xrqpo_ref :
				delete xrqpo_ref .
			end.
			
			create ok_det . assign ok_nbr = c_nbr .

		end. /*if v_ok = yes */

		/* end  执行新增**************************************************************************/

	end. /*if last-of(c_nbr) then*/
end.  /*for each xchg_det no-lock*/



end. /*updateloop:*/



/*即使cimload出错,也会执行(outside the updateloop)*/
if v_all_ok = yes then do:
			/*删除所有xchg_det*/
			for each xchg_det exclusive-lock 
				where c_stat02 = yes  
				and ( c_detail = "CN" or c_detail = "XN")
				break by c_nbr by c_line by c_date_to :
				find first xchg_hist 
						where xch_wk = v_wk 
						and xch_id = c_id 
				exclusive-lock no-error. 
				if avail xchg_hist then do:
					delete xchg_det .
				end.
			end.
					message "...全部执行完成..."  .
end.
else do:
			/*删除其中正确的xchg_det*/
			for each ok_det ,
				each xchg_det exclusive-lock 
					where c_nbr = ok_nbr
					and   c_stat02 = yes  
					and ( c_detail = "CN" or c_detail = "XN")
					break by c_nbr by c_line by c_date_to :
				find first xchg_hist 
						where xch_wk = v_wk 
						and xch_id = c_id 
				exclusive-lock no-error. 
				if avail xchg_hist then do:
					delete xchg_det .
				end.
			end.	
end. /*if v_all_ok = no*/



unix silent value ("rm -f "  + trim(v_file)). /*删除备份xpod的file*/
if v_poc_pt_req then do:
	find first poc_ctrl  no-error .
	if avail poc_ctrl then assign poc_pt_req = yes .
    find first mfc_ctrl  where mfc_field = "poc_pt_req" no-error.
    if avail mfc_ctrl then mfc_logical = yes .

	release  poc_ctrl .
	release  mfc_ctrl .
end.
if v_poc_pl_req then do:
	find first poc_ctrl  no-error .
	if avail poc_ctrl then assign poc_pl_req = yes .
	release  poc_ctrl .
end.

/* end  all            **************************************************************************/
/**********************************************************************************************************************************************************************************/



/*procedure define : *******************************************************/

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

	if linechar <> "ERROR" then do:
		unix silent value ("rm -f "  + trim(file_name)).
		unix silent value ("rm -f "  + trim(file_name_o)).
	end.

	v_ok = if linechar = "ERROR" then no else yes .

end. /*PROCEDURE write_error_to_log*/