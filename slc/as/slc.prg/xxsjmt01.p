/*By: Neil Gao 09/01/12 ECO: *SS 20090112* */

{mfdtitle.i "n2"}

define var site like pt_site.
define var sonbr like so_nbr.
define var ldloc like ld_loc  init "SJ01".
define var ldloc1 like ld_loc init "BZ01".
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
	
	update sonbr ldloc ldloc1 with frame a.
	
	if ldloc = "" or ldloc1 = "" then do:
		message "库位不能为空".
		next.
	end.
	
	update lcsn with frame a editing:
		{mfnp.i usrw_wkfl lcsn
							"usrw_domain = global_domain and usrw_key1 = 'lcsnsj'  and usrw_key2"
              lcsn usrw_key2 usrw_index1 }
      if recno <> ? then
         display
						usrw_key2 @ lcsn
         with frame a.
   	end.
		{gprun.i ""xxlcsnct.p"" "(input-output lcsn,
                         input 'LCSNSJ',
                         input today,
                         output snresult)"
		}
		if not snresult or lcsn = "" then undo ,retry.
		disp lcsn with frame a.
	
	empty temp-table xxtt1.
	for each so_mstr where so_domain = global_domain and so_nbr = sonbr no-lock,
		each sod_det where sod_domain =  global_domain and sod_nbr = so_nbr
			and sod_site = site 
			and sod_qty_ord > sod_qty_ship no-lock,
		each pt_mstr where pt_domain = global_domain and pt_part = sod_part no-lock:
		
/*SS 20090116 - B*/
/*
		each lad_det where lad_domain = global_domain and lad_nbr = so_nbr 
			and lad_line = string(sod_line) and lad_loc = ldloc no-lock:
*/
/*SS 20090116 - E*/
		xxqty1 = sod_qty_ord - deci(sod__chr06).
		if xxqty1 > 0 then do:
			for each ld_det where ld_domain = global_domain and ld_part = sod_part 
				and ld_site = sod_site and ld_loc = ldloc
				and ld_ref = sod_nbr
				and ld_qty_oh > ld_qty_all no-lock :
				
				xxqty2 = min(xxqty1,ld_qty_oh - ld_qty_all).
				create 	xxtt1.
				assign	xxtt1_f1 = sod_line
								xxtt1_f2 = sod_part
								xxtt1_f3 = pt_desc1
								xxtt1_f4 = xxqty2
								xxtt1_f5 = ld_lot
								xxtt1_f6 = ld_ref
								.
				xxqty1 = xxqty1 - xxqty2.
				if xxqty1 <= 0 then leave.
			end.
		end.
	end.
	
	loop1:
  repeat:
  			scroll_loop:
  			do:
  	      	{xuview.i	&buffer = xxtt1
         					&scroll-field = xxtt1_f1
         					&framename = "xxtt1"
         					&framesize = 8
         					&display1     = xxtt1_f1
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
   								find first sod_det where sod_domain = global_domain and sod_nbr = sonbr 
   									and sod_line = xxtt1_f1 no-error.
   								if avail sod_det then sod__chr06 = string(deci(sod__chr06) + xxtt1_f4).
   								if global_addr <> "" then do:
   									do i = 1 to num-entries(global_addr):
   										find first tr_hist where tr_domain = global_domain and tr_trnbr = int(entry(i,global_addr)) no-error.
   										if avail tr_hist then do:
   											tr__chr01 = lcsn.
   											tr_vend_lot = lcsn.
   											{gprun.i ""xxlcsnmt.p"" "(input lcsn,
                        	 input 'LCSNSJ',
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
	
	
   	