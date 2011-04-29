/* ptsumt.p - PART SUBSTITUTE MAINTENANCE                                     */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.6.1.6 $                                                       */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 6.0      LAST MODIFIED: 03/01/90   BY: EMB                       */
/* REVISION: 7.0      LAST MODIFIED: 03/24/92   BY: pma *F089*                */
/* REVISION: 7.2      LAST MODIFIED: 09/09/94   BY: pxd *FQ91*                */
/* Oracle changes (share-locks)      09/12/94   BY: rwl *FR24*                */
/* REVISION: 7.2      LAST MODIFIED: 09/24/94   BY: ais *FR78*                */
/* REVISION: 7.5      LAST MODIFIED: 03/14/95   BY: dzs *J046*                */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.6.1.3  BY: Jean Miller           DATE: 05/20/02  ECO: *P05V*   */
/* Revision: 1.6.1.4  BY: Amit Chaturvedi DATE: 06/19/02 ECO: *N1LT* */
/* $Revision: 1.6.1.6 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K* */


/* $MODIFIED BY: softspeed Roger Xiao         DATE: 2008/01/28  ECO: *xp001*  */ /*add使用优先顺序,借用pts_user1*/
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdtitle.i "2+ "}

define new shared variable cmtindx as integer.

define var v_abcd as integer format ">>9" label "使用优先顺序". /*xp001*/



define variable del-yn     like mfc_logical initial no.
define variable part_desc1 like pt_desc1    no-undo.
define variable part_desc2 like pt_desc1    no-undo.
define variable par_desc1  like pt_desc1    no-undo.
define variable par_desc2  like pt_desc1    no-undo.
define variable sub_desc1  like pt_desc1    no-undo.
define variable sub_desc2  like pt_desc1    no-undo.
define variable cmmts      like mfc_logical no-undo initial no label "Comments".
define variable parum      like pt_um       no-undo.
define variable partum     like pt_um       no-undo.
define variable subpartum  like pt_um       no-undo.
define variable ptstatus   like pt_status   no-undo.

/* DISPLAY SELECTION FORM */
form
   /* VALIDATE IS ADDED TO SKIP SCHEMA VALIDATION */
   pts_par       colon 25 label "Parent/Base Process Item" validate(true,"")
   parum         no-label
   par_desc1     no-label at 51
   par_desc2     no-label at 51
   skip(1)
   pts_part      colon 25 partum no-label
   part_desc1    no-label at 51
   part_desc2    no-label at 51
   pts_sub_part  colon 25 subpartum no-label
   sub_desc1     no-label at 51
   sub_desc2     no-label at 51
   pts_qty_per   colon 25
   v_abcd        colon 25 /*xp001*/
   pts_rmks      colon 25
   cmmts         colon 25
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
view frame a.

display-loop:
repeat with frame a:

   prompt-for
      pts_par
      pts_part
      pts_sub_part
   editing:

      if frame-field = "pts_par"
      then do:

         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i pts_det pts_par  " pts_det.pts_domain = global_domain and
         pts_par "  pts_par pts_par pts_par}
      end. /* IF frame-field = "pts_par" */

      else
      if frame-field = "pts_item"
      then do:

         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i pts_det pts_part  " pts_det.pts_domain = global_domain and
         pts_part "  pts_part pts_part pts_det}
      end. /* IF frame-field = "pts_item" */
      else
      if frame-field = "pts_sub_item"
      then do:

         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i pts_det pts_sub_part  " pts_det.pts_domain = global_domain and
         pts_sub_part "
                 pts_sub_part pts_sub_part pts_sub_part}
      end. /* IF frame-field = "pts_sub_item" */
      else do:

         readkey.
         apply lastkey.
      end. /* ELSE DO */

      if recno <> ?
      then do:

         assign
            par_desc1  = ""
            par_desc2  = ""
            part_desc1 = ""
            part_desc2 = ""
            sub_desc1  = ""
            sub_desc2  = ""
            parum      = ""
            partum     = ""
            subpartum  = "".
			v_abcd = 0 . /*xp001*/

         find pt_mstr no-lock
          where pt_mstr.pt_domain = global_domain and  pt_part = pts_par
         no-error.

         if available pt_mstr
         then
            assign
               par_desc1 = pt_desc1
               par_desc2 = pt_desc2
               parum     = pt_um.

         find pt_mstr no-lock
          where pt_mstr.pt_domain = global_domain and  pt_part = pts_part
         no-error.

         if available pt_mstr
         then
            assign
               part_desc1 = pt_desc1
               part_desc2 = pt_desc2
               partum     = pt_um.

         find pt_mstr no-lock
          where pt_mstr.pt_domain = global_domain and  pt_part = pts_sub_part
         no-error.

         if available pt_mstr
         then
            assign
               sub_desc1 = pt_desc1
               sub_desc2 = pt_desc2
               subpartum = pt_um.

         cmmts = (pts_cmtindx <> 0).
		 v_abcd = integer(pts_user1) . /*xp001*/

         display
            pts_par
            parum
            par_desc1
            par_desc2
            pts_part
            partum
            part_desc1
            part_desc2
            pts_sub_part
            subpartum
            sub_desc1
            sub_desc2
            pts_qty_per
            pts_rmks
			v_abcd  /*xp001*/
            cmmts.
      end. /* IF recno <> ? */

   end. /* PROMT-FOR */

   if input pts_par <> ""
   then do:

      /* CHECK FOR THE EXISTANCE OF PARENT/BASE PROCESS ITEM AS */
      /* ITEM OR BOM CODE                                       */
      if not (can-find(first pt_mstr
          where pt_mstr.pt_domain = global_domain and   pt_part = input
          pts_par))
         and not (can-find(first bom_mstr
          where bom_mstr.bom_domain = global_domain and  bom_parent = input
          pts_par))
      then do:

     /* ITEM NUMBER OR BOM CODE MUST EXIST */
         {pxmsg.i &MSGNUM=231 &ERRORLEVEL=3}
         undo display-loop, retry display-loop.

      end. /* IF NOT (CAN-FIND(FIRST pt_mstr... */

   end. /* IF INPUT pts_par <> "" */

   /* ADD/MOD/DELETE  */

   find pts_det exclusive-lock
using  pts_part and pts_par and pts_sub_part where pts_det.pts_domain =
global_domain  no-wait no-error.





   if locked pts_det
   then do:

      /* Record locked by another user.  Try later */
      {pxmsg.i &MSGNUM=7422 &ERRORLEVEL=4}
      next display-loop.
   end. /* IF LOCKED pts_det */

   if not available pts_det
   then do:

      find pt_mstr no-lock
       where pt_mstr.pt_domain = global_domain and  pt_part = input pts_sub_part
      no-error.

      if available pt_mstr
      then do:

         assign
            ptstatus                = pt_status
            substring(ptstatus,9,1) = "#".

         if can-find(isd_det
          where isd_det.isd_domain = global_domain and  isd_status = ptstatus
         and   isd_tr_type = "ADD-PS")
         then do:

            /* Restricted Item status */
            {pxmsg.i &MSGNUM=358 &ERRORLEVEL=3 &MSGARG1=pt_status}
            undo, retry.
         end. /* IF CAN-FIND(isd_det... */
      end. /* IF AVAILABLE pt_mstr */

      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create pts_det. pts_det.pts_domain = global_domain.
      assign
         pts_part
         pts_par
         pts_sub_part.

   end. /* IF NOT AVAILABLE pts_det */

   recno = recid(pts_det).

   assign
      par_desc1  = ""
      par_desc2  = ""
      part_desc1 = ""
      part_desc2 = ""
      sub_desc1  = ""
      sub_desc2  = ""
      parum      = ""
      partum     = ""
      subpartum  = "".


   find pt_mstr no-lock
    where pt_mstr.pt_domain = global_domain and  pt_part = pts_par
   no-error.

   if available pt_mstr
   then
      assign
         par_desc1 = pt_desc1
         par_desc2 = pt_desc2
         parum     = pt_um.

   find pt_mstr no-lock
    where pt_mstr.pt_domain = global_domain and  pt_part = pts_part
   no-error.

   if available pt_mstr
   then
      assign
         part_desc1 = pt_desc1
         part_desc2 = pt_desc2
         partum     = pt_um.

   find pt_mstr no-lock
    where pt_mstr.pt_domain = global_domain and  pt_part = pts_sub_part
   no-error.

   if available pt_mstr
   then
      assign
         sub_desc1 = pt_desc1
         sub_desc2 = pt_desc2
         subpartum = pt_um.

   cmmts = (pts_cmtindx <> 0).
   v_abcd = integer(pts_user1) . /*xp001*/

   display
      pts_par
      parum
      par_desc1
      par_desc2
      pts_part
      partum
      part_desc1
      part_desc2
      pts_sub_part
      subpartum
      sub_desc1
      sub_desc2
      pts_qty_per
      pts_rmks
	  v_abcd /*xp001*/
      cmmts.

   ststatus = stline[2].
   status input ststatus.
   del-yn = no.

   do on error undo, retry:

      set
         pts_qty_per
		 v_abcd  /*xp001*/
         pts_rmks
         cmmts
      go-on ("F5" "CTRL-D").

      /* DELETE */
      if lastkey = keycode("F5")
      or lastkey = keycode("CTRL-D")
      then do:

         del-yn = yes.

         /* Please confirm delete */
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}

         if not del-yn
         then
            undo, retry.

         for each cmt_det exclusive-lock
             where cmt_det.cmt_domain = global_domain and  cmt_indx =
             pts_cmtindx:
            delete cmt_det.
         end. /* FOR EACH cmt_det */

         delete pts_det.

         clear frame a.
         del-yn = no.

      end. /* IF LASTKEY = keycode("F5") */



      if cmmts = yes
      and available pts_det
      then do:

	  pts_user1 = if v_abcd <> 0 then string(v_abcd) else "" .  /*xp001*/
         assign
            global_ref = string(pts_part)
            cmtindx    = pts_cmtindx.

         {gprun.i ""gpcmmt01.p"" "(input ""pts_det"")"}

         assign
            pts_cmtindx = cmtindx
            global_ref  = "".

      end. /* IF cmmts = yes ... */

   end. /* DO ON ERROR UNDO, RETRY: */

end. /* REPEAT */

status input.
