/* REVISION: eb sp3 us  LAST MODIFIED: 01/11/03 BY: *EAS003* Leemy Lee        */

	PUT v_line SKIP.
	PUT '~"' pod_site '~"' SKIP.
	PUT '~"' pod_req_nbr '~"' SKIP.
	PUT '~"' pod_part '~"' SKIP.
	PUT '~"' pod_qty_ord '~" ~"' pod_um '~"' SKIP.
	PUT pod_pur_cost " " pod_disc_pct SKIP.
	PUT '~"' pod_lot_rcpt '~" ~"' pod_loc '~" ~"' pod_rev '~" ~"' pod_status
		 '~" ~"' pod_vpart '~" ~"' pod_due_date '~" ~"' pod_per_date '~" ~"' 
		 pod_need '~" ~"' pod_so_job '~" ~"' pod_fix_pr '~" ~"' pod_acct '~" ~"' 
		 pod_sub '~" ~"' pod_cc '~" ~"' pod_project '~" ~"' pod_type '~" ~"' 
		 pod_taxable '~" ~"' pod_taxc '~" ~"' pod_insp_rqd '~" ~"N~" ~"' pod_um_conv
		  '~" ~"' pod_cst_up '~"' SKIP.
	PUT '~"' pod_tax_usage '~" ~"' pod_tax_env '~" ~"'  pod_taxc '~" ~"' pod_taxable
		 '~" ~"' pod_tax_in '~"' SKIP. 
	PUT "." SKIP.
