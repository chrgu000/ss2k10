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

put skip skip(5) "***********  δ������" skip(5) .

    for each nr_det
        break by nr_site by nr_part by nr_due_date 
        with frame x1 
        width 300:
        disp 
            nr_site        label "�ص�"
            nr_part        label "���"
            nr_due_date    label "����"
            nr_qty_open    label "δ������"   format "->,>>>,>>>,>>9.9<<<<"
        with frame x1.
    end. /*for each err_det*/

put skip skip(5) "***********  ���ۿ��" skip(5) .

    for each kc_det
        break by kc_site by kc_part by kc_date 
        with frame x2 
        width 300:
        disp   
            kc_site        label "�ص�"     
            kc_part        label "���"     
            kc_type        label "��������"
            kc_date        label "����"     
            kc_qty_nr      label "δ������"            format "->,>>>,>>>,>>9.9<<<<"
            kc_qty_oh      label "�ų�ǰ���ۿ��"      format "->,>>>,>>>,>>9.9<<<<"
            kc_qty_min     label "����׼����"        format "->,>>>,>>>,>>9.9<<<<"
            kc_qty_max     label "����׼����"        format "->,>>>,>>>,>>9.9<<<<"
        with frame x2.
    end. /*for each err_det*/

put skip skip(5) "***********  �ų�ǰ��������" skip(5) .

    for each xrq_det
        break by xrq_site by xrq_nbr 
        with frame x3 
        width 300:
        disp 
            xrq_site       label "�ص�"       
            xrq_nbr        label "�������"       
            xrq_qty_today  label "��������"   

        with frame x3.
    end. /*for each err_det*/

put skip skip(5) "***********  ������+�Ϻ�,��ϸ" skip(5) .

    for each xln_det
        break by xln_site by xln_line by xln_part 
        with frame x4 
        width 300:
        disp 
            xln_site         label "�ص�"          
            xln_line         label "������"    
            xln_part         label "���"      
            xln_main         label "������"          
            xln_used         label "���ų�"      
            xln_qty_per_min  label "û���ӿ���������"   format "->,>>>,>>>,>>9.9<<<<"
        with frame x4.
    end. /*for each err_det*/

put skip skip(5) "***********  �����ų�,ÿ�����ߵ���������˳��" skip(5) .

    for each ttemp2
        break by tt2_site by tt2_line by tt2_seq 
        with frame x5
        width 300:
        disp 
            tt2_site         label "�ص�"          
            tt2_line         label "������"  
            tt2_seq          label "˳��"
            tt2_part         label "���"      
        with frame x5.
    end. /*for each err_det*/

put skip skip(5) "***********  �����ų�,ÿ�����ߵĲ���" skip(5) .

    for each xcn_det
        break by xcn_site by xcn_line by xcn_date 
        with frame x6
        width 300:
        disp 
            xcn_site        label "�ص�"     
            xcn_line        label "������"   
            xcn_date        label "���"     
            xcn_time_1      label "���1"   
            xcn_time_2      label "���2"   
            xcn_time_3      label "���3" 
            xcn_time_4      label "���4" 
            xcn_time_used   label "�����ų���ʹ�ò���"
        with frame x6.
    end. /*for each err_det*/


put skip skip(5) "***********  �ų���ϸ" skip(5) .

    for each xpsd_det
        break by xpsd_site by xpsd_line by xpsd_date by xpsd_part
        with frame x7
        width 300:
        disp 
            xpsd_rev          label "�汾"  
            xpsd_site         label "�ص�"     
            xpsd_line         label "������"   
            xpsd_part         label "���"   
            xpsd_date         label "����"
            xpsd_type         label "SP_MP"
            xpsd_seq          label "�Ų�˳��"
            xpsd_qty_prod1    label "���1"    format "->,>>>,>>>,>>9.9<<<<"
            xpsd_qty_prod2    label "���2"    format "->,>>>,>>>,>>9.9<<<<"
            xpsd_qty_prod3    label "���3"    format "->,>>>,>>>,>>9.9<<<<"
            xpsd_qty_prod4    label "���4"    format "->,>>>,>>>,>>9.9<<<<"

        with frame x7.
    end. /*for each err_det*/





end. /* rptloop: */


{mfreset.i}
                          