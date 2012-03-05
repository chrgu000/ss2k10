/* glpjrpa.p - GENERAL LEDGER PROJECT REPORT (PART II)                  */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert glpjrpa.p (converter v1.00) Fri Oct 10 13:57:44 1997     */
/* web tag in glpjrpa.p (converter v1.00) Mon Oct 06 14:18:19 1997      */
/*F0PN*/ /*K15S*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=Report                                                 */
/* REVISION: 7.0      LAST MODIFIED: 11/18/91   by: jms  *F058*         */
/*                                   07/09/92   by: jms  *F712*         */
/* REVISION: 7.3      LAST MODIFIED: 03/30/93   by: jms  *G884*         */
/*                                   04/27/93   by: skk  *GA51*         */
/*                                   01/13/94   by: bcm  *FL39*         */
/*                                   08/17/94   by: pmf  *FQ24*         */
/* REVISION: 8.6      LAST MODIFIED: 10/23/97   by: ckm  *K15S*         */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 03/25/98   by: rup  *L00M*         */
/* REVISION: 8.6E     LAST MODIFIED: 06/17/98   by: *L01W* Brenda Milton*/

          {mfdeclre.i}
              /* SS - Bill - B 2005.07.07 */
              {a6glpjrp.i}
              /* SS - Bill - E */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE glpjrpa_p_1 "期间活动金额"
/* MaxLen: Comment: */

&SCOPED-DEFINE glpjrpa_p_2 "按项目分页"
/* MaxLen: Comment: */

&SCOPED-DEFINE glpjrpa_p_3 "项目合计"
/* MaxLen: Comment: */

&SCOPED-DEFINE glpjrpa_p_4 "项目      帐户            摘要        "
/* MaxLen: Comment: */

&SCOPED-DEFINE glpjrpa_p_5 "打印说明"
/* MaxLen: Comment: */

&SCOPED-DEFINE glpjrpa_p_6 "汇总成本中心"
/* MaxLen: Comment: */

&SCOPED-DEFINE glpjrpa_p_7 "汇总分帐户"
/* MaxLen: Comment: */

&SCOPED-DEFINE glpjrpa_p_8 "抑制有零余额的帐户"
/* MaxLen: Comment: */

&SCOPED-DEFINE glpjrpa_p_9 "圆整至整数单位"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         {wbrp02.i}


         define shared variable glname      like en_name.
            /* SS - Bill - B 2005.07.07 */
            /*
         define shared variable begdt       like gltr_eff_dt.
         define shared variable enddt       like gltr_eff_dt.
         define shared variable acc         like ac_code.
         define shared variable acc1        like ac_code.
          */
         DEFINE INPUT PARAMETER begdt LIKE gltr_eff_dt.
         DEFINE INPUT PARAMETER enddt LIKE gltr_eff_dt.
         DEFINE INPUT PARAMETER acc LIKE ac_code.
         DEFINE INPUT PARAMETER acc1 LIKE ac_code.
          /* SS - Bill - E */
         define shared variable sub         like sb_sub.
         define shared variable sub1        like sb_sub.
         define shared variable ctr         like cc_ctr.
         define shared variable ctr1        like cc_ctr.
         define shared variable proj_tot    as decimal.
         define shared variable grand_tot   as decimal.
          /* SS - Bill - B 2005.07.07 */
          /*
         define shared variable entity      like en_entity.
         define shared variable entity1     like en_entity.
          */
         DEFINE INPUT PARAMETER entity LIKE en_entity.
         DEFINE INPUT PARAMETER entity1 LIKE en_entity.
          /* SS - Bill - E */
         define shared variable cname       like glname.
         define shared variable prtcents    like mfc_logical
            label {&glpjrpa_p_9}.
         define shared variable prtfmt      as character format "x(30)".
         define shared variable page_break  like mfc_logical initial true
            label {&glpjrpa_p_2}.
         define shared variable show_cmmts  like mfc_logical initial true
            label {&glpjrpa_p_5}.
         define shared variable subflag     like mfc_logical
            label {&glpjrpa_p_7}.
         define shared variable ccflag      like mfc_logical
            label {&glpjrpa_p_6}.
         define shared variable zeroflag    like mfc_logical
            label {&glpjrpa_p_8}.
         define shared variable pj_recno    as recid.

         define variable dt       like gltr_eff_dt.
         define variable dt1      like gltr_eff_dt.
         define variable acc_tot  as decimal.
         define variable account  as character format "x(14)".
         define variable xsub     like sb_sub.
         define variable xcc      like cc_ctr.

         define shared frame phead1.

/*L00M*ADD SECTION*/
         {etvar.i}   /* common euro variables */
         {etrpvar.i} /* common euro report variables */
         define shared variable et_grand_tot like grand_tot.
         define shared variable et_proj_tot  like proj_tot.
         define variable et_acc_tot like acc_tot.
/*L01W*  define shared variable et_show_curr as character format "x(30)". */
/*L00M*END ADD SECTION*/

         /* SS - Bill - B 2005.07.07 */
         /*
         /* REPORT PAGE HEADER FOR SECOND PAGE OF A PROJECT */
         form header
            cname at 1
/*L01W* /*L00M*/ space(2) et_show_curr */
/*L01W*/    mc-curr-label at 27 et_report_curr skip
/*L01W*/    mc-exch-label at 27 mc-exch-line1 skip
/*L01W*/    mc-exch-line2 at 48 skip(1)
            skip
            {&glpjrpa_p_1} at 62
            {&glpjrpa_p_4} at 1
            begdt at 60 "-" enddt  {&glpjrpa_p_3} at 85
            "-------   --------------  ------------------------" at 1
            "--------------------" at 59
            "--------------------" to 99
         with frame phead1 page-top width 132.
         */
         /* SS - Bill - E */

         find pj_mstr where recid(pj_mstr) = pj_recno no-lock.

         /* CALCULATE BALANCE IF BOTH SUB-ACCTS & COST CTRS SUMMARIZED*/
         if ccflag and subflag then do:

            /* DON'T DISPLAY EITHER SUB-ACCOUNT OR COST CENTER */
            /* WHEN BOTH ARE SUMMARIZED                        */
            xsub = "".
            xcc = "".

            for each asc_mstr where asc_acc >= acc and asc_acc <= acc1
            no-lock break by asc_acc
            with frame a width 132:

               if first-of(asc_acc) then find ac_mstr where
               ac_code = asc_mstr.asc_acc no-lock.

               if first-of(asc_acc) then do:
                  {glpjblsc.i &acc=asc_acc &begdt=begdt &enddt=enddt
                              &project=pj_project &balance=acc_tot}
/*L01W* /*L00M*/  {etrpconv.i acc_tot et_acc_tot} */
/*L01W*/          if et_report_curr <> base_curr then do:
/*L01W*/             {gprunp.i "mcpl" "p" "mc-curr-conv"
                       "(input base_curr,
                         input et_report_curr,
                         input et_rate1,
                         input et_rate2,
                         input acc_tot,
                         input true,    /* ROUND */
                         output et_acc_tot,
                         output mc-error-number)"}
/*L01W*/             if mc-error-number <> 0 then do:
/*L01W*/                {mfmsg.i mc-error-number 2}
/*L01W*/             end.
/*L01W*/          end.  /* if et_report_curr <> base_curr */
/*L01W*/          else assign et_acc_tot = acc_tot.

                  if prtcents then acc_tot = round(acc_tot, 0).
/*L00M*/          if prtcents then et_acc_tot = round(et_acc_tot, 0).
                  /* DISPLAY ACCOUNT AND AMOUNTS */
                  if (not zeroflag and (ac_active or
                  acc_tot <> 0)) or
                  (zeroflag and acc_tot <> 0) then do:
                      /* SS - Bill - B 2005.07.07 */
                      /*
                     {glpjrp1.i}
                         */
                      {a6glpjrp1.i}
                         /* SS - Bill - E */
                  end.
               end.  /* if first-of(asc_acc) */
               {mfrpchk.i &warn = "false"}
            end.  /* for each asc_mstr */
         end.  /* if ccflag and subflag */

         /* CALCULATE BALANCE IF SUMMARIZED SUB-ACCOUNTS*/
         else if subflag then do:

            /* DON'T DISPLAY SUB ACCOUNT IF SUMMARIZED */
            xsub = "".

            for each ac_mstr where ac_code >= acc and ac_code <= acc1
            no-lock with frame b width 132:
               for each cc_mstr where cc_ctr >= ctr and cc_ctr <= ctr1 no-lock:

                  xcc = cc_ctr.

                  find first asc_mstr where asc_acc = ac_code and
                  asc_cc = cc_ctr no-lock no-error.
                  if available asc_mstr then do:
                     {glpjbals.i &acc=asc_acc &cc=asc_cc &project=pj_project
                                 &begdt=begdt &enddt=enddt &balance=acc_tot}
/*L01W* /*L00M*/     {etrpconv.i acc_tot et_acc_tot} */
/*L01W*/             if et_report_curr <> base_curr then do:
/*L01W*/                {gprunp.i "mcpl" "p" "mc-curr-conv"
                          "(input base_curr,
                            input et_report_curr,
                            input et_rate1,
                            input et_rate2,
                            input acc_tot,
                            input true,    /* ROUND */
                            output et_acc_tot,
                            output mc-error-number)"}
/*L01W*/                if mc-error-number <> 0 then do:
/*L01W*/                   {mfmsg.i mc-error-number 2}
/*L01W*/                end.
/*L01W*/             end.  /* if et_report_curr <> base_curr */
/*L01W*/             else assign et_acc_tot = acc_tot.

                     if prtcents then acc_tot = round(acc_tot, 0).
/*L00M*/             if prtcents then assign et_acc_tot = round(et_acc_tot, 0).
                     /* DISPLAY ACCOUNT AND AMOUNTS */
                     if (not zeroflag and (ac_active or
                     acc_tot <> 0)) or
                     (zeroflag and acc_tot <> 0) then do:
                         /* SS - Bill - B 2005.07.07 */
                         /*
                        {glpjrp1.i}
                            */
                         {a6glpjrp1.i}
                            /* SS - Bill - E */
                     end.
                  end.  /* if availabel asc_mstr */
                  {mfrpchk.i &warn = "false"}
               end.  /* for each cc_mstr */
               {mfrpchk.i &warn = "false"}
            end.  /* for each ac_mstr */
         end.  /* else if subflag */

         /* CALCULATE BALANCE IF SUMMARIZED COST CENTERS */
         else if ccflag then do:

            /* DON'T DISPLAY COST CENTER IF SUMMARIZED */
            xcc = "".

            for each ac_mstr where ac_code >= acc and ac_code <= acc1
            no-lock with frame c width 132:
               for each sb_mstr where sb_sub >= sub and sb_sub <= sub1 no-lock:

                  xsub = sb_sub.

                  find first asc_mstr where asc_acc = ac_code and
                  asc_sub = sb_sub no-lock no-error.
                  if available asc_mstr then do:
                     {glpjbalc.i &acc=asc_acc &sub=asc_sub &project=pj_project
                                 &begdt=begdt &enddt=enddt &balance=acc_tot}
/*L01W* /*L00M*/     {etrpconv.i acc_tot et_acc_tot} */
/*L01W*/             if et_report_curr <> base_curr then do:
/*L01W*/                {gprunp.i "mcpl" "p" "mc-curr-conv"
                          "(input base_curr,
                            input et_report_curr,
                            input et_rate1,
                            input et_rate2,
                            input acc_tot,
                            input true,    /* ROUND */
                            output et_acc_tot,
                            output mc-error-number)"}
/*L01W*/                if mc-error-number <> 0 then do:
/*L01W*/                   {mfmsg.i mc-error-number 2}
/*L01W*/                end.
/*L01W*/             end.  /* if et_report_curr <> base_curr */
/*L01W*/             else assign et_acc_tot = acc_tot.

                     if prtcents then acc_tot = round(acc_tot, 0).
/*L00M*/             if prtcents then et_acc_tot = round(et_acc_tot, 0).
                     /* DISPLAY ACCOUNT AND AMOUNTS */
                     if (not zeroflag and (ac_active or
                     acc_tot <> 0)) or
                     (zeroflag and acc_tot <> 0) then do:
                         /* SS - Bill - B 2005.07.07 */
                         /*
                        {glpjrp1.i}
                            */
                         {a6glpjrp1.i}
                            /* SS - Bill - E */
                     end.
                  end.  /* if available asc_mstr */
                  {mfrpchk.i &warn = "false"}
               end.  /* for each sb_mstr */
               {mfrpchk.i &warn = "false"}
            end.  /* for each ac_mstr */
         end.  /* else if ccflag */

         else do:

            /* INDIVIDUAL ACCOUNTS (NO SUMMARIZATION) */
            for each ac_mstr where ac_code >= acc and ac_code <= acc1 no-lock
            with frame d width 132:
               if ac_type = "M" or ac_type = "S" then next.
               for each asc_mstr where asc_acc = ac_code and
               asc_sub >= sub and asc_sub <= sub1 and
               asc_cc >= ctr and asc_cc <= ctr1
               no-lock:

                  xsub = asc_sub.
                  xcc = asc_cc.

                  acc_tot = 0.
                  {glpjbal.i &acc=asc_acc &sub=asc_sub &cc=asc_cc
                             &project=pj_project &begdt=begdt &enddt=enddt
                             &balance=acc_tot}
/*L01W* /*L00M*/  {etrpconv.i acc_tot et_acc_tot} */
/*L01W*/          if et_report_curr <> base_curr then do:
/*L01W*/             {gprunp.i "mcpl" "p" "mc-curr-conv"
                       "(input base_curr,
                         input et_report_curr,
                         input et_rate1,
                         input et_rate2,
                         input acc_tot,
                         input true,    /* ROUND */
                         output et_acc_tot,
                         output mc-error-number)"}
/*L01W*/             if mc-error-number <> 0 then do:
/*L01W*/                {mfmsg.i mc-error-number 2}
/*L01W*/             end.
/*L01W*/          end.  /* if et_report_curr <> base_curr */
/*L01W*/          else assign et_acc_tot = acc_tot.

                  if prtcents then acc_tot = round(acc_tot, 0).
/*L00M*/          if prtcents then assign et_acc_tot = round(et_acc_tot, 0).
                  if (not zeroflag and (ac_active or
                  acc_tot <> 0)) or
                  (zeroflag and acc_tot <> 0) then do:
                      /* SS - Bill - B 2005.07.07 */
                      /*
                     {glpjrp1.i}
                         */
                      {a6glpjrp1.i}
                         /* SS - Bill - E */
                  end.
                  {mfrpchk.i &warn = "false"}
               end.  /* for each asc_mstr */
               {mfrpchk.i &warn = "false"}
            end.  /* FOR EACH AC_MSTR */
         end.  /* else do */
         {wbrp04.i}
