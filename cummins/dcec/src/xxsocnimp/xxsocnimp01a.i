/*计算xsc_d要装入数据                                                         */

  DEFINE VARIABLE VQTY01 LIKE ld_qty_oh.
  DEFINE VARIABLE VQTY02 LIKE ld_qty_oh.
  define variable vdetstat as character.

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
            delete xsc_m.
            delete xsa_r.
      end.
  end.

/*check qty_loc 库存数量大于使用量*/
  for each xsc_m exclusive-lock where xsm_stat = "":
      find first xsa_r exclusive-lock where
           xsm_part = xsr_part and xsm_qty_used < xsr_oh and
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
                xsd_qty_used = xsm_qty_used
                xsd_qty_oh = xsr_oh - xsm_qty_used
                xsd_qty_keep = xsr_oh - xsm_qty_used
                xsd_mid = recid(xsc_m).
            assign xsr_oh = xsr_oh - xsm_qty_used.
            delete xsc_m.
      end.
  end.

  for each xsc_m exclusive-lock where xsm_stat = "":
  xme:
      for each xsa_r exclusive-lock where
           xsm_part = xsr_part and
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
                xsd_mid = recid(xsc_m)
                .
           if xsr_oh >= xsm_qty_used then do:
              assign xsd_qty_used = xsm_qty_used
                     xsd_qty_keep = xsr_oh - xsm_qty_used
                     xsd_qty_oh = xsr_oh - xsm_qty_used
                     xsr_oh = xsr_oh - xsm_qty_used.
              if xsr_oh = 0 then do:
                 delete xsa_r.
              end.
              assign xsm_qty_used = 0.
              delete xsc_m.
           end.
           else do:
               assign xsd_qty_used = xsr_oh
                      xsd_qty_oh = 0
                      xsd_qty_keep = 0
                      xsm_qty_used = xsm_qty_used - xsr_oh.
           end.
        end.
  end.
  for each xsc_m exclusive-lock where xsm_stat = "":
      create xsc_d.
      assign xsd_ship = xsm_ship
             xsd_cust = xsm_cust
             xsd_qty_used = xsm_qty_used
             xsd_part = xsm_part
             xsd_serial = xsm_serial
             xsd_mid = recid(xsc_m)
             xsd_qty_oh = 0
             xsd_qty_keep = 0
             xsd_chk = getmsg(6754)
             .
  end.