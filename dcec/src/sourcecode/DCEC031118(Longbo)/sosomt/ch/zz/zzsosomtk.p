/* GUI CONVERTED from sosomtk.p (converter v1.69) Wed Jul 17 15:47:24 1996 */
/* sosomtk.p - DELETE SALES ORDER BILL                                  */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 6.0      LAST MODIFIED: 07/16/90   BY: EMB *D040**/
/* REVISION: 6.0      LAST MODIFIED: 11/29/90   BY: emb *D232**/
/* REVISION: 7.0      LAST MODIFIED: 11/06/91   BY: pma *F003**/
/* REVISION: 7.0      LAST MODIFIED: 04/09/92   BY: emb *F369**/
/* REVISION: 7.0      LAST MODIFIED: 06/04/92   BY: tjs *F504**/
/* REVISION: 7.0      LAST MODIFIED: 07/28/92   BY: emb *F817**/
/* REVISION: 7.3      LAST MODIFIED: 09/27/92   BY: jcd *G247**/
/* REVISION: 7.3      LAST MODIFIED: 04/15/93   BY: tjs *G948**/
/* REVISION: 7.3      LAST MODIFIED: 05/10/94   BY: tjs *FN95**/
/* Oracle changes (share-locks)      09/15/94   BY: rwl *FR31**/
/* REVISION: 8.5      LAST MODIFIED: 03/05/95   BY: DAH *J042**/
/* REVISION: 8.5      LAST MODIFIED: 04/24/96   BY: rxm *G1QJ**/
/* REVISION: 8.5      LAST MODIFIED: 07/09/96   BY: DAH *J0XR**/
/* REVISION: 8.5      LAST MODIFIED: 07/15/96   BY: ajw *J0Z6**/
/* REVISION: 8.5      LAST MODIFIED: 11/14/03   BY: *LB01* Long Bo         */

/* Calling procedure sets delete_line to "yes" if sob_det is to be deleted,  */
/* "no" when inventory qty reqd, mrp demand and forecast is no longer needed */
/* (order line is changed to memo type).                                     */

         {mfdeclre.i}

         define shared variable sod_recno as recid.
         define shared variable so_recno as recid.
/*F817*/ define shared variable prev_consume like sod_consume.
/*F817*/ define shared variable prev_type like sod_type.
/*G948*/ define shared variable delete_line like mfc_logical.

         define variable sobconsume like sob_qty_req.
         define variable sobabnormal like sob_qty_req.
/*G247** define shared variable mfguser as character. **/
         define variable i as integer.
         define new shared variable qty like sod_qty_ord.
         define new shared variable part as character format "x(18)".
         define new shared variable eff_date as date.
         define variable soc_sob_fcst as character.
/*FN95*/ define variable x3 as character format "x(3)".
/*J042*/ define shared variable line_pricing like mfc_logical.
/*J042*/ define shared variable new_order like mfc_logical.
/*J042*/ define shared variable so_db like dc_name.
/*G1QJ*/ define variable pm_code like pt_pm_code.

         find sod_det no-lock where recid(sod_det) = sod_recno.
         find so_mstr no-lock where recid(so_mstr) = so_recno.

         soc_sob_fcst = string(no).
         {mfctrl01.i "mfc_ctrl" "soc_sob_fcst" soc_sob_fcst no}

         find sod_det no-lock where recid(sod_det) = sod_recno.

/*G1QJ for each sob_det where sob_nbr = sod_nbr and sob_line = sod_line: */
/*G1QJ*/ for each sob_det where sob_nbr = sod_nbr and sob_line = sod_line
/*G1QJ*/ exclusive-lock:
/*GUI*/ if global-beam-me-up then undo, leave.


/*G948*/ if delete_line then do:
/*FR31*/    for each cmt_det exclusive-lock where cmt_indx = sob_cmtindx:
               delete cmt_det.
            end.
/*G948*/ end.

/*F504*  if so_conf_date <> ? and sod_type = "" then do: */
/*F817*
/*F504*/ if sod_confirm and sod_type = "" then do: */
/*F817*/ if sod_confirm and prev_type = "" then do:

      if soc_sob_fcst = string(yes) then do:
/*F817*  sobconsume  = if sod_consume then - sob_qty_req else 0.
         sobabnormal = if sod_consume then 0 else - sob_qty_req. */
/*F817*/ sobconsume  = if prev_consume then - sob_qty_req else 0.
/*F817*/ sobabnormal = if prev_consume then 0 else - sob_qty_req.
         {sobfc.i sob_part sob_iss_date sobconsume sobabnormal sob_site}
      end.

      if sod_status <> "FAS" and sod_fa_nbr = ""
      and (sob_qty_req <> 0 or sob_qty_all <> 0 or sob_qty_pick <> 0)
      then do:
/*G1QJ*/ find pt_mstr where pt_part = sob_part no-lock no-error.
/*G1QJ*/ pm_code = pt_pm_code.
/*G1QJ*/ find ptp_det where ptp_part = pt_part and ptp_site = sob_site
/*G1QJ*/ no-lock no-error.
/*G1QJ*/ if available ptp_det then pm_code = ptp_pm_code.
/*G1QJ*/ if pm_code <> "C" then do:
            find in_mstr where in_part = sob_part and in_site = sod_site
            exclusive-lock no-error.
            if available in_mstr then do:
               if sob_qty_req > 0 then
                  in_qty_req = in_qty_req - max(sob_qty_req - sob_qty_iss,0).
               if sob_qty_req < 0 then
                  in_qty_req = in_qty_req - min(sob_qty_req - sob_qty_iss,0).
               if (sob_qty_all <> 0 or sob_qty_pick <> 0) then
                  in_qty_all = in_qty_all - sob_qty_all - sob_qty_pick.
            end.
/*G1QJ*/ end.
      end.

      /* UPDATE PART MASTER MRP FLAG */
      {inmrp.i &part=sob_part &site=sob_site}

   end.

/*F369*  {mfmrwdel.i "sob_det" sob_part sob_nbr
         "string(sob_line) + ""-"" + sob_feature" """"} */

/*F369*/ {mfmrwdel.i "sob_det" sob_part sob_nbr
         "string(sob_line) + ""-"" + sob_feature" sob_parent }

/*G948*/ if delete_line then do:
/*FN95*/ /* begin added block */
            x3 = string(sob_line).
            find qad_wkfl where qad_key1 = "sob_det"
            and qad_key2 = string(sob_nbr,"x(8)") + string(x3,"x(3)") +
            string(sob_feature,"x(43)") + sob_part
            no-error.
            if available qad_wkfl then delete qad_wkfl.
/*FN95*/ /* end of added block */
/*J042*/ /* UPDATE ACCUM QTY WORKFILE WITH REVERSAL, SINCE IT WAS INCLUDED
            JUST PRIOR TO INVOKING sosomta.p.  CHECK FOR global_db SINCE
            PROCEDURE CAN BE CALLED FROM solndel.p WHEN UPDATING REMOTE
            DB's */
            if (line_pricing or not new_order) and so_db = global_db then do:
/*J0XR*/       /*Qualified the qty (sob_qty_req) and extended list   */
/*J0XR*/       /*(sob_qty_req * sob_tot_std) parameters to divide by */
/*J0XR*/       /*u/m conversion ratio since these include this factor*/
/*J0XR*/       /*already.                                            */
/*LB01*/       {gprun.i ""zzgppiqty2.p"" "(sod_line,
                                         sob_part,
                                         - (sob_qty_req / sod_um_conv),
                                         - (sob_tot_std * sob_qty_req
                                                        / sod_um_conv),
                                         sod_um,
                                         yes,
/*J0Z6*/                                 yes,
                                         yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J042*/    end.

            delete sob_det.
/*G948*/ end.
end.
/*GUI*/ if global-beam-me-up then undo, leave.


/*F817*/ /* Added following section*/
         for each mrp_det where mrp_dataset = "pbo_sold"
/*G1QJ         and mrp_nbr = sod_nbr and mrp_line = string(sod_line): */
/*G1QJ*/ and mrp_nbr = sod_nbr and mrp_line = string(sod_line) exclusive-lock:
/*GUI*/ if global-beam-me-up then undo, leave.


            qty = mrp_qty.

            {fcsdate2.i mrp_due_date week}

            if week = 0 then find fcs_sum where fcs_part = mrp_part
               and fcs_site = mrp_site and fcs_year = year(mrp_due_date) - 1
               use-index fcs_partyear no-error.
            else if week = 53 then find fcs_sum where fcs_part = mrp_part
               and fcs_site = mrp_site and fcs_year = year(mrp_due_date) + 1
               use-index fcs_partyear no-error.
            else find fcs_sum where fcs_part = mrp_part
               and fcs_site = mrp_site and fcs_year = year(mrp_due_date)
               use-index fcs_partyear no-error.

            if not available fcs_sum then
            if mrp_qty <> 0 then do:
               create fcs_sum.
               assign fcs_part = mrp_part
                  fcs_site = mrp_site.

               if week = 0 then fcs_year = year(mrp_due_date) - 1.
               else
               if week = 53 then fcs_year = year(mrp_due_date) + 1.
               else fcs_year = year(mrp_due_date).
            end.

            if available fcs_sum then do:

               if week = 53 then week = 1.
               if week = 0 then week = 52.
               fcs_recid = recid(fcs_sum).

               if prev_consume = no then
                  fcs_abnormal[week] = fcs_abnormal[week] - qty.
               else
                  fcs_sold_qty[week] = fcs_sold_qty[week] - qty.

               {inmrp.i &part=mrp_det.mrp_part &site=mrp_det.mrp_site}

               delete mrp_det.
            end.
         end.
/*GUI*/ if global-beam-me-up then undo, leave.

/*F817*/ /* End of added section */

/*F003*/ /* Delete Cost simulation detail */
/*FR31*/ for each sct_det exclusive-lock where sct_part = sod_part
         and sct_sim  = string(sod_nbr) + "." + string(sod_line):
            delete sct_det.
         end.
/*F003*/ /* Delete Cost simulation detail */
