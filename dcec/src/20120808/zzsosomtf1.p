/* GUI CONVERTED from sosomtf1.p (converter v1.69) Wed Sep 10 15:19:40 1997 */
/* sosomtf1.p - SALES ORDER MAINTENANCE CONFIGURED PRODUCTS             */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.3      LAST MODIFIED: 06/15/94   BY: WUG *GK60*          */
/* REVISION: 7.3      LAST MODIFIED: 07/21/94   BY: WUG *GK86*          */
/* REVISION: 7.4      LAST MODIFIED: 09/15/94   by: slm *GM64*          */
/* REVISION: 7.4      LAST MODIFIED: 12/07/95   by: rxm *H0FS*          */
/* REVISION: 8.5      LAST MODIFIED: 01/09/96   BY: DAH *J0B2*          */
/* REVISION: 7.4      LAST MODIFIED: 01/22/96   by: rxm *G1KC*          */
/* REVISION: 8.5      LAST MODIFIED: 05/28/97   BY: *J1RY* Tim Hinds    */
/* REVISION: 8.5      LAST MODIFIED: 11/14/03   BY: *LB01* Long Bo         */

/*BUILDS DEFAULT CONFIGURATION FOR AN ITEM*/

/*!      *******************************************
         sob_serial subfield positions:
/*G1KC*/  1-4    operation number (old - now 0's)
          5-10    scrap percent
         11-14   id number of this record
         15-15   structure code
         16-16   "y" (indicates "new" format sob_det record (created herein)
         17-34   original qty per parent
         35-35   original mandatory indicator (y/n)
         36-36   original default indicator (y/n)
         37-39   leadtime offset
/*H0FS*/ 40-40   price manually updated (y/n)        /* not used by v8.5 */
/*G1KC*/ 41-46   operation number (new - 6 digits)
         *******************************************/

/*GM64*/ {mfdeclre.i}

         define input param parent_item as character.
         define input param parent_id as character.
         define input param parent_qty as decimal.
         define input param parent_scrap_pct as decimal.

         define shared variable cpex_prefix as character.
         define shared variable cpex_ordernbr as character.
         define shared variable cpex_orderline as integer.
         define shared variable cpex_rev_date as date.
         define shared variable cpex_order_due_date as date.
         define shared variable cpex_site as character.
         define shared variable cpex_ex_rate like so_ex_rate.
         define shared variable cpex_mfg_lead like ptp_mfg_lead.
         define shared variable cpex_last_id as integer.
/*J0B2**
** /*H0FS*/ define shared variable undo_all_config like mfc_logical no-undo.
** /*H0FS*/ define variable work3_recno as recid no-undo.
** /*H0FS*/ define variable sob_recno as recid no-undo.
**J0B2*/

/* GM64  define shared variable global_user_lang_dir as character. */
/* GM64  define shared variable mfguser as character. */

         define new shared workfile wcomp_list
            field wcomp_comp like ps_comp
            field wcomp_component_req_qty as decimal
            field wcomp_component_sel_qty as decimal
            field wcomp_default like ps_default
            field wcomp_lt_off like ps_lt_off
            field wcomp_mandatory like ps_mandatory
            field wcomp_op like ps_op
            field wcomp_ps_code like ps_ps_code
            field wcomp_ref like ps_ref
            field wcomp_scrp_pct like ps_scrp_pct
/*J1RY*/    field wcomp_cf_lprice   like mfc_logical
/*J1RY*/    field wcomp_cf_lpricev like sod_list_pr
/*J1RY*/    field wcomp_cf_disc     like mfc_logical
/*J1RY*/    field wcomp_cf_discv   like sod_disc_pct
         .

         define new shared variable use_lt_off like ps_lt_off.
         define new shared variable use_default like ps_default.
         define new shared variable use_mandatory like ps_mandatory.
         define new shared variable use_ref like ps_ref.

         {mfdatev.i}

         define variable component_qty as decimal.
         define variable from_date as date.
         define variable due_date as date.
         define variable new_parent_id as character.
         define variable temp_id as integer.
         define variable pm_code as character.
         define variable selected_qty as decimal.
         define variable required_qty as decimal.

/*J1RY*/ define shared variable cf_config like mfc_logical.
/*J1RY*/ define shared variable cf_um     like sod_um.
/*J1RY*/ define shared variable cf_error_bom like mfc_logical.
/*J1RY*/ define shared variable cf_um_conv   like sod_um_conv.

         if parent_qty = 0 then leave.

         pm_code = "".
         find pt_mstr where pt_part = parent_item no-lock no-error.

         if available pt_mstr then do:
            pm_code = pt_pm_code.
         end.

         find ptp_det where ptp_part = parent_item and ptp_site = cpex_site
         no-lock no-error.

         if available ptp_det then do:
            pm_code = ptp_pm_code.
         end.

         if pm_code <> "c" then leave.

         /*GET COMPONENT LIST FOR THE ITEM*/
/*LB01*/ {gprun.i ""zzsosomtf5.p"" "(input parent_item, input 1,
          input parent_scrap_pct, input 0)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*J1RY*/ if cf_config and cf_error_bom then leave .

         /*PROCESS COMPONENT LIST*/
         for each wcomp_list no-lock
         break by wcomp_ref by wcomp_comp by wcomp_lt_off descending:
/*GUI*/ if global-beam-me-up then undo, leave.

         /*WE USE WCOMP_LT_OFF IN THE SORT BECAUSE WHEN WE
         HIT THE "LAST-OF" IT WILL BE AT ITS SMALLEST VALUE*/

            accumulate wcomp_component_req_qty (sub-total by wcomp_comp).
            accumulate wcomp_component_sel_qty (sub-total by wcomp_comp).

            if last-of(wcomp_comp)
            and
            (accum sub-total by wcomp_comp wcomp_component_sel_qty)
            * parent_qty <> 0 then do:
               due_date = ?.
               from_date = cpex_order_due_date.
               if cpex_order_due_date = ? then from_date = today.
               {mfdate.i due_date from_date "cpex_mfg_lead - wcomp_lt_off"
               cpex_site}


               cpex_last_id = cpex_last_id + 1.
               new_parent_id = string(cpex_last_id,"9999").


               /*******************************************
               sob_serial subfield positions:
/*G1KC*/        1-4    operation number (old - now 0's)
                5-10   scrap percent
               11-14   id number of this record
               15-15   structure code
               16-16   "y" (indicates "new" format sob_det record (created here)
               17-34   original qty per parent
               35-35   original mandatory indicator (y/n)
               36-36   original default indicator (y/n)
               37-39   leadtime offset
/*H0FS*/       40-40   price manually updated (y/n)  /* not used in v8.5 */
/*G1KC*/       41-46   operation number (new - 6 digits)
               *******************************************/

               required_qty =
                  (accum sub-total by wcomp_comp wcomp_component_req_qty)
                     * parent_qty.
               selected_qty =
                  (accum sub-total by wcomp_comp wcomp_component_sel_qty)
                     * parent_qty.

               create sob_det.

               assign
                  sob_nbr = cpex_prefix + cpex_ordernbr
                  sob_line = cpex_orderline
                  sob_parent = parent_id
                  sob_feature = wcomp_ref
                  sob_part = wcomp_comp
/*G1KC                  sob_serial = string(wcomp_op,"9999") */
/*G1KC*/          sob_serial = string(0,"9999")
                     + string(wcomp_scrp_pct,"999.99")
                     + new_parent_id + string(wcomp_ps_code,"x(1)") + "y"
                     + string(required_qty,"-9999999.999999999")
                     + string(wcomp_mandatory,"y/n")
                     + string(wcomp_default,"y/n")
                     + string(wcomp_lt_off,"-99")
/*G1KC*/             + "n"
/*G1KC*/             + string(wcomp_op,"999999")
                  sob_iss_date = due_date
                  sob_site = cpex_site
                  sob_qty_req = selected_qty.

/*GM64*/       recno = recid(sob_det).
/*J0B2** /*H0FS*/       sob_recno = recno. */

/*J1RY*/          /* Configurator Pricing ? */
/*J1RY*/          if cf_config then do:
/*J1RY*/             /* Has Component Got a Configurator List Price */
/*J1RY*/             if wcomp_cf_lprice then do:
/*J1RY*/                /* Create a Manual Pricing Record for the Component*/
/*LB01**J1RY*/                {gprun.i ""zzgppiwkad.p""
                           "(cf_um,
                           parent_id,
                           wcomp_ref,
                           wcomp_comp,
                           ""1"",
                           ""1"",
                           wcomp_cf_lpricev * cf_um_conv * cpex_ex_rate,
                           0,
                           no)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J1RY*/                sob_tot_std = wcomp_cf_lpricev * cf_um_conv *
/*J1RY*/                              cpex_ex_rate.
/*J1RY*/             end.
/*J1RY*/             /* Has Component Got a Configurator Discount % */
/*J1RY*/             if wcomp_cf_disc then do:
/*J1RY*/                /* Create a Manual Pricing Record for the Component*/
/*LB01**J1RY*/                {gprun.i ""zzgppiwkad.p"" "(cf_um,
                                                  parent_id,
                                                  wcomp_ref,
                                                  wcomp_comp,
                                                  ""1"",
                                                  ""2"",
                                                  0,
                                                  wcomp_cf_discv,
                                                  no)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J1RY*/             end.
/*J1RY*/          end.

               find pt_mstr where pt_part = wcomp_comp no-lock no-error.

               if available pt_mstr then do:
                  sob_loc = pt_loc.
                  if wcomp_ps_code = "o" then do:
/*J1RY*/             if not wcomp_cf_lprice then
                     sob_tot_std = pt_price * cpex_ex_rate.
/*J1RY*/             if not wcomp_cf_disc then
                     sob_price = sob_tot_std.
/*J1RY*/             else sob_price =
/*J1RY*/             ((100 - wcomp_cf_discv) / 100) * sob_tot_std.

/*J0B2**
** /*H0FS*/             work3_recno = ?.
** /*H0FS*/             {gprun.i ""gppccala.p"" "(input sob_part,
**                                               input work3_recno,
**                                               input sob_recno)"}
** /*H0FS*/             if keyfunction(lastkey) = "END-ERROR" then do:
** /*H0FS*/                undo_all_config = yes.
** /*H0FS*/                undo, leave.
** /*H0FS*/             end.
**J0B2*/
                  end.
               end.


               /*EXPLODE SUBCONFIGURATIONS*/
               {gprun.i ""zzsosomtf1.p"" "(input wcomp_comp, input new_parent_id,
                input selected_qty, input wcomp_scrp_pct)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            end.
         end.
/*GUI*/ if global-beam-me-up then undo, leave.

