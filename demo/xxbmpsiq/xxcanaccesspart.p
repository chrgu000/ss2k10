/* SS - 110104.1 By: Kaine Zhang */
/*
 * check permission of part(pt_part_type).
 * return current user can access part
 */
{mfdeclre.i}

define input parameter sPart as character.
define output parameter bCanAccessPart as logical.

bCanAccessPart = no.

for first pt_mstr
    no-lock
    where pt_domain = global_domain
        and pt_part = sPart
:
end.
if available(pt_mstr) then do:
    for first code_mstr
        no-lock
        where code_domain = pt_domain
            and code_fldname = pt_part_type
            and code_value = global_userid
    :
    end.
    if available(code_mstr) then do:
        bCanAccessPart = yes.
    end.
    else do:
        /* if userid set blank , then conside it can be access by all */
        for first code_mstr
            no-lock
            where code_domain = pt_domain
                and code_fldname = pt_part_type
                and code_value = ""
        :
        end.
        if available(code_mstr) then bCanAccessPart = yes.
    end.
end.




