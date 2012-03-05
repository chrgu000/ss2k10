/* soivpst1.p - POST INVOICES TO AR AND GL REPORT                             */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.84 $                                                          */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 1.0      LAST MODIFIED: 03/11/86   BY: pml                       */
/* REVISION: 6.0      LAST MODIFIED: 04/20/90   BY: ftb *D002*                */
/* REVISION: 6.0      LAST MODIFIED: 07/11/90   BY: wug *D051*                */
/* REVISION: 6.0      LAST MODIFIED: 08/17/90   BY: mlb *D055*                */
/* REVISION: 6.0      LAST MODIFIED: 08/24/90   BY: wug *D054*                */
/* REVISION: 6.0      LAST MODIFIED: 11/01/90   BY: mlb *D162*                */
/* REVISION: 6.0      LAST MODIFIED: 12/21/90   BY: mlb *D238*                */
/* REVISION: 6.0      LAST MODIFIED: 12/06/90   BY: afs *D279*                */
/* REVISION: 6.0      LAST MODIFIED: 02/18/91   BY: afs *D354*                */
/* REVISION: 6.0      LAST MODIFIED: 02/28/91   BY: afs *D387*                */
/* REVISION: 6.0      LAST MODIFIED: 03/12/91   BY: afs *D424*                */
/* REVISION: 6.0      LAST MODIFIED: 03/12/91   BY: afs *D425*                */
/* REVISION: 6.0      LAST MODIFIED: 03/28/91   BY: afs *D464*                */
/* REVISION: 6.0      LAST MODIFIED: 04/04/91   BY: afs *D478* (rev only)     */
/* REVISION: 6.0      LAST MODIFIED: 04/29/91   BY: afs *D586* (rev only)     */
/* REVISION: 6.0      LAST MODIFIED: 05/08/91   BY: afs *D628* (rev only)     */
/* REVISION: 6.0      LAST MODIFIED: 08/12/91   BY: afs *D824* (rev only)     */
/* REVISION: 6.0      LAST MODIFIED: 08/14/91   BY: mlv *D825*                */
/* REVISION: 6.0      LAST MODIFIED: 10/09/91   BY: dgh *D892*                */
/* REVISION: 7.0      LAST MODIFIED: 10/30/91   BY: mlv *F029*                */
/* REVISION: 6.0      LAST MODIFIED: 11/26/91   BY: wug *D953*                */
/* REVISION: 7.0      LAST MODIFIED: 11/30/91   BY: sas *F017*                */
/* REVISION: 7.0      LAST MODIFIED: 04/06/92   BY: afs *F356*                */
/* REVISION: 7.0      LAST MODIFIED: 06/18/92   BY: tmd *F458*                */
/* REVISION: 7.0      LAST MODIFIED: 08/13/92   BY: sas *F850*                */
/* REVISION: 7.3      LAST MODIFIED: 09/04/92   BY: afs *G047*                */
/* REVISION: 7.3      LAST MODIFIED: 10/23/92   BY: afs *G230*                */
/* REVISION: 7.3      LAST MODIFIED: 12/21/92   BY: mpp *G484*                */
/* REVISION: 7.3      LAST MODIFIED: 01/21/93   BY: sas *G585*                */
/* REVISION: 7.3      LAST MODIFIED: 04/05/93   BY: tjs *G858*                */
/* REVISION: 7.3      LAST MODIFIED: 05/11/93   BY: tjs *GA65*                */
/* REVISION: 7.4      LAST MODIFIED: 07/21/93   BY: jjs *H050*                */
/* REVISION: 7.4      LAST MODIFIED: 08/19/93   BY: pcd *H009*                */
/* REVISION: 7.4      LAST MODIFIED: 10/23/93   BY: cdt *H184*                */
/* REVISION: 7.4      LAST MODIFIED: 11/16/93   BY: bcm *H226*                */
/* REVISION: 7.4      LAST MODIFIED: 03/01/94   BY: dpm *H075*                */
/* REVISION: 7.4      LAST MODIFIED: 04/13/94   BY: bcm *H338*                */
/* REVISION: 7.4      LAST MODIFIED: 04/15/94   BY: cdt *H353*                */
/* REVISION: 7.4      LAST MODIFIED: 04/29/94   BY: dpm *FN83*                */
/* REVISION: 7.4      LAST MODIFIED: 05/18/94   BY: dpm *FO10*                */
/* REVISION: 7.3      LAST MODIFIED: 06/02/94   BY: dpm *GK02*                */
/* REVISION: 7.4      LAST MODIFIED: 06/07/94   BY: dpm *FO66*                */
/* REVISION: 7.4      LAST MODIFIED: 09/13/94   BY: rwl *FR31*                */
/* REVISION: 7.4      LAST MODIFIED: 11/06/94   BY: qzl *FT41*                */
/* REVISION: 7.4      LAST MODIFIED: 11/08/94   BY: bcm *GO14*                */
/* REVISION: 7.4      LAST MODIFIED: 11/17/94   BY: rxm *FT54*                */
/* REVISION: 7.4      LAST MODIFIED: 03/13/95   BY: jxz *F0M3*                */
/* REVISION: 8.5      LAST MODIFIED: 03/29/95   BY: dpm *J044*                */
/* REVISION: 8.5      LAST MODIFIED: 08/23/95   BY: jym *F0TR*                */
/* REVISION: 8.5      LAST MODIFIED: 10/02/95   BY: jym *G0XY*                */
/* REVISION: 8.5      LAST MODIFIED: 11/07/95   BY: ais *F0VT*                */
/* REVISION: 8.5      LAST MODIFIED: 07/25/95   BY: taf *J053*                */
/* REVISION: 8.5      LAST MODIFIED: 04/03/96   BY: *J04C* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 04/24/96   BY: *G1LW* Robin McCarthy     */
/* REVISION: 8.5      LAST MODIFIED: 05/14/96   BY: *G1SG* Walt Koteke        */
/* REVISION: 8.5      LAST MODIFIED: 07/09/96   BY: *G1YS* Dwight Kahng       */
/* REVISION: 8.5      LAST MODIFIED: 08/01/96   BY: *J0ZZ* T. Farnsworth      */
/* REVISION: 8.6      LAST MODIFIED: 10/02/96   BY: svs *K007*                */
/* REVISION: 8.6      LAST MODIFIED: 10/18/96   BY: *K017* Jean Miller        */
/* REVISION: 8.6      LAST MODIFIED: 10/22/96   BY: *H0MY* Aruna P. Patil     */
/* REVISION: 8.6      LAST MODIFIED: 09/30/96   BY: *G2G2* Aruna P. Patil     */
/* REVISION: 8.6      LAST MODIFIED: 11/12/96   BY: *H0N9* Aruna P. Patil     */
/* REVISION: 8.5      LAST MODIFIED: 01/02/97   BY: *J1D7* Sue Poland         */
/* REVISION: 8.6      LAST MODIFIED: 03/13/97   BY: *K06M* Srinivasa(SVS)     */
/* REVISION: 8.6      LAST MODIFIED: 05/29/97   BY: *J1S9* Aruna P. Patil     */
/* REVISION: 8.6      LAST MODIFIED: 08/14/97   BY: *J1Z0* Ajit Deodhar       */
/* REVISION: 8.6      LAST MODIFIED: 09/23/97   BY: *H1FM* Seema Varma        */
/* REVISION: 8.6      LAST MODIFIED: 10/16/97   BY: *K0N1* Jean Miller        */
/* REVISION: 8.6      LAST MODIFIED: 11/20/97   BY: *J26P* Mandar K.          */
/* REVISION: 8.6      LAST MODIFIED: 11/27/97   BY: *J273* Nirav Parikh       */
/* REVISION: 8.6      LAST MODIFIED: 01/06/98   BY: *J297* Mandar K.          */
/* REVISION: 8.6      LAST MODIFIED: 12/23/97   BY: *K15N* Jim Williams       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 04/17/98   BY: *J2J6* A. Licha           */
/* REVISION: 8.6E     LAST MODIFIED: 04/15/98   BY: *L00L* Adam Harris        */
/* REVISION: 8.6E     LAST MODIFIED: 06/23/98   BY: *J2LD* Niranjan R.        */
/* Old ECO marker removed, but no ECO header exists *J0DV*                    */
/* REVISION: 8.6E     LAST MODIFIED: 07/08/98   BY: *L024* Sami Kureishy      */
/* REVISION: 8.6E     LAST MODIFIED: 08/10/98   BY: *J2VV* Rajesh Talele      */
/* REVISION: 8.6E     LAST MODIFIED: 08/31/98   BY: *J2S3* Dana Tunstall      */
/* REVISION: 8.6E     LAST MODIFIED: 08/31/98   BY: *H1LL* Dana Tunstall      */
/* REVISION: 8.6E     LAST MODIFIED: 09/08/98   BY: *H1MZ* Poonam Bahl        */
/* REVISION: 9.0      LAST MODIFIED: 09/29/98   BY: *J2CZ* Reetu Kapoor       */
/* REVISION: 9.0      LAST MODIFIED: 11/24/98   BY: *M017* David Morris       */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Murali Ayyagari    */
/* REVISION: 9.1      LAST MODIFIED: 12/03/99   BY: *K24M* Sachin Shinde      */
/* REVISION: 9.1      LAST MODIFIED: 12/17/99   BY: *J3MX* Surekha Joshi      */
/* REVISION: 9.1      LAST MODIFIED: 03/06/00   BY: *N05Q* Luke Pokic         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 01/25/00   BY: *N06R* Bud Woolsey        */
/* REVISION: 9.1      LAST MODIFIED: 04/21/00   BY: *N09J* Denis Tatarik      */
/* REVISION: 9.1      LAST MODIFIED: 05/08/00   BY: *J3P2* Manish K.          */
/* REVISION: 9.1      LAST MODIFIED: 05/11/00   BY: *N09V* John Pison         */
/* REVISION: 9.1      LAST MODIFIED: 05/30/00   BY: *N0C8* John Pison         */
/* REVISION: 9.1      LAST MODIFIED: 09/05/00   BY: *N0RF* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 09/15/00   BY: *N0RZ* Dave Caveney       */
/* REVISION: 9.1      LAST MODIFIED: 09/26/00   BY: *K264* Manish K.          */
/* REVISION: 9.1      LAST MODIFIED: 12/14/00   BY: *M0XT* Nikita Joshi       */
/* REVISION: 9.1      LAST MODIFIED: 01/02/01   BY: *J3Q3* Ashwini G.         */
/* REVISION: 8.6E     LAST MODIFIED: 01/24/01   BY: *L17C* Jean Miller        */
/* REVISION: 9.1      LAST MODIFIED: 10/14/00   BY: *N0W8* BalbeerS Rajput    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.72       BY: Katie Hilbert       DATE: 04/01/01  ECO: *P002*   */
/* Revision: 1.75       BY: Hualin Zhong        DATE: 06/01/01  ECO: *N0YR*   */
/* Revision: 1.77       BY: Steve Nugent        DATE: 07/09/01  ECO: *P007*   */
/* Revision: 1.78       BY: Nikita Joshi        DATE: 04/17/01  ECO: *L18Q*   */
/* Revision: 1.79       BY: Ed van de Gevel     DATE: 12/03/01  ECO: *N16R*   */
/* Revision: 1.80    BY: Jean Miller         DATE: 12/12/01  ECO: *P03N*   */
/* Revision: 1.83    BY: Niranjan R.  DATE: 03/12/02 ECO: *P020*   */
/* $Revision: 1.84 $          BY: Ellen Borden   DATE: 05/30/01  ECO: *P00G* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* ENCLOSED DISPLAY STATEMENTS IN 'DO ON ENDKEY UNDO, LEAVE'              */
/* LOOPS FOR CORRECT POSTING OF INVOICE WHEN F4 IS PRESSED AT             */
/* THE SPACEBAR PROMPT FOR OUTPUT DIRECTED TO TERMINAL                    */

{mfdeclre.i }
{cxcustom.i "SOIVPST1.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define input parameter abs_recid as recid no-undo.

define new shared variable convertmode as character no-undo initial "report".
define new shared variable rndmthd like rnd_rnd_mthd.

{soivpst.i "shared"}
{fsdeclr.i}
{etdcrvar.i "new"}

define new shared frame sotot.

{etsotrla.i "NEW"}

define variable w-first-key like so_mstr.so_inv_nbr   no-undo.
define variable w-first-pass as logical               no-undo.
define variable bill_name like ad_name                no-undo.
define variable ship_name like ad_name                no-undo.
define variable col-80 like mfc_logical initial false no-undo.
define variable err_flag as integer no-undo.

{soivtot1.i "NEW"}  /* Define variables for invoice totals. */

define new shared variable new_order like mfc_logical.
define new shared variable consolidate like mfc_logical initial true.
define new shared variable undo_trl2 like mfc_logical.
define new shared variable undo_txdetrp like mfc_logical.
define new shared variable crtint_amt      like trgl_gl_amt.
define new shared variable customer_sched like mfc_logical.
define new shared variable so_db like dc_name.
define new shared variable tot_inv_comm as decimal format "->>,>>9.99"
   extent 4 no-undo.
define new shared variable line_pricing like mfc_logical.
define new shared variable sonbr like sod_nbr.
define new shared variable soline like sod_line.
define new shared variable sopart like sod_part.

define shared variable prog_name as character no-undo.
define variable connect_db like dc_name no-undo.
define variable base_total like base_price no-undo.
define variable marg_total like base_margin no-undo.
define variable base_total_fmt as character no-undo.
define variable base_total_old as character no-undo.
define variable marg_total_fmt as character no-undo.
define variable marg_total_old as character no-undo.
define variable ext_price_fmt as character no-undo.
define variable ext_price_old as character no-undo.
define variable ext_gr_marg_fmt as character no-undo.
define variable ext_gr_marg_old as character no-undo.
define variable totstr as character no-undo.
define variable gltwdr_fmt as character no-undo.
define variable gltwdr_old as character no-undo.
define variable gltwdr as decimal format "->>>>,>>>,>>9.99" no-undo.
define variable gltwcr_fmt as character no-undo.
define variable gltwcr_old as character no-undo.
define variable gltwcr as decimal format "->>>>,>>>,>>9.99" no-undo.
define variable oldsession as character no-undo.
define variable oldcurr like so_curr no-undo.
define variable base_cost as decimal no-undo.
define variable promo_inv like so_inv_nbr no-undo.
define variable complete as logical no-undo.
define variable apm-ex-prg as character format "x(10)" no-undo.
define variable apm-ex-sub as character format "x(24)" no-undo.
define variable error_msg as character format "x(78)" no-undo.
define variable msgText as character format "x(78)" no-undo.
define variable msgNbr as integer no-undo.
define variable l_consolidate   as   logical initial no no-undo.
define variable l_so_nbr        like so_nbr  no-undo.
define variable mc-error-number like msg_nbr no-undo.
{&SOIVPST1-P-TAG1}
define variable err_mess_num    like msg_nbr     no-undo.
define variable error_flag      like mfc_logical no-undo.
define variable l_so_gl_line    like glt_line     no-undo.
define variable l_so_gltw_line  like gltw_line    no-undo.
define variable l_ar_gl_line    like glt_line     no-undo.
define variable l_ar_gltw_line  like gltw_line    no-undo.
define variable l_tot_amt       like glt_amt      no-undo.
define variable l_tot_ramt      like glt_amt      no-undo.
define variable l_tot_amt1      like glt_amt      no-undo.
define variable l_tot_ramt1     like glt_amt      no-undo.
define variable l_inv_nbr       like so_inv_nbr   no-undo.
define variable l_lastof        like mfc_logical  no-undo.
define variable l_so_curr       like so_curr      no-undo.
define variable cont_charges    as decimal format "->>>>>>>>>9.9999" no-undo.
define variable line_charges    like absl_lc_amt no-undo.
define variable avail_abs       like mfc_logical no-undo.
define variable l_rnd_tax_amt   like glt_amt     no-undo.
define variable l_rnd_tax_ramt  like glt_amt     no-undo.
define new shared variable auto_balance_amount like glt_amt no-undo.

define new shared frame d.

define buffer somstr for so_mstr.
define new shared workfile invoice_err no-undo
   field  inv_nbr  like so_inv_nbr
   field  ord_nbr  like so_nbr
   field  db_name  like dc_name.

{gldynrm.i}

define variable viar_recno       as recid      no-undo.
define variable success          as logical    no-undo.
define variable vglamt           like ar_amt   no-undo.
define variable cur-sonbr        like so_nbr   no-undo.
define variable postInvoice      as logical no-undo.
define variable cardProcessed    as logical no-undo.
define variable l_storefront_so  as logical no-undo.

/* DEFINE VARIABLES USED IN GPGLEF1.P (GL CALENDAR VALIDATION) */
{gpglefv.i}

{gpcrfmt.i}
{gpfilev.i} /* VARIABLE DEFINITIONS FOR gpfile.i */

define variable prepaid-amt like so_prepaid no-undo.
define variable amt-due  like so_prepaid no-undo.
define variable price_fmt as character no-undo.

form
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
with frame d side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

form
   space(3)
   sod_line
   sod_part      format "x(22)"
   sod_um
   sod_acct
   sod_sub
   sod_cc
   sod_qty_inv   column-label "Invoiced!Backorder"
   space(5)
   sod_taxable
   sod_taxc      no-label
   sod_price     format "->>>,>>>,>>9.99<<<"
   ext_price     label "Ext Price"
   ext_gr_margin format "->>>>,>>>,>>9.99"
with frame e width 132 down.

/* SET EXTERNAL LABELS */
setFrameLabels(frame e:handle).

form
   skip(1)
   totstr     format "x(19)"            to 60
   base_total                           to 113
   marg_total format "->>>>,>>>,>>9.99" to 130
   skip(1)
with frame rpttot no-labels width 132.

/*DEFINE FRAME FOR DISPLAYING GL TOTALS */
form
   gltw_entity format "x(4)" label "Enty"
   gltw_acct
   gltw_sub
   gltw_cc
   gltw_date
   dr_amt      label "Consolidated Dr"
   cr_amt      label "Consolidated Cr"
with frame gltwtot width 132 down no-labels.

find first gl_ctrl no-lock.

/* DETERMINE IF CONTAINER AND LINE CHARGES IS ENABLED */
{cclc.i}

/* CHECK IF APM DATABASE IS CONNECTED IF APM RUNNING */
if soc_apm then do:
   {ifapmcon.i "4500" "return"} /* APM DATABASE IS NOT CONNECTED */
end.
{&SOIVPST1-P-TAG14}
for each gltw_wkfl where gltw_userid = mfguser
exclusive-lock:
   {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
      "(input gltw_exru_seq)"}
   delete gltw_wkfl.
end.

/* ASSIGN ORIGINAL FORMAT TO _OLD VARIABLES */
assign
   nontax_old      = nontaxable_amt:format
   taxable_old     = taxable_amt:format
   line_tot_old    = line_total:format
   disc_old        = disc_amt:format
   trl_amt_old     = so_trl1_amt:format
   tax_amt_old     = tax_amt:format
   ord_amt_old     = ord_amt:format
   container_old   = container_charge_total:format
   line_charge_old = line_charge_total:format.

assign
   ext_price_old   = ext_price:format
   ext_gr_marg_old = ext_gr_margin:format
   gltwcr_old      = cr_amt:format
   gltwdr_old      = dr_amt:format
   marg_total_old  = marg_total:format
   base_total_old  = base_total:format.
{&SOIVPST1-P-TAG15}

maint = no.

oldsession = SESSION:numeric-format.

mainloop:
do on error undo, leave:

   form header
      (getTermLabel ("SALES_JOURNAL_REFERENCE",24)) + ": " format "x(24)"
      ref
      (getTermLabel ("AR_BATCH",9)) + ": " format "x(9)"
      batch
   with frame jrnl width 80 page-top.

   {&SOIVPST1-P-TAG2}

   /* FIND FIRST logic used to simulate FOR EACH logic because the inner
    * FOR EACH so_mstr loop deletes so_mstr records.  This changes the
    * index cursor position being used for the so_mstr table and caused
    * the earlier outer FOR EACH and FIRST-OF to act unpredictably under
    * V7 Progress (but not V6).  Changed selection criterion to so_inv_nbr > ""
    * rather than 'so_inv_nbr <> ""' for better index bracketing and added
    * back missing selection criteria (so_cust, so_bill). Lastly,
    * added USE-INDEX to ensure that the invoice number index is used. */

   assign
      w-first-pass = yes
      w-first-key = inv
      l_storefront_so = no.

   repeat:

      if w-first-pass then do:

         for first somstr
         fields (so_ar_acct so_ar_cc so_bill so_cr_card so_cr_init so_ar_sub
                 so_curr so_cust so_disc_pct so_exru_seq so_ex_rate
                 so_ex_rate2 so_ex_ratetype so_fix_rate so_fob
                 so_fsm_type so_invoiced so_inv_nbr so_nbr
                 so_ord_date so_po so_prepaid so_print_pl
                 so_print_so so_pst_pct so_rev so_ship so_ship_date
                 so_site so_slspsn so_stat so_tax_date so_tax_pct
                 so_to_inv so_trl1_amt so_trl1_cd so_trl2_amt
                 so_trl2_cd so_trl3_amt so_trl3_cd)
            where (so_inv_nbr > "")
              and (so_inv_nbr >= w-first-key)
              and (so_inv_nbr <= inv1)
              and (so_invoiced = yes)
              and (so_cust >= cust and so_cust <= cust1)
              and (so_bill >= bill and so_bill <= bill1)
              and (so_to_inv = no)
         use-index so_invoice no-lock:
         end.

         w-first-pass = no.

      end.

      else
      for first somstr
      fields (so_ar_acct so_ar_cc so_bill so_cr_card so_cr_init so_ar_sub
              so_curr so_cust so_disc_pct so_exru_seq so_ex_rate
              so_ex_rate2 so_ex_ratetype so_fix_rate so_fob
              so_fsm_type so_invoiced so_inv_nbr so_nbr
              so_ord_date so_po so_prepaid so_print_pl
              so_print_so so_pst_pct so_rev so_ship so_ship_date
              so_site so_slspsn so_stat so_tax_date so_tax_pct
              so_to_inv so_trl1_amt so_trl1_cd so_trl2_amt
              so_trl2_cd so_trl3_amt so_trl3_cd)
         where (so_inv_nbr > "")
           and (so_inv_nbr > w-first-key)
           and (so_inv_nbr <= inv1)
           and (so_invoiced = yes)
           and (so_cust >= cust and so_cust <= cust1)
           and (so_bill >= bill and so_bill <= bill1)
           and (so_to_inv = no)
      use-index so_invoice no-lock:
      end.

      if available somstr then do:

         {&SOIVPST1-P-TAG3}
         /* Changed W-FIRST-KEY logic to avoid using an appended
          * "!" since this may be unreliable; eg, a <space> falls
          * before "!" in the ASCII collating sequence, hence if the
          * invoice number sequence were "ABC", "ABC XYZ", "DEF",
          * "ABC XYZ" would be skipped.  Also, it's possible that
          * EBCIDIC and Code Pages may produce unexpected results.
          * Instead, change the FIND-FIRST clause to handle the first
          * pass into the REPEAT one way and all subsequent passes
          * another (discriminated by W-FIRST-KEY equaling INV or not). */

         w-first-key = somstr.so_inv_nbr.

         if (oldcurr <> so_curr) or (oldcurr = "") then do:

            /* GET ROUNDING METHOD FROM CURRENCY MASTER */
            {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
               "(input so_curr,
                 output rndmthd,
                 output mc-error-number)"}
            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
               next.
            end. /* if mc-error-number <> 0 */

            /* DETERMINE CURRENCY DISPLAY AMERICAN OR EUROPEAN */
            for first rnd_mstr
            fields (rnd_dec_pt rnd_rnd_mthd)
               where rnd_rnd_mthd = rndmthd
            no-lock: end.

            if not available rnd_mstr then do:
               /* Rounding method record not found */
               {pxmsg.i &MSGNUM=863 &ERRORLEVEL=3}
               next.
            end.

            /* RND_DEC_PT = COMMA FOR DECIMAL POINT */
            /* THIS IS THE EUROPEAN METHOD */
            if (rnd_dec_pt = ",") then
               SESSION:numeric-format = "European".
            else
               SESSION:numeric-format = "American".

            {&SOIVPST1-P-TAG16}
            {socurfmt.i} /* SET CURRENCY DEPENDENT FORMATS */

            /* SET CURRENCY FORMAT FOR EXT_PRICE */
            ext_price_fmt = ext_price_old.

            run gpcrfmt
               (input-output ext_price_fmt,
                input rndmthd).

            /* SET CURRENCY FORMAT FOR EXT_GR_MARGIN */
            ext_gr_marg_fmt = ext_gr_marg_old.

            run gpcrfmt
               (input-output ext_gr_marg_fmt,
                input rndmthd).
            {&SOIVPST1-P-TAG17}

            oldcurr = so_curr.

         end. /* IF (OLDCURR <> SO_CURR) */

         invoiceloop:
         do transaction on error undo , leave:

            assign
               l_tot_amt   = 0
               l_tot_ramt  = 0
               l_tot_amt1  = 0
               l_tot_ramt1 = 0.

            /* EXCLUSIVE-LOCKING THE SALES ORDER AT THE START OF THE  */
            /* TRANSACTION SO THAT INVOICE NUMBER REMAINS CONSISTENT  */
            /* THROUGHOUT INVOICE POST TRANSACTIONS(AR, GL, SO)       */
            {&SOIVPST1-P-TAG4}
            for each so_mstr where so_mstr.so_inv_nbr = somstr.so_inv_nbr
            exclusive-lock
            use-index so_invoice
            break by so_inv_nbr:

               for first invoice_err
               fields (db_name inv_nbr ord_nbr)
                  where inv_nbr = so_inv_nbr
               no-lock: end.

               if available invoice_err then leave.

               {&SOIVPST1-P-TAG5}
               so_recno = recid(so_mstr).
               {&SOIVPST1-P-TAG6}

               view frame jrnl.

               assign
                  already_posted  = 0
                  tot_curr_amt    = 0
                  tot_line_disc   = 0
                  name            = "" .

               if first-of(so_inv_nbr) then do:
                  assign
                     l_so_nbr      = so_nbr
                     l_consolidate = no.
                  {soivtot2.i}  /*Initialize variables for invoice totals*/
               end.

               for first ad_mstr
               fields (ad_addr ad_name)
                  where ad_addr = so_cust
               no-lock:
                  name = ad_name.
               end.

               for first ad_mstr
               fields (ad_addr ad_name)
                  where ad_addr = so_bill
               no-lock:
                  bill_name = ad_name.
               end.

               for first ad_mstr
               fields (ad_addr ad_name)
                  where ad_addr = so_ship
               no-lock:
                  ship_name = ad_name.
               end.

               /* GET THE POSTING ENTITY BASED ON THE SO HEADER SITE */
               for first si_mstr
               fields (si_db si_entity si_site)
                  where si_site = so_site
               no-lock: end.

               if available si_mstr then
                  post_entity = si_entity.
               else
                  post_entity = glentity.

               if first-of(so_inv_nbr) then do:

                  if page-size - line-counter <= 11 then
                  do on endkey undo, leave:
                     page.
                  end. /* DO ON ENDKEY UNDO, LEAVE */

                  do on endkey undo, leave:

                     form with frame h1 width 80.
                     /* SET EXTERNAL LABELS */
                     setFrameLabels(frame h1:handle).

                     display
                        so_inv_nbr
                        so_bill
                        bill_name
                        so_cust
                        name
                        so_slspsn[1] label "Salespsn"
                        so_slspsn[2] no-label
                        so_slspsn[3] no-label
                        so_slspsn[4] no-label
                     with frame h1 width 132.

                  end. /* DO ON ENDKEY UNDO, LEAVE */

               end.

               if page-size - line-counter <= 6 then
               do on endkey undo, leave:
                  page.
               end. /* DO ON ENDKEY UNDO, LEAVE */

               do on endkey undo, leave:

                  do with frame h2:

                     /* SET EXTERNAL LABELS */
                     setFrameLabels(frame h2:handle).

                     display
                        skip(1)
                        space(3)
                        so_nbr
                        so_ship
                        ship_name   no-label
                        so_ord_date
                        so_po       label "P/O"
                     with frame h2 side-labels width 132 no-box.

                  end. /* do with */

               end. /* DO ON ENDKEY UNDO, LEAVE */

               /* VERIFY OPEN GL PERIOD FOR SITE ENTITY */
               {gpglef2.i &module  = ""SO""
                  &entity  = post_entity
                  &date    = eff_date
                  &loop    = "invoiceloop" }

               /* Get current rate if SO rate is not fixed */
               if so_mstr.so_fix_rate = no then do:

                  /* Create usage records for posting; delete later. */
                  {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
                     "(input  so_curr,
                       input  base_curr,
                       input  so_ex_ratetype,
                       input  eff_date,
                       output exch_rate,
                       output exch_rate2,
                       output exch_exru_seq,
                       output mc-error-number)"}
                  if mc-error-number <> 0 then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4}
                     undo, retry.
                  end.

               end.
               /* Copy rate from SO if using fixed rate */
               else
                  assign
                     exch_rate     = so_mstr.so_ex_rate
                     exch_rate2    = so_mstr.so_ex_rate2
                     exch_exru_seq = so_mstr.so_exru_seq.

               avail_abs = no.

               for first abs_mstr where recid(abs_mstr) = abs_recid
               no-lock:
                  avail_abs = yes.
               end.

               if avail_abs and
                  (using_line_charges or using_container_charges)
               then do:
                   /* ASSIGN THE INVOICE NUMBER TO THE abs_mstr AND */
                   /* absl_det RECORDS BEING PROCESSED.             */
                   {gprunmo.i
                      &program = ""soivpst2.p""
                      &module = "ACL"
                      &param = """(input abs_recid,
                                   input so_inv_nbr)"""}
               end. /* IF AVAIL_ABS */

               /* TOTAL THE ORDER FOR TRAILER AND GL DETAIL */
               so_recno = recid(so_mstr).

               if (using_line_charges or using_container_charges)
               then do:
                  /* GET THE CONTAINER AND LINE CHARGE TOTALS */
                  /* AND PASS THEM TO soivtrl2.p SO THAT THEY */
                  /* CAN BE CALCULATED AND PRINTED ON THE     */
                  /* INVOICE POST TRAILER.                    */
                  {gprunmo.i
                     &program = ""soivpst3.p""
                     &module = "ACL"
                     &param = """(input so_recno,
                                  output cont_charges,
                                  output line_charges)"""}
               end. /* IF using_line_charges ... */

               /* TOTAL ORDER, BUT DON'T PRINT THE DETAIL */
               /* REPORT YET                              */
               undo_trl2 = true.

               {gprun.i ""txdelete.p""
                  "(input '16',
                    input so_inv_nbr,
                    input so_nbr)" }

               if so_fsm_type = "FSM-RO" then do:
                  {gprun.i ""txdetcpy.p""
                     "(input so_nbr,
                       input so_quote,
                       input '38',
                       input so_inv_nbr,
                       input so_nbr,
                       input '16')"}
               end. /* IF so_fsm_type = "FSM-RO" */
               else do:
                  {gprun.i ""txdetcpy.p""
                     "(input so_nbr,
                       input '',
                       input '13',
                       input so_inv_nbr,
                       input so_nbr,
                       input '16')"}
               end. /* IF so_fsm_type <> "FSM-RO" */

               {gprun.i ""soivtrl2.p""
                  "(input so_inv_nbr,
                    input so_nbr,
                    input col-80 /* REPORT WIDTH */,
                    input '16'   /* TRANSACTION TYPE */,
                    input cont_charges,
                    input line_charges)"}

               if undo_trl2 then return.

               assign crtint_amt = 0.

               {&SOIVPST1-P-TAG7}

               /* GET ORDER DETAIL  */
               for each sod_det
               fields (sod_acct sod_cc sod_crt_int sod_desc sod_line sod_sub
                       sod_list_pr sod_nbr sod_part sod_price
                       sod_pst sod_qty_inv sod_qty_ord sod_qty_ship
                       sod_site sod_std_cost sod_taxable sod_taxc
                       sod_tax_in sod_um)
                  where sod_nbr = so_nbr
                    and sod_line > 0
                    and sod_qty_inv <> 0
               break by sod_line with frame e width 132:

                  sod_recno = recid(sod_det).
                  {&SOIVPST1-P-TAG8}

                  /* CALL INVOICES (REPAIRS) SHOULD HAVE A ZERO QTY
                   * BACKORDERED.  OTHERWISE, CALCULATE IT... */
                  if so_fsm_type = "FSM-RO" then
                     qty_bo = 0.
                  else if sod_qty_ord >= 0 then
                     qty_bo = max(sod_qty_ord - sod_qty_ship, 0).
                  else
                     qty_bo = min(sod_qty_ord - sod_qty_ship, 0).

                  net_list = sod_list_pr.
                  net_price = sod_price.
                  {&SOIVPST1-P-TAG12}
                  {&SOIVPST1-P-TAG13}

                  ext_price = net_price * sod_qty_inv.

                  {gprunp.i "mcpl" "p" "mc-curr-rnd"
                     "(input-output ext_price,
                       input rndmthd,
                       output mc-error-number)"}
                  if mc-error-number <> 0 then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                  end.

                  ext_list  = net_list  * sod_qty_inv.

                  {gprunp.i "mcpl" "p" "mc-curr-rnd"
                     "(input-output ext_list,
                       input rndmthd,
                       output mc-error-number)"}
                  if mc-error-number <> 0 then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                  end.

                  assign
                     ext_disc = ext_list - ext_price
                     tot_line_disc = tot_line_disc + ext_disc
                     base_cost = sod_std_cost.

                  /* SOD_STD_COST IS STORED IN BASE - IF DIFFERENT FROM */
                  /* DOC CURRENCY CONVERT IT TO DOC TO CALCULATE GROSS  */
                  /* MARGIN IN DOC CURRENCY. */
                  if base_curr <> so_curr then do:
                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input base_curr,
                          input so_curr,
                          input so_ex_rate2,
                          input so_ex_rate,
                          input base_cost,
                          input false,
                          output base_cost,
                          output mc-error-number)"}
                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                     end.
                  end.

                  assign
                     gr_margin = net_price - base_cost
                     ext_gr_margin = sod_qty_inv * gr_margin.

                  /* ROUND PER DOCUMENT CURR ROUND METHOD */
                  {gprunp.i "mcpl" "p" "mc-curr-rnd"
                     "(input-output ext_gr_margin,
                       input rndmthd,
                       output mc-error-number)"}
                  if mc-error-number <> 0 then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                  end.

                  assign
                     base_price = ext_price
                     base_margin = ext_gr_margin.

                  if base_curr <> so_curr then do:

                     /* CONVERT BASE PRICE TO BASE CURRENCY */
                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input so_curr,
                          input base_curr,
                          input exch_rate,
                          input exch_rate2,
                          input base_price,
                          input true,  /* ROUND */
                          output base_price,
                          output mc-error-number)"}
                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                     end.

                     /* CONVERT BASE MARGIN TO BASE CURRENCY */
                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input so_curr,
                          input base_curr,
                          input exch_rate,
                          input exch_rate2,
                          input base_margin,
                          input true,  /* ROUND */
                          output base_margin,
                          output mc-error-number)"}
                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                     end.

                  end. /* IF BASE_CURR <> SO_CURR */

                  /* ACCUMULATE CREDIT TERMS INTEREST */
                  if sod_crt_int <> 0 then do:

                     crtint_amt = crtint_amt + (ext_price -
                                  (ext_price / ((sod_crt_int + 100) / 100))).

                     /* ROUND PER CURR ROUND METHOD */
                     {gprunp.i "mcpl" "p" "mc-curr-rnd"
                        "(input-output crtint_amt,
                          input rndmthd,
                          output mc-error-number)"}
                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                     end.

                  end.

                  accumulate (base_price) (total).
                  accumulate (base_margin) (total).
                  accumulate (ext_price) (total).
                  accumulate (ext_gr_margin) (total).

                  /* BASE_COST IS ACTUALLY STORED IN FOREIGN CURRENCY */
                  ext_cost = base_cost * sod_qty_inv.

                  /* ROUND PER FOREIGN CURR ROUND METHOD */
                  {gprunp.i "mcpl" "p" "mc-curr-rnd"
                     "(input-output ext_cost,
                       input rndmthd,
                       output mc-error-number)"}
                  if mc-error-number <> 0 then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                  end.

                  accumulate (ext_cost)  (total).

                  desc1 = sod_desc.

                  for first pt_mstr
                  fields (pt_desc1 pt_desc2 pt_part)
                     where pt_part = sod_part
                  no-lock: end.

                  if desc1 = "" and available pt_mstr then
                     desc1 = pt_desc1 + " " + pt_desc2.

                  /* UPDATE GL WORKFILE */
                  undo_all = no.

                  {gprun.i ""sosoglb.p""
                     "(input-output l_so_gl_line,
                       input-output l_so_gltw_line,
                       input-output l_tot_amt,
                       input-output l_tot_ramt)" }

                  if undo_all then undo invoiceloop , leave.

                  ext_price:format = ext_price_fmt.
                  ext_gr_margin:format = ext_gr_marg_fmt.

                  do on endkey undo, leave:

                     display
                        sod_line
                        sod_part
                        sod_um
                        sod_acct sod_cc
                        sod_sub
                        sod_qty_inv
                        sod_taxable sod_taxc
                        net_price @ sod_price
                        ext_price
                        ext_gr_margin
                     with frame e.

                     down 1 with frame e.

                  end. /* DO ON ENDKEY UNDO, LEAVE */

                  if desc1 <> "" then
                  do on endkey undo, leave:
                     put desc1 at 8.
                  end. /* DO ON ENDKEY UNDO, LEAVE */

                  do on endkey undo, leave:
                     put qty_bo to 68.
                  end. /* DO ON ENDKEY UNDO, LEAVE */

                  if desc1 <> ""  then
                  do on endkey undo, leave:
                     put skip.
                  end. /* DO ON ENDKEY UNDO, LEAVE */

                  /* Print Lot/Serial Numbers */
                  if print_lotserials then do:

                     /* CHANGE DATABASES IF USING MULTI-DB TO LOCATE tr_hist */
                     so_db = global_db.

                     for first si_mstr
                     fields (si_db si_entity si_site)
                        where si_site = sod_site
                     no-lock: end.

                     if si_db <> so_db then do:
                        {gprun.i ""gpalias3.p"" "(si_db, output err_flag)" }
                        {soivconn.i invoiceloop yes}
                     end.

                     assign
                        sonbr = sod_nbr
                        soline = sod_line
                        sopart = sod_part.

                     undo_all = no.

                     {gprun.i ""soivpste.p""}

                     if undo_all then undo invoiceloop , leave.

                     /* RESET THE DB ALIAS TO THE SALES ORDER DATABASE */
                     if si_db <> so_db then do:
                        {gprun.i ""gpalias3.p"" "(so_db, output err_flag)" }
                        {soivconn.i invoiceloop no}
                     end.

                  end.

                  /* UPDATE AR DETAIL */
                  undo_all = no.

                  {gprun.i ""soivpstb.p""}

                  if undo_all then undo invoiceloop , leave.

               end. /* for each sod_det */

               tot_ext_cost = accum total (ext_cost).

               if so_nbr <> l_so_nbr then
                  l_consolidate = yes.

               {soivtot7.i}

               /* Display Trailer */
               /* (Only display trailer after all SOs for this invoice */
               /* have been printed.)                                  */
               if last-of(so_inv_nbr) then do:

                  assign
                     l_inv_nbr = so_inv_nbr
                     l_lastof  = yes
                     l_so_curr = so_curr .

                  /* PRINT TAX DETAIL FOR ALL SALES ORDERS */
                  /* FOR THIS INVOICE NUMBER USING 132 COL */
                  /* AND NO FORCED PAGE BREAK              */
                  undo_txdetrp = true.

                  {gprun.i ""txdetrp.p""
                     "(input '16',
                       input so_inv_nbr,
                       input '*',
                       input col-80,
                       input 0)"}

                  if undo_txdetrp then undo invoiceloop, leave.

                  {soivtot8.i}

                  if so_fsm_type = "PRM" and so_prepaid <> 0 then do:

                     assign
                        prepaid-amt = so_prepaid + so_prep_tax
                        amt-due = invtot_ord_amt - prepaid-amt
                        price_fmt = "-zzzz,zzz,zz9.99".

                     {gprun.i ""gpcurfmt.p""
                        "(input-output price_fmt,
                          input rndmthd)"}

                     form
                        so_prepaid  colon 15
                        prepaid-amt colon 60 label "Total Prepaid"
                        skip
                        so_prep_tax colon 15
                        "-----------------" at 61
                        skip
                        amt-due     colon 60 label "Amount Due"
                     with frame prep-frame side-labels width 80.

                     /* SET EXTERNAL LABELS */
                     setFrameLabels(frame prep-frame:handle).

                     assign
                        so_prepaid  :format
                           in frame prep-frame = price_fmt
                        prepaid-amt :format
                           in frame prep-frame = price_fmt
                        so_prep_tax :format
                           in frame prep-frame = price_fmt
                        amt-due     :format
                           in frame prep-frame = price_fmt.

                     do on endkey undo, leave:
                        display
                           so_prepaid
                           prepaid-amt
                           so_prep_tax
                           amt-due
                        with frame prep-frame.
                     end. /* DO ON ENDKEY UNDO, LEAVE */

                     assign
                        prepaid-amt = 0
                        amt-due = 0.

                  end. /* IF SO_FSM_TYPE = "PRM" */

               end. /* if last-of(so_inv_nbr) */

               /* GLTRANS WORKFILE POST */
               undo_all = no.

               {gprun.i ""sosogla.p""
                  "(input-output l_ar_gl_line,
                    input-output l_ar_gltw_line,
                    input-output l_tot_amt,
                    input-output l_tot_ramt,
                    input cont_charges,
                    input line_charges)" }

               if undo_all then undo invoiceloop , leave.

               if last-of (so_inv_nbr) then do:

                  assign
                     l_rnd_tax_ramt = 0
                     l_rnd_tax_amt  = 0.

                  /* ACCUMULATING TAX TOTALS */
                  for each tx2d_det
                  fields(tx2d_cur_tax_amt tx2d_ref tx2d_tax_amt tx2d_tr_type)
                     where tx2d_ref     = so_inv_nbr
                     and   tx2d_tr_type = "16"
                  no-lock:
                     assign
                        l_rnd_tax_amt  = l_rnd_tax_amt
                                       + tx2d_cur_tax_amt
                        l_rnd_tax_ramt = l_rnd_tax_ramt
                                       + tx2d_tax_amt.
                  end. /* FOR EACH tx2d_det */

                  assign
                     l_tot_amt  = l_tot_amt  - l_rnd_tax_amt
                     l_tot_ramt = l_tot_ramt - l_rnd_tax_ramt.

                  /* CONVERT L_TOT_AMT TO BASE_CURRENCY */
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

                  if l_tot_amt <> l_tot_ramt
                  then do:
                     /* ADJUST THE SO ACCT FOR THE LAST INVOICE */
                     find glt_det where
                          glt_ref   = ref
                      and glt_rflag = false
                      and glt_line  = l_so_gl_line
                     exclusive-lock no-error.
                     if available glt_det then
                        glt_amt = glt_amt + (l_tot_amt - l_tot_ramt).

                     /* ADJUST THE AR ACCT FOR THE LAST INVOICE */
                     find glt_det where
                          glt_ref   = ref
                      and glt_rflag = false
                      and glt_line  = l_ar_gl_line
                     exclusive-lock no-error.
                     if available glt_det then
                        glt_amt = glt_amt - (l_tot_amt - l_tot_ramt).

                     for each gltw_wkfl where
                              gltw_userid = mfguser
                          and gltw_ref    = mfguser
                     exclusive-lock:
                        if gltw_line = l_so_gltw_line then
                           gltw_amt = gltw_amt  + (l_tot_amt - l_tot_ramt).
                        if gltw_line = l_ar_gltw_line then
                           gltw_amt = gltw_amt - (l_tot_amt - l_tot_ramt).
                     end. /* FOR EACH GLTW_WKFL */

                  end. /* IF L_TOT_AMT <> L_TOT_RAMT */

               end. /* IF LAST-OF (SO_INV_NBR)  */

               /* Check to see if we should create installed base  */
               /* SERVICE CONTRACT ORDERS AND CALL INVOICE (REPAIR */
               /* ORDERS) DO NOT UPDATE THE INSTALLED BASE.        */
               if insbase then do:
                  if so_fsm_type begins "SC"
                  or so_fsm_type = "FSM-RO"
                     then .
                  else do:
                     undo_all = no.
                     {gprun.i ""fsivpcfa.p""}
                     if undo_all then undo invoiceloop , leave.
                  end.
               end.

               /* FOR CALL INVOICES, CREATE GL TRANSACTIONS TO */
               /* CREDIT WIP AND DEBIT COGS.                   */
               if so_fsm_type = "FSM-RO" then do:

                  if not available sac_ctrl then
                  for first sac_ctrl
                  fields (sac_sa_pre)
                  no-lock: end.

                  {gprun.i ""fsivpcfb.p""
                     "(input so_nbr,
                       input sac_sa_pre,
                       input eff_date)"}

               end.   /* if so_fsm_type= "FSM-RO" */

               /* FOR PRM INVOICES, CREATE GL TRANSACTIONS TO   */
               /* CREDIT WIP AND DEBIT COGS FOR ALL PROJ LINES  */
               if so_fsm_type = "PRM" then do:

                  /* WIP -> COGS GL BOOKINGS */
                  {gprunmo.i
                     &module="PRM"
                     &program="pjivpst.p"}

                  /* ARCHIVE SFB_DET FOR INVOICE REPRINT */
                  {gprunmo.i
                     &module="PRM"
                     &program="pjsfbdet.p"
                     &param="""(input so_nbr)"""}

               end. /* IF SO_FSM_TYPE = "PRM" */

               cur-sonbr = so_nbr.

               /* UPDATE AR MASTER FILE AND DELETE ORDER */
               /* INVOICE NUMBER HAS TO BE STORED IN CASE OF SO DELETION */
               assign promo_inv = if last-of(so_inv_nbr) then so_inv_nbr
                                  else ""
                      undo_all = no.

               /* ADDED FOURTH AND FIFTH INPUT-OUTPUT PARAMETER */
               /* L_TOT_AMT1 AND L_TOT_RAMT1 RESPECTIVELY       */
               {gprun.i ""soivpsta.p""
                  "(input l_consolidate,
                    output viar_recno,
                    output vglamt,
                    input-output l_tot_amt1,
                    input-output l_tot_ramt1)" }

               if l_lastof then do:

                  l_lastof = no.

                  /* CONVERT L_TOT_AMT1 TO BASE CURRENCY */
                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input  l_so_curr,
                       input  base_curr,
                       input  exch_rate,
                       input  exch_rate2,
                       input  l_tot_amt1,
                       input  true, /* ROUND */
                       output l_tot_amt1,
                       output mc-error-number)" }
                  if mc-error-number <> 0 then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                  end. /* IF MC-ERROR-NUMBER <> 0 */

                  if l_tot_amt1 <> l_tot_ramt1
                  then do:
                     find ar_mstr where ar_nbr = l_inv_nbr
                     exclusive-lock no-error.
                     if available ar_mstr then
                        ar_base_amt = ar_base_amt - (l_tot_ramt1 - l_tot_amt1).
                  end. /* IF L_TOT_AMT1 <> L_TOT_RAMT1 */

               end. /* IF L_LASTOF */

               if undo_all then do:

                  /* Error occurred. Invoice processing terminated */
                  {pxmsg.i &MSGNUM=2197 &ERRORLEVEL=4 &MSGBUFFER=error_msg}.

                  display
                     skip(3)
                     error_msg
                     skip(3)
                  with frame unpost no-labels width 80.

                  undo invoiceloop , leave.

               end.

               /* Decide if we need to use credit card and */
               /* if we do then make a payment             */
               run processCreditCard
                  (output cardProcessed,
                   output success,
                   output msgNbr).

               if cardProcessed then do:

                  l_storefront_so = yes.

                  if success = false then do:

                     /*  No MFG/PRO errors occurred but Cybercash*/
                     /*  returned an error - post invoice anyway*/
                     if msgNbr = 0 then do:
                        /* Cybercash transaction was not successful*/
                        {pxmsg.i &MSGNUM=3810 &ERRORLEVEL=2 &MSGBUFFER=msgText}
                        /* Invoice posted but Cybercash returned an error*/
                        {pxmsg.i &MSGNUM=3490 &ERRORLEVEL=2 &MSGBUFFER=error_msg}
                        postInvoice = true.
                     end.

                     /*An MFG/PRO error occurred do not post invoice*/
                     else do:
                        {pxmsg.i &MSGNUM=msgNbr &ERRORLEVEL=4 &MSGBUFFER=msgText}
                        /*Invoice was not posted due to a technical problem*/
                        {pxmsg.i &MSGNUM=3489 &ERRORLEVEL=4 &MSGBUFFER=error_msg}
                        postInvoice = false.
                     end.

                     display
                        skip(3)
                        msgText   skip
                        error_msg skip
                        skip(3)
                     with frame unpost2 no-labels width 80.

                     if postInvoice = false then
                        undo invoiceloop, leave.

                  end.

               end. /*if cardProcessed then do:*/

               if soc_apm and promo_inv <> "" then do:
                  complete = no.
                  apm-ex-prg = "ifapm053.p".
                  apm-ex-sub = "if/".
                  {gprunex.i
                     &module   = 'APM'
                     &subdir   = apm-ex-sub
                     &program  = 'ifapm053.p'
                     &params   = "(input promo_inv,
                                   output error_flag,
                                   output err_mess_num)"}
                  if error_flag then do:
                     {pxmsg.i &MSGNUM=err_mess_num &ERRORLEVEL=3}
                     undo_all = yes.
                  end.
               end.

               if undo_all then do:
                  {pxmsg.i &MSGNUM=2198 &ERRORLEVEL=4 &MSGBUFFER=error_msg}.
                  display
                     skip(3)
                     error_msg
                     skip(3)
                  with frame unpost no-labels width 80.
                  undo invoiceloop, leave.
               end.

               /* Delete exchange rate usage if not attached to SO */
               if not available so_mstr or
                  exch_exru_seq <> so_exru_seq
               then do:
                  {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
                     "(input exch_exru_seq)" }
               end.

            end. /*for each so_mstr*/

         end. /*invoiceloop*/

      end. /* if avail somstr */

      else
         leave.   /* not avail somstr */

   end. /* repeat: find first somstr */

   /*Disconnect APP server*/
   if l_storefront_so then do:
      {gprunp.i "gpccmck" "p" "terminateAppServer"}
      /*Delete gpccmck p from the memory*/
      {gpdelp.i "gpccmck" "p"}
   end.

   SESSION:numeric-format = oldsession.

   if not undo_all then do:

      /* SET CURRENCY FORMAT FOR BASE_TOTAL */
      base_total_fmt = base_total_old.

      run gpcrfmt
         (input-output base_total_fmt,
          input gl_rnd_mthd).

      assign
         base_total:format = base_total_fmt
         /* SET CURRENCY FORMAT FOR MARG_TOTAL */
         marg_total_fmt = marg_total_old.

      run gpcrfmt
         (input-output marg_total_fmt,
          input gl_rnd_mthd).

      assign
         marg_total:format = marg_total_fmt
         base_total = accum total (base_price)
         marg_total = accum total (base_margin).

      if using_container_charges or using_line_charges then
         assign
            base_total = base_total + cont_charges + line_charges
            marg_total = marg_total + cont_charges + line_charges.

      underline base_total base_margin with frame rpttot.
      down 1 with frame rpttot.

      do on endkey undo, leave:
         display
            skip(1)
            base_curr + " " + getTermLabel("REPORT_TOTALS",13) + ": " @ totstr
            base_total
            marg_total
         with frame rpttot.
      end. /* DO ON ENDKEY UNDO, LEAVE */

   end.

   /* PRINT GL RECAP */
   do on endkey undo, leave:
      page.
   end. /* DO ON ENDKEY UNDO, LEAVE */

   /* SET CURRENCY FORMAT FOR GLTWDR ACCORDING TO BASE */
   gltwdr_fmt = gltwdr_old.

   run gpcrfmt
      (input-output gltwdr_fmt,
       input gl_rnd_mthd).

   /* SET CURRENCY FORMAT FOR GLTWCR ACCORDING TO BASE */
   gltwcr_fmt = gltwcr_old.

   run gpcrfmt
      (input-output gltwcr_fmt,
       input gl_rnd_mthd).

   for each gltw_wkfl exclusive-lock where gltw_userid = mfguser
   break by gltw_entity by gltw_acct by gltw_sub by gltw_cc
   with frame gltwtot:

      {&SOIVPST1-P-TAG9}
      view frame jrnl.
      {&SOIVPST1-P-TAG10}

      assign
         dr_amt:format = gltwdr_fmt
         cr_amt:format = gltwcr_fmt
         cr_amt = 0
         dr_amt = 0.

      if gltw_amt < 0 then
         cr_amt = - gltw_amt.
      else
         dr_amt = gltw_amt.

      accumulate (dr_amt) (total by gltw_cc).
      accumulate (cr_amt) (total by gltw_cc).

      if not gl_sum then do:
         do on endkey undo, leave:
            display
               gltw_entity
               gltw_acct
               gltw_sub
               gltw_cc
               gltw_project
               gltw_date
               gltw_desc
            with frame gltwtot.
         end. /* DO ON ENDKEY UNDO, LEAVE */

         do on endkey undo, leave:
            if dr_amt <> 0 then display dr_amt.
            if cr_amt <> 0 then display cr_amt.
            down 1 with frame gltwtot.
         end. /* DO ON ENDKEY UNDO, LEAVE */

      end.

      if last-of(gltw_cc) then do:

         if gl_sum then
         do on endkey undo, leave:
            display
               gltw_entity
               gltw_acct
               gltw_cc
               gltw_date
               gltw_sub
            with frame gltwtot.
         end. /* DO ON ENDKEY UNDO, LEAVE */

         if (accum total by gltw_cc dr_amt) <> 0 then do:
            gltwdr = accum total by gltw_cc dr_amt.
            do on endkey undo, leave:
               display gltwdr @ dr_amt with frame gltwtot.
            end. /* DO ON ENDKEY UNDO, LEAVE */
         end.

         if (accum total by gltw_cc cr_amt) <> 0 then do:
            gltwcr = accum total by gltw_cc cr_amt.
            do on endkey undo, leave:
               display gltwcr @ cr_amt with frame gltwtot.
            end. /* DO ON ENDKEY UNDO, LEAVE */
         end.

         down 1 with frame gltwtot.

      end.

      if last-of(gltw_entity) then do:
         underline dr_amt cr_amt with frame gltwtot.
         down 1 with frame gltwtot.
         do on endkey undo, leave:
            display
               accum total (dr_amt) @ dr_amt
               accum total (cr_amt) @ cr_amt with frame gltwtot.
            down 1 with frame gltwtot.
         end. /* DO ON ENDKEY UNDO, LEAVE */
      end.

      {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
         "(input gltw_exru_seq)"}

      delete gltw_wkfl.

   end.

   if auto_balance_amount <> 0 then
      do with frame autobalance:
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame autobalance:handle).
         display
            getTermLabelRtColon("NOTE",7)
            auto_balance_amount
            getTermLabel("AUTO_BALANCED_REFER", 20)
            getTermLabelRtColon("SALES_JOURNAL_REFERENCE",24) format "x(24)"
            ref
            getTermLabelRtColon("AR_BATCH",9) format "x(9)"
            batch
         with frame autobalance width 132 no-label.
      end.

   /* Display unposted invoices */
   for first invoice_err
   fields (db_name inv_nbr ord_nbr)
   no-lock: end.

   if available invoice_err then do:

      page.

      display
         getTermLabel("UNPOSTED_INVOICES_DURING_PROCESS",35) format "x(35)"
      with frame c width 80.

      for each invoice_err no-lock,
          each so_mstr where so_inv_nbr = inv_nbr
      no-lock
      with frame err width 80:

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame err:handle).

         display
            inv_nbr
            so_nbr
            db_name column-label "DB Not Connected"
         with frame err.

      end.

   end.

   SESSION:numeric-format = oldsession.

   return.

end.

SESSION:numeric-format = oldsession.
undo_all = yes.

PROCEDURE processCreditCard:
/*---------------------------------------------------------------------------
  Purpose: Make a credit card payment
  Parameters:
     pSuccess - error status - will be false if any error occurred
     pMsgNbr  - Message number of any MFG/PRO errors occurring
                in soivccpy.p.  If only cybercash errors occurred
                then this will be 0
  Exceptions:
  Notes:
 ---------------------------------------------------------------------------*/
   define output parameter pCardProcessed as logical no-undo.
   define output parameter pSuccess as logical no-undo.
   define output parameter pMsgNbr as integer no-undo.

   define variable vpbatch          like ba_batch no-undo.
   define variable vparnbr          like ar_nbr   no-undo.
   define variable h-arpamtpl       as handle     no-undo.
   define variable vpdft-daybook    like dy_dy_code no-undo.
   define variable vpdesc           as character format "x(1)" no-undo.
   define variable vpard_recno      as recid      no-undo.
   define variable apply2_rndmthd   like rnd_rnd_mthd no-undo.
   define buffer invcmemo_ar_mstr   for ar_mstr.
   define buffer payment_ar_mstr    for ar_mstr.
   define variable vccorder         as logical    no-undo.
   define variable vba_recno        as recid      no-undo.
   define variable jrnl             as character format "x(8)" no-undo.
   define variable v-err-msg        as character no-undo.

   /* Capture and Authorize amount using MCK routines */
   {gprun.i ""soivccpy.p""
      "(input cur-sonbr,
        input promo_inv,
        input vglamt,
        output pCardProcessed,
        output pSuccess,
        output pMsgNbr)"}

   /* Not a credit card order or an error occurred */
   if pCardProcessed = false or pSuccess = false then return.

   {mfnctrl.i arc_ctrl arc_memo ar_mstr ar_check vparnbr}

   if vpbatch = "" then do:

      {gprun.i ""arpamtpl.p"" "persistent set h-arpamtpl"}

      /*Find or create batch number*/
      {gprun.i ""gpgetbat.p""
         "(input """",
           input ""AR"",
           input ""P"",
           input 0,
           output vba_recno,
           output vpbatch)"}

   end.  /*  end of vpatch = "" do  */

   if vpdft-daybook = "" then do:
      /*Obtain default daybook*/
      {gprun.i ""gldydft.p""
         "(input ""AR"",
           input ""P"",
           input post_entity,
           output vpdft-daybook,
           output vpdesc)"}
   end.  /*  end of vpdft-daybook = "" do  */

   for first invcmemo_ar_mstr
   fields (ar_curr ar_nbr ar_acct ar_sub
           ar_cc ar_entity ar_type ar_amt ar_applied ar_ex_rate ar_ex_rate2)
   where recid(invcmemo_ar_mstr) = viar_recno
   exclusive-lock: end.

   /* Only create payment records if the capture was OK - if pSuccess is
    * false here then Cybercash had returned an error - posting would
    * still take place in this situation but we don't want to
    * create the payment records*/
   /* Create payment master header */
   run create_payment_mstr in h-arpamtpl
      (input viar_recno,
       input vpbatch,
       input vpdft-daybook,
       input vparnbr,
       buffer invcmemo_ar_mstr,
       buffer payment_ar_mstr).

   /* Create payment detail record */
   run create_payment_detail in h-arpamtpl
      (input payment_ar_mstr.ar_nbr,
       input invcmemo_ar_mstr.ar_nbr,
       input invcmemo_ar_mstr.ar_acct,
       input invcmemo_ar_mstr.ar_sub,
       input invcmemo_ar_mstr.ar_cc,
       input invcmemo_ar_mstr.ar_entity,
       input invcmemo_ar_mstr.ar_type,
       input invcmemo_ar_mstr.ar_amt,
       input 0,
       input vpdft-daybook,
       input nrm-seq-num,
       output vpard_recno,
       buffer invcmemo_ar_mstr,
       buffer payment_ar_mstr).

   /* Get round method */
   run get_invcmemo_rounding_method in h-arpamtpl
      (input invcmemo_ar_mstr.ar_curr,
       output apply2_rndmthd).

   /*Calculate tax*/
   run calculate_tax_adjustment in h-arpamtpl
      (input vpard_recno,
       buffer invcmemo_ar_mstr,
       buffer payment_ar_mstr).

   {mfnctrl.i arc_ctrl arc_jrnl glt_det glt_ref jrnl}

   /*Post GL transactions*/
   run post_gl_transactions in h-arpamtpl
      (input recid(payment_ar_mstr),
       input vpard_recno,
       input payment_ar_mstr.ar_curr,
       input 1, /* inv_to_base_rate, */
       input 1, /* inv_to_base_rate2, */
       input payment_ar_mstr.ar_ex_rate,
       input payment_ar_mstr.ar_ex_rate2,
       input invcmemo_ar_mstr.ar_applied,
       input 0,
       input recid(invcmemo_ar_mstr),
       input invcmemo_ar_mstr.ar_ex_rate,
       input invcmemo_ar_mstr.ar_ex_rate2,
       input apply2_rndmthd,
       input jrnl,
       output undo_all).

   /* Update customer balance */
   run update_customer_balance in h-arpamtpl
      (buffer invcmemo_ar_mstr,
       input vpard_recno).

   for first ba_mstr where recid(ba_mstr) = vba_recno
   exclusive-lock:
      assign
         ba_total = ba_total + invcmemo_ar_mstr.ar_amt
         ba_ctrl = ba_total
         ba_userid = global_userid
         ba_date = today
         ba_status = " ".
   end.

   vglamt = - payment_ar_mstr.ar_applied.

   /* Create gltrans workfile records */
   {mfgltw.i
      &acct=payment_ar_mstr.ar_acct
      &sub=payment_ar_mstr.ar_sub
      &cc=payment_ar_mstr.ar_cc
      &entity=payment_ar_mstr.ar_entity
      &project= """"
      &ref=mfguser
      &date=today
      &type=""PAYMENT""
      &docnbr=payment_ar_mstr.ar_check
      &amt=vglamt
      &curramt=vglamt
      &daybook=""""}

   vglamt = - vglamt.

   {mfgltw.i
      &acct=invcmemo_ar_mstr.ar_acct
      &sub=invcmemo_ar_mstr.ar_sub
      &cc=invcmemo_ar_mstr.ar_cc
      &entity=invcmemo_ar_mstr.ar_entity
      &project= """"
      &ref=mfguser
      &date=today
      &type=""PAYMENT""
      &docnbr=payment_ar_mstr.ar_check
      &amt=vglamt
      &curramt=vglamt
      &daybook=""""}

END PROCEDURE. /*ProcessCreditCard*/

{&SOIVPST1-P-TAG11}
