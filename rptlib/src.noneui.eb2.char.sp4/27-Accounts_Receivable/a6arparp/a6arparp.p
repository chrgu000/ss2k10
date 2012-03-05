/* arparp.p - DETAIL PAYMENT AUDIT REPORT                               */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.19.1.13 $                               */
/* REVISION: 2.0      LAST MODIFIED: 12/09/86   BY: PML        */
/* REVISION: 4.0      LAST MODIFIED: 02/16/88   BY: FLM *A175* */
/* REVISION: 4.0      LAST MODIFIED: 07/27/88   BY: JC *C0028* */
/* REVISION: 4.0      LAST MODIFIED: 12/06/88   BY: JLC*C0028* */
/* REVISION: 5.0      LAST MODIFIED: 05/12/89   BY: MLB *B099* */
/* REVISION: 5.0      LAST MODIFIED: 06/23/89   BY: MLB *B159* */
/* REVISION: 5.0      LAST MODIFIED: 09/14/89   BY: MLB *B289* */
/* REVISION: 5.0      LAST MODIFIED: 10/04/89   BY: MLB *B326* */
/* REVISION: 5.0      LAST MODIFIED: 10/05/89   BY: MLB *B324* */
/* REVISION: 6.0      LAST MODIFIED: 08/29/90   BY: afs *D059* */
/* REVISION: 6.0      LAST MODIFIED: 08/31/90   BY: MLB *D055* */
/* REVISION: 6.0      LAST MODIFIED: 10/29/90   BY: MLB *D153* */
/* REVISION: 6.0      LAST MODIFIED: 02/28/91   BY: afs *D387* */
/* REVISION: 6.0      LAST MODIFIED: 03/15/91   BY: bjb *D461* */
/* REVISION: 6.0      LAST MODIFIED: 03/19/91   BY: MLB *D444* */
/* REVISION: 6.0      LAST MODIFIED: 04/17/91   BY: bjb *D515* */
/* REVISION: 7.0      LAST MODIFIED: 10/28/91   BY: MLV *F028* */
/* REVISION: 6.0      LAST MODIFIED: 11/18/19   BY: afs *D935* */
/* REVISION: 7.0      LAST MODIFIED: 03/04/92   BY: jms *F237* */
/* REVISION: 7.0      LAST MODIFIED: 03/17/92   BY: TMD *F258* */
/*                                   05/04/92   by: jms *F466* */
/* REVISION: 7.3      LAST MODIFIED: 08/03/92   by: jms *G024* */
/*                                   09/30/92   by: jms *G111* */
/*                                   09/27/93   by: jcd *G247* */
/*                                   11/23/92   by: mpp *G351* */
/*                                   03/17/93   by: bcm *G834* */
/*                                   04/20/93   by: bcm *G981* */
/* REVISION: 7.3      LAST MODIFIED: 06/29/93   by: pcd *GC86* REV ONLY */
/*                                   08/17/93   by: jjs *GE34*          */
/*                                           (split off arparpa.p)      */
/*                                   08/23/94   by: rxm *GL40*          */
/* Oracle changes (share-locks)    09/11/94           BY: rwl *FR14*    */
/* REVISION: 7.4      LAST MODIFIED: 10/27/94   by: ame *GN63*          */
/* REVISION: 8.5      LAST MODIFIED: 12/13/95   by: taf *J053*          */
/*                                   04/09/96   by: jzw *G1T9*          */
/* REVISION: 8.6      LAST MODIFIED: 03/18/97   BY: *K082* E. HUGHART   */
/* REVISION: 8.6      LAST MODIFIED: 10/16/97   BY: bvm *K0QK*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/*                                   8 apr 98   by: rup *L00K*              */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan       */
/* REVISION: 8.6E     LAST MODIFIED: 07/21/98   BY: *L01K* Jaydeep Parikh   */
/* REVISION: 9.1      LAST MODIFIED: 10/13/99   BY: *L0K5* Hemali Desai     */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn              */
/* REVISION: 9.1      LAST MODIFIED: 10/25/00   BY: *N0T7* Jean Miller      */
/* REVISION: 9.1      LAST MODIFIED: 09/13/00 BY: *N0VV* BalbeerS Rajput    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* Revision: 1.19.1.8  BY: Mercy C.        DATE: 03/21/02  ECO: *M1WF*      */
/* Revision: 1.19.1.9  BY: Karel Groos     DATE: 03/26/02  ECO: *N1B4*      */
/* Revision: 1.19.1.10 BY: Patrick de Jong DATE: 05/31/02  ECO: *P07H*      */
/* Revision: 1.19.1.11 BY: Manjusha Inglay DATE: 07/29/02  ECO: *N1P4*      */
/* Revision: 1.19.1.12 BY: Nishit V        DATE: 11/20/02  ECO: *N1ZZ*      */
/* $Revision: 1.19.1.13 $ BY: Narathip W.     DATE: 05/19/03  ECO: *P0SH*      */
/* $Revision: 1.19.1.13 $ BY: Bill Jiang     DATE: 09/24/05  ECO: *SS - 20050924*      */

/*V8:ConvertMode=FullGUIReport                                               */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20050924 - B */
define input parameter i_batch     like ar_batch.
define input parameter i_batch1    like ar_batch.
define input parameter i_check_nbr like ar_check.
define input parameter i_check1    like ar_check.
define input parameter i_cust      like ar_bill.
define input parameter i_cust1     like ar_bill.
define input parameter i_entity    like ar_entity.
define input parameter i_entity1   like ar_entity.
define input parameter i_ardate    like ar_date.
define input parameter i_ardate1   like ar_date.
define input parameter i_effdate   like ar_effdate.
define input parameter i_effdate1  like ar_effdate.
define input parameter i_bank      like ar_bank.
define input parameter i_bank1     like ar_bank.
define input parameter i_ptype     like ar_type.
define input parameter i_base_rpt  like ar_curr.
define input parameter i_mixed_rpt like mfc_logical.
/*
{mfdtitle.i "2+ "}
    */
    {a6mfdtitle.i "2+ "}
    /* SS - 20050924 - E */
{cxcustom.i "ARPARP.P"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE arparp_p_1 "Summary/Detail"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparp_p_2 "Print GL Detail"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparp_p_3 "Mixed Currencies"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/* DEFINE NEW SHARED WORKFILE AP_WKFL FOR CURRENCY SUMMARY */
{gpacctp.i "new"}

{gldydef.i new}
{gldynrm.i new}

{&ARPARP-P-TAG1}
define new shared variable bank      like ar_bank no-undo.
define new shared variable bank1     like bank no-undo.
define new shared variable rndmthd   like rnd_rnd_mthd.
/* DEFINE OLD_CURR FOR CALL TO GPACCTP.P */
define new shared variable old_curr  like ar_curr initial "".
define new shared variable cust      like ar_bill.
define new shared variable cust1     like ar_bill.
define new shared variable check_nbr like ar_check.
define new shared variable check1    like ar_check.
define new shared variable batch     like ar_batch.
define new shared variable batch1    like ar_batch.
define new shared variable entity    like ar_entity.
define new shared variable entity1   like ar_entity.
define new shared variable ardate    like ar_date.
define new shared variable ardate1   like ar_date.
define new shared variable effdate   like ar_effdate.
define new shared variable effdate1  like ar_effdate.
define new shared variable summary   like mfc_logical format {&arparp_p_1}
                                                 initial no label {&arparp_p_1}.
define new shared variable gltrans   like mfc_logical initial no
                                                            label {&arparp_p_2}.
define new shared variable base_rpt  like ar_curr no-undo.
define new shared variable mixed_rpt like mfc_logical initial no
                                                            label {&arparp_p_3}.
define new shared variable ptype     like ar_type initial " "
                                     label "Payment Type" no-undo.
{&ARPARP-P-TAG9}

{etvar.i   &new = "new"}
{etrpvar.i &new = "new"}

{&ARPARP-P-TAG2}
form
   batch                         colon 18
   batch1         label {t001.i} colon 49 skip
   check_nbr                     colon 18
   check1         label {t001.i} colon 49 skip
   cust                          colon 18
   cust1          label {t001.i} colon 49 skip
   entity                        colon 18
   entity1        label {t001.i} colon 49 skip
   ardate                        colon 18
   ardate1        label {t001.i} colon 49 skip
   effdate                       colon 18
   effdate1       label {t001.i} colon 49 skip
   bank                          colon 18
   bank1          label {t001.i} colon 49 skip (1)
   ptype                         colon 25
   summary                       colon 25
   gltrans                       colon 25
   base_rpt                      colon 25
   mixed_rpt                     colon 25
   {&ARPARP-P-TAG10}
with frame a side-labels width 80.

{&ARPARP-P-TAG3}
/* SET EXTERNAL LABELS */
    /* SS - 20050924 - B */
    /*
setFrameLabels(frame a:handle).
*/
BATCH = i_batch.
BATCH1 = i_batch1.
CHECK_nbr = i_check_nbr.
check1 = i_check1.
cust = i_cust.
cust1 = i_cust1.
entity = i_entity.
entity1 = i_entity1.
ardate = i_ardate.
ardate1 = i_ardate1.
effdate = i_effdate.
effdate1 = i_effdate1.
bank = i_bank.
bank1 = i_bank1.
ptype = i_ptype.
base_rpt = i_base_rpt.
mixed_rpt = i_mixed_rpt.
/* SS - 20050924 - E */

{wbrp01.i}

    /* SS - 20050924 - B */
    /*
repeat:
    */
    /* SS - 20050924 - E */

   if can-find(first ap_wkfl)
   then do:
      for each ap_wkfl
      exclusive-lock:
         delete ap_wkfl.
      end. /* FOR EACH ap_wkfl */
   end. /* IF CAN-FIND(FIRST ap_wkfl) */
   if batch1 = hi_char
   then
      batch1 = "".
   if check1 = hi_char
   then
      check1 = "".
   if cust1  = hi_char
   then
      cust1  = "".
   if entity1 = hi_char
   then
      entity1 = "".
   if ardate  = low_date
   then
      ardate  = ?.
   if ardate1 = hi_date
   then
      ardate1 = ?.
   if effdate = low_date
   then
      effdate = ?.
   if effdate1 = hi_date
   then
      effdate1 = ?.
   if bank1    = hi_char
   then
      bank1    = "".
   {&ARPARP-P-TAG4}

       /* SS - 20050924 - B */
       /*
   if c-application-mode <> 'web'
   then
      update
         batch     batch1
         check_nbr check1
         cust      cust1
         entity    entity1
         ardate    ardate1
         effdate   effdate1
         bank      bank1
         ptype
         {&ARPARP-P-TAG5}
         summary   gltrans
         base_rpt
         mixed_rpt
         {&ARPARP-P-TAG11}
      with frame a.

   {&ARPARP-P-TAG6}
   {&ARPARP-P-TAG12}
   {wbrp06.i
      &command = update
      &fields  = "  batch batch1 check_nbr check1 cust cust1 entity entity1
                   ardate ardate1 effdate effdate1 bank bank1 ptype summary
                   gltrans base_rpt
                   mixed_rpt"
      &frm     = "a"}
   {&ARPARP-P-TAG13}
   {&ARPARP-P-TAG7}
       */
       /* SS - 20050924 - E */

   if (c-application-mode <> 'web')
   or (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      {&ARPARP-P-TAG14}

      bcdparm = "".
      {mfquoter.i batch    }
      {mfquoter.i batch1   }
      {mfquoter.i check_nbr}
      {mfquoter.i check1   }
      {mfquoter.i cust     }
      {mfquoter.i cust1    }
      {mfquoter.i entity   }
      {mfquoter.i entity1  }
      {mfquoter.i ardate   }
      {mfquoter.i ardate1  }
      {mfquoter.i effdate  }
      {mfquoter.i effdate1 }
      {mfquoter.i bank     }
      {mfquoter.i bank1    }
      {mfquoter.i ptype    }
      {&ARPARP-P-TAG8}
      {mfquoter.i summary  }
      {mfquoter.i gltrans  }
      {mfquoter.i base_rpt}
      {mfquoter.i mixed_rpt}
      {&ARPARP-P-TAG15}

      if batch1 = ""
      then
         batch1 = hi_char.
      if check1 = ""
      then
         check1 = hi_char.
      if cust1  = ""
      then
         cust1  = hi_char.
      if entity1 = ""
      then
         entity1 = hi_char.
      if ardate  = ?
      then
         ardate  = low_date.
      if ardate1 = ?
      then
         ardate1 = hi_date.
      if effdate = ?
      then
         effdate  = low_date.
      if effdate1 = ?
      then
         effdate1 = hi_date.
      if bank1    = ""
      then
     bank1    = hi_char.

   end. /* IF (c-application-mode <> 'web') */

   /* SS - 20050924 - B */
   /*
   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i
      &printType = "printer"
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
   {&ARPARP-P-TAG16}
   {mfphead.i}
   {&ARPARP-P-TAG17}
       */
   define variable l_textfile        as character no-undo.
       /* SS - 20050924 - E */

   /* SS - 20050924 - B */
   /*
   /* DELETE GL WORKFILE ENTRIES */
   if gltrans = yes
   then
      for each gltw_wkfl
         where gltw_userid = mfguser
      exclusive-lock:
         delete gltw_wkfl.
      end. /* FOR EACH gltw_wkfl */

   /* PRINT BODY OF REPORT */
   {gprun.i ""arparpa.p""}

   /* PRINT GL DISTRIBUTION */
   if gltrans
   then do:
      page.

      /* CHANGED GPGLRP.P TO GPGLRP1.P WHICH PRINTS GL DISTRIBUTION */
      /* TAKING INTO CONSIDERATION THE ROUNDING METHOD OF THE       */
      /* CURRENCY SPECIFIED IN SELECTION CRITERIA.                  */
      {gprun.i ""gpglrp1.p""}
   end. /* IF gltrans */

   /*  DISPLAY CURRENCY TOTALS.                                     */
   if  base_rpt = ""
   and mixed_rpt
   then do:
      {gprun.i ""gpacctp.p""}.
   end. /* IF base_rpt = "" AND... */

   display
      getTermLabel("NOTE",6) + ": " +
      getTermLabel("GAIN/LOSS_IS_EXCLUDED_FROM_AR_AMT",47) format "x(55)"
   with frame f.

   /* REPORT TRAILER */
   {mfrtrail.i}

end. /* REPEAT */
   */
   {gprun.i ""a6arparpa.p""}
   /* SS - 20050924 - E */

{wbrp04.i &frame-spec = a}
