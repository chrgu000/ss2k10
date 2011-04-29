/* wowomt.p - WORK ORDER MAINTENANCE                                    */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 7.0      LAST EDIT: 10/11/91      MODIFIED BY: emb *F024*/
/* REVISION: 7.0      LAST EDIT: 02/20/92      MODIFIED BY: pma *F217**/
/* REVISION: 7.0      LAST EDIT: 02/21/92      MODIFIED BY: emb *F227**/
/* REVISION: 7.0      LAST EDIT: 02/28/92      MODIFIED BY: pma *F085**/
/* REVISION: 7.0      LAST EDIT: 03/23/92      MODIFIED BY: pma *F089**/
/* REVISION: 7.0      LAST EDIT: 04/29/92      MODIFIED BY: emb *F457**/
/* REVISION: 7.0      LAST EDIT: 06/18/92      MODIFIED BY: JJS *F672* (rev) */
/* REVISION: 7.0      LAST EDIT: 07/01/92      MODIFIED BY: afs *F723* (rev) */
/* REVISION: 7.0      LAST EDIT: 07/02/92      MODIFIED BY: emb *F729**/
/* REVISION: 7.0      LAST EDIT: 10/05/92      MODIFIED BY: emb *G125**/
/* REVISION: 7.3      LAST EDIT: 09/27/92      MODIFIED BY: jcd *G255**/
/* REVISION: 7.3      LAST EDIT: 11/03/92      MODIFIED BY: emb *G268* (rev) */
/* REVISION: 7.3      LAST EDIT: 12/22/92      MODIFIED BY: tjs *G463* (rev) */
/* REVISION: 7.3      LAST EDIT: 03/04/93      MODIFIED BY: emb *G870**/
/* REVISION: 7.3      LAST EDIT: 09/03/93      MODIFIED BY: pma *GE81* (rev) */
/* REVISION: 7.3      LAST EDIT: 11/16/93      MODIFIED BY: pxd *GH30**/
/* REVISION: 7.3      LAST EDIT: 12/22/93      MODIFIED BY: ais *GI25**/
/* REVISION: 8.5      LAST EDIT: 03/22/94      MODIFIED BY: tjs *J014**/
/* REVISION: 7.3      LAST EDIT: 04/06/94      MODIFIED BY: pma *FN27**/
/* REVISION: 7.3      LAST EDIT: 07/14/94      MODIFIED BY: ais *FP42**/
/* REVISION: 7.3      LAST EDIT: 08/08/94      MODIFIED BY: pxd *FP91**/
/* REVISION: 7.3      LAST EDIT: 09/01/94      MODIFIED BY: ljm *FQ67**/
/* REVISION: 7.3      LAST EDIT: 09/27/94      MODIFIED BY: rmh *FR82**/
/* REVISION: 8.5      LAST EDIT: 10/20/94      MODIFIED BY: mwd *J034**/
/* REVISION: 7.3      LAST EDIT: 10/31/94      MODIFIED BY: WUG *GN76**/
/* REVISION: 8.5      LAST EDIT: 11/30/94      MODIFIED BY: taf *J040**/
/* REVISION: 7.3      LAST EDIT: 12/27/94      MODIFIED BY: srk *G0B2**/
/* REVISION: 7.3      LAST EDIT: 02/10/95      MODIFIED BY: pxd *F0HS**/
/* REVISION: 7.3      LAST EDIT: 02/15/95      MODIFIED BY: pxe *F0H7**/
/* REVISION: 8.5      LAST EDIT: 03/07/95      MODIFIED BY: tjs *J027**/
/* REVISION: 7.3      LAST EDIT: 03/27/95      MODIFIED BY: srk *G0JB**/
/* REVISION: 7.2      LAST EDIT: 04/13/95      MODIFIED BY: ais *F0PM**/
/* REVISION: 7.2      LAST EDIT: 05/24/95      MODIFIED BY: qzl *F0S4**/
/* REVISION: 8.5      LAST EDIT: 06/07/95      MODIFIED BY: sxb *J04D**/
/* REVISION: 8.5      LAST EDIT: 06/16/95      MODIFIED BY: rmh *J04R**/
/* REVISION: 7.2      LAST EDIT: 06/19/95      MODIFIED BY: qzl *F0ST**/
/* REVISION: 7.3      LAST EDIT: 10/24/95      MODIFIED BY: jym *G19X**/
/* REVISION: 7.3      LAST EDIT: 11/10/95      MODIFIED BY: rvw *G1CZ**/
/* REVISION: 8.5      LAST EDIT: 04/11/96      BY: *J04C* Sue Poland    */
/* REVISION: 8.5      LAST EDIT: 04/11/96      BY: *J04C* Markus Barone */
/* REVISION: 8.5      LAST EDIT: 06/11/96      BY: *G1XY* Russ Witt     */
/* REVISION: 8.5      LAST EDIT: 07/26/96      BY: *J10X* Markus Barone */
/* REVISION: 8.5      LAST EDIT: 02/04/97      BY: *J1GW* Murli Shastri */
/* REVISION: 8.5      LAST EDIT: 05/11/97      BY: *G2MF* Julie Milligan*/

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan        */
/* REVISION: 9.0      LAST MODIFIED: 12/08/98   BY: *M02C* Jim Williams      */
/* REVISION: 9.0      LAST MODIFIED: 02/04/99   BY: *J38K* Viswanathan M     */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 11/14/99   BY: *N05J* Michael Amaladhas */
/* REVISION: 9.1      LAST MODIFIED: 12/15/99   BY: *L0MR* Rajesh Thomas     */
/* REVISION: 9.1      LAST MODIFIED: 02/07/00   BY: *M0JN* Kirti Desai       */
/* REVISION: 9.1      LAST MODIFIED: 03/06/00   BY: *N05Q* Vincent Koh       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 06/06/00   BY: *L0YT* Vandna Rohira     */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* myb               */
/* REVISION: eB sp5 chui  LAST MODIFIED: 08/31/05  BY: *eas050a* Kaine Zhang */
/* REVISION: eB sp5 chui  LAST MODIFIED: 03/27/07  BY: *ss - eas058* Apple Tam */
/* SS - 091230.1  By: Roger Xiao */ /*add part rev , initial value from pt_mstr.pt_rev, can modify to sod__chr09 (rev) */
/* SS - 100415.1  By: Roger Xiao */ /*add rcdxwtp ,program logic of xxwowor1.p and xxwowor2.p , spec eas056,eas057*/ 


/*F217*****************************************************************/
/*     MAKE SURE THAT ANY CHANGES TO THIS PROGRAM ARE ALSO REFLECTED  */
/*     IN REWOMT.P UNLESS REPETITIVE DOES NOT USE THAT FEATURE        */
/*F217*****************************************************************/
/*M02C*********************************************************************/
/*     PROGRAM wowomt.p WAS USED AS A TEMPLATE FOR NEW PROGRAM giapimpc.p */
/*     IN THE ON/Q PLANNING AND OPTIMIZATION API INTERFACE PROJECT.  NEW  */
/*     FUNCTIONAL AND STRUCTURAL CHANGES MADE TO wowomt.p SHOULD BE       */
/*     EVALUATED FOR SUITABILITY FOR INCLUSION WITHIN giapimpc.p.         */
/*M02C*********************************************************************/

         {mfdtitle.i "100415.1"} /*GI25*/

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE wowomt_p_1 "Comments"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowomt_p_2 "Adjust Co/By Order Quantities"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowomt_p_3 "Adjust Co/By Order Dates"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/*       define shared variable mfguser as character.           *G255* */
/* SS - 100415.1 - B */
         define new shared variable rcdxwtp as recid no-undo.
         define new shared variable strwopttype like pt_part_type no-undo.
         define var v_choice as logical  no-undo . 
/* SS - 100415.1 - E */

         define new shared variable comp like ps_comp.
         define new shared variable qty like wo_qty_ord.
         define new shared variable eff_date as date.
         define new shared variable wo_recno as recid.
         define new shared variable leadtime like pt_mfg_lead.
         define new shared variable prev_status like wo_status.
         define new shared variable prev_release like wo_rel_date.
         define new shared variable prev_due like wo_due_date.
         define new shared variable prev_qty like wo_qty_ord.
         define new shared variable any_issued like mfc_logical.
/*G125*/ define new shared variable any_feedbk like mfc_logical.
/*J027*/ /* begin added block */
         define new shared variable wo_recno1      as recid.
         define new shared variable jpwo_recno     as recid.
         define new shared variable prev_ord       like wo_ord_date.
         define new shared variable del-joint      like mfc_logical initial no.
         define new shared variable wopart         like wo_part.
         define new shared variable joint_type     like wo_joint_type.
         define new shared variable qty_type       like wo_qty_type.
         define new shared variable prod_pct       like wo_prod_pct.
         define new shared variable no_msg         like mfc_logical initial no.
         define new shared variable screen_used    like mfc_logical.
         define new shared variable err_msg        as integer.
         define new shared variable add_2_joint    like mfc_logical.
         define new shared variable rel_date       like wo_rel_date.
         define new shared variable due_date       like wo_due_date.
         define new shared variable base_lot       like wo_lot.
         define new shared variable base_qty       like wo_qty_ord.
         define new shared variable base_um        like bom_batch_um.
         define new shared variable prev_routing   like wo_routing.
         define new shared variable prev_bomcode   like wo_bom_code.
         define new shared variable updt_subsys    like mfc_logical.
         define new shared variable joint_qtys     like mfc_logical
/*J1GW*  label "Adjust joint order quantities" initial yes. */
/*J1GW*/ label {&wowomt_p_2} initial yes.
         define new shared variable joint_dates    like mfc_logical
/*J1GW*  label "Adjust joint order dates" initial yes. */
/*J1GW*/ label {&wowomt_p_3} initial yes.

         define variable jplabel        as character format "x(15)".
         define variable valid_mnemonic like mfc_logical.
         define variable prod_percent   like mfc_logical.
         define variable joint_label    like lngd_translation.
         define variable joint_code     like wo_joint_type.
         define variable conv           like ps_um_conv.
/*J027*/ /* End added block */
         define new shared variable cmtindx like wo_cmtindx.
         define new shared variable del-yn like mfc_logical initial no.
         define new shared variable deliv like wod_deliver.
         define new shared variable prev_site like wo_site.
         define new shared variable undo_all like mfc_logical no-undo.
/*G1XY*/ define new shared variable critical-part like wod_part no-undo.
/*G0JB*/ define new shared variable wonbr like wo_nbr.
/*G0JB*/ define new shared variable wolot like wo_nbr.
/*G0JB*/ define new shared variable know_date as date.
/*G0JB*/ define new shared variable find_date as date.
/*G0JB*/ define new shared variable interval as integer.
/*G0JB*/ define new shared variable frwrd as integer.
/*G0JB*/ define new shared variable undoretrymain as logical.
/*G0JB*/ define new shared variable undoleavemain as logical.
/*G0JB*/ define new shared variable pt_rec as recid.
         define
/*F085*/ new shared
         variable new_wo like mfc_logical initial no.

         define variable i as integer.
         define variable nonwdays as integer.
         define variable workdays as integer.
         define variable overlap as integer.
/*G0JB*  define variable know_date as date. */
/*G0JB*  define variable find_date as date. */
/*G0JB*  define variable interval as integer. */
/*FQ67*  define variable forward as integer. */
/*G0JB* /*FQ67*/ define variable frwrd as integer. */
         define variable yn like mfc_logical initial no.
/*G0JB*  define variable wonbr like wo_nbr. */
/*G0JB*  define variable wolot like wo_lot. */
         define variable wocmmts like woc_wcmmts label {&wowomt_p_1}.
/*J027*  define variable prev_routing like wo_routing.  */
/*J027*  define variable prev_bomcode like wo_bom_code. */
/*F227*/ define variable msg-type as integer.
/*F085*/ define variable glx_mthd like cs_method.
/*F085*/ define variable glx_set like cs_set.
/*F085*/ define variable cur_mthd like cs_method.
/*F085*/ define variable cur_set like cs_set.
/*L0MR** /*F085*/ define variable prev_mthd like cs_method. */
/*G870*/ define variable msg-counter as integer.
/*G0JB* /*F089*/ define variable ptstatus like pt_status. */
/*F0PM*/ define variable do-delete as logical.
/*J04D** define variable woattr like mfc_logical label "Set Attributes". ****/
/*L0MR*/ define new shared variable prev_mthd    like cs_method   no-undo.
/*M0JN*/ define new shared variable critical_flg like mfc_logical no-undo.

/*J040*/ define new shared frame attrmt.
/*J027*/ define buffer wo_mstr1 for wo_mstr.
/*G0JB*/ define new shared frame a.
/*J027*/ define new shared frame b.

/*J10X*/ if can-find(first qad_wkfl where qad_key1 = "WO-CLOSE") then do:
/*J10X*/    {mfmsg.i 1361 1}
/*J10X*/    /* OLD WORK ORDER DATA STORAGE HAS BEEN DETECTED IN QAD_WKFL */
/*J10X*/    {mfmsg.i 1362 1}
/*J10X*/    /* PLEASE RUN "UTQADWO.P" BEFORE EXECUTING THIS FUNCTION     */
/*J10X*/    pause.
/*J10X*/    hide message no-pause.
/*J10X*/    return.
/*J10X*/ end.

/*J040*  ATTRIBUTES FRAME DEFINITION */
/*J040*/ {mfwoat.i}

/*J04D** find first icc_ctrl no-lock no-error. ***/
/*J04D** if available icc_ctrl and icc_lotlev <> 0 then woattr = yes. ***/
/*J04D*/ {gprun.i ""gplotwdl.p""}

/*J027*/ do transaction on error undo, retry:
            find first woc_ctrl no-lock no-error.
/*J027*/    if not available woc_ctrl then create woc_ctrl.
            if available woc_ctrl then wocmmts = woc_wcmmts.
/*J027*/    release woc_ctrl.
/*J027*/ end.

/*M0JN*/ assign
/*M0JN*/    critical_flg = no
            eff_date     = today.

         form
            wo_nbr         colon 25
            wo_lot
            wo_part        colon 25
            pt_desc1       at 47 no-label
            wo_type        colon 25
            pt_desc2       at 47 no-label
            wo_site        colon 25
/*J027*/    joint_label    at 47 no-label
         with frame a side-labels width 80 attr-space.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).

         form
            wo_qty_ord     colon 25
            wo_ord_date    colon 55
            wo_qty_comp    colon 25
            wo_rel_date    colon 55
            wo_qty_rjct    colon 25
            wo_due_date    colon 55
            skip(1)
            wo_status      colon 25
            wo_site        colon 55
            wo_so_job      colon 25
            wo_routing     colon 55
            wo_vend        colon 25
            wo_bom_code    colon 55
            wo_yield_pct   colon 25
            /*eas050a*/  wo__dte01 COLON 55 LABEL "close date"
            skip(1)
/*F003      wo_acct        colon 25 wo_cc no-label wo_project */
/* SS - 091230.1 - B */
            wo__chr05      colon 25 label "Part Rev" format "x(4)"
/* SS - 091230.1 - E */
            wo_rmks        colon 25
            wocmmts        colon 25
/*F003*/    wo_var         colon 62
         with frame b side-labels width 80 attr-space.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame b:handle).

         /* DISPLAY */
         view frame a.
         view frame b.

         mainloop:
         repeat:
            do transaction with frame a:

               prev_status = "".
/*J027*/       prev_ord = ?.
               prev_release = ?.
               prev_due = ?.
               prev_qty = 0.
               leadtime = 0.
               new_wo = no.

               prompt-for wo_nbr wo_lot editing:
                  if frame-field = "wo_nbr" then do:
                     /* FIND NEXT/PREVIOUS RECORD */
                     {mfnp.i wo_mstr wo_nbr wo_nbr wo_nbr wo_nbr wo_nbr}

/*G0B2* BEGIN - MOVED TO BELOW *****************
*                    if recno <> ? then do:
*                       find pt_mstr where pt_part = wo_part
*                       no-lock no-error no-wait.
*                       if available pt_mstr then display pt_desc1 pt_desc2.
*                       else display " " @ pt_desc1 " " @ pt_desc2.
*                       display wo_nbr wo_lot wo_part wo_type wo_site
*                               with frame a.
*                       display wo_qty_ord wo_qty_comp wo_qty_rjct
*                               wo_ord_date wo_rel_date wo_due_date
*                               wo_status wo_so_job wo_vend wo_yield_pct
*                               wo_site wo_routing wo_bom_code
* /*F003                        wo_acct wo_cc wo_project */
*                               wo_rmks wocmmts
* /*F003*/                      wo_var
*                       with frame b.
*                    end.
**G0B2* END - MOVED **********/

                  end.
                  else if frame-field = "wo_lot" then do:

                     /* FIND NEXT/PREVIOUS RECORD */
                     {mfnp.i wo_mstr wo_lot wo_lot wo_nbr wo_nbr wo_lot}

/*G0B2*/          end.
                  else do:
                     readkey.
                     apply lastkey.
                  end.

                     if recno <> ? then do:
                        find pt_mstr where pt_part = wo_part
                        no-lock no-error no-wait.
                        if available pt_mstr then display pt_desc1 pt_desc2.
                        else display " " @ pt_desc1 " " @ pt_desc2.
/*L0YT** /*G1CZ*/       if wo_cmtindx > 0 then wocmmts = yes. */
/*L0YT** /*G1CZ*/       else wocmmts = no.                    */

/*L0YT*/             /* BEGIN ADD SECTION */

                     for first woc_ctrl
                        fields(woc_auto_nbr woc_nbr woc_wcmmts)
                        no-lock:
                     end. /* FOR FIRST WOC_CTRL */
                     if wo_cmtindx > 0
                        or (available woc_ctrl and woc_wcmmts) then
                        wocmmts = yes.
                     else
                        wocmmts = no.

/*L0YT*/             /* END ADD SECTION  */

/*J027*/ /* Begin added block */
                        if wo_joint_type <> "" then do:
                           /* Numeric wo_joint_type returns alpha code, label */
                           {gplngn2a.i &file     = ""wo_mstr""
                                       &field    = ""wo_joint_type""
                                       &code     = wo_joint_type
                                       &mnemonic = joint_code
                                       &label    = joint_label}
                        end.
                        else do:
                           joint_code = "".
                           joint_label = "".
                        end.
/*J027*/ /* End added block */
                        display wo_nbr wo_lot wo_part wo_type wo_site
/*J027*/                        joint_label
                                with frame a.
                        display wo_qty_ord wo_qty_comp wo_qty_rjct
                                wo_ord_date wo_rel_date wo_due_date
                                wo_status wo_so_job wo_vend wo_yield_pct
                                wo_site wo_routing wo_bom_code
                                wo_rmks wocmmts wo_var
                                /*eas050a*/  wo__dte01
                                /* SS - 091230.1 - B */ wo__chr05
/*J04D*                         woattr */
                        with frame b.
                     end.

/*G0B2*           end.
 *                else do:
 *                   readkey.
 *                   apply lastkey.
 *                end.
 *G0B2*/ /*END THROUGH LASTKEY STATEMENTS MOVED TO ABOVE DISPLAY*/
               end.
            end. /* transaction */

/*J027*/    joint_type = "".
            do transaction:

               /* ADD/MOD/DELETE */
               if available wo_mstr then release wo_mstr.
               wonbr = "".
               wolot = "".
               if input wo_nbr <> "" and input wo_lot <> "" then
                  find wo_mstr no-lock use-index wo_lot
                  using wo_lot and wo_nbr no-error.
               if input wo_nbr = "" and input wo_lot <> "" then
                  find wo_mstr no-lock use-index wo_lot using wo_lot no-error.
               if input wo_nbr <> "" and input wo_lot = "" then
                  find first wo_mstr no-lock use-index wo_nbr
                  using wo_nbr no-error.
               if not available wo_mstr then if input wo_lot <> "" then
                  find wo_mstr no-lock use-index wo_lot using wo_lot no-error.

               if available wo_mstr then do:
/*N05Q*/          /* PREVENT ACCESS TO PROJECT ACTIVITY RECORDING WORKORDERS */
/*N05Q*/          if wo_fsm_type = "PRM" then do:
/*N05Q*/             {mfmsg.i 3426 3}
/*N05Q*/             /* CONTROLLED BY PRM MODULE */
/*N05Q*/             undo mainloop, retry mainloop.
/*N05Q*/          end.
                  /* PREVENT ACCESS TO CALL ACTIVITY RECORDING WORK ORDERS */
/*J04C*/          if wo_fsm_type = "FSM-RO" then do:
/*J04C*/             {mfmsg.i 7492 3}
/*J04C*/             /* FIELD SERVICE CONTROLLED.  */
/*J04C*/             undo mainloop, retry mainloop.
/*J04C*/          end.
                  if wo_nbr <> input wo_nbr and input wo_nbr <> "" then do:
                     {mfmsg.i 508 3}
                     /* LOT NUMBER ENTERED BELONGS TO DIFFERENT WORK ORDER.*/
                     undo mainloop, retry mainloop.
                  end.
                  wolot = wo_lot.
/*G870*           {mfmsg.i 10 1} */

                  find pt_mstr where pt_part = wo_part no-lock no-error.
/*J027*           if avail pt_mstr then do:                              */
/*J027*              leadtime = pt_mfg_lead.                             */
/*J027*           end.                                                   */
/*J027*/ /* Begin added block */
                  if available pt_mstr then display pt_desc1 pt_desc2
                  with frame a.
                  else display " " @ pt_desc1 " " @ pt_desc2 with frame a.
                  if wo_joint_type <> "" then do:
                     /* Numeric wo_joint_type returns alpha code & label */
                     {gplngn2a.i &file     = ""wo_mstr""
                                 &field    = ""wo_joint_type""
                                 &code     = wo_joint_type
                                 &mnemonic = joint_code
                                 &label    = joint_label}
                     if wo_joint_type = "5"
                     then base_lot = wo_lot.
                     else base_lot = wo_base_id.
                  end.
                  else do:
                     joint_code = "".
                     joint_label = "".
                  end.
                  display joint_label with frame a.
/*J027*/ /* End added block */
/*GN76*/ /* ADDED FOLLOWING SECTION*/
                  if wo_type = "c" and wo_nbr = "" then do:
                     /* WORK ORDER TYPE IS CUMULATIVE */
                     {mfmsg.i 5123 3}
                     undo mainloop, retry mainloop.
                  end.
/*GN76*/ /* END SECTION*/
               end.
               else do:  /* not available wo_mstr */

                  if input wo_nbr <> ""
/*FN27*/          and input wo_nbr <> ?
                  then wonbr = input wo_nbr.
                  else do:
                     find first woc_ctrl no-lock no-error.
/*J027*              if not available woc_ctrl then create woc_ctrl. */
                     if not woc_auto_nbr then undo mainloop, retry mainloop.
                     {mfnctrl.i woc_ctrl woc_nbr wo_mstr wo_nbr wonbr}
                  end.
                  if input wo_lot <> ""
/*FN27*/          and input wo_lot <> ?
                  then wolot = input wo_lot.
                  else do:
                     /* Get next lot number */
/*J04R*              {mfnctrl.i woc_ctrl woc_lot wo_mstr wo_lot wolot} */
/*J04R*/             {mfnxtsq.i wo_mstr wo_lot woc_sq01 wolot}
                  end.
                  release woc_ctrl.
                  if wonbr = "" or wolot = "" then undo, retry.
                  display wonbr @ wo_nbr wolot @ wo_lot with frame a.
               end.
            end. /* transaction */

            do transaction:

/*G870*/       if keyfunction (lastkey) = "end-error" then next mainloop.

/*G870*        find wo_mstr use-index wo_lot where wo_lot = wolot no-error. */

/*J027*/       if available wo_mstr and wo_joint_type = "" then do:
/*G870*/          {gplock.i
                     &file-name="wo_mstr"
                     &find-criteria="wo_lot = wolot"
                     &exit-allowed=yes
                     &record-id=wo_recno}
/*J027*/ /* Begin added block */
               end.
               if (available wo_mstr and wo_joint_type <> "")
               or (not available wo_mstr and joint_type <> "") then do:
                  if available wo_mstr then do:
                     wonbr = wo_nbr.
                     wolot = wo_lot.
                  end.
                  /* Lock all the joint WOs */
                  /* If any in group are locked undo & issue message */
                  /* Record is locked. Please try again later */
                  {gplock1.i
                     &file-name="wo_mstr"
                     &group-criteria="wo_nbr = wonbr and wo_type = """""
                     &find-criteria="wo_lot = wolot"
                     &undo-block=mainloop
                     &retry="retry mainloop"
                     &record-id=wo_recno}
                  /* gplock1.i also done later in wowomtc.p */
               end.
/*J027*/ /* End added block */

/*G870*/       if keyfunction(lastkey) = "end-error" then undo mainloop, retry.

/*J034*/       if available wo_mstr then do:
/*J034*/          {gprun.i ""gpsiver.p""
                  "(input wo_site, input ?, output return_int)"}
/*J034*/          if return_int = 0 then do:
/*J034*/             display wo_nbr wo_lot wo_part wo_type wo_site
/*J034*/             with frame a.
/*J034*/             {mfmsg.i 725 3} /* USER DOES NOT HAVE ACCESS TO THIS SITE*/
/*J034*/             undo mainloop, retry mainloop.
/*J034*/          end.
/*J034*/       end.

               if not available wo_mstr then do with frame a:
/*J027*/ /* Begin added block */
                  clear frame b no-pause.
                  wo_recno = ?.
                  wopart = "".
                  screen_used = yes.
/*G0JB*/          undoleavemain = no.
                  /* Create wo_mstr, set part type & site, and take defaults */
                  {gprun.i ""wowomtc.p""}
/*G0JB*/          if undoleavemain then undo mainloop, leave mainloop.
                  if undo_all then undo mainloop, retry mainloop.
                  find wo_mstr exclusive-lock where recid(wo_mstr) = wo_recno.
                  find pt_mstr no-lock where recid(pt_mstr) = pt_recno.
                  /* SS - 091230.1 - B */ 
                  wo__chr05 = if avail pt_mstr then pt_rev else "" .
                  /* SS - 091230.1 - E */
/*J027*/ /* End added block */

/*J027*********** BEGIN DELETED SECTION ****************************************
         *        {mfmsg.i 1 1}
         *        new_wo = yes.
         *        create wo_mstr.
         *        assign wo_nbr = wonbr
         *               wo_lot = wolot.
/*G0JB*/ *         wo_recno = recid(wo_mstr).
 *J027************END DELETED SECTION *****************************************/
/*G0JB*********** BEGIN DELETED SECTION ****************************************
         *        display wo_nbr wo_lot.
/*F089*/ *        setitem:
         *        do on error undo, retry:
/*FR82*/ *           if retry and batchrun then
/*FR82*/ *              undo mainloop, leave mainloop.
         *           set wo_part wo_type wo_site editing:
         *              if frame-field = "wo_part" then do:
         *                 /* FIND NEXT/PREVIOUS RECORD */
         *                 {mfnp.i pt_mstr wo_part pt_part wo_part
         *                         pt_part pt_part}
         *                 if recno <> ? then
         *                 display pt_part @ wo_part pt_desc1 pt_desc2.
         *              end.
         *              else do:
         *                 readkey.
         *                 apply lastkey.
         *              end.
         *           end.
         *           assign wo_part
         *           wo_type = caps(input wo_type).
         *           find pt_mstr no-lock where pt_part = wo_part no-error.
         *           if available pt_mstr then do:
/*F089*/ *              ptstatus = pt_status.
/*F089*/ *              substring(ptstatus,9,1) = "#".
/*F089*/ *              if can-find(isd_det where isd_status = ptstatus
/*F089*/ *              and isd_tr_type = "ADD-WO") then do:
/*F089*/ *                  {mfmsg02.i 358 3 pt_status}
/*F089*/ *                  undo setitem, retry.
/*F089*/ *              end.
         *              leadtime = pt_mfg_lead.
         *              wo_part = pt_part.
         *              wo_yield_pct = pt_yield_pct.
         *              wo_routing = pt_routing.
/*F729*/ *              wo_bom_code = pt_bom_code.
         *              if wo_site = "" then
         *              wo_site = pt_site.
         *              find ptp_det no-lock where ptp_part = wo_part and
         *              ptp_site = wo_site no-error.
         *              if available ptp_det then assign
         *                wo_yield_pct = ptp_yld_pct
         *                    leadtime = ptp_mfg_lead
         *                  wo_routing = ptp_routing
         *                 wo_bom_code = ptp_bom_code.
         *              find first woc_ctrl no-lock.
         *              wo_var = woc_var.
         *           end.
         *           else do:
         *              {mfmsg.i 17 3}
         *              undo, retry.
         *           end.
         *           if wo_type <> "" and index("RE",wo_type) = 0 then do:
         *              {mfmsg.i 13 3}
         *              next-prompt wo_type.
         *              undo, retry.
         *           end.
         *        end.
         *        wo_status = "F".
         *        wo_ord_date = today.
         *        wo_rel_date = today.
         *        wo_due_date = ?.
         *        find first woc_ctrl no-lock.
         *        wo_var = woc_var.
         *
         *        {mfdate.i wo_rel_date wo_due_date leadtime wo_site}
 *G0JB*********** END DELETED SECTION *****************************************/
/*J027*********** BEGIN DELETED SECTION ****************************************
/*G0JB*/ *        undoleavemain = no.
/*G0JB*/ *        undoretrymain = yes.
/*G0JB*/ *        {gprun.i ""wowomtk.p""}
/*G0JB*/ *        if undoleavemain then undo mainloop, leave mainloop.
/*G0JB*/ *        if undoretrymain then undo mainloop, retry mainloop.
/*G0JB*/ *        if pt_rec <> ? then
/*G0JB*/ *           find pt_mstr where pt_rec = recid(pt_mstr)
/*F0PM*/ *           no-lock no-error.
 *J027************ END DELETED SECTION ****************************************/
               end.

/*G0JB*/       assign
                  prev_status = wo_status
/*J027*/          prev_ord = wo_ord_date
                  prev_release = wo_rel_date
                  prev_due = wo_due_date
                  prev_qty = wo_qty_ord
                  prev_site = wo_site
                  prev_routing = wo_routing
                  prev_bomcode = wo_bom_code.
/*J027*        if new wo_mstr and index("R",wo_type) > 0 then wo_status = "A".*/
/*J027*        if new wo_mstr and index("E",wo_type) > 0 then wo_status = "R".*/
/*J027*/       if new_wo and index("R",wo_type) > 0 then wo_status = "A".
/*J027*/       if new_wo and index("E",wo_type) > 0 then wo_status = "R".

/*F085*/       /*DETERMINE COSTING METHOD*/
/*F085*/       {gprun.i ""csavg01.p"" "(input wo_part,
                                        input wo_site,
                                        output glx_set,
                                        output glx_mthd,
                                        output cur_set,
                                        output cur_mthd)"
               }
/*F085*/       if glx_mthd = "AVG" then wo_var = no.
/*F085*/       prev_mthd = glx_mthd.

/*J027*        recno = recid(pt_mstr).    */
/*J027*        wo_recno = recid(wo_mstr). */

/*FP91*        ststatus = stline[2].      */
/*FP91*        status input ststatus.     */
               del-yn = no.

               /* SET GLOBAL ITEM VARIABLE */
/*G0JB*/       assign
                 global_part = wo_part
                 global_site = wo_site.

/*G1CZ*/       /* SET COMMENT DEFAULT FIELD      */
/*G1CZ*/       if new_wo then do:
/*G1CZ*/          if available woc_ctrl then wocmmts = woc_wcmmts.
/*G1CZ*/       end.
/*G1CZ*/       else do:
/*N05J*/          find first woc_ctrl no-lock no-error.
/*N05J*  /*G1CZ*/          if wo_cmtindx > 0 then wocmmts = yes. */
/*N05J*/          if wo_cmtindx > 0  or
/*N05J*/             (available woc_ctrl and woc_wcmmts) then wocmmts = yes.
/*G1CZ*/          else wocmmts = no.
/*N05J*/          release woc_ctrl.
/*G1CZ*/       end.

/*J04D*        if wo_type = "C" then woattr = no. */

               display wo_nbr wo_lot wo_part wo_type wo_site
               with frame a.

               display wo_qty_ord wo_qty_comp wo_qty_rjct
                       wo_ord_date wo_rel_date wo_due_date
                       wo_status wo_so_job wo_vend wo_yield_pct
                       wo_site wo_routing wo_bom_code
                       wo_rmks wocmmts
                       wo_var
                       /*eas050a*/  wo__dte01
                       /* SS - 091230.1 - B */ wo__chr05
/*J04D*                woattr */
               with frame b.

                /* SS - 100415.1 - B */
                v_choice = no.
                for first xwtp_det
                    where wo_nbr begins xwtp_type
                        and xwtp_site = wo_site
                        and xwtp_is_ser = no
                    no-lock:
                end.            
                if not available xwtp_det then do:
                    for first xwtp_det
                        where wo_nbr begins xwtp_type
                            and xwtp_site = wo_site
                            and xwtp_is_ser = yes
                        no-lock:
                    end.   
                    if available xwtp_det then do:
                        v_choice = yes .
                        rcdxwtp = recid(xwtp_det) .
                        for first pt_mstr where pt_part = wo_part no-lock:  end.
                        strwopttype = if available pt_mstr then pt_part_type else "" .                
                    end.                
                end.
                else do:
                    v_choice = no .
                    rcdxwtp = recid(xwtp_det) .
                end.
                /* SS - 100415.1 - E */

/*J027*        if available pt_mstr then display pt_desc1 pt_desc2      */
/*J027*        with frame a.                                            */
/*J027*        else display " " @ pt_desc1 " " @ pt_desc2 with frame a. */

/*J027*/       /* Update frame b */
/*eas050a*  /*J027*/       {gprun.i ""wowomtj.p""}  */
/*eas050a*/       {gprun.i ""xxwowomtj.p""}
/*J027*/       if undo_all then undo mainloop, retry mainloop.
/*J027*/       find wo_mstr exclusive-lock where recid(wo_mstr) = wo_recno.

/*J027*********** The following code was moved to wowomtj.p ********************
/*FP91*/  *    ststatus = stline[2].
/*FP91*/  *    status input ststatus.
          *    detail-loop:
          *    do on error undo, retry with frame b:
          *
          *       set wo_qty_ord wo_ord_date wo_rel_date wo_due_date
          *          wo_status wo_so_job wo_vend wo_yield_pct
          *          wo_site wo_routing wo_bom_code
          *          wo_rmks
          *          wocmmts
          *          wo_var
/*F085*/  *          when glx_mthd <> "AVG"
          *       go-on(F5 CTRL-D).
          *
/*GH30*/  *       if wo_qty_ord * wo_qty_comp <  0 then do:
/*GH30*/  *        {mfmsg.i 556 3}.
/*GH30*/  *        undo, retry.
/*GH30*/  *       end.
          *
/*F0H7*/  *       if wo_qty_ord * prev_qty <  0 then do:
/*F0H7*/  *        {mfmsg.i 95 3}.
/*F0H7*/  *        undo, retry.
/*F0H7*/  *       end.
          *
/*F0H7*/  *       if wo_qty_ord = 0 and  prev_qty <>  0 then do:
/*F0H7*/  *        {mfmsg.i 317 3}.
/*F0H7*/  *        undo, retry.
/*F0H7*/  *       end.
          *
          *       /* DELETE */
          *       if lastkey = keycode("F5")
          *       or lastkey = keycode("CTRL-D")
          *       then do:
          *
/*G1CZ*/  *       /* ISSUE WARNING IF QUALITY TEST RESULTS EXIST FOR THIS W/O */
/*G1CZ*/  *          find first mph_hist where mph_lot = wo_lot no-lock
/*G1CZ*/  *               no-error.
/*G1CZ*/  *          if available mph_hist then do:
/*G1CZ*/  *               {mfmsg02.i 7109 2 mph_part}.
/*G1CZ*/  *       /* QUALITY TEST RESULTS EXIST FOR THIS WORK ORDER FOR ITEM# */
/*G1CZ*/  *               pause.
/*G1CZ*/  *          end.
          *
          *          if wo_wip_tot <> 0 then do:
          *          /* Delete not allowed, w.order accounting must be closed*/
          *             {mfmsg.i 536 3}
          *             undo.
          *          end.
          *
/*F0PM*/  *          /* BEGIN ADDED SECTION TO VERIFY DELETE CAN BE DONE */
          *          do-delete = true.
/*G19X* * BEGIN COMMENT OUT *
 *                   for each wr_route
 *                   where wr_nbr = wo_nbr and wr_lot = wo_lot no-lock:
 *                      if wr_bdn_std <> 0 or
 *                         wr_lbr_std <> 0 or
 *                         wr_sub_std <> 0
 *                      then do:
 *                         do-delete = false.
 *                         leave.
 *                      end.
 *                   end.
 *
 *                   if do-delete
 *                   then do:
 *                      for each wod_det
 *                      where wod_nbr = wo_nbr and wod_lot = wo_lot
 *                      no-lock:
 *                         if wod_tot_std <> 0 or
 *                            wod_qty_iss <> 0
 *                         then do:
 *                            do-delete = no.
 *                            leave.
 *                         end.
 *                      end.
 *                   end.
 *
 *G19X* * * END COMMENT OUT */
          *
/*G19X*/  *          if wo_status = "C" and
/*G19X*/  *            can-find(qad_wkfl where qad_key1 = "WO-CLOSE" and
/*G19X*/  *                     qad_key2 = wo_lot) and
/*G19X*/  *            wo_wip_tot = 0 then do-delete = true.
          *
/*G19X*/  *          else if can-do("P,B,F",wo_status) and
/*G19X*/  *            wo_wip_tot = 0 then do-delete = true.
          *
/*G19X*/  *          else do-delete = false.
          *          if not do-delete
          *          then do:
          *             {mfmsg.i 536 3}
          *             undo.
/*F0PM*/  *          end.
          *          del-yn = yes.
          *          {mfmsg01.i 11 1 del-yn}
          *          if del-yn = no then undo.
          *
          *       end.
          *
          *       if not del-yn then do:
          *
/*GI25*/  *          find ptp_det no-lock
/*GI25*/  *          where ptp_part = wo_part and ptp_site = wo_site no-error.
/*GI25*/  *          if available ptp_det
/*GI25*/  *          then leadtime = ptp_mfg_lead.
          *          if wo_ord_date = ? then wo_ord_date = today.
          *          if wo_rel_date = ? and wo_due_date = ? then
          *          wo_rel_date = max(today,wo_ord_date).
/*F0S4*   *          if wo_rel_date = ? or wo_due_date = ? then do:
*         *             {mfdate.i wo_rel_date wo_due_date leadtime wo_site}
*         *          end.    *F0S4*/
          *          disp wo_rel_date wo_due_date.
          *          if wo_due_date < wo_rel_date then do:
          *             {mfmsg.i 514 3}
          *             /* DUE DATE BEFORE RELEASE DATE NOT ALLOWED.*/
          *             next-prompt wo_rel_date.
          *             undo, retry.
          *          end.
          *          if wo_status = "" then wo_status = prev_status.
          *
/*F0HS    *          if wo_status = "" then wo_status = prev_status.  */
/*F0HS*/  *          if wo_status = "" or wo_status = ?
/*F0HS*/  *          then wo_status = prev_status.
          *          if index("BFEARC",wo_status) = 0
          *          or ((index("RE",wo_type) > 0)
          *               and index("ARC",wo_status) = 0)
          *          or ((index("F",wo_type) > 0)
          *               and index("EARC",wo_status) = 0)
          *          then do:
          *             {mfmsg02.i 19 3 """'"" + wo_status + ""'"""}
          *             /*  INVALID STATUS */
          *             display prev_status @ wo_status.
          *             next-prompt wo_status.
          *             undo, retry.
          *          end.
          *
/*J014*/  *          if (wo_joint_type <> ""
/*J014*/  *              and index("PC",wo_status) = 0) then do:
/*J014*/  *              message  ERROR: STATUS MUST BE P OR C ON A JOINT
/*J014*/  *                       PRODUCT ORDER . BELL.
/*J014*/  *             display prev_status @ wo_status.
/*J014*/  *             next-prompt wo_status.
/*J014*/  *             undo, retry.
/*J014*/  *          end.
          *
          *          wo_status = caps(wo_status).
          *
/*G870*/  *          /* Added section*/
          *          if ((index("PFB",prev_status) > 0
          *             and index("FEAR",wo_status) > 0))
          *          or ((index("FEARC",prev_status) > 0
          *             and index("FB",wo_status) > 0))
          *          then do:
          *             /*Check wod_qty_iss status for all components*/
          *             {mfwomta.i wo_lot any_issued any_feedbk}
          *             if any_issued then do:
          *                /* Work order components have been issued */
          *                {mfmsg.i 529 3}
          *             end.
          *             if any_feedbk then do:
          *                /* Labor feedback has been reported */
          *                {mfmsg.i 554 3}
          *             end.
          *             if any_issued or any_feedbk then do:
          *                {mfmsg02.i 530 1 prev_status} /* Previous value: */
          *                next-prompt wo_status.
          *                undo, retry.
          *             end.
          *          end.
/*G870*/  *          /* End of added section*/
          *
          *          if prev_status = "R" and prev_qty <> wo_qty_ord
          *          then do on error undo, retry:
          *             {mfmsg.i 552 2}
/*G870*/  *             if not batchrun then
          *             pause.
          *          end.
          *
          *          if index("PFB",prev_status) = 0
          *          and index("PFB",wo_status) = 0
          *          and wo_routing <> prev_routing then do:
          *             /* Cannot change routing */
          *             {mfmsg.i 127 3}
          *             next-prompt wo_routing.
          *             display prev_routing @ wo_routing.
          *             undo, retry.
          *          end.
          *
          *          if index("PFB",prev_status) = 0
          *          and index("PFB",wo_status) = 0
          *          and wo_bom_code <> prev_bomcode then do:
          *             /* Cannot change product structure */
          *             {mfmsg.i 153 3}
          *             next-prompt wo_bom_code.
          *             display prev_bomcode @ wo_bom_code.
          *             undo, retry.
          *          end.
          *
/*F227*/  *          check-routing: do: /* and bom */
          *
/*F227*   *          if wo_routing <> "" then do: */
/*F0ST*/  *             find pt_mstr where pt_part = wo_part no-lock no-error.
/*F227*/  *             find ptp_det no-lock where ptp_part = wo_part
/*F227*/  *             and ptp_site = wo_site no-error.
/*F227*/  *             if available ptp_det then do:
/*F227*/  *                if wo_routing = ptp_routing
/*F227*/  *                and wo_bom_code = ptp_bom_code
/*F227*/  *                then leave check-routing.
/*F227*/  *             end.
/*F227*/  *             else do:
/*F227*/  *                if wo_routing = pt_routing
/*F227*/  *                and wo_bom_code = pt_bom_code
/*F227*/  *                then leave check-routing.
/*F227*/  *             end.
          *
          *              find first ptr_det no-lock where ptr_part = wo_part
          *              and ptr_site = wo_site and ptr_routing = wo_routing
          *              no-error.
          *              if not available ptr_det then do:
          *                 find first ptr_det no-lock where ptr_part = wo_part
          *                 and ptr_site = "" and ptr_routing = wo_routing
          *                 no-error.
          *              end.
          *              if not available ptr_det then do:
          *                 if not (available pt_mstr
          *                 and ((available ptp_det
          *                    and wo_routing = ptp_routing)
          *                 or (not available ptp_det
          *                    and wo_routing = pt_routing)))
          *                 then do:
          *
/*F227*/  *                    msg-type = 3.
/*F227*/  *                    if index("PFB",prev_status) = 0
/*F227*/  *                    and index("PFB",wo_status) = 0
/*F227*/  *                    then msg-type = 2.
          *                    /* Routing not valid for item */
/*F227*/  *                    {mfmsg.i 150 msg-type}
/*F227*/  *                    if msg-type = 3 then do:
/*F227*   *                       {mfmsg.i 150 3} */
          *                       next-prompt wo_routing.
          *                       undo, retry.
/*F227*/  *                    end.
          *                 end.
          *              end.
          *
          *              if (available ptr_det
          *              and wo_bom_code <> ""
/*F457*   *              and wo_bom_code <> ptr_user1 and ptr_user1 <> "") */
/*F457*/  *              and wo_bom_code <> ptr_bom_code and ptr_bom_code <> "")
/*F227*/  *              or (not available ptr_det and available ptp_det
/*F227*/  *              and wo_routing = ptp_routing
/*F227*/  *              and wo_bom_code <> ptp_bom_code)
/*F227*/  *              or (not available ptr_det and not available ptp_det
/*F227*/  *              and wo_routing = pt_routing
/*F227*/  *              and wo_bom_code <> pt_bom_code)
          *              then do:
/*F227*/  *                 msg-type = 3.
/*F227*/  *                 if index("PFB",prev_status) = 0
/*F227*/  *                 and index("PFB",wo_status) = 0
/*F227*/  *                 then msg-type = 2.
          *                 /* Routing and product structure are not valid */
/*F227*/  *                 {mfmsg.i 152 msg-type}
/*F227*/  *                 if msg-type = 3 then do:
/*F227*   *                    {mfmsg.i 152 3} */
          *                    next-prompt wo_routing.
          *                    undo, retry.
/*F227*/  *                 end.
          *              end.
          *          end.
          *
/*F227*   *          if wo_bom_code <> "" and wo_bom_code <> wo_part then do:
**        *             find first ps_mstr no-lock where ps_par = wo_part
**        *             and ps_comp = wo_bom_code and ps_ps_code = "A"
**        *             no-error.
**        *             if not available ps_mstr then do:
**        *                {mfmsg.i 151 3}
**        *                next-prompt wo_bom_code.
**        *                undo, retry.
**        *             end.
**        *          end. */
          *
          *          if wo_routing <> "" then
          *          if not can-find
          *          (first ro_det where ro_routing = wo_routing)
          *          then do:
          *             /* Routing does not exist */
          *             {mfmsg.i 126 2}
          *          end.
          *
          *          if wo_bom_code <> "" then
          *          if not can-find
          *          (first ps_mstr where ps_par = wo_bom_code)
          *          then do:
          *            /* No bill of material exists */
          *            {mfmsg.i 100 2}
          *          end.
          *
/*F085*/  *          if prev_site <> wo_site then do:
          *
/*F085*/  *             {gprun.i ""csavg01.p"" "(input global_part,
          *                                      input wo_site,
          *                                      output glx_set,
          *                                      output glx_mthd,
          *                                      output cur_set,
          *                                      output cur_mthd)"
          *             }
/*F085*/  *             if  (prev_mthd <> glx_mthd)
/*F085*/  *             and (wo_mtl_tot <> 0 or wo_lbr_tot <> 0 or
/*F085*/  *                  wo_bdn_tot <> 0 or wo_ovh_tot <> 0 or
/*F085*/  *                  wo_sub_tot <> 0 or wo_wip_tot <> 0)
/*F085*/  *             then do:
          *                /*  New site uses different costing method.  */
          *                /*  Change not allowed                       */
/*F085*/  *                {mfmsg.i 5426 3}
/*F085*/  *                next-prompt wo_site.
/*F085*/  *                display prev_site @ wo_site.
/*F085*/  *                undo, retry.
/*F085*/  *             end.
/*F085*/  *             if glx_mthd = "AVG" and wo_var then do:
          *                /* Average cost site.                          */
          *                /* Variance posting at labor entry not allowed */
/*F085*/  *                   {mfmsg.i 5427 3}
/*F085*/  *                next-prompt wo_var.
/*F085*/  *                undo, retry.
/*F085*/  *             end.
/*F085*/  *          end.
          *
          *          /*VALIDATE GL ACCOUNT CC */
/*F003*   *          {gpglac.i &acct = "wo_acct" &cc = "wo_cc" &frame = "b"} */
          *          /*SET & VALIDATE GL ACCOUNTS/COST CENTERS */
          *          hide frame b no-pause.
          *          {gprun.i ""womtacct.p""}
          *
/*G870*/  *          if keyfunction (lastkey) = "end-error" then undo, retry.
          *
          *          view frame a.
          *          view frame b.
          *
          *          def buffer simstr for si_mstr.
          *          if wo_wip_tot <> 0 and wo_site <> prev_site then do:
          *             find simstr where simstr.si_site = prev_site no-lock.
          *             find si_mstr where si_mstr.si_site = wo_site no-lock.
          *             if simstr.si_entity <> si_mstr.si_entity then do:
          *                /* WIP value exists for previous site entity */
          *                {mfmsg.i 551 3}
          *                next-prompt wo_site.
          *                undo, retry.
          *             end.
          *          end.
          *
          *          /* TRANSACTION COMMENTS */
/*G870*   *          if not available woc_ctrl then
**        *          find first woc_ctrl no-lock. */
          *          if wocmmts = yes then do:
          *             global_ref = wo_part.
          *             cmtindx = wo_cmtindx.
          *             hide frame a no-pause.
          *             hide frame b no-pause.
          *             {gprun.i ""gpcmmt01.p"" "(input ""wo_mstr"")"}
          *             view frame a.
          *             view frame b.
          *             wo_cmtindx = cmtindx.
          *          end.
          *
          *          if new_wo then do:
          *             assign prev_due = wo_due_date
          *                    prev_qty = wo_qty_ord
          *                   prev_site = wo_site
          *                prev_routing = wo_routing
          *                prev_bomcode = wo_bom_code
          *                prev_release = wo_rel_date.
          *             new_wo = no.
          *          end.
          *          undo_all = no.
/*G870*/  *       end.
          *    end. /* do with frame b */
 *J027*************************************************************************/
/*G2MF*/       /* UPDATE MRP */
/*G2MF*/       {gprun.i ""wowomta5.p"" "(input wo_recno)"}
/*G870*/    end. /* transaction */

/*J027*/ /* Begin added block */
            updt_subsys = yes.
            /* Joint Work Order */
            if wo_joint_type <> "" and wo_status <> "B" and not del-yn then do:

               hide frame a no-pause.
               hide frame b no-pause.

               /* New joint WO or (re-explode) Status change */
               if (new_wo and not add_2_joint) or
               (wo_status = "F" and prev_status <> "F") or
               (wo_bom_code <> prev_bomcode) or
               ((index("PBF",prev_status) > 0 and index("FEAR",wo_status) > 0)
                and prev_status <> wo_status) then do:
                  /* Create/re-establish its effective joint WOs.*/
                  {gprun.i ""wowomtf.p""}
                  find wo_mstr where recid(wo_mstr) = wo_recno.
                  if new_wo and wo_joint_type = "5" then do for wo_mstr1:
                     find first wo_mstr1 no-lock where
                     wo_mstr1.wo_nbr = wo_mstr.wo_nbr and
                     wo_mstr1.wo_type = "" and
                     wo_mstr1.wo_joint_type = "1" no-error.
                     if not available wo_mstr1 then do:
                        undo_all = yes.
                        /* Joint Product not produced by BOM/Formula */
                        {mfmsg.i 6546 3}
                     end.
                  end.
                  if undo_all then do:
                     if new_wo then do:
                        /* Failed validation, Del this WO and its joint WOs */
                        del-joint = yes.
                        {gprun.i ""wowomte.p""}
                     end.
                     else do transaction:
                        assign wo_site = prev_site
                           wo_ord_date = prev_ord
                           wo_due_date = prev_due
                           wo_rel_date = prev_release
                            wo_qty_ord = prev_qty
                            wo_routing = prev_routing
                           wo_bom_code = prev_bomcode
                             wo_status = prev_status.
                     end.
                     view frame a.
                     view frame b.
                     undo mainloop, retry mainloop.
                  end.
               end.
               /* Qty or dates or non re-explode status change */
               else do:
                  if prev_status <> wo_status
                  or (joint_qtys and (prev_qty <> wo_qty_ord))
                  or (joint_dates and
                      (prev_ord     <> wo_ord_date) or
                      (prev_release <> wo_rel_date) or
                      (prev_due     <> wo_due_date))
                  then do:
                     /* Update other joint WOs with status, qty & dates */
                     wo_recno = recid(wo_mstr).
                     {gprun.i ""wowomti.p""}
                     if undo_all then do:

/*M0JN*/                /* BEGIN ADD SECTION */

                        if critical_flg then do transaction:
                           /* UPDATE OTHER JOINT WOS WITH STATUS */
                           assign
                              wo_status    = "E"
                              critical_flg = no
                              wo_recno     = recid(wo_mstr).
                           {gprun.i ""wowomti.p""}
                           view frame a.
                           display wo_status with frame b.
                        end.

/*M0JN*/                /* END ADD SECTION */

                        view frame b.
                        undo, retry.
                     end.
                  end.
               end.
               /* Display/update list of joint orders */
               if wo_joint_type <> "" and wo_status <> "C" then do:
                  wo_recno = recid(wo_mstr).
                  {gprun.i ""wowomth.p""}
               end.
               view frame a.
               view frame b.
               if wo_recno = ? then do:
                  updt_subsys = no.
                  clear frame a no-pause.
                  clear frame b no-pause.
               end.
/*M0JN**       else do:                                                */
/*M0JN**       find wo_mstr no-lock where recid(wo_mstr) = wo_recno.   */

/*M0JN*/       /* CHANGED NO-LOCK TO EXCLUSIVE-LOCK TO ALLOW UPDATE OF */
/*M0JN*/       /* JOINT WOS WHEN CRITICAL COMPONENT IS NOT AVAILABLE   */
/*M0JN*/       else do transaction:
/*M0JN*/          find wo_mstr exclusive-lock where recid(wo_mstr) = wo_recno.

                  display wo_nbr wo_lot wo_part wo_type wo_site joint_label
                  with frame a.
                  display wo_qty_ord wo_qty_comp wo_qty_rjct
                  wo_ord_date wo_rel_date wo_due_date
                  wo_status wo_so_job wo_vend wo_yield_pct
                  wo_site wo_routing wo_bom_code wo_rmks wocmmts wo_var
                  with frame b.
               end.
            end.
/*J027*/ /* End added block */

/*J027*     if not del-yn then do: */
/*J027*/    if not del-yn and updt_subsys then do:
/*J027*/       joint_type = wo_joint_type.

               /* Add wo bill, wo routing, on order, etc */
/*ss - eas058               {gprun.i ""wowomta.p""}*/
/* SS - 100415.1 - B 
             {gprun.i ""xxwowomta.p""}    /*ss - eas058*/  
   SS - 100415.1 - E */
/* SS - 100415.1 - B */
if v_choice = yes then do:
    {gprun.i ""xxwowomtax.p""}   /*just like in xxwowor2.p*/
end.
else do:
    {gprun.i ""xxwowomta.p""}    /*just like in xxwowor1.p*/
end.
/* SS - 100415.1 - E */




/*J38K*/       /* AT THIS POINT, BASE PROCESS WORK ORDERS WO_REL_DATE &      */
/*J38K*/       /* WO_DUE_DATE WILL HAVE NON-BLANK DATE(AFTER RECALCULATION), */
/*J38K*/       /* WHEN ? IS ENTERED IN WO_REL_DATE OR/AND WO_DUE_DATE OF THE */
/*J38K*/       /* ACTIVE WORK ORDER.                                         */

/*J38K*/       if joint_dates then
/*J38K*/          run sync-release-due-dates.

/*F0S4*/       display wo_rel_date wo_due_date with frame b.

               if undo_all then do:
                  if wo_status = "A" then do:
                     /*Critical part not available, work order not allocated.*/
/*G1XY*              {mfmsg.i 4985 2}         */
/*G1XY*/             {mfmsg02.i 4985 2 wo_nbr}
                  end.
                  else do:
/*J027*/             if wo_joint_type = "" then do:
                        /*Critical part not available, work order not released*/
/*G1XY*                 {mfmsg.i 4984 2}      */
/*G1XY*/             {mfmsg02.i 4984 2 wo_nbr}
/*J027*/             end.
/*J027*/             else do transaction:
/*J027*/                /*Critical item not avail, status changed from R to E */
/*J027*/                {mfmsg.i 6547 2}
/*J027*/                wo_status = "E".
/*J027*/                display wo_status with frame b.
/*J027*/                /* Update other joint order with status */
/*J027*/                wo_recno = recid(wo_mstr).
/*J027*/                {gprun.i ""wowomti.p""}
/*J027*/             end.
                  end.
/*G1XY*/          {mfmsg02.i 989 1 critical-part}
               end.

/*G870*/       /* Added section */
               if any_issued then do:
                  /* Work order components have been issued */
                  {mfmsg.i 529 4}
               end.
               if any_feedbk then do:
                  /* Labor feedback has been reported */
                  {mfmsg.i 554 4}
               end.

               if undo_all or any_issued or any_feedbk
               then do transaction:

                  wo_status = prev_status.

/*M0JN*/          {gprun.i ""wowomta5.p"" "(input wo_recno)"}

                  if any_issued or any_feedbk then
                     assign wo_site = prev_site
/*J027*/                wo_ord_date = prev_ord
                        wo_rel_date = prev_release
                        wo_due_date = prev_due
                         wo_qty_ord = prev_qty
                         wo_routing = prev_routing
                        wo_bom_code = prev_bomcode.
/*J027*/          clear frame b no-pause.
/*J027*/          view frame b.
                  next mainloop.
               end.
/*G870*/       /* End of changed section */

/*G870*****    if any_issued then do:
          *       {mfmsg.i 529 3}
          *       {mfmsg02.i 530 1 prev_status}
          *       next-prompt wo_status.
          *       undo, retry.
          *    end.
/*G125*/  *    if any_feedbk then do:
/*G125*/  *       {mfmsg.i 554 3} /* LABOR FEEDBACK HAS BEEN REPORTED */
/*G125*/  *       {mfmsg02.i 530 1 prev_status} /* PREVIOUS VALUE: */
/*G125*/  *       next-prompt wo_status.
/*G125*/  *       undo, retry.
/*G125*/  *    end.
**G870*/
            end.

            /* DELETE WORK ORDER AND DETAIL */
            if del-yn and wo_wip_tot = 0 then do:

               /* DELETE FUNCTION MOVED TO wowomte.p */
               {gprun.i ""wowomte.p""}
               clear frame b no-pause.
               clear frame a no-pause.
               del-yn = no.
            end.
         end.

         status input.

/*J38K*/ /* BEGIN OF ADDED CODE */

PROCEDURE sync-release-due-dates:
/*------------------------------------------------------------------------------
  Purpose:    To synchronise release and due dates betweeen Base process and
              Co/By Product Work Orders.
  Parameters: None
  Notes:      /*J38K*/
------------------------------------------------------------------------------*/

         define buffer b1-womstr for wo_mstr.
         define buffer b2-womstr for wo_mstr.

         find first b2-womstr where b2-womstr.wo_nbr        = wo_mstr.wo_nbr
                                and b2-womstr.wo_joint_type = "5"
         no-lock no-error.
         if available b2-womstr
         and (b2-womstr.wo_rel_date <> ?
          or  b2-womstr.wo_due_date <> ?) then
         do:
            for each b1-womstr exclusive-lock
            where b1-womstr.wo_nbr       = b2-womstr.wo_nbr
            and b1-womstr.wo_lot        <> b2-womstr.wo_lot
            and b1-womstr.wo_joint_type <> "":

               if b1-womstr.wo_rel_date <> b2-womstr.wo_rel_date then
                  b1-womstr.wo_rel_date = b2-womstr.wo_rel_date.

               if b1-womstr.wo_due_date <> b2-womstr.wo_due_date then
                  b1-womstr.wo_due_date = b2-womstr.wo_due_date.

            end. /* FOR EACH B1-WOMSTR */
         end. /* IF AVAILABLE B2-WOMSTR */

END PROCEDURE.

/*J38K*/ /* END OF ADDED CODE */
