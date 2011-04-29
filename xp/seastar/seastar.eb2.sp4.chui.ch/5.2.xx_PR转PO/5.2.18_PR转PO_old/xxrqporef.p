/* rqporef.p  - REQUISITIONS MAINTAIN REQ/PO CROSSREFERENCE RECORD      */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.4 $                                                         */
/*V8:ConvertMode=NoConvert                                              */
/* REVISION: 8.5     LAST MODIFIED: 02/13/97    BY: B. Gates *J1Q2*     */
/* REVISION: 9.1     LAST MODIFIED: 08/12/00    BY: *N0KP* myb          */
/* Old ECO marker removed, but no ECO header exists *F0PN*              */
/* $Revision: 1.4 $    BY: Rajaneesh S.        DATE: 12/17/02  ECO: *N22B*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/************************************************************************/

{mfdeclre.i}

define input parameter p_first_call as   logical       no-undo.
define input parameter p_req_site   like pod_site      no-undo.
define input parameter p_req_nbr    like rqpo_req_nbr  no-undo.
define input parameter p_req_line   like rqpo_req_line no-undo.
define input parameter p_po_nbr     like rqpo_po_nbr   no-undo.
define input parameter p_po_line    like rqpo_po_line  no-undo.
define input parameter p_qty_ord    like pod_qty_ord   no-undo.
define input parameter p_pod_um     like pod_um        no-undo.
define output parameter p_req_um    like rqd_um        no-undo.
define output parameter p_ok        as   log           no-undo.

define variable old_db            as character no-undo.
define variable err-flag          as integer   no-undo.
define variable prev_qty          as decimal   no-undo.
define variable conversion_factor as decimal   no-undo.

/*define buffer b_poddet for pod_det.   */ /* xp001 */

if p_first_call
then do:
   /*FIRST TIME IN, WE SWITCH DB'S IF WE HAVE TO THEN
   CALL OURSELVES AGAIN, WHICH WILL EXECUTE THE ELSE BLOCK*/
   for first si_mstr
      fields(si_db si_site)
      where si_site = p_req_site
      no-lock:
   end. /* FOR FIRST si_mstr */

   if si_db <> global_db
   then do:
      old_db = global_db.
      {gprun.i ""gpalias3.p"" "(si_db, output err-flag)"}
   end. /* IF si_db <> global_db */

   {gprun.i ""xxrqporef.p""
      "(input no, input p_req_site, input p_req_nbr,
        input p_req_line, input p_po_nbr,
        input p_po_line, input p_qty_ord, input p_pod_um,
        output p_req_um, output p_ok)"}

   /*SWITCH BACK TO CENTRAL PO DB IF WE HAVE TO*/
   if old_db <> global_db
   then do:
      {gprun.i ""gpalias3.p"" "(old_db, output err-flag)"}
   end. /* IF old_db <> global_db */
end. /* IF p_first_call */
else do:
   prev_qty = 0.

   find rqpo_ref
      where rqpo_req_nbr  = p_req_nbr
        and rqpo_req_line = p_req_line
        and rqpo_po_nbr   = p_po_nbr
        and rqpo_po_line  = p_po_line
      exclusive-lock no-error.

   for first rqd_det
      fields(rqd_line rqd_nbr rqd_part rqd_um)
      where rqd_nbr  = p_req_nbr
        and rqd_line = p_req_line
      no-lock:
   end. /* FOR FIRST rqd_det */

   if  available rqpo_ref
   and not available rqd_det
   then do:
      delete rqpo_ref.
      leave.
   end. /* IF AVAILABLE rqpo_ref */

   p_req_um = rqd_um.

   if p_qty_ord = 0
   then do:
      if available rqpo_ref
      then
         delete rqpo_ref.
      p_ok = true.
   end. /* IF p_qty_ord = 0 */
   else do:
      if not available rqpo_ref
      then do:
         create rqpo_ref.

         assign
            rqpo_req_nbr  = p_req_nbr
            rqpo_req_line = p_req_line
            rqpo_po_nbr   = p_po_nbr
            rqpo_po_line  = p_po_line
            .

         if recid(rqpo_ref) = -1 then.
      end. /* IF NOT AVAILABLE rqpo_ref ... */

      conversion_factor = 1.

      if p_pod_um <> rqd_um
      then do:
         {gprun.i ""gpumcnv.p""
            "(input p_pod_um, input rqd_um, input rqd_part,
              output conversion_factor)"}
      end. /* IF p_pod_um <> rqd_um */

      /* USE THE EDITED UM CONVERSION AS CONVERSION FACTOR */
      /* for first b_poddet
         fields(pod_req_line pod_req_nbr pod_um_conv)
         where b_poddet.pod_req_nbr  = p_req_nbr
           and b_poddet.pod_req_line = p_req_line
         no-lock:

         if b_poddet.pod_um_conv <> conversion_factor
         then
            conversion_factor = b_poddet.pod_um_conv.

      end.  */ /* xp001 */

      rqpo_qty_ord = p_qty_ord * conversion_factor.
      p_ok = rqpo_qty_ord <> ?.
   end. /* ELSE DO */

   /*CHECK AND SET THE OPEN AND APRV STATUS INDICATORS*/

    for first rqm_mstr
       fields(rqm_aprv_stat rqm_nbr rqm_open rqm_status)
       where rqm_nbr = p_req_nbr
       no-lock:
    end. /* FOR FIRST rqm_mstr */
   {gprun.i ""rqsetopn.p"" "(input rqm_nbr)"}
end. /* ELSE DO */
