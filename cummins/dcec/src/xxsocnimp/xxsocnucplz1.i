/* GUI CONVERTED from socnucpl.i (converter v1.78) Wed Mar  9 02:26:36 2011 */
/* socnucpl.i - Sales Order Consignment Usage Common Procedure Library        */
/* Copyright 1986-2011 QAD Inc., Santa Barbara, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*                                                                            */
/* Revision: 1.1         BY: Robin McCarthy       DATE: 10/01/05  ECO: *P3MZ* */
/* Revision: 1.1.2.1     BY: Laxmikant Bondre     DATE: 03/24/09  ECO: *Q2MG* */
/* Revision: 1.1.2.2     BY: Prabu M              DATE: 05/27/09  ECO: *Q2Y0* */
/* Revision: 1.1.2.3     BY: Rajalaxmi Ganji      DATE: 01/14/10  ECO: *Q3RT* */
/* $Revision: 1.1.2.4 $  BY: Karthikeyan B       DATE: 03/09/11  ECO: *Q4PC* */
/*-Revision end---------------------------------------------------------------*/

/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */
/*                                                                          */
/*         THIS PROGRAM IS A BOLT-ON TO STANDARD PRODUCT MFG/PRO.           */
/* ANY CHANGES TO THIS PROGRAM MUST BE PLACED ON A SEPARATE ECO THAN        */
/* STANDARD PRODUCT CHANGES.  FAILURE TO DO THIS CAUSES THE BOLT-ON CODE TO */
/* BE COMBINED WITH STANDARD PRODUCT AND RESULTS IN PATCH DELIVERY FAILURES.*/
/*                                                                          */
/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */

/*V8:ConvertMode=Maintenance                                                  */

/* ========================================================================== */
PROCEDURE getName:
/* --------------------------------------------------------------------------
 * Purpose:      This procedure gets the customer or ship-to name.
 * -------------------------------------------------------------------------- */
   define input  parameter p_shipto           as character no-undo.
   define output parameter p_shipto_name      as character no-undo.

   define buffer ad_mstr for ad_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      p_shipto_name = "".

      for first ad_mstr
         fields (ad_domain ad_sort)
         where   ad_domain = global_domain
         and    (ad_addr = p_shipto
         and    (ad_type = "ship-to" or ad_type = "customer") )
      no-lock:
         p_shipto_name = ad_sort.
      end.

   end.   /* DO ON ERROR UNDO */

   return {&SUCCESS-RESULT}.

END PROCEDURE.   /* getName */

/* ========================================================================== */
PROCEDURE getPartDescription:
/* --------------------------------------------------------------------------
 * Purpose:      This procedure gets the part description field.
 * -------------------------------------------------------------------------- */
   define input  parameter p_part             as character no-undo.
   define output parameter p_part_desc        as character no-undo.

   define buffer pt_mstr for pt_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      p_part_desc = "".

      for first pt_mstr
         fields (pt_domain pt_desc1)
         where   pt_domain = global_domain
         and     pt_part = p_part
      no-lock:
         p_part_desc = pt_desc1.
      end.

   end.   /* DO ON ERROR UNDO */

   return {&SUCCESS-RESULT}.

END PROCEDURE.   /* getPartDescription */

/* ========================================================================== */
PROCEDURE getLanguageDetail:
/* --------------------------------------------------------------------------
 * Purpose:      Get language detail for the string entered by user.
 * -------------------------------------------------------------------------- */
   define input  parameter ip_sortby   as character no-undo.
   define input  parameter ip_dataset  as character no-undo.
   define output parameter op_key1     as character no-undo.
   define output parameter op_recno    as recid     no-undo.

   define buffer lngd_det for lngd_det.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      op_recno = ?.
      if global_lngd_raw then
         for first lngd_det where
            lngd_dataset = ip_dataset     and
            lngd_key1    begins ip_sortby and
            lngd_key2    <> ""            and
            lngd_key3    =  ""            and
            lngd_key4    =  ""            and
            lngd_field   = "sortby"       and
            lngd_lang    = global_user_lang
            no-lock: end.
      else
         for first lngd_det where
            lngd_dataset = ip_dataset     and
            lngd_key1    <> ""            and
            lngd_key2    begins ip_sortby and
            lngd_key3    =  ""            and
            lngd_key4    =  ""            and
            lngd_field   = "sortby"       and
            lngd_lang    = global_user_lang
         no-lock: end.

      if not available lngd_det then do:
         {pxmsg.i &MSGNUM=712 &ERRORLEVEL=3} /* INVALID OPTION */
      end.
      else
         assign
            op_key1 = lngd_key1
            op_recno = recid(lngd_det).

   end.   /* DO ON ERROR UNDO */

   return {&SUCCESS-RESULT}.

END PROCEDURE.   /* getLanguageDetail */

/* ========================================================================== */
PROCEDURE getLanguageDetailMnemonic:
/* --------------------------------------------------------------------------
 * Purpose:     Convert the numeric equivalent for sortby to mnemonic code
 * -------------------------------------------------------------------------- */
   define input  parameter ip_dataset      as character no-undo.
   define input  parameter ip_sortby       as character no-undo.
   define output parameter op_sortby_label as character no-undo.

   define buffer lngd_det for lngd_det.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      {gplngn2a.i &file     = ip_dataset
                  &field    = ""sortby""
                  &code     = ""sortby_num""
                  &mnemonic = ip_sortby
                  &label    = op_sortby_label}

   end.   /* DO ON ERROR UNDO */

   return {&SUCCESS-RESULT}.

END PROCEDURE.   /* getLanguageDetailMnemonic */

/* ========================================================================== */
PROCEDURE updateAutoCreateTable:
/* --------------------------------------------------------------------------
 * Purpose:     Read the temp-table and update each record with the
 *              customer usage ID and self-bill payment authorization.
 * -------------------------------------------------------------------------- */
   define input        parameter  ip_cust_usage_ref  as character no-undo.
   define input        parameter  ip_cust_usage_date as date      no-undo.
   define input        parameter  ip_selfbill_auth   as character no-undo.
   define input-output parameter  table              for tt_autocr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      /* UPDATE THE AUTOCREATE TEMP-TABLE */
      for each tt_autocr
      exclusive-lock:
         assign
            tt_autocr.ac_cust_usage_ref  = ip_cust_usage_ref
            tt_autocr.ac_cust_usage_date = ip_cust_usage_date
            tt_autocr.ac_selfbill_auth   = ip_selfbill_auth.
      end.
   end.

   return {&SUCCESS-RESULT}.

END PROCEDURE.   /* updateAutoCreateTable */

/* ========================================================================== */
PROCEDURE loadSOUpdateTable:
/* --------------------------------------------------------------------------
 * Purpose:     Locate data matching selection criteria to build temp-table.
 * -------------------------------------------------------------------------- */
   define input        parameter ip_shipto         as  character        no-undo.
   define input        parameter ip_cust           as  character        no-undo.
   define input        parameter ip_shipfrom       as  character        no-undo.
   define input        parameter ip_shipfrom1      as  character        no-undo.
   define input        parameter ip_sopart         as  character        no-undo.
   define input        parameter ip_sopart1        as  character        no-undo.
   define input        parameter ip_po             as  character        no-undo.
   define input        parameter ip_po1            as  character        no-undo.
   define input        parameter ip_nbr            as  character        no-undo.
   define input        parameter ip_nbr1           as  character        no-undo.
   define input        parameter ip_part           as  character        no-undo.
   define input        parameter ip_part1          as  character        no-undo.
   define input        parameter ip_auth           as  character        no-undo.
   define input        parameter ip_auth1          as  character        no-undo.
   define input        parameter ip_cust_job       as  character        no-undo.
   define input        parameter ip_cust_job1      as  character        no-undo.
   define input        parameter ip_seq            as  character        no-undo.
   define input        parameter ip_seq1           as  character        no-undo.
   define input        parameter ip_cust_ref       as  character        no-undo.
   define input        parameter ip_cust_ref1      as  character        no-undo.
   define input        parameter ip_shipper        as  character        no-undo.
   define input        parameter ip_shipper1       as  character        no-undo.
   define input-output parameter table             for tt_so_update.

   define variable     shipper_id                  as  character        no-undo.
   define variable     inventory_domain            as  character        no-undo.

   define buffer       so_mstr                     for so_mstr.
   define buffer       sod_det                     for sod_det.
   define buffer       si_mstr                     for si_mstr.
   define buffer       rqm_det                     for rqm_det.
   define buffer       rcsd_det                    for rcsd_det.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      for each so_mstr
         where so_domain   = global_domain
         and   so_cust_po >= ip_po
         and   so_cust_po <= ip_po1
         and  (so_cust     = ip_cust   or ip_cust = "")
         and   so_nbr     >= ip_nbr
         and   so_nbr     <= ip_nbr1
         and  (so_ship     = ip_shipto or ip_shipto = "")
      no-lock
      by so_domain
      by so_cust_po
      by so_cust
      by so_nbr:

         for each sod_det
            where sod_domain    = global_domain
            and   sod_part     >= ip_part     and sod_part     <= ip_part1
            and   sod_nbr       = so_nbr
            and   sod_site     >= ip_shipfrom and sod_site     <= ip_shipfrom1
            and   sod_custpart >= ip_sopart   and sod_custpart <= ip_sopart1
            and   sod_consignment
            and   sod_confirm
         no-lock
         break by sod_site:

            if first-of(sod_site) then
               for first si_mstr
                  where  si_domain = global_domain
                  and    si_site   = sod_site
               no-lock:
                  inventory_domain = si_db.
               end.

            /* USAGE BY AUTHORIZATION */
            if ip_auth1 <> "" then
               for each rqm_det
                  where rqm_domain = global_domain
                  and   rqm_type   > 0
                  and   rqm_nbr    = sod_nbr
                  and   rqm_line   = sod_line
               no-lock:

                  if rqm_value >= ip_auth
                     and rqm_value <= ip_auth1
                  then
                     if not can-find (first tt_so_update
                        where tt_inventory_domain = inventory_domain
                        and   tt_so_nbr           = so_nbr
                        and   tt_sod_line         = sod_line
                        and   tt_cncix_auth       = rqm_value)
                     then
                        run createSOUpdateTable
                           (input inventory_domain,
                            input so_nbr,
                            input sod_line,
                            input sod_site,
                            input sod_cum_qty[4],
                            input sod_cum_date[4],
                            input sod_qty_inv,
                            input sod_list_pr,
                            input sod_price,
                            input rqm_value,
                            input "",              /* CUST JOB */
                            input "",              /* CUST SEQ */
                            input "",              /* CUST REF */
                            input "",              /* SHIPPER  */
                            buffer tt_so_update).

               end.   /* FOR EACH rqm_det */

            /* USAGE BY SEQUENCE */
            else if ip_cust_job1 <> ""
               or ip_seq1 <> ""
               or ip_cust_ref1 <> ""
            then
               for each rcsd_det
                  where rcsd_domain = global_domain
                  and   rcsd_order  = sod_nbr
                  and   rcsd_line   = sod_line
               no-lock:
                  if rcsd_cust_job >= ip_cust_job
                     and rcsd_cust_job <= ip_cust_job1
                     and rcsd_cust_seq >= ip_seq and rcsd_cust_seq <= ip_seq1
                     and rcsd_cust_ref >= ip_cust_ref
                     and rcsd_cust_ref <= ip_cust_ref1
                  then
                     if not can-find (first tt_so_update
                        where tt_inventory_domain = inventory_domain
                        and   tt_so_nbr           = so_nbr
                        and   tt_sod_line         = sod_line
                        and   tt_cncix_cust_job   = rcsd_cust_job
                        and   tt_cncix_cust_seq   = rcsd_cust_seq
                        and   tt_cncix_cust_ref   = rcsd_cust_ref)
                     then
                        run createSOUpdateTable
                           (input inventory_domain,
                            input so_nbr,
                            input sod_line,
                            input sod_site,
                            input sod_cum_qty[4],
                            input sod_cum_date[4],
                            input sod_qty_inv,
                            input sod_list_pr,
                            input sod_price,
                            input "",              /* AUTHORIZATION */
                            input rcsd_cust_job,
                            input rcsd_cust_seq,
                            input rcsd_cust_ref,
                            input "",              /* SHIPPER  */
                            buffer tt_so_update).

               end.   /* FOR EACH rcsd_det */

            /* USAGE BY SHIPPER */
            else if ip_shipper1 <> ""
            then
               for each cncix_mstr
                  where cncix_domain    = global_domain
                  and   cncix_so_nbr    = so_nbr
                  and   cncix_sod_line  = sod_line
               no-lock:

                  if cncix_site            >= ip_shipfrom
                     and cncix_site        <= ip_shipfrom1
                     and cncix_asn_shipper >= ip_shipper
                     and cncix_asn_shipper <= ip_shipper1
                  then do:
                     shipper_id = cncix_asn_shipper.

                     if not can-find (first tt_so_update
                        where tt_inventory_domain = inventory_domain
                        and   tt_so_nbr           = so_nbr
                        and   tt_sod_line         = sod_line
                        and   tt_shipper          = shipper_id)
                     then
                        run createSOUpdateTable
                           (input inventory_domain,
                            input so_nbr,
                            input sod_line,
                            input sod_site,
                            input sod_cum_qty[4],
                            input sod_cum_date[4],
                            input sod_qty_inv,
                            input sod_list_pr,
                            input sod_price,
                            input "",              /* AUTHORIZATION */
                            input "",              /* CUST JOB */
                            input "",              /* CUST SEQ */
                            input "",              /* CUST REF */
                            input shipper_id,
                            buffer tt_so_update).

                  end.   /* IF cncix_site >= ip_shipfrom */
               end.   /* FOR EACH cncix_mstr */

               /* STANDARD USAGE */
               else if not can-find (first tt_so_update
                  where tt_inventory_domain = inventory_domain
                  and   tt_so_nbr           = so_nbr
                  and   tt_sod_line         = sod_line)
               then
                  run createSOUpdateTable
                     (input inventory_domain,
                      input so_nbr,
                      input sod_line,
                      input sod_site,
                      input sod_cum_qty[4],
                      input sod_cum_date[4],
                      input sod_qty_inv,
                      input sod_list_pr,
                      input sod_price,
                      input "",              /* AUTHORIZATION */
                      input "",              /* CUST JOB */
                      input "",              /* CUST SEQ */
                      input "",              /* CUST REF */
                      input "",              /* SHIPPER  */
                      buffer tt_so_update).

         end.   /* sod_det */
      end.   /* so_mstr */
   end.   /* DO ON ERROR UNDO */

   return {&SUCCESS-RESULT}.

END PROCEDURE.   /* loadSOUpdateTable */

/* ========================================================================== */
PROCEDURE createSOUpdateTable:
/* --------------------------------------------------------------------------
 * Purpose:     Create temp-table record matching selection criteria.
 * -------------------------------------------------------------------------- */
   define input        parameter ip_domain         as   character       no-undo.
   define input        parameter ip_order          as   character       no-undo.
   define input        parameter ip_line           as   integer         no-undo.
   define input        parameter ip_site           as   character       no-undo.
   define input        parameter ip_cum_qty        as   decimal         no-undo.
   define input        parameter ip_cum_date       as   date            no-undo.
   define input        parameter ip_qty_inv        like sod_qty_inv     no-undo.
   define input        parameter ip_list_price     like sod_list_pr     no-undo.
   define input        parameter ip_price          like sod_price       no-undo.
   define input        parameter ip_auth           as   character       no-undo.
   define input        parameter ip_cust_job       as   character       no-undo.
   define input        parameter ip_seq            as   character       no-undo.
   define input        parameter ip_cust_ref       as   character       no-undo.
   define input        parameter ip_shipper        as   character       no-undo.
   define              parameter buffer tt_so_update for tt_so_update.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      create tt_so_update.
      assign
         tt_inventory_domain = ip_domain
         tt_so_nbr           = ip_order
         tt_sod_line         = ip_line
         tt_sod_site         = ip_site
         tt_sod_cum_qty      = ip_cum_qty
         tt_sod_cum_date     = ip_cum_date
         tt_sod_qty_inv      = ip_qty_inv
         tt_sod_list_pr      = ip_list_price
         tt_sod_price        = ip_price
         tt_cncix_auth       = ip_auth
         tt_cncix_cust_job   = ip_cust_job
         tt_cncix_cust_seq   = ip_seq
         tt_cncix_cust_ref   = ip_cust_ref
         tt_shipper          = ip_shipper.

      if recid(tt_so_update) = -1 then .

   end.   /* DO ON ERROR UNDO */

   return {&SUCCESS-RESULT}.

END PROCEDURE.   /* createSOUpdateTable */

/* ========================================================================== */
PROCEDURE switchDomain:
/* -------------------------------------------------------------------------- */
   define input        parameter ip_domain         as character         no-undo.
   define output       parameter op_undo           as logical           no-undo.

   define variable err-flag                        as integer           no-undo.


   /* SWITCH TO INVOICE DOMAIN */
   {gprun.i ""gpmdas.p""
            "(input  ip_domain,
              output err-flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   if err-flag <> 0 then do:
      /* DOMAIN # IS NOT AVAILABLE */
      {pxmsg.i &MSGNUM=6137 &ERRORLEVEL=4 &MSGARG1=ip_domain}

      assign
         global_domain = ip_domain
         op_undo       = yes.
   end.

END PROCEDURE.   /* switchDomain */

/* ========================================================================== */
PROCEDURE Housekeeping:
/* -------------------------------------------------------------------------- */
   define input-output parameter table         for tt_autocr.
   define input-output parameter table         for tt_so_update.

   /* DELETE TEMP-TABLES */
   for each tt_autocr exclusive-lock:
      delete tt_autocr.
   end.

   for each tt_so_update exclusive-lock:
      delete tt_so_update.
   end.

   /* DELETE sr_wkfl AND LOT WORK FILES */
   {gprun.i ""socnuac1.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


END PROCEDURE.   /* Housekeeping */

/* ========================================================================== */
PROCEDURE postProcessCleanup:
/* -------------------------------------------------------------------------- */
   define input-output parameter table         for tt_autocr.
   define input-output parameter table         for tt_so_update.
   define input        parameter ip_domain     as  character            no-undo.
   define input        parameter ip_tmp_ref    as  character            no-undo.

   define variable undo_flag                   as logical               no-undo.

   if ip_domain <> global_domain then do:
      /* SWITCH TO INVOICE DOMAIN */
      run switchDomain
         (input  ip_domain,
          output undo_flag).

      if undo_flag then do:
         global_ref = ip_tmp_ref.
         undo, return.
      end.
   end.

   run Housekeeping
      (input-output table tt_autocr,
       input-output table tt_so_update).

   /* RESET GLOBAL_REF */
   global_ref = ip_tmp_ref.

END PROCEDURE.   /* postProcessCleanup */


/* ========================================================================== */
PROCEDURE proc_check_restricted:
/* -------------------------------------------------------------------------- *
 * Purpose: This procedure calls socncnal.p for checking                      *
 *          Restricted Transactions.                                          *
 * -------------------------------------------------------------------------- */
   define input  parameter p_ip_trans as character no-undo.
   define output parameter p_op_undo  as logical   no-undo.

   if can-find(first  sr_wkfl
         where sr_domain = global_domain
         and   sr_userid = mfguser
         and   sr_lineid = string(tt_autocr.ac_count)
         and   sr_qty    <> 0)
   then do:

      for each sr_wkfl
         where sr_domain = global_domain
         and   sr_userid = mfguser
         and   sr_lineid = string(tt_autocr.ac_count)
         and   sr_qty    <> 0
      no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.

         {gprun.i ""socncnal.p""
                  "(input  p_ip_trans,
                    input  tt_autocr.ac_order,
                    input  tt_autocr.ac_line,
                    input  sr_site,
                    input  sr_loc,
                    input  tt_autocr.ac_part,
                    input  sr_lotser,
                    input  sr_ref,
                    input  sr_qty,
                    input  tt_autocr.ac_consumed_um,
                    input  tt_autocr.ac_stock_um,
                    output p_op_undo)"}
/*GUI*/ if global-beam-me-up then undo, leave.

      end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /*FOR EACH sr_wkfl */
   end. /* IF CAN-FIND sr_wkfl THEN */
   else do:
      {gprun.i ""socncnal.p""
               "(input  p_ip_trans,
                 input  tt_autocr.ac_order,
                 input  tt_autocr.ac_line,
                 input  tt_autocr.ac_site,
                 input  tt_autocr.ac_loc,
                 input  tt_autocr.ac_part,
                 input  tt_autocr.ac_lotser,
                 input  tt_autocr.ac_ref,
                 input  tt_autocr.ac_tot_qty_consumed,
                 input  tt_autocr.ac_consumed_um,
                 input  tt_autocr.ac_stock_um,
                 output p_op_undo)"}
/*GUI*/ if global-beam-me-up then undo, leave.

   end. /* ELSE */
END PROCEDURE. /* PROCEDURE proc_check_restricted */
