/*By: Neil Gao 08/08/29 ECO: *SS 20080829* */

/* DISPLAY TITLE */
{mfdtitle.i "090621.1"}

{xxdeclre.i "new"}
{xxdeclre1.i}

define var site  like ld_site init "11000".
define var sonbr like so_nbr.
define var cust like so_cust.
define var shipto like so_ship.
define var reqdate like so_req_date.
define var part like sod_part.
define var qty like sod_qty_ord.
define var i as int.
define var tt_recid as recid no-undo.
define var sonbrtype as char.
define variable errorst        as logical no-undo.
define variable errornum       as integer no-undo.
define variable v_number       as char  no-undo.
define var xxchannel as char.
define var curr like cu_curr.
define var xxcmmt as char format "x(76)" extent 5.
define var outrst as int.

define temp-table tsod_det
	field tsod_sel  as char format "x(1)"
	field tsod_line like sod_line
	field tsod_part like sod_part
	field tsod_desc1 like pt_desc1
	field tsod_desc2 like pt_desc2
	field tsod_qty  like qty.

{xxdrsomt.i "new"}

form
	sonbr   label "销售订单"
	cust 
	shipto
	xxchannel label "订单类型"
	skip
	reqdate label "需求日期"
	curr    label "币别"
	part    label "物料号"
	/*qty*/
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
	tsod_sel	label "选"
	tsod_line label "项"
	tsod_part label "物料号"
  tsod_desc1 label "名称"
  /*tsod_desc2 label "规格"*/
  tsod_qty   label "数量"
with frame b down width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

form
	xxcmmt no-label
with frame c side-labels with width 80 attr-space.
	
mainloop:
repeat:
	 
	update sonbr with frame a editing:
		if frame-field = "sonbr" then do:
			{mfnp05.i so_mstr so_nbr "so_domain = global_domain and so_nbr begins 's' " so_nbr "input sonbr"}
		end.
		else do:
			status input.
			readkey.
			apply lastkey.
		end.
		if recno <> ? then do:	
			disp 	so_nbr @ sonbr 
						so_cust @ cust
						so_ship @ shipto
						so_curr @ curr
						so_req_date @ reqdate with frame a.
		end.
	end.
	
	if sonbr <> "" and not ( sonbr begins "s" ) then do:
		message "不是售后件订单".
		next.
	end.
	
	
	find first so_mstr where so_domain = global_domain and so_nbr = sonbr no-lock no-error.
	if avail so_mstr then do:
		cust = so_cust.
		shipto = so_ship.
		reqdate = so_req_date.
		xxchannel = so_channel.
		curr = so_curr.
		disp cust shipto reqdate xxchannel with frame a.
		update part /*qty*/ with frame a.
	end.
	else do:
		update cust shipto xxchannel reqdate curr part /*qty*/  with frame a.
	
		find first cm_mstr where cm_domain = global_domain and cm_addr = cust no-lock no-error.
		if not avail cm_mstr then do:
			{pxmsg.i &msgnum = 3 &errorlevel = 3}
			next.
		end.
		if shipto = "" then shipto = cust .
		disp shipto with frame a.
	
		if curr = "" then curr = cm_curr.
		disp curr with frame a.
	
		if lookup(xxchannel,"S1,S2,S3,S4") = 0 then do:
			message "错误:订单类型只能为S1,S2,S3,S4".
			next.
		end.
	
		if reqdate = ? or reqdate < today  then do:
			message "错误: 日期不能小于今天".
			next.
		end.
	end.
	if part <> "" or not avail so_mstr then do:
		find first ps_mstr where ps_domain = global_domain and ps_par = part no-lock no-error.
		if not avail ps_mstr then do:
			{pxmsg.i &msgnum = 5642 &errorlevel = 3}
			next.
		end.
	end.
		
	if sonbr <> "" then do:
		find first so_mstr where so_domain = global_domain and so_nbr = sonbr no-lock no-error.
		if not avail so_mstr then do:
			{pxmsg.i &msgnum = 1 &errorlevel = 1}
		end. 	
		else do:
			{pxmsg.i &msgnum = 10 &errorlevel = 2}
		end.
	end.
	
	
	empty temp-table tsod_det.
	
	find last sod_det where sod_domain = global_domain and sod_nbr = sonbr no-lock no-error.
	if not avail sod_det then i = 1.
	else i = sod_line + 1.
	
/*SS 20081112 - B*/
/*	
	for each ps_mstr where ps_domain = global_domain and ps_par = part no-lock,
		each pt_mstr where pt_domain = global_domain and pt_part = ps_comp no-lock:
		
		create 	tsod_det.
		assign 	tsod_line = i
						tsod_part = ps_comp
						tsod_desc1 = pt_desc1
						tsod_desc2 = pt_desc2
						tsod_qty = 0.
		i = i + 1.
	end.
*/
	{xxzkbommt.i "tsod_det" "part" "tsod_part" "today" "tsod_qty" }
	for each tsod_det ,
		each pt_mstr where pt_domain = global_domain and pt_part = tsod_part no-lock:
		tsod_line = i.
		tsod_qty = 0.
		tsod_desc1 = pt_desc1.
		tsod_desc2 = pt_desc2.
		i = i + 1.
	end.
	
/*SS 20081112 - E*/
	
	find first tsod_det no-lock no-error.
	if not avail tsod_det then do:
		{pxmsg.i &msgnum = 5011 &error = 3}
	end.

   	hide frame a no-pause.
   	hide frame c no-pause.
	
		scroll_loop:
   	do with frame b:
   	 	
    	{xusel.i
         &detfile = tsod_det
         &scroll-field = tsod_sel
         &framename = "b"
         &framesize = 8
         &display1     = tsod_sel
         &display2     = tsod_line
         &display3     = tsod_part
         &display4     = tsod_desc1
         &display6     = tsod_qty
         &sel_on    = ""*""
         &sel_off   = """"
         &include2  = "update tsod_qty with frame b."
         &include1  = "tsod_qty = 0. disp tsod_qty with frame b."
         &CURSORDOWN = " if avail tsod_det then
         									run dispmv ( input tsod_part) .
         								"
         &CURSORUP  = "  if avail tsod_det then
         								run dispmv ( input tsod_part) .
         							"
         &exitlabel = scroll_loop
         &exit-flag = true
         &record-id = tt_recid
			   		}
   		
   		hide frame a no-pause.
   		hide frame b no-pause.
   		hide frame c no-pause.
   		
   		if keyfunction(lastkey) = "end-error" then do:
   			next mainloop.
   		end.
   		
   		if sonbr = "" then do:
   			{gprun.i  ""gpnrmgv.p""
            		"('sonbr3',
              	input-output sonbr,
              	output errorst,
              	output errornum)" }
        if errorst then do:
        	message "订单号没有产生".
        	next mainloop.
        end.
			end.
   		
   		empty temp-table tt_tb.
   		for each tsod_det where tsod_sel = "*" no-lock break by tsod_line :
   			find first in_mstr where in_domain = global_domain and in_site = site and in_part = tsod_part no-lock no-error.
   			if not avail in_mstr then do:
   				{gprun.i ""xxdycrtsiin.p"" "(input site,input tsod_part,output outrst)"}
   			end.
   			if first(tsod_line) then do:
   				create tt_tb. assign 	tt_sel = 1 tt_f1 =  "@@begin".
					create tt_tb. assign 	tt_sel = 2 tt_f1 =  sonbr + "," + cust + "," + shipto.
					if not avail so_mstr then do:
						create tt_tb. assign 	tt_sel = 3 tt_f1 = string(today) + " " + string(reqdate) + " - " +
														string(reqdate) + " - " + " - " + " - " +  part + " - " + " - " + site + " "+ xxchannel + " - - " + curr
														.
					end.
					else do:
						create tt_tb. assign 	tt_sel = 3 tt_f1 = "-".
					end.
				end.
				create tt_tb. 	assign 		tt_sel = 4 tt_f1 =  """" + """" + "," + tsod_part + "," + string(tsod_qty)
														tt_recid = recid(xtsod_det).
				if last(tsod_line) then do:
			 		create tt_tb. assign tt_sel = 4 tt_f1 =  "@@end" .
				end.
   		end.
   		
   		pause 0.
			find first tt_tb no-lock no-error.
			if avail tt_tb then
				{gprun.i ""xxdrsosomt.p""}
			
			find first so_mstr where so_domain = global_domain and so_nbr = sonbr no-lock no-error.
			if avail so_mstr then do:
				empty temp-table tt_tb.
				create tt_tb. assign 	tt_sel = 1 tt_f1 =  "@@begin".
				create tt_tb. assign 	tt_sel = 2 tt_f1 =  sonbr + "," + so_cust + "," + so_ship.
				create tt_tb. assign tt_sel = 4 tt_f1 =  "@@end" .
   			{gprun.i ""xxdrsosomt.p""}
   		end.
   		/*评审*/
   		if avail so_mstr and (so_channel = "S1" or so_channel = "S4") then do:
   			for each sod_det where sod_domain = global_domain and sod_nbr = sonbr no-lock:
   				find first xxcffw_mstr where xxcffw_key1 = "check1" and xxcffw_key_nbr = sod_nbr
					and xxcffw_key_line = sod_line no-lock no-error.
					if not avail xxcffw_mstr then do:
						{gprun.i ""xxdylcmt01.p"" "(input 'check1',input sod_nbr ,input sod_line)"}
						if so_channel <> "S1" then do:
							find first xxcffw_mstr where xxcffw_key1 = "check1" and xxcffw_key_nbr = sod_nbr
							and xxcffw_key_line = sod_line no-error.
							if avail xxcff_mstr then xxcff_nbr = "120".
						end.
					end.
   			end.
   		end.
   		
		end.
	
end. /* Mainloop */

procedure dispmv:
	define input parameter iptpart like pt_part.
	find first cd_det where cd_domain = global_domain and cd_ref = iptpart no-lock no-error.
	if avail cd_det then do:
		xxcmmt[1] = cd_cmmt[1].
		xxcmmt[2] = cd_cmmt[2].
		xxcmmt[3] = cd_cmmt[3].
		xxcmmt[4] = cd_cmmt[4].
		xxcmmt[5] = cd_cmmt[5].
	end.
	else xxcmmt = "".
	
	disp xxcmmt with frame c.
	
end procedure.