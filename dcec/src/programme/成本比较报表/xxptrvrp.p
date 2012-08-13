
{mfdtitle.i}

DEFINE VAR effdate  LIKE gltr_eff_dt.
DEFINE VAR effdate1 LIKE gltr_eff_dt.
DEFINE VAR acct     LIKE ac_code.
DEFINE VAR acct1    LIKE ac_code.

DEFINE VAR PREV_cost LIKE sct_cst_tot LABEL "变更前成本".
DEFINE VAR PREV_mtl LIKE tr_mtl_std LABEL "变更前材料".
DEFINE VAR PREV_lbr LIKE tr_lbr_std LABEL "变更前人工".
DEFINE VAR PREV_bdn LIKE tr_bdn_std LABEL "变更前附加".
DEFINE VAR PREV_ovh LIKE tr_ovh_std LABEL "变更前间接".
DEFINE VAR PREV_sub LIKE tr_sub_std LABEL "变更前外包".

DEFINE VAR MODI_cost LIKE sct_cst_tot LABEL "变更后成本".
DEFINE VAR modi_mtl  LIKE tr_mtl_std  LABEL "变更后材料".
DEFINE VAR modi_lbr  LIKE tr_lbr_std  LABEL "变更后人工".
DEFINE VAR modi_bdn  LIKE tr_bdn_std  LABEL "变更后附加".
DEFINE VAR modi_ovh  LIKE tr_ovh_std  LABEL "变更后间接".
DEFINE VAR modi_sub  LIKE tr_sub_std  LABEL "变更后外包".

DEFINE VAR variance  AS  DECIMAL label "差异金额" FORMAT  "->>,>>>,>>9.99".
DEFINE VAR tot_var   AS  DECIMAL FORMAT "->>,>>>,>>9.99".
DEFINE VAR trnbr     LIKE tr_trnbr /*S777* loop counter holder */.
DEFINE VAR prevfound AS  LOGICAL.  /*S777* loop decider holder */.

DEFINE BUFFER trhist FOR tr_hist.

/* SELECT FORM */

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
   effdate         COLON 15
   effdate1        label "To" colon 49 skip
   acct            COLON 15
   acct1           label "To" colon 49 skip

 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF (DEFINED(SELECTION_CRITERIA) = 0)
  &THEN " Selection Criteria "
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

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
{wbrp01.i}
{mfguirpa.i true "printer" 256 " " " " " "  }

PROCEDURE p-enable-ui:

   IF effdate  = low_date THEN effdate = ?.
   if effdate1 = hi_date then effdate1 = ?.
   if acct1 = hi_char    then acct1 = "".

   if c-application-mode <> 'web' then
   
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. 

procedure p-report-quote:


   {wbrp06.i &command = update &fields = "effdate effdate1 acct acct1" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".

      {mfquoter.i effdate }
      {mfquoter.i effdate1}
      {mfquoter.i acct    }
      {mfquoter.i acct1   } 
      
      IF effdate  = ?  THEN effdate = low_date.
      if effdate1 = ?  then effdate1 = hi_date.
      IF acct1    = "" THEN acct1 = hi_char.
   end.

   /* OUTPUT DESTINATION SELECTION */
   
end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

procedure p-report:
{gpprtrpa.i "printer" 300 " " " " " " " " }

{mfphead.i}

 VARiance = 0.
 tot_var  = 0.

 FORM
     tr_effdate     LABEL "生效日期"
     tr_trnbr       LABEL "事务ID"
     tr_userid      LABEL "用户代码"
     trgl_gl_ref    LABEL "总帐参考号"
     tr_part        LABEL "零件号"
     tr_site        LABEL "地点"
     tr_loc         LABEL "库位"
     tr_loc_begin   LABEL "数量"
     PREV_cost      LABEL "变更前成本"
     PREV_mtl       LABEL "变更前材料"
     PREV_lbr       LABEL "变更前人工"
     PREV_bdn       LABEL "变更前附加"
     PREV_ovh       LABEL "变更前间接"
     PREV_sub       LABEL "变更前外包"
     modi_cost      LABEL "变更后成本"
     modi_mtl       LABEL "变更后材料"
     modi_lbr       LABEL "变更后人工"
     modi_bdn       LABEL "变更后附加"
     modi_ovh       LABEL "变更后间接"
     modi_sub       LABEL "变更后外包"
     variance       LABEL "前后差异"
 WITH DOWN FRAME detail WIDTH 400 STREAM-IO.

 setFrameLabels(frame detail:handle).

 FOR EACH tr_hist FIELDS(tr_hist.tr_trnbr tr_hist.tr_type tr_hist.tr_part tr_hist.tr_trnbr tr_hist.tr_nbr 
                         tr_hist.tr_effdate tr_hist.tr_site tr_hist.tr_loc tr_hist.tr_loc_begin tr_hist.tr_price
                         tr_hist.tr_lbr_std tr_hist.tr_ovh_std tr_hist.tr_bdn_std tr_hist.tr_mtl_std tr_hist.tr_sub_std 
                         tr_hist.tr_userid )
     WHERE tr_hist.tr_type = "CST-ADJ" AND tr_hist.tr_effdate >= effdate AND tr_hist.tr_effdate <= effdate1 USE-INDEX tr_type NO-LOCK,
     EACH trgl_det FIELDS(trgl_trnbr trgl_dr_acct trgl_cr_acct trgl_gl_ref)
     WHERE trgl_trnbr = tr_hist.tr_trnbr NO-LOCK:
     IF (trgl_dr_acct >= acct AND trgl_dr_acct <= acct1) OR (trgl_cr_acct >= acct AND trgl_cr_acct <= acct1) THEN DO:
     modi_cost = tr_hist.tr_lbr_std + tr_hist.tr_ovh_std + tr_hist.tr_bdn_std + tr_hist.tr_mtl_std + tr_hist.tr_sub_std.
     PREV_cost = modi_cost - tr_hist.tr_price.
     variance = tr_price * tr_loc_begin.
     tot_var = tot_var + variance.
     IF variance <> 0 THEN DO:
     ASSIGN trnbr = tr_hist.tr_trnbr
            prevfound = NO.
     DO WHILE NOT prevfound: 
     FOR LAST trhist FIELDS(trhist.tr_trnbr trhist.tr_part trhist.tr_trnbr trhist.tr_site trhist.tr_lbr_std trhist.tr_ovh_std 
                            trhist.tr_bdn_std trhist.tr_mtl_std trhist.tr_sub_std) 
     WHERE trhist.tr_part = tr_hist.tr_part AND trhist.tr_site = tr_hist.tr_site AND trhist.tr_trnbr < trnbr USE-INDEX tr_part_trn NO-LOCK: 
     END.
     IF AVAILABLE trhist THEN do:
        IF trhist.tr_mtl_std = tr_hist.tr_mtl_std AND
           trhist.tr_lbr_std = tr_hist.tr_lbr_std AND 
           trhist.tr_bdn_std = tr_hist.tr_bdn_std AND
           trhist.tr_ovh_std = tr_hist.tr_ovh_std AND
           trhist.tr_sub_std = tr_hist.tr_sub_std 
        THEN DO:
           trnbr = trhist.tr_trnbr.
        END.
        ELSE DO:
           prevfound = YES.
        END.
     END.
     ELSE LEAVE.
     END.
     IF AVAILABLE trhist THEN DO:
        DISP tr_hist.tr_effdate tr_hist.tr_trnbr tr_hist.tr_userid trgl_gl_ref 
             tr_hist.tr_part tr_hist.tr_site tr_hist.tr_loc tr_hist.tr_loc_begin 
             PREV_cost  trhist.tr_mtl_std @ prev_mtl trhist.tr_lbr_std @ prev_lbr 
             trhist.tr_bdn_std @ PREV_bdn trhist.tr_ovh_std @ PREV_ovh trhist.tr_sub_std @ PREV_sub
             Modi_cost  tr_hist.tr_mtl_std @ modi_mtl tr_hist.tr_lbr_std @ modi_lbr 
             tr_hist.tr_bdn_std @ modi_bdn tr_hist.tr_ovh_std @ modi_ovh tr_hist.tr_sub_std @ modi_sub
             variance WITH DOWN FRAME detail WIDTH 400 STREAM-IO .
     END.
     ELSE DO:
         DISP tr_hist.tr_effdate tr_hist.tr_trnbr tr_hist.tr_userid trgl_gl_ref 
              tr_hist.tr_part tr_hist.tr_site tr_hist.tr_loc tr_hist.tr_loc_begin 
              PREV_cost  
              Modi_cost  tr_hist.tr_mtl_std @ modi_mtl tr_hist.tr_lbr_std @ modi_lbr 
              tr_hist.tr_bdn_std @ modi_bdn tr_hist.tr_ovh_std @ modi_ovh tr_hist.tr_sub_std @ modi_sub
              variance WITH DOWN FRAME detail WIDTH 400 STREAM-IO .
     END.
     DOWN WITH FRAME detail.
     END.
     END.
 END.
 UNDERLINE variance WITH FRAME detail.
 DISP  tot_var @ variance WITH FRAME detail NO-LABEL.
 

{mfguitrl.i} /*Replace mfrtrail*/

{mfgrptrm.i} /*Report-to-Window*/


{wbrp04.i &frame-spec = a}

end procedure. /*p-report*/
{mfguirpb.i &flds=" effdate effdate1 acct acct1"} /*Drive the Report*/

