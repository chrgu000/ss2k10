/*By: Neil Gao 09/01/12 ECO: *SS 20090112* */

{mfdtitle.i "n2"}

define var site like pt_site init "12000".
define var sonbr like so_nbr.
define var ldloc like ld_loc  init "BZ01".
define var ldloc1 like ld_loc init "CS01".
define var tt_recid as recid no-undo.
define var first-recid as recid no-undo.
define var yn as logical.
define var xxqty1 as deci.
define var xxqty2 as deci.
define var lcsn as char format "x(11)" no-undo.
define var snresult as logical.
define var i as int.

define temp-table xxtt1
	field xxtt1_f1 like sod_line
	field xxtt1_f2 like sod_part
	field xxtt1_f3 like pt_desc1
	field xxtt1_f4 like ld_qty_oh
	field xxtt1_f5 like ld_lot
	field xxtt1_f6 like ld_ref
	.

form
	site	colon 15
	sonbr colon 15
	ldloc colon 15
	ldloc1 colon 15
	lcsn 	colon 15 label "单据号"
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
	xxtt1_f1 column-label "项"
	xxtt1_f2 column-label "物料号"
	xxtt1_f3 column-label "名称" format "x(18)"
	xxtt1_f4 column-label "转仓数量"
	xxtt1_f5 column-label "批次"
with frame xxtt1 down width 80 no-attr-space.

site = "12000".

Mainloop:
repeat:
	
	update site sonbr ldloc ldloc1 with frame a.
	
	if sonbr = "" then do:
		message "错误: 订单不能为空".
		next.
	end.
	
	if ldloc = "" or ldloc1 = "" then do:
		message "错误: 库位不能为空".
		next.
	end.
	
		update lcsn with frame a editing:
			{mfnp.i usrw_wkfl lcsn
							"usrw_domain = global_domain and usrw_key1 = 'lcsnsc'  and usrw_key2"
              lcsn usrw_key2 usrw_index1 }
      if recno <> ? then
         display
						usrw_key2 @ lcsn
         with frame a.
   	end.
		{gprun.i ""xxlcsnct.p"" "(input-output lcsn,
                         input 'LCSNSC',
                         input today,
                         output snresult)"
		}
		if not snresult or lcsn = "" then undo ,retry.
		disp lcsn with frame a.
	
		empty temp-table xxtt1.

			for each ld_det where ld_domain = global_domain
				and ld_site = site and ld_loc = ldloc
				and ld_ref = sonbr
				and ld_qty_oh > 0 no-lock ,
				each pt_mstr where pt_domain = global_domain and pt_part = ld_part no-lock:
				
				create 	xxtt1.
				assign	xxtt1_f2 = ld_part
								xxtt1_f3 = pt_desc1
								xxtt1_f4 = ld_qty_oh
								xxtt1_f5 = ld_lot
								xxtt1_f6 = ld_ref
								.
			end.
	
	find first xxtt1 no-error.
	if not avail xxtt1 then leave.
	first-recid = ?.
	tt_recid = ?.
	
	loop1:
  repeat:
  			scroll_loop:
  			do:
  	      	{xuview.i	&buffer = xxtt1
         					&scroll-field = xxtt1_f1
         					&framename = "xxtt1"
         					&framesize = 8
         					&display2     = xxtt1_f2
         					&display3     = xxtt1_f3
         					&display4     = xxtt1_f4
         					&display5     = xxtt1_f5
         					&searchkey    = " 1 = 1"
         					&logical1     = false
         					&first-recid  = first-recid
         					&exitlabel = scroll_loop
         					&exit-flag = true
         					&record-id = tt_recid
         					&cursorup  = " if avail xxtt1 then . "
         					&cursordown = "if avail xxtt1 then . "
       			}
       	end.
       	
       	if not avail xxtt1 then leave.
       	
     		if keyfunction(lastkey) = "end-error" then do:
	      	yn = no.
  	      {pxmsg.i &MSGNUM=36 &ERRORLEVEL=1 &CONFIRM=yn}
    	    if yn = yes then leave.
      	end.
     		
     		if keyfunction(lastkey) = "go" then do:
      		yn = no.
          /* IS ALL INFO CORRECT? */
          {pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=yn}
          if yn = ? then leave loop1.
          if yn then do:	
          	for each xxtt1 where xxtt1_f4 <> 0 no-lock:
          		{gprun.i ""xxmdiclotr.p"" 
   							"(input xxtt1_f2,
   								input xxtt1_f4,
   								input today,
   								input '',
   								input '',
   								input sonbr,
   								input site,
   								input ldloc,
   								input xxtt1_f5,
   								input xxtt1_f6,
   								input site,
   								input ldloc1,
   								output yn)"
   							}
   							if yn then message xxtt1_f2 xxtt1_f5 "转仓失败" view-as alert-box.
   							else do:
   								if global_addr <> "" then do:
   									do i = 1 to num-entries(global_addr):
   										find first tr_hist where tr_domain = global_domain and tr_trnbr = int(entry(i,global_addr)) no-error.
   										if avail tr_hist then do:
   											tr__chr01 = lcsn.
   											tr_vend_lot = lcsn.
   											{gprun.i ""xxlcsnmt.p"" "(input lcsn,
                        	 input 'LCSNSC',
                         	input tr_trnbr,
                         	output snresult)"
												}.
   										end.
   									end. /* do */
   								end.
   							end. /* else do */
          	end. /* for each */
          end.
          leave loop1.
       	end. /* if keyfunction(lastkey) = "go" */
       	
	end. /* loop1 */

end. /* mainloop */
	
	
   	