define {1} shared temp-table xxreq_det
	field xxreq_sel as char format "x(1)"
	field xxreq_vend like po_vend
	field xxreq_nbr like pod_nbr
	field xxreq_reldate like req_rel_date
	field xxreq_part like req_part
	field xxreq_qty like req_qty
	field xxreq_sonbr like so_nbr
	field xxreq_wolot like wo_lot
	field xxreq_type  as char format "x(2)"
	field xxreq_expert as char
	index xxreq_part
	xxreq_part
	xxreq_reldate
	index xxreq_vend
	xxreq_type
	xxreq_vend
	xxreq_nbr
	.