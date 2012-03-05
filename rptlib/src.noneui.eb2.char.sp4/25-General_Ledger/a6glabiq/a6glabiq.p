/* glabiq.p - GENERAL LEDGER ACCOUNT BALANCES INQUIRY                   */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.23 $                                                         */
/*V8:ConvertMode=Report                                                 */
/* REVISION: 1.0     LAST EDIT:  4/08/87    BY: JMS                     */
/* REVISION: 4.0     LAST EDIT: 12/30/87    BY: WUG  *A137*             */
/*                              02/25/88    BY: JMS                     */
/* REVISION: 5.0     LAST EDIT: 12/09/88    BY: RL   *C0028*            */
/*                              05/10/89    by: jms  *B066*             */
/*                              06/25/90    by: jms  *B500*             */
/* REVISION: 6.0     LAST EDIT: 10/15/90    by: jms  *D034*             */
/*                              01/03/91    by: jms  *D287*             */
/*                              09/05/91    by: jms  *D849*             */
/* REVISION: 7.0     LAST EDIT: 12/02/91    by: jms  *F058*             */
/*                                            (program split)           */
/* REVISION: 7.3     LAST EDIT: 09/10/92    BY: mpp  *G479*             */
/*                              06/11/93    BY: jjs  *GC02*             */
/* REVISION: 7.4     LAST EDIT: 10/14/93    BY: wep  *H046*             */
/*                              06/22/94    by: bcm  *H399*             */
/*                              02/07/95    by: str  *H0B5*             */
/* REVISION: 8.6      LAST EDIT: 11/25/97    BY: bvm  *K1BV*             */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton     */
/* REVISION: 8.6E     LAST MODIFIED: 06/16/98   BY: *L02P* John Evertse     */
/* REVISION: 8.6E     LAST MODIFIED: 07/09/98   BY: *L01W* Brenda Milton    */
/* REVISION: 8.6E     LAST MODIFIED: 12/09/98   BY: *L0CT* Robin McCarthy   */
/* REVISION: 9.1      LAST MODIFIED: 08/03/99   BY: *N014* Jeff Wootton     */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* Revision: 1.22    BY: Seema Tyagi           DATE: 01/29/02  ECO: *N17P*  */
/* $Revision: 1.23 $    BY: Shoma Salgaonkar        DATE: 12/05/02  ECO: *N215*  */
/* $Revision: 1.23 $    BY: Bill Jiang        DATE: 09/29/05  ECO: *SS - 20050929*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20050929 - B */                                                                                 
define input parameter i_acc       like ac_code.
define input parameter i_sub       like sb_sub.
define input parameter i_sub1      like sb_sub.
define input parameter i_ctr       like cc_ctr.
define input parameter i_ctr1      like cc_ctr.
define input parameter i_entity    like gltr_entity.
define input parameter i_entity1   like gltr_entity.
define input parameter i_eff_dt     like gltr_eff_dt.
define input parameter i_eff_dt1     like gltr_eff_dt.
define input parameter i_et_report_curr  like exr_curr1.
/*
{mfdtitle.i "2+ "}
    */
    {a6mfdtitle.i "2+ "}
    /* SS - 20050929 - E */

define new shared variable begdt0       as   date.
define new shared variable begdt1       as   date.
define new shared variable enddt1       as   date.
define new shared variable yr_end       as   date.
define new shared variable yr_beg       as   date.
define new shared variable per          as   integer.
define new shared variable per1         as   integer.
define new shared variable yr           as   integer   format "9999".
define new shared variable peryr        as   character format "x(8)"
   label "Period".
define new shared variable acctitle     as   character format "x(11)".
define new shared variable ac_recno     as   recid.
define new shared variable glname       like en_name.
define new shared variable begdt        like gltr_eff_dt.
define new shared variable enddt        like gltr_eff_dt.
define new shared variable acc          like ac_code.
define new shared variable curr         like gltr_curr.
define new shared variable entity       like gltr_entity.
define new shared variable entity1      like gltr_entity.
define new shared variable ret          like co_ret.
define new shared variable sub          like sb_sub.
define new shared variable sub1         like sb_sub.
define new shared variable ctr          like cc_ctr.
define new shared variable ctr1         like cc_ctr.
define new shared variable tmp_curr     like curr    no-undo.
define new shared variable acct_tagged  as   logical no-undo.

define variable use_cc         like  co_use_cc.
define variable use_sub        like  co_use_sub.
define variable pri_ent_curr   like  gltr_curr.
define variable curr_ctr       as    integer.
define variable is_transparent like  mfc_logical no-undo.

{etvar.i &new= "new"}
{etrpvar.i &new = "new"}
{eteuro.i}

/* GET NAME OF PRIMARY ENTITY */
for first en_mstr
   fields (en_entity en_name)
   where en_entity = current_entity
   no-lock:
end. /* FOR FIRSTen_mstr */
if not available en_mstr
then do:
   /* NO PRIMARY ENTITY DEFINED */
   {pxmsg.i &MSGNUM=3059 &ERRORLEVEL=3}
   if c-application-mode <> 'web'
   then
      pause.
   leave.
end. /* IF NOT AVAILABLE en_mstr */
else do:
   glname = en_name.
   release en_mstr.
end. /* ELSE DO */

assign
   entity  = current_entity
   entity1 = current_entity.

/* GET RETAINED EARNINGS CODE FROM CONTROL FILE */
for first co_ctrl
   fields (co_ret co_use_cc co_use_sub)
   no-lock:
end. /* FOR FIRST co_ctrl */
if not available co_ctrl
then do:
   /* CONTROL FILE MUST BE DEFINED BEFORE RUNNING REPORT */
   {pxmsg.i &MSGNUM=3032 &ERRORLEVEL=3}
   if c-application-mode <> 'web'
   then
      pause.
   leave.
end. /* IF NOT AVAILABLE co_ctrl */

assign
   ret     = co_ret
   use_sub = co_use_sub
   use_cc  = co_use_cc.

release co_ctrl.
curr = base_curr.

/* SELECT FORM */
form
   acc            colon 15
   ac_desc        at 30      no-label
   ac_curr        at 65      no-label
   sub            colon 15
   sub1           colon 40   label {t001.i}
   ctr            colon 15
   ctr1           colon 40   label {t001.i}
   entity         colon 15
   entity1        colon 40   label {t001.i}
   yr             colon 15   label "Fiscal Year"
   et_report_curr colon 40
with frame a side-labels width 80 attr-space
title color normal glname.

/* SET EXTERNAL LABELS */
/* SS - 20050929 - B */
/*
setFrameLabels(frame a:handle).
*/
acc = i_acc.
sub = i_sub.
sub1 = i_sub1.
ctr = i_ctr.
ctr1 = i_ctr1.
entity = i_entity.
entity1 = i_entity1.


et_report_curr = i_et_report_curr.
/* SS - 20050929 - E */

{wbrp01.i}

    /* SS - 20050929 - B */
    /*
mainloop:
repeat:
    */
    /* SS - 20050929 - E */

   if entity1 = hi_char
   then
      entity1 = "".

   if sub1    = hi_char
   then
      sub1    = "".

   if ctr1    = hi_char
   then
      ctr1    = "".

   /* ASSIGN VALUE OF FISCAL YEAR, IF EXISTS. ELSE ASSIGN CALENDAR YEAR */
   {glper1.i today peryr}
   if peryr  <> ""
   then
      yr   = glc_year.
   else
      yr   = year(today).

   /* REPORT BLOCK */
   loopaa:
   do on error undo, retry:
       /* SS - 20050929 - B */
       /*
      if c-application-mode <> 'web'
      then
         update
           acc
           sub  when (use_sub)
           sub1 when (use_sub)
           ctr  when (use_cc)
           ctr1 when (use_cc)
           entity
           entity1
           yr
           et_report_curr
         with frame a editing:

            if frame-field = "acc"
            then do:
               /* FIND NEXT/PREVIOUS RECORD */
               {mfnp.i ac_mstr acc ac_code acc ac_code ac_code}
               if recno <> ?
               then do:
                  acc = ac_code.
                  display
                     acc
                     ac_desc
                  with frame a.

                  acctitle = acc + "-" + ac_desc + " (" + ac_curr + ")".

                  if ac_curr <> base_curr
                  then
                     display
                        ac_curr
                     with frame a.
                  else
                     display
                        "" @ ac_curr
                     with frame a.
               end. /* IF recno <> ? */
            end. /* IF frame-field = "acc" */
            else do:
               readkey.
               apply lastkey.
            end. /* ELSE DO */
         end.  /* UPDATE WITH FRAME a EDITING */

         {wbrp06.i &command = update
                   &fields  = "  acc
                                 sub  when (use_sub)
                                 sub1 when (use_sub)
                                 ctr  when (use_cc)
                                 ctr1 when (use_cc)
                                 entity
                                 entity1
                                 yr
                                 et_report_curr  "
                   &frm     = "a"}
                   */
                   /* SS - 20050929 - E */

         if (c-application-mode    <> 'web')
            or (c-application-mode  =  'web'
            and (c-web-request begins 'data'))
         then do:

            if entity1 = ""
            then
               entity1 = hi_char.

            if sub1 = ""
            then
               sub1 = hi_char.

            if ctr1 = ""
            then
               ctr1 = hi_char.

            /* VALIDATE ACCOUNT */
            for first ac_mstr
               fields (ac_code ac_curr ac_desc)
               where ac_code = acc
               no-lock:
            end. /* FOR FIRST ac_mstr */
            /* SS - 20050929 - B */
            /*
            if not available ac_mstr
            then do:
               /* INVALID ACCOUNT CODE */
               {pxmsg.i &MSGNUM=3052 &ERRORLEVEL=3}

               if c-application-mode = 'web'
               then
                  return.
               undo mainloop, retry.
            end. /* IF NOT AVAILABLE ac_mstr */

            display
               ac_desc
            with frame a.

            acctitle = acc + "-" + ac_desc + " (" + ac_curr + ")".

            if ac_curr <> base_curr
            then
               display
                  ac_curr
               with frame a.
            else
               display
                  "" @ ac_curr
               with frame a.
               */
               /* SS - 20050929 - E */

            ac_recno = recid(ac_mstr).

            /*VALIDATE YEAR*/
            /* SS - 20050929 - B */
            /*
            for first glc_cal
               fields (glc_end glc_per glc_start glc_year)
               where glc_year = yr
               no-lock:
            end. /* FOR FIRST glc_cal */
            if not available glc_cal
            then do:
               /* NO FIRST PERIOD DEFINED FOR THIS FISCAL YEAR. */
               {pxmsg.i &MSGNUM=3033 &ERRORLEVEL=3}

               if c-application-mode = 'web'
               then
                  return.
               else
                  next-prompt yr with frame a.

               undo mainloop, retry.
            end. /* IF NOT AVAILABLE glc_cal */

            assign
               yr_beg = glc_start
               begdt0 = yr_beg - 1
               per    = glc_per.

            /* GET DATE OF END OF YEAR */
            for last glc_cal
               fields (glc_end glc_per glc_start glc_year)
               where glc_year = yr
               no-lock.
            end. /* FOR LAST glc_cal */
             assign
               yr_end = glc_end
               per1   = glc_per.

            if (sub <> sub1
               and use_sub)
               or  (ctr <> ctr1
                    and use_cc)
            then do:
                /*MORE THAN ONE SUBACCT/CC MAY INCREASE PROCESSING TIME*/
                {pxmsg.i &MSGNUM=3190 &ERRORLEVEL=2}
            end. /* IF sub <> sub1 ... */
                */
            ASSIGN
                yr_beg = i_eff_dt
                begdt0 = yr_beg - 1
                yr_end = i_eff_dt1
                .
                /* SS - 20050929 - E */

            acct_tagged = no.

            /* SEE IF BCC RUN AND IF ACCT WAS CONVERTED */
            if available et_ctrl
               and et_base_curr <> base_curr
            then do:
               /* BASE CURRENCY CONVERSION HAS BEEN RUN */
               for first qad_wkfl
                  fields (qad_decfld qad_key1 qad_key2)
                  where qad_key1 = "et_gl_cur"
                  and   qad_key2 = ac_code
                  no-lock:
               end. /* FOR FIRST qad_wkfl */
               if available qad_wkfl
               then
                  /* ACCT HAS BEEN TAGGED FOR NO CONVERSION DURING BCC */
                  acct_tagged = yes.
            end. /* IF AVAILABLE et_ctrl ... */

            if et_report_curr = ""
            then
               et_report_curr = base_curr.

            {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
               "(input  et_report_curr,
                 output mc-error-number)"}

            if mc-error-number = 0
            then do:
               /* TO CHECK EURO TRANSPARENCY BETWEEN ACCOUNT,   */
               /* REPORTING AND BASE CURRENCY                   */

               run is_euro_transparent
                  (input  ac_curr,
                   input  et_report_curr,
                   input  base_curr,
                   input  et_eff_date,
                   output is_transparent).

               /* TO CHECK EURO TRANSPARENCY BETWEEN BASE AND */
               /* REPORTING CURRENCY                          */

               if not is_transparent
               then do:
                  {gprunp.i "mcpl" "p" "mc-chk-union-transparency"
                     "(input  base_curr,
                       input  et_report_curr,
                       input  et_eff_date,
                       output is_transparent)" }
               end. /* IF NOT is_transparent */

               if not is_transparent
                  and ac_curr        <>  base_curr
                  and et_report_curr <>  ac_curr
                  and et_report_curr <>  base_curr
               then do:
                  /* REPORTING CURR MUST BE BASE OR ACCT FOR FOREIGN */
                  /* CURRENCY ACCOUNT                                */
                  {pxmsg.i &MSGNUM=3987 &ERRORLEVEL=4}
                  next-prompt et_report_curr with frame a.
                  undo,retry.
               end. /* IF NOT is_transparent ... */

               is_transparent = false.

               if acct_tagged
                  and ac_curr = et_report_curr
               then do:
                  {gprunp.i "mcpl" "p" "mc-get-ex-rate"
                     "(input  base_curr,
                       input  ac_curr,
                       input  "" "",
                       input  et_eff_date,
                       output et_rate1,
                       output et_rate2,
                       output mc-error-number)"}
               end. /*IF acct_tagged AND ... */
               else do:
                  /* REVERSED ORDER OF et_report_curr, ac_curr BELOW */
                  {gprunp.i "mcpl" "p" "mc-get-ex-rate"
                     "(input  et_report_curr,
                       input  ac_curr,
                       input  "" "",
                       input  et_eff_date,
                       output et_rate1,
                       output et_rate2,
                       output mc-error-number)"}
               end. /*ELSE DO */
            end.  /* IF mc-error-number = 0 */

            if mc-error-number <> 0
            then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
               if c-application-mode = 'web'
               then
                  return.
               else
                  next-prompt et_report_curr with frame a.
               undo, retry.
            end.  /* IF mc-error-number <> 0 */

         end.  /* IF (c-application-mode <> 'web') ... */
     end.  /* loopaa:  DO ON ERROR UNDO, RETRY */

     /* OUTPUT DESTINATION SELECTION */
     /* SS - 20050929 - B */
     /*
     {gpselout.i &printType                = "terminal"
                 &printWidth               = 80
                 &pagedFlag                = " "
                 &stream                   = " "
                 &appendToFile             = " "
                 &streamedOutputToTerminal = " "
                 &withBatchOption          = "no"
                 &displayStatementType     = 1
                 &withCancelMessage        = "yes"
                 &pageBottomMargin         = 6
                 &withEmail                = "yes"
                 &withWinprint             = "yes"
                 &defineVariables          = "yes"}

     hide frame a.
     */
     define variable l_textfile        as character no-undo.
     /* SS - 20050929 - E */

     /*DISPLAY DETAIL FOR ALL THREE CURRENCIES; BASE ACCOUNT AND ENTITY */
     currloop:
     /* SS - 20050929 - B */
     /*
     repeat curr_ctr = 1 to 3:
        if c-application-mode <> 'web'
        then
           pause before-hide.
        */
     repeat curr_ctr = 1 to 1:
        /* SS - 20050929 - E */

        curr = "".

        if curr_ctr = 1
        then
           assign
              curr     = base_curr
              tmp_curr = base_curr.
        else do:
           if curr_ctr = 2
              and (ac_curr    <> base_curr
                   or ac_curr <> et_report_curr)
           then
              assign
                 curr     = ac_curr
                 tmp_curr = ac_curr.
           else
              curr = "".
        end. /* ELSE DO */

        if curr_ctr = 2
           and et_report_curr <> ac_curr
           and not acct_tagged
           and et_report_curr <> base_curr
        then do:
           tmp_curr = et_report_curr.
           {gprunp.i "mcpl" "p" "mc-get-ex-rate"
              "(input  ac_curr,
                input  et_report_curr,
                input  "" "",
                input  et_eff_date,
                output et_rate1,
                output et_rate2,
                output mc-error-number)"}
        end. /* IF curr_ctr = 2 AND ... */

        if curr <> ""
        then do:
            /* SS - 20050929 - B */
            /*
           /* CALCULATE AND DISPLAY BALANCES */
           {gprun.i ""glabiqa.p""}

           /* APPLY LAST KEY PRESSED TO TRAP <END> */
           if c-application-mode <> 'web'
           then do:
              apply lastkey.
              if lastkey = keycode("F4")
              then
                 leave.
           end. /* IF c-application-mode <> 'web' */
           */
            {gprun.i ""a6glabiqa.p""}
           /* SS - 20050929 - E */
        end. /* IF curr <> "" */
     end. /*END CURRLOOP*/

     /* SS - 20050929 - B */
     /*
     {mfreset.i}  /*CLOSE OUTPUT*/
     view frame a.
end.  /* REPEAT */
*/
/* SS - 20050929 - E */

/* DEFINITION FOR PROCEDURE is_euro_transparent */
{gpacctet.i}

{wbrp04.i &frame-spec = a}
