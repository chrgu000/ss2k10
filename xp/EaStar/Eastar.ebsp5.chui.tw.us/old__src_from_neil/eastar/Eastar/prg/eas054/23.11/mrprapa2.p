/* mrprapa2.p - MRP Planned Purchase Requisition Creation                     */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                         */
/*N014*/ /*V8:RunMode=Character,Windows                                       */
/* REVISION  8.5      LAST MODIFIED: 08/15/97   BY: *J1Q2* Patrick Rowan      */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98   BY: *L040* Charles Yen        */
/* REVISION: 8.5      LAST MODIFIED: 07/30/98   BY: *J2WL* Patrick Rowan      */
/* REVISION: 8.5      LAST MODIFIED: 08/31/98   BY: *J2W1* Patrick Rowan      */
/* REVISION: 8.5      LAST MODIFIED: 09/10/98   BY: *J2YD* Patrick Rowan      */
/* REVISION: 8.5      LAST MODIFIED: 09/21/98   BY: *J300* Patrick Rowan      */
/* REVISION: 8.5      LAST MODIFIED: 09/28/98   BY: *J30R* Patrick Rowan      */
/* REVISION: 8.6E     LAST MODIFIED: 11/12/98   BY: *J34G* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 03/25/99   BY: *J3C7* Poonam Bahl        */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Patti Gaultney     */
/* REVISION: 9.1      LAST MODIFIED: 01/12/00   BY: *M0HL* Manish K.          */
/* REVISION: 9.1      LAST MODIFIED: 07/20/00   BY: *N0GF* Mudit Mehta        */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KR* myb                */
/* REVISION: 9.1      LAST MODIFIED: 02/07/01   BY: *M11D* Sandeep P.         */
/* REVISION: 9.1      LAST MODIFIED: 05/02/01   BY: *M162* Reetu Kapoor       */
/* REVISION: 9.1      LAST MODIFIED: 05/24/01   BY: *M18G* Murali Ayyagari    */
/* REVISION: 9.1      LAST MODIFIED: 08/24/01   BY: *M1J7* Sandeep P.         */
/* REVISION: 9.1      LAST MODIFIED: 12/21/01   BY: *N174* Anitha Gopal       */
/* REVISION: 9.1      LAST MODIFIED: 05/29/02   BY: *N1K7* Mark Christian     */

/*!
 ----------------------------------------------------------------------------
 DESCRIPTION: Copy MRP planned replenishments to a new requisition.
              Supports the Global Requisition Module of MFG/PRO (GRS).

 Notes:
 1) This program processes a single MRP replenishment, so must be called
    multiple times when multiple replenishments have been approved.
 2) Requisition headers are created when the 1st replenishment is processed.
 3) The requisition number is taken from the requisition control file.
 4) The requisition line is taken from the replenishment counter (1st parameter)
 5) Input parameters
       {1} replenishment counter
       {2} recid of wo_mstr
       {3} requisition number
 6) Output parameters
       {1} return code
 7) Patch J2WL makes this program accept generic data instead of reading wo_mstr
    records.  Operations Planning does not use wo_mstr.
    The new input parameters are:
       {1} replenishment counter
       {2} requisition number
       {3} part
       {4} site
       {5} quantity
       {6} release date
       {7} due date
       {8} remarks
 8) Requisitions created from MRP and OPS are product line purchases and do not
    contain categories.

 ============================================================================
 !*/
         {mfdeclre.i}
/*N0GF*/ {gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE mrprapa2_p_1 "Stock Um Qty"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrprapa2_p_2 "Ext Cost"
/* MaxLen: Comment: */

/*N0GF*
 * &SCOPED-DEFINE mrprapa2_p_3 "Item Not In Inventory"
 * /* MaxLen: Comment: */
 *N0GF*/

&SCOPED-DEFINE mrprapa2_p_4 "MRP planned order"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrprapa2_p_5 "Max Ext Cost"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         {rqconst.i}

         /* PARAMETERS */
         define input parameter in_repl_cntr   as integer no-undo.
/*J2WL*  define input parameter in_recid        as recid no-undo.    */
         define input parameter in_rqm_nbr   like rqm_mstr.rqm_nbr no-undo.
/*J2WL*/ define input parameter in_rqd_part     like rqd_det.rqd_part no-undo.
/*J2WL*/ define input parameter in_rqd_site     like rqd_det.rqd_site no-undo.
/*J2WL*/ define input parameter in_rqd_req_qty  like
/*J2WL*/                                        rqd_det.rqd_req_qty no-undo.
/*J2WL*/ define input parameter in_rqd_rel_date like
/*J2WL*/                                        rqd_det.rqd_rel_date no-undo.
/*J2WL*/ define input parameter in_rqd_due_date like
/*J2WL*/                                        rqd_det.rqd_due_date no-undo.
/*J2WL*/ define input parameter in_remarks_text like rqm_mstr.rqm_rmks no-undo.
         define output parameter out_return_code as integer no-undo.

         /* VARIABLES */
/*J30R*/ define variable req_qty        like rqd_req_qty no-undo.
         define variable line           like rqd_line no-undo.
         define variable get_rqmnbr     like rqm_mstr.rqm_nbr no-undo.
/*J2WL*  define variable remarks_text   like rqm_rmks no-undo
 *                       initial {&mrprapa2_p_4}.
 *J2WL*/

/*N014*/ define variable temp_sub        like rqm_sub.
/*N014*/ define variable temp_cc         like rqm_cc.

         /* MRPRAPA.P VARIABLES */
         define variable nonwdays as integer no-undo.
         define variable overlap  as integer no-undo.
         define variable workdays as integer no-undo.
         define variable interval as integer no-undo.
         define variable frwrd  as integer no-undo.
         define variable know_date as date no-undo.
         define variable find_date as date no-undo.

         /* RQRQMTA.P VARIABLES */
         define variable clines as integer init ? no-undo.
         define variable continue as logical no-undo.
         define variable conversion_factor as decimal no-undo.
         define variable cur_cost as decimal no-undo.
         define variable del-yn like mfc_logical no-undo.
         define variable desc1 like pt_desc1 no-undo.
         define variable desc2 like pt_desc1 no-undo.
         define variable ext_cost like rqd_pur_cost
                                  label {&mrprapa2_p_2} no-undo.
         define variable got_vendor_price as logical no-undo.
         define variable i as integer no-undo.
/*N014*  define variable l_pl_cc like rqd_cc no-undo.                         */
         define variable line_cmmts like COMMENTS no-undo.
         define variable max_ext_cost like rqd_max_cost
                                      label {&mrprapa2_p_5} no-undo.
         define variable mfgr like vp_mfgr no-undo.
         define variable mfgr_part like vp_mfgr_part no-undo.
         define variable messages as character no-undo.
         define variable msglevels as character no-undo.
         define variable msgnbr as integer no-undo.
         define variable new_rqd like mfc_logical no-undo.
         define variable not_in_inventory_msg as character
/*N0GF*                                     initial {&mrprapa2_p_3} no-undo. */
/*N0GF*/                                    no-undo.
         define variable poc_pt_req as log no-undo.
         define variable prev_category like rqd_category no-undo.
         define variable prev_ext_cost like ext_cost no-undo.
         define variable prev_item like rqd_part no-undo.
         define variable prev_max_ext_cost like ext_cost no-undo.
         define variable prev_qty like rqd_req_qty no-undo.
         define variable prev_site like rqd_site no-undo.
         define variable prev_status like rqd_status no-undo.
         define variable prev_um like rqd_um no-undo.
         define variable pur_cost as decimal no-undo.
         define variable qty_open like rqd_req_qty no-undo.
         define variable requm like rqd_um no-undo.
         define variable rqd_recid as recid no-undo.
         define variable rqm_recid as recid no-undo.
         define variable sngl_ln like rqf_ln_fmt.
         define variable st_qty like pod_qty_ord label {&mrprapa2_p_1} no-undo.
         define variable tot_qty_ord like pod_qty_ord no-undo.
         define variable serial_controlled as log no-undo.
/*N014*  define variable valid_acct like mfc_logical no-undo.                 */
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
/*L040*/ define variable mc-error-number like msg_nbr no-undo.
/*J3C7*/ define variable temp_rate     as   decimal      no-undo.
/*J3C7*/ define variable temp_rate2    as   decimal      no-undo.
/*J3C7*/ define variable temp_ratetype like exr_ratetype no-undo.

/*M162*/ define shared temp-table tt-rqm-mstr no-undo
/*M162*/     field tt-vend   like rqm_mstr.rqm_vend
/*M162*/     field tt-nbr    like rqm_mstr.rqm_nbr
/*M162*/     field tt-line   like rqd_det.rqd_line
/*M162*/     field tt-part   like rqd_det.rqd_part
/*M162*/     field tt-yn     like mfc_logical
/*M1J7*/     field tt-wo-nbr like wo_nbr
/*M1J7*/     field tt-wo-lot like wo_lot
/*M162*/     index vend is primary
/*M162*/        tt-vend
/*M162*/        tt-nbr
/*M162*/        tt-line
/*M1J7*/     index ttnbrlot
/*M1J7*/        tt-wo-nbr
/*M1J7*/        tt-wo-lot
/*M162*/     index ttnbr
/*M162*/        tt-nbr.

         /* INITIALIZATION */
/*J2W1*/ assign
/*N0GF*/    not_in_inventory_msg = getTermLabel("ITEM_NOT_IN_INVENTORY",25)
/*J2W1*/    new_rqd = true
         out_return_code = -1.
         find first gl_ctrl no-lock.
/*J2W1*/ find first poc_ctrl no-lock.

         /* GET CURRENT WORK ORDER MASTER */
/*J2WL*  find wo_mstr no-lock
 *J2WL*     where recid(wo_mstr) = in_recid.        */

         /* IF 1ST REPLENISHMENT THEN CREATE REQUISITION HEADER */

         if in_repl_cntr = 1 then do:

             /* INITIALIZATION */
/*J2W1*      find first poc_ctrl no-lock.        */
             find first mfc_ctrl where
             mfc_field = "poc_pt_req" no-lock no-error.
             if available mfc_ctrl then poc_pt_req = mfc_logical.

             {gprun.i ""rqpma.p""}
             find first rqf_ctrl no-lock.

/*N1K7*/     for first si_mstr
/*N1K7*/        fields (si_site si_entity)
/*N1K7*/        where si_site = in_rqd_site
/*N1K7*/        no-lock:
/*N1K7*/     end. /* FOR FIRST si_mstr */


             /*ADDING NEW RECORD*/
             create rqm_mstr.

             assign
                 rqm_curr         = base_curr
                 rqm_direct       = true
                 rqm_due_date     = today
                 rqm_email_opt    = rqf_email_opt
                 rqm_ent_date     = today
                 rqm_ent_ex       = 1
                 rqm_eby_userid   = global_userid
/*N1K7**         rqm_entity       = gl_entity */
/*N1K7*/         rqm_entity       = si_entity
                 rqm_ex_rate      = 1
/*L040*/         rqm_ex_rate2     = 1
                 rqm_nbr          = in_rqm_nbr
                 rqm_need_date    = today
                 rqm_pent_userid  = ?
                 rqm_req_date     = today
                 rqm_rqby_userid  = global_userid
                 rqm_rtto_userid  = global_userid
                 rqm_aprv_stat    = APPROVAL_STATUS_UNAPPROVED
                 rqm_ship         = poc_ship
                 rqm_status       = ""
                 rqm_print        = true
/*J2WL*          rqm_rmks         = remarks_text  */
/*J2WL*/         rqm_rmks         = in_remarks_text
                 .

             if recid(rqm_mstr) = -1 then.

             /*WRITE HISTORY RECORD*/
             {gprun.i ""rqwrthst.p""
                "(input rqm_nbr,
                input 0,
                input ACTION_CREATE_REQ,
                input global_userid,
                input '',
                input '')"}

             /*CHECK AND SET THE OPEN AND APRV STATUS INDICATORS*/

             {gprun.i ""rqsetopn.p"" "(input rqm_nbr)"}

             /*SAVE ACCESSED REQ NUMBER FOR OTHER PGMS TO USE*/

/*M162*/     /* SINCE THE REQS ARE NOW CREATED VENDORWISE, THERE MAYBE A */
/*M162*/     /* POSSIBILITY THAT THE LAST REQ IS CREATED BEFORE THE PREV */
/*M162*/     /* REQ. IN ORDER TO DEFAULT THE LAST REQ IN REQ MAINT,      */
/*M162*/     /* DOING A FOR LAST ON tt-rqm-mstr                          */

/*M162*/     for last tt-rqm-mstr
/*M162*/       where tt-nbr <> ""
/*M162*/         and tt-yn
/*M162*/       no-lock use-index ttnbr:
/*M162*/     end. /* FOR LAST tt-rqm-mstr */
/*M162*/     if available tt-rqm-mstr
/*M162*/     then
/*M162*/        get_rqmnbr = tt-rqm-mstr.tt-nbr.
/*M162*/     else
                get_rqmnbr = rqm_nbr.

             {gprun.i ""rqidf.p""
             "(input 'put', input 'reqnbr', input-output get_rqmnbr)"}

             end.  /* if in_repl_cntr = 1 */
         else do:

            /* GET REQUISITION MASTER */

           find rqm_mstr where
                rqm_nbr = in_rqm_nbr exclusive-lock no-error.
           if not available (rqm_mstr) then
           leave.
         end.

         /* CREATE REQUISITION LINE */

         line = in_repl_cntr.
         find last rqd_det where
            rqd_nbr = rqm_nbr no-lock no-error.
         if available rqd_det then
            line = rqd_line + 1.

         /*ADDING NEW RECORD*/
         create rqd_det.

         assign
            rqd_aprv_stat   = APPROVAL_STATUS_UNAPPROVED
            rqd_line        = line
            rqd_nbr         = rqm_nbr
/*J2WL*     rqd_site        = wo_site
 *          rqd_part        = wo_part
 *J2WL*/
/*J2WL*/    rqd_site        = in_rqd_site
/*J2WL*/    rqd_part        = in_rqd_part
            rqd_acct        = gl_pur_acct
/*N014*/    temp_sub        = gl_pur_sub
/*N014*/    temp_cc         = gl_pur_cc
/*N014*     rqd_cc          = gl_pur_cc                */
/*J2WL*     rqd_req_qty     = wo_qty_ord
 *          rqd_rel_date    = wo_rel_date
 *          rqd_due_date    = wo_due_date
 *          rqd_need_date   = wo_due_date
 *J2WL*/
/*J2WL*/    rqd_req_qty     = in_rqd_req_qty
/*J2WL*/    rqd_rel_date    = in_rqd_rel_date
/*J2WL*/    rqd_due_date    = in_rqd_due_date
/*J2WL*/    rqd_need_date   = in_rqd_due_date
            rqd_um_conv     = 1
/*J2YD*/    rqd_open        = true      /* Line's open qty status */
            .

         if recid(rqd_det) = -1 then.

         /* FIND PART MASTER AND PLANNING RECORDS */
/*J2WL*  find pt_mstr where pt_part = wo_part
 *       no-lock no-error.
 *J2WL*/
/*J2WL*/ find pt_mstr where pt_part = in_rqd_part
/*J2WL*/ no-lock no-error.

/*J2WL*  find ptp_det where ptp_part = wo_part
 *       and ptp_site = wo_site no-lock no-error.
 *J2WL*/
/*J2WL*/ find ptp_det where ptp_part = in_rqd_part
/*J2WL*/ and ptp_site = in_rqd_site no-lock no-error.

         /*GET DEFAULT SUPPLIER, PRICE, DISCOUNT LISTS, ACCOUNT & CC*/

         if available ptp_det then do:
            assign
               rqd_vend = ptp_vend
               .
            find vd_mstr where vd_addr = ptp_vend no-lock no-error.
         end.  /* if available ptp_mstr */
         else
            if available pt_mstr then do:
               assign
                  rqd_vend = pt_vend
                  .
               find vd_mstr where vd_addr = pt_vend no-lock no-error.
            end.  /* if available pt_mstr */

         if available vd_mstr then do:
            assign
               rqd_pr_list  = vd_pr_list
               rqd_pr_list2 = vd_pr_list2
               rqd_acct     = vd_pur_acct
/*N014*/       temp_sub     = vd_pur_sub
/*N014*/       temp_cc      = vd_pur_cc
/*N014*        rqd_cc       = vd_pur_cc                  */
/*J30R*/       rqd_disc_pct = vd_disc_pct
               .

/*J3C7*/    /* REQUISITION CURRENCY IS EARLIER SET TO THE BASE CURRENCY */
/*J3C7*/    /* ADDED LOGIC :                                            */
/*J3C7*/    /* IF THE VENDOR CURRENCY OF FIRST REPLINISHMENT IS NOT     */
/*J3C7*/    /* THE SAME AS REQUISITION HEADER CURRENCY THEN COPY THIS   */
/*J3C7*/    /* LINE VENDOR CURERENCY AND EXCHANGE RATES TO THE          */
/*J3C7*/    /* REQUISITION HEADER                                       */

/*J3C7*/    if in_repl_cntr = 1 and vd_curr <> rqm_curr
/*J3C7*/    then do :
/*J3C7*/       assign rqm_curr = vd_curr.

/*J3C7*/       /* DETERMINE EXCHANGE RATES */
/*J3C7*/       /* CREATE EXCHANGE RATE USAGE RECORDS */
/*J3C7*/       {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
                         "(input rqm_curr,
                          input base_curr,
                          input rqm_ex_ratetype,
                          input rqm_req_date,
                          output rqm_ex_rate,
                          output rqm_ex_rate2,
                          output rqm_exru_seq,
                          output mc-error-number)"}
/*J3C7*/       if mc-error-number <> 0 then do:
/*J3C7*/          {mfmsg.i mc-error-number 3}
/*J3C7*/          undo, retry.
/*J3C7*/       end.
/*J3C7*/    end. /* IF IN_REPL_CNTR = 1 AND VD_CURR <> RQM_CURR */

/*J3C7*/    if (in_repl_cntr = 1) and (rqm_curr <> rqf_appr_curr)
/*J3C7*/    then do:

/*J3C7*/        {gprun.i ""rqexrt.p""
                         "(input rqm_curr,
                           input rqf_appr_curr,
                           input temp_ratetype,
                           output temp_rate,
                           output temp_rate2,
                           output mc-error-number)"}

/*J3C7*/         if mc-error-number <> 0 then do:
/*J3C7*/            /* NO EXCHANGE RATE FOR APPROVAL CURRENCY */
/*J3C7*/            {mfmsg.i 2087 3}
/*J3C7*/            undo, retry.
/*J3C7*/         end.
/*J3C7*/     end. /* IF IN_REPL_CNTR = 1 AND RQM_CURR <> RQF_APPR_CURR */

         end.

         /* COPY PART MASTER DATA */

         if available pt_mstr then do:
            assign
               rqd_um       = pt_um
/*M0HL**       rqd_vend     = pt_vend */
               rqd_desc     = pt_desc1
               rqd_rev      = pt_rev
               rqd_loc      = pt_loc
               rqd_insp_rqd     = pt_insp_rqd
               .

            if pt_lot_ser = "s" then
               rqd_lot_rcpt = true.

            find pl_mstr no-lock
            where pl_prod_line = pt_prod_line
            no-error.

            if available pl_mstr and pl_pur_acct > "" then do:
               assign
                  rqd_acct  = pl_pur_acct
/*N014*/          temp_sub  = pl_pur_sub
/*N014*/          temp_cc   = pl_pur_cc
/*N014*           rqd_cc    = pl_pur_cc                      */
                  .
                end.
         end.  /* if available pt_mstr */

         /* CALCULATE DATES */

         if available ptp_det then do:
            assign
/*M0HL**       rqd_rev          = pt_rev      */
/*M0HL**       rqd_insp_rqd     = pt_insp_rqd */
/*M0HL*/       rqd_rev          = ptp_rev
/*M0HL*/       rqd_insp_rqd     = ptp_ins_rqd
               .
            if ptp_pm_code <> "P" then do:
               if ptp_ins_rqd and ptp_ins_lead <> 0 then do:
                  rqd_need_date = ?.

/*J2WL*             {mfdate.i rqd_need_date wo_due_date
 *                      ptp_ins_lead rqd_site}
 *J2WL*/

/*J2WL*/            {mfdate.i rqd_need_date in_rqd_due_date
                        ptp_ins_lead rqd_site}

               end.  /* if ptp_ins_rqd and ptp_ins_lead <> 0 */

               rqd_rel_date = rqd_need_date - ptp_pur_lead.
               {mfhdate.i rqd_rel_date -1 rqd_site}
            end.  /* if ptp_pm_code <> "P" */
         end.  /* if available ptp_det */
         else
            if available pt_mstr then do:
               if pt_pm_code <> "P" then do:
                  if pt_insp_rqd and pt_insp_lead <> 0 then do:
                     rqd_need_date = ?.

/*J2WL*                 {mfdate.i rqd_need_date wo_due_date
 *                          pt_insp_lead rqd_site}
 *J2WL*/

/*J2WL*/                {mfdate.i rqd_need_date in_rqd_due_date
                            pt_insp_lead rqd_site}

                  end.  /* if pt_insp_rqd and pt_insp_lead <> 0 */

                  rqd_rel_date = rqd_need_date - pt_pur_lead.
                  {mfhdate.i rqd_rel_date -1 rqd_site}
               end.  /* if pt_pm_code <> "P" */
            end.  /* if available pt_mstr */

         if (available ptp_det and ptp_ins_rqd) or
            (not available ptp_det and pt_insp_rqd) then do:
/*J2W1*     find first poc_ctrl no-lock.    */
            rqd_loc = poc_insp_loc.
         end.

         got_vendor_item_data = no.
         got_vendor_price = no.

         /*GET SUPPLIER ITEM - WHEN AVAILABLE*/

         if rqd_vend <> "" then do:
            run retrieve_vendor_item_data
               (input rqd_vend,
                input rqd_part,
                output got_vendor_item_data,
                output vendor_q_qty,
                output vendor_q_um,
                output vendor_q_curr,
                output vendor_part,
                output vendor_price,
                output mfgr,
                output mfgr_part).

            if got_vendor_item_data then
               rqd_vpart = vendor_part.

         end.  /* if rqd_vend <> "" */

         /*DETERMINE PRICING*/

/*J300*/ /*USE THE VENDOR QUOTE PRICE ONLY WHEN THE PRICE IS NON-ZERO*/

/*J300*  if got_vendor_item_data then do:   */
/*J300*/ if got_vendor_item_data and vendor_price <> 0
/*J300*/    then do:
            if vendor_q_curr = rqm_curr or
               vendor_q_curr = "" then do:

               /*CONVERT PRICE PER UM CONVERSION*/

               if vendor_q_um = rqd_um then do:
                  conversion_factor = 1.
               end.
               else do:
                  {gprun.i ""gpumcnv.p""
                 "(input vendor_q_um,
                       input rqd_um, input rqd_part,
                       output conversion_factor)"}
               end.

               if conversion_factor <> ? then do:
/*J300*/          /* --- MINIMUM BUY RULE --- */
/*J300*/          /* ONLY CONVERT TO THE VENDOR ITEM */
/*J300*/          /* PRICE IF THE REQ QTY >= THE     */
/*J300*/          /* VENDOR QUOTE QTY.               */
/*J30R* /*J300*/  if vendor_q_um = rqd_um            */
/*J30R* /*J300*/     and vendor_q_qty <= rqd_req_qty */
/*J30R*/          if vendor_q_um = rqd_um then do:
/*J30R*/            if rqd_req_qty >= vendor_q_qty
/*J300*/             then do:
/*J300*/                assign
                            rqd_pur_cost = vendor_price / conversion_factor
                            got_vendor_price = true.
/*J300*/            end.
/*J300*/          end.
/*J30R*/          else do:
/*J30R*/            req_qty = rqd_req_qty / conversion_factor.
/*J30R*/            if req_qty >= vendor_q_qty then do:
/*J30R*/                assign
/*J30R*/                    rqd_pur_cost = vendor_price / conversion_factor
/*J30R*/                    got_vendor_price = true.
/*J30R*/            end.
/*J30R*/          end.  /* else do */
               end.  /* if conversion_factor <> ? */
            end.  /* if vendor_q_curr = rqm_curr ... */
         end.  /* if got_vendor_item_data */

         if not got_vendor_price then do:
            /*DIDN'T FIND A VENDOR PART PRICE, USE STD COST*/

            {gprun.i ""gpsct05.p""
               "(input rqd_part, input rqd_site, input 2,
                 output rqd_pur_cost, output cur_cost)"}

/*L040*     rqd_pur_cost = rqd_pur_cost * rqm_ex_rate. */
/*L040*/    /* CONVERT FROM BASE TO FOREIGN CURRENCY */
/*L040*/    {gprunp.i "mcpl" "p" "mc-curr-conv"
             "(input base_curr,
               input rqm_curr,
               input rqm_ex_rate2,
               input rqm_ex_rate,
               input rqd_pur_cost,
               input false, /* DO NOT ROUND */
               output rqd_pur_cost,
               output mc-error-number)"}.

            /*CONVERT PRICE PER UM CONVERSION*/

            if pt_um = rqd_um then do:
               conversion_factor = 1.
            end.
            else do:
               {gprun.i ""gpumcnv.p"" "(input rqd_um,
                  input pt_um, input rqd_part,
                  output conversion_factor)"}
            end.

            if conversion_factor <> ? then do:
               rqd_pur_cost = rqd_pur_cost * conversion_factor.
            end.

         end.  /* if not got_vendor_price */

         /*INITIAL DEFAULT FOR DISCOUNT*/

/*J30R*/ /*AT THIS TIME RQM_DISC_PCT DOES NOT CONTAIN A VALUE! */
/*J30R*  rqd_disc_pct = rqm_disc_pct.   */

         /*GET PRICE FROM PRICE TABLES IF THERE IS ONE*/

         net_price = rqd_pur_cost * (1 - rqd_disc_pct / 100).

         lineffdate = rqd_due_date.
         if lineffdate = ? then lineffdate = rqm_req_date.
         if lineffdate = ? then lineffdate = today.

         if rqd_pr_list2 <> "" then do:
            net_price = ?.

            {gprun.i ""gppclst.p""
               "(input      rqd_pr_list2,
                 input        rqd_part,
                 input        rqd_um,
                 input        rqd_um_conv,
                 input        lineffdate,
                 input        rqm_curr,
                 input        new_rqd,
                 input        poc_pt_req,
                 input-output rqd_pur_cost,
                 input-output net_price,
                 output       minprice,
                 output       maxprice,
                 output       pc_recno)" }

            if net_price <> ? then
               net_price = net_price * (1 - rqd_disc_pct / 100).

         end.  /* if rqd_pr_list2 <> "" */



     /*GET DISCOUNT FROM DISCOUNT TABLES IF THERE IS ONE*/


/*J30R*/ /*CHANGED THE 10TH INPUT PARAMETER FROM:           */
/*J30R*/ /*       input        rqm_disc_pct,                */
/*J30R*/ /*                            TO:                  */
/*J30R*/ /*       input        rqd_disc_pct,                */
/*J30R*/ /*THIS DISCOUNT IS PASSED INTO THE SUBPROGRAM SO   */
/*J30R*/ /*THE DISCOUNT LIST CAN TAKE THE SUPPLIER DISCOUNT */
/*J30R*/ /*INTO EFFECT.  AT THIS POINT THE HEADER DISCOUNT  */
/*J30R*/ /*IS NOT POPULATED, AND YOU WILL FIND THE SUPPLIER */
/*J30R*/ /*IN THE REQ. LINE (POPULATED FROM THE VD_MSTR).   */
/*J30R*/ /*THIS KEEPS ALL OF THE LINE DISCOUNTS SEPARATE.   */


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
                 input        rqd_disc_pct,
                 input-output rqd_pur_cost,
                 output       rqd_disc_pct,
                 input-output net_price,
                 output       pc_recno)" }
         end.


/*J2W1*/ /*SET UNIT COST TO NET PRICE*/

/*J2W1*/ /*Unit cost is set to net price when there is no       */
/*J2W1*/ /*standard cost on the item but the req. refers        */
/*J2W1*/ /*to a price table or discount table.  The disc% is    */
/*J2W1*/ /*returned as 0.00 since it is based on the unit cost. */
/*J2W1*/ /*The net price is passed back from the sub-programs   */
/*J2W1*/ /*and plugged into the unit cost field to show the     */
/*J2W1*/ /*discounted price.                                    */

/*J2W1*/ if rqd_pur_cost = 0 and net_price <> ? then
/*J2W1*/    rqd_pur_cost = net_price.

/*N174** rqd_max_cost = rqd_pur_cost */
/*N174*/ rqd_max_cost =
/*N174*/ if rqd_disc_pct < 0
/*N174*/ then
/*N174*/    rqd_pur_cost * (1 - rqd_disc_pct
/*N174*/                      / 100)
/*N174*/ else
/*N174*/    rqd_pur_cost.


         /*WRITE HISTORY RECORD*/

         {gprun.i ""rqwrthst.p""
            "(input rqm_nbr,
              input rqd_line,
              input ACTION_CREATE_REQ_LINE,
              input global_userid,
              input '',
              input '')"}

         /* UPDATE MRP VISIBILITY */
         {gprun.i ""rqmrw.p""
                  "(input true,
                    input rqd_site,
                    input rqm_nbr,
                    input rqd_line)"}

         /* UPDATE REQUISITION HEADER */

         /* UPDATE TOTALS*/
         ext_cost   = rqd_req_qty * rqd_pur_cost *
                (1 - (rqd_disc_pct / 100)).
/*N174** max_ext_cost   = rqd_req_qty * rqd_max_cost * */
/*N174**        (1 - (rqd_disc_pct / 100)).            */

/*N174*/ max_ext_cost   = rqd_req_qty * rqd_max_cost.

     rqm_total  = rqm_total + ext_cost.
     rqm_max_total  = rqm_max_total + max_ext_cost.

         /* IF PROCESSING 1ST REPLENISHMENT                */
         /* THEN BACK-FILL THE REQUISITION HEADER          */
         /* WITH SUPPLIER, DISCOUNT, PRICE LIST AND DATES  */
         /* FROM REQUISITION LINE JUST CREATED.            */

         if in_repl_cntr = 1 then do:
            assign
               rqm_vend     = rqd_vend

/*J2W1*/       /*DON'T COPY THE THESE FIELDS TO THE HEADER, THEY */
/*J2W1*/       /*EFFECT HOW SUBSEQUENT LINES ARE PRICED.         */
/*J2W1*        rqm_disc_pct = rqd_disc_pct
 *             rqm_pr_list  = rqd_pr_list
 *             rqm_pr_list2 = rqd_pr_list2
 *J2W1*/
/*J30R*/       /*THESE FIELDS ARE RE-INSTATED SINCE SUBSEQUENT LINES */
/*J30R*/       /*WILL ONLY LOOK AND THE CURRENT LINE PRICE LISTS AND */
/*J30R*/       /*DISCOUNTS AND WILL NOT LOOK AT THE HEADER.  THE     */
/*J30R*/       /*HEADER MAY CONTAIN A DIFFERENT SUPPLIER AND DISC %. */
/*J30R*/       rqm_disc_pct = rqd_disc_pct
/*J30R*/       rqm_pr_list  = rqd_pr_list
/*J30R*/       rqm_pr_list2 = rqd_pr_list2

               rqm_due_date = rqd_due_date
               rqm_need_date    = rqd_need_date
               rqm_acct     = rqd_acct
/*N014*/       rqm_sub      = temp_sub
               rqm_cc       = temp_cc
               rqm_site     = rqd_site
/*M18G* /*M11D*/       rqm_lang     = vd_lang */

/*M18G*/       /*IF THE SUPPLIER IS AVAILABLE THEN ASSIGN VD_LANG TO RQM_LANG.*/
/*M18G*/       rqm_lang     =
/*M18G*/                    (if available(vd_mstr) then vd_lang else rqm_lang)
               .

            /*CHECK AND SET THE OPEN AND APRV STATUS INDICATORS*/

            {gprun.i ""rqsetopn.p"" "(input rqm_nbr)"}

         end.  /* if in_repl_cntr = 1 */

         /* EXECUTION COMPLETE */
     out_return_code = 0.

     /******************************************************/
     /******************************************************/
     /**                 PROCEDURES                       **/
     /******************************************************/
     /******************************************************/

     procedure retrieve_vendor_item_data:
        define input param p_vendor like rqm_vend no-undo.
        define input param p_part like rqd_part no-undo.
        define output param p_got_vendor_item_data as log no-undo.
        define output param p_q_qty like rqd_req_qty no-undo.
        define output param p_q_um like rqd_um no-undo.
        define output param p_curr like rqm_curr no-undo.
        define output param p_vpart like rqd_vpart no-undo.
        define output param p_q_price like rqd_pur_cost no-undo.
        define output param p_mfgr like vp_mfgr no-undo.
        define output param p_mfgr_part like vp_mfgr_part no-undo.

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
          p_got_vendor_item_data = true
          .

                  leave.
               end.
            end.
         end procedure.
