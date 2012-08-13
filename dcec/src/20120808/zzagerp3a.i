
if ih_inv_date <= inv_date1 
and ih_inv_date > inv_date1 - age_days[1] 
then do:
    agebe_amt[1] = agebe_amt[1] + idh_qty_inv * idh_price .
    end.
else if ih_inv_date <= inv_date1 - age_days[1] 
        and ih_inv_date > inv_date1 - age_days[2]
then do:
    agebe_amt[2] = agebe_amt[2] + idh_qty_inv * idh_price .
    end.
else if ih_inv_date <= inv_date1 - age_days[2]
        and ih_inv_date > inv_date1 - age_days[3]
 then do:
 agebe_amt[3] = agebe_amt[3] + idh_qty_inv * idh_price .
 end.
else if ih_inv_date <= inv_date1 - age_days[3]
        and ih_inv_date > inv_date1 - age_days[4]
        then do:
   agebe_amt[4] = agebe_amt[4] + idh_qty_inv * idh_price .     
        end.

else if ih_inv_date <= inv_date1 - age_days[4]
        and ih_inv_date > inv_date1 - age_days[5]
        then do:
        agebe_amt[5] = agebe_amt[5] + idh_qty_inv * idh_price .
        end.

