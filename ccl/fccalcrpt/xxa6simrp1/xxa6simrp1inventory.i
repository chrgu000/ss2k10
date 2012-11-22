
find first in_mstr
    no-lock
    use-index in_part
    where in_part = {1}
        and in_site = {2}
    no-error.
if available(in_mstr) then do:
    {3} = in_qty_oh.
end.
else do:
    {3} = 0.
end.