define input parameter part like ps_comp .
define input parameter part1 like ps_comp .
define input parameter action as character .
define buffer xxptmp-mstr for xxptmp_mstr .


if action = "D" then
do:
for each xxptmp_mstr where xxptmp_comp = part :
delete xxptmp_mstr .
end.
end.

if action = "R" then 
do:
repeat :
find next xxptmp_mstr where xxptmp_comp = part no-error .
if not available xxptmp_mstr then leave .
else do:
create xxptmp-mstr .
assign xxptmp-mstr.xxptmp_par = xxptmp_mstr.xxptmp_par 
       xxptmp-mstr.xxptmp_site = xxptmp_mstr.xxptmp_site 
       xxptmp-mstr.xxptmp_comp = part1 
      xxptmp-mstr.xxptmp_qty_per = xxptmp_mstr.xxptmp_qty_per .
delete xxptmp_mstr .        
end.
end.  /*repeat*/

end.

if action = "A" then 
do :
repeat :
find next xxptmp_mstr where xxptmp_comp = part no-error .
if not available xxptmp_mstr then leave .
else do:
create xxptmp-mstr .
assign xxptmp-mstr.xxptmp_par = xxptmp_mstr.xxptmp_par 
       xxptmp-mstr.xxptmp_site = xxptmp_mstr.xxptmp_site 
       xxptmp-mstr.xxptmp_comp = part1 
      xxptmp-mstr.xxptmp_qty_per = xxptmp_mstr.xxptmp_qty_per . 
end.
end.  /*repeat*/

end.
