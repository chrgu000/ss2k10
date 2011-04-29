/* xsmf002.p     BARCODE SFC SYSTEM MAIN FRAME                             */
/* REVISION: 1.0         Last Modified: 2008/11/27   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/



/*{mfdeclre.i}*/    /*mfgpro global vars & functions*/
/*{gplabel.i}*/     /*mfgpro externalized label include */

{xsmf002var01.i "new" }  /*all shared vars  defines & assigned here */
{xsmf002var02.i       }  /*all vars  defines here */
{xsmf002frm.i         }  /*all frame defines here */

/*一些重要变量的赋值,在xsmf002var01.i*/

{xscanrun001.i}    /*procedure define for : menu security load & check    */
/*    
{gpglefv.i} /*var for xsglefchk001.i (gpglef1.p) */
/*{xsglefchk001.i &module =""IC""  &entity =""""  &date =today }   *会计期间检查,放在各指令前检查,如xsfbchk001.i等*/
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


    /*1--默认用户名检查*/      
    find first xemp_mstr where xemp_addr = v_user no-lock no-error .
    if not avail xemp_mstr then do:
        message "无效用户,请重新输入!" .
        undo,retry .
    end.

    if xemp__chr01 <> encode(v_pwd)  then do:
        message "密码错误,请重新输入!    "  .
        next-prompt v_pwd with frame login .
        undo,retry .
    end.

    /*2--该用户的默认机器和工单ID */
    find first xusrw_wkfl where xusrw_key1 = v_fldname  and   xusrw_key2 = v_user /*xptest*exclusive-lock /*3--锁定用户,不可多次登陆*/ no-wait*/ no-lock no-error .
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
            find first xusrw_wkfl where xusrw_key1 = v_fldname  and   xusrw_key2 = v_user exclusive-lock /*3--锁定用户,不可多次登陆*/ no-error .    
        end.
        else do:
            release xusrw_wkfl .
            message "此用户已在线,请勿重复登陆!" skip
                    "     按任意键退出...      "
            view-as alert-box title "警告".
            undo,retry .
        end.
*/
    end.
    v_user2 = v_user .

end.  /*loginloop*/

mainloop:
repeat:
    loopa: /*机器维护*/
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
            {xsmf002now01.i} /*刷新显示top1*/

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
            message "无效工作中心,请重新输入" .
            next-prompt v_wc with frame top1 .
            undo,retry .
        end.
        v_msgtxt = "" .



        {xsmf002now01.i} /*刷新显示top1*/

        loopc: 
        repeat :
                run loopsn. /*刷读工单条码*/ 
                run loopx.  /*刷读指令条码*/                
                
        end. /*loopc*/
    end. /*loopa*/
    /*leave .*/ /*F4-直接退出*/
end. /*mainloop*/





procedure loopsn:
do on error undo,retry :
    {xsmf002now01.i} /*刷新显示top1*/
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
        /*v_user不变,为最后一个用户*/
    end.

    find first xwc_mstr where xwc_wkctr = v_wc no-lock no-error .
    if not avail xwc_mstr then do:
        message "无效工作中心,请重新输入" .
        undo,retry .
    end.

    disp xwc_wkctr @ v_wc  entry(max(1,num-entries(xwc_desc, "/")),xwc_desc,"/") @ xwc_desc  with frame main2 .


    if v_sn1 <> "" then do:
        if index(v_sn1, "+") = 0 then do:
            message "加工单条码格式有误,请重新刷读" .
            undo,retry .
        end.
        v_op    = integer(entry(2,trim(v_sn1),"+")) .
        v_wolot = entry(1,trim(v_sn1),"+") .

        find first xxwrd_det where xxwrd_wolot = v_wolot no-lock no-error .
        if avail xxwrd_det then do:  /*已同步过的wolot*/
            v_wonbr = xxwrd_wonbr .
            find first xxwrd_det where xxwrd_wolot = v_wolot and xxwrd_op = v_op no-lock no-error .
            if not avail xxwrd_det then do:
                message "无效SFC工单条码:" v_wolot "/" v_op " ,请重新刷读" .
                undo,retry .
            end.
        end. /*已同步过的wolot*/
        else do:  /*首次刷读的wolot*/
            find first xwr_route where xwr_lot = v_wolot and xwr_op = v_op no-lock no-error .
            if not avail xwr_route then do:
                message "无效加工单/工序:" v_wolot "/" v_op " ,请重新刷读" .
                undo,retry .
            end.
            else do:
                v_wonbr = xwr_nbr .
            end.
        end.  /*首次刷读的wolot*/
    end. /*if v_sn1 <> ""*/
    else do:
        v_op    = 0 .
        v_wolot = "" .
        v_wonbr = "" .
    end.
    
    disp v_sn1 v_wonbr  with frame main2 .

    {xsmf002now01.i} /*刷新显示top1*/

    v_msgtxt = "" .

end. /*loopsn*/
end procedure .


procedure loopx: /*刷读指令条码*/
    repeat:
        hide frame login  no-pause .
        hide frame top1   no-pause .
        hide frame main1  no-pause .
        hide frame main2  no-pause .

        view frame top1  .
        view frame main1 .
        view frame main2 . 
        
        {xsmf002now01.i} /*刷新显示top1*/
        if v_msgtxt <> "" then do:
            message v_msgtxt   /*view-as alert-box title "" */ .
            v_msgtxt = "" .
        end. /*前一笔指令做完之后,循环到这里才显示v_msgtxt,即使按ctrl+c也不怕交易丢失*/
        

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

        {xserr001.i "v_line" } /*检查数量栏位是否输入了问号*/

        {xslnchk001.i}         /*检查:单个指令操作权限*/
        
        
        {xstimetail01.i}       /*检查是否后处理工序的机器v_tail_wc*/
        {xslnchk002.i}         /*检查:多个指令的循环逻辑*/
        run value(execname) .  /*执行指令*/  
        
        {xsgetuser01.i} /*记录此用户本次刷读的机器和条码,作为下次登陆时的默认值*/



        if v_line = v_line_prev[13] /*切换机器*/ then run loopsn. /*刷读工单条码*/ 

    end. /*loopx*/
end procedure .