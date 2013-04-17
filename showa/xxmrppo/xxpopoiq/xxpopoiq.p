/* xxpopoiq.p - PURCHASE ORDER INQUIRY display with pod_type                  */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.9.3.2 $                                                       */
/*K1L4*/ /*                                                                   */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 1.0     LAST MODIFIED: 06/11/86     BY: PML                      */
/* REVISION: 2.0     LAST MODIFIED: 09/07/87     BY: PML *A89*                */
/* REVISION: 4.0     LAST MODIFIED: 01/04/88     BY: FLM *A108*               */
/* REVISION: 4.0     LAST MODIFIED: 03/28/88     BY: FLM *A187*               */
/* REVISION: 6.0     LAST MODIFIED: 08/17/90     BY: SVG *D058*               */
/* REVISION: 6.0     LAST MODIFIED: 03/26/91     BY: RAM *D453*               */
/* REVISION: 7.0     LAST MODIFIED: 07/07/92     BY: afs *F742*               */
/* REVISION: 7.0     LAST MODIFIED: 09/17/92     BY: WUG *G159*               */
/* Revision: 7.3     Last edit: 11/19/92         By: jcd *G339*               */
/* REVISION: 7.0     LAST MODIFIED: 10/24/94     BY: ljm *GN62*               */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98     BY: *L007* A. Rahane         */
/* REVISION: 8.6E    LAST MODIFIED: 03/09/98     BY: *K1L4* Beena Mol         */
/* REVISION: 8.6E    LAST MODIFIED: 05/20/98     BY: *K1Q4* Alfred Tan        */
/* REVISION: 8.6E    LAST MODIFIED: 06/03/98     BY: *K1RS* A.Shobha          */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00     BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00     BY: *N0KQ* myb               */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Old ECO marker removed, but no ECO header exists *GM74*                    */
/* $Revision: 1.9.3.2 $    BY: Dayanand Jethwa   DATE: 01/28/04  ECO: *P1LM*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE          */
{mfdtitle.i "111021.1"}

define variable vend like po_vend no-undo.
define variable nbr like po_nbr no-undo.
define variable due like pod_due_date no-undo.
define variable sord like pod_so_job no-undo.
define variable open_ref like pod_qty_ord label "Qty Open" no-undo.
define variable part like pt_part no-undo.
define variable work_ord like pod_wo_lot no-undo.
define variable getall like mfc_logical initial no label "All" no-undo.

part = global_part.

form
   part
   /*V8! view-as fill-in size 20 by 1 space(.1) */
   nbr
   /*V8! space(.1) */
   vend
   /*V8! space(.1) */
   due
   /*V8! space(.1) */
   sord
   /*V8! space(.1) */
   work_ord
   /*V8! space(.1) */
   getall
   /*V8! view-as fill-in size 3.5 by 1 */
with frame a no-underline width 80 no-attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}

repeat:

   if c-application-mode <> 'web'
   then
      update part nbr vend due sord work_ord getall with frame a
   editing:

      if frame-field = "part"
      then do:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i pod_det part pod_part part pod_part pod_part}
         if recno <> ?
         then do:
            part = pod_part.
            display part with frame a.
            recno = ?.
         end. /*  IF recno <> ?  */
      end. /* IF FRAME-FIELD = "part"  */
      else if frame-field = "nbr"
      then do:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i po_mstr nbr po_nbr nbr po_nbr po_nbr}
         if recno <> ?
         then do:
            nbr = po_nbr.
            display nbr with frame a.
            recno = ?.
         end. /*  IF recno <> ?  */
      end. /*  ELSE IF FRAME-FIELD = "nbr"  */
      else do:
         status input.
         readkey.
         apply lastkey.
      end. /* ELSE DO: */
   end. /*  EDITING: */

   {wbrp06.i &command = update &fields = "  part nbr vend due sord
        work_ord getall" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      /*V8! do:  */
      hide frame b.
      hide frame c.
      hide frame d.
      hide frame e.
      hide frame f.
      hide frame g.
      hide frame h.
      /*V8! end. */

   end. /*  IF (c-application-mode <> 'web') OR ....*/

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "terminal"
               &printWidth = 80
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "no"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}

   if part <> ""
   then
   for each pod_det
      where pod_part = part
      and   not pod_sched
      and ((pod_status <> "c" and pod_status <> "x" ) or getall = yes)
      no-lock use-index pod_partdue
      with frame b width 80
      on endkey undo, leave:

      /* SET EXTERNAL LABELS */

      setFrameLabels(frame b:handle).
      {mfrpchk.i}
      open_ref = pod_qty_ord - pod_qty_rcvd.

      find po_mstr
      where po_nbr = pod_nbr
      no-lock.
      if (vend = "" or po_vend = vend)
         and (nbr = "" or pod_nbr = nbr)
         and (due = ? or pod_due_date = due)
         and (sord = "" or pod_so_job = sord)
         and (work_ord = "" or pod_wo_lot = work_ord)
         and po_type <> "B"
         then do with frame b:
         display
            pod_site
            po_vend
            pod_nbr
            pod_line
            open_ref
            pod_um
            pod_due_date
            pod_type
            pod_so_job
            pod_wo_lot pod_status.
      end. /*  IF (vend = "" OR po_vend = vend) .... */
   end. /*  FOR EACH pod_det  */

   else
   if nbr <> ""
   then
      loopc:
   for each po_mstr
      where po_nbr = nbr
      and   po_type <> "B"
      no-lock:
      {mfrpchk.i}
      for each pod_det
         where pod_nbr = po_nbr
         and   not pod_sched
         and   ((pod_status <> "c" and pod_status <> "x" ) or getall = yes)
         no-lock
         use-index pod_nbrln with frame c width 80
         on endkey undo, leave loopc:

         /* SET EXTERNAL LABELS */

         setFrameLabels(frame c:handle).
         {mfrpchk.i}
         open_ref = pod_qty_ord - pod_qty_rcvd.
         if (vend = "" or po_vend = vend)
            and (due = ? or pod_due_date = due)
            and (sord = "" or pod_so_job = sord)
            and (work_ord = "" or pod_wo_lot = work_ord)
         then do with frame c:
            display
               po_vend
               pod_line
               pod_part
               open_ref
               pod_um
               pod_due_date
               pod_type
               pod_so_job
               pod_wo_lot pod_status.
         end. /*  IF (vend = "" OR po_vend = vend) .... */
      end. /*  FOR EACH pod_det  */
   end. /*  FOR EACH po_mstr  */

   else
   if vend <> ""
   then
      loopd:
   for each po_mstr
      where po_vend = vend
      and   po_type <> "B"
      no-lock:
      {mfrpchk.i}
      for each pod_det
         where pod_nbr = po_nbr
         and   not pod_sched
         and   ((pod_status <> "c" and pod_status <> "x" ) or getall = yes)
         no-lock
         use-index pod_nbrln with frame d width 80
         on endkey undo, leave loopd:

         /* SET EXTERNAL LABELS */

         setFrameLabels(frame d:handle).
         {mfrpchk.i}
         open_ref = pod_qty_ord - pod_qty_rcvd.
         if (due = ? or pod_due_date = due)
            and (sord = "" or pod_so_job = sord)
            and (work_ord = "" or pod_wo_lot = work_ord)
            then do with frame d:
            display
               pod_nbr
               pod_line
               pod_part
               open_ref
               pod_um
               pod_due_date
               pod_type
               pod_so_job
               pod_wo_lot pod_status.
         end. /*  IF (due = ? OR pod_due_date = due) ... */
      end. /*  FOR EACH pod_det  */
   end. /*  FOR EACH po_mstr  */

   else
   if due <> ?
   then
   for each pod_det
      where pod_due_date = due
      and   not pod_sched
      and   ((pod_status <> "c" and pod_status <> "x" ) or getall = yes)
      use-index pod_part no-lock
      with frame e width 80:

      /* SET EXTERNAL LABELS */

      setFrameLabels(frame e:handle).
      {mfrpchk.i}
      find po_mstr
         where po_nbr = pod_nbr
         no-lock.
      open_ref = pod_qty_ord - pod_qty_rcvd.
      if (vend = "" or po_vend = vend)
         and (sord = "" or pod_so_job = sord)
         and (work_ord = "" or pod_wo_lot = work_ord)
         and po_type <> "B"
         then do with frame e:
         display
            po_vend
            pod_nbr
            pod_line
            pod_part
            open_ref
            pod_um
            pod_type
            pod_so_job
            pod_wo_lot pod_status.
      end. /*  IF (vend = "" OR po_vend = vend) .... */
   end. /*  FOR EACH pod_det  */
   else
   if sord <> ""
   then
   for each pod_det
      where pod_so_job = sord
      and   not pod_sched
      and   ((pod_status <> "c" and pod_status <> "x" ) or getall = yes)
      no-lock use-index pod_part
      with frame f width 80:

      /* SET EXTERNAL LABELS */

      setFrameLabels(frame f:handle).
      {mfrpchk.i}

      find po_mstr
         where po_nbr = pod_nbr
         no-lock.

      open_ref = pod_qty_ord - pod_qty_rcvd.
      if work_ord = "" or pod_wo_lot = work_ord
         and po_type <> "B"
         then do with frame f:
         display
            po_vend
            pod_nbr
            pod_line
            pod_part
            open_ref
            pod_um
            pod_due_date
            pod_type
            pod_wo_lot pod_status.
      end. /*  IF work_ord = "" OR pod_wo_lot = work_ord ....*/
   end. /*  FOR EACH pod_det  */
   else
   if work_ord <> ""
   then
   for each pod_det
      where pod_wo_lot = work_ord
      and   not pod_sched
      and   ((pod_status <> "c" and pod_status <> "x" ) or getall = yes)
      no-lock use-index pod_part
      with frame g width 80:

      /* SET EXTERNAL LABELS */

      setFrameLabels(frame g:handle).
      {mfrpchk.i}

      find po_mstr
         where po_nbr = pod_nbr
         no-lock.

      open_ref = pod_qty_ord - pod_qty_rcvd.
      if po_type <> "B"
      then do with frame g:
         display
            po_vend
            pod_nbr
            pod_line
            pod_part
            open_ref
            pod_um
            pod_due_date
            pod_type
            pod_so_job pod_status.
      end. /*  IF po_type <> "B"  */
   end. /*  FOR EACH pod_det  */
   else
      looph:
   for each pod_det
      where not pod_sched
      and ((pod_status <> "c" and pod_status <> "x" ) or getall = yes)
      no-lock use-index pod_part
      with frame h width 80
      on endkey undo, leave looph:

      /* SET EXTERNAL LABELS */

      setFrameLabels(frame h:handle).
      {mfrpchk.i}
      open_ref = pod_qty_ord - pod_qty_rcvd.

      find po_mstr
         where po_nbr = pod_nbr
         no-lock no-error.

      if po_type <> "B"
      then do with frame h:
         display
            po_vend
            pod_nbr
            pod_line
            pod_part
            open_ref
            pod_um
            pod_due_date
            pod_type
            pod_so_job pod_status.
      end. /*  IF po_type <> "B"  */
   end. /*  FOR EACH pod_det  */
   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}

   {mfreset.i}
end. /*  REPEAT: */
global_part = part.

{wbrp04.i &frame-spec = a}
