/* mfivtr.i - INCLUDE FILE TO CREATE TRANSACTION FOR SHIPMENT                 */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */

/******************************************************************************/
/*!
 *  {1} = "input frame bi" for use on delete or modify
 *  {1} = " " for add
 *  {2} = "update in_qty_req" to update in_qty_req
 *  {2} = anything else to prevent update of in_qty_req
 */
/******************************************************************************/

/* REVISION: 1.0      LAST MODIFIED: 08/31/86   BY: pml *17  *                */
/* REVISION: 6.0      LAST MODIFIED: 04/03/90   BY: WUG *D015*                */
/* REVISION: 6.0      LAST MODIFIED: 04/05/90   BY: ftb *D002*                */
/* REVISION: 6.0      LAST MODIFIED: 04/16/90   BY: WUG *D002*                */
/* REVISION: 6.0      LAST MODIFIED: 04/30/90   BY: MLB *D021*                */
/* REVISION: 6.0      LAST MODIFIED: 10/26/90   BY: pml *D143*                */
/* REVISION: 6.0      LAST MODIFIED: 03/11/91   BY: afs *D414*                */
/* REVISION: 6.0      LAST MODIFIED: 03/18/91   BY: MLB *D443*                */
/* REVISION: 6.0      LAST MODIFIED: 04/02/91   BY: WUG *D472*                */
/* REVISION: 6.0      LAST MODIFIED: 10/07/91   BY: alb *D887*                */
/* REVISION: 7.0      LAST MODIFIED: 11/06/91   BY: pma *F003*                */
/* REVISION: 7.0      LAST MODIFIED: 02/12/92   BY: pma *F190*                */
/* REVISION: 7.0      LAST MODIFIED: 02/26/92   BY: afs *F240*                */
/* REVISION: 7.0      LAST MODIFIED: 03/20/92   BY: dld *F297*                */
/* REVISION: 7.0      LAST MODIFIED: 04/06/92   BY: dld *F358*                */
/* REVISION: 7.0      LAST MODIFIED: 05/13/92   BY: sas *F450*                */
/* REVISION: 7.0      LAST MODIFIED: 06/08/92   BY: tjs *F504*                */
/* REVISION: 7.0      LAST MODIFIED: 07/23/92   BY: tjs *F805*                */
/* REVISION: 7.0      LAST MODIFIED: 08/19/92   BY: tjs *F859*                */
/* REVISION: 7.4      LAST MODIFIED: 09/16/93   BY: dpm *H075*                */
/* REVISION: 7.4      LAST MODIFIED: 01/28/94   BY: dpm *FL77*                */
/* REVISION: 7.4      LAST MODIFIED: 03/23/94   BY: dpm *FM97*                */
/* REVISION: 7.4      LAST MODIFIED: 04/25/94   BY: WUG *GJ58*                */
/* REVISION: 7.4      LAST MODIFIED: 07/13/94   BY: dpm *FP41*                */
/* REVISION: 7.4      LAST MODIFIED: 08/12/94   BY: dpm *FQ11*                */
/* REVISION: 7.4      LAST MODIFIED: 09/11/94   BY: rmh *GM13*                */
/* REVISION: 7.4      LAST MODIFIED: 10/04/94   BY: pxd *FR90*                */
/* REVISION: 7.4      LAST MODIFIED: 12/12/94   BY: dpm *FT84*                */
/* REVISION: 7.4      LAST MODIFIED: 01/05/95   BY: jxz *G0BG*                */
/* REVISION: 7.4      LAST MODIFIED: 02/24/95   BY: smp *F0H4*                */
/* REVISION: 8.5      LAST MODIFIED: 03/29/95   BY: dpm *J044*                */
/* REVISION: 8.5      LAST MODIFIED: 03/29/95   BY: dzn *F0PN*                */
/* REVISION: 7.4      LAST MODIFIED: 08/16/95   BY: bcm *G0V5*                */
/* REVISION: 7.4      LAST MODIFIED: 10/05/95   BY: ais *G0YK*                */
/* REVISION: 7.4      LAST MODIFIED: 11/02/95   BY: jym *F0TC*                */
/* REVISION: 8.6      LAST MODIFIED: 09/23/96   BY: flm *K003*                */
/* REVISION: 8.6      LAST MODIFIED: 01/30/97   BY: kxn *K05G*                */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke        */
/* REVISION: 8.6      LAST MODIFIED: 04/14/97   BY: *H0X6* Jim Williams       */
/* REVISION: 8.6      LAST MODIFIED: 07/21/97   BY: *H1C8* Jim Williams       */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton       */
/* REVISION: 8.6E     LAST MODIFIED: 06/25/98   BY: *L034* Markus Barone      */
/* REVISION: 9.0      LAST MODIFIED: 09/30/98   BY: *J2CZ* Reetu Kapoor       */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B8* Hemanth Ebenezer   */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 04/21/99   BY: *F0Y0* Poonam Bahl        */
/* REVISION: 9.0      LAST MODIFIED: 06/22/99   BY: *J3BX* Reetu Kapoor       */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Robin McCarthy     */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KR* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 01/18/01   BY: *M0W0* Rajesh Kini        */
/* REVISION: 9.1      LAST MODIFIED: 09/25/00   BY: *N0WY* Mudit Mehta        */
/* Revision: 1.24     BY: Russ Witt               DATE: 09/21/01  ECO: *P01H* */
/* Revision: 1.25     BY: Anitha Gopal            DATE: 10/18/01  ECO: *M1N1* */
/* Revision: 1.26     BY: Nikita Joshi            DATE: 10/22/01  ECO: *M1LW* */
/* Revision: 1.27     BY: Rajaneesh Sarangi       DATE: 02/21/02  ECO: *L13N* */
/* Revision: 1.30     BY: Patrick Rowan           DATE: 03/24/02  ECO: *P00G* */
/* Revision: 1.31     BY: Patrick Rowan           DATE: 05/20/02  ECO: *P061* */
/* Revision: 1.32     BY: Jeff Wootton            DATE: 05/20/02  ECO: *P03G* */
/* Revision: 1.33     BY: Patrick Rowan           DATE: 05/24/02  ECO: *P018* */
/* Revision: 1.35     BY: Steve Nugent            DATE: 06/05/02  ECO: *P07Y* */
/* Revision: 1.38     BY: Dan Herman              DATE: 06/17/02  ECO: *P091* */
/* Revision: 1.39     BY: Nishit Vadhavkar        DATE: 06/27/02  ECO: *N1M2* */
/* Revision: 1.40     BY: Abbas Hirkani           DATE: 07/24/02  ECO: *P0C3* */
/* Revision: 1.41     BY: Ed van de Gevel         DATE: 09/05/02  ECO: *P0HQ* */
/* Revision: 1.42     BY: Mamata Samant           DATE: 09/12/02  ECO: *N1TP* */
/* Revision: 1.43     BY: Mercy Chittilapilly     DATE: 01/15/03  ECO: *N244* */
/* Revision: 1.45     BY: Subramanian Iyer        DATE: 03/25/03  ECO: *M22J* */
/* Revision: 1.46     BY: Narathip Weerakitpanich DATE: 05/08/03  ECO: *P0RL* */
/* Revision: 1.48     BY: Paul Donnelly (SB)      DATE: 06/28/03  ECO: *Q00G* */
/* Revision: 1.49     BY: Rajesh Kini             DATE: 08/14/03  ECO: *N2HN* */
/* Revision: 1.50     BY: Rajesh Kini             DATE: 11/25/03  ECO: *P1CF* */
/* Revision: 1.51     BY: Dayanand Jethwa         DATE: 01/07/04  ECO: *P1J2* */
/* Revision: 1.52     BY: Katie Hilbert           DATE: 03/03/04  ECO: *Q06B* */
/* Revision: 1.53     BY: Robin McCarthy          DATE: 04/19/04  ECO: *P15V* */
/* Revision: 1.54     BY: Shoma Salgaonkar        DATE: 08/25/04  ECO: *Q0CJ* */
/* Revision: 1.56     BY: Somesh Jeswani          DATE: 09/02/04  ECO: *P2HT* */
/* Revision: 1.58     BY: Ajay Nair               DATE: 11/18/04  ECO: *P2HN* */
/* Revision: 1.59     BY: Jignesh Rachh           DATE: 12/01/04  ECO: *P2XJ* */
/* Revision: 1.60     BY: Alok Gupta              DATE: 02/19/05  ECO: *P372* */
/* $Revision: 1.60.1.1 $       BY: Tejasvi Kulkarni        DATE: 01/17/06  ECO: *Q0PP* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:ConvertMode=Maintenance                                                  */

{cxcustom.i "MFIVTR.I"}

define variable is_wo_issue                as logical initial false no-undo.
define variable io_batch                   like cnsu_batch no-undo.
define variable using_supplier_consignment as logical no-undo.
define variable transfer as logical initial false no-undo.

{&MFIVTR-I-TAG9}

if execname = "soivmt.p" then
   for each sr_wkfl
      where sr_domain = global_domain
      and   sr_userid = mfguser
   exclusive-lock:
      delete sr_wkfl.
   end. /* FOR EACH sr_wkfl */

/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
         "(input 'enable_supplier_consignment',
           input 11,
           input 'ADG',
           input 'cns_ctrl',
           output using_supplier_consignment)"}

if sod_det.sod_um_conv = 0 then
   sod_det.sod_um_conv = 1.
qty_left = - {1}sod_qty_chg.

if l_qty_change
   or execname <> "soivmt.p"
then do:

   /*UPDATE ALLOCATION DETAIL AND LD_QTY_ALL*/
   for each lad_det
      where lad_domain  = global_domain
      and   lad_nbr     = sod_det.sod_nbr
      and   lad_line    = string(sod_det.sod_line)
      and   lad_dataset = "sod_det"
   exclusive-lock:
      find ld_det
         where ld_domain = global_domain
         and   ld_site   = lad_site
         and   ld_loc    = lad_loc
         and   ld_lot    = lad_lot
         and   ld_ref    = lad_ref
         and   ld_part   = lad_part
      exclusive-lock no-error.

      if available ld_det then
         ld_qty_all = ld_qty_all - (lad_qty_all + lad_qty_pick).

      delete lad_det.
   end. /* FOR EACH lad_det .. */

   {&MFIVTR-I-TAG1}

   /* DELETE KIT COMPONENT DETAIL ALLOCATIONS */
   {gprun.i ""soktdel1.p"" "(input recid(sod_det))"}

end. /* IF l_qty_change OR .. */

prev_found = no.
do for sr_wkfl
   while 
    /* SS - 20090606.1 - B */
    /* qty_left <> 0
   or*/
   /* SS - 20090606.1 - E */
   can-find(first sr_wkfl
   where sr_domain = global_domain
   and   sr_userid = mfguser
   and trim(sr_lineid) = trim(string(sod_det.sod_line))):

   assign
      trqty = qty_left
      site  = {1}sod_site.

   /* RETAINING THE OLD VALUES OF LOCATION AND LOTSER WHEN THEY ARE */
   /* EDITED SO THAT THE INVENTORY IS CORRECTLY ALLOCATED BACK      */
   /* TO THE OLD LOCATION AND LOTSER                                */
   if not l_lotedited then do:
      if location = "" then location = {1}sod_loc.
      if lotser = "" then lotser = {1}sod_serial.
   end. /* IF NOT L_LOTEDITED */

   /* CHECK TO SEE IF ITEM SERIAL NUMBER CONTROLLED */
   find first sr_wkfl
      where sr_domain = global_domain
      and   sr_userid = mfguser
      and   trim(sr_lineid) = trim(string(sod_det.sod_line))
   exclusive-lock no-error.

   if available sr_wkfl then do:
      assign
         site     = sr_site
         location = sr_loc
         lotser   = sr_lotser
         lotrf    = sr_ref
         trqty    = - sr_qty.

      delete sr_wkfl.
   end.

   {&MFIVTR-I-TAG2}
   if site <> sod_det.sod_site
      and sod_det.sod_type = ""
   then do:
      assign
         global_part = sod_det.sod_part
         global_addr = so_cust.

      {&MFIVTR-I-TAG3}

      transtype = "ISS-SO".

      {&MFIVTR-I-TAG4}

      if not available pt_mstr then
         for first pt_mstr
            where pt_domain = global_domain
            and   pt_part   = sod_det.sod_part
         no-lock: end.

      {&MFIVTR-I-TAG5}

       {gprun.i ""icxfer.p""
               "(input trlot,
                 input lotser,
                 input lotrf,
                 input lotrf,
                 input -1 * trqty * {1}sod_um_conv,
                 input {1}sod_nbr,
                 input {1}sod_nbr,
                 input """",
                 input """",
                 input eff_date,
                 input site,
                 input location,
                 input sod_det.sod_site,
                 input if available pt_mstr then pt_loc else location,
                 input no,
                 input """",
                 input ?,
                 input """",
                 input 0,
                 input """",
                 output glcost,
                 output iss_trnbr,
                 output rct_trnbr,
                 input-output assay,
                 input-output grade,
                 input-output expire)"}

      {&MFIVTR-I-TAG10}

      {&MFIVTR-I-TAG6}

      transfer = yes.
   end.

   if available pl_mstr then
      for first pld_det
         where pld_domain   = global_domain
         and   pld_prodline = pl_prod_line
         and   pld_site     = sod_det.sod_site
      no-lock: end.

   assign
      trgl_recno = ?
      sct_recno  = ?
      glxcst     = 0
      gl_amt     = 0
      dr_acct    = ""
      dr_sub     = ""
      dr_cc = ""
      base-price = {1}sod_price / {1}sod_um_conv.

   if so_curr <> base_curr then do:
      /* CONVERT PRICE TO BASE CURRENCY */
      {gprunp.i "mcpl" "p" "mc-curr-conv"
                "(input  so_curr,
                  input  base_curr,
                  input  exch_rate,
                  input  exch_rate2,
                  input  base-price,
                  input  no,   /* DO NOT ROUND */
                  output base-price,
                  output mc-error-number)"}
   end.  /* if so_mstr.so_curr <> base_curr */

   if available pt_mstr then do:
      {gpsct06.i &part=sod_det.sod_part
                 &site=sod_det.sod_site
                 &type=""GL""}
   end.

   assign
      sct_recno = recid(sct_det)
      recno     = sct_recno.

   if consigned_line_item then do:

      if (-1 * trqty) < 0 then do:

         /* SET CONSIGNMENT RETURN STATUS FOR THIS sr_wkfl RECORD */
         consigned_return_material = no.

         for first tt_consign_shipment_detail
            where sales_order    = sod_det.sod_nbr
            and   order_line     = sod_det.sod_line
            and   ship_from_site = site
            and   ship_from_loc  = location
            and   lot_serial     = lotser
            and   reference      = lotrf
         no-lock:
            consigned_return_material =
               tt_consign_shipment_detail.consigned_return_material.
         end.
      end.   /* if (-1 * trqty) < 0 */

      if (-1 * trqty) > 0            /* NORMAL SHIPMENT */
         or consigned_return_material
      then do:

         /* FIND THE CONSIGNMENT AND INTRANSIT LOCATION FROM SALES ORDER */
         {gprunmo.i &program = "socnsod1.p" &module = "ACN"
                    &param   = """(input so_nbr,
                                   input sod_det.sod_line,
                                   output consign_flag,
                                   output consign_loc,
                                   output intrans_loc,
                                   output max_aging_days,
                                   output auto_replenish)"""}

         /* DETERMINE CONSIGNMENT ACCOUNTS FOR THIS sr_wkfl */
         {gprunmo.i &program = "socnacct.p" &module = "ACN"
                    &param   = """(input sod_det.sod_part,
                                   input sod_det.sod_site,
                                   input consigned_to_location,
                                   output consign_inv_acct,
                                   output consign_inv_sub,
                                   output consign_inv_cc,
                                   output consign_intrans_acct,
                                   output consign_intrans_sub,
                                   output consign_intrans_cc,
                                   output consign_offset_acct,
                                   output consign_offset_sub,
                                   output consign_offset_cc)"""}

         /* SET GLOBAL VARIABLES */
         assign
            global_part = sod_det.sod_part
            global_addr = so_cust.

         /* SITE IS ASSIGNED TO SALES ORDER SITE SINCE SHIPMENT  */
         /* TRANSACTION SHOULD CONSIDER THE SALES ORDER SITE AND */
         /* ITEM LOCATION AND NOT THE SITE SPECIFIED AT SHIPMENT */
         if site <> sod_det.sod_site then
            assign
               site     = sod_det.sod_site
               location = if available pt_mstr then pt_loc
                          else location.

         /* PERFORM MATERIAL TRANSFER */
         {gprun.i ""icxfer.p""
                   "(input trlot,
                     input lotser,
                     input lotrf,
                     input lotrf,
                     input -1 * trqty * {1}sod_um_conv,
                     input {1}sod_nbr,
                     input {1}sod_nbr,
                     input l_rmks,
                     input l_project,
                     input eff_date,
                     input site,
                     input location,
                     input sod_det.sod_site,
                     input consigned_to_location,
                     input no,
                     input l_asn_shipper,
                     input eff_date,
                     input l_invmov,
                     input 0,
                     input """",
                     output glcost,
                     output iss_trnbr,
                     output rct_trnbr,
                     input-output assay,
                     input-output grade,
                     input-output expire)"}

         transfer = yes.

         /* CREATE CN-SHIP TRANSACTION */
         /* PASS IN THE RCT_TRNBR TO ICXFER3, TO BE USED FOR REMARKS*/
         l_trnbr = rct_trnbr.
         {gprunmo.i &program = "icxfer3.p" &module = "ACN"
                    &param = """(input trlot,
                                 input lotser,
                                 input lotrf,
                                 input lotrf,
                                 input -1 * trqty * {1}sod_um_conv,
                                 input {1}sod_nbr,
                                 input {1}sod_nbr,
                                 input {1}sod_line,
                                 input l_rmks,
                                 input l_project,
                                 input eff_date,
                                 input site,
                                 input location,
                                 input sod_det.sod_site,
                                 input consigned_to_location,
                                 input no,
                                 input l_asn_shipper,
                                 input eff_date,
                                 input l_invmov,
                                 input (if consigned_to_location = intrans_loc
                                        then
                                           consign_intrans_acct
                                        else
                                           consign_inv_acct),
                                 input (if consigned_to_location = intrans_loc
                                        then
                                           consign_intrans_sub
                                        else
                                           consign_inv_sub),
                                 input (if consigned_to_location = intrans_loc
                                        then
                                           consign_intrans_cc
                                        else
                                           consign_inv_cc),
                                 input consign_offset_acct,
                                 input consign_offset_sub,
                                 input consign_offset_cc,
                                 input so_curr,
                                 input base-price,
                                 input sod_det.sod_qty_ord
                                       - sod_det.sod_qty_ship,
                                 output glcost,
                                 input-output l_trnbr,
                                 input-output assay,
                                 input-output grade,
                                 input-output expire)"""}

         /* CREATE CONSIGNMENT SHIPMENT-INVENTORY X-REF FOR THIS sr_wkfl */

         /* PARAMETER io_first_time get passed in as yes initially       */
         /* to socncix.p. When io_first_time is yes, then socncix.p      */
         /* will create a new cross ref rec.  Once io_first_time is      */
         /* NO, socncix.p will try to reuse the same cross refernce rec  */
         /* if all other key information is the same.                    */

         /* ADDED 20TH PARAMETER TO INDICATE THE REVERSAL OF THE SHIPMENT */
         {gprunmo.i &program = "socncix.p" &module = "ACN"
                    &param = """(input sod_det.sod_nbr,
                                 input sod_det.sod_line,
                                 input sod_det.sod_site,
                                 input so_ship_date,
                                 input (trqty * -1) * sod_det.sod_um_conv,
                                 input sod_det.sod_um,
                                 input l_asn_shipper,
                                 input l_trnbr,
                                 input consigned_to_location,
                                 input lotser,
                                 input lotrf,
                                 input l_auth,
                                 input l_cust_job,
                                 input l_cust_seq,
                                 input l_cust_ref,
                                 input l_dock,
                                 input l_line_feed,
                                 input l_modelyr,
                                 input true,
                                 input no,
                                 input-output io_first_time)"""}

         /* RETRIEVE THE ISS-TR tr_hist TO LATER SAVE THE REC-ID */
         /* AND TO REDUCE THE REQUIRED QTY IN INVENTORY MASTER.  */
         for first tr_hist
            where tr_domain = global_domain
            and   tr_trnbr = iss_trnbr
         no-lock: end.

      end.   /* if (-1 * trqty) > 0 or consigned_return_material */

   end.  /* if consigned_line_item */

   /* LOGIC FOR NON-CONSIGNED LINE, OR RETURN FOR CREDIT ON CONSIGNED LINE */
   if not consigned_line_item
      or (consigned_line_item and (-1 * trqty) < 0
      and not consigned_return_material)
   then do:

      {&MFIVTR-I-TAG7}

      {ictrans.i
         &addrid=so_cust
         &bdnstd=0
         &cracct="if available pt_mstr then
                     if available pld_det then pld_inv_acct
                     else pl_inv_acct
                  else """""
         &crsub="if available pt_mstr then
                    if available pld_det then pld_inv_sub
                    else pl_inv_sub
                 else """""
         &crcc="if available pt_mstr then
                   if available pld_det then pld_inv_cc
                   else pl_inv_cc
                else """""
         &crproj="{1}sod_project"
         &curr=so_curr
         &dracct=dr_acct
         &drsub=dr_sub
         &drcc=dr_cc
         &drproj="{1}sod_project"
         &effdate=eff_date
         &exrate=exch_rate
         &exrate2=exch_rate2
         &exratetype=exch_ratetype
         &exruseq=exch_exru_seq
         &glamt=gl_amt
         &lbrstd=0
         &line="{1}sod_line"
         &location="(if site <> sod_det.sod_site and available pt_mstr
                     then pt_loc else location)"
         &lotnumber=trlot
         &lotserial=lotser
         &lotref=lotrf
         &mtlstd="if sod_det.sod_type = 'M' and not available pt_mstr
                  then sod_det.sod_std_cost else 0"
         &ordernbr="{1}sod_nbr"
         &ovhstd=0
         &part=sod_det.sod_part
         &perfdate="{1}sod_per_date"
         &price=base-price
         &promisedate="{1}sod_promise_date"
         &quantityreq="if new sod_det then
                         ({1}sod_bo_chg + {1}sod_qty_chg) * {1}sod_um_conv
                       else
                          if {1}sod_qty_ord > 0
                          then
                             ({1}sod_qty_ord - {1}sod_qty_ship) * {1}sod_um_conv
                          else 0"
         &quantityshort="{1}sod_bo_chg * {1}sod_um_conv"
         &quantity="trqty * {1}sod_um_conv"
         &revision=""""
         &rmks=""""
         &shiptype="{1}sod_type"
         &site=sod_det.sod_site
         &slspsn1="{1}sod_slspsn[1]"
         &slspsn2="{1}sod_slspsn[2]"
         &slspsn3="tr_slspsn[3] = {1}sod_slspsn[3]"
         &slspsn4="tr_slspsn[4] = {1}sod_slspsn[4]"
         &sojob="if sod_det.sod_fsm_type begins """RMA""" then
                    {1}sod_contr_id
                 else
                    {1}sod_nbr"
         &substd=0
         &transtype=""ISS-SO""
         &msg=0
         &ref_site=tr_site
         &tempid=1
         &trordrev="tr_ord_rev = so_rev"}

      {&MFIVTR-I-TAG11}

      if execname = "sosois.p"
         or execname = "soivmt.p"
         or execname = "fsrmash.p"
      then do:
         for first clc_ctrl
            fields (clc_domain clc_lotlevel)
            where   clc_domain = global_domain
         no-lock:

            if clc_lotlevel = 1 then do:
               for each lotw_wkfl
                  where lotw_domain  = global_domain
                  and   lotw_mfguser = mfguser
                  and   lotw_lotser  = lotser
                  and   lotw_part    = sod_det.sod_part
               exclusive-lock :
                  delete lotw_wkfl.
               end.
            end.

            if clc_lotlevel = 2 then do:
               for each lotw_wkfl
                  where lotw_domain = global_domain
                  and   lotw_mfguser = mfguser
                  and   lotw_lotser  = lotser
               exclusive-lock:
                  delete lotw_wkfl.
               end.
            end.

         end. /* FOR FIRST clc_ctrl */
      end. /* IF execname = ... */

      {&MFIVTR-I-TAG8}

      {gprun.i ""socost01.p""
               "(input trqty * {1}sod_um_conv,
                 input lotser,
                 input prev_found,
                 input sod_entity,
                 input location,
                 input recid(tr_hist) )"}

      assign
         prev_found = yes
         recno      = sct_recno.

   if available pt_mstr
      and sod_det.sod_prodline <> pt_prod_line
   then
      if sod_det.sod_fsm_type = ""
         and sod_det.sod_rma_type = ""
      then do for soddet:
         find soddet
            where soddet.sod_domain = global_domain
            and   soddet.sod_nbr    = sod_det.sod_nbr
            and   soddet.sod_line   = sod_det.sod_line
         exclusive-lock no-error.
         if available soddet then
            soddet.sod_prodline = pt_prod_line.
      end.

      assign
         tr_prod_line = sod_det.sod_prodline
         tr_fsm_type  = sod_det.sod_fsm_type
         tr_ship_date = so_ship_date.

      /* SS - 20080812.1 - B */
      /*
      - Bill To[so_bill]:Driver,保存于"tr_ship_inv_mov" "tr_user1" 
      - Ship-To[so_ship]:Truck,保存于"tr_ship_id"       "tr_user2"
      - DN No.[shp-id]:保存于"tr_so_job"
      */
      ASSIGN
         tr_user1 = v_bill
         tr_user2 = v_ship
         tr_so_job = v_dn 
         tr__dec01 = trqty
         tr__chr01 = sod_um
         .
      /* SS - 20080812.1 - E */

      if site <> sod_det.sod_site then
         assign
            tr_assay  = assay
            tr_grade  = grade
            tr_expire = expire.

      {gprun.i ""socost02.p""
               "(input trqty * {1}sod_um_conv,
                 input sod_entity,
                 input recid(trgl_det),
                 input recid(tr_hist))"}

   /* CREATE CONSIGNMENT USAGE RECORDS IF CONSIGNMENT ENABLED*/
   /* AND CONSIGNMENT INVENTORY EXISTS.                      */
   if using_supplier_consignment then do:

         /* STD TRANSACTION QTY IS PROCESSED AS -trqty SO IT IS TREATED */
         /* AS A POSITIVE QTY IN ictrancn.p, IMPLYING trqty IS NEGATIVE */
         /* TO START WITH.  THEREFORE, IF trqty > 0, IT IS A REVERSAL.  */
         {gprunmo.i &program = ""pocnsix4.p"" &module = "ACN"
                    &param   =  """(input sod_det.sod_part,
                                    input sod_det.sod_site,
                                    input right-trim(substring(lotser,1,18)),
                                    input lotrf,
                                    input (if trqty > 0 then true else false),
                                    output consign_flag)"""}

         /*IF CONSIGNED INVENTORY EXISTS, DETERMINE WHETHER TO */
         /*USE IT PRIOR TO UNCONSIGNED INVENTORY.              */
         if consign_flag and not transfer then do:
            {gprunmo.i &program = ""ictrancn.p"" &module = "ACN"
                       &param   =  """(input sod_det.sod_nbr,
                                       input '',
                                       input 0,
                                       input tr_so_job,
                                       input - trqty * {1}sod_um_conv,
                                       input lotser,
                                       input sod_det.sod_part,
                                       input sod_det.sod_site,
                                       input location,
                                       input lotrf,
                                       input eff_date,
                                       input tr_trnbr,
                                       input is_wo_issue,
                                       input-output io_batch)"""}
         end. /*If consign_flag*/
      end. /*IF USING_SUPPLIER_CONSIGNMENT*/

   end. /* if not consigned_line_item */

   tr_recno = recid(tr_hist).

   /* DO NOT UPDATE IN_QTY_REQ FOR RMA RECEIPT LINES */
   if {1}sod_type = ""
      and not {1}sod_sched
      and ({1}sod_fsm_type <> "RMA-RCT")
   then do:
      if not site_change then do:
         find in_mstr
            where in_domain = global_domain
            and   in_part = {1}sod_part
            and   in_site = {1}sod_site
         exclusive-lock no-error.

         if available in_mstr then do:
            if {2} = "update in_qty_req" then do:
               if pend_inv then
                  assign
                     in_qty_req = in_qty_req + tr_qty_loc.
               else do: /* not pend_inv */
                  /* Update Qty Required on in_mstr.  Note: tr_qty_loc is */
                  /* negative on shipments, positive on cr order returns. */
                  /* sod_qty_ship hasn't been updated w/new shipment yet. */
                  if {1}sod_qty_ord >= 0 then      /* Order Shipment */
                     in_qty_req = in_qty_req
                                - max(({1}sod_qty_ord * {1}sod_um_conv
                                - {1}sod_qty_ship * {1}sod_um_conv),0)
                                + max({1}sod_qty_ord * {1}sod_um_conv
                                - ({1}sod_qty_ship * {1}sod_um_conv
                                - tr_qty_loc),0).

                  if {1}sod_qty_ord < 0 then       /* Cr Order Return */
                     in_qty_req = in_qty_req
                                - min(({1}sod_qty_ord * {1}sod_um_conv
                                - {1}sod_qty_ship * {1}sod_um_conv),0)
                                + min({1}sod_qty_ord * {1}sod_um_conv
                                - ({1}sod_qty_ship * {1}sod_um_conv
                                - tr_qty_loc),0).

                  sod_det.sod_qty_ship = sod_det.sod_qty_ship
                                       - tr_qty_loc / sod_det.sod_um_conv.

               end.   /* not pend invoice */
            end. /* {2} = update in_qty_req */
         end.   /* avail in_mstr */
      end.   /* not site_change */
   end.   /* sod_type = "" */

   qty_left = qty_left - trqty.

end.
