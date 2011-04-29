/* xschgmachine.p �л�����                                                 */
/* REVISION: 1.0         Last Modified: 2008/12/01   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/

/*{mfdeclre.i}*/    /*mfgpro global vars & functions*/
/*{gplabel.i}*/     /*mfgpro externalized label include */
{xsmf002var01.i }  /*all shared vars  defines here */

define var v_txt as char format "x(12)" .

form
    skip(1)
    v_wc    colon 20  label "��ǰ����"
    v_txt   colon 20  label "ת������"
    skip(1)
with frame a 
title color normal "�л�����"
side-labels width 50 
row 8 centered overlay .   

view frame a .

v_txt  = v_wc .

chgmachine:
repeat: 
    do on error undo,retry :
        disp v_wc v_txt with frame a.
        update v_txt with frame a editing:
            if frame-field = "v_txt" then do:
                {xstimeout02.i " quit "    } 
                {xsmfnp11.i xwc_mstr xwc_wkctr  xwc_wkctr "input v_txt"  }
                if recno <> ? then do:
                    display xwc_wkctr @ v_txt with frame a .
                end. /* if recno <> ? */
            end. /* if frame-field = "v_suer" */   
            else do:
                status input.
                readkey.
                apply lastkey.                
            end. /* else do */
        end.
        assign v_txt.

        find first xwc_mstr where xwc_wkctr = v_txt no-lock no-error .
        if not avail xwc_mstr then do:
            message "��Ч��������,����������" .
            undo,retry .
        end.

        /*�ѹ�����������*/
        /*if v_wc <> v_txt then do:
            
            v_wolot = "" .
            v_op    = 0  .
            v_sn1   = "" .
            v_wonbr = "" .
            
            message "���л�����,������ˢ����������.".
        end.*/
        v_wc = v_txt.

        find first xxfb_hist 
            where xxfb_user = v_user
            and xxfb_wc     = v_wc 
        no-lock no-error .
        if avail xxfb_hist then do:
            for each xxfb_hist 
                where xxfb_user = v_user
                and xxfb_wc     = v_wc 
                no-lock 
                break by xxfb_user by xxfb_wc by xxfb_trnbr :
                if last-of(xxfb_user) then do:
                    v_wolot = xxfb_wolot .
                    v_op    = xxfb_op  .
                    v_sn1   = if xxfb_wolot <> "" then ( xxfb_wolot + "+" + string(xxfb_op) ) else ""  .
                    v_wonbr = xxfb_wonbr .
                    
                    message "�������л�.".
                end.
            end.
        end.
        else do:
            v_wolot = "" .
            v_op    = 0  .
            v_sn1   = "" .
            v_wonbr = "" .
            
            message "�������л�,������ˢ����������.".
        end.

    end. /*do on error undo,retry*/

leave .
end. /*chgmachine:*/

hide frame a no-pause.
