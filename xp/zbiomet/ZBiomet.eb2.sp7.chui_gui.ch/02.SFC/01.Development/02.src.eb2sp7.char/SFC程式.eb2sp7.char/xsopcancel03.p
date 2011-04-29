/* xsopcancel03.p  ��ֹ����������� ״̬xxwrd_status = "J"                 */
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
    v_yn1         colon 18 label "ȡ������" 

    skip(5)
with frame a 
title color normal "ȡ������(��/�����з�����¼)"
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
        
        disp v_qty_ord2 v_qty_comp v_qty_rjct v_qty_rework v_qty_return v_part v_inv_lot v_wolot v_op with frame a .
        find first xpt_mstr where xpt_part = v_part no-lock no-error .
        if avail xpt_mstr then disp xpt_um xpt_desc1 xpt_desc2 with frame a .

        find first xxwrd_det 
            where xxwrd_wrnbr = integer(v_wrnbr)
            and xxwrd_wolot   = v_wolot 
            and xxwrd_op      = v_op 
            and (xxwrd_status = "" or xxwrd_status  = "N" )
            and xxwrd_close   = no
        no-lock no-error .
        if avail xxwrd_det then do:
            if (xxwrd_status  <> "" and xxwrd_status <> "N") or xxwrd_close = yes then do:
                message "ָ���޷�ִ��:SFC�������������ѽ����ɾ��."  view-as alert-box title "" .
                undo,leave mainloop .
            end .

            if xxwrd_qty_rework > xxwrd_qty_return then do:
                message  "�з���δ�������,��������˳�" view-as alert-box title "" .
                undo,leave mainloop .
            end. 
        end.

        /*����������*/
        find first xxwrd_det 
            where xxwrd_wrnbr = integer(v_wrnbr)
            and xxwrd_wolot   = v_wolot 
            and xxwrd_op      = v_op 
            and (xxwrd_status = "" or xxwrd_status  = "N" )
            and xxwrd_close   = no
        exclusive-lock no-wait no-error .
        if not avail xxwrd_det then do:
            if locked xxwrd_det then do:
                message  "�˹����������ڱ�ʹ��,��������˳�" view-as alert-box title "" .
                undo,leave mainloop.
            end.
        end.

        v_yn1 = yes .
        update v_yn1 with frame a .
        {xsfbchk002.i} /*��ֹ��������Ҳ�ڷ����˹���,��������һ��,�Ա�����������*/
        
        if v_yn1 = no  then do:
            undo mainloop,leave mainloop .
        end. /*v_yn1 = no */

        /*if v_lastwo and v_lastop then do:*/
        if v_lastwo and v_prev = no and v_sub = no then do:    
            v_yn2 = yes .
            message "�Ƿ�������?" update v_yn2 .
        end. /*if v_laswo and v_lastop*/

        /*��Э�����Զ���Ϊ�������,��������*/
        if v_sub then assign v_yn2 = no .

    end. /*update_loop*/
    


/*  start ---------------------------------------------------------------------------------------*/  

v_date   = today.
v_time   = time - (time mod 60) . /*��֤ʱ���һ��*/
v_msgtxt = "" .   /*��ʾ��Ϣ*/

/*����:  ǰ��ָ��*/
do  :  /*xxfb_prev*/
    {xslnprev01.i}
end.  /*xxfb_prev*/


/*����:����ָ��*/
do  :  /*xxfb*/

    /*�ı��η������������*/
    find first xxwrd_Det 
        where xxwrd_wrnbr = integer(v_wrnbr) 
        and xxwrd_wolot   = v_wolot
        and xxwrd_op      = v_op 
        and (xxwrd_status = "" or xxwrd_status  = "N" )
        and xxwrd_close   = no 
    exclusive-lock no-error .
    if avail xxwrd_det then do:
            v_qty_now      = xxwrd_qty_comp .
            xxwrd_qty_comp = xxwrd_qty_ord - xxwrd_qty_rejct .
            v_qty_now      = xxwrd_qty_comp - v_qty_now . /*������ֹ����,�޸ĵ�����*/
            xxwrd_status   = "J" .
    end. /*if avail xxwrd_det*/


    /*�׹���:���±�����ID��(������,�����к�������)�� xxwrd_opfinish & xxwrd_issok */
    if v_lastwo and v_prev = no then do:
        for each xxwrd_det  
            where xxwrd_wrnbr  = integer(v_wrnbr)
            and xxwrd_wonbr    = v_wonbr 
            and (xxwrd_wolot   = v_wolot and xxwrd_op      >=  v_op)
            and (xxwrd_status = "" or xxwrd_status  = "N" or xxwrd_status = "J" )
            and xxwrd_close    = no 
            :

            xxwrd_opfinish = yes  .
            xxwrd_issok    = if v_yn2 = no  then yes else no  .
            /*��������,�������ʱ,����"���в���ȫ���������?" ,yes --> xxwrd_issok = yes */
        end. /*for each xxwrd_det*/        
    end. /*if v_lastwo and v_prev = no*/

    find first xwo_mstr where xwo_lot = v_wolot no-lock no-error.
    find first xcode_mstr where xcode_fldname = v_fldname and xcode_value = v_line no-lock no-error.

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
            xxfb_rmks        = ""   
            xxfb_rsn_code    = ""  
            xxfb_user        = v_user  
            xxfb_op          = v_op  
            xxfb_wc          = v_wc  
            xxfb_wolot       = v_wolot  
            xxfb_wonbr       = v_wonbr 
            xxfb_part        = if avail xwo_mstr then xwo_part else ""   
            xxfb_type        = v_line  
            xxfb_type2       = if avail xcode_mstr and xcode_cmmt <> ""  then entry(1,xcode_cmmt,"@") else "" 
            xxfb_update      = no  
            .

            /*if v_sub then xxfb_rmks = xxfb_rmks  + "�ͼ쵥:" + v_sub_nbr  . */

    v_msgtxt = v_msgtxt + xxfb_type2 + ":ָ�����" .
end.  /*xxfb*/

/*  end ---------------------------------------------------------------------------------------*/  


leave .
end. /*mainloop:*/

hide frame a no-pause .
