
{mfdtitle.i "20121023.1"}

define variable sourcename1 as character   format "x(44)".
{gpcdget.i "UT"}

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
skip(1)
    sourcename1   colon 20 LABEL "导出文件名"
    skip(1)
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

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
sourcename1 = "c:\223.txt".

main_loop:
repeat on stop undo, leave:
/*GUI*/ if global-beam-me-up then undo, leave.
  update  sourcename1 with frame a.
  /* 读入文件 */
  output to value(sourcename1).
  for each vo_mstr where vo_domain = global_domain and vo_confirmed and 
    vo__chr01 = "SS.Lambert" and vo__chr02 = "SS.Lambert":
    put unformat  vo_ref "," vo_invoice skip.
    vo__chr02 = "".
  end.
  output close.
end.
/*GUI*/ if global-beam-me-up then undo, leave.

