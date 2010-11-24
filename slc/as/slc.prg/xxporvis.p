/* porvis.p - PURCHASE ORDER RETURN TO VENDOR ISSUE                     */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.6.1.3 $                                                         */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 6.0     LAST MODIFIED: 08/08/90    BY: RAM *D030**/
/* REVISION: 6.0     LAST MODIFIED: 08/17/90    BY: SVG *D058**/
/* REVISION: 6.0     LAST MODIFIED: 02/11/91    BY: RAM *D345**/
/* REVISION: 6.0     LAST MODIFIED: 03/26/91    BY: RAM *D457**/
/* REVISION: 6.0     LAST MODIFIED: 03/27/91    BY: RAM *D462**/
/* REVISION: 6.0     LAST MODIFIED: 04/11/91    BY: RAM *D518**/
/* REVISION: 6.0     LAST MODIFIED: 05/10/91    BY: RAM *D641**/
/* REVISION: 6.0     LAST MODIFIED: 05/30/91    BY: RAM *D666**/
/* REVISION: 6.0     LAST MODIFIED: 06/25/91    BY: RAM *D676**/
/* REVISION: 6.0     LAST MODIFIED: 07/09/91    BY: MLV *D757**/
/* REVISION: 6.0     LAST MODIFIED: 07/16/91    BY: RAM *D777**/
/* REVISION: 6.0     LAST MODIFIED: 08/15/91    BY: pma *D829**/ /*rev only*/
/* REVISION: 6.0     LAST MODIFIED: 09/17/91    BY: WUG *D858**/
/* REVISION: 6.0     LAST MODIFIED: 09/20/91    BY: RAM *D871**/
/* REVISION: 6.0     LAST MODIFIED: 10/03/91    BY: alb *D887**/
/* REVISION: 6.0     LAST MODIFIED: 11/08/91    BY: RAM *D923**/
/* REVISION: 7.0     LAST MODIFIED: 12/02/91    BY: pma *F003**/
/* REVISION: 7.0     LAST MODIFIED: 12/09/91    BY: RAM *F070**/
/* REVISION: 7.3     LAST MODIFIED: 11/03/92    BY: MPP *G263**/
/* REVISION: 7.3     LAST MODIFIED: 11/09/92    BY: afs *G303*   (rev only) */
/* REVISION: 7.3     LAST MODIFIED: 12/15/92    BY: tjs *G443*   (rev only) */
/* REVISION: 7.3     LAST MODIFIED: 01/05/93    BY: MPP *G481**/
/* REVISION: 7.3     LAST MODIFIED: 02/08/93    BY: tjs *G654**/
/* REVISION: 7.3     LAST MODIFIED: 02/16/93    BY: tjs *G682*   (rev only) */
/* REVISION: 7.3     LAST MODIFIED: 02/25/93    BY: tjs *G751*   (rev only) */
/* REVISION: 7.3     LAST MODIFIED: 03/31/93    BY: afs *G891*   (rev only) */
/* REVISION: 7.3     LAST MODIFIED: 07/07/93    BY: cdt *GC95*   (rev only) */
/* REVISION: 7.4     LAST MODIFIED: 07/22/93    BY: pcd *H039**/
/* REVISION: 7.4     LAST MODIFIED: 09/23/93    BY: tjs *H093**/
/* REVISION: 7.4     LAST MODIFIED: 11/14/93    BY: afs *H220**/
/* REVISION: 7.4     LAST MODIFIED: 10/27/94    BY: cdt *FS95**/
/* REVISION: 7.4     LAST MODIFIED: 10/31/94    BY: ame *GN82**/
/* REVISION: 8.6     LAST MODIFIED: 06/11/96    BY: aal *K001**/
/* REVISION: 8.6     LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan       */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00    BY: *N0KQ* myb              */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Old ECO marker removed, but no ECO header exists *GO37*                    */
/* Revision: 1.6.1.2   BY: Jean Miller           DATE: 04/25/02  ECO: *P06H*  */
/* $Revision: 1.6.1.3 $        BY: John Corda            DATE: 08/08/02  ECO: *N1QP*  */
/* By: Neil Gao Date: 07/12/23 ECO: * ss 20071223 * */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*!
    porvis.p - Purchase Order Returns
*/

/*!
ANY CHANGES MADE TO porvis.p MUST ALSO BE MADE TO poporc.p
*/

{mfdtitle.i "2+ "}

{gldydef.i new}
{gldynrm.i new}

define new shared variable porec       like mfc_logical no-undo.
define new shared variable is-return   like mfc_logical no-undo.
define new shared variable tax_tr_type like tx2_tax_type initial "25" no-undo.
define new shared variable ports       as character no-undo.


/* Let poporcm.p know that we're returning purchase orders. */
assign
   ports = ""
   porec = yes
   is-return = yes.

/* ss 20071223 - b */
/*
{gprun.i ""porvism.p""}
*/
{gprun.i ""xxporvism.p""}
/* ss 20071223 - e */
