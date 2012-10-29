/* GUI CONVERTED from chcfpm.p (converter v1.71) Sun Oct 21 21:39:25 2007 */
/* chcfpm.p - CAS Cash Flow MODULE CONTROL FILE MAINTENANCE             */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.           */
/*V8:ConvertMode=Maintenance                                              */
/*V8:RunMode=Character,Windows                                            */
/* REVISION: 9.2      LAST MODIFIED: 03/05/04   BY: *XXCH911 XinChao Ma   */
/**************************************************************************/

          /* DISPLAY TITLE */
          {mfdtitle.i "b+ "}

/* ********** Begin Translatable Strings Definitions ********* */

/* ********** End Translatable Strings Definitions ********* */

         define variable del-yn       like mfc_logical initial no.

         /* DISPLAY SELECTION FORM */
         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
	    
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
xcfp_active colon 45
	    xcfp_dsp_mt colon 45
	    xcfp_dsp_sub colon 45
	    /*xcfp_post_chk colon 45  */
             SKIP(.4)  /*GUI*/
with frame a width 80 side-labels attr-space NO-BOX THREE-D /*GUI*/.

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
          view frame a.

          ststatus = stline[3].
          status input ststatus.

          loopa:
          repeat on endkey undo, leave:
/*GUI*/ if global-beam-me-up then undo, leave.


	  /* FIND EX_CTRL RECORD */
	  find first xcfp_ctrl where xcfp_domain = global_domain exclusive-lock no-error.
	  if not available xcfp_ctrl then create xcfp_ctrl. xcfp_domain = global_domain.

          display xcfp_active 
		  xcfp_dsp_mt
		  xcfp_dsp_sub
                  /*xcfp_post_chk */
		  with frame a.

		  set xcfp_active
		      xcfp_dsp_mt
		      xcfp_dsp_sub
		      /*xcfp_post_chk  */
		      with frame a.



	  end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* repeat */
