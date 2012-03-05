/* apvorp.p - AP DETAIL VOUCHER REGISTER REPORT                               */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.11.2.11 $                                                         */
/*V8:ConvertMode=FullGUIReport                                                */
/* REVISION: 1.0      LAST MODIFIED: 10/20/86   BY: PML                       */
/* REVISION: 6.0      LAST MODIFIED: 02/20/91   BY: bjb *D326*                */
/* REVISION: 6.0      LAST MODIFIED: 04/04/91   BY: MLV *D499*                */
/* REVISION: 6.0      LAST MODIFIED: 05/10/91   BY: MLV *D640*                */
/* REVISION: 7.0      LAST MODIFIED: 08/05/91   BY: MLV *F001*                */
/* REVISION: 7.0      LAST MODIFIED: 08/20/91   BY: MLV *F002*                */
/* REVISION: 7.0      LAST MODIFIED: 01/13/92   BY: MLV *F082*                */
/* REVISION: 7.0      LAST MODIFIED: 01/27/92   BY: MLV *F098*                */
/* REVISION: 7.0      LAST MODIFIED: 03/02/92   BY: MLV *F461*                */
/* REVISION: 7.3      LAST MODIFIED: 08/03/92   by: jms *G024* (rev only)     */
/*                                   10/09/92   by: jms *G161* (rev only)     */
/* REVISION: 7.3      LAST MODIFIED: 09/27/93   By: jcd *G247*                */
/*                                   04/20/93   BY: jms *G985* (rev only)     */
/*                                   07/26/93   BY: wep *GD59* (rev only)     */
/*                                   08/26/93   BY: bcm *H054* (rev only)     */
/*                                   08/24/94   BY: cpp *GL39*                */
/* Oracle changes (share-locks)    09/11/94           BY: rwl *FR10*          */
/* REVISION: 7.4      LAST MODIFIED: 10/27/94   BY: ame *FS90*                */
/* REVISION: 8.5      LAST MODIFIED: 02/02/96   by: mwd *J053*                */
/* REVISION: 8.5      LAST MODIFIED: 02/29/96   BY: *J0CV* Brandy J Ewing     */
/*                                   04/05/96   BY: jzw *G1T9*                */
/* REVISION: 8.6      LAST MODIFIED: 10/09/97   by: ckm *K0MX*                */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 04/10/98   BY: *L00K* rvsl               */
/* REVISION: 8.6E     LAST MODIFIED: 07/23/98   BY: *L03K* Jeff Wootton       */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* Pre-86E commented code removed, view in archive revision 1.10              */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/07/00   BY: *M0QW* Falguni Dalal      */
/* REVISION: 9.1      LAST MODIFIED: 08/23/00   BY: *N0ND* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 10/25/00   BY: *N0T7* Jean Miller        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.11.2.7  BY: Ed van de Gevel       DATE: 11/09/01  ECO: *N15N*  */
/* Revision: 1.11.2.8  BY: Mercy C.              DATE: 03/18/02  ECO: *M1WF*  */
/* $Revision: 1.11.2.11 $    BY: Orawan S.             DATE: 04/23/03  ECO: *P0QC* */
/* $Revision: 1.11.2.11 $    BY: Bill Jiang             DATE: 10/25/05  ECO: *SS - 20051025* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/******************************************************************************/

/* SS - 20051025 - B */
{a6apvorptt01.i "new"}
/* SS - 20051025 - E */

{mfdtitle.i "2+ "}
{cxcustom.i "APVORP.P"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE apvorp_p_1 "Supplier Type"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorp_p_2 "Summary/Detail"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorp_p_3 "Sort by Supplier"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorp_p_4 "Open Only"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorp_p_5 "Print GL Detail"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorp_p_6 "Print Unconfirmed"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorp_p_7 "Print Purchase Receipts"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorp_p_8 "Print Confirmed"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorp_p_9 "ERS Only"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorp_p_10 "Mixed Currencies"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/*DEFINE WORKFILE FOR CURRENCY TOTALS*/
{gpacctp.i "new"}

define new shared variable vend like ap_vend.
define new shared variable vend1 like ap_vend.
define new shared variable ref like ap_ref.
define new shared variable ref1 like ap_ref.
define new shared variable batch like ap_batch.
define new shared variable batch1 like ap_batch.
define new shared variable apdate like ap_date.
define new shared variable apdate1 like ap_date.
define new shared variable effdate like ap_effdate.
define new shared variable effdate1 like ap_effdate.
define new shared variable only_ers like mfc_logical
   label {&apvorp_p_9}.
define new shared variable summary
   like mfc_logical format {&apvorp_p_2} label {&apvorp_p_2}.
define new shared
   variable open_only like ap_open label {&apvorp_p_4} initial no.
define new shared variable gltrans like mfc_logical initial no
   label {&apvorp_p_5}.
define new shared variable base_rpt like ap_curr no-undo.
define new shared variable mixed_rpt like mfc_logical initial no

   label {&apvorp_p_10}.
define new shared variable entity like ap_entity.
define new shared variable entity1 like ap_entity.
define new shared variable show_vph like mfc_logical
   label {&apvorp_p_7}.
define new shared
   variable show_unconf like mfc_logical label {&apvorp_p_6}.
define new shared
   variable show_conf like mfc_logical label {&apvorp_p_8} initial yes.
define new shared variable votype like vo_type.
define new shared variable votype1 like votype.
define new shared
   variable sort_by_vend like mfc_logical label {&apvorp_p_3}.
define new shared variable vdtype like vd_type label {&apvorp_p_1}.
define new shared variable vdtype1 like vd_type.

define new shared variable rndmthd    like rnd_rnd_mthd.
define new shared variable oldsession as   character    no-undo.

{&APVORP-P-TAG1}
{txcurvar.i "new"}

{etvar.i &new = "new"}

form
   batch          colon 15
   batch1         label {t001.i} colon 49 skip
   ref            colon 15 format "x(8)"
   ref1           label {t001.i} colon 49 format "x(8)" skip
   votype         colon 15
   votype1        label {t001.i} colon 49 skip
   entity         colon 15
   entity1        label {t001.i} colon 49 skip
   vend           colon 15
   vend1          label {t001.i} colon 49 skip
   vdtype         colon 15
   vdtype1        label {t001.i} colon 49 skip
   apdate         colon 15
   apdate1        label {t001.i} colon 49
   effdate        colon 15
   effdate1       label {t001.i} colon 49 skip
   skip
   open_only      colon 25
   summary        colon 59 skip
   only_ers       colon 25
   sort_by_vend   colon 59 skip
   show_conf      colon 25
   gltrans        colon 59 skip
   show_unconf    colon 25
   base_rpt       colon 59 skip
   show_vph       colon 25
   mixed_rpt      colon 59
   {&APVORP-P-TAG2}
   skip
with frame a side-labels attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}

/* ASSUMED START UP SESSION IS FOR BASE CURRENCY */
oldsession = SESSION:numeric-format.

repeat:

   find first ap_wkfl no-error.
   if available ap_wkfl then

   for each ap_wkfl exclusive-lock:
      delete ap_wkfl.
   end.

   if batch1 = hi_char then batch1 = "".
   if ref1 = hi_char then ref1 = "".
   if vend1 = hi_char then vend1 = "".
   if apdate = low_date then apdate = ?.
   if apdate1 = hi_date then apdate1 = ?.
   if effdate = low_date then effdate = ?.
   if effdate1 = hi_date then effdate1 = ?.
   if entity1 = hi_char then entity1 = "".
   if votype1 = hi_char then votype1 = "".
   if vdtype1 = hi_char then vdtype1 = "".

   if c-application-mode <> 'web' then
   update
      batch batch1
      ref ref1
      votype votype1
      entity entity1
      vend vend1
      vdtype vdtype1
      apdate apdate1
      effdate effdate1
      open_only
      only_ers
      show_conf
      show_unconf
      show_vph
      summary
      sort_by_vend
      gltrans
      base_rpt
      mixed_rpt
      {&APVORP-P-TAG3}
   with frame a.
   {&APVORP-P-TAG4}
   {wbrp06.i &command = update
      &fields = "  batch batch1 ref ref1 votype votype1
        entity entity1 vend vend1 vdtype vdtype1
        apdate apdate1 effdate effdate1
        open_only  only_ers show_conf show_unconf
        show_vph summary  sort_by_vend gltrans
        base_rpt  mixed_rpt"
      &frm = "a"}

   {&APVORP-P-TAG9}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      {&APVORP-P-TAG5}
      bcdparm = "".
      {mfquoter.i batch      }
      {mfquoter.i batch1     }
      {mfquoter.i ref        }
      {mfquoter.i ref1       }
      {mfquoter.i votype     }
      {mfquoter.i votype1    }
      {mfquoter.i entity     }
      {mfquoter.i entity1    }
      {mfquoter.i vend       }
      {mfquoter.i vend1      }
      {mfquoter.i vdtype  }
      {mfquoter.i vdtype1  }
      {mfquoter.i apdate     }
      {mfquoter.i apdate1    }
      {mfquoter.i effdate    }
      {mfquoter.i effdate1   }
      {mfquoter.i open_only  }
      {mfquoter.i only_ers   }
      {mfquoter.i show_conf  }
      {mfquoter.i show_unconf}
      {mfquoter.i show_vph   }
      {mfquoter.i summary    }
      {mfquoter.i sort_by_vend}
      {mfquoter.i gltrans    }
      {mfquoter.i base_rpt   }
      {mfquoter.i mixed_rpt  }
      {&APVORP-P-TAG6}

      if batch1 = "" then batch1 = hi_char.
      if ref1 = "" then ref1 = hi_char.
      if vend1 = "" then vend1 = hi_char.
      if apdate = ? then apdate = low_date.
      if apdate1 = ? then apdate1 = hi_date.
      if effdate = ? then effdate = low_date.
      if effdate1 = ? then effdate1 = hi_date.
      if entity1 = "" then entity1 = hi_char.
      if votype1 = "" then votype1 = hi_char.
      if vdtype1 = "" then vdtype1 = hi_char.

   end.
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
   {&APVORP-P-TAG7}
       /* SS - 20051025 - B */
       /*
   {mfphead.i}
   {&APVORP-P-TAG8}

   /* DELETE GL WORKFILE ENTRIES */
   if gltrans = yes then do:
      for each gltw_wkfl exclusive-lock where
            gltw_userid = mfguser:
         delete gltw_wkfl.
      end.
   end.

   if sort_by_vend then do:
      {gprun.i ""apvorpa.p""}
   end.
   else do:
      {gprun.i ""apvorpb.p""}
   end.

   /* PRINT GL DISTRIBUTION */
   if gltrans then do:
      page.

      /* TO PRINT GL DETAILS USING ROUNDING METHOD OF THE CURRENCY */
      /* SPECIFIED IN REPORT CRITERIA                              */

      {gprun.i ""gpglrp1.p""}

   end.

   /*  Display Currency Totals. */
   if base_rpt = ""
      and mixed_rpt
   then do:
      {gprun.i ""gpacctp.p""}.
   end.
   /* REPORT TRAILER */

   {mfrtrail.i}
       */
       PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.

       FOR EACH tta6apvorp01:
           DELETE tta6apvorp01.
       END.
       {gprun.i ""a6apvorp01.p"" "(
           INPUT BATCH,
           INPUT batch1,
           INPUT ref,
           INPUT ref1,
           INPUT votype,
           INPUT votype1,
           INPUT entity,
           INPUT entity1,
           INPUT vend,
           INPUT vend1,
           INPUT vdtype,
           INPUT vdtype1,
           INPUT apdate,
           INPUT apdate1,
           INPUT effdate,
           INPUT effdate1,
           INPUT OPEN_only,
           INPUT only_ers,
           INPUT show_conf,
           INPUT show_unconf
           )"}
       EXPORT DELIMITER ";" "disp_curr" "ap_amt" "vo_ndisc_amt" "vo_applied" "vo_hold_amt" "vo_ref" "ap_date" "vd_remit" "ap_curr" "curr_disp_line1" "curr_disp_line2" "ap_vend" "ap_effdate" "vo_ship" "ap_bank" "vopo" "vo_due_date" "vo_invoice" "name" "ap_acct" "ap_sub" "ap_cc" "ap_disc_acct" "ap_disc_sub" "ap_disc_cc" "vo_disc_date" "ap_entity" "ap_rmk" "flag" "vo_confirmed" "vo_conf_by" "vo_is_ers" "remit_label" "remit_name" "ap_ckfrm" "vo_type" "ap_batch".
       FOR EACH tta6apvorp01:
           EXPORT DELIMITER ";" tta6apvorp01.
       END.

        PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.

        {a6mfrtrail.i}
       /* SS - 20051025 - E */

   /* RESET SESSION TO BASE NUMERIC FORMAT */
   SESSION:numeric-format = oldsession.

end. /* REPEAT */

{wbrp04.i &frame-spec = a}
