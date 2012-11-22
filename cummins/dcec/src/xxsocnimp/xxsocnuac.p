/* GUI CONVERTED from socnuac.p (converter v1.78) Thu Feb 12 23:05:44 2009 */
/* socnuac.p - Sales Order Consignment Usage AutoCreate                       */
/* Copyright 1986-2009 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*                                                                            */
/* Revision: 1.33      BY: Patrick Rowan          DATE: 04/04/02  ECO: *P00F* */
/* Revision: 1.37      BY: Dan Herman             DATE: 06/19/02  ECO: *P091* */
/* Revision: 1.38      BY: John Corda             DATE: 08/09/02  ECO: *N1QP* */
/* Revision: 1.42      BY: Paul Donnelly (SB)     DATE: 06/28/03  ECO: *Q00L* */
/* Revision: 1.43      BY: Ed van de Gevel        DATE: 12/24/03  ECO: *P0SV* */
/* Revision: 1.44      BY: Preeti Sattur          DATE: 02/20/04  ECO: *P1PZ* */
/* Revision: 1.45      BY: Preeti Sattur          DATE: 03/02/04  ECO: *P1N2* */
/* Revision: 1.46      BY: Laxmikant Bondre       DATE: 04/26/04  ECO: *P1TT* */
/* Revision: 1.47      BY: Robin McCarthy         DATE: 04/30/04  ECO: *P16X* */
/* Revision: 1.48      BY: Reena Ambavi           DATE: 06/23/04  ECO: *P27C* */
/* Revision: 1.49      BY: Vandna Rohira          DATE: 10/01/04  ECO: *P2ML* */
/* Revision: 1.49.1.1  BY: Jignesh Rachh          DATE: 02/28/05  ECO: *P38N* */
/* Revision: 1.49.1.2  BY: Robin McCarthy         DATE: 10/01/05  ECO: *P3MZ* */
/* Revision: 1.49.1.4  BY: Robin McCarthy         DATE: 10/31/05  ECO: *Q0MF* */
/* Revision: 1.49.1.5  BY: Hitendra P V           DATE: 12/02/05  ECO: *P406* */
/* Revision: 1.49.1.6  BY: Robin McCarthy         DATE: 12/08/05  ECO: *P49R* */
/* Revision: 1.49.1.9  BY: Hitendra PV            DATE: 12/19/05  ECO: *P4CL* */
/* Revision: 1.49.1.10 BY: Iram Momin             DATE: 10/08/07  ECO: *P694* */
/* Revision: 1.49.1.11 BY: Ed van de Gevel        DATE: 10/22/07  ECO: *P51G* */
/* Revision: 1.49.1.12 BY: Sumit Karunakaran      DATE: 12/28/07  ECO: *P62H* */
/* Revision: 1.49.1.13 BY: Prashant Menezes       DATE: 02/12/08  ECO: *P6LH* */
/* Revision: 1.49.1.14 BY: Alex Joy    DATE: 11/04/08 ECO: *P6R7* */
/* $Revision: 1.49.1.19 $ BY: Mallika Poojary        DATE: 01/30/09  ECO: *Q29Z* */
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

{mfdtitle.i "1+ "}
{cxcustom.i "SOCNUAC.P"}

/* VARIABLES */
{pxsevcon.i}
{gldydef.i new}
{gldynrm.i new}
{gprunpdf.i "mcpl" "p"}

/* SHARED VARIABLES FOR icsrup.p */
define new shared variable multi_entry       like mfc_logical           no-undo.
define new shared variable site              like sr_site               no-undo.
define new shared variable location          like sr_loc                no-undo.
define new shared variable trans_conv        like sod_um_conv.
DEFINE VARIABLE thLINE LIKE sod_line NO-UNDO.

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
{&SOCNUAC-P-TAG3}

/* SELECTION FORM */

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
{socnfm1a.i}
 thLINE
 site
 location
   skip(1)
   {socnfm2a.i}
 
 SKIP(.4)  /*GUI*/
with frame a width 80 side-labels NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
{&SOCNUAC-P-TAG4}

/* DETERMINE IF SELF-BILLING IS INSTALLED AND ACTIVE */
using_selfbilling =
   if can-find (first mfc_ctrl
      where mfc_domain  = global_domain
      and   mfc_field   = "enable_self_bill"
      and   mfc_seq     = 2
      and   mfc_module  = "ADG"
      and   mfc_logical = yes)
   then
      yes
   else
      no.

assign
   tmp_global_ref = global_ref
   invoice_domain = global_domain
   sortby_num     = "3".


mainloop:
repeat with frame a:
/*GUI*/ if global-beam-me-up then undo, leave.


   assign
      global_ref    = tmp_global_ref
      global_domain = invoice_domain.

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
      undo mainloop, leave mainloop.
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
   thLINE = 0 .
   site = "".
   location  = "".
   display
      shipfrom  shipfrom1
      sopart    sopart1
      po        po1
      nbr       nbr1
      part      part1
      thLINE
      site 
      location
      eff-date
      sel_all
      sortby
   with frame a.

   setloop:
   do on error undo, leave with frame a:
/*GUI*/ if global-beam-me-up then undo, leave.

      set
         shipfrom  shipfrom1
         sopart    sopart1
         po        po1
         nbr       nbr1
         part      part1
          thLINE
          site 
          location
         eff-date
         sel_all
         {&SOCNUAC-P-TAG5}
         sortby
      with frame a
      editing:

         lastkey_processed = no.

         if frame-field = "sortby" then do:
            {mfnp05.i lngd_det lngd_trans
               "lngd_dataset = 'consignment'
                and lngd_field   = 'sortby'
                and lngd_lang    = global_user_lang"
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
         undo setloop, leave setloop.
      end.
      {&SOCNUAC-P-TAG6}
   end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* SETLOOP */

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
       input  invoice_domain,
       input  eff-date,
       input  sortby_num,
       input  sel_all,
       output ctr,
       input-output table tt_autocr,
       input-output table tt_so_update).

   if return-value <> {&SUCCESS-RESULT} then
      undo mainloop, leave mainloop.
    {&SOCNUAC-P-TAG7}
   /* # RECORDS FOUND MATCHING SELECTION CRITERIA */
   {pxmsg.i &MSGNUM=1615 &ERRORLEVEL="(if ctr = 0 then 3 else 1)"
            &MSGARG1=string(ctr)}

   if ctr = 0 then
      undo mainloop, leave mainloop.

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

   hide frame a.
   hide frame aa.

   display
      shipto
      shipto_name
      cust
      cust_name
   with frame a1.

   FOR EACH tt_autocr :
       IF (ac_line = thline OR thline = 0 ) AND 
          (ac_site = site OR site = "") AND 
          (ac_loc = location OR location = "")  THEN NEXT.
       DELETE tt_autocr.
   END.

   /* IF USER CHOOSE NO FOR                     */
   /* QUERY 'IS ALL INFORMATION CORRECT'        */
   /* RETURN TO THIS PROGRAM AGAIN              */
   repeat:
/*GUI*/ if global-beam-me-up then undo, leave.


      /* MULTI-LINE BROWSE FOR SELECTION OF RECORDS */
      {gprun.i ""xxsocnuacb.p""
               "(input-output table tt_autocr,
                 input        sortby_num,
                 input        sel_all,
                 input        using_selfbilling,
                 input        invoice_domain,
                 input        eff-date,
                 output       continue-yn)"}
/*GUI*/ if global-beam-me-up then undo, leave.


      if (keyfunction(lastkey) = "END-ERROR"
         and not continue-yn)
         or continue-yn = ?   
      then
         undo mainloop, leave mainloop.

      if continue-yn then
         leave.
      leave.
   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* REPEAT */

   for first tt_autocr:
       /* UPDATE TEMPORARY TABLE */
       run updateAutoCreateTable
          (input        cust_usage_ref,
           input        cust_usage_date,
           input        selfbill_auth,
           input-output table tt_autocr).
   end.
/*GUI*/ if global-beam-me-up then undo, leave.


   hide frame a1.
   view frame a.

   if continue-yn = no then
      undo mainloop, leave mainloop.

   /* CREATE USAGE RECORDS AND POST INVOICE */
   {gprun.i ""socnuac2.p""
            "(input-output table tt_autocr,
              input-output table tt_so_update,
              input        using_selfbilling,
              input        MANUAL,
              input        eff-date,
              input        invoice_domain,
              output       batch_id,
              output       continue-yn)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   if continue-yn = no then
      undo mainloop, leave mainloop.

   /* SAVE USAGE ID FOR OTHER PROGRAMS TO USE */
   {gprun.i ""rqidf.p""
            "(input 'put',
              input 'usageID',
              input-output batch_id)"}
/*GUI*/ if global-beam-me-up then undo, leave.


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
    input        invoice_domain,
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
   define input        parameter  ip_invoice_domain  as character no-undo.
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
      break by tt_inventory_domain:
/*GUI*/ if global-beam-me-up then undo, leave.


         if first-of (tt_inventory_domain)
            and tt_inventory_domain <> global_domain
         then do:

            /* SWITCH TO INVENTORY DOMAIN */
            run switchDomain
               (input  tt_inventory_domain,
                output undo_flag).

            if undo_flag then
               undo, return.

            /* HOUSEKEEPING IN INVENTORY DOMAIN */
            {gprun.i ""socnuac1.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


         end. /* IF FIRST-OF (tt_inventory_domain) */

         /* CREATE cncix_mstr TEMP-TABLE FOR USAGE */
         {gprun.i ""socnuaca.p""
                  "(input        tt_inventory_domain,
                    input        tt_so_nbr,
                    input        tt_sod_line,
                    input        tt_sod_site,
                    input        """",
                    input        """",
                    input        ip_effdate,
                    input        ip_sortby_num,
                    input        ip_sel_all,
                    input        0,  /* EDI USAGE QTY */
                    input        """",
                    input        """",
                    input-output op_cntr,
                    input-output table tt_autocr)"}
/*GUI*/ if global-beam-me-up then undo, leave.


      end.
/*GUI*/ if global-beam-me-up then undo, leave.
   /* FOR EACH tt_so_update */

      if ip_invoice_domain <> global_domain then do:
         /* SWITCH TO INVOICE DOMAIN */
         run switchDomain
            (input  ip_invoice_domain,
             output undo_flag).

         if undo_flag then
            undo, return.
      end.

      for each tt_autocr no-lock:
         /* VERIFY EXCHANGE RATE */
         run verifyExchangeRate
            (input  ac_order,
             input  base_curr,
             input  ac_eff_date,
             output continue-yn).

         if not continue-yn then
            undo,return.
      end.   /*for each tt_autocr */

   end.   /* DO ON ERROR UNDO..*/
   return {&SUCCESS-RESULT}.

END PROCEDURE.   /* loadAutoCreateTable */

/* ========================================================================== */
PROCEDURE verifyExchangeRate:
/* --------------------------------------------------------------------------
 * Purpose:   Verifies if the Exchange rate is valid as on the date specified
 * -------------------------------------------------------------------------- */
   define input  parameter ip_order     like ac_order                   no-undo.
   define input  parameter ip_base_curr like base_curr                  no-undo.
   define input  parameter ip_eff_date  like ac_eff_date                no-undo.
   define output parameter op_continue  as   logical                    no-undo.

   define variable exch_rate            like exr_rate                   no-undo.
   define variable exch_rate2           like exr_rate2                  no-undo.
   define variable mc-error-number      as   integer                    no-undo.

   define buffer so_mstr for so_mstr.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      for first so_mstr
         fields (so_curr so_domain so_ex_ratetype so_fix_rate so_nbr)
         where   so_domain = global_domain
         and     so_nbr    = ip_order
      no-lock:

         if not so_fix_rate then do:

            /* GET EXCHANGE RATE FOR BASE TO ACCOUNT CURRENCY */
            {gprunp.i "mcpl" "p" "mc-get-ex-rate"
                      "(input  so_curr,
                        input  ip_base_curr,
                        input  so_ex_ratetype,
                        input  ip_eff_date,
                        output exch_rate,
                        output exch_rate2,
                        output mc-error-number)"}

            if mc-error-number <> 0 then do:
               /* EXCHANGE RATE DOES NOT EXIST */
               {pxmsg.i &MSGNUM=81 &ERRORLEVEL=3}
               op_continue = no.
            end.
            else
               op_continue = yes.

        end.   /* IF NOT so_fix_rate */
        else
           op_continue = yes.

      end.   /* FOR FIRST so_mstr */
   end.   /* DO ON ERROR UNDO.. */

   return {&SUCCESS-RESULT}.

END PROCEDURE.   /* verifyExchangeRate */
