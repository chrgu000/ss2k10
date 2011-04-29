/* xstimerun.p  ����ʱ��                                                  */
/* REVISION: 1.0         Last Modified: 2008/12/01   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/

/*{mfdeclre.i}*/    /*mfgpro global vars & functions*/
/*{gplabel.i}*/     /*mfgpro externalized label include */
{xsmf002var01.i }  /*all shared vars  defines here */
{xsfbchk001.i}  /*����ǰ��,�������弰��ؼ��*/

{xsfbchk002.i} /*ȡ�����ȵ�Ĭ��ֵ:ǰ����,������,�¹���*/

/*����ɵĹ�������ʱ�䷴��*/
{xstimechk01.i}


/*��cell����,ǰ����δ����򱾹�������ʼ*/
{xstimecell01.i}


/*��Э����v_sub������ʱ�䷴��*/
{xsfbsubwo02.i}

/*����Ƿ���ͣ���û�,����,����,*/
/*֮ǰ����v_tail_wc  {xstimetail01.i} or {xsfbchk001.i} */
{xstimepause01.i}


/*--------------------------------------------------------------------------------------------------*/

mainloop:
repeat:


    v_yn3 = no .
    find first xxwrd_Det 
            where xxwrd_wrnbr = integer(v_wrnbr) 
            and xxwrd_wolot   = v_wolot
            and xxwrd_op      = v_op 
            and (xxwrd_status = "" or xxwrd_status  = "N" )
            and xxwrd_close   = no
    exclusive-lock no-wait no-error .
    if avail xxwrd_det then do:
        if xxwrd_qty_rework - xxwrd_qty_return > 0 then do:
            v_yn3 = yes .
            message "�Ƿ񷵹���?" update v_yn3 .
        end.
    end. /*if avail xxwrd_det*/
    else do:
        if locked xxwrd_det then do:
            message  "�����������ڱ�ʹ��,��������˳�" view-as alert-box title "" .
            undo,leave mainloop.
        end.
    end.


    v_date   = today.
    v_time   = time - (time mod 60) . /*��֤ʱ���һ��*/
    v_msgtxt = "" .   /*��ʾ��Ϣ*/

    /*����:  ǰ��ָ�������ʷ��¼*/
    do  :  /*xxfb_prev*/
        {xslnprev01.i}
    end.  /*xxfb_prev*/


    /*����:����ָ�������ʷ��¼*/
    do :  /*xxfb*/


        find first xwo_mstr where xwo_lot = v_wolot no-lock no-error.
        find first xcode_mstr where xcode_fldname = v_fldname and xcode_value = v_line no-lock no-error.

        v_trnbr = 0 .
        v_nbrtype =  "bctrnbr" . /*xxfb_hist,������ˮ��*/
        run getnbr(input v_nbrtype ,output v_trnbr) .


        create  xxfb_hist .
        assign  xxfb_trnbr       = integer(v_trnbr) 
                xxfb_date        = today  
                xxfb_date_end    = ?  
                xxfb_date_start  = v_date  
                xxfb_time        = time - (time mod 60) 
                xxfb_time_end    = 0  
                xxfb_time_start  = v_time   
                xxfb_nbr         = "" 
                xxfb_program     = execname
                xxfb_wotype      = if v_yn3 then "R" else ""     
                xxfb_qty_fb      = 0   
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
        v_msgtxt = v_msgtxt + xxfb_type2 + ":ָ�ʼ" .
    end.  /*xxfb*/




leave.
end. /*mainloop*/
hide frame fixm no-pause . /*for xslnprev01.i */















