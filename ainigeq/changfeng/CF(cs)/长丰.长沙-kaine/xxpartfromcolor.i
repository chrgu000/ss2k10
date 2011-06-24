/* SS - 091111.1 By: Kaine Zhang */

for first xcscolor_mstr
    no-lock
    where xcscolor_color = {1}
:
end.
{2} = if available(xcscolor_mstr) then xcscolor_part else "".

