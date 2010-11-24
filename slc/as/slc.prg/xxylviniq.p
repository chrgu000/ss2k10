/******************************************************************************/
/*name:装柜清单查询                                                           */
/*designed by Billy 2009-01-14                                                */
/******************************************************************************/

{mfdtitle.i "billy"}

define variable previn as char.

form
	xxsovd_id  column-label "预留VIN码"
with frame b width 200 down attr-space.

form
 previn  COLON 15 label "输入VIN码前缀" skip
WITH FRAME a SIDE-LABELS WIDTH 80 attr-space.

repeat:
	
		update
			previn
		with frame a.

	{mfselprt.i "printer" 132}
	
	for each xxsovd_det where xxsovd_domain = global_domain
	                      and xxsovd_nbr = previn no-lock
	    break by substring(xxsovd_id,12):
	                      	disp
	                      		xxsovd_id
	                        with frame b.
	                        down with frame b.
	end. 

	{mfreset.i}
	{mfgrptrm.i}
end. /*repeat*/
