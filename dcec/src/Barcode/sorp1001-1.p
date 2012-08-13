/* GUI CONVERTED from sorp1001.p (converter v1.78) Fri Oct 29 14:34:11 2004 */
/* sorp1001.p - SALES ORDER INVOICE PRINT FOR ENGLISH PRINT CODE "1"          */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.29.1.23.1.6 $                                                 */
/* REVISION: 5.0      LAST MODIFIED: 03/15/90   BY: MLB *B615*                */
/* REVISION: 6.0      LAST MODIFIED: 04/20/90   BY: ftb      *                */
/* REVISION: 6.0      LAST MODIFIED: 07/05/90   BY: WUG *D043*                */
/* REVISION: 5.0      LAST MODIFIED: 08/18/90   BY: MLB *B755*                */
/* REVISION: 6.0      LAST MODIFIED: 08/20/90   BY: MLB *D055*                */
/* REVISION: 6.0      LAST MODIFIED: 12/13/90   BY: dld *D257*                */
/* REVISION: 6.0      LAST MODIFIED: 12/21/90   BY: MLB *D238*                */
/* REVISION: 6.0      LAST MODIFIED: 01/04/90   BY: WUG *D288*                */
/* REVISION: 6.0      LAST MODIFIED: 03/12/91   BY: afs *D425*                */
/* REVISION: 6.0      LAST MODIFIED: 10/21/91   BY: afs *D903*                */
/* REVISION: 6.0      LAST MODIFIED: 11/26/91   BY: WUG *D953*                */
/* REVISION: 7.0      LAST MODIFIED: 11/29/91   BY: SAS *F017*                */
/* REVISION: 7.0      LAST MODIFIED: 02/11/92   BY: tjs *F191*                */
/* REVISION: 7.0      LAST MODIFIED: 03/28/92   BY: dld *F322*                */
/* REVISION: 7.0      LAST MODIFIED: 03/31/92   BY: sas *F277*                */
/* REVISION: 7.0      LAST MODIFIED: 04/02/92   BY: afs *F348*                */
/* REVISION: 7.0      LAST MODIFIED: 04/09/92   BY: emb *F369*                */
/* REVISION: 7.0      LAST MODIFIED: 04/16/92   BY: sas *F378*                */
/* REVISION: 7.0      LAST MODIFIED: 06/08/92   BY: tjs *F504*                */
/* REVISION: 7.3      LAST MODIFIED: 09/04/92   BY: afs *G047*                */
/* REVISION: 7.3      LAST MODIFIED: 12/03/92   BY: afs *G341*                */
/* REVISION: 7.3      LAST MODIFIED: 02/19/93   by: jms *G712*                */
/* REVISION: 7.3      LAST MODIFIED: 04/05/93   BY: tjs *G858*                */
/* REVISION: 7.4      LAST MODIFIED: 07/15/93   BY: jjs *H050*                */
/* REVISION: 7.4      LAST MODIFIED: 08/19/93   BY: pcd *H009*                */
/* REVISION: 7.4      LAST MODIFIED: 10/28/93   BY: cdt *H197*                */
/* REVISION: 7.4      LAST MODIFIED: 05/03/94   BY: cdt *FN91*                */
/* REVISION: 7.4      LAST MODIFIED: 06/03/94   BY: dpm *GK02*                */
/* REVISION: 7.4      LAST MODIFIED: 10/05/94   BY: rxm *GM88*                */
/* REVISION: 7.4      LAST MODIFIED: 11/18/94   BY: smp *FT80*                */
/* REVISION: 7.4      LAST MODIFIED: 11/30/94   BY: smp *GO65*                */
/* REVISION: 7.4      LAST MODIFIED: 03/14/95   BY: kjm *F0MY*                */
/* REVISION: 7.4      LAST MODIFIED: 03/24/95   BY: kjm *F0NZ*                */
/* REVISION: 8.5      LAST MODIFIED: 03/30/95   BY: nte *J042*                */
/* REVISION: 7.4      LAST MODIFIED: 05/31/95   BY: jym *G0ND*                */
/* REVISION: 7.4      LAST MODIFIED: 07/19/95   BY: bcm *F0RW*                */
/* REVISION: 7.4      LAST MODIFIED: 10/13/95   BY: rxm *G0Z9*                */
/* REVISION: 7.4      LAST MODIFIED: 10/20/95   BY: jym *G0XY*                */
/* REVISION: 8.5      LAST MODIFIED: 07/25/95   BY: taf *J053*                */
/* REVISION: 8.5      LAST MODIFIED: 01/05/96   BY: ais *G1J5*                */
/* REVISION: 8.5      LAST MODIFIED: 02/05/96   BY: ais *G0NX*                */
/* REVISION: 8.5      LAST MODIFIED: 04/11/96   BY: GWM *J0HW*                */
/* REVISION: 8.5      LAST MODIFIED: 04/12/96   BY: ais *G1QW*                */
/* REVISION: 8.5      LAST MODIFIED: 04/10/96   BY: *J04C* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 06/14/96   BY: *J0T0* Dennis Hensen      */
/* REVISION: 8.5      LAST MODIFIED: 06/26/96   BY: *J0WF* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 07/22/96   BY: *J0ZZ* T. Farnsworth      */
/* REVISION: 8.5      LAST MODIFIED: 08/07/96   BY: *G29K* Markus Barone      */
/* REVISION: 8.5      LAST MODIFIED: 11/14/96   BY: *G2J1* Amy Esau           */
/* REVISION: 8.5      LAST MODIFIED: 07/22/97   BY: *H1C9* Seema Varma        */
/* REVISION: 8.5      LAST MODIFIED: 08/19/97   BY: *J1Z0* Ajit Deodhar       */
/* REVISION: 8.5      LAST MODIFIED: 09/23/97   BY: *H1FM* Seema Varma        */
/* REVISION: 8.5      LAST MODIFIED: 10/20/97   BY: *H1F8* Nirav Parikh       */
/* REVISION: 8.5      LAST MODIFIED: 11/27/97   BY: *J273* Nirav Parikh       */
/* REVISION: 8.5      LAST MODIFIED: 12/30/97   BY: *J281* Manish K.          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 04/23/98   BY: *L00L* Adam Harris        */
/* REVISION: 8.6E     LAST MODIFIED: 05/05/98   BY: *L00T* Ed v.d.Gevel       */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 06/29/98   BY: *L024* Sami Kureishy      */
/* REVISION: 8.6E     LAST MODIFIED: 09/08/98   BY: *H1MZ* Poonam Bahl        */
/* REVISION: 8.6E     LAST MODIFIED: 10/15/98   BY: *J29B* Ajit Deodhar       */
/* REVISION: 8.6E     LAST MODIFIED: 02/01/99   BY: *L0D5* Robin McCarthy     */
/* REVISION: 8.6E     LAST MODIFIED: 04/13/99   BY: *J3CZ* Poonam Bahl        */
/* REVISION: 9.1      LAST MODIFIED: 09/08/99   BY: *N02P* Robert Jensen      */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Murali Ayyagari    */
/* REVISION: 9.1      LAST MODIFIED: 10/18/99   BY: *K23R* Sachin Shinde      */
/* REVISION: 9.1      LAST MODIFIED: 11/02/99   BY: *N04P* Robert Jensen      */
/* REVISION: 9.1      LAST MODIFIED: 03/06/00   BY: *N05Q* Luke Pokic         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 02/16/00   BY: *N06R* Denis Tatarik      */
/* REVISION: 9.1      LAST MODIFIED: 06/08/00   BY: *L0Z5* Ashwini G.         */
/* REVISION: 9.1      LAST MODIFIED: 06/28/00   BY: *N0DM* Rajinder Kamra     */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 11/07/00   BY: *L15K* Kaustubh K         */
/* Revision: 1.29.1.15      BY: Manisha Sawant    DATE: 12/07/00  ECO: *M0XL* */
/* Revision: 1.29.1.16      BY: BalbeerS Rajput   DATE: 10/14/00  ECO: *N0WB* */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.29.1.17      BY: Katie Hilbert     DATE: 04/01/01  ECO: *P002* */
/* Revision: 1.29.1.18      BY: Ellen Borden      DATE: 07/09/01  ECO: *P007* */
/* Revision: 1.29.1.19      BY: Jean Miller       DATE: 07/09/01  ECO: *P03Q* */
/* Revision: 1.29.1.20      BY: Patrick Rowan     DATE: 03/15/02  ECO: *P00G* */
/* Revision: 1.29.1.21      BY: Dipesh Bector     DATE: 01/14/03  ECO: *M21Q* */
/* Revision: 1.29.1.22      BY: Vandna Rohira     DATE: 04/28/03  ECO: *N1YL* */
/* Revision: 1.29.1.23      BY: Narathip W.       DATE: 05/21/03  ECO: *P0S8* */
/* Revision: 1.29.1.23.1.1  BY: Manish Dani       DATE: 06/24/03  ECO: *P0VZ* */
/* Revision: 1.29.1.23.1.2  BY: Shoma Salgaonkar  DATE: 09/18/03  ECO: *N2L5* */
/* Revision: 1.29.1.23.1.3  BY: Somesh Jeswani    DATE: 10/10/03  ECO: *P131* */
/* Revision: 1.29.1.23.1.4  BY: Shivaraman V.     DATE: 02/05/04  ECO: *P1MR* */
/* Revision: 1.29.1.23.1.5  BY: Prashant Parab    DATE: 04/05/04  ECO: *P1WT* */
/* $Revision: 1.29.1.23.1.6 $ BY: Bharath Kumar    DATE: 09/03/04  ECO: *P2J3* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Report                                                   */

/* THIS PROGRAM IS SIMILAR TO soiv1001.p. CHANGES DONE IN THIS          */
/* PROGRAM MAY ALSO NEED TO BE DONE IN soiv1001.p.                      */

/* IN ORDER TO AVOID LOCKING ISSUES DURING INVOICE PRINT OF    */
/* SINGLE/MULTIPLE ORDERS, SKIP THE LOCKED ORDER AND PRINT THE */
/* INVOICES FOR THE REMAINING ORDERS.                          */


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdeclre.i}
{cxcustom.i "SORP1001.P"}
{gplabel.i}

define new shared variable convertmode as character no-undo initial "report".
define new shared variable rndmthd like rnd_rnd_mthd.
define new shared variable old_sod_nbr like sod_nbr.
define new shared variable pages as integer.
define new shared variable so_recno as recid.
define new shared variable billto as character format "x(38)" extent 6.
define new shared variable soldto as character format "x(38)" extent 6.
define new shared variable print_invoice  like mfc_logical.
define new shared variable rmaso          like mfc_logical.
define new shared variable sacontract     like mfc_logical.
define new shared variable fsremarks as character format "x(60)".
define new shared variable ext_actual   like sod_price.
define new shared variable ext_margin   like sod_price.
define new shared variable comb_inv_nbr like so_inv_nbr.
define new shared variable consolidate  like mfc_logical initial true.
define new shared variable undo_trl2    like mfc_logical.
define new shared variable undo_txdetrp like mfc_logical.
define new shared variable new_order    like mfc_logical.
define new shared variable disc_prnt_label as character format "x(8)".

define shared variable cust  like ih_cust.
define shared variable cust1 like ih_cust.
define shared variable bill  like ih_bill.
define shared variable bill1 like ih_bill.
define shared variable conso like mfc_logical label "Consolidate Invoices".
define shared variable nbr   like so_nbr.
define shared variable nbr1   like so_nbr.

define shared variable inv_only as logical label "Print Only Lines to Invoice".
define shared variable print_lotserials as logical initial no
   label "Print Lot/Serial Numbers Shipped".
define shared variable msg like msg_desc.
define shared variable inv_date like so_inv_date.
define shared variable company as character format "x(38)" extent 6.
define shared variable shipdate like so_ship_date.
define shared variable shipdate1 like shipdate.
define shared variable addr as character format "x(38)" extent 6.
define shared variable print_options as logical initial no
   label "Print Features and Options".
define shared variable lang like so_lang.
define shared variable lang1 like lang.
define shared variable next_inv_nbr like soc_inv.

define shared variable call-detail  like mfc_logical
   label "Print Call Invoice Detail".
define shared variable incinv  like mfc_logical initial yes
   label "Include Invoices".
define shared variable incmemo like mfc_logical initial yes
   label "Include Credit Memos".
define shared variable order_nbrs     as character extent 30.
define shared variable order_nbr_list as character no-undo.

define variable termsdesc    like ct_desc.
define variable prepaid-lbl  as character format "x(12)".
define variable po-lbl       as character format "x(8)".
define variable lot-lbl      as character format "x(43)".
define variable cspart-lbl   as character format "x(15)".
define variable resale       like cm_resale format "x(20)".
define variable trl_length   as integer initial 11.
define variable hdr_po       as character format "x(38)".
define variable po-lbl2      as character format "x(16)".
define variable sales_entity like si_entity.
define variable col-80       like mfc_logical initial true.

{&SORP1001-P-TAG1}
{sodiscwk.i &new="new"} /* Shared workfile for summary discounts */

define variable l_inv_conso   like mfc_logical initial no no-undo.
define variable l_orig_invnbr like so_inv_nbr  initial "" no-undo.

define buffer somstr for so_mstr.
define buffer somstr2 for so_mstr.

define new shared frame sotot.

{soivtot1.i "NEW"}  /* Define variables for invoice totals. */


define variable hdr_call as character format "x(21)".
define variable call-lbl as character format "x(16)".
define variable prepaid_fmt as character no-undo.
define variable prepaid_old as character no-undo.
define variable oldsession as character no-undo.
define variable oldcurr like so_curr no-undo.
define variable tot_prepaid_amt like so_prepaid.
define variable hdl_sum_disc_lbl as handle.
define variable tax-tran-type    as character no-undo.
define variable l_consolidate    as logical initial no no-undo.
define variable l_msg_text       as character no-undo.
define variable l_ctrj           as integer no-undo.
define variable l_ctrk           as integer no-undo.
define variable l_so_nbr         like so_nbr no-undo.
define variable l_so_nbr2        like so_nbr no-undo.
define variable lgData           as logical no-undo initial no.
define variable l_nbr            like tx2d_nbr no-undo.
define variable tot_prepaid_nett like so_prepaid
   label "Total Prepaid" no-undo.
define variable tot_ptax_amt     like so_prepaid no-undo
   label "Prepaid Tax".
define variable amt_due_af_prep  like so_prepaid
   label "Amount Due" no-undo.

define variable add-trl-length      as integer no-undo.
define variable et_tot_prepaid_amt  like tot_prepaid_amt no-undo.
define variable et_tot_ptax_amt     like tot_prepaid_amt no-undo.
define variable et_tot_prepaid_nett like tot_prepaid_amt no-undo.
define variable et_amt_due_af_prep  like tot_prepaid_amt no-undo.
define variable price_fmt           as character no-undo.
define variable vlResult            like mfc_logical no-undo.
define variable vcCreditCardMsg as character format "x(80)" extent 3 no-undo.
define variable tot_cont_charge as decimal no-undo.
define variable tot_line_charge as decimal no-undo.
define variable c-cont          as character format "x(35)" no-undo.
{&SORP1001-P-TAG9}

c-cont = CAPS(dynamic-function('getTermLabelFillCentered' in h-label,
              input "CONTINUED",
              input 35,
              input '*')).


/* FORMS NEEDED FOR SOIVTRL2.P */
define new shared frame d.
FORM /*GUI*/   /* NOT USED DURING INVOICE PRINT */
   so_cr_init     colon 15
   so_inv_nbr     colon 40
   so_cr_card     colon 15
   so_to_inv      colon 40
   so_print_so    colon 63
   so_stat        colon 15
   so_invoiced    colon 40
   so_print_pl    colon 63
   so_rev         colon 15
   so_prepaid     colon 40
   so_fob         colon 15
   so_ar_acct     colon 40 so_ar_sub no-label so_ar_cc no-label
with STREAM-IO /*GUI*/  frame d side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

FORM /*GUI*/ 
   tot_prepaid_amt      colon 60
   tot_ptax_amt         colon 60
   tot_prepaid_nett     colon 60
   skip(1)
   amt_due_af_prep      colon 60
with STREAM-IO /*GUI*/  frame prepd width 80 side-labels.

/* SET EXTERNAL LABELS */
setFrameLabels(frame prepd:handle).

/* PREPAID EURO FRAME */
FORM /*GUI*/ 
   tot_prepaid_amt      colon 60
   et_tot_prepaid_amt   at 80 no-attr-space no-label
   tot_ptax_amt         colon 60
   et_tot_ptax_amt      at 80 no-attr-space no-label
   tot_prepaid_nett     colon 60
   et_tot_prepaid_nett  at 80 no-attr-space no-label
   skip(1)
   amt_due_af_prep      colon 60
   et_amt_due_af_prep   at 80 no-attr-space no-label
with STREAM-IO /*GUI*/  frame prepdeuro side-labels width 132 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame prepdeuro:handle).

{&SORP1001-P-TAG10}
FORM /*GUI*/  header
   fill("-",77)   format "x(77)" skip
   space(31)
   c-cont
   skip(8)
with STREAM-IO /*GUI*/  frame continue page-bottom width 80.

{&SORP1001-P-TAG11}
FORM /*GUI*/ 
   so_nbr        colon 15
   so_ship_date  colon 55
   so_ord_date   colon 15
   hdr_po        to 78    no-label
   so_slspsn[1]  colon 15 label "Salesperson(s)"
   so_slspsn[2]           no-label
   so_ship       colon 55
   so_slspsn[3]  at 17    no-label
   so_slspsn[4]           no-label
   so_shipvia    colon 55
   so_cr_terms   colon 15
   so_bol        colon 55
   termsdesc     at    17 no-label
   so_fob        colon 55
   resale        colon 15
   hdr_call      to 64 no-label
   so_rmks       colon 15
   skip(1)
with STREAM-IO /*GUI*/  frame phead2 side-labels width 90.

/* SET EXTERNAL LABELS */
setFrameLabels(frame phead2:handle).

{etvar.i}
{etrpvar.i &new="new"}
{etdcrvar.i "new"}

{etsotrla.i "NEW"}
{&SORP1001-P-TAG42}
{so10a01.i}

{fsconst.i}     /* FIELD SERVICE CONSTANTS */

FORM /*GUI*/ 
   l_nontaxable_lbl            to 12          view-as text   
                                        no-attr-space no-label
   nontaxable_amt                                     no-label
   so_curr
   line_total                  colon 60 no-attr-space
   et_line_total               at 80    no-attr-space no-label
   l_taxable_lbl               to 12          view-as text   
                                        no-attr-space no-label
   taxable_amt                                        no-label
   so_disc_pct                 to 49                  no-label
   disc_amt                    colon 60 no-attr-space
   et_disc_amt                 at 80    no-attr-space no-label
   tax_date            /*V8+*/       colon 10   
   user_desc[1]                to 53                  no-label
   so_trl1_cd format "x(2)"    to 58                  no-label
   ":"                         at 60
   so_trl1_amt                                        no-label
   et_trl1_amt                                        no-label
   container_charge_total
   user_desc[2]                to 53                  no-label
   so_trl2_cd format "x(2)"    to 58                  no-label
   ":"                         at 60
   so_trl2_amt                                        no-label
   et_trl2_amt                                        no-label
   line_charge_total
   user_desc[3]                to 53                  no-label
   so_trl3_cd format "x(2)"    to 58                  no-label
   ":"                         at 60
   so_trl3_amt                                        no-label
   et_trl3_amt                                        no-label
   invcrdt                     at 3                   no-label
   tax_amt                     colon 60
   et_tax_amt                  at 80                  no-label   skip
   tax_edit_lbl format "x(28)" to 30 no-attr-space no-label
   tax_edit                    at 32                  no-label
   ord_amt                     colon 60
   et_ord_amt                  at 80                  no-label    skip
with STREAM-IO /*GUI*/  frame sototeuro side-labels width 132 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame sototeuro:handle).

assign
   l_nontaxable_lbl = getTermLabelRtColon("NON-TAXABLE", 12)
   l_taxable_lbl    = getTermLabelRtColon("TAXABLE", 12).

FORM /*GUI*/ 
   vcCreditCardMsg[1] skip
   vcCreditCardMsg[2] skip
   vcCreditCardMsg[3]
with STREAM-IO /*GUI*/  frame soccmsg no-labels width 132 attr-space.

/* **NOTE: The customer has promised to pay using a credit card */
{pxmsg.i &MSGNUM=3867 &ERRORLEVEL=1 &MSGBUFFER=vcCreditCardMsg[1]}
/* The card used at order time will be processed for payment */
{pxmsg.i &MSGNUM=3868 &ERRORLEVEL=1 &MSGBUFFER=vcCreditCardMsg[2]}
/* Customer is responsible for payment if credit card is denied */
{pxmsg.i &MSGNUM=3869 &ERRORLEVEL=1 &MSGBUFFER=vcCreditCardMsg[3]}

/* Find out if Logistics is processing this invoice */
{gprun.i ""mgisact.p"" "(input 'lgarinv', output lgData)"}

hdl_sum_disc_lbl = prnt_sum_disc_amt:handle in frame disc_sum_print.

/* ASSIGN ORIGINAL FORMAT TO _OLD VARIABLES */
assign
   nontax_old = nontaxable_amt:format
   taxable_old = taxable_amt:format
   line_tot_old = line_total:format
   disc_old     = disc_amt:format
   trl_amt_old = so_trl1_amt:format
   tax_amt_old = tax_amt:format
   ord_amt_old = ord_amt:format
   prepaid_old = so_prepaid:format
   container_old = container_charge_total:format
   line_charge_old = line_charge_total:format.

find first sac_ctrl no-lock no-error.
find first rmc_ctrl no-lock no-error.
find first svc_ctrl no-lock no-error.

/* DEFINE VARIABLES FOR DISPLAY OF VAT REG NO & COUNTRY CODE */
{gpvtecdf.i &var="shared"}
{gpvtepdf.i &var=" "}

assign
   oldsession = SESSION:numeric-format
   maint = no
   pages = 0
   old_sod_nbr = ?.

if msg <> "" then trl_length = trl_length + 1.
if nbr1 = "" then nbr1 = hi_char.
if shipdate = ? then shipdate = low_date.
if shipdate1 = ? then shipdate1 = hi_date.
if lang1 = "" then lang1 = hi_char.
if cust1 = "" then cust1 = hi_char.
if bill1 = "" then bill1 = hi_char.

if (execname <> "rcsois.p" and
    execname <> "rcunis.p" and
    execname <> "socnuac.p")
    and not lgData
   /* Logistics has set up the list of orders like the rc programs */
then do:
   for first so_mstr where (so_nbr >= nbr and so_nbr <= nbr1)
         and (so_to_inv = yes)
         and (so_ship_date >= shipdate and so_ship_date <= shipdate1)
         and (so_cust >= cust and so_cust <= cust1)
         and (so_bill >= bill and so_bill <= bill1)
         and (so_lang >= lang and so_lang <= lang1)
   no-lock: end.

      if available(so_mstr)
      then do:
         so_recno = recid(so_mstr).
         run p_check_locked(input so_recno).
      end. /*  IF AVAILABLE so_mstr */

end. /* IF EXECNAME <>"RCSOIS.P" AND EXECNAME <> "RCUNIS.P"  */

else do:
   if lgData then conso = yes.
   l_ctrj = 1.
   /* OBTAINING FIRST SALES ORDER  FROM ORDER_NBR ARRAY IF         */
   /* INVOICE PRINT IS BEING RUN FROM PRE-SHIPPER/SHIPPER CONFIRM  */
   /* OR SHIPPER UNCONFIRM                                         */
   l_so_nbr = order_nbrs[l_ctrj].
   for first so_mstr where so_nbr = l_so_nbr
   no-lock: end .
end.

repeat while available so_mstr:

   /* CALL PROCEDURE p_consolidate TO FIND IF THERE EXIST PENDING */
   /* INVOICES REFERENCING SAME MANUALLY ENTERED INVOICE NUMBER   */
   assign
      l_inv_conso   = no
      l_orig_invnbr = "".

   if not conso
      and  so_inv_nbr <> ""
      and  so_invoiced = no
      and  so_to_inv   = yes
   then do:
      run p_consolidate (input nbr,
                         input nbr1,
                         input so_nbr,
                         input so_inv_nbr,
                         output l_inv_conso).

      if l_inv_conso = yes
      then
         l_orig_invnbr = so_inv_nbr.

   end. /* IF NOT conso AND... */

   /* THE BLOCKA HAS BEEN INTRODUCED AND THE NEXT STATEMENTS IN THE   */
   /* PROGRAM WHICH REFER TO THE OUTER REPEAT WHILE AVAILABLE so_mstr*/
   /* HAVE BEEN REPLACED BY THE STATEMENT LEAVE BLOCKA. THIS IS       */
   /* NECCESSARY, SINCE THE FIND NEXT so_mstr IS BEING DONE AT THE   */
   /* END OF THE REPEAT LOOP AS A RESULT OF WHICH, THE INVOICE PRINT */
   /* WENT INTO AN INFINITE LOOP FOR ALL CONDITIONS WHERE THE NEXT   */
   /* STATEMENT IS BEING USED                                        */
   blocka:
   do:
      /* THIS TEST IS INCLUDED TO PREVENT THE PROGRAM FROM RE-INVOICING */
      /* SALES ORDERS INCLUDED IN PREVIOUS CONSOLIDATIONS (EARLIER IN   */
      /* THIS LOOP).  IT SEEMS NECESSARY BECAUSE PROGRESS DOES NOT      */
      /* NECESSARILY UPDATE ALL INDEXES AT THE SAME TIME IT UPDATES     */
      /* DATA IN THE DATABASE.                                          */
      {&SORP1001-P-TAG2}
      if not so_to_inv then leave blocka.
      {&SORP1001-P-TAG3}

      /* IF LOGISTICS OWNS THE ORDER AND EXTERNAL INVOICING */
      /* IS ACTIVE, DO NOT PRINT AN INVOICE. */
      /* FLAG IT AS PRINTED AND MOVE ON. */
      /* THESE ORDERS ARE INVOICED BY ANOTHER SYSTEM.  MFG/PRO */
      /* IS KEEPING THE RECORDS, BUT NOT PROCESSING THE INVOICE. */
      if not lgData and so_app_owner > "" and
         so_trl1_amt = 0 and
         so_trl2_amt = 0 and
         so_trl3_amt = 0
      then do:
         /* See if External Invoicing is active */
         if can-find (lgs_mstr where lgs_app_id = so_app_owner
            and lgs_invc_imp = yes no-lock) then do:
            /* Finish it up without a print */
            so_recno = recid(so_mstr).
            {&SORP1001-P-TAG34}
           /* {gprun.i ""sosoina.p""}*/
            {&SORP1001-P-TAG35}
            leave blocka.
         end.
      end.

      if (oldcurr <> so_curr) or (oldcurr = "") then do:

         {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
            "(input so_curr,
              output rndmthd,
              output mc-error-number)"}
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4}
            leave blocka.
         end.

         /* DETERMINE CURRENCY DISPLAY AMERICAN OR EUROPEAN   */
         find rnd_mstr where rnd_rnd_mthd = rndmthd no-lock no-error.
         if not available rnd_mstr then do:
            {pxmsg.i &MSGNUM=863 &ERRORLEVEL=4}
            /* ROUND METHOD RECORD NOT FOUND */
            leave blocka.
         end.
         /* IF RND_DEC_PT = COMMA FOR DECIMAL POINT */
         /* THIS IS THE EUROPEAN STYLE CURRENCY. */
         if (rnd_dec_pt = ",")
         then SESSION:numeric-format = "European".
         else SESSION:numeric-format = "American".

         {socurfmt.i}
         prepaid_fmt = prepaid_old.
         {&SORP1001-P-TAG4}
         {gprun.i ""gpcurfmt.p"" "(input-output prepaid_fmt,
                                   input rndmthd)"}
         assign
            oldcurr = so_curr.
      end. /* IF (OLDCURR <> SO_CURR) */

      if can-find(qad_wkfl where qad_key1 = "sosois.p" + so_nbr
                             and qad_key2 = "BATCH" )
      then
         leave blocka.
      {&SORP1001-P-TAG5}

      /* FOR CALL INVOICES, USE TRANSACTION TYPE 38 INSTEAD OF 13 */
      if so_fsm_type = "FSM-RO" then
         tax-tran-type = "38".
      else
         tax-tran-type = "13".
      assign
         et_new_page = true.

      {soivtot2.i}  /* Initialize variables for invoice totals. */
      comb_inv_nbr     = "" .

      /* PRINT INVOICES, CREDITS, OR BOTH */
      /* THIS ENHANCEMENT REQUIRES AN IMMEDIATE CALL TO SOIVTRL TO GET */
      /* THE INVOICE TOTAL TO DETERMINE IF IT SHOULD BE PRINTED.       */
      if not incinv or not incmemo then do:

         so_recno = recid(so_mstr).
         /* TOTAL INVOICE */
         undo_trl2 = true.

         {gprun.i ""soivtrl2.p""
            "(input so_nbr,
              input '',
              input col-80 /* REPORT WIDTH */,
              input '13',
              input tot_cont_charge,
              input tot_line_charge,
              input l_consolidate)"}

         if undo_trl2 then leave blocka.

         /* INVOICE PRINT TEST */
         if not incinv and ord_amt >= 0 then leave blocka.
         /* CREDIT PRINT TEST */
         if not incmemo and ord_amt < 0 then leave blocka.

         {soivtot2.i}  /* Initialize variables for invoice totals. */

      end.

      assign
         rmaso         = no
         print_invoice = yes
         sacontract    = no.

      /* RMASO INDICATES AN RMA INVOICE */
      if so_fsm_type = rma_c then
         rmaso       = yes.

      /* IF "PRINT NO CHARGE RECEIPTS" (rmc_prt_rtn) IS NO, */
      /* AND THE RMA INVOICE HAS ONLY ZERO PRICED RECEIPT   */
      /* LINES, THEN WE DON'T PRINT THE INVOICE.            */
      if available rmc_ctrl  and
         not rmc_prt_rtn     and
         so_fsm_type = rma_c
      then do:

         assign
            print_invoice = no.

         for each sod_det
            where sod_nbr      = so_nbr
              and sod_qty_inv  <> 0
         no-lock:
            if sod_price     <>  0    or
               sod_rma_type  <> "I"
            then
               print_invoice =  yes.
         end.

         if  print_invoice = no then do:
            so_recno = recid(so_mstr).
            {&SORP1001-P-TAG36}
           /* {gprun.i ""sosoina.p""}*/
            {&SORP1001-P-TAG37}
            leave blocka.
         end.

      end.    /* if available rmc_ctrl */

      /* Identify if it's a service contract billing. */
      /* SACONTRACT INDICATES A SERVICE CONTRACT INVOICE */
      if so_fsm_type = "SC" then sacontract = yes.

      {&SORP1001-P-TAG12}
      find ct_mstr where ct_code = so_cr_terms no-lock no-error.
      if available ct_mstr then
         termsdesc = ct_desc.
      else
         termsdesc = "".

      find ad_mstr where ad_addr = so_bill no-lock no-wait no-error.
      update billto = "".
      if available ad_mstr then do:
         {&SORP1001-P-TAG13}
         assign
            addr[1] = ad_name
            addr[2] = ad_line1
            addr[3] = ad_line2
            addr[4] = ad_line3
            addr[6] = ad_country.
         {mfcsz.i addr[5] ad_city ad_state ad_zip}.
         {&SORP1001-P-TAG14}
         {gprun.i ""gpaddr.p"" }
         assign
            billto[1] = addr[1]
            billto[2] = addr[2]
            billto[3] = addr[3]
            billto[4] = addr[4]
            billto[5] = addr[5]
            billto[6] = addr[6].
         {&SORP1001-P-TAG15}

         /* Move the PO number up into the address window */
         /* (if it fits)                                  */
         hdr_po    = po-lbl2 + so_po.

         if addr[6]  <> ""
            and so_po = ""
         then
            billto[6] = addr[6].

         {&SORP1001-P-TAG16}
      end.    /* if available ad_mstr */

      find ad_mstr where ad_addr = so_cust no-lock no-wait no-error.
      update soldto = "".
      if available ad_mstr then do:
         {&SORP1001-P-TAG17}
         assign
            addr[1] = ad_name
            addr[2] = ad_line1
            addr[3] = ad_line2
            addr[4] = ad_line3
            addr[6] = ad_country.
         {mfcsz.i addr[5] ad_city ad_state ad_zip}.
         {&SORP1001-P-TAG18}
         {gprun.i ""gpaddr.p"" }
         assign
            soldto[1] = addr[1]
            soldto[2] = addr[2]
            soldto[3] = addr[3]
            soldto[4] = addr[4]
            soldto[5] = addr[5]
            soldto[6] = addr[6].
      end.    /* if available ad_mstr */

      /* FIND VAT NO FOR SHIP TO OR BILL TO IF SHIP TO VAT=" " */
      find ad_mstr where ad_addr = so_ship no-lock no-wait no-error.
      if available ad_mstr then do:
         if ad_pst_id = " " then do:
            find ad_mstr where ad_addr = so_bill no-lock no-wait no-error.
            if available ad_mstr then do:
               {gpvteprg.i}
            end.
         end.
         else do:
            {gpvteprg.i}
         end.
      end.    /* if available ad_mstr */

      /* GET SECOND CURRENCY FOR EURO DUAL CURRENCY PRINTING */
      /* CHANGED 2nd PARAMETER FROM so_cust TO so_bill */
      {etdcra.i so_curr so_bill}

      find cm_mstr where cm_addr = so_cust no-lock no-error.
      if available cm_mstr then
         resale = cm_resale.
      else
         resale = "".

      hdr_call = "".
      if rmaso then do.
         find first rma_mstr where rma_nbr = so_nbr
                               and rma_prefix = "C"
         no-lock no-error.
         if available rma_mstr then
            hdr_call = call-lbl + rma_ca_nbr.
      end.

      so_recno = recid(so_mstr).
      {&SORP1001-P-TAG38}
    /*  {gprun.i ""sosoina.p""}*/
      {&SORP1001-P-TAG39}

      {gprun.i ""txdelete.p""
         "(input '16',
           input so_inv_nbr,
           input so_nbr)" }

      if tax-tran-type = "38" then
         l_nbr = so_quote.
      else
         l_nbr = "".

      /* COPY tx2d_dets FROM SALES ORDER OR CALL INVOICE TO INVOICE */
      {gprun.i ""txdetcpy.p""
         "(input so_nbr,
           input l_nbr,
           input tax-tran-type,
           input so_inv_nbr,
           input so_nbr,
           input '16')"}

      {&SORP1001-P-TAG19}
      FORM /*GUI*/  header
         skip(3)
         company[1]    at 4
         getTermLabelRt("BANNER_INVOICE",25) to 80 format "x(25)"
         company[2]    at 4
         company[3]    at 4
         getTermLabelRtColon("INVOICE",14)   to 56 format "x(14)"
         so_inv_nbr    at 58
         getTermLabelRtColon("REVISION",10)  to 76 format "x(10)"
         so_rev        to 80
         company[4]    at 4
         getTermLabelRtColon("INVOICE_DATE",14) to 56 format "x(14)"
         inv_date      at 58
         getTermLabel("PAGE_OF_REPORT",5) + ": " +
            string(page-number - pages,">>9")
            format "x(9)" to 80
         company[5]    at 4
         getTermLabelRtColon("PRINT_DATE",14) to 56 format "x(14)" today at 58
         company[6]    at 4 skip(1)
         getTermLabel("BILL_TO",15) + ": " + so_bill at 8  format "x(25)"
         getTermLabel("SOLD_TO",15) + ": " + so_cust at 46 format "x(25)"
         skip(1)
         billto[1]      at 8
         soldto[1]      at 46
         billto[2]      at 8
         soldto[2]      at 46
         billto[3]      at 8
         soldto[3]      at 46
         billto[4]      at 8
         soldto[4]      at 46
         billto[5]      at 8
         soldto[5]      at 46
         billto[6]      at 8
         soldto[6]      at 46
         skip(2)
         covatreglbl to 15
         covatreg
         vatreglbl   to 55
         vatreg
      with STREAM-IO /*GUI*/  frame phead1 page-top width 90.

      view frame phead1.

      {&SORP1001-P-TAG20}
      if old_sod_nbr <> ? then page.

      pages = page-number - 1.

      {&SORP1001-P-TAG21}
      display
         so_nbr
         so_ship_date
         so_ord_date
         hdr_po
         so_slspsn[1]
         so_slspsn[2]
         so_ship
         so_slspsn[3]
         so_slspsn[4]
         so_shipvia
         so_cr_terms
         so_bol termsdesc
         so_fob
         hdr_call
         resale
         so_rmks
      with frame phead2 STREAM-IO /*GUI*/ .

      hide frame phead2.

      view frame continue.

      {&SORP1001-P-TAG22}
      if sacontract  then do:

         /* FOR SERVICE CONTRACT INVOICES, PRINT THE PERIOD  */
         /* OF COVERAGE BEING BILLED FOR, AND THE CONTRACT # */
         fsremarks = getTermLabel("FOR_PERIOD",25) + ": " +
                     string(so_req_date,"99/99/99")       +
                     " " + getTermLabel("TO",10) + ": "   +
                     string(so_due_date,"99/99/99").
         put
            fsremarks  at 15.

         fsremarks = getTermLabel("SERVICE_CONTRACT",35) + ": " + so_sa_nbr.
         put
            fsremarks at 15.

      end.    /* if sacontract */
      {&SORP1001-P-TAG23}

      {gpcmtprt.i &type=in &id=so_cmtindx &pos=3}

      put skip(1).
      {&SORP1001-P-TAG24}

      /* IF THIS INVOICE IS FOR AN RMA WHICH REFERENCES */
      /* A CALL, PRINT HEADER COMMENTS FROM THAT CALL   */
      if rmaso then do:
         if available rma_mstr then do:
            /* NOTE: CA_CATEGORY = "0" FOR CALLS, AND  */
            /*       "QUOTE" FOR CALL QUOTES.          */
            find first ca_mstr where ca_nbr = rma_ca_nbr
                                and ca_category = "0"
            no-lock no-error.
            if available ca_mstr then do:
               {&SORP1001-P-TAG25}
               put skip(1).
               {gpcmtprt.i &type=in &id=ca_cmtindx &pos=3}
               {&SORP1001-P-TAG26}
            end.  /* if available ca_mstr */
         end.  /* if available rma_mstr */
      end.  /* if rmaso */

      old_sod_nbr = so_nbr.

      /*Establish the label for the display of discounts*/
      if disc_det_key <> "1" then do:
         find first lngd_det where lngd_dataset begins "soprint"
            and lngd_field   = "det_disc_prnt"
            and lngd_lang    = global_user_lang
            and lngd_key1    = disc_det_key
         no-lock no-error.
         if available lngd_det then
            disc_prnt_label = lngd_translation.
      end.

      {gprun.i ""sorp1a01.p"" "(output tot_cont_charge,
                                output tot_line_charge)"}

      find si_mstr where si_site = so_site no-lock  no-error.

      assign
         sales_entity = if available si_mstr then si_entity
                        else glentity
         tot_prepaid_amt = 0
         tot_ptax_amt    = 0
         l_consolidate   = no.

      /*Check if this is a credit card order*/
      {gprunp.i "gpccpl" "p" "isCCOrder"
         "(input so_nbr, output vlResult)"}
      /*If it is then view credit card message frame*/
      if vlResult then
         display vcCreditCardMsg with frame soccmsg STREAM-IO /*GUI*/ .

      /* MOVED THE CODE FROM BELOW SO THAT THE TOTALS OF THE  */
      /* FIRST SALES ORDER ARE ACCUMULATED BEFORE CHECKING    */
      /* FOR ITS POSSIBLE CONSOLIDATIONS WITH THE REMAINING   */
      /* SALES ORDERS                                         */

      /* TOTAL ORDER, BUT DON'T PRINT THE DETAIL REPORT YET*/
      undo_trl2 = true.
      {gprun.i ""soivtrl2.p"" "(input so_inv_nbr,
                                input so_nbr,
                                input col-80 /* REPORT WIDTH */,
                                input '16',
                                input tot_cont_charge,
                                input tot_line_charge,
                                input l_consolidate)"}
      if undo_trl2 then return.

      {soivtot7.i}  /* ACCUMULATE INVOICE TOTALS */

      /* Check for consolable invoices */

      /* ADDED CONDITION TO ENTER LOOP IF CONSOLIDATE INVOICES IS NO */
      /* BUT MULTIPLE PENDING INVOICES REFERENCE SAME INVOICE NUMBER */
      if conso
         or (not conso and l_inv_conso)
      then do:

         if (execname <> "rcsois.p"  and
             execname <> "rcunis.p"  and
             execname <> "socnuac.p" and
             not lgData)
         then
         for each somstr2
            where (so_nbr >= so_mstr.so_nbr and so_nbr <= nbr1)
              and (so_to_inv = yes)
              and (so_ship_date >= shipdate and so_ship_date <= shipdate1)
              and (so_lang >= lang and so_lang <= lang1)
         no-lock by so_to_inv by so_nbr:

            /* ASSIGN TRANSACTION TYPE AS 38 FOR CALL INVOICES */
            if somstr2.so_fsm_type = "FSM-RO"
            then
               tax-tran-type = "38".
            else
               tax-tran-type = "13".

            if l_inv_conso
            then do:
               if l_orig_invnbr <> so_inv_nbr
               then
                  next.
            end. /* IF l_inv_conso */

            if not incinv or not incmemo
            then do:
               so_recno = recid(somstr2).
               /* GET THE INVOICE TOTAL */
               undo_trl2 = true.
               {gprun.i ""soivtrl2.p""
                  "(input comb_inv_nbr,
                    input so_nbr,
                    input col-80 /* REPORT WIDTH */,
                    input '16',
                    input tot_cont_charge,
                    input tot_line_charge,
                    input l_consolidate)"}

               if not incinv and ord_amt >= 0 then
                  next.

               if not incmemo and ord_amt < 0 then
                  next.

            end. /* IF NOT INCINV OR NOT INCMEMO */
            {&SORP1001-P-TAG6}

            run process-conso
               (input somstr2.so_nbr,
                input so_mstr.so_nbr,
                input so_mstr.so_inv_nbr) .

            if undo_trl2 then
               return.

         end. /* for each */

         else do for somstr2:

            l_ctrk = l_ctrj + 1.

            /* FOR CONSOLIDATIONS, OBTAINING SALES ORDER FROM ORDER_NBR   */
            /* ARRAY OR ORDER_NBR_LIST IF INVOICE PRINT IS BEING RUN FROM */
            /* PRE-SHIPPER/SHIPPER CONFIRM OR SHIPPER UNCONFIRM           */
            l_so_nbr2 = if (l_ctrk <= 30) then
                           order_nbrs[l_ctrk]
                        else
                           entry(l_ctrk - 30 ,order_nbr_list).

            for first somstr2 where so_nbr = l_so_nbr2
            no-lock: end.

            repeat while available somstr2 and somstr2.so_to_inv:

               run process-conso
                  (input somstr2.so_nbr,
                   input so_mstr.so_nbr,
                   input so_mstr.so_inv_nbr) .

               if undo_trl2 then
                  return.

               l_ctrk = l_ctrk + 1.

               /* OBTAIN NEXT SALES ORDER FROM ORDER_NBR ARRAY OR */
               /* THE ORDER_NBR_LIST                              */
               l_so_nbr2 = if (l_ctrk <= 30) then
                              order_nbrs[l_ctrk]
                           else
                              entry(l_ctrk - 30 ,order_nbr_list).

               for first somstr2 where so_nbr = l_so_nbr2
               no-lock: end.

            end. /* REPEAT WHILE AVAILABLE SOMSTR2 */

         end. /* IF EXECNAME = "RCSOIS.P" OR EXECNAME = "RCUNIS.P"  */

      end. /* IF CONSO */

      if can-find(mfc_ctrl where
                  mfc_module = "SO" and
                  mfc_seq = 170)
      then do:
         so_recno = recid(so_mstr).
         {gprun.i ""sorp10c.p""}
      end.

      {&SORP1001-P-TAG27}
      hide frame continue.
      {&SORP1001-P-TAG28}

      /*Establish the label for the display of discounts*/
      if disc_sum_key <> "1" and
         disc_sum_key <> disc_det_key
      then do:
         find first lngd_det where lngd_dataset begins "soprint"
            and lngd_field   = "det_disc_prnt"
            and lngd_lang    = global_user_lang
            and lngd_key1    = disc_sum_key
         no-lock no-error.
         if available lngd_det then
            disc_prnt_label = lngd_translation.
         else
            disc_prnt_label = "".
      end.

      /* Print discount summary, delete disc wkfl records */
      {sopiprn2.i}

      {&SORP1001-P-TAG7}
      /* TRAILER */
      if et_dc_print then trl_length = trl_length + 3.

      /*PRINT TRAILER*/
      so_recno = recid(so_mstr).

      /* DISPLAY TRAILER*/
      /* PRINT TAX DETAIL FOR ALL SALES ORDERS */
      /* FOR THIS INVOICE NUMBER USING 132 COLUMN */
      /* AND NO FORCED PAGE BREAK              */
      undo_txdetrp = true.

      /* ADDED SIXTH INPUT PARAMETER '' AND SEVENTH INPUT     */
      /* PARAMETER yes TO ACCOMMODATE THE LOGIC INTRODUCED IN */
      /* txdetrpa.i FOR DISPLAYING THE APPROPRIATE CURRENCY   */
      /* AMOUNT.                                              */

      {&SORP1001-P-TAG32}
      {gprun.i ""txdetrp.p"" "(input '16',
                               input so_inv_nbr,
                               input '*',
                               input col-80,
                               input trl_length, /* PAGE-BREAK */
                               input '',
                               input yes)"}
      {&SORP1001-P-TAG33}
      if undo_txdetrp then
         undo, leave.  /* FOR EACH SO_MSTR */

      /* LOAD PREPAYMENTS */
      if so_fsm_type = "PRM"
      then do:
         {gprunmo.i
            &module="PRM"
            &program="pjsoprep.p"
            &param="""(input so_nbr,
                       input so_inv_nbr)"""}
      end.

      assign
         tot_ptax_amt    = tot_ptax_amt + so_prep_tax
         tot_prepaid_amt = tot_prepaid_amt + so_prepaid
         add-trl-length  = if tot_prepaid_amt <> 0 then 5
                           else 0.

      {&SORP1001-P-TAG29}
      if page-size - line-counter < trl_length + add-trl-length then
         page.

      do while page-size - line-counter > trl_length + add-trl-length:
         put skip(1).
      end.

      {&SORP1001-P-TAG30}
      if msg <> "" then put msg skip.
      put
         "-----------------------------------------" +
         "-----------------------------------------" format "x(80)".

      {soivtot8.i}
      {&SORP1001-P-TAG31}

      price_fmt = "-zzzz,zzz,zz9.99".

      {gprun.i ""gpcurfmt.p"" "(input-output price_fmt,
                                input rndmthd)"}

      tot_prepaid_amt:format  in frame prepd = price_fmt.
      tot_ptax_amt:format     in frame prepd = price_fmt.
      tot_prepaid_nett:format in frame prepd = price_fmt.
      amt_due_af_prep:format  in frame prepd = price_fmt.

      if tot_prepaid_amt <> 0 then do:

         /* IF THERE HAS BEEN A ROUNDING ERROR, ADJUST */
         /* THE PREPAID TAX AMOUNT TO BALANCE IT OUT.  */
         if absolute(tot_ptax_amt - tax_amt) = .01 then
            tot_ptax_amt = tax_amt.

         assign
            tot_prepaid_nett = tot_prepaid_amt + tot_ptax_amt
            amt_due_af_prep  = invtot_ord_amt  - tot_prepaid_nett.

         if not et_dc_print then do:
            display
               tot_prepaid_amt
               tot_ptax_amt
               tot_prepaid_nett
               amt_due_af_prep
            with frame prepd STREAM-IO /*GUI*/ .
         end.
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

            tot_prepaid_amt:format  in frame prepdeuro = price_fmt.
            tot_ptax_amt:format     in frame prepdeuro = price_fmt.
            tot_prepaid_nett:format in frame prepdeuro = price_fmt.
            amt_due_af_prep:format  in frame prepdeuro = price_fmt.
            et_tot_prepaid_amt:format in frame prepdeuro =
               et_ord_amt:format.
            et_tot_ptax_amt:format in frame prepdeuro =
               et_ord_amt:format.
            et_tot_prepaid_nett:format in frame prepdeuro =
               et_ord_amt:format.
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
            with frame prepdeuro STREAM-IO /*GUI*/ .

         end.

      end.

      {etdcrh.i so_curr}

      page.

   end. /* BLOCKA */


   if (execname <> "rcsois.p"  and
       execname <> "rcunis.p"  and
       execname <> "socnuac.p" and
       not lgData)
   then do:
      find next so_mstr where
             (so_nbr >= nbr and so_nbr <= nbr1)
         and (so_to_inv = yes)
         and (so_ship_date >= shipdate and so_ship_date <= shipdate1)
         and (so_cust >= cust and so_cust <= cust1)
         and (so_bill >= bill and so_bill <= bill1)
         and (so_lang >= lang and so_lang <= lang1)
      no-lock no-error.

      if available so_mstr
      then do:
         so_recno = recid(so_mstr).
         run p_check_locked(input so_recno).
       end. /* IF AVAILABLE so_mstr */
   end. /* IF (EXECNAME <> "RCSOIS.P" AND EXECNAME <> "RCUNIS.P") */

   else do:
      l_ctrj = l_ctrj + 1.
      /* OBTAIN NEXT SALES ORDER FROM ORDER_NBR ARRAY OR */
      /* THE ORDER_NBR_LIST                              */
      l_so_nbr = if (l_ctrj <=  30) then
                    order_nbrs[l_ctrj]
                 else
                    entry(l_ctrj - 30 ,order_nbr_list).

      for first so_mstr where so_nbr = l_so_nbr
      no-lock: end.
   end. /* ELSE DO */

end.

SESSION:numeric-format = oldsession.

PROCEDURE process-conso:
/* THIS PROCEDURE PROCESSES CONSOLIDATIONS OF SALES ORDERS */

   /* INPUT PARAMETERS */
   define input parameter l_so_nbr3    like so_nbr     no-undo.
   define input parameter l_so_nbr     like so_nbr     no-undo.
   define input parameter l_so_inv_nbr like so_inv_nbr no-undo.

   /* BUFFERS */
   define buffer somstr3 for so_mstr.

   for first somstr3 where so_nbr = l_so_nbr3
   no-lock: end.

   /* PROCEDURE FOR CONSOLIDATION RULES */
   {gprun.i ""soconso.p"" "(input 1,
                            input l_so_nbr,
                            input somstr3.so_nbr,
                            output l_consolidate,
                            output l_msg_text)"}

   if l_consolidate then do:

      /* LOAD PREPAYMENTS */
      if so_fsm_type = "PRM"
      then do:
         {gprunmo.i
            &module="PRM"
            &program="pjsoprep.p"
            &param="""(input so_nbr,
                       input l_so_inv_nbr)"""}
      end.

      assign
         tot_prepaid_amt = tot_prepaid_amt + so_prepaid
         tot_ptax_amt    = tot_ptax_amt + so_prep_tax
         comb_inv_nbr    = l_so_inv_nbr.

      /* COPY TX2D_DET FROM SALES ORDER TO INVOICE */
      {gprun.i ""txdelete.p"" "( input '16',
                                 input comb_inv_nbr ,
                                 input so_nbr )" }

      if tax-tran-type = "38" then
         l_nbr = so_quote.
      else
         l_nbr = "".

      {gprun.i ""txdetcpy.p"" "(input so_nbr,
                                input l_nbr,
                                input tax-tran-type,
                                input comb_inv_nbr,
                                input so_nbr,
                                input '16')"}

      so_recno = recid(somstr3).
      {&SORP1001-P-TAG8}

      /* PRINT SALES ORDER LINES */
      {gprun.i ""sorp1a01.p"" "(output tot_cont_charge,
                                output tot_line_charge)"}
      /* TOTAL SALES ORDER */
      /* TOTAL ORDER, BUT DON'T PRINT THE DETAIL REPORT YET */
      undo_trl2 = true.
      {gprun.i ""soivtrl2.p"" "(input comb_inv_nbr,
                                input so_nbr,
                                input col-80,
                                input '16',
                                input tot_cont_charge,
                                input tot_line_charge,
                                input l_consolidate)"}
      if undo_trl2 then return.

      /* ACCUMULATE INVOICE TOTALS */
      {soivtot7.i}

      /* UPDATE SALES ORDER HEADER */
      {&SORP1001-P-TAG40}
    /*  {gprun.i ""sosoina.p""}*/
      {&SORP1001-P-TAG41}

   end. /* IF L_CONSOLIDATE */

END PROCEDURE.


/* THIS PROCEDURE CHECKS FOR MULTIPLE PENDING INVOICES REFERENCING */
/* SAME INVOICE NUMBER SO AS TO PROCEED FOR CONSOLIDATION EVEN IF  */
/* USER ENTERS CONSOLIDATE INVOICES AS NO.                         */
PROCEDURE p_consolidate:

   define input  parameter l_nbr1        like so_nbr      no-undo.
   define input  parameter l_nbr2        like so_nbr      no-undo.
   define input  parameter l_so_nbr      like so_nbr      no-undo.
   define input  parameter l_so_inv_nbr  like so_inv_nbr  no-undo.
   define output parameter l_multi_conso like mfc_logical no-undo.

   define buffer somstr4 for so_mstr.

   if can-find (first somstr4
      where somstr4.so_nbr >= l_nbr1
      and   somstr4.so_nbr <= l_nbr2
      and   somstr4.so_nbr <> l_so_nbr
      and   somstr4.so_inv_nbr = l_so_inv_nbr)
   then
      l_multi_conso = yes.

END PROCEDURE. /* p_consolidate */

/* PROCEDURE TO SKIP LOCKED ORDERS DURING INVOICE PRINT */

PROCEDURE p_check_locked:

   define input parameter l_so_recno as recid no-undo.

   find first so_mstr
      where recid(so_mstr) = l_so_recno
      exclusive-lock no-error no-wait.

   if locked so_mstr
   then do:
      find next so_mstr
         where (so_nbr >= nbr and so_nbr <= nbr1)
         and   (so_to_inv = yes)
         and   (so_ship_date >=shipdate and so_ship_date <= shipdate1)
         and   (so_cust >= cust and so_cust <= cust1)
         and   (so_bill >= bill and so_bill <= bill1)
         and   (so_lang >= lang and so_lang <= lang1)
         no-lock no-error.

      if available(so_mstr)
      then do:
         l_so_recno = recid(so_mstr).
         run p_check_locked(l_so_recno).
      end. /* IF AVAILABLE so_mstr */
   end. /* IF LOCKED so_mstr */

END PROCEDURE. /* p_check_locked */
