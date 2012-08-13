/* GUI CONVERTED from rsshmt.p (converter v1.69) Thu Feb 27 09:40:34 1997 */
/* rsshmt.p - Release Management Supplier Schedules                     */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* H074* changes  made here should be applied to posmrc.p               */
/* REVISION: 7.3    LAST MODIFIED: 10/12/92           BY: WUG *G462*    */
/* REVISION: 7.3    LAST MODIFIED: 06/01/93           BY: WUG *GB46*    */
/* REVISION: 7.4    LAST MODIFIED: 01/05/94           BY: dpm *H074*    */
/* REVISION: 7.3    LAST MODIFIED: 04/20/94           BY: WUG *GJ47*    */
/* REVISION: 7.3    LAST MODIFIED: 07/15/94           BY: WUG *GK73*    */
/* REVISION: 8.5    LAST MODIFIED: 11/21/94           BY: mwd *J034*    */
/* REVISION: 8.5    LAST MODIFIED: 01/19/95           BY: taf *J038*    */
/* REVISION: 7.4    LAST MODIFIED: 05/10/95           BY: dxk *G0MC*    */
/* REVISION: 7.4    LAST MODIFIED: 08/02/95           BY: vrn *G0TF*    */
/* REVISION: 7.4    LAST MODIFIED: 12/14/95           BY: kjm *G1G8*    */
/* REVISION: 8.5    LAST MODIFIED: 02/27/96    BY: *J0CV* Robert Wachowicz*/
/* REVISION: 8.5    LAST MODIFIED: 03/08/96           BY: vrn *G1NV*    */
/* REVISION: 8.5    LAST MODIFIED: 02/24/97           BY: *G2L4* Ajit Deodhar */

         /* SHIPPER MAINT */

         {mfdtitle.i "e+ "}

         define variable disp_abs_id like abs_id.
         define variable abs_recid as recid.
         define variable del-yn like mfc_logical.
         define variable deassign like mfc_logical.
         define buffer abs_mstr_cont for abs_mstr.
         define buffer abs_mstr_par for abs_mstr.
         define variable old_gwt like pt_net_wt.
         define variable old_nwt like pt_net_wt.
         define variable old_vol like abs_vol.
         define variable diff_gwt like pt_net_wt.
         define variable diff_nwt like pt_net_wt.
         define variable diff_vol like abs_vol.
         define variable wt_conv as dec.
         define variable vol_conv as dec.
         define shared variable global_recid as recid.
         define variable last_shipfrom as character.                                   /*GJ47*/
         define variable last_id as character.                                         /*GJ47*/
/*G2L4** /*G1G8*/ define variable cont-yn	like mfc_logical initial no.*/
/*G1NV*/ define variable dummy_logi	like mfc_logical no-undo.
/*G1NV*/ define variable total_received	like pod_qty_rcvd no-undo.
/*G1NV*/ define variable base_amt	like pod_pur_cost no-undo.
/*G1NV*/ define variable qty_to_rcv	as decimal no-undo.
/*G1NV*/ define variable exch_rate	like exd_rate no-undo.
/*G1NV*/ define variable warn_substruct like mfc_logical no-undo.
/*G1NV*/ define new shared workfile work_abs_mstr like abs_mstr.

/*G1NV*	
.         form
./*J0CV      abs_shipfrom         colon 20 label "Supplier" */
./*J0CV*/    abs_shipfrom   colon 12 label "Supplier"
./*J0CV*/    abs_shp_date   colon 36
.            ad_name
./*J0CV         at 45 no-label  */
./*J0CV*/       at 49 no-label
./*J0CV      abs_id         colon 20 label "Shipper ID" format "x(12)" */
./*J0CV*/    abs_id         colon 12 label "Shipper ID" format "x(12)"
.            ad_line1
./*J0CV         at 45 no-label  */
./*J0CV*/       at 49 no-label
.         with frame a side-labels width 80 attr-space.
.
.         form
.            abs_shipto           colon 20 label "Ship-To"
.            si_desc              at 45 no-label
.         with frame b side-labels width 80 attr-space.
.*G1NV*/

/*G1NV*  Defined form with abs_mstr qualification */

/*G1NV*/ 
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
/*G1NV*/    
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
abs_mstr.abs_shipfrom   colon 12 label "供应商"
/*G1NV*/    abs_mstr.abs_shp_date   colon 36
/*G1NV*/    ad_name		    at 49 no-label
/*G1NV*/    abs_mstr.abs_id         colon 12 label "货运单标志" format "x(12)"
/*G1NV*/    ad_line1		    at 49 no-label
/*G1NV*/  SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/*G1NV*/ FORM /*GUI*/ 
/*G1NV*/    
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
abs_mstr.abs_shipto	    colon 20 label "货物发往"
/*G1NV*/    si_desc                 at 45 no-label
/*G1NV*/  SKIP(.4)  /*GUI*/
with frame b side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-b-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
 RECT-FRAME-LABEL:HIDDEN in frame b = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame b =
  FRAME b:HEIGHT-PIXELS - RECT-FRAME:Y in frame b - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME b = FRAME b:WIDTH-CHARS - .5.  /*GUI*/



/*G1NV*/ do for abs_mstr:
	    find abs_mstr where recid(abs_mstr) = global_recid
		 no-lock no-error.

	    if available abs_mstr and abs_id begins "s" and abs_type = "r"
	       then do:
	       find ad_mstr where ad_addr = abs_shipfrom no-lock.

	       disp
	       abs_shipfrom
	       substr(abs_id,2,50) @ abs_id
/*J0CV*/       abs_shp_date
	       ad_name
	       ad_line1
	       with frame a.

	       last_shipfrom = abs_shipfrom.                          /*GJ47*/
	       last_id = substr(abs_id,2,50).                         /*GJ47*/
	    end.

/*G1NV*/    find first poc_ctrl no-lock.

	    mainloop:
	    repeat:
/*GUI*/ if global-beam-me-up then undo, leave.


/*J038*/      do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.

/*J038*/        for each sr_wkfl exclusive-lock where sr_userid = mfguser:
/*J038*/           delete sr_wkfl.
/*J038*/        end.
/*J038*/        {gprun.i ""gplotwdl.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J038*/      end.
/*GUI*/ if global-beam-me-up then undo, leave.


	       do trans with frame a:
/*GUI*/ if global-beam-me-up then undo, leave.

		  prompt-for abs_shipfrom abs_id
/*J0CV*/                     abs_shp_date
		  editing:
		     if frame-field = "abs_shipfrom" then do:
/*G0MC                  "abs_id begins ""s"" "  */
			{mfnp05.i abs_mstr abs_id
			"abs_id begins ""s"" and abs_type = ""r"" "
			abs_shipfrom
			"input abs_shipfrom"}
			if recno <> ? then do:
			   find ad_mstr where ad_addr = abs_shipfrom
				no-lock no-error.

			   assign
			   disp_abs_id = substr(abs_id,2,50).

			   disp
			   abs_shipfrom
/*J0CV*/                   abs_shp_date
			   disp_abs_id @ abs_id
			   ad_name     when (available ad_mstr)
			   ""          when (not available ad_mstr) @ ad_name
			   ad_line1    when (available ad_mstr)
			   ""          when (not available ad_mstr) @ ad_line1.
			end.
		     end.
		     else
		     if frame-field = "abs_id" then do:
			global_addr = input abs_shipfrom.              /*GK73*/

/*G0MC         "abs_shipfrom = input abs_shipfrom and abs_id begins ""s"" "  */
			{mfnp05.i abs_mstr abs_id
			"abs_shipfrom = input abs_shipfrom and
			 abs_id begins ""s""
			 and abs_type = ""r"" "
			abs_id
			" ""s"" + input abs_id"}
			if recno <> ? then do:
			   find ad_mstr where ad_addr = abs_shipfrom
				no-lock no-error.

			   assign
			   disp_abs_id = substr(abs_id,2,50).

			   disp
			   abs_shipfrom
/*J0CV*/                   abs_shp_date
			   disp_abs_id @ abs_id
			   ad_name     when (available ad_mstr)
			   ""          when (not available ad_mstr) @ ad_name
			   ad_line1    when (available ad_mstr)
			   ""          when (not available ad_mstr) @ ad_line1.
			end.
		     end.
		     else do:
			status input.
			readkey.
			apply lastkey.
		     end.
		  end.

		  find vd_mstr where vd_addr = input abs_shipfrom
		       no-lock no-error.

		  if not available vd_mstr then do:
		     {mfmsg.i 2 3}
		     next-prompt abs_shipfrom.
		     undo, retry.
		  end.

		  find ad_mstr where ad_addr = input abs_shipfrom
		       no-lock no-error.

		  disp ad_name ad_line1.

		  if input abs_id = "" then do:
		     {mfmsg.i 8193 3}
		     next-prompt abs_id.
		     undo, retry.
		  end.

		  /*GJ47 ADDED FOLLOWING SECTION*/
		  if input abs_shipfrom <> last_shipfrom
		  and input abs_id = last_id
		  then do:
		     {mfmsg.i 8110 2}
		  end.

		  last_shipfrom = input abs_shipfrom.
		  last_id = input abs_id.
		  /*GJ47 END SECTION*/
	       end.
/*GUI*/ if global-beam-me-up then undo, leave.



	       do trans:
/*GUI*/ if global-beam-me-up then undo, leave.

		  find abs_mstr where abs_shipfrom = input frame a abs_shipfrom
		  and abs_id = "s" + input frame a abs_id
		  exclusive-lock no-error.

		  if not available abs_mstr then do:
		     {mfmsg.i 1 1}

		     create abs_mstr.

		     assign
		     abs_shipfrom = input frame a abs_shipfrom
		     abs_id = "s" + input frame a abs_id.

		     assign
		     abs_qty = 1
/*J0CV*              abs_shp_date = today  */
/*J0CV*/             abs_shp_date = if input frame a abs_shp_date <> ? then
/*J0CV*/                            input frame a abs_shp_date else today
		     abs_type = "r".
		  end.
/*G0TF*/          else do:
/*G0TF*/             /* IF CONFIRMED, WARN USER */
/*G2L4** /*G1G8*/    cont-yn = no. */
/*G0TF*/            if substr(abs_status,2,1) = "y" then do:
/*G2L4**
* /*G1G8**G0TF* {mfmsg.i 8190 2}  /*SHIPPER PREVIOUSLY CONFIRMED*/ */
* /*G1G8*/             {mfmsg01.i 8190 2 cont-yn}
*         	      /*SHIPPER PREVIOUSLY CONFIRMED*/
* /*G1G8*/             if not cont-yn then undo mainloop, retry.
**G2L4*/

/*G2L4*/               {mfmsg.i 8146 3}   /*SHIPPER PREVIOUSLY CONFIRMED*/
/*G2L4*/               undo mainloop, retry.
/*G0TF*/            end.
/*G0TF*/          end.

		  assign
		  global_recid = recid(abs_mstr).

		  find si_mstr where si_site = abs_shipto no-lock no-error.

		  clear frame b.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.

		  disp
		  abs_shipto
		  si_desc when (available si_mstr)
		  with frame b.

/*J034*/          if available si_mstr then do:
/*J034*/            {gprun.i ""gpsiver.p""
		      "(input si_site,
			input recid(si_mstr),
			output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/          end.
/*J034*/          else do:
/*J034*/            {gprun.i ""gpsiver.p""
		     "(input abs_shipto, input ?, output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/          end.
/*J034*/          if return_int = 0 then do:
/*J034*/             {mfmsg.i 725 3}  /* USER DOES NOT HAVE ACCESS TO SITE */
/*J034*/             undo mainloop, retry mainloop.
/*J034*/          end.

		  do for abs_mstr_par:
		     find abs_mstr_par
		     where abs_mstr_par.abs_shipfrom = abs_mstr.abs_shipfrom
		     and abs_mstr_par.abs_id = abs_mstr.abs_par_id
		     no-lock no-error.

		     if available abs_mstr_par then do:
/*G0MC                  {mfmsg02.i 8102 1 caps(abs_id)}  */
/*G0MC*/                {mfmsg02.i 8102 1 abs_id}
		     end.
		  end.

		  /*GB46 HANDLE CAN-FIND IDIOSYNCRASY WITH ADD'L CAN-FIND*/
		  if can-find(first abs_mstr_cont
		  where abs_mstr_cont.abs_shipfrom = abs_mstr.abs_shipfrom
		  and abs_mstr_cont.abs_par_id = abs_mstr.abs_id)
		  or can-find(abs_mstr_cont
		  where abs_mstr_cont.abs_shipfrom = abs_mstr.abs_shipfrom
		  and abs_mstr_cont.abs_par_id = abs_mstr.abs_id)
		  then do:
		     {mfmsg.i 8103 1}
		  end.
		  else do on error undo, retry
			  on endkey undo mainloop, retry mainloop
		  with frame b:
/*GUI*/ if global-beam-me-up then undo, leave.

		     {rsshmta.i}
		  end.
/*GUI*/ if global-beam-me-up then undo, leave.


		  abs_recid = recid(abs_mstr).
	       end.
/*GUI*/ if global-beam-me-up then undo, leave.


	       find abs_mstr where recid(abs_mstr) = abs_recid no-lock.

	       old_nwt = abs_nwt.
	       old_gwt = abs_gwt.
	       old_vol = abs_vol.


	       /* MAINTAIN CONTAINERS */

	       {gprun.i ""rsshmta.p"" "(input abs_recid)"}
/*GUI*/ if global-beam-me-up then undo, leave.



	       /* MAINTAIN ITEMS */
               {gprun.i ""zzrsshmtb.p"" "(input abs_recid)"}    /*marked by kevin,10/28/2003*/
	       {gprun.i ""zzrsshmtb.p"" "(input abs_recid)"}           /*kevin*/
/*GUI*/ if global-beam-me-up then undo, leave.


/*G1NV*/       /* EXPLODE SHIPPER TO GET ORDER DETAIL */
/*G1NV*/       for each work_abs_mstr exclusive-lock:
/*G1NV*/	   delete work_abs_mstr.
/*G1NV*/       end.
/*G1NV*/       {gprun.i ""rcsoisa.p"" "(input recid(abs_mstr))"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*G1NV*/       warn_substruct = no.

/*G1NV*/       {rsshmtt.i}

	       assign global_recid = recid(abs_mstr).
	    end.
/*GUI*/ if global-beam-me-up then undo, leave.

/*G1NV*/ end. /* do for abs_mstr */
