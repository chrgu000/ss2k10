/* 将本域的PC资料复制到其他域 为保持一致性先删除在复制 */

for each dom_mstr no-lock where dom_domain <> global_domain and dom_active:
/* 140123.1  - Start */
      for each pc exclusive-lock where pc.pc_domain = dom_domain
           and pc.pc_list = pc_mstr.pc_list      
           and pc.pc_curr = pc_mstr.pc_curr      
           and pc.pc_prod_line = pc_mstr.pc_prod_line 
           and pc.pc_part = pc_mstr.pc_part      
           and pc.pc_um = pc_mstr.pc_um
           and pc.pc_amt_type = pc_mstr.pc_amt_type
           and pc.pc_start < pc_mstr.pc_start
           break by pc.pc_domain by pc.pc_list by pc.pc_start descending:
           if first-of(pc.pc_domain) then do:
              assign vdte = pc_mstr.pc_start - 1.
           end.
           if (pc.pc_expir = ? or pc.pc_expir > vdte) and vdte >= pc.pc_start then 
              assign pc.pc_expir = vdte.
           assign vdte = pc.pc_start - 1.
       end.         
/* 140123.1  - End */
    if can-find(first vd_mstr no-lock where vd_domain = dom_domain
                  and vd_addr = pc_mstr.pc_list ) and
       can-find(first pt_mstr no-lock where pt_domain = dom_domain
                  and pt_part = pc_mstr.pc_part)
    then do:
       find first pc exclusive-lock where pc.pc_domain = dom_domain
              and pc.pc_list = pc_mstr.pc_list
              and pc.pc_curr = pc_mstr.pc_curr
              and pc.pc_prod_line = pc_mstr.pc_prod_line
              and pc.pc_part = pc_mstr.pc_part
              and pc.pc_um = pc_mstr.pc_um
              and pc.pc_start = pc_mstr.pc_start no-error.
       if available pc then do:
          delete pc.
       end.
       buffer-copy pc_mstr EXCEPT pc_domain to pc no-error.
       assign pc.pc_domain = dom_domain.
    end. /* if can-find vd and can-find pt*/
end. /* for each dom_mstr*/
