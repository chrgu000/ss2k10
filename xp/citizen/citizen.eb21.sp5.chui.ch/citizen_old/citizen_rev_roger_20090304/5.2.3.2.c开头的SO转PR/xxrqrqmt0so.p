/* rqrqmt0.p   - REQUISITION MAINTENANCE                                      */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
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
/* Revision: 1.18.1.18  BY: Geeta Kotian         DATE: 03/28/03 ECO: *N2BS*   */
/* Revision: 1.18.1.20  BY: Paul Donnelly (SB)   DATE: 06/28/03 ECO: *Q00L*   */
/* Revision: 1.18.1.21  BY: Rajinder Kamra       DATE: 06/23/03  ECO *Q003*   */
/* Revision: 1.18.1.25  BY: Katie Hilbert        DATE: 01/08/04  ECO: *P1J4*  */
/* Revision: 1.18.1.26     BY: Ken Casey         DATE: 02/19/04  ECO: *N2GM*  */
/* Revision: 1.18.1.27     BY: Shivganesh Hegde  DATE: 02/14/05  ECO: *P382*  */
/* Revision: 1.18.1.27.2.1  BY: Abbas Hirkani    DATE: 10/27/05  ECO: *P46M*  */
/* $Revision: 1.18.1.27.2.2 $          BY: Amit Kumar   DATE: 07/21/06 ECO: *P4XX* */

/* LAST MODIFIED: 2008/06/13   BY: Softspeed roger xiao  ECO:*xp001*          */  /*仅限C开头的PR号,自动找同号的SO,copy其中so_part为采购件的SO项次到PR */
/*
2.	客户化逻辑
A)	SO 转成 PR
条件 : 订单号码开头为  C  
          采购(P)件的物料才产生PR
          PR 数量 = SO 数量 (不考虑其它条件 :库存/......)  
B)	PR 号码 = SO 号码 ，PR LINE = SO LINE

备注：
1）销售订单自动转化为采购申请单时，采购申请单明细的供应商默认取自1.4.17的供应商；如1.4.17没有设置则取自1.4.7的供应商。
*/
/* LAST MODIFIED: 2008/07/03   BY: Softspeed roger xiao  ECO:*xp002*          */  /*明细价格按照供应商币别(vd_curr),不按照请购单主档币别(base_curr)*/
/* LAST MODIFIED: 2008/07/11   BY: Softspeed roger xiao  ECO:*xp003*          */  /*记录so_rmks(lotnum)*/
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Maintenance                                                  */
/*NOTE: CHANGES MADE TO THIS PROGRAM MAY NEED TO BE MADE TO
REQUISITION DETAIL INQUIRY AND/OR REQUISITION MAINTENANCE
        AND/OR REQUISITION REPORT.*/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{rqconst.i}

define new shared variable cmtindx          as integer.
define new shared variable userid_modifying as character no-undo.

define variable mc-error-number like msg_nbr no-undo.
define variable continue               as logical        no-undo.
define variable del-yn like mfc_logical no-undo.
define variable line as integer no-undo.
define variable new_req as logical no-undo.
define variable oldcurr like rqm_curr.
define variable get_rqmnbr like rqm_mstr.rqm_nbr no-undo.
define variable rqmnbr like rqm_mstr.rqm_nbr.
define variable email_opt_valid as logical no-undo.
define variable email_sent_to as character no-undo.
define variable approve_or_route       like mfc_logical  no-undo.
define variable i as integer no-undo.
define variable hdr_cmmts like COMMENTS no-undo.
define variable poc_pt_req             as logical        no-undo.
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
define variable rndmthd                like rnd_rnd_mthd no-undo.
define variable l_stat_open            as   logical      no-undo.


/*----------------------------------------------------------------------------------------------xp001*/
define variable outfile   as char format "x(40)"  no-undo.  /*for cimload*/
define variable outfile1  as char format "x(40)"  no-undo.  /*for cimload*/
define variable quote     as char initial '"'     no-undo.  /*for cimload*/
define variable v_ok      like mfc_logical initial yes no-undo.  /*for cimload*/
define variable v_ok_all  like mfc_logical initial yes no-undo.  /*for cimload*/

define var v_sngl_ln as logical label "行格式 (单/多)" . 
define temp-table temp1  /*xp001*/
    field t1_nbr like sod_nbr 
    field t1_line like sod_line 
    field t1_site  like sod_site
    field t1_part like sod_part 
    field t1_um      like rqd_um
    field t1_qty_ord like sod_qty_ord
    field t1_rmks    like so_rmks  /*xp003*/

    field t1_vend    like rqd_vend     
    field t1_pur_cost like rqd_pur_cost
    /*field t1_disc_pct like rqd_disc_pct */
    .
/*----------------------------------------------------------------------------------------------xp001*/




form
   rqm_mstr.rqm_nbr         colon 14
   rqm_vend        colon 36
   rqm_ship        colon 60
with frame a attr-space side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
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
with frame b attr-space side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

form
   rqm_disc_pct    colon 14
   rqm_pr_list2    colon 36
   rqm_pr_list     colon 68
with frame c attr-space side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

{mfadform.i "vend" 1 SUPPLIER}
{mfadform.i "ship_to" 41 SHIP_TO}

using_grs = can-find(mfc_ctrl
                where mfc_domain  = global_domain
                 and  mfc_field   = "grs_installed"
                 and mfc_logical = yes).

if not using_grs then do:
   /*GRS not enabled*/
   run p_ip_msg (input 2122, input 4).
   if not batchrun then pause.
   leave.
end.

find first gl_ctrl where gl_domain = global_domain no-lock.
find first poc_ctrl where poc_domain = global_domain no-lock.
find first mfc_ctrl
   where mfc_domain = global_domain
    and  mfc_field = "poc_pt_req"
no-lock no-error.
if available mfc_ctrl then poc_pt_req = mfc_logical.

{gprun.i ""rqpma.p""}
find first rqf_ctrl where rqf_domain = global_domain no-lock.
view frame dtitle.

if available rqf_ctrl then
    prohibit_changes = if rqf__qadc01 = "yes" then yes else no.

/*GET MOST RECENTLY ACCESSED REQ NUMBER AND DISPLAY*/
{gprun.i ""rqidf.p""
   "(input 'get', input 'reqnbr', input-output get_rqmnbr)"}

display
   get_rqmnbr @ rqm_mstr.rqm_nbr
with frame a.

mainloop:
repeat:
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
 /*xp001*/
/*   if input frame a rqm_mstr.rqm_nbr = "" then
   do transaction:
      rqmnbr = "".

      find first rqf_ctrl where rqf_domain = global_domain
      exclusive-lock.

      if length(rqf_pre) + length(string(rqf_nbr)) > 8 then
         rqf_nbr = 1.

      rqmnbr = rqf_pre + string(rqf_nbr).

      do while can-find(first rqm_mstr
         where rqm_mstr.rqm_domain = global_domain and rqm_nbr = rqmnbr):
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
   end.*/
   if input frame a rqm_mstr.rqm_nbr = "" then do:
        message "警告:PR号不允许为空,请重新输入" .
        undo,retry .
   end. 
   else if not (input frame a rqm_mstr.rqm_nbr begins "C" ) then do:
        message "警告:仅限C开头的PR,请重新输入" .
        undo,retry .
   end.  /*xp001*/
   else do:
      find rqm_mstr using frame a rqm_nbr
         where rqm_mstr.rqm_domain = global_domain
      no-lock no-error.

      if available rqm_mstr then do:
         if rqm_rtdto_purch
         then
            /*REQUISITION ROUTED TO PURCHASING*/
            run p_ip_msg (input 2106, input 2).

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
         end.

         /* If the approval process started for this req
          * don't allow editing */
         if prohibit_changes and
             userid_modifying <> rqm_buyer and
             can-find (first rqda_det
                          where rqda_domain = global_domain
                          and   rqda_nbr = frame a rqm_nbr
                            and rqda_action = ACTION_APPROVE)
             then do:
            /*Cannot Edit. Approvals Exist For This Requisition*/
                run p_ip_msg (input 5873, input 3).
               undo, retry.
         end.

         if not
            (userid_modifying = rqm_eby_userid
            or
            userid_modifying = rqm_rqby_userid
            or
            userid_modifying = rqm_rtto_userid)
         then do:
            /*YOU MUST BE THE ENTERER, REQUESTOR, OR CURRENT ROUTE TO*/
            run p_ip_msg (input 2113, input 3).
            undo, retry.
         end.
      end.  /* if available rqm_mstr */
      else do : /*xp001*/
          find first so_mstr where so_domain = global_domain and so_nbr = input frame a rqm_mstr.rqm_nbr no-lock no-error .
          if not avail so_mstr then do:
              message "警告:没有同编号的SO,请重新输入" .
              undo,retry .
          end.
          else do:
              find first sod_det 
                    where sod_domain = global_domain 
                    and sod_nbr = input frame a rqm_mstr.rqm_nbr 
                    and (can-find(ptp_det where ptp_domain = global_domain and ptp_part = sod_part and ptp_site = sod_site and ptp_pm_code = "P") 
                         or(not can-find(ptp_det where ptp_domain = global_domain and ptp_part = sod_part and ptp_site = sod_site) 
                            and can-find(pt_mstr where pt_domain = global_domain and pt_part = sod_part and pt_pm_code = "P")
                           ))
              no-lock no-error .
              if not avail sod_det then do:
                  message "警告:同编号的SO明细中无采购件,请重新输入" .
                  undo,retry .
              end.
              else do: /*add_new_pr*/
                    /*nothing here ,add pr below*/
              end.  /*add_new_pr*/
          end.
      end. /*xp001*/
   end.  /* else do */

   find first rqf_ctrl where rqf_domain = global_domain no-lock.

   do transaction:
      assign
         prev_sub        = ""
         prev_cc         = ""
         prev_entity     = ""
         prev_job        = ""
         prev_site       = ""
         l_prev_vend     = ""
         l_ext_cost1     = 0
         l_max_ext_cost1 = 0.

      find rqm_mstr using frame a rqm_nbr
         where rqm_mstr.rqm_domain = global_domain
      exclusive-lock no-error.

      if available rqm_mstr then do:
         new_req = no.
         /*MODIFYING EXISTING RECORD*/
         run p_ip_msg (input 10, input 1).
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

          find so_mstr 
                where so_mstr.so_domain = global_domain
                and so_nbr = input frame a rqm_mstr.rqm_nbr 
          exclusive-lock no-error. /*xp001*/

         clear frame vend.
         clear frame ship_to.
         clear frame b.

         /*ADDING NEW RECORD*/
         run p_ip_msg (input 1, input 1).
         create rqm_mstr.

         assign
            rqm_domain      = global_domain
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

         oldcurr = rqm_curr.

         set rqm_vend with frame a
         editing:
            {mfnp.i
               vd_mstr rqm_vend  " vd_mstr.vd_domain = global_domain and
               vd_addr "  rqm_vend vd_addr vd_addr}

            if recno <> ? then do:
               display
                  vd_addr @ rqm_vend
               with frame a.

               {mfaddisp.i "input rqm_vend" vend}
            end.
         end.  /* set with editing */

         if rqm_vend > "" then do:
            find vd_mstr
               where vd_domain = global_domain
                and  vd_addr = rqm_vend
            no-lock no-error.

            if not available vd_mstr then do:
               /*NOT A VALID SUPPLIER*/
               run p_ip_msg (input 2, input 3).
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
                  /*SUPPLIER CURRENCY IS*/
                  {pxmsg.i &MSGNUM=2108 &ERRORLEVEL=2 &MSGARG1=vd_curr}
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
      end.  /* do on error undo, retry */

      {mfaddisp.i rqm_vend vend}

      do on error undo, retry:
         set rqm_ship with frame a
         editing:
            {mfnp.i
               ad_mstr rqm_ship  " ad_domain = global_domain and ad_addr "
               rqm_ship ad_addr ad_addr}

            if recno <> ? then do:
               display
                  ad_addr @ rqm_ship
               with frame a.

               {mfaddisp.i "input rqm_ship" ship_to}
            end.
         end.  /* set with editing */

         {mfaddisp.i rqm_ship ship_to}

         if rqm_ship > "" and not available ad_mstr then do:
            /*NOT A VALID CHOICE*/
            run p_ip_msg (input 13, input 3).
            undo, retry.
         end.
      end.  /* do on error undo, retry */

      ststatus = stline[2].
      status input ststatus.
      prev_status = rqm_status.

      do on error undo, retry:
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
            find first rqpo_ref
               where rqpo_domain  = global_domain
                 and rqpo_req_nbr = rqm_nbr
            no-lock no-error.

            if available rqpo_ref then do:
               /*CAN'T DELETE REQUISITION, REFERENCED BY POS*/
               run p_ip_msg (input 2081, input 3).
               undo, retry.
            end.

            del-yn = yes.
            /*PLEASE CONFIRM DELETE*/
            {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
            if not del-yn then undo, retry.
            line = 0.

            for each rqd_det
               where rqd_domain = global_domain
                and  rqd_nbr = rqm_nbr
            exclusive-lock:
               for each cmt_det
                  where cmt_domain = global_domain
                   and  cmt_indx = rqd_cmtindx
               exclusive-lock:
                  delete cmt_det.
               end.

               /*DELETE ANY MRP DETAIL RECORDS*/

               for each mrp_det
                  where mrp_domain = global_domain
                   and  mrp_dataset = "req_det"
                     and mrp_nbr = rqd_nbr
                   and  mrp_line = string(rqd_line)
               exclusive-lock:
                  {inmrp.i
                     &part=mrp_det.mrp_part &site=mrp_det.mrp_site}

                  delete mrp_det.
               end.

               delete rqd_det.
               line = line + 1.
            end.  /* for each rqd_det */

            /* LINE ITEM RECORD(S) DELETED  */
            {pxmsg.i &MSGNUM=24 &ERRORLEVEL=1 &MSGARG1=line}
            hide message.

            for each cmt_det
               where cmt_domain = global_domain
                and  cmt_indx = rqm_cmtindx
            exclusive-lock:
               delete cmt_det.
            end.

            clear frame a.
            clear frame b.

            /*SEND EMAILS*/

            email_sent_to = "".

            if not new_req then do:
               {gprun.i ""rqemsend.p""
                  "(input recid(rqm_mstr), input ACTION_DELETE_REQ,
                    output email_sent_to)"}
            end.

            /* WRITE HISTORY RECORD */

            {gprun.i ""rqwrthst.p""
               "(input rqm_nbr,
                 input 0,
                 input ACTION_DELETE_REQ,
                 input userid_modifying,
                 input '',
                 input email_sent_to)"}

            for each rqda_det
               where rqda_domain = global_domain
                and  rqda_nbr = rqm_nbr
            exclusive-lock:
               delete rqda_det.
            end.

            {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
               "(input rqm_exru_seq)"}

            delete rqm_mstr.

            next mainloop.
         end.  /* if F5 or CTRL-D */

         if rqm_req_date = ? then do:
            /* INVALID DATE */
            run p_ip_msg (input 27, input 3).
            next-prompt rqm_req_date with frame b.
            undo, retry.
         end.

         if rqm_need_date = ? then do:
            /* INVALID DATE */
            run p_ip_msg (input 27, input 3).
            next-prompt rqm_need_date with frame b.
            undo, retry.
         end.

         if rqm_due_date = ? then do:
            /* INVALID DATE */
            run p_ip_msg (input 27, input 3).
            next-prompt rqm_due_date with frame b.
            undo, retry.
         end.
         if new_req then do:
            if rqm_req_date < today then do:
               /* Requisition date cannot be before today */
               {pxmsg.i &MSGNUM=1949 &ERRORLEVEL=3
                        &MSGARG1="getTermLabel('REQUISITION',15)"}
              next-prompt rqm_req_date with frame b.
               undo, retry.
            end.

            if rqm_need_date < today then do:
               /* Need date cannot be before today */
               {pxmsg.i &MSGNUM=1949 &ERRORLEVEL=3
                        &MSGARG1="getTermLabel('NEED',6)"}
               next-prompt rqm_need_date with frame b.
               undo, retry.
            end.

            if rqm_due_date < today then do:
               /* Due date cannot be before today */
               {pxmsg.i &MSGNUM=1949 &ERRORLEVEL=3
                        &MSGARG1="getTermLabel('DUE',5)"}
               next-prompt rqm_due_date with frame b.
               undo, retry.
            end.
         end.  /* if new_req */

         if not can-find
            (usr_mstr where usr_userid = rqm_rqby_userid)
         then do:
            /* UNAVAILABLE USER */
            run p_ip_msg (input 2054, input 3).
            next-prompt rqm_rqby_userid with frame b.
            undo, retry.
         end.

         if not can-find
            (usr_mstr where usr_userid = rqm_end_userid)
         then do:
            /* UNAVAILABLE USER */
            run p_ip_msg (input 2054, input 3).
            next-prompt rqm_end_userid with frame b.
            undo, retry.
         end.

         if gl_verify then do:
            if rqm_sub > "" then do:
               if not can-find(sb_mstr where sb_domain = global_domain
               and  sb_sub = rqm_sub)
               then do:
                  /* INVALID SUBACCOUNT CODE */
                  run p_ip_msg (input 3131, input 3).
                  next-prompt rqm_sub with frame b.
                  undo, retry.
               end.
            end.

            if rqm_cc > "" then do:
               if not can-find(cc_mstr where cc_domain = global_domain
               and  cc_ctr = rqm_cc)
               then do:
                  /* INVALID COST CENTER */
                  run p_ip_msg (input 3057, input 3).
                  next-prompt rqm_cc with frame b.
                  undo, retry.
               end.
            end.
         end.  /* if gl_verify */

         if rqm_site > "" then do:
            if not can-find(si_mstr where si_domain = global_domain
            and  si_site = rqm_site)
            then do:
               /* SITE DOES NOT EXIST */
               run p_ip_msg (input 708, input 3).
               next-prompt rqm_site with frame b.
               undo, retry.
            end.

            find si_mstr
               where si_domain = global_domain
                and  si_site = rqm_site
            no-lock.

            if si_db <> global_db then do:
               /* SITE IS NOT ASSIGNED TO THIS DOMAIN */
               run p_ip_msg (input 6251, input 3).
               next-prompt rqm_site with frame b.
               undo, retry.
            end.

            /* CHANGED MESSAGE FROM ERROR TO WARNING SO THAT        */
            /* MULTI-ENTITY IS ALLOWED WHILE REQUISITION GENERATION */
            if si_entity <> rqm_entity then do:
               /* SITE ENTITY DOES NOT MATCH REQUISITION ENTITY */
               run p_ip_msg (input 2107, input 2).
            end. /* IF si_entity <> rqm_entity */
         end.  /* if rqm_site > "" */

         if not can-find(en_mstr where en_domain = global_domain
                                   and en_entity = rqm_entity)
            and rqm_entity <> gl_entity
         then do:
            /* INVALID ENTITY */
            run p_ip_msg (input 3061, input 3).
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

            if mc-error-number <> 0 then do:
               /* NO EXCHANGE RATE FOR APPROVAL CURRENCY */
               run p_ip_msg (input 2087, input 3).
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
            and not can-find(first rqj_mstr where rqj_domain = global_domain
                                             and  rqj_job = rqm_job)
         then do:
            /* INVALID JOB */
            run p_ip_msg (input 2066, input 3).
            next-prompt rqm_job with frame b.
            undo, retry.
         end.

         if rqm_job > ""     and
            can-find (first rqj_mstr
            where rqj_domain = global_domain and
                  rqj_job    = rqm_job       and
                ( (rqj_start <> ?            and
                   rqj_start >  today)       or
                  (rqj_end   <> ?            and
                   rqj_end   <  today) ))
         then do:
            /* INVALID JOB EFFECTIVE DATE RANGE */
            run p_ip_msg (input 6899, input 3).
            next-prompt rqm_job with frame b.
            undo, retry.
         end. /* IF rqm_job > "" AND */

         do with frame b:
            if not ({gpglproj.v rqm_project}) then do:
               /* INVALID PROJECT */
               run p_ip_msg (input 3128, input 3).
               next-prompt rqm_project with frame b.
               undo, retry.
            end.
         end.

         if rqm_status <> ""  and
            rqm_status <> "x" and
            rqm_status <> "c"
         then do:
            /* INVALID STATUS */
            run p_ip_msg (input 19, input 3).
            next-prompt rqm_status with frame b.
            undo, retry.
         end.

         if prev_status = "" and rqm_status = "x" then do:
            find first rqpo_ref
               where rqpo_domain  = global_domain
                 and rqpo_req_nbr = rqm_nbr
            no-lock no-error.

            if available rqpo_ref then do:
               /* CAN'T CANCEL REQUISITION, REFERENCED BY POS */
               run p_ip_msg (input 2079, input 3).
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
            /* NOT A VALID EMAIL OPTION */
            run p_ip_msg (input 2092, input 3).
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
               /* NOT A VALID EMAIL OPTION */
               run p_ip_msg (input 2092, input 3).
               next-prompt email_opt_entry with frame b.
               undo, retry.
            end.
         end.
      end.

      /* GET DISC%, PRICE TABLE CODE, DISC TABLE CODE FROM USER */

      hide frame b no-pause.

      /* GET DEFAULT PRICE AND DISCOUNT LISTS */
      for first vd_mstr
         fields (vd_domain  vd_addr vd_buyer vd_curr vd_disc_pct
                 vd_pr_list vd_lang vd_pr_list2 vd_rmks)
         where vd_domain = global_domain
          and  vd_addr = rqm_vend
         no-lock:
      end. /* FOR FIRST vd_mstr */
      if available vd_mstr and new_req
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

      /* USER CHANGING STATUS FROM CANCELLED TO OPEN */
      /* OR USER CHANGING STATUS FROM CLOSED TO OPEN */

      if (prev_status = "x"  or
         prev_status = "c") and
         rqm_status = ""
      then do:
         yn = no.
         /* DO YOU WISH TO REOPEN ALL REQUISITION LINE ITEMS? */
         {pxmsg.i &MSGNUM=2084 &ERRORLEVEL=1 &CONFIRM=yn}

         if yn then do:
            run reopen_all_line_records(input recid(rqm_mstr),
                                        input rndmthd,
                                        input mc-error-number).

         end.
      end.

      /* USER CHANGING STATUS FROM OPEN TO CANCELLED */
      if prev_status = "" and rqm_status = "x" then do:
         run cancel_requisition(input recid(rqm_mstr)).
      end.

      /** USER CHANGING STATUS FROM OPEN TO CLOSED **/

      if prev_status = "" and
         rqm_status = "c"
      then do:
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
            run recalc_price_cost (buffer rqm_mstr,
                                   input rndmthd,
                                   input mc-error-number).

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

         rqm_cmtindx = cmtindx.
      end.
   end. /* do transaction */

   /* LINE ITEM DATA ENTRY */

   hide frame c no-pause.
   hide frame b no-pause.
   hide frame vend no-pause.
   hide frame ship_to no-pause.
   hide frame a no-pause.

   /* Identify context for QXtend */
   {gpcontxt.i
      &STACKFRAG = 'rqrqmta,rqrqmt0,rqrqmt'
      &FRAME = 'price-list-failed' &CONTEXT = 'LINE'}

   /* Identify context for QXtend */
   {gpcontxt.i
      &STACKFRAG = 'rqrqmta,rqrqmt0,rqrqmt'
      &FRAME = 'disc-list-failed' &CONTEXT = 'LINE'}



    if new_req then do: /*xp001*/
        l_lineffdate = if rqm_req_date <> ? then rqm_req_date else today.
        v_sngl_ln = no . 

        for each temp1 : delete temp1 . end.  
        for each sod_det 
            where sod_domain = global_domain
            and sod_nbr = rqm_nbr 
            and (can-find(ptp_det where ptp_domain = global_domain and ptp_part = sod_part and ptp_site = sod_site and ptp_pm_code = "P") 
                 or(not can-find(ptp_det where ptp_domain = global_domain and ptp_part = sod_part and ptp_site = sod_site) 
                    and can-find(pt_mstr where pt_domain = global_domain and pt_part = sod_part and pt_pm_code = "P")
                   ))
            and sod_qty_ord > 0 
            no-lock :
            find first temp1 where t1_nbr = sod_nbr and t1_line = sod_line no-error .
            if not avail temp1 then do:
                create temp1 .
                assign 
                t1_nbr = sod_nbr 
                t1_line = sod_line
                t1_site = sod_site
                t1_part = sod_part 
                t1_um      = sod_um 
                t1_qty_ord = sod_qty_ord
                t1_rmks    = so_rmks  /*xp003*/
                .

                find ptp_det where ptp_domain = global_domain and ptp_part = sod_part and ptp_site = sod_site /*and ptp_pm_code = "P"*/ no-lock no-error .
                if avail ptp_det then t1_vend = ptp_vend .
                else do:
                    find pt_mstr where pt_domain = global_domain and pt_part = sod_part /*and pt_pm_code = "P"*/ no-lock no-error .
                    if avail pt_mstr then t1_vend = pt_vend .
                end.


                /*find first pc_mstr 
                        use-index pc_part 
                        where pc_domain = global_domain 
                        and pc_part = t1_part 
                        and pc_list = t1_vend 
                        and pc_curr = rqm_curr
                        and pc_um   = t1_um 
                        and (pc_start = ?  or pc_start <= l_lineffdate) 
                        and (pc_expire = ? or pc_expire >= l_lineffdate )
                        and pc_amt_type = "L"
                no-lock no-error .
                if avail pc_mstr then t1_pur_cost = pc_amt[1] .*/  /*xp002*/

            end.
        end. /*for each sod*/

        v_ok_all = yes .

        newloop:
        for each temp1 :
                    do transaction:
                        find first vd_mstr where vd_domain = global_domain and vd_addr = t1_vend no-lock no-error .
                        if avail vd_mstr then do:
                            rqm_curr = vd_curr .   /*xp002*/
                        end. 
                    end.
                    outfile = "xxrqrqmtaso1_" + string(t1_line) + ".prn".
                    output to value(outfile ).
                        put unformatted t1_line skip .  /*line*/
                        put unformatted t1_site skip .  /*site*/
                        put unformatted t1_part skip .  /*part*/
                        put unformatted t1_vend skip .    /*vender */
                        put unformatted t1_qty_ord " " t1_um skip .  /*qty ,um*/ 
                        put unformatted " - " .        /*cost_price*/ /*t1_pur_cost*/
                        put unformatted " - " skip .   /*discount*/
                        put unformatted "." skip .
                    output close.

                    batchrun = yes.
                    outfile1  = outfile + ".o".

                    input from value(outfile).
                    output to  value (outfile1) .
                    {gprun.i ""xxrqrqmtaso1.p""
                             "(input recid(rqm_mstr), 
                               input new_req,
                               input v_sngl_ln,
                               output l_stat_open)"}

                    input close.
                    output close.

                    find rqd_det 
                            where rqd_domain = global_domain 
                            and rqd_nbr      = t1_nbr 
                            and rqd_line     = t1_line 
                            and rqd_part     = t1_part
                            and rqd_um       = t1_um
                            and rqd_req_qty  = t1_qty_ord 
                            and rqd_vend     = t1_vend 
                    no-error .
                    if not avail rqd_Det then  undo newloop, next newloop.
                    else do:
                        do transaction:
                            rqd__chr01      = t1_nbr . /*xp003*/
                            rqd__chr03      = string(t1_line) . /*xp003*/
                            rqd__chr02      = t1_rmks . /*xp003*/
                        end.
                    end.

                    run write_error_to_log(input outfile,input outfile1 ,output v_ok) . 
                    if not v_ok then do:
                            if v_ok_all = yes then v_ok_all = no .
                    end.
        end. /*for each temp1*/ /*newloop:*/

        if v_ok_all = no then
            message "SO转PR,有错误发生,请参考log.err最后几行" view-as alert-box.

    end . /*xp001*/
    do transaction:
        rqm_curr = base_curr.  /*xp002*/
    end.
    {gprun.i ""xxrqrqmtaso2.p""
          "(input recid(rqm_mstr), input new_req, output l_stat_open)"} /*xp001*/

   /*{gprun.i ""rqrqmta.p""
      "(input recid(rqm_mstr), input new_req, output l_stat_open)"}*/ /*xp001*/

   /* Clear context for QXtend */
   {gpcontxt.i
      &STACKFRAG = 'rqrqmta,rqrqmt0,rqrqmt'
      &FRAME = 'price-list-failed'}

   /* Clear context for QXtend */
   {gpcontxt.i
      &STACKFRAG = 'rqrqmta,rqrqmt0,rqrqmt'
      &FRAME = 'disc-list-failed'}

   view frame a.

   /* SEND EMAILS */

   email_sent_to = "".

   if not new_req then do:
      {gprun.i ""rqemsend.p""
         "(input recid(rqm_mstr),
           input ACTION_MODIFY_REQ,
           output email_sent_to)"}
   end.

   /* WRITE HISTORY RECORD */

   if new_req
   then action_entry = ACTION_CREATE_REQ.
   else action_entry = ACTION_MODIFY_REQ.

   {gprun.i ""rqwrthst.p""
      "(input rqm_nbr,
        input 0,
        input action_entry,
        input userid_modifying,
        input '',
        input email_sent_to)"}

   /* CHECK AND SET THE OPEN AND APRV STATUS INDICATORS */
   if not l_stat_open then
      {gprun.i ""rqsetopn.p"" "(input rqm_nbr)"}

   /* SAVE ACCESSED REQ NUMBER FOR OTHER PGMS TO USE */

   get_rqmnbr = rqm_nbr.

   {gprun.i ""rqidf.p""
      "(input 'put', input 'reqnbr', input-output get_rqmnbr)"}

   /* IF RQAPMT.P OR RQRTMT.P IS A CALLING PROGRAM
    * (EITHER DIRECT OR THIS CALLED FROM AN FKEY)
    * JUST DISPLAY TOTALS, OTHERWISE ASK THE
    * USER IF TO INVOKE RQAPMT.P */

   i = 1.

   do while program-name(i) <> ?:
      if index(program-name(i),"rqapmt.") > 0 or
         index(program-name(i),"rqrtmt.") > 0
         then leave.

      i = i + 1.
   end.

   {gprun.i ""rqtotdsp.p""
      "(input recid(rqm_mstr), output total_frame_hdl)"}

   if program-name(i) <> ? then do:
      do on endkey undo, leave:
         pause.
      end.
   end.

   if program-name(i) = ? then do:
      approve_or_route = false.

      do on endkey undo, leave:
         /* ROUTE THIS REQUISITION? */
         {pxmsg.i &MSGNUM=2083 &ERRORLEVEL=1 &CONFIRM=approve_or_route}
      end.

      if approve_or_route then do:

         /* SAVE CURRENT ROUTE-TO FOR RQRTMT.P */
         route_to = rqm_rtto_userid.

         {gprun.i ""rqidf.p""
            "(input 'put', input 'approver',
              input-output route_to)"}

         {gprun.i ""rqrtmt0.p""}
      end.
   end.

   /* THE FOLLOWING IS BECAUSE THE TOTAL FRAME IS STILL
   * VISIBLE AFTER RETURNING FROM RQTOTDSP.P */

   if valid-handle(total_frame_hdl)
   then
      total_frame_hdl:hidden = true.

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
   define buffer rqm_mstr for rqm_mstr.
   define buffer rqd_det  for rqd_det.

   find rqm_mstr where recid(rqm_mstr) = p_rqm_recid exclusive-lock.
   assign
      rqm_total     = 0
      rqm_max_total = 0.

   for each rqd_det
       where rqd_domain = global_domain
        and  rqd_nbr = rqm_nbr
   exclusive-lock:
      rqd_status = "x".

      /* UPDATE MRP */

      {gprun.i ""rqmrw.p""
         "(input false,
           input rqd_site,
           input rqd_nbr,
           input rqd_line)"}
   end.

   /* REQUISITION CANCELLED */
   run p_ip_msg (input 2098, input 3).
END PROCEDURE.

PROCEDURE reopen_all_line_records:
   define input parameter p_rqm_recid   as   recid           no-undo.
   define input parameter p_rndmthd     like rnd_rnd_mthd    no-undo.
   define input parameter p_mc_error_no like msg_nbr         no-undo.
   define variable        l_extcost     like l_ext_cost1     no-undo.
   define variable        l_maxextcost  like l_max_ext_cost1 no-undo.
   define buffer rqm_mstr for rqm_mstr.
   define buffer rqd_det  for rqd_det.

   find rqm_mstr where recid(rqm_mstr) = p_rqm_recid exclusive-lock.

      /* GET ROUNDING METHOD FROM CURRENCY MASTER */
   {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                        "(input rqm_curr,
                          output p_rndmthd,
                          output p_mc_error_no)"}
   if p_mc_error_no <> 0
   then
      {pxmsg.i &MSGNUM=3088
               &ERRORLEVEL=2}

    for each rqd_det
       where rqd_domain = global_domain
        and  rqd_nbr = rqm_nbr
   exclusive-lock:
      rqd_status = "".

      /* UPDATE MRP */

      run p_calc_netprice(buffer rqd_det).

      {gprun.i ""rqmrw.p""
         "(input false, input rqd_site, input rqd_nbr,
           input rqd_line)"}

      assign
          l_extcost = (if rqd_pur_cost <> 0
                       then
                          rqd_req_qty * rqd_pur_cost
                          * (1 - (- (l_net_price1
                          - rqd_pur_cost)
                          / (rqd_pur_cost / 100)) / 100)
                       else
                          0)
         l_maxextcost =  (rqd_req_qty * rqd_max_cost).

      {gprun.i ""gpcurrnd.p"" "(input-output l_extcost,
                                input p_rndmthd)"}

      {gprun.i ""gpcurrnd.p"" "(input-output l_maxextcost,
                                input p_rndmthd)"}

      assign
         l_ext_cost1     = l_ext_cost1     + l_extcost
         l_max_ext_cost1 = l_max_ext_cost1 + l_maxextcost.

   end.

   assign
      rqm_total     = l_ext_cost1
      rqm_max_total = l_max_ext_cost1.

   /* REQUISITION REOPENED */
   run p_ip_msg (input 2104, input 1).
END PROCEDURE.

PROCEDURE get_rqm_nbr:
   define output parameter p_continue as logical no-undo.

   p_continue = false.

   do on endkey undo, leave:
      prompt-for rqm_mstr.rqm_nbr with frame a
      editing:
         {mfnp.i rqm_mstr rqm_nbr  " rqm_mstr.rqm_domain = global_domain and
         rqm_nbr "  rqm_nbr rqm_nbr rqm_nbr}

         if recno <> ? then do:
            run display_req(input recno, input false).
         end.
      end.

      p_continue = true.
   end.
END PROCEDURE.

PROCEDURE display_req:
   define input parameter p_rqm_recid as recid no-undo.
   define input parameter p_exclusive_lock as logical no-undo.

   find first rqf_ctrl where rqf_domain = global_domain no-lock.

   if p_exclusive_lock then
      find rqm_mstr where recid(rqm_mstr) = p_rqm_recid exclusive-lock.
   else
      find rqm_mstr where recid(rqm_mstr) = p_rqm_recid no-lock.

   if new_req
   then hdr_cmmts = rqf_hcmmts.
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
   define buffer rqm_mstr for rqm_mstr.
   define buffer rqd_det  for rqd_det.

   find rqm_mstr
      where recid(rqm_mstr) = p_rqm_recid
   exclusive-lock no-error.
   assign
      rqm_total     = 0
      rqm_max_total = 0.

   for each rqd_det
      where rqd_domain = global_domain
       and  rqd_nbr    = rqm_nbr
       and  rqd_status = ""
   exclusive-lock:
      assign rqd_status = "c".

      /*UPDATE MRP*/
      {gprun.i ""rqmrw.p""
         "(input false,
           input rqd_site,
           input rqd_nbr,
           input rqd_line)"}

   end. /* FOR EACH RQD_DET */

   /* REQUISITION IS CLOSED */
   run p_ip_msg (input 3325, input 1).

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
      fields( vp_domain vp_curr vp_mfgr vp_mfgr_part vp_part vp_q_date
              vp_q_price vp_q_qty vp_um vp_vend vp_vend_part)
      no-lock
      where vp_domain = global_domain
        and vp_part   = p_part
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

   define parameter buffer rqm_mstr      for  rqm_mstr.
   define input parameter  p_rndmthd     like rnd_rnd_mthd no-undo.
   define input parameter  p_mc_error_no like msg_nbr      no-undo.

   define buffer rqd_det  for rqd_det.

   /* THE REQUISITION STATUS SHOULD BE CHANGED TO UNAPPROVED */
   /* IF COSTS ARE RECALCULATED.                             */
   if (rqm_status = "x"
   or  rqm_status = "c")
   then
      run reopen_all_line_records(input recid(rqm_mstr),
                                  input rndmthd,
                                  input mc-error-number).

   loop-rqd-det:
   for each rqd_det
      where rqd_domain    = global_domain
      and ( rqd_vend      =  rqm_vend
        and rqd_nbr       =  rqm_nbr
        and rqd_type      <> "M"
        and (rqd_pr_list  <> rqm_pr_list
      or    rqd_pr_list2  <> rqm_pr_list2))
   exclusive-lock:

      assign
         l_prev_ext_cost     = rqd_req_qty * rqd_pur_cost
                               * (1 - (rqd_disc_pct / 100))
         l_prev_max_ext_cost = rqd_req_qty * rqd_max_cost
         rqd_pr_list         = rqm_pr_list
         rqd_pr_list2        = rqm_pr_list2.

      for first pt_mstr
         fields (pt_domain pt_abc pt_avg_int pt_bom_code pt_cyc_int
                 pt_insp_lead pt_insp_rqd pt_joint_type pt_loc pt_mfg_lead
                 pt_mrp pt_network pt_ord_max pt_ord_min pt_ord_mult pt_ord_per
                 pt_ord_pol pt_ord_qty pt_part pt_plan_ord pt_pm_code
                 pt_prod_line pt_pur_lead pt_rctpo_active pt_rctpo_status
                 pt_rctwo_active pt_rctwo_status pt_routing pt_sfty_time
                 pt_timefence pt_um pt_yield_pct pt_desc1 pt_desc2)
          where pt_domain = global_domain
           and  pt_part = rqd_part
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
            where pt_domain = global_domain and pt_part = rqd_part)
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
      end. /* IF rqd_pr_list <> "" */

      if poc_ctrl.poc_pl_req
         and (   rqd_pr_list = ""
              or l_pc_recno  = 0)
      then do:

         /* DISPLAY ERROR IF IT IS INVENTORY ITEM */
         if can-find (pt_mstr
            where pt_domain = global_domain and pt_part = rqd_part)
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
         l_max_ext_cost = rqd_req_qty * rqd_max_cost.

      /* GET ROUNDING METHOD FROM CURRENCY MASTER */
      {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                           "(input rqm_curr,
                             output p_rndmthd,
                             output p_mc_error_no)"}
      if p_mc_error_no <> 0
      then
         {pxmsg.i &MSGNUM=3088
                  &ERRORLEVEL=2}

      {gprun.i ""gpcurrnd.p"" "(input-output l_ext_cost,
                                input p_rndmthd)"}

      {gprun.i ""gpcurrnd.p"" "(input-output l_prev_ext_cost,
                                input p_rndmthd)"}

      {gprun.i ""gpcurrnd.p"" "(input-output l_max_ext_cost,
                                input p_rndmthd)"}

      {gprun.i ""gpcurrnd.p"" "(input-output l_prev_max_ext_cost,
                                input p_rndmthd)"}

      assign
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





procedure write_error_to_log:
	define input parameter file_name as char .
	define input parameter file_name_o as char .
	define output parameter v_ok as logical .
	define variable linechar as char .
	define variable woutputstatment as char.

	linechar = "" .
	input from value (file_name_o) .

		repeat: 
			import unformatted woutputstatment.                         

			IF  index (woutputstatment,"ERROR:")   <> 0 OR    /* for us langx */ 
				index (woutputstatment,"错误:")	<> 0 OR    /* for ch langx */
				index (woutputstatment,"岿粇:")	<> 0       /* for tw langx */ 		     
			then do:			  
				output to  value ( "log.err") APPEND.
					put unformatted today " " string (time,"hh:mm:ss")  " " file_name_o " " woutputstatment  skip.
				output close.
				linechar = "ERROR" .			  
			end.		     
		End.

	input close.

	/*if linechar <> "ERROR" then do:
		unix silent value ("rm -f "  + trim(file_name)).
		unix silent value ("rm -f "  + trim(file_name_o)).
	end. */

	v_ok = if linechar = "ERROR" then no else yes .

end. /*PROCEDURE write_error_to_log*/
