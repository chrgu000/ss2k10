/* glacstrp.p - GL Statement Of Accounts                                    */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.16 $                                                        */
/* Revision: 1.9     BY: Chris Green        DATE: 04/04/02 ECO: *N1B3*      */
/* Revision: 1.10    BY: Patrick de Jong    DATE: 05/31/02 ECO: *P07H*      */
/* Revision: 1.12    BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D*      */
/* Revision: 1.13    BY: Veena Lad          DATE: 07/31/03 ECO: *P0YR*      */
/* Revision: 1.14    BY: Katie Hilbert      DATE: 07/29/03 ECO: *P15Z*      */
/* Revision: 1.15    BY: Ed van de Gevel DATE: 04/16/04 ECO: *P1XX* */
/* $Revision: 1.16 $ BY: Abhishek Jha  DATE: 06/28/05 ECO: *P3R4* */
/* $Revision: 1.16 $ BY: Bill Jiang  DATE: 04/10/07 ECO: *SS - 20070410.1* */
/*-Revision end---------------------------------------------------------------*/

/*V8:ConvertMode=Report                                                     */

/* SS - 20070410.1 - B */
/* 
1. 包括了期间活动为0的记录 
2. 仅前六个参数经过了测试
*/
define input parameter i_entity       like si_entity           no-undo.
define input parameter i_entity1      like si_entity           no-undo.
define input parameter i_acc          like gltr_acc            no-undo.
define input parameter i_acc1         like gltr_acc            no-undo.
define input parameter i_sub          like gltr_sub            no-undo.
define input parameter i_sub1         like gltr_sub            no-undo.
define input parameter i_ctr          like gltr_ctr            no-undo.
define input parameter i_ctr1         like gltr_ctr            no-undo.
define input parameter i_begdt        like gltr_eff_dt         no-undo.
define input parameter i_enddt        like gltr_eff_dt         no-undo.
define input parameter i_summary      like mfc_logical         no-undo.
define input parameter i_subflag      like mfc_logical no-undo.
define input parameter i_ccflag       like mfc_logical no-undo.
define input parameter i_trn_desc     like mfc_logical         no-undo.
define input parameter i_disp_curr    like mfc_logical         no-undo.
define input parameter i_incl_accs    like mfc_logical         no-undo.
define input parameter i_incl_accm    like mfc_logical         no-undo.
define input parameter i_prev_yr_bal  like mfc_logical         no-undo.

{a6glacstrp01.i}

/*
{mfdtitle.i "1+ "}
*/
{a6mfdtitle.i "1+ "}
/* SS - 20070410.1 - E */
{cxcustom.i "GLACSTRP.P"}

define variable entity       like si_entity           no-undo.
define variable entity1      like si_entity           no-undo.
define variable acc          like gltr_acc            no-undo.
define variable acc1         like gltr_acc            no-undo.
/* SS - 20070410.1 - B */
define variable sub          like gltr_sub            no-undo.
define variable sub1         like gltr_sub            no-undo.
define variable ctr          like gltr_ctr            no-undo.
define variable ctr1         like gltr_ctr            no-undo.
/* SS - 20070410.1 - E */
define variable begdt        like gltr_eff_dt         no-undo.
define variable enddt        like gltr_eff_dt         no-undo.
define variable summary      like mfc_logical
                             format "Summary/Detail"
                             label "Summary/Detail"
                             initial false                  no-undo.
define variable subflag      like mfc_logical
                             label "Summarize Sub-Accounts" no-undo.
define variable ccflag       like mfc_logical
                             label "Summarize Cost Centers" no-undo.
define variable trn_desc     like mfc_logical
                             label "Show Transaction Description"
                             initial true                   no-undo.
define variable disp_curr    like mfc_logical
                             label "Show Currency"
                             initial true                   no-undo.
define variable incl_accm    like mfc_logical
                             label "Include Memo Accounts"
                             initial false                  no-undo.
define variable incl_accs    like mfc_logical
                             label "Include Statistical Accounts"
                             initial false                  no-undo.
define variable prev_yr_bal  like mfc_logical
                             label "Balances from Previous Year"
                             initial false                  no-undo.
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
{&GLACSTRP-P-TAG4}

{gprunpdf.i "mcpl" "p"}

form entity      colon 25
     entity1     colon 47 label "To"
     acc         colon 25
     acc1        colon 47 label "To"
   /* SS - 20070410.1 - B */
   sub         colon 25
   sub1        colon 47 label "To"
   ctr         colon 25
   ctr1        colon 47 label "To"
   /* SS - 20070410.1 - E */
     begdt       colon 25 label "Effective Date"
     enddt       colon 47 label "To"
     summary     colon 35
     subflag     colon 35
     ccflag      colon 35
     trn_desc    colon 35
     disp_curr   colon 35
     incl_accs   colon 35
     incl_accm   colon 35
     prev_yr_bal colon 35
with frame a no-underline attr-space with side-labels width 80.

/* SS - 20070410.1 - B */
/*
setFrameLabels(frame a:handle).
*/
/* SS - 20070410.1 - E */

form
  gltr_acc
  gltr_sub
  gltr_ctr
  gltr_ref
  doc                    column-label "Document"
  bank                   column-label "Bk"
  ckfrm                  column-label "Cf"
  gltr_eff_dt            column-label "Eff Date!Batch"
  gltr_addr              column-label "Customer!Supplier"
  dr_amt                 column-label "Debit Amount"
  cr_amt                 column-label "Credit Amount"
with down frame b width 132 no-box.

/* SS - 20070410.1 - B */
/*
setFrameLabels(frame b:handle).
*/
ASSIGN
   entity = i_entity
   entity1 = i_entity1
   acc = i_acc
   acc1 = i_acc1
   sub = i_sub
   sub1 = i_sub1
   ctr = i_ctr
   ctr1 = i_ctr1
   begdt = i_begdt
   enddt = i_enddt
   SUMMARY = i_summary
   subflag = i_subflag
   ccflag = i_ccflag
   trn_desc = i_trn_desc
   DISP_curr = i_disp_curr
   incl_accs = i_incl_accs
   incl_accm = i_incl_accm
   PREV_yr_bal = i_prev_yr_bal
   .
/* SS - 20070410.1 - E */

{wbrp01.i &io-frame = "a"}
/* SS - 20070410.1 - B */
/*
for first gl_ctrl fields (gl_domain gl_rnd_mthd gl_entity)
   where gl_ctrl.gl_domain = global_domain
no-lock: end.
{gprun.i ""gpcurfmt.p"" "(input-output base_fmt,input gl_rnd_mthd)"}
assign dr_amt:format in frame b = base_fmt
       cr_amt:format in frame b = base_fmt
       entity1                  = gl_entity
       entity                   = gl_entity.

repeat on error undo, retry with frame a:
*/
/* SS - 20070410.1 - E */

  if entity1  = hi_char  then entity1  = "".
  if acc1     = hi_char  then acc1     = "".
  /* SS - 20070410.1 - B */
  if sub1     = hi_char  then sub1     = "".
  if ctr1     = hi_char  then ctr1     = "".
  /* SS - 20070410.1 - E */
  if begdt    = low_date then begdt    = ?.
  if enddt    = low_date then begdt    = ?.

  /* SS - 20070410.1 - B */
  /*
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
     set
          entity      entity1
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
  */
  /* SS - 20070410.1 - E */
  if entity1  = "" then entity1  = hi_char.
  if acc1     = "" then acc1     = hi_char.
  /* SS - 20070410.1 - B */
  if sub1     = "" then sub1     = hi_char.
  if ctr1     = "" then ctr1     = hi_char.
  /* SS - 20070410.1 - E */
  /* LOGIC TAKEN FROM GLDABRPA.P */
  if enddt = ? then enddt = today.
  /* SS - 20070410.1 - B */
  /*
  display enddt with frame a.
  */
  /* SS - 20070410.1 - E */
  {glper1.i enddt peryr}
  /* SS - 20070410.1 - B */
  /*
  if peryr = "" then do:
     /* DATE NOT WITHIN A VALID PERIOD */
     {pxmsg.i &MSGNUM=3018 &ERRORLEVEL=3}
     if c-application-mode = "WEB" then return.
     else
     next-prompt enddt with frame a.
     undo, retry.
  end.
  */
  /* SS - 20070410.1 - E */
  yr = glc_year.
  for first glc_cal
     fields (glc_domain glc_year glc_per glc_start)
     where glc_domain = global_domain
      and  glc_year = yr
      and  glc_per = 1
  no-lock:
  end.
  /* SS - 20070410.1 - B */
  /*
  if not available glc_cal then do:
     /* NO FIRST PERIOD DEFINED FOR THIS FISCAL YEAR. */
     {pxmsg.i &MSGNUM=3033 &ERRORLEVEL=3}
     undo, retry.
  end.
  */
  /* SS - 20070410.1 - E */
  if begdt = ? then begdt = glc_start.
  /* SS - 20070410.1 - B */
  /*
  display begdt with frame a.
  */
  /* SS - 20070410.1 - E */
  yr_beg = glc_start.
  /* SS - 20070410.1 - B */
  /*
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
  */
  /* SS - 20070410.1 - E */
  {glper1.i begdt peryr}
  /* SS - 20070410.1 - B */
  /*
  if peryr = "" then do:
     /* DATE NOT WITHIN A VALID PERIOD */
     {pxmsg.i &MSGNUM=3018 &ERRORLEVEL=3}
     if c-application-mode = "WEB" then return.
     else
     next-prompt begdt with frame a.
     undo, retry.
  end.
  */
  /* SS - 20070410.1 - E */
  for last glc_cal fields( glc_domain glc_year glc_end)
     where glc_domain = global_domain
       and glc_year = yr
  no-lock:
  end.
  assign yr_end   = glc_end
         rpt_curr = base_curr.

  bcdparm = "".
  {mfquoter.i entity     }
  {mfquoter.i entity1    }
  {mfquoter.i acc        }
  {mfquoter.i acc1       }
     /* SS - 20070410.1 - B */
     {mfquoter.i sub        }
     {mfquoter.i sub1       }
     {mfquoter.i ctr        }
     {mfquoter.i ctr1       }
     /* SS - 20070410.1 - E */
  {mfquoter.i begdt      }
  {mfquoter.i enddt      }
  {mfquoter.i trn_desc   }
  {mfquoter.i disp_curr  }
  {mfquoter.i incl_accs  }
  {mfquoter.i incl_accm  }
  {mfquoter.i prev_yr_bal}
  {mfquoter.i subflag    }
  {mfquoter.i ccflag     }

  /* SS - 20070410.1 - B */
  /*
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
  {mfphead.i}
  */
  /* SS - 20070410.1 - E */

  for each ac_mstr
     where ac_domain = global_domain
       and ac_code >= acc and ac_code <= acc1
  no-lock:

      if (ac_mstr.ac_type = "s" and not incl_accs) or
         (ac_mstr.ac_type = "m" and not incl_accm)
      then next.
      assign beg_tot = 0
             end_tot = 0.
      for first gltr_hist
         fields( gltr_domain gltr_eff_dt gltr_entity gltr_acc)
      no-lock
         where gltr_domain  = global_domain
          and  gltr_eff_dt >= begdt
          and  gltr_eff_dt <= enddt
          and  gltr_entity >= entity
          and  gltr_entity <= entity1
          and  gltr_acc     = ac_code
         /* SS - 20070410.1 - B */
         AND gltr_sub >= sub
         AND gltr_sub <= sub1
         AND gltr_ctr >= ctr
         AND gltr_ctr >= ctr1
         /* SS - 20070410.1 - E */
         :
      end.
      {&GLACSTRP-P-TAG5}
      {&GLACSTRP-P-TAG1}
      /* SS - 20070410.1 - B */
      /* 包括期间活动为0的记录 */
      /* 
      if not available gltr_hist then next.
      */
      /* SS - 20070410.1 - E */
      {&GLACSTRP-P-TAG2}
      for each asc_mstr
         where asc_domain = global_domain
          and  asc_acc = ac_code
      no-lock break by asc_acc
      with frame b width 132:
          if first-of(asc_acc) then assign beg_bal = 0.
          /* CALCULATE BEGINNING BALANCE */
          begdtxx = begdt - 1.
          run proc_beg_balance.
          beg_bal = beg_bal + amt.
          if last-of(asc_acc) then amt_solde = beg_bal.
      end. /*END FOR LOOP asc_mstr*/
      {&GLACSTRP-P-TAG3}
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
      where gltr_domain = global_domain
        and gltr_eff_dt >= begdt
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

end. /*END REPEAT LOOP*/

PROCEDURE proc_bank_and_paymthd:
  assign bank  = ""
         ckfrm = "".
  if gltr_hist.gltr_tr_type = "AR" and
    (gltr_hist.gltr_doc_typ = "P" or
     gltr_hist.gltr_doc_typ = "D")
  then do:
     for first ar_mstr
        fields( ar_domain ar_nbr ar_bank ar_pay_method)
        where ar_domain = global_domain
         and  ar_nbr = gltr_hist.gltr_doc
     no-lock:
        assign bank  = ar_mstr.ar_bank
               ckfrm = ar_mstr.ar_pay_method.
     end.
  end.
  else if gltr_hist.gltr_tr_type = "AP" and
          gltr_hist.gltr_doc_typ = "CK"
  then do:
     assign bank = substring(gltr_hist.gltr_doc, 1, 2).
     for first ap_mstr
        fields (ap_domain ap_type ap_ref ap_ckfrm)
        where ap_domain = global_domain
         and  ap_type = gltr_tr_type
         and  ap_ref = gltr_hist.gltr_doc
     no-lock:
        ckfrm = ap_ckfrm.
     end.
  end.
  else if gltr_hist.gltr_tr_type  = "JL" then
     assign bank = substring(gltr_hist.gltr_batch,3,2).
END PROCEDURE. /* proc_bank_and_paymthd */

PROCEDURE proc_doc_ref:
  assign doc = "".
  if gltr_hist.gltr_tr_type = "IC" then do:
     for first tr_hist
        fields (tr_domain tr_trnbr tr_lot)
        where tr_domain = global_domain
        and   tr_trnbr  = integer(gltr_hist.gltr_doc)
     no-lock:
        doc = tr_lot.
     end. /* FOR FIRST tr_hist */
  end.
  else if gltr_hist.gltr_tr_type = "WO" then do:
     for first opgl_det fields (opgl_domain opgl_gl_ref opgl_trnbr) no-lock
        where opgl_domain = global_domain
         and  opgl_gl_ref = gltr_hist.gltr_ref:
     end.
     if available opgl_det then
        for op_hist fields (op_domain op_trnbr op_wo_lot)
           where op_hist.op_domain = global_domain
            and  op_trnbr = opgl_trnbr
        no-lock:
           doc = op_wo_lot.
        end.
  end.
  else if gltr_hist.gltr_tr_type = "AR" and
          gltr_hist.gltr_doc_typ = "P"
  then
     doc = substr(gltr_hist.gltr_doc,9,8).
  else if gltr_hist.gltr_tr_type = "AP" and
          gltr_hist.gltr_doc_typ = "CK"
  then
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
         fields (tr_domain tr_trnbr tr_type)
         where tr_domain = global_domain
         and   tr_trnbr  = integer(gltr_doc)
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
     gltr_hist.gltr_doc_typ = "VO"
  then do:
     gldesc = getTermLabel("VOUCHER", 35).
     for first txrd_det
        fields (txrd_domain txrd_tran_type txrd_ref txrd_code)
     no-lock
        where txrd_det.txrd_domain = global_domain
         and  txrd_tran_type = "VO"
         and txrd_ref = gltr_doc:
     end.
     if available txrd_det then do:
        for first atd_mstr fields (atd_domain atd_code atd_desc)
         where atd_domain = global_domain
          and  atd_code   = txrd_code
        no-lock:
           gldesc = atd_desc.
        end.
     end.
  end.
  else
  if gltr_hist.gltr_tr_type = "AP" and gltr_hist.gltr_doc_typ = "CK"
  then
     gldesc = gltr_desc.
  else
  if gltr_hist.gltr_tr_type = "SO" then do:
     gldesc = getTermLabel("INVOICE",7) + "/" + getTermLabel("CREDIT",6)
            + " " + getTermLabel("NOTE",4).
     for first txrd_det
        fields (txrd_domain txrd_tran_type txrd_ref txrd_code)
     no-lock
        where txrd_domain = global_domain
         and  txrd_tran_type = "IV"
         and  txrd_ref = gltr_doc:
     end.
     if available txrd_det then do:
        for first atd_mstr fields (atd_domain atd_code atd_desc)
           where atd_domain = global_domain
            and  atd_code = txrd_code
        no-lock:
           gldesc = atd_desc.
        end.
     end.
  end.
  else
  if gltr_hist.gltr_tr_type = "AR" and gltr_hist.gltr_doc_typ = "M"
  then do:
     gldesc = getTermLabel("INVOICE",7) + "/" + getTermLabel("CREDIT",6)
            + " " + getTermLabel("NOTE",4).
     for first txrd_det
        fields (txrd_domain txrd_tran_type txrd_ref txrd_code)
     no-lock
        where txrd_domain = global_domain
         and  txrd_tran_type = "AR"
         and  txrd_ref = gltr_doc:
     end.
     if available txrd_det then do:
        for first atd_mstr fields (atd_domain atd_code atd_desc)
           where atd_domain = global_domain
            and  atd_code = txrd_code
        no-lock:
           gldesc = atd_desc.
        end.
     end.
  end.
  else
  if gltr_hist.gltr_tr_type = "AR" and
    (gltr_doc_typ = "P" or gltr_doc_typ = "D")
  then
     gldesc = gltr_desc.
  else
     gldesc = gltr_desc.
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
             getTermLabelRt("OPENING", 7)     @ gltr_eff_dt
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
             gltr_ctr           when (ip_cc)
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
        gltr_hist.gltr_curramt <> 0
     then do:
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
     for first sb_mstr fields (sb_domain sb_desc)
        where sb_domain = global_domain
         and  sb_sub = gltr_sub no-lock:
     end.
     display gltr_sub "*" + sb_desc @ doc with frame b.
     if ip_level = 1 then
        down 1 with frame b.
  end. /* sub descrp printed */
  else
  if ccflag = false and gltr_ctr <> "" then do:
     for first cc_mstr fields (cc_domain cc_desc cc_ctr)
        where cc_domain = global_domain
         and  cc_ctr = gltr_ctr
     no-lock: end.
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
