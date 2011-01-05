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

{mfdtitle.i "2+ "}

/* SS - 20070817.1 - B */
{ssardrrp0101.i "new"}
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

/* SS - 20070817.1 - B */
DEFINE VARIABLE to_entity LIKE ar_entity.
DEFINE VARIABLE stat LIKE ar_user1.

DEFINE VARIABLE output-find LIKE mfc_logical.
DEFINE VARIABLE output-nbr LIKE ar_nbr.
/* SS - 20070817.1 - E */

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
   /* SS - 20070817.1 - B */
   to_entity       colon 25 skip
   stat       colon 25 skip
   /* SS - 20070817.1 - E */
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

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

headerFrameLabel = getTermLabel("INDICATES_MISSING_REFERENCE",50).

find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.

/* SS - 20070817.1 - B */
FIND FIRST mfc_ctrl WHERE mfc_domain = GLOBAL_domain AND mfc_field = "ssari_en_from" NO-LOCK NO-ERROR.
IF AVAILABLE mfc_ctrl THEN DO:
   entity = mfc_char.
   entity1 = mfc_char.
END.
ELSE DO:
   /* 没有发现控制表记录 */
   {pxmsg.i &MSGNUM=291 &ERRORLEVEL=3}
   RETURN.
END.

FIND FIRST mfc_ctrl WHERE mfc_domain = GLOBAL_domain AND mfc_field = "ssari_en_to" NO-LOCK NO-ERROR.
IF AVAILABLE mfc_ctrl THEN DO:
   to_entity = mfc_char.
END.
ELSE DO:
   /* 没有发现控制表记录 */
   {pxmsg.i &MSGNUM=291 &ERRORLEVEL=3}
   RETURN.
END.
/* SS - 20070817.1 - E */

{wbrp01.i}

/* SS - 20070817.1 - B */
mainloop:
/* SS - 20070817.1 - E */
repeat:
   /* SS - 20070817.1 - B */
   hide all no-pause .
   view frame dtitle .
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

   display  l_msgdesc[1] with frame a.

  /* SS - 20070817.1 - B */
   /* gp973.p支持 */
  GLOBAL_addr = "ar_user1".
  /* SS - 20070817.1 - E */

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
      /* SS - 20070817.1 - B */
      to_entity
      stat
      /* SS - 20070817.1 - E */
         base_rpt
         mixed_rpt
         cnt_only
      with frame a.

   {wbrp06.i &command = update
      &fields = "  nbr nbr1 batch batch1 cust cust1
        ardate ardate1 entity entity1
      /* SS - 20070817.1 - B */
      to_entity
      stat
      /* SS - 20070817.1 - E */
      base_rpt
        mixed_rpt cnt_only" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      /* SS - 20070817.1 - B */
      IF stat = "3" THEN DO:
         /* 无效的登记 */
         {pxmsg.i &MSGNUM=4509 &ERRORLEVEL=3}
         next-prompt stat WITH FRAME a.
         undo mainloop,retry mainloop.
      END.

      FIND CODE_mstr WHERE CODE_domain = GLOBAL_domain AND CODE_fldname = "ar_user1" AND CODE_value = stat NO-LOCK NO-ERROR.
      IF NOT AVAILABLE CODE_mstr THEN DO:
         FIND FIRST CODE_mstr WHERE CODE_domain = GLOBAL_domain AND CODE_fldname = "ar_user1" NO-LOCK NO-ERROR.
         IF AVAILABLE CODE_mstr THEN DO:
            /* 无效的登记 */
            {pxmsg.i &MSGNUM=4509 &ERRORLEVEL=3}
            next-prompt stat WITH FRAME a.
            undo mainloop,retry mainloop.
         END.
      END.
      /* SS - 20070817.1 - E */

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
         /* SS - 20070817.1 - B */
         {mfquoter.i TO_entity}
         {mfquoter.i stat}
         /* SS - 20070817.1 - E */
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

   /* SS - 20070817.1 - B */
   /*
   do with frame b down:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).

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

         display l_result1 no-label.

         if ar_contested = yes
         then
            contested = "C".
         else
            contested = " ".

         old_nbr = ar_nbr.

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

         {mfrpchk.i}
      end.  /* FOR EACH ar_mstr */

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

   end.  /* DO WITH FRAME B */

   /* IF ALL CURRENCIES, PRINT SUMMARY BY CURRENCY. */
   if base_rpt = ""
      and mixed_rpt
      then
         {gprun.i ""gparcur.p""}.

   /* REPORT TRAILER */
   {mfrtrail.i}
   */

   EMPTY TEMP-TABLE ttssardrrp0101.

   {gprun.i ""ssardrrp0101.p"" "(
      input nbr,
      input nbr1,
      input BATCH,
      input BATCH1,
      input cust,
      input cust1,
      input ardate,
      input ardate1,
      input entity,
      input entity1,
      input base_rpt,
      input mixed_rpt,
      input cnt_only
      )"}

   FOR EACH ttssardrrp0101
      ,EACH ar_mstr NO-LOCK
      WHERE ar_domain = GLOBAL_domain
      AND ar_nbr = ttssardrrp0101_ar_nbr
      :
      IF ar_user1 <> stat THEN DO:
         DELETE ttssardrrp0101.
      END.
   END.

   {gprun.i ""ssardri1a.p"" "(
      INPUT to_entity
      )"}

   /* 输出执行的结果 */
   do with frame b down:
      do with frame b down:

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame b:handle).

         old_nbr = ?.
         for each ttssardrrp0101
            ,EACH ar_mstr
            where ar_mstr.ar_domain = global_domain
            and ar_nbr = ttssardrrp0101_ar_nbr
            no-lock
            by ar_nbr
            with frame b width 132:

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

            /*
            /* CHECK FOR NUMERIC AND ALPHANUMERIC SEQUENCES */
            {gprun.i ""gpseqck.p""
                "(input  old_nbr,
                  input  ar_nbr,
                  output l_result1)"}
            */
            {gprun.i ""ssardri1b.p"" "(
               INPUT ar_bill,
               INPUT ar_date,
               INPUT ar_nbr,
               OUTPUT output-find,
               OUTPUT output-nbr
               )"}
            IF output-find THEN DO:
               l_result1 = "".
            END.
            ELSE DO:
               l_result1 = "*".
            END.

            display l_result1 no-label.

            if ar_contested = yes
            then
               contested = "C".
            else
               contested = " ".

            old_nbr = ar_nbr.

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

            {mfrpchk.i}
         end.  /* FOR EACH ar_mstr */

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

      end.  /* DO WITH FRAME B */

      /* IF ALL CURRENCIES, PRINT SUMMARY BY CURRENCY. */
      if base_rpt = ""
         and mixed_rpt
         then
            {gprun.i ""gparcur.p""}.
   END.

   /* REPORT TRAILER */
   {mfrtrail.i}
   /* SS - 20070817.1 - E */

end. /* REPEAT */

{wbrp04.i &frame-spec = a}
