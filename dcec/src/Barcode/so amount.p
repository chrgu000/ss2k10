output to c:\output\soamt.txt .
define var so_ln_sum1 as integer format "->,>>>,>>9" .
define var so_ln_sum as integer format "->,>>>,>>9".
assign so_ln_sum1=0.
assign so_ln_sum=0.
for each so_mstr where so_due_date>=01/01/06 AND so_due_date<=12/31/06 no-lock:
for each sod_det where sod_nbr=so_nbr AND sod_site=so_site no-lock with no-box stream-io width 320:
if available sod_det then do:
so_ln_sum=so_ln_sum + 1.
end.
end.
assign so_ln_sum1= so_ln_sum.
assign so_ln_sum=0.
display so_nbr '' so_ln_sum1 '' '' so_due_date ''.
end.
