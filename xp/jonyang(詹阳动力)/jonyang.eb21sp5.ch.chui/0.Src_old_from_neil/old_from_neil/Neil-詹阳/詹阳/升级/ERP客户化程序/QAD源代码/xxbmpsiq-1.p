/* GUI CONVERTED from bmpsiq.p (converter v1.69) Thu Oct 17 11:39:45 1996 */
/* bmpsiq.p - PRODUCT STRUCTURE INQUIRY                                       */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.       */
/*F0PN*/ /*V8:ConvertMode=Report                                              */
/* REVISION: 1.0        LAST EDIT: 06/11/86       MODIFIED BY: EMB            */
/* REVISION: 1.0        LAST EDIT: 11/03/86       MODIFIED BY: EMB *12*       */
/* REVISION: 1.0        LAST EDIT: 11/03/86       MODIFIED BY: EMB *36*       */
/* REVISION: 2.0        LAST EDIT: 03/23/87       MODIFIED BY: EMB *12*       */
/* REVISION: 2.1        LAST EDIT: 10/20/87       MODIFIED BY: WUG *A94*      */
/* REVISION: 4.0        LAST EDIT: 12/30/87                BY: WUG*A137*      */
/* REVISION: 4.0        LAST EDIT: 04/28/88       MODIFIED BY: EMB (*12*)     */
/* REVISION: 5.0        LAST EDIT: 05/03/89                BY:WUG *B098*      */
/* REVISION: 7.0        LAST EDIT: 03/23/92       MODIFIED BY: emb *F671*     */
/* Revision: 7.3        Last edit: 11/19/92             By: jcd *G345*        */
/* REVISION: 7.3        LAST EDIT: 02/24/93             BY: sas *G740*        */
/* REVISION: 7.3        LAST EDIT: 12/20/93             BY: ais *GH69*        */
/* Revision: 7.3        Last edit: 12/29/93             By: ais *FL07*        */
/* REVISION: 7.4        LAST EDIT: 01/07/94             BY: qzl *H013*        */
/* REVISION: 7.4        LAST EDIT: 05/16/94             BY: qzl *H370*        */
/* REVISION: 7.4        LAST EDIT: 08/08/94             BY: ais *FP95*        */
/* REVISION: 7.4        LAST EDIT: 08/09/94             BY: bcm *H474*        */
/* REVISION: 7.2        LAST EDIT: 01/18/94             By: qzl *F0FD*        */
/* REVISION: 8.5    LAST MODIFIED: 07/30/96  BY: *J12T* Sue Poland            */
/* REVISION: 8.5    LAST MODIFIED: 10/16/96  BY: *J168* Murli Shastri         */

/* Note: Changes made here may be desireable in fspsiq.p also. */

	 /* DISPLAY TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

	 {mfdtitle.i "++ "} /*FL07*/

	 define variable comp like ps_comp.
	 define variable level as integer.
	 define variable maxlevel as integer format ">>>" label "层次".
/*GH69*  define variable eff_date like ar_effdate.      */
/*FL07*  /*GH69*/ define variable eff_date as date column-label "As of Dt". */
/*FL07*/ define variable eff_date as date column-label "起始日".
	 define variable parent like ps_par.
	 define variable desc1 like pt_desc1.
	 define variable um like pt_um.
	 define variable phantom like mfc_logical format "Y" label "虚".
	 define variable iss_pol like pt_iss_pol format "/no".
	 define variable record as integer extent 100.
	 define variable lvl as character format "x(7)" label "层次".

/*H013*/ define variable ecmnbr    like ecm_nbr /*H474*/ label "变更单号".
/*H013*/ define variable ecmid     like wo_lot.
/*H013*/ define variable dbase     like si_db.
/*H013*/ define shared variable global_recid as recid.
/*H013*/ define buffer psmstr for ps_mstr.
/*H013*/ define variable rev like pt_rev.
/*H013*/ define variable relation like mfc_logical.

	 eff_date = today.

/*H013*/ /****************** Delete: Begin **************************
*	 form
*	    space(1)
*	    parent
*           desc1
*	    um
*	    eff_date
*	    maxlevel
*	 with frame a width 80 attr-space no-underline.
/*H013*/ ******************* Delete: End ****************************/

	 
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
	   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
parent     colon 13
	   desc1      colon 38 no-label
/*J168*	   um         colon 62 no-label */
/*J168*/   um         colon 64 no-label
	   eff_date   colon 13 label "起始日"
	   maxlevel   colon 31
	   rev        colon 51
	   ecmnbr     colon 13
	   ecmid      colon 31
	   dbase      colon 51
	 with frame a side-label width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



	 /* SET PARENT TO GLOBAL PART NUMBER */
	 parent = global_part.
	 repeat:

/*H013*/ /* update parent eff_date maxlevel with frame a editing: */
/*H013*/    update parent eff_date maxlevel rev ecmnbr ecmid dbase
/*H013*/    with frame a editing:

	       if frame-field = "parent" then do:
/*J12T*/          /* NEXT/PREV THRU 'NON-SERVICE' BOMS */
/*J12T*/          {mfnp05.i bom_mstr bom_fsm_type "bom_fsm_type = """" "
                   bom_parent "input parent"}       	
		
/*J12T* 	  {mfnp.i bom_mstr parent bom_parent parent bom_parent     */
/*J12T*		  bom_parent}                                              */

		  if recno <> ? then do:
		     parent = bom_parent.
/*J168*/             /** BEGIN DELETE SECTION **
.		     display bom_parent @ parent with frame a.
.		     find pt_mstr where pt_part = parent no-lock no-error.
.		     if available pt_mstr
.		     then display pt_desc1 @ desc1 pt_um @ um with frame a.
.		     else display bom_desc @ desc1 bom_batch_um @ um
.			with frame a.
/*J168*/             ** END DELETE SECTION **/
/*J168*              ** BEGIN ADD SECTION **/
		     display parent
                             bom_desc     @ desc1
                             bom_batch_um @ um with frame a.

                     if bom_desc = "" then do:
                        find pt_mstr where pt_part = parent no-lock no-error.
                        if available pt_mstr
                        then display pt_desc1 @ desc1 with frame a.
                     end.
/*J168*              ** END ADD SECTION **/
		     recno = ?.
		  end.
	       end.    /* if frame-field = "parent" */
/*H013*/ /******************* Added: Begin **************************/
	       else if frame-field = "ecmnbr" then do:
		  global_recid = ?.
		  {mfnp05.i ecm_mstr ecm_mstr
		  "(ecm_eff_date <> ?)"
		  ecm_nbr "input ecmnbr"}
		  if global_recid <> ? then do:
		     recno = global_recid.
		     find ecm_mstr where recid(ecm_mstr) = recno.
		     global_recid = ?.
		  end.

		  if recno <> ? then display
		     substring(ecm_nbr,1,8)  @ ecmnbr
		     substring(ecm_nbr,9,8)  @ ecmid
		     substring(ecm_nbr,17,8) @ dbase with frame a.
	       end.
/*H013*/ /****************** Added: End ****************************/
	       else do:
		  status input.
		  readkey.
		  apply lastkey.
	       end.
	    end.   /* editing */

	    desc1 = "".
	    um = "".

	    find pt_mstr use-index pt_part
	       where pt_part = parent no-lock no-error.
/*FP95*/    find bom_mstr no-lock where bom_parent = parent no-error.
/*FP95*/    if available bom_mstr then /*G740*/ do:

/*J12T* /*G740*/       {fsbomv.i bom_parent 2}  */
/*J12T*/       /* WARN USER IF A SERVICE BOM */
/*J12T*/       if bom_fsm_type = "FSM" then do:
/*J12T*/            {mfmsg.i 7487 2}    /* THIS IS AN SSM BILL OF MATERIAL.. */
/*J12T*/       end.     /* if bom_fsm_type = "FSM" */

/*FP95*/       assign um = bom_batch_um
/*F0FD* /*FP95*/  desc1 = if bom_desc <> "" then bom_desc else pt_desc1 */
/*FP95*/          parent = bom_parent.
/*F0FD*/          if bom_desc <> "" then desc1 = bom_desc.
/*F0FD*/          else if available pt_mstr then desc1 = pt_desc1.
/*FP95*/    end.
/*FP95*/    else
	    if available pt_mstr then do:
	       assign um = pt_um
		   desc1 = pt_desc1
		  parent = pt_part.
	    end.
/*FP95**    MOVED THE FOLLOWING CODE HIGHER, SO IT IS THE DEFAULT RATHER
      *     THAN PT_MSTR
      *
      *     else do:
      *        find bom_mstr no-lock where bom_parent = parent no-error.
      *        if available bom_mstr then  /*G740*/ do:
/*G740*/          {fsbomv.i bom_parent 2}
      *           assign um = bom_batch_um
      *              parent = bom_parent.
/*G740*/       end.
/*FP95*/    end.        */

/*F671*     if parent = "" then do: */
/*F671*/    if not available pt_mstr and not available bom_mstr then do:
	       hide message no-pause.
	       {mfmsg.i 17 3}
	       /* PART NUMBER DOES NOT EXIST. */
	       display desc1 um with frame a.
	       undo, retry.
	    end.

	    display parent desc1 um with frame a.

	    hide frame heading.

	    assign
	       level = 1
		comp = parent
	    maxlevel = min(maxlevel,99).

/*H013*/    /****************** Added: Begin *******************************/
	    if (ecmnbr + ecmid + dbase) <> "" then do:
	       find ecm_mstr where ecm_nbr = string(ecmnbr,"x(8)") +
	       string(ecmid,"x(8)") + string(dbase,"x(8)") no-lock no-error.
	       if not available ecm_mstr then do:
		  {mfmsg.i 5610 3}    /* ECN DOES NOT EXIST */
		  next-prompt ecmnbr with frame a.
		  undo, retry.
	       end.
	       else if available ecm_mstr and ecm_eff_date = ? then do:
		  {mfmsg.i 5685 3}    /* ECN HAS NOT BEEN INCORPORATED */
		  next-prompt ecmnbr with frame a.
		  undo, retry.
	       end.
	       eff_date = ecm_eff_date.
	    end.

	    /* SELECT PRINTER */
	    {mfselprt.i "terminal" 80}
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
.

	    if rev <> "" then do:
	       relation = no.
	       for each ecm_mstr no-lock where ecm_eff_date <> ?, each ecd_det
	       no-lock where ecd_nbr = ecm_nbr and ecd_new_rev = rev break by
	       ecm_eff_date
/*H370*/       descending: /* to find the latest effective ecn of entered rev */
		  if ecd_part = parent then do:
		     relation = yes.
		     eff_date = ecm_eff_date.
		     leave.
		  end.
	       end.
	    end.
	    else if (ecmnbr + ecmid + dbase) <> "" then do:
	       {gprun.i ""ecbmec01.p"" "(input comp, input ecm_nbr,
	       input maxlevel, output relation)"}
	    end.
/*H013*/    /******************* Added: End ********************************/


/*H013*/    if ((rev <> "" or ecmnbr + ecmid + dbase <> "") and relation) or
/*H013*/    (rev = "" and ecmnbr + ecmid + dbase = "") then do:

	    find first ps_mstr use-index ps_parcomp where ps_par = comp
	       no-lock no-error.
	    repeat with frame heading:

	       
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
                            /*G345*/

	       /*DETAIL FORM */
	       FORM /*GUI*/ 
		  lvl
		  ps_comp
		  desc1
		  ps_qty_per
		  um
		  phantom
		  ps_ps_code
		  iss_pol
	       with STREAM-IO /*GUI*/  frame heading width 80
	       no-attr-space.

	       if not available ps_mstr then do:
		  repeat:
		     level = level - 1.
		     if level < 1 then leave.
		     find ps_mstr where recid(ps_mstr) = record[level]
		     no-lock no-error.
		     comp = ps_par.
		     find next ps_mstr use-index ps_parcomp where ps_par = comp
		     no-lock no-error.
		     if available ps_mstr then leave.
		  end.
	       end.
	       if level < 1 then leave.

	       if eff_date = ? or (eff_date <> ? and
	       (ps_start = ? or ps_start <= eff_date)
	       and (ps_end = ? or eff_date <= ps_end)) then do:

		  assign um = ""
		      desc1 = ""
		    iss_pol = no
		    phantom = no.

		  find pt_mstr where pt_part = ps_comp no-lock no-error.
		  if available pt_mstr then do:
		     assign um = pt_um
			 desc1 = pt_desc1
		       iss_pol = pt_iss_pol
		       phantom = pt_phantom.
		  end.
		  else do:
		     find bom_mstr no-lock where bom_parent = ps_comp no-error.
		     if available bom_mstr then
		     assign um = bom_batch_um
			 desc1 = bom_desc.
		  end.

		  record[level] = recid(ps_mstr).
		  lvl = ".......".
		  lvl = substring(lvl,1,min(level - 1,6)) + string(level).
		  if length(lvl) > 7
		  then lvl = substring(lvl,length(lvl) - 6,7).

		  if frame-line = frame-down and frame-down <> 0
		  and available pt_mstr and pt_desc2 > ""
		  then down 1 with frame heading.
find first ro_det where ro_routing = ps_par no-lock no-error.
if not available ro_det then do:

		  display lvl ps_par ps_comp desc1
		  ps_qty_per
		  um phantom ps_ps_code iss_pol
		  with frame heading STREAM-IO /*GUI*/ .

		  if available pt_mstr and pt_desc2 > ""
		  then do with frame heading:
		     down 1.
		     display pt_desc2 @ desc1 WITH STREAM-IO /*GUI*/ .
		  end.
end.
		  if level < maxlevel or maxlevel = 0 then do:
		     comp = ps_comp.
		     level = level + 1.
		     find first ps_mstr use-index ps_parcomp where ps_par = comp
		     no-lock no-error.
		  end.
		  else do:
		     find next ps_mstr use-index ps_parcomp where ps_par = comp
		     no-lock no-error.
		  end.
	       end.
	       else do:
		  find next ps_mstr use-index ps_parcomp where ps_par = comp
		  no-lock no-error.
	       end.
	    end.
/*H013*/    end. /* End of if relation */
	    {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

	    {mfmsg.i 8 1}
	 end.
	 global_part = parent.
