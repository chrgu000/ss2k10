/* arpamt.p - AR PAYMENT MAINTENANCE                                          */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.13.1.11 $                                                               */
/*V8:ConvertMode=Maintenance                                                  */
/* Revision: 2.0      LAST MODIFIED: 12/18/86   BY: PML *A3*                  */
/* REVISION: 6.0      LAST MODIFIED: 02/28/91   BY: afs *D387*                */
/* REVISION: 6.0      LAST MODIFIED: 03/12/91   BY: MLB *D360*                */
/* REVISION: 6.0      LAST MODIFIED: 03/12/91   BY: MLB *D385*                */
/* REVISION: 6.0      LAST MODIFIED: 03/12/91   BY: afs *D424*   (rev only)   */
/* REVISION: 6.0      LAST MODIFIED: 04/19/91   BY: MLV *D546*                */
/* REVISION: 6.0      LAST MODIFIED: 04/25/91   BY: afs *D498*   (rev only)   */
/* REVISION: 6.0      LAST MODIFIED: 04/26/91   BY: MLV *D559*                */
/* REVISION: 6.0      LAST MODIFIED: 04/29/91   BY: afs *D598*                */
/* REVISION: 6.0      LAST MODIFIED: 05/02/91   BY: MLV *D595*                */
/* REVISION: 6.0      LAST MODIFIED: 06/06/91   BY: MLV *D674*                */
/* REVISION: 6.0      LAST MODIFIED: 06/17/91   BY: afs *D709*   (rev only)   */
/* REVISION: 7.0      LAST MODIFIED: 01/03/92   BY: MLV *F081*                */
/* REVISION: 7.0      LAST MODIFIED: 05/29/92   BY: MLV *F513*                */
/* REVISION: 7.3      LAST MODIFIED: 09/27/94   BY: jpm *GM78*                */
/* REVISION: 8.6      LAST MODIFIED: 06/11/96   BY: aal *K001*                */
/* REVISION: 8.6      LAST MODIFIED: 12/03/97   BY: B. Gates *K1DG*           */
/* REVISION: 8.6E     LAST MODIFIED: 04/02/98   BY: rup *L00K*                */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton       */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 08/10/00   BY: *L127* Shilpa Athalye     */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                */
/* REVISION: 9.1      LAST MODIFIED: 01/03/01   BY: *M0Y4* Jose Alex          */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Old ECO marker removed, but no ECO header exists *L01K*                    */
/* Revision: 1.13.1.9   BY: Manjusha Inglay    DATE: 07/29/02  ECO:   *N1P4*  */
/* Revision: 1.13.1.10  BY: Marcin Serwata      DATE: 11/17/03  ECO: *P18V*  */
/* $Revision: 1.13.1.11 $ BY: Hitendra P V    DATE: 07/12/05  ECO: *P3SP*               */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 080830.1 By: Bill Jiang */
/* SS - 090929.1 By: Bill Jiang */
/* SS - 100330.1  By: Roger Xiao */ /*修改了子程式ssarpamtd.p*/  /*参照ssapvomt.p修改,eco:091218.1,需求见call:ss-396,共四只程式全部需要修改*/

/* SS - 080830.1 - B */
/*
{mfdtitle.i "1+ "}
*/
{mfdtitle.i "100330.1"}

DEFINE NEW SHARED VARIABLE ref_glt LIKE glt_det.glt_ref.
DEFINE NEW SHARED VARIABLE user1_glt LIKE glt_det.glt_user1.
DEFINE NEW SHARED VARIABLE nbr_ar LIKE ar_mstr.ar_nbr.
/* SS - 080830.1 - E */
{cxcustom.i "ARPAMT.P"}

define new shared variable cash_book        like mfc_logical initial no.
define new shared variable bank_ctrl        like ap_amt.
define new shared variable bank_total       like ap_amt.
define new shared variable bank_batch       like ba_batch.
define new shared variable b_batch          like ba_batch.
define new shared variable bank_bank        like ck_bank.
define new shared variable arjrnl           like glt_ref.
define new shared variable arbatch          like ar_batch.
define new shared variable arnbr            like ar_nbr.
define new shared variable bank_ex_rate     like ar_ex_rate.
define new shared variable bank_ex_rate2    like ar_ex_rate2.
define new shared variable bank_ex_ratetype like cb_ex_ratetype.
define new shared variable bank_exru_seq    like cb_exru_seq.
define new shared variable bank_curr        like bk_curr.
define new shared variable new_line         like mfc_logical.
{&ARPAMT-P-TAG1}
define new shared variable del_cb           like mfc_logical.
{&ARPAMT-P-TAG2}
define new shared variable undo_all         like mfc_logical.
define new shared variable h-arpamtpl       as   handle         no-undo.
define new shared variable l_ar_base_amt    like ar_base_amt    no-undo.
define new shared variable l_batch_err      like mfc_logical    no-undo.

{gldydef.i new}
{gldynrm.i new}
/*COMMON EURO TOOLKIT VARIABLES*/
{etvar.i &new = new}

{gprun.i ""arpamtpl.p"" "persistent set h-arpamtpl"}

/* SS - 080830.1 - B */
/*
{gprun.i ""arpamtm.p"" "(input """")"}
*/
{gprun.i ""ssarpamtm.p"" "(input """")"}
/* SS - 080830.1 - E */

delete PROCEDURE h-arpamtpl no-error.
