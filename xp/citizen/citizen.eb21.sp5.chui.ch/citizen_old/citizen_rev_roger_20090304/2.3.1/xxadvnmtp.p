/* advnmtp.p - SUPPLIER MAINTENANCE update frames b, b1, and c.               */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.41.2.2 $                                                          */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.4      LAST MODIFIED: 08/17/93   BY: cdt *H086*                */
/* REVISION: 7.4      LAST MODIFIED: 12/23/93   BY: tjs *GI35*                */
/* REVISION: 7.4      LAST MODIFIED: 03/09/94   BY: cdt *H291*                */
/* REVISION: 7.4      LAST MODIFIED: 05/23/94   by: bcm *H373*                */
/* REVISION: 7.4      LAST MODIFIED: 07/29/94   BY: bcm *H465*                */
/* REVISION: 7.4      LAST MODIFIED: 09/29/94   BY: bcm *H541*                */
/* REVISION: 7.4      LAST MODIFIED: 11/14/94   BY: str *FT44*                */
/* REVISION: 7.4      LAST MODIFIED: 03/29/95   by: dzn *F0PN*                */
/* REVISION: 7.4      LAST MODIFIED: 08/06/96   BY: *H0M9* Sanjay Patil       */
/* REVISION: 8.6      LAST MODIFIED: 10/10/96   BY: svs *K007*                */
/* REVISION: 8.6      LAST MODIFIED: 10/18/96   BY: jpm *K017*                */
/* REVISION: 8.6      LAST MODIFIED: 10/22/96   BY: *K004* Kurt De Wit        */
/* REVISION: 8.6      LAST MODIFIED: 03/07/96   BY: *K071* M. Madison         */
/* REVISION: 8.6      LAST MODIFIED: 06/10/97   BY: *K0DZ* Arul Victoria      */
/* REVISION: 8.6      LAST MODIFIED: 06/24/97   BY: *K0DH* Arul Victoria      */
/* REVISION: 8.6      LAST MODIFIED: 10/08/97   BY: *K0N1* Jean Miller        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98   BY: *L020* Charles Yen        */
/* REVISION: 8.6E     LAST MODIFIED: 08/05/98   BY: *K1QS* Dana Tunstall      */
/* REVISION: 8.6E     LAST MODIFIED: 08/05/98   BY: *K1RJ* Dana Tunstall      */
/* REVISION: 8.6E     LAST MODIFIED: 08/12/98   BY: *J2W3* Surekha Joshi      */
/* REVISION: 8.6E     LAST MODIFIED: 08/19/98   BY: *L062* Steve Nugent       */
/* REVISION: 9.0      LAST MODIFIED: 11/20/98   BY: *M002* Mayse Lai          */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Brian Compton      */
/* REVISION: 9.1      LAST MODIFIED: 01/19/00   BY: *N077* Vijaya Pakala      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* Revision: 1.29     BY: Jack Rief             DATE: 06/11/00   ECO: *N0B9*  */
/* Revision: 1.30     BY: Falguni Dalal         DATE: 07/21/00   ECO: *M0PQ*  */
/* Revision: 1.31     BY: Mudit Mehta           DATE: 09/22/00   ECO: *N0W2*  */
/* Revision: 1.32     BY: Katie Hilbert         DATE: 04/01/01   ECO: *P002*  */
/* Revision: 1.34     BY: Steve Nugent          DATE: 05/03/01   ECO: *M11Z*  */
/* Revision: 1.36     BY: Niall Shanahan        DATE: 10/22/02   ECO: *N15F*  */
/* Revision: 1.37     BY: Ed van de Gevel       DATE: 12/03/02   ECO: *N1ND*  */
/* Revision: 1.38     BY: Narathip W.           DATE: 04/17/03   ECO: *P0Q4*  */
/* Revision: 1.40     BY: Paul Donnelly (SB)    DATE: 06/26/03   ECO: *Q00B*  */
/* Revision: 1.41     BY: Manjusha Inglay       DATE: 12/29/04   ECO: *P31V*  */
/* Revision: 1.41.2.1 BY: Alok Gupta            DATE: 05/31/05   ECO: *P3N4*  */
/* $Revision: 1.41.2.2 $ BY: Russ Witt   DATE: 09/05/05  ECO: *P37P*  */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*****************************************************************************/
/* THE CHANGES INTRODUCED BY ECO K1QS IN ADDSCLST.I AND ADPRCLST.I           */
/* AFFECT BOTH GRS AND NON GRS PROGRAMS. SINCE THE SCHEMA FOR  GRS           */
/* WAS INTRODUCED IN 8.6 AS OF 8.6C, THE ECO K1QS WAS CREATED FOR            */
/* ALL PROGRAMS INCLUDING GRS PROGRAMS. THE CORRESPONDING PATCH              */
/* FOR NON GRS PROGRAMS IS K1RJ. NO PROGRAM CHANGES HAVE BEEN                */
/* INTRODUCED BY ECO K1RJ.                                                   */
/*****************************************************************************/
/*   Modification added 2 new sub-acct fields.  Frame b was broken up into   */
/*   2 frames, frame b and frame b1a.  The new frame b1a overlays frame b.   */
/*   New frame b1a appears after frame b and before frame b1.                */
/*****************************************************************************/
/* ************************************************************************* */
/* Note: This code has been modified to run when called inside an MFG/PRO API*/
/* method as well as from the MFG/PRO menu, using the global variable        */
/* c-application-mode to conditionally execute API- vs. UI-specific logic.   */
/* Before modifying the code, please review the MFG/PRO API Development Guide*/
/* in the QAD Development Standards for specific API coding standards and    */
/* guidelines.                                                               */
/* ************************************************************************* */

{mfdeclre.i}
{cxcustom.i "ADVNMTP.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{pxmaint.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE advnmtp_p_1 "Auto EMT Processing"
/* MaxLen: Comment: */

&SCOPED-DEFINE advnmtp_p_2 "TID Notice"
/* MaxLen: Comment: */

&SCOPED-DEFINE advnmtp_p_3 "DB Number"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */
define     shared frame a.
define     shared frame b.

define new shared variable tid_notice   as   character format "x(1)"
                                             label {&advnmtp_p_2}.

define     shared variable ad_recno     as   recid.
define     shared variable vd_recno     as   recid.
define     shared variable errfree      like mfc_logical.
define     shared variable undo_adcsmtc like mfc_logical.
define     shared variable promo_old like vd_promo.

define variable del-yn          like mfc_logical.
define variable apm-ex-prg      as character format "x(10)" no-undo.
define variable apm-ex-sub      as character format "x(24)" no-undo.
define variable emt-auto        like mfc_logical label {&advnmtp_p_1} no-undo.
define variable mc-error-number like msg_nbr no-undo.
define variable db_nbr          as character format "x(16)"
                                label {&advnmtp_p_3} no-undo.
define variable error_flag      like mfc_logical no-undo.
define variable error_nbr       like msg_nbr no-undo.

{&ADVNMTP-P-TAG1}
/* COMMON API CONSTANTS AND VARIABLES */
{mfaimfg.i}

/* SUPPLIER API TEMP-TABLES */
{advnit01.i}

if c-application-mode = "API" then do on error undo, return error:

   /* GET HANDLE OF API CONTROLLER */
   {gprun.i ""gpaigh.p""
      "(output ApiMethodHandle,
        output ApiProgramName,
        output ApiMethodName,
        output apiContextString)"}

   /* GET CURRENT VENDOR MASTER IN LOCAL TEMP-TABLE */
   create ttSupplier.
   run getSupplierRecord in ApiMethodHandle
      (buffer ttSupplier) no-error.

   /* GET CURRENT ADDRESS MASTER IN LOCAL TEMP-TABLE */
   create ttAddress.
   run getAddressRecord in ApiMethodHandle
      (buffer ttAddress) no-error.

end.  /* If c-application-mode = "API" */

{xxadvnmt02.i} /*xp001*/

find first soc_ctrl  where soc_ctrl.soc_domain = global_domain no-lock no-error.

find vd_mstr where recid(vd_mstr) = vd_recno exclusive-lock no-error.
find ad_mstr where recid(ad_mstr) = ad_recno exclusive-lock no-error.
{&ADVNMTP-P-TAG13}

errfree = false.
frameloop:
do:
   if c-application-mode <> "API" then
      display
         vd_sort
         vd_type
         vd_pur_acct
         vd_pur_sub
         vd_pur_cc
         vd_ap_acct
         vd_ap_sub
         vd_ap_cc
         vd_shipvia
         vd_rmks
      with frame b.

   loopb:

   do on endkey undo, leave frameloop:
      if vd_sort = "" then vd_sort = ad_name.

      ststatus = stline[3].
      status input ststatus.

      if c-application-mode <> "API" then
         set
            vd_sort
            vd_type
            vd_pur_acct
            vd_pur_sub
            vd_pur_cc
            vd_ap_acct
            vd_ap_sub
            vd_ap_cc
            vd_shipvia
            vd_rmks
         with frame b.
      else  /*if c-application-mode = "API"*/
         assign
            {mfaiset.i vd_sort ttSupplier.vdSort}
            {mfaiset.i vd_type ttSupplier.vdType}
            {mfaiset.i vd_pur_acct ttSupplier.purAcct}
            {mfaiset.i vd_pur_sub ttSupplier.purSub}
            {mfaiset.i vd_pur_cc ttSupplier.purCc}
            {mfaiset.i vd_ap_acct ttSupplier.apAcct}
            {mfaiset.i vd_ap_sub ttSupplier.shipvia}
            {mfaiset.i vd_ap_cc ttSupplier.apCc}
            {mfaiset.i vd_shipvia ttSupplier.vdSort}
            {mfaiset.i vd_rmks ttSupplier.rmks}
         .

      ad_sort = vd_sort.

      {pxrun.i &PROC='validateAccount' &PROGRAM='glacxr.p'
         &PARAM="(input vd_pur_acct,
                  input vd_pur_sub,
                  input vd_pur_cc)"
         &NOAPPERROR=true
         &CATCHERROR=true}

      if return-value <> {&SUCCESS-RESULT} then do:
         if c-application-mode <> "API" then do:
            next-prompt vd_pur_acct with frame b.
            undo, retry.
         end.
         else   /*if c-application-mode ="API"*/
            undo, return error.
      end. /* if return-value <> {&SUCCESS-RESULT} then do: */

      {pxrun.i &PROC='validateAccount' &PROGRAM='glacxr.p'
         &PARAM="(input vd_ap_acct,
                  input vd_ap_sub,
                  input vd_ap_cc)"
         &NOAPPERROR=true
         &CATCHERROR=true}

      if return-value <> {&SUCCESS-RESULT} then do:
         if c-application-mode <> "API" then do:
            next-prompt vd_ap_acct with frame b.
            undo, retry.
         end.
         else   /*if c-application-mode ="API"*/
            undo, return error.
      end. /* if return-value <> {&SUCCESS-RESULT} then do: */

   end. /*END LOOP B */

   /* GET THE CARRIER ID*/
   {pxrun.i &PROC  ='getSupplierExtendFields' &PROGRAM = 'vdvdxr.p'
             &PARAM = "(buffer vd_mstr,
                        output vd_carrier_id,
                        output vd_kanban_supplier)"
       &NOAPPERROR = true
       &CATCHERROR = true}

   if c-application-mode <> "API" then
      {&ADVNMTP-P-TAG14}
      display
         vd_ckfrm
         vd_bank
         vd_pur_cntct
         vd_ap_cntct
         vd_curr
         vd_lang
         vd_promo
         vd_misc_cr
         vd_carrier_id
         vd_kanban_supplier
      with frame b1a.
      {&ADVNMTP-P-TAG15}
      loopb1a:
      do on endkey undo, leave frameloop:
         {&ADVNMTP-P-TAG2}

      if c-application-mode <> "API" then
         set
            vd_bank
            vd_curr
            vd_pur_cntct
            vd_ap_cntct
            vd_promo
            vd_ckfrm
            vd_lang
            vd_misc_cr
            vd_carrier_id
            vd_kanban_supplier
         with frame b1a.
      else  /* C-application-mode = "API" */

         assign
            {mfaiset.i vd_bank      ttSupplier.bank}
            {mfaiset.i vd_curr      ttSupplier.curr}
            {mfaiset.i vd_pur_cntct ttSupplier.purCntct}
            {mfaiset.i vd_ap_cntct  ttSupplier.apCntct}
            {mfaiset.i vd_promo     ttSupplier.promo }
            {mfaiset.i vd_ckfrm     ttSupplier.ckfrm }
            {mfaiset.i vd_lang      ttSupplier.lang }
            {mfaiset.i vd_misc_cr   ttSupplier.miscCr }
         .

      {&ADVNMTP-P-TAG3}

      {pxrun.i &PROC='validateCarrier' &PROGRAM='vdvdxr.p'
         &PARAM="(input vd_carrier_id:SCREEN-VALUE)"
         &NOAPPERROR=true
         &CATCHERROR=true}
      if return-value <> {&SUCCESS-RESULT} then do:
         if c-application-mode <> "API" then do:
            next-prompt vd_carrier_id with frame b1a.
            undo loopb1a, retry.
         end.
         else
            undo loopb1a, return error.
      end.


      {pxrun.i &PROC='validatePromotionGroup' &PROGRAM='adsuxr.p'
         &PARAM="(input vd_promo:SCREEN-VALUE)"
         &NOAPPERROR=true
         &CATCHERROR=true}
      if return-value <> {&SUCCESS-RESULT} then do:
         if c-application-mode <> "API" then do:
            next-prompt vd_promo with frame b1a.
            undo loopb1a, retry.
         end.
         else
            undo loopb1a, return error.
      end.

      ad_lang = vd_lang.

      /* VALIDATE BANK */
      {pxrun.i &PROC='validateBank' &PROGRAM='adsuxr.p'
         &PARAM="(input vd_bank,
                  input vd_curr,
                  input base_curr)"
         &NOAPPERROR=true
         &CATCHERROR=true}
      if return-value = {&APP-ERROR-RESULT} then do:
         if c-application-mode <> "API" then do:
            next-prompt vd_bank with frame b1a.
            undo loopb1a, retry.
         end.
         else
            undo loopb1a, return error.
      end. /* if not available bk_mstr then do: */
      else
      if return-value = {&WARNING-RESULT}
         and c-application-mode <> "API" then do:
         pause.
      end. /* if not available bk_mstr then do: */

      /* VALIDATE CURRENCY CODE */
      {pxrun.i &PROC='validateCurrency' &PROGRAM='mcexxr.p'
         &PARAM="(input vd_curr)"
         &NOAPPERROR=true
         &CATCHERROR=true}
      if return-value <> {&SUCCESS-RESULT} then do:
         if c-application-mode <> "API" then do:
            next-prompt vd_curr with frame b1a.
            undo loopb1a, retry loopb1a.
         end.
         else
            undo loopb1a, return error.
      end.

      {pxrun.i &PROC='validateAccountCurrency' &PROGRAM='adsuxr.p'
         &PARAM="(input vd_pur_acct,
                  input vd_curr,
                  input base_curr,
                  input 'vd_pur_acct')"
         &NOAPPERROR=true
         &CATCHERROR=true}

      if return-value <> {&WARNING-RESULT} then do:
         {pxrun.i &PROC='validateAccountCurrency' &PROGRAM='adsuxr.p'
            &PARAM="(input vd_ap_acct,
                     input vd_curr,
                     input base_curr,
                     input 'vd_ap_acct')"
            &NOAPPERROR=true
            &CATCHERROR=true}
      end.

      /*VERIFY CHECK FORM*/
      {&ADVNMTP-P-TAG4}
      {pxrun.i &PROC='validateCheckForm' &PROGRAM='appmtxr.p'
         &PARAM="(input vd_ckfrm)"
         &NOAPPERROR=true
         &CATCHERROR=true}
      if return-value = {&APP-ERROR-RESULT} then do:
         if c-application-mode <> "API" then do:
            next-prompt vd_ckfrm with frame b1a.
            undo, retry.
         end.
         else
            undo, return error.
      end.

      {pxrun.i &PROC='validateCheckFormCurrency' &PROGRAM='appmtxr.p'
         &PARAM="(input vd_ckfrm,
                  input vd_curr,
                  input base_curr,
                  input {&WARNING-RESULT})"
         &NOAPPERROR=true
         &CATCHERROR=true}

      /* FURTHER CHECK FORM VALIDATION, SPECIFIC TO THIS PROGRAM */
      {pxrun.i &PROC='validateMiscCreditorCheckForm' &PROGRAM='adsuxr.p'
         &PARAM="(input vd_ckfrm,
                  input vd_misc_cr)"
         &NOAPPERROR=true
         &CATCHERROR=true}
      if return-value <> {&SUCCESS-RESULT} then do:
         if c-application-mode <> "API" then do:
            next-prompt vd_ckfrm with frame b1a.
            undo loopb1a, retry.
         end.
         else
            undo loopb1a, return error.
      end. /* if return-value <> {&SUCCESS-RESULT} then do: */
      {&ADVNMTP-P-TAG5}

      /* SET THE CARRIER ID and KANBAN SUPPLIER*/
      {pxrun.i &PROC  ='setSupplierExtendFields' &PROGRAM = 'vdvdxr.p'
             &PARAM = "(buffer vd_mstr,
                        input vd_carrier_id,
                        input vd_kanban_supplier)"
         &NOAPPERROR = true
         &CATCHERROR = true}


      if soc_apm and
         (promo_old <> "" or vd_promo <> "") then do:
         /* Future logic will go here to determine subdirectory*/
         apm-ex-prg = "ifvend.p".
         apm-ex-sub = "if/".
         {gprunex.i
            &module   = 'APM'
            &subdir   = apm-ex-sub
            &program  = 'ifapm057.p'
            &params   = "(input vd_mstr.vd_addr,
                          input vd_mstr.vd_sort,
                          input ad_mstr.ad_attn,
                          input ad_mstr.ad_city,
                          input ad_mstr.ad_country,
                          input ad_mstr.ad_ext,
                          input ad_mstr.ad_fax,
                          input ad_mstr.ad_line1,
                          input ad_mstr.ad_line2,
                          input ad_mstr.ad_line3,
                          input ad_mstr.ad_name,
                          input ad_mstr.ad_phone,
                          input ad_mstr.ad_state,
                          input ad_mstr.ad_zip,
                          output error_flag,
                          output error_nbr)" }
         if error_flag then do:
            {pxmsg.i &MSGNUM=error_nbr &ERRORLEVEL={&APP-ERROR-NO-REENTER-RESULT}}
            /* ERROR OCCURRED UPDATING APM */
            return.
         end. /* if error_flag then do: */
      end. /* (promo_old <> "" or vd_promo <> "") then do: */

   end. /* END LOOP B1A */
   {&ADVNMTP-P-TAG6}
   if c-application-mode <> "API" then
      display
         vd_buyer
         vd_pr_list2
         vd_pr_list
         vd_fix_pr
      with frame b1.

   loopb1:

   do on endkey undo, leave frameloop:

      {&ADVNMTP-P-TAG7}
      if c-application-mode <> "API" then
         set
            vd_buyer
            vd_pr_list2
            vd_pr_list
            vd_fix_pr
         with frame b1.
      else
         assign
            {mfaiset.i vd_buyer ttSupplier.buyer}
            {mfaiset.i vd_pr_list2 ttSupplier.prList}
            {mfaiset.i vd_pr_list ttSupplier.prList2}
            {mfaiset.i vd_fix_pr ttSupplier.fixPr}
         .

      {&ADVNMTP-P-TAG8}

      /* MOVED PRICE TABLE VALIDATION TO adprclst.i */
      /* ADDED TWO ARGUMENTS &DISP-MSG AND &WARNING */
      {adprclst.i
         &price-list     = "vd_pr_list2"
         &curr           = "vd_curr"
         &price-list-req = "no"
         &undo-label     = "loopb1"
         &with-frame     = "with frame b1"
         &disp-msg       = "yes"
         &warning        = "yes" }

      /* MOVED DISCOUNT TABLE VALIDATION TO addsclst.i */
      /* ADDED TWO ARGUMENTS &DISP-MSG AND &WARNING */
      {addsclst.i
         &disc-list      = "vd_pr_list"
         &curr           = "vd_curr"
         &disc-list-req  = "no"
         &undo-label     = "loopb1"
         &with-frame     = "with frame b1"
         &disp-msg       = "yes"
         &warning        = "yes" }

      if soc_apm and
         (promo_old <> "" or vd_promo <> "") then do:
         /* Future logic will go here to determine subdirectory*/
         apm-ex-prg = "ifvend.p".
         apm-ex-sub = "if/".
         {gprunex.i
            &module   = 'APM'
            &subdir   = apm-ex-sub
            &program  = 'ifvend.p'
            &params   = "(input vd_addr)" }
      end. /* (promo_old <> "" or vd_promo <> "") then do: */

   end. /* END LOOP B1 */

   {pxrun.i &PROC='getAutoEMT' &PROGRAM='adsuxr.p'
      &PARAM="(input vd_addr,
               output emt-auto)"
      &NOAPPERROR=true
      &CATCHERROR=true}
   {&ADVNMTP-P-TAG9}

   if c-application-mode <> "API" then
      display
         vd_rcv_so_price
         vd_tp_pct
         vd_rcv_held_so
         vd_tp_use_pct
         emt-auto
         vd__qadl01
      with frame btb.

   loopbtb:

   do on endkey undo, leave frameloop:
      if c-application-mode <> "API" then
         set
           vd_rcv_so_price
           vd_rcv_held_so
           emt-auto
           vd__qadl01
           vd_tp_pct
           vd_tp_use_pct
         with frame btb.
      else do: /*if c-application-mode = "API"*/
         assign
            {mfaiset.i vd_rcv_so_price ttSupplier.rcvSoPrice}
            {mfaiset.i vd_rcv_held_so ttSupplier.rcvHeldSo}
            {mfaiset.i vd__qadl01 ttSupplier.qadl01}
            {mfaiset.i vd_tp_pct ttSupplier.tpPct}
            {mfaiset.i vd_tp_use_pct ttSupplier.tpUsePct}
            .
         emt-auto = true.
      end.

      {pxrun.i &PROC='setAutoEMT' &PROGRAM='adsuxr.p'
         &PARAM="(input vd_addr,
                        input emt-auto)"
         &NOAPPERROR=true
         &CATCHERROR=true}

      {pxrun.i &PROC='validatePriceReduction' &PROGRAM='adsuxr.p'
         &PARAM="(input vd_tp_pct,
                  input vd_tp_use_pct)"
         &NOAPPERROR=true
         &CATCHERROR=true}
      if return-value <> {&SUCCESS-RESULT} then do:
         if c-application-mode <> "API" then
            pause.
      end.

      {pxrun.i &PROC='validatePriceReductionLimit' &PROGRAM='adsuxr.p'
         &PARAM="(input vd_tp_pct)"
         &NOAPPERROR=true
         &CATCHERROR=true}
      if return-value <> {&SUCCESS-RESULT} then do:
         if c-application-mode <> "API" then do:
            next-prompt vd_tp_pct with frame btb.
            undo loopbtb, retry.
         end.
         else
            undo loopbtb, return error.
      end.

   end. /* END LOOP BTB */

   /* FIND QAD_WKFL AND PICK UP TID_NOTICE */
   {pxrun.i &PROC='getTIDNotice' &PROGRAM='adsuxr.p'
      &PARAM="(input vd_addr,
               output tid_notice)"
      &NOAPPERROR=true
      &CATCHERROR=true}

   /* FIND QAD_WKFL AND PICK UP DB_NBR */
   {pxrun.i &PROC='getDBNumber' &PROGRAM='adsuxr.p'
      &PARAM="(input vd_addr,
               output db_nbr)"
      &NOAPPERROR=true
      &CATCHERROR=true}

   if c-application-mode <> "API" then
      display
         vd_cr_terms when (not vd_misc_cr)
         vd_disc_pct
         ad_coc_reg
         vd_partial
         vd_hold
         db_nbr
         ad_taxable @ vd_taxable
         ad_gst_id  @ vd_tax_id
         tid_notice
         vd_prepay
         vd_debtor
         (if vd_misc_cr then no else vd_1099) @ vd_1099
         vd_pay_spec
      with frame c.

      loopc:
   do on endkey undo, leave frameloop:

      ststatus = stline[3].
      status input ststatus.

      /* SET DEFAULTS IN CASE OF MISC CREDITORS */
      {pxrun.i &PROC='setMiscCreditorDefaults' &PROGRAM='adsuxr.p'
         &PARAM="(buffer vd_mstr)"
         &NOAPPERROR=true
         &CATCHERROR=true}

      if c-application-mode <> "API" then
         set
            vd_cr_terms when (not vd_misc_cr)
            vd_disc_pct
            ad_coc_reg
            vd_partial
            vd_hold
            db_nbr
            tid_notice
            vd_prepay
            vd_debtor
            vd_1099    when (not vd_misc_cr)
            vd_pay_spec
         with frame c.
      else do:
          assign
            {mfaiset.i  vd_cr_terms ttSupplier.crTerms}  when (not vd_misc_cr)
            {mfaiset.i  vd_disc_pct ttSupplier.discPct}
            {mfaiset.i  vd_partial ttSupplier.partial}
            {mfaiset.i  vd_hold ttSupplier.hold}
            {mfaiset.i  db_nbr ttSupplier.db}
            {mfaiset.i  vd_taxable ttSupplier.taxable}
            {mfaiset.i  vd_tax_id ttSupplier.taxId}
            {mfaiset.i  vd_prepay ttSupplier.prepay}
            {mfaiset.i  vd_debtor ttSupplier.debtor}
            {mfaiset.i  vd_pay_spec ttSupplier.paySpec}
            .

            if(not vd_misc_cr) then
               vd_1099 = no.

      end.  /*if c-application-mode ="API"*/

      {pxrun.i &PROC='validateCreditTerms' &PROGRAM='adcrxr.p'
         &PARAM="(input vd_cr_terms)"
         &NOAPPERROR=true
         &CATCHERROR=true}
      if return-value <> {&SUCCESS-RESULT} then do:
         if c-application-mode <> "API" then do:
            undo loopc, retry loopc.
         end.
         else
            undo loopc, return error.
      end.

      {&ADVNMTP-P-TAG16}
      /* FIND QAD_WKFL AND STORE TID_NOTICE */
      {pxrun.i &PROC='setTIDNotice' &PROGRAM='adsuxr.p'
         &PARAM="(input vd_addr,
                  input tid_notice)"
         &NOAPPERROR=true
         &CATCHERROR=true}

      /* FIND QAD_WKFL AND STORE DB_NBR */
      {pxrun.i &PROC='setDBNumber' &PROGRAM='adsuxr.p'
         &PARAM="(input vd_addr,
                  input db_nbr)"
         &NOAPPERROR=true
         &CATCHERROR=true}

      {&ADVNMTP-P-TAG10}

      /* INPUT TAX DATA */
      undo_adcsmtc = true.
      ad_recno = recid(ad_mstr).
      {&ADVNMTP-P-TAG11}
      {gprun.i ""adcsmtc.p""}
      if undo_adcsmtc then undo loopc, retry.

   end. /* END LOOP C */

   {&ADVNMTP-P-TAG12}
   errfree = true.

end. /* END FRAMELOOP */
