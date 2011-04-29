define temp-table temp1 
    field t1_wrnbr as integer  /*uniq*/
    field t1_wolot as char
    field t1_op    as integer 
    .



/*-------------------------------------------------------------��ֹǰ�湤������δ��,���湤��ķ�������*/

/*��¼�ѽ�����һ������*/
for each xxwrd_det 
    where xxwrd_close = yes 
    no-lock  :

    find first temp1 where t1_wrnbr = xxwrd_wrnbr  no-lock no-error.
    if not avail temp1 then do:
        create temp1.
        assign 
        t1_wrnbr = xxwrd_wrnbr 
        t1_wolot = xxwrd_wolot  
        t1_op = xxwrd_op . 
    end.
    else do:
        if t1_wolot > xxwrd_wolot or (t1_wolot = xxwrd_wolot and t1_op < xxwrd_op ) then do:
            assign  t1_wolot = xxwrd_wolot  
                    t1_op = xxwrd_op . 
        end.
    end.
end.

/*����֮ǰ�Ĺ�����*/
output to "xxxxclose.txt" .
    for each temp1 ,
        each xxwrd_det 
        where xxwrd_wrnbr = t1_wrnbr 
        and (
            xxwrd_wolot > t1_wolot or ( xxwrd_wolot = t1_wolot and xxwrd_op < t1_op)
        )
        and  xxwrd_close  = no :

            xxwrd_close = yes .  /*�Ѹ���MFGPRO*/

            put "������:" xxwrd_wonbr   
                " ����ID:" xxwrd_wolot 
                " ����:" xxwrd_op 
                " ������:" xxwrd_qty_ord 
                " �깤����:" xxwrd_qty_comp 
                " ��������:" xxwrd_qty_rej 
            skip.
        
    end.
output close .


/*-------------------------------------------------------------���¶�Ӧ�ķ������׼�¼��ֵ*/


for each xxwrd_det where xxwrd_close  = yes no-lock ,
    each xxfb_hist where xxfb_wolot = xxwrd_wolot and xxfb_op = xxwrd_op :
    xxfb_update = yes. /*�Ѹ���MFGPRO*/
end.