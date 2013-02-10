/* GUI CONVERTED from yyscximp.p (converter v1.78) Thu Dec  6 14:46:56 2012 */
/* yyscximp.p - Forecast import from xls                                      */
/*V8:ConvertMode=Report                                                       */

/* DISPLAY TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "121205.1"}
{gplabel.i}
{yyscximp.i "new"}
define variabl i as integer.
{gpcdget.i "UT"}

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/

 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
skip(1)
   file_name colon 20
   log_file  colon 20 skip(1)
with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

find first qad_wkfl no-lock where qad_domain = global_domain
       and qad_key1 = "common-filename-list" and qad_key2 = global_userid no-error.
if available qad_wkfl then do:
   assign file_name = qad_charfld[1]
          log_file  = qad_charfld[2].
end.
repeat:
   update file_name log_file with frame a.

     IF SEARCH(FILE_name) = ? THEN DO:
         {mfmsg.i 4839 3}
         next-prompt file_name.
         undo, retry.
     END.
   find first qad_wkfl where qad_domain = global_domain
         and qad_key1 = "common-filename-list"
         and qad_key2 = global_userid no-error.
   if available qad_wkfl then do:
      if not locked(qad_wkfl) and qad_charfld[1] <> input file_name then do:
           assign qad_charfld[1] = file_name
                  qad_charfld[2] = log_file.
      end.
   end.
   else do:
      create qad_wkfl. qad_domain = global_domain.
      assign qad_key1 = "common-filename-list"
             qad_key2 = global_userid
             qad_charfld[1] = file_name
             qad_charfld[2] = log_file.
   end.
    {gprun.i ""yyscximp0.p""}
     if not can-find(first xsch_data) then do:
          {mfmsg.i 5935 1}
     end.
     else do:
         {gprun.i ""yyscximp1.p""}
     end.
     output to value(log_file).
     		display rlseid_from with frame x side-label with stream-io.
     		setFrameLabels(frame x:handle).
     for each xsch_data no-lock where xsd_upd_qty <> 0
              with width 320 frame c:
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame c:handle).
         display xsch_data WITH STREAM-IO /*GUI*/ .
     end.
     output close.
end.

