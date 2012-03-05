/* soivrp9a.p - INVOICE HISTORY REPORT BY INVOICE                             */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.37 $                                                          */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 7.4      LAST MODIFIED: 05/31/94   BY: dpm *GK02*                */
/*                                   09/23/94   BY: bcm *H536*                */
/*                                   10/19/94   BY: ljm *GN40*                */
/* REVISION: 7.4      LAST MODIFIED: 12/22/94   BY: jxz *G09W*                */
/* REVISION: 7.4      LAST MODIFIED: 01/19/95   BY: bcm *G0CR*                */
/* REVISION: 7.4      LAST MODIFIED: 02/13/95   BY: bcm *G0F0*                */
/* REVISION: 8.5      LAST MODIFIED: 07/13/95   BY: taf *J053*                */
/* REVISION: 8.5      LAST MODIFIED: 04/09/96   BY: jzw *G1P6*                */
/* REVISION: 8.5      LAST MODIFIED: 07/19/96   BY: taf *J0ZZ**/
/* REVISION: 8.5      LAST MODIFIED: 08/02/96   BY: taf *J13P**/
/* REVISION: 8.6      LAST MODIFIED: 10/04/97   BY: ckm *K0LH*                */
/* REVISION: 8.6      LAST MODIFIED: 01/21/98   BY: *J2BP* Manish K.          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 04/23/98   BY: *L00L* EvdGevel           */
/* REVISION: 8.6E     LAST MODIFIED: 07/15/98   BY  *L024* Bill Reckard       */
/* REVISION: 8.6E     LAST MODIFIED: 12/04/98   BY  *J360* Poonam Bahl        */
/* REVISION: 8.6E     LAST MODIFIED: 01/22/99   BY: *J38T* Poonam Bahl        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/99   BY: *L0DH* Narender S         */
/* REVISION: 9.0      LAST MODIFIED: 08/10/99   BY: *M0DM* Satish Chavan      */
/* REVISION: 9.1      LAST MODIFIED: 09/17/99   BY: *N02Z* Hemali Desai       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 02/17/00   BY: *M0HV* Sachin Shinde      */
/* REVISION: 9.1      LAST MODIFIED: 05/02/00   BY: *N09M* Antony Babu        */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* myb                */
/* REVISION: 9.1      LAST MODIFIED: 10/16/00   BY: *N0W8* Mudit Mehta        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.32     BY: Katie Hilbert         DATE: 04/01/01   ECO: *P002*  */
/* Revision: 1.33     BY: Ellen Borden          DATE: 07/09/01   ECO: *P007*  */
/* Revision: 1.34     BY: Jean Miller           DATE: 09/07/01   ECO: *N122*  */
/* Revision: 1.36     BY: Karan Motwani         DATE: 10/16/02   ECO: *N1WF*  */
/* $Revision: 1.37 $    BY: Amit Chaturvedi      DATE: 01/20/03   ECO: *N20Y*   */
/* $Revision: 1.37 $    BY: Bill Jiang      DATE: 09/21/05   ECO: *SS - 20050921*   */
/* $Revision: 1.37 $    BY: Bill Jiang      DATE: 02/21/06   ECO: *SS - 20060221*   */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20050921 - B */
{a6soivrp0902.i}
/* SS - 20050921 - E */
       
{mfdeclre.i}
{cxcustom.i "SOIVRP9A.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE soivrp9a_p_1 "Ext Margin"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivrp9a_p_3 "Ext Price"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivrp9a_p_4 "Discount"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivrp9a_p_6 "Unit Margin"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivrp9a_p_7 "Total"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivrp9a_p_8 "Total Tax"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivrp9a_p_11 "Exch Rate"
/* MaxLen: 40 Comment: Label for currency exchange rate */

&SCOPED-DEFINE soivrp9a_p_12 " Qty Ordered"
/* MaxLen: 18 Comment: Label for Ordered Quantity */

/* ********** End Translatable Strings Definitions ********* */

{wbrp02.i}

define new shared variable undo_txdetrp like mfc_logical.

define shared variable rndmthd like rnd_rnd_mthd.
define shared variable oldcurr like ih_curr.
define shared variable cust like ih_cust.
define shared variable cust1 like ih_cust.
define shared variable inv like ih_inv_nbr.
define shared variable inv1 like ih_inv_nbr.
define shared variable nbr like ih_nbr.
define shared variable nbr1 like ih_nbr.
define shared variable name like ad_name.
define shared variable spsn like sp_addr.
define shared variable spsn1 like spsn.
define shared variable po like ih_po.
define shared variable po1 like ih_po.
define shared variable gr_margin like idh_price label {&soivrp9a_p_6}
   format "->>>>>,>>9.99".
define shared variable ext_price like idh_price label {&soivrp9a_p_3}
   format "->>,>>>,>>>.99".
define shared variable ext_gr_margin like gr_margin label {&soivrp9a_p_1}.
define shared variable desc1 like pt_desc1 format "x(49)".
define shared variable curr_cost like idh_std_cost.
define shared variable base_price like ext_price.
define shared variable base_margin like ext_gr_margin.
define shared variable ext_cost like idh_std_cost.
define shared variable base_rpt like ih_curr.
define shared variable disp_curr as character format "x(1)" label "C".
define shared variable ih_recno as recid.
define shared variable tot_trl1 like ih_trl1_amt.
define shared variable tot_trl3 like ih_trl3_amt.
define shared variable tot_trl2 like ih_trl2_amt.
define variable base_trl1 like ih_trl1_amt.
define variable base_trl3 like ih_trl3_amt.
define variable base_trl2 like ih_trl2_amt.
define variable base_disc like ih_trl1_amt label {&soivrp9a_p_4}.
define variable base_tot_tax like ih_trl2_amt label {&soivrp9a_p_8}.
define variable base_ord_amt like ih_trl3_amt label {&soivrp9a_p_7}.
define shared variable tot_disc like ih_trl1_amt label {&soivrp9a_p_4}.
define shared variable rpt_tot_tax like ih_trl2_amt
   label {&soivrp9a_p_8}.
define shared variable tot_ord_amt like ih_trl3_amt label {&soivrp9a_p_7}.
{&SOIVRP9A-P-TAG1}
define shared variable net_price like idh_price.
define shared variable base_net_price like net_price
                             format "->>>>,>>>,>>9.99".
define shared variable detail_lines like mfc_logical.
define shared variable bill  like ih_bill.
define shared variable bill1 like ih_bill.
define variable  currdisp  like so_curr.
define new shared variable col-80      like mfc_logical initial false.
define variable tax_total   like tx2d_totamt.
define variable disprnd like rnd_rnd_mthd.
define variable tot_price  like ih_trl1_amt no-undo.
define variable tot_margin like ih_trl1_amt no-undo.
define variable tot_marg_fmt as character no-undo.
define variable tot_price_fmt as character no-undo.
define variable tot_trl_fmt as character no-undo.
define variable tot_tax_fmt as character no-undo.
define variable tot_disc_fmt as character no-undo.
define variable tot_ord_fmt as character no-undo.
define variable base_price_fmt as character no-undo.
define variable base_price_old as character no-undo.
define variable base_net_price_fmt as character no-undo.
define variable base_net_price_old as character no-undo.
define variable base_net_price_label as character no-undo.
define variable base_marg_fmt as character no-undo.
define variable base_marg_old as character no-undo.
define variable oldsession as character no-undo.
define variable v_disp_line1    as   character format "x(40)"
   label {&soivrp9a_p_11} no-undo.
define variable v_disp_line2    as   character format "x(40)" no-undo.
define variable v_cust_po       as   character format "x(31)" no-undo.
define variable v_cust_po_label as   character                no-undo.
define variable l_qty_call      like idh_qty_ord              no-undo.
define variable vContainerCharges as decimal no-undo.
define variable vLineCharges as decimal no-undo.
/* SS - 20050921 - B */
DEFINE SHARED VARIABLE entity LIKE gltr_entity.
DEFINE SHARED VARIABLE entity1 LIKE gltr_entity.
DEFINE SHARED VARIABLE eff_dt LIKE gltr_eff_dt.
DEFINE SHARED VARIABLE eff_dt1 LIKE gltr_eff_dt.
DEFINE SHARED VARIABLE inv_date LIKE ih_inv_date.
DEFINE SHARED VARIABLE inv_date1 LIKE ih_inv_date.
/* SS - 20050921 - E */

define new shared temp-table t_absr_det no-undo
   field t_absr_reference like absr_reference
   field t_absr_qty         as decimal format "->>>>,>>>,>>9.99"
   field t_absr_ext         as decimal format "->>>>,>>>,>>9.99".

{mfivtrla.i "NEW"}

{soivtot1.i }  /* Define variables for invoice totals. */

{etdcrvar.i new}
{etvar.i &new = new}
{etrpvar.i &new = new}
{etihtfrm.i}

define variable tot_container like container_charge_total no-undo.
define variable tot_line_charge like line_charge_total no-undo.

{gpfilev.i} /* VARIABLE DEFINITIONS FOR gpfile.i */

form
   tot_margin label {&soivrp9a_p_1}
   tot_price label {&soivrp9a_p_3}
   tot_disc
   tot_trl1
   tot_trl2
   tot_trl3
   tot_container
   tot_line_charge
   rpt_tot_tax
   tot_ord_amt
with frame d side-labels 3 columns width 132.

/* SET EXTERNAL LABELS */
/* SS - 20050921 - B */
/*
setFrameLabels(frame d:handle).
*/
/* SS - 20050921 - E */

define frame b
   ih_inv_nbr
   ih_rev
   v_cust_po
   ih_ship
   ih_ship_date
   ih_inv_date
   ih_slspsn[1]
   ih_curr
   v_disp_line1
with down width 132 no-box.

/* SET EXTERNAL LABELS */
/* SS - 20050921 - B */
/*
setFrameLabels(frame b:handle).
*/
/* SS - 20050921 - E */

assign
   substring(v_cust_po_label, 1) = getTermLabel("CUSTOMER",8)
   substring(v_cust_po_label, 9) = " " + getTermLabel("PURCHASE_ORDER",22)
   v_cust_po:LABEL in frame b    = v_cust_po_label.

form
   idh_nbr
   idh_line
   idh_part
   idh_um
   idh_qty_ord column-label {&soivrp9a_p_12}
   idh_qty_inv
   idh_bo_chg
   disp_curr
   base_net_price
   base_price
   base_margin
with frame c width 132 down.

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

assign
   base_net_price_label = getTermLabel("PRICE",7)
   base_net_price:LABEL in frame c = base_net_price_label.

{cclc.i} /* DETERMINE IF CONTAINER/LINE CHARGES IS ACTIVATED */

/* ASSIGN ORIGINAL FORMAT TO _OLD VARIABLES */
assign
   nontax_old     = nontaxable_amt:format
   taxable_old    = taxable_amt:format
   line_tot_old   = line_total:format
   disc_old       = disc_amt:format
   trl_amt_old    = ih_trl1_amt:format
   tax_amt_old    = tax_amt:format
   ord_amt_old    = ord_amt:format
   base_price_old = base_price:format
   base_net_price_old = base_net_price:format
   base_marg_old  = base_margin:format
   container_old = container_charge_total:format
   line_charge_old = line_charge_total:format.

assign
   oldcurr = ""
   maint = no
   oldsession = SESSION:numeric-format.

/* SS - 20050921 - B */
FOR EACH tr_hist 
    WHERE tr_typ = 'ISS-SO'
    AND tr_effdate >= eff_dt
    AND tr_effdate <= eff_dt1
    AND tr_rmks >= inv
    AND tr_rmks <= inv1
    USE-INDEX tr_type
    NO-LOCK
    ,EACH si_mstr 
    WHERE si_site = tr_site
    AND si_entity >= entity
    AND si_entity <= entity1
    NO-LOCK
    BREAK BY tr_rmks:
    IF LAST-OF(tr_rmks) THEN DO:
/*
FOR EACH gltr_hist 
    WHERE gltr_doc_typ = 'I'
    AND gltr_eff_dt >= eff_dt
    AND gltr_eff_dt <= eff_dt1
    AND gltr_doc >= inv
    AND gltr_doc <= inv1
    AND gltr_entity >= entity
    AND gltr_entity <= entity1
    USE-INDEX gltr_doctyp
    NO-LOCK
    BREAK BY gltr_doc:
    IF LAST-OF(gltr_doc) THEN DO:
*/
/*
for each ih_hist where (ih_inv_nbr >= inv) and (ih_inv_nbr <= inv1)
*/
for each ih_hist where (ih_inv_nbr = tr_rmks)
/* SS - 20050921 - E */
      and (ih_nbr >= nbr) and (ih_nbr <= nbr1)
      and (ih_cust >= cust) and (ih_cust <= cust1)
      and (ih_bill >= bill and ih_bill <= bill1)
      and (ih_slspsn[1] >= spsn) and (ih_slspsn[1] <= spsn1)
      and (ih_sched or ((ih_po >= po) and (ih_po <= po1)))
      and (base_rpt = ""
      or ih_curr = base_rpt)
      /* SS - 20050921 - B */
      AND ih_inv_date >= inv_date
      AND ih_inv_date <= inv_date1
      /* SS - 20050921 - E */
      no-lock break by ih_inv_nbr with frame c down width 132.

   /* IF NO DETAIL RECORD EXIST THEN PRINT THE HEADER AND TRAILER  */
   /* AS BEFORE; IF ANY DETAIL HISTORY RECORDS EXIST THEN AT LEAST */
   /* ONE OF THE DETAIL RECORD SHOULD QUALITY THE SELECTION        */
   /* CRITERIA HAVING po NUMBER TO PRINT THE HEADER AND TRAILER.   */

   if can-find (first idh_hist where
      idh_inv_nbr = ih_inv_nbr and
      idh_nbr     = ih_nbr)    and
      not can-find (first idh_hist where
              idh_nbr = ih_nbr
      and idh_inv_nbr = ih_inv_nbr
      and ((idh_contr_id >= po) and (idh_contr_id <= po1)))
      then next.

   {&SOIVRP9A-P-TAG2}
   /* SET ROUND METHOD TO BASE AND FORMATS */

   if (oldcurr <> ih_curr) or (oldcurr = "") then do:

      {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
         "(input  ih_curr,
           output rndmthd,
           output mc-error-number)" }
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.

      /* DETERMINE CURRENCY DISPLAY AMERICAN OR EUROPEAN  */
      find rnd_mstr where rnd_rnd_mthd = rndmthd no-lock no-error.
      if not available rnd_mstr then do:
         {pxmsg.i &MSGNUM=863 &ERRORLEVEL=4}
         /* ROUND METHOD RECORD NOT FOUND */
         next.
      end.
      /* SET ONLY IF BASE_RPT <> BASE */

      if base_rpt <> ""
      then do:
         /* IF RND_DEC_PT EQUAL COMMA, THEN DECIMAL POINT IS COMMA*/
         /* THIS IS INDICATED BY THE EUROPEAN FORMAT CURRENCY */
         if (rnd_dec_pt = ",")
         then SESSION:numeric-format = "European".
         else SESSION:numeric-format = "American".
      end.
   end. /* IF (OLDCURR <> IH_CURR */

   if base_rpt = ""
   then disprnd = gl_rnd_mthd.
   else disprnd = rndmthd.

   /* SET FORMATS HERE BASE ON OLDCUR AND IH_CURR USING DISPRND*/
   if (oldcurr <> ih_curr) or (oldcurr = "") then do:
      {soivcfmt.i}

      /* SET base_net_price FORMAT */
      base_net_price_fmt = base_net_price_old.
      {gprun.i ""gpcurfmt.p"" "(input-output base_net_price_fmt,
                                input disprnd)"}


      /* SET BASE_PRICE FORMAT */
      base_price_fmt = base_price_old.
      {gprun.i ""gpcurfmt.p"" "(input-output base_price_fmt,
                                input disprnd)"}

      /* SET BASE_MARGIN FORMAT */
      base_marg_fmt = base_marg_old.
      {gprun.i ""gpcurfmt.p"" "(input-output base_marg_fmt,
                                input disprnd)"}

      oldcurr = ih_curr.
   end. /* IF (OLDCURR <> IH_CURR) */

   ih_recno = recid(ih_hist).
   name = "".
   find ad_mstr where ad_addr = ih_cust no-lock no-wait no-error.
   if available ad_mstr then name = ad_name.

   /* SS - 20050921 - B */
   /*
   if page-size - line-counter < 3 then page.
   if first-of(ih_inv_nbr) then do:
      assign
         invtot_container_amt = 0
         invtot_linecharge_amt = 0
         v_cust_po               = ""
         substring(v_cust_po, 1) = ih_cust
         substring(v_cust_po, 9) = " " + ih_po.

      {gprunp.i "mcui" "p" "mc-ex-rate-output"
         "(input ih_curr,
           input base_curr,
           input ih_ex_rate,
           input ih_ex_rate2,
           input ih_exru_seq,
           output v_disp_line1,
           output v_disp_line2)"}

      display
         ih_inv_nbr
         ih_rev
         v_cust_po
         ih_ship
         ih_ship_date
         ih_inv_date
         ih_slspsn[1]
         ih_curr
         v_disp_line1
      with frame b down width 132.

      if name <> "" or ih_slspsn[2] <> "" or
         v_disp_line2 <> ""
      then do with frame b:
         down 1.
         display
            name         @ v_cust_po
            ih_slspsn[2] @ ih_slspsn[1]
            v_disp_line2 @ v_disp_line1.
      end.

      if ih_slspsn[3] <> "" then do with frame b:
         down 1.
         display ih_slspsn[3] @ ih_slspsn[1].
      end.
      if ih_slspsn[4] <> "" then do with frame b:
         down 1.
         display ih_slspsn[4] @ ih_slspsn[1].
      end.

      if ih_rmks <> "" then put ih_rmks at 13.
      put skip(1).

      {soivtot2.i}  /* Initialize variables for invoice totals. */

   end.  /* Header display */
   */
   /* SS - 20050921 - E */

   /* GET INVOICE HISTORY DETAIL */
   detail_lines = no.
   for each idh_hist where idh_inv_nbr = ih_inv_nbr
         and idh_nbr     = ih_nbr
         and (not ih_sched
         or ((idh_contr_id >= po) and (idh_contr_id <= po1)))
         no-lock
         break by idh_inv_nbr
         by idh_nbr
         by idh_line with no-box frame c width 132:

      net_price = idh_price.
      ext_price = net_price * idh_qty_inv.
      /* ROUND PER DOCUMENT CURRENCY */
      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output ext_price,
           input        rndmthd,
           output       mc-error-number)" }
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.

      /*CONVERT STD COST TO FOREIGN CURR TO CALC MARGIN*/

      /* CONVERT COST (STORED IN BASE) TO DOC CURRENCY IN ORDER TO  */
      /* CALCULATE THE GROSS MARGIN.  DO NOT ROUND THE UNIT COST.   */

      if base_curr <> ih_curr
      then do:

         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input  base_curr,
              input  ih_curr,
              input  ih_ex_rate2,
              input  ih_ex_rate,
              input  idh_std_cost,
              input  false,  /* DO NOT ROUND */
              output curr_cost,
              output mc-error-number)" }
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end.
      end.
      else assign curr_cost = idh_std_cost.

      gr_margin = net_price - curr_cost.
      ext_gr_margin = idh_qty_inv * gr_margin.

      /* ROUND EXT_GR_MARGIN USING DOC CURRENCY ROUNDING METHOD   */

      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output ext_gr_margin,
           input        rndmthd,
           output       mc-error-number)" }
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.

      /* THESE AMOUNTS ARE ALL IN DOC CURRENCY                      */
      assign
         base_net_price = net_price
         base_price = ext_price
         base_margin = ext_gr_margin.
      /* IF BASE IS NOT DOC CURRENCY AND RPT IS IN BASE THEN CONVERT*/
      /* THE NET_PRICE, PRICE, AND MARGIN TO BASE.                  */
      if base_curr <> ih_curr and base_rpt = ""
      then do:

         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input  ih_curr,
              input  base_curr,
              input  ih_ex_rate,
              input  ih_ex_rate2,
              input  base_net_price,
              input  false,  /* DO NOT ROUND */
              output base_net_price,
              output mc-error-number)" }
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end.

         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input  ih_curr,
              input  base_curr,
              input  ih_ex_rate,
              input  ih_ex_rate2,
              input  base_price,
              input  true,  /* ROUND */
              output base_price,
              output mc-error-number)" }
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end.

         /* ROUND PER BASE CURR ROUND METHOD */

         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input  ih_curr,
              input  base_curr,
              input  ih_ex_rate,
              input  ih_ex_rate2,
              input  base_margin,
              input  true,  /* ROUND */
              output base_margin,
              output mc-error-number)" }
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end.

         currdisp  = base_curr.
      end.
      else currdisp = ih_curr.

      accumulate (base_price) (total by idh_inv_nbr).
      accumulate (base_margin) (total by idh_inv_nbr).

      desc1 = "".
      find pt_mstr where pt_part = idh_part no-lock no-wait no-error.
      if available pt_mstr then desc1 = pt_desc1 + " " + pt_desc2.

      base_net_price:format = base_net_price_fmt.
      base_price:format = base_price_fmt.
      base_margin:format = base_marg_fmt.

      if ih_fsm_type = "FSM-RO"
      then do:

         assign
            l_qty_call = 0
            idh_qty_ord:label = getTermLabel("QUANTITY_REPAIRED",17).

         for first itm_det
               fields(itm_nbr itm_line itm_part itm_qty_call)
               where itm_nbr = idh_nbr
               and   itm_line = idh_line
               and   itm_part = idh_part
               no-lock:
         end. /* FOR FIRST itm_det */

         if available itm_det
         then
            l_qty_call = itm_qty_call.

         else do:

            for first itmh_hist
                  fields(itmh_nbr itmh_line itmh_part itmh_qty_call)
                  where itmh_nbr = idh_nbr
                  and   itmh_line = idh_line
                  and   itmh_part = idh_part
                  no-lock:
            end. /* FOR FIRST itmh_hist */

            if available itmh_hist
            then
               l_qty_call = itmh_qty_call.

         end. /* ELSE DO */

      end. /* IF ih_fsm_type = "FSM-RO" */

      else

      idh_qty_ord:label = " " + getTermLabel("QUANTITY_ORDERED",14).

      /* SS - 20050921 - B */
      /*
      display
         idh_nbr
         idh_line
         idh_part
         idh_um
         idh_qty_ord when (ih_fsm_type <> "FSM-RO")
         l_qty_call  when (ih_fsm_type =  "FSM-RO") @ idh_qty_ord
         idh_qty_inv when (ih_fsm_type <> "FSM-RO")
         l_qty_call  when (ih_fsm_type =  "FSM-RO") @ idh_qty_inv
      with frame c.

      if ih_fsm_type <> "FSM-RO"
      then do:
         if idh_qty_ord >= 0 then /* show bo regardless of sign */
            display max(idh_qty_ord - idh_qty_ship, 0) @ idh_bo_chg
            with frame c.
         else
            display min(idh_qty_ord - idh_qty_ship, 0) @ idh_bo_chg
            with frame c.
      end. /* IF ih_fsm_type <> "FSM-RO" */
      else
         display "" @ idh_bo_chg with frame c.

      display
         disp_curr
         base_net_price
         base_price
         base_margin
         idh_due_date idh_type
      with frame c.
      */
      /* REPLACED OUTPUT PARAMETER TAX_TOTAL WITH TAX_AMT */
      {gprun.i  ""txtotal.p"" "(input '16',
                                input ih_inv_nbr,
                                input ih_nbr,
                                input idh_line,
                                output tax_amt)" }

      /* OBTAINING TOTAL INCLUDED TAX FOR THE TRANSACTION */
      {gprun.i ""txtotal1.p"" "(input '16',
                                input  ih_inv_nbr,
                                input  ih_nbr,
                                input  idh_line,
                                output l_tax_in)"}
      CREATE tta6soivrp0902.
      ASSIGN
          tta6soivrp0902_inv_nbr = ih_inv_nbr
          tta6soivrp0902_nbr = ih_nbr
          tta6soivrp0902_line = idh_line
          tta6soivrp0902_cust = ih_cust
          tta6soivrp0902_prodline = idh_prodline
          tta6soivrp0902_part = idh_part
          tta6soivrp0902_qty_inv = idh_qty_inv
          tta6soivrp0902_ext_price = ext_price
          tta6soivrp0902_ext_margin = ext_gr_margin
          tta6soivrp0902_ext_tax = tax_amt + l_tax_in
          tta6soivrp0902_base_price = base_price
          tta6soivrp0902_base_margin = base_margin
          tta6soivrp0902_base_tax = tax_amt + l_tax_in
          tta6soivrp0902_taxc = idh_taxc
          tta6soivrp0902_acct = idh_acct
          tta6soivrp0902_sub = idh_sub
          tta6soivrp0902_cc = idh_cc
          tta6soivrp0902_eff_dt = tr_effdate
          tta6soivrp0902_inv_date = ih_inv_date
          /* SS - 20060221 - B */
          tta6soivrp0902_ih_channel = ih_channel
          tta6soivrp0902_idh_site = idh_site
          /* SS - 20060221 - E */
          .
      /* SS - 20050921 - E */
      detail_lines = yes.

      /* SS - 20050921 - B */
      /*
      if not ih_sched then
         put desc1 at 6 skip.
      else
         put desc1 at 6
         getTermLabelRtColon("PURCHASE_ORDER",15) + " "
         format "x(16)" at 57
         idh_contr_id      at 73 skip.

      if using_line_charges then do:
           /* PRINT LINE CHARGES */
         run printLineCharges
            (input idh_inv_nbr,
             input idh_nbr,
             input idh_line,
             input ih_ship,
             input ih_site,
             input ih_curr,
             input base_curr,
             input base_rpt,
             input ih_ex_rate,
             input ih_ex_rate2,
             input-output vLineCharges).
         if last-of(idh_nbr) then do:
            if base_curr <> ih_curr
               and base_rpt = ""
            then do:
               run CurrencyConversion
                  (input  ih_curr,
                   input  base_curr,
                   input  ih_ex_rate,
                   input  ih_ex_rate2,
                   input-output vLineCharges).
            end. /* IF BASE_CURR <> IH_CURR */
            assign
               invtot_linecharge_amt = invtot_linecharge_amt + vLinecharges
               invtot_line_total = invtot_line_total + vLineCharges
               tot_line_charge = tot_line_charge + vLineCharges
               invtot_ord_amt = invtot_ord_amt + vLineCharges.
            vLineCharges = 0.
         end. /*IF LAST_OF(IDH_NBR)*/
       end. /* IF using_line_charges */

       if last-of(idh_nbr) and
          using_container_charges
       then do:

          run printContainerCharges
             (input idh_inv_nbr,
              input idh_nbr,
              input ih_ship,
              input ih_site,
              input ih_curr,
              input base_curr,
              input base_rpt,
              input ih_ex_rate,
              input ih_ex_rate2,
              input-output vContainerCharges).

          if base_curr <> ih_curr
             and base_rpt = ""
          then do:
             run CurrencyConversion
                (input  ih_curr,
                 input  base_curr,
                 input  ih_ex_rate,
                 input  ih_ex_rate2,
                 input-output vContainerCharges).
          end. /* IF BASE_CURR <> IH_CURR */

          assign
             invtot_container_amt = invtot_container_amt + vContainerCharges
             invtot_line_total = invtot_line_total + vContainerCharges
             tot_container = tot_container + vContainerCharges
             invtot_ord_amt = invtot_ord_amt + vContainerCharges.
          vContainerCharges = 0.
       end. /* IF LAST-OF(IDH_NBR) and using_container_charges */
       */
       /* SS - 20050921 - E */
      {mfrpexit.i "false"}

   end. /* for each idh_hist */

   /* SS - 20050921 - B */
   /*
   if not last-of(ih_inv_nbr) then do:
      {gprun.i ""soihtrl2.p""}
      /* ACCUMULATE TRAILER TOTALS BY USING SOIVTOT9.I */
      run p-acc-totals
         (buffer ih_hist,
          input-output invtot_nontaxable_amt,
          input-output invtot_taxable_amt,
          input-output invtot_line_total,
          input-output invtot_disc_amt,
          input-output invtot_trl1_amt,
          input-output invtot_trl2_amt,
          input-output invtot_trl3_amt,
          input-output invtot_tax_amt,
          input-output invtot_ord_amt,
          input-output invtot_container_amt,
          input-output invtot_linecharge_amt) .
   end. /* IF NOT LAST-OF(IH_INV_NBR) */

   /* Total invoice including taxes */
   if last-of(ih_inv_nbr) then do:
      undo_txdetrp = true.

      /* CHANGED TXDETRP.P TO TXDETRP2.P TO FACILITATE PRINTING */
      /* OF TAX LINE DETAILS IN THE REPORTING CURRENCY          */
      {gprun.i ""txdetrp2.p"" "(input '16',
                                input ih_inv_nbr,
                                input '*',
                                input ih_curr,
                                input ih_ex_rate,
                                input ih_ex_rate2,
                                input col-80,
                                input 0)" }

      /* REPLACED OUTPUT PARAMETER TAX_TOTAL WITH TAX_AMT */
      {gprun.i  ""txtotal.p"" "(input '16',
                                input ih_inv_nbr,
                                input '*',
                                input 0,
                                output tax_amt)" }

      /* OBTAINING TOTAL INCLUDED TAX FOR THE TRANSACTION */
      {gprun.i ""txtotal1.p"" "(input '16',
                                input  ih_inv_nbr,
                                input  '*',
                                input  0,
                                output l_tax_in)"}

      {gprun.i ""soihtrl2.p""}
      /* ADJUSTING TOTAL TAX AMOUNT BY INCLUDED TAX */
      assign
         tax_amt = tax_amt + l_tax_in
         l_tax_in = 0
         ord_amt = ord_amt + tax_amt.
      /* ACCUMULATE TRAILER TOTALS USING SOIVTOT9.I */
      run p-acc-totals
         (buffer ih_hist,
          input-output invtot_nontaxable_amt,
          input-output invtot_taxable_amt,
          input-output invtot_line_total,
          input-output invtot_disc_amt,
          input-output invtot_trl1_amt,
          input-output invtot_trl2_amt,
          input-output invtot_trl3_amt,
          input-output invtot_tax_amt,
          input-output invtot_ord_amt,
          input-output invtot_container_amt,
          input-output invtot_linecharge_amt) .

      /* CONVERT TO BASE FOR REPORT TOTALS */
      assign
         base_trl1    = invtot_trl1_amt
         base_trl2    = invtot_trl2_amt
         base_trl3    = invtot_trl3_amt
         base_disc    = invtot_disc_amt
         base_tot_tax = invtot_tax_amt
         base_ord_amt = invtot_ord_amt.

      /* IF REPORT IS DESIRED IN BASE AND DOC CURRENCY IS NOT */
      /* BASE THEN CONVERT THE ROUNDED AMOUNTS TO BASE AND ROUND */
      if base_rpt = ""
         and ih_curr <> base_curr then do:

         /* COMMENTED CODE BELOW SINCE THE REPORT VARIABLES ARE */
         /* ALREADY CONVERTED TO BASE CURRENCY BY CALL TO       */
         /* SOIVTOT9.I ABOVE                                    */

      end.

      assign
         tot_trl1 = tot_trl1 + base_trl1
         tot_trl2 = tot_trl2 + base_trl2
         tot_trl3 = tot_trl3 + base_trl3
         tot_disc = tot_disc + base_disc
         rpt_tot_tax = rpt_tot_tax + base_tot_tax
         tot_ord_amt = tot_ord_amt + base_ord_amt.

   end. /* IF LAST-OF(IH_INV_NBR) */

   /*PRINT TRAILER*/
   if last-of(ih_inv_nbr)
   then do:
      {etdcrc.i ih_curr ih_hist.ih}
      {soivto10.i}
   end. /* IF LAST-OF(IH_INV_NBR) */
   */
   /* SS - 20050921 - E */

   {mfrpchk.i}

end. /* for each ih_hist */
/* SS - 20050921 - B */
    END. /* IF LAST-OF(gltr_doc) THEN DO: */
END. /* FOR EACH gltr_hist */
/* SS - 20050921 - E */

/* SET UP ALL FORMATS FOR TOTAL IN BASE CURRENCY */
/* SET TOT_MARGIN FORMAT */
/* SS - 20050921 - B */
/*
tot_marg_fmt = tot_margin:format.
{gprun.i ""gpcurfmt.p"" "(input-output tot_marg_fmt,
                          input gl_rnd_mthd)"}
tot_margin:format = tot_marg_fmt.

/* SET TOT_PRICE FORMAT */
tot_price_fmt = tot_price:format.
{gprun.i ""gpcurfmt.p"" "(input-output tot_price_fmt,
                          input gl_rnd_mthd)"}
tot_price:format = tot_price_fmt.

/* SET TOT_DISC FORMAT */
tot_disc_fmt = tot_disc:format.
{gprun.i ""gpcurfmt.p"" "(input-output tot_disc_fmt,
                          input gl_rnd_mthd)"}
tot_disc:format = tot_disc_fmt.

/* SET TOT_TRL FORMAT */
tot_trl_fmt = tot_trl1:format.
{gprun.i ""gpcurfmt.p"" "(input-output tot_trl_fmt,
                          input gl_rnd_mthd)"}
assign
   tot_trl1:format = tot_trl_fmt
   tot_trl2:format = tot_trl_fmt
   tot_trl3:format = tot_trl_fmt.

/* SET TOT_TAX FORMAT */
tot_tax_fmt = rpt_tot_tax:format.
{gprun.i ""gpcurfmt.p"" "(input-output tot_tax_fmt,
                          input gl_rnd_mthd)"}
rpt_tot_tax:format = tot_tax_fmt.

/* SET TOT_ORD FORMAT */
tot_ord_fmt = tot_ord_amt:format.
{gprun.i ""gpcurfmt.p"" "(input-output tot_ord_fmt,
                          input gl_rnd_mthd)"}
tot_ord_amt:format = tot_ord_fmt.

tot_price = accum total base_price.
tot_margin = accum total base_margin.

tot_container:format = tot_trl_fmt.
tot_line_charge:format = tot_trl_fmt.

if page-size - line-counter < 6 then page.

put skip(1) base_rpt + " " +
   getTermLabelRtColon("REPORT_TOTALS",14) format "x(18)" skip.

display
   tot_margin
   tot_price
   tot_disc
   tot_trl1
   tot_trl2
   tot_trl3
   tot_container
   tot_line_charge
   rpt_tot_tax
   tot_ord_amt
with frame d.
*/
/* SS - 20050921 - E */

SESSION:numeric-format = oldsession.
{wbrp04.i}

PROCEDURE p-acc-totals:
   /* THIS PROCEDURE ACCUMULATES TRAILER TOTALS FOR GTM */

   define parameter buffer ih_hist       for  ih_hist.
   define input-output parameter invtot_nontaxable_amt
      as decimal no-undo.
   define input-output parameter invtot_taxable_amt
      as decimal no-undo.
   define input-output parameter invtot_line_total
      as decimal no-undo.
   define input-output parameter invtot_disc_amt as decimal no-undo.
   define input-output parameter invtot_trl1_amt
      like ih_trl1_amt no-undo.
   define input-output parameter invtot_trl2_amt
      like ih_trl2_amt no-undo.
   define input-output parameter invtot_trl3_amt
      like ih_trl3_amt no-undo.
   define input-output parameter invtot_tax_amt as decimal no-undo.
   define input-output parameter invtot_ord_amt as decimal no-undo.
   define input-output parameter invtot_container_amt as decimal no-undo.
   define input-output parameter invtot_linecharge_amt as decimal no-undo.

   define variable tmpamt          as   decimal no-undo.
   define variable mc-error-number like msg_nbr no-undo.
   {soivtot9.i}
END PROCEDURE. /* PROCEDURE P-ACC-TOTALS */

PROCEDURE printContainerCharges:
   define input parameter ipInvNbr like idh_inv_nbr no-undo.
   define input parameter ipNbr like idh_nbr no-undo.
   define input parameter ipShip like ih_ship no-undo.
   define input parameter ipSite like ih_site no-undo.
   define input parameter ipCurr like ih_curr no-undo.
   define input parameter ipBaseCurr as character no-undo.
   define input parameter ipBaseRpt as character no-undo.
   define input parameter ipExchangeRate like ih_ex_rate no-undo.
   define input parameter ipExchangeRate2 like ih_ex_rate no-undo.
   define input-output parameter ioContainerCharges as decimal no-undo.
          /* PRINT CONTAINER CHARGES */
   {gprunmo.i
      &module = "ACL"
      &program = ""soivccrp.p""
      &param = """(input ipInvNbr,
                   input ipNbr,
                   input ipShip,
                   input ipSite,
                   input yes,
                   input ipCurr,
                   input ipBaseCurr,
                   input ipBaseRpt,
                   input ipExchangeRate,
                   input ipExchangeRate2,
                   input-output ioContainerCharges)"""}
END PROCEDURE. /* printContainerCharges */

PROCEDURE printLineCharges:
   define input parameter ipInvNbr like idh_inv_nbr no-undo.
   define input parameter ipNbr like idh_nbr no-undo.
   define input parameter ipLine like idh_line no-undo.
   define input parameter ipShip like ih_ship no-undo.
   define input parameter ipSite like ih_site no-undo.
   define input parameter ipCurr like ih_curr no-undo.
   define input parameter ipBaseCurr as character no-undo.
   define input parameter ipBaseRpt as character no-undo.
   define input parameter ipExchangeRate like ih_ex_rate no-undo.
   define input parameter ipExchangeRate2 like ih_ex_rate no-undo.
   define input-output parameter ioLineCharges as decimal no-undo.
          /* PRINT LINE CHARGES */

   {gprunmo.i
      &module = "ACL"
      &program = ""soivlcrp.p""
      &param = """(input ipInvNbr,
                   input ipNbr,
                   input ipLine,
                   input ipShip,
                   input ipSite,
                   input yes,
                   input ipCurr,
                   input ipBaseCurr,
                   input ipBaseRpt,
                   input ipExchangeRate,
                   input ipExchangeRate2,
                   input-output ioLineCharges)"""}

END PROCEDURE. /* printLineCharges */

PROCEDURE CurrencyConversion:
   define input parameter ipCurr like ih_curr no-undo.
   define input parameter ipBaseCurr as character no-undo.
   define input parameter ipExchangeRate like ih_ex_rate no-undo.
   define input parameter ipExchangeRate2 like ih_ex_rate no-undo.
   define input-output parameter ioCharge as decimal no-undo.
   define variable vMsgNbr as integer no-undo.

   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input  ipcurr,
        input  ipBaseCurr,
        input  ipExchangeRate,
        input  ipExchangeRate2,
        input  ioCharge,
        input  true,  /*ROUND */
        output ioCharge,
        output vMsgNbr)" }
   if vMsgNbr <> 0 then do:
      {pxmsg.i &MSGNUM=vMsgNbr &ERRORLEVEL=2}
   end.

END PROCEDURE. /* CurrencyConversion */
