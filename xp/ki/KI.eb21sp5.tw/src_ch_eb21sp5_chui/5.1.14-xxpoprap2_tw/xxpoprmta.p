/* xxpoprmta.p - PURCHASE REQUISITION MAINTENANCE -- subroutine         */
/* poprmta.p - PURCHASE REQUISITION MAINTENANCE -- subroutine           */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 7.0     LAST MODIFIED: 08/26/91    BY: MLV *F006**/
/* REVISION: 6.0     LAST MODIFIED: 10/10/91    BY: dgh *D892**/
/* REVISION: 7.0     LAST MODIFIED: 10/17/91    BY: emb *F024**/
/* REVISION: 6.0     LAST MODIFIED: 10/30/91    BY: emb *D906**/
/* REVISION: 7.0     LAST MODIFIED: 11/19/91    BY: pma *F003**/
/* REVISION: 7.0     LAST MODIFIED: 12/08/91    BY: RAM *F033**/
/* REVISION: 7.0     LAST MODIFIED: 03/24/92    BY: MLV *F279**/
/* REVISION: 7.3     LAST MODIFIED: 04/19/93    BY: afs *G973**/
/* REVISION: 7.3     LAST MODIFIED: 06/25/93    BY: afs *GC77**/
/* REVISION: 7.3     LAST MODIFIED: 03/01/96    BY: rxm *G1PJ**/

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00 BY: *N0KQ* myb              */
/* $Revision: 1.7.1.4 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00J* */
/* SSIVAN 07120201 BY:Ivan Yang Date:12/02/07  */
/*                   1. Remove Approval Edit for User, 1st Approval   */
/*                      and 2nd Approved (req_approved = yes)         */
/*                   2. Save Last Edit(req_user1,req__dte01) 4 1st Apr*/
/*                   3. Validate req__log01 = yes for 2nd Approval    */
/*                   4. Default Approved By to User ID                */
/*                   5. After 2nd Approval, not allow to disapproved  */
/*                   6. Delete 2nd Approved PR, usrw_key6 = "V"       */
/*                   7. Hide Extended Amount(For User Only)           */
/*-Revision end---------------------------------------------------------------*/

     {mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE poprmta_p_1 "Extended Amount"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

     define shared variable desc1 like pt_desc1.
     define variable i as integer.
     define shared variable cmt-yn like mfc_logical.
     define new shared variable cmtindx like cmt_indx.
/*F006*/ define shared variable puramt like req_pur_cost
/*F006*/    label {&poprmta_p_1}.
/*F006*/ define variable approve_ok like mfc_logical.
/*F006*/ define variable j as integer.
/*F006*/ define variable continue like mfc_logical.
     define shared variable req_recno as recid.
/*G973*  define shared frame a. */
     define shared frame b.
/*G1PJ*/ define variable old_apr_code like req_apr_code no-undo.

/*SSIVAN 07120201 add*/define shared variable usr-level as character.
/*SSIVAN 07120201 add*/define shared variable new_req like mfc_logical.
/*SSIVAN 07120201 add*/define variable msg-temp like msg_desc.

     /* DISPLAY SELECTION FORM */
/*G973*  form
 *       req_nbr        colon 25
 *       req_line       no-label at 27 no-attr-space
 *       req_part       colon 25
 *       desc1          no-label no-attr-space
 *       req_site       colon 25
 *       skip(1)
 *       req_qty        colon 25
 *       req_um         colon 25
/*F006*/ req_pur_cost   colon 25
 *       req_rel_date   colon 25
 *       req_need       colon 25
 *       req_request    colon 25
 *       req_acct       colon 25
 *       req_cc         no-label no-attr-space
/*F033*/ req_po_site    colon 25
 *       req_print      colon 25
 *       cmt-yn         colon 25
 *       with frame a side-labels width 80 attr-space.
 **G973*/

/*G1PJ
 * /*F006*/ form
 * /*F006*/    req_apr_code   colon 18
 * /*F006*/    puramt         colon 55
 * /*F006*/    req_approved   colon 18
 * /*F006*/    req_apr_prnt   colon 55
 * /*F006*/    req_apr_by     colon 18
 * /*F006*/    req_apr_ent    colon 55
 * /*F006*/ with frame b side-labels width 80 attr-space title color
 * /*F006*/ normal "Approvals".
 *G1PJ*/

/*G1PJ*/    {poprfrm.i}               /* shared frame definition */

           ststatus  =  stline[3].
           status input ststatus.

           find req_det exclusive-lock where recid(req_det) = req_recno.
           find pt_mstr no-lock  where pt_mstr.pt_domain = global_domain and
           pt_part = req_part no-error.

/*G1PJ*/       old_apr_code = req_apr_code.

/*SSIVAN 07120201 add*/      if usr-level = "0" then do:
/*SSIVAN 07120201 add*/         display req_apr_code req_apr_prnt
/*SSIVAN 07120201 add*/                 req_approved req_apr_by req_apr_ent
/*SSIVAN 07120201 add*/         with frame b.
/*SSIVAN 07120201 add*/         if new_req then req_approved = no.
/*SSIVAN 07120201 add*/      end.

/*SSIVAN 07120201 add*/      else if usr-level = "1" and req__log01 then do:
/*SSIVAN 07120201 add*/         display req_apr_code req_apr_prnt puramt
/*SSIVAN 07120201 add*/              req_approved req_apr_by req_apr_ent
/*SSIVAN 07120201 add*/         with frame b.
/*SSIVAN 07120201 add*/         req_user1 = global_userid.
/*SSIVAN 07120201 add*/         req__dte01 = today.
/*SSIVAN 07120201 add*/         if new_req then req_approved = no.
/*SSIVAN 07120201 add*/      end.

/*SSIVAN 07120201 add*/      else if usr-level = "2" and req_approved and not new_req then do:
/*SSIVAN 07120201 add*/         display req_apr_code req_apr_prnt puramt
/*SSIVAN 07120201 add*/              req_approved req_apr_by req_apr_ent
/*SSIVAN 07120201 add*/         with frame b.
/*SSIVAN 07120201 add*/      end.

/*SSIVAN 07120201 add*/      else if usr-level = "2" and (not req_approved or new_req) 
/*SSIVAN 07120201 add*/      then do:
/*SSIVAN 07120201 add*/         find first pac_mstr where pac_mstr.pac_domain = global_domain and pac_site = req_site
/*SSIVAN 07120201 add*/              and (   pac_apr_by[1] = global_userid
/*SSIVAN 07120201 add*/                   or pac_apr_by[2] = global_userid
/*SSIVAN 07120201 add*/                   or pac_apr_by[3] = global_userid
/*SSIVAN 07120201 add*/                   or pac_apr_by[4] = global_userid)
/*SSIVAN 07120201 add*/              and (pac_pur_acct = req_acct or pac_pur_acct = "")
/*SSIVAN 07120201 add*/              and (pac_pur_sub = req_sub or pac_pur_sub = "")
/*SSIVAN 07120201 add*/		     and (pac_pur_cc = req_cc or pac_pur_cc = "")
/*SSIVAN 07120201 add*/              and (pac_req_by = req_request or pac_req_by = "")
/*SSIVAN 07120201 add*/         no-lock no-error.
/*SSIVAN 07120201 add*/         if available pac_mstr then do:
/*SSIVAN 07120201 add*/            req_apr_code = pac_code.
/*SSIVAN 07120201 add*/         end.

/*SSIVAN 07120201 add*/         req_apr_by = global_userid.

/*F006*/       /* SET APPROVAL FIELDS */
/*F006*/       setb: do with frame b on error undo, retry:
/*SSIVAN 07120201 add*/        if new_req then req_approved = no.

/*G973*           /* Deleted following section */
 * /*F006*/       /*CALCULATE AND DISPLAY EXTENDED AMOUNT*/
 * /*F006*/       if not available pt_mstr then
 * /*F006*/          puramt = req_pur_cost * req_qty.
 * /*F006*/       else do:
 * /*F003*/          if req_po_site <> ""
 * /*F003*/       or (req_po_site = ""
 * /*F003*/       and can-find(si_mstr where si_site = ""))
 * /*F003*/       then do:
 * /*F003*/          {gpsct05.i
 *                      &part=pt_part
 *                      &site=req_po_site
 *                      &cost=sct_mtl_tl}
 * /*F003*/          end.
 * /*F003*/          else if can-find(ptp_det where ptp_part = req_part
 * /*F003*/          and ptp_site = req_site) then do:
 * /*F003*/             find ptp_det where ptp_part = req_part
 * /*F003*/             and ptp_site = req_site no-lock no-error.
 * /*F003*/             {gpsct05.i
 *                         &part=pt_part
 *                         &site=ptp_po_site
 *                         &cost=sct_mtl_tl}
 * /*F003*/             end.
 * /*F003*/             else do:
 * /*F003*/                {gpsct05.i
 *                         &part=pt_part
 *                         &site=pt_po_site
 *                         &cost=sct_mtl_tl}
 * /*F003*/          end.
 * /*F003            puramt = pt_mtl_stdtl * req_qty. */
 * /*F003*/          puramt = glxcst * req_qty.
 * /*F006*/          if pt_um <> req_um then do:
 * /*F006*/             find um_mstr where um_um = pt_um and
 * /*F006*/             um_alt_um = req_um
 * /*F006*/             and um_part = req_part no-lock no-error.
 * /*F006*/             if not available um_mstr then
 * /*F006*/             find um_mstr where um_um = pt_um
 * /*F006*/             and um_alt_um = req_um
 * /*F006*/             and um_part = "" no-lock no-error.
 * /*F006*/             if available um_mstr then
 * /*F006*/                puramt = puramt * um_conv.
 * /*F006*/          end.
 * /*F006*/       end.
 **G973*/         /* End of deleted section */

/*F006*/          display req_apr_code req_apr_prnt puramt
/*F006*/          req_approved req_apr_by req_apr_ent.

/*F006*/          set req_apr_code req_approved req_apr_by req_apr_prnt.

/*SSIVAN 07120201 rmk*/ /*/*G1PJ*/          if old_apr_code <> "" and req_apr_code = "" then do:  */
/*SSIVAN 07120201 add*/         if (old_apr_code <> "" and req_apr_code = "")
/*SSIVAN 07120201 add*/         or req_apr_code = "" then do:
/*G1PJ*/             {mfmsg.i 40 3} /* BLANK NOT ALLOWED */
/*G1PJ*/             next-prompt req_apr_code with frame b.
/*G1PJ*/             undo setb, retry.
/*G1PJ*/          end.

/*F006*/          if req_apr_code <> "" then do:
/*F006*/             find pac_mstr  where pac_mstr.pac_domain = global_domain
and  pac_code = req_apr_code no-lock
/*F006*/             no-error.
/*F006*/             if not available pac_mstr then do:
/*F006*/                {mfmsg.i 191 3}
/*F006*/                /*ERROR: APPROVAL CODE DOES NOT EXIST*/
/*F006*/                next-prompt req_apr_code with frame b.
/*F006*/                undo setb, retry.
/*F006*/             end.

/*F006*/             /*IF APPROVED = YES, CHECK THAT NECESSARY LEVEL APPROVAL*/
/*F006*/             /*IS REACHED*/  /*WARNING*/
/*F006*/             if req_approved = yes then do:
/*F006*/                approve_ok = no.

/*F279***               /* Deleted following section */
 * /*F006*/                if pac_amt[1] > puramt then approve_ok = yes.
 * /*F006*/                /*no approval required for this amount*/
 * /*F006*/                if approve_ok = no then do:
 * /*F006*/                   /* find first pac_amt that is <= puramt and  */
 * /*F006*/                   /* where this is the highest approval or the */
 * /*F006*/                   /* approval just above this is greater.  If  */
 * /*F006*/                   /* the amt[i + 1] = 0, it is assumed amt[i]  */
 * /*F006*/                   /* is the last approval on the approval code */
 * /*F006*/                   do i = 1 to 4:
 * /*F006*/                      if (pac_amt[i] <= puramt) and
 * /*F006*/                      (  i = 4  or
 * /*F006*/                      (pac_amt[i + 1] > puramt or pac_amt[i + 1] = 0)
 * /*F006*/                      )
 * /*F006*/                      then leave.
 * /*F006*/                   end.
 *F279*/                   /* End of deleted section*/

            /*F279 FIND APPROVAL LEVEL REQUIRED (i)*/
            if req_apr_code <> "" then do:
               do i = 1 to 4:
                  if pac_amt[i] >= puramt then leave.
               end.
            end.
/*F006*/                /*See if this level or higher matches req_apr_by*/
/*F006*/                do j = i to 4:
/*F006*/                   if pac_apr_by[j] = req_apr_by
/*F006*/                   and pac_apr_by[j] <> "" then do:
/*F006*/                      approve_ok = yes.
/*F006*/                      leave.
/*F006*/                   end.
/*F006*/                end.
/*F006*/                if approve_ok = no then do:
/*GC77*/                   req_approved = no.
/*F006*/                   continue = no.
/*F006*/                   {mfmsg01.i 192 2 continue }
/*F006*/                   /*WARNING:  APPROVAL LEVEL REQUIRED FOR THIS*/
/*F006*/                   /*AMOUNT HAS NOT BEEN REACHED, Continue?*/
/*F006*/                   if continue = no then undo setb, retry.
/*F006*/                end.
/*SSIVAN 07120201 add*/               if not req__log01 then do:
/*SSIVAN 07120201 add*/                  req_approved = no.
/*SSIVAN 07120201 add*/                  continue = no.
/*SSIVAN 07120201 rmk*/                 /* msg-temp = "REQUISITION HAS NOT BEEN APPROVED. CONTINUE?". */
/*SSIVAN 07120201 rmk*/                 /* {xxmfmsg01.i msg-temp 2 continue}	*/
/*SSIVAN 07120201 add*/			{pxmsg.i &MSGNUM=9031 &ERRORLEVEL=2 &CONFIRM=continue}
/*SSIVAN 07120201 add*/                  if continue = no then undo setb, retry.
/*SSIVAN 07120201 add*/               end.
/*F006*/             end. /*req_approved = yes*/
/*F006*/          end. /*req_apr_code <> ""*/
/*F006*/       end. /*setb*/
/*F006*/       /*SET APPROVED ENTERED BY FIELD TO USER ID*/
/*F006*/       if (req_approved entered and req_approved = yes)
/*F006*/       or (req_apr_by entered and req_apr_by <> "")
/*F006*/       then req_apr_ent = global_userid.

/*SSIVAN 07120201 add*/      if req_approved then do:
/*SSIVAN 07120201 add*/         create usrw_wkfl. usrw_wkfl.usrw_domain = global_domain.
/*SSIVAN 07120201 add*/         assign usrw_key1 = req_nbr
/*SSIVAN 07120201 add*/                usrw_key2 = string(req_line)
/*SSIVAN 07120201 add*/                usrw_key3 = "PR"
/*SSIVAN 07120201 add*/                usrw_key4 = req_part
/*SSIVAN 07120201 add*/                usrw_key5 = req_site 
/*SSIVAN 07120201 add*/                usrw_charfld[1] = req_user1
/*SSIVAN 07120201 add*/                usrw_datefld[3] = req__dte01
/*SSIVAN 07120201 add*/                usrw_decfld[1] = req_qty
/*SSIVAN 07120201 add*/                usrw_decfld[2] = req_pur_cost
/*SSIVAN 07120201 add*/                usrw_decfld[3] = req__dec01
/*SSIVAN 07120201 add*/                usrw_decfld[4] = req__dec02
/*SSIVAN 07120201 add*/                usrw_datefld[1] = req_rel_date
/*SSIVAN 07120201 add*/                usrw_datefld[2] = req_need
/*SSIVAN 07120201 add*/                usrw_charfld[2] = req_um
/*SSIVAN 07120201 add*/                usrw_charfld[3] = req_request
/*SSIVAN 07120201 add*/                usrw_charfld[4] = req_acct
/*SSIVAN 07120201 add*/                usrw_charfld[5] = req_cc
/*SSIVAN 07120201 add*/                usrw_charfld[6] = req_po_site
/*SSIVAN 07120201 add*/                usrw_charfld[7] = req_apr_code
/*SSIVAN 07120201 add*/                usrw_charfld[8] = req_apr_by
/*SSIVAN 07120201 add*/                usrw_charfld[9] = req_apr_ent
/*SSIVAN 07120201 add*/		       usrw_charfld[11]	= req_sub
/*SSIVAN 07120201 add*/                usrw_datefld[4] = today.
/*SSIVAN 07120201 add*/      end.  /* create usrw_wkfl */

/*SSIVAN 07120201 add*/      end.  /* usr-level = 2 */

           /* ADD COMMENTS IF DESIRED */
           if cmt-yn then do:
/*G973**          hide frame a no-pause. **/
/*G973**          hide frame b no-pause. **/
          cmtindx = req_cmtindx.
          global_ref = req_part.
          {gprun.i ""gpcmmt01.p"" "(input ""req_det"")"}
          req_cmtindx = cmtindx.
/*G973**          view frame a. **/
/*G973**          view frame b. **/
           end.

           status input.
