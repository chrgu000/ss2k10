 /* print the result */


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
 /**********
    for each xps_mstr
        where xps_rev = v_rev 
        break by xps_site by xps_part by xps_date
        with frame x width 300:

        /*�����ʽ����????*/


    end. /*for each xps_mstr */
************/

end. /* rptloop: */


{mfreset.i}



