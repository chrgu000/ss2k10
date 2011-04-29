/* mrprapa2.p - MRP Planned Purchase Requisition Creation                     */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*V8:ConvertMode=Maintenance                                                  */
/* $Revision: 1.32 $                                                              */
/* REVISION  8.5       LAST MODIFIED: 08/15/97   BY: *J1Q2* Patrick Rowan     */
/* REVISION: 8.6E      LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E      LAST MODIFIED: 06/11/98   BY: *L040* Charles Yen       */
/* REVISION: 8.5       LAST MODIFIED: 07/30/98   BY: *J2WL* Patrick Rowan     */
/* REVISION: 8.5       LAST MODIFIED: 08/31/98   BY: *J2W1* Patrick Rowan     */
/* REVISION: 8.5       LAST MODIFIED: 09/10/98   BY: *J2YD* Patrick Rowan     */
/* REVISION: 8.5       LAST MODIFIED: 09/21/98   BY: *J300* Patrick Rowan     */
/* REVISION: 8.5       LAST MODIFIED: 09/28/98   BY: *J30R* Patrick Rowan     */
/* REVISION: 8.6E      LAST MODIFIED: 11/12/98   BY: *J34G* Alfred Tan        */
/* REVISION: 8.6E      LAST MODIFIED: 03/25/99   BY: *J3C7* Poonam Bahl       */
/* REVISION: 9.1       LAST MODIFIED: 10/01/99   BY: *N014* Patti Gaultney    */
/* REVISION: 9.1       LAST MODIFIED: 01/12/00   BY: *M0HL* Manish K.         */
/* REVISION: 9.1       LAST MODIFIED: 07/20/00   BY: *N0GF* Mudit Mehta       */
/* REVISION: 9.1       LAST MODIFIED: 08/13/00   BY: *N0KR* myb               */
/* REVISION: 9.1       LAST MODIFIED: 02/07/01   BY: *M11D* Sandeep P.        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.20         BY: Reetu Kapoor       DATE: 05/02/01  ECO: *M162*  */
/* Revision: 1.21         BY: Murali Ayyagari    DATE: 05/24/01  ECO: *M18G*  */
/* Revision: 1.22         BY: Niranjan R.        DATE: 07/12/01  ECO: *P00L*  */
/* Revision: 1.23         BY: Sandeep P.         DATE: 08/24/01  ECO: *M1J7*  */
/* Revision: 1.25         BY: Anitha Gopal       DATE: 12/21/01  ECO: *N174*  */
/* Revision: 1.26         BY: Mark Christian     DATE: 05/29/02  ECO: *N1K7*  */
/* Revision: 1.27         BY: Manisha Sawant     DATE: 12/05/02  ECO: *N219*  */
/* Revision: 1.29         BY: Paul Donnelly (SB) DATE: 06/28/03  ECO: *Q00J*  */
/* Revision: 1.30         BY: Vandna Rohira      DATE: 02/27/04  ECO: *P1QZ*  */
/* Revision: 1.31         BY: Priya Idnani       DATE: 06/10/05  ECO: *P3P4*  */
/* $Revision: 1.32 $          BY: Surajit Roy        DATE: 07/30/05  ECO: *P3W3*  */





/* $MODIFIED BY: softspeed Roger Xiao         DATE: 2008/01/16  ECO: *xp001*  */ /*找数量刚好匹配的so,记录so_nbr到req_det or rqd_det*/
/* $MODIFIED BY: softspeed Roger Xiao         DATE: 2008/03/28  ECO: *xp002*  */ 
/* $MODIFIED BY: softspeed Roger Xiao         DATE: 2008/04/22  ECO: *xp003*  */ /*加记录so_rmks 到req_det or rqd_det*/
/* $MODIFIED BY: softspeed Roger Xiao         DATE: 2008/06/12  ECO: *xp004*  */  /*价格表单位与BOM单位不一致,且存在单位转换率,PR用价格表单位*/
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

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
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE mrprapa2_p_1 "Stock Um Qty"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrprapa2_p_2 "Ext Cost"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrprapa2_p_4 "MRP planned order"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrprapa2_p_5 "Max Ext Cost"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{rqconst.i}

/* PARAMETERS */
define input parameter in_repl_cntr    as integer no-undo.
define input parameter in_rqm_nbr      like rqm_mstr.rqm_nbr no-undo.
define input parameter in_rqd_part     like rqd_det.rqd_part no-undo.
define input parameter in_rqd_site     like rqd_det.rqd_site no-undo.
define input parameter in_rqd_req_qty  like
   rqd_det.rqd_req_qty no-undo.
define input parameter in_rqd_rel_date like
   rqd_det.rqd_rel_date no-undo.
define input parameter in_rqd_due_date like
   rqd_det.rqd_due_date no-undo.
define input parameter in_remarks_text like rqm_mstr.rqm_rmks no-undo.
define output parameter out_return_code as integer no-undo.

/* VARIABLES */
define variable req_qty        like rqd_req_qty no-undo.
define variable line           like rqd_line no-undo.
define variable get_rqmnbr     like rqm_mstr.rqm_nbr no-undo.
define variable temp_sub       like rqm_sub.
define variable temp_cc        like rqm_cc.

/* MRPRAPA.P VARIABLES */
define variable nonwdays as integer no-undo.
define variable overlap  as integer no-undo.
define variable workdays as integer no-undo.
define variable interval as integer no-undo.
define variable frwrd  as integer no-undo.
define variable know_date as date no-undo.
define variable find_date as date no-undo.

/* RQRQMTA.P VARIABLES */
define variable clines as integer initial ? no-undo.
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
define variable line_cmmts like COMMENTS no-undo.
define variable max_ext_cost like rqd_max_cost
   label {&mrprapa2_p_5} no-undo.
define variable mfgr like vp_mfgr no-undo.
define variable mfgr_part like vp_mfgr_part no-undo.
define variable messages as character no-undo.
define variable msglevels as character no-undo.
define variable msgnbr as integer no-undo.
define variable new_rqd like mfc_logical no-undo.
define variable not_in_inventory_msg as character no-undo.
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
define variable mc-error-number like msg_nbr no-undo.
define variable temp_rate     as   decimal      no-undo.
define variable temp_rate2    as   decimal      no-undo.
define variable temp_ratetype like exr_ratetype no-undo.

define  shared var v_sonbr like sod_nbr.      /*xp001*/ /*create in xxmrprapa.p*/
define  shared var v_soline like sod_line .   /*xp001*/ /*create in xxmrprapa.p*/
define  shared var v_sormks like so_rmks  .   /*xp003*/  /*create in xxmrprapa.p*/



define var v_conv   like um_conv . /*xp004*/
define var v_alt_um like um_um .   /*xp004*/
define var v_vend   like pt_vend .  /*xp004*/
define var v_curr   like rqm_curr .  /*xp004*/
define var v_req_qty like rqd_req_qty .  /*xp004*/

define shared temp-table tt-rqm-mstr no-undo
    field tt-vend   like rqm_mstr.rqm_vend
    field tt-site   like rqd_det.rqd_site /*xp002*/
	field tt-loc    like rqd_det.rqd_loc  /*xp002*/
    field tt-nbr    like rqm_mstr.rqm_nbr
    field tt-line   like rqd_det.rqd_line
    field tt-part   like rqd_det.rqd_part
    field tt-yn     like mfc_logical
    field tt-wo-nbr like wo_nbr
    field tt-wo-lot like wo_lot
    index vend is primary
       tt-vend
       tt-nbr
       tt-line
    index ttnbrlot
       tt-wo-nbr
       tt-wo-lot
    index ttnbr
       tt-nbr.

/* INITIALIZATION */
assign
   not_in_inventory_msg = getTermLabel("ITEM_NOT_IN_INVENTORY",25)
   new_rqd = true
   out_return_code = -1.
find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.
find first poc_ctrl  where poc_ctrl.poc_domain = global_domain no-lock.

/* IF 1ST REPLENISHMENT THEN CREATE REQUISITION HEADER */

if in_repl_cntr = 1 then do:

   /* INITIALIZATION */

   find first mfc_ctrl  where mfc_ctrl.mfc_domain = global_domain and
      mfc_field = "poc_pt_req" no-lock no-error.
   if available mfc_ctrl then poc_pt_req = mfc_logical.

   {gprun.i ""rqpma.p""}
   find first rqf_ctrl  where rqf_ctrl.rqf_domain = global_domain no-lock.

   for first si_mstr
      fields( si_domain si_site si_entity)
       where si_mstr.si_domain = global_domain and  si_site = in_rqd_site
      no-lock:
   end. /* FOR FIRST si_mstr */

   /*ADDING NEW RECORD*/
   create rqm_mstr. rqm_mstr.rqm_domain = global_domain.

   assign
      rqm_curr         = base_curr
      rqm_direct       = true
      rqm_due_date     = today
      rqm_email_opt    = rqf_email_opt
      rqm_ent_date     = today
      rqm_ent_ex       = 1
      rqm_eby_userid   = global_userid
      rqm_entity       = si_entity
      rqm_ex_rate      = 1
      rqm_ex_rate2     = 1
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
      rqm_rmks         = in_remarks_text
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

   /* SINCE THE REQS ARE NOW CREATED VENDORWISE, THERE MAYBE A */
   /* POSSIBILITY THAT THE LAST REQ IS CREATED BEFORE THE PREV */
   /* REQ. IN ORDER TO DEFAULT THE LAST REQ IN REQ MAINT,      */
   /* DOING A FOR LAST ON tt-rqm-mstr                          */

   for last tt-rqm-mstr
     where tt-nbr <> ""
       and tt-yn
     no-lock use-index ttnbr:
   end. /* FOR LAST tt-rqm-mstr */
   if available tt-rqm-mstr
   then
      get_rqmnbr = tt-rqm-mstr.tt-nbr.
   else
      get_rqmnbr = rqm_nbr.

   {gprun.i ""rqidf.p""
      "(input 'put', input 'reqnbr', input-output get_rqmnbr)"}

end.  /* if in_repl_cntr = 1 */
else do:

   /* GET REQUISITION MASTER */
   find rqm_mstr  where rqm_mstr.rqm_domain = global_domain and
      rqm_nbr = in_rqm_nbr exclusive-lock no-error.
   if not available (rqm_mstr) then
      leave.
end.

/* CREATE REQUISITION LINE */

line = in_repl_cntr.
find last rqd_det  where rqd_det.rqd_domain = global_domain and
   rqd_nbr = rqm_nbr no-lock no-error.
if available rqd_det then
   line = rqd_line + 1.

/*ADDING NEW RECORD*/
create rqd_det. rqd_det.rqd_domain = global_domain.

assign
   rqd_aprv_stat   = APPROVAL_STATUS_UNAPPROVED
   rqd_line        = line
   rqd_nbr         = rqm_nbr
   rqd_site        = in_rqd_site
   rqd_part        = in_rqd_part
   rqd_acct        = gl_pur_acct
   temp_sub        = gl_pur_sub
   temp_cc         = gl_pur_cc
   rqd_req_qty     = in_rqd_req_qty
   rqd_rel_date    = in_rqd_rel_date
   rqd_due_date    = in_rqd_due_date
   rqd_need_date   = in_rqd_due_date
   rqd_um_conv     = 1
   rqd_open        = true      /* Line's open qty status */
   rqd__chr01      = v_sonbr  /*xp001*/
   rqd__chr03      = string(v_soline) /*xp001*/
   rqd__chr02      = v_sormks  /*xp003*/
   .

if recid(rqd_det) = -1 then.

/* FIND PART MASTER AND PLANNING RECORDS */

find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part = in_rqd_part
   no-lock no-error.

find ptp_det  where ptp_det.ptp_domain = global_domain and  ptp_part =
in_rqd_part
   and ptp_site = in_rqd_site no-lock no-error.

/*GET DEFAULT SUPPLIER, PRICE, DISCOUNT LISTS, ACCOUNT & CC*/

if available ptp_det then do:
   assign
      rqd_vend = ptp_vend.
   find vd_mstr  where vd_mstr.vd_domain = global_domain and  vd_addr =
   ptp_vend no-lock no-error.
end.  /* if available ptp_mstr */
else
   if available pt_mstr then do:
   assign
      rqd_vend = pt_vend.
   find vd_mstr  where vd_mstr.vd_domain = global_domain and  vd_addr = pt_vend
   no-lock no-error.
end.  /* if available pt_mstr */

if available vd_mstr then do:
   assign
      rqd_pr_list  = vd_pr_list
      rqd_pr_list2 = vd_pr_list2
      rqd_acct     = vd_pur_acct
      temp_sub     = vd_pur_sub
      temp_cc      = vd_pur_cc
      rqd_disc_pct = vd_disc_pct
      .

   /* REQUISITION CURRENCY IS EARLIER SET TO THE BASE CURRENCY */
   /* ADDED LOGIC :                                            */
   /* IF THE VENDOR CURRENCY OF FIRST REPLENISHMENT IS NOT     */
   /* THE SAME AS REQUISITION HEADER CURRENCY THEN COPY THIS   */
   /* LINE VENDOR CURRENCY AND EXCHANGE RATES TO THE           */
   /* REQUISITION HEADER                                       */

   if in_repl_cntr = 1 and vd_curr <> rqm_curr
   then do:
      assign rqm_curr = vd_curr.

      /* DETERMINE EXCHANGE RATES */
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
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
         undo, retry.
      end.
   end. /* IF IN_REPL_CNTR = 1 AND VD_CURR <> RQM_CURR */

   if (in_repl_cntr = 1) and (rqm_curr <> rqf_appr_curr)
   then do:

      {gprun.i ""rqexrt.p""
         "(input rqm_curr,
           input rqf_appr_curr,
           input temp_ratetype,
           output temp_rate,
           output temp_rate2,
           output mc-error-number)"}

      if mc-error-number <> 0 then do:
         /* NO EXCHANGE RATE FOR APPROVAL CURRENCY */
         {pxmsg.i &MSGNUM=2087 &ERRORLEVEL=3}
         undo, retry.
      end.
   end. /* IF IN_REPL_CNTR = 1 AND RQM_CURR <> RQF_APPR_CURR */

end.

/* COPY PART MASTER DATA */

if available pt_mstr then do:
   assign
      rqd_um       = pt_um
      rqd_desc     = pt_desc1
      rqd_rev      = pt_rev
      rqd_loc      = pt_loc
      rqd_insp_rqd     = pt_insp_rqd
      .

   if pt_lot_ser = "s" then
      rqd_lot_rcpt = true.

   find pl_mstr no-lock
       where pl_mstr.pl_domain = global_domain and  pl_prod_line = pt_prod_line
      no-error.

   if available pl_mstr and pl_pur_acct > "" then
      run getGLDefaults.
end.  /* if available pt_mstr */

/* CALCULATE DATES */

if available ptp_det then do:
   assign
      rqd_rev          = ptp_rev
      rqd_insp_rqd     = ptp_ins_rqd
      .
   if ptp_pm_code <> "P" then do:
      if ptp_ins_rqd and ptp_ins_lead <> 0 then do:
         rqd_need_date = ?.

         {mfdate.i rqd_need_date in_rqd_due_date
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

         {mfdate.i rqd_need_date in_rqd_due_date
            pt_insp_lead rqd_site}

      end.  /* if pt_insp_rqd and pt_insp_lead <> 0 */

      rqd_rel_date = rqd_need_date - pt_pur_lead.
      {mfhdate.i rqd_rel_date -1 rqd_site}
   end.  /* if pt_pm_code <> "P" */
end.  /* if available pt_mstr */

if (available ptp_det and ptp_ins_rqd) or
   (not available ptp_det and pt_insp_rqd)
then
   rqd_loc = poc_insp_loc.

find first in_mstr 
	where in_domain = global_domain 
	and in_site = rqd_site 
	and in_part = rqd_part 
no-lock no-error .
if avail in_mstr then do:
	rqd_loc = in_loc .
end.  /*xp002*/ 



/*xp004*/
v_req_qty = 0 .
v_conv   = 0 .
v_alt_um = "".
v_vend   = rqd_vend .
v_curr   = rqm_curr .

lineffdate    = rqd_due_date.
if lineffdate = ? then lineffdate = rqm_req_date.
if lineffdate = ? then lineffdate = today.


find first pc_mstr 
        use-index pc_part 
        where pc_domain = global_domain 
        and pc_part = rqd_part 
        and pc_list = v_vend 
        and pc_curr = v_curr 
        and (pc_start = ?  or pc_start <= lineffdate) 
        and (pc_expire = ? or pc_expire >= lineffdate )
        and pc_amt_type = "L"
no-lock no-error .
if avail pc_mstr then do:
    v_alt_um = pc_um .
    if v_alt_um <> rqd_um then do:
        find first um_mstr 
            use-index um_part 
            where um_domain = global_Domain 
            and um_part     = rqd_part 
            and um_um       = rqd_um 
            and um_alt_um   = v_alt_um
            and (um_conv <> 0 and um_conv <> ? )
        no-lock no-error .
        if avail um_mstr then do:
            v_conv = um_conv .
            v_req_qty = rqd_req_qty / v_conv .
            rqd_req_qty = v_req_qty .
            rqd_um      = v_alt_um .
            rqd_um_conv = v_conv .
        end. /*if avail um_mstr*/
        else do:
            find first um_mstr 
                use-index um_part 
                where um_domain = global_Domain 
                and um_part     = ""  
                and um_um       = rqd_um 
                and um_alt_um   = v_alt_um
                and (um_conv <> 0 and um_conv <> ? )
            no-lock no-error .
            if avail um_mstr then do:
                v_conv = um_conv .
                v_req_qty = rqd_req_qty / v_conv .
                rqd_req_qty = v_req_qty .
                rqd_um      = v_alt_um .
                rqd_um_conv = v_conv .
            end. /*if avail um_mstr*/
        end.
        /*else message "无替换单位" view-as alert-box. */

    end. /*if v_alt_um <> rqd_um*/
end. /*if avail pc_mstr*/
/*else message "无单价:零件" rqd_part "单位" v_alt_um "供应商" v_vend "币别"  v_curr  "取价日期" lineffdate view-as alert-box.*/

/*xp004*/




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

/*USE THE VENDOR QUOTE PRICE ONLY WHEN THE PRICE IS NON-ZERO*/

if got_vendor_item_data and vendor_price <> 0
then do:
   if vendor_q_curr = rqm_curr or
      vendor_q_curr = "" then do:

      /*CONVERT PRICE PER UM CONVERSION*/

      if vendor_q_um = rqd_um then
         conversion_factor = 1.
      else do:
         {gprun.i ""gpumcnv.p""
            "(input vendor_q_um,
              input rqd_um, input rqd_part,
              output conversion_factor)"}
      end.

      if conversion_factor <> ? then do:
         /* --- MINIMUM BUY RULE --- */
         /* ONLY CONVERT TO THE VENDOR ITEM */
         /* PRICE IF THE REQ QTY >= THE     */
         /* VENDOR QUOTE QTY.               */

         if vendor_q_um = rqd_um then do:
            if rqd_req_qty >= vendor_q_qty
            then
               assign
                  rqd_pur_cost = vendor_price / conversion_factor
                  got_vendor_price = true.
         end.
         else do:
            req_qty = rqd_req_qty / conversion_factor.
            if req_qty >= vendor_q_qty then
               assign
                  rqd_pur_cost = vendor_price / conversion_factor
                  got_vendor_price = true.
         end.  /* else do */
      end.  /* if conversion_factor <> ? */
   end.  /* if vendor_q_curr = rqm_curr ... */
end.  /* if got_vendor_item_data */

if not got_vendor_price then do:
   /*DIDN'T FIND A VENDOR PART PRICE, USE STD COST*/

   {gprun.i ""gpsct05.p""
      "(input rqd_part, input rqd_site, input 2,
        output rqd_pur_cost, output cur_cost)"}

   /* CONVERT FROM BASE TO FOREIGN CURRENCY */
   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input base_curr,
        input rqm_curr,
        input rqm_ex_rate2,
        input rqm_ex_rate,
        input rqd_pur_cost,
        input false, /* DO NOT ROUND */
        output rqd_pur_cost,
        output mc-error-number)"}.

   /*CONVERT PRICE PER UM CONVERSION*/

   if pt_um = rqd_um then
      conversion_factor = 1.
   else do:
      {gprun.i ""gpumcnv.p""
         "(input rqd_um,
           input pt_um,
           input rqd_part,
           output conversion_factor)"}
   end.

   if conversion_factor <> ? then
      rqd_pur_cost = rqd_pur_cost * conversion_factor.

end.  /* if not got_vendor_price */

/*INITIAL DEFAULT FOR DISCOUNT*/

/*AT THIS TIME RQM_DISC_PCT DOES NOT CONTAIN A VALUE! */

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

/*CHANGED THE 10TH INPUT PARAMETER FROM:           */
/*       input        rqm_disc_pct,                */
/*                            TO:                  */
/*       input        rqd_disc_pct,                */
/*THIS DISCOUNT IS PASSED INTO THE SUBPROGRAM SO   */
/*THE DISCOUNT LIST CAN TAKE THE SUPPLIER DISCOUNT */
/*INTO EFFECT.  AT THIS POINT THE HEADER DISCOUNT  */
/*IS NOT POPULATED, AND YOU WILL FIND THE SUPPLIER */
/*IN THE REQ. LINE (POPULATED FROM THE VD_MSTR).   */
/*THIS KEEPS ALL OF THE LINE DISCOUNTS SEPARATE.   */

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

/*SET UNIT COST TO NET PRICE*/

/*Unit cost is set to net price when there is no       */
/*standard cost on the item but the req. refers        */
/*to a price table or discount table.  The disc% is    */
/*returned as 0.00 since it is based on the unit cost. */
/*The net price is passed back from the sub-programs   */
/*and plugged into the unit cost field to show the     */
/*discounted price.                                    */

if rqd_pur_cost = 0 and net_price <> ? then
   rqd_pur_cost = net_price.

/* MAX UNIT COST (rqd_max_cost) AND EXT COST (ext_cost) WILL NOW BE */
/* CALCULATED USING net_price AND UNIT COST (rqd_pur_cost) INSTEAD  */
/* OF DISC% (rqd_disc_pct)                                          */

/* VALUE STORED IN rqd__qadc01 WILL BE USED TO SET net_price */
/* WHEN THE USER ACCESSES AN EXISTING REQUISITION LINE.      */

assign
   net_price    = if net_price = ?
                  then
                     0
                  else
                     net_price
   rqd__qadc01  = string(net_price)
   rqd_max_cost = if rqd_disc_pct < 0
                  then
                     rqd_pur_cost *
                        (1 - (- (net_price - rqd_pur_cost)
                              / (rqd_pur_cost / 100))
                         / 100)
                  else
                     rqd_pur_cost.

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
assign
   ext_cost = if rqd_pur_cost <> 0
              then
                 rqd_req_qty
                    * rqd_pur_cost
                    * (1 - (- (net_price - rqd_pur_cost)
                            / (rqd_pur_cost / 100)) / 100)
              else
                 0
   max_ext_cost   = rqd_req_qty * rqd_max_cost
   rqm_total      = rqm_total + ext_cost
   rqm_max_total  = rqm_max_total + max_ext_cost.

/* IF PROCESSING 1ST REPLENISHMENT                */
/* THEN BACK-FILL THE REQUISITION HEADER          */
/* WITH SUPPLIER, DISCOUNT, PRICE LIST AND DATES  */
/* FROM REQUISITION LINE JUST CREATED.            */

if in_repl_cntr = 1 then do:
   assign
      rqm_vend     = rqd_vend

      /*THESE FIELDS ARE RE-INSTATED SINCE SUBSEQUENT LINES */
      /*WILL ONLY LOOK AND THE CURRENT LINE PRICE LISTS AND */
      /*DISCOUNTS AND WILL NOT LOOK AT THE HEADER.  THE     */
      /*HEADER MAY CONTAIN A DIFFERENT SUPPLIER AND DISC %. */
      rqm_disc_pct  = if available vd_mstr
                      then
                          vd_disc_pct
                      else
                          rqd_disc_pct
      rqm_pr_list   = rqd_pr_list
      rqm_pr_list2  = rqd_pr_list2
      rqm_due_date  = rqd_due_date
      rqm_need_date = rqd_need_date
      rqm_acct      = rqd_acct
      rqm_sub       = temp_sub
      rqm_cc        = temp_cc
      rqm_site      = rqd_site
      /*IF THE SUPPLIER IS AVAILABLE THEN ASSIGN VD_LANG TO RQM_LANG.*/
      rqm_lang       = (if available(vd_mstr) then vd_lang else rqm_lang)
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
          where vp_mstr.vp_domain = global_domain and  vp_part = p_part and
          vp_vend = p_vendor
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
END PROCEDURE.
PROCEDURE getGLDefaults:
   /* Check for vendor's supplier type  */
   for first vd_mstr
      fields( vd_domain
              vd_addr
              vd_type
              vd_lang
              vd_disc_pct)
      where vd_mstr.vd_domain = global_domain
      and   vd_addr           = rqd_det.rqd_vend
   no-lock:
   end. /* FOR FIRST vd_mstr */

   /* CHECK FOR PURCHASES DEFAULT GL ACCOUNT */
   {gprun.i ""glactdft.p"" "(input ""PO_PUR_ACCT"",
                             input pt_mstr.pt_prod_line,
                             input rqd_site,
                             input if available vd_mstr then
                                   vd_type else """",
                             input """",
                             input no,
                             output rqd_acct,
                             output temp_sub,
                             output temp_cc)"}
END PROCEDURE.
