for each xsub_det use-index {2} 
    where xsub_domain = global_domain 
    and {3} {4} {5} {6} {7} {8} {9}
no-lock 
with frame {1} with width 200 :

    disp 
        xsub_wonbr      column-label "工单编号"
        xsub_wolot      column-label "工单ID"
        xsub_part       column-label "原物料号"
        xsub_subpart    column-label "替代料"
        xsub_qty        column-label "(原/替)比例" 
    with frame {1} .

end.
