/* xschgwolot.p �л�����                                                 */
/* REVISION: 1.0         Last Modified: 2008/12/01   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/

/*{mfdeclre.i}*/    /*mfgpro global vars & functions*/
/*{gplabel.i}*/     /*mfgpro externalized label include */
{xsmf002var01.i }  /*all shared vars  defines here */

/* 
{gpglefv.i} /*var for xsglefchk001.i (gpglef1.p) */
{xsglefchk001.i &module =""IC""  &entity =""""  &date =today } /*����ڼ���*/
            */



define var v_txt as char format "x(12)" .

form
    skip(1)
    v_sn1    colon 20  label "��ǰ��������"
    v_txt   colon 20  label "ת����������"
    skip(1)
with frame a 
title color normal "�л�����"
side-labels width 50 
row 8 centered overlay .   

view frame a .

v_txt  = v_sn1 .

chgmachine:
repeat: 
    do on error undo,retry :
        disp v_sn1 v_txt with frame a.
        update v_txt with frame a .
        assign v_txt.


        if v_txt <> "" then do:
            if index(v_txt, "+") = 0 then do:
                message "�ӹ��������ʽ����,������ˢ��" .
                undo,retry .
            end.
            if v_txt = v_sn1 then do:
                message "����Ŀ�깤������,����ת��." .
                undo,retry .
            end.
            
            v_sn1   = v_txt.
            v_op    = integer(entry(2,trim(v_txt),"+")) .
            v_wolot = entry(1,trim(v_txt),"+") .
            v_line  = "" .
            find first xwo_mstr where xwo_lot = v_wolot no-lock no-error .
            if not avail xwo_mstr then do:
                message "��Ч�ӹ���:" v_wolot " ������ˢ������" .
                undo,retry .
            end.
            else do:
                /*if xwo_status <> "R" then do:
                    message "�ӹ���״̬:" xwo_status " ������ˢ������" .
                    undo,retry .
                end. *//*xp-wo-stat*/

                v_wonbr = xwo_nbr .
            end.
        end.
        else do:
            message "�������벻��Ϊ��,������ˢ��." .
            undo,retry .
        end.
        
        
    end. /*do on error undo,retry*/

leave .
end. /*chgmachine:*/

hide frame a no-pause.
