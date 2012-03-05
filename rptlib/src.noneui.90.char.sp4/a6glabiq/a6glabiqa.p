/* glabiqa.p - GENERAL LEDGER ACCOUNT BALANCES INQUIRY (PART II)        */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Report                                        */
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
/* REVISION: 8.6E    LAST MODIFIED: 08/29/05   BY: *SS - 20050829* Bill Jiang*/
/* REVISION: 8.6E    LAST MODIFIED: 09/01/05   BY: *SS - 20050901* Bill Jiang*/

/* SS - 20050829 - B */
define input parameter acc       like ac_code.
define input parameter sub       like sb_sub.
define input parameter sub1      like sb_sub.
define input parameter ctr       like cc_ctr.
define input parameter ctr1      like cc_ctr.
define input parameter entity    like gltr_entity.
define input parameter entity1   like gltr_entity.
define input parameter eff_dt     like gltr_eff_dt.
define input parameter eff_dt1     like gltr_eff_dt.

{a6glabiq.i}
/* SS - 20050829 - E */

          {mfdeclre.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE glabiqa_p_1 "累计余额"
/* MaxLen: Comment: */

&SCOPED-DEFINE glabiqa_p_2 "期间"
/* MaxLen: Comment: */

&SCOPED-DEFINE glabiqa_p_3 "期初差额:"
/* MaxLen: Comment: */

&SCOPED-DEFINE glabiqa_p_4 "每个活动（借款）"
/* MaxLen: Comment: */

&SCOPED-DEFINE glabiqa_p_5 "     期初余额    "
/* MaxLen: Comment: */

&SCOPED-DEFINE glabiqa_p_6 "每个活动（信贷）"
/* MaxLen: Comment: */

&SCOPED-DEFINE glabiqa_p_7 "期未余额:"
/* MaxLen: Comment: */

&SCOPED-DEFINE glabiqa_p_8 "      期末结余"
/* MaxLen: Comment: */

&SCOPED-DEFINE glabiqa_p_9 "货币"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

          {wbrp02.i}


          define shared variable per       as integer.
          define shared variable per1      as integer.
          define shared variable yr        as integer.
          define shared variable begdt0    as date.
          define shared variable begdt1    as date.
          define shared variable enddt1    as date.
          define shared variable yr_end    as date.
          define shared variable yr_beg    as date.
          define shared variable peryr     as character
/*L00M    format "x(8)" */
/*L03J*  /*L00M*/ format "x(22)" */
/*L03J*/  format "x(8)"
             label {&glabiqa_p_2}.
          define shared variable ac_recno  as recid.
          define shared variable acctitle  as character format "x(11)".
          define shared variable curr_type as character format "x(19)".
          define shared variable glname    like en_name.
          define shared variable begdt     like gltr_eff_dt.
          define shared variable enddt     like gltr_eff_dt.
          /* SS - 20050829 - B */
          /*
          define shared variable acc       like ac_code.
          define shared variable sub       like sb_sub.
          define shared variable sub1      like sb_sub.
          define shared variable ctr       like cc_ctr.
          define shared variable ctr1      like cc_ctr.
          */
          /* SS - 20050829 - E */
          define shared variable curr      like gltr_curr.
          /* SS - 20050829 - B */
          /*
          define shared variable entity    like gltr_entity.
          define shared variable entity1   like gltr_entity.
          */
          /* SS - 20050829 - E */
          define shared variable ret       like co_ret.
/*L0CT*/  define shared variable acct_tagged as logical no-undo.

          define new shared variable beg_bal as decimal
             format ">>>,>>>,>>>,>>9.99cr" label {&glabiqa_p_5}.

          define new shared variable beg_bal1 like beg_bal.
          define new shared variable beg_bal2 like beg_bal.

          define new shared variable per_dr_act as decimal
             format "->>>,>>>,>>9.99" label {&glabiqa_p_4}.
          define new shared variable per_cr_act like per_dr_act
             label {&glabiqa_p_6}.

          define new shared variable knt     as integer.
          define new shared variable dt      as date.
          define new shared variable dt1     as date.

          define variable end_bal   like beg_bal label {&glabiqa_p_8}.
          define variable dr_act_to_dt like per_dr_act.
          define variable cr_act_to_dt like per_dr_act.
          define variable bb_accum  like beg_bal.
          define variable pa_dr_accum like per_dr_act.
          define variable pa_cr_accum like per_cr_act.
          define variable accum_bal like beg_bal label {&glabiqa_p_1}.
          define variable percount  as integer.

/*L01W*/  define shared variable tmp_curr like curr no-undo.

          define buffer cal for glc_cal.

/*L00M*BEGIN ADD*/
          {etvar.i  }
          {etrpvar.i}
          define variable et_accum_bal    like accum_bal.
          define variable et_per_dr_act   like per_dr_act.
          define variable et_per_cr_act   like per_cr_act.
          define variable et_dr_act_to_dt like dr_act_to_dt.
          define variable et_cr_act_to_dt like cr_act_to_dt.
/*L00M*END ADD*/


          /* SELECT FORM */
          form
            peryr
/*L00M*     per_dr_act      */
/*L00M*/    et_per_dr_act
/*L00M*     per_cr_act    */
/*L00M*/    et_per_cr_act
/*L00M*     accum_bal    */
/*L00M*/    et_accum_bal
            curr      column-label {&glabiqa_p_9}
         with frame b down width 80  attr-space title color normal acctitle.

         /*INITIALIZE ACTIVITY TO DATE */
/*L00M*  dr_act_to_dt = 0.   */
/*L00M*  cr_act_to_dt = 0.   */
/*L05L*/ assign
/*L05L*/    dr_act_to_dt = 0
/*L05L*/    cr_act_to_dt = 0
/*L00M*/    et_dr_act_to_dt = 0
/*L00M*/    et_cr_act_to_dt = 0
            bb_accum = 0.  /*INITIALIZE BEGIN BAL ACCUMULATOR*/

/*L0BK*/ for first ac_mstr fields(ac_code ac_curr ac_type)
/*L0BK*/ where recid(ac_mstr) = ac_recno no-lock: end.

         /*LOOP FOR EACH SUB-ACCT AND COST CTR IN THE RANGE FOR THE ACCT*/
         for each asc_mstr where asc_acc  = acc and
                                 asc_sub >= sub and asc_sub <= sub1 and
                                 asc_cc  >= ctr and asc_cc  <= ctr1 no-lock:
/*L0BK*     find ac_mstr where ac_code = asc_acc no-lock no-error.
 *          if not available ac_mstr then next.
 *          ac_recno = recid(ac_mstr).
 *L0BK*/

            /* CALCULATE AND DISPLAY BEGINNING BALANCE */
             /* SS - 20050901 - B */
             /*
            if lookup(ac_type, "A,L") = 0 then do:
               {gprun.i ""glabiqb.p"" "(input  asc_acc,
                                        input  asc_sub,
                                        input  asc_cc,
                                        input  yr_beg,
                                        input  begdt0,
                                        output beg_bal1,
                                        output beg_bal2)"}
            end.
            else do:
               {gprun.i ""glabiqb.p"" "(input  asc_acc,
                                        input  asc_sub,
                                        input  asc_cc,
                                        input  low_date,
                                        input  begdt0,
                                        output beg_bal1,
                                        output beg_bal2)"}
            end.
               */
             if lookup(ac_type, "A,L") = 0 then do:
                {gprun.i ""a6glabiqb.p"" "(input  asc_acc,
                                         input  asc_sub,
                                         input  asc_cc,
                    INPUT entity,
                    INPUT entity1,
                                         input  yr_beg,
                                         input  begdt0,
                                         output beg_bal1,
                                         output beg_bal2)"}
             end.
             else do:
                {gprun.i ""a6glabiqb.p"" "(input  asc_acc,
                                         input  asc_sub,
                                         input  asc_cc,
                    INPUT entity,
                    INPUT entity1,
                                         input  low_date,
                                         input  begdt0,
                                         output beg_bal1,
                                         output beg_bal2)"}
             end.
               /* SS - 20050901 - E */
            bb_accum = bb_accum + beg_bal1 + beg_bal2.
         end.  /* for each asc_mstr */
         beg_bal = bb_accum.

         /*DETERMINE HOW MANY PERIODS EXIST, KNOWLEDGE OF THIS */
         /*WILL ALLOW FOR THE INSERTION OF BLANK LINES IF SPACE*/
         /*IS AVAILABLE                                        */
         perloop:
         for each cal where cal.glc_year = yr no-lock
         break by cal.glc_per:
            percount = percount + 1.
         end.

         /* CALCULATE PERIOD TOTALS */
         /* SS - 20050829 - B */
         DO:
         /*
         for each cal where cal.glc_year = yr no-lock
         with frame b down
         break by cal.glc_per:
             */
             /* SS - 20050829 - E */

            /* LOOK UP TRANSACTIONS */
            begdt1 = yr_beg.
            /* SS - 20050829 - B */
            /*
            if begdt1 < cal.glc_start then begdt1 = cal.glc_start.
            */
            /* SS - 20050829 - E */
            enddt1 = yr_end.
            /* SS - 20050829 - B */
            /*
            if enddt1 > cal.glc_end then enddt1 = cal.glc_end.
            */
            /* SS - 20050829 - E */
/*L01W*/    assign
               knt = 0
               per_dr_act = 0
               per_cr_act = 0
               pa_dr_accum = 0
               pa_cr_accum = 0.

            /*LOOP FOR EACH SUBACCT AND COST CTR IN THE RANGE FOR THE ACCT*/
            for each asc_mstr where asc_acc  = acc and
                                    asc_sub >= sub and asc_sub <= sub1 and
                                    asc_cc  >= ctr and asc_cc  <= ctr1 no-lock:
/*L0BK*        find ac_mstr where ac_code = asc_acc no-lock no-error.
 *             if not available ac_mstr then next.
 *             ac_recno = recid(ac_mstr).
 *L0BK*/

                /* SS - 20050901 - B */
                /*
               {gprun.i ""glabiqb.p"" "(input asc_acc,
                                        input asc_sub,
                                        input asc_cc,
                                        input begdt1,
                                        input enddt1,
                                        output per_cr_act,
                                        output per_dr_act)"}
                   */
                   {gprun.i ""a6glabiqb.p"" "(input asc_acc,
                                            input asc_sub,
                                            input asc_cc,
                       INPUT entity,
                       INPUT entity1,
                                            input begdt1,
                                            input enddt1,
                                            output per_cr_act,
                                            output per_dr_act)"}
                   /* SS - 20050901 - E */

               pa_dr_accum = pa_dr_accum + per_dr_act.
               pa_cr_accum = pa_cr_accum + per_cr_act.

            end.  /* for each asc_mstr */
            per_dr_act = pa_dr_accum.
            per_cr_act = pa_cr_accum.

/*L01W* /*L00M*/  {etrpconv.i per_dr_act et_per_dr_act} */
/*L01W* /*L00M*/  {etrpconv.i per_cr_act et_per_cr_act} */

/*L01W*/    if ac_curr <> et_report_curr and tmp_curr <> base_curr then do:
/*L01W*/       {gprunp.i "mcpl" "p" "mc-curr-conv"
                 "(input ac_curr,
                   input et_report_curr,
                   input et_rate1,
                   input et_rate2,
                   input per_dr_act,
                   input true,  /* ROUND */
                   output et_per_dr_act,
                   output mc-error-number)"}
/*L01W*/       if mc-error-number <> 0 then do:
/*L01W*/          {mfmsg.i mc-error-number 2}
/*L01W*/       end.
/*L01W*/       {gprunp.i "mcpl" "p" "mc-curr-conv"
                 "(input ac_curr,
                   input et_report_curr,
                   input et_rate1,
                   input et_rate2,
                   input per_cr_act,
                   input true,  /* ROUND */
                   output et_per_cr_act,
                   output mc-error-number)"}
/*L01W*/       if mc-error-number <> 0 then do:
/*L01W*/          {mfmsg.i mc-error-number 2}
/*L01W*/       end.
/*L01W*/    end.  /* if ac_curr <> et_report_curr ... */
/*L0CT *************** BEGIN SECTION ADDED */
            else
            /* ACCT NOT CONVERTED DURING BASE CURRENCY CONVERSION */

            if acct_tagged and
            ac_curr = et_report_curr and tmp_curr <> base_curr then do:
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                 "(input base_curr,
                   input ac_curr,
                   input et_rate1,
                   input et_rate2,
                   input per_dr_act,
                   input true,  /* ROUND */
                   output et_per_dr_act,
                   output mc-error-number)"}

               if mc-error-number <> 0 then do:
                  {mfmsg.i mc-error-number 2}
               end.

               {gprunp.i "mcpl" "p" "mc-curr-conv"
                 "(input base_curr,
                   input ac_curr,
                   input et_rate1,
                   input et_rate2,
                   input per_cr_act,
                   input true,  /* ROUND */
                   output et_per_cr_act,
                   output mc-error-number)"}

               if mc-error-number <> 0 then do:
                  {mfmsg.i mc-error-number 2}
               end.
            end.   /* IF acct_tagged */
/*L0CT *************** END SECTION ADDED */
/*L01W*/    else assign
/*L01W*/       et_per_dr_act = per_dr_act
/*L01W*/       et_per_cr_act = per_cr_act.

            /* DISPLAY BEGINNING BALANCE FOLLOWED BY PERIOD TOTAL */
/* SS - 20050829 - B */
/*
            if first(glc_per) then do:
                */
DO:
                /* SS - 20050829 - E */
               accum_bal = beg_bal.
/*L01W* /*L00M*/ {etrpconv.i beg_bal et_accum_bal} */
/*L01W*/       if ac_curr <> et_report_curr and tmp_curr <> base_curr then do:
/*L01W*/          {gprunp.i "mcpl" "p" "mc-curr-conv"
                    "(input ac_curr,
                      input et_report_curr,
                      input et_rate1,
                      input et_rate2,
                      input beg_bal,
                      input true,  /* ROUND */
                      output et_accum_bal,
                      output mc-error-number)"}
/*L01W*/          if mc-error-number <> 0 then do:
/*L01W*/             {mfmsg.i mc-error-number 2}
/*L01W*/          end.
/*L01W*/       end.  /* if ac_curr <> et_report_curr ... */
/*L01W*/       else et_accum_bal = beg_bal.

                    /* SS - 20050829 - B */
                    CREATE tta6glabiq.
                    ASSIGN
                        tta6glabiq_acc = acc
                        tta6glabiq_curr = tmp_curr
                        tta6glabiq_beg = et_accum_bal
                        .
                    /*
               display {&glabiqa_p_3} @ peryr
/*L00M*                "" @ per_dr_act   */
/*L00M*                "" @ per_cr_act   */
/*L00M*/               "" @ et_per_dr_act
/*L00M*/               "" @ et_per_cr_act
/*L00M*                accum_bal          */
/*L00M*/               et_accum_bal
/*L01W* /*L00M*/       et_disp_curr @ curr  */
/*L01W*/               tmp_curr @ curr
               with frame b.

               if percount > 12 then
                  down.
               else
                  down 2.
               */
               /* SS - 20050829 - E */
            end.  /* if first(glc_per) */

/*L01W*/    assign
/*L00M*        dr_act_to_dt = dr_act_to_dt + per_dr_act. */
/*L00M*        cr_act_to_dt = cr_act_to_dt + per_cr_act. */
/*L05L*/       dr_act_to_dt = dr_act_to_dt + per_dr_act
/*L05L*/       cr_act_to_dt = cr_act_to_dt + per_cr_act
/*L00M*/       et_dr_act_to_dt = et_dr_act_to_dt + et_per_dr_act
/*L00M*/       et_cr_act_to_dt = et_cr_act_to_dt + et_per_cr_act
/*L00M*        accum_bal = accum_bal + per_dr_act + per_cr_act.  */
/*L05L*/       accum_bal = accum_bal + per_dr_act + per_cr_act
/*L00M*/       et_accum_bal = et_accum_bal + et_per_dr_act + et_per_cr_act
    /* SS - 20050829 - B */
    /*
               peryr = string(glc_per,"99") + "/" + string(glc_year)
    */
    /* SS - 20050829 - E */
               per_cr_act = -1 * per_cr_act
/*L05L*/       et_per_cr_act = -1 * et_per_cr_act.

/*L00M*     display peryr per_dr_act per_cr_act accum_bal    */
/* SS - 20050829 - B */
/*
/*L00M*/    display peryr et_per_dr_act et_per_cr_act et_accum_bal
            with frame b.
*/
/* SS - 20050829 - E */

            /*IF FUTURE PERIOD, SHOW ACCUM BAL AS '"' */

/* SS - 20050829 - B */
/*
            if last(glc_per) then do:
                */
DO:
                /* SS - 20050829 - E */
                /* SS - 20050829 - B */
                /*
               if percount > 12 then
                  down.
               else
                  down 2.
                  */
                  /* SS - 20050829 - E */

/*L05L*/       assign
                  cr_act_to_dt = -1 * cr_act_to_dt
/*L05L*/          et_cr_act_to_dt = -1 * et_cr_act_to_dt.

/*L00M*        display "End Bal:" @ peryr dr_act_to_dt @ per_dr_act    */
/*L00M*        cr_act_to_dt @ per_cr_act accum_bal with frame b.   */

/*L00M*BEGIN ADD*/
/*L03J*        display "End Bal:" @ peryr */
/* SS - 20050829 - B */
ASSIGN
    tta6glabiq_dr = et_dr_act_to_dt
    tta6glabiq_cr = et_cr_act_to_dt
    tta6glabiq_end = et_accum_bal
    .
/*
/*L03J*/       display {&glabiqa_p_7} @ peryr
/*L03J*                et_dr_act_to_dt @ per_dr_act */
/*L03J*/               et_dr_act_to_dt @ et_per_dr_act
/*L03J*                et_cr_act_to_dt @ per_cr_act */
/*L03J*/               et_cr_act_to_dt @ et_per_cr_act
                       et_accum_bal
               with frame b.
*/
/* SS - 20050829 - E */
/*L00M*END ADD*/
/*L00M*ADD SECTION*/
/*L01W*        {etrpconv.i dr_act_to_dt dr_act_to_dt} */
/*L01W*        {etrpconv.i cr_act_to_dt cr_act_to_dt} */
/*L01W*        {etrpconv.i accum_bal accum_bal} */
/*L01W*/       if ac_curr <> et_report_curr and tmp_curr <> base_curr then do:
/*L01W*/          {gprunp.i "mcpl" "p" "mc-curr-conv"
                    "(input ac_curr,
                      input et_report_curr,
                      input et_rate1,
                      input et_rate2,
                      input dr_act_to_dt,
                      input true,  /* ROUND */
                      output dr_act_to_dt,
                      output mc-error-number)"}
/*L01W*/          if mc-error-number <> 0 then do:
/*L01W*/             {mfmsg.i mc-error-number 2}
/*L01W*/          end.
/*L01W*/          {gprunp.i "mcpl" "p" "mc-curr-conv"
                    "(input ac_curr,
                      input et_report_curr,
                      input et_rate1,
                      input et_rate2,
                      input cr_act_to_dt,
                      input true,  /* ROUND */
                      output cr_act_to_dt,
                      output mc-error-number)"}
/*L01W*/          if mc-error-number <> 0 then do:
/*L01W*/             {mfmsg.i mc-error-number 2}
/*L01W*/          end.
/*L01W*/          {gprunp.i "mcpl" "p" "mc-curr-conv"
                    "(input ac_curr,
                      input et_report_curr,
                      input et_rate1,
                      input et_rate2,
                      input accum_bal,
                      input true,  /* ROUND */
                      output accum_bal,
                      output mc-error-number)"}
/*L01W*/          if mc-error-number <> 0 then do:
/*L01W*/             {mfmsg.i mc-error-number 2}
/*L01W*/          end.
/*L01W*/       end.  /* if ac_curr <> et_report_curr ... */
/*L0CT *************** BEGIN SECTION ADDED */
               else
               /* ACCT NOT CONVERTED DURING BASE CURRENCY CONVERSION */

               if acct_tagged and
               ac_curr = et_report_curr and tmp_curr <> base_curr then do:
                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                    "(input base_curr,
                      input ac_curr,
                      input et_rate1,
                      input et_rate2,
                      input dr_act_to_dt,
                      input true,  /* ROUND */
                      output dr_act_to_dt,
                      output mc-error-number)"}
                  if mc-error-number <> 0 then do:
                     {mfmsg.i mc-error-number 2}
                  end.
                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                    "(input base_curr,
                      input ac_curr,
                      input et_rate1,
                      input et_rate2,
                      input cr_act_to_dt,
                      input true,  /* ROUND */
                      output cr_act_to_dt,
                      output mc-error-number)"}
                  if mc-error-number <> 0 then do:
                     {mfmsg.i mc-error-number 2}
                  end.
                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                    "(input base_curr,
                      input ac_curr,
                      input et_rate1,
                      input et_rate2,
                      input accum_bal,
                      input true,  /* ROUND */
                      output accum_bal,
                      output mc-error-number)"}
                  if mc-error-number <> 0 then do:
                     {mfmsg.i mc-error-number 2}
                  end.
               end.   /* IF acct_tagged */
/*L0CT *************** END SECTION ADDED */

               /* SS - 20050829 - B */
               /*
               if et_show_diff and
               (et_dr_act_to_dt <> dr_act_to_dt or
                et_cr_act_to_dt <> cr_act_to_dt or
                et_accum_bal <> accum_bal)
               then do:
                  clear frame b all.
                  down.
/*L03J*           display "Ending Balance:" @ peryr */
/*L03J*/          display {&glabiqa_p_7} @ peryr
                          et_dr_act_to_dt @ et_per_dr_act et_accum_bal
                          et_cr_act_to_dt @ et_per_cr_act et_accum_bal
/*L01W*                   et_disp_curr @ curr with frame b.   */
/*L01W*/                  tmp_curr @ curr with frame b.
                  down.
/*L05L*           display string(substring(et_diff_txt,1,21) + ":") */
/*L05L*/          display string(substring(et_diff_txt,1,7) + ":")
                          @ peryr
                          (et_dr_act_to_dt - dr_act_to_dt) @ et_per_dr_act
                          (et_cr_act_to_dt - cr_act_to_dt) @ et_per_cr_act
                          (et_accum_bal - accum_bal) @ et_accum_bal
                  with frame b.
               end.  /* if et_show_diff */
               */
               /* SS - 20050829 - E */
/*L00M*END ADD SECTION*/

            end. /*SS - 20050829* if last(glc_per) then do: */
            /* SS - 20050829 - B */
            /*
            down.
            */
            /* SS - 20050829 - E */
         end. /*SS - 20050829* for each cal where cal.glc_year = yr no-lock */

         /* SS - 20050829 - B */
         /*
         if c-application-mode <> 'web':u then
            pause before-hide.

         hide frame b.
         */
         /* SS - 20050829 - E */
         {wbrp04.i}
