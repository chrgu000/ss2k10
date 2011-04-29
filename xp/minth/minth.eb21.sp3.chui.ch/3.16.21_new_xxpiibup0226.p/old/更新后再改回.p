for each tag_mstr where tag_domain = "151" and tag_nbr >= 90800001 ,
each ld_det where ld_domain = "151" and ld_part = tag_part and ld_site = tag_site
and ld_loc = tag_loc and ld_lot = tag_serial and ld_ref = tag_ref :
display tag_nbr ld_loc ld_site ld_part ld_qty_oh tag__qad01 tag_cnt_dt tag_void .
/* tag_posted = no.
 tag_cnt_dt = ?.
               ld_qty_frz  = tag__qad01. */
	       end.