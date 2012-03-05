/* socnuac.p - Sales Order Consignment Usage AutoCreate                       */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*                                                                            */
/* Revision: 1.33         BY: Patrick Rowan       DATE: 04/04/02  ECO: *P00F* */
/* Revision: 1.37         BY: Dan Herman          DATE: 06/19/02  ECO: *P091* */
/* Revision: 1.38         BY: John Corda          DATE: 08/09/02  ECO: *N1QP* */
/* Revision: 1.38.3.1     BY: Ed van de Gevel     DATE: 12/02/03  ECO: *P0SV* */
/* Revision: 1.38.3.2     BY: Preeti Sattur       DATE: 02/20/04  ECO: *P1PZ* */
/* Revision: 1.38.3.3     BY: Preeti Sattur       DATE: 03/02/04  ECO: *P1N2* */
/* Revision: 1.38.3.5     BY: Robin McCarthy      DATE: 03/29/04  ECO: *P16X* */
/* Revision: 1.38.3.6     BY: Laxmikant Bondre    DATE: 04/26/04  ECO: *P1TT* */
/* Revision: 1.38.3.7     BY: Reena Ambavi        DATE: 06/23/04  ECO: *P27C* */
/* Revision: 1.38.3.8     BY: Vandna Rohira       DATE: 10/01/04  ECO: *P2ML* */
/* Revision: 1.38.3.9     BY: Jignesh Rachh       DATE: 02/28/05  ECO: *P38N* */
/* Revision: 1.38.3.10    BY: Hitendra P V        DATE: 09/08/05  ECO: *P406* */
/* Revision: 1.38.3.11    BY: Robin McCarthy      DATE: 10/01/05  ECO: *P3MZ* */
/* Revision: 1.38.3.13    BY: Robin McCarthy      DATE: 12/02/05  ECO: *P49R* */
/* $Revision: 1.38.3.14 $          BY: Hitendra PV         DATE: 12/19/05  ECO: *P4CL* */
/* $Revision: 1.38.3.14 $          BY: Bill Jiang         DATE: 02/16/08  ECO: *SS - 20080216.1* */

/* SS - 20080216.1 - B */
/*
1. 验证了总账日历
*/
/* SS - 20080216.1 - E */
/*-Revision end---------------------------------------------------------------*/

/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */
/*                                                                          */
/*         THIS PROGRAM IS A BOLT-ON TO STANDARD PRODUCT MFG/PRO.           */
/* ANY CHANGES TO THIS PROGRAM MUST BE PLACED ON A SEPARATE ECO THAN        */
/* STANDARD PRODUCT CHANGES.  FAILURE TO DO THIS CAUSES THE BOLT-ON CODE TO */
/* BE COMBINED WITH STANDARD PRODUCT AND RESULTS IN PATCH DELIVERY FAILURES.*/
/*                                                                          */
/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */

/* MODIFICATIONS TO THIS PROGRAM MAY REQUIRE MODIFICATION TO:                 */
/*    socnuac3.p, socnuac5.p and socnuac7.p                                   */

/*V8:ConvertMode=Maintenance                                                  */

{mfdtitle.i "2+ "}
{cxcustom.i "SOCNUAC.P"}

/* VARIABLES */
{pxsevcon.i}
{gldydef.i new}
{gldynrm.i new}

/* SHARED VARIABLES FOR icsrup.p */
define new shared variable multi_entry       like mfc_logical           no-undo.
define new shared variable site              like sr_site               no-undo.
define new shared variable location          like sr_loc                no-undo.
define new shared variable trans_conv        like sod_um_conv.

/* LOCAL VARIABLES */
{socnvars.i}
{socnuvar.i}    /* COMMON USAGE VARIABLES */

/* FRAME D VARIABLES (used in socnufrm.i */
define variable frmd_lotser                  like cncix_lotser          no-undo.
define variable frmd_ref                     like cncix_ref             no-undo.

{&SOCNUAC-P-TAG1}
{&SOCNUAC-P-TAG2}

{socnutmp.i}    /* COMMON USAGE TEMP-TABLE DEFINITIONS */

{socnufrm.i}    /* COMMON USAGE FORM DEFINITIONS */

/* SELECTION FORM */
form
   {socnfm1a.i}
   skip(1)
   {socnfm2a.i}
with frame a width 80 side-labels.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DETERMINE IF SELF-BILLING IS INSTALLED AND ACTIVE */
using_selfbilling =
   if can-find (first mfc_ctrl
      where mfc_field   = "enable_self_bill"
      and   mfc_seq     = 2
      and   mfc_module  = "ADG"
      and   mfc_logical = yes)
   then
      yes
   else
      no.

assign
   tmp_global_ref = global_ref
   invoice_db     = global_db
   sortby_num     = "3".


mainloop:
repeat with frame a:

   assign
      global_ref = tmp_global_ref
      global_db  = invoice_db.

   hide frame a1.
   hide frame aa.

   if shipfrom1 = hi_char then shipfrom1 = "".
   if sopart1   = hi_char then sopart1   = "".
   if po1       = hi_char then po1       = "".
   if nbr1      = hi_char then nbr1      = "".
   if part1     = hi_char then part1     = "".

   /* Convert the numeric equivalent for sortby to mnemonic code */
   run getLanguageDetailMnemonic
      (input  "consignment",
       input  sortby,
       output sortby_label).

   display
      sortby
      sortby_label
   with frame a.

   update
      shipto
      cust
   with frame a.

   /* VALIDATION */
   if shipto   = ""
      and cust = ""
   then do:
      {pxmsg.i &MSGNUM=4922 &ERRORLEVEL=3}  /* MUST ENTER SHIP-TO OR SOLD-TO*/
      next-prompt shipto.
      undo mainloop, retry mainloop.
   end.

   /* DETERMINE SHIP-TO NAME */
   run getName
      (input  shipto,
       output shipto_name).
   display shipto_name with frame a.

   /* DETERMINE CUSTOMER NAME */
   run getName
      (input  cust,
       output cust_name).
   display cust_name with frame a.

   if eff-date = ? then
      eff-date = today.

   display
      shipfrom  shipfrom1
      sopart    sopart1
      po        po1
      nbr       nbr1
      part      part1
      eff-date
      sel_all
      sortby
   with frame a.

   setloop:
   do on error undo, retry with frame a:
      set
         shipfrom  shipfrom1
         sopart    sopart1
         po        po1
         nbr       nbr1
         part      part1
         eff-date
         sel_all
         sortby
      with frame a
      editing:

         lastkey_processed = no.

         if frame-field = "sortby" then do:
            {mfnp05.i lngd_det lngd_trans
               "lngd_dataset   = 'consignment'
                and lngd_field = 'sortby'
                and lngd_lang  = global_user_lang"
                lngd_key2 "input sortby"}

            lastkey_processed = yes.

            if recno <> ? then
               display
                  lngd_key2        @ sortby
                  lngd_translation @ sortby_label
               with frame a.
         end.

         if not lastkey_processed then do:
            status input.
            readkey.
            apply lastkey.
         end.

      end.   /* UPDATE shipfrom ... EDITING */

      if eff-date = ? then
         eff-date = today.

      /* DETERMINE SORT OPTION */
      run getLanguageDetail
         (input  sortby,
          input  "consignment",
          output sortby_num,
          output lngd_recno).

      if lngd_recno = ? then do:
         next-prompt sortby.
         undo setloop, retry setloop.
      end.

      /* SS - 20080216.1 - B */
      /* CHECK FOR CLOSED PERIODS */
      find first glc_cal where glc_start <= eff-date and
                               glc_end >= eff-date
      no-lock no-error.

      if not available glc_cal then do:
         /* Invalid period/year */
         {pxmsg.i &MSGNUM=3008 &ERRORLEVEL=3}
         next-prompt eff-date.
         undo setloop, retry setloop.
      end.

      if available glc_cal then do:
         find
            /* TODO: */
            /* SS - 20080216.1 - B */
            first
            /* SS - 20080216.1 - E */
            glcd_det where glcd_year = glc_year and glcd_per = glc_per 
            /* TODO: */
            /* SS - 20080216.1 - B */
            /*
            and
            glcd_entity = {3}
            */
            /* SS - 20080216.1 - E */
         no-lock no-error.
      end.

      if glcd_yr_clsd = yes
      then do:
         /* YEAR HAS BEEN CLOSED */
         {pxmsg.i &MSGNUM=3022 &ERRORLEVEL=3}
         next-prompt eff-date.
         undo setloop, retry setloop.
      end. /* IF glcd_yr_clsd = yes */

      if glcd_ic_clsd = yes
      then do:
         /* PERIOD HAS BEEN CLOSED */
         {pxmsg.i &MSGNUM=3023 &ERRORLEVEL=3}
         next-prompt eff-date.
         undo setloop, retry setloop.
      end. /* IF glcd_ic_clsd = yes */
      /* SS - 20080216.1 - E */
   end.  /* setloop */

   if shipfrom1 = "" then shipfrom1 = hi_char.
   if sopart1   = "" then sopart1   = hi_char.
   if po1       = "" then po1       = hi_char.
   if nbr1      = "" then nbr1      = hi_char.
   if part1     = "" then part1     = hi_char.
   ctr = 0.

   run Housekeeping
      (input-output table tt_autocr,
       input-output table tt_so_update).

   /* LOAD TEMPORARY TABLE */
   run loadAutoCreateTable
      (input  shipto,
       input  cust,
       input  shipfrom,
       input  shipfrom1,
       input  sopart,
       input  sopart1,
       input  po,
       input  po1,
       input  nbr,
       input  nbr1,
       input  part,
       input  part1,
       input  invoice_db,
       input  eff-date,
       input  sortby_num,
       input  sel_all,
       output ctr,
       input-output table tt_autocr,
       input-output table tt_so_update).

   if return-value <> {&SUCCESS-RESULT} then
      undo mainloop, retry mainloop.

   /* # RECORDS FOUND MATCHING SELECTION CRITERIA */
   {pxmsg.i &MSGNUM=1615 &ERRORLEVEL="(if ctr = 0 then 3 else 1)"
            &MSGARG1=string(ctr)}

   if ctr = 0 then
      undo mainloop, retry mainloop.

   assign
      global_ref      = ""
      cust_usage_ref  = ""
      cust_usage_date = today
      selfbill_auth   = "".

   display
      cust_usage_ref
      cust_usage_date
      selfbill_auth   when (using_selfbilling)
      eff-date
   with frame aa.

   set
      cust_usage_ref
      cust_usage_date
      selfbill_auth   when (using_selfbilling)
   with frame aa.

   if cust_usage_date = ? then
      cust_usage_date = today.

   /* UPDATE TEMPORARY TABLE */
   run updateAutoCreateTable
      (input        cust_usage_ref,
       input        cust_usage_date,
       input        selfbill_auth,
       input-output table tt_autocr).

   hide frame a.
   hide frame aa.

   display
      shipto
      shipto_name
      cust
      cust_name
   with frame a1.

   /* IF USER CHOOSE NO FOR                     */
   /* QUERY 'IS ALL INFORMATION CORRECT'        */
   /* RETURN TO THIS PROGRAM AGAIN              */
   repeat:

   /* MULTI-LINE BROWSE FOR SELECTION OF RECORDS */
   {gprun.i ""socnuacb.p""
            "(input-output table tt_autocr,
              input        sortby_num,
              input        sel_all,
              input        using_selfbilling,
              input        invoice_db,
              input        eff-date,
              output       continue-yn)"}

      if (keyfunction(lastkey) = "END-ERROR"
         and not continue-yn)
/*V8!    or continue-yn = ? */
      then
         undo mainloop, retry mainloop.

      if continue-yn then
         leave.

   end. /* REPEAT */

   hide frame a1.
   view frame a.

   if continue-yn = no then
      undo mainloop, retry mainloop.

   /* CREATE USAGE RECORDS AND POST INVOICE */
   {gprun.i ""socnuac2.p""
            "(input-output table tt_autocr,
              input-output table tt_so_update,
              input        using_selfbilling,
              input        MANUAL,
              input        eff-date,
              input        invoice_db,
              output       batch_id,
              output       continue-yn)"}

   if continue-yn = no then
      undo mainloop, retry mainloop.

   /* SAVE USAGE ID FOR OTHER PROGRAMS TO USE */
   {gprun.i ""rqidf.p""
            "(input 'put',
              input 'usageID',
              input-output batch_id)"}

   {pxmsg.i &MSGNUM=1107 &ERRORLEVEL=1}   /* PROCESS COMPLETE  */

   if global_ref = "" then do:
      /* BATCH CREATED:  */
      {pxmsg.i &MSGNUM=4924 &ERRORLEVEL=1 &MSGARG1=batch_id}
   end.
   else do:
      /* BATCH CREATED: #,  INVOICE CREATED: # */
      {pxmsg.i &MSGNUM=5237 &ERRORLEVEL=1
               &MSGARG1=batch_id
               &MSGARG2=global_ref}
   end.
end.   /* MAINLOOP */

run postProcessCleanup
   (input-output table tt_autocr,
    input-output table tt_so_update,
    input        invoice_db,
    input        tmp_global_ref).

/* ========================================================================== */
/* ************************* INTERNAL PROCEDURES **************************** */
/* ========================================================================== */

{socnucpl.i}   /* COMMON INTERNAL PROCEDURES FOR ALL USAGE PROGRAMS */

/* ========================================================================== */
PROCEDURE loadAutoCreateTable:
/* --------------------------------------------------------------------------
 * Purpose:    Read the shipment cross-reference table based on the selection
 *             criteria and fill the temp table buffer.
 * -------------------------------------------------------------------------- */
   define input        parameter  ip_shipto          as character no-undo.
   define input        parameter  ip_cust            as character no-undo.
   define input        parameter  ip_shipfrom        as character no-undo.
   define input        parameter  ip_shipfrom1       as character no-undo.
   define input        parameter  ip_sopart          as character no-undo.
   define input        parameter  ip_sopart1         as character no-undo.
   define input        parameter  ip_po              as character no-undo.
   define input        parameter  ip_po1             as character no-undo.
   define input        parameter  ip_nbr             as character no-undo.
   define input        parameter  ip_nbr1            as character no-undo.
   define input        parameter  ip_part            as character no-undo.
   define input        parameter  ip_part1           as character no-undo.
   define input        parameter  ip_invoice_db      as character no-undo.
   define input        parameter  ip_effdate         as date      no-undo.
   define input        parameter  ip_sortby_num      as character no-undo.
   define input        parameter  ip_sel_all         as logical   no-undo.
   define output       parameter  op_cntr            as integer   no-undo.
   define input-output parameter  table              for tt_autocr.
   define input-output parameter  table              for tt_so_update.

   do transaction on error undo, return error {&GENERAL-APP-EXCEPT}:

      /* INITIALIZE op_cntr OUTSIDE LOOP FOR cncix_mstr SO THAT CORRECT */
      /* RECORD COUNT IS DISPLAYED IN THE MESSAGE                       */
      op_cntr = 0.

      /* BUILD TEMP-TABLE OF SO LINES MATCHING SELECTION CRITERIA */
      run loadSOUpdateTable
         (input  ip_shipto,
          input  ip_cust,
          input  ip_shipfrom,
          input  ip_shipfrom1,
          input  ip_sopart,
          input  ip_sopart1,
          input  ip_po,
          input  ip_po1,
          input  ip_nbr,
          input  ip_nbr1,
          input  ip_part,
          input  ip_part1,
          input  "",             /* Auth */
          input  "",             /* Auth1 */
          input  "",             /* Cust Job */
          input  "",             /* Cust Job1 */
          input  "",             /* Seq */
          input  "",             /* Seq */
          input  "",             /* Cust Ref */
          input  "",             /* Cust Ref1 */
          input  "",             /* Shipper */
          input  "",             /* Shipper1 */
          input-output table tt_so_update).

      for each tt_so_update no-lock
      break by tt_inventory_db:

         if first-of (tt_inventory_db)
            and tt_inventory_db <> global_db
         then do:

            /* SWITCH TO INVENTORY DB */
            run switchDB
               (input  tt_inventory_db,
                output undo_flag).

            if undo_flag then
               undo, return.

            /* HOUSEKEEPING IN INVENTORY DB */
            {gprun.i ""socnuac1.p""}

         end. /* IF FIRST-OF (tt_inventory_db) */

         /* CREATE cncix_mstr TEMP-TABLE FOR USAGE */
         {gprun.i ""socnuaca.p""
                  "(input        tt_so_nbr,
                    input        tt_sod_line,
                    input        tt_sod_site,
                    input        ip_effdate,
                    input        ip_sortby_num,
                    input        ip_sel_all,
                    input        0,  /* EDI USAGE QTY */
                    input-output op_cntr,
                    input-output table tt_autocr)"}

      end.   /* FOR EACH tt_so_update */

      if ip_invoice_db <> global_db then do:
         /* SWITCH TO INVOICE DB */
         run switchDB
            (input  ip_invoice_db,
             output undo_flag).

         if undo_flag then
            undo, return.
      end.
   end.   /* DO ON ERROR UNDO..*/

   return {&SUCCESS-RESULT}.

END PROCEDURE.   /* loadAutoCreateTable */
