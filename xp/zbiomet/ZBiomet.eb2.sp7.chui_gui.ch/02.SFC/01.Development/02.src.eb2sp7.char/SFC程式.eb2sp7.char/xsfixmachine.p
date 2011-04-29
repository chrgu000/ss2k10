/* xsfixmachine.p ����ά��ָ��                                             */
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


define var v_txt as char format "x(12)" .
define var v_sdate as date .
define var v_sh as integer format "99".
define var v_sm as integer format "99".
define var v_edate as date .
define var v_eh as integer format "99".
define var v_em as integer format "99".
define var v_time_end as integer  .

form
    skip(1)
    v_sdate colon 20  label "��ʼ����(������)"
    v_sh    colon 20  label "��ʼʱ��(24ʱ��)"     
    v_sm              label     ""
    /*v_edate colon 20  label "��������(������)"
    v_eh    colon 20  label "����ʱ��(24ʱ��)"     
    v_em              label     ""
    */
    v_txt   colon 20  label "��ע"
    skip(1)
with frame a 
title color normal "����ά��"
side-labels width 50 
row 8 centered overlay .   

/* check start ---------------------------------------------------------------------------------------*/  




/* check end  ---------------------------------------------------------------------------------------*/  
v_txt = "" .
v_sdate = today .
v_sh    = integer(substring(string(time,"hh:mm"),1,2)) .
v_sm    = integer(substring(string(time,"hh:mm"),4,2)) .

v_edate    = ? . 
v_time_end = 0 .
/*v_edate = today .
v_eh    = integer(substring(string(time,"hh:mm"),1,2)) .
v_em    = integer(substring(string(time,"hh:mm"),4,2)) .
*/
view frame a .

mainloop:
repeat :
    
    do on error undo,retry: /*update_loop*/

        message "ָ��:����ά��,������ά�޿�ʼ/����ʱ�� " .
        disp v_sdate v_sh v_sm v_txt with frame a .

        update v_sdate v_sh v_sm v_txt with frame a .
        assign v_sdate v_sh v_sm v_txt .

        {xserr001.i "v_sh" } /*���������λ�Ƿ��������ʺ�*/
        {xserr001.i "v_sm" } /*���������λ�Ƿ��������ʺ�*/

        if v_sdate = ? then do:
            message "����ȷ����ά�޿�ʼ����." .
            next-prompt v_sdate.
            undo,retry .
        end.

        if v_sh >= 24 then do:
            message "����ȷ����ά�޿�ʼʱ��." .
            next-prompt v_sh.
            undo,retry .
        end.

        if v_sm >= 60 then do:
            message "����ȷ����ά�޿�ʼʱ��." .
            next-prompt v_sm.
            undo,retry .
        end.

        /*
        if v_edate = ? then do:
            message "����ȷ����ά�޽�������." .
            next-prompt v_edate.
            undo,retry .
        end.

        if v_eh >= 24 then do:
            message "����ȷ����ά�޽���ʱ��." .
            next-prompt v_eh.
            undo,retry .
        end.

        if v_em >= 60 then do:
            message "����ȷ����ά�޽���ʱ��." .
            next-prompt v_em.
            undo,retry .
        end.
        */

        v_date   = v_sdate .
        v_time   = v_sh * 60 * 60 + v_sm * 60  . 
        v_time   = v_time - (v_time mod 60)    . /*��֤ʱ���һ��*/
        
        
        /*����ʱ��*/ /*
        v_time_end   = v_eh * 60 * 60 + v_em * 60  . 
        v_time_end   = v_time_end - (v_time_end mod 60). 
        if (integer(v_edate) + v_time_end / 86400 ) > (integer(today) + (time - (time mod 60)) / 86400 ) then do:
            message "����ʱ�䲻�ɳ���:����(" today "" string(time,"hh:mm") ")." .
            undo,retry .
        end.
        if (integer(v_date) + v_time / 86400 ) > (integer(v_edate) + v_time_end / 86400 ) then do:
            message "��ʼʱ�䲻�ɳ���:ά�޽���ʱ��(" v_edate "" string(v_time_end,"hh:mm") ")." .
            undo,retry .
        end.
        */

        if (integer(v_date) + v_time / 86400 ) > (integer(today) + (time - (time mod 60)) / 86400 ) then do:
            message "��ʼʱ�䲻�ɳ���:����(" today "" string(time,"hh:mm") ")." .
            undo,retry .
        end.



      
        v_recno = ? .  /*�����һ����ʱ���ȵ�ָ��*/
        for each xxfb_hist  
                use-index xxfb_userwc 
                where xxfb_user = v_user and xxfb_wc = v_wc
                and (xxfb_type = v_line_prev[1] or 
                     xxfb_type = v_line_prev[2] or 
                     xxfb_type = v_line_prev[19] or 
                     xxfb_type = v_line_prev[20] or
                     xxfb_type = v_line_prev[21] )
                no-lock 
                break by xxfb_user by xxfb_wc by xxfb_trnbr :

                if last(xxfb_user) then v_recno = recid(xxfb_hist) .
        end.
        if v_recno <> ? then do:
            find xxfb_hist where  recid(xxfb_hist) = v_recno no-lock no-error .
            if xxfb_date_end <> ? then do:
                if (integer(v_date) + v_time / 86400 ) < (integer(xxfb_date_end) + xxfb_time_end / 86400 ) then do:
                    message "��ʼʱ�䲻������:���һ��ָ���ִ��ʱ��(" xxfb_date_end "" string(xxfb_time_end,"hh:mm") ")." .
                    undo,retry .
                end.
            end.
            else do:
                if (integer(v_date) + v_time / 86400 ) < (integer(xxfb_date_start) + xxfb_time_start / 86400 ) then do:
                    message "��ʼʱ�䲻������:���һ��ָ���ִ��ʱ��(" xxfb_date_start "" string(xxfb_time_start,"hh:mm") ")." .
                    undo,retry .
                end.
            end.
        end.

    end. /*update_loop*/
    


    /*  start ---------------------------------------------------------------------------------------*/  

    v_date   = v_sdate .
    v_time   = v_sh * 60 * 60 + v_sm * 60  . 
    v_time   = v_time - (v_time mod 60)    . /*��֤ʱ���һ��*/
    v_msgtxt = "" .   /*��ʾ��Ϣ*/


    /*����:  ǰ��ָ�������ʷ��¼*/
    do :  /*xxfb_prev*/
        {xslnprev02.i}                      
    end.  /*xxfb_prev*/


    /*����:����ָ�������ʷ��¼*/
    do  :  /*xxfb*/


        find first xwo_mstr where xwo_lot = v_wolot no-lock no-error.
        find first xcode_mstr where xcode_fldname = v_fldname and xcode_value = v_line no-lock no-error.

        v_trnbr = 0 .
        v_nbrtype =  "bctrnbr" . /*xxfb_hist,������ˮ��*/
        run getnbr(input v_nbrtype ,output v_trnbr) .

        create  xxfb_hist .
        assign  xxfb_trnbr       = integer(v_trnbr) 
                xxfb_date        = today  
                xxfb_date_end    = v_edate  
                xxfb_date_start  = v_date  
                xxfb_time        = time - (time mod 60)  
                xxfb_time_end    = v_time_end  
                xxfb_time_start  = v_time   
                xxfb_nbr         = ""  
                xxfb_program     = execname
                xxfb_wotype      = ""  
                xxfb_qty_fb      = 0   
                xxfb_rmks        = v_txt  
                xxfb_rsn_code    = ""  
                xxfb_user        = v_user  
                xxfb_op          = 0  
                xxfb_wc          = v_wc  
                xxfb_wolot       = "" 
                xxfb_wonbr       = v_wonbr 
                xxfb_part        = if avail xwo_mstr then xwo_part else ""   
                xxfb_type        = v_line  
                xxfb_type2       = if avail xcode_mstr and xcode_cmmt <> ""  then entry(1,xcode_cmmt,"@") else "" 
                xxfb_update      = no  
                .
        v_msgtxt = xxfb_type2 + ":ָ�ʼ" .
    end.  /*xxfb*/



    /*  end ---------------------------------------------------------------------------------------*/  


leave .
end. /*mainloop:*/
hide frame a no-pause .
