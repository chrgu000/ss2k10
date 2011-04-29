/* xs                                                 */
/* REVISION: 1.0         Last Modified: 2008/12/01   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/

/*{mfdeclre.i}*/    /*mfgpro global vars & functions*/
/*{gplabel.i}*/     /*mfgpro externalized label include */
{xsmf002var01.i }  /*all shared vars  defines here */
{xsfbchk001.i}  /*反馈前的,变量定义及相关检查*/

/*非cell机器,前工序未完成则本工序不允许开始*/
{xstimecell01.i}

/*检查是否被暂停的用户,机器,工单,*/
/*之前需有v_tail_wc  {xstimetail01.i} or {xsfbchk001.i} */
{xstimepause01.i}

define var v_xxx as logical initial no . /*盘点临时程式*/


form
    skip(1)
    v_wolot       colon 18 label "工单标志"
    v_op          colon 45 label "工序" 
    v_part        colon 18 label "完成品"  
    xpt_desc1      colon 45 label "品名"
    xpt_um         colon 18 label "单位"
    xpt_desc2      colon 45 label "规格"
    skip(1)
    v_qty_ord2    colon 18 label "订购量"
    v_inv_lot     colon 45 label "批号"
    v_qty_comp    colon 18 label "已合格数"
    v_qty_rjct    colon 45 label "已报废数"
    v_qty_rework  colon 18 label "累计返工(件次)"
    v_qty_return  colon 18 label "返工完成(件次)"
    skip(1)       
    v_qty_now     colon 18 label "本次完工合格"

    v_xxx         colon 18 label "关闭工单"    "     <---盘点临时程式" /*盘点临时程式*/

    skip(5)
with frame a 
title color normal "工单盘点:合格反馈"
side-labels width 80 .   


hide all no-pause .
view frame a .

mainloop:
repeat :
    
    do  on error undo,retry: /*update_loop*/
        clear frame a no-pause .
        v_qty_now     = 0 .
        rejreason     = "" . 
        rwkreason     = "" . 


        {xsfbchk002.i} /*取数量等的默认值:前工序,本工序,下工序*/
        
        disp v_qty_ord2 v_qty_comp v_qty_rjct v_qty_rework v_qty_return v_part v_inv_lot v_wolot v_op with frame a .
        find first xpt_mstr where xpt_part = v_part no-lock no-error .
        if avail xpt_mstr then disp xpt_um xpt_desc1 xpt_desc2 with frame a .
        

        find first xxwrd_det 
            where xxwrd_wrnbr = integer(v_wrnbr)
            and xxwrd_wolot   = v_wolot 
            and xxwrd_op      = v_op 
            and (xxwrd_status = "" or xxwrd_status  = "N" )
            and xxwrd_close   = no
        exclusive-lock no-wait no-error .
        if not avail xxwrd_det then do:
            if locked xxwrd_det then do:
                message  "工单条码正在被使用,按任意键退出" view-as alert-box title "" .
                undo,leave mainloop.
            end.
        end.

        update v_qty_now 
        v_xxx   /*盘点临时程式*/
        with frame a .
        {xsfbchk002.i} /*防止其他机器也在反馈此工单,重新再找一遍,以便找最新数据*/
        
        {xserr001.i "v_qty_now" } /*检查数量栏位是否输入了问号*/


        if v_qty_now = 0 then do:
            message "合格数量不可为零.请重新输入" .
            undo,retry .
        end. /**/

        if v_qty_rework - v_qty_return > 0 then do:
            message "是否返工件完工合格?" update v_yn3 .
        end.

        if v_qty_now > 0 then do:
            
            /*仅首工序的数量不受任何限制*/
            if  v_prev = yes then do:
                if (v_qty_now + v_qty_comp + v_qty_rjct) * v_qty_bom > v_qty_prev then do:
                    message "累计数量不可超过前工序(" v_prev_wolot "+" v_prev_op ")合格量("  v_qty_prev  ")请重新输入" .
                    undo,retry .
                end.

                if v_qty_now + v_qty_comp + v_qty_rjct > v_qty_ord2 then do:
                    message "累计数量不可超过订购量("  v_qty_ord2  ")请重新输入" .
                    undo,retry .
                end.
            end.

            if v_qty_now + v_qty_comp + v_qty_rjct > v_qty_ord2 * (v_tol_pct / 100 ) then do:
                message "数量超限,请重新输入" .
                undo,retry .
            end.
            
            if v_yn3 = yes then do:
                if v_qty_rework - v_qty_return < v_qty_now then do:
                    message "不可超过返工未完成数量(" (v_qty_rework - v_qty_return) "),请重新输入" .
                    undo,retry .
                end.                      
            end.

        end. /*if v_qty_now > 0 */

        if v_qty_now < 0 then do:
            if (v_qty_comp  < - v_qty_now)  then do:
                message "不可超过已合格数量,请重新输入" .
                undo,retry .
            end.

            if v_next = yes and (v_qty_now + v_qty_comp ) < v_qty_next * v_next_bom then do:
                message "累计数量不可少于后工序(" v_next_wolot "+" v_next_op ")完成量("  v_qty_next  ")请重新输入" .
                undo,retry .
            end.

            if v_yn3 = yes then do: 
                if v_qty_return < - v_qty_now then do:
                    message "不可超过返工完成数量(" v_qty_return "),请重新输入" .
                    undo,retry .
                end.                       
            end.

        end. /*if v_qty_now < 0 */

        /*if v_lastwo and v_lastop then do:*/
        if v_lastwo and v_prev = no and v_sub = no then do:    
            v_yn1 = no .
            message "是否工序完成?" update v_yn1 .
            v_yn2 = yes .
            message "是否有退料?" update v_yn2 .
        end. /*if v_laswo and v_lastop*/
        
        /*外协工序自动认为工序完成,且无退料*/
        if v_sub then assign v_yn1 = yes v_yn2 = no .

        {xsfbsubwo01.i} /*v_sub:外协工单刷读送检单*/

    end. /*update_loop*/
    


/*  start ---------------------------------------------------------------------------------------*/  

v_date   = today.
v_time   = time - (time mod 60) . /*保证时间点一致*/
v_msgtxt = "" .   /*提示信息*/

/*更新:  前笔指令*/
do  :  /*xxfb_prev*/
    {xslnprev01.i}
end.  /*xxfb_prev*/


/*更新:本次指令*/
do  :  /*xxfb*/

    /*改本次反馈工序的数量*/
    find first xxwrd_Det 
        where xxwrd_wrnbr = integer(v_wrnbr) 
        and xxwrd_wolot   = v_wolot
        and xxwrd_op      = v_op 
        and (xxwrd_status = "" or xxwrd_status  = "N" )
        and xxwrd_close   = no 
    exclusive-lock no-error .
    if avail xxwrd_det then do:

            assign xxwrd_qty_comp = xxwrd_qty_comp + v_qty_now .

            if v_yn3 then do:
                xxwrd_qty_return = xxwrd_qty_return + v_qty_now .
            end.

            if v_xxx then xxwrd_close = yes .  /*盘点临时程式*/

    end. /*if avail xxwrd_det*/


    /*首工序:更新本工单ID的(本工序,及所有后续工序)的 xxwrd_opfinish & xxwrd_issok */
    if v_lastwo and v_prev = no then do:
        for each xxwrd_det  
            where xxwrd_wrnbr  = integer(v_wrnbr)
            and xxwrd_wonbr    = v_wonbr 
            and (xxwrd_wolot   = v_wolot and xxwrd_op      >=  v_op)
            and (xxwrd_status  = "" or xxwrd_status  = "N" )
            and xxwrd_close    = no 
            :

            xxwrd_opfinish = if v_yn1 = yes then yes else no .
            xxwrd_issok    = if v_yn2 = no  then yes else no  .
            /*有退料则,退料完成时,提问"所有材料全部退料完成?" ,yes --> xxwrd_issok = yes */
        end. /*for each xxwrd_det*/        
    end. /*if v_lastwo and v_prev = no*/

    
    if v_prev = no and v_yn1 = yes and v_qty_now > 0 then do:
            /*首工序(v_prev = no) ,完工后(v_yn1 = yes): 更新所有后续工序的订购数量:*/
            find first xxwrd_Det 
                where xxwrd_wrnbr = integer(v_wrnbr) 
                and xxwrd_wolot   = v_wolot
                and xxwrd_op      = v_op 
                and (xxwrd_status = "" or xxwrd_status  = "N" )
                and xxwrd_close   = no 
            no-lock no-error .
            v_qty_ord2 = if avail xxwrd_det then xxwrd_qty_comp else 0 .

            for each xxwrd_det  
                where xxwrd_wrnbr = integer(v_wrnbr)
                and xxwrd_wonbr   = v_wonbr 
                and ((xxwrd_wolot   = v_wolot and xxwrd_op      > v_op)
                    or
                    (xxwrd_wolot < v_wolot)
                    ) 
                and (xxwrd_status = "" or xxwrd_status  = "N" )
                and xxwrd_close   = no 
                break by xxwrd_wonbr by xxwrd_wolot by xxwrd_op
                :

                if xxwrd_qty_bom = 0 then xxwrd_qty_bom = 1 . /*biomet,单位用量默认都是1 */
                xxwrd_qty_ord = v_qty_ord2 / xxwrd_qty_bom . /*本工序订购量*/

                v_qty_ord2 = xxwrd_qty_ord - xxwrd_qty_rejct .   /*下工序供应量(订购量*单位用量)*/

            end. /*for each xxwrd_det*/  
            
        /*
        find first xcode_mstr where xcode_fldname = v_fld_cell and xcode_value = v_wc no-lock no-error .
        if avail xcode_mstr then do: /*cell机器*/
        end. /*cell机器*/
        else do: /*not_cell机器*/
        end. /*not_cell机器*/ 
        */
    end. /*if v_prev = no*/

    find first xwo_mstr where xwo_lot = v_wolot no-lock no-error.
    find first xcode_mstr where xcode_fldname = v_fldname and xcode_value = v_line no-lock no-error.

    v_trnbr = 0 .
    v_nbrtype =  "bctrnbr" . /*xxfb_hist,交易流水号*/
    run getnbr(input v_nbrtype ,output v_trnbr) .

    create  xxfb_hist .
    assign  xxfb_trnbr       = integer(v_trnbr) 
            xxfb_date        = today  
            xxfb_date_end    = v_date  
            xxfb_date_start  = v_date  
            xxfb_time        = time - (time mod 60)  
            xxfb_time_end    = v_time  
            xxfb_time_start  = v_time   
            xxfb_nbr         = "" 
            xxfb_program     = execname
            xxfb_wotype      = if v_yn3 then "R" else ""   
            xxfb_qty_fb      = v_qty_now   
            xxfb_rmks        = ""   
            xxfb_rsn_code    = ""  
            xxfb_user        = v_user
            xxfb_user2       = v_user2
            xxfb_op          = v_op  
            xxfb_wc          = v_wc  
            xxfb_wolot       = v_wolot  
            xxfb_wonbr       = v_wonbr 
            xxfb_part        = if avail xwo_mstr then xwo_part else ""   
            xxfb_type        = v_line  
            xxfb_type2       = if avail xcode_mstr and xcode_cmmt <> ""  then entry(1,xcode_cmmt,"@") else "" 
            xxfb_update      = no  
            .

            if v_sub then xxfb_rmks = xxfb_rmks  + "送检单:" + v_sub_nbr  .

    v_msgtxt = v_msgtxt + xxfb_type2 + ":指令完成" .
end.  /*xxfb*/

/*  end ---------------------------------------------------------------------------------------*/  


leave .
end. /*mainloop:*/

hide frame a no-pause .
