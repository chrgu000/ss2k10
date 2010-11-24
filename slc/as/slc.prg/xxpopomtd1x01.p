/*By: Neil Gao 08/11/20 ECO: *SS 20081120* */

{mfdeclre.i}

define input parameter iptrecid as recid.
define shared variable worklot  like wo_lot.
define var wonbr like wo_nbr.

find first pod_det where recid(pod_det) = iptrecid no-lock no-error.
if not avail pod_det then return.

&GLOBAL-DEFINE dputline1 "" .
&GLOBAL-DEFINE dputline2 "" .
&GLOBAL-DEFINE dputline3 "" .
&GLOBAL-DEFINE dputline4 "" .
&GLOBAL-DEFINE dputline5 "" .
&GLOBAL-DEFINE dputline6 "" .

global_addr = "".
wonbr = "WS" + substring(pod_nbr,3) + string(pod_line,"999").
{xxcimmd.i &putline1 = " wonbr ' '"
           &putline2 = " pod_part ' - ' pod_site"
           &putline3 = " pod_qty_ord ' - ' pod_due_date ' ' pod_due_date  ' r ' pod_nbr "
	         &putline4 = "'.'"
	         &putline5 = "'-'"
	         &putline6 = "'.'"
	         &execname = "xxcimwomt.p"
								           }

find first wo_mstr where wo_domain = global_domain and wo_lot = global_addr no-error.
if avail wo_mstr then do:
	wo__dec02 = pod_line.
	worklot = wo_lot.
end.

		           