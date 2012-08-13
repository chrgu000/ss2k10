output to c:\trainmrp.d.
for each mrp_det no-lock
where mrp_dataset = "wod_det"
and mrp_type = "demand" 
break by mrp_part by mrp_due_date:

    find first pod_det where pod_part = mrp_part and pod_sched no-lock no-error.
    if not available pod_det then next.

    find wo_mstr where wo_nbr = mrp_nbr and wo_lot = mrp_line
    no-lock no-error.
    if available wo_mstr then
        find pt_mstr where pt_part = wo_part no-lock no-error.

    disp wo_part when available wo_mstr pt_desc2 when available pt_mstr 
         mrp_part mrp_due_date mrp_qty with width 132 stream-io.
end.         
