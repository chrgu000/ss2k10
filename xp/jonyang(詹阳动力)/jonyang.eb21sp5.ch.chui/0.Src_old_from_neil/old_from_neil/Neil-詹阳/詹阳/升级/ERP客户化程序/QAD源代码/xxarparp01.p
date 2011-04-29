/* GUI CONVERTED from arparp01.p (converter v1.71) Fri Aug 21 18:36:40 1998 */
/* arparp01.p - DETAIL APPLY UNAPPLIED AUDIT REPORT                     */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert arparp01.p (converter v1.00) Fri Oct 10 13:57:06 1997 */
/* web tag in arparp01.p (converter v1.00) Mon Oct 06 14:17:23 1997 */
/*F0PN*/ /*K1DN*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 5.0      LAST MODIFIED: 10/05/89   BY: MLB *B326*          */
/* REVISION: 6.0      LAST MODIFIED: 08/31/90   BY: MLB *D055*          */
/* REVISION: 6.0      LAST MODIFIED: 09/20/90   BY: afs *D059*          */
/* REVISION: 6.0      LAST MODIFIED: 10/29/90   BY: MLB *D153*          */
/* REVISION: 6.0      LAST MODIFIED: 02/28/91   BY: afs *D387*          */
/* REVISION: 6.0      LAST MODIFIED: 03/19/91   BY: MLB *D444*          */
/* REVISION: 6.0      LAST MODIFIED: 04/03/91   BY: bjb *D507*          */
/* REVISION: 7.0      LAST MODIFIED: 02/01/92   BY: pml *F128*          */
/*                                   03/04/92   by: jms *F237*          */
/* REVISION: 7.3      LAST MODIFIED: 10/12/92   by: jms *G024*          */
/*                                   09/27/92   By: jcd *G247*          */
/*                                   02/25/93   By: skk *G746*          */
/*                                   08/23/94   By: rxm *GL40*          */
/* REVISION: 7.4      LAST MODIFIED: 09/11/94   by: slm *GM15*          */
/* REVISION: 8.5      LAST MODIFIED: 12/14/95   by: taf & mwd *J053*    */
/*                                   04/09/96   by: jzw *G1P6*          */
/*                                   07/29/96   by: taf *J101*          */
/* REVISION: 8.6      LAST MODIFIED: 12/16/97   by: bvm *K1DN*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 03/20/98   BY: *J2F8* D. Tunstall */
/* REVISION: 8.6E     LAST MODIFIED: 04/30/98   BY: *J2KJ* Niranjan R.  */
/* REVISION: 8.6E     LAST MODIFIED: 07/09/98   BY: *L01K* Jaydeep Parikh */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

         {mfdtitle.i "e+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE arparp01_p_1 "基本货币批处理合计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparp01_p_2 "发票"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparp01_p_3 "打印总帐明细"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparp01_p_4 "基本货币报表合计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparp01_p_5 "财务费用"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparp01_p_6 " 报表"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparp01_p_7 "基本货币报表"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparp01_p_8 "通知"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparp01_p_9 " 批处理合计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparp01_p_10 "基本货币批处理"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparp01_p_11 " 报表合计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparp01_p_12 "指定用途金额"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparp01_p_13 " 批处理"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparp01_p_14 "      付款"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparp01_p_15 "单位"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparp01_p_16 "S-汇总/D-明细"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparp01_p_17 "类型"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparp01_p_18 "  合计:"
/* MaxLen: Comment: */
&SCOPED-DEFINE arparp01_p_19 "日期!生效日期"
/* ********** End Translatable Strings Definitions ********* */

          define new shared variable rndmthd like rnd_rnd_mthd.
          define new shared variable base_amt_fmt as character.
          define new shared variable curr_amt_old as character.
          define new shared variable curr_amt_fmt as character.
          define variable oldcurr like ar_curr.
          define variable oldsession as character.
          define variable cust like ar_bill.
          define variable cust1 like ar_bill.
          define variable check_nbr like ar_check.
          define variable check1 like ar_check.
          define variable batch like ar_batch.
          define variable batch1 like ar_batch.
          define variable entity like ar_entity.
          define variable entity1 like ar_entity.
          define variable ardate like ar_date.
          define variable ardate1 like ar_date.
          define variable effdate like ar_effdate.
          define variable effdate1 like ar_effdate.
/*J2F8**  define variable name like ad_name format "x(26)". */
/*J2F8*/  define variable name like ad_name format "x(24)" no-undo.
          define variable type like ar_type format "X(10)".
          define variable detlines as integer.
          define variable gltrans like mfc_logical initial no
             label {&arparp01_p_3}.
          define variable gl_sum like mfc_logical initial no.
          define variable gldesc like glt_desc.
          define variable summary like mfc_logical format {&arparp01_p_16}
             initial no label {&arparp01_p_16}.
          define new shared variable base_rpt like ar_curr.
          define variable base_damt like ard_amt.
          define new shared variable base_amt like ar_amt.
          define variable disp_curr as character format "x(1)" label "C".
          define new shared variable ar_recno as recid.
          
          define variable base_det_amt like glt_amt.
          define variable gain_amt like glt_amt.
/*L01K*/  define variable mc-error-number like msg_nbr no-undo.
/*L01K*/  define variable foreignpayforeign like mfc_logical no-undo.


/*L01K*/ /* MUST INCLUDE gprunpdf.i IN THE MAIN BLOCK OF THE PROGRAM SO THAT */
/*L01K*/ /* CALLS TO gprunp.i FROM ANY OF THE INTERNAL PROCEDURES SKIPS  */
/*L01K*/ /* DEFINITION OF SHARED VARS OF gprunpdf.i */
/*L01K*/ /* FOR FURTHER INFO REFER TO HEADER COMMENTS IN gprunp.i */
/*L01K*/ {gprunpdf.i "mcpl" "p"}
/*L01K*/ {gprunpdf.i "mcui" "p"}


/*J2KJ*/  define variable basepayforeign like mfc_logical no-undo.
/*J2KJ*/  define variable base_glar_amt like glt_amt no-undo.

          find first gl_ctrl no-lock.

          
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
             
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
batch          colon 18 batch1         label {t001.i} colon 49
             check_nbr      colon 18 check1         label {t001.i} colon 49
             cust           colon 18 cust1          label {t001.i} colon 49
             entity         colon 18 entity1        label {t001.i} colon 49
             ardate         colon 18 ardate1        label {t001.i} colon 49
             effdate        colon 18 effdate1       label {t001.i} colon 49
             summary        colon 18
             gltrans        colon 18
             base_rpt       colon 18
           SKIP(.4)  /*GUI*/
with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF (DEFINED(SELECTION_CRITERIA) = 0)
  &THEN " 选择条件 "
  &ELSE {&SELECTION_CRITERIA}
  &ENDIF .
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



          FORM /*GUI*/ 
             space(10)
             ard_ref
             type column-label {&arparp01_p_17}
             ard_entity format "X(4)" label {&arparp01_p_15}
             ard_acct
             ard_cc no-label
             disp_curr
             base_damt label {&arparp01_p_12}
          with STREAM-IO /*GUI*/  frame c width 132 down.

          FORM /*GUI*/ 
             ar_nbr format "x(8)"
             ar_bill name column-label "名称!备注"
         /*    ar_type */
             ar_check column-label "支票! T "
             base_amt format "->>,>>>,>>9.99"
            ar_date column-label "日期!生效日期"
         /*    ar_effdate */
         /*    ar_entity format "X(4)" label {&arparp01_p_15} */
             ar_acct column-label "帐户!单位"
             ar_cc no-label
           /*  ar_po format "x(16)" */
          with STREAM-IO /*GUI*/  frame d width 132 down no-box.

          base_amt_fmt = base_amt:format.
          {gprun.i ""gpcurfmt.p"" "(input-output base_amt_fmt,
                                    input gl_rnd_mthd)"}
          curr_amt_old = base_amt:format.
          oldsession = SESSION:numeric-format.
          oldcurr = "".

         {wbrp01.i}

          
/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:


             if batch1 = hi_char then batch1 = "".
             if check1 = hi_char then check1 = "".
             if cust1 = hi_char then cust1 = "".
             if entity1 = hi_char then entity1 = "".
             if ardate = low_date then ardate = ?.
             if ardate1 = hi_date then ardate1 = ?.
             if effdate = low_date then effdate = ?.
             if effdate1 = hi_date then effdate1 = ?.

             if c-application-mode <> 'web':u then
             
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


         {wbrp06.i &command = update &fields = "  batch batch1 check_nbr check1
          cust cust1 entity entity1 ardate ardate1 effdate effdate1 summary
          gltrans base_rpt" &frm = "a"}

         if (c-application-mode <> 'web':u) or
         (c-application-mode = 'web':u and
         (c-web-request begins 'data':u)) then do:

             bcdparm = "".
             {mfquoter.i batch    }
             {mfquoter.i batch1   }
             {mfquoter.i check_nbr}
             {mfquoter.i check1   }
             {mfquoter.i cust     }
             {mfquoter.i cust1    }
             {mfquoter.i entity   }
             {mfquoter.i entity1  }
             {mfquoter.i ardate   }
             {mfquoter.i ardate1  }
             {mfquoter.i effdate  }
             {mfquoter.i effdate1 }
             {mfquoter.i summary  }
             {mfquoter.i gltrans  }
             {mfquoter.i base_rpt}

             if batch1 = "" then batch1 = hi_char.
             if check1 = "" then check1 = hi_char.
             if cust1 = "" then cust1 = hi_char.
             if entity1 = "" then entity1 = hi_char.
             if ardate = ? then ardate = low_date.
             if ardate1 = ? then ardate1 = hi_date.
             if effdate = ? then effdate = low_date.
             if effdate1 = ? then effdate1 = hi_date.

         end.

             /* SELECT PRINTER */
             
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:
find first gl_ctrl no-lock.

define buffer armstr for ar_mstr.


             {mfphead2.i}

             /* DELETE GL WORKFILE ENTRIES */
             if gltrans = yes then do:
                for each gltw_wkfl where gltw_userid = mfguser exclusive-lock:
                   delete gltw_wkfl.
                end.
             end.

             do with frame d down:

                for each ar_mstr where ar_batch >= batch and
                                       ar_batch <= batch1 and
                                       ar_check >= check_nbr and
                                       ar_check <= check1 and
                                       ar_bill /*ar_cust*/ >= cust and
                                       ar_bill /*ar_cust*/ <= cust1 and
                                       ar_entity >= entity and
                                       ar_entity <= entity1 and
                                       ar_date >= ardate and
                                       ar_date <= ardate1 and
                                       ar_effdate >= effdate and
                                       ar_effdate <= effdate1 and
                                       ar_type = "A" and
                                       ((ar_curr = base_rpt) or
                                       (base_rpt = ""))
                                       no-lock break by ar_batch by ar_nbr
                                       with frame c width 132 down:

                   if (oldcurr <> ar_curr) or (oldcurr = "") then do:
/*L01K*               {gpcurmth.i */
/*L01K*                    "ar_curr" */
/*L01K*                    "4" */
/*L01K*                    "leave" */
/*L01K*                    "pause" } */
/*L01K*/              /* GET ROUNDING METHOD FROM CURRENCY MASTER */
/*L01K*/              {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                          "(input ar_curr,
                            output rndmthd,
                            output mc-error-number)"}
/*L01K*/              if mc-error-number <> 0 then do:
/*L01K*/                    {mfmsg.i mc-error-number 4}
/*L01K*/                    if c-application-mode <> "WEB":U then
/*L01K*/                       pause.
/*L01K*/                    leave.
/*L01K*/              end.

                      /* DETERMINE CURRENCY DISPLAY AMERICAN OR EUROPEAN  */
                      find rnd_mstr where rnd_rnd_mthd = rndmthd
                         no-lock no-error.
                      if not available rnd_mstr then do:
                         {mfmsg.i 863 4}    /* ROUND METHOD RECORD NOT FOUND */
                         leave.
                      end.
                      /* ASSUME CURRENT SETTING IS SET FOR BASE CURRENCY*/
                      /* SET SESSION IF BASE_RPT <> BASE */
                      if (base_rpt <> "")
                      then do:
                         /* IF RND_DEC_PT = COMMA FOR DECIMAL POINT */
                         /* THIS IS A EUROPEAN STYLE CURRENCY */
                         if (rnd_dec_pt = "," )
                         then SESSION:numeric-format = "European".
                         else SESSION:numeric-format = "American".
                      end.

                      curr_amt_fmt = curr_amt_old.
                      {gprun.i ""gpcurfmt.p"" "(input-output curr_amt_fmt,
                                                input rndmthd)"}
                      oldcurr = ar_curr.
                   end.

                   base_amt = ar_amt.
                   base_amt:format = curr_amt_fmt.
                   if base_rpt = ""
                   and ar_curr <> base_curr then do:
                      base_amt:format = base_amt_fmt.
/*L01K*               USE ar_base_amt FOR BASE EQUIVALENT OF ar_amt.
*                     base_amt = base_amt / ar_ex_rate.
*                      /* ROUND PER BASE CURRENCY */
*                     {gprun.i ""gpcurrnd.p"" "(input-output base_amt,
*                        input gl_rnd_mthd)"}
**L01K*/
/*L01K*/              base_amt = ar_base_amt.
                   end.

                   if first-of(ar_batch) then display ar_batch with frame b
                      side-labels STREAM-IO /*GUI*/ .

                     find ad_mstr where ad_addr = ar_bill no-lock no-wait
                      no-error.
                   if available ad_mstr then name = ad_name.
                   else name = "".
                   display ar_nbr
                      ar_bill
                      name
                     /* ar_type */
                      ar_check 
                      base_amt format "->>,>>>,>>9.99"
                      ar_date
              /*        ar_effdate */
               /*       ar_entity */
                      ar_acct
                      ar_cc
                   /*   ar_po */
                   with frame d STREAM-IO /*GUI*/ .
                   down 1 with frame d.
                   display ar_po @ name ar_type @ ar_check ar_effdate @ ar_date ar_entity @ ar_acct with frame d stream-io. 
                   down 1 with frame d.

                   if gltrans then do:
                      if gl_vat then do:
                         ar_recno = recid(ar_mstr).
                         {gprun.i ""arparpv1.p""}
                      end.
                      {gpnextln.i &ref=ar_bill &line=return_int}
                      create gltw_wkfl.
                      assign gltw_entity = ar_entity
                             gltw_acct = ar_acct
                             gltw_cc = ar_cc
                             gltw_ref = ar_bill
                             gltw_line = return_int
                             gltw_date = ar_date
                             gltw_effdate = ar_effdate
                             gltw_userid = mfguser
                             gltw_desc =
                                ar_batch + " " + ar_type + " " + ar_nbr.
                             gltw_amt = base_amt.
                      recno = recid(gltw_wkfl).
                   end.

                   /* GET AR DETAIL  */
                   detlines = 0.
                   for each ard_det where ard_nbr = ar_nbr no-lock
                                          by ard_acct with frame e width 132:

/*J2KJ*/              basepayforeign = no.
/*J2KJ*/              /* GET MEMO OR INVOICE ASSOCIATED WITH THIS PMT */
/*J2KJ*/              if ard_ref <> " " then do:
/*J2KJ*/                 find armstr where armstr.ar_nbr = ard_ref no-lock
/*J2KJ*/                    no-error.
/*J2KJ*/                 if available armstr and armstr.ar_curr <> base_curr
/*J2KJ*/                    and (ar_mstr.ar_curr = base_curr or
/*J2KJ*/                    base_rpt <> armstr.ar_curr ) then
/*J2KJ*/                       /* BASE PMT ON A FOREIGN CURR MEMO/INVOICE */
/*J2KJ*/                       basepayforeign = yes.
/*J2KJ*/              end. /* IF ard_ref <> " " */

/*L01K*/         /* WITH EURO TRANSPARENCY AN EMU CURRENCY PAYMENT CAN SETTLE */
/*L01K*/         /* THE INVOICE/MEMO THAT IS IN ANOTHER EMU CURRENCY AND BOTH */
/*L01K*/         /* THE CURRENCIES MAY NOT BE BASE.                           */
/*L01K*/              assign foreignpayforeign = no.
/*L01K*/              if available armstr then
/*L01K*/                if armstr.ar_curr <> base_curr and
/*L01K*/                   ar_mstr.ar_curr <> base_curr and
/*L01K*/                   armstr.ar_curr <> ar_mstr.ar_curr and
/*L01K*/                   base_rpt = "" then foreignpayforeign = yes.

/*J2KJ*/              /* IF PMT CURR = BASE OR BASE REPT = PMT CURR */
/*J2KJ*/              if ar_mstr.ar_curr = base_curr or
/*J2KJ*/                 base_rpt = ar_mstr.ar_curr then do:
/*J2KJ*/                 assign
/*J2KJ*/                    base_damt = ard_amt
/*J2KJ*/                    base_det_amt = ard_amt
/*J2KJ*/                    disp_curr = " ".

/*L01K* /*J2KJ*/         if basepayforeign = yes then do: */
/*L01K*/                 if basepayforeign or foreignpayforeign then do:
/*J2KJ*/                    if ar_mstr.ar_curr = armstr.ar_curr then
/*L01K*/                     do:
/*L01K* /*J2KJ*/               base_glar_amt = ard_amt / armstr.ar_ex_rate. */
/*L01K*/                       /* CONVERT FROM FOREIGN TO BASE CURRENCY */
/*L01K*/                       {gprunp.i "mcpl" "p" "mc-curr-conv"
                                        "(input armstr.ar_curr,
                                          input base_curr,
                                          input armstr.ar_ex_rate,
                                          input armstr.ar_ex_rate2,
                                          input ard_amt,
                                          input true, /* ROUND */
                                          output base_glar_amt,
                                          output mc-error-number)"}.
/*L01K*/                       if mc-error-number <> 0 then do:
/*L01K*/                          {mfmsg.i mc-error-number 2}.
/*L01K*/                       end.
/*L01K*/                     end.
/*J2KJ*/                    else
/*L01K*/                     do:
/*L01K* /*J2KJ*/              base_glar_amt = ( ard_amt * ar_mstr.ar_ex_rate) */
/*L01K* /*J2KJ*/                              / armstr.ar_ex_rate.            */
/*L01K*/                       /* CONVERT FROM FOREIGN TO BASE CURRENCY */
/*L01K*/                       {gprunp.i "mcpl" "p" "mc-curr-conv"
                                        "(input armstr.ar_curr,
                                          input base_curr,
                                          input armstr.ar_ex_rate,
                                          input armstr.ar_ex_rate2,
                                          input ard_cur_amt,
                                          input true, /* ROUND */
                                          output base_glar_amt,
                                          output mc-error-number)"}.
/*L01K*/                       if mc-error-number <> 0 then do:
/*L01K*/                          {mfmsg.i mc-error-number 2}.
/*L01K*/                       end.
/*L01K*/                     end.
/*J2KJ*/                 end. /* IF basepayforeign = yes */
/*J2KJ*/                 else
/*J2KJ*/                    base_glar_amt = ard_amt.

/*L01K*                  ROUNDING DONE BY mc-curr-conv
* /*J2KJ*/                 /* ROUND PER BASE CURRENCY */
* /*J2KJ*/                 {gprun.i ""gpcurrnd.p"" "(input-output base_glar_amt,
*                          input gl_rnd_mthd)"}
**L01K*/
/*J2KJ*/              end. /* IF ar_mstr.ar_curr = base_curr */
/*J2KJ*/              else do:
/*J2KJ*/                 assign
/*J2KJ*/                    base_damt:format = base_amt_fmt.
/*L01K* /*J2KJ*/            base_damt = ard_amt / ar_mstr.ar_ex_rate. */
/*L01K*/                 /* CONVERT FROM FOREIGN TO BASE CURRENCY */
/*L01K*/                 {gprunp.i "mcpl" "p" "mc-curr-conv"
                                        "(input ar_mstr.ar_curr,
                                          input base_curr,
                                          input ar_mstr.ar_ex_rate,
                                          input ar_mstr.ar_ex_rate2,
                                          input ard_amt,
                                          input true, /* ROUND */
                                          output base_damt,
                                          output mc-error-number)"}.
/*L01K*/                 if mc-error-number <> 0 then do:
/*L01K*/                     {mfmsg.i mc-error-number 2}.
/*L01K*/                 end.
/*L01K*                  ROUNDING DONE BY mc-curr-conv
* /*J2KJ*/                 /* ROUND PER BASE CURRENCY */
* /*J2KJ*/                 {gprun.i ""gpcurrnd.p"" "(input-output base_damt,
*                                input gl_rnd_mthd)"}
*
* /*J2KJ*/                 base_det_amt = ard_amt / ar_mstr.ar_ex_rate.
* /*J2KJ*/                 /* ROUND PER BASE CURRENCY */
* /*J2KJ*/                 {gprun.i ""gpcurrnd.p"" "(input-output base_det_amt,
*                                input gl_rnd_mthd)"}
**L01K*/
/*L01K*/                 /* CONVERT FROM FOREIGN TO BASE CURRENCY */
/*L01K*/                 {gprunp.i "mcpl" "p" "mc-curr-conv"
                                        "(input ar_mstr.ar_curr,
                                          input base_curr,
                                          input ar_mstr.ar_ex_rate,
                                          input ar_mstr.ar_ex_rate2,
                                          input ard_amt,
                                          input true, /* ROUND */
                                          output base_det_amt,
                                          output mc-error-number)"}.
/*L01K*/                 if mc-error-number <> 0 then do:
/*L01K*/                     {mfmsg.i mc-error-number 2}.
/*L01K*/                 end.

/*L01K* /*J2KJ*/         if basepayforeign = yes then do: */
/*L01K*/                 if basepayforeign or foreignpayforeign then do:
/*J2KJ*/                    if ar_mstr.ar_curr = armstr.ar_curr then
/*L01K*/                     do:
/*L01K* /*J2KJ*/               base_glar_amt = ard_amt / armstr.ar_ex_rate. */
/*L01K*/                       /* CONVERT FROM FOREIGN TO BASE CURRENCY */
/*L01K*/                       {gprunp.i "mcpl" "p" "mc-curr-conv"
                                        "(input armstr.ar_curr,
                                          input base_curr,
                                          input armstr.ar_ex_rate,
                                          input armstr.ar_ex_rate2,
                                          input ard_amt,
                                          input true, /* ROUND */
                                          output base_glar_amt,
                                          output mc-error-number)"}.
/*L01K*/                       if mc-error-number <> 0 then do:
/*L01K*/                           {mfmsg.i mc-error-number 2}.
/*L01K*/                       end.
/*L01K*/                     end.
/*J2KJ*/                    else
/*L01K*/                     do:
/*L01K* /*J2KJ*/               base_glar_amt = ( ard_amt * ar_mstr.ar_ex_rate)*/
/*L01K* /*J2KJ*/                                       / armstr.ar_ex_rate. */
/*L01K*/                       /* CONVERT FROM FOREIGN TO BASE CURRENCY */
/*L01K*/                       {gprunp.i "mcpl" "p" "mc-curr-conv"
                                        "(input armstr.ar_curr,
                                          input base_curr,
                                          input armstr.ar_ex_rate,
                                          input armstr.ar_ex_rate2,
                                          input ard_cur_amt,
                                          input true, /* ROUND */
                                          output base_glar_amt,
                                          output mc-error-number)"}.
/*L01K*/                       if mc-error-number <> 0 then do:
/*L01K*/                           {mfmsg.i mc-error-number 2}.
/*L01K*/                       end.
/*L01K*/                     end.
/*J2KJ*/                 end. /* IF basepayforeign = yes */
/*J2KJ*/                 else
/*L01K*/                   do:
/*L01K* /*J2KJ*/             base_glar_amt = ard_amt / ar_mstr.ar_ex_rate. */
/*L01K*/                     /* CONVERT FROM FOREIGN TO BASE CURRENCY */
/*L01K*/                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                                        "(input ar_mstr.ar_curr,
                                          input base_curr,
                                          input ar_mstr.ar_ex_rate,
                                          input ar_mstr.ar_ex_rate2,
                                          input ard_amt,
                                          input true, /* ROUND */
                                          output base_glar_amt,
                                          output mc-error-number)"}.
/*L01K*/                       if mc-error-number <> 0 then do:
/*L01K*/                           {mfmsg.i mc-error-number 2}.
/*L01K*/                       end.
/*L01K*/                   end.

/*L01K*                  ROUNDING DONE BY mc-curr-conv
* /*J2KJ*/                 /* ROUND PER BASE CURRENCY */
* /*J2KJ*/                 {gprun.i ""gpcurrnd.p"" "(input-output base_glar_amt,
*                            input gl_rnd_mthd)"}
**L01K*/

/*J2KJ** BEGIN DELETE
 *                     base_damt = ard_amt.
 *                     base_det_amt = ard_amt.
 * /*J053*/              base_damt:format = curr_amt_fmt.
 *                     disp_curr = " ".
 * /*G1P6*               if base_rpt = "base" */
 * /*G1P6*/              if base_rpt = ""
 *                     and ar_curr <> base_curr then do:
 * /*J053*/                 base_damt:format = base_amt_fmt.
 *                        base_damt = base_damt / ar_ex_rate.
 * /*J053*/                 /* ROUND PER BASE CURRENCY */
 * /*J053*/                 {gprun.i ""gpcurrnd.p"" "(input-output base_damt,
 *                                                  input gl_rnd_mthd)"}
 * /*J053*                        base_damt = round(base_damt,gl_ex_round).   */
 *                         if ard_ref <> "" then do:
 *                           find armstr where armstr.ar_nbr = ard_ref no-lock.
 *                           base_det_amt = base_det_amt / armstr.ar_ex_rate.
 *                              /*INVOICE*/
 *                        end.
 *                        else base_det_amt = base_det_amt / ar_mstr.ar_ex_rate.
 *                           /*CHECK*/
 * /*J053*/                 /* ROUND PER BASE CURRENCY */
 * /*J053*/                 {gprun.i ""gpcurrnd.p"" "(input-output base_det_amt,
 *                                                    input gl_rnd_mthd)"}
 * /*J053*                   base_det_amt = round(base_det_amt,gl_ex_round).  */
 *J2KJ** END DELETE */

                         disp_curr = "Y".
                      end.

                      type = "".
                      if ard_type = "M" then type = {&arparp01_p_8}.
                      else if ard_type = "F" then type = {&arparp01_p_5}.
                      else if ard_type = "I" then type = {&arparp01_p_2}.

                      detlines = detlines + 1.
                      accumulate base_damt (total).

                      if not summary then do with frame c:
                         display
                            ard_ref
                            type
                            ard_entity
                            ard_acct
                            ard_cc
                            disp_curr
                            base_damt WITH STREAM-IO /*GUI*/ .
                         down 1.
                      end.

                      if gltrans then do:
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
/*J2KJ**                        gltw_amt = - base_det_amt. */
/*J2KJ*/                        gltw_amt = - base_glar_amt.
                         recno = recid(gltw_wkfl).

/*J2KJ** BEGIN DELETE
*                        if base_curr <> ar_mstr.ar_curr then do:
*                           gain_amt = base_det_amt - base_damt.
*J2KJ** END DELETE */

/*J2KJ*/                 if base_curr <> ar_mstr.ar_curr or
/*L01K* /*J2KJ*/            basepayforeign = yes then do: */
/*L01K*/                    basepayforeign or foreignpayforeign then do:
/*J2KJ*/                    if base_rpt = " " or base_rpt = base_curr then
/*J2KJ*/                       gain_amt = base_glar_amt - base_damt.
/*J2KJ*/                       if basepayforeign = no and
/*L01K*/                          foreignpayforeign = no and
/*J2KJ*/                       base_rpt = ar_mstr.ar_curr then
/*J2KJ*/                       gain_amt = 0.

                            if gain_amt <> 0 then do:
                               {gpnextln.i &ref=ar_mstr.ar_bill
                                  &line=return_int}
                               create gltw_wkfl.
                               assign gltw_entity = glentity
                                      gltw_acct = ar_mstr.ar_var_acct
                                      gltw_cc = ar_mstr.ar_var_cc
                                      gltw_ref = ar_mstr.ar_bill
                                      gltw_line = return_int
                                      gltw_date = ar_mstr.ar_date
                                      gltw_effdate = ar_mstr.ar_effdate
                                      gltw_userid = mfguser
                                      gltw_desc = ar_mstr.ar_batch + " " +
                                      ar_mstr.ar_type + " " + ar_mstr.ar_nbr
                                      gltw_amt = gain_amt.
                               recno = recid(gltw_wkfl).
                            end.
                         end.
                      end.

                   end.  /* ard_det loop */
                   accumulate (accum total  (base_damt))
                      (total by ar_mstr.ar_batch).

                   if detlines > 1 and not summary then do with frame c:
                      if page-size - line-counter < 3 then page.
                      underline base_damt.
                      display {&arparp01_p_14} @ type {&arparp01_p_18} @ ard_entity
                              accum total (base_damt) @ base_damt WITH STREAM-IO /*GUI*/ .
                      down 2.
                   end.

                   if last-of(ar_mstr.ar_batch) then do:
                      if page-size - line-counter < 4 then page.
                      if summary then do with frame d:
                         underline base_amt.
                         display
                                 (if base_rpt = ""
                                  then {&arparp01_p_1}
                                  else base_rpt + {&arparp01_p_9})
                                  @ name
                                 accum total by ar_mstr.ar_batch
                                 (accum total base_damt) @ base_amt WITH STREAM-IO /*GUI*/ .
                         down 3.
                      end.
                      else do with frame c:
                         underline base_damt.
                         display
                                 (if base_rpt = ""
                                  then {&arparp01_p_10}
                                  else base_rpt + {&arparp01_p_13})
                                 @ type
                                 {&arparp01_p_18} @ ard_entity
                                 accum total by ar_mstr.ar_batch
                                 (accum total base_damt) @ base_damt WITH STREAM-IO /*GUI*/ .
                                 down 3.
                             /*    if not last (ar_mstr.ar_nbr)  then do: */
                                   put ""  at 2 .
                                  put  "制表：__________________ 审批：__________________日期：_________________ " at  8.
                                  page.
                      end.
                   end.  /* batch totals */

  /*                 if last (ar_mstr.ar_nbr) then do:  /* report totals */
                      if page-size - line-counter < 3 then page.
                      if summary then do with frame d:
                         underline base_amt.
                         display
                                 (if base_rpt = ""
                                  then {&arparp01_p_4}
                                  else base_rpt + {&arparp01_p_11})
                                 @ name
                                 accum total (accum total base_damt) @ base_amt WITH STREAM-IO /*GUI*/ .
                         down 2.
                      end.
                      else do with frame c:
                         underline base_damt.
                         display
                                 (if base_rpt = ""
                                  then {&arparp01_p_7}
                                  else base_rpt + {&arparp01_p_6})
                                 @ type
                                 {&arparp01_p_18} @ ard_entity
                                 accum total
                                 (accum total base_damt) @ base_damt WITH STREAM-IO /*GUI*/ .
                          down 2.
                          put ""  at 2 .
                   put  "制单：___________________ 审批：_________________ 日期：________________" at 8.
                    page.
                      end.
                   end.  /* report totals */ */

                   
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/

                end.  /* ar_mstr loop */

             end.  /* scope for frame d */

             /* PRINT GL DISTRIBUTION */
             if gltrans then do:
                page.
                SESSION:numeric-format = oldsession.
                {gprun.i ""gpglrp.p""}
             end.

             /* REPORT TRAILER */
             
/*GUI*/ /* {mfguitrl.i}Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


          end.
          SESSION:numeric-format = oldsession.

         {wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" batch batch1 check_nbr check1 cust cust1 entity entity1 ardate ardate1 effdate effdate1 summary gltrans base_rpt "} /*Drive the Report*/
