/*  ---- */
/* Copyright 2010 SoftSpeed gz                                                         */
/* All rights reserved worldwide.  This is an unpublished work.                        */
/* SS - 100412.1 By: Kaine Zhang */

{mfdeclre.i}
define input parameter rcd1 as recid.
define output parameter b1 as logical.

define variable s1 as character no-undo.
define variable i1 as integer no-undo.
define variable i2 as integer no-undo.
define variable i3 as integer no-undo.

b1 = no.
find first xvd_mstr
    no-lock
    where recid(xvd_mstr) = rcd1
    no-error.
if available(xvd_mstr) then do:
    assign
        s1 = xvd_addr
        i1 = xvd_start_year
        i2 = xvd_start_month
        i3 = xvd_finish_year * 100 + xvd_finish_month
        .
    find first xvd_mstr
        no-lock
        where xvd_domain = global_domain
            and xvd_addr = s1
            and xvd_start_year * 100 + xvd_start_month > i1 * 100 + i2
        use-index xvd_addr_date
        no-error.
    if available(xvd_mstr) then do:
        if xvd_start_year * 100 + xvd_start_month > i3 then b1 = yes.
    end.
    else
        b1 = yes.
end.



