/* xxpoprmt1.p - PURCHASE REQUISITION MAINTENANCE (FIRST/SECOND LEVEL)  */
/* xxpoprmt.p - PURCHASE REQUISITION MAINTENANCE (FOR USER INPUT)       */
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
/* SSIVAN 07120201 BY:Ivan Yang Date:12/02/07  */
/*                   1. Display Min. Order & Multi Order Qty            */
/*                   2. Display the Item Status, Group, Buyer and Pur LT*/      
/*                   3. Add field req__dec01 for Excess Qty             */
/*                   4. Add field req__dec02 for Excess Amount          */
/*                   5. Extent pt_desc to "x(49)" + pt_desc2            */
/*                   6. ptp_buyer should be setup b4 creating records   */
/*                   7. Only Allow to Modify Need Date, Comments        */
/*                      and Reduce Qty after 1st/2nd Approval           */
/*                   8. No History Record if Delete after 1st Approval  */
/*                   9. Update Last Edit if Delete after 2nd Approval   */
/*                  10. Modify not allowed when Qty deduced from PO     */
/*                  11. Delete PR Open Qty will Update Last Edit & Qty  */
/*                      and update usrw_key6 = "V", if available        */
/*                  12. Hide Unit Cost, Excess/Ext Amount(For User Only)*/
/*                  13. Display User Name(usr_name) format x(12)        */
/*                  14. Save Excess Amount(req__dec02) as Base Currency */
/* SSIVAN 07120202 BY:Ivan Yang Date:12/02/07  */
/*                  1. remove 07120202 option 12			*/
/*                  2. Combine xxpoprmt1.p, xxpoprmt2.p into one program*/
/*                  3. Allow Users Modify PR Details, like Remark...    */
/*		    4.Modify frame layout & update sequence to avoid Qty changed by mistake*/
/*                  5. Hide Excess Amount (for user only)              */
/*                  6. Update req__log01 after 1st(Mgr) Approval       */
/*                  7. Update usrw_wkfl for 2nd(Director) Approval     */
/*                  8. Default Approved By to User ID                  */
/*                  9. After 2nd Approval, not allow to disapproved    */
/*                  10. Add req__chr05 for PMC planner to input Deliver To and defa to PO    */
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
{mfdtitle.i "2+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE poprmt_p_1 "Extended Amount"
/* MaxLen: Comment: */

/*SSIVAN 07120201 rmk*/ /* &SCOPED-DEFINE poprmt_p_2 "Comments"	 */
/*SSIVAN 07120201 add*/	   &SCOPED-DEFINE poprmt_p_2 "Comment"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define new shared variable desc1 like pt_desc1
/*SSIVAN 07120201 add*/                                 format "x(49)".
/*SSIVAN 07120201 add*/ define new shared variable desc2 like pt_desc2 format "x(49)".
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

/*SSIVAN 07120202 rmk*/ /* /*SSIVAN 07120201 add*/ define new shared variable usr-level as character. */
/*SSIVAN 07120202 add*/ define shared variable usr-level as character.
/*SSIVAN 07120201 add*/ define variable continue like mfc_logical.
/*SSIVAN 07120201 add*/ define variable prev_qty like req_qty.
/*SSIVAN 07120201 add*/ define variable prev_need like req_need.
/*SSIVAN 07120202 add*/ define shared variable reqno like req_nbr.

/* DISPLAY SELECTION FORM */
form
   req_nbr        colon 25
   req_line       no-label at 27 no-attr-space
/*SSIVAN 07120201 rmk */ /* req_part       colon 25   */
/*SSIVAN 07120201 add */    req_part       colon 7 label "Item"
   desc1          no-label no-attr-space
/*SSIVAN 07120201 rmk*/  /* req_site       colon 25  */
/*SSIVAN 07120201 add */ req_site       colon 7
/*SSIVAN 07120201 add */ desc2          no-label at 29 no-attr-space
/*SSIVAN 07120202 rmk begin*
   req_qty        colon 25
/*SSIVAN 07120201 add */ req__log01     colon 55 label "Approved"
*SSIVAN 07120202 rmk end*/
/*SSIVAN 07120202 add*/ req__log01   colon 10 label "Approved"
/*ss-apple*/ req__chr05   label "Deliver" format "x(2)"
/*SSIVAN 07120202 add*/ req_qty      colon 55
   req_um         colon 10
/*SSIVAN 07120201 add */ ptp_ord_min    colon 55
   req_pur_cost   colon 10
/*SSIVAN 07120201 add */ ptp_ord_mult   colon 55
   req_rel_date   colon 10
/*SSIVAN 07120201 add */ pt_status      colon 55
   req_need       colon 10
/*SSIVAN 07120201 add */ ptp_pur_lead   colon 55
   req_request    colon 10
/*SSIVAN 07120201 add */ space(1) usr_name no-label format "x(12)"
/*SSIVAN 07120201 add */ pt_group       colon 55
   req_acct       colon 10
   req_sub        no-label no-attr-space
   req_cc         no-label no-attr-space
/*SSIVAN 07120201 add */ ptp_buyer      colon 55
   req_po_site    colon 10
/*SSIVAN 07120201 add */ req__dec01     colon 55 label "Excess Qty" format "->>>,>>>,>>9.99"
   req_print      colon 10  cmt-yn
/*SSIVAN 07120201 add */ req__dec02     colon 55 label "Excess Amt" format "->>>,>>>,>>9.99"
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
      assign new_req = false
/*SSIVAN 07120201 add */      prev_qty = 0
/*SSIVAN 07120201 add */      prev_need = ?      
      .

/*SSIVAN 07120202 rmk begin*
*      prompt-for req_nbr with frame a
*      editing:
*
*         /* Allow last req number refresh */
*         if keyfunction(lastkey) = "RECALL" or lastkey = 307
*            then display reqnbr @ req_nbr with frame a.
*
*         /* FIND NEXT/PREVIOUS RECORD */
*         {mfnp.i req_det req_nbr  " req_det.req_domain = global_domain and
*         req_nbr "  req_nbr req_nbr req_nbr}
*
*         if recno <> ? then do:
*
*            desc1 = caps(getTermLabel("ITEM_NOT_IN_INVENTORY",24)).
* /*SSIVAN 07120201 add */            desc2 = " ".
* /*SSIVAN 07120201 add */            find ptp_det where ptp_det.ptp_domain = global_domain and ptp_part = req_part
* /*SSIVAN 07120201 add */                          and ptp_site = req_site no-lock no-error.
*            find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part
*            = req_part no-lock no-error.
*            if available pt_mstr then 
* /*SSIVAN 07120201 add */  assign	    
*	    desc1 = pt_desc1
* /*SSIVAN 07120201 add */                desc2 = pt_desc2
*	    .
*            cmt-yn =
*
*            can-find(first cmt_det  where cmt_det.cmt_domain = global_domain
*            and  cmt_indx = req_cmtindx).
* /*SSIVAN 07120201 add */            find first usr_mstr where usr_userid = req_request
* /*SSIVAN 07120201 add */            no-lock no-error.
*            display req_nbr req_line req_part desc1
* /*SSIVAN 07120201 add */            desc2
*               req_site
*               req_qty req_um
* /*SSIVAN 07120201 add */            req__log01
* /*SSIVAN 07120201 add */            ptp_ord_min when available ptp_det 
* /*SSIVAN 07120201 add */            /*   req_pur_cost	  */
* /*SSIVAN 07120201 add */            ptp_ord_mult when available ptp_det
*               req_rel_date
* /*SSIVAN 07120201 add */            pt_status when available pt_mstr  
*               req_need
* /*SSIVAN 07120201 add */            ptp_pur_lead when available ptp_det 
*               req_request
* /*SSIVAN 07120201 add */            usr_name when available usr_mstr
* /*SSIVAN 07120201 add */            pt_group when available pt_mstr
*               req_acct
*               req_sub
*               req_cc
* /*SSIVAN 07120201 add */            ptp_buyer when available ptp_det
*               req_po_site
* /*SSIVAN 07120201 add */            req__dec01
*               req_print
*               cmt-yn with frame a.
*            display req_apr_code req_apr_prnt
*               req_approved req_apr_by req_apr_ent with frame b.
*            /*CALCULATE AND DISPLAY EXTENDED AMOUNT*/
*            puramt = req_pur_cost * req_qty.
*
* /*SSIVAN 07120201 rmk */    /*        display puramt with frame b.    */
*            line = req_line.
*         end. /* IF RECNO <> ? */
*      end. /* EDITING */
*SSIVAN 07120202 rmk end*/
   end.  /* transaction */

/*SSIVAN 07120202 rmk begin*
*   /*GET NEXT REQ NUMBER IF BLANK */
*   do transaction with frame a:
*      reqnbr = "".
*      if input req_nbr <> "" then reqnbr = input req_nbr.
*      else do:
*         find first woc_ctrl  where woc_ctrl.woc_domain = global_domain no-lock
*         no-error.
*         if not available woc_ctrl then do:  create woc_ctrl.
*         woc_ctrl.woc_domain = global_domain. end.
*         {mfnctrl.i "woc_ctrl.woc_domain = global_domain" "woc_ctrl.woc_domain"
*         "req_det.req_domain = global_domain" woc_ctrl woc_nbr req_det req_nbr
*         reqnbr}
*      end.
*      if reqnbr = "" then undo, retry.
* /*SSIVAN 07120201 add */       if can-find(first usrw_wkfl where usrw_wkfl.usrw_domain = global_domain and usrw_key1 = reqnbr
* /*SSIVAN 07120201 add */         and int(usrw_key2) = line and usrw_key3 = "PR") then do:
* /*SSIVAN 07120201 add */       if not can-find(first req_det where req_det.req_domain = global_domain and req_nbr = reqnbr
* /*SSIVAN 07120201 add */         and req_line = line) then do:
* /*SSIVAN 07120201 add */         {mfmsg.i 2142 3}
* /*SSIVAN 07120201 add */         undo mainloop, retry mainloop.
* /*SSIVAN 07120201 add */       end.
* /*SSIVAN 07120201 add */       end.
*      display reqnbr @ req_nbr.
*   end.  /* transaction */
*SSIVAN 07120202 rmk end*/

   do transaction:

      /* ADD/MODIFY/DELETE */

      find req_det  where req_det.req_domain = global_domain and  req_nbr =
/*SSIVAN 07120202 rmk*/    /*  reqnbr exclusive-lock no-error.	*/
/*SSIVAN 07120202 add*/    reqno exclusive-lock no-error.
      if ambiguous req_det then
      find req_det  where req_det.req_domain = global_domain and  req_nbr =
      reqnbr

         and req_line = line exclusive-lock no-error.

      if available req_det then do:
         {pxmsg.i &MSGNUM=10 &ERRORLEVEL=1}
         display req_nbr with frame a.
      end.

      if not available req_det then do:
/*SSIVAN 07120202 add*/      leave.

/*SSIVAN 07120202 rmk begin*
*         undo-all = true.
* /*SSIVAN 07120201 rmk */    /*    {gprun.i ""poprmtb.p""} */
* /*SSIVAN 07120201 add */    {gprun.i ""xxpoprmtb.p""}
*         if undo-all then
*            undo mainloop, retry mainloop.
*
*         find req_det where recid(req_det) = req_recno
*            exclusive-lock no-error.
*SSIVAN 07120202 rmk end*/
      end. /* IF NOT AVAILABLE REQ_DET */

      ststatus  =  stline[2].
      status input ststatus.
      del-yn = no.

      desc1 = caps(getTermLabel("ITEM_NOT_IN_INVENTORY",24)).
/*SSIVAN 07120201 add */      desc2 = " ".
      find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
      req_part no-lock no-error.
      find ptp_det  where ptp_det.ptp_domain = global_domain and  ptp_part =
      req_part and ptp_site = req_site
         no-lock no-error.
      if available pt_mstr then do:
         desc1 = pt_desc1.
/*SSIVAN 07120201 add */         desc2 = pt_desc2.

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

/*SSIVAN 07120201 add*/      find first usr_mstr where usr_userid = req_request
/*SSIVAN 07120201 add*/      no-lock no-error.

      display req_nbr req_line req_part desc1
/*SSIVAN 07120201 add*/      desc2
         req_site
         req_qty req_um
/*SSIVAN 07120201 add*/      req__log01
/*ss-apple*/     req__chr05
/*SSIVAN 07120201 add*/      ptp_ord_min when available ptp_det
/*SSIVAN 07120201 rmk*/      /*   req_pur_cost*/
/*SSIVAN 07120202 add*/      req_pur_cost  when usr-level <> '0'
/*SSIVAN 07120201 add*/       ptp_ord_mult when available ptp_det
         req_rel_date
/*SSIVAN 07120201 add*/      pt_status when available pt_mstr
         req_need
/*SSIVAN 07120201 add*/      ptp_pur_lead when available ptp_det
         req_request
/*SSIVAN 07120201 add*/      usr_name when available usr_mstr
/*SSIVAN 07120201 add*/      pt_group when available pt_mstr
         req_acct
         req_sub
         req_cc
/*SSIVAN 07120201 add*/      ptp_buyer when available ptp_det
         req_po_site
/*SSIVAN 07120201 add*/      req__dec01
         req_print
/*SSIVAN 07120202 add*/      req__dec02
/*SSIVAN 07120202 add*/      when usr-level <> '0'
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
/*SSIVAN 07120202 add*/      when usr-level <> '0'	 
	 with frame b.

      seta-2:
      do with frame a on error undo, retry:
/*SSIVAN 07120201 add*/       prev_qty = req_qty.
/*SSIVAN 07120201 add*/       prev_need = req_need.
/*SSIVAN 07120202 rmk*/ /* /*SSIVAN 07120201 add*/       if not req__log01 or new_req then do:	*/
/*SSIVAN 07120202 add*/       if not req_approved and usr-level <> '0' then do:
         set
/*SSIVAN 07120202 add*/        req__log01
/*ss-apple*/        req__chr05 when req__chr01 = "" and usr-level = "1"
            req_qty  /* req_um */
            req_um when (not available pt_mstr)
            req_pur_cost when (not available pt_mstr)
/*SSIVAN 07120201 rmk */   /*        req_rel_date*/
            req_need
/*SSIVAN 07120201 rmk */   /*            req_request   */
            req_acct when (not available pt_mstr)
            req_sub  when (not available pt_mstr)
            req_cc   when (not available pt_mstr)
            req_po_site
            req_print
            cmt-yn
            go-on ("F5" "CTRL-D").
/*SSIVAN 07120201 add*/       end.
/*SSIVAN 07120201 add*/       else do:
/*SSIVAN 07120201 add*/       find usrw_wkfl where usrw_wkfl.usrw_domain = global_domain and usrw_key1 = req_nbr
/*SSIVAN 07120201 add*/       and int(usrw_key2) = req_line and usrw_key3 = "PR"
/*SSIVAN 07120201 add*/       and usrw_decfld[1] <> prev_qty 
/*SSIVAN 07120201 add*/       no-lock no-error.
/*SSIVAN 07120201 add*/       if not available usrw_wkfl then do:
/*SSIVAN 07120201 add*/         set
/*ss-apple*/        req__chr05 when req__chr01 = "" and usr-level = "1"
/*SSIVAN 07120201 add*/         req_qty
/*SSIVAN 07120201 add*/         req_need
/*SSIVAN 07120202 add*/         req_acct    when not req__log01
/*SSIVAN 07120202 add*/         req_cc      when not req__log01
/*SSIVAN 07120202 add*/		req_sub      when not req__log01
/*SSIVAN 07120202 add*/         req_po_site when not req__log01
/*SSIVAN 07120202 add*/         req_print   when not req__log01
/*SSIVAN 07120201 add*/         cmt-yn
/*SSIVAN 07120201 add*/         go-on ("F5" "CTRL-D").
/*SSIVAN 07120201 add*/       end.
/*SSIVAN 07120201 add*/       else do:
/*SSIVAN 07120201 rmk*/         /* message "WARNING: MODIFICATION NOT ALLOWED, REQUISITION ATTACHED TO PURCHASE ORDER.".  */
/*SSIVAN 07120201 add*/		{pxmsg.i &MSGNUM=9026 &ERRORLEVEL=2}
/*SSIVAN 07120201 add*/         set 
/*SSIVAN 07120201 add*/         cmt-yn
/*SSIVAN 07120201 add*/         go-on ("F5" "CTRL-D").
/*SSIVAN 07120201 add*/       end.
/*SSIVAN 07120201 add*/       end.
/*SSIVAN 07120201 add*/       if new_req then req__log01 = no.
         /* DELETE */
         if lastkey = keycode("F5")
            or lastkey = keycode("CTRL-D")
         then do:
            del-yn = yes.
            {mfmsg01.i 11 1 del-yn}
            if del-yn = no then undo seta-2, retry seta-2.
         end.
         if del-yn or req_part = "" then do:

/*SSIVAN 07120201 add*/            /* CHECK usrw_wkfl BEFORE DELETE*/
/*SSIVAN 07120201 add*/            find usrw_wkfl where usrw_wkfl.usrw_domain = global_domain and usrw_key1 = req_nbr
/*SSIVAN 07120201 add*/            and int(usrw_key2) = req_line and usrw_key3 = "PR"
/*SSIVAN 07120201 add*/            exclusive-lock no-error.
/*SSIVAN 07120201 add*/            if available usrw_wkfl then do:

/*SSIVAN 07120201 add*/              if usrw_decfld[1] = req_qty then do:
/*SSIVAN 07120201 add*/                 continue = yes.
/*SSIVAN 07120201 add*/                 {mfmsg01.i 8266 2 continue}
/*SSIVAN 07120201 add*/                 if continue = no then undo seta-2, retry seta-2.
/*SSIVAN 07120201 add*/              end.
/*SSIVAN 07120201 add*/              else do:
/*SSIVAN 07120201 add*/                 usrw_decfld[1] = usrw_decfld[1] - req_qty.
/*SSIVAN 07120201 add*/              end.
/*SSIVAN 07120201 add*/              usrw_key6 = "V".
/*SSIVAN 07120201 add*/              usrw_charfld[1] = global_userid.
/*SSIVAN 07120201 add*/              usrw_datefld[3] = today.
/*SSIVAN 07120201 add*/            end.

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

/*SSIVAN 07120202 add*/      if usr-level = '1'
/*SSIVAN 07120202 add*/       or usr-level = '0'
/*SSIVAN 07120202 add*/      then do:
/*SSIVAN 07120201 add*/         if not new_req and req__log01 then do:
/*SSIVAN 07120201 add*/          if prev_qty < req_qty then do:
/*SSIVAN 07120201 add*/            bell.
/*SSIVAN 07120201 rmk*/            /* message "ERROR: MODIFIED QTY GREATER THAN APPROVED QTY.".	*/
/*SSIVAN 07120201 add*/		    {pxmsg.i &MSGNUM=9027 &ERRORLELVE=3}
/*SSIVAN 07120201 add*/            next-prompt req_qty with frame a.
/*SSIVAN 07120201 add*/            undo seta-2, retry.
/*SSIVAN 07120201 add*/          end.
/*SSIVAN 07120201 add*/          if (prev_qty > req_qty or prev_need <> req_need)
/*SSIVAN 07120201 add*/          then do:
/*SSIVAN 07120201 add*/            req_user1 = global_userid.
/*SSIVAN 07120201 add*/            req__dte01 = today.
/*SSIVAN 07120201 add*/          end.
/*SSIVAN 07120201 add*/         end.
/*SSIVAN 07120202 add*/      end.

/*SSIVAN 07120201 add*/         /* CHECK usrw_wkfl */
/*SSIVAN 07120201 add*/         find usrw_wkfl where usrw_wkfl.usrw_domain = global_domain and usrw_key1 = req_nbr
/*SSIVAN 07120201 add*/         and int(usrw_key2) = req_line and usrw_key3 = "PR"
/*SSIVAN 07120201 add*/         exclusive-lock no-error.
/*SSIVAN 07120201 add*/         if available usrw_wkfl then do:
/*SSIVAN 07120201 add*/            if input req_qty > usrw_decfld[1] then do:
/*SSIVAN 07120201 add*/              bell.
/*SSIVAN 07120201 rmk*/              /* message "ERROR: MODIFIED QTY GREATER THAN APPROVED QTY.". */
/*SSIVAN 07120201 add*/		    {pxmsg.i &MSGNUM=9027 &ERRORLELVE=3}
/*SSIVAN 07120201 add*/              next-prompt req_qty with frame a.
/*SSIVAN 07120201 add*/              undo seta-2, retry.
/*SSIVAN 07120201 add*/            end.
/*SSIVAN 07120201 add*/            else if prev_qty = usrw_decfld[1] 
/*SSIVAN 07120201 add*/                 and (input req_qty < usrw_decfld[1] 
/*SSIVAN 07120201 add*/                 or input req_need <> usrw_datefld[2])
/*SSIVAN 07120201 add*/            then do:
/*SSIVAN 07120201 add*/              usrw_decfld[1] = req_qty.
/*SSIVAN 07120201 add*/              usrw_datefld[2] = req_need.
/*SSIVAN 07120201 add*/              usrw_charfld[1] = global_userid.
/*SSIVAN 07120201 add*/              usrw_datefld[3] = today.
/*SSIVAN 07120201 add*/            end.
/*SSIVAN 07120201 add*/         end.

/*SSIVAN 07120201 add*/         if available ptp_det then do:
/*SSIVAN 07120201 add*/             if req_qty < ptp_ord_min then do:
/*SSIVAN 07120201 add*/                bell.
/*SSIVAN 07120201 rmk*/             /*   message "WARNING: ORDER QTY IS LESS THAN MIN. ORDER.".	   */
/*SSIVAN 07120201 add*/		    {pxmsg.i &MSGNUM=9028 &ERRORLELVE=2}
/*SSIVAN 07120201 add*/             end.

/*SSIVAN 07120201 add*/             if (ptp_ord_mult <> 0 and ((req_qty / ptp_ord_mult) 
/*SSIVAN 07120201 add*/                     <> integer(req_qty / ptp_ord_mult))) then do:
/*SSIVAN 07120201 add*/                bell.
/*SSIVAN 07120201 rmk*/             /*   message "WARNING: INCORRECT ORDER QUANTITY.".	*/
/*SSIVAN 07120201 add*/		    {pxmsg.i &MSGNUM=9029 &ERRORLELVE=2}
/*SSIVAN 07120201 add*/             end.

/*SSIVAN 07120201 add*/             if (ptp_pur_lead > req_need - req_rel_date) then do:
/*SSIVAN 07120201 add*/                bell.
/*SSIVAN 07120201 rmk*/              /*  message "WARNING: NEED DATE - RELEASE DATE < PUR LT.".	 */
/*SSIVAN 07120201 add*/		     {pxmsg.i &MSGNUM=9030 &ERRORLELVE=2}
/*SSIVAN 07120201 add*/             end. 
/*SSIVAN 07120201 add*/         end.  /* available ptp_det */


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
/*SSIVAN 07120201 add*/         if new_req then req_rel_date = today.
         display req_rel_date req_need.

         /* Changed pre-processor to Term */
         {mfmrw.i "req_det" req_part req_nbr string(req_line) """"
            req_rel_date req_need
            "req_qty" "SUPPLYF" PURCHASE_REQUISITION req_site}

         puramt = req_pur_cost * req_qty.

/*SSIVAN 07120201 add*/ /* CALCULATE EXCESS QTY(req__dec01) and EXCESS AMOUNT(req__dec02)*/
/*SSIVAN 07120201 add*/         for each in_mstr where in_mstr.in_domain = global_domain and in_site = req_site
/*SSIVAN 07120201 add*/                            and in_part = req_part 
/*SSIVAN 07120201 add*/         no-lock:
/*SSIVAN 07120201 add*/           req__dec01 = in_qty_oh. 
/*SSIVAN 07120201 add*/           for each mrp_det where mrp_det.mrp_domain = global_domain and mrp_site = req_site 
/*SSIVAN 07120201 add*/                              and mrp_part = req_part 
/*SSIVAN 07120201 add*/           no-lock:
/*SSIVAN 07120201 add*/              if index(mrp_type,"demand") > 0 
/*SSIVAN 07120201 add*/                 then req__dec01 = req__dec01 - mrp_qty. 
/*SSIVAN 07120201 add*/              else 
/*SSIVAN 07120201 add*/              if index(mrp_type,"supply") > 0
/*SSIVAN 07120201 add*/                       and mrp_type <> "supplyp"
/*SSIVAN 07120201 add*/                 then req__dec01 = req__dec01 + mrp_qty.
/*SSIVAN 07120201 add*/           end. 
/*SSIVAN 07120201 add*/           req__dec02 = 0. 
/*SSIVAN 07120201 add*/           find last prh_hist where prh_hist.prh_domain = global_domain and prh_part = req_part 
/*SSIVAN 07120201 add*/                                and prh_pur_cost <> 0 
/*SSIVAN 07120201 add*/           use-index prh_part no-lock no-error. 
/*SSIVAN 07120201 add*/           if available prh_hist
/*SSIVAN 07120201 add*/           then
/*SSIVAN 07120201 add*/            req__dec02 = prh_pur_cost * req__dec01.
/*SSIVAN 07120201 add*/           else do:
/*SSIVAN 07120201 add*/             find last pod_det where pod_det.pod_domain = global_domain and pod_part = req_part
/*SSIVAN 07120201 add*/                                 and pod_pur_cost <> 0
/*SSIVAN 07120201 add*/             use-index pod_partdue no-lock no-error.
/*SSIVAN 07120201 add*/             if available pod_det then do:
/*SSIVAN 07120201 add*/               find first po_mstr where po_mstr.po_domain = global_domain and po_nbr = pod_nbr
/*SSIVAN 07120201 add*/               no-lock no-error.
/*SSIVAN 07120201 add*/               if available po_mstr then
/*SSIVAN 07120201 add*/                req__dec02 = pod_pur_cost * po_ent_ex * req__dec01.
/*SSIVAN 07120201 add*/             end.
/*SSIVAN 07120201 add*/             else do:
/*SSIVAN 07120201 add*/               find first sct_det where sct_det.sct_domain = global_domain and sct_part = req_part
/*SSIVAN 07120201 add*/                    and sct_sim  = "Standard" and sct_site = req_site
/*SSIVAN 07120201 add*/               no-lock no-error. 
/*SSIVAN 07120201 add*/               if available sct_det then
/*SSIVAN 07120201 add*/                 req__dec02 = sct_cst_tot * req__dec01.
/*SSIVAN 07120201 add*/             end.
/*SSIVAN 07120201 add*/           end.
/*SSIVAN 07120202 rmk*/ /* /*SSIVAN 07120201 add*/           display req__dec01 /**req__dec02**/ with frame a.	  */
/*SSIVAN 07120202 add*/           display req__dec01 req__dec02  when usr-level <> '0'   with frame a.
/*SSIVAN 07120201 add*/         end.

      end. /* seta-2 */

      if new_req then do:
         /*DEFAULT THE APPROVAL CODE*/ /*do this w/in this transaction*/
         {gppacal.i}                   /*so be sure one gets set*/
      end.
   end.  /*transaction*/

   /* SET APPROVAL FIELDS */
   req_recno = recid(req_det).
/*SSIVAN 07120202 rmk*/ /*/*SSIVAN 07120201 add*/   usr-level = "0".*/
/*SSIVAN 07120201 rmk*/ /*  {gprun.i ""poprmta.p""}   */
/*SSIVAN 07120201 add*/   {gprun.i ""xxpoprmta.p""}

   clear frame a.
   clear frame b.

end. /* repeat */
status input.
