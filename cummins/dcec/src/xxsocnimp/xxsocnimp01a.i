
/*  output to D:\dcec\src\SRC-2011SE\xxsocnimp\xsc_m.txt.                    */
/*  for each xsc_m with width 300:                                           */
/*      display xsc_m with stream-io.                                        */
/*  end.                                                                     */
/*  output close.                                                            */
/*  output to D:\dcec\src\SRC-2011SE\xxsocnimp\xsa_r.txt.                    */
/*  for each xsa_r no-lock break by xsr_part with width 300:                 */
/*    display xsa_r with stream-io.                                          */
/*  end.                                                                     */
/*  output close.                                                            */

  /*check qty_loc 数量不足*/
  for each xsc_m exclusive-lock where xsm_stat = "":
      for each xsa_r no-lock where
               (xsm_so = xsr_so or xsm_so = "") AND
               xsm_part = xsr_part:
          accum xsr_oh(total).
      end.
      if xsm_qty_used > accum total(xsr_oh) then do:
         create xsc_d.
         assign xsd_ship = xsm_ship
                xsd_cust = xsm_cust
                xsd_so = xsm_so
                xsd_line = 0
                xsd_serial = xsm_serial
                xsd_part = xsm_part
                xsd_qty_used = xsm_qty_used
                xsd_site = xsm_site
                xsd_loc = xsm_loc
                xsd_lot = xsm_lot
                xsd_ref = xsm_ref
                xsd_qty_oh = accum total(xsr_oh)
                xsd_qty_keep = (accum total(xsr_oh)) - xsm_qty_used
                xsd_chk = getmsg(6754)
                xsd_mid = recid(xsc_m).
         assign xsm_stat = "C".
      end.
  end.

  /*数量完全匹配*/
  for each xsc_m exclusive-lock where xsm_stat = "":
      find first xsa_r exclusive-lock where
           (xsm_so = xsr_so or xsm_so = "") AND
           xsm_part = xsr_part and xsm_qty_used = xsr_oh
           no-error.
      if available xsa_r then do:
         find first so_mstr no-lock where so_domain = global_domain
                and so_nbr = xsr_so no-error.
         create xsc_d.
         assign xsd_ship = so_ship when available so_mstr
                xsd_cust = so_cust when available so_mstr
                xsd_so = xsr_so
                xsd_line = xsr_line
                xsd_serial = xsm_serial
                xsd_part = xsr_part
                xsd_site = xsr_site
                xsd_loc = xsr_loc
                xsd_lot = xsr_lot
                xsd_ref = xsr_ref
                xsd_qty_used = xsr_oh
                xsd_qty_oh = xsr_oh
                xsd_qty_keep = xsr_oh - xsm_qty_used
                xsd_mid = recid(xsc_m).
           assign xsm_stat = "C".
           delete xsa_r.
      end.
  end.

  for each xsc_m exclusive-lock where xsm_stat = "":
      for each xsa_r exclusive-lock where
           (xsm_so = xsr_so or xsm_so = "") AND
           xsm_part = xsr_part:
           find first so_mstr no-lock where so_domain = global_domain
                and so_nbr = xsr_so no-error.
           create xsc_d.
           assign xsd_ship = so_ship when available so_mstr
                  xsd_cust = so_cust when available so_mstr
                  xsd_so = xsr_so
                  xsd_line = xsr_line
                  xsd_serial = xsm_serial
                  xsd_part = xsr_part
                  xsd_site = xsr_site
                  xsd_loc = xsr_loc
                  xsd_lot = xsr_lot
                  xsd_ref = xsr_ref
                  xsd_mid = recid(xsc_m).
            if xsr_oh >= xsm_qty_used then do:
           assign xsd_qty_used = xsm_qty_used
                  xsd_qty_oh = xsr_oh
                  xsd_qty_keep = xsr_oh - xsm_qty_used
                  xsm_qty_used = 0
                  xsm_stat = "C"
                  xsr_oh = xsr_oh - xsm_qty_used.
                  leave.
            end.
            else do:
           assign xsd_qty_used = xsr_oh
                  xsd_qty_oh = xsr_oh
                  xsd_qty_keep = 0
                  xsm_qty_used = xsm_qty_used - xsr_oh.
                  delete xsa_r.
            end.
      end.
  end.
  for each xsc_d exclusive-lock:
      find first sod_det exclusive-lock where sod_domain = global_domain
             and sod_nbr = xsd_so and sod_line = xsd_line no-error.
      if available sod_det then do:
         assign xsd_sched = sod_sched.
      end.
      if xsd_qty_used = 0 then do:
         delete xsc_d.
      end.
  end.
/*
    output to D:\dcec\src\SRC-2011SE\xxsocnimp\xsa_r.txt.
    for each xsa_r with width 300:
        display xsa_r with stream-io.
    end.
    output close.

    output to D:\dcec\src\SRC-2011SE\xxsocnimp\xsc_d.txt.
    for each xsc_d with width 300:
        display xsc_d with stream-io.
    end.
    output close.
*/