/* create by roger 090707.1: print the list of invoice approved */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 090707.1 By: Roger Xiao */


v_ii = 0 .
for each temp1 where t1_ok = yes no-lock,
    each ih_hist  where ih_inv_nbr  = t1_inv_nbr and ih_nbr  = t1_nbr no-lock,
    each idh_hist where idh_inv_nbr = ih_inv_nbr and idh_nbr = ih_nbr no-lock
    break by t1_line by idh_inv_nbr by idh_nbr by idh_line 
    with frame xxx1 width 132:
        
        net_price = idh_price .
        run get-price (input-output net_price , input idh_tax_in , input ih_tax_date , input idh_taxc) .
        ext_price =  net_price * idh_qty_inv.   


        v_ii = v_ii + 1 .
        disp 
            v_ii          label "��" format ">>9"
            idh_inv_nbr   label "��Ʊ��"
            idh_nbr       label "�ͻ�����"
            idh_line      label "��" format ">>9"
            idh_part      label "���Ϻ�"
            idh_um        label "UM"
            idh_qty_inv   label "��Ʊ����"
            net_price     label "�۸�"
            ext_price     label "���"
            ih_userid     label "������"
            ih__dte01     label "��������"
        with frame xxx1. 

        if v_print then do:
            {mfrpexit.i}
        end.
end. /*for each temp1*/