/*V8:ConvertMode=Report                                                */

define {1} shared variable frwrd like soc_fcst_fwd.
define {1} shared variable bck like soc_fcst_bck.
define {1} shared variable qty_oh like in_qty_oh.
define {1} shared variable site like si_site.
define {1} shared variable site1 like si_site.
/* "4303406-S700-00B7" */
define {1} shared variable part like pt_part.
define {1} shared variable part1 like pt_part.
define {1} shared variable buyer like pt_buyer.
define {1} shared variable buyer1 like pt_buyer.
define {1} shared variable prod_line like pt_prod_line.
define {1} shared variable prod_line1 like pt_prod_line.
define {1} shared variable ptgroup like pt_group.
define {1} shared variable ptgroup1 like pt_group.
define {1} shared variable part_type like pt_part_type.
define {1} shared variable part_type1 like pt_part_type.
define {1} shared variable vendor like pt_vend.
define {1} shared variable vendor1 like pt_vend.
define {1} shared variable start like ro_start.
define {1} shared variable ending like ro_end.
define {1} shared variable pm_code like pt_pm_code.
define {1} shared variable dwm as character format "x(1)"
   label {&mrmprp11_p_8}.
define {1} shared variable idays as integer format ">>>>>9"
   label {&mrmprp11_p_2}.
define {1} shared variable out_dev as character.

define variable old_start as date.
define variable not_part as integer.
define {1} shared variable subs like mfc_logical
   label {&mrmprp11_p_7}.
define {1} shared variable show_base like mfc_logical initial true
   label {&mrmprp11_p_1}.
define {1} shared variable plan_yn like mfc_logical
   label {&mrmprp11_p_9}.

define {1} shared temp-table tmp_list
    fields tl_part like ps_mstr.ps_par.

define {1} shared temp-table tmp_ps
   fields tps_par  like ps_mstr.ps_par
   fields tps_comp like ps_mstr.ps_comp
   fields tps_qty  like ps_mstr.ps_qty_per
   fields tps_rctpo as decimal format "->>>>>>9"
   fields tps_planpo as decimal format "->>>>>>9" extent 14
   index tps_par is primary tps_par tps_comp
   index tps_comp tps_comp tps_par.

define {1} shared temp-table tmp_data0
   fields t0_part like pt_part
   fields t0_site like pt_site
   fields t0_iss_so  as decimal format "->>>>>>9"
   fields t0_rct_po  as decimal format "->>>>>>9"
   fields t0_qty_req as decimal format "->>>>>>9" extent 14
   fields t0_open_po1 as decimal format "->>>>>>9" extent 14
   fields t0_open_so as decimal format "->>>>>>9" extent 14
   fields t0_open_po as decimal format "->>>>>>9" extent 14
   fields t0_vd_qtyoh as decimal format "->>>>>>9" extent 14
   fields t0_qty_loc  as decimal format "->>>>>>9" extent 14
   fields t0_qty_planpo as decimal format "->>>>>>9" extent 14
   index t0_part is primary t0_part.
/*
define {1} shared buffer psmstr for ps_mstr.
*/
procedure getList:
    define input  parameter vv_comp     as character .
    define input  parameter vv_eff_date as date format "99/99/99" .

    define var  vv_part     like ps_comp no-undo.
    define var  vv_level    as integer   no-undo.
    define var  vv_record   as integer extent 500.
    define var  vv_qty      as decimal initial 1  no-undo.
    define var  vv_save_qty as decimal extent 500 no-undo.

    assign vv_level = 1
           vv_part  = vv_comp
           vv_save_qty = 0
           vv_qty      = 1 .

    create tmp_list.
    assign tl_part = vv_comp.

find first ps_mstr use-index ps_comp where ps_domain = global_domain
       and ps_comp = vv_part  no-lock no-error.

repeat:
       if not avail ps_mstr then do:
             repeat:
                vv_level = vv_level - 1.
                if vv_level < 1 then leave .
                find ps_mstr where recid(ps_mstr) = vv_record[vv_level]
                     no-lock no-error.
                vv_part  = ps_comp.
                vv_qty = vv_save_qty[vv_level].
                find next ps_mstr use-index ps_comp where
                          ps_domain = global_domain and
                          ps_comp = vv_part  no-lock no-error.
                if avail ps_mstr then leave .
            end.
        end.  /*if not avail ps_mstr*/

        if vv_level < 1 then leave .
        vv_record[vv_level] = recid(ps_mstr).


        if (ps_end = ? or vv_eff_date <= ps_end) then do :
                vv_save_qty[vv_level] = vv_qty.

                vv_part  = ps_par.
                vv_qty = vv_qty * ps_qty_per * (100 / (100 - ps_scrp_pct)).
                vv_level = vv_level + 1.

                find first tmp_list where tl_part = vv_part no-error.
                if not available tmp_ps then do:
                    create tmp_list.
                    assign
                        tl_part      = caps(vv_part).
                end.
                else tps_qty   = tps_qty + vv_qty  .

                find first ps_mstr use-index ps_comp where
                           ps_domain = global_domain and
                           ps_comp = vv_part  no-lock no-error.
        end.   /*if (ps_end = ? or vv_eff_date <= ps_end)*/
        else do:
              find next ps_mstr use-index ps_comp where
                        ps_domain = global_domain and
                        ps_comp = vv_part  no-lock no-error.
        end.  /* not (ps_end = ? or vv_eff_date <= ps_end)  */
end.
end.
procedure getPar:
    define input  parameter vv_comp     as character .
    define input  parameter vv_eff_date as date format "99/99/99" .

    define var  vv_part     like ps_comp no-undo.
    define var  vv_level    as integer   no-undo.
    define var  vv_record   as integer extent 500.
    define var  vv_qty      as decimal initial 1  no-undo.
    define var  vv_save_qty as decimal extent 500 no-undo.

    assign vv_level = 1
           vv_part  = vv_comp
           vv_save_qty = 0
           vv_qty      = 1 .


find first ps_mstr use-index ps_comp where ps_domain = global_domain
       and ps_comp = vv_part  no-lock no-error.

repeat:
       if not avail ps_mstr then do:
             repeat:
                vv_level = vv_level - 1.
                if vv_level < 1 then leave .
                find ps_mstr where recid(ps_mstr) = vv_record[vv_level]
                     no-lock no-error.
                vv_part  = ps_comp.
                vv_qty = vv_save_qty[vv_level].
                find next ps_mstr use-index ps_comp where
                          ps_domain = global_domain and
                          ps_comp = vv_part  no-lock no-error.
                if avail ps_mstr then leave .
            end.
        end.  /*if not avail ps_mstr*/

        if vv_level < 1 then leave .
        vv_record[vv_level] = recid(ps_mstr).


        if (ps_end = ? or vv_eff_date <= ps_end) then do :
                vv_save_qty[vv_level] = vv_qty.

                vv_part  = ps_par.
                vv_qty = vv_qty * ps_qty_per * (100 / (100 - ps_scrp_pct)).
                vv_level = vv_level + 1.

                find first tmp_ps where tps_par = vv_part and
                           tps_comp = vv_comp no-error.
                if not available tmp_ps then do:
                    create tmp_ps.
                    assign
                        tps_par      = caps(vv_part)
                        tps_comp     = caps(vv_comp)
                        tps_qty      = vv_qty
                        .
                end.
                else tps_qty   = tps_qty + vv_qty  .

                find first ps_mstr use-index ps_comp where
                           ps_domain = global_domain and
                           ps_comp = vv_part  no-lock no-error.
        end.   /*if (ps_end = ? or vv_eff_date <= ps_end)*/
        else do:
              find next ps_mstr use-index ps_comp where
                        ps_domain = global_domain and
                        ps_comp = vv_part  no-lock no-error.
        end.  /* not (ps_end = ? or vv_eff_date <= ps_end)  */
end.

end procedure. /*bom_down*/

/***************
procedure getPar:
  define input parameter icomp like ps_mstr.ps_comp.
  define input parameter iLeav like ps_mstr.ps_par.
  define input-output parameter iqty like ps_mstr.ps_qty_per.
  for each ps_mstr use-index ps_comp no-lock where
             ps_domain = global_domain and
             ps_comp = icomp  and
            (ps_mstr.ps_start <= today or ps_mstr.ps_start = ?) and
            (ps_mstr.ps_end >= today or ps_mstr.ps_end = ?):
      find first psmstr no-lock where psmstr.ps_domain = global_domain and
                 psmstr.ps_comp = ps_mstr.ps_par no-error.
      if available psmstr then do:
         find first pt_mstr no-lock where pt_domain = global_domain and
                    pt_part = psmstr.ps_par no-error.
         if available pt_mstr then do:
            if pt_pm_code = "P" then do:
               assign iqty = iqty * ps_mstr.ps_qty_per.
               run getPar(input ps_mstr.ps_par ,input ps_mstr.ps_comp ,
                          input-output iqty).
            end.
            else do:
                assign iqty = iqty * ps_mstr.ps_qty_per.
                find first tmp_ps where tps_comp = ps_mstr.ps_comp and
                           tps_par = ps_mstr.ps_par no-error.
                if available tmp_ps then do:
                   assign tps_qty = tps_qty + iqty.
                end.
                else do:
                   create tmp_ps.
                   assign tps_comp = iLeav
                          tps_par = ps_mstr.ps_par
                          tps_qty = iqty.
                end.
            end.
         end.
      end.
      else do:
         find first pt_mstr no-lock where pt_domain = global_domain and
                    pt_part = ps_mstr.ps_par and pt_pm_code = "P" no-error.
         if available pt_mstr then do:
           find first tmp_ps where tps_comp = ps_mstr.ps_comp
                               and tps_par = ps_mstr.ps_par
                               and tps_qty = ps_mstr.ps_qty_per no-error.
           if not available tmp_ps then do:
           create tmp_ps.
           assign tps_comp = ps_mstr.ps_comp
                  tps_par = ps_mstr.ps_par
                  tps_qty = ps_mstr.ps_qty_per
                  iqty = ps_mstr.ps_qty_per.
           leave.
           end.
           else do:
                assign tps_qty = tps_qty + ps_mstr.ps_qty_per
                       iqty = tps_qty.
           end.
         end.
      end.
  end.
end procedure.
*************************/
