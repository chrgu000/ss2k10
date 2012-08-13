FIND FIRST so_mstr WHERE so_nbr = "0505030".
DISPLAY so_inv_date .

FOR EACH sod_det WHERE sod_nbr = "0505030":
    DISPLAY sod_part sod_price sod_list_pr sod__dec01 sod__dec02 sod__chr01 sod_fix_pr  .
END.
