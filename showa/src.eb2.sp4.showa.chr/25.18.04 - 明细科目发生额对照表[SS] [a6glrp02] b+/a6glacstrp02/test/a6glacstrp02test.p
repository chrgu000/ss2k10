/* glacstrp.p - GL Statement Of Accounts                                    */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.10.3.1 $ */
/* Revision: 1.9  BY: Chris Green  DATE: 04/04/02 ECO: *N1B3*               */
/* Revision: 1.10 BY: Patrick de Jong  DATE: 05/31/02 ECO: *P07H*           */
/* $Revision: 1.10.3.1 $ BY: Veena Lad  DATE: 07/29/03 ECO: *P0YR*        */
/* $Revision: 1.10.3.1 $ BY: Bill Jiang  DATE: 04/19/06 ECO: *SS - 20060419.1*        */
/*V8:ConvertMode=Report                                                     */

/* SS - 20060419.1 - B */
{a6glacstrp02.i "new"}
/* SS - 20060419.1 - E */

{mfdtitle.i "2+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE glacstrp_p_1  "Summary/Detail"
/* MaxLen: 33 Comment: */

&SCOPED-DEFINE glacstrp_p_2  "Show Currency"
/* MaxLen: 33 Comment: */

&SCOPED-DEFINE glacstrp_p_3  "Include Memo Accounts"
/* MaxLen: 33 Comment: */

&SCOPED-DEFINE glacstrp_p_4  "Include Statistical Accounts"
/* MaxLen: 33 Comment: */

&SCOPED-DEFINE glacstrp_p_5  "Show Transaction Description"
/* MaxLen: 33 Comment: */

&SCOPED-DEFINE glacstrp_p_6  "Balances from Previous Year"
/* MaxLen: 33 Comment: */

&SCOPED-DEFINE glacstrp_p_7  "Summarize Sub-Accounts"
/* MaxLen: Comment: */

&SCOPED-DEFINE glacstrp_p_8  "Summarize Cost Centers"
/* MaxLen: Comment: */

&SCOPED-DEFINE glacstrp_p_9  "Document"
/* MaxLen: 28 Comment: */

&SCOPED-DEFINE glacstrp_p_10 "Bk"
/* MaxLen:  2 Comment: */

&SCOPED-DEFINE glacstrp_p_11 "Cf"
/* MaxLen:  4 Comment: */

&SCOPED-DEFINE glacstrp_p_12 "Eff Date!Batch"
/* MaxLen: 8 Comment: */

&SCOPED-DEFINE glacstrp_p_13 "Customer!Supplier"
/* MaxLen:  8 Comment: */

&SCOPED-DEFINE glacstrp_p_14 "Debit Amount"
/* MaxLen: 18 Comment: */

&SCOPED-DEFINE glacstrp_p_15 "Credit Amount"
/* MaxLen: 18 Comment: */

/* ********** End Translatable Strings Definitions ********* */

define variable entity       like si_entity           no-undo.
define variable entity1      like si_entity           no-undo.
define variable acc          like gltr_acc            no-undo.
define variable acc1         like gltr_acc            no-undo.
define variable begdt        like gltr_eff_dt         no-undo.
define variable enddt        like gltr_eff_dt         no-undo.
define variable summary      like mfc_logical         label {&glacstrp_p_1}
        initial false                         no-undo.
define variable subflag      like mfc_logical label {&glacstrp_p_7} no-undo.
define variable ccflag       like mfc_logical label {&glacstrp_p_8} no-undo.
define variable trn_desc     like mfc_logical         label {&glacstrp_p_5}
        initial true                          no-undo.
define variable disp_curr    like mfc_logical         label {&glacstrp_p_2}
        initial true                          no-undo.
define variable incl_accm    like mfc_logical         label {&glacstrp_p_3}
        initial false                         no-undo.
define variable incl_accs    like mfc_logical         label {&glacstrp_p_4}
        initial false                         no-undo.
define variable prev_yr_bal  like mfc_logical         label {&glacstrp_p_6}
        initial false                         no-undo.
define variable doc          as character format  "x(28)"              no-undo.
define variable bank         as character format  "x(2)"               no-undo.
define variable ckfrm        as character format  "x(2)"               no-undo.
define variable cr_amt       as decimal   format  "->>,>>>,>>>,>>9.99" no-undo.
define variable dr_amt       as decimal   format  "->>,>>>,>>>,>>9.99" no-undo.
define variable base_fmt     as character initial "->>,>>>,>>>,>>9.99" no-undo.
define variable yr           as integer                                no-undo.
define variable peryr        as character format "x(8)"                no-undo.
define variable yr_beg       like gltr_eff_dt                          no-undo.
define variable yr_end       as date                                   no-undo.
define variable rpt_curr     like gltr_hist.gltr_curr                  no-undo.
define variable beg_tot      as decimal   format ">>>>>>,>>>,>>9.99cr" no-undo.
define variable end_tot      like beg_tot                              no-undo.
define variable begdtxx      as date                                   no-undo.
define variable beg_bal      as decimal   format "->>,>>>,>>>,>>9.99"  no-undo.
define variable amt          like beg_bal                              no-undo.
define variable amt_solde    as decimal   format "->>,>>>,>>>,>>9.99"  no-undo.
define variable acc_dr_amt   as decimal   format  "->>,>>>,>>>,>>9.99" no-undo.
define variable acc_cr_amt   as decimal   format  "->>,>>>,>>>,>>9.99" no-undo.
define variable dt           as date                                   no-undo.
define variable dt1          as date                                   no-undo.
define variable knt          as integer                                no-undo.
define variable ret          like ac_code                              no-undo.
define variable gldesc       as character format "x(50)"               no-undo.

{gprunpdf.i "mcpl" "p"}

form entity      colon 25
     entity1     colon 47 label {t001.i}
     acc         colon 25
     acc1        colon 47 label {t001.i}
     begdt       colon 25 label "Effective Date"
     enddt       colon 47 label {t001.i}
     summary     colon 35
     subflag     colon 35
     ccflag      colon 35
     trn_desc    colon 35
     disp_curr   colon 35
     incl_accs   colon 35
     incl_accm   colon 35
     prev_yr_bal colon 35
with frame a no-underline attr-space with side-labels width 80.
setFrameLabels(frame a:handle).
form
  gltr_acc
  gltr_sub
  gltr_ctr
  gltr_ref
  doc                    column-label {&glacstrp_p_9}
  bank                   column-label {&glacstrp_p_10}
  ckfrm                  column-label {&glacstrp_p_11}
  gltr_eff_dt            column-label {&glacstrp_p_12}
  gltr_addr              column-label {&glacstrp_p_13}
  dr_amt                 column-label {&glacstrp_p_14}
  cr_amt                 column-label {&glacstrp_p_15}
with down frame b width 132 no-box.
setFrameLabels(frame b:handle).

{wbrp01.i &io-frame = "a"}
for first gl_ctrl fields(gl_rnd_mthd gl_entity) no-lock: end.
{gprun.i ""gpcurfmt.p"" "(input-output base_fmt,input gl_rnd_mthd)"}
assign dr_amt:format in frame b = base_fmt
       cr_amt:format in frame b = base_fmt
       entity1                  = gl_entity
       entity                   = gl_entity.

repeat on error undo, retry with frame a:

  if entity1  = hi_char  then entity1  = "".
  if acc1     = hi_char  then acc1     = "".
  if begdt    = low_date then begdt    = ?.
  if enddt    = low_date then begdt    = ?.
  display entity      entity1
          acc         acc1
          begdt       enddt
          summary
          subflag
          ccflag
          trn_desc
          disp_curr
          incl_accs
          incl_accm
          prev_yr_bal with frame a.
  if c-application-mode <> "WEB" then
  set     entity      entity1
          acc         acc1
          begdt       enddt
          summary
          subflag
          ccflag
          trn_desc
          disp_curr
          incl_accs
          incl_accm
          prev_yr_bal with frame a.
  {wbrp06.i &command = set
            &fields  = "entity      entity1
                        acc         acc1
                        begdt       enddt
                        summary
                        subflag
                        ccflag
                        trn_desc
                        disp_curr
                        incl_accs
                        incl_accm
                        prev_yr_bal"
            &frm     = "a"}
  if entity1  = "" then entity1  = hi_char.
  if acc1     = "" then acc1     = hi_char.
  /* LOGIC TAKEN FROM GLDABRPA.P */
  if enddt = ? then enddt = today.
  display enddt with frame a.
  {glper1.i enddt peryr}
  if peryr = "" then do:
     /* DATE NOT WITHIN A VALID PERIOD */
     {pxmsg.i &MSGNUM=3018 &ERRORLEVEL=3}
     if c-application-mode = "WEB" then return.
     else
     next-prompt enddt with frame a.
     undo, retry.
  end.
  yr = glc_year.
  for first glc_cal fields(glc_year glc_per glc_start) no-lock
  where glc_year = yr and glc_per = 1:
  end.
  if not available glc_cal then do:
     /* NO FIRST PERIOD DEFINED FOR THIS FISCAL YEAR. */
     {pxmsg.i &MSGNUM=3033 &ERRORLEVEL=3}
     undo, retry.
  end.
  if begdt = ? then begdt = glc_start.
  display begdt with frame a.
  yr_beg = glc_start.
  if begdt < glc_start then do:
     /* REPORT CANNOT SPAN FISCAL YEAR */
     {pxmsg.i &MSGNUM=3031 &ERRORLEVEL=3}
     undo, retry.
  end.
  if begdt > enddt then do:
     /* INVALID DATE */
     {pxmsg.i &MSGNUM=27 &ERRORLEVEL=3}
     undo, retry.
  end.
  {glper1.i begdt peryr}
  if peryr = "" then do:
     /* DATE NOT WITHIN A VALID PERIOD */
     {pxmsg.i &MSGNUM=3018 &ERRORLEVEL=3}
     if c-application-mode = "WEB" then return.
     else
     next-prompt begdt with frame a.
     undo, retry.
  end.
  for last glc_cal fields(glc_year glc_end) no-lock
  where glc_year = yr:
  end.
  assign yr_end   = glc_end
         rpt_curr = base_curr.

  bcdparm = "".
  {mfquoter.i entity     }
  {mfquoter.i entity1    }
  {mfquoter.i acc        }
  {mfquoter.i acc1       }
  {mfquoter.i begdt      }
  {mfquoter.i enddt      }
  {mfquoter.i trn_desc   }
  {mfquoter.i disp_curr  }
  {mfquoter.i incl_accs  }
  {mfquoter.i incl_accm  }
  {mfquoter.i prev_yr_bal}
  {mfquoter.i subflag    }
  {mfquoter.i ccflag     }

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
              /* SS - 20060419.1 - B */
     /*
  {mfphead.i}

  for each ac_mstr no-lock where ac_code >= acc and ac_code <= acc1:

      if (ac_mstr.ac_type = "s" and not incl_accs) or
         (ac_mstr.ac_type = "m" and not incl_accm)
      then next.
      assign beg_tot = 0
             end_tot = 0.
      for first gltr_hist fields(gltr_eff_dt gltr_entity gltr_acc) no-lock
      where gltr_eff_dt >= begdt
        and gltr_eff_dt <= enddt
        and gltr_entity >= entity
        and gltr_entity <= entity1
        and gltr_acc     = ac_code:
      end.
      if not available gltr_hist then next.
      for each asc_mstr where asc_acc = ac_code no-lock break by asc_acc
      with frame b width 132:
          if first-of(asc_acc) then assign beg_bal = 0.
          /* CALCULATE BEGINNING BALANCE */
          begdtxx = begdt - 1.
          run proc_beg_balance.
          beg_bal = beg_bal + amt.
          if last-of(asc_acc) then amt_solde = beg_bal.
      end. /*END FOR LOOP asc_mstr*/
      assign acc_dr_amt = 0
             acc_cr_amt = 0.
      display ac_code                          @ gltr_acc
              ac_desc                          @ doc
              getTermLabelRt("OPENING", 7)     @ gltr_eff_dt
              getTermLabel("BALANCE", 7) + ":" @ gltr_addr
              amt_solde                        @ dr_amt
      with frame b.
      down 1 with frame b.
      if summary then do:
         if subflag and ccflag then.
         else do:
            if subflag then
               {glacstr1.i &sort1="gltr_ctr" &sort2="gltr_ctr"}
            else if ccflag then
               {glacstr1.i &sort1="gltr_sub" &sort2="gltr_sub"}
            else
               {glacstr1.i &sort1="gltr_sub" &sort2="gltr_ctr"}
            down 1 with frame b.
            next.
         end.
      end.
      else
         run ip_detail.
      if summary or (subflag = false and ccflag = false) then
      for each gltr_hist no-lock
      where gltr_eff_dt >= begdt
        and gltr_eff_dt <= enddt
        and gltr_entity >= entity
        and gltr_entity <= entity1
        and gltr_acc     = ac_code
        and gltr_amt    <> 0
      use-index gltr_eff_dt with frame cc width 132 down no-labels:
          if (gltr_hist.gltr_amt >= 0 and
              gltr_hist.gltr_correction = false) or
             (gltr_hist.gltr_amt <  0 and
              gltr_hist.gltr_correction = true)
          then
             assign dr_amt = gltr_amt
                    cr_amt = 0.
          else
             assign cr_amt = - gltr_amt
                    dr_amt = 0.
          run ip_print_detail(dr_amt, cr_amt, yes, yes).
      end. /*END FOR LOOP gltr_hist*/
      if acc_dr_amt <> 0 or acc_cr_amt <> 0 or amt_solde <> 0 then do:
         if not summary then do:
            underline dr_amt cr_amt with frame b.
            down 1 with frame b.
         end.
         display getTermLabelRt("PERIOD", 6) @ gltr_eff_dt
                 getTermLabel("ACTIVITY", 8) @ gltr_addr
                 acc_dr_amt                  @ dr_amt
                 acc_cr_amt                  @ cr_amt
         with frame b.
         down 1 with frame b.
         if not summary then do:
            underline dr_amt cr_amt with frame b.
            down 1 with frame b.
         end.
         display getTermLabelRt("CLOSING", 7)     @ gltr_eff_dt
                 getTermLabel("BALANCE", 7) + ":" @ gltr_addr
                 amt_solde                        @ dr_amt
         with frame b.
         down 1 with frame b.
      end.
      assign amt_solde = 0.
      if line-counter >= (page-size - 2) then
         page.
      else
         down 2 with frame b.

  end. /*END FOR LOOP Ac_mstr*/

  {mfrtrail.i}
  /* Process complete */
  {pxmsg.i &MSGNUM=1107 &ERRORLEVEL=1}
     */
     PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.
         
      FOR EACH tta6glacstrp02:
         DELETE tta6glacstrp02.
      END.
      
      {gprun.i ""a6glacstrp02.p"" "(
         input entity,
         input entity1,
         input acc,
         input acc1,
         input begdt,
         input enddt,
         input summary,
         input subflag,
         input ccflag,
         input trn_desc,
         input disp_curr,
         input incl_accs,
         input incl_accm,
         input prev_yr_bal
         )"}
      
      EXPORT DELIMITER ";" "acc" "ref" "doc" "bank" "ckfrm" "addr" "eff_dt" "beg_amt" "dr_amt" "cr_amt" "batch" "sub" "ctr" "gldesc" "curr" "curramt".
      FOR EACH tta6glacstrp02:
         EXPORT DELIMITER ";" tta6glacstrp02.
      END.
      
      PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.
      
      {a6mfrtrail.i}
     /* SS - 20060419.1 - E */

end. /*END REPEAT LOOP*/

PROCEDURE proc_bank_and_paymthd:
  assign bank  = ""
         ckfrm = "".
  if gltr_hist.gltr_tr_type eq "AR" and
    (gltr_hist.gltr_doc_typ eq "P" or
     gltr_hist.gltr_doc_typ eq "D")
  then do:
     for first ar_mstr fields(ar_nbr ar_bank ar_pay_method) no-lock
     where ar_nbr = gltr_hist.gltr_doc:
     end.
     if available ar_mstr then
        assign bank  = ar_mstr.ar_bank
               ckfrm = ar_mstr.ar_pay_method.
  end.
  else if gltr_hist.gltr_tr_type eq "AP" and
          gltr_hist.gltr_doc_typ eq "CK" then do:
     assign bank = substring(gltr_hist.gltr_doc, 1, 2).
     for first ap_mstr fields(ap_type ap_ref ap_ckfrm) no-lock
     where ap_type = gltr_tr_type and ap_ref = gltr_hist.gltr_doc:
     end.
     if available ap_mstr then ckfrm = ap_ckfrm.
  end.
  else if gltr_hist.gltr_tr_type  eq "JL" then
     assign bank = substring(gltr_hist.gltr_batch,3,2).
END PROCEDURE. /* proc_bank_and_paymthd */

PROCEDURE proc_doc_ref:
  assign doc = "".
  if gltr_hist.gltr_tr_type = "IC" then do:
     for first tr_hist
        fields(tr_trnbr tr_lot)
        where tr_trnbr = integer(gltr_hist.gltr_doc)
        no-lock:
     end. /* FOR FIRST tr_hist */
     if available tr_hist then doc = tr_lot.
  end.
  else if gltr_hist.gltr_tr_type = "WO" then do:
     for first opgl_det fields(opgl_gl_ref opgl_trnbr) no-lock
     where opgl_gl_ref = gltr_hist.gltr_ref:
     end.
     if available opgl_det then
     for op_hist fields(op_trnbr op_wo_lot) no-lock
     where op_trnbr = opgl_trnbr:
     end.
     if available op_hist then doc = op_wo_lot.
  end.
  else if gltr_hist.gltr_tr_type = "AR" and
          gltr_hist.gltr_doc_typ = "P" then
     doc = substr(gltr_hist.gltr_doc,9,8).
  else if gltr_hist.gltr_tr_type = "AP" and
          gltr_hist.gltr_doc_typ = "CK" then
     doc = substr(gltr_hist.gltr_doc,3,8).
  else doc = gltr_doc.
END PROCEDURE. /* proc_doc_ref */

PROCEDURE proc_beg_balance:
  if (lookup(ac_mstr.ac_type, "A,L") <> 0) or
     (prev_yr_bal and lookup(ac_mstr.ac_type, "S,M") <> 0)
  then do:
     {glacbal1.i &acc=asc_mstr.asc_acc &sub=asc_mstr.asc_sub
                 &cc=asc_mstr.asc_cc &begdt=low_date &enddt=begdtxx
                 &balance=amt &yrend=yr_end &rptcurr=rpt_curr
                 &accurr=ac_mstr.ac_curr}
  end.
  else do:
     {glacbal1.i &acc=asc_mstr.asc_acc &sub=asc_mstr.asc_sub
                 &cc=asc_mstr.asc_cc &begdt=yr_beg &enddt=begdtxx
                 &balance=amt &yrend=yr_end &rptcurr=rpt_curr
                 &accurr=ac_mstr.ac_curr}
  end. /*prev_yr_bal = yes*/
END PROCEDURE. /* proc_beg_balance */

PROCEDURE proc_get_gl_desc:
  assign gldesc = "".
  if (gltr_hist.gltr_tr_type = "JL" or
      gltr_hist.gltr_tr_type = "RV" or
      gltr_hist.gltr_tr_type = "RA" or
      gltr_hist.gltr_tr_type = "YA")
      then gldesc = if gltr_desc = "" then gltr_user1
                    else (gltr_desc + " " + gltr_user1).
  else
  if gltr_hist.gltr_tr_type = "IC" then do:
      for first tr_hist
         fields(tr_trnbr tr_type)
         where tr_trnbr = integer(gltr_doc)
         no-lock:
      end. /* FOR FIRST tr_hist */
      if available tr_hist and
         (tr_type = "RCT-PO" or tr_type = "ISS-PRV")
         then do:
              if gltr_user1 <> "" then gldesc = gltr_user1.
              else gldesc = gltr_desc.
         end.
         else gldesc = gltr_desc.
  end.
  else
  if gltr_hist.gltr_tr_type = "AP" and
     gltr_hist.gltr_doc_typ = "VO" then do:
     gldesc = getTermLabel("VOUCHER", 35).
     for first txrd_det fields(txrd_tran_type txrd_ref txrd_code) no-lock
     where txrd_tran_type = "VO" and txrd_ref = gltr_doc:
     end.
     if available txr_mstr then do:
        for first atd_mstr fields(atd_code atd_desc) no-lock
        where atd_code = txrd_code:
        end.
        if available atd_mstr then gldesc = atd_desc.
     end.
  end.
  else
  if gltr_hist.gltr_tr_type = "AP" and gltr_hist.gltr_doc_typ = "CK" then do:
     gldesc = gltr_desc.
  end.
  else
  if gltr_hist.gltr_tr_type = "SO" then do:
     gldesc = getTermLabel("INVOICE",7) + "/" + getTermLabel("CREDIT",6)
            + " " + getTermLabel("NOTE",4).
     for first txrd_det fields(txrd_tran_type txrd_ref txrd_code) no-lock
     where txrd_tran_type = "IV" and txrd_ref = gltr_doc:
     end.
     if available txr_mstr then do:
        for first atd_mstr fields(atd_code atd_desc) no-lock
        where atd_code = txrd_code:
        end.
        if available atd_mstr then gldesc = atd_desc.
     end.
  end.
  else
  if gltr_hist.gltr_tr_type = "AR" and gltr_hist.gltr_doc_typ = "M" then do:
     gldesc = getTermLabel("INVOICE",7) + "/" + getTermLabel("CREDIT",6)
            + " " + getTermLabel("NOTE",4).
     for first txrd_det fields(txrd_tran_type txrd_ref txrd_code) no-lock
     where txrd_tran_type = "AR" and txrd_ref = gltr_doc:
     end.
     if available txr_mstr then do:
        for first atd_mstr fields(atd_code atd_desc) no-lock
        where atd_code = txrd_code:
        end.
        if available atd_mstr then gldesc = atd_desc.
     end.
  end.
  else
  if gltr_hist.gltr_tr_type = "AR" and
  (gltr_doc_typ = "P" or gltr_doc_typ = "D") then do:
      gldesc = gltr_desc.
  end.
  else gldesc = gltr_desc.
END PROCEDURE. /* proc_get_gl_desc */

PROCEDURE ip_print_detail:
  define input parameter ip_dr_amt like dr_amt                       no-undo.
  define input parameter ip_cr_amt like cr_amt                       no-undo.
  define input parameter ip_sub like mfc_logical                     no-undo.
  define input parameter ip_cc like mfc_logical                      no-undo.

  define variable curr_fmt as character initial "->>,>>>,>>>,>>9.99" no-undo.
  define variable curr_old like curr_fmt                             no-undo.
  define variable curr_amt like dr_amt                               no-undo.
  define variable rndmthd like gl_rnd_mthd                           no-undo.
  define variable mc-error-number like msg_nbr                       no-undo.

  if line-counter = 1 then do:
     display gltr_hist.gltr_acc
             ac_mstr.ac_desc  @ doc
             getTermLabelRt("OPENING", 7) @ gltr_eff_dt
             getTermLabel("BALANCE", 7) + ":" @ gltr_addr
             amt_solde @ dr_amt
     with frame b.
     down 1 with frame b.
  end.
  if not summary then do:
     run proc_bank_and_paymthd.
     run proc_doc_ref.
     run proc_get_gl_desc.
     display gltr_hist.gltr_sub when (ip_sub)
             gltr_ctr  when (ip_cc)
             gltr_ref
             doc
             bank
             ckfrm
             gltr_addr
             gltr_eff_dt
             ip_dr_amt  @ dr_amt
             ip_cr_amt  @ cr_amt
     with frame b.
     down with frame b.
     display gltr_batch @ gltr_eff_dt with frame b.
     if trn_desc and gldesc <> "" then
     display gldesc @ doc with frame b.
     if disp_curr   and
        gltr_hist.gltr_curr <> base_curr and
        gltr_hist.gltr_curramt <> 0      then do:
        assign curr_fmt = curr_old
               curr_amt = gltr_curramt.
        {gprunp.i "mcpl" "p" "mc-get-rnd-mthd" "(input  gltr_curr,
             output rndmthd, output mc-error-number)"}
        if mc-error-number <> 0 then rndmthd = gl_ctrl.gl_rnd_mthd.
        {gprun.i ""gpcurfmt.p"" "(input-output curr_fmt, input rndmthd)"}
        dr_amt:format in frame b = curr_fmt.
        display gltr_curr @ gltr_addr
                curr_amt  @ dr_amt
        with frame b.
        dr_amt:format in frame b = base_fmt.
     end.
     if ((trn_desc  and gldesc <> "") or (disp_curr and
       gltr_hist.gltr_curr <> base_curr and
          gltr_hist.gltr_curramt <> 0) or gltr_batch <> "")
     then down with frame b.
  end. /*IF BLOCK CASE: NOT SUMMARY*/
  assign amt_solde  = amt_solde  + ip_dr_amt - ip_cr_amt
         acc_dr_amt = acc_dr_amt + ip_dr_amt
         acc_cr_amt = acc_cr_amt + ip_cr_amt.
  if line-counter >= (page-size - 2) then page.
  {mfrpexit.i}
END PROCEDURE. /* ip_print_detail */

PROCEDURE ip_print_summary:
  define input parameter ip_level  as   integer no-undo.
  define input parameter ip_dr_amt like dr_amt  no-undo.
  define input parameter ip_cr_amt like cr_amt  no-undo.

  if summary = false then return.
  if (ip_level = 1 or ccflag) and gltr_hist.gltr_sub <> "" then do:
     for first sb_mstr fields (sb_desc) where sb_sub = gltr_sub no-lock:
     end.
     display gltr_sub "*" + sb_desc @ doc with frame b.
     if ip_level = 1 then
        down 1 with frame b.
  end. /* sub descrp printed */
  else
  if ccflag = false and gltr_ctr <> "" then do:
     for first cc_mstr fields (cc_desc cc_ctr)
         where cc_ctr = gltr_ctr no-lock: end.
     display gltr_ctr
             (if subflag then "*" else "**") + cc_desc @ doc
     with frame b.
  end. /* cc descrp printed */
  if ip_level = 2 then do:
     display getTermLabelRt("PERIOD", 6) @ gltr_eff_dt
             getTermLabel("ACTIVITY", 8) @ gltr_addr
             ip_dr_amt                   @ dr_amt
             ip_cr_amt                   @ cr_amt
     with frame b.
     down 1 with frame b.
     display getTermLabelRt("CLOSING", 7)      @ gltr_eff_dt
             getTermLabel("BALANCE", 7) + ":"  @ gltr_addr
             amt_solde + ip_dr_amt - ip_cr_amt @ dr_amt
     with frame b.
     down 1 with frame b.
  end.
END PROCEDURE. /* ip_print_summary */

PROCEDURE ip_detail:
  if subflag and ccflag then do:
     {glacstr1.i &sort0 = "by gltr_eff_dt" &sort1 = "gltr_ref"
                 &sort2="gltr_ref"}
  end.
  else
  if subflag then do:
     {glacstr1.i &sort0 = "by gltr_eff_dt" &sort1 = "gltr_ref"
                 &sort2="gltr_ctr"}
  end.
  else if ccflag then do:
     {glacstr1.i &sort0 = "by gltr_eff_dt" &sort1 = "gltr_ref"
                 &sort2="gltr_sub"}
  end.
END PROCEDURE. /* ip_detail */
