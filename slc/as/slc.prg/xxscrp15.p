/* SS - 090622.1 By: Neil Gao */

{mfdtitle.i "090622.1"}

define new shared variable release_all like mfc_logical.
define variable nbr like req_nbr.
define variable part like mrp_part.
define variable part2 like mrp_part.
define variable rel_date like mrp_rel_date.
define variable rel_date2 like mrp_rel_date.
define variable sonbr like so_nbr.
define variable sonbr1 like so_nbr.
define variable dwn as integer.
define variable yn like mfc_logical.
define variable site like si_site.
define variable site2 like si_site.
define variable v_dwn as integer.
define var tt_recid as recid no-undo.
define var first-recid as recid no-undo.
define var cfnbr as char init "120".
define var mktype as char init "check1".

{xxscrp15.i "new"}
/*SS 20080324 - E*/

define temp-table tt1
	field tt1_f1 like so_nbr
	field tt1_f2 like so_cust
	field tt1_f3 as char
	field tt1_f4 as date
	field tt1_f5 as date
	field tt1_f6 as logical
	field tt1_f7 as char format "x(4)"
	field tt1_f8 as char format "x(30)"
	field tt1_f9 as char format "x(18)"
	.

form
	tt1_f1 column-label "订单"
	tt1_f2 column-label "客户"
	tt1_f3 column-label "订单类型"
	tt1_f9 column-label "配送比例"
	tt1_f4 column-label "订单日期"
	tt1_f5 column-label "发货日期"
	tt1_f6 column-label "确认"
	tt1_f7 column-label "返回"
with frame tt1 down width 80 no-attr-space.
	
/* INPUT OPTION FORM */
form   
   sonbr			colon 15
   sonbr1   label {t001.i}              colon 45
   part				 colon 15
   part2 label {t001.i}		colon 45
   rel_date			colon 15
   rel_date2 label {t001.i}	colon 45 skip(1)
   release_all			colon 36
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

assign
   release_all = yes
   site = global_site
   site2 = global_site.

main-loop:
repeat:
   assign
      dwn = 0
      .

    ststatus = stline[1].
    status input ststatus.

   if part2 = hi_char then part2 = "".
   if sonbr1 = hi_char then  sonbr1  = "".
   if rel_date = low_date then rel_date = ?.
   if rel_date2 = hi_date  then rel_date2 = ?.


   update
      sonbr
      sonbr1
      part part2
      rel_date rel_date2
      release_all
   with frame a
   editing:
         ststatus = stline[3].
         status input ststatus.
         readkey.
         apply lastkey.
   end. /* EDITING */

   status input "".

   if part2 = "" then part2 = hi_char.
   if sonbr1 = "" then sonbr1 = hi_char.
   if rel_date = ? then  rel_date = low_date.
   if rel_date2 = ? then rel_date2 = hi_date.


   	empty temp-table tt1.
		empty temp-table tt2.
		
   	for each xxcff_mstr where xxcff_key1 = mktype and xxcff_key_nbr >= sonbr and xxcff_key_nbr <= sonbr1 
		     	and xxcff_nbr = cfnbr no-lock,
	 			each xxcffw_mstr where xxcffw_key1 = mktype and xxcffw_key_nbr = xxcff_key_nbr
	 				and xxcffw_key_line = xxcff_key_line 
		     	and xxcffw_check = no and xxcffw_nbr = cfnbr no-lock,	
   		each so_mstr where so_domain = global_domain and so_nbr = xxcff_key_nbr
		  and so_ord_date >= rel_date and so_ord_date <= rel_date2 no-lock,
   		each sod_det where sod_domain = global_domain 
   			and sod_nbr = so_nbr and sod_line = xxcff_key_line
        and sod_part >= part and sod_part <= part2 no-lock
		  break by xxcff_key_nbr:

	  		assign 	dwn = dwn + 1
                .
        find first pt_mstr where pt_domain = global_domain and pt_part = sod_part no-lock no-error.

				if first-of(xxcff_key_nbr) then do:
					find first ad_mstr where ad_domain = global_domain and ad_addr = so_cust no-lock no-error.
					create  tt1.
								  tt1_f1 = so_nbr.
									tt1_f2 = so_cust.
									tt1_f3 = so_channel.
									tt1_f4 = so_ord_date.
									tt1_f5 = so_req_date.
									tt1_f6 = release_all.
									tt1_f8 = so_rmks.
					
					if tt1_f3 <> "" then do:
	 					find first code_mstr where code_domain = global_domain and code_fldname = "xxchannel" 
	 						and code_value = tt1_f3 no-lock no-error.
	 					if avail code_mstr then do:
	 						tt1_f3 = code_cmmt.
	 					end.
	 				end.
					
					v_dwn = 0.
				end.
				
				v_dwn = v_dwn + 1.
	      create 	tt2.
	      assign 	tt2_f1 = 	v_dwn
               	tt2_f2 = 	sod_nbr
               	tt2_f3 = 	sod_line
		  				 	tt2_f4 =  sod_part
               	tt2_f5 =	( if avail pt_mstr then pt_desc1 else "")
		  					tt2_f6 = sod_req_date
		  					tt2_f7 = sod_qty_ord
                .
   end.

   if dwn <> 0
   then do:
      hide frame a.

      scroll_loop:
      repeat:
      	
      	{xuview.i	&buffer = tt1
         					&scroll-field = tt1_f1
         					&framename = "tt1"
         					&framesize = 8
         					&display1     = tt1_f1
         					&display2     = tt1_f2
         					&display3     = tt1_f3
         					&display4     = tt1_f4
         					&display5     = tt1_f5
         					&display6     = tt1_f6
         					&display7     = tt1_f7
         					&searchkey    = " 1 = 1"
         					&logical1     = false
         					&first-recid  = first-recid
         					&exitlabel = scroll_loop
         					&exit-flag = true
         					&record-id = tt_recid
         					&cursorup  = " if avail tt1 then message tt1_f8. "
         					&cursordown = "if avail tt1 then message tt1_f8. "
       	}
       	
       	if keyfunction(lastkey) = "return" and avail tt1 then 
       	do on error undo,leave:
       		hide frame tt1 no-pause.
       		{gprun.i ""xxscrp15a.p"" "(input tt1_f1)"}
       		update tt1_f5 tt1_f6 with frame tt1.
       		if tt1_f5 = ? then do:
       			message "日期不能为空".
       			undo,retry.
       		end.
       		if not tt1_f6 then do:
       			update tt1_f7 with frame tt1.
       		end.
       		else do:
       			tt1_f7 = "".
       			tt1_f8 = "".
       		end.
      	end.
      	else if keyfunction(lastkey) = "go" then do:
      		yn = no.
          /* IS ALL INFO CORRECT? */
          {pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=yn}
          if yn = ? then leave scroll_loop.
          if yn then do on error undo, retry:	
          	
          	
          	
          	for each tt1 no-lock where tt1_f6 or tt1_f7 <> "" :
							{gprun.i ""xxscrpmd04.p"" "(input 'check1',input cfnbr,input tt1_f1,input tt1_f6,input tt1_f7)"}
							if tt1_f6 then 
								{gprun.i ""xxscrpmd03.p"" "(input tt1_f1,input tt1_f5,input tt1_f6,input tt1_f7)"}
							pause 0.
						end.
						
					end.
					leave scroll_loop.
      	end.
      end. /* scroll_loop */
      hide frame tt1 no-pause.
      
   end. /* IF dwn <> 0 */
   else do:
       message("没有需要审批的销售订单").
   end. /* ELSE DO */

end. /* MAINLOOP */
