/* adcsrp01.p - CUSTOMER MASTER REPORT                                        */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.27 $                                                               */
/*V8:ConvertMode=FullGUIReport                                                */
/* REVISION: 1.0      LAST MODIFIED: 09/16/86   BY: PML  13                   */
/* REVISION: 6.0      LAST MODIFIED: 03/08/90   BY: pml *D001*                */
/* REVISION: 6.0      LAST MODIFIED: 12/13/90   BY: dld *D257*                */
/* REVISION: 6.0      LAST MODIFIED: 07/16/91   BY: afs *D776*                */
/* REVISION: 7.0      LAST MODIFIED: 11/22/91   BY: afs *F056*                */
/* REVISION: 7.4      LAST MODIFIED: 08/25/93   BY: tjs *H082*                */
/* REVISION: 7.4      LAST MODIFIED: 10/15/93   BY: jjs *H181*                */
/* REVISION: 7.4      LAST MODIFIED: 10/18/93   BY: cdt *H086*                */
/* REVISION: 7.4      LAST MODIFIED: 11/30/93   BY: tjs *H081*                */
/*           7.2                     08/30/94   BY: bcm *FQ43*                */
/* REVISION: 8.5      LAST MODIFIED: 07/07/95   BY: cdt *J057*                */
/* REVISION: 8.5      LAST MODIFIED: 11/01/96   BY: *H0NT* Suresh Nayak       */
/* REVISION: 8.6      LAST MODIFIED: 03/17/97   BY: *K07Z* Arul Victoria      */
/* REVISION: 8.6      LAST MODIFIED: 10/16/97   BY: gyk *K12B*                */
/* REVISION: 8.6      LAST MODIFIED: 10/29/97   BY: *H1G4* Manish K.          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 11/21/98   BY: *J353* Reetu Kapoor       */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Robin McCarthy     */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 05/12/00   BY: *N09X* Antony Babu        */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.21     BY: Katie Hilbert         DATE: 04/01/01  ECO: *P002*   */
/* Revision: 1.22     BY: Hualin Zhong          DATE: 10/25/01  ECO: *P010*   */
/* Revision: 1.23     BY: Ed van de Gevel       DATE: 11/05/01  ECO: *N15L*  */
/* Revision: 1.24     BY: Narathip W.           DATE: 05/03/03  ECO: *P0R5* */
/* Revision: 1.26     BY: Paul Donnelly (SB)    DATE: 06/26/03  ECO: *Q00B* */
/* $Revision: 1.27 $       BY: Vivek Gogte           DATE: 07/08/04  ECO: *P292* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdtitle.i "1+ "}
{cxcustom.i "ADCSRP01.P"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE adcsrp01_p_7 "Slspsn[1]"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define variable code like cm_addr.
define variable code1 like cm_addr.
define variable name like ad_name.
define variable name1 like ad_name.
define variable zip like ad_zip.
define variable zip1 like ad_zip.
define variable type like cm_type.
define variable type1 like cm_type.
define variable region like cm_region.
define variable region1 like cm_region.
define variable slspsn like sp_addr.
define variable slspsn1 like slspsn.
define variable under as character format "x(78)".
define variable bk_acct_type like csbd_type.
{&ADCSRP01-P-TAG1}
define variable bk_acct_type_desc like glt_desc.

{&ADCSRP01-P-TAG2}
form
   code           colon 15
   code1          label {t001.i} colon 49 skip
   name           colon 15
   name1          label {t001.i} colon 49 skip
   zip            colon 15
   zip1           label {t001.i} colon 49 skip
   type           colon 15
   type1          label {t001.i} colon 49 skip
   region         colon 15
   region1        label {t001.i} colon 49 skip
   slspsn         colon 15
   slspsn1        label {t001.i} colon 49 skip
with frame a side-labels          width 80.
{&ADCSRP01-P-TAG3}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   csbd_bank
   bk_acct_type
   csbd_edi format "x(9)"
   csbd_branch
   csbd_bk_acct format "x(24)"
   csbd_beg_date
   csbd_end_date
with down frame csbd width 80
   title color normal (getFrameTitle("BANK_ACCOUNTS_DATA",26)).

/* SET EXTERNAL LABELS */
setFrameLabels(frame csbd:handle).

under = caps(dynamic-function('getTermLabelFillCentered' in h-label,
   input "CUSTOMER_ADDRESS",
   input 78,
   input "=")).

{wbrp01.i}
repeat:
   if code1 = hi_char then code1 = "".
   if name1 = hi_char then name1 = "".
   if type1 = hi_char then type1 = "".
   if zip1 = hi_char then zip1 = "".
   if region1 = hi_char then region1 = "".
   if slspsn1 = hi_char then slspsn1 = "".

   if c-application-mode <> 'web' then
   {&ADCSRP01-P-TAG4}
   update code code1 name name1 zip zip1 type type1 region region1
      slspsn slspsn1 with frame a.

   {wbrp06.i &command = update &fields = "  code code1 name name1 zip
        zip1 type type1 region region1 slspsn slspsn1" &frm = "a"}

   {&ADCSRP01-P-TAG5}
   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      bcdparm = "".
      {mfquoter.i code      }
      {mfquoter.i code1     }
      {mfquoter.i name      }
      {mfquoter.i name1     }
      {mfquoter.i zip       }
      {mfquoter.i zip1      }
      {mfquoter.i type      }
      {mfquoter.i type1     }
      {mfquoter.i region    }
      {mfquoter.i region1   }
      {mfquoter.i slspsn    }
      {mfquoter.i slspsn1   }

      {&ADCSRP01-P-TAG6}
      if code1 = "" then code1 = hi_char.
      if name1 = "" then name1 = hi_char.
      if type1 = "" then type1 = hi_char.
      if zip1 = "" then zip1 = hi_char.
      if region1 = "" then region1 = hi_char.
      if slspsn1 = "" then slspsn1 = hi_char.

   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 80
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

   {mfphead2.i}

   for each cm_mstr
          where cm_mstr.cm_domain = global_domain and  (cm_addr >= code and
          cm_addr <= code1)
         and (cm_sort >= name and cm_sort <= name1)
         and (cm_type >= type and cm_type <= type1)
         and (cm_region >= region and cm_region <= region1)
         and (cm_slspsn[1] >= slspsn and cm_slspsn[1] <= slspsn1)
      no-lock by cm_sort:

      find ad_mstr  where ad_mstr.ad_domain = global_domain and  ad_addr =
      cm_addr no-lock.
      if (ad_zip >= zip and ad_zip <= zip1) then do:

         /* DISPLAY SELECTION FORM */
         {&ADCSRP01-P-TAG7}
         form
            skip
            cm_addr        colon 10
            ad_name        colon 10
            ad_line1       colon 10
            ad_line2       colon 10
            ad_line3       colon 10
            ad_city        colon 10
            ad_state
            ad_zip         colon 56
            ad_country     colon 10
            ad_ctry  colon 42 no-label
            ad_county      colon 56
            ad_attn        colon 10
            ad_attn2       label "[2]" colon 43
            ad_phone       colon 10
            ad_ext
            ad_phone2      label "[2]" colon 43
            ad_ext2
            ad_fax         colon 10
            ad_fax2        label "[2]" colon 43
            ad_date
         with frame a1 title color normal under side-labels width 80
            attr-space.
         {&ADCSRP01-P-TAG8}

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a1:handle).

         form
            cm_sort        colon 10
            cm_type        colon 48
            cm_taxable     colon 68
            cm_taxc        no-label
            cm_slspsn[1]   colon 10 label {&adcsrp01_p_7}
            cm_slspsn[2]   colon 26 label "[2]"
            cm_region      colon 48
            cm_pr_list2    colon 68

            cm_shipvia     colon 10
            cm_curr        colon 48
            cm_pr_list     colon 68

            cm_ar_acct     colon 10
            cm_ar_sub      no-label
            cm_ar_cc       no-label
            cm_lang        colon 48
            cm_fix_pr      colon 68

            cm_resale      colon 10
            cm_site        colon 48
            cm_class       colon 68

            cm_sic         colon 10
            cm_partial     colon 48

            cm_rmks        colon 10
         with frame b title color normal
            (getFrameTitle("CUSTOMER_DATA",20)) side-labels
            width 80
            attr-space.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame b:handle).

         form
            cm_cr_limit    colon 15
            cm_disc_pct    colon 41
            cm_bill        colon 61

            cm_cr_terms    colon 15
            cm_fin         colon 41
            cm_high_cr     colon 61

            cm_cr_hold     colon 15
            cm_stmt        colon 41
            cm_high_date   colon 61

            cm_cr_rating   colon 15
            cm_stmt_cyc    colon 41
            cm_sale_date   colon 61

            cm_db          colon 15
            cm_dun         colon 41
            cm_pay_date    colon 61

            cm_po_req      colon 15
            cm_cr_review   colon 61
            cm_cr_update   colon 61
         with frame c title color normal
            (getFrameTitle("CUSTOMER_CREDIT_DATA",29)) side-labels
            width 80
            attr-space.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame c:handle).

         form
            cm_fr_list    colon 15
            cm_fr_min_wt  colon 15
            fr_um         no-label
            cm_fr_terms   colon 15
         with frame d title color normal
            (getFrameTitle("CUSTOMER_FREIGHT_DATA",30)) side-labels
            width 80 attr-space.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame d:handle).

         form
            cm_btb_type    colon 20
            cm_ship_lt     colon 55
            cm_btb_mthd    colon 20
            cm_btb_cr      colon 55
         with frame e title color normal
            (getFrameTitle("ENTERPRISE_MATERIAL_TRANSFER_DATA",46))
            side-labels width 80 attr-space.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame e:handle).

         {&ADCSRP01-P-TAG9}
         display cm_addr ad_name ad_line1 ad_line2 ad_line3 ad_city
            ad_state ad_zip ad_country
            ad_ctry
            ad_county
            ad_attn ad_phone ad_ext ad_attn2 ad_phone2 ad_ext2
            ad_fax ad_fax2 ad_date with frame a1.

         display cm_sort cm_type cm_region cm_slspsn[1]
            cm_slspsn[2]
            cm_ar_acct
            cm_ar_sub
            cm_ar_cc cm_resale cm_shipvia cm_rmks
            cm_pr_list
            ad_taxable  @ cm_taxable
            ad_taxc @ cm_taxc
            cm_partial cm_curr cm_lang
            cm_fix_pr
            cm_pr_list2
            cm_class cm_site
            cm_sic
         with frame b.

         display cm_cr_limit cm_fin cm_high_cr cm_cr_terms cm_dun
            cm_stmt cm_stmt_cyc  cm_disc_pct cm_bill
            cm_high_date cm_db cm_cr_rating cm_pay_date cm_cr_hold
            cm_cr_review cm_cr_update
            cm_sale_date
            cm_po_req

         with frame c.

         find fr_mstr  where fr_mstr.fr_domain = global_domain and  fr_list =
         cm_fr_list
            and fr_site = cm_site
            and fr_curr = cm_curr
         no-lock no-error.
         display cm_fr_list cm_fr_min_wt
            fr_um when (available fr_mstr)
            cm_fr_terms with frame d.

         display cm_btb_type cm_ship_lt cm_btb_mthd cm_btb_cr
         with frame e.

         /*DISPLAY ALL BANK ACCOUNTS FOR CUSTOMER */
         for each csbd_det  where csbd_det.csbd_domain = global_domain and
         csbd_addr = cm_addr no-lock:
            /* GET MNEMONIC FOR ACCOUNT TYPE FROM lngd_det */
            {gplngn2a.i &file     = ""csbd_det""
               &field    = ""bk_acct_type""
               &code     = csbd_type
               &mnemonic = bk_acct_type
               &label    = bk_acct_type_desc}

            display csbd_bank
               bk_acct_type
               csbd_edi
               csbd_branch
               csbd_bk_acct
               csbd_beg_date
               csbd_end_date when (csbd_end_date <> hi_date)
               "" when (csbd_end_date = hi_date) @ csbd_end_date
            with frame csbd.
            down 1 with frame csbd.

            /* ALLOW USER TO EXIT IF F4 PRESSED OR MAX LINE/PAGE REACHED */
            {mfrpchk.i}
         end. /* for each csbd_det where csbd_addr = cm_addr no-lock: */

         {&ADCSRP01-P-TAG10}
         {mfrpchk.i}
      end. /* if (ad_zip >= zip and ad_zip <= zip1) then do: */
   end. /* for each cm_mstr */
   /* REPORT TRAILER  */

   {mfrtrail.i}

end. /* repeat: */

{wbrp04.i &frame-spec = a}
