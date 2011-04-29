
define var v_sq01 as integer .
define var v_sq02 as integer .

v_sq01 = 0 .
for each xxwrd_det 
    fields( xxwrd_wrnbr) 
    no-lock
    break by xxwrd_wrnbr :

    if last(xxwrd_wrnbr) then do:
        v_sq01 = xxwrd_wrnbr .
    end.
end.


v_sq02 = 0 .
for each xxfb_hist 
    fields( xxfb_trnbr) 
    no-lock
    break by xxfb_trnbr :

    if last(xxfb_trnbr) then do:
        v_sq02 = xxfb_trnbr .
    end.
end.





/*
message v_sq01 v_sq02 view-as alert-box .
*/

assign current-value(sfc_sq01) = v_sq01 
       current-value(sfc_sq02) = v_sq02 .
