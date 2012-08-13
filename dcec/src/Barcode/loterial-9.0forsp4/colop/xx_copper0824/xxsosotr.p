/* xxsosotr.p - SALES ORDER TRANSACTION                                   */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.10.3.8.3.3 $                                            */
/*F0PN*//*V8:ConvertMode=Maintenance                                    */
/* REVISION 5.0     LAST MODIFIED: 04/03/89   BY: MLB   *B083**/
/* REVISION: 6.0    LAST MODIFIED: 04/10/90   BY: MLB   *D021**/
/* REVISION: 7.0    LAST MODIFIED: 06/11/92   BY: tjs   *F504**/
/* REVISION: 7.2    LAST MODIFIED: 05/05/94   BY: afs   *FN92**/
/* REVISION: 7.3    LAST MODIFIED: 11/16/94   BY: qzl   *FT43**/
/* REVISION: 7.3    LAST MODIFIED: 02/13/95   BY: smp   *F0H4**/
/* REVISION: 8.5    LAST MODIFIED: 10/13/95   BY: *J04C* Sue Poland     */
/* REVISION: 8.5    LAST MODIFIED: 12/12/95   BY: *F0S5* Sue Poland     */
/* REVISION: 8.5    LAST MODIFIED: 12/22/95   BY: *F0W9* Sue Poland     */
/* REVISION: 8.5    LAST MODIFIED: 01/31/98   BY: *J2D6* Seema Varma    */
/* REVISION: 8.6    LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan     */
/* REVISION: 8.6E   LAST MODIFIED: 06/25/98   BY: *L034* Russ Witt      */
/* REVISION: 9.1    LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1    LAST MODIFIED: 04/25/00   BY: *N0CG* Santosh Rao      */
/* REVISION: 9.1    LAST MODIFIED: 08/12/00   BY: *N0KN* myb              */
/* REVISION: 9.1    LAST MODIFIED: 10/04/00   BY: *M0TF* Rajesh Kini      */
/* Revision: 1.10.3.8.3.2   BY: Ellen Borden     DATE: 10/15/01  ECO: *P004* */
/* $Revision: 1.10.3.8.3.3 $    BY: Ashish Maheshwari  DATE: 12/15/03  ECO: *P1DV* */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*                                                                        */
/**************************************************************************/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define input parameter reason-code like rsn_code.
define input parameter tr-cmtindx  like tr_fldchg_cmtindx.
define shared variable so_recno as recid.
define shared variable sod_recno as recid.
define shared variable qty_req like in_qty_req.
define shared stream bi.
define shared frame bi.
define variable mc-error-number like msg_nbr no-undo.

define variable qty_all like in_qty_all.

define buffer seoc_buf for seoc_ctrl.

for first soc_ctrl
      fields(soc_so_hist)
      no-lock:
end. /* FOR FIRST SOC_CTRL */

for first so_mstr
      fields(so_ca_nbr so_curr so_cust so_exru_seq
      so_ex_rate so_ex_rate2 so_ex_ratetype so_fsm_type
      so_nbr so_rev so_slspsn)
      where recid(so_mstr) = so_recno no-lock:
end. /* FOR FIRST SO_MSTR */

if not available so_mstr then leave.

find sod_det where recid(sod_det) = sod_recno
   exclusive-lock no-error.

if not available sod_det then leave.

/* FORM DEFINITION FOR HIDDEN FRAME BI */
{sobifrm.i}

FORM /*GUI*/ 
   sod_det
with frame bi THREE-D /*GUI*/.


if not new sod_det
   and input frame bi sod_confirm
then do:

   if sod_fsm_type = "RMA-ISS"
   then
      qty_all = - (input frame bi sod_qty_all +
                   input frame bi sod_qty_pick) *
                   input frame bi sod_um_conv.
   else
      qty_all = - (input frame bi sod_qty_all +
                   input frame bi sod_qty_pick -
                   input frame bi sod_qty_chg) *
                   input frame bi sod_um_conv.

   {mfsotr.i "DELETE" "input frame bi"}

end. /* IF NOT NEW sod_det ... */

if reason-code <> "" or tr-cmtindx > 0 then
assign
   tr_rsn_code = reason-code
   tr_fldchg_cmtindx = tr-cmtindx.

/* RMA RECEIPTS SHOULD NOT CREATE INVENTORY ALLOCATIONS */
if sod_fsm_type = "RMA-RCT" then
   qty_all = 0.
else
if sod_fsm_type = "RMA-ISS"
   then
   qty_all = (sod_qty_all + sod_qty_pick) * sod_um_conv.
else
assign qty_all = (sod_qty_all + sod_qty_pick - sod_qty_chg) * sod_um_conv.

{mfsotr.i "ADD"}
