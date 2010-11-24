/* xxadsfmt.p - SHIP from MAINTENANCE                                        */
/* Copyright softspeed Inc., GuangZhou, GD, CHA.                             */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.51 $                                                         */
/* $Revision: 1.51 $   BY: zy       DATE: 09/10/10 ECO: *ACS004*             */

/*-Revision end--------------------------------------------------------------*/

/*****************************************************************************/
/* All patch markers and commented out code have been removed from the source*/
/* code below. For all future modifications to this file, any code which is  */
/* no longer required should be deleted and no in-line patch markers should  */
/* be added.  The ECO marker should only be included in the Revision History.*/
/*****************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "100917.1"}
{pxmaint.i}
{cxcustom.i "XXADSFMT.P"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE adstmt_p_3 "Code"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/* ************************** Function  *********************** */

define variable del-yn like mfc_logical.
define variable name like ad_name.
define variable yn like mfc_logical initial yes.
define variable shiptocode like ad_addr.
define new shared variable tax_recno as recid.
define variable delete_lsmstr like mfc_logical no-undo.
define variable adnbr like ad_addr.
define new shared variable undo_adtaxmt as logical.
define variable  l_adnbr    like ad_addr     no-undo.
define variable  l_err      like mfc_logical no-undo.
define variable  l_newrec   like mfc_logical no-undo.
define variable  l_batcherr like mfc_logical no-undo.
{&ADSTMT-P-TAG7}
define buffer admstr for ad_mstr.
define buffer lsmstr for ls_mstr.

/* VARIABLES FOR VAT REGISTRATION VALIDATION */
{gpvtevdf.i "new shared"}

{pxsevcon.i}

/* Variable to handle delete through CIM */
define variable batchdelete as character format "x(1)" no-undo.

/*MAIN-BEGIN*/
/* DISPLAY SELECTION FORM */
form
   skip
   vd_addr        colon 10
   ad_name        colon 10
   ad_county      colon 48
   ad_line1       colon 10
   ad_state       colon 48
   ad_ctry no-labels
   ad_line2       colon 10
   ad_country     colon 48
   ad_city        colon 10
   ad_zip         colon 48
   ad_format
with frame a title color normal (getFrameTitle("SUPPLIER_ADDRESS",24))
   side-labels
   width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{&ADSTMT-P-TAG1}
form
   skip
   adnbr          colon 10 label {&adstmt_p_3}
   ad_temp
   ad_name        colon 10
   ad_line1       colon 10
   ad_line2       colon 10
   ad_line3       colon 10
   ad_city        colon 10
   ad_state
   ad_zip         colon 54
   ad_format
   ad_country     colon 10
   ad_ctry  no-labels
   ad_county      colon 54
   ad_attn        colon 10
   ad_attn2       label "[2]" colon 44
   ad_phone       colon 10
   ad_ext
   ad_phone2      label "[2]" colon 44
   ad_ext2
   ad_fax         colon 10
   ad_fax2        label "[2]" colon 44
   ad_lang
   ad_sort        colon 10
with frame b title color normal (getFrameTitle("SUPPLIER_SHIP-FROM",24))
   side-labels
   width 80 attr-space.
{&ADSTMT-P-TAG2}

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.
do transaction on error undo, retry:
   find first adc_ctrl  where adc_ctrl.adc_domain = global_domain no-lock
   no-error.
   if not available adc_ctrl then do:  create adc_ctrl. adc_ctrl.adc_domain =
   global_domain. end.
   if recid(adc_ctrl) = -1 then .
end. /* do transaction on error undo, retry: */

/* DISPLAY */
mainloop:
repeat:
   view frame a.
   view frame b.
   clear frame b no-pause.
   do transaction with frame a on endkey undo, leave mainloop:

      view frame a.
      view frame b.

      prompt-for vd_mstr.vd_addr
         editing:

         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i vd_mstr vd_addr  " vd_mstr.vd_domain = global_domain and
         vd_addr " vd_addr vd_addr vd_addr}
         if recno <> ? then do:
            find ad_mstr  where ad_mstr.ad_domain = global_domain and  ad_addr
            = vd_addr no-lock no-error.
            display vd_addr ad_name ad_line1 ad_line2 ad_city
               ad_state ad_ctry ad_county
               ad_country ad_zip ad_format.
         end. /* if recno <> ? then do: */
      end. /* editing: */
      if input vd_addr = " " then do:
         /* BLANK NOT ALLOWED */
         {pxmsg.i &MSGNUM=40 &ERRORLEVEL={&APP-ERROR-RESULT}}
         undo mainloop.
      end. /* if input vd_addr = " " then do: */
      assign global_addr = input vd_addr.
      find first vd_mstr no-lock where vd_addr = input vd_addr no-error.

      /* ADD/MOD/DELETE  */
/****100910*/
      {pxrun.i &PROC    = 'processRead' &PROGRAM = 'adadxr.p'
         &PARAM   = "(input vd_addr:SCREEN-VALUE,
                             buffer ad_mstr,
                             input yes,
                             input yes)"
         &NOAPPERROR = true
         &CATCHERROR = true
         }

      if return-value = {&SUCCESS-RESULT} then
      do:
         {pxrun.i &PROC    = 'processRead' &PROGRAM = 'adadxr.p'
            &PARAM   = "(input ad_addr,
                               buffer ad_mstr,
                               input yes,
                               input yes)"
            &NOAPPERROR = true
            &CATCHERROR = true
            }

      end. /* if return-value = {&SUCCESS-RESULT} processRead adadxr.p */
/*****100910****/
      if return-value <> {&SUCCESS-RESULT} then
      do:
         /* NOT A VALID CUSTOMER */
         {pxmsg.i &MSGNUM=2 &ERRORLEVEL={&APP-ERROR-RESULT}}
         undo, retry.
      end. /* if return-value <> {&SUCCESS-RESULT} processRead adcuxr.p */
      del-yn = no.
      recno = ?.
      if avail ad_mstr then do:
        display ad_name  ad_line1 ad_line2 ad_city
           ad_county ad_state ad_ctry
           ad_country ad_zip ad_format.
        name = ad_name.
      end.
 end.   /* END LOOP A  */

   loopb:
   repeat with frame b:

      if (not batchrun and
          keyfunction(lastkey) = "END-ERROR"
      or (batchrun and
          l_batcherr))
      and l_newrec             = yes
      then do:
         {pxrun.i &PROC    = 'processRead' &PROGRAM = 'adarxr.p'
                  &PARAM   = "(input adnbr:SCREEN-VALUE,
                               input 'shipfrom',
                               buffer ls_mstr,
                               input yes,
                               input yes)"
                  &NOAPPERROR = true
                  &CATCHERROR = true
         }

         {&ADSTMT-P-TAG5}
         {pxrun.i &PROC='processDelete' &PROGRAM='adarxr.p'
                  &PARAM="(buffer ls_mstr)"
         }
         {&ADSTMT-P-TAG6}
      end. /* IF NOT batchrun AND KEYFUNCTION(LASTKEY) = "END-ERROR" */

      {gpaud.i &uniq_num1 = 01 &uniq_num2 = 02}

      assign
         l_newrec    = no
         l_batcherr  = no
         global_addr = vd_addr.

      /* Initialize batchdelete variable */
      batchdelete = "".

      prompt-for adnbr
         /* Prompt for batchdelete only during CIM */
         batchdelete no-label when (batchrun)
         editing:

         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp01.i ad_mstr adnbr ad_addr ad_ref  " ad_mstr.ad_domain =
         global_domain and vd_addr "  ad_ref}

         if recno <> ? then do:
            display ad_addr @ adnbr ad_temp
               ad_name ad_line1 ad_line2 ad_line3 ad_city ad_county
               ad_state ad_country ad_ctry
               ad_zip ad_format ad_lang
               ad_attn ad_phone ad_ext ad_attn2 ad_phone2 ad_ext2
               ad_fax ad_fax2 ad_sort.
         end. /* if recno <> ? then do: */
      end. /* editing: */
      {pxrun.i &PROC    = 'validateShipToID' &PROGRAM = 'adstxr.p'
         &PARAM   = "(input adnbr:SCREEN-VALUE,
                             input vd_addr)"
         &NOAPPERROR = true
         &CATCHERROR = true
         }
      if return-value <> {&SUCCESS-RESULT} then
         undo loopb, retry.

      {pxrun.i &PROC    = 'processRead' &PROGRAM = 'adadxr.p'
         &PARAM   = "(input adnbr:SCREEN-VALUE,
                             buffer ad_mstr,
                             input no,
                             input no)"
         &NOAPPERROR = true
         &CATCHERROR = true
         }

      {pxrun.i &PROC    = 'processRead' &PROGRAM = 'adarxr.p'
         &PARAM   = "(input adnbr:SCREEN-VALUE,
                             input 'shipfrom',
                             buffer ls_mstr,
                             input no,
                             input no)"
         &NOAPPERROR = true
         &CATCHERROR = true
         }

      assign l_adnbr = input adnbr.
      /* CREATED INTERNAL PROCEDURE TO REMOVE ACTION SEGMENT ERROR */
      run p_dock_check ( input l_adnbr , output l_err ).
      if l_err then undo.
      {pxrun.i &PROC    = 'validateAddress' &PROGRAM = 'adstxr.p'
         &PARAM   = "(input adnbr:SCREEN-VALUE,
                             input vd_addr)"
         &NOAPPERROR = true
         &CATCHERROR = true
         }

      if return-value <> {&SUCCESS-RESULT} then undo.
      if input adnbr = "" or not available ls_mstr then do:
         /* Skip the excess prompt in batch */
         if not batchrun then do:
            /* ship-from does not exist, do you wish to add? */
         {pxmsg.i &MSGNUM=80402 &ERRORLEVEL={&INFORMATION-RESULT} &CONFIRM=yn}
         end.
         else
            yn = yes.
         if not yn then do:
            display "" @ adnbr.
            next-prompt adnbr.
            undo loopb, retry loopb.
         end. /* if not yn then do: */
         else do:
            do transaction:
               if not available ad_mstr then do:
                  if input adnbr = "" then do:
                     run update-addr (input-output shiptocode).
                     display shiptocode @ adnbr with frame b.
                  end. /* if input adnbr = "" then do: */

                  {pxrun.i &PROC    = 'createAddress' &PROGRAM = 'adadxr.p'
                     &PARAM   = "(buffer ad_mstr,
                                             input adnbr:screen-value,
                                             input 'shipfrom',
                                             input today)"
                     &NOAPPERROR = true
                     &CATCHERROR = true
                     }

                  {pxrun.i &PROC   = 'setCreateDefaults' &PROGRAM = 'adadxr.p'
                     &PARAM   = "(buffer ad_mstr,
                                             input adnbr:screen-value,
                                             input name,
                                             input 'shipfrom',
                                             input name,
                                             input vd_lang)"
                     &NOAPPERROR = true
                     &CATCHERROR = true
                     }
                  if recid(ad_mstr) = -1 then .
               end. /* if not available ad_mstr then do: */
               else do:
                  {pxrun.i &PROC    = 'processRead' &PROGRAM = 'adadxr.p'
                     &PARAM   = "(input adnbr:SCREEN-VALUE,
                                        buffer ad_mstr,
                                        input yes,
                                        input yes)"
                     &NOAPPERROR = true
                     &CATCHERROR = true
                     }
               end.

               {pxrun.i &PROC = 'attachCustomertoShipTo' &PROGRAM = 'adstxr.p'
                        &PARAM = "(buffer ad_mstr,
                                     input vd_addr)"
                  &NOAPPERROR = true
                  &CATCHERROR = true
                  }

               {pxrun.i &PROC    = 'processCreate' &PROGRAM = 'adarxr.p'
                  &PARAM   = "(input ad_addr,
                                     input 'shipfrom',
                                     buffer ls_mstr)"
                  &NOAPPERROR = true
                  &CATCHERROR = true
                  }

               l_newrec = yes.

               run ls_update(buffer ls_mstr).
               /* Moved code to an internal procedure to handle mgqqapp.i */

            end.  /*transaction*/
         end.  /*else do*/
      end.  /*if input = "" or not available */

      /* AUDIT TRAIL - BEFORE IMAGE FILE CAPTURE */
      {gpaud1.i &uniq_num1 = 01
         &uniq_num2 = 02
         &db_file   = ad_mstr}

      do transaction:

         find ad_mstr  where ad_mstr.ad_domain = global_domain and  ad_addr =
         input adnbr exclusive-lock.
         if avail ad_mstr then do:
         display
            ad_temp ad_name ad_line1 ad_line2 ad_line3 ad_city
            ad_state ad_zip ad_format
            ad_ctry ad_county
            ad_attn ad_phone ad_ext ad_fax
            ad_attn2 ad_phone2 ad_ext2  ad_fax2  ad_lang
            ad_sort.
         end.
         do on error undo, retry:
            assign
               delete_lsmstr = false.
            {pxrun.i &PROC    = 'setModificationInfo' &PROGRAM = 'adadxr.p'
               &PARAM   = "(buffer ad_mstr)"
               &NOAPPERROR = true
               &CATCHERROR = true
               }

            assign
               ststatus = stline[2]
               del-yn = no
               recno = recid(ad_mstr).
            status input ststatus.

            set
               ad_temp ad_name ad_line1 ad_line2 ad_line3 ad_city
               ad_state ad_zip ad_format
               ad_ctry ad_county
               ad_attn ad_phone ad_ext ad_fax
               ad_attn2 ad_phone2 ad_ext2  ad_fax2  ad_lang
               ad_sort go-on("F5" "CTRL-D").

            if keyfunction(lastkey) = "END-ERROR"
            then
               undo loopb, retry loopb.

            {pxrun.i &PROC    = 'validateAddressFormat' &PROGRAM = 'adadxr.p'
               &PARAM   = "(input ad_format)"
               &NOAPPERROR = true
               &CATCHERROR = true
               }
            if return-value <> {&SUCCESS-RESULT} then do:
               next-prompt ad_format.
               undo.
            end. /* if return-value <> {&SUCCESS-RESULT} */

            {pxrun.i &PROC    = 'validateCountryCode' &PROGRAM = 'adadxr.p'
               &PARAM   = "(input ad_ctry)"
               &NOAPPERROR = true
               &CATCHERROR = true
               }
            if return-value <> {&SUCCESS-RESULT} then do:
               if batchrun
               then do:
                  /* l_batcherr IS USED TO TRAP ERROR IN CASE OF CIM */
                  l_batcherr = true.
                  import ^.
                  next-prompt adnbr with frame b.
                  undo loopb, retry loopb.
               end. /* IF batchrun */
               else do:
                  next-prompt ad_ctry with frame b.
                  undo, retry.
               end. /* ELSE DO */
            end.
            else do:
               {pxrun.i &PROC    = 'getCountryDescription' &PROGRAM = 'adctxr.p'
                  &PARAM   = "(input ad_ctry,
                                 output ad_country)"
                  &NOAPPERROR = true
                  &CATCHERROR = true
                  }
               if return-value = {&SUCCESS-RESULT} then
                  display ad_country with frame b.
            end. /* else do: */

            /* DELETE */
            if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
            /* Execute delete when batchdelete variable is set to "x" */
            or input batchdelete = "x"
            then do:
               del-yn = yes.
               /* Please  confirm Delete */
               {pxmsg.i &MSGNUM=11 &ERRORLEVEL={&INFORMATION-RESULT}
                  &CONFIRM=del-yn}
               if not del-yn then undo, retry.
               delete_lsmstr = true.
               undo, leave.
            end. /* then do: */
         end. /* do on error undo, retry: */

         if delete_lsmstr then do:
/*100910*****
            {pxrun.i &PROC    = 'checkOpenSalesOrders' &PROGRAM = 'adstxr.p'
               &PARAM   = "(input vd_addr,
                                  input ad_addr)"
               &NOAPPERROR = true
               &CATCHERROR = true
               }
            if return-value <> {&SUCCESS-RESULT} then
               next loopb.

            /* CHECK FOR OPEN SALES ORDER QUOTES */
            {pxrun.i &PROC    = 'checkOpenSalesQuotes' &PROGRAM = 'adstxr.p'
               &PARAM   = "(input vd_addr,
                                  input ad_addr)"
               &NOAPPERROR = true
               &CATCHERROR = true
               }
            if return-value <> {&SUCCESS-RESULT} then
               next loopb.

            /* CHECK FOR OPEN SERVICE & REPAIR ORDERS */
            {pxrun.i &PROC    = 'checkOpenServiceAndRepairOrders'
               &PROGRAM = 'adstxr.p'
               &PARAM   = "(input vd_addr,
                                  input ad_addr)"
               &NOAPPERROR = true
               &CATCHERROR = true
               }
            if return-value <> {&SUCCESS-RESULT} then
               next loopb.

            /* CHECK FOR OPEN PRM PROJECTS */
            {pxrun.i &PROC    = 'checkOpenPRMProj' &PROGRAM = 'adstxr.p'
               &PARAM   = "(input vd_addr,
                                  input ad_addr)"
               &NOAPPERROR = true
               &CATCHERROR = true
               }
            if return-value <> {&SUCCESS-RESULT} then
               next loopb.

            /* CHECK FOR OPEN INVOICES */
            {pxrun.i &PROC    = 'checkOpenInvoice'
                     &PROGRAM = 'adstxr.p'
                     &PARAM   = "(input vd_addr,
                                  input ad_addr)"
                     &NOAPPERROR = true
                     &CATCHERROR = true}
            if return-value <> {&SUCCESS-RESULT}
            then
               next loopb.
*****100910 */

            {pxrun.i &PROC    = 'deleteUserRoles' &PROGRAM = 'adarxr.p'
               &PARAM   = "(input ad_addr,input 'shipfrom')"
               &NOAPPERROR = true
               &CATCHERROR = true
               }

            /* DELETE LIST MASTER */
            {pxrun.i &PROC    = 'processRead' &PROGRAM = 'adarxr.p'
               &PARAM   = "(input ad_addr,
                                  input 'shipfrom',
                                  buffer ls_mstr,
                                  input yes,
                                  input yes)"
               &NOAPPERROR = true
               &CATCHERROR = true
               }
/*****
            {pxrun.i &PROC    = 'deleteAllCustomerItemsForShipto'
                     &PROGRAM = 'ppcixr.p'
                     &PARAM   = "(input ls_addr)"
                     &NOAPPERROR = true
                     &CATCHERROR = true
                     }

            {pxrun.i &PROC    = 'deleteDockAddress' &PROGRAM = 'adstxr.p'
               &PARAM   = "(input ls_addr)"
               &NOAPPERROR = true
               &CATCHERROR = true
               }

            {pxrun.i &PROC = 'deleteReservedLocationsForShipFrom'
                     &PROGRAM = 'adstxr.p'
                     &PARAM = "(input ls_addr)"
                     &NOAPPERROR=true
                     &CATCHERROR=true
            }
*****/
            {pxrun.i &PROC    = 'deleteRole' &PROGRAM = 'adarxr.p'
               &PARAM   = "(input ad_addr,
                            input 'shipfrom')"
               &NOAPPERROR = true
               &CATCHERROR = true
               }

            if not dynamic-function("existAddressRole"
               in getHandle("adarxr.p",false),  ad_addr)
            then do:
               {pxrun.i &PROC    = 'deleteAddress' &PROGRAM = 'adadxr.p'
                  &PARAM   = "(buffer ad_mstr)"
                  &NOAPPERROR = true
                  &CATCHERROR = true
                  }
            end.
            else
            do:
              if not can-find (first ls_mstr
                                 where ls_domain = global_domain
                                 and   ls_addr   = ad_addr
                                 and   ls_type   = "enduser")
              then
                assign
                  ad_ref = "".

              ad_temp = No.

              {pxrun.i &PROC    = 'setModificationInfo' &PROGRAM = 'adadxr.p'
                 &PARAM   = "(buffer ad_mstr)"
                 &NOAPPERROR = true
                 &CATCHERROR = true
                 }
            end.
            clear frame b.

            /* AUDIT TRAIL SECTION - AFTER IMAGE SECTION FOR DELETE */
            run upd_aud2.

            next loopb.
         end. /* if delete_lsmstr then do: */

      end.  /*transaction*/

      /* INPUT TAX DATA */

      undo_adtaxmt = true.
      {&ADSTMT-P-TAG3}
      {adtaxmt.i "undo_adtaxmt" "ad_mstr."}

      if undo_adtaxmt
      then do:
         l_newrec = no.
         undo loopb, retry.
      end. /* IF undo_adtaxmt */
      {&ADSTMT-P-TAG4}

      /* AUDIT TRAIL SECTION - AFTER IMAGE SECTION FOR MODIFY */
      run upd_aud2.

      /* AUDIT TRAIL FILE DELETE */
      run upd_aud3.

   end. /* END LOOP B  */

end. /* END MAIN LOOP */
status input.

/*MAIN-END*/
/* ========================================================================== */
/* *************************** INTERNAL PROCEDURES ************************** */
/* ========================================================================== */

/*============================================================================*/
PROCEDURE ls_update:
/*---------------------------------------------------------------------------
Purpose:     /*@TO DO*/
Exceptions:  NONE
Notes:
History:
---------------------------------------------------------------------------*/
   define parameter buffer ls_mstr for ls_mstr.

   /* Update ls_app_owner with the Q/LinQ owner, if any */
   {mgqqapp.i "ls_app_owner"}
   if recid(ls_mstr) = -1 then .

END PROCEDURE.

/*============================================================================*/
PROCEDURE p_dock_check:
/*---------------------------------------------------------------------------
Purpose:
Exceptions:  NONE
Notes:
History:
---------------------------------------------------------------------------*/

   define input parameter  l_adnbr like ad_addr no-undo.
   define output parameter l_err like mfc_logical no-undo .

   {pxrun.i &PROC    = 'validateDock' &PROGRAM = 'adstxr.p'
      &PARAM   = "(input l_adnbr)"
      &NOAPPERROR = true
      &CATCHERROR = true
      }

   if return-value <> {&SUCCESS-RESULT} then do:
      assign l_err = yes.
   end. /* IF AVAILABLE AD_MSTR */

END PROCEDURE.

/*============================================================================*/
PROCEDURE update-addr:
/*---------------------------------------------------------------------------
Purpose:
Exceptions:  NONE
Notes:
History:
---------------------------------------------------------------------------*/
   define input-output parameter shipToCode like ad_addr.

   {mfactrl.i "cmc_ctrl.cmc_domain = global_domain" "cmc_ctrl.cmc_domain"
   "ad_mstr.ad_domain = global_domain" cmc_ctrl cmc_nbr ad_mstr ad_addr
   shipToCode}

END PROCEDURE.

/* ADDED FOLLOWING PROCEDURES TO PREVENT ACTION SEGMENT ERROR */

PROCEDURE upd_aud2:

   {gpaud2.i  &uniq_num1 = 01
      &uniq_num2 = 02
      &db_file   = ad_mstr
      &db_field  = ad_addr
      &db_field1 = """"}

END PROCEDURE.  /* PROCEDURE UPD_AUD2 */

PROCEDURE upd_aud3:

   {gpaud3.i  &uniq_num1 = 01
      &uniq_num2 = 02
      &db_file   = ad_mstr
      &db_field  = ad_addr}

END PROCEDURE.  /* PROCEDURE UPD_AUD3 */
