/* xxpold1.p - check data                                                    */
{mfdeclre.i}
{xxpold.i}
define variable vcurr like vd_curr.
define variable vum like pt_um.
for each xxpod9 exclusive-lock:
    assign x9_chk = "".
    find first pod_det no-lock where pod_domain = global_domain
         and pod_nbr = x9_nbr and pod_line = x9_line no-error.
    if available pod_det then do:
       assign x9_chk = "PO:" + x9_nbr + "项次" + trim(string(x9_line)) + "已存在!".
       next.
    end.
    if x9_line > 999 or x9_line < 1 then do:
       assign x9_chk = "项号错误!".
       next.
    end.
    find first vd_mstr no-lock where vd_domain = global_domain
           and vd_addr = x9_vend no-error.
    if not available vd_mstr then do:
       assign x9_chk = "供应商不存在!".
       next.
    end.
    else do:
       assign vcurr = vd_curr.
       if vcurr = "" then do:
          assign x9_chk = "供应商币别设置错误!".
          next.
       end.
       else do:
           find first cu_mstr no-lock where cu_curr = vd_curr no-error.
           if not available cu_mstr then do:
              assign x9_chk = "供应商币别设置错误!".
              next.
           end.
       end.
     end.
     find first poc_ctrl no-lock where poc_domain = global_domain no-error.
     if available poc_ctrl then do:
        if poc_pt_req then do:
           if x9_pr_list2 = "" or
             not can-find(first pc_mstr no-lock where pc_domain = global_domain
                            and pc_list = x9_pr_list2 and pc_amt_type = "L"
                            and pc_part = x9_part
                            and (pc_start <= today or pc_start = ?)
                            and (pc_expir >= today or pc_expir = ?)) then do:
             assign x9_chk = "价格表未找到!".
             next.
           end.
        end.
        if poc_pl_req then do:
           if x9_pr_list = "" or
             not can-find(first pc_mstr no-lock where pc_domain = global_domain
                            and pc_list = x9_pr_list and pc_amt_type <> "L"
                            and pc_part = x9_part
                            and (pc_start <= today or pc_start = ?)
                            and (pc_expir >= today or pc_expir = ?)) then do:
             assign x9_chk = "折扣表未找到!".
             next.
           end.
        end.
      end.
    find first si_mstr no-lock where si_domain = global_domain
           and si_site = x9_site no-error.
    if not available si_mstr then do:
       assign x9_chk = "地点不存在!".
       next.
    end.
    find first pt_mstr no-lock where pt_domain = global_domain
           and pt_part = x9_part no-error.
    if not available pt_mstr then do:
       assign x9_chk = "料号不存在".
       next.
    end.
    else do:
         assign vum = pt_um.
         find first isd_det no-lock where isd_domain = global_domain
                and trim(substring(isd_status,1,8)) = pt_status
                and (isd_tr_type = "add-po" or isd_tr_type = "ord-po" ) no-error.
         if available isd_det then do:
             x9_chk = "零件状态限制" .
             next.
         end.
         find first poc_ctrl no-lock where poc_domain = global_domain no-error.
         if available poc_ctrl then do:
            find first pc_mstr no-lock where pc_domain = global_domain
                   and pc_list = x9_pr_list2 and pc_curr = vcurr
                   and pc_prod_line = ""
                   and pc_part = x9_part and pc_um = vum
                   and (pc_start <= today or pc_start = ?) no-error.
            if not available pc_mstr then do:
                x9_chk = "价格表不存在" .
                next.
            end.
        end.
    end.
end.
