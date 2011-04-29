define {1} shared var v_bk_type as char initial "IMP" . 
define {1} shared var v_form_type as char initial "2" . 
define {1} shared var v_sl_type like xxsl_type format "1-ת��ת��/2-ת��ת��" initial yes  .
define {1} shared var v_vend like po_vend  .

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



define {1} shared var v_amt like xximp_amt .
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

define {1} shared temp-table temp2
    field t2_sl_nbr   like xxsld_nbr
    field t2_sl_line  like xxsld_line 
    field t2_cu_ln    like xxcpt_ln
    field t2_bk_nbr   like xxcbk_bk_nbr 
    .



define {1} shared  frame h1 .
define {1} shared  frame h2 .
define {1} shared  frame d1. 
define {1} shared  frame d2.  
define {1} shared  frame d3. 




form
    space(1)
    v_nbr                  label "���ص���"  
    xximp_sl_nbr           label "�ط��"
    xximp_rct_date         label "��������" colon 58    
    v_add                  label "�Զ�"     colon 74
    skip
    space(1)     
    xximp_bk_nbr        label "�����ֲ�" 
    xximp_req_date      label "�걨����"    colon 58
    v_all               label "ȫ��"        colon 74
with frame h1  side-labels width 80 attr-space.


form
    xximp_cu_nbr       label "���ر��"    colon 13 xximp_pre_nbr      label "Ԥ¼����"  colon 45   
    xximp_dept         label "���ڿڰ�"    colon 13 xximp_from         label "���˵�"      colon 45  
    xximp_ship_via     label "���䷽ʽ"    colon 13 xximp_to           label "Ŀ�ĵ�"      colon 45  
    xximp_ship_tool    label "���乤��"    colon 13 xximp_port         label "װ����"      colon 45  
    xximp_bl_nbr       label "���˵�"      colon 13 xximp_fob          label "�ɽ���ʽ"    colon 45  
    xximp_trade_mtd    label "ó�׷�ʽ"    colon 13 xximp_box_num      label "����"        colon 45  
    xximp_tax_mtd      label "��������"    colon 13 xximp_tax_rate     label "��˰����"    colon 45  
    xximp_box_type     label "��װ����"    colon 13 xximp_net          label "����"        colon 45  
    xximp_license      label "���֤��"    colon 13 xximp_gross        label "ë��"        colon 45  
    xximp_appr_nbr     label "��׼�ĺ�"    colon 13 xximp_curr         label "�ұ�"        colon 45  
    xximp_contract     label "��ͬЭ���"  colon 13 xximp_amt          label "���"        colon 45 
    xximp_container    label "��װ���"    colon 13 xximp_stat         label "״̬"        colon 45 
    xximp_rmks1        label "��ͷ"        colon 13 xximp_use          label "��;"        colon 45  
    xximp_rmks2        label "��ע"        colon 13                                               
with frame h2 side-labels width 80 attr-space .   


form
    v_line           label "��" 
    xximpd_rct_nbr   label "�ջ�����"
    xximpd_rct_ln    label "��"
    xximpd_rct_order label "�ɹ���"
    xximpd_rct_part  label "�����"
    xximpd_um        label "UM"
    xximpd_rct_qty   label "�ջ�����"
with frame d1  width 80 attr-space.



form
    xximpd_rct_date  label "�ջ�����"     colon 13
    xximpd_cu_part   label "��Ʒ����"     colon 13 xximpd_ctry      label "ԭ����"   colon 45  
    xximpd_cu_ln     label "��Ʒ��"       colon 13 xxcpt_desc       label "Ʒ��"   
    xximpd_cu_um     label "���ص�λ"     colon 13 xximpd_um_conv   label "��λ��������"   colon 45  
    xximpd_price     label "����"         colon 13     
    xximpd_cu_qty    label "��������"     colon 13 xximpd_stat      label "����״̬"     colon 45  
    xximpd_amt       label "���"         colon 13 xximpd_used      label "��ת����"   colon 45     

with frame d2  side-labels  width 80 attr-space.

form
    space(1)
    xximp_nbr           label "���ص���"  
    xximp_bk_nbr        label "�����ֲ�" 
with frame d3  side-labels width 80 attr-space.