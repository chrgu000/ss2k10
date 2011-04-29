/* xxscraprp001.p - 次品明细报表                                                               */
/* REVISION: 1.0      Created : 20090903   BY: Roger Xiao  ECO:*090903.1*   */

/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 090903.1  By: Roger Xiao */
/* SS - 100327.1  By: Roger Xiao */  /*返修原因的代码类型改为(QC, and reject) */
/* SS - 100406.1  By: Roger Xiao */  /*取消次品库存校验*/


/*
1.数据源xlkh_hist,所以:如果某天没有次品,则xlkh_hist无记录,则无生产数量记录显示
2.界面上的生产日期实际为生产完成的回报日期,不是生效日期.
*/


{mfdtitle.i "100406.1"}


define var date      as date .
define var date1     as date .
define var line      like ln_line.
define var line1     like ln_line.
define var part      like pt_part .
define var part1     like pt_part .
define var rsncode   as char .
define var rsncode1  as char .
define var v_time      as integer format ">>".
define var v_time1     as integer format ">>" .

define var v_qty_oh   like tr_qty_loc .
define var v_qty_prd  like tr_qty_loc .
define var v_rsncode  as char .
define var v_rsndesc  like rsn_desc .
define var v_qc_type as char .  
define var v_scrap_type as char .  
/* SS - 100327.1 - B 
v_qc_type = "reject" .
v_scrap_type = "reject" .
   SS - 100327.1 - E */
/* SS - 100327.1 - B */
v_qc_type = "QC" .
v_scrap_type = "QC" .
/* SS - 100327.1 - E */


define var site       like pt_site .
define var v_qc_loc   like pt_loc  .


define frame a .
form
    SKIP(.2)
    date                colon 18  label "生产日期" 
    date1               colon 53  label "至"        
    line                colon 18  label "生产线"   
    line1               colon 53  label "至"       
    part                colon 18  label "零件编号" 
    part1               colon 53  label "至"       
    rsncode             colon 18  label "原因代码" 
    rsncode1            colon 53  label "至"       
    v_time              colon 18  label "反馈时间" 
    v_time1             colon 53  label "至"        
        
skip(2) 
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{wbrp01.i}
rploop:
repeat:
    if date     = low_date then date  = ? .
    if date1    = hi_date  then date1 = ? .
    if line1    = hi_char  then line1 = "" .
    if part1    = hi_char  then part1 = "" .
    if rsncode1 = hi_char  then rsncode1 = "" .
    if v_time1  = 24       then v_time1 = 0 .
    
    update 
        date     
        date1    
        line     
        line1    
        part     
        part1    
        rsncode  
        rsncode1 
        v_time     
        v_time1    
    with frame a.

    if date     = ?  then date      =  low_date.
    if date1    = ?  then date1     =  hi_date .
    if line1    = "" then line1     =  hi_char .
    if part1    = "" then part1     =  hi_char .
    if rsncode1 = "" then rsncode1  =  hi_char .
    if v_time1  = 0  then v_time1   =  24      .

/*限制条件:次品库存要和回报数据相同*/
    v_qc_loc = "" .
    find first icc_ctrl where icc_domain = global_domain no-lock no-error.
    site = (if available icc_ctrl then icc_site else global_domain).
    find first xkbc_ctrl where xkbc_domain = global_domain no-lock no-error.
    if not avail xkbc_ctrl then do:
        find first loc_mstr where loc_domain = global_domain and loc_site = site and index(loc_desc,"线边不良品仓" ) <> 0 no-lock no-error .
        if avail loc_mstr then do:
            v_qc_loc = loc_loc .
        end.
    end.
    else do:
        v_qc_loc = xkbc_qc_loc .
    end.

/**************************************************/
/* SS - 100406.1 - B 
    message "正在检查实际次品库存数" .
    for each xlkh_hist 
        where xlkh_domain = global_domain 
        and ((xlkh_date >= date and xlkh_date <= date1 ) or xlkh_date = ?)
        and xlkh_line >= line and xlkh_line <= line1 
        and xlkh_part >= part and xlkh_part <= part1 
        and (if index(xlkh_barcode,"qc") <> 0 
                 then (xlkh_barcode >= "x" + xlkh_line + "qc" + rsncode and xlkh_barcode <= "x" + xlkh_line + "qc" + rsncode1) 
                 else  (xlkh_barcode >= "x" + xlkh_line + rsncode and xlkh_barcode <= "x" + xlkh_line + rsncode1)
            )
        and xlkh_time >= v_time * 3600 and xlkh_time <= v_time1 * 3600
        and xlkh_scrap_date = ?  /*未做返修的记录*/
        no-lock break by xlkh_site by xlkh_part:
        if first-of(xlkh_part) then do:
            v_qty_prd = 0 .
        end.
        v_qty_prd = v_qty_prd + xlkh_qc_qty .
        if last-of(xlkh_part) then do:
            v_qty_oh = 0 .
            for each ld_det where ld_domain = global_domain and ld_site = site and ld_part = xlkh_part and ld_loc = v_qc_loc no-lock:
                v_qty_oh = v_qty_oh + ld_qty_oh .
            end. /*for each ld_det*/

            if v_qty_oh < v_qty_prd then do:
                message "零件号:" xlkh_part skip "次品库存(" v_qty_oh ")小于次品回报数(" v_qty_prd ")" view-as alert-box  title "" .
                undo rploop, retry rploop.
            end.
        end.
    end.  /*for each xlkh_hist*/   
   SS - 100406.1 - E */
   
    /* PRINTER SELECTION */
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
hide message no-pause .
mainloop: 
do on error undo, return error on endkey undo, return error:                    
/*put  "test_begin_time: " string(time,"hh:mm:ss") skip(3). */

{mfphead.i}



for each xlkh_hist 
    where xlkh_domain = global_domain 
    and ((xlkh_date >= date and xlkh_date <= date1 ) or xlkh_date = ?)
    and xlkh_line >= line and xlkh_line <= line1 
    and xlkh_part >= part and xlkh_part <= part1 
    and (if index(xlkh_barcode,"qc") <> 0 
             then (xlkh_barcode >= "x" + xlkh_line + "qc" + rsncode and xlkh_barcode <= "x" + xlkh_line + "qc" + rsncode1) 
             else  (xlkh_barcode >= "x" + xlkh_line + rsncode and xlkh_barcode <= "x" + xlkh_line + rsncode1)
        )
    and xlkh_time >= v_time * 3600 and xlkh_time <= v_time1 * 3600
    and xlkh_qc_qty <> 0 
    no-lock
    with frame x width 300:

    find first pt_mstr where pt_domain = global_domain and pt_part = xlkh_part no-lock no-error.

    v_rsncode = if index(xlkh_barcode,"qc") <> 0 
                then substring(xlkh_barcode ,length("x" + xlkh_line + "qc") + 1 )
                else substring(xlkh_barcode ,length("x" + xlkh_line ) + 1 ) .
    find first rsn_ref where rsn_domain = global_domain and  ( rsn_type = v_qc_type or rsn_type = "Reject") and rsn_code = v_rsncode no-lock no-error.
    v_rsndesc = if avail rsn_ref  then rsn_desc else "" .

    v_qty_prd = 0 .
    for each tr_hist 
        use-index tr_date_trn 
        where tr_domain = global_domain 
        and tr_date     = xlkh_date  /*tr_date or tr_effdate ??? */
        and tr_type     = "rct-wo" 
        and tr_part     = xlkh_part 
        and tr_site     = xlkh_site
      /*and tr_loc      = xlkh_line*/   /**次品/废品库位<>prod_line*/
    no-lock:
        v_qty_prd = v_qty_prd + tr_qty_loc .
    end. /*for each tr_hist*/

    disp 
        xlkh_site                    label "地点"
        xlkh_line                    label "生产线"
        xlkh_part                    label "零件号"
        pt_desc1 when avail pt_mstr  label "零件说明1"
        pt_desc2 when avail pt_mstr  label "说明2"
        pt_um    when avail pt_mstr  label "UM"
        xlkh_qc_qty                  label "次品数量"
        v_rsncode                    label "原因代码"
        v_rsndesc                    label "原因描述"
        v_qty_prd                    label "生产数量"
        xlkh_date                    label "刷读日期"
        string(xlkh_time,"HH:mm:ss") label "刷读时间"        
        xlkh_userid                  label "用户"
     
    with frame x  .






end. /*for each xlkh_hist*/

/*put skip(3) "test_end_time: " string(time,"hh:mm:ss") . */

end. /* mainloop: */
{mfrtrail.i}  /* REPORT TRAILER  */
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
