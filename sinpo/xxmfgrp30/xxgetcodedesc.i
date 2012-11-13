/* SS - 100704.1 By: Kaine Zhang */

for first code_mstr
    no-lock
    where code_domain = global_domain
        and code_fldname = {1}
        and code_value = {2}
:
end.
{3} = if available(code_mstr) then code_cmmt else "".


