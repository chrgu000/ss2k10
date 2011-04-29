/* xxseqmt.p - �����߷����Ӱ�ʱ������ά��  */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110328.1  By: Roger Xiao */ /* created */
/*-Revision end---------------------------------------------------------------*/

{mfdtitle.i "110328.1"}

define var site               like xxpsq_site .
define var v_line             like xxpsq_line  .
define var v_seq              like xxpsq_seq  .

define var del-yn             like mfc_logical initial no.
define var v_ii               as integer .




form
    site                      colon 18  label "�ص�"     si_desc no-label
    v_line                    colon 18  label "������"   ln_desc no-label
    v_seq                     colon 18  label "˳��" 

    skip(1)
    xxpsq_part                colon 18  label "������"  
    pt_desc1                  colon 52  label "˵��"
    pt_um                     colon 18  label "��λ"
    pt_desc2                  colon 52  no-label  

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
        v_line
        v_seq
    with frame a editing:
         if frame-field = "site" then do:
             {mfnp11.i xxpsq_det  xxpsq_line xxpsq_site " input site"  }
             if recno <> ? then do:
                find first si_mstr where si_site = xxpsq_site no-lock no-error.
                if avail si_mstr then disp si_desc with frame a .

                find first ln_mstr where ln_line = xxpsq_line and ln_site = xxpsq_site no-lock no-error.
                if avail ln_mstr then disp ln_desc with frame a .

                find first pt_mstr where pt_part = xxpsq_part no-lock no-error.
                if avail pt_mstr then disp pt_desc1 pt_Desc2 pt_um  with frame a .

                disp 
                    xxpsq_site  @ site
                    xxpsq_line  @ v_line  
                    xxpsq_seq   @ v_seq 
                    xxpsq_part  
                with frame a .
             end . /* if recno <> ? then  do: */
         end.
         else if frame-field = "v_line" then do:
             {mfnp11.i xxpsq_det  xxpsq_line "xxpsq_site = input site and xxpsq_line" "input v_line"  }
             if recno <> ? then do:
                find first ln_mstr where ln_line = xxpsq_line and ln_site = xxpsq_site no-lock no-error.
                if avail ln_mstr then disp ln_desc with frame a .

                find first pt_mstr where pt_part = xxpsq_part no-lock no-error.
                if avail pt_mstr then disp pt_desc1 pt_Desc2 pt_um  with frame a .

                disp 
                    xxpsq_site  @ site
                    xxpsq_line  @ v_line  
                    xxpsq_seq   @ v_seq 
                    xxpsq_part  
                with frame a .
             end . /* if recno <> ? then  do: */
         end.
         else if frame-field = "v_seq" then do:
             {mfnp11.i xxpsq_det  xxpsq_line "xxpsq_site = input site and xxpsq_line = input v_line and xxpsq_seq " "input v_seq"  }
             if recno <> ? then do:
                find first ln_mstr where ln_line = xxpsq_line and ln_site = xxpsq_site no-lock no-error.
                if avail ln_mstr then disp ln_desc with frame a .

                find first pt_mstr where pt_part = xxpsq_part no-lock no-error.
                if avail pt_mstr then disp pt_desc1 pt_Desc2 pt_um  with frame a .

                disp 
                    xxpsq_site  @ site
                    xxpsq_line  @ v_line  
                    xxpsq_seq   @ v_seq 
                    xxpsq_part  
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
        message "����:��Ч�ص�,����������" .
        undo,retry.
    end.

    find first ln_mstr where ln_line = v_line and ln_site = site no-lock no-error.
    if not avail ln_mstr then do:
        message "����:��Ч������/�ص�,����������" .
        next-prompt v_line with frame a .
        undo,retry.
    end.

    disp si_desc ln_desc with frame a .


    setloop:
    do on error undo ,retry on endkey undo, leave:
        find first xxpsq_det 
          where xxpsq_site   = site 
            and xxpsq_line   = v_line
            and xxpsq_seq    = v_seq 
        exclusive-lock no-error .
        if not avail xxpsq_det then do :
                {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1} 
                create xxpsq_det .
                assign xxpsq_site   = site       
                       xxpsq_line   = v_line
                       xxpsq_seq    = v_seq
                       .
        end.
        else do:
            {pxmsg.i &MSGNUM=10 &ERRORLEVEL=1} 
        end.

        find first pt_mstr where pt_part = xxpsq_part no-lock no-error.
        if avail pt_mstr then disp pt_desc1 pt_Desc2 pt_um  with frame a .
        
        disp 
                    xxpsq_site  @ site
                    xxpsq_line  @ v_line  
                    xxpsq_seq   @ v_seq 
                    xxpsq_part  
        with frame a . 

        update 
                xxpsq_part
        go-on (F5 CTRL-D)
        with frame a .

        if (lastkey = keycode("F5") or
            lastkey = keycode("CTRL-D"))
        then do:
            del-yn = yes.
            {mfmsg01.i 11 1 del-yn}
            if del-yn then do:
                delete xxpsq_det .
                {pxmsg.i &MSGNUM=24 &ERRORLEVEL=3 }
                clear frame a all no-pause.
                next mainloop.
            end.
            else undo, retry.
        end. /* CTRL-D */

        find first pt_mstr where pt_part = xxpsq_part no-lock no-error.
        if not avail pt_mstr then do:
            message "����:�����Ų�����,����������" .
            undo,retry.
        end.
        disp pt_desc1 pt_Desc2 pt_um  with frame a .


        assign  xxpsq_mod_date   = today 
                xxpsq_mod_user   = global_userid
                .

    end. /*  setloop: */
end.   /*  mainloop: */
status input.

