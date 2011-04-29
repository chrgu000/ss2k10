/* xs                                                 */
/* REVISION: 1.0         Last Modified: 2008/12/01   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/

/*{mfdeclre.i}*/    /*mfgpro global vars & functions*/
/*{gplabel.i}*/     /*mfgpro externalized label include */
{xsmf002var01.i }  /*all shared vars  defines here */
{xsfbchk001.i}  /*反馈前的,变量定义及相关检查*/

define var v_time_setup   as decimal   format "->9.9". /*盘点临时程式*/
define var v_time_run     as decimal   format "->9.9" . /*盘点临时程式*/
define var v_time_setup2  as decimal   format "->9.9". /*盘点临时程式*/
define var v_time_run2    as decimal   format "->9.9" . /*盘点临时程式*/
define var v_time_setup3  as decimal   format "->9.9". /*盘点临时程式*/
define var v_time_run3    as decimal   format "->9.9" . /*盘点临时程式*/

form
    skip(1)
    v_wolot       colon 18 label "工单标志"
    v_op          colon 45 label "工序" 
    v_part        colon 18 label "完成品"  
    xpt_desc1      colon 45 label "品名"
    xpt_um         colon 18 label "单位"
    xpt_desc2      colon 45 label "规格"
    skip(1)
    v_qty_ord2    colon 18 label "订购量"
    v_inv_lot     colon 45 label "批号"
    v_qty_comp    colon 18 label "已合格数"
    v_qty_rjct    colon 45 label "已报废数"
    v_qty_rework  colon 18 label "累计返工(件次)"
    v_qty_return  colon 45 label "返工完成(件次)"
    v_time_setup  colon 18 label "已准备时间(小时)"  /*盘点临时程式*/
    v_time_run    colon 45 label "已运行时间(小时)"   /*盘点临时程式*/
    skip(1)       
    v_time_setup2  colon 25 label "正常准备时间(小时)"  /*盘点临时程式*/      "    <--盘点临时程式 "
    v_time_setup3  colon 25 label "返工准备时间(小时)"  /*盘点临时程式*/      "    <--盘点临时程式 "
    v_time_run2    colon 25 label "正常运行时间(小时)"   /*盘点临时程式*/     "    <--盘点临时程式 "
    v_time_run3    colon 25 label "返工运行时间(小时)"   /*盘点临时程式*/     "    <--盘点临时程式 "

    skip(2)
with frame a 
title color normal "工单盘点:准备/运行时间"
side-labels width 80 .   


hide all no-pause .
view frame a .


v_time_setup2 = 0 .
v_time_run2   = 0 .

mainloop:
repeat :
    
        clear frame a no-pause .

        find first xxwrd_det 
            where xxwrd_wrnbr = integer(v_wrnbr)
            and xxwrd_wolot   = v_wolot 
            and xxwrd_op      = v_op 
            and (xxwrd_status = "" or xxwrd_status  = "N" )
            and xxwrd_close   = no
        exclusive-lock no-wait no-error .
        if not avail xxwrd_det then do:
            if locked xxwrd_det then do:
                message  "工单条码正在被使用,按任意键退出" view-as alert-box title "" .
                undo,leave mainloop.
            end.
        end.

        find first xxwrd_det 
            where xxwrd_wrnbr = integer(v_wrnbr)
            and xxwrd_wolot   = v_wolot 
            and xxwrd_op      = v_op 
            and (xxwrd_status = "" or xxwrd_status  = "N" )
            and xxwrd_close   = no
        no-lock no-error .
        if avail xxwrd_Det then do: /*本工序*/
                              
                v_qty_bom     = xxwrd_qty_bom .
                v_qty_rework  = xxwrd_qty_rework .
                v_qty_return  = xxwrd_qty_return .
                v_qty_ord2    = xxwrd_qty_ord  .
                v_qty_comp    = xxwrd_qty_comp .
                v_qty_rjct    = xxwrd_qty_rejct .
                v_part        = xxwrd_part .
                v_inv_lot     = xxwrd_inv_lot .
                v_time_setup  = xxwrd_time_setup / 3600 .
                v_time_run    = xxwrd_time_run / 3600.        

        end.  /*本工序*/
        
        find first xpt_mstr where xpt_part = v_part no-lock no-error .
        if avail xpt_mstr then disp xpt_um xpt_desc1 xpt_desc2 with frame a .
        disp v_wolot v_op v_part v_qty_ord2 v_inv_lot v_qty_comp v_qty_rjct  v_qty_rework v_qty_return v_time_setup v_time_run  
        v_time_setup2 v_time_setup3 v_time_run2 v_time_run3  with frame a . 




    do  on error undo,retry: /*update_loop*/

        update v_time_setup2 v_time_setup3 v_time_run2 v_time_run3  /*盘点临时程式*/
        with frame a .        
        {xserr001.i "v_time_setup2" } /*检查数量栏位是否输入了问号*/
        {xserr001.i "v_time_run2" } /*检查数量栏位是否输入了问号*/
        {xserr001.i "v_time_setup3" } /*检查数量栏位是否输入了问号*/
        {xserr001.i "v_time_run3" } /*检查数量栏位是否输入了问号*/



    end. /*update_loop*/
    


/*  start ---------------------------------------------------------------------------------------*/  

v_date   = today.
v_time   = time - (time mod 60) . /*保证时间点一致*/
v_msgtxt = "" .   /*提示信息*/



/*更新:本次指令*/
do  :  /*xxfb*/

    /*改本次反馈工序的数量*/
    find first xxwrd_Det 
        where xxwrd_wrnbr = integer(v_wrnbr) 
        and xxwrd_wolot   = v_wolot
        and xxwrd_op      = v_op 
        and (xxwrd_status = "" or xxwrd_status  = "N" )
        and xxwrd_close   = no 
    exclusive-lock no-error .
    if avail xxwrd_det then do:

            assign xxwrd_time_setup = xxwrd_time_setup + (v_time_setup2 + v_time_setup3) * 3600  
                   xxwrd_time_run   = xxwrd_time_run   + (v_time_run2 + v_time_run3) * 3600 .

    end. /*if avail xxwrd_det*/


    find first xwo_mstr where xwo_lot = v_wolot no-lock no-error.
    find first xcode_mstr where xcode_fldname = v_fldname and xcode_value = v_line no-lock no-error.



if v_time_setup2 <> 0 then do:

    v_trnbr = 0 .
    v_nbrtype =  "bctrnbr" . /*xxfb_hist,交易流水号*/
    run getnbr(input v_nbrtype ,output v_trnbr) .

    create  xxfb_hist .
    assign  xxfb_trnbr       = integer(v_trnbr) 
            xxfb_date        = today  
            xxfb_date_end    = v_date  
            xxfb_date_start  = v_date  
            xxfb_time        = time - (time mod 60)  
            xxfb_time_end    = v_time_setup2 * 3600  
            xxfb_time_start  = 0  
            xxfb_nbr         = "" 
            xxfb_program     = execname
            xxfb_wotype      = ""   
            xxfb_qty_fb      = 0   
            xxfb_rmks        = "盘点"    
            xxfb_rsn_code    = ""  
            xxfb_user        = v_user  
            xxfb_user2       = v_user2
            xxfb_op          = v_op  
            xxfb_wc          = v_wc  
            xxfb_wolot       = v_wolot  
            xxfb_wonbr       = v_wonbr 
            xxfb_part        = if avail xwo_mstr then xwo_part else ""   
            xxfb_type        = "11"  
            xxfb_type2       = "调机/准备时间" 
            xxfb_update      = no  
            .

end.

if v_time_setup3 <> 0 then do:

    v_trnbr = 0 .
    v_nbrtype =  "bctrnbr" . /*xxfb_hist,交易流水号*/
    run getnbr(input v_nbrtype ,output v_trnbr) .

    create  xxfb_hist .
    assign  xxfb_trnbr       = integer(v_trnbr) 
            xxfb_date        = today  
            xxfb_date_end    = v_date  
            xxfb_date_start  = v_date  
            xxfb_time        = time - (time mod 60)  
            xxfb_time_end    = v_time_setup3 * 3600  
            xxfb_time_start  = 0  
            xxfb_nbr         = "" 
            xxfb_program     = execname
            xxfb_wotype      = "R"   
            xxfb_qty_fb      = 0   
            xxfb_rmks        = "盘点"    
            xxfb_rsn_code    = ""  
            xxfb_user        = v_user
            xxfb_user2       = v_user2
            xxfb_op          = v_op  
            xxfb_wc          = v_wc  
            xxfb_wolot       = v_wolot  
            xxfb_wonbr       = v_wonbr 
            xxfb_part        = if avail xwo_mstr then xwo_part else ""   
            xxfb_type        = "11"  
            xxfb_type2       = "调机/准备时间" 
            xxfb_update      = no  
            .
end.

if v_time_run2 <> 0 then do:

    v_trnbr = 0 .
    v_nbrtype =  "bctrnbr" . /*xxfb_hist,交易流水号*/
    run getnbr(input v_nbrtype ,output v_trnbr) .

    create  xxfb_hist .
    assign  xxfb_trnbr       = integer(v_trnbr) 
            xxfb_date        = today  
            xxfb_date_end    = v_date  
            xxfb_date_start  = v_date  
            xxfb_time        = time - (time mod 60)  
            xxfb_time_end    = v_time_run2 * 3600  
            xxfb_time_start  = 0  
            xxfb_nbr         = "" 
            xxfb_program     = execname
            xxfb_wotype      = ""   
            xxfb_qty_fb      = 0   
            xxfb_rmks        = "盘点"    
            xxfb_rsn_code    = ""  
            xxfb_user        = v_user
            xxfb_user2       = v_user2
            xxfb_op          = v_op  
            xxfb_wc          = v_wc  
            xxfb_wolot       = v_wolot  
            xxfb_wonbr       = v_wonbr 
            xxfb_part        = if avail xwo_mstr then xwo_part else ""   
            xxfb_type        = "12"  
            xxfb_type2       = "运行时间" 
            xxfb_update      = no  
            .
end.

if v_time_run3 <> 0 then do:

    v_trnbr = 0 .
    v_nbrtype =  "bctrnbr" . /*xxfb_hist,交易流水号*/
    run getnbr(input v_nbrtype ,output v_trnbr) .

    create  xxfb_hist .
    assign  xxfb_trnbr       = integer(v_trnbr) 
            xxfb_date        = today  
            xxfb_date_end    = v_date  
            xxfb_date_start  = v_date  
            xxfb_time        = time - (time mod 60)  
            xxfb_time_end    = v_time_run3 * 3600  
            xxfb_time_start  = 0  
            xxfb_nbr         = "" 
            xxfb_program     = execname
            xxfb_wotype      = "R"   
            xxfb_qty_fb      = 0   
            xxfb_rmks        = "盘点"    
            xxfb_rsn_code    = ""  
            xxfb_user        = v_user
            xxfb_user2       = v_user2
            xxfb_op          = v_op  
            xxfb_wc          = v_wc  
            xxfb_wolot       = v_wolot  
            xxfb_wonbr       = v_wonbr 
            xxfb_part        = if avail xwo_mstr then xwo_part else ""   
            xxfb_type        = "12"  
            xxfb_type2       = "运行时间" 
            xxfb_update      = no  
            .
end.



    v_msgtxt = "盘点指令完成" .
end.  /*xxfb*/

/*  end ---------------------------------------------------------------------------------------*/  


leave .
end. /*mainloop:*/

hide frame a no-pause .
