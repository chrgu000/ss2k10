/* GUI CONVERTED from ardrrp.p (converter v1.71) Wed Sep 16 02:47:17 1998 */
/* ardrrp.p - AR DETAIL DR/CR MEMO AUDIT REPORT                         */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert ardrrp.p (converter v1.00) Mon Oct 06 14:21:22 1997 */
/* web tag in ardrrp.p (converter v1.00) Mon Oct 06 14:17:23 1997 */
/*F0PN*/ /*K0QC*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 1.0      LAST MODIFIED: 07/16/86   BY: PML                 */
/* REVISION: 6.0      LAST MODIFIED: 08/27/90   BY: afs *D062*          */
/*                                   10/29/90   BY: MLB *D153*          */
/*                                   01/02/91   BY: afs *D283*          */
/*                                   02/28/91   BY: afs *D387*          */
/*                                   03/06/91   BY: bjb *D865*          */
/*                                   04/10/91   BY: bjb *D515*          */
/*                                   09/26/91   BY: WUG *D878*          */
/* REVISION: 7.0      LAST MODIFIED: 02/12/92   BY: jms *F201*          */
/*                                   03/04/92   BY: jms *F237*          */
/* REVISION: 7.0      LAST MODIFIED: 03/17/92   BY: TMD *F258*          */
/* REVISION: 7.0      LAST MODIFIED: 03/22/92   BY: TMD *F302*          */
/* REVISION: 7.0      LAST MODIFIED: 04/11/92   BY: afs *F356*          */
/* REVISION: 7.0      LAST MODIFIED: 05/29/92   BY: jjs *F559*          */
/* REVISION: 7.3      LAST MODIFIED: 08/03/92   BY: jms *G024*          */
/*                                   10/14/92   BY: jms *G177*          */
/*                                   09/27/93   BY: jcd *G247*          */
/*                                   05/13/93   BY: pcd *GA88*          */
/* REVISION: 7.4      LAST MODIFIED: 08/05/93   BY: bcm *H056*          */
/*                                   09/02/93   BY: wep *H102*          */
/*                                   09/02/93   BY: rxm *GL40*          */
/* REVISION: 7.4      LAST MODIFIED: 09/11/94   by: slm *GM15*          */
/* REVISION: 7.4      LAST MODIFIED: 11/08/94   by: jzs *GN61*          */
/* REVISION: 8.5      LAST MODIFIED: 12/12/95   by: taf & mwd *J053*    */
/*                                   04/08/96   by: jzw *G1T9*          */
/* REVISION: 8.5      LAST MODIFIED: 07/29/96   BY: taf *J101*          */
/* REVISION: 8.5      LAST MODIFIED: 12/20/96   BY: rxm *G2JR*          */
/* REVISION: 8.6      LAST MODIFIED: 02/18/97   BY: *K06Z* M. Madison   */
/* REVISION: 8.6      LAST MODIFIED: 10/10/97   BY: bvm *K0QC*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 06/26/98   BY: *L01K* Jaydeep Parikh */
/* REVISION: 8.6E     LAST MODIFIED: 09/16/98   BY: *L098* G.Latha        */
/************************************************************************/


/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

          {mfdtitle.i "e+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE ardrrp_p_1 "支付方式!催!帐!级"
/* MaxLen: Comment: */

&SCOPED-DEFINE ardrrp_p_2 "金额!已分配金额"
/* MaxLen: Comment: */

&SCOPED-DEFINE ardrrp_p_3 "财务费"
/* MaxLen: Comment: */

/*L01K* &SCOPED-DEFINE ardrrp_p_4 "Cur!Exch Rate" */
/*L01K*/ &SCOPED-DEFINE ardrrp_p_4 "币!C"
/* MaxLen: Comment: */

&SCOPED-DEFINE ardrrp_p_5 "基本货币报表合计"
/* MaxLen: Comment: */

&SCOPED-DEFINE ardrrp_p_6 "通知"
/* MaxLen: Comment: */

&SCOPED-DEFINE ardrrp_p_7 "日期!生效日期!定税日期"
/* MaxLen: Comment: */

&SCOPED-DEFINE ardrrp_p_8 "票据开往!销往"
/* MaxLen: Comment: */

&SCOPED-DEFINE ardrrp_p_9 "发票"
/* MaxLen: Comment: */

&SCOPED-DEFINE ardrrp_p_10 " 报表合计"
/* MaxLen: Comment: */

&SCOPED-DEFINE ardrrp_p_11 "帐户!单位!争议"
/* MaxLen: Comment: */

&SCOPED-DEFINE ardrrp_p_12 " 合计"
/* MaxLen: Comment: */

&SCOPED-DEFINE ardrrp_p_13 " 批处理 "
/* MaxLen: Comment: */

/*L01K* &SCOPED-DEFINE ardrrp_p_14 "Name!PO" */
/*L01K*/ &SCOPED-DEFINE ardrrp_p_14 "名称!兑换率!采购单"
/* MaxLen: Comment: */

&SCOPED-DEFINE ardrrp_p_15 "打印总帐明细"
/* MaxLen: Comment: */

&SCOPED-DEFINE ardrrp_p_16 "参考类型"
/* MaxLen: Comment: */

&SCOPED-DEFINE ardrrp_p_17 "类型"
/* MaxLen: Comment: */

&SCOPED-DEFINE ardrrp_p_18 "S-汇总/D-明细"
/* MaxLen: Comment: */

/*L098*/ /* HARDCODED STRING "Base" HAS BEEN REPLACED BY PRE-PROCESSOR */
&SCOPED-DEFINE ardrrp_p_19 "基本"
/* MaxLen:4 Comment: */

/* ********** End Translatable Strings Definitions ********* */

          /* DEFINE NEW SHARED WORKFILE AP_WKFL FOR CURRENCY SUMMARY */
          {gpacctp.i "new"}

          define new shared variable rndmthd like rnd_rnd_mthd.
           /* OLD_CURR IS USED BY GPACCTP.P */
          define new shared variable old_curr like ar_curr.
          define variable oldsession   as character.
          define variable c_session   as character.
          define variable oldcurr      like ar_curr.
          define variable cust         like ar_bill.
          define variable cust1        like ar_bill.
          define variable nbr          like ar_nbr.
          define variable nbr1         like ar_nbr.
          define variable batch        like ar_batch.
          define variable batch1       like ar_batch.
          define variable entity       like ar_entity.
          define variable entity1      like ar_entity.
          define variable ardate       like ar_date.
          define variable ardate1      like ar_date.
          define variable effdate      like ar_effdate.
          define variable effdate1     like ar_effdate.
/*L01K*   define variable name         like ad_name format "x(27)". */
/*L01K*/  define variable name         like ad_name format "x(35)".
          define variable type         like ar_type format "X(4)"
             label {&ardrrp_p_17}.
          define variable select_type  like ar_type
             label {&ardrrp_p_16} initial " ".
          define variable gltrans      like mfc_logical initial no
             label {&ardrrp_p_15}.
          define variable summary      like mfc_logical format {&ardrrp_p_18}
             initial no label {&ardrrp_p_18}.
          define variable base_rpt     like ar_curr.
          define variable mixed_rpt    like mfc_logical initial no
             label {gpmixlbl.i}.
          define variable base_damt    like ard_amt
             format "->,>>>,>>>,>>9.99".
          define variable base_amt     like ar_amt
             format "->,>>>,>>>,>>9.99".
          define variable base_applied like ar_applied
             format "->,>>>,>>>,>>9.99".
          define variable disp_curr    as character format "x(1)" label "C".
          define variable batch_title  as character format "x(30)".
          define new shared variable undo_txdetrp like mfc_logical.
          define variable tax_tr_type  like tx2d_tr_type initial "18".
          define variable tax_nbr      like tx2d_nbr initial "".
          define variable page_break   as integer initial 0.
          define variable col-80       like mfc_logical initial false.
          define variable disp_amt     like base_amt.
          define variable disp_applied like base_applied.
          define variable base_amt_fmt as character.
          define variable curr_amt_fmt as character.
          define variable curr_amt_old as character.
/*L01K*/  define variable mc-error-number like msg_nbr no-undo.
/*L01K*/ define variable ex_rate_relation1 as character format "x(40)" no-undo.
/*L01K*/ define variable ex_rate_relation2 as character format "x(40)" no-undo.


/*L01K*/ /* MUST INCLUDE gprunpdf.i IN THE MAIN BLOCK OF THE PROGRAM SO THAT */
/*L01K*/ /* CALLS TO gprunp.i FROM ANY OF THE INTERNAL PROCEDURES SKIPS  */
/*L01K*/ /* DEFINITION OF SHARED VARS OF gprunpdf.i */
/*L01K*/ /* FOR FURTHER INFO REFER TO HEADER COMMENTS IN gprunp.i */
/*L01K*/ {gprunpdf.i "mcpl" "p"}
/*L01K*/ {gprunpdf.i "mcui" "p"}

          {txcurvar.i "NEW"}
          
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
          
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
batch        colon 18 batch1   colon 49 label {t001.i}
          nbr          colon 18 nbr1     colon 49 label {t001.i}
          cust         colon 18 cust1    colon 49 label {t001.i}
          entity       colon 18 entity1  colon 49 label {t001.i}
          ardate       colon 18 ardate1  colon 49 label {t001.i}
          effdate      colon 18 effdate1 colon 49 label {t001.i}
          select_type  colon 18 skip (1)
          summary      colon 25
          gltrans      colon 25
          base_rpt     colon 25
          mixed_rpt    colon 25
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
             ar_nbr format "X(8)"
             type column-label {&ardrrp_p_17}
             ar_bill column-label {&ardrrp_p_8}
             name column-label {&ardrrp_p_14} format "x(24)"
             ar_date column-label {&ardrrp_p_7}
    /*       ar_contested column-label {&ardrrp_p_11}*/
    /*         ar_entity format "X(4)"*/
             ar_acct column-label {&ardrrp_p_11}
             ar_cc no-label
             ar_cr_terms
                     column-label {&ardrrp_p_1}   /* added Dunning Level */
             ar_curr column-label {&ardrrp_p_4}
   /*         disp_curr */
             base_amt column-label  {&ardrrp_p_2}format "->>,>>>,>>9.99"
          with STREAM-IO /*GUI*/  frame c width 132 down.

           FORM /*GUI*/ 
             space(10)
             ard_entity
             ard_acct
             ard_cc no-label
             ard_project
             base_damt
             ard_desc
          with STREAM-IO /*GUI*/  frame d width 132 down.

          FORM /*GUI*/ 
          batch_title  to 108  no-label
          ar_amt       colon 110
          ar_applied   colon 110
          with STREAM-IO /*GUI*/  frame e side-labels  width 132 no-attr-space.

          find first gl_ctrl no-lock.

          base_amt_fmt = base_amt:format in frame c.
          {gprun.i ""gpcurfmt.p"" "(input-output base_amt_fmt,
                                    input gl_rnd_mthd)"}
          curr_amt_old = base_amt:format in frame c.
          oldcurr = "".
          oldsession = SESSION:numeric-format.

          {wbrp01.i}

          
/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:


             find first ap_wkfl no-error.
             if available ap_wkfl then for each ap_wkfl EXCLUSIVE-LOCK:
                delete ap_wkfl.
             end.

             if batch1 = hi_char then batch1 = "".
             if nbr1 = hi_char then nbr1 = "".
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


         {wbrp06.i &command = update
                   &fields = "  batch batch1
                                nbr nbr1
                                cust cust1
                                entity entity1
                                ardate ardate1
                                effdate effdate1
                                select_type summary
                                gltrans base_rpt
                                mixed_rpt"
                   &frm = "a"}

         if (c-application-mode <> 'web':u) or
         (c-application-mode = 'web':u and
         (c-web-request begins 'data':u)) then do:

             bcdparm = "".
             {mfquoter.i batch    }
             {mfquoter.i batch1   }
             {mfquoter.i nbr      }
             {mfquoter.i nbr1     }
             {mfquoter.i cust     }
             {mfquoter.i cust1    }
             {mfquoter.i entity   }
             {mfquoter.i entity1  }
             {mfquoter.i ardate   }
             {mfquoter.i ardate1  }
             {mfquoter.i effdate  }
             {mfquoter.i effdate1 }
             {mfquoter.i select_type}
             {mfquoter.i summary  }
             {mfquoter.i gltrans  }
             {mfquoter.i base_rpt}
             {mfquoter.i mixed_rpt}

             if batch1 = "" then batch1 = hi_char.
             if nbr1 = "" then nbr1 = hi_char.
             if cust1 = "" then cust1 = hi_char.
             if entity1 = "" then entity1 = hi_char.
             if ardate = ? then ardate = low_date.
             if ardate1 = ? then ardate1 = hi_date.
             if effdate = ? then effdate = low_date.
             if effdate1 = ? then effdate1 = hi_date.
             /* VALIDATE SELECT TYPE */
             if select_type <> "" and (lookup(select_type,"M,I,F") = 0) then do:
                {mfmsg.i 1172 3}

                if c-application-mode = 'web':u then return.
                else /*GUI NEXT-PROMPT removed */
                /*GUI UNDO removed */ RETURN ERROR.
             end.

         end.

             /* SELECT PRINTER */
             
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:
find first gl_ctrl no-lock.
find first ap_wkfl no-error.



             {mfphead2.i}

             FORM /*GUI*/  header
             skip(1)
             with STREAM-IO /*GUI*/  frame a1 page-top width 132.
             view frame a1.

             /* DELETE GL WORKFILE ENTRIES */
             if gltrans = yes then do:
                for each gltw_wkfl where gltw_userid = mfguser exclusive-lock:
/*L01K*/           {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
                             "(input gltw_wkfl.gltw_exru_seq)" }
                   delete gltw_wkfl.
                end.
             end.
             for each ar_mstr where (ar_batch >= batch) and
                                    (ar_batch <= batch1) and
                                    (ar_nbr  >= nbr) and (ar_nbr <= nbr1) and
                                    (ar_bill >= cust) and (ar_bill <= cust1) and
                                    (ar_entity >= entity) and
                                    (ar_entity <= entity1) and
                                    (ar_date >= ardate) and
                                    (ar_date <= ardate1) and
                                    (ar_effdate >= effdate) and
                                    (ar_effdate <= effdate1) and
                                    (ar_type <> "P") and
                                    (ar_type <> "D") and
                                    (ar_type <> "A") and
                                    (select_type = "" or ar_type = select_type)
                                    and (ar_curr = base_rpt or
                                    base_rpt = "")
                                    no-lock break by ar_batch by ar_nbr
                                    with frame c width 132 down :

               if (oldcurr <> ar_curr) or (oldcurr = "") then do:
/*L01K*            {gpcurmth.i */
/*L01K*                 "ar_curr" */
/*L01K*                 "2" */
/*L01K*                 "next" */
/*L01K*                 "pause" } */
/*L01K*/           if ar_curr = gl_base_curr then
/*L01K*/              rndmthd = gl_rnd_mthd.
/*L01K*/           else do:
/*L01K*/              /* GET ROUNDING METHOD FROM CURRENCY MASTER */
/*L01K*/              {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                       "(input ar_curr,
                         output rndmthd,
                         output mc-error-number)"}
                      if mc-error-number <> 0 then do:
/*L01K*/                 {mfmsg.i mc-error-number 2}
/*L01K*/                 if c-application-mode <> "WEB":U then
/*L01K*/                    next.
/*L01K*/                 pause.
/*L01K*/              end.
/*L01K*/           end.

                   /* DETERMINE CURRENCY DISPLAY AMERICAN OR EUROPEAN       */
                   find rnd_mstr where rnd_rnd_mthd = rndmthd no-lock no-error.
                   if not available rnd_mstr then do:
                      {mfmsg.i 863 2}    /* ROUND METHOD RECORD NOT FOUND */
                      if c-application-mode = 'web':u then return.
                      next.
                   end.
                   /* ASSUME START UP SESSION IS FOR BASE CURR */
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

                   oldcurr = ar_curr.
                   curr_amt_fmt = curr_amt_old.
                   {gprun.i ""gpcurfmt.p"" "(input-output curr_amt_fmt,
                                             input rndmthd)" }
                end.

                /* CONVERT CURRENCY TO BASE IF APPROPRIATE */
                if base_curr = ar_curr or base_rpt = ar_curr then do:
                   /* NO CONVERSION */
                   base_amt = ar_amt.
                   base_applied = ar_applied.
                   disp_curr = " ".
                end.
                else do:
                   /* CONVERSION */
/*L01K*            USE ar_base_amt FOR BASE EQUIVALENT OF ar_amt AND
*                      ar_base_applied FOR BASE EQUIVALENT OF ar_applied.
*                  base_amt = ar_amt / ar_ex_rate.
*                  base_applied = ar_applied / ar_ex_rate.
*                  /* ROUND PER BASE ROUND METHOD */
*                  {gprun.i ""gpcurrnd.p"" "(input-output base_amt,
*                     input gl_rnd_mthd)"}
*                  /* ROUND PER BASE ROUND METHOD */
*                  {gprun.i ""gpcurrnd.p"" "(input-output base_applied,
*                     input gl_rnd_mthd)"}
**L01K*/
                   assign base_amt = ar_base_amt.
                          base_applied = ar_base_applied.
                   disp_curr = "Y".
                end.

                if base_rpt = ""
                and mixed_rpt
                then disp_curr = "".

                /* BLOCK MOVED FROM BELOW */
                /* STORE TOTALS, BY CURRENCY, IN WORK FILE. */
                if base_rpt = ""
                and mixed_rpt
                then do:
                   find first ap_wkfl where ar_curr = apwk_curr no-error.
                   /* IF RECORD FOR THIS CURRENCY NON-EXISTENT, CREATE ONE */
                   if not available ap_wkfl then do:
                      create ap_wkfl.
                      apwk_curr = ar_curr.
                   end.

                   /* ACCUMULATE INDIVIDUAL CURRENCY TOTALS IN WORK FILE */
                   apwk_for = apwk_for + ar_amt.
                   if base_curr <> ar_curr then
                      apwk_base = apwk_base + base_amt.
                   else apwk_base = apwk_for.
                end.
                /* END BLOCK MOVE */

                accumulate base_amt (total by ar_batch).
                accumulate base_applied (total by ar_batch).

                if first-of(ar_batch) then display ar_batch with frame b
                   side-labels STREAM-IO /*GUI*/ .
                find ad_mstr where ad_addr = ar_bill no-lock no-wait no-error.
                if available ad_mstr then name = ad_name.
                else name = "".
                if ar_type = "M" then type = {&ardrrp_p_6}.
                else if ar_type = "I" then type = {&ardrrp_p_9}.
                else if ar_type = "F" then type = {&ardrrp_p_3}.
                else type = "".

                 display
                    ar_nbr
                    type
                    ar_bill
                    name
                    ar_date
           /*       ar_contested */
              /*      ar_entity */
                    ar_acct
                    ar_cc
                    ar_cr_terms
                    ar_curr
              /*    disp_curr*/
                 with frame c STREAM-IO /*GUI*/ .

                /* IF BASE_RPT IS BLANK, AMOUNTS DISPLAYED IN ORIGINAL CURR   */
                /* ADDED DISP_BASE & DISP_APPLIED SO THAT THESE FIELDS COULD  */
                /* DISPLAY THE APPROPRIATE AMOUNTS WITHOUT OVERRIDING BASE_AMT*/
                /* AND BASE_APPLIED                                           */
                if base_rpt = ""
                and mixed_rpt
                then do:
                   base_amt:format in frame c = curr_amt_fmt.
                   disp_amt = ar_amt.
                   disp_applied = ar_applied.
                end.
                else do:
                   base_amt:format in frame c = base_amt_fmt.
                   disp_amt = base_amt.
                   disp_applied = base_applied.
                end.

                display
                   disp_amt  format "->>,>>>,>>9.99"@ base_amt
                with frame c STREAM-IO /*GUI*/ .
                down 1 with frame c.

/*L01K*          USE mc-ex-rate-output ROUTINE TO GET THE RATES FOR DISPLAY */
/*L01K*/         {gprunp.i "mcui" "p" "mc-ex-rate-output"
                    "(input ar_curr,
                      input base_curr,
                      input ar_ex_rate,
                      input ar_ex_rate2,
                      input ar_exru_seq,
                      output ex_rate_relation1,
                      output ex_rate_relation2)"}

/*L01K*         display ar_po @ name ar_effdate @ ar_date ar_ent_ex  @ ar_curr  */
/*L01K*/        display ex_rate_relation1 @ name ar_effdate @ ar_date
                   ar_cust @ ar_bill 
                   disp_applied @ base_amt
                   string(ar_dun_level) @ ar_cr_terms
                   disp_curr @ ar_curr
                   ar_entity @ ar_acct
                with frame c STREAM-IO /*GUI*/ .
                down 1 with frame c.
                

/*       if ex_rate_relation2 <> "" then */
/*L0          do: */
/*L01K*/             display ex_rate_relation2 @ name ar_contested @ ar_acct  
                              ar_tax_date @ ar_date  with frame c STREAM-IO /*GUI*/ .
/*L01K*/             down 1 with frame c.
/*L01           end. */



/*L0*/        if ar_po <>  "" then
/*L01K*/          do:
/*L01K*/            display ar_po @ name with frame c STREAM-IO /*GUI*/ .
/*L01K*/            down 1 with frame c.
/*L01*/           end.

                if gltrans then do:
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
                          gltw_desc = ar_batch + " " + ar_type + " " + ar_nbr +
                             " " + ar_bill
                          gltw_amt = base_amt.
                   recno = recid(gltw_wkfl).
                end.

                /* GET AR DETAIL  */
                for each ard_det where ard_nbr = ar_nbr and
                                       ard_ref = "" no-lock
                                       by ard_acct with frame d width 132:

                   if ar_curr = base_curr or ar_curr = base_rpt then
                   do:
                      base_damt:format in frame d = curr_amt_fmt.
                      base_damt = ard_amt.
                   end.
                   else do:
/*L01K*               base_damt = ard_amt / ar_ex_rate. */
/*L01K*/              /* CONVERT FROM FOREIGN TO BASE CURRENCY */
/*L01K*/              {gprunp.i "mcpl" "p" "mc-curr-conv"
                       "(input ar_curr,
                         input base_curr,
                         input ar_ex_rate,
                         input ar_ex_rate2,
                         input ard_amt,
                         input true, /* ROUND */
                         output base_damt,
                         output mc-error-number)"}.
/*L01K*/                if mc-error-number <> 0 then do:
/*L01K*/                   {mfmsg.i mc-error-number 4}.
/*L01K*/                end.
/*L01K*               ROUNDING DONE BY mc-curr-conv
*                     /* ROUND PER BASE ROUND METHOD */
*                     {gprun.i ""gpcurrnd.p"" "(input-output base_damt,
*                        input gl_rnd_mthd)"}
**L01K*/
                      base_damt:format in frame d = base_amt_fmt.
                   end.

                   if not summary then do:
                      display
                         ard_entity
                         ard_acct
                         ard_cc
                         ard_project
                      with frame d STREAM-IO /*GUI*/ .

                      if base_rpt = ""
                      and mixed_rpt
                      then
                      do:
                         base_damt:format in frame d = curr_amt_fmt.
                         display ard_amt @ base_damt ard_desc
                         with frame d STREAM-IO /*GUI*/ .
                      end.
                      else
                      do:
                         base_damt:format in frame d = base_amt_fmt.
                          display base_damt ard_desc
                         with frame d STREAM-IO /*GUI*/ .
                      end.
                      down with frame d.
                   end.

                   if gltrans then do:
                      {gpnextln.i &ref=ar_bill &line=return_int}
                      create gltw_wkfl.
                      assign gltw_entity = ard_entity
                             gltw_acct = ard_acct
                             gltw_cc = ard_cc
                             gltw_project = ard_project
                             gltw_date = ar_date
                             gltw_ref = ar_bill
                             gltw_line = return_int
                             gltw_effdate = ar_effdate
                             gltw_userid = mfguser
                             gltw_desc = ar_batch + " " + ar_type + " " +
                                ar_nbr + " " + ar_bill
                             gltw_amt = - base_damt.
                      recno = recid(gltw_wkfl).
                   end.
                end.

                if {txnew.i} then do:
                   undo_txdetrp = true.
                   {gprun.i  ""txdetrp.p"" "(input tax_tr_type,
                                             input ar_nbr,
                                             input tax_nbr,
                                             input col-80,
                                             input page_break)" }
                   if undo_txdetrp = true then undo, leave.
                end.

                if last-of(ar_batch) then do:
                   /* RESET SESSION TO BASE */
                   SESSION:numeric-format = oldsession.
                   /* DISPLAY BATCH TOTAL. */
                   if base_rpt = ""
                   and mixed_rpt
                   then
                   do:
                      ar_amt:format in frame e = base_amt_fmt.
                      ar_applied:format in frame e = base_amt_fmt.
                   end.
                   else
                   do:
                      ar_amt:format in frame e = curr_amt_fmt.
                      ar_applied:format in frame e = curr_amt_fmt.
                   end.

                   if page-size - line-counter < 4 then page.
                   put "" at 2.
                   put "" at 2.
                   put  "制表：__________________审核：_________________日期:__________________ " at 8.
                   page.
       /*          display
                 
                          (if base_rpt = ""
/*L098**                    then "Base" */
/*L098*/                    then {&ardrrp_p_19}
                            else base_rpt)
                           + {&ardrrp_p_13} + ar_batch + {&ardrrp_p_12}
                           @ batch_title
                           accum total by ar_batch (base_amt) @ ar_amt
                           accum total by ar_batch (base_applied) @ ar_applied
                           with frame e STREAM-IO /*GUI*/ . */

                end.

                
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/


                /* DISPLAY REPORT TOTAL */
                if last(ar_nbr) then do:
                   /* RESET SESSION TO BASE */
                   SESSION:numeric-format = oldsession.
                   down with frame e.
                   if page-size - line-counter < 2 then page.
      /*             display
                           (if base_rpt = ""
                            then {&ardrrp_p_5}
                            else base_rpt + {&ardrrp_p_10})
                           @ batch_title
                           accum total (base_amt) @ ar_amt
                           accum total (base_applied) @ ar_applied
                           with frame e STREAM-IO /*GUI*/ . */
                end.
                if (base_rpt <> "") then
                   SESSION:numeric-format = c_session.
             end. /* FOR EACH AR_MSTR */

             /* PRINT GL DISTRIBUTION */
     /*        if gltrans then do:
                page.
                SESSION:numeric-format = oldsession.
                {gprun.i ""gpglrp.p""}
             end. */

             /* IF ALL CURRENCIES, PRINT A SUMMARY REPORT BROKEN BY CURRENCY. */
  /*          if base_rpt = ""
             and mixed_rpt
             then
             do:
                SESSION:numeric-format = oldsession.
                {gprun.i ""gpacctp.p""}.
             end. */

             /* REPORT TRAILER */ 

             
/*GUI*/ /*{mfguitrl.i} Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/ 


             SESSION:numeric-format = oldsession.
          end.

       {wbrp04.i &frame-spec = a} 

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" batch batch1 nbr nbr1 cust cust1 entity entity1 ardate ardate1 effdate effdate1 select_type summary gltrans base_rpt mixed_rpt "} /*Drive the Report*/
