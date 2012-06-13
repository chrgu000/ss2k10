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