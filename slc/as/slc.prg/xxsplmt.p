/*By: Neil Gao 08/10/31 ECO: *SS 20081031* */

{mfdtitle.i "n+"}

define var site like ld_site init "10000".
define var planid like xxspl_id.
define var shipto like so_ship.
define var cust like so_cust.
define var sonbr like so_nbr.
define var soline like sod_line.
define var sodpart like pt_part.
define var desc1 like pt_desc1.
define var planqty like ld_qty_oh.
define var sopo like so_po.
define var sopo1 like so_po.
define var del-yn as logical.
define var xxrmks as char VIEW-AS EDITOR size 60 by 3.

/*
define temp-table tt1 
	field tt1_nbr like sod_nbr
	field tt1_line like sod_line
	field tt1_part like sod_part
	field tt1_desc like sod_desc
	field tt1_
*/
form
	planid colon 10 label "计划号"
	cust   colon 40 label "客户"
	shipto colon 60 label "发货至"
	xxspl_shp_date colon 10 
	xxspl_status 
	xxrmks colon 10 label "备注"
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

view frame a.

form
	sonbr colon 25
	soline colon 25
	/*glnbr colon  label "关联订单"*/
	xxspld_part colon 25 
	desc1 colon 25 no-labels
	skip(1) 
	xxspld_qty_ord colon 25
	planqty colon 25 label "已安排数量"
	skip(1) 
	xxspld_qty_ship colon 25
	skip(1)
with frame c side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).


mainloop:
repeat with frame a:
	
	clear frame c all no-pause.
	clear frame a all no-pause.
	update	planid with frame a editing:
		if frame-field = "planid" then do:
			{mfnp05.i xxspl_mstr xxspl_id
       		" xxspl_domain = global_domain and xxspl_site = site"
            xxspl_id  planid}
      if recno <> ? then do:
      	xxrmks = xxspl_rmks.
      	disp  xxspl_id @ planid 
      			  xxspl_cust @ cust
      			  xxspl_ship @ shipto
      			  xxspl_shp_date
      			  xxspl_status
      			  xxrmks
      			  with frame a.
      end.
		end.
		else do:
			status input .
			readkey.
			apply lastkey.
		end.
	end. /*editing */
	if planid <> "" then do :
		find first xxspl_mstr where xxspl_domain = global_domain and xxspl_id = planid and xxspl_site = site no-error.
		if not avail xxspl_mstr then do:
			message "计划号不存在".
			next.
		end.
	end.
	else do:
		define variable errorst        as logical no-undo.
		define variable errornum       as integer no-undo.
		{gprun.i  ""gpnrmgv.p""
    		"('splid',
      	input-output planid,
      	output errorst,
      	output errornum)" }
    if errorst then do:
    	message "计划号没有产生".
    	next mainloop.
    end.
    disp planid with frame a.
	end.
	find first xxspl_mstr where xxspl_domain = global_domain and xxspl_id = planid and xxspl_site = site no-error.
	if not avail xxspl_mstr then do:
		update cust shipto with frame a editing:
                 global_addr = input cust.
                 status input.
                 readkey.
		   apply lastkey.
              end. /* editing */
		if shipto = "" then shipto = cust.
		disp shipto with frame a.
		
		find first cm_mstr where cm_domain = global_domain and cm_addr = cust no-lock no-error.
		if not avail cm_mstr then do:
			message "客户不存在".
			undo,retry.
		end.
		find first cm_mstr where cm_domain = global_domain and cm_addr = shipto no-lock no-error.
		if not avail cm_mstr then do:
			find first ad_mstr where ad_domain = global_domain and ad_addr = shipto and ad_ref = cust no-lock no-error.
			if not avail ad_mstr then do:
				message "发货-至不正确".
				undo,retry.
			end.
		end.
		create xxspl_mstr.
		assign xxspl_domain = global_domain 
					 xxspl_site   = site
					 xxspl_id = planid
					 xxspl_cust = cust
					 xxspl_ship = shipto
					 xxspl_crt_date = today
					 .
	end.
	else do:
		cust = xxspl_cust.
		shipto = xxspl_ship.
		disp cust shipto with frame a.
	end.
	
	xxrmks = xxspl_rmks.
	
	disp xxspl_status xxrmks with frame a.

	if xxspl_status <> "" then do:
		message "状态不能修改".
		next mainloop.
	end.
	
	update xxspl_shp_date xxrmks go-on("ctrl-d") with frame a .

        if lastkey = keycode("ctrl-d") then do:
          del-yn = yes.
          {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         	
	   if del-yn then  do:
             for each xxspld_det where xxspld_domain = global_domain and xxspld_site = xxspl_site 
               and xxspld_id = xxspl_id :
               delete xxspld_det.
             end.
             delete xxspl_mstr.
             next mainloop.
          end.
        end.
	
	xxspl_rmks = xxrmks.
	
	loop1:
	repeat:
		
		update sonbr soline with frame c editing:
			if frame-field = "sonbr" then do:
				{mfnp05.i xxspld_det xxspld_nbr
       		" xxspld_domain = global_domain and xxspld_site = site and xxspld_id = planid"
            xxspld_nbr sonbr}
      	if recno <> ? then do:
      		disp  xxspld_nbr @ sonbr 
      				  xxspld_line @ soline
      				  xxspld_qty_ord
      			  	xxspld_qty_ship
      			  	xxspld_part
      			  	with frame c.
      		find first pt_mstr where pt_domain = global_domain and pt_part = xxspld_part no-lock no-error.
					if avail pt_mstr then	disp pt_desc1 @ desc1 with frame c.
      		run jsspldqty (input site, input xxspld_nbr ,input xxspld_line, output planqty).
      		disp planqty with frame c.
      	end.
			end.
			else do:
				status input .
				readkey.
				apply lastkey.
			end.
		end.

		if soline = 999 then do:
			find first so_mstr where so_domain = global_domain and so_nbr = sonbr no-lock no-error.
			if not avail so_mstr then do:
				message "错误:订单号不存在".
				next.
			end.
			if so_cust <> cust then do:
				message "错误:客户不相同".
				next.
			end.
			run crtspld (input sonbr).
			message "确认订单项已加入".
			next loop1.
		end.

		find first sod_det where sod_domain = global_domain and sod_nbr = sonbr and sod_line = soline no-lock no-error.
		if not avail sod_det then do:
			message "订单项不存在".
			next.
		end.
		
		if not sod_confirm then do:
			message "销售订单没有确认".
			next.
		end.

		find first so_mstr where so_domain = global_domain and so_nbr = sonbr no-lock no-error.
		if avail so_mstr then do:
			if so_cust <> cust then do:
				message "客户不相同".
				next.
			end.
      if so_po <> "" then do:
				if so_po <> so_nbr then
        	message "关联订单:" so_po.
        else do:
          sopo = so_po.
          sopo1 = "".
          for each so_mstr where so_domain = global_domain and so_po = sopo no-lock:
             if so_nbr <> sopo then
             sopo1 = sopo1 + so_nbr + " ". 
          end.
          message "关联订单:" sopo1.
        end.
      end.
		end.
		
		run jsspldqty (input site, input sonbr ,input soline, output planqty).
		disp planqty with frame c.
		
		find first xxspld_det where xxspld_domain = global_domain and xxspld_site = site and xxspld_id = xxspl_id and
			xxspld_nbr = sonbr and xxspld_line = soline no-error.
		if not avail xxspld_det then do:
			create xxspld_det.
			assign xxspld_domain = global_domain 
						 xxspld_site = site
						 xxspld_id = xxspl_id
						 xxspld_nbr = sonbr
						 xxspld_line = soline
						 xxspld_part = sod_part
						 xxspld_qty_ord = sod_qty_ord
						 .
		end.
		
		disp xxspld_part with frame c.
		find first pt_mstr where pt_domain = global_domain and pt_part = xxspld_part no-lock no-error.
		if avail pt_mstr then do:
			disp pt_desc1 @ desc1 with frame c.
		end.
		disp xxspld_qty_ord with frame c.
		
		loop2:
		do on error undo,retry:
			find first xxspld_det where xxspld_domain = global_domain and xxspld_site = site and xxspld_id = xxspl_id and
			xxspld_nbr = sonbr and xxspld_line = soline no-error.

			update xxspld_qty_ship go-on("ctrl-d") with frame c .
		       
                     if lastkey = keycode("ctrl-d") then do:
                       del-yn = yes.
                       {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         	
	 		   if del-yn then  do:
                          
                          delete xxspld_det.
                          next loop1.
                        end.
                     end.
			run jsspldqty (input site, input sonbr ,input soline, output planqty).
			if planqty  > sod_qty_ord then undo,retry.
			disp planqty with frame c.
			message "保存成功".
		end.
		
	end. /* loop1 */
	
end. /* mainloop */


procedure jsspldqty :
	define input parameter iptsite like ld_site.
	define input parameter iptsonbr like so_nbr.
	define input parameter iptsoline like sod_Line.
	define output parameter optqty like xxspld_qty_ship.
	
	optqty = 0.
	for each xxspld_det where xxspld_domain = global_domain and xxspld_site = iptsite and
		xxspld_nbr = iptsonbr and xxspld_line = iptsoline no-lock:
		optqty = optqty + xxspld_qty_ship.
	end.
end. 

procedure crtspld:
	define input parameter iptf1 like so_nbr.
	for each sod_det where sod_domain = global_domain and sod_nbr = iptf1 and sod_confirm :
		run jsspldqty (input site, input sod_nbr ,input sod_line, output planqty).
		if sod_qty_ord - planqty > 0 then do:
			create xxspld_det.
			assign xxspld_domain = global_domain 
					 xxspld_site = site
					 xxspld_id = planid
					 xxspld_nbr = sod_nbr
					 xxspld_line = sod_line
					 xxspld_part = sod_part
					 xxspld_qty_ord = sod_qty_ord
					 xxspld_qty_ship = sod_qty_ord - planqty
					 .
		end.
		
	end.
end.
