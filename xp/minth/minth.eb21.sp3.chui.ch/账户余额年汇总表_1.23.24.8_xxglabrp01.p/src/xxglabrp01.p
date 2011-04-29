/* xxglabrp01.p - 按账户,按年,汇总: 年初,年借,年贷,年末                       */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*----rev history--------------------------------------------------------------*/
/* SS - 100602.1  By: Roger Xiao */  /*从bill eb2.sp4版本更新过来*/
/*-Revision end---------------------------------------------------------------*/

{mfdtitle.i "100602.1"}

{xxglabiq01.i "new"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE glabrp_p_2 "Curr"

&SCOPED-DEFINE glabrp_p_6 "Summarize Sub-Accounts"
/* MaxLen: Comment: */

&SCOPED-DEFINE glabrp_p_7 "Summarize Cost Centers"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

          define new shared variable glname like en_name  no-undo.
          define new shared variable per as integer  no-undo.
          define new shared variable per1 as integer  no-undo.
          define new shared variable yr as integer  no-undo.
          define new shared variable begdt like gltr_eff_dt  no-undo.
          define new shared variable begdt1 like gltr_eff_dt  no-undo.
          define new shared variable begdt0 like begdt  no-undo.
          define new shared variable enddt like gltr_eff_dt  no-undo.
          define new shared variable enddt1 like gltr_eff_dt  no-undo.
          define new shared variable enddt0 like enddt  no-undo.
          define new shared variable yr_beg like gltr_eff_dt  no-undo.
          define new shared variable yr_end as date  no-undo.
          define new shared variable acc like ac_code  no-undo.
          define new shared variable acc1 like ac_code  no-undo.
          define new shared variable sub like sb_sub  no-undo.
          define new shared variable sub1 like sb_sub  no-undo.
          define new shared variable ctr like cc_ctr  no-undo.
          define new shared variable ctr1 like cc_ctr  no-undo.
          define new shared variable ccflag like mfc_logical
             label {&glabrp_p_7}  no-undo.
          define new shared variable subflag like mfc_logical
             label {&glabrp_p_6}  no-undo.
          define new shared variable oldacc like ac_code  no-undo.
          define new shared variable entity like gltr_entity  .
          define new shared variable entity1 like gltr_entity  .
          define new shared variable entity0 like gltr_entity  no-undo.
          define new shared variable cname like glname  no-undo.
          define new shared variable ret like ac_code  no-undo.
          define new shared variable disp_curr like gltr_curr
             label {&glabrp_p_2}  no-undo.
          define new shared variable begdtxx as date  no-undo.
          define new shared variable rpt_curr like gltr_curr  no-undo.

          define variable peryr   as   character format "x(8)"  no-undo.
          define variable use_cc  like co_use_cc   no-undo.
          define variable use_sub like co_use_sub  no-undo.

          define variable l_begdt like mfc_logical no-undo.
          define variable l_enddt like mfc_logical no-undo.

          {etvar.i   &new = "new"} /* common euro variables        */
          {etrpvar.i &new = "new"} /* common euro report variables */
          {eteuro.i              } /* some initializations         */

          /* GET NAME OF CURRENT ENTITY */
          for first en_mstr fields( en_domain en_entity en_name en_curr)
              no-lock  where en_mstr.en_domain = global_domain and  en_entity =
              current_entity: end.

          if not available en_mstr then do:
             {mfmsg.i 3059 3} /* NO PRIMARY ENTITY DEFINED */
             if not batchrun then
                if c-application-mode <> 'web':u then
                   pause.
             leave.
          end.
          else do:
             ASSIGN
                glname = en_name.

             release en_mstr.
          end.

          assign
             entity = current_entity
             entity1 = current_entity
             rpt_curr = base_curr
             cname = glname.

          /* SELECT FORM */
          form
             entity   colon 25 entity1 colon 50 label {t001.i}
             cname    colon 25
             acc      colon 25 acc1    colon 50 label {t001.i}
             sub      colon 25 sub1    colon 50 label {t001.i}
             ctr      colon 25 ctr1    colon 50 label {t001.i}
             begdt    colon 25 enddt   colon 50 label {t001.i}
            skip(1)
            /*
            rpt_curr colon 25
            et_report_curr colon 25
            */

          with frame a side-labels attr-space width 80.

          /* SET EXTERNAL LABELS */
          setFrameLabels(frame a:handle).

          /* GET RETAINED EARNINGS ACCOUNT CODE FROM CONTROL FILE */
          for first co_ctrl fields( co_domain co_ret co_use_cc co_use_sub)
              where co_ctrl.co_domain = global_domain no-lock: end.
          if not available co_ctrl then do:
             {mfmsg.i 3032 3} /* CONTROL FILE MUST BE DEFINED BEFORE
                                 RUNNING REPORT */
             if not batchrun then
                if c-application-mode <> 'web':u then
                   pause.
             leave.
          end.
          assign
             ret = co_ret
             use_cc = co_use_cc
             use_sub = co_use_sub.

          release co_ctrl.

{wbrp01.i}
mainloop:
repeat:

        assign
           l_begdt = no
           l_enddt = no.

        if entity1 = hi_char then assign entity1 = "".
        if acc1 = hi_char then assign acc1 = "".
        if sub1 = hi_char then assign sub1 = "".
        if ctr1 = hi_char then assign ctr1 = "".
        display 
           entity entity1 cname 
           acc acc1 
           sub sub1 
           ctr ctr1 
           begdt enddt
        with frame a.

        if c-application-mode <> 'web':u then
           set entity entity1
               acc acc1 
               sub when (use_sub)
               sub1 when (use_sub) 
               ctr when (use_cc) 
               ctr1 when (use_cc)
               begdt enddt 
            with frame a.

           /* VALIDATE INPUT */
           if entity1 = ""  then assign entity1 = hi_char.
           if acc1 = ""     then assign acc1 = hi_char.
           if sub1 = ""     then assign sub1 = hi_char.
           if ctr1 = ""     then assign ctr1 = hi_char.
           if rpt_curr = "" then assign rpt_curr = base_curr.
           if enddt = ?     then assign enddt = if (begdt <> ? and year(begdt) <> year(today)) then date(12,31,year(begdt))
                                                else today . /*报表不是今年开始,就截止当年最后一天*/
           {glper1.i enddt peryr}
           if peryr = "" then do:
              {mfmsg.i 3018 3}
              next-prompt enddt with frame a.
              undo, retry.
           end.

           assign
              yr = glc_year
              per1 = glc_per.

           run validate-input.


           if l_begdt or
              l_enddt
           then do:
                 if l_begdt
                 then
                    next-prompt begdt with frame a.
                 else
                    next-prompt enddt with frame a.
                 undo, retry.
           end. /* IF L_BEGDT OR L_ENDDT */

/*****           
           if et_report_curr <> "" then do:
              {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
                "(input et_report_curr,
                  output mc-error-number)"}
              if mc-error-number = 0
              and et_report_curr <> rpt_curr then do:
                 /* CURRENCIES AND RATES REVERSED BELOW...*/
                 {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
                   "(input et_report_curr,
                     input rpt_curr,
                     input "" "",
                     input et_eff_date,
                     output et_rate2,
                     output et_rate1,
                     output mc-seq,
                     output mc-error-number)"}
              end.  /* if mc-error-number = 0 */

              if mc-error-number <> 0 then do:
                 {mfmsg.i mc-error-number 3}
                 if c-application-mode = 'web':u then return.
                 else next-prompt et_report_curr with frame a.
                 undo, retry.
              end.  /* if mc-error-number <> 0 */
              else if et_report_curr <> rpt_curr then do:
                 /* CURRENCIES AND RATES REVERSED BELOW...*/
                 {gprunp.i "mcui" "p" "mc-ex-rate-output"
                   "(input et_report_curr,
                     input rpt_curr,
                     input et_rate2,
                     input et_rate1,
                     input mc-seq,
                     output mc-exch-line1,
                     output mc-exch-line2)"}
                 {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
                   "(input mc-seq)"}
              end.  /* else do */
           end.  /* if et_report_curr <> "" */
*****/
           if et_report_curr = "" or et_report_curr = rpt_curr then assign
              mc-exch-line1 = ""
              mc-exch-line2 = ""
              et_report_curr = rpt_curr.

        /* select printer */
        {mfselbpr.i "printer" 132}


        for each tta6glabiq:
            delete tta6glabiq.
        end.

        for each ac_mstr
            fields(ac_domain ac_code)
            where ac_domain = global_domain 
            and ac_code >= acc
            and ac_code <= acc1
        no-lock:
            {gprun.i ""xxglabiq01.p"" "(
                input ac_code,
                input sub,
                input sub1,
                input ctr,
                input ctr1,
                input entity,
                input entity1,
                input begdt,
                input enddt,
                input et_report_curr
            )"}
        end.

        PUT UNFORMATTED "#def REPORTPATH=$/Minth/" + SUBSTRING(execname,1,LENGTH(execname) - 2) SKIP.
        PUT UNFORMATTED "#def :end" SKIP.        
        /*export delimiter ";" "acc" "acdesc" "beg" "dr" "cr" "end" "year". */
        for each tta6glabiq:
            define var acdesc like ac_desc no-undo .
            find first ac_mstr where ac_domain = global_domain and ac_code = tta6glabiq_acc no-lock no-error .
            acdesc = if avail ac_mstr then ac_desc else tta6glabiq_acc . 

            export delimiter ";" tta6glabiq_acc acdesc tta6glabiq_beg tta6glabiq_dr tta6glabiq_cr tta6glabiq_end  year(begdt).
        end.


    {mfreset.i}
    {pxmsg.i &MSGNUM=9 &ERRORLEVEL=1}
end.  /*mainloop:*/
{wbrp04.i &frame-spec = a}

procedure validate-input:
    for first glc_cal fields( glc_domain glc_end glc_per glc_start glc_year)
    no-lock  where glc_cal.glc_domain = global_domain and  glc_year = yr
    and glc_per = 1: 
    end.

      if not available glc_cal then do:
         {mfmsg.i 3033 3} /* NO FIRST PERIOD DEFINED FOR THIS FISCAL YEAR. */
         assign
            l_enddt = yes.
         return.
      end.
      if begdt = ? then assign begdt = glc_start.
      display begdt enddt with frame a.
      assign yr_beg = glc_start.
      if begdt < glc_start then do:
         {mfmsg.i 3031 3} /* REPORT CANNOT SPAN FISCAL YEAR */
         assign
            l_enddt = yes.
         return.
      end.
      if begdt > enddt then do:
         {mfmsg.i 27 3} /* INVALID DATE */
         assign
            l_begdt = yes.
         return.
      end.
      {glper1.i begdt peryr}
      if peryr = "" then do:
         {mfmsg.i 3018 3}
         assign
            l_begdt = yes.
         return.
      end.
      assign per = glc_per.

      find last glc_cal  where glc_cal.glc_domain = global_domain and
      glc_year = yr no-lock.
      assign
         yr_end = glc_end
         begdt0 = begdt
         enddt0 = enddt.
end. /* procedure validate-input: */

