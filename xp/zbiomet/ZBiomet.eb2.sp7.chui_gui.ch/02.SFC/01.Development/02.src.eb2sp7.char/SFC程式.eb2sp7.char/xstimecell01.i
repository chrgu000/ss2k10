/* xstimecell01.i ��cell����,ǰ����δ����򱾹�������ʼ                */
/* REVISION: 1.0         Last Modified: 2008/12/22   By: Roger   No ECO:   */
/*-Revision end------------------------------------------------------------*/



define var v_fld_cell  like xcode_fldname .  v_fld_cell = v_fldname + "-cell-mch" .
define var v_prev_opok as logical format "Y/N".   v_prev_opok = no .  
define var v_prev_sn1  as char format "x(20)" .   v_prev_sn1 = "" .
run cellok( output v_prev_opok , output v_prev_sn1 ) .
if v_prev_opok = no then do:
    message "ǰ����δ���:" v_prev_sn1 ",����������ʼ. " 
    view-as alert-box title "" .
    undo,leave .
end.




procedure cellok :
    define output parameter  v_opok     as logical . /*�������Ƿ���Կ�ʼ*/
    define output parameter  v_prev_sn1 as char no-undo .  /*ǰ���������*/

        
/************
0.��cell�Ļ�����������ж�(ǰ�����Ƿ����v_opok ),����cell����v_opok = yes .
1.��cell�Ļ���,û��ǰ����,��v_opok = yes

(�׹���:��󹤵�ID�����OP)
2.��cell�Ļ���,��ǰ�����ҷ��׹���,��ǰ�������������,��v_opok = yes
3.��cell�Ļ���,��ǰ�����ҷ��׹���,��ǰ��������δ���,��v_opok = no
4.��cell�Ļ���,��ǰ���������׹���,��
    4.1 ���v_opfinish = yes ��v_opok = yes
    4.2 ���v_opfinish = no  �� (�Զ�����ǰ������,�ĺ�������OP���������,��v_opok = yes)
************/ 



    define var v_jj         as integer .
    define var v_prevwo       as logical .  /*�Ƿ���ǰ����*/
    define var v_qty_ok     as logical .  /*�Ƿ�ǰ�������깤*/
    define var v_opfinish   as logical .  /*�Ƿ����깤*/
    define var v_prevwo_wolot as char .
    define var v_prevwo_op    as integer .
    define var v_lastwo2   as logical  format "x(18)".
    define var v_lastop2   as logical .

    v_prevwo_wolot = "" .
    v_prevwo_op    = 0  .
    v_qty_ok       = no .
    v_prevwo       = no .
    v_opok         = no . 
    v_prev_sn1     = "" .
    v_opfinish     = no .


    find first xcode_mstr where xcode_fldname = v_fld_cell and xcode_value = v_wc no-lock no-error .
    if avail xcode_mstr then do: /*cell����*/
        v_opok = yes .
    end. /*cell����*/
    else do: /*not_cell����*/
        v_jj = 0 .     /*ǰ����*/
        v_lastwo2 = no .
        v_lastop2 = no . 
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
                v_prevwo_wolot = xxwrd_wolot .
                v_prevwo_op    = xxwrd_op .
                v_prevwo     = yes .
                v_lastwo2     = xxwrd_lastwo .
                v_lastop2     = xxwrd_lastop .

                v_qty_ok     = (xxwrd_qty_comp + xxwrd_qty_rejct >= xxwrd_qty_ord ) .
                v_opfinish   = xxwrd_opfinish .
            end.
            v_jj = v_jj + 1 .
            if v_jj >= 1 then leave .
        end.   /*ǰ����*/

        if v_prevwo = no then v_opok = yes .
        else do:
                find first xxwrd_det 
                    where xxwrd_wrnbr = integer(v_wrnbr) 
                    and xxwrd_wonbr   = v_wonbr
                    and ((xxwrd_wolot   = v_prevwo_wolot and xxwrd_op      < v_prevwo_op)
                        or
                        (xxwrd_wolot > v_prevwo_wolot)
                        )
                    and (xxwrd_status = "" or xxwrd_status  = "N" or xxwrd_status = "J" ) 
                no-lock no-error.
                if not avail xxwrd_det then do:  /*���׹���*/
                    /*if v_opfinish = no then do: */

                        /*������ID���������,��Ϊ�����Ķ�����*/
                        v_qty_ord2 = 0 .
                        find first xxwrd_Det 
                            where xxwrd_wrnbr = integer(v_wrnbr) 
                            and xxwrd_wolot   = v_prevwo_wolot
                            and xxwrd_op      = v_prevwo_op 
                            and (xxwrd_status = "" or xxwrd_status  = "N" or xxwrd_status = "J" )
                            and xxwrd_close   = no 
                        no-error .
                        if avail xxwrd_Det then do:
                            xxwrd_opfinish = yes .
                            v_opfinish     = yes . /*ǰ�������*/
                            v_qty_ord2     = xxwrd_qty_comp  . /*�¹���Ӧ��(������*��λ����)*/
                        end.

                        if v_qty_ord2 = 0 then do:
                            message "�׹���(" v_prevwo_wolot "+" v_prevwo_op ")δ���ϸ���������." view-as alert-box title "" .
                            v_prev_sn1 = v_prevwo_wolot + "+" + string(v_prevwo_op) .
                            undo,leave .
                        end.
                        
                        /*������ID����๤��,���������Ϊyes*/
                        for each xxwrd_det  
                            where xxwrd_wrnbr  = integer(v_wrnbr)
                            and xxwrd_wonbr    = v_wonbr 
                            and (xxwrd_wolot   = v_prevwo_wolot and xxwrd_op      >=  v_prevwo_op)
                            and (xxwrd_status = "" or xxwrd_status  = "N" or xxwrd_status = "J" )
                            and xxwrd_close    = no 
                            :

                            xxwrd_opfinish = yes  .
                        end. /*for each xxwrd_det*/ 

                        /*�޸����к�������Ķ�����*/
                        for each xxwrd_det  
                            where xxwrd_wrnbr = integer(v_wrnbr)
                            and xxwrd_wonbr   = v_wonbr 
                            and ((xxwrd_wolot   = v_prevwo_wolot and xxwrd_op      > v_prevwo_op)
                                or
                                (xxwrd_wolot < v_prevwo_wolot)
                                ) 
                            and (xxwrd_status = "" or xxwrd_status  = "N" or xxwrd_status = "J" )
                            and xxwrd_close   = no 
                            break by xxwrd_wonbr by xxwrd_wolot by xxwrd_op
                            :
                            if xxwrd_qty_bom = 0 then xxwrd_qty_bom = 1 . /*biomet,��λ����Ĭ�϶���1 */
                            xxwrd_qty_ord = v_qty_ord2 / xxwrd_qty_bom . /*�����򶩹���*/

                            v_qty_ord2 = xxwrd_qty_ord - xxwrd_qty_rejct .   /*�¹���Ӧ��(������*��λ����)*/

                            if xxwrd_status = "J" then xxwrd_qty_comp = v_qty_ord2. /*��ֹ�Ĺ���,���ٷ���,�����Զ��޸��������*/

                        end. /*for each xxwrd_det*/
                    /*end. */

                    v_opok = yes. 

                end. /*if not avail xxwrd_det*/
                else do: /*if avail xxwrd_det*/
                    v_opok = if v_qty_ok = yes then yes  else no .
                    v_prev_sn1 = v_prevwo_wolot + "+" + string(v_prevwo_op) .
                end. /*if avail xxwrd_det*/
            
        end.
    end.  /*not_cell����*/

end procedure. /*cellok*/
