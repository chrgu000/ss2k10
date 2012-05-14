
output to p.cim.
for each xxloc_det no-lock:
    put unformat "@@batchload xxptlocmt.p" skip.
    put unformat '"' xxloc_type '" "' xxloc_loc '" "' xxloc_part '"' skip.
    put unformat xxloc_qty skip.
    put unformat "@@end" skip.
end.
for each xxpl_ref no-lock:
		put unformat "@@batchload xxptlomt.p" skip.
		put unformat '"' xxpl_part '"' skip.
		put unformat '"-" "' xxpl_loc '"' skip.
		put unformat '"' xxpl_type '" "' xxpl_rank '" ' xxpl_panel ' ' 
							   xxpl_cap skip.
		put unformat "@@end" skip.
end.
output close.
