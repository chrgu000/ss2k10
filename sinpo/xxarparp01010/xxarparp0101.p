/* arparp01.p - DETAIL APPLY UNAPPLIED AUDIT REPORT                     */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.10.1.21 $                           */
/* REVISION: 5.0      LAST MODIFIED: 10/05/89   BY: MLB *B326*          */
/* REVISION: 6.0      LAST MODIFIED: 08/31/90   BY: MLB *D055*          */
/* REVISION: 6.0      LAST MODIFIED: 09/20/90   BY: afs *D059*          */
/* REVISION: 6.0      LAST MODIFIED: 10/29/90   BY: MLB *D153*          */
/* REVISION: 6.0      LAST MODIFIED: 02/28/91   BY: afs *D387*          */
/* REVISION: 6.0      LAST MODIFIED: 03/19/91   BY: MLB *D444*          */
/* REVISION: 6.0      LAST MODIFIED: 04/03/91   BY: bjb *D507*          */
/* REVISION: 7.0      LAST MODIFIED: 02/01/92   BY: pml *F128*          */
/*                                   03/04/92   by: jms *F237*          */
/* REVISION: 7.3      LAST MODIFIED: 10/12/92   by: jms *G024*          */
/*                                   09/27/92   By: jcd *G247*          */
/*                                   02/25/93   By: skk *G746*          */
/*                                   08/23/94   By: rxm *GL40*          */
/* REVISION: 7.4      LAST MODIFIED: 09/11/94   by: slm *GM15*          */
/* REVISION: 8.5      LAST MODIFIED: 12/14/95   by: taf & mwd *J053*    */
/*                                   04/09/96   by: jzw *G1P6*          */
/*                                   07/29/96   by: taf *J101*          */
/* REVISION: 8.6      LAST MODIFIED: 12/16/97   by: bvm *K1DN*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 03/20/98   BY: *J2F8* D. Tunstall  */
/* REVISION: 8.6E     LAST MODIFIED: 04/30/98   BY: *J2KJ* Niranjan R.  */
/* REVISION: 8.6E     LAST MODIFIED: 07/09/98   BY: *L01K* Jaydeep Parikh */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Paul Johnson   */
/* REVISION: 9.1      LAST MODIFIED: 10/13/99   BY: *L0K5* Hemali Desai   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 06/22/00   BY: *N0CL* Arul Victoria    */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn              */
/* REVISION: 9.1      LAST MODIFIED: 08/29/00   BY: *M0S0* Veena Lad        */
/* REVISION: 9.1      LAST MODIFIED: 10/09/00   BY: *M0TJ* Mark Christian   */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* Revision: 1.10.1.13     BY: Katie Hilbert  DATE: 04/01/01 ECO: *P002*      */
/* Revision: 1.10.1.14     BY: Katie Hilbert  DATE: 12/12/01 ECO: *P03P*      */
/* Revision: 1.10.1.15     BY: Mercy C        DATE: 03/18/02 ECO: *M1WF*      */
/* Revision: 1.10.1.16     BY: Paul Donnelly  DATE: 01/02/02 ECO: *N16J*      */
/* Revision: 1.10.1.17     BY: Hareesh V.     DATE: 06/21/02 ECO: *N1HY*      */
/* Revision: 1.10.1.18  BY: Geeta Kotian DATE: 05/12/03 ECO: *P0RV* */
/* Revision: 1.10.1.20  BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00B* */
/* $Revision: 1.10.1.21 $  BY: Vinay Nayak-Sujir DATE: 10/20/04 ECO: *P2PR*   */
/*-Revision end---------------------------------------------------------------*/


/*V8:ConvertMode=FullGUIReport                                          */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 100705.1 By: Bill Jiang */

/* DISPLAY TITLE */
/* SS - 100705.1 - B */
define input parameter i_batch like ar_batch.
define input parameter i_batch1 like ar_batch.
define input parameter i_check_nbr like ar_check.
define input parameter i_check1 like ar_check.
define input parameter i_cust like ar_bill.
define input parameter i_cust1 like ar_bill.
define input parameter i_entity like ar_entity.
define input parameter i_entity1 like ar_entity.
define input parameter i_ardate like ar_date.
define input parameter i_ardate1 like ar_date.
define input parameter i_effdate like ar_effdate.
define input parameter i_effdate1 like ar_effdate.
define input parameter i_base_rpt like ar_curr.

{xxarparp0101.i}
/*
/* DISPLAY TITLE */
{mfdtitle.i "1+ "}
*/
{xxmfdtitle.i "1+ "}

DEFINE TEMP-TABLE tt1
   field tt1_batch like ar_batch
   field tt1_nbr like ar_nbr
   field tt1_bill like ar_bill
   field tt1_name like ad_NAME
   field tt1_type like ar_type
   field tt1_check like ar_check
   field tt1_base_amt like ar_amt
   field tt1_date like ar_date
   field tt1_effdate like ar_effdate
   field tt1_entity like ar_entity
   field tt1_acct like ar_acct
   field tt1_sub like ar_sub
   field tt1_cc like ar_cc
   field tt1_po like ar_po
   INDEX index1 tt1_nbr
   .
/* SS - 100705.1 - E */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE arparp01_p_3 "Print GL Detail"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparp01_p_12 "Applied Amt"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparp01_p_15 "Enty"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparp01_p_16 "Summary/Detail"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparp01_p_17 "Type"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define new shared variable rndmthd like rnd_rnd_mthd.
define new shared variable base_amt_fmt as character.
define new shared variable curr_amt_old as character.
define new shared variable curr_amt_fmt as character.
define new shared variable base_rpt like ar_curr no-undo.
define variable oldcurr like ar_curr.
define variable oldsession as character.
define variable cust like ar_bill.
define variable cust1 like ar_bill.
define variable check_nbr like ar_check.
define variable check1 like ar_check.
define variable batch like ar_batch.
define variable batch1 like ar_batch.
define variable entity like ar_entity.
define variable entity1 like ar_entity.
define variable ardate like ar_date.
define variable ardate1 like ar_date.
define variable effdate like ar_effdate.
define variable effdate1 like ar_effdate.

define variable name like ad_name format "x(24)" no-undo.
define variable type like ar_type format "X(11)".
define variable detlines as integer.
define variable gltrans like mfc_logical initial no
   label {&arparp01_p_3}.
define variable summary like mfc_logical format {&arparp01_p_16}
   initial no label {&arparp01_p_16}.
define variable base_damt like ard_amt.
define variable base_amt like ar_amt.
define variable disp_curr as character format "x(1)" label "C".
define variable base_det_amt like glt_amt.
define variable gain_amt like glt_amt.
define variable mc-error-number like msg_nbr no-undo.
define variable foreignpayforeign like mfc_logical no-undo.

define buffer armstr for ar_mstr.

/* MUST INCLUDE gprunpdf.i IN THE MAIN BLOCK OF THE PROGRAM SO THAT */
/* CALLS TO gprunp.i FROM ANY OF THE INTERNAL PROCEDURES SKIPS  */
/* DEFINITION OF SHARED VARS OF gprunpdf.i */
/* FOR FURTHER INFO REFER TO HEADER COMMENTS IN gprunp.i */
{gprunpdf.i "mcpl" "p"}
{gprunpdf.i "mcui" "p"}

define variable basepayforeign as logical no-undo.
define variable base_glar_amt like glt_amt no-undo.

define variable c-base-rpt-lbl1 as character no-undo.
define variable c-base-rpt-lbl2 as character no-undo.

/* FOLLOWING REQUIRED FOR INTER-COMPANY */
{pxpgmmgr.i}
define variable ico_acct as character no-undo.
define variable ico_sub as character no-undo.
define variable ico_cc as character no-undo.


find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.

form
   batch          colon 18 batch1         label {t001.i} colon 49
   check_nbr      colon 18 check1         label {t001.i} colon 49
   cust           colon 18 cust1          label {t001.i} colon 49
   entity         colon 18 entity1        label {t001.i} colon 49
   ardate         colon 18 ardate1        label {t001.i} colon 49
   effdate        colon 18 effdate1       label {t001.i} colon 49
   summary        colon 18
   gltrans        colon 18
   base_rpt       colon 18
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* SS - 100705.1 - B */
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
base_rpt = i_base_rpt.
/* SS - 100705.1 - E */

form
   space(10)
   ard_ref
   type column-label {&arparp01_p_17}
   ard_entity format "x(4)" label {&arparp01_p_15}
   ard_acct
   ard_sub
   ard_cc
   disp_curr
   base_damt label {&arparp01_p_12}
with frame c width 132 down.

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

form
   ar_nbr format "x(8)"
   ar_bill name
   ar_type
   ar_check
   base_amt
   ar_date
   ar_effdate
   ar_entity format "x(4)" label {&arparp01_p_15}
   ar_acct
   ar_sub
   ar_cc
   ar_po
   format "x(14)"
with frame d width 132 down no-box.

/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

base_amt_fmt = base_amt:format.
{gprun.i ""gpcurfmt.p"" "(input-output base_amt_fmt,
                          input gl_rnd_mthd)"}
assign
   curr_amt_old = base_amt:format
   oldsession = SESSION:numeric-format
   oldcurr = "".

{wbrp01.i}

/* SS - 100705.1 - B
repeat:
SS - 100705.1 - E */

   if batch1 = hi_char then batch1 = "".
   if check1 = hi_char then check1 = "".
   if cust1 = hi_char then cust1 = "".
   if entity1 = hi_char then entity1 = "".
   if ardate = low_date then ardate = ?.
   if ardate1 = hi_date then ardate1 = ?.
   if effdate = low_date then effdate = ?.
   if effdate1 = hi_date then effdate1 = ?.

   /* SS - 100705.1 - B
   if c-application-mode <> 'web' then
      update
         batch batch1
         check_nbr check1
         cust cust1
         entity entity1
         ardate ardate1
         effdate effdate1
         summary
         gltrans
         base_rpt
      with frame a.

   {wbrp06.i &command = update &fields = "  batch batch1 check_nbr check1
          cust cust1 entity entity1 ardate ardate1 effdate effdate1 summary
          gltrans base_rpt" &frm = "a"}
   SS - 100705.1 - E */

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

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
      {mfquoter.i summary  }
      {mfquoter.i gltrans  }
      {mfquoter.i base_rpt}

      if batch1 = "" then batch1 = hi_char.
      if check1 = "" then check1 = hi_char.
      if cust1 = "" then cust1 = hi_char.
      if entity1 = "" then entity1 = hi_char.
      if ardate = ? then ardate = low_date.
      if ardate1 = ? then ardate1 = hi_date.
      if effdate = ? then effdate = low_date.
      if effdate1 = ? then effdate1 = hi_date.

   end.

   /* SS - 100705.1 - B
   /* SELECT OUTPUT */
   {gpselout.i &printType = "printer"
            &printWidth = 132
            &pagedFlag = " "
            &stream = " "
            &appendToFile = " "
            &streamedOutputToFile = " "
            &withBatchOption = "yes"
            &displayStatementType = 1
            &withCancelMessage = "yes"
            &pageBottomMargin = 6
            &withEmail = "yes"
            &withWinPrint = "yes"
            &defineVariables = "yes" }

   {mfphead.i}
   SS - 100705.1 - E */
   /* SS - 100705.1 - B */
   define variable l_textfile        as character no-undo.
   /* SS - 100705.1 - E */

   /* DELETE GL WORKFILE ENTRIES */
   if gltrans = yes then do:
      for each gltw_wkfl  where gltw_wkfl.gltw_domain = global_domain and
      gltw_userid = mfguser exclusive-lock:
         delete gltw_wkfl.
      end.
   end.

   do with frame d down:

      for each ar_mstr  where ar_mstr.ar_domain = global_domain and (  ar_batch
      >= batch and
            ar_batch <= batch1 and
            ar_check >= check_nbr and
            ar_check <= check1 and
            ar_bill /*ar_cust*/ >= cust and
            ar_bill /*ar_cust*/ <= cust1 and
            ar_entity >= entity and
            ar_entity <= entity1 and
            ar_date >= ardate and
            ar_date <= ardate1 and
            ar_effdate >= effdate and
            ar_effdate <= effdate1 and
            ar_type = "A" and
            ((ar_curr = base_rpt) or (base_rpt = ""))
            ) no-lock break by ar_batch by ar_nbr
         with frame c width 132 down:

         {mfrpchk.i}

         if (oldcurr <> ar_curr) or (oldcurr = "") then do:

            /* GET ROUNDING METHOD FROM CURRENCY MASTER */
            {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
               "(input ar_curr,
                 output rndmthd,
                 output mc-error-number)"}
            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4}
               if c-application-mode <> "WEB" then
                  pause.
               leave.
            end.

            /* DETERMINE CURRENCY DISPLAY AMERICAN OR EUROPEAN  */
            find rnd_mstr  where rnd_mstr.rnd_domain = global_domain and
            rnd_rnd_mthd = rndmthd
               no-lock no-error.
            if not available rnd_mstr then do:
               /* ROUND METHOD RECORD NOT FOUND */
               {pxmsg.i &MSGNUM=863 &ERRORLEVEL=4}
               leave.
            end.
            /* ASSUME CURRENT SETTING IS SET FOR BASE CURRENCY*/
            /* SET SESSION IF BASE_RPT <> BASE */
            if (base_rpt <> "")
            then do:
               /* IF RND_DEC_PT = COMMA FOR DECIMAL POINT */
               /* THIS IS A EUROPEAN STYLE CURRENCY */
               if (rnd_dec_pt = "," )
               then SESSION:numeric-format = "European".
               else SESSION:numeric-format = "American".
            end.

            curr_amt_fmt = curr_amt_old.
            {gprun.i ""gpcurfmt.p"" "(input-output curr_amt_fmt,
                                      input rndmthd)"}
            oldcurr = ar_curr.
         end.

         assign
            base_amt = ar_amt
            base_amt:format = curr_amt_fmt.
         if base_rpt = "" and ar_curr <> base_curr then
            assign
               base_amt:format = base_amt_fmt
               base_amt = ar_base_amt.

         /* SS - 100705.1 - B
         if first-of(ar_batch) then do with frame b:
            /* SET EXTERNAL LABELS */
            setFrameLabels(frame b:handle).
            display ar_batch with frame b side-labels.
         end. /* if first-of(ar_batch) */
         SS - 100705.1 - E */

         find ad_mstr  where ad_mstr.ad_domain = global_domain and  ad_addr =
         ar_bill no-lock no-wait
            no-error.
         if available ad_mstr
         then
            name = ad_name.
         else
            name = "".
         /* SS - 100705.1 - B
         display
            ar_nbr
            ar_bill
            name
            ar_type
            ar_check
            base_amt
            ar_date
            ar_effdate
            ar_entity
            ar_acct
            ar_sub
            ar_cc
            ar_po
         with frame d.
         down 1 with frame d.
         SS - 100705.1 - E */
         /* SS - 100705.1 - B */
         CREATE tt1.
         ASSIGN
            tt1_batch = ar_batch
            tt1_nbr = ar_nbr
            tt1_bill = ar_bill
            tt1_name = NAME
            tt1_type = ar_type
            tt1_check = ar_check
            tt1_base_amt = base_amt
            tt1_date = ar_date
            tt1_effdate = ar_effdate
            tt1_entity = ar_entity
            tt1_acct = ar_acct
            tt1_sub = ar_sub
            tt1_cc = ar_cc
            tt1_po = ar_po
            .
         /* SS - 100705.1 - E */

         if gltrans then do:
            {gpnextln.i &ref=ar_bill &line=return_int}
            create gltw_wkfl. gltw_wkfl.gltw_domain = global_domain.
            assign
               gltw_entity = ar_entity
               gltw_acct = ar_acct
               gltw_sub = ar_sub
               gltw_cc = ar_cc
               gltw_ref = ar_bill
               gltw_line = return_int
               gltw_date = ar_date
               gltw_effdate = ar_effdate
               gltw_userid = mfguser
               gltw_desc = ar_batch + " " + ar_type + " " + ar_nbr
               gltw_amt = base_amt.
            recno = recid(gltw_wkfl).
         end.

         /* GET AR DETAIL  */
         detlines = 0.
         for each ard_det  where ard_det.ard_domain = global_domain and
         ard_nbr = ar_nbr no-lock
               by ard_acct
               by ard_sub
            with frame e width 132:

            basepayforeign = no.
            /* GET MEMO OR INVOICE ASSOCIATED WITH THIS PMT */
            if ard_ref <> " " then do:
               find armstr  where armstr.ar_domain = global_domain and
               armstr.ar_nbr = ard_ref no-lock
                  no-error.
               if available armstr and armstr.ar_curr <> base_curr
                  and (ar_mstr.ar_curr = base_curr or
                       base_rpt <> armstr.ar_curr )
               then
                  /* BASE PMT ON A FOREIGN CURR MEMO/INVOICE */
                  basepayforeign = yes.
            end. /* IF ard_ref <> " " */

            /* WITH EURO TRANSPARENCY AN EMU CURRENCY PAYMENT CAN SETTLE */
            /* THE INVOICE/MEMO THAT IS IN ANOTHER EMU CURRENCY AND BOTH */
            /* THE CURRENCIES MAY NOT BE BASE.                           */
            assign foreignpayforeign = no.
            if available armstr then
               if armstr.ar_curr <> base_curr and
                  ar_mstr.ar_curr <> base_curr and
                  armstr.ar_curr <> ar_mstr.ar_curr and
                  base_rpt = ""
               then
                  foreignpayforeign = yes.

            /* IF PMT CURR = BASE OR BASE REPT = PMT CURR */
            if ar_mstr.ar_curr = base_curr or
               base_rpt = ar_mstr.ar_curr
            then do:
               assign
                  base_damt:format = curr_amt_fmt
                  base_damt        = ard_amt
                  base_det_amt     = ard_amt
                  disp_curr        = " ".

               if basepayforeign or foreignpayforeign then do:
                  if ar_mstr.ar_curr = armstr.ar_curr
                  then do:
                     /* CONVERT FROM FOREIGN TO BASE CURRENCY */
                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input armstr.ar_curr,
                          input base_curr,
                          input armstr.ar_ex_rate,
                          input armstr.ar_ex_rate2,
                          input ard_amt,
                          input true, /* ROUND */
                          output base_glar_amt,
                          output mc-error-number)"}.
                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
                     end.
                  end.
                  else do:
                     /* CONVERT FROM FOREIGN TO BASE CURRENCY */
                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input armstr.ar_curr,
                          input base_curr,
                          input armstr.ar_ex_rate,
                          input armstr.ar_ex_rate2,
                          input ard_cur_amt,
                          input true, /* ROUND */
                          output base_glar_amt,
                          output mc-error-number)"}.
                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
                     end.
                  end.
               end. /* IF basepayforeign = yes */
               else
                  base_glar_amt = ard_amt.

            end. /* IF ar_mstr.ar_curr = base_curr */
            else do:
               assign
                  base_damt:format = base_amt_fmt.

               /* CONVERT FROM FOREIGN TO BASE CURRENCY */
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input ar_mstr.ar_curr,
                    input base_curr,
                    input ar_mstr.ar_ex_rate,
                    input ar_mstr.ar_ex_rate2,
                    input ard_amt,
                    input true, /* ROUND */
                    output base_damt,
                    output mc-error-number)"}.
               if mc-error-number <> 0 then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
               end.

               /* CONVERT FROM FOREIGN TO BASE CURRENCY */
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input ar_mstr.ar_curr,
                    input base_curr,
                    input ar_mstr.ar_ex_rate,
                    input ar_mstr.ar_ex_rate2,
                    input ard_amt,
                    input true, /* ROUND */
                    output base_det_amt,
                    output mc-error-number)"}.
               if mc-error-number <> 0 then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
               end.

               if basepayforeign or foreignpayforeign then do:
                  if ar_mstr.ar_curr = armstr.ar_curr
                  then do:
                     /* CONVERT FROM FOREIGN TO BASE CURRENCY */
                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input armstr.ar_curr,
                          input base_curr,
                          input armstr.ar_ex_rate,
                          input armstr.ar_ex_rate2,
                          input ard_amt,
                          input true, /* ROUND */
                          output base_glar_amt,
                          output mc-error-number)"}.
                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
                     end.
                  end.
                  else do:
                     /* CONVERT FROM FOREIGN TO BASE CURRENCY */
                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                        "(input armstr.ar_curr,
                          input base_curr,
                          input armstr.ar_ex_rate,
                          input armstr.ar_ex_rate2,
                          input ard_cur_amt,
                          input true, /* ROUND */
                          output base_glar_amt,
                          output mc-error-number)"}.
                     if mc-error-number <> 0 then do:
                        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
                     end.
                  end.
               end. /* IF basepayforeign = yes */
               else do:

                  /* CONVERT FROM FOREIGN TO BASE CURRENCY */
                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input ar_mstr.ar_curr,
                       input base_curr,
                       input ar_mstr.ar_ex_rate,
                       input ar_mstr.ar_ex_rate2,
                       input ard_amt,
                       input true, /* ROUND */
                       output base_glar_amt,
                       output mc-error-number)"}.
                  if mc-error-number <> 0 then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
                  end.
               end.

               disp_curr = getTermLabel("YES",1).
            end.

            type = "".

            if ard_type = "M" then
               type = getTermLabel("MEMO",10).
            else
            if ard_type = "F" then
               type = getTermLabel("FINANCE_CHARGE",10).
            else
            if ard_type = "I" then
               type = getTermLabel("INVOICE",10).

            detlines = detlines + 1.
            accumulate base_damt (total).

            /* SS - 100705.1 - B
            if not summary then do with frame c:
               display
                  ard_ref
                  type
                  ard_entity
                  ard_acct
                  ard_sub
                  ard_cc
                  disp_curr
                  base_damt.
               down 1.
            end.
            SS - 100705.1 - E */
            /* SS - 100705.1 - B */
            CREATE ttxxarparp0101.
            ASSIGN
               ttxxarparp0101_batch = tt1_batch
               ttxxarparp0101_nbr = tt1_nbr
               ttxxarparp0101_bill = tt1_bill
               ttxxarparp0101_name = tt1_NAME
               ttxxarparp0101_type = tt1_type
               ttxxarparp0101_check = tt1_check
               ttxxarparp0101_base_amt = tt1_base_amt
               ttxxarparp0101_date = tt1_date
               ttxxarparp0101_effdate = tt1_effdate
               ttxxarparp0101_entity = tt1_entity
               ttxxarparp0101_acct = tt1_acct
               ttxxarparp0101_sub = tt1_sub
               ttxxarparp0101_cc = tt1_cc
               ttxxarparp0101_po = tt1_po

               ttxxarparp0101_ard_ref = ard_ref
               ttxxarparp0101_ard_type = ard_type
               ttxxarparp0101_ard_entity = ard_entity
               ttxxarparp0101_ard_acct = ard_acct
               ttxxarparp0101_ard_sub = ard_sub
               ttxxarparp0101_ard_cc = ard_cc
               ttxxarparp0101_disp_curr = disp_curr
               ttxxarparp0101_base_damt = base_damt
               .
            /* SS - 100705.1 - E */

            /* SS - 100705.1 - B
            if gltrans then do:
               {gpnextln.i &ref=ar_mstr.ar_bill &line=return_int}
               create gltw_wkfl. gltw_wkfl.gltw_domain = global_domain.
               assign
                  gltw_entity = ard_entity
                  gltw_acct = ard_acct
                  gltw_sub = ard_sub
                  gltw_cc = ard_cc
                  gltw_ref = ar_mstr.ar_bill
                  gltw_line = return_int
                  gltw_date = ar_mstr.ar_date
                  gltw_effdate = ar_mstr.ar_effdate
                  gltw_userid = mfguser
                  gltw_desc = ar_mstr.ar_batch + " " +
                  ar_mstr.ar_type + " " + ar_mstr.ar_nbr
                  gltw_amt = - base_glar_amt.
               recno = recid(gltw_wkfl).

               if base_curr <> ar_mstr.ar_curr or
                  basepayforeign or foreignpayforeign
               then do:
                  if base_rpt = " " or base_rpt = base_curr then
                     gain_amt = base_glar_amt - base_damt.
                  if basepayforeign = no and
                     foreignpayforeign = no and
                     base_rpt = ar_mstr.ar_curr
                  then
                     gain_amt = 0.

                  if gain_amt <> 0 then do:
                     {gpnextln.i &ref=ar_mstr.ar_bill &line=return_int}
                     create gltw_wkfl. gltw_wkfl.gltw_domain = global_domain.

                     assign
                        gltw_entity  = ar_mstr.ar_entity
                        gltw_acct    = ar_mstr.ar_var_acct
                        gltw_sub     = ar_mstr.ar_var_sub
                        gltw_cc      = ar_mstr.ar_var_cc
                        gltw_ref     = ar_mstr.ar_bill
                        gltw_line    = return_int
                        gltw_date    = ar_mstr.ar_date
                        gltw_effdate = ar_mstr.ar_effdate
                        gltw_userid  = mfguser
                        gltw_desc    = ar_mstr.ar_batch + " " +
                        ar_mstr.ar_type + " " + ar_mstr.ar_nbr
                        gltw_amt     = gain_amt.
                     recno = recid(gltw_wkfl).
                  end.
               end.

               /* FOLLOWING GLTW LINES ARE FOR INTER-COMPANY */
               if (ar_mstr.ar_entity <> ard_entity)
               then do:
                  {glenacex.i &entity=ar_mstr.ar_entity
                        &type='"DR"'
                        &module='"AR"'
                        &acct=ico_acct
                        &sub=ico_sub
                        &cc=ico_cc }
                   /*DEBIT DETAIL ENTITY*/
                   {gpnextln.i &ref=ar_mstr.ar_bill &line=return_int}
                   create gltw_wkfl. gltw_wkfl.gltw_domain = global_domain.
                   assign
                       gltw_entity = ard_entity
                       gltw_acct = ico_acct
                       gltw_sub = ico_sub
                       gltw_cc = ico_cc
                       gltw_ref = ar_mstr.ar_bill
                       gltw_line = return_int
                       gltw_date = ar_mstr.ar_date
                       gltw_effdate = ar_mstr.ar_effdate
                       gltw_userid = mfguser
                       gltw_desc = ar_mstr.ar_batch + " " +
                                   ar_mstr.ar_type + " " +
                                   ar_mstr.ar_nbr
                       gltw_amt = base_glar_amt
                       recno = recid(gltw_wkfl).
                   /*CREDIT HEADER ENTITY*/
                   {glenacex.i &entity=ard_entity
                               &type='"CR"'
                               &module='"AR"'
                               &acct=ico_acct
                               &sub=ico_sub
                               &cc=ico_cc }
                   {gpnextln.i &ref=ar_bill &line=return_int}
                   create gltw_wkfl. gltw_wkfl.gltw_domain = global_domain.
                   assign
                       gltw_entity = ar_mstr.ar_entity
                       gltw_acct = ico_acct
                       gltw_sub = ico_sub
                       gltw_cc = ico_cc
                       gltw_ref = ar_mstr.ar_bill
                       gltw_line = return_int
                       gltw_date = ar_mstr.ar_date
                       gltw_effdate = ar_mstr.ar_effdate
                       gltw_userid = mfguser
                       gltw_desc = ar_mstr.ar_batch + " " +
                                   ar_mstr.ar_type + " " +
                                   ar_mstr.ar_nbr
                       gltw_amt = - base_glar_amt
                       recno = recid(gltw_wkfl).
               end. /* INTER-COMPANY */

            end.
            SS - 100705.1 - E */
         end.  /* ard_det loop */
         /* SS - 100705.1 - B
         accumulate (accum total  (base_damt))
            (total by ar_mstr.ar_batch).

         if detlines > 1 and not summary then do with frame c:
            if page-size - line-counter < 3 then page.
            underline base_damt.

            display
               getTermLabelRt("PAYMENT",10) @ type
               getTermLabelRtColon("TOTALS",7) @  ard_entity
               format "x(7)"
               accum total (base_damt) @ base_damt.

            down 2.
         end.

         if last-of(ar_mstr.ar_batch) then do:
            if page-size - line-counter < 4 then page.
            if summary then do with frame d:
               underline base_amt.

               c-base-rpt-lbl1 =
                  getTermLabelRtColon("BASE_BATCH_TOTALS",20).
               c-base-rpt-lbl2 =
                  getTermLabelRtColon("BATCH_TOTALS",24).
               display
                  (if base_rpt = ""
                   then c-base-rpt-lbl1
                   else
                      base_rpt + " " + c-base-rpt-lbl2 )
                  @ name
                  accum total by ar_mstr.ar_batch
                  (accum total base_damt) @ base_amt.

               down 3.
            end.
            else do with frame c:
               underline base_damt.

               assign
                  c-base-rpt-lbl1 = getTermLabel("BASE_BATCH",10)
                  c-base-rpt-lbl2 = getTermLabelRt("BATCH",5).
               display
                  (if base_rpt = ""
                   then c-base-rpt-lbl1
                   else
                      base_rpt + " " + c-base-rpt-lbl2)
                  @ type
                  getTermLabelRtColon("TOTALS",7) @  ard_entity
                  format "x(7)"
                  accum total by ar_mstr.ar_batch
                  (accum total base_damt) @ base_damt.

               down 3.
            end.
         end.  /* batch totals */

         if last (ar_mstr.ar_nbr) then do:  /* report totals */
            if page-size - line-counter < 3 then page.
            if summary then do with frame d:
               underline base_amt.

               assign
                  c-base-rpt-lbl1 =
                     getTermLabelRtColon("BASE_REPORT_TOTALS",24)
                  c-base-rpt-lbl2 =
                     getTermLabelRtColon("REPORT_TOTALS",20).

               display
                  (if base_rpt = ""
                   then c-base-rpt-lbl1
                   else base_rpt + " " + c-base-rpt-lbl2 )
                  @ name
                  accum total (accum total base_damt) @ base_amt.

               down 2.
            end.
            else do with frame c:
               underline base_damt.

               assign
                  c-base-rpt-lbl1 = getTermLabel("BASE_REPRT",11)
                  c-base-rpt-lbl2 = getTermLabelRt("REPORT",5).

               display
                  (if base_rpt = ""
                   then c-base-rpt-lbl1
                   else base_rpt + " " + c-base-rpt-lbl2 )
                  @ type
                  getTermLabelRtColon("TOTALS",7) @  ard_entity
                  format "x(7)"
                  accum total
                  (accum total base_damt) @ base_damt.

               down 2.
            end.
         end.  /* report totals */
         SS - 100705.1 - E */

         {mfrpexit.i}
      end.  /* ar_mstr loop */

   end.  /* scope for frame d */

   /* SS - 100705.1 - B
   /* PRINT GL DISTRIBUTION */
   if gltrans then do:
      page.
      SESSION:numeric-format = oldsession.

      /* CHANGED GPGLRP.P TO GPGLRP1.P WHICH PRINTS GL DISTRIBUTION */
      /* TAKING INTO CONSIDERATION THE ROUNDING METHOD OF THE       */
      /* CURRENCY SPECIFIED IN SELECTION CRITERIA.                  */

      {gprun.i ""gpglrp1.p""}
   end.

   /* REPORT TRAILER */
   {mfrtrail.i}

end.
SESSION:numeric-format = oldsession.
   SS - 100705.1 - E */

{wbrp04.i &frame-spec = a}
