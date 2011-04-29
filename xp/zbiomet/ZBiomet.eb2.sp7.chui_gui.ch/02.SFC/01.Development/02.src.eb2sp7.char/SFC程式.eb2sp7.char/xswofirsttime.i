/* xswofirsttime.i  �����״�ˢ��,����SFC��������                              */
/* REVISION: 1.0         Last Modified: 2008/12/01   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/


find first xxwrd_det where xxwrd_wolot = v_wolot no-lock no-error .
if not avail xxwrd_det then do:

    /*��鹤����Ч��*/
    find first xwo_mstr where xwo_lot = v_wolot no-lock no-error.
    if not avail xwo_mstr then do:
        message "ָ���޷�ִ��:��ǰ����������"  view-as alert-box title ""  .
        undo,leave .
    end.
    else do:
        /*if index("R",xwo_status ) = 0 then do:
            message "ָ���޷�ִ��:��ǰ����״̬����" xwo_status  view-as alert-box title ""  .
            undo,leave .
        end. *//*xp-wo-stat*/
    end. 


    /*������׹���������:����Ʒ����������*/
    v_inv_lot = "" .
    for each xwo_mstr where xwo_nbr = v_wonbr no-lock break by xwo_nbr by xwo_lot :
        if first-of(xwo_nbr) then do:
            v_inv_lot = xwo_lot_next .
        end.        
    end.
    if v_inv_lot = "" then do:
        message "�ӹ�����Ʒ����Ϊ��,����ά��!"  view-as alert-box title ""  .
        undo,leave .
    end.

    /*���״�ˢ��Ϊ���׹���(��󹤵���־�ĵ�һ������)ʱ����*/
    define var v_firstwo as logical initial yes .
    define var v_firstwosn as char format "x(15)" .
    define temp-table xsfcwr 
        field xsfc_wonbr like xwr_nbr 
        field xsfc_wolot like xwr_lot
        field xsfc_op    like xwr_op .

    for each xsfcwr : delete xsfcwr . end.

    for each xwr_route 
        fields (xwr_nbr xwr_lot xwr_op)
        where xwr_nbr = v_wonbr 
        no-lock:
        
        find first xxwrd_det 
            where xxwrd_wolot = xwr_lot 
            and   xxwrd_op    = xwr_op 
            and   xxwrd_wonbr = xwr_nbr 
        no-lock no-error .
        if not avail xxwrd_det then do:
            create xsfcwr .
            assign xsfc_wonbr = xwr_nbr
                   xsfc_wolot = xwr_lot
                   xsfc_op    = xwr_op 
                   .
        end.
    end.

    for each xsfcwr where xsfc_wonbr = v_wonbr 
        break by xsfc_wonbr by xsfc_wolot by xsfc_op descending:
        if last-of(xsfc_wonbr) then do:
            if xsfc_wolot <> v_wolot or xsfc_op <> v_op then do:
                v_firstwo = no .
                v_firstwosn = xsfc_wolot + "+" + string(xsfc_op) .
            end .
        end.
    end.
    if v_firstwo = no then do:
        message "����:�׹���" v_firstwosn "��δ����." view-as alert-box title "".
        undo,leave  .
    end.
    



    /*ȡ������*/
    v_wrnbr = 0 .
    v_nbrtype =  "bcwrnbr" . /*xxwrd_det,����������*/
    run getnbr(input v_nbrtype ,output v_wrnbr) .


    /*��16.13.13 , ����SFC��������*/
    for each xsfcwr where xsfc_wonbr = v_wonbr ,
        each xwr_route where xwr_nbr = xsfc_wonbr  
        break by xwr_nbr by xwr_lot by xwr_op  :

        /*xwr__chr05 = v_wrnbr . *������,��xwr_route̫����ᱻɾ��,ȡ�������ֶ�*/
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
                    xxwrd_status   = "" /*������-��,����ɾ��-D,�����Ĺ���-N,��ֹ�Ĺ���-J */
                    xxwrd_opfinish = no /*�������*/
                    xxwrd_issok    = no /*�������,��ȫ����ԭ���ϵĹ���ID��ʹ���������*/
                    xxwrd_lastwo   = no 
                    xxwrd_lastop   = no 
                    .

            if last-of(xwr_lot)  then xxwrd_lastop  = yes . /*�ж��Ƿ�ÿ������ID�����һ������(ɾ,�ӹ����ҲҪ����) : xxwrd_lastop*/
            if v_wolot = xwr_lot then xxwrd_lastwo  = yes . /*�ж��Ƿ�ȫ����ԭ���ϵĹ���ID : xxwrd_lastwo*/
        end.
    end.

    message "�����״�ˢ��,SFC�����������̸������." .
end. /*if not avail xxwrd_det*/




/*���㵥λ����:
ɾ��op��ҲҪ���㵥λ����,
����op���������,ͬ���,���Բ�����
*/







