/* ardrrp01.p - AR DR/CR MEMO REPORT                                         */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.8.1.15 $                                                     */
/*V8:ConvertMode=FullGUIReport                                               */
/* REVISION: 1.0      LAST MODIFIED: 12/11/86   BY: PML                      */
/* REVISION: 4.0      LAST MODIFIED: 02/16/88   BY: FLM *A175*               */
/* REVISION: 4.0      LAST MODIFIED: 04/05/89   BY: JLC *C0028.1             */
/* REVISION: 5.0      LAST MODIFIED: 02/22/89   BY: MLB *B043*               */
/* REVISION: 5.0      LAST MODIFIED: 06/09/89   BY: WUG *B131*               */
/* REVISION: 6.0      LAST MODIFIED: 09/20/90   BY: afs *D059*               */
/* REVISION: 6.0      LAST MODIFIED: 04/02/91   BY: bjb *D507*               */
/* REVISION: 6.0      LAST MODIFIED: 04/18/91   BY: bjb *D724*               */
/* REVISION: 6.0      LAST MODIFIED: 06/26/91   BY: afs *D723*               */
/* REVISION: 7.0      LAST MODIFIED: 03/04/92   BY: jms *F237*               */
/*                                   06/17/92   by: jms *F666*               */
/*                                   08/23/94   by: rxm *GL40*               */
/* REVISION: 7.3      LAST MODIFIED: 10/27/94   by: ame *GN63*               */
/* REVISION: 8.5      LAST MODIFIED: 12/04/95   by: taf *J053*               */
/*                                   04/09/96   by: jzw *G1P6*               */
/* REVISION: 8.6      LAST MODIFIED: 10/10/97   by: bvm *K0QG*               */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98   BY: *L01K* Jaydeep Parikh    */
/* REVISION: 8.6E     LAST MODIFIED: 09/16/98   BY: *L098* G.Latha           */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 02/10/00   BY: *N07W* Rajesh Thomas     */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 04/13/00   BY: *N08H* Veena Lad         */
/* REVISION: 9.1      LAST MODIFIED: 06/07/00   BY: *N0CL* Arul Victoria     */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* REVISION: 9.1      LAST MODIFIED: 10/25/00   BY: *N0T7* Jean Miller       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Revision: 1.8.1.12    BY: Anil Sudhakaran      DATE: 09/24/01 ECO: *N131* */
/* Revision: 1.8.1.13  BY: Vandna Rohira DATE: 09/04/02 ECO: *N1ST* */
/* $Revision: 1.8.1.15 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00B* */
/* $Revision: 1.8.1.15 $ BY: Bill Jiang DATE: 08/17/07 ECO: *SS - 20070817.1* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20070817.1 - B */
/*
{mfdtitle.i "2+ "}
*/
{a6mfdtitle.i "2+ "}

{ssardrrp0101.i}

define input parameter i_nbr              like ar_nbr.
define input parameter i_nbr1             like ar_nbr.
define input parameter i_batch            like ar_batch.
define input parameter i_batch1           like ar_batch.
define input parameter i_cust             like ar_bill.
define input parameter i_cust1            like ar_bill.
define input parameter i_ardate           like ar_date.
define input parameter i_ardate1          like ar_date.
define input parameter i_entity           like gl_entity.
define input parameter i_entity1          like gl_entity.
define input parameter i_base_rpt         like ar_curr.
define input parameter i_mixed_rpt        like mfc_logical.
define input parameter i_cnt_only         like mfc_logical.
/* SS - 20070817.1 - E */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE ardrrp01_p_1 "Mixed Currencies"
/* MaxLen: Comment: */

&SCOPED-DEFINE ardrrp01_p_2 "Slspsn"
/* MaxLen: Comment: */

&SCOPED-DEFINE ardrrp01_p_3 "Contested Only"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{gparcur.i}

define variable cust             like ar_bill.
define variable cust1            like ar_bill.
define variable nbr              like ar_nbr.
define variable nbr1             like ar_nbr.
define variable batch            like ar_batch.
define variable batch1           like ar_batch.
define variable ardate           like ar_date.
define variable ardate1          like ar_date.
define variable name             like ad_name.
define variable type             like ar_type format "X(4)".
define variable old_nbr          like ar_nbr.
define variable i                as   integer.
define variable base_rpt         like ar_curr.
define variable mixed_rpt        like mfc_logical initial no
   label {&ardrrp01_p_1}.
define variable base_amt         like ar_amt.
define variable base_applied     like ar_applied.
define variable disp_curr        like ar_curr.
define variable cnt_only         like mfc_logical label {&ardrrp01_p_3}
   initial no.
define variable contested        as character format "x(1)".
define variable entity           like gl_entity.
define variable entity1          like gl_entity.
define variable mc-error-number  like msg_nbr no-undo.
define variable l_msgdesc        like msg_desc extent 2 format "x(45)"
   no-undo.
define variable headerFrameLabel as character no-undo.
define variable l_result1        as character format "x(1)"
   no-undo.

/* MUST INCLUDE gprunpdf.i IN THE MAIN BLOCK OF THE PROGRAM SO THAT */
/* CALLS TO gprunp.i FROM ANY OF THE INTERNAL PROCEDURES SKIPS  */
/* DEFINITION OF SHARED VARS OF gprunpdf.i */
/* FOR FURTHER INFO REFER TO HEADER COMMENTS IN gprunp.i */
{gprunpdf.i "mcpl" "p"}
{gprunpdf.i "mcui" "p"}

form
   nbr            colon 16
   nbr1           label {t001.i} colon 49 skip
   batch          colon 16
   batch1         label {t001.i} colon 49 skip
   cust           colon 16
   cust1          label {t001.i} colon 49 skip
   ardate         colon 16
   ardate1        label {t001.i} colon 49 skip
   entity         colon 16
   entity1        label {t001.i} colon 49 skip(1)
   base_rpt       colon 25 skip
   mixed_rpt      colon 25 skip
   (1)
   cnt_only       colon 25 skip (1)
   l_msgdesc[1]    at 2 no-label
with frame a side-labels width 80.

/* NOTE: '*' INDICATES MISSING REFERENCE */
{pxmsg.i
   &MSGNUM=3552
   &ERRORLEVEL=0
   &MSGBUFFER=l_msgdesc[1]
}

/* 'C' INDICATES CONTESTED INVOICE/MEMO */
{pxmsg.i
   &MSGNUM=760
   &ERRORLEVEL=0
   &MSGBUFFER=l_msgdesc[2]
}

/* SS - 20070817.1 - B */
/*
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
*/
nbr = i_nbr.
nbr1 = i_nbr1.
batch = i_batch.
batch1 = i_batch1.
cust = i_cust.
cust1 = i_cust1.
ardate = i_ardate.
ardate1 = i_ardate1.
entity = i_entity.
entity1 = i_entity1.
base_rpt = i_base_rpt.
mixed_rpt = i_mixed_rpt.
cnt_only = i_cnt_only.
/* SS - 20070817.1 - E */

headerFrameLabel = getTermLabel("INDICATES_MISSING_REFERENCE",50).

find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.

{wbrp01.i}

/* SS - 20070817.1 - B */
/*
repeat:
*/
/* SS - 20070817.1 - E */

   find first ar_wkfl no-error.
   if available ar_wkfl
   then
      for each ar_wkfl exclusive-lock:
         delete ar_wkfl.
      end. /* FOR EACH ar_wkfl */

   if batch1 = hi_char
   then
      batch1 = "".
   if nbr1 = hi_char
   then
      nbr1 = "".
   if cust1 = hi_char
   then
      cust1 = "".
   if ardate = low_date
   then
      ardate = ?.
   if ardate1 = hi_date
   then
      ardate1 = ?.
   if entity1 = hi_char
   then
      entity1 = "".

   /* SS - 20070817.1 - B */
   /*
   display  l_msgdesc[1] with frame a.

   if c-application-mode <> 'web'
   then
      update
         nbr
         nbr1
         batch
         batch1
         cust
         cust1
         ardate
         ardate1
         entity
         entity1
         base_rpt
         mixed_rpt
         cnt_only
      with frame a.

   {wbrp06.i &command = update
      &fields = "  nbr nbr1 batch batch1 cust cust1
        ardate ardate1 entity entity1 base_rpt
        mixed_rpt cnt_only" &frm = "a"}
   */
   /* SS - 20070817.1 - E */

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".
      {mfquoter.i nbr     }
      {mfquoter.i nbr1    }
      {mfquoter.i batch   }
      {mfquoter.i batch1  }
      {mfquoter.i cust    }
      {mfquoter.i cust1   }
      {mfquoter.i ardate  }
      {mfquoter.i ardate1 }
      {mfquoter.i entity  }
      {mfquoter.i entity1 }
      {mfquoter.i base_rpt}
      {mfquoter.i mixed_rpt}
      {mfquoter.i cnt_only}

      if batch1 = ""
      then
         batch1 = hi_char.
      if nbr1 = ""
      then
         nbr1 = hi_char.
      if cust1 = ""
      then
         cust1 = hi_char.
      if ardate = ?
      then
         ardate = low_date.
      if ardate1 = ?
      then
         ardate1 = hi_date.
      if entity1 = ""
      then
         entity1 = hi_char.

   end. /* IF (c-application-mode <> 'WEB') */

   /* SS - 20070817.1 - B */
   /*
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
   {mfphead.i}

   form
      header
      skip (1)

      "'*' - " + headerFrameLabel
      format "x(60)" skip
      l_msgdesc[2]
      with frame pfoot page-bottom
      width 132.

   view frame pfoot.

   do with frame b down:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).
   */
   /* SS - 20070817.1 - E */

      old_nbr = ?.
      for each ar_mstr  where ar_mstr.ar_domain = global_domain and (  (ar_nbr
      >= nbr) and (ar_nbr <= nbr1)
            and (ar_batch >= batch) and (ar_batch <= batch1)
            and (ar_bill >= cust) and (ar_bill <= cust1)
            and (ar_date >= ardate) and (ar_date <= ardate1)
            and (ar_entity >= entity and ar_entity <= entity1)
            and (ar_type <> "P")
            and (ar_type <> "A")
            and (ar_type <> "D")
            and ((ar_curr = base_rpt)
            or  (base_rpt = ""))
            and ((ar_contested = yes) or (cnt_only = no))
         ) no-lock by ar_nbr with frame b width 132:

         assign
            base_amt     = ar_amt
            base_applied = ar_applied.

         if (base_rpt = "") and
            (ar_curr <> base_curr)
         then do:

            assign
               base_amt     = ar_base_amt
               base_applied = ar_base_applied.
         end. /* IF (base_rpt = "") */

         name = "".
         find ad_mstr  where ad_mstr.ad_domain = global_domain and  ad_addr =
         ar_bill no-lock no-wait no-error.
         if available ad_mstr
         then
            name = ad_name.

         type = "".

         if ar_type = "M"
         then
            type = getTermLabel("MEMO",4).
         else
            if ar_type = "I"
            then
               type = getTermLabel("INVOICE",4).
         else
            if ar_type = "F"
            then
               type = getTermLabel("FINANCE",4).

         /* CHECK FOR NUMERIC AND ALPHANUMERIC SEQUENCES */
         {gprun.i ""gpseqck.p""
             "(input  old_nbr,
               input  ar_nbr,
               output l_result1)"}

         /* SS - 20070817.1 - B */
         /*
         display l_result1 no-label.
         */
         /* SS - 20070817.1 - E */

         if ar_contested = yes
         then
            contested = "C".
         else
            contested = " ".

         old_nbr = ar_nbr.

         /* SS - 20070817.1 - B */
         /*
         display
            ar_nbr format "X(8)"
            type
            ar_bill
            name
            ar_date
            ar_effdate
            ar_paid_date
            ar_slspsn[1] column-label {&ardrrp01_p_2}
            (if base_rpt = ""
            and not mixed_rpt
            and ar_curr <> base_curr
            then
               getTermLabel("BASE",4)
            else
               ar_curr)
            @ disp_curr. /* NOTE - TRUNCATE TO 3 CHARACTERS */

         if not (base_rpt = "" and mixed_rpt)
         then
            display
               base_amt
               base_applied
               contested no-label.
         else
            display
               ar_amt @ base_amt
               ar_applied @ base_applied
               contested no-label.
         */
         CREATE ttssardrrp0101.
         ASSIGN
            ttssardrrp0101_l_result1 = l_result1
            ttssardrrp0101_ar_nbr = ar_nbr
            ttssardrrp0101_type = TYPE
            ttssardrrp0101_ar_bill = ar_bill
            ttssardrrp0101_name = NAME
            ttssardrrp0101_ar_date = ar_date
            ttssardrrp0101_ar_effdate = ar_effdate
            ttssardrrp0101_ar_paid_date = ar_paid_date
            ttssardrrp0101_ar_slspsn[1] = ar_slspsn[1]
            .

         if base_rpt = ""
         and not mixed_rpt
         and ar_curr <> base_curr
         then
            ASSIGN ttssardrrp0101_ar_curr = getTermLabel("BASE",4).
         else
            ASSIGN ttssardrrp0101_ar_curr = ar_curr.

         if not (base_rpt = "" and mixed_rpt)
         then
            ASSIGN
               ttssardrrp0101_ar_amt = base_amt
               ttssardrrp0101_ar_applied = base_applied
               ttssardrrp0101_contested = contested
               .
         else
            ASSIGN
               ttssardrrp0101_ar_amt = ar_amt
               ttssardrrp0101_ar_applied = ar_applied
               ttssardrrp0101_contested = contested
               .

         /* SS - 20070817.1 - E */

         /* SS - 20070817.1 - B */
         /*
         accumulate base_amt (total).
         accumulate base_applied (total).

         if page-size - line-counter <= 2
         then
            page.
         else
            down 1.

         /*  STORE SALES ORDER TOTALS, BY CURRENCY, IN WORK FILE.    */
         if base_rpt = ""
            and mixed_rpt
         then do:
            find first ar_wkfl where ar_curr = arwk_curr no-error.
            /* If a record for this currency
            doesn't exist, create one. */
            if not available ar_wkfl
            then do:
               create ar_wkfl.
               arwk_curr = ar_curr.
            end. /* IF NOT AVAILABLE ar_wkfl */

            /* Accumulate individual currency totals in work file */
            arwk_for = arwk_for + ar_amt.
            if base_curr <> ar_curr
            then
               arwk_base = arwk_base + base_amt.
            else
               arwk_base = arwk_for.
         end. /* IF base_rpt = "" */
         */
         /* SS - 20070817.1 - E */

         {mfrpchk.i}
      end.  /* FOR EACH ar_mstr */

      /* SS - 20070817.1 - B */
      /*
      if page-size - line-counter < 3
      then
         page.
      underline base_amt base_applied.

      display
         (if base_rpt = ""
          then
             getTermLabelRt("BASE",8)
          else
             "     " + base_rpt)
         @ ar_paid_date
         getTermLabelRtColon("TOTAL",6) @ ar_slspsn[1]
         accum total base_amt @ base_amt
         accum total base_applied @ base_applied skip.
      */
      /* SS - 20070817.1 - E */

   /* SS - 20070817.1 - B */
   /*
   end.  /* DO WITH FRAME B */

   /* IF ALL CURRENCIES, PRINT SUMMARY BY CURRENCY. */
   if base_rpt = ""
      and mixed_rpt
      then
         {gprun.i ""gparcur.p""}.

   /* REPORT TRAILER */
   {mfrtrail.i}

end. /* REPEAT */
   */
   /* SS - 20070817.1 - E */

{wbrp04.i &frame-spec = a}
