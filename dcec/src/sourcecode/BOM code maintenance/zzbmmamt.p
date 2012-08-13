/* GUI CONVERTED from bmmamt.p (converter v1.69) Mon Aug 12 14:05:19 1996 */
/* bmmamt.p - ADD / MODIFY BILL OF MATERIAL MASTER RECORDS                    */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.       */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                         */
/* REVISION: 7.0        LAST EDIT: 12/16/91               BY: emb             */
/* REVISION: 7.0        LAST EDIT: 03/20/92               BY: emb *F308*      */
/* REVISION: 7.0        LAST EDIT: 03/24/92               BY: pma *F089*      */
/* REVISION: 7.0        LAST EDIT: 04/29/92               BY: emb *F447*      */
/* REVISION: 7.0        LAST EDIT: 05/26/92               BY: pma *F533*      */
/* REVISION: 7.0        LAST EDIT: 06/18/92               BY: emb *F671*      */
/* REVISION: 7.0        LAST EDIT: 11/10/92               BY: pma *G309*      */
/* REVISION: 7.3        LAST EDIT: 02/24/93               BY: sas *G740*      */
/* Oracle changes (share-locks)    09/11/94               BY: rwl *FR15*      */
/* REVISION: 7.2        LAST EDIT: 10/20/94               BY: ais *FS62*      */
/* REVISION: 7.0        LAST EDIT: 06/01/95               BY: qzl *F0SL*      */
/* REVISION: 8.5    LAST MODIFIED: 07/31/96  BY: *J12T* Sue Poland          */
/* REVISION: 8.5    LAST MODIFIED: 08/06/96  BY: *G2B7* Julie Milligan      */
/* REVISION: 8.5    LAST MODIFIED: 10/16/03  BY: Kevin                  */

         /* DISPLAY TITLE */
         {mfdtitle.i "d+ "} /*G740*/

         define new shared variable comp like ps_comp.
         define new shared variable par like ps_par.
         define new shared variable level as integer.
         define new shared variable qty as decimal.
         define new shared variable parent like ps_par.
         define new shared variable ps_recno as recid.
         define variable des like pt_desc1.
         define variable des2 like pt_desc1.
         define variable um like pt_um.
         define variable del-yn like mfc_logical initial no.
         define variable pt_des1 as character format "x(49)".
         define variable rev like pt_rev.
         define variable item_no like ps_item_no.
         define buffer ps_mstr1 for ps_mstr.
/*G2B7*         define variable batch_qty like pt_batch. */
/*G2B7*/ define variable batch_qty like bom_batch.
         define variable unknown_char as character initial ?.
/*G2B7* /*D852*/ define variable batch_size like pt_batch. */
/*G2B7*/ define variable batch_size like bom_batch.
         define variable cmmts like mfc_logical initial no label "说明".
         define new shared variable cmtindx as integer.
/*F089*/ define variable ptstatus like pt_status.
/*F533*/ define variable bomdesc like bom_desc.
/*F533*/ define variable ptdesc1 like pt_desc1.
         define variable lines as integer.

         def var msg-nbr as inte.                     /*kevin*/
         
         /* DISPLAY SELECTION FORM */
         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
bom_parent     colon 27
/*F533      bom_desc colon 27 */
skip(1) bom__chr01 colon 27 label "地点"                /*kevin*/
        bom__chr02 colon 27 label "对应零件" format "x(18)"             /*kevin*/
/*F533*/    bomdesc  colon 27
            bom_batch_um   colon 27
            cmmts          colon 27
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



         /* DISPLAY */
         view frame a.

/*G309*/ mainloop:
         repeat with frame a:
/*GUI*/ if global-beam-me-up then undo, leave.


/*F533*/    ptdesc1 = ?.
            prompt-for bom_parent editing:

                /* FIND NEXT/PREVIOUS RECORD - NON-SERVICE BOMS ONLY */
/*J12T*/        {mfnp05.i bom_mstr
                        bom_fsm_type
                        "bom_fsm_type = "" "" "
                        bom_parent
                        "input bom_parent"}
/*J12T*         {mfnp.i bom_mstr bom_parent bom_parent  */
/*J12T*             bom_parent bom_parent bom_parent}   */

                if recno <> ? then do:

/*F671*/            bomdesc = "".
/*F533*/            if bom_desc = "" then do:
/*F533*/                find pt_mstr no-lock where pt_part = bom_parent no-error.
/*F533*/                if available pt_mstr then bomdesc = pt_desc1.
/*F533*/            end.
/*F533*/            else do:
/*F533*/                bomdesc = bom_desc.
/*F533*/            end.

	           display bom_parent
/*F533                     bom_desc */
/*F533*/                   bomdesc
                          bom__chr01 bom__chr02                 /*kevin*/
	                  bom_batch_um.

	           if bom_cmtindx <> 0 then display true @ cmmts.
	           else display false @ cmmts.
                end.    /* if recno <> ? */
/*F671*/        hide frame b.
            end.    /* editing on bom_parent */

/*F671*/    hide frame b.

/*F671*/    bomdesc = "".

            find bom_mstr exclusive-lock using bom_parent no-error.
            if not available bom_mstr then do:

                if input bom_parent = "" then do:
	           {mfmsg.i 40 3}
	           undo, retry.
                end.

                find pt_mstr no-lock where pt_part = input bom_parent no-error.
/*F447*/        if available pt_mstr then do:
/*F089*/            ptstatus = pt_status.
/*F089*/            substring(ptstatus,9,1) = "#".
/*F089*/            if can-find(isd_det where isd_status = ptstatus
/*F089*/            and isd_tr_type = "ADD-PS") then do:
/*F089*/                {mfmsg02.i 358 3 pt_status}
/*F089*/                undo, retry.
/*F089*/            end.
/*F447*/        end.

/*added by kevin, 10/16/2003, to forbid users to create the new bom code*/
                message "物料单代码不存在,请重新输入!" view-as alert-box error.
                undo,retry.
/*end added by kevin, 10/16/2003*/

                {mfmsg.i 1 1}
                create bom_mstr.
                assign bom_parent = caps(input bom_parent).

                if available pt_mstr then
                    assign bom_parent = pt_part
/*F533                     bom_desc = pt_desc1 */
	                   bom_batch_um = pt_um
/*G2B7*	                   bom_batch = pt_batch */
	                   bom_formula = pt_formula.
            end.    /* if not available bom_mstr */
/*G740*/    else do:
                /* WARN USER IF HE'S MAINTAINING A SERVICE BOM HERE */
/*J12T*/        if bom_fsm_type <> " " then do:
/*J12T*/            {mfmsg.i 7487 2}
                    /* THIS IS AN SSM BILL OF MATERIAL NOT A STANDARD ONE */
/*J12T* /*G740*/    {fsbomv.i bom_parent 2}    */
/*J12T*/        end.
/*G740*/    end.

/*F533*/    if bom_desc = "" then do:
/*F533*/        find pt_mstr no-lock where pt_part = bom_parent no-error.
/*F533*/        if available pt_mstr then do:
/*F533*/            bomdesc = pt_desc1.
/*F533*/            ptdesc1 = pt_desc1.
/*F533*/        end.
/*F533*/    end.
/*F533*/    else do:
/*F533*/        bomdesc = bom_desc.
/*F533*/    end.

            display bom_parent
/*F533          bom_desc */
/*F533*/        bomdesc
                bom__chr01 bom__chr02                           /*kevin*/
                bom_batch_um.
            if bom_cmtindx <> 0 then display true @ cmmts.
            else display false @ cmmts.

/*F308*/    if bom_formula then do:
/*F308*/        {mfmsg.i 263 3} /* Formula controlled */
/*F308*/        undo, retry.
/*F308*/    end.

            parent = bom_parent.

            /* SET GLOBAL PART VARIABLE */
            global_part = parent.
/*D852*/    batch_size = bom_batch.

            ststatus = stline[2].
            status input ststatus.
            del-yn = no.

            do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

/*added by kevin, 10/16/2003*/
               /*set bom__chr01 with frame a.*/
                 
               find si_mstr no-lock where si_site = bom__chr01 no-error.
               if not available si_mstr or (si_db <> global_db) then do:
                   if not available si_mstr then msg-nbr = 708.
                   else msg-nbr = 5421.
                   {mfmsg.i msg-nbr 3}
                   undo, retry.
               end.
   
               {gprun.i ""gpsiver.p""
               "(input si_site, input recid(si_mstr), output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/       if return_int = 0 then do:
/*J034*/          {mfmsg.i 725 3}    /* USER DOES NOT HAVE */
/*J034*/                             /* ACCESS TO THIS SITE*/
/*J034*/          undo,retry.
/*J034*/       end.               
/*end added by kevin, 10/16/2003*/
            
	       set
/*F533              bom_desc */
/*F533*/            bomdesc
	            bom_batch_um when (bom_batch = 0 or bom_batch = 1)
	            cmmts
	       go-on ("F5" "CTRL-D").

	       assign
	           bom_userid = global_userid
	           bom_mod_date = today.
/*F533*/       if bomdesc <> ptdesc1 then bom_desc = bomdesc.

	       /* DELETE */
	       if lastkey = keycode("F5")
	       or lastkey = keycode("CTRL-D")
	       then do:

/*G309*/    /*PATCH G309 OVERRIDES PATCH F671.  IT WAS DEEMED BETTER TO      */
	    /*TOTALLY PROHIBIT THE DELETION OF BOM CODES THAT ARE USED IN    */
	    /*STRUCTURES RATHER THAN AUTOMATICALLY DELETE THE STRUCTURE.     */
/*G309*/    /*WHATEVER METHOD IS USED MUST BE THE SAME IN FMMAMT.P AS WELL   */

/*G309*/            if can-find (first ps_mstr where ps_par = bom_parent)
/*FS62*  /*G309*/    or can-find (first ps_mstr where ps_comp = bom_parent)  */
/*F0SL*/            or (can-find (first ps_mstr where ps_comp = bom_parent)
/*F0SL*/                and not can-find(pt_mstr where pt_part = bom_parent))
/*G309*/            then do:
/*G309*/                {mfmsg.i 226 3} /*Delete not allowed, product structure exists*/
/*G309*/                undo mainloop, retry.
/*G309*/            end.

	           del-yn = yes.
	           {mfmsg01.i 11 1 del-yn}
	           if del-yn = no then undo, retry.

	           for each cmt_det exclusive-lock where cmt_indx = bom_cmtindx:    /*FR15*/
	               delete cmt_det.
	           end.

/*F671*/            lines = 0.
/*F671*/            for each ps_mstr exclusive-lock where ps_par = bom_parent
/*F671*/            with frame b width 80 no-attr-space down:
/*GUI*/ if global-beam-me-up then undo, leave.

/*F671*/                pause 0.
/*F671*/                display ps_comp ps_ref ps_qty_per ps_ps_code ps_start ps_end.
/*F671*/                {inmrp.i &part=ps_comp &site=unknown_char}
/*F671*/                delete ps_mstr.
/*F671*/                lines = lines + 1.
/*F671*/            end.
/*GUI*/ if global-beam-me-up then undo, leave.

/*F671*/            pause before-hide.
/*F671*/            {inmrp.i &part=bom_parent &site=unknown_char}

	           delete bom_mstr.
	           del-yn = no.
/*F671*/            if lines > 0 then do:
/*F671*/                {mfmsg02.i 24 1 lines}
/*F671*/            end.
/*F671*/            else do:
	                {mfmsg.i 22 1}
/*F671*/            end.

	       end.    /* if lastkey ... */
	       else do:

	           if cmmts = yes then do:
	               global_ref = string(bom_parent).
	               cmtindx = bom_cmtindx.
	               {gprun.i ""gpcmmt01.p"" "(""bom_mstr"")"}
/*GUI*/ if global-beam-me-up then undo, leave.

	               bom_cmtindx = cmtindx.
	               global_ref = "".
	           end.
	       end.
            end.
/*GUI*/ if global-beam-me-up then undo, leave.
   /* do on error undo, retry */

         end.
/*GUI*/ if global-beam-me-up then undo, leave.
    /* mainloop repeat */
         status input.
