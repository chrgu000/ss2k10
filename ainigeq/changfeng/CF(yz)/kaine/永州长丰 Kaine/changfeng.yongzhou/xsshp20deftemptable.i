/* xsshp10deftemptable.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/06/2009   By: Kaine Zhang     Eco: *ss_20090706* */
/* SS - 090706.1 By: Kaine Zhang */

define temp-table t1_tmp no-undo
    field t1_line like pod_line
    field t1_qty as decimal
    field t1_trnbr like tr_trnbr
    .

define variable sCarNumber as character no-undo.
define variable bSucceed as logical no-undo.
define variable iFailLine like pod_line no-undo.
define variable decFailQty like pod_qty_ord no-undo.
