/* GUI CONVERTED from rspomtb.p (converter v1.69) Sun Sep  7 22:46:35 1997 */
/* rspomtb.p - Release Management Supplier Schedules                        */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.     */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                       */
/* REVISION: 7.3    LAST MODIFIED: 09/30/92           BY: WUG *G462*        */
/* REVISION: 7.3    LAST MODIFIED: 05/24/93           BY: WUG *GB29*        */
/* REVISION: 7.3    LAST MODIFIED: 06/01/93           BY: WUG *GB46*        */
/* REVISION: 7.3    LAST MODIFIED: 06/07/93           BY: WUG *GB75*        */
/* REVISION: 7.3    LAST MODIFIED: 06/16/93           BY: WUG *GC34*        */
/* REVISION: 7.3    LAST MODIFIED: 07/07/93           BY: WUG *GD20*        */
/* REVISION: 7.3    LAST MODIFIED: 07/13/93           BY: WUG *GD42*        */
/* REVISION: 7.3    LAST MODIFIED: 07/13/93           BY: WUG *GD43*        */
/* REVISION: 7.4    LAST MODIFIED: 08/06/94           BY: bcm *H057*        */
/* REVISION: 7.3    LAST MODIFIED: 04/21/94           BY: WUG *GJ48*        */
/* REVISION: 7.3    LAST MODIFIED: 05/16/94           BY: WUG *GJ59*        */
/* REVISION: 7.3    LAST MODIFIED: 09/26/94           BY: ljm *GM77*        */
/* REVISION: 7.3    LAST MODIFIED: 10/24/94           BY: ljm *GN54*        */
/* REVISION: 7.3    LAST MODIFIED: 10/31/94           BY: WUG *GN76*        */
/* REVISION: 7.3    LAST MODIFIED: 11/11/94           BY: dpm *GO13*        */
/* REVISION: 8.5    LAST MODIFIED: 11/21/94           BY: mwd *J034*        */
/* REVISION: 7.3    LAST MODIFIED: 01/17/95           by: srk *G0C1*        */
/* REVISION: 7.3    LAST MODIFIED: 01/31/95           by: srk *H09T*        */
/* REVISION: 7.4    LAST MODIFIED: 02/06/95           BY: rxm *G0DH*        */
/* REVISION: 7.4    LAST MODIFIED: 02/16/95           by: rxm *G0D5*        */
/* REVISION: 7.5    LAST MODIFIED: 02/21/95           BY: dpm *J044*        */
/* REVISION: 7.4    LAST MODIFIED: 02/23/95           by: jzw *H0BM*        */
/* REVISION: 7.4    LAST MODIFIED: 03/02/95           by: rxm *G0G5*        */
/* REVISION: 7.4    LAST MODIFIED: 03/29/95           by: pmf *G0JR*        */
/* REVISION: 7.4    LAST MODIFIED: 05/15/95           by: vrn *G0MW*        */
/* REVISION: 7.4    LAST MODIFIED: 05/19/95           by: dxk *G0N7*        */
/* REVISION: 7.4    LAST MODIFIED: 05/23/95           by: vrn *G0NC*        */
/* REVISION: 7.4    LAST MODIFIED: 06/07/95           by: dxk *G0PF*        */
/* REVISION: 7.4    LAST MODIFIED: 07/06/95           by: vrn *G0RV*        */
/* REVISION: 7.4    LAST MODIFIED: 08/01/95           by: dxk *G0T5*        */
/* REVISION: 7.4    LAST MODIFIED: 01/08/96           by: kjm *G1JC*        */
/* REVISION: 7.4    LAST MODIFIED: 02/02/96           by: kjm *G1LT*        */
/* REVISION: 8.5    LAST MODIFIED: 02/26/96     BY: *J0CV* Brandy J Ewing   */
/* REVISION: 8.5    LAST MODIFIED: 03/29/96           BY: BHolmes *J0FY*    */
/* REVISION: 8.5    LAST MODIFIED: 04/08/96           by: dxk *G1R3*        */
/* REVISION: 8.5    LAST MODIFIED: 04/23/96           BY: rpw *J0K4*        */
/* REVISION: 8.5    LAST MODIFIED: 04/23/96           BY: rpw *J0K4*        */
/* REVISION: 8.5    LAST MODIFIED: 06/10/96           BY: rxm *G1XN*        */
/* REVISION: 8.5    LAST MODIFIED: 07/08/96           BY: ajw *J0SZ*        */
/* REVISION: 8.5    LAST MODIFIED: 08/20/96           BY: *G2CP* Suresh Nayak */
/* REVISION: 8.5    LAST MODIFIED: 12/05/96           BY: *H0PP* Ajit Deodhar */
/* REVISION: 8.5    LAST MODIFIED: 01/09/97           BY: *J1B1* R. McCarthy  */
/* REVISION: 8.5    LAST MODIFIED: 02/14/97           BY: *G2L2* Jim Williams */
/* REVISION: 8.5    LAST MODIFIED: 03/03/97           BY: *H0T4* Aruna Patil  */
/* REVISION: 8.5    LAST MODIFIED: 05/08/97           BY: *J1QW* Suresh Nayak */
/* REVISION: 8.5    LAST MODIFIED: 06/02/97           BY: *H0ZB* Ajit Deodhar */
/* REVISION: 8.5    LAST MODIFIED: 06/16/97           BY: *J1T5* Suresh Nayak */
/* REVISION: 8.5    LAST MODIFIED: 07/23/97           BY: *H1CC* Aruna Patil  */
/* REVISION: 8.5    LAST MODIFIED: 09/04/97           BY: *G2PD* Nirav Parikh */
/* REVISION: 8.5    LAST MODIFIED: 11/14/03           BY: *LB01* Long Bo      */


         {mfdeclre.i}


         /* SCHEDULED ORDER MAINT SUBPROGRAM */

         define input param po_recid as recid.

         define shared frame po.
         define shared frame po1.
         define shared frame pod.
         define shared frame pod1.
         define shared frame pod2.

         define shared variable cmtindx like cmt_indx.
         define variable line as integer.
         define variable yn like mfc_logical.
/*J0CV*/ define variable new-pod like mfc_logical.
/*J0CV*/ define variable erslst like ers_pr_lst_tp no-undo.
/*J0CV*/ define variable ers-err as integer no-undo.
/*J0CV*/ define variable ersopt like ers_opt no-undo.
         define variable del-yn like mfc_logical.
         define variable scx_recid as recid.
         define variable valid_acct like mfc_logical.
         define new shared variable global_curr as character.
/*GC34*/ define new shared variable global_order as character.
/*H057*/ define shared variable tax_in like ad_tax_in.
/*H057*/ define variable zone_to like txz_tax_zone no-undo.
/*H057*/ define variable zone_from like txz_tax_zone no-undo.
/*H057*/ define variable old_pod_site like pod_site.
/*GJ59*/ define variable schedule_found like mfc_logical.
/*G0PF*/ define variable somrp_found like mfc_logical no-undo.
/*G0G5 /*GN76*/ define variable any_msgs like mfc_logical. */
/*G0G5*/ define new shared variable any_msgs like mfc_logical.
/*G1R3*/ define            variable err-flag as integer no-undo.
/*G1R3*/ define            variable old_db   like si_db no-undo.
/*GJ59*/ define new shared variable new_site like si_site.
/*GJ59*/ define new shared variable err_stat as integer.
/*GJ59*/ define new shared variable so_db like dc_name.
/*GO13*/ define variable found_price like mfc_logical.
/*G0G5*/ define variable save_supp_part like vp_vend_part.
/*G0N7*/ define variable i as integer no-undo.
/*G0NC*/ define variable counter as integer no-undo.
/*G0RV*/ define variable ptstatus like pt_status no-undo.
/*G1JC*/ define variable newline as integer no-undo.
/*G1LT*/ define variable shipper_found as integer no-undo.
/*G1LT*/ define variable save_abs like abs_par_id.

/*J044*/ define    shared variable impexp   like mfc_logical no-undo.
/*J044*/ define           variable imp-okay like mfc_logical no-undo.
/*LB01*/ define        variable l_gl_set     like icc_gl_set.

         {zzrsordfrm.i}
/*H057*/ {gptxcdec.i}  /* DECLARATIONS FOR gptxcval.i */

/*H057*/ /* TAX ENVIRONMENT FORM */
         FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
pod_tax_usage     colon 25
            pod_tax_env       colon 25
            pod_tax_in        colon 25
          SKIP(.4)  /*GUI*/
with frame set_tax row 8 overlay centered side-labels attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-set_tax-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame set_tax = F-set_tax-title.
 RECT-FRAME-LABEL:HIDDEN in frame set_tax = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame set_tax =
  FRAME set_tax:HEIGHT-PIXELS - RECT-FRAME:Y in frame set_tax - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME set_tax = FRAME set_tax:WIDTH-CHARS - .5.  /*GUI*/


         find first poc_ctrl no-lock.
         find first gl_ctrl no-lock.
         find first icc_ctrl no-lock.

         pocmmts = poc_hcmmts.

         /*GJ48 CHANGE EXCLUSIVE TO NO-LOCK IN FOLLOWING*/
         find po_mstr where recid(po_mstr) = po_recid no-lock.

         find vd_mstr where vd_addr = po_vend no-lock.

         find ad_mstr where ad_addr = po_vend no-lock.

         assign
/*GC34*/    global_order = po_nbr
            global_addr = po_vend.

/*G0C1*  clear frame pod all no-pause. */
/*G0C1*  clear frame pod1 all no-pause. */
/*G0C1*  clear frame pod2 all no-pause. */
/*G0C1*/ clear frame pod no-pause.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame pod = F-pod-title.
/*G0C1*/ clear frame pod1 no-pause.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame pod1 = F-pod1-title.
/*G0C1*/ clear frame pod2 no-pause.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame pod2 = F-pod2-title.


         detailloop:
         repeat:
/*GUI*/ if global-beam-me-up then undo, leave.

            hide frame pod1 no-pause.
            hide frame pod2 no-pause.

            /* FIND OR CREATE DETAIL RECORD */

            do with frame pod:
/*G0G5      global_part = input scx_part. */

               prompt-for scx_part scx_shipto scx_line editing:
                  if frame-field = "scx_part" then do:

/*H0ZB**BEGIN DELETE**
 *           {mfnp05.i scx_ref scx_po "scx_type = 2
 *           and scx_po = po_nbr"
 *           scx_part "input scx_part"}
 *H0ZB**END DELETE**/

/*H0ZB*/           /* REPLACED "INPUT SCX_PART" TO "INPUT FRAME POD SCX_PART" */
/*H0ZB*/             {mfnp05.i scx_ref scx_po "scx_type = 2
             and scx_po = po_nbr"
             scx_part "input frame pod scx_part"}

                     if recno <> ? then do:
                        find pt_mstr where pt_part = scx_part no-lock.
                        find pod_det where pod_nbr = po_nbr
                        and pod_line = scx_line no-lock.
                        find si_mstr where si_site = scx_shipto no-lock.

                        global_site = pod_site.

                        display
                           scx_part
                           scx_shipto
                           si_desc
/*GD42                     pt_um */
                           pod_vpart
                           scx_line.
                     end.
                  end.
                  else
                  if frame-field = "scx_shipto" then do:
/*H0ZB**BEGIN DELETE**
 *           {mfnp05.i scx_ref scx_po "scx_type = 2
 *           and scx_po = po_nbr and scx_part = input scx_part"
 *           scx_shipto "input scx_shipto"}
 *H0ZB**END DELETE**/

/*H0ZB*/       /* REPLACED "INPUT SCX_PART" TO "INPUT FRAME POD SCX_PART"
                  AND "INPUT SCX_SHIPTO" TO "INPUT FRAME POD SCX_SHIPTO" */
/*H0ZB*/         {mfnp05.i scx_ref scx_po "scx_type = 2
             and scx_po = po_nbr and
             scx_part = input frame pod scx_part"
             scx_shipto "input frame pod scx_shipto"}

                     if recno <> ? then do:
                        find pt_mstr where pt_part = scx_part no-lock.
                        find pod_det where pod_nbr = po_nbr
                        and pod_line = scx_line no-lock.
                        find si_mstr where si_site = scx_shipto no-lock.

                        global_site = pod_site.

                        display
                           scx_part
                           scx_shipto
                           si_desc
/*GD42                     pt_um */
                           pod_vpart
                           scx_line.
                     end.
                  end.
                  else
/*G1JC* CHANGED "INPUT SCX_LNE" TO "INOPUT FRAME POD SCX_LINE" */
                  if frame-field = "scx_line" then do:
                     {mfnp05.i scx_ref scx_order "scx_type = 2
                     and scx_order = po_nbr"
                     scx_line "input frame pod scx_line"}

                     if recno <> ? then do:
                        find pt_mstr where pt_part = scx_part no-lock.
                        find pod_det where pod_nbr = po_nbr
                        and pod_line = scx_line no-lock.
                        find si_mstr where si_site = scx_shipto no-lock.

                        global_site = pod_site.

                        display
                           scx_part
                           scx_shipto
                           si_desc
/*GD42                     pt_um   */
                           pod_vpart
                           scx_line.
                     end.
                  end.
                  else do:
                     status input.
                     readkey.
                     apply lastkey.
                  end.
               end.

/*G1JC*        if scx_line entered and not scx_part entered then do: */

/*H0ZB**
 * /*G1JC*/    if frame pod scx_line entered and not scx_part entered then do:
 *H0ZB**/
/*H0ZB*/       /* REPLACED "SCX_PART" TO "FRAME POD SCX_PART" */
/*H0ZB*/       if frame pod scx_line entered and
/*H0ZB*/                not frame pod scx_part entered then do:
                  find pod_det where pod_nbr = po_nbr and
/*G1JC*           pod_line = input scx_line */
/*G1JC*/          pod_line = input frame pod scx_line
                  no-lock no-error.

                  if available pod_det then do:
                     global_site = pod_site.

                     display
                        pod_part @ scx_part
                        pod_site @ scx_shipto.
                  end.
               end.

               find pt_mstr where pt_part = input
/*G0JR* /*GM77*/    /*V8!frame pod */ scx_part no-lock no-error.  */
/*G0JR*/       frame pod scx_part no-lock no-error.
               if not available pt_mstr then do:
/*G0JR* /*G0G5*/ if can-find(first vp_mstr where vp_vend_part = input scx_part  */
/*G0JR*/       if can-find(first vp_mstr
                where vp_vend_part = input frame pod scx_part
/*G0G5*/        and vp_vend = (if po_vend <> "" then po_vend else ""))
/*G0G5*/        then do:
/*G0G5            SINCE WE MAY HAVE MANY SUPPLIERS FOR ANY ONE ITEM, WE FIND
                  THE SUPPLIER FOR THIS ITEM WITH THE MOST RECENT QUOTE      */
/*G0G5*/          for each vp_mstr no-lock where vp_vend_part = input
/*G0JR*  /*G0G5*/   scx_part and vp_vend = po_vend  */
/*G0JR*/            frame pod scx_part and vp_vend = po_vend
/*G0G5*/            break by vp_q_date descending:
/*GUI*/ if global-beam-me-up then undo, leave.

/*G0G5*/             if first(vp_q_date) then do:
/*G0G5*/                find pt_mstr where pt_part = vp_part
/*G0G5*/                  no-lock no-error.
/*G0G5*/                if available pt_mstr then do:
/*G0JR* /*G0G5*/           save_supp_part = input scx_part.  */
/*G0JR*/                   save_supp_part = input frame pod scx_part.
/*G0G5*/                   display pt_part @ scx_part with frame pod.
/*G0G5*/                   {mfmsg03.i 371 1 vp_vend_part vp_part """"}
/*G0G5*/                   /* SUPPLIER ITEM x REPLACED BY ITEM y */
/*G0G5*/                end.
/*G0G5*/                else do:
/*G0G5*/                   {mfmsg.i 16 3} /* ITEM NUMBER DOES NOT EXIST */
/*G0G5*/                   undo, retry.
/*G0G5*/                end.
/*G0G5*/             end.
/*G0G5*/          end.
/*GUI*/ if global-beam-me-up then undo, leave.

/*G0G5*/       end.
/*G0G5*/       else do:
                 {mfmsg.i 16 3}   /* ITEM NUMBER DOES NOT EXIST */
                 undo, retry.
/*G0G5*/       end.
            end.

/*LB01*/    {zzchkbuyer.i "input frame pod "}			

/*G0RV*/    /*  CHECK TO SEE WHETHER THE PART IS RESTRICTED FROM THE
                BEING USED IN A PO - CODE COPIED FROM popomte.p. */
/*G0RV*/    ptstatus = pt_status.
/*G0RV*/    substring(ptstatus,9,1) = "#".
/*G0RV*/    if can-find(isd_det where isd_status = ptstatus
/*G0RV*/    and isd_tr_type = "ADD-PO") then do:
/*G0RV*/    /* RESTRICTED PROCEDURE FOR ITEM STATUS CODE XXX */
/*G0RV*/        {mfmsg02.i 358 3 pt_status}
/*G0RV*/        undo, retry.
/*G0RV*/    end.

/*G0JR* /*G0G5*/ global_part = input scx_part.  */
/*G0JR*/    global_part = input frame pod scx_part.

            find si_mstr where si_site = input
/*G0JR* /*GM77*/ /*V8!frame pod */ scx_shipto no-lock no-error. */
/*G0JR*/    frame pod scx_shipto no-lock no-error.
            if not available si_mstr then do:
               {mfmsg.i 708 3}   /* SITE DOES NOT EXIST */
               undo, retry.
            end.

/*GJ59*******************
.              if si_db <> global_db then do:
.                 {mfmsg.i 8182 3}
.                 /* ORDER MUST BE CREATED IN THE DATABASE FOR THE SITE */
.                 undo, retry.
.              end.
**GJ59******************/

/*J034*/  {gprun.i ""gpsiver.p""
          "(input si_site, input recid(si_mstr), output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/  if return_int = 0 then do:
/*J034*/      {mfmsg.i 725 3}  /* USER DOES NOT HAVE ACCESS TO SITE */
/*J034*/      undo, retry.
/*J034*/  end.

/*GD43*******************
./*GB75*/      find ad_mstr where ad_addr = si_site no-lock no-error.
./*GB75*/      if not available ad_mstr then do:
./*GB75*/         {mfmsg.i 8183
.                 /* NO COMPANY ADDRESS RECORD FOR SHIP-TO SITE EXISTS */
./*GB75*/         undo, retry.
./*GB75*/      end.
**GD43******************/

/*G0MW*/    find ptp_det where ptp_part = pt_part and ptp_site = si_site
/*G0MW*/      no-lock no-error.

/*G2CP**     if pt_pm_code <> "" and pt_pm_code <> "p" then do:               */
/*J1QW**  FOLLOWING SECTION COMMENTED**
 * /*G2CP*/     if (available ptp_det and ptp_pm_code <> "p")
 * /*G2CP*/     or (not available ptp_det and pt_pm_code <> "p")
 *J1QW**/

/*J1QW*/     if (available ptp_det and (ptp_pm_code = "C" or ptp_pm_code = "F"))
         then do:
/*G2CP**        {mfmsg.i 8184 2}   /* ITEM PUR/MFG CODE MUST BE BLANK OR P */ */
/*J1QW** /*G2CP*/ {mfmsg.i 8184 2} /* ITEM PUR/MFG CODE IS NOT  P */          */
/*J1QW*/        /* ITEM PUR/MFG CODE IS # */
/*J1T5*/        {mfmsg03.i 1850 2 ptp_pm_code """" """"}
/*J1T5** /*J1QW*/        {mfmsg03.i 8159 2 ptp_pm_code """" """"}   */
             end.
/*J1QW*/     else if (not available ptp_det
/*J1QW*/     and (pt_pm_code = "F" or pt_pm_code = "C"))
/*J1QW*/     then do:
/*J1QW*/        /* ITEM PUR/MFG CODE IS # */
/*J1T5*/        {mfmsg03.i 1850 2 pt_pm_code """" """"}
/*J1T5** /*J1QW*/        {mfmsg03.i 8159 2 pt_pm_code """" """"}    */
/*J1QW*/     end.

            find scx_ref where scx_type = 2 and scx_shipfrom = po_vend
/*G0JR*       and scx_shipto = input scx_shipto and scx_part = input scx_part */
/*G0JR*/      and scx_shipto = input frame pod scx_shipto
/*G0JR*/      and scx_part = input frame pod scx_part
              and scx_po = po_nbr no-lock no-error.

            if not available scx_ref then do:
/*G0NC*/ /*!- LOGIC TO WRAP AROUND IF THE LINE# LIMIT IS REACHED
          AND TO SEEK ANY UNUSED LINE NUMBER. CODE COMPLEMENTS THE FUNCTIONALITY
          OF ARCHIVE/DELETE OF SCHEDULE LINE*/
/*G0NC*/          find last pod_det where pod_nbr = po_nbr no-lock no-error.
/*G0NC*/          line = 1.
/*G0NC*/          /* SCREENS & REPORTS DON'T SUPPORT 4 DIGIT LINE NOS. */
/*G0NC*/           if available pod_det then do:
/*G0NC*/             if pod_line < 999 then
/*G0NC*/                line = pod_line + 1.
/*G0NC*/             else
/*G0NC*/             if pod_line = 999 then do:
/*G0NC*/                {mfmsg.i 6025 1}
/*G0NC*/                /*  MAX LINE# USED, SEARCH FOR NEXT AVAILABLE LINE# */
/*G0NC*/                pause 1 no-message.
/*G0NC*/                do counter = 1 to 999:
/*G0NC*/                   display counter @ scx_line.
/*G0NC*/                   if not can-find (scx_ref where scx_type = 2 and
/*G0NC*/                                    scx_order = po_nbr         and
/*G0NC*/                                    scx_line  = counter) then do:
/*G0NC*/                      line = counter.
/*G0NC*/                      leave.
/*G0NC*/                   end.
/*G0NC*/                end.
/*G0NC*/                if counter = 1000 then do:
/*G0NC*/                   {mfmsg.i 6026 4}  /* ALL AVAILABLE LINE# ARE USED */
/*G0NC*/                   undo, retry.
/*G0NC*/                end.
/*G0NC*/             end.  /* if pod_line = 999  */
/*G0NC*/          end.  /* if available pod_det */
/*G0NC*/

               {mfmsg.i 1 1}   /* ADDING NEW RECORD */
               create scx_ref.
               assign
                 scx_type     = 2
                 scx_shipfrom = po_vend

/*G0JR* /*GN54*/ scx_shipto          /*V8! = input frame pod scx_shipto */ */
/*G0JR* /*H09T*/ scx_part            /*V8! = input frame pod scx_part   */ */

/*G0JR*/         scx_shipto   = input frame pod scx_shipto
/*G0JR*/         scx_part     = input frame pod scx_part
                 scx_po       = po_nbr
                 scx_order    = po_nbr.

/*G0NC         line = 1. */
/*G0NC         find last pod_det where pod_nbr = po_nbr no-lock no-error. */
/*G0NC         if available pod_det then line = pod_line + 1. */


/*G1JC*/       /* IF USER ENTERED LINE NUMBER IT'S OK IF IT'S UNUSED */
/*G1JC*/       if frame pod scx_line entered and
/*G1JC*/       line <> input frame pod scx_line then do:
/*G1JC*/          newline = input frame pod scx_line.
/*G1JC*/          if not can-find (scx_ref where scx_type = 2 and
/*G1JC*/          scx_order = po_nbr and scx_line = newline) and
/*G1JC*/          not can-find (pod_det where pod_nbr = po_nbr
/*G1JC*/          and pod_line = newline) then
/*G1JC*/             line = newline.
/*G1JC*/       end.

               display line @ scx_line.
               assign scx_line = line.

               create pod_det.
/*J0CV*/       new-pod = yes.
               assign
                 pod_nbr         = po_nbr
                 pod_line        = scx_line
                 pod_part        = scx_part
                 pod_site        = scx_shipto
                 pod_sched       = yes
/*H057*/         pod_taxable     = if ({txnew.i}) then (po_taxable and pt_taxable)
                                   else po_taxable
/*H057*/         pod_tax_usage   = po_tax_usage
/*H057*/         pod_tax_in      = tax_in
/*H057*/         pod_taxc        = pt_taxc
                 pod_pst         = po_pst
                 pod_po_db       = global_db
                 pod_um          = pt_um
                 pod_um_conv     = 1
                 pod_ord_mult    = 1
                 pod_acct        = vd_pur_acct
                 pod_cc          = vd_pur_cc
                 pod_rev         = pt_rev
/*G0MW*          pod_loc         = pt_loc */
/*G0MW*          pod_insp_rqd    = pt_insp_rqd */
/*G0MW*/         pod_insp_rqd    = if available ptp_det then ptp_ins_rqd
/*G0MW*/                                               else pt_insp_rqd
/*G0MW*/         pod_loc         = if pod_insp_rqd then poc_insp_loc else pt_loc
                 pod_cum_date[1] = today
/*G0G5*/         pod_vpart       = save_supp_part
                 pod_pr_list     = vd_pr_list
                 pod__chr01 		= "".      /*GD20*/

/*H1CC*/         /* KEEP TAX ENV. BLANK TO INVOKE SUGGESTION OF TAX ENV. */
/*H1CC** /*H0T4*/   if {txnew.i} then            */
/*H1CC** /*H0T4*/      pod_tax_env = po_tax_env. */

/*G0N7*/       i = 0.
/*H0PP /*G0N7*/ for each si_mstr no-lock: */
/*H0PP*/       for each si_mstr no-lock where si_site >= "":
/*G0N7*/          i = i + 1.
/*G0N7*/          if i >= 2 then leave.
/*G0N7*/       end.
/*G0N7*/       if pod_site = po_site then pod_po_site = po_site.
/*G0N7*/       else if po_site <> "" then pod_po_site = po_site.
/*G0N7*/       else if not can-find(si_mstr where si_site = "")
/*G0N7*/         then pod_po_site = pod_site.
/*G0N7*/       else if i >= 2 then pod_po_site = pod_site.

               if icc_cur_cost = "NONE" then assign pod_cst_up = no.
               else assign pod_cst_up = yes.

               {gpsct05.i &part=pod_part &site=pod_site &cost=sct_mtl_tl}
               pod_pur_cost = glxcst.
/*G0DH*/       pod_pur_cost = pod_pur_cost * po_ex_rate.

/*G0MW*        if pt_insp_rqd then pod_loc = poc_insp_loc. */
               find pl_mstr where pl_prod_line = pt_prod_line no-lock no-error.

               if available pl_mstr then do:
                  assign
                  pod_acct = pl_pur_acct
                  pod_cc = pl_pur_cc.
               end.

               yn = yes.

               {mfmsg01.i 8231 1 yn}
               /* COPY DATA FROM ANOTHER ORDER LINE FOR THIS ITEM? */

               if yn then do:
                  {gprun.i ""rspomta.p"" "(input recid(pod_det))"}
/*GUI*/ if global-beam-me-up then undo, leave.

               end.
            end.
            else do:
               find pod_det where pod_nbr = scx_order
               and pod_line = scx_line exclusive-lock.
/*J0CV*/       new-pod = no.
            end.

            /*GJ59 CHECK ITEM EXISTENCE IN REMOTE DB*/
            new_site = pod_site.
            global_part = pt_part.
            so_db = global_db.
            {gprun.i ""gpptsi01.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


            if err_stat > 1 then do:
               {mfmsg.i 715 3}   /* ITEM DOES NOT EXIST AT THIS SITE */
               undo, retry.
            end.


            display
              scx_part
/*GD42        pt_um                          */
              pod_vpart
              scx_line.
         end.


         /* DETAIL DATA ITEMS FRAME 1 */
         display
           pod_pr_list
           pod_pur_cost
           pod_acct
           pod_cc
           pod_taxable /*H057*/ pod_taxc when ({txnew.i})
           pod_type                                                     /*GN76*/
           pod_cst_up
           pod__chr01
           pod_loc
           pod_um                                                       /*GD42*/
           pod_um_conv                                                  /*GD42*/
           pod_wo_lot                                                   /*GN76*/
           pod_op                                                       /*GN76*/
           with frame pod1.

         do with frame pod1 on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

            ststatus = stline[2].
            status input ststatus.

            assign
              global_part = pod_part
              global_curr = po_curr.

            set
              pod_pr_list
              pod_pur_cost
              pod_acct
              pod_cc
              pod_taxable /*H057*/ pod_taxc when ({txnew.i})
              pod_type                                                  /*GN76*/
              pod_cst_up
              pod__chr01
              pod_loc
              pod_um                                                    /*GD42*/
              go-on("F5" "CTRL-D").

            del-yn = no.
            if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
            then do:
               del-yn = yes.
               {mfmsg01.i 11 1 del-yn}   /* PLEASE CONFIRM DELETE */
               if not del-yn then undo, retry.
            end.

            if del-yn then do:
               /*GB46 HANDLE CAN-FIND IDIOSYNCRASY WITH ADD'L CAN-FINDS*/
               /*GJ59 MOVE CHECK TO SUBPROGRAM SO THAT REMOTE DATABASE
               CAN BE CHECKED*/

/*G0PF         {gprun.i ""rsschck.p"" "(input pod_nbr, input pod_line,  */
/*G0PF            output schedule_found)"}  */

/*G0PF BEGINS*/
/*G1LT*        ADDED "OUTPUT SHIPPER FOUND" AND "OUTPUT SAVE_ABS" */
/*G1LT*/       shipper_found = 0.
               {gprun.i ""rsschck.p"" "(input pod_nbr, input pod_line,
               input scx_part, input scx_shipto,
               output schedule_found, output somrp_found,
               output shipper_found, output save_abs)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*G0PF ENDS*/

               if schedule_found then do:
                  {mfmsg.i 6022 3}   /* SCHEDULE EXISTS, DELETE NOT ALLOWED */
                  undo, retry.
               end.

/*G0PF*/       if somrp_found then do:
/*G0PF*/          {mfmsg.i 6027 4}  /* USED IN SCHEDULED ORDER MRP % TABLE */
/*G0PF*/          undo, retry.
/*G0PF*/       end.

/*G1LT*/       if shipper_found >= 1 then do:
/*G1LT*/          save_abs = substring(save_abs,2,12).
/*G1LT*/          {mfmsg03.i 1118 2 shipper_found save_abs """"}
/*G1LT*/          /* # Shippers/Containers found for this order, incl. # */
/*G1LT*/          {mfmsg01.i 11 1 del-yn}   /* PLEASE CONFIRM DELETE */
/*G1LT*/          if not del-yn then undo, retry.
/*G1LT*/       end.

/*G2PD** BEGIN DELETE **
 * /*G2L2*/       if pod_qty_rcvd <> 0 then do:
 * /*G2L2*/          {mfmsg.i 364 4}
 * /*G2L2*/          /* DELETE NOT ALLOWED, PO LINE HAS RECEIPTS */
 * /*G2L2*/          undo, retry.
 * /*G2L2*/       end.
 *G2PD** END DELETE ** */

/*G2PD*/       find first prh_hist where prh_nbr = pod_nbr
/*G2PD*/              and prh_line = pod_line no-lock no-error.
/*G2PD*/       if available prh_hist then do :
/*G2PD*/        /* DELETE NOT ALLOWED, PO LINE HAS RECEIPTS */
/*G2PD*/      {mfmsg.i 364 4}
/*G2PD*/          undo, retry.
/*G2PD*/       end. /* IF AVAILABLE prh_hist THEN */

               /*GJ59 MOVE DETAIL DELETE TO SUBROUTINE*/
               {gprun.i ""rssddel.p"" "(input recid(pod_det))"}
/*GUI*/ if global-beam-me-up then undo, leave.


               if not available po_mstr then leave detailloop.
               hide frame pod1.

/*G0C1*        clear frame pod all no-pause. */
/*G0C1*/       clear frame pod no-pause.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame pod = F-pod-title.
               next detailloop.
            end.

            if pod_pr_list <> "" then do:
/*GO13*     find first pc_mstr where pc_list = pod_pr_list
*             and pc_curr = po_curr
*             and pc_prod_line = ""
*             and pc_part = pod_part
*             and pc_um = pod_um
*             no-lock no-error.
*
*           if not available pc_mstr then do:
*GO13*/

/*GO13*/    found_price = no.

/*G0T5*
.*GO13*    {gprun.i ""rcpccal1.p"" "(input pod_part, input pod_pr_list,
.*GO13*    input po_ord_date, input pod_um, input po_curr, output found_price)"}
.*G0T5*/
           /* Validate that the Price List exists using the current date instead
              of the Scheduled Order Date since these orders can be added to
              over long periods of time.  To use the Scheduled Order Date
              would mean that pricing list Effective Dates would have to be
              backdated to the date the order was originally entered.  This
              is not only impractical but could also lead to other problems.
              NB: Prior to patch G013, no date limitation existed. This patch
              only changes validation.  The actual pricing assignment
              occurs during scheduled shipper confirmation (receipt) and uses
              the Effective Date specified at that time.  */

/*G0T5*/   {gprun.i ""rcpccal1.p"" "(input pod_part, input pod_pr_list,
           input today, input pod_um, input po_curr, output found_price)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*GO13*/    if found_price  = false then do:
/*J0SZ*        {mfmsg.i 8186 2}   PRICE LIST DOES NOT EXIST FOR THIS ITEM   */
/*J0SZ*/        {mfmsg.i 8160 2}   /* PRICE LIST DOES NOT EXIST FOR THIS ITEM */
                bell. 
            end.
            
         end.

/*LB01*.. Validate: Cost set needed.                          */
/*LB01*/ find si_mstr where si_site = pod_site no-lock no-error.
/*LB01*/ l_gl_set = si_gl_set.
/*LB01*/ if l_gl_set = "" then do:
/*LB01*/ 	find icc_ctrl where icc_site = pod_site no-lock no-error.
/*LB01*/	if available icc_ctrl then
/*LB01*/ 		l_gl_set = icc_gl_set.
/*LB01*/ end.
/*LB01*/ find sct_det where sct_sim = l_gl_set and sct_site = pod_site and pod_part = sct_part no-lock no-error.
/*LB01*/ 	if (l_gl_set="") or (not available sct_det) or (sct_cst_tot <= 0) then do:
/*LB01*/ 		message "零件成本不存在，请先维护成本！" VIEW-AS ALERT-BOX ERROR BUTTONS OK.		
/*LB01*/ 		undo , retry.
/*LB01*/ 	end. 



/*LB01   Validate the cost */
/*LB01*/ if pod_pur_cost=?  or pod_pur_cost < 0 then do:
/*LB01   	{mfmsg.i 8160 3}*/   /* COST IS INVALID */
/*LB01*/	   message "采购成本不能小于0，请重新输入！" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
/*LB01*/    undo, retry.
/*LB01*/ end.

/*LB01*/	if pod_pur_cost = 0 then do:
/*LB01*/	  message "警告：单位成本为0，继续吗？" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO TITLE "" UPDATE choice AS LOGICAL.
			 if not choice then do:
/*LB01*/      undo, retry.
     		 end.	 
/*LB01*/	end.

/*看中转库是否存在*/
/*LB01*/	if pod__chr01 <> "" then do:
				find first ad_mstr where ad_addr = pod__chr01 
					and ad_type = "company" no-lock no-error.
				if not available ad_mstr then do:
/*LB01*/	   	message "错误：中转站不存在，请重新输入！" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
/*LB01*/      	undo, retry.
     		 	end.	 
/*LB01*/	end.

         {gpglver1.i &acc=pod_acct &sub=? &cc=pod_cc &frame=pod1}


         /*GN76 ADDED FOLLOWING SECTION*/
         if not (pod_type = "" or pod_type = "s") then do:
            {mfmsg.i 4211 3}   /* INVALID TYPE CODE */
            next-prompt pod_type.
            undo, retry.
         end.
         /*GN76 END SECTION*/


         /*H057 ADDED NEW CODE */

         if {txnew.i} then do:
            /* VALIDATE TAXABLE AND TAX CODE */
            {gptxcval.i &code=pod_taxc &taxable=pod_taxable &date=po_tax_date
                &frame="pod1"}
         end.


         /* GET TAX MANAGEMENT DATA */
         if {txnew.i} and pod_taxable then do:
            taxloop:  do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

            /* SUGGEST TAX ENVIRONMENT */
                     if pod_tax_env = "" then do:
                        /* GET VENDOR SHIP_FROM TAX ZONE FROM ADDRESS */
                        find ad_mstr where ad_addr = vd_addr no-lock no-error.
                        if available ad_mstr then zone_from = ad_tax_zone.

                        /* GET SHIP_TO TAX ZONE FROM SHIP TO ADDRESS */
                        find ad_mstr where ad_addr = scx_shipto no-lock no-error.
                        if available ad_mstr then zone_to = ad_tax_zone.
                        else do:
/*H0BM*           {mfmsg03.i 902 2 """ Site Address""" """" """"} */
/*H0BM*/          {mfmsg.i 864 2} /* SITE ADDRESS DOES NOT EXIST */
                           zone_to = "".
                        end. /* ELSE AVAILABLE ad_mstr */

                        /* SUGGEST A TAX ENVIRONMENT */
                        {gprun.i ""txtxeget.p"" "(input zone_to,
                                                  input zone_from,
                                                  input pod_taxc,
                                                  output pod_tax_env)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                     end. /* IF pod_tax_env = "" */

                     update pod_tax_usage
                            pod_tax_env
                            pod_tax_in
                     with frame set_tax.

                     /* VALIDATE TAX ENVIRONMENT -- BLANKS NOT ALLOWED */
                     if pod_tax_env = "" then do:
/*H0BM*        {mfmsg03.i 906 3 """Tax Environment""" """" """"} */
/*H0BM*/       {mfmsg.i 944 3} /* BLANK TAX ENVIRONMENT NOT ALLOWED */
                        next-prompt pod_tax_env with frame set_tax.
                        undo taxloop, retry.
                     end.  /* IF pod_tax_env = "" */

                     if not {gptxe.v "pod_tax_env" ""no""} then do:
/*H0BM*        {mfmsg03.i 902 3 """Tax Environment""" """" """"} */
/*H0BM*/       {mfmsg.i 869 3} /* TAX ENVIRONMENT DOES NOT EXIST */
                        next-prompt pod_tax_env with frame set_tax.
                        undo taxloop, retry.
                     end.  /* IF NOT gptxe.v */
                     hide frame set_tax.
                  end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* taxloop */
               end. /* IF GTM and pod_taxable */

/*H0T4*/       if {txnew.i} and not pod_taxable and pod_tax_env = "" then
/*H0T4*/          pod_tax_env = po_tax_env.

/*H057 END NEW CODE */
/*GD42 ADDED FOLLOWING SECTION*/
               if pt_um <> pod_um then do:
                  find um_mstr where um_um = pt_um
                  and um_alt_um = pod_um
                  and um_part = pod_part no-lock no-error.

                  if not available um_mstr then
                     find um_mstr where um_um = pt_um
                     and um_alt_um = pod_um
                     and um_part = "" no-lock no-error.

                  if available um_mstr then do:
                     pod_um_conv = um_conv.
                  end.
                  else do:
                     {mfmsg.i 33 2} /* No UM conversion exists */
                  end.
               end.

               /*No F5/Delete Available */
/*G1R3*/       ststatus = stline[3].
/*G1R3*/       status input ststatus.

               update pod_um_conv with frame pod1.

/*GD42 END SECTION*/

/*J044*/       if can-find
/*J044*/       (first ie_mstr where ie_type = "2" and ie_nbr =  pod_nbr)
/*J044*/       then do:
                  imp-okay = no.
/*J044*/          {gprun.i ""iedetcr.p"" "(input ""2"",
                                     input pod_nbr,
                                     input pod_line,
                                     input recid(pod_det),
                                     input-output imp-okay)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J044*/          if imp-okay = no  then undo , retry.
/*J044*/       end.

/**J0CV**ADDED FOLLOWING CODE TO SUPPORT ERS PROCESSING**/
               /* DETERMINE RIGHT NOW WHAT THE VALID OPTIONS ARE */
               {gprun.i ""poers.p"" "(input po_vend, input pod_site,
                                      input pod_part, output ersopt,
                                      output erslst, output ers-err)"}
/*GUI*/ if global-beam-me-up then undo, leave.


               /* DETERMINE PROPER DEFAULT VALUES */
               if new-pod then do:
                  if po_ers_opt = "" then
                     assign
                        pod_ers_opt = ersopt
                        pod_pr_lst_tp = (if po_pr_lst_tp = 0 then erslst
                                                             else po_pr_lst_tp)
                     .
                  else assign
                     pod_ers_opt = integer(po_ers_opt)
                     pod_pr_lst_tp = po_pr_lst_tp.
               end.   /* IF NEW-POD */

              /* UPDATE ERS FIELDS ONLY IF ERS IS ENABLED */
              find first poc_ctrl no-lock no-error.
              if available poc_ctrl and poc_ers_proc then do:
/*J0K4*/         ers-loop:
/*J0K4*/         do with frame poders on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


                    display
                       pod_ers_opt   colon 23 skip
                       pod_pr_lst_tp colon 23 space(1)
                   with frame poders centered side-labels no-attr-space overlay
                    row (frame-row(pod1) + 3).

/*J0K4*           ers-loop:
*                 do with frame poders on error undo, retry:
*/
                    set pod_ers_opt pod_pr_lst_tp with frame poders.

                    /* VALIDATE ERS OPTION ENTERED IS VALID */
                    if not({gppoders.v}) then do:
/*J1B1                 /* ERS OPTION MUST BE 0, 1, 2, OR 3 */ */
/*J1B1                 {mfmsg02.i 2303 3 "'0, 1, 2, or 3'"} */
/*J1B1*/               {mfmsg.i 2303 3}        /* INVALID ERS OPTION */
                       next-prompt pod_ers_opt.
                       undo, retry ers-loop.
                    end.

                    /* VERIFY THAT ENTERED VALUE OF ERS OPTION ISN'T TOO HIGH */
                    if pod_ers_opt entered then do:
                       if ers-err = 0 and pod_ers_opt > ersopt then do:
                          /*ERS OPTION NOT VALID BASED UPON SUPPLIER/SITE/ITEM*/
                          {mfmsg.i 2317 1}
                          /* ERS OPTION MUST BE LESS THAN OR EQUAL TO */
                          {mfmsg02.i 2318 3 "string(ersopt)"}
                          next-prompt pod_ers_opt.
                          undo, retry ers-loop.
                       end.  /* IF ERS-ERR = 0 */

                       else if ers-err = 1 then do:
                          /* ERS VALUES MISSING FOR SITE */
/*J1B1                    {mfmsg02.i 2311 2 "'ERS Option set to 1'"} */
/*J1B1*/                  {mfmsg.i 2311 2}
/*J1B1*/                  {mfmsg.i 2346 1}   /* ERS OPTION SET TO 1 */
                          pod_ers_opt = 1.
                          display pod_ers_opt with frame poders.
                          next-prompt pod_ers_opt.
                          undo, retry ers-loop.
                       end.

                       else if ers-err = 2 then do:
                          /* ERS VALUES MISSING FOR SUPPLIER */
/*J1B1                    {mfmsg02.i 2309 2 "'ERS Option set to 1'"} */
/*J1B1*/                  {mfmsg.i 2309 2}
/*J1B1*/                  {mfmsg.i 2346 1}   /* ERS OPTION SET TO 1 */
                          pod_ers_opt = 1.
                          display pod_ers_opt with frame poders.
                          next-prompt pod_ers_opt.
                          undo, retry ers-loop.
                       end.

                       else if ers-err = 3 then do:
                          /* ERS VALUES MISSING FOR SUPPLIER AND SITE */
/*J1B1                    {mfmsg02.i 2301 2 "'ERS Option set to 1'"} */
/*J1B1*/                  {mfmsg.i 2301 2}
/*J1B1*/                  {mfmsg.i 2346 1}   /* ERS OPTION SET TO 1 */
                          pod_ers_opt = 1.
                          display pod_ers_opt with frame poders.
                          next-prompt pod_ers_opt.
                          undo, retry ers-loop.
                       end.
                    end. /* IF POD_ERS_OPT ENTERED */
                 end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* ERS-LOOP */
                 hide frame poders.
              end.   /* IF AVAIL POC_CTRL */
/**J0CV**END OF ADDED CODE**/

/*G1R3*/       if pod_type = "s" then do:

/*G1R3*/           find si_mstr no-lock where si_site = pod_site.
/*G1R3*/           old_db = global_db.
/*G1R3*/           if si_db <> global_db then do:
/*G1R3*/              {gprun.i ""gpalias3.p"" "(si_db, output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

/*G1R3*/           end.

/*G1R3*/           {gprun.i ""rspomtb1.p""
/*G1R3*/             "(input pod_site, input-output pod_wo_lot, input-output pod_op)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*G1R3*/           if old_db <> global_db then do:
/*G1R3*/              {gprun.i ""gpalias3.p"" "(old_db, output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

/*G1R3*/           end.
/*G1R3*/          if keyfunction(lastkey) = "END-ERROR" then undo,retry.
/*G1R3*/       end.
/*G1R3*/       else do:
                  /*Only hide frame pod1 if not type "s" since
                    rspomtb1.p (for subcontract items) will also
                    use pod1.  If we hide it then reuse it, the
                    frame will flash. */
                  hide frame pod1.
/*G1R3*/       end.
            end.
/*GUI*/ if global-beam-me-up then undo, leave.


/*G0G5   MOVED FOLLOWING SECTION OF CODE TO rspomtb1.p TO OVERCOME COMPILE
           SIZE LIMITATIONS
* /*GN76 ADDED FOLLOWING SECTION*/
* if pod_type = "s" then do with frame pod1:
*    display
*    pod_wo_lot
*    pod_op
*    .
*
*    do on error undo, retry:
*       any_msgs = no.
*       set pod_wo_lot pod_op.
*
*       find wo_mstr where wo_lot = pod_wo_lot no-lock no-error.
*
*       if not available wo_mstr then do:
*          {mfmsg.i 510 3}
*          undo, retry.
*       end.
*
*       if wo_type <> "" and wo_type <> "c" then do:
*          {mfmsg02.i 5103 3 wo_type}
*          undo, retry.
*       end.
*
*       if wo_site <> pod_site then do:
*          {mfmsg02.i 5112 3 wo_site}
*          undo, retry.
*       end.
*
*       if index ("FPC",wo_status) <> 0 then do:
*          {mfmsg.i 523 2}
*          any_msgs = yes.
*       end.
*
*       if wo_type = "c" and wo_due_date < today then do:
*          {mfmsg.i 5124 2}
*          any_msgs = yes.
*       end.
*
*
*       /*GET WO ROUTING RECORD*/
*
*       find wr_route where wr_lot = pod_wo_lot
*       and wr_op = pod_op
*       no-lock no-error.
*
*       if not available wr_route then do:
*          {mfmsg.i 106 3}
*          next-prompt pod_op.
*          undo, retry.
*       end.
*
*       {rewrsdef.i}
*       {rewrsget.i &lot=wr_lot &op=wr_op}
*
*       if wr_sub_cost = 0 then do:
*          {mfmsg.i 5118 2}
*          any_msgs = yes.
*       end.
*
*       if any_msgs then do:
*          message.
*          message.
*       end.
*    end.
* end.
* /*GN76 END SECTION*/
*G0G5   END SECTION OF CODE MOVED TO rspomtb1.p */

/*G1R3 /*G0G5*/  {gprun.i ""rspomtb1.p"" "(input recid(pod_det))"}  */

            /* DETAIL DATA ITEMS FRAME 2 */

            podcmmts = (pod_cmtindx <> 0 or (new pod_det and poc_lcmmts)).
            display
               pod_firm_days
               pod_plan_days
               pod_plan_weeks
               pod_plan_mths
               pod_fab_days
               pod_raw_days
               pod_translt_days
               pod_sftylt_days
               pod_vpart
               pod_sd_pat
               pod_cum_qty[3]
               pod_ord_mult
               pod_cum_date[1]
               podcmmts
/*G1XN*/       pod_start_eff[1]
/*G1XN*/       pod_end_eff[1]
            with frame pod2.

            do with frame pod2 on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

               ststatus = stline[3].
               status input ststatus.

               set
                  pod_firm_days
                  pod_plan_days
                  pod_plan_weeks
                  pod_plan_mths
                  pod_fab_days
                  pod_raw_days
                  pod_translt_days
                  pod_sftylt_days
                  pod_vpart
                  pod_sd_pat
                  pod_cum_qty[3]
                  pod_ord_mult
                  pod_cum_date[1]
                  podcmmts
/*G1XN*/          pod_start_eff[1]
/*G1XN*/          pod_end_eff[1].

               if pod_ord_mult = 0 then do:
                  {mfmsg.i 317 3}   /* ZERO NOT ALLOWED */
                  next-prompt pod_ord_mult.
                  undo, retry.
               end.

               if pod_vpart <> ""
               and not can-find(vp_mstr where vp_vend_part = pod_vpart
               and vp_part = pod_part and vp_vend = po_vend)
               then do:
                  {mfmsg.i 238 3}   /* SUPPLIER ITEM DOES NOT EXIST */
                  next-prompt pod_vpart.
                  undo, retry.
               end.

               if not ({gpcode.v pod_sd_pat sch_sd_pat}) then do:
                  {mfmsg.i 716 3}   /* VALUE MUST EXIST IN GENERALIZED CODES */
                  next-prompt pod_sd_pat.
                  undo, retry.
               end.
/*J0FY*/
/*J0FY*/      if pod_cum_qty[3] = 0 and
/*J0FY*/         can-find(whl_mstr where whl_mstr.whl_site = pod_site
/*J0FY*/                             and whl_mstr.whl_loc = pod_loc
                                     and whl_mstr.whl_act)
/*J0FY*/      then do:
/*J0FY*/          {mfmsg.i 1811 3}
                  /* MAX ORDER QTY CANNOT = 0 WHEN RCV'G INTO EXTERNAL WHSE */
/*J0FY*/          next-prompt pod_cum_qty[3].
/*J0FY*/          undo, retry.
/*J0FY*/      end.
               hide frame pod2.
            end.
/*GUI*/ if global-beam-me-up then undo, leave.




            /* DETAIL COMMENTS */

            if podcmmts then do:
               cmtindx = pod_cmtindx.
               global_ref = pod_part.
               {gprun.i ""gpcmmt01.p"" "(input ""pod_det"")"}
/*GUI*/ if global-beam-me-up then undo, leave.

               pod_cmtindx = cmtindx.

               view frame po.
            end.

/*GJ59 UPDATE REMOTE PO DETAIL RECORD IF THERE IS ONE*/
            {gprun.i ""rsrsdup.p"" "(input recid(pod_det))"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*G0D5*/    pod_sched_chgd = yes.
/*G0D5*/    release pod_det.
/*G0D5*/    release scx_ref.
         end.
/*GUI*/ if global-beam-me-up then undo, leave.

