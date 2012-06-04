/* xstrshipall.i - xxtrsp2ship.i record splited item to xxship_det           */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 24YP LAST MODIFIED: 04/24/12 BY: zy expand xrc length to 120    */
/* REVISION END                                                              */
{mfdeclre.i}
/* -----------------------------------------------------------
   Purpose: 单个物料调拨时将已拆分物料的记录在xxship_det.
   Parameters:
             {1} Item_Number
             {2} Lot/Serial
   Notes:
 -------------------------------------------------------------*/

   define variable vcimFile as character.
   assign vcimfile = "xsictr69.p." + string(today,"99999999") + "-" + string(time).
   assign vv_key1 = vcimfile + ".cimproc"
   for each usrw_wkfl exclusive-lock where usrw_key1 begins vcimfile:
       delete usrw_wkfl.
   end.
   assign i = 0.
   for each xxship_det no-lock where xxship_nbr = trim(entry(1,V1100,"@"))
           and xxship_case = integer(trim(V1110)) and xxship__chr03 = "",
      each ld_det no-lock where ld_part = xxship_part2 and ld_lot = xxship__chr01
       and ld_site = V1002 and ld_loc = trim(v1130) and ld_qty_oh > 0:
       create usrw_wkfl.
       assign usrw_key1 = vv_key1
              usrw_key2 = string(i)
              usrw_key3 = xxship_nbr
              usrw_key4 = string(xxship_case)
              usrw_key5 = ld_part
              usrw_key6 = ld_lot
              usrw_charfld[1] = xxship_vend
              usrw_charfld[2] = ld_site
              usrw_charfld[3] = ld_loc
              usrw_charfld[4] = V1140
              usrw_decfld[1] = ld_qty_oh.
       assign i = i + 1.
   end.

   output to value(vcimfile + ".bpi").
      for each usrw_wkfl no-lock where usrw_key1 = vv_key1:
          put unformat usrw_key5 skip.
          put unformat usrw_decfld[1] ' - "' usrw_key3 '" "' usrw_key4 '" "' usrw_charfld[1] '"' skip.
          put unformat '-' skip.
          put unformat '- "' usrw_charfld[3] '" "' usrw_key6 '"' skip.
          put unformat '- "' usrw_charfld[4] '" -' skip.
          put "Y" skip.
          put "." skip.
      end.
   output close.

   do transaction on stop undo,leave:
      assign vtrrecid = current-value(tr_sq01).
      batchrun = yes.
      input from value(vcimfile + ".bpi").
      output to value(vcimfile + ".bpo") keep-messages.
      hide message no-pause.
      {gprun.i ""iclotr04.p""}
      hide message no-pause.
      output close.
      input close.
      batchrun = no.

      assign yn = yes.
      for each usrw_wkfl no-lock where usrw_key1 = vv_key1:
          find first tr_hist no-lock use-index tr_nbr_eff where tr_trnbr > int(vtrrecid)
                and tr_effdate = today and tr_nbr = usrw_key3 and tr_so_job = usrw_key4
                and tr_part = usrw_key5 and tr_type = "iss-tr" and tr_site = usrw_charfld[2]
                and tr_loc = usrw_charfld[3] and tr_lot = usrw_key6 no-error.
          if not available tr_hist then do:
             assign yn = no.
             undo,leave.
          end.
          find first tr_hist no-lock use-index tr_nbr_eff where tr_trnbr > int(vtrrecid)
                and tr_effdate = today and tr_nbr = usrw_key3 and tr_so_job = usrw_key4
                and tr_part = usrw_key5 and tr_type = "rct-tr" and tr_site = usrw_charfld[2]
                and tr_loc = usrw_charfld[4] and tr_lot = usrw_key6 no-error.
          if not available tr_hist then do:
             assign yn = no.
             undo,leave.
          end.
      end.
   end.     /* do transaction undo, leave:  */

   for each usrw_wkfl exclusive-lock where usrw_key1 = vv_key1:
       delete usrw_wkfl.
   end.
   os-delete value(vcimfile + ".bpi") no-error.
   os-delete value(vcimfile + ".bpo") no-error.
