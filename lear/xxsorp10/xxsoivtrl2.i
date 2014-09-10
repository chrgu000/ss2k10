/* GUI CONVERTED from soivtrl2.i (converter v1.76) Wed Jul 17 23:11:03 2002 */
/* soivtrl2.i - PENDING INVOICE TRAILER                                       */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.48 $                                                          */
/*V8:ConvertMode=ReportAndMaintenance                                         */
/* REVISION: 7.4      CREATED:        10/02/95   BY: jym *G0XY*               */
/* REVISION: 7.4      MODIFIED:       11/29/95   BY: rxm *H0GY*               */
/* REVISION: 8.5      MODIFIED:       07/13/95   BY: taf *J053*               */
/* REVISION: 8.5      MODIFIED:       01/08/96   BY: jzw *H0K0*               */
/* REVISION: 8.5      LAST MODIFIED:  09/10/96   BY: *H0MP* Aruna P.Patil     */
/* REVISION: 8.6      LAST MODIFIED:  11/25/96   BY: *K01X* jzw               */
/* REVISION: 8.6      LAST MODIFIED:  10/09/97   BY: *K0JV* Surendra Kumar    */
/* REVISION: 8.6      LAST MODIFIED:  01/15/98   BY: *J2B2* Manish K.         */
/* REVISION: 8.6E     LAST MODIFIED:  02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED:  05/05/98   BY: *L00V* Ed v.d.Gevel      */
/* REVISION: 8.6E     LAST MODIFIED:  05/09/98   BY: *L00Y* Jeff Wootton      */
/* REVISION: 8.6E     LAST MODIFIED:  06/23/98   BY: *L01G* R. McCarthy       */
/* REVISION: 8.6E     LAST MODIFIED:  07/02/98   BY: *L024* Sami Kureishy     */
/* REVISION: 8.6E     LAST MODIFIED:  08/10/98   BY: *J2VV* Rajesh Talele     */
/* REVISION: 8.6E     LAST MODIFIED:  08/19/98   BY: *J2WV* Surekha Joshi     */
/* REVISION: 9.0      LAST MODIFIED:  09/29/98   BY: *J2CZ* Reetu Kapoor      */
/* REVISION: 9.0      LAST MODIFIED:  11/17/98   BY: *H1LN* Poonam Bahl       */
/* REVISION: 9.0      LAST MODIFIED:  01/22/99   BY: *J38T* Poonam Bahl       */
/* REVISION: 9.0      LAST MODIFIED:  03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.0      LAST MODIFIED:  05/07/99   BY: *J3DQ* Niranjan R.       */
/* REVISION: 9.1      LAST MODIFIED:  09/08/99   BY: *N02P* Robert Jensen     */
/* REVISION: 9.1      LAST MODIFIED:  10/01/99   BY: *N014* Murali Ayyagari   */
/* REVISION: 9.1      LAST MODIFIED:  02/24/00   BY: *M0K0* Ranjit Jain       */
/* REVISION: 9.1      LAST MODIFIED:  03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED:  07/05/00   BY: *N0F4* Mudit Mehta       */
/* REVISION: 9.1      LAST MODIFIED:  09/05/00   BY: *N0RF* Mark Brown        */
/* REVISION: 9.1      LAST MODIFIED:  09/06/00   BY: *N0D0* Santosh Rao       */
/* REVISION: 9.1      LAST MODIFIED:  10/16/00   BY: *N0W8* Mudit Mehta       */
/* REVISION: 9.1      LAST MODIFIED:  03/05/01   BY: *M12V* Rajaneesh S.      */
/* Revision: 1.42        BY: Ellen Borden        DATE: 07/09/01  ECO: *P007*  */
/* Revision: 1.43        BY: Kaustubh K.         DATE: 07/26/01  ECO: *M1DS*  */
/* Revision: 1.44        BY: Mark Christian      DATE: 02/07/02  ECO: *N18X*  */
/* Revision: 1.46        BY: Ellen Borden        DATE: 03/15/02  ECO: *P00G*  */
/* Revision: 1.47        BY: Jean Miller         DATE: 04/09/02  ECO: *P058*  */
/* $Revision: 1.48 $       BY: Manisha Sawant      DATE: 07/11/02  ECO: *N1NW*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*!

   PARAMETERS:

   I/O    NAME        LIKE         DESCRIPTION
   ------ ----------- ------------ ---------------------------------------
   input  ref         tx2d_ref     so_nbr until inv print; then so_inv_nbr
   input  nbr         tx2d_nbr     blank until inv print; then so_nbr
   input  col-80      mfc_logical  true to print report with 80 columns
                                   otherwise report uses 132 columns
   input  tot_tr_type tx2d_tr_type 13 for Pending SO; 16 for posting
   input  tot_cont_charge  decimal Total container charge amount
   input  tot_line_charge  decimal Total line charge amount

*/

{mfdeclre.i}
{cxcustom.i "SOIVTRL2.I"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE soivtrl2_i_1 "Total"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */
define input parameter ref          like tx2d_ref     no-undo.
define input parameter nbr          like tx2d_nbr     no-undo.
define input parameter col-80       like mfc_logical  no-undo.
define input parameter tax_tr_type  like tx2d_tr_type no-undo.
define input parameter tot_cont_charge as decimal no-undo.
define input parameter tot_line_charge  as decimal no-undo.

define new shared variable undo_txdetrp like mfc_logical.

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
define variable l_retrobill like mfc_logical no-undo.
define variable l_tax_in    like tax_amt     no-undo.
define variable lgData      as logical       no-undo.
define variable l_yn        like mfc_logical no-undo.
define variable l_tax_amt1  like tax_amt     no-undo.
define variable l_tax_amt2  like tax_amt     no-undo.
define variable l_nontaxable_lbl     as character format "x(12)" no-undo.
define variable l_taxable_lbl        as character format "x(12)" no-undo.

/*roger*/ DEFINE shared VARIABL np_fp AS LOGICAL FORMAT "NP/FP" LABEL "δ����/���ۣ�NP/FP��" .

if execname = "rcrbrp01.p" then
   l_retrobill = yes.

{txcalvar.i}

{etdcrvar.i}  /* TOOLKIT DUAL CURRENCY PRICING VARIABLES */
{etvar.i}     /* TOOLKIT GENERAL VARIABLES */
{etrpvar.i}   /* TOOLKIT REPORTING CURRENCY VARIABLES */

/* Find out if this session is being run through Q/LinQ */
/* If so, suppress the pop up windows */
{gprun.i ""mgisact.p"" "(input 'qqimprc', output lgData)"}
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/
 /*RFJ*/

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
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


for first soc_ctrl fields (soc_domain soc_margin) no-lock
    where soc_domain = global_domain:
end.

do for so_mstr:     /*scope this trans */

   if maint then
   find so_mstr where recid(so_mstr) = so_recno
   exclusive-lock no-error.
   else

   for first so_mstr
   fields (so_domain so_ar_acct so_ar_cc so_cr_card so_cr_init so_curr so_ar_sub
      so_cust so_disc_pct so_due_date so_ex_rate
      so_ex_rate2 so_fob so_invoiced so_inv_nbr so_nbr
      so_ord_date so_prepaid so_print_pl so_print_so
      so_rev  so_ship so_ship_date so_stat so_tax_date
      so_tax_env so_to_inv so_trl1_amt so_trl1_cd
      so_trl2_amt so_trl2_cd so_trl3_amt so_trl3_cd
      so__qadl01)
      where recid(so_mstr) = so_recno no-lock:
   end.

   {&SOIVTRL2-I-TAG2}

   /**** FORMS ****/
   FORM /*GUI*/


&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
&ENDIF /*GUI*/
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


&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 SKIP(.4)  /*GUI*/
&ENDIF /*GUI*/
with frame d side-labels width 80
&IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 STREAM-IO /*GUI*/
&ENDIF /*GUI*/

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 NO-BOX THREE-D /*GUI*/
&ENDIF /*GUI*/
.


&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 DEFINE VARIABLE F-d-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame d = F-d-title.
 RECT-FRAME-LABEL:HIDDEN in frame d = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame d =
  FRAME d:HEIGHT-PIXELS - RECT-FRAME:Y in frame d - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME d = FRAME d:WIDTH-CHARS - .5.  /*GUI*/
&ENDIF /*GUI*/


   /* SET EXTERNAL LABELS */
   setFrameLabels(frame d:handle).

   {socurvar.i}
   {txcurvar.i}
/*roger*/   {sototfrm.i}

   taxloop:
   do on endkey undo, leave:

      /* PRINT THE DETAIL REPORT ONLY FOR REPORTS      */
      /* WHERE THE INVOICES HAVE NOT BEEN CONSOLIDATED */
      if not maint and not consolidate then do:
         undo_txdetrp = true.
         {gprun.i  ""txdetrp.p"" "(input tax_tr_type,
              input ref,
              input nbr,
              input col-80,
              input page_break)" }
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/

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
      assign
         line_total = 0
         taxable_amt = 0
         nontaxable_amt = 0
         tot_line_comm[1] = 0
         tot_line_comm[2] = 0
         tot_line_comm[3] = 0
         tot_line_comm[4] = 0.

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

      for each sod_det where sod_domain = global_domain and sod_nbr = so_nbr
/*roger*/          AND ((np_fp = YES AND sod_user1 = "NP") OR (np_fp = NO AND sod_user1 = "FP"))
          no-lock:
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


         if using_cust_consignment then do:
            /* IF THE ORDER LINE IS A CONSIGNMENT ORDER LINE  */
            /* THEN WE DON'T WANT THE DOLLAR AMOUNT INCLUDED  */
            /* ON THE INVOICE WHEN THE LINE HAS BEEN SHIPPED, */
            /* BUT WHEN THE SHIPMENT HAS BEEN USED.           */
            {gprunmo.i
               &program = "socnsod1.p"
               &module = "ACN"
               &param = """(input so_nbr,
                 input sod_line,
                 output consign_flag,
                 output consign_loc,
                 output intrans_loc,
                 output max_aging_days,
                 output auto_replenish)"""}

            if consign_flag then do:
               /* CHECK FOR USAGE RECORDS.               */
               /* IF USAGE RECORDS EXIST, THEN INVOICE.   */
               /* IF THEY DON'T RECORDS EXIST, THEN SKIP. */
               {gprunmo.i
                  &program = "socnu01.p"
                  &module = "ACN"
                  &param = """(input so_nbr,
                    input sod_line)"}

               if return-value <> "" then next.
            end.  /* if return-value = "" */
         end. /* IF using_cust_consignment */

         ext_actual = (sod_price * sod_qty_inv).

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output ext_actual,
              input rndmthd,
              output mc-error-number)"}
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end.

         line_total = line_total + ext_actual.

         /* FOR CALL INVOICES, SFB_TAXABLE (IN 86E) OF SFB_DET DETERMINES */
         /* TAXABILITY AND THERE COULD BE MULTIPLE SFB_DET FOR A SOD_DET. */
         if sod_fsm_type = "FSM-RO" and sod_taxable then do:

            for each sfb_det where sfb_domain = global_domain and sfb_nbr = sod_nbr and
                  sfb_so_line = sod_line
            no-lock:
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/

               ext_actual = sfb_price * sfb_qty_req.
               /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */
               {gprunp.i "mcpl" "p" "mc-curr-rnd"
                  "(input-output ext_actual,
                    input rndmthd,
                    output mc-error-number)"}
               if mc-error-number <> 0 then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               end.
               if sfb_taxable then
                  assign taxable_amt      = taxable_amt + ext_actual.
               else
                  nontaxable_amt = nontaxable_amt + ext_actual.
            end.
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/
 /* FOR EACH SFB_DET */

         end. /* IF SOD_FSM_TYPE = FSM-RO ... */

         else
         if sod_taxable then
            taxable_amt = taxable_amt + ext_actual.
         else
            nontaxable_amt = nontaxable_amt + ext_actual.

         ext_margin = ext_actual - round(sod_std_cost * (sod_qty_inv),2).

         if soc_margin = yes then do: /* Commissions based on margin */
            assign
               tot_line_comm[1] = tot_line_comm[1] +
               ext_margin * sod_comm_pct[1] / 100
               tot_line_comm[2] = tot_line_comm[2] +
               ext_margin * sod_comm_pct[2] / 100
               tot_line_comm[3] = tot_line_comm[3] +
               ext_margin * sod_comm_pct[3] / 100
               tot_line_comm[4] = tot_line_comm[4] +
               ext_margin * sod_comm_pct[4] / 100.
         end.

         else do:                     /* Commissions based on sales  */
            assign
               tot_line_comm[1] = tot_line_comm[1] +
               ext_actual * sod_comm_pct[1] / 100
               tot_line_comm[2] = tot_line_comm[2] +
               ext_actual * sod_comm_pct[2] / 100
               tot_line_comm[3] = tot_line_comm[3] +
               ext_actual * sod_comm_pct[3] / 100
               tot_line_comm[4] = tot_line_comm[4] +
               ext_actual * sod_comm_pct[4] / 100.
         end.

      end.
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


      {&SOIVTRL2-I-TAG3}

      /* SKIPPING SALES VOLUME DISCOUNT CALCULATION    */
      /* FOR RETROBILLED ITEMS                         */
      if maint and not so__qadl01 and not l_retrobill then do:

         for first cm_mstr fields (cm_domain cm_addr cm_disc_pct)
            where cm_domain = global_domain and cm_addr = so_cust no-lock:
         end.

         if so_cust <> so_ship and
            can-find (cm_mstr where cm_mstr.cm_domain = global_domain and cm_mstr.cm_addr = so_ship)
         then
         for first cm_mstr fields (cm_domain cm_addr cm_disc_pct)
            where cm_mstr.cm_domain = global_domain and cm_mstr.cm_addr = so_ship no-lock:
         end.

         /* ADDED SECOND EXCHANGE RATE BELOW */
         {gprun.i ""sosd.p"" "(input so_ord_date,
              input so_ex_rate,
              input so_ex_rate2,
              input so_cust,
              input so_curr,
              input line_total,
              output disc_pct)"}
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/

         if disc_pct > cm_disc_pct and disc_pct <> 0 then
            so_disc_pct = disc_pct.
         else
            so_disc_pct = cm_disc_pct.

      end.

      disc_amt = (- line_total * (so_disc_pct / 100)).

      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output disc_amt,
           input rndmthd,
           output mc-error-number)"}
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.

      tmp_amt = taxable_amt * so_disc_pct / 100.

      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output tmp_amt,
           input rndmthd,
           output mc-error-number)"}
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.

      assign
         taxable_amt = taxable_amt - tmp_amt
         tmp_amt = nontaxable_amt * so_disc_pct / 100.

      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output tmp_amt,
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
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


         /* OBTAINING TOTAL INCLUDED TAX FOR THE TRANSACTION */
         {gprun.i ""txtotal1.p"" "(input  tax_tr_type,
              input  ref,
              input  nbr,
              input  tax_lines,  /* ALL LINES */
              output l_tax_amt2)"}
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


         l_tax_amt1 = l_tax_amt1 + l_tax_amt2.

         /* SEE IF ANY TAX DETAIL EXISTS */

         for first tx2d_det fields (tx2d_domain tx2d_edited tx2d_nbr
                   tx2d_ref tx2d_tr_type)
            where tx2d_domain = global_domain and tx2d_ref = so_nbr and
            tx2d_nbr = nbr and
            tx2d_tr_type = tax_tr_type no-lock:
         end.

         if available tx2d_det then do:

            /* CHECK PREVIOUS DETAIL FOR EDITED VALUES */
            for first tx2d_det fields (tx2d_domain tx2d_edited tx2d_nbr
                      tx2d_ref tx2d_tr_type)
               where tx2d_domain = global_domain and tx2d_ref = so_nbr and
               tx2d_nbr = nbr             and
               tx2d_tr_type = tax_tr_type and
               tx2d_edited no-lock:
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
                 output tax-edited)" }
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/
     /* RETURN VAL */

            if tax-edited then do:
               /* Copy edited tax values? */
               {pxmsg.i &MSGNUM=935 &ERRORLEVEL=2 &CONFIRM=tax-edited}
            end.
         end.

         if recalc then do:

            /* ADDED TWO PARAMETERS TO TXCALC.P, INPUT PARAMETER VQ-POST */
            /* AND OUTPUT PARAMETER RESULT-STATUS. THE POST FLAG IS SET  */
            /* TO 'NO' BECAUSE WE ARE NOT CREATING QUANTUM REGISTER      */
            /* RECORDS FROM THIS CALL TO TXCALC.P                        */
            {gprun.i ""txcalc.p""
               "(input  tax_tr_type,
                 input  ref,
                 input  nbr,
                 input  tax_lines /* ALL LINES */,
                 input no,
                 output result-status)" }
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


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
                    output result-status)" }
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/

            end. /* IF NOT so_sched */

         end. /* IF recalc */

      end. /* IF maint */

      /* PROCEDURE CALCULATES TOTAL TAXABLE AND NONTAXABLE AMOUNT */
      run p-tottax
         (input  tax_tr_type,
          input  ref,
          input  nbr,
          input  tax_lines,
          input-output taxable_amt,
          input-output nontaxable_amt).

      {gprun.i ""txabsrb.p""
         "(input so_nbr,
           input ' ',
           input '13',
           input-output line_total,
           input-output taxable_amt)"}
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


      /* COPY EDITED RECORDS IF SPECIFIED BY USER */
      if tax-edited then do:
         {gprun.i ""txedtcpy.p""
            "(input  '11'      /* SOURCE TR  */,
              input  so_nbr             /* SOURCE REF */,
              input  nbr                /* SOURCE NBR */,
              input  '13'               /* TARGET TR  */,
              input  so_nbr             /* TARGET REF */,
              input  nbr                /* TARGET NBR */,
              input  0)"    }
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/
           /* ALL LINES  */
      end.

      /* TOTAL TAX TOTALS */
      {gprun.i ""txtotal.p""
         "(input  tax_tr_type,
           input  ref,
           input  nbr,
           input  tax_lines, /* ALL LINES */
           output tax_amt)"}
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


      /* OBTAINING TOTAL INCLUDED TAX FOR THE TRANSACTION */
      {gprun.i ""txtotal1.p""
         "(input  tax_tr_type,
           input  ref,
           input  nbr,
           input  tax_lines,      /* ALL LINES */
           output l_tax_in)"}
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


      /* ADJUSTING LINE TOTALS AND TOTAL TAX BY INCLUDED TAX */
      assign
         line_total       = line_total - l_tax_in
         tax_amt          = tax_amt + l_tax_in.

      ord_amt =  line_total + disc_amt + so_trl1_amt +
                 so_trl2_amt + so_trl3_amt + tax_amt.

      if ord_amt < 0 then
         invcrdt = "**" + getTermLabel("C_R_E_D_I_T",11) + "**".
      else
         invcrdt = "".

      if maint then do on endkey undo taxloop, leave:

         display
            nontaxable_amt
            so_curr
            line_total
            taxable_amt
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
         with frame sotot
&IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 STREAM-IO /*GUI*/
&ENDIF /*GUI*/
.

         /* Don't re-set the tax data */
         if not lgData then do:

            trlloop:
            do on error undo trlloop, retry
               on endkey undo taxloop, leave:
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


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
                     and l_tax_amt1 <> tax_amt
                  then do:
                     hide message no-pause.
                     /* TAX DETAIL RECORDS WILL NOT BE SAVED WHEN F4 */
                     /* OR ESC IS PRESSED.                           */
                     {pxmsg.i &MSGNUM=4773 &ERRORLEVEL=2}
                     /* CONTINUE WITHOUT SAVING?                     */
                     {pxmsg.i &MSGNUM=4774 &ERRORLEVEL=1 &CONFIRM=l_yn}
                     hide message no-pause.
                     if l_yn
                     then
                        undo taxloop, leave.
                  end. /* IF KEYFUNCTION(LASTKEY) */
                  else
                     apply lastkey.
               end. /* EDITING */
               {&SOIVTRL2-I-TAG5}

               /* TO CHECK WHETHER DISCOUNT PERCENTAGE MANUALLY ENTERED?*/
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
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/

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
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/

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
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/

                  if retval <> 0 then do:
                     next-prompt so_trl3_amt with frame sotot.
                     undo trlloop, retry.
                  end.
               end.

            end.
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/
 /* TRLLOOP */
         end. /* if not lgData */

         /*** GET TOTALS FOR LINES ***/
         line_total = 0.
         taxable_amt = 0.
         nontaxable_amt = 0.

         assign
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

         for each sod_det where sod_domain = global_domain and sod_nbr = so_nbr
/*roger*/          AND ((np_fp = YES AND sod_user1 = "NP") OR (np_fp = NO AND sod_user1 = "FP")):
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


            if using_cust_consignment then do:
               /* IF THE ORDER LINE IS A CONSIGNMENT ORDER LINE  */
               /* THEN WE DON'T WANT THE DOLLAR AMOUNT INCLUDED  */
               /* ON THE INVOICE WHEN THE LINE HAS BEEN SHIPPED, */
               /* BUT WHEN THE SHIPMENT HAS BEEN USED.           */

               {gprunmo.i
               &program = "socnsod1.p"
               &module = "ACN"
               &param = """(input so_nbr,
                 input sod_line,
                 output consign_flag,
                 output consign_loc,
                 output intrans_loc,
                 output max_aging_days,
                 output auto_replenish)"""}

               if consign_flag then do:
                  /* CHECK FOR USAGE RECORDS.                */
                  /* IF USAGE RECORDS EXIST, THEN INVOICE.   */
                  /* IF THEY DON'T RECORDS EXIST, THEN SKIP. */
                  {gprunmo.i
                  &program = "socnu01.p"
                  &module = "ACN"
                  &param = """(input so_nbr,
                    input sod_line)"}

                  if return-value <> "" then next.
               end.  /* if return-value = "" */
            end. /* IF using_cust_consignment */

            ext_actual = (sod_price * sod_qty_inv).

            {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output ext_actual,
              input rndmthd,
              output mc-error-number)"}
            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end.

            line_total = line_total + ext_actual.

            /* FOR CALL INVOICES, SFB_TAXABLE (IN 86E) OF SFB_DET DETERMINES */
            /* TAXABILITY AND THERE COULD BE MULTIPLE SFB_DET FOR A SOD_DET. */

            if sod_fsm_type = "FSM-RO" and sod_taxable then do:
               for each sfb_det no-lock where sfb_domain = global_domain and sfb_nbr = sod_nbr and
                  sfb_so_line = sod_line:
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/

                  ext_actual = sfb_price * sfb_qty_req.
                  /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */
                  {gprunp.i "mcpl" "p" "mc-curr-rnd"
                  "(input-output ext_actual,
                    input rndmthd,
                    output mc-error-number)"}
                  if mc-error-number <> 0 then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                  end.
                  if sfb_taxable then
                     assign taxable_amt = taxable_amt + ext_actual.
                  else
                     nontaxable_amt = nontaxable_amt + ext_actual.
               end.
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/
 /* FOR EACH SFB_DET */
            end. /* IF SOD_FSM_TYPE = FSM-RO ... */
            else
               if sod_taxable then
               taxable_amt = taxable_amt + ext_actual.
            else
               nontaxable_amt = nontaxable_amt + ext_actual.
         end.
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


         disc_amt = (- line_total * (so_disc_pct / 100)).

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output disc_amt,
           input rndmthd,
           output mc-error-number)"}
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end.

         tmp_amt = taxable_amt * so_disc_pct / 100.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output tmp_amt,
           input rndmthd,
           output mc-error-number)"}
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end.

         taxable_amt = taxable_amt - tmp_amt.

         tmp_amt = nontaxable_amt * so_disc_pct / 100.

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output tmp_amt,
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
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


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
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


            end. /* IF NOT so_sched */

         end.

         /* PROCEDURE CALCULATES TOTAL TAXABLE AND NONTAXABLE AMOUNT */
         run p-tottax
            (input  tax_tr_type,
             input  ref,
             input  nbr,
             input  tax_lines,
             input-output taxable_amt,
             input-output nontaxable_amt).

         {gprun.i ""txabsrb.p""
            "(input so_nbr,
              input ' ',
              input '13',
              input-output line_total,
              input-output taxable_amt)"}
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


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
                 output tax_amt)"}
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


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
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


         /* OBTAINING TOTAL INCLUDED TAX FOR THE TRANSACTION */
         {gprun.i ""txtotal1.p""
            "(input  tax_tr_type,
              input  ref,
              input  nbr,
              input  tax_lines,      /* ALL LINES */
              output l_tax_in)"}
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


         /* ADJUSTING LINE TOTALS AND TOTAL TAX BY INCLUDED TAX */
         assign
            line_total = line_total - l_tax_in
            tax_amt    = tax_amt + l_tax_in.
            ord_amt    = line_total + disc_amt + so_trl1_amt +
                         so_trl2_amt + so_trl3_amt + tax_amt.

         if ord_amt < 0 then
            invcrdt = "**" + getTermLabel("C_R_E_D_I_T",11) + "**".
         else
            invcrdt = "".

      end.    /* end if maint block */

      {etdcrc.i so_curr so_mstr.so}

      /* DISPLAY TRAILER ONLY IF INVOICES ARE NOT CONSOLIDATED */
      if not consolidate then do:

         if not et_dc_print then
            display
               nontaxable_amt so_curr line_total taxable_amt
               so_disc_pct disc_amt tax_date user_desc[1] so_trl1_cd
               so_trl1_amt user_desc[2] so_trl2_cd so_trl2_amt
               user_desc[3] so_trl3_cd so_trl3_amt tax_amt ord_amt
               container_charge_total line_charge_total
               invcrdt
            with frame sotot
&IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 STREAM-IO /*GUI*/
&ENDIF /*GUI*/
.

         /* MOVED DISPLAY USING FRAME sototeuro TO INTERNAL PROCEDURE */
         /* ip_dispeuro AS PROGRESS GETS CONFUSED BETWEEN TWO FRAMES  */
         /* WITH SAME FIELD so_disc_pct AND ALLOWS UNAUTHORIZED USER  */
         /* TO UPDATE THE FIELD.                                      */

         else
            run ip_dispeuro.
      end.

      undo_trl2 = false. /* Changed per discussion skk/pcd */

   end. /* TAXLOOP */

end. /*end do for transaction scope */

/* PROCEDURE CALCULATES TOTAL TAXABLE AND NONTAXABLE AMOUNT */
/*roger*/ {xxtxtotal.i}

PROCEDURE ip_dispeuro:

   /* THIS PROCEDURE IS INTRODUCED AS PROGRESS GETS CONFUSED */
   /* BETWEEN TWO FRAMES WITH SAME FIELD so_disc_pct AND     */
   /* ALLOWS AN UNAUTORIZED USER TO UPDATE THE FIELD.        */

/*roger*/   {ettotfrm.i}

   define buffer somstr for so_mstr.

   for first somstr fields(so_domain so_ar_acct so_ar_cc so_ar_sub so_cr_card
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

      display
         nontaxable_amt
         so_curr
         line_total
         taxable_amt
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
      with frame sototeuro
&IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 STREAM-IO /*GUI*/
&ENDIF /*GUI*/
.

   end. /* FOR FIRST somstr */

END PROCEDURE. /* p_dispeuro */
