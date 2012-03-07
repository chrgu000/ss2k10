/* poporp11.p - UNVOUCHERED PO RECEIPT AS OF DATE REPORT                      */
/* Copyright 1986-2007 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* Revision: 1.5        BY: Patrick de Jong       DATE: 04/16/02  ECO: *N1B4* */
/* Revision: 1.5        BY: Patrick de Jong       DATE: 04/31/02  ECO: *P07H* */
/* Revision: 1.6        BY: Patrick Rowan         DATE: 06/18/02  ECO: *P090* */
/* Revision: 1.8        BY: Ellen Borden          DATE: 08/25/02  ECO: *P0DB* */
/* Revision: 1.9        BY: Ellen Borden          DATE: 08/25/02  ECO: *P0HV* */
/* Revision: 1.10       BY: K Paneesh             DATE: 04/15/03  ECO: *P0PZ* */
/* Revision: 1.12       BY: Paul Donnelly (SB)    DATE: 06/28/03  ECO: *Q00J* */
/* Revision: 1.13       BY: Bhagyashri Shinde     DATE: 12/03/04  ECO: *P2Y1* */
/* Revision: 1.14       BY: Robin McCarthy        DATE: 01/05/05  ECO: *P2P6* */
/* Revision: 1.15       BY: Robin McCarthy        DATE: 02/22/05  ECO: *P2XY* */
/* Revision: 1.18       BY: Vandna Rohira         DATE: 03/03/05  ECO: *P2XP* */
/* Revision: 1.19       BY: Vandna Rohira         DATE: 03/17/05  ECO: *P3CM* */
/* Revision: 1.20       BY: Binoy John            DATE: 04/18/05  ECO: *P3GK* */
/* Revision: 1.21       BY: Shivganesh Hegde      DATE: 04/27/05  ECO: *P3J9* */
/* Revision: 1.22       BY: Swati Sharma          DATE: 05/18/05  ECO: *P3LQ* */
/* Revision: 1.23       BY: Anil Sudhakaran       DATE: 08/11/05  ECO: *P2PJ* */
/* Revision: 1.23.1.1   BY: Shivaraman V.         DATE: 09/02/05  ECO: *P40J* */
/* Revision: 1.23.1.4   BY: Nishit V              DATE: 11/15/05  ECO: *Q0MK* */
/* Revision: 1.23.1.5   BY: Geeta Kotian          DATE: 12/29/05  ECO: *P4DW* */
/* Revision: 1.23.1.10  BY: Steve Nugent          DATE: 04/03/06  ECO: *P4JR* */
/* Revision: 1.23.1.11  BY: Shridhar M            DATE: 04/26/06  ECO: *Q0TN* */
/* Revision: 1.23.1.12  BY: Rohan Barsainya       DATE: 10/05/06  ECO: *P59G* */
/* Revision: 1.23.1.13  BY: Abhijit Gupta         DATE: 01/29/07  ECO: *P5MQ* */
/* $Revision: 1.23.1.14 $         BY: Dilip Manawat         DATE: 03/29/07  ECO: *P5S5* */
/*-Revision end---------------------------------------------------------------*/
/* ss - 110803.1 by: jack */ /* ÐÞ¸Ä¼ÆËãÂß¼­ */
/* ss - 110804.1 by: jack */  /* ÐÞ¸ÄÔÝ¹Àµ¥¼Û*/
/*V8:ConvertMode=Report                                                       */

{xxmfdtitle.i "1+ "}
{cxcustom.i "POPORP11.P"}

define INPUT PARAMETER i_vendor     like po_vend no-undo.
define INPUT PARAMETER i_vendor1    like po_vend no-undo.
define INPUT PARAMETER  i_part       like pt_part no-undo.
define INPUT PARAMETER i_part1      like pt_part no-undo.
define INPUT PARAMETER i_site       like pt_site no-undo.
define INPUT PARAMETER i_site1      like pt_site no-undo.
define INPUT PARAMETER i_acc        like ap_acct no-undo.
define INPUT PARAMETER i_acc1       like ap_acct no-undo.
define INPUT PARAMETER i_sub        like ap_sub no-undo.
define INPUT PARAMETER i_sub1       like ap_sub no-undo.
define INPUT PARAMETER i_cc         like ap_cc no-undo.
define INPUT PARAMETER i_cc1        like ap_cc no-undo.
define INPUT PARAMETER i_effdate    like prh_rcp_date format "99/99/99" no-undo.
define INPUT PARAMETER i_rcpt_from  like prh_rcp_date format "99/99/99" no-undo.
define INPUT PARAMETER i_sel_inv    like mfc_logical  initial yes no-undo.
define INPUT PARAMETER i_sel_sub    like mfc_logical  initial yes no-undo.
define INPUT PARAMETER i_sel_mem    like mfc_logical  initial yes no-undo.
define INPUT PARAMETER i_excl_unconfirmed like mfc_logical initial yes no-undo.
define INPUT PARAMETER i_use_tot    like mfc_logical  initial no no-undo.
define INPUT PARAMETER i_base_rpt   like po_curr no-undo.
define INPUT PARAMETER i_l-summary  like mfc_logical no-undo.
define INPUT PARAMETER i_buyer   AS CHAR.
define INPUT PARAMETER i_buyer1 AS CHAR .

define var vendor     like po_vend no-undo.
define var vendor1    like po_vend no-undo.
define var  part       like pt_part no-undo.
define var part1      like pt_part no-undo.
define var site       like pt_site no-undo.
define var site1      like pt_site no-undo.
define var acc        like ap_acct no-undo.
define var acc1       like ap_acct no-undo.
define var sub        like ap_sub no-undo.
define var sub1       like ap_sub no-undo.
define var cc         like ap_cc no-undo.
define var cc1        like ap_cc no-undo.
define var effdate    like prh_rcp_date format "99/99/99" no-undo.
define var rcpt_from  like prh_rcp_date format "99/99/99" no-undo.
define var sel_inv    like mfc_logical  initial yes no-undo.
define var sel_sub    like mfc_logical  initial yes no-undo.
define var sel_mem    like mfc_logical  initial yes no-undo.
define var excl_unconfirmed like mfc_logical initial yes no-undo.
define var use_tot    like mfc_logical  initial no no-undo.
define var base_rpt   like po_curr no-undo.
define var l-summary  like mfc_logical no-undo.
define VAR buyer   AS CHAR.
define VAR buyer1 AS CHAR .



define variable rndmthd    like rnd_rnd_mthd no-undo.
define variable oldcurr    like prh_curr no-undo.
define variable std_ext    as decimal format "->>>>>>>>>>9.99<<<" no-undo.
define variable pur_ext    as decimal format "->>>>>>>>>>9.99<<<" no-undo.
define variable tax_accrued as decimal format "->>>>>>>>>>9.99<<<" no-undo.
define variable openTaxAmount like tx2d_totamt no-undo.
define variable invoiceTaxAmount like tx2d_totamt no-undo.
define variable rep_tot_with_tax as decimal format "->>>>>>>>>>9.99<<<" no-undo.
define variable std_cost   as decimal format "->>>>>>>9.99<<<" no-undo.
define variable std_var    as decimal format "->>>>>>>9.99<<<" no-undo.
define variable base_cost  as decimal format "->>>>>>>>9.99<<<" no-undo.
define variable disp_curr  as character format "X(1)" no-undo.
define variable descname   as character format "x(50)" no-undo.
define variable qty_open   as decimal   format "->>>>>>9.9<<<<<<"  no-undo.
define variable exdrate    like ap_ex_rate no-undo.
define variable last_nbr   like prh_nbr no-undo.
define variable last_vend  like prh_vend no-undo.
define variable base_std_cost as decimal no-undo.
define variable rcptacct   like ap_acct no-undo.
define variable rcptsub    like ap_sub no-undo.
define variable rcptcc     like ap_cc no-undo.
define variable rcptxacct  like ap_acct no-undo.
define variable rcptxsub   like ap_sub no-undo.
define variable rcptxcc    like ap_cc no-undo.
define variable receiptacc like ap_acct no-undo.
define variable receiptsub like ap_sub no-undo.
define variable receiptcc  like ap_cc no-undo.
define variable qty_vph    like qty_open no-undo.
define variable vendor_type like vd_type no-undo.
define variable mc-error-number  like msg_nbr no-undo.
define variable l_pvod_eff_date as date no-undo.
define variable l_pvod_trans_qty as decimal no-undo.

define variable l_sitedb   like si_db   no-undo.
define variable l_old_db   like si_db   no-undo.
define variable err-flag   as   integer no-undo.

define temp-table tt_summary no-undo
   field tt_acc     like ap_acct
   field tt_sub     like ap_sub
   field tt_cc      like ap_cc
   field tt_pur_ext as decimal format "->>,>>>,>>>,>>9.99" initial 0
   index tt_acc_cc is primary
   tt_acc
   tt_sub
   tt_cc.

DEFINE  SHARED TEMP-TABLE tt  /* */
    FIELD tt_vend LIKE po_vend
    FIELD tt_name LIKE ad_name
    FIELD tt_nbr LIKE vo_invoice
    FIELD tt_date AS DATE
    FIELD tt_user AS CHAR
    FIELD tt_part LIKE pt_part
    FIELD tt_desc1 LIKE pt_desc1
    FIELD tt_qty LIKE pod_qty_ord
    FIELD tt_cost LIKE prh_pur_cost
    FIELD tt_amt LIKE ap_amt
    FIELD tt_type AS CHAR /* 1 Èë¿â 2 Ó¦¸¶ 3 Ô¤¸¶*/
    .

{apconsdf.i}
{popvodet.i}   /* pvod_det TEMP-TABLE DEFINITION */

define variable totalTransQty as decimal no-undo.
define variable totalTaxAccrued as decimal no-undo.
define variable pvod-trx-cost like prh_pur_cost no-undo.
define buffer b_tt_pvod_det for tt_pvoddet.

for first gl_ctrl where gl_domain = global_domain no-lock: end.

  

/* SELECT FORM */
form
   vendor           colon 15
   vendor1          label "To" colon 49 skip
   part             colon 15
   part1            label "To" colon 49 skip
   site             colon 15
   site1            label "To" colon 49
   acc              colon 15
   acc1             label "To" colon 49 skip
   sub              colon 15
   sub1             label "To" colon 49 skip
   cc               label "Cost Center" colon 15
   cc1              label "To"                             colon 49 skip
   effdate          label "Effective Date"                 colon 31
   rcpt_from        label "Show Purchase Receipts From"    colon 31
   sel_inv          label "Inventory Items"                colon 31
   sel_sub          label "Subcontracted Items"            colon 31
   sel_mem          label "Memo Items"                     colon 31
   excl_unconfirmed label "Unconfirmed Vouchered Receipts" colon 31
   use_tot          label "Use Total Std Cost"             colon 31
   base_rpt         colon 31
   l-summary        label "Summary" colon 31
with frame a side-labels width 80.

setFrameLabels(frame a:handle).

{wbrp01.i &io-frame = "a"}

/* /* REPORT BLOCK */ */
/* repeat:            */

    ASSIGN

    vendor    = i_vendor
    vendor1   = i_vendor1
    part   = i_part
    part1   = i_part1
   site   = i_site
   site1  = i_site1
   acc    = i_acc
   acc1   = i_acc1
   sub   = i_sub
   sub1  = i_sub1
   cc    = i_cc
   cc1   = i_cc1
   effdate = i_effdate
   rcpt_from  = i_rcpt_from
   sel_inv    = i_sel_inv
   sel_sub   = i_sel_sub
   sel_mem   = i_sel_mem
   excl_unconfirmed = i_excl_unconfirmed
   use_tot    = i_use_tot
   base_rpt   = i_base_rpt
   l-summary     = i_l-summary
   buyer = i_buyer
   buyer1 = i_buyer1
    .


   if vendor1    = hi_char then vendor1 = "".
   if part1      = hi_char then part1 = "".
   if site1      = hi_char then site1 = "".
   if acc1       = hi_char then acc1 = "".
   if sub1       = hi_char then sub1 = "".
   if cc1        = hi_char then cc1 = "".
   if rcpt_from  = low_date then rcpt_from = ?.
   if effdate    = ? then effdate = today.

 
   /* CREATE BATCH INPUT STRING */
   bcdparm = "".
   run ip-quoter.

   if vendor1   = "" then vendor1   = hi_char.
   if part1     = "" then part1     = hi_char.
   if site1     = "" then site1     = hi_char.
   if acc1      = "" then acc1      = hi_char.
   if sub1      = "" then sub1      = hi_char.
   if cc1       = "" then cc1       = hi_char.
   if rcpt_from = ?  then rcpt_from = low_date.
   if effdate   = ?  then effdate   = today.

   

   for each tt_summary exclusive-lock:
      delete tt_summary.
   end.

   assign
      oldcurr = ""
      last_nbr = ""
      last_vend = "".

   do on endkey undo, leave:

      /* Process all receipts in the specified range */
      for each prh_hist no-lock
         where prh_domain = global_domain
         and ((prh_vend >= vendor and prh_vend <= vendor1)
         and (prh_part >= part and prh_part <= part1)
         and ((prh_rcp_date >= rcpt_from)
         or  (prh_rcp_date = ? and rcpt_from = low_date))
         and (prh_site >= site and prh_site <= site1)
         and ((prh_type = "" and sel_inv = yes)
         or  (prh_type = "S" and sel_sub = yes)
         or  (prh_type <> "" and prh_type <> "S" and sel_mem = yes))
         and (base_rpt = "" or base_rpt = prh_curr))
      use-index prh_vend  ,
          FIRST po_mstr WHERE po_domain = prh_domain AND po_nbr = prh_nbr 
          AND (po_user_id >= buyer AND po_user_id <= buyer1) NO-LOCK by prh_vend by prh_nbr :
      

         /* INITIALIZE VARIABLES */
         assign
           qty_open = 0
           qty_vph  = 0
           invoiceTaxAmount = 0
           openTaxAmount = 0
           totalTransQty = 0.

         /* Set open quantity to the sum of the                            */
         /* transaction qty on the pending voucher records for the receiver*/
         /* This is being done because for supplier consignment a pending  */
         /* a pending voucher doesn't get created until a usage occurs against*/
         /* the consigned inventory that was received.                     */

         for each tt_pvoddet exclusive-lock where
                  tt_pvoddet.pvod_domain = global_domain:
            delete tt_pvoddet.
         end.
         /* Process all vouchers which are linked to the receiver
          * before the as of date */
         for each pvo_mstr
            where pvo_domain            = global_domain
            and   pvo_order_type        = {&TYPE_PO}
            and   pvo_order             = prh_nbr
            and   pvo_internal_ref_type = {&TYPE_POReceiver}
            and   pvo_internal_ref      = prh_receiver
            and   pvo_line              = prh_line
            and   pvo_eff_date         <= effdate
            and   pvo_lc_charge         = ""
         no-lock:

            if pvo_consignment
            then do:

               for first pod_det
                  fields (pod_domain pod_line pod_nbr pod_site)
                  where pod_det.pod_domain = global_domain
                  and   pod_nbr            = pvo_order
                  and   pod_line           = pvo_line
               no-lock:

               end. /* FOR FIRST pod_det */

               if available pod_det
               then
                  for first si_mstr
                     fields (si_domain si_db si_site)
                     where si_mstr.si_domain = global_domain
                     and   si_site           = pod_site
                  no-lock:

                  end. /* FOR FIRST si_mstr */

               if available si_mstr
                  and si_db = global_db
               then do:

                   for each cnsu_mstr no-lock
                      where cnsu_domain     = prh_domain
                      and   cnsu_po_nbr     = prh_nbr
                      and   cnsu_pod_line   = prh_line
                      and   cnsu_part       = prh_part
                      and   cnsu_site       = prh_site
                      and   cnsu_eff_date  <= effdate
                      use-index cnsu_order,
                      each cnsud_det no-lock
                         where cnsud_domain    = cnsu_domain
                         and   cnsud_cnsu_pkey = cnsu_pkey
                         and   cnsud_receiver  = prh_receiver
                      break by cnsu_po_nbr
                            by cnsu_pod_line
                            by cnsud_receiver
                            by cnsu_part:

                      accumulate cnsud_qty_used (total by cnsu_part).
                      qty_open = (accum total cnsud_qty_used).

                   end. /* FOR EACH cnsu_mstr */

               end. /* IF si_db = global_db */

               else do:

                  l_old_db = global_db.

                  {gprun.i ""gpmdas.p"" "(si_db, output err-flag)" }

                  if err-flag <> 0
                  then do:

                  /* DOMAIN # IS NOT AVAILABLE */
                  {pxmsg.i &MSGNUM=6137 &ERRORLEVEL=4 &MSGARG1=si_db}
                   undo, leave.

                  end. /* IF err-flag <> 0 */

                  {gprun.i ""poporp12.p""
                           "(input prh_nbr,
                             input prh_line,
                             input prh_part,
                             input prh_site,
                             input effdate,
                             input prh_receiver,
                             output qty_open)"}

                  if l_old_db <> global_db
                  then do:

                     /* SWITCH BACK TO THE ORIGINAL DOMAIN  */
                     {gprun.i ""gpmdas.p""
                              "(input  l_old_db,
                                output err-flag)"}

                     if err-flag <> 0
                     then do:

                        /* DOMAIN # IS NOT AVAILABLE */
                        {pxmsg.i &MSGNUM=6137 &ERRORLEVEL=4 &MSGARG1=si_db}
                        undo , leave.

                     end. /* IF err-flag <> 0 */

                  end.  /* IF l_old_db <> global_db */

               end. /* ELSE DO */

               qty_open = qty_open / prh_um_conv.

            end. /* IF pvo_consignment */

            else

               /* SET OPEN QTY  */
               qty_open = qty_open + pvo_trans_qty.

            for each pvod_det no-lock where
                     pvod_domain = global_domain
                 and pvod_id = pvo_id:

               {gpextget.i &OWNER     = 'ADG'
                           &TABLENAME = 'pvod_det'
                           &REFERENCE = '10074a'
                           &KEY1      = pvod_domain
                           &KEY2      = string(pvod_id)
                           &KEY3      = string(pvod_id_line)
                           &DEC1      = l_pvod_trans_qty
                           &DATE2     = l_pvod_eff_date}

               if l_pvod_eff_date > effdate then next.
               qty_vph = 0.

               if     pvo_vouchered_qty <> 0
                  and not can-find(vph_hist
                                      where vph_domain       = global_domain
                                      and   vph_pvo_id       = pvod_id
                                      and   vph_pvod_id_line = pvod_id_line)
               then
                  qty_vph = pvo_vouchered_qty.

               for each vph_hist where
                        vph_domain       = global_domain and
                        vph_pvo_id       = pvod_id       and
                        vph_pvod_id_line = pvod_id_line  and
                        vph_inv_date    <= effdate
               no-lock:

                  /* Skip the unconfirmed vouchers */
                  if excl_unconfirmed then do:
                     for first vo_mstr no-lock where
                               vo_domain = global_domain
                           and vo_ref = vph_ref:
                     end.
                     if available vo_mstr and vo_confirmed = false then
                     next.
                  end.

                  /* Determine vouchered taxes by getting tax type 22 records*/
                  /* corresponding to the vph_hist records                   */
                  for each tx2d_det
                     where tx2d_domain = global_domain
                     and   tx2d_ref = vph_ref
                     and   tx2d_nbr = prh_receiver
                     and   tx2d_line = prh_line
                     and   tx2d_tr_type = "22"
                     and not tx2d_tax_in
                     and   tx2d_rcpt_tax_point = yes
                  no-lock:
                     invoiceTaxAmount = invoiceTaxAmount + tx2d_cur_tax_amt.
                  end.

                  /* SET VOUCHERED QUANTITY */
                  qty_vph = qty_vph + vph_inv_qty.

                  /* If this voucher closes the receipt recalculate
                   * vouchered quantity to account for closing the line
                   * when not all items are vouchered
                   * Voucher quantity = receipt quantity -
                   *                    invoice quantity of other vouchers */

                  if pvo_last_voucher = vph_ref
                  then
                     qty_vph = qty_vph + (pvo_trans_qty - pvo_vouchered_qty).

               end. /* for each vph_hist*/

               buffer-copy pvod_det to b_tt_pvod_det.

               b_tt_pvod_det.pvoddet_trans_qty = l_pvod_trans_qty.

               /* GET EXTENDED TABLE RECORDS */
               /* THIS CODE CAN BE REMOVED ONCE THE FIELDS ARE ADDED IN eB3*/
               {poporpcn.i}

               if b_tt_pvod_det.pvoddet_trans_qty - qty_vph = 0
               then do:
                  delete b_tt_pvod_det.
                  next.
               end. /* IF b_tt_pvod_det.pvoddet_trans_qty - qty_vph = 0 */

               assign
                  b_tt_pvod_det.pvoddet_id = pvod_det.pvod_id
                  b_tt_pvod_det.pvoddet_id_line = pvod_det.pvod_id_line
                  b_tt_pvod_det.pvoddet_open_qty =
                       b_tt_pvod_det.pvoddet_trans_qty - qty_vph
                  totalTransQty = totalTransQty
                                + b_tt_pvod_det.pvoddet_trans_qty
                                - qty_vph.
            end. /* FOR EACH pvod_det */
         end. /* for each pvo_mstr */

         qty_open = (qty_open / prh_um_conv) - (qty_vph / prh_um_conv).

         /* SHOULD NOT DISPLAY THE RECEIPT WHOSE QTY OPEN IS ZERO    */
         if qty_open = 0
         then
            next.


         run getSupplierDefaults.
         run getReceiptAccounts.

         if not(receiptacc >= acc and receiptacc <= acc1
            and receiptsub >= sub and receiptsub <= sub1
            and receiptcc >= cc   and receiptcc  <= cc1)
         then
            next.

         /* Determine rounding method */
         if (oldcurr <> prh_curr) or (oldcurr = "") then do:

            if prh_curr = gl_base_curr then
               rndmthd = gl_rnd_mthd.
            else do:
               /* GET ROUNDING METHOD FROM CURRENCY MASTER */
               {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                         "(input prh_curr,
                           output rndmthd,
                           output mc-error-number)"}
               if mc-error-number <> 0 then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4}
                  leave.
               end.
            end.

            oldcurr = prh_curr.

         end.

         /*GET THE TAX AMOUNT IN PENDING VOUCHER CURRENCY*/
         for each tx2d_det
            where tx2d_domain   = global_domain
            and   tx2d_ref      = prh_receiver
            and   tx2d_nbr      = prh_nbr
            and   tx2d_line     = prh_line
            and   (tx2d_tr_type = "21"
            or    (tx2d_tr_type = "25"
            and   prh_rcp_type  = "R"))
            and not tx2d_tax_in
            and   tx2d_rcpt_tax_point = yes
         no-lock:
            openTaxAmount = openTaxAmount + tx2d_cur_tax_amt.
         end.

         /* Display header */
         do with frame bhead:

        

            

            assign
               last_nbr = prh_nbr
               last_vend = prh_vend.

           

         end.  /* do with frame bhead */

         /* CALCULATE THE ACCRUED TAX */
         totalTaxAccrued = openTaxAmount - invoiceTaxAmount.

         for each tt_pvoddet where
            tt_pvoddet.pvod_domain = global_domain and
            tt_pvoddet.pvoddet_open_qty <> 0
         no-lock:

            /* Calculate standard cost */
            std_cost = pvoddet_pur_std.

         if prh_type = "" then

               std_cost = pvoddet_pur_std - pvoddet_ovh_std.
            if use_tot = yes or prh_type = "S"  then
               std_cost = pvoddet_pur_std.

         base_std_cost = std_cost.

         if base_rpt <> "" and prh_curr <> base_curr then do:
            {gprunp.i "mcpl" "p" "mc-curr-conv"
                      "(input base_curr,
                        input prh_curr,
                        input pvoddet_ex_rate2,
                        input pvoddet_ex_rate,
                        input std_cost,
                        input false, /* DO NOT ROUND */
                        output std_cost,
                        output mc-error-number)"}
         end.
            /* CONVERT pvod_pur_cost TO TRANSACTION CURR */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
                      "(input  base_curr,
                        input  prh_curr,
                        input  pvoddet_ex_rate2,
                        input  pvoddet_ex_rate,
                        input  pvoddet_pur_cost,
                        input  false,
                        output pvod-trx-cost,
                        output mc-error-number)"}

            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end.

         assign
            base_cost = pvod-trx-cost
            disp_curr = "".

         if base_rpt = "" and prh_curr <> base_curr then
            assign
               base_cost = pvoddet_pur_cost
               disp_curr = "Y".

         /* Calculate extended GL cost */
         assign
            qty_open = pvoddet_open_qty * prh_um_conv
            std_ext = base_std_cost * qty_open.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
                   "(input-output std_ext,
                     input gl_rnd_mthd,
                     output mc-error-number)"}

         if base_rpt <> "" and prh_curr <> base_curr then do:
            {gprunp.i "mcpl" "p" "mc-curr-conv"
                      "(input base_curr,
                        input prh_curr,
                        input pvoddet_ex_rate2,
                        input pvoddet_ex_rate,
                        input std_ext,
                        input true, /* DO ROUND */
                        output std_ext,
                        output mc-error-number)"}

            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end.
         end.

         /* Calculate extended PO cost */
         pur_ext = pvod-trx-cost * qty_open.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
                   "(input-output pur_ext,
                     input rndmthd,
                     output mc-error-number)"}

         if base_rpt = "" and prh_curr <> base_curr then do:
            {gprunp.i "mcpl" "p" "mc-curr-conv"
                      "(input prh_curr,
                        input base_curr,
                        input pvoddet_ex_rate,
                        input pvoddet_ex_rate2,
                        input pur_ext,
                        input true, /* DO ROUND */
                        output pur_ext,
                        output mc-error-number)"}

            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end.
         end.

         /* Calculate the accrued tax */
         tax_accrued = totalTaxAccrued * qty_open / totalTransQty.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
                   "(input-output tax_accrued,
                     input rndmthd,
                     output mc-error-number)"}

         if base_rpt = "" and prh_curr <> base_curr then do:
            {gprunp.i "mcpl" "p" "mc-curr-conv"
                      "(input prh_curr,
                        input base_curr,
                        input pvoddet_ex_rate,
                        input pvoddet_ex_rate2,
                        input tax_accrued,
                        input true, /* DO ROUND */
                        output tax_accrued,
                        output mc-error-number)"}

            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end.
         end.

         /* Calculate PO-GL variance */
         std_var = pur_ext - std_ext.

         if prh_type <> "" and prh_type <> "S" then
            assign
               std_cost = 0
               std_ext  = 0
               std_var  = 0.

         accumulate std_ext (total).
         accumulate pur_ext (total).
         accumulate std_var (total).
         accumulate tax_accrued (total).

         /* Display receiver details */
/*          if not l-summary then do with frame b:                          */
/*                                                                          */
/*             setFrameLabels(frame b:handle).                              */
/*                                                                          */
/*             display                                                      */
/*                prh_receiver       format "x(12)"                         */
/*                prh_line           column-label "Pur"                     */
/*                prh_part                                                  */
/*                prh_rcp_date       column-label "Rcpt Dt"                 */
/*                qty_open           column-label "Qty Open"                */
/*                                   format "->>>>>>9.9<<<<<<"              */
/*                prh_rcp_type                                              */
/*                std_cost           when (base_rpt <> "")                  */
/*                                   column-label "GL Cost"                 */
/*                base_std_cost      when (base_rpt = "" ) @ std_cost       */
/*                                   column-label "GL Cost"                 */
/*                disp_curr          column-label "C"                       */
/*                base_cost          column-label "Purchase Cost"           */
/*                std_ext            column-label "Ext GL Cost"             */
/*                pur_ext            column-label "Ext PO Cost!Accrued Tax" */
/*                std_var            column-label "PO-GL Var"               */
/*             with frame b.                                                */
/*                                                                          */
/*             down 1 with frame b.                                         */
/*                                                                          */
/*             display                                                      */
/*                tax_accrued         @ pur_ext                             */
/*             with frame b.                                                */
/*             down 1 with frame b.                                         */
/*          end.                                                            */


         IF NOT l-summary THEN DO:

             /* ss - 110803.1 -b
                           FIND FIRST tt WHERE tt_type = "1" AND tt_vend = prh_vend AND tt_nbr = prh_nbr AND tt_date = prh_per_date
                       AND tt_part = prh_part  NO-ERROR .
                   IF NOT AVAILABLE tt THEN DO:
            
                    FIND    FIRST ad_mstr WHERE ad_domain = po_domain AND ad_addr = prh_vend NO-LOCK NO-ERROR .
                    FIND  FIRST pt_mstr WHERE pt_domain = po_domain AND pt_part = prh_part NO-LOCK NO-ERROR .
            
                       CREATE tt .
                       ASSIGN
                           tt_date = prh_per_date
                           tt_vend = prh_vend
                           tt_name = IF AVAILABLE ad_mstr THEN ad_name ELSE ""
                           tt_nbr = prh_nbr
                           tt_user = po_user_id
                           tt_part = prh_part
                           tt_desc1 = IF AVAILABLE pt_mstr THEN  pt_desc1 ELSE ""
                           tt_qty = qty_open
                           tt_cost = std_cost
                           tt_amt = std_ext
                           tt_type = "1"
                           .
                   END.
                   ELSE DO:
                       ASSIGN
            
                           tt_qty = tt_qty + qty_open
                           /* ss - 110803.1 -b 
                           tt_amt =  tt_amt + tt_qty * tt_cost
                           ss - 110803.1 -e */
                           /* ss - 110803.1 -b */
                           tt_amt = tt_qty * tt_cost 
                           /* ss - 110803.1 -e */
                           .
            
                   END.
                   ss - 110803.1 -e */

             /* ss - 110803.1 -b */
           
              FIND    FIRST ad_mstr WHERE ad_domain = po_domain AND ad_addr = prh_vend NO-LOCK NO-ERROR .
                    FIND  FIRST pt_mstr WHERE pt_domain = po_domain AND pt_part = prh_part NO-LOCK NO-ERROR .
            
                       CREATE tt .
                       ASSIGN
                           tt_date = prh_per_date
                           tt_vend = prh_vend
                           tt_name = IF AVAILABLE ad_mstr THEN ad_name ELSE ""
                           tt_nbr = prh_nbr
                           tt_user = po_user_id
                           tt_part = prh_part
                           tt_desc1 = IF AVAILABLE pt_mstr THEN  pt_desc1 ELSE ""
                           tt_qty = qty_open
                          /* ss - 110804.1 -b 
                           tt_cost = std_cost
                           tt_amt = pur_ext
                           ss - 110804.1 -e */
                           tt_type = "1"
                           .

                 FIND FIRST  pvo_mstr
            where pvo_domain            = global_domain
            and   pvo_order_type        = {&TYPE_PO}
            and   pvo_order             = prh_nbr
            and   pvo_internal_ref_type = {&TYPE_POReceiver}
            and   pvo_internal_ref      = prh_receiver
            and   pvo_line              = prh_line
            and   pvo_eff_date         <= effdate
            and   pvo_lc_charge         = "" NO-LOCK NO-ERROR .
            IF AVAILABLE pvo_mstr THEN DO:

                IF pvo_tax_in = YES AND pvo_taxable = YES  THEN DO:
                    FIND LAST tx2_mstr WHERE tx2_domain = prh_domain AND tx2_tax_type = "tax"
                        AND tx2_pt_taxc = prh_taxc AND tx2_tax_usage = prh_tax_usage NO-LOCK NO-ERROR .
                    IF AVAILABLE tx2_mstr THEN DO:
                        tt_cost = base_cost / ( 1 + tx2_tax_pct / 100 ).
                    END.
                    ELSE 
                        tt_cost = base_cost .
                END.
                ELSE
                    tt_cost = base_cost .
            END.
            ELSE
                    tt_cost = base_cost .
                

                    tt_amt = tt_cost * tt_qty .


             /* ss - 110803.1 -e */

         END.

         /* Update totals */
         for first tt_summary
            where tt_acc = receiptacc and
                  tt_sub = receiptsub and
                  tt_cc  = receiptcc
         exclusive-lock: end.

         if not available tt_summary then do:
            create tt_summary.
            assign
               tt_acc = receiptacc
               tt_sub = receiptsub
               tt_cc  = receiptcc.
         end.

         assign tt_pur_ext = tt_pur_ext + pur_ext + tax_accrued.

         end. /* FOR EACH tt_pvoddet... */
      end.

     

      rep_tot_with_tax = (accum total pur_ext) + (accum total tax_accrued).

/*       /* Display summary */                                                     */
/*       if not l-summary then                                                     */
/*          display                                                                */
/*             "--------------- --------------- ------------" to 131               */
/*             (if base_rpt = "" then GetTermLabelRtColon("BASE_REPORT_TOTAL", 18) */
/*              else base_rpt + " " + GetTermLabelRtColon("REPORT_TOTAL", 13))     */
/*             format "x(18)"   to 84                                              */
/*             accum total std_ext format "->>>>>>>>>>9.99<<<<"  to 102            */
/*             accum total pur_ext format "->>>>>>>>>>9.99<<<<"  to 118            */
/*             accum total std_var format "->>>>>>>9.99<<<<"  to 131               */
/*             (if base_rpt = ""                                                   */
/*              then                                                               */
/*                 GetTermLabelRtColon("BASE_REPORT_TOTAL_WITH_TAX", 27)           */
/*              else                                                               */
/*                 base_rpt +                                                      */
/*                 " "      +                                                      */
/*                 GetTermLabelRtColon("REPORT_TOTAL_WITH_TAX", 22))               */
/*              format "x(27)"   to 84                                             */
/*              rep_tot_with_tax format "->>>>>>>>>>9.99<<<<"  to 118              */
/*              "=============== =============== ============" to 131              */
/*          with frame g width 132 no-labels no-box.                               */
/*                                                                                 */
/*       if page-size - line-counter < 6 then page.                                */
/*                                                                                 */
/*       put skip(1).                                                              */
/*                                                                                 */
/*       display                                                                   */
/*          getTermLabel("SUMMARY", 15) format "x(15)"                             */
/*          skip                                                                   */
/*          "---------------"                                                      */
/*          skip.                                                                  */
/*                                                                                 */
/*       put skip (1).                                                             */
/*                                                                                 */
/*       for each tt_summary use-index tt_acc_cc                                   */
/*       with frame b1 down width 132 no-box:                                      */
/*                                                                                 */
/*          setFrameLabels(frame b1:handle).                                       */
/*                                                                                 */
/*          display                                                                */
/*             tt_acc                                                              */
/*             tt_sub                                                              */
/*             tt_cc                                                               */
/*             tt_pur_ext (total) column-label "Unvouchered Amount".               */
/*       end.                                                                      */

   end.  /* do on endkey */

  

/*     hide message no-pause.           */
/*    {pxmsg.i &MSGNUM=9 &ERRORLEVEL=1} */
/*                                      */


{wbrp04.i &frame-spec = a}

PROCEDURE ip-quoter:

   {mfquoter.i vendor    }
   {mfquoter.i vendor1   }
   {mfquoter.i part      }
   {mfquoter.i part1     }
   {mfquoter.i site      }
   {mfquoter.i site1     }
   {mfquoter.i acc       }
   {mfquoter.i acc1      }
   {mfquoter.i sub       }
   {mfquoter.i sub1      }
   {mfquoter.i cc        }
   {mfquoter.i cc1       }
   {mfquoter.i effdate   }
   {mfquoter.i rcpt_from }
   {mfquoter.i sel_inv   }
   {mfquoter.i sel_sub   }
   {mfquoter.i sel_mem   }
   {mfquoter.i excl_unconfirmed}
   {mfquoter.i use_tot   }
   {mfquoter.i base_rpt  }
   {mfquoter.i l-summary }

END PROCEDURE.


PROCEDURE getSupplierDefaults:

   /* Determine the PO Receipts and the Expensed Items Receipts Account
    * of the supplier */

   vendor_type = "".

   for first vd_mstr
      where vd_domain = global_domain
      and   vd_addr   = prh_hist.prh_vend
   no-lock:

      assign
         descname    = vd_sort
         vendor_type = vd_type.

      for first acdf_mstr
         where acdf_domain = global_domain
         and   acdf_module = "VD"
         {&POPORP11-P-TAG1}
         and   acdf_type   = "VD_RCPT_ACC"
         {&POPORP11-P-TAG2}
         and   acdf_key1   = vd_addr
      no-lock:
         assign
            rcptacct  = acdf_acct
            rcptsub   = acdf_sub
            rcptcc    = acdf_cc.
      end.

      for first acdf_mstr
         where acdf_domain = global_domain
         and   acdf_module = "VD"
         {&POPORP11-P-TAG1}
         and   acdf_type = "VD_RCPTX_ACC"
         {&POPORP11-P-TAG3}
         and   acdf_key1 = vd_addr
      no-lock:
         assign
            rcptxacct  = acdf_acct
            rcptxsub   = acdf_sub
            rcptxcc    = acdf_cc.
      end.

   end.

END PROCEDURE.

PROCEDURE getReceiptAccounts:

   {&POPORP11-P-TAG1}
   if prh_hist.prh_type <> "M"
   {&POPORP11-P-TAG4}
   then
      assign
         receiptacc = rcptacct
         receiptsub = rcptsub
         receiptcc  = rcptcc.
   else
      assign
         receiptacc = rcptxacct
         receiptsub = rcptxsub
         receiptcc  = rcptxcc.

   if receiptacc = ""
      and receiptsub = ""
      and receiptcc = ""
   then do:

      if prh_type <> "M" then do:
         for first pt_mstr
            where pt_domain = global_domain
            and   pt_part = prh_part
         no-lock,
         first pl_mstr
            where pl_domain = global_domain
            and   pl_prod_line = pt_prod_line
         no-lock:
            {gprun.i ""glactdft.p""
                     "(input ""PO_RCPT_ACCT"",
                       input if available pt_mstr then pt_prod_line
                             else """",
                       input prh_site,
                       input vendor_type,
                       input """",
                       input yes,
                       output receiptacc,
                       output receiptsub,
                       output receiptcc)"}
         end.
      end.
   end.

   if receiptacc = ""
      and receiptsub = ""
      and receiptcc = ""
   then
      assign
         receiptacc  = gl_ctrl.gl_rcptx_acct
         receiptsub  = gl_ctrl.gl_rcptx_sub
         receiptcc   = gl_ctrl.gl_rcptx_cc.

END PROCEDURE.
