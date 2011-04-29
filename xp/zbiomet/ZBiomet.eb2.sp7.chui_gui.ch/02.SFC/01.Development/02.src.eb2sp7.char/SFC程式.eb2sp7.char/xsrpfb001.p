/* xsrpfb001.p �������׼�¼��ѯ                                            */
/* REVISION: 1.0         Last Modified: 2008/12/01   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/

/*{mfdeclre.i}*/    /*mfgpro global vars & functions*/
/*{gplabel.i}*/     /*mfgpro externalized label include */
{xsmf002var01.i }  /*all shared vars  defines here */




define var v_fbnbr like xxfb_trnbr .



form
skip(1)                
v_fbnbr                         colon 12 label "���׺�"
xxfb_type                       colon 12 label "��������"     
xxfb_type2                      no-label                  xxfb_nbr                        colon 50 label "���ݺ�"       
xxfb_date                       colon 12 label "ִ������" xxfb_program                    colon 50 label "��ʽ"    format "x(24)"          
xxfb_time                       colon 12 label "ִ��ʱ��" xxfb_user                       colon 50 label "�û�"       
xxfb_part                       colon 12 label "��Ŀ��"   xpt_desc1                        colon 50 label "Ʒ��"
xpt_um                           colon 12 label "��λ"     xpt_desc2                        colon 50 label "���"
skip(1)
xxfb_wonbr                      colon 12 label "������"    xxfb_wolot                      colon 50 label "������־"
xxfb_op                         colon 12 label "����"      xxfb_wc                         colon 50 label "����"
xxfb_date_start                 colon 12 label "��ʼ����"  xxfb_qty_fb                     colon 50 label "����"    
xxfb_time_start                 colon 12 label "��ʼʱ��"  xxfb_wotype                     colon 50 label "��������"  
xxfb_date_end                   colon 12 label "��������"  xxfb_rsn_code                   colon 50 label "ԭ��"    
xxfb_time_end                   colon 12 label "����ʱ��"  xxfb_rmks                       colon 50 label "��ע"    
xxfb_update                     colon 12 label "�Ѹ���" 


with frame a 
title color normal "���׼�¼��ѯ"
side-labels width 80 .   


hide all no-pause .
view frame a .

find last xxfb_hist no-lock no-error .
v_fbnbr = if avail xxfb_hist then xxfb_trnbr else 0.

mainloop:
repeat :

    update v_fbnbr with frame a editing:
        {xstimeout02.i " quit "    } 
        {xsmfnp11.i xxfb_hist xxfb_trnbr xxfb_trnbr "input v_fbnbr" }
        IF recno <> ?  THEN DO:
            DISP 
                xxfb_trnbr @ v_fbnbr   
                xxfb_type       
                xxfb_type2      
                xxfb_nbr        
                xxfb_user       
                xxfb_date       
                xxfb_program    
                xxfb_part            
                xxfb_wonbr      
                xxfb_wolot      
                xxfb_op         
                xxfb_wc         
                xxfb_date_start 
                xxfb_date_end   
                string(xxfb_time,"hh:mm")       @ xxfb_time       
                string(xxfb_time_start,"hh:mm") @ xxfb_time_start 
                string(xxfb_time_end,"hh:mm")   @ xxfb_time_end  
                xxfb_qty_fb     
                xxfb_rsn_code   
                xxfb_rmks       
                xxfb_update     
                xxfb_wotype     

            with frame a.

            find first xpt_mstr where xpt_part = xxfb_part no-lock no-error.
            if avail xpt_mstr then disp xpt_desc1 xpt_desc2 xpt_um with frame a  .
        END.  /*if recno<> ?*/
    end.
    assign v_fbnbr .

    {xserr001.i "v_fbnbr" } /*���������λ�Ƿ��������ʺ�*/

    find first xxfb_hist 
        use-index xxfb_trnbr 
        where xxfb_trnbr = v_fbnbr 
    no-lock no-error .
    if not avail xxfb_hist then do:
        message "��Ч���׺�,����������" .
        undo,retry .
    end.
    else do: /*avail*/
            DISP 
                xxfb_trnbr @ v_fbnbr   
                xxfb_type       
                xxfb_type2      
                xxfb_nbr        
                xxfb_user       
                xxfb_date       
                xxfb_program    
                xxfb_part            
                xxfb_wonbr      
                xxfb_wolot      
                xxfb_op         
                xxfb_wc         
                xxfb_date_start 
                xxfb_date_end   
                string(xxfb_time,"hh:mm")       @ xxfb_time       
                string(xxfb_time_start,"hh:mm") @ xxfb_time_start 
                string(xxfb_time_end,"hh:mm")   @ xxfb_time_end  
                xxfb_qty_fb     
                xxfb_rsn_code   
                xxfb_rmks       
                xxfb_update     
                xxfb_wotype     

            with frame a.

            find first xpt_mstr where xpt_part = xxfb_part no-lock no-error.
            if avail xpt_mstr then disp xpt_desc1 xpt_desc2 xpt_um with frame a  .

    end. /*avail*/



end. /*mainloop*/
hide frame a no-pause .