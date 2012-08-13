/* GUI CONVERTED from pppsmt02.p (converter v1.69) Tue Sep  9 16:27:04 1997 */
/* pppsmt02.p - PART SITE PLANNING MAINTENANCE                          */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 6.0      LAST MODIFIED: 07/31/90   BY: emb                 */
/* REVISION: 6.0      LAST MODIFIED: 10/31/90   BY: emb *D158*          */
/* REVISION: 6.0      LAST MODIFIED: 02/18/91   BY: emb *D342*          */
/* REVISION: 6.0      LAST MODIFIED: 02/18/91   BY: emb *D357*          */
/* REVISION: 7.0      LAST MODIFIED: 02/20/92   BY: emb *F227*          */
/* REVISION: 7.0      LAST MODIFIED: 07/24/92   BY: pma *F782*          */
/* REVISION: 7.0      LAST MODIFIED: 11/09/92   BY: pma *G299*          */
/* REVISION: 7.3      LAST MODIFIED: 06/15/93   BY: qzl *GC15*          */
/* REVISION: 7.3      LAST MODIFIED: 07/29/93   BY: emb *GD82*          */
/* REVISION: 7.3      LAST MODIFIED: 08/12/93   BY: ram *GE15*          */
/* REVISION: 7.3      LAST MODIFIED: 11/19/93   BY: pxd *GH42*          */
/* REVISION: 7.3      LAST MODIFIED: 02/03/94   BY: ais *FL79*          */
/* REVISION: 7.3      LAST MODIFIED: 02/03/94   BY: pxd *FM16*          */
/* REVISION: 7.3      LAST MODIFIED: 02/15/94   BY: pxd *FL60*          */
/* REVISION: 7.3      LAST MODIFIED: 06/28/94   BY: pxd *FP14*          */
/*           7.3                     09/03/94   BY: bcm *GL93*          */
/*           7.3                     09/11/94   BY: rmh *GM19*          */
/* REVISION: 8.5      LAST MODIFIED: 10/16/94   BY: dzs *J005*          */
/* REVISION: 8.5      LAST MODIFIED: 10/17/94   BY: mwd *J034*          */
/*           7.3                     11/06/94   BY: rwl *GO27*          */
/* REVISION: 7.3      LAST MODIFIED: 12/20/94   BY: ais *F0B7*          */
/* REVISION: 7.3      LAST MODIFIED: 03/16/95   BY: pxd *F0NB*          */
/* REVISION: 7.2      LAST MODIFIED: 05/04/95   BY: qzl *F0R6*          */
/* REVISION: 8.5      LAST MODIFIED: 08/25/95   BY: tjs *J070*          */
/* REVISION: 7.2      LAST MODIFIED: 05/31/95   BY: qzl *F0SK*          */
/* REVISION: 7.3      LAST MODIFIED: 01/24/96   BY: bcm *G1KV*          */
/* REVISION: 8.5      LAST MODIFIED: 03/09/96   BY: jxz *J078*          */
/* REVISION: 8.5      LAST MODIFIED: 12/05/96   BY: *G2HJ* Murli Shastri   */
/* REVISION: 8.5      LAST MODIFIED: 12/13/96   BY: *J1BZ* Russ Witt       */
/* REVISION: 8.5      LAST MODIFIED: 02/18/97   BY: *J1HW* Russ Witt       */
/* REVISION: 8.5      LAST MODIFIED: 02/28/97   BY: *J1JQ* Murli Shastri   */
/* REVISION: 8.5      LAST MODIFIED: 05/19/97   BY: *J1RT* Tim Hinds       */
/* REVISION: 8.5      LAST MODIFIED: 09/09/97   BY: *J20N* Doug Norton     */

/*FL60*/ {mfdtitle.i "e+ "}
/*J1HW*  ADDED NO-UNDO TO VARIABLES BELOW  */
/*F227*/ define variable yn like mfc_logical no-undo.
         define variable del-yn like mfc_logical no-undo.
         define variable part like ptp_part no-undo.
         define variable site like ptp_site no-undo.
         define variable ptp_recno as recid no-undo.
         define variable err-flag as integer no-undo.
         define variable ps-recno as recid no-undo.
         define variable bom_code like ptp_bom_code no-undo.
/*GC15*/ define variable drp_mrp like mfc_logical initial no no-undo.
/*FM16/*GH42*/ define variable update_wc like mfc_logical initial "yes". */
/*GH42*/ define variable ptp_bom_codesv like ptp_bom_code no-undo.
/*GH42*/ define variable ptp_pm_codesv  like ptp_pm_code no-undo.
/*GH42*/ define variable ptp_networksv  like ptp_network no-undo.

/*J1HW*F0NB* define buffer inmstra for in_mstr.                */
/*F0NB*/ define variable ptp_ord_polsv like ptp_ord_pol initial "xyz" no-undo.

/*J1RT*/ define variable cfexists like mfc_logical.
/*J1RT*/ define variable cfsite  like ptp_site.
/*J1RT*/ define variable cfdel-yn like mfc_logical initial no.

/*J1RT*/ /*check the existance of a config. control record*/
/*J1RT*/ {gprun.i ""cfctrl.p"" "(""cf_w_mod"", output cfexists)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*F782*/ /*REPLACED FORMS WITH INCLUDE FILES*/
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

/*F782*/ FORM /*GUI*/  
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
/*kang jian*/ {zzpppsmta4.i} 
/*GL93*/  SKIP(.4)  /*GUI*/
with frame c1 
/*GL93*/ side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-c1-title AS CHARACTER.
 F-c1-title = " 零件计划数据 ".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame c1 = F-c1-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame c1 =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame c1 + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame c1 =
  FRAME c1:HEIGHT-PIXELS - RECT-FRAME:Y in frame c1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME c1 = FRAME c1:WIDTH-CHARS - .5. /*GUI*/


/*F782*/ display global_part @ pt_part global_site @ site with frame a.

         /* DISPLAY */
         mainloop:
         repeat:
/*GUI*/ if global-beam-me-up then undo, leave.

            view frame a.
/*F782      view frame c. */
/*F782*/    view frame c1.

            do with frame a on endkey undo, leave mainloop:

/*F782         prompt-for ptp_part ptp_site editing:                        */
/*F782            /* SET GLOBAL PART VARIABLE */                            */
/*F782            global_part = caps(input ptp_part).                       */
/*F782            global_site = caps(input ptp_site).                       */
/*F782            if frame-field = "ptp_part" then do:                      */
/*F782               /* FIND NEXT/PREVIOUS RECORD */                        */
/*F782               {mfnp.i ptp_det ptp_part ptp_part ptp_site             */
/*F782                ptp_site ptp_part}                                    */
/*F782            end.                                                      */
/*F782            else if frame-field = "ptp_site" then do:                 */
/*F782               /* FIND NEXT/PREVIOUS RECORD */                        */
/*F782               {mfnp01.i ptp_det ptp_site ptp_site                    */
/*F782               ptp_part "input ptp_part" ptp_site}                    */
/*F782            end.                                                      */

/*F782*/       prompt-for pt_part site editing:
/*F782*/          /* SET GLOBAL PART VARIABLE */
/*J034* /*F782*/          global_part = caps(input pt_part). */
/*J034* /*F782*/          global_site = caps(input site).    */
/*J034*/          assign global_part = input pt_part
/*J034*/                 global_site = input site.
/*F782*/          if frame-field = "pt_part" then do:
/*F782*/             /* FIND NEXT/PREVIOUS RECORD */
/*F782*/             {mfnp.i ptp_det pt_part ptp_part site
                     ptp_site ptp_part}
/*F782*/          end.
/*F782*/          else if frame-field = "site" then do:
/*F0R6*/            /* Changed search index from "ptp_site" to "ptp_part" */
/*F782*/            /* FIND NEXT/PREVIOUS RECORD */
/*F782*/            {mfnp01.i ptp_det site ptp_site
                     ptp_part "input pt_part" ptp_part}
/*F782*/          end.
/*F782*/          else do:
/*F782*/             readkey.
/*F782*/             apply lastkey.
/*F782*/          end.

/*F782*/          /*REPLACED DISPLAYS WITH INCLUDE FILES*/
                  if recno <> ? then do:
                     find pt_mstr no-lock where pt_part = ptp_part no-error.
                     find in_mstr no-lock where in_part = ptp_part
                     and in_site = ptp_site no-error.

/*GL93** /*F782*/             display {ppptmta1.i}. **/
/*GL93*/             display {ppptmta1.i} with frame a.
/*F782*/             display ptp_part @ pt_part ptp_site @ site with frame a.
/*GL93** /*F782*/    display {pppsmta4.i}.  **/
/*GL93*/   /*kang jian*/          display {zzpppsmta4.i} with frame c1.

/*F0SK*/             if ptp_bom_code <> "" then find bom_mstr no-lock
/*F0SK*/             where bom_parent = ptp_bom_code no-error.
/*F0SK*/             else find bom_mstr no-lock
/*F0SK*/             where bom_parent = ptp_part no-error.
/*F0SK*/             if available bom_mstr and bom_batch <> 0
/*F0SK*/             then display bom_batch @ ptp_batch with frame c1.
/*F0SK*/             else display 1 @ ptp_batch with frame c1.
                  end.
               end.

               /* ADD/MOD/DELETE  */
               del-yn = no.

/*F782*/       if not can-find (pt_mstr where pt_part = input pt_part) then do:
/*F782*/          {mfmsg.i 16 3}
/*F782*/          undo, retry.
/*F782*/       end.

/*F782*/       if not can-find (si_mstr where si_site = input site) then do:
/*F782*/          {mfmsg.i 708 3}
/*F782*/          next-prompt site with frame a.
/*F782*/          undo, retry.
/*F782*/       end.

/*J034* /*GE15*/       find si_mstr no-lock where si_site = input site.   */
/*J034* /*GE15*/       if si_db <> global_db then do:                     */
/*J034*/       find si_mstr where si_site = input site no-lock no-error.
/*J034*/       if available si_mstr and si_db <> global_db then do:
/*GE15*/          {mfmsg.i 5421 3}  /* SITE NOT ASSIGNED TO THIS DATABASE */
/*GE15*/          next-prompt site with frame a.
/*GE15*/          undo, retry.
/*GE15*/       end.

/*J034*/       if available si_mstr then do:
/*J034*/          {gprun.i ""gpsiver.p""
                  "(input si_site, input recid(si_mstr), output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/          if return_int = 0 then do:
/*J034*/             {mfmsg.i 725 3} /* USER DOES NOT HAVE ACCESS TO SITE */
/*J034*/             next-prompt site with frame a.
/*J034*/             undo mainloop, retry mainloop.
/*J034*/          end.
/*J034*/       end.

/*F782         find pt_mstr no-lock where pt_part = input ptp_part.         */
/*F782         find in_mstr no-lock where in_part = input ptp_part          */
/*F782         and in_site = input ptp_site no-error.                       */
/*F782         find ptp_det exclusive using ptp_part and ptp_site no-error. */

/*FP14/*F782*/ find pt_mstr no-lock where pt_part = input pt_part.  */
/*FP14*/       find pt_mstr exclusive-lock
/*FP14*/       where pt_part = input pt_part no-error.
/*FP14*/       if not available pt_mstr then do:
/*FP14*/           {mfmsg.i 16 3}
/*FP14*/           undo, retry.
/*FP14*/       end.
/*F782*/       find in_mstr no-lock where in_part = pt_part
/*F782*/       and in_site = input site no-error.
/*F782*/       find ptp_det exclusive-lock where ptp_part = pt_part
/*F782*/       and ptp_site = input site no-error.

               if not available ptp_det then do:

                  /* NEW ITEM */
                  {mfmsg.i 1 1}
                  create ptp_det.
/*F782            assign ptp_part = caps(input ptp_part) ptp_site.          */
/*F782*/          assign ptp_part = pt_part
/*J070*/                 ptp_joint_type = pt_joint_type
/*F782*/                 ptp_site = input site.
/*GM19*           recno = recid(ptp_det). */
/*GO27*/          if recid(ptp_det) = -1 then .

/*FL60*/          find in_mstr where in_site = ptp_site
/*G1KV*/          and in_part = ptp_part exclusive-lock no-error.
/*G1KV** /*FL60*/          and in_part = ptp_part no-error. **/
/*FL60*/          if available in_mstr then in_level = 99999.
                  find in_mstr no-lock where in_part = ptp_part
                  and in_site = ptp_site no-error.
                  if not available in_mstr then do:
                     create in_mstr.
                     assign
                        in_part = pt_part
                        in_site = ptp_site
                         in_mrp = yes
                         in_abc = pt_abc
                     in_avg_int = pt_avg_int
                     in_cyc_int = pt_cyc_int.
/*FL60                 in_level = pt_ll_code.             */
/*FL60*/               in_level = 99999.
/*GM19*              recno = recid(in_mstr). */
/*GO27*/             if recid(in_mstr) = -1 then .

                     find si_mstr where si_site = in_site no-lock no-error.
                     if available si_mstr
                        then assign in_gl_set = si_gl_set
                                    in_cur_set = si_cur_set.

/*G2HJ*              ** CREATE sct_det RECORD **/
/*G2HJ*/             {gpsct04.i &type=""GL""}
/*G2HJ*/             {gpsct04.i &type=""CUR""}
                  end.

/*F0NB*/          ptp_ord_polsv  = ptp_ord_pol.

/*F0R6*/    /* Added parenthesis for when in display statement */
                  display
                  pt_ms @ ptp_ms
                  pt_plan_ord @ ptp_plan_ord
                  in_mrp when (available in_mstr) @ in_mrp
                  pt_mrp when (not available in_mstr) @ in_mrp
                  pt_ord_pol @ ptp_ord_pol
                  pt_ord_qty @ ptp_ord_qty
                  pt_ord_per @ ptp_ord_per
                  pt_sfty_stk @ ptp_sfty_stk
                  pt_sfty_time @ ptp_sfty_tme
                  pt_rop @ ptp_rop

                  pt_buyer @ ptp_buyer
                  pt_vend @ ptp_vend
                  pt_pm_code @ ptp_pm_code
                  ptp_site @ ptp_po_site
                  pt_mfg_lead @ ptp_mfg_lead
                  pt_pur_lead @ ptp_pur_lead
                  pt_insp_rqd @ ptp_ins_rqd
                  pt_insp_lead @ ptp_ins_lead
                  pt_cum_lead @ ptp_cum_lead
                  pt_timefence @ ptp_timefnce
                  pt_network @ ptp_network
                  pt_routing @ ptp_routing
                  pt_bom_code @ ptp_bom_code

                  pt_iss_pol @ ptp_iss_pol
                  pt_phantom @ ptp_phantom
                  pt_ord_min @ ptp_ord_min
                  pt_ord_max @ ptp_ord_max
                  pt_ord_mult @ ptp_ord_mult
                  pt_yield_pct @ ptp_yld_pct
                  pt_run @ ptp_run
                  pt_setup @ ptp_setup
/*kang jian*/     pt__dec01 @ ptp__dec01 
                  pt_rev @ ptp_rev
                 
/*F782            with frame c.   */
/*F782*/          with frame c1.
               end.
               else
/*F782*/       /*REPLACED DISPLAYS WITH INCLUDE FILES*/
/*GL93** /*F782*/ display {pppsmta4.i}.  **/
/*GL93*/  /*kang jian*/     display {zzpppsmta4.i} with frame c1.

               /* DISPLAY */

/*G299*/       if ptp_bom_code <> "" then find bom_mstr no-lock
/*G299*/          where bom_parent = ptp_bom_code no-error.
/*G299*/       else find bom_mstr no-lock
/*G299*/          where bom_parent = ptp_part no-error.
/*F0R6*/    /* Added parenthesis for when in display statement */
/*G299*/       display
/*G299*/    bom_batch when (available bom_mstr and bom_batch <> 0) @ ptp_batch
/*G299*/       1 when (not available bom_mstr
/*G299*/            or (available bom_mstr and bom_batch = 0)) @ ptp_batch
/*G299*/       with frame c1.

/*GL93** /*F782*/  display {ppptmta1.i}. **/
/*GL93*/       display {ppptmta1.i} with frame a.
/*F782*/       display ptp_part @ pt_part ptp_site @ site with frame a.

               ststatus = stline[2].
               status input ststatus.

/*F0B7         next-prompt ptp_ms with frame c.   */
/*F0B7*/       next-prompt ptp_ms with frame c1.

               do on error undo, retry with frame c1:
/*GUI*/ if global-beam-me-up then undo, leave.


/*J1HW*        PERIODS REMOVED FROM ASSIGN STATEMENT BELOW   */
/*J1HW*/          assign
/*GH42*/          ptp_bom_codesv = ptp_bom_code
/*GH42*/          ptp_pm_codesv =  ptp_pm_code
/*GH42*/          ptp_networksv  = ptp_network
/*FL79*/          ptp_mod_date = today
/*FL79*/          ptp_userid = global_userid.

                  set ptp_ms ptp_plan_ord
                  ptp_timefnce
                  ptp_ord_pol ptp_ord_qty
                  ptp_ord_per ptp_sfty_stk ptp_sfty_tme ptp_rop
/*F782*/          ptp_rev
                  ptp_buyer ptp_vend
                  ptp_po_site
/*J1JQ /*J078*/   ptp_pm_code when (pt_pm_code <> "F") */
                  ptp_pm_code ptp_mfg_lead ptp_pur_lead
                  ptp_ins_rqd ptp_ins_lead ptp_cum_lead
                  ptp_network
                  ptp_routing
                  ptp_bom_code
/*F782            ptp_rev  */
                  ptp_iss_pol ptp_phantom ptp_ord_min ptp_ord_max
                  ptp_ord_mult ptp_yld_pct
                  ptp_run ptp_setup ptp__dec01
                  go-on (F5 CTRL-D)
/*F782            with frame c. */
/*F782*/          with frame c1.

/*FL60*  *
/*GC15*/ *         if  ptp_pm_code = "D" and ptp_network <> "" then do:
/*GC15*/ *           find in_mstr exclusive where in_part = ptp_part
/*GC15*/ *           and in_site = ptp_site.
/*GC15*/ *           if available in_mstr and in_level > -1 then in_level = -1.
/*GC15*/ *           {gprun.i ""ppllup.p"" "(recid(in_mstr))"}
/*GC15*/ *           if in_level > ptp_ll_bom then drp_mrp = yes.
/*GC15*/ *         end.
         *                                       FL60*/

                  /* DELETE */
                  if lastkey = keycode("F5")
                  or lastkey = keycode("CTRL-D")
                  then do:
                     del-yn = yes.
                     {mfmsg01.i 11 1 del-yn}
                     if del-yn = no then undo, retry.
                  end.
                  else do:

/*J1BZ*/             /* Added section */
                     /* do not allow unknown values (question mark) */
                     {gpchkqst.i &fld=ptp_ms &frame-name=c1}
                     {gpchkqst.i &fld=ptp_plan_ord &frame-name=c1}
                     {gpchkqst.i &fld=ptp_timefnce &frame-name=c1}
                     {gpchkqst.i &fld=ptp_ord_pol &frame-name=c1}
                     {gpchkqst.i &fld=ptp_ord_qty &frame-name=c1}
                     {gpchkqst.i &fld=ptp_ord_per &frame-name=c1}
                     {gpchkqst.i &fld=ptp_sfty_stk &frame-name=c1}
                     {gpchkqst.i &fld=ptp_sfty_tme &frame-name=c1}
                     {gpchkqst.i &fld=ptp_rop &frame-name=c1}
                     {gpchkqst.i &fld=ptp_rev &frame-name=c1}
                     {gpchkqst.i &fld=ptp_buyer &frame-name=c1}
                     {gpchkqst.i &fld=ptp_vend &frame-name=c1}
                     {gpchkqst.i &fld=ptp_po_site &frame-name=c1}
                     {gpchkqst.i &fld=ptp_pm_code &frame-name=c1}
                     {gpchkqst.i &fld=ptp_mfg_lead &frame-name=c1}
                     {gpchkqst.i &fld=ptp_pur_lead &frame-name=c1}
                     {gpchkqst.i &fld=ptp_ins_rqd &frame-name=c1}
                     {gpchkqst.i &fld=ptp_ins_lead &frame-name=c1}
                     {gpchkqst.i &fld=ptp_cum_lead &frame-name=c1}
                     {gpchkqst.i &fld=ptp_network &frame-name=c1}
                     {gpchkqst.i &fld=ptp_routing &frame-name=c1}
                     {gpchkqst.i &fld=ptp_bom_code &frame-name=c1}
                     {gpchkqst.i &fld=ptp_iss_pol &frame-name=c1}
                     {gpchkqst.i &fld=ptp_phantom &frame-name=c1}
                     {gpchkqst.i &fld=ptp_ord_min &frame-name=c1}
                     {gpchkqst.i &fld=ptp_ord_max &frame-name=c1}
                     {gpchkqst.i &fld=ptp_ord_mult &frame-name=c1}
                     {gpchkqst.i &fld=ptp_yld_pct &frame-name=c1}
                     {gpchkqst.i &fld=ptp_run &frame-name=c1}
                     {gpchkqst.i &fld=ptp_setup &frame-name=c1}
/*kang jian*/        {gpchkqst.i &fld=ptp__dec01 &frame-name=c1}
/*J1BZ*/             /* End of added section */

                     if not
                     {gpval.v &fld=ptp_network &mfile=ssm_mstr
                        &mfld=ssm_network &blank=yes }
                     then do:
                        {mfmsg.i 1505 3}
                        next-prompt ptp_network with frame c1.
                        undo, retry.
                     end.

/*F0B7*/             if ptp_yld_pct = 0
/*F0B7*/             then do:
/*F0B7*/                {mfmsg.i 3953 3}
/*F0B7*/                next-prompt ptp_yld_pct with frame c1.
/*F0B7*/                undo, retry.
/*F0B7*/             end.

/*J1RT*/             /* Check removal of pm-code or 'c' when using Adv. Config */
/*J1RT*/             run cfexists.del.

/*J078*/             /* processing the change */
/*J1JQ /*J078*/      if ptp_pm_codesv <> "F" and ptp_pm_code = "F" */
/*J1JQ*/             if pt_pm_code <> "F" and ptp_pm_code = "F"
/*J078*/             then do:
/*J078*/                {mfmsg.i 1267 3} /*Family Item can only be
                                           defined at Item Master Maintenance*/
/*J078*/                next-prompt ptp_pm_code with frame c1.
/*J078*/                undo, retry.
/*J078*/             end.

/*J1JQ*/             /* IF pt_pm_code = "F" THEN ptp_pm_code SHOULD ALSO BE
                        VALIDATED TO BE "F" ONLY */
/*J1JQ*/             if pt_pm_code = "F" and ptp_pm_code <> "F"
/*J1JQ*/             then do:
/*J1JQ*/                {mfmsg.i 1020 3} /*Family Item only */
/*J1JQ*/                next-prompt ptp_pm_code with frame c1.
/*J1JQ*/                undo, retry.
/*J1JQ*/             end.

                     err-flag = 0.
                     if ptp_routing > "" then
                     if not can-find
                     (first ro_det where ro_routing = ptp_routing) then do:
                         {mfmsg.i 126 2}
                         next-prompt ptp_routing with frame c1.
                         err-flag = 1.
                     end.
                     if ptp_bom_code > "" then
                     if not can-find
                     (first ps_mstr where ps_par = ptp_bom_code) then do:
                         {mfmsg.i 100 2}
                         if err-flag <> 1 then
                             next-prompt ptp_bom_code with frame c1.
                         err-flag = 2.
                     end.
                     if err-flag <> 0 then do:
/*F227*/                yn = yes.
                        /* PLEASE CONFIRM UPDATE */
/*F227*/                {mfmsg01.i 32 1 yn}
/*F227*/                if yn = no then undo, retry.
/*F227*                 pause. */
                     end.

/*J005*/ /* Begin added block */

                     if ptp_joint_type = "5" and
                     ptp_bom_code <> "" and ptp_bom_code <> ptp_part then do:
                        /* BASE PROCESS BOM MUST BE THE SAME AS ITEM NO.*/
                        {mfmsg.i 6533 4}
                        next-prompt ptp_bom_code with frame c1.
                        undo, retry.
                     end.
                     /* BOM CHANGE. SEE IF THIS IS A CO-PRODUCT. */
                     if ptp_joint_type <> "5" and
/*J070*/             (new ptp_det or
/*J070*/             ptp_bom_code <> ptp_bom_codesv) then do:
/*J070*              ptp_bom_code <> ptp_bom_codesv then do: */
                        find first ps_mstr no-lock
                        where ps_par = ptp_part and ps_comp = ptp_bom_code
                        and ps_joint_type = "1" no-error.
                        if available ps_mstr then ptp_joint_type = "1".
                                             else ptp_joint_type = "".
                     end.

                     if ptp_joint_type = "1" or ptp_joint_type = "5" then do:
                        if ptp_phantom = yes then do:
                           /*A JOINT PROD OR BASE PROCESS MAY NOT BE A PHANTOM*/
                           {mfmsg.i 6512 3}
                           next-prompt ptp_phantom with frame c1.
                           undo, retry.
                        end.
                        if ptp_pm_code = "C" then do:
                           /* CONFIGURED ITEM NOT ALLOWED */
                           {mfmsg.i 225 3}
                           next-prompt ptp_pm_code with frame c1.
                           undo, retry.
                        end.
                     end.
/*J005*/ /* End added block */

                     ps-recno = 1.
                     bom_code =
                        (if ptp_bom_code > "" then ptp_bom_code else ptp_part).

/*GH42*/             if (ptp_bom_code  <> ptp_bom_codesv or
/*GH42*/             ptp_pm_code       <> ptp_pm_codesv  or
/*GH42*/             ptp_network       <> ptp_networksv) and not batchrun
/*GH42*/             then do:
/*FL60*/               for each  in_mstr where in_part = ptp_part:
/*FL60*/                 in_level = 99999.
/*FL60*/               end.

/*FM16/*GH42*/         {mfmsg01.i 5004 1 update_wc}.        */
/*FM16/*GH42*/         if update_wc then                    */

                       {gprun.i ""bmpsmta1.p""
                       "(pt_part,"""",bom_code,input-output ps-recno)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*GH42*/             end.

                     if ps-recno = 0 then do:
                        {mfmsg.i 206 3} /* CYCLIC STRUCTURE NOT ALLOWED. */
                        next-prompt ptp_bom_code with frame c1.
                        undo, retry.
                     end.

                     find bom_mstr no-lock where bom_parent = bom_code no-error.
                     if (available bom_mstr and (ptp_ll_bom > bom_ll_code
/*GC15*/                or drp_mrp))
                     or (not available bom_mstr and ptp_ll_bom > 0)
                     then do:

                        if available bom_mstr
                        then ptp_ll_bom = bom_ll_code.
                        else ptp_ll_bom = 0.

                        if ptp_pm_code <> "D" and ptp_pm_code <> "P" then do:
                           find in_mstr exclusive-lock where in_part = ptp_part
                           and in_site = ptp_site
                           and in_level > ptp_ll_bom no-error.
                           if available in_mstr then do:
/*FL60*/                      assign in_mrp = yes.
/*FL60                             in_level = ptp_ll_bom.                */
/*FL60                        {gprun.i ""ppllup.p"" "(recid(in_mstr))"}  */
                           end.
                        end.
                     end.
                  end.
               end.
/*GUI*/ if global-beam-me-up then undo, leave.

/*J1HW*        FOLLOWING MOVED TO INTERNAL PROCEDURE
.              part = ptp_part.
.              site = ptp_site.
.              {inmrp.i &part=part &site=site}

./*F0NB*/      if ptp_ord_pol = "" and ptp_ord_polsv <> ptp_ord_pol then do:
./*F0NB*/         find inmstra where inmstra.in_part = ptp_part and
./*F0NB*/         inmstra.in_site = ptp_site no-error.
./*F0NB*/         if available inmstra then inmstra.in_mrp = yes.
./*F0NB*/      end.
.*J1HW         END OF MOVED CODE   */
/*J1HW*/       run check-mrp.

               if del-yn = yes then do:

/*J1HW*           FOLLOWING MOVED TO INTERNAL PROCEDURE
.                 ptp_recno = recid(ptp_det).
.                 find ptp_det exclusive-lock where recid(ptp_det) = ptp_recno.
./*FL60*/         find in_mstr where in_mstr.in_site = ptp_site
./*FL60*/         and in_mstr.in_part = ptp_part no-error.
./*FL60*/         if available in_mstr then in_mstr.in_level = 99999.
.                 delete ptp_det.
.*J1HW*           END OF MOVED CODE      */

/*J1HW*/          run delete_ptp_det.

                  clear frame a.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
/*F782            clear frame c.   */
/*F782*/          clear frame c1.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame c1 = F-c1-title.
                  del-yn = no.
                  next mainloop.
               end.
               status input.
            end.
         end.
/*GUI*/ if global-beam-me-up then undo, leave.

         /* END MAIN LOOP */
         status input.

/*J1HW*  INTERNAL PROCEDURES                          */
         procedure check-mrp:
            define buffer inmstra for in_mstr.
            part = ptp_det.ptp_part.
            site = ptp_det.ptp_site.
            {inmrp.i &part=part &site=site}
            if ptp_ord_pol = "" and ptp_ord_polsv <> ptp_ord_pol then do:
               find inmstra where inmstra.in_part = ptp_part and
               inmstra.in_site = ptp_site no-error.
               if available inmstra then inmstra.in_mrp = yes.
            end.
         end procedure.

/*J1RT*/ procedure cfexists.del:
/*J1RT*/   /* warn the user if they change an items pt_pm_code and */
/*J1RT*/   /* a configuration record for the item exists */
/*J1RT*/   if ptp_pm_codesv = "c" and ptp_det.ptp_pm_code <> "c"
/*J1RT*/   and cfexists then do:
/*J1RT*/     find qad_wkfl
/*J1RT*/       where qad_key1 = "cfpt"
/*J1RT*/       and qad_key2 = string(ptp_part,"x(18)") +
/*J1RT*/                      string(ptp_site,"x(8)")
/*J1RT*/       exclusive-lock no-error.
/*J1RT*/     if available qad_wkfl then do:
/*J1RT*/       cfdel-yn = no.
/*J1RT*/       {mfmsg01.i 1798 2 cfdel-yn}
/*J1RT*/       /* model name exists for the configured item. delete ?*/
/*J1RT*/       if cfdel-yn then do:
/*J1RT*/          delete qad_wkfl.
/*J1RT*/       end.
/*J1RT*/       else do:
/*J1RT*/         next-prompt ptp_pm_code.
/*J1RT*/         undo, retry.
/*J1RT*/       end.
/*J1RT*/     end. /*available qad_wkfl*/
/*J1RT*/   end. /*ptp_pm_codesv = "c"*/
/*J1RT*/ end procedure.

         procedure delete_ptp_det:
/*J1RT*/   if cfexists then do:
/*J1RT*/     /* If the user has decided to delete the record and a */
/*J1RT*/     /* configuration record exists - then delete it */
/*J20N* /*J1RT*/     if false then do:           */
/*J20N* /*J1RT*/       {gprun0.i ""cfwkflrm.p""} */
/*J20N* /*J1RT*/     end.                        */
/*J1RT*/     {gprunmo.i
                &module = "cf"
                &program = "cfwkflrm.p"
                &param   = """(ptp_det.ptp_part,
                               ptp_det.ptp_site)"""
             }
/*J1RT*/   end. /*cfexists*/
           ptp_recno = recid(ptp_det).
           find ptp_det exclusive-lock where recid(ptp_det) = ptp_recno.
           find in_mstr where in_mstr.in_site = ptp_site
           and in_mstr.in_part = ptp_part no-error.
           if available in_mstr then in_mstr.in_level = 99999.
           delete ptp_det.
         end procedure.
/*J1HW*  END OF INTERNAL PROCEDURES                       */
