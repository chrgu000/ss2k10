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
/* By: Neil Gao Date: 07/11/22 ECO: * ss 20071122 * */
/*By: Neil Gao 08/04/16 ECO: *SS 20080416* */
/*By: Neil Gao 08/06/14 ECO: *SS 20080614* */
/*By: Neil Gao 08/11/23 ECO: *SS 20081123* */

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

&SCOPED-DEFINE poprmt_p_2 "Comments"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define new shared variable desc1 like pt_desc1.
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

/* DISPLAY SELECTION FORM */
form
   req_nbr        colon 25
/*SS 20080614 - B*/
/*
   req_line       no-label at 27 no-attr-space
*/
/*SS 20080614 - E*/
   req_part       colon 25
   desc1          no-label no-attr-space
   req_site       colon 25
/*SS 20080614 - B*/
		req_line
/*SS 20080614 - E*/
   req_qty        colon 25
   req_um         colon 25
   req_pur_cost   colon 25
   req_rel_date   colon 25
   req_need       colon 25
/* ss 20071122 - b */
/*
   req_request    colon 25
*/
   req_user1      colon 25 label "π©”¶…Ã"  req_so_job no-label
/*SS 20080416*/   req_user2      no-label
/* ss 20071122 - e */
   req_acct       colon 25
   req_sub        no-label no-attr-space
   req_cc         no-label no-attr-space
   req_po_site    colon 25
   req_print      colon 25  cmt-yn
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
/* ss 20071122 - b */
/*
               req_request
*/
							 req_user1
							 req_so_job
/* ss 20071122 - e */
/*SS 20080416*/ req_user2
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
   end.  /* transaction */

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

   do transaction:

      /* ADD/MODIFY/DELETE */

      find req_det  where req_det.req_domain = global_domain and  req_nbr =
      reqnbr exclusive-lock no-error.
      if ambiguous req_det then
      find req_det  where req_det.req_domain = global_domain and  req_nbr =
      reqnbr

         and req_line = line exclusive-lock no-error.

      if available req_det then do:
         {pxmsg.i &MSGNUM=10 &ERRORLEVEL=1}
         display req_nbr with frame a.
      end.

      if not available req_det then do:

         undo-all = true.
         /* ss 20080123 */
         {gprun.i ""xxpoprmtb.p""}
         if undo-all then
            undo mainloop, retry mainloop.

         find req_det where recid(req_det) = req_recno
            exclusive-lock no-error.

      end. /* IF NOT AVAILABLE REQ_DET */

      ststatus  =  stline[2].
      status input ststatus.
      del-yn = no.

      desc1 = caps(getTermLabel("ITEM_NOT_IN_INVENTORY",24)).
      find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
      req_part no-lock no-error.
      find ptp_det  where ptp_det.ptp_domain = global_domain and  ptp_part =
      req_part and ptp_site = req_site
         no-lock no-error.
      if available pt_mstr then do:
         desc1 = pt_desc1.

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

      display req_nbr req_line req_part desc1
         req_site
         req_qty req_um
         req_pur_cost
         req_rel_date
         req_need
/* ss 20071122 - b */
/*
         req_request
*/
				 req_user1
				 req_so_job
/* ss 20071122 - e */
/*SS 20080416*/ req_user2
         req_acct
         req_sub
         req_cc
         req_po_site
         req_print
         cmt-yn with frame a.

      {gprun.i ""gpsiver.p""
         "(input req_site, input ?, output return_int)"}
      if return_int = 0 then do:
         {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}        /* USER DOES NOT HAVE */
         /* ACCESS TO THIS SITE*/
         undo mainloop, retry.
      end.

      display req_apr_code req_apr_prnt
         req_approved req_apr_by req_apr_ent puramt with frame b.

      seta-2:
      do with frame a on error undo, retry:
         set
            req_qty  /* req_um */
            req_um when (not available pt_mstr)
            req_pur_cost when (not available pt_mstr)
            req_rel_date
            req_need
/* ss 20071122 - b */
/*
            req_request
*/
            req_user1
            req_so_job
/* ss 20071122 - e */
/*SS 20080416*/ req_user2
            req_acct when (not available pt_mstr)
            req_sub  when (not available pt_mstr)
            req_cc   when (not available pt_mstr)
            req_po_site
            req_print
            cmt-yn
            go-on ("F5" "CTRL-D").

         /* DELETE */
         if lastkey = keycode("F5")
            or lastkey = keycode("CTRL-D")
         then do:
            del-yn = yes.
            {mfmsg01.i 11 1 del-yn}
            if del-yn = no then undo seta-2, retry seta-2.
         end.
         if del-yn or req_part = "" then do:

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
         display req_rel_date req_need.

         /* Changed pre-processor to Term */
         {mfmrw.i "req_det" req_part req_nbr string(req_line) """"
            req_rel_date req_need
            "req_qty" "SUPPLYF" PURCHASE_REQUISITION req_site}

         puramt = req_pur_cost * req_qty.

      end. /* seta-2 */

      if new_req then do:
         /*DEFAULT THE APPROVAL CODE*/ /*do this w/in this transaction*/
         {gppacal.i}                   /*so be sure one gets set*/
      end.
/*SS 20081123 - B*/
			global_addr = req_nbr.
/*SS 20081123 - E*/
   end.  /*transaction*/

   /* SET APPROVAL FIELDS */
   req_recno = recid(req_det).
   {gprun.i ""poprmta.p""}

   clear frame a.
   clear frame b.

end. /* repeat */
status input.
