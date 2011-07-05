/* xxiclomt.p - LOCATION MAINTENANCE                                     */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                   */
/* All rights reserved worldwide.  This is an unpublished work.          */

/* $Revision: 1.6.5.11.3.1 $                                             */

/* REVISION: 1.0      LAST MODIFIED: 03/28/86   BY: PML                  */
/* REVISION: 2.0      LAST MODIFIED: 07/28/87   BY: EMB *A41*            */
/* REVISION: 6.0      LAST MODIFIED: 03/12/90   BY: emb *D002*           */
/* REVISION: 6.0      LAST MODIFIED: 03/29/90   BY: WUG *D015*           */
/* REVISION: 7.0      LAST MODIFIED: 11/12/91   BY: flm *F036*           */
/* REVISION: 7.0      LAST MODIFIED: 01/30/92   BY: emb *F114*           */
/* REVISION: 7.0      LAST MODIFIED: 04/09/92   BY: emb *F372*           */
/* REVISION: 7.2      LAST MODIFIED: 08/19/94   BY: pxd *FQ40*           */
/* REVISION: 7.5      LAST MODIFIED: 10/05/94   BY: mwd *J034*           */
/* REVISION: 7.5      LAST MODIFIED: 01/08/95   BY: taf *J038*           */
/* REVISION: 7.2      LAST MODIFIED: 02/19/95   BY: qzl *F0JM*           */
/* REVISION: 8.5      LAST MODIFIED: 07/28/95   BY: bholmes *J0FY*       */
/* REVISION: 8.5      LAST MODIFIED: 04/26/96   BY: bholmes *J0K3*       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane     */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan    */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan    */
/* REVISION: 9.1      LAST MODIFIED: 11/20/99   BY: *N04Q* J. Fernando   */
/* REVISION: 9.1      LAST MODIFIED: 03/06/00   BY: *N05Q* Mayse Lai     */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* myb              */
/* REVISION: 9.1      LAST MODIFIED: 09/18/00   BY: *N0VN* Mudit Mehta      */
/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* Revision: 1.6.5.8    BY: Russ Witt  DATE: 06/01/01 ECO: *P00J*        */
/* Revision: 1.6.5.9    BY: Russ Witt  DATE: 07/09/01 ECO: *P011*        */
/* Revision: 1.6.5.10   BY: Russ Witt  DATE: 10/17/01 ECO: *P021*        */
/* Revision: 1.6.5.11   BY: Patrick Rowan DATE: 05/24/02  ECO: *P018* */
/* $Revision: 1.6.5.11.3.1 $    BY: Rajaneesh S.  DATE: 07/16/03  ECO: *N2J9* */

/*V8:ConvertMode=Maintenance                                             */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* Revision: 1.6.5.11                      BY: ZY DATE: 07/05/11  ECO: *Y175* */
/* Environment: Progress:9.1D   QAD:eb2sp12    Interface:Character            */
/*Y175  - 110705.1    ZY      *Y175*
  Purpose:做库位分组,以便统计库存状态报表
  Parameters:<none>
  Notes:借用loc_user1
  Change List:
        xxiclomt.p
        xxicstrp.p
*/
/* DISPLAY TITLE */
{mfdtitle.i "110705.1"}
{cxcustom.i "ICLOMT.P"}

define variable del-yn  like mfc_logical initial no.
define variable locstatus like loc_status.
define variable locdesc like loc_desc.
define variable reserved_cust like mfc_logical initial no no-undo.
define variable v-project like loc_project no-undo.

/* CONSIGNMENT INVENTORY VARIABLES */
{pocnvars.i}

/* DISPLAY SELECTION FORM */
form
   loc_site       colon 30 si_desc no-label
   loc_loc        colon 30 skip(1)
   loc_desc       colon 30
   loc_status     colon 30 validate (true, "")
   loc_project    colon 30 pj_desc no-label
   loc_date       colon 30
   loc_perm       colon 30
   loc_type       colon 30
   loc_single     colon 30
   loc__qad01     colon 30 label "Single Lot/Ref"
   loc_cap        colon 30 loc_cap_um label "UM"
   reserved_cust  colon 30 label "Reserved Locations"
   loc_xfer_ownership colon 30
   loc_user1      colon 30
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
         "(input ENABLE_SUPPLIER_CONSIGNMENT,
           input 11,
           input ADG,
           input SUPPLIER_CONSIGN_CTRL_TABLE,
           output using_supplier_consignment)"}

/* DISPLAY */
view frame a.
global_site = "".
mainloop:
repeat with frame a:

   prompt-for loc_site loc_loc
   editing:
      if frame-field = "loc_site" then do:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i si_mstr
                 loc_site
                 si_site
                 loc_site
                 si_site
                 si_site}
         if recno <> ?
         then display si_site @ loc_site
                      si_desc
         with frame a.
         global_site = input loc_site.
      end.   /* if frame-field = "loc_site" */
      else if frame-field = "loc_loc" then do:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp05.i loc_mstr
                   loc_loc
                   "(loc_site = input loc_site)"
                   loc_loc
                   "input loc_loc"}
         if recno <> ? then do:
            /* FIND NEXT/PREVIOUS RECORD */

            for first si_mstr fields (si_site si_desc)
               where si_site = loc_site
               no-lock:
            end.

            if can-find (first locc_det where locc_site = loc_site
                         and   locc_loc  = loc_loc) then
            reserved_cust = yes.
            else reserved_cust = no.

            for first pj_mstr fields (pj_project pj_desc)
               where pj_project = loc_project
               no-lock:
            end.
            if available pj_mstr then
               display pj_desc.
            else display "" @ pj_desc.

            display
               loc_site
               si_desc   when(available si_mstr)
               loc_loc
               loc_desc
               loc_status
               loc_date
               loc_perm
               loc_type
               loc_single
               loc_cap
               loc__qad01
               loc_cap_um
               loc_project
               reserved_cust
               loc_xfer_ownership when (using_supplier_consignment)
               loc_user1
            with frame a
            .
         end.  /* if recno <> ? */
      end.  /* if frame-field = "loc_loc" */
   end.  /* editing */

   if can-find (first locc_det where locc_site = input loc_site
                and   locc_loc  = input loc_loc) then
   reserved_cust = yes.
   else reserved_cust = no.

   for first whl_mstr fields (whl_site whl_loc)
         where whl_mstr.whl_site = input loc_site
         and whl_mstr.whl_loc = input loc_loc
         exclusive-lock:
   end.
   if available whl_mstr
   then do:
      {pxmsg.i &MSGNUM=1813 &ERRORLEVEL=3}
      undo, retry.
   end.

   for first si_mstr fields (si_site si_desc)
         where si_site = input loc_site
         no-lock:
   end.

   if available si_mstr then do:
      {gprun.i ""gpsiver.p""
         "(input si_site, input recid(si_mstr), output return_int)"}
      if return_int = 0 then do:
         {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
         /* USER DOES NOT HAVE */
         /* ACCESS TO THIS SITE*/
         undo, retry.
      end.
   end.

   /* ADD/MOD/DELETE  */

   for first loc_mstr
         where loc_site = input loc_site and loc_loc = input loc_loc
         exclusive-lock:
   end.
   if available loc_mstr then locdesc  = loc_desc.
   if not available loc_mstr then do:
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create loc_mstr.
      assign
         loc_loc
         loc_site
         loc_desc
         loc_status  = si_status
         loc_single = no
         loc__qad01 = no
         loc_xfer_ownership = if using_supplier_consignment
                                then si_xfer_ownership
                                else no
         loc_perm = yes
         loc_user1.
         locdesc = " ".
   end.
   assign
      recno = recid(loc_mstr)
      global_site = loc_site.

   for first pj_mstr fields (pj_project pj_desc)
         where pj_project = loc_project
         no-lock:
   end.
   if available pj_mstr then
      display pj_desc.
   else display " " @ pj_desc.
   v-project = loc_project.

   display
      loc_site si_desc when(available si_mstr)
      " " when (not available si_mstr) @ si_desc
      loc_loc
      locdesc @ loc_desc
      loc_status
      loc_date loc_perm loc_type
      loc_single
      loc__qad01
      loc_cap loc_cap_um
      loc_project
      reserved_cust
      loc_xfer_ownership when (using_supplier_consignment).
      loc_user1
      .

   ststatus = stline[2].
   status input ststatus.
   del-yn = no.

   locstatus = loc_status.

   set1:
   do on error undo, retry:

      set
         loc_desc loc_status
         loc_project
         loc_date loc_perm loc_type
         loc_single
         loc__qad01
         loc_cap loc_cap_um
         reserved_cust
         loc_xfer_ownership when (using_supplier_consignment)
         loc_user1
         go-on (F5 CTRL-D).

      /* VALIDATING THE INVENTORY STATUS */
      if not can-find(is_mstr
                      where is_status = input loc_status)
      then do:
         /* INVENTORY STATUS MUST EXIST */
         {pxmsg.i &MSGNUM=6282 &ERRORLEVEL=3}
         next-prompt loc_status.
         undo, retry.
      end. /* IF NOT CAN-FIND(is_mstr... ) */


      /* DELETE */
      if lastkey = keycode("F5") or
         lastkey = keycode("CTRL-D") then do:
         del-yn = yes.
         {mfmsg01.i 11 1 del-yn}
         if del-yn = no then undo set1.
      end.
      if del-yn then do:
         /* DELETE LOCATION DETAIL IF QTY NOT OUTSTANDING */
         {pxmsg.i &MSGNUM=211 &ERRORLEVEL=1}

         if can-find (first ld_det where ld_site = si_site
            and ld_loc = loc_loc) then do:
            {pxmsg.i &MSGNUM=431 &ERRORLEVEL=3}
            undo, retry.
         end.
         if can-find (first tag_mstr where tag_site = si_site
            and tag_loc = loc_loc) then do:
            {pxmsg.i &MSGNUM=432 &ERRORLEVEL=3}
            undo, retry.
         end.

/*       Issue warning if reserved customer locations found...*/
         if can-find (first locc_det where locc_site = si_site
         and locc_loc = loc_loc) then do:
            del-yn = no.
            {pxmsg.i &MSGNUM=3345 &ERRORLEVEL=1 &CONFIRM=del-yn}
            /* RESERVED LOCATION DATA EXISTS FOR THIS */
            /* LOCATION. CONTINUE?                    */
            if del-yn = no then undo set1, retry.
         end.

         for each locc_det exclusive-lock
         where locc_site =  loc_site
         and   locc_loc  =  loc_loc:
            delete locc_det.
         end.

         delete loc_mstr.
         clear frame a.
         del-yn = no.
         hide message no-pause.
         next mainloop.
      end.

      /* WARNING IF PROJECT IS CHANGED IN A NON-EMPTY LOCATION*/
      if v-project <> loc_project and
         can-find(first ld_det where ld_site = loc_site
         and ld_loc  = loc_loc
         and ld_qty_oh <> 0)
      then do:
         {pxmsg.i &MSGNUM=8609 &ERRORLEVEL=2}
         /* PROJECT CHANGED, BUT MATERIAL FOUND IN LOCATION */
      end.

      for first pj_mstr fields (pj_project pj_desc)
            where pj_project = loc_project
            no-lock:
      end.
      if available pj_mstr then display pj_desc.
      else display " " @ pj_desc.

      if loc__qad01 and not loc_single then do:
         {pxmsg.i &MSGNUM=230 &ERRORLEVEL=2}
         /* Single Lot/Serial is only enforced for single item locations */
      end.
      {&ICLOMT-P-TAG1}

      if loc_status <> locstatus then do:

         for first ld_det fields(ld_loc ld_lot ld_qty_oh ld_site)
               where ld_site = loc_site
               and ld_loc = loc_loc and ld_lot = "" no-lock:
         end.
         if available ld_det then do:
            /* Status of existing non-lot/serial control  */
            /* inventory not changed*/
            {pxmsg.i &MSGNUM=1452 &ERRORLEVEL=2}
         end.
      end.

      /* if reserved_cust is yes, call program iclomta.p   */
      /* to update reserved cust data                      */
      if reserved_cust = yes then do:
         /* Issue warning first if available status = yes */
         for first is_mstr fields(is_status is_avail)
            where is_status = loc_status
            no-lock:
               if batchrun = no and is_avail = yes then do:
               {pxmsg.i &MSGNUM=4611 &ERRORLEVEL=2}
               /* Reserved locations not advised when Inv Status */
               /*  is "avail = yes"                              */
               del-yn = no.
               {pxmsg.i &MSGNUM=2316 &ERRORLEVEL=1 &CONFIRM=del-yn}
               /* OK to continue? */
               if del-yn = no then do:
                  next-prompt reserved_cust with frame a.
                  undo set1, retry set1.
               end.
            end.  /* is_avail = yes */
         end.   /* for first is_mstr */

         hide frame a no-pause.
         {gprun.i ""iclomta.p""
         "(input loc_site, input loc_loc)"}
         view frame a.
      end.   /* reserved_cust = yes */

   end.  /*** (set1:) ***/
end.  /*** (mainloop:) ***/
status input.
