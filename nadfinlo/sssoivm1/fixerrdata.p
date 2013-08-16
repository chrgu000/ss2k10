/* 手工处理由于用标准程序过账造成客户化程序重复显示已过账发票的问题          */
for each abs_mstr exclusive-lock where abs_id begins 'i'
     and abs_order = "SO_NBR"
     and abs_item = "Part"
     and abs_ship_qty = shipqty:
display abs__qad02 abs_line abs_ship_qty abs__chr01.
assign abs__chr01 = "C".
end.

/*税错误调整*/
for each ar_mstr exclusive-lock where ar_batch  = "76310":
display ar_nbr ar_so ar_amt ar_base_amt.
/*
assign ar_amt = 65716.82
       ar_base_amt = 65716.82.
*/
for each ard_det exclusive-lock where ard_nbr = ar_nbr and ard_acct = "2171":
display ard_amt ard_cur_amt.
update ard_amt.
end.

for each tx2d_det exclusive-lock where tx2d_ref = ar_nbr:
display tx2d_tr_type tx2d_nbr tx2d_tax_amt format "->>>,>>9.9999"
tx2d_cur_tax_amt format "->>>,>>9.9999"
.
update tx2d_tax_amt tx2d_cur_tax_amt.
end.
end.


for each ar_mstr no-lock where ar_nbr = '22843811':
display ar_mstr with 2 columns.
/* assign ar_applied = 65716.82.   */
color display input ar_amt ar_applied.
for each ard_det exclusive-lock where ard_ref = ar_nbr:
display ard_det with 2 columns.
color display input  ard_amt.
/*
assign ard_amt = 65716.82.
*/
end.
end.
