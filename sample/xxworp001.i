
define var v_desc     as char format "x(48)" .
define var v_std_cost as decimal format "->>>,>>>,>>>,>>9.9<" .
define var v_wo_cost  as decimal format "->>>,>>>,>>>,>>9.9<" .
define var v_std_time as decimal format "->>>,>>>,>>>,>>9.9<" .
define var v_time_set as decimal format "->>>,>>>,>>>,>>9.9<" .
define var v_time_run as decimal format "->>>,>>>,>>>,>>9.9<" .


define temp-table temp3
        field t3_part        like pt_part 
        field t3_comp        like ps_comp  label "×ÓÁã¼þ"
        field t3_qty_per     like ps_qty_per
        .


procedure get-standard-cost:
    define input  parameter i-site  like wo_site  no-undo.
    define input  parameter i-part  like wo_part  no-undo.
    define output parameter o-cost  like gltr_amt no-undo.

    define var v_gl_set like si_gl_set .
    define var v_pkqty  as decimal .

    o-cost = 0.
    find first si_mstr where si_domain = global_domain and si_site = i-site no-lock no-error.
    if avail si_mstr then do:
        v_gl_set = si_gl_set .
    end.

    find first sct_det 
        use-index sct_sim_pt_site
        where sct_domain = global_domain 
        and   sct_sim    = v_gl_set 
        and   sct_part   = i-part
        and   sct_site   = i-site 
    no-lock no-error.
    if avail sct_Det then o-cost = sct_mtl_ll + sct_mtl_tl .

end procedure .

procedure get-wo-cost:
    define input  parameter i-wonbr like wo_nbr no-undo.
    define input  parameter i-wolot like wo_lot no-undo.
    define input  parameter i-effdt like wo_rel_date no-undo.
    define output parameter o-cost  as decimal no-undo.

    o-cost = 0 .
    for each tr_hist 
        use-index tr_nbr_eff 
        where tr_domain   = global_domain 
        and   tr_nbr      = i-wonbr 
        and   tr_effdate >= i-effdt
        and   tr_lot      = i-wolot
        and   tr_type     = "ISS-WO"
        no-lock:
        o-cost = o-cost + tr_gl_amt.
    end.
end procedure .


procedure getSubQty:
    define input  parameter vv_part     as character .
    define input  parameter vv_eff_date as date format "99/99/99" .
    define output parameter vv_time_run as decimal  .
    define output parameter vv_time_set as decimal  .
    
    define var  vv_comp     like ps_comp no-undo.
    define var  vv_level    as integer   no-undo.
    define var  vv_record   as integer extent 500.
    define var  vv_qty      as decimal initial 1  no-undo.
    define var  vv_save_qty as decimal extent 500 no-undo.


    for each temp3 :  delete temp3 .  end .

    assign vv_level = 1 
           vv_comp  = vv_part
           vv_save_qty = 0 
           vv_qty      = 1 .

    
find first ps_mstr use-index ps_parcomp where ps_domain = global_domain and ps_par = vv_comp  no-lock no-error .
repeat:        
       if not avail ps_mstr then do:                        
             repeat:  
                vv_level = vv_level - 1.
                if vv_level < 1 then leave .                    
                find ps_mstr where recid(ps_mstr) = vv_record[vv_level] no-lock no-error.
                vv_comp  = ps_par.  
                vv_qty = vv_save_qty[vv_level].            
                find next ps_mstr use-index ps_parcomp where ps_domain = global_domain and  ps_par = vv_comp  no-lock no-error.
                if avail ps_mstr then leave .               
            end.
        end.  /*if not avail ps_mstr*/
    
        if vv_level < 1 then leave .
        vv_record[vv_level] = recid(ps_mstr).                
        
        
        if (ps_end = ? or vv_eff_date <= ps_end) then do :
                vv_save_qty[vv_level] = vv_qty.

                vv_comp  = ps_comp .
                vv_qty = vv_qty * ps_qty_per * (100 / (100 - ps_scrp_pct)).
                vv_level = vv_level + 1.


                find first temp3 where t3_part = vv_part and t3_comp = ps_comp no-error.
                if not available temp3 then do:
                    create temp3.
                    assign
                        t3_part     = caps(vv_part)
                        t3_comp     = caps(ps_comp)
                        t3_qty_per  = vv_qty 
                        .
                end.
                else t3_qty_per   = t3_qty_per + vv_qty  .  

                find first ps_mstr use-index ps_parcomp where ps_domain = global_domain and ps_par = vv_comp  no-lock no-error.     
        end.   /*if (ps_end = ? or vv_eff_date <= ps_end)*/
        else do:
              find next ps_mstr use-index ps_parcomp where ps_domain = global_domain and ps_par = vv_comp  no-lock no-error.
        end.  /* not (ps_end = ? or vv_eff_date <= ps_end)  */
end. /*repeat:*/   


vv_time_set = 0 .
vv_time_run = 0 .
for each temp3 where t3_part = vv_part :
    for each ro_det where ro_domain = global_domain and ro_routing = t3_comp no-lock :
        vv_time_set = vv_time_set + ro_setup.
        vv_time_run = vv_time_run + ro_run * t3_qty_per  .
    end.
end.
for each ro_det where ro_domain = global_domain and ro_routing = vv_part no-lock :
    vv_time_set = vv_time_set + ro_setup.
    vv_time_run = vv_time_run + ro_run   .
end.

end procedure. /*bom_down*/


