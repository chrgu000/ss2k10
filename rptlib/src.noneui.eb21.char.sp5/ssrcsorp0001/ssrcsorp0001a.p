/* rcsorpa.p - Release Management Customer Schedules                    */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.5.1.6 $                                                 */
/*V8:ConvertMode=Report                                                 */
/* REVISION: 7.3    LAST MODIFIED: 10/06/92           BY: WUG *G462*    */
/* REVISION: 7.3    LAST MODIFIED: 12/15/94           BY: rxm *GN16*    */
/* REVISION: 7.3    LAST MODIFIED: 03/23/95           BY: aed *G0J0*    */
/* REVISION: 8.5    LAST MODIFIED: 04/24/95           BY: dpm *J044*    */
/* REVISION: 7.4    LAST MODIFIED: 10/07/95           BY: vrn *G0YL*    */
/* REVISION: 8.5    LAST MODIFIED: 10/15/96           BY: *G2GJ* Ajit Deodhar */
/* REVISION: 8.6    LAST MODIFIED: 10/03/97           BY: bvm *K0KR*    */
/* REVISION: 9.1    LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1    LAST MODIFIED: 08/12/00 BY: *N0KP* myb              */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.5.1.3    BY: Ellen Borden   DATE: 03/04/02  ECO:  *P00G*       */
/* Revision: 1.5.1.4  BY: Katie Hilbert DATE: 04/15/02 ECO: *P03J* */
/* $Revision: 1.5.1.6 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K* */
/* $Revision: 1.5.1.6 $ BY: Bill Jiang DATE: 03/08/08 ECO: *SS - 20080308.1* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20080308.1 - B */
{ssrcsorp0001.i}
/* SS - 20080308.1 - E */

/* SCHEDULED ORDER REPORT SUBPROGRAM */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{wbrp02.i}

define input parameter scx_recid as recid.
define input parameter consignment as logical no-undo.
define input parameter dev as character no-undo.
define variable l_desc1  like pt_desc1   no-undo.

define variable i as integer.
define variable impexp   like mfc_logical no-undo.

define variable proc_id as character no-undo.
{socnvars.i}
using_cust_consignment = consignment.

{rcordfrm.i}
form
   {rcordfma.i}

with frame prm side-labels width 80 attr-space.

/* SS - 20080308.1 - B */
/*
/* SET EXTERNAL LABELS */
setFrameLabels(frame prm:handle).
*/
/* SS - 20080308.1 - E */

find scx_ref where recid(scx_ref) = scx_recid no-lock.

find si_mstr  where si_mstr.si_domain = global_domain and  si_site =
scx_shipfrom no-lock.
find ad_mstr  where ad_mstr.ad_domain = global_domain and  ad_addr = scx_shipto
no-lock.

find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part = scx_part
no-lock.
find so_mstr  where so_mstr.so_domain = global_domain and  so_nbr = scx_order
no-lock.
find sod_det  where sod_det.sod_domain = global_domain and  sod_nbr = scx_order
and sod_line = scx_line no-lock.
find cm_mstr  where cm_mstr.cm_domain = global_domain and  cm_addr = so_cust
no-lock.
find first soc_ctrl  where soc_ctrl.soc_domain = global_domain no-lock.
find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.
if available pt_mstr then l_desc1 = pt_desc1.
else if available sod_det then l_desc1 = sod_desc.
else l_desc1 = "".

/* SS - 20080308.1 - B */
/*
{rcsoiq.i}
*/
{ssrcsorp0001iq.i}
/* SS - 20080308.1 - E */
{wbrp04.i}
