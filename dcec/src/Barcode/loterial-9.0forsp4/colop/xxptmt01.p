/* xxptmt01.p - Part Master for Copper Fleciable Usage                                  */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* Revision: 1.66     BY: Jyoti Thatte             DATE: 02/21/03 ECO: *P0MX* */
/* Revision: 1.67     BY: Piotr Witkowicz          DATE: 03/19/03 ECO: *P0NP* */
/* Revision: 1.68     BY: Mamata Samant            DATE: 04/08/03 ECO: *N2CM* */
/* Revision: 1.71     BY: Deepali Kotavadekar      DATE: 04/17/03 ECO: *N2CY* */
/* Revision: 1.72     BY: Orawan S.                DATE: 04/24/03 ECO: *P0Q8* */
/* Revision: 1.73     BY: Mercy Chittilapilly      DATE: 05/21/03 ECO: *P0RM* */
/* Revision: 1.73.1.1 BY: Saurabh Chaturvedi       DATE: 09/10/03 ECO: *P12R* */
/* Revision: 1.73.1.2 BY: Ashish Maheshwari        DATE: 10/30/03 ECO: *P184* */
/* Revision: 1.73.1.3 BY: Vandna Rohira            DATE: 11/03/03 ECO: *P14V* */
/* Revision: 1.73.1.4 BY: Shoma Salgaonkar         DATE: 11/24/03 ECO: *P1BW* */
/* $Revision: 1.73.1.5 $ BY: Ed van de Gevel DATE: 12/01/03 ECO: *N2G5* */
/******************************************************************************/

/*V8:ConvertMode=Maintenance                                                  */

{mfdtitle.i "2+ "}
{cxcustom.i "xxptmt01.p"}


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
   pt_part        colon 25
   pt_desc1       colon 50
   pt_um          COLON 25
   pt_desc2      COLON 50 NO-LABEL 
   pt__dec01   COLON 25 LABEL "Copper Std. Usage (BOM)" FORMAT ">>>,>>9.9<<<<<<"
   pt__dec02   COLON  25   LABEL "Copper Additional Usage " FORMAT ">>>,>>9.9<<<<<<"
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


/******* MAINLOOP: ***********************************************************
***      MAIN LOGIC SECTION                                                ***
******************************************************************************/

main-loop:
repeat with frame a:
/*GUI*/ if global-beam-me-up then undo, leave.

   prompt-for
      pt_part
   editing:
      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp.i pt_mstr pt_part pt_part pt_part pt_part pt_part}

      if recno <> ? then do:
         display
            pt_part
            pt_desc1 
             pt_um
             pt_desc2
             pt__dec01
             pt__dec02 .
      END.
       
   END.
   FIND pt_mstr WHERE pt_part = INPUT pt_part EXCLUSIVE-LOCK NO-ERROR .
   IF NOT AVAILABLE pt_mstr THEN DO:
       BELL.
       MESSAGE "The item number does not exists ! "  VIEW-AS ALERT-BOX ERROR BUTTONS OK.
       UNDO,RETRY .
   END.
   recno = recid(pt_mstr).
   DISPLAY pt__dec01 WITH FRAME a.

   ststatus = stline[2].
   status input ststatus.

   do on error undo, retry with frame a no-validate:
   /*GUI*/ if global-beam-me-up then undo, leave.

      update
        pt__dec02  FORMAT "->>>,>>>,>>9.9<<<<<<<<".

      IF pt__dec01 = 0  AND pt__dec02 <> 0  THEN DO:         
          BELL.
          MESSAGE "The standard copper usage is zero ! "  VIEW-AS ALERT-BOX ERROR BUTTONS OK.
          UNDO,RETRY .
      END.
      IF pt__dec02 < 0  AND pt__dec02 + pt__dec01 < 0 THEN DO:         
          BELL.
          MESSAGE "The additional usage is greater the standard usage  ! "  VIEW-AS ALERT-BOX ERROR BUTTONS OK.
          UNDO,RETRY .
      END.

   END.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* do on error undo, retry with frame a no-validate: */


END . /*Mian loop**/
/******* END OF MAINLOOP: ***************************************************/

status input.
