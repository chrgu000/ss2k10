/*print error log to report*/

{mfdeclre.i}
{gplabel.i} 
{pxmaint.i}
{pxpgmmgr.i}

{xxpsmt01var.i }
{mfsprtdf.i } 

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
    &defineVariables = "no"
}  /*&pagedFlag = "nopage",取消换行符,但不能再输出到page*/

rptloop:
do on error undo, return error on endkey undo, return error:            

put skip skip(5) "***********  未结纳入" skip(5) .

    for each nr_det
        break by nr_site by nr_part by nr_due_date 
        with frame x1 
        width 300:
        disp 
            nr_site        label "地点"
            nr_part        label "零件"
            nr_due_date    label "日期"
            nr_qty_open    label "未结纳入"   format "->,>>>,>>>,>>9.9<<<<"
        with frame x1.
    end. /*for each err_det*/

put skip skip(5) "***********  理论库存" skip(5) .

    for each kc_det
        break by kc_site by kc_part by kc_date 
        with frame x2 
        width 300:
        disp   
            kc_site        label "地点"     
            kc_part        label "零件"     
            kc_type        label "纳入类型"
            kc_date        label "日期"     
            kc_qty_nr      label "未结纳入"            format "->,>>>,>>>,>>9.9<<<<"
            kc_qty_oh      label "排程前理论库存"      format "->,>>>,>>>,>>9.9<<<<"
            kc_qty_min     label "库存基准下限"        format "->,>>>,>>>,>>9.9<<<<"
            kc_qty_max     label "库存基准上限"        format "->,>>>,>>>,>>9.9<<<<"
        with frame x2.
    end. /*for each err_det*/

put skip skip(5) "***********  排程前可用容器" skip(5) .

    for each xrq_det
        break by xrq_site by xrq_nbr 
        with frame x3 
        width 300:
        disp 
            xrq_site       label "地点"       
            xrq_nbr        label "容器编号"       
            xrq_qty_today  label "可用数量"   

        with frame x3.
    end. /*for each err_det*/

put skip skip(5) "***********  生产线+料号,明细" skip(5) .

    for each xln_det
        break by xln_site by xln_line by xln_part 
        with frame x4 
        width 300:
        disp 
            xln_site         label "地点"          
            xln_line         label "生产线"    
            xln_part         label "零件"      
            xln_main         label "主产线"          
            xln_used         label "有排程"      
            xln_qty_per_min  label "没分钟可生产个数"   format "->,>>>,>>>,>>9.9<<<<"
        with frame x4.
    end. /*for each err_det*/

put skip skip(5) "***********  本次排程,每个产线的最优生产顺序" skip(5) .

    for each ttemp2
        break by tt2_site by tt2_line by tt2_seq 
        with frame x5
        width 300:
        disp 
            tt2_site         label "地点"          
            tt2_line         label "生产线"  
            tt2_seq          label "顺序"
            tt2_part         label "零件"      
        with frame x5.
    end. /*for each err_det*/

put skip skip(5) "***********  本次排程,每个产线的产能" skip(5) .

    for each xcn_det
        break by xcn_site by xcn_line by xcn_date 
        with frame x6
        width 300:
        disp 
            xcn_site        label "地点"     
            xcn_line        label "生产线"   
            xcn_date        label "零件"     
            xcn_time_1      label "班次1"   
            xcn_time_2      label "班次2"   
            xcn_time_3      label "班次3" 
            xcn_time_4      label "班次4" 
            xcn_time_used   label "本次排程已使用产能"
        with frame x6.
    end. /*for each err_det*/


put skip skip(5) "***********  排程明细" skip(5) .

    for each xpsd_det
        break by xpsd_site by xpsd_line by xpsd_date by xpsd_part
        with frame x7
        width 300:
        disp 
            xpsd_rev          label "版本"  
            xpsd_site         label "地点"     
            xpsd_line         label "生产线"   
            xpsd_part         label "零件"   
            xpsd_date         label "日期"
            xpsd_type         label "SP_MP"
            xpsd_seq          label "排产顺序"
            xpsd_qty_prod1    label "班次1"    format "->,>>>,>>>,>>9.9<<<<"
            xpsd_qty_prod2    label "班次2"    format "->,>>>,>>>,>>9.9<<<<"
            xpsd_qty_prod3    label "班次3"    format "->,>>>,>>>,>>9.9<<<<"
            xpsd_qty_prod4    label "班次4"    format "->,>>>,>>>,>>9.9<<<<"

        with frame x7.
    end. /*for each err_det*/





end. /* rptloop: */


{mfreset.i}
                          