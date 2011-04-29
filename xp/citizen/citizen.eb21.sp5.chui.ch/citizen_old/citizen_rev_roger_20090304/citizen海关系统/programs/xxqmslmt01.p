/* xxqmslmt01.p 海关关封维护                                     */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      LAST MODIFIED: 2008/03/28   BY: Softspeed roger xiao    */
/*-Revision end---------------------------------------------------------------*/



/* DISPLAY TITLE */
{mfdtitle.i "1+ "}


define var v_nbr as char format "x(8)" .
define var v_type like xxsl_type format "1-转厂转入/2-转厂转出" initial yes  .
define var v_from as char format "x(8)" .
define var v_to as char format "x(8)" .
define var del-yn like mfc_logical initial no.
define var v_new like mfc_logical initial no.
define var v_line like xxsld_line .
define var v_desc like pt_desc1 .
define var v_bk_nbr like xxcbkd_bk_nbr .
define var v_bk_type like xxcbkd_bk_type .
define var v_bk_ln  like xxcbkd_bk_ln .

define var v_bk_from   like xxcbkd_bk_nbr.
define var v_bk_to     like xxcbkd_bk_nbr.

define var v_qty_old1  like xxcbkd_qty_io .
define var v_qty_rst   like xxcbkd_qty_io .

define new shared frame a.
define new shared frame b.
define new shared frame ship_from.
define new shared frame ship_to.
define frame d1 .
define frame d2 .


form
    space(1)
    v_nbr                 label "关封编号" 
    v_type                label "转厂类型"
    v_from                label "转自"  
    v_to                  label "转入"  
    skip 
with frame a  side-labels width 80 attr-space.
{mfadform.i "ship_from" 1 ship_from}
{mfadform.i "ship_to" 41  ship_to}

form
    SKIP(.2)
    xxsl_date          label "维护日期"  colon 13
    xxsl_start         label "生效日期"  colon 13
    xxsl_expire        label "截止日期"  colon 13
    xxsl_stat          label "状态"     colon 13
with frame b  side-labels width 80 attr-space.

form
    v_line  label "项" 
    xxsld_cu_ln label "序号"
    xxsld_cu_part label "商品编号"
    xxsld_cu_um   label "UM"
    xxsld_price    label "单价"
    xxsld_qty_ord  label "关封数量"
with frame d1  width 80 attr-space.


form
    v_desc           label "品名"        colon 13 
    xxsld_bk_from    label "转出手册"    colon 13    
    xxsld_bk_to      label "转入手册"    colon 13
    xxsld_qty_used   label "已转厂数量"  colon 13 
    xxsld_stat       label "状态"        colon 13    
    xxsld_rmks       label "备注"        colon 13 
    skip(1)


   /* "转出                          转入 " colon 13 
    xxsld_bk_from        label "手册号"    colon 13    xxsld_bk_to          label "手册号"    colon 45
    xxsld_bk_ln_from     label "手册项"    colon 13    xxsld_bk_ln_to       label "手册项"    colon 45 */

with frame d2  side-labels  width 80 attr-space.

/* DISPLAY */


find first poc_ctrl where poc_domain = global_domain no-error.
if not avail poc_ctrl then do:
create poc_ctrl . 
assign poc_domain = global_domain .
end.


mainloop:
repeat with frame a :
    ststatus = stline[1].
    status input ststatus.
/*
    hide frame a no-pause.
    hide frame d1 no-pause.
    hide frame d2 no-pause.
    hide frame ship_from no-pause.
    hide frame ship_to no-pause.
    hide frame b no-pause. 
*/
    view frame a.
    view frame ship_from .
    view frame ship_to .
    view frame b .
    v_new = no .
    prompt-for v_nbr with frame a editing:
         if frame-field = "v_nbr" then do:    
             {mfnp01.i xxsl_mstr v_nbr  xxsl_nbr  xxsl_domain global_domain xxsl_nbr }

             if recno <> ? then do:
                v_nbr = xxsl_nbr .
                v_type = xxsl_type .
                v_from = xxsl_addr_from.
                v_to   = xxsl_addr_to .
                disp  v_nbr v_type v_from v_to with frame a .
                disp  xxsl_date xxsl_start xxsl_expire xxsl_stat with frame b .
                {mfaddisp.i v_from ship_from}
                {mfaddisp.i v_to   ship_to}
             end . /* if recno <> ? then  do: */
         end.
         else do:
                   status input ststatus.
                   readkey.
                   apply lastkey.
         end.
    end. /* PROMPT-FOR...EDITING */
    assign v_nbr v_type v_from v_to .

    
    if v_nbr = "" then do:
        message "关封号不允许为空" .
        undo,retry.
    end.


    find first xxsl_mstr where xxsl_domain = global_domain and xxsl_nbr = v_nbr  no-error .
    if avail xxsl_mstr then do:
        if xxsl_stat = "C" then do:
            message "关封已结,请重新输入" .
            undo,retry .
        end.

        v_nbr = xxsl_nbr .
        v_type = xxsl_type .
        v_from = xxsl_addr_from.
        v_to   = xxsl_addr_to .
        disp  v_nbr v_type v_from v_to with frame a .
        disp  xxsl_date xxsl_start xxsl_expire xxsl_stat with frame b .
        {mfaddisp.i v_from ship_from}
        {mfaddisp.i v_to   ship_to}
    end.
    
    loopa:
    do on error undo , retry:
        find first xxsl_mstr where xxsl_domain = global_domain and xxsl_nbr = v_nbr no-error .
        if not avail xxsl_mstr then do:

            clear frame ship_from no-pause .
            clear frame ship_to no-pause .
            clear frame b no-pause .

            update v_type with frame a .
            find first poc_ctrl where poc_domain = global_domain no-lock no-error.
            v_to   = if ( avail poc_ctrl and  v_type = yes /*转入*/) then poc_ship else "" . 
            v_from = if ( avail poc_ctrl and  v_type = no  /*转出*/) then poc_ship else "" .
            create xxsl_mstr .
            assign 
                xxsl_domain = global_domain 
                xxsl_nbr = v_nbr 
                xxsl_type = v_type
                xxsl_addr_from = v_from
                xxsl_addr_to   = v_to 
                xxsl_date      = today
                xxsl_start     = today
                v_new = yes 
                .
            {mfmsg.i 1 1}


            disp  v_nbr v_type v_from v_to with frame a .
            {mfaddisp.i v_from ship_from}
            {mfaddisp.i v_to   ship_to}

        end. /*if not avail xxsl_mstr*/  
        if v_new = no then do:
           {mfmsg.i 10 1}
        end.
        
        prompt-for  v_from when( v_type = yes )  
                    v_to when( v_type = no )
        with frame a editing:
             if frame-field = "v_from" then do:    
                 {mfnp01.i vd_mstr v_from  vd_addr  vd_domain global_domain vd_addr }
                 if recno <> ? then do:
                    v_from = vd_addr .
                    disp  v_nbr v_type v_from v_to with frame a . 
                    {mfaddisp.i v_from ship_from}
                    {mfaddisp.i v_to   ship_to}
                 end . /* if recno <> ? then  do: */
             end.
             else if frame-field = "v_to" then do:
                 {mfnp01.i vd_mstr v_to  vd_addr  vd_domain global_domain vd_addr }
                 if recno <> ? then do:
                    v_to = vd_addr .
                    disp  v_nbr v_type v_from v_to with frame a .
                    {mfaddisp.i v_from ship_from}
                    {mfaddisp.i v_to   ship_to}
                 end . /* if recno <> ? then  do: */
             end.
             else do:
                       status input ststatus.
                       readkey.
                       apply lastkey.
             end.
        end. /* PROMPT-FOR...EDITING */
        assign v_from when( v_type = yes )  
               v_to when( v_type = no ) .
        assign xxsl_addr_from = v_from
               xxsl_addr_to   = v_to .

        for first ad_mstr  
            where ad_mstr.ad_domain = global_domain
            and  ad_addr = v_from  no-lock:
        end.   
        if not avail ad_mstr then do:
            message "错误:无效转出公司请重新输入" .
            next-prompt v_from.
            undo,retry .
        end.

        for first ad_mstr  
            where ad_mstr.ad_domain = global_domain
            and  ad_addr = v_to  no-lock:
        end.   
        if not avail ad_mstr then do:
            message "错误:无效转入公司请重新输入" .
            next-prompt v_to.
            undo,retry .
        end.

        disp  v_nbr v_type v_from v_to with frame a .
        disp  xxsl_date xxsl_start xxsl_expire xxsl_stat with frame b .
        {mfaddisp.i v_from ship_from}
        {mfaddisp.i v_to   ship_to}

        loopb:
        do on error undo , retry:
            update  xxsl_start xxsl_expire xxsl_stat 
            go-on("F5" "CTRL-D")
            with frame b editing :
                readkey.
                if  lastkey = keycode("F5")
                    or lastkey = keycode("CTRL-D")
                then do:   /*a*/
                    find first xxsld_Det 
                        where xxsld_domain = global_domain 
                        and xxsld_nbr = xxsl_nbr 
                        and (xxsld_qty_use <> 0 or xxsld_stat <> "" )
                    no-error .
                    if avail xxsld_det then do:
                        message "错误:存在已开始转厂或已结项次,不允许删除" .
                        undo,retry .                        
                    end.
                    else do:
                        if xxsl_stat <> "" then do:
                            message "错误:关封已结,不允许删除" .
                            undo,retry .  
                        end.
                        else do:
                            del-yn = yes.            
                            {mfmsg01.i 11 1 del-yn}
                            if del-yn then do:                  
                                for each xxsld_det where xxsld_domain = global_domain and xxsld_nbr = xxsl_nbr :                                    
                                    delete xxsld_det .
                                end.
                                delete xxsl_mstr.

                                clear frame a no-pause .
                                clear frame ship_from no-pause .
                                clear frame ship_to no-pause .
                                clear frame b no-pause .
                                del-yn = no.
                                next mainloop .
                            end.
                        end.
                    end.
                end.  /*a*/
                else apply lastkey.
            end. /* editing :*/
            if v_new then do:
                if xxsl_start < today or xxsl_start = ? then do:
                    message "生效日期不能小于今天" .
                    undo ,retry .
                end.

                if xxsl_expire < today then do:
                    message "截止日期不能小于今天" .
                    undo ,retry .
                end.
            end.
            
        end. /*loopb*/
        hide frame a no-pause.
        hide frame ship_from no-pause.
        hide frame ship_to no-pause.
        hide frame b no-pause.

        find first xxsld_det where xxsld_domain = global_domain and xxsld_nbr = v_nbr no-error .
        if avail xxsld_det then assign v_bk_from = xxsld_bk_from v_bk_to = xxsld_bk_to .


        loopd:
        repeat :
            view frame a .
            view frame d1 .
            view frame d2 .
            clear frame d1 no-pause.
            clear frame d2 no-pause.
            

            v_line  = 1 .
            find last xxsld_det where xxsld_domain = global_domain and xxsld_nbr = v_nbr no-error .
            if avail xxsld_det then v_line  = xxsld_line + 1 .
            disp v_line with frame d1 .

            prompt-for v_line with frame d1 editing:
                if frame-field = "v_line" then do:
                    {mfnp01.i xxsld_det v_line  xxsld_line  v_nbr "xxsld_domain = global_domain and xxsld_nbr" xxsld_nbr }
                    if recno <> ? then do:
                        v_line = xxsld_line .
                        find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxsld_cu_ln no-lock no-error.
                        v_desc = if avail xxcpt_mstr then xxcpt_desc else "" .

                        disp v_line xxsld_cu_ln  xxsld_cu_part  xxsld_cu_um xxsld_price xxsld_qty_ord with frame d1 .
                        disp v_desc xxsld_qty_used xxsld_stat xxsld_rmks  xxsld_bk_from xxsld_bk_to /*xxsld_bk_ln_from  xxsld_bk_ln_to*/    with frame d2 .
                    end . /* if recno <> ? then  do: */
                end.
                else do:
                    status input ststatus.
                    readkey.
                    apply lastkey.
                end.
            end. /*prompt-for v_line*/
            assign v_line  .

            if v_line = 0 then do:
                message "错误:不允许项为0" .
                undo,retry.
            end.

            find first xxsld_det where xxsld_domain = global_domain and xxsld_nbr = v_nbr and xxsld_line = v_line  no-error .
            if avail xxsld_det then do:
                v_line = xxsld_line .
                find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = xxsld_cu_ln no-lock no-error.
                v_desc = if avail xxcpt_mstr then xxcpt_desc else "" .
                disp v_line xxsld_cu_ln  xxsld_cu_part  xxsld_cu_um xxsld_price xxsld_qty_ord with frame d1 .
                disp v_desc xxsld_qty_used xxsld_stat xxsld_rmks  xxsld_bk_from xxsld_bk_to  with frame d2 .
            end.

            loope:
            do on error undo , retry:
                find first xxsld_det where xxsld_domain = global_domain and xxsld_nbr = v_nbr and xxsld_line = v_line no-error .
                if not avail xxsld_det then do:
                    {mfmsg.i 1 1}
                    clear frame d1 no-pause.
                    clear frame d2 no-pause.
                    disp v_line with frame d1 .
                    create xxsld_det .
                    assign 
                        xxsld_domain = global_domain
                        xxsld_nbr    = v_nbr 
                        xxsld_line   = v_line.

                    prompt-for xxsld_cu_ln with frame d1 editing:
                        if frame-field = "xxsld_cu_ln" then do:
                            {mfnp01.i xxcpt_mstr xxsld_cu_ln  xxcpt_ln  xxcpt_domain  global_domain xxcpt_ln}
                            if recno <> ? then do:
                                v_desc = xxcpt_desc .

                                disp v_line xxcpt_ln @ xxsld_cu_ln xxcpt_cu_part @ xxsld_cu_part xxcpt_um @ xxsld_cu_um xxcpt_price @ xxsld_price xxsld_qty_ord with frame d1 .
                                disp v_desc xxsld_qty_used xxsld_stat xxsld_rmks  xxsld_bk_from /*xxsld_bk_ln_from  xxsld_bk_ln_to */ xxsld_bk_to  with frame d2 .
                            end . /* if recno <> ? then  do: */
                        end.
                        else do:
                            status input ststatus.
                            readkey.
                            apply lastkey.
                        end.
                    end. /*prompt-for xxsld_cu_ln*/ 

                    find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = input xxsld_cu_ln no-lock no-error.
                    if not avail xxcpt_mstr then do:
                        message "错误:无效公司序号".
                        undo,retry.
                    end.
                    else do:
                        xxsld_cu_ln = xxcpt_ln .
                        xxsld_cu_um = xxcpt_um .
                        xxsld_cu_part = xxcpt_cu_part .
                        xxsld_price   = xxcpt_price .
                        v_desc = xxcpt_desc .

                        disp v_line xxsld_cu_ln  xxsld_cu_part  xxsld_cu_um xxsld_price xxsld_qty_ord with frame d1 .
                        disp v_desc xxsld_qty_used xxsld_stat xxsld_rmks  xxsld_bk_from /*xxsld_bk_ln_from  xxsld_bk_ln_to*/  xxsld_bk_to  with frame d2 .
                    end.

                    loopf:
                    do on error undo , retry:
                        v_bk_nbr = "" .
                        v_bk_type = "" .
                        v_bk_ln  = 0 .                      
                        xxsld_bk_from = v_bk_from .
                        xxsld_bk_to = v_bk_to .

                        update 
                             xxsld_bk_from  xxsld_bk_to
                        with frame d2 . /*editing:
                        end. update xxsld_stat*/
                        
                        if xxsld_bk_from = xxsld_bk_to then do:
                            message "错误:转入转出手册号不可相同" .
                            undo , retry.
                        end.
                        
                        /*检查手册*/
                        if xxsl_type =  yes then do:
                            v_bk_nbr = xxsld_bk_to .
                            v_bk_type = "IMP" .
                            v_bk_ln  = xxsld_bk_ln_to .
                        end. /*if xxsl_type =  yes*/
                        else do:
                            v_bk_nbr = xxsld_bk_from .
                            v_bk_type = "OUT" .
                            v_bk_ln  = xxsld_bk_ln_from .
                        end. /*if xxsl_type =  no */


                        find first xxcbkd_det 
                             where xxcbkd_domain = global_domain
                             and xxcbkd_bk_nbr   =  v_bk_nbr
                             and xxcbkd_bk_type  =  v_bk_type
                             and xxcbkd_cu_ln    = xxsld_cu_ln 
                        no-error .
                        if not avail xxcbkd_Det then do:
                            message "错误:无效本厂手册号" v_bk_nbr /*"/项" v_bk_ln*/ .
                            if xxsl_type =  yes then next-prompt xxsld_bk_to .
                            else next-prompt xxsld_bk_from .
                            undo , retry.
                        end.
                        else if xxcbkd_stat <> "" then  do:
                            message "错误:本厂手册非未结状态" v_bk_nbr /*"/项" v_bk_ln*/ .
                            if xxsl_type =  yes then next-prompt xxsld_bk_to .
                            else next-prompt xxsld_bk_from .
                            undo , retry.
                        end.
                        else do:
                            if ( xxcbkd_qty_ord - xxcbkd_qty_tsf - xxcbkd_qty_sl - xxcbkd_qty_io + xxcbkd_qty_rjct  ) <= 0 then do:
                                message "错误:本厂手册剩余数量不足," v_bk_nbr /*"/项" v_bk_ln*/ .
                                if xxsl_type =  yes then next-prompt xxsld_bk_to .
                                else next-prompt xxsld_bk_from .
                                undo , retry.
                            end.
                        end.
                    end. /*loopf*/
                end. /*if not avail xxsld_det*/
                else do:
                    {mfmsg.i 10 1}
                end.

            end. /*loope*/

            loopg:
            do on error undo , retry:
                if xxsl_type =  yes then do:
                    v_bk_nbr = xxsld_bk_to .
                    v_bk_type = "IMP" .
                    v_bk_ln  = xxsld_bk_ln_to .
                end. /*if xxsl_type =  yes*/
                else do:
                    v_bk_nbr = xxsld_bk_from .
                    v_bk_type = "OUT" .
                    v_bk_ln  = xxsld_bk_ln_from .
                end. /*if xxsl_type =  no */

                v_qty_old1 = xxsld_qty_ord .      
                update xxsld_qty_ord 
                go-on("F5" "CTRL-D")
                with frame d1 editing :
                    readkey.
                    if  lastkey = keycode("F5")
                        or lastkey = keycode("CTRL-D")
                    then do:   /*x1*/
                        if xxsld_qty_used > 0 or xxsld_stat <> "" then do:
                            message "错误:不允许删除." .
                            undo,retry .
                        end.
                        else do:
                            del-yn = yes.            
                            {mfmsg01.i 11 1 del-yn}
                            if del-yn then do: 
                            
                                delete xxsld_det.

                                clear frame d1 no-pause .
                                clear frame d2 no-pause .
                                del-yn = no.
                                next loopd .
                            end.
                        end.
                    end.  /*x1*/
                    else apply lastkey.
                end. /* editing :*/

                if xxsld_qty_ord <= 0 then do:
                    message "错误:转厂数量只允许正数." .
                    undo,retry.
                end.

                find first xxcbkd_det 
                     where xxcbkd_domain = global_domain
                     and xxcbkd_bk_nbr   = v_bk_nbr
                     and xxcbkd_bk_type  =  v_bk_type
                     /*and xxcbkd_bk_ln    = v_bk_ln*/ 
                     and xxcbkd_cu_ln    = xxsld_cu_ln 
                no-error .
                if not avail xxcbkd_Det then do:
                    message "错误:无效本厂手册号" v_bk_nbr /*"/项" v_bk_ln*/ .
                    undo , retry.
                end.
                else if xxcbkd_stat <> "" then  do:
                    message "错误:本厂手册非未结状态" v_bk_nbr /*"/项" v_bk_ln*/ .
                    undo , retry.
                end.
                else if ( xxcbkd_qty_ord - xxcbkd_qty_tsf - xxcbkd_qty_sl - xxcbkd_qty_io  + xxcbkd_qty_rjct ) <= 0 then do:
                    message "错误:本厂手册剩余数量不足," v_bk_nbr /*"/项" v_bk_ln*/ .
                    undo , retry.
                end.
                else do: /*if avail xxcbkd_Det */
                    v_qty_rst = (xxcbkd_qty_ord - xxcbkd_qty_tsf - xxcbkd_qty_sl - xxcbkd_qty_io + xxcbkd_qty_rjct ) .
                    if v_qty_rst < xxsld_qty_ord then do:
                        message "错误:本厂手册号" v_bk_nbr /*"/项" v_bk_ln*/ 
                            "剩余数量" v_qty_rst  
                            "不足本次转厂关封需求".
                        undo , retry.                                    
                    end.

                end. /*if avail xxcbkd_Det */

                looph:
                do on error undo , retry:
                    update xxsld_stat xxsld_rmks with frame d2 .
                    if xxsld_stat <> "" and index("XC",xxsld_stat) = 0 then do:
                        message "错误:无效状态" .
                        undo,retry .
                    end.
                end. /*looph*/                    
            end. /*loopg*/


        end. /*loopd*/
        hide frame a no-pause.
        hide frame d1 no-pause.
        hide frame d2 no-pause.

        view frame a .
        view frame ship_from .
        view frame ship_to .
        view frame b .



    end. /*loopa*/

end.   /*  mainloop: */
status input.