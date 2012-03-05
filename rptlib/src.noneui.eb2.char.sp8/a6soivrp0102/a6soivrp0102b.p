/* soivrpb.p - PENDING INVOICE REGISTER LINE DISPLAY AND SUBTOTAL       */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.20.2.9.3.2 $                                                         */
/*V8:ConvertMode=Report                                                 */
/* REVISION: 7.4      LAST MODIFIED: 11/11/94   BY: afs *H593**/
/* REVISION: 7.4      LAST MODIFIED: 03/02/95   BY: kjm *F0LC**/
/* REVISION: 7.4      LAST MODIFIED: 03/13/95   BY: jxz *F0M3**/
/* REVISION: 7.4      LAST MODIFIED: 09/05/95   BY: jym *G0W9**/
/* REVISION: 7.4      LAST MODIFIED: 11/07/95   BY: ais *G0Z5**/
/* REVISION: 8.5      LAST MODIFIED: 07/20/95   BY: taf *J053**/
/* REVISION: 8.5      LAST MODIFIED: 04/24/96   BY: rxm *G1LW**/
/* REVISION: 8.5      LAST MODIFIED: 06/11/96   BY: *J0SD* Rob Wachowicz */
/* REVISION: 8.5      LAST MODIFIED: 08/15/96   BY: *G2CD* Suresh Nayak  */
/* REVISION: 8.5      LAST MODIFIED: 11/11/96   BY: *G2HX* Aruna Patil   */
/* REVISION: 8.5      LAST MODIFIED: 11/14/96   BY: *G2J1* Amy Esau      */
/* REVISION: 8.5      LAST MODIFIED: 04/29/97   BY: *J1Q4* Sanjay Patil  */
/* REVISION: 8.6      LAST MODIFIED: 10/04/97   BY: ckm *K0LD*           */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane     */
/* REVISION: 8.6E     LAST MODIFIED: 04/17/98   BY: *J2J6* A. Licha      */
/* REVISION: 8.6E     LAST MODIFIED: 04/30/98   BY: *J2LH* D. Tunstall   */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton  */
/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* REVISION: 8.6E     LAST MODIFIED: 07/13/98   BY: *L024* Bill Reckard  */
/* REVISION: 8.6E     LAST MODIFIED: 08/13/98   BY: *J2S3* Dana Tunstall */
/* REVISION: 8.6E     LAST MODIFIED: 09/24/98   BY: *L09L* Poonam Bahl   */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Murali Ayyagari  */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 05/02/00   BY: *N09M* Antony Babu      */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* myb              */
/* REVISION: 9.1      LAST MODIFIED: 09/26/00   BY: *K264* Manish K.        */
/* REVISION: 9.1      LAST MODIFIED: 10/13/00   BY: *N0W8* Mudit Mehta      */
/* Revision: 1.20.2.8 BY: Katie Hilbert  DATE: 04/01/01 ECO: *P002*         */
/* Revision: 1.20.2.9 BY: Niranjan R.    DATE: 03/12/02 ECO: *P020*         */
/* Revision: 1.20.2.9.3.1     BY: Gnanasekar  DATE: 08/18/03 ECO: *P0ZW*    */
/* $Revision: 1.20.2.9.3.2 $               BY: Ajay Nair   DATE: 03/30/04 ECO: *P1W7*    */
/* $Revision: 1.20.2.9.3.2 $               BY: Bill Jiang   DATE: 06/02/06 ECO: *SS - 20060602.1*    */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20060602.1 - B */
/*
1. 标准输入输出
2. 执行列表:
   a6soivrp0102.p
   a6soivrp0102a.p
   a6soivrp0102b.p,a6soivtrl20102.p
   a6soivtrlc0102.p
   a6soivtrl20102.i
   a6sototfrm0102.i
*/
/* SS - 20060602.1 - E */

/* SS - 20060602.1 - B */
DEFINE SHARED VARIABLE rec1 AS RECID.

{a6soivrp0102.i}

FIND tta6soivrp0102 WHERE RECID(tta6soivrp0102) = rec1 NO-LOCK NO-ERROR.
IF NOT AVAILABLE tta6soivrp0102 THEN DO:
   CREATE tta6soivrp0102.
END.
/* SS - 20060602.1 - E */

{mfdeclre.i}
{cxcustom.i "SOIVRPB.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{wbrp02.i}

define input-output parameter l_so_gl_line    like glt_line    no-undo.
define input-output parameter l_so_gltw_line  like gltw_line   no-undo.
define input-output parameter l_tot_amt       like glt_amt     no-undo.
define input-output parameter l_tot_ramt      like glt_amt     no-undo.
define input        parameter p_last_line     like mfc_logical no-undo.

define     shared variable rndmthd like rnd_rnd_mthd.
define     shared variable ext_price_fmt as character.
define     shared variable ext_gr_marg_fmt as character.
define     shared variable tot_base_amt like ar_amt.
define     shared variable tot_base_price as decimal
   format "->>>>,>>>,>>9.99".
define     shared variable tot_base_margin as decimal
   format "->>>>,>>>,>>9.99".
define     shared variable nbr like so_nbr.
define     shared variable nbr1 like so_nbr.
define     shared variable shipdate like so_ship_date.
define     shared variable shipdate1 like shipdate.
define     shared variable cust  like so_cust.
define     shared variable cust1 like so_cust.
define     shared variable bill  like so_bill.
define     shared variable bill1 like so_bill.
define     shared variable print_ready2inv  like mfc_logical
   initial yes.
define     shared variable print_ready2post like mfc_logical
   initial no.
define     shared variable inv_only like mfc_logical initial yes.
define     shared variable print_lotserials like mfc_logical
   label "Print Lot/Serial Numbers Shipped".
define     shared variable so_recno as recid.
define     shared variable sod_recno as recid.
define     shared variable gl_sum like mfc_logical.
define     shared variable eff_date as date.
define     shared variable post like mfc_logical.
define     shared variable already_posted like glt_amt.
define     shared variable tot_curr_amt like glt_amt.
define     shared variable ext_price as decimal label "Ext Price"
   format "->>>>,>>>,>>9.99".
define     shared variable ext_list like sod_list_pr.
define     shared variable ext_disc as decimal.
define     shared variable base_price as decimal
   format "->>>>,>>>,>>9.99".
define     shared variable base_margin as decimal
   format "->>>>,>>>,>>9.99".
define     shared variable exch_rate like so_ex_rate.
define     shared variable exch_rate2 like so_ex_rate2.
define     shared variable exch_ratetype like so_ex_ratetype.
define     shared variable exch_exru_seq like so_exru_seq.
define     shared variable undo_all like mfc_logical no-undo.
define     shared variable new_order like mfc_logical.
define     shared variable ref like glt_det.glt_ref.
define     shared variable batch like ar_batch.
define     shared variable curr_amt like glt_amt.
define     shared variable should_be_posted like glt_amt.
define     shared variable post_entity like ar_entity.
define     shared variable tax_recno as recid.
define     shared variable consolidate like mfc_logical initial false.
define     shared variable crtint_amt      like trgl_gl_amt.

define            variable name            like ad_name.
define            variable qty_bo          like sod_qty_ord
   label "Backorder".
define            variable net_price       like sod_price.
define            variable net_list        like sod_list_pr.
define            variable gr_margin       like sod_price
   label "Unit Margin".
   format "->>>>,>>>,>>9.99".
define            variable ext_gr_margin   like gr_margin
   label "Ext Margin"
   format "->>>>,>>>,>>9.99".
define            variable desc1           like pt_desc1
   format "x(49)".
define            variable lotserial_total like tr_qty_chg.
define            variable ship_name       like ad_name.
define            variable base_cost as decimal no-undo.
define new shared variable auto_balance_amount like glt_amt no-undo.

define shared frame sotot.
{etvar.i }
{etrpvar.i}
{etdcrvar.i}

{etsotrla.i}

{soivrpl2.i}  /* defs for soivtrl2.p addition */

find so_mstr where recid(so_mstr) = so_recno no-lock.
{&SOIVRPB-P-TAG1}

assign
   exch_rate  = so_ex_rate
   exch_rate2 = so_ex_rate2.
if (not so_fix_rate) and (so_curr <> base_curr)
then do:
   {gprunp.i "mcpl" "p" "mc-get-ex-rate"
                "(input  so_curr,
                  input  base_curr,
                  input  so_ex_ratetype,
                  input  so_ship_date,
                  output exch_rate,
                  output exch_rate2,
                  output mc-error-number)" }
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.

end. /* IF (NOT SO_FIX_RATE) AND .. */

/* SO header */
find ad_mstr where ad_addr = so_ship no-lock no-wait no-error.
if available ad_mstr then ship_name = ad_name.
else ship_name = "".

/* SS - 20060602.1 - B */
/*
if page-size - line-counter <= 6 then page.
do with frame h2:
   /* SET EXTERNAL LABELS */
   setFrameLabels(frame h2:handle).
   display
      skip(1)
      space(3)
      so_nbr
      so_ship
      ship_name no-label
      so_ord_date
      so_po label "P/O"
   with frame h2 side-labels width 132 no-box.
end. /* do with */
*/
ASSIGN
   tta6soivrp0102_so_nbr = so_nbr
   tta6soivrp0102_so_ship = so_ship
   tta6soivrp0102_ship_name = ship_name
   tta6soivrp0102_so_ord_date = so_ord_date
   tta6soivrp0102_so_po = so_po
   .
/* SS - 20060602.1 - E */

/* GET ORDER DETAIL  */
for each sod_det where (sod_nbr = so_nbr)
      and (sod_qty_inv <> 0 or not inv_only)
      no-lock break by sod_line
   with frame e width 132:

   if sod_qty_ord >= 0 then
      qty_bo = max(sod_qty_ord - sod_qty_ship, 0).
   else
      qty_bo = min(sod_qty_ord - sod_qty_ship, 0).
   assign
      net_price = sod_price
      net_list  = sod_list_pr
      ext_price = net_price
      ext_list  = net_list.

   /* ROUND OFF THE SALES ORDER PRICE AND THE LIST PRICE BEFORE   */
   /* CALCULATING THE EXTENDED PRICE AND THE EXTENDED LIST PRICE. */

   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output ext_price,
        input        rndmthd,
        output       mc-error-number)" }
   if mc-error-number <> 0
   then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.

   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output ext_list,
        input        rndmthd,
        output       mc-error-number)" }

   if mc-error-number <> 0
   then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.

   assign
      ext_price = ext_price * sod_qty_inv
      ext_list  = ext_list  * sod_qty_inv.

   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output ext_price,
        input        rndmthd,
        output       mc-error-number)" }
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.

   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output ext_list,
        input        rndmthd,
        output       mc-error-number)" }

   base_cost = sod_std_cost.
   if base_curr <> so_curr then
   do:

      {gprunp.i "mcpl" "p" "mc-curr-conv"
                    "(input  base_curr,
                      input  so_curr,
                      input  exch_rate2,
                      input  exch_rate,
                      input  base_cost,
                      input  false,  /* DO NOT ROUND */
                      output base_cost,
                      output mc-error-number)" }
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.
   end.

   assign
      gr_margin     = net_price - base_cost
      ext_gr_margin = gr_margin.

   /* ROUND OFF THE GROSS MARGIN BEFORE CALCULATING EXTENDED */
   /* GROSS MARGIN.                                          */

   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output ext_gr_margin,
        input        rndmthd,
        output       mc-error-number)" }
   if mc-error-number <> 0
   then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.

   ext_gr_margin = sod_qty_inv * ext_gr_margin.

   /*  ROUND EXT_GR_MARGIN */
   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output ext_gr_margin,
        input        rndmthd,
        output       mc-error-number)" }
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.
   assign
      base_price = ext_price
      base_margin = ext_gr_margin.

   /* CONVERT BASE_PRICE AND BASE_MARGIN TO BASE CURRENCY */
   if base_curr <> so_curr then do:

      {gprunp.i "mcpl" "p" "mc-curr-conv"
                    "(input  so_curr,
                      input  base_curr,
                      input  exch_rate,
                      input  exch_rate2,
                      input  ext_price,
                      input  true,  /* ROUND */
                      output base_price,
                      output mc-error-number)" }
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.

      {gprunp.i "mcpl" "p" "mc-curr-conv"
                    "(input  so_curr,
                      input  base_curr,
                      input  exch_rate,
                      input  exch_rate2,
                      input  ext_gr_margin,
                      input  true,  /* ROUND */
                      output base_margin,
                      output mc-error-number)" }
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.
   end.

   tot_base_price    = tot_base_price + base_price.
   tot_base_margin   = tot_base_margin + base_margin.

   accumulate (ext_price) (total).
   accumulate (ext_gr_margin) (total).

   desc1 = sod_desc.
   find pt_mstr where pt_part = sod_part no-lock no-wait no-error.
   if desc1 = "" and available pt_mstr then
      desc1 = pt_desc1 + " " + pt_desc2.

   ext_disc = ext_list - ext_price.

   /* GET POST_ENTITY FOR USE IN SOSOGLB */
   find first si_mstr where si_site = so_site no-lock no-error.
   if available si_mstr then post_entity = si_entity.
   else post_entity = glentity.

   /* UPDATE GL WORKFILE */
   sod_recno = recid(sod_det).
   so_recno = recid(so_mstr).

   if last(sod_line)
   then
      p_last_line = yes.
   else
      p_last_line = no.

   /* ADDED FOUR INPUT-OUTPUT PARAMETERS                   */
   /* L_SO_GL_LINE,L_SO_GLTW_LINE,L_TOT_AMT AND L_TOT_RAMT */
   /* ADDED FIFTH INPUT PARAMETER p_last_line TO ACCOMODATE THE   */
   /* LOGIC INTRODUCED IN gpcurcnv.i FOR HANDLING ROUNDING ISSUES */
   {gprun.i ""sosoglb.p""
      "(input-output l_so_gl_line,
        input-output l_so_gltw_line,
        input-output l_tot_amt,
        input-output l_tot_ramt,
        input        p_last_line)"}

   /* SS - 20060602.1 - B */
   /*
   display
      sod_line
      sod_part sod_um
      sod_acct
      sod_sub
      sod_cc
      sod_qty_inv
      string(sod_taxable) + "  " + sod_taxc @ taxandtaxc
      net_price
      ext_price
      ext_gr_margin
   with frame e down.

   put desc1 at 5 format "x(41)" qty_bo to 67.
   put sod_tax_usage  at 69.

   if sod_tax_env <> so_tax_env then do:
      down with frame e.
      put getTermLabelRtColon("TAX_ENVIRONMENT",21) + " "
         + sod_tax_env format "x(50)" at 60.
   end.
   */
   CREATE tt2.
   ASSIGN
      sod_line
      sod_part 
      sod_um
      sod_acct
      sod_sub
      sod_cc
      sod_qty_inv
      sod_taxable
      sod_taxc
      net_price
      ext_price
      ext_gr_margin
      desc1
      qty_bo
      sod_tax_usage
      sod_tax_env
      .
      
   /* SS - 20060602.1 - E */

   /* SS - 20060602.1 - B */
   /*
   /* Print Lot/Serial Numbers */
   if print_lotserials then do:
      /* MAKE SURE ORACLE DOES NOT PICK TR_TYPE INDEX */
      {&SOIVRPB-P-TAG2}
      for each tr_hist no-lock where tr_type <= "ISS-SO"
            and tr_type >= "ISS-SO"
            and tr_nbr = so_nbr
            and tr_rmks = ""
            and tr_line = sod_line
            and tr_serial <> ""
            {&SOIVRPB-P-TAG3}
            use-index tr_nbr_eff break by tr_serial
            by tr_expire:
         if first(tr_expire) then do:
            if page-size - line-counter < 1 then do:
               page.
               clear frame e all no-pause.

               display sod_part
                  dynamic-function('getTermLabelFillCentered' in h-label,
                  input "CONTINUE",
                  input 8,
                  input '*') @ sod_qty_inv

               with frame e.
               down 1 with frame e.
            end.

            put getTermLabel("LOT/SERIAL_NUMBERS_SHIPPED",26) + ":"
               format "x(27)" at 5
               space(1)
               getTermLabelRt("QUANTITY",6)  format "x(6)"
               space(3)
               getTermLabel("EXPIRE",10) format "x(10)"
               space(1)
               {gplblfmt.i
               &FUNC=getTermLabel(""REFERENCE"",18)
               }
               skip.

         end.

         if first-of(tr_expire) then lotserial_total = 0.
         lotserial_total = lotserial_total - tr_qty_loc.

         if last-of(tr_expire) and lotserial_total <> 0 then do:
            if page-size - line-counter < 1 then do:
               page.
               clear frame e all no-pause.

               display sod_part
                  dynamic-function('getTermLabelFillCentered' in h-label,
                  input "CONTINUE",
                  input 8,
                  input '*') @ sod_qty_inv

               with frame e.
               down 1 with frame e.
            end.

            put tr_serial at 7
                lotserial_total at 27
                tr_expire at 42
                tr_ref    at 54
                skip.
         end.
      end.
   end.  /* Print Lot/Serial Numbers */
   */
   /* SS - 20060602.1 - E */

   {mfrpchk.i}

end.
{wbrp04.i}
