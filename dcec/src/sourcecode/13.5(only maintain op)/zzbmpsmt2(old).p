/* GUI CONVERTED from bmpsmt.p (converter v1.69) Mon Jan 20 11:44:39 1997 */
/* bmpsmt.p - PRODUCT STRUCTURE MAINTENANCE                             */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 1.0       LAST EDIT: 06/12/86      MODIFIED BY: EMB        */
/* REVISION: 1.0       LAST EDIT: 09/08/86      MODIFIED BY: EMB        */
/* REVISION: 1.0       LAST EDIT: 10/02/86      MODIFIED BY: EMB *25*   */
/* REVISION: 1.0       LAST EDIT: 11/03/86      MODIFIED BY: EMB *36*   */
/* REVISION: 1.0       LAST EDIT: 11/03/86      MODIFIED BY: EMB *39*   */
/* REVISION: 2.0       LAST EDIT: 03/12/87      MODOFIED BY: EMB *A41*  */
/* REVISION: 4.0       LAST EDIT: 01/04/88      MODIFIED BY: RL  *A117* */
/* REVISION: 4.0       LAST EDIT: 01/05/88      MODIFIED BY: RL  *A126* */
/* REVISION: 4.0       LAST EDIT: 03/07/88      MODIFIED BY: WUG *A183* */
/* REVISION: 4.0       LAST EDIT: 04/19/88      MODIFIED BY: emb *A207* */
/* REVISION: 5.0       LAST EDIT: 12/30/88      MODIFIED BY: emb *B001* */
/* REVISION: 6.0       LAST EDIT: 11/05/90      MODIFIED BY: emb *D176* */
/* REVISION: 6.0       LAST EDIT: 09/09/91      MODIFIED BY: emb *D852* */
/* REVISION: 7.0       LAST EDIT: 03/16/92      MODIFIED BY: emb *F308* */
/* REVISION: 7.0       LAST EDIT: 03/24/92      MODIFIED BY: pma *F089* */
/* REVISION: 7.0       LAST EDIT: 05/27/92      MODIFIED BY: pma *F533* */
/* REVISION: 7.0       LAST EDIT: 06/01/92      MODIFIED BY: emb *F562* */
/* REVISION: 7.0       LAST EDIT: 10/07/92      MODIFIED BY: emb *G141* */
/* REVISION: 7.3       LAST EDIT: 02/24/93      MODIFIED BY: sas *G740* */
/* REVISION: 7.3       LAST EDIT: 06/11/93      MODIFIED BY: qzl *GC10* */
/* REVISION: 7.3       LAST EDIT: 07/29/93      MODIFIED BY: emb *GD82* */
/* REVISION: 7.3       LAST EDIT: 09/07/93      MODIFIED BY: pxd *GE64* */
/* REVISION: 7.3       LAST EDIT: 10/07/93      MODIFIED BY: pxd *GG22* */
/* REVISION: 7.3       LAST EDIT: 02/16/94      MODIFIED BY: pxd *FL60* */
/* REVISION: 7.3       LAST EDIT: 04/22/94      MODIFIED BY: pxd *FN07* */
/* REVISION: 7.3       LAST EDIT: 08/08/94      MODIFIED BY: str *FP93* */
/* REVISION: 7.3       LAST EDIT: 09/11/94      MODIFIED BY: slm *GM32* */
/* REVISION: 7.3       LAST EDIT: 09/15/94      MODIFIED BY: qzl *FR35* */
/* REVISION: 7.2       LAST EDIT: 09/19/94      MODIFIED BY: ais *FR55* */
/* REVISION: 7.3       LAST EDIT: 09/27/94      MODIFIED BY: qzl *FR88* */
/* REVISION: 7.3       LAST EDIT: 11/06/94      MODIFIED BY: ame *GO19* */
/* REVISION: 7.3       LAST EDIT: 12/16/94      MODIFIED BY: pxd *F09W* */
/* REVISION: 8.5       LAST EDIT: 01/07/95      MODIFIED BY: dzs *J005**/
/* REVISION: 8.5       LAST EDIT: 02/16/95      MODIFIED BY: tjs *J005**/
/* REVISION: 7.2       LAST EDIT: 03/20/95      MODIFIED BY: qzl *F0NG* */
/* REVISION: 8.5       LAST EDIT: 09/18/95      MODIFIED BY: kxn *J07Z**/
/* REVISION: 7.3       LAST EDIT: 12/14/95      MODIFIED BY: bcm *F0WG* */
/* REVISION: 8.5       LAST EDIT: 04/10/96      BY: *J04C* Markus Barone     */
/* REVISION: 8.5       LAST EDIT: 07/31/96      BY: *G2B7* Julie Milligan    */
/* REVISION: 8.5       LAST EDIT: 12/23/96      BY: *J1CT* Russ Witt         */
/*Revision: 8.5    Last modified: 10/15/03, By: Kevin, users just only maintain the 'op' code*/

         /*********************************************************/
         /* NOTES:   1. Patch FL60 sets in_level to a value       */
         /*             of 99999 when in_mstr is created or      */
         /*             when any structure or network changes are */
         /*             made that affect the low level codes.     */
         /*          2. The in_levels are recalculated when MRP   */
         /*             is run or can be resolved by running the  */
         /*             mrllup.p utility program.                 */
         /*********************************************************/

         /* DISPLAY TITLE */
         {mfdtitle.i "++ "} /*FN07*/

         define new shared variable comp like ps_comp.
         define new shared variable par like ps_par.
         define new shared variable level as integer.
         define new shared variable qty as decimal.
         define new shared variable parent like ps_par.
         define new shared variable ps_recno as recid.
/*F0WG** /*FN07*/ define new shared variable parentm like ps_par. **/
         define            variable des like pt_desc1.
         define            variable des2 like pt_desc1.
         define            variable um like pt_um.
         define            variable del-yn like mfc_logical initial no.
         define            variable rev like pt_rev.
         define            variable item_no like ps_item_no.
         define            buffer ps_mstr1 for ps_mstr.
         define            variable unknown_char as character initial ?.
/*G2B7* /*D852*/ define            variable batch_size like pt_batch. */
/*G2B7*/ define            variable batch_size like bom_batch.
/*F308*/ define            variable conflicts like mfc_logical.
/*F308*/ define            variable psstart like ps_start.
/*F308*/ define            variable psend like ps_end.
/*F308*/ define            variable conv like ps_um_conv initial 1.
/*F089*/ define            variable ptstatus1 like pt_status.
/*F089*/ define            variable ptstatus2 like pt_status.
/*F533*/ define            variable bomdesc like bom_desc.
/*GG22*/ define new shared variable sitept like si_site.
/*GG22*/ define new shared variable partpt like pt_part.
/*FR55*/ define new shared variable bom_recno as recid.
/*F0WG*/ define            variable new_psmstr like mfc_logical no-undo.

         /* DISPLAY SELECTION FORM */
         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
ps_par         colon 25
/*F533      bom_desc colon 25 */
/*F533*/    bomdesc  colon 25
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



         FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
ps_comp        colon 25       des no-label at 47
            rev            colon 25      des2 no-label at 47
            ps_ref         colon 25
/*FP93      ps_start       colon 25 label "Effective" ps_end label {t001.i} */
/*FP93*/    ps_start colon 25                     ps_end colon 59
            skip(1)
            ps_qty_per     colon 25 um no-label
/*GE64*/                                    ps_scrp_pct colon 59 format ">9.99%"
                                              ps_lt_off colon 59
                                                  ps_op colon 59
                                             ps_item_no colon 59
            ps_ps_code     colon 25         ps_fcst_pct colon 59
            psstart        colon 25            ps_group colon 59
            psend          colon 25          ps_process colon 59
            ps_rmks        colon 25
          SKIP(.4)  /*GUI*/
with frame b side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-b-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
 RECT-FRAME-LABEL:HIDDEN in frame b = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame b =
  FRAME b:HEIGHT-PIXELS - RECT-FRAME:Y in frame b - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME b = FRAME b:WIDTH-CHARS - .5.  /*GUI*/


         /* DISPLAY */
         view frame a.
         view frame b.
/*FR55*/ bom_recno = ?.
/*F089*/ mainloop:
         repeat with frame a:
/*GUI*/ if global-beam-me-up then undo, leave.


/*F089*/    ptstatus1 = "".
/*F089*/    ptstatus2 = "".
            clear frame b no-pause.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.

            prompt-for ps_par editing:

/*GC10*/       if frame-field = "ps_par" then do:
               /* FIND NEXT/PREVIOUS  RECORD */
/*FR55*/          recno = bom_recno.
/*F0WG*/          find bom_mstr where recid(bom_mstr) = recno no-lock no-error.
/*F0WG** /*FR55*/ find bom_mstr where recid(bom_mstr) = recno no-error. **/
/*J04C*           {mfnp.i bom_mstr ps_par bom_parent ps_par    */
/*J04C*                   bom_parent bom_parent}                      */
/*J04C*/          /* NEXT/PREV THRU 'NON-SERVICE' BOMS */
/*J04C*/          {mfnp05.i bom_mstr bom_fsm_type "bom_fsm_type = """""
                   bom_parent "input ps_par"}

                  if recno <> ? then do:

/*FR55*/             bom_recno = recno.
/*F533*/             if bom_desc = "" then do:
/*F533*/                find pt_mstr no-lock where pt_part = bom_parent
/*F533*/                no-error.
/*F533*/                if available pt_mstr then bomdesc = pt_desc1.
/*F533*/             end.
/*F533*/             else do:
/*F533*/                bomdesc = bom_desc.
/*F533*/             end.

                     display
                        bom_parent @ ps_par
/*F533                  bom_desc. */
/*F533*/                bomdesc.
                  end.
/*FR55*/          else bom_recno = ?.
               end. /* if field-frame = "ps_par" */
/*GC10*/       else do:
/*GC10*/          readkey.
/*GC10*/          apply lastkey.
/*GC10*/       end.
            end. /* prompt-for */

/*F089*/    find pt_mstr no-lock where pt_part = input ps_par no-error.
            find bom_mstr no-lock where bom_parent = input ps_par no-error.
/*J04C*/    if available bom_mstr then
/*J04C*/       if bom_fsm_type = "FSM" then do:
/*J04C*/          {mfmsg.i 7487 3}
                  /* THIS IS A SERVICE BILL OF MATERIAL, NOT A STANDARD BOM */
/*J04C*/          undo, retry.
/*J04C*/       end.
/*J04C*     REMOVE RELIANCE ON QAD_WKFL
./*G740*/    if available bom_mstr then do:
./*G740*/       {fsbomv.i bom_parent 2}
./*G740*/    end.
.*J04C*/
       
/*added by kevin, 10/15/2003*/
          find first ps_mstr where ps_par = input ps_par no-lock no-error.
          if not available ps_mstr then do:
                message "�����/���ϵ���������Ҫά������������!" view-as alert-box error.
                undo,retry.
          end.
                    
            if not available bom_mstr then do
/*G141*/    transaction:
/*GUI*/ if global-beam-me-up then undo, leave.


/*F089         find pt_mstr no-lock where pt_part = input ps_par no-error. */

               {mfmsg.i 1 1}

               create bom_mstr.
               assign bom_parent = input ps_par
                      bom_userid = global_userid
                    bom_mod_date = today.

               if available pt_mstr then
                  assign bom_parent = pt_part
/*F533                     bom_desc = pt_desc1  */
                       bom_batch_um = pt_um
/*G2B7*                          bom_batch = pt_batch */
                        bom_formula = pt_formula.
/*GO19* /*GM32*/ recno = recid(bom_mstr).*/
/*GO19*/       if recid(bom_mstr) = -1 then .
            end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* transaction */
/*FR55*/    bom_recno = recid(bom_mstr).

/*F533*/    if bom_desc = "" and available pt_mstr then bomdesc = pt_desc1.
/*F533*/    else bomdesc = bom_desc.

            display bom_parent @ ps_par
/*F533         bom_desc. */
/*F533*/       bomdesc.

/*F089*/    if available pt_mstr then ptstatus1 = pt_status.

/*F308*/    if bom_formula then do:
/*F308*/       {mfmsg.i 263 3} /* Formula controlled */
/*F308*/       undo, retry.
/*F308*/    end.

            parent = bom_parent.

            /* SET GLOBAL PART VARIABLE */
            global_part = parent.

/*D852*/    batch_size = bom_batch.
/*D852*/    if batch_size = 0 then batch_size = 1.

/*F089*/    b-loop:
            repeat with frame b:
/*GUI*/ if global-beam-me-up then undo, leave.

/*F089*/       ptstatus2 = "".
               prompt-for ps_comp ps_ref
/*F308*/          ps_start
               editing:

/*GC10*/          if frame-field = "ps_comp" then do:
                     /* FIND NEXT/PREVIOUS RECORD */
                     {mfnp01.i ps_mstr ps_comp ps_comp parent ps_par ps_parcomp}

                     if recno <> ? then do:
                        assign um = ""
                              des = ""
                             des2 = "".

                        find pt_mstr where pt_part = ps_comp no-lock no-error.
/*F533*/                find bom_mstr no-lock where bom_parent = ps_comp
/*F533*/                no-error.
/*F533*/                if available bom_mstr then
/*F533*/                   assign um = bom_batch_um
/*F533*/                         des = bom_desc.
                        if available pt_mstr then do:
                           assign um = pt_um
/*F533                           des = pt_desc1 */
/*F533                          des2 = pt_desc2 */
                                 rev = pt_rev.
/*F533*/                   if des = "" then
/*F533*/                      assign des = pt_desc1
/*F533*/                            des2 = pt_desc2.
                        end.
/*F533                  else do:                                              */
/*F533                     find bom_mstr no-lock where bom_parent = ps_comp   */
/*F533*                    no-error.                                          */
/*F533                     if available bom_mstr then                         */
/*F533                        assign um = bom_batch_um                        */
/*F533                              des = bom_desc.                           */
/*F533                 end.                                                   */

                       display ps_comp des
                          rev des2
                          ps_ref
                          ps_qty_per um
                          ps_scrp_pct
                          ps_ps_code ps_fcst_pct ps_lt_off
                          ps_op
                          ps_start ps_end
                          ps_start @ psstart
                          ps_end @ psend
                          ps_rmks ps_item_no
/*D176*/                  ps_group ps_process.
                     end. /* recno <> ? */
/*GC10*/          end. /* frame-field = "ps_comp" */
/*GC10*/          else do:
/*GC10*/             readkey.
/*GC10*/             apply lastkey.
/*GC10*/          end.
               end. /* prompt-for */

               if input ps_comp = input ps_par then do:
                  {mfmsg.i 206 3} /* CYCLIC STRUCTURE NOT ALLOWED. */
                  undo, retry.
               end.

               assign
                  um = ""
                  des = ""
                  des2 = ""
                  rev = "".

               find pt_mstr where pt_part = input ps_comp no-lock no-error.
/*F533*/       find bom_mstr no-lock where bom_parent = input ps_comp no-error.
/*F533*/       if available bom_mstr then
/*J04C*/       do:
/*J04C*/          if bom_fsm_type = "FSM" then do:
/*J04C*/                {mfmsg.i 7487 3}
                        /* THIS IS A SERVICE BILL OF MATERIAL */
/*J04C*/                undo, retry.
/*J04C*/          end.
/*F533*/          assign um = bom_batch_um
/*F533*/                des = bom_desc.
/*J04C*/       end.  /* if available bom_mstr */

               if available pt_mstr then do:
/*J005*/          if pt_joint_type = "5" then do:
/*J005*/             /* COMPONENT MAY NOT BE A BASE PROCESS */
/*J005*/             {mfmsg.i 6521 3}
/*J005*/             undo, retry.
/*J005*/          end.

/*F089*/          ptstatus2 = pt_status.
                  assign
                       um = pt_um
/*F533                des = pt_desc1                       */
/*F533               des2 = pt_des                         */
                      rev = pt_rev.
/*F533*/          if des = "" then
/*F533*/             assign des = pt_desc1
/*F533*/                   des2 = pt_desc2.
               end.

/*F533         else do:                                                       */
/*F533            find bom_mstr no-lock where bom_parent = input ps_comp      */
/*F533*           no-error.                                                   */
/*F533            if available bom_mstr then                                  */
/*F533               assign um = bom_batch_um                                 */
/*F533                     des = bom_desc.                                    */
/*F533         end.                                                           */

/*F0WG*/       new_psmstr = no.

               find first ps_mstr exclusive-lock
               using ps_par and ps_comp and ps_ref
/*F308*/       and ps_start
               no-error.

               if not available ps_mstr then do:

/*added by kevin, 10/15/2003*/
               message "��Ʒ�ṹ������,����������!" view-as alert-box error.
               undo b-loop, retry.
               
/*F089*/          substring(ptstatus1,9,1) = "#".
/*F089*/          if can-find(isd_det where isd_status = ptstatus1
/*F089*/          and isd_tr_type = "ADD-PS") then do:
/*F089*/             {mfmsg02.i 358 3 substring(ptstatus1,1,2)}
/*F089*/             undo mainloop, retry.
/*F089*/          end.

/*F562*
/*F089*/          ptstatus2 = pt_status. */
/*F089*/          substring(ptstatus2,9,1) = "#".
/*F089*/          if can-find(isd_det where isd_status = ptstatus2
/*F089*/          and isd_tr_type = "ADD-PS") then do:
/*F089*/             {mfmsg02.i 358 3 substring(ptstatus2,1,2)}
/*F089*/             undo b-loop, retry.
/*F089*/          end.

/*F0WG*/          if not can-find (first ps_mstr where ps_par = input ps_par
/*F0WG*/          and ps_comp = input ps_comp) then new_psmstr = yes.

                  create ps_mstr.
                  assign
/*J07Z*                     ps_par = caps(input ps_par)       */
/*J07Z*                     ps_comp = caps(input ps_comp)     */
/*J07Z*/             ps_par = input ps_par
/*J07Z*/             ps_comp = input ps_comp
                     ps_ref
/*F308*/             ps_start.

                  ps_recno = recid(ps_mstr).

                  /* CHECK FOR CYCLIC PRODUCT STRUCTURES */
                  {gprun.i ""bmpsmta.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

                  if ps_recno = 0 then do:
                     hide message no-pause.
                     {mfmsg.i 206 3}
                     /* CYCLIC PRODUCT STRUCTURE NOT ALLOWED. */
                     undo, retry.
                  end.

                  {mfmsg.i 1 1}
               end. /* if not available ps_mstr */

/*J005*/       if ps_ps_code = "J" then do:
/*J005*/          /* MAY NOT UPDATE A JOINT PRODUCT STRUCTURE */
/*J005*/          {mfmsg.i 6509 3}
/*J005*/          undo, retry.
/*J005*/       end.

/*F308*/       if ps_qty_type = "P" then do:
/*F308*/          {mfmsg.i 4604 3}
                  /* PERCENT OF BATCH STRUCTURE   */
/*F308*/          undo, retry.
/*F308*/       end.


/*F09W*/       if ps_qty_type = "B" then do:
/*F09W*/          {mfmsg.i 4607 3}
                  /* CHANGE NOT ALLOWED TO BATCH STRUCTURE   */
/*F09W*/          undo, retry.
/*F09W*/       end.

/*FR88*/       if ps_ps_code = "A" then do:
/*FR88*/          {mfmsg.i 598 3}
                  /* ALTERNATE STRUCTURE NOT ALLOWED   */
/*FR88*/          undo, retry.
/*FR88*/       end.

               recno = recid(ps_mstr).
               ps_recno = recno.

               /* SET GLOBAL PART VARIABLE */
               global_part = ps_comp.

               display
                  ps_comp des
                  rev des2
                  ps_ref
                  ps_qty_per
                  um
                  ps_scrp_pct
                  ps_ps_code ps_fcst_pct ps_lt_off
                  ps_op ps_rmks
                  ps_start ps_end
                  ps_start @ psstart
                  ps_end @ psend
                  ps_item_no
/*D176*/          ps_group ps_process.

/*F308*/       conflicts = false.
/*J1CT*/       if not batchrun then do:
/*F308*/          for each ps_mstr1 no-lock
/*F308*/          where ps_mstr1.ps_par = ps_mstr.ps_par
/*F308*/          and ps_mstr1.ps_comp = ps_mstr.ps_comp
/*F308*/          and ps_mstr1.ps_ref = input ps_mstr.ps_ref
/*F308*/          and recid(ps_mstr) <> recid(ps_mstr1)
/*J1CT*           REFERENCES TO END DATE REMOVED--NOT ENTERED YET
./*F308*/         and (
./*F308*/            (ps_mstr1.ps_end = ? and ps_mstr.ps_end = ?)
./*F308*/         or (ps_mstr1.ps_start = ? and input ps_mstr.ps_start = ?)
./*F308*/         or (ps_mstr1.ps_start = ? and ps_mstr1.ps_end = ?)
./*F308*/         or (ps_mstr.ps_start = ? and ps_mstr.ps_end = ?)
./*F308*/         or ((input ps_mstr.ps_start >= ps_mstr1.ps_start
./*F308*/              or ps_mstr1.ps_start = ?)
./*F308*/              and input ps_mstr.ps_start <= ps_mstr1.ps_end)
./*F308*/         or (input ps_mstr.ps_start <= ps_mstr1.ps_end
./*F308*/             and ps_mstr.ps_end >= ps_mstr1.ps_start) ):
. *J1CT*          END OF DELETED CODE REPLACED BELOW   */
/*J1CT*           BEGIN NEW CODE    */
                  and (
                     (ps_mstr1.ps_start = ? and input ps_mstr.ps_start = ?)
                  or (ps_mstr1.ps_start = ? and ps_mstr1.ps_end = ?)
                  or ((input ps_mstr.ps_start >= ps_mstr1.ps_start
                       or ps_mstr1.ps_start = ?)
                       and input ps_mstr.ps_start <= ps_mstr1.ps_end) ):
/*J1CT*           END OF NEW CODE      */
/*F308*/               conflicts = true.
/*F308*/               leave.
/*F308*/          end.  /* FOR EACH PS_MSTR1...   */

/*F308*/          if conflicts then do:
/*F308*/             {mfmsg.i 122 2}
/*J1CT*/             /* DATE RANGES MAY NOT OVERLAP  */
/*F308*/          end.
/*J1CT*/       end.  /* IF NOT BATCHRUN...   */

               ststatus = stline[2].
               status input ststatus.
               del-yn = no.

               assign
                  psstart = ps_start
                    psend = ps_end.

               do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


                  set
                     /*marked by kevin, 10/15/2003
                     ps_qty_per
                     ps_ps_code
                     psstart psend
                     ps_rmks
                     ps_scrp_pct
                     ps_lt_off
                     end marked by kevin, 10/15/2003*/
                     
                     ps_op
                     
                     /*marked by kevin, 10/15/2003
                     ps_item_no
/*D176*/             ps_fcst_pct ps_group ps_process
/*F308*              ps_ref */
                  go-on ("F5" "CTRL-D")
                  end marked by kevin, 10/15/2003*/
                  .

                  comp = ps_comp.
                  parent = ps_par.

/*J005*/          if ps_ps_code = "X" then do for ps_mstr1:
/*J005*/             find first ps_mstr1 no-lock where ps_mstr1.ps_par = comp
/*J07Z*  /*J005*/    and ps_mstr1.ps_ps_code = "J" . */
/*J07Z*/             and ps_mstr1.ps_ps_code = "J" no-error.
/*J005*/             if available ps_mstr1 then do:
/*J005*/       /*A JOINT PRODUCT MAY NOT BE A COMPONENT IN A PHANTOM STRUCTURE*/
/*J005*/                {mfmsg.i 6534 3}
/*J005*/                undo, retry.
/*J005*/             end.
/*J005*/          end.

/*J005*/          if ps_ps_code = "J" then do:
/*J005*/             /* MAY NOT UPDATE A JOINT PRODUCT STRUCTURE */
/*J005*/             {mfmsg.i 6509 4}
/*J005*/             undo, retry.
/*J005*/          end.


                  /* DELETE */
                  if lastkey = keycode("F5")
                  or lastkey = keycode("CTRL-D")
                  then do:
                     del-yn = yes.
                     {mfmsg01.i 11 1 del-yn}
                     if del-yn = no then undo, retry.

/*F0WG*/             /*! UPDATE THE MRP REQUIRED FLAG FOR APPROPRIATE ITEMS
                      *  (MANUFACTURED ITEMS WHICH SOMEHOW REFERENCE THIS
                      *  PARENT CODE AS THEIR BOM CODE).  DO NOT UPDATE LOW
                      *  LEVEL CODES */
/*F0WG*/             {gprun.i ""bmpsmtc.p"" "(parent,no)" }
/*GUI*/ if global-beam-me-up then undo, leave.


/*F0WG*/             /*! LOCATE PHANTOM STRUCTURE AND 'BOM CODE' PARENTS OF THIS
                      *  PARENT CODE TO APPLY THE LOGIC IN bmpsmtc.p SO THAT
                      *  THEIR MRP FLAGS ARE PROPERLY UPDATED. */
/*F0WG*/             {gprun.i ""bmpsmtd.p"" "(parent)" }
/*GUI*/ if global-beam-me-up then undo, leave.


/*F0WG** DELETED FOLLOWING SECTION **
./*F0NG*/            parentm = ps_par.
./*F0NG*/            {gprun.i ""bmpsmrp.p"" "(parentm)"} **/

                     delete ps_mstr.
                     del-yn = no.
                     {mfmsg.i 22 1}
                  end.
                  else do: /* MODIFY */

                     if (psstart <> ? and psend <> ?) then
                     if psstart > psend then do:
                        {mfmsg.i 4 3}
                        /* START DATE MUST BE PRIOR TO END DATE  */
                        next-prompt psstart.
                        undo, retry.
                     end.

/*F308*/             conflicts = false.
/*F308*/             for each ps_mstr1 no-lock where
                     ps_mstr1.ps_par = ps_mstr.ps_par
/*F308*/             and ps_mstr1.ps_comp = ps_mstr.ps_comp
/*F308*/             and ps_mstr1.ps_ref = input ps_mstr.ps_ref
/*F308*/             and recid(ps_mstr) <> recid(ps_mstr1)
/*F308*/             and (
/*F308*/                (ps_mstr1.ps_end = ? and psend = ?)
/*F308*/             or (ps_mstr1.ps_start = ? and psstart = ?)
/*F308*/             or (ps_mstr1.ps_start = ? and ps_mstr1.ps_end = ?)
/*F308*/             or (ps_mstr.ps_start = ? and psend = ?)
/*FR35************Deleted: Begin***********************
/*F308*/             or ((psstart >= ps_mstr1.ps_start
/*F308*/                or ps_mstr1.ps_start = ?)
/*F308*/                and psstart <= ps_mstr1.ps_end)
/*F308*/             or (psstart <= ps_mstr1.ps_end
/*F308*/                and psend >= ps_mstr1.ps_start) ):
/*FR35*/ ***********Deleted: End*************************/
/*FR35*/             or ((psstart >= ps_mstr1.ps_start
/*FR35*/                or ps_mstr1.ps_start = ?)
/*FR35*/                and (psstart <= ps_mstr1.ps_end or ps_mstr1.ps_end = ?
/*FR35*/                or psstart = ?))
/*FR35*/             or ((psstart <= ps_mstr1.ps_end or psstart = ? or
/*FR35*/                ps_mstr1.ps_end = ?)
/*FR35*/                and (psend >= ps_mstr1.ps_start or psend = ? or
/*FR35*/                ps_mstr1.ps_start = ?)) ):
/*F308*/                conflicts = true.
/*F308*/                leave.
/*F308*/             end.

/*F308*/             if conflicts then do:
/*F308*/                {mfmsg.i 122 3}
/*J1CT*/                /* DATE RANGES MAY NOT OVERLAP  */
/*F308*/                next-prompt psend.
/*F308*/                undo, retry.
/*F308*/             end.

                     /*F308*Start** Not implemented yet********
                   * conv = 1.
                   * if um <> bom_batch_um
                   * and ps_qty_type <> ""
                   * then do:
                   *    {gprun.i ""gpumcnv.p""
                   *       "(um, bom_batch_um, ps_comp, output conv)"}
                   *    if conv = ? and ps_qty_type = "P" then do:
                   *       {mfmsg.i 4600 2}
                   *       {mfmsg.i 33 2}
                   *       conv = 1.
                   *    end.
                   * end.
                     *F308*End**************/

                     /* STORE MODIFY DATE AND USERID */
                     assign
                        ps_mod_date = today
                        ps_userid = global_userid

/*F308*/                ps_start = psstart
/*F308*/                ps_end = psend
/*J07Z*                        ps_ps_code = caps(ps_ps_code)         */
/*J07Z*                        ps_qty_type = caps(ps_qty_type).      */
/*J07Z*/                ps_ps_code = ps_ps_code
/*J07Z*/                ps_qty_type = ps_qty_type.

                        ps_qty_per_b = ps_qty_per.

                     if ps_qty_type = "B" and batch_size <> 0 then
                        assign
                           ps_batch_pct = ps_qty_per_b * conv / batch_size * 100
                           ps_qty_per_b = ps_qty_per * batch_size.
                     else
                     if ps_qty_type = "P" then
                        assign
                           ps_qty_per = ps_batch_pct * .01 * batch_size / conv
                          ps_qty_per_b = ps_batch_pct * .01 * batch_size / conv.

                     if ps_qty_type = "" then ps_batch_pct = 0.

/*F308*/             display ps_start ps_end.

/*F0WG***** DELETED SECTION *
./*FN07*/            parentm = ps_par.
./*FN07*/            {gprun.i ""bmpsmrp.p"" "(parentm)"}
**F0WG****  DELETED SECTION */

                     if ps_item_no <> 0 then do:
                        item_no = ps_item_no.
                        for each ps_mstr1 no-lock where ps_mstr1.ps_par = parent
                        and ps_mstr1.ps_item_no = item_no
                        and ps_mstr1.ps_comp <> comp:
/*GUI*/ if global-beam-me-up then undo, leave.

                           {mfmsg.i 54 2}
                           leave.
                        end.
/*GUI*/ if global-beam-me-up then undo, leave.

                     end.

/*added by kevin, 11/09/2003*/
              if input ps_op <> 0 then do:    
                  find opm_mstr where opm_std_op = input ps_op no-lock no-error.
                  if not available opm_mstr then do:
                     message "����:��׼���򲻴���,����������!" view-as alert-box error.
                     undo,retry.
                  end.
                  if opm__chr01 <> ps__chr01 then do:
                     message "����:��׼����ĵص���BOM�ĵص㲻һ��,����������!" view-as alert-box error.
                     undo,retry. 
                  end.
              end.    
/*end added by kevin, 11/09/2003*/

/*F0WG*/          end. /* MODIFY */

/*F0WG*/          /*! UPDATE THE MRP REQUIRED AND LOW LEVEL CODE
                   *  RECALCULATION FLAGS FOR APPROPRIATE ITEMS (MANUFACTURED
                   *  ITEMS WHICH SOMEHOW REFERENCE THIS PARENT CODE AS THEIR
                   *  BOM CODE). */
/*F0WG*/          {gprun.i ""bmpsmtc.p"" "(parent,new_psmstr)" }
/*GUI*/ if global-beam-me-up then undo, leave.


/*F0WG*/          /*! LOCATE PHANTOM STRUCTURE AND 'BOM CODE' PARENTS OF THIS
                   *  PARENT CODE TO APPLY THE LOGIC IN bmpsmtc.p SO THAT THEIR
                   *  MRP FLAGS AND LOW LEVEL CODE CALCULATION FLAGS ARE
                   *  PROPERLY UPDATED. */
/*F0WG*/          {gprun.i ""bmpsmtd.p"" "(parent)" }
/*GUI*/ if global-beam-me-up then undo, leave.


/*F0WG** DELETED SECTION **
./*FL60*/             for each in_mstr exclusive where in_part = ps_comp
./*FL60*/             and not can-find (ptp_det where ptp_part = in_part
./*FL60*/             and ptp_site = in_site):
./*FL60*/                if available in_mstr then in_level = 99999.
./*FL60*/             end.
./*FL60*/             for each ptp_det where ptp_part = ps_comp:
./*FL60*/                find in_mstr where in_part = ptp_part and
./*FL60*/                in_site =  ptp_site no-error.
./*FL60*/                if available in_mstr then in_level = 99999.
./*FL60*/             end.
**F0WG**/

/*FL60               if new(ps_mstr) then do:             */
/*FL60                  /* UPDATE LOW LEVEL CODES */      */
/*FL60                  {gprun.i ""bmpsmtb.p""}           */
/*FL60               end.                                 */

/*F0WG** DELETED SECTION **
                  end.

./*D176*/          {inmrp.i &part=parent &site=unknown_char}
./*D176*/          {inmrp.i &part=comp   &site=unknown_char}
.
./*GG22*/          repeat:
./*GG22*/             find next ptp_det where ptp_bom_code = parent no-lock
.                     no-error.
./*GG22*/             if not available ptp_det then leave.
./*GG22*/             sitept = ptp_site.
./*GG22*/             partpt = ptp_part.
./*GG22*/             {inmrp.i &part=partpt &site=sitept}
./*GG22*/          end.
.
./*GG22*/          define buffer inmstr for in_mstr.
./*GG22*/          repeat:
./*GG22*/             find next pt_mstr where pt_bom_code = parent no-lock
./*GG22*/             no-error.
./*GG22*/             if not available pt_mstr then leave.
./*GG22*/             for each inmstr where in_part = pt_part
./*GG22*/             and not can-find (ptp_det where ptp_part = pt_part  and
./*GG22*/             ptp_site = in_site):
./*GG22*/                sitept = inmstr.in_site.
./*GG22*/                partpt = inmstr.in_part.
./*GG22*/                {inmrp.i &part=partpt &site=sitept}
./*GG22*/             end.
./*GG22*/          end.
.
.                  release pt_mstr.
**F0WG** END DELETED SECTION **/
               end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* do on error */
            end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* b-loop: repeat with frame b: */
         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* mainloop: repeat with frame a: */
         status input.