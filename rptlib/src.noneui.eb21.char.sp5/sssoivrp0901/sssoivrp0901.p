/* soivrp09.p - INVOICE HISTORY REPORT BY INVOICE                       */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.8.2.5 $                                             */
/*V8:ConvertMode=FullGUIReport                                          */
/* REVISION: 5.0      LAST MODIFIED: 01/09/90   BY: ftb *B511**/
/* REVISION: 6.0      LAST MODIFIED: 04/13/90   BY: ftb *D002**/
/* REVISION: 6.0      LAST MODIFIED: 09/18/90   BY: MLB *D055**/
/* REVISION: 6.0      LAST MODIFIED: 11/12/90   BY: MLB *D202**/
/* REVISION: 6.0      LAST MODIFIED: 03/28/91   BY: afs *D464**/
/* REVISION: 6.0      LAST MODIFIED: 04/05/91   BY: bjb *D507**/
/* REVISION: 6.0      LAST MODIFIED: 04/10/91   BY: MLV *D506**/
/* REVISION: 6.0      LAST MODIFIED: 05/07/91   BY: MLV *D617**/
/* REVISION: 6.0      LAST MODIFIED: 08/14/91   BY: MLV *D825**/
/* REVISION: 6.0      LAST MODIFIED: 08/21/91   BY: bjb *D811*/
/* REVISION: 7.0      LAST MODIFIED: 09/16/91   BY: MLV *F015**/
/* REVISION: 7.0      LAST MODIFIED: 02/02/92   BY: pml *F129**/
/* REVISION: 7.0      LAST MODIFIED: 02/12/92   BY: tjs *F202**/
/* REVISION: 7.0      LAST MODIFIED: 03/04/92   BY: tjs *F247* (rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 03/17/92   BY: TMD *F259**/
/* REVISION: 7.0      LAST MODIFIED: 03/20/92   BY: TMD *F263* (rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 03/20/92   BY: dld *F322*           */
/* REVISION: 7.0      LAST MODIFIED: 04/08/92   BY: tmd *F367* (rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 04/06/92   BY: dld *F358*           */
/* REVISION: 7.0      LAST MODIFIED: 06/19/92   BY: tmd *F458**/
/* REVISION: 7.3      LAST MODIFIED: 09/06/92   BY: afs *G047**/
/* REVISION: 7.4      LAST MODIFIED: 08/19/93   BY: pcd *H009* */
/* REVISION: 7.4      LAST MODIFIED: 05/31/94   BY: dpm *GK02* */
/* REVISION: 8.5      LAST MODIFIED: 07/27/95   BY: taf *J053* */
/* REVISION: 8.5      LAST MODIFIED: 04/09/96   BY: jzw *G1P6* */
/* REVISION: 8.6      LAST MODIFIED: 10/04/97   BY: ckm *K0LH* */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* myb              */
/* REVISION: 9.1      LAST MODIFIED: 10/10/00   BY: *N0W8* Mudit Mehta      */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* Revision: 1.8.2.4     BY: Katie Hilbert  DATE: 04/01/01 ECO: *P002* */
/* $Revision: 1.8.2.5 $    BY: Karan Motwani  DATE: 10/16/02 ECO: *N1WF* */
/* $Revision: 1.8.2.5 $    BY: Bill Jiang  DATE: 07/26/07 ECO: *SS - 20070726.1* */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
/* SS - 20070726.1 - B */
/*
{mfdtitle.i "2+ "}
*/
{a6mfdtitle.i "2+ "}
/* SS - 20070726.1 - E */
{cxcustom.i "SOIVRP09.P"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE soivrp09_p_1 "Ext Margin"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivrp09_p_2 "Ext Price"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivrp09_p_3 "Discount"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivrp09_p_4 "Total"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivrp09_p_5 "Unit Margin"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivrp09_p_6 "Total Tax"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define new shared variable rndmthd like rnd_rnd_mthd.
define new shared variable oldcurr like ih_curr.
/*CHANGED ALL LOCAL VARIABLES TO NEW SHARED FOR soivrp09a.p */
define new shared variable cust like ih_cust.
define new shared variable cust1 like ih_cust.
define new shared variable inv like ih_inv_nbr.
define new shared variable inv1 like ih_inv_nbr.
define new shared variable nbr like ih_nbr.
define new shared variable nbr1 like ih_nbr.
define new shared variable name like ad_name.
define new shared variable spsn like sp_addr.
define new shared variable spsn1 like spsn.
define new shared variable po like ih_po.
define new shared variable po1 like ih_po.
define new shared variable gr_margin like idh_price label {&soivrp09_p_5}
   format "->>>>>,>>9.99".
define new shared variable ext_price like idh_price label {&soivrp09_p_2}
   format "->>,>>>,>>>.99".
define new shared variable ext_gr_margin like gr_margin
   label {&soivrp09_p_1}.
define new shared variable desc1 like pt_desc1 format "x(49)".
define new shared variable curr_cost like idh_std_cost.
define new shared variable base_price like ext_price.
define new shared variable base_margin like ext_gr_margin.
define new shared variable ext_cost like idh_std_cost.
define new shared variable base_rpt like ih_curr.
define new shared variable disp_curr as character
   format "x(1)" label "C".
define new shared variable ih_recno as recid.
define new shared variable tot_trl1 like ih_trl1_amt.
define new shared variable tot_trl3 like ih_trl3_amt.
define new shared variable tot_trl2 like ih_trl2_amt.
define new shared variable tot_disc like ih_trl1_amt label {&soivrp09_p_3}.
define new shared variable rpt_tot_tax like ih_trl2_amt
   label {&soivrp09_p_6}.
define new shared variable tot_ord_amt like ih_trl3_amt label {&soivrp09_p_4}.
define new shared variable net_price like idh_price.
define new shared variable base_net_price like net_price
                                 format "->>>>,>>>,>>9.99".
define new shared variable detail_lines like mfc_logical.
define new shared variable bill  like ih_bill.
define new shared variable bill1 like ih_bill.
define variable maint like mfc_logical.

/* SS - 20070726.1 - B */
DEFINE NEW SHARED VARIABLE entity LIKE gltr_entity.
DEFINE NEW SHARED VARIABLE entity1 LIKE gltr_entity.
DEFINE NEW SHARED VARIABLE eff_dt LIKE gltr_eff_dt.
DEFINE NEW SHARED VARIABLE eff_dt1 LIKE gltr_eff_dt.
DEFINE NEW SHARED VARIABLE inv_date LIKE ih_inv_date.
DEFINE NEW SHARED VARIABLE inv_date1 LIKE ih_inv_date.

DEFINE input parameter i_entity LIKE gltr_entity.
DEFINE input parameter i_entity1 LIKE gltr_entity.
DEFINE input parameter i_eff_dt LIKE gltr_eff_dt.
DEFINE input parameter i_eff_dt1 LIKE gltr_eff_dt.
DEFINE input parameter i_inv_date LIKE ih_inv_date.
DEFINE input parameter i_inv_date1 LIKE ih_inv_date.

define input parameter i_inv like ih_inv_nbr.
define input parameter i_inv1 like ih_inv_nbr.
define input parameter i_nbr like ih_nbr.
define input parameter i_nbr1 like ih_nbr.
define input parameter i_cust like ih_cust.
define input parameter i_cust1 like ih_cust.
define input parameter i_bill  like ih_bill.
define input parameter i_bill1 like ih_bill.
define input parameter i_spsn like sp_addr.
define input parameter i_spsn1 like spsn.
define input parameter i_po like ih_po.
define input parameter i_po1 like ih_po.
define input parameter i_base_rpt like ih_curr.
/* SS - 20070726.1 - E */

{soivtot1.i "NEW" }  /* Define variables for invoice totals. */

maint = no.

{&SOIVRP09-P-TAG1}
form
   inv            colon 15
   inv1           label {t001.i} colon 49 skip
   nbr            colon 15
   nbr1           label {t001.i} colon 49 skip
   cust           colon 15
   cust1          label {t001.i} colon 49 skip
   bill           colon 15
   bill1          label {t001.i} colon 49 skip
   spsn           colon 15
   spsn1          label {t001.i} colon 49 skip
   po             colon 15
   po1            label {t001.i} colon 49
   base_rpt       colon 15 skip
with frame a side-labels width 80.
{&SOIVRP09-P-TAG2}

/* SS - 20070726.1 - B */
/*
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
*/
/* SS - 20070726.1 - E */

/* SS - 20070726.1 - B */
entity = i_entity.
entity1 = i_entity1.
eff_dt = i_eff_dt.
eff_dt1 = i_eff_dt1.
inv_date = i_inv_date.
inv_date1 = i_inv_date1.

inv = i_inv.
inv1 = i_inv1.
nbr = i_nbr.
nbr1 = i_nbr1.
cust = i_cust.
cust1 = i_cust1.
bill = i_bill.
bill1 = i_bill1.
spsn = i_spsn.
spsn1 = i_spsn1.
po = i_po.
po1 = i_po1.
base_rpt = i_base_rpt.
/* SS - 20070726.1 - E */

{wbrp01.i}

/* SS - 20070726.1 - B */
/*
repeat:
*/
/* SS - 20070726.1 - E */
   assign
      oldcurr = ""
      tot_trl1     = 0
      tot_trl2     = 0
      tot_trl3     = 0
      tot_disc     = 0
      rpt_tot_tax  = 0
      tot_ord_amt  = 0.

   if inv1 = hi_char then inv1 = "".
   if nbr1 = hi_char then nbr1 = "".
   if cust1 = hi_char then cust1 = "".
   if bill1 = hi_char then bill1 = "".
   if spsn1 = hi_char then spsn1 = "".
   if po1 = hi_char then po1 = "".
   /* SS - 20070726.1 - B */
   IF entity1 = hi_char THEN entity1 = "".
   IF eff_dt = low_date THEN eff_dt = ?.
   IF eff_dt1 = hi_date THEN eff_dt1 = TODAY.
   IF inv_date = low_date THEN inv_date = ?.
   IF inv_date1 = hi_date THEN inv_date1 = TODAY.
   /* SS - 20070726.1 - E */

   /* SS - 20070726.1 - B */
   /*
   if c-application-mode <> 'web' then
   {&SOIVRP09-P-TAG3}
   update inv inv1 nbr nbr1 cust cust1
      bill bill1
      spsn spsn1 po po1
      base_rpt with frame a.

   {wbrp06.i &command = update &fields = "  inv inv1 nbr nbr1 cust cust1  bill
                                  bill1 spsn spsn1 po po1 base_rpt" &frm = "a"}
   {&SOIVRP09-P-TAG4}
    */
    /* SS - 20070726.1 - E */

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      bcdparm = "".
      {mfquoter.i inv     }
      {mfquoter.i inv1    }
      {mfquoter.i nbr     }
      {mfquoter.i nbr1    }
      {mfquoter.i cust    }
      {mfquoter.i cust1   }
      {mfquoter.i bill    }
      {mfquoter.i bill1   }
      {mfquoter.i spsn    }
      {mfquoter.i spsn1   }
      {mfquoter.i po      }
      {mfquoter.i po1     }
      {mfquoter.i base_rpt }
      /* SS - 20070726.1 - B */
      {mfquoter.i entity     }
      {mfquoter.i entity1    }
      {mfquoter.i eff_dt     }
      {mfquoter.i eff_dt1    }
      {mfquoter.i inv_date     }
      {mfquoter.i inv_date1    }
      /* SS - 20070726.1 - E */
      {&SOIVRP09-P-TAG5}

      if inv1 = "" then inv1 = hi_char.
      if nbr1 = "" then nbr1 = hi_char.
      if cust1 = "" then cust1 = hi_char.
      if bill1 = "" then bill1 = hi_char.
      if spsn1 = "" then spsn1 = hi_char.
      if po1 = "" then po1 = hi_char.
      /* SS - 20070726.1 - B */
      if entity1 = "" then entity1 = hi_char.
      IF eff_dt = ? THEN eff_dt = low_date.
      IF eff_dt1 = ? THEN eff_dt1 = TODAY.
      IF inv_date = ? THEN inv_date = low_date.
      IF inv_date1 = ? THEN inv_date1 = TODAY.
      /* SS - 20070726.1 - E */

   end.

   /* SS - 20070726.1 - B */
   /*
   /* SELECT PRINTER */
   {mfselbpr.i "printer" 132}

   {mfphead.i}
   {gprun.i ""soivrp9a.p""}
   /* REPORT TRAILER */
   {mfrtrail.i}

end.
   */
   {gprun.i ""sssoivrp0901a.p""}
   /* SS - 20070726.1 - E */

{wbrp04.i &frame-spec = a}
