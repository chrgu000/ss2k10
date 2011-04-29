/* poporp11.p - UNVOUCHERED PO RECEIPT AS OF DATE REPORT                      */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* Revision: 1.5        BY: Patrick de Jong       DATE: 04/16/02  ECO: *N1B4* */
/* Revision: 1.5        BY: Patrick de Jong       DATE: 04/31/02  ECO: *P07H* */
/* Revision: 1.6        BY: Patrick Rowan         DATE: 06/18/02  ECO: *P090* */
/* Revision: 1.8        BY: Ellen Borden          DATE: 08/25/02  ECO: *P0DB* */
/* Revision: 1.9        BY: Ellen Borden          DATE: 08/25/02  ECO: *P0HV* */
/* Revision: 1.10       BY: K Paneesh             DATE: 04/15/03  ECO: *P0PZ* */
/* Revision: 1.12       BY: Paul Donnelly (SB)    DATE: 06/28/03  ECO: *Q00J* */
/* Revision: 1.13       BY: Bhagyashri Shinde     DATE: 12/03/04  ECO: *P2Y1* */
/* Revision: 1.14       BY: Robin McCarthy        DATE: 01/05/05  ECO: *P2P6* */
/* Revision: 1.15       BY: Robin McCarthy        DATE: 02/22/05  ECO: *P2XY* */
/* Revision: 1.18       BY: Vandna Rohira         DATE: 03/03/05  ECO: *P2XP* */
/* Revision: 1.19       BY: Vandna Rohira         DATE: 03/17/05  ECO: *P3CM* */
/* Revision: 1.20       BY: Binoy John            DATE: 04/18/05  ECO: *P3GK* */
/* Revision: 1.21       BY: Shivganesh Hegde      DATE: 04/27/05  ECO: *P3J9* */
/* Revision: 1.22       BY: Swati Sharma          DATE: 05/18/05  ECO: *P3LQ* */
/* Revision: 1.23       BY: Anil Sudhakaran       DATE: 08/11/05  ECO: *P2PJ* */
/* Revision: 1.23.1.1   BY: Shivaraman V.         DATE: 09/02/05  ECO: *P40J* */
/* Revision: 1.23.1.4   BY: Nishit V              DATE: 11/15/05  ECO: *Q0MK* */
/* Revision: 1.23.1.5   BY: Geeta Kotian          DATE: 12/29/05  ECO: *P4DW* */
/* Revision: 1.23.1.10  BY: Steve Nugent       DATE: 04/03/06  ECO: *P4JR*  */
/* $Revision: 1.23.1.11 $ BY: Shridhar M       DATE: 04/26/06  ECO: *Q0TN*  */
/*-Revision end---------------------------------------------------------------*/
/*V8:ConvertMode=Report                                                       */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 100715.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/

/* SS - 100715.1 - B 
{mfdtitle.i "1+ "}
   SS - 100715.1 - E */
/* SS - 100715.1 - B */
{mfdeclre.i}
{gplabel.i} 

{xxporp002.i}
/* SS - 100715.1 - E */


{cxcustom.i "POPORP11.P"}

/* SS - 100715.1 - B */
define input parameter i-rcpt_from  like prh_rcp_date format "99/99/99" no-undo.
define input parameter i-rcpt_to    like prh_rcp_date format "99/99/99" no-undo.
define input parameter i-vendor     like po_vend no-undo.
define input parameter i-vendor1    like po_vend no-undo.
define input parameter i-nbr        like po_nbr no-undo.
define input parameter i-nbr1       like po_nbr no-undo.
define input parameter i-buyer      like po_buyer no-undo.
define input parameter i-buyer1     like po_buyer no-undo.

/*
define input parameter i-part       like pt_part no-undo.
define input parameter i-part1      like pt_part no-undo.
define input parameter i-site       like pt_site no-undo.
define input parameter i-site1      like pt_site no-undo.
define input parameter i-acc        like ap_acct no-undo.
define input parameter i-acc1       like ap_acct no-undo.
define input parameter i-sub        like ap_sub no-undo.
define input parameter i-sub1       like ap_sub no-undo.
define input parameter i-cc         like ap_cc no-undo.
define input parameter i-cc1        like ap_cc no-undo.
define input parameter i-effdate    like prh_rcp_date format "99/99/99" no-undo.
define input parameter i-sel_inv    like mfc_logical  initial yes no-undo.
define input parameter i-sel_sub    like mfc_logical  initial yes no-undo.
define input parameter i-sel_mem    like mfc_logical  initial yes no-undo.
define input parameter i-use_tot    like mfc_logical  initial no no-undo.
define input parameter i-base_rpt   like po_curr no-undo.
define input parameter i-l-summary  like mfc_logical no-undo.
*/
/* SS - 100715.1 - E */


define variable vendor     like po_vend no-undo.
define variable vendor1    like po_vend no-undo.
define variable part       like pt_part no-undo.
define variable part1      like pt_part no-undo.
define variable site       like pt_site no-undo.
define variable site1      like pt_site no-undo.
define variable acc        like ap_acct no-undo.
define variable acc1       like ap_acct no-undo.
define variable sub        like ap_sub no-undo.
define variable sub1       like ap_sub no-undo.
define variable cc         like ap_cc no-undo.
define variable cc1        like ap_cc no-undo.
define variable effdate    like prh_rcp_date format "99/99/99" no-undo.
define variable rcpt_from  like prh_rcp_date format "99/99/99" no-undo.
define variable sel_inv    like mfc_logical  initial yes no-undo.
define variable sel_sub    like mfc_logical  initial yes no-undo.
define variable sel_mem    like mfc_logical  initial yes no-undo.
define variable use_tot    like mfc_logical  initial no no-undo.
define variable base_rpt   like po_curr no-undo.
define variable l-summary  like mfc_logical no-undo.
define variable rndmthd    like rnd_rnd_mthd no-undo.
define variable oldcurr    like prh_curr no-undo.
define variable std_ext    as decimal format "->>>>>>>>>>9.99<<<" no-undo.
define variable pur_ext    as decimal format "->>>>>>>>>>9.99<<<" no-undo.
define variable tax_accrued as decimal format "->>>>>>>>>>9.99<<<" no-undo.
define variable openTaxAmount like tx2d_totamt no-undo.
define variable invoiceTaxAmount like tx2d_totamt no-undo.
define variable rep_tot_with_tax as decimal format "->>>>>>>>>>9.99<<<" no-undo.
define variable std_cost   as decimal format "->>>>>>>9.99<<<" no-undo.
define variable std_var    as decimal format "->>>>>>>9.99<<<" no-undo.
define variable base_cost  as decimal format "->>>>>>>>9.99<<<" no-undo.
define variable disp_curr  as character format "X(1)" no-undo.
define variable descname   as character format "x(50)" no-undo.
define variable qty_open   as decimal   format "->>>>>>9.9<<<<<<"  no-undo.
define variable exdrate    like ap_ex_rate no-undo.
define variable last_nbr   like prh_nbr no-undo.
define variable last_vend  like prh_vend no-undo.
define variable base_std_cost as decimal no-undo.
define variable rcptacct   like ap_acct no-undo.
define variable rcptsub    like ap_sub no-undo.
define variable rcptcc     like ap_cc no-undo.
define variable rcptxacct  like ap_acct no-undo.
define variable rcptxsub   like ap_sub no-undo.
define variable rcptxcc    like ap_cc no-undo.
define variable receiptacc like ap_acct no-undo.
define variable receiptsub like ap_sub no-undo.
define variable receiptcc  like ap_cc no-undo.
define variable qty_vph    like qty_open no-undo.
define variable vendor_type like vd_type no-undo.
define variable mc-error-number  like msg_nbr no-undo.
define variable excl_unconfirmed like mfc_logical initial yes no-undo.
define variable l_pvod_eff_date as date no-undo.
define variable l_pvod_trans_qty as decimal no-undo.

define variable l_sitedb   like si_db   no-undo.
define variable l_old_db   like si_db   no-undo.
define variable err-flag   as   integer no-undo.

define temp-table tt_summary no-undo
   field tt_acc     like ap_acct
   field tt_sub     like ap_sub
   field tt_cc      like ap_cc
   field tt_pur_ext as decimal format "->>,>>>,>>>,>>9.99" initial 0
   index tt_acc_cc is primary
   tt_acc
   tt_sub
   tt_cc.

{apconsdf.i}
{popvodet.i}   /* pvod_det TEMP-TABLE DEFINITION */

define variable totalTransQty as decimal no-undo.
define variable totalTaxAccrued as decimal no-undo.
define variable pvod-trx-cost like prh_pur_cost no-undo.
define buffer b_tt_pvod_det for tt_pvoddet.

for first gl_ctrl where gl_domain = global_domain no-lock: end.

/* SELECT FORM */
form
   vendor           colon 15
   vendor1          label "To" colon 49 skip
   part             colon 15
   part1            label "To" colon 49 skip
   site             colon 15
   site1            label "To" colon 49
   acc              colon 15
   acc1             label "To" colon 49 skip
   sub              colon 15
   sub1             label "To" colon 49 skip
   cc               label "Cost Center" colon 15
   cc1              label "To"                             colon 49 skip
   effdate          label "Effective Date"                 colon 31
   rcpt_from        label "Show Purchase Receipts From"    colon 31
   sel_inv          label "Inventory Items"                colon 31
   sel_sub          label "Subcontracted Items"            colon 31
   sel_mem          label "Memo Items"                     colon 31
   excl_unconfirmed label "Unconfirmed Vouchered Receipts" colon 31
   use_tot          label "Use Total Std Cost"             colon 31
   base_rpt         colon 31
   l-summary        label "Summary" colon 31
with frame a side-labels width 80.

setFrameLabels(frame a:handle).

{wbrp01.i &io-frame = "a"}

/* SS - 100715.1 - B */
for each temp1 : delete temp1 . end .

assign 
    vendor      = i-vendor     
    vendor1     = i-vendor1        
    rcpt_from   = i-rcpt_from    
    .
/* SS - 100715.1 - E */


/* REPORT BLOCK */
repeat:

   if vendor1    = hi_char then vendor1 = "".
   if part1      = hi_char then part1 = "".
   if site1      = hi_char then site1 = "".
   if acc1       = hi_char then acc1 = "".
   if sub1       = hi_char then sub1 = "".
   if cc1        = hi_char then cc1 = "".
   if rcpt_from  = low_date then rcpt_from = ?.
   if effdate    = ? then effdate = today.

/* SS - 100715.1 - B 

   if c-application-mode <> 'web' then
   update
      vendor vendor1
      part part1
      site site1
      acc acc1
      sub sub1
      cc cc1
      effdate
      rcpt_from
      sel_inv
      sel_sub
      sel_mem
      excl_unconfirmed
      use_tot
      base_rpt
      l-summary
   with frame a.

   {wbrp06.i &command = update &fields = "vendor vendor1 part part1
              site site1 acc acc1 sub sub1 cc cc1
              effdate rcpt_from
              sel_inv sel_sub sel_mem
              excl_unconfirmed
              use_tot base_rpt l-summary" &frm = "a"}

   bcdparm = "".
   run ip-quoter.

   SS - 100715.1 - E */


   if vendor1   = "" then vendor1   = hi_char.
   if part1     = "" then part1     = hi_char.
   if site1     = "" then site1     = hi_char.
   if acc1      = "" then acc1      = hi_char.
   if sub1      = "" then sub1      = hi_char.
   if cc1       = "" then cc1       = hi_char.
   if rcpt_from = ?  then rcpt_from = low_date.
   if effdate   = ?  then effdate   = today.

   /* OUTPUT DESTINATION SELECTION */
/* SS - 100715.1 - B 
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

   {mfphead.i}
   SS - 100715.1 - E */

   for each tt_summary exclusive-lock:
      delete tt_summary.
   end.

   assign
      oldcurr = ""
      last_nbr = ""
      last_vend = "".

   do on endkey undo, leave:
