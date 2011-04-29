{xxporp002x1.i}

for each prh_hist no-lock
    where prh_domain = global_domain
    and (prh_nbr >= i-nbr and prh_nbr <= i-nbr1 )

    and ((prh_vend >= vendor and prh_vend <= vendor1)
    and (prh_part >= part and prh_part <= part1)
    and ((prh_rcp_date >= rcpt_from) or  (prh_rcp_date = ? and rcpt_from = low_date))
    and ((prh_rcp_date <= i-rcpt_to) or  prh_rcp_date = ? )
    and (prh_buyer >= i-buyer and prh_buyer <= i-buyer1 )
    and (prh_site >= site and prh_site <= site1)
    and ((prh_type = "" and sel_inv = yes)
        or  (prh_type = "S" and sel_sub = yes)
        or  (prh_type <> "" and prh_type <> "S" and sel_mem = yes))
    and (base_rpt = "" or base_rpt = prh_curr))
use-index prh_nbr 
by prh_vend by prh_nbr
with frame b down width 132 no-box:

{xxporp002x2.i}
