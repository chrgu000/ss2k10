/* xxpbdmt.p - 物料排产的经济批量和库存基准维护  */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110328.1  By: Roger Xiao */ /* created */
/*-Revision end---------------------------------------------------------------*/

{mfdtitle.i "110328.1"}

define var site               like si_site .
define var part               like xxpbd_part .

define var del-yn             like mfc_logical initial no.
define var v_ii               as integer .


form
    site                      colon 18  label "地点"     si_desc no-label
    part                      colon 18  label "零件编号"  
    pt_desc1                  colon 52  label "说明"
    pt_um                     colon 18  label "单位"
    pt_desc2                  colon 52  no-label  
    skip(1)

    xxpbd_qty_lot             colon 18  label "经济批量"  
    xxpbd_qty_min             colon 18  label "库存下限"      
    xxpbd_qty_max             colon 18  label "库存上限"      

with frame a             
side-labels              
width 80 .               

view frame a.

find icc_ctrl no-lock no-error.
site = if avail icc_ctrl then icc_site else "gsa01" .

mainloop:
repeat with frame a:
    ststatus = stline[1].
    status input ststatus.

    update 
        site
        part
    with frame a editing:
         if frame-field = "site" then do:
             {mfnp11.i xxpbd_det  xxpbd_site xxpbd_site " input site"  }
             if recno <> ? then do:
                find first si_mstr where si_site = xxpbd_site no-lock no-error.
                if avail si_mstr then disp si_desc with frame a .

                disp 
                    xxpbd_site  @ site
                    xxpbd_part  @ part
                    xxpbd_qty_lot
                    xxpbd_qty_min
                    xxpbd_qty_max
                with frame a .
             end . /* if recno <> ? then  do: */
         end.
         else if frame-field = "part" then do:
             {mfnp11.i xxpbd_det  xxpbd_site "xxpbd_site = input site and xxpbd_part" "input part"  }
             if recno <> ? then do:

                find first pt_mstr where pt_part = xxpbd_part no-lock no-error.
                if avail pt_mstr then disp pt_desc1 pt_Desc2 pt_um  with frame a .

                disp 
                    xxpbd_site  @ site
                    xxpbd_part  @ part
                    xxpbd_qty_lot
                    xxpbd_qty_min
                    xxpbd_qty_max
                with frame a .
             end . /* if recno <> ? then  do: */
         end.
         else do:
                   status input ststatus.
                   readkey.
                   apply lastkey.
         end.
    end. /* update..EDITING */


    find first si_mstr where si_site = site no-lock no-error.
    if not avail si_mstr then do:
        message "错误:无效地点,请重新输入" .
        undo,retry.
    end.


    find first pt_mstr where pt_part = part no-lock no-error.
    if not avail pt_mstr then do:
        message "错误:无效零件编号,请重新输入" .
        undo,retry.
    end.

    disp si_desc pt_desc1 pt_Desc2 pt_um  with frame a .


    setloop:
    do on error undo ,retry on endkey undo, leave:
        find first xxpbd_det 
          where xxpbd_part = part 
          and   xxpbd_site = site 
        exclusive-lock no-error .
        if not avail xxpbd_det then do :
                {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1} 
                create xxpbd_det .
                assign xxpbd_part   = part
                       xxpbd_site   = site 
                       .
            find first xxcased_det 
                use-index xxcased_part
                where xxcased_part = xxpbd_part 
            no-lock no-error.
            if avail xxcased_Det then xxpbd_qty_lot = xxcased_qty_per .
        end.
        else do:
            {pxmsg.i &MSGNUM=10 &ERRORLEVEL=1} 
        end.

        disp 
                    xxpbd_part @ part
                    xxpbd_qty_lot
                    xxpbd_qty_min
                    xxpbd_qty_max
        with frame a . 

        update 
                    xxpbd_qty_lot
                    xxpbd_qty_min
                    xxpbd_qty_max
        go-on (F5 CTRL-D)
        with frame a .

        if (lastkey = keycode("F5") or
            lastkey = keycode("CTRL-D"))
        then do:
            del-yn = yes.
            {mfmsg01.i 11 1 del-yn}
            if del-yn then do:
                delete xxpbd_det .
                {pxmsg.i &MSGNUM=24 &ERRORLEVEL=3 }
                clear frame a all no-pause.
                next mainloop.
            end.
            else undo, retry.
        end. /* CTRL-D */


        if xxpbd_qty_min > xxpbd_qty_max then do:
            message "错误:上限小于下限,请重新输入" .
            undo,retry.
        end.

        assign  xxpbd_mod_date   = today 
                xxpbd_mod_user   = global_userid
                .

    end. /*  setloop: */
end.   /*  mainloop: */
status input.

