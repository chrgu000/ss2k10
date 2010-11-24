/* xxgettmpvd.i ---- */
/* Copyright 2010 SoftSpeed gz                                                         */
/* All rights reserved worldwide.  This is an unpublished work.                        */
/* SS - 100412.1 By: Kaine Zhang */

/*
{xxgettmpvd.i
    yr
    per
}
*/

define temp-table tmpvd_tmp
    field tmpvd_addr as character
    field tmpvd_type as character
    field tmpvd_type_desc as character
    .

empty temp-table tmpvd_tmp.
for each vd_mstr
    no-lock
    where vd_domain = global_domain
:
    create tmpvd_tmp.
    assign
        tmpvd_addr = vd_addr
        .
    find first xvd_mstr
        no-lock
        where xvd_domain = global_domain
            and xvd_addr = vd_addr
            and xvd_start_year * 100 + xvd_start_month <= {1} * 100 + {2}
            and xvd_finish_year * 100 + xvd_finish_month >= {1} * 100 + {2}
        use-index xvd_addr_date
        no-error.
    if available(xvd_mstr) then do:
        tmpvd_type = xvd_type.

        find first code_mstr
            no-lock
            where code_domain = global_domain
                and code_fldname = "xvd_type"
                and code_value = xvd_type
            no-error.
        if available(code_mstr) then tmpvd_type_desc = code_cmmt.
    end.
end.



