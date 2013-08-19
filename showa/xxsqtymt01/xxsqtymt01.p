/* xxsqtymt01.p ȫ�갲ȫ���ά��                                              */
/* REVISION: 090717.1      Create Date: 20090717  BY: Softspeed roger xiao    */
/* SS - 101215.1  By: Roger Xiao */  /*remove xsqty_date from disp            */
/*-Revision end---------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "130807.1"}

define var part    like xsqty_part .
define var site    like xsqty_site .
define var desc1   like pt_desc1.
define var desc2   like pt_desc2 .
define var del-yn  like mfc_logical initial yes.
define var v_i     as integer.
define var v_sqty  as decimal extent 12 no-undo.

form
    SKIP(.2)
    part                     colon 18
    desc1                    colon 52
    site                     colon 18
    desc2                    colon 52 no-label
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

form
    v_sqty[01] colon 15 label "01��"   v_sqty[07] colon 52 label "07��"
    v_sqty[02] colon 15 label "02��"   v_sqty[08] colon 52 label "08��"
    v_sqty[03] colon 15 label "03��"   v_sqty[09] colon 52 label "09��"
    v_sqty[04] colon 15 label "04��"   v_sqty[10] colon 52 label "10��"
    v_sqty[05] colon 15 label "05��"   v_sqty[11] colon 52 label "11��"
    v_sqty[06] colon 15 label "06��"   v_sqty[12] colon 52 label "12��"
    skip(3)
    "��ע:" colon 10
    "1.�ص�:����Ϊ���еص�İ�ȫ���,�����Ϊָ���ص�İ�ȫ���"  colon 10
    "2.�·�:�ӵ�ǰ���ڿ�ʼ��������.  ��:���統ǰ����Ϊ2009/8/1,"  colon 10
    "       ��08��-12��Ϊ������·�,01��-07��Ϊ������·�"        colon 10
    "3.ά�������� xxsqtymt02.p"                                   colon 10
with frame b title color normal "���°�ȫ���" side-labels width 80 attr-space.
setFrameLabels(frame b:handle).

/* DISPLAY */
view frame a.
view frame b.

mainloop:
repeat with frame a:
    clear frame a no-pause .
    clear frame b no-pause .


    ststatus = stline[1].
    status input ststatus.

    update part site with frame a editing:
         if frame-field = "part" then do:
             {mfnp.i pt_mstr part  pt_part  part pt_part pt_part}
             if recno <> ? then do:
                    display pt_part @ part pt_desc1 @ desc1 pt_desc2 @ desc2 pt_site @ site with frame a .
             end . /* if recno <> ? then  do: */
         end.
         else  if frame-field = "site" then do:
             {mfnp01.i xsqty_mstr  site xsqty_site  part  xsqty_part  xsqty_part}
             if recno <> ? then do:
                    find pt_mstr where pt_part = xsqty_part no-lock no-error .
                    desc1 = if avail pt_mstr then pt_desc1 else "" .
                    desc2 = if avail pt_mstr then pt_desc2 else "" .
                    disp xsqty_part @ part desc1 desc2 xsqty_site @ site with frame a .
                    disp
                         xsqty_sqty[01] @ v_sqty[01]
                         xsqty_sqty[02] @ v_sqty[02]
                         xsqty_sqty[03] @ v_sqty[03]
                         xsqty_sqty[04] @ v_sqty[04]
                         xsqty_sqty[05] @ v_sqty[05]
                         xsqty_sqty[06] @ v_sqty[06]
                         xsqty_sqty[07] @ v_sqty[07]
                         xsqty_sqty[08] @ v_sqty[08]
                         xsqty_sqty[09] @ v_sqty[09]
                         xsqty_sqty[10] @ v_sqty[10]
                         xsqty_sqty[11] @ v_sqty[11]
                         xsqty_sqty[12] @ v_sqty[12]
                    with frame b.
             end . /* if recno <> ? then  do: */
         end.
         else do:
                   status input ststatus.
                   readkey.
                   apply lastkey.
         end.
    end. /* update...EDITING */

    find first pt_mstr where pt_part = part no-lock no-error.
    if not avail pt_mstr  then do :
        message "����:�ϼ�������" .
        undo mainloop, retry mainloop.
    end.

    if site <> "" and ( not can-find(si_mstr where si_site = site ) ) then do:
        message "����:�ص㲻����"  .
        undo mainloop, retry mainloop.
    end.


    find pt_mstr where pt_part = part no-lock no-error .
    desc1 = if avail pt_mstr then pt_desc1 else "" .
    desc2 = if avail pt_mstr then pt_desc2 else "" .
    disp part desc1 desc2 site with frame a .

    find  xsqty_mstr where xsqty_part = part
                       and xsqty_site = site exclusive-lock no-error .
    if not avail xsqty_mstr then do :
            {mfmsg.i 1 1 }
            create xsqty_mstr.
            assign xsqty_part =  part
                   xsqty_site =  site
                   xsqty_user =  global_userid
                   xsqty_date =  today.
    end.


    v_i = 0 .
    do v_i = 1 to 12 :
        assign v_sqty[v_i] = xsqty_sqty[v_i] .
    end.

    disp
            v_sqty[1]
            v_sqty[2]
            v_sqty[3]
            v_sqty[4]
            v_sqty[5]
            v_sqty[6]
            v_sqty[07]
            v_sqty[08]
            v_sqty[09]
            v_sqty[10]
            v_sqty[11]
            v_sqty[12]
    with frame b .

    setloop:
    do on error undo ,retry :
        update
                v_sqty[1]
                v_sqty[2]
                v_sqty[3]
                v_sqty[4]
                v_sqty[5]
                v_sqty[6]
                v_sqty[07]
                v_sqty[08]
                v_sqty[09]
                v_sqty[10]
                v_sqty[11]
                v_sqty[12]
        go-on ("f5" "ctrl-d")
        with frame b editing :
                readkey.
                if ( lastkey = keycode("f5") or lastkey = keycode("ctrl-d") ) then do:
                    {mfmsg01.i 11 1 del-yn }
                    /*message "ȷ��ɾ��?" view-as alert-box question buttons yes-no title "" update choice as logical.
                    if choice then do :*/
                    if del-yn then do :
                            delete xsqty_mstr .
                            next mainloop .
                    end.
                end. /*   "f5" "ctrl-d" */
                else apply lastkey.
        end. /* update ...editing */

        v_i = 0 .
        do v_i = 1 to 12 :
            if v_sqty[v_i] < 0 or v_sqty[v_i] = ?   then do:
                message "����:��ȫ�����������Ϊ����.����������" .
                next-prompt v_sqty[v_i] with frame b .
                undo,retry .
            end.
        end.

        v_i = 0 .
        do v_i = 1 to 12 :
            assign xsqty_sqty[v_i] = v_sqty[v_i].
        end.
        assign
            xsqty_user = global_userid
            xsqty_date = today .
    end. /*  setloop: */
end.   /*  mainloop: */
status input.