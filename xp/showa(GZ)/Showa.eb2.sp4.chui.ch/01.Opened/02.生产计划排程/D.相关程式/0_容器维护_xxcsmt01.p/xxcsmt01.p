/* xxcsmt01.p - 容器维护  */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110324.1  By: Roger Xiao */ /* created */
/*-Revision end---------------------------------------------------------------*/

{mfdtitle.i "110324.1"}

define var site               like xxrest_site .
define var v_nbr              like po_nbr no-undo.
define var v_part             like pt_part no-undo .
define var del-yn             like mfc_logical initial no.
define var v_ii               as integer .


form
    site                 colon 18  label "地点"            si_desc no-label 
    v_nbr                colon 18  label "容器编码" 
    xxcase_desc          colon 18  label "容器描述" 
    xxcase_qty_ord       colon 18  label "总数量"
    skip(1)
    v_part               colon 18 label "物料编号"   
    pt_desc1             colon 52 label "说明"
    pt_um                colon 18 label "单位"
    pt_desc2             colon 52 no-label 
    xxcased_qty_per      colon 18 label "数量" 
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



    update site  v_nbr with frame a editing:
         if frame-field = "site" then do:
             {mfnp11.i xxcase_mstr  xxcase_nbr xxcase_site " input site"  }
             if recno <> ? then do:
                disp 
                    xxcase_site @ site
                    xxcase_nbr  @ v_nbr 
                    xxcase_desc
                    xxcase_qty_ord 
                with frame a .
                find first si_mstr where si_site = input site no-lock no-error.
                if avail si_mstr then disp si_desc with frame a .
             end . /* if recno <> ? then  do: */
         end.
         else if frame-field = "v_nbr" then do:
             {mfnp11.i xxcase_mstr  xxcase_nbr "xxcase_site = input site  and xxcase_nbr" " input v_nbr"  }
             if recno <> ? then do:
                disp 
                    xxcase_site @ site
                    xxcase_nbr  @ v_nbr 
                    xxcase_desc
                    xxcase_qty_ord 
                with frame a .
             end . /* if recno <> ? then  do: */
         end.
         else do:
                   status input ststatus.
                   readkey.
                   apply lastkey.
         end.
    end. /* update..EDITING */

    mstrloop:
    do on error undo ,retry on endkey undo, leave:
        find first xxcase_mstr 
            where xxcase_site = site 
            and   xxcase_nbr  = v_nbr 
        exclusive-lock no-error .
        if not avail xxcase_mstr then do :
                {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1} 
                create xxcase_mstr .
                assign xxcase_nbr      = v_nbr
                       xxcase_site     = site
                       xxcase_mod_user = global_userid
                       xxcase_mod_date = today 
                       .
        end.
        else do:
            {pxmsg.i &MSGNUM=10 &ERRORLEVEL=1} 
        end.

        find first si_mstr where si_site = site no-lock no-error.
        if avail si_mstr then disp si_desc with frame a .

        disp 
            xxcase_site @ site
            xxcase_nbr  @ v_nbr 
            xxcase_desc
            xxcase_qty_ord 
        with frame a . 

        update 
            xxcase_desc
            xxcase_qty_ord 
        go-on (F5 CTRL-D)
        with frame a .

        if (lastkey = keycode("F5") or
            lastkey = keycode("CTRL-D"))
        then do:
            find first xxcased_det 
                where xxcased_site = site
                and   xxcased_nbr  = v_nbr
            no-lock no-error.
            if avail xxcased_det then do:
                message "错误:容器绑定物料,不允许删除".
                undo,retry.
            end.

            del-yn = yes.
            {mfmsg01.i 11 1 del-yn}

            if del-yn then do:
                delete xxcase_mstr .
                {pxmsg.i &MSGNUM=24 &ERRORLEVEL=3 }
                clear frame a all no-pause.
                next mainloop.
            end.
            else undo, retry.
        end. /* CTRL-D */

        assign  xxcase_mod_date = today 
                xxcase_mod_user = global_userid
                .


        detloop:
        repeat with frame a:
            update 
                v_part 
            with frame a editing:
                 if frame-field = "v_part" then do:
                     {mfnp11.i xxcased_det  xxcased_nbr "xxcased_site = site and xxcased_nbr = v_nbr  and xxcased_part" " input v_part"  }
                     if recno <> ? then do:
                        disp 
                            xxcased_part  @ v_part
                            xxcased_qty_per
                        with frame a .

                        find first pt_mstr where pt_part = xxcased_part no-lock no-error .
                        if avail pt_mstr then 
                        disp pt_desc1 pt_desc2 pt_um with frame a .

                     end . /* if recno <> ? then  do: */
                 end.
                 else do:
                           status input ststatus.
                           readkey.
                           apply lastkey.
                 end.
            end. /* update..EDITING */

            find first pt_mstr where pt_part = v_part no-lock no-error .
            if avail pt_mstr then 
            disp pt_desc1 pt_desc2 pt_um with frame a .


            setloop:
            do on error undo,retry on endkey undo, leave:
                find first xxcased_det 
                    where xxcased_site = site
                    and   xxcased_nbr  = v_nbr 
                    and   xxcased_part = v_part
                exclusive-lock no-error .
                if not avail xxcased_det then do :
                        {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1} 
                        create xxcased_det .
                        assign xxcased_nbr      = v_nbr 
                               xxcased_site     = site
                               xxcased_part     = v_part
                               xxcased_mod_user = global_userid
                               xxcased_mod_date = today 
                               .
                end.

                disp 
                    xxcase_site @ site
                    xxcase_nbr  @ v_nbr 
                    xxcase_desc
                    xxcase_qty_ord 
                    xxcased_part  @ v_part
                    xxcased_qty_per
                with frame a . 

                update 
                    xxcased_qty_per 
                go-on (F5 CTRL-D)
                with frame a .

                if (lastkey = keycode("F5") or
                    lastkey = keycode("CTRL-D"))
                then do:
                    del-yn = yes.
                    {mfmsg01.i 11 1 del-yn}

                    if del-yn then do:
                        delete xxcased_det .
                        {pxmsg.i &MSGNUM=24 &ERRORLEVEL=3 }
                        
                        v_part = "".
                        disp 
                            v_part
                            "" @ pt_Desc1
                            "" @ pt_desc2
                            "" @ pt_um
                            "" @ xxcased_qty_per
                        with frame a.

                        next detloop.
                    end.
                    else undo, retry.
                end. /* CTRL-D */

                assign xxcased_mod_date = today 
                       xxcased_mod_user = global_userid
                       .
            
            end. /* setloop: */
        end.  /*detloop:*/    

    end. /*  mstrloop: */

end.   /*  mainloop: */
status input.

