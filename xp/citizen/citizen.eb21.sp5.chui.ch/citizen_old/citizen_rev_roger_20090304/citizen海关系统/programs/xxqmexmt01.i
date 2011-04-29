define {1} shared var del-yn   as logical initial no .
define {1} shared var leave-yn as logical initial no .
define {1} shared var new_add as logical initial no .
define {1} shared var detail_add as logical initial no .
define {1} shared var v_all   as logical initial yes .
define {1} shared var v_add   as logical initial yes .
define {1} shared variable info_correct  like mfc_logical no-undo.
define {1} shared  var v_round1 as decimal .
define {1} shared  var v_round2 as integer .



v_round1 = 0.00001.
v_round2 = 5 .
define {1} shared var v_bk_type as char initial "OUT" . 

define {1} shared var v_abs_id like abs_id .
define {1} shared var v_amt like xxepr_amt .
define {1} shared var v_nbr as char .
define {1} shared var v_line  as integer format ">>9" .
define {1} shared var v_qty_b1 like prh_rcvd .
define {1} shared var v_qty_b2 like prh_rcvd .
define {1} shared var v_error as char format "x(18)".
define {1} shared var v_um_conv like xxccpt_um_conv initial 1 .
define {1} shared var v_curr like po_curr initial "USD".
define {1} shared  var v_recid like recno  .

define {1} shared temp-table temp 
    field t_nbr  as char format "x(10)"
    field t_line as integer format ">>9" label "��"
    field t_ponbr like prh_nbr
    field t_vend  like prh_vend
    field t_rcp_date as date label "��������" 
    field t_part     like prh_part 
    field t_cu_ln    as integer format ">>>>>9" label "��Ʒ��"
    field t_cu_part  like xxcpt_cu_part label "��Ʒ����"
    field t_ctry     like xxccpt_ctry 
    field t_um       like prh_um
    field t_um_conv1  like prh_um_conv
    field t_um_conv2  like xxccpt_um_conv
    field t_rcvd     like prh_rcvd /*prh_rcvd - prh__dec01*/
    field t_yn       as logical initial yes format "Y/N".


define {1} shared  frame h1 .
define {1} shared  frame h2 .
define {1} shared  frame d1. 
define {1} shared  frame d2.  
define {1} shared  frame d3. 




form
    space(1)
    v_nbr                  label "�걨����"  
    xxepr_date             label "��������" 
    xxepr_req_date         label "�걨����"  
    v_add                  label "�Զ�"
    skip
    space(1)
    xxepr_bar_code      label "��ʽ����" 
    xxepr_bk_nbr        label "�����ֲ�" colon 50
    v_all               label "ȫ��"     colon 66
with frame h1  side-labels width 80 attr-space.


form
    SKIP(.2)    

xxepr_dept           label "���ڿڰ�"   colon 13 xxepr_box_num        label "����"  colon 50        
xxepr_loc            label "����/����"  colon 13 xxepr_gross          label "����(KG)"  colon 50
xxepr_car            label "���ڳ��ƺ�" colon 13 xxepr_amt            label "���"  colon 50
xxepr_driver         label "˾����"     colon 13 xxepr_curr           label "�ұ�"  colon 50 
xxepr_ship_nbr       label "�ػ��嵥��" colon 13 xxepr_stat           label "״̬"  colon 50
xxepr_license        label "���֤��"   colon 13 
xxepr_rmks1          label "��ע"       colon 13    format "x(60)" 
with frame h2  side-labels width 80 attr-space.


form
    v_line           label "��" 
    xxeprd_iss_nbr   label "���˵���"
    xxeprd_iss_ln    label "��"
    xxeprd_iss_order label "���۵�"
    xxeprd_iss_part  label "�����"
    xxeprd_um        label "UM"
    xxeprd_iss_qty   label "������"
with frame d1  width 80 attr-space.



form
    xxeprd_iss_date  label "��������"     colon 13
    xxeprd_cu_part   label "��Ʒ����"     colon 13 xxeprd_ctry      label "ԭ����"   colon 45  
    xxeprd_cu_ln     label "��Ʒ��"       colon 13 xxcpt_desc       label "Ʒ��"   
    xxeprd_cu_um     label "���ص�λ"     colon 13 xxeprd_um_conv   label "��λ��������"   colon 45  
    xxeprd_price     label "����"         colon 13     
    xxeprd_cu_qty    label "��������"     colon 13 xxeprd_stat      label "����״̬"     colon 45  
    xxeprd_amt       label "���"         colon 13 xxeprd_used      label "��ת����"   colon 45     

with frame d2  side-labels  width 80 attr-space.

form
    space(1)
    xxepr_nbr           label "�걨����"  
    xxepr_bar_code      label "��ʽ����" 
    xxepr_bk_nbr        label "�����ֲ�" 
with frame d3  side-labels width 80 attr-space.