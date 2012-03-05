/* glpjrp1a.p - GENERAL LEDGER PROJECT REPORT Sub-program               */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Report                                        */
/* REVISION: 8.6            Created: 10/23/97   by: ckm  *K15S*         */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 03/26/98   by: rup *L00M*          */
/* REVISION: 8.6E     LAST MODIFIED: 06/17/98   by: *L01W* Brenda Milton*/

            {mfdeclre.i}
                /* SS - Bill - B 2005.07.07 */
                {a6glpjrp.i}
                /* SS - Bill - E */

       /* ********** Begin Translatable Strings Definitions ********* */

       &SCOPED-DEFINE glpjrp1a_p_1 "抑制有零余额的帐户"
       /* MaxLen: Comment: */

       &SCOPED-DEFINE glpjrp1a_p_2 "圆整至整数单位"
/* MaxLen: Comment: */

&SCOPED-DEFINE glpjrp1a_p_3 "汇总成本中心"
/* MaxLen: Comment: */

&SCOPED-DEFINE glpjrp1a_p_4 "汇总分帐户"
/* MaxLen: Comment: */

&SCOPED-DEFINE glpjrp1a_p_5 "类型："
/* MaxLen: Comment: */

&SCOPED-DEFINE glpjrp1a_p_6 "警告:  "
/* MaxLen: Comment: */

&SCOPED-DEFINE glpjrp1a_p_7 "  完成日期:"
/* MaxLen: Comment: */

&SCOPED-DEFINE glpjrp1a_p_8 "实际完成日期:"
/* MaxLen: Comment: */

&SCOPED-DEFINE glpjrp1a_p_9 "打印说明"
/* MaxLen: Comment: */

&SCOPED-DEFINE glpjrp1a_p_10 "语言:"
/* MaxLen: Comment: */

&SCOPED-DEFINE glpjrp1a_p_11 "  开始日期:"
/* MaxLen: Comment: */

&SCOPED-DEFINE glpjrp1a_p_12 "按项目分页"
/* MaxLen: Comment: */

&SCOPED-DEFINE glpjrp1a_p_13 "描述："
/* MaxLen: Comment: */

&SCOPED-DEFINE glpjrp1a_p_14 "项目      帐户            摘要        "
/* MaxLen: Comment: */

&SCOPED-DEFINE glpjrp1a_p_15 "项目:"
/* MaxLen: Comment: */

&SCOPED-DEFINE glpjrp1a_p_16 "项目合计"
/* MaxLen: Comment: */

&SCOPED-DEFINE glpjrp1a_p_17 "页号:"
/* MaxLen: Comment: */

&SCOPED-DEFINE glpjrp1a_p_18 "期间活动金额"
/* MaxLen: Comment: */

&SCOPED-DEFINE glpjrp1a_p_19 "          帐户            摘要       "
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

          {wbrp02.i}

          define shared variable glname like en_name.
            /* SS - Bill - B 2005.07.07 */
            /*
          define shared variable begdt like gltr_eff_dt.
          define shared variable enddt like gltr_eff_dt.
          define shared variable acc like ac_code.
          define shared variable acc1 like ac_code.
          */
         DEFINE INPUT PARAMETER begdt LIKE gltr_eff_dt.
         DEFINE INPUT PARAMETER enddt LIKE gltr_eff_dt.
         DEFINE INPUT PARAMETER acc LIKE ac_code.
         DEFINE INPUT PARAMETER acc1 LIKE ac_code.
          /* SS - Bill - E */
          define shared variable sub like sb_sub.
          define shared variable sub1 like sb_sub.
          define shared variable ctr like cc_ctr.
          define shared variable ctr1 like cc_ctr.
          define shared variable proj_tot as decimal.
          define shared variable grand_tot as decimal.
          /* SS - Bill - B 2005.07.07 */
          /*
          define shared variable entity like en_entity.
          define shared variable entity1 like en_entity.
          */
         DEFINE INPUT PARAMETER entity LIKE en_entity.
         DEFINE INPUT PARAMETER entity1 LIKE en_entity.
          /* SS - Bill - E */
          define shared variable cname like glname.
          define shared variable prtcents like mfc_logical
             label {&glpjrp1a_p_2}.
          define shared variable prtfmt as character format "x(30)".
          define shared variable page_break like mfc_logical initial true
             label {&glpjrp1a_p_12}.
          define shared variable show_cmmts like mfc_logical initial true
             label {&glpjrp1a_p_9}.
          define shared variable subflag like mfc_logical
             label {&glpjrp1a_p_4}.
          define shared variable ccflag like mfc_logical
             label {&glpjrp1a_p_3}.
          define shared variable zeroflag like mfc_logical
             label {&glpjrp1a_p_1}.
          define shared variable pj_recno as recid.
          define shared variable proj like gltr_project.
          define shared variable proj1 like gltr_project.
          define shared variable projfound like mfc_logical.
          define shared variable unposted_flag like mfc_logical.
          define variable i as integer.

          define new shared frame phead1.

/*L00M*/  {etvar.i}   /* common euro variables */
/*L00M*/  {etrpvar.i} /* common euro report variables */
/*L01W* /*L00M*/ define shared variable et_show_curr as character */
/*L01W* /*L00M*/ format "x(30)". */
/*L00M*/  define shared variable et_grand_tot like grand_tot.
/*L00M*/  define shared variable et_proj_tot like proj_tot.



/* SS - Bill - B 2005.07.07 */
/*
          /* REPORT PAGE HEADER FOR SECOND PAGE OF A PROJECT */
          form header
             cname at 1
/*L01W* /*L00M*/ space(2) et_show_curr */
/*L01W*/     mc-curr-label at 27 et_report_curr skip
/*L01W*/     mc-exch-label at 27 mc-exch-line1 skip
/*L01W*/     mc-exch-line2 at 48 skip(1)
             skip
             {&glpjrp1a_p_18} at 62
             {&glpjrp1a_p_14} at 1
             begdt at 60 "-" enddt  {&glpjrp1a_p_16} at 85
             "-------   --------------  ------------------------" at 1
             "--------------------" at 59
             "--------------------" to 99
          with frame phead1 page-top width 132.

          /* HEADER FOR FIRST PAGE OF A PROJECT */
          form header
             {&glpjrp1a_p_18} at 62
             {&glpjrp1a_p_19} at 1
             begdt at 60 "-" enddt  {&glpjrp1a_p_16} at 85
             "          --------------  ------------------------" at 1
             "--------------------" at 59
             "--------------------" to 99
          with frame pjhead width 132.
          */
          /* SS - Bill - E */

          /* SET FORMAT FOR AMOUNTS */
          if not prtcents then prtfmt = ">>>,>>>,>>>,>>9.99cr".
          else prtfmt = ">>,>>>,>>>,>>>,>>9cr".

          /* CYCLE THROUGH FILES */
/*L00M*/  assign et_grand_tot = 0
                 grand_tot = 0.
          for each pj_mstr where pj_project >= proj and
          pj_project <= proj1 no-lock
          break by pj_project:
              /* SS - Bill - B 2005.07.07 */
              /*
             hide frame phead1.
             if page-size - line-counter < 7 then page.
             */
             /* SS - Bill - E */
/*L00M*/     assign et_proj_tot = 0
                    proj_tot = 0.
             pj_recno = recid(pj_mstr).
             /* SS - Bill - B 2005.07.07 */
             /*
             if line-counter < 5 then put skip cname at 1
/*L01W* /*L00M*/space(2) et_show_curr */
/*L01W*/        mc-curr-label at 27 et_report_curr skip
/*L01W*/        mc-exch-label at 27 mc-exch-line1 skip
/*L01W*/        mc-exch-line2 at 48
                skip(1).
             */
             /* SS - Bill - E */

             /* CHECK FOR ANY ACTIVITY FOR THE PROJECT */
             projfound = yes.
             find first gltr_hist where gltr_entity  >= entity     and
                                        gltr_entity  <= entity1    and
                                        gltr_acc     >= acc        and
                                        gltr_acc     <= acc1       and
                                        gltr_sub     >= sub        and
                                        gltr_sub     <= sub1       and
                                        gltr_ctr     >= ctr        and
                                        gltr_ctr     <= ctr1       and
                                        gltr_project  = pj_project and
                                        gltr_eff_dt  >= begdt      and
                                        gltr_eff_dt  <= enddt
                 /* SS - Bill - B 2005.07.08 */
                 USE-INDEX gltr_ind1
                 /* SS - Bill - E */
             no-lock no-error.
             /* SS - Bill - B 2005.07.07 */
             /*
             if available gltr_hist then do:
                put {&glpjrp1a_p_15} space(1) pj_project space(2)
                    {&glpjrp1a_p_13} space(1) pj_desc space(4)
                    {&glpjrp1a_p_11} space(1) pj_beg_dt space(2)
                    {&glpjrp1a_p_7} space(1).
                if pj_revfin <> ? then put pj_revfin
/*L00M*/           at 97.
                else put pj_findate
/*L00M*/           at 97.
                put
/*L00M*/           skip
                   space(2) {&glpjrp1a_p_8} space(1) pj_comp skip.

                /*PRINT COMMENTS */
                if show_cmmts then do:
                   for each cmt_det no-lock where cmt_indx = pj_cmtindx:
                      put space(5) {&glpjrp1a_p_5} space(1) cmt_type space(2)
                          {&glpjrp1a_p_10} space(1) cmt_lang space(2)
                          {&glpjrp1a_p_17} space(1) cmt_seq skip.
                      do i = 1 to 15:
                         if cmt_cmmt[i] > "" then
                            put space(5) cmt_cmmt[i] skip.
                      end.
                      {mfrpchk.i &warn=false}
                   end.
                end.
                view frame pjhead.
                display "".
             end. /* IF AVAILABLE GLTR_HIST */
             else projfound = no.
                  */
             IF NOT AVAILABLE gltr_hist THEN
                 projfound = NO.
                  /* SS - Bill - E */

             /* CHECK FOR UNPOSTED TRANSACTIONS */
             find first glt_det where glt_entity >= entity and
                                      glt_entity <= entity1 and
                                      glt_acc >= acc and glt_acc <= acc1 and
                                      glt_sub >= sub and glt_sub <= sub1 and
                                      glt_cc >= ctr and glt_cc <= ctr1 
                 /* SS - Bill - B 2005.07.08 */
                 AND glt_effdate >= begdt 
                 AND glt_effdate <= enddt 
                 AND glt_project = pj_project 
                 USE-INDEX glt_index
                 /* SS - Bill - E */
                 no-lock no-error.
             if available glt_det then do:
                if not unposted_flag then do:
                   {mfmsg.i 3151 2} /* UNPOSTED TRANSACTIONS EXIST FOR
                                       RANGES ON THIS REPORT */
                   unposted_flag = yes.
                end.
                else do:
                   find msg_mstr where msg_nbr  = 3151 and
                   msg_lang = global_user_lang no-lock no-error.
                   if available msg_mstr then put {&glpjrp1a_p_6}
                      caps(msg_desc) format "x(64)".
                end.
             end.

             if projfound = yes then do:

                 /* SS - Bill - B 2005.07.07 */
                 {gprun.i ""a6glpjrpa.p""
                    "(input begdt,
                    INPUT enddt,
                    INPUT acc,
                    INPUT acc1,
                    INPUT entity,
                    INPUT entity1)"
                    }

                {mfrpchk.i}
                     /*
                hide frame pjhead.
                {gprun.i ""glpjrpa.p""}

                {mfrpchk.i}
                /* PRINT PROJECT TOTAL */
                if page-size - line-counter < 2 then page.
                put "--------------------" to 78 skip
/*L00M              string(proj_tot, prtfmt) */
/*L00M*/            string(et_proj_tot, prtfmt)
                    format "x(20)" to 99 skip(1).
                if page_break then do:   /* START NEXT PROJECT ON NEW PAGE */
                   if last(pj_project) then do:
                      view frame phead1.
                      page.
                   end.
                   else page.
                end.
                */
                /* SS - Bill - E */
             end. /* IF PROJFOUND = YES */

             {mfrpchk.i}
          end.  /* FOR EACH PJ_MSTR */

             /* SS - Bill - B 2005.07.07 */
             /*
          /* PRINT TOTALS */
          if page-size - line-counter < 2 then page.
          put "--------------------" to 99
/*L00M        string(grand_tot, prtfmt) */
/*L00M*/      string(et_grand_tot, prtfmt)
              format "x(20)" to 99.
/*L00M*ADD SECTION*/
/*L01W*   {etrpconv.i grand_tot grand_tot} */
          */
          /* SS - Bill - E */

/*L01W*/  if et_report_curr <> base_curr then do:
/*L01W*/     {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input base_curr,
                 input et_report_curr,
                 input et_rate1,
                 input et_rate2,
                 input grand_tot,
                 input true,    /* ROUND */
                 output grand_tot,
                 output mc-error-number)"}
/*L01W*/      if mc-error-number <> 0 then do:
/*L01W*/         {mfmsg.i mc-error-number 2}
/*L01W*/      end.
/*L01W*/   end.  /* if et_report_curr <> base_curr */

/* SS - Bill - B 2005.07.07 */
/*
           if (grand_tot <> et_grand_tot) and et_show_diff
           and not prtcents
           then
              put et_diff_txt to 72
                  string((et_grand_tot - grand_tot),prtfmt)
                  format "x(20)" to 99.
/*L00M*END ADD SECTION*/

           put     "====================" to 99.
           hide frame phead1.
           */
           /* SS - Bill - E */


           {wbrp04.i}
