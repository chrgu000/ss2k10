/* GUI CONVERTED from chcfa2mt.p (converter v1.71) Sun Oct 21 21:39:25 2007 */
/* chcfacmt.p - CASH FLOW ACCOUNT CODE MAINTENANCE - CAS              */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                    */
/* All rights reserved worldwide.  This is an unpublished work.           */
/*V8:ConvertMode=Maintenance                                            */
/*V8:RunMode=Character,Windows                                          */
/* REVISION: 9.1      LAST MODIFIED: 07/11/02   BY: *XXCH911 XinChao Ma   */
/**************************************************************************/

          /* DISPLAY TITLE */
          {mfdtitle.i "b+ "}

/* ********** Begin Translatable Strings Definitions ********* */

/* ********** End Translatable Strings Definitions ********* */

         define variable del-yn       like mfc_logical initial no.
         define variable acdesc       like ac_desc.
         define variable mfgdesc      like ac_desc.

          /* DISPLAY SELECTION FORM */
          
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
	    
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
xcf2_ac_code colon 35 acdesc no-label
	    xcf2_active  colon 35
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

          repeat:
/*GUI*/ if global-beam-me-up then undo, leave.


          loopa:  
          do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

	  prompt-for xcf2_ac_code with frame a editing:
               {mfnp.i xcf2_mstr xcf2_ac_code "xcf2_mstr.xcf2_domain = global_domain and xcf2_ac_code"
                xcf2_ac_code 
                   xcf2_ac_code xcf2_ac_code}

          if recno <> ? then do:
          find ac_mstr where ac_code = xcf2_ac_code and ac_domain = global_domain 
          no-lock no-error.
	  if available ac_mstr then acdesc = ac_desc.
               mfgdesc = "".
	/*  find ac_mstr where ac_code = xcf2_mfg_ac_code no-lock no-error.
	  if available ac_mstr then mfgdesc = ac_desc.      */
                  display xcf2_ac_code acdesc
	                  xcf2_active
		          with frame a.
	  end.
	  end.

	  /* VERIFY ACCT CODE */
	  find ac_mstr where ac_code = input xcf2_ac_code and ac_domain = global_domain 
	  no-lock no-error.
	  if not available ac_mstr then do:
		    {mfmsg.i 3052 3} /* INVALID ACCT CODE */
		    undo.
	  end.
		  acdesc =ac_desc.
		  display acdesc
			  with frame a.

	  find first xcf2_mstr where xcf2_ac_code = input xcf2_ac_code 
	           and xcf2_domain = global_domain 
                      exclusive-lock no-error.
	  if not available xcf2_mstr then do:
		     create xcf2_mstr. xcf2_domain = global_domain.
		     assign xcf2_ac_code
			    xcf2_active = yes.
          end.

	  display xcf2_ac_code
			  xcf2_active
			  with frame a.

          update xcf2_active
	   go-on("F5" "CTRL-D")
	   with frame a.

          if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
	     then do:
	     del-yn = no. 
	      { mfmsg01.i 11 1 del-yn }
          end.

	  if del-yn then do:
	     delete xcf2_mstr.
          end.

	  end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* do on error undo */
	  end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* repeat */

