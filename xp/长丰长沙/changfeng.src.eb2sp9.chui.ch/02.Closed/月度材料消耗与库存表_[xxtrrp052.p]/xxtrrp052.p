/* xxtrrp052.p - 材料消耗与库存金额表                                     */
/*----rev history-------------------------------------------------------------------------------------*/
/* REVISION: 100625.1    Created On: 20100625   BY: Softspeed Roger Xiao    */

{mfdtitle.i "100625.1"}

define var v_site  like ld_site no-undo.
define var v_loc   like ld_loc  no-undo .
define var v_loc1  like ld_loc  no-undo .

define var v_part_type  like pt_part_type no-undo.
define var v_part_type1 like pt_part_type no-undo.
define var v_year   as integer format "9999" no-undo.
define var v_month  as integer format "99"   no-undo .

define var v_start1  as date .
define var v_end1    as date .
define var v_start2  as date .
define var v_end2    as date .

define var v_ii as integer .

define var price  like sct_mtl_tl .
define var cmmt   like code_cmmt .

define var rctqty like tr_qty_loc .
define var issqty like tr_qty_loc .
define var cycqty like tr_qty_loc .
define var qcqty  like tr_qty_loc.	/*期初数*/
define var qmqty  like tr_qty_loc.	/*期末数*/
define var qmqty2 like tr_qty_loc.	/*期末数*/

define var tot-rctqty like tr_qty_loc .
define var tot-issqty like tr_qty_loc .
define var tot-cycqty like tr_qty_loc .
define var tot-qcqty  like tr_qty_loc.	/*期初数*/
define var tot-qmqty  like tr_qty_loc.	/*期末数*/


define temp-table tmp_mstr 
    field tmp_part like pt_part            /*物料编码*/
    field tmp_loc like tr_loc            /*库位*/
    field tmp_type like pt_part_type    /*材料类型*/
    field tmp_qty14 like ld_qty_oh        /*库存数*/

    field tmp_qty1 like ld_qty_oh        /*大于截至日期的入库事务的入库数*/
    field tmp_qty2 like ld_qty_oh        /*大于截至日期的出库事务的出库数*/

    field tmp_qty3 like ld_qty_oh        /*本期入库*/
    field tmp_qty4 like ld_qty_oh        /*本期出库*/

    field tmp_qty5 like ld_qty_oh        /*采购入库*/
    field tmp_qty6 like ld_qty_oh        /*采购退货*/
    field tmp_qty7 like ld_qty_oh        /*计划外入库*/
    field tmp_qty8 like ld_qty_oh        /*转仓入库*/
    field tmp_qty9 like ld_qty_oh        /*盘盈亏*/
    field tmp_qty10 like ld_qty_oh        /*工单出库*/
    field tmp_qty11 like ld_qty_oh        /*销售出库*/    
    field tmp_qty12 like ld_qty_oh        /*计划外出库*/
    field tmp_qty13 like ld_qty_oh        /*转仓出库*/
    field tmp_qty15 like ld_qty_oh        /*工单入库*/
    .

find icc_ctrl no-lock no-error.
v_site  = if avail icc_ctrl then icc_site else "" .
v_year  = year(today) .
v_month = month(today) - 1 .

form
    SKIP(.2)
    v_site            colon 18  label "地点"         
    v_loc             colon 18  label "库位"         
    v_loc1            colon 45  label "至" 
    v_part_type       colon 18  label "项目类型"        
    v_part_type1      colon 45  label "至"              
                                       
    v_year            colon 18  label "年份"            
    v_month           colon 45  label "期间"     
        
skip(2) 
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    if v_part_type1    = hi_char  then v_part_type1 = "" .
    if v_loc1          = hi_char  then v_loc1 = "" .

    for each tmp_mstr :
        delete tmp_mstr .
    end.
    
    update 
        v_site
        v_loc   
        v_loc1
        v_year       
        v_month      
        v_part_type  
        v_part_type1 
    with frame a.

    if v_part_type1    = "" then v_part_type1     =  hi_char .
    if v_loc1    = ""       then v_loc1           =  hi_char .

    if v_site = "" or (not can-find(first si_mstr where si_site = v_site no-lock)) then do:
        message "错误:无效地点,请重新输入" .
        next-prompt v_site .
        undo,retry.
    end.

    if v_year = 0  or v_year = ?  then v_year  = year(today) .
    if v_month = 0 or v_month = ? then v_month = month(today) - 1 .

    find first glc_cal where glc_year = v_year and glc_per = v_month no-lock no-error .
    if not avail glc_cal then do:
        message  "错误:无效会计年度/期间,请重新输入" .
        next-prompt v_year .
        undo,retry.
    end.
    else assign v_start1 = glc_start 
                v_end1   = glc_end.
   
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
mainloop: 
do on error undo, return error on endkey undo, return error:                    
   
    
    for each tmp_mstr :
        delete tmp_mstr .
    end.

    for each  pt_mstr 
        use-index pt_part_type
        where pt_part_type >= v_part_type
        and   pt_part_type <= v_part_type1
        no-lock break by pt_part :

            for each tr_hist 
                use-index tr_part_eff
                where tr_part   = pt_part
                and tr_effdate >= v_start1
                and tr_site = v_site 
                and tr_loc  >= v_loc 
                and tr_loc  <= v_loc1
                and tr_qty_loc <> 0
                and tr_ship_type = ""
                no-lock 
                :

                find first tmp_mstr where tmp_part = tr_part and tmp_loc = tr_loc no-error .
                if not avail tmp_mstr then do :
                    create tmp_mstr .
                    assign 
                        tmp_part = tr_part
                        tmp_loc  = tr_loc
                        tmp_type = pt_part_type
                        .
                end.

                if tr_effdate <= v_end1 then do :
                    if ( tr_type begins "RCT" 
                        or tr_type = "CN-RCT" 
                        or tr_type = "TAG-CNT" 
                        or tr_type = "ISS-PRV" 
                        or tr_type = "ISS-RV" 
                        or (tr_type = "RCT-WO" and tr_program = "icunrc01.p")) 
                    then tmp_qty3 = tmp_qty3 + tr_qty_loc.
                    else if (not tr_type begins "CYC") then tmp_qty4 = tmp_qty4 - tr_qty_loc.
                    if ( (tr_type = "RCT-PO" and tr_qty_loc > 0) or (tr_type = "RCT-WO" and tr_program = "icunrc01.p") or (tr_type = "ISS-WO" and tr_program = "icunrc01.p")) then tmp_qty5 = tmp_qty5 + tr_qty_loc.
                    if ( tr_type = "ISS-PRV" or tr_type = "ISS-RV" or (tr_type = "RCT-PO" and tr_qty_loc <= 0) ) then tmp_qty6 = tmp_qty6 + tr_qty_loc.
                    if ( tr_type = "RCT-UNP" ) then tmp_qty7 = tmp_qty7 + tr_qty_loc.
                    if ( tr_type = "RCT-TR" ) then tmp_qty8 = tmp_qty8 + tr_qty_loc.

                    if (tr_type = "RCT-WO" and tr_program <> "icunrc01.p") then tmp_qty15 = tmp_qty15 + tr_qty_loc .

                    if ( tr_type = "CYC-RCNT" or tr_type = "CYC-CNT" ) then  tmp_qty9 = tmp_qty9 + tr_qty_loc.

                    if (tr_type = "ISS-WO" ) then tmp_qty10 = tmp_qty10 - tr_qty_loc.
                    if (tr_type = "ISS-SO" ) then tmp_qty11 = tmp_qty11 - tr_qty_loc.
                    if (tr_type = "ISS-UNP" ) then tmp_qty12 = tmp_qty12 - tr_qty_loc.
                    if (tr_type = "ISS-TR" ) then tmp_qty13 = tmp_qty13 - tr_qty_loc.
                end.

                if tr_effdate > v_end1 then do :
                    if ( tr_type begins "RCT" 
                         or tr_type = "CN-RCT" 
                         or (tr_type = "CYC-RCNT" and tr_qty_loc > 0 )
                         or tr_type = "TAG-CNT" 
                         or tr_type = "ISS-PRV" 
                         or tr_type = "ISS-RV" 
                         or (tr_type = "RCT-WO" and tr_program = "icunrc01.p")) 
                    then tmp_qty1 = tmp_qty1 + tr_qty_loc.
                    else tmp_qty2 = tmp_qty2 - tr_qty_loc.
                end.
            end. /*for each tr_hist*/

        for each ld_det 
            use-index ld_part_loc
            where ld_part = pt_part
            and ld_site = v_site
            and ld_loc  >= v_loc 
            and ld_loc  <= v_loc1
            and ld_qty_oh <> 0
            no-lock:
            find first tmp_mstr where tmp_part = ld_part and tmp_loc = ld_loc  no-error .
            if not avail tmp_mstr then do :
                create tmp_mstr .
                assign 
                    tmp_part = ld_part 
                    tmp_loc = ld_loc
                    tmp_type = pt_part_type
                    .
            end.
            tmp_qty14 = tmp_qty14 + ld_qty_oh .
        end. /*for each ld_det*/
    end. /*for each pt_mstr*/

    put "湖南长丰汽车沙发有限责任公司长沙分公司 材料消耗与库存表"  at 40 skip.
    put unformat  "报表期间:" at 46  v_year  "年"  v_month  "月"   skip.

     form
        v_ii                 column-label "序号"
        tmp_type             column-label "物料类型"
        cmmt                 column-label "类型说明"
        tmp_loc              column-label "库位"
        qcqty                column-label "本月期初库存" format "->>,>>>,>>9.99<<"
        rctqty               column-label "本月入库"     format "->>,>>>,>>9.99<<"
        issqty               column-label "本月出库"     format "->>,>>>,>>9.99<<"
        qmqty2               column-label "期末理论库存" format "->>,>>>,>>9.99<<"
        qmqty                column-label "期末实际库存" format "->>,>>>,>>9.99<<"
        cycqty               column-label "差异"         format "->>,>>>,>>9.99<<"       
    with frame x with stream-io width 320 down .



    assign 
        tot-rctqty = 0  
        tot-issqty = 0  
        tot-cycqty = 0  
        tot-qcqty  = 0  
        tot-qmqty  = 0
        v_ii       = 0
        .

    for each tmp_mstr no-lock break by tmp_type by tmp_loc by tmp_part:
        if first-of(tmp_loc) then do:
            qmqty = 0 .
            qcqty = 0 .
            rctqty = 0.
            issqty = 0.
            cycqty = 0.
        end.

        find first sct_det where sct_sim = "standard" and sct_part = tmp_part no-lock no-error .
        price = if avail sct_det then sct_mtl_tl + sct_mtl_ll else 0 .

        assign 
            rctqty  = rctqty + tmp_qty3 * price
            issqty  = issqty + tmp_qty4 * price
            cycqty  = cycqty + tmp_qty9 * price
            qmqty   = qmqty  + (tmp_qty14 - tmp_qty1 + tmp_qty2) * price 
            qcqty   = qcqty  + (tmp_qty14 - tmp_qty1 + tmp_qty2 - tmp_qty3 + tmp_qty4 - tmp_qty9) * price
            . 

        if last-of(tmp_loc) then do:
            find first code_mstr where code_fldname = "pt_part_type" and code_value = tmp_type no-lock no-error .
            cmmt = if avail code_mstr then code_cmmt else "" .

            assign 
                tot-rctqty = rctqty + tot-rctqty 
                tot-issqty = issqty + tot-issqty    
                tot-cycqty = cycqty + tot-cycqty    
                tot-qcqty  = qcqty  + tot-qcqty     
                tot-qmqty  = qmqty  + tot-qmqty  
                .   
            v_ii = v_ii + 1 .
            display 
                v_ii 
                tmp_type                  
                cmmt                      
                tmp_loc                   
                qcqty                     
                rctqty                    
                issqty                    
                (qmqty -  cycqty )  @ qmqty2      
                qmqty                     
                cycqty                     
            with frame x .
            down 1 with frame x .
        end.

    end . /*for each tmp_mstr*/

    down 1 with frame x .
    display 
        ""                           @ v_ii     
        ""                           @ tmp_type
        "合计:"                      @ cmmt  
        ""                           @ tmp_loc 
        tot-qcqty                    @ qcqty                          
        tot-rctqty                   @ rctqty                      
        tot-issqty                   @ issqty                      
        (tot-qmqty -  tot-cycqty )   @ qmqty2                          
        tot-qmqty                    @ qmqty                      
        tot-cycqty                   @ cycqty                            
    with frame x .
    
end. /* mainloop: */
/**{mfrtrail.i}  * REPORT TRAILER  */
{mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
