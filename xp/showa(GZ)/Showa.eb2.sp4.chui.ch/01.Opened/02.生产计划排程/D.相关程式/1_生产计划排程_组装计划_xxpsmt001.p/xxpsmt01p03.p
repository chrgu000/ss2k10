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

    for each err_det
        break by err_site by err_type by err_part
        with frame x 
        width 200:
        disp 
            err_site   label "地点" 
            err_desc   label "错误描述"
            err_part   label "错误数据"
        with frame x.
    end. /*for each err_det*/

end. /* rptloop: */


{mfreset.i}



