/* glabiq.p - GENERAL LEDGER ACCOUNT BALANCES INQUIRY                   */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert glabiq.p (converter v1.00) Fri Oct 10 13:57:41 1997      */
/* web tag in glabiq.p (converter v1.00) Mon Oct 06 14:18:14 1997       */
/*F0PN*/ /*K1BV*/ /*V8#ConvertMode=WebReport                            */
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
/* REVISION: 8.6     LAST EDIT: 11/25/97    BY: bvm  *K1BV*             */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane     */
/* REVISION: 8.6E    LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton  */
/* REVISION: 8.6E    LAST MODIFIED: 06/16/98   BY: *L02P* John Evertse  */
/* REVISION: 8.6E    LAST MODIFIED: 07/09/98   BY: *L01W* Brenda Milton */
/* REVISION: 8.6E    LAST MODIFIED: 12/09/98   BY: *L0CT* Robin McCarthy*/
/* REVISION: 8.6E    LAST MODIFIED: 08/29/05   BY: *SS - 20050829* Bill Jiang*/
          /* SS - 20050829 - B */
          /*
         {mfdtitle.i "f+ "}
          */
          {a6glabiq.i}

          define input parameter acc       like ac_code.
          define input parameter sub       like sb_sub.
          define input parameter sub1      like sb_sub.
          define input parameter ctr       like cc_ctr.
          define input parameter ctr1      like cc_ctr.
          define input parameter entity    like gltr_entity.
          define input parameter entity1   like gltr_entity.
          define input parameter eff_dt     like gltr_eff_dt.
          define input parameter eff_dt1     like gltr_eff_dt.

          {a6mfdtitle.i "f+ "}
          /* SS - 20050829 - E */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE glabiq_p_1 "期间"
/* MaxLen: Comment: */

&SCOPED-DEFINE glabiq_p_2 "年份"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

          define new shared variable begdt0    as date.
          define new shared variable begdt1    as date.
          define new shared variable enddt1    as date.
          define new shared variable yr_end    as date.
          define new shared variable yr_beg    as date.
          define new shared variable per       as integer.
          define new shared variable per1      as integer.
          define new shared variable yr        as integer format "9999".
          define new shared variable peryr     as character format "x(8)"
             label {&glabiq_p_1}.
          define new shared variable acctitle  as character format "x(11)".
          define new shared variable ac_recno  as recid.
          define new shared variable glname    like en_name.
          define new shared variable begdt     like gltr_eff_dt.
          define new shared variable enddt     like gltr_eff_dt.
          /* SS - 20050829 - B */
          /*
          define new shared variable acc       like ac_code.
          */
          /* SS - 20050829 - E */
          define new shared variable curr      like gltr_curr.
          /* SS - 20050829 - B */
          /*
          define new shared variable entity    like gltr_entity.
          define new shared variable entity1   like gltr_entity.
          */
          /* SS - 20050829 - E */
          define new shared variable ret       like co_ret.
          /* SS - 20050829 - B */
          /*
          define new shared variable sub       like sb_sub.
          define new shared variable sub1      like sb_sub.
          define new shared variable ctr       like cc_ctr.
          define new shared variable ctr1      like cc_ctr.
          */
          /* SS - 20050829 - E */
/*L01W*/  define new shared variable tmp_curr  like curr no-undo.
/*L0CT*/  define new shared variable acct_tagged as logical no-undo.

/*L01W*   define variable xrate     like exd_rate. */
/*L01W* /*L00Y*/  define variable xrate2    like exd_rate. */
/*L01W*   define variable xrate1    like exd_rate. */
/*L01W* /*L00Y*/ define variable xrate12   like exd_rate. */
          define variable use_cc       like co_use_cc.
          define variable use_sub      like co_use_sub.
          define variable pri_ent_curr like gltr_curr.
          define variable valid_acct   as logical.
          define variable curr_ctr     as integer.

/*L02P*ADD SECTION*/
          {etvar.i &new= "new"}
          {etrpvar.i &new = "new"}
          {eteuro.i}
/*L02P*END ADD SECTION*/

          /* GET NAME OF PRIMARY ENTITY */
          find en_mstr where en_entity = current_entity no-lock no-error.
          if not available en_mstr then do:
             {mfmsg.i 3059 3} /* NO PRIMARY ENTITY DEFINED */
             if c-application-mode <> 'web':u then
                pause.
             leave.
          end.
          else do:
             glname = en_name.
             release en_mstr.
          end.
          entity = current_entity.
          entity1 = current_entity.

          /* GET RETAINED EARNINGS CODE FROM CONTROL FILE */
          find first co_ctrl no-lock no-error.
          if not available co_ctrl then do:
             {mfmsg.i 3032 3} /* CONTROL FILE MUST BE DEFINED BEFORE
                                 RUNNING REPORT */
             if c-application-mode <> 'web':u then
                pause.
             leave.
          end.
/*L01W*/  assign
             ret = co_ret
             use_sub = co_use_sub
             use_cc = co_use_cc.
          release co_ctrl.
          curr = base_curr.

          /* SELECT FORM */
          form
             acc     colon 15  ac_desc at 30 no-label ac_curr at 65 no-label
             sub     colon 15  sub1    colon 40 label {t001.i}
             ctr     colon 15  ctr1    colon 40 label {t001.i}
             entity  colon 15  entity1 colon 40 label {t001.i}
             yr      colon 15  label {&glabiq_p_2}
/*L01W*/     et_report_curr colon 40
/*L02P*ADD SECTION*/
/*L01W*      et_report_txt no-label to 20 */
/*L01W*      et_report_curr no-label colon 23 skip */
/*L01W*      et_rate_txt no-label to 20 */
/*L01W*      et_report_rate no-label colon 23 skip */
/*L02P*END ADD SECTION*/
          with frame a side-labels width 80 attr-space
          title color normal glname.

          {wbrp01.i}

              /* SS - 20050829 - B */
              /*
          mainloop:
          repeat:
              */
              /* SS - 20050829 - E */
             if entity1 = hi_char then entity1 = "".
             if sub1    = hi_char then sub1    = "".
             if ctr1    = hi_char then ctr1    = "".
             yr         = year(today).

             /* REPORT BLOCK */
             loopaa:
             do on error undo, retry:
/*L01W* /*L02P*/ display et_report_txt */
/*L01W* /*L02P*/         et_rate_txt */
/*L01W* /*L02P*/ with frame a. */
                 /* SS - 20050829 - B */
                 /*
                if c-application-mode <> 'web':u then
                   update
                      acc
                      sub when (use_sub)
                      sub1 when (use_sub)
                      ctr when (use_cc)
                      ctr1 when (use_cc)
                      entity
                      entity1
                      yr
/*L02P*/              et_report_curr
/*L01W* /*L02P*/      et_report_rate */
                   with frame a editing:

                      if frame-field = "acc" then do:
                         /* FIND NEXT/PREVIOUS RECORD */
                         {mfnp.i ac_mstr acc ac_code acc ac_code ac_code}
                         if recno <> ? then do:
                            acc = ac_code.
                            display acc ac_desc with frame a.
                            acctitle = acc + "-" + ac_desc +
                                       " (" + ac_curr + ")".
                            if ac_curr <> base_curr then
                               display ac_curr
                               with frame a.
                            else
                               display "" @ ac_curr
                               with frame a.
                         end.
                      end.
                      else do:
                         readkey.
                         apply lastkey.
                      end.
                   end.  /* update with frame a editing */

                {wbrp06.i &command = update &fields = "  acc sub when (use_sub)
                 sub1 when (use_sub) ctr when (use_cc) ctr1 when (use_cc)
                 entity entity1 yr
/*L01W*/         et_report_curr
                 " &frm = "a"}
                    */
                    /* SS - 20050829 - E */

                if (c-application-mode <> 'web':u) or
                (c-application-mode = 'web':u and
                (c-web-request begins 'data':u)) then do:

                   if entity1 = "" then entity1 = hi_char.
                   if sub1    = "" then sub1 = hi_char.
                   if ctr1    = "" then ctr1 = hi_char.

                   /* VALIDATE ACCOUNT */
                   find ac_mstr where ac_code = acc no-lock no-error.
                   /* SS - 20050829 - B */
                   /*
                   if not available ac_mstr then do:
                      {mfmsg.i 3014 3} /*INVALID ACCOUNT/COST CENTER */
                      if c-application-mode = 'web':u then return.
                      undo mainloop, retry.
                   end.
                   display ac_desc with frame a.
                   */
                   /* SS - 20050829 - E */
                   acctitle = acc + "-" + ac_desc + " (" + ac_curr + ")".
                   /* SS - 20050829 - B */
                   /*
                   if ac_curr <> base_curr then
                      display ac_curr with frame a.
                   else
                      display "" @ ac_curr with frame a.
                      */
                      /* SS - 20050829 - E */
                   ac_recno = recid(ac_mstr).

                   /*VALIDATE YEAR*/
                   /* SS - 20050829 - B */
                   /*
                   find first glc_cal where glc_year = yr no-lock no-error.
                   if not available glc_cal then do:
                      {mfmsg.i 3033 3} /* NO FIRST PERIOD DEFINED FOR THIS
                                          FISCAL YEAR. */
                      if c-application-mode = 'web':u then return.
                      else next-prompt yr with frame a.
                      undo mainloop, retry.
                   end.
/*L01W*/           assign
                      yr_beg = glc_start
                      begdt0 = yr_beg - 1
                      per    = glc_per.

                   /* GET DATE OF END OF YEAR */
                   find last glc_cal where glc_year = yr no-lock.
/*L01W*/           assign
                      yr_end = glc_end
                      per1   = glc_per.
*/
ASSIGN
    yr_beg = eff_dt
    begdt0 = yr_beg - 1
    yr_end = eff_dt1
    .

/*
                   if (sub <> sub1 and use_sub) or
                   (ctr <> ctr1 and use_cc) then do:
                      {mfmsg.i 3190 2}
                      /*MORE THAN ONE SUBACCT/CC MAY INCREASE PROCESSING TIME*/
                   end.
                      */
/* SS - 20050829 - E */

/*L0CT***BEGIN SECTION ADDED */
                   acct_tagged = no.

                   /* SEE IF BCC RUN AND IF ACCT WAS CONVERTED */
                   if available et_ctrl and et_base_curr <> base_curr then do:
                      /* BASE CURRENCY CONVERSION HAS BEEN RUN */

                      find first qad_wkfl where qad_key1 = "et_gl_cur"
                      and qad_key2 = ac_code no-lock no-error.
                      if available qad_wkfl then
                         acct_tagged = yes.
                         /* ACCT HAS BEEN TAGGED FOR NO CONVERSION DURING BCC */
                   end.

                   if et_report_curr = "" then
                      et_report_curr = base_curr.
/*L0CT***END SECTION ADDED */

/*L0CT /*L01W*/    if et_report_curr <> "" then do: */
/*L01W*/              {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
                        "(input et_report_curr,
                          output mc-error-number)"}

                      if mc-error-number = 0 then do:
/*L0CT*/                 if acct_tagged and ac_curr = et_report_curr then do:
/*L0CT*/                    {gprunp.i "mcpl" "p" "mc-get-ex-rate"
                                      "(input  base_curr,
                                        input  ac_curr,
                                        input  "" "",
                                        input  et_eff_date,
                                        output et_rate1,
                                        output et_rate2,
                                        output mc-error-number)"}
/*L0CT*/                 end.
/*L0CT*/                 else do:
/*L0CT                      REVERSED ORDER OF et_report_curr, ac_curr BELOW */
/*L01W*/                    {gprunp.i "mcpl" "p" "mc-get-ex-rate"
                                      "(input  et_report_curr,
                                        input  ac_curr,
                                        input  "" "",
                                        input  et_eff_date,
                                        output et_rate1,
                                        output et_rate2,
                                        output mc-error-number)"}
/*L0CT*/                 end.
/*L01W*/              end.  /* if mc-error-number = 0 */

/*L01W*/              if mc-error-number <> 0 then do:
/*L01W*/                 {mfmsg.i mc-error-number 3}
/*L01W*/                 if c-application-mode = 'web':u then return.
/*L01W*/                 else next-prompt et_report_curr with frame a.
/*L01W*/                 undo, retry.
/*L01W*/              end.  /* if mc-error-number <> 0 */
/*L0CT /*L01W*/    end.  /* if et_report_curr <> "" */ */

/*L0CT /*L01W*/    if et_report_curr = "" or et_report_curr = base_curr then */
/*L0CT /*L01W*/       et_report_curr = ac_curr. */
                end.  /* if (c-application-mode <> 'web':u) ... */
             end.  /* loopaa:  do on error undo, retry */


/*L02P*ADD SECTION*/
/*L01W*      {etcurval.i &curr     = "et_report_curr" */
/*L01W*                  &errlevel = "4" */
/*L01W*                  &action   = "next" */
/*L01W*                  &prompt   = "pause" } */
/*L02P*END ADD SECTION*/

             /* SELECT PRINTER */
             /* SS - 20050829 - B */
             /*
             {mfselprt.i "terminal" 80}

             hide frame a.
             */
             /* SS - 20050829 - E */

             /*DISPLAY DETAIL FOR ALL THREE CURRENCIES; BASE ACCOUNT AND */
             /*ENTITY                                                    */
             currloop:
             /* SS - 20050829 - B */
             /*
             repeat curr_ctr = 1 to 3:
             */
             repeat curr_ctr = 1 to 1:
             /* SS - 20050829 - E */

                 /* SS - 20050829 - B */
                 /*
                if c-application-mode <> 'web':u then
                   pause before-hide.
                */
                /* SS - 20050829 - E */

                curr = "".
                if curr_ctr = 1 then do:
                   curr = base_curr.
/*L01W*/           tmp_curr = base_curr.
                end.
                else do:
                   if curr_ctr = 2 and (ac_curr <> base_curr
/*L01W*/           or ac_curr <> et_report_curr)
/*L01W* /*L02P*/   and not et_tk_active */
                   then do:
                      curr = ac_curr.
/*L01W*/              tmp_curr = ac_curr.
                   end.
                   else
                      curr = "".
                end.
/*L01W*/        if curr_ctr = 2 and
/*L0CT /*L01W*/ et_report_curr <> ac_curr then do: */
/*L0CT*/        et_report_curr <> ac_curr and not acct_tagged then do:
/*L01W*/           tmp_curr = et_report_curr.
/*L01W*/           {gprunp.i "mcpl" "p" "mc-get-ex-rate"
                     "(input ac_curr,
                       input et_report_curr,
                       input "" "",
                       input et_eff_date,
                       output et_rate1,
                       output et_rate2,
                       output mc-error-number)"}
/*L01W*/        end.

                if curr <> "" then do:
/*L01W* /*L02P*/   {gprun.i ""etrate.p"" "(curr)"} */

/*L01W* /*L02P*/if not et_tk_active then et_disp_curr = curr.  */
                   /* CALCULATE AND DISPLAY BALANCES */
                    /* SS - 20050829 - B */
                 {gprun.i ""a6glabiqa.p"" "(
                 INPUT acc,
                 INPUT sub,
                 INPUT sub1,
                 INPUT ctr,
                 INPUT ctr1,
                 INPUT entity,
                 INPUT entity1,
                 INPUT eff_dt,
                 INPUT eff_dt1
                 )"}
                    /*
                   {gprun.i ""glabiqa.p""}

                   /*APPLY LAST KEY PRESSED TO TRAP <END>*/
                   if c-application-mode <> 'web':u then do:
                      apply lastkey.
                      if lastkey = keycode("F4") then leave.
                   end.
                   */
                   /* SS - 20050829 - E */
                end.
             end. /*END CURRLOOP*/

             /* SS - 20050829 - B */
             /*
             {mfreset.i}  /*CLOSE OUTPUT*/
             view frame a.
          end.  /* repeat */
          */
          /* SS - 20050829 - E */

          {wbrp04.i &frame-spec = a}
