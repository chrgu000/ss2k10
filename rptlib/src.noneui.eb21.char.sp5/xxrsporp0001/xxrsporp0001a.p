/* rsporpa.p - Release Management Supplier Schedules                    */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.15 $                                                  */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 7.3    LAST MODIFIED: 12/10/92           BY: WUG *G462*    */
/* REVISION: 7.5    LAST MODIFIED: 03/21/95           BY: dpm *J044*    */
/* REVISION: 8.6    LAST MODIFIED: 05/20/98           BY: *K1Q4* Alfred Tan */
/* REVISION: 8.6E   LAST MODIFIED: 08/17/98           BY: *L062* Steve Nugent */
/* REVISION: 8.6E   LAST MODIFIED: 09/02/98           BY: *L08H* A. Shobha  */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00 BY: *N0KP* myb              */
/* Old ECO marker removed, but no ECO header exists *F0PN*                */
/* Revision: 1.13  BY: Dan Herman DATE: 05/24/02 ECO: *P018* */
/* $Revision: 1.15 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00L* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

     /* SCHEDULED ORDER REPORT SUBPROGRAM */

/* SS - 090115.1 By: Bill Jiang */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{pxmaint.i}

/* SS - 090115.1 - B */
{xxrsporp0001.i}
/* SS - 090115.1 - E */

define input parameter scx_recid as recid.
define input parameter consignment as logical no-undo.

define variable i as integer no-undo.
define variable impexp like mfc_logical no-undo.
define variable subtype as character format "x(12)"
        label "Subcontract Type" no-undo.
{pocnvars.i} /* Consignment variables */
{pocnpo.i}   /* Consignment procedures and frames */

using_supplier_consignment = consignment.

{rsordfrm.i}

find scx_ref where recid(scx_ref) = scx_recid no-lock.

find si_mstr  where si_mstr.si_domain = global_domain and  si_site = scx_shipto
no-lock.
find ad_mstr  where ad_mstr.ad_domain = global_domain and  ad_addr =
scx_shipfrom no-lock.

find vd_mstr  where vd_mstr.vd_domain = global_domain and  vd_addr = ad_addr
no-lock.

find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part = scx_part
no-lock.
find po_mstr  where po_mstr.po_domain = global_domain and  po_nbr = scx_order
no-lock.
find pod_det  where pod_det.pod_domain = global_domain and  pod_nbr = scx_order
and pod_line = scx_line no-lock.
find first poc_ctrl  where poc_ctrl.poc_domain = global_domain no-lock.
find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.

subtype = pod__qad16.

/* SS - 090115.1 - B */
/*
     {rspoiq.i}
*/
     {xxrsporp0001iq.i}
/* SS - 090115.1 - E */
