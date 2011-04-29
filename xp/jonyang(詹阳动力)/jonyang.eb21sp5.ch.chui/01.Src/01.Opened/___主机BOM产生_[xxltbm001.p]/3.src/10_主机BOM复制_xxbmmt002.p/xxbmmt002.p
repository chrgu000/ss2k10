/*xxbmmt001.p 主机BOM复制 */
/*----rev history-------------------------------------------------------------------------------------*/
/* REVISION: 100907.1   Created On: 20100907   By: Softspeed Roger Xiao                               */



{mfdtitle.i "100907.1"}
define var v_lot     like xbm_lot  no-undo.
define var v_part    like pt_part  no-undo.
define var v_desc11  like pt_desc1 no-undo.
define var v_um11    like pt_um    no-undo.
define var v_desc12  like pt_desc2 no-undo.

define var v_newlot  like xbm_lot  no-undo.
define var v_newpart like pt_part  no-undo.
define var v_desc21  like pt_desc1 no-undo.
define var v_um21    like pt_um    no-undo.
define var v_desc22  like pt_desc2 no-undo.

define var v_yn      as logical    no-undo.
define var choice    as logical .

define buffer xbmzp_buffer for xbmzp_det.
define buffer xbmd_buffer  for xbmd_det.
define buffer xbm_buffer   for xbm_mstr.

form
    SKIP(.2)
    v_lot          colon 15 label "主机号"
    v_part         colon 15 label "零件号"
    v_desc11       colon 47 no-label    
    v_um11         colon 15 label "单位"
    v_desc12       colon 47 no-label 
                   
    skip(1)
    v_newlot       colon 15 label "新主机号"
    v_newpart      colon 15 label "新零件号"
    v_desc21       colon 47 no-label    
    v_um21         colon 15 label "单位"
    v_desc22       colon 47 no-label 

    skip(2)
    v_yn           colon 15 label "删除原主机"


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

    newlotloop:
    do on error undo , retry on endkey undo,leave :
        v_newpart = v_part .

        update v_newlot with frame a .

        find first xbm_mstr where xbm_domain = global_domain and xbm_lot = v_newlot no-lock no-error .
        if avail xbm_mstr then do:
            message "错误:主机编号已存在,请重新输入".
            undo,retry.
        end.

        newpartloop:
        do on error undo, retry on endkey undo,leave :
            update 
                v_newpart 
            with frame a editing:
                {mfnp11.i pt_mstr pt_part  "pt_domain = global_domain and pt_part "  "input v_newpart"  }
                if recno <> ? then do:
                    disp 
                        pt_desc1 @ v_desc21
                        pt_desc2 @ v_desc22
                        pt_um    @ v_um21
                    with frame a.
                end . 
            end. /*editing:*/
            assign v_newpart .

            find first pt_mstr where pt_domain = global_domain and pt_part = v_newpart no-lock no-error .
            if avail pt_mstr then do:
                disp 
                    pt_desc1 @ v_desc21
                    pt_desc2 @ v_desc22
                    pt_um    @ v_um21
                with frame a.
            end.
            else do:
                message "错误:必须是有效物料编号,请重新输入.".
                undo,retry.
            end.


            update v_yn with frame a .


            message "以上信息全部正确?" update choice .
            if choice then do:

                for each xbm_mstr where xbm_domain = global_domain and xbm_lot = v_lot exclusive-lock :
                    for each xbmzp_det where xbmzp_domain = global_domain and xbmzp_lot = v_lot exclusive-lock :
                        create xbmzp_buffer.
                        buffer-copy xbmzp_det 
                            except xbmzp_lot xbmzp_par
                        to xbmzp_buffer.
                        assign  xbmzp_buffer.xbmzp_lot = v_newlot 
                                xbmzp_buffer.xbmzp_par = v_newpart .

                        if v_yn = yes then delete xbmzp_det .
                    end.
                    for each xbmd_det where xbmd_domain = global_domain and xbmd_lot = v_lot exclusive-lock :
                        create xbmd_buffer.
                        buffer-copy xbmd_det 
                            except xbmd_lot xbmd_par
                        to xbmd_buffer.
                        assign  xbmd_buffer.xbmd_lot = v_newlot 
                                xbmd_buffer.xbmd_par = v_newpart .

                        if v_yn = yes then delete xbmd_det .
                    end.

                        create xbm_buffer.
                        buffer-copy xbm_mstr 
                            except 
                                    xbm_lot 
                                    xbm_part
                                    xbm_user_crt
                                    xbm_date_crt
                                    xbm_time_crt
                                    xbm_mthd_crt  
                        to xbm_buffer.
                        assign  xbm_buffer.xbm_lot      = v_newlot 
                                xbm_buffer.xbm_part     = v_newpart 
                                xbm_buffer.xbm_user_crt = global_userid 
                                xbm_buffer.xbm_date_crt = today 
                                xbm_buffer.xbm_time_crt = time 
                                xbm_buffer.xbm_mthd_crt   = "copy" .

                    if v_yn = yes then delete xbm_mstr .
                end. /*for each xbm_mstr*/

                message "新主机复制完成" .
            end. /*if choice then*/
            else do:
                message "未复制,用户退出." .
                undo mainloop,retry mainloop.
            end.
        end. /*newpartloop:*/
    end. /*newlotloop:*/
end. /* mainloop: */





