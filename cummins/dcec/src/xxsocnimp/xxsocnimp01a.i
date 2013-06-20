/*计算xsc_d要装入数据                                                         */

  DEFINE VARIABLE VQTY01 LIKE ld_qty_oh.
  /*数量完全匹配*/
  for each xsc_m exclusive-lock where xsm_stat = "":
      find first xsa_r exclusive-lock where
           xsm_part = xsr_part and xsm_qty_used = xsr_oh and
           (xsm_so = xsr_so or xsm_so = "") no-error.
      if available xsa_r then do:
         create xsc_d.
         assign xsd_ship = xsr_ship
                xsd_cust = xsr_cust
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
                xsd_qty_keep = 0
                xsd_mid = recid(xsc_m).
         assign xsm_stat = "C".
         delete xsa_r.
      end.
  end.

  /*check qty_loc 数量不足*/
  for each xsc_m exclusive-lock where xsm_stat = "" and xsm_so <> ""
        break by xsm_part by xsm_so:
         assign vqty01 = 0.
         for each xsa_r exclusive-lock where xsr_part = xsm_part and xsr_stat = ""
             and (xsm_so = xsr_so or xsm_so = ""):
             assign vqty01 = vqty01 + xsr_oh.
             assign xsr_stat = "C".
             if vqty01 >= xsm_qty_used then do:
                leave.
             end.
         end.
      if xsm_qty_used > vqty01 then do:
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
                xsd_qty_oh = vqty01
                xsd_qty_keep = vqty01 - xsm_qty_used
                xsd_chk = getmsg(6754)
                xsd_mid = recid(xsc_m).
         assign xsm_stat = "C".
      end.
  end.

  for each xsc_m exclusive-lock where xsm_stat = "":
      for each xsa_r exclusive-lock where xsm_part = xsr_part AND
           (xsm_so = xsr_so or xsm_so = ""):
           create xsc_d.
           assign xsd_ship = xsr_ship
                  xsd_cust = xsr_cust
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
