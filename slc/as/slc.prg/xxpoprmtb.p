/* poprmtb.p - PURCHASE REQUISITION MAINTENANCE                               */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.5.1.7 $                                                       */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 8.5     LAST MODIFIED: 05/27/96    BY: *J0NX* M. Deleeuw         */
/* REVISION: 8.5     LAST MODIFIED: 03/07/97    BY: *J1KJ* Aruna Patil        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Brian Compton      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.5.1.4  BY: Jean Miller DATE: 05/14/02 ECO: *P05V* */
/* Revision: 1.5.1.6  BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00J* */
/* $Revision: 1.5.1.7 $ BY: Rajinder Kamra  DATE: 06/23/03  ECO *Q003*  */
/*By: Neil Gao 08/04/16 ECO: *SS 20080416* */
/*By: Neil Gao 08/06/14 ECO: *SS 20080614* */

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */


define shared variable cmt-yn     like mfc_logical initial no label "Comments".
define shared variable desc1      like pt_desc1.
define shared variable req_recno  as recid.
define shared variable undo-all   like mfc_logical.
define shared variable new_req    like mfc_logical.

define variable ptstatus   like pt_status.

define shared frame a.

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
/*SS 20080416*/ req_user2      no-label   
/* ss 20071122 - e */
   req_acct       colon 25
   req_sub        no-label no-attr-space
   req_cc         no-label no-attr-space
   req_po_site    colon 25
   req_print      colon 25  cmt-yn
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock no-error.

{pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
create req_det. req_det.req_domain = global_domain.
assign
   req_nbr
   req_line = 0
   req_rel_date = today
   req_acct = gl_pur_acct
   req_sub = gl_pur_sub
   req_cc = gl_pur_cc
   req_need = today
   req_recno = recid(req_det)
   new_req = true.

display
   req_nbr
   req_part
   req_site
with frame a.

mainproc:
do on endkey undo, leave:

   seta-1:
   do with frame a on error undo, retry:

      set
         req_part req_site
/*SS 20080614 - B*/
					req_line
/*SS 20080614 - E*/
      editing:

         /* SET GLOBAL PART VARIABLE */
         assign
            global_part = input req_part
            global_site = input req_site.

         if frame-field = "req_part" then do:
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp.i
               pt_mstr
               req_part
                " pt_mstr.pt_domain = global_domain and pt_part "
               req_part
               pt_part
               pt_part}
            if recno <> ? then do:
               assign
                  req_part = pt_part
                  desc1 = pt_desc1.
               if new req_det then
                  req_site = pt_site.
               display req_part desc1 req_site with frame a.
            end.
         end. /* IF FRAME-FIELD = "REQ_PART" */

         else if frame-field = "req_site" then do:
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp.i
               si_mstr
               req_site
                " si_mstr.si_domain = global_domain and si_site "
               req_site
               si_site
               si_site}
            if recno <> ? then do:
               req_site = si_site.
               display req_site with frame a.
            end.
         end. /* IF FRAME-FIELD = "REQ_SITE" */

         else do:
            status input stline[3].
            readkey.
            apply lastkey.
         end.

      end. /* EDITING */

      if req_part = "" then do:
         {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}
         /* BLANK NOT ALLOWED */
         next-prompt req_part with frame a.
         undo seta-1, retry.
      end.

      /* VALIDATE SITE */
      if req_site <> "" then do:

         find si_mstr  where si_mstr.si_domain = global_domain and  si_site =
         req_site no-lock no-error.

         if not available si_mstr
         then do:
            {pxmsg.i &MSGNUM=708 &ERRORLEVEL=3}
            /* SITE DOES NOT EXIST */
            next-prompt req_site with frame a.
            undo seta-1, retry.
         end.

         /* MAKE SURE REQ IS FOR THIS DATABASE */
         if si_db <> global_db then do:
            /* SITE IS NOT ASSIGNED TO THIS DOMAIN */
            {pxmsg.i &MSGNUM=6251 &ERRORLEVEL=3}
            next-prompt req_site with frame a.
            undo seta-1, retry.
         end.

         {gprun.i ""gpsiver.p""
            "(input req_site, input ?, output return_int)"}
         if return_int = 0 then do:
            /* User does not have access to this site */
            {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
            next-prompt req_site with frame a.
            undo seta-1, retry.
         end.

      end. /* IF REQ_SITE <> "" */

      /* CHECK ITEM STATUS CODE TO MAKE SURE PO'S ARE ALLOWED */
      find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
      req_part no-lock no-error.

      if available pt_mstr then do:

         assign
            ptstatus                = pt_status
            substring(ptstatus,9,1) = "#".

         if can-find(isd_det  where isd_det.isd_domain = global_domain and
         isd_status = ptstatus
                               and isd_tr_type = "ADD-PO")
         then do:
            /* Restricted procedure for item status code */
            {pxmsg.i &MSGNUM=358 &ERRORLEVEL=3 &MSGARG1=pt_status}
            undo seta-1, retry.
         end.
      end. /* IF AVAILABLE PT_MSTR */

      undo-all = false.

   end. /* SETA1: DO ON ERROR.. */

end.  /* MAINPROC*/
