define var effdate as date .
define var vv as char initial ";" .
DEFINE VAR site AS CHAR .
define var v_file as char format "x(30)" initial "/home/mfg/trinv.txt"  .

update effdate label "��Ч����"  colon 20 site LABEL "�ص�" skip
     v_file  label "����ļ�"  colon 20 with frame a side-labels .

output to value(v_file) .
put unformatted "˵�� ;�����; ���� ;��� ; ���˵� ;tr��Ʊ;ʵ�ʷ�Ʊ;��Ʊ����" skip .
for each tr_hist  use-index tr_type where tr_type = "iss-so"
and tr_effdate >= effdate AND tr_site = site  AND tr_rmks <> "" :

  find last xxabs_mstr where xxabs_shipfrom = tr_site
  and xxabs_par_id = "s" + tr_ship_id
  and xxabs_order = tr_nbr and int(xxabs_line) = tr_line   no-lock no-error .
  if available xxabs_mstr then do:

    find last xxrqm_mstr where xxrqm_nbr = xxabs_nbr no-lock no-error .
    if available xxrqm_mstr   then do:
       /*
       tr_rmks = xxrqm_inv_nbr  .
       */
        IF  xxrqm_inv_nbr <> "" and xxrqm_inv_nbr <> tr_rmks THEN
        put unformatted "�ݲ�����-�����Ƕ�ο�Ʊԭ��" vv tr_trnbr vv tr_nbr vv tr_line vv tr_ship_id vv tr_rmks  vv xxrqm_inv_nbr skip .
        ELSE IF xxrqm_inv_nbr = "" and xxrqm_inv_nbr <> tr_rmks  THEN DO:
        
        put unformatted "tr�뿪Ʊ��¼��Ʊ��һ�¿������" vv tr_trnbr vv tr_nbr vv tr_line vv tr_ship_id vv tr_rmks  vv xxrqm_inv_nbr skip .
        END.

     end .
    else do:
      
      put unformatted  "û���ҵ���Ʊ��¼" vv  tr_trnbr vv  tr_nbr vv tr_line vv tr_ship_id vv tr_rmks skip .
      

    end .

  end .
else do:
   FIND FIRST ih_hist WHERE ih_nbr = tr_nbr AND ih_inv_nbr = tr_rmks NO-LOCK NO-ERROR .
   IF AVAILABLE ih_hist  THEN
  put unformatted  "û���ҵ���Ʊ��¼�������" vv  tr_trnbr vv  tr_nbr vv tr_line vv tr_ship_id vv tr_rmks vv vv ih_inv_date skip .
   ELSE
        put unformatted  "û���ҵ���Ʊ��¼�������" vv  tr_trnbr vv  tr_nbr vv tr_line vv tr_ship_id vv tr_rmks  skip .

end .

end .
output close .
