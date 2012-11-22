/***********************
for each mrp_det
    no-lock
    use-index mrp_site_due
    where mrp_part = {1}
        and mrp_site = {2}
        and mrp_due_date >= {3}
        and mrp_due_date <= {4}
        and (
            mrp_dataset = "sod_det"
            or mrp_dataset = "wod_det"
            or mrp_dataset = "fcs_sum"
            or mrp_dataset = "pfc_det"
            or mrp_dataset = "wo_scrap"
            or mrp_dataset = "fc_det"
            or mrp_type = "demand"
        )
:
    accumulate mrp_qty (total).
end.
{5} = accum total mrp_qty.
**************************************/

for each mrp_det
    no-lock
    use-index mrp_site_due
    where mrp_part = {1}
        and mrp_site = {2}
        and mrp_type = "demand"
:
    accumulate mrp_qty (total).
end.
{5} = accum total mrp_qty.