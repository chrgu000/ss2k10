/* GUI CONVERTED from rwopmmt.p (converter v1.69) Thu Apr 18 10:34:57 1996 */
/* rwopmmt.p - STANDARD OPERATION MAINTENANCE                           */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 4.0      LAST MODIFIED: 03/18/88   BY: WUG *A194*/
/* REVISION: 5.0      LAST MODIFIED: 07/06/89   BY: emb *B169*/
/* REVISION: 6.0      LAST MODIFIED: 07/17/92   BY: emb *F778*/
/* REVISION: 7.3      LAST MODIFIED: 11/10/92   BY: emb *G689*/
/* REVISION: 7.3      LAST EDIT:     02/24/93   BY: sas *G740**/
/* REVISION: 7.3      LAST EDIT:     06/02/93   BY: dzs *GB32**/
/* Oracle changes (share-locks)    09/13/94           BY: rwl *GM49*    */
/* REVISION: 8.5      LAST MODIFIED: 01/13/96   BY: *J04C* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 02/22/96   BY: *G1MB* Sue Poland   */
/* REVISION: 8.5      LAST MODIFIED: 10/16/03   BY: Kevin               */

	 /* DISPLAY TITLE */
	 {mfdtitle.i "b+ "} /*GB32*/

	 define            variable description like pt_desc1.
	 define            variable del-yn      like mfc_logical
	                   initial no.
	 define            variable opmcmmts    like mfc_logical
	                   initial no label "说明".
	 define new shared variable cmtindx     as integer.
         
         def var msg-nbr as inte.                                 /*kevin*/
         
	 /* DISPLAY SELECTION FORM */
	 
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A


FORM /*GUI*/ 
	    
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
opm_std_op     colon 30
            opm__chr01     colon 30 label "地点"                    /*kevin*/
	    opm_desc       colon 30
	    opm_wkctr      colon 30
	    opm_mch        colon 30
	    skip(1)
	    opm_setup      colon 30
	    opm_run        colon 30
	    opm_move       colon 30
	    skip(1)
	    opm_yld_pct    colon 30
	    opm_tool       colon 30
	    opm_vend       colon 30
/*G689*/    opm_mile       colon 30
/*GB32      skip(1)                      */
/*GB32*/    opm_inv_val    colon 30
	    opm_sub_cost   colon 30
	    opm_sub_lead   colon 30
	    opm_tran_qty   colon 30
	    opmcmmts       colon 30
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



	 /* DISPLAY */
	 view frame a.

	 mainloop:
	 repeat with frame a:
/*GUI*/ if global-beam-me-up then undo, leave.


	    prompt-for opm_std_op editing:
	       /* FIND NEXT/PREVIOUS RECORD */
/*J04C*	       {mfnp05.i opm_mstr opm_std_op yes opm_std_op "input opm_std_op"} */
	       /* NEXT/PREV THROUGH ONLY THE NON-SERVICE OPERATIONS */
/*J04C*/       {mfnp05.i opm_mstr opm_std_op "opm_fsm_type = "" "" "
			 opm_std_op "input opm_std_op"}

	       if recno <> ? then do:
		  display
		     opm_std_op 
		     opm__chr01                               /*kevin*/
		     opm_desc opm_wkctr opm_mch
		     opm_setup opm_run opm_move
		     opm_yld_pct opm_tool opm_vend
/*G689*/             opm_mile
/*GB32*/             opm_inv_val
		     opm_sub_cost opm_sub_lead opm_tran_qty.
		     if opm_cmtindx <> 0 then display yes @ opmcmmts.
		     else display no @ opmcmmts.
	       end.
	    end.

	    /* ADD/MOD/DELETE */
/*F778*     find opm_mstr using opm_std_op no-error. */
/*F778*/    find opm_mstr where opm_std_op = input opm_std_op no-error.
	    if not available opm_mstr then do:
/*G1MB*        ADDED THE FOLLOWING */
	       /* DON'T LET THE USER CREATE BLANK STANDARD OPERATIONS */
	       if input opm_std_op = " " then do:
		    {mfmsg.i 40 3}
		    /* BLANK NOT ALLOWED */
		    undo, retry.
	       end.	/* if input opm_std_op = " " */
/*G1MB*        END ADDED CODE */
	       {mfmsg.i 1 1}
	       create opm_mstr.
	       assign opm_std_op.
/*G689*/       opm_mile = yes.
	       opmcmmts = no.
	    end.
/*G740*/    else do:
/*J04C*	       WITH 8.5, REMOVED RELIANCE ON QAD_WKFL */
/*J04C* /*G740*/      {fsopmv.i opm_std_op 2} */
/*J04C*/       if opm_fsm_type <> " " then do:
/*J04C*/	   {mfmsg.i 7492 2}
		   /* CONTROLLED BY SERVICE/SUPPORT MODULE */
/*J04C*/       end.	/* if opm_fsm_type... */

/*added by kevin, 10/22/2003 for site control*/
	  if opm__chr01 <> "" then do:  
	    display
	       opm__chr01                                          /*kevin*/
	       opm_desc opm_wkctr opm_mch
	       opm_setup opm_run opm_move
	       opm_yld_pct opm_tool opm_vend
/*G689*/       opm_mile
/*GB32*/       opm_inv_val
	       opm_sub_cost opm_sub_lead opm_tran_qty opmcmmts.
	       
             find si_mstr no-lock where si_site = opm__chr01 no-error.
             if not available si_mstr or (si_db <> global_db) then do:
                 if not available si_mstr then msg-nbr = 708.
                 else msg-nbr = 5421.
                 {mfmsg.i msg-nbr 3}
                 undo, retry.
             end.
   
             {gprun.i ""gpsiver.p""
             "(input si_site, input recid(si_mstr), output return_int)"}             
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/          if return_int = 0 then do:
/*J034*/             {mfmsg.i 725 3}    /* USER DOES NOT HAVE */
/*J034*/                                /* ACCESS TO THIS SITE*/
/*J034*/             undo,retry.
/*J034*/          end.             
          end. /*if opm__chr01 <> ""*/
/*end added by kevin*/

/*G740*/    end. /*else do*/

	    recno = recid(opm_mstr).
	    ststatus = stline[2].
	    status input ststatus.
	    del-yn = no.

	    if opm_cmtindx <> 0 then opmcmmts = yes.
	    else opmcmmts = no.

	    display
	       opm__chr01                                          /*kevin*/
	       opm_desc opm_wkctr opm_mch
	       opm_setup opm_run opm_move
	       opm_yld_pct opm_tool opm_vend
/*G689*/       opm_mile
/*GB32*/       opm_inv_val
	       opm_sub_cost opm_sub_lead opm_tran_qty opmcmmts.


	    seta:
	    do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.
               
               if opm__chr01 = "" then disp global_site @ opm__chr01.
                
	       set 
	           opm__chr01                                      /*kevin*/
	           opm_desc opm_wkctr opm_mch opm_setup opm_run
		   opm_move opm_yld_pct opm_tool opm_vend
/*G689*/           opm_mile
/*GB32*/           opm_inv_val
		   opm_sub_cost opm_sub_lead opm_tran_qty opmcmmts
	       go-on ("F5" "CTRL-D" ).

	       /* DELETE */
	       if lastkey = keycode("F5")
	       or lastkey = keycode("CTRL-D")
	       then do:
		  del-yn = yes.
		  {mfmsg01.i 11 1 del-yn}
		  if del-yn = no then undo seta.

/*GM49*/	  for each cmt_det exclusive-lock where cmt_indx = opm_cmtindx:
		     delete cmt_det.
		  end.

		  delete opm_mstr.
		  clear frame a.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
		  del-yn = no.
		  next mainloop.
	       end.

/*added by kevin, 10/16/2003 for site control*/
                 find si_mstr no-lock where si_site = input opm__chr01 no-error.
                 if not available si_mstr or (si_db <> global_db) then do:
                     if not available si_mstr then msg-nbr = 708.
                     else msg-nbr = 5421.
                     {mfmsg.i msg-nbr 3}
                     undo, retry.
                 end.
   
                {gprun.i ""gpsiver.p""
                "(input si_site, input recid(si_mstr), output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/          if return_int = 0 then do:
/*J034*/             {mfmsg.i 725 3}    /* USER DOES NOT HAVE */
/*J034*/                                /* ACCESS TO THIS SITE*/
/*J034*/             undo,retry.
/*J034*/          end.               

                 assign global_site = opm__chr01.           /*kevin,01/17/2003*/
                 
/*end added by kevin, 10/16/2003*/

	       if not can-find (wc_mstr where wc_wkctr = opm_wkctr
	       and wc_mch = opm_mch)
	       then do:
		  {mfmsg.i 528 3}
		  next-prompt opm_mch.
		  undo, retry.
	       end.
/*G740*/       {fswcv.i &fld=opm_wkctr &type=2 &cmd="next-prompt opm_wkctr."}

/*J04C*        ADDED THE FOLLOWING */
	       if opm_vend entered and opm_vend <> " " then do:
		   find vd_mstr where vd_addr = opm_vend
		       no-lock no-error.
		   if not available vd_mstr then do:
			{mfmsg.i 2 2}
			/* NOT A VALID SUPPLIER */
		   end.	/* if not available vd_mstr */
	       end.	/* if opm_vend entered */
/*J04C*	       END ADDED CODE */
	       if opmcmmts = yes then do:
		  global_ref = string(opm_std_op).
		  cmtindx = opm_cmtindx.
		  {gprun.i ""gpcmmt01.p"" "(input ""opm_mstr"")"}
/*GUI*/ if global-beam-me-up then undo, leave.

		  opm_cmtindx = cmtindx.
		  global_ref = "".
	       end.
	    end.
/*GUI*/ if global-beam-me-up then undo, leave.

	 end.
/*GUI*/ if global-beam-me-up then undo, leave.


	 status input.
