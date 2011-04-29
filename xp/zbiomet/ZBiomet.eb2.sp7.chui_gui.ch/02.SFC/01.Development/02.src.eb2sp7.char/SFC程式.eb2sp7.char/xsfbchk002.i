/* xsfbchk002.i ����ǰ,ȡ�����ȵ�Ĭ��ֵ:ǰ����,������,�¹���               */
/* REVISION: 1.0         Last Modified: 2008/12/11   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/



/*************
1.called by �ϸ�,����,����
2.to check ȡ�����ȵ�Ĭ��ֵ:ǰ����,������,�¹���

************/ 
        
        
find first xxwrd_det 
    where xxwrd_wrnbr = integer(v_wrnbr)
    and xxwrd_wolot   = v_wolot 
    and xxwrd_op      = v_op 
    and (xxwrd_status = "" or xxwrd_status  = "N" )
    and xxwrd_close   = no
no-lock no-error .
if avail xxwrd_Det then do: /*������*/
                      
        v_qty_bom     = xxwrd_qty_bom .
        v_qty_rework  = xxwrd_qty_rework .
        v_qty_return  = xxwrd_qty_return .
        v_qty_ord2    = xxwrd_qty_ord  .
        v_qty_comp    = xxwrd_qty_comp .
        v_qty_rjct    = xxwrd_qty_rejct .
        v_qty_check   = xxwrd_qty_check .
        v_part        = xxwrd_part .
        v_inv_lot     = xxwrd_inv_lot .
        v_lastwo      = xxwrd_lastwo .
        v_lastop      = xxwrd_lastop .
        v_yn3         = if xxwrd_qty_rework - xxwrd_qty_return > 0 then yes else no .


        
        v_ii = 0 .     /*ǰ����*/
        for each xxwrd_det 
            where xxwrd_wrnbr = integer(v_wrnbr) 
            and xxwrd_wonbr   = v_wonbr
            and ((xxwrd_wolot   = v_wolot and xxwrd_op      < v_op)
                or
                (xxwrd_wolot > v_wolot)
                )
            and (xxwrd_status = "" or xxwrd_status  = "N" or xxwrd_status = "J" ) 
        no-lock 
        break by xxwrd_wonbr by xxwrd_wolot  by xxwrd_op descending:
            if first-of(xxwrd_wonbr) then do:   
                v_prev_wolot = xxwrd_wolot .
                v_prev_op    = xxwrd_op .
                v_prev_part  = xxwrd_part .
                v_qty_prev   = xxwrd_qty_comp .
                v_prev       = yes .
            end.
            v_ii = v_ii + 1 .
            if v_ii >= 1 then leave .
        end.   /*ǰ����*/

        v_ii = 0 .    /*�¹���*/
        for each xxwrd_det 
            where xxwrd_wrnbr = integer(v_wrnbr) 
            and xxwrd_wonbr   = v_wonbr
            and ((xxwrd_wolot   = v_wolot and xxwrd_op      > v_op)
                or
                (xxwrd_wolot < v_wolot)
                )
            and (xxwrd_status  = "" or xxwrd_status  = "N" )
        no-lock 
        break by xxwrd_wonbr by xxwrd_wolot descending by xxwrd_op :
            if first-of(xxwrd_wonbr) then do:   
                v_next_wolot = xxwrd_wolot .
                v_next_op    = xxwrd_op .
                v_next_part  = xxwrd_part .
                v_qty_next   = xxwrd_qty_comp + xxwrd_qty_rejct.
                v_next       = yes .
            end.
            v_ii = v_ii + 1 .
            if v_ii >= 1 then leave .
        end.  /*�¹���*/
/*  
message "prev_wo&op:" v_prev_wolot v_prev_op v_qty_prev  view-as alert-box .
message "next_wo&op:" v_next_wolot v_next_op v_qty_next  view-as alert-box .
*/
end.  /*������*/