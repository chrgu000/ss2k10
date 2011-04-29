/*xxbcprint001.i 备料清单由文本转excel,且加条码 */
/* REVISION: 1.0         Last Modified: 2008/11/25   By: Roger   ECO:*xp001*  */
/*-Revision end------------------------------------------------------------*/


/*xp001************
1.called by xxwoworl*.p    
    --> (修改1)主程式,在主循环的最后,且在主循环内,添加: {xxbcprint001.i} 
2.条码产生判断依据:存在两个星号,
    即: "*WOID加号OP*" ,所以主程式要对应修改(修改2)    
3.外边需要定义一个shared var v_file_tmp ,后台程式固定从v_file_tmp导入 , 所以打印机必须是excel
4.excel输出到固定的路径: c:\gui\report\wo*.xls .
5.最终excel文件名: "wo"+date+time+000+".xls"
6.过程文件*.prn取决于打印机excel的设定,
  这里取值打印机"设备路径名"(prd_det.prd_path),-->用完即删除

 mgmgmt05.p C+                 36.13.2 打印机设置维护                  08/12/18
+--------------------------------- 打印机定义 ---------------------------------+
|         输出至: excel                                   目的地类型: Default  |
|                                                         打印机类型:          |
|           说明:                                            行数/页: 66       |
|       最多页数: 0                                     滚动方式输出: N)否     |
|     设备路径名: c:\gui\report\wo.prn                          脱机: N)否     |
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
define variable x_row as integer init 1. /*行*/
define variable x_col as integer init 1. /*列*/


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
    message "文件不存在:" v_file_tmp " ,程式终止!  " view-as alert-box .
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
        
        if index(vv_text,"") <> 0 /*换行符*/ then do:
            xworksheet:rows(x_row + 1):pagebreak = 1 .
            vv_text = substring(vv_text,2) . /*换行符,都在第一码,所以舍弃第一码*/ 
        end.

        /*
        一共有两种条码
        1.*woid+op*
        2.#woid#
        */

        if trim(vv_text) begins "*" then do: /*需转工单工序条码*/
            vv_start  = index(vv_text,"*") . /*理论上 vv_start = 1 */
            vv_length = index(vv_text,"*",vv_start + 1 ) .
            if vv_length <> 0 then do:
                /*根据条码宽度,添加空格,调整右边字符位置*/
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
            else do: /*不需转条码*/
                x_row = x_row + 1.
                x_col = 1.
                xworksheet:cells(x_row,x_col) = vv_text  .
            end. /*不需转条码*/
        end. /*需转工单工序条码*/
        else if trim(vv_text) begins "#" then do: /*需转工单标志条码*/
            vv_start  = index(vv_text,"#") . /*理论上 vv_start = 1 */
            vv_length = index(vv_text,"#",vv_start + 1 ) .
            if vv_length <> 0 then do:
            
                vv_text = "*" + substring(vv_text,vv_start + 1 ,vv_length - 2 ) + "*" . /* #替换成* */

                x_row = x_row + 1.
                x_col = 1.
                xworksheet:cells(x_row,x_col) = vv_text  .

                xworksheet:cells(x_row,x_col):Characters(vv_start,vv_length):Font:name = "3 of 9 Barcode" .
                xworksheet:cells(x_row,x_col):Characters(vv_start,vv_length):Font:size = 22 .
                xworksheet:rows(x_row):RowHeight = 14.25 .
                xworksheet:rows(x_row):VerticalAlignment = 3 .
            end.
            else do: /*不需转条码*/
                x_row = x_row + 1.
                x_col = 1.
                xworksheet:cells(x_row,x_col) = vv_text  .
            end. /*不需转条码*/
        end. /*需转工单标志条码*/
        else do: /*不需转条码*/
            x_row = x_row + 1.
            x_col = 1.
            xworksheet:cells(x_row,x_col) = vv_text  .

        end. /*不需转条码*/

    end. /*repeat*/
    input close .

    xworksheet:pagesetup:Zoom = 80 . /*缩放比*/
    xworksheet:pagesetup:LeftMargin   = xapplication:InchesToPoints(0.4) .  /*左边距*/
    xworksheet:pagesetup:RightMargin  = xapplication:InchesToPoints(0.4) .  /*右边距*/
    xworksheet:pagesetup:TopMargin    = xapplication:InchesToPoints(0) .  /*上边距*/
    xworksheet:pagesetup:BottomMargin = xapplication:InchesToPoints(0) .  /*下边距*/
    xworksheet:pagesetup:HeaderMargin = xapplication:InchesToPoints(0) .  /*页眉*/
    xworksheet:pagesetup:FooterMargin = xapplication:InchesToPoints(0) .  /*页脚*/
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
    xworksheet:range("a1"):value = "条码打印历史记录". 
    xworksheet:Cells(1, 1):HorizontalAlignment = 3 .
    xworksheet:range("a1"):Font:Bold = True .
    xworksheet:range("a1"):font:size=20 .
    xworksheet:Rows("1:1"):EntireRow:AutoFit .  
    x_col = x_col + 1.


error-status:get-message(1)


    */
