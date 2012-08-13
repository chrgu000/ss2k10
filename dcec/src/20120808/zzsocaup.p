/* GUI CONVERTED from socaup.p (converter v1.69) Tue Aug 19 06:19:57 1997 */
/* socaup.p SALES ORDER AUTO CREDIT APPROVAL UPDATE             */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*J06N*/ /*V8:ConvertMode=Report                                */
/*J06N* *F0PN* was V 8:Convert Mode=FullGUIReport               */
/* Revision: 5.0      LAST MODIFIED: 03/28/90   BY: ftb         */
/* Revision: 6.0      LAST MODIFIED: 10/18/90   BY: pml *D106*  */
/* Revision: 6.0      LAST MODIFIED: 12/02/90   BY: afs *D236*  */
/* Revision: 6.0      LAST MODIFIED: 01/26/91   BY: pml *D319*  */
/* Revision: 6.0      LAST MODIFIED: 04/05/91   BY: bjb *D507*  */
/* Revision: 7.3      LAST MODIFIED: 09/03/92   BY: afs *G045*  */
/* Revision: 7.3      LAST MODIFIED: 12/01/92   BY: mpp *G484*  */
/* Revision: 7.3      LAST MODIFIED: 01/26/93   BY: tjs *G599*  */
/* Revision: 7.4      LAST MODIFIED: 10/01/93   BY: tjs *H070*  */
/* Revision: 7.4      LAST MODIFIED: 01/10/93   BY: tjs *H188*  */
/* Revision: 7.4      LAST MODIFIED: 02/01/94   BY: tjs *FL86*  */
/* Revision: 7.4      LAST MODIFIED: 06/15/94   BY: dpm *FO89*  */
/* Revision: 7.4      LAST MODIFIED: 06/21/94   BY: dpm *H396*  */
/* Revision: 7.4      LAST MODIFIED: 11/01/94   BY: bcm *H583*  */
/* Revision: 8.5      LAST MODIFIED: 07/21/95   BY: tjs *J04F*  */
/*                                   08/08/95   BY: srk *J06N*  */
/*                                   08/30/95   BY: kjm *G0VZ*  */
/*                                   10/25/95   by: jym *G0XY*  */
/* Revision: 7.3      LAST MODIFIED: 10/24/95   BY: rvw *G19Z*  */
/* Revision: 8.5      LAST MODIFIED: 07/27/95   BY: taf *J053*  */
/* Revision: 8.5      LAST MODIFIED: 05/28/96   BY: tzp *G1W8*  */
/* REVISION: 8.5      LAST MODIFIED: 07/19/96   BY: taf *J0ZZ**/
/* REVISION: 8.5      LAST MODIFIED: 04/23/97   BY: *J1LV* Aruna Patil */
/* REVISION: 8.5      LAST MODIFIED: 08/14/97   BY: *J1Z0* Ajit Deodhar */
/* REVISION: 8.5      LAST MODIFIED: 11/14/03   BY: *LB01* Long Bo         */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "e+ "}  /*H188*/

/*G0XY*/ define new shared variable convertmode as character no-undo
/*J1Z0**                  initial "REPORT". */
/*J1Z0*/                  initial "report".

/*J053*/ define new shared variable rndmthd like rnd_rnd_mthd.
     define variable nbr like so_nbr.
     define variable nbr1 like so_nbr.
/*G599*  define variable cust like so_cust.  */
/*G599*  define variable cust1 like so_cust. */
/*G599*/ define variable cust like so_bill.
/*G599*/ define variable cust1 like so_bill.
     define variable ord_date like so_ord_date.
     define variable ord_date1 like so_ord_date.
     define variable due_date like so_due_date.
     define variable due_date1 like so_due_date.
     define variable act_stat like so_stat.
     define variable act_stat1 like so_stat.
     define variable ovr_cr_lim like mfc_logical initial yes.
     define variable inc_so_bal like mfc_logical initial yes.
     define variable off_cr_hold like mfc_logical initial yes.
     define variable past_due like mfc_logical initial no.
     define variable past_due_days as integer format ">>9" initial 30.
     define variable past_due_allow like ar_amt.
     define variable past_due_tot like ar_amt label "过期" initial 0.
     define variable past_due_date as integer.
     define variable set_hold like mfc_logical initial no.
     define variable rmv_hold like mfc_logical initial no.
     define variable cur_ar_amt like ar_amt.
     define variable so_open_amt like ar_amt label "未结金额".
     define variable open_amt like ar_amt.
     define variable line_amt like ar_amt.
     define variable total_exp like ar_amt.
     define variable cust_name like ad_name.
     define variable closed like mfc_logical.
     define variable age_date like ar_due_date initial today.
     define variable base_amt like ar_amt.
     define variable curr_amt like ar_amt.
     define variable base_applied like ar_amt.
     define variable due-date like due_date.
/*H070*/ define variable disc-date like due_date.
     define variable applied-amt like ar_amt.
     define variable this-applied like ar_amt.
     define variable amt-due like ar_amt.
     define variable cr_remain like ar_amt label "信贷余额".
     define variable first_cust like mfc_logical.
/*J04F*/ define variable last_so_bill like so_bill.
/*G484*/ define variable exdrate like exd_rate.
/*J1LV*/ define variable l_new_so like mfc_logical initial no no-undo.
/*H188*/ define new shared variable so_recno as recid.
/*H188*/ define new shared variable new_order      like mfc_logical initial no.
/*H188*/ define new shared variable due_date_range like mfc_logical initial yes.
/*H188*/ define new shared variable date_range     like sod_due_date.
/*H188*/ define new shared variable date_range1    like sod_due_date.
/*H188*/ define new shared variable display_trail  like mfc_logical initial no.
/*J053 /*H188*/ define new shared variable tax_edit like mfc_logical initial false. */
/*J053* /*H188*/ define new shared variable tax_edit_lbl like mfc_char format "x(28)".*/
/*J053*/ define variable oldcurr like so_curr no-undo.
/*H188*/ define new shared variable undo_trl2 like mfc_logical.
/*H188*/ define new shared frame sotot.
/*H396*/ define            variable first_time     like mfc_logical.

/*H188*/ {mfsotrla.i "NEW"}
/*J053* /*H188*/    {sototfrm.i} /* Define tralier form for Tax Management */ */
/*G1W8*/ define buffer somstr for so_mstr.

/*J053*/ assign
/*J053*/   nontax_old = nontaxable_amt:format
/*J053*/   taxable_old = taxable_amt:format
/*J053*/   line_tot_old = line_total:format
/*J053*/   line_pst_old = line_pst:format
/*J053*/   disc_old     = disc_amt:format
/*J053*/   trl_amt_old = so_trl1_amt:format
/*J053*/   tax_amt_old = tax_amt:format
/*J053*/   tot_pst_old = total_pst:format
/*J053*/   tax_old     = tax[1]:format
/*J053*/   amt_old     = amt[1]:format
/*J053*/   ord_amt_old = ord_amt:format.

/*J053*/ oldcurr = "".





/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
nbr            colon 20
   nbr1           label {t001.i} colon 54 skip
   cust           colon 20
   cust1          label {t001.i} colon 54 skip
   ord_date       colon 20
   ord_date1      label {t001.i} colon 54 skip
   due_date       colon 20
   due_date1      label {t001.i} colon 54 skip
   act_stat       colon 20
   act_stat1      label {t001.i} colon 54 skip(1)
   set_hold       label "清除执行状态"     colon 39
   off_cr_hold    label "检查资信冻结"       colon 39 skip(1)
   ovr_cr_lim     label "检查信贷限额"      colon 39 skip
   inc_so_bal     label "包括客户订单"   colon 39 skip(1)
   past_due       label "检查过期未付发票" colon 39
   past_due_days  label "天数"                    colon 39
   past_due_allow label "金额"                  colon 39 skip
with frame a side-labels attr-space width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME




/*D507*/ find first gl_ctrl no-lock.


repeat:

   if nbr1 = hi_char then nbr1 = "".
   if cust1 = hi_char then cust1 = "".
   if ord_date = low_date then ord_date = ?.
   if ord_date1 = hi_date or ord_date1 = low_date then
      ord_date1 = ?.
   if due_date = low_date then due_date = ?.
   if due_date1 = hi_date or due_date1 = low_date then
      due_date1 = ?.
   if act_stat1 = hi_char then act_stat1 = "".

   view frame a.
   update nbr
      nbr1
      cust
      cust1
      ord_date
      ord_date1
      due_date
      due_date1
      act_stat
      act_stat1
      set_hold
      off_cr_hold
      ovr_cr_lim
      inc_so_bal
      past_due
      past_due_days
      past_due_allow
   with frame a side-labels attr-space width 80.

   bcdparm = "".
   {mfquoter.i nbr       }
   {mfquoter.i nbr1      }
   {mfquoter.i cust      }
   {mfquoter.i cust1     }
   {mfquoter.i ord_date  }
   {mfquoter.i ord_date1 }
   {mfquoter.i due_date  }
   {mfquoter.i due_date1 }
   {mfquoter.i act_stat  }
   {mfquoter.i act_stat1 }
   {mfquoter.i set_hold  }
   {mfquoter.i off_cr_hold }
   {mfquoter.i ovr_cr_lim}
   {mfquoter.i inc_so_bal}
   {mfquoter.i past_due  }
   {mfquoter.i past_due_days }
   {mfquoter.i past_due_allow }

   if nbr1 = "" then nbr1 = hi_char.
   if cust1 = "" then cust1 = hi_char.
   if ord_date = ? then ord_date = low_date.
   if ord_date1 = ? then ord_date1 = hi_date.
   if due_date = ? then due_date = low_date.
   if due_date1 = ? then due_date1 = hi_date.
/*D319*/
   if act_stat1 = "" then act_stat1 = hi_char.


   /* SELECT PRINTER */
   {mfselbpr.i "printer" 132}
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.

    { mfphead.i }

/*J04F*/ /*******************************************************************
   for each so_mstr where so_nbr >= nbr and so_nbr <= nbr1                  *
/*G599*  and so_cust >= cust and so_cust <= cust1 */                        *
/*G599*/ and so_bill >= cust and so_bill <= cust1                           *
       and so_ord_date >= ord_date and so_ord_date <= ord_date1             *
       and so_stat >= act_stat and so_stat <= act_stat1                     *
/*G599*  break by so_cust by so_ord_date with frame d down : */             *
/*G599*/ break by so_bill by so_ord_date with frame d down :                *
 *J04F*/

/*J04F*/ last_so_bill = ?.
/*G1W8* /*J04F*/ for each so_mstr use-index so_bill exclusive-lock where */
/*G1W8*/ for each so_mstr use-index so_bill no-lock where
/*J04F*/ so_nbr >= nbr and so_nbr <= nbr1 and
/*J04F*/ so_bill >= cust and so_bill <= cust1 and
/*J04F*/ so_ord_date >= ord_date and so_ord_date <= ord_date1
/*J04F*/ break by so_bill by so_ord_date with frame d down width 132:

/*J04F*/    if so_stat < act_stat or so_stat > act_stat1 then next.

/*J053*/    /* SET CURLOOP TO CAUSE SETTING OR FORMATS FOR CURRENCY */
/*J0ZZ************* REPLACE BY GPCURMTH.I ***********************************
** /*J053*/ if (oldcurr <> so_curr) then do:
** /*J053*/    /* DETERMINE ROUNDING METHOD FROM DOCUMENT CURRENCY OR BASE    */
** /*J053*/    if (gl_base_curr <> so_curr) then do:
** /*J053*/       find first ex_mstr where ex_curr = so_curr no-lock no-error.
** /*J053*/       if not available ex_mstr then do:
** /*J053*           CURRENCY EXCHANGE MASTER DOES NOT EXIST              */
** /*J053*/          {mfmsg.i 964 3}
** /*J053*/          leave.
** /*J053*/       end.
** /*J053*/       rndmthd = ex_rnd_mthd.
** /*J053*/    end.
** /*J053*/    else rndmthd = gl_rnd_mthd.
**J0ZZ***********************************************************************/

/*J1LV*/    /* CHECK IF ANY SALES ORDER IS BEING CREATED */
/*J1LV*/    l_new_so = no.
/*J1LV*/    {gprun.i ""sonewso.p"" "(input recid(so_mstr),
                                         output l_new_so)"}
/*J1LV*/    if l_new_so then next.

/*J0ZZ*/    if (oldcurr <> so_curr) or (oldcurr = "") then do:
/*J1LV*/    /* REPLACING SECOND PARAMETER "3" WITH "4" */
/*J0ZZ*/       {gpcurmth.i
            "so_curr"
                    "4"
            "leave"
            "pause" }

/*J053*/       {socurfmt.i}  /* SET CURRENCY FORMATS */
/*J053*/       oldcurr = so_curr.
/*J053*/    end. /* IF OLDCURR <> SO_CURR */


/*J04F*/ /*******************************************************************
/*G599*  if first-of(so_cust) then first_cust = yes. */                     *
/*H396*  if first-of(so_bill) then first_cust = yes. */                     *
/*H396*/ if first-of(so_bill) then do:                                      *
/*H396*/    first_cust = yes.                                               *
/*H396*/    first_time = yes.                                               *
/*H396*/ end.                                                               *
 *J04F*/

/*J04F*/    if last_so_bill <> so_bill then do:
/*J04F*/       first_cust = yes.
/*J04F*/       first_time = yes.
/*J04F*/       last_so_bill = so_bill.
/*J04F*/    end.

/*FL86******
/*H188* *if due_date > low_date and due_date1 < hi_date then do: */
    * find first sod_det where sod_due_date >= due_date and
/*G599*/* sod_confirm and
    * sod_due_date <= due_date1 and sod_nbr = so_nbr no-lock no-error.
    * if not available sod_det then next.
/*H188* *end. */
 *FL86******/
/*FL86*/ find first sod_det where sod_nbr = so_nbr and sod_confirm and
/*FL86*/ ((sod_due_date = ? and due_date = low_date) or
/*FL86*/  (sod_due_date >= due_date and sod_due_date <= due_date1 and
/*FL86*/   sod_due_date <> ?)) no-lock no-error.
/*FL86*/ if not available sod_det then next.

/*G599*  find cm_mstr where cm_addr = so_cust no-lock no-error. */
/*G599*  find ad_mstr where ad_addr = so_cust no-lock no-error. */
/*G599*/ find cm_mstr where cm_addr = so_bill no-lock no-error.
/*G599*/ find ad_mstr where ad_addr = so_bill no-lock no-error.
       if available ad_mstr then cust_name = ad_name.

       if available cm_mstr then do:
/*FO89*   if first_cust   = yes  then do: */
/*H396*   if first-of(so_bill)  then do: */
/*H396*/  if first_time   then do:
/*H396*/     first_time = no.
         total_exp    = cm_balance.
         so_open_amt  = 0.
         open_amt     = 0.
         cr_remain    = cm_cr_limit - cm_balance.
         past_due_tot = 0.
         /* Calculate past_due using multiple credit terms */
         if past_due = yes then do:
        for each ar_mstr where  ar_bill = cm_addr and ar_open = yes
        no-lock use-index ar_bill_open:
           open_amt = 0.
/*D507********     base_amt = ar_amt - ar_applied.
     *        if base_curr <> ar_curr then base_amt = base_amt / ar_ex_rate.
*************/
           curr_amt = ar_amt - ar_applied.
           base_amt = ar_amt.
           base_applied = ar_applied.

/*J053*/           /* BASE_AMT IS IN DOCUMENT CURRENCY AND ROUNDED PER*/
/*J053*/           /* THAT CURR IF DOC CURR AND BASE CURR ARE NOT THE */
/*J053*/           /* SAME THEN CALCULATE BASE_AMOUNT USING THE BASE  */
/*J053*/           /* EXCHANGE RATE AND ROUND PER BASE CURR  */
           if ar_curr <> base_curr then do:
/*J053* /*D507*/      base_amt = round(base_amt / ar_ex_rate,gl_ex_round). */
/*J053*/              base_amt = base_amt / ar_ex_rate.
/*J053*/              {gprun.i ""gpcurrnd.p"" "(input-output base_amt,
                        input gl_rnd_mthd)"}
/*D507*/              base_applied =
/*J053*/                         base_applied / ar_ex_rate.
/*J053*/              {gprun.i ""gpcurrnd.p"" "(input-output base_applied,
                            input gl_rnd_mthd)"}
/*J053* /*D507*/      round(base_applied / ar_ex_rate,gl_ex_round).   */

/*G484*/              {gpgtex8.i &ent_curr = base_curr
                 &curr = ar_curr
                 &date = age_date
                 &exch_from = exd_rate
                 &exch_to = exdrate}
/*G484**              find last exd_det where exd_curr = ar_curr and
**G484**              exd_eff_date <= age_date and exd_end_date >= age_date
**G484**              no-lock no-error.
**G484*/
/*G484*/              if available exd_det then curr_amt =
               curr_amt / exdrate.

             /*IF NO EXCHANGE RATE FOR TODAY, USE THE INVOICE RATE*/
              else
             curr_amt = curr_amt / ar_ex_rate.

/*J053* /*D507*/      curr_amt = round(curr_amt,gl_ex_round). */
/*J053*/              {gprun.i ""gpcurrnd.p"" "(input-output curr_amt,
                        input gl_rnd_mthd)"}
           end. /* IF AR_CURR <> BASE_CURR */

           due-date = ar_due_date.
           find ct_mstr where ct_code = ar_cr_terms no-lock no-error.
           if available ct_mstr and ct_dating = yes then do:
              applied-amt = base_applied.
              for each ctd_det where ctd_code = ar_cr_terms no-lock
              use-index ctd_cdseq:
             closed = no.
             find ct_mstr where ct_code = ctd_date_cd
             no-lock no-error.
             if available ct_mstr then do:
/*H070*****
/*G045*/ *                  if (ct_from_inv = 1) then
     *                     due-date  = ar_date + ct_due_days.
     *                  else       /*from end of month*/
     *                     due-date = date((month(ar_date) + 1) mod 12
     *                     + if month(ar_date) = 11 then 12 else
     *                          0, 1, year(ar_date) +
     *                          if month(ar_date) >= 12 then
     *                             1 else 0) + integer(ct_due_days)
     *                            - if ct_due_days <> 0 then 1 else 0.
     *
     *                  if ct_due_date <> ? then due-date = ct_due_date.
 *H070*****/
/*H070*/                    /* GET DUE DATE FOR MULTI DUE DATE TERMS */
/*H070*/                    due-date = ?.

/*H583*/                    {gprun.i ""adctrms.p""
                     "(input  ar_date,
                       input  ctd_date_cd,
                       output disc-date,
                       output due-date)"}

/*H583** USE adctrms.p TO REDUCE FILE SIZE **
 ** /*H070*/                    {adctrms.i &date = ar_date
 **                              &cr_terms = ctd_date_cd
 **                             &disc_date = disc-date &due_date = due-date} **/

                /*CALCULATE AMT-DUE LESS APPLIED FOR THIS SEGMENT*/
                amt-due = base_amt * (ctd_pct_due / 100).
                if applied-amt >= amt-due then do:
                   applied-amt = applied-amt - amt-due.
                   this-applied = amt-due * (-1).
                   closed = yes.
                end.
                else do:
                   amt-due = amt-due - applied-amt.
                   this-applied = applied-amt * (-1).
                   applied-amt = 0.
                end.
                if (today - past_due_days) > due-date and not closed
                then
                   open_amt = open_amt + base_amt
                      * (ctd_pct_due / 100).
             end. /*if avail ct_mstr*/
             if ctd_pct_due = 100 then leave.
              end. /*for each ctd_det*/
           end. /*if available ct_mstr &  ct_dating = yes*/
           else if (today - past_due_days) >  due-date then
              open_amt = base_amt - base_applied.
              past_due_tot = past_due_tot + open_amt.
        end. /* for ar_mstr */
         end. /* if past_due = yes */
      end. /* if first_cust = yes */
/*H188****************
    * for each sod_det where sod_due_date >= due_date and
/*G599*/* sod_confirm and
    * sod_due_date <= due_date1 and sod_nbr = so_nbr
    * no-lock :
    *    line_amt = line_amt + ((sod_qty_ord - sod_qty_ship)
    *                           * sod_price).
    * end.
    * so_open_amt = line_amt + so_trl1_amt + so_trl2_amt + so_trl3_amt
    *             - (line_amt * (so_disc_pct / 100)).
    * line_amt = 0.
    * if so_curr <> base_curr then
/*D507*/*   so_open_amt = round(so_open_amt / so_ex_rate,gl_ex_round).
 *H188****************/
/*H188**** begin add block ***/

      /* DETERMINE ord_amt */
      maint = no.
      date_range  = due_date.
      date_range1 = due_date1.
/*FL86*   if date_range = ? then date_range = low_date.  */
/*FL86*   if date_range1 = ? then date_range1 = hi_date. */
      so_recno = recid(so_mstr).
      if {txnew.i} then do:
         {gprun.i ""sosotrl2.p""}
      end.
      else do:
         {gprun.i ""sosotrl.p""}
      end.

/*J053*/  /* ORD_AMT IS IN DOCUMENT CURRENCY AND IS ROUNDED PER THAT CURR */
/*J053*/  /* IF DOC CURR AND BASE CURR ARE NOT THE SAME THEN CALCULATE ORD*/
/*J053*/  /* AMOUNT USING THE BASE EXCHANGE RATE AND ROUND PER BASE CURR  */

/*LB01*..   check all the orders assosiated with the customer...          */
/*LB01      not like before only calculates the selected sales orders.      */
/*LB01*/so_open_amt = 0.
/*LB01*/for each somstr where somstr.so_cust = so_mstr.so_cust and so_fsm_type=" " no-lock use-index so_cust,
/*LB01*/  each sod_det where somstr.so_nbr = sod_nbr no-lock:
			so_open_amt = so_open_amt +
/*LB01*/                  (sod_qty_ord - sod_qty_ship + sod_qty_inv)
/*LB01*/                   * sod_price.
/*LB01*/end. 


/*LB01*/  if so_curr <> base_curr then
/*J053*/  do:
/*J053*      so_open_amt = round(ord_amt / so_ex_rate,gl_ex_round). */
/*LB01*J053*/so_open_amt = so_open_amt / so_ex_rate.
/*J053*/     {gprun.i ""gpcurrnd.p"" "(input-output so_open_amt,
                       input gl_rnd_mthd)"}
/*J053*/  end.

/*LB01*************************************************************************
*      if so_curr = base_curr then
*         so_open_amt = ord_amt.
*      else
*
/*J053*/  do:
/*J053*      so_open_amt = round(ord_amt / so_ex_rate,gl_ex_round). */
/*J053*/     so_open_amt = ord_amt / so_ex_rate.
/*J053*/     {gprun.i ""gpcurrnd.p"" "(input-output so_open_amt,
                       input gl_rnd_mthd)"}
/*J053*/  end.
*LB01*************************************************************************/

/*H188**** end add block ***/

      cr_remain = cr_remain - so_open_amt.
      if inc_so_bal then total_exp = total_exp + so_open_amt.

       end. /* available cm_mstr */

       if
       (past_due_tot <= past_due_allow or past_due = no)
       and (total_exp <= cm_cr_limit or ovr_cr_lim = no)
       and  (cm_cr_hold = no or off_cr_hold = no)
       and (so_stat <> "" or not first_cust) then do:

      if (first_cust) then do:
         first_cust = no.
         if past_due = yes then
/*G599*      display so_cust cust_name cm_cr_hold cm_cr_limit cm_balance */
/*G599*/     display so_bill cust_name cm_cr_hold cm_cr_limit cm_balance
         past_due_tot with frame b down width 132 STREAM-IO /*GUI*/ .
         else
/*G599*      display so_cust cust_name cm_cr_hold cm_cr_limit cm_balance */
/*G599*/     display so_bill cust_name cm_cr_hold cm_cr_limit cm_balance
         with frame c down width 132 STREAM-IO /*GUI*/ .
      end.
/*G1W8*          if set_hold = yes then so_stat = "". */
/*G1W8*/  if set_hold = yes then do for somstr:
/*G1W8*/    find somstr exclusive-lock where recid(somstr) = so_recno no-error.
/*G1W8*/    if available somstr then somstr.so_stat = "".
/*G1W8*/  end.

/*G0VZ*/  /* SET STAT FOR RMA'S, TOO */
/*G19Z* *G0VZ*  for each rma_mstr where rma_nbr = so_nbr exclusive-lock:  */
/*G19Z*/  find rma_mstr where rma_nbr = so_nbr and rma_prefix = "C"
/*G19Z*/     exclusive-lock no-error no-wait.
/*G19Z*/  if available rma_mstr then do:
/*G0VZ*/        rma_stat = so_stat.
/*G0VZ*/  end.

/*G599*   display so_ship so_nbr so_stat so_po so_due_date */
/*G599*/  display so_cust so_ship so_nbr so_stat so_po so_due_date
          so_conf_date so_open_amt so_cr_terms cr_remain
          with frame d down width 132 STREAM-IO /*GUI*/ .

      end.
   end. /* for each so_mstr */

   /*REPORT TRAILER */
   {mfrtrail.i}
end. /* repeat */
