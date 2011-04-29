/*xxworp002.p 加工单报表    */
/* REVISION: 101022.1   Created On: 20101022   By: Softspeed Roger Xiao                               */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 101022.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/


{mfdtitle.i "101022.1"}

define var v_date     as date label "截止日期" no-undo.
define var v_date1    as date label "至" no-undo.
define var v_part     like pt_part label "车型代码" no-undo.
define var v_part1    like pt_part label "至" no-undo.

define var v_qty_rct  like tr_qty_loc .
define var v_qty_conv like um_conv .
define var v_qty_bom  like wod_bom_qty .
define var v_qty_wt   like tr_qty_loc .
define var v_um       like pt_um .

define var v_desc1    like pt_desc1 format "x(48)" .
define var v_desc2    like pt_Desc1 format "x(48)". 

form
    SKIP(.2)
    v_date                   colon 18 
    v_date1                  colon 53 
    v_part                   colon 18 
    v_part1                  colon 53 

    skip(1) 
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:

    if v_date   = low_date then v_date  = ? .    
    if v_date1  = hi_date  then v_date1 = ? .    
    if v_part1  = hi_char  then v_part1 = "" .    

    update 
        v_date    
        v_date1   
        v_part       
        v_part1     
    with frame a.

    if v_date   = ?   then v_date  = low_date  .    
    if v_date1  = ?   then v_date1 = hi_date   .    
    if v_part1  = ""  then v_part1 = hi_char   .    
    

    {gpselout.i &printType = "printer"
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
mainloop: 
do on error undo, return error on endkey undo, return error:                    


export delimiter "~011"
    "工单号"
    "工单ID"
    "计划生产日期" 
    "底盘下线日期"
    "车型代码" 
    "二类底盘型号"
    "名称"
    "SVO号"
    "数量"
    "订单号"
    "代理商"
    "交付期"
    "开始车辆"
    .

for each wo_mstr  
        use-index wo_due_part
        where wo_mstr.wo_domain = global_domain 
        and (wo_due_date >= v_date and wo_due_date <= v_date1)
        and (wo_part >= v_part and wo_part <= v_part1)
        and wo_nbr begins "K"
    no-lock 
    break by wo_nbr by wo_lot:

    find pt_mstr  
        where pt_mstr.pt_domain = global_domain 
        and  pt_part = wo_part 
    no-lock no-error.
    v_desc1 = if avail pt_mstr then pt_desc1 + pt_desc2 else "" .
    v_desc2 = if avail pt_mstr then pt_break_cat else "" .

    find ptp_det  
        where ptp_det.ptp_domain = global_domain 
        and ptp_part = wo_part 
        and ptp_site = wo_site
    no-lock no-error.

    /* PLANNED ORDERS (WO_STATUS = P) PRINT ONLY PM_CODE = M OR SPACE OR L */
    if wo_status = "P" and 
        ((available ptp_det and ptp_pm_code <> "M" and ptp_pm_code <> "" and ptp_pm_code <> "L")
         or 
        (not available ptp_det and available pt_mstr and pt_pm_code <> "M" and pt_pm_code <> "" and pt_pm_code <> "L"))
    then next.

    export delimiter "~011"
            wo_nbr
            wo_lot
            if wo_due_date = ? then "" else string(year(wo_due_date),"9999") + "/" + string(month(wo_due_date),"99") + "/" + string(day(wo_due_date),"99") 
            if wo_rel_date = ? then "" else string(year(wo_rel_date),"9999") + "/" + string(month(wo_rel_date),"99") + "/" + string(day(wo_rel_date),"99") 
            wo_part
            v_desc2
            v_desc1
            wo_lot_next
            wo_qty_ord 
            wo_so_job
            wo_rmks
            if wo_ord_date = ? then "" else string(year(wo_ord_date),"9999") + "/" + string(month(wo_ord_date),"99") + "/" + string(day(wo_ord_date),"99") 
            wo_project 
            .

    {mfrpchk.i}

end. /*for each wo_mstr */


put skip(1)    
    "报表结束"  skip .

end. /* mainloop: */
/* {mfrtrail.i}  *REPORT TRAILER  */
{mfreset.i}
{pxmsg.i &MSGNUM=9 &ERRORLEVEL=1}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
