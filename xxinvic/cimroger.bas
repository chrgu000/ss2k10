Attribute VB_Name = "cimroger"
Public v_Label_0 As String       '<--- main-menu-label,多个sub会调用

'/******* Created By Roger Xiao ,On 2011/03/xx ****************/


'主程式开始:添加目标菜单,到excel菜单栏的最后
Sub Auto_Open()
    
    On Error Resume Next
    v_Label_0 = "SoftSpeed(&S)"
    
    '避免重复增加,先删除本菜单,再重新逐级增加多级菜单
    ActiveMenuBar.Menus(v_Label_0).Delete
       
    '_0: 0级菜单,即主菜单
    Set v_Menu_0 = Application.CommandBars(1).Controls.Add(Type:=msoControlPopup)
        v_Menu_0.Caption = v_Label_0


    '_0X: 1级菜单或项次----------------------------------------------------------------------------------
    Set v_Menu_01 = v_Menu_0.Controls.Add(Type:=msoControlPopup)
        v_Menu_01.Caption = "日供发票导入(&1)"
       
    '_0XX: 2级菜单或项次----------------------------------------------------------------------------------
    Set v_Menu_011 = v_Menu_01.Controls.Add(Type:=msoControlPopup)
        v_Menu_011.Caption = "PL--->List       (&1)"
    Set v_Menu_012 = v_Menu_01.Controls.Add(Type:=msoControlButton)
        v_Menu_012.Caption = "List-->Cim文本 (&2)"
        v_Menu_012.OnAction = "createcim"
        v_Menu_012.BeginGroup = True
    
    
    '_0XXX: 3级菜单或项次----------------------------------------------------------------------------------
    Set v_Menu_0111 = v_Menu_011.Controls.Add(Type:=msoControlButton)
        v_Menu_0111.Caption = "琦玉     (&1)"
        v_Menu_0111.OnAction = "createxls01"
    Set v_Menu_0112 = v_Menu_011.Controls.Add(Type:=msoControlButton)
        v_Menu_0112.Caption = "御练场  (&2)"
        v_Menu_0112.OnAction = "createxls02"
        v_Menu_0112.BeginGroup = True
    Set v_Menu_0113 = v_Menu_011.Controls.Add(Type:=msoControlButton)
        v_Menu_0113.Caption = "名古屋  (&3)"
        v_Menu_0113.OnAction = "createxls03"
        v_Menu_0113.BeginGroup = True
        
        
End Sub


'主程式结束:删除目标菜单
Sub Auto_Close()

    On Error GoTo ErrorHandler
    ActiveMenuBar.Menus(v_Label_0).Delete
    ActiveMenuBar.Reset

ErrorHandler:
    Exit Sub

End Sub

'产生excel导入文件
Sub createxls01()
    Dim wkbk_now    As Workbook
    Dim wksht_old   As Worksheet
    Dim wksht_new   As Worksheet
 
    Dim line_from, line_to As Long
    
    
    '为避免重复,如果当前文件有大于1个分页,,则弹出警告并退出
    '让其自己手工删除当前文件中其他页面
    If ActiveWorkbook.Worksheets.Count > 1 Then
        MsgBox "此文件只允许存在一个分页. 请先删除其他页面...", 48, "警告"
        Exit Sub
    End If
    
    Set wkbk_now = ActiveWorkbook
    Set wksht_old = ActiveWorkbook.ActiveSheet
    wksht_old.Range("A1").Select
    
    '备份当前文件
    'Call BackupThisFile
    
    '复制模板到本excel首页,作为临时模板
    Call CopyFromSampleFile("C:\cim-xxinvmt-sample.xls")
    
    Set wksht_new = ActiveWorkbook.ActiveSheet
    
    'cimload模版的数据写入行初始化
    line_from = 11
    line_to = line_from
    
    '填充数据到指定单元格
    For i = 21 To wksht_old.UsedRange.Rows.Count
    
        If wksht_old.Cells(i, 3).Value = "Total  :" Then
            Exit For
        End If
        
        
        If wksht_old.Cells(i, 9).Value <> "" Then
            
            '指定wksht_new的写入行
            line_to = line_to + 1
            
            '供应商：
            wksht_new.Cells(line_to, 1).Value = "J19X003"
            '发票号：
            wksht_new.Cells(line_to, 2).Value = wksht_old.Cells(16, 10).Value
            '保税否：
            wksht_new.Cells(line_to, 3).Value = wksht_old.Cells(16, 11).Value
            
            '合同号：
            wksht_new.Cells(line_to, 4).Value = wksht_old.Cells(15, 10).Value
            
            '项次：
            wksht_new.Cells(line_to, 13).Value = (line_to - line_from)
            
            '零件图号:
            wksht_new.Cells(line_to, 14).Value = wksht_old.Cells(i, 9).Value
            
            '托号：
            wksht_new.Cells(line_to, 15).Value = wksht_old.Cells(i, 3).Value
            If wksht_new.Cells(line_to, 15).Value = "" Then
                wksht_new.Cells(line_to, 15).Value = wksht_new.Cells(line_to - 1, 15).Value
            End If
            
            '数量：
            wksht_new.Cells(line_to, 16).Value = wksht_old.Cells(i, 29).Value
          
            '量产Z/新机种R：
            wksht_new.Cells(line_to, 17).Value = "Z"
          
        End If
    Next
           
           
    '删除指定页:第一页
    DeleteSheet 1
    
    '保存当前文件
    wkbk_now.SaveAs FileName:="c:\cim-xxinvmt-" & CStr(Year(Now())) & CStr(Month(Now())) & CStr(Day(Now())) & "-" & CStr(Hour(Now())) & "-" & CStr(Minute(Now())) & ".xls", FileFormat:=xlNormal

End Sub

'产生excel导入文件
Sub createxls02()
    Dim wkbk_now    As Workbook
    Dim wksht_old   As Worksheet
    Dim wksht_new   As Worksheet
 
    Dim line_from, line_to As Long
    Dim invoice, contract, baoshui As String
    
    
    '为避免重复,如果当前文件有大于1个分页,,则弹出警告并退出
    '让其自己手工删除当前文件中其他页面
    If ActiveWorkbook.Worksheets.Count > 1 Then
        MsgBox "此文件只允许存在一个分页. 请先删除其他页面...", 48, "警告"
        Exit Sub
    End If
    
    Set wkbk_now = ActiveWorkbook
    Set wksht_old = ActiveWorkbook.ActiveSheet
    wksht_old.Range("A1").Select
    
    '备份当前文件
    'Call BackupThisFile
    
    '复制模板到本excel首页,作为临时模板
    Call CopyFromSampleFile("C:\cim-xxinvmt-sample.xls")
    
    Set wksht_new = ActiveWorkbook.ActiveSheet
    
    'cimload模版的数据写入行初始化
    line_from = 11
    line_to = line_from
    
    '填充数据到指定单元格
    For i = 1 To wksht_old.UsedRange.Rows.Count
    
        If wksht_old.Cells(i, 4).Value = "Total:" Then
            Exit For
        End If
        
        If i < 6 And wksht_old.Cells(i, 3).Value = "Invoice №" Then
            contract = wksht_old.Cells(i, 4).Value
            invoice = wksht_old.Cells(i, 5).Value
            baoshui = wksht_old.Cells(i, 6).Value
        End If
        
        If IsNumeric(wksht_old.Cells(i, 5).Value) And wksht_old.Cells(i, 5).Value <> "" And wksht_old.Cells(i, 3).Value <> "" Then
            
            '指定wksht_new的写入行
            line_to = line_to + 1
            
            '供应商：
            wksht_new.Cells(line_to, 1).Value = "J19X004"
            '发票号：
            wksht_new.Cells(line_to, 2).Value = invoice
            '保税否：
            wksht_new.Cells(line_to, 3).Value = baoshui
            
            '合同号：
            wksht_new.Cells(line_to, 4).Value = contract
            
            '项次：
            wksht_new.Cells(line_to, 13).Value = (line_to - line_from)
            
            '零件图号:
            wksht_new.Cells(line_to, 14).Value = wksht_old.Cells(i, 3).Value
            
            '托号：
            wksht_new.Cells(line_to, 15).Value = wksht_old.Cells(i, 2).Value
            If wksht_new.Cells(line_to, 15).Value = "" Then
                wksht_new.Cells(line_to, 15).Value = wksht_new.Cells(line_to - 1, 15).Value
            End If
            
            '数量：
            wksht_new.Cells(line_to, 16).Value = wksht_old.Cells(i, 5).Value
          
            '量产Z/新机种R：
            wksht_new.Cells(line_to, 17).Value = "Z"
          
        End If
    Next
           
           
    '删除指定页:第一页
    DeleteSheet 1
    
    '保存当前文件
    wkbk_now.SaveAs FileName:="c:\cim-xxinvmt-" & CStr(Year(Now())) & CStr(Month(Now())) & CStr(Day(Now())) & "-" & CStr(Hour(Now())) & "-" & CStr(Minute(Now())) & ".xls", FileFormat:=xlNormal

End Sub


'产生excel导入文件
Sub createxls03()
    Dim wkbk_now    As Workbook
    Dim wksht_old   As Worksheet
    Dim wksht_new   As Worksheet
 
    Dim line_from, line_to As Long
    
    
    '为避免重复,如果当前文件有大于1个分页,,则弹出警告并退出
    '让其自己手工删除当前文件中其他页面
    If ActiveWorkbook.Worksheets.Count > 1 Then
        MsgBox "此文件只允许存在一个分页. 请先删除其他页面...", 48, "警告"
        Exit Sub
    End If
    
    Set wkbk_now = ActiveWorkbook
    Set wksht_old = ActiveWorkbook.ActiveSheet
    wksht_old.Range("A1").Select
    
    '备份当前文件
    'Call BackupThisFile
    
    '复制模板到本excel首页,作为临时模板
    Call CopyFromSampleFile("C:\cim-xxinvmt-sample.xls")
    
    Set wksht_new = ActiveWorkbook.ActiveSheet
    
    'cimload模版的数据写入行初始化
    line_from = 11
    line_to = line_from
    
    '填充数据到指定单元格
    For i = 3 To wksht_old.UsedRange.Rows.Count
    
        If wksht_old.Cells(i, 1).Value = "Ｔotal　：" Then
            Exit For
        End If
        
        
        If wksht_old.Cells(i, 13).Value <> "" Then
            
            '指定wksht_new的写入行
            line_to = line_to + 1
            
            '供应商：
            wksht_new.Cells(line_to, 1).Value = "J19X002"
            '发票号：
            wksht_new.Cells(line_to, 2).Value = ""
            '保税否：
            wksht_new.Cells(line_to, 3).Value = "N"
            
            '合同号：
            wksht_new.Cells(line_to, 4).Value = ""
            
            '项次：
            wksht_new.Cells(line_to, 13).Value = (line_to - line_from)
            
            '零件图号:
            wksht_new.Cells(line_to, 14).Value = wksht_old.Cells(i, 2).Value
            
            '托号：
            wksht_new.Cells(line_to, 15).Value = wksht_old.Cells(i, 1).Value
            If wksht_new.Cells(line_to, 15).Value = "" Then
                wksht_new.Cells(line_to, 15).Value = wksht_new.Cells(line_to - 1, 15).Value
            End If
            
            '数量：
            wksht_new.Cells(line_to, 16).Value = wksht_old.Cells(i, 13).Value
          
            '量产Z/新机种R：
            wksht_new.Cells(line_to, 17).Value = "Z"
          
        End If
    Next
           
           
    '删除指定页:第一页
    DeleteSheet 1
    
    '保存当前文件
    wkbk_now.SaveAs FileName:="c:\cim-xxinvmt-" & CStr(Year(Now())) & CStr(Month(Now())) & CStr(Day(Now())) & "-" & CStr(Hour(Now())) & "-" & CStr(Minute(Now())) & ".xls", FileFormat:=xlNormal

End Sub

'复制模板文件到本文件首页,作为临时模板
Sub CopyFromSampleFile(v_file_name As String)
    Dim wkbk_from As Workbook
    Dim wkbk_to   As Workbook
    Dim is_open As Boolean
    Dim all_open
    Dim FileName As String

    
    '当前excel为目标文件
    Set wkbk_to = ActiveWorkbook
    
    '指定模板文件: 绝对路径和文件名
    FileName = v_file_name
    
    '判断模板文件是否打开
    is_open = False
    For Each all_open In Workbooks
        If all_open.Name = FileName Then
            is_open = True
            Exit For
        End If
    Next all_open


    '如果模版文件未打开,则打开它
    If is_open = False Then
        Set wkbk_from = Workbooks.Open(FileName)
    End If
    
    '复制模板到当前文件的最后一页
    wkbk_from.Sheets(1).Copy after:=wkbk_to.Sheets(wkbk_to.Worksheets.Count)
    
    '关闭模板文件
    wkbk_from.Close savechanges:=False

    '选择最后一页(临时模版)作为当前表
    If wkbk_to.Worksheets.Count >= 2 Then
        wkbk_to.Sheets(wkbk_to.Worksheets.Count).Select
    Else
        wkbk_to.Sheets(1).Select
    End If
    
End Sub


'删除指定页
Private Function DeleteSheet(SheetCount As Integer)
        Application.DisplayAlerts = False
        ActiveWorkbook.Sheets(SheetCount).Delete
        Application.DisplayAlerts = True
End Function


'产生36.15.2可用的cimload
Sub createcim()
    Dim fln As String
    Dim i, j As Long

    Dim i1, i2, jMax As Long
    Dim strFileName As String
    Dim strExecPrgName As String
    Dim strCell() As String
    Dim strString As String
    Dim sLineEnd As String
    
    Dim wksht_cim   As Worksheet
    Set wksht_cim = ActiveWorkbook.ActiveSheet
    
    On Error GoTo ErrorHandlerCim
    
    i1 = 12
    i2 = 11
    Do
        i2 = i2 + 1
    Loop While wksht_cim.Cells(i2 + 1, 1) <> ""
    
    If i2 <= 12 Then
        MsgBox "当前页面有误:无可导入行", vbOKOnly, "错误"
        End
    End If
    
    If wksht_cim.Cells(3, 2) <> "xxinvmt.p" Then
        MsgBox "当前页面有误:不是(日供发票导入-xxinvmt.p)的导入模版.", vbOKOnly, "错误"
        End
    End If
    
    
    strExecPrgName = wksht_cim.Cells(3, 2)
    fln = wksht_cim.Cells(2, 2)
    strFileName = InputBox("请输入保存文件完整路径及文件名", "文件保存:", "c:\" & fln & ".txt")
    'i1 = CLng(InputBox("请输入CIMLoad数据开始行:", "开始", "12"))
    'i2 = CLng(InputBox("请输入CIMLoad数据结束行:", "结束", i2))
        
    i = 1
    jMax = 0
    Do While wksht_cim.Cells(11, i) <> ""
        jMax = jMax + 1
        i = i + 1
    Loop
    
    ReDim strCell(jMax) As String
    
    If LCase(wksht_cim.Cells(5, 2)) = "chui" Then
        sLineEnd = vbLf
    ElseIf LCase(wksht_cim.Cells(5, 2)) = "gui" Then
        sLineEnd = vbCrLf
    End If
              
    Open strFileName For Output As #1
    
    For i = i1 To i2
        If wksht_cim.Cells(i, 1) <> "" Then
            For j = 1 To jMax
                If Trim(wksht_cim.Cells(9, j)) = "." Then
                        strCell(j) = "."
                    ElseIf Trim(wksht_cim.Cells(i, j)) = "" Or Trim(wksht_cim.Cells(i, j)) = "-" Then
                        strCell(j) = "-"
                    ElseIf wksht_cim.Cells(9, j) = "" Then
                        strCell(j) = Trim(wksht_cim.Cells(i, j))
                    ElseIf wksht_cim.Cells(9, j) = "chr" Then
                        strCell(j) = Chr(34) & Trim(wksht_cim.Cells(i, j)) & Chr(34)
                    ElseIf wksht_cim.Cells(9, j) = "dat" Then
                        strCell(j) = convDate2String(wksht_cim.Cells(i, j))
                    End If
                
                
                If wksht_cim.Cells(10, j) = "enterline" Then
                    strCell(j) = strCell(j) & sLineEnd
                Else
                    strCell(j) = strCell(j) & Chr(9)
                End If
            Next j
            
            strString = "@@batchload " & strExecPrgName & sLineEnd
            
            For j = 1 To jMax
                strString = strString & strCell(j)
            Next j
            
            strString = strString & "@@end"
            
            
            Print #1, strString
        
        End If
    Next i
    
    Close #1
    MsgBox "生成CIMlLoad文件成功！文件保存在" & strFileName & ".", vbOKOnly, "完成"
    End

ErrorHandlerCim:
    MsgBox "生成CIMLoad文件过程中错误！", vbOKOnly + vbCritical, "错误"
    End
    
    
End Sub




'转换日期格式为指定
Function convDate2String(dteTodo As Date) As String
    'because the date format(ymd/dmy/mdy) input by "end user",
    'maybe input (Ymd/DMY/mDY etc..), so use LCase conv it.
    If LCase(wksht_cim.Cells(4, 2)) = "mm/dd/yy" Then
        convDate2String = Format(dteTodo, "mm\/dd\/yy")
    ElseIf LCase(wksht_cim.Cells(4, 2)) = "dd/mm/yy" Then
        convDate2String = Format(dteTodo, "dd\/mm\/yy")
    ElseIf LCase(wksht_cim.Cells(4, 2)) = "yy/mm/dd" Then
        convDate2String = Format(dteTodo, "yy\/mm\/dd")
    End If
End Function



