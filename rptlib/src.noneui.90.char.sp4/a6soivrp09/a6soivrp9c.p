/* soivrp9a.p - INVOICE HISTORY REPORT BY INVOICE                       */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*K0LH*/
/*V8:ConvertMode=Report                                                 */
/* REVISION: 7.4      LAST MODIFIED: 05/31/94   BY: dpm *GK02*          */
/*                                   09/23/94   BY: bcm *H536*          */
/*                                   10/19/94   BY: ljm *GN40*          */
/* REVISION: 7.4      LAST MODIFIED: 12/22/94   BY: jxz *G09W*          */
/* REVISION: 7.4      LAST MODIFIED: 01/19/95   BY: bcm *G0CR*          */
/* REVISION: 7.4      LAST MODIFIED: 02/13/95   BY: bcm *G0F0*          */
/* REVISION: 8.5      LAST MODIFIED: 07/13/95   BY: taf *J053*          */
/* REVISION: 8.5      LAST MODIFIED: 04/09/96   BY: jzw *G1P6*          */
/* REVISION: 8.5      LAST MODIFIED: 07/19/96   BY: taf *J0ZZ**/
/* REVISION: 8.5      LAST MODIFIED: 08/02/96   BY: taf *J13P**/
/* REVISION: 8.6      LAST MODIFIED: 10/04/97   BY: ckm *K0LH*          */
/* REVISION: 8.6      LAST MODIFIED: 01/21/98   BY: *J2BP* Manish K.    */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 04/23/98   BY: *L00L* EvdGevel */
/* REVISION: 8.6E     LAST MODIFIED: 07/15/98   BY  *L024* Bill Reckard */
/* REVISION: 8.6E     LAST MODIFIED: 12/04/98   BY  *J360* Poonam Bahl  */
/* REVISION: 8.6E     LAST MODIFIED: 01/22/99   BY: *J38T* Poonam Bahl  */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/99   BY: *L0DH* Narender S   */
/* REVISION: 9.0      LAST MODIFIED: 08/10/99   BY: *M0DM* Satish Chavan*/
/* REVISION: 9.0      LAST MODIFIED: 02/17/00   BY: *M0HV* Sachin Shinde*/
                     
/*GN40*/ {mfdeclre.i}

         /* ********** Begin Translatable Strings Definitions ********* */

         &SCOPED-DEFINE soivrp9a_p_1 "毛利合计"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivrp9a_p_2 " 报表合计:"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivrp9a_p_3 "总价格"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivrp9a_p_4 "折扣"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivrp9a_p_5 "采购单:"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivrp9a_p_6 "单件毛利"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivrp9a_p_7 "合计 "
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivrp9a_p_8 "税款合计"
         /* MaxLen: Comment: */

/*L024*/ &SCOPED-DEFINE soivrp9a_p_9 "客户"
/*L024*/ /* MaxLen: 8  Comment: Label for SO customer */

/*L024*/ &SCOPED-DEFINE soivrp9a_p_10 "采购单"
/*L024*/ /* MaxLen: 22  Comment: Label for SO purchase order number */

/*L024*/ &scoped-define soivrp9a_p_11 "   兑换率"
/*L024*/ /* MaxLen: 40 Comment: Label for currency exchange rate */

/*M0HV*/ &SCOPED-DEFINE soivrp9a_p_12 " 订货量"
/*M0HV*/ /* MaxLen: 18 Comment: Label for Ordered Quantity */

/*M0HV*/ &SCOPED-DEFINE soivrp9a_p_13 "已维修量"
/*M0HV*/ /* MaxLen: 18 Comment: Label for Call Quantity */

         /* ********** End Translatable Strings Definitions ********* */

                     /* SS - Bill - B 2005.06.30 */
                     {a6soivrp09.i}

                    DEFINE SHARED VARIABLE inv_date LIKE ih_inv_date.
                    DEFINE SHARED VARIABLE inv_date1 LIKE ih_inv_date.
                    DEFINE INPUT PARAMETER eff_dt LIKE gltr_eff_dt.
                    DEFINE INPUT PARAMETER eff_dt1 LIKE gltr_eff_dt.
                    DEFINE INPUT PARAMETER entity LIKE gltr_entity.
                    DEFINE INPUT PARAMETER entity1 LIKE gltr_entity.
                     /* SS - Bill - E */

/*K0LH*/ {wbrp02.i}

/*H536*/ define new shared variable undo_txdetrp like mfc_logical.

/*J053*/ define shared variable rndmthd like rnd_rnd_mthd.
/*J053*/ define shared variable oldcurr like ih_curr.
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
/*G1P6*                                   format "x(4)" initial "Base". */
         define shared variable disp_curr as character format "x(1)" label "C".
         define shared variable ih_recno as recid.
         define shared variable tot_trl1 like ih_trl1_amt.
         define shared variable tot_trl3 like ih_trl3_amt.
         define shared variable tot_trl2 like ih_trl2_amt.
/*G0CR*/ define variable base_trl1 like ih_trl1_amt.
/*G0CR*/ define variable base_trl3 like ih_trl3_amt.
/*G0CR*/ define variable base_trl2 like ih_trl2_amt.
/*G0CR*/ define variable base_disc like ih_trl1_amt label {&soivrp9a_p_4}.
/*G0CR*/ define variable base_tot_tax like ih_trl2_amt label {&soivrp9a_p_8}.
/*G0CR*/ define variable base_ord_amt like ih_trl3_amt label {&soivrp9a_p_7}.
         define shared variable tot_disc like ih_trl1_amt label {&soivrp9a_p_4}.
         define shared variable rpt_tot_tax like ih_trl2_amt
                                          label {&soivrp9a_p_8}.
         define shared variable tot_ord_amt like ih_trl3_amt label {&soivrp9a_p_7}.
         define shared variable net_price like idh_price.
         define shared variable base_net_price like net_price.
         define shared variable detail_lines like mfc_logical.
         define shared variable bill  like ih_bill.
         define shared variable bill1 like ih_bill.
/*GK02*/ define variable  currdisp  like so_curr.
/*H536*/ define new shared variable col-80      like mfc_logical initial false.
/*H536*/ define variable tax_total   like tx2d_totamt.
/*G0F0** /*G09W*/ define new shared variable invoice_nbr like ih_inv_nbr.
.        /*G09W*/ define new shared variable calc_inv like mfc_logical. **/
/*J053*/ define variable disprnd like rnd_rnd_mthd.
/*J053*/ define variable tot_price like ext_price no-undo.
/*J053*/ define variable tot_margin like ext_gr_margin no-undo.
/*J053*/ define variable tot_marg_fmt as character no-undo.
/*J053*/ define variable tot_price_fmt as character no-undo.
/*J053*/ define variable tot_trl_fmt as character no-undo.
/*J053*/ define variable tot_tax_fmt as character no-undo.
/*J053*/ define variable tot_disc_fmt as character no-undo.
/*J053*/ define variable tot_ord_fmt as character no-undo.
/*J053*/ define variable base_price_fmt as character no-undo.
/*J053*/ define variable base_price_old as character no-undo.
/*J053*/ define variable base_marg_fmt as character no-undo.
/*J053*/ define variable base_marg_old as character no-undo.
/*J053*/ define variable oldsession as character no-undo.
/*J053*/ define variable tmpamt as decimal no-undo.

/*L024*/ define variable v_disp_line1    as   character format "x(40)"
/*L024*/                                        label {&soivrp9a_p_11} no-undo.
/*L024*/ define variable v_disp_line2    as   character format "x(40)" no-undo.
/*L024*/ define variable v_cust_po       as   character format "x(31)" no-undo.
/*L024*/ define variable v_cust_po_label as   character                no-undo.
/*M0HV*/ define variable l_qty_call      like idh_qty_ord              no-undo.

/*J053*         {mfsotrla.i } */
/*J053*/ {mfivtrla.i "NEW"}

         {soivtot1.i }  /* Define variables for invoice totals. */
/*GN40*  {mfdtitle.i "0+ "} */
/*L00L*/ {etdcrvar.i new}
/*L00L*/ {etvar.i &new = new}
/*L00L*/ {etrpvar.i &new = new}
/*J360*/ {etihtfrm.i}

/*J053* DEFINE FORMS USED FOR THE DISPLAYS                      */
/*J053*/ form
/*J053*/   tot_margin label {&soivrp9a_p_1}
/*J053*/   tot_price label {&soivrp9a_p_3}
/*J053*/   tot_disc
/*J053*/   tot_trl1
/*J053*/   tot_trl2
/*J053*/   tot_trl3
/*J053*/   rpt_tot_tax
/*J053*/   tot_ord_amt
/*J053*/ with frame d side-labels 3 columns width 132.

/*L024*/ define frame b
/*L024*/    ih_inv_nbr
/*L024*/    ih_rev
/*L024*/    v_cust_po
/*L024*/    ih_ship
/*L024*/    ih_ship_date
/*L024*/    ih_inv_date
/*L024*/    ih_slspsn[1]
/*L024*/    ih_curr
/*L024*/    v_disp_line1
/*L024*/ with down width 132 no-box.

/*L024*/ assign
/*L024*/    substring(v_cust_po_label, 1) = {&soivrp9a_p_9}
/*L024*/    substring(v_cust_po_label, 9) = " " + {&soivrp9a_p_10}
/*L024*/    v_cust_po:LABEL in frame b    = v_cust_po_label.

/*J053*/ form
/*J053*/   idh_nbr
/*J053*/   idh_line
/*J053*/   idh_part
/*J053*/   idh_um
/*M0HV** /*J053*/ idh_qty_ord */
/*M0HV*/   idh_qty_ord column-label {&soivrp9a_p_12}
/*J053*/   idh_qty_inv
/*J053*/   idh_bo_chg
/*J053*/   disp_curr
/*J053*/   idh_price
/*J053*/   base_price
/*J053*/   base_margin
/*J053*/ with frame c width 132 down.

/*J053*/ /* ASSIGN ORIGINAL FORMAT TO _OLD VARIABLES */
/*J053*/ assign
/*J053*/   nontax_old     = nontaxable_amt:format
/*J053*/   taxable_old    = taxable_amt:format
/*J053*/   line_tot_old   = line_total:format
/*J053*/   line_pst_old   = line_pst:format
/*J053*/   disc_old       = disc_amt:format
/*J053*/   trl_amt_old    = ih_trl1_amt:format
/*J053*/   tax_amt_old    = tax_amt:format
/*J053*/   tot_pst_old    = total_pst:format
/*J053*/   tax_old        = tax[1]:format
/*J053*/   amt_old        = amt[1]:format
/*J053*/   ord_amt_old    = ord_amt:format
/*J053*/   base_price_old = base_price:format
/*J053*/   base_marg_old  = base_margin:format.

/*J053*/ oldcurr = "".
         maint = no.

/*J053**** TRAILER FORMS DEFINE IN MFIVTRLA.I ****************************
*         /*Define trailer forms */
*         if gl_can then do:
*            {ctivtrfm.i}
*         end.
*         else do:
*            {soivtrfm.i}
*         end.
*J053**** TRAILER FORMS DEFINE IN MFIVTRLA.I *****************************/

/*J053*/ oldsession = SESSION:numeric-format.
         /* SS - Bill - B 2005.07.05 */
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
                 /*
         for each ih_hist where (ih_inv_nbr >= inv) and (ih_inv_nbr <= inv1)
             */
         for each ih_hist where (ih_inv_nbr = gltr_doc)
                 /* SS - Bill - E */
         and (ih_nbr >= nbr) and (ih_nbr <= nbr1)
         and (ih_cust >= cust) and (ih_cust <= cust1)
         and (ih_bill >= bill and ih_bill <= bill1)
         and (ih_slspsn[1] >= spsn) and (ih_slspsn[1] <= spsn1)
/*J2BP** and (ih_po >= po) and (ih_po <= po1)    */
/*J2BP*/ and (ih_sched or ((ih_po >= po) and (ih_po <= po1)))
/*G1P6*  and (base_rpt = "Base" */
/*G1P6*/ and (base_rpt = ""
         or ih_curr = base_rpt)
             /* SS - Bill - B 2005.07.01 */
             AND ih_inv_date >= inv_date
             AND ih_inv_date <= inv_date1
             /* SS - Bill - E */
         no-lock break by ih_inv_nbr with frame c down width 132.

/*J2BP*/  /* IF NO DETAIL RECORD EXIST THEN PRINT THE HEADER AND TRAILER  */
/*J2BP*/  /* AS BEFORE; IF ANY DETAIL HISTORY RECORDS EXIST THEN AT LEAST */
/*J2BP*/  /* ONE OF THE DETAIL RECORD SHOULD QUALITY THE SELECTION        */
/*J2BP*/  /* CRITERIA HAVING po NUMBER TO PRINT THE HEADER AND TRAILER.   */

/*J2BP*/  if can-find (first idh_hist where idh_inv_nbr = ih_inv_nbr and
/*J2BP*/                                    idh_nbr     = ih_nbr)    and
/*J2BP*/  not can-find (first idh_hist where idh_nbr = ih_nbr
/*J2BP*/                           and idh_inv_nbr = ih_inv_nbr
/*J2BP*/                           and ((idh_contr_id >= po) and
/*J2BP*/                                (idh_contr_id <= po1)))
/*J2BP*/  then next.


/*J053*/ /* SET ROUND METHOD TO BASE AND FORMATS */
/*J0ZZ************* REPLACE BY GPCURMTH.I ***********************************
** /*J053*/ if (oldcurr <> ih_curr) then do:
** /*J053*/    /* DETERMINE ROUNDING METHOD FROM DOCUMENT CURRENCY OR BASE    */
** /*J053*/    if (gl_base_curr <> ih_curr) then do:
** /*J053*/       find first ex_mstr where ex_curr = ih_curr no-lock no-error.
** /*J053*/       if not available ex_mstr then do:
** /*J053*           CURRENCY EXCHANGE MASTER DOES NOT EXIST              */
** /*J053*/          {mfmsg.i 964 4}
** /*J053*/          next.
** /*J053*/       end.
** /*J053*/       rndmthd = ex_rnd_mthd.
** /*J053*/    end.
** /*J053*/    else rndmthd = gl_rnd_mthd.
**J0ZZ***********************************************************************/

/*J0ZZ*/    if (oldcurr <> ih_curr) or (oldcurr = "") then do:
/*L024* /*J0ZZ*/       {gpcurmth.i          */
/*L024*             "ih_curr"               */
/*L024*            "4"                      */
/*L024*     "next"                          */
/*L024*     "pause" }                       */

/*L024*/      {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                  "(input  ih_curr,
                    output rndmthd,
                     output mc-error-number)" }
/*L024*/      if mc-error-number <> 0 then do:
/*L024*/         {mfmsg.i mc-error-number 2}
/*L024*/      end.

/*J053*        DETERMINE CURRENCY DISPLAY AMERICAN OR EUROPEAN               */
/*J053*/       find rnd_mstr where rnd_rnd_mthd = rndmthd no-lock no-error.
/*J053*/       if not available rnd_mstr then do:
/*J053*/          {mfmsg.i 863 4}    /* ROUND METHOD RECORD NOT FOUND */
/*J053*/          next.
/*J053*/       end.
/*J053*/       /* SET ONLY IF BASE_RPT <> BASE */
/*G1P6*        *J053* if base_rpt <> "Base" */
/*G1P6*/       if base_rpt <> ""
/*J053*/       then do:
/*J053*/          /* IF RND_DEC_PT EQUAL COMMA, THEN DECIMAL POINT IS COMMA*/
/*J053*/          /* THIS IS INDICATED BY THE EUROPEAN FORMAT CURRENCY */
/*J053*/          if (rnd_dec_pt = ",")
/*J053*/          then SESSION:numeric-format = "European".
/*J053*/          else SESSION:numeric-format = "American".
/*J053*/       end.
/*J053*/    end. /* IF (OLDCURR <> IH_CURR */

/*G1P6*     *J053* if base_rpt = "Base" */
/*G1P6*/    if base_rpt = ""
/*J053*/    then disprnd = gl_rnd_mthd.
/*J053*/    else disprnd = rndmthd.

/*J053*/    /* SET FORMATS HERE BASE ON OLDCUR AND IH_CURR USING DISPRND*/
/*J053*/    if (oldcurr <> ih_curr)
/*J13P*/       or (oldcurr = "") then do:
/*J053*/       {soivcfmt.i}
/*J053*/       /* SET BASE_PRICE FORMAT */
/*J053*/       base_price_fmt = base_price_old.
/*J053*/       {gprun.i ""gpcurfmt.p"" "(input-output base_price_fmt,
                                         input disprnd)"}

/*J053*/       /* SET BASE_MARGIN FORMAT */
/*J053*/       base_marg_fmt = base_marg_old.
/*J053*/       {gprun.i ""gpcurfmt.p"" "(input-output base_marg_fmt,
                                    input disprnd)"}

/*J053*/       oldcurr = ih_curr.
/*J053*/    end. /* IF (OLDCURR <> IH_CURR) */

            ih_recno = recid(ih_hist).
            name = "".
            find ad_mstr where ad_addr = ih_cust no-lock no-wait no-error.
            if available ad_mstr then name = ad_name.

            if page-size - line-counter < 3 then page.
            if first-of(ih_inv_nbr) then do:
/*L024*/       assign
/*L024*/          v_cust_po               = ""
/*L024*/          substring(v_cust_po, 1) = ih_cust
/*L024*/          substring(v_cust_po, 9) = " " + ih_po.

/*L024*/       {gprunp.i "mcui" "p" "mc-ex-rate-output"
                 "(input ih_curr,
                   input base_curr,
                   input ih_ex_rate,
                   input ih_ex_rate2,
                   input ih_exru_seq,
                   output v_disp_line1,
                   output v_disp_line2)"}

    /* SS - Bill - B 2005.06.30 */
    /*
               display ih_inv_nbr
                       ih_rev
/*L024*                ih_cust name ih_po ih_ship ih_ship_date  */
/*L024*/               v_cust_po ih_ship ih_ship_date
                       ih_inv_date ih_slspsn[1] ih_curr
/*L024*/               v_disp_line1
               with frame b down width 132.
               */

/*L024*        if ih_slspsn[2] <> "" or ih_ex_rate <>  1 then do with frame b:  */
/*L024*           if ih_ex_rate <> 1  */
/*L024*           then display ih_ent_ex  @ ih_curr.        */

               /*
/*L024*/       if name <> "" or ih_slspsn[2] <> "" or
/*L024*/          v_disp_line2 <> "" then do with frame b:
                  down 1.
                  display
/*L024*/             name         @ v_cust_po
                     ih_slspsn[2] @ ih_slspsn[1]
/*L024*/             v_disp_line2 @ v_disp_line1.
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
               */
               /* SS - Bill - E */

               {soivtot2.i}  /* Initialize variables for invoice totals. */

            end.  /* Header display */

            /* GET INVOICE HISTORY DETAIL */
            detail_lines = no.
            for each idh_hist where idh_inv_nbr = ih_inv_nbr
/*J2BP**    and idh_nbr     = ih_nbr     no-lock   */
/*J2BP*/    and idh_nbr     = ih_nbr
/*J2BP*/    and (not ih_sched
/*J2BP*/     or ((idh_contr_id >= po) and (idh_contr_id <= po1)))
/*J2BP*/    no-lock
            break by idh_inv_nbr
            by idh_nbr
            by idh_line with no-box frame c width 132:

               net_price = idh_price.
               if (gl_can or gl_vat) and idh_tax_in then do:
                  find last vt_mstr where vt_class = idh_taxc
                  and vt_start <= ih_tax_date and vt_end >= ih_tax_date
                  no-lock no-error.
                  if not available vt_mstr then find last vt_mstr where
                  vt_class = idh_taxc no-lock no-error.
                  if available vt_mstr then
/*J053*                  net_price = ROUND(net_price * 100 / (100 + vt_tax_pct),2). */
/*J053* SHOULD NOT BE ROUNDING NET_PRICE, IT IS NOT AN EXTENDED AMOUNT       */
/*J053*/          net_price = net_price * 100 / (100 + vt_tax_pct).
               end.
               ext_price = net_price * idh_qty_inv.
/*J053*/       /* ROUND PER DOCUMENT CURRENCY */
/*L024* /*J053*/       {gprun.i ""gpcurrnd.p"" "(input-output ext_price, */
/*L024*                                  input rndmthd)"}               */

/*L024*/        {gprunp.i "mcpl" "p" "mc-curr-rnd"
                     "(input-output ext_price,
                       input        rndmthd,
                       output       mc-error-number)" }
/*L024*/        if mc-error-number <> 0 then do:
/*L024*/             {mfmsg.i mc-error-number 2}
/*L024*/        end.


               /*CONVERT STD COST TO FOREIGN CURR TO CALC MARGIN*/

/*J053** IT WAS DETERMINED THAT THE MOST ACCURATE WAY TO PERFORM CONVERSIONS */
/*j053** FROM BASE TO FOREIGN OR FOREIGN TO BASE WAS TO CALCULATE THE        */
/*J053** EXTENDED AMOUNT, ROUND IT, THEN CONVERT IT AND ROUND IT AGAIN.      */

/*J053*/       /* CONVERT COST (STORED IN BASE) TO DOC CURRENCY IN ORDER TO  */
/*J053*/       /* CALCULATE THE GROSS MARGIN.  DO NOT ROUND THE UNIT COST.   */
/*L024*        curr_cost = idh_std_cost.     */

               if base_curr <> ih_curr
/*L024*/       then do:
/*L024*        then curr_cost = curr_cost * ih_ex_rate.  */

/*L024*/          {gprunp.i "mcpl" "p" "mc-curr-conv"
                   "(input  base_curr,
                     input  ih_curr,
                     input  ih_ex_rate2,
                     input  ih_ex_rate,
                     input  idh_std_cost,
                     input  false,  /* DO NOT ROUND */
                     output curr_cost,
                     output mc-error-number)" }
/*L024*/          if mc-error-number <> 0 then do:
/*L024*/              {mfmsg.i mc-error-number 2}
/*L024*/          end.
/*L024*/       end.
/*L0DH*/       else assign curr_cost = idh_std_cost.

                    gr_margin = net_price - curr_cost.
                    ext_gr_margin = idh_qty_inv * gr_margin.

/*J053*/       /* ROUND EXT_GR_MARGIN USING DOC CURRENCY ROUNDING METHOD   */
/*L024* /*J053*/       {gprun.i ""gpcurrnd.p"" "(input-output ext_gr_margin,*/
/*L024*                                    input rndmthd)"}     */
/*L024*/          {gprunp.i "mcpl" "p" "mc-curr-rnd"
                     "(input-output ext_gr_margin,
                       input        rndmthd,
                       output       mc-error-number)" }
/*L024*/          if mc-error-number <> 0 then do:
/*L024*/             {mfmsg.i mc-error-number 2}
/*L024*/          end.

               /* THESE AMOUNTS ARE ALL IN DOC CURRENCY                      */
               base_net_price = net_price.
               base_price = ext_price.
               base_margin = ext_gr_margin.
/*J053*/       /* IF BASE IS NOT DOC CURRENCY AND RPT IS IN BASE THEN CONVERT*/
/*J053*/       /* THE NET_PRICE, PRICE, AND MARGIN TO BASE.                  */
               if base_curr <> ih_curr
/*G1P6*        and base_rpt = "Base" */
/*G1P6*/       and base_rpt = ""
               then do:
/*L024*           base_net_price = base_net_price / ih_ex_rate.*/

/*L024*/          {gprunp.i "mcpl" "p" "mc-curr-conv"
                    "(input  ih_curr,
                      input  base_curr,
                      input  ih_ex_rate,
                      input  ih_ex_rate2,
                      input  base_net_price,
                      input  false,  /* DO NOT ROUND */
                      output base_net_price,
                      output mc-error-number)" }
/*L024*/          if mc-error-number <> 0 then do:
/*L024*/             {mfmsg.i mc-error-number 2}
/*L024*/          end.

/*J053*           base_price = round(base_price / ih_ex_rate,gl_ex_round).   */
/*L024* /*J053*/  base_price = base_price / ih_ex_rate.  */
/*L024*/          {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input  ih_curr,
                       input  base_curr,
                       input  ih_ex_rate,
                       input  ih_ex_rate2,
                       input  base_price,
                       input  true,  /* ROUND */
                       output base_price,
                       output mc-error-number)" }
/*L024*/          if mc-error-number <> 0 then do:
/*L024*/               {mfmsg.i mc-error-number 2}
/*L024*/          end.

/*J053*/          /* ROUND PER BASE CURR ROUND METHOD */
/*L024* /*J053*/  {gprun.i ""gpcurrnd.p"" "(input-output base_price, */
/*L024*                                     input gl_rnd_mthd)"} */

/*J053*           base_margin = round(base_margin / ih_ex_rate,gl_ex_round).  */
/*L024* /*J053*/  base_margin = base_margin / ih_ex_rate.  */
/*L024*/          {gprunp.i "mcpl" "p" "mc-curr-conv"
                    "(input  ih_curr,
                      input  base_curr,
                      input  ih_ex_rate,
                      input  ih_ex_rate2,
                      input  base_margin,
                      input  true,  /* ROUND */
                      output base_margin,
                      output mc-error-number)" }
/*L024*/          if mc-error-number <> 0 then do:
/*L024*/             {mfmsg.i mc-error-number 2}
/*L024*/          end.

/*L024*  /*J053*/ /* ROUND PER BASE CURR ROUND METHOD */  */
/*L024*  /*J053*/ {gprun.i ""gpcurrnd.p"" "(input-output base_margin, */
/*L024*                                     input gl_rnd_mthd)"}  */

/*GK02*/          currdisp  = base_curr.
               end.
/*GK02*/       else currdisp = ih_curr.

               accumulate (base_price) (total by idh_inv_nbr).
               accumulate (base_margin) (total by idh_inv_nbr).

               desc1 = "".
               find pt_mstr where pt_part = idh_part no-lock no-wait no-error.
               if available pt_mstr then desc1 = pt_desc1 + " " + pt_desc2.


/*J053*/       base_price:format = base_price_fmt.
/*J053*/       base_margin:format = base_marg_fmt.

/*M0HV*/       if ih_fsm_type = "FSM-RO"
/*M0HV*/       then do:

/*M0HV*/           assign
/*M0HV*/               l_qty_call = 0
/*M0HV*/               idh_qty_ord:label = {&soivrp9a_p_13}.

/*M0HV*/           for first itm_det
/*M0HV*/              fields(itm_nbr itm_line itm_part itm_qty_call)
/*M0HV*/              where itm_nbr = idh_nbr
/*M0HV*/              and   itm_line = idh_line
/*M0HV*/              and   itm_part = idh_part
/*M0HV*/              no-lock:
/*M0HV*/           end. /* FOR FIRST itm_det */

/*M0HV*/           if available itm_det
/*M0HV*/           then
/*M0HV*/              l_qty_call = itm_qty_call.

/*M0HV*/           else do:

/*M0HV*/               for first itmh_hist
/*M0HV*/                  fields(itmh_nbr itmh_line itmh_part itmh_qty_call)
/*M0HV*/                  where itmh_nbr = idh_nbr
/*M0HV*/                  and   itmh_line = idh_line
/*M0HV*/                  and   itmh_part = idh_part
/*M0HV*/                  no-lock:
/*M0HV*/               end. /* FOR FIRST itmh_hist */

/*M0HV*/               if available itmh_hist
/*M0HV*/               then
/*M0HV*/                  l_qty_call = itmh_qty_call.

/*M0HV*/           end. /* ELSE DO */

/*M0HV*/       end. /* IF ih_fsm_type = "FSM-RO" */

/*M0HV*/       else
/*M0HV*/          idh_qty_ord:label = {&soivrp9a_p_12}.

                  /* SS - Bill - B 2005.06.30 */
                  /*
               display
                      idh_nbr
/*M0HV**              idh_line idh_part idh_um idh_qty_ord idh_qty_inv */
/*M0HV*/              idh_line
/*M0HV*/              idh_part
/*M0HV*/              idh_um
/*M0HV*/              idh_qty_ord when (ih_fsm_type <> "FSM-RO")
/*M0HV*/              l_qty_call  when (ih_fsm_type =  "FSM-RO") @ idh_qty_ord
/*M0HV*/              idh_qty_inv when (ih_fsm_type <> "FSM-RO")
/*M0HV*/              l_qty_call  when (ih_fsm_type =  "FSM-RO") @ idh_qty_inv
/*J053*/       with frame c.

/*M0HV*/       if ih_fsm_type <> "FSM-RO"
/*M0HV*/       then do:
                  if idh_qty_ord >= 0 then /* show bo regardless of sign */
                     display max(idh_qty_ord - idh_qty_ship, 0) @ idh_bo_chg
/*J053*/             with frame c.
                  else
                     display min(idh_qty_ord - idh_qty_ship, 0) @ idh_bo_chg
/*J053*/             with frame c.
/*M0HV*/       end. /* IF ih_fsm_type <> "FSM-RO" */
/*M0HV*/       else
/*M0HV*/         display "" @ idh_bo_chg with frame c.

               display
                      disp_curr
                      base_net_price @
                      idh_price base_price base_margin
                      idh_due_date idh_type
/*J053*/       with frame c.
               */
               /* SS - Bill - E */
               detail_lines = yes.

               /* SS - Bill - B 2005.06.30 */
               /*
/*J2BP*/       if not ih_sched then
                  put desc1 at 6 skip.
/*J2BP*/       else
/*J2BP*/           put desc1 at 6
/*J2BP*/          {&soivrp9a_p_5} at 57
/*J2BP*/          idh_contr_id      at 73 skip.
*/
/* SS - Bill - E */


/* SS - Bill - B 2005.06.30 */
/*J360*/          /* REPLACED OUTPUT PARAMETER TAX_TOTAL WITH TAX_AMT */
/*G0CR*/          {gprun.i  ""txtotal.p"" "(input '16',
                                            input ih_inv_nbr,
                                            input ih_nbr,
                                            input idh_line,
                                            output tax_amt)" }

/*J38T*/          /* OBTAINING TOTAL INCLUDED TAX FOR THE TRANSACTION */
/*J38T*/          {gprun.i ""txtotal1.p"" "(input '16',
                                            input  ih_inv_nbr,
                                            input  ih_nbr,
                                            input  idh_line,
                                            output l_tax_in)"}
    
CREATE wfidh.
ASSIGN
    wfidh_inv_nbr = ih_inv_nbr
    wfidh_nbr = ih_nbr
    wfidh_line = idh_line
    wfidh_cust = ih_cust
    wfidh_part = idh_part
    wfidh_prodline = idh_prodline
    wfidh_qty_inv = idh_qty_inv
    wfidh_ext_price = ext_price
    wfidh_ext_gr_margin = ext_gr_margin
    wfidh_ext_tax_amt = tax_amt + l_tax_in
    wfidh_base_price = base_price
    wfidh_base_margin = base_margin
    wfidh_base_tax_amt = tax_amt + l_tax_in
    wfidh_cc = idh_cc
    wfidh_acct = idh_acct
    .

FIND pl_mstr WHERE pl_prod_line = wfidh_prodline NO-LOCK NO-ERROR.
IF AVAILABLE pl_mstr THEN DO:
    ASSIGN
        wfidh_pl_desc = pl_desc
        wfidh_pl__chr01 = pl__chr01
        wfidh_pl__chr01_cmmt = pl__chr01
        wfidh_pl__chr02 = pl__chr02
        wfidh_pl__chr02_cmmt = pl__chr02
        .
    FIND FIRST CODE_mstr
        WHERE CODE_fldname = 'pl__chr01'
        AND CODE_value = pl__chr01
        NO-LOCK 
        NO-ERROR.
    IF AVAILABLE CODE_mstr THEN
        wfidh_pl__chr01_cmmt = CODE_cmmt.
    FIND FIRST CODE_mstr
        WHERE CODE_fldname = 'pl__chr02'
        AND CODE_value = pl__chr02
        NO-LOCK 
        NO-ERROR.
    IF AVAILABLE CODE_mstr THEN
        wfidh_pl__chr02_cmmt = CODE_cmmt.
END.
ELSE DO:
    ASSIGN
        wfidh_pl_desc = '找不到产品类'
        wfidh_pl__chr01 = ''
        wfidh_pl__chr01_cmmt = '找不到大类'
        wfidh_pl__chr02 = ''
        wfidh_pl__chr02_cmmt = '找不到小类'
        .
END.

FIND cc_mstr WHERE cc_ctr = wfidh_cc NO-LOCK NO-ERROR.
IF AVAILABLE cc_mstr THEN DO:
    ASSIGN
        wfidh_cc_desc = cc_desc
        wfidh_cc_user1 = cc_user1
        wfidh_cc_user1_cmmt = cc_user1
        wfidh_cc_user2 = cc_user2
        wfidh_cc_user2_cmmt = cc_user2
        wfidh_cc__qadc01 = cc__qadc01
        wfidh_cc__qadc01_cmmt = cc__qadc01
        .

    FIND FIRST CODE_mstr
        WHERE CODE_fldname = 'cc_user1'
        AND CODE_value = cc_user1
        NO-LOCK 
        NO-ERROR.
    IF AVAILABLE CODE_mstr THEN
        wfidh_cc_user1_cmmt = CODE_cmmt.
    
    FIND FIRST CODE_mstr
        WHERE CODE_fldname = 'cc_user2'
        AND CODE_value = cc_user2
        NO-LOCK 
        NO-ERROR.
    IF AVAILABLE CODE_mstr THEN
        wfidh_cc_user2_cmmt = CODE_cmmt.
    
    FIND FIRST CODE_mstr
        WHERE CODE_fldname = 'cc__qadc01'
        AND CODE_value = cc__qadc01
        NO-LOCK 
        NO-ERROR.
    IF AVAILABLE CODE_mstr THEN
        wfidh_cc__qadc01_cmmt = CODE_cmmt.
END.
ELSE DO:
    ASSIGN
        wfidh_cc_desc = '找不到成本中心'
        wfidh_cc_user1 = ''
        wfidh_cc_user1_cmmt = '找不到渠道'
        wfidh_cc_user2 = ''
        wfidh_cc_user2_cmmt = '找不到区域'
        wfidh_cc__qadc01 = ''
        wfidh_cc__qadc01_cmmt = '找不到办事处'
        .
END.

FIND cm_mstr WHERE cm_addr = wfidh_cust NO-LOCK NO-ERROR.
IF AVAILABLE cm_mstr THEN DO:
    ASSIGN
        wfidh_cm_region = cm_region
        wfidh_cm_region_cmmt = cm_region
        .

    FIND FIRST CODE_mstr
        WHERE CODE_fldname = 'cm_region'
        AND CODE_value = cm_region
        NO-LOCK 
        NO-ERROR.
    IF AVAILABLE CODE_mstr THEN
        wfidh_cm_region_cmmt = CODE_cmmt.
END.
ELSE DO:
    ASSIGN
        wfidh_cm_region = ''
        wfidh_cm_region_cmmt = '找不到区域'
        .
END.
/*L024*/          {gprunp.i "mcpl" "p" "mc-curr-conv"
                    "(input  ih_curr,
                      input  base_curr,
                      input  ih_ex_rate,
                      input  ih_ex_rate2,
                      input  wfidh_ext_tax_amt,
                      input  false,  /* DO NOT ROUND */
                      output wfidh_base_tax_amt,
                      output mc-error-number)" }
/*L024*/          if mc-error-number <> 0 then do:
/*L024*/             {mfmsg.i mc-error-number 2}
/*L024*/          end.
/* SS - Bill - E */


/*G0CR*** MOVED OUTSIDE OF DETAIL LOOP **
.              if last-of(idh_inv_nbr) then do:
.
.                 /* Total invoice including taxes */
./*H536*/          if {txnew.i} then do:
./*H536*/             undo_txdetrp = true.
./*H536*/             {gprun.i  ""txdetrp.p"" "(input '16',
.                                               input ih_inv_nbr,
.                                               input '*',
.                                               input col-80,
.                                               input 0)" }
.
./*H536*/             {gprun.i  ""txtotal.p"" "(input '16',
.                                               input ih_inv_nbr,
.                                               input '*',
.                                               input 0,
.                                               output tax_total)" }
.
./*H536*/             rpt_tot_tax = rpt_tot_tax + tax_total.
.
.                     {gprun.i ""soihtrl2.p""}
./*H536*/          end.
./*H536*/          else do:
.                     {gprun.i ""soivhtrl.p""}
./*H536*/          end.
.                  {mfrpexit.i "false"}
.
.                  {soivtot5.i}  /* Accumulate invoice totals */
.
.               end. /* last-of(idh_inv... */
**G0CR*** END MOVED SECTION **/

               {mfrpexit.i "false"}

            end. /* for each idh_hist */

               /* SS - Bill - B 2005.06.30 */
               /*
/*J360*/    if {txnew.i} and
/*J360*/       not last-of(ih_inv_nbr) then do :
/*J360*/       {gprun.i ""soihtrl2.p""}
/*J360*/       /* ACCUMULATE TRAILER TOTALS BY USING SOIVTOT9.I */
/*J360*/       run p-acc-totals (buffer ih_hist,
                                 input-output invtot_nontaxable_amt,
                                 input-output invtot_taxable_amt,
                                 input-output invtot_line_total,
                                 input-output invtot_disc_amt,
                                 input-output invtot_trl1_amt,
                                 input-output invtot_trl2_amt,
                                 input-output invtot_trl3_amt,
                                 input-output invtot_tax_amt,
                                 input-output invtot_ord_amt) .
/*J360*/    end. /* IF {TXNEW.I} AND NOT LAST-OF(IH_INV_NBR) */

            /* Total invoice including taxes */
/*G0CR*/    if {txnew.i} then do:
/*J360*/       if last-of(ih_inv_nbr) then do :
/*G0CR*/          undo_txdetrp = true.

/*M0DM**          ** BEGIN DELETE **
 * /*J360*/       /* REPLACED OUTPUT PARAMETER TAX_TOTAL WITH TAX_AMT */
 * /*G0CR*/       {gprun.i  ""txdetrp.p"" "(input '16',
 *                                          input ih_inv_nbr,
 *                                          input '*',
 *                                          input col-80,
 *                                          input 0)" }
 *M0DM**          ** END DELETE */

/*M0DM*/          /* CHANGED TXDETRP.P TO TXDETRP2.P TO FACILITATE PRINTING */
/*M0DM*/          /* OF TAX LINE DETAILS IN THE REPORTING CURRENCY          */
/*M0DM*/          {gprun.i ""txdetrp2.p"" "(input '16',
                                            input ih_inv_nbr,
                                            input '*',
                                            input ih_curr,
                                            input ih_ex_rate,
                                            input ih_ex_rate2,
                                            input col-80,
                                            input 0)" }

/*J360*/          /* REPLACED OUTPUT PARAMETER TAX_TOTAL WITH TAX_AMT */
/*G0CR*/          {gprun.i  ""txtotal.p"" "(input '16',
                                            input ih_inv_nbr,
                                            input '*',
                                            input 0,
                                            output tax_amt)" }

/*J38T*/          /* OBTAINING TOTAL INCLUDED TAX FOR THE TRANSACTION */
/*J38T*/          {gprun.i ""txtotal1.p"" "(input '16',
                                            input  ih_inv_nbr,
                                            input  '*',
                                            input  0,
                                            output l_tax_in)"}

/*G0CR*/          {gprun.i ""soihtrl2.p""}
/*J38T*/          /* ADJUSTING TOTAL TAX AMOUNT BY INCLUDED TAX */
/*J360*/          assign
/*J38T*/             tax_amt = tax_amt + l_tax_in
/*J38T*/             l_tax_in = 0
/*J360*/             ord_amt = ord_amt + tax_amt.
/*J360*/          /* ACCUMULATE TRAILER TOTALS USING SOIVTOT9.I */
/*J360*/          run p-acc-totals (buffer ih_hist,
                                    input-output invtot_nontaxable_amt,
                                    input-output invtot_taxable_amt,
                                    input-output invtot_line_total,
                                    input-output invtot_disc_amt,
                                    input-output invtot_trl1_amt,
                                    input-output invtot_trl2_amt,
                                    input-output invtot_trl3_amt,
                                    input-output invtot_tax_amt,
                                    input-output invtot_ord_amt) .

/*G0CR*/          /* COVERT TO BASE FOR REPORT TOTALS */
/*J360** BEGIN DELETE **
 * /*G0CR*/       base_trl1 = ih_trl1_amt.
 * /*G0CR*/       base_trl2 = ih_trl2_amt.
 * /*G0CR*/       base_trl3 = ih_trl3_amt.
 * /*G0CR*/       base_disc = disc_amt.
 * /*G0CR*/       base_tot_tax = tax_amt.
 * /*G0CR*/       base_ord_amt = ord_amt.
 *J360** END DELETE */

/*J360*/          assign
/*J360*/             base_trl1    = invtot_trl1_amt
/*J360*/             base_trl2    = invtot_trl2_amt
/*J360*/             base_trl3    = invtot_trl3_amt
/*J360*/             base_disc    = invtot_disc_amt
/*J360*/             base_tot_tax = invtot_tax_amt
/*J360*/             base_ord_amt = invtot_ord_amt.

/*J053*/          /* IF REPORT IS DESIRED IN BASE AND DOC CURRENCY IS NOT */
/*J053*/          /* BASE THEN CONVERT THE ROUNDED AMOUNTS TO BASE AND ROUND */
/*G1P6*        *G0CR* if base_rpt = "Base" */
/*G1P6*/          if base_rpt = ""
/*G0CR*/          and ih_curr <> base_curr then do:
/*J053* /*G0CR*/  base_trl1 = round(base_trl1 / ih_ex_rate,gl_ex_round). */
/*J053* /*G0CR*/  base_trl2 = round(base_trl2 / ih_ex_rate,gl_ex_round). */
/*J053* /*G0CR*/  base_trl3 = round(base_trl3 / ih_ex_rate,gl_ex_round). */
/*J053* /*G0CR*/  base_disc = round(base_disc / ih_ex_rate,gl_ex_round). */
/*L024* /*J053*/  base_trl1 = base_trl1 / ih_ex_rate. */

/*M0DM*/             /* COMMENTED CODE BELOW SINCE THE REPORT VARIABLES ARE */
/*M0DM*/             /* ALREADY CONVERTED TO BASE CURRENCY BY CALL TO       */
/*M0DM*/             /* SOIVTOT9.I ABOVE                                    */

/*M0DM**             ** BEGIN DELETE **
 * /*L024*/          {gprunp.i "mcpl" "p" "mc-curr-conv"
 *                       "(input  ih_curr,
 *                         input  base_curr,
 *                         input  ih_ex_rate,
 *                         input  ih_ex_rate2,
 *                         input  base_trl1,
 *                         input  true,  /* ROUND */
 *                         output base_trl1,
 *                         output mc-error-number)" }
 * /*L024*/          if mc-error-number <> 0 then do:
 * /*L024*/             {mfmsg.i mc-error-number 2}
 * /*L024*/          end.
 * /*J053*/             /* ROUND PER BASE CURR ROUND METHOD */

 * /*L024* /*J053*/  {gprun.i ""gpcurrnd.p"" "(input-output base_trl1,*/
 * /*L024*                                     input gl_rnd_mthd)"} */

 * /*L024* /*J053*/  base_trl2 = base_trl2 / ih_ex_rate. */
 * /*L024*/          {gprunp.i "mcpl" "p" "mc-curr-conv"
 *                       "(input  ih_curr,
 *                         input  base_curr,
 *                         input  ih_ex_rate,
 *                         input  ih_ex_rate2,
 *                         input  base_trl2,
 *                         input  true,  /* ROUND */
 *                         output base_trl2,
 *                         output mc-error-number)" }
 * /*L024*/          if mc-error-number <> 0 then do:
 * /*L024*/             {mfmsg.i mc-error-number 2}
 * /*L024*/          end.

 * /*J053*/             /* ROUND PER BASE CURR ROUND METHOD */
 * /*L024* /*J053*/  {gprun.i ""gpcurrnd.p"" "(input-output base_trl2, */
 * /*L024*                                     input gl_rnd_mthd)"}  */

 * /*L024* /*J053*/  base_trl3 = base_trl3 / ih_ex_rate. */
 * /*L024*/          {gprunp.i "mcpl" "p" "mc-curr-conv"
 *                       "(input  ih_curr,
 *                         input  base_curr,
 *                         input  ih_ex_rate,
 *                         input  ih_ex_rate2,
 *                         input  base_trl3,
 *                         input  true,  /* ROUND */
 *                         output base_trl3,
 *                         output mc-error-number)" }
 * /*L024*/          if mc-error-number <> 0 then do:
 * /*L024*/             {mfmsg.i mc-error-number 2}
 * /*L024*/          end.

 * /*J053*/             /* ROUND PER BASE CURR ROUND METHOD */
 * /*L024* /*J053*/  {gprun.i ""gpcurrnd.p"" "(input-output base_trl3, */
 * /*L024*                                     input gl_rnd_mthd)"} */

 * /*J053* /*G0CR*/  base_tot_tax = round(base_tot_tax / ih_ex_rate,gl_ex_round).*/
 * /*L024* /*J053*/  base_tot_tax = base_tot_tax / ih_ex_rate. */
 * /*L024*/          {gprunp.i "mcpl" "p" "mc-curr-conv"
 *                       "(input  ih_curr,
 *                         input  base_curr,
 *                         input  ih_ex_rate,
 *                         input  ih_ex_rate2,
 *                         input  base_tot_tax,
 *                         input  true,  /* ROUND */
 *                         output base_tot_tax,
 *                         output mc-error-number)" }
 * /*L024*/          if mc-error-number <> 0 then do:
 * /*L024*/             {mfmsg.i mc-error-number 2}
 * /*L024*/          end.

 * /*J053*/             /* ROUND PER BASE CURR ROUND METHOD */
 * /*L024* /*J053*/  {gprun.i ""gpcurrnd.p"" "(input-output base_tot_tax,*/
 * /*L024*                                     input gl_rnd_mthd)"} */

 * /*J053* /*G0CR*/  base_ord_amt = round(base_ord_amt / ih_ex_rate,gl_ex_round).*/
 * /*L024* /*J053*/  base_ord_amt = base_ord_amt / ih_ex_rate.  */
 * /*L024*/          {gprunp.i "mcpl" "p" "mc-curr-conv"
 *                       "(input  ih_curr,
 *                         input  base_curr,
 *                         input  ih_ex_rate,
 *                         input  ih_ex_rate2,
 *                         input  base_ord_amt,
 *                         input  true,  /* ROUND */
 *                         output base_ord_amt,
 *                         output mc-error-number)" }
 * /*L024*/          if mc-error-number <> 0 then do:
 * /*L024*/             {mfmsg.i mc-error-number 2}
 * /*L024*/          end.

 * /*J053*/             /* ROUND PER BASE CURR ROUND METHOD */
 * /*L024* /*J053*/  {gprun.i ""gpcurrnd.p"" "(input-output base_ord_amt, */
 * /*L024*                                     input gl_rnd_mthd)"}       */
 *M0DM**             ** END DELETE */

/*G0CR*/          end.

/*G0CR*/          tot_trl1 = tot_trl1 + base_trl1.
/*G0CR*/          tot_trl2 = tot_trl2 + base_trl2.
/*G0CR*/          tot_trl3 = tot_trl3 + base_trl3.
/*G0CR*/          tot_disc = tot_disc + base_disc.
/*G0CR*/          rpt_tot_tax = rpt_tot_tax + base_tot_tax.
/*G0CR*/          tot_ord_amt = tot_ord_amt + base_ord_amt.

/*J360*/       end. /* IF LAST-OF(IH_INV_NBR) */
/*G0CR*/    end.
/*G0CR*/    else do:
/*G0CR*/       {gprun.i ""soivhtrl.p""}
/*G0CR*/    end.

/*J360*/    if not {txnew.i} then do :
/*G0CR*/       {soivtot5.i}  /* Accumulate invoice totals */
/*J360*/    end. /* IF NOT {TXNEW.I} */

            /*PRINT TRAILER*/
/*H536**    if last-of(ih_inv_nbr) then do: **/
/*H536*/    if last-of(ih_inv_nbr) and not {txnew.i} then do:
               {soivtot6.i}
            end.
/*J360*/    else if last-of(ih_inv_nbr)
/*J360*/            and {txnew.i} then do :
/*J360*/       {etdcrc.i ih_curr ih_hist.ih}
/*J360*/       {soivto10.i}
/*J360*/    end. /* IF LAST-OF(IH_INV_NBR) AND {TXNEW.I} */
               */
               /* SS - Bill - E */

            {mfrpexit.i}

         end. /* for each ih_hist */

                 /* SS - Bill - B 2005.07.05 */
             END. /* IF LAST-OF(gltr_doc) THEN DO: */
         END. /* FOR EACH gltr_hist */
         /* SS - Bill - E */

            /* SS - Bill - B 2005.06.30 */
            /*
/*J053*/ /* SET UP ALL FORMATS FOR TOTAL IN BASE CURRENCY */
/*J053*/ /* SET TOT_MARGIN FORMAT */
/*J053*/ tot_marg_fmt = tot_margin:format.
/*J053*/ {gprun.i ""gpcurfmt.p"" "(input-output tot_marg_fmt,
                                   input gl_rnd_mthd)"}
/*J053*/ tot_margin:format = tot_marg_fmt.

/*J053*/ /* SET TOT_PRICE FORMAT */
/*J053*/ tot_price_fmt = tot_price:format.
/*J053*/ {gprun.i ""gpcurfmt.p"" "(input-output tot_price_fmt,
              input gl_rnd_mthd)"}
/*J053*/ tot_price:format = tot_price_fmt.

/*J053*/ /* SET TOT_DISC FORMAT */
/*J053*/ tot_disc_fmt = tot_disc:format.
/*J053*/ {gprun.i ""gpcurfmt.p"" "(input-output tot_disc_fmt,
                                   input gl_rnd_mthd)"}
/*J053*/ tot_disc:format = tot_disc_fmt.

/*J053*/ /* SET TOT_TRL FORMAT */
/*J053*/ tot_trl_fmt = tot_trl1:format.
/*J053*/ {gprun.i ""gpcurfmt.p"" "(input-output tot_trl_fmt,
                                       input gl_rnd_mthd)"}
/*J053*/ tot_trl1:format = tot_trl_fmt.
/*J053*/ tot_trl2:format = tot_trl_fmt.
/*J053*/ tot_trl3:format = tot_trl_fmt.

/*J053*/ /* SET TOT_TAX FORMAT */
/*J053*/ tot_tax_fmt = rpt_tot_tax:format.
/*J053*/ {gprun.i ""gpcurfmt.p"" "(input-output tot_tax_fmt,
              input gl_rnd_mthd)"}
/*J053*/ rpt_tot_tax:format = tot_tax_fmt.

/*J053*/ /* SET TOT_ORD FORMAT */
/*J053*/ tot_ord_fmt = tot_ord_amt:format.
/*J053*/ {gprun.i ""gpcurfmt.p"" "(input-output tot_ord_fmt,
              input gl_rnd_mthd)"}
/*J053*/ tot_ord_amt:format = tot_ord_fmt.

/*J053*/ tot_price = accum total base_price.
/*J053*/ tot_margin = accum total base_margin.
         if page-size - line-counter < 6 then page.
         put skip(1) base_rpt + {&soivrp9a_p_2} format "x(18)" skip.

/*J053******************* REDO DISPLAY *********************************/
/*J053*         display accum total base_margin label "Ext Margin"            */
/*J053*                 format "->>,>>>,>>>,>>9.99<<<"                        */
/*J053*                 accum total base_price label "Ext Price"              */
/*J053*                 format "->>,>>>,>>>,>>9.99<<<"                        */
/*J053*                 tot_disc format "->>,>>>,>>>,>>9.99<<<"               */
/*J053*                 tot_trl1 format "->>,>>>,>>>,>>9.99<<<"               */
/*J053*                 tot_trl2 format "->>,>>>,>>>,>>9.99<<<"               */
/*J053*                 tot_trl3 format "->>,>>>,>>>,>>9.99<<<"               */
/*J053*                 rpt_tot_tax format "->>,>>>,>>>,>>9.99<<<"            */
/*J053*                 tot_ord_amt format "->>,>>>,>>>,>>9.99<<<"            */
/*J053*         with frame d side-labels 3 columns width 132.                 */

/*J053*/ display tot_margin
/*J053*/         tot_price
/*J053*/         tot_disc
/*J053*/         tot_trl1
/*J053*/         tot_trl2
/*J053*/         tot_trl3
/*J053*/         rpt_tot_tax
/*J053*/         tot_ord_amt
/*J053*/ with frame d.
*/
/* SS - Bill - E */

/*J053*/ SESSION:numeric-format = oldsession.
/*K0LH*/ {wbrp04.i}

/*J360*/ PROCEDURE p-acc-totals :
/*J360*/     /* THIS PROCEDURE ACCUMULATES TRAILER TOTALS FOR GTM */

/*J360*/     define parameter buffer ih_hist       for  ih_hist.
/*J360*/     define input-output parameter invtot_nontaxable_amt
                               as decimal no-undo.
/*J360*/     define input-output parameter invtot_taxable_amt
                       as decimal no-undo.
/*J360*/     define input-output parameter invtot_line_total
                       as decimal no-undo.
/*J360*/     define input-output parameter invtot_disc_amt as decimal no-undo.
/*J360*/     define input-output parameter invtot_trl1_amt
                       like ih_trl1_amt no-undo.
/*J360*/     define input-output parameter invtot_trl2_amt
                       like ih_trl2_amt no-undo.
/*J360*/     define input-output parameter invtot_trl3_amt
                       like ih_trl3_amt no-undo.
/*J360*/     define input-output parameter invtot_tax_amt as decimal no-undo.
/*J360*/     define input-output parameter invtot_ord_amt as decimal no-undo.

/*J360*/     define variable tmpamt          as   decimal no-undo.
/*J360*/     define variable mc-error-number like msg_nbr no-undo.

/*J360*/     {soivtot9.i}
/*J360*/ end. /* PROCEDURE P-ACC-TOTALS */
