/* GUI CONVERTED from chcfarmt.p (converter v1.71) Sun Oct 21 21:39:25 2007 */
/* chcfarmt.p - CASH FLOW ACCOUNT CODE RELATIONSHIP MAINTENANCE - CAS     */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                    */
/* All rights reserved worldwide.  This is an unpublished work.           */
/*V8:ConvertMode=Maintenance                                              */
/*V8:RunMode=Character,Windows                                            */
/* REVISION: 9.2      LAST MODIFIED: 03/05/04   BY: *XXCH911 XinChao Ma   */
/**************************************************************************/

          /* DISPLAY TITLE */
          {mfdtitle.i "c+ "}
{gprunpdf.i "gpglvpl" "p"}
/* ********** Begin Translatable Strings Definitions ********* */

/* ********** End Translatable Strings Definitions ********* */

         define variable del-yn       like mfc_logical initial no.
         define variable acdesc       like ac_desc.
         define variable mfgdesc      like ac_desc.
         define variable mfgcdesc     like ac_desc.
         define variable subdesc      like sb_desc.
         define variable ccdesc      like cc_desc.
         define variable prodesc      like pj_desc.
/*XXBH*/ define variable subdesc1      like sb_desc.
/*XXBH*/ define variable ccdesc1      like cc_desc.
/*XXBH*/ define variable prodesc1      like pj_desc.
         define variable xxcf_ac_code like xcf_ac_code.
         define variable xxcf_sub like xcf_sub.
         define variable xxcf_cc like xcf_cc.
         define variable xxcf_pro like xcf_pro.
         define variable valid_acct  like mfc_logical                 no-undo.
          /* DISPLAY SELECTION FORM */
          
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
xcf1_mfg_ac_code  colon 35 mfgdesc no-label
/*XXBH*/    xcf1_mfg_sub  colon 35 subdesc1 no-label        
/*XXBH*/    xcf1_mfg_cc   colon 35 ccdesc1 no-label        
/*XXBH*/    xcf1_mfg_pro  colon 35 prodesc1 no-label          
            xcf1_mfgc_ac_code colon 35 mfgcdesc no-label
            xcf1_mfgc_sub colon 35 subdesc no-label
            xcf1_mfgc_cc colon 35 ccdesc no-label
            xcf1_mfgc_pro colon 35 prodesc no-label
	    xcf1_ac_code      colon 35 acdesc no-label
	    xcf1_cf_acc       colon 35
	    xcf1_active       colon 35
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

/*XXBH*/         prompt-for xcf1_mfg_ac_code xcf1_mfg_sub xcf1_mfg_cc xcf1_mfg_pro xcf1_mfgc_ac_code xcf1_mfgc_sub xcf1_mfgc_cc xcf1_mfgc_pro xcf1_ac_code
                    with frame a editing:
         {mfnp01.i xcf1_mstr xcf1_mfg_ac_code xcf1_mfg_ac_code xcf1_mfg_ac_code 
                 "xcf1_mstr.xcf1_domain = global_domain and xcf1_mfg_ac_code" xcf1_mfg_ac_code}
	  if recno <> ? then do:
	   find ac_mstr where ac_code = xcf1_mfg_ac_code and ac_domain = global_domain no-lock no-error.
	   if available ac_mstr then mfgdesc = ac_desc.
					    else mfgdesc = "".
/*XXBH*ADD*/
     find sb_mstr where sb_sub = xcf1_mfg_sub and sb_domain = global_domain no-lock no-error.
	   if available sb_mstr then subdesc1 = sb_desc.
	            else subdesc1 = "".	            
     if xcf1_mfg_sub = "*" then subdesc1 = "ALL".	      
	   find first cc_mstr where cc_ctr = xcf1_mfg_cc and cc_domain = global_domain no-lock no-error.
	   if available cc_mstr then ccdesc1 = cc_desc.
	            else ccdesc1 = "".	          
     if xcf1_mfg_cc = "*" then ccdesc1 = "ALL".	
	   find first pj_mstr where pj_project = xcf1_mfg_pro and pj_domain = global_domain no-lock no-error.
	       if available cc_mstr then prodesc1 = pj_desc. 
	            else prodesc1 = "".
     if xcf1_mfg_pro = "*" then prodesc1 = "ALL".
/*XXBH*ADD*END*/
	   find ac_mstr where ac_code = xcf1_mfgc_ac_code and ac_domain = global_domain no-lock no-error.
	   if available ac_mstr then mfgcdesc = ac_desc.
					    else mfgcdesc = "".
     find sb_mstr where sb_sub = xcf1_mfgc_sub and sb_domain = global_domain no-lock no-error.
	   if available sb_mstr then subdesc = sb_desc.
	            else subdesc = "".	            
/*XXBH*/ if xcf1_mfgc_sub = "*" then subdesc = "ALL".	      
	   find first cc_mstr where cc_ctr = xcf1_mfgc_cc and cc_domain = global_domain no-lock no-error.
	   if available cc_mstr then ccdesc = cc_desc.
	            else ccdesc = "".	          
/*XXBH*/ if xcf1_mfgc_cc = "*" then ccdesc = "ALL".	
	   find first pj_mstr where pj_project = xcf1_mfgc_pro and pj_domain = global_domain no-lock no-error.
	       if available cc_mstr then prodesc = pj_desc. 
	            else prodesc = "".
/*XXBH*/ if xcf1_mfgc_pro = "*" then prodesc = "ALL".
	            
	   find ac_mstr where ac_code = xcf1_ac_code and ac_domain = global_domain no-lock no-error.
	   if available ac_mstr then acdesc = ac_desc.
				    else acdesc = "".

                       display xcf1_mfg_ac_code mfgdesc
/*XXBH*/                       xcf1_mfg_sub subdesc1
/*XXBH*/                       xcf1_mfg_cc ccdesc1 
/*XXBH*/                       xcf1_mfg_pro  prodesc1                      
                               xcf1_mfgc_ac_code mfgcdesc
                               xcf1_mfgc_sub subdesc 
                               xcf1_mfgc_cc ccdesc 
                               xcf1_mfgc_pro prodesc 
		               xcf1_ac_code acdesc
			             xcf1_cf_acc
			             xcf1_active
		       with frame a.
	       end.
	  end.

	  /* VERIFY ACCT CODE */
	  find ac_mstr where ac_code = input xcf1_mfg_ac_code and ac_domain = global_domain no-lock no-error.
	          if not available ac_mstr then do:
	    {mfmsg.i 3052 3} /* INVALID ACCT CODE */   
		    undo.
		  end.
		 .
		 
/*XXBH*ADD*/
    assign xxcf_ac_code = input xcf1_mfg_ac_code
	          xxcf_sub = input xcf1_mfg_sub
		        xxcf_cc = input xcf1_mfg_cc 
		        xxcf_pro = input xcf1_mfg_pro.
	  
/*XXBH*CHANGE 3* 	  if xxcf_sub = "*" then xxcf_sub = "".  
	          if xxcf_cc = "*" then xxcf_cc = "".   
	          if xxcf_pro = "*" then xxcf_pro = "".  
*XXBH*CHANGE 3*/ 	          
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
/*XXBH*ADD*END*/		 

    assign xxcf_ac_code = input xcf1_mfgc_ac_code
	          xxcf_sub = input xcf1_mfgc_sub
		        xxcf_cc = input xcf1_mfgc_cc 
		        xxcf_pro = input xcf1_mfgc_pro.
	  
/*XXBH*CHANGE 3* 	  if xxcf_sub = "*" then xxcf_sub = "".  
	          if xxcf_cc = "*" then xxcf_cc = "".   
	          if xxcf_pro = "*" then xxcf_pro = "".  
*XXBH*CHANGE 3*/ 	     

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
 		 
	  find ac_mstr where ac_code = input xcf1_ac_code and ac_domain = global_domain no-lock no-error.
	          if not available ac_mstr then do:
  
		    {mfmsg.i 3052 3} /* INVALID ACCT CODE */  
		    undo.
		  end.
		  
	  	  find xcf1_mstr where xcf1_mfg_ac_code = input xcf1_mfg_ac_code 
/*XXBH*/	  	             and xcf1_mfg_sub = input xcf1_mfg_sub 
/*XXBH*/	  	             and xcf1_mfg_cc  = input xcf1_mfg_cc 
/*XXBH*/	  	             and xcf1_mfg_pro = input xcf1_mfg_pro 
                           and xcf1_mfgc_ac_code = input xcf1_mfgc_ac_code 
                           and xcf1_mfgc_sub = input xcf1_mfgc_sub
                           and xcf1_mfgc_cc = input xcf1_mfgc_cc
                           and xcf1_mfgc_pro = input xcf1_mfgc_pro
                           and xcf1_ac_code <> input xcf1_ac_code
                           and xcf1_domain = global_domain exclusive-lock no-error.     
         if available xcf1_mstr then do:
                   assign xcf1_mfg_ac_code
/*XXBH*/                   xcf1_mfg_sub
/*XXBH*/                   xcf1_mfg_cc
/*XXBH*/                   xcf1_mfg_pro
                         xcf1_mfgc_ac_code
                         xcf1_mfgc_sub
                         xcf1_mfgc_cc
                         xcf1_mfgc_pro
                         xcf1_ac_code.
                         xcf1_domain = global_domain.
         end.                               
         find first xcf1_mstr where xcf1_mfg_ac_code = input xcf1_mfg_ac_code 
/*XXBH*/	  	             and xcf1_mfg_sub = input xcf1_mfg_sub 
/*XXBH*/	  	             and xcf1_mfg_cc  = input xcf1_mfg_cc 
/*XXBH*/	  	             and xcf1_mfg_pro = input xcf1_mfg_pro 
                           and xcf1_mfgc_ac_code = input xcf1_mfgc_ac_code 
                           and xcf1_mfgc_sub = input xcf1_mfgc_sub
                           and xcf1_mfgc_cc  = input xcf1_mfgc_cc
                           and xcf1_mfgc_pro = input xcf1_mfgc_pro
                           and xcf1_ac_code = input xcf1_ac_code 
                           and xcf1_domain = global_domain
                               exclusive-lock no-error .
         if not available xcf1_mstr then do:
                  create xcf1_mstr.
                  xcf1_domain = global_domain.
                  assign xcf1_mfg_ac_code
/*XXBH*/                   xcf1_mfg_sub
/*XXBH*/                   xcf1_mfg_cc
/*XXBH*/                   xcf1_mfg_pro
                         xcf1_mfgc_ac_code
                         xcf1_mfgc_sub
                         xcf1_mfgc_cc
                         xcf1_mfgc_pro
                         xcf1_ac_code.
		          display mfgdesc mfgcdesc acdesc 
/*XXBH*/ 		  subdesc1 ccdesc1 prodesc1
			          with frame a.
          end.
        
          update xcf1_cf_acc xcf1_active
			         go-on("F5" "CTRL-D")
			         with frame a.

          if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
		      then do:
		          del-yn = no. 
		           { mfmsg01.i 11 1 del-yn }
          end.

		      if del-yn then do:
		          delete xcf1_mstr.
		          next.
          end.
/*
		  /* VERIFY CASH FLOW ACCT CAN HAS ONE DEFAULT */
	  find xcf1_mstr where xcf1_mfg_ac_code = input xcf1_mfg_ac_code 
/*XXBH*/	  	             and xcf1_mfg_sub = input xcf1_mfg_sub 
/*XXBH*/	  	             and xcf1_mfg_cc  = input xcf1_mfg_cc 
/*XXBH*/	  	             and xcf1_mfg_pro = input xcf1_mfg_pro 
                           and xcf1_mfgc_ac_code = input xcf1_mfgc_ac_code 
                           and xcf1_mfgc_sub = input xcf1_mfgc_sub
                           and xcf1_mfgc_cc = input xcf1_mfgc_cc
                           and xcf1_mfgc_pro = input xcf1_mfgc_pro
                         /*  and xcf1_cf_acc = yes   */
                           and xcf1_domain = global_domain no-lock no-error.
	   if not available xcf1_mstr then do:
	  		   {mfmsg.i 3052 2} /* INVALID ACCT CODE */   
		    /*undo.*/
		 end.
*/
	  end.
/*GUI*/ if global-beam-me-up then undo, leave.


	  end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* repeat */

