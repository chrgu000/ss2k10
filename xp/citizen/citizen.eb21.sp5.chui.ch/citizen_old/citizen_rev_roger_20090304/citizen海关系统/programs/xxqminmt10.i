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
define {1} shared var v_bk_type as char initial "IMP" . 


define {1} shared var v_amt like xxipr_amt .
define {1} shared var v_nbr as char .
define {1} shared var v_line  as integer format ">>9" .
define {1} shared var v_qty_b1 like prh_rcvd .
define {1} shared var v_qty_b2 like prh_rcvd .
define {1} shared var v_error as char format "x(18)".
define {1} shared var v_um_conv like xxccpt_um_conv initial 1 .
define {1} shared var v_curr like po_curr initial "USD".
define {1} shared  var v_recid like recno  .

define {1} shared temp-table temp 
    field t_nbr  like prh_receiver 
    field t_line as integer format ">>9" label "��"
    field t_ponbr like prh_nbr
    field t_vend  like prh_vend
    field t_rcp_date as date label "�ջ�����" 
    field t_part     like prh_part 
    field t_cu_ln    as integer format ">>>9" label "��"
    field t_cu_part  like xxcpt_cu_part label "��Ʒ����"
    field t_ctry     like xxccpt_ctry 
    field t_um       like prh_um
    field t_um_conv1  like prh_um_conv
    field t_um_conv2  like xxccpt_um_conv
    field t_rcvd     like prh_rcvd /*prh_rcvd - prh__dec01*/
    field t_yn       as logical initial yes .


define {1} shared  frame h1 .
define {1} shared  frame h2 .
define {1} shared  frame d1. 
define {1} shared  frame d2.  
define {1} shared  frame d3. 




form
    space(1)
    v_nbr                  label "�걨����"  
    xxipr_date             label "��������" 
    xxipr_req_date         label "�걨����"  
    v_add                  label "�Զ�"
    skip
    space(1)
    xxipr_bar_code      label "��ʽ����" 
    xxipr_bk_nbr        label "�����ֲ�" colon 50
    v_all               label "ȫ��"     colon 66
with frame h1  side-labels width 80 attr-space.


form
    SKIP(.2)    

xxipr_dept           label "���ڿڰ�"   colon 13 xxipr_box_num        label "����"  colon 50        
xxipr_loc            label "����/����"  colon 13 xxipr_gross          label "����(KG)"  colon 50
xxipr_car            label "���ڳ��ƺ�" colon 13 xxipr_amt            label "���"  colon 50
xxipr_driver         label "˾����"     colon 13 xxipr_curr           label "�ұ�"  colon 50 
xxipr_ship_nbr       label "�ػ��嵥��" colon 13 xxipr_stat           label "״̬"  colon 50
xxipr_license        label "���֤��"   colon 13 
xxipr_rmks1          label "��ע"       colon 13    format "x(60)" 
with frame h2  side-labels width 80 attr-space.


form
    v_line           label "��" 
    xxiprd_rct_nbr   label "�ջ�����"
    xxiprd_rct_ln    label "��"
    xxiprd_rct_order label "�ɹ���"
    xxiprd_rct_part  label "�����"
    xxiprd_um        label "UM"
    xxiprd_rct_qty   label "�ջ�����"
with frame d1  width 80 attr-space.



form
    xxiprd_rct_date  label "�ջ�����"     colon 13
    xxiprd_cu_part   label "��Ʒ����"     colon 13 xxiprd_ctry      label "ԭ����"   colon 45  
    xxiprd_cu_ln     label "��Ʒ��"       colon 13 xxcpt_desc       label "Ʒ��"   
    xxiprd_cu_um     label "���ص�λ"     colon 13 xxiprd_um_conv   label "��λ��������"   colon 45  
    xxiprd_price     label "����"         colon 13     
    xxiprd_cu_qty    label "��������"     colon 13 xxiprd_stat      label "����״̬"     colon 45  
    xxiprd_amt       label "���"         colon 13 xxiprd_used      label "��ת����"   colon 45     

with frame d2  side-labels  width 80 attr-space.

form
    space(1)
    xxipr_nbr           label "�걨����"  
    xxipr_bar_code      label "��ʽ����" 
    xxipr_bk_nbr        label "�����ֲ�" 
with frame d3  side-labels width 80 attr-space.