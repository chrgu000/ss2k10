
/* ע������ȵ�һ���·��Ƿ�Ϊ1 �����꣬�»�����Ҫ���¼��㣬���Ҳ���ͳ�� */

define var v_cost like cph_tot_sale .
define var v_sale like cph_tot_sale .
define var v_qty like cph_tot_qty .
define var v_file as char format "x(30)" initial "/home/mfg/cph4.txt"  .
define var v_effdate as date .
define var v_effdate1 as date .
define var v_month as int .
DEFINE VAR v_part LIKE pt_part .
DEFINE VAR v_comp LIKE ld_qty_oh .

DEFINE VAR v_std LIKE sod_price .
DEFINE VAR v_price LIKE sod_price .

update v_effdate label "��Ч����" colon 20  v_effdate1 label "��" colon 45 skip
       v_part LABEL "���" COLON 20 SKIP 
     v_file  label "����ļ�"  colon 20 with frame a side-labels .

output to value(v_file) .

PUT UNFORMATTED "�ͻ�;����;��Ʊ;��Ч����;��Ʊ����" SKIP .

for each  ar_mstr where ar_effdate >= v_effdate and ar_effdate <= v_effdate1 no-lock,
 each ih_hist use-index ih_inv_nbr where  ih_inv_nbr  = ar_nbr NO-LOCK   :

   
    IF ar_effdate <> ih_inv_date THEN
    EXPORT DELIMITER ";" ih_cust ih_ship  ih_inv_nbr   ar_effdate ih_inv_date  .

  
end .



output close .





