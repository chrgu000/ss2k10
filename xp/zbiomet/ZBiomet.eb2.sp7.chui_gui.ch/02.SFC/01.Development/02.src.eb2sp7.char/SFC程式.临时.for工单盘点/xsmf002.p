/* xsmf002.p     BARCODE SFC SYSTEM MAIN FRAME                             */
/* REVISION: 1.0         Last Modified: 2008/11/27   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/



/*{mfdeclre.i}*/    /*mfgpro global vars & functions*/
/*{gplabel.i}*/     /*mfgpro externalized label include */

{xsmf002var01.i "new" }  /*all shared vars  defines & assigned here */
{xsmf002var02.i       }  /*all vars  defines here */
{xsmf002frm.i         }  /*all frame defines here */

/*һЩ��Ҫ�����ĸ�ֵ,��xsmf002var01.i*/

{xscanrun001.i}    /*procedure define for : menu security load & check    */
/*    
{gpglefv.i} /*var for xsglefchk001.i (gpglef1.p) */
/*{xsglefchk001.i &module =""IC""  &entity =""""  &date =today }   *����ڼ���,���ڸ�ָ��ǰ���,��xsfbchk001.i��*/
*/
         

v_user = "" .

loginloop:  
do on error undo,retry :
    hide frame login  no-pause .
    hide frame top1   no-pause .
    hide frame main1  no-pause .
    hide frame main2  no-pause .

    view frame login . 

    disp v_user v_pwd with frame login .

    update  v_user 
            v_pwd blank 
    with frame login editing:
        {xstimeout02.i " quit "   } /*readkey pause ...*/
        apply lastkey.
    end. /*update v_user*/
    assign v_user v_pwd .
    assign v_user = caps(v_user) v_pwd = caps(v_pwd).


    /*1--Ĭ���û������*/      
    find first xemp_mstr where xemp_addr = v_user no-lock no-error .
    if not avail xemp_mstr then do:
        message "��Ч�û�,����������!" .
        undo,retry .
    end.

    if xemp__chr01 <> encode(v_pwd)  then do:
        message "�������,����������!    "  .
        next-prompt v_pwd with frame login .
        undo,retry .
    end.

    /*2--���û���Ĭ�ϻ����͹���ID */
    find first xusrw_wkfl where xusrw_key1 = v_fldname  and   xusrw_key2 = v_user /*xptest*exclusive-lock /*3--�����û�,���ɶ�ε�½*/ no-wait*/ no-lock no-error .
    if avail xusrw_wkfl then do:
        v_wc   = xusrw_key3 .
        v_sn1  = xusrw_key4 .
    end.
    else do:  
        v_wc   = "" .
        v_sn1  = "" .
        find first xusrw_wkfl where xusrw_key1 = v_fldname  and   xusrw_key2 = v_user no-lock no-error .
        if not avail xusrw_wkfl then do:
            create  xusrw_wkfl .
            assign  xusrw_key1 = v_fldname
                    xusrw_key2 = v_user   .
            release xusrw_wkfl .
        end.
        else do:
        
        end.

/*xptest*
            find first xusrw_wkfl where xusrw_key1 = v_fldname  and   xusrw_key2 = v_user exclusive-lock /*3--�����û�,���ɶ�ε�½*/ no-error .    
        end.
        else do:
            release xusrw_wkfl .
            message "���û�������,�����ظ���½!" skip
                    "     ��������˳�...      "
            view-as alert-box title "����".
            undo,retry .
        end.
*/
    end.
    v_user2 = v_user .

end.  /*loginloop*/

mainloop:
repeat:
    loopa: /*����ά��*/
    do on error undo,retry  :
        hide frame login  no-pause .
        hide frame top1   no-pause .
        hide frame main1  no-pause .
        hide frame main2  no-pause .

        clear frame top1 no-pause .
        clear frame main1 no-pause.
        clear frame main2 no-pause .

        view frame top1  .
        view frame main1 .
        view frame main2 .     
        
        find first xwc_mstr where xwc_wkctr = v_wc no-lock no-error .
        if not avail xwc_mstr then do:
            {xsmf002now01.i} /*ˢ����ʾtop1*/

            update v_wc with frame top1 editing:
                    if frame-field = "v_wc" then do:
                        {xstimeout02.i " quit "    } 
                        {xsmfnp11.i xwc_mstr xwc_wkctr  xwc_wkctr "input v_wc"  }
                        if recno <> ? then do:
                            display xwc_wkctr @ v_wc  entry(max(1,num-entries(xwc_desc, "/")),xwc_desc,"/") @ xwc_desc   with frame top1 .
                        end. 
                    end. 
                    else do:
                        status input.
                        readkey . 
                        apply lastkey.  
                    end. 
            end. /*update v_user*/
            assign v_wc .


        end. /*if not avail xwc_mstr then*/

        find first xwc_mstr where xwc_wkctr = v_wc no-lock no-error .
        if not avail xwc_mstr then do:
            message "��Ч��������,����������" .
            next-prompt v_wc with frame top1 .
            undo,retry .
        end.
        v_msgtxt = "" .



        {xsmf002now01.i} /*ˢ����ʾtop1*/

        loopc: 
        repeat :
                run loopsn. /*ˢ����������*/ 
                run loopx.  /*ˢ��ָ������*/                
                
        end. /*loopc*/
    end. /*loopa*/
    /*leave .*/ /*F4-ֱ���˳�*/
end. /*mainloop*/





procedure loopsn:
do on error undo,retry :
    {xsmf002now01.i} /*ˢ����ʾtop1*/
    clear frame main2 no-pause.
    find first xemp_mstr where xemp_addr = v_user no-lock no-error .
    if avail xemp_mstr then v_user_name = xemp_lname .

    update v_user_name v_wc v_sn1 with frame main2  editing:
        if frame-field = "v_user_name" then do:
                    {xstimeout02.i " quit "    } 
                    {xsmfnp11.i xemp_mstr xemp_name  xemp_lname "input v_user_name"  }
                    if recno <> ? then do:
                        disp xemp_lname @ v_user_name xemp_addr with frame main2 .
                    end. /* if recno <> ? */
        end.
        else if frame-field = "v_wc"  then do:
                    {xstimeout02.i " quit "    } 
                    {xsmfnp11.i xwc_mstr xwc_wkctr  xwc_wkctr "input v_wc"  }
                    if recno <> ? then do:
                        disp xwc_wkctr @ v_wc  entry(max(1,num-entries(xwc_desc, "/")),xwc_desc,"/") @ xwc_desc  with frame main2 .
                    end. /* if recno <> ? */
        end.
        else do:
            readkey .
            apply lastkey.
        end.
    end. /*update*/
    assign v_sn1 .

    find first xemp_mstr use-index  xemp_name where xemp_lname = v_user_name no-lock no-error .
    if avail xemp_mstr then do:
        v_user = xemp_addr .
        disp xemp_lname @ v_user_name xemp_addr with frame main2 .
    end.
    else do:
        /*v_user����,Ϊ���һ���û�*/
    end.

    find first xwc_mstr where xwc_wkctr = v_wc no-lock no-error .
    if not avail xwc_mstr then do:
        message "��Ч��������,����������" .
        undo,retry .
    end.

    disp xwc_wkctr @ v_wc  entry(max(1,num-entries(xwc_desc, "/")),xwc_desc,"/") @ xwc_desc  with frame main2 .


    if v_sn1 <> "" then do:
        if index(v_sn1, "+") = 0 then do:
            message "�ӹ��������ʽ����,������ˢ��" .
            undo,retry .
        end.
        v_op    = integer(entry(2,trim(v_sn1),"+")) .
        v_wolot = entry(1,trim(v_sn1),"+") .

        find first xxwrd_det where xxwrd_wolot = v_wolot no-lock no-error .
        if avail xxwrd_det then do:  /*��ͬ������wolot*/
            v_wonbr = xxwrd_wonbr .
            find first xxwrd_det where xxwrd_wolot = v_wolot and xxwrd_op = v_op no-lock no-error .
            if not avail xxwrd_det then do:
                message "��ЧSFC��������:" v_wolot "/" v_op " ,������ˢ��" .
                undo,retry .
            end.
        end. /*��ͬ������wolot*/
        else do:  /*�״�ˢ����wolot*/
            find first xwr_route where xwr_lot = v_wolot and xwr_op = v_op no-lock no-error .
            if not avail xwr_route then do:
                message "��Ч�ӹ���/����:" v_wolot "/" v_op " ,������ˢ��" .
                undo,retry .
            end.
            else do:
                v_wonbr = xwr_nbr .
            end.
        end.  /*�״�ˢ����wolot*/
    end. /*if v_sn1 <> ""*/
    else do:
        v_op    = 0 .
        v_wolot = "" .
        v_wonbr = "" .
    end.
    
    disp v_sn1 v_wonbr  with frame main2 .

    {xsmf002now01.i} /*ˢ����ʾtop1*/

    v_msgtxt = "" .

end. /*loopsn*/
end procedure .


procedure loopx: /*ˢ��ָ������*/
    repeat:
        hide frame login  no-pause .
        hide frame top1   no-pause .
        hide frame main1  no-pause .
        hide frame main2  no-pause .

        view frame top1  .
        view frame main1 .
        view frame main2 . 
        
        {xsmf002now01.i} /*ˢ����ʾtop1*/
        if v_msgtxt <> "" then do:
            message v_msgtxt   /*view-as alert-box title "" */ .
            v_msgtxt = "" .
        end. /*ǰһ��ָ������֮��,ѭ�����������ʾv_msgtxt,��ʹ��ctrl+cҲ���½��׶�ʧ*/
        

        update v_line with frame main2 editing:
                if frame-field = "v_line" then do:
                    {xstimeout02.i " quit "    } 
                    {xsmfnp09.i xcode_mstr v_line  xcode_value v_fldname xcode_fldname xcode_fldval }
                    if recno <> ? then do:
                        v_line = xcode_value.
                        display v_line entry(1,xcode_cmmt,"@") @ xcode_cmmt with frame main2.
                    end. 
                end. 
                else do:
                    status input.
                    readkey . 
                    apply lastkey.  
                end. 
        end. /*update v_line*/
        assign v_line  .

        {xserr001.i "v_line" } /*���������λ�Ƿ��������ʺ�*/

        {xslnchk001.i}         /*���:����ָ�����Ȩ��*/
        
        
        {xstimetail01.i}       /*����Ƿ������Ļ���v_tail_wc*/
        {xslnchk002.i}         /*���:���ָ���ѭ���߼�*/
        run value(execname) .  /*ִ��ָ��*/  
        
        {xsgetuser01.i} /*��¼���û�����ˢ���Ļ���������,��Ϊ�´ε�½ʱ��Ĭ��ֵ*/



        if v_line = v_line_prev[13] /*�л�����*/ then run loopsn. /*ˢ����������*/ 

    end. /*loopx*/
end procedure .