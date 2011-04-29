/* rqrqrp5b.p - REQUISITION REPORT SUBPROGRAM - DISPLAY LINE DETAIL           */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.10.1.11 $                                                       */
/*V8:ConvertMode=Report                                                       */

/* Revision: 8.5    LAST MODIFIED BY: 05/05/97  By: B. Gates          *J1Q2*  */
/* Revision: 8.5    LAST MODIFIED BY: 10/31/97  By: Patrick Rowan     *J243*  */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/05/98   BY: *K1PB* A. Shobha */
/* Revision: 8.5    LAST MODIFIED BY: 06/22/98  By: B. Gates          *J2QB*  */
/* Revision: 8.5    LAST MODIFIED BY: 08/12/98  By: Patrick Rowan     *J2W4*  */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Brian Compton      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00 BY: *N0KP* myb                  */
/* Revision: 1.10.1.4 BY: Tiziana Giustozzi  DATE: 07/03/01 ECO: *N104*       */
/* Revision: 1.10.1.5 BY: Nikita Joshi       DATE: 08/08/01 ECO: *M1DQ*       */
/* Revision: 1.10.1.8 BY: Anitha Gopal      DATE: 12/21/01 ECO: *N174*        */
/* Revision: 1.10.1.9  BY: Manisha Sawant DATE: 12/05/02 ECO: *N219* */
/* $Revision: 1.10.1.11 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00L* */


/*LAST MODIFIED: 2008/04    BY: softspeed Roger Xiao      ECO:*xp001*     */ /*add默认收货库位v_loc, so_nbr , lot_num */
/*LAST MODIFIED: 2008/06/14 BY: softspeed Roger Xiao      ECO:*xp002*     */ /*默认收货库位v_loc : in_loc-->vp_vend_part; */
/*-Revision end---------------------------------------------------------------*/


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*NOTE: CHANGES MADE TO THIS PROGRAM MAY NEED TO BE MADE TO
REQUISITION DETAIL INQUIRY AND/OR REQUISITION MAINTENANCE
AND/OR REQUSITION REPORT.*/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE rqrqrp5b_p_1 "Max Ext Cost"
/* MaxLen: Comment: */

&SCOPED-DEFINE rqrqrp5b_p_4 "Ext Cost"
/* MaxLen: Comment: */

&SCOPED-DEFINE rqrqrp5b_p_5 "Stock Um Qty"
/* MaxLen: Comment: */

&SCOPED-DEFINE rqrqrp5b_p_6 "Supplier Item"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define input parameter p_rqd_recid as recid no-undo.

{rqconst.i}
define variable rqd_recid as recid no-undo.
define variable rqm_recid as recid no-undo.
define variable tot_qty_ord like pod_qty_ord no-undo.
define variable st_qty like pod_qty_ord label {&rqrqrp5b_p_5}
   no-undo.
define variable ext_cost like rqd_pur_cost label {&rqrqrp5b_p_4}
   no-undo.
define variable max_ext_cost like rqd_max_cost label {&rqrqrp5b_p_1}
   no-undo.
define variable line_cmmts like COMMENTS no-undo.
define variable mfgr like vp_mfgr no-undo.
define variable mfgr_part like vp_mfgr_part no-undo.
define variable desc1 like pt_desc1 no-undo.
define variable desc2 like pt_desc1 no-undo.
define variable not_in_inventory_msg as character format "x(35)" no-undo.
define variable view_cmmts like mfc_logical no-undo.
define variable vend_row as integer no-undo.
define new shared variable cmtindx like cmt_indx.
define var v_loc like loc_loc . /*xp001*/


define variable rndmthd like rnd_rnd_mthd no-undo.
define variable mc-error-number like msg_nbr no-undo.

not_in_inventory_msg = getTermLabel("ITEM_NOT_IN_INVENTORY",30).

form
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
with frame b 1 down width 140.

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
   rqd_pr_list2        colon 36
   tot_qty_ord         colon 60
   rqd_category        colon 15
   rqd_pr_list         colon 36
   rqd_max_cost        colon 60 no-attr-space
   rqd_acct            colon 15
   rqm_sub             no-label
   rqm_cc              no-label

   ext_cost            colon 60 no-attr-space
   rqd_project         colon 15
   max_ext_cost        colon 60 no-attr-space
   rqd_vpart           colon 15 label {&rqrqrp5b_p_6}
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

{wbrp02.i}

find rqd_det where recid(rqd_det) = p_rqd_recid no-lock.
find rqm_mstr  where rqm_mstr.rqm_domain = global_domain and  rqm_nbr = rqd_nbr
no-lock no-error.
rqd_recid = p_rqd_recid.
rqm_recid = recid(rqm_mstr).

find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.

/* SET CURRENCY DISPLAY FORMATS */

if rqm_curr = gl_base_curr then do:
   rndmthd = gl_rnd_mthd.
end.
else do:
   rndmthd = ?.
   /* GET ROUNDING METHOD FROM CURRENCY MASTER */
   {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
      "(input rqm_curr,
                output rndmthd,
                output mc-error-number)"}
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.
end.


find first in_mstr where in_domain = global_domain and in_site = rqd_site and in_part = rqd_part no-lock no-error .
v_loc = if avail in_mstr then in_loc else rqd_loc . /*xp001*/
        find first vp_mstr where vp_domain = global_domain and vp_part = "C" and vp_vend = rqd_vend no-lock no-error .
        if avail vp_mstr then v_loc = vp_vend_part .  /*xp002*/

display
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
with frame b.

run display_line_frame_c.

if rqd_vend <> rqm_vend then do:
   run display_supplier(input rqd_vend).
   display rqd_pr_list2 rqd_pr_list with frame vend.
end.

/******************************************************/
/******************************************************/

/**                 PROCEDURES                       **/
/**                                                  **/
/******************************************************/
/******************************************************/

PROCEDURE display_line_frame_c:
   find rqd_det where recid(rqd_det) = rqd_recid no-lock.
   find rqm_mstr where recid(rqm_mstr) = rqm_recid no-lock.

   assign
      line_cmmts = rqd_cmtindx <> 0
      desc1 = not_in_inventory_msg
      desc2 = ""
      st_qty = 0.

   find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
   rqd_part no-lock no-error.

   if available pt_mstr then do:
      assign
         desc1 = pt_desc1
         desc2 = pt_desc2
         .
   end.
   else
      if rqd_desc <> "" then do:
      assign
         desc1 = rqd_desc
         desc2 = "".
   end.

   global_part = rqd_part.
   st_qty = rqd_req_qty * rqd_um_conv.

   /*CALCULATE QTY ALREADY ORDERED ON PO'S*/

   tot_qty_ord = 0.
   for each rqpo_ref no-lock
          where rqpo_ref.rqpo_domain = global_domain and  rqpo_req_nbr =
          rqd_nbr and rqpo_req_line = rqd_line:
      tot_qty_ord = tot_qty_ord + rqpo_qty_ord.
   end.

   /*GET MFGR, MFGR PART FROM VP_MSTR*/

   mfgr = "".
   mfgr_part = "".

   if rqd_vpart <> "" then do:
      find first vp_mstr  where vp_mstr.vp_domain = global_domain and  vp_part
      = rqd_part
         and vp_vend_part = rqd_vpart
         and vp_vend = rqd_vend
         no-lock no-error.

      if available vp_mstr then do:
         mfgr = vp_mfgr.
         mfgr_part = vp_mfgr_part.
      end.
   end.

   /*GET TEXT OF APPROVAL STATUS*/

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
      rqm_sub

      rqm_cc
      rqd_project
      rqd_vpart
      mfgr
      mfgr_part
      desc1
      desc2

      rqd_lot_rcpt
      rqd_rev
      rqd_pr_list2
      rqd_pr_list

      rqd_um_conv
      st_qty
      tot_qty_ord
      rqd_max_cost
      rqd_status
      line_cmmts
      approval_stat_desc @ rqd_aprv_stat

   with frame c.

   run display_ext_cost.
   run display_max_ext_cost.
END PROCEDURE.

PROCEDURE display_ext_cost:

   define variable l_netprice like pc_min_price no-undo.

   find rqd_det where recid(rqd_det) = rqd_recid exclusive-lock.

   /* EXTENDED COST (ext_cost) WILL NOW BE CALCULATED */
   /* USING l_netprice AND UNIT COST (rqd_pur_cost)   */
   /* INSTEAD OF DISC% (rqd_disc_pct)                 */

   if available rqd_det
   then
      assign
         l_netprice = decimal(rqd__qadc01).
         ext_cost   = if rqd_pur_cost <> 0
                      then
                         rqd_req_qty * rqd_pur_cost
                            * (1 - (- (l_netprice - rqd_pur_cost)
                                    / (rqd_pur_cost / 100)) / 100)
                      else
                         0.

   /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */
   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output ext_cost,
                   input rndmthd,
                   output mc-error-number)"}
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.

   display ext_cost with frame c.
END PROCEDURE.

PROCEDURE display_max_ext_cost:
   find rqd_det where recid(rqd_det) = rqd_recid exclusive-lock.

   max_ext_cost = rqd_req_qty * rqd_max_cost.

   /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */
   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output max_ext_cost,
                   input rndmthd,
                   output mc-error-number)"}
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.

   display max_ext_cost with frame c.
END PROCEDURE.

PROCEDURE display_supplier:
   define input parameter p_vend like rqd_vend no-undo.

   if c-application-mode <> 'WEB' then
      pause 0 .
   find ad_mstr  where ad_mstr.ad_domain = global_domain and  ad_addr = p_vend
   no-lock no-error.
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

   if c-application-mode <> 'WEB' then
      pause before-hide.
END PROCEDURE.
