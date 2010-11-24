/* xxsoivpst.p - POST INVOICES TO AR AND GL REPORT                           */
/* REVISION: 1.0      LAST MODIFIED: 09/25/10   BY: zy                       */
/*-Revision end--------------------------------------------------------------*/
{mfdtitle.i "100915.1"}
{cxcustom.i "XXSOIVPST.P"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE soivpst_p_1 "GL Consolidated or Detail"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivpst_p_2 "GL Effective Date"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{gldydef.i new}
{gldynrm.i new}

{soivpst.i "new shared"} /* variable definition moved include file */
{fsdeclr.i new}

{etvar.i &new="new"}
{etdcrvar.i "new"}
{etrpvar.i &new="new"}

define new shared variable prog_name as character
   initial "soivpst.p" no-undo.

define variable l_increment   like mfc_logical      no-undo.
define variable l_cur_tax_amt like tx2d_cur_tax_amt no-undo.
define variable l_po_schd_nbr like sod_contr_id     no-undo.

/* CUSTOMIZED SECTION FOR VERTEX BEGIN */
define variable l_vtx_message   like mfc_logical initial no no-undo.
define variable l_cont          like mfc_logical initial no no-undo.
define variable l_api_handle      as handle                 no-undo.
define variable l_vq_reg_db_open  as logical     initial no no-undo.
define variable result-status     as integer                no-undo.
/* CUSTOMIZED SECTION FOR VERTEX END */

{&SOIVPST-P-TAG8}

/* THE TEMP-TABLE WORK_TRNBR STORES THE VALUES OF FIRST AND LAST  */
/* TRANSACTION NUMBER WHICH IS USED WHEN INVOICE IS POSTED VIA    */
/* SHIPPER CONFIRM, FOR ASSIGNING THE TR_RMRKS AND TR_GL_DATE     */
/* FIELDS. PREVIOUSLY, THIS WAS BEING DONE IN RCSOISB1.P PRIOR TO */
/* INVOICE POST. THIS TEMP-TABLE IS HOWEVER NOT USED BY SOIVPST.P */
/* AND HAS BEEN DEFINED HERE SINCE SOIVPSTA.P, WHICH IS SHARED    */
/* BETWEEN RCSOIS.P AND SOIVPST.P USES IT.                        */

define new shared temp-table work_trnbr no-undo
   field work_sod_nbr  like sod_nbr
   field work_sod_line like sod_line

   field work_tr_recid  like tr_trnbr
   index work_sod_nbr work_sod_nbr ascending.

/* This flag will indicate that Logistics is running Post */

define new shared variable lgData as logical no-undo initial no.
/* DEFINE VARIABLES USED IN GPGLEF1.P (GL CALENDAR VALIDATION) */
{gpglefv.i}

post = yes.

{&SOIVPST-P-TAG1}
{&SOIVPST-P-TAG9}
form
   inv                  colon 15
   inv1                 label {t001.i} colon 49 skip
   cust                 colon 15
   cust1                label {t001.i} colon 49 skip
   bill                 colon 15
   bill1                label {t001.i} colon 49 skip(1)
   eff_date             colon 33 label {&soivpst_p_2} skip
   gl_sum               colon 33 label {&soivpst_p_1} skip
   print_lotserials     colon 33

with frame a width 80 side-labels.
{&SOIVPST-P-TAG10}
{&SOIVPST-P-TAG2}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* CUSTOMIZED SECTION FOR VERTEX BEGIN */
/* RUN vqregopn.p TO SEE IF VERTEX SUTI API IS RUNNING, */
/* AND THEN OPEN REGISTER DB                            */

/* TRY AND FIND VERTEX TAX API'S PROCEDURE HANDLE. */
{gpfindph.i vqapi l_api_handle}

/* IF THERE IS NO PROCEDURE HANDLE WE ARE DONE. */
if l_api_handle <> ?
then do:

   {gprun.i ""vqregopn.p"" "(output result-status)"}

   if result-status = 0
   then
      l_vq_reg_db_open = yes.

   if  result-status <> 0
   and not batchrun
   then do:

      /* INVOICES WILL POST TO MFG/PRO BUT NOT UPDATE THE VERTEX REGISTER */
      {pxmsg.i &MSGNUM=8880 &ERRORLEVEL=1}

      /* CONTINUE WITH INVOICE POST? */
      {pxmsg.i &MSGNUM=8881 &ERRORLEVEL=1 &CONFIRM=l_cont}
      if  l_cont = no
      then
         undo, return no-apply.

   end. /* IF  result-status <> 0... */

   if result-status <> 0
   then
      l_vtx_message = yes.

end. /* IF l_api_handle */
/* CUSTOMIZED SECTION FOR VERTEX END  */

/* Is Logistics running this program? */
{gprun.i ""mgisact.p"" "(input 'lgarinv', output lgData)"}
do transaction:

   insbase = no.

   for first svc_ctrl
         fields( svc_domain svc_isb_bom svc_pt_mstr svc_ship_isb)
          where svc_ctrl.svc_domain = global_domain no-lock :
   end.

   /* SVC_WARR_SVCODE IS THE WARRANTY SERVICE TYPE FOR RMA'S, */
   /* NOT A DEFAULT WARRANTY TYPE.                            */

   /* WITH THE 8.5 RELEASE, LOADING THE STANDARD BOM CONTENTS */
   /* INTO THE INSTALLED BASE IS NO LONGER AN OPTION.  THIS   */
   /* DECISION WAS MADE TO PREVENT SERIALIZED ITEMS FROM      */
   /* GETTING INTO THE ISB WITHOUT SERIAL NUMBERS, AND ENSURE */
   /* THERE ARE NO ADVERSE IMPACTS TO THE COMPLIANCE SERIAL   */
   /* NUMBERING REQUIREMENTS.                                 */
   if available svc_ctrl then
   assign

      serialsp = "S"       /* ALL SERIALS SHOULD LOAD */
      nsusebom = no
      usebom   = svc_isb_bom
      needitem = svc_pt_mstr

      insbase  = svc_ship_isb.

end.

main:
repeat:

   assign
      expcount = 999
      pageno   = 0.

   if eff_date = ? then eff_date = today.
   if inv1 = hi_char then inv1 = "".
   if cust1 = hi_char then cust1 = "".
   if bill1 = hi_char then bill1 = "".
   {&SOIVPST-P-TAG11}

   if not lgData then do:
      {&SOIVPST-P-TAG3}
      update
         inv inv1
     {&SOIVPST-P-TAG12}
         cust cust1 bill bill1
         eff_date gl_sum print_lotserials
      with frame a.
      {&SOIVPST-P-TAG4}
   end.
   else do:
      /* Get the invoice number from Logistics */
      {gprun.i ""lgsetinv.p"" "(output inv)"}
      inv1 = inv.
   end.

   if can-find(sbic_ctl
       where  sbic_domain = global_domain
       and    sbic_active = yes)
   then do:
       if can-find(soc_ctrl
           where  soc_domain = global_domain
           and    soc_ar     = no)
       then do:

          /* CANNOT EXECUTE INVOICE POST */
          {pxmsg.i &MSGNUM=6671 &ERRORLEVEL=4}

          /* SELF BILLING ENABLED. INTEGRATE WITH AR IN SO  */
          /* CTRL MUST BE 'YES'                             */
          {pxmsg.i &MSGNUM=6672 &ERRORLEVEL=1}

          next main.
       end.  /* IF CAN-FIND(soc_ctrl) */
   end.  /* IF CAN-FIND(sbic_ctl) */


   /* VALIDATE OPEN GL PERIOD FOR PRIMARY ENTITY - GIVE
    * A WARNING IF THE PRIMARY ENTITY IS CLOSED. WE DON'T
    * WANT A HARD ERROR BECAUSE WHAT REALLY MATTERS IS
    * THE ENTITY SO_SITE OF EACH SO_SITE (WHICH IS VALIDATED
    * IN SOIVPST1.P. BUT WE AT LEAST WANT A WARNING MESSAGE
    * IN CASE, FOR EXAMPLE, THEY ACCIDENTALLY ENTERED
    * THE WRONG EFFECTIVE DATE */

   /* VALIDATE OPEN GL PERIOD FOR SPECIFIED ENTITY */
   {gprun.i ""gpglef1.p""
      "( input  ""SO"",
                      input  glentity,
                      input  eff_date,
                      output gpglef_result,
                      output gpglef_msg_nbr
                    )" }

   if gpglef_result > 0 then do:
      /* IF PERIOD CLOSED THEN WARNING ONLY */
      if gpglef_result = 2 then do:
         {pxmsg.i &MSGNUM=3005 &ERRORLEVEL=2}
      end.
      /* OTHERWISE REGULAR ERROR MESSAGE */
      else do:
         {pxmsg.i &MSGNUM=gpglef_msg_nbr &ERRORLEVEL=4}
         next-prompt eff_date with frame a.
         undo, retry.
      end.
   end.

   bcdparm = "".

   {mfquoter.i inv      }
   {mfquoter.i inv1     }
   {&SOIVPST-P-TAG13}
   {mfquoter.i cust     }
   {mfquoter.i cust1    }
   {mfquoter.i bill     }
   {mfquoter.i bill1    }
   {&SOIVPST-P-TAG5}
   {mfquoter.i eff_date }
   {&SOIVPST-P-TAG16}
   {mfquoter.i gl_sum   }
   {mfquoter.i print_lotserials}
   {&SOIVPST-P-TAG6}

   if eff_date = ? then eff_date = today.
   if inv1 = "" then inv1 = hi_char.
   if cust1 = "" then cust1 = hi_char.
   if bill1 = "" then bill1 = hi_char.
   {&SOIVPST-P-TAG14}

   if not lgData then do:
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
   end.


   /* If we are runing under dos then the second print file for  */

   if insbase then do:
      {gpfildel.i &filename=global_userid + "".isb""}
      output stream prt2  to value(global_userid + ".isb").
   end.

   l_increment = no.

/*zy*/ /*发票过账前将so尾信息记录在 so__chr06 */   
/*zy*/   for each so_mstr exclusive-lock
/*zy*/       where so_mstr.so_domain = global_domain and  (so_inv_nbr >= inv
/*zy*/      and    so_inv_nbr <= inv1)
/*zy*/      {&SOIVPST-P-TAG15}
/*zy*/      and   (so_invoiced = yes)
/*zy*/      and   (so_cust >= cust
/*zy*/      and    so_cust <= cust1)
/*zy*/      and   (so_bill >= bill
/*zy*/      and    so_bill <= bill1)
/*zy*/      and   (so_to_inv = no)
/*zy*/      use-index so_invoice:
/*zy*/       assign so__chr06 = string(so_trl1_amt) + ";"
/*zy*/                        + string(so_trl2_amt) + ";"
/*zy*/                        + string(so_trl3_amt).
/*zy*/   end.

   so_mstr-loop:

   for each so_mstr no-lock
       where so_mstr.so_domain = global_domain and  (so_inv_nbr >= inv
      and    so_inv_nbr <= inv1)
      {&SOIVPST-P-TAG15}
      and   (so_invoiced = yes)
      and   (so_cust >= cust
      and    so_cust <= cust1)
      and   (so_bill >= bill
      and    so_bill <= bill1)
      and   (so_to_inv = no)
      use-index so_invoice:

      for each sod_det
         fields(sod_domain  sod_list_pr  sod_nbr    sod_price
                sod_qty_inv sod_disc_pct sod_ln_ref sod_contr_id
                sod_line    sod_site)
          where sod_det.sod_domain = global_domain and  sod_nbr = so_nbr
          no-lock:

         if so_sched
         then
            l_po_schd_nbr = sod_contr_id.
         else
            l_po_schd_nbr = "".

         if (sod_price * sod_qty_inv) <> 0
            or sod_disc_pct           <> 0
         then do:
            l_increment = yes .
            leave so_mstr-loop.
         end. /* THEN DO */

         if can-find(first absl_det
                        where absl_det.absl_domain  =  global_domain
                        and   absl_order            = sod_nbr
                        and   absl_ord_line         = sod_line
                        and   absl_abs_shipfrom     = sod_site
                        and   absl_confirmed        = yes
                        and   absl_inv_nbr          = so_inv_nbr
                        and   absl_inv_post         = no
                        and   absl_lc_amt           <> 0 )
         then do:
            l_increment = yes.
            leave so_mstr-loop.

         end. /* IF CAN-FIND(FIRST absl_det ... */

         for each sodlc_det
            fields (sodlc_det.sodlc_domain sodlc_order
                    sodlc_ord_line         sodlc_one_time
                    sodlc_times_charged    sodlc_lc_amt)
            where sodlc_det.sodlc_domain = global_domain
            and   sodlc_order            = sod_nbr
            and   sodlc_ord_line         = sod_line
            and   sodlc_lc_amt           <> 0
         no-lock:
            if    (sodlc_one_time      = no
               or (sodlc_one_time      = yes
               and sodlc_times_charged <= 1 ))
               and sod_qty_inv         <> 0
            then do:

               l_increment = yes.
               leave so_mstr-loop.

            end. /* IF (sodlc_one_time = no .... */

         end. /* FOR EACH sodlc_det */

         if can-find(first abscc_det
                        where abscc_det.abscc_domain  =  global_domain
                        and   abscc_order             = sod_nbr
                        and   abscc_ord_line          = sod_line
                        and   abscc_abs_shipfrom      = sod_site
                        and   abscc_confirmed         = yes
                        and   abscc_inv_nbr           = so_inv_nbr
                        and   abscc_inv_post          = no
                        and   abscc_cont_price        <> 0 )
         then do:
            l_increment = yes.
            leave so_mstr-loop.

         end. /* IF CAN-FIND(FIRST abscc_det ... */

      end. /* FOR EACH sod_det */

      /* TO ACCUMULATE TAX AMOUNTS OF SHIPPED SO ONLY ('13'/'14'type) */
      for each tx2d_det
         fields( tx2d_domain tx2d_cur_tax_amt tx2d_ref tx2d_tr_type)
          where tx2d_det.tx2d_domain = global_domain and (  tx2d_ref         =
          so_nbr
         and   (tx2d_tr_type    = '13'
                or tx2d_tr_type = '14')
         ) no-lock:
         l_cur_tax_amt = l_cur_tax_amt + absolute(tx2d_cur_tax_amt).
      end. /* FOR EACH tx2d_det */

      if (absolute(so_trl1_amt) + absolute(so_trl2_amt) +
          absolute(so_trl3_amt) + l_cur_tax_amt) <> 0
      then do:
         l_increment = yes.
         leave so_mstr-loop.
      end. /* IF ABSOLUTE(so_trl1_amt) + ... */

   end. /* FOR EACH SO_MSTR */

   if l_increment then
   do transaction on error undo, retry:
      /* Create Journal Reference */

      {gprun.i ""sonsogl.p"" "(input eff_date)"}
   end.
   else do:
      run p_getbatch.
      ref   = "".
   end. /* ELSE DO */

   mainloop:
   do on error undo, leave:

      {mfphead.i}
      {&SOIVPST-P-TAG17}


      {gprun.i ""xxsoivpst1.p""
               "(input ?,
                 input l_po_schd_nbr)"}

      do transaction:
         find ba_mstr  where ba_mstr.ba_domain = global_domain and  ba_batch =
         batch and ba_module = "SO"
            exclusive-lock no-error.
         if available ba_mstr then do:
            ba_total  = ba_total + batch_tot.
            ba_ctrl   = ba_total.
            ba_userid = global_userid.
            ba_date   = today.
            batch_tot = 0.
            ba_status = " ". /*balanced*/
         end.
      end.

      /* Reset second print file */
      if insbase then do:
         put stream prt2 " ".
         output stream prt2 close.
      end.

      /* CUSTOMIZED SECTION FOR VERTEX BEGIN */
      if l_vtx_message
      then do:

         /* DISPLAY A MESSAGE IN THE AUDIT TRAIL */

         /* API FUNCTION FAILURE. VERTEX REGISTER DB DID NOT UPDATE. */
         {pxmsg.i &MSGNUM=8882 &ERRORLEVEL=1}

         /* VERIFY THE DATA IN THE VERTEX REGISTER. */
         {pxmsg.i &MSGNUM=8883 &ERRORLEVEL=1}

      end. /* IF l_vtx_message */
      /*  CUSTOMIZED SECTION FOR VERTEX ENDS */

      /* REPORT TRAILER */
      {mfrtrail.i}
      {&SOIVPST-P-TAG7}
   end. /* mainloop */

   if lgData then leave.
end.

/* CUSTOMIZED SECTION FOR VERTEX BEGIN */
/* CHECK IF VERTEX REGISTER DBF WAS OPENED */
if l_vq_reg_db_open
then do:
   {gprun.i ""vqregcls.p""}
end. /* IF l_vq_reg_db_open */
/*  CUSTOMIZED SECTION FOR VERTEX ENDS */

procedure p_getbatch:
/*--------------------------------------------------------------------
  Purpose: Get next AR batch number
---------------------------------------------------------------------*/

   if can-find(first soc_ctrl
      where soc_domain = global_domain
      and   soc_ar     = yes)
   then do:
      {mfnctrl.i "arc_ctrl.arc_domain = global_domain"
       "arc_ctrl.arc_domain" "ar_mstr.ar_domain = global_domain"
        arc_ctrl arc_batch ar_mstr ar_batch batch}

      if not can-find(first ba_mstr
         where ba_domain = global_domain
         and ba_batch = batch
         and ba_module = "SO")
      then do:
         create ba_mstr.
         assign
            ba_domain = global_domain
            ba_batch = batch
            ba_module = "SO"
            ba_doc_type = "I"
            ba_status = "NU" /*not used*/.
      end. /* IF NOT CAN-FIND(FIRST ba_mstr */
   end. /* IF CAN-FIND(FIRST soc_ctrl.. */
END PROCEDURE. /* p_getbatch */
