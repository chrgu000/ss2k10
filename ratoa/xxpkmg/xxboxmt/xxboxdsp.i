/* xxboxmt.p - box MAINT parameter file                                       */
/*V8:ConvertMode=Maintenance                                                  */
/*-Revision end---------------------------------------------------------------*/

display xxbox_sonbr
        xxbox_soline
        xxbox_qty_max
        xxbox_par
        xxbox_comptype
        xxbox_comp
        xxbox_site
	      xxbox_loc
        xxbox_comp.
 find first xxsovd_det no-lock where xxsovd_domain = global_domain
				 and xxsovd_id = input xxbox_comp no-error.
if available xxsovd_det then do:
		display xxsovd_part
            xxsovd_wonbr
            xxsovd_wolot
            xxsovd_id1.
end.
