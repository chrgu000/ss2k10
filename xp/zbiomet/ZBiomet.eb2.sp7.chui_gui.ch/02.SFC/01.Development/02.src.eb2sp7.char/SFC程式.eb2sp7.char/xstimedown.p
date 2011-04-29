/* xstimedown.p ͣ��ʱ��                                                   */
/* REVISION: 1.0         Last Modified: 2008/12/01   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/

/*{mfdeclre.i}*/    /*mfgpro global vars & functions*/
/*{gplabel.i}*/     /*mfgpro externalized label include */
{xsmf002var01.i }  /*all shared vars  defines here */

{xscanrun001.i}  /*security load & check procedure define   */

/*    
{gpglefv.i} /*var for xsglefchk001.i (gpglef1.p) */
{xsglefchk001.i &module =""IC""  &entity =""""  &date =today } /*����ڼ���*/
*/


/*����Ƿ������Ļ���v_tail_wc*/
{xstimetail01.i}

/*����Ƿ���ͣ���û�,����,����,*/
/*֮ǰ����v_tail_wc  {xstimetail01.i} or {xsfbchk001.i} */
{xstimepause01.i}



/*
ָ����Ҫ�����޸ĵ��ļ�:
*/ 






define var v_fld_dt as char label "downtimeָ��ͨ�ô�������ֶ���" .   v_fld_dt = v_fldname + "-Downtime" .
define var v_txt as char format "x(20)" extent 10 .
define var v_ii as integer .



form
    " ����ͣ��ʱ��ָ��:" skip 
    " 1)"  colon 3      v_txt[01]   colon 10  no-label 
    " 2)"  colon 3      v_txt[02]   colon 10  no-label 
    " 3)"  colon 3      v_txt[03]   colon 10  no-label 
    " 4)"  colon 3      v_txt[04]   colon 10  no-label 
    " 5)"  colon 3      v_txt[05]   colon 10  no-label 
    " 6)"  colon 3      v_txt[06]   colon 10  no-label 
    " 7)"  colon 3      v_txt[07]   colon 10  no-label 
    " 8)"  colon 3      v_txt[08]   colon 10  no-label 
    " 9)"  colon 3      v_txt[09]   colon 10  no-label 
                        v_txt[10]   colon 10  no-label 
    skip(1)
    v_line      colon 10  label "����ָ��"
with frame a 
title color normal "ͣ��ʱ��"
side-labels width 60 
row 3 centered overlay .   

view frame a .

mainloop:
repeat :
    update_loop:
    do on error undo,retry: 
        v_line = "" .
        v_txt[01]  = "" .
        v_txt[02]  = "" .
        v_txt[03]  = "" .
        v_txt[04]  = "" .
        v_txt[05]  = "" .
        v_txt[06]  = "" .
        v_txt[07]  = "" .
        v_txt[08]  = "" .
        v_txt[09]  = "" .
        v_txt[10]  = "" .

        v_ii = 0 .
        for each xcode_mstr where xcode_fldname = v_fld_dt and xcode_cmmt <> "" no-lock :
            if index(xcode_cmmt, "@") <> 0 and trim(entry(2,xcode_cmmt,"@")) <> "" then do:
                v_ii = v_ii + 1 .
                v_txt[v_ii] = xcode_value + " " + entry(1,xcode_cmmt,"@").
            end.
        end .

        disp  
             v_txt[01]
             v_txt[02]
             v_txt[03]
             v_txt[04]
             v_txt[05]
             v_txt[06]
             v_txt[07]
             v_txt[08]
             v_txt[09]
             v_txt[10]
             v_line   
        with frame a .

        update v_line with frame a .

        {xserr001.i "v_line" } /*���������λ�Ƿ��������ʺ�*/

        if v_line = "" then do:
            message "ָ���Ϊ��,����������" .
            undo,retry .
        end.

        find first xcode_mstr where xcode_fldname = v_fld_dt and xcode_value = v_line no-lock no-error .
        if not avail xcode_mstr then do:
            message "��Чָ��,����������" .
            undo,retry .
        end.
        if index(xcode_cmmt, "@") = 0 then do:
            message "ָ���趨����,�������趨" .
            undo,retry .            
        end.
        if entry(2,xcode_cmmt,"@") = "" then do:
            message "ָ���趨����,�������趨" .
            undo,retry .  
        end.
        if entry(2,xcode_cmmt,"@") <> "" and index(entry(2,xcode_cmmt,"@"),".p") <> 0 then do:
            if search(trim(entry(2,xcode_cmmt,"@"))) = ? then do:
                message "ָ���޷�ִ��,��֪ͨIT�����" .
                undo,retry .  
            end.
            /*�ļ���ȡ��ִ��Ȩ��??*/
        end.

        {xslnchk002.i}         /*���:���ָ���ѭ���߼�*/

        find first xcode_mstr where xcode_fldname = v_fld_dt and xcode_value = v_line no-lock no-error .
        execname = "" .
        run checksecurity (input trim(entry(2,xcode_cmmt,"@")) , input v_user , output execname ).
        if execname = ""  then do:
            message "��Ȩ��ִ��ָ��,��ȷ��." .
            undo,retry .
        end.
    end. /*update_loop*/

    hide frame a no-pause .
    run value(execname) .  /*ִ��ָ��*/      
    
leave .
end. /*mainloop:*/
hide frame a no-pause .
