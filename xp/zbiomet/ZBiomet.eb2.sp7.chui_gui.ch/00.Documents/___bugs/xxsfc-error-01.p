define temp-table temp1 field t1_wolot as char .
for each temp1 :  delete temp1 . end.

for each xxwrd_det break by xxwrd_wonbr by xxwrd_wolot by xxwrd_op :
    xxwrd_lastwo = no .
    xxwrd_lastop = no .
    if last-of(xxwrd_wolot) then xxwrd_lastop = yes .
    if last-of(xxwrd_wonbr) then do:
        xxwrd_lastwo = yes .
        create temp1 .
        assign t1_wolot = xxwrd_Wolot .
    end.
end.


for each temp1 ,
    each xxwrd_det 
    where xxwrd_wolot = t1_wolot :
    xxwrd_lastwo = yes .
end.


