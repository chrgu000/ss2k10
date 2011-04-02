define buffer trhist for tr_hist.
define variable wrec like tr_lot.
define variable waddr like tr_addr.
define variable kk as char format "x(2)".
define temp-table tmp_file
       field tmp_rec	like tr_lot
       field tmp_part	like tr_part
       field tmp_desc1	like pt_desc1
       field tmp_addr   like tr_addr
       field tmp_serial like tr_serial
       field tmp_qty_loc like tr_qty_loc
       index tmp_rec tmp_rec ASCENDING.


for each tmp_file:
delete tmp_file.
end.
for each tr_hist where tr_type ="ISS-TR" and tr_date = 08/04/05 and tr_loc = "HM0001" use-index tr_date_trn no-lock, 
    each pt_mstr where pt_part = tr_part and ( pt_prod_line = "0100" or    pt_prod_line = "0200" or
         pt_prod_line = "0300" or pt_prod_line = "0400" or pt_prod_line = "0500" or pt_prod_line = "0600" or 
	 pt_prod_line = "0640" )  no-lock:
wrec = "".
waddr = "".

find first trhist where  (  trhist.tr_serial = tr_hist.tr_serial and length(trhist.tr_serial) = 13 or trhist.tr_lot = substring(tr_hist.tr_nbr ,1,8) ) 
     and trhist.tr_type ="RCT-PO" and trhist.tr_part = tr_hist.tr_part  no-lock no-error .

if available trhist then do:
   wrec = trhist.tr_lot.
   waddr = trhist.tr_addr.

end.



create tmp_file.
assign  
       tmp_rec		= wrec
       tmp_part		= tr_hist.tr_part 
       tmp_desc1	= pt_desc1 
       tmp_addr		= waddr
       tmp_serial	= tr_hist.tr_serial 
       tmp_qty_loc	= tr_hist.tr_qty_loc * -1 .


end.

for each tmp_file , each prh_hist where tmp_rec = prh_receiver no-lock :
display kk		column-label ""
        tmp_rec		column-label "RM單編號"
        tmp_part	column-label "零件"
	tmp_desc1       column-label "描述"
	tmp_addr	column-label "供應商"
	tmp_serial      column-label "LOT #"
	tmp_qty_loc	column-label "數量"
	prh_rev		column-label "版本"
	"             " column-label "檢查結果"
	"             " column-label "備注"
	"             " column-label "簽名" 
	kk		column-label ""
	skip(1)
	with width 200.
	if kk ="" then kk = "**" else kk = "".
end.