/* xxxovispm.p - �������Ͽ���  */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110104.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/

define var site like pt_site .

{mfdtitle.i "110104.1"}

form
    skip(.2)
    site                 colon 10 label "�ص�"    si_desc   no-label 
    xovc_nbr_pre         colon 10 label "����ǰ׺"
    xovc_nbr_next        colon 10 label "��һ����"
                         
                         skip(1)

    xovc_add_user        colon 10 label "�����û�"
    xovc_mod_user        colon 10 label "�޸��û�"
    xovc_del_user        colon 10 label "ɾ���û�"
                         skip(1)
    "  ��������  �����û�"  skip  
    space(2)
    xovc_app_lvl[1]       no-label 
    xovc_app_user[1]      no-label skip
    space(2)
    xovc_app_lvl[2]       no-label 
    xovc_app_user[2]      no-label skip
    space(2)
    xovc_app_lvl[3]       no-label 
    xovc_app_user[3]      no-label skip
    space(2)
    xovc_app_lvl[4]       no-label 
    xovc_app_user[4]      no-label skip
    space(2)
    xovc_app_lvl[5]       no-label 
    xovc_app_user[5]      no-label skip

    skip(3)
    "  ˵��:�û��嵥���ö��ŷָ�" skip
with frame a  
side-labels width 80 
title color normal "���������������"
attr-space.

view frame a.

find icc_ctrl no-lock no-error.
site = if avail icc_ctrl then icc_site else "" .
disp site with frame a .

mainloop:
repeat with frame a:
    ststatus = stline[1].
    status input ststatus.

    find first xovc_ctrl where xovc_site = site no-lock no-error .
    if avail xovc_ctrl then 
    disp 
        xovc_nbr_pre
        xovc_nbr_next
        xovc_add_user       
        xovc_mod_user       
        xovc_del_user       
        xovc_app_lvl[1]     
        xovc_app_lvl[2]     
        xovc_app_lvl[3]     
        xovc_app_lvl[4]     
        xovc_app_lvl[5]     
        xovc_app_user[1]    
        xovc_app_user[2]    
        xovc_app_user[3]    
        xovc_app_user[4]    
        xovc_app_user[5]   
    with frame a .

    update site with frame a editing:
         if frame-field = "site" then do:
             {mfnp.i si_mstr  site si_site  site  si_site  si_site}
             if recno <> ? then do:
                clear frame a no-pause.
                disp si_site @ site si_desc with frame a .

                find first xovc_ctrl where xovc_site = si_site no-lock no-error .
                if avail xovc_ctrl then 
                disp 
                    xovc_nbr_pre
                    xovc_nbr_next
                    xovc_add_user       
                    xovc_mod_user       
                    xovc_del_user       
                    xovc_app_lvl[1]     
                    xovc_app_lvl[2]     
                    xovc_app_lvl[3]     
                    xovc_app_lvl[4]     
                    xovc_app_lvl[5]     
                    xovc_app_user[1]    
                    xovc_app_user[2]    
                    xovc_app_user[3]    
                    xovc_app_user[4]    
                    xovc_app_user[5]   
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
        message "����:�ص㲻����,����������" .
        undo mainloop, retry mainloop.
    end.
    disp si_site @ site si_desc with frame a .

    find first xovc_ctrl where xovc_site = site no-lock no-error .
    if avail xovc_ctrl then 
    disp 
        xovc_nbr_pre
        xovc_nbr_next
        xovc_add_user       
        xovc_mod_user       
        xovc_del_user       
        xovc_app_lvl[1]     
        xovc_app_lvl[2]     
        xovc_app_lvl[3]     
        xovc_app_lvl[4]     
        xovc_app_lvl[5]     
        xovc_app_user[1]    
        xovc_app_user[2]    
        xovc_app_user[3]    
        xovc_app_user[4]    
        xovc_app_user[5]   
    with frame a .

    
    setloop:
    do on error undo ,retry :
        find first xovc_ctrl where xovc_site = site exclusive-lock no-error .
        if not avail xovc_ctrl then do :
                {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1} 
                create xovc_ctrl .
                assign xovc_site = site .
        end.

        update 
            xovc_nbr_pre
            xovc_nbr_next
            xovc_add_user       
            xovc_mod_user       
            xovc_del_user       
            xovc_app_lvl[1]     
            xovc_app_lvl[2]     
            xovc_app_lvl[3]     
            xovc_app_lvl[4]     
            xovc_app_lvl[5]     
            xovc_app_user[1]    
            xovc_app_user[2]    
            xovc_app_user[3]    
            xovc_app_user[4]    
            xovc_app_user[5]     
        go-on ("F5" "CTRL-D") with frame a editing :
                readkey.
                if ( lastkey = keycode("F5") or lastkey = keycode("CTRL-D") ) then do:
                    message "ȷ��ɾ��?" update choice as logical.
                    if choice then do :
                            delete xovc_ctrl .
                            next mainloop .
                    end.
                end. /*   "F5" "CTRL-D" */
                else apply lastkey.
        end. /* update ...EDITING */
    end. /*  setloop: */
end.   /*  mainloop: */
status input.
