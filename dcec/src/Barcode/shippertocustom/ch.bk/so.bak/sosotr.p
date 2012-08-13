/* GUI CONVERTED from sosotr.p (converter v1.75) Wed Oct  4 04:26:04 2000 */
/* sosotr.p - SALES ORDER TRANSACTION                                   */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
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
/* REVISION: 9.0    LAST MODIFIED: 10/04/00   BY: *M0TF* Rajesh Kini    */

     {mfdeclre.i}

     define shared variable so_recno as recid.
     define shared variable sod_recno as recid.
     define shared variable qty_req like in_qty_req.
     define shared stream bi.
     define shared frame bi.
/*L034*/ define variable mc-error-number like msg_nbr no-undo.

/*FN92*/ define variable qty_all like in_qty_all.

/*J04C*/ define buffer seoc_buf for seoc_ctrl.

     find first soc_ctrl no-lock.

     find so_mstr no-lock where recid(so_mstr) = so_recno no-error.
     if not available so_mstr then leave.

     find sod_det no-lock where recid(sod_det) = sod_recno no-error.
     if not available sod_det then leave.

/*FT43*/ /* This overlap frame bi sets the display format of those */
/*FT43*/ /* fields to what have been re-formatted in solinfrm.i    */

/*J2D6*/ /* REPLACED BELOW BLOCK BY SOBIFRM.I */
/*J2D6** BEGIN DELETE **
 * /*FT43*/ form
 * /*FT43*/     sod_qty_ord                    format "->>>>,>>9.9<<<<"
 * /*FT43*/     sod_list_pr                    format ">>>,>>>,>>9.99<<<"
 * /*FT43*/     sod_disc_pct label "Disc%"     format "->>>>9.99"
 * /*FT43*/ with frame bi.
 *J2D6** END DELETE   */

/*J2D6*/ /* FORM DEFINITION FOR HIDDEN FRAME BI */
/*J2D6*/ {sobifrm.i}

     FORM /*GUI*/ 
         sod_det
     with frame bi THREE-D /*GUI*/.


/*F504*/ /* reverse tr_hist if not new line and was confirmed. */
/*F0W9*
./*F0S5* *F504* if not new sod_det and input frame bi sod_confirm then do:  */
./*F0S5*/ if not new sod_det and input frame bi sod_confirm and
./*F0S5*/      sod_type = "" then do:
.*F0W9*/
/*F0W9*/ if not new sod_det and input frame bi sod_confirm then do:

/*F0H4*     RATHER THAN MFSOTR.I TRYING TO FIGURE OUT HOW MANY ALLOCATIONS */
/*F0H4*     TO MODIFY, WE'LL TELL IT...                                    */
/*F0H4*/    qty_all = - (input frame bi sod_qty_all +
/*F0H4*/                 input frame bi sod_qty_pick -
/*F0H4*/                 input frame bi sod_qty_chg) *
/*F0H4*/                 input frame bi sod_um_conv.
        {mfsotr.i "DELETE" "input frame bi"}
/*F504*/ end.

/*F0W9* /*F0S5*/ if sod_type = "" then */
        /* RMA RECEIPTS SHOULD NOT CREATE INVENTORY ALLOCATIONS */
/*J04C*/ if sod_fsm_type = "RMA-RCT" then
/*J04C*/    qty_all = 0.
/*M0TF*/ else
/*M0TF*/    if sod_fsm_type = "RMA-ISS"
/*M0TF*/    then
/*M0TF*/        qty_all = (sod_qty_all + sod_qty_pick) * sod_um_conv.
/*J04C*/    else
/*F0H4*/        assign qty_all = (sod_qty_all + sod_qty_pick - sod_qty_chg)
/*F0H4*/                        * sod_um_conv.

     {mfsotr.i "ADD"}
