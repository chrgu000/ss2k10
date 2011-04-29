/*xxsorp401.p SVO车统计报表                                                                           */
/* REVISION: 101021.1   Created On: 20101021   By: Softspeed Roger Xiao                               */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 101021.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/

{mfdtitle.i "101021.1"}

define var v_prgname like execname no-undo.            
define var v_company like ad_name  no-undo .

find first ad_mstr where ad_domain = global_domain and ad_addr = "~~reports" no-lock no-error.
v_company = if available ad_mstr then ad_name else "" .



define var part               like pt_part no-undo.
define var part1              like pt_part no-undo.
define var v_a_date           as date  no-undo.
define var v_a_date1          as date  no-undo.
define var v_b_date           as date  no-undo.
define var v_b_date1          as date  no-undo.
define var v_c_date           as date  no-undo.
define var v_c_date1          as date  no-undo.
define var v_ponbr            like so_po no-undo.
define var v_ponbr1           like so_po no-undo.
define var v_lot              like ld_lot no-undo.
define var v_lot1             like ld_lot no-undo.

define var v_cust as char format "x(40)" .
define var v_cmmt as char format "x(100)" .
define var v_ii   as integer .
define var v_jj   as integer .
define var v_um   as char format "x(2)" initial "台".



form
    SKIP(.2)

    part                     colon 18
    part1                    colon 54   label  {t001.i} 
    v_a_date                 colon 18   label "承诺日期"                
    v_a_date1                colon 54   label  {t001.i} 
    v_b_date                 colon 18   label "排程日期"                
    v_b_date1                colon 54   label  {t001.i} 
    v_c_date                 colon 18   label "入库日期"                
    v_c_date1                colon 54   label  {t001.i} 
    v_ponbr                  colon 18   label "采购单"                
    v_ponbr1                 colon 54   label  {t001.i} 
    v_lot                    colon 18   label "底盘号"                
    v_lot1                   colon 54   label  {t001.i} 


    skip (2)
   
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    if part1      = hi_char       then part1      = "".
    if v_ponbr1   = hi_char       then v_ponbr1   = "".
    if v_lot1     = hi_char       then v_lot1     = "".
    if v_a_date   = low_date      then v_a_date   = ? .
    if v_a_date1  = hi_date       then v_a_date1  = ? .
    if v_b_date   = low_date      then v_b_date   = ? .
    if v_b_date1  = hi_date       then v_b_date1  = ? .
    if v_c_date   = low_date      then v_c_date   = ? . 
    if v_c_date1  = hi_date       then v_c_date1  = ? .



    update  
        part      
        part1     
        v_a_date  
        v_a_date1 
        v_b_date  
        v_b_date1 
        v_c_date  
        v_c_date1 
        v_ponbr   
        v_ponbr1  
        v_lot     
        v_lot1    
    with frame a.

       
    /*BI报表专用,不用再改程式名*/
    if index(execname,".p") <> 0 then v_prgname = entry(1,execname,".p").
    else do:
        message "错误:无效程式名格式" execname .
        undo,retry.
    end.
    

    if part1      =  ""    then part1      = hi_char  .
    if v_ponbr1   =  ""    then v_ponbr1   = hi_char  .
    if v_lot1     =  ""    then v_lot1     = hi_char  .
    if v_a_date   =  ?     then v_a_date   = low_date .
    if v_a_date1  =  ?     then v_a_date1  = hi_date  .
    if v_b_date   =  ?     then v_b_date   = low_date .
    if v_b_date1  =  ?     then v_b_date1  = hi_date  .
    if v_c_date   =  ?     then v_c_date   = low_date . 
    if v_c_date1  =  ?     then v_c_date1  = hi_date  .


    /*不可有换页符&pagedFlag = "nopage"*/
    {gpselout.i &printType = "printer"
                &printWidth = 132
                &pagedFlag = " "
                &stream = " "
                &appendToFile = " "
                &streamedOutputToTerminal = " "
                &withBatchOption = "yes"
                &displayStatementType = 1
                &withCancelMessage = "yes"
                &pageBottomMargin = 6
                &withEmail = "yes"
                &withWinprint = "yes"
                &defineVariables = "yes"}
mainloop: 
do on error undo, return error on endkey undo, return error:                    

/*
put unformatted "#def reportpath=$/JMC01/" + v_prgname  skip.
put unformatted "#def :end" skip.
*/

export delimiter "~011"
    " "
    " "
    " "
    " "
    " "
    " "
    "SVO销售统计报表"
    .

export delimiter "~011"
    "序号"
    "SVO订单号"
    "SVO评审单号"
    "代理商"
    "车型"
    "改制费"
    "描述"
    "单位"
    "数量"
    "承诺交付日期"
    "排程日期"
    "入库日期"
    "底盘号"
    "销售订单号"
    "销售订单行"
    .


v_jj = 0 .
for each sod_det 
        where sod_domain = global_domain 
        and sod_part >= part and sod_part <= part1 
        and ((sod_promise_date >= v_a_date and sod_promise_date <= v_a_date1) or sod_promise_date = ?)
        and ((sod_due_date >= v_b_date and sod_due_date <= v_b_date1 ) or sod_due_date = ?)
        and ((sod_per_date >= v_c_date and sod_per_date <= v_c_date1 ) or sod_per_date = ?)
        and sod_serial  >= v_lot     and sod_serial <= v_lot1 
        and sod_type = "M"
    no-lock,
    each so_mstr 
        where so_domain = global_domain 
        and so_nbr = sod_nbr 
        and so_po >= v_ponbr and so_po <= v_ponbr1 
    no-lock:


    find first ad_mstr where ad_domain = global_domain and ad_type = "customer" and ad_addr = so_cust no-lock no-error.
    v_cust = if avail ad_mstr then ad_sort else so_cust.
    v_cmmt = "" .
    if sod_cmtindx <> 0 then do:
        for each cmt_det where cmt_indx = sod_cmtindx no-lock :
            v_ii = 0 .
            do v_ii = 1 to 15:
                if cmt_cmmt[v_ii] <> "" then do:
                     v_cmmt = v_cmmt + left-trim(right-trim(cmt_cmmt[v_ii])) .
                end.
            end.
        end.
    end. /*if sod_cmtindx*/


    v_jj = v_jj + 1 .
    /*
    export  delimiter ";"
        v_jj
        so_po    
        sod_part 
        v_cust   
        sod_desc 
        sod_price 
        v_cmmt    
        v_um      
        sod_qty_ord 
        if sod_promise_date = ? then "" else string(year(sod_promise_date),"9999") + "/" + string(month(sod_promise_date),"99") + "/" + string(day(sod_promise_date),"99") 
        if sod_due_date = ? then "" else string(year(sod_due_date),"9999") + "/" + string(month(sod_due_date),"99") + "/" + string(day(sod_due_date),"99") 
        if sod_per_date = ? then "" else string(year(sod_per_date),"9999") + "/" + string(month(sod_per_date),"99") + "/" + string(day(sod_per_date),"99") 
        sod_serial
        sod_nbr 
        sod_line 
        /*公司名称*/ v_company 
        /*打印日期*/ string(year(today),"9999") + "/" + string(month(today),"99") + "/" + string(day(today),"99") 
        .
    */

    export delimiter "~011"
        v_jj
        so_po    
        sod_part 
        v_cust   
        sod_desc 
        sod_price 
        v_cmmt    
        v_um      
        sod_qty_ord 
        if sod_promise_date = ? then "" else string(year(sod_promise_date),"9999") + "/" + string(month(sod_promise_date),"99") + "/" + string(day(sod_promise_date),"99") 
        if sod_due_date = ? then "" else string(year(sod_due_date),"9999") + "/" + string(month(sod_due_date),"99") + "/" + string(day(sod_due_date),"99") 
        if sod_per_date = ? then "" else string(year(sod_per_date),"9999") + "/" + string(month(sod_per_date),"99") + "/" + string(day(sod_per_date),"99") 
        sod_serial
        sod_nbr 
        sod_line 
        .
    
end. /*for each*/

end. /* mainloop: */
/* {mfrtrail.i}  *REPORT TRAILER  */
{mfreset.i}
{pxmsg.i &MSGNUM=9 &ERRORLEVEL=1}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
