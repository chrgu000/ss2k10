/* GUI CONVERTED from rqrqmt0.p (converter v1.76) Fri Apr  4 01:49:18 2003 */
/* rqrqmt0.p   - REQUISITION MAINTENANCE                                      */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.18.1.18 $                                                     */
/* Revision: 8.5    LAST MODIFIED: 04/22/97  BY: *J1Q2* B. Gates              */
/* REVISION: 8.5    LAST MODIFIED: 10/24/97  BY: *J24N* Patrick Rowan         */
/* REVISION: 8.6E   LAST MODIFIED: 02/23/98  BY: *L007* A. Rahane             */
/* REVISION: 8.6E   LAST MODIFIED: 03/31/98  BY: *J2G7* Samir Bavkar          */
/* REVISION: 8.6E   LAST MODIFIED: 05/20/98  BY: *K1Q4* Alfred Tan            */
/* REVISION: 8.6E   LAST MODIFIED: 03/18/98  BY: *J2GM* B. Gates              */
/* REVISION: 8.6E   LAST MODIFIED: 07/21/98  BY: *L040* Brenda Milton         */
/* REVISION: 8.6E   LAST MODIFIED: 08/13/98  BY: *K1QS* Dana Tunstall         */
/* REVISION: 8.6E   LAST MODIFIED: 09/09/99  BY: *J39R* Reetu Kapoor          */
/* REVISION: 9.1    LAST MODIFIED: 03/24/00  BY: *N08T* Annasaheb Rahane      */
/* REVISION: 9.1    LAST MODIFIED: 07/22/00  BY: *M0Q8* Manish K.             */
/* REVISION: 9.1    LAST MODIFIED: 08/12/00  BY: *N0KP* myb                   */
/* Revision: 1.18.1.5      BY: Murali Ayyagari   DATE: 10/30/01  ECO: *N15H*  */
/* Revision: 1.18.1.7      BY: Falguni Dalal     DATE: 11/19/01  ECO: *P02Y*  */
/* Revision: 1.18.1.10     BY: Anitha Gopal      DATE: 12/21/01  ECO: *N174*  */
/* Revision: 1.18.1.11     BY: Jose Alex         DATE: 05/21/02  ECO: *N1JK*  */
/* Revision: 1.18.1.12     BY: Mark Christian    DATE: 05/30/02  ECO: *N1K7*  */
/* Revision: 1.18.1.13     BY: Rajaneesh S.      DATE: 08/29/02  ECO: *M1BY*  */
/* Revision: 1.18.1.14     BY: Dan Herman        DATE: 12/30/02  ECO: *N236*  */
/* Revision: 1.18.1.15     BY: Dan Herman        DATE: 01/14/03  ECO: *N245*  */
/* Revision: 1.18.1.16     BY: Vivek Gogte       DATE: 02/27/03  ECO: *P0N8*  */
/* $Revision: 1.18.1.18 $            BY: Geeta Kotian      DATE: 03/28/03  ECO: *N2BS*  */
/* $Revision: eb2sp3 $      BY: Joy Huang  DATE: 07/07/04  ECO: *ZH002*     */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Maintenance                                                  */
/*NOTE: CHANGES MADE TO THIS PROGRAM MAY NEED TO BE MADE TO
REQUISITION DETAIL INQUIRY AND/OR REQUISITION MAINTENANCE
AND/OR REQUSITION REPORT.*/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{rqconst.i}

define variable mc-error-number like msg_nbr no-undo.
define variable continue as log no-undo.
define variable del-yn like mfc_logical no-undo.
define variable line as integer no-undo.
define variable new_req as logical no-undo.
define variable oldcurr like rqm_curr.
define variable get_rqmnbr like rqm_mstr.rqm_nbr no-undo.
define variable rqmnbr like rqm_mstr.rqm_nbr.
define variable email_opt_valid as logical no-undo.
define variable email_sent_to as character no-undo.
define variable approve_or_route as logical no-undo.
define variable i as integer no-undo.
define variable hdr_cmmts like COMMENTS no-undo.
define variable poc_pt_req as log no-undo.
define variable prev_status like rqm_status no-undo.
define variable prev_sub like rqm_sub no-undo.
define variable prev_cc like rqm_cc no-undo.
define variable prev_entity like rqm_entity no-undo.
define variable prev_job like rqm_job no-undo.
define variable prev_site like rqm_site no-undo.
define variable route_to like rqm_rtto_userid no-undo.
define variable yn like mfc_logical no-undo.
define variable temp_rate as decimal no-undo.
define variable temp_rate2 as decimal no-undo.
define variable temp_ratetype like exr_ratetype no-undo.
define variable total_frame_hdl as handle no-undo.
define new shared variable cmtindx as integer.
define new shared variable userid_modifying as character no-undo.
define variable l_prev_list            like rqm_pr_list  no-undo.
define variable l_prev_list2           like rqm_pr_list2 no-undo.
define variable l_cur_cost             as decimal        no-undo.
define variable l_base_cost            like rqd_pur_cost no-undo.
define variable l_vendor               like rqm_vend     no-undo.
define variable l_got_vendor_item_data like mfc_logical  no-undo.
define variable l_vendor_q_qty         like vp_q_qty     no-undo.
define variable l_vendor_q_um          like vp_um        no-undo.
define variable l_vendor_q_curr        like vp_curr      no-undo.
define variable l_vendor_part          like rqd_vpart    no-undo.
define variable l_vendor_price         like vp_q_price   no-undo.
define variable l_mfgr                 like vp_mfgr      no-undo.
define variable l_mfgr_part            like vp_mfgr_part no-undo.
define variable l_conversion_factor    as decimal        no-undo.
define variable l_got_vendor_price     like mfc_logical  no-undo.
define variable l_req_qty              like rqd_req_qty  no-undo.
define variable l_net_price            like pc_min_price no-undo.
define variable l_lineffdate           like rqm_due_date no-undo.
define variable l_minprice             like pc_min_price no-undo.
define variable l_maxprice             like pc_min_price no-undo.
define variable l_pc_recno             as recid          no-undo.
define variable l_ext_cost             like rqd_pur_cost no-undo.
define variable l_max_ext_cost         like rqd_max_cost no-undo.
define variable l_prev_ext_cost        like rqd_pur_cost no-undo.
define variable l_prev_max_ext_cost    like rqd_max_cost no-undo.
define variable l_prev_vend            like rqm_vend     no-undo.
define variable using_grs              like mfc_logical  no-undo.
define variable prohibit_changes       like mfc_logical  no-undo.
define variable l_net_price1           like pc_min_price no-undo.
define variable l_ext_cost1            like rqd_pur_cost no-undo.
define variable l_max_ext_cost1        like rqd_pur_cost no-undo.


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
rqm_mstr.rqm_nbr         colon 14
   rqm_vend        colon 36
   rqm_ship        colon 60
 SKIP(.4)  /*GUI*/
with frame a attr-space side-labels width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
rqm_req_date        colon 14
   rqm_sub             colon 36
   rqm_curr            colon 60
   rqm_need_date       colon 14
   rqm_cc              colon 36
   rqm_lang            colon 60
   rqm_due_date        colon 14
   rqm_site            colon 36
   rqm_direct          colon 60
   rqm_eby_userid      colon 14
   rqm_entity          colon 36
   email_opt_entry     colon 60
   rqm_rqby_userid     colon 14
   rqm_job             colon 36
   rqm_status          colon 60
   rqm_end_userid      colon 14
   rqm_project         colon 36
   hdr_cmmts           colon 60
   rqm_reason          colon 14
   rqm_aprv_stat   colon 60
   rqm_rmks            colon 14
 SKIP(.4)  /*GUI*/
with frame b attr-space side-labels width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-b-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
 RECT-FRAME-LABEL:HIDDEN in frame b = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame b =
  FRAME b:HEIGHT-PIXELS - RECT-FRAME:Y in frame b - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME b = FRAME b:WIDTH-CHARS - .5.  /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
rqm_disc_pct    colon 14
   rqm_pr_list2    colon 36
   rqm_pr_list     colon 68
 SKIP(.4)  /*GUI*/
with frame c attr-space side-labels width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-c-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame c = F-c-title.
 RECT-FRAME-LABEL:HIDDEN in frame c = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame c =
  FRAME c:HEIGHT-PIXELS - RECT-FRAME:Y in frame c - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME c = FRAME c:WIDTH-CHARS - .5.  /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

{mfadform.i "vend" 1 SUPPLIER}
{mfadform.i "ship_to" 41 SHIP_TO}

using_grs = can-find(mfc_ctrl
               where mfc_field   = "grs_installed"
                 and mfc_logical = yes).

if not using_grs then do:
   run p_ip_msg (input 2122, input 4).
   /*GRS not enabled*/
   if not batchrun then pause.
   leave.
end.

find first gl_ctrl no-lock.
find first poc_ctrl no-lock.
find first mfc_ctrl where mfc_field = "poc_pt_req" no-lock no-error.
if available mfc_ctrl then poc_pt_req = mfc_logical.

{gprun.i ""rqpma.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

find first rqf_ctrl no-lock.
/*GUI: view frame dtitle. */
IF global-tool-bar AND global-tool-bar-handle ne ? THEN
  view global-tool-bar-handle. /*GUI*/


if available rqf_ctrl then
    prohibit_changes = if rqf__qadc01 = "yes" then yes else no.

/*GET MOST RECENTLY ACCESSED REQ NUMBER AND DISPLAY*/
{gprun.i ""rqidf.p""
   "(input 'get', input 'reqnbr', input-output get_rqmnbr)"}
/*GUI*/ if global-beam-me-up then undo, leave.


display get_rqmnbr @ rqm_mstr.rqm_nbr with frame a.

mainloop:
repeat:
/*GUI*/ if global-beam-me-up then undo, leave.

   view frame a.
   view frame vend.
   view frame ship_to.
   view frame b.
   userid_modifying = global_userid.

   display
      approval_stat_desc @ rqm_aprv_stat
   with frame b.

   run get_rqm_nbr(output continue).
   if not continue then leave.

   /*BLANK REQ NBR ENTERED, CREATE A NEW ONE FROM CONTROL FILE*/
   if input frame a rqm_mstr.rqm_nbr = "" then
   do transaction:
      rqmnbr = "".

      find first rqf_ctrl exclusive-lock.

      if length(rqf_pre) + length(string(rqf_nbr)) > 8 then
         rqf_nbr = 1.

      rqmnbr = rqf_pre + string(rqf_nbr).

      do while can-find(first rqm_mstr where rqm_nbr = rqmnbr):
         rqf_nbr = rqf_nbr + 1.

         if length(rqf_pre) + length(string(rqf_nbr)) > 8 then
            rqf_nbr = 1.

         rqmnbr = rqf_pre + string(rqf_nbr).
      end.

      rqf_nbr = rqf_nbr + 1.

      if length(rqf_pre) + length(string(rqf_nbr)) > 8 then
         rqf_nbr = 1.

      release rqf_ctrl.

      display rqmnbr @ rqm_mstr.rqm_nbr with frame a.
   end.
   else do:
      find rqm_mstr using frame a rqm_nbr no-lock no-error.

      if available rqm_mstr then do:
         if rqm_rtdto_purch
         then
            run p_ip_msg (input 2106, input 2).
            /*REQUISITION ROUTED TO PURCHASING*/

         /* CHECK USER WHO IS MODIFYING THIS REQ.  MUST BE EITHER:
         * A) THE ORIGINAL ENTERER
         * B) THE REQUESTER
         * C) THE CURRENT ROUTE-TO USER*/

         if index(program-name(2),"rqapmt.") > 0
            and input frame a rqm_nbr = get_rqmnbr
         then do:
            /* SPECIAL CASE: IF THIS PROGRAM IS CALLED BY RQAPMT.P,
            * THEN RQAPMT.P PROVIDES A USERID (THE "APPROVER").
            * THIS ID IS USED INSTEAD OF GLOBAL_USERID FOR THE ABOVE
            * CHECKS, IF ATTEMPTING TO MODIFY THE REQ REFERENCED BY
            * RQAPMT.P.  THIS ALLOWS ALTERNATES DEFINED FOR THE
            * APPROVER TO MODIFY REQUISITIONS. */

            {gprun.i ""rqidf.p""
               "(input 'get', input 'approver',
                 input-output userid_modifying)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         end.

         /* If the approval process started for this req
          * don't allow editing */
         if prohibit_changes and
             userid_modifying <> rqm_buyer and
             can-find (first rqda_det where rqda_nbr = frame a rqm_nbr
                            and rqda_action = ACTION_APPROVE)
             then do:
                run p_ip_msg (input 5873, input 3).
             /*Cannot Edit. Approvals Exist For This Requisition*/
               undo, retry.
         end.

         if not
            (userid_modifying = rqm_eby_userid
            or
            userid_modifying = rqm_rqby_userid
            or
            userid_modifying = rqm_rtto_userid)
         then do:
            run p_ip_msg (input 2113, input 3).
            /*YOU MUST BE THE ENTERER, REQUESTOR, OR CURRENT ROUTE TO*/
            undo, retry.
         end.
      end.  /* if available rqm_mstr */
   end.  /* else do */

   find first rqf_ctrl no-lock.

   do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.

      assign
         prev_sub        = ""
         prev_cc         = ""
         prev_entity     = ""
         prev_job        = ""
         prev_site       = ""
         l_prev_vend     = ""
         l_ext_cost1     = 0
         l_max_ext_cost1 = 0.

      find rqm_mstr using frame a rqm_nbr exclusive-lock no-error.

      if available rqm_mstr then do:
         new_req = no.
         run p_ip_msg (input 10, input 1).
         /*MODIFYING EXISTING RECORD*/
         hdr_cmmts = rqm_cmtindx <> 0.

         assign
            prev_sub    = rqm_sub
            prev_cc     = rqm_cc
            prev_entity = rqm_entity
            prev_job    = rqm_job
            prev_site   = rqm_site
            l_prev_vend = rqm_vend.
      end.
      else do:
         new_req = yes.

         clear frame vend.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame vend = F-vend-title.
         clear frame ship_to.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame ship_to = F-ship_to-title.
         clear frame b.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.

         run p_ip_msg (input 1, input 1).
         /*ADDING NEW RECORD*/
         create rqm_mstr.

         assign
            rqm_curr = base_curr
            rqm_direct = false
            rqm_due_date = today
            rqm_email_opt = rqf_email_opt
            rqm_ent_date = today
            rqm_eby_userid = global_userid
            rqm_entity = gl_entity
            rqm_ex_rate = 1
            rqm_ex_rate2 = 1
            rqm_exru_seq = 0
            rqm_ex_ratetype = ""
            rqm_nbr = input frame a rqm_nbr
            rqm_need_date = today
            rqm_pent_userid = ?
            rqm_req_date = today
            rqm_rqby_userid = global_userid
            rqm_rtto_userid = global_userid
            rqm_aprv_stat = APPROVAL_STATUS_UNAPPROVED
            rqm_ship = poc_ship
            rqm_status = ""
            rqm_print = true.

         if recid(rqm_mstr) = -1 then.
      end.  /* else do */

      assign
         l_prev_list  = rqm_pr_list
         l_prev_list2 = rqm_pr_list2.

      run display_req(input recid(rqm_mstr), input true).

      do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


         oldcurr = rqm_curr.

         set rqm_vend with frame a
         editing:
            {mfnp.i
               vd_mstr rqm_vend vd_addr rqm_vend vd_addr vd_addr}

            if recno <> ? then do:
               display
                  vd_addr @ rqm_vend
               with frame a.

               {mfaddisp.i "input rqm_vend" vend}
            end.
         end.  /* set with editing */

         if rqm_vend > "" then do:
            find vd_mstr where vd_addr = rqm_vend no-lock no-error.

            if not available vd_mstr then do:
               run p_ip_msg (input 2, input 3).
               /*NOT A VALID SUPPLIER*/
               undo, retry.
            end.

            if new_req then do:
               assign
                  rqm_curr = vd_curr
                  rqm_lang = vd_lang
                  rqm_rmks = vd_rmks
                  rqm_buyer = vd_buyer
                  rqm_disc_pct = vd_disc_pct
                  rqm_pr_list = vd_pr_list
                  rqm_pr_list2 = vd_pr_list2.

               display
                  rqm_curr
                  rqm_lang
                  rqm_rmks
               with frame b.
            end.  /* if new_req */
            else do:
               if vd_curr <> rqm_curr then do:
                  {pxmsg.i &MSGNUM=2108 &ERRORLEVEL=2 &MSGARG1=vd_curr}
                  /*SUPPLIER CURRENCY IS*/
               end.

                if l_prev_vend = ""
                then do:
                   assign
                      rqm_lang     = vd_lang
                      rqm_buyer    = vd_buyer
                      rqm_pr_list  = vd_pr_list
                      rqm_pr_list2 = vd_pr_list2
                      rqm_rmks     = vd_rmks
                      rqm_disc_pct = vd_disc_pct.

                   display
                      rqm_lang
                      rqm_rmks
                      with frame b.
                end. /* IF l_prev_vend = "" */
            end.
         end.  /* if rqm_vend > "" */
      end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* do on error undo, retry */

      {mfaddisp.i rqm_vend vend}

      do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

         set rqm_ship with frame a
         editing:
            {mfnp.i
               ad_mstr rqm_ship ad_addr rqm_ship ad_addr ad_addr}

            if recno <> ? then do:
               display
                  ad_addr @ rqm_ship
               with frame a.

               {mfaddisp.i "input rqm_ship" ship_to}
            end.
         end.  /* set with editing */

         {mfaddisp.i rqm_ship ship_to}

         if rqm_ship > "" and not available ad_mstr then do:
            run p_ip_msg (input 13, input 3).
            /*NOT A VALID CHOICE*/
            undo, retry.
         end.
      end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* do on error undo, retry */

      ststatus = stline[2].
      status input ststatus.
      prev_status = rqm_status.

      do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

         set
            rqm_req_date
            rqm_need_date
            rqm_due_date
            rqm_rqby_userid
            rqm_end_userid
            rqm_reason
            rqm_rmks
            rqm_sub
            rqm_cc
            rqm_site
            rqm_entity
            rqm_job
            rqm_project
            rqm_curr  when (new_req)
            rqm_lang  when (new_req)
            rqm_direct    when (new_req)
            email_opt_entry
            rqm_status
            hdr_cmmts
            go-on (F5 "CTRL-D")
         with frame b.

         if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
         then do:
            find first rqpo_ref where rqpo_req_nbr = rqm_nbr
            no-lock no-error.

            if available rqpo_ref then do:
               run p_ip_msg (input 2081, input 3).
               /*CAN'T DELETE REQUISITION, REFERENCED BY POS*/
               undo, retry.
            end.

            del-yn = yes.
            {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
            /*PLEASE CONFIRM DELETE*/
            if not del-yn then undo, retry.
            line = 0.

            for each rqd_det exclusive-lock
                  where rqd_nbr = rqm_nbr:
/*GUI*/ if global-beam-me-up then undo, leave.

               for each cmt_det exclusive-lock
                     where cmt_indx = rqd_cmtindx:
                  delete cmt_det.
               end.

               /*DELETE ANY MRP DETAIL RECORDS*/

               for each mrp_det exclusive-lock
                     where mrp_dataset = "req_det"
                     and mrp_nbr = rqd_nbr
                     and mrp_line = string(rqd_line):
/*GUI*/ if global-beam-me-up then undo, leave.

                  {inmrp.i
                     &part=mrp_det.mrp_part &site=mrp_det.mrp_site}

                  delete mrp_det.
               end.
/*GUI*/ if global-beam-me-up then undo, leave.


               delete rqd_det.
               line = line + 1.
            end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* for each rqd_det */

            {pxmsg.i &MSGNUM=24 &ERRORLEVEL=1 &MSGARG1=line}
            /* LINE ITEM RECORD(S) DELETED  */
            hide message.

            for each cmt_det exclusive-lock
                  where cmt_indx = rqm_cmtindx:
               delete cmt_det.
            end.

            clear frame a.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
            clear frame b.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.

            /*SEND EMAILS*/

            email_sent_to = "".

            if not new_req then do:
               {gprun.i ""rqemsend.p""
                  "(input recid(rqm_mstr), input ACTION_DELETE_REQ,
                    output email_sent_to)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            end.

            /* WRITE HISTORY RECORD */

            {gprun.i ""rqwrthst.p""
               "(input rqm_nbr,
                 input 0,
                 input ACTION_DELETE_REQ,
                 input userid_modifying,
                 input '',
                 input email_sent_to)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            for each rqda_det exclusive-lock
                  where rqda_nbr = rqm_nbr:
               delete rqda_det.
            end.

            {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
               "(input rqm_exru_seq)"}

            delete rqm_mstr.

            next mainloop.
         end.  /* if F5 or CTRL-D */

         if rqm_req_date = ? then do:
            run p_ip_msg (input 27, input 3).
            /* INVALID DATE */
            next-prompt rqm_req_date with frame b.
            undo, retry.
         end.

         if rqm_need_date = ? then do:
            run p_ip_msg (input 27, input 3).
            /* INVALID DATE */
            next-prompt rqm_need_date with frame b.
            undo, retry.
         end.

         if rqm_due_date = ? then do:
            run p_ip_msg (input 27, input 3).
            /* INVALID DATE */
            next-prompt rqm_due_date with frame b.
            undo, retry.
         end.
         if new_req then do:
            if rqm_req_date < today then do:
               {pxmsg.i &MSGNUM=1949 &ERRORLEVEL=3
                        &MSGARG1="getTermLabel('REQUISITION',15)"}
               /*Requistion date cannot be before today */
              next-prompt rqm_req_date with frame b.
               undo, retry.
            end.

            if rqm_need_date < today then do:
               {pxmsg.i &MSGNUM=1949 &ERRORLEVEL=3
                        &MSGARG1="getTermLabel('NEED',6)"}
               /*Need date cannot be before today */
               next-prompt rqm_need_date with frame b.
               undo, retry.
            end.

            if rqm_due_date < today then do:
               {pxmsg.i &MSGNUM=1949 &ERRORLEVEL=3
                        &MSGARG1="getTermLabel('DUE',5)"}
               /*Due date cannot be before today */
               next-prompt rqm_due_date with frame b.
               undo, retry.
            end.
         end.  /* if new_req */

         if not can-find
            (usr_mstr where usr_userid = rqm_rqby_userid)
         then do:
            run p_ip_msg (input 2054, input 3).
            /* UNAVAILABLE USER */
            next-prompt rqm_rqby_userid with frame b.
            undo, retry.
         end.

         if not can-find
            (usr_mstr where usr_userid = rqm_end_userid)
         then do:
            run p_ip_msg (input 2054, input 3).
            /* UNAVAILABLE USER */
            next-prompt rqm_end_userid with frame b.
            undo, retry.
         end.

         if gl_verify then do:
            if rqm_sub > "" then do:
               if not can-find(sb_mstr where sb_sub = rqm_sub)
               then do:
                  run p_ip_msg (input 3131, input 3).
                  /* INVALID SUBACCOUNT CODE */
                  next-prompt rqm_sub with frame b.
                  undo, retry.
               end.
            end.

            if rqm_cc > "" then do:
               if not can-find(cc_mstr where cc_ctr = rqm_cc)
               then do:
                  run p_ip_msg (input 3057, input 3).
                  /* INVALID COST CENTER */
                  next-prompt rqm_cc with frame b.
                  undo, retry.
               end.
            end.
         end.  /* if gl_verify */

         if rqm_site > "" then do:
            if not can-find(si_mstr where si_site = rqm_site)
            then do:
               run p_ip_msg (input 708, input 3).
               /* SITE DOES NOT EXIST */
               next-prompt rqm_site with frame b.
               undo, retry.
            end.

            find si_mstr where si_site = rqm_site no-lock.

            if si_db <> global_db then do:
               run p_ip_msg (input 5421, input 3).
               /* SITE IS NOT ASSIGNED TO THIS DATABASE */
               next-prompt rqm_site with frame b.
               undo, retry.
            end.

            /* CHANGED MESSAGE FROM ERROR TO WARNING SO THAT        */
            /* MULTI-ENTITY IS ALLOWED WHILE REQUISITION GENERATION */
            if si_entity <> rqm_entity then do:
               run p_ip_msg (input 2107, input 2).
               /* SITE ENTITY DOES NOT MATCH REQUISITION ENTITY */
            end. /* IF si_entity <> rqm_entity */
         end.  /* if rqm_site > "" */

         if not can-find(en_mstr where en_entity = rqm_entity)
            and rqm_entity <> gl_entity
         then do:
            run p_ip_msg (input 3061, input 3).
            /* INVALID ENTITY */
            next-prompt rqm_entity with frame b.
            undo, retry.
         end.

         {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
            "(input input rqm_curr,
              output mc-error-number)"}
         if mc-error-number <> 0 then do:
            run p_ip_msg (input mc-error-number, input 3).
            next-prompt rqm_curr with frame b.
            undo, retry.
         end.

         if rqm_curr <> rqf_appr_curr then do:

            {gprun.i ""rqexrt.p""
               "(input rqm_curr,
                 input rqf_appr_curr,
                 input temp_ratetype,
                 output temp_rate,
                 output temp_rate2,
                 output mc-error-number)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            if mc-error-number <> 0 then do:
               run p_ip_msg (input 2087, input 3).
               /* NO EXCHANGE RATE FOR APPROVAL CURRENCY */
               undo, retry.
            end.
         end.

         if new_req and rqm_curr <> base_curr then do:
            /* CREATE EXCHANGE RATE USAGE RECORDS */
            {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
               "(input rqm_curr,
                 input base_curr,
                 input rqm_ex_ratetype,
                 input rqm_req_date,
                 output rqm_ex_rate,
                 output rqm_ex_rate2,
                 output rqm_exru_seq,
                 output mc-error-number)"}
            if mc-error-number <> 0 then do:
               run p_ip_msg (input mc-error-number, input 3).
               undo, retry.
            end.
         end.

         if rqm_job > ""
            and not can-find(first rqj_mstr where rqj_job = rqm_job)
         then do:
            run p_ip_msg (input 2066, input 3).
            /* INVALID JOB */
            next-prompt rqm_job with frame b.
            undo, retry.
         end.

         do with frame b:
            if not ({gpglproj.v rqm_project}) then do:
               run p_ip_msg (input 3128, input 3).
               /* INVALID PROJECT */
               next-prompt rqm_project with frame b.
               undo, retry.
            end.
         end.

         if rqm_status <> ""  and
            rqm_status <> "x" and
            rqm_status <> "c" then do:
            run p_ip_msg (input 19, input 3).
            /* INVALID STATUS */
            next-prompt rqm_status with frame b.
            undo, retry.
         end.

         if prev_status = "" and rqm_status = "x" then do:
            find first rqpo_ref where rqpo_req_nbr = rqm_nbr
            no-lock no-error.

            if available rqpo_ref then do:
               run p_ip_msg (input 2079, input 3).
               /* CAN'T CANCEL REQUISITION, REFERENCED BY POS */
               next-prompt rqm_status with frame b.
               undo, retry.
            end.
         end.

         {gplngv.i
            &file=""rqf_ctrl""
            &field=""rqf_email_opt""
            &mnemonic=email_opt_entry
            &isvalid=email_opt_valid}

         if not email_opt_valid then do:
            run p_ip_msg (input 2092, input 3).
            /* NOT A VALID EMAIL OPTION */
            next-prompt email_opt_entry with frame b.
            undo, retry.
         end.

         /* CAN'T USE EMAIL IF CONTROL FILE OPTION SAYS NO EMAIL */
         if rqf_email_opt = EMAIL_OPT_NO_EMAIL then do:
            {gplnga2n.i
               &file=""rqf_ctrl""
               &field=""rqf_email_opt""
               &code=rqm_email_opt
               &mnemonic=email_opt_entry
               &label=email_opt_desc}

            if rqm_email_opt <> EMAIL_OPT_NO_EMAIL then do:
               run p_ip_msg (input 2092, input 3).
               /* NOT A VALID EMAIL OPTION */
               next-prompt email_opt_entry with frame b.
               undo, retry.
            end.
         end.
      end.
/*GUI*/ if global-beam-me-up then undo, leave.


      /* GET DISC%, PRICE TABLE CODE, DISC TABLE CODE FROM USER */

      hide frame b no-pause.

      /* GET DEFAULT PRICE AND DISCOUNT LISTS */
      for first vd_mstr
         fields (vd_addr vd_buyer vd_curr vd_disc_pct vd_lang vd_pr_list
                 vd_pr_list2 vd_rmks)
         where vd_addr = rqm_vend
         no-lock:
      end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR FIRST vd_mstr */
      if available vd_mstr and
         new_req
      then
         assign
            rqm_pr_list  = vd_pr_list
            rqm_pr_list2 = vd_pr_list2.

      display
         rqm_disc_pct
         rqm_pr_list2
         rqm_pr_list
      with frame c.

      setpriceinfo:
      do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

         set
            rqm_disc_pct
            rqm_pr_list2
            rqm_pr_list
         with frame c.

         /* CHECK PRICE LIST */

         {adprclst.i
            &price-list     = "rqm_pr_list2"
            &curr           = "rqm_curr"
            &price-list-req = "poc_pt_req"
            &undo-label     = "setpriceinfo"
            &with-frame     = "with frame c"
            &disp-msg       = "yes"
            &warning        = "yes"}

         /*CHECK DISCOUNT LIST*/

         {addsclst.i
            &disc-list      = "rqm_pr_list"
            &curr           = "rqm_curr"
            &disc-list-req  = "poc_pl_req"
            &undo-label     = "setpriceinfo"
            &with-frame     = "with frame c"
            &disp-msg       = "yes"
            &warning        = "yes"}
      end.
/*GUI*/ if global-beam-me-up then undo, leave.


      /* USER CHANGING STATUS FROM CANCELLED TO OPEN */
      /* OR USER CHANGING STATUS FROM CLOSED TO OPEN */

      if (prev_status = "x"  or
         prev_status = "c") and
         rqm_status = "" then do:
         yn = no.
         {pxmsg.i &MSGNUM=2084 &ERRORLEVEL=1 &CONFIRM=yn}
         /* DO YOU WISH TO REOPEN ALL REQUISITION LINE ITEMS? */

         if yn then do:
            run reopen_all_line_records(input recid(rqm_mstr)).
         end.
      end.

      /* USER CHANGING STATUS FROM OPEN TO CANCELLED */
      if prev_status = "" and rqm_status = "x" then do:
         run cancel_requisition(input recid(rqm_mstr)).
      end.

      /** USER CHANGING STATUS FROM OPEN TO CLOSED **/

      if prev_status = "" and
         rqm_status = "c" then do:
         run close_requisition(input recid(rqm_mstr)).
      end. /* IF PREV_STATUS = " " AND ... */

      if   not new_req
      and (rqm_pr_list  <> l_prev_list or
           rqm_pr_list2 <> l_prev_list2)
      then do:

         /* RECALCULATE ITEM PRICE AND COST */
         {pxmsg.i &MSGNUM=640 &ERRORLEVEL=1 &CONFIRM=yn &CONFIRM-TYPE='LOGICAL'}

         if yn
         then
            run recalc_price_cost (buffer rqm_mstr).

      end. /* IF NOT new_req ... */

      /* GET EMAIL OPTION INTERNAL VALUE */

      {gplnga2n.i
         &file=""rqf_ctrl""
         &field=""rqf_email_opt""
         &code=rqm_email_opt
         &mnemonic=email_opt_entry
         &label=email_opt_desc}

      /* COMMENTS */

      assign
         global_type = ""
         global_lang = rqm_lang.

      if hdr_cmmts then do:
         hide frame c no-pause.
         hide frame b no-pause.
         hide frame vend no-pause.
         hide frame ship_to no-pause.
         hide frame a no-pause.

         assign
            global_ref = rqm_vend
            cmtindx = rqm_cmtindx.

         {gprun.i ""gpcmmt01.p"" "(input ""po_mstr"")"}
/*GUI*/ if global-beam-me-up then undo, leave.


         rqm_cmtindx = cmtindx.
      end.
   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* do transaction */

   /* LINE ITEM DATA ENTRY */

   hide frame c no-pause.
   hide frame b no-pause.
   hide frame vend no-pause.
   hide frame ship_to no-pause.
   hide frame a no-pause.

/*ZH002     {gprun.i ""rqrqmta.p""
               "(input recid(rqm_mstr), input new_req)"}*/
/*ZH002*/   {gprun.i ""xxrqrqmta.p""
               "(input recid(rqm_mstr), input new_req)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   view frame a.

   /* SEND EMAILS */

   email_sent_to = "".

   if not new_req then do:
      {gprun.i ""rqemsend.p""
         "(input recid(rqm_mstr), input ACTION_MODIFY_REQ,
           output email_sent_to)"}
/*GUI*/ if global-beam-me-up then undo, leave.

   end.

   /* WRITE HISTORY RECORD */

   if new_req then action_entry = ACTION_CREATE_REQ.
   else action_entry = ACTION_MODIFY_REQ.

   {gprun.i ""rqwrthst.p""
      "(input rqm_nbr,
        input 0,
        input action_entry,
        input userid_modifying,
        input '',
        input email_sent_to)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   /* CHECK AND SET THE OPEN AND APRV STATUS INDICATORS */

   {gprun.i ""rqsetopn.p"" "(input rqm_nbr)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   /* SAVE ACCESSED REQ NUMBER FOR OTHER PGMS TO USE */

   get_rqmnbr = rqm_nbr.

   {gprun.i ""rqidf.p""
      "(input 'put', input 'reqnbr', input-output get_rqmnbr)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   /* IF RQAPMT.P OR RQRTMT.P IS A CALLING PROGRAM
    * (EITHER DIRECT OR THIS CALLED FROM AN FKEY)
    * JUST DISPLAY TOTALS, OTHERWISE ASK THE
    * USER IF TO INVOKE RQAPMT.P */

   i = 1.

   do while program-name(i) <> ?:
      if index(program-name(i),"rqapmt.") > 0
         or index(program-name(i),"rqrtmt.") > 0
         then leave.

      i = i + 1.
   end.

   {gprun.i ""rqtotdsp.p""
      "(input recid(rqm_mstr), output total_frame_hdl)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   if program-name(i) <> ? then do:
      do on endkey undo, leave:
         pause.
      end.
   end.

   if program-name(i) = ? then do:
      approve_or_route = false.

      do on endkey undo, leave:
         {pxmsg.i &MSGNUM=2083 &ERRORLEVEL=1 &CONFIRM=approve_or_route}
         /* ROUTE THIS REQUISITION? */
      end.

      if approve_or_route then do:

         /* SAVE CURRENT ROUTE-TO FOR RQRTMT.P */
         route_to = rqm_rtto_userid.

         {gprun.i ""rqidf.p""
            "(input 'put', input 'approver',
              input-output route_to)"}
/*GUI*/ if global-beam-me-up then undo, leave.


         {gprun.i ""rqrtmt0.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

      end.
   end.

   /* THE FOLLOWING IS BECAUSE THE TOTAL FRAME IS STILL
   * VISIBLE AFTER RETURNING FROM RQTOTDSP.P */

   if valid-handle(total_frame_hdl)
      then total_frame_hdl:hidden = true.

   hide frame c no-pause.
   hide frame b no-pause.
   hide frame vend no-pause.
   hide frame ship_to no-pause.
   hide frame a no-pause.

   /* UPDATE APPROVAL_STAT_DESC WITH FINAL VALUE OF RQM_APRV_STAT */
   {gplngn2a.i
      &file     = ""rqm_mstr""
      &field    = ""rqm_aprv_stat""
      &code     = rqm_aprv_stat
      &mnemonic = approval_stat_entry
      &label    = approval_stat_desc}

   release rqm_mstr.
end. /* mainloop: repeat */

if valid-handle(total_frame_hdl)
   then total_frame_hdl:hidden = true.

hide frame c no-pause.
hide frame b no-pause.
hide frame vend no-pause.
hide frame ship_to no-pause.
hide frame a no-pause.

/******************************************************/
/******************************************************/
/**                 PROCEDURES                       **/
/******************************************************/
/******************************************************/

PROCEDURE cancel_requisition:
   define input parameter p_rqm_recid as recid no-undo.

   find rqm_mstr where recid(rqm_mstr) = p_rqm_recid exclusive-lock.
   rqm_total = 0.
   rqm_max_total = 0.

   for each rqd_det exclusive-lock
         where rqd_nbr = rqm_nbr:
/*GUI*/ if global-beam-me-up then undo, leave.

      rqd_status = "x".

      /* UPDATE MRP */

      {gprun.i ""rqmrw.p""
         "(input false, input rqd_site, input rqd_nbr,
           input rqd_line)"}
/*GUI*/ if global-beam-me-up then undo, leave.

   end.
/*GUI*/ if global-beam-me-up then undo, leave.


   run p_ip_msg (input 2098, input 3).
   /* REQUISITION CANCELLED */
END PROCEDURE.

PROCEDURE reopen_all_line_records:
   define input parameter p_rqm_recid as recid no-undo.

   find rqm_mstr where recid(rqm_mstr) = p_rqm_recid exclusive-lock.

   for each rqd_det exclusive-lock
         where rqd_nbr = rqm_nbr:
/*GUI*/ if global-beam-me-up then undo, leave.

      rqd_status = "".

      /* UPDATE MRP */

      run p_calc_netprice(buffer rqd_det).

      {gprun.i ""rqmrw.p""
         "(input false, input rqd_site, input rqd_nbr,
           input rqd_line)"}
/*GUI*/ if global-beam-me-up then undo, leave.


      assign
         l_ext_cost1     = l_ext_cost1 + (if rqd_pur_cost <> 0
                                         then
                                            rqd_req_qty * rqd_pur_cost
                                            * (1 - (- (l_net_price1
                                                       - rqd_pur_cost)
                                            / (rqd_pur_cost / 100)) / 100)
                                         else
                                            0)
         l_max_ext_cost1 = l_max_ext_cost1 + (rqd_req_qty * rqd_max_cost).

   end.
/*GUI*/ if global-beam-me-up then undo, leave.


   assign
      rqm_total     = l_ext_cost1
      rqm_max_total = l_max_ext_cost1.

   run p_ip_msg (input 2104, input 1).
   /* REQUISITION REOPENED */
END PROCEDURE.

PROCEDURE get_rqm_nbr:
   define output parameter p_continue as log no-undo.

   p_continue = false.

   do on endkey undo, leave:
      prompt-for rqm_mstr.rqm_nbr with frame a
      editing:
         {mfnp.i rqm_mstr rqm_nbr rqm_nbr rqm_nbr rqm_nbr rqm_nbr}

         if recno <> ? then do:
            run display_req(input recno, input false).
         end.
      end.

      p_continue = true.
   end.
END PROCEDURE.

PROCEDURE display_req:
   define input parameter p_rqm_recid as recid no-undo.
   define input parameter p_exclusive_lock as log no-undo.

   find first rqf_ctrl no-lock.

   if p_exclusive_lock then
      find rqm_mstr where recid(rqm_mstr) = p_rqm_recid exclusive-lock.
   else
      find rqm_mstr where recid(rqm_mstr) = p_rqm_recid no-lock.

   if new_req then hdr_cmmts = rqf_hcmmts.
   else hdr_cmmts = rqm_cmtindx <> 0.

   display
      rqm_nbr
      rqm_vend
      rqm_ship
   with frame a.

   {mfaddisp.i rqm_vend vend}
   {mfaddisp.i rqm_ship ship_to}

   {gplngn2a.i
      &file=""rqf_ctrl""
      &field=""rqf_email_opt""
      &code=rqm_email_opt
      &mnemonic=email_opt_entry
      &label=email_opt_desc}

   {gplngn2a.i
      &file=""rqm_mstr""
      &field=""rqm_aprv_stat""
      &code=rqm_aprv_stat
      &mnemonic=approval_stat_entry
      &label=approval_stat_desc}

   display
      rqm_req_date
      rqm_need_date
      rqm_due_date
      rqm_eby_userid
      rqm_rqby_userid
      rqm_end_userid
      rqm_reason
      rqm_rmks
      rqm_sub
      rqm_cc
      rqm_site
      rqm_entity
      rqm_job
      rqm_project
      rqm_curr
      rqm_lang
      rqm_direct
      email_opt_entry
      rqm_status
      hdr_cmmts
      approval_stat_desc @ rqm_aprv_stat
   with frame b.
END PROCEDURE.

/* TO CLOSE A REQUISITION */
PROCEDURE close_requisition:

   define input parameter p_rqm_recid as recid no-undo.

   find rqm_mstr
      where recid(rqm_mstr) = p_rqm_recid
   exclusive-lock no-error.
   assign
      rqm_total     = 0
      rqm_max_total = 0.

   for each rqd_det exclusive-lock
         where rqd_nbr    = rqm_nbr
         and rqd_status = "":
/*GUI*/ if global-beam-me-up then undo, leave.

      assign rqd_status = "c".

      /*UPDATE MRP*/
      {gprun.i ""rqmrw.p""
         "(input false,
           input rqd_site,
           input rqd_nbr,
           input rqd_line)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH RQD_DET */

   run p_ip_msg (input 3325, input 1).
   /* REQUISITION IS CLOSED */

END PROCEDURE. /* PROCEDURE CLOSE_REQUISITION */

PROCEDURE retrieve_vendor_item_data:

   define input  parameter p_vendor               like rqm_vend     no-undo.
   define input  parameter p_part                 like rqd_part     no-undo.
   define output parameter p_got_vendor_item_data like mfc_logical  no-undo.
   define output parameter p_q_qty                like rqd_req_qty  no-undo.
   define output parameter p_q_um                 like rqd_um       no-undo.
   define output parameter p_curr                 like rqm_curr     no-undo.
   define output parameter p_vpart                like rqd_vpart    no-undo.
   define output parameter p_q_price              like rqd_pur_cost no-undo.
   define output parameter p_mfgr                 like vp_mfgr      no-undo.
   define output parameter p_mfgr_part            like vp_mfgr_part no-undo.

   p_got_vendor_item_data = false.

   for each vp_mstr
      fields (vp_curr vp_mfgr vp_mfgr_part vp_part vp_q_date vp_q_price
              vp_q_qty vp_um vp_vend vp_vend_part)
      no-lock
      where vp_part = p_part
        and vp_vend = p_vendor
      break by vp_q_date descending:

      if first(vp_q_date)
      then do:
         assign
            p_q_qty                = vp_q_qty
            p_q_um                 = vp_um
            p_curr                 = vp_curr
            p_vpart                = vp_vend_part
            p_q_price              = vp_q_price
            p_mfgr                 = vp_mfgr
            p_mfgr_part            = vp_mfgr_part
            p_got_vendor_item_data = true.

         leave.
      end. /* IF FIRST(vp_q_date) */

   end. /* FOR EACH vp_mstr */

END PROCEDURE. /* RETRIEVE_VENDOR_ITEM_DATA */

PROCEDURE p_ip_msg:

   define input parameter l_num  as integer no-undo.
   define input parameter l_stat as integer no-undo.

   {pxmsg.i &MSGNUM=l_num &ERRORLEVEL=l_stat}

END PROCEDURE. /* P_IP_MSG */

PROCEDURE recalc_price_cost:

   define parameter buffer rqm_mstr for rqm_mstr.

   /* THE REQUISITION STATUS SHOULD BE CHANGED TO UNAPPROVED */
   /* IF COSTS ARE RECALCULATED.                             */
   if (rqm_status = "x"
   or  rqm_status = "c")
   then
      run reopen_all_line_records(input recid(rqm_mstr)).

   loop-rqd-det:
   for each rqd_det
      where rqd_vend      =  rqm_vend
        and rqd_nbr       =  rqm_nbr
        and rqd_type      <> "M"
        and (rqd_pr_list  <> rqm_pr_list
         or  rqd_pr_list2 <> rqm_pr_list2)
      exclusive-lock:

      assign
         l_prev_ext_cost     = rqd_req_qty * rqd_pur_cost
                               * (1 - (rqd_disc_pct / 100))
         l_prev_max_ext_cost = rqd_req_qty * rqd_max_cost
         rqd_pr_list         = rqm_pr_list
         rqd_pr_list2        = rqm_pr_list2.

      for first pt_mstr
         fields (pt_abc pt_avg_int pt_bom_code pt_cyc_int pt_desc1 pt_desc2
                 pt_insp_lead pt_insp_rqd pt_joint_type pt_loc pt_mfg_lead
                 pt_mrp pt_network pt_ord_max pt_ord_min pt_ord_mult pt_ord_per
                 pt_ord_pol pt_ord_qty pt_part pt_plan_ord pt_pm_code
                 pt_prod_line pt_pur_lead pt_rctpo_active pt_rctpo_status
                 pt_rctwo_active pt_rctwo_status pt_routing pt_sfty_time
                 pt_timefence pt_um pt_yield_pct)
         where pt_part = rqd_part
         no-lock:
      end. /* FOR FIRST pt_mstr */

      if available pt_mstr
      then do:

         /* INITIAL DEFAULT FOR PRICE */
         assign
            l_vendor_part      = ""
            l_mfgr             = ""
            l_mfgr_part        = ""
            l_vendor           = rqd_vend
            l_got_vendor_price = false.

         /* FIND STANDARD COST AND GL COST */
         {gprun.i ""gpsct05.p""
            "(input  rqd_part,
              input  rqd_site,
              input  2,
              output glxcst,
              output l_cur_cost)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         l_base_cost = glxcst * rqd_um_conv.

         if l_vendor > ""
         then do:

            /* RETRIEVE VENDOR ITEM DATA */
            run retrieve_vendor_item_data
               (input  rqd_vend,
                input  rqd_part,
                output l_got_vendor_item_data,
                output l_vendor_q_qty,
                output l_vendor_q_um,
                output l_vendor_q_curr,
                output l_vendor_part,
                output l_vendor_price,
                output l_mfgr,
                output l_mfgr_part).

            if  l_got_vendor_item_data
            and l_vendor_price <> 0
            then do:

               if (l_vendor_q_curr = rqm_curr
               or  l_vendor_q_curr = "")
               then do:

                  /* CONVERT PRICE PER UM CONVERSION */
                  if l_vendor_q_um = rqd_um
                  then
                     l_conversion_factor = 1.

                  else do:
                     {gprun.i ""gpumcnv.p""
                        "(input  l_vendor_q_um,
                          input  rqd_um,
                          input  rqd_part,
                          output l_conversion_factor)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                  end. /* ELSE DO */

                  if l_conversion_factor = ?
                  then do:
                     /* NO UM CONVERSION EXISTS FOR SUPPLIER ITEM */
                     {pxmsg.i
                        &MSGNUM     = 2086
                        &ERRORLEVEL = 2
                        &MSGARG1    = l_vendor_part}
                  end. /* IF l_conversion_factor = ? */

                  /* ONLY CONVERT TO THE VENDOR ITEM */
                  /* PRICE IF THE UM MATCHES AND THE */
                  /* RQ QTY IS >= THAN THE QUOTE QTY */
                  if l_vendor_q_um = rqd_um
                  then do:
                     if rqd_req_qty >= l_vendor_q_qty
                     then
                        assign
                           rqd_pur_cost       =
                              l_vendor_price / l_conversion_factor
                           l_got_vendor_price = true.
                  end. /* IF l_vendor_q_um = rqd_um */

                  else do:
                     l_req_qty = rqd_req_qty / l_conversion_factor.

                     if l_req_qty >= l_vendor_q_qty
                     then
                        assign
                           rqd_pur_cost       =
                              l_vendor_price / l_conversion_factor
                           l_got_vendor_price = true.

                  end. /* ELSE DO: */

               end.  /* IF l_vendor_q_curr = rqm_curr or "" */

               else do:
                  /* SUPPLIER ITEM NOT FOR SAME CURRENCY */
                  {pxmsg.i
                     &MSGNUM     = 2109
                     &ERRORLEVEL = 2
                     &MSGARG1    = l_vendor_q_curr}
               end. /* ELSE DO */

            end. /* IF l_got_vendor_item_data AND l_vendor_price <> 0   */

         end. /* IF l_vendor > "" */

         /* DIDN'T FIND A VENDOR PART PRICE, USE STD COST */
         if not l_got_vendor_price
         then do:

            /* CONVERT FROM BASE TO FOREIGN CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input  base_curr,
                 input  rqm_curr,
                 input  rqm_ex_rate2,
                 input  rqm_ex_rate,
                 input  glxcst,
                 input  false, /* DO NOT ROUND */
                 output rqd_pur_cost,
                 output mc-error-number)"}.

            /* CONVERT PRICE PER UM CONVERSION */
            if pt_um = rqd_um
            then
               l_conversion_factor = 1.
            else do:
               {gprun.i ""gpumcnv.p""
                  "(input  rqd_um,
                    input  pt_um,
                    input  rqd_part,
                    output l_conversion_factor)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            end. /* ELSE DO */

            if l_conversion_factor = ?
            then do:
               /* NO UM CONVERSION EXISTS */
               {pxmsg.i
                  &MSGNUM     = 33
                  &ERRORLEVEL = 2
                  &MSGARG1    = rqd_um}
            end. /* IF l_conversion_factor = ? */
            else
               rqd_pur_cost = rqd_pur_cost * l_conversion_factor.

         end. /* IF NOT l_got_vendor_price */
      end.  /* IF AVAILABLE pt_mstr */
      else
         /*RESET COST FIELDS*/
         rqd_pur_cost = 0.

      /* INITIAL DEFAULT FOR DISCOUNT */
      assign
         rqd_disc_pct = rqm_disc_pct

         /* GET PRICE FROM PRICE TABLES IF THERE IS ONE */
         l_net_price  = rqd_pur_cost * (1 - rqd_disc_pct / 100)

         l_lineffdate = rqd_due_date.

      if l_lineffdate = ?
      then
         l_lineffdate = if rqm_req_date <> ?
                        then
                           rqm_req_date
                        else
                           today.

      if rqd_pr_list2 <> ""
      then do:
         l_net_price = ?.
         {gprun.i ""gppclst.p""
            "(input        rqd_pr_list2,
              input        rqd_part,
              input        rqd_um,
              input        rqd_um_conv,
              input        l_lineffdate,
              input        rqm_curr,
              input        true,
              input        poc_pt_req,
              input-output rqd_pur_cost,
              input-output l_net_price,
              output       l_minprice,
              output       l_maxprice,
              output       l_pc_recno)" }
/*GUI*/ if global-beam-me-up then undo, leave.


         if l_net_price <> ?
         then
            l_net_price = l_net_price * (1 - rqd_disc_pct / 100).
      end. /* IF rqd_pr_list2 <> "" */

      if poc_pt_req
         and (   rqd_pr_list2 = ""
              or l_pc_recno   = 0)
      then do:

         /* DISPLAY ERROR IF IT IS INVENTORY ITEM */
         if can-find (pt_mstr
               where pt_part = rqd_part)
         then do:
            /* REQUIRED PRICE TABLE FOR ITEM # IN UM # NOT FOUND */
            {pxmsg.i
               &MSGNUM     = 6231
               &ERRORLEVEL = 3
               &MSGARG1    = rqd_part
               &MSGARG2    = rqd_um}

            undo loop-rqd-det, next loop-rqd-det.
         end. /* IF CAN-FIND pt_mstr ... */

         /* DISPLAY WARNING IF IT IS MEMO ITEM */
         else do:

            /* REQUIRED PRICE TABLE FOR ITEM # IN UM # NOT FOUND */
            {pxmsg.i
            &MSGNUM     = 6231
            &ERRORLEVEL = 2
            &MSGARG1    = rqd_part
            &MSGARG2    = rqd_um}

         end. /* ELSE DO ... */

      end. /* IF poc_pt_req ... */

      /* GET DISCOUNT FROM DISCOUNT TABLES IF THERE IS ONE */
      if rqd_pr_list <> ""
      then do:
         {gprun.i ""gppccal.p""
            "(input        rqd_part,
              input        rqd_req_qty,
              input        rqd_um,
              input        rqd_um_conv,
              input        rqm_curr,
              input        rqd_pr_list,
              input        l_lineffdate,
              input        rqd_pur_cost,
              input        poc_ctrl.poc_pl_req,
              input        rqm_disc_pct,
              input-output rqd_pur_cost,
              output       rqd_disc_pct,
              input-output l_net_price,
              output       l_pc_recno)" }
/*GUI*/ if global-beam-me-up then undo, leave.

      end. /* IF rqd_pr_list <> "" */

      if poc_ctrl.poc_pl_req
         and (   rqd_pr_list = ""
              or l_pc_recno  = 0)
      then do:

         /* DISPLAY ERROR IF IT IS INVENTORY ITEM */
         if can-find (pt_mstr
               where pt_part = rqd_part)
         then do:

            /* REQUIRED DISCOUNT TABLE FOR ITEM # IN */
            /* UM # NOT FOUND                        */
            {pxmsg.i
               &MSGNUM     = 982
               &ERRORLEVEL = 3
               &MSGARG1    = rqd_part
               &MSGARG2    = rqd_um}

            undo loop-rqd-det, next loop-rqd-det.
         end. /* IF CAN-FIND pt_mstr ... */

         /* DISPLAY WARNING IF IT IS MEMO ITEM */
         else do:

            /* REQUIRED DISCOUNT TABLE FOR ITEM # IN UM # NOT FOUND */
            {pxmsg.i
               &MSGNUM     = 982
               &ERRORLEVEL = 2
               &MSGARG1    = rqd_part
               &MSGARG2    = rqd_um}

         end. /* ELSE DO ... */

      end. /* IF poc_ctrl.poc_pl_req ... */

      /* UNIT COST IS SET TO NET PRICE WHEN THERE IS NO       */
      /* STANDARD COST ON THE ITEM BUT THE REQ. REFERS        */
      /* TO A PRICE TABLE OR DISCOUNT TABLE.  THE DISC% IS    */
      /* RETURNED AS 0.00 SINCE IT IS BASED ON THE UNIT COST. */
      /* THE NET PRICE IS PASSED BACK FROM THE SUB-PROGRAMS   */
      /* AND PLUGGED INTO THE UNIT COST FIELD TO SHOW THE     */
      /* DISCOUNTED PRICE.                                    */
      if rqd_pur_cost = 0 and
         l_net_price <> ?
      then
         rqd_pur_cost = l_net_price.

      assign
         rqd_max_cost   = if rqd_disc_pct < 0
                          then
                             rqd_pur_cost
                             * (1 - rqd_disc_pct / 100)
                          else
                             rqd_pur_cost

         /* SET LINE STATUS */
         rqd_aprv_stat  = APPROVAL_STATUS_UNAPPROVED

         /* UPDATE REQUISITION TOTALS AND STATUS */
         l_ext_cost     = rqd_req_qty * rqd_pur_cost
                          * (1 - (rqd_disc_pct / 100))
         l_max_ext_cost = rqd_req_qty * rqd_max_cost
         rqm_total      = rqm_total + l_ext_cost - l_prev_ext_cost
         rqm_max_total  = rqm_max_total + l_max_ext_cost
                         - l_prev_max_ext_cost
         action_entry   = ACTION_MODIFY_REQ_LINE
         rqm_status     = ""
         rqm_aprv_stat  = APPROVAL_STATUS_UNAPPROVED.

      /* WRITE HISTORY RECORD */
      {gprun.i ""rqwrthst.p""
         "(input rqm_nbr,
           input rqd_line,
           input action_entry,
           input userid_modifying,
           input '',
           input '')"}
/*GUI*/ if global-beam-me-up then undo, leave.


   end. /* FOR EACH rqd_det */

END PROCEDURE. /* RECALC_PRICE_COST */

PROCEDURE p_calc_netprice:

   /* TO CALCULATE THE NET PRICE FOR REQUISITION LINE */

   define parameter buffer rqddet for rqd_det.

   if available rqddet
   then do:
      if rqddet.rqd__qadc01 <> ""
      then
         l_net_price1 = decimal(rqddet.rqd__qadc01).
      else
         l_net_price1 = rqddet.rqd_pur_cost
                     * (1 - rqddet.rqd_disc_pct / 100).
   end. /* IF AVAILABLE rqddet */
   else
      l_net_price1 = 0.

END. /* PROCEDURE p_calc_netprice */
