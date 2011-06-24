/* Revision: Version.ui    Modified: 07/06/2009   By: Kaine Zhang     Eco: *ss_20090706* */
/* SS - 090706.1 By: Kaine Zhang */

define temp-table t1_tmp no-undo
    field t1_nbr like pod_nbr
    field t1_line like pod_line
    field t1_qty as decimal
    field t1_trnbr like tr_trnbr
    field t1_rct_nbr like tr_lot
    .

define variable bSucceed as logical no-undo.
define variable sFailNbr like pod_nbr no-undo.
define variable iFailLine like pod_line no-undo.
define variable decFailQty like pod_qty_ord no-undo.
