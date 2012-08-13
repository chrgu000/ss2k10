/* GUI CONVERTED from pppsmt01.p (converter v1.69) Tue Dec 10 14:44:25 1996 */
/* pppsmt01.p - ITEM SITE INVENTORY MAINTENANCE                         */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.0      LAST MODIFIED: 10/09/91   BY: pma *F003*          */
/* REVISION: 7.0      LAST MODIFIED: 03/11/92   BY: pma *F087*          */
/* REVISION: 7.0      LAST MODIFIED: 07/23/92   BY: pma *F782*          */
/* REVISION: 7.3      LAST MODIFIED: 08/12/93   BY: ram *GE15*          */
/* REVISION: 7.3      LAST MODIFIED: 02/15/94   BY: pxd *FL60*          */
/* REVISION: 7.3      LAST MODIFIED: 06/06/94   BY: ais *FO63*          */
/* REVISION: 7.3      LAST MODIFIED: 06/28/94   BY: pxd *FP14*          */
/*           7.3                     09/03/94   BY: bcm *GL93*          */
/* REVISION: 8.5      LAST MODIFIED: 10/17/94   BY: mwd *J034*          */
/* REVISION: 8.5      LAST MODIFIED: 01/05/95   BY: pma *J040*          */
/* REVISION: 7.2      LAST MODIFIED: 05/04/95   BY: qzl *F0R6*          */
/* REVISION: 8.5      LAST MODIFIED: 12/05/96   BY: *G2HJ* Murli Shastri   */
/* REVISION: 8.5      LAST MODIFIED: 10/16/03   BY: Kevin               */

/*FL60*/ {mfdtitle.i "++ "}

	 define variable part like in_part.
	 define variable site like in_site.
/*J040/*F087*/ define variable rcpt_stat like ld_status   */
/*J040/*F087*/    label "Receipt Status".                 */



/*F782   form                               */
/*F782      in_part        colon 20         */
/*F782      in_site        colon 58         */
/*F782      pt_rev         colon 58         */
/*F782      pt_desc1       colon 20         */
/*F782      pt_draw        colon 58         */
/*F782      pt_desc2       colon 20         */
/*F782      pt_part_type   colon 58         */
/*F782      pt_um          colon 20         */
/*F782      pt_status      colon 58         */
/*F782      pt_prod_line   colon 20         */
/*F782      pt_group       colon 58         */
/*F782       with frame a                   */
/*F782   side-labels width 80 attr-space.   */

/*GL93** /*F782*/ form {ppptmta1.i}. **/

/*GL93*/ 
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/  
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
{ppptmta1.i}
/*GL93*/  SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/*GL93** /*F782*/ display site colon 20 with frame a. **/
/*GL93*/ display site colon 20       skip(.4)    with frame a.

/*F782*/ display global_part @ pt_part global_site @ site with frame a.

	 FORM /*GUI*/ 
	    
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
in_abc             colon 20
	    in_iss_date        colon 58
	    in_avg_int         colon 20
	    in_avg_date        colon 58
	    in_cyc_int         colon 20
	    in_cnt_date        colon 58
/*J040/*F087*/ rcpt_stat       colon 20                                    */
/*J040*/    in_rctpo_status    colon 20
/*J040*/    in_rctpo_active    colon 37
            in_user1        colon 58 label "缺省库位"              /*kevin*/
/*J040*/    in_rctwo_status    colon 20
/*J040*/    in_rctwo_active    colon 37
            in__qadc01         colon 58 label "保管员"                 /*kevin*/
	  SKIP(.4)  /*GUI*/
with frame c side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-c-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame c = F-c-title.
 RECT-FRAME-LABEL:HIDDEN in frame c = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame c =
  FRAME c:HEIGHT-PIXELS - RECT-FRAME:Y in frame c - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME c = FRAME c:WIDTH-CHARS - .5.  /*GUI*/


	 /* DISPLAY */

	 mainloop:
	 repeat:
/*GUI*/ if global-beam-me-up then undo, leave.

	    view frame a.
	    view frame c.

	    do with frame a on endkey undo, leave mainloop:

/*J040/*F087*/ rcpt_stat = ?.                                                */

/*F782         prompt-for in_part in_site editing:                           */
/*F782            /* SET GLOBAL PART VARIABLE */                             */
/*F782            global_part = caps(input in_part).                         */
/*F782            global_site = caps(input in_site).                         */
/*F782            if frame-field = "in_part" then do:                        */
/*F782               /* FIND NEXT/PREVIOUS RECORD */                         */
/*F782               {mfnp.i in_mstr in_part in_part in_site in_site in_part}*/
/*F782            end.                                                       */
/*F782            else if frame-field = "in_site" then do:                   */
/*F782               /* FIND NEXT/PREVIOUS RECORD */                         */
/*F782               {mfnp01.i in_mstr in_site in_site in_part               */
/*F782               "input in_part" in_site}                                */
/*F782            end.                                                       */

/*F782*/       prompt-for pt_part site editing:
		  /* SET GLOBAL PART VARIABLE */
/*J034/*F782*/    global_part = caps(input pt_part).  */
/*J034/*F782*/    global_site = caps(input site).     */
/*J034*/          assign global_part = input pt_part
/*J034*/                 global_site = input site.

/*F782*/          if frame-field = "pt_part" then do:
/*F782*/             /* FIND NEXT/PREVIOUS RECORD */
/*F782*/             {mfnp.i in_mstr pt_part in_part site in_site in_part}
/*F782*/          end.
/*F782*/          else if frame-field = "site" then do:
/*F782*/             /* FIND NEXT/PREVIOUS RECORD */
/*F0R6*/             /* Changed search index from "in_site" to "in_part" */
/*F782*/             /* FIND NEXT/PREVIOUS RECORD */
/*F782*/             {mfnp01.i in_mstr site in_site in_part
		      "input pt_part" in_part}
/*F782*/          end.
		  else do:
		     readkey.
		     apply lastkey.
		  end.
		  if recno <> ? then do:
		     find pt_mstr no-lock where pt_part = in_part no-error.
/*F782               display in_part in_site pt_desc1 pt_desc2 pt_um pt_draw */
/*F782               pt_prod_line pt_group  pt_part_type pt_status           */
/*F782               with frame a.                                           */

/*F782*/             if available pt_mstr then do:
/*GL93** /*F782*/                display {ppptmta1.i}. **/
/*GL93*/                display {ppptmta1.i} with frame a.
/*F782*/                display in_part @ pt_part in_site @ site with frame a.

/*J040/*F087*/          rcpt_stat = ?.                                       */
/*J040/*F087*/          find qad_wkfl where qad_key1 = "RCPT-STAT"           */
/*J040/*F087*/                          and qad_key2 = in_part + in_site     */
/*J040/*F087*/          no-lock no-error.                                    */
/*J040/*F087*/          if available qad_wkfl then rcpt_stat = qad_charfld[2].*/

			if in_abc = ? then
			display "" @ in_abc "" @ in_avg_int "" @ in_cyc_int
			with frame c.
			else display
			in_abc in_avg_int in_cyc_int in_iss_date in_avg_date
			in_cnt_date
/*J040/*F087*/          rcpt_stat                                            */
/*J040*/                in_rctpo_status in_rctpo_active
                        in_user1                                  /*kevin*/
/*J040*/                in_rctwo_status in_rctwo_active
                        in__qadc01                                 /*kevin*/
			with frame c.
/*F782*/             end.
		  end.
	       end.

	       /* ADD/MODIFY  */
	       /*NOTE: DELETING THE IN_MSTR RECORD SHOULD NOT BE ALLOWED. */
/*F782*/       if not can-find (pt_mstr where pt_part = input pt_part) then do:
/*F782*/          {mfmsg.i 16 3}
/*F782*/          undo, retry.
/*F782*/       end.

/*F782*/       if not can-find (si_mstr where si_site = input site) then do:
/*F782*/          {mfmsg.i 708 3}
/*F782*/          next-prompt site with frame a.
/*F782*/          undo, retry.
/*F782*/       end.

/*J034/*GE15*/find si_mstr no-lock where si_site = input site. */
/*J034/*GE15*/if si_db <> global_db then do:                   */

/*J034*/       find si_mstr where si_site = input site no-lock no-error.
/*J034*/       if available si_mstr and si_db <> global_db then do:
/*GE15*/          {mfmsg.i 5421 3}  /* SITE NOT ASSIGNED TO THIS DATABASE */
/*GE15*/          next-prompt site with frame a.
/*GE15*/          undo, retry.
/*GE15*/       end.

/*J034*/       if available si_mstr then do:
/*J034*/          {gprun.i ""gpsiver.p""
		  "(input site, input recid(si_mstr), output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/          if return_int = 0 then do:
/*J034*/             {mfmsg.i 725 3} /* USER DOES NOT HAVE ACCESS TO SITE */
/*J034*/             next-prompt site with frame a.
/*J034*/             undo mainloop, retry mainloop.
/*J034*/          end.
/*J034*/       end.

/*F782         find pt_mstr no-lock where pt_part = input in_part.        */
/*F782         find ptp_det no-lock where ptp_part = input in_part        */
/*F782         and ptp_site = input in_site no-error.                     */
/*F782         find in_mstr exclusive where in_part = input in_part       */
/*F782         and in_site = input in_site no-error.                      */

/*FP14/*F782*/ find pt_mstr no-lock where pt_part = input pt_part.  */
/*FP14*/       find pt_mstr exclusive-lock where pt_part = input pt_part
/*FP14*/       no-error.
/*FP14*/       if not available pt_mstr then do:
/*FP14*/           {mfmsg.i 16 3}
/*FP14*/           undo, retry.
/*FP14*/       end.

/*F782*/       find ptp_det no-lock where ptp_part = pt_part
/*F782*/       and ptp_site = input site no-error.

/*F782*/       find in_mstr exclusive-lock where in_part = pt_part
/*F782*/       and in_site = input site no-error.

/*F782/*F087*/ rcpt_stat = ?.                                               */
/*F782/*F087*/ find qad_wkfl where qad_key1 = "RCPT-STAT"                   */
/*F782/*F087*/                 and qad_key2 = input in_part + input in_site */
/*F782/*F087*/ no-error.                                                    */
/*F782/*F087*/ if available qad_wkfl then rcpt_stat = qad_charfld[2].       */

	       /* NEW ITEM */
	       if not available in_mstr then do:
		  {mfmsg.i 1 1}
		  create in_mstr.
/*F782            assign in_part = caps(input in_part) in_site.             */
/*J034/*F782*/    assign in_part = caps(pt_part)                            */
/*J034*/          assign in_part = pt_part
/*F782*/                 in_site = input site
/*FL60*/                 in_level = 99999.

/*J040*/          if in_abc = "" then in_abc = pt_abc.

/*G2HJ*/	  assign in_gl_set  = si_gl_set
/*G2HJ*/	         in_cur_set = si_cur_set.

/*G2HJ*           ** CREATE sct_det RECORD **/
/*G2HJ*/          {gpsct04.i &type=""GL""}
/*G2HJ*/          {gpsct04.i &type=""CUR""}

/*FL60            if available ptp_det then do:                             */
/*FL60               if ptp_pm_code = "D"                                   */
/*FL60               then in_level = ptp_ll_drp.                            */
/*FL60               else in_level = ptp_ll_bom.                            */
/*FL60            end.                                                      */
/*FL60            else if pt_pm_code <> "D"                                 */
/*FL60              then in_level = pt_ll_code.                             */
	       end.

	       if in_abc = ? then in_abc = pt_abc.
/*J040/*FO63*/ if new in_mstr and in_abc = "" then in_abc = pt_abc.         */
	       if in_avg_int = ? then  in_avg_int = pt_avg_int.
	       if in_cyc_int= ? then in_cyc_int = pt_cyc_int.

/*J040/*F782*/ rcpt_stat = ?.                                               */
/*J040/*F782*/ find qad_wkfl where qad_key1 = "RCPT-STAT"                   */
/*J040/*F782*/                 and qad_key2 = in_part + in_site             */
/*J040/*F782*/ no-lock no-error.                                            */
/*J040/*F782*/ if not available qad_wkfl then                               */
/*J040/*F782*/ find qad_wkfl where qad_key1 = "RCPT-STAT"                   */
/*J040/*F782*/                 and qad_key2 = pt_part + pt_site             */
/*J040/*F782*/ no-lock no-error.                                            */
/*J040/*F782*/ if available qad_wkfl then rcpt_stat = qad_charfld[2].       */

/*F782         display pt_desc1 pt_desc2 pt_um pt_draw                      */
/*F782         pt_prod_line pt_group pt_part_type pt_status                 */
/*F782         with frame a.                                                */

/*GL93/*F782*/ display {ppptmta1.i}. *                                      */
/*GL93*/       display {ppptmta1.i} with frame a.
/*F782*/       display in_part @ pt_part in_site @ site with frame a.
	       display in_abc in_iss_date in_avg_int in_avg_date in_cyc_int
	       in_cnt_date
/*J040/*F087*/rcpt_stat                                                    */
/*J040*/       in_rctpo_status in_rctpo_active
               in_user1                            /*kevin*/
/*J040*/       in_rctwo_status in_rctwo_active
               in__qadc01                          /*kevin*/
	       with frame c.

/*F087*/       setc:
/*F087*/       do with frame c on error undo setc, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

		  set in_abc in_avg_int in_cyc_int
/*J040/*F087*/        rcpt_stat                                             */
/*J040*/              in_rctpo_status in_rctpo_active
/*J040*/                 when ({gppswd3.i &field=""in_rctpo_status""})
                      in_user1                           /*kevin*/
/*J040*/              in_rctwo_status in_rctwo_active
/*J040*/                 when ({gppswd3.i &field=""in_rctwo_status""})
                      in__qadc01                          /*kevin*/
		  with frame c.

/*added by kevin, 10/16/2003 to add a field to record the warehouse clerk*/
                  find loc_mstr where loc_site = in_site and loc_loc = input in_user1 no-lock no-error.
                  if not available loc_mstr then do:
                       {mfmsg.i 229 3}
                       next-prompt in_user1 with frame c.
                       undo setc, retry setc.
                  end.
                  if pt_site = in_site and pt_loc <> input in_user1 then do:
                   message "提示: 与缺省地点的缺省库位不一致!".
                end.
                
                /*kevin,change verified the employee to verified general code  
                  find emp_mstr where emp_addr = input in__qadc01 no-lock no-error.
                  if not available emp_mstr then do:
                       {mfmsg.i 520 3}
                       next-prompt in__qadc01 with frame c.
                       undo setc, retry setc.
                  end.
                */
              
              find code_mstr where code_fldname = "in__qadc01" and code_value = input in__qadc01 
              no-lock no-error.
              if not available code_mstr then do:
                   message "错误: 通用代码中未定义请重新输入!" view-as alert-box error.
                   next-prompt in__qadc01 with frame c.
                   undo setc, retry setc.
              end.
                                        
/*end added by kevin, 10/16/2003*/

/*F782/*F087*/    if rcpt_stat = ? then do:                                  */
/*F782/*F087*/       if available qad_wkfl then delete qad_wkfl.             */
/*F782/*F087*/    end.                                                       */
/*F782/*F087*/    else do:                                                   */
/*J040/*F087*/    if not can-find(is_mstr where is_status = rcpt_stat)       */
/*J040/*F782*/    and rcpt_stat <> ?                                         */
/*J040/*F087*/    then do:                                                   */
/*J040/*F087*/       {mfmsg.i 362 3} /*status does not exist*/               */
/*J040/*F087*/       next-prompt rcpt_stat.                                  */
/*J040/*F087*/       undo setc, retry.                                       */
/*J040/*F087*/    end.                                                       */
/*J040/*F782*/    find qad_wkfl where qad_key1 = "RCPT-STAT"                 */
/*J040/*F782*/                    and qad_key2 = in_part + in_site           */
/*J040/*F782*/    no-error.                                                  */
/*J040/*F087*/    if not available qad_wkfl then do:                         */
/*J040/*F087*/       create qad_wkfl.                                        */
/*J040/*F087*/       assign                                                  */
/*J040/*F087*/       qad_key1 = "RCPT-STAT"                                  */
/*F782/*F087*/ qad_key2 = input in_part + input in_site.                     */
/*J040/*F782*/       qad_key2 = in_part + in_site.                           */
/*J040/*F087*/    end.                                                       */
/*J040/*F087*/    qad_charfld[2] = rcpt_stat.                                */

/*F087*/       end.
/*GUI*/ if global-beam-me-up then undo, leave.

/*F782/*F087*/ end.                                                          */
	    end.
	 end.
/*GUI*/ if global-beam-me-up then undo, leave.

	 /* END MAIN LOOP */
	 status input.
