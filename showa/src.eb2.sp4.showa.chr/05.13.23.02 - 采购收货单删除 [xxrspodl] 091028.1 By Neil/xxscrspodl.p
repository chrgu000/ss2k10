/* SS - 091028.1 By: Neil Gao */

{mfdeclre.i}
{gplabel.i}

define input parameter iptf1 like po_vend.
define input parameter iptf2 like abs_id.
define output parameter optf1 as int.

find abs_mstr where abs_shipfrom = iptf1 and abs_id = "S" + iptf2 exclusive-lock.
if avail abs_mstr and abs_type = "r" and substring(abs_status,2,1) = "" then do:
	
	{gprun.i ""xxscrspodla.p"" "(input recid(abs_mstr))"}
	
	/* pass */
	optf1 = 0.
	
end.
/* fail */
else optf1 = 1.
