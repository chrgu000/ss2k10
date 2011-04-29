/* rqrqrp5a.p  - REQUISITION REPORT SUBPROGRAM - DISPLAY HEADER INFO          */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.14 $                                                         */
/*V8:ConvertMode=FullGUIReport                                                */
/* Revision: 8.5    LAST MODIFIED BY: 05/05/97  By: B. Gates          *J1Q2*  */
/* REVISION 8.5       LAST MODIFIED: 10/23/97  BY: *J243* Patrick Rowan     */

/*NOTE: CHANGES MADE TO THIS PROGRAM MAY NEED TO BE MADE TO
REQUISITION DETAIL INQUIRY AND/OR REQUISITION MAINTENANCE
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 06/09/98   BY: *K1PB* D. Belbeck         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 09/09/99   BY: *J39R* Reetu Kapoor       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00 BY: *N0KP* myb                  */
/* Revision: 1.11  BY: Tiziana Giustozzi  DATE: 07/03/01 ECO: *N104* */
/* Revision: 1.13  BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00L* */
/* $Revision: 1.14 $ BY: Geeta Kotian DATE: 01/23/04 ECO: *P1KT* */

/*LAST MODIFIED: 2008/04    BY: softspeed Roger Xiao      ECO:*xp001*     */ /*add默认收货库位v_loc, so_nbr , lot_num */
/*LAST MODIFIED: 2008/06/14 BY: softspeed Roger Xiao      ECO:*xp002*     */ /*默认收货库位v_loc : in_loc-->vp_vend_part; add : 是否存在价格表*/
/*LAST MODIFIED: 2008/07/15 BY: softspeed Roger Xiao      ECO:*xp003*     */ /*默认收货库位v_loc :仅限C开头销售单的库位才取vp_vend_part */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
AND/OR REQUSITION REPORT.*/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{rqconst.i}

define shared variable nbr like rqm_mstr.rqm_nbr.
define shared variable nbr1 like rqm_mstr.rqm_nbr.
define shared variable vend like rqm_vend.
define shared variable vend1 like rqm_vend.
define shared variable entered_by like rqm_eby_userid.
define shared variable entered_by1 like rqm_eby_userid.
define shared variable req_by like rqm_rqby_userid.
define shared variable req_by1 like rqm_rqby_userid.
define shared variable end_user like rqm_end_userid.
define shared variable end_user1 like rqm_end_userid.
define shared variable rbuyer like rqm_buyer.
define shared variable rbuyer1 like rqm_buyer.
define shared variable ent_date like rqm_ent_date.
define shared variable ent_date1 like rqm_ent_date.
define shared variable req_date like rqm_req_date.
define shared variable req_date1 like rqm_req_date.
define shared variable need_date like rqm_need_date.
define shared variable need_date1 like rqm_need_date.
define shared variable due_date like rqm_due_date.
define shared variable due_date1 like rqm_due_date.
define shared variable site like rqm_site.
define shared variable site1 like rqm_site.
define shared variable category like rqd_category.
define shared variable category1 like rqd_category.
define shared variable rjob like rqm_job.
define shared variable rjob1 like rqm_job.
define shared variable open_only like mfc_logical.
define shared variable inc_cmmts like mfc_logical.
define shared variable v_pc like mfc_logical label "仅限无价格表PR" format "Yes/No" initial no.  /*xp002*/
define shared variable new_page_each_req like mfc_logical.

define new shared variable p_pause as log no-undo initial false.
define new shared variable p_view_cmmts as log no-undo.
define new shared variable addr as character format "x(38)" extent 6.
define buffer rqmmstr for rqm_mstr.

define variable vendor as character format "x(38)" extent 7 no-undo.
define variable shipto as character format "x(38)" extent 6 no-undo.
define variable duplicate as character format "x(11)" no-undo.
define variable vend_phone like ad_phone no-undo.
define variable max_ext_cost_fmt as character no-undo.
define variable max_ext_cost_old as character no-undo.
define variable print_date as date no-undo.
define variable i as integer no-undo.
define variable hdr_cmmts like COMMENTS no-undo.
define variable prev_session_numeric_format as character no-undo.
define variable rndmthd as character no-undo.
define variable by_caption as character format "x(34)"
   initial "By: ______________________________" no-undo.
define variable ALREADY_PRINTED as log initial false no-undo.
define variable NOT_PRINTED as log initial true no-undo.
define variable total_frame_hdl as handle no-undo.

define var v_loc like loc_loc . /*xp001*/
define var v_pclist as logical format "Yes/No" . /*xp002*/
define var lineffdate as date . /*xp002*/ 

p_view_cmmts = inc_cmmts.
find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.
print_date = today.
prev_session_numeric_format = session:numeric-format.

find first rqm_mstr  where rqm_mstr.rqm_domain = global_domain no-lock no-error.

form
   rqm_mstr.rqm_nbr     colon 10
   skip(1)
   rqm_vend        colon 11
   rqm_ship        colon 50
   vendor[1]       at 2    no-label
   shipto[1]       at 42   no-label
   vendor[2]       at 2    no-label
   shipto[2]       at 42   no-label
   vendor[3]       at 2    no-label
   shipto[3]       at 42   no-label
   vendor[4]       at 2    no-label
   shipto[4]       at 42   no-label
   vendor[5]       at 2    no-label
   shipto[5]       at 42   no-label
   vendor[6]       at 2    no-label
   shipto[6]       at 42   no-label
with frame aa side-labels width 80 no-box.

/* SET EXTERNAL LABELS */
setFrameLabels(frame aa:handle).

/*form
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
with frame b attr-space side-labels width 80. */

/* SET EXTERNAL LABELS */
/*setFrameLabels(frame b:handle). 

form
   rqm_disc_pct    colon 17
   rqm_pr_list2    colon 43
   rqm_pr_list     colon 68
with frame c attr-space side-labels width 80. ss-080515*/

/* SET EXTERNAL LABELS */
/*setFrameLabels(frame c:handle). ss-080515*/

form
   rqd_nbr /*ss-080515*/
   rqd_line
   rqd_site
   v_loc label "库位" /*xp001*/
   rqd_part
   rqd_vend
   rqd_req_qty
   rqd_um
   rqd_pur_cost        format ">>>>>>>>9.99<<<"
   rqd_disc_pct
   rqd__chr01  format "x(8)" column-label "销售单"    /*xp001*/
   rqd__chr02  format "x(32)"  column-label "LotNum"  /*xp001*/
   rqm_req_date  label "申请日期"
   rqd_need_date column-label "需求日期"
   rqd_due_date  column-label "截至日期"/*s-080515*/
   v_pclist   label "价格表" /*xp002*/

with frame rqd down width 300 no-box.

/* SET EXTERNAL LABELS */
setFrameLabels(frame rqd:handle).

for each rqm_mstr no-lock
       where rqm_mstr.rqm_domain = global_domain and (  (rqm_nbr >= nbr) and
       (rqm_nbr <= nbr1)
      and (rqm_vend >= vend) and (rqm_vend <= vend1)
      and (rqm_eby_userid >= entered_by and rqm_eby_userid <= entered_by1)
      and (rqm_rqby_userid >= req_by and rqm_rqby_userid <= req_by1)
      and (rqm_end_userid >= end_user and rqm_end_userid <= end_user1)
      and (rqm_buyer >= rbuyer and rqm_buyer <= rbuyer1)
      and (rqm_ent_date >= ent_date and rqm_ent_date <= ent_date1)
      and (rqm_req_date >= req_date and rqm_req_date <= req_date1)
      and (rqm_need_date >= need_date and rqm_need_date <= need_date1)
      and (rqm_due_date >= due_date and rqm_due_date <= due_date1)
      and (rqm_job >= rjob and rqm_job <= rjob1)

      and ((rqm_open and rqm_status  = "")
      or   open_only = false) ),
      each rqd_det no-lock
       where rqd_det.rqd_domain = global_domain and  rqd_nbr = rqm_nbr
      and (rqd_site >= site and rqd_site <= site1)
      and (rqd_category >= category and rqd_category <= category1)
      and ((rqd_open
            and rqd_status  = "")
           or open_only     = false)
      break by rqd_nbr by rqd_line:
   if first(rqd_nbr) then do:
   end.

   if first-of(rqd_nbr) then do:

      /*DISPLAY REQ HEADER INFO*/

      hdr_cmmts = rqm_cmtindx <> 0.

/*      run format_address(input rqm_vend).
      vendor[1] = addr[1].
      vendor[2] = addr[2].
      vendor[3] = addr[3].
      vendor[4] = addr[4].
      vendor[5] = addr[5].
      vendor[6] = addr[6].

      run format_address(input rqm_ship).
      shipto[1] = addr[1].
      shipto[2] = addr[2].
      shipto[3] = addr[3].
      shipto[4] = addr[4].
      shipto[5] = addr[5].
      shipto[6] = addr[6].

    display
         rqm_nbr
         rqm_vend
         rqm_ship
         vendor[1]
         shipto[1]
         vendor[2]
         shipto[2]
         vendor[3]
         shipto[3]
         vendor[4]
         shipto[4]
         vendor[5]
         shipto[5]
         vendor[6]
         shipto[6]
      with frame aa. ss-080515*/

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

 /*     display
         rqm_req_date
         rqm_sub
         rqm_curr
         rqm_need_date
         rqm_cc
         rqm_lang
         rqm_due_date
         rqm_site
         rqm_direct
         rqm_eby_userid
         rqm_entity
         email_opt_entry
         rqm_rqby_userid
         rqm_job
         rqm_status
         rqm_end_userid
         rqm_project
         hdr_cmmts
         rqm_reason
         approval_stat_desc @ rqm_aprv_stat
         rqm_rmks
      with frame b. ss-080515*/

 /*     display
         rqm_disc_pct
         rqm_pr_list2
         rqm_pr_list
      with frame c. ss-080515*/

      /*PRINT HEADER COMMENTS*/

      if inc_cmmts then do:
         {gpcmtprt.i &type=RP &id=rqm_cmtindx &pos=3}
      end.
   end.

   /*DISPLAY LINE RECORD INFO*/

        find first in_mstr where in_domain = global_domain and in_site = rqd_site and in_part = rqd_part no-lock no-error .
        v_loc = if avail in_mstr then in_loc else rqd_loc . /*xp001*/
        if rqd__chr01 begins "C" then do:   /*xp003*/
            find first vp_mstr where vp_domain = global_domain and vp_part = "C" and vp_vend = rqd_vend no-lock no-error .
            if avail vp_mstr then v_loc = vp_vend_part .  /*xp002*/
        end.   /*xp003*/

        lineffdate = rqd_due_date.
        if lineffdate = ? then lineffdate = rqm_req_date.
        if lineffdate = ? then lineffdate = today.

        find first pc_mstr 
                use-index pc_part 
                where pc_domain = global_domain 
                and pc_part = rqd_part 
                and pc_list = rqd_vend 
                and pc_curr = rqm_curr 
                and pc_um   = rqd_um 
                and (pc_start = ?  or pc_start <= lineffdate) 
                and (pc_expire = ? or pc_expire >= lineffdate )
                and pc_amt_type = "L"
        no-lock no-error .
        v_pclist = if avail pc_mstr then yes else no . /*xp002*/

        if v_pc and v_pclist = no then next .  /*xp002*/

      display
         rqd_nbr /* ss-080515*/
         rqd_line
         rqd_site
         v_loc /*xp001*/
         rqd_part
         rqd_vend
         rqd_req_qty
         rqd_um
         rqd_pur_cost
         rqd_disc_pct
         rqd__chr01 rqd__chr02 /*xp001*/
	 rqm_req_date 
	 rqd_need_date
	 rqd_due_date /*ss-080515*/
     v_pclist  /*xp002*/

      with frame rqd.

      down 1 with frame rqd.
   
   /*PRINT DETAIL LINE COMMENTS*/

   if inc_cmmts then do:
      /*THE DOWN 1 CAUSES COLUMN HEADINGS TO REAPPEAR*/
      {gpcmtprt.i &type=RP &id=rqd_cmtindx &pos=5
         &command="down 1 with frame rqd."}
   end.

  /* if last-of(rqd_nbr) then do:
      {gprun.i ""rqtotds2.p""
         "(input recid(rqm_mstr), output total_frame_hdl)"}

      if new_page_each_req then page.
      else put skip(3).
   end. ss-080515*/
end.

session:numeric-format = prev_session_numeric_format.

/******************************************************/
/******************************************************/

/**                 PROCEDURES                       **/
/**                                                  **/
/******************************************************/
/******************************************************/

PROCEDURE format_address:
   define input parameter p_address like ad_addr no-undo.

   addr = "".
   find ad_mstr  where ad_mstr.ad_domain = global_domain and  ad_addr =
   p_address no-lock no-error.

   if available ad_mstr then do:
      addr[1] = ad_name.
      addr[2] = ad_line1.
      addr[3] = ad_line2.
      addr[4] = ad_line3.
      addr[6] = ad_country.
      {mfcsz.i   addr[5] ad_city ad_state ad_zip}
      {gprun.i ""gpaddr.p"" }
   end.
END PROCEDURE.
