/*增加参数{5}用于记录转换后的OPEN_PO数量                                   *5a*/
/*5a*/ assign {5} = 0.
for each pod_det no-lock
    use-index pod_partdue
    where pod_part = {1}
      and pod_site = {2}
        /* and pod_due_date <= {3} */
      and pod_status = "":
    accumulate (pod_qty_ord - pod_qty_rcvd)(total).
/*5a*/ assign conv = 1.
/*5a*/ find first pt_mstr no-lock where pt_part = pod_part no-error.
/*5a*/ if available pt_mstr then do:
/*5a*/   {gprun.i ""gpumcnv.p"" "(input pod_um , input pt_um , input pod_part ,
                                  output conv)"}
/*5a*/ end.
/*5a*/ if conv = ? or conv = 0 then conv = 1.
/*5a*/ {5} = {5} + (pod_qty_ord - pod_qty_rcvd) * conv.
end.
{4} = accum total (pod_qty_ord - pod_qty_rcvd).
