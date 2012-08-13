/* yywobmspt.p 加入：镜像BOM成本元素明细                        */
/* Author: James Duan    *DATE:2009-09-14*                      */


{mfdeclre.i }

DEFINE INPUT PARAMETER iSite	LIKE pt_site.
DEFINE INPUT PARAMETER iPart	LIKE pt_part.
DEFINE INPUT PARAMETER iBomcode AS CHAR.
DEFINE INPUT PARAMETER iDate	AS DATE.

define variable v_costset as character.

define new shared variable comp like ps_comp.
define new shared variable site like ptp_site no-undo.
define new shared variable eff_date as date.

{gpxpld01.i "new shared"}
define new shared workfile pkdet no-undo
    field pkpart like ps_comp
    field pkop as integer format ">>>>>9"
    field pkstart like pk_start
    field pkend like pk_end
    field pkqty like pk_qty
    field pkbombatch like bom_batch
    field pkltoff like ps_lt_off.

if iBomcode = "" then iBomcode = iPart.
comp = iBomcode.
site = iSite.
eff_date = iDate.


find last xxwobmfm_mstr where xxwobmfm_site = iSite
	and xxwobmfm_part = iPart
	use-index xxwobmfm_idx1 no-lock no-error.
if available xxwobmfm_mstr then do:
        /* get cost set */
	find first in_mstr where in_part = iPart and in_site = iSite no-lock no-error.
	v_costset = (if available in_mstr and in_gl_set <> "" then in_gl_set else "STANDARD").

	/* explode part by standard picklist logic */
	{gprun.i ""woworla2.p""}

	for each spt_det no-lock where spt_site = iSite
		and spt_sim = v_costset
		and spt_part = iPart
		by spt_element:
		/* 生成对应版本镜像BOM成本元素明细 */
		find first yywobmspt_mstr where yywobmspt_site = iSite
			and yywobmspt_part = iPart
			and yywobmspt_version = xxwobmfm_version
			and yywobmspt_elem = spt_element no-error.
		if not available yywobmspt_mstr then do:
			create yywobmspt_mstr.
			assign 
			    yywobmspt_site = iSite
			    yywobmspt_part = iPart
			    yywobmspt_version = xxwobmfm_version
			    yywobmspt_elem = spt_element.
				
		end. /* if not available yywobmspt_mstr */
		assign
		    yywobmspt_elem_cost = spt_cst_tl + spt_cst_ll
		    yywobmspt_userid = global_userid
		    yywobmspt_mod_date = today.
	end. /* for each spt_det */

	for each yywobmsptd_det where yywobmsptd_part = iPart
		and yywobmsptd_site    = iSite
		and yywobmsptd_version = xxwobmfm_version:
		delete 	yywobmsptd_det.
	end.

	for each pkdet
		where eff_date = ? or (eff_date <> ?
		and (pkstart = ? or pkstart <= eff_date)
		and (pkend = ? or eff_date <= pkend)
		     )
		break by pkpart by pkop:
		for each spt_det no-lock where spt_site = iSite
			and spt_sim = v_costset
			and spt_part = pkpart
			by spt_element:
			find first yywobmsptd_det where yywobmsptd_part = iPart 
				and yywobmsptd_site    = iSite
				and yywobmsptd_version = xxwobmfm_version
				and yywobmsptd_comp    = pkpart 
				and yywobmsptd_elem    = spt_element NO-ERROR.
			if not available yywobmsptd_det then do:
				create yywobmsptd_det.
				assign
				    yywobmsptd_part = iPart
				    yywobmsptd_site    = iSite
				    yywobmsptd_version = xxwobmfm_version
				    yywobmsptd_comp    = pkpart
				    yywobmsptd_elem    = spt_element. 
			end. /* if not available yywobmsptd_det*/
			assign
			    yywobmsptd_elem_cost = spt_cst_tl + spt_cst_ll
			    yywobmsptd_userid = global_userid
			    yywobmsptd_mod_date = today.
			yywobmsptd_unit_qty = yywobmsptd_unit_qty + pkqty.
		end. /* for each spt_det */
	end. /* for each pk_det */
end. /* if not available xxwobmfm_mstr */
