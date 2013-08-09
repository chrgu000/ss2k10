define var effdate as date .
define var vv as char initial ";" .
define var v_file as char format "x(30)" initial "/home/mfg/idh1.txt"  .

update effdate label "��Ч����" colon 20 skip
     v_file  label "����ļ�"  colon 20 with frame a side-labels .

output to value(v_file) .
put unformatted "˵��;��Ʊ ; ���� ;��� ;�����" skip .

for each ih_hist use-index ih_inv_date where ih_inv_date >= effdate no-lock ,
each idh_hist where idh_inv_nbr = ih_inv_nbr and idh_nbr = ih_nbr :

   
    find last xxrqm_mstr where xxrqm_inv_nbr = idh_inv_nbr no-lock no-error .
    if available xxrqm_mstr   then do:

   find last xxabs_mstr where xxabs_shipfrom = idh_site
       and xxabs_nbr = xxrqm_nbr 
        and xxabs_order = idh_nbr and int(xxabs_line) = idh_line no-lock no-error .
  if not available xxabs_mstr then do:

   
       
       put unformatted "����ɾ��" vv idh_inv_nbr vv idh_nbr  vv idh_line vv   xxrqm_nbr  skip  .
       
        delete idh_hist   .
       
    end .
    

  end .
   else do:
    put unformatted "error û���ҵ���Ʊ��Ʊ��¼" vv idh_inv_nbr vv   idh_nbr vv idh_line skip  .
    end .

end .
output close .