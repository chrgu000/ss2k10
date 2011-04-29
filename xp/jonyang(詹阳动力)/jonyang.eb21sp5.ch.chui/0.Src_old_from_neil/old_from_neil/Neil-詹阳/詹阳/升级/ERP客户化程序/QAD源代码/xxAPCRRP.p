/* GUI CONVERTED from apcrrp.p (converter v1.71) Tue Oct  6 23:24:38 1998 */
/* apcrrp.p - AP CHECK RECONCILIATION REPORT                             */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.  */
/* web convert apcrrp.p (converter v1.00) Fri Oct 10 13:57:05 1997       */
/* web tag in apcrrp.p (converter v1.00) Mon Oct 06 14:17:22 1997        */
/*F0PN*/ /*K12V*/ /*V8#ConvertMode=WebReport                             */
/*V8:ConvertMode=FullGUIReport                                           */
/* REVISION: 1.0      LAST MODIFIED: 11/21/86   BY: PML                  */
/* REVISION: 6.0      LAST MODIFIED: 10/10/90   BY: mlb *D084*           */
/* REVISION: 5.0      LAST MODIFIED: 10/19/90   BY: mlb *B805*           */
/* REVISION: 7.0      LAST MODIFIED: 04/28/92   BY: mlv *F441*           */
/*                                   05/14/92   BY: mlv *F492*           */
/*                                   07/31/92   BY: mlv *F825*           */
/* REVISION: 7.3      LAST MODIFIED: 04/25/93   BY: jms *G934*           */
/* REVISION: 7.4      LAST MODIFIED: 11/29/93   BY: wep *H246*           */
/*                                   06/29/94   BY: bcm *H416*           */
/*                                   09/10/94   BY: rxm *FQ94*           */
/*                                   10/19/94   BY: had *H571*           */
/*                                   02/11/95   BY: ljm *G0DZ*           */
/*                                   07/07/95   BY: jzw *H0F8*           */
/*                                   10/31/95   BY: mys *G1BQ*           */
/* REVISION: 8.5      LAST MODIFIED: 12/24/95   by: mwd *J053*           */
/* REVISION: 8.5      LAST MODIFIED: 04/04/96   by: jzw *G1LD*           */
/* REVISION: 8.6      LAST MODIFIED: 10/02/96   by: svs *K007*           */
/*                    LAST MODIFIED: 11/19/96   by: jpm *K020*           */
/* REVISION: 8.6      LAST MODIFIED: 10/20/97   by: mur *K12V*           */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane     */
/* REVISION: 8.6E     LAST MODIFIED: 07/23/98   BY: *L03K* Jeff Wootton  */
/* REVISION: 8.6E     LAST MODIFIED: 09/09/98   BY: *J2Z3* Irine D'mello */
/* REVISION: 8.6E     LAST MODIFIED: 10/06/98   BY: *L09C* Santhosh Nair */
/* Pre-86E commented code removed, view in archive revision 1.9          */
/*************************************************************************/


/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

         {mfdtitle.i "e+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE apcrrp_p_1 "  支票总数:         "
/* MaxLen: Comment: */

&SCOPED-DEFINE apcrrp_p_2 "状态(CANCEL,VOID,OPEN)"
/* MaxLen: Comment: */

&SCOPED-DEFINE apcrrp_p_3 "     帐户: "
/* MaxLen: Comment: */

&SCOPED-DEFINE apcrrp_p_4 "银行: "
/* MaxLen: Comment: */

&SCOPED-DEFINE apcrrp_p_5 " 报表合计: "
/* MaxLen: Comment: */

&SCOPED-DEFINE apcrrp_p_6 "支票日期"
/* MaxLen: Comment: */

&SCOPED-DEFINE apcrrp_p_7 "银行合计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE apcrrp_p_8 "支票"
/* MaxLen: Comment: */

&SCOPED-DEFINE apcrrp_p_9 "支票有效期"
/* MaxLen: Comment: */

&SCOPED-DEFINE apcrrp_p_10 "支票金额"
/* MaxLen: Comment: */

&SCOPED-DEFINE apcrrp_p_11 "未兑现支票:         "
/* MaxLen: Comment: */

&SCOPED-DEFINE apcrrp_p_12 "清算有效日期"
/* MaxLen: Comment: */

&SCOPED-DEFINE apcrrp_p_13 "清算日期"
/* MaxLen: Comment: */

&SCOPED-DEFINE apcrrp_p_14 "支票日期"
/* MaxLen: Comment: */

&SCOPED-DEFINE apcrrp_p_15 "支票日期"
/* MaxLen: Comment: */

&SCOPED-DEFINE apcrrp_p_16 "起始日期"
/* MaxLen: Comment: */

&SCOPED-DEFINE apcrrp_p_17 "必须是(C)注销, (V)无效, (O)未结或置空, 请重新输入。"
/* MaxLen: Comment: */

&SCOPED-DEFINE apcrrp_p_18 "          未清金额"
/* MaxLen: Comment: */

/*L09C*/ /* REPLACED LITERAL STRING "Base" WITH PRE-PROCESSOR */
&SCOPED-DEFINE apcrrp_p_19 "基本"
/* MaxLen: 4 Comment: */

/* ********** End Translatable Strings Definitions ********* */

/*L03K*/ /* DEFINE GPRUNP VARIABLES OUTSIDE OF FULL GUI INTERNAL PROCEDURES */
/*L03K*/ {gprunpdf.i "mcpl" "p"}

         define variable detail_lines as integer.
         define variable dispcurr     as character format "x(4)".
         define variable rptdate      as date label {&apcrrp_p_16}.
         define variable out_count    as integer.
         /*V8+*/
              
         define variable nbr          as integer format ">999999"
         label {&apcrrp_p_8}.
         define variable nbr1         as integer format ">999999".
            
         define variable bank         like ck_bank.
         define variable bank1        like ck_bank.
         define variable apdate       like ap_date
            label {&apcrrp_p_6}.
         define variable apdate1      like ap_date.
         define variable stat         like ck_status initial "OPEN"
            label {&apcrrp_p_2}.
         define variable name         like ad_name.
         define variable out_amt      like ap_amt label {&apcrrp_p_18}.
         define variable base_amt     like ap_amt format "->>>>>,>>>,>>9.99".
/*J2Z3*/ define variable base_ckd_amt like ap_amt format "->>>>>,>>>,>>9.99"
/*J2Z3*/                                           no-undo.
         define variable base_out     like out_amt.
         define variable effdate      like ap_effdate
            label {&apcrrp_p_9}.
         define variable effdate1     like ap_effdate.
         define variable ckstatus     like ck_status.
         define variable clrdate      like ck_clr_date
            label {&apcrrp_p_12}.
         define variable clrdate1     like ck_clr_date.
         define variable voideff      like ck_voideff.
         define variable voideff1     like ck_voideff.
         define variable acc          like ap_acct.
         define variable acc1         like ap_acct.
         define variable base_rpt like ap_curr.
         define variable disp_base_amt like ap_amt.
         define variable remit-name    like ad_mstr.ad_name no-undo.
/*L03K*/ define variable mc-error-number like msg_nbr no-undo.


         find first gl_ctrl no-lock.

         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
bank           colon 15   bank1    label {t001.i} colon 49
            nbr            colon 15   nbr1     label {t001.i} colon 49
            apdate         colon 15   apdate1  label {t001.i} colon 49
            effdate        colon 15   effdate1 label {t001.i} colon 49
            clrdate        colon 15   clrdate1 label {t001.i} colon 49
            voideff        colon 15   voideff1 label {t001.i} colon 49
            acc            colon 15   acc1     label {t001.i} colon 49 skip(1)
            rptdate        colon 35
            stat           colon 35
               validate((index("VOID CANCEL OPEN", stat) <> 0) or stat = "",
               {&apcrrp_p_17})
            base_rpt       colon 35   dispcurr at 42 no-label
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



         {wbrp01.i}
         
/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

            if bank1    = hi_char  then bank1    = "".
            if apdate   = low_date then apdate   = ?.
            if apdate1  = hi_date  then apdate1  = ?.
            if effdate  = low_date then effdate  = ?.
            if effdate1 = hi_date  then effdate1 = ?.
            if clrdate  = low_date then clrdate  = ?.
            if clrdate1 = hi_date  then clrdate1 = ?.
            if voideff  = low_date then voideff  = ?.
            if voideff1 = hi_date  then voideff1 = ?.
            if acc1     = hi_char  then acc1     = "".

            if c-application-mode <> 'web':u then
               
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


            {wbrp06.i &command = update &fields = "  bank bank1 nbr nbr1 apdate
apdate1 effdate effdate1  clrdate clrdate1 voideff voideff1  acc acc1 rptdate   stat
base_rpt" &frm = "a"}

            if (c-application-mode <> 'web':u) or
            (c-application-mode = 'web':u and
            (c-web-request begins 'data':u)) then do:

               bcdparm = "".
               {mfquoter.i bank}
               {mfquoter.i bank1}
               {mfquoter.i nbr}
               {mfquoter.i nbr1}
               {mfquoter.i apdate}
               {mfquoter.i apdate1}
               {mfquoter.i effdate}
               {mfquoter.i effdate1}
               {mfquoter.i clrdate}
               {mfquoter.i clrdate1}
               {mfquoter.i voideff}
               {mfquoter.i voideff1}
               {mfquoter.i acc}
               {mfquoter.i acc1}
               {mfquoter.i rptdate}
               {mfquoter.i stat}
               {mfquoter.i base_rpt}

               if bank1    = "" then bank1    = hi_char.
               if nbr1     = 0  then nbr1     = 999999.
               if apdate   = ?  then apdate   = low_date.
               if apdate1  = ?  then apdate1  = hi_date.
               if effdate  = ?  then effdate  = low_date.
               if effdate1 = ?  then effdate1 = hi_date.
               if clrdate  = ?  then clrdate  = low_date.
               if clrdate1 = ?  then clrdate1 = hi_date.
               if voideff  = ?  then voideff  = low_date.
               if voideff1 = ?  then voideff1 = hi_date.
               if acc1     = "" then acc1     = hi_char.
               if rptdate  = ?  then rptdate  = today.
               display rptdate with frame a.

/*L09C**       if base_rpt = "" then display "Base" @ dispcurr with frame a. */
/*L09C*/       if base_rpt = "" then display {&apcrrp_p_19} @ dispcurr
/*L09C*/          with frame a.
               else display "" @ dispcurr with frame a.

               if (clrdate <> low_date or clrdate1 <> hi_date) and
                stat <> "" and stat <> "CANCEL" then do:
                  {mfmsg.i 2212 2} /* CLEAR DATE RANGE ENTERED, BUT CANCEL */
                                   /* STATUS NOT SELECTED */
               end.
               if (voideff <> low_date or voideff1 <> hi_date) and
                 stat <> "" and stat <> "VOID" then do:
                  {mfmsg.i 2213 2}
                  /* VOID DATE RANGE ENTERED,     */
                  /* BUT VOID STATUS NOT SELECTED */
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



            {mfphead.i}

            check_loop:
            for each ck_mstr where ck_bank >= bank and ck_bank <= bank1
                              and ck_nbr >= nbr and ck_nbr <= nbr1
                              and (stat = "" or
                                ((stat = "OPEN" and ck_status = "")
                                or (stat = "VOID" and ck_status = "VOID")
                                or (stat = "CANCEL" and ck_status = "CANCEL")))
                              and (base_rpt = "" or ck_curr = base_rpt)
                              no-lock break by ck_bank by ck_nbr
            with frame c width 132 down:

               find ap_mstr where ap_ref = ck_ref and ap_type = "CK"
                  no-lock          no-error.
               if not available ap_mstr then next check_loop.
               if ap_acct < acc or ap_acct > acc1 then
                  next check_loop.
               if ap__qad01 > "" then next check_loop. /* EXCLUDE DRAFTS */

               if first(ck_bank) then display with frame c STREAM-IO /*GUI*/ .

               if first-of(ck_bank) then do:
                  find bk_mstr where bk_code = string(ck_bank, "X(2)") no-lock
                     no-error.

                  put {&apcrrp_p_4} string(ck_bank, "X(2)").
                  if available bk_mstr then do:
                     put {&apcrrp_p_3} bk_acct bk_cc space(2)
                         bk_desc skip.
                  end.
                  put skip(1).
                  out_count = 0.
               end.

               /* FIND STATUS AT TIME OF REPORT */
               if ck_status = "" or
                  (ck_status = "VOID" and ck_voiddate > rptdate) or
                  (ck_status = "CANCEL" and ck_clr_date > rptdate)
               then ckstatus = "".
               else ckstatus = ck_status.

               if (ap_date >= apdate and ap_date <= apdate1)
                  and (ap_effdate >= effdate and ap_effdate <= effdate1)
                  and (ck_status <> "VOID" or
                  (ck_voideff >= voideff and ck_voideff <= voideff1))
                  and (ck_status <> "CANCEL" or ck_clr_date = ? or
                  (ck_clr_date >= clrdate and ck_clr_date <= clrdate1))
                  then do:
                  out_amt = 0.
                  if ck_status = "" then out_amt = ap_amt.

                  find first bk_mstr where bk_code = string(ck_bank, "X(2)")
                     no-lock no-error.
/*L03K*/          assign
                     base_amt = ap_amt
                     base_out = out_amt.
                  /* IF VOID OR CLOSED NOW, BUT WAS OPEN THEN FIND AMOUNT */
                  if ck_status <> "" and ckstatus = "" then do:
/*L03K*/             assign
                        base_amt = 0
                        base_out = 0.
                     for each ckd_det where ckd_ref = ck_ref:
/*L03K*/                assign
                           base_amt = base_amt - ckd_amt
                           base_out = base_out - ckd_amt.
                     end.
                  end.
                  else do:
                     /*IF VOID, DISPLAY ORIGINAL AMOUNT*/
                     if ck_status = "VOID" then do:
                        base_amt = 0.
                        for each ckd_det where ckd_ref = ck_ref:
                           base_amt = base_amt - ckd_amt.
                        end.
                     end.
                  end.

/*J2Z3*/          /* FOR FOREIGN CURRENCY CHECKS, CALCULATE THE CHECK     */
/*J2Z3*/          /* DETAIL IN BASE AND THEN TOTAL                        */

                  if base_rpt = "" and ck_curr <> base_curr then do:

/*L03K*              base_amt = base_amt / ck_ex_rate. */
/*J2Z3*/             base_amt = 0.
/*J2Z3*/             for each ckd_det fields (ckd_amt ckd_ref) where
/*J2Z3*/             ckd_ref = ck_ref no-lock:

/*J2Z3*/             /* CHANGED FIFTH   PARAMETER base_amt TO ckd_amt      */
/*J2Z3*/             /* CHANGED SEVENTH PARAMETER base_amt TO base_ckd_amt */
/*L03K*/             /* CONVERT FROM FOREIGN TO BASE CURRENCY */
/*L03K*/                {gprunp.i "mcpl" "p" "mc-curr-conv"
                         "(input ck_curr,
                           input base_curr,
                           input ck_ex_rate,
                           input ck_ex_rate2,
                           input ckd_amt,
                           input true, /* ROUND */
                           output base_ckd_amt,
                           output mc-error-number)"}.
/*L03K*/                if mc-error-number <> 0 then do:
/*L03K*/                   {mfmsg.i mc-error-number 2}
/*L03K*/                end.

/*J2Z3*/                base_amt = base_amt - base_ckd_amt.
/*J2Z3*/             end. /* FOR EACH ckd_det */

/*L03K*              {gprun.i ""gpcurrnd.p"" "(input-output base_amt, */
/*L03K*                 input gl_rnd_mthd)"} */

/*L03K*              base_out = base_out / ck_ex_rate. */
/*L03K*/             /* CONVERT FROM FOREIGN TO BASE CURRENCY */
/*L03K*/             {gprunp.i "mcpl" "p" "mc-curr-conv"
                      "(input ck_curr,
                        input base_curr,
                        input ck_ex_rate,
                        input ck_ex_rate2,
                        input base_out,
                        input true, /* ROUND */
                        output base_out,
                        output mc-error-number)"}.
/*L03K*/             if mc-error-number <> 0 then do:
/*L03K*/                {mfmsg.i mc-error-number 2}
/*L03K*/             end.
/*L03K*              {gprun.i ""gpcurrnd.p"" "(input-output base_out, */
/*L03K*                  input gl_rnd_mthd)"} */
                  end.
                  accumulate base_amt (total by ck_bank).
                  accumulate base_out (total by ck_bank).

                  accumulate base_amt (total by ck_bank).
                  accumulate base_out (total by ck_bank).
                  accumulate ck_nbr (count by ck_bank).
                  if ckstatus = "" then out_count = out_count + 1.
                  name = "".

                  find ad_mstr where ad_addr = ap_vend no-lock no-wait
                     no-error.
                  if available ad_mstr then name = ad_name.

                  remit-name = "".
                  {gprun.i ""apmisccr.p"" "(input ck_mstr.ck_ref,
                                            output remit-name)"}
                  if remit-name <> "" then name = remit-name.

                  display
                     ck_nbr
                     ck_type
                     ap_vend
                     name
                     space(2)
                     (- base_amt) column-label {&apcrrp_p_10}
                                  format "->>>>>,>>>,>>9.99"
                     space(2)
                     ap_acct
                     space(2)
                     ap_date      column-label {&apcrrp_p_14}
                     space(2)
                     ap_effdate   column-label {&apcrrp_p_15}
                     space (2)
                     ck_clr_date  column-label {&apcrrp_p_13}
                     space(2)
                     ck_voideff
                     space(3)
                     ckstatus WITH STREAM-IO /*GUI*/ .

                  
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/

               end.

               if last-of(ck_bank) then do:
                  disp_base_amt = accum total by ck_bank (base_amt).
                  disp_base_amt = - (disp_base_amt).
                  put "-----------------" to 66
                      skip

                      {&apcrrp_p_7} to 45
                      disp_base_amt format "->>>>>,>>>,>>9.99" to 66
                      .
                  if available bk_mstr then
                     put
                        bk_curr to 71
                        skip.

                  put {&apcrrp_p_11} out_count
                    format ">>>>>9" skip
                    {&apcrrp_p_1} accum count by ck_bank (ck_nbr)
                    format ">>>>>9" skip(1).
               end.
            end. /* CHECK_LOOP */

            put "-----------------" to 66
                skip.

            if base_rpt = "" then put
               base_curr + {&apcrrp_p_5} format "x(19)" to 45.
            else put base_rpt + {&apcrrp_p_5}  format "x(19)" to 45.

/*L03K*/    assign
               disp_base_amt = accum total (base_amt)
               disp_base_amt = - (disp_base_amt).
            put disp_base_amt format "->>>>>,>>>,>>9.99" to 66
            skip(1).
            put "" at 2.
             put "" at 2.
             put  "制表:_______________                        审批:_______________ " at 8.  

          
                       /* REPORT TRAILER */

            
/*GUI*//* {mfguitrl.i} Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/ 


         end. /* REPEAT */

         {wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" bank bank1 nbr nbr1 apdate apdate1 effdate effdate1 clrdate clrdate1 voideff voideff1 acc acc1 rptdate stat base_rpt "} /*Drive the Report*/
