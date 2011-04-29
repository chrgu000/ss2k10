define {1} shared var v_bk_type as char initial "OUT" . 
define {1} shared var v_form_type as char initial "4" . 



define {1} shared var del-yn   as logical initial no .
define {1} shared var leave-yn as logical initial no .
define {1} shared var new_add as logical initial no .
define {1} shared var detail_add as logical initial no .
define {1} shared var v_all   as logical format "Y/N"  initial yes .
define {1} shared var v_add   as logical format "Y/N"  initial yes .
define {1} shared variable info_correct  like mfc_logical no-undo.
define {1} shared  var v_round1 as decimal .
define {1} shared  var v_round2 as integer .



v_round1 = 0.00001.
v_round2 = 5 .


define {1} shared var v_abs_id like abs_id .
define {1} shared var v_amt like xxexp_amt .
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
    field t_cu_ln    as integer format ">>>>>9" label "��"
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
    v_nbr                  label "���ص���"  
    xxexp_iss_date         label "��������" colon 58     
    v_add                  label "�Զ�"     colon 74
    skip
    space(1)     
    xxexp_bk_nbr        label "�����ֲ�" 
    xxexp_req_date      label "�걨����"    colon 58  
    v_all               label "ȫ��"        colon 74
with frame h1  side-labels width 80 attr-space.



form
    xxexp_cu_nbr       label "���ر��"    colon 13 xxexp_pre_nbr      label "Ԥ¼����"  colon 45   
    xxexp_dept         label "���ڿڰ�"    colon 13 xxexp_from         label "���˵�"      colon 45  
    xxexp_ship_via     label "���䷽ʽ"    colon 13 xxexp_to           label "Ŀ�ĵ�"      colon 45  
    xxexp_ship_tool    label "���乤��"    colon 13 xxexp_port         label "װ����"      colon 45  
    xxexp_bl_nbr       label "���˵�"      colon 13 xxexp_fob          label "�ɽ���ʽ"    colon 45  
    xxexp_trade_mtd    label "ó�׷�ʽ"    colon 13 xxexp_box_num      label "����"        colon 45  
    xxexp_tax_mtd      label "��������"    colon 13 xxexp_tax_rate     label "��˰����"    colon 45  
    xxexp_box_type     label "��װ����"    colon 13 xxexp_net          label "����"        colon 45  
    xxexp_license      label "���֤��"    colon 13 xxexp_gross        label "ë��"        colon 45  
    xxexp_appr_nbr     label "��׼�ĺ�"    colon 13 xxexp_curr         label "�ұ�"        colon 45  
    xxexp_contract     label "��ͬЭ���"  colon 13 xxexp_amt          label "���"        colon 45 
    xxexp_container    label "��װ���"    colon 13 xxexp_stat         label "״̬"        colon 45 
    xxexp_rmks1        label "��ͷ"        colon 13 xxexp_use          label "��;"        colon 45  
    xxexp_rmks2        label "��ע"        colon 13                                               
with frame h2 side-labels width 80 attr-space .   



form
    v_line           label "��" 
    xxexpd_iss_nbr   label "���˵���"
    xxexpd_iss_ln    label "��"
    xxexpd_iss_order label "���۵�"
    xxexpd_iss_part  label "�����"
    xxexpd_um        label "UM"
    xxexpd_iss_qty   label "������"
with frame d1  width 80 attr-space.



form
    xxexpd_iss_date  label "��������"     colon 13
    xxexpd_cu_part   label "��Ʒ����"     colon 13 xxexpd_ctry      label "ԭ����"   colon 45  
    xxexpd_cu_ln     label "��Ʒ��"       colon 13 xxcpt_desc       label "Ʒ��"   
    xxexpd_cu_um     label "���ص�λ"     colon 13 xxexpd_um_conv   label "��λ��������"   colon 45  
    xxexpd_price     label "����"         colon 13     
    xxexpd_cu_qty    label "��������"     colon 13 xxexpd_stat      label "����״̬"     colon 45  
    xxexpd_amt       label "���"         colon 13 xxexpd_used      label "��ת����"   colon 45     

with frame d2  side-labels  width 80 attr-space.

form
    space(1)
    xxexp_nbr           label "���ص���"   
    xxexp_bk_nbr        label "�����ֲ�" 
with frame d3  side-labels width 80 attr-space.