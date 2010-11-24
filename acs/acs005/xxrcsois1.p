/* xxrcsois1.p - Customer Schedules Confirm Shipper                          */
/* REVISION: 1.0      LAST MODIFIED: 09/25/10   BY: zy                       */
/*-Revision end--------------------------------------------------------------*/

{mfdeclre.i}
{cxcustom.i "XXRCSOIS1.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{gldydef.i new}
{gldynrm.i new}

{apconsdf.i}   /* PRE-PROCESSOR CONSTANTS FOR LOGISTICS ACCOUNTING */

/* NEW SHARED VARIABLES, BUFFERS AND FRAMES */
define new shared variable rndmthd        like rnd_rnd_mthd.
define new shared variable abs_carr_ref     as character.
define new shared variable abs_fob        like so_fob.
define new shared variable abs_recid        as recid.
define new shared variable abs_shipvia    like so_shipvia.
define new shared variable accum_wip      like tr_gl_amt.
define new shared variable already_posted like glt_amt.
define new shared variable auto_post      like mfc_logical label "Post Invoice".
define new shared variable base_amt       like ar_amt.
define new shared variable batch          like ar_batch.
define new shared variable batch_tot      like glt_amt.
define new shared variable bill           like so_bill.
define new shared variable bill1          like so_bill.
define new shared variable change_db      like mfc_logical.
define new shared variable consolidate    like mfc_logical
   label "Consolidate Invoices".
define new shared variable cr_acct        like trgl_cr_acct.
define new shared variable cr_sub         like trgl_cr_sub.
define new shared variable cr_amt           as decimal
   format "->>>,>>>,>>>.99" label "Credit Amount".
define new shared variable cr_cc          like trgl_cr_cc.
define new shared variable cr_proj        like trgl_cr_proj.
define new shared variable curr_amt       like glt_amt.
define new shared variable cust           like so_cust.
define new shared variable cust1          like so_cust.
define new shared variable desc1          like pt_desc1 format "x(49)".
define new shared variable dr_acct        like trgl_dr_acct.
define new shared variable dr_sub         like trgl_dr_sub.
define new shared variable dr_amt           as decimal
   format "->>>,>>>,>>>.99" label "Debit Amount".
define new shared variable dr_cc          like trgl_dr_cc.
define new shared variable eff_date       like glt_effdate label "Effective".
define new shared variable exch_rate      like exr_rate.
define new shared variable exch_rate2     like exr_rate2.
define new shared variable exch_ratetype  like exr_ratetype.
define new shared variable exch_exru_seq  like exru_seq.
define new shared variable ext_cost       like sod_price.
define new shared variable ext_disc         as decimal decimals 2.
define new shared variable gr_margin      like sod_price
   label "Unit Margin" format "->>>>,>>9.99".
define new shared variable ext_gr_margin  like gr_margin label "Ext Margin".
define new shared variable base_margin    like ext_gr_margin.
define new shared variable ext_list       like sod_list_pr decimals 2.
define new shared variable ext_price        as decimal
   label "Ext Price" decimals 2 format "->>>>,>>>,>>9.99".
define new shared variable base_price     like ext_price.
define new shared variable freight_ok     like mfc_logical.
define new shared variable gl_amt         like sod_fr_chg.
define new shared variable gl_sum         like mfc_logical
   format "Consolidated/Detail" initial yes.
define new shared variable inv            like ar_nbr label "Invoice".
define new shared variable inv1           like ar_nbr label {t001.i}.
define new shared variable inv_only       like mfc_logical initial yes.
define new shared variable loc like pt_loc.
define new shared variable lotserial_total like tr_qty_chg.
define new shared variable name           like ad_name.
define new shared variable nbr like tr_nbr.
define new shared variable net_price      like sod_price.
define new shared variable net_list       like sod_list_pr.
define new shared variable old_ft_type      as character.
define new shared variable ord-db-cmtype  like cm_type no-undo.
define new shared variable order_ct         as integer.
define new shared variable order_nbrs       as character extent 30.
define new shared variable order_nbr_list   as character no-undo.
define new shared variable part             as character format "x(18)".
define new shared variable post           like mfc_logical.
define new shared variable post_entity    like ar_entity.
define new shared variable print_lotserials like mfc_logical
   label "Print Lot/Serial Numbers Shipped".
define new shared variable project        like wo_project.
define new shared variable que-doc          as logical.
define new shared variable qty              as decimal.
define new shared variable qty_all        like sod_qty_all.
define new shared variable qty_pick       like sod_qty_pick.
define new shared variable qty_bo         like sod_bo_chg.
define new shared variable qty_chg        like sod_qty_chg.
define new shared variable qty_cum_ship   like sod_qty_ship.
define new shared variable qty_inv        like sod_qty_inv.
define new shared variable qty_iss_rcv    like tr_qty_loc.
define new shared variable qty_left       like tr_qty_chg.
define new shared variable qty_open       like sod_qty_ord.
define new shared variable qty_ord        like sod_qty_ord.
define new shared variable qty_req        like in_qty_req.
define new shared variable qty_ship       like sod_qty_ship.
define new shared variable ref            like glt_ref.
define new shared variable rejected       like mfc_logical no-undo.
define new shared variable rmks           like tr_rmks.
define new shared variable sct_recid        as recid.
define new shared variable sct_recno        as recid.
define new shared variable ship_db        like global_db.
define new shared variable ship_dt        like so_ship_date.
define new shared variable ship_line      like sod_line.
define new shared variable ship_site        as character.
define new shared variable ship_so        like so_nbr.
define new shared variable should_be_posted like glt_amt.
define new shared variable so_db          like global_db.
define new shared variable so_job         like tr_so_job.
define new shared variable so_hist        like soc_so_hist.
define new shared variable so_mstr_recid    as recid.
define new shared variable so_recno         as recid.
define new shared variable sod_entity     like en_entity.
define new shared variable sod_recno        as recid.
define new shared variable std_cost       like sod_std_cost.
define new shared variable tax_recno        as recid.
define new shared variable tot_curr_amt   like glt_amt.
define new shared variable tot_ext_cost   like sod_price.
define new shared variable tot_line_disc    as decimal decimals 2.
define new shared variable tr_recno         as recid.
define new shared variable transtype        as character format "x(7)".
define new shared variable trgl_recno       as recid.
define new shared variable trlot          like tr_lot.
define new shared variable trqty          like tr_qty_chg.
define new shared variable unit_cost      like tr_price label "Unit Cost".
define new shared variable undo_all       like mfc_logical no-undo.
define new shared variable use_shipper    like mfc_logical
   label "Use Shipper Nbr for Inv Nbr".
define new shared variable wip_entity     like si_entity.
define new shared workfile work_sr_wkfl   like sr_wkfl.
define new shared variable yn             like mfc_logical.
define new shared variable critical-part  like wod_part    no-undo.
define new shared variable prog_name        as character
   initial "rcsois.p" no-undo.
define new shared variable auto_inv       like mfc_logical
   label "Print Invoice".
define new shared variable l_undo         like mfc_logical no-undo.
{&RCSOIS1-P-TAG18}

/* SHARED VARIABLES, BUFFERS AND FRAMES */
define shared variable confirm_mode like mfc_logical       no-undo.
define shared variable global_recid as recid.

/* LOCAL VARIABLES, BUFFERS AND FRAMES */
define variable abs_trans_mode    as   character     no-undo.
define variable abs_veh_ref       as   character     no-undo.
define variable disp_abs_id       like abs_mstr.abs_id no-undo.
define variable first_so_bill     like so_bill       no-undo.
define variable first_so_cust     like so_cust       no-undo.
define variable first_so_curr     like so_curr       no-undo.
define variable first_so_cr_terms like so_cr_terms   no-undo.
define variable first_so_slspsn   like so_slspsn     no-undo.
define variable first_so_trl1_cd  like so_trl1_cd    no-undo.
define variable first_so_trl2_cd  like so_trl2_cd    no-undo.
define variable first_so_trl3_cd  like so_trl3_cd    no-undo.
define variable first_so_entity   like si_entity     no-undo.
define variable msg_text          as   character     no-undo.
define variable shipqty           as   decimal       no-undo.
define variable txcalcref         as   character     no-undo.
define variable conf_type         as   logical
   format "Pre-Shipper/Shipper"        initial true  no-undo.
define variable l_first_so_nbr    like so_nbr        no-undo.
define variable l_consolidate_ok  as   logical       no-undo.
define variable oldcurr           like so_curr       no-undo.
define variable id_length         as   integer       no-undo.
define variable shipgrp           like sg_grp        no-undo.
define variable shipnbr           like abs_mstr.abs_id no-undo.
define variable nrseq             like shc_ship_nr_id  no-undo.
define variable errorst           as   logical       no-undo.
define variable errornum          as   integer       no-undo.
define variable is_valid          as   logical       no-undo.
define variable is_internal       as   logical       no-undo.
define variable l_invprint        as   logical       no-undo.
define variable l_invpost         as   logical       no-undo.
{&RCSOIS1-P-TAG9}

define buffer abs_temp for abs_mstr.

define variable l_disc_pct1       as   decimal       no-undo.
define variable l_net_price       as   decimal       no-undo.
define variable l_list_price      as   decimal       no-undo.
define variable l_rec_no          as   recid         no-undo.
define variable change-queued     as   logical       no-undo.
define variable l_flag            like mfc_logical   no-undo.
define variable undo_stat         like mfc_logical   no-undo.
define variable l_tr_type         like tx2d_tr_type  initial "13" no-undo.
define variable l_nbr             like tx2d_nbr      initial ""   no-undo.
define variable l_line            like tx2d_line     initial 0    no-undo.
define variable l_calc_freight    like mfc_logical   initial yes
   label "Calculate Freight"                         no-undo.
define variable errorNbr          as   integer       no-undo.
define variable vSOToHold         like so_nbr        no-undo.
define variable creditCardOrder   as   logical       no-undo.
define variable l_undoflg         like mfc_logical   no-undo.
define variable l_flag1           like mfc_logical   no-undo.
define variable use-log-acctg     as   logical       no-undo.
define variable first_so_site     like so_site       no-undo.
define variable first_so_ex_rate  like so_ex_rate    no-undo.
define variable first_so_ex_rate2 like so_ex_rate2   no-undo.
define variable first_so_exru_seq like so_exru_seq   no-undo.
define variable lv_error_num      as integer         no-undo.
define variable lv_name           as character       no-undo.
define variable l_wo_reject       like mfc_logical   no-undo.

define variable tot_freight_gl_amt    like sod_fr_chg. /* NOT NO-UNDO */
define variable l_auto_noupdate   like mfc_logical   no-undo initial no.

define new shared temp-table work_ldd no-undo
   field work_ldd_id like abs_id
   index work_ldd_id work_ldd_id.

define variable l_consigned_line_item like mfc_logical      no-undo.

/* CUSTOMIZED SECTION FOR VERTEX BEGIN */
define variable l_cont          like mfc_logical initial no no-undo.
define variable l_api_handle      as handle                 no-undo.
define variable l_vq_reg_db_open  as logical     initial no no-undo.
/* CUSTOMIZED SECTION FOR VERTEX END */

define temp-table tt_consign_rec no-undo
   field tt_consign_order   like so_nbr
   field tt_consign_line    like sod_line
   field tt_consign_qty_chg like sod_qty_chg
   index tt_consign_rec_idx tt_consign_order tt_consign_line.

define variable msgnbr         as integer no-undo.
define variable dummy-length   as character format "999:99" no-undo.
define variable shp_time       as character format "xx:xx"  no-undo.
define variable arr_date     like abs_arr_date              no-undo.
define variable arr_time       as character format "xx:xx"  no-undo.
define variable l_so_to_inv    like so_to_inv               no-undo.

define variable return_status  as   integer                 no-undo.

define temp-table tt_sod_det no-undo
   field tt_sod_nbr  like sod_nbr
   field tt_sod_line like sod_line
   field tt_pr_found as logical
   index i_sodnbr tt_sod_nbr.

define temp-table tt_so_mstr no-undo
   field tt_so_nbr       like so_nbr
   field tt_so_to_inv    like so_to_inv
   field tt_so_invoiced  like so_invoiced
   field tt_so_ship_date like so_ship_date
   field tt_so_tax_date  like so_tax_date
   field tt_so_bol       like so_bol
   field tt_so__qadc01   like so__qadc01
   index i_sonbr tt_so_nbr.

define temp-table tt_somstr no-undo
   field tt_sonbr   like so_nbr
   field tt_sotoinv like mfc_logical initial no
   index sonbr is primary unique
   tt_sonbr.

/*zy*/ /*define variable solst record so_list in abs_mstr*/
/*zy*/ define variable solst as character no-undo.

define stream abs.

{&RCSOIS1-P-TAG14}

/* EURO TOOL KIT DEFINITIONS */
{etvar.i &new="new"}
{etdcrvar.i "new"}
{etrpvar.i &new="new"}
{etsotrla.i "new"}

{fsdeclr.i new}

{gpglefdf.i}
{txcalvar.i}
{rcwabsdf.i new}
{gpfilev.i}   /* VARIABLE DEFINITIONS FOR gpfile.i */

/* CONSIGNMENT VARIABLES */
{socnvars.i}
{pxsevcon.i}

/* FREIGHT ACCRUAL TEMP TABLE DEFINITION */
{lafrttmp.i "new"}

{gprunpdf.i "gpccpl" "p"}
{&RCSOIS1-P-TAG15}
form
   abs_mstr.abs_shipfrom colon 35 label "Ship-From"
   si_desc               at 47    no-label
   conf_type             colon 35 label "Pre-Shipper/Shipper"
   abs_mstr.abs_id       colon 35 label "Number"
   skip(1)
   abs_mstr.abs_shipto   colon 35 label "Ship-To/Dock"
   ad_name               at 47    no-label
   ad_line1              at 47    no-label
   ship_dt               colon 35
   eff_date              colon 35
with frame a side-labels width 80 attr-space.
{&RCSOIS1-P-TAG16}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   abs_veh_ref colon 35 label "Vehicle ID"    format "x(20)"
   shp_time    colon 35 label "Shipping Time"
   arr_date    colon 35 label "Arrive Date"
   arr_time    colon 35 label "Arrival Time"
with frame ab side-labels width 80 attr-space.

setFrameLabels(frame ab:handle).
/* "Print Invoice " WILL NOW APPEAR IN THE FRAME BELOW AND WILL NO  */
/* LONGER APPEAR AFTER THE PROMPT "Is all the information correct"  */
form
   auto_inv              colon 35
   {&RCSOIS1-P-TAG10}
   auto_post             colon 35
   use_shipper           colon 35
   consolidate           colon 35
   l_calc_freight        colon 35
   {&RCSOIS1-P-TAG19}
with frame b side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

form
   space(1)
   shipnbr label "Shipper Number"
with frame convfrm centered side-labels attr-space
title color normal (getFrameTitle("CONVERT_PRE-SHIPPER_TO_SHIPPER",42))
overlay width 45.

/* SET EXTERNAL LABELS */
setFrameLabels(frame convfrm:handle).

run getControlFiles
   (buffer gl_ctrl,
    buffer shc_ctrl,
    input enable_customer_consignment,
    input adg,
    input cust_consign_ctrl_table,
    output use-log-acctg,
    output using_cust_consignment,
    output auto_post,
    output use_shipper,
    output consolidate).

{cclc.i} /*CHECK FOR ENABLEMENT OF CONTAINER AND LINE CHARGES*/

for first abs_mstr
   fields( abs_domain abs_canceled abs_eff_date abs_format abs_id
           abs_inv_mov abs_nr_id abs_preship_id abs_preship_nr_id
           abs_shipfrom abs_shipto abs_shp_date abs_status
           abs_type abs__qad01 abs__qad05)
   where recid(abs_mstr) = global_recid
   no-lock:
end.

if available abs_mstr
   and abs_type = "S"
   and (abs_id begins "P"
    or  abs_id begins "S")
then do:

   for first si_mstr
      fields( si_domain si_db si_desc si_entity si_site)
       where si_mstr.si_domain = global_domain and si_site = abs_shipfrom
   no-lock:
   end.

   conf_type = abs_id begins "p".

   display
      abs_shipfrom
      si_desc {&RCSOIS1-P-TAG23}
      conf_type
      substring(abs_id,2,50) @ abs_id
   with frame a.

end.

assign
   ship_dt  = today
   eff_date = if confirm_mode
                 or not available abs_mstr
              then
                 today
              else
                 abs_eff_date
   oldcurr  = "".

display
   ship_dt
   eff_date
   conf_type
with frame a.

mainloop:
repeat:

assign solst = "".
   /* INITIALIZE work_ldd */
   run p_InitializeTempTableWorkLdd.

   /* Inserting a block so that orders can be placed on hold      */
   /* if the credit card validations fail even if the user enters */
   /* F4 or answers no to "Is all information correct?".          */
   CK-CC-HOLD:
   do on error undo CK-CC-HOLD, leave CK-CC-HOLD:

      assign
         vSOToHold = ""
         oldcurr   = "".

      run del-qad-wkfl.

      do with frame a:

         prompt-for
            abs_shipfrom
            conf_type
            abs_id
         editing:

            global_site = input abs_shipfrom.

            if frame-field = "abs_shipfrom"
            then do:
               /* ADDED () AROUND THE or STATEMENT */
               {mfnp05.i abs_mstr abs_id
                  " abs_mstr.abs_domain = global_domain
                  and (abs_id  begins 's'
                  or   abs_id  begins 'p')"
                  abs_shipfrom
                  "input abs_shipfrom"}

               if recno <> ?
               then do:

                  for first si_mstr
                     fields( si_domain si_db si_desc si_entity si_site)
                      where si_mstr.si_domain = global_domain
                       and  si_site = abs_shipfrom
                  no-lock:
                  end.

                  assign
                     global_site = abs_shipfrom
                     global_lot  = abs_id
                     conf_type   = abs_id begins "p"
                     disp_abs_id = substring(abs_id,2,50).

                  display
                     abs_shipfrom
                     si_desc  when (available si_mstr)
                     ""       when (not available si_mstr) @ si_desc
                     conf_type
                     disp_abs_id @ abs_id.

               end. /* if recno <> ? */

            end. /* if frame-field "abs_shipfrom" */

            else if frame-field = "abs_id"
            then do:

               /* HANDLE SHIPPERS */
               if not input conf_type
               then do:

                  {mfnp05.i abs_mstr abs_id
                     "abs_mstr.abs_domain = global_domain
                      and abs_shipfrom  = input abs_shipfrom
                      and abs_id begins ""s""
                      and abs_type    = ""s"""
                          abs_id " ""s"" + input abs_id"}
               end. /* if not input conf_type */

               else do:
                  {mfnp05.i abs_mstr abs_id
                     "abs_mstr.abs_domain = global_domain
                      and abs_shipfrom  = input abs_shipfrom
                      and abs_id begins
                      ""p"" " abs_id " ""p"" + input abs_id"}

               end. /* else */

               if recno <> ?
               then do:

                  for first si_mstr
                     fields( si_domain si_db si_desc si_entity si_site)
                      where si_mstr.si_domain = global_domain
                       and  si_site = abs_shipfrom
                  no-lock:
                  end.

                  assign
                     global_site = abs_shipfrom
                     global_lot  = abs_id
                     conf_type   = abs_id begins "p"
                     disp_abs_id = substring(abs_id,2,50).

                  display
                     abs_shipfrom
                     si_desc  when (available si_mstr)
                     ""       when (not available si_mstr) @ si_desc
                     conf_type
                     disp_abs_id @ abs_id.

               end. /* if recno <> ? */

            end. /* if frame-field = "abs_id" */

            else do:
               status input.
               readkey.
               apply lastkey.
            end.

         end. /* prompt-for */

      end. /* do with frame a */

      assign
         so_db = global_db.

      for first si_mstr
         fields( si_domain si_db si_desc si_entity si_site)
          where si_mstr.si_domain = global_domain
           and  si_site = input abs_shipfrom
      no-lock:
      end.

      if not available si_mstr
      then do:

         /* Site does not exist */
         run DisplayMessage (input 708,
                             input 3,
                             input '').
         next-prompt abs_shipfrom with frame a.
         undo, retry.
      end.

      display
         si_desc
      with frame a.

      if global_db <> si_db then do:
         {gprunp.i "mgdompl" "p" "ppDomainConnect"
                                  "(input  si_db,
                                    output lv_error_num,
                                    output lv_name)"}

         /* Making sure domain is connected */
         if lv_error_num <> 0
         then do:

            /* Domain # is not available */
            run DisplayMessage (input lv_error_num,
                                input 3,
                                input lv_name).
            next-prompt abs_shipfrom with frame a.
            undo, retry.
         end.
      end. /* if global_db <> si_db then do: */

      assign
         ship_db   = si_db
         change_db = ship_db <> global_db.

      for first abs_mstr
         fields( abs_domain abs_canceled abs_eff_date abs_format abs_id
                 abs_inv_mov abs_nr_id abs_preship_id abs_preship_nr_id
                 abs_shipfrom abs_shipto abs_shp_date abs_status
                 abs_type abs__qad01 abs__qad05)
          where abs_mstr.abs_domain = global_domain
           and abs_shipfrom = input abs_shipfrom
           and abs_id       = (if input conf_type
                               then
                                  "P"
                               else
                                  "S")
                             + input abs_id
           and abs_type     = "S"
         no-lock:
      end.

      if not available abs_mstr
      then do:

         /* Picklist/Shipper does not exist */
         run DisplayMessage (input 8145,
                             input 3,
                             input '').
         next-prompt abs_id with frame a.
         undo, retry.
      end.

      {gprun.i ""gpsiver.p""
         "(input (input abs_shipfrom), input ?, output return_int)"}

      if return_int = 0
      then do:

         /* User does not have access to site */
         run DisplayMessage (input 725,
                             input 3,
                             input '').
         undo, retry.
      end.

      /* Changed "authorized" to "l_flag" below */
      {gprun.i ""gpsimver.p""
         "(input abs_shipfrom,
           input abs_inv_mov,
           output l_flag)"}.
      if not l_flag
      then do:

         /* USER DOES NOT HAVE ACCESS TO THIS SITE/INVENTORY MOVEMENT CODE */
         run DisplayMessage (input 5990,
                             input 4,
                             input '').
         undo, retry.
      end.

      if abs_canceled
      then do:

         /* SHIPPER CANCELED */
         run DisplayMessage (input 5885,
                             input 3,
                             input '').
         undo, retry.
      end.

      if (substring(abs_status,2,1) = "y") = confirm_mode
      then do:

         if confirm_mode
         then
            /* Shipper previously confirmed */
            run DisplayMessage (input 8146,
                                input 3,
                                input '').
         else
            /* Shipper previously not confirmed */
            run DisplayMessage (input 8140,
                                input 3,
                                input '').
         undo, retry.
      end.

      {&RCSOIS1-P-TAG1}

      if abs_inv_mov <> ""
         and not can-find(first im_mstr
         where im_mstr.im_domain = global_domain
         and   im_inv_mov = abs_inv_mov
         and   im_tr_type = "ISS-SO")
      then do:

         {&RCSOIS1-P-TAG2}
         /* Not a Sales Order Shipper */
         run DisplayMessage (input 5802,
                             input 3,
                             input '').
         undo, retry.
      end.  /* if abs_inv_mov */

      if not confirm_mode
      then do:

         yn = no.

         /* Continue with Unconfirm ? */
         run DisplayMessage1(input 5987,
                             input 1,
                             input-output yn).

         if not yn
         then
            undo CK-CC-HOLD, leave CK-CC-HOLD.

         assign
            eff_date = abs_eff_date
            ship_dt  = abs_shp_date.

         display
            eff_date
            ship_dt
         with frame a.

      end.

      /* CHECK AND ASSIGN CORRECT SHIP-TO TO ABS_SHIPTO IF */
      /* IT CONTAINS A SESSION ID THAT IS ASSIGNED DUE TO  */
      /* ABNORMAL TERMINATION                              */

      if abs_shipto     <> abs__qad05
         and abs__qad05 <> ""
      then
         run chk_shipto_prefix(input abs_shipfrom,
                               input abs_id).


      /* Get length of shipper # */
      if abs_id begins "P"
      then do:

         {gprun.i ""gpgetgrp.p""
            "(input  abs_shipfrom,
              input  abs_shipto,
              output shipgrp)"}

         nrseq = shc_ship_nr_id.

         if shipgrp <> ?
         then
            for first sgid_det
               fields( sgid_domain sgid_grp sgid_inv_mov sgid_ship_nr_id)
                where sgid_det.sgid_domain = global_domain
                 and  sgid_grp = shipgrp
                 and  sgid_inv_mov = abs_inv_mov
            no-lock:
               nrseq = sgid_ship_nr_id.
            end.

         run get_nr_length
            (input nrseq,
             output id_length,
             output errorst,
             output errornum).
         if errorst
         then do:

            run DisplayMessage (input errornum,
                                input 3,
                                input '').
            undo, retry.
         end.

      end. /* if abs_id begins "p" */

      else
         id_length = length(substring(abs_id,2)).

      /* Since invoice# can be 8 char or less, we cannot process this */
      /* preshipper to create a combined shipper-invoice              */
      if abs_id begins "P"
         and can-find (first df_mstr
         where df_mstr.df_domain = global_domain
         and df_type = "1"
         and df_format = abs_format
         and df_inv)
         and id_length > 8
      then do:

         /* INVALID DOCUMENT FORMAT, CANNOT ASSIGN SHIPPER NUMBER */
         run DisplayMessage (input 5887,
                             input 4,
                             input '').
         undo, retry.
      end. /* if abs_id begins "p" */

      if confirm_mode
         and substring(abs_status,1,1) <> "y"
      then
         /* Shipper not printed */
         run DisplayMessage (input 8147,
                             input 2,
                             input '').

      /* ASSIGN global_recid FOR USE IN THE TAX CALCULATION ROUTINE */
      assign
         abs_recid    = recid(abs_mstr)
         global_recid = abs_recid.

      for each work_abs_mstr
         exclusive-lock:
         delete work_abs_mstr.
      end.

      empty temp-table tt_so_mstr.

      /* EXPLODE SHIPPER TO GET ORDER DETAIL */
      {gprun.i ""rcsoisa.p"" "(input recid(abs_mstr))"}

      /* ADDED THE BLOCK TO CHECK WHETHER THE SALES ORDER IS */
      /* ATTACHED TO THE SHIPPER LINE ITEM. IF THE SO IS NOT */
      /* ATTACHED, THE SHIPPER WILL NOT GET CONFIRMED AND    */
      /* THE DETAILS WILL BE PRINTED IN 'shipper.err' FILE  */
      if can-find(first work_abs_mstr
                     where (work_abs_mstr.abs_id begins "ic"
                            or work_abs_mstr.abs_id begins "is")
                     and work_abs_mstr.abs_order = ""
                     and work_abs_mstr.abs_line  = "")
      then do:
         run abs_audit.
         undo, retry.
      end. /* IF CAN-FIND ... */

      /* ADD CONSIGNMENT DATA TO work_abs_mstr */
      if using_cust_consignment
      then do:

         if change_db
         then do:

            run ip_alias
               (input ship_db,
                output l_flag).

            if l_flag
            then
               undo CK-CC-HOLD, leave CK-CC-HOLD.

         end. /* IF change_db */

         {gprunmo.i &module = "ACN" &program = "rcsoisa2.p"}

         /* SWITCH BACK TO SALES ORDER DOMAIN IF NECESSARY */
         if change_db
         then do:

            run ip_alias
               (input so_db,
                output l_flag).

            if l_flag
            then
               undo CK-CC-HOLD, leave CK-CC-HOLD.

         end. /* IF change_db */

      end.  /* if using_cust_consignment */

      /* USE THE qad_wkfl TO KEEP TRACK OF THE SALES ORDERS BEING     */
      /* CONFIRMED SO THAT SHIPPERS RELATED TO THE SAME ORDER ARE NOT */
      /* SIMULTANEOUSLY CONFIRMED.                                    */
      do transaction:
         run p-qadwkfl.
         if l_undoflg = yes
         then
            undo CK-CC-HOLD, leave CK-CC-HOLD.
      end.  /* DO TRANSACTION */

      l_undoflg = no.

      /* EXIT IF THERE IS ANY PENDING CHANGE FOR EMT ORDER */
      que-doc = no.

      for each work_abs_mstr
         where abs_order > ""
         no-lock
      break by work_abs_mstr.abs_order
      on endkey undo CK-CC-HOLD, leave CK-CC-HOLD:

         if first-of (work_abs_mstr.abs_order)
         then do:

            assign l_wo_reject = no
                   l_undoflg   = no.

            run CheckWOAndCMF (input work_abs_mstr.abs_order,
                              input work_abs_mstr.abs_line,
                              output l_wo_reject,
                              output l_undoflg,
                              input-output que-doc) no-error.

            if l_wo_reject = yes
            then
               undo mainloop, retry mainloop.

            if l_undoflg = yes
            then
               undo, retry.

         end. /* if first-of(abs_order) */

      end. /* for each work_abs_mstr */

      assign
         shp_time = substring(string(abs_shp_time,"hh:mm"),1,2)
                  + substring(string(abs_shp_time,"hh:mm"),4,2)
         arr_date = abs_arr_date
         arr_time = substring( string(abs_arr_time,"hh:mm"),1,2)
                  + substring( string(abs_arr_time,"hh:mm"),4,2)
         abs_shipvia    = substring(abs__qad01,1,20)
         abs_fob        = substring(abs__qad01,21,20)
         abs_carr_ref   = substring(abs__qad01,41,20)
         abs_trans_mode = substring(abs__qad01,61,20)
         abs_veh_ref    = substring(abs__qad01,81,20).

      /* REPLACED PARAMETER auto_post FROM OUTPUT TO INPUT-OUTPUT */
      /* FOR DISPLAYING THE CORRECT FLAG SETTING AS PER CONTROL FILE */

      run find_auto_post (input-output auto_post).

      for first ad_mstr
         fields( ad_domain ad_addr ad_line1 ad_name)
          where ad_mstr.ad_domain = global_domain
           and  ad_addr = abs_mstr.abs_shipto
      no-lock: end.

      display
         si_desc
         abs_mstr.abs_shipto
         ad_name
         ad_line1
      with frame a.

      if confirm_mode
      then
         update
            ship_dt
            eff_date
         with frame a.
      {&RCSOIS1-P-TAG17}

      /* VERIFY OPEN GL PERIOD FOR LINE ITEM SITE/ENTITY, */
      /* NOT PRIMARY ENTITY                               */
      run p_glcalval
         (output l_flag).
      if l_flag
      then do:

         next-prompt abs_mstr.abs_shipfrom with frame a.
         undo CK-CC-HOLD, leave CK-CC-HOLD.
      end.  /* IF L_FLAG */

      display
         abs_veh_ref shp_time arr_date arr_time
      with frame ab.

      do with frame ab on error undo, retry:
         set
            abs_veh_ref
            shp_time
            arr_date
            arr_time with frame ab.
         /* EDIT USER INPUT TIME FIELDS */
         {gprun.i ""fstimchk.p""
          "(input         ""T"",
            input         shp_time,
            input         """",
            output        shp_time,
            output        dummy-length,
            output        msgnbr)"}

          /* FSTIMCHK WILL RETURN ONE OF TWO POTENTIAL  */
          /* ERRORS.  #30 IS FOR MINUTES > 59.  #69     */
          /* INDICATES NON-NUMERIC INPUT, IN WHICH CASE */
          /* WE WANT TO PRESERVE AND REDISPLAY THE USER */
          /* INPUT.                                     */
         if msgnbr <> 0
         then do:

             run DisplayMessage (input msgnbr,
                                 input 3,
                                 input '').
             next-prompt shp_time with frame ab.
             undo,retry.
         end.

         /* EDIT USER INPUT TIME FIELDS */
         {gprun.i ""fstimchk.p""
           "(input         ""T"",
           input         arr_time,
           input         """",
           output        arr_time,
           output        dummy-length,
           output        msgnbr)"}

         /* FSTIMCHK WILL RETURN ONE OF TWO POTENTIAL  */
         /* ERRORS.  #30 IS FOR MINUTES > 59.  #69     */
         /* INDICATES NON-NUMERIC INPUT, IN WHICH CASE */
         /* WE WANT TO PRESERVE AND REDISPLAY THE USER */
         /* INPUT.                                     */

         if msgnbr <> 0
         then do:

             run DisplayMessage (input msgnbr,
                                 input 3,
                                 input '').
             next-prompt arr_time with frame ab.
             undo,retry.
         end.

         find abs_mstr
            where recid(abs_mstr) = abs_recid
            exclusive-lock
            no-error.
         assign
            abs_shp_time = ((integer(substring(shp_time,1,2)) * 60)
                           + integer(substring(shp_time,3,2))) * 60
            abs_arr_date = arr_date
            abs_arr_time = ((integer(substring(arr_time,1,2)) * 60)
                           + integer(substring(arr_time,3,2))) * 60
            overlay(abs__qad01,81,20) = string(abs_veh_ref,"x(20)").
      end.
      /* Warn if there is any sales orders on the shipper */
      /* that has its action status non-blank             */
      for each work_abs_mstr
         no-lock
         where abs_order > ""
      break by abs_order
      on endkey undo CK-CC-HOLD, leave CK-CC-HOLD:

         if first-of (abs_order)
         then do:

            for first so_mstr
               fields( so_domain so_bill so_cr_terms so_curr so_cust so_disc_pct
                       so_exru_seq so_ex_rate so_ex_rate2 so_ex_ratetype
                       so_fix_rate so_fr_terms so_invoiced so_inv_mthd
                       so_inv_nbr so_nbr so_pst_pct so_quote
                       so_secondary so_ship_date so_site so_slspsn
                       so_stat so_tax_date so_tax_pct so_to_inv
                       so_trl1_amt so_trl1_cd so_trl2_amt so_trl2_cd
                       so_trl3_amt so_trl3_cd so_bol so__qadc01)
                where so_mstr.so_domain = global_domain
                 and  so_nbr = abs_order
            no-lock:
            end.

            if available so_mstr
            then do:
               for first cm_mstr
                  fields( cm_domain cm_addr cm_cr_hold)
                   where cm_mstr.cm_domain = global_domain
                    and  cm_addr = so_bill
               no-lock:
               end.

               if available cm_mstr
                  and cm_cr_hold
               then do:

                  /* CUSTOMER ON CREDIT HOLD */
                  run DisplayMessage (input 614,
                                      input 2,
                                      input '').
                  leave.
               end. /* IF AVAILABLE CM_MSTR */

               if so_stat <> ""
               then do:

                  /* SALES ORDER STATUS NOT BLANK */
                  run DisplayMessage (input 623,
                                      input 2,
                                      input '').
                  leave.
               end.

               if not can-find (first tt_so_mstr
                                   where tt_so_mstr.tt_so_nbr = so_nbr)
               then do:
                  create tt_so_mstr.
                  assign
                     tt_so_mstr.tt_so_nbr       = so_nbr
                     tt_so_mstr.tt_so_to_inv    = so_to_inv
                     tt_so_mstr.tt_so_invoiced  = so_invoiced
                     tt_so_mstr.tt_so_ship_date = so_ship_date
                     tt_so_mstr.tt_so_tax_date  = so_tax_date
                     tt_so_mstr.tt_so_bol       = so_bol
                     tt_so_mstr.tt_so__qadc01   = so__qadc01.
               end. /* IF NOT CAN-FIND (FIRST tt_so_mstr */

            end. /* IF AVAILABLE SO_MSTR */

            else if not available so_mstr
            then do:

               /* SALES ORDER DOES NOT EXIST  */
               run DisplayMessage (input 609,
                                   input 3,
                                   input '').
               undo CK-CC-HOLD, leave CK-CC-HOLD.
               leave.
            end.

         end. /* if first-of  abs_order */

         if not can-find(sod_det
             where sod_det.sod_domain = global_domain
              and sod_nbr  = abs_order
              and sod_line = integer(abs_line))
              and abs_qty <> abs_ship_qty
         then do:

            /* SALES ORDER LINE DOES NOT EXIST  */
            run DisplayMessage (input 764,
                                input 3,
                                input '').
            undo CK-CC-HOLD, leave CK-CC-HOLD.
         end.

      end. /* for each work_abs_mstr */

      do transaction:

         /* If the structure is a "pre-shipper" then convert it into */
         /* a "shipper" first. For that, generate the shipper#       */
         if abs_mstr.abs_id begins "p"
         then do:

            {gprun.i ""gpgetgrp.p""
               "(input  abs_mstr.abs_shipfrom,
                 input  abs_mstr.abs_shipto,
                 output shipgrp)"}

            nrseq = shc_ship_nr_id.

            if shipgrp <> ?
            then do:

               for first sgid_det
                  fields( sgid_domain sgid_grp sgid_inv_mov sgid_ship_nr_id)
                   where sgid_det.sgid_domain = global_domain
                    and sgid_grp = shipgrp
                    and sgid_inv_mov = abs_inv_mov
               no-lock:
                  nrseq = sgid_ship_nr_id.
               end. /* FOR FIRST SGID_DET */

            end.

            run chk_internal
               (input nrseq,
                output is_internal,
                output errorst,
                output errornum).

            if errorst
            then do:

               run DisplayMessage (input errornum,
                                   input 3,
                                   input '').
               undo CK-CC-HOLD, leave CK-CC-HOLD.
            end.

            if is_internal
            then do:

               run getnbr
                  (input nrseq,
                   input today,
                   output shipnbr,
                   output errorst,
                   output errornum).

               if errorst
               then do:

                  run DisplayMessage (input errornum,
                                      input 3,
                                      input '').
                  undo CK-CC-HOLD, leave CK-CC-HOLD.
               end.

               display
                  shipnbr
               with frame convfrm.

               if not batchrun
               then
                  pause.

            end.

            else do: /* external sequence */

               updnbr:
               do on endkey undo updnbr, leave updnbr:

                  update
                     shipnbr
                  with frame convfrm.

                  if can-find (first abs_temp
                      where abs_temp.abs_domain = global_domain
                       and abs_temp.abs_shipfrom = abs_mstr.abs_shipfrom
                       and abs_temp.abs_id = "S" + shipnbr)
                  then do:

                     /* SHIPPER ALREADY EXISTS */
                     run DisplayMessage (input 8278,
                                         input 3,
                                         input '').
                     undo updnbr, retry updnbr.
                  end.

                  run valnbr
                     (input nrseq,
                      input today,
                      input shipnbr,
                      output is_valid,
                      output errorst,
                      output errornum).

                  if errorst
                  then do:

                     run DisplayMessage (input errornum,
                                         input 3,
                                         input '').
                     undo updnbr, retry updnbr.
                  end.

                  else if not is_valid
                  then do:

                     /* INVALID PRE-SHIPPER/SHIPPER NUMBER FORMAT */
                     run DisplayMessage (input 5950,
                                         input 3,
                                         input '').
                     undo updnbr, retry updnbr.
                  end.

               end. /* updnbr */

               if keyfunction(lastkey) = "end-error"
               then do:

                  hide frame convfrm no-pause.
                  undo CK-CC-HOLD, leave CK-CC-HOLD.
               end.

            end. /* external sequence */

            hide frame convfrm no-pause.

            shipnbr = "S" + shipnbr.

            find abs_mstr
               where recid(abs_mstr) = abs_recid
               exclusive-lock
               no-error.

            /* Save the preshipper# and overwrite abs_id with shipper# */
            assign
               abs_mstr.abs_preship_id    = abs_mstr.abs_id
               abs_mstr.abs_preship_nr_id = abs_mstr.abs_nr_id
               abs_mstr.abs_nr_id         = nrseq.

            /* CHANGE THE SHIPPER NUMBER IN THE WORK_ABS_MSTR */
            {gprun.i ""rcsoisa1.p""
               "(abs_mstr.abs_shipfrom,
                 abs_mstr.abs_id,
                 shipnbr)"}

            /* CHANGE THE SHIPPER NUMBER FOR ENTIRE SHIPPER STRUCTURE */
            {gprun.i ""icshchg.p"" "(recid(abs_mstr), shipnbr)" }

            /* ASSIGN SHIPPER NUMBER TO CARRIER REF IF CARRIER REF IS */
            /* PRE_SHIPPER NUMBER */
            if right-trim(substring(abs_mstr.abs_preship_id,2,20)) =
               right-trim(substring(abs_mstr.abs__qad01,41,20))
            then
               assign
                  overlay(abs_mstr.abs__qad01,41,20) =
                     substring(abs_mstr.abs_id,2,20)
                  abs_carr_ref = substring(abs_mstr.abs__qad01,41,20).

            if use-log-acctg
            then
               run changeShipperNumberInLogAcctDetail
                      (input {&TYPE_SOPreShipper},
                       input substring(abs_mstr.abs_preship_id,2),
                       input abs_mstr.abs_shipfrom,
                       input {&TYPE_SOShipper},
                       input substring(abs_mstr.abs_id,2),
                       input abs_mstr.abs_shipfrom).


         end. /* IF ABS_MSTR.ABS_ID BEGINS "P"  */
      end. /* DO TRANSACTION */

      /* CHECK FOR UNPEGGED SHIPPER LINES */
      {gprun.i ""rcsois4a.p""
         "(input abs_recid, output yn)"}

      if yn
      then
         undo CK-CC-HOLD, leave CK-CC-HOLD.
      for first df_mstr
         fields( df_domain df_format df_inv df_type)
          where df_mstr.df_domain = global_domain
           and  df_type = "1"
           and  df_format = abs_format
      no-lock:
      end.
      if available df_mstr
         and df_inv
      then
         assign
            auto_post   = yes
            use_shipper = yes
            consolidate = yes
            auto_inv    = no.

      else
      if not available df_mstr
         or (available df_mstr
         and not df_inv)
      then do:

         auto_inv = auto_post.

         if auto_post
         then
            for first mfc_ctrl
               fields( mfc_domain mfc_field mfc_logical )
                where mfc_ctrl.mfc_domain = global_domain
                 and  mfc_field = "rcc_auto_inv"
            no-lock:
               auto_inv = mfc_logical.
            end. /* FOR FIRST mfc_ctrl */

      end. /* else IF NOT AVAILABLE df_mstr .. */

      if id_length > 8
      then
         use_shipper = no.
      {&RCSOIS1-P-TAG5}

      if available so_mstr
      then do:

         {gprunp.i "gpccpl" "p" "isCCOrder"
            "(input so_nbr, output creditCardOrder)"}
      end. /* IF AVAILABLE so_mstr */

      {&RCSOIS1-P-TAG6}
      if creditCardOrder
      then do:

         assign
            use_shipper = no
            consolidate = no.
         display use_shipper consolidate with frame b.
      end. /*if creditCardOrder then do:*/

      /* PERFORM SECURITY CHECK FOR ACCESS OF MENUS INVOICE PRINT */
      /* AND INVOICE POST.                                        */
      for first mnd_det
         fields (mnd_exec mnd_nbr mnd_select)
         where  (mnd_exec = "xxsosorp10.p" or mnd_exec = "sosorp10.p")
      no-lock:
      end.
      if available mnd_det then do:
         {gprun1.i ""mfsec.p"" "(input mnd_det.mnd_nbr,
                                 input mnd_det.mnd_select,
                                 input false,
                                 output l_invprint)" }
      end. /* IF AVAILABLE mnd_det */

      for first mnd_det
         fields (mnd_exec mnd_nbr mnd_select)
         where  (mnd_exec = "xxsoivpst.p" or mnd_exec = "soivpst.p")
      no-lock:
      end.
      if available mnd_det then do:
         {gprun1.i ""mfsec.p"" "(input mnd_det.mnd_nbr,
                                 input mnd_det.mnd_select,
                                 input false,
                                 output l_invpost)" }
      end. /* IF AVAILABLE mnd_det */

      /* DISABLE UPDATE TO INVOICE POST FLAG WHEN SELF BILLING */
      /* IS ACTIVE BUT INTEGRATE WITH AR IS 'NO'               */
      run proc-archeck(input-output auto_post,
               input-output l_auto_noupdate).

      {&RCSOIS1-P-TAG11}

      if l_invprint = no then
         assign
            auto_inv  = no
            auto_post = no.

      else if l_invprint = yes
              and l_invpost = no then
                 auto_post  = no.

      {&RCSOIS1-P-TAG20}

      if l_invprint = no then
         hide frame b.

      else
      update
         auto_inv    when (l_invprint = yes)
         auto_post   when (not l_auto_noupdate
                           and l_invprint = yes
                           and l_invpost  = yes)
         use_shipper when (not creditCardOrder
                           and l_invprint = yes)
         consolidate when (not creditCardOrder
                           and l_invprint = yes)
         l_calc_freight
         {&RCSOIS1-P-TAG21}
      with frame b.
      {&RCSOIS1-P-TAG12}

      {&RCSOIS1-P-TAG22}
      l_auto_noupdate = no.

      run connect_vertex no-error.
      if error-status:error
      then
         undo, retry.

      errornum = if use_shipper
                    and id_length > 8
                 then
                    /* Shipper number too long, use shipper document as inv */
                    5982
                 else if use_shipper
                    and not consolidate
                 then
                    /* Consolidating mandatory when using shipper nbr as inv */
                    5984
                 else
                    0.

      if errornum <> 0
      then do:

         run DisplayMessage (input errornum,
                             input 3,
                             input '').
         next-prompt use_shipper with frame b.
         undo, retry.
      end.

      if available df_mstr
         and df_inv
         and not use_shipper
      then

         /* DOCUMENT FORMAT REQUIRES SHIPPER NUMBER TO BE USED FOR INVOICE */
         run DisplayMessage (input 5992,
                             input 2,
                             input '').


      /* VALIDATES THAT THERE IS ADEQUATE INVENTORY AVAILABLE TO SHIP ALL */
      /* LINES WITH SAME SITE, LOC & PART IF OVER-ISSUE NOT ALLOWED */
      /* VALIDATE WHEN CONFIRMING, SKIP WHEN UN-CONFIRMING. */
      /* THIS ALLOWS SERIAL NUMBERS TO BE RETURNED FROM CONSIGNMENT */
      /* LOCATIONS. */

      if confirm_mode
      then do:

         {gprun.i ""rcsoisg.p""}
         if rejected
         then
            undo CK-CC-HOLD, leave CK-CC-HOLD.
      end.  /* if confirm_mode */

      /* GO THRU WORKFILE FOR  VALIDATION,  UPDATE  STD  COSTS,      */
      /* SET PRICES,  SET  INVOICING  FLAGS, UPDATE FREIGHT CHARGES, */
      /* MANUAL UPDATE OF TRAILER CHARGES,                           */
      /* AND ORDER  THE  SECRETARY  FLOWERS                          */

      assign
         tot_freight_gl_amt = 0
         order_ct = 0.

      do transaction:

         for each work_abs_mstr
            where abs_order > ""
            no-lock,
            each sod_det
            exclusive-lock
             where sod_det.sod_domain = global_domain
              and sod_nbr = abs_order
              and sod_line = integer(abs_line)
         break by abs_order by abs_line:

            if (oldcurr <> so_curr)
               or (oldcurr = "")
            then do:

               /* GET ROUNDING METHOD FROM CURRENCY MASTER */
               {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                  "(input so_curr,
                    output rndmthd,
                    output mc-error-number)"}
               if mc-error-number <> 0
               then do:

                  run DisplayMessage (input mc-error-number,
                                      input 3,
                                      input '').
                  undo CK-CC-HOLD, leave CK-CC-HOLD.
               end.  /* mc-error-number <> 0 */

               oldcurr = so_curr.

            end.

            if first(abs_order)
            then do:

               find so_mstr
                   where so_mstr.so_domain = global_domain
                    and  so_nbr = sod_nbr
               exclusive-lock.

               assign
                  l_first_so_nbr     = so_nbr
                  first_so_bill      = so_bill
                  first_so_cust      = so_cust
                  first_so_curr      = so_curr
                  first_so_cr_terms  = so_cr_terms
                  first_so_trl1_cd   = so_trl1_cd
                  first_so_trl2_cd   = so_trl2_cd
                  first_so_trl3_cd   = so_trl3_cd
                  first_so_slspsn[1] = so_slspsn[1]
                  first_so_slspsn[2] = so_slspsn[2]
                  first_so_slspsn[3] = so_slspsn[3]
                  first_so_slspsn[4] = so_slspsn[4]
                  first_so_entity    = ""
                  first_so_site      = so_site
                  first_so_ex_rate   = so_ex_rate
                  first_so_ex_rate2  = so_ex_rate2
                  first_so_exru_seq  = so_exru_seq.

               for first si_mstr
                  fields( si_domain si_db si_desc si_entity si_site)
                   where si_mstr.si_domain = global_domain
                    and  si_site = so_site
               no-lock:
                  first_so_entity = si_entity.
               end.
               /* MULTI-DB: USE SHIP-TO CUSTOMER TYPE FOR DEFAULT */
               /* IF AVAILABLE ELSE USE BILL-TO TYPE USED TO      */
               /* FIND COGS ACCOUNT IN SOCOST02.p                 */
               {gprun.i ""gpcust.p""
                  "(input  so_nbr, output ord-db-cmtype)"}

            end.

            /* CONVERTING SHIPQTY TO INVENTORY UM FROM SHIP UM */
            shipqty = (if confirm_mode
                       then
                          (work_abs_mstr.abs_qty - work_abs_mstr.abs_ship_qty)
                      /* CORRECTED THE SHIPQTY DURING UNCONFIRM MODE  */
                       else
                          (-1 * work_abs_mstr.abs_qty)) *
                         decimal(work_abs_mstr.abs__qad03).

            if abs_item = sod_part
            then
               accumulate shipqty (sub-total by abs_line).

            if first-of(abs_order)
            then do:
               l_so_to_inv = no.

               order_ct = order_ct + 1.

               if order_ct <= 30
               then
                  order_nbrs[order_ct] = sod_nbr.
               else
                  order_nbr_list = order_nbr_list + sod_nbr + ",".

               for first so_mstr
                  fields( so_domain so_bill so_cr_terms so_curr so_cust
                          so_exru_seq so_ex_rate so_ex_rate2 so_ex_ratetype
                          so_fix_rate so_fr_terms so_invoiced so_inv_mthd
                          so_inv_nbr so_nbr so_pst_pct so_quote
                          so_secondary so_ship_date so_site so_slspsn
                          so_stat so_tax_date so_tax_pct so_to_inv
                          so_trl1_amt so_trl1_cd so_trl2_amt so_trl2_cd
                          so_trl3_amt so_trl3_cd so_disc_pct so_bol so__qadc01)
                   where so_mstr.so_domain = global_domain
                    and  so_nbr = sod_nbr
               no-lock:
               end.
               /* CHECK FOR USE SHIPPER AS INVOICE NUMBER */
               if use_shipper
               then
               if can-find(first so_mstr
                   where so_mstr.so_domain = global_domain
                   and ( so_inv_nbr = substring(abs_mstr.abs_id,2,50)))
                     or can-find(ar_mstr
                   where ar_mstr.ar_domain = global_domain
                   and ( ar_nbr = substring(abs_mstr.abs_id,2,50)))
                     or can-find(first ih_hist
                   where ih_hist.ih_domain = global_domain
                   and   ih_inv_nbr = substring(abs_mstr.abs_id,2,50))
               then do:

                  /* Cannot auto invoice.                  */
                  /* Shipper already used by invoice/order */
                  run DisplayMessage (input 8150,
                                      input 3,
                                      input '').
                  undo CK-CC-HOLD, leave CK-CC-HOLD.
               end.


               /*CHECK CONSISTENCY OF SALES ORDERS*/
               if consolidate
               then do:

                  msg_text = "".

                  /* PROCEDURE FOR CONSOLIDATION RULES */
                  {gprun.i ""soconso.p""
                     "(input 2,
                       input  l_first_so_nbr ,
                       input  so_nbr ,
                       output l_consolidate_ok,
                       output msg_text)"}

                  if msg_text > ""
                  then do:

                     /* MISMATCH WITH PENDING INVOICE - CAN'T CONSOLIDATE. */
                     run DisplayMessage (input 1046,
                                         input 3,
                                         input msg_text).
                     undo CK-CC-HOLD, leave CK-CC-HOLD.
                  end.

               end. /* IF CONSOLIDATE */

               if use-log-acctg
                  and l_calc_freight
               then do:

                  msg_text = "".

                  run validateSOForLogisticsAccounting
                         (input l_first_so_nbr,
                          input so_nbr,
                          output msg_text).

                  if msg_text > ""
                  then do:

                     /* ALL ATTACHED ORDERS MUST HAVE SAME # */
                     run DisplayMessage (input 5588,
                                         input 3,
                                         input msg_text).
                     undo CK-CC-HOLD, leave CK-CC-HOLD.
                  end.

               end. /* IF USE-LOG-ACCTG AND l_CALC_FREIGHT */

               if so_fix_rate
               then
                  assign
                     exch_rate     = so_ex_rate
                     exch_rate2    = so_ex_rate2
                     exch_ratetype = so_ex_ratetype
                     exch_exru_seq = so_exru_seq.
               else do:

                  /* GET EXCHANGE RATE FOR BASE TO ACCOUNT CURRENCY */
                  {gprunp.i "mcpl" "p" "mc-get-ex-rate"
                           "(input  so_curr,
                             input  base_curr,
                             input  so_ex_ratetype,
                             input  eff_date,
                             output exch_rate,
                             output exch_rate2,
                             output mc-error-number)" }
                  if mc-error-number <> 0
                  then do:

                     run DisplayMessage (input mc-error-number,
                                         input 3,
                                         input '').
                     undo CK-CC-HOLD, leave CK-CC-HOLD.
                  end.
                  assign
                     exch_ratetype = so_ex_ratetype
                     exch_exru_seq = 0.

               end.  /* else */
               find so_mstr
                   where so_mstr.so_domain = global_domain
                    and  so_nbr = sod_nbr
               exclusive-lock.

               if available so_mstr
               then
                  assign
                     so_ship_date = ship_dt
                     so_invoiced  = no .
               if using_cust_consignment
               then
                  so_tax_date = ? .
               else
                  so_tax_date  = ship_dt.
               /* TO DOWNGRADE THE LOCK TO NO-LOCK AS THE FIELDS */
               /* OF THE so_mstr ARE ACCESSED BELOW              */
               for first so_mstr
                   where so_domain = global_domain
                   and   so_nbr    = sod_nbr
                   no-lock:
               end. /* FOR FIRST so_mstr */

            end. /* IF FIRST-OF(ABS_ORDER) */

            if last-of(abs_line)
            then do:

               /* SET STANDARD COST */

               /* SWITCH TO INVENTORY DOMAIN IF NECESSARY */
               if change_db
               then do:

                  run ip_alias
                     (input ship_db,
                      output l_flag).
                  if l_flag
                  then
                     undo CK-CC-HOLD, leave CK-CC-HOLD.
               end.

               /* SET STANDARD COST FROM INVENTORY DOMAIN */
               {gprun.i ""gpsct05.p""
                  "(input sod_part,
                    input sod_site,
                    input 1,
                    output glxcst,
                    output curcst)"}

               /* SWITCH BACK TO SALES ORDER DOMAIN IF NECESSARY */
               if change_db
               then do:

                  run ip_alias
                     (input so_db,
                      output l_flag).
                  if l_flag
                  then
                     undo CK-CC-HOLD, leave CK-CC-HOLD.
               end.

               if sod_type <> "M"
               then
                  sod_std_cost = glxcst * sod_um_conv.

               /* If Scheduled Order */
               if sod_sched
               then do:

                  if sod_cum_qty[3] > 0
                     and sod_cum_qty[1]
                     + ((accum sub-total by abs_line shipqty)
                     /   sod_um_conv) >= sod_cum_qty[3]
                  then do on endkey undo CK-CC-HOLD, leave CK-CC-HOLD:

                     hide message no-pause.

                     /* CUM SHIPPED QTY >= MAX ORDER QTY FOR ORDER SELECTED*/
                     run DisplayMessage (input 8220,
                                         input 2,
                                         input '').
                     /* Order # Line # */
                     {pxmsg.i &MSGNUM=8310 &ERRORLEVEL=1
                              &MSGARG1=sod_nbr
                              &MSGARG2=sod_line}
                     if not batchrun
                     then
                        pause.
                  end.

                  /* SET CURRENT PRICE */
                  for first pt_mstr
                     fields( pt_domain pt_part pt_price)
                      where pt_mstr.pt_domain = global_domain
                       and  pt_part = sod_part
                  no-lock:
                  end.

                  /* FOLLOWING SECTION IS ADDED TO REPLACE rcpccal.p */
                  /* WITH gppccal.p TO TAKE CARE OF PRICE LIST TYPES */
                  /* "M" AND "D" IN ADDITION TO "P"                  */
                  for first soc_ctrl
                     fields( soc_domain soc_pl_req)
                      where soc_ctrl.soc_domain = global_domain
                  no-lock:
                  end.

                  assign
                     l_disc_pct1  = 0
                     l_net_price  = ?
                     l_rec_no     = ?
                     l_list_price = 0.

                  /* SCHEDULED ORDERS CAN BE CREATED ONLY IN STOCKING */
                  /* UM MULTIPLYING BY sod_um_conv JUST FOR SAFETY    */
                  if available pt_mstr
                  then do:

                     /* CONVERT FROM BASE TO ACCOUNT CURRENCY */
                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                              "(input  base_curr,
                                input  so_curr,
                                input  exch_rate2,
                                input  exch_rate,
                                input  pt_price * sod_um_conv,
                                input  false,   /* DO NOT ROUND */
                                output l_list_price,
                                output mc-error-number)"}.
                     if mc-error-number <> 0
                     then do:

                        run DisplayMessage (input mc-error-number,
                                            input 3,
                                            input '').
                        undo CK-CC-HOLD, leave CK-CC-HOLD.
                     end.

                  end.  /* if available */

                  /* CALCULATE PRICE */
                  {gprun.i ""gppccal.p""
                     "(input  sod_part,
                       input (accum sub-total by abs_line shipqty) / sod_um_conv,
                       input sod_um,
                       input sod_um_conv,
                       input so_curr,
                       input sod_pr_list ,
                       input eff_date,
                       input (sod_std_cost * so_ex_rate),
                       input soc_pl_req,
                       0.0,
                       input-output  l_list_price,
                       output        l_disc_pct1,
                       input-output  l_net_price,
                       output        l_rec_no)"}

                  create tt_sod_det.

                  assign
                     tt_sod_nbr  = sod_nbr
                     tt_sod_line = sod_line
                     tt_pr_found = if l_rec_no = 0
                                   then
                                      false
                                   else
                                      true.

                  if recid(tt_sod_det) = -1
                  then
                     .

                  if l_net_price <> ?
                  then
                     sod_price = l_net_price.

                  /* UPDATE SOD_LIST_PRICE FOR SCHEDULE ORDER WHEN   */
                  /* SOD_LIST_PRICE IS ZERO OR                       */
                  /* LIST PRICE IN ITEM MASTER IS ZERO SO THAT SALES */
                  /* AMOUNT SHOULD BE POSTED TO PROPER ACCOUNT       */
                  if pt_price    = 0 or
                     sod_list_pr = 0
                  then
                     sod_list_pr = sod_price.

                  /* SWITCHING TO INVENTORY DOMAIN */
                  if change_db
                  then do:

                     run ip_alias
                        (input ship_db,
                         output l_flag).
                     if l_flag
                     then
                        undo CK-CC-HOLD, leave CK-CC-HOLD.
                  end. /* IF CHANGE_DB */

                  /* UPDATE NET PRICE, LIST PRICE, CUMULATIVE QTY IN */
                  /* INVENTORY DOMAIN                              */
                  {gprun.i ""sosoisu6.p""
                     "(input sod_nbr,
                       input sod_line,
                       input sod_price,
                       input l_list_price,
                       input sod_cum_qty[1],
                       input sod_cum_qty[2],
                       input sod_cum_qty[3])"}

                  /* SWITCHING BACK TO CENTRAL DOMAIN */
                  if change_db
                  then do:

                     run ip_alias (input so_db, output l_flag).
                     if l_flag
                     then
                        undo CK-CC-HOLD, leave CK-CC-HOLD.
                  end. /* IF CHANGE_DB */

               end.

               /* SOD_QTY_CHG IS FOR EVERY SALES ORDER LINE AND THE */
               /* QUANTITY SHOULD BE ACCUMULATED FOR EACH LOTSERIAL */
               /* LINE ENTERED VIA MULTI-ENTRY MODE                 */
               assign
                  sod_qty_chg =
                     (accum sub-total by abs_line shipqty) / sod_um_conv.

               /* CREATE IMPORT EXPORT HISTORY RECORD */
               run createImpExpHist
                   (buffer sod_det,
                    input sod_qty_chg,
                    input abs_mstr.abs_id,
                    input eff_date).

            end. /* if last-of abs_line */

            if last-of(abs_order)
            then do:

               gl_amt = 0.
               run calculate_freight_charge( buffer so_mstr,
                  input l_calc_freight,
                  input substring(abs_mstr.abs_id,2,50)).

               if rndmthd = ""
               then do:

                  /* GET ROUNDING METHOD FROM CURRENCY MASTER */
                  {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                     "(input so_curr,
                       output rndmthd,
                       output mc-error-number)"}
                  if mc-error-number <> 0
                  then do:

                     run DisplayMessage (input mc-error-number,
                                         input 3,
                                         input '').
                     undo CK-CC-HOLD, leave CK-CC-HOLD.
                  end.  /* IF mc-error-number <> 0 */

               end. /* IF rndmthd = "" */

               /* MANUAL UPDATE OF TRAILER DATA */
               {gprun.i ""xxrcsoistr.p""
                  "(input sod_nbr,
                    output undo_stat)"}
/*zy*/          if solst= "" then
/*zy*/          	assign solst = so_nbr.
/*zy*/          else
/*zy*/          	if index(solst,so_nbr) = 0 then
/*zy*/        		   assign solst = solst + ";" + so_nbr.
               /* WHEN POSTING FREIGHT WITH LOGISTICS ACCOUNTING WE NEED THE  */
               /* TRANSACTION NUMBER(tr_trnbr)FOR THE "ISS-SO" TRANSACTION.   */
               /* THIS NUMBER IS USED TO RELATE THE TRGL_DET RECORDS CREATED  */
               /* IN LAFRPST.P TO "ISS-SO" TRANSACTION(TR_HIST) RECORD.       */
               /* THERFORE THE FREIGHT ACCRUAL POSTING FOR LOGISTICS ACCTNG   */
               /* IS DONE AFTER SHIPMENTS ARE PROCESSED (I.E.AFTER RCSOIS1A.P */
               /* IS CALLED).                                                 */

               /* POST FREIGHT ACCRUALS - WHEN LOG ACCTG IS NOT ENABLED */
               if gl_amt <> 0
                  and (not use-log-acctg)
               then do:

                  so_mstr_recid = recid(so_mstr).
                  {gprun.i ""sofrpst.p"" "(input eff_date)"}
               end. /* IF GL_AMT <> 0 */

               tot_freight_gl_amt = tot_freight_gl_amt + gl_amt.

               if undo_stat
               then
                  undo CK-CC-HOLD, leave CK-CC-HOLD.

            end. /* if last-of(abs_order) */

            /* CHECK FOR SALES ORDER HAVING ALL CONSIGNED LINES AND NO       */
            /* TRAILER AMOUNTS AND SET so_to_inv = NO FOR SUCH SALES ORDERS. */
            run  p_set-so-to-invoice (input work_abs_mstr.abs_order,
                                      input work_abs_mstr.abs_line,
                                      input work_abs_mstr.abs_qty,
                                      input work_abs_mstr.abs__qadc01,
                                      input-output l_so_to_inv).


         end. /* for each work_abs_mstr */

         /* For Pre-shipper/shipper confirm determines if this order
          * will be processed with a credit card and validate that
          * the credit card info is valid and that the authorized
          * amount is enough to process the order.*/
         if confirm_mode = yes
            and available so_mstr
         then do:

            {&RCSOIS1-P-TAG7}
            {gprunp.i "soccval" "p" "preValidateCCProcessing"
               "(input so_nbr, output errorNbr)"}
            if errorNbr <> 0
            then do:

               run DisplayMessage (input errorNbr,
                                   input 2,
                                   input '').
               /*ORDER PLACED ON HOLD*/
               run DisplayMessage (input 3468,
                                   input 2,
                                   input '').
               vSOToHold = so_nbr.
            end.
            {&RCSOIS1-P-TAG8}
         end. /* IF confirm_mode = YES AND ... */

         /* WHILE UNCONFIRMING THE SHIPPER, trq_mstr GETS DELETED  */
         /* IF ASN HAS BEEN EXPORTED OTHERWISE DISPLAY THE WARNING */
         if can-find(btb_det
             where btb_det.btb_domain = global_domain
             and   btb_so       = sod_nbr
             and   btb_sod_line = sod_line)
             and not confirm_mode
         then do:

            run p-del-trq_mstr.
            if l_flag1 = yes
            then
               undo CK-CC-HOLD, leave CK-CC-HOLD.
         end. /* IF CAN-FIND(btb_det) */

         if using_container_charges
         then do:

            /* CREATE THE SALES ORDER DETAIL CONTAINER CHARGE RECORDS */
            {gprunmo.i &module = "ACL" &program = ""rcsoiscd.p""
               &param   = """(input abs_shipfrom,
                              input abs_shipto,
                              input ship_dt,
                              input eff_date,
                              input abs_recid,
                              input confirm_mode,
                              input auto_post,
                              input no)"""}
         end.

         if using_line_charges
         then do:

            /* EXPLODE SHIPPER TO GET ORDER ADDITIONAL CHARGES DETAIL */
            {gprunmo.i &module = "ACL" &program = ""rcsoiscf.p""
               &param   = """(input recid(abs_mstr),
                              input confirm_mode,
                              input no)"""}
         end.

         txcalcref = string(abs_mstr.abs_shipfrom,"x(8)") +
                            abs_mstr.abs_id.

         yn = yes.
         /* Is all information correct ? */
         {pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=yn}

         if not yn
         then
            undo CK-CC-HOLD, leave CK-CC-HOLD.

      end. /* do transaction */
      do transaction:

         /* THE POST FLAG IS SET TO 'NO' BECAUSE WE ARE NOT CREATING
          * QUANTUM REGISTER RECORDS FROM THIS CALL TO TXCALC.P */
         run p_taxcal.

         /* SWITCH TO INVENTORY DOMAIN IF NECESSARY */
         if change_db
         then do:

            run ip_alias
               (input ship_db,
                output l_flag).

            if l_flag
            then
               undo CK-CC-HOLD, leave CK-CC-HOLD.

         end.

         {gprun.i ""gpnxtsq.p"" "(output trlot)" }

         /* SWITCH BACK TO SALES ORDER DOMAIN IF NECESSARY */
         if change_db
         then do:

            run ip_alias (input so_db, output l_flag).
            if l_flag
            then
               undo CK-CC-HOLD, leave CK-CC-HOLD.

         end.
         run check_somstr.
      end.
      {&RCSOIS1-P-TAG13}
      /* Added input using_cust_consignment    */
      {gprun.i ""xxrcsois1a.p""
         "(input ""so_shipper_confirm"",
           input using_cust_consignment,
           input table tt_somstr,
           output undo_stat)" }

      for each tt_somstr exclusive-lock:
         delete tt_somstr.
      end. /* FOR EACH tt_somstr */

      /* PROCEDURE CREATED TO AVOID ACTION SEGMENT ERROR   */
      run p-undo.

      if undo_stat
      then do transaction:

         /* RESET THE tx2d_det, so_mstr AND sod_det TO PRIOR STATUS */
         /* IN CASE OF AN ERROR                                     */
         run p_undo_records
            (buffer tt_so_mstr,
             input txcalcref).

      end. /* IF undo_stat */

      if l_undo
      then
         undo mainloop, retry mainloop.

      if undo_stat
      then
         undo CK-CC-HOLD, leave CK-CC-HOLD.


      /* FREIGHT POSTING WITH LOGISTICS ACCOUNTING DISABLED ARE HANDLED */
      /* ABOVE BY SOFRPST.P                                             */

      /* POST FREIGHT ACCRUALS WITH LOGISTICS ACCOUNTING ENABLED    */
      run p_PostFreightForLogAcctg.

      if     available sod_det
         and not sod_consignment
      then do:
         if can-find(first lotw_wkfl
            where lotw_domain  = global_domain
            and   lotw_mfguser = mfguser)
         then do:
            for each lotw_wkfl
               where lotw_domain  = global_domain
               and   lotw_mfguser = mfguser
            exclusive-lock:
               delete lotw_wkfl.
            end. /* FOR EACH lotw_wkfl */
         end. /* IF CAN-FIND FIND(lotw_wkfl) */
      end. /* IF NOT sod_consignment */

      if available so_mstr
        then
         if not so_sched
         then
            run p_wrk_so_calc.

      global_recid = abs_recid.
      release sod_det.
   end. /* CK-CC-HOLD */

   /* IF CREDIT CARD VALIDATIONS FAILED, PUT THE ORDER ON HOLD */
   /* BEFORE REPEATING THE MAINLOOP.                           */
   if vSOToHold <> ""
   then do transaction:

      run updateSOStatus
         (input vSOToHold).
   end.

   release abs_mstr.

/*zy*/ do transaction:
/*zy*/    do while solst > "":
/*zy*/       for each so_mstr exclusive-lock where so_domain = global_domain 
/*zy*/              and (so_nbr = substring(solst,1,index(solst,";") - 1) or 
/*zy*/                   so_nbr = solst):              
/*zy*/           assign so_trl1_amt = decimal(entry(1,so__chr06,";"))
/*zy*/                                when so__chr06 <> ""           
/*zy*/                  so_trl2_amt = decimal(entry(2,so__chr06,";"))
/*zy*/                                when so__chr06 <> ""           
/*zy*/                  so_trl3_amt = decimal(entry(3,so__chr06,";"))
/*zy*/                               when so__chr06 <> "".           
/*zy*/        end.  
/*zy*/					 if index(solst,";") > 0 then
/*zy*/              assign solst = substring(solst,index(solst,";") + 1).
/*zy*/           else 
/*zy*/           	  assign solst = "".                                                
/*zy*/    end.
/*zy*/ end.
   run disconnect_vertex.

end. /* mainloop (repeat) */

run disconnect_vertex.

{gpdelp.i "soccval" "p"} /*Delete persistent procedure*/

{gpnbrgen.i}
{gpnrseq.i}

{rctxcal.i}

run del-qad-wkfl.

PROCEDURE del-qad-wkfl:
/*-----------------------------------------------------------------------
  Purpose:      Clean up qad_wkfl records used for rcsois.p
  Parameters:
  Notes:        Internal procedure created to reduce compile size
 -------------------------------------------------------------------------*/

   define buffer qad_wkfl for qad_wkfl.

   for each qad_wkfl
       where qad_wkfl.qad_domain = global_domain
        and qad_key3 = "rcsois.p"
        and qad_key4 = mfguser
      exclusive-lock:
      delete qad_wkfl.
   end.

END PROCEDURE.  /* del-qad-wkfl */

PROCEDURE p_glcalval:
/*-----------------------------------------------------------------------
  Purpose:      Verifies open GL Period for each site/entity of
                each line item

  Parameters:   l_flag

  Notes:
 -------------------------------------------------------------------------*/
   define output parameter l_flag like mfc_logical no-undo.

   define buffer work_abs_mstr for work_abs_mstr.
   define buffer si_mstr       for si_mstr.

   for each work_abs_mstr
      where work_abs_mstr.abs_qty <> work_abs_mstr.abs_ship_qty
        and (work_abs_mstr.abs_id begins "I" or
            work_abs_mstr.abs_id begins "C")
      no-lock:

      for first si_mstr
         fields( si_domain si_db si_desc si_entity si_site )
          where si_mstr.si_domain = global_domain
           and  si_site = work_abs_mstr.abs_site
      no-lock:
      end.

      if available si_mstr
      then do:

         /* CHECK GL EFFECTIVE DATE */
         {gpglef01.i ""IC"" si_entity eff_date}

         if gpglef > 0
         then do:

            run DisplayMessage (input gpglef,
                                input 4,
                                input si_entity).
            l_flag = yes.
            return.
         end. /* IF GPGLEF > 0 */

         else do:

            /* CHECK GL EFFECTIVE DATE */
            {gpglef01.i ""SO"" si_entity eff_date}

            if gpglef > 0
            then do:

               run DisplayMessage (input gpglef,
                                   input 4,
                                   input si_entity).
               l_flag = yes.
               return.
            end. /* IF GPGLEF > 0 */

         end. /* ELSE IF GPGLEF = 0 */

      end. /* IF AVAILABLE SI_MSTR */

   end. /* FOR EACH WORK_ABS_MSTR */

END PROCEDURE.  /* p_glcalval */

PROCEDURE ip_alias:
/*-----------------------------------------------------------------------
  Purpose:      Establish an Alias for a particular db

  Parameters:   i_db          Name of the database
                o_err_flag    If true, then database alias not established
  Notes:
 -------------------------------------------------------------------------*/

   define input  parameter i_db       like global_db no-undo.
   define output parameter o_err_flag as   logical   no-undo.
   define variable         v_err_num  as   integer   no-undo.

   {gprun.i ""gpalias3.p"" "(i_db, output v_err_num)" }

   o_err_flag = v_err_num = 2 or v_err_num = 3.

   if o_err_flag
   then do:

      /* Domain # is not available */
      run DisplayMessage (input 6137,
                          input 4,
                          input i_db).
   end.

END PROCEDURE.  /* ip_alias */


PROCEDURE updateSOStatus:
/*-----------------------------------------------------------------------
  Purpose:      Set the so_stat field of a Sales Order to the value of
                ccc_cc_hold_status

  Parameters:   pSONbr - Sales Order Number

  Notes:        added by N06R for Net.Commerce
 -------------------------------------------------------------------------*/
   define input parameter pSONbr as character no-undo.

   define buffer ccc_ctrl for ccc_ctrl.
   define buffer so_mstr  for so_mstr.

   for first ccc_ctrl
      fields( ccc_domain ccc_cc_hold_status)
       where ccc_ctrl.ccc_domain = global_domain no-lock:

      for first so_mstr
         exclusive-lock
          where so_mstr.so_domain = global_domain
           and  so_nbr = pSONbr:
         so_stat = ccc_cc_hold_status.
      end.

      release so_mstr.

   end.

END PROCEDURE.


PROCEDURE p-qadwkfl:
/*-----------------------------------------------------------------------
  Purpose:
  Parameters:   <None>
  Notes:
 -------------------------------------------------------------------------*/

   define buffer work_abs_mstr for work_abs_mstr.
   define buffer qad_wkfl      for qad_wkfl.

   for each work_abs_mstr
      exclusive-lock:

      if work_abs_mstr.abs_order <> ""
      then do:

         for first qad_wkfl
            fields( qad_domain qad_charfld qad_datefld qad_key1 qad_key2
                    qad_key3 qad_key4)
             where qad_wkfl.qad_domain = global_domain
              and qad_key1 = "rcsois.p"
              and qad_key2 = work_abs_mstr.abs_order
            no-lock:
         end.

         if available qad_wkfl
            and qad_wkfl.qad_key4 <> mfguser
         then do:

            /* SALES ORDER # IS BEING CONFIRMED BY USER # */
            {pxmsg.i &MSGNUM=2262 &ERRORLEVEL=3
                     &MSGARG1=qad_key2
                     &MSGARG2=qad_charfld[1]}
            l_undoflg = yes.
         end.  /* IF AVAILABLE qad_wkfl */

         else
         if not available qad_wkfl
         then do:

            create qad_wkfl. qad_wkfl.qad_domain = global_domain.
            assign
               qad_key1       = "rcsois.p"
               qad_key2       = work_abs_mstr.abs_order
               qad_key3       = "rcsois.p"
               qad_key4       = mfguser
               qad_charfld[1] = global_userid
               qad_charfld[2] = work_abs_mstr.abs_par_id
               qad_charfld[3] = work_abs_mstr.abs_shipfrom
               qad_date[1]    = today
               qad_charfld[5] = string(time, "hh:mm:ss").

            if recid(qad_wkfl) = -1
            then
               .

         end.  /* IF NOT AVAILABLE qad_wkfl */

      end. /* IF abs_order <> "" */

      assign
         work_abs_mstr.abs_ship_qty = 0.

   end.  /* FOR EACH work_abs_mstr */

END PROCEDURE.

PROCEDURE p-del-trq_mstr:
   define buffer trq_mstr for trq_mstr.

   find first trq_mstr
      where trq_domain   = global_domain          and
            trq_doc_type = "ASN"                  and
            trq_doc_ref  =  abs_mstr.abs_shipfrom and
            trq_add_ref  =  trim("s" +
                            substring(abs_mstr.abs__qad01,41,20))
   exclusive-lock no-error.
   if available trq_mstr
   then
      delete trq_mstr.
   else do:
      yn = no.
      /* This is an EMT Shipper. The ASN is already transmitted. */
      {pxmsg.i &MSGNUM=4391 &ERRORLEVEL=1}
      /* Continue with Unconfirm ? */
      {pxmsg.i &MSGNUM=5987 &ERRORLEVEL=1 &CONFIRM=yn}

      if yn = no
      then
         l_flag1 = yes.
      else
         l_flag1 = no.
   end. /* ELSE DO */

END PROCEDURE. /*PROCEDURE p-del-trq_mstr */

PROCEDURE p-undo :
/*-----------------------------------------------------------------------
  Purpose: To avoid Action segment error .
  Parameters:   <None>
  Notes:
 -------------------------------------------------------------------------*/
   if l_undo
   then do:

      if not batchrun
      then
         pause.

   end. /* IF l_undo */
END PROCEDURE.

/* INTERNAL PROCEDURES changeShipperNumberInLogAcctDetail AND          */
/*   validateSOForLogisticsAccounting ARE DEFINED IN larcsois.i        */
{rcsoisla.i}

PROCEDURE DisplayMessage:
   define input parameter ipMsgNum as integer no-undo.
   define input parameter ipLevel  as integer no-undo.
   define input parameter ipMsg1   as character no-undo.

   {pxmsg.i &MSGNUM = ipMsgNum
            &ERRORLEVEL = ipLevel
            &MSGARG1    = ipMsg1}
END PROCEDURE.

PROCEDURE p_InitializeTempTableWorkLdd:
   for each work_ldd
      exclusive-lock:
      delete work_ldd.
   end. /* FOR EACH work_ldd */
END PROCEDURE. /* p_InitializeTempTableWorkLdd */


PROCEDURE p_PostFreightForLogAcctg:

   if use-log-acctg
      and l_calc_freight
      and tot_freight_gl_amt <> 0
   then do:

      /* IF LOGISTICS ACCOUNTING IS ENABLED THEN CREATE PENDING VOUCHER */
      /* MASTER AND DETAIL RECORDS AND POST THE FREIGHT TO THE GL.      */
      {gprunmo.i &module  = "LA" &program = "lafrpst.p"
                 &param   = """(input '{&TYPE_SOShipper}',
                                input substring(abs_mstr.abs_id,2),
                                input substring(abs__qad01,41,20), /*EXT-RF*/
                                input abs_mstr.abs_shp_date,
                                input eff_date,
                                input abs_mstr.abs_shipto,   /* SHIP-TO */
                                input '{&TYPE_SO}',
                                input first_so_curr,
                                input first_so_ex_rate,
                                input first_so_ex_rate2,
                                input ' ',  /* BLANK PVO_EX_RATETYPE */
                                input first_so_exru_seq)"""}

   end. /* IF USE-LOG-ACCTG AND ... */
END PROCEDURE. /*    p_PostFreightForLogAcctg */

PROCEDURE getControlFiles:

   define        parameter buffer gl_ctrl              for gl_ctrl.
   define        parameter buffer shc_ctrl             for shc_ctrl.
   define input  parameter enable_customer_consignment as character no-undo.
   define input  parameter adg                         as character no-undo.
   define input  parameter cust_consign_ctrl_table     as character no-undo.
   define output parameter use-log-acctg               as logical   no-undo.
   define output parameter using_cust_consignment      as logical   no-undo.
   define output parameter auto_post                   as logical   no-undo.
   define output parameter use_shipper                 as logical   no-undo.
   define output parameter consolidate                 as logical   no-undo.

   /* CHECK IF LOGISTICS ACCOUNTING IS ENABLED */
   {gprun.i ""lactrl.p"" "(output use-log-acctg)"}

   for first gl_ctrl
      fields( gl_domain gl_base_curr gl_rnd_mthd)
      where gl_ctrl.gl_domain = global_domain
   no-lock: end.

   /* CREATE SHIPPER CONTROL IF NOT FOUND */
   {gprun.i ""socrshc.p""}

   for first shc_ctrl
      fields( shc_domain shc_ship_nr_id shc_trl_amts)
      where shc_ctrl.shc_domain = global_domain
   no-lock: end.

   /* CREATE rcc_ctrl FILE RECORDS IF NECESSARY */
   {gprun.i ""rcpma.p""}

   /* DETERMINE IF CUSTOMER CONSIGNMENT IS ACTIVE */
   {gprun.i ""gpmfc01.p""
      "(input ENABLE_CUSTOMER_CONSIGNMENT,
        input 10,
        input ADG,
        input CUST_CONSIGN_CTRL_TABLE,
        output using_cust_consignment)"}

   /* FIND mfc_ctrl RECORDS FOR rcc_variables */
   for first mfc_ctrl
      fields( mfc_domain mfc_field mfc_logical)
      where mfc_ctrl.mfc_domain = global_domain
       and  mfc_field = "rcc_auto_post"
   no-lock:
      auto_post = mfc_logical.
   end. /* FOR FIRST MFC_CTRL */

   for first mfc_ctrl
      fields( mfc_domain mfc_field mfc_logical)
       where mfc_ctrl.mfc_domain = global_domain
        and  mfc_field = "rcc_use_shipper"
   no-lock:
      use_shipper = mfc_logical.
   end. /* FOR FIRST MFC_CTRL */

   for first mfc_ctrl
      fields( mfc_domain mfc_field mfc_logical)
       where mfc_ctrl.mfc_domain = global_domain
        and  mfc_field = "rcc_consolidate"
   no-lock:
      consolidate = mfc_logical.
   end. /* FOR FIRST MFC_CTRL */

END PROCEDURE.   /* getControlFiles */

PROCEDURE createImpExpHist:

   define parameter buffer sod_det for sod_det.
   define input parameter sod_qty_chg like sod_qty_chg no-undo.
   define input parameter p_absmstrid like abs_mstr.abs_id no-undo.
   define input parameter eff_date as date no-undo.

   if can-find(iec_ctrl where iec_ctrl.iec_domain = global_domain and
                                       iec_use_instat = yes)
   then do:

      /* CREATE IMPORT EXPORT HISTORY RECORD */
      {gprun.i ""iehistso.p"" "(buffer sod_det,
                                input sod_qty_chg,
                                input substring(p_absmstrid,2),
                                input 0,
                                input eff_date,
                                input ""SHIP"")"}
   end.

END PROCEDURE.   /* createImpExpHist */


PROCEDURE find_auto_post:
/*-----------------------------------------------------------------------
   Purpose:      To find auto_post.

   Parameters:   1. output  o_auto_post - logical if invoice auto post

   Note:         Procedure created to remove Error "Action Segment has exceeded
                 its limit of 63488 bytes".
-------------------------------------------------------------------------*/

   define input-output parameter o_auto_post like mfc_logical no-undo.

   for first work_abs_mstr
      where work_abs_mstr.abs_id begins "I"
   no-lock:

      {&RCSOIS1-P-TAG3}
      if work_abs_mstr.abs_order <> ""
      then do:

         {&RCSOIS1-P-TAG4}
         for first scx_ref
            fields( scx_domain scx_order scx_shipfrom scx_shipto scx_type)
            where scx_ref.scx_domain = global_domain
              and scx_type  = 1
              and scx_order = abs_order
         no-lock:
         end. /* FOR FIRST scx_ref */
      end. /* IF ABS_ORDER <> "" */

      else
         for first scx_ref
            fields( scx_domain scx_order scx_shipfrom scx_shipto scx_type)
            where scx_ref.scx_domain = global_domain
            and scx_type     = 1
            and scx_shipfrom = abs_shipfrom
            and scx_shipto   = abs_shipto
         no-lock:
         end. /* FOR FIRST scx_ref */
   end. /* FOR FIRST work_abs_mstr */

   if available scx_ref then
      for first so_mstr
         fields( so_domain so_bill so_cr_terms so_curr so_cust so_disc_pct
                 so_exru_seq so_ex_rate so_ex_rate2 so_ex_ratetype
                 so_fix_rate so_fr_terms so_invoiced so_inv_mthd
                 so_inv_nbr so_nbr so_pst_pct so_quote so_secondary
                 so_ship_date so_site so_slspsn so_stat so_tax_date
                 so_tax_pct so_to_inv so_trl1_amt so_trl1_cd
                 so_trl2_amt so_trl2_cd so_trl3_amt so_trl3_cd
                 so_bol so__qadc01)
         where so_mstr.so_domain = global_domain and so_nbr = scx_order
      no-lock:
         o_auto_post  = substring(so_inv_mthd,2,1) = "y".
      end.

END PROCEDURE.


PROCEDURE calculate_freight_charge:
/*-----------------------------------------------------------------------
   Purpose:      To calculate freight charge

   Parameters:   1. Buffer so_mstr
                 2. input i_l_calc_freight  - logical if freight is to be calculated

   Note:         Procedure created to remove Error "Action Segment has exceeded
                 its limit of 63488 bytes".
-------------------------------------------------------------------------*/


   define       parameter buffer so_mstr for so_mstr.
   define input parameter i_l_calc_freight like mfc_logical no-undo.
   define input parameter i_asn like abs_mstr.abs_id no-undo.

   if so_mstr.so_fr_terms <> ""
       and i_l_calc_freight
   then do:

      /*CALCULATE FREIGHT CHARGES*/
      for first ft_mstr
         fields( ft_domain ft_terms ft_type)
         where ft_mstr.ft_domain = global_domain
          and  ft_terms = so_fr_terms
      no-lock:
          old_ft_type = ft_type.
      end. /* FOR FIRST FT_MSTR */

      so_mstr_recid = recid(so_mstr).

      /* FREIGHT CHARGE AND WEIGHT CALC FOR SHIPMENTS */

      {gprun.i ""sofrcals.p""
               "(input table tt_sod_det,
                 input i_asn)"}

      for each tt_sod_det
      exclusive-lock:

         delete tt_sod_det.

      end. /* FOR EACH tt_sod_det */

      if not freight_ok
      then do:

         /* Freight error detected - */
         run DisplayMessage (input 669,
                              input 2,
                              input '').
         pause.
      end.

   end. /* IF SO_FR_TERMS <> "" AND i_L_CALC_FREIGHT */

END PROCEDURE.

PROCEDURE woValidate:

   define input  parameter ip_sod_lot    like sod_lot     no-undo.
   define input  parameter ip_sod_fa_nbr like sod_fa_nbr  no-undo.
   define output parameter op_wo_reject  like mfc_logical no-undo.

   op_wo_reject = no.

   if ip_sod_lot <> ""
   then do:

      for first wo_mstr
         fields (wo_domain wo_nbr wo_lot wo_status)
         where wo_domain = global_domain
           and wo_lot    = ip_sod_lot
         no-lock:
      end. /* FOR FIRST wo_mstr */

      if available wo_mstr
      and lookup(wo_status, "A,R,C") = 0
      then
         op_wo_reject = yes.

   end. /* IF ip_sod_lot <> "" */

   else do:

      if ip_sod_fa_nbr <> ""
      then do:

         for first wo_mstr
            fields (wo_domain wo_nbr wo_status)
            where wo_domain                = global_domain
              and wo_nbr                   = ip_sod_fa_nbr
              and lookup(wo_status, "A,R,C") = 0
            no-lock:
         end. /* FOR FIRST wo_mstr */

         if available wo_mstr
         then
            op_wo_reject = yes.

      end. /* IF ip_sod_fa_nbr <> "" */

   end. /* ELSE */

   if op_wo_reject = yes
   then do:

      /* WORK ORDER ID IS CLOSED, PLANNED OR */
      /* FIRM PLANNED                        */
      run DisplayMessage (input 523,
                          input 4,
                          input ":" + wo_nbr).

      /* CURRENT WORK ORDER STATUS: */
      run DisplayMessage (input 525,
                          input 1,
                          input wo_status).

   end. /* IF l_wo_reject = yes */

END PROCEDURE.  /* woValidate */

PROCEDURE CheckWOAndCMF:

   define input        parameter ip_abs_order like abs_mstr.abs_order no-undo.
   define input        parameter ip_abs_line  like abs_mstr.abs_line  no-undo.
   define output       parameter op_wo_reject like mfc_logical        no-undo.
   define output       parameter op_undo_var  like mfc_logical        no-undo.
   define input-output parameter io_que-doc   like mfc_logical        no-undo.

   define variable               l_woreject   like mfc_logical        no-undo.

   assign op_wo_reject = no
          op_undo_var  = no.

   for first so_mstr
      fields( so_domain so_bill so_cr_terms so_curr so_cust so_disc_pct
              so_exru_seq so_ex_rate so_ex_rate2 so_ex_ratetype
              so_fix_rate so_fr_terms so_invoiced so_inv_mthd
              so_inv_nbr so_nbr so_pst_pct so_quote
              so_secondary so_ship_date so_site so_slspsn
              so_stat so_tax_date so_tax_pct so_to_inv
              so_trl1_amt so_trl1_cd so_trl2_amt so_trl2_cd
              so_trl3_amt so_trl3_cd so_bol so__qadc01)
       where so_mstr.so_domain = global_domain
        and  so_nbr = ip_abs_order
      no-lock:
   end. /* FOR FIRST so_mstr */

   for first sod_det
      fields( sod_domain sod_btb_po sod_cum_qty sod_fsm_type sod_line
              sod_list_pr sod_nbr sod_part sod_price sod_pr_list
              sod_qty_chg sod_sched sod_site sod_std_cost
              sod_taxc sod_um sod_um_conv sod_lot sod_fa_nbr)
       where sod_det.sod_domain = global_domain
        and sod_nbr  = ip_abs_order
        and sod_line = integer(ip_abs_line)
      no-lock:
   end. /* FOR FIRST sod_det */

   /* CHECK IF WORK ORDER IS RELEASED OR ALLOCATED */
   /* FOR ATO CONFIGURED ITEMS                     */

   if available sod_det
   then do:

      /* CHECK WO STATUS */
      run woValidate(input  sod_lot,
                     input  sod_fa_nbr,
                     output l_woreject).

      if l_woreject = yes
      then do:
         op_wo_reject = yes.
         return.
      end. /* IF l_woreject = yes */

   end. /* IF AVAILABLE sod_det */

   if available so_mstr
      and available sod_det
   then
      if not so_secondary
   then
      for first cmf_mstr
         fields( cmf_domain cmf_doc_ref cmf_doc_type cmf_status
                 cmf_trans_nbr)
          where cmf_mstr.cmf_domain = global_domain
           and (cmf_doc_type = "PO"
           and cmf_doc_ref  = sod_btb_po
           and (cmf_status   = "1" or
                cmf_status   = "2" or
                cmf_status   = "3"   ) )
         no-lock:
      end. /* FOR FIRST cmf_mstr */

   else do:

      for first cmf_mstr
         fields( cmf_domain cmf_doc_ref cmf_doc_type cmf_status
                 cmf_trans_nbr)
          where cmf_mstr.cmf_domain = global_domain
            and cmf_doc_type        = "SO"
            and cmf_doc_ref         = so_nbr
            and cmf_status          = "1"
      no-lock:

         for first cmd_det
            fields( cmd_domain cmd_field cmd_key_val cmd_trans_nbr)
             where cmd_det.cmd_domain = global_domain
               and (cmd_trans_nbr     = cmf_trans_nbr
               and cmd_key_val        = so_nbr + "," + string(sod_line)
               and (cmd_field         = "sod_due_date" or
                    cmd_field         = "sod_qty_ord" ) )
         no-lock:
            change-queued = yes.
         end. /* FOR FIRST cmd_det */

      end. /* FOR FIRST cmf_mstr */

   end. /* ELSE */

   if available so_mstr
   and ((not so_secondary
   and available cmf_mstr )
   or (so_secondary and change-queued ))
   then do:

      /* CHANGE ON EMT SO WITH PENDING CHANGE IS NOT ALLOWED */
      run DisplayMessage (input 2834,
                          input 3,
                          input '').
      assign op_undo_var = yes.
      return.

   end. /* IF AVAILABLE so_mstr */

   /* THIS IS THE NORMAL SHIPMENT OF A SALES ORDER THUS */
   /* WE ONLY QUEUE A DOCUMENT IF THIS IS THE SECONDARY */
   /* SO BECAUSE FOR THE PRIMARY SO THIS CORRESPONDS TO */
   /* THE SHIPMENT OF A NORMAL SO AND NO DOCUMENT WILL  */
   /* BE QUEUED.                                        */

   /* THIS IS DIFFERENT IN THE PROGRAM rcsois2.p !!!!!!! */
   if available so_mstr
   and so_secondary
   and not io_que-doc
   then
      io_que-doc = yes.

END PROCEDURE.  /* CheckWOAndCMF */

PROCEDURE p_undo_records:
   define parameter buffer tt_so_mstr   for tt_so_mstr.
   define input  parameter p_txcalcref  like tx2d_ref no-undo.

   /* DELETE THE tx2d_det RECORDS IN CASE OF AN ERROR  WHEN THE TYPE */
   /* IS SO SHIPPER MAINTENANCE AND RESET sod_qty_chg TO ZERO        */

   for each tx2d_det exclusive-lock
      where tx2d_domain  = global_domain
      and   tx2d_ref     = p_txcalcref
      and   tx2d_tr_type = "14":

      /* RESET THE so_mstr FIELDS IN CASE OF AN ERROR */
      find first so_mstr
         where so_domain = global_domain
         and   so_nbr    = tx2d_nbr
         exclusive-lock.
      if available so_mstr
      then do:

         for first tt_so_mstr
            where tt_so_mstr.tt_so_nbr = so_nbr no-lock:
            assign
               so_to_inv    = tt_so_mstr.tt_so_to_inv
               so_invoiced  = tt_so_mstr.tt_so_invoiced
               so_ship_date = tt_so_mstr.tt_so_ship_date
               so_tax_date  = tt_so_mstr.tt_so_tax_date
               so_bol       = tt_so_mstr.tt_so_bol
               so__qadc01   = tt_so_mstr.tt_so__qadc01.
         end. /* for first tt_so_mstr */

      end. /* if available so_mstr */
      release so_mstr.

      for each sod_det exclusive-lock
         where sod_domain = global_domain
         and   sod_nbr    = tx2d_nbr
         and  (sod_line   = tx2d_line
         or    tx2d_line  = 0):

         sod_qty_chg = 0.

         {gprun.i ""txcalc.p""
            "(input  '13',
              input  sod_nbr,
              input  '',
              input  if tx2d_line = 0
                     then
                        0
                     else
                        sod_line,
              input  no,
              output return_status)"}

      end. /* FOR EACH sod_det */

      delete tx2d_det.

   end. /* FOR EACH tx2d_det */

END PROCEDURE. /* PROCEDURE p_undo_records */

{sotoinv.i}

PROCEDURE DisplayMessage1:
   define input        parameter pMsgNum   as   integer     no-undo.
   define input        parameter pLevel    as   integer     no-undo.
   define input-output parameter pconfirm  like mfc_logical no-undo.

   {pxmsg.i &MSGNUM=pmsgnum
            &ERRORLEVEL=plevel
            &CONFIRM=pconfirm}

END PROCEDURE.

PROCEDURE proc-archeck:
   define input-output parameter auto_post       like mfc_logical no-undo.
   define input-output parameter l_auto_noupdate like mfc_logical no-undo.
   if can-find(sbic_ctl
          where sbic_domain = global_domain
          and   sbic_active = yes)
      then do:
          if can-find(soc_ctrl
              where  soc_domain = global_domain
              and    soc_ar     = no)
          then
             assign
                auto_post       = no
                l_auto_noupdate = yes.

   end. /* IF CAN-FIND(sbic_ctl) */

END PROCEDURE.

PROCEDURE connect_vertex :

   /* RUN vqregopn.p TO SEE IF VERTEX SUTI API IS RUNNING, */
   /* AND THEN OPEN REGISTER DB                            */

   /* TRY AND FIND VERTEX TAX API'S PROCEDURE HANDLE. */
   {gpfindph.i vqapi l_api_handle}

   /* IF THERE IS NO PROCEDURE HANDLE WE ARE DONE. */
   if  auto_post
   and execname = "rcsois.p"
   and l_api_handle <> ?
   then do:

      {gprun.i ""vqregopn.p"" "(output result-status)"}
      hide message.

      if result-status = 0
      then
         l_vq_reg_db_open = yes.

      if  result-status <> 0
      then do:

         /* INVOICES WILL POST TO MFG/PRO BUT NOT UPDATE THE VERTEX */
         /* REGISTER */
         {pxmsg.i &MSGNUM=8880 &ERRORLEVEL=1}

         /* CONTINUE WITH INVOICE POST? */
         {pxmsg.i &MSGNUM=8881 &ERRORLEVEL=1 &CONFIRM=l_cont}
         if  l_cont = no
         then
            return error.

      end. /* IF  result-status <> 0... */

      if  result-status <> 0
      then do:
         do transaction:

            create qad_wkfl.
            assign
               qad_domain = global_domain
               qad_key1   = "l_vertex_message"
               qad_key2   = "yes"
               qad_key3   = "rcsois.p"
               qad_key4   = mfguser.

            if recid(qad_wkfl) = -1
            then.

         end. /* DO TRANSACTION */

      end. /* IF  result-status <> 0 */

   end. /* IF l_api_handle */

END PROCEDURE. /* connect_vertex */

PROCEDURE disconnect_vertex:

   /* CHECK IF VERTEX REGISTER DB WAS OPENED */
   if l_vq_reg_db_open
   then do:
      {gprun.i ""vqregcls.p""}
      l_vq_reg_db_open = no.
   end. /* IF l_vq_reg_db_open */

END PROCEDURE. /* disconnect_vertex */

PROCEDURE check_somstr:
   for each tt_somstr:
      for first so_mstr
         where so_domain = global_domain
           and so_nbr    = tt_sonbr
      exclusive-lock:
         if available so_mstr
         then
            so_to_inv = tt_sotoinv.
      end. /* FOR FIRST so_mstr */
      release so_mstr.
   end. /* FOR EACH tt_somstr */
END PROCEDURE. /* check_somstr */

PROCEDURE chk_shipto_prefix:
   define input parameter p_abs_shipfrom like abs_mstr.abs_shipfrom no-undo.
   define input parameter p_abs_id       like abs_mstr.abs_id       no-undo.
   define buffer b_abs_mstr for abs_mstr.

   find first b_abs_mstr
      where abs_domain   = global_domain
      and   abs_shipfrom = p_abs_shipfrom
      and   abs_id       = p_abs_id
   exclusive-lock no-wait no-error.

   if     available b_abs_mstr
      and abs__qad05 <> abs_shipto
   then do:
       for first ad_mstr
          fields (ad_domain ad_addr)
          where ad_domain = abs_domain
          and   ad_addr   = abs_shipto
          no-lock:
       end. /* FOR FIRST ad_mstr */

       if not available ad_mstr
       then do:
          for first ad_mstr
             fields (ad_domain ad_addr)
             where ad_domain = abs_domain
             and   ad_addr   = abs__qad05
             no-lock:
          end. /* FOR FIRST ad_mstr */

          if available ad_mstr then
             abs_shipto  = ad_addr.
       end. /* IF NOT AVAILABLE ad_mstr */
    end. /* IF NOT AVAILABLE b_abs_mstr */

END PROCEDURE. /* chk_shipto_prefix */

PROCEDURE abs_audit:
   define variable l_msg as character format "x(80)" no-undo.

   /* SHIPPER NOT CONFIRMED. PLEASE CHECK 'shipper.err' FOR DETAILS. */
   {pxmsg.i &MSGNUM=7640
            &ERRORLEVEL=2}

   /* NO MATCHING SALES ORDER/LINE FOR FOLLOWING ITEMS IN SHIPPER # */
   {pxmsg.i &MSGNUM=7642
            &ERRORLEVEL=1
            &MSGARG1=substring(abs_mstr.abs_id,2,20)
            &MSGBUFFER=l_msg}.

   output stream abs to "shipper.err".

      put stream abs l_msg.

      for each work_abs_mstr
         where work_abs_mstr.abs_id begins "ic"
            or work_abs_mstr.abs_id begins "is"
      no-lock:
         disp stream abs
            work_abs_mstr.abs_item
            work_abs_mstr.abs_qty
            work_abs_mstr.abs_site
            work_abs_mstr.abs_loc
            work_abs_mstr.abs_lotser
            work_abs_mstr.abs_ref.
      end. /* FOR EACH work_abs_mstr */

   output stream abs close.

END PROCEDURE. /* END abs_audit */
