/* xxrepkdis2.i - display workorder seqerence                                */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 24YP LAST MODIFIED: 04/24/12 BY: zy expand xrc length to 120    */
/* REVISION END                                                              */

    display t0_date t0_site t0_line t0_part
            t0_wktime
            t0_tttime
            string(t0_start,"hh:mm:ss") @ t0_start
            string(t0_end,"hh:mm:ss") @ t0_end
            t0_qtya
            t0_qty
            xx_comp
            xx_qty_req
            xx_nbr
            xx_op
            t0_qty / t0_qtya * xx_qty_req @ xx_start
            t0_tttime / t0_wktime * xx_qty_req @ t0_time
            with frame detail001 width 300 .
     down with frame detail001.

     /****
  for each xxwa_det exclusive-lock where
           xxwa__dte01 >= issue and xxwa__dte01 <= issue1 and
           xxwa_site >= site and (xxwa_site <= site1 or site1 = ?) and
           xxwa_line >= wkctr and (xxwa_line <= wkctr1 or wkctr1 = "")
  break by xxwa_date by xxwa_site by xxwa_line by xxwa_rtime by xxwa_part:
      display xxwa_date xxwa_site xxwa_line xxwa_part xxwa_qty_pln
              string(xxwa_rtime,"hh:mm:ss") @ xxwa_rtime
              string(xxwa_pstime,"hh:mm:ss") @ xxwa_pstime
              string(xxwa_petime,"hh:mm:ss") @ xxwa_petime
              string(xxwa_sstime,"hh:mm:ss") @ xxwa_sstime
              string(xxwa_setime,"hh:mm:ss") @ xxwa_setime
              xxwa__log01 with width 300.
  end.
    ******/   