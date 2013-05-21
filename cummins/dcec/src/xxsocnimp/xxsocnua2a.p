/* socnua2a.p - Sales Order Consignment Usage Process Temp-Table Program      */
/* Copyright 1986-2010 QAD Inc., Santa Barbara, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*                                                                            */
/* Revision: 1.1       BY: Robin McCarthy         DATE: 10/01/05  ECO: *P3MZ* */
/* Revision: 1.1.3.1   BY: Vijaykumar Patil       DATE: 03/27/06  ECO: *P4MH* */
/* Revision: 1.1.3.2   BY: Vijaykumar Patil       DATE: 03/30/06  ECO: *P4MH* */
/* Revision: 1.1.3.4   BY: Mochesh Chandran       DATE: 06/12/06  ECO: *P4TF* */
/* Revision: 1.1.3.6   BY: Sanat Paul             DATE: 07/05/07  ECO: *P5KL* */
/* Revision: 1.1.3.7   BY: Dilip Manawat          DATE: 09/07/07  ECO: *P670* */
/* Revision: 1.1.3.12  BY: Mallika Poojary        DATE: 01/30/09  ECO: *Q29Z* */
/* Revision: 1.1.3.13  BY: Anish Mandalia         DATE: 02/22/09  ECO: *Q2G5* */
/* $Revision: 1.1.3.14 $       BY: Prabu M          DATE: 05/27/10  ECO: *Q43C* */
/*-Revision end---------------------------------------------------------------*/

/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */
/*                                                                          */
/*         THIS PROGRAM IS A BOLT-ON TO STANDARD PRODUCT MFG/PRO.           */
/* ANY CHANGES TO THIS PROGRAM MUST BE PLACED ON A SEPARATE ECO THAN        */
/* STANDARD PRODUCT CHANGES.  FAILURE TO DO THIS CAUSES THE BOLT-ON CODE TO */
/* BE COMBINED WITH STANDARD PRODUCT AND RESULTS IN PATCH DELIVERY FAILURES.*/
/*                                                                          */
/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */

/*V8:ConvertMode=NoConvert                                                    */

{mfdeclre.i}
{gpoidfcn.i}   /* Defines nextOidValue() function */

{pxsevcon.i}
{socnutmp.i}   /* COMMON USAGE TEMP-TABLE DEFINITIONS */
{socnvars.i}

/* MUST INCLUDE gprunpdf.i IN THE MAIN BLOCK OF THE PROGRAM SO THAT */
/* CALLS TO gprunp.i FROM ANY OF THE INTERNAL PROCEDURES SKIPS      */
/* DEFINITION OF SHARED VARS OF gprunpdf.i                          */
/* FOR FURTHER INFO REFER TO HEADER COMMENTS IN gprunp.i            */
{gprunpdf.i "mcpl" "p"}

/* PARAMETERS */
define input-output parameter table                         for bUsage.
define input-output parameter table                         for tt_so_update.
define              parameter buffer  bConsignedShipment    for cncix_mstr.
define              parameter buffer  bConsignedUsageMaster for cncu_mstr.
define input        parameter invoice_domain    as   character          no-undo.
define input        parameter origin            as   character          no-undo.
define input-output parameter effdate           like glt_effdate        no-undo.
define input-output parameter continue-yn       like mfc_logical        no-undo.
define input-output parameter save_sbinfo       like mfc_logical        no-undo.
define input-output parameter residual_qty      like cncix_qty_stock    no-undo.
define input-output parameter working_trnbr     as   integer            no-undo.
define input-output parameter scheduled         like mfc_logical        no-undo.
define input-output parameter curr_rlse_id      as   character          no-undo.
define input-output parameter cum_shipped_qty   as   decimal            no-undo.
define input-output parameter shipfrom_site     as   character          no-undo.
define input-output parameter prior_cum_qty     as   decimal            no-undo.
define input-output parameter batch             as   character          no-undo.
define input-output parameter ac_part           like ac_part            no-undo.
define input-output parameter ac_site           like ac_site            no-undo.
define input-output parameter ac_ship           like ac_ship            no-undo.
define input-output parameter ac_cust           like ac_cust            no-undo.
define input-output parameter ac_sopart         like ac_sopart          no-undo.
define input-output parameter ac_order          like ac_order           no-undo.
define input-output parameter ac_line           like ac_line            no-undo.
define input-output parameter ac_asn_shipper    like ac_asn_shipper     no-undo.
define input-output parameter ac_auth           like ac_auth            no-undo.
define input-output parameter ac_cust_job       like ac_cust_job        no-undo.
define input-output parameter ac_cust_seq       like ac_cust_seq        no-undo.
define input-output parameter ac_cust_ref       like ac_cust_ref        no-undo.
define input-output parameter ac_eff_date       like ac_eff_date        no-undo.
define input-output parameter ac_consumed_um_conv
                                             like ac_consumed_um_conv   no-undo.
define input-output parameter ac_consumed_um    like ac_consumed_um     no-undo.
define input-output parameter ac_cust_usage_ref
                                                like ac_cust_usage_ref  no-undo.
define input-output parameter ac_cust_usage_date
                                                like ac_cust_usage_date no-undo.
define input-output parameter ac_selfbill_auth  like ac_selfbill_auth   no-undo.
define input-output parameter ac_tot_qty_consumed
                                               like ac_tot_qty_consumed no-undo.
define input-output parameter ac_lotser        like ac_lotser           no-undo.
define input-output parameter ac_ref           like ac_ref              no-undo.
define input-output parameter ac_loc           like ac_loc              no-undo.
define input-output parameter ac_count         like ac_count            no-undo.
define output       parameter op_error         as   integer             no-undo.
define variable     l_consigned_qty            like cncix_qty_stock     no-undo.
define shared temp-table work_trnbr no-undo
   field work_sod_nbr  like sod_nbr
   field work_sod_line like sod_line
   field work_tr_recid like tr_trnbr
index work_sod_nbr work_sod_nbr ascending.

/* DETERMINE IF LOT/SERIAL MATERIAL */
if can-find(first sr_wkfl
   where sr_domain = global_domain
   and   sr_userid = mfguser
   and   sr_lineid = string(ac_count)
   and   sr_qty    <> 0)
then do:

   /* IF LOT OR SERIAL, THEN READ sr_wkfl */
   for each sr_wkfl
      where sr_domain = global_domain
      and   sr_userid = mfguser
      and   sr_lineid = string(ac_count)
      and   sr_qty    <> 0
   exclusive-lock:

      /* INITIALIZE WORKING TRANSACTION ID */
      working_trnbr = 0.

      /* VERIFY SHIPMENT X-REFERENCE */
      run verifyShipmentData
         (input ac_part,
          input sr_site,
          input ac_ship,
          input ac_cust,
          input ac_sopart,
          input ac_order,
          input ac_line,
          input sr_loc,
          input sr_lotser,
          input sr_ref,
          input ac_asn_shipper,
          input ac_auth,
          input ac_cust_job,
          input ac_cust_seq,
          input ac_cust_ref,
          output continue-yn).

      if continue-yn = no then do:
         op_error = 2.
         leave.
      end.

      /* THE SEQUENCE DATA IS CONDITIONAL BECAUSE SOME */
      /* CUSTOMERS DO REPORT THE SEQUENCES USED, EVEN  */
      /* THOUGH THEY USE SEQUENCE SCHEDULES.           */
      for each bConsignedShipment
         where cncix_domain      = global_domain
         and   cncix_part        = ac_part
         and   cncix_site        = sr_site
         and   cncix_shipto      = ac_ship
         and   cncix_cust        = ac_cust
         and   cncix_custpart    = ac_sopart
         and   cncix_so_nbr      = ac_order
         and   cncix_sod_line    = ac_line
         and   cncix_current_loc = sr_loc
         and   cncix_lotser      = sr_lotser
         and   cncix_ref         = sr_ref
         and   cncix_auth        = ac_auth
         and  (ac_cust_job       = ""
         or   (cncix_cust_job    = ac_cust_job
         and   ac_cust_job       <> ""))
         and  (ac_cust_seq       = ""
         or   (cncix_cust_seq    = ac_cust_seq
         and   ac_cust_seq       <> ""))
         and  (ac_cust_ref       = ""
         or   (cncix_cust_ref    = ac_cust_ref
         and   ac_cust_ref       <> ""))
         and  (ac_asn_shipper    = ""
         or   (cncix_asn_shipper = ac_asn_shipper
         and   ac_asn_shipper    <> ""))
         and   cncix_qty_stock   > 0
      exclusive-lock
      break by cncix_ship_date:

         /* EXACT OR PARTIAL sr_qty QUANTITY */
         if cncix_qty_stock >= (sr_qty * ac_consumed_um_conv)
         then do:

            /* CREATE CONSIGNED USAGE */
            run createConsignedUsage
               (input        sr_qty,
                input        ac_consumed_um,
                input        ac_consumed_um_conv,
                input        ac_cust_usage_ref,
                input        ac_cust_usage_date,
                input        ac_eff_date,
                input        origin,
                input        save_sbinfo,
                input        ac_selfbill_auth,
                input        ac_tot_qty_consumed,
                input        sr_qty,
                input-output batch,
                input-output working_trnbr,
                buffer       bUsage,
                buffer       bConsignedShipment).

            /* ALL DONE !! */
            leave.

         end.  /* IF cncix_qty_stock >= (sr_qty * ac_consumed_um_conv) */

         /* EXCESS sr_qty QUANTITY */
         if (sr_qty * ac_consumed_um_conv) > cncix_qty_stock
         then do:
            if first(cncix_ship_date) then
            /* POPULATE CONSIGNMENT TOTAL */
            run chkconsgqty
              (input ac_part,
               input sr_site,
               input ac_ship,
               input ac_cust,
               input ac_sopart,
               input ac_order,
               input ac_line,
               input sr_loc,
               input sr_lotser,
               input sr_ref,
               input ac_asn_shipper,
               input ac_auth,
               input ac_cust_job,
               input ac_cust_seq,
               input ac_cust_ref,
               output l_consigned_qty).

            if (sr_qty * ac_consumed_um_conv) > l_consigned_qty
            then do:
               for first loc_mstr no-lock
                  where loc_domain = global_domain
                  and   loc_loc = cncix_current_loc:
               end.
               if available loc_mstr
               then do:
                  for first is_mstr no-lock
                     where is_domain = global_domain
                     and   is_status = loc_status :
                  end.
                  if available is_mstr and is_overissue = no
                  then do:
             /* Quantity Available For Item */
                     {pxmsg.i &MSGNUM=237
                              &MSGARG1=cncix_part
                              &MSGARG2="":""
                              &MSGARG3=cncix_qty_stock
                              &ERRORLEVEL=3 }
                     next.
                  end. /* IF AVAILABLE is_mstr and is_overissue = no */
          else
                  if is_overissue = yes
                  then do:
                     /* CREATE CONSIGNED USAGE */
                     run createConsignedUsage
                     (input        sr_qty,
                      input        ac_consumed_um,
                      input        ac_consumed_um_conv,
                      input        ac_cust_usage_ref,
                      input        ac_cust_usage_date,
                      input        ac_eff_date,
                      input        origin,
                      input        save_sbinfo,
                      input        ac_selfbill_auth,
                      input        ac_tot_qty_consumed,
                      input        sr_qty,
                      input-output batch,
                      input-output working_trnbr,
                      buffer       bUsage,
                      buffer       bConsignedShipment).

                     /* ALL DONE !! */
                     leave.
                  end. /* IF is_overissue = yes */
               end.  /* IF AVAILABLE loc_mstr */
            end.  /* IF (sr_qty * ac_consumed_um_conv) > l_consigned_qty */

            /* CALCULATE RESIDUAL */
            if first-of(cncix_ship_date) then
               residual_qty = (sr_qty * ac_consumed_um_conv)
                            - cncix_qty_stock.
            else
               residual_qty = residual_qty - cncix_qty_stock.

            /* CREATE CONSIGNED USAGE */
            run createConsignedUsage
               (input        cncix_qty_stock,
                input        ac_consumed_um,
                input        ac_consumed_um_conv,
                input        ac_cust_usage_ref,
                input        ac_cust_usage_date,
                input        ac_eff_date,
                input        origin,
                input        save_sbinfo,
                input        ac_selfbill_auth,
                input        ac_tot_qty_consumed,
                input        sr_qty,
                input-output batch,
                input-output working_trnbr,
                buffer       bUsage,
                buffer       bConsignedShipment).

             /* REDUCE sr_qty BY THE RESIDUAL QTY */
             sr_qty = residual_qty / ac_consumed_um_conv.

         end.   /* IF (sr_qty * ac_consumed_um_conv) > cncix_qty_stock */
      end.   /* FOR EACH bConsignedShipment */
   end.   /* FOR EACH sr_wkfl */
end.   /* IF CAN-FIND(first sr_wkfl) */
else do:
   /* INITIALIZE WORKING TRANSACTION ID */
   working_trnbr = 0.

   /* VERIFY SHIPMENT X-REFERENCE */
   run verifyShipmentData
      (input  ac_part,
       input  ac_site,
       input  ac_ship,
       input  ac_cust,
       input  ac_sopart,
       input  ac_order,
       input  ac_line,
       input  ac_loc,
       input  ac_lotser,
       input  ac_ref,
       input  ac_asn_shipper,
       input  ac_auth,
       input  ac_cust_job,
       input  ac_cust_seq,
       input  ac_cust_ref,
       output continue-yn).

   if continue-yn = no then do:
      op_error = 2.
      leave.
   end.


   /* THE SEQUENCE DATA IS CONDITIONAL BECAUSE SOME */
   /* CUSTOMERS DO REPORT THE SEQUENCES USED, EVEN  */
   /* THOUGH THEY USE SEQUENCE SCHEDULES.           */
   for each bConsignedShipment
      where cncix_domain      = global_domain
      and   cncix_part        = ac_part
      and   cncix_site        = ac_site
      and   cncix_shipto      = ac_ship
      and   cncix_cust        = ac_cust
      and   cncix_custpart    = ac_sopart
      and   cncix_so_nbr      = ac_order
      and   cncix_sod_line    = ac_line
      and   cncix_current_loc = ac_loc
      and   cncix_lotser      = ac_lotser
      and   cncix_ref         = ac_ref
      and   cncix_auth        = ac_auth
      and  (ac_cust_job       = ""
      or   (cncix_cust_job    = ac_cust_job
      and   ac_cust_job       <> ""))
      and  (ac_cust_seq       = ""
      or   (cncix_cust_seq    = ac_cust_seq
      and   ac_cust_seq       <> ""))
      and  (ac_cust_ref       = ""
      or   (cncix_cust_ref    = ac_cust_ref
      and   ac_cust_ref       <> ""))
      and  (ac_asn_shipper    = ""
      or   (cncix_asn_shipper = ac_asn_shipper
      and   ac_asn_shipper    <> ""))
      and   cncix_qty_stock   > 0
   exclusive-lock
   break by cncix_ship_date:

      /* EXACT OR PARTIAL ac_tot_qty_consumed QUANTITY */
      if cncix_qty_stock >= (ac_tot_qty_consumed * ac_consumed_um_conv)
      then do:

         /* CREATE CONSIGNED USAGE */
         run createConsignedUsage
            (input        ac_tot_qty_consumed,
             input        ac_consumed_um,
             input        ac_consumed_um_conv,
             input        ac_cust_usage_ref,
             input        ac_cust_usage_date,
             input        ac_eff_date,
             input        origin,
             input        save_sbinfo,
             input        ac_selfbill_auth,
             input        ac_tot_qty_consumed,
             input        ac_tot_qty_consumed,
             input-output batch,
             input-output working_trnbr,
             buffer       bUsage,
             buffer       bConsignedShipment).

         /* ALL DONE !! */
         leave.
      end.  /* IF cncix_qty_stock >= (ac_tot_qty_consumed) */

      /* EXCESS ac_tot_qty_consumed QUANTITY */
      if (ac_tot_qty_consumed * ac_consumed_um_conv) > cncix_qty_stock
      then do:
         if first(cncix_ship_date) then
         /* POPULATE CONSIGNED TOTAL */
         run chkconsgqty
            (input ac_part,
             input ac_site,
             input ac_ship,
             input ac_cust,
             input ac_sopart,
             input ac_order,
             input ac_line,
             input ac_loc,
             input ac_lotser,
             input ac_ref,
             input ac_asn_shipper,
             input ac_auth,
             input ac_cust_job,
             input ac_cust_seq,
             input ac_cust_ref,
             output l_consigned_qty).

         if (ac_tot_qty_consumed * ac_consumed_um_conv) > l_consigned_qty
         then do:
            for first loc_mstr no-lock
           where loc_domain = global_domain
           and   loc_loc    = cncix_current_loc:
            end.
            if available loc_mstr
            then do:
               for first is_mstr no-lock
              where is_domain = global_domain
          and   is_status = loc_status :
               end.
               if available is_mstr and is_overissue = no
               then do:
              /* Quantity Available For Item */
                  {pxmsg.i &MSGNUM=237
                           &MSGARG1=cncix_part
                           &MSGARG2="":""
                           &MSGARG3=cncix_qty_stock
                           &ERRORLEVEL=3 }
                   next.
               end. /* IF AVAILABLE is_mstr and is_overissue = no */
           else
               if is_overissue = yes
               then do:
                  /* CREATE CONSIGNED USAGE */
                  run createConsignedUsage
                  (input        ac_tot_qty_consumed,
                   input        ac_consumed_um,
                   input        ac_consumed_um_conv,
                   input        ac_cust_usage_ref,
                   input        ac_cust_usage_date,
                   input        ac_eff_date,
                   input        origin,
                   input        save_sbinfo,
                   input        ac_selfbill_auth,
                   input        ac_tot_qty_consumed,
                   input        ac_tot_qty_consumed,
                   input-output batch,
                   input-output working_trnbr,
                   buffer       bUsage,
                   buffer       bConsignedShipment).

                   /* ALL DONE !! */
                   leave.
               end.  /* IF overissue = yes */
            end.  /* IF AVAILABLE loc_mstr */
         end.  /* IF (ac_tot_qty_consumed * ac_consumed_um_conv) > l_consigned_qty */

         /* CALCULATE RESIDUAL */
         if first-of(cncix_ship_date) then
            residual_qty = (ac_tot_qty_consumed * ac_consumed_um_conv)
                         - cncix_qty_stock.
         else
            residual_qty = residual_qty - cncix_qty_stock.

         /* CREATE CONSIGNED USAGE */
         run createConsignedUsage
            (input        cncix_qty_stock / ac_consumed_um_conv,
             input        ac_consumed_um,
             input        ac_consumed_um_conv,
             input        ac_cust_usage_ref,
             input        ac_cust_usage_date,
             input        ac_eff_date,
             input        origin,
             input        save_sbinfo,
             input        ac_selfbill_auth,
             input        ac_tot_qty_consumed,
             input        ac_tot_qty_consumed,
             input-output batch,
             input-output working_trnbr,
             buffer       bUsage,
             buffer       bConsignedShipment).

         /* REDUCE ac_tot_qty_consumed BY THE RESIDUAL QTY */
         ac_tot_qty_consumed = residual_qty / ac_consumed_um_conv.

      end.   /* IF (ac_tot_qty_consumed) > cncix_qty_stock */
   end.   /* FOR EACH cncix_mstr*/
end.   /* ELSE DO */

if continue-yn = no then do:
   op_error = 2.
   leave.
end.

/* GET SALES ORDER DETAIL DATA */
run getSalesOrderDetailData
   (input  ac_order,
    input  ac_line,
    output scheduled,
    output curr_rlse_id,
    output cum_shipped_qty,
    output auto_replenish,
    output shipfrom_site).

/* IF SCHEDULED & AUTO-REPLENISH NEEDED, THEN UPDATE SCHEDULE  */
if scheduled and auto_replenish then
   run updateCurrentRelease
      (input ac_order,
       input ac_line,
       input curr_rlse_id,
       input cum_shipped_qty,
       input shipfrom_site,
       input ac_tot_qty_consumed * ac_consumed_um_conv).

/* ========================================================================== */
/* ************************* INTERNAL PROCEDURES **************************** */
/* ========================================================================== */

/* ========================================================================== */
PROCEDURE verifyShipmentData:
/* --------------------------------------------------------------------------
 * Purpose:     Performs a can-find function on the cncix_mstr table or the
 *              cncud_det table to see if a shipment record exists.
 *--------------------------------------------------------------------------- */
   define input  parameter ip_part        as character                  no-undo.
   define input  parameter ip_site        as character                  no-undo.
   define input  parameter ip_ship        as character                  no-undo.
   define input  parameter ip_cust        as character                  no-undo.
   define input  parameter ip_sopart      as character                  no-undo.
   define input  parameter ip_order       as character                  no-undo.
   define input  parameter ip_line        as integer                    no-undo.
   define input  parameter ip_loc         as character                  no-undo.
   define input  parameter ip_lotser      as character                  no-undo.
   define input  parameter ip_ref         as character                  no-undo.
   define input  parameter ip_asn_shipper as character                  no-undo.
   define input  parameter ip_auth        as character                  no-undo.
   define input  parameter ip_cust_job    as character                  no-undo.
   define input  parameter ip_cust_seq    as character                  no-undo.
   define input  parameter ip_cust_ref    as character                  no-undo.
   define output parameter op_continue    as logical                    no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      if can-find(first bConsignedShipment
         where cncix_domain      = global_domain
         and   cncix_part        = ip_part
         and   cncix_site        = ip_site
         and   cncix_shipto      = ip_ship
         and   cncix_cust        = ip_cust
         and   cncix_custpart    = ip_sopart
         and   cncix_so_nbr      = ip_order
         and   cncix_sod_line    = ip_line
         and   cncix_current_loc = ip_loc
         and   cncix_lotser      = ip_lotser
         and  (ip_asn_shipper    = ""
         or   (cncix_asn_shipper = ip_asn_shipper
         and   ip_asn_shipper <> ""))
         and   cncix_ref         = ip_ref
         and   cncix_auth        = ip_auth
         and   cncix_cust_job    = ip_cust_job
         and   cncix_cust_seq    = ip_cust_seq
         and   cncix_cust_ref    = ip_cust_ref
         and   cncix_qty_stock   > 0)
         or can-find(first bConsignedUsageMaster
         where cncu_domain       = global_domain
         and   cncu_part         = ip_part
         and   cncu_site         = ip_site
         and   cncu_shipto       = ip_ship
         and   cncu_cust         = ip_cust
         and   cncu_custpart     = ip_sopart
         and   cncu_so_nbr       = ip_order
         and   cncu_sod_line     = ip_line
         and   cncu_lotser       = ip_lotser
         and   cncu_ref          = ip_ref
         and   cncu_auth         = ip_auth
         and   cncu_cust_job     = ip_cust_job
         and   cncu_cust_seq     = ip_cust_seq
         and   cncu_cust_ref     = ip_cust_ref)
      then
         op_continue = yes.
      else do:
         {pxmsg.i &MSGNUM=1486 &ERRORLEVEL=3}  /* NO SHIPMENT RECORD EXISTS */
         op_continue = no.
      end.

   end.   /* DO ON ERROR UNDO.. */

   return {&SUCCESS-RESULT}.

END PROCEDURE.   /* verifyShipmentData */



/* ========================================================================== */
PROCEDURE createConsignedUsage:
/* --------------------------------------------------------------------------
 * Purpose:     Read the temp-table buffer and call a program to process
 *              each record.
 * -------------------------------------------------------------------------- */
   define input        parameter ip_qty                 like cncix_qty_stock
                                                                        no-undo.
   define input        parameter ip_um                  as  character   no-undo.
   define input        parameter ip_um_conv             as  decimal     no-undo.
   define input        parameter ip_cust_usage_ref      as  character   no-undo.
   define input        parameter ip_cust_usage_date     as  date        no-undo.
   define input        parameter ip_eff_date            as  date        no-undo.
   define input        parameter ip_origin              as  character   no-undo.
   define input        parameter ip_save_sbinfo         as  logical     no-undo.
   define input        parameter ip_selfbill_auth       as  character   no-undo.
   define input        parameter ip_tot_qty_consumed    as  decimal     no-undo.
   define input        parameter ip_tot_lotser_consumed as  decimal     no-undo.
   define input-output parameter io_batch               as  integer     no-undo.
   define input-output parameter io_trnbr               as  integer     no-undo.
   define              parameter buffer bUsage          for tt_cons_usage.
   define              parameter buffer bConsignedShipment for cncix_mstr.
   define variable     l_sonbr   like cncix_so_nbr                      no-undo.
   define variable     l_sodline like cncix_sod_line                    no-undo.

   assign
      l_sonbr   = cncix_so_nbr.
      l_sodline = cncix_sod_line.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      /* FILL THE USAGE BUFFER */
      create bUsage.
      assign
         bUsage.oid_cncud_det        = nextOidValue()
         bUsage.cncud_domain         = global_domain
         bUsage.cncud_cncix_pkey     = cncix_pkey
         bUsage.order_nbr            = cncix_so_nbr
         bUsage.order_line           = cncix_sod_line
         bUsage.site                 = cncix_site
         bUsage.shipto               = cncix_shipto
         bUsage.cust                 = cncix_cust
         bUsage.cncud_selfbill       = cncix_selfbill
         bUsage.selfbill_auth        = ip_selfbill_auth
         bUsage.part                 = cncix_part
         bUsage.cust_part            = cncix_custpart
         bUsage.cncud_qty_ship       = cncix_qty_ship
         bUsage.cncud_stock_um       = cncix_stock_um
         bUsage.cncud_price          = cncix_price
         bUsage.cncud_ship_value     = cncix_ship_value
         bUsage.cncud_curr           = cncix_curr
         bUsage.cncud_asn_shipper    = cncix_asn_shipper
         bUsage.po                   = cncix_po
         bUsage.cncud_ship_date      = cncix_ship_date
         bUsage.cncud_usage_qty      = ip_qty
         bUsage.cncud_usage_um       = ip_um
         bUsage.cncud_usage_um_conv  = ip_um_conv
         bUsage.cncud_current_loc    = cncix_current_loc
         bUsage.lotser               = cncix_lotser
         bUsage.ref                  = cncix_ref
         bUsage.auth                 = cncix_auth
         bUsage.cust_seq             = cncix_cust_seq
         bUsage.cust_job             = cncix_cust_job
         bUsage.cust_ref             = cncix_cust_ref
         bUsage.cncud_cust_dock      = cncix_cust_dock
         bUsage.cncud_line_feed      = cncix_line_feed
         bUsage.modelyr              = cncix_modelyr
         bUsage.cncud_aged_date      = cncix_aged_date
         bUsage.cncud_orig_aged_date = cncix_orig_aged_date
         bUsage.cncud_ship_trnbr     = cncix_ship_trnbr
         bUsage.cust_usage_ref       = ip_cust_usage_ref
         bUsage.cust_usage_date      = ip_cust_usage_date
         bUsage.cncu_batch           = io_batch
         bUsage.trans_date           = today
         bUsage.eff_date             = ip_eff_date
         bUsage.origin               = ip_origin
         bUsage.cncud__qadc01        = cncix__qadc01.

      if recid (bUsage) = -1 then .

      /* CALL THE USAGE PROCESSOR */
      /*  - Update Sales Order Qty to Invoice */
      /*  - Update Sales Order CUMS           */
      /*  - Create ISS-SO, CN-USE             */
      /*  - Reduce consigned inventory        */
      /*  - CREATE consigned usage records    */
      /*  - CREATE self-billling records      */
      {gprun.i ""xxsocnis.p""
               "(input        invoice_domain,
                 input        ip_tot_qty_consumed * ip_um_conv,
                 input        ip_tot_lotser_consumed * ip_um_conv,
                 input        ip_eff_date,
                 input-output io_trnbr,
                 input-output table tt_cons_usage,
                 input-output table tt_so_update)"}

      for first tr_hist
         fields(tr_domain tr_trnbr)
         where tr_domain = global_domain
           and tr_trnbr  = io_trnbr
      no-lock:
      end.

      if available tr_hist then do:
         create work_trnbr.
         assign
            work_sod_nbr  = l_sonbr
            work_sod_line = l_sodline
            work_tr_recid = recid(tr_hist).
      end.

      if return-value <> {&SUCCESS-RESULT} then
         return return-value.

      /* SAVE OFF USAGE ID */
      for first bUsage
      exclusive-lock:
         io_batch = bUsage.cncu_batch.
      end.

      /* DELETE THE USAGE BUFFER */
      delete bUsage.
   end.   /* DO ON ERROR UNDO.. */

   return {&SUCCESS-RESULT}.

END PROCEDURE.   /* createConsignedUsage */


/* ========================================================================== */
PROCEDURE getSalesOrderDetailData:
/* --------------------------------------------------------------------------
 * Purpose:  This procedure reads the SO detail record and passes back data.
 * -------------------------------------------------------------------------- */
   define input  parameter    ip_order           as character           no-undo.
   define input  parameter    ip_line            as integer             no-undo.
   define output parameter    op_scheduled       as logical             no-undo.
   define output parameter    op_curr_rlse_id    as character           no-undo.
   define output parameter    op_cum_shipped_qty as decimal             no-undo.
   define output parameter    op_auto_replenish  as logical             no-undo.
   define output parameter    op_shipfrom_site   as character           no-undo.

   define buffer sod_det for sod_det.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      for first sod_det
         fields (sod_domain sod_sched sod_curr_rlse_id sod_site sod_cum_qty
                 sod_auto_replenish)
         where   sod_domain = global_domain
         and     sod_nbr    = ip_order
         and     sod_line   = ip_line
      no-lock:
         assign
            op_scheduled        = sod_sched
            op_shipfrom_site    = sod_site
            op_curr_rlse_id     = sod_curr_rlse_id[3]
            op_cum_shipped_qty  = sod_cum_qty[1]
            op_auto_replenish   = sod_auto_replenish.

      end.   /* FOR FIRST sod_det */
   end.   /* DO ON ERROR UNDO */

   return {&SUCCESS-RESULT}.

END PROCEDURE. /* getSalesOrderDetailData */


/* ========================================================================== */
PROCEDURE updateCurrentRelease:
/* --------------------------------------------------------------------------
 * Purpose:    This procedure adds a new requirement to the type-3 Required
 *             Shipping Schedule.  If the requirement already exists, then the
 *             existing requirement quantity is updated.
 * -------------------------------------------------------------------------- */
   define input parameter ip_order           as character               no-undo.
   define input parameter ip_line            as integer                 no-undo.
   define input parameter ip_curr_rlse_id    as character               no-undo.
   define input parameter ip_cum_shipped_qty as decimal                 no-undo.
   define input parameter ip_shipfrom_site   as character               no-undo.
   define input parameter ip_qty             as decimal                 no-undo.

   define variable new_date                  as date                    no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      /* GET SCHEDULE MASTER */
      for first sch_mstr
         fields (sch_domain sch_cumulative sch_pcr_qty)
         where   sch_domain  = global_domain
         and     sch_nbr     = ip_order
         and     sch_line    = ip_line
         and     sch_type    = 3                       /* RSS */
         and     sch_rlse_id = ip_curr_rlse_id
      no-lock: end.

      if available sch_mstr
      then do:

         /* DETERMINE WHERE THE NEXT OPEN REQUIREMENTS ARE ON THE SCHEDULE */
         for first schd_det
            fields (schd_domain schd_upd_qty)
            where   schd_domain   = global_domain
            and     schd_nbr      = ip_order
            and     schd_line     = ip_line
            and     schd_type     = 3                       /* RSS */
            and     schd_rlse_id  = ip_curr_rlse_id
            and     schd_cum_qty  > ip_cum_shipped_qty
            and trim(substring(schd_fc_qual,2,1)) = ""      /* NOT FULLY SHIPPED */
         exclusive-lock:
            /* ADD TO OPEN REQUIREMENTS IF EXISTS */
            schd_upd_qty = schd_upd_qty + ip_qty.
         end.

         if not available schd_det then do:
            /* ADD TO END OF THE SCHEDULE */
            for last schd_det
               fields (schd_domain schd_date)
               where   schd_domain  = global_domain
               and     schd_nbr     = ip_order
               and     schd_line    = ip_line
               and     schd_type    = 3                       /* RSS */
               and     schd_rlse_id = ip_curr_rlse_id
            no-lock:
               new_date = schd_date + 1.
            end.

            if not available schd_det then
               new_date = today + 1.

            /* CREATE NEW REQUIREMENT */
            create schd_det.
            assign
               schd_domain   = global_domain
               schd_type     = 3
               schd_nbr      = ip_order
               schd_line     = ip_line
               schd_rlse_id  = ip_curr_rlse_id
               schd_date     = new_date
               schd_interval = "D"
               schd_upd_qty  = ip_qty
               substring(schd_fc_qual,1,1) = "F".

            /* FORWARD SCHEDULE THE REQUIREMENT BASED ON SITE CALENDAR */
            {rchdate.i schd_date 1 ip_shipfrom_site}

         end.   /* IF NOT AVAILABLE schd_det */

         /* UPDATE CUM QUANTITIES */
         prior_cum_qty = sch_pcr_qty.

         for each schd_det
            where schd_domain  = global_domain
            and   schd_type    = 3
            and   schd_nbr     = ip_order
            and   schd_line    = ip_line
            and   schd_rlse_id = ip_curr_rlse_id
         exclusive-lock:

            if sch_cumulative then
               assign
                  schd_cum_qty = if schd_upd_qty > prior_cum_qty then schd_upd_qty
                                 else schd_upd_qty + prior_cum_qty
                  schd_discr_qty = schd_cum_qty - prior_cum_qty
                  prior_cum_qty  = prior_cum_qty + schd_discr_qty.
            else
               assign
                  schd_discr_qty = schd_upd_qty
                  prior_cum_qty  = prior_cum_qty + schd_discr_qty
                  schd_cum_qty   = prior_cum_qty.

         end.   /* FOR EACH schd_det */
      end. /* IF AVAILABLE sch_mstr */
   end.   /* DO ON ERROR UNDO */

   return {&SUCCESS-RESULT}.

END PROCEDURE.   /* updateCurrentRelease */


/* ========================================================================== */
PROCEDURE chkconsgqty :
/* --------------------------------------------------------------------------
 * Purpose:    This procedure is to calculate the total consignment inventory
 * -------------------------------------------------------------------------- */

   define input  parameter p_cpart       like ac_part         no-undo.
   define input  parameter p_csite       like ac_site         no-undo.
   define input  parameter p_cship       like ac_ship         no-undo.
   define input  parameter p_ccust       like ac_cust         no-undo.
   define input  parameter p_csopart     like ac_sopart       no-undo.
   define input  parameter p_corder      like ac_order        no-undo.
   define input  parameter p_cline       like ac_line         no-undo.
   define input  parameter p_cloc        like ac_loc          no-undo.
   define input  parameter p_clotser     like ac_lotser       no-undo.
   define input  parameter p_cref        like ac_ref          no-undo.
   define input  parameter p_casnshipper like ac_asn_shipper  no-undo.
   define input  parameter p_cauth       like ac_auth         no-undo.
   define input  parameter p_ccustjob    like ac_cust_job     no-undo.
   define input  parameter p_ccustseq    like ac_cust_seq     no-undo.
   define input  parameter p_ccustref    like ac_cust_ref     no-undo.
   define output parameter p_constotqty  like cncix_qty_stock no-undo.

   define buffer       b_ConsignedShipment        for cncix_mstr.

   p_constotqty = 0.

   for each b_ConsignedShipment
      where b_ConsignedShipment.cncix_domain      = global_domain
      and   b_ConsignedShipment.cncix_part        = p_cpart
      and   b_ConsignedShipment.cncix_site        = p_csite
      and   b_ConsignedShipment.cncix_shipto      = p_cship
      and   b_ConsignedShipment.cncix_cust        = p_ccust
      and   b_ConsignedShipment.cncix_custpart    = p_csopart
      and   b_ConsignedShipment.cncix_so_nbr      = p_corder
      and   b_ConsignedShipment.cncix_sod_line    = p_cline
      and   b_ConsignedShipment.cncix_current_loc = p_cloc
      and   b_ConsignedShipment.cncix_lotser      = p_clotser
      and   b_ConsignedShipment.cncix_ref         = p_cref
      and   b_ConsignedShipment.cncix_auth        = p_cauth
      and  (ac_cust_job       = ""
      or   (b_ConsignedShipment.cncix_cust_job    = p_ccustjob
      and   ac_cust_job       <> ""))
      and  (ac_cust_seq       = ""
      or   (b_ConsignedShipment.cncix_cust_seq    = p_ccustseq
      and   ac_cust_seq       <> ""))
      and  (ac_cust_ref       = ""
      or   (b_ConsignedShipment.cncix_cust_ref    = p_ccustref
      and   ac_cust_ref       <> ""))
      and  (ac_asn_shipper    = ""
      or   (b_ConsignedShipment.cncix_asn_shipper = p_casnshipper
      and   ac_asn_shipper    <> ""))
      and   b_ConsignedShipment.cncix_qty_stock   > 0
   no-lock
   break by b_ConsignedShipment.cncix_ship_date:

      p_constotqty = p_constotqty + b_ConsignedShipment.cncix_qty_stock.
   end.  /* FOR EACH b_ConsignedShipment */

END PROCEDURE.  /* Populate the total consignment inventory */
