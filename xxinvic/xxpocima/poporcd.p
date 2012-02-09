/* poporcd.p - PURCHASE ORDER RECEIPTS MULTI-DB ROUTINE                 */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*J2DG*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 7.0     LAST MODIFIED: 12/08/91    BY: RAM *F033*          */
/* REVISION: 7.0     LAST MODIFIED: 01/30/92    BY: RAM *F126*          */
/* REVISION: 7.3     LAST MODIFIED: 11/04/93    BY: afs *H220*          */
/* REVISION: 7.4     LAST MODIFIED: 06/13/94    BY: afs *FO81*          */
/* REVISION: 7.4     LAST MODIFIED: 06/07/95    BY: bcm *F0SM*          */
/* REVISION: 9.0     LAST MODIFIED: 04/16/99    BY: *J2DG* Reetu Kapoor */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00 BY: *N0KQ* myb              */

/*J2DG*/ /* ADDED NO-UNDO  AND ASSIGN  WHEREVER MISSING                    */
/*J2DG*/ /* REPLACED FIND STATEMENTS WITH FOR FIRST FOR ORACLE PERFORMANCE */

/*********************************************************************
*  This program is used to update pod_det records in the PO header   *
*  database to reflect activity in the remote databases, such as     *
*  Receipts and Returns.                                             *
*********************************************************************/

/*F0SM*/ {mfdeclre.i}
         {gplabel.i} /* EXTERNAL LABEL INCLUDE */

     define shared variable po_recno as recid.
     define variable old_recno as recid no-undo.
/*H220** define variable change_db like mfc_logical. **/
     define new shared variable new_db like si_db.
     define new shared variable old_db like si_db.
     define new shared variable new_site like si_site.
     define new shared variable old_site like si_site.
     define new shared stream hs_po.
     define new shared frame hf_po_mstr.
     define new shared frame hf_pod_det.
/*FO81*/ define buffer poddet for pod_det.
/*FO81*/ define new shared variable blanket_qty_rcvd  like pod_qty_rcvd.
/*FO81*/ define new shared variable blanket_rel_qty   like pod_rel_qty.
/*FO81*/ define new shared variable blanket_qty_chg   like pod_qty_chg.

/*F0SM** {mfdeclre.i} **/

/*F0SM*/ form
/*F0SM*/     pod__qad02 format "->>>>>>>>>9"
/*F0SM*/ with frame hf_pod_det.

     form po_mstr with frame hf_po_mstr.
     form pod_det with frame hf_pod_det.

     {mfoutnul.i &stream_name="hs_po"}

/*J2DG*/ assign
            old_recno = po_recno
            old_db    = global_db.
/*H220** change_db = no.  **/

/*J2DG** find po_mstr where recid(po_mstr) = po_recno no-lock no-error. **/

/*J2DG*/ /** DID NOT ADD FIELD LIST - REQUIRES ENTIRE RECORD **/

/*J2DG*/ for first po_mstr
/*J2DG*/    where recid(po_mstr) = po_recno no-lock:
/*J2DG*/ end. /* FOR FIRST PO_MSTR */

     if available po_mstr then do:

/*          display stream hs_po po_mstr with frame hf_po_mstr.         */

/*J2DG*/ /** DID NOT ADD FIELD LIST - REQUIRES ENTIRE RECORD **/
/*H220*/    for each pod_det where pod_nbr = po_nbr no-lock:
/*H220*     break by pod_po_db: */

           if pod_po_db <> ""
           and pod_po_db <> old_db then do:

          display stream hs_po pod_det with frame hf_pod_det.

/*FO81*/          /* Store blanket line quantities for update */
/*FO81*/          if pod_blanket <> "" then do:

/*FO81*/             find poddet where poddet.pod_nbr  = pod_det.pod_blanket
/*FO81*/             and poddet.pod_line = pod_det.pod_blnkt_ln
/*FO81*/             no-error.

/*FO81*/             if available poddet then assign
/*FO81*/                blanket_qty_rcvd = poddet.pod_qty_rcvd
/*FO81*/                blanket_rel_qty  = poddet.pod_rel_qty
/*FO81*/                blanket_qty_chg  = poddet.pod_qty_chg
/*FO81*/                .
/*FO81*/          end.

/*H220**          change_db = yes.   **/
/*FO81**          new_db =         pod_po_db. **/
/*FO81*/          new_db = pod_det.pod_po_db.
          {gprun.i ""gpaliasd.p""}
          {gprun.i ""poporcd1.p""}

           end.  /* if pod_po_db <> "" */

/*H220*        (Moved outside of loop)
 *             if last-of(pod_po_db)
 *             and change_db then do:
/*F126            {gprun.i ""poporcb.p""} */
 *                new_db = old_db.
 *                {gprun.i ""gpaliasd.p""}
 *                change_db = no.
 *                po_recno = old_recno.
 *             end.  /* if last-of(pod_po_db) */
 **H220*/

        end.  /* for each pod_det */

/*H220*/     new_db = old_db.
/*H220*/    {gprun.i ""gpaliasd.p""}
/*H220*/     po_recno = old_recno.

     end.  /* if available po_mstr */
