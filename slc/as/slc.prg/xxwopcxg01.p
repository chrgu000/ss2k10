/* By: Neil Gao Date: 07/10/11 ECO: * ss 20071011.1 */
/* By: Neil Gao Date: 08/02/28 ECO: * ss 20080228   */
/* By: Neil Gao Date: 08/03/04 ECO: * ss 20080304 * */
/*By: Neil Gao 08/04/17 ECO: *SS 20080417* */
/*By: Neil Gao 08/07/05 ECO: *SS 20080705* */

{mfdeclre.i}  
/*
{mgdomain.i}
define shared variable global_user_lang_dir as character.
define shared variable mfguser as character.
*/
{gplabel.i} 

define new shared var site like pt_site.
define var stdate as date label "日期".
define var date1 as date.
define var date2 as date.
define var sonbr  like so_nbr.
define var sonbr1 like so_nbr.
define var ord		like so_ord_date.
define var ord1		like so_ord_date.
define var line   like ln_line.
define var line1  like ln_line.
/*SS 20080417 - B*/
define var sodline like sod_line.
/*SS 20080417 - E*/
define var xxdate1 as date.
define var i as int.
define new shared variable prline   like  rps_line.
define new shared variable line_rate      like lnd_rate.
define var tt_recid as recid no-undo.
define var first-recid as recid no-undo.
define new shared variable part         like seq_part.
define new shared variable hours          as   decimal extent 4.
define new shared variable cap            as   decimal extent 4.
define variable sw_reset     like mfc_logical. 
define var tmpqty like ld_qty_oh.
define var tmppick like ld_qty_oh.
define var tmpqty1 as int. /* 缺料种类 */
define var tmpqty2 like ld_qty_oh. /* 缺料数量 */
define var tmpqty3 like ld_qty_oh.
define var inpqty like ld_qty_oh.
define var update-yn as logical.
define var tothours as decimal format ">>>>>>>9.9<" .
define var totqty   as decimal.
define var tmprmks as char.
define var ii like xxseq_priority.
define var onlyF as logical label "仅未下达" init yes.

define variable new_priority   as   decimal no-undo.
	DEFINE VARIABLE vchr_filename_in AS CHARACTER.
	DEFINE VARIABLE vchr_filename_out AS CHARACTER.	
	DEFINE VARIABLE vlog_fail_flag AS LOGICAL.

	vchr_filename_in = "./ssi" + mfguser.
	vchr_filename_out = "./sso" + mfguser.


define temp-table xuseq_mstr
	field xuseq_site like xxseq_site
	field xuseq_priority like xxseq_priority
	field xuseq_ii like xxseq_priority
  field xuseq_wod_lot like xxseq_wod_lot
  field xuseq_wod_qty like xxseq_qty_req
  field xuseq_sod_nbr like xxseq_sod_nbr
  field xuseq_sod_line like xxseq_sod_line   
  field xuseq_due_date like xxseq_due_date   
  field xuseq_line like xxseq_line       
  field xuseq_part like xxseq_part       
  field xuseq_qty_req like xxseq_qty_req
  field xuseq_qty_pick like xxseq_qty_req
  field xuseq_pick_rmks as char
  field xuseq_qty2 like xxseq_qty_req
  field xuseq_chgtype as char
  field xuseq_shift1 like xxseq_shift1
  field xuseq_status as char format "x(1)"
  index xuseq_ii
  xuseq_ii
  index xuseq_priority
  xuseq_priority.

define buffer s1 for xuseq_mstr.
define buffer s2 for xxseq_mstr.


define temp-table xuld_det
	field xuld_site like ld_site
	field xuld_part like pt_part
	field xuld_qty_oh like ld_qty_oh
	field xuld_qty_all like ld_qty_all
	field xuld_qty_pick like ld_qty_all
	field xuld_qty_ic   like ld_qty_all
	index xuld_part
	xuld_site
	xuld_part.

define temp-table xulad_det
	field xulad_site like ld_site
	field xulad_priority like xxseq_priority
	field xulad_part like pt_part
	field xulad_nbr  like wo_lot
	field xulad_qty_all like ld_qty_all
	field xulad_qty_pick like ld_qty_oh
	field xulad_ii like xuseq_ii
	index xulad_priority
	xulad_site
	xulad_priority.

form
   site			colon 12
   onlyf    colon 45
   sonbr    colon 12  sonbr1  colon 45
   date1 		colon 12  date2		colon 45
   line     colon 12   
	 sodline  colon 45 label "项"
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).


form
   xuseq_ii   column-label "序号" format ">>>>>9.9"
   xuseq_due_date   column-label "生产日期"
   xuseq_line       column-label "生产线"
   xuseq_part       column-label "物料号"
   xuseq_qty_req    column-label "数量"
   xuseq_qty_pick   column-label "成套库存"
   xuseq_pick_rmks  column-label "缺料情况"
   xuseq_status     column-label "R"
with frame d down no-attr-space width 80
title color normal (getFrameTitle("AVAILABLE_SEQUENCE_RECORDS",34)).
/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).
	
/* DISPLAY */
view frame a.

form 
	xuld_part      column-label "物料号"
	xuld_qty_oh    column-label "库存"  format "->>>>>>>"
	xuld_qty_ic   column-label "待检量" format "->>>>>>>"
	pt_desc1       column-label "名称"
	xulad_qty_all  column-label "需备料" format "->>>>>>>" 
	xulad_qty_pick column-label "已备料" format "->>>>>>>"
with frame e overlay down no-attr-space row 10 width 80.
setFrameLabels(frame e:handle).

stdate = today.
/*SS 20080705 - B*/
/*
{gprunp.i "xxproced" "p" "getglsite" "(output site)"}
*/
site = global_site.
/*SS 20080705 - E*/
/*
date1 = today.
date2 = date1 + 3.
*/
mainloop:
repeat with frame a:
   
   if sonbr1 = hi_char  then sonbr1 = "".
   if date1	 = low_date then date1  = ?.
   if date2  = hi_date  then date2 = ?.
   if line1  = hi_char 	then line1  = "".
   
   update 
   	site	onlyf
   	sonbr sonbr1
   	date1	date2
   	line 	sodline
   with frame a.
   
   global_site = site.
   
   if date1 = ? then date1 = low_date.
   if date2 = ? then date2 = hi_date.
   if line1 = "" then line1 = hi_char.
   if sonbr1 = "" then sonbr1 = hi_char.
	 
   empty temp-table xuseq_mstr.
   empty temp-table xuld_det.
   empty temp-table xulad_det.
   
   i = 1.
   
   for each xxseq_mstr where xxseq_domain = global_domain 
    and xxseq_site = site
   	and xxseq_sod_nbr >= sonbr and xxseq_sod_nbr <= sonbr1
   	and xxseq_due_date >= date1 and xxseq_due_date <= date2
		and (xxseq_line = line or line = "")
		and (xxseq_sod_line = sodline or sodline = 0)
   	and ((xxseq_user1 = "F" or xxseq_user1 = "A") or not onlyf ) no-lock
   	by xxseq_due_date by xxseq_line by xxseq_shift4:
   		
   		create xuseq_mstr.
   		assign xuseq_ii       = i
   					 xuseq_site     = xxseq_site
   					 xuseq_priority = xxseq_priority
   					 xuseq_due_date = xxseq_due_date
   					 xuseq_line     = xxseq_line
   					 xuseq_part     = xxseq_part
   					 xuseq_qty_req  = xxseq_qty_req
   					 xuseq_wod_qty  = xxseq_qty_req
   					 xuseq_wod_lot  = xxseq_wod_lot
   					 xuseq_sod_nbr  = xxseq_sod_nbr
   					 xuseq_sod_line = xxseq_sod_line
   					 xuseq_shift1   = xxseq_shift1.
   	 if xxseq_user1 <> "F" then xuseq_status = xxseq_user1.
		 i = i + 1.
   end.
   find first xuseq_mstr no-lock no-error.
   if not avail xuseq_mstr then next.
   
   view frame d.
   pause 0.
   sw_reset = yes.
   scroll_loop:
   repeat with frame d:
	 	 
	   	/*pause 0.*/
      
      if sw_reset then do:

				{gprunp.i "xxprocedwo" "p" "initld"}
   			
   			for each xuseq_mstr by xuseq_ii :
   				{gprunp.i "xxprocedwo" "p" "createld" "(	input site,
   																									input xuseq_wod_lot,
   																									input xuseq_qty_req,
   																									input xuseq_wod_qty,
   																									input xuseq_ii,
   																									input xuseq_priority,	
   																									output tmppick,
   																									output tmprmks )"}
   				xuseq_qty_pick = tmppick.
   				xuseq_pick_rmks = tmprmks.
   			end.
      	
      end.
   
      do transaction:
	
   			{xxrescrad.i xuseq_mstr "use-index xuseq_ii" xuseq_ii
            "xuseq_ii xuseq_due_date xuseq_line xuseq_part xuseq_qty_req xuseq_qty_pick xuseq_pick_rmks xuseq_status
             "
            xuseq_ii d
            "xuseq_site = site"
            "
            ii = xuseq_ii.
            run ctrlz.
            "
            " find first cd_det where cd_domain = global_domain and cd_ref = xuseq_part 
                            	and cd_lang = 'ch' no-lock no-error.
             	if avail cd_det then do:  
              	message cd_cmmt[1].
                message cd_cmmt[2].
              end.  "
            " 
            	tothours = 0.
            	totqty   = 0.
            	for each s2 where s2.xxseq_domain = global_domain and s2.xxseq_site = xuseq_mstr.xuseq_site
							and s2.xxseq_line = xuseq_mstr.xuseq_line and s2.xxseq_due_date = xuseq_mstr.xuseq_due_date no-lock :
								tothours = tothours + s2.xxseq_shift1.
								totqty   = totqty  + s2.xxseq_qty_req.
							end.
							find first pt_mstr where pt_domain = global_domain and pt_part = substring(xuseq_part,1,4) no-lock no-error.
              if avail pt_mstr then 
              	message '工时:' round(tothours,1)  '数量:' totqty  '订单:' xuseq_sod_nbr xuseq_sod_line 'ID:' xuseq_wod_lot '旧机型:' pt_desc1.
							else message '工时:' round(tothours,1)  '数量:' totqty  '订单号:' xuseq_sod_nbr xuseq_sod_line 'ID' xuseq_wod_lot.
            "
            }
      end.
      
      if keyfunction(lastkey) = "end-error" then do:
      	update-yn = no.
        {pxmsg.i &MSGNUM=36 &ERRORLEVEL=1 &CONFIRM=update-yn}
        if update-yn = yes then leave.
      end.

			/* If you press return then in modify mode */
      if keyfunction(lastkey) = "return" and recno <> ?
      then do transaction on error undo, retry:	      	
      	
				tmpqty = xuseq_ii.
				prompt-for xuseq_ii with frame d
				editing: /* active in scrolling window   */

        	{mfnp06.i xuseq_mstr xuseq_ii
          	" xuseq_site  = site "
              xuseq_ii xuseq_ii
              xuseq_ii xuseq_ii}

          if recno <> ? then do:
          	display  xuseq_ii
                     xuseq_due_date
                     xuseq_line
                     xuseq_part
                     xuseq_qty_req
                     xuseq_qty_pick
                     xuseq_pick_rmks
                     xuseq_status
            with frame d.
          end.
        end.
				
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
				end.
				else do on error undo,retry :
					find first xuseq_mstr where xuseq_ii = tmpqty no-error.
					if avail xuseq_mstr then do:
						display  xuseq_ii
                   xuseq_due_date
                   xuseq_line
                   xuseq_part
                   xuseq_qty_req
                   xuseq_qty_pick
                   xuseq_pick_rmks
                   xuseq_status
          	with frame d.
          	if xuseq_status = "R" then do:
          		message "已经派工,不能修改".
          		next .
          	end.
          	update xuseq_status validate (can-do(",A",xuseq_status), "只能输入空或A")
          	xuseq_due_date xuseq_line .
          	find first pt_mstr where pt_domain = global_domain and pt_part = xuseq_part no-lock no-error.
       			find last lnd_det where lnd_domain = global_domain and  lnd_line  =  xuseq_line
     				and lnd_site  =  site	and lnd_part = pt_part and lnd_rate <> 0
     				and lnd_start <= xuseq_due_date no-lock no-error.
       			if not avail lnd_det then 
          	find last lnd_det where lnd_det.lnd_domain = global_domain and  lnd_line  =  xuseq_line
     							and lnd_site  =  site	and lnd_part = pt_group and lnd_rate <> 0
     							and lnd_start <= xuseq_due_date no-lock no-error.
         		if not avail lnd_det then do:
         				message "生产线不存在".
         				next-prompt xuseq_line.
            		undo, retry.
         		end.
         		if xuseq_chgtype = "" then xuseq_chgtype = "mt".
         		tothours = 0.
         		for each s1 where s1.xuseq_site = xuseq_mstr.xuseq_site
							and s1.xuseq_line = xuseq_mstr.xuseq_line and s1.xuseq_due_date = xuseq_mstr.xuseq_due_date no-lock :
								tothours = tothours + s1.xuseq_shift1.	
         		end.
         		message '总工时:' round(tothours,1) .
					end.	
				end.
			end. /* if keyfunction */
			
			else if keyfunction(lastkey) = "insert-mode" then 
			do on error undo,retry:
				
				disp 0 @ xuseq_ii with frame d.
				prompt-for xuseq_ii with frame d
				editing: /* active in scrolling window   */

        	{mfnp06.i xuseq_mstr xuseq_ii
          	" xuseq_site  = site "
              xuseq_ii xuseq_ii
              xuseq_ii xuseq_ii}

          if recno <> ? then do:
          	display  xuseq_ii
                     xuseq_due_date
                     xuseq_line
                     xuseq_part
                     xuseq_qty_req
                     xuseq_qty_pick
            with frame d.
          end.
        end. /* editing */
        
				find first xuseq_mstr using xuseq_ii no-lock no-error.
				if not avail xuseq_mstr then do:
					message "记录不存在".
					prompt-for xuseq_ii.
					undo,retry.
				end.
				else 
						display  xuseq_ii
                     xuseq_due_date
                     xuseq_line
                     xuseq_part
                     xuseq_qty_req
                     xuseq_qty_pick
            with frame d.
        
				if xuseq_status <> "" then do:
        	message "已经派工,不能修改".
        	next .
        end.
				
				tmpqty = xuseq_qty_req.
				do on error undo,retry:
					update xuseq_qty_req with frame d.
					
					if xuseq_qty_req <= 0 then do:
						message "数量不能小于0或等于0".
						xuseq_qty_req = tmpqty.
						undo,retry.
					end.
					
					if xuseq_qty_req > tmpqty then do:
						message "数量不能大于原值.".
						xuseq_qty_req = tmpqty.
						undo,retry.
					end.
					
					find first pt_mstr where pt_domain = global_domain and pt_part = xuseq_part no-lock no-error.
					find last lnd_det where lnd_det.lnd_domain = global_domain and  lnd_line  =  xuseq_line
     							and lnd_site  =  site	and lnd_part = pt_part and lnd_rate <> 0
     							and lnd_start <= xuseq_due_date no-lock no-error.
     			if not avail lnd_det then
					find last lnd_det where lnd_det.lnd_domain = global_domain and  lnd_line  =  xuseq_line
     							and lnd_site  =  site	and lnd_part = pt_group and lnd_rate <> 0
     							and lnd_start <= xuseq_due_date no-lock no-error.
					
					if avail lnd_det then xuseq_shift1 = xuseq_qty_req / lnd_rate.
					
					if xuseq_qty_req < tmpqty then do:
						
						if xuseq_chgtype = "" then xuseq_chgtype = "mt".
						
						tmpqty = tmpqty - xuseq_qty_req.
						find first xxseq_mstr where xxseq_domain = global_domain 
    					and xxseq_site = site and xxseq_priority = xuseq_priority no-lock no-error.
    				if avail xxseq_mstr then do:	
   						i = xuseq_ii.
   					
   						for each xuseq_mstr use-index xuseq_priority where xuseq_ii > i :
								xuseq_ii = xuseq_ii + 1.
							end.
   					
   						create xuseq_mstr.
   						assign xuseq_ii   = i + 1
   							xuseq_site     = xxseq_site
   						 	xuseq_priority = xxseq_priority
   						 	xuseq_due_date = xxseq_due_date
   						 	xuseq_line     = xxseq_line
   						 	xuseq_part     = xxseq_part
   						 	xuseq_qty_req  = tmpqty
   						 	xuseq_wod_qty  = xxseq_qty_req
   						 	xuseq_sod_nbr  = xxseq_sod_nbr
   						 	xuseq_sod_line = xxseq_sod_line
   						 	xuseq_wod_lot  = xxseq_wod_lot
   						 	xuseq_chgtype = "add".
							if xxseq_user1 <> "F" then xuseq_status  = xxseq_user1.
							if avail lnd_det then xuseq_shift1 = xuseq_qty_req / lnd_rate.
							
						end.
						sw_reset = yes.
					end.
				end. /* do */
			end.
			else if keyfunction(lastkey) = "go"
      then do:
				
        update-yn = no.
        {pxmsg.i &MSGNUM=32 &ERRORLEVEL=1 &CONFIRM=update-yn}
        if update-yn = yes then do: 
         	
         	do transaction:

        		for each xuseq_mstr where xuseq_chgtype = "" :
        			
        			find first xxseq_mstr where xxseq_domain = global_domain 
    							and xxseq_site = site and xxseq_priority = xuseq_priority no-error.
    							if avail xxseq_mstr then do:
    								xxseq_shift4   = xuseq_ii.
    							end.
        		
        		end.
        		for each xuseq_mstr where xuseq_chgtype <> "" :
        		 
        			if xuseq_chgtype = "mt" then do:   	
        		  	find first pt_mstr where pt_domain = global_domain and pt_part = xuseq_part no-lock no-error.		
       					
       					OUTPUT TO value(vchr_filename_in).
	 										
								PUT '~"'  '~" ~"' xuseq_wod_lot '~"' SKIP.
								PUT xuseq_qty_req " - " xuseq_due_date - pt_mfg_lead " "  xuseq_due_date  " - - " xuseq_line SKIP.
								put "." skip.
								put "-" skip.
								put "." skip.
										
								OUTPUT CLOSE.
															
								INPUT FROM VALUE(vchr_filename_in).	
								OUTPUT TO VALUE(vchr_filename_out).		
	 							
								batchrun = YES.  /* In order to	disable the "Pause" message */
								{gprun.i ""xxcimwomt.p""} 
								batchrun = NO.
								INPUT CLOSE.
								OUTPUT CLOSE.
   							
								OS-DELETE VALUE("./ssi" + mfguser).
								OS-DELETE VALUE("./sso" + mfguser). 
								
								find first wo_mstr where wo_domain = global_domain and wo_lot = xuseq_wod_lot and 
									wo_due_date = xuseq_due_date and wo_vend = xuseq_line
									and wo_qty_ord = xuseq_qty_req no-lock no-error.
								if not avail wo_mstr then
								do: 
										message  "工单没有修改成功:" xuseq_wod_lot.
										pause.
								end.
								else do:
									find first xxseq_mstr where xxseq_domain = global_domain 
    							and xxseq_site = site and xxseq_priority = xuseq_priority no-error.
    							if avail xxseq_mstr then do:
    								xxseq_qty_req = xuseq_qty_req.
    								xuseq_wod_qty  = xuseq_qty_req.
    								xxseq_line    = xuseq_line.
    								xxseq_due_date = xuseq_due_date.
    								xxseq_shift1   = xuseq_shift1.
    								xxseq_shift4   = xuseq_ii.
    								if xuseq_status <> "" then xxseq_user1 = xuseq_status.
    							end.
    							
    						end.	
   							i = xuseq_ii.
            	end. /* if xuseq_chgtype = "mt" */
            	else do:
            		
            		find first pt_mstr where pt_domain = global_domain and pt_part = xuseq_part no-lock no-error.
            		
            		find first wo_mstr where wo_domain = global_domain and wo_lot = xuseq_wod_lot no-lock no-error.
            		if not avail wo_mstr then 
            		do:
            			message "工单不存在:" xuseq_wod_lot.
            			pause.
            			next.
            		end.

								&GLOBAL-DEFINE dputline1 "" .
								&GLOBAL-DEFINE dputline2 "" .
								&GLOBAL-DEFINE dputline3 "" .
								&GLOBAL-DEFINE dputline4 "" .
								&GLOBAL-DEFINE dputline5 "" .
								&GLOBAL-DEFINE dputline6 "" .
								
								{xxcimmd.i &putline1 = "wo_nbr"
								           &putline2 = "xuseq_part ' - ' site"
								           &putline3 = "xuseq_qty_req ' - ' xuseq_due_date ' ' xuseq_due_date ' F ' xuseq_sod_nbr ' 'xuseq_line"
								           &putline4 = "'.' "
								           &putline5 = "'-'"
								           &putline6 = "'.' "
								           &execname = "xxcimwomt.p"
								           }
								find first wo_mstr where wo_domain = global_domain and wo_lot = global_addr and 
									wo_part = xuseq_part and wo_site = site and 
									wo_due_date = xuseq_due_date and wo_vend = xuseq_line
									and wo_so_job = xuseq_sod_nbr no-error.
								if avail wo_mstr then do:	
									wo__dec02 = xuseq_sod_line. 
									new_priority = 0.
									find last xxseq_mstr use-index xxseq_priority where xxseq_domain = global_domain
									and xxseq_site = site no-lock no-error.
									if avail xxseq_mstr then 
										new_priority = xxseq_priority.
									new_priority = new_priority + 1.
									
									find first pt_mstr where pt_domain = global_domain and pt_part = xuseq_part no-lock no-error.
									find last lnd_det where lnd_det.lnd_domain = global_domain and  lnd_line  =  xuseq_line
     							and lnd_site  =  site	and lnd_part = pt_part and lnd_rate <> 0
     							and lnd_start <= xuseq_due_date no-lock no-error.
     							if not avail lnd_det then
									find last lnd_det where lnd_det.lnd_domain = global_domain and  lnd_line  =  xuseq_line
     							and lnd_site  =  site	and lnd_part = pt_group and lnd_rate <> 0
     							and lnd_start <= xuseq_due_date no-lock no-error.
									
									create xxseq_mstr. xxseq_mstr.xxseq_domain = global_domain.
        					assign  xxseq_priority = new_priority
        						xxseq_part     = xuseq_part
                  	xxseq_site     = site
                  	xxseq_line     = xuseq_line
                  	xxseq_due_date = xuseq_due_date
                  	xxseq_sod_nbr  = xuseq_sod_nbr
                  	xxseq_sod_line = xuseq_sod_line
        						xxseq_qty_req  = xuseq_qty_req.
        						xuseq_wod_qty  = xuseq_qty_req.
       							xxseq_shift1   = xuseq_shift1.
										xxseq_user1 = "F". 
										xxseq_shift4   = xuseq_ii.
										xxseq_wod_lot = global_addr.
										xuseq_wod_lot = global_addr.
										if xuseq_status <> "" then xxseq_user1 = xuseq_status.
								end.
								else do: 
										message xxseq_due_date "工单没有建立". 
										pause.
								end.
								
								
            	end. /* else do: */
            	
            	xuseq_chgtype = "".
            	
            end.
            

         	end. /* DO TRANSACTION ... */
      		sw_reset = yes.
      	end. /* if update-yn = yes */

      end.
			
			next scroll_loop.
			
   end. /* do with frame d */
   
   hide frame d no-pause.
   
end. /* repeat with frame a */

status input.

procedure ctrlz:
	{gprunp.i "xxprocedwo" "p" "displd" "(input site,
    																		input ii)"}  
end procedure.