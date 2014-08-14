/* sosorp.p - SALES ORDERS REPORT BY ORDER                                   */
/*V8:ConvertMode=FullGUIReport                                               */
/*****************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "3+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE sosorp_p_1 "Qty Open"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosorp_p_3 "Tax"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosorp_p_6 "Display Comments"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosorp_p_8 "Display Features and Options"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosorp_p_10 "Ext Price"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosorp_p_11 "Include Shipped"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosorp_p_12 "Include Allocated"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosorp_p_13 "Include Unprocessed"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosorp_p_14 "Include Picked"
/* MaxLen: Comment: */

&SCOPED-DEFINE sosorp_p_17 "Exch Rate"
/* MaxLen: 40 Comment: Label for currency exchange rate */

&SCOPED-DEFINE sosorp_p_18 "Mixed Currencies"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{gpcurrp.i}

define variable rndmthd like rnd_rnd_mthd no-undo.
define variable oldcurr like so_curr no-undo.
define variable cust like so_cust.
define variable cust1 like so_cust.
define variable nbr like so_nbr.
define variable nbr1 like so_nbr.
define variable ord like so_ord_date.
define variable ord1 like so_ord_date.
define variable name like ad_name.
define variable qty_open like sod_qty_ord label {&sosorp_p_1}.
define variable desc1 like pt_desc1 format "x(49)".
define variable base_rpt like so_curr.
define variable mixed_rpt like mfc_logical initial no
   label {&sosorp_p_18}.
define variable disp_curr as character format "x(1)" label "C".
define variable stat like so_stat.
define variable stat1 like so_stat.
define variable spsn like sp_addr.
define variable spsn1 like spsn.
define variable po like so_po.
define variable po1 like so_po.
define variable quote like so_quote.
define variable quote1 like so_quote.
define variable include_allocated like mfc_logical
   label {&sosorp_p_12} initial yes.
define variable include_picked like mfc_logical
   label {&sosorp_p_14} initial yes.
define variable include_shipped like mfc_logical
   label {&sosorp_p_11} initial yes.
define variable include_unprocessed like mfc_logical
   label {&sosorp_p_13} initial yes.
define variable print_options like mfc_logical
   label {&sosorp_p_8} initial no.
define variable show_comments like mfc_logical
   label {&sosorp_p_6} initial no.
define variable i as integer.
define variable options_qty like sob_qty_req.
define variable options_desc1 like pt_desc1.
define variable options_desc2 like pt_desc2.
define variable options_um like pt_um.
define variable print_customer_header as logical.
define variable base_price like sod_price.
define variable curr_price like sod_price.
define variable ext_base_price like sod_price
   label {&sosorp_p_10} format "->,>>>,>>>,>>9.99".
define variable ext_base_price_unrnd like sod_price.
define variable ext_curr_price like sod_price
   label {&sosorp_p_10} format "->,>>>,>>>,>>9.99".
define variable ext_curr_price_unrnd like sod_price.
define variable l_new_so like mfc_logical initial no no-undo.
define variable v_disp_line1    as   character format "x(40)"
   label {&sosorp_p_17} no-undo.
define variable v_disp_line2    as   character format "x(40)" no-undo.
define variable v_cust_po       as   character format "x(31)" no-undo.
define variable mc-error-number like msg_nbr no-undo.

/* VARIABLE c-opt DEFINED                  */
/* TO DETERMINE THE OUTPUT OPTION SELECTED */
define variable c-opt as character no-undo.

{gprunpdf.i "mcpl" "p"}
{gprunpdf.i "mcui" "p"}

form header
   skip(1)
with frame phead1 page-top width 132.

form
   skip
with frame skipline width 132.

form
   nbr            colon 15
   nbr1            label {t001.i} colon 49 skip
   cust           colon 15
   cust1           label {t001.i} colon 49 skip
   ord            colon 15
   ord1            label {t001.i} colon 49 skip
   spsn           colon 15
   spsn1           label {t001.i} colon 49 skip
   po             colon 15
   po1             label {t001.i} colon 49 skip
   stat           colon 15
   stat1           label {t001.i} colon 49 skip
   quote          colon 15
   quote1          label {t001.i} colon 49 skip(1)
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   so_nbr
   v_cust_po
   so_ship
   so_ord_date
   so_stat
   so_quote
   so_disc_pct
   so_cr_terms
   so_curr
   v_disp_line1
with frame b down width 132 no-box.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

v_cust_po:LABEL in frame b    = getTermLabel("SOLD-TO",8) + " "
                              + getTermLabel("PURCHASE_ORDER",22).

form
   sod_line
   sod_part
   sod_um
   sod_qty_ord
   sod_qty_all
   sod_qty_pick
   qty_open
   disp_curr
   base_price
   ext_base_price
   sod_due_date
   sod_type
   sod_taxc column-label {&sosorp_p_3}
with frame c down width 132 no-box.

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.

oldcurr = "".

{wbrp01.i}

repeat:

   find first order_wkfl no-error.
   if available order_wkfl then
   for each order_wkfl exclusive-lock:
      delete order_wkfl.
   end.

   if nbr1 = hi_char then nbr1 = "".
   if cust1 = hi_char then cust1 = "".
   if ord = low_date then ord = ?.
   if ord1 = hi_date then ord1 = ?.
   if stat1 = hi_char then stat1 = "".
   if spsn1 = hi_char then spsn1 = "".
   if po1 = hi_char then po1 = "".
   if quote1 = hi_char then quote1 = "".

   if c-application-mode <> 'web' then
   update
      nbr nbr1
      cust cust1
      ord ord1
      spsn spsn1
      po po1
      stat stat1
      quote quote1

   with frame a.

   {wbrp06.i &command = update &fields = "  nbr nbr1 cust cust1 ord ord1
            spsn spsn1 po po1 stat stat1 quote quote1 " &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      bcdparm = "".

      if nbr1 = "" then nbr1 = hi_char.
      if cust1 = "" then cust1 = hi_char.
      if ord = ? then ord = low_date.
      if ord1 = ? then ord1 = hi_date.
      if stat1 = "" then stat1 = hi_char.
      if spsn1 = "" then spsn1 = hi_char.
      if po1 = "" then po1 = hi_char.
      if quote1 = "" then quote1 = hi_char.

   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}

  DEFINE TEMP-TABLE  tt1
         FIELD tt1_cust LIKE so_cust
         FIELD tt1_cust_name LIKE ad_name
         FIELD tt1_sod_nbr LIKE so_nbr
         FIELD tt1_so_po   LIKE so_po
         FIELD tt1_so_channel LIKE so_channel
         FIELD tt1_sod_line LIKE sod_line
         FIELD tt1_sod_part LIKE sod_part
         FIELD tt1_sod_due_date LIKE sod_due_date
         FIELD tt1_sod_qty_ord  LIKE sod_qty_ord
         FIELD tt1_sod_list_pr LIKE sod_list_pr
         FIELD tt1_so_curr LIKE so_curr
         FIELD tt1_sod_amt LIKE sod_qty_ord
         FIELD tt1_so_ord_date LIKE so_ord_date
          .

   /* OPEN SALES ORDER FILE WITH THE CRITERIA SPECIFIED BY USER. */
   for each so_mstr  where so_mstr.so_domain = global_domain and (  (so_nbr >=
   nbr) and (so_nbr <= nbr1)
         and not so_sched
         and (so_cust >= cust) and (so_cust <= cust1)
         and (so_ord_date >= ord) and (so_ord_date <= ord1)
         and (so_stat >= stat) and (so_stat <= stat1)
         and (so_slspsn[1] >= spsn) and (so_slspsn[1] <= spsn1)
         and (so_po >= po) and (so_po <= po1) and (so_quote >= quote)
         and (so_quote <= quote1)
         ) no-lock

       break by so_nbr:

       FOR EACH sod_det WHERE sod_domain = so_domain AND sod_nbr = so_nbr NO-LOCK:

           FIND FIRST ad_mstr WHERE ad_domain = GLOBAL_domain AND ad_addr = so_cust NO-LOCK NO-ERROR.

           FIND FIRST CODE_mstr WHERE CODE_domain = GLOBAL_domain
               AND CODE_fldname = "so_channel"
               AND CODE_value = so_channel NO-LOCK NO-ERROR.

           CREATE tt1.
           ASSIGN tt1_cust = so_cust
                  tt1_cust_name = ad_name
                  tt1_sod_nbr = sod_nbr
                  tt1_so_po  = so_po
                  tt1_so_channel = CODE_cmmt
                  tt1_sod_line = sod_line
                  tt1_sod_part = sod_part
                  tt1_sod_due_date = sod_due_date
                  tt1_sod_qty_ord  = sod_qty_ord
                  tt1_sod_list_pr = sod_list_pr
                  tt1_so_curr = so_curr
                  tt1_sod_amt = sod_qty_ord * sod_list_pr
                  tt1_so_ord_date = so_ord_date
                   .

       END.

   end. /* end so_mstr */


   PUT UNFORMATTED "#def REPORTPATH=$/PORITE/" + SUBSTRING(execname,1,LENGTH(execname) - 2) SKIP.
   PUT UNFORMATTED "#def :end" SKIP.

FOR EACH tt1:
    EXPORT DELIMITER ";" tt1.

END.

EMPTY TEMP-TABLE tt1.

   /* REPORT TRAILER */
   {mfreset.i}

end.

{wbrp04.i &frame-spec = a}
