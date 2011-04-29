/*sub-program to : 指定excel的某一行,按照设定的栏数,分别求和.*/
 
Define Input Parameter v_file    AS Char . 
Define Input Parameter v_line    As Integer .
DEFINE Input Parameter v_first   AS Char .
Define Input Parameter v_month   As Integer .
Define Input Parameter v_length  As Integer .

/**//*
Define Var v_file    AS Char . 
Define Var v_line    As Integer .
DEFINE VAR v_first   AS Char .
Define Var v_month   As Integer .
Define Var v_length  As Integer .

v_file = "d:\test.xls" .
v_line = 4 .
v_first = "G" .
v_length = 7 .
v_month = 01.
*/







def var vchexcel     as com-handle no-undo.
def var vchworkbook  as com-handle no-undo.
def var vchworksheet as com-handle no-undo.

Define Var v_sum     As Decimal .
Define Var v_qty     As Decimal .
DEFINE VAR i         AS Integer .
Define Var j         As Integer .
Define Var v_start   As Integer .
Define Var v_end     As Integer .
Define Var v_rel    As Date .
Define Var v_due    As Date .
Define Var v_match   As Logical .
Define Var clm    AS CHAR Extent 104 Initial 
    ["A","B","C","D","E","F","G",
     "H","I","J","K","L","M","N",
     "O","P","Q","R","S","T",
     "U","V","W","X","Y","Z",
     "AA","AB","AC","AD","AE","AF","AG",
     "AH","AI","AJ","AK","AL","AM","AN",
     "AO","AP","AQ","AR","AS","AT",
     "AU","AV","AW","AX","AY","AZ",
     "BA","BB","BC","BD","BE","BF","BG",
     "BH","BI","BJ","BK","BL","BM","BN",
     "BO","BP","BQ","BR","BS","BT",
     "BU","BV","BW","BX","BY","BZ",
     "CA","CB","CC","CD","CE","CF","CG",
     "CH","CI","CJ","CK","CL","CM","CN",
     "CO","CP","CQ","CR","CS","CT",
     "CU","CV","CW","CX","CY","CZ"].

Define Shared Temp-table tt 
    Field tt_j As Integer 
    Field tt_qty As Decimal 
    Field tt_rel As Date 
    Field tt_due As Date.

/*变量初始化
*******************************************************************/

If v_month = 1 Or v_month = 3 Or v_month = 5 Or v_month = 7 
   Or v_month = 8 Or v_month = 10 Or v_month = 12 Then Do:
    v_end = 31 .
End.
Else If v_month = 2 Then Do:
    v_end = Day(Date(03,01,Year(Today)) - 1) .
End.
Else Do:
    v_end = 30 .
End.
i = 0 .
j = 0 .
v_sum = 0 .
v_rel = ? .
v_due = ? .
v_match = No .


For Each tt:
    Delete tt .
End.


/*确定数量数据起止列
*******************************************************************/



Do i = 1 To 104 While v_match = No :
    v_match = clm[i] = v_first .
End.
i = i - 1 .
v_start = i .
v_end = i + v_end - 1 .
/* Disp  i v_start v_end clm[i] clm[v_end] .*/

/*确定第一个发放日期:第一个有数量的数据列i,
*******************************************************************/


create "excel.application":u vchexcel.
assign vchexcel:visible = no 
       vchworkbook      = vchexcel:workbooks:open(v_file)
       vchworksheet     = vchexcel:sheets:item(1).

repeat while i <=  v_end  :
	v_qty = if vchworksheet:range(clm[i] + string(v_line)):value = ? then 0 
			else vchworksheet:range(clm[i] + string(v_line)):value .

	if v_qty > 0 then leave .
    i = i + 1 .
end.


vchexcel:displayalerts = false.
vchworkbook:close.
release object vchworksheet.
release object vchworkbook.

vchexcel:quit.
release object vchexcel.

/*按区间长度和第一个发放日,划分每个小工单,存进table tt:
*******************************************************************/

create "excel.application":u vchexcel.
assign vchexcel:visible = no 
       vchworkbook      = vchexcel:workbooks:open(v_file)
       vchworksheet     = vchexcel:sheets:item(1).
Repeat:
    j = i .
    Do i = j To j + v_length - 1 While i <= v_end  :
        /* Disp j i clm[j] clm[i] . */
        v_qty = If vchworksheet:range(clm[i] + string(v_line)):value = ? Then 0 
                Else vchworksheet:range(clm[i] + string(v_line)):value .
        v_sum = v_sum + v_qty .
        If v_rel = ? And v_sum > 0 Then v_rel = Date(v_Month, i - v_start + 1 ,Year(Today)) .
		IF v_qty > 0 THEN  v_due =  Date(v_Month, i - v_start + 1 ,Year(Today)) .
    End.
    If v_sum > 0 Then Do:
        Find First tt Where tt_j = j No-lock No-error .
        If Not Avail tt Then Do:
            Create tt .
            Assign  tt_j = j 
                    tt_qty = v_sum
                    tt_rel = v_rel 
					tt_due = v_due.
        End.
    End.

    v_sum = 0 .
    v_rel = ? .
	v_due = ? .
    If i > v_end Then Leave .
End. /*Repeat:*/

vchexcel:displayalerts = false.
vchworkbook:close.
release object vchworksheet.
release object vchworkbook.

vchexcel:quit.
release object vchexcel.



/*For Each tt :   Disp tt with stream-io. End. 
output to d:\1234.txt.
For Each tt :   Disp tt  with stream-io. End. 
output close.*/
/**********************************************************************/
