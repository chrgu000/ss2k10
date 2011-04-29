/*xxworp003p1.p 自动产生加工单 打印子程式   */
/* REVISION: 101028.1   Created On: 20101028   By: Softspeed Roger Xiao                               */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 101028.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/

{mfdeclre.i}
{gplabel.i} 

define input parameter part      like pt_part no-undo.
define input parameter v_qty_ord like wo_qty_ord no-undo.
define input parameter rel_date  as date no-undo.
define input parameter due_date  as date no-undo.
define input parameter v_type    as char no-undo.
define input parameter v_key1    as char no-undo.

define var v_desc1   as char format "x(48)".
define var v_size    as char format "x(18)" label "下料尺寸" .



{xxgpseloutxp.i 
    &printType = "printer"
    &printWidth = 132
    &pagedFlag = "nopage"
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


export delimiter "~011"  
        "车型:" part
        "数量:" v_qty_ord 
        "类型:" v_type
        .

put skip(1) "计划产生WO如下:" skip .

export delimiter "~011"  
        "工单号"
        "工单ID"
        "类型"
        "物料号"
        "描述"
        "下料尺寸"
        "数量"
        "发放日期"
        "截止日期"
        .

for each usrw_wkfl 
    where usrw_domain = global_domain 
    and  usrw_key1    = v_key1 
    break by usrw_key4 by usrw_key3 :
    
    usrw_decfld[1]  = usrw_decfld[1] * v_qty_ord .
    
    find first pt_mstr
        where pt_domain = global_domain
        and pt_part = usrw_key3
    no-lock no-error.
    v_desc1 = if avail pt_mstr then pt_desc1 + pt_Desc2 else "" .
    v_size = if avail pt_mstr then pt_article else "" .

    export delimiter "~011" 
        " "
        " "
        usrw_key4
        usrw_key3    
        v_desc1 
        v_size
        usrw_decfld[1] 
        string(year(rel_date),"9999") + "/" + string(month(rel_date),"99") + "/" + string(day(rel_date),"99")
        string(year(due_date),"9999") + "/" + string(month(due_date),"99") + "/" + string(day(due_date),"99")
        .  

end . /*for each usrw_wkfl*/

put skip(1) "报表结束"  skip .

{mfreset.i}


