/* GUI CONVERTED from rwwcmt.p (converter v1.69) Fri Jan 31 16:03:11 1997 */
/* rwwcmt.p - WORK CENTER MAINTENANCE                                   */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 1.0      LAST MODIFIED: 04/06/86   BY: PML       */
/* REVISION: 1.0      LAST MODIFIED: 04/29/86   BY: EMB       */
/* REVISION: 2.0      LAST MODIFIED: 03/12/87   BY: EMB *A41* */
/* REVISION: 4.0      LAST MODIFIED: 02/05/88   BY: RL  *A171**/
/* REVISION: 4.0      LAST MODIFIED: 04/18/88   BY: EMB *A201**/
/* REVISION: 5.0      LAST MODIFIED: 07/05/89   BY: EMB *B169**/
/* REVISION: 6.0      LAST MODIFIED: 05/04/90   BY: RAM *D018**/
/* REVISION: 7.2      LAST MODIFIED: 11/16/92   BY: emb *G322**/
/* REVISION: 7.3      LAST MODIFIED: 02/24/93   BY: sas *G729*/
/* REVISION: 7.3      LAST MODIFIED: 02/01/95   BY: pxd *F0GP*/
/* REVISION: 8.5      LAST MODIFIED: 07/31/96   BY: *J12T* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 01/14/97   BY: *J1FL* Murli Shastri      */
/* REVISION: 8.5      LAST MODIFIED: 12/08/03   BY: Kevin, for site control*/

/* Note: Changes made here may be necessary in fswcmt.p also. */

         /* DISPLAY TITLE */
         {mfdtitle.i "++ "}/*G729*/

         define variable del-yn like mfc_logical initial no.

         def var msg-nbr as inte.                                 /*kevin*/

         /* DISPLAY SELECTION FORM */
         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
wc_wkctr       colon 30 wc_mch
            wc__chr01 colon 30 label "地点"                     /*kevin*/
            wc_desc        colon 30
            skip(1)
            wc_dept        colon 30 dpt_desc no-label
            wc_wk_loc      colon 30 wk_desc  no-label
            skip(1)
/*D018      wc_lbr_cap     colon 30 label "Hours per Day" */
            wc_queue       colon 30
            wc_wait        colon 30
            wc_mch_op      colon 30
            skip(1)
            wc_setup_men   colon 30                   wc_setup_rte   colon 60
            wc_men_mch     colon 30 label "操作人数"  wc_lbr_rate    colon 60
            wc_mch_wkctr   colon 30 label "设备数"  wc_bdn_rate    colon 60
            wc_mch_bdn     colon 30                   wc_bdn_pct     colon 60
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
         mainloop:
         repeat with frame a:
/*GUI*/ if global-beam-me-up then undo, leave.


            ststatus = stline[1].
            status input ststatus.

            prompt-for wc_wkctr wc_mch editing:

                /* FIND NEXT/PREVIOUS RECORD - STANDARD W/C'S ONLY */
/*J12T*/        {mfnp05.i wc_mstr
                              wc_wkctr
                              "wc_fsm_type = "" "" "
                              wc_wkctr
                              "input wc_wkctr"}
/*J12T*         {mfnp.i wc_mstr wc_wkctr wc_wkctr wc_mch wc_mch wc_wkctr}  */

                if recno <> ? then do:
	           display wc_wkctr wc_mch 
	               wc__chr01                                        /*kevin*/
	              wc_desc wc_dept wc_wk_loc
/*D018                  wc_lbr_cap wc_queue wc_wait wc_mch_op */
/*D018*/                wc_queue wc_wait wc_mch_op
	                wc_setup_men wc_men_mch wc_mch_wkctr wc_mch_bdn
	                wc_setup_rte wc_lbr_rate wc_bdn_rate wc_bdn_pct.
	           find dpt_mstr where dpt_dept = wc_dept no-lock no-error.
	           if available dpt_mstr then display dpt_desc.
	           else display " " @ dpt_desc.
	           find wk_mstr where wk_wk_loc = wc_wk_loc no-lock no-error.
	           if available wk_mstr then display wk_desc.
	           else display " " @ wk_desc.
                end.    /* if recno <> ? */
            end.    /* editing on W/C */

            /* ADD/MOD/DELETE  */
            find wc_mstr using wc_wkctr and wc_mch no-error.
            if not available wc_mstr then do:
                {mfmsg.i 1 1}
                create wc_mstr.
                assign wc_wkctr
                wc_mch.
            end.
            else do:                                      /*G729*/
/*J12T*/        if wc_fsm_type = "FSM" then do:
/*J12T*/            {mfmsg.i 7485 2}
                    /* THIS IS A SERVICE WORK CENTER */
/*J12T*/        end.
/*J12T* 	{fswcv.i &fld="input wc_wkctr" &type=2}   /*G729*/     */

/*added by kevin, 10/22/2003 for site control*/
	  if wc__chr01 <> "" then do:  
            display 
                   wc__chr01                                         /*kevin*/
                 wc_desc wc_dept wc_wk_loc
/*D018              wc_lbr_cap wc_queue wc_wait wc_mch_op */
/*D018*/            wc_queue wc_wait wc_mch_op
                    wc_setup_men wc_men_mch wc_mch_wkctr wc_mch_bdn
                    wc_setup_rte wc_lbr_rate wc_bdn_rate wc_bdn_pct.
	       
             find si_mstr no-lock where si_site = wc__chr01 no-error.
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
          end. /*if wc__chr01 <> ""*/
/*end added by kevin*/

            end.
                                                   /*G729*/
            recno = recid(wc_mstr).
            display 
                   wc__chr01                                         /*kevin*/
                 wc_desc wc_dept wc_wk_loc
/*D018              wc_lbr_cap wc_queue wc_wait wc_mch_op */
/*D018*/            wc_queue wc_wait wc_mch_op
                    wc_setup_men wc_men_mch wc_mch_wkctr wc_mch_bdn
                    wc_setup_rte wc_lbr_rate wc_bdn_rate wc_bdn_pct.

            find dpt_mstr where dpt_dept = wc_dept no-lock no-error.
            if available dpt_mstr then display dpt_desc.
            else display " " @ dpt_desc.
            find wk_mstr where wk_wk_loc = wc_wk_loc no-lock no-error.
            if available wk_mstr then display wk_desc.
            else display " " @ wk_desc.

            ststatus = stline[2].
            status input ststatus.
            del-yn = no.

            seta:
            do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.
             
             if wc__chr01 = "" then disp global_site @ wc__chr01.
             
                set
                   wc__chr01                                     /*kevin*/ 
                   wc_desc wc_dept wc_wk_loc
/*D018              wc_lbr_cap wc_queue wc_wait wc_mch_op */
/*D018*/            wc_queue wc_wait wc_mch_op
                    wc_setup_men wc_men_mch wc_mch_wkctr wc_mch_bdn
                    wc_setup_rte wc_lbr_rate wc_bdn_rate wc_bdn_pct
                editing:

	               if frame-field = "wc_dept" then do:
	                   /* FIND NEXT/PREVIOUS RECORD */
	                   {mfnp.i dpt_mstr wc_dept dpt_dept
	                           wc_dept dpt_dept dpt_dept}
	                   if recno <> ? then
	                       display dpt_dept @ wc_dept dpt_desc.
	               end.
	               else if frame-field = "wc_wk_loc" then do:
	                   /* FIND NEXT/PREVIOUS RECORD */
	                   {mfnp.i wk_mstr wc_wk_loc wk_wk_loc
	                       wc_wk_loc wk_wk_loc wk_wk_loc}
	                       if recno <> ? then
	                           display wk_wk_loc @ wc_wk_loc wk_desc.
	               end.
	               else do:
	                   ststatus = stline[2].
	                   status input ststatus.
	                   readkey.
	                   apply lastkey.
	               end.
	
	               /* DELETE */
	               if lastkey = keycode("F5")
	               or lastkey = keycode("CTRL-D")
	               then do:
	                   del-yn = yes.
	                   {mfmsg01.i 11 1 del-yn}
	                   if del-yn then leave.
	               end.
                end.    /* editing */

                if del-yn then do:
	           if can-find
	               (first ro_det where ro_wkctr = wc_wkctr and ro_mch = wc_mch)
	           then do:
	               find first ro_det where ro_wkctr=wc_wkctr and ro_mch = wc_mch
	                   no-lock.
	               {mfmsg02.i 521 3 ro_routing}
	               /* DELETE NOT ALLOWED, ITEM ROUTING EXISTS */
	               next mainloop.
	           end.
	           if can-find
	               (first wr_route where wr_wkctr = wc_wkctr and wr_mch = wc_mch)
	           then do:
	               find first wr_route where wr_wkctr = wc_wkctr
	                   and wr_mch = wc_mch no-lock.
	               {mfmsg02.i 522 3 wr_nbr}
	               /* DELETE NOT ALLOWED, WORK ORDER EXISTS */
	               next mainloop.
	           end.

/*J1FL* /*F0GP*/   find first swc_det where swc_wkctr = wc_wkctr
		   no-lock no-error. */
/*J1FL*/           find first swc_det
/*J1FL*/           where swc_wkctr = wc_wkctr
/*J1FL*/           and   swc_mch   = wc_mch  no-lock no-error.
/*F0GP*/           if available swc_det then do:
/*F0GP*/                {mfmsg.i 5402 3}
                        /* DELETE NOT ALLOWED, DETAIL COST RECORDS EXIST */
/*F0GP*/                next mainloop.
/*F0GP*/           end.

	           delete wc_mstr.
	           clear frame a.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
	           del-yn = no.
                end.    /* if del-yn then do */
                else do:

/*added by kevin, 12/08/2003 for site control*/
                 find si_mstr no-lock where si_site = input wc__chr01 no-error.
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
               
               assign global_site = wc__chr01.
                              
/*end added by kevin, 12/08/2003*/

	           find dpt_mstr where dpt_dept = wc_dept no-lock no-error.
	           if available dpt_mstr then display dpt_desc.
	           else display " " @ dpt_desc.
	           find wk_mstr where wk_wk_loc = wc_wk_loc no-lock no-error.
	           if available wk_mstr then display wk_desc.
	           else display " " @ wk_desc.

	           if wc_dept <> "" and
	           not can-find(first dpt_mstr where dpt_dept = wc_dept)
	           then do:
	               {mfmsg.i 532 3}     /* DEPARTMENT DOES NOT EXIST */
	               next-prompt wc_dept.
	               undo, retry.
	           end.
/*G322*            if can-find(first wk_mstr) then */
/*G322*/           if wc_wk_loc > "" then
	               if not can-find(wk_mstr where wk_wk_loc = wc_wk_loc)
	               then do:
	                   {mfmsg.i 4026 3}
	                   /* INVALID WORK LOCATION CODE */
	                   next-prompt wc_wk_loc.
	                   undo, retry.
	               end.
                end.    /* else, not del-yn, do */

            end.
/*GUI*/ if global-beam-me-up then undo, leave.
    /* seta do on error */

         end.
/*GUI*/ if global-beam-me-up then undo, leave.
   /* repeat */
         status input.
