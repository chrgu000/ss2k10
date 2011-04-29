/* xxdbsync01.p - SFC db sync with then qad db                                */
/* REVISION: 1.0  LAST MODIFIED: 2009/02/18     BY: QAD roger xiao  NO ECO:   */
/*-Revision end---------------------------------------------------------------*/



/* DISPLAY TITLE */
{mfdtitle.i "1+ "}

define var v_file as char format "x(60)" label "导入导出临时文件" initial "xxdbsync01.d" .
define var v_yn  like mfc_logical extent 15 format "Y/N" initial no .

define var v_starttime as char format "x(30)".
define var v_endtime   as char format "x(30)".


form
    SKIP(.2)
    "请选择需要同步的资料:"
    skip(1)
    v_yn[01] colon 20 label  "工单主档" 
    v_yn[02] colon 20 label  "工单工艺流程" 
    v_yn[03] colon 20 label  "采购单明细" 
    
    v_yn[04] colon 20 label  "通用代码主档"    
    v_yn[05] colon 20 label  "原因代码主档"    
    v_yn[06] colon 20 label  "打印机设定" 
    
    v_yn[07] colon 20 label  "料件基本资料" 
    v_yn[08] colon 20 label  "机器基本资料"                   
    v_yn[09] colon 20 label  "雇员基本资料" 
    skip(4)
    /*                                                    
    v_yn[10] colon 20 label  "同步-"
    v_yn[11] colon 20 label  "同步-"
    v_yn[12] colon 20 label  "同步-"
    v_yn[13] colon 20 label  "同步-"
    v_yn[14] colon 20 label  "同步-"
    v_yn[15] colon 20 label  "同步-"
    */

with frame a  side-labels width 80 attr-space THREE-D  .

view frame a.
clear frame a no-pause .

mainloop:
repeat with frame a:

    ststatus = stline[1].
    status input ststatus.

    update v_yn[01] v_yn[02] v_yn[03] v_yn[04] v_yn[05] v_yn[06] v_yn[07] v_yn[08] v_yn[09] with frame a . 

    v_starttime = string(today) + "-" + string(time,"hh:mm:ss").
    message "同步开始:" v_starttime   .    


    if v_yn[01] = yes then do on error undo ,retry :
        for each xwo_mstr :
            find first wo_mstr 
                where wo_lot = xwo_lot
            no-lock no-error .
            if not avail wo_mstr then do:
                delete xwo_mstr .
            end. 
        end.

        for each wo_mstr no-lock:
            find first xwo_mstr 
                where xwo_lot = wo_lot
            no-error .
            if not avail xwo_mstr then do:
                {xwo_mstr.i}
            end.
            else if 
                 xwo_nbr <> wo_nbr
              or xwo_status <> wo_status
              or xwo_lot_next <> wo_lot_next 
            then do:
                delete xwo_mstr .
                {xwo_mstr.i}
            end. 
        end. /*太多异常字符,没办法dumpload*/

        /*for each wo_mstr no-lock:
            find first xwo_mstr 
                where xwo_lot = wo_lot
            no-error .
            if not avail xwo_mstr then do:
                {xxdbsync01.i "wo_mstr"  "xwo_mstr"}
            end.
            else if 
                 xwo_nbr <> wo_nbr
              or xwo_status <> wo_status
            then do:
                delete xwo_mstr .
                {xxdbsync01.i "wo_mstr"  "xwo_mstr"}
            end. 
        end. */
    end. /*if v_yn[01*/


    if v_yn[02] = yes then do on error undo ,retry :
        for each xwr_route :
            find first wr_route 
                where wr_lot = xwr_lot
                and   wr_op  = xwr_op
            no-lock no-error .
            if not avail wr_route then do:
                delete xwr_route .
            end.
        end.
        
        for each wr_route no-lock:
            find first xwr_route 
                where xwr_lot = wr_lot
                and   xwr_op  = wr_op
            no-error .
            if not avail xwr_route then do:
                {xwr_route.i}
            end.
            else if 
                    xwr_nbr <> wr_nbr
            then do:
                delete xwr_route .
                {xwr_route.i}
            end.
        end. /*太多异常字符,没办法dumpload*/

        /*
        for each wr_route no-lock:
            find first xwr_route 
                where xwr_lot = wr_lot
                and   xwr_op  = wr_op
            no-error .
            if not avail xwr_route then do:
                {xxdbsync01.i "wr_route"  "xwr_route"}
            end.
            else if 
                    xwr_nbr <> wr_nbr
            then do:
                delete xwr_route .
                {xxdbsync01.i "wr_route"  "xwr_route"}
            end.
        end.*/
    end. /*if v_yn[02*/

    if v_yn[03] = yes then do on error undo ,retry :
        for each xpod_det :
            find first pod_det 
                where pod_nbr  = xpod_nbr 
                and   pod_line = xpod_line 
            no-lock no-error .
            if not avail pod_det then do:
                delete xpod_det .
            end. 
        end.

        for each pod_det no-lock:
            find first xpod_det 
                where xpod_nbr  = pod_nbr 
                and   xpod_line = pod_line 
            no-error .
            if not avail xpod_det then do:
                {xxdbsync01.i "pod_det"  "xpod_det"}
            end.
            else if 
                 xpod_part   <> pod_part
              or xpod_wo_lot <> pod_wo_lot
              or xpod_op     <> pod_op
            then do:
                delete xpod_det .
                {xxdbsync01.i "pod_det"  "xpod_det"}
            end. 
        end.
    end. /*if v_yn[03*/

    if v_yn[04] = yes then do on error undo ,retry :
        for each xcode_mstr :
            find first code_mstr 
                where code_fldname = xcode_fldname
                and   code_value   = xcode_value 
            no-lock no-error .
            if not avail code_mstr then do:
                delete xcode_mstr .                
            end. 
        end.

        for each code_mstr no-lock:
            find first xcode_mstr 
                where xcode_fldname = code_fldname
                and   xcode_value   = code_value 
            no-error .
            if not avail xcode_mstr then do:
                {xxdbsync01.i "code_mstr"  "xcode_mstr"}
            end.
            else if 
                 xcode_cmmt <> code_cmmt
            then do:
                delete xcode_mstr .
                {xxdbsync01.i "code_mstr"  "xcode_mstr"}
            end. 
        end.
    end. /*if v_yn[04*/

    if v_yn[05] = yes then do on error undo ,retry :
        for each xrsn_ref :
            find first rsn_ref 
                where rsn_code = xrsn_code
                and   rsn_type = xrsn_type
            no-lock no-error .
            if not avail rsn_ref then do:
                delete xrsn_ref .
            end.            
        end.

        for each rsn_ref no-lock:
            find first xrsn_ref 
                where xrsn_code = rsn_code
                and   xrsn_type = rsn_type
            no-error .
            if not avail xrsn_ref then do:
                {xxdbsync01.i "rsn_ref"  "xrsn_ref"}
            end.            
        end.
    end. /*if v_yn[05*/


    if v_yn[06] = yes then do on error undo ,retry :
        for each xprd_det :
            find first prd_det 
                where prd_dev = xprd_dev
            no-lock no-error .
            if not avail prd_det then do:
                delete xprd_det .
            end.            
        end.

        for each prd_det no-lock:
            find first xprd_det 
                where xprd_dev = prd_dev
            no-error .
            if not avail xprd_det then do:
                {xxdbsync01.i "prd_det"  "xprd_det"}
            end.
            else if 
                 xprd_path <> prd_path
              or xprd_type <> prd_type
            then do:
                delete xprd_det .
                {xxdbsync01.i "prd_det"  "xprd_det"}
            end. 
        end.
    end. /*if v_yn[06*/



    if v_yn[07] = yes then do on error undo ,retry :
        for each xpt_mstr :
            find first pt_mstr 
                where pt_part = xpt_part
            no-lock no-error .
            if not avail pt_mstr then do:
                delete xpt_mstr.
            end. 
        end.

        for each pt_mstr no-lock:
            find first xpt_mstr 
                where xpt_part = pt_part
            no-error .
            if not avail xpt_mstr then do:
                {xxdbsync01.i "pt_mstr"  "xpt_mstr"}
            end. 
        end.
    end. /*if v_yn[07*/


    if v_yn[08] = yes then do on error undo ,retry :
        for each xwc_mstr :
            find first wc_mstr 
                where wc_wkctr = xwc_wkctr
                and   wc_mch   = xwc_mch
            no-lock no-error .
            if not avail wc_mstr then do:
                delete xwc_mstr .
            end. 
        end.

        for each wc_mstr no-lock:
            find first xwc_mstr 
                where xwc_wkctr = wc_wkctr
                and   xwc_mch   = wc_mch
            no-error .
            if not avail xwc_mstr then do:
                {xxdbsync01.i "wc_mstr"  "xwc_mstr"}
            end.
            else if 
                 xwc_desc <> wc_desc
            then do:
                delete xwc_mstr .
                {xxdbsync01.i "wc_mstr"  "xwc_mstr"}
            end. 
        end.
    end. /*if v_yn[08*/



    if v_yn[09] = yes then do on error undo ,retry :

        for each xemp_mstr :
            find first emp_mstr 
                where emp_addr = xemp_addr
            no-error .
            if not avail emp_mstr then do:
                delete xemp_mstr .
            end.
            /*密码写回正式库? 暂不写入*
            if emp__chr01 <> xemp__chr01 then do:
               emp__chr01 = xemp__chr01 .
            end.*/
        end.

        for each emp_mstr no-lock:
            find first xemp_mstr 
                where xemp_addr = emp_addr
            no-error .
            if not avail xemp_mstr then do:
                {xxdbsync01.i "emp_mstr"  "xemp_mstr"}

                /*新雇员密码初始化为 雇员代码密值*/
                find first xemp_mstr 
                    where xemp_addr = emp_addr
                no-error .
                if avail xemp_mstr and xemp__chr01 = "" then do:
                    assign xemp__chr01 = encode(caps(emp_addr)).
                end.
            end.
        end.
    end. /*if v_yn[09*/



v_endtime = string(today) + "-" + string(time,"hh:mm:ss").

    
    message "同步完成:" v_endtime   .

end.   /*  mainloop: */
status input.



