/* sosorp10.p  -  SALES ORDER INVOICE PRINT                                   */
/*V8:ConvertMode=Report                                                       */
/******************************************************************************/

{mfdtitle.i "8.6"}
{cxcustom.i "SOSORP10.P"}

define new shared variable nbr  like so_nbr.
define new shared variable nbr1 like so_nbr.
define new shared variable inv_only like mfc_logical initial YES
   label "Print Only Lines to Invoice".
define new shared variable print_lotserials like mfc_logical initial no
   label "Print Lot/Serial Numbers Shipped".
define new shared variable comp_addr like soc_company.
define new shared variable msg like msg_desc.
define new shared variable inv_date like so_inv_date initial today.
define new shared variable company as character format "x(38)" extent 6.
define new shared variable shipdate  like so_ship_date.
define new shared variable shipdate1 like shipdate.
define new shared variable addr as character format "x(38)" extent 6.
define new shared variable print_options like mfc_logical initial no
   label "Print Features and Options".
define new shared variable lang  like so_lang.
define new shared variable lang1 like lang.
define new shared variable next_inv_nbr like soc_inv.
define new shared variable next_inv_pre like soc_inv_pre.
define new shared variable cust  like so_cust.
define new shared variable cust1 like so_cust.
define new shared variable bill  like so_bill.
define new shared variable bill1 like so_bill.
define new shared variable conso like mfc_logical initial no
   label "Consolidate Invoices".
define new shared variable incinv like mfc_logical initial yes
   label "Include Debit Invoices".
define new shared variable incmemo like mfc_logical initial yes
   label "Include Credit Invoices".
define new shared variable max_lines  as integer.
define new shared variable body_count as integer.
define new shared variable undo_nota like mfc_logical.
define new shared variable order_nbrs     as character extent 30.
define new shared variable order_nbr_list as character no-undo.
define new shared variable disc_det_key like lngd_key1 initial "1".
define new shared variable disc_sum_key  like lngd_key1 initial "1".
define new shared variable call-detail like mfc_logical
   label "Print Call Invoice Detail"   initial no.

define variable form_code as character format "x(2)" label "Form Code" no-undo.
define variable run_file  as character format "x(12)" no-undo.
define variable c-lngd-dataset like lngd_det.lngd_dataset
   initial "soprint.p" no-undo.
define variable yn like mfc_logical initial yes no-undo.
define variable disc_det like lngd_translation label "Discount Detail" no-undo.
define variable disc_sum like disc_det         label "Discount Summary" no-undo.
define variable lgData as logical no-undo initial no.
define variable prt_width as integer no-undo.

/*roger*/ DEFINE new shared VARIABL np_fp AS LOGICAL FORMAT "NP/FP" LABEL "未定价/定价（NP/FP）" .

{etvar.i &new="new"}

/* DEFINE VARIABLES FOR DISPLAY OF VAT REG NO & COUNTRY CODE */
{gpvtecdf.i &var="new shared"}

FORM
   nbr                 colon 15
   nbr1             label "To" colon 49 skip
   shipdate         colon 15
   shipdate1        label "To" colon 49 skip
   cust             colon 15
   cust1            label "To" colon 49 skip
   bill             colon 15
   bill1            label "To" colon 49 skip
   lang             colon 15
   lang1            label "To" colon 49
   skip(1)
   inv_date         colon 35
   incinv           colon 72 skip
   inv_only         colon 35
   incmemo          colon 72 skip
   print_lotserials colon 35
   call-detail      colon 72
   print_options    colon 35
/*roger*/            np_fp        colon 72 skip
   conso            colon 35 skip
   comp_addr        colon 35 skip
   form_code        colon 35 deblank skip
   disc_det         colon 35
   disc_sum         colon 35 skip
   space(1)
   msg
   skip
with frame a side-labels width 80.
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{&SOSORP10-P-TAG2}

find first lngd_det where
       lngd_dataset = c-lngd-dataset
   and lngd_field   = "det_disc_prnt"
   and lngd_lang    = global_user_lang
   and lngd_key1    = disc_det_key
no-lock no-error.
if available lngd_det then
   disc_det = lngd_translation.
else
   disc_det = "".

find first lngd_det where lngd_dataset = c-lngd-dataset
   and lngd_field   = "det_disc_prnt"
   and lngd_lang    = global_user_lang
   and lngd_key1    = disc_sum_key
no-lock no-error.
if available lngd_det then
   disc_sum = lngd_translation.
else
   disc_sum = "".

/* See if Logistics is running this session. */
/* If so, don't update from the screen. */
{gprun.i ""mgisact.p"" "(input 'lgarinv', output lgData)"}

repeat:

   if inv_date = ? then inv_date = today.
   if nbr1 = hi_char then nbr1 = "".
   if lang1 = hi_char then lang1 = "".
   if shipdate = low_date then shipdate = ?.
   if shipdate1 = hi_date then shipdate1 = ?.
   if cust1 = hi_char then cust1 = "".
   if bill1 = hi_char then bill1 = "".
   if form_code = "" then form_code = "1".

   if comp_addr = "" then do:
      find first soc_ctrl no-lock.
      comp_addr = soc_comp.
      inv_only = soc_ln_inv.
   end.

   assign company = "".

   if not lgData then do:
      {&SOSORP10-P-TAG3}
      update
         nbr nbr1
         shipdate shipdate1
         cust cust1
         bill bill1
         lang lang1
         inv_date
         inv_only
         print_lotserials
         print_options
         conso
         comp_addr
         form_code
         disc_det
         disc_sum
         incinv
         incmemo
         call-detail
         np_fp
         msg
      with frame a
      editing:
         {&SOSORP10-P-TAG4}
         if frame-field = "disc_det" then do:
            {mfnp05.i lngd_det lngd_trans
               "lngd_dataset   = c-lngd-dataset
                  and lngd_field  = 'det_disc_prnt'
                  and lngd_lang   = global_user_lang"
               lngd_translation "input disc_det" }
            if recno <> ? then
            display lngd_translation @ disc_det
            with frame a.
         end.
         else if frame-field = "disc_sum" then do:
            {mfnp05.i lngd_det lngd_trans
               "lngd_dataset   = c-lngd-dataset
                  and lngd_field  = 'det_disc_prnt'
                  and lngd_lang   = global_user_lang"
               lngd_translation "input disc_sum" }
            if recno <> ? then display lngd_translation @ disc_sum
            with frame a.
         end.
         else do:
            status input.
            readkey.
            apply lastkey.
         end.

      end. /* editing */

   end. /* if not lgData */

   else do:
      /* Tell logistics the order numbers that are processed here */
      {gprunmo.i &module="LG" &program = "lgsetso.p"}
   end.

   run p_mfquote.

   /* Add this do loop so the converter won't create an 'on leave' */
   do:
      {&SOSORP10-P-TAG5}

      /* Validate discount print options */
      find first lngd_det where lngd_dataset     = c-lngd-dataset
         and lngd_field       = "det_disc_prnt"
         and lngd_lang        = global_user_lang
         and lngd_translation = disc_det
      no-lock no-error.
      if not available lngd_det then do:
         /* INVALID OPTION */
         {pxmsg.i &MSGNUM=712 &ERRORLEVEL=3 &MSGARG1=disc_det}
         {gprun.i ""gpmsgls1.p""
            "(6928, c-lngd-dataset, 'det_disc_prnt', global_user_lang )"}
         next-prompt disc_det with frame a.
         undo, retry.
      end.
      disc_det_key = lngd_key1.

      find first lngd_det where lngd_dataset     = c-lngd-dataset
         and lngd_field       = "det_disc_prnt"
         and lngd_lang        = global_user_lang
         and lngd_translation = disc_sum
      no-lock no-error.
      if not available lngd_det then do:
         /* INVALID OPTION */
         {pxmsg.i &MSGNUM=712 &ERRORLEVEL=3 &MSGARG1=disc_sum}
         {gprun.i ""gpmsgls1.p""
            "(6928, c-lngd-dataset, 'det_disc_prnt', global_user_lang )"}
         next-prompt disc_sum with frame a.
         undo, retry.
      end.
      disc_sum_key = lngd_key1.

      if not incinv and not incmemo then do:
         {pxmsg.i &MSGNUM=1614 &ERRORLEVEL=3}
         /* SELECTION CRITERIA RESULTS IN NO DATA TO REPORT */
         next-prompt incinv with frame a.
         undo, retry.
      end.

      if inv_date = ? then do:
         {pxmsg.i &MSGNUM=27 &ERRORLEVEL=3} /* INVALID DATE */
         next-prompt inv_date with frame a.
         undo, retry.
      end.

      if lookup(form_code,"1,11") = 0 then do:
         {pxmsg.i &MSGNUM=129 &ERRORLEVEL=3} /* FORM CODE NOT INSTALLED */
         next-prompt form_code with frame a.
         undo, retry.
      end.

      if comp_addr <> "" then do:

         find ad_mstr where ad_domain = global_domain and ad_addr = comp_addr no-lock no-error.

         if available ad_mstr then do:

            find ls_mstr where ls_domain = global_domain and ls_addr = ad_addr and ls_type = "company"
            no-lock no-error.

            if not available ls_mstr then do:
               {pxmsg.i &MSGNUM=28 &ERRORLEVEL=3} /* NOT A VALID COMPANY */
               next-prompt comp_addr with frame a.
               undo , retry.
            end.

            assign
               addr[1] = ad_name
               addr[2] = ad_line1
               addr[3] = ad_line2
               addr[4] = ad_line3
               addr[6] = ad_country.

            {mfcsz.i addr[5] ad_city ad_state ad_zip}.
            {gprun.i ""gpaddr.p"" }

            assign
               company[1] = addr[1]
               company[2] = addr[2]
               company[3] = addr[3]
               company[4] = addr[4]
               company[5] = addr[5]
               company[6] = addr[6].

            {gpvtecrg.i}  /* FIND VAT REG NO & COUNTRY CODE */

         end.

         else do:
            {pxmsg.i &MSGNUM=28 &ERRORLEVEL=3} /* NOT A VALID COMPANY */
            next-prompt comp_addr with frame a.
            undo, retry.
         end.

      end. /* if comp_addr <> "" */

   end.

   if form_code = "11" or et_ctrl.et_print_dc
      {&SOSORP10-P-TAG6}
   then
      prt_width = 132.
   else
      prt_width = 80.

   if not lgData then do:
      /* OUTPUT DESTINATION SELECTION */
      {gpselout.i &printType = "printer" &printWidth = prt_width
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

   mainloop:
   do transaction on error undo, leave on endkey undo, leave:

      {gprun.i ""sorp10a.p"" }
      {&SOSORP10-P-TAG7}

      find first soc_ctrl no-lock.
      next_inv_nbr = soc_inv - 1.
/*roger      next_inv_pre = soc_inv_pre.*/
/*roger*/ IF np_fp THEN next_inv_pre = "NP".
/*roger*/ ELSE next_inv_pre = "FP".
      {&SOSORP10-P-TAG8}

      /*RUN SELECTED FORMAT */
      undo_nota = no.

      {gprfile.i}
      if lgData then run_file = "01".

      if false then do:
/*roger*/         {gprun.i ""xxsorp1001.p""}
         {gprun.i ""sorp1011.p""}
      end.

      {&SOSORP10-P-TAG9}
/*roger*/      {gprun.i " ""xxsorp10"" + run_file + "".p"" "}
      {&SOSORP10-P-TAG10}

      {mfreset.i}
/*GUI* {mfgrptrm.i}  *Report-to-Window*/


      if undo_nota then do:
         /* ERROR: Invoice has # lines. # lines allowed. */
         {pxmsg.i &MSGNUM=1922 &ERRORLEVEL=4
                  &MSGARG1=body_count
                  &MSGARG2=max_lines}
         batchrun = yes.
      end.
/*
      if not batchrun then do:
         yn = yes.
         /* UPDATE INVOICES? */
         {pxmsg.i &MSGNUM=602 &ERRORLEVEL=1 &CONFIRM=yn}
         if not yn then undo mainloop, leave.
      end.
*/
      /* If the print run is accepted, update the control file */
      {gprun.i ""sorp10b.p"" }

   end. /* mainloop: do transaction */

   /* If Logistics is processing, there is no one at the screen. */
   /* We need to exit here. */
   if lgData then leave.

end.

PROCEDURE p_mfquote:
   bcdparm = "".
   {mfquoter.i nbr}
   {mfquoter.i nbr1}
   {mfquoter.i shipdate}
   {mfquoter.i shipdate1}
   {mfquoter.i cust     }
   {mfquoter.i cust1    }
   {mfquoter.i bill     }
   {mfquoter.i bill1    }
   {mfquoter.i lang   }
   {mfquoter.i lang1  }
   {mfquoter.i inv_date}
   {mfquoter.i inv_only}
   {mfquoter.i print_lotserials}
   {mfquoter.i print_options }
/*roger*/   {mfquoter.i np_fp }
   {mfquoter.i conso    }
   {mfquoter.i comp_addr}
   {mfquoter.i form_code}
   {mfquoter.i disc_det  }
   {mfquoter.i disc_sum  }
   {mfquoter.i incinv}
   {mfquoter.i incmemo}
   {mfquoter.i call-detail}
   {&SOSORP10-P-TAG11}
   {mfquoter.i msg}
END PROCEDURE.
