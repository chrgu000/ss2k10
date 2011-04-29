/* rqpobld.p - Requisition Purchase Build Maintenance                       */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.9.1.13 $                                                            */
/*V8:ConvertMode=ReportAndMaintenance                                       */
/* REVISION 8.5       LAST MODIFIED: 04/15/97  BY: *J1Q2* Patrick Rowan     */
/* REVISION 8.5       LAST MODIFIED: 10/28/97  BY: *J24N* Patrick Rowan     */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98  BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 03/31/98  BY: *J2G7* Samir Bavkar      */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98  BY: *K1Q4* Alfred Tan        */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98  BY: *J314* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00 BY: *N0KP* myb                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* Revision: 1.9.1.10      BY: Mugdha Tambe   DATE: 10/01/01 ECO: *P012*      */
/* Revision: 1.9.1.11  BY: Rajaneesh S. DATE: 08/29/02 ECO: *M1BY* */
/* $Revision: 1.9.1.13 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00L* */



/* $MODIFIED BY: softspeed Roger Xiao         DATE: 2007/12/04  ECO: *xp001*  */ /*单据按类别编号*/
/* $MODIFIED BY: softspeed Roger Xiao         DATE: 2008/01/12  ECO: *xp002*  */  /*记录PO历史记录*/
/* $MODIFIED BY: softspeed Roger Xiao         DATE: 2008/01/16  ECO: *xp003*  */  /*不限同so, rqd__chr01直接传递到POD,*/
/* $MODIFIED BY: softspeed Roger Xiao         DATE: 2008/03/28  ECO: *xp004*  */ /*添加限制:同地点,同供应商的零件,且交货库位相同的采购申请,才能转化为同一采购单*/
/* $MODIFIED BY: softspeed Roger Xiao         DATE: 2008/06/13  ECO: *xp005*  */ /*C开头的请购单,默认用1.19库位,不存在则用1.4.16库位;非C开头的请购单,默认用1.4.16库位*/
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*!
 ----------------------------------------------------------------------------
 DESCRIPTION: Copy requisitions to a new or existing purchase order.
              Supports the multi-line Purchase Requisition Module of MFG/PRO.

 Notes:
 1) Valid requisitions must be approved and routed to the buyer.
 2) Valid requisition lines must contain open qty.
 3) Requisition lines marked out of tolerence can be put on a PO, and
    will be re-evaluated for out of tolerence during PO Maintenance.
 4) Valid purchase orders are open orders, not closed or cancelled.
 5) Purchase orders cannot be blanket orders.

============================================================================
!*/
{mfdtitle.i "2+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE rqpobld_p_1 "Requisition"
/* MaxLen: Comment: */

&SCOPED-DEFINE rqpobld_p_2 "Blank Suppliers Only"
/* MaxLen: Comment: */

&SCOPED-DEFINE rqpobld_p_3 "Include MRO Items"
/* MaxLen: Comment: */

&SCOPED-DEFINE rqpobld_p_4 "Include MRP Items"
/* MaxLen: Comment: */

&SCOPED-DEFINE rqpobld_p_5 "Default Copy"
/* MaxLen: Comment: */

&SCOPED-DEFINE rqpobld_p_6 "Req Ln!PO Nbr"
/* MaxLen:8 Comment: */

&SCOPED-DEFINE rqpobld_p_7 "Site!PO Line"
/* MaxLen:8 Comment: */

&SCOPED-DEFINE rqpobld_p_8 "Item Number!Qty Ordered"
/* MaxLen:12 Comment: */

&SCOPED-DEFINE rqpobld_p_9 "Supplier!UM"
/* MaxLen:8 Comment: */

&SCOPED-DEFINE rqpobld_p_10 "Due Date!Disc %"
/* MaxLen:8 Comment: */

&SCOPED-DEFINE rqpobld_p_11 "Purchase Cost!Extended Cost"
/* MaxLen:15 Comment: */

&SCOPED-DEFINE rqpobld_p_12 "Ln"
/* MaxLen:3 Comment: */

&SCOPED-DEFINE rqpobld_p_13 "Supplier"
/* MaxLen:6 Comment: */

/* ********** End Translatable Strings Definitions ********* */

/* VARIABLES */
define variable req_nbr               like rqm_mstr.rqm_nbr no-undo
   label {&rqpobld_p_1}.
define variable req_nbr1              like rqm_mstr.rqm_nbr no-undo.
define variable supplier              like rqm_vend no-undo.
define variable supplier1             like rqm_vend no-undo.
define variable need_date             like rqd_need_date no-undo.
define variable need_date1            like rqd_need_date no-undo.
define variable part                  like rqd_part    no-undo.
define variable part1                 like rqd_part    no-undo.
define variable site                  like rqd_site    no-undo.
define var      loc                   like loc_loc no-undo . /*xp004*/
define new shared var      v_type     like xdn_type  label "单据类别" no-undo . /*xp001*/
define new shared variable v_site     like rqd_site    no-undo.  /*xp001*/

define variable buyer_id              like rqm_buyer   no-undo.
define variable job_name              like rqm_job     no-undo.
define variable ship                  like rqd_ship    no-undo.
define variable currency              like rqm_curr    no-undo.
define variable requester             like rqm_rqby_userid no-undo.
define variable open_qty              like rqd_req_qty no-undo.
define variable qty_um                like rqd_um      no-undo.
define variable l_subject             as   character   no-undo.
define variable l_reqlist             as   character   no-undo.
define variable l_emailsent           like mfc_logical no-undo.
define variable l_povend              like po_vend     no-undo.
define variable l_end                 as   character format "x(35)" no-undo.
/* LOGICALS */
define variable blank_suppliers       like mfc_logical no-undo
   label {&rqpobld_p_2}.
define variable default_copy          like mfc_logical no-undo
   label {&rqpobld_p_5}.
define variable include_mrp_type      like mfc_logical no-undo
   label {&rqpobld_p_4}.
define variable include_mro_type      like mfc_logical no-undo
   label {&rqpobld_p_3}.

/* COUNTERS */
define variable rqpo_wrk_cntr         as integer no-undo.
define variable using_grs            like mfc_logical no-undo.

/* CONSTANTS */
{rqconst.i}

/* SHARED VARIABLES*/
{rqpovars.i "NEW"}

/*STREAMS*/
define stream mailNotice.

/* FRAME Z: SELECTION FORM */
form
   site                colon 20   v_type             /*xp001*/
    loc                 colon 20  /*xp004*/
   req_nbr             colon 20
   req_nbr1            colon 49 label {t001.i}
   /*supplier            colon 20
   supplier1           colon 49 label {t001.i}   xp004*/
   part                colon 20
   part1               colon 49 label {t001.i}
   need_date           colon 20
   need_date1          colon 49 label {t001.i}

   supplier            colon 36  /*xp004*/
  
   buyer_id            colon 36
   requester           colon 36
   job_name            colon 36
   ship                colon 36
   currency            colon 36
   blank_suppliers     colon 36
   include_mrp_type    colon 36
   include_mro_type    colon 36
   include_hcmmts      colon 36
   include_lcmmts      colon 36
   default_copy        colon 36
with frame z side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame z:handle).

using_grs = can-find(mfc_ctrl
                where mfc_ctrl.mfc_domain = global_domain and  mfc_field   =
                "grs_installed"
                 and mfc_logical = yes).


form
   pod_req_nbr
   pod_req_line column-label {&rqpobld_p_12}
   pod_nbr
   pod_line
   pod_due_date
   pod_part
   pod_qty_ord
   pod_um
   l_povend label {&rqpobld_p_13}
with frame emailnotice width 80   down.

/* SET EXTERNAL LABELS */
setFrameLabels(frame emailnotice:handle).

if not using_grs then do:
   {pxmsg.i &MSGNUM=2122 &ERRORLEVEL=4}
   /*GRS not enabled*/

   if not batchrun then pause.
   leave.
end. /* if not using_grs then do: */

assign
   include_hcmmts = yes
   include_lcmmts = yes
   default_copy = yes
   buyer_id  = global_userid
   include_mrp_type = yes
   include_mro_type = yes.

find first icc_ctrl where icc_domain = global_domain no-lock no-error .
site = if avail icc_ctrl then icc_site else global_site .



mainloop:
repeat:

   if req_nbr1 = hi_char then req_nbr1 = ''.
   if supplier1 = hi_char then supplier1 = ''.
   if part1 = hi_char then part1 = ''.
   if need_date = low_date then need_date = ?.
   if need_date1 = hi_date then need_date1 = ?.

   update
      site
      v_type /*xp001*/
	  loc  /*xp004*/

      req_nbr
      req_nbr1
      /*supplier
      supplier1  xp004*/
      part
      part1
      need_date
      need_date1

	  supplier /*xp004*/
	  
      buyer_id
      requester
      job_name
      ship
      currency
      blank_suppliers
      include_mrp_type
      include_mro_type
      include_hcmmts
      include_lcmmts
      default_copy
   with frame z.

   if req_nbr1 = '' then req_nbr1 = hi_char.
   if supplier1 = '' then supplier1 = hi_char.
   if part1 = '' then part1 = hi_char.
   if need_date = ? then need_date = low_date.
   if need_date1 = ? then need_date1 = hi_date.
   
   find first si_mstr where si_domain = global_domain and si_site = site no-lock no-error.
   if not avail si_mstr then do:
	   message "无效地点,请重新输入" view-as alert-box.
	   undo,retry.
   end.
   v_site = site .

	find first xdn_ctrl where xdn_domain = global_domain and xdn_site = site and xdn_ordertype = "PO" and xdn_type = v_type no-lock no-error .
	if not avail xdn_ctrl then do:
		message "无效单据类别,请重新输入" view-as alert-box.
		undo,retry.
	end.

   find first loc_mstr where loc_domain = global_domain and loc_site = site and loc_loc = loc no-lock no-error.
   if not avail loc_mstr then do:
	   message "无效库位,请重新输入" view-as alert-box.
	   undo,retry.
   end.

   /*  INITIALIZE  */
   assign
      rqpo_wrk_cntr = 0
      info_correct  = no
      return_code   = 0.

   /*  RETRIEVE RECORDS AND LOAD TEMP-TABLE */

   {gprun.i ""xxrqpobldexx.p""
      "(input true,
        input req_nbr,
        input req_nbr1,
        input supplier,
        input part,
        input part1,
        input need_date,
        input need_date1,
        input buyer_id,
        input site,
		input loc,
        input requester,
        input job_name,
        input ship,
        input currency,
        input blank_suppliers,
        input include_mrp_type,
        input include_mro_type,
        input default_copy,
        output rqpo_wrk_cntr)"} 

   if rqpo_wrk_cntr = 0 then do:

      {pxmsg.i &MSGNUM=1853 &ERRORLEVEL=3}
      /* NO REQUISITIONS AVAILABLE FOR PROCESSING */

   end. /* if rqpo_wrk_cntr = 0 then do: */
   else do:
      hide frame z.
      /* DISPLAY REQUISITIONS FROM THE WORK FILE */
      /* USING SCROLLING WINDOW          */
      {gprun.i ""rqpoblda.p""}

      if info_correct then do:

         /* ARE ANY OF THE WORK FILE ENTRIES MARKED "YES" */
         if can-find (first rqpo_wrk where rqpo_copy_to_po) then do:
            hide frame z .

            /* BUILD PO FROM REQUISITIONS MARKED "YES" */
            {gprun.i ""xxrqpobldbxx.p""}   /* SIMILAR TO pomt.p */   /*xp001*/  /*xp002*/ 


            if return_code > 0 then do:

               {pxmsg.i &MSGNUM=return_code &ERRORLEVEL=1}

               /* WHEN OUTPUT IS TAKEN TO PAGE IN RQPOBLDB.P,LASTKEY VALUE  */
               /* IS RETAINED AS "F4".THIS GIVES ERROR WHILE DISPLAYING     */
               /* SUMMARY REPORT. HENCE THE FOLLOWING PAUSE STATEMENT ADDED */

               if not batchrun
                  and keyfunction(lastkey) = "end-error"
               then
                  pause .

               /* SEND E-MAIL NOTIFICATION , SUMMARY TO REQUESTER */
               assign
                  l_emailsent  = no
                  l_end        = getTermLabel("END_OF_REPORT",35) .

               for each wkrqd_det
                  break by wkrqd_rqby_userid by wkrqd_nbr:

                  /* IF E-MAIL OPTION IS "N" THEN SKIP THIS RECORD FOR */
                  /* E-MAIL PROCESSING                                 */
                  if can-find(rqm_mstr  where rqm_mstr.rqm_domain =
                  global_domain and  rqm_nbr = wkrqd_nbr and
                                       rqm_email_opt = EMAIL_OPT_NO_EMAIL )
                  then next .

                  if first-of(wkrqd_rqby_userid)
                  then do:
                     output stream mailNotice to email.out Append .
                     l_reqlist = "" .
                  end. /* IF FIRST-OF(wkrqd_rqby_userid) */

                  for first pod_det
                     fields( pod_domain pod_nbr pod_line pod_part pod_site
                     pod_um
                             pod_req_nbr pod_req_line pod_qty_ord
                             pod_pur_cost pod_due_date pod_request
                             pod_disc_pct pod__qad02 pod__qad09)
                      where pod_det.pod_domain = global_domain and  pod_req_nbr
                      = wkrqd_nbr
                     and pod_req_line  = wkrqd_line
                     and pod_part      = wkrqd_part
                     and pod_due_date  = wkrqd_due_date
                     no-lock:
                  end. /* FOR FIRST pod_det */

                  for first po_mstr
                     fields( po_domain po_nbr po_vend po_due_date)
                      where po_mstr.po_domain = global_domain and  po_nbr
                      = pod_nbr
                     no-lock:
                  end. /* FOR FIRST po_mstr */

                  display stream mailNotice
                     pod_req_nbr
                     pod_req_line
                     pod_nbr
                     pod_line
                     pod_due_date
                     pod_part
                     pod_qty_ord
                     pod_um
                     po_vend @ l_povend
                  with frame emailnotice width 80 down.
                  down with frame emailnotice.

                  /* GET LIST OF REQUISITIONS FOR NOTIFICATION */
                  if l_reqlist = ""
                  then
                     l_reqlist = pod_req_nbr.
                  else if first-of(wkrqd_nbr)
                  then
                     l_reqlist = l_reqlist + "," +  pod_req_nbr .

                  if last-of(wkrqd_rqby_userid)
                  then do:

                     display stream mailNotice
                        l_end at 35
                        with frame em_end no-label width 80 .

                     output stream mailNotice close .

                     /* SEND THE FOLLOWING MESSAGE # 4798 AS A SUBJECT IF A  */
                     /* PO IS CREATED USING MORE THAN 5 DIFFERENT            */
                     /* REQUISITIONS. OTHERWISE USE MESSAGE # 4782 WITH LIST */
                     /* OF REQUISITIONS AS A SUBJECT                         */

                     if length( l_reqlist ) > 44
                     then do :
                        /* MESSAGE #4798 - PO # WAS CREATED FROM  MULTIPLE
                                           REQUISITIONS  */
                        {pxmsg.i
                           &MSGNUM=4798
                           &MSGARG1=pod_nbr
                           &MSGBUFFER=l_subject }
                     end. /* IF LENGTH( l_reqlist) > 44 */
                     else do:

                        /* MESSAGE #4782 - PO # WAS CREATED FROM
                                           REQUISITION # */
                        {pxmsg.i
                           &MSGNUM=4782
                           &MSGARG1=pod_nbr
                           &MSGARG2=l_reqlist
                           &MSGBUFFER=l_subject }

                     end. /* ELSE DO: */

                     /* SENDING E-MAIL NOTIFICATION */
                     run send_email(
                        input l_subject ,
                        input wkrqd_rqby_userid ,
                        input "email.out" ) .
                     /* SEND E-MAIL NOTIFICATION TO ENDUSER IF E-MAIL OPTION */
                     /* IS "E" */
                     if wkrqd_end_userid <> ""
                        and wkrqd_end_userid <> wkrqd_rqby_userid
                        and wkrqd_email_opt = EMAIL_OPT_EXTENDED
                     then do:
                        run send_email(
                           input l_subject ,
                           input wkrqd_end_userid,
                           input "email.out" ) .
                     end. /* IF wkrqd_end_userid <> "" */

                     {gpfildel.i &filename=""email.out"" }

                     l_emailsent = yes .
                  end. /* if LAST-OF(wkrqd_rqby_userid) */

                  if last-of(wkrqd_nbr)
                     and can-find(rqm_mstr  where rqm_mstr.rqm_domain =
                     global_domain and  rqm_nbr = wkrqd_nbr
                                           and   rqm_open = no )
                  then do:

                     run displaySummary( input  pod_req_nbr ).

                     /* MESSAGE # 4783 - REQUISITION # IS COMPLETE    */
                     {pxmsg.i
                        &MSGNUM=4783
                        &MSGARG1=pod_req_nbr
                        &MSGBUFFER=l_subject }

                     /* SEND E-MAIL SUMMARY TO REQUESTER */
                     run send_email(
                        input l_subject,
                        input wkrqd_rqby_userid ,
                        input "summary.out" ) .

                     /* SEND E-MAIL SUMMARY TO ENDUSER IF E-MAIL OPTION */
                     /* IS "E"                                          */
                     if  wkrqd_email_opt  = EMAIL_OPT_EXTENDED
                     and wkrqd_end_userid  <> ""
                     and wkrqd_rqby_userid <> wkrqd_end_userid
                     then do:
                        run send_email(
                           input l_subject,
                           input wkrqd_end_userid,
                           input "summary.out" ) .
                     end. /* IF wkrqd__email_opt = EMAIL_OPT_EXTENDED */

                     {gpfildel.i &filename=""summary.out"" }

                     l_emailsent = yes .

                  end. /* IF LAST-OF(wkrqd_nbr) */

               end. /* FOR EACH wkrqd_det  */

               if l_emailsent
               then do:
                  /* MESSAGE # 1793 -  E-MAIL MESSAGE SENT. */
                  {pxmsg.i &MSGNUM=1793  &ERRORLEVEL=1 }
               end.  /* IF l_emailsent */

            end. /* IF return_code > 0 THEN DO: */

         end. /* IF CAN-FIND (FIRST rqpo_wrk WHERE rqpo_copy_to_po) THEN DO: */
         else do:

            {pxmsg.i &MSGNUM=1855 &ERRORLEVEL=1}
            /* NO REQUISITIONS SELECTED FOR ACTION */

         end.  /* IF CAN-FIND (FIRST rqpo_wrk) */

      end.  /* IF info_correct */

   end.  /* IF rqpo_wrk_cntr = 0 */

end.  /* REPEAT */

PROCEDURE send_email:

   define input parameter p_subject as character no-undo.
   define input parameter p_userid  as character no-undo.
   define input parameter p_out     as character no-undo.

   define variable email_return_code   as integer   no-undo.
   define variable email_return_userid as character no-undo.

   if p_userid = "" then leave.
   {gprun.i ""mgemsend.p""
      "(input p_userid,
         input '',
         input p_subject,
         input p_out ,
         input '',
         input false,
         input ?,
         output email_return_code,
         output email_return_userid)"}

   if email_return_code <> 0 then do:
      {pxmsg.i &MSGNUM=email_return_code &ERRORLEVEL=2}
   end. /* IF email_return_code <> 0 THEN DO: */

end. /* send_email */

PROCEDURE displaySummary:

   define input  parameter pReqNbr like rqm_mstr.rqm_nbr no-undo.

   define variable l_fld1 as character format "x(8)"  no-undo.
   define variable l_fld2 as character format "x(35)" no-undo.

   form
      l_fld1        at 1  column-label {&rqpobld_p_6}
      pod_site      at 10 column-label {&rqpobld_p_7}
      pod_part      at 20 column-label {&rqpobld_p_8}
      po_vend       at 40 column-label {&rqpobld_p_9}
      po_due_date   at 51 column-label {&rqpobld_p_10}
      pod_pur_cost  at 60 column-label {&rqpobld_p_11}
   with frame eSum width 80 down .

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame eSum:handle).

   form
      pod_req_nbr
      pod_due_date
      pod_request
   with frame new1 side-labels width 80 down.


   /* SET EXTERNAL LABELS */
   setFrameLabels(frame new1:handle).

   {gpfildel.i &filename=""summary.out"" }


   output to summary.out .

   for each rqd_det  where rqd_det.rqd_domain = global_domain and  rqd_nbr  =
   pReqNbr
                    and   rqd_line >= 0
                    and   rqd_open = no no-lock,
      each pod_det  where pod_det.pod_domain = global_domain and  pod_req_nbr
      = pReqNbr
                    and  pod_req_line = rqd_line
                    and  pod_due_date = rqd_due_date
                    and  pod_part     = rqd_part no-lock,
      first po_mstr  where po_mstr.po_domain = global_domain and  po_nbr =
      pod_nbr no-lock
      break by pod_req_line:

      if first( pod_req_line )
      then
         display
            pod_req_nbr
            pod_due_date
            pod_request
         with frame new1 side-labels width 80 down.

      display
         trim(string(pod_req_line)) @ l_fld1
         pod_site
         pod_part
         po_vend
         po_due_date
         pod_pur_cost
      with frame eSum width 80 down .

      down 1 with frame eSum  .

      display
         po_nbr                 @ l_fld1
         trim(string(pod_line)) @ pod_site
         trim(string(pod_qty_ord,"->,>>>,>>9.9<<<<<" )) @ pod_part
         pod_um                 @ po_vend
         pod_disc_pct           @ po_due_date
         if ((pod__qad02 = 0 or pod__qad02 = ?) and
             (pod__qad09 = 0 or pod__qad09 = ?)
            )
         then pod_qty_ord * pod_pur_cost  * (1 - (pod_disc_pct / 100))
         else pod_qty_ord * (pod__qad09 + pod__qad02 / 100000)
                                @ pod_pur_cost
      with frame eSum  .

      down 2 with frame eSum  .

      {mfrpchk.i }

   end. /* FOR EACH pod_det */

   l_fld2 =  getTermLabel("END_OF_REPORT",35) .

   display skip(1) l_fld2 at 35
   with frame r_end no-label width 80 .
   output close .

end. /* PROCEDURE displaySummary */
