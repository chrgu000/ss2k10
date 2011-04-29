/* socnuac2.p - Sales Order Consignment Usage Process Temp-Table Program    */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.31 $                                                        */
/*                                                                          */
/*V8:ConvertMode=NoConvert                                                  */

/* Revision: 1.21  BY: Patrick Rowan DATE: 04/04/02 ECO: *P00F* */
/* Revision: 1.23  BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00L* */
/* Revision: 1.25   BY: Paul Donnelly     DATE: 07/17/03  ECO: *Q014*  */
/* Revision: 1.26   BY: Sandy Brown (OID) DATE: 12/06/03  ECO: *Q04L*  */
/* Revision: 1.27   BY: Preeti Sattur     DATE: 02/06/04  ECO: *P1N2*  */
/* Revision: 1.28   BY: Laxmikant Bondre     DATE: 04/26/04  ECO: *P1TT*  */
/* Revision: 1.29   BY: Somesh Jeswani       DATE: 06/14/04  ECO: *P25V*  */
/* Revision: 1.30   BY: Reena Ambavi         DATE: 06/29/04  ECO: *P27C*  */
/* $Revision: 1.31 $ BY: Vandna Rohira        DATE: 08/17/04  ECO: *P2FL* */
/* By: Neil Gao Date: *ss 20070302 ECO: *ss 20070302.1* */

/*-Revision end---------------------------------------------------------------*/


{mfdeclre.i}
{gpoidfcn.i}  /* Defines nextOidValue() function */

{pxsevcon.i}
{socnuac.i}
{socnvars.i}

/* MUST INCLUDE gprunpdf.i IN THE MAIN BLOCK OF THE PROGRAM SO THAT */
/* CALLS TO gprunp.i FROM ANY OF THE INTERNAL PROCEDURES SKIPS      */
/* DEFINITION OF SHARED VARS OF gprunpdf.i                          */
/* FOR FURTHER INFO REFER TO HEADER COMMENTS IN gprunp.i            */
{gprunpdf.i "mcpl" "p"}

/* FUNCTIONS/PROCEDURES */


/* PARAMETERS */
define input-output parameter table for tt_autocr.
define input parameter using_selfbilling as logical no-undo.
define input parameter origin as character no-undo.
define input parameter l_effdate like glt_effdate no-undo.
define output parameter batch as character no-undo.
define output parameter continue-yn as logical no-undo.

/* VARIABLES */
define variable residual_qty like cncix_qty_stock no-undo.
define variable save_sbinfo as logical no-undo.
define variable scheduled as logical no-undo.
define variable curr_rlse_id as character no-undo.
define variable cum_shipped_qty as decimal no-undo.
define variable shipfrom_site as character no-undo.
define variable prior_cum_qty as decimal no-undo.
define variable working_trnbr as integer no-undo.
/*minth*/  define variable residual_qtyx like cncix_qty_stock no-undo.
/*minth*/  define variable residual_qtyy like cncix_qty_stock no-undo.
/*minth*/  define shared variable rtn               as  logical      initial   no  no-undo.

/* TEMP-TABLE */
define temp-table tt_cons_usage like cncud_det
   field origin               as character
   field trans_date           as date
   field eff_date             as date
   field cust_usage_ref       as character
   field cust_usage_date      as date
   field cncu_batch           as integer
   field selfbill_auth        as character
   field so_nbr               like cncu_so_nbr
   field sod_line             like cncu_sod_line
   field lotser               like cncu_lotser
   field ref                  like cncu_ref
   field auth                 like cncu_auth
   field cust_job             like cncu_cust_job
   field cust_seq             like cncu_cust_seq
   field cust_ref             like cncu_cust_ref
   field site                 like cncu_site
   field shipto               like cncu_shipto
   field cust                 like cncu_cust
   field cust_part            like cncu_custpart
   field po                   like cncu_po
   field part                 like cncu_part
   field modelyr              like cncu_modelyr.

/* BUFFERS */
define buffer bConsignedUsage for tt_cons_usage.
define buffer bConsignedShipment for cncix_mstr.
define buffer bConsignedUsageMaster for cncu_mstr.

/* ss 20070302.1 - b */
DEFINE shared TEMP-TABLE tt1
   FIELD tt1_stat     as character format "x(1)" label "S"
   FIELD tt1_shipfrom LIKE ABS_shipfrom 
   FIELD tt1_id LIKE ABS_id FORMAT "x(46)"
   field tt1_disp_id like abs_id format "x(46)"
   FIELD tt1_par_id LIKE ABS_par_id
   FIELD tt1_shipto         LIKE ABS_shipto 
   FIELD tt1_order        AS CHAR FORMAT "x(8)"
   FIELD tt1_po           LIKE so_po
   FIELD tt1_line     LIKE ABS_line FORMAT "x(3)"
   FIELD tt1_item     AS CHAR FORMAT "x(18)"
   FIELD tt1_cust_part LIKE cp_cust_part
   FIELD tt1_desc1        like pt_desc1
   FIELD tt1_desc2        like pt_desc2
   FIELD tt1_um           AS CHAR FORMAT "x(2)"
   FIELD tt1_ship_qty AS DECIMAL FORMAT "->,>>>,>>9.99"
   FIELD tt1_qty_inv AS DECIMAL FORMAT "->,>>>,>>9.99"
   FIELD tt1_nbr AS char
   FIELD tt1_price LIKE sod_price
   FIELD tt1_close_abs AS LOGICAL
   FIELD tt1_type LIKE sod_type
   /* SS - 20060401 - B */
   FIELD tt1_new  AS LOGICAL INITIAL YES
   FIELD tt1_ord_date LIKE so_ord_date
   FIELD tt1__qad02 LIKE ABS__qad02
   FIELD tt1_conv AS DECIMAL INITIAL 1
   /* SS - 20060401 - E */
   index tt1_disp_id tt1_disp_id
   INDEX tt1_id tt1_id
   INDEX tt1_stat tt1_stat
   INDEX tt1_par_id_line tt1_par_id tt1_line
   INDEX tt1_shipfrom_id tt1_shipfrom tt1_id
   .
/* ss 20070302.1 - e */

continue-yn = no.

/* READ THE AUTOCREATE TEMP-TABLE BUFFER */
for each bAutoCreate
   where ac_tot_qty_consumed <> 0
   exclusive-lock:

  /* DETERMINE IF BILL-TO IS REGISTERED FOR SELF-BILLING */
  save_sbinfo =
      if using_selfbilling and ac_selfbill
         then yes
      else no.



  /* DETERMINE IF LOT/SERIAL MATERIAL */

  if can-find(first sr_wkfl  where sr_wkfl.sr_domain = global_domain and
                    sr_userid = mfguser and
                    sr_lineid = string(ac_count)  and
                    sr_qty <> 0) then do:


     /* IF LOT OR SERIAL, THEN READ sr_wkfl */
     for each sr_wkfl
          where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser   and
               sr_lineid = string(ac_count)  and
               sr_qty <> 0
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

        if continue-yn = no then
           leave.

        /* VERIFY EXCHANGE RATE  */
        run verifyExchangeRate
            (input  ac_order,
             input  base_curr,
             input  ac_eff_date,
             output continue-yn).

        if continue-yn = no
        then
            return.

        /* THE SEQUENCE DATA IS CONDITIONAL BECAUSE SOME */
        /* CUSTOMERS DO REPORT THE SEQUENCES USED, EVEN  */
        /* THOUGH THEY USE SEQUENCE SCHEDULES.           */

        for each bConsignedShipment
             where bConsignedShipment.cncix_domain = global_domain and (
             cncix_part     = ac_part     and
                  cncix_site     = sr_site     and
                  cncix_shipto   = ac_ship     and
                  cncix_cust     = ac_cust     and
                  cncix_custpart = ac_sopart   and
                  cncix_so_nbr   = ac_order    and
                  cncix_sod_line = ac_line     and
                  cncix_current_loc      = sr_loc      and
                  cncix_lotser   = sr_lotser   and
                  cncix_ref      = sr_ref      and
                  cncix_auth     = ac_auth
                                and
                    (ac_cust_job = "" or
                 (cncix_cust_job = ac_cust_job and
                     ac_cust_job <> ""))
                                and
                    (ac_cust_seq = "" or
                 (cncix_cust_seq = ac_cust_seq and
                     ac_cust_seq <> ""))
                                and
                    (ac_cust_ref = "" or
                 (cncix_cust_ref = ac_cust_ref and
                     ac_cust_ref <> ""))
                               and
                    (ac_asn_shipper = "" or
                 (cncix_asn_shipper = ac_asn_shipper and
                     ac_asn_shipper <> ""))
/*minth del                                and
                  cncix_qty_stock > 0
            ) no-lock
            break by cncix_ship_date: */ 
/*minth add*/                                and
                (rtn and   cncix_qty_stock >= 0  or  cncix_qty_stock > 0 )
            ) no-lock
            break by cncix_ship_date: 
             /* EXACT OR PARTIAL sr_qty QUANTITY */
             if cncix_qty_stock >= (sr_qty * ac_consumed_um_conv) then do:

                /* CREATE CONSIGNED USAGE */
                run createConsignedUsage
                   (input sr_qty,
                    input ac_consumed_um,
                    input ac_consumed_um_conv,
                    input ac_cust_usage_ref,
                    input ac_cust_usage_date,
                    input ac_eff_date,
                    input origin,
                    input save_sbinfo,
                    input ac_selfbill_auth,
                    input ac_tot_qty_consumed,
                    input sr_qty,
                    input-output batch,
                    input-output working_trnbr,
                    buffer bConsignedUsage,
                    buffer bConsignedShipment).

                /* ALL DONE !! */
                leave.

             end.  /* if cncix_qty_stock >= (sr_qty * ac_consumed_um_conv) */

             /* EXCESS sr_qty QUANTITY */
             if (sr_qty * ac_consumed_um_conv) > cncix_qty_stock then do:

                /* CALCULATE RESIDUAL */
                if first-of(cncix_ship_date) then
                   residual_qty = (sr_qty * ac_consumed_um_conv)
                                               - cncix_qty_stock.
                else
                   residual_qty = residual_qty - cncix_qty_stock.

                /* CREATE CONSIGNED USAGE */
                run createConsignedUsage
                   (input cncix_qty_stock,
                    input ac_consumed_um,
                    input ac_consumed_um_conv,
                    input ac_cust_usage_ref,
                    input ac_cust_usage_date,
                    input ac_eff_date,
                    input origin,
                    input save_sbinfo,
                    input ac_selfbill_auth,
                    input ac_tot_qty_consumed,
                    input sr_qty,
                    input-output batch,
                    input-output working_trnbr,
                    buffer bConsignedUsage,
                    buffer bConsignedShipment).

                /* REDUCE sr_qty BY THE RESIDUAL QTY */
                sr_qty = residual_qty / ac_consumed_um_conv.

             end.  /* if (sr_qty * ac_consumed_um_conv) > cncix_qty_stock */

        end.  /* for each bConsignedShipment */

     end.  /*for each sr_wkfl */

  end.  /* if can-find(first sr_wkfl) */
  else do:
       /* INITIALIZE WORKING TRANSACTION ID */
        working_trnbr = 0.

        /* VERIFY SHIPMENT X-REFERENCE */
        run verifyShipmentData
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
             output continue-yn).

        if continue-yn = no then
           leave.

        /* VERIFY EXCHANGE RATE  */
        run verifyExchangeRate
            (input  ac_order,
             input  base_curr,
             input  ac_eff_date,
             output continue-yn).

        if continue-yn = no
        then
            return.

        /* THE SEQUENCE DATA IS CONDITIONAL BECAUSE SOME */
        /* CUSTOMERS DO REPORT THE SEQUENCES USED, EVEN  */
        /* THOUGH THEY USE SEQUENCE SCHEDULES.           */

        for each bConsignedShipment
             where bConsignedShipment.cncix_domain = global_domain and (
             cncix_part     = ac_part   and
                  cncix_site     = ac_site     and
                  cncix_shipto   = ac_ship     and
                  cncix_cust     = ac_cust     and
                  cncix_custpart   = ac_sopart   and
                  cncix_so_nbr   = ac_order    and
                  cncix_sod_line = ac_line     and
                  cncix_current_loc      = ac_loc      and
                  cncix_lotser   = ac_lotser   and
                  cncix_ref      = ac_ref      and
                  cncix_auth     = ac_auth
                                and
                    (ac_cust_job = "" or
                 (cncix_cust_job = ac_cust_job and
                     ac_cust_job <> ""))
                                and
                    (ac_cust_seq = "" or
                 (cncix_cust_seq = ac_cust_seq and
                     ac_cust_seq <> ""))
                                and
                    (ac_cust_ref = "" or
                 (cncix_cust_ref = ac_cust_ref and
                     ac_cust_ref <> ""))
                               and
                    (ac_asn_shipper = "" or
                 (cncix_asn_shipper = ac_asn_shipper and
                     ac_asn_shipper <> ""))
                               and
                  cncix_qty_stock > 0
            ) no-lock
            break by cncix_ship_date:

            /* EXACT OR PARTIAL ac_tot_qty_consumed QUANTITY */
            if cncix_qty_stock >= (ac_tot_qty_consumed * ac_consumed_um_conv)
              then do:

                /* CREATE CONSIGNED USAGE */
                run createConsignedUsage
                   (input ac_tot_qty_consumed,
                    input ac_consumed_um,
                    input ac_consumed_um_conv,
                    input ac_cust_usage_ref,
                    input ac_cust_usage_date,
                    input ac_eff_date,
                    input origin,
                    input save_sbinfo,
                    input ac_selfbill_auth,
                    input ac_tot_qty_consumed,
                    input ac_tot_qty_consumed,
                    input-output batch,
                    input-output working_trnbr,
                    buffer bConsignedUsage,
                    buffer bConsignedShipment).

                /* ALL DONE !! */
                leave.

             end.  /* if cncix_qty_stock >= (ac_tot_qty_consumed) */

             /* EXCESS ac_tot_qty_consumed QUANTITY */
             if (ac_tot_qty_consumed * ac_consumed_um_conv) > cncix_qty_stock
               then do:

                /* CALCULATE RESIDUAL */
                if first-of(cncix_ship_date) then
                   residual_qty = (ac_tot_qty_consumed * ac_consumed_um_conv)
                                               - cncix_qty_stock.
                else
                   residual_qty = residual_qty - cncix_qty_stock.

                /* CREATE CONSIGNED USAGE */
                run createConsignedUsage
                   (input cncix_qty_stock,
                    input ac_consumed_um,
                    input ac_consumed_um_conv,
                    input ac_cust_usage_ref,
                    input ac_cust_usage_date,
                    input ac_eff_date,
                    input origin,
                    input save_sbinfo,
                    input ac_selfbill_auth,
                    input ac_tot_qty_consumed,
                    input ac_tot_qty_consumed,
                    input-output batch,
                    input-output working_trnbr,
                    buffer bConsignedUsage,
                    buffer bConsignedShipment).

                /* REDUCE ac_tot_qty_consumed BY THE RESIDUAL QTY */
                ac_tot_qty_consumed = residual_qty / ac_consumed_um_conv.

             end.  /* if (ac_tot_qty_consumed) > cncix_qty_stock */

        end.  /* for each cncix_mstr*/

  end.  /* else do */

  if continue-yn = no then
     leave.

  /* GET SALES ORDER DETAIL DATA */
  run getSalesOrderDetailData
        (input ac_order,
         input ac_line,
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


end.  /* for each bConsignedUsage */

continue-yn = yes.

/* ss 20070302.1 - b */

for each tt1 no-lock where tt1_nbr <> "" break by tt1_nbr:

   DO TRANSACTION :
    if first-of(tt1_nbr) then do:
    	 find first so_mstr where so_nbr = tt1_order and so_domain = global_domain no-lock no-error.
    	 find first sod_det where sod_nbr = tt1_order and sod_line = int(tt1_line) 
    	   and sod_domain = global_domain no-lock no-error.
    	 find first xxrqm_mstr where xxrqm_domain = global_domain and xxrqm_nbr = tt1_nbr no-error.
    	 if not avail xxrqm_mstr then leave.
    	 assign  xxrqm_site         = tt1_shipfrom   
               xxrqm_cust         = so_cust
               xxrqm_domain       = global_domain
               xxrqm_req_date     = today
               xxrqm_open         = yes
               xxrqm_tax_in       = sod_tax_in .
    end.
    if tt1_qty_inv = 0 then next.
    find first xxabs_mstr where xxabs_domain = global_domain and xxabs_nbr = tt1_nbr and xxabs_id = tt1_id no-error.
    if avail xxabs_mstr then do:
       assign xxabs_ship_qty = xxabs_ship_qty + tt1_qty_inv.
    end.
    else do:
      CREATE xxabs_mstr.
      ASSIGN xxabs_domain = global_domain
             xxabs_nbr = tt1_nbr 
             xxabs_shipfrom = tt1_shipfrom
             xxabs_id  = tt1_id
             xxabs_par_id = tt1_par_id
             xxabs_order = tt1_order
             xxabs_line = tt1_line
             xxabs_ship_qty = tt1_qty_inv
             xxabs_canceled = tt1_close_abs
             xxabs__chr01 = tt1_type 
             .
    end. /* else do: */
  end. /* DO TRANSACTION */  
end. /* for each tt1 */	

/* ss 20070302.1 - e */

/*RUN THE AUTO INVOICE POST PROGRAM*/
/* ADDED SECOND INPUT PARAMETER l_effdate */
/* ss 20070302.1 -  b */
/*
{gprun.i ""socnpst.p""
       "(input batch, l_effdate)"}
 */
/* ss 20070302.1 - e */

/* ========================================================================= */
/* ************************ INTERNAL PROCEDURES **************************** */
/* ========================================================================= */

/* ========================================================================= */
PROCEDURE verifyShipmentData:
/* -------------------------------------------------------------------------
Purpose:      Performs a can-find function on the cncix_mstr table or the
              cncud_det table to see if a shipment record exists.
Exceptions:   None
Conditions:
Pre:
Post:
Notes:
History:
 --------------------------------------------------------------------------- */

   define input parameter ip_part        as character no-undo.
   define input parameter ip_site        as character no-undo.
   define input parameter ip_ship        as character no-undo.
   define input parameter ip_cust        as character no-undo.
   define input parameter ip_sopart      as character no-undo.
   define input parameter ip_order       as character no-undo.
   define input parameter ip_line        as integer   no-undo.
   define input parameter ip_loc         as character no-undo.
   define input parameter ip_lotser      as character no-undo.
   define input parameter ip_ref         as character no-undo.
   define input parameter ip_asn_shipper as character no-undo.
   define input parameter ip_auth        as character no-undo.
   define input parameter ip_cust_job    as character no-undo.
   define input parameter ip_cust_seq    as character no-undo.
   define input parameter ip_cust_ref    as character no-undo.
   define output parameter op_continue   as logical no-undo.


   do on error undo, return error {&GENERAL-APP-EXCEPT}:


      if can-find(first bConsignedShipment
          where bConsignedShipment.cncix_domain = global_domain
          and  (cncix_part       = ip_part
          and  cncix_site        = ip_site
          and  cncix_shipto      = ip_ship
          and  cncix_cust        = ip_cust
          and  cncix_custpart    = ip_sopart
          and  cncix_so_nbr      = ip_order
          and  cncix_sod_line    = ip_line
          and  cncix_current_loc = ip_loc
          and  cncix_lotser      = ip_lotser
          and  (ip_asn_shipper = ""
                or (cncix_asn_shipper = ip_asn_shipper
                    and ip_asn_shipper <> ""))
          and  cncix_ref         = ip_ref
          and  cncix_auth        = ip_auth
          and  cncix_cust_job    = ip_cust_job
          and  cncix_cust_seq    = ip_cust_seq
          and  cncix_cust_ref    = ip_cust_ref
          and  cncix_qty_stock   > 0))
                        or
         can-find(first bConsignedUsageMaster
             where bConsignedUsageMaster.cncu_domain = global_domain and
             cncu_part      = ip_part     and
                  cncu_site      = ip_site     and
                  cncu_shipto    = ip_ship     and
                  cncu_cust      = ip_cust     and
                  cncu_custpart  = ip_sopart   and
                  cncu_so_nbr    = ip_order    and
                  cncu_sod_line  = ip_line     and
                  cncu_lotser    = ip_lotser   and
                  cncu_ref       = ip_ref      and
                  cncu_auth      = ip_auth     and
                  cncu_cust_job  = ip_cust_job and
                  cncu_cust_seq  = ip_cust_seq and
                  cncu_cust_ref  = ip_cust_ref)
         then
         op_continue = yes.
      else do:
         {pxmsg.i &MSGNUM=1486 &ERRORLEVEL=3}  /* NO SHIPMENT RECORD EXISTS */
         op_continue = no.
      end.

   end. /*Do on error undo..*/

   return {&SUCCESS-RESULT}.

END PROCEDURE. /*verifyShipmentData*/

/* ========================================================================= */
PROCEDURE verifyExchangeRate:
/* -------------------------------------------------------------------------
Purpose:      Verifies if the Exchange rate is valid as on the date specified
Exceptions:   None
 --------------------------------------------------------------------------- */
   define input  parameter ip_order     like ac_order    no-undo.
   define input  parameter ip_base_curr like base_curr   no-undo.
   define input  parameter ip_eff_date  like ac_eff_date no-undo.
   define output parameter op_continue  as   logical     no-undo.

   define variable l_exch_rate      like exr_rate.
   define variable l_exch_rate2     like exr_rate2.
   define variable l_mc-error-number as integer no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      for first so_mstr
         fields (so_curr so_domain so_ex_ratetype so_fix_rate so_nbr)
         where so_domain = global_domain
         and   so_nbr    = ip_order no-lock:

         if not so_fix_rate
         then do:

            /* GET EXCHANGE RATE FOR BASE TO ACCOUNT CURRENCY */
            {gprunp.i "mcpl" "p" "mc-get-ex-rate"
                 "(input  so_curr,
                   input  ip_base_curr,
                   input  so_ex_ratetype,
                   input  ip_eff_date,
                   output l_exch_rate,
                   output l_exch_rate2,
                   output l_mc-error-number)" }

            if l_mc-error-number <> 0
            then do:
               /* EXCHANGE RATE DOES NOT EXIST */
               {pxmsg.i &MSGNUM=81 &ERRORLEVEL=3}
               op_continue = no.
            end. /* IF l_mc-error-number <> 0 */
            else
               op_continue = yes.

        end. /* IF NOT so_fix_rate */

      end. /* FOR FIRST so_mstr */

   end. /* DO ON ERROR UNDO.. */

   return {&SUCCESS-RESULT}.

END PROCEDURE. /*verifyExchangeRate */

/* ========================================================================= */
PROCEDURE createConsignedUsage:
/* -------------------------------------------------------------------------
Purpose:      Read the temp-table buffer and call a program to process
              each record.
Exceptions:   None
Conditions:
Pre:
Post:
Notes:
History:
 --------------------------------------------------------------------------- */

   define input parameter ip_qty like cncix_qty_stock no-undo.
   define input parameter ip_um as character no-undo.
   define input parameter ip_um_conv as decimal no-undo.
   define input parameter ip_cust_usage_ref as character no-undo.
   define input parameter ip_cust_usage_date as date no-undo.
   define input parameter ip_eff_date like glt_effdate no-undo.
   define input parameter ip_origin as character no-undo.
   define input parameter ip_save_sbinfo as logical no-undo.
   define input parameter ip_selfbill_auth as character no-undo.
   define input parameter ip_tot_qty_consumed as decimal no-undo.
   define input parameter ip_tot_lotser_consumed as decimal no-undo.
   define input-output parameter io_batch as integer no-undo.
   define input-output parameter io_trnbr as integer no-undo.

   define parameter buffer bConsignedUsage for tt_cons_usage.
   define parameter buffer bConsignedShipment for cncix_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

       /* FILL THE USAGE BUFFER */
      create bConsignedUsage.
      assign
         bConsignedUsage.oid_cncud_det    = nextOidValue()
         bConsignedUsage.cncud_domain     = global_domain
         bConsignedUsage.cncud_cncix_pkey = cncix_pkey
         bConsignedUsage.so_nbr           = cncix_so_nbr
         bConsignedUsage.sod_line         = cncix_sod_line
         bConsignedUsage.site             = cncix_site
         bConsignedUsage.shipto           = cncix_shipto
         bConsignedUsage.cust             = cncix_cust
         bConsignedUsage.cncud_selfbill   = cncix_selfbill
         bConsignedUsage.selfbill_auth    = ip_selfbill_auth
         bConsignedUsage.part             = cncix_part
         bConsignedUsage.cust_part        = cncix_custpart
         bConsignedUsage.cncud_qty_ship   = cncix_qty_ship
         bConsignedUsage.cncud_stock_um   = cncix_stock_um
         bConsignedUsage.cncud_price      = cncix_price
         bConsignedUsage.cncud_ship_value = cncix_ship_value
         bConsignedUsage.cncud_curr       = cncix_curr
         bConsignedUsage.cncud_asn_shipper = cncix_asn_shipper
         bConsignedUsage.po               = cncix_po
         bConsignedUsage.cncud_ship_date  = cncix_ship_date
         bConsignedUsage.cncud_usage_qty  = ip_qty
         bConsignedUsage.cncud_usage_um   = ip_um
         bConsignedUsage.cncud_usage_um_conv   = ip_um_conv
         bConsignedUsage.cncud_current_loc     = cncix_current_loc
         bConsignedUsage.lotser           = cncix_lotser
         bConsignedUsage.ref              = cncix_ref
         bConsignedUsage.auth             = cncix_auth
         bConsignedUsage.cust_seq         = cncix_cust_seq
         bConsignedUsage.cust_job         = cncix_cust_job
         bConsignedUsage.cust_ref         = cncix_cust_ref
         bConsignedUsage.cncud_cust_dock  = cncix_cust_dock
         bConsignedUsage.cncud_line_feed  = cncix_line_feed
         bConsignedUsage.modelyr          = cncix_modelyr
         bConsignedUsage.cncud_aged_date = cncix_aged_date
         bConsignedUsage.cncud_orig_aged_date = cncix_orig_aged_date
         bConsignedUsage.cncud_ship_trnbr = cncix_ship_trnbr
         bConsignedUsage.cust_usage_ref = ip_cust_usage_ref
         bConsignedUsage.cust_usage_date  = ip_cust_usage_date
         bConsignedUsage.cncu_batch       = io_batch
         bConsignedUsage.trans_date       = today
         bConsignedUsage.eff_date         = ip_eff_date
         bConsignedUsage.origin           = ip_origin.

      if recid (bConsignedUsage) = -1 then .


        /* CALL THE USAGE PROCESSOR */
        /*  - Update Sales Order Qty to Invoice */
        /*  - Update Sales Order CUMS           */
        /*  - Create ISS-SO, CN-USE             */
        /*  - Reduce consigned inventory        */
        /*  - CREATE consigned usage records    */
        /*  - CREATE self-billling records      */

/* ss 20070302.1 - b */
/*
      {gprun.i ""socnis.p""
 */
      {gprun.i ""xxsocnis.p""
               "(input ip_tot_qty_consumed * ip_um_conv,
                 input ip_tot_lotser_consumed * ip_um_conv,
                 input ip_eff_date,
                 input-output table tt_cons_usage,
                 input-output io_trnbr)"}.
/* ss 20070302.1 - e */

      if return-value <> {&SUCCESS-RESULT} then
         return return-value.

        /* SAVE OFF USAGE ID */
      for first bConsignedUsage
         exclusive-lock:
         io_batch = bConsignedUsage.cncu_batch.
      end.


        /* DELETE THE USAGE BUFFER */
      delete bConsignedUsage.
   end. /*Do on error undo..*/

   return {&SUCCESS-RESULT}.

END PROCEDURE. /*createConsignedUsage*/



/* ========================================================================= */
PROCEDURE getSalesOrderDetailData:
/* -------------------------------------------------------------------------
Purpose:      This procedure reads the SO detail record and passes back data.
Exceptions:   None
Conditions:
Pre:
Post:
Notes:
History:
 --------------------------------------------------------------------------- */

   define input  parameter    ip_order as character no-undo.
   define input  parameter    ip_line  as integer no-undo.
   define output parameter    op_scheduled as logical no-undo.
   define output parameter    op_curr_rlse_id as character no-undo.
   define output parameter    op_cum_shipped_qty as decimal no-undo.
   define output parameter    op_auto_replenish as logical no-undo.
   define output parameter    op_shipfrom_site as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      for first sod_det
            fields( sod_domain sod_sched sod_curr_rlse_id sod_site
                   sod_cum_qty sod_auto_replenish)
          where sod_det.sod_domain = global_domain and  sod_nbr  = ip_order
         and sod_line = ip_line
         no-lock:

         assign
            op_scheduled        = sod_sched
            op_shipfrom_site    = sod_site
            op_curr_rlse_id     = sod_curr_rlse_id[3]
            op_cum_shipped_qty  = sod_cum_qty[1]
            op_auto_replenish   = sod_auto_replenish.

      end.  /* for first sod_det */

   end. /*Do on error undo*/

   return {&SUCCESS-RESULT}.

END PROCEDURE. /*getSalesOrderDetailData*/


/* ========================================================================= */
PROCEDURE updateCurrentRelease:
/* -------------------------------------------------------------------------
Purpose:      This procedure adds a new requirement to the type-3 Required
              Shipping Schedule.  If the requirement already exists, then the
              existing requirement quantity is updated.
Exceptions:   None
 --------------------------------------------------------------------------- */

   define input parameter    ip_order as character no-undo.
   define input parameter    ip_line as integer no-undo.
   define input parameter    ip_curr_rlse_id as character no-undo.
   define input parameter    ip_cum_shipped_qty as decimal no-undo.
   define input parameter    ip_shipfrom_site as character no-undo.
   define input parameter    ip_qty as decimal no-undo.

   define variable new_date as date no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

        /* GET SCHEDULE MASTER */
      for first sch_mstr
            fields( sch_domain sch_cumulative sch_pcr_qty)
          where sch_mstr.sch_domain = global_domain and  sch_nbr      = ip_order
         and sch_line     = ip_line
         and sch_type     = 3                       /* RSS */
         and sch_rlse_id  = ip_curr_rlse_id
         no-lock:
      end.  /* for first sch_mstr */

        /* DETERMINE WHERE THE NEXT OPEN REQUIREMENTS ARE ON THE SCHEDULE */
      for first schd_det
            fields( schd_domain schd_upd_qty)
          where schd_det.schd_domain = global_domain and  schd_nbr      =
          ip_order
         and schd_line     = ip_line
         and schd_type     = 3                       /* RSS */
         and schd_rlse_id  = ip_curr_rlse_id
         and schd_cum_qty  > ip_cum_shipped_qty
         and trim(substring(schd_fc_qual,2,1)) = "" /* NOT FULLY SHIPPED */
         exclusive-lock:
      end.

      if available (schd_det) then
         /* ADD TO OPEN REQUIREMENTS IF EXISTS */
         schd_upd_qty = schd_upd_qty + ip_qty.

      else do:
         /* ADD TO END OF THE SCHEDULE */
         for last schd_det
            fields( schd_domain schd_date)
             where schd_det.schd_domain = global_domain and  schd_nbr      =
             ip_order
              and schd_line     = ip_line
              and schd_type     = 3                       /* RSS */
              and schd_rlse_id  = ip_curr_rlse_id
            no-lock:
         end.

         if available (schd_det) then
            new_date = schd_date + 1.
         else
            new_date = today + 1.

           /* CREATE NEW REQUIREMENT */
         create schd_det. schd_det.schd_domain = global_domain.
         assign
            schd_type       = 3
            schd_nbr        = ip_order
            schd_line       = ip_line
            schd_rlse_id    = ip_curr_rlse_id
            schd_date       = new_date
            schd_interval   = "D"
            schd_upd_qty    = ip_qty
            substring(schd_fc_qual,1,1) = "F".

              /* FORWARD SCHEDULE THE REQUIREMENT BASED ON SITE CALENDAR */
         {rchdate.i schd_date 1 ip_shipfrom_site}

      end.  /* else do */

        /* UPDATE CUM QUANTITIES */
      prior_cum_qty = sch_pcr_qty.

      for each schd_det
          where schd_det.schd_domain = global_domain and  schd_type     = 3 and
               schd_nbr      = ip_order  and
               schd_line     = ip_line and
               schd_rlse_id  = ip_curr_rlse_id
         exclusive-lock:

         if sch_cumulative then
            assign
               schd_cum_qty   = if schd_upd_qty > prior_cum_qty
                                     then schd_upd_qty
                                     else schd_upd_qty + prior_cum_qty
               schd_discr_qty = schd_cum_qty - prior_cum_qty
               prior_cum_qty  = prior_cum_qty + schd_discr_qty.

         else
            assign
               schd_discr_qty = schd_upd_qty
               prior_cum_qty  = prior_cum_qty + schd_discr_qty
               schd_cum_qty   = prior_cum_qty.

      end.  /* for each schd_det */
   end. /*Do on error undo*/

   return {&SUCCESS-RESULT}.

END PROCEDURE. /*updateCurrentRelease*/
