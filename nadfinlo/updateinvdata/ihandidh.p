FOR each ih_hist where  ih_nbr = "����"
     and ih_inv_nbr = "��Ʊ" :
    DISPLAY ih_nbr ih_inv_nbr   .
     DELETE ih_hist .
END.

FOR each idh_hist where  idh_nbr = "����"
   and idh_inv_nbr = "��Ʊ" AND idh_line = "���" :
    DISPLAY idh_nbr idh_inv_nbr  idh_part idh_line .
    DELETE idh_hist .
END.
