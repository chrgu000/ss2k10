/* yyglout.p - gl out                                                        */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120918.1 LAST MODIFIED: 09/18/12 BY: zy                         */
/* REVISION END                                                              */
 
{mfdtitle.i "120918.1"}
&SCOPED-DEFINE PP_FRAME_NAME A
FORM
   RECT-FRAME       AT ROW 1.4 COLUMN 1.25
   RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
   SKIP(.1)
    SKIP(1)
with frame a side-labels width 80 attr-space NO-BOX THREE-D.
DEFINE VARIABLE F-a-title AS CHARACTER.
   F-a-title ="".
   RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
   RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
   FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
   RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
   RECT-FRAME:HEIGHT-PIXELS in frame a =
   frame a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
   RECT-FRAME:WIDTH-CHARS IN frame a = frame a:WIDTH-CHARS - .5.
&UNDEFINE PP_FRAME_NAME
setFrameLabels(frame a:handle).

 
/* REPORT BLOCK */
repeat:

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType                = "printer"
               &printWidth               = 80
               &pagedFlag                = " "
               &stream                   = " "
               &appendToFile             = " "
               &streamedOutputToTerminal = " "
               &withBatchOption          = "yes"
               &displayStatementType     = 1
               &withCancelMessage        = "yes"
               &pageBottomMargin         = 6
               &withEmail                = "yes"
               &withWinprint             = "yes"
               &defineVariables          = "yes"}

  
   {mfreset.i}  /* REPORT TRAILER */

end. /* REPEAT: */
 