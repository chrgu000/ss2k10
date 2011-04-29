define temp-table temp1 
    field t1_wrnbr as integer  /*uniq*/
    field t1_wolot as char
    field t1_op    as integer 
    .



/*-------------------------------------------------------------防止前面工单工序未结,后面工序的反而结了*/

/*记录已结的最后一道工序*/
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

/*所有之前的工序结掉*/
output to "xxxxclose.txt" .
    for each temp1 ,
        each xxwrd_det 
        where xxwrd_wrnbr = t1_wrnbr 
        and (
            xxwrd_wolot > t1_wolot or ( xxwrd_wolot = t1_wolot and xxwrd_op < t1_op)
        )
        and  xxwrd_close  = no :

            xxwrd_close = yes .  /*已更新MFGPRO*/

            put "工单号:" xxwrd_wonbr   
                " 工单ID:" xxwrd_wolot 
                " 工序:" xxwrd_op 
                " 订购量:" xxwrd_qty_ord 
                " 完工数量:" xxwrd_qty_comp 
                " 报废数量:" xxwrd_qty_rej 
            skip.
        
    end.
output close .


/*-------------------------------------------------------------更新对应的反馈交易记录的值*/


for each xxwrd_det where xxwrd_close  = yes no-lock ,
    each xxfb_hist where xxfb_wolot = xxwrd_wolot and xxfb_op = xxwrd_op :
    xxfb_update = yes. /*已更新MFGPRO*/
end.