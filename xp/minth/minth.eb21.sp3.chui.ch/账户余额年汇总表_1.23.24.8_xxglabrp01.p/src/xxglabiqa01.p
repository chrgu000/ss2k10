/* glabiqa.p - GENERAL LEDGER ACCOUNT BALANCES INQUIRY (PART II)        */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.28 $                                                         */
/*V8:ConvertMode=Report                                                 */
/* REVISION: 7.0     LAST EDIT: 12/02/91    by: jms  *F058*             */
/* REVISION: 7.4     LAST EDIT: 07/26/93    by: wep  *H046*             */
/*                              06/22/94    by: bcm  *H399*             */
/*                              01/18/95    by: str  *H09R*             */
/* REVISION: 8.6     LAST EDIT: 05/29/96    by: ejh  *K001*             */
/* REVISION: 8.6     LAST EDIT: 02/12/97    by: rxm  *H0S7*             */
/* REVISION: 8.6     LAST EDIT: 11/25/97    by: bvm  *K1BV*             */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane     */
/* REVISION: 8.6E    LAST MODIFIED: 04/24/98   BY: *L00M* D. Sidel      */
/* REVISION: 8.6E    LAST MODIFIED: 07/07/98   BY: *L03J* Edwin Janse   */
/* REVISION: 8.6E    LAST MODIFIED: 07/09/98   BY: *L01W* Brenda Milton */
/* REVISION: 8.6E    LAST MODIFIED: 08/10/98   BY: *L05L* Brenda Milton */
/* REVISION: 8.6E    LAST MODIFIED: 10/09/98   BY: *L0BK* Brenda Milton */
/* REVISION: 8.6E    LAST MODIFIED: 12/09/98   BY: *L0CT* Robin McCarthy*/
/* REVISION: 9.1     LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane*/
/* REVISION: 9.1     LAST MODIFIED: 08/14/00 BY: *N0L1* Mark Brown      */
/* REVISION: 9.1     LAST MODIFIED: 08/31/00 BY: *N0QF* Mudit Mehta     */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Revision: 1.25     BY: Seema Tyagi           DATE: 01/29/02  ECO: *N17P*  */
/* Revision: 1.26  BY: Jose Alex DATE: 10/29/02 ECO: *N1YF* */
/* $Revision: 1.28 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */


/* SS - 100602.1  By: Roger Xiao */  /*update from bill,eb2sp4, ECO: SS - 20050929 */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* SS - 20050929 - B */
{xxglabiq01.i}
/* SS - 20050929 - E */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE glabiqa_p_1 "Accumulated Balance"
/* MaxLen: Comment: */

&SCOPED-DEFINE glabiqa_p_2 "Period"
/* MaxLen: Comment: */

&SCOPED-DEFINE glabiqa_p_4 "Per Activity (DR)"
/* MaxLen: Comment: */

&SCOPED-DEFINE glabiqa_p_5 "Beginning Balance"
/* MaxLen: Comment: */

&SCOPED-DEFINE glabiqa_p_6 "Per Activity (CR)"
/* MaxLen: Comment: */

&SCOPED-DEFINE glabiqa_p_8 "Ending Balance"
/* MaxLen: Comment: */

&SCOPED-DEFINE glabiqa_p_9 "Curr"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{wbrp02.i}

define new shared variable beg_bal     as   decimal
format ">>>,>>>,>>>,>>9.99cr" label {&glabiqa_p_5}.
define new shared variable beg_bal1    like beg_bal.
define new shared variable beg_bal2    like beg_bal.
define new shared variable per_dr_act  as   decimal
format "->>>,>>>,>>9.99" label {&glabiqa_p_4}.
define new shared variable per_cr_act  like per_dr_act label {&glabiqa_p_6}.
define new shared variable knt         as   integer.
define new shared variable dt          as   date.
define new shared variable dt1         as   date.

define shared variable per           as   integer.
define shared variable per1          as   integer.
define shared variable yr            as   integer.
define shared variable begdt0        as   date.
define shared variable begdt1        as   date.
define shared variable enddt1        as   date.
define shared variable yr_end        as   date.
define shared variable yr_beg        as   date.
define shared variable peryr         as   character format "x(8)" label {&glabiqa_p_2}.

define variable end_bal              like beg_bal label {&glabiqa_p_8}.
define variable dr_act_to_dt         like per_dr_act.
define variable cr_act_to_dt         like per_dr_act.
define variable bb_accum             like beg_bal.
define variable pa_dr_accum          like per_dr_act.
define variable pa_cr_accum          like per_cr_act.
define variable accum_bal            like beg_bal label {&glabiqa_p_1}.
define variable percount             as   integer.

define shared variable ac_recno      as   recid.
define shared variable acctitle      as   character format "x(11)".
define shared variable curr_type     as   character format "x(19)".
define shared variable glname        like en_name.
define shared variable begdt         like gltr_eff_dt.
define shared variable enddt         like gltr_eff_dt.
define shared variable acc           like ac_code.
define shared variable sub           like sb_sub.
define shared variable sub1          like sb_sub.
define shared variable ctr           like cc_ctr.
define shared variable ctr1          like cc_ctr.
define shared variable curr          like gltr_curr.
define shared variable entity        like gltr_entity.
define shared variable entity1       like gltr_entity.
define shared variable ret           like co_ret.
define shared variable acct_tagged   as   logical no-undo.
define shared variable tmp_curr      like curr    no-undo.

define buffer cal for glc_cal.

{etvar.i  }
{etrpvar.i}
define variable et_accum_bal    like accum_bal.
define variable et_per_dr_act   like per_dr_act.
define variable et_per_cr_act   like per_cr_act.
define variable et_dr_act_to_dt like dr_act_to_dt.
define variable et_cr_act_to_dt like cr_act_to_dt.

/* SELECT FORM */
form
   peryr
   et_per_dr_act
   et_per_cr_act
   et_accum_bal
   curr      column-label {&glabiqa_p_9}
with frame b down width 80  attr-space title color normal acctitle.

/* SET EXTERNAL LABELS */
/* SS - 20050929 - B */
/*
setFrameLabels(frame b:handle).
*/
/* SS - 20050929 - E */

/*INITIALIZE ACTIVITY TO DATE */

assign
   dr_act_to_dt    = 0
   cr_act_to_dt    = 0
   et_dr_act_to_dt = 0
   et_cr_act_to_dt = 0
   /*INITIALIZE BEGIN BAL ACCUMULATOR*/
   bb_accum        = 0.

for first ac_mstr
   fields( ac_domain ac_curr ac_type)
   where recid(ac_mstr) = ac_recno
   no-lock:
end. /* FOR FIRST ac_mstr */

/*LOOP FOR EACH SUB-ACCT AND COST CTR IN THE RANGE FOR THE ACCT*/
for each asc_mstr
   fields( asc_domain asc_acc asc_cc asc_sub)
    where asc_mstr.asc_domain = global_domain and  asc_acc  = acc
   and   asc_sub >= sub
   and   asc_sub <= sub1
   and   asc_cc  >= ctr
   and   asc_cc  <= ctr1
   no-lock:

   /* CALCULATE AND DISPLAY BEGINNING BALANCE */
   if lookup(ac_type, "A,L") = 0
   then do:
      {gprun.i ""glabiqb.p""
         "(input  asc_acc,
           input  asc_sub,
           input  asc_cc,
           input  yr_beg,
           input  begdt0,
           output beg_bal1,
           output beg_bal2)"}
   end. /* IF LOOKUP(ac_type, A,L) = 0 */
   else do:
      {gprun.i ""glabiqb.p""
         "(input  asc_acc,
           input  asc_sub,
           input  asc_cc,
           input  low_date,
           input  begdt0,
           output beg_bal1,
           output beg_bal2)"}
   end. /* ELSE DO */

   bb_accum = bb_accum + beg_bal1 + beg_bal2.
end.  /* FOR EACH asc_mstr */

beg_bal = bb_accum.

/* DETERMINE HOW MANY PERIODS EXIST, KNOWLEDGE OF THIS  */
/* WILL ALLOW FOR THE INSERTION OF BLANK LINES IF SPACE */
/* IS AVAILABLE                                          */
perloop:
for each cal
   fields( glc_domain cal.glc_end cal.glc_per cal.glc_start cal.glc_year)
    where cal.glc_domain = global_domain and  cal.glc_year = yr
   no-lock
   break by cal.glc_per:
   percount = percount + 1.
end. /* FOR EACH cal */

/* CALCULATE PERIOD TOTALS */
/* SS - 20050929 - B */
DO:
/*
for each cal
   fields( glc_domain cal.glc_end cal.glc_per cal.glc_start cal.glc_year)
    where cal.glc_domain = global_domain and  cal.glc_year = yr
   no-lock
   with frame b down
   break by cal.glc_per:
    */
    /* SS - 20050929 - E */

   /* LOOK UP TRANSACTIONS */
    /* SS - 20050929 - B */
    /*
   begdt1 = yr_beg.

   if begdt1 < cal.glc_start
   then
      begdt1 = cal.glc_start.

   enddt1 = yr_end.

   if enddt1 > cal.glc_end
   then
      enddt1 = cal.glc_end.
   */
    begdt1 = yr_beg.

    enddt1 = yr_end.
   /* SS - 20050929 - E */

   assign
      knt         = 0
      per_dr_act  = 0
      per_cr_act  = 0
      pa_dr_accum = 0
      pa_cr_accum = 0.

   /*LOOP FOR EACH SUBACCT AND COST CTR IN THE RANGE FOR THE ACCT*/
   for each asc_mstr
      fields( asc_domain asc_acc asc_cc asc_sub)
       where asc_mstr.asc_domain = global_domain and  asc_acc  = acc
      and   asc_sub >= sub
      and   asc_sub <= sub1
      and   asc_cc  >= ctr
      and   asc_cc  <= ctr1
      no-lock:

      {gprun.i ""glabiqb.p""
         "(input  asc_acc,
           input  asc_sub,
           input  asc_cc,
           input  begdt1,
           input  enddt1,
           output per_cr_act,
           output per_dr_act)"}

      assign
         pa_dr_accum = pa_dr_accum + per_dr_act
         pa_cr_accum = pa_cr_accum + per_cr_act.

   end. /* FOR EACH asc_mstr */

   assign
      per_dr_act = pa_dr_accum
      per_cr_act = pa_cr_accum.

   if ac_curr            <> et_report_curr
      and tmp_curr       <> base_curr
      and et_report_curr <> base_curr
   then do:
      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input  ac_curr,
           input  et_report_curr,
           input  et_rate1,
           input  et_rate2,
           input  per_dr_act,
           input  true,  /* ROUND */
           output et_per_dr_act,
           output mc-error-number)"}

      if mc-error-number <> 0
      then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end. /* IF mc-error-number <> 0 */

      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input  ac_curr,
           input  et_report_curr,
           input  et_rate1,
           input  et_rate2,
           input  per_cr_act,
           input  true,  /* ROUND */
           output et_per_cr_act,
           output mc-error-number)"}

      if mc-error-number <> 0
      then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end. /* IF mc-error-number <> 0 */
   end.  /* IF ac_curr <> et_report_curr ... */

   else
   /* ACCT NOT CONVERTED DURING BASE CURRENCY CONVERSION */
   if acct_tagged
      and ac_curr  =  et_report_curr
      and tmp_curr <> base_curr
   then do:
      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input  base_curr,
           input  ac_curr,
           input  et_rate1,
           input  et_rate2,
           input  per_dr_act,
           input  true,  /* ROUND */
           output et_per_dr_act,
           output mc-error-number)"}

      if mc-error-number <> 0
      then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end. /* IF mc-error-number <> 0 */

      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input  base_curr,
           input  ac_curr,
           input  et_rate1,
           input  et_rate2,
           input  per_cr_act,
           input  true,  /* ROUND */
           output et_per_cr_act,
           output mc-error-number)"}

      if mc-error-number <> 0
      then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end. /* IF mc-error-number <> 0 */
   end. /* IF acct_tagged */

   else
      assign
         et_per_dr_act = per_dr_act
         et_per_cr_act = per_cr_act.

   /* DISPLAY BEGINNING BALANCE FOLLOWED BY PERIOD TOTAL */
      /* SS - 20050929 - B */
      DO:
      /*
   if first(glc_per)
   then do:
       */
       /* SS - 20050929 - E */
      accum_bal = beg_bal.

      /* MODIFIED TO CORECT THE DISPLAY OF ACCUMULATED BALANCES */
      /* IN SECOND SCREEN FOR A FOREIGN CURRENCY ACCOUNT WHEN   */
      /* REPORTING CURRENCY IS BASE CURRENCY OR BLANK.          */
      if ac_curr        <> et_report_curr and
         tmp_curr       <> base_curr      and
         et_report_curr <> base_curr
      then do:
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input  ac_curr,
              input  et_report_curr,
              input  et_rate1,
              input  et_rate2,
              input  beg_bal,
              input  true,  /* ROUND */
              output et_accum_bal,
              output mc-error-number)"}

         if mc-error-number <> 0
         then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end. /* IF mc-error-number <> 0 */

      end.  /* IF ac_curr <> et_report_curr ... */

      else
         et_accum_bal = beg_bal.

         /* SS - 20050929 - B */
         /*
      display
         getTermLabel("BEGIN_BALANCE",9) + ":" format "x(10)" @ peryr
         "" @ et_per_dr_act
         "" @ et_per_cr_act
         et_accum_bal
         tmp_curr @ curr
      with frame b.

      if percount > 12
      then
         down.
      else
         down 2.
         */
         CREATE tta6glabiq.
         ASSIGN
             tta6glabiq_acc = acc
             tta6glabiq_curr = tmp_curr
             tta6glabiq_beg = et_accum_bal
             .
         /* SS - 20050929 - E */

   end.  /* IF FIRST(glc_per) */

   assign
      dr_act_to_dt    = dr_act_to_dt         + per_dr_act
      cr_act_to_dt    = cr_act_to_dt         + per_cr_act
      et_dr_act_to_dt = et_dr_act_to_dt      + et_per_dr_act
      et_cr_act_to_dt = et_cr_act_to_dt      + et_per_cr_act
      accum_bal       = accum_bal            + per_dr_act    + per_cr_act
      et_accum_bal    = et_accum_bal         + et_per_dr_act + et_per_cr_act
       /* SS - 20050929 - B */
       /*
      peryr           = string(glc_per,"99") + "/"           + string(glc_year)
       */
       /* SS - 20050929 - E */
      per_cr_act      = -1 * per_cr_act
      et_per_cr_act   = -1 * et_per_cr_act.

   /* SS - 20050929 - B */
   /*
   display
      peryr
      et_per_dr_act
      et_per_cr_act
      et_accum_bal
   with frame b.

   /*IF FUTURE PERIOD, SHOW ACCUM BAL AS '"' */
   if last(glc_per)
   then do:
      if percount > 12
      then
         down.
      else
         down 2.
   */
   DO:
   /* SS - 20050929 - E */

      assign
         cr_act_to_dt    = -1 * cr_act_to_dt
         et_cr_act_to_dt = -1 * et_cr_act_to_dt.

      /* SS - 20050929 - B */
      /*
      display
         getTermLabel("END_BALANCE",7) + ":" @ peryr
         et_dr_act_to_dt @ et_per_dr_act
         et_cr_act_to_dt @ et_per_cr_act
         et_accum_bal
      with frame b.
      */
      ASSIGN
          tta6glabiq_dr = et_dr_act_to_dt
          tta6glabiq_cr = (- et_cr_act_to_dt)
          tta6glabiq_end = et_accum_bal
          .
      /* SS - 20050929 - E */

      if ac_curr            <> et_report_curr
         and tmp_curr       <> base_curr
         and et_report_curr <> base_curr
      then do:
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input  ac_curr,
              input  et_report_curr,
              input  et_rate1,
              input  et_rate2,
              input  dr_act_to_dt,
              input  true,  /* ROUND */
              output dr_act_to_dt,
              output mc-error-number)"}

         if mc-error-number <> 0
         then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end. /* IF mc-error-number <> 0 */

         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input  ac_curr,
              input  et_report_curr,
              input  et_rate1,
              input  et_rate2,
              input  cr_act_to_dt,
              input  true,  /* ROUND */
              output cr_act_to_dt,
              output mc-error-number)"}

         if mc-error-number <> 0
         then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end. /* IF mc-error-number <> 0 */

         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input  ac_curr,
              input  et_report_curr,
              input  et_rate1,
              input  et_rate2,
              input  accum_bal,
              input  true,  /* ROUND */
              output accum_bal,
              output mc-error-number)"}

         if mc-error-number <> 0
         then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end. /* IF mc-error-number <> 0 */

      end.  /* IF ac_curr <> et_report_curr ... */

      else
         /* ACCT NOT CONVERTED DURING BASE CURRENCY CONVERSION */
         if acct_tagged
            and ac_curr  =  et_report_curr
            and tmp_curr <> base_curr
         then do:
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input  base_curr,
                 input  ac_curr,
                 input  et_rate1,
                 input  et_rate2,
                 input  dr_act_to_dt,
                 input  true,  /* ROUND */
                 output dr_act_to_dt,
                 output mc-error-number)"}

            if mc-error-number <> 0
            then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end. /* IF mc-error-number <> 0 */

            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input  base_curr,
                 input  ac_curr,
                 input  et_rate1,
                 input  et_rate2,
                 input  cr_act_to_dt,
                 input  true,  /* ROUND */
                 output cr_act_to_dt,
                 output mc-error-number)"}

            if mc-error-number <> 0
            then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end. /* IF mc-error-number <> 0 */

            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input base_curr,
                 input ac_curr,
                 input et_rate1,
                 input et_rate2,
                 input accum_bal,
                 input true,  /* ROUND */
                 output accum_bal,
                 output mc-error-number)"}

            if mc-error-number <> 0
            then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end. /* IF mc-error-number <> 0 */

         end. /* IF acct_tagged */

         /* SS - 20050929 - B */
         /*
      if et_show_diff
         and (et_dr_act_to_dt    <> dr_act_to_dt
              or et_cr_act_to_dt <> cr_act_to_dt
              or et_accum_bal    <> accum_bal)
      then do:
         clear frame b all.
         down.

         display
            getTermLabel("END_BALANCE",7) + ":" @ peryr
            et_dr_act_to_dt @ et_per_dr_act
            et_accum_bal
            et_cr_act_to_dt @ et_per_cr_act
            et_accum_bal
            tmp_curr @ curr
         with frame b.
         down.

         display
            string(substring(et_diff_txt,1,7) + ":") @ peryr
            (et_dr_act_to_dt - dr_act_to_dt)         @ et_per_dr_act
            (et_cr_act_to_dt - cr_act_to_dt)         @ et_per_cr_act
            (et_accum_bal - accum_bal)               @ et_accum_bal
         with frame b.

      end.  /* IF et_show_diff */
      */
      /* SS - 20050929 - E */
   end. /* IF LAST(glc_per) */
   /* SS - 20050929 - B */
   /*
   down.
   */
   /* SS - 20050929 - E */
end. /* FOR EACH cal */

/* SS - 20050929 - B */
/*
if c-application-mode <> 'web'
then
   pause before-hide.

hide frame b.
*/
/* SS - 20050929 - E */
{wbrp04.i}
