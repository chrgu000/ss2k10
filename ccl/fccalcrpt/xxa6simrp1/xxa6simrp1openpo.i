for each pod_det
    no-lock
    use-index pod_partdue
    where pod_part = {1}
        and pod_site = {2}
        /* and pod_due_date <= {3} */
        and pod_status = ""
:
    accumulate (pod_qty_ord - pod_qty_rcvd) (total).
end.
{4} = accum total (pod_qty_ord - pod_qty_rcvd) .
