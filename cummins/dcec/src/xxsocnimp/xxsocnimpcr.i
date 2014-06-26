/* xxsocnimpcr.i create xsa_r temp file                                      */

/*   for each cncix_mstr no-lock where cncix_domain = global_domain          */
/*         and cncix_shipto = xsm_ship and cncix_part = xsm_part:            */
/*         find first xsa_r exclusive-lock                                   */
/*              where xsr_ship = cncix_shipto                                */
/*                and xsr_cust = cncix_cust                                  */
/*                and xsr_so = cncix_so_nbr                                  */
/*                and xsr_line = cncix_sod_line                              */
/*                and xsr_part = cncix_part                                  */
/*                and xsr_site = cncix_site                                  */
/*                and xsr_loc = cncix_current_loc                            */
/*                and xsr_lot = cncix_lotser                                 */
/*                and xsr_ref = cncix_ref no-error.                          */
/*         if not available xsa_r then do:                                   */
/*         create xsa_r.                                                     */
/*         assign xsr_ship = cncix_shipto                                    */
/*                xsr_cust = cncix_cust                                      */
/*                xsr_so = cncix_so_nbr                                      */
/*                xsr_line = cncix_sod_line                                  */
/*                xsr_part = cncix_part                                      */
/*                xsr_site = cncix_site                                      */
/*                xsr_loc = cncix_current_loc                                */
/*                xsr_lot = cncix_lotser                                     */
/*                xsr_ref = cncix_ref                                        */
/*                xsr_eff = ?                                                */
/*                xsr_um = cncix_stock_um.                                   */
/*         end.                                                              */
/*         assign xsr_oh = xsr_oh + cncix_qty_stock.                         */
/*   end.                                                                    */

     for each cncix_mstr no-lock where cncix_domain = global_domain
          and cncix_shipto = xsm_ship and cncix_part = xsm_part
     break by cncix_shipto
           by cncix_cust
           by cncix_so_nbr
           by cncix_sod_line
           by cncix_part
           by cncix_site
           by cncix_current_loc
           by cncix_lotser
           by cncix_ref:
           if first-of(cncix_ref) then do:
              qty_cn = 0.
           end.
           qty_cn = qty_cn + cncix_qty_stock.
           if last-of(cncix_ref) and qty_cn > 0 then do:
              create xsa_r.
              assign xsr_ship = cncix_shipto
                     xsr_cust = cncix_cust
                     xsr_so = cncix_so_nbr
                     xsr_line = cncix_sod_line
                     xsr_part = cncix_part
                     xsr_site = cncix_site
                     xsr_loc = cncix_current_loc
                     xsr_lot = cncix_lotser
                     xsr_ref = cncix_ref
                     xsr_eff = ?
                     xsr_um = cncix_stock_um
                     xsr_oh = qty_cn.
            end. /* if last-of(cncix_ref) and qty_cn > 0 then do: */
      end.
