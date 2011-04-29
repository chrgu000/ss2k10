/* xsquit.p �뿪SFCϵͳ,���������û������л�������ҵ                       */
/* REVISION: 1.0         Last Modified: 2008/12/01   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/

/*{mfdeclre.i}*/    /*mfgpro global vars & functions*/
/*{gplabel.i}*/     /*mfgpro externalized label include */
{xsmf002var01.i }  /*all shared vars  defines here */


/*      
{gpglefv.i} /*var for xsglefchk001.i (gpglef1.p) */
{xsglefchk001.i &module =""IC""  &entity =""""  &date =today } /*����ڼ���*/
       */



/*����Ƿ������Ļ���v_tail_wc*/
{xstimetail01.i}

/*����Ƿ���ͣ���û�,����,����,*/
/*֮ǰ����v_tail_wc  {xstimetail01.i} or {xsfbchk001.i} */
{xstimepause01.i}





define var v_now  as char label "ʱ��" format "x(20)" .
form
    v_user    label "����Ա" format "x(16)"
    v_wc      label "����"  
    xwc_desc   format "x(10)" no-label 
    v_now     label "ʱ��"  colon 57
with frame top1 
title color normal " ZBIOMET SHOPFLOOR SYSTEM "
side-labels 
width 80  .   


hide all no-pause .
define var v_leave as logical format "Y/N".
mainloop:
repeat: /*leave*/

    {xsquit01.i} /*�ҳ�δ��ָ��*/
    

    /*��ʾ����Ա/����/ʱ��*/
    view frame top1 .
    v_now = string(string(year(today),"9999") + "/" 
            + string(month(today),"99") + "/" 
            + string(day(today),"99") + " " 
            + string(time,"HH:MM:SS") ) .
    disp v_now with frame top1.

    find first xemp_mstr where xemp_addr = v_user no-lock no-error .
    if avail xemp_mstr then disp caps(xemp_addr + " -" + xemp_lname) @ v_user with frame top1 .

    find first xwc_mstr where xwc_wkctr = v_wc no-lock no-error .
    if avail xwc_mstr then disp xwc_wkctr @ v_wc  entry(max(1,num-entries(xwc_desc, "/")),xwc_desc,"/") @ xwc_desc  with frame top1 .


    

    /*��ʾδ��ָ��*/
    view frame b .
    loopdisp: 
    for each tt no-lock ,
        each xxfb_hist
        where recid(xxfb_hist) = t_rec  
        break by xxfb_trnbr
        on endkey undo, leave loopdisp 
        with frame b 
        title color normal "δ��ָ���嵥"
        13 down width 80:

        display
            xxfb_trnbr                      format ">>>>>>"  label "���׺�"
            xxfb_wc                         format "x(8)"    label "����"
            xxfb_type                       format "x(2)"    column-label "ָ!��"
            xxfb_type2                      format "x(9)"    label "��������"
            xxfb_date                                        label "��������"
            string(xxfb_time_start,"HH:MM") format "x(5)"    column-label "��ʼ!ʱ��"
            /*string(xxfb_time_end,"HH:MM")*/
            "    "                          format "x(4)"    column-label "����!ʱ��"
            xxfb_wolot                      format "x(7)"    label "����ID"
            xxfb_op                         format ">9"      label "OP"
            
            xxfb_rmks                       format "x(13)"   label "��ע"
        with frame b.
        down 1 with frame b.

        if frame-line(b) = frame-down(b) then pause.

    end. /*for each,  loopdisp*/
    message "�б����" .

    v_leave = yes .
    find first tt no-lock no-error .
    if not avail tt then do:
        message "��δ��ָ��,��������˳�ϵͳ..." view-as alert-box title "" .
        quit .
    end.
    else do:
        message "ȫ������,���˳�ϵͳ ?" /*���û��ڵ�ǰ����   view-as alert-box buttons Yes-No title ""*/  update v_leave .
        if v_leave then do:
            {xsquit02.i} /*����δ��ָ��*/
            v_msgtxt = "ָ���ѽ���" .
            quit.
        end. /*if v_leave*/
    end.

leave .
end. /*leave*/

hide frame top1 no-pause .
hide frame b no-pause .
