

define temp-table temp1 
    field t1_wonbr as char format "x(18)" 
    field t1_wolot as char 
    field t1_op    as integer 
    field t1_qty   as decimal .

define temp-table temp2 field t2_wonbr as char  format "x(18)" .

for each temp1: delete temp1 . end.
for each temp2: delete temp2 . end.

for each xxwrd_det no-lock
where xxwrd_qty_ord = 0 
break by xxwrd_wonbr by xxwrd_wolot by xxwrd_op :
    find first temp2 where t2_wonbr = xxwrd_wonbr no-lock no-error .
    if not avail temp2 then do:
        create temp2 . t2_wonbr = xxwrd_wonbr .
    end.
end.


for each temp2,
    each xxwrd_det where xxwrd_wonbr = t2_wonbr
    break by xxwrd_wonbr by xxwrd_wolot by xxwrd_op descending:
    if last-of(xxwrd_wonbr) then do:
        find first temp1 where t1_wonbr = xxwrd_wonbr and t1_wolot = xxwrd_wolot and t1_op = xxwrd_op no-error .
        if not avail temp1 then do:
            create temp1 .
            assign  t1_wonbr = xxwrd_wonbr 
                    t1_wolot = xxwrd_wolot 
                    t1_op    = xxwrd_op
                    t1_qty   = xxwrd_qty_comp .
        end.
    end.
end.

output to "/mfgeb2/bc_prod/test-001.txt".
for each temp1 :
disp temp1 .
end.
output close .

for each temp1 ,
    each xxwrd_det where xxwrd_wonbr = t1_wonbr :
    if xxwrd_qty_ord = 0 then assign xxwrd_qty_ord = t1_qty .
end.