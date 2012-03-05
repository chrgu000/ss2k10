/* soivrp09.p - INVOICE HISTORY REPORT BY INVOICE                       */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert soivrp09.p (converter v1.00) Tue Sep 30 12:00:06 1997 */
/* web tag in soivrp09.p (converter v1.00) Mon Sep 29 14:35:39 1997 */
/*F0PN*/ /*K0LH*/ /*V8#ConvertMode=WebReport                               */
/*V8:ConvertMode=FullGUIReport                                 */
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
/* REVISION: 7.0      LAST MODIFIED: 04/08/92   BY: tmd *F367*   (rev only) */
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
         /* DISPLAY TITLE */
         /* SS - Bill - B 2005.07.07 */
         /*
/*H009*/ {mfdtitle.i "e+ "}
         */
         {a6mfdtitle.i "e+ "}
         {a6soivrp09.i}
         /* SS - Bill - E */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE soivrp09_p_1 "毛利合计"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivrp09_p_2 "总价格"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivrp09_p_3 "折扣"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivrp09_p_4 "合计 "
/* MaxLen: Comment: */

&SCOPED-DEFINE soivrp09_p_5 "单件毛利"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivrp09_p_6 "税款合计"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


/*J053*/ define new shared variable rndmthd like rnd_rnd_mthd.
/*J053*/ define new shared variable oldcurr like ih_curr.
/*GK02*/ /*CHANGED ALL LOCAL VARIABLES TO NEW SHARED FOR soivrp09a.p */
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
/*G1P6*       format "x(4)" initial "Base". */
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
/*J053* /*H009*/ /*D202*/ {mfsotrla.i "NEW"} */

/*D506*/ define new shared variable net_price like idh_price.
/*D617*/ define new shared variable base_net_price like net_price.
/*F202*/ define new shared variable detail_lines like mfc_logical.
/*G047*/ define new shared variable bill  like ih_bill.
/*G047*/ define new shared variable bill1 like ih_bill.
/*J053*/ define variable maint like mfc_logical.
/*GK02*/ /*{soivtot1.i}  /* Define variables for invoice totals. */ */
/*GK02*/ {soivtot1.i "NEW" }  /* Define variables for invoice totals. */

    /* SS - Bill - B 2005.06.30 */
    DEFINE BUFFER wfidh_pl FOR wfidh.
    DEFINE BUFFER wfidh_cc FOR wfidh.
    DEFINE VARIABLE pl_qty_inv LIKE wfidh_qty_inv.
    DEFINE VARIABLE pl_base_price LIKE wfidh_base_price.
    DEFINE VARIABLE cc_qty_inv LIKE wfidh_qty_inv.
    DEFINE VARIABLE cc_base_price LIKE wfidh_base_price.

    DEFINE NEW SHARED VARIABLE inv_date LIKE ih_inv_date.
    DEFINE NEW SHARED VARIABLE inv_date1 LIKE ih_inv_date.
    DEFINE INPUT PARAMETER eff_dt LIKE gltr_eff_dt.
    DEFINE INPUT PARAMETER eff_dt1 LIKE gltr_eff_dt.
    DEFINE INPUT PARAMETER entity LIKE gltr_entity.
    DEFINE INPUT PARAMETER entity1 LIKE gltr_entity.
    
    /* SS - Bill - E */

/*D202*/ maint = no.
/*GK02 ****
/*G047*  Define trailer forms */
 *       if gl_can then do:
 *          {ctivtrfm.i}
 *       end.
 *       else do:
 *          {soivtrfm.i}
 *       end.
 *GK02***/
         form
             /* SS - Bill - B 2005.07.01 */
             inv_date            colon 15
             inv_date1           label {t001.i} colon 49 skip
             eff_dt            colon 15
             eff_dt1           label {t001.i} colon 49 skip
             /* SS - Bill - E */
             inv            colon 15
             inv1           label {t001.i} colon 49 skip
             nbr            colon 15
             nbr1           label {t001.i} colon 49 skip
             cust           colon 15
             cust1          label {t001.i} colon 49 skip
/*G047*/     bill           colon 15
/*G047*/     bill1          label {t001.i} colon 49 skip
             spsn           colon 15
             spsn1          label {t001.i} colon 49 skip
             po             colon 15
             po1            label {t001.i} colon 49
             base_rpt       colon 15 skip
         with frame a side-labels width 80.

         find first gl_ctrl no-lock. /*D507*/

/*K0LH*/ {wbrp01.i}

    /* SS - Bill - B 2005.07.07 */
    /*
         repeat:
             */
             /* SS - Bill - E */
/*J053*/    oldcurr = "".
            tot_trl1     = 0.
            tot_trl2     = 0.
            tot_trl3     = 0.
            tot_disc     = 0.
            rpt_tot_tax  = 0.
            tot_ord_amt  = 0.

            if inv1 = hi_char then inv1 = "".
            if nbr1 = hi_char then nbr1 = "".
            if cust1 = hi_char then cust1 = "".
/*G047*/    if bill1 = hi_char then bill1 = "".
            if spsn1 = hi_char then spsn1 = "".
            if po1 = hi_char then po1 = "".
            /* SS - Bill - B 2005.07.01 */
            IF inv_date = low_date THEN inv_date = ?.
            IF inv_date1 = hi_date THEN inv_date1 = TODAY.
            IF eff_dt = low_date THEN eff_dt = ?.
            IF eff_dt1 = hi_date THEN eff_dt1 = TODAY.


/*
/*K0LH*/ if c-application-mode <> 'web':u then
        update inv inv1 nbr nbr1 cust cust1
/*G047*/           bill bill1
                   spsn spsn1 po po1
                   base_rpt with frame a.

/*K0LH*/ {wbrp06.i &command = update &fields = "  inv inv1 nbr nbr1 cust cust1  bill
bill1 spsn spsn1 po po1 base_rpt" &frm = "a"}
*/
            /* SS - Bill - E */

/*K0LH*/ if (c-application-mode <> 'web':u) or
/*K0LH*/ (c-application-mode = 'web':u and
/*K0LH*/ (c-web-request begins 'data':u)) then do:


            bcdparm = "".
            /* SS - Bill - B 2005.07.01 */
            {mfquoter.i inv_date     }
            {mfquoter.i inv_date1    }
            {mfquoter.i eff_dt     }
            {mfquoter.i eff_dt1    }
            /* SS - Bill - E */
            {mfquoter.i inv     }
            {mfquoter.i inv1    }
            {mfquoter.i nbr     }
            {mfquoter.i nbr1    }
            {mfquoter.i cust    }
            {mfquoter.i cust1   }
/*G047*/    {mfquoter.i bill    }
/*G047*/    {mfquoter.i bill1   }
            {mfquoter.i spsn    }
            {mfquoter.i spsn1   }
            {mfquoter.i po      }
            {mfquoter.i po1     }
            {mfquoter.i base_rpt }

                /* SS - Bill - B 2005.07.01 */
                IF inv_date = ? THEN inv_date = low_date.
                IF inv_date1 = ? THEN inv_date1 = TODAY.
                IF eff_dt = ? THEN eff_dt = low_date.
                IF eff_dt1 = ? THEN eff_dt1 = TODAY.
                /* SS - Bill - E */
            if inv1 = "" then inv1 = hi_char.
            if nbr1 = "" then nbr1 = hi_char.
            if cust1 = "" then cust1 = hi_char.
/*G047*/    if bill1 = "" then bill1 = hi_char.
            if spsn1 = "" then spsn1 = hi_char.
            if po1 = "" then po1 = hi_char.

/*K0LH*/ end.

            /* SS - Bill - B 2005.06.30 */
            /*
            /* SELECT PRINTER */
        {mfselbpr.i "printer" 132}

            {mfphead.i}
            */
/*GK02*/    /* Moved for each ih_hist to soivrp9a.p due rcode limits */
            /*
            {gprun.i ""soivrp9a.p""}
            */
             {gprun.i ""a6soivrp9c.p""
                "(input eff_dt,
                INPUT eff_dt1,
                INPUT entity,
                INPUT entity1)"
             }
            /* REPORT TRAILER */
            /*
            {mfrtrail.i}

         end.
            */
            /* SS - Bill - E */

/*K0LH*/ {wbrp04.i &frame-spec = a}
