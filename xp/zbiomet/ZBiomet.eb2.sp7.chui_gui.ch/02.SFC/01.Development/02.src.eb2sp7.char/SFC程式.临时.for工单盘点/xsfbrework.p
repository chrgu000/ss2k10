/* xs                                                 */
/* REVISION: 1.0         Last Modified: 2008/12/01   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/

/*{mfdeclre.i}*/    /*mfgpro global vars & functions*/
/*{gplabel.i}*/     /*mfgpro externalized label include */
{xsmf002var01.i }  /*all shared vars  defines here */
{xsfbchk001.i}  /*����ǰ��,�������弰��ؼ��*/


/*��cell����,ǰ����δ����򱾹�������ʼ*/
{xstimecell01.i}

/*����Ƿ���ͣ���û�,����,����,*/
/*֮ǰ����v_tail_wc  {xstimetail01.i} or {xsfbchk001.i} */
{xstimepause01.i}


form
    skip(1)
    v_wolot       colon 18 label "������־"
    v_op          colon 45 label "����" 
    v_part        colon 18 label "���Ʒ"  
    xpt_desc1      colon 45 label "Ʒ��"
    xpt_um         colon 18 label "��λ"
    xpt_desc2      colon 45 label "���"
    skip(1)       
    v_qty_ord2    colon 18 label "������"
    v_inv_lot     colon 45 label "����"
    v_qty_comp    colon 18 label "�Ѻϸ���"
    v_qty_rjct    colon 45 label "�ѱ�����"
    v_qty_rework  colon 18 label "�ۼƷ���(����)"
    v_qty_return  colon 18 label "�������(����)"
    skip(1)
    v_qty_now  colon 18 label "���η���(����)"
    rwkreason  colon 18 label "����ԭ��"  xrsn_desc no-label
    skip(5)
with frame a 
title color normal "��������"
side-labels width 80 .   




hide all no-pause .
view frame a .

mainloop:
repeat :
    
    do  on error undo,retry: /*update_loop*/
        clear frame a no-pause .
        v_qty_now     = 0 .
        rejreason     = "" . 
        rwkreason     = "" . 

        {xsfbchk002.i} /*ȡ�����ȵ�Ĭ��ֵ:ǰ����,������,�¹���*/

        disp v_qty_ord2 v_qty_comp v_qty_rjct v_qty_rework v_qty_return v_part v_inv_lot v_wolot v_op rwkreason with frame a .
        find first xpt_mstr where xpt_part = v_part no-lock no-error .
        if avail xpt_mstr then disp xpt_um xpt_desc1 xpt_desc2 with frame a .
        find first xrsn_ref where xrsn_type = "rework" and xrsn_code = rwkreason  no-lock no-error .
        if avail xrsn_ref then disp  xrsn_code @ rwkreason xrsn_desc with frame a .
        else disp rwkreason "" @ xrsn_desc with frame a .
        
        find first xxwrd_det 
            where xxwrd_wrnbr = integer(v_wrnbr)
            and xxwrd_wolot   = v_wolot 
            and xxwrd_op      = v_op 
            and (xxwrd_status = "" or xxwrd_status  = "N" )
            and xxwrd_close   = no
        exclusive-lock no-wait no-error .
        if not avail xxwrd_det then do:
            if locked xxwrd_det then do:
                message  "�����������ڱ�ʹ��,��������˳�" view-as alert-box title "" .
                undo,leave mainloop.
            end.
        end.

        update v_qty_now with frame a .
        {xsfbchk002.i} /*��ֹ��������Ҳ�ڷ����˹���,��������һ��,�Ա�����������*/

        {xserr001.i "v_qty_now" } /*���������λ�Ƿ��������ʺ�*/

        if v_qty_now = 0 then do:
            message "������������Ϊ��.����������" .
            undo,retry .
        end. /**/


        if v_qty_rework - v_qty_return > 0 then do:
            message "�Ƿ񷵹����ٴη���?" update v_yn3 .
        end.

        if v_qty_now > 0 then do:
            /*һ���ɶ��,�����ۼ�ֵ�ϲ��ⶥ,����:ÿ��,���ó���ʣ������*/
            /*���׹�������������κ�����*/
            if  v_prev = yes then do:
                if (v_qty_now + v_qty_comp + v_qty_rjct) * v_qty_bom > v_qty_prev then do:
                    message "�ۼ��������ɳ���ǰ����(" v_prev_wolot "+" v_prev_op ")�����("  v_qty_prev  ")����������" .
                    undo,retry .
                end.

                if v_qty_now + v_qty_comp + v_qty_rjct > v_qty_ord2 then do:
                    message "�ۼ��������ɳ���������("  v_qty_ord2  ")����������" .
                    undo,retry .
                end.
            end.

            if v_yn3 = yes then do:
                if v_qty_rework - v_qty_return < v_qty_now then do:
                    message "���ɳ�������δ�������(" (v_qty_rework - v_qty_return) "),����������" .
                    undo,retry .
                end.                      
            end.

        end. /*if v_qty_now > 0 */

        if v_qty_now < 0 then do:            
            if v_yn3 = yes then do: 
                if v_qty_return < - v_qty_now then do:
                    message "���ɳ��������������(" v_qty_return "),����������" .
                    undo,retry .
                end.                       
            end.
            else do:
                if (v_qty_rework - v_qty_return  ) < - v_qty_now then do:
                    message "���ɳ�������δ�������,����������" .
                    undo,retry .
                end.
            end.
        end. /*if v_qty_now < 0 */

        {xsfbsubwo01.i} /*v_sub:��Э����ˢ���ͼ쵥*/
        
        reasonloop:
        do on error undo,retry :
            update rwkreason with frame a editing:
                {xstimeout02.i " quit "    } 
                {xsmfnp01.i xrsn_ref rwkreason xrsn_code ""rework"" xrsn_type xrsn_type}

                if recno <> ? then do:
                    display xrsn_code @ rwkreason xrsn_desc with frame a .
                end.
            end.
            assign rwkreason .

            find first xrsn_ref 
                where xrsn_type = "rework" and xrsn_code = rwkreason 
            no-lock no-error .
            if not avail xrsn_ref then do:
                message "��Ч����ԭ��,����������." .
                undo,retry .
            end.
            disp  xrsn_code @ rwkreason xrsn_desc with frame a .
        end.  /*reasonloop:*/
        

    end. /*update_loop*/
    


/*  start ---------------------------------------------------------------------------------------*/  

v_date   = today.
v_time   = time - (time mod 60) . /*��֤ʱ���һ��*/
v_msgtxt = "" .   /*��ʾ��Ϣ*/

/*����:  ǰ��ָ�������ʷ��¼*/
do  :  /*xxfb_prev*/
    {xslnprev01.i}
end.  /*xxfb_prev*/


/*����:����ָ�������ʷ��¼*/
do  :  /*xxfb*/

    find first xxwrd_Det 
        where xxwrd_wrnbr = integer(v_wrnbr) 
        and xxwrd_wolot   = v_wolot
        and xxwrd_op      = v_op 
        and (xxwrd_status = "" or xxwrd_status  = "N" )
        and xxwrd_close   = no
    exclusive-lock no-error .
    if avail xxwrd_det then do:
        assign xxwrd_qty_rework = xxwrd_qty_rework + v_qty_now .

        if v_yn3 then xxwrd_qty_return = xxwrd_qty_return + v_qty_now .
    end. /*if avail xxwrd_det*/



    find first xwo_mstr where xwo_lot = v_wolot no-lock no-error.
    find first xcode_mstr where xcode_fldname = v_fldname and xcode_value = v_line no-lock no-error.
    find first xrsn_ref where xrsn_type = "rework" and xrsn_code = rwkreason  no-lock no-error .

    v_trnbr = 0 .
    v_nbrtype =  "bctrnbr" . /*xxfb_hist,������ˮ��*/
    run getnbr(input v_nbrtype ,output v_trnbr) .

    create  xxfb_hist .
    assign  xxfb_trnbr       = integer(v_trnbr) 
            xxfb_date        = today  
            xxfb_date_end    = v_date  
            xxfb_date_start  = v_date  
            xxfb_time        = time - (time mod 60) 
            xxfb_time_end    = v_time  
            xxfb_time_start  = v_time   
            xxfb_nbr         = "" 
            xxfb_program     = execname
            xxfb_wotype      = if v_yn3 then "R" else ""   
            xxfb_qty_fb      = v_qty_now   
            xxfb_rmks        = if avail xrsn_ref then xrsn_desc else ""   
            xxfb_rsn_code    = rwkreason  
            xxfb_user        = v_user  
            xxfb_user2       = v_user2
            xxfb_op          = v_op  
            xxfb_wc          = v_wc  
            xxfb_wolot       = v_wolot  
            xxfb_wonbr       = v_wonbr 
            xxfb_part        = if avail xwo_mstr then xwo_part else ""   
            xxfb_type        = v_line  
            xxfb_type2       = if avail xcode_mstr and xcode_cmmt <> ""  then entry(1,xcode_cmmt,"@") else "" 
            xxfb_update      = no  
            .

            if v_sub then xxfb_rmks = xxfb_rmks  + "�ͼ쵥:" + v_sub_nbr  .

    v_msgtxt = v_msgtxt + xxfb_type2 + ":ָ�����" .
end.  /*xxfb*/


/*  end ---------------------------------------------------------------------------------------*/  


leave.
end. /*mainloop:*/

hide frame a no-pause .
