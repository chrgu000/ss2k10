/* soivtrl2.i - PENDING INVOICE TRAILER                                      */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/*V8:ConvertMode=ReportAndMaintenance                                        */
/*V8:RunMode=Character,Windows                                               */
/* REVISION: 7.4      CREATED:       10/02/95   BY: jym *G0XY*               */
/* REVISION: 7.4     MODIFIED:       11/29/95   BY: rxm *H0GY*               */
/* REVISION: 8.5     MODIFIED:       07/13/95   BY: taf *J053*               */
/* REVISION: 8.5     MODIFIED:       01/08/96   BY: jzw *H0K0*               */
/* REVISION: 8.5     LAST MODIFIED:  09/10/96   BY: *H0MP* Aruna P.Patil     */
/* REVISION: 8.6     LAST MODIFIED:  11/25/96   BY: *K01X* jzw               */
/* REVISION: 8.6     LAST MODIFIED:  10/09/97   BY: *K0JV* Surendra Kumar    */
/* REVISION: 8.6     LAST MODIFIED:  01/15/98   BY: *J2B2* Manish K.         */
/* REVISION: 8.6E    LAST MODIFIED:  02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E    LAST MODIFIED:  05/05/98   BY: *L00V* Ed v.d.Gevel      */
/* REVISION: 8.6E    LAST MODIFIED:  05/09/98   BY: *L00Y* Jeff Wootton      */
/* REVISION: 8.6E    LAST MODIFIED:  06/23/98   BY: *L01G* R. McCarthy       */
/* REVISION: 8.6E    LAST MODIFIED:  07/02/98   BY: *L024* Sami Kureishy     */
/* REVISION: 8.6E    LAST MODIFIED:  08/10/98   BY: *J2VV* Rajesh Talele     */
/* REVISION: 8.6E    LAST MODIFIED:  08/19/98   BY: *J2WV* Surekha Joshi     */
/* REVISION: 9.0     LAST MODIFIED:  09/29/98   BY: *J2CZ* Reetu Kapoor      */
/* REVISION: 9.0     LAST MODIFIED:  11/17/98   BY: *H1LN* Poonam Bahl       */
/* REVISION: 9.0     LAST MODIFIED:  01/22/99   BY: *J38T* Poonam Bahl       */
/* REVISION: 9.0     LAST MODIFIED:  03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.0     LAST MODIFIED:  05/07/99   BY: *J3DQ* Niranjan R.       */
/* REVISION: 9.1     LAST MODIFIED:  09/08/99   BY: *N02P* Robert Jensen     */
/* REVISION: 9.1     LAST MODIFIED:  10/01/99   BY: *N014* Murali Ayyagari   */
/* REVISION: 9.1     LAST MODIFIED:  02/24/00   BY: *M0K0* Ranjit Jain       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 07/05/00 BY: *N0F4* Mudit Mehta      */
/* REVISION: 9.1      LAST MODIFIED: 09/05/00 BY: *N0RF* Mark Brown          */

         /*!

         PARAMETERS:

         I/O    NAME        LIKE         DESCRIPTION
         ------ ----------- ------------ ---------------------------------------
         input  ref         tx2d_ref     so_nbr until inv print; then so_inv_nbr
         input  nbr         tx2d_nbr     blank until inv print; then so_nbr
         input  col-80      mfc_logical  true to print report with 80 columns
                                         otherwise report uses 132 columns
         input  tax_tr_type tx2d_tr_type 13 for Pending SO; 16 for posting

          */

/*J2CZ*/ /* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE AND ADDED NO-UNDO */
/*J2CZ*/ /* WHEREVER MISSING FOR PERFORMANCE AND SMALLER R-CODE */

{mfdeclre.i}
			{gplabel.i}
         /* ********** Begin Translatable Strings Definitions ********* */

         &SCOPED-DEFINE soivtrl2_i_1 "Total"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivtrl2_i_2 "Taxable"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivtrl2_i_3 "Total Tax"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivtrl2_i_4 "Discount"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivtrl2_i_5 "Non-Taxable"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivtrl2_i_6 "Line Total"
         /* MaxLen: Comment: */

/*N0F4*
 *       &SCOPED-DEFINE soivtrl2_i_7 "**C R E D I T**"
 *       /* MaxLen: Comment: */
 *N0F4*/

		define input parameter ref like tx2d_ref no-undo.
		define output parameter  totamt as decimal.

         /* ********** End Translatable Strings Definitions ********* */
     /*    define variable ref          like tx2d_ref     no-undo.*/
         define  variable nbr          like tx2d_nbr     no-undo.
         define  variable col-80       like mfc_logical  no-undo.
         define  variable tax_tr_type  like tx2d_tr_type no-undo.


/*M0K0*/ define new shared variable l_txchg      like mfc_logical initial no.
         define new shared variable rndmthd          like rnd_rnd_mthd.
         define new shared variable so_recno         as recid.
/*         define shared variable maint            as logical.
         define shared variable consolidate      like mfc_logical.
*/
         define new shared variable taxable_amt      as decimal
                                                 format "->>>>,>>>,>>9.99"
                                                 label {&soivtrl2_i_2}.
         define new shared variable nontaxable_amt   like taxable_amt
                                                 label {&soivtrl2_i_5}.
         define new shared variable line_total       as decimal
                                                 format "-zzzz,zzz,zz9.99"
                                                 label {&soivtrl2_i_6}.
         define new shared variable disc_amt         like line_total
                                                 label {&soivtrl2_i_4}
                                                 format "(zzzz,zzz,zz9.99)".
         define new shared variable tax_amt          like line_total
                                                 label {&soivtrl2_i_3}.
         define new shared variable ord_amt          like line_total
                                                 label {&soivtrl2_i_1}.
         define new shared variable invcrdt          as character format "x(15)".
         define new shared variable user_desc        like trl_desc extent 3.
         define new shared variable tax_date         like so_tax_date.
/*         define shared variable new_order        like mfc_logical.*/
         define new shared variable tax_edit         like mfc_logical.
         define new shared variable tax_edit_lbl     like mfc_char
                                                 format "x(28)".
         define new shared variable undo_trl2        like mfc_logical.
         define new shared variable tot_line_comm    as decimal extent 4 format
                                                 "->>>>,>>>,>>9.99<<<<".

  /*       define shared frame sotot.*/

         define variable ext_price   like sod_price no-undo.
         define variable ext_actual  like sod_price no-undo.
         define variable tax_lines   like tx2d_line initial 0       no-undo.
         define variable page_break  as integer initial 0           no-undo.
         define variable recalc      like mfc_logical initial true  no-undo.
         define variable tax-edited  like mfc_logical initial false no-undo.
         define variable ext_margin  as decimal
                                      format "->>>>,>>>,>>9.99" no-undo.
         define variable disc_pct    like so_disc_pct no-undo.
         define variable tmp_amt     as decimal no-undo.
         define variable retval      as integer no-undo.
/*H1LN*/ define variable l_retrobill like mfc_logical no-undo.
/*J38T*/ define variable l_tax_in    like tax_amt     no-undo.
/*N02P*/ define variable lgData as logical no-undo.

/*H1LN*  if execname = "rcrbrp01.p" then
 H1LN   l_retrobill = yes.*/ 

		nbr = "".
		tax_tr_type = "13".
		
         {txcalvar.i}
         
         
/*L00L*/ {etvar.i &new="new"}
/*L00L*/ {etdcrvar.i "new"}
/*L00L*/ {etrpvar.i &new="new"}


/*
/*L01G*/ {etdcrvar.i}  /* TOOLKIT DUAL CURRENCY PRICING VARIABLES */
/*L01G*/ {etvar.i}     /* TOOLKIT GENERAL VARIABLES */
/*L01G*/ {etrpvar.i}   /* TOOLKIT REPORTING CURRENCY VARIABLES */

*/

/*J2CZ*/ for first soc_ctrl fields (soc_margin) no-lock: end.


         do for so_mstr:     /*scope this trans */

            if false then
                find so_mstr where recid(so_mstr) = so_recno
                   exclusive-lock no-error.
            else
/*J2CZ**        find so_mstr where recid(so_mstr) = so_recno   */
/*J2CZ**           no-lock no-error.                           */

/*J2CZ*/        for first so_mstr
/*J2CZ*/           fields (so_ar_acct so_ar_cc so_cr_card so_cr_init so_curr
/*N014*/                   so_ar_sub
/*J2CZ*/                   so_cust so_disc_pct so_due_date so_ex_rate
/*J2CZ*/                   so_ex_rate2 so_fob so_invoiced so_inv_nbr so_nbr
/*J2CZ*/                   so_ord_date so_prepaid so_print_pl so_print_so
/*J2CZ*/                   so_rev  so_ship so_ship_date so_stat so_tax_date
/*J2CZ*/                   so_tax_env so_to_inv so_trl1_amt so_trl1_cd
/*J2CZ*/                   so_trl2_amt so_trl2_cd so_trl3_amt so_trl3_cd
/*J2CZ*/                   so__qadl01)
					where so_nbr = ref no-lock:
/*/*J2CZ*/           where recid(so_mstr) = so_recno no-lock: */
/*J2CZ*/        end.
				
				if not available so_mstr then return.
				

            {socurvar.i}
            {txcurvar.i}
/*L00V   {ettotfrm.i}*/ 
/*L00V*     {sototfrm.i} */

/*L024*/       /** GET ROUNDING METHOD FROM CURRENCY MASTER **/
/*L024*/       {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                  "(input so_curr,
                    output rndmthd,
                    output mc-error-number)"}

       taxloop:
       do on endkey undo, leave.

/*J2CZ*/ assign
           line_total = 0
           taxable_amt = 0
           nontaxable_amt = 0
           tot_line_comm[1] = 0
           tot_line_comm[2] = 0
           tot_line_comm[3] = 0
           tot_line_comm[4] = 0.

               if so_tax_date <> ? then
                  tax_date = so_tax_date.
               else if so_ship_date <> ? then
                  tax_date = so_ship_date.
               else
                  tax_date = so_due_date.

               for each sod_det where sod_nbr = so_nbr no-lock:

                  ext_actual = (sod_price * sod_qty_inv).

/*L024*           {gprun.i ""gpcurrnd.p"" "(input-output ext_actual, */
/*L024*                                     input rndmthd)"}         */
/*L024*/          {gprunp.i "mcpl" "p" "mc-curr-rnd"
                   "(input-output ext_actual,
                     input rndmthd,
                     output mc-error-number)"}
/*L024*/          if mc-error-number <> 0 then do:
/*L024*/             {mfmsg.i mc-error-number 2}
/*L024*/          end.

                  line_total = line_total + ext_actual.

/*J2VV*/    /* FOR CALL INVOICES, SFB_TAXABLE (IN 86E) OF SFB_DET DETERMINES */
/*J2VV*/    /* TAXABILITY AND THERE COULD BE MULTIPLE SFB_DET FOR A SOD_DET. */

/*J2VV*/          if sod_fsm_type = "FSM-RO" and sod_taxable then do:
/*J2VV*/             for each sfb_det no-lock where sfb_nbr = sod_nbr and
/*J2VV*/                                            sfb_so_line = sod_line:
/*J2VV*/                ext_actual = sfb_price * sfb_qty_req.
/*J2VV*/                /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */
/*J2VV*/                {gprunp.i "mcpl" "p" "mc-curr-rnd"
                         "(input-output ext_actual,
                           input rndmthd,
                           output mc-error-number)"}
/*J2VV*/                if mc-error-number <> 0 then do:
/*J2VV*/                   {mfmsg.i mc-error-number 2}
/*J2VV*/                end.
/*J2VV*/                if sfb_taxable then
/*J2VV*/                   assign taxable_amt      = taxable_amt + ext_actual.
/*J2VV*/                else
/*J2VV*/                   nontaxable_amt = nontaxable_amt + ext_actual.
/*J2VV*/             end. /* FOR EACH SFB_DET */
/*J2VV*/          end. /* IF SOD_FSM_TYPE = FSM-RO ... */
/*J2VV*/          else
                  if sod_taxable then
                     taxable_amt = taxable_amt + ext_actual.
                  else
                     nontaxable_amt = nontaxable_amt + ext_actual.
                  ext_margin = ext_actual -
                               ROUND(sod_std_cost * (sod_qty_inv),2).
                  if soc_margin = yes then do: /* Commissions based on margin */
/*J2CZ*/             assign
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
/*J2CZ*/             assign
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



               disc_amt = (- line_total * (so_disc_pct / 100)).

/*L024*        {gprun.i ""gpcurrnd.p"" "(input-output disc_amt, */
/*L024*                                  input rndmthd)"}       */
/*L024*/       {gprunp.i "mcpl" "p" "mc-curr-rnd"
                "(input-output disc_amt,
                  input rndmthd,
                  output mc-error-number)"}
/*L024*/       if mc-error-number <> 0 then do:
/*L024*/          {mfmsg.i mc-error-number 2}
/*L024*/       end.

               tmp_amt = taxable_amt * so_disc_pct / 100.

/*L024*        {gprun.i ""gpcurrnd.p"" "(input-output tmp_amt, */
/*L024*                                  input rndmthd)"}      */
/*L024*/       {gprunp.i "mcpl" "p" "mc-curr-rnd"
                "(input-output tmp_amt,
                  input rndmthd,
                  output mc-error-number)"}
/*L024*/       if mc-error-number <> 0 then do:
/*L024*/          {mfmsg.i mc-error-number 2}
/*L024*/       end.

/*J2CZ*/       assign
                taxable_amt = taxable_amt - tmp_amt
                tmp_amt = nontaxable_amt * so_disc_pct / 100.

/*L024*        {gprun.i ""gpcurrnd.p"" "(input-output tmp_amt, */
/*L024*                                  input rndmthd)"}      */
/*L024*/       {gprunp.i "mcpl" "p" "mc-curr-rnd"
                "(input-output tmp_amt,
                  input rndmthd,
                  output mc-error-number)"}
/*L024*/       if mc-error-number <> 0 then do:
/*L024*/          {mfmsg.i mc-error-number 2}
/*L024*/       end.

               nontaxable_amt = nontaxable_amt - tmp_amt.

                /* ADD TRAILER AMOUNTS */
                {txtrltrl.i so_trl1_cd so_trl1_amt user_desc[1]}
                {txtrltrl.i so_trl2_cd so_trl2_amt user_desc[2]}
                {txtrltrl.i so_trl3_cd so_trl3_amt user_desc[3]}

/*J3DQ*/         /* PROCEDURE CALCULATES TOTAL TAXABLE AND NONTAXABLE AMOUNT */
/*J3DQ*/         run p-tottax (input  tax_tr_type,
                               input  ref,
                               input  nbr,
                               input  tax_lines,
                               input-output taxable_amt,
                               input-output nontaxable_amt).

                 {gprun.i ""txabsrb.p"" "(input so_nbr,
                                          input ' ',
                                          input '13',
                                          input-output line_total,
                                          input-output taxable_amt)"}

                /* COPY EDITED RECORDS IF SPECIFIED BY USER */
                if tax-edited then do:
                    {gprun.i ""txedtcpy.p""
                                "(input  '11'               /* SOURCE TR  */,
                                  input  so_nbr             /* SOURCE REF */,
                                  input  nbr                /* SOURCE NBR */,
                                  input  '13'               /* TARGET TR  */,
                                  input  so_nbr             /* TARGET REF */,
                                  input  nbr                /* TARGET NBR */,
                                  input  0)"    }           /* ALL LINES  */
                end.

               /* TOTAL TAX TOTALS */
               
               {gprun.i ""txtotal.p"" "(input  tax_tr_type,
                                        input  ref,
                                        input  nbr,
                                        input  tax_lines,        /* ALL LINES */
                                        output tax_amt)"}

/*J38T*/       /* OBTAINING TOTAL INCLUDED TAX FOR THE TRANSACTION */
/*J38T*/       {gprun.i ""txtotal1.p"" "(input  tax_tr_type,
                                         input  ref,
                                         input  nbr,
                                         input  tax_lines,      /* ALL LINES */
                                         output l_tax_in)"}

/*J38T*/       /* ADJUSTING LINE TOTALS AND TOTAL TAX BY INCLUDED TAX */
/*J38T*/       assign
/*J38T*/         line_total       = line_total - l_tax_in
/*J38T*/         taxable_amt      = taxable_amt - l_tax_in
/*J38T*/         tax_amt          = tax_amt + l_tax_in.

               ord_amt =  line_total + disc_amt + so_trl1_amt
                          + so_trl2_amt + so_trl3_amt + tax_amt.
				
				totamt = ord_amt.
				
             /*   undo_trl2 = false. Changed per discussion skk/pcd */
            end. /* TAXLOOP */
         end. /*end do for transaction scope */

/*J3DQ*/ /* PROCEDURE CALCULATES TOTAL TAXABLE AND NONTAXABLE AMOUNT */
/*J3DQ*/ {txtotal.i}
