{mfdtitle.i "091103.1"}
define var v_file as char format "x(30)" .
define var v_update as logical .
define var v_qad22 as logical .
define var v_qad26 as logical .
DEFINE VAR v_lable AS CHAR FORMAT "x(20)" .
define temp-table tt
field t1_nbr like pod_nbr
field t1_line like pod_line
field t1_pur_cost like pod_pur_cost


.

FORM 
    v_file   LABEL "文件"
    v_update      LABEL "是否更新"
    SKIP
    "请按单号，项次，单价用逗号分隔导入"
    "导入完后请查看/home/mfg/temp目录中以poprice开头的文件"
    WITH FRAME a .

update v_file WITH FRAME a  .

for each tt :
delete tt .
end .

input from value(v_file) .

repeat:
  create tt .
  import delimiter "," t1_nbr  t1_line t1_pur_cost   .
end .



output to "/home/mfg/temp/poprice daoru.txt"  .
for each tt WHERE t1_nbr <> "" no-lock :
  export delimiter "," tt .
end .

output close .

OUTPUT TO "/home/mfg/temp/poprice yuanshi.txt"  .
 for each tt where  t1_nbr <> "" no-lock :
   FIND FIRST pod_det NO-LOCK WHERE pod_nbr = t1_nbr AND pod_line = t1_line NO-ERROR .
   IF AVAILABLE pod_det THEN 
	    EXPORT DELIMITER "," pod_nbr pod_line pod_pur_cost pod__qad02 pod__qad09 .
         
      
  end .
OUTPUT CLOSE .

update v_update WITH FRAME a .

if v_update = yes then do:
  for each tt where  t1_nbr <> "" no-lock :
   FIND FIRST pod_det WHERE pod_nbr = t1_nbr AND pod_line = t1_line NO-ERROR .
   IF AVAILABLE pod_det THEN 
	      assign
	         
             pod_pur_cost = t1_pur_cost
		     pod__qad09 = t1_pur_cost * (1 - (pod_disc_pct / 100))
               pod__qad02 = (t1_pur_cost * (1 - (pod_disc_pct / 100))
               - pod__qad09) * 100000
		   
            .
	  
  end .

   output to "/home/mfg/temp/poprice daoru ok.txt"  .
   for each tt where t1_nbr <> "" no-lock :
    FIND FIRST pod_det NO-LOCK WHERE pod_nbr = t1_nbr AND pod_line = t1_line NO-ERROR .
   IF AVAILABLE pod_det THEN 
     export delimiter "," pod_nbr  pod_line  pod_pur_cost   .
   END.
    output close .
  
   output to "/home/mfg/temp/poprice daoru error.txt"  .
   for each tt where t1_nbr <> "" no-lock :
  FIND FIRST pod_det NO-LOCK WHERE pod_nbr = t1_nbr AND pod_line = t1_line NO-ERROR .
   IF NOT AVAILABLE pod_det THEN 
     export delimiter "," tt .
   END.
    output close .

end .
