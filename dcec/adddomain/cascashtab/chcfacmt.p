/* GUI CONVERTED from chcfacmt.p (converter v1.71) Sun Oct 21 21:39:25 2007 */
/* chcfacmt.p - CASH FLOW ACCOUNT CODE MAINTENANCE - CAS              */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                    */
/* All rights reserved worldwide.  This is an unpublished work.           */
/*V8:ConvertMode=Maintenance                                            */
/*V8:RunMode=Character,Windows                                          */
/* REVISION: 9.1      LAST MODIFIED: 07/11/02   BY: *XXCH911 XinChao Ma   */
/* REVISION: 9.3      LAST MODIFIED: 10/11/07   BY: LinYun   ECO: *XXLY*  */
/**************************************************************************/

          /* DISPLAY TITLE */
          {mfdtitle.i "z+ "}
       {gprunpdf.i "gpglvpl" "p"}
/* ********** Begin Translatable Strings Definitions ********* */

/* ********** End Translatable Strings Definitions ********* */

         define variable del-yn       like mfc_logical initial no.
         define variable xxcf_ac_code like xcf_ac_code.
         define variable xxcf_sub like xcf_sub.
         define variable xxcf_cc like xcf_cc.
         define variable xxcf_pro like xcf_pro.
         define variable acdesc       like ac_desc.
         define variable subdesc      like sb_desc.
         define variable ccdesc      like cc_desc.
         define variable prodesc      like pj_desc.
         define variable mfgdesc      like ac_desc.
         define variable valid_acct  like mfc_logical                 no-undo.
/*XXLY*/ define variable acdesc1      like ac_desc.
/*XXLY*/ define variable subdesc1      like sb_desc.
/*XXLY*/ define variable ccdesc1      like cc_desc.
/*XXLY*/ define variable prodesc1      like pj_desc.
          /* DISPLAY SELECTION FORM */
          
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
/*XXLY*/      
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
xcf_mfg_code colon 35 acdesc1 no-label
/*XXLY*/	    xcf_mfg_sub colon 35 subdesc1 no-label
/*XXLY*/	    xcf_mfg_cc colon 35 ccdesc1 no-label
/*XXLY*/	    xcf_mfg_pro colon 35 prodesc1 no-label    	
	    xcf_ac_code colon 35 acdesc no-label
	    xcf_sub colon 35 subdesc no-label
	    xcf_cc colon 35 ccdesc no-label
	    xcf_pro colon 35 prodesc no-label
	    xcf_mfg_ac_code  colon 35 mfgdesc no-label
	    xcf_active  colon 35
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


          loopa:  do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

/*XXLY*/         prompt-for xcf_mfg_code xcf_mfg_sub xcf_mfg_cc xcf_mfg_pro xcf_ac_code xcf_sub xcf_cc xcf_pro 
                    with frame a editing:
         {mfnp01.i xcf_mstr xcf_mfg_code xcf_mfg_code xcf_mfg_code 
                 "xcf_mstr.xcf_domain = global_domain and xcf_mfg_code" xcf_cf_mfg}
	  if recno <> ? then do:
	   find ac_mstr where ac_code = xcf_mfg_code and ac_domain = global_domain no-lock no-error.
	   if available ac_mstr then acdesc1 = ac_desc.
					    else acdesc1 = "".
/*XXLY*ADD*/
 find sb_mstr where sb_sub = xcf_mfg_sub and sb_domain = global_domain no-lock no-error.
	   if available sb_mstr then subdesc1 = sb_desc.
	            else subdesc1 = "".	            
     if xcf_mfg_sub = "*" then subdesc1 = "ALL".	      
	   find first cc_mstr where cc_ctr = xcf_mfg_cc and cc_domain = global_domain no-lock no-error.
	   if available cc_mstr then ccdesc1 = cc_desc.
	            else ccdesc1 = "".	          
     if xcf_mfg_cc = "*" then ccdesc1 = "ALL".	
	   find first pj_mstr where pj_project = xcf_mfg_pro and pj_domain = global_domain no-lock no-error.
	       if available cc_mstr then prodesc1 = pj_desc. 
	            else prodesc1 = "".
     if xcf_mfg_pro = "*" then prodesc1 = "ALL".
/*XXLY*ADD*END*/
		 	 find ac_mstr where ac_code = xcf_ac_code and ac_domain = global_domain  no-lock no-error.
	       if available ac_mstr then acdesc = ac_desc.
               mfgdesc = "".
	      find first ac_mstr where ac_code = xcf_mfg_ac_code and ac_domain = global_domain no-lock no-error.
	       if available ac_mstr then mfgdesc = ac_desc. 
	      find first sb_mstr where sb_sub = xcf_sub and sb_domain = global_domain no-lock no-error.
	       if available sb_mstr then subdesc = sb_desc.
/*XXLY*/ if xcf_sub = "*" then subdesc = "ALL".	      
	      find first cc_mstr where cc_ctr = xcf_cc and cc_domain = global_domain no-lock no-error.
	       if available cc_mstr then ccdesc = cc_desc.
/*XXLY*/ if xcf_cc = "*" then ccdesc = "ALL".	      
	      find first pj_mstr where pj_project = xcf_pro and pj_domain = global_domain no-lock no-error.
	       if available cc_mstr then prodesc = pj_desc. 	       
/*XXLY*/ if xcf_pro = "*" then prodesc = "ALL".	
      
	      display     
	                  xcf_mfg_code acdesc1
	                  xcf_mfg_sub  subdesc1
	                  xcf_mfg_cc  ccdesc1
	                  xcf_mfg_pro prodesc1
	                  xcf_ac_code acdesc
	                  xcf_sub subdesc
	                  xcf_cc ccdesc
	                  xcf_pro prodesc
	                  xcf_mfg_ac_code mfgdesc
	                  xcf_active
		          with frame a.
		    end.
		  end.
  	  
/*XXLY*ADD*/
    assign xxcf_ac_code = input xcf_mfg_code
	          xxcf_sub = input xcf_mfg_sub
		        xxcf_cc = input xcf_mfg_cc 
		        xxcf_pro = input xcf_mfg_pro.
		        

	           
	  /* INITIALIZE SETTINGS */
      {gprunp.i "gpglvpl" "p" "initialize"}
      
/* VALIDATE UNCONDITIONALLY, REGARDLESS OF 36.1 */
      {gprunp.i "gpglvpl" "p" "set_always_ver" "(input true)"}
   
/* ROUTINE BELOW ACCT/SUB/CC/PROJ VALIDATION                */
      {gprunp.i "gpglvpl" "p" "validate_fullcode"
         "(input xxcf_ac_code,
           input xxcf_sub,
           input xxcf_cc,
           input xxcf_pro,
           output valid_acct)"}
           
   if valid_acct = no
      then do:
         undo.
   end. /* IF valid_acct = no  */
  
/*XXLY*ADD*END*/	
    assign xxcf_ac_code = input xcf_ac_code
	          xxcf_sub = input xcf_sub
		        xxcf_cc = input xcf_cc 
		        xxcf_pro = input xcf_pro.
    
	  /* INITIALIZE SETTINGS */
      {gprunp.i "gpglvpl" "p" "initialize"}
      
/* VALIDATE UNCONDITIONALLY, REGARDLESS OF 36.1 */
      {gprunp.i "gpglvpl" "p" "set_always_ver" "(input true)"}
   
/* ROUTINE BELOW ACCT/SUB/CC/PROJ VALIDATION                */
      {gprunp.i "gpglvpl" "p" "validate_fullcode"
         "(input xxcf_ac_code,
           input xxcf_sub,
           input xxcf_cc,
           input xxcf_pro,
           output valid_acct)"}
   if valid_acct = no
      then do:
           undo.
      end. /* IF valid_acct = no  */
    
 
		 find first xcf_mstr where xcf_mfg_code = input xcf_mfg_code 
/*XXLY*/	  	             and xcf_mfg_sub = input xcf_mfg_sub 
/*XXLY*/	  	             and xcf_mfg_cc  = input xcf_mfg_cc 
/*XXLY*/	  	             and xcf_mfg_pro = input xcf_mfg_pro 
                           and xcf_ac_code = input xcf_ac_code 
                           and xcf_sub = input xcf_sub
                           and xcf_cc = input xcf_cc
                           and xcf_pro = input xcf_pro
                           and xcf_ac_code <> input xcf_ac_code
                           and xcf_domain = global_domain exclusive-lock no-error.     
         if available xcf_mstr then do:
                   assign xcf_mfg_code
/*XXLY*/                   xcf_mfg_sub
/*XXLY*/                   xcf_mfg_cc
/*XXLY*/                   xcf_mfg_pro
                         xcf_ac_code
                         xcf_sub
                         xcf_cc
                         xcf_pro
                         xcf_ac_code.
                         xcf_domain = global_domain.
         end.            

	find first xcf_mstr where xcf_mfg_code = input xcf_mfg_code 
/*XXLY*/	  	             and xcf_mfg_sub = input xcf_mfg_sub 
/*XXLY*/	  	             and xcf_mfg_cc  = input xcf_mfg_cc 
/*XXLY*/	  	             and xcf_mfg_pro = input xcf_mfg_pro 
                           and xcf_ac_code = input xcf_ac_code 
                           and xcf_sub = input xcf_sub
                           and xcf_cc  = input xcf_cc
                           and xcf_pro = input xcf_pro
                           and xcf_ac_code = input xcf_ac_code 
                           and xcf_domain = global_domain
                               exclusive-lock no-error .
         if not available xcf_mstr then do:
                  create xcf_mstr.
                  xcf_domain = global_domain.
                  assign xcf_mfg_code
/*XXLY*/                   xcf_mfg_sub
/*XXLY*/                   xcf_mfg_cc
/*XXLY*/                   xcf_mfg_pro
                         xcf_ac_code
                         xcf_sub
                         xcf_cc
                         xcf_pro
                         xcf_ac_code.
		          display acdesc subdesc ccdesc prodesc
/*XXLY*/ 		   acdesc1 subdesc1 ccdesc1 prodesc1
			          with frame a.
          end.
        
          update xcf_mfg_ac_code xcf_active
			         go-on("F5" "CTRL-D")
			         with frame a.
     find ac_mstr where ac_code = input xcf_mfg_ac_code and ac_domain = global_domain no-lock no-error.
	          if not available ac_mstr then do:  
		    {mfmsg.i 3052 3} /* INVALID ACCT CODE */  
		    undo.
		  end. 
          if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
		      then do:
		          del-yn = no. 
		           { mfmsg01.i 11 1 del-yn }
          end.

		      if del-yn then do:
		          delete xcf_mstr.
		          next.
          end.
/*
		  /* VERIFY CASH FLOW ACCT CAN HAS ONE DEFAULT */
	  find xcf_mstr where xcf_mfg_code = input xcf_mfg_code 
/*XXLY*/	  	             and xcf_mfg_sub = input xcf_mfg_sub 
/*XXLY*/	  	             and xcf_mfg_cc  = input xcf_mfg_cc 
/*XXLY*/	  	             and xcf_mfg_pro = input xcf_mfg_pro 
                           and xcf_ac_code = input xcf_ac_code 
                           and xcf_sub = input xcf_sub
                           and xcf_cc = input xcf_cc
                           and xcf_pro = input xcf_pro
                                               and xcf_domain = global_domain no-lock no-error.
	   if not available xcf_mstr then do:
	  		   {mfmsg.i 3052 2} /* INVALID ACCT CODE */   
		    /*undo.*/
		 end.
*/
	  end.
/*GUI*/ if global-beam-me-up then undo, leave.


	  end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* repeat */

