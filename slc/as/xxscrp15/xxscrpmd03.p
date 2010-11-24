/*By: Neil Gao 08/12/29 ECO: *SS 20081229* */

{mfdeclre.i}
{gplabel.i}

define input parameter iptnbr like so_nbr.
define input parameter iptdate as date.
define input parameter iptlog as logical.
define input parameter iptrt  as char.
define var vend like po_vend.

find first so_mstr where so_domain = global_domain and so_nbr = iptnbr no-error.
if not avail so_mstr then leave.

if iptlog then do:
	tran1:
	DO on error undo,leave:
		so_due_date = iptdate.
		for each sod_det where sod_domain = global_domain and sod_nbr = iptnbr ,
			each pt_mstr where pt_domain = global_domain and pt_part = sod_part 
			break by sod_nbr:
			sod_due_date = iptdate.
		
			find first vp_mstr where vp_domain = global_domain and vp_part = sod_part 
				and vp_vend <> "" and vp_tp_pct = 100 no-lock no-error.
			if avail vp_mstr then do:
				vend = vp_vend.
			end.
			else vend = "-".			
  	
  		&GLOBAL-DEFINE dputline1 "" .
			&GLOBAL-DEFINE dputline2 "" .
			&GLOBAL-DEFINE dputline3 "" .
			&GLOBAL-DEFINE dputline4 "" .
			&GLOBAL-DEFINE dputline5 "" .
			
			{xxcimmd.i &putline1 = "' '"
	           &putline2 = "sod_part ' ' sod_site ' ' sod_line"
	           &putline3 = "sod_qty_ord ' ' max(today,iptdate - pt_insp_lead - pt_pur_lead) ' ' max(today,iptdate - pt_insp_lead)  ' ' vend ' ' sod_nbr ' SO'"
	           &putline4 = "''"
	           &putline5 = "'.'"
	           &execname = "xxpoprmt.p"
				           }
			pause 0.  
			if last-of(sod_nbr) then do: 
  			{xxcimmd.i &putline1 = "sod_nbr ' ' sod_nbr"
	      	     &putline2 = "'socon'"
	        	   &putline3 = "' ' "
	          	 &putline4 = "'.'"
	          	 &putline5 = "'.'"
	           	&execname = "sosoco.p"
				           }
  			pause 0.
  		end.
  	end. /* for each sod_det */
  end.  /* tran1 */
end.
else do:
	/*取消提交*/
	so__log01 = no.
end.
	
