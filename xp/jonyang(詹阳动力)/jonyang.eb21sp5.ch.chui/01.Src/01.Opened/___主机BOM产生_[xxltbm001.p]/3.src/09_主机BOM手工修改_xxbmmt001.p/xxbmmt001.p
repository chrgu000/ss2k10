/*xxbmmt001.p 主机BOM手工修改 */
/*----rev history-------------------------------------------------------------------------------------*/
/* REVISION: 100907.1   Created On: 20100907   By: Softspeed Roger Xiao                               */



{mfdtitle.i "100907.1"}
define var v_lot     like xbm_lot  no-undo.
define var v_part    like pt_part  no-undo.
define var v_desc11  like pt_desc1 no-undo.
define var v_um11    like pt_um    no-undo.
define var v_desc12  like pt_desc2 no-undo.

define var v_zppart  like pt_part  no-undo.
define var v_desc21  like pt_desc1 no-undo.
define var v_um21    like pt_um    no-undo.
define var v_desc22  like pt_desc2 no-undo.

define var v_comp    like pt_part  no-undo.
define var v_desc31  like pt_desc1 no-undo.
define var v_um31    like pt_um    no-undo.
define var v_desc32  like pt_desc2 no-undo.


form
    SKIP(.2)
    v_lot          colon 15 label "主机号"
    v_part         colon 15 label "零件号"
    v_desc11       colon 47 no-label    
    v_um11         colon 15 label "单位"
    v_desc12       colon 47 no-label 
                   
                   skip(1)
    v_zppart       colon 15 label "主机材料"
    v_desc21       colon 47 no-label  
    v_um21         colon 15 label "单位"
    v_desc22       colon 47 no-label 
    xbmd_qty_bom   colon 15 label "用量"
    xbmd_sn        colon 15 label "序列号"
    xbmd_hide      colon 15 label "隐藏"
                   
                   
                   
                   skip(1)
    v_comp         colon 15 label "ZP件材料"
    v_desc31       colon 47 no-label  
    v_um31         colon 15 label "单位"
    v_desc32       colon 47 no-label 
    xbmzp_qty_bom  colon 15 label "用量"
    xbmzp_sn       colon 15 label "序列号"
    xbmzp_hide     colon 15 label "隐藏"

    
skip(1) 
with frame a  side-labels width 80 attr-space.
/*setFrameLabels(frame a:handle).*/

view frame a .
mainloop:
repeat:
    clear frame a no-pause .

    disp v_lot with frame a .

    prompt-for 
        v_lot
    with frame a editing:
         {mfnp11.i xbm_mstr xbm_lot  "xbm_domain = global_domain and xbm_lot"  "input v_lot"  }
         if recno <> ? then do:
            disp 
                xbm_lot  @ v_lot
                xbm_part @ v_part
            with frame a .
            find first pt_mstr where pt_domain = global_domain and pt_part = xbm_part no-lock no-error .
            if avail pt_mstr then do:
                disp 
                    pt_desc1 @ v_desc11
                    pt_desc2 @ v_desc12
                    pt_um    @ v_um11
                with frame a.
            end.
         end . 
    end. /*editing:*/
    assign v_lot .

    find first xbm_mstr where xbm_domain = global_domain and xbm_lot = v_lot exclusive-lock no-error .
    if not avail xbm_mstr then do:
        message "错误:无效主机编号,请重新输入".
        undo,retry.
    end.
    v_part = xbm_part .

    find first pt_mstr where pt_domain = global_domain and pt_part = v_part no-lock no-error .
    if avail pt_mstr then do:
        disp 
            pt_desc1 @ v_desc11
            pt_desc2 @ v_desc12
            pt_um    @ v_um11
        with frame a.
    end.

    find first xbmd_det 
        where xbmd_domain = global_domain 
        and   xbmd_lot    = xbm_lot
        and   xbmd_par    = xbm_part
    no-error .
    if not avail xbmd_det then do:
        message "错误:主机BOM明细不存在,请重新输入" .
        undo,retry .
    end.
    v_zppart = xbmd_comp .
    
    zploop:
    repeat: 
        disp v_zppart with frame a .

        prompt-for 
            v_zppart
        with frame a editing:
             {mfnp11.i xbmd_det xbmd_comp  "xbmd_domain = global_domain and xbmd_lot = xbm_lot and xbmd_comp "  "input v_zppart"  }
             if recno <> ? then do:
                disp 
                    xbmd_comp @ v_zppart
                    xbmd_qty_bom
                    xbmd_sn     
                    xbmd_hide   
                with frame a .
                find first pt_mstr where pt_domain = global_domain and pt_part = xbmd_comp no-lock no-error .
                if avail pt_mstr then do:
                    disp 
                        pt_desc1 @ v_desc21
                        pt_desc2 @ v_desc22
                        pt_um    @ v_um21
                    with frame a.
                end.
             end . 
        end. /*editing:*/
        assign v_zppart .

        find first pt_mstr where pt_domain = global_domain and pt_part = v_zppart no-lock no-error .
        if not avail pt_mstr then do:
            message "错误:无效零件编号,请重新输入".
            undo,retry.
        end.
        disp 
            pt_desc1 @ v_desc21
            pt_desc2 @ v_desc22
            pt_um    @ v_um21
        with frame a.

        find first xbmd_det 
            where xbmd_domain = global_domain 
            and   xbmd_lot    = xbm_lot
            and   xbmd_comp   = v_zppart 
        exclusive-lock no-error .
        if not avail xbmd_det then do:
            {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1} 
            create xbmd_det.
            assign xbmd_domain = global_domain 
                   xbmd_lot    = xbm_lot       
                   xbmd_par    = xbm_part      
                   xbmd_wolot  = xbm_wolot     
                   xbmd_comp   = v_zppart      
                   xbmd_comp2  = v_zppart
                   xbmd_hide   = if avail pt_mstr then pt__chr01 else "" 
                   .
        end.
        else {pxmsg.i &MSGNUM=2 &ERRORLEVEL=1} 
        v_zppart = xbmd_comp .

        disp 
            xbmd_qty_bom 
            xbmd_sn 
            xbmd_hide 
        with frame a .

        zploopb:
        do on error undo,retry on endkey undo,leave :
            update 
                xbmd_qty_bom when ( not v_zppart begins "zp" )
                xbmd_sn 
                xbmd_hide 
            with frame a editing:
                readkey.
                if ( lastkey = keycode("F5") or lastkey = keycode("CTRL-D") ) then do:
                    if v_zppart begins "zp" then do:
                        message "错误:ZP件不可用本程式删除." .
                        undo,retry.
                    end.

                    message "确认删除?" update choice as logical.
                    if choice then do :
                        delete xbmd_det.
                        message "主机材料已删除." .
                        next zploop .
                    end.
                end. /*   "F5" "CTRL-D" */
                else apply lastkey.
            end. /* update ...EDITING */

            if xbmd_hide <> "Y" and xbmd_hide <> "" then do:
                message "错误:是否隐藏,限制输入Y或空.".
                undo,retry.
            end.

            if not (v_zppart begins "zp") then next zploop.

            find first xbmzp_det 
                where xbmzp_domain = global_domain 
                and   xbmzp_lot    = xbm_lot
                and   xbmzp_zppart = v_zppart
            no-error .
            if avail xbmzp_det then do:
                v_comp = xbmzp_comp .
                disp 
                    xbmzp_qty_bom 
                    xbmzp_sn 
                    xbmzp_hide 
                with frame a .
            end.

            zpdetloop:
            repeat: 
                disp v_comp with frame a .

                prompt-for 
                    v_comp
                with frame a editing:
                     {mfnp11.i xbmzp_det xbmzp_comp  "xbmzp_domain = global_domain and xbmzp_lot = xbm_lot and xbmzp_zppart = v_zppart and xbmzp_comp "  "input v_comp"  }
                     if recno <> ? then do:
                        disp 
                            xbmzp_comp @ v_comp
                            xbmzp_qty_bom
                            xbmzp_sn     
                            xbmzp_hide   
                        with frame a .
                        find first pt_mstr where pt_domain = global_domain and pt_part = xbmzp_comp no-lock no-error .
                        if avail pt_mstr then do:
                            disp 
                                pt_desc1 @ v_desc31
                                pt_desc2 @ v_desc32
                                pt_um    @ v_um31
                            with frame a.
                        end.
                     end . 
                end. /*editing:*/
                assign v_comp .

                find first pt_mstr where pt_domain = global_domain and pt_part = v_comp no-lock no-error .
                if not avail pt_mstr then do:
                    message "错误:无效零件编号,请重新输入".
                    undo,retry.
                end.
                else do:
                    disp 
                        pt_desc1 @ v_desc31
                        pt_desc2 @ v_desc32
                        pt_um    @ v_um31
                    with frame a.
                end.

                find first xbmzp_det 
                    where xbmzp_domain = global_domain 
                    and   xbmzp_lot    = xbm_lot
                    and   xbmzp_zppart = v_zppart 
                    and   xbmzp_comp   = v_comp
                exclusive-lock no-error .
                if not avail xbmzp_det then do:
                    {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1} 
                    create xbmzp_det.
                    assign xbmzp_domain = global_domain 
                           xbmzp_lot    = xbm_lot       
                           xbmzp_par    = xbm_part      
                           xbmzp_wolot  = xbm_wolot  
                           xbmzp_zppart = v_zppart 
                           xbmzp_comp   = v_comp      
                           xbmzp_comp2  = v_comp
                           xbmzp_hide   = if avail pt_mstr then pt__chr01 else "" 
                           .
                end.
                else {pxmsg.i &MSGNUM=2 &ERRORLEVEL=1} 
                v_comp = xbmzp_comp .
                disp 
                    xbmzp_qty_bom 
                    xbmzp_sn 
                    xbmzp_hide 
                with frame a .


                zpdetloopb:
                do on error undo,retry on endkey undo,leave :
                    update 
                        xbmzp_qty_bom 
                        xbmzp_sn 
                        xbmzp_hide 
                    with frame a editing:
                        readkey.
                        if ( lastkey = keycode("F5") or lastkey = keycode("CTRL-D") ) then do:
                            message "确认删除?" update choice2 as logical.
                            if choice2 then do :
                                delete xbmzp_det.
                                message "主机ZP件材料已删除." .
                                next zpdetloop .
                            end.
                        end. /*   "F5" "CTRL-D" */
                        else apply lastkey.
                    end. /* update ...EDITING */

                    if xbmzp_hide <> "Y" and xbmzp_hide <> "" then do:
                        message "错误:是否隐藏,限制输入Y或空.".
                        undo,retry.
                    end.
                end. /* zpdetloopb: */
            end. /* zpdetloop: */
        end. /* zploopb: */
    end. /* zploop: */
end. /* mainloop: */





