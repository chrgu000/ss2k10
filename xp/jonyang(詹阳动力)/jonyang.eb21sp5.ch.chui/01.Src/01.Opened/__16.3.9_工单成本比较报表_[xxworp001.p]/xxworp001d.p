{mfdeclre.i}
{gplabel.i}


{xxworp001var.i}


{xxworp001x1.i}

for each pt_mstr 
        use-index pt_prod_part
        where pt_domain = global_domain 
        and pt_prod_line >= line and pt_prod_line <= line1
        and pt_part      >= part and pt_part      <= part1 
    no-lock,
    each wo_mstr 
        use-index wo_part_rel
        where wo_domain = global_domain
        and   wo_part   = pt_part
        and   wo_rel_date >= rdate and wo_rel_date <= rdate1
        and   wo_nbr   >= wonbr    and wo_nbr  <= wonbr1
        and   wo_lot   >= lot      and wo_lot  <= lot1
        and  ( v_all = 1
               or ( v_all = 2 and (wo_close_eff >= cdate and wo_close_eff <= cdate1))
               or ( v_all = 3 and wo_close_eff = ? )
             )
        and index("RC",wo_status) > 0 
    no-lock
    with frame x width 300:

    {xxworp001x2.i}

end. /*for each pt_mstr*/
