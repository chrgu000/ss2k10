FOR each ih_hist where  ih_nbr = "订单"
     and ih_inv_nbr = "发票" :
    DISPLAY ih_nbr ih_inv_nbr   .
     DELETE ih_hist .
END.

FOR each idh_hist where  idh_nbr = "订单"
   and idh_inv_nbr = "发票" AND idh_line = "项次" :
    DISPLAY idh_nbr idh_inv_nbr  idh_part idh_line .
    DELETE idh_hist .
END.
