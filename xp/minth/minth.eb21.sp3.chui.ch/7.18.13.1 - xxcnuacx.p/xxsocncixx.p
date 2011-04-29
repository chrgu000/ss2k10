/* socncix.p - Create Consignment Shipment/Inventory Cross-Reference          */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.34.1.2 $                                          */
/*----------------------------------------------------------------------------*/
/*  Purpose:   Creates/updates/deletes the consignment shipment/inventory     */
/*             cross-reference record.                                        */
/*  Notes:                                                                    */
/*----------------------------------------------------------------------------*/

/* Revision: 1.19       BY: Patrick Rowan         DATE: 04/04/02  ECO: *P00F* */
/* Revision: 1.21       BY: Paul Donnelly (SB)    DATE: 06/28/03  ECO: *Q00L* */
/* Revision: 1.22       BY: Katie Hilbert         DATE: 08/25/03  ECO: *P10Y* */
/* Revision: 1.23       BY: Sandy Brown (OID)     DATE: 12/06/03  ECO: *Q04L* */
/* Revision: 1.24       BY: Vivek Gogte           DATE: 01/05/04  ECO: *P1H4* */
/* Revision: 1.26       BY: Robin McCarthy        DATE: 04/19/04  ECO: *P15V* */
/* Revision: 1.29       BY: Patrick Rowan         DATE: 10/11/04  ECO: *P2PH* */
/* Revision: 1.31       BY: Abhishek Jha          DATE: 12/08/04  ECO: *P2YJ* */
/* Revision: 1.34       BY: Bharath Kumar         DATE: 03/10/05  ECO: *P3C4* */
/* Revision: 1.34.1.1   BY: Reena Ambavi          DATE: 04/07/05  ECO: *P3FT* */
/* $Revision: 1.34.1.2 $ BY: Shivganesh Hegde DATE: 05/10/05 ECO: *P3KR* */
/* $Revision: 1.34.1.2 $ BY: mage chen            DATE: 04/02/07 ECO: *minth* */


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




/*************************************************************以下为版本历史 */  
/*minth* 20070402 by Mage Chen  */
/* SS - 090401.1  By: Roger Xiao */

/*************************************************************以下为发版说明 */

/* SS - 090401.1 - RNB
1.原程式库存记录锁定时间太长,原因查找abs_mstr时未加domain,太慢, 仅修改xxsocncixx.p
xxcnuacx.p --> xxsocnuac2x.p --> xxsocnisx.p --> xxsocncixx.p
2.取消锁定库存记录:原xxsocnisx.p直接调用ictrans.i,现改为: xxsocnisx.p  --> xxictransxp01.p --> xxictransxp01.i
  并release ld_det & in_mstr 
  注意: &slspsn3 &slspsn4 &trordrev 在xxictransxp01.i与ictrans.i使用方式不同

SS - 090401.1 - RNE */





{mfdeclre.i}
{gpoidfcn.i}  /* Defines nextOidValue() function */
{pxsevcon.i}

define input parameter ip_order     like sod_nbr no-undo.
define input parameter ip_line      like sod_line no-undo.
define input parameter ip_site      like sod_site no-undo.
define input parameter ip_ship_date like so_ship_date no-undo.
define input parameter ip_ship_qty  like sod_qty_ship no-undo.
define input parameter ip_stock_um  like sod_um no-undo.
define input parameter ip_asn       like abs_id no-undo.
define input parameter ip_trnbr     like tr_trnbr no-undo.
define input parameter ip_location  like sod_loc no-undo.
define input parameter ip_lotser    like sod_serial no-undo.
define input parameter ip_ref       like ld_ref no-undo.
define input parameter ip_auth      like absr_reference no-undo.
define input parameter ip_cust_job  as character no-undo.
define input parameter ip_cust_seq  as character no-undo.
define input parameter ip_cust_ref  as character no-undo.
define input parameter ip_dock      as character no-undo.
define input parameter ip_line_feed as character no-undo.
define input parameter ip_modelyr   as character no-undo.
define input parameter ip_shipment  as logical no-undo.
define input parameter ip_cncix_pkey  like cncix_pkey no-undo. /*minth mage add*/
define input-output parameter io_first_time as logical no-undo.

define variable return_status      as integer no-undo.
define variable working_qty        like sod_qty_ship no-undo.
define variable tmp_qty_stock      like sod_qty_ship no-undo.
define variable tmp_qty_ship       like sod_qty_ship no-undo.
define variable tmp_amt            like sod_qty_ship no-undo.
define variable part               like pt_part      no-undo.
define variable consign_qty_oh     as decimal        no-undo.
define variable qty_chg            as decimal        no-undo.
define variable memo_type          as logical        no-undo.

define variable l_asn_id like abs_par_id no-undo.
define variable l_asn_ck like mfc_logical initial no.


{socnvars.i}   /* CONSIGNMENT VARIABLES */

{socncix.i}    /* FUNCTIONS/PROCEDURES */

procblk:
do on error undo, leave:

   /* INITIALIZE WORKING QTY */
   working_qty = ip_ship_qty.

   l_asn_id = "s" + ip_asn.

/* SS - 090401.1 - B */
    l_asn_ck       = no .
   for each dom_mstr fields (dom_domain) no-lock:
       if can-find(first abs_mstr where
                   abs_domain      = dom_domain      and 
                   abs_order       = ip_order        and
                   abs_line        = string(ip_line) and
                   abs_shipfrom    = ip_site         and
                   abs_lotser      = ip_lotser       and
                   abs_ref         = ip_ref          and
                   abs__qadc01     = "yes")
       then
          l_asn_ck       = yes.
   end.
/* SS - 090401.1 - E */

/*SS - 090401.1 - B 
   if can-find(first abs_mstr where
               abs_order       = ip_order        and
               abs_line        = string(ip_line) and
               abs_shipfrom    = ip_site         and
               abs_lotser      = ip_lotser       and
               abs_ref         = ip_ref          and
               abs__qadc01     = "yes")
   then
      l_asn_ck       = yes.
SS - 090401.1 - E */


   /* DETERMINE IF THERE ARE X-REFERENCE RECORDS TO REPLACE.        */
   /* THESE HAVE OPPOSITE SIGNED QUANTITY THAN THE WORKING_QTY.     */
   /* THIS HANDLES REVERSALS AND OVER-ISSUES.                       */
/*minth del***********************************************************************
   for each cncix_mstr
      where cncix_domain       = global_domain
      and  (cncix_so_nbr       = ip_order
      and   cncix_sod_line     = ip_line
      and   cncix_pkey          = ip_cncix_pkey   /*minth*  magee add ********/
      and   cncix_lotser       = ip_lotser
      and   cncix_ref          = ip_ref
      and   cncix_auth         = ip_auth
      and   cncix_cust_job     = ip_cust_job
      and   cncix_cust_ref     = ip_cust_ref
      and   cncix_cust_dock    = ip_dock
      and   cncix_line_feed    = ip_line_feed
      and   (cncix_asn_shipper = ip_asn
             or l_asn_ck      = yes)
      and   cncix_site         = ip_site
      and   cncix_current_loc  = ip_location
      and ((working_qty > 0 and cncix_qty_stock < 0)
                             or
           (working_qty < 0 and cncix_qty_stock > 0)))
   exclusive-lock
   break by cncix_so_nbr
         by cncix_sod_line
         by cncix_ship_date
         by cncix_asn_shipper:
*minth del***********************************************************************/
/*minth add***********************************************************************/
   for each cncix_mstr
      where cncix_domain       = global_domain
      and  (cncix_so_nbr       = ip_order
      and   cncix_sod_line     = ip_line
      and   cncix_pkey          = ip_cncix_pkey   /*minth*  magee add ********/
      and   cncix_lotser       = ip_lotser
      and   cncix_ref          = ip_ref
      and   cncix_auth         = ip_auth
      and   cncix_cust_job     = ip_cust_job
      and   cncix_cust_ref     = ip_cust_ref
      and   cncix_cust_dock    = ip_dock
      and   cncix_line_feed    = ip_line_feed
      and   (cncix_asn_shipper = ip_asn
             or l_asn_ck      = yes)
      and   cncix_site         = ip_site
      and   cncix_current_loc  = ip_location
      and ((working_qty > 0 and cncix_qty_stock < 0)
                             or
           (working_qty < 0 and cncix_qty_stock >  0)))
   exclusive-lock
   break by cncix_so_nbr
         by cncix_sod_line
         by cncix_ship_date
         by cncix_asn_shipper:
/*minth add***********************************************************************/
      part = cncix_part.
 
      /* IF TEMPORARY RECORDS EXIST THEN GATHER THEM AND REPLACE AS   */
      /* MANY AS POSSIBLE WITH THE SHIPPED QTY.                       */
      /*    THE TEMPORARY RECORDS ARE 'PLACEHOLDERS' FOR OVER-ISSUED  */
      /*    MATERIAL.  THEY HAVE NEGATIVE ON-HAND QTY.                */
      /*    THIS CAN OCCUR WITH E-COMMERCE AND AN IN-TRANSIT LOCATION */
      /*    HAVING AN INVENTORY STATUS CODE WITH OVERISSUE = YES.     */
      /*    WHEN USAGE OCCURS BEFORE THE WAREHOUSE GETS THE RECEIPT   */
      /*    SIGNAL TO MOVE THE QTY OUT OF IN-TRANSIT, RESULTING IN A  */
      /*    NEGATIVE ON-HAND QTY.                                     */
      /*    BY THE TIME THIS CODE IS REACHED, IT HAS ALREADY BEEN     */
      /*    DETERMINED THAT THE LOCATION (IN-TRANSIT OR CONSIGNMENT)  */
      /*    PERMITS OVERISSUE.                                        */
      /* DELETE ANY TEMPORARY RECORDS WITH ZERO ON-HAND QTY.    */

      /* CALCULATE NEW SHIP AND ON-HAND QTY */
      assign
         qty_chg = working_qty
         tmp_qty_ship = cncix_qty_ship + working_qty
         tmp_qty_stock  = cncix_qty_stock   + working_qty.

      /* IF THE SHIPMENT OR RETURN/REVERSAL QUANTITY MAKES UP     */
      /* FOR THE ORIGINAL SHIPMENT OR ON-HAND QTY, THEN DELETE    */
      /* THE TEMPORARY RECORD.  OTHERWISE, UPDATE THE TEMPORARY   */
      /* RECORD WITH THE NEW QUANTITIES.                          */
      if (cncix_qty_stock < 0 and        /* NEGATIVE OH QTY   */
         ip_ship_qty   >  0 and          /* POSITIVE SHIP QTY */
         tmp_qty_stock >= 0)
                           or
         (cncix_qty_stock > 0 and        /* POSITIVE OH QTY   */
         ip_ship_qty   <  0 and          /* NEGATIVE SHIP QTY */
         tmp_qty_stock <= 0)
      then do:
         qty_chg = - cncix_qty_stock.
/*minth  
         delete cncix_mstr.  */
/*minth add ***************************************/
assign
            cncix_qty_stock  = 0
            cncix_qty_ship   = if ip_shipment then tmp_qty_ship
                               else cncix_qty_ship
            cncix_ship_value = if ip_shipment then cncix_ship_value +
                                  (cncix_price * working_qty)
                               else cncix_ship_value.

/*minth add ***************************************/


      end.
      else
         /* QTY-ON-HAND GETS UPDATED ON BOTH SHIPMENT AND USAGE. */
         /* QTY SHIPPED AND AMOUNT ON ORDER ARE ONLY UPDATED     */
         /* ON SHIPMENTS, NOT USAGE.                             */
         assign
            cncix_qty_stock  = tmp_qty_stock
            cncix_qty_ship   = if ip_shipment then tmp_qty_ship
                               else cncix_qty_ship
            cncix_ship_value = if ip_shipment then cncix_ship_value +
                                  (cncix_price * working_qty)
                               else cncix_ship_value.
 
      /* DETERMINE IF SO/LINE IS A MEMO-TYPE. */
      /* IF MEMO-TYPE THEN INVENTORY RECORDS ARE NOT UPDATED */
      memo_type = if can-find(first sod_det where
                           sod_domain = global_domain and
                           sod_order = ip_order and
                           sod_line  = ip_line and
                           sod_type = "M")
                    then true
                    else false.


      /* UPDATE CONSIGNMENT ON-HAND QTY (UNLESS SOD IS MEMO ITEM) */
      if memo_type = No then do:
         run updateConsignmentQty
            (input  ip_site,
             input  ip_location,
             input  part,
             input  ip_lotser,
             input  ip_ref,
             input  qty_chg,
             output consign_qty_oh).
      end.  /* if memo_type = No */

      /* ADJUST ACCUMULATOR QTY */
      working_qty = tmp_qty_stock.

      /* LEAVE IF working_qty HAS CHANGED SIGNS FROM */
      /* ORIGINAL QTY.  SET working_qty TO ZERO.     */
      if (working_qty <= 0 and       /* NEGATIVE WORKING QTY */
         ip_ship_qty  >  0)          /* POSITIVE SHIP QTY    */
                     or
         (working_qty >= 0 and       /* POSITIVE WORKING QTY */
         ip_ship_qty  <  0)          /* NEGATIVE SHIP QTY    */
      then do:
         working_qty = 0.
         leave.
      end.

   end.  /* for each cncix_mstr */


   /* IF ACCUMULATOR QTY IS STILL <> 0 */
   if working_qty <> 0 then do:

      qty_chg = working_qty.

      /* CREATE TEMP-TABLE BUFFER TO PASS DATA */
      run createConsignShipmentXRefBuffer
         (buffer bConsignShipmentXRef).

      /* ASSIGN KEY VALUES */
      assign
         bConsignShipmentXRef.cncix_so_nbr      = ip_order
         bConsignShipmentXRef.cncix_sod_line    = ip_line
         bConsignShipmentXRef.cncix_site        = ip_site
         bConsignShipmentXRef.cncix_current_loc = ip_location
         bConsignShipmentXRef.cncix_lotser      = ip_lotser
         bConsignShipmentXRef.cncix_ref         = ip_ref
         bConsignShipmentXRef.cncix_auth        = ip_auth
         bConsignShipmentXRef.cncix_cust_job    = ip_cust_job
         bConsignShipmentXRef.cncix_cust_seq    = ip_cust_seq
         bConsignShipmentXRef.cncix_cust_ref    = ip_cust_ref
         bConsignShipmentXRef.cncix_cust_dock   = ip_dock
         bConsignShipmentXRef.cncix_line_feed   = ip_line_feed
         bConsignShipmentXRef.cncix_modelyr     = ip_modelyr
         /* SHIP DATE IS ASSIGNED HERE BECAUSE IT IS MANDATORY */
         bConsignShipmentXRef.cncix_ship_date   = ip_ship_date
         bConsignShipmentXRef.cncix_ship_trnbr  = ip_trnbr.

      /* DETERMINE IF THERE ARE SHIPMENT X-REF RECORDS TO REPLACE */
      if isConsignShipmentXRefExists (buffer bConsignShipmentXRef)
      then do:

         /* IF SHIPMENT X-REF EXISTS THEN UPDATE WITH SHIP QTY */
         run readConsignShipmentXRef
            (buffer bConsignShipmentXRef,
             input {&LOCK_FLAG},
             input {&WAIT_FLAG}).

         assign
            bConsignShipmentXRef.cncix_qty_stock   =
               bConsignShipmentXRef.cncix_qty_stock + working_qty
            bConsignShipmentXRef.cncix_qty_ship = if ip_shipment
               then
                  bConsignShipmentXRef.cncix_qty_ship + working_qty
               else
                  bConsignShipmentXRef.cncix_qty_ship
            bConsignShipmentXRef.cncix_ship_value  = if ip_shipment
               then
                  bConsignShipmentXRef.cncix_ship_value +
                  (bConsignShipmentXRef.cncix_price * working_qty)
               else
                  bConsignShipmentXRef.cncix_ship_value
            part = bConsignShipmentXRef.cncix_part.

         run updateConsignShipmentXRef
              (buffer bConsignShipmentXRef).

      end.  /* if isConsignShipmentXRefExists */
      else do:

         /* IF SHIPMENT X-REF DOESN'T EXIST THEN CREATE ONE */

         /* GENERATE NEW PRIMARY KEY RECORD */
         run createConsignShipmentXRefPrimaryKey
            (buffer bConsignShipmentXRef).

         /* CREATE SHIPMENT INVENTORY X-REFERENCE RECORD */
         run createConsignShipmentXRef
            (buffer bConsignShipmentXRef).

         /* GET SALES ORDER MASTER DATA */
         run getSalesOrderMasterData
            (input  ip_order,
             output bConsignShipmentXRef.cncix_shipto,
             output bConsignShipmentXRef.cncix_cust,
             output bConsignShipmentXRef.cncix_curr,
             output bConsignShipmentXRef.cncix_po,
             output bConsignShipmentXRef.cncix_selfbill).

         /* GET SALES ORDER DETAIL DATA */
         run getSalesOrderDetailData
            (input  ip_order,
             input  ip_line,
             output bConsignShipmentXRef.cncix_part,
             output bConsignShipmentXRef.cncix_custpart,
             output bConsignShipmentXRef.cncix_price,
             output bConsignShipmentXRef.cncix_intrans_loc,
             output bConsignShipmentXRef.cncix_max_aging_days,
             output bConsignShipmentXRef.cncix_translt_days,
             output memo_type,
             input-output bConsignShipmentXRef.cncix_po).

         /* GET PART MASTER DATA */
         run getPartMasterData
            (input  bConsignShipmentXRef.cncix_part,
             output bConsignShipmentXRef.cncix_stock_um).

         /* ASSIGN DATA VALUES */
         assign
            bConsignShipmentXRef.cncix_ship_trnbr  = ip_trnbr
            bConsignShipmentXRef.cncix_qty_ship    = ip_ship_qty
            bConsignShipmentXRef.cncix_asn_shipper = ip_asn
            bConsignShipmentXRef.cncix_qty_stock   = working_qty
            bConsignShipmentXRef.cncix_ship_value  =
               (bConsignShipmentXRef.cncix_price * working_qty)
            bConsignShipmentXRef.cncix_intransit   =
               (if bConsignShipmentXRef.cncix_intrans_loc = ip_location
                then yes else no)
            part = bConsignShipmentXRef.cncix_part.

         /* DETERMINE MAX AGE DATE */
         /* ADD THE MAX AGING DAYS AND THE TRANSIT   */
         /* LEAD TIME TO THE SHIP DATE TO DETERMINE  */
         /* THE MAX DATE THE MATERIAL CAN AGE BEFORE */
         /* ITS CONSIDERED TO CHANGE OWNERSHIP.      */
         if bConsignShipmentXRef.cncix_max_aging_days > 0 then
            assign
               bConsignShipmentXRef.cncix_aged_date
                         =  ip_ship_date
                         +  bConsignShipmentXRef.cncix_max_aging_days
                         +  bConsignShipmentXRef.cncix_translt_days
               bConsignShipmentXRef.cncix_orig_aged_date
                         =  bConsignShipmentXRef.cncix_aged_date.

           run updateConsignShipmentXRef
              (buffer bConsignShipmentXRef).

           io_first_time = no.

      end.  /* else do */

      /* UPDATE CONSIGNMENT ON-HAND QTY (UNLESS SOD IS MEMO ITEM) */
      if memo_type = No then do:
         run updateConsignmentQty
            (input  ip_site,
             input  ip_location,
             input  part,
             input  ip_lotser,
             input  ip_ref,
             input  qty_chg,
             output consign_qty_oh).
      end.  /* if memo_type = No */

   end.  /* if working_qty <> 0 */

end. /* procblk */


/* ========================================================================= */
/* ************************ INTERNAL PROCEDURES **************************** */
/* ========================================================================= */

/* ========================================================================= */
PROCEDURE getSalesOrderMasterData:
/* -------------------------------------------------------------------------
 * Purpose:      This procedure reads the SO master record and passes back data.
 *--------------------------------------------------------------------------- */

   define input  parameter    ip_order as character no-undo.
   define output parameter    op_ship  as character no-undo.
   define output parameter    op_cust  as character no-undo.
   define output parameter    op_curr  as character no-undo.
   define output parameter    op_po  as character no-undo.
   define output parameter    op_selfbill  as logical no-undo.


   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      for first so_mstr
         fields (so_domain so_ship so_cust so_bill so_curr so_po)
         where   so_domain = global_domain
         and     so_nbr = ip_order
      no-lock:

         assign
            op_ship  = so_ship
            op_cust  = so_cust
            op_curr  = so_curr
            op_po    = so_po.

         /* DETERMINE IF SELF-BILLING IS ACTIVE */
         /* AND IF BILL-TO IS REGISTERED FOR SELF-BILLING */
         op_selfbill = if can-find (first mfc_ctrl
                                 where mfc_domain = global_domain
                                   and mfc_field = "enable_self_bill"
                                   and mfc_seq = 2 and mfc_module = "ADG"
                                   and mfc_logical = yes) and
                             can-find (cm_mstr
                                 where cm_domain = global_domain
                                   and cm_addr = so_bill
                                   and cm__qad06 = yes)
                          then yes
                          else no.

        end.  /* for first so_mstr */

     end. /*Do on error undo*/

     return {&SUCCESS-RESULT}.

END PROCEDURE. /*getSalesOrderMasterData*/


/* ========================================================================= */
PROCEDURE getSalesOrderDetailData:
/* -------------------------------------------------------------------------
 * Purpose:      This procedure reads the SO detail record and passes back data.
 *--------------------------------------------------------------------------- */

   define input  parameter    ip_order as character no-undo.
   define input  parameter    ip_line  as integer no-undo.
   define output parameter    op_part  like sod_part no-undo.
   define output parameter    op_custpart  like sod_custpart no-undo.
   define output parameter    op_price  like sod_price no-undo.
   define output parameter    op_intrans_loc  as character no-undo.
   define output parameter    op_max_aging_days  as integer no-undo.
   define output parameter    op_translt_days  as decimal no-undo.
   define output parameter    op_memo_type  as logical no-undo.
   define input-output parameter ip_po  as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      /* GET SALES ORDER CONSIGNMENT DATA*/
      for first so_mstr
          fields (so_domain so_conrep so_nbr)
      no-lock
         where so_domain = global_domain
         and   so_nbr = ip_order,
      first sod_det
         fields (sod_domain sod_part sod_custpart sod_um sod_price
                 sod_nbr sod_line sod_sched sod_translt_days sod_type
                 sod_contr_id sod_intrans_loc sod_max_aging_days)
         where   sod_domain = global_domain
         and     sod_nbr  = so_nbr
         and     sod_line = ip_line
     no-lock:

        assign
           op_part             = sod_part
           op_custpart         = (if sod_custpart <> "" then sod_custpart
                                  else sod_part)
           op_price            = sod_price
           ip_po               = (if sod_sched then sod_contr_id
                                  else ip_po)
           op_intrans_loc      = sod_intrans_loc
           op_max_aging_days   = sod_max_aging_days
           op_translt_days     = sod_translt_days
           op_memo_type        = (if sod_type = "M" then true
                                  else false).
        end.  /* for first so_mstr */

     end. /*Do on error undo*/

     return {&SUCCESS-RESULT}.

END PROCEDURE. /*getSalesOrderDetailData*/


/* ========================================================================= */
PROCEDURE getPartMasterData:
/* -------------------------------------------------------------------------
 * Purpose:    This procedure reads the part master record and passes back data.
 *--------------------------------------------------------------------------- */

   define input  parameter    ip_part as character no-undo.
   define output parameter    op_um  like pt_um no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:

      for first pt_mstr
         fields (pt_domain pt_um)
         where   pt_domain = global_domain
         and     pt_part   = ip_part
      no-lock:

         op_um = pt_um.

      end.  /* for first pt_mstr */

   end. /*Do on error undo*/

   return {&SUCCESS-RESULT}.

END PROCEDURE. /*getPartMasterData*/

/* ========================================================================= */
PROCEDURE updateConsignmentQty:
/* -------------------------------------------------------------------------
 * Purpose:    This procedure updates the consignment on-hand qty in the
 *             in_mstr and ld_det tables.
 *--------------------------------------------------------------------------- */
   define input  parameter ip_site        as character no-undo.
   define input  parameter ip_location    as character no-undo.
   define input  parameter ip_part        as character no-undo.
   define input  parameter ip_lotser      as character no-undo.
   define input  parameter ip_ref         as character no-undo.
   define input  parameter ip_qty_chg     as decimal   no-undo.
   define output parameter consign_qty_oh as decimal   no-undo.

   /* UPDATE INVENTORY MASTER CONSIGNMENT ON-HAND QTY */
 /*mage del 08/08/20  {gprun.i ""socnin.p""
            "(input ""update"",
              input ip_site,
              input ip_part,
              input ip_qty_chg,
              output consign_qty_oh)"}  */
/*mage add 08/08/20  */  {gprun.i ""xxsocnin.p""
            "(input ""update"",
              input ip_site,
              input ip_part,
              input ip_qty_chg,
              output consign_qty_oh)"}  


   /* UPDATE LOCATION DETAIL CONSIGNMENT ON-HAND QTY */
   {gprun.i ""socnld.p""
            "(input ""update"",
              input ip_site,
              input ip_part,
              input ip_location,
              input ip_lotser,
              input ip_ref,
              input ip_qty_chg,
              output consign_qty_oh)"}

END PROCEDURE. /* updateConsignmentQty */
