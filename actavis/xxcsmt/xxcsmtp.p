/* xxcsmtp.p  -  CUSTOMER  MAINTENANCE update frame b and frame b2            */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.45 $                                                          */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.4      LAST MODIFIED:    10/12/93     BY:   cdt    *H086*      */
/* REVISION: 7.4      LAST MODIFIED:    05/23/94     BY:   bcm    *H373*      */
/* REVISION: 7.4      LAST MODIFIED:    07/29/94     BY:   bcm    *H465*      */
/* REVISION: 7.4      LAST MODIFIED:    09/29/94     BY:   bcm    *H541*      */
/* REVISION: 7.4      LAST MODIFIED:    11/07/94     BY:   str    *FT44*      */
/* REVISION: 7.2      LAST MODIFIED:    01/12/95     BY:   ais    *F0C7*      */
/* REVISION: 7.4      LAST MODIFIED:    04/10/95     BY:   jpm    *H0CH*      */
/* REVISION: 7.4      LAST MODIFIED:    08/09/95     BY:   dxb    *H0FG*      */
/* REVISION: 8.5      LAST MODIFIED:    12/17/96     BY: *J1B6* Markus Barone */
/* REVISION: 8.5      LAST MODIFIED:    12/26/97     BY: *J28R* Seema Varma   */
/* REVISION: 8.5      LAST MODIFIED:    01/06/98     BY: *J299* Surekha Joshi */
/* REVISION: 8.6E     LAST MODIFIED:    02/23/98     BY: *L007* A. Rahane     */
/* REVISION: 8.6E     LAST MODIFIED:    04/18/98     BY: *L00R* Adam Harris   */
/* REVISION: 8.6E     LAST MODIFIED:    05/20/98     BY: *K1Q4* Alfred Tan    */
/* REVISION: 8.6E     LAST MODIFIED:    06/19/98     BY: *L01N* Robin McCarthy*/
/* REVISION: 8.6E     LAST MODIFIED:    07/21/98     BY: *L04G* Robin McCarthy*/
/* REVISION: 8.6E     LAST MODIFIED:    08/05/98     BY: *K1QS* Dana Tunstall */
/* REVISION: 8.6E     LAST MODIFIED:    08/05/98     BY: *K1RJ* Dana Tunstall */
/* REVISION: 8.6E     LAST MODIFIED:    08/18/98     BY: *K1DQ* Suresh Nayak  */
/* REVISION: 9.0      LAST MODIFIED:    11/09/98     BY: *M00R* Markus Barone */
/* REVISION: 9.0      LAST MODIFIED:    02/11/99     BY: *M082* Steve Nugent  */
/* REVISION: 9.0      LAST MODIFIED:    03/10/99     BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED:    03/13/99     BY: *M0BD* Alfred Tan    */
/* REVISION: 9.1      LAST MODIFIED:    10/01/99     BY: *N014* Robin McCarthy*/
/* REVISION: 9.1      LAST MODIFIED:    01/18/00     BY: *N077* Vijaya Pakala */
/* REVISION: 9.1      LAST MODIFIED:    02/04/00     BY: *N03S* Hemanth Ebenezer*/
/* REVISION: 9.1      LAST MODIFIED:    04/18/00     BY: *N03T* Jack Rief     */
/* REVISION: 9.1      LAST MODIFIED:    05/08/00     BY: *N0B0* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED:    08/17/00     BY: *N0LJ* Mark Brown    */
/* REVISION: 9.1      LAST MODIFIED:    10/17/00     BY: *M0V4* Kirti Desai   */
/* REVISION: 9.1      LAST MODIFIED:    09/20/00     BY: *N0W2* Mudit Mehta   */
/* Revision: 1.37     BY: Katie Hilbert DATE: 04/01/01   ECO: *P002*          */
/* Revision: 1.38     BY: Rajesh Kini   DATE: 09/26/01   ECO: *N136*          */
/* Revision: 1.39     BY: Hualin Zhong  DATE: 10/25/01   ECO: *P010*          */
/* Revision: 1.40  BY: Amit Chaturvedi DATE: 01/20/03 ECO: *N20Y* */
/* Revision: 1.42  BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00B* */
/* Revision: 1.43  BY: Rajaneesh S.       DATE: 08/26/03 ECO: *N2JB* */
/* Revision: 1.44  BY: Preeti Sattur      DATE: 03/03/04 ECO: *P1RR* */
/* $Revision: 1.45 $ BY: Vandna Rohira      DATE: 01/25/05 ECO: *P359* */
/*111205.1 - add address columns to 66 character length.                      */
/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{cxcustom.i "ADCSMTP.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{pxmaint.i}

/* THE CHANGES INTRODUCED BY ECO K1QS IN ADDSCLST.I AND ADPRCLST.I   */
/* AFFECT BOTH GRS AND NON GRS PROGRAMS. SINCE THE SCHEMA FOR  GRS   */
/* WAS INTRODUCED IN 8.6 AS OF 8.6C, THE ECO K1QS WAS CREATED FOR    */
/* ALL PROGRAMS INCLUDING GRS PROGRAMS. THE CORRESPONDING PATCH      */
/* FOR NON GRS PROGRAMS IS K1RJ. NO PROGRAM CHANGES HAVE BEEN        */
/* INTRODUCED BY ECO K1RJ.                                           */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE adcsmtp_p_2 "Capture Self-Billing Information"
/* MaxLen: Comment:                                            */

/* ********** End Translatable Strings Definitions ********* */

define shared  variable mult_slspsn like mfc_logical no-undo.

define         variable is-union    like mfc_logical no-undo.
define         variable is-member   like mfc_logical no-undo.
define         variable old_curr    like cm_curr     no-undo.
define         variable new_curr    like cm_curr. /* CANNOT BE no-undo */

define shared frame a.
define shared frame b.
define shared frame b2.
define shared variable tax_recno    as   recid.
define shared variable cm_recno     as   recid.
define shared variable ad_recno     as   recid.
define shared variable undo_adcsmtc like mfc_logical.
define shared variable errfree      like mfc_logical.
define shared variable new_cmmstr   as   logical no-undo.

{&ADCSMTP-P-TAG1}
{etvar.i &new="new"}

/* DISPLAY SELECTION FORM */
{xxcsmt02.i}

/* FRAME TO UPDATE CUSTOMER TIME ZONE */
form
   space(1)
   ad_timezone
   space(2)
with frame tz-popup overlay row (frame-row(b2) - 1)
   centered side-labels attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame tz-popup:handle).

form
   space(1)
   cm__qad06 label {&adcsmtp_p_2}
   space(1)
with frame selfbill overlay row (frame-row(b2) - 1)
   centered side-labels attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame selfbill:handle).

find first gl_ctrl   where gl_ctrl.gl_domain = global_domain no-lock no-error.

find first svc_ctrl  where svc_ctrl.svc_domain = global_domain no-lock no-error.

find cm_mstr where recid(cm_mstr) = cm_recno exclusive-lock no-error.
find ad_mstr where recid(ad_mstr) = ad_recno exclusive-lock no-error.

errfree = false.

loopb:
{&ADCSMTP-P-TAG2}
do on endkey undo, leave:
{&ADCSMTP-P-TAG3}

   {pxrun.i &PROC = 'setSortName' &PROGRAM = 'adcuxr.p'
      &PARAM = "(buffer cm_mstr,
                 input ad_name)"
      &NOAPPERROR=true
      &CATCHERROR=true
      }

   ststatus = stline[3].
   status input ststatus.

   display
      cm_sort
      cm_type
      cm_region
      cm_slspsn[1]
      mult_slspsn
      cm_shipvia
      cm_resale
      cm_rmks
      cm_ar_acct
      cm_ar_sub
      cm_ar_cc
      cm_curr
      cm_lang
      cm_site
      cm_scurr when (et_print_dc)
   with frame b.

   old_curr = cm_curr.

   if cm_curr <> ""
      and et_print_dc
   then do:

      /* CHECK IF CUSTOMER CURRENCY IS UNION CURRENCY */

      {pxrun.i &PROC = 'validateCurrencyInUnion' &PROGRAM = 'mcexxr.p'
         &PARAM = "(input cm_curr,
                    output union-curr,
                    output is-union,
                    output is-member)"
         &NOAPPERROR=true
         &CATCHERROR=true
         }

   end. /* IF cm_curr <> "" AND et_print_dc */

   setb:
   do on error undo, retry:

      if old_curr <> cm_curr
         and cm_curr <> ""
         and et_print_dc
      then do:

         {pxrun.i &PROC = 'validateCurrency' &PROGRAM = 'adcuxr.p'
            &PARAM = "(input cm_curr,
                       output is-union,
                       output is-member)"
            &NOAPPERROR=true
            &CATCHERROR=true
            }

      end.  /* IF cm_curr <> "" AND et_print_dc */

      hide frame tz-popup.

      set
         cm_sort
         cm_slspsn[1]
         mult_slspsn
         cm_shipvia
         cm_ar_acct
         cm_ar_sub
         cm_ar_cc
         cm_resale
         cm_rmks
         cm_type
         cm_region
         cm_curr
         cm_scurr when (et_print_dc
                   and (new_cmmstr
                    or is-union
                    or is-member
                    or new_curr <> old_curr))
         cm_site
         cm_lang
      with frame b.

      new_curr = input cm_curr.

      /* UPDATION OF END USER DETAILS WITH CORRESPONDING */
      /* ADDRESS MASTER DETAILS.                         */

      find first eu_mstr
         where eu_domain = global_domain
         and   eu_addr   = ad_addr
      exclusive-lock no-error.
      if available eu_mstr
      then
         eu_lang = cm_lang.

      release eu_mstr.

      if cm_slspsn[1] <> ""
      then do:

         /* FIND THE sp_mstr RECORD. */

         {pxrun.i &PROC = 'processRead' &PROGRAM = 'adspxr.p'
            &PARAM = "(input cm_slspsn[1],
                       input false,
                       input false,
                       buffer sp_mstr)"
            &NOAPPERROR=true
            &CATCHERROR=true
            }
         if return-value <> {&SUCCESS-RESULT}
         then do:

            /* SALES PERSON DOES NOT EXIST */
            {pxmsg.i &MSGNUM=612 &ERRORLEVEL={&APP-ERROR-RESULT}}
            next-prompt cm_slspsn[1] with frame b.
            undo setb, retry.
         end. /* IF NOT AVAILABLE sp_mstr THEN DO: */

      end. /* IF cm_slspsn[1] <> "" THEN DO: */

      {pxrun.i &PROC = 'validateAccount' &PROGRAM = 'glacxr.p'
         &PARAM = "(input cm_ar_acct,
                    input cm_ar_sub,
                    input cm_ar_cc)"
         &NOAPPERROR=true
         &CATCHERROR=true
         }
      if return-value <> {&SUCCESS-RESULT}
      then do:

         next-prompt cm_ar_acct with frame b.
         undo, retry.
      end. /* IF return-value <> {&SUCCESS-RESULT} THEN DO: */

      {pxrun.i &PROC = 'validateCurrencyCode' &PROGRAM = 'adcuxr.p'
         &PARAM = "(input old_curr,
                    input new_curr)"
         &NOAPPERROR=true
         &CATCHERROR=true
         }
      if return-value <> {&SUCCESS-RESULT}
      then do:

         next-prompt cm_curr with frame b.
         undo setb, retry.
      end. /* IF return-value <> {&SUCCESS-RESULT} THEN DO: */

      {pxrun.i &PROC = 'validateAccountCurrency' &PROGRAM = 'adcuxr.p'
              &PARAM = "(input cm_ar_acct,
                         input cm_curr,
                         input base_curr)"
              &NOAPPERROR=true
              &CATCHERROR=true
      }
      if return-value <> {&SUCCESS-RESULT}
      then do:

         next-prompt cm_ar_acct with frame b.
         undo setb, retry.
      end. /* IF return-value <> {&SUCCESS-RESULT} */

      if cm_scurr <> ""
         and et_print_dc
      then do:

         /* VALIDATE RELATIONSHIP OF DUAL PRICING CURRENCY TO CUSTOMER
         CURRENCY.  THE CUSTOMER CURRENCY MUST BE AN EMU CURRENCY TO
         USE DUAL PRICING CURRENCY.  BOTH CURRENCIES CANNOT BE
         MEMBER CURRENCIES OR THE SAME CURRENCY. */

         if old_curr <> new_curr
         then do:

            {pxrun.i &PROC = 'validateCurrencyInUnion' &PROGRAM = 'mcexxr.p'
               &PARAM = "(input cm_curr,
                          output union-curr,
                          output is-union,
                          output is-member)"
               &NOAPPERROR=true
               &CATCHERROR=true
               }

         end.  /* IF old_curr <> cm_curr */

         {pxrun.i &PROC = 'validateUnionCurrency' &PROGRAM = 'mcexxr.p'
            &PARAM = "(input is-union,
                       input is-member)"
            &NOAPPERROR=true
            &CATCHERROR=true
            }

         if return-value <> {&SUCCESS-RESULT}
         then do:

            next-prompt cm_curr with frame b.
            undo setb, retry.
         end. /* IF return-value <> {&SUCCESS-RESULT} THEN DO: */

         /* VALIDATE DUAL PRICING CURRENCY CODE */

         {pxrun.i &PROC = 'validateCurrency' &PROGRAM = 'mcexxr.p'
            &PARAM = "(input cm_scurr)"
            &NOAPPERROR=true
            &CATCHERROR=true
            }

         if return-value <> {&SUCCESS-RESULT}
         then do:

            next-prompt cm_scurr with frame b.
            undo setb, retry.
         end. /* IF return-value <> {&SUCCESS-RESULT} THEN DO: */

         {pxrun.i &PROC = 'validateDualCurrencies' &PROGRAM = 'adcuxr.p'
            &PARAM = "(input cm_curr,
                       input cm_scurr)"
            &NOAPPERROR=true
            &CATCHERROR=true
            }
         if return-value <> {&SUCCESS-RESULT}
         then do:

            next-prompt cm_scurr with frame b.
            undo setb, retry.
         end. /* IF return-value <> {&SUCCESS-RESULT} THEN DO: */

         /* IF CUSTOMER CURRENCY IS UNION CURRENCY, THEN DUAL PRICING
         CURRENCY MUST BE MEMBER CURRENCY. */
         if is-union
         then do:

            {pxrun.i &PROC = 'validateCurrencyIsMember' &PROGRAM = 'mcexxr.p'
               &PARAM = "(input cm_scurr,
                          output union-curr,
                          output is-member)"
               &NOAPPERROR=true
               &CATCHERROR=true
               }
            if not is-member
            then do:

               /* SECOND CURRENCY MUST BE EMU CURRENCY */
               {pxmsg.i &MSGNUM=2561 &ERRORLEVEL={&APP-ERROR-RESULT}}
               next-prompt cm_scurr with frame b.
               undo setb, retry.
            end. /* IF NOT is-member THEN DO: */
         end. /* IF is-union */
         else do:

            /* CUSTOMER CURRENCY IS A MEMBER CURRENCY, THEREFORE
            DUAL PRICING CURRENCY MUST BE UNION CURRENCY. */

            {pxrun.i &PROC = 'validateCurrencyIsUnion' &PROGRAM = 'mcexxr.p'
               &PARAM = "(input cm_scurr,
                          output is-union)"
               &NOAPPERROR=true
               &CATCHERROR=true
               }
            if not is-union
            then do:

               /* ONE CURRENCY MUST BE A UNION CURRENCY */
               {pxmsg.i &MSGNUM=2753 &ERRORLEVEL={&APP-ERROR-RESULT}}
               if old_curr <> cm_curr
               then
                  next-prompt cm_curr with frame b.
               else
                  next-prompt cm_scurr with frame b.
               undo setb, retry.
            end. /* if not is-union then do: */
         end.  /* ELSE DO */
      end.  /* IF cm_scurr <> "" AND et_print_dc */

      {pxrun.i &PROC = 'setSortFields' &PROGRAM = 'adadxr.p'
         &PARAM = "(buffer ad_mstr,
                    input cm_lang,
                    input cm_sort)"
         &NOAPPERROR=true
         &CATCHERROR=true
         }

      /* UPDATE MULTIPLE SALESPERSONS IN SUBROUTINE */
      if mult_slspsn
      then do:

         cm_recno = recid(cm_mstr).
         {gprun.i ""adcsmta.p""}
      end. /* IF mult_slspsn THEN DO: */

      /* NEW FIELD ADDED AS cm__qadl01 */
      display
         cm_pr_list2
         cm_pr_list
         cm_fix_pr
         ad_taxable @ cm_taxable
         cm_sic
         cm_partial
         cm_class
         cm__qadl01
      with frame b2.

      setb2:
      do on error undo, retry:

         set
            cm_pr_list2
            cm_pr_list
            cm_fix_pr
            cm_class
            cm_sic
            cm_partial
            cm__qadl01
         with frame b2.

         /* PRICE TABLE VALIDATION */
         /* ADDED TWO ARGUMENTS &DISP-MSG AND &WARNING */

         {adprclst.i &price-list     = "cm_mstr.cm_pr_list2"
            &curr           = "cm_mstr.cm_curr"
            &price-list-req = "no"
            &undo-label     = "setb2"
            &with-frame     = "with frame b2"
            &disp-msg       = "yes"
            &warning        = "yes" }

         /* DISCOUNT TABLE VALIDATION */
         /* ADDED TWO ARGUMENTS &DISP-MSG AND &WARNING */

         {addsclst.i &disc-list      = "cm_mstr.cm_pr_list"
            &curr           = "cm_mstr.cm_curr"
            &disc-list-req  = "no"
            &undo-label     = "setb2"
            &with-frame     = "with frame b2"
            &disp-msg       = "yes"
            &warning        = "yes" }

         undo_adcsmtc = true.
         {&ADCSMTP-P-TAG4}
         {gprun.i ""adcsmtc.p""}
         if undo_adcsmtc
         then
            undo setb2, retry.

         /* ALLOW UPDATE OF CUSTOMER TIME ZONE IF MTZ ENABLED */

         if {pxfunct.i &FUNCTION = 'ifMultiTimeZone' &PROGRAM = 'adadxr.p' }
         then do:

            display
               ad_timezone
            with frame tz-popup.

            /* IF AN END USER SHARES THE SAME ADDRESS RECORD, THEN   */
            /* THE TZ IS DISPLAY ONLY HERE, AND MUST BE CHANGED THRU */
            /* THE END USER TIME ZONE CHANGE UTILITY.                */

            if {pxfunct.i &FUNCTION = 'isTimeZoneEnabled' &PROGRAM = 'adadxr.p'
               &PARAM = "input ad_addr"
               }
            then do:

               {pxrun.i &PROC = 'getDefaultTimeZone' &PROGRAM = 'adadxr.p'
                  &PARAM = "(input ad_addr,
                             output ad_timezone)"
                  &NOAPPERROR=true
                  &CATCHERROR=true
                  }

               settz:
               do on error  undo, retry
                  on endkey undo setb, retry setb:
                  set
                     ad_timezone
                  with frame tz-popup.

                  /* VALIDATE TIME ZONE AGAINST TZO_MSTR */

                  {pxrun.i &PROC = 'validateTimeZone' &PROGRAM = 'adadxr.p'
                     &PARAM = "(input ad_addr,
                                input ad_timezone)"
                     &NOAPPERROR=true
                     &CATCHERROR=true
                     }
                  if return-value <> {&SUCCESS-RESULT}
                  then
                     undo settz, retry settz.
               end.  /* settz */
            end.  /* IF isTimeZoneEnabled */
            else
               if not batchrun
               then
                  pause.

            hide frame tz-popup no-pause.
         end.  /* IF svc_multi_time_zones */

         if {pxfunct.i &FUNCTION = 'isSelfBilling' &PROGRAM = 'adcuxr.p' }
         then do:

            do on endkey undo , leave:
               update
                  cm__qad06
               with frame selfbill.
            end. /* do on endkey undo , leave: */
            hide frame selfbill.
         end. /* IF isSelfBilling() THEN DO: */

      end. /* setb2 */
   end. /* setb */

   errfree = true.
   {&ADCSMTP-P-TAG5}
end. /* END LOOP B */
