/* xssorjt10deftemptable.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* SS - 100301.1 By: Roger Xiao */

define temp-table t1_tmp no-undo
    field t1_line like pod_line
    field t1_qty as decimal
    field t1_trnbr like tr_trnbr
    .

define variable bSucceed as logical no-undo.
define variable iFailLine like pod_line no-undo.
define variable decFailQty like pod_qty_ord no-undo.
