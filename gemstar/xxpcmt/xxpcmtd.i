/*delete none golbal_domain pc data*/

for each dom_mstr no-lock where dom_domain <> global_domain and dom_active:
    for each pc exclusive-lock where pc.pc_domain = dom_domain
        and pc.pc_list = pc_mstr.pc_list
        and pc.pc_curr = pc_mstr.pc_curr
        and pc.pc_prod_line = pc_mstr.pc_prod_line
        and pc.pc_part = pc_mstr.pc_part
        and pc.pc_um = pc_mstr.pc_um
        and pc.pc_start = pc_mstr.pc_start:
        delete pc.
    end.
end.
