/* xxinvmta.p xxinvmt.p���ӳ�ʽ,ά��xxship_det*/
/*----rev history-------------------------------------------------------------------------------------*/
/*ԭ�汾C+,ԭ��xxship.p*/
/* SS - 110307.1  By: Roger Xiao */ /*�����޸�:��bug,,ԭ��û���κ�У��,����Ҳδ��*/
/*-Revision end---------------------------------------------------------------*/

{mfdeclre.i}
{gplabel.i} 

define input parameter v_nbr   as char no-undo.
define input parameter v_vend  as char no-undo.

define var line              as int format "999".
define var v_inv_pm          as logical .
define var del-yn            like mfc_logical initial no.


form 
    line                  label "���"                   colon 10
    xxship_part           label "���ͼ��"               colon 35 format "x(26)"

    xxship_case           label "�к�"                   colon 10
    xxship_qty            label "����"                   colon 35
    xxship_type           label "����Z/�»���R"          colon 65
                                                          skip(1)
    xxship_qty_unit       label "ÿ������"               colon 10
    xxship_pkg            label "����"                   colon 35
    xxship_status         label "״̬"                   colon 65

    xxship_curr           label "��������"               colon 10
    xxship_rate           label "����"                   colon 35
    xxship_rcvd_date      label "�ջ�ʱ��"               colon 65

    xxship_price          label "����"                   colon 10
    xxship_value          label "�۸�"                   colon 35
    xxship_site           label "�ջ��ص�"               colon 65

with frame a side-labels width 80 attr-space .
setFrameLabels(frame a:handle).


mainloop:
repeat:

view frame a.

line = 1.

update 
    line
with frame a
editing:

        {mfnp11.i xxship_det xxship_line "xxship_nbr = v_nbr and xxship_vend = v_vend and xxship_line" "input line"}
        if recno <> ?  then do:   /* 3 */
                    display
                        xxship_line @ line
                        xxship_part    
                        xxship_qty         
                        /* xxship_duedate */            
                        /* xxship_etadate */          
                        xxship_curr           
                        xxship_rate                
                        xxship_price                  
                        xxship_value        
                        xxship_site                       
                        xxship_case                            
                        xxship_pkg                           
                        xxship_qty_unit                  
                        xxship_status                  
                        xxship_rcvd_date                
                        xxship_type                   
                    with frame a.
        end. /* 3end */ 

        if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
        then do:  /* 6 */
                del-yn = yes.
                {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
                if not del-yn then undo, retry.
                if del-yn
                then do:  /* 7 */
                    for each xxship_det where xxship_nbr = v_nbr and xxship_vend = v_vend and xxship_line = line .
                        delete xxship_det.
                    end.  /* 7end */
                    del-yn = no.
                    next mainloop.
                end. /* 6end */
                else
                    display
                        /*  "" @ xxship_part ***********************/
                        "" @ xxship_part
                        "" @ xxship_qty    
                        /* "" @ xxship_duedate */
                        /* "" @ xxship_etadate */
                        "" @ xxship_cur
                        "" @ xxship_rate 
                        "" @ xxship_price
                        "" @ xxship_value
                        "" @ xxship_site                          
                        "" @ xxship_case                   
                        "" @ xxship_pkg                       
                        "" @ xxship_qty_unit                 
                        "" @ xxship_status                  
                        "" @ xxship_rcvd_date         
                        "" @ xxship_type
                    with frame a.
        end.
end. /* EDITING */
assign line .

if input line = 0 then do:
    {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}  /*BLANK NOT ALLOWED*/
    undo, retry.
end. /*INPUT BLANK*/

find xxship_det where xxship_nbr = v_nbr and xxship_vend  = v_vend and xxship_line = line no-error.
if avail xxship_det then do:
        display
            line
            xxship_part     
            xxship_qty         
            /* xxship_duedate */            
            /* xxship_etadate */          
            xxship_curr           
            xxship_rate                
            xxship_price                  
            xxship_value        
            xxship_site                       
            xxship_case                            
            xxship_pkg                           
            xxship_qty_unit                  
            xxship_status                  
            xxship_rcvd_date                
            xxship_type                   
        with frame a.
end.

partloop:
do on error undo,retry on endkey undo,leave :
        find xxship_det 
            use-index xxship_line 
            where xxship_nbr   = v_nbr  
            and   xxship_vend  = v_vend
            and   xxship_line  = line 
        exclusive-lock no-error.
        if not available xxship_det then do on error undo, retry :
            find xxinv_mstr where xxinv_nbr = v_nbr no-lock no-error.
            v_inv_pm = if avail xxinv_mstr then xxinv_pm else no .

            {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1} 
            create xxship_det.
            assign 
                xxship_nbr   = v_nbr
                xxship_vend  = v_vend
                xxship_line  = line
                xxship_curr  = if avail xxinv_mstr then xxinv_curr else base_curr 
                xxship_rate  = if xxship_curr = base_curr then 1 else 0
                xxship_type  = "Z" 
                xxship_site  = if avail xxinv_mstr then xxinv_site else "GSA01".


            update 
                xxship_part 
            with frame a .

            find first vp_mstr 
                use-index vp_vend_part
                where vp_vend = xxship_vend 
                and   vp_vend_part = xxship_part 
                and  (( vp_part begins "M" and v_inv_pm = no )
                      or
                      ( vp_part begins "P" and v_inv_pm = yes ))
            no-lock no-error.
            if not available vp_mstr then do:
                message "����:���ͼ�Ų���ȷ,����������."  . 
                undo,retry.
            end.

            xxship_part2 = vp_part .  /*�Ѻ�ͼ��*/
            xxship_pm    = v_inv_pm .     


        end. /*if not available xxship_det*/
        else do:
            {pxmsg.i &MSGNUM=10 &ERRORLEVEL=1} 
        end.



        update
            xxship_case     
            xxship_qty      
            xxship_type     

            xxship_qty_unit 
            xxship_pkg      
            xxship_curr   
            xxship_rate     
            xxship_price    
            xxship_value                                 
        with frame a.

        find first si_mstr where si_site = xxship_site no-lock no-error .
        if not avail si_mstr then do:
            message "����:��Ч�ص�,����������" .
            next-prompt xxship_site  with frame a .
            undo,retry.
        end.

        find first cu_mstr where cu_curr = xxship_curr no-lock no-error .
        if not avail cu_mstr then do:
            message "����:��Ч�ұ�,����������" .
            next-prompt xxship_curr  with frame a .
            undo,retry.
        end.


        if index("Z,R",xxship_type) = 0 then do:
            message "����:����Z,R����,����������" .
            next-prompt xxship_type with frame a .
            undo,retry.
        end.

end. /*partloop:*/
     
end. /* MAINLOOP */
hide frame a.