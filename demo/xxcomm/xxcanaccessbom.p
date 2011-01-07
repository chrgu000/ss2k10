/* SS - 110104.1 By: Kaine Zhang */
/*
 * check permission of bom(pt_status).
 * return current user can access bom
 */

{mfdeclre.i}

define input parameter sBom as character.
define output parameter bCanAccessBom as logical.

bCanAccessBom = no.

for first pt_mstr
    no-lock
    where pt_domain = global_domain
        and pt_part = sBom
:
end.
if available(pt_mstr) then do:
    for first code_mstr
        no-lock
        where code_domain = pt_domain
            and code_fldname = pt_status
            and code_value = global_userid
    :
    end.
    
    if available(code_mstr) then do:
        bCanAccessBom = yes.
    end.
    else do:
        /* if userid set blank , then conside it can be access by all */
        for first code_mstr
            no-lock
            where code_domain = pt_domain
                and code_fldname = pt_status
                and code_value = ""
        :
        end.
        if available(code_mstr) then bCanAccessBom = yes.
    end.
end.



