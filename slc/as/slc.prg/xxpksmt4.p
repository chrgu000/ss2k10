/*By: Neil Gao 09/01/16 ECO: *SS 20090116* */
/*By: Neil Gao 09/03/03 ECO: *SS 20090303* */


/* DISPLAY TITLE */
{mfdtitle.i "n1"}

define var site like ld_site.
define var packno as char.
define var packno1 as char.
define var vin as char format "x(18)".
define var desc1 like pt_desc1.
define var desc2 like pt_desc2.
define var part like pt_part.
define var qty like ld_qty_oh.
define var sonbr like so_nbr.
define var soline like sod_Line.
define var location like ld_loc.
define var lotserial like ld_lot.
define var lotref like ld_ref.
define var ldloc like ld_loc init "BZ01".
define var ldloc1 like ld_loc init "CS01".
define var yn as logical.
define var tqty1 like ld_qty_oh.
define var tqty2 like tqty1.
/*SS 20090303 - B*/
define var lcsn as char format "x(11)" no-undo.
define var snresult as logical.
define var i as int.
/*SS 20090303 - E*/

DEFINE new shared temp-table tmp_mstr
	field tmp_packno as char
	field tmp_vin as char format "x(18)"
	field tmp_nbr like sod_nbr
	field tmp_line like sod_line
	field tmp_part like pt_part
	field tmp_desc as char format "x(40)"
	field tmp_site like ld_site
	field tmp_loc	like ld_Loc
	field tmp_lot	like ld_Lot
	field tmp_ref like ld_ref
	field tmp_qty	like ld_qty_oh.

form
	site colon 12
	packno colon 12 label "包装箱号"
	ldloc colon 12 label "库位"
	ldloc1 colon 12 label "到"
	lcsn 	colon 12 label "单据号"
with frame a side-labels width 80 attr-space.

setFrameLabels(frame a:handle).

site = "12000".

mainloop:
repeat:
	
	update site packno with frame a editing:
		if frame-field = "packno" then do:
			{mfnp05.i xxabs_mstr xxabs_id
       		" xxabs_domain = global_domain and xxabs_shipfrom = input site and xxabs_par_id = '' and xxabs_type = 'P'"
          	xxabs_id  "input packno"}
      if recno <> ? then do:
      	disp xxabs_id @ packno with frame a.
      end.
		end.
		else do:
			status input.
			readkey.
			apply lastkey.
		end.
	end.
	
	find first si_mstr where si_domain= global_domain and si_site = site no-lock no-error.
	if not avail si_mstr then do:
		message "地点不存在".
		undo,retry.
	end.
	
	find first xxabs_mstr where xxabs_domain = global_domain and xxabs_shipfrom = site and xxabs_id = packno no-error.
	if not avail xxabs_mstr then do:
		message "包装箱号不存在".
		undo,retry.
	end.
	
	loop:
	repeat transaction on error undo,retry:

 		update ldloc ldloc1 with frame a.

/*SS 20090216 - B*/
/*		
 		run crttmp (input packno).
*/
		/* 检查库存 */
		tqty1 = 0.
		tqty2 = 0.
		for each xxabs_mstr where xxabs_domain = global_domain and xxabs_shipfrom = site 
			and xxabs_par_id = packno and xxabs_loc = ldloc no-lock
			break by xxabs_nbr by xxabs_part:
			tqty1 = tqty1 + xxabs_qty.
			if last-of(xxabs_part) then do:
				for each ld_det where ld_domain = global_domain and ld_site = site and ld_part = xxabs_part 
					and ld_loc = xxabs_loc and ld_ref = xxabs_nbr no-lock :
					tqty2 = tqty2 + ld_qty_oh.
				end.
				if tqty1 > tqty2 then do:
					message "错误:" xxabs_part "库存量" tqty2 "小于发运量" tqty1.
					next mainloop.
				end.
				tqty1 = 0.
				tqty2 = 0.	
			end.
		end.

/*SS 20090303 - B*/
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
/*SS 20090303 - E*/	
		
		/*创建临时表*/
		empty temp-table tmp_mstr.
		for each xxabs_mstr where xxabs_domain = global_domain and xxabs_shipfrom = site 
			and xxabs_par_id = packno and xxabs_loc = ldloc no-lock
			break by xxabs_nbr by xxabs_part:
			tqty1 = tqty1 + xxabs_qty.
			if last-of(xxabs_part) then do:
				for each ld_det where ld_domain = global_domain and ld_site = site and ld_part = xxabs_part 
					and ld_loc = xxabs_loc and ld_ref = xxabs_nbr no-lock :
					tqty2 = min(tqty1,ld_qty_oh).
					tqty1 = tqty1 - tqty2.
					create tmp_mstr.
					assign tmp_packno = xxabs_par_id
						 tmp_site = xxabs_shipfrom
						 tmp_vin = xxabs_id
						 tmp_nbr = xxabs_nbr
						 tmp_line = xxabs_line
				 		 tmp_part = xxabs_part
						 tmp_loc	= ld_loc
						 tmp_lot	= ld_lot
						 tmp_ref  = ld_ref
						 tmp_qty	= tqty2.
					if tqty1 <= 0 then leave.
				end.
				if tqty1 > 0 then do:
					message "错误:" xxabs_part "分配出错".
					next mainloop.
				end.
			end. /* if last-of(xxabs_part) */
		end. /* for each */
/*SS 20090216 - E*/ 
		loop2:
		do on error undo,retry:
 			for each tmp_mstr no-lock:
 				{gprun.i ""xxmdiclotr.p"" 
   							"(input tmp_part,
   								input tmp_qty,
   								input today,
   								input '',
   								input '',
   								input tmp_nbr,
   								input tmp_site,
   								input ldloc,
   								input tmp_lot,
   								input tmp_ref,
   								input tmp_site,
   								input ldloc1,
   								output yn)"
   							}
   			if yn then do:
   				message tmp_part "转仓失败" view-as alert-box.
   				undo, next loop.
   			end.
   			else do:
   				find first xxabs_mstr where xxabs_domain = global_domain and xxabs_shipfrom = tmp_site and xxabs_type = "I"
 						and xxabs_par_id = packno and xxabs_nbr = tmp_nbr and xxabs_line = tmp_line
 						and xxabs_part = tmp_part
 						and xxabs_loc = ldloc no-error.
 					if avail xxabs_mstr then do:
 						xxabs_loc = ldloc1.
 					end.
/*SS 20090303 - B*/
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
/*SS 20090303 - E*/ 					
 				end.
 			end. /* for each */
 		end. /* do on error */	
 		message "执行成功".
   	leave.
 	end.

end.


procedure crttmp:
	define input parameter iptno as char.
	
	for each xxabs_mstr where xxabs_domain = global_domain and xxabs_shipfrom = site 
		and xxabs_par_id = iptno  no-lock:
		if xxabs_type = "I" then do:
			create tmp_mstr.
			assign tmp_packno = xxabs_par_id
						 tmp_site = xxabs_shipfrom
						 tmp_vin = xxabs_id
						 tmp_nbr = xxabs_nbr
						 tmp_line = xxabs_line
				 		 tmp_part = xxabs_part
						 tmp_loc	= xxabs_loc
						 tmp_lot	= xxabs_lot
						 tmp_ref  = xxabs_ref
						 tmp_qty	= xxabs_qty.
			find first pt_mstr where pt_domain = global_domain and pt_part = xxabs_part no-lock no-error.
			if avail pt_mstr then tmp_desc = pt_desc1.
		end.
		else do:
			run crttmp ( input xxabs_id ).
		end.
	end.
end.

