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
}  /*&pagedFlag = "nopage",ȡ�����з�,�������������page*/

rptloop:
do on error undo, return error on endkey undo, return error:            

    for each err_det
        break by err_site by err_type by err_part
        with frame x 
        width 200:
        disp 
            err_site   label "�ص�" 
            err_desc   label "��������"
            err_part   label "��������"
        with frame x.
    end. /*for each err_det*/

end. /* rptloop: */


{mfreset.i}



