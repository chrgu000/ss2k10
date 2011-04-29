/* xxpoprmt1.p - PURCHASE REQUISITION MAINTENANCE (FIRST/SECOND LEVEL)  */
/* poprmt.p - PURCHASE REQUISITION MAINTENANCE                          */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.30 $                                                         */
/* REVISION: 1.0     LAST MODIFIED: 05/05/86    BY: EMB                 */
/* REVISION: 6.0     LAST MODIFIED: 07/06/90    BY: EMB *D040*          */
/* REVISION: 6.0     LAST MODIFIED: 07/16/90    BY: RAM *D030*          */
/* REVISION: 6.0     LAST MODIFIED: 03/26/91    BY: RAM *D455*          */
/* REVISION: 7.0     LAST MODIFIED: 08/26/91    BY: MLV *F006*          */
/* REVISION: 7.0     LAST MODIFIED: 10/10/91    BY: dgh *D892*          */
/* REVISION: 7.0     LAST MODIFIED: 10/17/91    BY: emb *F024*          */
/* REVISION: 6.0     LAST MODIFIED: 10/30/91    BY: emb *D906*          */
/* REVISION: 7.0     LAST MODIFIED: 11/19/91    BY: pma *F003*          */
/* REVISION: 7.0     LAST MODIFIED: 12/08/91    BY: RAM *F033*          */
/* REVISION: 7.0     LAST MODIFIED: 03/24/92    BY: pma *F089*          */
/* REVISION: 7.0     LAST MODIFIED: 04/13/92    BY: RAM *F386*          */
/* REVISION: 7.0     LAST MODIFIED: 05/06/92    BY: afs *F474*          */
/* REVISION: 7.3     LAST MODIFIED: 04/19/93    BY: afs *G973*          */
/* REVISION: 7.3     LAST MODIFIED: 06/25/93    BY: afs *GC77*   (rev only) */
/* REVISION: 7.3     LAST MODIFIED: 06/29/93    BY: cdt *GC89*          */
/* REVISION: 7.3     LAST MODIFIED: 08/13/93    BY: dpm *GE17*   (rev only) */
/* REVISION: 7.3     LAST MODIFIED: 09/15/93    BY: afs *GF32*          */
/* REVISION: 7.3     LAST MODIFIED: 06/16/93    BY: afs *FO93*          */
/* REVISION: 7.3     LAST MODIFIED: 09/01/94    BY: ljm *FQ67*          */
/* Oracle changes (share-locks)     09/12/94    BY: rwl *GM41*          */
/* REVISION: 8.5     LAST MODIFIED: 10/18/94    BY: mwd *J034*          */
/* REVISION: 8.5     LAST MODIFIED: 03/01/96    BY: rxm *G1PJ*          */
/* REVISION: 8.5     LAST MODIFIED: 05/27/96    BY: *J0NX* M. Deleeuw   */
/* REVISION: 8.5     LAST MODIFIED: 08/26/96    BY: *G2CY* Suresh Nayak */
/* REVISION: 8.5     LAST MODIFIED: 11/15/96    BY: *J188* Aruna Patil  */
/* REVISION: 8.5     LAST MODIFIED: 07/31/97    BY: *J1YW* B. Gates     */
/* REVISION: 8.5     LAST MODIFIED: 10/09/97    BY: *J231* Patrick Rowan*/
/* REVISION: 8.5     LAST MODIFIED: 10/28/97    BY: *J249* Patrick Rowan*/
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane    */
/* REVISION: 8.6E    LAST MODIFIED: 03/31/98    BY: *J2G7* Samir Bavkar */
/* REVISION: 8.6E    LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan       */
/* REVISION: 8.6E    LAST MODIFIED: 10/04/98    BY: *J314* Alfred Tan       */
/* REVISION: 9.0     LAST MODIFIED: 11/18/98    BY: *J34Q* Reetu Kapoor     */
/* REVISION: 9.0     LAST MODIFIED: 12/08/98    BY: *M02C* Jim Williams     */
/* REVISION: 9.0     LAST MODIFIED: 03/13/99    BY: *M0BD* Alfred Tan       */
/* REVISION: 9.0     LAST MODIFIED: 08/12/99    BY: *L0G8* Ranjit Jain      */
/* REVISION: 9.1     LAST MODIFIED: 10/01/99    BY: *N014* Brian Compton    */
/* REVISION: 9.1     LAST MODIFIED: 01/19/00    BY: *N077* Vijaya Pakala    */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1     LAST MODIFIED: 09/04/00    BY: *N0RC* Mark Brown       */
/* REVISION: 9.1     LAST MODIFIED: 08/17/00    BY: *N0KM* Mudit Mehta      */
/* REVISION: 9.1     LAST MODIFIED: 11/08/00    BY: *N0TN* Jean Miller      */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* Revision: 1.26     BY: Niranjan R.       DATE: 04/09/01 ECO: *P00L*  */
/* Revision: 1.27     BY: Samir Bavkar.     DATE: 01/31/02 ECO: *P000*  */
/* Revision: 1.28  BY: Rajaneesh S. DATE: 08/29/02 ECO: *M1BY* */
/* $Revision: 1.30 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00J* */
/* REVISION: eB2.1SP5    LAST MODIFIED: 09/17/09     BY: Apple Tam *ss-20090917*         */
/*                   1. Display Min. Order & Multi Order Qty            */
/*                   2. Display the Item Status, Group, Buyer and Pur LT*/      
/*                   3. Add field req__dec01 for Excess Qty             */
/*                   4. Add field req__dec02 for Excess Amount          */
/*                   5. Extent pt_desc to "x(49)" + pt_desc2            */
/*                   1. ptp_buyer should be setup b4 creating records   */
/*                   2. Only Allow to Modify Need Date, Comments        */
/*                      and Reduce Qty after 1st/2nd Approval           */
/*                   3. No History Record if Delete after 1st Approval  */
/*                   4. Update Last Edit if Delete after 2nd Approval   */
/*                   5. Modify not allowed when Qty deduced from PO     */
/*                   6. Delete PR Open Qty will Update Last Edit & Qty  */
/*                      and update usrw_key6 = "V", if available        */
/*                   7. Hide Excess Amount (for user only)              */
/*                   8. Update req__log01 after 1st(Mgr) Approval       */
/*                   9. Update usrw_wkfl for 2nd(Director) Approval     */
/*                  10. Default Approved By to User ID                  */
/*                  11. After 2nd Approval, not allow to disapproved    */
/*                  12. Display User Name(usr_name) format x(12)        */
/*                  1. Save Excess Amount(req__dec02) as Base Currency  */
/*                  2. Combine xxpoprmt1.p, xxpoprmt2.p into one program*/
/*                  1. Allow Users Modify PR Details, like Remark...    */
/* Modify frame layout & update sequence to avoid Qty changed by mistake*/
/* Add req__chr05 for PMC planner to input Deliver To and defa to PO    */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Maintenance                                                  */

/**************************************************************************/
/*     PROGRAM poprmt.p WAS USED AS A TEMPLATE FOR NEW PROGRAM giapimpe.p */
/*     IN THE ON/Q PLANNING AND OPTIMIZATION API INTERFACE PROJECT.  NEW  */
/*     FUNCTIONAL AND STRUCTURAL CHANGES MADE TO poprmt.p SHOULD BE       */
/*     EVALUATED FOR SUITABILITY FOR INCLUSION WITHIN giapimpe.p.         */
/**************************************************************************/

/* NOTE: MFDTITLE.I MOVED TO TOP OF PROGRAM          */
/* DISPLAY TITLE */
/*ss-20090917****/ {mfdtitle.i "2+ "}
/*ss-20090917 {mfdeclre.i}*/

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE poprmt_p_1 "Extended Amount"
/* MaxLen: Comment: */

&SCOPED-DEFINE poprmt_p_2 "Comments"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define new shared variable desc1 like pt_desc1
/*ss-20090917*/                                 format "x(49)".
/*ss-20090917*/define new shared variable desc2 like pt_desc2 format "x(49)".
define variable del-yn like mfc_logical initial no.
define variable line like req_line.
define variable leadtime like pt_pur_lead.
define variable i as integer.
define variable nonwdays as integer.
define variable workdays as integer.
define variable overlap as integer.
define variable know_date as date.
define variable find_date as date.
define variable interval as integer.
define variable frwrd as integer.
define variable temp_date as date.
define variable reqnbr like req_nbr.
define new shared variable cmt-yn like mfc_logical
   initial no label {&poprmt_p_2}.
define new shared variable puramt like req_pur_cost
   label {&poprmt_p_1}.
define new shared variable req_recno as recid.
define new shared frame a.
define new shared frame b.
define new shared variable undo-all like mfc_logical.
define new shared variable new_req  like mfc_logical.

define variable valid_acct like mfc_logical.
define variable gl-site    like in_site   no-undo.
define variable gl-set     like in_gl_set no-undo.
define variable using_grs  like mfc_logical no-undo.

/*ss-20090917** /*ss-20090917*/define new shared variable usr-level as character.  **/
/*ss-20090917*/define shared variable usr-level as character.
/*ss-20090917*/define variable continue like mfc_logical.
/*ss-20090917*/define variable prev_qty like req_qty.
/*ss-20090917*/define variable prev_need like req_need.
/*ss-20090917*/define shared variable reqno like req_nbr.

/* DISPLAY SELECTION FORM */
form
   req_nbr        colon 25
   req_line       no-label at 27 no-attr-space
/*ss-20090917* req_part       colon 25 **/
/*ss-20090917*/req_part       colon 7 label "料號"
   desc1          no-label no-attr-space
/*ss-20090917* req_site       colon 25 **/
/*ss-20090917*/req_site       colon 7
/*ss-20090917*/desc2          no-label at 29 no-attr-space
/*ss-20090917*/ req__log01   colon 15 label "核准"
/*ss-20090917*/ req__chr05   label "交付" format "x(2)"
/*ss-20090917*/ req_qty      colon 55 
         req_um         colon 15
/*ss-20090917*/ptp_ord_min    colon 55         
/*F006*/ req_pur_cost   colon 15
/*ss-20090917*/ptp_ord_mult   colon 55
         req_rel_date   colon 15
/*ss-20090917*/pt_status      colon 55
         req_need       colon 15
/*ss-20090917*/ptp_pur_lead   colon 55         
         req_request    colon 15
/*ss-20090917*/space(1) usr_name no-label format "x(12)"
/*ss-20090917*/pt_group       colon 55
         req_acct       colon 15
   req_sub        no-label no-attr-space
   req_cc         no-label no-attr-space
/*ss-20090917*/ptp_buyer      colon 55
/*F033*/ req_po_site    colon 15
/*ss-20090917*/req__dec01     colon 55 label "超額/剩餘數量" format "->>>,>>>,>>9.99"
         req_print      colon 15  cmt-yn
/*ss-20090917*/req__dec02     colon 55 label "超額/剩餘金額" format "->>>,>>>,>>9.99"
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{poprfrm.i}               /* shared frame definition */

using_grs = can-find(mfc_ctrl
                where mfc_ctrl.mfc_domain = global_domain and  mfc_field   =
                "grs_installed"
                 and mfc_logical = yes).

if using_grs then do:

   {pxmsg.i &MSGNUM=2123 &ERRORLEVEL=4}
   /*GRS enabled*/

   if not batchrun then pause.
   leave.
end.

find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock no-error.

/* DISPLAY */
view frame a.
view frame b.

mainloop:
repeat:
   do transaction:
      assign new_req = false.
/*ss-20090917*/      prev_qty = 0.
/*ss-20090917*/      prev_need = ?.
/*ss-20090917** begin delete section ***
      prompt-for req_nbr with frame a
      editing:

         /* Allow last req number refresh */
         if keyfunction(lastkey) = "RECALL" or lastkey = 307
            then display reqnbr @ req_nbr with frame a.

         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i req_det req_nbr  " req_det.req_domain = global_domain and
         req_nbr "  req_nbr req_nbr req_nbr}

         if recno <> ? then do:

            desc1 = caps(getTermLabel("ITEM_NOT_IN_INVENTORY",24)).
            find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part
            = req_part no-lock no-error.
            if available pt_mstr then desc1 = pt_desc1.
            cmt-yn =

            can-find(first cmt_det  where cmt_det.cmt_domain = global_domain
            and  cmt_indx = req_cmtindx).
            display req_nbr req_line req_part desc1
               req_site
               req_qty req_um
               req_pur_cost
               req_rel_date
               req_need
               req_request
               req_acct
               req_sub
               req_cc
               req_po_site
               req_print
               cmt-yn with frame a.
            display req_apr_code req_apr_prnt
               req_approved req_apr_by req_apr_ent with frame b.
            /*CALCULATE AND DISPLAY EXTENDED AMOUNT*/
            puramt = req_pur_cost * req_qty.

            display puramt with frame b.
            line = req_line.
         end. /* IF RECNO <> ? */
      end. /* EDITING */
.*ss-20090917** end delete section ***/
   end.  /* transaction */

/*ss-20090917** begin delete section ***
   /*GET NEXT REQ NUMBER IF BLANK */
   do transaction with frame a:
      reqnbr = "".
      if input req_nbr <> "" then reqnbr = input req_nbr.
      else do:
         find first woc_ctrl  where woc_ctrl.woc_domain = global_domain no-lock
         no-error.
         if not available woc_ctrl then do:  create woc_ctrl.
         woc_ctrl.woc_domain = global_domain. end.
         {mfnctrl.i "woc_ctrl.woc_domain = global_domain" "woc_ctrl.woc_domain"
         "req_det.req_domain = global_domain" woc_ctrl woc_nbr req_det req_nbr
         reqnbr}
      end.
      if reqnbr = "" then undo, retry.
      display reqnbr @ req_nbr.
   end.  /* transaction */
.*ss-20090917** end delete section ***/

   do transaction:

      /* ADD/MODIFY/DELETE */
/*ss-20090917**
      find req_det  where req_det.req_domain = global_domain and  req_nbr =
      reqnbr exclusive-lock no-error.
 *ss-20090917**/
/*ss-20090917*/      find req_det where req_det.req_domain = global_domain and req_nbr = reqno exclusive-lock no-error.
      if ambiguous req_det then
      find req_det  where req_det.req_domain = global_domain and  req_nbr =
      reqnbr

         and req_line = line exclusive-lock no-error.

      if available req_det then do:
         {pxmsg.i &MSGNUM=10 &ERRORLEVEL=1}
         display req_nbr with frame a.
      end.

      if not available req_det then do:
/*ss-20090917*/      leave.
/*ss-20090917** begin ***

         undo-all = true.
         {gprun.i ""poprmtb.p""}
         if undo-all then
            undo mainloop, retry mainloop.

         find req_det where recid(req_det) = req_recno
            exclusive-lock no-error.
.*ss-20090917** end ***/

      end. /* IF NOT AVAILABLE REQ_DET */

      ststatus  =  stline[2].
      status input ststatus.
      del-yn = no.

      desc1 = caps(getTermLabel("ITEM_NOT_IN_INVENTORY",24)).
/*ss-20090917*/      desc2 = " ".
      find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
      req_part no-lock no-error.
      find ptp_det  where ptp_det.ptp_domain = global_domain and  ptp_part =
      req_part and ptp_site = req_site
         no-lock no-error.
      if available pt_mstr then do:
         desc1 = pt_desc1.
/*ss-20090917*/         desc2 = pt_desc2.

         if new_req then do:
            req_um = pt_um.
            find pl_mstr
                where pl_mstr.pl_domain = global_domain and  pl_prod_line =
                pt_prod_line no-lock no-error.
            if available pl_mstr
            then do:
               {gprun.i ""glactdft.p"" "(input ""PO_PUR_ACCT"",
                                         input pl_prod_line,
                                         input req_site,
                                         input """",
                                         input """",
                                         input no,
                                         output req_acct,
                                         output req_sub,
                                         output req_cc)"}
            end.
         end.
      end.

      if new_req then do:
         if available ptp_det then do:
            req_need = req_rel_date + ptp_pur_lead.
            {mfhdate.i req_need 1 req_site}
            req_po_site = ptp_po_site.
         end.
         else
            if available pt_mstr then do:
            req_need = req_rel_date + pt_pur_lead.
            {mfhdate.i req_need 1 req_site}
            req_po_site = pt_po_site.
         end.
         else req_po_site = req_site.
      end.

      /* SET GLOBAL PART VARIABLE */
      global_part = req_part.

      /*CALCULATE AND DISPLAY EXTENDED AMOUNT*/
      if not available pt_mstr then
         puramt = req_pur_cost * req_qty.
      else do:

         /* GPSCT05.I LOOKS FOR IN_MSTR AND GETS THE COST, IF */
         /* IT IS NOT AVAILABLE, VALUES OF 0.00 ARE RETURNED. */
         /* IF NOT AVAIABLE, IN_MSTR IS CREATED LATER IN THIS */
         /* PROGRAM.                                          */
         /* WITH LINKED SITE COSTING, IF THE SELECTED ITEM AND*/
         /* SITE ARE LINKED TO ANOTHER SITE, I.E. IF A LINKING*/
         /* RULE EXIST FOR SELECTED SITE, THEN IN_MSTR IS     */
         /* CREATED WITH THE LINK. (I.E. IN_GL_COST_SITE      */
         /* SOURCE SITE AND IN_GL_SET = SOURCE GL COST SET.)  */
         /* THEREFORE FOR LINKED SITES THE UNIT COST RETRIEVED*/
         /* HERE SHOULD BE THE COST AT THE SOURCE SITE.       */
         /* TO AVOID CHANGING THE IN_MSTR CREATION TIMING WE  */
         /* FIND THE SOURCE SITE AND GET THE COST AT THAT SITE*/

         gl-site = req_site.
         for first in_mstr  where in_mstr.in_domain = global_domain and
         in_part = pt_part
                             and in_site = req_site no-lock:
         end.
         if not available in_mstr then
            {gprun.i ""gpingl.p""
                     "(input  req_site,
                       input  pt_part,
                       output gl-site,
                       output gl-set)"}

         {gpsct05.i
            &part=pt_part
            &site=gl-site
            &cost=sct_mtl_tl}
         req_pur_cost = glxcst.
         puramt = req_pur_cost * req_qty.

      end.

      cmt-yn = can-find(first cmt_det  where cmt_det.cmt_domain = global_domain
      and  cmt_indx = req_cmtindx).
/*ss-20090917*/      find first usr_mstr where usr_userid = req_request
/*ss-20090917*/      no-lock no-error.

      display req_nbr req_line req_part desc1
/*ss-20090917*/      desc2
         req_site
         req_qty req_um
/*ss-20090917*/      req__log01
/*ss-20090917*/     req__chr05
/*ss-20090917*/      ptp_ord_min when available ptp_det
         req_pur_cost
/*ss-20090917*/      when usr-level <> '0'
/*ss-20090917*/      ptp_ord_mult when available ptp_det
         req_rel_date
/*ss-20090917*/      pt_status when available pt_mstr
         req_need
/*ss-20090917*/      ptp_pur_lead when available ptp_det
         req_request
/*ss-20090917*/      usr_name when available usr_mstr
/*ss-20090917*/      pt_group when available pt_mstr
         req_acct
         req_sub  
         req_cc
/*ss-20090917*/      ptp_buyer when available ptp_det
         req_po_site
/*ss-20090917*/      req__dec01
         req_print
/*ss-20090917*/      req__dec02 when usr-level <> '0' 
         cmt-yn with frame a.

      {gprun.i ""gpsiver.p""
         "(input req_site, input ?, output return_int)"}
      if return_int = 0 then do:
         {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}        /* USER DOES NOT HAVE */
         /* ACCESS TO THIS SITE*/
         undo mainloop, retry.
      end.

      display req_apr_code req_apr_prnt
         req_approved req_apr_by req_apr_ent puramt 
/*ss-20090917*/      when usr-level <> '0'
	 with frame b.

      seta-2:
      do with frame a on error undo, retry:
/*ss-20090917*/       prev_qty = req_qty.
/*ss-20090917*/       prev_need = req_need.
/*ss-20090917** /*ss-20090917*/       if not req_approved then do:  **/
/*ss-20090917*/       if not req_approved and usr-level <> '0' then do:
         set
/*ss-20090917*/        req__log01
 /*ss-20090917*/        req__chr05 when req__chr01 = "" and usr-level = "1"
            req_qty  /* req_um */
            req_um when (not available pt_mstr)
            req_pur_cost when (not available pt_mstr)
/*ss-20090917**         req_rel_date  **/
            req_need
/*ss-20090917**         req_request   **/  
            req_acct when (not available pt_mstr)
            req_sub  when (not available pt_mstr) 
            req_cc   when (not available pt_mstr)
            req_po_site
            req_print
            cmt-yn
            go-on ("F5" "CTRL-D").
/*ss-20090917*/       end.
/*ss-20090917*/       else do:
/*ss-20090917*/       find usrw_wkfl where usrw_wkfl.usrw_domain = global_domain and usrw_key1 = req_nbr
/*ss-20090917*/       and int(usrw_key2) = req_line and usrw_key3 = "PR"
/*ss-20090917*/       and usrw_decfld[1] <> prev_qty 
/*ss-20090917*/       no-lock no-error.
/*ss-20090917*/       if not available usrw_wkfl then do:
/*ss-20090917*/         set
/*ss-20090917*/        req__chr05 when req__chr01 = "" and usr-level = "1"
/*ss-20090917*/         req_qty
/*ss-20090917*/         req_need
/*ss-20090917*/         req_acct    when not req__log01
/*ss-20090917*/         req_cc      when not req__log01
/*ss-20090917*/         req_po_site when not req__log01
/*ss-20090917*/         req_print   when not req__log01
/*ss-20090917*/         cmt-yn
/*ss-20090917*/         go-on ("F5" "CTRL-D").
/*ss-20090917*/       end.
/*ss-20090917*/       else do:
/*ss-20090917         message "警告: 不允許更改, 請購單附於採購單上.".*/
/**ss-20090917*/		{pxmsg.i &MSGNUM=9026 &ERRORLEVEL=2}
/*ss-20090917*/         set 
/*ss-20090917*/         cmt-yn
/*ss-20090917*/         go-on ("F5" "CTRL-D").
/*ss-20090917*/       end.
/*ss-20090917*/       end.
/*ss-20090917*/       if new_req then req__log01 = no.

         /* DELETE */
         if lastkey = keycode("F5")
            or lastkey = keycode("CTRL-D")
         then do:
            del-yn = yes.
            {mfmsg01.i 11 1 del-yn}
            if del-yn = no then undo seta-2, retry seta-2.
         end.
         if del-yn or req_part = "" then do:

/*ss-20090917*/            /* CHECK usrw_wkfl BEFORE DELETE*/
/*ss-20090917*/            find usrw_wkfl where usrw_wkfl.usrw_domain = global_domain and usrw_key1 = req_nbr
/*ss-20090917*/            and int(usrw_key2) = req_line and usrw_key3 = "PR"
/*ss-20090917*/            exclusive-lock no-error.
/*ss-20090917*/            if available usrw_wkfl then do:

/*ss-20090917*/              if usrw_decfld[1] = req_qty then do:
/*ss-20090917*/                 continue = yes.
/*ss-20090917*/                 {mfmsg01.i 8266 2 continue}
/*ss-20090917*/                 if continue = no then undo seta-2, retry seta-2.
/*ss-20090917*/              end.
/*ss-20090917*/              else do:
/*ss-20090917*/                 usrw_decfld[1] = usrw_decfld[1] - req_qty.
/*ss-20090917*/              end.
/*ss-20090917*/              usrw_key6 = "V".
/*ss-20090917*/              usrw_charfld[1] = global_userid.
/*ss-20090917*/              usrw_datefld[3] = today.
/*ss-20090917*/            end.

            /* mrp workfile */
            /* Changed pre-processor to Term */
            {mfmrw.i "req_det" req_part req_nbr string(req_line) """"
               req_rel_date req_need
               "0" "SUPPLYF" PURCHASE_REQUISITION req_site}

            /* DELETE COMMENTS */
            for each cmt_det exclusive-lock
                   where cmt_det.cmt_domain = global_domain and  cmt_indx =
                   req_cmtindx:
               delete cmt_det.
            end.

            delete req_det.
            clear frame a.
            {pxmsg.i &MSGNUM=22 &ERRORLEVEL=1}
            del-yn = no.
            next mainloop.
         end.

         if req_qty = 0 then do:
            {pxmsg.i &MSGNUM=317 &ERRORLEVEL=3}
            /* ZERO NOT ALLOWED */
            next-prompt req_qty with frame a.
            undo seta-2, retry.
         end.

/*ss-20090917*/      if usr-level = '1'
/*ss-20090917*/       or usr-level = '0'
/*ss-20090917*/      then do:
/*ss-20090917*/         if not new_req and req__log01 then do:
/*ss-20090917*/          if prev_qty < req_qty then do:
/*ss-20090917*/            bell.
/*ss-20090917            message "錯誤: 修改數量大於核准數量.".*/
/*ss-20090917*/		    {pxmsg.i &MSGNUM=9027 &ERRORLELVE=3}
/*ss-20090917*/            next-prompt req_qty with frame a.
/*ss-20090917*/            undo seta-2, retry.
/*ss-20090917*/          end.
/*ss-20090917*/          if (prev_qty > req_qty or prev_need <> req_need)
/*ss-20090917*/          then do:
/*ss-20090917*/            req_user1 = global_userid.
/*ss-20090917*/            req__dte01 = today.
/*ss-20090917*/          end.
/*ss-20090917*/         end.
/*ss-20090917*/      end.

/*ss-20090917*/         /* CHECK usrw_wkfl */
/*ss-20090917*/         find usrw_wkfl where usrw_domain = global_domain and usrw_key1 = req_nbr
/*ss-20090917*/         and int(usrw_key2) = req_line and usrw_key3 = "PR"
/*ss-20090917*/         exclusive-lock no-error.
/*ss-20090917*/         if available usrw_wkfl then do:
/*ss-20090917*/            if input req_qty > usrw_decfld[1] then do:
/*ss-20090917*/              bell.
/*ss-20090917              message "錯誤: 修改數量大於核准數量.".*/
/*ss-20090917*/		    {pxmsg.i &MSGNUM=9027 &ERRORLELVE=3}
/*ss-20090917*/              next-prompt req_qty with frame a.
/*ss-20090917*/              undo seta-2, retry.
/*ss-20090917*/            end.
/*ss-20090917*/            else if prev_qty = usrw_decfld[1] 
/*ss-20090917*/                 and (input req_qty < usrw_decfld[1]
/*ss-20090917*/                 or input req_need <> usrw_datefld[2])
/*ss-20090917*/            then do:
/*ss-20090917*/              usrw_decfld[1] = req_qty.
/*ss-20090917*/              usrw_datefld[2] = req_need.
/*ss-20090917*/              usrw_charfld[1] = global_userid.
/*ss-20090917*/              usrw_datefld[3] = today.
/*ss-20090917*/            end.
/*ss-20090917*/         end.

/*ss-20090917*/         if available ptp_det then do:
/*ss-20090917*/             if req_qty < ptp_ord_min then do:
/*ss-20090917*/                bell.
/*ss-20090917               message "警告: 訂單數量少於最小訂貨數量.".*/ 
/*ss-20090917*/		    {pxmsg.i &MSGNUM=9028 &ERRORLELVE=2}
/*ss-20090917*/             end.

/*ss-20090917*/             if (ptp_ord_mult <> 0 and ((req_qty / ptp_ord_mult) 
/*ss-20090917*/                     <> integer(req_qty / ptp_ord_mult))) then do:
/*ss-20090917*/                bell.
/*ss-20090917                message "警告: 訂貨數量不正確.".*/
/*ss-20090917*/		    {pxmsg.i &MSGNUM=9029 &ERRORLELVE=2}
/*ss-20090917*/             end.

/*ss-20090917*/             if (ptp_pur_lead > req_need - req_rel_date) then do:
/*ss-20090917*/                bell.
/*ss-20090917               message "警告: (需求日期 - 請購發放日期)少於採購LT.".*/ 
/*ss-20090917*/		     {pxmsg.i &MSGNUM=9030 &ERRORLELVE=2}
/*ss-20090917*/             end. 
/*ss-20090917*/         end.  /* available ptp_det */


         /*  Verify G/L account and cost center combination. */

         {gprunp.i "gpglvpl" "p" "initialize"}
         /* SET PROJECT VERIFICATION TO NO */
         {gprunp.i "gpglvpl" "p" "set_proj_ver" "(input false)"}
         {gprunp.i "gpglvpl" "p" "validate_fullcode"
            "(input req_acct,
                            input req_sub,
                            input req_cc,
                            input """",
                            output valid_acct)"}
         if valid_acct = no then do:
            next-prompt req_acct with frame a.
            undo seta-2, retry.
         end.

         if req_po_site <> "" then do:
            if not can-find(si_mstr  where si_mstr.si_domain = global_domain
            and  si_site = req_po_site) then do:
               {pxmsg.i &MSGNUM=708 &ERRORLEVEL=3}
               /* SITE DOES NOT EXIST */
               next-prompt req_po_site with frame a.
               undo seta-2, retry.
            end.
         end.  /* IF REQ_PO_SITE <> "" */

         if req_rel_date = ? and req_need = ? then
            req_rel_date = today.
         if req_rel_date = ? or req_need = ? then do:
            leadtime = 0.
            if available ptp_det then
               leadtime = ptp_pur_lead.
            else
               if available pt_mstr then
               leadtime = pt_pur_lead.

            if req_rel_date = ? then
               req_rel_date = req_need - leadtime.
            if req_need = ? then
               req_need = req_rel_date + leadtime.
         end.
         {mfhdate.i req_need 1 req_site}
         {mfhdate.i req_rel_date -1 req_site}
/*ss-20090917*/         if new_req then req_rel_date = today.
         display req_rel_date req_need.

         /* Changed pre-processor to Term */
         {mfmrw.i "req_det" req_part req_nbr string(req_line) """"
            req_rel_date req_need
            "req_qty" "SUPPLYF" PURCHASE_REQUISITION req_site}

         puramt = req_pur_cost * req_qty.

/*ss-20090917*/ /* CALCULATE EXCESS QTY(req__dec01) and EXCESS AMOUNT(req__dec02)*/
/*ss-20090917*/         for each in_mstr where in_mstr.in_domain = global_domain and in_site = req_site
/*ss-20090917*/                            and in_part = req_part 
/*ss-20090917*/         no-lock:
/*ss-20090917*/           req__dec01 = in_qty_oh. 
/*ss-20090917*/           for each mrp_det where mrp_det.mrp_domain = global_domain and mrp_site = req_site 
/*ss-20090917*/                              and mrp_part = req_part 
/*ss-20090917*/           no-lock:
/*ss-20090917*/              if index(mrp_type,"demand") > 0 
/*ss-20090917*/                 then req__dec01 = req__dec01 - mrp_qty. 
/*ss-20090917*/              else 
/*ss-20090917*/              if index(mrp_type,"supply") > 0
/*ss-20090917*/                       and mrp_type <> "supplyp"
/*ss-20090917*/                 then req__dec01 = req__dec01 + mrp_qty.
/*ss-20090917*/           end. 
/*ss-20090917*/           req__dec02 = 0. 
/*ss-20090917*/           find last prh_hist where prh_hist.prh_domain = global_domain and prh_part = req_part 
/*ss-20090917*/                                and prh_pur_cost <> 0 
/*ss-20090917*/           use-index prh_part no-lock no-error. 
/*ss-20090917*/           if available prh_hist
/*ss-20090917*/           then
/*ss-20090917**
./*ss-20090917*/             req__dec02 = prh_pur_cost * prh_ex_rate * req__dec01.
**ss-20090917*/
/*ss-20090917*/            req__dec02 = prh_pur_cost * req__dec01.
/*ss-20090917*/           else do:
/*ss-20090917*/             find last pod_det where pod_det.pod_domain = global_domain and pod_part = req_part
/*ss-20090917*/                                 and pod_pur_cost <> 0
/*ss-20090917*/             use-index pod_partdue no-lock no-error.
/*ss-20090917*/             if available pod_det then do:
/*ss-20090917*/               find first po_mstr where po_mstr.po_domain = global_domain and po_nbr = pod_nbr
/*ss-20090917*/               no-lock no-error.
/*ss-20090917*/               if available po_mstr then
/*ss-20090917**
./*ss-20090917*/                 req__dec02 = pod_pur_cost * po_ex_rate * req__dec01.
**ss-20090917**/
/*ss-20090917*/                req__dec02 = pod_pur_cost * po_ent_ex * req__dec01.
/*ss-20090917*/             end.
/*ss-20090917*/             else do:
/*ss-20090917*/               find first sct_det where sct_det.sct_domain = global_domain and sct_part = req_part
/*ss-20090917*/                    and sct_sim  = "Standard" and sct_site = req_site
/*ss-20090917*/               no-lock no-error. 
/*ss-20090917*/               if available sct_det then
/*ss-20090917*/                 req__dec02 = sct_cst_tot * req__dec01.
/*ss-20090917*/             end.
/*ss-20090917*/           end.
/*ss-20090917*/           display req__dec01 req__dec02 
/*ss-20090917*/                              when usr-level <> '0'
/*ss-20090917*/           with frame a.
/*ss-20090917*/         end.

      end. /* seta-2 */

      if new_req then do:
         /*DEFAULT THE APPROVAL CODE*/ /*do this w/in this transaction*/
         {gppacal.i}                   /*so be sure one gets set*/
      end.
   end.  /*transaction*/

   /* SET APPROVAL FIELDS */
   req_recno = recid(req_det).
/*ss-20090917* {gprun.i ""poprmta.p""} **/
/*ss-20090917*/   {gprun.i ""xxpoprmta.p""}

   clear frame a.
   clear frame b.

end. /* repeat */
status input.
