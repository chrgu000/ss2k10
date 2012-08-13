FOR EACH so_mstr WHERE so__dec01 <> 0 ,
    EACH sod_det WHERE sod_nbr = so_nbr :
    DISPLAY sod_nbr sod_line sod_part sod_qty_chg sod_qty_inv sod__dec01 so__dec01 FORMAT "->>>,>>,>>9.9<<<<<<<".
END.
