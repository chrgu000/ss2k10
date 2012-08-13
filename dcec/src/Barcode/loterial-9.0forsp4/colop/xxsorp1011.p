/* GUI CONVERTED from sorp1011.p (converter v1.77) Tue Oct  7 10:23:24 2003 */
/* xxsorp1011.p - SALES ORDER INVOICE PRINT NOTA FISCAL FORMAT            */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.9.1.6.3.1 $                                                        */
/*V8:ConvertMode=Report                                                 */
/* REVISION: 7.4      LAST MODIFIED: 01/04/94   BY: tjs *H166**/
/* REVISION: 7.4      LAST MODIFIED: 01/13/94   BY: dpm *H074**/
/* REVISION: 7.4      LAST MODIFIED: 04/14/94   BY: dpm *H347**/
/* REVISION: 7.4      LAST MODIFIED: 04/21/94   BY: tjs *H359**/
/* REVISION: 7.4      LAST MODIFIED: 06/13/94   BY: bcm *H381**/
/* REVISION: 7.4      LAST MODIFIED: 03/14/95   BY: kjm *F0MY**/
/* REVISION: 7.4      LAST MODIFIED: 03/24/95   BY: kjm *F0NZ**/
/* REVISION: 8.5      LAST MODIFIED: 07/25/95   BY: taf *J053**/
/* REVISION: 8.5      LAST MODIFIED: 07/19/96   BY: taf *J0ZZ**/
/* REVISION: 8.6      LAST MODIFIED: 11/25/96   BY: jzw *K01X**/
/* REVISION: 8.6      LAST MODIFIED: 10/20/97   BY: *H1F8* Nirav Parikh       */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 06/29/98   BY: *L024* Sami Kureishy      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* myb                */
/* REVISION: 9.1      LAST MODIFIED: 10/14/00   BY: *N0WB* Mudit Mehta        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Old ECO marker removed, but no ECO header exists *H393*                    */
/* Revision: 1.9.1.4   BY: Katie Hilbert      DATE: 04/01/01  ECO: *P002*     */
/* Revision: 1.9.1.5   BY: Ellen Borden       DATE: 07/09/01  ECO: *P007*     */
/* Revision: 1.9.1.6   BY: Dipesh Bector      DATE: 01/14/03  ECO: *M21Q*     */
/* $Revision: 1.9.1.6.3.1 $  BY: Katie Hilbert      DATE: 09/29/03  ECO: *P14P*   */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*  Run Confirm Shipment (rcsorp10.p)                                         */
/*  The Invoice number (Shipper Number) must be present and may span over     */
/*  multiple orders. Many fields are in Portuguese for our friends in Brazil. */
/*  For GTM environment only.                                           */

/* THIS PROGRAM IS SIMILAR TO soiv1011.p. CHANGES DONE IN THIS          */
/* PROGRAM MAY ALSO NEED TO BE DONE IN soiv1011.p.                      */

/* IN ORDER TO AVOID LOCKING ISSUES DURING INVOICE PRINT OF    */
/* SINGLE/MULTIPLE ORDERS, SKIP THE LOCKED ORDER AND PRINT THE */
/* INVOICES FOR THE REMAINING ORDERS.                          */


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdeclre.i}
{cxcustom.i "SORP1011.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define new shared variable rndmthd       like rnd_rnd_mthd.
define new shared variable so_recno      as recid.
define new shared variable comb_inv_nbr  like so_inv_nbr.

define shared variable max_lines         as integer.
define shared variable body_count        as integer.
define shared variable nbr               like so_nbr.
define shared variable nbr1              like so_nbr.
define shared variable shipdate          like so_ship_date.
define shared variable shipdate1         like shipdate.
define shared variable cust              like so_cust.
define shared variable cust1             like so_cust.
define shared variable bill              like so_bill.
define shared variable bill1             like so_bill.
define shared variable lang              like so_lang.
define shared variable lang1             like lang.
define shared variable next_inv_nbr      like soc_inv.
define shared variable undo_nota         like mfc_logical.
define shared variable company           as character
                                         format "x(38)" extent 6.

define variable item_count   as integer.
define variable addr         as character format "x(38)" extent 6.
define variable billto       as character format "x(38)" extent 6.
define variable soldto       as character format "x(38)" extent 6.
define variable comp_addr    like soc_company.
define variable inv_date     like so_inv_date.
define variable numero       like so_inv_nbr  extent 24.
define variable valor        like sod_price   extent 24.
define variable data         like so_due_date extent 24.
define variable pct_due      like ctd_pct_due extent 24.
define variable bal_due      like sod_price.
define variable numero1      like so_inv_nbr.
define variable numero2      like so_inv_nbr.
define variable valor1       like sod_price.
define variable valor2       like sod_price.
define variable data1        like so_due_date.
define variable data2        like so_due_date.
define variable trl_length   as integer initial 11.
define variable shipto       as character format "x(38)" extent 6.
define variable prepaid-lbl  as character format "x(12)".
define variable po-lbl       as character format "x(8)".
define variable lot-lbl      as character format "x(43)".
define variable cspart-lbl   as character format "x(15)".
define variable hdr_po       as character format "x(38)".
define variable po-lbl2      as character format "x(16)".
define variable letter       as character format "x(1)" extent 24.
define variable lot_total    like tr_qty_chg.
define variable sales_entity like si_entity.
define variable due_date     like so_due_date.
define variable disc_date    like so_due_date.
define variable qty_inv      like sod_qty_inv.
define variable ext_price    like sod_price.
define variable desc1        like sod_desc.
define variable desc2        like sod_desc.
define variable termsdesc    like ct_desc.
define variable tot_merca    like so_trl1_amt.
define variable tot_nota     like so_trl1_amt.
define variable tot_trans    like so_trl1_amt.
define variable tot_seguro   like so_trl1_amt.
define variable tot_outras   like so_trl1_amt.
define variable base_ipi     like so_trl1_amt.
define variable valor_ipi    like so_trl1_amt.
define variable base_icms    like so_trl1_amt.
define variable valor_icms   like so_trl1_amt.
define variable aliq_icms    like so_disc_pct.
define variable icms_rate    like so_disc_pct.
define variable fiscal_class like pt_fiscal_class.
define variable ipi_rate     like tx2_tax_pct.
define variable ipi_tax_amt  like so_trl1_amt.
define variable comp_cgc_id  like ad_gst_id.
define variable comp_est_id  like ad_pst_id.
define variable comp_state   like ad_state.
define variable sold_cgc_id  like ad_gst_id.
define variable sold_est_id  like ad_pst_id.
define variable sold_state   like ad_state.
define variable ship_cgc_id  like ad_gst_id.
define variable ship_est_id  like ad_pst_id.
define variable ship_state   like ad_state.
define variable disc_pct     like ctd_pct_due.
define variable no_pi        like so_po.
define variable vend         like so_source.
define variable cfo          like so_tax_usage.
define variable natureza     like ad_name.
define variable ped_client   like so_po.
define variable carr_name    like ad_name.
define variable via          like fr_mode.
define variable frete        like so_fr_terms.
define variable carr_ender   like ad_city.
define variable ship_wt      like sod_fr_wt.
define variable net_wt       like sod_fr_wt.
define variable contra       like so_fob.
define variable tot_disc_amt like so_disc_pct.
define variable shipper_id   like so_inv_nbr.
define variable abs_shipvia  like so_shipvia.
define variable abs_fob      like so_fob.
define variable abs_trans_mode as character format "x(20)".
define variable abs_veh_ref    as character format "x(20)".
define variable oldsession     as character no-undo.
define variable oldcurr      like so_curr no-undo.
/* DEFINE VARIABLES FOR FORMATS */
define variable valor_fmt      as character no-undo.
define variable valor_old      as character no-undo.
define variable ext_price_fmt  as character no-undo.
define variable ext_price_old  as character no-undo.
define variable ipi_tax_fmt    as character no-undo.
define variable ipi_tax_old    as character no-undo.
define variable tot_trans_fmt  as character no-undo.
define variable tot_trans_old  as character no-undo.
define variable tot_seguro_fmt as character no-undo.
define variable tot_seguro_old as character no-undo.
define variable tot_outras_fmt as character no-undo.
define variable tot_outras_old as character no-undo.
define variable tot_merca_fmt  as character no-undo.
define variable tot_merca_old  as character no-undo.
define variable tot_nota_fmt   as character no-undo.
define variable tot_nota_old   as character no-undo.
define variable base_ipi_fmt   as character no-undo.
define variable base_ipi_old   as character no-undo.
define variable valor_ipi_fmt  as character no-undo.
define variable valor_ipi_old  as character no-undo.
define variable base_icms_fmt  as character no-undo.
define variable base_icms_old  as character no-undo.
define variable valor_icms_fmt as character no-undo.
define variable valor_icms_old as character no-undo.
define variable mc-error-number like msg_nbr no-undo.
define variable l_locked        like mfc_logical no-undo.

{gpvtecdf.i &var="shared"} /* Define vars for VAT Reg No & Country */
{gpvtepdf.i &var=" "}
{mfsotrla.i "NEW"}

{&SORP1011-P-TAG1}
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

FORM /*GUI*/  /* LINE ITEMS */
   item_count   at 1      format ">9"
   sod_um       at 4      format "x(2)"
   qty_inv      at 6      format ">>>,>>9"
   sod_fr_wt    at 15     format ">>>,>>9"
   sod_part     at 23     format "x(10)"
   desc1        at 34     format "x(24)"
   fiscal_class at 60     format "x(10)"
   natureza     at 71     format "x(3)"
   sod_price    at 75     format ">>>>,>>>,>>>.99"
   ext_price    at 91     format ">>>>>,>>>,>>>.99"
   ipi_rate     at 107    format ">>>9.9"
   ipi_tax_amt  at 113    format ">>>,>>>,>>>.99"
with STREAM-IO /*GUI*/  frame b down no-attr-space no-box no-labels width 132.

FORM /*GUI*/  /* VALUE LINE */
   icms_rate    at 30     format ">9.9"
   tot_trans    at 41     format "->>>>>>>>>>>.99"
   tot_seguro   at 57     format "->>>>>>>>>>>.99"
   tot_outras   at 74     format "->>>>>>>>>>>.99"
   tot_merca    at 92     format "->>>>>>>>>>>.99"
   tot_nota     at 111    format "->>>>>>>>>>>.99"
   skip(1)
with STREAM-IO /*GUI*/  frame c no-attr-space no-box no-labels width 132.

FORM /*GUI*/  /* INVOICE DATE BLOCK - DATA DE EMISSAO */
   inv_date     at 24
   comp_cgc_id  at 42     format "x(18)"
   ship_cgc_id  at 75     format "x(18)"
   comp_est_id  at 42     format "x(18)"
   comp_state   at 63     format "x(4)"
   ship_est_id  at 75     format "x(18)"
   ship_state   at 95     format "x(4)"
   so_ship_date at 101    skip(1)
   base_ipi     at 15     format "->>>>>>>>>>>.99"
   valor_ipi    at 37     format "->>>>>>>>>>>.99"
   base_icms    at 59     format "->>>>>>>>>>>.99"
   valor_icms   at 81     format "->>>>>>>>>>>.99"
   aliq_icms    at 98     format ">9.9"
   skip(1)
with STREAM-IO /*GUI*/  frame d no-attr-space no-box no-labels width 132.

FORM /*GUI*/  /* INVOICE No. BLOCK - NOTA FISCAL FATURA */
   no_pi        at 81     format "x(22)"
   vend         at 110    format "x(8)"
   cfo          at 50     format "x(6)"
   natureza     at 70     format "x(30)"
   ped_client   at 105    format "x(28)"
   carr_name    at 60     format "x(28)"
   via          at 90     format "x(8)"
   frete        at 110    format "x(8)"
   so_inv_nbr   at 30
   carr_ender   at 60     format "x(28)"
   contra       at 110    format "x(20)"
   abs_trans_mode at 50
   abs_veh_ref  at 75
   ship_wt      at 95
   so_ship_date at 32
   net_wt       at 95
   skip(1)
with STREAM-IO /*GUI*/  frame e no-attr-space no-box no-labels width 132.

FORM /*GUI*/  /* PAYMENT SCHED & ADDR - DUPLICATAS & SACADO */
   numero1     at 1      format "x(9)"
   valor1      at 11     format ">>>>>,>>>,>>>.99"
   data1       at 28
   numero2     at 38     format "x(9)"
   valor2      at 48     format ">>>>>,>>>,>>>.99"
   data2       at 65
   addr[1]     at 85
with STREAM-IO /*GUI*/  frame f down no-attr-space no-box no-labels width 132.

FORM /*GUI*/  /* CREDIT TERMS - PRACA DE PAGAMENTO */
   skip(1)
   sold_cgc_id  at 85     format "x(18)"
   sold_est_id  at 113    format "x(18)"
   disc_pct     at 94     format "->9.9"
   disc_date    at 110
   data[1]      at 125
   termsdesc    at 96
   shipto[5]    at 94
   ship_cgc_id  at 85     format "x(18)"
   ship_est_id  at 113    format "x(18)"
with STREAM-IO /*GUI*/  frame g no-attr-space no-box no-labels width 132.

/* SET _OLD VARIABLES WITH FORMATS */
assign
   valor_old       = valor1:format
   ext_price_old   = ext_price:format
   ipi_tax_old     = ipi_tax_amt:format
   tot_trans_old   = tot_trans:format
   tot_seguro_old  = tot_seguro:format
   tot_merca_old   = tot_seguro:format
   tot_outras_old  = tot_outras:format
   tot_nota_old    = tot_nota:format
   base_ipi_old    = base_ipi:format
   valor_ipi_old   = valor_ipi:format
   base_icms_old   = base_icms:format
   valor_icms_old  = valor_icms:format.

find first gl_ctrl no-lock.

if nbr1      = "" then nbr1 = hi_char.
if shipdate  = ?  then shipdate = low_date.
if shipdate1 = ?  then shipdate1 = hi_date.
if lang1     = "" then lang1 = hi_char.
if cust1     = "" then cust1 = hi_char.
if bill1     = "" then bill1 = hi_char.
maint = no.

/* VERIFY THAT Nota Fiscal DOESN'T EXCEED max_lines */
{gprun.i ""soso1011.p"" }
if max_lines < 0 then do:
   max_lines = max_lines * -1.
   undo_nota = yes.
   leave.
end.

/* DUPLICATA LETTER SUFFIX */
do i = 1 to 24:
   letter[i] = chr((ASC("a") - 1) + i).
end.

oldsession = SESSION:numeric-format.
{&SORP1011-P-TAG2}

for each so_mstr where (so_to_inv = yes)
      and (so_inv_nbr) <> "" and (so_inv_nbr) <> ?
      and (so_nbr >= nbr and so_nbr <= nbr1)
      and (so_ship_date >= shipdate and so_ship_date <= shipdate1)
      and (so_cust >= cust and so_cust <= cust1)
      and (so_bill >= bill and so_bill <= bill1)
      and (so_lang >= lang and so_lang <= lang1)
      no-lock break by so_inv_nbr by so_nbr:

   if (oldcurr <> so_curr) or (oldcurr = "") then do:
      /* GET ROUNDING METHOD FROM CURRENCY MASTER */
      {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
         "(input so_curr,
           output rndmthd,
           output mc-error-number)"}
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4}
         next.
      end.
      /* DETERMINE CURRENCY DISPLAY AMERICAN OR EUROPEAN  */
      find rnd_mstr where rnd_rnd_mthd = rndmthd no-lock no-error.
      if not available rnd_mstr then do:
         /* ROUND METHOD RECORD NOT FOUND */
         {pxmsg.i &MSGNUM=863 &ERRORLEVEL=4}
         next.
      end.
      /* IF RND_DEC_PT = COMMA FOR THE DECIMAL POINT */
      /* THIS IS THE EUROPEAN STYLE CURRENCY */
      if (rnd_dec_pt = ",")
      then SESSION:numeric-format = "European".
      else SESSION:numeric-format = "American".
      /* FORMAT ALL AMOUNT VARIABLES */
      valor_fmt = valor_old.
      {gprun.i ""gpcurfmt.p"" "(input-output valor_fmt,
                                input rndmthd)"}
      assign
         valor1:format = valor_fmt
         valor2:format = valor_fmt
         ext_price_fmt = ext_price_old.
      {gprun.i ""gpcurfmt.p"" "(input-output ext_price_fmt,
                                input rndmthd)"}
      assign
         ext_price:format = ext_price_fmt
         ipi_tax_fmt = ipi_tax_old.
      {gprun.i ""gpcurfmt.p"" "(input-output ipi_tax_fmt,
                                input rndmthd)"}
      assign
         ipi_tax_amt:format = ipi_tax_fmt
         tot_trans_fmt = tot_trans_old.
      {gprun.i ""gpcurfmt.p"" "(input-output tot_trans_fmt,
                                input rndmthd)"}
      assign
         tot_trans:format = tot_trans_fmt
         tot_seguro_fmt = tot_seguro_old.
      {gprun.i ""gpcurfmt.p"" "(input-output tot_seguro_fmt,
                                input rndmthd)"}
      assign
         tot_seguro:format = tot_seguro_fmt
         tot_outras_fmt = tot_outras_old.
      {gprun.i ""gpcurfmt.p"" "(input-output tot_outras_fmt,
                                input rndmthd)"}
      assign
         tot_outras:format = tot_outras_fmt
         tot_merca_fmt = tot_merca_old.
      {gprun.i ""gpcurfmt.p"" "(input-output tot_merca_fmt,
                                input rndmthd)"}
      assign
         tot_merca:format = tot_merca_fmt
         tot_nota_fmt = tot_nota_old.
      {gprun.i ""gpcurfmt.p"" "(input-output tot_nota_fmt,
                                input rndmthd)"}
      assign
         tot_nota:format = tot_nota_fmt
         base_ipi_fmt = base_ipi_old.
      {gprun.i ""gpcurfmt.p"" "(input-output base_ipi_fmt,
                                input rndmthd)"}
      assign
         base_ipi:format = base_ipi_fmt
         valor_ipi_fmt = valor_ipi_old.
      {gprun.i ""gpcurfmt.p"" "(input-output valor_ipi_fmt,
                                input rndmthd)"}
      assign
         valor_ipi:format = valor_ipi_fmt
         base_icms_fmt = base_icms_old.
      {gprun.i ""gpcurfmt.p"" "(input-output base_icms_fmt,
                                input rndmthd)"}
      assign
         base_icms:format = base_icms_fmt
         valor_icms_fmt = valor_icms_old.
      {gprun.i ""gpcurfmt.p"" "(input-output valor_icms_fmt,
                               input rndmthd)"}
      assign
         valor_icms:format = valor_icms_fmt
         oldcurr = so_curr.
   end. /* IF (OLDCURR <> SO_CURR) */
   {&SORP1011-P-TAG3}

   if first-of(so_inv_nbr) then do:
      comb_inv_nbr = so_inv_nbr.

      /* PRODUCING ESTABLISHMENT - ESTABELECIMENTO ENITENTE      */
      /* STATE, GST & PST ID     - U.F., INSCR. C.G.C & ESTADUAL */
      find ad_mstr where ad_addr = so_site and ad_type = "company"
         no-lock no-error.
      if available ad_mstr then
      assign
         comp_state  = ad_state
         comp_cgc_id = ad_gst_id
         comp_est_id = ad_pst_id.
      else
      assign
         comp_state  = ""
         comp_cgc_id = ""
         comp_est_id = "".

      /* SOLD TO */
      find ad_mstr where ad_addr = so_cust no-lock no-error.
      update soldto = "".
      if available ad_mstr then do:
         assign
            addr[1] = ad_name
            addr[2] = ad_line1
            addr[3] = ad_line2
            addr[4] = ad_line3
            addr[6] = ad_country
            sold_state = ad_state
            sold_cgc_id = ad_gst_id
            sold_est_id = ad_pst_id.
         {mfcsz.i addr[5] ad_city ad_state ad_zip}.
         {gprun.i ""gpaddr.p"" }
         assign
            soldto[1] = addr[1]
            soldto[2] = addr[2]
            soldto[3] = addr[3]
            soldto[4] = addr[4]
            soldto[5] = addr[5]
            soldto[6] = addr[6].
      end.

      /* SHIP TO */
      find ad_mstr where ad_addr = so_ship no-lock no-error.
      update shipto = "".
      if available ad_mstr then do:
         assign
            addr[1] = ad_name
            addr[2] = ad_line1
            addr[3] = ad_line2
            addr[4] = ad_line3
            addr[6] = ad_country
            ship_state = ad_state
            ship_cgc_id = ad_gst_id
            ship_est_id = ad_pst_id.
         {mfcsz.i addr[5] ad_city ad_state ad_zip}.
         {gprun.i ""gpaddr.p"" }
         assign
            shipto[1] = addr[1]
            shipto[2] = addr[2]
            shipto[3] = addr[3]
            shipto[4] = addr[4]
            shipto[5] = addr[5]
            shipto[6] = addr[6].

         /* FIND VAT # FOR SHIP TO OR BILL TO IF SHIP TO VAT=" " */
         if ad_pst_id = "" then do:
            find ad_mstr where ad_addr = so_bill no-lock no-error.
            if available ad_mstr then do:
               {gpvteprg.i}
            end.
         end.
         else do:
            {gpvteprg.i}
         end.

      end.  /* available ad_mstr */

      /* INITIALIZE DUPLICATA ARRAY */
      assign
         numero = ""
         data = ?
         pct_due = 0
         disc_pct = 0
         disc_date = ?
         i = 1
         numero[i] = so_inv_nbr + letter[i]
         inv_date = so_inv_date
         data[i] = inv_date
         pct_due[i] = 100
         termsdesc = "".
      find ct_mstr where ct_code = so_cr_terms no-lock no-error.
      if available ct_mstr then do:
         assign
            termsdesc = ct_desc
            disc_pct = ct_disc_pct
            /* DUE & DISCOUNT DATE */
            disc_date = ?
            due_date = ?.
         if ct_dating = no then do: /* SINGLE PAYMENT CREDIT TERMS */
            {gprun.i ""adctrms.p"" "(input inv_date,
                                     input ct_code,
                                     output disc_date,
                                     output due_date)"}
            data[i] = due_date.
         end.
         else do:                   /* MULTI PAYMENT CREDIT TERMS */
            if ct_dating = yes then do:
               for each ctd_det
                  where ctd_code = so_cr_terms
               no-lock use-index ctd_cdseq:
                  find ct_mstr where ct_code = ctd_date_cd
                     no-lock no-error.
                  if available ct_mstr then do:
                     due_date = ?. /* disc_date won't change */
                     {gprun.i ""adctrms.p"" "(input inv_date,
                                              input ct_code,
                                              output disc_date,
                                              output due_date)"}
                     assign
                        numero[i] = so_inv_nbr + letter[i]
                        data[i] = due_date
                        pct_due[i] = ctd_pct_due.
                  end.
                  i = i + 1.
                  if i > 24 then leave.
               end.
            end.
         end.
      end.
      if disc_pct = 0 then disc_date = ?.

      /* SHIPPER MASTER */
      find abs_mstr where abs_shipfrom = so_site and
         abs_id = "s" + comb_inv_nbr no-lock no-error.
      if available abs_mstr then
      assign
         abs_shipvia    = substring(abs__qad01,1,20)
         abs_fob        = substring(abs__qad01,21,20)
         abs_trans_mode = substring(abs__qad01,61,20)
         abs_veh_ref    = substring(abs__qad01,81,20).

      /* INITIALIZE TOTALS */
      assign
         tot_disc_amt = 0
         tot_merca    = 0
         tot_nota     = 0
         valor_ipi    = 0
         valor_icms   = 0
         net_wt       = 0
         item_count   = 0
         body_count   = 0
         icms_rate    = 0
         aliq_icms    = 0
         natureza     = ""
         no_pi        = ""
         vend         = so_slspsn[1]
         ped_client   = so_po
         cfo          = so_tax_usage
         ship_wt      = so_weight
         frete        = so_fr_terms
         contra       = so_fob.

      put "" skip(6).

   end. /* if first-of(so_inv_nbr) */

   /* UPDATE so_mstr AS INVOICED */
   so_recno = recid(so_mstr).

   run p_check_locked(input so_recno).
   if l_locked = yes
   then
      next.

   {gprun.i ""sosoina.p""}

   /* PRINT HEADER COMMENTS BEFORE LINE ITEMS  - OBSERV */
   for each cmt_det no-lock where cmt_indx = so_cmtindx
         and (lookup("BL",cmt_print) > 0 or /* Bill of Lading */
              lookup("PA",cmt_print) > 0 or /* Packing List   */
              lookup("SH",cmt_print) > 0 or /* Shipper        */
              lookup("IN",cmt_print) > 0):  /* Invoice        */
      do i = 1 to 15:
         if cmt_cmmt[i] <> "" then do:
            put cmt_cmmt[i] at 3 skip.
            body_count = body_count + 1.
         end.
      end.
   end.

   /* COPY tx2d_det - SHIPPER TYPES TO INVOICE TYPES */
   shipper_id = string(so_site,"x(8)") + "s" + comb_inv_nbr.

   {gprun.i ""txdelete.p"" "(input '16',
                             input comb_inv_nbr,
                             input so_nbr)"}

   {gprun.i ""txdetcpy.p""
      "(input shipper_id,
        input so_nbr,
        input '14',
        input comb_inv_nbr,
        input so_nbr,
        input '16')"}
   /* LINE ITEM LOOP */
   for each sod_det
      where sod_nbr = so_nbr
        and sod_qty_inv <> 0
   by sod_line with frame b:

      if sod_qty_inv < 0 then qty_inv = sod_qty_inv * -1.
      else qty_inv = sod_qty_inv.
      ext_price = qty_inv * sod_price.

      /* GET ITEM MASTER DATA */
      find pt_mstr where pt_part = sod_part no-lock no-error.
      if available pt_mstr then do:
         fiscal_class = pt_fiscal_class.
         if sod_desc = "" then desc1 = pt_desc1.
         else desc1 = sod_desc.
         desc2 = pt_desc2.
      end.
      else
      assign
         fiscal_class = ""
         desc1 = sod_desc
         desc2 = "".

      /* LINE SALES TAX */
      ipi_tax_amt = 0.
      for each tx2d_det where tx2d_ref = so_inv_nbr
            and tx2d_nbr = so_nbr
            and tx2d_line = sod_line
            and tx2d_tr_type = "16"
      no-lock:
         find tx2_mstr where tx2_tax_code = tx2d_tax_code
            and tx2_tax_code <> "00000000"
            no-lock no-error.
         if available tx2_mstr then do:
            natureza = tx2_tax_usage.

            if tx2d_tax_in then
            /* TAX IS INCLUDED IN THE LINE PRICE */
               icms_rate = round(tx2_tax_pct,1).
            else /* TAX NOT INCLUDED IN THE LINE PRICE */
               ipi_tax_amt = ipi_tax_amt + tx2d_cur_tax_amt.
         end. /* avail tx2_mstr */
      end.
      if ipi_tax_amt < 0 then ipi_tax_amt = - ipi_tax_amt.
      if ext_price = 0 then ipi_rate = 0.
      else ipi_rate = round(((ipi_tax_amt / ext_price ) * 100),1).
      aliq_icms = icms_rate.

      item_count = item_count + 1.

      /* PRINT LINE ITEM */
      display
         item_count
         sod_um
         qty_inv
         sod_fr_wt
         sod_part
         desc1
         fiscal_class
         natureza
         sod_price
         ext_price
         ipi_rate     when (ipi_rate <> 0)
         ipi_tax_amt  when (ipi_tax_amt <> 0) WITH STREAM-IO /*GUI*/ .
      down 1.
      body_count = body_count + 1.

      if desc2 <> "" then do:
         put desc2 at 36 skip.
         body_count = body_count + 1.
      end.

      if sod_custpart <> "" then do:  /* CUSTOMER PART */
         put "CLIENTE CODIGO PRODUTO:" at 10 sod_custpart at 36 skip.
         body_count = body_count + 1.
      end.

      if sod_contr_id <> "" then do:  /* LINE PURCHASE ORDER*/
         put "     Pedido do Cliente:" at 10 sod_contr_id at 36 skip.
         body_count = body_count + 1.
      end.

      /* PRINT LINE COMMENTS AFTER OTHER DATA FOR THE LINE */
      for each cmt_det no-lock where cmt_indx = sod_cmtindx
         and (lookup("BL",cmt_print) > 0 or /* Bill of Lading */
              lookup("PA",cmt_print) > 0 or /* Packing List   */
              lookup("SH",cmt_print) > 0 or /* Shipper        */
              lookup("IN",cmt_print) > 0):  /* Invoice        */
         do i = 1 to 15:
            if cmt_cmmt[i] <> "" then do:
               put cmt_cmmt[i] at 3 skip.
               body_count = body_count + 1.
            end.
         end.
      end.

      /* TOTAL LINES  -  TOTAL MERCADORIAS */
      assign
         tot_merca = tot_merca + ext_price
         valor_ipi = valor_ipi + ipi_tax_amt
         net_wt    = net_wt + (sod_fr_wt * qty_inv).

      
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

   end. /* for each sod_det */

   /* GET TRAILER TAX DATA */
   /* Not Req'd */
   assign
      tot_trans  = tot_trans  + so_trl1_amt
      tot_seguro = tot_seguro + so_trl2_amt
      tot_outras = tot_outras + so_trl3_amt.

   if last-of(so_inv_nbr) then do:

      /* CONSOLIDATE INVOICE TOTALS */
      assign
         tot_nota = tot_merca + valor_ipi + tot_trans + tot_seguro + tot_outras
         base_ipi   = tot_merca
         base_icms  = tot_nota
         valor_icms = base_icms * aliq_icms / 100
         /* CALCULATE DUE AMTS FOR MULTIPLE DUE DATES */
         bal_due = tot_nota
         i = 1.
      do while i < 25:
         if pct_due[i] <> 0 then do:
            valor[i] = round((tot_nota * pct_due[i] / 100),2).
            if valor[i] > bal_due then valor[i] = bal_due.
            bal_due = bal_due - valor[i].
         end.
         i = i + 1.
      end.

      do while body_count < (max_lines + 1):
         body_count = body_count + 1.
         put "" skip.
      end.

      /* PRINT TOTALS */
      display
         icms_rate
         tot_trans   /* freight   */
         tot_seguro  /* insurance */
         tot_outras  /* others    */
         tot_merca
         tot_nota
      with frame c STREAM-IO /*GUI*/ .

      /* PRINT SHIP DATE BLOCK - DATA DE EMISSAO */
      display
         inv_date
         comp_cgc_id
         ship_cgc_id
         comp_est_id
         comp_state
         ship_est_id
         ship_state
         so_ship_date
         base_ipi
         valor_ipi
         base_icms
         valor_icms
         aliq_icms
      with frame d STREAM-IO /*GUI*/ .

      /* FIND CARRIER - TRANSP */
      carr_name = "".
      carr_ender = "".
      find vd_mstr where vd_addr = substring(so_shipvia,1,8)
         no-lock no-error.
      if available vd_mstr then do:
         find ad_mstr where ad_addr = vd_addr
            no-lock no-error.
         if available ad_mstr then
         assign
            carr_name = ad_name
            carr_ender = ad_city + " " + ad_state.
      end.

      find fr_mstr where fr_list = so_fr_list
         and fr_site = so_site and fr_curr = so_curr
         no-lock no-error.
      if available fr_mstr then via = fr_mode.
      else via = "".

      /* PRINT INVOICE NUMBER BLOCK */
      display
         no_pi
         vend
         cfo
         natureza
         ped_client
         carr_name
         via
         frete
         so_inv_nbr
         carr_ender
         contra
         abs_trans_mode
         abs_veh_ref
         ship_wt
         so_ship_date
         net_wt
      with frame e STREAM-IO /*GUI*/ .

      /* PRINT DUPLICATAS & ADDR */
      do i = 1 to 6 with frame f:
         display
            numero[i]      @ numero1
            valor[i]       when (valor[i]    <> 0)  @ valor1
            data[i]        @ data1
            numero[i + 12] @ numero2
            valor[i + 12]  when (valor[i + 12] <> 0)  @ valor2
            data[i + 12]   @ data2
            soldto[i]      @ addr[1] WITH STREAM-IO /*GUI*/ .
         down 1.
      end.
      do i = 7 to 8 with frame f:
         display
            numero[i]      @ numero1
            valor[i]       when (valor[i]    <> 0)  @ valor1
            data[i]        @ data1
            numero[i + 12] @ numero2
            valor[i + 12]  when (valor[i + 12] <> 0)  @ valor2
            data[i + 12]   @ data2 WITH STREAM-IO /*GUI*/ .
         down 1.
      end.
      do i = 9 to 12 with frame f:
         display
            numero[i]      @ numero1
            valor[i]       when (valor[i]    <> 0)  @ valor1
            data[i]        @ data1
            numero[i + 12] @ numero2
            valor[i + 12]  when (valor[i + 12] <> 0)  @ valor2
            data[i + 12]   @ data2
            shipto[i - 8]  @ addr[1] WITH STREAM-IO /*GUI*/ .
         down 1.
      end.
      do i = 5 to 6 with frame f:
         display
            shipto[i]      @ addr[1] WITH STREAM-IO /*GUI*/ .
         down 1.
      end.

      /* PRINT CREDIT TERMS */
      display
         sold_cgc_id
         sold_est_id
         disc_pct when (disc_pct <> 0)
         disc_date
         data[1]
         termsdesc
         shipto[5]
         ship_cgc_id
         ship_est_id
      with frame g STREAM-IO /*GUI*/ .
   end. /* if last-of(so_inv_nbr) */

end.  /* for each so_mstr */
SESSION:numeric-format = oldsession.

/* PROCEDURE TO SKIP LOCKED ORDERS DURING INVOICE PRINT */

PROCEDURE p_check_locked:

   define input parameter l_so_recno as recid no-undo.

   l_locked = no.

   find first so_mstr
      where recid(so_mstr) = l_so_recno
      exclusive-lock no-wait no-error.

   if locked(so_mstr)
   then
      l_locked = yes .

END PROCEDURE. /* p_check_locked */
