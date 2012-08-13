/* GUI CONVERTED from sosomtf5.p (converter v1.69) Wed Sep 10 15:19:49 1997 */
/* sosomtf5.p - SALES ORDER MAINTENANCE CONFIGURED PRODUCTS             */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.3      LAST MODIFIED: 06/15/94   BY: WUG *GK60*          */
/* REVISION: 7.3      LAST MODIFIED: 07/21/94   BY: WUG *GK86*          */
/* REVISION: 8.5      LAST MODIFIED: 05/28/97   BY: *J1RY* Tim Hinds    */

/*GET COMPONENT LIST FOR A CONFIGURED ITEM.  PHANTOMS ARE BLOWN THRU.*/

/*NOTE: PARENT QTY ALWAYS HAS TO BE ONE FOR THE CALL TO THIS PROGRAM.*/


/*J1RY*/ {mfdeclre.i}

/*J1RY** def input param parent_item as char. */
/*J1RY** def input param parent_qty as dec. */
/*J1RY** def input param parent_scrap_pct as dec. */
/*J1RY** def input param level as int. */
/*J1RY*/define input parameter parent_item as character.
/*J1RY*/define input parameter parent_qty as decimal.
/*J1RY*/define input parameter parent_scrap_pct as decimal.
/*J1RY*/define input parameter level as integer.


/*J1RY   def shared workfile wcomp_list  */
/*J1RY*/define shared workfile wcomp_list
           field wcomp_comp like ps_comp
           field wcomp_component_req_qty as dec
           field wcomp_component_sel_qty as dec
           field wcomp_default like ps_default
           field wcomp_lt_off like ps_lt_off
           field wcomp_mandatory like ps_mandatory
           field wcomp_op like ps_op
           field wcomp_ps_code like ps_ps_code
           field wcomp_ref like ps_ref
           field wcomp_scrp_pct like ps_scrp_pct
/*J1RY*/   field wcomp_cf_lprice  like mfc_logical
/*J1RY*/   field wcomp_cf_lpricev like sod_list_pr
/*J1RY*/   field wcomp_cf_disc    like mfc_logical
/*J1RY*/   field wcomp_cf_discv   like sod_disc_pct
           .

/*J1RY** BEGIN DELETE - change from abbreviation **
* def shared var use_default like ps_default.
* def shared var use_mandatory like ps_mandatory.
* def shared var use_ref like ps_ref.
* def shared var use_lt_off like ps_lt_off.
* def shared var cpex_prefix as char.
* def shared var cpex_ordernbr as char.
* def shared var cpex_orderline as int.
* def shared var cpex_rev_date as date.
* def shared var cpex_order_due_date as date.
* def shared var cpex_site as char.
* def shared var cpex_ex_rate like so_ex_rate.
* def shared var cpex_mfg_lead like ptp_mfg_lead.
**J1RY** END DELETE */
/*J1RY*/ /**BEGIN ADD-BACK **/
        define shared variable use_default like ps_default.
        define shared variable use_mandatory like ps_mandatory.
        define shared variable use_ref like ps_ref.
        define shared variable use_lt_off like ps_lt_off.
        define shared variable cpex_prefix as character.
        define shared variable cpex_ordernbr as character.
        define shared variable cpex_orderline as integer.
        define shared variable cpex_rev_date as date.
        define shared variable cpex_order_due_date as date.
        define shared variable cpex_site as character.
        define shared variable cpex_ex_rate like so_ex_rate.
        define shared variable cpex_mfg_lead like ptp_mfg_lead.
/*J1RY*/ /**END ADD-BACK **/

/*J1RY ** replaced with mfdeclre.i ***
.def shared var global_user_lang_dir as char.
.def shared var mfguser as char.
.*J1RY ** end delete */

/*J1RY** def var component_qty as dec. */
/*J1RY** def var component_scrap_pct as dec. */
        define variable component_qty as decimal.
        define variable component_scrap_pct as decimal.

/*J1RY*/define shared variable cf_config like mfc_logical.
/*J1RY*/define shared variable cf_rm_old_bom like mfc_logical.
/*J1RY*/define shared variable cf_error_bom  like mfc_logical.
/*J1RY*/define variable cf_factor              like mfc_logical.
/*J1RY*/define variable cf_rfact  as integer.

/*J1RY*/if cf_config and cf_rm_old_bom then do:
/*J1RY*/   /*common to both so and sq*/
/*J1RY*/   find first pic_ctrl no-lock no-error.
/*J1RY*/   if cpex_prefix = "qod_det" then do:
/*J1RY*/      if pic_qo_fact then
/*J1RY*/         assign
/*J1RY*/            cf_factor = yes
/*J1RY*/            cf_rfact  = pic_qo_rfact.
/*J1RY*/      else
/*J1RY*/         assign
/*J1RY*/            cf_factor = no
/*J1RY*/            cf_rfact  = pic_qo_rfact + 2.
/*J1RY*/   end. /*if cpex_prefix = "qod_det"*/
/*J1RY*/   else do:
/*J1RY*/      if pic_so_fact then
/*J1RY*/         assign
/*J1RY*/            cf_factor = yes
/*J1RY*/            cf_rfact  = pic_so_rfact.
/*J1RY*/      else
/*J1RY*/         assign
/*J1RY*/            cf_factor = no
/*J1RY*/            cf_rfact = pic_so_rfact + 2.
/*J1RY*/   end.
/*J1RY*/end.


        for each ps_mstr no-lock
        where ps_par = parent_item
        and
        (
           cpex_rev_date = ?
           or
           (
              (
                 ps_start <= cpex_rev_date
                 or
                 ps_start = ?
              )
              and
              (
                 ps_end >= cpex_rev_date
                 or
                 ps_end = ?
              )
           )
        )
        use-index ps_parref:
/*GUI*/ if global-beam-me-up then undo, leave.


           find pt_mstr where pt_part = ps_comp no-lock no-error.

           if level = 0 then do:
              use_default = ps_default.
              use_mandatory = ps_mandatory.
              use_ref = ps_ref.
              use_lt_off = ps_lt_off.
           end.


           component_scrap_pct =
           100 -
           (
              (100 - parent_scrap_pct)
              *
              ((100 - ps_scrp_pct) / 100)
           ).


           if ps_ps_code = "x" or not available pt_mstr then do:
              /*BLOW THRU PHANTOMS*/

              component_qty = parent_qty * ps_qty_per.

              {gprun.i ""sosomtf5.p""
              "(input ps_comp, input component_qty,
              input component_scrap_pct, input level + 1)"}
/*GUI*/ if global-beam-me-up then undo, leave.

           end.

           else
           if ps_ps_code = "" then do:
              /*STANDARD BOM COMPONENTS*/

              component_qty = parent_qty * ps_qty_per.

              create wcomp_list.

              assign
              wcomp_comp = ps_comp
              wcomp_default = use_default
              wcomp_lt_off = use_lt_off
              wcomp_mandatory = use_mandatory
              wcomp_op = ps_op
              wcomp_ps_code = ps_ps_code
              wcomp_ref = use_ref
              wcomp_scrp_pct = component_scrap_pct
              wcomp_component_req_qty = component_qty
              wcomp_component_sel_qty = component_qty
              .
           end.

           else

/*J1RY if ps_ps_code = "o" then do:*/
/*J1RY*/   if ps_ps_code = "o" and not cf_config then do:
/*J1RY optional components will not be added to the bom if the item was */
/*J1RY configured with concinity.                                       */

             /*OPTION COMPONENTS*/

             component_qty = parent_qty * ps_qty_per.

             create wcomp_list.

             assign
             wcomp_comp = ps_comp
             wcomp_default = use_default
             wcomp_lt_off = use_lt_off
             wcomp_mandatory = use_mandatory
             wcomp_op = ps_op
             wcomp_ps_code = ps_ps_code
             wcomp_ref = use_ref
             wcomp_scrp_pct = component_scrap_pct
             wcomp_component_req_qty = component_qty
             .

             if ps_mandatory and ps_default then do:
                wcomp_component_sel_qty = component_qty.
             end.
           end.
        end.
/*GUI*/ if global-beam-me-up then undo, leave.


/*J1RY*/if cf_config and cf_rm_old_bom then do:
/*J1RY*/  cf_error_bom = no.
/*J1RY*/  {gprun.i ""cfgetbom.p"" "(parent_item,
                                    parent_qty,
                                    parent_scrap_pct,
                                    cf_factor,
                                    cf_rfact)"
                                    }
/*GUI*/ if global-beam-me-up then undo, leave.

/*J1RY*/end.
