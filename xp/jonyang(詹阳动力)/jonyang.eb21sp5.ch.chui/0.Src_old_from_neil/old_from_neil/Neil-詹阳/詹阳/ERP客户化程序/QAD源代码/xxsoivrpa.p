/* soivrpa.p - PENDING INVOICE REGISTER SUBPROGRAM                      */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.16.1.18.1.2 $                                            */
/*V8:ConvertMode=Report                                                 */
/* REVISION: 7.4      LAST MODIFIED: 07/14/93   BY: JJS *H050*          */
/*                                               (split from soivrp.p)  */
/* REVISION: 7.4      LAST MODIFIED: 08/19/93   BY: pcd *H009*          */
/* REVISION: 7.4      LAST MODIFIED: 11/23/93   BY: cdt *H184*          */
/* REVISION: 7.4      LAST MODIFIED: 12/08/93   BY: bcm *H266*          */
/* REVISION: 7.4      LAST MODIFIED: 12/15/93   BY: cdt *GI04*          */
/* REVISION: 7.4      LAST MODIFIED: 03/28/94   BY: srk *H305*          */
/* REVISION: 7.4      LAST MODIFIED: 11/11/94   BY: afs *H593*          */
/* REVISION: 7.4      LAST MODIFIED: 12/28/94   BY: bcm *F0C0*          */
/* REVISION: 7.4      LAST MODIFIED: 03/13/95   BY: jxz *F0M3*          */
/* REVISION: 7.4      LAST MODIFIED: 10/02/95   BY: jym *G0XY*          */
/* REVISION: 7.4      LAST MODIFIED: 11/07/95   BY: ais *G0Z5*          */
/* REVISION: 8.5      LAST MODIFIED: 07/20/95   BY: taf *J053*          */
/* REVISION: 8.5      LAST MODIFIED: 07/19/96   BY: taf *J0ZZ*          */
/* REVISION: 8.5      LAST MODIFIED: 11/11/96   BY: *H0N8* Ajit Deodhar */
/* REVISION: 8.5      LAST MODIFIED: 08/14/97   BY: *J1Z0* Ajit Deodhar */
/* REVISION: 8.6      LAST MODIFIED: 10/04/97   BY: ckm *K0LD*          */
/* REVISION: 8.6      LAST MODIFIED: 11/27/97   BY: *J273* Nirav Parikh */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 05/06/98   BY: *L00L* Adam Harris  */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton */
/* REVISION: 8.6E     LAST MODIFIED: 07/13/98   BY: *L024* Bill Reckard */
/* REVISION: 8.6E     LAST MODIFIED: 09/24/98   BY: *L09L* Poonam Bahl  */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Murali Ayyagari  */
/* REVISION: 9.1      LAST MODIFIED: 02/15/00   BY: *K25F* Rajesh Kini      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 05/07/00   BY: *N09G* Luke Pokic       */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* myb              */
/* REVISION: 9.1      LAST MODIFIED: 09/26/00   BY: *K264* Manish K.        */
/* Old ECO marker removed, but no ECO header exists *F0PN*              */
/* Revision: 1.16.1.10  BY: Katie Hilbert          DATE: 04/01/01 ECO: *P002* */
/* Revision: 1.16.1.11  BY: Ellen Borden           DATE: 07/09/01 ECO: *P007* */
/* Revision: 1.16.1.12  BY: Nikita Joshi           DATE: 04/17/01 ECO: *L18Q* */
/* Revision: 1.16.1.14  By: Marek Krajanowski      DATE: 02/27/03 ECO: *P0NH* */
/* Revision: 1.16.1.16  BY: Paul Donnelly (SB)     DATE: 06/28/03 ECO: *Q00L* */
/* Revision: 1.16.1.17  BY: Gnanasekar             DATE: 09/15/03 ECO: *P0ZW* */
/* Revision: 1.16.1.18  BY: Prashant Parab         DATE: 04/06/04 ECO: *P1WT* */
/* Revision: 1.16.1.18.1.1 BY: Dayanand Jethwa     DATE: 02/24/05 ECO: *P27M* */
/* $Revision: 1.16.1.18.1.2 $ BY: Karel Groos DATE: 04/01/05 ECO: *P2BV*        */
/* SS - 090924.1 By: Neil Gao */

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{cxcustom.i "SOIVRPA.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */


{wbrp02.i}

define new shared variable convertmode as character no-undo
   initial "report".
define new shared variable rndmthd like rnd_rnd_mthd .
define new shared variable so_recno as recid.
define new shared variable sod_recno as recid.
define new shared variable gl_sum like mfc_logical.
define new shared variable eff_date as date.
define new shared variable post like mfc_logical.
define new shared variable already_posted like glt_amt.
define new shared variable tot_curr_amt like glt_amt.
define new shared variable ext_price as decimal label "Ext Price"
   format "->>>>,>>>,>>9.99".
define new shared variable ext_list like sod_list_pr.
define new shared variable ext_disc as decimal.
define new shared variable base_amt like ar_amt.
define new shared variable base_price as decimal
   format "->>>>,>>>,>>9.99".
define new shared variable base_margin as decimal
   format "->>>>,>>>,>>9.99".
define new shared variable exch_rate like so_ex_rate.
define new shared variable exch_rate2 like so_ex_rate2.
define new shared variable exch_ratetype like so_ex_ratetype.
define new shared variable exch_exru_seq like so_exru_seq.
define new shared variable undo_all like mfc_logical no-undo.
define new shared variable new_order like mfc_logical.
define new shared variable ref like glt_det.glt_ref.
define new shared variable batch like ar_batch.
define new shared variable curr_amt like glt_amt.
define new shared variable should_be_posted like glt_amt.
define new shared variable post_entity like ar_entity.
define new shared variable tax_recno as recid.
define new shared variable consolidate like mfc_logical initial false.
define new shared variable ext_price_fmt as character.
define new shared variable ext_gr_marg_fmt as character.
define new shared variable undo_txdetrp    like mfc_logical.
define new shared variable crtint_amt like trgl_gl_amt.
define new shared variable addtax     like mfc_logical.

{&SOIVRPA-P-TAG1}

define shared variable tot_base_amt like ar_amt.
define shared variable tot_base_price as decimal
   format "->>>>,>>>,>>9.99".
define shared variable tot_base_margin as decimal
   format "->>>>,>>>,>>9.99".
define shared variable nbr like so_nbr.
define shared variable nbr1 like so_nbr.
define shared variable shipdate like so_ship_date.
define shared variable shipdate1 like shipdate.
define shared variable cust  like so_cust.
define shared variable cust1 like so_cust.
define shared variable bill  like so_bill.
define shared variable bill1 like so_bill.
define shared variable print_ready2inv like mfc_logical initial yes.
define shared variable print_ready2post like mfc_logical initial no.
define shared variable inv_only like mfc_logical initial yes.
define shared variable print_lotserials like mfc_logical
   label "Print Lot/Serial Numbers Shipped".
define shared variable conso           like mfc_logical initial no.

define variable ext_price_old as character.
define variable ext_gr_marg_old as character.
define variable net_price like sod_price.
define variable name like ad_name.
define variable ext_gr_margin like sod_price label "Ext Margin"
   format "->>>>,>>>,>>9.99".
define variable col-80 like mfc_logical initial false.

define            variable bill_name       like ad_name.
define            variable sales_entity    like si_entity.
define            variable oldsession as character no-undo.
define            variable oldcurr         like so_curr no-undo.
define            variable l_accumonly    as integer initial 1 no-undo.
define            variable l_printonly    as integer initial 3 no-undo.
define            variable l_consolidate  as logical initial no no-undo.
define            variable l_ar_gl_line    like glt_line   no-undo.
define            variable l_ar_gltw_line  like gltw_line  no-undo.
define            variable l_so_gl_line    like glt_line   no-undo.
define            variable l_so_gltw_line  like gltw_line  no-undo.
define            variable l_tot_amt       like glt_amt    no-undo.
define            variable l_tot_ramt      like glt_amt    no-undo.
define            variable l_rnd_tax_amt   like glt_amt    no-undo.
define            variable l_rnd_tax_ramt  like glt_amt    no-undo.
define            variable l_ln_tot_amt    like glt_amt    no-undo.
define            variable l_ln_tot_ramt   like glt_amt    no-undo.
define            variable p_last_line     like mfc_logical no-undo initial no.


define            buffer   somstr2         for so_mstr.
define            workfile coninv_wkfl
   field    coninv_sonbr    like so_nbr.
define new shared frame sotot.

/* WORKFILE DEFINITION */
{txdetdef.i "new shared"}

define variable tot_prepaid_amt     like so_prepaid      no-undo.
define variable tot_prepaid_nett    like so_prepaid      no-undo
   label "Total Prepaid" .
define variable tot_ptax_amt        like so_prepaid      no-undo
   label "Prepaid Tax".
define variable amt_due_af_prep like so_prepaid          no-undo
   label "Amount Due" .
define variable add-trl-length      as integer           no-undo.
define variable et_tot_prepaid_amt  like tot_prepaid_amt no-undo.
define variable et_tot_ptax_amt     like tot_prepaid_amt no-undo.
define variable et_tot_prepaid_nett like tot_prepaid_amt no-undo.
define variable et_amt_due_af_prep  like tot_prepaid_amt no-undo.
define variable price_fmt           as character         no-undo.
define variable cont_charges        as decimal no-undo.
define variable line_charges        as decimal no-undo.
/* SS 090924.1 - B */
define shared var tot_qty like sod_qty_ord.
/* SS 090924.1 - E */

{etvar.i &new="new"}
{etrpvar.i &new="new"}
{etdcrvar.i "new"}
{gpfilev.i}  /* VARIABLE DEFINITIONS FOR gpfile.i */

form
   tot_prepaid_amt      colon 15
   tot_prepaid_nett     colon 60
   tot_ptax_amt         colon 15
   "-----------------"  at 61
   skip
   amt_due_af_prep      colon 60
with frame prepd width 80
   side-labels.

/* SET EXTERNAL LABELS */
setFrameLabels(frame prepd:handle).

/* PREPAID EURO FRAME */
form
   tot_prepaid_amt      colon 15
   et_tot_prepaid_amt   at 80 no-attr-space no-label
   tot_prepaid_nett     colon 60
   et_tot_prepaid_nett  at 80 no-attr-space no-label
   tot_ptax_amt         colon 15
   et_tot_ptax_amt      at 80 no-attr-space no-label
   skip(1)
   amt_due_af_prep      colon 60
   et_amt_due_af_prep   at 80 no-attr-space no-label
with frame prepdeuro side-labels width 132 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame prepdeuro:handle).

{etsotrla.i "NEW"}
{soivtot1.i "NEW" }  /* variables for invoice totals */
{soivrpl2.i "NEW"}   /* defs for soivtrl2.p addition */

{cclc.i} /* DETERMINE IF CONTAINER OR LINE CHARGES IS ACTIVE */

/* ASSIGN ORIGINAL FORMAT TO _OLD VARIABLES */
assign
   nontax_old     = nontaxable_amt:format
   taxable_old    = taxable_amt:format
   line_tot_old   = line_total:format
   disc_old       = disc_amt:format
   trl_amt_old    = so_trl1_amt:format
   tax_amt_old    = tax_amt:format
   ord_amt_old    = ord_amt:format
   ext_price_old  = ext_price:format
   ext_gr_marg_old = ext_gr_margin:format
   container_old = container_charge_total:format
   line_charge_old = line_charge_total:format.

assign
   maint             = false
   post              = false
   addtax            = true
   gl_sum            = true
   eff_date          = today
   tot_base_price    = 0
   tot_base_margin   = 0
   tot_base_amt      = 0
   .

oldcurr = "".
oldsession = SESSION:numeric-format.
soloop:
for each so_mstr  where so_mstr.so_domain = global_domain and (  (so_nbr >=
nbr) and (so_nbr <= nbr1)
      and (so_ship_date >= shipdate)
      and (so_ship_date <= shipdate1)
      and (so_cust >= cust and so_cust <= cust1)
      and (so_bill >= bill and so_bill <= bill1)
      and ((so_to_inv = yes and print_ready2inv)
      or (so_to_inv = no and so_invoiced = yes
      and print_ready2post))
      ) no-lock by so_nbr:

   /* FLUSH THE WORKFILE */
   for each taxdetail exclusive-lock:
      delete taxdetail.
   end.

   assign
      l_tot_amt     = 0
      l_ln_tot_amt  = 0
      l_ln_tot_ramt = 0
      l_tot_ramt    = 0.

   /* Check if previously consolidated */
   find first coninv_wkfl where coninv_sonbr = so_nbr no-lock no-error.
   if available coninv_wkfl then next.

   if (oldcurr <> so_curr) or (oldcurr = "") then do:

      {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
         "(input  so_curr,
           output rndmthd,
           output mc-error-number)" }
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4}
         next.
      end.

      /* DETERMINE CURRENCY DISPLAY AMERICAN OR EUROPEAN           */
      find rnd_mstr  where rnd_mstr.rnd_domain = global_domain and
      rnd_rnd_mthd = rndmthd no-lock no-error.
      if not available rnd_mstr then do:
         {pxmsg.i &MSGNUM=863 &ERRORLEVEL=4}
         /* ROUND METHOD RECORD NOT FOUND */
         next.
      end.
      /* IF RND_DEC_PT = COMMA FOR DECIMAL POINT */
      /* THIS IS A EUROPEAN STYLE OF CURRENCY */
      if (rnd_dec_pt = ",")
      then SESSION:numeric-format = "European".
      else SESSION:numeric-format = "American".
      /* SET UP ALL TRAILER FORMATS ACCORDING TO CURRENCY ROUND MTHD*/
      {socurfmt.i}
      /* SET UP EXT PRICE FORMAT ACCORDING TO CURRENCY ROUND MTHD */
      ext_price_fmt = ext_price_old.
      {gprun.i ""gpcurfmt.p"" "(input-output ext_price_fmt,
                                input rndmthd)"}
      /* SET UP EXT GR MARG FORMAT ACCORDING TO CURRENCY ROUND MTHD */
      ext_gr_marg_fmt = ext_gr_marg_old.
      {gprun.i ""gpcurfmt.p"" "(input-output ext_gr_marg_fmt,
                                input rndmthd)"}
      oldcurr = so_curr.
   end. /* IF (OLDCURR <> SO_CURR */

   already_posted = 0.
   tot_curr_amt = 0.
   {soivtot2.i}  /* Initialize variables */

   find ad_mstr  where ad_mstr.ad_domain = global_domain and  ad_addr = so_cust
   no-lock no-wait no-error.
   if available ad_mstr then name = ad_name.
   else name = "".
   find ad_mstr  where ad_mstr.ad_domain = global_domain and  ad_addr = so_bill
   no-lock no-wait no-error.
   if available ad_mstr then bill_name = ad_name.
   else bill_name = "".
   find ad_mstr  where ad_mstr.ad_domain = global_domain and  ad_addr = so_ship
   no-lock no-wait no-error.

   /* Invoice Header */
   if page-size - line-counter <= 11 then page.
   do with frame h1:
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame h1:handle).
      display
         so_inv_nbr
         so_bill
         bill_name
         so_cust
         name
         so_slspsn[1] label "Salespsn"
         so_ar_acct + "-" + so_ar_sub
/* SS 090924.1 - B */
/*
         so_ar_sub
					no-label
*/
					format "x(16)" label "Ó¦ÊÕÕË»§"
/* SS 090924.1 - E */
         so_ar_cc
      with frame h1 width 132.
   end. /* do with frame h1 */

   do with frame env:
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame env:handle).
      display
         so_tax_env at 60
         so_tax_usage
      with frame env width 132 side-labels no-box.
   end. /* if */

   so_recno = recid(so_mstr).

   assign
      tot_prepaid_amt = 0
      tot_ptax_amt    = 0
      l_consolidate   = no.

   /* Calculate order total */

   /* GET THE CONTAINER AND LINE CHARGE TOTALS */
   /* AND PASS THEM TO soivtrl2.p SO THAT THEY */
   /* CAN BE CALCULATED AND PRINTED ON THE     */
   /* INVOICE POST TRAILER.                    */

   run container_line_charge_calc in THIS-PROCEDURE
       (input recid(so_mstr), output cont_charges,
        output line_charges).
   assign
      tot_base_price = tot_base_price + cont_charges + line_charges
      tot_base_margin = tot_base_margin + cont_charges + line_charges.

   /* TOTAL ORDER, BUT DON'T PRINT THE DETAIL */
   /* REPORT YET                              */
   assign
      undo_trl2 = true
      consolidate = true.
   find first tx2d_det  where tx2d_det.tx2d_domain = global_domain and
   tx2d_ref = so_inv_nbr
      and tx2d_nbr = so_nbr
      and tx2d_tr_type = '16' no-lock no-error.
   if available tx2d_det then do:
      {gprun.i ""soivtrl2.p"" "(input so_inv_nbr,
                     input so_nbr,
                     input col-80 /* REPORT WIDTH */,
                     input '16'   /* TRANSACTION TYPE */,
                     input cont_charges,
                     input line_charges,
                     input l_consolidate)"}
      /* ACCUMULATE THE TAX DETAILS */
      {gprun.i ""txdetrp1.p"" "(input '16',
                      input so_inv_nbr,
                      input so_nbr,
                      input col-80,
                      input 0,
                      input l_accumonly)"}
   end. /* if available tx2d_det */
   else do:
      if so_fsm_type = "fsm-ro"
      then do:
         {gprun.i ""soivtrl2.p""
               "(input so_nbr,
                 input so_quote,
                 input col-80,
                 input '38',
                 input cont_charges,
                 input line_charges,
                 input l_consolidate)"}
         /* ACCUMULATE TAX DETAILS */
         {gprun.i ""txdetrp1.p""
               "(input '38',
                 input so_nbr,
                 input so_quote,
                 input col-80,
                 input 0,
                 input l_accumonly)"}
      end. /* IF SO_FSM_TYPE */

      else do:
         {gprun.i ""soivtrl2.p"" "(input so_nbr,
                         ' ',
                         input col-80 /* REPORT WIDTH */,
                         input '13'   /* TRANSACTION TYPE */,
                         input cont_charges,
                         input line_charges,
                         input l_consolidate)"}
         /* ACCUMULATE TAX DETAILS */
         {gprun.i ""txdetrp1.p"" "(input '13',
                         input so_nbr,
                         input '',
                         input col-80,
                         input 0,
                         input l_accumonly)"}
      end. /* ELSE DO */
   end. /* else do: */
   if undo_trl2 then return.

   /* DISPLAY ORDER DETAIL  */
   /* ADDED FOUR INPUT-OUTPUT PARMETERS                    */
   /* L_SO_GL_LINE,L_SO_GLTW_LINE,L_TOT_AMT AND L_TOT_RAMT */

   /* ADDED FIFTH   INPUT PARAMETER p_last_line TO ACCOMODATE THE */
   /* LOGIC INTRODUCED IN gpcurcnv.i FOR HANDLING ROUNDING ISSUES */
/* SS 090924.1 - B */
/*
   {gprun.i ""soivrpb.p""
*/
   {gprun.i ""xxsoivrpb.p""
      "(input-output l_so_gl_line,
        input-output l_so_gltw_line,
        input-output l_tot_amt,
        input-output l_tot_ramt,
        input        p_last_line)"}
/* SS 090924.1 - E */

   /* Accumulate SO totals */
   {soivtot7.i}

   base_amt = ord_amt.
   if base_curr <> so_curr then
   do:

      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input  so_curr,
           input  base_curr,
           input  exch_rate,
           input  exch_rate2,
           input  base_amt,
           input  true,  /* ROUND */
           output base_amt,
           output mc-error-number)" }
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.
   end.
   tot_base_amt = tot_base_amt + base_amt.

   /* ADDED FOUR INPUT-OUTPUT PARAMETERS                    */
   /* L_AR_GL_LINE,L_AR_GLTW_LINE,L_TOT_AMT AND L_TOT_RAMT  */
   /* ADDED SEVENTH INPUT PARAMETER p_last_line TO ACCOMODATE THE */
   /* LOGIC INTRODUCED IN gpcurcnv.i FOR HANDLING ROUNDING ISSUES */

   {gprun.i ""sosogla.p""
      "(input-output l_ar_gl_line,
        input-output l_ar_gltw_line,
        input-output l_tot_amt,
        input-output l_tot_ramt,
        input cont_charges,
        input line_charges,
        input p_last_line,
        input-output addtax)"}

   if so_fsm_type = "PRM" then do:

      /* WIP -> COGS GL BOOKINGS */
      {gprunmo.i
         &module="PRM"
         &program="pjivpst.p"}

   end.

   /* Check for consolable invoices */
   if conso then do:

      find si_mstr  where si_mstr.si_domain = global_domain and  si_site =
      so_site no-lock no-error.
      if available si_mstr then sales_entity = si_entity.
      else sales_entity = glentity.

      for each somstr2
             where somstr2.so_domain = global_domain and (  (so_nbr >
             so_mstr.so_nbr and so_nbr <= nbr1)
            and so_inv_nbr     = so_mstr.so_inv_nbr
            and ((so_to_inv = yes and print_ready2inv)
            or (so_to_inv = no and so_invoiced = yes
            and print_ready2post))
            and (so_ship_date >= shipdate and so_ship_date <= shipdate1)
            and (  so_bill     = so_mstr.so_bill  /* FIELDS WHICH MUST */
            and so_cust        = so_mstr.so_cust  /* BE IDENTICAL FOR  */
            and so_curr        = so_mstr.so_curr  /* CONSOLIDATION.    */
            and so_cr_terms    = so_mstr.so_cr_terms
            and so_trl1_cd     = so_mstr.so_trl1_cd
            and so_trl2_cd     = so_mstr.so_trl2_cd
            and so_trl3_cd     = so_mstr.so_trl3_cd
            and so_slspsn[1]   = so_mstr.so_slspsn[1]
            and so_slspsn[2]   = so_mstr.so_slspsn[2]
            and so_slspsn[3]   = so_mstr.so_slspsn[3]
            and so_slspsn[4]   = so_mstr.so_slspsn[4]
            )
            /* USE-INDEX CLAUSE HAS BEEN ADDED IN 91 TO AVOID PROGRESS BUG */
            /* THAT DISCONNECTS THE DATABASE WHEN 2 IDENTICAL INDEXES ARE UTILIZED */
            /* ON THE SAME TABLE */
            /* WHEN PROGRESS BUG IS FIXED, USE-INDEX CLAUSE CAN BE REMOVED */
            ) no-lock use-index so_to_inv by so_to_inv by so_nbr:
         l_consolidate = yes.

         /* Compare sales order entities */
         find si_mstr  where si_mstr.si_domain = global_domain and  si_site =
         somstr2.so_site no-lock no-error.
         if not available si_mstr or si_entity <> sales_entity
            then next.

         so_recno = recid(somstr2).
         /* Print SO lines */
         /* ADDED FOUR INPUT-OUTPUT PARMETERS                    */
         /* L_SO_GL_LINE,L_SO_GLTW_LINE,L_TOT_AMT AND L_TOT_RAMT */
         /* ADDED FIFTH   INPUT PARAMETER p_last_line TO ACCOMODATE THE */
         /* LOGIC INTRODUCED IN gpcurcnv.i FOR HANDLING ROUNDING ISSUES */

/* SS 090924.1 - B */
/*
         {gprun.i ""soivrpb.p""
*/
         {gprun.i ""xxsoivrpb.p""
            "(input-output l_so_gl_line,
              input-output l_so_gltw_line,
              input-output l_tot_amt,
              input-output l_tot_ramt,
              input p_last_line)"}
/* SS 090924.1 - E */

         /* TOTAL ORDER, BUT DON'T PRINT THE DETAIL REPORT YET */
         undo_trl2 = true.
         find first tx2d_det  where tx2d_det.tx2d_domain = global_domain and
         tx2d_ref = so_inv_nbr
            and tx2d_nbr = so_nbr
            and tx2d_tr_type = '16' no-lock no-error.
         if available tx2d_det then do:
            {gprun.i ""soivtrl2.p""
                  "(input so_inv_nbr,
                    input so_nbr,
                    input col-80 /* REPORT WIDTH */,
                    input '16'   /* TRANSACTION TYPE */,
                    input cont_charges,
                    input line_charges,
                    input l_consolidate)"}
            /* ACCUMULATE THE TAX DETAILS */
            {gprun.i ""txdetrp1.p"" "(input '16',
                      input so_inv_nbr,
                      input so_nbr,
                      input col-80,
                      input 0,
                      input l_accumonly)"}
         end. /* if available tx2d_det */
         else do:
            {gprun.i ""soivtrl2.p"" "(input so_nbr,
                          ' ',
                          input col-80 /* REPORT WIDTH */,
                          input '13'   /* TRANSACTION TYPE */,
                          input cont_charges,
                          input line_charges,
                          input l_consolidate)"}
            /* ACCUMULATE TAX DETAILS */
            {gprun.i ""txdetrp1.p"" "(input '13',
                      input so_nbr,
                      input '',
                      input col-80,
                      input 0,
                      input l_accumonly)"}
         end. /* else do: */
         if undo_trl2 then return.

         {soivtot7.i}  /* ACCUMULATE INVOICE TOTALS */

         assign
            tot_prepaid_amt = tot_prepaid_amt + so_prepaid
            tot_ptax_amt    = tot_ptax_amt + so_prep_tax
            base_amt = ord_amt.
         if base_curr <> so_curr then
         do:

            {gprunp.i "mcpl" "p" "mc-curr-conv"
                          "(input  so_curr,
                            input  base_curr,
                            input  exch_rate,
                            input  exch_rate2,
                            input  ord_amt,
                            input  true,  /* ROUND */
                            output base_amt,
                            output mc-error-number)" }
            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end.
         end.
         tot_base_amt = tot_base_amt + base_amt.

         /* ADDED FOUR INPUT-OUTPUT PARAMETERS                   */
         /* L_AR_GL_LINE,L_AR_GLTW_LINE,L_TOT_AMT AND L_TOT_RAMT */
         /* ADDED SEVENTH INPUT PARAMETER p_last_line TO ACCOMODATE THE */
         /* LOGIC INTRODUCED IN gpcurcnv.i FOR HANDLING ROUNDING ISSUES */

         {gprun.i ""sosogla.p""
            "(input-output l_ar_gl_line,
              input-output l_ar_gltw_line,
              input-output l_tot_amt,
              input-output l_tot_ramt,
              input cont_charges,
              input line_charges,
              input p_last_line,
              input-output addtax)"}

         /* Write SO to temp file so we don't report it again */
         create coninv_wkfl.
         coninv_sonbr = somstr2.so_nbr.

         {mfrpchk.i &loop="soloop"}
      end. /* for each */

   end.  /* If consolidating */

   /* STORING THE VALUES WITH TAX */
   assign
      l_ln_tot_amt   = l_tot_amt
      l_ln_tot_ramt  = l_tot_ramt
      l_rnd_tax_ramt = 0
      l_rnd_tax_amt  = 0.

   {&SOIVRPA-P-TAG3}

      /* ACCUMULATING TAX TOTALS */
      for each tx2d_det
         fields( tx2d_domain tx2d_cur_tax_amt tx2d_ref tx2d_tax_amt
         tx2d_tr_type)
          where tx2d_det.tx2d_domain = global_domain and  tx2d_ref     = so_nbr
         and   tx2d_tr_type = "13"
      no-lock:
         assign
            l_rnd_tax_amt  = l_rnd_tax_amt  + tx2d_cur_tax_amt
            l_rnd_tax_ramt = l_rnd_tax_ramt + tx2d_tax_amt.
      end. /* FOR EACH tx2d_det */

   {&SOIVRPA-P-TAG4}

   assign
      l_tot_amt  = l_tot_amt  - l_rnd_tax_amt
      l_tot_ramt = l_tot_ramt - l_rnd_tax_ramt.

   /* CONVERT L_TOT_AMT TO BASE CURRENCY */
   {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input  so_curr,
              input  base_curr,
              input  exch_rate,
              input  exch_rate2,
              input  l_tot_amt,
              input  true, /* ROUND */
              output l_tot_amt,
              output mc-error-number)" }
   if mc-error-number <> 0
   then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end. /* IF MC-ERROR-NUMBER <> 0 */

   /* CONVERT l_ln_tot_amt TO BASE CURRENCY */
   {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input  so_curr,
              input  base_curr,
              input  exch_rate,
              input  exch_rate2,
              input  l_ln_tot_amt,
              input  true, /* ROUND */
              output l_ln_tot_amt,
              output mc-error-number)" }
   if mc-error-number <> 0
   then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end. /* IF MC-ERROR-NUMBER <> 0 */

   if l_tot_amt <> l_tot_ramt
   then do:

      for each gltw_wkfl
             where gltw_wkfl.gltw_domain = global_domain and  gltw_userid =
             mfguser
            and   gltw_ref    = mfguser
      exclusive-lock:
         if gltw_line = l_so_gltw_line then
            gltw_amt = gltw_amt + (l_tot_amt - l_tot_ramt).
         if gltw_line = l_ar_gltw_line then
            gltw_amt = gltw_amt - (l_tot_amt - l_tot_ramt).
      end. /* FOR EACH GLTW_WKFL */

      assign
         tot_base_amt    = tot_base_amt
                         - (l_ln_tot_amt - l_ln_tot_ramt)
         tot_base_price  = tot_base_price
                         - (l_ln_tot_amt - l_ln_tot_ramt)
         tot_base_margin = tot_base_margin
                         - (l_ln_tot_amt - l_ln_tot_ramt).

   end. /* IF L_TOT_AMT <> L_TOT_RAMT */

   /* Display Trailer */
   /* PRINT TAX DETAIL FOR ALL SALES ORDERS */
   /* FOR THIS INVOICE NUMBER USING 132 COL */
   /* AND NO FORCED PAGE BREAK              */
   undo_txdetrp = true.
   {gprun.i ""txdetrp1.p"" "(input '',
                      input '',
                      input '',
                      input col-80,
                      input 0,
                      input l_printonly)"}
   if undo_txdetrp then undo, next.
   assign
      tot_ptax_amt    = tot_ptax_amt + so_prep_tax
      tot_prepaid_amt = tot_prepaid_amt + so_prepaid.

   {&SOIVRPA-P-TAG2}

   {soivtot8.i}
   price_fmt = "-zzzz,zzz,zz9.99".
   {gprun.i ""gpcurfmt.p"" "(input-output price_fmt,
                             input rndmthd)"}

   assign
      tot_prepaid_amt:format  in frame prepd = price_fmt
      tot_ptax_amt:format     in frame prepd = price_fmt
      tot_prepaid_nett:format in frame prepd = price_fmt
      amt_due_af_prep:format  in frame prepd = price_fmt.

   if tot_prepaid_amt <> 0 then do:
      /* IF THERE HAS BEEN A ROUNDING ERROR, ADJUST */
      /* THE PREPAID TAX AMOUNT TO BALANCE IT OUT.  */
      if absolute(tot_ptax_amt - tax_amt) = .01 then
         tot_ptax_amt = tax_amt.
      assign
         tot_prepaid_nett = tot_prepaid_amt + tot_ptax_amt
         amt_due_af_prep  = invtot_ord_amt  - tot_prepaid_nett.
      if not et_dc_print then
      display
         tot_prepaid_amt
         tot_ptax_amt
         tot_prepaid_nett
         amt_due_af_prep
      with frame prepd.
      else do:
         {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input  so_curr,
                 input  et_sec_curr,
                 input  et_rate1,
                 input  et_rate2,
                 input  tot_prepaid_amt,
                 input  true,        /* ROUND */
                 output et_tot_prepaid_amt,
                 output mc-error-number)"}
         {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input  so_curr,
                 input  et_sec_curr,
                 input  et_rate1,
                 input  et_rate2,
                 input  tot_ptax_amt,
                 input  true,        /* ROUND */
                 output et_tot_ptax_amt,
                 output mc-error-number)"}
         {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input  so_curr,
                 input  et_sec_curr,
                 input  et_rate1,
                 input  et_rate2,
                 input  tot_prepaid_nett,
                 input  true,        /* ROUND */
                 output et_tot_prepaid_nett,
                 output mc-error-number)"}
         {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input  so_curr,
                 input  et_sec_curr,
                 input  et_rate1,
                 input  et_rate2,
                 input  amt_due_af_prep,
                 input  true,        /* ROUND */
                 output et_amt_due_af_prep,
                 output mc-error-number)"}

         assign
               tot_prepaid_amt:format  in frame prepdeuro = price_fmt
               tot_ptax_amt:format     in frame prepdeuro = price_fmt
               tot_prepaid_nett:format in frame prepdeuro = price_fmt
               amt_due_af_prep:format  in frame prepdeuro = price_fmt
               et_tot_prepaid_amt:format in frame prepdeuro =
               et_ord_amt:format
               et_tot_ptax_amt:format in frame prepdeuro =
               et_ord_amt:format
               et_tot_prepaid_nett:format in frame prepdeuro =
               et_ord_amt:format
               et_amt_due_af_prep:format in frame prepdeuro =
               et_ord_amt:format.
         display
               tot_prepaid_amt
               tot_ptax_amt
               tot_prepaid_nett
               amt_due_af_prep
               et_tot_prepaid_amt
               et_tot_ptax_amt
               et_tot_prepaid_nett
               et_amt_due_af_prep
         with frame prepdeuro.
      end.
   end.

   put skip(1).

   /* UPDATE GL WORKFILE */
   so_recno = recid(so_mstr).

   {mfrpchk.i &loop="soloop"}

end. /* FOR EACH SO_MSTR WHERE (SO_NBR >= NBR) */
SESSION:numeric-format = oldsession.
{wbrp04.i}

/* INTERNAL PROCEDURE TO CALCULATE AND PRINT CONTAINER AND LINE */
/* CHARGES ON THE PENDING INVOICE REGISTER OUTPUT.              */
PROCEDURE container_line_charge_calc:
   define input parameter so_recid as recid no-undo.
   define output parameter cont_charges as decimal no-undo.
   define output parameter line_charges as decimal no-undo.

   define variable absl_exists as logical initial no no-undo.

   for first so_mstr no-lock  where so_mstr.so_domain = global_domain and
     recid(so_mstr) = so_recid.
   end.

   for each sod_det
   fields( sod_domain sod_site sod_nbr sod_line sod_qty_inv sod_part)
   no-lock  where sod_det.sod_domain = global_domain and
   sod_nbr = so_nbr  and
   sod_qty_inv <> 0:

      if using_line_charges then do:
         absl_exists = no.
         for each absl_det no-lock  where absl_det.absl_domain = global_domain
         and
            absl_abs_shipfrom = sod_site  and
            absl_order = so_nbr           and
            absl_ord_line = sod_line      and
            absl_inv_nbr = so_inv_nbr     and
            absl_confirmed:

            assign
               absl_exists = yes
               line_charges = line_charges + absl_ext_price.
         end. /* FOR EACH absl_det */

        if not absl_exists then do:
           for each sodlc_det no-lock  where sodlc_det.sodlc_domain =
           global_domain and
              sodlc_order = so_nbr  and
              sodlc_ord_line = sod_line:

              if sodlc_one_time and
                 sodlc_times_charged > 0 then next.

              line_charges = line_charges + sodlc_ext_price.
           end. /* FOR EACH sodlc_det */
        end. /* IF NOT absl_exists */
      end. /* IF using_line_charges */

      if using_container_charges then do:
         for each abscc_det no-lock
             where abscc_det.abscc_domain = global_domain and
               abscc_order = so_nbr
            and abscc_ord_line = sod_line
            and abscc_inv_post = no
            and abscc_inv_nbr = so_inv_nbr:
            cont_charges = cont_charges + (abscc_qty * abscc_cont_price).
         end.
      end. /* IF using_container_charges */
   end. /* FOR EACH sod_det */

 END PROCEDURE.
