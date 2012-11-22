
for each wo_mstr
    no-lock
    use-index wo_part
    where wo_part = {1}
        and wo_site = {2}
        /* and wo_due_date <= {3} */
        and (wo_status <> "C" and wo_status <> "P")
:
    accumulate (wo_qty_ord - wo_qty_comp - wo_qty_rjct) (total).
end.
{4} = accum total (wo_qty_ord - wo_qty_comp - wo_qty_rjct).