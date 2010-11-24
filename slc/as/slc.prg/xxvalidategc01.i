/* check whether the Generalized Code is validate */

for first code_mstr
    where code_domain = global_domain
        and code_fldname = {1}
    no-lock:
end.
if available(code_mstr) then do:
    for first code_mstr
        where code_domain = global_domain
            and code_fldname = {1}
            and code_value = {2}
        no-lock:
    end.
    if available(code_mstr) then
        {3} = yes.
    else
        {3} = no.
end.
else do:
    {3} = yes.
end.
