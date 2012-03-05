/* apckrp.p - AP CHECK REGISTER AUDIT REPORT                              */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                    */
/* All rights reserved worldwide.  This is an unpublished work.           */
/* $Revision: 1.8.1.10 $                                                         */
/* Copyright 1986-2001 QAD Inc., Carpinteria, CA, USA.                    */
/*V8:ConvertMode=FullGUIReport                                   */
/* REVISION: 1.0      LAST MODIFIED: 10/20/86   BY: PML                   */
/* REVISION: 6.0      LAST MODIFIED: 02/22/91   BY: mlv *D361*            */
/*                                   04/03/91   BY: mlv *D494*            */
/* REVISION: 7.0      LAST MODIFIED: 01/27/92   BY: mlv *F098*            */
/*                                   05/19/92   BY: mlv *F509*(rev only)  */
/*                                   05/21/92   BY: mlv *F461*            */
/* REVISION: 7.3      LAST MODIFIED: 09/27/93   BY: jcd *G247*            */
/*                                   04/12/93   BY: jms *G937* (rev only) */
/*                                   04/17/93   BY: jms *G967* (rev only) */
/*                                   07/22/93   BY: wep *GD59* (rev only) */
/*                                   09/16/93   BY: bcm *GF38* (rev only) */
/* REVISION: 7.4      LAST MODIFIED: 09/21/93   BY: bcm *H110* (rev only) */
/*                                   11/24/93   BY: wep *H245*            */
/* REVISION: 7.4      LAST MODIFIED: 10/27/94   BY: ame *FS90*            */
/* REVISION: 7.4      LAST MODIFIED: 02/11/95   BY: ljm *G0DZ*            */
/*                                   04/10/96   BY: jzw *G1LD*            */
/* REVISION: 8.6      LAST MODIFIED: 10/14/97   BY: ckm *K0QV*            */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan     */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00 BY: *N0KK* jyn                 */
/* REVISION: 9.1      LAST MODIFIED: 09/21/00 BY: *N0W0* BalbeerS Rajput  */
/* REVISION: 9.0    LAST MODIFIED: 10 NOV 2000 BY: *N0X7* Ed van de Gevel */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.8.1.6.2.3 BY: Ed van de Gevel     DATE: 11/05/01  ECO: *N15M*  */
/* $Revision: 1.8.1.10 $ BY: Orawan S.           DATE: 05/03/02  ECO: *P0QW*  */
/* $Revision: 1.8.1.10 $ BY: Bill Jiang           DATE: 02/15/06  ECO: *SS - 20060215*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20060215 - B */
{a6apckrptt.i "new"}
/* SS - 20060215 - E */

{mfdtitle.i "2+ "}
{cxcustom.i "APCKRP.P"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE apckrp_p_1 "Supplier Type"
/* MaxLen: Comment: */

&SCOPED-DEFINE apckrp_p_2 "Summary/Detail"
/* MaxLen: Comment: */

&SCOPED-DEFINE apckrp_p_3 "Sort by Supplier"
/* MaxLen: Comment: */

&SCOPED-DEFINE apckrp_p_4 "Check"
/* MaxLen: Comment: */

&SCOPED-DEFINE apckrp_p_5 "Print GL Detail"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define new shared variable vend         like ap_vend.
define new shared variable vend1        like ap_vend.
define new shared variable batch        like ap_batch.
define new shared variable batch1       like ap_batch.
define new shared variable apdate       like ap_date.
define new shared variable apdate1      like ap_date.
define new shared variable effdate      like ap_effdate.
define new shared variable effdate1     like ap_effdate.
define new shared variable bank         like ck_bank.
define new shared variable bank1        like ck_bank.
{&APCKRP-P-TAG1}
/*V8-*/
define new shared variable nbr          like ck_nbr.
define new shared variable nbr1         like ck_nbr.
/*V8+*/ /*V8!
define new shared variable nbr          as integer format ">999999"
label {&apckrp_p_4}.
define new shared variable nbr1         as integer format ">999999". */
{&APCKRP-P-TAG2}
define new shared variable entity       like ap_entity.
define new shared variable entity1      like ap_entity.
define new shared variable ckfrm        like ap_ckfrm.
define new shared variable ckfrm1       like ap_ckfrm.
define new shared variable summary      like mfc_logical
   format {&apckrp_p_2} label {&apckrp_p_2}.
define new shared variable gltrans      like mfc_logical initial no
   label {&apckrp_p_5}.
define new shared variable base_rpt     like ap_curr.

define new shared variable vdtype       like vd_type
   label {&apckrp_p_1}.
define new shared variable vdtype1      like vdtype.
define new shared variable sort_by_vend like mfc_logical
   label {&apckrp_p_3}.
define new shared variable duedate      like vo_due_date.
define new shared variable duedate1     like vo_due_date.

{&APCKRP-P-TAG13}
{&APCKRP-P-TAG3}
{&APCKRP-P-TAG11}
form
   batch          colon 15
   batch1         label {t001.i} colon 49 skip
   nbr            colon 15 format "999999"
   nbr1           label {t001.i} colon 49 format "999999" skip
   bank           colon 15
   bank1          label {t001.i} colon 49 skip
   ckfrm          colon 15                format "x(1)"
   ckfrm1         label {t001.i} colon 49 format "x(1)" skip
   entity         colon 15
   entity1        label {t001.i} colon 49 skip
   vend           colon 15
   vend1          label {t001.i} colon 49 skip
   vdtype         colon 15
   vdtype1        label {t001.i} colon 49 skip
   apdate         colon 15
   apdate1        label {t001.i} colon 49 skip
   effdate        colon 15
   effdate1       label {t001.i} colon 49
   duedate        colon 15
   duedate1       label {t001.i} colon 49 skip(1)
    /* SS - 20060215 - B */
    /*
   summary        colon 25
   sort_by_vend   colon 25
   gltrans        colon 25
    */
    /* SS - 20060215 - E */
   base_rpt       colon 25
with frame a side-labels width 80.
{&APCKRP-P-TAG12}
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
   {&APCKRP-P-TAG14}
   if nbr1     = 999999   then nbr1     = 0.
   {&APCKRP-P-TAG15}
   {&APCKRP-P-TAG4}
   if batch1   = hi_char  then batch1   = "".
   if bank1    = hi_char  then bank1    = "".
   if vend1    = hi_char  then vend1    = "".
   if apdate   = low_date then apdate   = ?.
   if apdate1  = hi_date  then apdate1  = ?.
   if effdate  = low_date then effdate  = ?.
   if effdate1 = hi_date  then effdate1 = ?.
   if duedate  = low_date then duedate  = ?.
   if duedate1 = hi_date  then duedate1 = ?.
   if entity1  = hi_char  then entity1  = "".
   if vdtype1  = hi_char  then vdtype1  = "".
   if ckfrm1   = hi_char  then ckfrm1   = "".

   /* SS - 20060215 - B */
   /*
   if c-application-mode <> 'web' then
   {&APCKRP-P-TAG5}
   update batch batch1
      nbr nbr1
      bank bank1
      ckfrm ckfrm1
      entity entity1
      vend vend1
      vdtype vdtype1
      apdate apdate1
      effdate effdate1
      duedate duedate1
      summary
      sort_by_vend
      gltrans
      {&APCKRP-P-TAG16}
      base_rpt with frame a.

   {&APCKRP-P-TAG6}
   {&APCKRP-P-TAG17}
   {wbrp06.i &command = update &fields = "  batch batch1 nbr nbr1 bank bank1
        ckfrm ckfrm1 entity entity1 vend vend1 vdtype vdtype1 apdate apdate1 effdate effdate1
        duedate duedate1 summary  sort_by_vend gltrans base_rpt" &frm = "a"}
       */
   if c-application-mode <> 'web' then
   {&APCKRP-P-TAG5}
   update batch batch1
      nbr nbr1
      bank bank1
      ckfrm ckfrm1
      entity entity1
      vend vend1
      vdtype vdtype1
      apdate apdate1
      effdate effdate1
      duedate duedate1
      base_rpt with frame a.

   {&APCKRP-P-TAG6}
   {&APCKRP-P-TAG17}
   {wbrp06.i &command = update &fields = "  batch batch1 nbr nbr1 bank bank1
        ckfrm ckfrm1 entity entity1 vend vend1 vdtype vdtype1 apdate apdate1 effdate effdate1
        duedate duedate1 base_rpt" &frm = "a"}
       /* SS - 20060215 - E */

   {&APCKRP-P-TAG18}
   {&APCKRP-P-TAG10}
   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      {&APCKRP-P-TAG19}
      bcdparm = "".
      {mfquoter.i batch}
      {mfquoter.i batch1}
      {mfquoter.i nbr}
      {mfquoter.i nbr1}
      {mfquoter.i bank}
      {mfquoter.i bank1}
      {mfquoter.i ckfrm  }
      {mfquoter.i ckfrm1  }
      {mfquoter.i entity}
      {mfquoter.i entity1}
      {mfquoter.i vend}
      {mfquoter.i vend1}
      {mfquoter.i vdtype  }
      {mfquoter.i vdtype1  }
      {mfquoter.i apdate}
      {mfquoter.i apdate1}
      {mfquoter.i effdate}
      {mfquoter.i effdate1}
      {mfquoter.i duedate}
      {mfquoter.i duedate1}
      {&APCKRP-P-TAG7}
      {mfquoter.i summary}
      {mfquoter.i sort_by_vend}
      {mfquoter.i gltrans}
      {mfquoter.i base_rpt}
      {&APCKRP-P-TAG20}
      {&APCKRP-P-TAG8}

      {&APCKRP-P-TAG21}
      if nbr1 = 0     then nbr1     = 999999.
      {&APCKRP-P-TAG22}
      {&APCKRP-P-TAG9}
      if batch1 = ""  then batch1   = hi_char.
      if bank1 = ""   then bank1    = hi_char.
      if vend1 = ""   then vend1    = hi_char.
      if apdate = ?   then apdate   = low_date.
      if apdate1 = ?  then apdate1  = hi_date.
      if effdate = ?  then effdate  = low_date.
      if effdate1 = ? then effdate1 = hi_date.
      if duedate = ?  then duedate  = low_date.
      if duedate1 = ? then duedate1 = hi_date.
      if entity1 = "" then entity1  = hi_char.
      if vdtype1 = "" then vdtype1  = hi_char.
      if ckfrm1 = ""  then ckfrm1   = hi_char.

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
      /* SS - 20060215 - B */
      /*
   {&APCKRP-P-TAG23}
   {mfphead.i}
   {&APCKRP-P-TAG24}

   /* DELETE GL WORKFILE ENTRIES */
   if gltrans = yes then do:

      for each gltw_wkfl exclusive-lock
            where gltw_userid = mfguser:
         delete gltw_wkfl.
      end.
   end.

   if sort_by_vend then do:
      {gprun.i ""apckrpb.p""}
   end.
   else do:
      {gprun.i ""apckrpa.p""}
   end.

   /* PRINT GL DISTRIBUTION */
   if gltrans then do:
      page.
      {gprun.i ""gpglrp.p""}
   end.
   /* REPORT TRAILER */
   {mfrtrail.i}
   */
   PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.

    FOR EACH tta6apckrp:
        DELETE tta6apckrp.
    END.

   {gprun.i ""a6apckrp.p"" "(
        input batch        ,
        input batch1       ,
        input nbr          ,
        input nbr1         ,
        input bank         ,
        input bank1        ,
        input ckfrm        ,
        input ckfrm1       ,
        input entity       ,
        input entity1      ,
        input vend         ,
        input vend1        ,
        input vdtype       ,
        input vdtype1      ,
        input apdate       ,
        input apdate1      ,
        input effdate      ,
        input effdate1     ,
        input duedate      ,
        input duedate1     ,
        input base_rpt     
   )"}

    EXPORT DELIMITER ";" "ap_batch" "ck_bank" "ck_nbr" "ap_vend" "name" "ap_date" "ap_effdate" "ap_curr" "ap_ex_rate" "ap_ex_rate2" "ap_entity" "ap_acct" "ap_sub" "ap_cc" "ckstatus" "base_disp_amt" "ap_entity1" "ckd_voucher" "ckd_type" "order" "rmks" "invoice" "ckd_acct" "ckd_sub" "ckd_cc" "base_ckd_amt" "base_disc".
    FOR EACH tta6apckrp:
        EXPORT DELIMITER ";" tta6apckrp.
    END.

    PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.

    {a6mfrtrail.i}
   /* SS - 20060215 - E */

end.

{wbrp04.i &frame-spec = a}
