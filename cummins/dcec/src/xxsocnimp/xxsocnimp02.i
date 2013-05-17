/*取得批号到xsa_r*/
empty temp-table xst_t no-error.
for each xsa_r1 no-lock:
   for each tr_hist fields(tr_domain tr_part tr_type tr_nbr tr_line
            tr_serial tr_ref tr_rmks tr_trnbr) no-lock
       where tr_domain = global_domain and
             tr_part = xsr1_part and
            (tr_type = "CN-SHIP" or tr_type = "CN-USE") AND
             tr_nbr = xsr1_so and tr_line = xsr1_line:
             create xst_t.
             assign xst_type = tr_type
                    xst_id = integer(tr_rmks)
                    xst_so = tr_nbr
                    xst_line = tr_line
                    xst_lot = tr_serial
                    xst_ref = tr_ref.
   end.
   for each xst_t exclusive-lock:
       find first tr_hist where tr_domain = global_domain
              and tr_trnbr = xst_id no-lock no-error.
       if available tr_hist then do:
          assign xst_qty = tr_qty_loc.
       end.
   end.
end.
for each xsa_r1 no-lock:
    for each xst_t no-lock where xst_so = xsr1_so and xst_line = xsr1_line
       break by xst_so by xst_line by xst_lot by xst_ref:
         if first-of(xst_ref) then do:
            assign qty_cn = 0.
         end.
         assign qty_cn = qty_cn + xst_qty.
         if last-of(xst_ref) then do:
            create xsa_r.
            assign xsr_ship = xsr1_ship
                   xsr_so = xsr1_so
                   xsr_line = xsr1_line
                   xsr_part = xsr1_part
                   xsr_site = xsr1_site
                   xsr_loc = xsr1_loc
                   xsr_lot = xst_lot
                   xsr_ref = xst_ref
                   xsr_eff = xsr1_eff
                   xsr_oh = qty_cn
                   xsr_um = xsr_um.
        end.
   end.
end.
