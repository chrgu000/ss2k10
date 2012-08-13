
{mfdtitle.i}

DEFINE VAR effdate  LIKE gltr_eff_dt.
DEFINE VAR effdate1 LIKE gltr_eff_dt.
DEFINE VAR acct     LIKE ac_code.
DEFINE VAR acct1    LIKE ac_code.
DEFINE VAR PREV_cost LIKE sct_cst_tot LABEL "变更前成本".
DEFINE VAR MODI_cost LIKE sct_cst_tot LABEL "变更后成本".
DEFINE VAR variance  AS  DECIMAL label "差异金额" FORMAT  "->>,>>>,>>9.99".
DEFINE VAR tot_var   AS  DECIMAL FORMAT "->>,>>>,>>9.99".

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
{mfguirpa.i true "printer" 132 " " " " " "  }

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
{gpprtrpa.i "printer" 132 " " " " " " " " }

{mfphead.i}

 VARiance = 0.
 tot_var  = 0.

 FORM
     tr_effdate     LABEL "Effective"
     tr_trnbr       LABEL "Trans Nbr"
     tr_userid      LABEL "User ID"
     trgl_gl_ref    LABEL "GL ref"
     tr_part        LABEL "Item"
     tr_site        LABEL "Site"
     tr_loc         LABEL "Location"
     tr_loc_begin   LABEL "Quantity"
     PREV_cost      LABEL "Prev Cost"
     modi_cost      LABEL "Modified"
     variance       LABEL "Variance"
 WITH DOWN FRAME detail WIDTH 144 STREAM-IO.

 setFrameLabels(frame detail:handle).

 FOR EACH tr_hist
     WHERE tr_type = "CST-ADJ" AND tr_effdate >= effdate AND tr_effdate <= effdate1 NO-LOCK,
     FIRST trgl_det FIELDS(trgl_trnbr trgl_dr_acct trgl_cr_acct trgl_gl_ref)
     WHERE trgl_trnbr = tr_trnbr AND 
     ((trgl_dr_acct >= acct AND trgl_dr_acct <= acct1) OR (trgl_cr_acct >= acct AND trgl_cr_acct <= acct1)) NO-LOCK:
     modi_cost = tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_mtl_std + tr_sub_std.
     PREV_cost = modi_cost - tr_price.
     variance = tr_price * tr_loc_begin.
     tot_var = tot_var + variance.
     IF variance <> 0 THEN DO:
     DISP tr_effdate tr_trnbr tr_userid trgl_gl_ref tr_part tr_site tr_loc tr_loc_begin PREV_cost Modi_cost variance WITH DOWN FRAME detail.
     DOWN WITH FRAME detail.
     END.
 END.
 UNDERLINE variance WITH FRAME detail.
 DISP  tot_var @ variance WITH FRAME detail NO-LABEL.
 



   /* REPORT TRAILER */
   
{mfguitrl.i} /*Replace mfrtrail*/

{mfgrptrm.i} /*Report-to-Window*/


{wbrp04.i &frame-spec = a}

end procedure. /*p-report*/
{mfguirpb.i &flds=" effdate effdate1 acct acct1"} /*Drive the Report*/

