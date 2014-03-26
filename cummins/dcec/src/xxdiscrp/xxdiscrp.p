/* GUI CONVERTED from xxdiscrp.p    Thu Mar 20 11:21:41 2014 */
/* xxdiscrp.p - discount report                              */
/*V8:ConvertMode=FullGUIReport                               */
/** 查询发票历史记录 7.13.8                                  */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE

&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT
&SCOPED-DEFINE PP_FRAME_NAME A

{mfdtitle.i "320"}

define variable bill like so_bill.
define variable bill1 like so_bill.
define variable ivdate like so_inv_date.
define variable ivdate1 like so_inv_date INITIAL TODAY.
define variable detsum  like mfc_logical format "Detail/Summary".
define variable archflnm AS CHARACTER format "x(160)" view-as fill-in size 40 by 1.
DEFINE VARIABLE ds_amt AS DECIMAL FORMAT "->>>>>>>>>>>>>>>>>>>>>>>>>>>9.9<<<<<<<<<".
DEFINE VARIABLE sum_amt as DECIMAL FORMAT "->>>>>>>>>>>>>>>>>>>>>>>>>>>9.9<<<<<<<<<".
DEFINE VARIABLE open_amt as DECIMAL FORMAT "->>>>>>>>>>>>>>>>>>>>>>>>>>>9.9<<<<<<<<<".

{xxdiscrp.i "new"}

FORM /*GUI*/
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
   bill     colon 25
   bill1    COLON 44 label "To"
   ivdate   colon 25
   ivdate1  COLON 44 label "To"
   detsum   colon 25
   archflnm colon 25
 SKIP(.4)  /*GUi*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF DEFINED(GPLABEL_I)=0 &THEN
   &IF (DEFINED(SELECTION_CRITERIA) = 0)
   &THEN " Selection Criteria "
   &ELSE {&SELECTION_CRITERIA}
   &ENDIF
&ELSE
   getTermLabel("SELECTION_CRITERIA", 25).
&ENDIF.
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
ASSIGN ivdate =DATE(1,1,YEAR( ivdate1)).
{wbrp01.i}

/*GUI*/ {mfguirpa.i false "printer" 132 " " " " " "  }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

   if bill1 = hi_char then bill1 = "".
   if ivdate = low_date then ivdate = ?.
   if ivdate1 = hi_date then ivdate1 = ?.

   if c-application-mode <> 'web' then

run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


   {wbrp06.i &command = update &fields = " bill bill1 ivdate ivdate1 detsum archflnm " &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      if bill1 = "" then bill1 = hi_char.
      if ivdate = ? then ivdate = low_date.
      if ivdate1 = ? then ivdate1 = hi_date.
   end.

   /* OUTPUT DESTINATION SELECTION */

/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i "printer" 132 " " " " " " " " }
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:


   {mfphead.i}
   empty temp-table t0 no-error.
   empty temp-table t1 no-error.
   for each idh_hist no-lock
       WHERE idh_domain = GLOBAL_domain AND idh_part = "ZK",
       EACH ih_hist NO-LOCK WHERE ih_domain = GLOBAL_domain
        and idh_inv_nbr = ih_inv_nbr
        AND ih_bill >= bill AND ih_bill <= bill1
        AND ih_inv_date >= ivdate AND ih_inv_date <= ivdate1:
       create t0.
       assign t0_bill = ih_bill
              t0_inv_date = ih_inv_date
              t0_ih_nbr = ih_inv_nbr
              t0_price = idh_price
              t0_qty_inv = -1 * idh_qty_inv
              t0_ih_amt = -1 * ( idh_price * idh_qty_inv).
       find first cm_mstr no-lock where cm_domain = global_domain
              and cm_addr = t0_bill no-error.
       if available cm_mstr then do:
          assign t0_ds_amt = decimal(cm_resale) no-error.
       end.
   end.
   FOR EACH t0 BREAK BY t0_bill BY t0_inv_date:
       IF FIRST-OF(t0_bill) THEN DO:
          ASSIGN SUM_amt = 0
                 OPEN_amt = 0.
       END.
       sum_amt = sum_amt + t0_ih_amt.
       open_amt = t0_ds_amt - sum_amt.
       t0_sum_amt = sum_amt.
       t0_open_amt = open_amt.
       IF LAST-OF(t0_bill) THEN DO:
           FIND FIRST t1 EXCLUSIVE-LOCK WHERE t1_bill = t0_bill NO-ERROR.
           IF NOT AVAILABLE t1 THEN DO:
                CREATE t1.
                ASSIGN t1_bill = t0_bill
                       t1_ds_amt = t0_ds_amt
                       t1_sum_amt = SUM_amt
                       t1_open_amt = OPEN_amt.
           END.
       END.
   END.

   if opsys <> "unix" and archflnm <> "" then do:
      if detsum then do:
         {gprun.i ""xxdiscrpd.p"" "(input archflnm)"}
      end.
      else do:
         {gprun.i ""xxdiscrps.p"" "(input archflnm)"}
      end.
   end.
   IF detsum THEN DO:
       for each t0 NO-LOCK BREAK BY t0_bill BY t0_inv_date with frame b width 320 no-attr-space:
          /* SET EXTERNAL LABELS */
          setFrameLabels(frame b:handle).
          IF FIRST-OF(t0_bill) THEN
          FIND FIRST cm_mstr NO-LOCK WHERE cm_domain = GLOBAL_domain AND cm_addr = t0_bill NO-ERROR.
          DISPLAY t0_bill cm_sort WHEN AVAILABLE cm_mstr t0_ds_amt t0_ih_nbr  t0_ih_amt t0_sum_amt t0_inv_date t0_open_amt WITH STREAM-IO.
          /*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
       end.
   END.
   else do:
       for each t1 no-lock with frame c width 320 no-attr-space:
           setFrameLabels(frame c:handle).
           FIND FIRST cm_mstr NO-LOCK WHERE cm_domain = GLOBAL_domain AND cm_addr = t1_bill NO-ERROR.
           display t1_bill cm_sort WHEN AVAILABLE cm_mstr t1_ds_amt t1_sum_amt t1_open_amt WITH STREAM-IO.
           /*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
       end.
   end.
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

end.

{wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" bill bill1 ivdate ivdate1 detsum archflnm "} /*Drive the Report*/
