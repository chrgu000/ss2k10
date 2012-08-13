/* Revision: 1.0    BY: Jeff Wang, Atos Origin          DATE: 04/21/2004  */

/* DISPLAY TITLE */

{mfdtitle.i "2+ "}

define variable psnbr as char.
 DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
 DEFINE VARIABLE chExcelWorkbook AS COM-HANDLE.
 DEFINE VARIABLE chExcelWorksheet AS COM-HANDLE.

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
RECT-FRAME       AT ROW 1 COLUMN 1.25
RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
SKIP(.1)  /*GUI*/
    space(1)
   psnbr      colon 25 label "Òª»õµ¥ºÅ"
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

/* DISPLAY */
view frame a.
mainloop:
repeat with frame a:
    /*GUI*/ if global-beam-me-up then undo, leave.
       update psnbr
           with frame a.           
       {gprun.i ""xkpsprt.p"" "(input psnbr)" }
end.
