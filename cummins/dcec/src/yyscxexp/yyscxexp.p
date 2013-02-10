/* GUI CONVERTED from xxscxexp.p (converter v1.78) Thu Dec  6 12:03:47 2012   */
/* xxschimp.p - Forecast import from xls                                      */
/*V8:ConvertMode=Report                                                       */

/* DISPLAY TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "111124.1"}

{yyscxexp.i "new"}
define variable i as integer.


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
  
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
skip(.1)
   order     colon 15
   rlseid_from    colon 15
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
   if c-application-mode <> 'web' then
    prompt-for order rlseid_from with frame a
		   editing:
		  if frame-field = "order" then do:
	    	 {mfnp05.i sch_mstr sch_tnlr
         " sch_mstr.sch_domain = global_domain and sch_type  = 3 "
         sch_nbr "input order"}
         if recno <> ? then 
         		display sch_nbr @ order with frame a. 
	    end.
		  else if frame-field = "rlseid_from" then do:
		
		         /* FIND NEXT/PREVIOUS RECORD */
		         
      {mfnp05.i sch_mstr sch_tnlr
         " sch_mstr.sch_domain = global_domain and sch_type  = 3 and
         sch_nbr = input order "
         sch_rlse_id "input rlseid_from"}
		
		         if recno <> ? then 
		            display  sch_rlse_id @ rlseid_from with frame a.
		      end.
		      else do:
		         status input.
		         readkey.
		         apply lastkey.
		      end.
   end. 
  
  assign order rlseid_from. 
 	
 if order = "" or rlseid_from = "" then do:
     {mfmsg.i 40 3}
     undo,retry.
 end.
 if not can-find(first sch_mstr no-lock where sch_domain = global_domain
        and sch_type = 3 and sch_nbr = order and sch_rlse_id = rlseid_from) then do:
     {mfmsg.i 2362 3}
     undo,retry.
 end.

   /* OUTPUT DESTINATION SELECTION */

    if not can-find(first sch_mstr where sch_domain = global_domain
       and sch_type = 3 and sch_nbr = order) then do:
       {mfmsg.i 6012 3}
       undo,retry.
    end.
    {gprun.i ""yyscxexp0.p""}

end.
