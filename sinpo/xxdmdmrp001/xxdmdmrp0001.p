/* xxdmdmrp001.p  -  dmdmrp.p - DRAFT MANAGEMENT REPORT                       */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.10.1.15 $                                                     */
/*V8:ConvertMode=FullGUIReport                                                */
/* REVISION: 7.0      LAST MODIFIED: 09/04/91   BY: JJS *F065*                */
/*                                   03/12/92   BY: JJS *F198*                */
/*                                   03/18/92   BY: TMD *F266*                */
/*                                   04/16/92   BY: JJS *F406*                */
/*                                   07/01/94   BY: SRK *FP18*                */
/*                                   08/24/94   BY: RXM *FQ43*                */
/* REVISION: 7.2      LAST MODIFIED: 10/27/94   BY: ame *FS96*                */
/* REVISION: 8.5      LAST MODIFIED: 12/12/95   BY: taf *J053*                */
/*                                   04/15/96   BY: jzw *G1T9*                */
/* REVISION: 8.5      LAST MODIFIED: 07/29/96   BY: taf *J101*                */
/* REVISION: 8.6      LAST MODIFIED: 10/09/97   BY: bvm *K0PR*                */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 06/19/98   BY: *L01K* Jaydeep Parikh     */
/* REVISION: 8.6E     LAST MODIFIED: 08/21/98   BY: *L070* Jaydeep Parikh     */
/* REVISION: 8.6E     LAST MODIFIED: 08/24/98   BY: *J2RF* Dana Tunstall      */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Paul Johnson       */
/* REVISION: 9.0      LAST MODIFIED: 07/30/99   BY: *L0FX* Jean Miller        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 06/21/00   BY: *N0DB* Rajinder Kamra     */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                */
/* REVISION: 9.1      LAST MODIFIED: 09/21/00   BY: *N0WP* BalbeerS Rajput    */
/* REVISION: 9.1      LAST MODIFIED: 09/14/00   BY: *N0MN* Inna Lyubarsky     */
/* REVISION: 9.1      LAST MODIFIED: 10/20/00   BY: *L14K* Jean Miller        */
/* REVISION: 9.1      LAST MODIFIED: 29 JUN 2001 BY:  *N0ZX* Ed van de Gevel  */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.10.1.12  BY: Hareesh V. DATE: 06/21/02 ECO: *N1HY* */
/* Revision: 1.10.1.14  BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00B* */
/* $Revision: 1.10.1.15 $ BY: Ed van de Gevel DATE: 01/09/04 ECO: *P1J9* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
define input parameter inbr        like ar_nbr                      no-undo.
define input parameter inbr1       like ar_nbr                      no-undo.
define input parameter ibill       like ar_bill                     no-undo.
define input parameter ibill1      like ar_bill                     no-undo.
define input parameter ientity     like ar_entity   format "x(4)"   no-undo.
define input parameter ientity1    like ar_entity   format "x(4)"   no-undo.
define input parameter ibatch      like ar_batch  initial ""        no-undo.
define input parameter ibatch1     like ar_batch  initial ""        no-undo.
define input parameter icc         like ar_cc                       no-undo.
define input parameter icc1        like ar_cc                       no-undo.
define input parameter iardate     like ar_date                     no-undo.
define input parameter iardate1    like ar_date                     no-undo.
define input parameter iduedate    like ar_due_date                 no-undo.
define input parameter iduedate1   like ar_due_date                 no-undo.
define input parameter ieffdate    like ar_effdate                  no-undo.
define input parameter ieffdate1   like ar_effdate                  no-undo.
define input parameter istat       as character                     no-undo.
define input parameter ibase_rpt   like ar_curr                     no-undo.


{xxmfdtitle.i "1"}
{cxcustom.i "DMDMRP.P"}

/* ********** BEGIN TRANSLATABLE STRINGS DEFINITIONS ********* */

{&DMDMRP-P-TAG22}

{&DMDMRP-P-TAG23}

/* ********** END TRANSLATABLE STRINGS DEFINITIONS ********* */

{&DMDMRP-P-TAG1}
/* DEFINE NEW SHARED WORKFILE ap_wkfl FOR CURRENCY SUMMARY */
{gpacctp.i "new"}
{xxdmdmrp0001.i}
define new shared variable rndmthd  like rnd_rnd_mthd.
/* DEFINE old_curr FOR CALL TO gpacctp.p */
define new shared variable old_curr like ar_curr.

define variable oldcurr           like ar_curr                     no-undo.
define variable c_session         as   character                   no-undo.
define variable oldsession        as   character                   no-undo.
define variable bill              like ar_bill                     no-undo.
define variable bill1             like ar_bill                     no-undo.
define variable nbr               like ar_nbr                      no-undo.
define variable nbr1              like ar_nbr                      no-undo.
define variable entity            like ar_entity   format "x(4)"   no-undo.
define variable entity1           like ar_entity   format "x(4)"   no-undo.
define variable ardate            like ar_date                     no-undo.
define variable ardate1           like ar_date                     no-undo.
define variable batch             like ar_batch  initial ""        no-undo.
define variable batch1            like ar_batch  initial ""        no-undo.
define variable duedate           like ar_due_date                 no-undo.
define variable duedate1          like ar_due_date                 no-undo.
define variable effdate           like ar_effdate                  no-undo.
define variable effdate1          like ar_effdate                  no-undo.
define variable name              like ad_name                     no-undo.
define variable type              like ar_type     format "x(4)"
                                  label "Type"                     no-undo.
define variable currency_in       like ar_curr                     no-undo.
define variable base_rpt          like ar_curr                     no-undo.
define variable base_damt         like ard_amt                     no-undo.
define variable base_amt          like ar_amt
   format "->,>>>,>>>,>>9.99"                                      no-undo.
define variable base_applied      like ar_applied
   format "->,>>>,>>>,>>9.99"                                      no-undo.
define variable base_open         like ar_amt
   format "->,>>>,>>>,>>9.99"     label "Open Amount"              no-undo.
define variable base_disc         like ard_disc
   format "->,>>>,>>>,>>9.99"                                      no-undo.
define variable disp_curr         as character      format "x(1)"
   label "C"                                                       no-undo.
{&DMDMRP-P-TAG15}
define variable stat              as character      format "x(8)"
                                  label "Status"                   no-undo.
{&DMDMRP-P-TAG16}
define variable stat1             like stat                        no-undo.
define variable artotal           like ar_amt                      no-undo.
define variable tot               as character      format "x(30)" no-undo.
define variable tmp_amt           like ar_amt
   format "->,>>>,>>>,>>9.99"                                      no-undo.
define variable base_amt_fmt      as character                     no-undo.
define variable curr_amt_fmt      as character                     no-undo.
define variable curr_amt_old      as character                     no-undo.
define variable mc-error-number   like msg_nbr                     no-undo.
define variable ex_rate_relation1 as character      format "x(40)" no-undo.
define variable ex_rate_relation2 as character      format "x(40)" no-undo.
define variable disp_char1        as character      format "x(69)" no-undo.
define variable l_approved        as character      format "x(10)" no-undo.
define variable l_closed          as character      format "x(10)" no-undo.
define variable l_void            as character      format "x(10)" no-undo.
define variable l_proposed        as character      format "x(10)" no-undo.
define variable l_discount        as character      format "x(10)" no-undo.
define variable tmpamt            like ard_amt                     no-undo.
define variable det_curr          like ar_curr                     no-undo.

define variable cc                like ar_cc.
define variable cc1               like ar_cc.

define buffer armstr for ar_mstr.
define buffer armstr0 for ar_mstr.

/* MUST INCLUDE gprunpdf.i IN THE MAIN BLOCK OF THE PROGRAM SO THAT */
/* CALLS TO gprunp.i FROM ANY OF THE INTERNAL PROCEDURES SKIPS  */
/* DEFINITION OF SHARED VARS OF gprunpdf.i */
/* FOR FURTHER INFO REFER TO HEADER COMMENTS IN gprunp.i */
{gprunpdf.i "mcpl" "p"}
{gprunpdf.i "mcui" "p"}

{&DMDMRP-P-TAG17}
form
   nbr                           colon 18
   nbr1           label {t001.i} colon 49 skip
   bill                          colon 18
   bill1          label {t001.i} colon 49 skip
   entity                        colon 18
   entity1        label {t001.i} colon 49 skip
   batch                         colon 18
   batch1         label {t001.i} colon 49 skip
   cc                            colon 18
   cc1            label {t001.i} colon 49 skip
   ardate                        colon 18
   ardate1        label {t001.i} colon 49 skip
   duedate                       colon 18
   duedate1       label {t001.i} colon 49 skip
   effdate                       colon 18
   effdate1       label {t001.i} colon 49 skip
   stat                          colon 18 skip
   disp_char1     no-label       at    10
   base_rpt                      colon 18
with frame a side-labels width 80.

/* SET EXTERNAL LABELS
setFrameLabels(frame a:handle).
{&DMDMRP-P-TAG18}
*/
/*  FORM FOR TOTALS.        */
form
   tot             to     108
   ar_amt          colon  110
with frame e no-labels  width 132 no-attr-space.

form
   space(10)
   ard_nbr
   base_open
   base_damt
   base_disc
with frame base_det width 132 down.

/* SET EXTERNAL LABELS */
setFrameLabels(frame base_det:handle).

{&DMDMRP-P-TAG19}
form
   ar_bill
   name     column-label "Name!Exch Rate"   format "x(40)"
   ar_nbr   column-label "Reference!Status" format "x(8)"
   ar_acct
   ar_sub
   ar_cc
   ar_date  column-label "Date!Due Date"
   ar_effdate
   ar_curr  column-label "Currency"
   disp_curr
   base_amt column-label "Amount!Total of Invoices"
with frame f width 132 down.

/* SET EXTERNAL LABELS */
setFrameLabels(frame f:handle).

assign
   l_approved = getTermLabel("APPROVED",10)
   l_closed   = getTermLabel("CLOSED",8)
   l_void     = getTermLabel("VOID",6)
   l_proposed = getTermLabel("PROPOSED",10)
   l_discount = getTermLabel("DISCOUNT",10)
   disp_char1 = l_proposed + ", "  +
                l_approved + ", "  +
                l_discount + ", "  +
                l_closed   + ", "  +
                l_void     + ", (" +
                getTermLabel("BLANK_FOR_ALL",13) + ")".
{&DMDMRP-P-TAG20}

find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock no-error.

assign
   curr_amt_old = ar_amt:format
   base_amt_fmt = base_amt:format in frame f.

{gprun.i ""gpcurfmt.p"" "(input-output base_amt_fmt,
                          input        gl_rnd_mthd)"}
oldsession = SESSION:numeric-format.

{wbrp01.i}
assign nbr      = inbr
       nbr1     = inbr1
       bill     = ibill
       bill1    = ibill1
       entity   = ientity
       entity1  = ientity1
       batch    = ibatch
       batch1   = ibatch1
       cc       = icc
       cc1      = icc1
       ardate   = iardate
       ardate1  = iardate1
       duedate  = iduedate
       duedate1 = iduedate1
       effdate  = ieffdate
       effdate1 = ieffdate1
       stat     = istat
       base_rpt = ibase_rpt.
/*dis
repeat:
 display disp_char1 with frame a.  */
   {&DMDMRP-P-TAG14}
   assign
      oldcurr  = ""
      old_curr = "".
   if can-find(first ap_wkfl)
   then
      for each ap_wkfl exclusive-lock:
         delete ap_wkfl.
      end. /* FOR EACH ap_wkfl */

/*   if nbr1     = hi_char  then nbr1     = "".                           */
/*   if bill1    = hi_char  then bill1    = "".                           */
/*   if entity1  = hi_char  then entity1  = "".                           */
/*   if batch1   = hi_char  then batch1   = "".                           */
/*   if cc1      = hi_char  then cc1      = "".                           */
/*   if ardate   = low_date then ardate   = ?.                            */
/*   if ardate1  = hi_date  then ardate1  = ?.                            */
/*   if duedate  = low_date then duedate  = ?.                            */
/*   if duedate1 = hi_date  then duedate1 = ?.                            */
/*   if effdate  = low_date then effdate  = ?.                            */
/*   if effdate1 = hi_date  then effdate1 = ?.                            */

/*   if c-application-mode <> 'web'                                       */
/*   then                                                                 */
/*      update                                                            */
/*         nbr nbr1 bill bill1 entity entity1 batch batch1 cc cc1         */
/*         ardate ardate1 duedate duedate1 effdate effdate1               */
/*         stat base_rpt                                                  */
/*      with frame a.                                                     */
/*                                                                        */
/*   {wbrp06.i &command = update                                          */
/*      &fields = "  nbr nbr1 bill bill1 entity                           */
/*                 entity1 batch batch1 cc cc1 ardate ardate1             */
/*                 duedate duedate1 effdate effdate1 stat base_rpt"       */
/*      &frm    = "a"}                                                    */
/*                                                                        */
   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      if stat <> ""
      then
         {&DMDMRP-P-TAG2}

      if (stat <> l_approved and
          stat <> l_closed   and
          stat <> l_void     and
          stat <> l_proposed and
          stat <> l_discount)
      then do:
         {&DMDMRP-P-TAG3}
         {pxmsg.i &MSGNUM=19 &ERRORLEVEL=3}  /* INVALID STATUS */
         if c-application-mode = 'web'
         then
            return.
         else
            next-prompt stat with frame a.
         undo, retry.
      end. /* IF stat */

      if base_rpt <> ""
      then do:
         {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
            "(input base_rpt, output mc-error-number)"}
         if mc-error-number <> 0
         then do:
            {pxmsg.i &MSGNUM=3088 &ERRORLEVEL=3}  /* INVALID CURRENCY */
            if c-application-mode = 'web'
            then
               return.
            else
               next-prompt base_rpt with frame a.
            undo, retry.
         end. /* IF mc-error-number */
      end. /* IF base_rpt */
      {&DMDMRP-P-TAG28}
      bcdparm = "".
      {mfquoter.i nbr      }
      {mfquoter.i nbr1     }
      {mfquoter.i bill     }
      {mfquoter.i bill1    }
      {mfquoter.i entity   }
      {mfquoter.i entity1  }
      {mfquoter.i batch    }
      {mfquoter.i batch1   }
      {mfquoter.i cc       }
      {mfquoter.i cc1      }
      {mfquoter.i ardate   }
      {mfquoter.i ardate1  }
      {mfquoter.i duedate  }
      {mfquoter.i duedate1 }
      {mfquoter.i effdate  }
      {mfquoter.i effdate1 }
      {mfquoter.i stat     }
      {mfquoter.i base_rpt }

      if nbr1     = "" then nbr1     = hi_char.
      if bill1    = "" then bill1    = hi_char.
      if entity1  = "" then entity1  = hi_char.
      if batch1   = "" then batch1   = hi_char.
      if cc1      = "" then cc1      = hi_char.
      if ardate   = ?  then ardate   = low_date.
      if ardate1  = ?  then ardate1  = hi_date.
      if duedate  = ?  then duedate  = low_date.
      if duedate1 = ?  then duedate1 = hi_date.
      if effdate  = ?  then effdate  = low_date.
      if effdate1 = ?  then effdate1 = hi_date.
      {&DMDMRP-P-TAG29}
   end.  /* IF (c-application-mode <> 'web') */

   /* OUTPUT DESTINATION SELECTION */
/*   {gpselout.i &printType = "printer"                         */
/*               &printWidth = 132                              */
/*               &pagedFlag = " "                               */
/*               &stream = " "                                  */
/*               &appendToFile = " "                            */
/*               &streamedOutputToTerminal = " "                */
/*               &withBatchOption = "yes"                       */
/*               &displayStatementType = 1                      */
/*               &withCancelMessage = "yes"                     */
/*               &pageBottomMargin = 6                          */
/*               &withEmail = "yes"                             */
/*               &withWinprint = "yes"                          */
/*               &defineVariables = "yes"}                      */
/*dis  {mfphead.i}                             */
/*dis                                          */
/*dis   form header                            */
/*dis      skip(1)                             */
/*dis   with frame a1 width 80 page-top.       */
/*dis   view frame a1.                         */

   {&DMDMRP-P-TAG4}
   assign v_ar_entity = ""
          v_ar_bank = ""
          v_ar_batch = ""
          v_ar_bill = ""
          v_name = ""
          v_ar_nbr = ""
          v_ar_acct = ""
          v_ar_sub = ""
          v_ar_cc = ""
          v_ar_date = ?
          v_ar_effdate = ?
          v_ar_curr = ""
          v_disp_curr = ""
          v_base_amt = 0
          v_ex_rate_relation1 = ""
          v_statl = ""
          v_ar_due_date = ?.

   empty temp-table ttssdmdmrp0001_det no-error.

   for each ar_mstr
       where ar_mstr.ar_domain = global_domain and (  (ar_nbr         >= nbr)
      and   (ar_nbr         <= nbr1)
      and   (ar_bill        >= bill)
      and   (ar_bill        <= bill1)
      and   (ar_entity      >= entity)
      and   (ar_entity      <= entity1)
      and   (ar_batch       >= batch)
      and   (ar_batch       <= batch1)
      and   (ar_date        >= ardate)
      and   (ar_date        <= ardate1)
      and   (ar_due_date    >= duedate)
      and   (ar_due_date    <= duedate1)
      and   (((ar_effdate   >= effdate)
         and  (ar_effdate   <= effdate1))
         or   (ar_effdate   =  ?
         and  (effdate      =  low_date
         or    effdate1     =  hi_date)))
      and   (ar_type = "D")
      and   ((stat = "")        /* ALL */
         or  (stat =  l_proposed
            and  ar_open
            and  ar_draft = no)
         or (stat = l_closed
            and ar_open = no
            and ar_draft)
         or (stat = l_void
            and ar_open  = no
            and ar_draft = no)
         or (stat = l_approved
            and ar_open
            and ar_draft)
         or (stat = l_discount
            and ar_open
            and ar_draft))
         and ( ar_curr  = base_rpt
            or base_rpt ="")
   ) no-lock break by ar_entity by ar_bank
      by ar_batch by ar_bill by ar_nbr
      by ar_date by ar_due_date:
/*dis   with frame c width 132 no-box:        */
/*dis      /* SET EXTERNAL LABELS */          */
/*dis      setFrameLabels(frame c:handle).    */
      {&DMDMRP-P-TAG5}

      if stat = l_discount
      then do:
         for first ard_det
            fields( ard_domain ard_amt ard_disc ard_nbr ard_ref ard_type)
             where ard_det.ard_domain = global_domain and  ard_nbr <> ""
            and   ard_ref =  ar_nbr
            and ard_type begins "C"
         no-lock:
         end. /* FOR FIRST ard_det */
         if not available ard_det
         then
            next.
      end. /* IF stat = l_discount */

      if    (oldcurr <> ar_curr)
         or (oldcurr  = "")
      then do:
         if ar_curr = gl_base_curr
         then
            rndmthd = gl_rnd_mthd.
         else do:
            /* GET ROUNDING METHOD FROM CURRENCY MASTER */
            {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
               "(input  ar_curr,
                 output rndmthd,
                 output mc-error-number)"}
            if mc-error-number <> 0
            then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4}
               if c-application-mode <> "WEB"
               then
               .
/*dis                  pause. */
               next.
            end. /* IF mc-error-number */
         end. /* IF ar_curr = gl_base_curr */
         /* DETERMINE CURRENCY DISPLAY AMERICAN OR EUROPEAN */
         for first rnd_mstr
            fields( rnd_domain rnd_dec_pt rnd_rnd_mthd)
             where rnd_mstr.rnd_domain = global_domain and  rnd_rnd_mthd =
             rndmthd
         no-lock:
         end. /* FOR FIRST rmd_mstr */
         if not available rnd_mstr
         then do:
            /* ROUND METHOD RECORD NOT FOUND */
/*dis        {pxmsg.i &MSGNUM=863 &ERRORLEVEL=4}  */
            if c-application-mode = 'web'
            then
               return.
            next.
         end. /* IF NOT AVAILABLE rnd_mstr */
         if (base_rpt <> base_curr)
         then do:
            /* IF rnd_dec_pt = COMMA FOR DECIMAL POINT */
            /* THIS IS A EUROPEAN STYLE CURRENCY */
            if (rnd_dec_pt = "," )
            then
               assign
                  c_session = "European"
                  SESSION:numeric-format = "European".
            else
               assign
                  c_session = "American"
                  SESSION:numeric-format = "American".
         end. /* IF (base_rpt <> base_curr) */

         assign
            oldcurr      = ar_curr
            curr_amt_fmt = curr_amt_old.
         {gprun.i ""gpcurfmt.p""
            "(input-output curr_amt_fmt,
              input        rndmthd)"}
      end.  /* IF ar_curr <> old_curr */

      /* CONVERT CURRENCY TO BASE IF APPROPRIATE.                    */
      if    base_curr = ar_curr
         or base_rpt  = ar_curr
      then
         assign
            base_amt  = ar_amt
            disp_curr = " ".
      else
         assign
            base_amt  = ar_base_amt
            disp_curr = getTermLabel("YES",1).

      if base_rpt = ""
      then
         disp_curr = "".

      accumulate base_amt (total by ar_entity).
      accumulate base_amt (total by ar_bank).
      {&DMDMRP-P-TAG6}
      accumulate base_amt (total by ar_batch).
      accumulate base_amt (total by ar_bill).

      if first-of(ar_entity)
      then do with frame b:
         /* SET EXTERNAL LABELS */
/*dis         setFrameLabels(frame b:handle).              */
/*dis         display ar_entity with frame b side-labels.  */
         assign v_ar_entity = ar_entity.
      end. /* IF FIRST-OF(ar_entity) */

      if first-of(ar_bank)
      then do with frame b1:
         /* SET EXTERNAL LABELS */
/*dis         setFrameLabels(frame b1:handle).            */
/*dis         display ar_bank with frame b1 side-labels.  */
         assign v_ar_bank = ar_bank.
      end. /* IF FIRST-OF(ar_bank) */

      if first-of(ar_batch)
      then do with frame b2:
         /* SET EXTERNAL LABELS */
/*dis         setFrameLabels(frame b2:handle).            */
/*dis         display ar_batch with frame b2 side-labels. */
         assign v_ar_batch = ar_batch.
      end. /* IF FIRST-OF(ar_batch) */

      do with frame f width 132 down no-box:

         if first-of(ar_bill)
         then do:
            for first cm_mstr
               fields( cm_domain cm_addr cm_sort)
                where cm_mstr.cm_domain = global_domain and  cm_addr = ar_bill
            no-lock:
            end. /* FOR FIRST cm_mstr */
            if available cm_mstr
            then
               name = cm_sort.
            else
               name = "".
/*dis         display ar_bill name.  */
              assign v_ar_bill = ar_bill
                     v_name    = name.
         end. /* IF FIRST-OF(ar_bill) */
/*dis         else                                */
/*dis            display "" @ ar_bill "" @ name.  */

         if stat = ""
         then do:
            {&DMDMRP-P-TAG7}

            if ar_open
               and ar_draft = no
            then
               stat1 = l_proposed.
            else if ar_open = no
               and  ar_draft
            then
               stat1 = l_closed.
            else if ar_open = no
               and  ar_open = no
            then
               stat1 = l_void.
            else if ar_open = true
               and ar_draft
            then do:
               for first ard_det
                  fields( ard_domain ard_amt ard_disc ard_nbr ard_ref ard_type)
                   where ard_det.ard_domain = global_domain and  ard_ref =
                   ar_nbr
                  and   ard_type begins "C"
                  and   ard_nbr <> ""
               no-lock:
               end. /* FOR FIRST ard_det */

               if available ard_det
               then
                  stat1 = l_discount.
               else
                  stat1 = l_approved.
            end. /* ELSE IF ar_open = TRUE */
         end. /* IF stat = "" */
         else
            stat1 = stat.

         /*  IF base_rpt IS BLANK, AMOUNTS WILL BE DISPLAYED IN THE  */
         if base_rpt = ""
         then
            /* DESTROYS base_amt NEEDED FOR CURRENCY SUMMARY */
            base_amt:format in frame f = curr_amt_fmt.
         else if base_rpt = base_curr
         then
            base_amt:format in frame f = base_amt_fmt.
         else if base_rpt = ar_curr
         then
            base_amt:format in frame f = curr_amt_fmt.
         {&DMDMRP-P-TAG8}

/*dis         display                      */
/*dis            ar_nbr                    */
/*dis            ar_acct                   */
/*dis            ar_sub                    */
/*dis            ar_cc                     */
/*dis            ar_date                   */
/*dis            ar_effdate                */
/*dis            ar_curr                   */
/*dis            disp_curr                 */
/*dis            (if base_rpt = ""         */
/*dis             then                     */
/*dis                ar_amt                */
/*dis             else                     */
/*dis                base_amt) @ base_amt  */
/*dis         with frame f.                */
         assign  v_ar_nbr     = ar_nbr
                 v_ar_acct    = ar_acct
                 v_ar_sub     = ar_sub
                 v_ar_cc      = ar_cc
                 v_ar_date    = ar_date
                 v_ar_effdate = ar_effdate
                 v_ar_curr    = ar_curr
                 v_disp_curr  = disp_curr
                 v_base_amt = (if base_rpt = "" then ar_amt  else base_amt).
         /* USE mc-ex-rate-output ROUTINE TO GET THE RATES */
         {gprunp.i "mcui" "p" "mc-ex-rate-output"
            "(input  ar_curr,
              input  base_curr,
              input  ar_ex_rate,
              input  ar_ex_rate2,
              input  ar_exru_seq,
              output ex_rate_relation1,
              output ex_rate_relation2)"}
/*dis         down 1 with frame f.                */
/*dis         display                             */
/*dis            ex_rate_relation1 @ name         */
/*dis            stat1             @ ar_nbr       */
/*dis            ar_due_date       @ ar_date      */
/*dis         with frame f.                       */
         assign v_ex_rate_relation1 = ex_rate_relation1
                v_statl = stat1
                v_ar_due_date = ar_due_date.
         {&DMDMRP-P-TAG21}
         artotal = 0.
         for each ard_det
             where ard_det.ard_domain = global_domain and (  ard_ref  = ar_nbr
             and
         {&DMDMRP-P-TAG30}
                 (ard_type = "I"
               or ard_type = "M")
         {&DMDMRP-P-TAG31}
         ) no-lock use-index ard_ref:
            do for armstr:
               {&DMDMRP-P-TAG24}
               for first armstr
                  fields( ar_domain ar_acct     ar_amt     ar_bank
                          ar_base_amt ar_acct
                          ar_batch    ar_bill    ar_cc       ar_curr
                          ar_date     ar_draft   ar_entity   ar_due_date
                          ar_effdate  ar_ex_rate ar_ex_rate2 ar_exru_seq
                          ar_nbr      ar_open    ar_sub      ar_type)
                   where armstr.ar_domain = global_domain and  armstr.ar_nbr =
                   ard_nbr
               no-lock:
               end. /* FOR FIRST armstr */
               tmpamt = ard_amt.
               if armstr.ar_curr <> ar_mstr.ar_curr
               then do:
                  {&DMDMRP-P-TAG25}
                  /* CONVERT FOREIGN CURR AMT OF INV TO BASE CURRENCY */
                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input  armstr.ar_curr,
                       input  base_curr,
                       input  armstr.ar_ex_rate,
                       input  armstr.ar_ex_rate2,
                       input  ard_amt,
                       input  false, /* DO NOT ROUND */
                       output tmpamt,
                       output mc-error-number)"}.
                  if mc-error-number <> 0
                  then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
                  end. /* IF mc-error-number <> 0 */

                  /* CONVERT BASE CURRENCY AMT TO CURR OF THE DRAFT */
                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input base_curr,
                       input ar_mstr.ar_curr,
                       input ar_mstr.ar_ex_rate2,
                       input ar_mstr.ar_ex_rate,
                       input tmpamt,
                       input false, /* DO NOT ROUND */
                       output tmpamt,
                       output mc-error-number)"}.
                  if mc-error-number <> 0
                  then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
                  end. /* IF mc-error-number */
               end. /* armstr.ar_curr <> ar_mstr.ar_curr */

               artotal = artotal + tmpamt.

            end. /* DO FOR armstr */
         end. /* FOR EACH ard_det */

         /* CONVERT CURRENCY TO BASE IF APPROPRIATE.                */
         if base_curr <> ar_curr and base_rpt <> ar_curr
         then do:
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input  ar_curr,
                 input  base_curr,
                 input  ar_ex_rate,
                 input  ar_ex_rate2,
                 input  artotal,
                 input  true, /* ROUND */
                 output artotal,
                 output mc-error-number)"}.
            if mc-error-number <> 0
            then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4}.
            end. /* IF mc-error-number */
         end. /* IF base_curr <> ar_curr */

         if     base_curr <> ar_curr
            and base_rpt  <> ar_curr
         then
         .
/*dis           display base_curr @ ar_curr with frame f.        */
/*dis                                                            */
/*dis        display artotal @ base_amt with frame f.            */
/*dis        down 1 with frame f.                                */

         /* DISPLAY SECOND PART OF TRIANGULATED RATES RETRIEVED BY */
         /* mc-ex-rate-output ROUTINE BEFORE */
/*         if ex_rate_relation2 <> ""                   */
/*         then do:                                     */
/*            display                                   */
/*               ex_rate_relation2 @ name               */
/*            with frame f.                             */
/*            down 1 with frame f.                      */
/*         end. /* IF ex_rate_relation2 <> "" */        */

      end. /* DO WITH FRAME f */

      /*  STORE TOTALS, BY CURRENCY, IN WORK FILE.                */
      if base_rpt = ""
      then do:
         find first ap_wkfl
            where ar_curr = apwk_curr
         exclusive-lock no-error.
         /* IF A RECORD FOR THIS CURRENCY DOESN'T EXIST, CREATE ONE */
         if not available ap_wkfl
         then do:
            create ap_wkfl.
            apwk_curr = ar_curr.
         end. /* IF NOT AVAILABLE ap_wkfl */
         /* ACCUMULATE INDIVIDUAL CURRENCY TOTALS IN WORK FILE. */
         apwk_for = apwk_for + ar_amt.
         if base_curr <> ar_curr
         then
            apwk_base = apwk_base + base_amt.
         else
            apwk_base = apwk_for.
      end. /* IF base_rpt = "" */

      {&DMDMRP-P-TAG9}
      /* GET ATTACHED INVOICE DETAIL */
      for each ard_det
          where ard_det.ard_domain = global_domain and (  ard_ref = ar_nbr
         and  (ard_type = "I"
            or ard_type = "M")
      ) no-lock use-index ard_ref with frame d width 132:
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame d:handle).
         {&DMDMRP-P-TAG10}

         assign
            base_damt = ard_amt
            base_disc = ard_disc
            base_open = ard_amt + ard_disc.

         do for armstr:
            {&DMDMRP-P-TAG26}
            for first armstr
               fields( ar_domain ar_acct     ar_amt     ar_bank     ar_base_amt
                       ar_batch    ar_bill    ar_cc       ar_curr   ar_acct
                       ar_date     ar_draft   ar_entity   ar_due_date
                       ar_effdate  ar_ex_rate ar_ex_rate2 ar_exru_seq
                       ar_nbr      ar_open    ar_sub      ar_type)
                where armstr.ar_domain = global_domain and  armstr.ar_nbr =
                ard_nbr
            no-lock:
            end. /* FOR FIRST armstr */

            if armstr.ar_curr <> ar_mstr.ar_curr
            then do:
               {&DMDMRP-P-TAG27}
               /* CONVERT THE AMOUNT (ard_amt) */
               tmpamt = ard_amt.

               /* CONVERT FOREIGN CURR AMT OF INV TO BASE CURRENCY */
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input armstr.ar_curr,
                    input base_curr,
                    input armstr.ar_ex_rate,
                    input armstr.ar_ex_rate2,
                    input ard_amt,
                    input false, /* DO NOT ROUND */
                    output tmpamt,
                    output mc-error-number)"}.
               if mc-error-number <> 0
               then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
               end. /* IF mc-error-number */

               /* CONVERT BASE CURR AMT TO CURRENCY OF THE DRAFT */
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input  base_curr,
                    input  ar_mstr.ar_curr,
                    input  ar_mstr.ar_ex_rate2,
                    input  ar_mstr.ar_ex_rate,
                    input  tmpamt,
                    input  true,
                    output tmpamt,
                    output mc-error-number)"}.
               if mc-error-number <> 0
               then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
               end. /* IF mc-error-number */

               assign
                  base_damt = tmpamt
                  /* CONVERT THE DISCOUNT (ard_disc)*/
                  tmpamt = ard_disc.

               /* CONVERT FOREIGN CURR AMT OF INV TO BASE CURRENCY */
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input  armstr.ar_curr,
                    input  base_curr,
                    input  armstr.ar_ex_rate,
                    input  armstr.ar_ex_rate2,
                    input  ard_disc,
                    input  false, /* DO NOT ROUND */
                    output tmpamt,
                    output mc-error-number)"}.
               if mc-error-number <> 0
               then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
               end. /* IF mc-error-number */

               /* CONVERT BASE CURRENCY AMT TO CURRENCY OF THE DRAFT */
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input  base_curr,
                    input  ar_mstr.ar_curr,
                    input  ar_mstr.ar_ex_rate2,
                    input  ar_mstr.ar_ex_rate,
                    input  tmpamt,
                    input  true,
                    output tmpamt,
                    output mc-error-number)"}.
               if mc-error-number <> 0
               then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
               end. /* IF mc-error-number */

               assign
                  base_disc = tmpamt
                  base_open = base_damt + base_disc.

            end. /* armstr.ar_curr <> ar_mstr.ar_curr */
         end. /* DO FOR armstr */

         /* SET FORMATS BASED ON CURR FMT */
         assign
            base_damt:format in frame base_det = curr_amt_fmt
            base_disc:format in frame base_det = curr_amt_fmt
            base_open:format in frame base_det = curr_amt_fmt.
         if      base_rpt = base_curr
            and ar_curr   <> base_curr
         then do:

            /* CONVERT FROM FOREIGN TO BASE CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input  ar_curr,
                 input  base_curr,
                 input  ar_ex_rate,
                 input  ar_ex_rate2,
                 input  base_damt,
                 input  true, /* ROUND */
                 output base_damt,
                 output mc-error-number)"}.
            if mc-error-number <> 0
            then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4}.
            end. /* IF mc-error-number */

            /* CONVERT FROM FOREIGN TO BASE CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input  ar_curr,
                 input  base_curr,
                 input  ar_ex_rate,
                 input  ar_ex_rate2,
                 input  base_disc,
                 input  true, /* ROUND */
                 output base_disc,
                 output mc-error-number)"}.
            if mc-error-number <> 0
            then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4}.
            end. /* IF mc-error-number */

            /* CONVERT FROM FOREIGN TO BASE CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input  ar_curr,
                 input  base_curr,
                 input  ar_ex_rate,
                 input  ar_ex_rate2,
                 input  base_open,
                 input  true, /* ROUND */
                 output base_open,
                 output mc-error-number)"}.
            if mc-error-number <> 0
            then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4}.
            end. /* IF mc-error-number */

            /* SET FORMATS BASED ON BASE FMT */
            assign
               base_damt:format in frame base_det = base_amt_fmt.
               base_disc:format in frame base_det = base_amt_fmt.
               base_open:format in frame base_det = base_amt_fmt.
         end. /* IF base_rpt = base_curr */

         {&DMDMRP-P-TAG11}
/*dis         display                               */
/*dis            ard_nbr                            */
/*dis            base_open                          */
/*dis            base_damt                          */
/*dis            base_disc                          */
/*dis            det_curr                           */
/*dis         with frame base_det.                  */
         assign v_ard_acct = ""
                v_ard_sub  = ""
                v_ard_cc   = "".
         for first armstr0
              fields( ar_domain ar_acct     ar_amt     ar_bank
                      ar_base_amt ar_acct
                      ar_batch    ar_bill    ar_cc       ar_curr
                      ar_date     ar_draft   ar_entity   ar_due_date
                      ar_effdate  ar_ex_rate ar_ex_rate2 ar_exru_seq
                      ar_nbr      ar_open    ar_sub      ar_type)
               where armstr0.ar_domain = global_domain and  armstr0.ar_nbr =
               ard_nbr
         no-lock:
         end. /* FOR FIRST armstr */
         if available armstr0 then do:
            assign v_ard_acct = armstr0.ar_acct
                   v_ard_sub  = armstr0.ar_sub
                   v_ard_cc   = armstr0.ar_cc.
         end.
         create ttssdmdmrp0001_det.
         assign ttssdmdmrp0001_ar_entity         = v_ar_entity
                ttssdmdmrp0001_ar_bank           = v_ar_bank
                ttssdmdmrp0001_ar_batch          = v_ar_batch
                ttssdmdmrp0001_ar_bill           = v_ar_bill
                ttssdmdmrp0001_name              = v_name
                ttssdmdmrp0001_ar_nbr            = v_ar_nbr
                ttssdmdmrp0001_ar_acct           = v_ar_acct
                ttssdmdmrp0001_ar_sub            = v_ar_sub
                ttssdmdmrp0001_ar_cc             = v_ar_cc
                ttssdmdmrp0001_ar_date           = v_ar_date
                ttssdmdmrp0001_ar_effdate        = v_ar_effdate
                ttssdmdmrp0001_ar_curr           = v_ar_curr
                ttssdmdmrp0001_disp_curr         = v_disp_curr
                ttssdmdmrp0001_base_amt          = v_base_amt
                ttssdmdmrp0001_ex_rate_relation1 = v_ex_rate_relation1
                ttssdmdmrp0001_ex_rate_relation2 = ex_rate_relation2
                ttssdmdmrp0001_statl             = v_statl
                ttssdmdmrp0001_ar_due_date       = v_ar_due_date
                ttssdmdmrp0001_ard_nbr           = ard_nbr
                ttssdmdmrp0001_ard_acct          = v_ard_acct
                ttssdmdmrp0001_ard_sub           = v_ard_sub
                ttssdmdmrp0001_ard_cc            = v_ard_cc
                ttssdmdmrp0001_base_open         = base_open
                ttssdmdmrp0001_base_damt         = base_damt
                ttssdmdmrp0001_base_disc         = base_disc
                ttssdmdmrp0001_base_curr         = base_curr
                ttssdmdmrp0001_artotal           = artotal.
         if     base_rpt = base_curr
            and ar_curr <> base_curr
         then do:
/*dis              display base_curr @ det_curr with frame base_det.   */
            assign ttssdmdmrp0001_det_curr          = base_curr.
         end.
         else do:
/*dis            display ar_curr @ det_curr with frame base_det.     */
            assign ttssdmdmrp0001_det_curr = ar_curr.
          end.
         {&DMDMRP-P-TAG12}
/*dis         down 1 with frame base_det.                           */

      end. /* FOR EACH ard_det */
/*dis**************************************************************************
 *    if     base_curr <> ar_curr
 *       and base_rpt  <> ar_curr
 *    then
 *       ar_amt:format in frame e = base_amt_fmt.
 *    else
 *       ar_amt:format in frame e = curr_amt_fmt.
 *
 *    if last-of(ar_bill)
 *    then do:
 *       /*  DISPLAY CUSTOMER TOTAL.         */
 *       if page-size - line-counter < 3
 *       then
 *          page.
 *       /* SET BACK TO BASE */
 *       if (base_rpt = "")
 *       then
 *          SESSION:numeric-format = oldsession.
 *
 *       display
 *          getTermLabel("CUSTOMER",10) + " " + ar_bill + " "
 *          + getTermLabel("TOTAL",9) + ":" @ tot
 *          accum total by ar_bill (base_amt) @ ar_amt
 *       with frame e.
 *       display skip(1) with frame c.
 *    end. /* IF LAST-OF(ar_bill ) */
 *
 *    if last-of(ar_batch)
 *    then do:
 *       /* SET BACK TO BASE */
 *       if (base_rpt = "")
 *       then
 *          SESSION:numeric-format = oldsession.
 *       /*  DISPLAY BATCH TOTAL.            */
 *       display skip with frame c.
 *       if page-size - line-counter < 3
 *       then
 *          page.
 *
 *       display
 *          getTermLabel("BATCH",10) +  " " + ar_batch + " "
 *          + getTermLabel("TOTAL",9) + ":" @ tot
 *          accum total by ar_batch (base_amt) @ ar_amt
 *       with frame e.
 *    end. /* IF LAST-OF(ar_batch) */
 *    {&DMDMRP-P-TAG13}
 *    if last-of(ar_bank)
 *    then do:
 *       /* SET BACK TO BASE */
 *       if (base_rpt = "")
 *       then
 *          SESSION:numeric-format = oldsession.
 *       /*  DISPLAY BANK TOTAL.             */
 *       display skip with frame c.
 *       if page-size - line-counter < 3
 *       then
 *          page.
 *
 *       display
 *          getTermLabel("BANK",10) + " " + ar_bank + " "
 *          + getTermLabel("TOTAL",9) + ":" @ tot
 *          accum total by ar_bank (base_amt) @ ar_amt
 *       with frame e.
 *    end. /* IF LAST-OF(ar_bank) */
 *
 *    if last-of(ar_entity)
 *    then do:
 *       /* SET BACK TO BASE */
 *       if (base_rpt = "")
 *       then
 *          SESSION:numeric-format = oldsession.
 *       /*  DISPLAY ENTITY TOTAL.           */
 *       if base_rpt = ""
 *       then
 *          currency_in = base_curr.
 *       else
 *          currency_in = base_rpt.
 *
 *       display skip with frame c.
 *       if page-size - line-counter < 3
 *       then
 *          page.
 *
 *       display
 *          currency_in + " " + getTermLabel("ENTITY",8) + " " +
 *          ar_entity + " " + getTermLabel("TOTAL",7) + ":" @ tot
 *          accum total by ar_entity (base_amt) @ ar_amt
 *       with frame e.
 *    end. /* IF LAST-OF(ar_entity) */
 *    {mfrpchk.i}
 *
 *    /*  DISPLAY REPORT TOTAL. */
 *    if last(ar_nbr)
 *    then do:
 *       /* SET BACK TO BASE */
 *       if (base_rpt = "")
 *       then
 *          SESSION:numeric-format = oldsession.
 *       display skip with frame c.
 *       if page-size - line-counter < 2
 *       then
 *          page.
 *       if base_rpt = ""
 *       then
 *          currency_in = base_curr.
 *       else
 *          currency_in = base_rpt.
 *
 *       display
 *          currency_in + " " +
 *          getTermLabel("REPORT_TOTAL",24) + ":" @ tot
 *          accum total (base_amt) @ ar_amt
 *       with  frame e.
 *    end. /* IF LAST(ar_nbr) */
 *    if (base_rpt = "")
 *    then
 *       SESSION:numeric-format = c_session.
******************************************************************************/
   end.  /* FOR EACH ar_mstr */

   /* IF ALL CURRENCIES, PRINT A SUMMARY REPORT BROKEN BY CURRENCY. */
/*dis   if base_rpt = ""                                */
/*dis   then do:                                        */
/*dis      SESSION:numeric-format = oldsession.         */
/*dis      {gprun.i ""gpacctp.p""}.                     */
/*dis   end. /* IF base_rpt = "" */                     */

   /* REPORT TRAILER */
  /* {mfreset.i} */
 /*
SESSION:numeric-format = oldsession.
end.REPEAT
SESSION:numeric-format = oldsession.
*/
{wbrp04.i &frame-spec = a}
