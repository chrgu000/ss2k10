/* xxgetwropwip.p ---- */
/* Copyright 2010 SoftSpeed gz                                                         */
/* All rights reserved worldwide.  This is an unpublished work.                        */
/* SS - 100715.1 By: Kaine Zhang */

{mfdeclre.i}

define input parameter sLot as character.
define input parameter iOp as integer.
define output parameter decQtyWIP as decimal.

for first xwrld_det
    no-lock
    where xwrld_domain = global_domain
        and xwrld_wo_lot = sLot
        and xwrld_op = iOp
    use-index xwrld_lot_op
:
end.
decQtyWIP = if available(xwrld_det) then xwrld_qty_wip else 0.


