/* SS - 091111.1 By: Kaine Zhang */

for first xcsser_mstr
    no-lock
    where xcsser_serial = {1}
:
end.
{2} = if available(xcsser_mstr) then xcsser_part else "".

