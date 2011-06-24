/* xswri10deftemptable.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/24/2009   By: Kaine Zhang     Eco: *ss_20090724* */


define temp-table t1_tmp no-undo
    field t1_part as character
    field t1_op like wod_op
    field t1_lot as character
    field t1_qty as decimal
    field t1_trnbr like tr_trnbr
    .

define variable dec1 as decimal no-undo.
define variable bSucceed as logical no-undo.
define variable bEnoughQty as logical no-undo.
define variable sFailPart as character no-undo.
define variable sFailLot as character no-undo.
define variable decFailQty as decimal no-undo.
define variable decFailStore as decimal no-undo.
