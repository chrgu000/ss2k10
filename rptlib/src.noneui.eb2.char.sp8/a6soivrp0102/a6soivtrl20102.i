/* soivtrl2.i - PENDING INVOICE TRAILER                                       */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.57.1.23 $                                             */
/* REVISION: 7.4      CREATED:        10/02/95   BY: jym *G0XY*               */
/* REVISION: 7.4      MODIFIED:       11/29/95   BY: rxm *H0GY*               */
/* REVISION: 8.5      MODIFIED:       07/13/95   BY: taf *J053*               */
/* REVISION: 8.5      MODIFIED:       01/08/96   BY: jzw *H0K0*               */
/* REVISION: 8.5      LAST MODIFIED:  09/10/96   BY: *H0MP* Aruna Patil       */
/* REVISION: 8.6      LAST MODIFIED:  11/25/96   BY: *K01X* Jeff Wootton      */
/* REVISION: 8.6      LAST MODIFIED:  10/09/97   BY: *K0JV* Surendra Kumar    */
/* REVISION: 8.6      LAST MODIFIED:  01/15/98   BY: *J2B2* Manish Kulkarni   */
/* REVISION: 8.6E     LAST MODIFIED:  02/23/98   BY: *L007* Annasheb Rahane   */
/* REVISION: 8.6E     LAST MODIFIED:  05/05/98   BY: *L00V* Ed van de Gevel   */
/* REVISION: 8.6E     LAST MODIFIED:  05/09/98   BY: *L00Y* Jeff Wootton      */
/* REVISION: 8.6E     LAST MODIFIED:  06/23/98   BY: *L01G* Robin McCarthy    */
/* REVISION: 8.6E     LAST MODIFIED:  07/02/98   BY: *L024* Sami Kureishy     */
/* REVISION: 8.6E     LAST MODIFIED:  08/10/98   BY: *J2VV* Rajesh Talele     */
/* REVISION: 8.6E     LAST MODIFIED:  08/19/98   BY: *J2WV* Surekha Joshi     */
/* REVISION: 9.0      LAST MODIFIED:  09/29/98   BY: *J2CZ* Reetu Kapoor      */
/* REVISION: 9.0      LAST MODIFIED:  11/17/98   BY: *H1LN* Poonam Bahl       */
/* REVISION: 9.0      LAST MODIFIED:  01/22/99   BY: *J38T* Poonam Bahl       */
/* REVISION: 9.0      LAST MODIFIED:  03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.0      LAST MODIFIED:  05/07/99   BY: *J3DQ* Niranjan Ranka    */
/* REVISION: 9.1      LAST MODIFIED:  09/08/99   BY: *N02P* Robert Jensen     */
/* REVISION: 9.1      LAST MODIFIED:  10/01/99   BY: *N014* Murali Ayyagari   */
/* REVISION: 9.1      LAST MODIFIED:  02/24/00   BY: *M0K0* Ranjit Jain       */
/* REVISION: 9.1      LAST MODIFIED:  03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED:  07/05/00   BY: *N0F4* Mudit Mehta       */
/* REVISION: 9.1      LAST MODIFIED:  09/05/00   BY: *N0RF* Mark Brown        */
/* REVISION: 9.1      LAST MODIFIED:  09/06/00   BY: *N0D0* Santosh Rao       */
/* REVISION: 9.1      LAST MODIFIED:  10/16/00   BY: *N0W8* Mudit Mehta       */
/* REVISION: 9.1      LAST MODIFIED:  03/05/01   BY: *M12V* Rajaneesh Sarangi */
/* Revision: 1.42         BY: Ellen Borden        DATE: 07/09/01  ECO: *P007* */
/* Revision: 1.43         BY: Kaustubh Kulkarni   DATE: 07/26/01  ECO: *M1DS* */
/* Revision: 1.44         BY: Mark Christian      DATE: 02/07/02  ECO: *N18X* */
/* Revision: 1.46         BY: Ellen Borden        DATE: 03/15/02  ECO: *P00G* */
/* Revision: 1.47         BY: Jean Miller         DATE: 04/09/02  ECO: *P058* */
/* Revision: 1.48         BY: Manisha Sawant      DATE: 07/11/02  ECO: *N1NW* */
/* Revision: 1.49         BY: Gnanasekar          DATE: 11/12/02  ECO: *N1Y0* */
/* Revision: 1.50         BY: Mamata Samant       DATE: 01/23/03  ECO: *N23T* */
/* Revision: 1.51         BY: Amit Chaturvedi     DATE: 01/26/03  ECO: *N20Y* */
/* Revision: 1.57         BY: Vandna Rohira       DATE: 04/28/03  ECO: *N1YL* */
/* Revision: 1.57.1.1     BY: Manish Dani         DATE: 06/24/03  ECO: *P0VZ* */
/* Revision: 1.57.1.2     BY: Vivek Gogte         DATE: 07/14/03  ECO: *N2GZ* */
/* Revision: 1.57.1.3     BY: Ashish Maheshwari   DATE: 10/10/03  ECO: *P15L* */
/* Revision: 1.57.1.4     BY: Sunil Fegade        DATE: 12/11/03  ECO: *P1F7* */
/* Revision: 1.57.1.5     BY: Vinay Soman         DATE: 12/23/03  ECO: *N2NZ* */
/* Revision: 1.57.1.6     BY: Rajaneesh Sarangi   DATE: 01/05/04  ECO: *P1GK* */
/* Revision: 1.57.1.7     BY: Vinay Soman         DATE: 01/15/04  ECO: *P1JP* */
/* Revision: 1.57.1.11    BY: Swati Sharma        DATE: 02/27/04  ECO: *P1R4* */
/* Revision: 1.57.1.12    BY: Robin McCarthy      DATE: 03/10/04  ECO: *P15V* */
/* Revision: 1.57.1.13    BY: Prashant Parab      DATE: 04/05/04  ECO: *P1WT* */
/* Revision: 1.57.1.15    BY: Somesh Jeswani      DATE: 06/16/04  ECO: *P25V* */
/* Revision: 1.57.1.19    BY: Sachin Deshmukh     DATE: 07/07/04  ECO: *P268* */
/* Revision: 1.57.1.22    BY: Niranjan Ranka      DATE: 10/04/04  ECO: *P2MQ* */
/* $Revision: 1.57.1.23 $   BY: Dan Herman          DATE: 10/25/04  ECO: *P2QS* */
/* $Revision: 1.57.1.23 $   BY: Bill Jiang          DATE: 06/02/06  ECO: *SS - 20060602.1* */

/****************************************************************************~**/
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
/* SS - 20060602.1 - E */

/*!
 * PARAMETERS:
 *
 * I/O    NAME                 LIKE         DESCRIPTION
 * ------ --------------- ------------ ---------------------------------------
 * input  ref             tx2d_ref     so_nbr until inv print; then so_inv_nbr
 * input  nbr             tx2d_nbr     blank until inv print; then so_nbr
 * input  col-80          mfc_logical  true to print report with 80 columns
 *                                     otherwise report uses 132 columns
 * input  tot_tr_type     tx2d_tr_type 13 for Pending SO; 16 for posting
 * input  tot_cont_charge decimal      Total container charge amount
 * input  tot_line_charge decimal      Total line charge amount
 * input  p_consolidate   mfc_logical  false to initialize taxable
                                       and non taxable amounts
 *
 */

/*! N1YL HAS CHANGED THE WAY TAXABLE/NON-TAXABLE AMOUNT IS CALCULATED.
 *  THE ORDER DISCOUNT IS APPLIED FOR EACH LINE TOTAL AND THEN IT IS
 *  SUMMED UP TO CALCULATE THE TAXABLE/NON-TAXABLE AMOUNT BASED ON THE
 *  TAXABLE STATUS OF EACH LINE. PREVIOUSLY, TAXABLE/NON-TAXABLE AMOUNT
 *  WAS OBTAINED FROM THE GTM TABLES. THIS CAUSED PROBLEMS WHEN
 *  MULTIPLE TAXABLE BASES ARE USED TO CALCULATE TAX.
 *
 *  TAXABLE/NON-TAXABLE AMOUNT WILL NOW BE DISPLAYED IN THE TRAILER
 *  FRAME BASED ON THE VALUE OF THE FLAG "DISPLAY TAXABLE/NON-TAXABLE
 *  AMOUNT ON TRAILER" IN THE GLOBAL TAX MANAGEMENT CTRL FILE
 */

/*V8:ConvertMode=ReportAndMaintenance                                         */

{mfdeclre.i}
{cxcustom.i "SOIVTRL2.I"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{sotxidef.i}

{sotrhstb.i}   /* DEFINITION FOR TEMP-TABLE t_tr_hist1 */

define input parameter ref             like tx2d_ref     no-undo.
define input parameter nbr             like tx2d_nbr     no-undo.
define input parameter col-80          like mfc_logical  no-undo.
define input parameter tax_tr_type     like tx2d_tr_type no-undo.
define input parameter tot_cont_charge as decimal no-undo.
define input parameter tot_line_charge as decimal no-undo.
define input parameter p_consolidate   like mfc_logical  no-undo.

define new shared variable undo_txdetrp like mfc_logical.
/* l_txchg IS SET TO TRUE IN TXEDIT.P WHEN TAXES ARE BEING EDITED  */
/* AND NOT JUST VIEWED IN DR/CR MEMO MAINTENANCE                   */
define new shared variable l_txchg      like mfc_logical initial no.
define shared variable rndmthd          like rnd_rnd_mthd.
define shared variable so_recno         as recid.
define shared variable maint            as logical.
define shared variable consolidate      like mfc_logical.
define shared variable taxable_amt      as decimal
   format "->>>>,>>>,>>9.99"
   label "Taxable".
define shared variable nontaxable_amt   like taxable_amt label "Non-Taxable".
define shared variable line_total       as decimal
   format "-zzzz,zzz,zz9.99"
   label "Line Total".
define shared variable disc_amt         like line_total label "Discount"
   format "(zzzz,zzz,zz9.99)".
define shared variable tax_amt          like line_total label "Total Tax".
define shared variable ord_amt          like line_total label "Total".
define shared variable invcrdt          as character format "x(15)".
define shared variable user_desc        like trl_desc extent 3.
define shared variable tax_date         like so_tax_date.
define shared variable new_order        like mfc_logical.
define shared variable tax_edit         like mfc_logical.
define shared variable tax_edit_lbl     like mfc_char
   format "x(28)".
define shared variable undo_trl2        like mfc_logical.
define shared variable tot_line_comm    as decimal extent 4 format
   "->>>>,>>>,>>9.99<<<<".
define shared  variable container_charge_total as decimal
   format "->>>>>>>>9.99"
   label "Containers" no-undo.
define  shared variable line_charge_total as decimal
   format "->>>>>>>>9.99"
   label "Line Charges" no-undo.

define shared variable l_nontaxable_lbl as character format "x(12)" no-undo.
define shared variable l_taxable_lbl    as character format "x(12)" no-undo.

define shared frame sotot.
define shared frame d.

define variable ext_price   like sod_price no-undo.
define variable ext_actual  like sod_price no-undo.
define variable tax_lines   like tx2d_line initial 0       no-undo.
define variable page_break  as integer initial 0           no-undo.
define variable recalc      like mfc_logical initial true  no-undo.
define variable tax-edited  like mfc_logical initial false no-undo.
define variable ext_margin  as decimal format "->>>>,>>>,>>9.99" no-undo.
define variable disc_pct    like so_disc_pct no-undo.
define variable tmp_amt     as decimal no-undo.
define variable retval      as integer no-undo.
{&SOIVTRL2-I-TAG1}
define variable l_retrobill   like mfc_logical     no-undo.
define variable l_tax_in      like tax_amt         no-undo.
define variable lgData        as   logical         no-undo.
define variable l_yn          like mfc_logical     no-undo.
define variable l_tax_amt1    like tax_amt         no-undo.
define variable l_tax_amt2    like tax_amt         no-undo.
define variable l_nontax_amt  like tx2d_nontax_amt no-undo.

define variable auth_price    like sod_price format "->>>>,>>>,>>9.99"
                                                   no-undo.
define variable auth_found    like mfc_logical     no-undo.

define new shared temp-table t_absr_det            no-undo
   field t_absr_reference like absr_reference
   field t_absr_qty       as decimal format "->>>>,>>>,>>9.99"
   field t_absr_ext       as decimal format "->>>>,>>>,>>9.99".

if execname = "rcrbrp01.p" then
   l_retrobill = yes.

{txcalvar.i}

{etdcrvar.i}  /* TOOLKIT DUAL CURRENCY PRICING VARIABLES */
{etvar.i}     /* TOOLKIT GENERAL VARIABLES */
{etrpvar.i}   /* TOOLKIT REPORTING CURRENCY VARIABLES */

/* Find out if this session is being run through Q/LinQ */
/* If so, suppress the pop up windows */
{gprun.i ""mgisact.p"" "(input 'qqimprc', output lgData)"} /*RFJ*/

/* VARIABLE DEFINITIONS FOR gpfile.i */
{gpfilev.i}

/*DETERMINE IF CONTAINER AND LINE CHARGES ARE ENABLED*/
{cclc.i}

/* CONSIGNMENT VARIABLES */
{socnvars.i}

/* CHECK TO SEE IF CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
         "(input ENABLE_CUSTOMER_CONSIGNMENT,
           input 10,
           input ADG,
           input CUST_CONSIGN_CTRL_TABLE,
           output using_cust_consignment)"}

for first soc_ctrl fields (soc_margin) no-lock:
end.

for first txc_ctrl
   fields (txc__qad03)
   no-lock:
end. /* FOR FIRST txc_ctrl */

empty temp-table t_store_ext_actual no-error.

do for so_mstr:     /*scope this trans */

   if maint then
      find so_mstr where recid(so_mstr) = so_recno
      exclusive-lock no-error.
   else
      for first so_mstr
         fields (so_ar_acct so_ar_cc so_cr_card so_cr_init so_curr so_ar_sub
                 so_cust so_disc_pct so_due_date so_ex_rate
                 so_ex_rate2 so_fob so_invoiced so_inv_nbr so_nbr
                 so_ord_date so_prepaid so_print_pl so_print_so
                 so_rev so_ship so_ship_date so_stat so_tax_date
                 so_tax_env so_to_inv so_trl1_amt so_trl1_cd
                 so_trl2_amt so_trl2_cd so_trl3_amt so_trl3_cd
                 so__qadl01 so__qadc03 so_sched)
         where recid(so_mstr) = so_recno
      no-lock:
      end.

   /* CREATE TEMP-TABLE TO STORE tr_hist RECORDS AND RETRIEVE THE SAME IN  */
   /* soauthbl.p TO IMPROVE THE PERFORMANCE WHILE PRINTING AUTHORIZATION   */
   /* NUMBERS FOR SCHEDULE ORDERS.                                         */
   if available so_mstr
      and so_sched = yes
      and so__qadc03 = "yes"
      and not can-find(first t_tr_hist1
                          where t_tr_nbr = so_nbr)
   then do:

      /* REPLACED SECOND PARAMETER FROM so_inv_nbr WITH BLANK */
      /* INORDER TO MATCH THE INVOICE TOTAL WITH DR/CR MEMO TOTAL */

      {gprun.i ""sotrhstb.p""
         "(input        so_nbr,
           input        '',
           input-output table t_tr_hist1)"}

   end. /* IF AVAILABLE so_mstr */

   {&SOIVTRL2-I-TAG2}

   /**** FORMS ****/
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

   {socurvar.i}
   {txcurvar.i}
      /* SS - 20060602.1 - B */
      /*
   {sototfrm.i}
      */
      {a6sototfrm0102.i}
      /* SS - 20060602.1 - E */

   taxloop:
   do on endkey undo, leave:
      /* WHERE THE INVOICES HAVE NOT BEEN CONSOLIDATED */
      if not maint and not consolidate then do:
         undo_txdetrp = true.

         /* ADDED SIXTH INPUT PARAMETER '' AND SEVENTH INPUT     */
         /* PARAMETER yes TO ACCOMMODATE THE LOGIC INTRODUCED IN */
         /* txdetrpa.i FOR DISPLAYING THE APPROPRIATE CURRENCY   */
         /* AMOUNT.                                              */

         {gprun.i  ""txdetrp.p""
                   "(input tax_tr_type,
                     input ref,
                     input nbr,
                     input col-80,
                     input page_break,
                     input '',
                     input yes)"}
         if undo_txdetrp = true then undo, leave.
      end. /* if not maint */

      if using_container_charges or using_line_charges then do:
         assign
            container_charge_total = tot_cont_charge
            line_charge_total = tot_line_charge
            line_total = 0
            ord_amt = 0.
      end. /*IF USING_CONTAINER*/

      /*** GET TOTALS FOR LINES ***/
      line_total = 0.
      if not p_consolidate
      then
         assign
            taxable_amt    = 0
            nontaxable_amt = 0.

         assign
            tot_line_comm[1] = 0
            tot_line_comm[2] = 0
            tot_line_comm[3] = 0
            tot_line_comm[4] = 0
            l_ord_contains_tax_in_lines = can-find (first sod_det
                                                    where sod_nbr = so_nbr
                                                    and   sod_taxable
                                                    and   sod_tax_in).

      if so_tax_date <> ? then
         tax_date = so_tax_date.
      else
         if so_ship_date <> ? then
         tax_date = so_ship_date.
      else
         tax_date = so_due_date.

      if using_container_charges then
         line_total = line_total + tot_cont_charge.

      if using_line_charges then
         line_total = line_total + tot_line_charge.

      for each sod_det where sod_nbr = so_nbr no-lock:

         /* IF THE ORDER LINE IS A CONSIGNMENT ORDER LINE  */
         /* THEN WE DON'T WANT THE DOLLAR AMOUNT INCLUDED  */
         /* ON THE INVOICE WHEN THE LINE HAS BEEN SHIPPED, */
         /* BUT WHEN THE SHIPMENT HAS BEEN USED.           */
         if using_cust_consignment
            and sod_consignment
         then do:
            if so_tax_date = ?
            then do:
               find last cncu_mstr
                  where cncu_so_nbr   = so_nbr
                  and   cncu_sod_line = sod_line
               no-lock.
               if available cncu_mstr
               then
               tax_date = cncu_cust_usage_date.
            end. /* IF so_tax_date */
            {gprunmo.i &program = "socnsod1.p" &module = "ACN"
                       &param   = """(input so_nbr,
                                      input sod_line,
                                      output consign_flag,
                                      output consign_loc,
                                      output intrans_loc,
                                      output max_aging_days,
                                      output auto_replenish)"""}

            /* CHECK FOR NON-INVOICED USAGE RECORDS. IF */
            /* THEY EXIST, THEN INVOICE. OTHERWISE SKIP */
            /* UNLESS THE SHIPMENT IS RETURNED FOR CREDIT. */
            {gprunmo.i &program = "socnu01.p"   &module = "ACN"
                       &param   = """(input so_nbr,
                                      input sod_line)"}

               if return-value <> ""
                  and sod_qty_inv >= 0
               then
                  next.
         end. /* IF using_cust_consignment */

         run ip_calc_amt
            (input-output ext_actual,
             input-output line_total,
             input-output taxable_amt,
             input-output nontaxable_amt,
             buffer       so_mstr,
             buffer       sod_det).

         ext_margin = ext_actual - round(sod_std_cost * (sod_qty_inv),2).

         if soc_margin = yes then     /* Commissions based on margin */
            assign
               tot_line_comm[1] = tot_line_comm[1]
                                + ext_margin * sod_comm_pct[1] / 100
               tot_line_comm[2] = tot_line_comm[2]
                                + ext_margin * sod_comm_pct[2] / 100
               tot_line_comm[3] = tot_line_comm[3]
                                + ext_margin * sod_comm_pct[3] / 100
               tot_line_comm[4] = tot_line_comm[4]
                                + ext_margin * sod_comm_pct[4] / 100.
         else        /* Commissions based on sales  */
            assign
               tot_line_comm[1] = tot_line_comm[1]
                                + ext_actual * sod_comm_pct[1] / 100
               tot_line_comm[2] = tot_line_comm[2]
                                + ext_actual * sod_comm_pct[2] / 100
               tot_line_comm[3] = tot_line_comm[3]
                                + ext_actual * sod_comm_pct[3] / 100
               tot_line_comm[4] = tot_line_comm[4]
                                + ext_actual * sod_comm_pct[4] / 100.

      end.   /* FOR EACH SOD_DET */

      {&SOIVTRL2-I-TAG3}

      /* SKIPPING SALES VOLUME DISCOUNT CALCULATION    */
      /* FOR RETROBILLED ITEMS                         */
      if maint and not so__qadl01 and not l_retrobill then do:

         for first cm_mstr
            fields (cm_addr cm_disc_pct)
            where cm_addr = so_cust
         no-lock:
         end.

         if so_cust <> so_ship and
            can-find (cm_mstr where cm_mstr.cm_addr = so_ship)
         then
            for first cm_mstr
               fields (cm_addr cm_disc_pct)
               where cm_mstr.cm_addr = so_ship
            no-lock:
            end.

         {gprun.i ""sosd.p""
                  "(input so_ord_date,
                    input so_ex_rate,
                    input so_ex_rate2,
                    input so_cust,
                    input so_curr,
                    input line_total,
                    output disc_pct)"}

         if disc_pct > cm_disc_pct and disc_pct <> 0 then
            so_disc_pct = disc_pct.
         else
            so_disc_pct = cm_disc_pct.

      end.

      /* USE THE EXISTING LOGIC TO CALCULATE DISCOUNT ONLY WHEN */
      /* SALES ORDER DOES NOT HAVE TAX INCLUDED LINES           */
      if l_ord_contains_tax_in_lines = no
      then
         disc_amt = (- line_total * (so_disc_pct / 100)).

      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output disc_amt,
           input rndmthd,
           output mc-error-number)"}
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.

      nontaxable_amt = nontaxable_amt - tmp_amt.

      /* ADD TRAILER AMOUNTS */
      {txtrltrl.i so_trl1_cd so_trl1_amt user_desc[1]}
      {txtrltrl.i so_trl2_cd so_trl2_amt user_desc[2]}
      {txtrltrl.i so_trl3_cd so_trl3_amt user_desc[3]}

      /* UNTIL AN INVOICE IS PRINTED REF IS so_nbr AND */
      /* NBR IS BLANK.  ONCE AN INVOICE IS PRINTED REF */
      /* IS so_inv_nbr AND NBR IS so_nbr               */
      /* CALCULATE TAX AMOUNTS ONLY IF MAINT                */
      if maint then do:

         /* CALULATE THE TAX AMOUNT BEFORE TXCALC.P CALCULATES THE NEW */
         /* TAXES SO AS TO COMPARE IF THE TAX AMOUNT HAS BEEN CHANGED  */

         /* CALCULATE TOTALS */
         {gprun.i ""txtotal.p""
            "(input  tax_tr_type,
              input  ref,
              input  nbr,
              input  tax_lines,   /* ALL LINES */
              output l_tax_amt1)"}

         /* OBTAINING TOTAL INCLUDED TAX FOR THE TRANSACTION */
         {gprun.i ""txtotal1.p"" "(input  tax_tr_type,
              input  ref,
              input  nbr,
              input  tax_lines,  /* ALL LINES */
              output l_tax_amt2)"}

         l_tax_amt1 = l_tax_amt1 + l_tax_amt2.

         /* SEE IF ANY TAX DETAIL EXISTS */
         for first tx2d_det
            fields (tx2d_cur_nontax_amt tx2d_edited     tx2d_line   tx2d_nbr
                    tx2d_nontax_amt     tx2d_ref        tx2d_taxc
                    tx2d_tax_env        tx2d_tax_usage  tx2d_tottax tx2d_trl
                    tx2d_tr_type)
            where tx2d_ref = so_nbr
            and   tx2d_nbr = nbr
            and   tx2d_tr_type = tax_tr_type
         no-lock:
         end.

         if available tx2d_det then do:

            /* CHECK PREVIOUS DETAIL FOR EDITED VALUES */
            for first tx2d_det
               fields (tx2d_cur_nontax_amt tx2d_edited     tx2d_line   tx2d_nbr
                       tx2d_nontax_amt     tx2d_ref        tx2d_taxc
                       tx2d_tax_env        tx2d_tax_usage  tx2d_tottax tx2d_trl
                       tx2d_tr_type)
               where tx2d_ref = so_nbr
               and   tx2d_nbr = nbr
               and   tx2d_tr_type = tax_tr_type
               and   tx2d_edited
            no-lock:
            end.

            if available(tx2d_det) then do:
               /* Previous tax values edited. Recalculate? */
               {pxmsg.i &MSGNUM=917 &ERRORLEVEL=2 &CONFIRM=recalc}
            end.

         end.

         else do:
            tax-edited = no.

            {gprun.i ""txedtchk.p""
               "(input  '11'               /* SOURCE TR  */,
                 input  so_nbr             /* SOURCE REF */,
                 input  nbr                /* SOURCE NBR */,
                 input  0                  /* ALL LINES  */,
                 output tax-edited)"}     /* RETURN VAL */

            if tax-edited then do:
               /* Copy edited tax values? */
               {pxmsg.i &MSGNUM=935 &ERRORLEVEL=2 &CONFIRM=tax-edited}
            end.
         end.

         if recalc then do:

            l_nontax_amt  = 0.

            for first tx2d_det
               fields (tx2d_cur_nontax_amt tx2d_edited     tx2d_line   tx2d_nbr
                       tx2d_nontax_amt     tx2d_ref        tx2d_taxc
                       tx2d_tax_env        tx2d_tax_usage  tx2d_tottax tx2d_trl
                       tx2d_tr_type)
               where tx2d_ref        = so_nbr
                 and tx2d_tr_type    = tax_tr_type
                 and tx2d_nontax_amt <> 0
            no-lock:
               l_nontax_amt = tx2d_nontax_amt.
            end. /* FOR FIRST tx2d_det */

            /* THE POST FLAG IS SET TO 'NO' BECAUSE WE ARE NOT CREATING */
            /* QUANTUM REGISTER RECORDS FROM THIS CALL TO TXCALC.P      */
            {gprun.i ""txcalc.p""
               "(input  tax_tr_type,
                 input  ref,
                 input  nbr,
                 input  tax_lines /* ALL LINES */,
                 input no,
                 output result-status)"}

            /* CREATES TAX RECORDS WITH TRANSACTION TYPE "11" */
            /* FOR THE QUANTITY BACKORDER DURING PENDING      */
            /* INVOICE MAINTENANCE                            */
            if not so_sched
            then do:
               {gprun.i ""txcalc.p""
                  "(input  "11",
                    input  ref,
                    input  nbr,
                    input  tax_lines,
                    input  no,
                    output result-status)"}
            end. /* IF NOT so_sched */

         end. /* IF recalc */

      end. /* IF maint */

      {gprun.i ""txabsrb.p""
         "(input so_nbr,
           input ' ',
           input '13',
           input-output line_total,
           input-output taxable_amt)"}

      /* COPY EDITED RECORDS IF SPECIFIED BY USER */
      if tax-edited then do:
         {gprun.i ""txedtcpy.p""
            "(input  '11'      /* SOURCE TR  */,
              input  so_nbr             /* SOURCE REF */,
              input  nbr                /* SOURCE NBR */,
              input  '13'               /* TARGET TR  */,
              input  so_nbr             /* TARGET REF */,
              input  nbr                /* TARGET NBR */,
              input  0)"}               /* ALL LINES  */
      end.

      /* TOTAL TAX TOTALS */
      {gprun.i ""txtotal.p""
         "(input  tax_tr_type,
           input  ref,
           input  nbr,
           input  tax_lines, /* ALL LINES */
           output tax_amt)"}

      /* OBTAINING TOTAL INCLUDED TAX FOR THE TRANSACTION */
      {gprun.i ""txtotal1.p""
         "(input  tax_tr_type,
           input  ref,
           input  nbr,
           input  tax_lines,      /* ALL LINES */
           output l_tax_in)"}

      /* WHEN TAX DETAIL RECORDS ARE NOT AVAILABLE AND SO IS */
      /* TAXABLE THEN USE THE PROCEDURE TO CALCULATE ORDER   */
      /* TOTAL AND DISCOUNT                                  */
      /*                                                     */
      /* WHEN TAX INCLUDED IS YES, ORDER DISCOUNT SHOULD BE */
      /* CALCULATED ON THE ORDER TOTAL AFTER REDUCING THE   */
      /* ORDER TOTAL BY THE INCLUDED TAX                    */
      if l_tax_in <> 0
         or (l_ord_contains_tax_in_lines
             and (not can-find (tx2d_det
                                where tx2d_ref = so_nbr
                                and   tx2d_nbr = so_inv_nbr)))
      then do:
         {gprunp.i "sopl" "p" "calDiscAmountAfterSubtractingTax"
            "(input table  t_store_ext_actual,
              input        rndmthd,
              input        so_disc_pct,
              input        so_nbr,
              input        so_inv_nbr,
              input        tax_tr_type,
              output       line_total,
              output       disc_amt)"}

         /* DISCOUNT AMOUNT IS ADJUSTED TO AVOID ROUNDING ERROR */
         /* IN CALCULATION OF ORDER AMOUNT                      */
         {gprunp.i "sopl" "p" "adjustDiscountAmount"
            "(input        taxable_amt - l_tax_in,
              input        nontaxable_amt,
              input        so_trl1_amt,
              input        so_trl2_amt,
              input        so_trl3_amt,
              input        line_total,
              input-output disc_amt)"}

      end. /* IF l_tax_in <> 0 ... */

      /* ADJUSTING LINE TOTALS AND TOTAL TAX BY INCLUDED TAX */
      assign
         taxable_amt = taxable_amt - l_tax_in
         tax_amt     = tax_amt + l_tax_in
         ord_amt     = line_total + disc_amt + so_trl1_amt
                     + so_trl2_amt + so_trl3_amt + tax_amt.

      if ord_amt < 0 then
         invcrdt = "**" + getTermLabel("C_R_E_D_I_T",11) + "**".
      else
         invcrdt = "".

      /* SS - 20060602.1 - B */
      /*
      if maint then do on endkey undo taxloop, leave:

         if txc__qad03 then
            display
               l_nontaxable_lbl
               nontaxable_amt
               l_taxable_lbl
               taxable_amt
               with frame sotot.
         else
            display
               "" @ l_nontaxable_lbl
               "" @ nontaxable_amt
               "" @ l_taxable_lbl
               "" @ taxable_amt
               with frame sotot.

         display
            so_curr
            line_total
            so_disc_pct
            disc_amt
            tax_date
            user_desc[1] so_trl1_cd so_trl1_amt
            user_desc[2] so_trl2_cd so_trl2_amt
            user_desc[3] so_trl3_cd so_trl3_amt
            tax_amt
            ord_amt
            container_charge_total
            line_charge_total
            tax_edit
            invcrdt
         with frame sotot.

         /* Don't re-set the tax data */
         if not lgData then do:

            trlloop:
            do on error undo trlloop, retry
               on endkey undo taxloop, leave:

               /* STORING THE DEFAULT VOLUME DISCOUNT PERCENTAGE */
               assign
                  disc_pct = so_disc_pct .

               {&SOIVTRL2-I-TAG4}
               set
                  so_disc_pct so_trl1_cd so_trl1_amt so_trl2_cd
                  so_trl2_amt so_trl3_cd so_trl3_amt tax_edit
               with frame sotot
               editing:
                  readkey.
                  if keyfunction(lastkey) = "end-error"
                     and (l_tax_amt1   <> tax_amt
                     or l_nontax_amt <> nontaxable_amt)
                  then do:
                     hide message no-pause.
                     /* TAX DETAIL RECORDS WILL NOT BE SAVED WHEN F4 */
                     /* OR ESC IS PRESSED.                           */
                     {pxmsg.i &MSGNUM=4773 &ERRORLEVEL=2}
                     /* CONTINUE WITHOUT SAVING?                     */
                     {pxmsg.i &MSGNUM=4774 &ERRORLEVEL=1 &CONFIRM=l_yn}
                     hide message no-pause.
                     if l_yn then
                        undo taxloop, leave.
                  end. /* IF KEYFUNCTION(LASTKEY) */
                  else
                     apply lastkey.
               end. /* EDITING */
               {&SOIVTRL2-I-TAG5}

               /* TO CHECK WHETHER DISCOUNT PERCENTAGE MANUALLY ENTERED? */
               if so_disc_pct <> disc_pct then
                  so__qadl01 = yes.

               {txedttrl.i &code  = "so_trl1_cd"
                   &amt   = "so_trl1_amt"
                   &desc  = "user_desc[1]"
                   &frame = "sotot"
                   &loop  = "trlloop"}

               /* VALIDATE TRAILER 1 AMOUNT */
               if (so_trl1_amt <> 0) then do:
                  {gprun.i ""gpcurval.p""
                     "(input so_trl1_amt,
                       input rndmthd,
                       output retval)"}
                  if retval <> 0 then do:
                     next-prompt so_trl1_amt with frame sotot.
                     undo trlloop, retry.
                  end.
               end.

               {txedttrl.i &code  = "so_trl2_cd"
                  &amt   = "so_trl2_amt"
                  &desc  = "user_desc[2]"
                  &frame = "sotot"
                  &loop  = "trlloop"}

               /* VALIDATE TRAILER 2 AMOUNT */
               if (so_trl2_amt <> 0) then do:
                  {gprun.i ""gpcurval.p""
                     "(input so_trl2_amt,
                       input rndmthd,
                       output retval)"}
                  if retval <> 0 then do:
                     next-prompt so_trl2_amt with frame sotot.
                     undo trlloop, retry.
                  end.
               end.

               {txedttrl.i &code  = "so_trl3_cd"
                  &amt   = "so_trl3_amt"
                  &desc  = "user_desc[3]"
                  &frame = "sotot"
                  &loop  = "trlloop"}

               /* VALIDATE TRAILER 3 AMOUNT */
               if (so_trl3_amt <> 0) then do:
                  {gprun.i ""gpcurval.p""
                     "(input so_trl3_amt,
                       input rndmthd,
                       output retval)"}
                  if retval <> 0 then do:
                     next-prompt so_trl3_amt with frame sotot.
                     undo trlloop, retry.
                  end.
               end.

            end. /* TRLLOOP */
         end. /* if not lgData */

         /*** GET TOTALS FOR LINES ***/
         assign
            line_total = 0
            taxable_amt = 0
            nontaxable_amt = 0
            container_charge_total = 0
            line_charge_total = 0.

         if using_container_charges or using_line_charges then do:
            assign
            container_charge_total = tot_cont_charge
            line_charge_total = tot_line_charge
            ord_amt = 0.
         end. /*IF USING_CONTAINER*/

         if using_container_charges then
            line_total = line_total + tot_cont_charge.

         if using_line_charges then
            line_total = line_total + tot_line_charge.

         for each sod_det where sod_nbr = so_nbr:

            /* IF THE ORDER LINE IS A CONSIGNMENT ORDER LINE  */
            /* THEN WE DON'T WANT THE DOLLAR AMOUNT INCLUDED  */
            /* ON THE INVOICE WHEN THE LINE HAS BEEN SHIPPED, */
            /* BUT WHEN THE SHIPMENT HAS BEEN USED.           */
            if using_cust_consignment
               and sod_consignment
            then do:

               {gprunmo.i &program = "socnsod1.p" &module = "ACN"
                          &param   = """(input so_nbr,
                                         input sod_line,
                                         output consign_flag,
                                         output consign_loc,
                                         output intrans_loc,
                                         output max_aging_days,
                                         output auto_replenish)"""}

               /* CHECK FOR NON-INVOICED USAGE RECORDS. IF */
               /* THEY EXIST, THEN INVOICE. OTHERWISE SKIP.*/
               {gprunmo.i &program = "socnu01.p"  &module = "ACN"
                          &param   = """(input so_nbr,
                                         input sod_line)"}

                  if return-value <> "" then next.

            end. /* IF using_cust_consignment */

            /* RE-ASSIGN THE FLAG SO THAT WE CAN USE EXISTING */
            /* LOGIC TO CALCULATE ORDER TOTAL AND DISCOUNT    */
            l_ord_contains_tax_in_lines = no.

            run ip_calc_amt
               (input-output ext_actual,
                input-output line_total,
                input-output taxable_amt,
                input-output nontaxable_amt,
                buffer       so_mstr,
                buffer       sod_det).
         end.

         disc_amt = (- line_total * (so_disc_pct / 100)).

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output disc_amt,
           input rndmthd,
           output mc-error-number)"}
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end.

         /* ADD TRAILER AMOUNTS */
         {txtrltrl.i so_trl1_cd so_trl1_amt user_desc[1]}
         {txtrltrl.i so_trl2_cd so_trl2_amt user_desc[2]}
         {txtrltrl.i so_trl3_cd so_trl3_amt user_desc[3]}

         /****** CALCULATE TAXES ************/

         /* UNTIL AN INVOICE IS PRINTED REF IS so_nbr AND */
         /* NBR IS BLANK.  ONCE AN INVOICE IS PRINTED     */
         /* REF BECOMES so_inv_nbr AND NBR IS so_nbr      */

         if recalc and not tax-edited then do:
            {gprun.i ""txcalc.p""  "(input  tax_tr_type,
              input  ref,
              input  nbr,
              input  tax_lines, /* ALL LINES */
              input  no,
              output result-status)"}

            /* CREATES TAX RECORDS WITH TRANSACTION TYPE "11" */
            /* FOR THE QUANTITY BACKORDER DURING PENDING      */
            /* INVOICE MAINTENANCE                            */
            if not so_sched
            then do:

               {gprun.i ""txcalc.p""
                  "(input  "11",
                    input  ref,
                    input  nbr,
                    input  tax_lines,
                    input  no,
                    output result-status)"}

            end. /* IF NOT so_sched */

         end.

         {gprun.i ""txabsrb.p""
            "(input so_nbr,
              input ' ',
              input '13',
              input-output line_total,
              input-output taxable_amt)"}

         /* DO TAX DETAIL DISPLAY / EDIT HERE */
         if tax_edit then do:

            hide frame sotot no-pause.
            hide frame d no-pause.

            {gprun.i ""txedit.p""
               "(input  tax_tr_type,
                 input  ref,
                 input  nbr,
                 input  tax_lines, /* ALL LINES */
                 input  so_tax_env,
                 input  so_curr,
                 input  so_ex_ratetype,
                 input  so_ex_rate,
                 input  so_ex_rate2,
                 input  tax_date,
                 output tax_amt)"}

            view frame sotot.
            view frame d.

         end.

         /* CALCULATE TOTALS */
         {gprun.i ""txtotal.p""
            "(input  tax_tr_type,
              input  ref,
              input  nbr,
              input  tax_lines,    /* ALL LINES */
              output tax_amt)"}

         /* OBTAINING TOTAL INCLUDED TAX FOR THE TRANSACTION */
         {gprun.i ""txtotal1.p""
            "(input  tax_tr_type,
              input  ref,
              input  nbr,
              input  tax_lines,      /* ALL LINES */
              output l_tax_in)"}

         /* ADJUSTING LINE TOTALS AND TOTAL TAX BY INCLUDED TAX */
         assign
            taxable_amt = taxable_amt - l_tax_in
            tax_amt     = tax_amt + l_tax_in.

         /* DISCOUNT AMOUNT IS ADJUSTED TO AVOID ROUNDING ERROR */
         /* IN CALCULATION OF ORDER AMOUNT                      */
         if l_tax_in <> 0
         then do:
            {gprunp.i "sopl" "p" "adjustDiscountAmount"
               "(input        taxable_amt,
                 input        nontaxable_amt,
                 input        so_trl1_amt,
                 input        so_trl2_amt,
                 input        so_trl3_amt,
                 input        line_total,
                 input-output disc_amt)"}

         end. /* IF l_tax_in <> 0 */

         ord_amt = line_total + disc_amt + so_trl1_amt
                 + so_trl2_amt + so_trl3_amt + tax_amt.

         if ord_amt < 0 then
            invcrdt = "**" + getTermLabel("C_R_E_D_I_T",11) + "**".
         else
            invcrdt = "".

      end.    /* end if maint block */
      */
      /* SS - 20060602.1 - E */
      
      {etdcrc.i so_curr so_mstr.so}

      /* DISPLAY TRAILER ONLY IF INVOICES ARE NOT CONSOLIDATED */
      if not consolidate then do:

         if not et_dc_print
         then do:

            /* SS - 20060602.1 - B */
            /*
            if txc__qad03 then
               display
                  l_nontaxable_lbl
                  nontaxable_amt
                  l_taxable_lbl
                  taxable_amt
                  with frame sotot.
            else
               display
                  "" @ l_nontaxable_lbl
                  "" @ nontaxable_amt
                  "" @ l_taxable_lbl
                  "" @ taxable_amt
                  with frame sotot.

            display
               so_curr line_total
               so_disc_pct disc_amt tax_date user_desc[1] so_trl1_cd
               so_trl1_amt user_desc[2] so_trl2_cd so_trl2_amt
               user_desc[3] so_trl3_cd so_trl3_amt tax_amt ord_amt
               container_charge_total line_charge_total
               invcrdt
            with frame sotot.
            */

            FIND tta6soivrp0102 WHERE RECID(tta6soivrp0102) = rec1 NO-LOCK NO-ERROR.
            IF NOT AVAILABLE tta6soivrp0102 THEN DO:
               CREATE tta6soivrp0102.
            END.

            if txc__qad03 then
               ASSIGN
                  tta6soivrp0102_nontaxable_amt = nontaxable_amt
                  tta6soivrp0102_taxable_amt = taxable_amt
                  .
            ASSIGN
               tta6soivrp0102_so_curr  = so_curr 
               tta6soivrp0102_line_total = line_total
               tta6soivrp0102_so_disc_pct = so_disc_pct 
               tta6soivrp0102_disc_amt = disc_amt 
               tta6soivrp0102_tax_date = tax_date 
               tta6soivrp0102_user_desc[1] = user_desc[1] 
               tta6soivrp0102_so_trl1_cd = so_trl1_cd
               tta6soivrp0102_so_trl1_amt = so_trl1_amt 
               tta6soivrp0102_user_desc[2] = user_desc[2] 
               tta6soivrp0102_so_trl2_cd = so_trl2_cd 
               tta6soivrp0102_so_trl2_amt = so_trl2_amt
               tta6soivrp0102_user_desc[3] = user_desc[3] 
               tta6soivrp0102_so_trl3_cd = so_trl3_cd 
               tta6soivrp0102_so_trl3_amt = so_trl3_amt 
               tta6soivrp0102_tax_amt = tax_amt 
               tta6soivrp0102_ord_amt = ord_amt
               tta6soivrp0102_container_charge = container_charge_total
               tta6soivrp0102_line_charge_total = line_charge_total
               tta6soivrp0102_invcrdt = invcrdt
               .
            /* SS - 20060602.1 - E */
            
         end. /* IF NOT et_dc_print */
         else
            run ip_dispeuro.
      end.

      undo_trl2 = false.

   end. /* TAXLOOP */

   empty temp-table t_tr_hist1.

end. /*end do for transaction scope */


PROCEDURE ip_dispeuro:

   /* THIS PROCEDURE IS INTRODUCED AS PROGRESS GETS CONFUSED */
   /* BETWEEN TWO FRAMES WITH SAME FIELD so_disc_pct AND     */
   /* ALLOWS AN UNAUTORIZED USER TO UPDATE THE FIELD.        */

   {ettotfrm.i}

   define buffer somstr  for so_mstr.
   define buffer txcctrl for txc_ctrl.

   for first txcctrl
      fields (txc__qad03)
      no-lock:
   end. /* FOR FIRST txcctrl */

   for first somstr
      fields(so_ar_acct  so_ar_cc    so_ar_sub    so_cr_card
             so_cr_init  so_curr     so_cust      so_disc_pct
             so_due_date so_ex_rate  so_ex_rate2  so_fob
             so_invoiced so_inv_nbr  so_nbr       so_ord_date
             so_prepaid  so_print_pl so_print_so  so_rev
             so_sched    so_ship     so_ship_date so_stat
             so_tax_date so_tax_env  so_to_inv    so_trl1_amt
             so_trl1_cd  so_trl2_amt so_trl2_cd   so_trl3_amt
             so_trl3_cd  so__qadl01)
      where recid(somstr) = so_recno
      no-lock:

      /* SS - 20060602.1 - B */
      /*
      if txcctrl.txc__qad03 then
         display
            l_nontaxable_lbl
            nontaxable_amt
            l_taxable_lbl
            taxable_amt
            with frame sototeuro.
      else
         display
            "" @ l_nontaxable_lbl
            "" @ nontaxable_amt
            "" @ l_taxable_lbl
            "" @ taxable_amt
            with frame sototeuro.

      display
         so_curr
         line_total
         so_disc_pct
         disc_amt
         tax_date
         user_desc[1]
         so_trl1_cd
         so_trl1_amt
         user_desc[2]
         so_trl2_cd
         so_trl2_amt
         user_desc[3]
         so_trl3_cd
         so_trl3_amt
         tax_amt
         ord_amt
         et_line_total
         et_disc_amt
         et_trl1_amt
         et_trl2_amt
         et_trl3_amt
         et_tax_amt
         container_charge_total
         line_charge_total
         et_ord_amt
         invcrdt
      with frame sototeuro.
      */

      FIND tta6soivrp0102 WHERE RECID(tta6soivrp0102) = rec1 NO-LOCK NO-ERROR.
      IF NOT AVAILABLE tta6soivrp0102 THEN DO:
         CREATE tta6soivrp0102.
      END.

      if txcctrl.txc__qad03 then
         ASSIGN
            tta6soivrp0102_nontaxable_amt = nontaxable_amt
            tta6soivrp0102_taxable_amt = taxable_amt
            .
      ASSIGN
         tta6soivrp0102_so_curr  = so_curr 
         tta6soivrp0102_line_total = line_total
         tta6soivrp0102_so_disc_pct = so_disc_pct 
         tta6soivrp0102_disc_amt = disc_amt 
         tta6soivrp0102_tax_date = tax_date 
         tta6soivrp0102_user_desc[1] = user_desc[1] 
         tta6soivrp0102_so_trl1_cd = so_trl1_cd
         tta6soivrp0102_so_trl1_amt = so_trl1_amt 
         tta6soivrp0102_user_desc[2] = user_desc[2] 
         tta6soivrp0102_so_trl2_cd = so_trl2_cd 
         tta6soivrp0102_so_trl2_amt = so_trl2_amt
         tta6soivrp0102_user_desc[3] = user_desc[3] 
         tta6soivrp0102_so_trl3_cd = so_trl3_cd 
         tta6soivrp0102_so_trl3_amt = so_trl3_amt 
         tta6soivrp0102_tax_amt = tax_amt 
         tta6soivrp0102_ord_amt = ord_amt
         tta6soivrp0102_container_charge = container_charge_total 
         tta6soivrp0102_line_charge_total = line_charge_total
         tta6soivrp0102_invcrdt = invcrdt
         tta6soivrp0102_et_line_total = et_line_total
         tta6soivrp0102_et_disc_amt = et_disc_amt
         tta6soivrp0102_et_trl1_amt = et_trl1_amt
         tta6soivrp0102_et_trl2_amt = et_trl2_amt
         tta6soivrp0102_et_trl3_amt = et_trl3_amt
         tta6soivrp0102_et_tax_amt = et_tax_amt
         tta6soivrp0102_et_ord_amt = et_ord_amt
         .
      /* SS - 20060602.1 - E */
      
   end. /* FOR FIRST somstr */

END PROCEDURE. /* p_dispeuro */

PROCEDURE ip_calc_amt:

   define input-output parameter p_ext_actual     like sod_price no-undo.
   define input-output parameter p_line_total     as decimal     no-undo.
   define input-output parameter p_taxable_amt    as decimal.
   define input-output parameter p_nontaxable_amt as decimal.
   define parameter    buffer    somstr for so_mstr.
   define parameter    buffer    soddet for sod_det.

   /* l_ext_actual IS THE EXTENDED AMOUNT EXCLUDING DISCOUNT. IT WILL */
   /* BE USED FOR THE CALCULATION OF taxable_amt AND nontaxable_amt   */
   define variable l_ext_actual like sod_price   no-undo.

   if somstr.so_fsm_type = "SC"
   then do:
         p_ext_actual =  soddet.sod_price * soddet.sod_qty_item.

      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output p_ext_actual,
           input rndmthd,
           output mc-error-number)"}
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end. /* IF mc-error-number <> 0 */

      p_ext_actual = p_ext_actual  * soddet.sod_qty_per.

   end. /* IF somstr.so_fsm_type = "SC" */
   else
      p_ext_actual = (soddet.sod_price  * soddet.sod_qty_inv).

   {gprunp.i "mcpl" "p" "mc-curr-rnd"
    "(input-output p_ext_actual,
      input rndmthd,
      output mc-error-number)"}
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end. /* IF mc-error-number <> 0 */

   /* CHECK AUTHORIZATION RECS FOR DIFFERENT EXT PRICE */
   if soddet.sod_sched = yes
      and somstr.so__qadc03 = "yes"
   then do:

      /* REPLACED SECOND PARAMETER FROM so_inv_nbr WITH BLANK */
      /* INORDER TO MATCH THE INVOICE TOTAL WITH DR/CR MEMO TOTAL */

      auth_found = no.
      {gprun.i ""soauthbl.p""
         "(input table t_tr_hist1,
           input '',
           input somstr.so__qadc03,
           input soddet.sod_nbr,
           input soddet.sod_line,
           input soddet.sod_price,
           input soddet.sod_site,
           input p_ext_actual,
           output auth_price,
           output auth_found)"}

      assign
         ext_actual   = auth_price
         p_ext_actual = auth_price.

   end. /*IF sod_sched */

   l_ext_actual = (p_ext_actual * (1 - somstr.so_disc_pct / 100)).
   {gprunp.i "mcpl" "p" "mc-curr-rnd"
    "(input-output l_ext_actual,
      input rndmthd,
      output mc-error-number)"}
    if mc-error-number <> 0
    then do:
       {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
    end. /* IF mc-error-number <> 0 */

   for first t_store_ext_actual
      where t_line = sod_line
      no-lock:
   end. /* FOR FIRST t_store_ext_actual ... */

   /* CALL THE PROCEDURE TO GET LINE TOTAL ONLY WHEN TAX IS INCLUDED */
   /* AND THE TAX HAS BEEN ALREADY CALCULATED WHICH IS INDICATED BY  */
   /* THE EXISTENCE OF TEMPORARY TABLE t_store_ext_actual            */
   /*                                                                */
   /* AFTER WE GET THE LINE TOTAL WE CAN USE THE EXISTING LOGIC TO   */
   /* CALCULATE ORDER TOTAL AND DISCOUNT                             */
   if available t_store_ext_actual
      and soddet.sod_tax_in
   then do:
      {gprunp.i "sopl" "p" "getExtendedAmount"
         "(input        rndmthd,
           input        soddet.sod_line,
           input        somstr.so_nbr,
           input        somstr.so_inv_nbr,
           input        tax_tr_type,
           input-output p_ext_actual)"}
   end. /* IF AVAILABLE t_store_ext_actual ... */

   if not available t_store_ext_actual
   then do:
      create t_store_ext_actual.
      assign
         t_line       = sod_line
         t_ext_actual = p_ext_actual.
   end. /* IF NOT AVAILABLE t_store_ext_actual ... */

   /* USE THE EXISTING LOGIC TO CALCULATE ORDER TOTAL */
   if l_ord_contains_tax_in_lines = no
   then
      p_line_total = p_line_total + p_ext_actual.

   /* FOR CALL INVOICES, SFB_TAXABLE (IN 86E) OF SFB_DET DETERMINES */
   /* TAXABILITY AND THERE COULD BE MULTIPLE SFB_DET FOR A SOD_DET. */
   if soddet.sod_fsm_type = "FSM-RO"
      and soddet.sod_taxable
   then do:
      for each sfb_det
         where sfb_nbr     = soddet.sod_nbr
         and   sfb_so_line = soddet.sod_line
      no-lock:
         if sfb_exchange then
            assign
               p_ext_actual =  0 - (sfb_exg_price * sfb_qty_ret)
               l_ext_actual = (0 - (sfb_exg_price * sfb_qty_ret))
                            * (1 - somstr.so_disc_pct / 100).
         else
            assign
               p_ext_actual = (sfb_price * sfb_qty_req) - sfb_covered_amt
               l_ext_actual = ((sfb_price * sfb_qty_req) - sfb_covered_amt)
                            * (1 - somstr.so_disc_pct / 100).

         /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */
         {gprunp.i "mcpl" "p" "mc-curr-rnd"
          "(input-output p_ext_actual,
            input rndmthd,
            output mc-error-number)"}
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end. /* IF mc-error-number <> 0 */

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
          "(input-output l_ext_actual,
            input rndmthd,
            output mc-error-number)"}
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end. /* IF mc-error-number <> 0 */

         if sfb_taxable then
            p_taxable_amt    = p_taxable_amt    + l_ext_actual.
         else
            p_nontaxable_amt = p_nontaxable_amt + l_ext_actual.

      end. /* FOR EACH SFB_DET */
   end. /* IF SOD_FSM_TYPE = FSM-RO ... */
   else
      if soddet.sod_taxable then
         p_taxable_amt    = p_taxable_amt    + l_ext_actual.
      else
         p_nontaxable_amt = p_nontaxable_amt + l_ext_actual.

   if using_line_charges
   then do:

      if can-find(first absl_det
         where absl_order     = sod_nbr
         and absl_ord_line    = sod_line)
      then do:
         for each absl_det
            fields (absl_confirmed absl_inv_nbr absl_inv_post absl_lc_amt
                    absl_order absl_ord_line absl_trl_code absl_ext_price)
            where absl_order  = sod_nbr
            and absl_ord_line = sod_line
            and (absl_inv_nbr = "" or absl_inv_nbr = ref)
            and absl_confirm  = yes
            and absl_inv_post = no
         no-lock:
            for first trl_mstr
               fields (trl_code trl_taxable)
               where trl_code = absl_trl_code
            no-lock:
               if trl_taxable then
                  p_taxable_amt    = p_taxable_amt    + absl_ext_price.
               else
                  p_nontaxable_amt = p_nontaxable_amt + absl_ext_price.
            end. /* FOR FIRST trl_mstr */
         end. /* FOR EACH absl_det */
      end. /* IF AVAILABLE absl_det */

      if not can-find(first absl_det
         where absl_order     = sod_nbr
         and absl_ord_line    = sod_line)
         and sod_qty_inv <> 0
      then do:
         for each sodlc_det
            fields(sodlc_order sodlc_ord_line sodlc_ext_price
                   sodlc_one_time sodlc_times_charged sodlc_trl_code
                   sodlc_lc_amt)
            where sodlc_order            = sod_nbr
            and   sodlc_ord_line         = sod_line
         no-lock:
            if sodlc_one_time
               and sodlc_times_charged > 0
            then
               next.
            for first trl_mstr
               fields (trl_code trl_taxable)
               where   trl_code    = sodlc_trl_code
            no-lock:
               if trl_taxable then
                  p_taxable_amt    = p_taxable_amt    + sodlc_lc_amt.
               else
                  p_nontaxable_amt = p_nontaxable_amt + sodlc_lc_amt.
            end. /* FOR FIRST trl_mstr */
         end. /* FOR EACH sodlc_det*/
      end. /* IF not available absl_det */
   end. /* IF using_line_charges */

   if using_container_charges
   then do:

      for each abscc_det
         fields (abscc_container abscc_inv_nbr abscc_order
                 abscc_ord_line abscc_taxable abscc_cont_price)
         where abscc_order       = sod_nbr
         and   abscc_ord_line    = sod_line
         and   (abscc_inv_nbr    = "" or abscc_inv_nbr = ref)
         and   abscc_confirm     = yes
         and   abscc_inv_post    = no
      no-lock:
            if abscc_taxable    = yes
            then
               p_taxable_amt    = p_taxable_amt + abscc_cont_price.
            else
               p_nontaxable_amt = p_nontaxable_amt
                                + abscc_cont_price.
      end. /* FOR EACH abscc_det */
   end. /* IF using_container_charges */

END PROCEDURE. /* ip_calc_amt */
