/* rqrqmta.p  - REQUISITION MAINTENANCE - LINES                            */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                     */
/* All rights reserved worldwide.  This is an unpublished work.            */
/*V8:ConvertMode=Maintenance                                               */
/* $Revision: 1.37.2.8 $                                                   */
/* Revision: 8.6      LAST MODIFIED: 04/22/97   By: *J1Q2* B. Gates        */
/* Revision: 8.5      LAST MODIFIED: 10/30/97   By: *J243* Patrick Rowan   */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane       */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan      */
/* REVISION: 8.6E     LAST MODIFIED: 06/22/98   BY: *J2QB* B. Gates        */
/* REVISION: 8.6E     LAST MODIFIED: 07/18/98   BY: *L040* Brenda Milton   */
/* REVISION: 8.6E     LAST MODIFIED: 07/18/98   BY: *K1QS* Dana Tunstall   */
/* REVISION: 8.5      LAST MODIFIED: 08/12/98   BY: *J2W4* Patrick Rowan   */
/* REVISION: 8.5      LAST MODIFIED: 09/17/98   BY: *J2VX* Patrick Rowan   */
/* Revision: 8.5      LAST MODIFIED: 09/21/98   By: *J300* Patrick Rowan   */
/* Revision: 8.5      LAST MODIFIED: 09/28/98   By: *J30R* Patrick Rowan   */
/* Revision: 8.6E     LAST MODIFIED: 02/01/99   By: *J396* Steve Nugent    */
/* Revision: 9.1      LAST MODIFIED: 05/18/99   BY: *J3FW* Sachin Shinde   */
/* Revision: 9.1      LAST MODIFIED: 07/08/99   BY: *J3HV* Poonam Bahl     */
/* Revision: 9.1      LAST MODIFIED: 10/01/99   By: *N014* Murali Ayyagari */
/* Revision: 9.1      LAST MODIFIED: 10/07/99   BY: *J39R* Reetu Kapoor    */
/* Revision: 9.1      LAST MODIFIED: 01/28/00   BY: *K253* Sandeep Rao     */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane*/
/* REVISION: 9.1      LAST MODIFIED: 07/17/00   BY: *M0PY* Kaustubh K.     */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb             */
/* REVISION: 9.1      LAST MODIFIED: 10/06/00   BY: *M0TH* Abhijeet Thakur */
/* Revision: 9.1      LAST MODIFIED: 12/13/00   BY: *L16L* Rajaneesh S.    */
/* Revision: 1.37     BY:Patrick Rowan        DATE:01/04/01     ECO:J3QK   */
/* Revision: 1.37.2.2         BY:Nikita Joshi    DATE:08/03/01   ECO:M1DQ  */
/* Revision: 1.37.2.3         BY:Vivek Dsilva    DATE:10/10/01   ECO:N144  */
/* $Revision: 1.37.2.8 $        BY:Anitha Gopal    DATE:12/21/01   ECO:n174  */

/*NOTE: CHANGES MADE TO THIS PROGRAM MAY NEED TO BE MADE TO
REQUISITION DETAIL INQUIRY AND/OR REQUISITION MAINTENANCE
AND/OR REQUSITION REPORT.*/

/*J39R*/ /* TO REMOVE ACTION SEGMENT ERROR COMBINED MULTIPLE */
/*J39R*/ /* ASSIGN STATEMENTS                                */

 /*A100106*/ /*A-flag 20100106 not ctrl poc_pt_req */


         {mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE rqrqmta_p_1 "Ext Cost"
/* MaxLen: Comment: */

&SCOPED-DEFINE rqrqmta_p_2 " Supplier "
/* MaxLen: Comment: */

/*L16L* &SCOPED-DEFINE rqrqmta_p_3 "Item Not In Inventory" */
/* MaxLen: Comment: */

&SCOPED-DEFINE rqrqmta_p_4 "Max Ext Cost"
/* MaxLen: Comment: */

&SCOPED-DEFINE rqrqmta_p_5 "Supplier Item"
/* MaxLen: Comment: */

&SCOPED-DEFINE rqrqmta_p_6 "Stock Um Qty"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         define input parameter p_rqm_recid as recid no-undo.
         define input parameter p_new_req as log no-undo.

         {rqconst.i}
         define shared variable cmtindx as integer.

         define variable clines as integer initial ? no-undo.
         define variable continue as logical no-undo.
         define variable conversion_factor as decimal no-undo.
         define variable cur_cost as decimal no-undo.
         define variable del-yn like mfc_logical no-undo.
         define variable desc1 like pt_desc1 no-undo.
         define variable desc2 like pt_desc1 no-undo.
         define variable ext_cost like rqd_pur_cost
            label {&rqrqmta_p_1} no-undo.
         define variable got_vendor_price as logical no-undo.
         define variable i as integer no-undo.
/*N014*  define variable l_pl_cc like rqd_cc no-undo. */
         define variable line like rqd_line no-undo.
         define variable line_cmmts like COMMENTS no-undo.
         define variable max_ext_cost like rqd_max_cost
            label {&rqrqmta_p_4} no-undo.
         define variable mfgr like vp_mfgr no-undo.
         define variable mfgr_part like vp_mfgr_part no-undo.
         define variable messages as character no-undo.
         define variable msglevels as character no-undo.
         define variable msgnbr as integer no-undo.
         define variable new_rqd like mfc_logical no-undo.
/*L16L** define variable not_in_inventory_msg as character */
/*L16L**    initial {&rqrqmta_p_3} no-undo.                */
/*L16L*/ define variable not_in_inventory_msg as character no-undo.
         define variable poc_pt_req as log no-undo.
         define variable prev_category like rqd_category no-undo.
         define variable prev_ext_cost like ext_cost no-undo.
         define variable prev_item like rqd_part no-undo.
         define variable prev_max_ext_cost like ext_cost no-undo.
         define variable prev_qty like rqd_req_qty no-undo.
         define variable prev_site like rqd_site no-undo.
         define variable prev_status like rqd_status no-undo.
         define variable prev_um like rqd_um no-undo.
/*N014* /*J396*/ define variable prev_acct like rqd_acct no-undo. */
         define variable pur_cost as decimal no-undo.
         define variable qty_open like rqd_req_qty no-undo.
         define variable requm like rqd_um no-undo.
/*L040*/ define variable display_um like rqd_um no-undo.
/*L040*/ define variable base_cost like rqd_pur_cost no-undo.
         define variable rqd_recid as recid no-undo.
         define variable rqm_recid as recid no-undo.
         define variable sngl_ln like rqf_ln_fmt.
         define variable st_qty like pod_qty_ord label {&rqrqmta_p_6} no-undo.
         define variable tot_qty_ord like pod_qty_ord no-undo.
         define variable serial_controlled as log no-undo.
         define variable valid_acct like mfc_logical no-undo.
         define variable vendor like rqm_vend no-undo.
         define variable vendor_part like rqd_vpart no-undo.
         define variable vendor_price like vp_q_price no-undo.
         define variable vendor_q_curr like vp_curr no-undo.
         define variable vendor_q_qty like vp_q_qty no-undo.
         define variable vendor_q_um like vp_um no-undo.
         define variable yn like mfc_logical no-undo.
         define variable rndmthd like rnd_rnd_mthd no-undo.
         define variable formatstring as character no-undo.
         define variable warning like mfc_logical initial no no-undo.
         define variable net_price like pc_min_price no-undo.
         define variable new_net_price like pc_min_price no-undo.
         define variable lineffdate like rqm_due_date no-undo.
         define variable minprice like pc_min_price no-undo.
         define variable maxprice like pc_min_price.
         define variable pc_recno as recid no-undo.
         define variable minmaxerr as logical no-undo.
         define variable got_vendor_item_data as logical no-undo.
         define variable vend_row as integer no-undo.
         define variable disc_pct like rqd_disc_pct no-undo.
         define shared variable userid_modifying as character no-undo.
/*L040*/ define variable mc-error-number like msg_nbr      no-undo.
/*M0TH*/ define variable l_rqd_cost      like rqd_pur_cost no-undo.
/*M0TH*/ define variable l_flag          like mfc_logical  no-undo.
/*N014* - BEGIN DELETE
 * /*J300*/ /* temp_acct RETAINS THE ACCOUNT NUMBER FOR CATEGORY SEARCHES.     */
 * /*J300*/ /* IT IS NEEDED BECAUSE rqd_acct IS CONCATENATED WITH THE SUB-ACCT */
 * /*J300*/ define variable temp_acct like rqd_acct no-undo.
 *N014* - END DELETE */

/*J30R*/ /* st_um CONTAINS THE STOCKING UM. IT'S USED TO COMPARE TO */
/*J30R*/ /* REQ_UM TO SEE IF QTY CONVERSION SHOULD BE DONE          */
/*J30R*/ define variable st_um like rqd_um no-undo.
/*J30R*/ define variable req_qty like rqd_req_qty no-undo.

/*M0PY*/ define variable l_actual_disc  as decimal                no-undo.
/*M0PY*/ define variable l_min_disc     as decimal initial -99.99 no-undo.
/*M0PY*/ define variable l_max_disc     as decimal initial 999.99 no-undo.
/*M0PY*/ define variable l_display_disc as decimal                no-undo.
/*M1DQ*/ define variable l_prev_vend    like rqd_vend             no-undo.
/*N144*/ define variable l_prev_list    like rqd_pr_list          no-undo.
/*N144*/ define variable l_prev_list2   like rqd_pr_list2         no-undo.
/*N174*/ define variable l_rqd_disc_pct like rqd_disc_pct         no-undo.

/*L16L*/ not_in_inventory_msg = getTermLabel("ITEM_NOT_IN_INVENTORY",30).

         form
            rqm_mstr.rqm_nbr
            rqm_vend
            sngl_ln             colon 70
         with frame a attr-space side-labels width 80.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).

         form
            line
            rqd_site
            rqd_part
            rqd_vend
            rqd_req_qty
            rqd_um
            rqd_pur_cost        format ">>>>>>>>9.99<<<"
            rqd_disc_pct
         with frame b clines down width 80.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame b:handle).

         form
            rqd_due_date        colon 15
            rqd_lot_rcpt        colon 36
            rqd_um_conv         colon 60
            rqd_need_date       colon 15
            rqd_rev             colon 36
            st_qty              colon 60
            rqd_type            colon 15
            tot_qty_ord         colon 60
            rqd_category        colon 15
            rqd_max_cost        colon 60 no-attr-space
            rqd_acct            colon 15
/*N014*/    rqm_sub             no-label
/*N014*/    rqm_cc              no-label
/*N014*/    rqd_project         no-label
/*J2QB*     rqd_cc              colon 36 */
/*N014* /*J2QB*/    rqm_cc              colon 36 */
            ext_cost            colon 60 no-attr-space
/*N014*            rqd_project         colon 15 */
            max_ext_cost        colon 60 no-attr-space
            rqd_vpart           colon 15 label {&rqrqmta_p_5}
            rqd_status          colon 60
            mfgr                colon 15
            mfgr_part           no-attr-space no-label
            line_cmmts          colon 60
            desc1               colon 15
            rqd_aprv_stat       colon 60
            desc2               at 17 no-label
         with frame c attr-space side-labels 1 down width 80.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame c:handle).

         form
            space(1)
            ad_name              no-label
            skip space(1)
            ad_line1             no-label
            skip space(1)
            ad_line2             no-label
            skip space(1)
            ad_city              no-label
            ad_state             no-label
            ad_zip               no-label
            skip space(1)
            ad_country           no-label
            skip(1)
            space(1)
            rqd_pr_list2
            rqd_pr_list
         with overlay frame vend centered row vend_row side-labels
         title color normal (getFrameTitle("SUPPLIER",13)) width 40.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame vend:handle).

         rqm_recid = p_rqm_recid.
         find first rqf_ctrl no-lock.
         find first poc_ctrl no-lock.
         find first mfc_ctrl where mfc_field = "poc_pt_req" no-lock no-error.
         if available mfc_ctrl then poc_pt_req = mfc_logical.
         poc_pt_req = no . /*A100106*/

         sngl_ln = rqf_ln_fmt.
         find rqm_mstr where recid(rqm_mstr) = p_rqm_recid no-lock.
         find first gl_ctrl no-lock.

         /* SET CURRENCY DISPLAY FORMATS */

         if rqm_curr = gl_base_curr then do:
            rndmthd = gl_rnd_mthd.
         end.
         else do:
            rndmthd = ?.
/*L040*     find first ex_mstr where ex_curr = rqm_curr no-lock no-error. */
/*L040*     if available ex_mstr then rndmthd = ex_rnd_mthd. */
/*L040*/    /* GET ROUNDING METHOD FROM CURRENCY MASTER */
/*L040*/    {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
              "(input rqm_curr,
                output rndmthd,
                output mc-error-number)"}
/*L040*/    if mc-error-number <> 0 then do:
/*J39R** /*L040*/       {mfmsg.i mc-error-number 2}   */
/*J39R*/       run p_ip_msg (input mc-error-number, input 2).
/*L040*/    end.
         end.

         formatstring = ext_cost:format in frame c.

         {gprun.i ""gpcurfmt.p""
           "(input-output formatstring, input rndmthd)"}

         ext_cost:format in frame c = formatstring.

         formatstring = max_ext_cost:format in frame c.

         {gprun.i ""gpcurfmt.p""
           "(input-output formatstring, input rndmthd)"}

         max_ext_cost:format in frame c = formatstring.

         display
            rqm_nbr
            rqm_vend
            sngl_ln
         with frame a.

         line = 1.
         find last rqd_det where rqd_nbr = rqm_nbr no-lock no-error.
         if available rqd_det then line = rqd_line + 1.

         mainloop:
         repeat:
            if sngl_ln then clines = 1.
            else clines = ?.

            view frame b.
            if sngl_ln then view frame c.

            lineloop:
            repeat transaction:
               assign
                  minprice = 0
                  maxprice = 0.

               /* RESET "PREVIOUS" VALUE VARS */

               assign
                  prev_item         = ""
                  prev_site         = ""
                  prev_category     = ""
                  prev_ext_cost     = 0
                  prev_max_ext_cost = 0
                  prev_qty          = 0
                  prev_status       = ""
/*N014* /*J396*/          prev_acct = "" */
                  prev_um           = ""
/*M1DQ*/          l_prev_vend       = ""
/*N144*/          l_prev_list       = ""
/*N144*/          l_prev_list2      = "".

               /* INITIALIZE SINGLE-LINE FRAME */

               find rqd_det where rqd_nbr = rqm_nbr and rqd_line = line
               no-lock no-error.

               if available rqd_det then do:
                  line_cmmts = rqd_cmtindx <> 0.
                  rqd_recid = recid(rqd_det).
                  run display_line_frame_b.

                  if sngl_ln then do:
                     run display_line_frame_c.
                  end.
               end.
               else do:
                  line_cmmts = rqf_lcmmts.
                  run initialize_frame_b.
                  if sngl_ln then run initialize_frame_c.
               end.

               /* GET LINE NUMBER FROM USER */

               display line with frame b.

               do on error undo, retry:
                  set line with frame b editing:
                     {mfnp01.i rqd_det line rqd_line rqm_nbr rqd_nbr rqd_nbr}

                     if recno <> ? then do:
                        rqd_recid = recid(rqd_det).
                        run display_line_frame_b.

                        if sngl_ln then do:
                           run display_line_frame_c.
                        end.
                     end.
                  end.

                  if line < 1 then do:
/*J39R**             {mfmsg.i 317 1}     */
/*J39R*/             run p_ip_msg (input 317, input 1).
                     /* ZERO NOT ALLOWED */
                     undo, retry.
                  end.

                  find first rqpo_ref
                  where rqpo_req_nbr = rqm_nbr and rqpo_req_line = line
                  no-lock no-error.

                  if available rqpo_ref then do:
/*J2VX*              {mfmsg02.i 2102 2                                  */
/*J2VX*                 "rqpo_po_nbr + ' ' + string(rqpo_po_line)"}     */
/*J2VX*/             run display_message_mfmsg02
                        (input 2102,
                         input 2,
                         input rqpo_po_nbr + ' ' + string(rqpo_po_line)).
                     /* REQUISITION LINE REFERENCED BY PO */
                  end.
               end.

               /* FIND RECORD OR CREATE */

               find rqd_det where rqd_nbr = rqm_nbr and rqd_line = line
               exclusive-lock no-error.

               if available rqd_det then do:
                  rqd_recid = recid(rqd_det).
                  run display_line_frame_b.

                  if sngl_ln then do:
                     run display_line_frame_c.
                  end.

                  new_rqd = false.
                  global_part = rqd_part.

                  if rqd_status <> "x" then do:
/*J39R*/             assign
/*M0TH*/                l_rqd_cost        = rqd_pur_cost
                        prev_ext_cost     = rqd_req_qty * rqd_pur_cost
                                            * (1 - (rqd_disc_pct / 100))

/*N174**                prev_max_ext_cost = rqd_req_qty * rqd_max_cost    */
/*N174**                                    * (1 - (rqd_disc_pct / 100)). */

/*N174*/                prev_max_ext_cost = rqd_req_qty * rqd_max_cost.

                  end.

                  if rqd_aprv_stat = APPROVAL_STATUS_APPROVED
                  or rqd_aprv_stat = APPROVAL_STATUS_OOT
                  then do:
/*J39R**             {mfmsg.i 2116 2} */
/*J39R*/             run p_ip_msg (input 2116, input 2).
                     /* APPROVED/OOT STATUS WILL BE CHANGED TO UNAPPROVED */
                  end.

                  assign
                     prev_category = rqd_category
                     prev_item     = rqd_part
                     prev_qty      = rqd_req_qty
                     prev_site     = rqd_site
                     prev_status   = rqd_status
                     prev_um       = rqd_um

/*J30R*/             /* STOCKING UM IS INITIALIZED TO THE REQ_UM AND WILL */
/*J30R*/             /* BE UPDATED TO THE PT_UM IF THE PART IS A PT_MSTR  */
/*J30R*/             st_um         = rqd_um
/*M1DQ*/             l_prev_vend   = rqd_vend
/*N144*/             l_prev_list   = rqd_pr_list
/*N144*/             l_prev_list2  = rqd_pr_list2.

               end.
               else do:
                  if rqm_status = "x" then do:
                     yn = no.
/*J39R**             {mfmsg01.i 2077 1 yn} */
/*J39R*/             run p_mfmsg01 (input 2077, input 1, input-output yn).
                     /* ADDING NEW LINE TO CANCELLED REQUISITION - REOPEN? */

                     if not yn then undo, retry.

                     find rqm_mstr where recid(rqm_mstr) = p_rqm_recid
                     exclusive-lock.

                     rqm_status = "".

                  end.

/*J39R*/          /* WHEN A NEW LINE IS ADDED TO A CLOSED REQ */
/*J39R*/          /* OPENING THE REQ AGAIN                    */

/*J39R*/          if rqm_status = "c" then do:
/*J39R*/             yn = no.
/*J39R*/             /*ADDING NEW LINE TO CLOSED REQUISITION - REOPEN?*/
/*J39R*/             run p_mfmsg01 (input 3299, input 1, input-output yn).
/*J39R*/             if not yn then undo, retry.

/*J39R*/             if yn then do:
/*J39R*/                run p_open_req (input recid(rqm_mstr)).
/*J39R*/             end. /* IF YN THEN */

/*J39R*/          end. /* IF RQM_STATUS = "C" */

/*J39R**          {mfmsg.i 1 1}      */
/*J39R*/           run p_ip_msg (input 1, input 1).
                  /* ADDING NEW RECORD */
                  create rqd_det.

                  assign
                     rqd_aprv_stat = APPROVAL_STATUS_UNAPPROVED
/*J2QB*              rqd_cc = rqm_cc */
                     rqd_disc_pct = rqm_disc_pct
                     rqd_due_date = rqm_due_date
                     rqd_line = line
                     rqd_nbr = rqm_nbr
                     rqd_need_date = rqm_need_date
                     rqd_pr_list = rqm_pr_list
                     rqd_pr_list2 = rqm_pr_list2
                     rqd_project = rqm_project
                     rqd_site = rqm_site
                     rqd_um = ""
                     rqd_um_conv = 1
                     rqd_vend = rqm_vend.

                  if recid(rqd_det) = -1 then.

                  /* THE FOLLOWING IS JUST TO TRICK FOLLOWING CODE
                   * INTO THINKING THERE ARE COMMENTS SO AS TO PROPERLY
                   * DISPLAY THE LINE_CMMTS VARIABLE */
                  if rqf_lcmmts then rqd_cmtindx = -1.
/*J39R*/          assign
                  new_rqd = true
                  rqd_recid = recid(rqd_det).
                  run display_line_frame_b.

                  if sngl_ln then do:
                     run display_line_frame_c.
                  end.
               end.

               line_cmmts = rqd_cmtindx <> 0.

               /* GET SITE FROM USER */

               run get_site.
               if not continue then undo, retry.

               /* GET ITEM FROM USER */

               run get_item.
               if not continue then undo, retry.
               global_part = rqd_part.

               if sngl_ln then do:
                  /* DISPLAY SUPPLIER IF THERE IS ONE */

                  run display_supplier(input rqd_vend).

                  /* DISPLAY PRICE AND DISCOUNT LISTS */

                  display
                     rqd_pr_list2
                     rqd_pr_list
                  with frame vend.
               end.

               /* GET SUPPLIER FROM USER */

               run get_supplier.

               if not continue then do:
                  hide frame vend no-pause.
                  undo, retry.
               end.

               /* GET DEFAULT PRICE AND DISCOUNT LISTS */

/*N144**       if new_rqd and rqd_vend <> rqm_vend then do:  */
                  find vd_mstr where vd_addr = rqd_vend no-lock no-error.

/*N144**          if available vd_mstr then do: */
/*N144*/          if available vd_mstr
/*N144*/          then
                     assign
                        rqd_pr_list  = vd_pr_list
                        rqd_pr_list2 = vd_pr_list2.
/*N144*/          else
/*N144*/             assign
/*N144*/                rqd_pr_list  = ""
/*N144*/                rqd_pr_list2 = "".

/*N144**          end. */
/*N144**       end. */

               /* GET PRICE AND DISCOUNT LISTS FROM USER */

               if sngl_ln then do:
                  display
                     rqd_pr_list2
                     rqd_pr_list
                  with frame vend.

                  setpriceinfo:
                  do on error undo, retry:
                     set
                        rqd_pr_list2
                        rqd_pr_list
                     with frame vend.

                     /* CHECK PRICE LIST */

/*K1QS*/             /* ADDED TWO ARGUMENTS &DISP-MSG AND &WARNING */
                     {adprclst.i
                     &price-list     = "rqd_pr_list2"
                     &curr           = "rqm_curr"
                     &price-list-req = "poc_pt_req"
                     &undo-label     = "setpriceinfo"
                     &with-frame     = "with frame vend"
                     &disp-msg       = "yes"
                     &warning        = "yes"}

                     /*CHECK DISCOUNT LIST*/

/*K1QS*/             /* ADDED TWO ARGUMENTS &DISP-MSG AND &WARNING */
                     {addsclst.i
                     &disc-list      = "rqd_pr_list"
                     &curr           = "rqm_curr"
                     &disc-list-req  = "poc_pl_req"
                     &undo-label     = "setpriceinfo"
                     &with-frame     = "with frame vend"
                     &disp-msg       = "yes"
                     &warning        = "yes"}
                  end.

                  hide frame vend no-pause.
               end.

/*J300*        if new_rqd then do:                                      */
/*J300*/       if new_rqd or rqd_part <> prev_item then do:

                  /* GET DEFAULT ACCT */

/*J300*/          assign
/*N014* /*J300*/    temp_acct = gl_pur_acct. */
/*J300*/            rqd_acct = gl_pur_acct.

                  find vd_mstr where vd_addr = rqd_vend no-lock no-error.

                  if available vd_mstr then do:
/*J300*/             assign
/*N014* /*J300*/        temp_acct = vd_pur_acct */
                        rqd_acct = vd_pur_acct.
/*J2QB*              if rqm_direct then rqd_cc = vd_pur_cc. */
                  end.

/*N014* - BEGIN DELETE
 * /*J396*/         rqd_acct = rqd_acct + "       ".
 *
 *                /* PUT SUBACCOUNT INTO ACCOUNT */
 *
 * /*J300*/          /*CONCATENATE THE SUB-ACCOUNT ONLY IF THE ACCOUNT NBR */
 * /*J300*/          /*CONTAINS A VALUE.                                   */
 *
 * /*J300*           if rqm_sub > "" and gl_sub_len > 0 then do:           */
 * /*J300*/          if rqd_acct <> "" and
 * /*J300*/             rqm_sub > "" and gl_sub_len > 0 then do:
 *                      rqd_acct =
 *                          substr(rqd_acct, 1, (8 - gl_sub_len)) + rqm_sub.
 * /*J396*/                assign
 * /*J396*/                    prev_acct = rqd_acct.
 *                end.
 * /*J3HV*/          /* FOR ORACLE ENVIRONMENT, ENSURING THAT THERE ARE NO
    Last change:  QAD  10 Oct 2001    7:51 pm
 */
 * /*J3HV*/          /* TRAILING SPACES                                      */
 * /*J3HV*/          prev_acct = trim(prev_acct).
 *N014* - END DELETE */

                  /* DEFAULT CATEGORY */

/*J300*           find last rqcd_det
 *                where  rqcd_acct_from <= rqd_acct
 *                and rqcd_acct_to >= rqd_acct
 *                no-lock no-error.
 *
 *                if available rqcd_det then do:
 *                  rqd_category = rqcd_category.
 *                end.
 *J300*/

/*N014* - BEGIN DELETE
 * /*J300*/          run get_default_category
 *                    (input rqm_direct,
 *                     input temp_acct,
 *                     input rqd_acct,
 *                     output rqd_category).
 *N014* - END DELETE */
/*N014* - BEGIN ADD */
                  run get_default_category
                      (input rqm_direct,
                       input rqd_acct,
                       input rqm_sub,
                       output rqd_category).
/*N014* - END ADD */

/*J300*
 *     /*L040*/end.
 *
 *     /*L040*/if new_rqd or rqd_part <> prev_item then do:
 *J300*/
                  /* GET DATA IF THERE IS AN ITEM MASTER RECORD */

                  find pt_mstr where pt_part = rqd_part no-lock no-error.

                  if available pt_mstr then do:
                     /* INITIALIZE RECORD */
                     assign
                        rqd_desc = pt_desc1
                        rqd_rev = pt_rev
                        rqd_loc = pt_loc
                        rqd_insp_rqd = pt_insp_rqd
                        rqd_um = pt_um
/*J300*/                rqd_type = ""
                        vendor_part = ""
                        mfgr = ""
                        mfgr_part = "".

                     if pt_lot_ser = "s" then rqd_lot_rcpt = true.

                     /* GET FIELD VALS FROM PTP_DET */

                     find ptp_det where ptp_part = pt_part
                     and ptp_site = rqd_site no-lock no-error.

                     if available ptp_det then do:
/*J39R*/                assign
                            rqd_rev = ptp_rev
                            rqd_insp_rqd = ptp_ins_rqd.
                     end.

                     if (available ptp_det and ptp_ins_rqd) or
                     (not available ptp_det and pt_insp_rqd) then do:
                        find first poc_ctrl no-lock.
                        rqd_loc = poc_insp_loc.
                     end.

                     /* GET FIELD VALS FROM PL_MSTR */

                     find pl_mstr where pl_prod_line = pt_prod_line
                     no-lock no-error.

                     if available pl_mstr then do:
                        assign
/*N014* /*J300*/           temp_acct = pl_pur_acct */
                           rqd_acct = pl_pur_acct.

/*J2QB*                 if rqm_direct then rqd_cc = pl_pur_cc. */
                     end.

/*N014* - BEGIN DELETE
 * /*J396*/             rqd_acct = rqd_acct + "       ".
 *
 *                   /* PUT SUBACCOUNT INTO ACCOUNT */
 *
 * /*J300*/             /*CONCATENATE THE SUB-ACCOUNT ONLY IF THE ACCOUNT NBR */
 * /*J300*/             /*CONTAINS A VALUE.                                   */
 *
 * /*J300*              if rqm_sub > "" and gl_sub_len > 0 then do:           */
 * /*J300*/             if rqd_acct <> "" and
 * /*J300*/                rqm_sub > "" and gl_sub_len > 0 then do:
 *                          rqd_acct =
 *                              substr(rqd_acct, 1, (8 - gl_sub_len)) + rqm_sub.
 * /*J396*/                    assign
 * /*J396*/                        prev_acct = rqd_acct.
 *                   end.
 * /*J3HV*/           /* FOR ORACLE ENVIRONMENT, ENSURING THAT THERE ARE NO   */
 * /*J3HV*/           /* TRAILING SPACES                                      */
 * /*J3HV*/             prev_acct = trim(prev_acct).
 *N014* - END DELETE */

                     /* DEFAULT CATEGORY */

/*J300*              find last rqcd_det
 *                   where  rqcd_acct_from <= rqd_acct
 *                   and rqcd_acct_to >= rqd_acct
 *                   no-lock no-error.
 *
 *                   if available rqcd_det then do:
 *                      rqd_category = rqcd_category.
 *                   end.
 *J300*/

/*N014* - BEGIN DELETE
 * /*J300*/             run get_default_category
 *                      (input rqm_direct,
 *                       input temp_acct,
 *                       input rqd_acct,
 *                       output rqd_category).
 *N014* - END DELETE */
/*N014* - BEGIN ADD */
                     run get_default_category
                        (input rqm_direct,
                         input rqd_acct,
                         input rqm_sub,
                         output rqd_category).
/*N014* - END ADD */

                     /* GET SUPPLIER ITEM */

                     vendor = rqd_vend.
                     if rqd_vend = "" then vendor = rqm_vend.

                     run retrieve_vendor_item_data
                        (input vendor,
                         input rqd_part,
                         output got_vendor_item_data,
                         output vendor_q_qty,
                         output vendor_q_um,
                         output vendor_q_curr,
                         output vendor_part,
                         output vendor_price,
                         output mfgr,
                         output mfgr_part).

                     if got_vendor_item_data then rqd_vpart = vendor_part.
/*L040*/             else rqd_vpart = "".

                     /* DISPLAY STUFF */

                     display
                        rqd_um
                        rqd_pur_cost
                     with frame b.

                     if sngl_ln then do:
                        display
                           rqd_vpart
                           mfgr
                           mfgr_part
                           rqd_um_conv
                           pt_desc1 @ desc1
                           pt_desc2 @ desc2
                           rqd_category
                           rqd_acct
/*N014*/                   rqm_sub
/*J2QB*                    rqd_cc */
/*J2QB*/                   rqm_cc
                           rqd_project
                        with frame c.
                     end.
                  end. /*IF AVAILABLE PT_MSTR*/
                  else do:
                     if sngl_ln then do:
                        display not_in_inventory_msg @ desc1 with frame c.
                     end.

/*J300*/             assign
/*J300*/                rqd_vpart = ""
/*J300*/                mfgr = ""
/*J300*/                mfgr_part = ""
                        rqd_desc = not_in_inventory_msg
                        rqd_type = "M".
/*J39R**             {mfmsg.i 25 2} */
/*J39R*/              run p_ip_msg (input 25, input 2).
                     /* TYPE SET TO (M)EMO */

/*L040*/             if sngl_ln then do:
/*L040*/                display
/*L040*/                    rqd_type
/*J300*/                    rqd_vpart
/*J300*/                    mfgr
/*J300*/                    mfgr_part
/*J300*/                    rqd_category
/*J300*/                    rqd_acct
/*N014*/                    rqm_sub
/*J300*/                    rqm_cc
/*J300*/                    rqd_project
/*L040*/                    with frame c.
/*L040*/             end.
                  end.
               end.  /* if new_rqd or rqd_part <> prev_item */

/*M1DQ*/       /* BEGIN ADD */
               else do:
                  if  not new_rqd
                  and rqd_vend <> l_prev_vend
                  then do:
                     assign
                        vendor       = if rqd_vend = ""
                                       then
                                          rqm_vend
                                       else
                                          rqd_vend
                        rqd_vpart    = ""
                        mfgr         = ""
                        mfgr_part    = "".

                     for each vp_mstr
                        fields (vp_curr vp_mfgr vp_mfgr_part vp_part vp_q_date
                                vp_q_price vp_q_qty vp_um vp_vend vp_vend_part)
                        where vp_part = rqd_part
                        and   vp_vend = vendor
                        no-lock
                        break by vp_q_date descending:

                        if first(vp_q_date)
                        then
                           assign
                              rqd_vpart    = vp_vend_part
                              mfgr         = vp_mfgr
                              mfgr_part    = vp_mfgr_part.

                     end. /* FOR EACH vp_mstr */

                     if sngl_ln
                     then
                        display
                           rqd_vpart
                           mfgr
                           mfgr_part
                        with frame c.

                  end. /* IF NOT new_rqd AND rqd_vend <> l_prev_vend */
               end. /* ELSE DO */

/*M1DQ*/       /* END ADD */

               /*** GET DEPENDENT DATA ETC ***/

               del-yn = false.

               ststatus = stline[2].
               status input ststatus.

               /* GET REQ QTY AND UM FROM USER */

               do on error undo, retry:
                  set
                    rqd_req_qty
                    rqd_um
/*J30R** /*J300*/      when (new_rqd or rqd_part <> prev_item) */
                    go-on(CTRL-D F5) with frame b.

                  if lastkey = keycode("f5") or lastkey = keycode("ctrl-d")
                  then do:
                     find first rqpo_ref where rqpo_req_nbr = rqd_nbr
                     and rqpo_req_line = rqd_line
                     no-lock no-error.

                     if available rqpo_ref then do:
/*J39R**                {mfmsg.i 2081 3}  */
/*J39R*/                run p_ip_msg (input 2081, input 3).
                        /* CAN'T DELETE REQUISITION, REFERENCED BY POS */
                        undo, retry.
                     end.

                     del-yn = true.
/*J39R**             {mfmsg01.i 11 1 del-yn}  */
/*J39R*/             run p_mfmsg01 (input 11, input 1, input-output del-yn).
                     /* PLEASE CONFIRM DELETE */

                     if del-yn then do:
                        /* WRITE HISTORY RECORD */

                        {gprun.i ""rqwrthst.p""
                          "(input rqm_nbr,
                            input rqd_line,
                            input ACTION_DELETE_REQ_LINE,
                            input userid_modifying,
                            input '',
                            input '')"}

                        /* DELETE COMMENTS */

                        line = rqd_line + 1.

                        for each cmt_det exclusive-lock
                        where cmt_indx = rqd_cmtindx:
                           delete cmt_det.
                        end.

                        /* DELETE ANY MRP DETAIL RECORDS */

                        for each mrp_det exclusive-lock
                        where mrp_dataset = "req_det"
                        and mrp_nbr = rqd_nbr
                        and mrp_line = string(rqd_line):
                           {inmrp.i
                              &part=mrp_det.mrp_part &site=mrp_det.mrp_site}

                           delete mrp_det.
                        end.

                        /* DELETE THE LINE RECORD */

                        delete rqd_det.

                        find rqm_mstr
                        where recid(rqm_mstr) = p_rqm_recid
                        exclusive-lock.
/*J39R*/                assign
                           rqm_total = rqm_total - prev_ext_cost
                           rqm_max_total = rqm_max_total - prev_max_ext_cost.

                        clear frame b.
                        if sngl_ln then clear frame c.
                        next lineloop.
                     end.
                     else undo, retry.
                  end.

                  if rqd_req_qty = 0 then do:
/*J39R**             {mfmsg.i 317 3}  */
/*J39R*/             run p_ip_msg (input 317, input 3).
                     /* ZERO NOT ALLOWED */
                     undo, retry.
                  end.

                  /* NEEDS TO BE A UM CONVERSION TO STK UM */

                  find pt_mstr where pt_part = rqd_part no-lock no-error.

                  if available pt_mstr then do:
                     if rqd_um <> pt_um then do:
                        {gprun.i ""gpumcnv.p""
                          "(input rqd_um, input pt_um, input pt_part,
                            output conversion_factor)"}

                        if conversion_factor = ? then do:
/*J2VX*                    {mfmsg02.i 33 3 pt_um}                       */
/*J2VX*/                   run display_message_mfmsg02
                            (input 33,
                             input 3,
                             input pt_um).
                           /* NO UNIT OF MEASURE CONVERSION EXISTS */
                           next-prompt rqd_um with frame b.
                           undo, retry.
                        end.
                     end.
                  end.

                  /* CHANGING UM NOT ALLOWED IF REFERENCED BY A PO */

                  if not new_rqd and rqd_um <> prev_um then do:
                     find first rqpo_ref
                     where rqpo_req_nbr = rqd_nbr
                     and rqpo_req_line = rqd_line
                     no-lock no-error.

                     if available rqpo_ref then do:
/*J39R**                {mfmsg.i 2114 3}    */
/*J39R*/                 run p_ip_msg (input 2114, input 3).
                        /* REQUISITION LINE REFERENCED BY PO, CHANGE
                         * NOT ALLOWED */
                        next-prompt rqd_um with frame b.
                        undo, retry.
                     end.
                  end.

                  /* CHANGING (REDUCING) QTY MUST NOT CAUSE A NEGATIVE
                   * OPEN QTY */

                  {gprun.i ""rqoqty.p""
                    "(input false,
                      input rqd_site,
                      input rqd_nbr,
                      input rqd_line,
                      output qty_open,
                      output requm)"}

                  if qty_open < 0 then do:
/*J39R**             {mfmsg.i 2093 3} */
/*J39R*/             run p_ip_msg (input 2093, input 3).
                     /* QTY ON PURCHASE ORDERS EXCEEDS REQUISITION LINE QTY */
                     undo, retry.
                  end.

                  /* GET SUPPLIER ITEM UM AND COMPARE TO REQ UM */

                  vendor = rqd_vend.
                  if rqd_vend = "" then vendor = rqm_vend.

                  run retrieve_vendor_item_data
                     (input vendor,
                      input rqd_part,
                      output got_vendor_item_data,
                      output vendor_q_qty,
                      output vendor_q_um,
                      output vendor_q_curr,
                      output vendor_part,
                      output vendor_price,
                      output mfgr,
                      output mfgr_part).

                  if got_vendor_item_data and vendor_q_um <> rqd_um then do:
/*J2VX*              {mfmsg02.i 304 2 vendor_q_um}                      */
/*J2VX*/             run display_message_mfmsg02
                        (input 304,
                         input 2,
                         input vendor_q_um).
                     /* UM NOT THE SAME AS FOR VENDOR PART */
                  end.
               end.

               /* DETERMINE UM CONVERSION FACTOR */

               find pt_mstr where pt_part = rqd_part no-lock no-error.

               if available pt_mstr then do:
                  if pt_um = rqd_um then do:
                     conversion_factor = 1.
                  end.
                  else do:
                     {gprun.i ""gpumcnv.p"" "(input rqd_um,
                       input pt_um, input rqd_part,
                       output conversion_factor)"}
                  end.

                  if conversion_factor = ? then do:
/*J39R**             {mfmsg.i 33 2}   */
/*J39R*/             run p_ip_msg (input 33, input 2).
                     /* NO UNIT OF MEASURE CONVERSION EXISTS */
                  end.
                  else do:
                     rqd_um_conv = conversion_factor.
                  end.
               end.

               if sngl_ln then do:
                  display rqd_um_conv with frame c.
                  run display_st_qty.
               end.

               /* CALCULATE PRICE NOW THAT WE KNOW QTY */
/*L040*/       /* ALSO CALCULATE NEW PRICE WHEN PART HAS CHANGED */
/*L040*        if new_rqd or (rqd_req_qty <> prev_qty or rqd_um <> prev_um) */
/*L040*/       if new_rqd
/*L040*/       or (rqd_part     <> prev_item
/*L040*/       or  rqd_req_qty  <> prev_qty
/*L040*/       or  rqd_um       <> prev_um
/*N144*/       or  rqd_vend     <> l_prev_vend
/*N144*/       or  rqd_pr_list  <> l_prev_list
/*N144*/       or  rqd_pr_list2 <> l_prev_list2)
               then do:

/*J39R*/          /* WHEN THE REQ QTY IS CHANGED FOR A REQ LINE */
/*J39R*/          /* HAVING STATUS CLOSED OR CANCELLED          */

/*J39R*/          if not new_rqd and
/*J39R*/             (rqd_part    <> prev_item             or
/*J39R*/              rqd_req_qty <> prev_qty              or
/*J39R*/              rqd_um      <> prev_um)              and
/*J39R*/             (rqm_status = "c" or rqm_status = "x" or
/*J39R*/              rqd_status = "c" or rqd_status = "x") then
/*J39R*/          do:
/*J39R*/             yn = no.
/*J39R*/             /* REQ AND/OR REQ LINE CLOSED OR CANCELLED - REOPEN? */
/*J39R*/             {mfmsg01.i 3327 1 yn}
/*J39R*/             if not yn then undo,retry.

/*J39R*/             if yn then do:
/*J39R*/                assign
/*J39R*/                   rqm_status  = ""
/*J39R*/                   rqm_open    = true
/*J39R*/                   rqd_status  = ""
/*J39R*/                   rqd_open    = true
/*J39R*/                   prev_status = rqd_status.
/*J39R*/             end. /* IF YN THEN */
/*J39R*/          end. /* IF NOT NEW_RQD and (RQD_PART ... */

/*J30R*/          if not new_rqd and
/*J3QK*/             rqd_type <> "M" and        /* NOT A MEMO ITEM */
/*J30R*/             (rqd_um <> prev_um or rqd_part <> prev_item) then do:
/*J30R*/             yn = true.
/*J39R** /*J30R*/    {mfmsg01.i 372 1 yn} */
/*J39R*/             run p_mfmsg01 (input 372, input 1, input-output yn).
/*J30R*/             /* CONVERT QTY FROM STOCK TO PURCHASE UNITS */
/*J30R*/             if yn = true then do:

/*J30R*/                {gprun.i ""gpumcnv.p"" "(input rqd_um,
                         input prev_um, input rqd_part,
                         output conversion_factor)"}

/*J30R*/                 if conversion_factor = ? then do:
/*J39R** /*J30R*/           {mfmsg.i 33 2}    */
/*J39R*/                    run p_ip_msg (input 33, input 2).
/*J30R*/                    /* NO UNIT OF MEASURE CONVERSION EXISTS */
/*J30R*/                 end.
/*J30R*/                 else do:
/*J30R*/                      rqd_um_conv = conversion_factor.
/*J30R*/                 end.

/*J30R*/                 rqd_req_qty = rqd_req_qty / rqd_um_conv.
/*J30R*/                 display
/*J30R*/                     rqd_req_qty
/*J30R*/                     with frame b.
/*J30R*/                 if sngl_ln then do:
/*J30R*/                    if rqd_um = pt_um then
/*J30R*/                       rqd_um_conv = 1.
/*J30R*/                    display rqd_um_conv with frame c.
/*J30R*/                    run display_st_qty.
/*J30R*/                 end. /* if sngl_ln */
/*J30R*/             end. /* if yn = true */
/*J30R*/         end. /* if not new _rqd */

/*J3QK**         if not new_rqd then do:        */
/*J3QK*/         if not new_rqd and rqd_type <> "M" then do:
                     yn = true.
/*J39R**             {mfmsg01.i 640 1 yn}   */
/*J39R*/             run p_mfmsg01 (input 640, input 1, input-output yn).
                     /* RECALCULATE ITEM PRICE AND COST */
                 end.

                 if yn or new_rqd then do:

                     find pt_mstr where pt_part = rqd_part no-lock no-error.

                     if available pt_mstr then do:
                        /** INITIAL DEFAULT FOR PRICE **/
/*L040*/                assign
                           vendor_part = ""
                           mfgr = ""
                           mfgr_part = ""
                           vendor = rqd_vend.
                        if rqd_vend = "" then vendor = rqm_vend.
                        got_vendor_price = false.

/*L040*/                /* THIS CALL IS MOVED FROM BELOW SO STD. COST IS    */
/*L040*/                /* FOUND ALL THE TIME AND IS AVAILABLE FOR DISPLAY. */
/*L040*/                /* USE glxcst TO HOLD GL COST   */
/*L040*/                {gprun.i ""gpsct05.p""
                          "(input rqd_part, input rqd_site, input 2,
                            output glxcst, output cur_cost)"}
/*L040*/                base_cost = glxcst * rqd_um_conv.

                        if vendor > "" then do:
                           /* GET FIELD VALS FROM VP_MSTR */

                           run retrieve_vendor_item_data
                              (input vendor,
                               input rqd_part,
                               output got_vendor_item_data,
                               output vendor_q_qty,
                               output vendor_q_um,
                               output vendor_q_curr,
                               output vendor_part,
                               output vendor_price,
                               output mfgr,
                               output mfgr_part).

/*J300*                    if got_vendor_item_data then do:     */
/*J300*/                   if got_vendor_item_data and vendor_price <> 0
/*J300*/                    then do:
                              if (vendor_q_curr = rqm_curr
                              or vendor_q_curr = "")
                              then do:
                                 /* CONVERT PRICE PER UM CONVERSION */

                                 if vendor_q_um = rqd_um then do:
                                    conversion_factor = 1.
                                 end.
                                 else do:
                                    {gprun.i ""gpumcnv.p""
                                      "(input vendor_q_um,
                                        input rqd_um, input rqd_part,
                                        output conversion_factor)"}
                                 end.

                                 if conversion_factor = ? then do:
/*J2VX*                             {mfmsg02.i 2086 2 vendor_part}      */
/*J2VX*/                            run display_message_mfmsg02
                                        (input 2086,
                                         input 2,
                                         input vendor_part).
                                    /* NO UM CONVERSION EXISTS FOR
                                     * SUPPLIER ITEM */
                                 end.
/*L040*/                         /* ONLY CONVERT TO THE VENDOR ITEM */
/*L040*/                         /* PRICE IF THE UM MATCHES AND THE */
/*L040*/                         /* RQ QTY IS >= THAN THE QUOTE QTY */
/*J30R** /*L040*/                if vendor_q_um = rqd_um            */
/*J30R** /*L040*/                and vendor_q_qty <= rqd_req_qty    */
/*L040*                          else do:                           */

/*J30R*/                         if vendor_q_um = rqd_um then do:
/*J30R*/                            if rqd_req_qty >= vendor_q_qty
/*L040*/                            then do:
/*L040*/                               assign
                                         rqd_pur_cost =
                                           vendor_price / conversion_factor
/*N174**                                 rqd_max_cost = rqd_pur_cost */
/*N174*/                                 rqd_max_cost =
/*N174*/                                    if rqd_disc_pct < 0
/*N174*/                                    then
/*N174*/                                       rqd_pur_cost * (1 - rqd_disc_pct
/*N174*/                                                         / 100)
/*N174*/                                    else
/*N174*/                                       rqd_pur_cost

                                         got_vendor_price = true.
                                    end.
                                 end.
/*J30R*/                         else do:
/*J30R*/                              req_qty =
/*J30R*/                                  rqd_req_qty / conversion_factor.
/*J30R*/                              if req_qty >= vendor_q_qty then do:
/*J30R*/                                 assign
/*J30R*/                                    rqd_pur_cost =
/*J30R*/                                      vendor_price / conversion_factor

/*N174** /*J30R*/                           rqd_max_cost = rqd_pur_cost */
/*N174*/                                    rqd_max_cost =
/*N174*/                                       if rqd_disc_pct < 0
/*N174*/                                       then
/*N174*/                                          rqd_pur_cost
/*N174*/                                             * (1 - rqd_disc_pct
/*N174*/                                                  / 100)
/*N174*/                                       else
/*N174*/                                          rqd_pur_cost

/*J30R*/                                    got_vendor_price = true.
/*J30R*/                               end. /* if req_qty qty >= */
/*J30R*/                          end. /* else do: */
/*J30R*/                      end.  /* if vendor_q_curr = rqm_curr or "" */
                              else do:
/*J2VX*                          {mfmsg02.i 2109 2 vendor_q_curr}       */
/*J2VX*/                         run display_message_mfmsg02
                                    (input 2109,
                                    input 2,
                                    input vendor_q_curr).
                                 /* SUPPLIER ITEM NOT FOR SAME CURRENCY */
                              end.
                           end.
                        end.

                        if not got_vendor_price then do:
                           /* DIDN'T FIND A VENDOR PART PRICE, USE STD COST */

/*L040*/                   /* THIS CALL IS MOVED ABOVE, OUT OF THE 'IF' */
/*L040*/                   /* STATEMENT.                                */
/*L040*                    {gprun.i ""gpsct05.p""
 *                         "(input rqd_part, input rqd_site, input 2,
 *                         output rqd_pur_cost, output cur_cost)"}
 *L040*/

/*L040*/                   /* NOTE:  THIS WAS CHANGED TO CONVERT glxcst  */
/*L040*/                   /* INSTEAD OF rqd_pur_cost PER ECO J2V6       */
/*L040*/                   /* WHICH HAS BEEN PROPOGATED TO  8.6E BY L040 */
/*L040*                    rqd_pur_cost = rqd_pur_cost * rqm_ex_rate. */
/*L040*/                   /* CONVERT FROM BASE TO FOREIGN CURRENCY */
/*L040*/                   {gprunp.i "mcpl" "p" "mc-curr-conv"
                             "(input base_curr,
                               input rqm_curr,
                               input rqm_ex_rate2,
                               input rqm_ex_rate,
                               input glxcst,
                               input false, /* DO NOT ROUND */
                               output rqd_pur_cost,
                               output mc-error-number)"}.

/*N174**                   rqd_max_cost = rqd_pur_cost. */
/*N174*/                   rqd_max_cost =
/*N174*/                      if rqd_disc_pct < 0
/*N174*/                      then
/*N174*/                         rqd_pur_cost * (1 - rqd_disc_pct
/*N174*/                                           / 100)
/*N174*/                      else
/*N174*/                         rqd_pur_cost.

                           /* CONVERT PRICE PER UM CONVERSION */

                           if pt_um = rqd_um then do:
                              conversion_factor = 1.
                           end.
                           else do:
                              {gprun.i ""gpumcnv.p"" "(input rqd_um,
                                input pt_um, input rqd_part,
                                output conversion_factor)"}
                           end.

                           if conversion_factor = ? then do:
/*J2VX*                       {mfmsg02.i 33 2 rqd_um}           */
/*J2VX*/                      run display_message_mfmsg02
                                (input 33,
                                 input 2,
                                 input rqd_um).
                              /* NO UM CONVERSION EXISTS */
                           end.
                           else do:
/*J39R*/                      assign
                              rqd_pur_cost = rqd_pur_cost * conversion_factor

/*N174**                      rqd_max_cost = rqd_pur_cost. */
/*N174*/                      rqd_max_cost =
/*N174*/                         if rqd_disc_pct < 0
/*N174*/                         then
/*N174*/                            rqd_pur_cost * (1 - rqd_disc_pct
/*N174*/                                              / 100)
/*N174*/                         else
/*N174*/                            rqd_pur_cost.

                           end.
                        end.
                     end.  /* if available pt_mstr */
/*J300*/             else do:
/*J300*/
/*J300*/                /*RESET COST FIELDS*/
/*J300*/
/*J300*/                assign
/*J300*/                    rqd_pur_cost = 0
/*J300*/                    rqd_max_cost = 0.
/*J30R*/                if sngl_ln then
/*J300*/                  display
/*J300*/                    rqd_max_cost
/*J300*/                    with frame c.
/*J300*/             end.

                     /* INITIAL DEFAULT FOR DISCOUNT */
/*J39R*/             assign
/*N174*/             l_rqd_disc_pct = rqd_disc_pct
                     rqd_disc_pct = rqm_disc_pct

                     /* GET PRICE FROM PRICE TABLES IF THERE IS ONE */

                     net_price = rqd_pur_cost * (1 - rqd_disc_pct / 100)

                     lineffdate = rqd_due_date.
                     if lineffdate = ? then lineffdate = rqm_req_date.
                     if lineffdate = ? then lineffdate = today.

                     if rqd_pr_list2 <> "" then do:
                        net_price = ?.
/*L16L*/                /* CHANGED 7TH PARAMETER FROM new_rqd TO true */
                        {gprun.i ""gppclst.p""
                          "(input      rqd_pr_list2,
                            input        rqd_part,
                            input        rqd_um,
                            input        rqd_um_conv,
                            input        lineffdate,
                            input        rqm_curr,
                            input        true,
                            input        poc_pt_req,
                            input-output rqd_pur_cost,
                            input-output net_price,
                            output       minprice,
                            output       maxprice,
                            output       pc_recno)" }

                        if net_price <> ? then
                           net_price = net_price * (1 - rqd_disc_pct / 100).
                     end.

                     if poc_pt_req and (rqd_pr_list2 = "" or pc_recno = 0)
                     then do:
                        {mfmsg03.i 6231 3 rqd_part rqd_um """"}
                        /* REQUIRED PRICE TABLE FOR ITEM # IN UM # NOT FOUND */
                        undo, retry.
                     end.

                     /* GET DISCOUNT FROM DISCOUNT TABLES IF THERE IS ONE */

                     if rqd_pr_list <> "" then do:
                        {gprun.i ""gppccal.p""
                          "(input      rqd_part,
                            input        rqd_req_qty,
                            input        rqd_um,
                            input        rqd_um_conv,
                            input        rqm_curr,
                            input        rqd_pr_list,
                            input        lineffdate,
                            input        rqd_pur_cost,
                            input        poc_pl_req,
                            input        rqm_disc_pct,
                            input-output rqd_pur_cost,
                            output       rqd_disc_pct,
                            input-output net_price,
                            output       pc_recno)" }
                     end.

                     if poc_pl_req
                     and (rqd_pr_list = "" or pc_recno = 0) then do:
                        {mfmsg03.i 982 3 rqd_part rqd_um """"}
                        /* REQUIRED DISCOUNT TABLE FOR ITEM # IN */
                        /* UM # NOT FOUND */
                        undo, retry.
                     end.

/*J2VX*/             /*SET UNIT COST TO NET PRICE*/

/*J2VX*/             /*Unit cost is set to net price when there is no       */
/*J2VX*/             /*standard cost on the item but the req. refers        */
/*J2VX*/             /*to a price table or discount table.  The disc% is    */
/*J2VX*/             /*returned as 0.00 since it is based on the unit cost. */
/*J2VX*/             /*The net price is passed back from the sub-programs   */
/*J2VX*/             /*and plugged into the unit cost field to show the     */
/*J2VX*/             /*discounted price.                                    */

/*J2VX*/             if rqd_pur_cost = 0 and net_price <> ? then
/*J2VX*/                rqd_pur_cost = net_price.

                     /* DISPLAY PRICE, DISC%, EXT PRICES */

/*M0PY** BEGIN DELETE
 *                   display
 *                      rqd_pur_cost
 *                      rqd_disc_pct
 *                   with frame b.
 *M0PY** END DELETE */

/*N174*/                rqd_max_cost =
/*N174*/                   if rqd_disc_pct < 0
/*N174*/                   then
/*N174*/                      rqd_pur_cost * (1 - rqd_disc_pct
/*N174*/                                        / 100)
/*N174*/                   else
/*N174*/                      rqd_pur_cost.

/*M0PY*/             run display_line_frame_b.

                     if sngl_ln then do:
                        run display_ext_cost.
                        run display_max_ext_cost.
                     end.
                  end.
               end.

/*L040*/       if (new_rqd or rqd_part <> prev_item or rqd_um <> prev_um) and
/*L040*/          rqm_curr <> base_curr and rqd_pur_cost <> 0 then do:
/*L040*/             {mfmsg02.i 684 1
                      "base_cost, "">>>>,>>>,>>9.99<<<"" "}
                      /* Base currency list price: 19.99 */
/*L040*/       end.

               /* GET PRICE, DISCOUNT% FROM USER */

               ststatus = stline[3].
               status input ststatus.

               do on error undo, retry:

/*M0PY*/          l_actual_disc = rqd_disc_pct.
/*M0PY*/          if rqd_disc_pct < l_min_disc or
/*M0PY*/             rqd_disc_pct > l_max_disc then
/*M0PY*/          do:
/*M0PY*/             if rqd_disc_pct >  l_max_disc then
/*M0PY*/                rqd_disc_pct =  l_max_disc.
/*M0PY*/             if rqd_disc_pct < l_min_disc then
/*M0PY*/                rqd_disc_pct = l_min_disc.
/*M0PY*/             /* DISCOUNT # CANNOT BE FIT IN THE FORMAT, DISPLAYED */
/*M0PY*/             /* AS ALL 9'S                                        */
/*M0PY*/             {mfmsg03.i 1651 2 l_actual_disc """" """"}.
/*M0PY*/          end. /* IF RQD_DISC_PCT < L_MIN_DISC... */

/*N174*/          l_rqd_disc_pct = rqd_disc_pct.
                  set rqd_pur_cost rqd_disc_pct with frame b.

/*M0PY*/          if not rqd_disc_pct entered
/*M0PY*/             then rqd_disc_pct = l_actual_disc.

                  if rqd_pr_list2 > "" then do:
                     net_price = rqd_pur_cost * (1 - rqd_disc_pct / 100).

                     {gprun.i ""gpmnmx.p""
                       "(input      false,
                         input        true,
                         input        minprice,
                         input        maxprice,
                         output       minmaxerr,
                         input-output rqd_pur_cost,
                         input-output net_price,
                         input        rqd_part)" }

                     if minmaxerr then undo, retry.
                     display rqd_pur_cost with frame b.
                  end.
               end.
/*M0TH*/       if rqd_req_qty  =  prev_qty      and
/*M0TH*/          rqd_part     =  prev_item     and
/*M0TH*/          rqd_um       =  prev_um       and
/*N174** /*M0TH*/ l_rqd_cost   <> rqd_pur_cost  and */
/*N174*/          (l_rqd_cost   <> rqd_pur_cost
/*N174*/          or (l_rqd_disc_pct <> rqd_disc_pct
/*N174*/          and not (l_rqd_disc_pct >= 0
/*N174*/          and rqd_disc_pct >= 0))) and
/*M0TH*/          not new_rqd
/*M0TH*/       then do:
/*M0TH*/          l_flag = yes.
								  if not batchrun then do:
/*M0TH*/             {mfmsg01.i 4389 1 l_flag}
							    end.
/*M0TH*/          /* UNIT COST HAS CHANGED, UPDATE MAXIMUM UNIT COST (Y/N) */
/*M0TH*/       end. /* IF NOT new_rqd */
               if new_rqd
/*L040*/          or rqd_part    <> prev_item
/*L040*/          or rqd_um      <> prev_um
/*L040*/          or rqd_req_qty <> prev_qty
/*M0TH*/          or l_flag
               then do:
/*N174**          rqd_max_cost = rqd_pur_cost. */
/*N174*/          rqd_max_cost =
/*N174*/             if rqd_disc_pct < 0
/*N174*/             then
/*N174*/                rqd_pur_cost * (1 - rqd_disc_pct
/*N174*/                                  / 100)
/*N174*/             else
/*N174*/                rqd_pur_cost.

               end.

               if sngl_ln then do:
                  /* GET REST OF STUFF FROM USER */

                  run display_line_frame_c.

                  find pt_mstr where pt_part = rqd_part no-lock no-error.
                  serial_controlled = available pt_mstr and pt_lot_ser = "s".

                  do on error undo, retry:
                     set
                        rqd_due_date
                        rqd_need_date
                        rqd_type
/*J300*                 rqd_category                            */
/*J300*/                rqd_category    when (not rqm_direct and not batchrun)
                        rqd_acct
                        rqd_project
                        rqd_vpart
                        desc1 when (not can-find(pt_mstr
                                    where pt_part = rqd_part) and not batchrun)
                        rqd_lot_rcpt   when (not serial_controlled  and not batchrun)
                        rqd_rev
/*J300*                 rqd_um_conv    when (new_rqd)           */
/*J300*/                rqd_um_conv    when ((new_rqd or rqd_part <> prev_item) and not batchrun)
                        rqd_max_cost
                        rqd_status
                        line_cmmts
                     with frame c.

                     /* CHECK DUE DATE */

                     if rqd_due_date = ? then do:
/*J39R**                {mfmsg.i 27 3} */
/*J39R*/                run p_ip_msg (input 27, input 3).
                        /* INVALID DATE */
                        next-prompt rqd_due_date with frame c.
                        undo, retry.
                     end.

                     /* CHECK NEED DATE */

                     if rqd_need_date = ? then do:
/*J39R**                {mfmsg.i 27 3}      */
/*J39R*/                run p_ip_msg (input 27, input 3).
                        /* INVALID DATE */
                        next-prompt rqd_need_date with frame c.
                        undo, retry.
                     end.

                     /* CHECK TYPE */

                     if not can-find(pt_mstr where pt_part = rqd_part)
                     and rqd_type <> "M"
                     then do:
/*J39R**                {mfmsg.i 715 3}     */
/*J39R*/                run p_ip_msg (input 715, input 3).
                        /* ITEM DOES NOT EXIST AT THIS SITE */
                        next-prompt rqd_type with frame c.
                        undo, retry.
                     end.

                     /* CHECK CATEGORY */

                     if rqd_category > "" then do:
                        find rqc_mstr where rqc_category = rqd_category
                        no-lock no-error.

                        if not available rqc_mstr then do:
/*J39R**                   {mfmsg.i 2064 3}  */
/*J39R*/                   run p_ip_msg (input 2064, input 3).
                           /* INVALID CATEGORY */
                           next-prompt rqd_category with frame c.
                           undo, retry.
                        end.
                     end.

                     /* CHECK MAX COST */

                     if rqd_max_cost < rqd_pur_cost then do:
/*J39R**                {mfmsg.i 2062 3}    */
/*J39R*/                run p_ip_msg (input 2062, input 3).
                        /* MAX COST MAY NOT BE LESS THAN PURCHASE COST */
                        next-prompt rqd_max_cost with frame c.
                        undo, retry.
                     end.

                     /* CHECK STATUS */

/*J39R**             if rqd_status <> "" and rqd_status <> "x" then do: */
/*J39R*/             if rqd_status <> ""  and
/*J39R*/                rqd_status <> "c" and
/*J39R*/                rqd_status <> "x" then
/*J39R*/             do:
/*J39R**                {mfmsg.i 19 3}  */
/*J39R*/                run p_ip_msg (input 19, input 3).
                        /* INVALID STATUS */
                        next-prompt rqd_status with frame c.
                        undo, retry.
                     end.

                     if prev_status = "" and rqd_status = "x" then do:
                        /* IF THERE IS A PO REFERENCING, DON'T ALLOW CANCEL */

                        find first rqpo_ref where rqpo_req_nbr = rqd_nbr
                        and rqpo_req_line = rqd_line
                        no-lock no-error.

                        if available rqpo_ref then do:
/*J39R**                   {mfmsg.i 2053 3}   */
/*J39R*/                   run p_ip_msg (input 2053, input 3).
                           /* ORDER HAS BEEN PLACED */
                           next-prompt rqd_status with frame c.
                           undo, retry.
                        end.
                     end.

                     if prev_status = "x" and rqd_status = "" then do:
                        yn = false.
/*J39R**                {mfmsg01.i 2183 1 yn}  */
/*J39R*/                run p_mfmsg01 (input 2183, input 1, input-output yn).
                        /* REQ OR REQ LINE CANCELLED - REOPEN? */

                        if not yn then do:
                           next-prompt rqd_status with frame c.
                           undo, retry.
                        end.

                        find rqm_mstr
                        where recid(rqm_mstr) = p_rqm_recid
                        exclusive-lock.

                        rqm_status = "".
                     end.

/*J39R*/             /* USER CLOSING THE STATUS MANUALLY */
/*J39R*/             if prev_status = "" and
/*J39R*/                rqd_status  = "c" then
/*J39R*/             do:
/*J39R*/                run p_close_req (input recid(rqm_mstr)).
/*J39R*/             end.  /* IF PREV_STATUS = "" AND ... */

/*J39R*/             /* USER OPENING THE STATUS MANUALLY */
/*J39R*/             if prev_status = "c" and
/*J39R*/                rqd_status  = "" then
/*J39R*/             do:
/*J39R*/                yn = no.
/*J39R*/               /* REQ AND/OR REQ LINE CLOSED OR CANCELLED - REOPEN? */
/*J39R*/                run p_mfmsg01 (input 3327, input 1, input-output yn).

/*J39R*/                if not yn then do:
/*J39R*/                   next-prompt rqd_status with frame c.
/*J39R*/                   undo, retry.
/*J39R*/                end. /* IF NOT YN */
/*J39R*/                else do:
/*J39R*/                   run p_open_req (input recid(rqm_mstr)).
/*J39R*/                end. /* ELSE DO */
/*J39R*/             end.   /* IF PREV_STATUS = "C" ... */

                     /* CHECK PROJECT */

                     do with frame c:
                        if not ({gpglproj.v rqd_project}) then do:
/*J39R**                   {mfmsg.i 3128 3} */
/*J39R*/                   run p_ip_msg (input 3128, input 3).
                           /* INVALID PROJECT */
                           next-prompt rqd_project with frame c.
                           undo, retry.
                        end.
                     end.

/*N014* - BEGIN DELETE
 * /*J396*/             rqd_acct = rqd_acct + "       ".
 * /*J396*/             temp_acct = substr(rqd_acct, 1, (8 - gl_sub_len)).
 * /*J396*/
 * /*J396*/             /*PUT SUBACCOUNT INTO ACCOUNT*/
 * /*J396*/
 * /*J396*/           if rqd_acct <> "" and  rqd_acct <> prev_acct and
 * /*J396*/                rqm_sub > "" and gl_sub_len > 0 then do:
 * /*J396*/                    rqd_acct =
 * /*J396*/                    substr(rqd_acct, 1, (8 - gl_sub_len)) + rqm_sub.
 * /*J396*/            end.
 * /*J3HV*/           /* FOR ORACLE ENVIRONMENT, ENSURING THAT THERE ARE NO   */
 * /*J3HV*/           /* TRAILING SPACES                                      */
 * /*J3HV*/            temp_acct = trim(temp_acct).
 *N014* - END DELETE */

                     /* CHECK GL ACCOUNT/COST CENTER */

                     /* GPGLVERO.P RETURNS A LIST OF MESSAGE NUMBERS;
                      * THEY ARE DISPLAYED AS WARNINGS.  THEY WILL BE
                      * RE-CHECKED WHEN FINAL APPROVAL IS ATTEMPTED.
                      * ALL ACCTS MUST BE VALID IN ORDER FOR FINAL APPROVAL */

/*J2QB*/             /* CHANGED RQD_CC TO RQM_CC IN FOLLOWING*/
/*N014* - BEGIN DELETE
 *                   {gprun.i ""gpglvero.p"" "(input rqd_acct, input ?,
 *                     input rqm_cc, output messages, output msglevels)"}
 *N014* - END DELETE */
/*N014* - BEGIN REPLACE OLD VALIDATION CALL WITH NEW CALLS */
                     {gprunp.i "gpglvpl" "p" "initialize"}
                     {gprunp.i "gpglvpl" "p" "set_disp_msgs" "(input false)"}
                     {gprunp.i "gpglvpl" "p" "validate_fullcode"
                         "(input rqd_acct,
                         input rqm_sub,
                         input rqm_cc,
                         input rqd_project,
                         output valid_acct)"}
                     {gprunp.i "gpglvpl" "p" "get_msgs"
                         "(output messages, output msglevels)"}
/*N014* - END REPLACE OLD VALIDATION CALL WITH NEW CALLS */

                     do i = 1 to num-entries(messages):
                        msgnbr = integer(entry(i,messages)).
/*J39R**                {mfmsg.i msgnbr 2}   */
/*J39R*/                run p_ip_msg (input msgnbr, input 2).
/*J3FW*/                if line_cmmts and not batchrun then
/*J3FW*/                   pause.
                     end.
/*J396**
 * /*J300*/             temp_acct = substr(rqd_acct, 1, (8 - gl_sub_len)).
 * /*J300*/
 * /*J300*/             /*PUT SUBACCOUNT INTO ACCOUNT*/
 * /*J300*/
 * /*J300*/           if rqd_acct <> "" and
 * /*J300*/                rqm_sub > "" and gl_sub_len > 0 then do:
 * /*J300*/                    rqd_acct =
 * /*J300*/                    substr(rqd_acct, 1, (8 - gl_sub_len)) + rqm_sub.
 * /*J300*/             end.
 *J396**/

/*J300*/             /*DEFAULT CATEGORY*/

/*N014* - BEGIN DELETE
 * /*J3HV** /*J30R*/    if rqd_category = "" then */
 * /*J3HV*/             if rqd_category = "" or rqd_acct <> prev_acct then
 * /*J300*/               run get_default_category
 *                      (input rqm_direct,
 *                       input temp_acct,
 *                       input rqd_acct,
 *                       output rqd_category).
 *N014* - END DELETE */
/*N014* - BEGIN ADD */
                     if rqd_category = "" then
                       run get_default_category
                        (input rqm_direct,
                         input rqd_acct,
                         input rqm_sub,
                         output rqd_category).
/*N014* - END ADD */

/*J300*/
/*J300*/             display
/*J300*/                rqd_category
/*J300*/                rqd_acct
/*J300*/                with frame c.

/*J396*/           /* RE-INSTATING CODE THAT WAS COMMENTED OUT BY J300 BELOW */

/*J396**
 * /*J300*/     /*CHECKS FOR CATEGORY, ACCT, AND SUBACCT ARE NOT NEEDED  */
 * /*J300*/        /*SINCE THE FIELDS WILL BE RE-POPULATED ABOVE.           */
 *
 * /*J300*              /*CHECK IF CATEGORY IS FOR ACCT*/
 *
 *                   if rqd_category > "" then do:
 *                      find last rqcd_det
 *                      where rqcd_category = rqd_category
 *                      and rqcd_acct_from <= rqd_acct
 *                      and rqcd_acct_to >= rqd_acct
 *                      no-lock no-error.
 *
 *                      if not available rqcd_det then do:
 *                         {mfmsg.i 2076 2}
 *                         /*ACCOUNT NOT DEFINED FOR CATEGORY*/
 *                      end.
 *                   end.
 *
 *
 *
 *                   /*CHECK IF SUBACCT MATCHES HEADER SUBACCT*/
 *
 *                   if rqm_sub > "" and gl_sub_len > 0 then do:
 *                      if substr(rqd_acct, 9 - gl_sub_len) <> rqm_sub then do:
 *                         {mfmsg.i 2085 2}
 *                         /*LINE SUB-ACCT DOES NOT MATCH HEADER SUB-ACCT*/
 *                      end.
 *                   end.
 * *J300*/
 *J396**/

/*J396*/             /*CHECK IF CATEGORY IS FOR ACCT*/

/*J396*/             if rqd_category > "" then do:
/*J396*/                find last rqcd_det
/*J396*/                where rqcd_category = rqd_category
/*J396*/                and rqcd_acct_from <= rqd_acct
/*J396*/                and rqcd_acct_to >= rqd_acct
/*N014*/                and rqcd_sub_from <= rqm_sub
/*N014*/                and rqcd_sub_to >= rqm_sub
/*J396*/                no-lock no-error.

/*J396*/                if not available rqcd_det then do:

/*J396*/                   for last rqcd_det where
/*J396*/                            rqcd_category = rqd_category  and
/*N014* - BEGIN DELETE
 * /*J396*/                            rqcd_acct_from <= temp_acct   and
 * /*J396*/                            rqcd_acct_to >= temp_acct
 *N014* - END DELETE */
 /*N014*/                            rqcd_acct_from <= rqd_acct   and
 /*N014*/                            rqcd_acct_to >= rqd_acct
/*J396*/                            no-lock: end.

/*J396*/                     if not available rqcd_det then do:
/*J39R** /*J396*/              {mfmsg.i 2076 2} */
/*J39R*/                        run p_ip_msg (input 2076, input 2).
/*J396*/                       /*ACCOUNT NOT DEFINED FOR CATEGORY*/
/*J396*/                     end. /* if not available rqcd_det */
/*J396*/                end. /* if not available rqcd_det */
/*J396*/             end. /* if rqd_category > "" */

                  end.

                  display rqd_um_conv with frame c.

                  run display_st_qty.
                  run display_ext_cost.
                  run display_max_ext_cost.
                  rqd_desc = desc1.
               end.

               if rqd_due_date = ? then rqd_due_date = today.
               if rqd_need_date = ? then rqd_need_date = rqd_due_date.

               if sngl_ln then do:
                  display
                     rqd_due_date
                     rqd_need_date
                  with frame c.
               end.

               assign
                  global_type = ""
                  global_lang = rqm_lang.

               if line_cmmts then do:
                  hide frame c no-pause.
                  hide frame b no-pause.
                  hide frame a no-pause.

                  global_ref = rqd_part.

                  if rqd_cmtindx = -1 then cmtindx = 0.
                  else cmtindx = rqd_cmtindx.

                  {gprun.i ""gpcmmt01.p"" "(input ""pod_det"")"}

                  rqd_cmtindx = cmtindx.
                  view frame a.
                  view frame b.
                  if sngl_ln then view frame c.
               end.

               if rqd_cmtindx = -1 then rqd_cmtindx = 0.

               if not sngl_ln then down 1 with frame b.
               line = line + 1.

               /* UPDATE MRP */

               {gprun.i ""rqmrw.p""
                 "(input false, input rqd_site, input rqd_nbr, input rqd_line)"}

               /* CALCULATE NEW EXT COSTS */
/*J39R*/       assign
               ext_cost = rqd_req_qty * rqd_pur_cost
                          * (1 - (rqd_disc_pct / 100))

/*N174**       max_ext_cost = rqd_req_qty * rqd_max_cost    */
/*N174**                      * (1 - (rqd_disc_pct / 100)). */
/*N174*/       max_ext_cost = rqd_req_qty * rqd_max_cost.

               if rqd_status = "x" then do:
/*J39R*/          assign
                  ext_cost = 0
                  max_ext_cost = 0.
               end.

               /* SET LINE STATUS */

               rqd_aprv_stat = APPROVAL_STATUS_UNAPPROVED.

               /* UPDATE REQUISITION TOTALS */

               find rqm_mstr where recid(rqm_mstr) = p_rqm_recid exclusive-lock.
/*J39R*/       assign
               rqm_total = rqm_total + ext_cost - prev_ext_cost
               rqm_max_total = rqm_max_total + max_ext_cost - prev_max_ext_cost.

               /* WRITE HISTORY RECORD */

               if new_rqd then action_entry = ACTION_CREATE_REQ_LINE.
               else action_entry = ACTION_MODIFY_REQ_LINE.

               {gprun.i ""rqwrthst.p""
                 "(input rqm_nbr,
                   input rqd_line,
                   input action_entry,
                   input userid_modifying,
                   input '',
                   input '')"}

               release rqd_det.
            end. /*LINELOOP: repeat transaction*/

            if sngl_ln then hide frame c no-pause.
            hide frame b no-pause.

            do on endkey undo, leave mainloop:
               update sngl_ln with frame a.
            end.
         end. /*MAINLOOP*/

         hide frame a no-pause.

         /******************************************************/
         /******************************************************/
         /**                 PROCEDURES                       **/
         /******************************************************/
         /******************************************************/

         PROCEDURE initialize_frame_b:
            find rqm_mstr where recid(rqm_mstr) = rqm_recid no-lock.

            display
               line
               rqm_site @ rqd_site
               "" @ rqd_part
               rqm_vend @ rqd_vend
               0 @ rqd_req_qty
               "" @ rqd_um
               0 @ rqd_pur_cost
               rqm_disc_pct @ rqd_disc_pct
            with frame b.
         END PROCEDURE.

         PROCEDURE initialize_frame_c:
            find rqm_mstr where recid(rqm_mstr) = rqm_recid no-lock.

            display
               "" @ rqd_due_date
               "" @ rqd_need_date
               "" @ rqd_type
               "" @ rqd_category
               "" @ rqd_acct
               "" @ rqd_project
               "" @ rqd_vpart
               "" @ mfgr
               "" @ mfgr_part
               "" @ desc1
               "" @ desc2
               "" @ rqd_lot_rcpt
               "" @ rqd_rev
/*N014*/       "" @ rqm_sub
/*J2QB*        "" @ rqd_cc */
/*J2QB*/       "" @ rqm_cc
               "" @ rqd_um_conv
               0 @ st_qty
               0 @ tot_qty_ord
               0 @ rqd_max_cost
               0 @ ext_cost
               0 @ max_ext_cost
               "" @ rqd_status
               "" @ rqd_aprv_stat
               "" @ line_cmmts
            with frame c.
         END PROCEDURE.

         PROCEDURE display_line_frame_b:
            find rqd_det where recid(rqd_det) = rqd_recid exclusive-lock.

/*M0PY*/    if rqd_disc_pct >  l_max_disc then
/*M0PY*/       l_display_disc =  l_max_disc.
/*M0PY*/    else
/*M0PY*/    if rqd_disc_pct < l_min_disc then
/*M0PY*/       l_display_disc = l_min_disc.
/*M0PY*/    else
/*M0PY*/       l_display_disc = rqd_disc_pct.

            line = rqd_line.

            display
               line
               rqd_site
               rqd_part
               rqd_vend
               rqd_req_qty
               rqd_um
               rqd_pur_cost
/*M0PY**       rqd_disc_pct */
/*M0PY*/       l_display_disc @ rqd_disc_pct
            with frame b.
         END PROCEDURE.

         PROCEDURE display_line_frame_c:
            find rqd_det where recid(rqd_det) = rqd_recid no-lock.
            find rqm_mstr where recid(rqm_mstr) = rqm_recid no-lock.

            assign
               line_cmmts = rqd_cmtindx <> 0
               desc1 = not_in_inventory_msg
               desc2 = "".

            find pt_mstr where pt_part = rqd_part no-lock no-error.

            if available pt_mstr then do:
               assign
                  desc1 = pt_desc1
                  desc2 = pt_desc2.
            end.
            else
            if rqd_desc <> "" then do:
               assign
                  desc1 = rqd_desc
                  desc2 = "".
            end.

            global_part = rqd_part.

            /* CALCULATE QTY ALREADY ORDERED ON PO'S */

            tot_qty_ord = 0.
            for each rqpo_ref no-lock
            where rqpo_req_nbr = rqd_nbr and rqpo_req_line = rqd_line:
               tot_qty_ord = tot_qty_ord + rqpo_qty_ord.
            end.

            /* GET MFGR, MFGR PART FROM VP_MSTR */

/*M1DQ*/    assign
               mfgr      = ""
               mfgr_part = ""
/*M1DQ*/       vendor    = if rqd_vend = ""
/*M1DQ*/                   then
/*M1DQ*/                      rqm_vend
/*M1DQ*/                   else
/*M1DQ*/                      rqd_vend.

            if rqd_vpart <> "" then do:
               find first vp_mstr
                  where vp_part      = rqd_part
                  and   vp_vend_part = rqd_vpart
/*M1DQ**          and   vp_vend      = rqd_vend */
/*M1DQ*/          and   vp_vend      = vendor
            no-lock no-error.

               if available vp_mstr then do:
                  mfgr = vp_mfgr.
                  mfgr_part = vp_mfgr_part.
               end.
            end.

            /* GET TEXT OF APPROVAL STATUS */

            {gplngn2a.i
              &file=""rqm_mstr""
              &field=""rqm_aprv_stat""
              &code=rqd_aprv_stat
              &mnemonic=approval_stat_entry
              &label=approval_stat_desc}

            display
               rqd_due_date
               rqd_need_date
               rqd_type
               rqd_category
               rqd_acct
/*N014*/       rqm_sub
/*J2QB*        rqd_cc */
/*J2QB*/       rqm_cc
               rqd_project
               rqd_vpart
               mfgr
               mfgr_part
               desc1
               desc2
               rqd_lot_rcpt
               rqd_rev
/*J2QB*        rqd_cc */
               rqd_um_conv
               tot_qty_ord
               rqd_max_cost
               rqd_status
               line_cmmts
               approval_stat_desc @ rqd_aprv_stat
            with frame c.

            run display_st_qty.
            run display_ext_cost.
            run display_max_ext_cost.
         END PROCEDURE.

         PROCEDURE get_site:
            find rqd_det where recid(rqd_det) = rqd_recid exclusive-lock.
            find rqm_mstr where recid(rqm_mstr) = rqm_recid no-lock.

            continue = false.

            do on error undo, retry:
               set rqd_site with frame b editing:
                  {mfnp.i si_mstr rqd_site si_site rqd_site si_site si_site}

                  if recno <> ? then do:
                     display si_site @ rqd_site with frame b.
                  end.
               end.

               find si_mstr where si_site = rqd_site no-lock no-error.

               if not available si_mstr then do:
/*J39R**          {mfmsg.i 708 3}     */
/*J39R*/          run p_ip_msg (input 708, input 3).
                  /* SITE DOES NOT EXIST */
                  next-prompt rqd_site with frame b.
                  undo, retry.
               end.

               if si_db <> global_db then do:
/*J39R**          {mfmsg.i 5421 3} */
/*J39R*/           run p_ip_msg (input 5421, input 3).
                  /* SITE IS NOT ASSIGNED TO THIS DATABASE */
                  next-prompt rqd_site with frame b.
                  undo, retry.
               end.

               if si_entity <> rqm_entity then do:
/*J39R**          {mfmsg.i 2107 3}      */
/*J39R*/          run p_ip_msg (input 2107, input 3).
                  /* SITE ENTITY DOES NOT MATCH REQUISITION ENTITY */
                  next-prompt rqd_site with frame b.
                  undo, retry.
               end.

               if not new_rqd and rqd_site <> prev_site then do:
                  find first rqpo_ref
                  where rqpo_req_nbr = rqd_nbr
                  and rqpo_req_line = rqd_line
                  no-lock no-error.

                  if available rqpo_ref then do:
/*J39R**             {mfmsg.i 2114 3} */
/*J39R*/             run p_ip_msg (input 2114, input 3).
                     /* REQUISITION LINE REFERENCED BY PO, CHANGE NOT ALLOWED */
                     next-prompt rqd_site with frame b.
                     undo, retry.
                  end.
               end.

               continue = true.
            end.
         END PROCEDURE.

         PROCEDURE get_item:
            define variable ptstatus as character.

            find rqd_det where recid(rqd_det) = rqd_recid exclusive-lock.
            find rqm_mstr where recid(rqm_mstr) = rqm_recid no-lock.

            continue = false.

            do on error undo, retry:
               set rqd_part with frame b editing:
                  {mfnp.i pt_mstr rqd_part pt_part rqd_part pt_part pt_part}

                  if recno <> ? then do:
/*L040*/             display_um = rqd_um.
/*L040*/             if display_um = ""  then
/*L040*/                display_um = pt_um.

/*L040*/             /* FIND UNIT COST FOR EACH NEXT/PREVIOUS */
/*L040*/             run get_pur_cost
                        (input pt_part,
                         input rqd_vend,
                         input rqd_site,
                         input rqm_curr,
                         input rqd_req_qty,
                         input display_um,
                         input rqm_ex_rate,
                         input rqm_ex_rate2,
                         output rqd_pur_cost,
                         output base_cost).

                     display
                        pt_part @ rqd_part
/*L040*                 pt_um @ rqd_um */
/*L040*/                display_um @ rqd_um
/*L040*/                rqd_pur_cost
                     with frame b.

                     if sngl_ln then do:
                        display
                           1 @ rqd_um_conv
                           pt_desc1 @ desc1
                           pt_desc2 @ desc2
                        with frame c.
                     end.
                  end.
               end.

               if rqd_part = "" then do:
/*J39R**          {mfmsg.i 40 3}   */
/*J39R*/          run p_ip_msg (input 40, input 3).
                  /* BLANK NOT ALLOWED */
                  next-prompt rqd_part with frame b.
                  undo, retry.
               end.

               find pt_mstr where pt_part = rqd_part no-lock no-error.

               if not available pt_mstr then do:
/*J39R**          {mfmsg.i 16 2}   */
/*J39R*/          run p_ip_msg (input 16, input 2).
                  /* ITEM NUMBER DOES NOT EXIST */
               end.

               if available pt_mstr then do:
/*J30R*/          /* SET STOCKING UM TO THE PART UM IF VALID PART */
/*J30R*/          assign
/*J30R*/            st_um = pt_um
                    ptstatus = pt_status.
                  substring(ptstatus,9,1) = "#".

                  if can-find(isd_det where isd_status = ptstatus
                  and isd_tr_type = "ADD-PO") then do:
/*J2VX*              {mfmsg02.i 358 3 pt_status}                */
/*J2VX*/             run display_message_mfmsg02
                        (input 358,
                         input 3,
                         input pt_status).
                     /* RESTRICTED PROCEDURE FOR ITEM STATUS CODE */
                     undo, retry.
                  end.
               end.

               if not new_rqd and rqd_part <> prev_item then do:
                  find first rqpo_ref
                  where rqpo_req_nbr = rqd_nbr
                  and rqpo_req_line = rqd_line
                  no-lock no-error.

                  if available rqpo_ref then do:
/*J39R**             {mfmsg.i 2114 3}   */
/*J39R*/             run p_ip_msg (input 2114, input 3).
                     /* REQUISITION LINE REFERENCED BY PO, CHANGE NOT ALLOWED */
                     next-prompt rqd_part with frame b.
                     undo, retry.
                  end.
               end.

/*L040*/       if available (pt_mstr) and rqd_pur_cost = 0 then do:
/*L040*/          display_um = rqd_um.
/*L040*/          if display_um = ""  then
/*L040*/             display_um = pt_um.

/*L040*/          /* FIND UNIT COST FOR THE PART */
/*L040*/          run get_pur_cost
                     (input rqd_part,
                      input rqd_vend,
                      input rqd_site,
                      input rqm_curr,
                      input rqd_req_qty,
                      input display_um,
                      input rqm_ex_rate,
                      input rqm_ex_rate2,
                      output rqd_pur_cost,
                      output base_cost).

/*L040*/          display
/*L040*/             display_um @ rqd_um
/*L040*/             rqd_pur_cost
/*L040*/             with frame b.
/*L040*/       end.  /* END - if rqd_pur_cost = 0 */

               continue = true.
            end.
         END PROCEDURE.

         PROCEDURE get_supplier:
            find rqd_det where recid(rqd_det) = rqd_recid exclusive-lock.
            find rqm_mstr where recid(rqm_mstr) = rqm_recid no-lock.

            continue = false.

            do on error undo, retry:
               set rqd_vend with frame b editing:
                  {mfnp.i vd_mstr rqd_vend vd_addr rqd_vend vd_addr vd_addr}

                  if recno <> ? then do:
                     display vd_addr @ rqd_vend with frame b.

                     if sngl_ln then do:
                        run display_supplier(input vd_addr).

                        display
                           vd_pr_list2 @ rqd_pr_list2
                           vd_pr_list @ rqd_pr_list
                        with frame vend.
                     end.
                  end.
               end.

               if rqd_vend > "" then do:
                  find vd_mstr where vd_addr = rqd_vend no-lock no-error.

                  if not available vd_mstr then do:
/*J39R**             {mfmsg.i 2 3} */
/*J39R*/             run p_ip_msg (input 2, input 3).
                     /* NOT A VALID SUPPLIER */
                     next-prompt rqd_vend with frame b.
                     undo, retry.
                  end.
               end.

               if sngl_ln then do:
                  run display_supplier(input rqd_vend).
               end.
               continue = true.
            end.
         END PROCEDURE.

         PROCEDURE display_supplier:
            define input parameter p_vend like rqd_vend no-undo.

            pause 0 .
            find ad_mstr where ad_addr = p_vend no-lock no-error.

            vend_row = frame-row(c) + 1.

            if available ad_mstr then do:
               display
                  ad_name
                  ad_line1
                  ad_line2
                  ad_city
                  ad_state
                  ad_zip
                  ad_country
               with frame vend.
            end.
            else do:
               display
                  "" @ ad_name
                  "" @ ad_line1
                  "" @ ad_line2
                  "" @ ad_city
                  "" @ ad_state
                  "" @ ad_zip
                  "" @ ad_country
               with frame vend.
            end.

            pause before-hide.
         END PROCEDURE.

         PROCEDURE retrieve_vendor_item_data:
            define input parameter p_vendor like rqm_vend no-undo.
            define input parameter p_part like rqd_part no-undo.
            define output parameter p_got_vendor_item_data as log no-undo.
            define output parameter p_q_qty like rqd_req_qty no-undo.
            define output parameter p_q_um like rqd_um no-undo.
            define output parameter p_curr like rqm_curr no-undo.
            define output parameter p_vpart like rqd_vpart no-undo.
            define output parameter p_q_price like rqd_pur_cost no-undo.
            define output parameter p_mfgr like vp_mfgr no-undo.
            define output parameter p_mfgr_part like vp_mfgr_part no-undo.

            p_got_vendor_item_data = false.

            for each vp_mstr no-lock
            where vp_part = p_part and vp_vend = p_vendor
            break by vp_q_date descending:
               if first(vp_q_date) then do:
                  assign
                     p_q_qty = vp_q_qty
                     p_q_um = vp_um
                     p_curr = vp_curr
                     p_vpart = vp_vend_part
                     p_q_price = vp_q_price
                     p_mfgr = vp_mfgr
                     p_mfgr_part = vp_mfgr_part
                     p_got_vendor_item_data = true.

                  leave.
               end.
            end.
         END PROCEDURE.

         PROCEDURE display_ext_cost:
            find rqd_det where recid(rqd_det) = rqd_recid exclusive-lock.

            ext_cost = rqd_req_qty * rqd_pur_cost
                       * (1 - (rqd_disc_pct / 100)).

/*J2W4*/    /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */
/*J2W4*/    {gprunp.i "mcpl" "p" "mc-curr-rnd"
                 "(input-output ext_cost,
                   input rndmthd,
                   output mc-error-number)"}
/*J2W4*/    if mc-error-number <> 0 then do:
/*J2W4*/       {mfmsg.i mc-error-number 2}
/*J2W4*/    end.

            display ext_cost with frame c.
         END PROCEDURE.

         PROCEDURE display_max_ext_cost:
            find rqd_det where recid(rqd_det) = rqd_recid exclusive-lock.

/*N174**    max_ext_cost = rqd_req_qty * rqd_max_cost   */
/*N174**                  * (1 - (rqd_disc_pct / 100)). */
/*N174*/    max_ext_cost = rqd_req_qty * rqd_max_cost.

/*J2W4*/    /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */
/*J2W4*/    {gprunp.i "mcpl" "p" "mc-curr-rnd"
                 "(input-output max_ext_cost,
                   input rndmthd,
                   output mc-error-number)"}
/*J2W4*/    if mc-error-number <> 0 then do:
/*J2W4*/       {mfmsg.i mc-error-number 2}
/*J2W4*/    end.

            display max_ext_cost with frame c.
         END PROCEDURE.

         PROCEDURE display_st_qty:
            find rqd_det where recid(rqd_det) = rqd_recid exclusive-lock.

            st_qty = rqd_req_qty * rqd_um_conv.
            display st_qty with frame c.
         END PROCEDURE.

/*L040*/ PROCEDURE get_remote_item_data:
/*L040*/    define input  parameter p_part     like pt_part     no-undo.
/*L040*/    define input  parameter p_site     like pt_site     no-undo.
/*L040*/    define output parameter p_std_cost as   decimal     no-undo.
/*L040*/    define output parameter p_rev      like pt_rev      no-undo.
/*L040*/    define output parameter p_loc      like pt_loc      no-undo.
/*L040*/    define output parameter p_ins      like pt_insp_rqd no-undo.
/*L040*/    define output parameter p_acct     like pod_acct    no-undo.
/*N014*/    define output parameter p_sub      like pod_sub     no-undo.
/*L040*/    define output parameter p_cc       like pod_cc      no-undo.

/*L040*/    define variable old_db       like si_db.
/*L040*/    define variable err-flag     as   integer.
/*L040*/    define variable curcst       as   decimal.
/*K253*/    define variable l_dummy_type as   character no-undo.

/*L040*/    find si_mstr where si_site = p_site no-lock.

/*L040*/    if si_db <> global_db then do:
/*L040*/       old_db = global_db.
/*L040*/       {gprun.i ""gpalias3.p"" "(si_db, output err-flag)" }
/*L040*/    end.

/*L040*/    {gprun.i ""gpsct05.p""
              "(p_part, si_site, 2, output p_std_cost, output curcst)"}
/*L040*/
/*N014* - ADDED SUB-ACCT PARM ON CALL TO POPOMTE1.P */
/*K253*/ /* ADDED L_DUMMY_TYPE AS NINTH OUTPUT PARAMETER */
/*N014*/ /*L040*/    {gprun.i ""popomte1.p""
              "(p_part,
                si_site,
                output p_rev,
                output p_loc,
                output p_ins,
                output p_acct,
                output p_sub,
                output p_cc,
                output l_dummy_type)"}

/*L040*/    if old_db <> global_db then do:
/*L040*/       {gprun.i ""gpalias3.p"" "(old_db, output err-flag)" }
/*L040*/    end.
/*L040*/ END PROCEDURE.

/*L040*/ PROCEDURE get_vendor_q_price:
/*L040*/    define input parameter p_part like pod_part no-undo.
/*L040*/    define input parameter p_vend like po_vend no-undo.
/*L040*/    define input parameter p_curr like po_curr no-undo.
/*L040*/    define input parameter p_qty_ord like pod_qty_ord no-undo.
/*L040*/    define input parameter p_um like pod_um no-undo.
/*L040*/    define output parameter p_pur_cost like pod_pur_cost no-undo.

/*L040*/    define variable conversion_factor as decimal no-undo.

/*L040*/    p_pur_cost = ?.

/*L040*/    for each vp_mstr no-lock
/*L040*/    where vp_part = p_part
/*L040*/    and vp_vend = p_vend
/*L040*/    break by vp_q_date descending:
/*L040*/       if first(vp_q_date) then do:
/*L040*/          conversion_factor = 1.

/*L040*/          if vp_um <> p_um then do:
/*L040*/             {gprun.i ""gpumcnv.p""
                       "(input vp_um, input p_um, input vp_part,
                         output conversion_factor)"}
/*L040*/          end.

/*L040*/          if conversion_factor <> ? then do:
/*L040*/             if p_qty_ord / conversion_factor >= vp_q_qty
/*L040*/             and p_curr = vp_curr
/*L040*/                then p_pur_cost = vp_q_price / conversion_factor.
/*L040*/          end.

/*L040*/          leave.
/*L040*/       end.
/*L040*/    end.
/*L040*/ END PROCEDURE.

/*L040*/ PROCEDURE get_pur_cost:
/*L040*/    define input parameter p_part like pt_part no-undo.
/*L040*/    define input parameter p_vend like po_vend no-undo.
/*L040*/    define input parameter p_site like si_site no-undo.
/*L040*/    define input parameter p_curr like po_curr no-undo.
/*L040*/    define input parameter p_qty_ord like pod_qty_ord no-undo.
/*L040*/    define input parameter p_um like pod_um no-undo.
/*L040*/    define input parameter p_ex_rate like po_ex_rate no-undo.
/*L040*/    define input parameter p_ex_rate2 like po_ex_rate2 no-undo.
/*L040*/    define output parameter p_pur_cost like pod_pur_cost no-undo.
/*L040*/    define output parameter p_base_cost like pod_pur_cost no-undo.

/*L040*/    define variable conversion_factor as decimal no-undo.
/*L040*/    define variable glxcst as decimal no-undo.
/*L040*/    define variable l_pl_acc like pl_pur_acct  no-undo.
/*N014*/    define variable l_pl_sub like pl_pur_sub  no-undo.
/*L040*/    define variable l_pl_cc  like pl_pur_cc  no-undo.
/*L040*/    define variable l_pt_rev like pt_rev no-undo.
/*L040*/    define variable l_pt_ins like pt_insp_rqd no-undo.
/*L040*/    define variable l_pt_loc like pt_loc no-undo.

/*L040*/    run get_vendor_q_price
               (input p_part,
                input p_vend,
                input p_curr,
                input p_qty_ord,
                input p_um,
                output p_pur_cost).

/*L040*/    if p_pur_cost = ? then do:
/*L040*/        find pt_mstr where pt_part = p_part no-lock no-error.

/*L040*/        if available pt_mstr then do:
/*N014* - ADD SUB-ACCT PARM ON CALL TO POPOMTE1.P */
/*N014*/ /*L040*/   run get_remote_item_data
                     (input p_part,
                      input p_site,
                      output glxcst,
                      output l_pt_rev,
                      output l_pt_loc,
                      output l_pt_ins,
                      output l_pl_acc,
                      output l_pl_sub,
                      output l_pl_cc).

/*L040*/          conversion_factor = 1.

/*L040*/          if pt_um <> p_um then do:
/*L040*/             {gprun.i ""gpumcnv.p""
                       "(input pt_um, input p_um, input pt_part,
                         output conversion_factor)"}
/*L040*/          end.

/*L040*/          p_pur_cost = (glxcst / conversion_factor) * p_ex_rate.
/*L040*/          {gprunp.i "mcpl" "p" "mc-curr-conv"
                    "(input base_curr,
                      input p_curr,
                      input p_ex_rate2,
                      input p_ex_rate,
                      input (glxcst / conversion_factor),
                      input false,  /* DO NOT ROUND */
                      output p_pur_cost,
                      output mc-error-number)"}

/*L040*/          p_base_cost = glxcst / conversion_factor.
/*L040*/        end.
/*L040*/    end.
/*L040*/ END PROCEDURE.

/*J2VX*/ PROCEDURE display_message_mfmsg02:
/*J2VX*/    define input parameter p_message_nbr    like msg_nbr no-undo.
/*J2VX*/    define input parameter p_severity       as integer no-undo.
/*J2VX*/    define input parameter p_user_value     as character no-undo.

/*J2VX*/    {mfmsg02.i p_message_nbr p_severity p_user_value}

/*J2VX*/ END PROCEDURE.

/*J300*/ PROCEDURE get_default_category:
/*J300*/    define input parameter p_direct like rqm_direct no-undo.
/*J300*/    define input parameter p_acct like rqd_acct no-undo.
/*N014* /*J300*/ define input parameter p_acct_subacct like rqm_acct no-undo. */
/*N014*/    define input parameter p_sub like rqm_sub no-undo.
/*J300*/    define output parameter p_category like rqc_category no-undo.
/*J300*/
/*J300*/    p_category = "".
/*J300*/
/*J300*/    /*DEFAULT RULES:                                            */
/*J300*/    /*  1. CATEGORIES NEEDED ONLY FOR MRO REQS. (DIRECT = NO)   */
/*J300*/    /*  2. USE (PUR ACCT + SUBACCT) TO FIND CATEGORY            */
/*J300*/    /*  3. USE PUR ACCT TO FIND CATEGORY                        */
/*J300*/    /*  4. NOT FOUND, CATEGORY = ""                             */
/*J300*/
/*J300*/    if not p_direct then do:
/*J300*/        find last rqcd_det
/*N014* /*J300*/        where  rqcd_acct_from <= p_acct_subacct */
/*N014* /*J300*/        and rqcd_acct_to >= p_acct_subacct */
/*N014*/        where  rqcd_acct_from <= p_acct
/*N014*/        and rqcd_acct_to >= p_acct
/*N014*/        and rqcd_sub_from <= p_sub
/*N014*/        and rqcd_sub_to >= p_sub
/*J300*/        no-lock no-error.
/*J300*/
/*J300*/        if available rqcd_det then do:
/*J300*/            p_category = rqcd_category.
/*J300*/        end.
/*J300*/        else do:
/*J300*/            find last rqcd_det
/*J300*/            where  rqcd_acct_from <= p_acct
/*J300*/            and rqcd_acct_to >= p_acct
/*J300*/            no-lock no-error.
/*J300*/
/*J300*/            if available (rqcd_det) then do:
/*J300*/                p_category = rqcd_category.
/*J300*/            end.
/*J300*/        end.
/*J300*/    end.  /* if not p_direct */
/*J300*/ END PROCEDURE.

/*J39R*/ /* TO REDUCE ACTION SEGMENT ERROR CREATED INTERNAL PROCEDURES */

/*J39R*/ PROCEDURE p_close_req:

/*J39R*/     define input parameter p_rqm_recid as recid no-undo.

/*J39R*/     find rqm_mstr
/*J39R*/        where recid(rqm_mstr) = p_rqm_recid
/*J39R*/        exclusive-lock no-error.
/*J39R*/     if available rqm_mstr then do:
/*J39R*/        if rqm_status = "" and
/*J39R*/           rqm_open   = true then
/*J39R*/           rqm_status = "c" .
/*J39R*/     end. /* IF AVAILABLE RQM_MSTR */
/*J39R*/ end. /* PROCEDURE P_CLOSE_REQ */

/*J39R*/ PROCEDURE p_open_req:

/*J39R*/     define input parameter p_rqm_recid as recid no-undo.

/*J39R*/     find rqm_mstr
/*J39R*/        where recid(rqm_mstr) = p_rqm_recid
/*J39R*/        exclusive-lock no-error.
/*J39R*/     if available rqm_mstr then
/*J39R*/        rqm_status = "".
/*J39R*/ end. /* PROCEDURE P_OPEN_REQ */

/*J39R*/ PROCEDURE p_ip_msg:

/*J39R*/    define input parameter l_num  as integer no-undo.
/*J39R*/    define input parameter l_stat as integer no-undo.

/*J39R*/     {mfmsg.i l_num l_stat}
/*J39R*/ end. /* PROCEDURE P_IP_MSG */

/*J39R*/ PROCEDURE p_mfmsg01:

/*J39R*/    define input        parameter l_num  as   integer     no-undo.
/*J39R*/    define input        parameter l_stat as   integer     no-undo.
/*J39R*/    define input-output parameter l_yn   like mfc_logical no-undo.

/*J39R*/     {mfmsg01.i l_num l_stat l_yn}
/*J39R*/ end. /* PROCEDURE P_MFMSG01 */
