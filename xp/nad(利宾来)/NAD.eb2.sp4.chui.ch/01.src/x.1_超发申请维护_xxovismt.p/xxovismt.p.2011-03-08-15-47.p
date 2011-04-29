/* xxovismt.p - 超发申请单维护  */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110121.1  By: Roger Xiao */ /*改为每张申请单可对应多张wo*/
/*-Revision end---------------------------------------------------------------*/

{mfdtitle.i "110121.1"}

define var v_nbr              like rqd_nbr no-undo.
define var v_site             like wo_site no-undo.
define var v_wonbr            like wo_nbr  no-undo.
define var v_wolot            like wo_lot  no-undo.

define var v_iss_times        as integer format ">>>" .
define var v_qty_pct          as decimal format ">>>9.9<%" .
define var v_qty_open         like tr_qty_loc .
define var v_qty_ord          like tr_qty_loc .
define var v_qty_total        like tr_qty_loc .
define var line               as integer format ">>>" .
define var del-yn             like mfc_logical initial no.
define var v_ii               as integer .

define var v_newline          as logical .
define var v_sub              as logical .

define var v_error            as logical .
define var v_todo             as char extent 4 .
v_todo[1] = "add".
v_todo[2] = "mod".
v_todo[3] = "del".
v_todo[4] = "app".

define new shared variable cmtindx       as integer.
define var v_cmmt                        as logical format "Yes/No" no-undo.


form
    v_nbr          colon 10  label "申请单号" v_site         colon 35  label "地点"     
    xovm_status    colon 10  label "申请状态" v_wonbr        colon 35  label "加工单"
    xovm_mod_date  colon 10  label "申请日期" v_wolot        colon 35  label "工单ID"            
    xovm_mod_user  colon 10  label "申请人"   wo_part        colon 35  label "料号"       
with frame a  
side-labels
width 80 .


form
    line              label "项次"
    xovd_part         label "物料号"
    v_qty_open        label "欠缺量"
    xovd_iss_qty      label "超发量"
    xovd_iss_times    label "第次"
    v_qty_total       label "累计超发量"
    v_qty_pct         label "累计%"
    v_cmmt            label "备注"
with frame b 	
three-d 
overlay 9 down 
scroll 1
width 80.


view frame a.
view frame b.

mainloop:
repeat with frame a:
    ststatus = stline[1].
    status input ststatus.

    clear frame a all no-pause.
    clear frame b all no-pause.

    find first xovc_ctrl no-lock no-error .
    if not avail xovc_ctrl then do: 
        message "错误:超发申请控制未维护,按任意键退出.".
        undo,leave mainloop.
    end.

    update v_nbr with frame a editing:
         if frame-field = "v_nbr" then do:
             {mfnp11.i xovm_mstr  xovm_nbr xovm_nbr " input v_nbr"  }
             if recno <> ? then do:
                disp 
                    xovm_nbr  @ v_nbr 
                    xovm_site @ v_site
                    xovm_mod_user 
                    xovm_mod_date 
                    xovm_status   
                    "" @ v_wonbr
                    "" @ v_wolot
                with frame a .
             end . /* if recno <> ? then  do: */
         end.
         else do:
                   status input ststatus.
                   readkey.
                   apply lastkey.
         end.
    end. /* update..EDITING */

    if v_nbr <> "" then do:        
        find first xovm_mstr where xovm_nbr = v_nbr no-lock no-error.
        if avail xovm_mstr then do:
            v_site = xovm_site.
            find first si_mstr where si_site = xovm_site no-lock no-error.
            if not avail si_mstr then do:
                message "错误:地点不存在,请重新输入" .
                undo mainloop, retry mainloop.
            end.
            {gprun.i ""gpsiver.p"" "(input si_site, input recid(si_mstr), output return_int)"}
            if return_int = 0 then do:
               {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}  
               undo , retry .
            end.            

            {gprun.i ""xxovismtb.p"" "(input global_userid, input v_todo[2] , input xovm_site, output v_error )"}
            if v_error then do:
                message "错误:您没有申请单的 修改权限".
                undo,retry.
            end.

            if xovm_status <> "P" then do:
                message "错误:申请单已经审批,不可再修改".
                undo,retry.                
            end.
            /***        
            find first xovm_mstr where xovm_nbr = v_nbr exclusive-lock no-wait no-error .
            if not avail xovm_mstr then do:
                if locked xovm_mstr then do:
                    message "警告:此单号正在被编辑,已被锁定" .
                    undo,retry.
                end.
            end.       
            ***/    
            
        end. /*if avail xovm_mstr*/
        else do: /*new*/
            message "错误:超发申请单号不存在,请重新输入".
            undo,retry.
        end. /*new*/
    end. /*v_nbr <> ""*/
    else do on error undo,retry: /*v_nbr = ""*/
            update v_site with frame a editing:
                 if frame-field = "v_site" then do:
                     {mfnp11.i si_mstr  si_site si_site " input v_site"  }
                     if recno <> ? then do:
                        disp 
                            si_site @ v_site
                        with frame a .
                     end . /* if recno <> ? then  do: */
                 end.
                 else do:
                           status input ststatus.
                           readkey.
                           apply lastkey.
                 end.
            end. /* update..EDITING */

            find first si_mstr where si_site = v_site no-lock no-error.
            if not avail si_mstr then do:
                message "错误:地点不存在,请重新输入" .
                undo mainloop, retry mainloop.
            end.
            {gprun.i ""gpsiver.p"" "(input si_site, input recid(si_mstr), output return_int)"}
            if return_int = 0 then do:
               {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}  
               undo , retry .
            end.            

            {gprun.i ""xxovismtb.p"" "(input global_userid, input v_todo[2] , input v_site, output v_error )"}
            if v_error then do:
                message "错误:您没有申请单的 修改权限".
                undo,retry.
            end.
            
            do transaction on error undo, leave on endkey undo, return:            
                {xxovismtc.i 
                    xovc_ctrl 
                    xovc_nbr_pre 
                    xovc_nbr_next 
                    xovm_mstr 
                    xovm_nbr 
                    v_nbr 
                    " xovc_site = v_site "
                    " xovm_site = v_site "
                    }
                release xovc_ctrl .
            end.            

    end.  /*v_nbr = ""*/

setloop:
do on error undo ,retry on endkey undo, leave:
    find first xovm_mstr where xovm_nbr = v_nbr exclusive-lock no-error .
    if not avail xovm_mstr then do :
            {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1} 
            create xovm_mstr .
            assign xovm_nbr      = v_nbr 
                   xovm_site     = v_site
                   xovm_status   = "P"
                   xovm_mod_user = global_userid
                   xovm_mod_date = today 
                   .
    end.

    disp
        xovm_nbr  @ v_nbr 
        xovm_site @ v_site
        xovm_mod_user 
        xovm_mod_date 
        xovm_status   
    with frame a . 
    
    v_wolot = "".
    v_wonbr = "".


    mstrloop:
    repeat on endkey undo, leave:
        prompt-for 
            v_wonbr 
            v_wolot 
        with frame a editing:
            if frame-field = "v_wonbr" then do:
                {mfnp11.i xovd_det xovd_nbr_wonbr "xovd_nbr = v_nbr and xovd_wonbr" "input v_wonbr"}
            end.
            else if frame-field = "v_wolot" then do:
                {mfnp11.i xovd_det xovd_nbr_wolot "xovd_nbr = v_nbr and xovd_wolot" "input v_wolot"}
            end.
            else do:
                readkey.
                apply lastkey.
            end.

            if recno <> ? then do:
                find first wo_mstr use-index wo_lot where wo_lot = xovd_wolot no-lock no-error .
                if avail wo_mstr then 
                display
                    wo_nbr @ v_wonbr 
                    wo_lot @ v_wolot
                    wo_part
                with frame a.
            end.
        end. /* prompt-for ... with frame a editing: */

        if input v_wonbr <> "" and input v_wolot <> "" then
            find wo_mstr no-lock use-index wo_lot where wo_lot = input v_wolot and wo_nbr = input v_wonbr no-error.

        if input v_wonbr = "" and input v_wolot <> "" then
            find wo_mstr no-lock use-index wo_lot where wo_lot = input v_wolot no-error.

        if input v_wonbr <> "" and input v_wolot = "" then
            find first wo_mstr no-lock use-index wo_nbr where wo_nbr = input v_wonbr no-error.

        if not available wo_mstr then if input v_wolot <> "" then
            find wo_mstr no-lock use-index wo_lot where wo_lot = input v_wolot no-error.

        if not available wo_mstr then do:
            {pxmsg.i &msgnum=503 &errorlevel=3}
            undo , retry .
        end.
        else do:   /*if available wo_mstr*/
            if wo_nbr <> input v_wonbr and input v_wonbr <> "" then do:
                {pxmsg.i &msgnum=508 &errorlevel=3}
                undo , retry .
            end.

            disp 
                wo_nbr @ v_wonbr 
                wo_lot @ v_wolot
                wo_part
            with frame a .

            if wo_site <> v_site then do:
                message "错误:此工单不属于申请单指定的地点" v_site .
                undo,retry .
            end.
            
            find first si_mstr where si_site = wo_site no-lock no-error.
            if not avail si_mstr then do:
                message "错误:地点不存在,请重新输入" .
                undo , retry .
            end.
            {gprun.i ""gpsiver.p"" "(input si_site, input recid(si_mstr), output return_int)"}
            if return_int = 0 then do:
               {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}  
               next-prompt v_nbr with frame a.
               undo , retry .
            end.            

            {gprun.i ""xxovismtb.p"" "(input global_userid, input v_todo[1] , input wo_site, output v_error )"}
            if v_error then do:
                message "错误:工单地点:" wo_site ",您没有申请单的 新增权限".
                undo,retry.
            end.


            v_wolot = wo_lot.
            v_wonbr = wo_nbr.
        end.  /*if available wo_mstr*/

        if v_wolot = "" then leave mstrloop.


        line = 1.

        lineloop:
        repeat on endkey undo, leave:
            clear frame b all no-pause.

            find last xovd_det 
                where xovd_nbr = v_nbr 
            no-lock no-error.
            if available xovd_det then line = xovd_line + 1.

            for each xovd_det 
                where xovd_nbr   = v_nbr 
                and   xovd_wolot = v_wolot
                no-lock
                break by xovd_line :

                    v_qty_open = 0 .
                    v_qty_ord  = 0 .
                    v_iss_times = 0.
                    v_qty_total = 0.
                    for each wod_det where wod_lot = xovd_wolot and wod_part = xovd_part no-lock :
                        v_qty_open = v_qty_open + max(0, wod_qty_req - wod_qty_iss ) .
                        v_qty_ord  = v_qty_ord  + wod_qty_req .
                    end.

                    {gprun.i ""xxovismta.p"" "(input xovd_part, input xovd_nbr , input xovd_wolot , output v_iss_times , output v_qty_total )"}

                    v_iss_times = v_iss_times + 1 .
                    v_qty_total = v_qty_total + xovd_iss_qty .
                    v_qty_pct   = if v_qty_ord <> 0  then v_qty_total * 100 / v_qty_ord else 100.
                    
                    v_cmmt      = if can-find(first cmt_det  where cmt_det.cmt_indx = xovd_cmtidx) then yes else no .

                    display
                        xovd_line @ line           
                        xovd_part      
                        xovd_iss_qty   
                        xovd_iss_times 
                        v_qty_open     
                        v_qty_total  
                        v_qty_pct
                        v_cmmt 
                    with down frame b.                     

                    if frame-line(b) = frame-down(b) then leave.
                    down 1 with frame b.
            end.  /* for each xovd_det */

            update 
                line 
            with frame b editing:
                {mfnp11.i xovd_det xovd_nbr_wolot "xovd_nbr = v_nbr and xovd_wolot = v_wolot and xovd_line" "input line"}

                if recno <> ? then do:

                    find first pt_mstr where pt_part = xovd_part no-lock no-error.
                    if avail pt_mstr then message pt_desc1 pt_desc2 .

                    v_qty_open = 0 .
                    v_qty_ord  = 0 .
                    v_iss_times = 0.
                    v_qty_total = 0.

                    for each wod_det where wod_lot = xovd_wolot and wod_part = xovd_part no-lock :
                        v_qty_open = v_qty_open + max(0, wod_qty_req - wod_qty_iss ) .
                        v_qty_ord  = v_qty_ord  + wod_qty_req.
                    end.

                    {gprun.i ""xxovismta.p"" "(input xovd_part, input xovd_nbr , input xovd_wolot, output v_iss_times , output v_qty_total )"}

                    v_iss_times = v_iss_times + 1 .
                    v_qty_total = v_qty_total + xovd_iss_qty .
                    v_qty_pct   = if v_qty_ord <> 0  then v_qty_total * 100 / v_qty_ord else 100.

                    v_cmmt      = if can-find(first cmt_det  where cmt_det.cmt_indx = xovd_cmtidx) then yes else no .
                    
                    display
                        xovd_line @ line           
                        xovd_part      
                        xovd_iss_qty   
                        xovd_iss_times 
                        v_qty_open     
                        v_qty_total 
                        v_qty_pct
                        v_cmmt
                    with frame b.                     
                end.
            end. /*editing:*/
               
            if line = 0 then leave .

            find first xovd_det 
                where xovd_nbr = v_nbr
                and xovd_line  = input line 
            exclusive-lock no-error.
            if not available xovd_det then do:
                {gprun.i ""xxovismtb.p"" "(input global_userid, input v_todo[1] , input xovm_site, output v_error )"}
                if v_error then do:
                    message "错误:您没有申请单的 新增权限".
                    undo,retry.
                end.

                {pxmsg.i  &MSGNUM=1 &ERRORLEVEL=1}
                create xovd_det.
                assign
                    xovd_nbr     = v_nbr
                    xovd_wonbr   = v_wonbr
                    xovd_wolot   = v_wolot 
                    xovd_line    = input line
                    xovd_status  = "P"
                    v_newline    = yes .

                partloop:
                do on error undo, retry with frame b:
                    set 
                        xovd_part
                    with frame b editing:
                        if frame-field = "xovd_part" then do:
                            {mfnp11.i wod_det wod_det "wod_lot = xovd_wolot and wod_part " " input xovd_part" }

                            if recno <> ? then do:    
                                v_qty_open = 0 .
                                v_qty_ord  = 0 .

                                v_qty_open = v_qty_open + max(0, wod_qty_req - wod_qty_iss ) .
                                v_qty_ord  = v_qty_ord  + wod_qty_req.
                                v_iss_times = 0.
                                v_qty_total = 0.


                                {gprun.i ""xxovismta.p"" "(input wod_part, input xovd_nbr , input xovd_wolot, output v_iss_times , output v_qty_total )"}
                                
                                v_qty_pct = if v_qty_ord <> 0  then v_qty_total * 100 / v_qty_ord else 100.

                                disp 
                                    wod_part @ xovd_part 
                                    max(0, wod_qty_req - wod_qty_iss ) @ v_qty_open 
                                    v_iss_times @ xovd_iss_times
                                    v_qty_total 
                                    v_qty_pct
                                with frame b .
                            end.
                        end.
                        else do:
                            status input ststatus.
                            readkey.
                            apply lastkey.
                        end.
                    end.

                    find first wod_det where wod_lot = xovd_wolot and wod_part = input xovd_part no-lock no-error.
                    if not avail wod_det then do:
                        v_sub = no .
                        for each pts_det
                            use-index pts_sub_part
                            where pts_sub_part = input xovd_part 
                            and  (pts_par = wo_part or pts_par = "" ) 
                        no-lock :
                            find first wod_det where wod_lot = xovd_wolot and wod_part = pts_part no-lock no-error.
                            if avail wod_det then do:
                                v_sub = yes .
                                leave .
                            end.
                        end.

                        if v_sub = no then do:
                            message "错误:该零件在加工单物料清单上不存在,请重新输入".
                            undo,retry.
                        end.
                    end.

                    if can-find(first xovd_det 
                                    use-index xovd_nbrpart 
                                    where xovd_nbr = v_nbr 
                                    and xovd_part  = input xovd_part 
                                    and xovd_wolot = v_wolot
                                    and xovd_line <> line 
                                no-lock) 
                    then do:
                        message "错误:已有其他项次包含此工单/料号,请重新输入".
                        undo,retry.
                    end.

                    v_qty_open = 0 .
                    v_qty_ord  = 0 .
                    v_iss_times = 0.
                    v_qty_total = 0.
                    for each wod_det where wod_lot = xovd_wolot and wod_part = xovd_part no-lock :
                        v_qty_open = v_qty_open + max(0, wod_qty_req - wod_qty_iss ) .
                        v_qty_ord  = v_qty_ord  + wod_qty_req.
                    end.

                    {gprun.i ""xxovismta.p"" "(input xovd_part, input xovd_nbr , input xovd_wolot, output v_iss_times , output v_qty_total )"}
                    v_iss_times = v_iss_times + 1. 

                    v_qty_pct = if v_qty_ord <> 0  then v_qty_total * 100 / v_qty_ord else 100.
                    
                    xovd_iss_times = v_iss_times.
                    display
                        xovd_line @ line           
                        xovd_part      
                        xovd_iss_qty   
                        xovd_iss_times
                        v_qty_open     
                        v_qty_total      
                        v_qty_pct
                    with down frame b.    
                    
                end. /*partloop:*/
            end. /* if not available xovd_det */
            else v_newline = no .

            if xovd_status <> "P" then do:
                message "错误:当前状态(" xovd_status "),非待批准P,不可再修改." .
                undo,retry.
            end.

            if v_newline = no then do:
                    {gprun.i ""xxovismtb.p"" "(input global_userid, input v_todo[2] , input xovm_site, output v_error )"}
                    if v_error then do:
                        message "错误:您没有申请单的 修改权限".
                        undo,retry.
                    end.                
            end.

            qtyloop:
            do on error undo, retry with frame b:
                update 
                    xovd_iss_qty 
                    v_cmmt
                go-on (F5 CTRL-D)
                with frame b .

                if (lastkey = keycode("F5") or
                    lastkey = keycode("CTRL-D"))
                then do:
                    {gprun.i ""xxovismtb.p"" "(input global_userid, input v_todo[3] , input xovm_site, output v_error )"}
                    if v_error then do:
                        message "错误:您没有申请单的 删除权限".
                        undo,retry.
                    end.

                    if xovd_status <> "P" then do:
                        message "错误:当前状态(" xovd_status "),非待批准P,不可删除." .
                        undo,retry.
                    end.

                    del-yn = yes.
                    {mfmsg01.i 11 1 del-yn}

                    if del-yn then do:
                        delete xovd_det.
                        {pxmsg.i  &MSGNUM=24 &ERRORLEVEL=1  &MSGARG1=1}
                        hide message.

                        clear frame b all no-pause.
                        next lineloop.
                    end.
                    else undo, retry.
                end. /*if (lastkey = keycode("F5")*/


                if xovd_iss_qty <= 0 then do:
                    message "错误：数量仅限正数, 请重新输入！".
                    next-prompt xovd_iss_qty with frame b.
                    undo, retry.                                 
                end.

                v_qty_open = 0 .
                v_qty_ord  = 0 .
                for each wod_det where wod_lot = xovd_wolot and wod_part = xovd_part no-lock :
                    v_qty_open = v_qty_open + max(0, wod_qty_req - wod_qty_iss ) .
                    v_qty_ord  = v_qty_ord  + wod_qty_req.
                end.

                {gprun.i ""xxovismta.p"" "(input xovd_part, input xovd_nbr , input xovd_wolot, output v_iss_times , output v_qty_total )"}

                v_iss_times = v_iss_times + 1 .
                v_qty_total = v_qty_total + xovd_iss_qty .
                v_qty_pct = if v_qty_ord <> 0  then v_qty_total * 100 / v_qty_ord else 100.

                display
                    xovd_line @ line           
                    xovd_part      
                    xovd_iss_qty  
                    xovd_iss_times 
                    v_qty_open     
                    v_qty_total      
                    v_qty_pct
                    v_cmmt 
                with frame b.  
                
                if v_cmmt = yes then do on error undo , retry:
                    pause 0 .
                    assign
                        global_ref  = xovd_nbr
                        cmtindx     = xovd_cmtidx .

                    {gprun.i ""gpcmmt01.p"" "(input ""xovd_det"")"}

                    xovd_cmtidx = cmtindx.

                end.            

                release xovd_det.

            end. /*qtyloop:*/

            down 1 with frame b.
               
        end. /* lineloop */
    end. /* mstrloop */
end. /*  setloop: */

    v_ii = 0 .
    for each xovd_det where xovd_nbr = v_nbr no-lock:
    v_ii = v_ii + 1 .
    end.
    if v_ii = 0 then do:
        for each xovm_mstr where xovm_nbr = v_nbr exclusive-lock :
            delete xovm_mstr .
            v_nbr = "" .
            clear frame a all no-pause.
            clear frame b all no-pause.
            next mainloop.
        end.
    end.
end.   /*  mainloop: */
status input.

