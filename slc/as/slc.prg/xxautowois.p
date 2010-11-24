/* Creation: eB21SP3 Chui Last Modified: 20080107 By: Davild Xu *ss-20071228.1*/
/*{mfdeclre.i}*/

/*批量自动退货iss-wo
*/
{mfdtitle.i "n1"}

define new shared variable i as integer .
{xxautowois.i "new"}

form
     wolot  colon 14  
     loc colon 14 label "入库库位"
with frame a width 80 side-label.

{wbrp01.i}
REPEAT :
hide all no-pause .
view frame dtitle .

 FOR EACH  tmp_mstr 
 	 :
 delete tmp_mstr .
 END.
 v_loc = "" .
		/*loc = "NC1" .*/	/*---Remark by davild 20080120.1*/
		FOR EACH  tmp_mstr :
			delete tmp_mstr .
		     END.
		UPDATE
			wolot loc
		WITH FRAME a.
		find first wo_mstr where wo_domain = global_domain and wo_lot = wolot no-lock no-error.
		if not avail wo_mstr then do:
			message "此ID不存在" view-as alert-box .
			next .
		end.
		else do:
			for each tr_hist where tr_domain = global_domain and tr_type = "iss-wo"
				and tr_lot = wolot 
				and (tr_loc = loc or loc = "")
				no-lock :
				find first tmp_mstr where tmp_part = tr_part and tmp_op = tr_wod_op
						and tmp_site = tr_site and tmp_loc = tr_loc
						and tmp_lot = tr_serial and tmp_ref = tr_ref
						no-lock no-error.
				if not avail tmp_mstr then do:
					create tmp_mstr.
					assign
						tmp_part = tr_part
						tmp_op	= tr_wod_op
						tmp_site = tr_site
						tmp_loc  = tr_loc
						tmp_lot  = tr_serial
						tmp_wonbr = tr_nbr
						tmp_wolot = tr_lot
						tmp_ref  = tr_ref
						tmp_qty_iss = 0 - tr_qty_loc /*原已发数*/
						tmp_ok_iss = tmp_qty_iss     /*退货数量*/
						tmp_ii = "*"
						.		
				end.
				else assign tmp_qty_iss = tmp_qty_iss + ( 0 - tr_qty_loc ) 
					tmp_ok_iss = tmp_qty_iss .
			end.
		end.	/*else do:*/
  	{gprun.i ""xxautowoisb.p""}
end.
 
