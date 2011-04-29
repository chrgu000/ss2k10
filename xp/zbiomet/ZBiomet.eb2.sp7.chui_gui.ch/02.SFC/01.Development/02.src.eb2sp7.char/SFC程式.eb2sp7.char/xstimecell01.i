/* xstimecell01.i 非cell机器,前工序未完成则本工序不允许开始                */
/* REVISION: 1.0         Last Modified: 2008/12/22   By: Roger   No ECO:   */
/*-Revision end------------------------------------------------------------*/



define var v_fld_cell  like xcode_fldname .  v_fld_cell = v_fldname + "-cell-mch" .
define var v_prev_opok as logical format "Y/N".   v_prev_opok = no .  
define var v_prev_sn1  as char format "x(20)" .   v_prev_sn1 = "" .
run cellok( output v_prev_opok , output v_prev_sn1 ) .
if v_prev_opok = no then do:
    message "前工序未完成:" v_prev_sn1 ",本工序不允许开始. " 
    view-as alert-box title "" .
    undo,leave .
end.




procedure cellok :
    define output parameter  v_opok     as logical . /*本工序是否可以开始*/
    define output parameter  v_prev_sn1 as char no-undo .  /*前工序的条码*/

        
/************
0.非cell的机器才做这个判断(前工序是否完成v_opok ),所以cell机器v_opok = yes .
1.非cell的机器,没有前工序,则v_opok = yes

(首工序:最大工单ID的最后OP)
2.非cell的机器,有前工序且非首工序,且前工序数量已完成,则v_opok = yes
3.非cell的机器,有前工序且非首工序,但前工序数量未完成,则v_opok = no
4.非cell的机器,有前工序且是首工序,则
    4.1 如果v_opfinish = yes 则v_opok = yes
    4.2 如果v_opfinish = no  则 (自动结束前工序反馈,改后续所有OP的完成数量,且v_opok = yes)
************/ 



    define var v_jj         as integer .
    define var v_prevwo       as logical .  /*是否有前工序*/
    define var v_qty_ok     as logical .  /*是否前工序已完工*/
    define var v_opfinish   as logical .  /*是否工序完工*/
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
    if avail xcode_mstr then do: /*cell机器*/
        v_opok = yes .
    end. /*cell机器*/
    else do: /*not_cell机器*/
        v_jj = 0 .     /*前工序*/
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
        end.   /*前工序*/

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
                if not avail xxwrd_det then do:  /*是首工序*/
                    /*if v_opfinish = no then do: */

                        /*本工单ID的完成数量,作为后续的订购量*/
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
                            v_opfinish     = yes . /*前工序完成*/
                            v_qty_ord2     = xxwrd_qty_comp  . /*下工序供应量(订购量*单位用量)*/
                        end.

                        if v_qty_ord2 = 0 then do:
                            message "首工序(" v_prevwo_wolot "+" v_prevwo_op ")未做合格数量反馈." view-as alert-box title "" .
                            v_prev_sn1 = v_prevwo_wolot + "+" + string(v_prevwo_op) .
                            undo,leave .
                        end.
                        
                        /*本工单ID如果多工序,则后续都改为yes*/
                        for each xxwrd_det  
                            where xxwrd_wrnbr  = integer(v_wrnbr)
                            and xxwrd_wonbr    = v_wonbr 
                            and (xxwrd_wolot   = v_prevwo_wolot and xxwrd_op      >=  v_prevwo_op)
                            and (xxwrd_status = "" or xxwrd_status  = "N" or xxwrd_status = "J" )
                            and xxwrd_close    = no 
                            :

                            xxwrd_opfinish = yes  .
                        end. /*for each xxwrd_det*/ 

                        /*修改所有后续工序的订购量*/
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
                            if xxwrd_qty_bom = 0 then xxwrd_qty_bom = 1 . /*biomet,单位用量默认都是1 */
                            xxwrd_qty_ord = v_qty_ord2 / xxwrd_qty_bom . /*本工序订购量*/

                            v_qty_ord2 = xxwrd_qty_ord - xxwrd_qty_rejct .   /*下工序供应量(订购量*单位用量)*/

                            if xxwrd_status = "J" then xxwrd_qty_comp = v_qty_ord2. /*终止的工序,不再反馈,所以自动修改完成数量*/

                        end. /*for each xxwrd_det*/
                    /*end. */

                    v_opok = yes. 

                end. /*if not avail xxwrd_det*/
                else do: /*if avail xxwrd_det*/
                    v_opok = if v_qty_ok = yes then yes  else no .
                    v_prev_sn1 = v_prevwo_wolot + "+" + string(v_prevwo_op) .
                end. /*if avail xxwrd_det*/
            
        end.
    end.  /*not_cell机器*/

end procedure. /*cellok*/
