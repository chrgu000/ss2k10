def buffer tmp for pod_det.

output to c:\item_multivend.d.
for each pod_det where pod_sched no-lock:
    find first tmp where tmp.pod_sched and tmp.pod_part = pod_det.pod_part
    and tmp.pod_nbr <> pod_det.pod_nbr no-lock no-error.
    if available tmp then do:
        find pt_mstr where pt_part = pod_det.pod_part no-lock no-error.
        disp pod_det.pod_nbr pod_det.pod_line 
             pod_det.pod_part pt_desc2 with stream-io.
    end.
end.
