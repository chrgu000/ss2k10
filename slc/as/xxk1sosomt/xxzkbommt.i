/*SS 20080926 - B*/
/*
{1} = table
{2} = ps_par
{3} = ps_comp
{4} = effdate
{5} = ps_qty
*/

for each ps_mstr where ps_domain = global_domain and ps_par = {2} and ps_ps_code = ""
	and ( ps_start <= {4} or ps_start = ?)
	and ( ps_end >= {4} or ps_end = ?)  no-lock:
	find first pt_mstr where pt_domain = global_domain and pt_part = ps_comp no-lock no-error.
	if avail pt_mstr and pt_pm_code <> "M" then do:
		find first {1} where {3} = ps_comp no-error.
		if not avail {1} then do:
			create {1}.
			assign {3} = ps_comp
						 {5} = ps_qty_per.
		end.
		else do:
			{5} = {5} + ps_qty_per.
		end.
	end.
	else do:
		run pcxbom (input ps_comp, input ps_qty_per).
	end.
end.

procedure pcxbom:
	define input parameter iptpart like pt_part.
	define input parameter iptqty  like ps_qty_per.

	for each ps_mstr where ps_domain = global_domain and ps_par = iptpart and ps_ps_code = ""
		and ( ps_start <= {4} or ps_start = ?)
		and ( ps_end >= {4} or ps_end = ?)  no-lock:
		find first pt_mstr where pt_domain = global_domain and pt_part = ps_comp no-lock no-error.
		if avail pt_mstr and pt_pm_code <> "M" then do:
			find first {1} where {3} = ps_comp no-error.
			if not avail {1} then do:
				create {1}.
				assign {3} = ps_comp
							 {5} = ps_qty_per * iptqty.
			end.
			else do:
				{5} = {5} + ps_qty_per * iptqty.
			end.
		end.
		else do:
			run pcxbom (input ps_comp, input ps_qty_per * iptqty).
		end.
	end.
	
end procedure .