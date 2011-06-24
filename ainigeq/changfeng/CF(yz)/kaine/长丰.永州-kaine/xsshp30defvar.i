/* xsshp30deftemptable.i -- */
/* Copyright 200907 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 07/06/2009   By: Kaine Zhang     Eco: *ss_20090706* */
/* SS - 090706.1 By: Kaine Zhang */

define variable iSodLine like sod_line no-undo.
define variable sCarNumber as character no-undo.
define variable iQty1 as integer initial 1 no-undo.

define variable sSodNbr like sod_nbr no-undo.
define variable sSodPart like sod_part no-undo.
define variable sPartDesc as character no-undo.
define variable decOpenQty as decimal no-undo.

define variable iScanQty as integer no-undo.

define temp-table t1_tmp no-undo
    field t1_lot as character
    .
/* SS - 090826.1 - B
define variable sOrderQty as character no-undo.
define variable sShippedQty as character no-undo.
SS - 090826.1 - E */
