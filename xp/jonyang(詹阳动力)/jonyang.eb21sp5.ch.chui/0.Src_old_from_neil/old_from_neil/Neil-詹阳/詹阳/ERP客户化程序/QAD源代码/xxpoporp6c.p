/* poporp6c.p - PURCHASE ORDER RECEIPTS REPORT Sorted by Packing Slip Nbr     */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*                                                                            */
/* REVISION: 7.4      LAST MODIFIED: 12/17/93 BY: dpm  *H074*                 */
/* REVISION: 7.4      LAST MODIFIED: 09/27/94 BY: dpm  *FR87*                 */
/* REVISION: 7.4      LAST MODIFIED: 03/29/95 BY: dzn  *F0PN*                 */
/* REVISION: 8.5      LAST MODIFIED: 11/15/95 BY: taf  *J053*                 */
/* REVISION: 8.5      LAST MODIFIED: 02/07/96 BY: *J0CV* Robert Wachowicz     */
/* REVISION: 8.5      LAST MODIFIED: 04/08/96 BY: *G1LD* Jeff Wootton         */
/* REVISION: 8.5      LAST MODIFIED: 07/18/96 BY: *J0ZS* Tamra Farnsworth     */
/* REVISION: 8.6      LAST MODIFIED: 10/03/97 BY: *K0KK* Madhusudhana Rao     */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98 BY: *L007* Annasaheb Rahane     */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98 BY: *L020* Charles Yen          */
/* REVISION: 9.1      LAST MODIFIED: 06/28/99 BY: *N00Q* Sachin Shinde        */
/* REVISION: 9.1      LAST MODIFIED: 12/23/99 BY: *L0N3* Sandeep Rao          */
/* REVISION: 9.1      LAST MODIFIED: 03/06/00 BY: *N05Q* David Morris         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane     */
/* REVISION: 9.1      LAST MODIFIED: 09/04/00 BY: *N0RC* Mark Brown           */
/* REVISION: 9.1      LAST MODIFIED: 08/17/00 BY: *N0KM* Rajinder Kamra       */
/* REVISION: 9.1      LAST MODIFIED: 01/18/01 BY: *N0VP* Sandeep Parab        */
/* Revision: 1.7.1.13       BY: Steve Nugent       DATE: 04/17/02 ECO: *P043* */
/* Revision: 1.7.1.14       BY: Patrick Rowan      DATE: 05/24/02 ECO: *P018* */
/* Revision: 1.7.1.15       BY: Hareesh V.         DATE: 06/21/02 ECO: *N1HY* */
/* Revision: 1.7.1.18       BY: Patrick Rowan      DATE: 08/15/02 ECO: *P0FH* */
/* Revision: 1.7.1.19       BY: Karan Motwani      DATE: 08/27/02 ECO: *N1SB* */
/* Revision: 1.7.1.20       BY: Dan Herman         DATE: 08/29/02 ECO: *P0DB* */
/* Revision: 1.7.1.21.1.1   BY: N. Weerakitpanich  DATE: 05/03/03 ECO: *P0R5* */
/* Revision: 1.7.1.21.1.2   BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00J* */
/* Revision: 1.7.1.21.1.3   BY: Deepak Rao         DATE: 07/31/03 ECO: *P0T9* */
/* Revision: 1.7.1.21.1.4   BY: Manisha Sawant     DATE: 04/26/04 ECO: *P1YV* */
/* Revision: 1.7.1.21.1.5   BY: Bhagyashri Shinde  DATE: 11/23/04 ECO: *P2W5* */
/* Revision: 1.7.1.21.1.6   BY: Robin McCarthy     DATE: 01/05/05 ECO: *P2P6* */
/* Revision: 1.7.1.21.1.7   BY: Anil Sudhakaran    DATE: 01/27/05 ECO: *P2PJ* */
/* Revision: 1.7.1.21.1.7.1.1  BY: Steve Nugent    DATE: 09/08/05 ECO: *Q0LM* */
/* Revision: 1.7.1.21.1.7.1.2  BY: Shivaraman V.   DATE: 03/07/06 ECO: *P4KF* */
/* $Revision: 1.7.1.21.1.7.1.6 $ BY: R. McCarthy   DATE: 09/22/06 ECO: *P575* */
/*By: Neil Gao 09/03/18 ECO: *SS 20090318* */

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:ConvertMode=Report                                                       */

{mfdeclre.i }
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{cxcustom.i "POPORP6C.P"}
{popvodet.i}   /* pvod_det TEMP-TABLE DEFINITION */
{wbrp02.i}

define input parameter ers-only        as logical   no-undo.
define input parameter l_sup_cnsg_code as character no-undo.

{poporp06.i} /* INCLUDE FILE FOR SHARED VARIABLES */
{apconsdf.i}

{&POPORP6C-P-TAG5}

define variable mc-error-number like msg_nbr no-undo.
define variable vouchered_qty like pvo_vouchered_qty no-undo.
define variable ex_rate like prh_ex_rate no-undo.
define variable ex_rate2 like prh_ex_rate2 no-undo.
define variable project like pvo_project no-undo.
define variable l_prh_nbr like prh_nbr no-undo.
define variable l_prh_receiver like prh_receiver no-undo.
define variable tax_amt as decimal format "->>>>>>>>>>9.99<<<" no-undo.
define variable voucheredTax as decimal no-undo.
define variable l_nonvouchered_qty like pvo_vouchered_qty no-undo.
define variable base_std_cost as decimal.
define variable poders as character format "x(2)" no-undo.
define variable exRateUsageSeq as decimal no-undo.
define variable totalTransQty as decimal no-undo.
define variable tot_tax_amt as decimal no-undo.
define variable tot_std_ext as decimal no-undo.
define variable tot_std_var as decimal no-undo.
define variable tot_pur_ext as decimal no-undo.
define buffer b_tt_pvod_det for tt_pvoddet.
/*SS 20090318 - B*/
define variable ptdesc1 like pt_desc1.
define variable ptdesc2 like pt_desc2.
/*SS 20090318 - E*/

find first gl_ctrl where gl_domain = global_domain no-lock no-error.

{&POPORP6C-P-TAG1}
for each prh_hist
   where prh_domain = global_domain
   and ((prh_rcp_date >= rdate and prh_rcp_date <= rdate1
   or   (prh_rcp_date = ? and rdate = low_date))
   and  (prh_vend >= vendor and prh_vend <= vendor1)
   and  (prh_part >= part and prh_part <= part1)
   and  (prh_site >= site and prh_site <= site1)
   and  (prh_ps_nbr >= fr_ps_nbr and prh_ps_nbr <= to_ps_nbr)
   and ((prh_type = "" and sel_inv = yes)
   or   (prh_type = "S" and sel_sub = yes)
   or   (prh_type <> "" and prh_type <> "S" and sel_mem = yes))
   and (can-find (first pod_det
           where pod_domain   = global_domain
           and  (pod_nbr      = prh_nbr
           and   pod_line     = prh_line
           and   pod_project >= pj and pod_project <= pj1)))
   and  (uninv_only = no  /* Non-Vouchered Receipts Only = NO */
         or
        ((uninv_only       /* Non-Vouchered Receipts Only = YES */
            and   can-find (first pvo_mstr
            where pvo_domain            = global_domain
            and  (pvo_lc_charge         = ""
            and   pvo_internal_ref_type = {&TYPE_POReceiver}
            and   pvo_internal_ref      = prh_receiver
            and   pvo_line              = prh_line
            and   pvo_last_voucher      = "")))
             or
           (uninv_only and
              not can-find (first pvo_mstr
              where pvo_domain            = global_domain
              and   pvo_lc_charge         = ""
              and   pvo_internal_ref_type = {&TYPE_POReceiver}
              and   pvo_internal_ref      = prh_receiver
              and   pvo_line              = prh_line
              and   pvo_last_voucher      = "")
              and   can-find (first pod_det
                    where pod_domain   = global_domain
                    and   pod_nbr      =  prh_nbr
                    and   pod_line     =  prh_line
                    and   pod_qty_rcvd <> 0))))
   and (base_rpt = ""
   or base_rpt = prh_curr)
   and (ers-only = no
   or  (ers-only
   and can-find (first pvo_mstr
   where pvo_domain = global_domain
   and   pvo_lc_charge         = ""
   and   pvo_internal_ref_type = {&TYPE_POReceiver}
   and   pvo_internal_ref      = prh_receiver
   and   pvo_line              = prh_line
   and   pvo_ers_status        = 2))))
use-index prh_rcp_date
no-lock break by prh_rcp_date by prh_ps_nbr by prh_vend with frame e
/*SS 20090318 - B*/
/*
down width 132 no-box:
*/
down width 175 no-box:
/*SS 20090318 - E*/
   {&POPORP6C-P-TAG2}

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame e:handle).

   {mfrpchk.i}

   assign
      l_nonvouchered_qty = 0
      vouchered_qty      = 0
      voucheredTax       = 0
      tax_amt            = 0.

   for each tx2d_det
      where tx2d_domain  = global_domain
      and   tx2d_ref     = prh_receiver
      and   tx2d_nbr     = prh_nbr
      and   tx2d_line    = prh_line
      and  (tx2d_tr_type = "21"
      or   (tx2d_tr_type = "25"
      and   prh_rcp_type = "R"))
      and   not tx2d_tax_in
      and   tx2d_rcpt_tax_point = yes
   no-lock:
      tax_amt = tax_amt + tx2d_cur_tax_amt.
   end.

   for each pvo_mstr
      where pvo_domain = global_domain
      and   pvo_internal_ref_type = {&TYPE_POReceiver}
      and   pvo_lc_charge    = ""
      and   pvo_internal_ref = prh_receiver
      and   pvo_line = prh_line
   no-lock:

      if uninv_only = yes then
         /* Back out the taxes that have been vouchered */
         for each vph_hist
            where vph_domain = global_domain
            and   vph_pvo_id        = pvo_id
            and   vph_pvod_id_line  > 0
            and  (vph_inv_date >= rdate
            and   vph_inv_date <= rdate1)
         no-lock:

            for each tx2d_det
               where tx2d_domain = global_domain
               and   tx2d_ref = vph_ref
               and   tx2d_nbr = prh_receiver
               and   tx2d_line = prh_line
               and   tx2d_tr_type = "22"
               and not tx2d_tax_in
               and   tx2d_rcpt_tax_point = yes
            no-lock:
               voucheredTax = voucheredTax + tx2d_cur_tax_amt.
            end.
         end. /* for each vph_hist */
   end. /* for each pvo_mstr */

   tax_amt = tax_amt - voucheredTax.

   /* DETERMINE THE VALUES FOR ex_rate, ex_rate2 and project. */
   /* THIS IS TO SUPPORT SUPPLIER CONSIGNMENT RECEIPTS, WHERE THE pvo_mstr    */
   /* IS NOT CREATED AT TIME OF RECEIPT BUT TIME OF USAGE.  NORMAL RECEIPTS   */
   /* WILL CREATE pvo_mstr RECORDS WITH THE APPROPRIATE EXCHANGE RATES.       */
   /* FOR SUPPLIER CONSIGNMENT RECIEPTS (WHERE THE pvo_mstr IS NOT AVAILABLE) */
   /* THE EXCHANGE RATES COME FROM THE RECEIPT HISTORY RECORD (prh_hist).     */
   if (oldcurr <> prh_curr)
      or (oldcurr = "")
   then do:

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
            if c-application-mode <> "WEB" then
               pause.

            next.
         end.
      end.
      oldcurr = prh_curr.
   end.

   do with frame ehead:
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame ehead:handle).

      /* INITIALIZE pvod_det TEMP-TABLE */
      for each tt_pvoddet exclusive-lock:
         delete tt_pvoddet.
      end.

      /* INITIALIZE TOTAL TRANSACTION QUANTITY */
      totalTransQty = 0.

      for each pvo_mstr
         fields (pvo_internal_ref_type
                 pvo_id            pvo_line       pvo_internal_ref
                 pvo_lc_charge     pvo_trans_qty  pvo_last_voucher
                 pvo_vouchered_qty pvo_ers_status pvo_project)
         where pvo_domain = global_domain
         and   pvo_internal_ref = prh_receiver
         and   pvo_line         = prh_line
      no-lock:

         /* CALCULATE TOTAL TRANSACTION QUANTITY */
         totalTransQty = totalTransQty + pvo_trans_qty.

         /* DON'T POLULATE pvod_det TEMP-TABLE WHEN ONLY SUPPLIER */
         /* CONSIGNED QUANTITIES ARE TO BE CONSIDERED OR WHEN     */
         /* UNINVOICED ONLY = YES AND THE pvo_mstr IS CLOSED.     */
         if l_sup_cnsg_code <> "3"  and
            ((uninv_only = no) or (uninv_only = yes and pvo_last_voucher = ""))
         then do:
            for each pvod_det
               where pvod_domain = global_domain
               and   pvod_id = pvo_id
            no-lock:

               buffer-copy pvod_det to b_tt_pvod_det.

               assign b_tt_pvod_det.pvoddet_id      = pvod_det.pvod_id
                      b_tt_pvod_det.pvoddet_id_line = pvod_det.pvod_id_line.

               /* GET EXTENDED TABLE RECORDS */
               /* THIS CODE CAN BE REMOVED ONCE THE FIELDS ARE ADDED IN eB3*/
               {poporpcn.i}

            end.
         end. /* IF l_sup_cnsg_code <> "3" THEN DO */
      end. /* FOR EACH pvo_mstr */

      /* CREATE DUMMY pvod_det RECORD FOR CONSIGNED INVENTORY */
      if l_sup_cnsg_code = "2" or l_sup_cnsg_code = "3" then do:
         create tt_pvoddet.
         assign
            pvoddet_id             = 999999999
            pvoddet_id_line        = 99999999
            pvoddet_trans_qty      = prh_rcvd - totalTransQty
            pvoddet_vouchered_qty  = 0
            pvoddet_pur_cost       = prh_pur_cost
            pvoddet_pur_std        = prh_pur_std
            pvoddet_ovh_std        = prh_ovh_std
            pvoddet_ex_rate        = prh_ex_rate
            pvoddet_ex_rate2       = prh_ex_rate2
            pvoddet_ex_ratetype    = prh_ex_ratetype
            pvoddet_exru_seq       = prh_exru_seq.
      end.

      assign
         tot_std_ext = 0
         tot_pur_ext = 0
         tot_std_var = 0
         tot_tax_amt = 0.

      for each tt_pvoddet no-lock:

         /* DETERMINE VOUCHERED & UN-VOUCHERED QTY FOR EACH pvod_det */
         assign
            ex_rate            = pvoddet_ex_rate
            ex_rate2           = pvoddet_ex_rate2
            project            = pvoddet_project
            l_nonvouchered_qty = pvoddet_trans_qty - pvoddet_vouchered_qty
            vouchered_qty      = pvoddet_vouchered_qty.

         /* PRH_PUR_STD IS IN BASE CURRENCY */
         std_cost = pvoddet_pur_std.

         if prh_type = "" then
            std_cost = pvoddet_pur_std - pvoddet_ovh_std.

         if use_tot = yes or prh_type = "S"  then
            std_cost = pvoddet_pur_std.

         /* SAVE THE BASE CURRENCY STANDARD UNIT COST */
         base_std_cost = std_cost.

         /* IF REPORT IS NOT IN BASE THEN CONVERT THE STD UNIT COST */
         /* TO DOCUMENT CURRENCY */
         if base_rpt <> ""
            and prh_curr <> base_curr
         then do:

            /* CONVERT FROM BASE TO FOREIGN CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
                      "(input  base_curr,
                        input  prh_curr,
                        input  ex_rate2,
                        input  ex_rate,
                        input  std_cost,
                        input  false, /* DO NOT ROUND */
                        output std_cost,
                        output mc-error-number)"}

            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end.
         end. /* IF BASE_RPT <> "" AND PRH_CURR <> BASE_CURR */

         /* ALWAYS BEGIN WITH THE DOCUMENT CURRENCY UNIT COST */
         assign
            base_cost = pvoddet_pur_cost * ex_rate / ex_rate2
            disp_curr = "".

         /* NO NEED FOR CONVERSION BASE_COST = DOC CURR UNIT COST */
         if base_rpt = ""
            and prh_curr <> base_curr
         then do:
            /* IF BASE RPT, SET BASE_COST TO BASE FOR DISPLAY ONLY */
            assign
               base_cost = pvoddet_pur_cost.
               disp_curr = getTermLabel("YES",1).
         end.

         /* 'EXCLUDE' SUPPLIER CONSIGNED INVENTORY*/
         if l_sup_cnsg_code = "1" then do:

            /* WHEN NON-VOUCHERED ONLY IS 'YES' INCLUDE INVENTORY THAT IS */
            /* NON-VOUCHERED */
            if uninv_only then
               assign
                  qty_open = l_nonvouchered_qty * prh_um_conv
                  tax_amt  = (tax_amt + voucheredTax) * l_nonvouchered_qty
                           / prh_rcvd.

            /* WHEN NON-VOUCHERED ONLY IS 'NO' INCLUDE INVENTORY THAT IS */
            /* VOUCHERED AND NON-VOUCHERED */
            if not uninv_only then
               assign
                  qty_open = (l_nonvouchered_qty + vouchered_qty) * prh_um_conv
                  tax_amt  = tax_amt * (l_nonvouchered_qty + vouchered_qty)
                           / prh_rcvd.

         end. /* IF l_sup_cnsg_code = "1" */

         /* 'INCLUDE' SUPPLIER CONSIGNED INVENTORY */
         else if l_sup_cnsg_code = "2" then do:

            /* WHEN NON-VOUCHERED ONLY IS 'YES' INCLUDE INVENTORY THAT IS */
            /* NON-VOUCHERED. IN CASE OF CONSIGNED ITEMS ALSO INCLUDE */
            /* INVENTORY THAT IS RECEIVED BUT NOT CONSUMED */
            if uninv_only then
               qty_open = (pvoddet_trans_qty - vouchered_qty) * prh_um_conv.

            /* WHEN NON-VOUCHERED ONLY IS 'NO' INCLUDE INVENTORY THAT IS */
            /* VOUCHERED AND NON-VOUCHERED. IN CASE OF CONSIGNED ITEMS */
            /* ALSO INCLUDE INVENTORY THAT IS RECEIVED BUT NOT CONSUMED */
            if not uninv_only then
               qty_open = pvoddet_trans_qty * prh_um_conv.

         end. /* IF l_sup_cnsg_code = "2" */

         /* INCLUDE 'ONLY' SUPPLIER CONSIGNED INVENTORY I.E. INCLUDE ONLY */
         /* INVENTORY THAT IS RECEIVED BUT NOT YET USED */
         else if l_sup_cnsg_code = "3" then
            assign
               qty_open = pvoddet_trans_qty * prh_um_conv
               tax_amt  = (tax_amt + voucheredTax)
                        * pvoddet_trans_qty / prh_rcvd.

         /* NEGATIVE PO RECEIPTS SHOULD DISPLAY A NEGATIVE OPEN QTY. */
         /* POSITIVE RECEIPTS WHOSE QTY OPEN IS LESS THAN OR EQUAL   */
         /* TO ZERO SHOULD NOT DISPLAY.                              */
         if prh_rcvd > 0 and qty_open <= 0 then next.
         else if prh_rcvd < 0 and qty_open >= 0 then next.

         /* CALCULATE THE EXTENDED STANDARD COST FIRST IN BASE CURRENCY */
         /* BECAUSE STD COST IS ALWAYS STORED IN BASE */
         std_ext = base_std_cost * qty_open.

         /* ROUND PER BASE CURRENCY ROUND METHOD */
         {gprunp.i "mcpl" "p" "mc-curr-rnd"
                   "(input-output std_ext,
                     input  rndmthd,
                     output mc-error-number)"}

         /* CONVERT STD_EXT TO DOCUMENT CURRENCY IF NECESSARY */
         if base_rpt <> ""
            and prh_curr <> base_curr
         then do:

            /* CONVERT FROM BASE TO FOREIGN CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
                      "(input  base_curr,
                        input  prh_curr,
                        input  ex_rate2,
                        input  ex_rate,
                        input  std_ext,
                        input  true, /* DO ROUND */
                        output std_ext,
                        output mc-error-number)"}

            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end.
         end.

         /* CALCULATE THE EXTENDED PUR COST IN DOCUMENT CURRENCY */
         pur_ext = (pvoddet_pur_cost * ex_rate / ex_rate2) * qty_open.

         /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */
         {gprunp.i "mcpl" "p" "mc-curr-rnd"
                   "(input-output pur_ext,
                     input  rndmthd,
                     output mc-error-number)"}

         /* CONVERT PUR EXT AMT TO BASE IF NECESSARY */
         if base_rpt = ""
            and prh_curr <> base_curr
         then do:

            /* CONVERT FROM FOREIGN TO BASE CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
                      "(input  prh_curr,
                        input  base_curr,
                        input  ex_rate,
                        input  ex_rate2,
                        input  pur_ext,
                        input  true, /* DO ROUND */
                        output pur_ext,
                        output mc-error-number)"}

            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end.
         end.

         /* ROUND PER BASE CURRENCY ROUND METHOD */
         {gprunp.i "mcpl" "p" "mc-curr-rnd"
                   "(input-output tax_amt,
                     input  rndmthd,
                     output mc-error-number)"}

         /* CONVERT PUR EXT AMT TO BASE IF NECESSARY */
         if base_rpt = ""
            and prh_curr <> base_curr
         then do:

            /* CONVERT FROM FOREIGN TO BASE CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
                      "(input  prh_curr,
                        input  base_curr,
                        input  ex_rate,
                        input  ex_rate2,
                        input  tax_amt,
                        input  true, /* DO ROUND */
                        output tax_amt,
                        output mc-error-number)"}

            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end.
         end.

         std_var = pur_ext - std_ext.

         if prh_type <> ""
            and prh_type <> "S"
         then
            assign
               std_cost = 0
               std_ext  = 0
               std_var  = 0.

         find pod_det
            where pod_domain = global_domain
            and   pod_nbr = prh_nbr
            and   pod_line = prh_line
         no-lock no-error.

         if available pod_det then
            poders = string(pod_ers_opt, ">9").

         {&POPORP6C-P-TAG3}

         if first-of (prh_ps_nbr)
            or prh_rcp_date <> last_rcp
            or prh_vend <> last_vend
         then do:
            if first (prh_ps_nbr)
               or prh_rcp_date <> last_rcp
               or prh_vend <> last_vend
            then
               put skip(1).
            else if page-size - line-counter < 7 then do:
               page.
               put skip(1).
            end.

            assign
               last_rcp  = prh_rcp_date
               last_vend = prh_vend.

            display
               prh_rcp_date
               prh_ps_nbr
               prh_vend
            with frame ehead no-box width 132.
         end.

         if page-size - line-counter < 0 then do:
            page.
            put skip(1).

            display
               prh_rcp_date
               prh_ps_nbr
               prh_vend
               "  " +  dynamic-function('getTermLabelFillCentered' in h-label,
                  input "CONTINUE", input 12, input '*') format "x(64)"
                  @ descname no-label
/*SS 20090318 - B*/
/*
            with frame ehead no-box width 132.
*/
            with frame ehead no-box width 175.
/*SS 20090318 - E*/
         end.

         if qty_open <> 0 or prh_ps_qty <> 0 then do:
/*SS 20090318 - B*/
            find pt_mstr where pt_domain = global_domain and pt_part = prh_part no-lock no-error.
               if available pt_mstr then do :
                  ptdesc1 = pt_desc1.    
                  ptdesc2 = pt_desc2.
               end.
               else do:
                  ptdesc1 = "".
                  ptdesc2 = "".
               end.                                 		
/*SS 20090318 - E*/
            display
               prh_part                       column-label "Item Number!ERS Option"
/*SS 20090318 - B*/
								ptdesc1 column-label "ÃèÊö" 
/*SS 20090318 - E*/
               prh_receiver @ l_prh_receiver  column-label "Receiver!Project"
               prh_line
               prh_nbr @ l_prh_nbr            column-label "Order!Ship Date"
               qty_open                       column-label "Recd Qty!Ps Qty"
                                              format "->>>,>>>,>>9.9<<<<<<<<"
               prh_rcp_type
               std_cost                       column-label "GL Cost!PO Cost"
               disp_curr
               std_ext
               pur_ext                        column-label "Ext PO Cost!Ext PO Tax"
               std_var                        format "->>>>>>>>>>9.99<<<<"
            with frame e.

            down with frame e.

            display
               poders        @ prh_part
               project       @ l_prh_receiver
               prh_ship_date @ l_prh_nbr
               prh_ps_qty @ qty_open      format "->>>,>>>,>>9.9<<<<<<<<"
               base_cost @ std_cost       format "->>>>>>>>9.99<<<"
/*SS 20090318 - B*/
								ptdesc2 		 @ ptdesc1
/*SS 20090318 - E*/
            with frame e.

            display
               tax_amt @ pur_ext
            with frame e.

            down with frame e.

            {&POPORP6C-P-TAG4}

         end.   /* if qty_open <> 0 */

         poders = "".

         assign
            tot_std_ext = tot_std_ext + std_ext
            tot_pur_ext = tot_pur_ext + pur_ext
            tot_std_var = tot_std_var + std_var
            tot_tax_amt = tot_tax_amt + tax_amt.

      end. /* FOR EACH tt_pvoddet */

      assign
         std_ext = tot_std_ext
         pur_ext = tot_pur_ext
         std_var = tot_std_var
         tax_amt = tot_tax_amt.

      accumulate std_ext (total by prh_ps_nbr).
      accumulate pur_ext (total by prh_ps_nbr).
      accumulate std_var (total by prh_ps_nbr).
      accumulate tax_amt (total by prh_ps_nbr).

      if last-of (prh_ps_nbr)
         and show_sub = yes
      then do:
         if page-size - line-counter < 3 then do:
            page.
            put skip(1).
            display
               prh_rcp_date
               prh_vend
               prh_ps_nbr
               "  " +  dynamic-function('getTermLabelFillCentered' in h-label,
                  input "CONTINUE", input 12, input '*') format "x(64)"
                  @ descname no-label
            with frame ehead no-box width 132.
         end.

         if std_ext <> 0 or pur_ext <> 0 or std_var <> 0 then
            underline
               std_ext
               pur_ext
               std_var
            with frame e.

         if (accum total by prh_ps_nbr std_ext) <> 0 or
            (accum total by prh_ps_nbr pur_ext) <> 0 or
            (accum total by prh_ps_nbr std_var) <> 0 or
            (accum total by prh_ps_nbr tax_amt) <> 0
         then
            display
              (if base_rpt = "" then
                 getTermLabelRtColon("BASE_PACKING_SLIP_NUMBER_TOTAL",18)
               else
                  base_rpt + " "
                     + getTermLabelRtColon("PACKING_SLIP_NUMBER_TOTAL",14))
                     format "x(18)" to 74
               accum total by prh_ps_nbr std_ext format "->>>>>>>>>>9.99<<<<" to 90
               accum total by prh_ps_nbr pur_ext format "->>>>>>>>>>9.99<<<<" to 106
               accum total by prh_ps_nbr std_var format "->>>>>>>>>>9.99<<<<" to 122
               accum total by prh_ps_nbr tax_amt format "->>>>>>>>>>9.99<<<<" to 106
               skip(1)
            with frame f width 132 no-labels no-box.
      end.
   end. /* DO WITH */
end. /* For each prh_hist */

if page-size - line-counter < 4 then do:
   page.
   put skip(1).
end.

if (accum total std_ext) <> 0 or
   (accum total pur_ext) <> 0 or
   (accum total std_var) <> 0 or
   (accum total tax_amt) <> 0
then
   display
/*SS 20090318 - B*/
/*
      "--------------- --------------- ---------------" to 122
*/
      "--------------- --------------- ---------------" to 175
/*SS 20090318 - E*/
      (if base_rpt = "" then
          getTermLabelRtColon("BASE_REPORT_TOTAL",18)
       else
          base_rpt + " " + getTermLabelRtColon("REPORT_TOTAL",14))
          format "x(18)"   to 74
       accum total std_ext format "->>>>>>>>>>9.99<<<<"  to 90
       accum total pur_ext format "->>>>>>>>>>9.99<<<<"  to 106
       accum total std_var format "->>>>>>>>>>9.99<<<<"  to 122
       accum total tax_amt format "->>>>>>>>>>9.99<<<<"  to 106
       "=============== =============== ===============" to 122
/*SS 20090318 - B*/
/*
    with frame g width 132 no-labels no-box.
*/
    with frame g width 175 no-labels no-box.
/*SS 20090318 - E*/
/*V8-*/
{wbrp04.i}
/*V8+*/
