/* xswor030060i01.i -- */
/* Copyright 200908 Softspeed Inc., Guangzhou, China                     */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: Version.ui    Modified: 08/24/2009   By: Kaine Zhang     Eco: *ss_20090824* */

find first code_mstr
    no-lock
    where code_fldname = "bc_wo_can_over_receipt"
        and code_value = "bc_wo_can_over_receipt"
        and code_value = "Y"
    no-error.
if not(available(code_mstr)) then do:
    if wo_qty_comp + dec0060 > wo_qty_ord then do:
        sMessage = "工单不允许超收".
        undo detlp, retry detlp.
    end.
end.

