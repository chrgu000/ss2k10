/* arcsrp03.p - AR CUSTOMER STATEMENTS                                        */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.11.1.13 $                                                      */
/*V8:ConvertMode=FullGUIReport                                                */
/* REVISION: 1.0      LAST MODIFIED: 07/16/86   BY: PML                       */
/* REVISION: 6.0      LAST MODIFIED: 09/20/90   BY: afs *D059*                */
/* REVISION: 6.0      LAST MODIFIED: 10/12/90   BY: afs *D099*                */
/* REVISION: 6.0      LAST MODIFIED: 03/29/91   BY: bjb *D470*                */
/* REVISION: 6.0      LAST MODIFIED: 10/10/91   BY: pml *F018*                */
/* REVISION: 7.0      LAST MODIFIED: 02/26/92   by: jms *F237*                */
/* REVISION: 7.3      LAST MODIFIED: 09/03/92   BY: afs *G045*                */
/*                                   09/15/93   BY: jjs *GF27*                */
/*                                   12/08/93   by: jms *GH79*                */
/*                                   12/09/93   by: jms *GH82*                */
/*                                   10/11/94   by: str *FS29*                */
/*                                   12/06/94   by: cdt *GO70*                */
/* REVISION: 8.5      LAST MODIFIED: 12/08/95   BY: taf *J053*                */
/* REVISION: 8.5      LAST MODIFIED: 07/29/96   BY: taf *J101*                */
/* REVISION: 8.5      LAST MODIFIED: 09/03/97   BY: *J209* Irine D'mello      */
/* REVISION: 8.6      LAST MODIFIED: 10/09/97   BY: bvm *K0PL*                */
/* REVISION: 8.6      LAST MODIFIED: 01/06/98   BY: *J295* Irine D'mello      */
/* REVISION: 8.6                     02/02/98   by: *H1JC* Jean Miller        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98   BY: *L01K* Jaydeep Parikh     */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 01/13/00   BY: *M0HS* Ranjit Jain        */
/* REVISION: 9.1      LAST MODIFIED: 02/10/00   BY: *N07W* Rajesh Thomas      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 04/12/00   BY: *N07D* Antony Babu        */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* Jacolyn Neder      */
/* REVISION: 9.1      LAST MODIFIED: 09/22/00   BY: *N0VV* Mudit Mehta        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.11.1.10    BY: Jean Miller        DATE: 12/14/01  ECO: *P03Q*  */
/* Revision: 1.11.1.11  BY: Kedar Deherkar DATE: 05/27/03 ECO: *N2G0* */
/* $Revision: 1.11.1.13 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00B* */
/*-Revision end---------------------------------------------------------------*/
/* SS - 20081007.1 By: Bill Jiang */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20081007.1 - B */
/*
/* DISPLAY TITLE */
{mfdtitle.i "2+ "}
*/
{xxmfdtitle.i "2+ "}

{xxarcsrp0302.i}

define INPUT PARAMETER i_cust  like ar_bill.
define INPUT PARAMETER i_cust1 like ar_bill.
define INPUT PARAMETER i_entity  like ar_bill.
define INPUT PARAMETER i_entity1 like ar_bill.
define INPUT PARAMETER i_effdate   like ar_effdate.
define INPUT PARAMETER i_effdate1   like ar_effdate.
define INPUT PARAMETER i_start_date   like oa_fr_date.
define INPUT PARAMETER i_bal_out      like mfc_logical.
define INPUT PARAMETER i_stmt_cyc     like cm_stmt_cyc.
/* SS - 20081007.1 - E */
{cxcustom.i "ARCSRP03.P"}

define variable oldsession as character.
define variable oldcurr like ar_curr no-undo.
define variable rndmthd like rnd_rnd_mthd no-undo.
define variable curr_amt_fmt as character no-undo.
define variable curr_amt_old as character no-undo.
define variable cust  like ar_bill no-undo.
define variable cust1 like ar_bill no-undo.
/* SS - 20081007.1 - B */
define variable entity  like ar_entity no-undo.
define variable entity1 like ar_entity no-undo.
/* SS - 20081007.1 - E */

define variable start_date   like oa_fr_date no-undo.
define variable type         as character format "x(8)" label "Type" no-undo.
define variable age_days     as integer extent 5 label "Column Days" no-undo.
define variable age_range    as character extent 5 format "x(16)" no-undo.
define variable i            as integer no-undo.
define variable age_amt      like ar_amt extent 5 no-undo.
define variable age_period   as integer no-undo.
define variable stmt_cyc     like cm_stmt_cyc no-undo.
define variable comp_addr    like soc_company no-undo.
define variable msg          like msg_desc format "x(60)" no-undo.
define variable pages        as integer no-undo.
define variable current_bal  like ar_amt no-undo.
define variable unapplied    like ar_amt no-undo.
define variable disc         like ard_disc no-undo.
define variable bal_out      like mfc_logical
   label "Outstanding Balance Only" no-undo.
define variable company      as character format "x(40)" extent 6 no-undo.
define variable billto       as character format "x(40)" extent 6 no-undo.
define variable base_amt     like ar_amt no-undo.
define variable base_applied like ar_applied no-undo.
define variable base_open    like ar_amt no-undo.
define variable base_disc    like ard_disc no-undo.
define variable due-date     like ar_due_date no-undo.
define variable amt-to-apply like ar_amt no-undo.
define variable amt-due      like ar_amt no-undo.
define variable amt-open     like ar_amt no-undo.
define variable j            as integer no-undo.
define variable open_ref     like ar_amt extent 3 no-undo.
define variable mgot         like mfc_logical no-undo.
define variable contested    as character format "x(1)" no-undo.
define variable contest_amt  like ar_amt
   label "Contested Amount" no-undo.
define new shared variable addr as character format "x(38)" extent 6.
define variable contest_tot  like ar_amt no-undo.
define variable total-amt    like ar_amt no-undo.

define variable mc-error-number like msg_nbr no-undo.
{&ARCSRP03-P-TAG1}
define variable l_msgdesc       like msg_desc no-undo.

/* SS - 20081007.1 - B */
DEFINE VARIABLE artype1 LIKE ar_type.
DEFINE VARIABLE artype2 LIKE ar_type.
/* SS - 20081007.1 - E */

/* MUST INCLUDE gprunpdf.i IN THE MAIN BLOCK OF THE PROGRAM SO THAT */
/* CALLS TO gprunp.i FROM ANY OF THE INTERNAL PROCEDURES SKIPS  */
/* DEFINITION OF SHARED VARS OF gprunpdf.i */
/* FOR FURTHER INFO REFER TO HEADER COMMENTS IN gprunp.i */
{gprunpdf.i "mcpl" "p"}
{gprunpdf.i "mcui" "p"}

form
   cust           colon 25 cust1  label "To" colon 49 
   /* SS - 20081007.1 - B */
   entity           colon 25 entity1  label "To" colon 49 
   /* SS - 20081007.1 - E */
   skip (1)
   start_date     colon 25 skip
   bal_out        colon 25 skip
   stmt_cyc       colon 25 skip
   comp_addr      colon 25 skip (1)
   msg            colon 17 skip
   age_days[1]    colon 17
   age_days[2]    label "[2]"
   age_days[3]    label "[3]" skip (1)
with frame a side-labels width 80.

/* SS - 20081007.1 - B */
/*
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
*/
cust = i_cust.
cust1 = i_cust1.
entity = i_entity.
entity1 = i_entity1.
START_date = i_start_date.
bal_out = i_bal_out.
stmt_cyc = i_stmt_cyc.
/* SS - 20081007.1 - E */

form
   ar_date
   ar_nbr     format "x(9)"
   type
   due-date
   amt-due
   amt-open   label "Amount Open"
   contested  no-label
   ar_curr
with frame c width 80 down.

/* SS - 20081007.1 - B */
/*
/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).
*/
/* SS - 20081007.1 - E */

curr_amt_old = amt-due:format in frame c.
oldsession = SESSION:numeric-format.

find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.

find first soc_ctrl  where soc_ctrl.soc_domain = global_domain no-lock.
if available soc_ctrl then
   comp_addr = soc_company.
else
   comp_addr = "".

{wbrp01.i}

/* C - indicated Contested Invoice/Memo */
{pxmsg.i &MSGNUM=760 &ERRORLEVEL=1 &MSGBUFFER=l_msgdesc}

/* SS - 20081007.1 - B */
/*
repeat:
*/
/* SS - 20081007.1 - E */

   assign company = "".

   if cust1 = hi_char then cust1 = "".
   /* SS - 20081007.1 - B */
   if entity1 = hi_char then entity1 = "".
   /* SS - 20081007.1 - E */
   if start_date = low_date then start_date = ?.

   /* SS - 20081007.1 - B */
   /*
   if age_days[1] = 0 then age_days[1] = 1.
   if age_days[2] = 0 then age_days[2] = 30.
   if age_days[3] = 0 then age_days[3] = 60.

   display
      cust cust1
      /* SS - 20081007.1 - B */
      entity entity1
      /* SS - 20081007.1 - E */
      start_date
      bal_out
      stmt_cyc
      comp_addr
      age_days[1 for 3]
      msg
   with frame a.

   if c-application-mode <> "WEB" then
   set
      cust cust1
      /* SS - 20081007.1 - B */
      entity
      entity1
      /* SS - 20081007.1 - E */
      start_date
      bal_out
      stmt_cyc
      comp_addr
      age_days[1 for 3]
      msg
   with frame a.

   {wbrp06.i &command = set
      &fields  = "  cust
        cust1
      /* SS - 20081007.1 - B */
      entity
      entity1
      /* SS - 20081007.1 - E */
        start_date
        bal_out
        stmt_cyc
        comp_addr
        age_days [ 1 for 3 ]
        msg"
      &frm     = "a"}
   */
   /* SS - 20081007.1 - E */

   if (c-application-mode <> "WEB") or
      (c-application-mode = "WEB" and
      (c-web-request begins "DATA"))
   then do:

      bcdparm = "".

      {mfquoter.i cust        }
      {mfquoter.i cust1       }
         /* SS - 20081007.1 - B */
         {mfquoter.i entity        }
         {mfquoter.i entity1       }
         /* SS - 20081007.1 - E */
      {mfquoter.i start_date  }
      {mfquoter.i bal_out     }
      {mfquoter.i stmt_cyc    }
      {mfquoter.i comp_addr   }
      {mfquoter.i age_days[1] }
      {mfquoter.i age_days[2] }
      {mfquoter.i age_days[3] }
      {mfquoter.i msg         }

      /* Add do loop to prevent converter from creating on leave of */
      do:
         if comp_addr <> "" then do:

            find ad_mstr  where ad_mstr.ad_domain = global_domain and  ad_addr
            = comp_addr
            no-lock no-wait no-error.

            if available ad_mstr then do:

               if not can-find(ls_mstr  where ls_mstr.ls_domain = global_domain
               and  ls_addr = ad_addr and
                                             ls_type = "company")
               then do:
                  /* Not a valid compaany */
                  {pxmsg.i &MSGNUM=28 &ERRORLEVEL=3}
                  if c-application-mode = "WEB" then return.
                  else
                     next-prompt comp_addr with frame a.
                  undo, retry.
               end.

               addr[1] = ad_name.
               addr[2] = ad_line1.
               addr[3] = ad_line2.
               addr[4] = ad_line3.
               addr[6] = ad_country.
               {mfcsz.i addr[5] ad_city ad_state ad_zip}.
               {gprun.i ""gpaddr.p"" }
               company[1] = addr[1].
               company[2] = addr[2].
               company[3] = addr[3].
               company[4] = addr[4].
               company[5] = addr[5].
               company[6] = addr[6].

            end.

            else do:
               /* Not a valid company */
               {pxmsg.i &MSGNUM=28 &ERRORLEVEL=3}
               if c-application-mode = "WEB" then return.
               else
                  next-prompt comp_addr with frame a.
               undo, retry.
            end.

         end.

      end.

      if cust1 = "" then cust1 = hi_char.
      /* SS - 20081007.1 - B */
      if entity1 = "" then entity1 = hi_char.
      /* SS - 20081007.1 - E */
      if start_date = ? then start_date = low_date.

   end. /* if c-application-mode <> "WEB"...*/

   /* SS - 20081007.1 - B */
   /*
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
   */
   define variable l_textfile        as character no-undo.
   /* SS - 20081007.1 - E */

   /* SS - 20081007.1 - B */
   /*
   /* CREATE REPORT HEADER */
   do i = 1 to 3:
      age_range[i] = getTermLabelRt("PAST_DUE",11) + " " +
                     string(age_days[i],"->>9").
   end.
   */
   /* SS - 20081007.1 - E */

   for each cm_mstr  where cm_mstr.cm_domain = global_domain and (
      cm_addr >= cust and cm_addr <= cust1 and
       /* SS - 20081007.1 - B */
       /*
      cm_stmt = yes and
       */
       /* SS - 20081007.1 - E */
      (cm_stmt_cyc = stmt_cyc or stmt_cyc = "") and
      (cm_balance <> 0 or bal_out = no)
   ) no-lock:

      /* SS - 20081007.1 - B */
      artype1 = getTermLabel("DRAFT",8).
      /* SS - 20081007.1 - E */

      for each ar_mstr  where ar_mstr.ar_domain = global_domain and (
         ar_bill = cm_addr 
         /* SS - 20081007.1 - B */
         AND ar_entity >= entity AND ar_entity <= entity1
         /* SS - 20081007.1 - E */
         and
         ((ar_amt - ar_applied <> 0) or ar_date >= start_date) and
          (bal_out = no or ar_amt - ar_applied <> 0) and
         ar_type <> "A" and
         /* SS - 20081007.1 - B */
         /*
         (not ar_type = "D" or ar_draft = true)
         */
         (not (ar_type = "D" OR ar_type = artype1) or ar_draft = true)
         AND ar_effdate >= i_effdate
         AND ar_effdate <= i_effdate1
         /* SS - 20081007.1 - E */
      ) no-lock break by ar_bill by ar_curr
      by ar_date:

         if (oldcurr <> ar_curr) or (oldcurr = "") then do:

            if ar_curr = gl_base_curr then
               rndmthd = gl_rnd_mthd.
            else do:
               /* GET ROUNDING METHOD FROM CURRENCY MASTER */
               {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                  "(input ar_curr,
                    output rndmthd,
                    output mc-error-number)"}
               if mc-error-number <> 0 then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4}
                  if c-application-mode <> "WEB" then
                     pause.
                  next.
               end.
            end.

            /* DETERMINE CURRENCY DISPLAY AMERICAN OR EUROPEAN    */
            find rnd_mstr  where rnd_mstr.rnd_domain = global_domain and
            rnd_rnd_mthd = rndmthd
            no-lock no-error.
            if not available rnd_mstr then do:
               {pxmsg.i &MSGNUM=863 &ERRORLEVEL=4}
               /* ROUND METHOD RECORD NOT FOUND */
               if c-application-mode = "WEB" then return.
               next.
            end.

            /* IF RND_DEC_PT = COMMA FOR DECIMAL POINT */
            /* THIS IS A EUROPEAN STYLE CURRENCY */
            if (rnd_dec_pt = "," )
               then
               SESSION:numeric-format = "European".
            else
               SESSION:numeric-format = "American".

            curr_amt_fmt = curr_amt_old.
            {gprun.i ""gpcurfmt.p""
               "(input-output curr_amt_fmt,
                 input rndmthd)"}

            amt-due:format in frame c= curr_amt_fmt.
            amt-open:format in frame c = curr_amt_fmt.
            oldcurr = ar_curr.

         end. /* if oldcurr <> ar_curr */

         /* SS - 20081007.1 - B */
         /*
         form
            header
            skip (3)
            company[1]     at 4
            getTermLabelRt("S_T_A_T_E_M_E_N_T",25) format "x(25)" to 78
            company[2]     at 4
            company[3]     at 4
            company[4]     at 4
            getTermLabelRtColon("PRINT_DATE",15) format "x(15)" to 59
            today
            getTermLabelRtColon("PAGE",5) + string(page-number - pages,">>9")
               to 78
            company[5]     at 4
            company[6]     at 4
            skip (1)
            getTermLabelRtColon("BILL_TO",8) at 8
            ar_bill
            skip (1)
            billto[1]      at 8
            billto[2]      at 8
            billto[3]      at 8
            billto[4]      at 8
            billto[5]      at 8
            billto[6]      at 8
            skip (3)
         with frame phead1 page-top width 90.

         view frame phead1.

         do i = 1 to 3:
            age_amt[i] = 0.
            open_ref[i] = 0.
         end.
         */
         /* SS - 20081007.1 - E */

         assign
            current_bal = 0
            unapplied   = 0
            contest_amt = 0
            disc        = 0
            type = "".

         if ar_type = "M" then type = getTermLabel("MEMO",8).
         else if ar_type = "I" then type = getTermLabel("INVOICE",8).
         else if ar_type = "F" then type = getTermLabel("FIN_CHG",8).
         else if ar_type = "P" then type = getTermLabel("PAYMENT",8).
         else if ar_type = "D" then type = getTermLabel("DRAFT",8).

         if ar_contested = yes then
            contested = "C".
         else
            contested = " ".

         if first-of(ar_bill) then do:
            find ad_mstr  where ad_mstr.ad_domain = global_domain and  ad_addr
            = ar_bill no-lock no-error.
            pages = page-number - 1.
            assign billto = "".
            if available ad_mstr then do:
               addr[1] = ad_name.
               addr[2] = ad_line1.
               addr[3] = ad_line2.
               addr[4] = ad_line3.
               addr[6] = ad_country.
               {mfcsz.i addr[5] ad_city ad_state ad_zip}
               {gprun.i ""gpaddr.p"" }
               billto[1] = addr[1].
               billto[2] = addr[2].
               billto[3] = addr[3].
               billto[4] = addr[4].
               billto[5] = addr[5].
               billto[6] = addr[6].
            end.
         end.

         base_amt = ar_amt.
         base_applied = ar_applied.

         /*NOTE: USED FOR EACH BECAUSE WITH VAT MAY HAVE MORE THAN 1 BLANK REF*/
         if ar_type = "P" and
            can-find(first ard_det  where ard_det.ard_domain = global_domain
            and  ard_nbr = ar_nbr and
            ard_ref = "")
         then do:
            for each ard_det  where ard_det.ard_domain = global_domain and
                  ard_nbr = ar_nbr and
                  ard_ref = ""
            no-lock:
               if ard_type = "N" then do:
                  base_amt = base_amt + ard_amt.
                  base_applied = base_applied + ard_amt.
               end.
            end.
         end.

         base_open = base_amt - base_applied.

         /*AGE OPEN AMOUNTS */
         amt-to-apply = base_applied.

         find ct_mstr  where ct_mstr.ct_domain = global_domain and  ct_code =
         ar_cr_terms no-lock no-error.

         if available ct_mstr and ct_dating = yes then do:

            j = 0.
            total-amt = 0.

            for each ctd_det  where ctd_det.ctd_domain = global_domain and
            ctd_code = ar_cr_terms no-lock
            break by ctd_code:

               find ct_mstr  where ct_mstr.ct_domain = global_domain and
               ct_code = ctd_date_cd
               no-lock no-error.

               if available ct_mstr then do:
                  {&ARCSRP03-P-TAG2}
                  if (ct_due_inv = 1) then
                     due-date  = ar_date + ct_due_days.
                  else
                     due-date = date((month(ar_date) + 1) modulo 12 +
                                if month(ar_date) = 11
                                then 12 else 0, 1, year(ar_date) +
                                if month(ar_date) >= 12
                                then 1 else 0) + integer(ct_due_days) -
                                if ct_due_days <> 0 then 1 else 0.
                  if ct_due_date <> ? then due-date = ct_due_date.
                  {&ARCSRP03-P-TAG3}

                  /*CALCULATE BREAK DOWN OF INVOICE BY DUE DATES*/
                  /* TO PREVENT ROUNDING ERRORS ASSIGN           */
                  /* LAST BUCKET = ROUNDED TOTAL - RUNNING TOTAL */
                  if last-of(ctd_code) then
                     amt-due = base_amt - total-amt.
                  else
                     amt-due = base_amt * (ctd_pct_due / 100).

                  {gprunp.i "mcpl" "p" "mc-curr-rnd"
                     "(input-output amt-due,
                       input rndmthd ,
                       output mc-error-number)"}

                  total-amt = total-amt + amt-due.

                  if (amt-to-apply >= amt-due and base_amt >= 0)
                  or (amt-to-apply <= amt-due and base_amt < 0)
                  then do:
                     amt-open = 0.
                     amt-to-apply = amt-to-apply - amt-due.
                  end.
                  else do:
                     amt-open = amt-due - amt-to-apply.
                     amt-to-apply = 0.
                  end.

                  /*DISPLAY THIS SECTION OF THE INVOICE*/
                  /* SS - 20081007.1 - B */
                  /*
                  if j > 0 then down 1 with frame c.

                  display
                     ar_date
                     ar_nbr
                     type
                     due-date
                     amt-due
                     amt-open
                     contested
                     ar_curr
                  with frame c.

                  down 1 with frame c.
                  */
                  CREATE ttxxarcsrp0302.
                  ASSIGN
                     ttxxarcsrp0302_ar_bill = ar_bill
                     ttxxarcsrp0302_ar_cust = ar_cust
                     ttxxarcsrp0302_ar_date = ar_date
                     ttxxarcsrp0302_ar_nbr = ar_nbr
                     ttxxarcsrp0302_ar_type = ar_type
                     ttxxarcsrp0302_type = TYPE
                     ttxxarcsrp0302_ar_due_date = due-date
                     ttxxarcsrp0302_ar_effdate = ar_effdate
                     ttxxarcsrp0302_amt_due = amt-due
                     ttxxarcsrp0302_amt_open = amt-open
                     ttxxarcsrp0302_contested = contested
                     ttxxarcsrp0302_ar_curr = ar_curr
                     ttxxarcsrp0302_acct = ar_acct
                     ttxxarcsrp0302_sub = ar_sub
                     ttxxarcsrp0302_cc = ar_cc
                     ttxxarcsrp0302_ar_ex_rate = ar_ex_rate
                     ttxxarcsrp0302_ar_ex_rate2 = ar_ex_rate2
                     .
                  IF ar_type = getTermLabel("MEMO",8) THEN DO:
                     ASSIGN
                        ttxxarcsrp0302_ar_type = "M"
                        ttxxarcsrp0302_type = ar_type
                        .
                  END.
                  ELSE IF ar_type = getTermLabel("INVOICE",8) THEN DO:
                     ASSIGN
                        ttxxarcsrp0302_ar_type = "I"
                        ttxxarcsrp0302_type = ar_type
                        .
                  END.
                  ELSE IF ar_type = getTermLabel("FIN_CHG",8) THEN DO:
                     ASSIGN
                        ttxxarcsrp0302_ar_type = "F"
                        ttxxarcsrp0302_type = ar_type
                        .
                  END.
                  ELSE IF ar_type = getTermLabel("PAYMENT",8) THEN DO:
                     ASSIGN
                        ttxxarcsrp0302_ar_type = "P"
                        ttxxarcsrp0302_type = ar_type
                        .
                  END.
                  ELSE IF ar_type = getTermLabel("DRAFT",8) THEN DO:
                     ASSIGN
                        ttxxarcsrp0302_ar_type = "D"
                        ttxxarcsrp0302_type = ar_type
                        .
                  END.
                  /* SS - 20081007.1 - E */

                  j = j + 1.

                  /* CALCULATE THE AGING*/
                  /* SS - 20081007.1 - B */
                  /*
                  if ar_contested = no then do:
                     mgot = no.
                     do i = 3 to 1 by -1:
                        if ( today - age_days[i] ) >= due-date
                        then do:
                           open_ref[i] = open_ref[i] + amt-open.
                           mgot = yes.
                           leave.
                        end.
                     end.
                     if mgot = no then
                        current_bal = current_bal +  amt-open.
                  end. /* if ar_contested = no */
                  else do:
                     current_bal = current_bal + amt-open.
                     contest_amt = contest_amt + amt-open.
                  end.
                  */
                  /* SS - 20081007.1 - E */

               end. /*if avail ct_mstr*/

               if ctd_pct_due = 100 then leave.

            end. /*for each ctd_det*/

            /* SS - 20081007.1 - B */
            /*
            do i = 1 to 3:
               age_amt[i] =  open_ref[i].
            end.
            */
            /* SS - 20081007.1 - E */

         end. /*if available ct_mstr &  ct_dating = yes*/

         else do:

            /*DISPLAY THE LINE*/
            /* SS - 20081007.1 - B */
            /*
            display ar_date with frame c.

            if ar_type <> "P" then
            display
               ar_nbr format "x(9)"
               type
               ar_due_date @ due-date
            with frame c.

            else
            display
               ar_check  @ ar_nbr
               type
            with frame c.

            display
               base_amt @ amt-due
               base_open @ amt-open
               contested
               ar_curr
            with frame c.

            down 1 with frame c.
            */
            CREATE ttxxarcsrp0302.
            ASSIGN
               ttxxarcsrp0302_ar_bill = ar_bill
               ttxxarcsrp0302_ar_cust = ar_cust
               ttxxarcsrp0302_ar_date = ar_date
               ttxxarcsrp0302_ar_effdate = ar_effdate
               ttxxarcsrp0302_ar_type = ar_type
               .
            if ar_type <> "P" then
               ASSIGN
               ttxxarcsrp0302_ar_nbr = ar_nbr
               ttxxarcsrp0302_type = TYPE
               ttxxarcsrp0302_ar_due_date = ar_due_date
               ttxxarcsrp0302_acct = ar_acct
               ttxxarcsrp0302_sub = ar_sub
               ttxxarcsrp0302_cc = ar_cc
               ttxxarcsrp0302_ar_ex_rate = ar_ex_rate
               ttxxarcsrp0302_ar_ex_rate2 = ar_ex_rate2
               .
            ELSE DO:
               ASSIGN
                  ttxxarcsrp0302_ar_nbr = ar_nbr
                  ttxxarcsrp0302_ar_check = ar_check
                  ttxxarcsrp0302_type = TYPE
                  .
               for FIRST ard_det where ard_nbr = ar_nbr no-lock:
               end.
               IF AVAILABLE ard_det THEN DO:
                  ASSIGN
                     ttxxarcsrp0302_acct = ard_acct
                     ttxxarcsrp0302_sub = ard_sub
                     ttxxarcsrp0302_cc = ard_cc
                     ttxxarcsrp0302_ar_ex_rate = ar_ex_rate
                     ttxxarcsrp0302_ar_ex_rate2 = ar_ex_rate2
                     .
               END.
            END.
            ASSIGN
               ttxxarcsrp0302_amt_due = base_amt
               ttxxarcsrp0302_amt_open = base_open
               ttxxarcsrp0302_contested = contested
               ttxxarcsrp0302_ar_curr = ar_curr
               .
            IF ar_type = getTermLabel("MEMO",8) THEN DO:
               ASSIGN
                  ttxxarcsrp0302_ar_type = "M"
                  ttxxarcsrp0302_type = ar_type
                  .
            END.
            ELSE IF ar_type = getTermLabel("INVOICE",8) THEN DO:
               ASSIGN
                  ttxxarcsrp0302_ar_type = "I"
                  ttxxarcsrp0302_type = ar_type
                  .
            END.
            ELSE IF ar_type = getTermLabel("FIN_CHG",8) THEN DO:
               ASSIGN
                  ttxxarcsrp0302_ar_type = "F"
                  ttxxarcsrp0302_type = ar_type
                  .
            END.
            ELSE IF ar_type = getTermLabel("PAYMENT",8) THEN DO:
               ASSIGN
                  ttxxarcsrp0302_ar_type = "P"
                  ttxxarcsrp0302_type = ar_type
                  .
            END.
            ELSE IF ar_type = getTermLabel("DRAFT",8) THEN DO:
               ASSIGN
                  ttxxarcsrp0302_ar_type = "D"
                  ttxxarcsrp0302_type = ar_type
                  .
            END.
            /* SS - 20081007.1 - E */

            /*CALCULATE THE AGING*/
            /* SS - 20081007.1 - B */
            /*
            if ar_contested = no then do:
               age_period = 0.
               do i = 1 to 3:
                  if (today - age_days[i]) >= ar_due_date then
                     age_period = i.
               end.
               if ar_due_date = ? then
                  age_period = 0.
               if age_period <> 0 then
                  age_amt[age_period] = base_open.
               if age_period = 0 then
                  current_bal = base_open.
            end.

            else if ar_contested = yes then do:
               current_bal = base_open.
               contest_amt = base_open.
            end.
            */
            /* SS - 20081007.1 - E */

         end. /*else do, if not avaiable ct_mstr*/

         if ar_type = "P" then do:
            unapplied = base_open.
            for each ard_det  where ard_det.ard_domain = global_domain and
            ard_nbr = ar_nbr no-lock:
               base_disc = ard_disc.
               disc = disc - base_disc.
            end.
            /* SS - 20081007.1 - B */
            /*
            if disc <> 0 then do:
               display
                  getTermLabel("DISCOUNT",8) @ type
                  disc @ amt-due
               with frame c.
               down 1 with frame c.
            end.
            */
            /* SS - 20081007.1 - E */
         end. /* if ar_type = "P" */

         /* SS - 20081007.1 - B */
         /*
         accumulate age_amt (total by ar_curr).
         accumulate base_open (total by ar_curr).
         accumulate current_bal (total by ar_curr).
         accumulate unapplied (total by ar_curr).
         accumulate contest_amt (total by ar_curr).

         if last-of(ar_curr) then do:

            contest_tot = accum total by ar_curr (contest_amt).

            if contest_tot <> 0 then
               display
                  skip(2)
                  l_msgdesc no-label at 3 skip.

            if (page-size <> 0) and page-size - line-counter < 10
               then page.

            do while page-size - line-counter > 10:
               put skip(1).
            end.

            put
               skip(1)
               {gplblfmt.i &FUNC=getTermLabel(""TOTAL_AMOUNT_OPEN"",60)
                           &CONCAT="': '"} to 63
               (accum total by ar_curr (base_open)) -
               (accum total by ar_curr (unapplied)) format curr_amt_fmt
               skip
               {gplblfmt.i &FUNC=getTermLabel(""PAYMENTS_UNAPPLIED"",60)
                           &CONCAT="': '"} to 63
               accum total by ar_curr (unapplied) format curr_amt_fmt skip
               {gplblfmt.i &FUNC=getTermLabel(""TOTAL_CONTESTED"",17)
                           &CONCAT=':'} at 3
               accum total by ar_curr (contest_amt) format curr_amt_fmt
               ar_curr to 55
               {gplblfmt.i &FUNC=getTermLabel(""TOTAL"",5)
                            &CONCAT="': '"} to 63
               accum total by ar_curr (base_open) format curr_amt_fmt
               skip
               skip(1)
               {gplblfmt.i &FUNC=getTermLabel(""CURRENT"",18) } to 18
               age_range[1] to 35
               age_range[2] to 52
               age_range[3] to 69
               skip
               "  ---------------- ---------------- "
               "---------------- ----------------"
               accum total by ar_curr (current_bal) format curr_amt_fmt  to 18
               accum total by ar_curr (age_amt[1])  format curr_amt_fmt  to 35
               accum total by ar_curr (age_amt[2])  format curr_amt_fmt  to 52
               accum total by ar_curr (age_amt[3])  format curr_amt_fmt  to 69
               skip(1)
               msg at 4 skip.

            page.

         end. /* if last-of(ar_curr) */
         */
         /* SS - 20081007.1 - E */

         {mfrpchk.i}

      end. /* for each ar_mstr */

   end. /* for each cm_mstr */

   /* SS - 20081007.1 - B */
   /*
   {mfreset.i}

end. /* repeat */
*/
/* SS - 20081007.1 - E */

SESSION:numeric-format = oldsession.

{wbrp04.i &frame-spec = a}
