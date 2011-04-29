/*xxworp003p2.p 自动产生加工单 打印子程式   */
/* REVISION: 101028.1   Created On: 20101028   By: Softspeed Roger Xiao                               */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 101028.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/

{mfdeclre.i}
{gplabel.i} 
define input parameter part      like pt_part no-undo.
define input parameter v_qty_ord like wo_qty_ord no-undo.
define input parameter v_type    as char no-undo.

define var v_desc1   as char format "x(48)".
define var v_size    as char format "x(18)" label "下料尺寸" .

define shared temp-table tt no-undo field tt_rec as recid .



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

put skip(1)  "已产生WO如下:" skip .


export delimiter "~011"  
        "工单号"
        "工单ID"
        "物料号"
        "描述"
        "下料尺寸"
        "数量"
        "发放日期"
        "截止日期"
        .


for each tt:
    find wo_mstr where recid(wo_mstr) = tt_rec no-error .
    if avail wo_mstr then do:
        find first pt_mstr
            where pt_domain = global_domain
            and pt_part = wo_part
        no-lock no-error.
        v_desc1 = if avail pt_mstr then pt_desc1 + pt_Desc2 else "" .
        v_size = if avail pt_mstr then pt_article else "" .

        export delimiter "~011"  
            wo_nbr 
            wo_lot
            wo_part
            v_desc1
            v_size
            wo_qty_ord 
            string(year(wo_rel_date),"9999") + "/" + string(month(wo_rel_date),"99") + "/" + string(day(wo_rel_date),"99")
            string(year(wo_due_date),"9999") + "/" + string(month(wo_due_date),"99") + "/" + string(day(wo_due_date),"99")
            .        
    end.
end. /*for each tt:*/

put skip(1) "报表结束"  skip .

{mfreset.i}


