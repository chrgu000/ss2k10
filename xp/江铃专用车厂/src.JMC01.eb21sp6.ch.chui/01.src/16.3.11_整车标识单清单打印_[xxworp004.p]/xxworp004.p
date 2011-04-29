/*xxworp004.p 整车标识单清单打印    */
/* REVISION: 101027.1   Created On: 20101027   By: Softspeed Roger Xiao                               */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 101027.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/


{mfdtitle.i "101027.1"}

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
define var v_desc3    like pt_Desc1 format "x(48)". 

define var v_ii       as integer .
define var v_jj       as integer .
define var v_seq_num  as char format "x(20)" .


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
    " "
    " "
    " "
    " "
    " "
    " " 
    "整车标识单清单"
    .


export delimiter "~011"
    "行号"
    "打印"
    "工单编号"
    "工单ID"
    "计划下线日期"
    "整车型号" 
    "车型描述"
    "二类底盘型号"
    "厢体SVO编号"
    "SVO订单号"
    "车辆去向"
    "工单数量"
    "首辆编号"
    "车辆编号"
    .

v_ii = 0 .

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
    v_desc3 = if avail pt_mstr then pt_break_cat else "" .

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

    v_seq_num = "" .
    v_jj = integer(wo_project)  no-error.
    if error-status:error then do:
        v_seq_num = "error" .
        v_jj = 0 .
    end.
    else if v_jj = 0 then v_seq_num = "error" .
    else v_seq_num = string(v_jj).

    v_jj = 0 .
    do v_jj = 1 to round(wo_qty_ord,0) :
        v_ii = v_ii + 1 .
        export delimiter "~011"
                v_ii 
                "Y"
                wo_nbr
                wo_lot
                if wo_rel_date = ? then "" else string(year(wo_rel_date),"9999") + "/" + string(month(wo_rel_date),"99") + "/" + string(day(wo_rel_date),"99") 
                wo_part
                v_desc1
                v_desc3
                wo_lot_next
                wo_so_job
                wo_rmks
                wo_qty_ord 
                wo_project
                v_seq_num
                .

        if v_seq_num <> "error" then 
            v_seq_num = string(integer(v_seq_num) + 1 ) .
    end.

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
