/* xxrqpochk.p      PO审核程式                                              */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      LAST MODIFIED: 10/08/07   BY: Softspeed roger xiao    */
/*-Revision end---------------------------------------------------------------*/


/* DISPLAY TITLE */
{mfdtitle.i "1+ "}

define variable isAuthorized        as integer initial 0  .
define var v_site like po_site label "地点" .
define var vend like po_vend label "供应商" .
define var nbr    like po_nbr label "采购单号".
define var i as integer.	/*pod实有项次数*/
define var j as integer .	/*pod最后项次*/
define var v_adjust as logical initial no . /*是否重整po项次*/
define var v_yn   as logical label "核准" .


define var date like po_ord_date label "起" .
define var date1  like po_ord_date label "止" .
define var nbr1   like po_nbr label "至".

/*var for xxswslxp01.i*/
define variable first_sw_call as logical initial true no-undo.
define variable temp_recno  as recid                no-undo.
define variable l_error       as integer              no-undo.
define variable include_cons_ent as logical           no-undo.
define variable select_all    as logical              no-undo.


define new shared var v_lt   as logical label "满足LT" .
define new shared temp-table temp 
	field t_select   as char  format "x(1)"   
	field t_nbr      like po_nbr              
	field t_line     like pod_line       
	field t_podline     like pod_line  
	field t_date     like po_ord_date         
	field t_part     like pod_part            
	field t_qty      like pod_qty_ord         
	field t_price    like pod_pur_cost        
	field t_app      as logical  format "Yes/No" 
	field t_rmks     as char format "x(60)"      . 

/*var for pod delete */
define variable use-log-acctg          as logical        no-undo.
define new shared variable podnbr      like pod_nbr.
define new shared variable podline     like pod_line.
define new shared variable blanket     like mfc_logical.
define new shared variable qty_ord     like pod_qty_ord.
define new shared variable del-yn      like mfc_logical.

define variable vfile as char format "x(16)".
define variable quote as char initial '"' no-undo.

define var v_poc_pt_req like poc_pt_req initial no .  /*for cimload*/
define var v_poc_pl_req like poc_pl_req initial no .  /*for cimload*/

define temp-table xxpod_det 
	field xxpod_nbr     like pod_nbr 
	field xxpod_line    like pod_line 
	field xxpod_req_nbr like pod_req_nbr 
	field xxpod_req_line     like pod_req_line 	
	field xxpod_site         like pod_site 
	field xxpod_part         like pod_part
	field xxpod_um           like pod_um 
	field xxpod_qty_ord      like pod_qty_ord
	field xxpod_pur_cost     like pod_pur_cost
	field xxpod_due_date     like pod_due_date
	field xxpod_need         like pod_need	
	field xxpod_per_date     like pod_per_date
	field xxpod__chr01	     like pod__chr01
	field xxpod__chr02	     like pod__chr02
	field xxpod__chr03	     like pod__chr03
	field xxpod__dte01		 like pod__dte01
	field xxpod__dec01		 like pod__dec01
	.




/*var initialized */
date = date(month(today),1,year(today)) .
date1 = today .
v_yn = no .
blanket = no .
v_site = "10000" . 
global_site = v_site .



define  frame a.
define  frame c.
define new shared  frame b.

/* DISPLAY SELECTION FORM */
form
	v_site  column-label "地点"
	vend    column-label "供应商"
	nbr     column-label "采购单号"
	
	v_yn    column-label "核准" colon 70


with frame a side-labels no-underline width 80 attr-space.
/*setFrameLabels(frame a:handle). */

form
	t_select  label "选"
	t_nbr     column-label "采购单" 
	t_line    column-label "项" 
	t_date    column-label "订单日期"
	t_part    label "零件"
	t_qty     label "订单数量"
	t_price   label "价格" 
	t_app     label "审核"

with frame c down width 80 .     




form
	t_nbr       label "采购单" 
	pod_part    no-label 	    colon 18
	po_cr_terms label "支付方式" colon 50
	pod_need    label "需求日"   colon 68

	t_line      label "项次"    colon 5
	pt_desc1    no-label		colon 18
	po_curr     label "币别"	    colon 50
	pt_pur_lead label "采购提前" colon 68

	t_app       label "审核"    colon 5
	pt_desc2    no-label		colon 18
    v_lt        label "满足LT"  colon 68

	t_rmks      label "备注"  colon 5
with frame b side-labels width 80 attr-space.         


/* DISPLAY */
view frame a.
view frame c.
view frame b.

mainloop:
repeat with frame a:
    clear frame a no-pause .
    clear frame c all no-pause .
	clear frame b no-pause .
	v_adjust = no .
	nbr = "" .
	v_site = global_site .

    update v_site with frame a .

	find first si_mstr where si_site = v_site no-lock no-error .
	if avail si_mstr then do:

		  {gprun.i ""gpsiver.p"" 
			 "(input v_site,
			   input ?,
			   output isAuthorized)"}

		  if isAuthorized = 0 then do:
				/* MESSAGE #725 - USER DOES NOT HAVE ACCESS TO THIS SITE. */
				message "用户没有这个地点的存取权限" view-as alert-box .
				undo,retry .
		  end.
	end.
	else do:
		message "地点:" v_site "无效,请重新输入." view-as alert-box.
		undo,retry .
	end.


    update vend  with frame a editing:
		if frame-field = "vend" then do:
				/* FIND NEXT/PREVIOUS  RECORD */
               {mfnp.i vd_mstr vend vd_addr vend vd_addr vd_addr}
               if recno <> ? then do:
                  vend = vd_addr.
                  display vend with frame a.
				  recno = ?.
               end.
		end.
		else do:
			status input.
			readkey.
			apply lastkey.
		end.
	end. /*update */

	update nbr  with frame a editing:
		if frame-field = "nbr" then do:
			if vend = "" then do :
				/* FIND NEXT/PREVIOUS RECORD */
				{mfnp.i po_mstr nbr po_nbr nbr " po_site = v_site and po_stat = '' and po__chr01 = ''  and po_nbr " po_nbr}
				if recno <> ? then do:
					nbr = po_nbr.
					display nbr with frame a.
					recno = ?.
				end.
			end.
			else do :
				/* FIND NEXT/PREVIOUS RECORD */
				{mfnp01.i po_mstr nbr po_nbr vend "po_site = v_site and po_stat = '' and po__chr01 = '' and po_vend " po_nbr}
				if recno <> ? then do:
					nbr = po_nbr.
					display nbr with frame a.
					recno = ?.
				end.				
			end.

		end.
		else do:
			status input.
			readkey.
			apply lastkey.
		end.


	end. /*update */

	if nbr = "" then do :
		message "警告:必须输入采购单号" .
		undo,retry .
	end.
	else do:
		find first po_mstr use-index po_nbr where po_nbr = nbr and po_stat = "" and po_site = v_site exclusive-lock no-error.
		if avail po_mstr then do :
			if vend <> "" and vend <> po_vend then do:
				message "警告:采购单非指定的供应商:" vend .
			end.


			find first pod_det where pod_nbr = po_nbr and pod__chr01 = "" no-lock no-error.
			if avail pod_det then do : 
				message "错误:采购单:" po_nbr "有未审核的项次,暂不能核准".
				undo ,retry .
 			end.


			/*find first pod_det where pod_nbr = po_nbr and pod_qty_rcvd <> 0 no-lock no-error.
			if avail pod_det then do:
				message "错误:采购单已发放并已收货,不可再核准".
				undo ,retry .
			end. */

			find last pod_det where pod_nbr = po_nbr no-lock no-error .
			j = if avail pod_det then pod_line else  0 .
			if j = 0 then do :
				message "错误:采购单无项次,请重新输入." .
				undo,retry .
			end.

			vend = po_vend .
			nbr  = po_nbr .
			disp vend nbr with frame a .
		end.
		else do:
			message "错误:采购单号无效或已结,请重新输入." .
			undo,retry .
		end.
	end.

	

	for each temp:
		delete temp.
	end.	
    clear frame c all no-pause .
	clear frame b no-pause .

	for each po_mstr use-index po_nbr
		where po_nbr = nbr  and po_stat = "" exclusive-lock :
		/*and po_ord_date >= date and po_ord_date <= date1 
		and (po__chr01 = "" 未审核or审核未过 or v_app = no )*/
		
		i = 0 .
		for each pod_det where pod_nbr = po_nbr /*and (pod__chr01 = "A" )*/	
			no-lock break by pod_part by pod_need :

		    i = i + 1 .

			find first temp where t_nbr = pod_nbr and t_podline = pod_line no-lock no-error.
			if not avail temp then do:
				create temp .
				assign  t_nbr = pod_nbr 
						t_line = i
						t_podline = pod_line 
						t_part = pod_part 
						t_date = po_ord_date
						t_qty = pod_qty_ord
						t_price = pod_pur_cost
						t_app = yes
						t_select = ""
						t_rmks = pod__chr02 .
			end. /*if not avail temp*/
		end. /*for each pod_det*/
		if i <> j then do :
			v_adjust = yes .
		end.
	end. /*for each po_mstr*/
	
	find first pod_det where pod_nbr = nbr and ( pod_stat <> "" or pod_qty_rcvd <> 0 ) no-lock no-error .
	if avail pod_det then v_adjust = no . /*已收货让再核准,不可再调整项次**/
	
	find first temp no-lock no-error.
	if not avail temp then  do:
		message "无未审核的采购单." .
		undo, retry .
	end.

	sw_block:
	repeat :
		/*find first temp no-lock no-error .
		if not avail temp then leave .*/
		for first temp no-lock:
		end.		
		{xxswslxp01.i
			&detfile      = temp
			&scroll-field = t_nbr
			&framename    = "c"
			&framesize    = 6
			&sel_on       = ""*""
			&sel_off      = """"
			&display1     = t_select
			&display2     = t_nbr
			&display3     = t_line
            &display4     = t_date
			&display5     = t_part
			&display6     = t_qty
			&display7     = t_price
			&display8     = t_app
			&exitlabel    = sw_block
			&exit-flag    = first_sw_call
			&record-id    = temp_recno
			
		}
		if keyfunction(lastkey) = "end-error"
			or lastkey = keycode("F4")
			or lastkey = keycode("ESC")
		then do:
				for each temp exclusive-lock:
					delete temp.
				end.
				clear frame c all no-pause .
				clear frame b no-pause .
				undo,leave mainloop .
		end.  /*if keyfunction(lastkey)*/   
		
		if keyfunction(lastkey) = "return" or
			keyfunction(lastkey) = " "   or
			keyfunction(lastkey) = "go"
		then do:
			leave . 
		end.  

	end.  /*sw_block:*/

	loopb:
	do on error undo,retry :
			find first po_mstr where po_nbr = t_nbr no-lock no-error .
			if avail po_mstr then do:						
				v_yn = if po__chr01 = "A" then yes else  no . 
			end.

			update v_yn with frame a .
			
			j = 0 .
			for each temp no-lock break by t_nbr by t_line :
				/*审核状态调整 here*/
				if first-of(t_nbr) then do:
					find first po_mstr where po_nbr = t_nbr exclusive-lock no-error .
					if avail po_mstr then do:						
						if v_yn then po__chr01 = "A" . /*整张PO改为已审核*/
						else  do:   /*整张PO改为未审核*/
							find first pod_det where pod_nbr = po_nbr and pod_qty_rcvd <> 0 no-lock no-error.
							if avail pod_det then do:
								message "错误:采购单已收货,不可再核准".
								undo ,retry .
							end.
							else po__chr01 = "" .
						end.
						po__chr03 = global_userid .
						po__dte01 = today .
						po__dec01 = time .
					end.					
				end.

				/*message t_line t_podline j view-as alert-box  .*/

				/*确定项次调整起始项*/
				if v_Adjust then do:
					if t_line <> t_podline and j = 0 then do:
						j = t_line .
						if j > 0 then leave .
					end.
				end. /*if v_Adjust then*/
			end .   /*for each temp */
			/*项次调整start */
			if v_Adjust and j > 0  then do:

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




					message "正在整理采购单项次" .

					/* VALIDATE IF LOGISTICS ACCOUNTING IS TURNED ON */
					{gprun.i ""lactrl.p"" "(output use-log-acctg)"}

					for each xxpod_det :
						delete xxpod_Det .
					end.

					find first pod_det no-lock no-error .

					repeat :
						find next pod_det where pod_nbr = t_nbr and pod_line >= j exclusive-lock no-error .
						if avail pod_det then do:
							/*保存old :by req_nbr by req_line */
							find first xxpod_det where xxpod_nbr = pod_nbr and xxpod_line = pod_line no-lock no-error .
							if not avail xxpod_det then do :
									create xxpod_Det .
									assign  xxpod_nbr = pod_nbr 
											xxpod_line = pod_line 
											xxpod_req_nbr = pod_req_nbr
											xxpod_req_line  = pod_req_line 
											xxpod_site = pod_site 
											xxpod_part = pod_part 
											xxpod_um   = pod_um
											xxpod_qty_ord  = pod_qty_ord
											xxpod_pur_cost = pod_pur_cost
											xxpod_due_date = pod_due_date
											xxpod_need     = pod_need	
											xxpod_per_date = pod_per_date
											xxpod__chr01    = pod__chr01
											xxpod__chr02	= pod__chr02
											xxpod__chr03	= pod__chr03
											xxpod__dte01	= pod__dte01
											xxpod__dec01	= pod__dec01.
							end.

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
								assign   podnbr  = pod_nbr 
										 podline = pod_line
										 del-yn  = yes.
								{gprun.i ""popomta2.p""}
								
								/*删除后,PR改为open*/
								for each rqm_mstr exclusive-lock
										where rqm_nbr = xxpod_req_nbr 
										/*and rqm_rtdto_purch and rqm_open   and rqm_status = ""*/ ,
									each rqd_det exclusive-lock 
										where rqd_nbr = xxpod_req_nbr and rqd_line = xxpod_req_line  
										/*and rqd_status = ""   and rqd_open*/ :

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
											rqm_open   = true.   
								end.
							/******end 删除old*/

						end. /* if avail pod_det then */
						else leave .
					end.  /*repeat :*/

					/*begin********新增被删除的项次*/
					vfile = "popomt"
							+ TRIM ( string(year(TODAY)) 
							+ string(MONTH(TODAY)) 
							+ string(DAY(TODAY)))  
							+ trim(STRING(TIME)) 
							+ trim(string(RANDOM(1,100))) 
							  .
					output to value( trim(vfile) + ".i") .
						/*for each xxpod_Det no-lock :
						put xxpod_nbr "" xxpod_line "" xxpod_req_nbr "" xxpod_req_line "" xxpod_site  "" xxpod_part "" 
							xxpod_qty_ord "" xxpod_pur_cost ""
							xxpod_due_date "" xxpod_per_date "" xxpod_need skip .
						end.*/

						for each temp no-lock break by t_nbr by t_line :
							if first-of(t_nbr) then do :
								find first po_mstr where po_nbr = t_nbr no-lock no-error .
								if avail po_mstr then do:
									put unformatted	quote trim(po_nbr)      quote space skip .
									put unformatted	 " - " skip .
									put unformatted	 " - " skip .
									put unformatted	 " -  -  -  -  -  -  -  - " .
									put unformatted	 " -  -  -  -  - " .
									put unformatted	 " -  -  -  -  -  -  -  -  -  - " skip .
									if ( not can-find(first prh_hist where prh_nbr = po_nbr)) and  po_curr <> base_curr then put unformatted	 " -  - "skip . /*外币汇率*/
									put unformatted	 " -  -  -  -  - " skip . /*纳税*/	
								end.
							end.

							find first xxpod_det where xxpod_nbr = t_nbr 
									and xxpod_line = t_podline no-lock no-error .
							if avail xxpod_det then do :
								put unformatted	trim(string(t_line))       space skip .
								put unformatted	quote trim(xxpod_site)      quote    space skip .
								put unformatted	quote trim(xxpod_req_nbr)   quote space 
												trim(string(xxpod_req_line))  space skip .
								put unformatted	" - " skip . /*part*/
								put unformatted trim(string(xxpod_qty_ord))  space "-" space skip .
								put unformatted " -  - " skip . /*截止日/利息*/
								put unformatted trim(string(xxpod_pur_cost))   space "-" space skip .
								put unformatted " -  -  -  -  - " .
								put unformatted trim(string(xxpod_due_date))   space
												trim(string(xxpod_per_date))   space
												trim(string(xxpod_need))       space 
												" -  -  -  -  -  -  -  -  -  -  -  - " skip  .

								if can-find (first vp_mstr where vp_mstr.vp_part >= ""
															and  vp_mstr.vp_vend >= ""
															and  vp_mstr.vp_vend_part >= "")
								then do:
									find first po_mstr where po_nbr = xxpod_nbr no-lock no-error .
									
									find first vp_mstr where vp_part = t_part 
														and  vp_vend = po_vend 
									no-lock no-error.
									if available vp_mstr then do:
										if vp_q_price <> xxpod_pur_cost 
											and vp_um = xxpod_um
											and vp_curr = po_curr 
											and xxpod_qty_ord >= vp_q_qty
										then do:
											put unformatted "N" space skip . /*不更新报价*/
										end.
									end.
								end.  /*if can-find (first vp_mstr*/
							end.

							if last-of(t_nbr) then do:
									put unformatted  "." skip.
									put unformatted  "." skip.
									put unformatted  " - " skip .
									put unformatted  " -  -  -  -  -  -  -  -  -  -  - " skip .

							end.
						end. /*for each temp*/
					output close . /*output to*/ 
					

					batchrun = yes .
					input from value ( vfile + ".i") .
						output to  value ( vfile + ".o") .
							{gprun.i ""pomt.p"" "(input false)"}						
						output close.
					input close.


					for each temp no-lock break by t_nbr by t_line :
						find first xxpod_det where xxpod_nbr = t_nbr 
									and xxpod_line = t_podline no-lock no-error .
						if avail xxpod_det then do :
							find first pod_det where pod_nbr  = xxpod_nbr 
												 and pod_line = t_line 
												 and pod_req_nbr  = xxpod_req_nbr 
												 and pod_req_line = xxpod_req_line 
							exclusive-lock no-error .
							if avail pod_det then do :
									assign  pod__chr01  = xxpod__chr01
											pod__chr02	= xxpod__chr02
											pod__chr03	= xxpod__chr03
											pod__dte01	= xxpod__dte01 
											pod__dec01	= xxpod__dec01.
							end.
						end.
					end.

					/*end********新增被删除的项次*/


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
					message "采购单项次整理完成" .
			end. /*if v_Adjust then*/
			
			for each temp exclusive-lock:
				delete temp.
			end.
			clear frame c all no-pause .
			clear frame b no-pause .
		
	end. /*loopb*/

	global_site = v_site .
end.   /*  mainloop: */

status input.
