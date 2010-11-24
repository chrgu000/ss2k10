/*By: Neil Gao 08/11/26 ECO: *SS 20081126* */

{mfdtitle.i "n+ "}

define var site like in_site init "10000".
define var part like pt_part.
define var loc like in_loc.
define var vend like po_vend.
define var transfer like pt_article.
define var oldname like pt_desc1.

form
	part 
	site 
	loc
	transfer  label "配料员" 
	vend
with frame a no-underline width 80.

setframelabels(frame a:handle).

mainloop:
repeat:
	
	update part site loc transfer vend with frame a.
	
	{mfselprt.i "printer" 120}
	
	for each ld_det where ld_domain = global_domain and ld_site = site
		and (ld_part = part or part = "")
		and (ld_loc = loc or loc = "")
		and ld_qty_oh <> 0
		and (substring(ld_lot,7) = vend or vend = "") no-lock,
		each pt_mstr where pt_domain = global_domain 
		               and pt_part = ld_part 
		               and (pt_article = transfer or transfer = "") no-lock
		with frame c width 200:
	
		setframelabels(frame c:handle).
		
		find first vd_mstr where vd_domain = global_domain and vd_addr = substring(ld_lot,7) no-lock no-error.
		{gprun.i ""xxaddoldname.p"" "(input ld_part,output oldname)"}
		disp 	ld_loc 
		      ld_part 
		      pt_desc1 
		      oldname     column-label "老车型"
					substring(ld_lot,7) column-label "供应商"
					vd_sort format "x(16)" when avail vd_mstr
					ld_lot
					ld_ref
					ld_qty_oh
					ld_status
					with frame c.
		down with frame c.
	  oldname = "".
	end.
	put " " skip(1).
	
	{mfreset.i}
	{mfgrptrm.i}
		
		
end.
