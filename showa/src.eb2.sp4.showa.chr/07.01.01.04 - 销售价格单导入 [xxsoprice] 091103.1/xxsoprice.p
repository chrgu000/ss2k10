{mfdtitle.i "091103.1"}
define var v_file as char format "x(30)" .
define var v_update as logical .
define var v_qad22 as logical .
define var v_qad26 as logical .
define temp-table tt
field t1_nbr like so_nbr
field t1_line like sod_line
field t1_price like sod_price


.

FORM 
    v_file   LABEL "文件"
    v_update      LABEL "是否更新"
    SKIP
    "请按单号，项次，单价用逗号分隔导入"
    "导入完后请查看/home/mfg/temp目录中以soprice开头的文件"
    WITH FRAME a .

update v_file WITH FRAME a .

for each tt :
delete tt .
end .

input from value(v_file) .

repeat:
  create tt .
  import delimiter "," t1_nbr  t1_line t1_price   .
end .

output to "/home/mfg/temp/soprice daoru.txt"  .
for each tt no-lock :
  export delimiter "," tt .
end .

output close .

update v_update .

if v_update = yes then do:
  for each tt where  t1_nbr <> "" no-lock :
   FIND FIRST sod_det WHERE sod_nbr = t1_nbr AND sod_line = t1_line NO-ERROR .
   IF AVAILABLE sod_det THEN 
	      assign
	           
		    sod_list_pr = t1_price
		    sod_price = t1_price
            .
	  
  end .

   output to "/home/mfg/temp/soprice daoru ok.txt"  .
   for each tt where t1_nbr <> "" no-lock :
    FIND FIRST sod_det NO-LOCK WHERE sod_nbr = t1_nbr AND sod_line = t1_line NO-ERROR .
   IF AVAILABLE sod_det THEN 
     export delimiter "," sod_nbr  sod_line sod_list_pr sod_price   .
   END.
    output close .
  
   output to "/home/mfg/temp/soprice daoru error.txt"  .
   for each tt where t1_nbr <> "" no-lock :
  FIND FIRST sod_det  NO-LOCK WHERE sod_nbr = t1_nbr AND sod_line = t1_line NO-ERROR .
   IF NOT AVAILABLE sod_det THEN 
     export delimiter "," tt .
   END.
    output close .

end .
