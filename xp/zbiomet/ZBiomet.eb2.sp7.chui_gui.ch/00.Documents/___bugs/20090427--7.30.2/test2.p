define var v_pknbr like xpk_nbr  .
define temp-table temp2  field t2_sonbr   like sod_nbr .

for each temp2 : delete temp2 . end.


update v_pknbr .

for each xpk_mstr where xpk_nbr >= v_pknbr no-lock 
break by xpk_sonbr :
    if first-of(xpk_sonbr) then do:
        find first temp2 where t2_sonbr = xpk_sonbr no-lock no-error.
        if not avail temp2 then do:
            create temp2 .
            assign t2_sonbr = xpk_sonbr . 
        end.
    end.
end.

output to "lad_det.txt" .
    for each temp2 ,
        each lad_det where lad_dataset = "sod_det" and lad_nbr = t2_sonbr no-lock  
        break by t2_sonbr with frame x1 width 300:

        disp lad_nbr lad_line lad_part lad_site lad_loc lad_lot lad_Ref lad_qty_all lad_qty_pick with frame x1 .
        
    end.

    put skip(10) .

    for each xpkd_det where xpkd_nbr >= v_pknbr  no-lock  
        break by xpkd_sonbr with frame x2 width 300:

        disp xpkd_sonbr xpkd_soline xpkd_nbr xpkd_part xpkd_site xpkd_loc xpkd_lot xpkd_box xpkd_qty_pk with frame x2 .
        
    end.
output close .
