/* xxqmslmt04.p    供应商/零件/月初:可转厂数维护                            */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      LAST MODIFIED: 10/08/07   BY: Softspeed roger xiao    */
/*-Revision end---------------------------------------------------------------*/


{mfdtitle.i "1+ "}


define var v_vend  as char label "供应商代码" .
define var v_name  as char format "x(30)" . /*"供应商名称"*/
define var v_year  as integer label "年" format "9999" .
define var v_month as integer label "月" format "99".
define var v_date  as date label "参考日期" initial today .
define var v_cu_ln like xxcpt_ln label "商品序" .

define var del-yn  like mfc_logical initial yes.
v_year = year(v_date) .
v_month = month(v_date).

define  frame a.

form
    SKIP(.2)
    v_vend         colon 16 v_name no-label       
    v_date         colon 16
    v_year         colon 16  
    v_month        colon 16
    v_cu_ln        colon 16 label "商品序" 
    xxcpt_um       label "单位"
    xxcpt_cu_part  colon 16 label "商品编码"
    xxcpt_desc     colon 16 no-label 
   
    xxtrh_qty_begin   colon 16 label "期初可转厂数"
    xxtrh_qty_send    colon 16 label "本期实际送货数"

with frame a  side-labels width 80 attr-space.

view frame a .

mainloop:
repeat with frame a:
    

    ststatus = stline[1].
    status input ststatus.

    disp v_vend v_date v_month v_year v_cu_ln with frame a .

    prompt-for v_vend v_date v_cu_ln with frame a editing:
         if frame-field = "v_vend" then do:
             /* FIND NEXT/PREVIOUS RECORD */
             {mfnp01.i ad_mstr v_vend ad_addr global_domain ad_domain ad_addr}
             if recno <> ? then do:
                    disp ad_addr @ v_vend ad_name @ v_name with frame a .
             end . /* if recno <> ? then  do: */

         end.
         else  if frame-field = "v_cu_ln" then do:
             /* FIND NEXT/PREVIOUS RECORD */
             {mfnp01.i xxcpt_mstr  v_cu_ln xxcpt_ln global_domain xxcpt_domain xxcpt_ln}

             if recno <> ? then do:
                    disp xxcpt_ln @ v_cu_ln xxcpt_cu_part xxcpt_desc xxcpt_um with frame a.
             end . /* if recno <> ? then  do: */
         end.
         else do:
                   status input ststatus.
                   readkey.
                   apply lastkey.
         end.
    end. /* PROMPT-FOR...EDITING */
    assign v_cu_ln v_vend v_date v_cu_ln .

    if v_date = ? then do:
        message "错误:无效日期,请重新输入.".
        next-prompt v_date .
        undo,retry .
    end.
    
    assign v_year = year(v_date) v_month = month(v_date).
    disp v_year v_month with frame a .


    find first ad_mstr where ad_domain = global_domain and ad_addr = v_vend no-lock no-error .
    if not avail ad_mstr then do:
        message "错误:无效供应商代码.请重新输入" .
        next-prompt v_vend .
        undo,retry .
    end.
    else do:
        disp ad_name @ v_name with frame a.
    end.


    find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = v_cu_ln no-lock no-error .
    if not avail xxcpt_mstr then do:
        message "错误:无效商品序.请重新输入" .
        next-prompt v_cu_ln .
        undo,retry .
    end.
    else do:
        disp xxcpt_ln @ v_cu_ln xxcpt_cu_part xxcpt_desc xxcpt_um with frame a.
    end.


    setloop:
    do on error undo ,retry :
        find xxtrh_hist 
                where xxtrh_domain = global_domain 
                and xxtrh_cu_ln = v_cu_ln 
                and xxtrh_vend = v_vend 
                and xxtrh_year = v_year
                and xxtrh_month = v_month
        no-error .
        if not avail xxtrh_hist then do :
                clear frame a no-pause .
                find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = v_cu_ln no-lock no-error .
                {mfmsg.i 1 1}
                create xxtrh_hist .
                assign xxtrh_domain  = global_domain 
                       xxtrh_cu_ln   = v_cu_ln
                       xxtrh_cu_part = if avail xxcpt_mstr then xxcpt_cu_part else ""
                       xxtrh_cu_um   = if avail xxcpt_mstr then xxcpt_um      else ""
                       xxtrh_vend    = v_vend
                       xxtrh_year    = v_year
                       xxtrh_month   = v_month
                       .
        end.
        else do:
            {mfmsg.i 10 1}
        end.
        find first xxcpt_mstr where xxcpt_domain = global_domain and xxcpt_ln = v_cu_ln no-lock no-error .
        disp xxtrh_cu_ln @ v_cu_ln 
             xxtrh_vend @ v_vend 
             xxtrh_year @ v_year 
             xxtrh_month @ v_month 
             v_date 
             xxcpt_cu_part 
             xxcpt_desc 
             xxcpt_um 
             xxtrh_qty_begin
             xxtrh_qty_send
             with frame a.


        update xxtrh_qty_begin xxtrh_qty_send
        go-on ("F5" "CTRL-D") with frame a editing :
                readkey.
                if ( lastkey = keycode("F5") or lastkey = keycode("CTRL-D") ) then do:
                    del-yn = no.            
                    {mfmsg01.i 11 1 del-yn}
                    if del-yn then do:
                        delete xxtrh_hist . 
                    end.
                end. /*   "F5" "CTRL-D" */
                else apply lastkey.
        end. /* update ...EDITING */


    end. /*  setloop: */

end.   /*  mainloop: */

status input.
