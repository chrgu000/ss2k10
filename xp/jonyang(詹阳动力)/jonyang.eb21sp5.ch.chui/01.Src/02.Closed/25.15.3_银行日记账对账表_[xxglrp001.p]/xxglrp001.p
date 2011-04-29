/* xxglrp001.p - GENERAL LEDGER DETAILED ACCOUNT REPORT                       */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 100810.1  By: Roger Xiao */  /*由标准gldabrp.p,新增为对账报表xxglrp001.p,
                                       输出到BI, 
                                       "*仅限AR,AP,JL类型"
                                       如果单据号为空,则本身记录不显示,找gltr_ref对应的其他gltr_line,显示出来(借贷方相反),
                                       */

/*-Revision end---------------------------------------------------------------*/

{mfdtitle.i "100810.1"}
{cxcustom.i "GLDABRP.P"}

define new shared variable first_acct like mfc_logical no-undo.
define new shared variable first_sub  like mfc_logical no-undo.
define new shared variable first_cc   like mfc_logical no-undo.
define new shared variable glname     like en_name no-undo.
define new shared variable per        as integer no-undo.
define new shared variable per1       as integer no-undo.
define new shared variable yr         as integer no-undo.
define new shared variable begdt      like gltr_eff_dt no-undo.
define new shared variable enddt      like gltr_eff_dt no-undo.
define new shared variable yr_beg     like gltr_eff_dt no-undo.
define new shared variable yr_end     as date no-undo.
define new shared variable acc        like ac_code no-undo.
define new shared variable acc1       like ac_code no-undo.
define new shared variable sub        like sb_sub no-undo.
define new shared variable sub1       like sb_sub no-undo.
define new shared variable ctr        like cc_ctr no-undo.
define new shared variable ctr1       like cc_ctr no-undo.
define new shared variable beg_tot    as decimal
                                      format ">>>>>>,>>>,>>9.99cr" no-undo.
define new shared variable per_tot    like beg_tot no-undo.
define new shared variable end_tot    like beg_tot no-undo.
define new shared variable transflag  like mfc_logical initial no no-undo
                                      label "Transaction Totals Only".
define new shared variable rpt_curr   like gltr_curr no-undo.
define new shared variable entity     like gltr_entity no-undo.
define new shared variable entity1    like gltr_entity no-undo.
define new shared variable ret        like ac_code no-undo.
define new shared variable asc_recno  as recid no-undo.
define new shared variable round_cnts like mfc_logical no-undo
                                      label "Round to Nearest Whole Unit".
define new shared variable prtfmt     as character format "x(30)" no-undo.
define new shared variable begdtxx    as date no-undo.
define new shared variable doc_detail like mfc_logical initial yes
                                      label "Print Document Detail" no-undo.
define new shared variable code       like dy_dy_code no-undo.
define new shared variable code1      like dy_dy_code no-undo.
define new shared variable et_beg_tot like beg_tot.
define new shared variable et_per_tot like per_tot.
define new shared variable et_end_tot like end_tot.
define new shared variable daybooks-in-use as logical initial no no-undo.
define new shared variable l_show_hidden like mfc_logical no-undo initial yes
                                       label "Show Non-Selected Transctions".

define variable knt            as integer no-undo.
define variable cname          like glname no-undo.
define variable pl             like co_pl no-undo.
define variable use_cc         like co_use_cc no-undo.
define variable use_sub        like co_use_sub no-undo.
define variable l-return-value as logical.
define variable l_begdt        like mfc_logical no-undo.
define variable l_enddt        like mfc_logical no-undo.
{&GLDABRP-P-TAG22}

{etvar.i   &new = "new"} /* common euro variables        */
{etrpvar.i &new = "new"} /* common euro report variables */
{eteuro.i              } /* some initializations         */

define buffer a1 for ac_mstr.
{&GLDABRP-P-TAG1}

/* GET NAME OF CURRENT ENTITY */
run get-current-entity (output l-return-value).
if l-return-value = false then leave.

/* GET RETAINED EARNINGS CODE FROM CONTROL FILE */
run get-retained-earnings (output l-return-value).
if l-return-value = false then leave.

{&GLDABRP-P-TAG2}
if can-find(first dyd_mstr where dyd_mstr.dyd_domain = global_domain ) then
   assign daybooks-in-use = yes.

/* SS - 100810.1 - B */
acc = "1002" .
ctr = "0000" .
/* SS - 100810.1 - E */

/* SELECT FORM */
{&GLDABRP-P-TAG3}
form
   entity         colon 30 entity1 colon 50 label {t001.i}
   cname          colon 30
   skip(1)
   acc            colon 30 
   sub            colon 30 
   ctr            colon 30 
   begdt          colon 30 enddt   colon 50 label {t001.i} skip
   skip(1)
   rpt_curr       colon 30
   et_report_curr colon 30
   skip(1)

   

/* SS - 100810.1 - B 
   acc1    colon 50 label {t001.i}
   sub1    colon 50 label {t001.i}
   ctr1    colon 50 label {t001.i}

   code           colon 30 code1   colon 50 label {t001.i}
   transflag      colon 30
   round_cnts     colon 30
   doc_detail     colon 30
   skip(1)
   l_show_hidden  colon 35
   SS - 100810.1 - E */
skip(3)
with frame a side-labels attr-space width 80.
{&GLDABRP-P-TAG4}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{&GLDABRP-P-TAG5}
assign
   entity = current_entity
   entity1 = current_entity
   cname = glname.

/* DEFINE PAGE HEADER */
/* RE-ALIGNED HEADERS, DETAILS AND TOTALS TO FIT EXPANDED DOC INFO*/
/* OLD POSITION NUMBERS HAVE BEEN COMMENTED OUT FOR REFERENCE     */
{&GLDABRP-P-TAG6}
{&GLDABRP-P-TAG23}
/* SS - 100810.1 - B 
form header
   cname at 1

   mc-curr-label at 27 et_report_curr skip
   mc-exch-label at 27 mc-exch-line1  skip
   mc-exch-line2 at 49
   skip

   getTermLabelRt("PERIOD_ACTIVITY",20) format "x(20)" to 100
   getTermLabelRt("PERIOD_ACTIVITY",20) format "x(20)" to 123
   getTermLabel("ACCOUNT",25)           format "x(25)" at 1
   getTermLabel("DESCRIPTION",20)       format "x(20)" at 27
   getTermLabelRt("DEBITS",20)          format "x(20)" to 95
   getTermLabelRt("CREDITS",20)         format "x(20)" to 119

   "-----------------------  ------------------------" at 1
   "-------------------" to 102
   "------------------" to 124
with frame phead1 page-top width 132.
   SS - 100810.1 - E */

{&GLDABRP-P-TAG24}
{&GLDABRP-P-TAG7}

{wbrp01.i}

/* REPORT BLOCK */
repeat:

   assign
      l_begdt = no
      l_enddt = no.

   /* INPUT OPTIONS */
   if entity1 = hi_char then assign entity1 = "".
   if acc1 = hi_char then assign acc1 = "".
   if sub1 = hi_char then assign sub1 = "".
   if ctr1 = hi_char then assign ctr1 = "".
   if code1 = hi_char then assign code1 = "".

   display
      entity entity1 cname
      acc 
      sub 
      ctr 
      begdt enddt
      rpt_curr
      et_report_curr

/* SS - 100810.1 - B 
    acc1 
    sub1 
    ctr1 
      transflag
      round_cnts
      doc_detail
      l_show_hidden
   SS - 100810.1 - E */
   with frame a.
   {&GLDABRP-P-TAG8}

   if c-application-mode <> 'web' then
   {&GLDABRP-P-TAG9}
      set
         entity 
         entity1 
         cname
         acc 
         sub  when (use_sub)
         ctr  when (use_cc)
         /*      
         acc1
         sub1 when (use_sub)
         ctr1 when (use_cc)
         */  
         begdt
         enddt
         rpt_curr
         et_report_curr
/* SS - 100810.1 - B 
         code
         code1
         transflag
        round_cnts
         doc_detail
         l_show_hidden
   SS - 100810.1 - E */
   with frame a.

/* SS - 100810.1 - B 
   {wbrp06.i &command = set &fields = "  entity entity1 cname
        acc acc1
        sub when ( use_sub )  sub1 when ( use_sub )
        ctr when ( use_cc )   ctr1 when ( use_cc )
        begdt enddt
        code  code1 transflag rpt_curr round_cnts  doc_detail
        et_report_curr
        l_show_hidden
        " &frm = "a"}
   SS - 100810.1 - E */
/* SS - 100810.1 - B */
   {wbrp06.i &command = set &fields = "  entity entity1 cname
        acc 
        sub when ( use_sub )  
        ctr when ( use_cc )   
        begdt enddt
        rpt_curr et_report_curr
        " &frm = "a"}
/* SS - 100810.1 - E */

   {&GLDABRP-P-TAG10}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      /* VALIDATE INPUT */
      if entity1 = "" then assign entity1 = hi_char.
/* SS - 100810.1 - B 
      if acc1 = "" then assign acc1 = hi_char.
      if sub1 = "" then assign sub1 = hi_char.
      if ctr1 = "" then assign ctr1 = hi_char.
   SS - 100810.1 - E */
/* SS - 100810.1 - B */
      acc1 = acc.
      sub1 = sub.
      ctr1 = ctr.
/* SS - 100810.1 - E */

      if code1 = "" then assign code1 = hi_char.
      if rpt_curr = "" then assign rpt_curr = base_curr.

      {&GLDABRP-P-TAG11}
      run validate-input.
      {&GLDABRP-P-TAG12}

      /* TO AVOID SCOPING PROBLEM OF INTERNAL PROCEDURE */
      /* VALIDATE-INPUT SO THAT CONTROL WOULD BE PLACED */
      /* ON THE RESPECTIVE FROM OR TO DATE FIELDS WHEN  */
      /* ERROR IS RECEIVED AND HENCE AVOID TO GENERATE  */
      /* REPORT WITH ERRONEOUS SELECTION CRITERIA       */

      if l_begdt or
         l_enddt
      then do:
         if c-application-mode = 'web' then return.
         else do:
            if l_begdt
            then
               next-prompt begdt with frame a.
            else
               next-prompt enddt with frame a.
            undo, retry.
         end. /* ELSE IF C-APPLICATION-MODE */
      end. /* IF L_BEGDT OR L_ENDDT */

      /* CREATE BATCH INPUT STRING */

      run create-batch-input-string.

   end.  /* if (c-application-mode <> 'web') ... */

   if et_report_curr <> "" then do:
      {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
         "(input et_report_curr,
           output mc-error-number)"}

      if mc-error-number = 0
         and et_report_curr <> rpt_curr then do:

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
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
         if c-application-mode = 'web' then return.
         else next-prompt et_report_curr with frame a.
         undo, retry.
      end.  /* if mc-error-number <> 0 */
      else if et_report_curr <> rpt_curr then do:

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
      end.
   end.  /* if et_report_curr <> "" */
   if et_report_curr = "" or et_report_curr = rpt_curr then
      assign
         mc-exch-line1 = ""
         mc-exch-line2 = ""
         et_report_curr = rpt_curr.

   if can-find (first glt_det
       where glt_det.glt_domain = global_domain and  glt_entity >= entity and
            glt_entity <= entity1 and
            glt_acc >= acc and glt_acc <= acc1 and
            glt_sub >= sub and glt_sub <= sub1 and
            glt_cc >= ctr and glt_cc <= ctr1 and
            glt_effdate >= begdt and
            glt_effdate <= enddt)
   then do:
      /* UNPOSTED TRANSACTIONS EXIST FOR RANGES ON THIS REPORT */
      {pxmsg.i &MSGNUM=3151 &ERRORLEVEL=2}
   end.


   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
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
/* SS - 100810.1 - B 
   {mfphead.i}

   view frame phead1.
   SS - 100810.1 - E */
PUT UNFORMATTED "#def REPORTPATH=$/QAD Addons/BI Report/xxglrp001" SKIP.
PUT UNFORMATTED "#def :end" SKIP.


   /* SET PRINT FORMAT */
   prtfmt = ">>>>>>,>>>,>>9.99cr".
   if round_cnts then prtfmt = ">>>>>,>>>,>>>,>>9cr".

   {&GLDABRP-P-TAG25}
   /* CYCLE THROUGH ACCOUNT FILE */
   assign
      beg_tot    = 0
      end_tot    = 0
      per_tot    = 0
      et_beg_tot = 0
      et_end_tot = 0
      et_per_tot = 0
      begdtxx    = begdt - 1.

   loopa:
   for each asc_mstr
      fields( asc_domain asc_acc asc_sub asc_cc)
       where asc_mstr.asc_domain = global_domain and  asc_acc >= acc  and
            asc_acc <= acc1 and
            asc_sub >= sub  and
            asc_sub <= sub1 and
            asc_cc >= ctr   and
            asc_cc <= ctr1  and
            asc_acc <> pl
      no-lock
         break by asc_acc by asc_sub by asc_cc
      with frame b width 132:

      if first-of(asc_acc) then first_acct = yes.
      else first_acct = no.
      if first-of(asc_sub) then first_sub = yes.
      else first_sub = no.
      if first-of(asc_cc) then first_cc = yes.
      else first_cc = no.
      /*!
      if daybooks are being used and the user entered some criteria
      in the daybook code range then we want to check if there are
      any transactions within the given daybook range for this account
      if there are not then go to the next account
      */
      if daybooks-in-use and
         not l_show_hidden and
         (code <> "" or code1 <> hi_char) then
         if not can-find(first gltr_hist  where gltr_hist.gltr_domain =
         global_domain and
            gltr_acc      = asc_acc and
            gltr_sub      = asc_sub and
            gltr_ctr      = asc_cc  and
            gltr_entity  >= entity  and
            gltr_entity  <= entity1 and
            gltr_dy_code >= code    and
            gltr_dy_code <= code1   and
            gltr_eff_dt  >= begdt   and
            gltr_eff_dt  <= enddt)
         then next loopa.

      for first ac_mstr fields( ac_domain ac_curr ac_code)
      no-lock  where ac_mstr.ac_domain = global_domain and  ac_code = asc_acc:
      end.
      if rpt_curr = base_curr or ac_curr = rpt_curr then do:
         asc_recno = recid(asc_mstr).
         {gprun.i ""xxgldabrpax.p""}
      end.

      {mfrpchk.i}
   end.

   /* PRINT TOTALS */

/* SS - 100810.1 - B 
   {&GLDABRP-P-TAG26}
   put {gplblfmt.i
          &FUNC=getTermLabel(""CURRENCY"",15)
          &CONCAT = "':'"
        } et_report_curr to 60 skip

      {gplblfmt.i
         &FUNC=getTermLabel(""TOTAL_BEGINNING_BALANCE"",35)
         &CONCAT = "':'"
      } string(et_beg_tot, prtfmt) format "x(20)" to 63 skip

      {gplblfmt.i
         &FUNC=getTermLabel(""TOTAL_ACTIVITY_TO_DATE"",35)
         &CONCAT = "':'"
      } string(et_per_tot, prtfmt) format "x(20)" to 63 skip

      {gplblfmt.i
         &FUNC=getTermLabel(""TOTAL_ENDING_BALANCE"",35)
         &CONCAT = "':'"
      } string(et_end_tot, prtfmt) format "x(20)" to 63 skip.

   {&GLDABRP-P-TAG27}
   {&GLDABRP-P-TAG20}

   if et_report_curr <> rpt_curr then do:
      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input rpt_curr,
           input et_report_curr,
           input et_rate1,
           input et_rate2,
           input beg_tot,
           input true,   
           output beg_tot,
           output mc-error-number)"}
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.

      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input rpt_curr,
           input et_report_curr,
           input et_rate1,
           input et_rate2,
           input per_tot,
           input true,    
           output per_tot,
           output mc-error-number)"}
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.

      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input rpt_curr,
           input et_report_curr,
           input et_rate1,
           input et_rate2,
           input end_tot,
           input true,    
           output end_tot,
           output mc-error-number)"}
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.
   end.   

   {&GLDABRP-P-TAG21}

   if (beg_tot <> et_beg_tot or
       per_tot <> et_per_tot or
       end_tot <> et_end_tot) and
      et_show_diff           and
      not round_cnts
   then do:
      put
         et_diff_txt to 61
         string(et_beg_tot - beg_tot, prtfmt) format "x(20)" to 63
         skip
         string(et_per_tot - per_tot, prtfmt) format "x(20)" to 63
         skip
         string(et_end_tot - end_tot, prtfmt) format "x(20)" to 63
         skip.
   end.
   SS - 100810.1 - E */



/* {mfrtrail.i}  REPORT TRAILER  */
{mfreset.i}

end.

{wbrp04.i &frame-spec = a}

PROCEDURE create-batch-input-string:

   assign bcdparm = "".
   {mfquoter.i entity   }
   {mfquoter.i entity1  }
   {mfquoter.i cname    }
   {mfquoter.i acc      }
   {mfquoter.i acc1     }
   if use_sub then do:
      {mfquoter.i sub   }
      {mfquoter.i sub1  }
   end.
   if use_cc then do:
      {mfquoter.i ctr   }
      {mfquoter.i ctr1  }
   end.
   {mfquoter.i begdt    }
   {mfquoter.i enddt    }
   {mfquoter.i rpt_curr }
   {mfquoter.i et_report_curr}

/* SS - 100810.1 - B 
   {mfquoter.i code     }
   {mfquoter.i code1    }
   {mfquoter.i transflag}
   {mfquoter.i round_cnts}
   {&GLDABRP-P-TAG13}
   {mfquoter.i doc_detail}
   {mfquoter.i l_show_hidden}
   SS - 100810.1 - E */

   {&GLDABRP-P-TAG14}

END PROCEDURE.

PROCEDURE get-current-entity:
   define output parameter l-return-value as logical.

   l-return-value = true.
   for first en_mstr fields( en_domain en_name en_entity)
   no-lock  where en_mstr.en_domain = global_domain and  en_entity =
   current_entity:
   end.
   if not available en_mstr then do:
      {pxmsg.i &MSGNUM=3059 &ERRORLEVEL=3} /* NO PRIMARY ENTITY DEFINED */
      if not batchrun then
         if c-application-mode <> 'web' then
            pause.
      l-return-value = false.
      return.
   end.
   else do:
      glname = en_name.
      release en_mstr.
   end.
END PROCEDURE. /* get-current-entity */

PROCEDURE get-retained-earnings:
   define output parameter l-return-value as logical.

   l-return-value = true.
   for first co_ctrl
      fields( co_domain co_pl co_ret co_use_cc co_use_sub)
    where co_ctrl.co_domain = global_domain no-lock:
   end.
   if not available co_ctrl then do:
      /* CONTROL FILE MUST BE DEFINED BEFORE RUNNING REPORT */
      {pxmsg.i &MSGNUM=3032 &ERRORLEVEL=3}
      if not batchrun then
         if c-application-mode <> 'web' then
            pause.
      l-return-value = false.
      return.
   end.
   assign
      pl       = co_pl
      ret      = co_ret
      use_cc   = co_use_cc
      use_sub  = co_use_sub
      rpt_curr = base_curr.

   release co_ctrl.
END PROCEDURE. /* get-retained-earinings */

PROCEDURE validate-input:
   define variable begdt0         as date no-undo.
   define variable enddt0         as date no-undo.
   define variable peryr          as character format "x(8)" no-undo.

   if enddt = ? then enddt = today.
   display enddt with frame a.
   {glper1.i enddt peryr}
   if peryr = "" then do:
      {pxmsg.i &MSGNUM=3018 &ERRORLEVEL=3}
      {&GLDABRP-P-TAG15}
      l_enddt = yes.
      return.

   end.
   assign
      yr = glc_year
      per1 = glc_per.

   for first glc_cal
      fields( glc_domain glc_end glc_per glc_start glc_year)
       where glc_cal.glc_domain = global_domain and  glc_year = yr and glc_per
       = 1
   no-lock:
   end.
   if not available glc_cal then do:
      /* NO FIRST PERIOD DEFINED FOR THIS FISCAL YEAR. */
      {pxmsg.i &MSGNUM=3033 &ERRORLEVEL=3}
      {&GLDABRP-P-TAG16}
      l_enddt = yes.
      return.

   end.
   if begdt = ? then begdt = glc_start.
   display begdt with frame a.
   yr_beg = glc_start.
   if begdt < glc_start then do:
      {pxmsg.i &MSGNUM=3031 &ERRORLEVEL=3} /* REPORT CANNOT SPAN FISCAL YEAR */
      {&GLDABRP-P-TAG17}
      l_enddt = yes.
      return.

   end.
   if begdt > enddt then do:
      {pxmsg.i &MSGNUM=27 &ERRORLEVEL=3} /* INVALID DATE */
      {&GLDABRP-P-TAG18}
      l_begdt = yes.
      return.

   end.
   {glper1.i begdt peryr}
   if peryr = "" then do:
      {pxmsg.i &MSGNUM=3018 &ERRORLEVEL=3}
      {&GLDABRP-P-TAG19}
      l_begdt = yes.
      return.

   end.
   per = glc_per.
   find last glc_cal  where glc_cal.glc_domain = global_domain and  glc_year =
   yr no-lock.
   assign
      yr_end = glc_end
      begdt0 = begdt
      enddt0 = enddt.
end.
