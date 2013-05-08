for each pod_det no-lock
    use-index pod_partdue
    where pod_part = {1}
      and pod_site = {2}
        /* and pod_due_date <= {3} */
      and pod_status = "":
    accumulate (pod_qty_ord - pod_qty_rcvd) (total).
    assign conv = 1.
    find first pt_mstr no-lock where pt_part = pod_part no-error.
    if available pt_mstr then do:
      {gprun.i ""gpumcnv.p"" "(input pt_um , input pod_um , input pod_part , output conv)"}
    end.
    {5} = {5} + (pod_qty_ord - pod_qty_rcvd) * conv.
end.
{4} = accum total (pod_qty_ord - pod_qty_rcvd).
