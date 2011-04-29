/*xxbcprint001.i �����嵥���ı�תexcel,�Ҽ����� */
/* REVISION: 1.0         Last Modified: 2008/11/25   By: Roger   ECO:*xp001*  */
/*-Revision end------------------------------------------------------------*/


/*xp001************
1.called by xxwoworl*.p    
    --> (�޸�1)����ʽ,����ѭ�������,������ѭ����,���: {xxbcprint001.i} 
2.��������ж�����:���������Ǻ�,
    ��: "*WOID�Ӻ�OP*" ,��������ʽҪ��Ӧ�޸�(�޸�2)    
3.�����Ҫ����һ��shared var v_file_tmp ,��̨��ʽ�̶���v_file_tmp���� , ���Դ�ӡ��������excel
4.excel������̶���·��: c:\gui\report\wo*.xls .
5.����excel�ļ���: "wo"+date+time+000+".xls"
6.�����ļ�*.prnȡ���ڴ�ӡ��excel���趨,
  ����ȡֵ��ӡ��"�豸·����"(prd_det.prd_path),-->���꼴ɾ��

 mgmgmt05.p C+                 36.13.2 ��ӡ������ά��                  08/12/18
+--------------------------------- ��ӡ������ ---------------------------------+
|         �����: excel                                   Ŀ�ĵ�����: Default  |
|                                                         ��ӡ������:          |
|           ˵��:                                            ����/ҳ: 66       |
|       ���ҳ��: 0                                     ������ʽ���: N)��     |
|     �豸·����: c:\gui\report\wo.prn                          �ѻ�: N)��     |
+------------------------------------------------------------------------------+

***********xp001*/ 

/***********
define var v_file_tmp as char format "x(40)" .  v_file_tmp = "c:\wo.prn" .
define variable wrnbr   as char . wrnbr = "wonbr" .
define variable wrlot   as char . wrlot = "wolot" .
************/

define var vv_file as char format "x(40)" .  
define var vv_text as char format "x(40)" .
define var vv_length as integer .
define var vv_start as integer .

define variable xapplication as com-handle.
define variable xworkbook as com-handle.
define variable xworksheet as com-handle.
define variable x_row as integer init 1. /*��*/
define variable x_col as integer init 1. /*��*/


/*  
vv_file =  "c:\gui\report\wo_" 
            + string(year(today),"9999") 
            + string(month(today),"99") 
            + string(day(today),"99") 
            + "_"
            + string(time) 
            + string(random(1,99)) 
            + ".xls".
*/

vv_file =  "c:\gui\report\wo" 
            + trim(wrnbr)
            + "_"
            + trim(wrlot)
            + ".xls".

if search(v_file_tmp) = ? then do:
    message "�ļ�������:" v_file_tmp " ,��ʽ��ֹ!  " view-as alert-box .
    undo,retry .
end.
else do: /*if search(v_file_tmp) <> ?*/
    
    create "excel.application" xapplication.
    xworkbook = xapplication:workbooks:add().
    xworksheet = xapplication:sheets:item(1).  
    x_row = 0.
    x_col = 0.

    input from  value(v_file_tmp). 
    repeat:	
        vv_text = "" .
        import unformatted vv_text .
        
        if index(vv_text,"") <> 0 /*���з�*/ then do:
            xworksheet:rows(x_row + 1):pagebreak = 1 .
            vv_text = substring(vv_text,2) . /*���з�,���ڵ�һ��,����������һ��*/ 
        end.

        /*
        һ������������
        1.*woid+op*
        2.#woid#
        */

        if trim(vv_text) begins "*" then do: /*��ת������������*/
            vv_start  = index(vv_text,"*") . /*������ vv_start = 1 */
            vv_length = index(vv_text,"*",vv_start + 1 ) .
            if vv_length <> 0 then do:
                /*����������,��ӿո�,�����ұ��ַ�λ��*/
                if length(substring(vv_text,vv_start,vv_length)) = 13 then vv_text = substring(vv_text,1,vv_length) + fill(" ",4)  + trim(substring(vv_text,vv_length + 1 )) .
                if length(substring(vv_text,vv_start,vv_length)) = 12 then vv_text = substring(vv_text,1,vv_length) + fill(" ",6)  + trim(substring(vv_text,vv_length + 1 )) .
                if length(substring(vv_text,vv_start,vv_length)) = 11 then vv_text = substring(vv_text,1,vv_length) + fill(" ",8)  + trim(substring(vv_text,vv_length + 1 )) .
                if length(substring(vv_text,vv_start,vv_length)) = 10 then vv_text = substring(vv_text,1,vv_length) + fill(" ",10) + trim(substring(vv_text,vv_length + 1 )) .
                if length(substring(vv_text,vv_start,vv_length)) = 9  then vv_text = substring(vv_text,1,vv_length) + fill(" ",12) + trim(substring(vv_text,vv_length + 1 )) .
                if length(substring(vv_text,vv_start,vv_length)) = 8  then vv_text = substring(vv_text,1,vv_length) + fill(" ",14) + trim(substring(vv_text,vv_length + 1 )) .
                if length(substring(vv_text,vv_start,vv_length)) = 7  then vv_text = substring(vv_text,1,vv_length) + fill(" ",16) + trim(substring(vv_text,vv_length + 1 )) .
                if length(substring(vv_text,vv_start,vv_length)) = 6  then vv_text = substring(vv_text,1,vv_length) + fill(" ",19) + trim(substring(vv_text,vv_length + 1 )) .
                if length(substring(vv_text,vv_start,vv_length)) = 5  then vv_text = substring(vv_text,1,vv_length) + fill(" ",21) + trim(substring(vv_text,vv_length + 1 )) .
                if length(substring(vv_text,vv_start,vv_length)) = 4  then vv_text = substring(vv_text,1,vv_length) + fill(" ",23) + trim(substring(vv_text,vv_length + 1 )) .
                
                x_row = x_row + 1.
                x_col = 1.
                xworksheet:cells(x_row,x_col) = vv_text  .

                xworksheet:cells(x_row,x_col):Characters(vv_start,vv_length):Font:name = "3 of 9 Barcode" .
                xworksheet:cells(x_row,x_col):Characters(vv_start,vv_length):Font:size = 22 .
                xworksheet:rows(x_row):RowHeight = 14.25 .
                xworksheet:rows(x_row):VerticalAlignment = 3 .
            end.
            else do: /*����ת����*/
                x_row = x_row + 1.
                x_col = 1.
                xworksheet:cells(x_row,x_col) = vv_text  .
            end. /*����ת����*/
        end. /*��ת������������*/
        else if trim(vv_text) begins "#" then do: /*��ת������־����*/
            vv_start  = index(vv_text,"#") . /*������ vv_start = 1 */
            vv_length = index(vv_text,"#",vv_start + 1 ) .
            if vv_length <> 0 then do:
            
                vv_text = "*" + substring(vv_text,vv_start + 1 ,vv_length - 2 ) + "*" . /* #�滻��* */

                x_row = x_row + 1.
                x_col = 1.
                xworksheet:cells(x_row,x_col) = vv_text  .

                xworksheet:cells(x_row,x_col):Characters(vv_start,vv_length):Font:name = "3 of 9 Barcode" .
                xworksheet:cells(x_row,x_col):Characters(vv_start,vv_length):Font:size = 22 .
                xworksheet:rows(x_row):RowHeight = 14.25 .
                xworksheet:rows(x_row):VerticalAlignment = 3 .
            end.
            else do: /*����ת����*/
                x_row = x_row + 1.
                x_col = 1.
                xworksheet:cells(x_row,x_col) = vv_text  .
            end. /*����ת����*/
        end. /*��ת������־����*/
        else do: /*����ת����*/
            x_row = x_row + 1.
            x_col = 1.
            xworksheet:cells(x_row,x_col) = vv_text  .

        end. /*����ת����*/

    end. /*repeat*/
    input close .

    xworksheet:pagesetup:Zoom = 80 . /*���ű�*/
    xworksheet:pagesetup:LeftMargin   = xapplication:InchesToPoints(0.4) .  /*��߾�*/
    xworksheet:pagesetup:RightMargin  = xapplication:InchesToPoints(0.4) .  /*�ұ߾�*/
    xworksheet:pagesetup:TopMargin    = xapplication:InchesToPoints(0) .  /*�ϱ߾�*/
    xworksheet:pagesetup:BottomMargin = xapplication:InchesToPoints(0) .  /*�±߾�*/
    xworksheet:pagesetup:HeaderMargin = xapplication:InchesToPoints(0) .  /*ҳü*/
    xworksheet:pagesetup:FooterMargin = xapplication:InchesToPoints(0) .  /*ҳ��*/
    xapplication:displayalerts = false.
    xworkbook:SaveAs(vv_file,,,,,,1).
    /*xworkbook:printout.*/
    xapplication:visible = true.  
    xworkbook:printpreview.

    xapplication:quit .
    release object xworksheet.
    release object xworkbook.
    release object xapplication.



end.  /*if search(v_file_tmp) <> ?*/


    /*
    xworksheet:range("a1:k1"):select.
    xworksheet:range("a1:k1"):merge.
    xworksheet:range("a1"):value = "�����ӡ��ʷ��¼". 
    xworksheet:Cells(1, 1):HorizontalAlignment = 3 .
    xworksheet:range("a1"):Font:Bold = True .
    xworksheet:range("a1"):font:size=20 .
    xworksheet:Rows("1:1"):EntireRow:AutoFit .  
    x_col = x_col + 1.


error-status:get-message(1)


    */
