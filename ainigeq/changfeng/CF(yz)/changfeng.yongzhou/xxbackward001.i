/* SS - 100512.1 By: Kaine Zhang */

for first pt_mstr
    no-lock
    where pt_part = sWoPart
:
end.

if available(pt_mstr) then do:
    put
        "成品:" at 1    space(1)
        pt_part         space(1)
        "说明:" at 30   space(1)
        pt_desc1        space(1)
        pt_desc2
        skip(1)
        .
end.

