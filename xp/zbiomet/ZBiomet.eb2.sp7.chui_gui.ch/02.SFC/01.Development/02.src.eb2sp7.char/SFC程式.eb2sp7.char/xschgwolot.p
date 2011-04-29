/* xschgwolot.p 切换工单                                                 */
/* REVISION: 1.0         Last Modified: 2008/12/01   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/

/*{mfdeclre.i}*/    /*mfgpro global vars & functions*/
/*{gplabel.i}*/     /*mfgpro externalized label include */
{xsmf002var01.i }  /*all shared vars  defines here */

/* 
{gpglefv.i} /*var for xsglefchk001.i (gpglef1.p) */
{xsglefchk001.i &module =""IC""  &entity =""""  &date =today } /*会计期间检查*/
            */



define var v_txt as char format "x(12)" .

form
    skip(1)
    v_sn1    colon 20  label "当前工单条码"
    v_txt   colon 20  label "转到工单条码"
    skip(1)
with frame a 
title color normal "切换工单"
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
                message "加工单条码格式有误,请重新刷读" .
                undo,retry .
            end.
            if v_txt = v_sn1 then do:
                message "已在目标工单工序,不需转移." .
                undo,retry .
            end.
            
            v_sn1   = v_txt.
            v_op    = integer(entry(2,trim(v_txt),"+")) .
            v_wolot = entry(1,trim(v_txt),"+") .
            v_line  = "" .
            find first xwo_mstr where xwo_lot = v_wolot no-lock no-error .
            if not avail xwo_mstr then do:
                message "无效加工单:" v_wolot " 请重新刷读条码" .
                undo,retry .
            end.
            else do:
                /*if xwo_status <> "R" then do:
                    message "加工单状态:" xwo_status " 请重新刷读条码" .
                    undo,retry .
                end. *//*xp-wo-stat*/

                v_wonbr = xwo_nbr .
            end.
        end.
        else do:
            message "工单条码不可为空,请重新刷读." .
            undo,retry .
        end.
        
        
    end. /*do on error undo,retry*/

leave .
end. /*chgmachine:*/

hide frame a no-pause.
