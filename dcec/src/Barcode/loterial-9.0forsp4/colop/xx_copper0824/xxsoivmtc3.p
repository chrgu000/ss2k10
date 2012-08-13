/* xxsoivmtc3.p - INVOICE MAINTENANCE TRAILER                                   */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.14.1.11 $                                                     */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.3                                                              */
/* REVISION: 7.4      LAST MODIFIED: 06/21/93   BY: pcd *H009*                */
/* REVISION: 7.4      LAST MODIFIED: 07/01/93   BY: bcm *H002*                */
/*                                   07/29/93   BY: jjs *H043*                */
/* REVISION: 7.4      LAST MODIFIED: 08/23/93   BY: cdt *H049*                */
/* REVISION: 7.4      LAST MODIFIED: 10/14/93   BY: dpm *H067*                */
/* REVISION: 7.4      LAST MODIFIED: 07/27/94   BY: rxm *FP61*                */
/* REVISION: 7.4      LAST MODIFIED: 10/21/94   BY: rmh *FQ08*                */
/* REVISION: 7.4      LAST MODIFIED: 04/20/95   BY: vrn *F0QS*                */
/* REVISION: 8.5      LAST MODIFIED: 04/24/95   BY: DAH *J042*                */
/* REVISION: 7.4      LAST MODIFIED: 06/23/95   BY: kjm *G0ML*                */
/* REVISION: 7.4      LAST MODIFIED: 10/02/95   BY: jym *G0XY*                */
/* REVISION: 7.4      LAST MODIFIED: 11/29/95   BY: rxm *H0GY*                */
/* REVISION: 8.5      LAST MODIFIED: 07/14/95   BY: taf *J053*                */
/* REVISION: 8.5      LAST MODIFIED: 08/02/96   BY: *J12Q* Andy Wasilczuk     */
/* REVISION: 8.5      LAST MODIFIED: 08/06/96   BY: *G1ZR* Suresh Nayak       */
/* REVISION: 8.5      LAST MODIFIED: 01/29/98   BY: *J2BC* Aruna Patil        */
/* REVISION: 8.5      LAST MODIFIED: 02/12/98   BY: *J2F4* Manish K.          */
/* REVISION: 8.6E     LAST MODIFIED: 04/27/98   BY: Adam Harris *L00L*/
/* REVISION: 8.6E     LAST MODIFIED: 05/12/98   BY: *J2LF* Niranjan R.        */
/* Old ECO marker removed, but no ECO header exists *G588*                    */
/* Old ECO marker removed, but no ECO header exists *G858*                    */
/* REVISION: 8.6E     LAST MODIFIED: 07/06/98   BY: *L024* Sami Kureishy      */
/* REVISION: 9.1      LAST MODIFIED: 09/08/99   BY: *N02P* Robert Jensen      */
/* REVISION: 9.1      LAST MODIFIED: 10/18/99   BY: *N049* Robert Jensen      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Old ECO marker removed, but no ECO header exists *F273*                    */
/* Old ECO marker removed, but no ECO header exists *F458*                    */
/* Old ECO marker removed, but no ECO header exists *F676*                    */
/* Old ECO marker removed, but no ECO header exists *G416*                    */
/* Revision: 1.14.1.9      BY: Katie Hilbert     DATE: 04/01/01   ECO: *P002* */
/* Revision: 1.14.1.10     BY: Steve Nugent      DATE: 07/09/01   ECO: *P007* */
/* $Revision: 1.14.1.11 $  BY: Jean Miller       DATE: 04/10/02   ECO: *P058* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define new shared variable convertmode as character no-undo initial "MAINT".
define new shared variable consolidate like mfc_logical initial false.
define new shared variable sotax_update like mfc_logical no-undo .
define new shared variable undo_mainblk like mfc_logical no-undo .

define shared variable rndmthd like rnd_rnd_mthd.
define shared variable cr_terms_changed like mfc_logical no-undo.
define shared variable so_recno as recid.
define shared variable cm_recno as recid.
define shared variable base_amt like ar_amt.
define shared variable undo_trl2 like mfc_logical.
define shared variable undo_mtc3 like mfc_logical.
define shared variable balance_fmt as character.
define shared variable limit_fmt as character.
define shared variable prepaid_fmt as character no-undo.
define shared variable calc_fr    like mfc_logical.
define shared variable disp_fr    like mfc_logical.
define shared variable freight_ok like mfc_logical.

define shared frame d.
define shared frame sotot.

define variable col-80 like mfc_logical initial false.
define variable ship_amt like ar_amt.
define variable mc-error-number like msg_nbr no-undo.
define variable idx as integer no-undo.

{etdcrvar.i}
{etsotrla.i}

{xxsoivmt01.i} /* DEFINE FRAME D */
so_prepaid:format = prepaid_fmt.

define variable tot_cont_charges as decimal no-undo initial 0.
define variable tot_line_charges as decimal no-undo.
define variable vLinePrice as decimal no-undo.
define variable tmp_tot_cont_charge as decimal no-undo.
define variable msg-arg as character format "x(20)" no-undo.

/* VARIABLE DEFINITIONS FOR gpfile.i */
{gpfilev.i}

/* TEMP TABLE DEFINITION FOR CONTAINER CHARGES INFO */
{ccltt.i}

/*DETERMINE IF CONTAINER AND LINE CHARGES ARE ENABLED*/
{cclc.i}

/* Logistics Table Input */
{lgivdefs.i &type="lg"}

find first soc_ctrl no-lock.
find so_mstr where recid(so_mstr) = so_recno.
find cm_mstr where recid(cm_mstr) = cm_recno no-lock.

maint = yes.

/* External Orders may have trailer charges embedded */
/* If so, get them now. */
if lgData then run ExternalTrl.

if using_line_charges or using_container_charges then
   assign
      line_total = 0
      nontaxable_amt = 0
      taxable_amt = 0
      line_charge_total = 0
      container_charge_total = 0
      ord_amt = 0.


/* MOVED THIS BLOCK UP FOR CONSISTENCY WITH SO MAINTENANCE    */
/*ADDED BLOCK TO WARN USER IF CREDIT TERMS WAS CHANGED DURING */
/*PRICING AND THE TERMS INTEREST WAS NOT USED TO RECALCULATE  */
/*PRICES. */
if cr_terms_changed then do:
   find ct_mstr where ct_code = so_cr_terms no-lock no-error.
   if available ct_mstr and ct_terms_int <> 0 then do:
      /* TERMS CODE CHANGED FOR THIS ORDER BY A CREDIT TERMS PRICELIST. */
      {pxmsg.i &MSGNUM=6222 &ERRORLEVEL=2}
      /* TERMS INTEREST OF # PERCENT NOT APPLIED TO THIS ORDER. */
      {pxmsg.i &MSGNUM=6223 &ERRORLEVEL=2 &MSGARG1=ct_terms_int}
   end. /* IF AVAILABLE CT_MSTR */
end. /* IF CR_TERMS_CHANGED */

/* End and start a new transaction so default trailer codes     */
/* will be set even if user doesn't go through trailer screens. */
mainblk:
do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.


   /* DISPLAY FREIGHT WEIGHTS */
   if so_fr_list <> "" then do:
      if calc_fr then do:
         if not freight_ok then do:
            {pxmsg.i &MSGNUM=669 &ERRORLEVEL=2}
            /* Freight error detected - */
            if not batchrun then pause.
         end.
         if disp_fr then do:
            /* Freight Weight = */
            {pxmsg.i &MSGNUM=698 &ERRORLEVEL=1
                     &MSGARG1=so_weight
                     &MSGARG2=so_weight_um}
         end.
      end.
   end.

   /* For Logistics Orders, get tax data from the Tables */
   if lgData then do:
      run ExternalTax.
   end.

   {sototdsp.i}
   undo_trl2 = true.

   if using_container_charges or using_line_charges then
      run container_line_charge_calc (input so_recno).
   
   {gprun.i ""xxsoivtrl2.p"" "(input so_nbr /* TX2D_REF */,
                             input ''     /* TX2D_NBR */,
                             input col-80 /* REPORT WIDTH */,
                             input '13'   /* TRANSACTION TYPE */,
                             input tot_cont_charges ,
                             input tot_line_charges )"}
/*GUI*/ if global-beam-me-up then undo, leave.

   if undo_trl2 then return.
   {sototdsp.i}

   /* CHECK FOR MINIMUM NET ORDER AMOUNT DUE TO REQUIREMENT OF
   QUALIFYING PRICE LIST.  IF VIOLATION FOUND, DISPLAY WARNING
   MESSAGE.*/

   for each pih_hist where pih_doc_type = 1 and
         pih_nbr      = so_nbr
         no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.

      if pih_min_net <> 0 and pih_min_net > line_total then do:
         /*Price list requires min net order amt, price list:*/
         {pxmsg.i &MSGNUM=6925 &ERRORLEVEL=2
                  &MSGARG1=pih_list
                  &MSGARG2=pih_min_net}
         if not batchrun then
            pause.
      end.
   end.
/*GUI*/ if global-beam-me-up then undo, leave.


   if new so_mstr then so_to_inv = yes.

   /* CHECK FOR MINIMUM SHIP AMOUNT */
   find mfc_ctrl where mfc_field = "soc_min_shpamt"no-lock no-error.
   if available mfc_ctrl then do:
      ship_amt = mfc_decimal.
      if so_curr <> base_curr then do:
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input base_curr,
              input so_curr,
              input so_ex_rate2,
              input so_ex_rate,
              input ship_amt,
              input false,
              output ship_amt,
              output mc-error-number)"}
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end.
      end.
      if ord_amt > 0 and  ord_amt < ship_amt then do:
         /* Ord amount is lt Minmum Shipment  Amount. */
         {pxmsg.i &MSGNUM=6211 &ERRORLEVEL=2
                  &MSGARG1=ord_amt
                  &MSGARG2=ship_amt}
      end.
   end.

   /* CHECK CREDIT LIMIT */
   base_amt = ord_amt.
   if so_curr <> base_curr then do:

      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input so_curr,
           input base_curr,
           input so_ex_rate,
           input so_ex_rate2,
           input ord_amt,
           input true,
           output base_amt,
           output mc-error-number)"}
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.
   end.
   if cm_cr_limit < (cm_balance + base_amt) then do:
      msg-arg = string((cm_balance + base_amt),balance_fmt).
      /* Customer Balance plus this Order */
      {pxmsg.i &MSGNUM=616 &ERRORLEVEL=2 &MSGARG1=msg-arg}
      msg-arg = string(cm_cr_limit,limit_fmt).
      /* Credit Limit */
      {pxmsg.i &MSGNUM=617 &ERRORLEVEL=1 &MSGARG1=msg-arg}
   end.
end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /*transaction*/

if undo_mainblk then leave.
undo_mtc3 = false.

/* ADD INTERNAL PROCEDURES FOR GETTING TRAILER */
/* DATA FROM LOGISTICS TABLES AND FOR SETTING UP */
/* TAX DATA. */

procedure ExternalTrl:
   do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.

      /* Initialize the trailer charges. */
      assign
         so_mstr.so_trl1_cd = ""
         so_trl1_amt = 0
         so_trl2_cd = ""
         so_trl2_amt = 0
         so_trl3_cd = ""
         so_trl3_amt = 0.
      /* ADD UP THE CHARGES IN EACH CATAGORY.  MFG/PRO LIMITS THE */
      /* NUMBER OF CATEGORIES TO THREE */
      for each lgit_lgdet no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.

         /* First see if this charge type is already listed. */
         /* If so add this amount to the existing amount */
         if lgit_so_trl_cd = so_trl1_cd then
            so_trl1_amt = so_trl1_amt + lgit_so_trl_amt.
         else if lgit_so_trl_cd = so_trl2_cd then
            so_trl2_amt = so_trl2_amt + lgit_so_trl_amt.
         else if lgit_so_trl_cd = so_trl3_cd then
            so_trl3_amt = so_trl3_amt + lgit_so_trl_amt.
        /* Not on the list, find the first blank and add it in */
         else if so_trl1_cd = "" then
         assign
            so_trl1_cd = lgit_so_trl_cd
            so_trl1_amt = lgit_so_trl_amt.
         else if so_trl2_cd = "" then
         assign
            so_trl2_cd = lgit_so_trl_cd
            so_trl2_amt = lgit_so_trl_amt.
         else if so_trl3_cd = "" then
         assign
            so_trl3_cd = lgit_so_trl_cd
            so_trl3_amt = lgit_so_trl_amt.
         else do:
            /* Error, Only three trailer charges allowed. */
            {pxmsg.i &MSGNUM=3329 &ERRORLEVEL=4}
         end.
      end.
/*GUI*/ if global-beam-me-up then undo, leave.

   end.
/*GUI*/ if global-beam-me-up then undo, leave.

end.

/* Set up the external taxes. */
PROCEDURE ExternalTax:
   define variable amt_taxed as decimal no-undo.
   define variable l_taxenv like sod_tax_env no-undo.
   define variable l_taxc like sod_taxc no-undo.
   define variable ext_tax as logical no-undo.
   define variable err_status as integer no-undo.

   /* Setup the sod_det tax details to match the imported tax type */
   /* Make assignment based on logistics application */
   {gprunmo.i &module = "LG"
              &program = "lgtaxenv.p"
              &param = """(input so_mstr.so_app_owner, output ext_tax,
                           output l_taxenv, output l_taxc)"""}

   /* If External Taxes are enabled then set up taxes */
   if ext_tax = yes then do:
      /* Setup the so_mstr tax details to match the tax type */
      assign
         so_mstr.so_tax_usage = ""
         so_tax_env = l_taxenv
         so_taxc = l_taxc
         so_tax_usage = "".

      /* Delete any existing tx2d_dets for this trailer */
      /* Line 99999 is used by tx2d_det to indicate taxes */
      /* Assign to the trailer charges */
      for each tx2d_det where tx2d_ref = so_nbr and
            tx2d_nbr = "" and tx2d_line = 99999 and
            tx2d_tr_type = "13" exclusive-lock:
         delete tx2d_det.
      end.
      for each tx2d_det where tx2d_ref = so_nbr and
            tx2d_nbr = "" and tx2d_line = 99999 and
            tx2d_tr_type = "11" exclusive-lock:
         delete tx2d_det.
      end.

      /* FOR EACH TAX LINE IN THE IMPORT, CREATE A TX2D_DET RECORD. */
      /* TAXES ON LINE CHARGES ARE SUMMED HERE, SINCE LINE CHARGES */
      /* ARE ALSO SUMMED TO THE TRAILER CHARGES. */
      /* WHEN MFG/PRO HANDLES CHARGES PER LINE, MOVE LINE CHARGES TO */
      /* SOIVMTA2.P */
      for each lgitx_lgdet no-lock:
         /* Get the Tax Code (tx2_tax_code) for use */
         /* In the tx2d records */
         if so_trl1_cd = lgitx_tx2d_trl then
            amt_taxed = so_trl1_amt.
         else
         if so_trl2_cd = lgitx_tx2d_trl then
            amt_taxed = so_trl2_amt.
         else
         if so_trl3_cd = lgitx_tx2d_trl then
            amt_taxed = so_trl3_amt.
         else next.
         for first lgit_lgdet where lgit_so_trl_cd = lgitx_tx2d_trl
               no-lock:
            if lgit_sod_tax_usage <> "" then
               so_tax_usage = lgit_sod_tax_usage.
            for first lgi_lgmstr no-lock:
            end.
            {gprunmo.i &module="LG"
                  &program ="lgwrtx2d.p"
                  &param="""(
                    input '13',
                    input so_nbr,
                    input '',
                    input 99999,
                    input lgitx_tx2d_trl,
                    input amt_taxed,
                    input lgitx_tx2d_cur_tax_amt,
                    input lgitx_tx2d_tax_type,
                    input lgit_sod_tax_usage,
                    input lgi_app_id,
                    input so_due_date,
                    output err_status
                    )"""}
         end.
      end.
   end.
END PROCEDURE.


PROCEDURE container_line_charge_calc:
   /* PROCEDURE TO CALCULATE AND PRINT CONTAINER AND LINE */
   /* CHARGES ON THE INVOICE OUTPUT.                               */
   define input parameter so_recid as recid no-undo.
   define variable tmp_line_charge as decimal no-undo.

   for first so_mstr no-lock where
      recid(so_mstr) = so_recid.
   end.

   for each sod_det no-lock where
      sod_nbr = so_nbr:

      if using_line_charges then do:
         tmp_line_charge = 0.

         if sod_qty_inv <> 0 then do:

            for first absl_det no-lock where
               absl_abs_shipfrom = sod_site  and
               absl_order = so_nbr           and
               absl_ord_line = sod_line      and
               absl_confirmed                and
               absl_inv_post = no:
            end.  /*FOR FIRST ABSL_DET*/

            if available absl_det then do:

               for each absl_det where
                  absl_abs_shipfrom = sod_site  and
                  absl_order = so_nbr           and
                  absl_ord_line = sod_line      and
                  absl_inv_post = no            and
                  absl_confirmed
               no-lock:
                  vLinePrice = absl_ext_price.
                  accumulate vLinePrice (total).
                  tmp_line_charge = accum total vLinePrice.
               end. /* FOR EACH absl_det */

            end. /* IF AVAILABLE ABSL_DET */

            else do:

               for each sodlc_det where
                  sodlc_order = so_nbr          and
                  sodlc_ord_line = sod_line
               no-lock:
                  if sodlc_one_time and sodlc_times_charged > 0 then
                     next.
                  vLinePrice = sodlc_ext_price.
                  accumulate vLinePrice (total).
                  tmp_line_charge = accum total vLinePrice.
               end. /* FOR EACH sodlc_det*/

            end. /* ELSE DO*/

            /* CALCULATE TOTAL LINE CHARGES */
            tot_line_charges = tot_line_charges + tmp_line_charge.

         end. /* IF sod_qty_inv <> 0 */

      end. /* IF using_line_charges */

      if using_container_charges then do:
         tmp_tot_cont_charge = 0.

         for each abscc_det where
            abscc_order = sod_nbr      and
            abscc_ord_line = sod_line  and
            abscc_inv_post = no
         no-lock:
            tmp_tot_cont_charge = abscc_cont_price * abscc_qty.
            tot_cont_charges = tot_cont_charges + tmp_tot_cont_charge.
         end. /*FOR EACH abscc_DET*/

      end. /*IF using_container_charges*/

   end. /* FOR EACH SOD_DET */

END PROCEDURE.
