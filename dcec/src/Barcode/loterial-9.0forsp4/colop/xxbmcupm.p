/* xxbmcupm.p - COPPER ITEM NUMBER PARAMETERS                            */
/* Copyright 2004 Shanghai e-Steering Inc., Shanghai , CHINA                  */
/* All rights reserved worldwide.  This is an unpublished work.         */

/* DISPLAY TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "b+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE xxbmcupm_p_1 "Copper Item Number"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
   SKIP(1) 
    icc_user1  label {&xxbmcupm_p_1}
    SKIP(1)
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

find first icc_ctrl no-lock.
FIND FIRST pt_mstr WHERE pt_part = icc_user1 NO-LOCK NO-ERROR.
 
/* IF NOT ORACLE THEN L_IS_ORACLE = NO ELSE L_IS_ORACLE = YES */
display
   icc_user1 COLON 25 FORMAT "X(18)"  
   pt_desc1  WHEN AVAILABLE pt_mstr NO-LABEL COLON 25 SKIP(1) 
with frame a.

find first icc_ctrl EXCLUSIVE-LOCK.

mainloop:
repeat:

     UPDATE icc_user1 FORMAT "x(18)" WITH FRAME a .

     FIND FIRST pt_mstr WHERE pt_part = icc_user1 NO-LOCK NO-ERROR.
     IF NOT AVAILABLE pt_mstr THEN DO:
         BELL.
         MESSAGE "Error: The Item Numbes has not exist!  Please re-enetr !" .
         UNDO, RETRY .
     END.
     ELSE DISPLAY  pt_desc1 WITH FRAME a .

END.
