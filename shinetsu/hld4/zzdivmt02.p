/* zzdivmt01.p - Diversion Maintenance Backward Exploded                     */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 24YP LAST MODIFIED: 04/24/12 BY: zy expand xrc length to 120    */
/* REVISION END                                                              */

{mfdeclre.i}
{gplabel.i}

{zzdivmt.i}

DEFINE VARIABLE fn_i AS CHARACTER.
DEFINE VARIABLE v_tr_trnbr LIKE tr_trnbr.

FOR EACH ttld_det WHERE ttld_sel:

      fn_i = "zzdivmt312-" + global_userid + STRING(TIME).

      OUTPUT TO VALUE(fn_i + ".bpi" ).
      PUT UNFORMATTED entry(1,ttld_part1,"-") + '-04' SKIP.
      PUT UNFORMATTED ttld_site " " ttld_qty_oh  " " "- - " ttld_site " "
                      ttld_loc_to " " ttld_lot " " """" +
                      ttld_ref + """" " " "NO"   SKIP.
      PUT UNFORMATTED "- - - - - - - - - " "YES" SKIP.
      PUT UNFORMATTED """" + " " + """"  SKIP.
      /*
      PUT UNFORMATTED SKIP(1).
      PUT UNFORMATTED SKIP(1).
      */
      PUT UNFORMATTED ttld_part1 SKIP.
      PUT UNFORMATTED ttld_qty_oh " " "NO" " " ttld_site " " ttld_loc " "
                      ttld_lot  " " """" + ttld_ref + """" " " "no" SKIP.
      PUT UNFORMATTED """" + " " + """" SKIP.
      PUT UNFORMATTED "yes" SKIP.
      PUT UNFORMATTED "yes" SKIP.
      PUT UNFORMATTED "yes" SKIP.
      OUTPUT CLOSE .

      FIND LAST tr_hist WHERE tr_domain = global_domain NO-LOCK NO-ERROR.
      v_tr_trnbr = tr_trnbr.

      batchrun = yes.
      INPUT FROM VALUE(fn_i + ".bpi" ) .
      OUTPUT TO VALUE(fn_i + ".bpo" ) .
      {gprun.i ""icunrc01.p""}
      INPUT CLOSE.
      OUTPUT CLOSE.
      batchrun = NO.

      FIND LAST tr_hist WHERE tr_domain = global_domain
            AND tr_effdate = TODAY
            AND tr_part = ttld_part1
            AND tr_loc = ttld_loc
            AND tr_serial = ttld_lot
            AND tr_ref = ttld_ref
            AND tr_qty_loc = - ttld_qty_oh
            AND tr_trnbr > v_tr_trnbr
            AND tr_type = "ISS-WO" NO-LOCK NO-ERROR.
      IF AVAIL tr_hist THEN DO:
         find first lot_mstr where lot_domain = global_domain and
                    lot_serial = ttld_lot and
                    lot_part = "zzlot2" exclusive-lock no-error.
         if avail lot_mstr then do:
            assign lot__chr02 = "160".
         end.
         os-delete value(fn_i + ".bpi").
         os-delete value(fn_i + ".bpo").
/****************
          FIND FIRST zzsellot_mstr WHERE zzsellot_domain = global_domain
                 AND zzsellot_lotno = ttld_lot
                 AND zzsellot_final = "1"
                  NO-ERROR.
          IF AVAIL zzsellot_mstr THEN DO:
             ASSIGN
                 zzsellot_partchg_time = STRING(TIME,"HH:MM:SS")
                 zzsellot_partchg_dt = STRING(TODAY)
                 zzsellot_partchg_userid = GLOBAL_userid
                 zzsellot_partchg_partto = x_part
                 zzsellot_partchg_partfrom = x_part1
                 zzsellot_partchg_reason = transfer_rs
                 zzsellot_part = x_part
                 zzsellot_extralen_tech = jsyc_dec
                 zzsellot_extralen_other = qtyc_dec
                 zzsellot_insp_efflength = ttld_yxc.
          END.
          FIND FIRST zzsellot_mstr WHERE zzsellot_domain = global_domain
                 AND zzsellot_lotno = ttld_lot
                 AND zzsellot_final <> "1"
                  NO-ERROR.
          if available zzsellot_mstr then do:
             assign zzsellot_insp_goodweight = zzsellot_insp_calcweight.
          end.
*****************/
     end.
   END. /*FOR EACH ttld_det*/
