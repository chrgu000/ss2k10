/* By: Neil Gao Date: 07/11/15 ECO: * ss 20071115.1 */
/* By: Neil Gao Date: 07/12/19 ECO: * ss 20071219 */
/*By: Neil Gao 08/04/18 ECO: *SS 20080418* */
/*By: Neil Gao 08/09/02 ECO: *SS 20080902* */
/*SS - 100524.1 BY KEN*/ 

{mfdeclre.i}  
{gplabel.i} 

define new shared var site like pt_site init "11000".
define var xxvend  like po_vend.
define var xxvend1 like po_vend.
define var xxreq	like req_nbr.
define var xxreq1 like req_nbr.
define var xxreldate like req_rel_date.
define var xxreldate1 like req_rel_date. 
define var i as int.
define var tt_recid as recid no-undo.
define var xxmsg1 as char format "x(70)".
define var xxmsg2 as char format "x(70)".
define var totqty like pod_qty_ord.
define var pcpct like vp_tp_pct.
define var im as int init 1.
define var tdate1 as date.
define var tdate2 as date.
define var tyr as int.
define var tmn as int.
define var tmn1 as int.
define var tqty1 like pod_qty_ord.
define var tqty2 like pod_qty_ord.
define var tqty3 like pod_qty_ord.
define var tqty4 like pod_qty_ord.
define var isel as logical init "yes".

{xxpopomt01.i "new"}

define temp-table ttpct_det
	field ttpct_part like pod_part
	field ttpct_vend like po_vend
	field ttpct_name like ad_name
	field ttpct_pct 	like vp_tp_pct
	field ttpct_totqty like pod_qty_ord
	field ttpct_totpct like vp_tp_pct
	index ttpct_part
				ttpct_part ttpct_vend.

form
   site     colon 12
   xxvend     colon 12 label "供应商"
   xxvend1    colon 45 label "至"
   xxreq		colon 12   label "申请号"
   xxreq1		colon 45   label "至"
   xxreldate   colon 12   label "发放日期"
   xxreldate1  colon 45   label "至"
   im					colon 12  label "订单计算月"
   isel       colon 25  label "默认选择"
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
		
form
	xxreq_sel   label "选"
	xxreq_vend  label "供应商"
	xxreq_nbr   label "申请号"
	xxreq_sonbr label "订单"
	xxreq_wolot label "派工单"
	xxreq_reldate label "发放日期"
	xxreq_part  label "物料号"
	xxreq_qty   label "数量" format ">>>>>>>9.9<"
	/*xxreq_type  label "类"*/
with frame b down width 80 .

setFrameLabels(frame b:handle).

form
	ttpct_vend   label "供应商"
	ttpct_name   label "名称"
	ttpct_pct    label "设置比例"
	ttpct_totqty label "实际下单数量"
	ttpct_totpct  label "实际比例"
with frame c down width 80.

setFramelabels(frame c:handle).

/* DISPLAY */
view frame a.

mainloop:
repeat with frame a:
   
   if xxvend1 = hi_char then xxvend1 = "".
   if xxreq1 = hi_char  then xxreq1 = "".
   if xxreldate  = low_date then xxreldate = ?.
   if xxreldate1 = hi_date  then xxreldate1 = ?.
   
   update 
   	site 
    xxvend xxvend1
   	xxreq  xxreq1
   	xxreldate xxreldate1
   	im
   	isel
   with frame a.
   
   if xxvend1 = "" then xxvend1 = hi_char.
   if xxreq1 = "" then xxreq1 = hi_char.
   if xxreldate  = ? then xxreldate  = low_date.
   if xxreldate1 = ? then xxreldate1 = hi_date.
   
	 for each xxreq_det:
	 	delete xxreq_det.
	 end.
	 
	 for each req_det where req_domain = global_domain and req_site = site
	 	and req_nbr >= xxreq and req_nbr <= xxreq1 
	 	and req_rel_date >= xxreldate and req_rel_date <= xxreldate1
	 	and req_user1 >= xxvend and req_user1 <= xxvend1 no-lock,
	 	each pt_mstr where pt_domain = global_domain and pt_part = req_part 
	 	and (pt_buyer = global_userid or global_userid = "mfg" or global_userid = "LGP01")
	 	no-lock:
	 		
	 	create xxreq_det.
	 	assign xxreq_sel = ""
	 				 xxreq_vend = req_user1 
	 				 xxreq_nbr  = req_nbr
	 				 xxreq_part = req_part
	 				 xxreq_reldate = req_rel_date
	 				 xxreq_qty  = req_qty
	 				 xxreq_wolot = req_so_job
	 				 xxreq_expert = req_user2.
	 	if req_user2 = "SO" then xxreq_type = "SO".
	 	if isel and xxreq_vend <> "" then do:
	 		xxreq_sel = "*".
	 	end.
	 	
	 	find first wo_mstr where wo_domain = global_domain and wo_lot = req_so_job no-lock no-error.
	 	if avail wo_mstr then assign xxreq_sonbr = wo_so_job.
	 	
	 end.
	 
	 	tmn1 = year(today) * 12 + month(today).
		if day(today) > 21 then do:
	 		tmn1 = tmn1 + 1.
	 	end.
	 	tyr = int(trunc((tmn1 - im) / 12,0)).
	 	tmn = ( tmn1 - im ) mod 12.
	 	if tmn = 0 then assign tyr = tyr - 1 tmn = 12.
	 	tdate1 = date(tmn,21,tyr).
	 	
	 	tyr = int(trunc(tmn1 / 12,0)).
	 	tmn = tmn1 mod 12.
	 	if tmn = 0 then assign tyr = tyr - 1 tmn = 12.
	 	tdate2 = date(tmn,21,tyr).
	 	
	 	empty temp-table ttpct_det.	 	
	 	for each xxreq_det /*where xxreq_vend = ""*/ no-lock break by xxreq_part:
			if first-of(xxreq_part) then do:
				tqty2 = 0.
				for each vp_mstr where vp_domain = global_domain and vp_part = xxreq_part and vp_vend <> "" and vp_tp_pct > 0 no-lock,
				each ad_mstr where ad_domain = global_domain and ad_addr = vp_vend no-lock
				break by vp_vend :
					if last-of(vp_vend) then do:
						tqty1 = 0.
						for each po_mstr where po_domain = global_domain and po_vend = vp_vend 
							and po_ord_date >= tdate1 and po_ord_date <= tdate2 no-lock,
							each pod_det where pod_domain = global_domain and po_nbr = pod_nbr and pod_part = vp_part no-lock:
							tqty1 = tqty1 + pod_qty_ord /*- pod_qty_rtnd*/ .
						end.
						create ttpct_det.
						assign ttpct_part = xxreq_part
									 ttpct_vend = vp_vend
									 ttpct_name = ad_name
									 ttpct_pct  = vp_tp_pct
									 ttpct_totqty = tqty1.
						tqty2 = tqty2 + tqty1.		
					end.
				end.
				if tqty2 > 0 then do:
					for each ttpct_det where ttpct_part = xxreq_part:
						ttpct_totpct = round( ttpct_totqty / tqty2 * 100,2).
					end.
				end.
			end. /* if first-of(xxreq_part) */
		end.
	 
   find first xxreq_det no-lock no-error.
   if not avail xxreq_det then do:
   		message "没有未安排的申请".
   		next.
   end.
   hide frame a no-pause.
   hide frame c no-pause.
   
   scroll_loop:
   do with frame b:
   	/*SS - 100524.1 B*/ 	
      /*
      
      
          &include1 = "	
          						run mvdp (input recid(xxreq_det)).
                           "
                           
          change to                  
          &include1 = "	
          						run mvdp (input recid(xxreq_det)).
                           run mtvend (input recid(xxreq_det)).    

          						"
                           
      */

    	{xusel.i
         &detfile = "xxreq_det"
         &scroll-field = xxreq_part
         &framename = "b"
         &framesize = 8
         &display1     = xxreq_sel
         &display2     = xxreq_vend
         &display3     = xxreq_nbr
         &display4     = xxreq_sonbr
         &display5     = xxreq_wolot
         &display6     = xxreq_part
         &display7     = xxreq_reldate
         &display8     = xxreq_qty
         &sel_on    = ""*""
         &sel_off   = """"
         &exitlabel = scroll_loop
         &exit-flag = true
         &record-id = tt_recid
         &CURSORDOWN = "
         								run mvdp (input recid(xxreq_det)).
                       "
         &CURSORUP   = "
         								run mvdp (input recid(xxreq_det)).
                       "
          &include1 = "	
          						run mvdp (input recid(xxreq_det)).
                           run mtvend (input recid(xxreq_det)).    

          						"
          &include2 = "
          							run mvdp (input recid(xxreq_det)).
          							run mtvend (input recid(xxreq_det)).
          							
          						"
   		}
   		/*SS - 100524.1 E */
   		    									
   		hide frame b no-pause.
   		
   end. /* do with frame b */
   hide frame a no-pause.
   hide frame b no-pause.
   hide frame c no-pause.
   
   if keyfunction(lastkey) = "end-error" then next.
   
   find first xxreq_det where xxreq_sel <> "" no-lock no-error.
   if not avail xxreq_det then do:
   		message "没有选择申请".
   end.
   else do:
   	for each xxreq_det use-index xxreq_vend where xxreq_sel <> "" and xxreq_vend <> "" no-lock break by xxreq_type by xxreq_vend :
   		if first-of(xxreq_vend) then 
   			{gprun.i ""xxpomt02.p"" "(input false,
   																input xxreq_type,
   	 														 input xxreq_vend)"}
   	 	pause 0.
   	end.
   end.
   
end. /* mainloop */     														  
   
status input.

procedure mvdp:
	clear frame c all.
	hide frame c no-pause.
	define input parameter xxr as recid.  
	find first xxreq_det where recid( xxreq_det ) = xxr no-error.
  find first pt_mstr where pt_domain = global_domain and pt_part = xxreq_part no-lock no-error.
  if avail pt_mstr then message pt_desc1 pt_desc2.
 	find first cd_det where cd_domain = global_domain and cd_ref = xxreq_part and cd_type = "SC" and cd_lang = "CH" no-lock no-error.
 	if avail cd_det then message cd_cmmt[1].
 	for each ttpct_det where ttpct_part = xxreq_part no-lock:
 		disp ttpct_vend ttpct_name ttpct_totqty ttpct_totpct ttpct_pct with frame c.
 		down with frame c.
 	end.
 	
end procedure.

procedure mtvend:
	define input parameter xxr as recid.  
  find first xxreq_det where recid( xxreq_det ) = xxr no-error.
  	do on error undo,retry:
  		disp xxreq_sel xxreq_vend with frame b.
  		prompt xxreq_vend xxreq_qty with frame b.
  		find first vd_mstr where vd_domain = global_domain and vd_addr = input xxreq_vend no-lock no-error.
    	if not avail vd_mstr then do: 
    		message "供应商存在". 
    		undo,retry . 
    	end.
    	find first vp_mstr where vp_domain = global_domain and vp_part = xxreq_part and vp_vend = input xxreq_vend no-lock no-error.
    	if not avail vp_mstr then do: 
    		message "不是此物料的配套供应商". 
    		undo,retry. 
    	end.
    	if input xxreq_qty > xxreq_qty then do:
    		message "输入数量大于申请量".
    		undo,retry.
    	end.
    	if input xxreq_qty < 0 then do:
    		message "数量不能小于零".
    		undo,retry.
    	end.
    	assign xxreq_vend.
    	if input xxreq_qty < xxreq_qty then do:
				tqty3 = input xxreq_qty.
				tqty4 = xxreq_qty - input xxreq_qty.
				if frame-line(b) < frame-down(b) then 
				down with frame b.
    		scroll from-current down with frame b.
    		do sw_i = frame-down(b) to frame-line(b) + 1 by -1:
        	 sw_frame_recid[sw_i] = sw_frame_recid[sw_i - 1].
     		end.
     		disp tqty4 @ xxreq_qty with frame b.
     		do on error undo,retry:
     			prompt xxreq_vend with frame b.
     			find first vp_mstr where vp_domain = global_domain and vp_part = xxreq_part and vp_vend = input xxreq_vend no-lock no-error.
    			if not avail vp_mstr then do: 
    				message "不是此物料的配套供应商". 
    				undo,retry. 
    			end.
    			run crtxxreq (input xxreq_nbr,input (input xxreq_vend),input tqty3,input tqty4).
     		end. /* do on error undo */
  		end.
  		else assign xxreq_qty.
   	end.
   	hide frame c no-pause.
end procedure.

procedure crtxxreq:
	define input parameter iptnbr like req_nbr.
	define input parameter iptvend like po_vend.
	define input parameter iptqty1 like req_qty.
	define input parameter iptqty2 like req_qty.
	define var tmpnbr like wo_nbr.
	
	&GLOBAL-DEFINE dputline1 "" .
	&GLOBAL-DEFINE dputline2 "" .
	&GLOBAL-DEFINE dputline3 "" .
	&GLOBAL-DEFINE dputline4 "" .
	&GLOBAL-DEFINE dputline5 "" .					
	
	find first xxreq_det where xxreq_nbr = iptnbr no-lock no-error.
	if avail xxreq_det then do:
		xxreq_qty = iptqty1.
		tmpnbr = xxreq_sonbr.
	end.
	find first req_det where req_domain = global_domain and req_nbr = iptnbr no-error.
	if avail req_det then do:
		create xxreq_det.
	 	assign xxreq_sel = "*"
	 				 xxreq_vend = iptvend 
	 				 /*xxreq_nbr  = req_nbr*/
	 				 xxreq_part = req_part
	 				 xxreq_reldate = req_rel_date
	 				 xxreq_qty  = iptqty2
	 				 xxreq_wolot = req_so_job
	 				 xxreq_sonbr = tmpnbr
	 				 .
	 	global_addr = "".
	 	{xxcimmd.i &putline1 = "' '"
	  	         &putline2 = "req_part ' ' req_site"
		           &putline3 = "iptqty2 ' ' req_rel_date ' ' req_need  ' ' iptvend ' ' req_so_job"
			         &putline4 = "''"
			         &putline5 = "'.'"
			         &execname = "xxpoprmt.p"
								           }
		if global_addr <> "" then do:
			req_qty = iptqty1.
			xxreq_nbr = global_addr.
	 		sw_frame_recid[frame-line(b)] = recid(xxreq_det).
	 		disp xxreq_sel xxreq_vend xxreq_nbr xxreq_sonbr xxreq_wolot xxreq_part xxreq_reldate xxreq_qty with frame b.
		end.
	end.
	
end procedure.
