define {1} shared temp-table temp3
        field t3_part        like pt_part
        field t3_comp        like ps_comp
        field t3_qty_per     like ps_qty_per
        field t3_ps_code     like ps_ps_code.

procedure getSubQty:
 /* -----------------------------------------------------------
    Purpose: 计算BOM用量到table temp3
    Parameters: vv_par:父零件,vv_eff_date:生效日
    Notes:
  -------------------------------------------------------------*/

    define input  parameter vv_part     as character .
    define input  parameter vv_eff_date as date format "99/99/99" .

    define var  vv_comp     like ps_comp no-undo.
    define var  vv_level    as integer   no-undo.
    define var  vv_record   as integer extent 500.
    define var  vv_qty      as decimal initial 1  no-undo.
    define var  vv_save_qty as decimal extent 500 no-undo.

    assign vv_level = 1
           vv_comp  = vv_part
           vv_save_qty = 0
           vv_qty      = 1 .

find first ps_mstr use-index ps_parcomp where
           ps_par = vv_comp  no-lock no-error .
repeat:
       if not avail ps_mstr then do:
             repeat:
                vv_level = vv_level - 1.
                if vv_level < 1 then leave .
                find ps_mstr where recid(ps_mstr) = vv_record[vv_level]
                             no-lock no-error.
                vv_comp  = ps_par.
                vv_qty = vv_save_qty[vv_level].
                find next ps_mstr use-index ps_parcomp where
                          ps_par = vv_comp  no-lock no-error.
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


                find first temp3 where t3_part = vv_part and
                           t3_comp = ps_comp no-error.
                if not available temp3 then do:
                    create temp3.
                    assign
                        t3_part     = caps(vv_part)
                        t3_comp     = caps(ps_comp)
                        t3_qty_per  = vv_qty
                        t3_ps_code  = ps_ps_code.
                        .
                end.
                else t3_qty_per   = t3_qty_per + vv_qty  .

                find first ps_mstr use-index ps_parcomp where
                           ps_par = vv_comp  no-lock no-error.
        end.   /*if (ps_end = ? or vv_eff_date <= ps_end)*/
        else do:
              find next ps_mstr use-index ps_parcomp where
                        ps_par = vv_comp  no-lock no-error.
        end.  /* not (ps_end = ? or vv_eff_date <= ps_end)  */
end. /*repeat:*/

end procedure. /*bom_down*/
