/* poporp6a.p - PURCHASE ORDER RECEIPTS REPORT Sort By Po Num                 */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.35 $                                                              */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 7.4    LAST MODIFIED: 12/17/93                 BY: dpm *H074     */
/* REVISION: 7.4    LAST MODIFIED: 09/27/94                 BY: dpm *FR87*    */
/* REVISION: 7.4    LAST MODIFIED: 10/21/94                 BY: mmp *H573*    */
/* REVISION: 8.5    LAST MODIFIED: 11/15/95                 BY: taf *J053*    */
/* REVISION: 8.5    LAST MODIFIED: 02/12/96      BY: *J0CV* Robert Wachowicz  */
/* REVISION: 8.5    LAST MODIFIED: 04/08/96                 BY: jzw *G1LD*    */
/* REVISION: 8.5    LAST MODIFIED: 07/18/96     BY: taf *J0ZS**/
/* REVISION: 8.5    LAST MODIFIED: 10/24/96     BY: *H0NK* Ajit Deodhar       */
/* REVISION: 8.5    LAST MODIFIED: 03/07/97     BY: *J1KL* Suresh Nayak       */
/* REVISION: 8.6    LAST MODIFIED: 10/03/97     BY: mur *K0KK**/
/* REVISION: 8.6E   LAST MODIFIED: 02/23/98     BY: *L007* A. Rahane          */
/* REVISION: 8.6E   LAST MODIFIED: 06/11/98     BY: *L020* Charles Yen        */
/* REVISION: 9.0    LAST MODIFIED: 02/06/99     BY: *M06R* Doug Norton        */
/* REVISION: 9.0    LAST MODIFIED: 03/13/99     BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1    LAST MODIFIED: 06/28/99     BY: *N00Q* Sachin Shinde      */
/* REVISION: 9.1    LAST MODIFIED: 12/23/99     BY: *L0N3* Sandeep Rao        */
/* REVISION: 9.1    LAST MODIFIED: 03/06/00     BY: *N05Q* David Morris       */
/* REVISION: 9.1    LAST MODIFIED: 03/24/00     BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1    LAST MODIFIED: 04/27/00     BY: *N09M* Peter Faherty      */
/* REVISION: 9.1    LAST MODIFIED: 06/30/00     BY: *N009* David Morris       */
/* REVISION: 9.1    LAST MODIFIED: 07/20/00     BY: *N0GF* Mudit Mehta        */
/* REVISION: 9.1    LAST MODIFIED: 08/13/00     BY: *N0KQ* myb                */
/* REVISION: 9.1    LAST MODIFIED: 01/18/01     BY: *N0VP* Sandeep P.         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.25      BY: Patrick Rowan       DATE: 04/17/02  ECO: *P043*    */
/* Revision: 1.26      BY: Patrick Rowan       DATE: 05/24/02  ECO: *P018*    */
/* Revision: 1.27      BY: Hareesh V           DATE: 06/21/02  ECO: *N1HY*    */
/* Revision: 1.29      BY: Patrick Rowan       DATE: 08/15/02  ECO: *P0FH*    */
/* Revision: 1.30      BY: Karan Motwani       DATE: 08/27/02  ECO: *N1SB*    */
/* Revision: 1.31      BY: Dan Herman          DATE: 08/29/02  ECO: *P0DB*    */
/* Revision: 1.32      BY: Mercy Chittilapilly DATE: 12/10/02  ECO: *N21W*    */
/* Revision: 1.33      BY: Narathip W.         DATE: 05/02/03  ECO: *P0R5*    */
/* Revision: 1.34      BY: Deepak Rao          DATE: 05/29/03  ECO: *P0T9*    */
/* $Revision: 1.35 $       BY: Bhagyashri Shinde   DATE: 02/12/04  ECO: *P1NV*    */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/****************************************************************************/
/****************************************************************************/

{mfdeclre.i }
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
/*cj*/ {cxcustom.i "YYPOPORP6D.P"}

{wbrp02.i}

/*cj*/ {yypoporp06.i} /* INCLUDE FILE FOR SHARED VARIABLES */
{apconsdf.i}

{&POPORP6A-P-TAG6}
define variable base_std_cost as decimal.
define variable l_first_of_nbr as logical no-undo.
define variable l_first_nbr    as logical no-undo.
define variable mc-error-number like msg_nbr no-undo.
define variable o_disp_line1   as character format "x(80)" no-undo.
define variable o_disp_line2   as character format "x(80)" no-undo.
find first gl_ctrl no-lock no-error.
define variable poders as character format "x(2)" no-undo.

define variable vouchered_qty like pvo_vouchered_qty no-undo.
define variable last_voucher like pvo_last_voucher no-undo.
define variable ers_status like pvo_ers_status no-undo.
define variable ex_rate like prh_ex_rate no-undo.
define variable ex_rate2 like prh_ex_rate2 no-undo.
define variable tax_amt as decimal format "->>>>>>>>>>9.99<<<" no-undo.
define variable voucheredTax as decimal no-undo.
define variable l_nonvouchered_qty like pvo_vouchered_qty no-undo.

define input parameter ers-only        as logical   no-undo.
define input parameter l_sup_cnsg_code as character no-undo.

/*cj*add*beg*/ 
DEF TEMP-TABLE xx
    FIELD xx_vend LIKE vd_addr
    FIELD xx_name LIKE ad_name
    FIELD xx_c1 AS DEC format "->>>>>>>>>>>9.99<<<"
    FIELD xx_c2 AS DEC format "->>>>>>>>>>>9.99<<<"
    FIELD xx_c3 AS DEC format "->>>>>>>>>>>9.99<<<"
    FIELD xx_c4 AS DEC format "->>>>>>>>>>>9.99<<<"
    FIELD xx_c5 AS DEC format "->>>>>>>>>>>9.99<<<" .

DEF VAR c1tot AS DEC format "->>>>>>>>>>>9.99<<<" .
DEF VAR c2tot AS DEC format "->>>>>>>>>>>9.99<<<" .
DEF VAR c3tot AS DEC format "->>>>>>>>>>>9.99<<<" .
DEF VAR c4tot AS DEC format "->>>>>>>>>>>9.99<<<" .
DEF VAR c5tot AS DEC format "->>>>>>>>>>>9.99<<<" .

FOR EACH xx :
    DELETE xx .
END.
uninv_only = YES .
/*cj*add*end*/ 

{&POPORP6A-P-TAG1}
for each prh_hist
      where (prh_rcp_date >= rdate and prh_rcp_date <= rdate1
      or  (prh_rcp_date = ? and rdate = low_date))
      and (prh_vend >= vendor and prh_vend <= vendor1)
      and (prh_part >= part and prh_part <= part1)
      and (prh_site >= site and prh_site <= site1)
      and (prh_ps_nbr >= fr_ps_nbr and prh_ps_nbr <= to_ps_nbr)
      and ((prh_type = "" and sel_inv = yes)
      or  (prh_type = "S" and sel_sub = yes)
      or  (prh_type <> "" and prh_type <> "S" and sel_mem = yes))
      and (can-find (first pod_det where
                pod_nbr      = prh_nbr            and
                pod_line     = prh_line           and
                pod_project >= pj and pod_project <= pj1))
      and (uninv_only = no  /* Non-Vouchered Receipts Only = NO */
             or
           (uninv_only   and  /* Non-Vouchered Receipts Only = YES */
              not can-find (first pvo_mstr where
                  pvo_lc_charge         = ""                 and
                  pvo_internal_ref_type = {&TYPE_POReceiver} and
                  pvo_internal_ref      = prh_receiver       and
                  pvo_line              = prh_line           and
                  pvo_last_voucher      <> "")))
      and (base_rpt = ""
      or base_rpt = prh_curr)
      use-index prh_nbr no-lock break by prh_nbr
   with frame b down width 132 no-box:

   {&POPORP6A-P-TAG2}
   if first-of(prh_nbr) then do:

      l_first_of_nbr  = yes.
      if first (prh_nbr) then
         l_first_nbr  = yes.

      for first po_mstr
         fields(po_nbr po_project)
         where po_nbr = prh_nbr
         no-lock:
      end. /* FOR FIRST po_mstr */
   end. /* IF FIRST-OF prh_nbr */

   assign
      l_nonvouchered_qty = 0
      vouchered_qty      = 0
      voucheredTax       = 0
      tax_amt            = 0.

   for each tx2d_det
      where tx2d_ref = prh_receiver
      and  tx2d_nbr = prh_nbr
      and  tx2d_line = prh_line
      and  tx2d_tr_type = "21"
      and not tx2d_tax_in
      and  tx2d_rcpt_tax_point = yes
      no-lock:
      tax_amt = tax_amt + tx2d_cur_tax_amt.
   end. /*for each tx2d_det*/

   for first pvo_mstr
      where pvo_internal_ref_type = {&TYPE_POReceiver}
      and pvo_lc_charge    = ""
      and pvo_internal_ref = prh_receiver
      and pvo_line = prh_line
      no-lock:

      if uninv_only = yes then
         /* Back out the taxes that have been vouchered */
         for each vph_hist where
            vph_pvo_id        = pvo_id  and
            vph_pvod_id_line  = 0       and
            (vph_inv_date >= rdate and
             vph_inv_date <= rdate1) no-lock:

            for each tx2d_det
               where tx2d_ref = vph_ref
               and  tx2d_nbr = prh_receiver
               and  tx2d_line = prh_line
               and  tx2d_tr_type = "22"
               and not tx2d_tax_in
               and  tx2d_rcpt_tax_point = yes
               no-lock:
               voucheredTax = voucheredTax + tx2d_cur_tax_amt.
            end. /*for each tx2d_det*/
      end. /* if uninv_only = yes then */
   end. /* for first pvo_mstr */

   tax_amt = tax_amt - voucheredTax.

   /* DETERMINE THE VALUES FOR ex_rate and ex_rate2. */
   /* THIS IS TO SUPPORT SUPPLIER CONSIGNMENT RECEIPTS, WHERE THE pvo_mstr    */
   /* IS NOT CREATED AT TIME OF RECEIPT BUT TIME OF USAGE.  NORMAL RECEIPTS   */
   /* WILL CREATE pvo_mstr RECORDS WITH THE APPROPRIATE EXCHANGE RATES.       */
   /* FOR SUPPLIER CONSIGNMENT RECIEPTS (WHERE THE pvo_mstr IS NOT AVAILABLE) */
   /* THE EXCHANGE RATES COME FROM THE RECEIPT HISTORY RECORD (prh_hist).     */

   if available (pvo_mstr) then
      assign
         ex_rate  = pvo_ex_rate
         ex_rate2 = pvo_ex_rate2.
   else
      assign
         ex_rate  = prh_ex_rate
         ex_rate2 = prh_ex_rate2.

   for each pvo_mstr
      fields (pvo_ex_rate       pvo_ex_rate2   pvo_internal_ref_type
              pvo_id            pvo_line       pvo_internal_ref
              pvo_lc_charge     pvo_trans_qty  pvo_last_voucher
              pvo_vouchered_qty pvo_ers_status pvo_external_ref)
      where pvo_internal_ref = prh_receiver
      and   pvo_line         = prh_line
   no-lock:

      assign
         l_nonvouchered_qty = l_nonvouchered_qty + pvo_trans_qty
                              - pvo_vouchered_qty
         vouchered_qty      = vouchered_qty + pvo_vouchered_qty.

      if  ers-only
      and pvo_lc_charge         = ""
      and pvo_internal_ref_type = "07"
      and pvo_external_ref      = prh_ps_nbr
      then
         assign
            last_voucher = pvo_last_voucher
            ers_status   = pvo_ers_status.

   end. /* FOR EACH pvo_mstr */

   if ers-only then do:

      if last_voucher = "" then do:
         find pod_det where pod_nbr = prh_nbr and pod_line = prh_line
         no-lock no-error.
         if available pod_det and pod_ers_opt = 1 then next.
      end. /* IF last_voucher = "" */
      else
         if  ers_status <> 2 then  next.
   end. /* IF ERS ONLY */

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
            if c-application-mode <> "WEB" then
               pause.

            next.
         end.
      end.
      oldcurr = prh_curr.
   end.

   /* RETRIEVE THE PROJECT FROM THE PURCHASE ORDER HEADER */
   if available po_mstr then
   for first pj_mstr
      fields (pj_project pj_desc) no-lock

      where pj_project = po_project:
   end.

   do with frame bhead:
      if l_first_of_nbr = yes  or prh_vend <> last_vend then do:

         l_first_of_nbr = no.

/*cj*         if l_first_nbr  or prh_vend <> last_vend  then do:
            l_first_nbr = no.
            put skip(1). 
         end.
         else if page-size - line-counter < 7 then do:
            page.
            put skip(1).
         end.*/
         last_vend = prh_vend.
         descname = "".
         find vd_mstr where vd_addr = prh_vend no-lock no-error.
         if available vd_mstr then descname = vd_sort.
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame bhead:handle).
/*cj*         display
            prh_nbr
            prh_vend
            descname no-label
         with frame bhead no-box width 132.*/
/*cj*         if available pj_mstr then
            display
            pj_project
            pj_desc no-label
         with frame bhead.*/
      end.

/*cj*      if page-size - line-counter < 0 then do:
         page.
         put skip(1).

         if available pj_mstr then
            display
            prh_nbr
            prh_vend
            descname
            pj_project
            pj_desc      no-label
         with frame bhead.
         else
            display
            prh_nbr
            prh_vend
            descname
            "" @ pj_project
            "" @ pj_desc no-label

            "  " + dynamic-function('getTermLabelFillCentered' in h-label,
            input "CONTINUE", input 12, input '*') format "x(14)"
         with frame bhead.

      end.  */
      /* PRH_PUR_STD IS IN BASE CURRENCY */
      std_cost = prh_pur_std.
      if prh_type = ""
      then
         std_cost = prh_pur_std - prh_ovh_std.
      if use_tot = yes or prh_type = "S"  then std_cost = prh_pur_std.

      /* SAVE THE BASE CURRENCY STANDARD UNIT COST */
      base_std_cost = std_cost.
      /* IF RPT NOT IN BASE AND PRH_CURR DIFF THEN CONVERT THE STD_COST*/
      /* TO DOCUMENT CURRENCY */
      if base_rpt <> ""
         and prh_curr <> base_curr then
   do:

         /* CONVERT FROM BASE TO FOREIGN CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input base_curr,
              input prh_curr,
              input ex_rate2,
              input ex_rate,
              input std_cost,
              input false, /* DO NOT ROUND */
              output std_cost,
              output mc-error-number)"}.
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end.
      end. /* IF BASE_RPT <> "" AND PRH_CURR <> BASE_CURR */

      /* ALWAYS BEGIN WITH THE DOCUMENT CURRENCY UNIT COST */
      base_cost = prh_curr_amt.
      disp_curr = "".

      /* NO NEED FOR CONVERSION BASE_COST = DOC CURR UNIT COST */

      if base_rpt = ""
         and prh_curr <> base_curr then do:
         /* IF BASE RPT, SET BASE_COST TO BASE FOR DISPLAY ONLY */
         base_cost = prh_pur_cost.
         disp_curr = getTermLabel("YES",1).
      end.

      /* SUPPLIER CONSIGNED IS 'EXCLUDE' */

      if l_sup_cnsg_code = "1"
      then do:

         /* NON-VOUCHERED ONLY IS 'YES' */

         if uninv_only
         then
            assign
               qty_open = l_nonvouchered_qty * prh_um_conv
               tax_amt  = (tax_amt + voucheredTax) * l_nonvouchered_qty
                          / prh_rcvd.

         /* NON-VOUCHERED ONLY IS 'NO' */

         if not uninv_only
         then
            assign
               qty_open = (l_nonvouchered_qty + vouchered_qty) * prh_um_conv
               tax_amt  = tax_amt * (l_nonvouchered_qty + vouchered_qty)
                          / prh_rcvd.

      end. /* IF l_sup_cnsg_code = "1" */

      /* SUPPLIER CONSIGNED IS 'INCLUDE' */

      if l_sup_cnsg_code = "2"
      then do:

         /* NON-VOUCHERED ONLY IS 'YES' */

         if uninv_only
         then
            qty_open = (prh_rcvd - vouchered_qty) * prh_um_conv.

         /* NON-VOUCHERED ONLY IS 'NO' */

         if not uninv_only
         then
            qty_open = prh_rcvd * prh_um_conv.

      end. /* IF l_sup_cnsg_code = "2" */

      /* WHEN SUPPLIER CONSIGNED IS 'ONLY'   */

      if l_sup_cnsg_code = "3"
      then
         assign
            qty_open = (prh_rcvd - l_nonvouchered_qty - vouchered_qty)
                       * prh_um_conv
            tax_amt  = (tax_amt + voucheredTax) - ((tax_amt + voucheredTax)
                       * (l_nonvouchered_qty + vouchered_qty) / prh_rcvd).

      if qty_open = 0
      then
         next.

      /* CALCULATE THE EXTENDED STANDARD COST FIRST IN BASE CURRENCY */
      /* BECAUSE STD COST IS ALWAYS STORED IN BASE */
      std_ext = base_std_cost * qty_open.
      /* ROUND PER BASE CURRENCY ROUND METHOD */

      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output std_ext,
           input gl_rnd_mthd,
           output mc-error-number)"}
      /* CONVERT STD_EXT TO DOCUMENT CURRENCY IF NECESSARY */
      if base_rpt <> ""
         and prh_curr <> base_curr
      then do:

         /* CONVERT FROM BASE TO FOREIGN CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input base_curr,
              input prh_curr,
              input ex_rate2,
              input ex_rate,
              input std_ext,
              input true, /* DO ROUND */
              output std_ext,
              output mc-error-number)"}.
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end.
         /* ROUND PER DOC CURRENCY ROUND METHOD */

      end.

      /* CALCULATE THE EXTENDED PUR COST IN DOCUMENT CURRENCY */
      pur_ext = prh_curr_amt * qty_open.
      /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */

      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output pur_ext,
           input rndmthd,
           output mc-error-number)"}
      /* CONVERT PUR EXT AMT TO BASE IF NECESSARY */
      if base_rpt = ""
         and prh_curr <> base_curr then do:

         /* CONVERT FROM FOREIGN TO BASE CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input prh_curr,
              input base_curr,
              input ex_rate,
              input ex_rate2,
              input pur_ext,
              input true, /* DO ROUND */
              output pur_ext,
              output mc-error-number)"}.
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end.
         /* ROUND PER BASE CURRENCY ROUND METHOD */

      end.

/*cj      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output tax_amt,
           input rndmthd,
           output mc-error-number)"}
      /* CONVERT PUR EXT AMT TO BASE IF NECESSARY */
      if base_rpt = ""
         and prh_curr <> base_curr then do:

         /* CONVERT FROM FOREIGN TO BASE CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input prh_curr,
              input base_curr,
              input ex_rate,
              input ex_rate2,
              input tax_amt,
              input true, /* DO ROUND */
              output tax_amt,
              output mc-error-number)"}.
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end.
         /* ROUND PER BASE CURRENCY ROUND METHOD */
      end. */

/*cj      std_var = pur_ext - std_ext.
      if prh_type <> "" and prh_type <> "S" then do:
         std_cost = 0.
         std_ext  = 0.
         std_var  = 0.
      end.
      accumulate std_ext (total by prh_nbr).
      accumulate pur_ext (total by prh_nbr).
      accumulate std_var (total by prh_nbr).
      accumulate tax_amt (total by prh_nbr).

      find pod_det where pod_nbr = prh_nbr and pod_line = prh_line
      no-lock no-error.
      if available pod_det then poders = string(pod_ers_opt,">9"). */

      /* SET EXTERNAL LABELS */
/*cj*      setFrameLabels(frame b:handle).
      {&POPORP6A-P-TAG3}
      display
         prh_receiver column-label "Receiver!PS Nbr"
         format "x(20)"
         prh_line
         prh_part
         column-label "Item Number!ERS Option"
         prh_rcp_date
         column-label "Receipt!Ship Date"
         qty_open
         format "->>>>>>9.9<<<<<<" column-label "Recd Qty!Ps Qty"
         prh_rcp_type
         std_cost column-label "GL Cost!PO Cost"
         disp_curr
         std_ext
         pur_ext column-label "Ext PO Cost!Ext PO Tax"
         std_var
      with frame b.
      {&POPORP6A-P-TAG4}

      down with frame b.

      display prh_ps_nbr    @ prh_receiver
              prh_ps_qty    @ qty_open
              poders        @ prh_part
              prh_ship_date @ prh_rcp_date
              tax_amt       @ pur_ext
          base_cost     @ std_cost with frame b.

      {&POPORP6A-P-TAG5}

     if last-of (prh_nbr) and show_sub = yes then do:
         if page-size - line-counter < 3 then do:
            page.
            put skip(1).

            if available pj_mstr then
            display
               prh_nbr
               prh_vend
               descname
               pj_project
               pj_desc       no-label
            with frame bhead.
            else
            display
               prh_nbr
               prh_vend
               descname
               "" @ pj_project
               "" @ pj_desc no-label

               "  " + dynamic-function('getTermLabelFillCentered' in h-label,
               input "CONTINUE",  input 12,  input '*') format "x(14)"
            with frame bhead.

         end.

         underline std_ext pur_ext std_var
         with frame b.

         /* END MOVED AFTER THE END OF IF LAST-OF (prh_nbr) CONDITION */

         if prh_curr <> base_curr then do:

            /* CALL MCUI.P TO FORMAT OUTPUT LINE */
            {gprunp.i "mcui" "p" "mc-ex-rate-output"
               "(input prh_curr,
                 input base_curr,
                 input ex_rate,
                 input ex_rate2,
                 input prh_exru_seq,
                 output o_disp_line1,
                 output o_disp_line2)"}.

            put {gplblfmt.i
               &FUNC=getTermLabel(""EXCHANGE_RATE"",10) &CONCAT="':'"} at 10
               o_disp_line1 format "x(80)" skip.
            put "          " at 10 o_disp_line2 format "x(80)". 
         end.

         put
            (if base_rpt = ""

            then getTermLabel("BASE_PURCHASE_ORDER_TOTAL",13) + ":"
            else base_rpt + getTermLabel("PURCHASE_ORDER_TOTAL",13) + ":")
            format "x(14)" to  76
            accum total by prh_nbr std_ext
            format "->>>>>>>>>>9.99<<<<" to 97
            accum total by prh_nbr pur_ext
            format "->>>>>>>>>>9.99<<<<" to 113
            accum total by prh_nbr std_var
            format "->>>>>>>>9.99<<<<" to 126
            accum total by prh_nbr tax_amt
            format "->>>>>>>>>>9.99<<<<" to 113
            skip(1).
      end.*/

   end. /* DO WITH */

/*cj*add*beg*/
      FIND xx WHERE xx_vend = prh_vend NO-ERROR .
      IF NOT AVAILABLE xx THEN DO :
          FIND ad_mstr NO-LOCK WHERE ad_addr = prh_vend NO-ERROR .
          CREATE xx .
          xx_vend = prh_vend .
          IF AVAILABLE ad_mstr THEN xx_name = ad_name .
      END.

      IF (TODAY - prh_rcp_date) < age[1] THEN xx_c1 = xx_c1 + pur_ext .
      IF (TODAY - prh_rcp_date) >= age[1] AND (TODAY - prh_rcp_date) < age[2] THEN xx_c2 = xx_c2 + pur_ext .
      IF (TODAY - prh_rcp_date) >= age[2] AND (TODAY - prh_rcp_date) < age[3] THEN xx_c3 = xx_c3 + pur_ext .
      IF (TODAY - prh_rcp_date) >= age[3] AND (TODAY - prh_rcp_date) < age[4] THEN xx_c4 = xx_c4 + pur_ext .
      IF (TODAY - prh_rcp_date) >= age[4] THEN xx_c5 = xx_c5 + pur_ext .
/*cj*add*end*/

end. /* For each prh_hist */
/*cj* if page-size - line-counter < 4 then do:
   page.
   put skip(1).
end.
display
   "--------------- --------------- ------------" to 126
   (if base_rpt = ""

   then getTermLabel("BASE_REPORT_TOTAL",20) + ":"
   else base_rpt + getTermLabel("REPORT_TOTAL",15) + ":")
   format "x(18)"   to 76
   accum total std_ext format "->>>>>>>>>>9.99<<<<"  to 97
   accum total pur_ext format "->>>>>>>>>>9.99<<<<"  to 113
   accum total std_var format "->>>>>>>>9.99<<<<"    to 126
   accum total tax_amt format "->>>>>>>>>>9.99<<<<"  to 113
      "=============== =============== ============" to 126
with frame g width 132 no-labels no-box.

setFrameLabels(frame g:handle).*/

/*cj*add*beg*/
PUT "供应商" AT 2 
    "名称" AT 12 
    "< " + STRING(age[1]) + "天" TO 60 
    STRING(age[1]) + " - " + STRING(age[2]) + "天" TO 80
    STRING(age[2]) + " - " + STRING(age[3]) + "天" TO 100
    STRING(age[3]) + " - " + STRING(age[4]) + "天" TO 120
    ">= " + STRING(age[4]) + "天" TO 140 SKIP .

c1tot = 0 .
c2tot = 0 .
c3tot = 0 .
c4tot = 0 .
c5tot = 0 .
FOR EACH xx NO-LOCK :
    PUT xx_vend AT 2 xx_name AT 12 xx_c1 TO 60 xx_c2 TO 80 xx_c3 TO 100 xx_c4 TO 120 xx_c5 TO 140 SKIP .
    c1tot = c1tot + xx_c1 .
    c2tot = c2tot + xx_c2 .
    c3tot = c3tot + xx_c3 .
    c4tot = c4tot + xx_c4 .
    c5tot = c5tot + xx_c5 .
END.

PUT SKIP(1) .
PUT UNFORMATTED FILL("-",100) AT 40 SKIP .
PUT "合计："  AT 12 c1tot TO 60 c2tot TO 80 c3tot TO 100 c4tot TO 120 c5tot TO 140 SKIP .
/*cj*add*end*/

/*V8-*/
{wbrp04.i}
/*V8+*/
