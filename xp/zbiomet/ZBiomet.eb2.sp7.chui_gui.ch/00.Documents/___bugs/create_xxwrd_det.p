/* "v_"��ͷ�Ķ��Ǳ���:
    
v_wonbr = ������.
v_wrnbr = wrnbr����ˮ��.
v_inv_lot = ��Ʒ����ID������.
v_wolot  = �׹��򹤵�ID.

*/

/*ȡsequence��ˮ�ŵķ�ʽ*/
v_wrnbr =  next-value(sfc_sq01) .
if v_wrnbr = 0 then v_wrnbr = next-value(sfc_sq01) .

    
    /*��16.13.13 , ����SFC��������*/

    for each xwr_route where xwr_nbr = v_wonbr  
        break by xwr_nbr by xwr_lot by xwr_op  :

        find first xxwrd_det where xxwrd_wolot = xwr_lot and xxwrd_op = xwr_op no-lock no-error .
        if not avail xxwrd_det then do:
            create  xxwrd_det .
            assign  xxwrd_wonbr    = xwr_nbr 
                    xxwrd_wolot    = xwr_lot
                    xxwrd_op       = xwr_op
                    xxwrd_part     = xwr_part 
                    xxwrd_wc       = xwr_wkctr /*Ĭ�ϵĹ�������(����)*/
                    xxwrd_opname   = xwr_desc 
                    xxwrd_wrnbr    = integer(v_wrnbr) 
                    xxwrd_qty_ord  = xwr_qty_ord
                    xxwrd_inv_lot  = v_inv_lot /*��С����ID������*/
                    xxwrd_qty_bom  = 1  /*Ĭ�ϵ�λ����Ϊ1*/
                    xxwrd_status   = "" /*������-��,����ɾ��-D,�����Ĺ���-N */
                    xxwrd_opfinish = no /*�������*/
                    xxwrd_issok    = no /*�������,��ȫ����ԭ���ϵĹ���ID��ʹ���������*/
                    xxwrd_lastwo   = no 
                    xxwrd_lastop   = no 
                    .

            if last-of(xwr_lot)  then xxwrd_lastop  = yes . /*�ж��Ƿ�ÿ������ID�����һ������(ɾ,�ӹ����ҲҪ����) : xxwrd_lastop*/
            if v_wolot = xwr_lot then xxwrd_lastwo  = yes . /*�ж��Ƿ�ȫ����ԭ���ϵĹ���ID : xxwrd_lastwo*/
        end.
    end.
