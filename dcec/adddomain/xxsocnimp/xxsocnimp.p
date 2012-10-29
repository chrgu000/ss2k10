/* GUI CONVERTED from xxsocnimp.p (converter v1.78) Fri Oct 26 19:50:23 2012 */
/* xxsocnimp.p - xxsocimimp                                                  */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120713.1 LAST MODIFIED: 07/13/12 BY: zy                         */
/* REVISION END                                                              */


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "20121020.1"}
{cxcustom.i "SOCNUAC.P"}
DEFINE NEW SHARED VAR thfile AS CHAR FORMAT "x(50)".
def new shared var bexcel as com-handle.
def new shared var bbook as com-handle.
def new shared var bsheet as com-handle.

DEFINE NEW SHARED TEMP-TABLE mytt
    FIELD f01 AS CHAR
    FIELD f02 AS CHAR
    FIELD f03 AS CHAR
    FIELD f04 AS CHAR
    FIELD f05 AS CHAR format "x(18)"
    FIELD f06 AS CHAR
    FIELD f07 AS CHAR format "x(18)"
    FIELD f08 AS CHAR format "x(18)"
    FIELD f09 AS CHAR
    FIELD f10 AS CHAR
    FIELD f11 AS CHAR
    FIELD f12 AS CHAR format "x(48)"
    .

{gpcdget.i "UT"}
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/

 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
skip(1)
   thfile colon 16
   skip(1)
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

{wbrp01.i}
repeat:
   FOR EACH mytt :
       DELETE mytt.
   END.
   if c-application-mode <> 'web' then
   update thfile with frame a.

   {wbrp06.i &command = update &fields = " thfile "
      &frm = "a"}

     IF SEARCH(thfile) = ? THEN DO:
         {mfmsg.i 4839 3}
         next-prompt thfile.
         undo, retry.
     END.

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      hide frame b.
      hide frame c.
   end.

   /*
   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "window"
               &printWidth = 320
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "no"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
   {mfmsg.i 832 1}
   {mfphead.i}
   */
   {gprun.i ""xxsocnimp01.p""}
/*
   for each mytt  with width 320 frame c:
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame c:handle).
     disp mytt.
   end.
*/
   {gprun.i ""xxsocnimp02.p""}
/*
   HIDE ALL.
   for each mytt  with width 320 frame d:
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame d:handle).
     disp mytt.
   end.
*/
   HIDE ALL.
   /*
   {mfrtrail.i}
   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}
   */
end.

{wbrp04.i &frame-spec = a}
