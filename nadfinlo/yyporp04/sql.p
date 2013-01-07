for each po_mstr no-lock
where po_ord_date >= 01/01/11
and po_ord_date <= 03/31/11
and po_type <> "B",
each pod_det no-lock
where pod_nbr = po_nbr
and not pod_sched
and pod_so_job <> ""
and length(pod_so_job) = 2
break by pod_so_job by month(po_ord_date):
   disp pod_so_job po_ord_date pod_qty_rcvd pod_pur_cost.
END.
