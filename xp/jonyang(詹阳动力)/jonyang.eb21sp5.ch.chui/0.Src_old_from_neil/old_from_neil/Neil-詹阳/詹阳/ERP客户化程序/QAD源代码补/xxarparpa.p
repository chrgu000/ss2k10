/* GUI CONVERTED from arparpa.p (converter v1.71) Fri Oct  2 11:21:14 1998 */
/* arparpa.p - DETAIL PAYMENT AUDIT REPORT SUBROUTINE                        */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.      */
/* web convert arparpa.p (converter v1.00) Fri Oct 10 13:57:28 1997 */
/* web tag in arparpa.p (converter v1.00) Mon Oct 06 14:17:58 1997 */
/*F0PN*/ /*K0QK*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=Report                                             */
/*V8:WebEnabled=No*/
/* REVISION: 7.3      LAST MODIFIED: 08/17/93   by: JJS *GE34*               */
/*                                              (split from arparp.p)        */
/* REVISION: 7.4      LAST MODIFIED: 09/11/94   by: slm *GM15*               */
/*                                   02/24/95   by: str *F0K9*               */
/*                                   01/15/96   by: mys *H0HN*               */
/* REVISION: 8.5      LAST MODIFIED: 12/04/95   by: taf *J053*               */
/*                                   04/08/96   by: wjk *H0KG*               */
/*                                   04/15/96   by: mzh *J0J3*               */
/*                                   04/16/96   by: jzw *G1T9*               */
/*                                   05/28/96   by: jzw *G1WL*               */
/*                                   07/18/96   by: jwk *F0XJ*               */
/*                                   10/28/96   by: rxm *F0X6*               */
/*                                   01/08/97   by: bkm *J1DQ*               */
/* REVISION: 8.6      LAST MODIFIED: 10/17/97   by: bvm *K0QK*               */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 04/08/98   by: rup *L00K*               */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton      */
/* REVISION: 8.6E     LAST MODIFIED: 06/19/98   BY: *J2PJ* Dana Tunstall     */
/* REVISION: 8.6E     LAST MODIFIED: 07/07/98   BY: *L01K* Jaydeep Parikh    */
/* REVISION: 8.6E     LAST MODIFIED: 09/16/98   BY: *L098* G.Latha           */
/* REVISION: 8.6E     LAST MODIFIED: 09/18/98   BY: *J30B* Santhosh Nair     */
/* REVISION: 8.6E     LAST MODIFIED: 09/21/98   BY: *L09F* Jeff Wootton      */
/* REVISION: 8.6E     LAST MODIFIED: 09/25/98   BY: *L09V* Jeff Wootton      */


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

         {mfdeclre.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE arparpa_p_1 "类型"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparpa_p_2 "  合计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparpa_p_3 "未指定"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparpa_p_4 "未指定用途金额"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparpa_p_5 "S-汇总/D-明细"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparpa_p_6 "报表"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparpa_p_7 "现金帐户!贴现帐户"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparpa_p_8 "  批处理合计:"
/* MaxLen: Comment: */

/*J30B*/ /* REPLACED pre-processor label "Curr!Exch Rate"      */
/*J30B*/ /* TO "Cur!Exch Rate" FOR TRANSLATION PURPOSE         */
/*J30B** &SCOPED-DEFINE arparpa_p_9 "Cur!Exch Rate"            */
&SCOPED-DEFINE arparpa_p_9 "货币!兑换率"
/* MaxLen: 13 Comment: */

&SCOPED-DEFINE arparpa_p_10 "     基本报表合计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparpa_p_11 "     报表合计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparpa_p_12 "折扣金额"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparpa_p_13 "现金金额!折扣金额"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparpa_p_14 "财务费"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparpa_p_15 "单位"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparpa_p_16 "基本货币批处理合计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparpa_p_17 "通知"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparpa_p_18 "汇票 "
/* MaxLen: Comment: */

&SCOPED-DEFINE arparpa_p_19 "批处理"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparpa_p_20 "发票  "
/* MaxLen: Comment: */

&SCOPED-DEFINE arparpa_p_21 "日期!生效日期"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparpa_p_22 "应收金额!非应收金额"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparpa_p_23 "非应收金额"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparpa_p_24 "打印总帐明细"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparpa_p_25 "非应收"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparpa_p_26 "付款"
/* MaxLen: Comment: */

/*L098*/ /* HARDCODED STRING "Base" HAS BEEN REPLACED BY PRE-PROCESSOR */
&SCOPED-DEFINE arparpa_p_27 "基本"
/* MaxLen:4 Comment: */

/* ********** End Translatable Strings Definitions ********* */
/*L00K*/ {etvar.i}
/*L00K*/ {etrpvar.i}
         {wbrp02.i}

         /* DEFINE SHARED WORKFILE AP_WKFL FOR CURRENCY SUMMARY */
         {gpacctp.i}

         define shared variable rndmthd like rnd_rnd_mthd.
         define new shared variable base_amt like ar_amt.

         define new shared variable base_damt like ard_amt.
         define new shared variable base_disc like ard_disc.
         define new shared variable tot-vtadj like ar_amt.
         define new shared variable tot-vtcurradj like tot-vtadj.
         define new shared variable un-vt-amt as decimal.
         define new shared variable ard_recno as recid.
         define new shared variable ar_recno as recid.

         define shared variable batch like ar_batch.
         define shared variable batch1 like ar_batch.
         define shared variable check_nbr like ar_check.
         define shared variable check1 like ar_check.
         define shared variable cust like ar_bill.
         define shared variable cust1 like ar_bill.
         define shared variable entity like ar_entity.
         define shared variable entity1 like ar_entity.
         define shared variable ardate like ar_date.
         define shared variable ardate1 like ar_date.
         define shared variable effdate like ar_effdate.
         define shared variable effdate1 like ar_effdate.
         define shared variable base_rpt like ar_curr.
         define shared variable mixed_rpt like mfc_logical.
         define shared variable summary like mfc_logical format {&arparpa_p_5}
            initial no label {&arparpa_p_5}.
         define shared variable gltrans like mfc_logical initial no
           label {&arparpa_p_24}.

         define variable detlines as integer.
         define variable disp_curr as character format "x(1)" label "C".
         define variable type like ar_type format "X(6)".
         define variable aramt like ard_amt label {&arparpa_p_22}.
         define variable unamt like ard_amt label {&arparpa_p_4}.
         define variable c_unamt like unamt.
         define variable nonamt like ard_amt label {&arparpa_p_23}.
         define variable c_nonamt like nonamt.
         define variable base_det_amt like glt_amt.
         define variable base_gl_disc like glt_amt.
         define variable gain_amt like glt_amt.
         define variable name like ad_name.
         define variable basepayforeign like mfc_logical no-undo.
         define variable oldcurr like ar_curr.
         define variable oldsession as character.
         define variable c_session as character.
         define variable base_amt_fmt as character.
         define variable curr_amt_old as character.
         define variable curr_amt_fmt as character.
         define variable curr_to_pass like ar_curr.
         define variable save_line like gltw_line no-undo.
         define variable base_glar_amt like glt_amt no-undo.
/*L01K*/ define variable ex_rate_relation1 as character format "x(40)" no-undo.
/*L01K*/ define variable ex_rate_relation2 as character format "x(40)" no-undo.
/*L01K*/ define variable foreignpayforeign like mfc_logical no-undo.


         /* FOLLOWING NEEDED TO CALL ROUTINE TXTOTAL.P ***/
         define variable tax_tr_type like tx2d_tr_type initial "19".
         define variable tax_lines like tx2d_line initial 0.
         /* ABOVE FOR TXTOTAL.P                        ***/

         /* FOLLOWING NEEDED TO CALL ROUTINE TXGLPOST.P ***/
         define variable gen_desc like glt_desc.
         /* ABOVE FOR TXGLPST.P                         ***/

         define buffer armstr for ar_mstr.

         FORM /*GUI*/ 
         /*   ar_check */
            ar_bill column-label "票据开往!支票"
            name format "x(18)"
            ar_type column-label " T!单位"
            ar_curr column-label {&arparpa_p_9}
/*L01K*/    format "x(25)"          /* TO DISPLAY EX RATES IN CURRENCY COLUMN */
            base_amt format "->>,>>>,>>9.99"
            ar_date column-label {&arparpa_p_21}
         /*   ar_entity */
            ar_acct column-label {&arparpa_p_7}
            ar_cc no-label
         with STREAM-IO /*GUI*/  frame c width 132 down.

         FORM /*GUI*/ 
            ard_ref
            type column-label {&arparpa_p_1}
        /*    ard_entity format "X(4)" label {&arparpa_p_15} */
            ard_acct column-label "帐户!单位"
            ard_cc no-label
            disp_curr
            base_damt column-label {&arparpa_p_13} format "->>,>>>,>>9.99"
         /*   base_disc label {&arparpa_p_12} format "->>,>>>,>>9.99" */
            aramt column-label {&arparpa_p_22} format "->>,>>>,>>9.99"
            unamt label {&arparpa_p_4} format "->>,>>>,>>9.99"
          /*  nonamt label {&arparpa_p_23} format "->>,>>>,>>9.99" */
         with STREAM-IO /*GUI*/  frame e width 132 down.

         find first gl_ctrl no-lock no-error.
         find ar_mstr where recid(ar_mstr) = ar_recno no-lock no-error.
         base_amt_fmt = base_amt:format.
         {gprun.i ""gpcurfmt.p"" "(input-output base_amt_fmt,
                                   input gl_rnd_mthd)"}
/*L09F*/ assign
            curr_amt_old = base_amt:format
            oldsession = SESSION:numeric-format
            oldcurr = "".
         do with frame e width 132 no-box down:

            for each ar_mstr where (ar_batch >= batch) and (ar_batch <= batch1)
                        and (ar_check >= check_nbr) and (ar_check <= check1)
                        and (ar_bill >= cust) and (ar_bill <= cust1)
                        and (ar_entity >= entity) and (ar_entity <= entity1)
                        and (ar_date >= ardate) and (ar_date <= ardate1)
                        and (ar_effdate >= effdate) and (ar_effdate <= effdate1)
                        and (ar_type = "P")
                        and ((ar_curr = base_rpt)
                        or (base_rpt = "")) no-lock break by ar_batch by ar_nbr
               with frame c width 132 down:

               if (oldcurr <> ar_curr) then do:
               /* DETERMINE ROUNDING METHOD FROM DOCUMENT CURRENCY OR BASE    */
                  if (gl_base_curr <> ar_curr) then do:
/*L01K*              REPLACED WITH mc-get-rnd-mthd
*                    find first ex_mstr where ex_curr = ar_curr
*                       no-lock no-error.
*                    if not available ex_mstr then do:
*                       {mfmsg.i 964 4}
*                       /* CURRENCY EXCHANGE MASTER DOES NOT EXIST */
*                       next.
*                    end.
*                    rndmthd = ex_rnd_mthd.
**L01K*/
/*L01K*/             /* GET ROUNDING METHOD FROM CURRENCY MASTER */
/*L01K*/             {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                            "(input ar_curr,
                              output rndmthd,
                              output mc-error-number)"}
/*L01K*/             if mc-error-number <> 0 then do:
/*L01K*/                {mfmsg.i mc-error-number 4}
/*L01K*/                next.
/*L01K*/             end.
                  end.
                  else rndmthd = gl_rnd_mthd.

                  /* DETERMINE CURRENCY DISPLAY AMERICAN OR EUROPEAN       */
                  find rnd_mstr where rnd_rnd_mthd = rndmthd no-lock no-error.
                  if not available rnd_mstr then do:
                     {mfmsg.i 863 4}
                     /* ROUND METHOD RECORD NOT FOUND */
                     next.
                  end.
                  /* IT IS ASSUMED THAT THE STARTUP SESSION IS FOR THE BASE */
                  /* CURRENCY, THEREFORE DO NOT CHANGE SESSION IF BASE_RPT */
                  /* IS BASE */
                  if not (base_rpt = "" and not mixed_rpt)
                  then do:
                      /* IF RND_DEC_PT = COMMA FOR DECIMAL POINT */
                      /* THIS IS A EUROPEAN STYLE CURRENCY */
                      if (rnd_dec_pt = "," )
                      then
                        assign
                          c_session = "European"
                          SESSION:numeric-format = "European".
                      else
                        assign
                          c_session = "American"
                          SESSION:numeric-format = "American".
                  end.

/*L09F*/          assign
                     oldcurr = ar_curr
                     curr_amt_fmt = curr_amt_old.
                  {gprun.i ""gpcurfmt.p"" "(input-output curr_amt_fmt,
                                            input rndmthd)"}
               end.

               if ar_curr = base_curr then
               do:
/*L09F*/          assign
                     base_amt:format = curr_amt_fmt
                     base_amt = ar_amt.
               end.
               else do:
/*L01K*           FIELD ar__dec01 NOT USED ANY MORE FOR PAYMT/BASE RATE
.                 assign
./*L00K*/          et_ex_rate = (if ar_mstr.ar__dec01 <> 0
.                                then ar_mstr.ar__dec01
.                                else
.                                ar_mstr.ar_ex_rate)
.*L01K*/
/*L00K            base_amt = ar_amt / ar_ex_rate         */
/*L01K* /*L00K*/      base_amt = ar_amt / et_ex_rate . */
/*L01K*/          /*INSTEAD OF CONVERTING ar_amt, USE NEW FIELD ar_base_amt */
/*L01K*/          assign base_amt = ar_base_amt
                         base_amt:format = base_amt_fmt .

/*L01K*
*                 /* ROUND PER BASE CURRENCY ROUND METHOD */
*                 {gprun.i ""gpcurrnd.p"" "(input-output base_amt,
*                    input gl_rnd_mthd)"}
**L01K*/
               end.

               if first-of(ar_batch) then
                  display ar_batch with frame b side-labels STREAM-IO /*GUI*/ .

               if first-of(ar_nbr) then
               do with frame c:
                  find ad_mstr where ad_addr = ar_bill no-lock no-wait no-error.
                  if available ad_mstr then name = ad_name.
                  else name = "".

                  /* Changed format of batch header to make room for currency */
                  /* and Exchange rate.                                       */
                  display /* ar_check */
                          ar_bill
                          name
                          ar_type WITH STREAM-IO /*GUI*/ .
                  if not (base_rpt = "" and not mixed_rpt)
                  then display ar_curr with frame c STREAM-IO /*GUI*/ .
                  else display base_curr @ ar_curr
                          with frame c STREAM-IO /*GUI*/ .
                  if base_rpt = "" and not mixed_rpt
                  then
                  do:
                      base_amt:format = base_amt_fmt.
                      display (- base_amt) @ base_amt
                          with frame c STREAM-IO /*GUI*/ .
                  end.
                  else
                  do:
                      base_amt:format = curr_amt_fmt.
                      display (- ar_amt) @ base_amt
                          with frame c STREAM-IO /*GUI*/ .
                  end.
                  display /*ar_check*/
                          ar_date                      
                          ar_acct
                          ar_cc
                  with frame c STREAM-IO /*GUI*/ .
                  down 1 with frame c.

/*L01K*           USE mc-ex-rate-output ROUTINE TO GET THE RATES FOR DISPLAY */
/*L01K*/          {gprunp.i "mcui" "p" "mc-ex-rate-output"
                    "(input ar_curr,
                      input base_curr,
                      input ar_ex_rate,
                      input ar_ex_rate2,
                      input ar_exru_seq,
                      output ex_rate_relation1,
                      output ex_rate_relation2)"}

                  display ar_check @ ar_bill
                          ar_entity @ ar_type format "x(4)"
                          ar_po @ name
/*L01K*                   ar_ent_ex  @ ar_curr */
/*L01K*/                  ex_rate_relation1 @ ar_curr format "x(25)"
                          ar_effdate @ ar_date
                          ar_disc_acct @ ar_acct
                          ar_disc_cc @ ar_cc no-label
                          skip
                  with frame c STREAM-IO /*GUI*/ .
/*L01K*/          down 1 with frame c.

/*L01K*/          if ex_rate_relation2 <> "" then
/*L01K*/          do:
/*L01K*/             display ex_rate_relation2 @ ar_curr with frame c STREAM-IO /*GUI*/ .
/*L01K*/             down 1 with frame c.
/*L01K*/          end.

                  if gltrans then do:
                     {gpnextln.i &ref=ar_bill &line=return_int}
                     create gltw_wkfl.
/*L09F*              recno = recid(gltw_wkfl). */
                     assign
                            gltw_entity = ar_entity
                            gltw_acct = ar_acct
                            gltw_cc = ar_cc
                            gltw_ref = ar_bill
                            gltw_line = return_int
                            gltw_date = ar_date
                            gltw_effdate = ar_effdate
                            gltw_userid = mfguser
                            gltw_desc = ar_batch + " " + ar_type + " "
                                      + ar_nbr
/*L09F*/                    recno = recid(gltw_wkfl)
                            save_line = gltw_line.

                     /* RELEASE THE RECORD SO arparpvt.p FINDS IT */
                     release gltw_wkfl.
                  end.
               end.  /* first ar_nbr/gltrans file */

               /*  STORE TOTALS, BY CURRENCY, IN WORK FILE.                */
               if base_rpt = ""
               and mixed_rpt
               then do:
                  find first ap_wkfl where ar_curr = apwk_curr no-error.

                  /* If a record for this currency
                     doesn't exist, create one. */
                  if not available ap_wkfl then do:
                     create ap_wkfl.
                     apwk_curr = ar_curr.
                  end.

                     /* Accumulate individual currency totals in work file.*/
                  apwk_for = apwk_for + (- ar_amt).
                  if base_curr <> ar_curr then
                      apwk_base = apwk_base + (- base_amt).
                  else apwk_base = apwk_for.
               end.

               /* GET AR DETAIL  */
               detlines = 0.
               for each ard_det where ard_nbr = ar_nbr no-lock
                        break by ard_nbr by ard_acct with frame e:

                  basepayforeign = no.
                  /* GET MEMO OR INVOICE ASSOCIATED WITH THIS PMT */
                  if ard_ref <> "" then do:
                     find armstr where armstr.ar_nbr = ard_ref no-lock
                        no-error.
                     if available armstr and armstr.ar_curr <> base_curr
                        and ar_mstr.ar_curr = base_curr then
                        /* BASE PMT ON A FOREIGN CURR MEMO/INVOICE */
                        basepayforeign = yes.
                  end.

/*L01K*           WITH EURO TRANSPARENCY AN EMU CURRENCY PAYMENT CAN SETTLE */
/*L01K*           THE INVOICE/MEMO THAT IS IN ANOTHER EMU CURRENCY AND BOTH */
/*L01K*           THE CURRENCIES MAY NOT BE BASE.                           */
/*L09F*           /*L01K*/ assign */
/*L01K*/          foreignpayforeign = no.
/*L01K*/          if available armstr then
/*L01K*/             if armstr.ar_curr <> base_curr and
/*L01K*/                ar_mstr.ar_curr <> base_curr and
/*L01K*/                ar_mstr.ar_curr <> armstr.ar_curr and
/*L01K*/                base_rpt = "" then foreignpayforeign = yes.


                  /* IF PMT CURR = BASE OR REPT CURR = PMT CURR */
                  if ar_mstr.ar_curr = base_curr or
                     base_rpt = ar_mstr.ar_curr then do:
/*L09F*/             assign
                        base_damt = ard_amt
                        base_disc = ard_disc
                        base_det_amt = ard_amt + ard_disc
                        disp_curr = " ".
/*L01K*              if basepayforeign = yes then */
/*L01K*/             if basepayforeign or foreignpayforeign then
/*L01K*/                do:
/*L01K*                 base_glar_amt = ((ard_amt + ard_disc)
*                                     * ar_mstr.ar_ex_rate) / armstr.ar_ex_rate.
**L01K*/
/*L01K*                 NO NEED TO DO (ard_amt + ard_disc)*ar_mstr.ar_ex_rate */
/*L01K*                 PART OF THE CONVERSION TO DERIVE THE INVOICE/MEMO AMT */
/*L01K*                 AS OF DATE OF PAYMENT.                                */
/*L01K*                 INSTEAD USE THE ard_cur_amt + ard_cur_disc WHICH      */
/*L01K*                 ALREADY HAS THOSE VALUES.                             */
/*L01K*/                /* CONVERT FROM BASE TO FOREIGN CURRENCY */
/*L01K*/                {gprunp.i "mcpl" "p" "mc-curr-conv"
                             "(input armstr.ar_curr,
                               input base_curr,
                               input armstr.ar_ex_rate,
                               input armstr.ar_ex_rate2,
                               input (ard_cur_amt + ard_cur_disc),
                               input true, /* ROUND */
                               output base_glar_amt,
                               output mc-error-number)"}.
/*L01K*/                 if mc-error-number <> 0 then do:
/*L01K*/                    {mfmsg.i mc-error-number 4}.
/*L01K*/                 end.
/*L01K*/                end.
                     else
                        base_glar_amt = ard_amt + ard_disc.
/*L01K*              ROUNDING NOT NEEDED HERE
*                    /* ROUND PER BASE CURRENCY ROUND METHOD */
*                    {gprun.i ""gpcurrnd.p"" "(input-output base_glar_amt,
*                       input gl_rnd_mthd)"}
**L01K*/
                  end.
                  else do:
/*L01K*              base_damt = ard_amt / ar_mstr.ar_ex_rate. */

/*L09V*/             if ard_ref <> ""
/*L09V*/             /* (INVOICE/MEMO ATTACHED) */
/*L09V*/             and ard_cur_amt + ard_cur_disc <> 0
/*L09V*/             /* (PAYMENT DETAIL HAS A FOREIGN AMOUNT) */
/*L09V*/             and ard_cur_amt + ard_cur_disc = armstr.ar_applied
/*L09V*/             /* (PAYMENT FOREIGN CURRENCY AMOUNT EQUALS */
/*L09V*/             /*  INVOICE/MEMO APPLIED AMOUNT) */
/*L09V*/             then do:
/*L09V*/                base_damt = armstr.ar_base_applied.
/*L09V*/                /* (USE INVOICE/MEMO BASE APPLIED AMOUNT) */
/*L09V*/                base_disc = armstr.ar_base_applied
/*L09V*/                          /* (USE INVOICE/MEMO BASE APPLIED AMOUNT) */
/*L09V*/                          * ard_disc
/*L09V*/                          / (ard_amt + ard_disc).
/*L09V*/                          /* (IN SAME PROPORTION AS DISCOUNT) */
/*L09V*/                /* ROUND TO BASE METHOD */
/*L09V*/                {gprunp.i "mcpl" "p" "mc-curr-rnd"
                         "(input-output base_disc,
                           input gl_ctrl.gl_rnd_mthd,
                           output mc-error-number)"}
/*L09V*/                if mc-error-number <> 0 then do:
/*L09V*/                   {mfmsg.i mc-error-number 4}
/*L09V*/                end.
/*L09V*/                /* MAKE PAYMENT + DISCOUNT BALANCE TO INVOICE/MEMO */
/*L09V*/                base_damt = base_damt
/*L09V*/                          - base_disc.
/*L09V*/             end.
/*L09V*/             else do:
/*L01K*/                /* CONVERT FROM FOREIGN TO BASE CURRENCY */
/*L09F*/                /* CHANGED ROUNDING FROM FALSE TO TRUE BELOW */
/*L01K*/                {gprunp.i "mcpl" "p" "mc-curr-conv"
                          "(input ar_mstr.ar_curr,
                            input base_curr,
                            input ar_mstr.ar_ex_rate,
                            input ar_mstr.ar_ex_rate2,
                            input ard_amt,
                            input true, /* ROUND */
                            output base_damt,
                            output mc-error-number)"}.
/*L01K*/                if mc-error-number <> 0 then do:
/*L01K*/                   {mfmsg.i mc-error-number 4}.
/*L01K*/                end.
/*L01K*                 ROUNDING DONE BY mc-curr-conv
*                       /* ROUND PER BASE CURRENCY ROUND METHOD */
*                       {gprun.i ""gpcurrnd.p"" "(input-output base_damt,
*                         input gl_rnd_mthd)"}
**L01K*/

/*L01K*                 base_disc = ard_disc / ar_mstr.ar_ex_rate. */
/*L01K*/                /* CONVERT FROM FOREIGN TO BASE CURRENCY */
/*L01K*/                {gprunp.i "mcpl" "p" "mc-curr-conv"
                          "(input ar_mstr.ar_curr,
                            input base_curr,
                            input ar_mstr.ar_ex_rate,
                            input ar_mstr.ar_ex_rate2,
                            input ard_disc,
                            input true, /* ROUND */
                            output base_disc,
                            output mc-error-number)"}.
/*L01K*/                if mc-error-number <> 0 then do:
/*L01K*/                   {mfmsg.i mc-error-number 4}.
/*L01K*/                end.
/*L01K*                 ROUNDING DONE BY mc-curr-conv
*                       /* ROUND PER BASE CURRENCY ROUND METHOD */
*                       {gprun.i ""gpcurrnd.p"" "(input-output base_disc,
*                         input gl_rnd_mthd)"}
**L01K*/

/*L09V*/             end.

/*L01K*
*                     base_det_amt = (ard_amt + ard_disc) / ar_mstr.ar_ex_rate.
*                     /* ROUND PER BASE CURRENCY ROUND METHOD */
*                     {gprun.i ""gpcurrnd.p"" "(input-output base_det_amt,
*                        input gl_rnd_mthd)"}
**L01K*/
/*L09F*              /*L01K*/ assign */
/*L01K*/             base_det_amt = base_damt + base_disc.

/*L01K*              if basepayforeign = yes then  */
/*L01K*/             if basepayforeign or foreignpayforeign then
/*L01K*/              do:
/*L01K*                 base_glar_amt = ((ard_amt + ard_disc)
*                                     * ar_mstr.ar_ex_rate) / armstr.ar_ex_rate.
**L01K*/
/*L01K*                 NO NEED TO DO (ard_amt + ard_disc)*ar_mstr.ar_ex_rate */
/*L01K*                 PART OF THE CONVERSION TO DERIVE THE INVOICE/MEMO AMT */
/*L01K*                 AS OF DATE OF PAYMENT.                                */
/*L01K*                 INSTEAD USE THE ard_cur_amt + ard_cur_disc WHICH      */
/*L01K*                 ALREADY HAS THOSE VALUES.                             */
/*L01K*/                /* CONVERT FROM BASE TO FOREIGN CURRENCY */
/*L01K*/                {gprunp.i "mcpl" "p" "mc-curr-conv"
                             "(input armstr.ar_curr,
                               input base_curr,
                               input armstr.ar_ex_rate,
                               input armstr.ar_ex_rate2,
                               input (ard_cur_amt + ard_cur_disc),
                               input true, /* ROUND */
                               output base_glar_amt,
                               output mc-error-number)"}.
/*L01K*/                 if mc-error-number <> 0 then do:
/*L01K*/                    {mfmsg.i mc-error-number 4}.
/*L01K*/                 end.
/*L01K*/              end.
                     else
/*L01K*/              do:
/*L01K* /*J2PJ*/        if ar_mstr.ar_curr = armstr.ar_curr then    */
/*L01K* /*J2PJ*/           assign                                   */
/*L01K* /*J2PJ*/              base_glar_amt = (ard_amt + ard_disc)  */
/*L01K* /*J2PJ*/                              / armstr.ar_ex_rate.  */
/*L01K* /*J2PJ*/        else                                        */
/*L01K*                 base_glar_amt = (ard_amt + ard_disc)   */
/*L01K*                                  / ar_mstr.ar_ex_rate. */
/*L01K*/                if available armstr and
/*L01K*/                   ar_mstr.ar_curr = armstr.ar_curr then
/*L01K*/                  do:
/*L01K*/                    /* CONVERT FROM FOREIGN TO BASE CURRENCY */
/*L01K*/                    {gprunp.i "mcpl" "p" "mc-curr-conv"
                                 "(input armstr.ar_curr,
                                   input base_curr,
                                   input armstr.ar_ex_rate,
                                   input armstr.ar_ex_rate2,
                                   input (ard_amt + ard_disc),
                                   input true, /* ROUND */
                                   output base_glar_amt,
                                   output mc-error-number)"}.
/*L01K*/                    if mc-error-number <> 0 then do:
/*L01K*/                       {mfmsg.i mc-error-number 4}.
/*L01K*/                    end.
/*L01K*/                  end.
/*L01K*/                else
/*L01K*/                  do:
/*L01K*/                    /* CONVERT FROM FOREIGN TO BASE CURRENCY */
/*L01K*/                    {gprunp.i "mcpl" "p" "mc-curr-conv"
                                 "(input ar_mstr.ar_curr,
                                   input base_curr,
                                   input ar_mstr.ar_ex_rate,
                                   input ar_mstr.ar_ex_rate2,
                                   input (ard_amt + ard_disc),
                                   input true, /* ROUND */
                                   output base_glar_amt,
                                   output mc-error-number)"}.
/*L01K*/                    if mc-error-number <> 0 then do:
/*L01K*/                       {mfmsg.i mc-error-number 4}.
/*L01K*/                    end.
/*L01K*/                  end.
/*L01K*/              end.
                      /* ROUND PER BASE CURRENCY ROUND METHOD */

/*L01K*               ROUNDING DONE BY mc-curr-conv
*                     {gprun.i ""gpcurrnd.p"" "(input-output base_glar_amt,
*                        input gl_rnd_mthd)"}
**L01K*/

                     disp_curr = "Y".
                  end.

/*L09F*/          assign
                     detlines = detlines + 1
                     type = "".
                  if ard_type = "M" then type = {&arparpa_p_17}.
                  else if ard_type = "F" then type = {&arparpa_p_14}.
                  else if ard_type = "I" then type = {&arparpa_p_20}.
                  else if ard_type = "D" then type = {&arparpa_p_18}.
                  else if ard_type = "U" then type = {&arparpa_p_3}.
                  else if ard_type = "N" then type = {&arparpa_p_25}.

                  accumulate base_damt (total).
                  accumulate base_disc (total).
                  accumulate ard_amt (total).
                  accumulate ard_disc (total).
                  if not summary then do with frame e:
                     display
                        (if ard_type = "N"
                         or ard_type = "U"
                         then ard_tax /* N/U REFERENCE */
                         else ard_ref)
                            @ ard_ref
                        type
                     /*   ard_entity  */
                        ard_acct
                        ard_cc
                     with frame e STREAM-IO /*GUI*/ .
                    

                     if base_rpt = ""
                     and mixed_rpt
                     and disp_curr = "Y" then do:
/*L09F*/                assign
                           base_damt:format = curr_amt_fmt
                   /*        base_disc:format = curr_amt_fmt */
                           disp_curr = "".
                        display disp_curr
                                ard_amt @ base_damt WITH STREAM-IO .
                      /*          ard_disc @ base_disc WITH STREAM-IO /*GUI*/ .*/

              end.
                     else                    
                        display disp_curr
                          base_damt  WITH STREAM-IO /*GUI*/ .
                  /*        base_disc WITH STREAM-IO /*GUI*/ .*/

                    

                     /* DETERMINE FORMATTING TO BE BASE OR CURR */
                     if base_rpt = ""
                     and mixed_rpt
                     then do:
/*L09F*/                assign
                           aramt:format = curr_amt_fmt
                           unamt:format = curr_amt_fmt.
                     /*      nonamt:format = curr_amt_fmt. */
                     end.
                     else do:
/*L09F*/                assign
                           aramt:format = base_amt_fmt
                           unamt:format = base_amt_fmt.
                   /*        nonamt:format = base_amt_fmt. */
                     end.

                     if ard_type <> "N" then do:
                        aramt = base_det_amt.
                        if base_rpt = ""
                        and mixed_rpt
                        and basepayforeign = false then
                          display (ard_amt + ard_disc) @ aramt WITH STREAM-IO /*GUI*/ .
                        else display aramt WITH STREAM-IO /*GUI*/ .
                        accumulate (ard_amt + ard_disc) (total).
                        accumulate aramt (total).
                     end.
                     else display 0 @ aramt WITH STREAM-IO /*GUI*/ .

                     if ard_type = "U" then do:
                        unamt = base_damt.
                        if base_rpt = ""
                        and mixed_rpt
                        then display ard_amt @ unamt WITH STREAM-IO /*GUI*/ .
                        else display unamt WITH STREAM-IO /*GUI*/ .
                        accumulate c_unamt (total).
                        accumulate unamt (total).
                     end.
                     else display 0 @ unamt WITH STREAM-IO /*GUI*/ .
                     down 1 with frame e.

                     if ard_type = "N" then do:
                        nonamt = base_damt.
                        if base_rpt = ""
                        and mixed_rpt
                        then display ard_amt @ aramt WITH STREAM-IO /*GUI*/ .
                        else display nonamt @ aramt WITH STREAM-IO /*GUI*/ .
                        accumulate c_nonamt (total).
                        accumulate nonamt (total).
                     end.
                     else display 0 @ aramt WITH STREAM-IO /*GUI*/ .
                  
                  end.
                   if base_rpt = ""
                     and mixed_rpt
                     and disp_curr = "Y" then do:
/*L09F*/                assign
                           base_damt:format = curr_amt_fmt
                   /*        base_disc:format = curr_amt_fmt */
                           disp_curr = "".
                        display ard_disc @ base_damt WITH STREAM-IO /*GUI*/.

                     end.
                     else  display base_disc @ base_damt WITH STREAM-IO /*GUI*/ .                                                
                   display ard_entity @ ard_acct. 
                    down 1 with frame e.  
                  if gltrans then do:
/*L09F*/             assign
                        tot-vtadj = 0
                        tot-vtcurradj = 0
                        un-vt-amt = 0.
                     if gl_vat then do:
/*L09F*/                assign
                           ar_recno = recid(ar_mstr)
                           ard_recno = recid(ard_det).
                        {gprun.i ""arparpvt.p""}
                     end.
                     else if {txnew.i} then do:
                        /* GET TAX TOTALS */
                        {gprun.i ""txtotal.p"" "(input  tax_tr_type,
                                                 input  ard_det.ard_nbr,
                                                 input  ard_det.ard_ref,
                                                 input  tax_lines,
                                                 output tot-vtcurradj)"}
                        /* TAX MANAGEMENT ADJUSTMENTS ARE NEGATIVE VALUES */
/*L09F*/                assign
                           tot-vtcurradj = - tot-vtcurradj
                           tot-vtadj = tot-vtcurradj.
                        if available armstr then do:
                           if base_curr <> armstr.ar_curr then
                           do:
/*L01K*                       tot-vtadj = tot-vtadj / ar_mstr.ar_ex_rate. */
/*L01K*/                      /* CONVERT FROM FOREIGN TO BASE CURRENCY */
/*L01K*/                      {gprunp.i "mcpl" "p" "mc-curr-conv"
                                  "(input armstr.ar_curr,
                                    input base_curr,
                                    input ar_mstr.ar_ex_rate,
                                    input ar_mstr.ar_ex_rate2,
                                    input tot-vtadj,
                                    input false, /* DO NOT ROUND */
                                    output tot-vtadj,
                                    output mc-error-number)"}.
/*L01K*/                      if mc-error-number <> 0 then do:
/*L01K*/                         {mfmsg.i mc-error-number 4}.
/*L01K*/                      end.

                           end.
                        end.
                     end.

                     find first gltw_wkfl where gltw_ref = ar_mstr.ar_bill
                                           and gltw_line = save_line
                                           exclusive-lock no-error.
                     if available gltw_wkfl then do:
                        gltw_amt = gltw_amt + (base_glar_amt + un-vt-amt).
                        release gltw_wkfl.
                     end.

                     {gpnextln.i &ref=ar_mstr.ar_bill &line=return_int}
                     create gltw_wkfl.
                     assign gltw_entity = ard_entity
                            gltw_acct = ard_acct
                            gltw_cc = ard_cc
                            gltw_ref = ar_mstr.ar_bill
                            gltw_line = return_int
                            gltw_date = ar_mstr.ar_date
                            gltw_effdate = ar_mstr.ar_effdate
                            gltw_userid = mfguser
                            gltw_desc = ar_mstr.ar_batch + " " +
                                        ar_mstr.ar_type + " " + ar_mstr.ar_nbr
                            gltw_amt = - base_glar_amt - un-vt-amt
                            recno = recid(gltw_wkfl).

                     if {txnew.i} then do:
                        if (base_rpt = "" or
                            base_rpt = base_curr) then
                           base_gl_disc = base_disc - tot-vtadj.
                        else base_gl_disc = base_disc - tot-vtcurradj.
                     end.
                     else base_gl_disc = base_disc - tot-vtcurradj.

                     if base_gl_disc <> 0 then do:
                        /*IF VAT, CALCULATE BASE DISC FROM
                          CURR DISC AND CURR VTADJ*/
                        if ar_mstr.ar_curr <> base_curr and tot-vtadj <> 0
                        and not {txnew.i}
                        then do:
                           base_gl_disc = ard_disc - tot-vtcurradj.
                           if base_rpt <> ar_mstr.ar_curr then
/*L01K*                      base_gl_disc = base_gl_disc / ar_mstr.ar_ex_rate.*/
/*L01K*/                      /* CONVERT FROM FOREIGN TO BASE CURRENCY */
/*L01K*/                      {gprunp.i "mcpl" "p" "mc-curr-conv"
                                  "(input ar_mstr.ar_curr,
                                    input base_curr,
                                    input ar_mstr.ar_ex_rate,
                                    input ar_mstr.ar_ex_rate2,
                                    input base_gl_disc,
                                    input false, /* DO NOT ROUND */
                                    output base_gl_disc,
                                    output mc-error-number)"}.
/*L01K*/                      if mc-error-number <> 0 then do:
/*L01K*/                         {mfmsg.i mc-error-number 4}.
/*L01K*/                      end.

                        end.

                        find first gltw_wkfl where gltw_ref = ar_mstr.ar_bill
                                               and gltw_line = save_line
                                               exclusive-lock no-error.
                        if available gltw_wkfl then do:
                           gltw_amt = gltw_amt - base_disc.
                           release gltw_wkfl.
                        end.

                        {gpnextln.i &ref=ar_mstr.ar_bill &line=return_int}
                        create gltw_wkfl.
                        assign gltw_entity = ard_entity
                               gltw_acct = ar_mstr.ar_disc_acct
                               gltw_cc = ar_mstr.ar_disc_cc
                               gltw_ref = ar_mstr.ar_bill
                               gltw_line = return_int
                               gltw_date = ar_mstr.ar_date
                               gltw_effdate = ar_mstr.ar_effdate
                               gltw_userid = mfguser
                               gltw_desc = ar_mstr.ar_batch + " "
                                           + ar_mstr.ar_type + " "
                                           + ar_mstr.ar_nbr
                               gltw_amt = base_gl_disc
                               recno = recid(gltw_wkfl).
                     end.

                     if base_curr <> ar_mstr.ar_curr
/*L01K*              or basepayforeign = yes then do: */
/*L01K*/             or basepayforeign = yes or foreignpayforeign then do:
                        if {txnew.i} then do:
                           if (base_rpt = ""
                           or  base_rpt = base_curr) then
                              gain_amt = base_glar_amt
                                       - base_damt - base_gl_disc
                                       - tot-vtadj + un-vt-amt.
                           else
                              gain_amt = base_glar_amt
                                       - base_damt - base_gl_disc
                                       - tot-vtcurradj + un-vt-amt.
                        end.
                        else
                           gain_amt = base_glar_amt
                                    - base_damt - base_gl_disc
                                    - tot-vtadj + un-vt-amt.
/*L01K*                 if basepayforeign = no and */
/*L01K*/                if basepayforeign = no and foreignpayforeign = no and
                        base_rpt = ar_mstr.ar_curr then
                           gain_amt = 0.

                        if gain_amt <> 0 then do:

                           find first gltw_wkfl where gltw_ref = ar_mstr.ar_bill
                                                 and gltw_line = save_line
                                                 exclusive-lock no-error.
                           if available gltw_wkfl then do:
                              gltw_amt = gltw_amt - gain_amt.
                              release gltw_wkfl.
                           end.

                           {gpnextln.i &ref=ar_mstr.ar_bill &line=return_int}
                           create gltw_wkfl.
                           assign gltw_entity = ard_entity /*glentity*/
                                  gltw_acct = ar_mstr.ar_var_acct
                                  gltw_cc = ar_mstr.ar_var_cc
                                  gltw_ref = ar_mstr.ar_bill
                                  gltw_line = return_int
                                  gltw_date = ar_mstr.ar_date
                                  gltw_effdate = ar_mstr.ar_effdate
                                  gltw_userid = mfguser
                                  gltw_desc = ar_mstr.ar_batch + " "
                                              + ar_mstr.ar_type + " "
                                              + ar_mstr.ar_nbr
                                  gltw_amt = gain_amt
                                  recno = recid(gltw_wkfl).
                        end.
                     end.

                     if {txnew.i} and tot-vtcurradj <> 0 then do:
                        find first arc_ctrl no-lock no-error.
                        gen_desc = ar_mstr.ar_batch + " " + ar_mstr.ar_type.
                        {gpnextln.i &ref=ar_mstr.ar_bill &line=return_int}
                        if (base_rpt = "" or
                            base_rpt = base_curr) then
                           curr_to_pass = base_curr.
                        else curr_to_pass = base_rpt.

/*L00Y*/                /* ADDED SECOND EXCHANGE RATE, TYPE, SEQUENCE */
                        {gprun.i ""txglpost.p"" "(
                            input tax_tr_type         /* TRANSACTION TYPE */,
                            input ard_det.ard_nbr     /* REFERENCE */,
                            input ard_det.ard_ref     /* NUMBER */,
                            input curr_to_pass        /* REPORT CURRENCY */,
                            input ar_mstr.ar_bill     /* GL REFERENCE NUMBER */,
                            input ar_mstr.ar_effdate  /* EFFECTIVE DATE */,
                            input ar_mstr.ar_ex_rate  /* EXCHANGE RATE */,
                            input ar_mstr.ar_ex_rate2,
                            input ar_mstr.ar_ex_ratetype,
                            input ar_mstr.ar_exru_seq,
                            input ar_mstr.ar_batch    /* BATCH */,
                            input 'AR'                /* MODULE */,
                            input gen_desc            /* TRANS. DESCRIPTION */,
                            input false               /* POST */,
                            input not arc_gl_sum      /* POST DETAIL */,
                            input true                /* AUDIT TRAIL */,
                            input false               /* REPORT IN DETAIL */,
                            input ''                  /* PROJECT*/,
                            input ar_mstr.ar_type     /* TYPE OF DOCUMENT */,
                            input ar_mstr.ar_ship     /* ADDRESS */,
                            input gen_desc            /* GLTW_WKFL TYPE */,
                            input -1                  /* POSTING SIGN */
                        )" }
                        find last gltw_wkfl where gltw_ref = ar_mstr.ar_bill
                        and gltw_line = return_int
                        and gltw_userid = mfguser no-error.
                        if available gltw_wkfl then do:
                            assign gltw_date = ar_mstr.ar_date
                                   gltw_effdate = ar_mstr.ar_effdate
                                   recno = recid(gltw_wkfl).
                        end.
                     end. /* IF {TXNEW.I} */

                  end.  /* gltrans */
               end.  /* ard_det loop */

               accumulate (accum total  (nonamt)) (total by ar_mstr.ar_batch).
               accumulate (accum total  (unamt)) (total by ar_mstr.ar_batch).
               accumulate (accum total  (aramt)) (total by ar_mstr.ar_batch).
               accumulate
                  (accum total  (base_disc)) (total by ar_mstr.ar_batch).
               accumulate
                  (accum total  (base_damt)) (total by ar_mstr.ar_batch).

               if detlines > 1 and not summary then do with frame e:
                  if page-size - line-counter < 4 then page.
                  underline base_damt aramt unamt .

                  if base_rpt = ""
                  and mixed_rpt
                  then do:
                     display skip
                     ar_mstr.ar_curr @ ard_ref
                     {&arparpa_p_26} @ type {&arparpa_p_2} @ ard_acct
                     accum total (ard_amt) @ base_damt format "->>,>>>,>>9.99"
             /*        accum total (ard_disc) @ base_disc format "->>,>>>,>>9.99" */
                     accum total (ard_amt + ard_disc) @ aramt format "->>,>>>,>>9.99"
                     accum total (c_unamt) @ unamt format "->>,>>>,>>9.99"
            /*         accum total (c_nonamt) @ nonamt format "->>,>>>,>>9.99" */
                     skip WITH STREAM-IO /*GUI*/ .
                  end.
                  else do:
                     display
                             skip(0)
                             base_rpt @ ard_ref
                             {&arparpa_p_26} @ type {&arparpa_p_2} @ ard_acct
                             accum total (base_damt) @ base_damt format "->>,>>>,>>9.99"
                       /*      accum total (base_disc) @ base_disc format "->>,>>>,>>9.99" */
                             accum total (aramt) @ aramt format "->>,>>>,>>9.99"
                             accum total (unamt) @ unamt format "->>,>>>,>>9.99"
                    /*         accum total (nonamt) @ nonamt format "->>,>>>,>>9.99" */
                             skip WITH STREAM-IO /*GUI*/ .
                  end.
                  if base_rpt = ""
                  and mixed_rpt
                  then do:
                          display  accum total (ard_disc) @ base_damt format "->>,>>>,>>9.99" 
                           accum total (c_nonamt) @ aramt format "->>,>>>,>>9.99"  WITH STREAM-IO /*GUI*/ .
                           down 1 with frame e.
                  end.
                  else do:
                      display   accum total (base_disc) @ base_damt format "->>,>>>,>>9.99"
                               accum total (nonamt) @ aramt format "->>,>>>,>>9.99" WITH STREAM-IO /*GUI*/ . 
                                down 1 with frame e.
                  end.                   

               end.
               if last-of(ar_mstr.ar_batch) then do:
                  if page-size - line-counter < 4 then page.
                  /* RESET SESSION FOR BASE CURR */
                  SESSION:numeric-format = oldsession.
                  if summary then do with frame c:
                     down 2.
                     underline base_amt .

                     base_amt:format = base_amt_fmt.
                     display
                             (if base_rpt = ""
                              then {&arparpa_p_16}
                              else base_rpt + {&arparpa_p_8})
                             @ name
                             accum total by ar_mstr.ar_batch
                             (accum total base_damt) @ base_amt format "->>,>>>,>>9.99"
                             skip WITH STREAM-IO /*GUI*/ .
                  end.
                  else do with frame e:
                     down 2.
                     underline base_damt aramt unamt .
/*L09F*/             assign
                        base_damt:format = base_amt_fmt
                  /*      base_disc:format = base_amt_fmt*/
                        aramt:format = base_amt_fmt
                        unamt:format = base_amt_fmt.
                /*        nonamt:format = base_amt_fmt. */
                     display
                             (if base_rpt = ""
/*L098**                      then "Base" */
/*L098*/                      then {&arparpa_p_27}
                              else base_rpt)
                             @ ard_ref
                                {&arparpa_p_19} @ type
                                {&arparpa_p_2} @ ard_acct
                             accum total by ar_mstr.ar_batch
                                (accum total base_damt) @ base_damt format "->>,>>>,>>9.99"
                        /*     accum total by ar_mstr.ar_batch
                                (accum total base_disc) @ base_disc format "->>,>>>,>>9.99" */
                             accum total by ar_mstr.ar_batch
                                (accum total aramt) @ aramt format "->>,>>>,>>9.99"
                             accum total by ar_mstr.ar_batch
                                (accum total unamt) @ unamt format "->>,>>>,>>9.99"
                       /*      accum total by ar_mstr.ar_batch
                                (accum total nonamt) @ nonamt format "->>,>>>,>>9.99" */
                              WITH STREAM-IO /*GUI*/ .
                             down 1 with frame e.
                    display   accum total by ar_mstr.ar_batch
                              (accum total base_disc) @ base_damt format "->>,>>>,>>9.99"  
                              accum total by ar_mstr.ar_batch
                              (accum total nonamt) @ aramt format "->>,>>>,>>9.99" WITH STREAM-IO.
                                   
                  end.
                  /*  if not last(ar_mstr.ar_nbr) then do:*/
                     put " " at 2.
                     put "" at 2.
                     put  "制表:__________________审批:_________________日期:________________" at 8.  
                     page.
                                       
               end.  /* batch totals */

 /*            if last(ar_mstr.ar_nbr) then do:  /* report totals */
                  /* RESET SESSION FOR BASE CURR */
                  SESSION:numeric-format = oldsession.
                  if page-size - line-counter < 4 then page.
                  if summary then do with frame c:
                     base_amt:format = base_amt_fmt.
                     down 2.
                        underline base_amt.
                     display
                             (if base_rpt = ""
                              then {&arparpa_p_10}
                              else base_rpt + {&arparpa_p_11})
                             @ name
                             accum total (accum total base_damt) @ base_amt WITH STREAM-IO /*GUI*/ .
                  end.
                  else do with frame e:
/*L09F*/             assign
                        base_damt:format = base_amt_fmt
                   /*     base_disc:format = base_amt_fmt */
                        aramt:format = base_amt_fmt
                        unamt:format = base_amt_fmt.
                   /*     nonamt:format = base_amt_fmt. */
                     down 2.
                     underline base_damt aramt unamt .
                     display
                             (if base_rpt = ""
/*L098**                      then "Base" */
/*L098*/                      then {&arparpa_p_27}
                              else base_rpt)
                             @ ard_ref
                             {&arparpa_p_6} @ type {&arparpa_p_2} @ ard_acct 
                             accum total (accum total base_damt) @ base_damt format "->>,>>>,>>9.99"
                     /*         accum total (accum total base_disc) @ base_disc format "->>,>>>,>>9.99" */
                             accum total (accum total aramt) @ aramt format "->>,>>>,>>9.99"
                             accum total (accum total unamt) @ unamt format "->>,>>>,>>9.99"
                   /*          accum total (accum total nonamt) @ nonamt format "->>,>>>,>>9.99" */                                                       
                             WITH STREAM-IO /*GUI*/ .   
                             down 1 with frame e.                           
                  display    accum total (accum total base_disc) @ base_damt format "->>,>>>,>>9.99"
                             accum total (accum total nonamt) @ aramt format "->>,>>>,>>9.99" WITH STREAM-IO /*GUI*/ .
                             down 1 with frame e.                            
                    end.
                        put "" at 2.
                        put "" at 2.
                        put  "制表:_______________ 审批:_______________日期:_________________ " at 8.  
                        page.
                    end.*/      
                    
                  end. /*report totals */   
               /* RESET SESSION IF BASE_RPT <> BASE */
               if not (base_rpt = "" and not mixed_rpt)
               then SESSION:numeric-format = c_session.
               
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/

            end. /* for each ar_mstr */
        /* end.*/  /* do with frame e */
         SESSION:numeric-format = oldsession.
         {wbrp04.i}
