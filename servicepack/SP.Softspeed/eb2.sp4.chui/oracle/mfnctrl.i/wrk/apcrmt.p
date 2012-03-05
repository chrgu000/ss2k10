/* apcrmt.p - AP CHECK RECONCILIATION MAINTENANCE                             */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.9.1.4 $                                                    */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 1.0      LAST MODIFIED: 09/08/86   BY: PML                       */
/* REVISION: 6.0      LAST MODIFIED: 06/10/91   BY: mlv *D683*                */
/* REVISION: 7.0      LAST MODIFIED: 12/06/91   BY: mlv *F037*                */
/*                                   12/17/91   BY: mlv *F074*                */
/*                                   12/30/91   BY: mlv *F081*                */
/*                                   06/01/92   BY: mlv *F513*                */
/* REVISION: 7.3      LAST MODIFIED: 10/21/92   by: jms *G213*                */
/*                                   11/24/92   BY: bcm *G352*                */
/*                                   01/04/93   by: jms *G497* (rev only)     */
/*                                   06/07/93   by: jms *G934* (rev only)     */
/*                                   06/25/93   by: jjs *GC76* (rev only)     */
/*                                   07/13/93   by: wep *GD37* (rev only)     */
/* REVISION: 7.4      LAST MODIFIED: 07/13/93   by: wep *H235* (rev only)     */
/* REVISION: 8.6      LAST MODIFIED: 06/18/96   BY: bjl *K001*                */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton       */
/* Pre-86E commented code removed, view in archive revision 1.5               */
/* Old ECO marker removed, but no ECO header exists *Hwep*                    */
/* REVISION: 8.6E     LAST MODIFIED: 07/23/98   BY: *L03K* Jeff Wootton       */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.9.1.4 $    BY: Manjusha Inglay       DATE: 07/29/02  ECO: *N1P4*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "2+ "}
{gldydef.i new}
{gldynrm.i new}

define new shared variable barecid          as   recid.
define new shared variable jrnl             like glt_ref.
/*VARIABLES FOR CASH BOOK*/
define new shared variable cash_book        like mfc_logical initial no.
define new shared variable bank_bank        like ck_bank.
define new shared variable bank_ctrl        like ap_amt.
define new shared variable bank_b_ctrl      like ap_amt.
define new shared variable bank_ex_rate     like cb_ex_rate.
define new shared variable bank_ex_rate2    like cb_ex_rate2.
define new shared variable bank_ex_ratetype like cb_ex_ratetype.
define new shared variable bank_exru_seq    like cb_exru_seq.
define new shared variable bank_curr        like bk_curr.
define new shared variable bank_date        like ba_date.
define new shared variable bank_batch       like ba_batch.
define new shared variable b_batch          like cb_batch.
define new shared variable b_line           like cb_line.
define new shared variable del_cb           like mfc_logical.
define new shared variable undo_all         like mfc_logical.

define variable draft_idr                   as   character format "x(1)".

do transaction:
   /* GET NEXT JOURNAL REFERENCE NUMBER  */
   {mfnctrl.i apc_ctrl apc_jrnl glt_det glt_ref jrnl}
end. /* DO TRANSACTION */

{gprun.i ""apcrmtm.p""}
