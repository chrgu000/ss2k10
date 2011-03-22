Public v_Label_0 As String       '<--- main-menu-label,多个sub会调用


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
    'Set v_Menu_01 = v_Menu_0.Controls.Add(Type:=msoControlPopup)
    '    v_Menu_01.Caption = "日供发票导入(&1)"
    Set v_Menu_02 = v_Menu_0.Controls.Add(Type:=msoControlButton)
        v_Menu_02.Caption = "发货指示书   (&1)"
        v_Menu_02.OnAction = "ship01"
        v_Menu_02.BeginGroup = True                               '前面是否要分隔符
    'Set v_Menu_03 = v_Menu_0.Controls.Add(Type:=msoControlPopup)
    '    v_Menu_03.Caption = "其他待定    (&3)"
    '    v_Menu_03.BeginGroup = True
    
    'Set v_Menu_09 = v_Menu_0.Controls.Add(Type:=msoControlPopup)
    '    v_Menu_09.Caption = "xxxx(&9)"
    '    v_Menu_09.BeginGroup = True
       
       
       
       
    '_0XX: 2级菜单或项次----------------------------------------------------------------------------------
    'Set v_Menu_011 = v_Menu_01.Controls.Add(Type:=msoControlPopup)
    '    v_Menu_011.Caption = "PL--->List       (&1)"
    'Set v_Menu_012 = v_Menu_01.Controls.Add(Type:=msoControlButton)
    '    v_Menu_012.Caption = "List-->Cim文本 (&2)"
    '    v_Menu_012.OnAction = "createcim"
'        v_Menu_012.BeginGroup = True

    'Set v_Menu_091 = v_Menu_09.Controls.Add(Type:=msoControlButton)
    '    v_Menu_091.Caption = "测试21..(&1)"
    '    v_Menu_091.OnAction = "test"
    'Set v_Menu_092 = v_Menu_09.Controls.Add(Type:=msoControlButton)
    '    v_Menu_092.Caption = "测试22..(&2)"
    '    v_Menu_092.OnAction = "test"
    '    v_Menu_092.BeginGroup = True
    'Set v_Menu_093 = v_Menu_09.Controls.Add(Type:=msoControlButton)
    '    v_Menu_093.Caption = "测试23..(&3)"
    '    v_Menu_093.OnAction = "test"
    '    v_Menu_093.BeginGroup = True
    
    
    
    '_0XXX: 3级菜单或项次----------------------------------------------------------------------------------
  '  Set v_Menu_0111 = v_Menu_011.Controls.Add(Type:=msoControlButton)
  '      v_Menu_0111.Caption = "琦玉     (&1)"
  '      v_Menu_0111.OnAction = "createxls01"
    '    v_Menu_0111.BeginGroup = True
  '  Set v_Menu_0112 = v_Menu_011.Controls.Add(Type:=msoControlButton)
  '      v_Menu_0112.Caption = "御练场  (&2)"
  '      v_Menu_0112.OnAction = "createxls02"
  '      v_Menu_0112.BeginGroup = True
  '  Set v_Menu_0113 = v_Menu_011.Controls.Add(Type:=msoControlButton)
  '      v_Menu_0113.Caption = "名古屋  (&3)"
  '      v_Menu_0113.OnAction = "createxls03"
  '      v_Menu_0113.BeginGroup = True
        
        
End Sub
Sub Auto_Close()
  
 On Error GoTo ErrorHandler
 ActiveMenuBar.Menus(v_Label_0).Delete
 ActiveMenuBar.Reset
  
ErrorHandler:
  Exit Sub

End Sub

Sub ship01()
    Dim ns, ws, i, j, vbreak, mvL, side, rngstr, LT, LD
    ws = ActiveSheet.Name
    If InStr(ActiveWorkbook.Worksheets(ws).Cells(1, 1).Value, "客户厂别:") = 0 Then
        MsgBox "请选择正确的资料表处理资料!", vbCritical, "操作错误"
        Exit Sub
    End If

    Set ns = Sheets.Add(Type:=xlWorksheet)
    ns.Visible = False
    Call setColWidth(ns)
    side = 1 ' or 10
    mvL = 3
    For i = 3 To 65535
        If ActiveWorkbook.Worksheets(ws).Cells(i, 1).Value = "" Then Exit For

        If vbreak <> ActiveWorkbook.Worksheets(ws).Cells(i, 7).Value Then
            Call setTitle(ns, side, mvL)
            vbreak = ActiveWorkbook.Worksheets(ws).Cells(i, 7).Value
            rngstr = Chr(side + 65) & Trim(mvL + 1)
            ns.Range(rngstr).FormulaR1C1 = ActiveWorkbook.Worksheets(ws).Cells(i, 2).Value
            rngstr = Chr(side + 69) & Trim(mvL + 1)
            ns.Range(rngstr).NumberFormatLocal = "h:mm;@"
            ns.Range(rngstr).FormulaR1C1 = ActiveWorkbook.Worksheets(ws).Cells(i, 3).Value
            rngstr = Chr(side + 65) & Trim(mvL + 2)
            ns.Range(rngstr).NumberFormatLocal = "h:mm;@"
            ns.Range(rngstr).FormulaR1C1 = ActiveWorkbook.Worksheets(ws).Cells(i, 5).Value
            rngstr = Chr(side + 69) & Trim(mvL + 2)
            ns.Range(rngstr).NumberFormatLocal = "h:mm;@"
            ns.Range(rngstr).FormulaR1C1 = ActiveWorkbook.Worksheets(ws).Cells(i, 7).Value
            corner = Chr(side + 64) & Trim(mvL + 4)
            mvL = mvL + 4
            If side = 1 Then
                LT = mvL
            End If
        End If

        rngstr = Chr(side + 64) & Trim(Str(mvL))
        ns.Range(rngstr).NumberFormatLocal = "h:mm;@"
        ns.Range(rngstr).FormulaR1C1 = ActiveWorkbook.Worksheets(ws).Cells(i, 7).Value
        
        rngstr = Chr(side + 65) & Trim(Str(mvL))
        ns.Range(rngstr).FormulaR1C1 = ActiveWorkbook.Worksheets(ws).Cells(i, 9).Value
        
        rngstr = Chr(side + 66) & Trim(Str(mvL))
        ns.Range(rngstr).FormulaR1C1 = ActiveWorkbook.Worksheets(ws).Cells(i, 10).Value
                
        rngstr = Chr(side + 67) & Trim(Str(mvL))
        ns.Range(rngstr).FormulaR1C1 = 1
        
        rngstr = Chr(side + 68) & Trim(Str(mvL))
        ns.Range(rngstr).FormulaR1C1 = ActiveWorkbook.Worksheets(ws).Cells(i, 11).Value
        
        rngstr = Chr(side + 69) & Trim(Str(mvL))
        ns.Range(rngstr).FormulaR1C1 = ActiveWorkbook.Worksheets(ws).Cells(i, 12).Value
                
        rngstr = Chr(side + 70) & Trim(Str(mvL))
        ns.Range(rngstr).FormulaR1C1 = 1
        
        rngstr = Chr(side + 71) & Trim(Str(mvL))
        ns.Range(rngstr).FormulaR1C1 = 1
        
        If Left(ActiveWorkbook.Worksheets(ws).Cells(i, 9).Value, 5) = "56100" Then
            rngstr = Chr(side + 64) & Trim(Str(mvL)) & ":" & Chr(side + 71) & Trim(Str(mvL))
            ns.Range(rngstr).Interior.ThemeColor = xlThemeColorAccent6
        End If
        
                
        If ActiveWorkbook.Worksheets(ws).Cells(i, 7).Value <> ActiveWorkbook.Worksheets(ws).Cells(i + 1, 7).Value Then
            If side = 1 Then
               j = i
               LD = mvL
            End If

            If side = 10 Then
               If LD > mvL Then
                  mvL = LD
               End If
               
               If mvL - LT <= 10 Then
                  mvL = mvL + (10 - (mvL - LT))
               End If
               rngstr = "A" & Trim(Str(LT)) & ":H" & Trim(Str(mvL))
               ns.Range(rngstr).Borders.Color = xlContinuous
               rngstr = "J" & Trim(Str(LT)) & ":Q" & Trim(Str(mvL))
               ns.Range(rngstr).Borders.Color = xlContinuous
               Call setTail(ns, 1, mvL + 1)
               Call setTail(ns, 10, mvL + 1)
               Call writeTilTime(ws, ns, 3, mvL + 2, j)
               Call writeTilTime(ws, ns, 12, mvL + 2, j + 1)
                
               mvL = mvL + 6
            End If
            
            If side = 1 Then
                side = 10
                mvL = LT - 4
            Else
                side = 1
            End If

        Else
            mvL = mvL + 1
        End If
    Next i
    
    If side = 10 Then
        mvL = mvL + (10 - (mvL - LT))
        rngstr = "A" & Trim(Str(LT)) & ":H" & Trim(Str(mvL))
        ns.Range(rngstr).Borders.Color = xlContinuous
        Call setTail(ns, 1, mvL + 1)
        Call writeTilTime(ws, ns, 3, mvL + 2, j)
    End If
    ns.Visible = True
    ns.Select
End Sub


Sub setColWidth(iSheet)
' 设定列宽
    iSheet.Columns("A:A").ColumnWidth = 9.88
    iSheet.Columns("B:B").ColumnWidth = 16.63
    iSheet.Columns("C:C").ColumnWidth = 17.63
    iSheet.Columns("D:D").ColumnWidth = 8.38
    iSheet.Columns("E:E").ColumnWidth = 8.88
    iSheet.Columns("F:F").ColumnWidth = 10
    iSheet.Columns("G:G").ColumnWidth = 8.38
    iSheet.Columns("H:H").ColumnWidth = 12.75
    iSheet.Columns("I:I").ColumnWidth = 1.38
    iSheet.Columns("J:J").ColumnWidth = 9.88
    iSheet.Columns("K:K").ColumnWidth = 16.63
    iSheet.Columns("L:L").ColumnWidth = 17.63
    iSheet.Columns("M:M").ColumnWidth = 8.38
    iSheet.Columns("N:N").ColumnWidth = 8.88
    iSheet.Columns("O:O").ColumnWidth = 10
    iSheet.Columns("P:P").ColumnWidth = 8.38
    iSheet.Columns("Q:Q").ColumnWidth = 12.75
End Sub

Sub setTitle(iSheet, icol, ilne)
    '写title
    
    Dim col, lne, rngstr
    col = icol + 64
    lne = ilne
    
    rngstr = Chr(col) & Trim(Str(lne)) & ":" & Chr(col + 7) & Trim(Str(lne))
    iSheet.Range(rngstr).Merge
    iSheet.Range(rngstr).FormulaR1C1 = "一厂发货指示书"
    iSheet.Range(rngstr).Font.Bold = True
    
    lne = lne + 1
    rngstr = Chr(col) & Trim(Str(lne))
    iSheet.Range(rngstr).FormulaR1C1 = "传票日期："
    rngstr = Chr(col + 1) & Trim(Str(lne)) & ":" & Chr(col + 3) & Trim(Str(lne))
    iSheet.Range(rngstr).Merge
    rngstr = Chr(col + 4) & Trim(Str(lne))
    iSheet.Range(rngstr).FormulaR1C1 = "传票时间："
    rngstr = Chr(col + 5) & Trim(Str(lne)) & ":" & Chr(col + 7) & Trim(Str(lne))
    iSheet.Range(rngstr).Merge
    
    lne = lne + 1
    rngstr = Chr(col) & Trim(Str(lne))
    iSheet.Range(rngstr).FormulaR1C1 = "发货时间："
    rngstr = Chr(col + 1) & Trim(Str(lne)) & ":" & Chr(col + 3) & Trim(Str(lne))
    iSheet.Range(rngstr).Merge
    rngstr = Chr(col + 4) & Trim(Str(lne))
    iSheet.Range(rngstr).FormulaR1C1 = "到货时段："
    rngstr = Chr(col + 5) & Trim(Str(lne)) & ":" & Chr(col + 7) & Trim(Str(lne))
    iSheet.Range(rngstr).Merge
    
    lne = lne + 1
    rngstr = Chr(col) & Trim(Str(lne))
    iSheet.Range(rngstr).FormulaR1C1 = "区分"
    rngstr = Chr(col + 1) & Trim(Str(lne))
    iSheet.Range(rngstr).FormulaR1C1 = "客户图号"
    rngstr = Chr(col + 2) & Trim(Str(lne))
    iSheet.Range(rngstr).FormulaR1C1 = "公司图号"
    rngstr = Chr(col + 3) & Trim(Str(lne))
    iSheet.Range(rngstr).FormulaR1C1 = "传票张数"
    rngstr = Chr(col + 4) & Trim(Str(lne))
    iSheet.Range(rngstr).FormulaR1C1 = "部品数量"
    rngstr = Chr(col + 5) & Trim(Str(lne))
    iSheet.Range(rngstr).FormulaR1C1 = "容器数量"
    rngstr = Chr(col + 6) & Trim(Str(lne))
    iSheet.Range(rngstr).FormulaR1C1 = "标签数量"
    rngstr = Chr(col + 7) & Trim(Str(lne))
    iSheet.Range(rngstr).FormulaR1C1 = "二维码数量"
    rngstr = Chr(icol + 64) & Trim(Str(ilne)) & ":" & Chr(col + 7) & Trim(Str(lne))
    iSheet.Range(rngstr).VerticalAlignment = xlCenter
    iSheet.Range(rngstr).HorizontalAlignment = xlCenter
    iSheet.Range(rngstr).Borders.Color = xlContinuous

End Sub

Sub setTail(iSheet, icol, ilne)
    Dim col, lne, rngstr
    col = icol + 64
    lne = ilne
    rngstr = Trim(Str(lne)) + ":" + Trim(Str(lne))
    iSheet.Range(rngstr).RowHeight = 24
    rngstr = Chr(col) & Trim(Str(lne))
    iSheet.Range(rngstr).FormulaR1C1 = "项目"
    rngstr = Chr(col) & Trim(Str(lne)) & ":" & Chr(col + 1) & Trim(Str(lne))
    iSheet.Range(rngstr).Merge
    rngstr = Chr(col + 2) & Trim(Str(lne))
    iSheet.Range(rngstr).FormulaR1C1 = "传票日期"
    rngstr = Chr(col + 3) & Trim(Str(lne))
    iSheet.Range(rngstr).FormulaR1C1 = "备货完成时间"
    rngstr = Chr(col + 4) & Trim(Str(lne))
    iSheet.Range(rngstr).FormulaR1C1 = "装车时间"
    rngstr = Chr(col + 5) & Trim(Str(lne))
    iSheet.Range(rngstr).FormulaR1C1 = "发货时间"
    rngstr = Chr(col + 6) & Trim(Str(lne))
    iSheet.Range(rngstr).FormulaR1C1 = "运输时间"
    rngstr = Chr(col + 7) & Trim(Str(lne))
    iSheet.Range(rngstr).FormulaR1C1 = "到货时间"
    rngstr = Chr(col) & Trim(Str(lne)) & ":" & rngstr
    iSheet.Range(rngstr).WrapText = True
    iSheet.Range(rngstr).HorizontalAlignment = xlCenter
    iSheet.Range(rngstr).VerticalAlignment = xlCenter
    
    lne = lne + 1
    rngstr = Chr(col) & Trim(Str(lne))
    iSheet.Range(rngstr).FormulaR1C1 = "计划时间"
    rngstr = Chr(col) & Trim(Str(lne)) & ":" & Chr(col + 1) & Trim(Str(lne))
    iSheet.Range(rngstr).Merge
    
    lne = lne + 1
    rngstr = Chr(col) & Trim(Str(lne))
    iSheet.Range(rngstr).FormulaR1C1 = "实际时间"
    rngstr = Chr(col) & Trim(Str(lne)) & ":" & Chr(col + 1) & Trim(Str(lne))
    iSheet.Range(rngstr).Merge
    
    lne = lne + 1
    rngstr = Chr(col) & Trim(Str(lne))
    iSheet.Range(rngstr).FormulaR1C1 = "成品仓确认"
    rngstr = Chr(col) & Trim(Str(lne)) & ":" & Chr(col + 3) & Trim(Str(lne))
    iSheet.Range(rngstr).Merge
    
    rngstr = Chr(col + 4) & Trim(Str(lne))
    iSheet.Range(rngstr).FormulaR1C1 = "物流组确认"
    rngstr = Chr(col + 4) & Trim(Str(lne)) & ":" & Chr(col + 7) & Trim(Str(lne))
    iSheet.Range(rngstr).Merge
    
    rngstr = Chr(icol + 64) & Trim(Str(ilne)) + ":" & Chr(col + 7) & Trim(Str(lne))
    iSheet.Range(rngstr).VerticalAlignment = xlCenter
    iSheet.Range(rngstr).HorizontalAlignment = xlCenter
    iSheet.Range(rngstr).Borders.Color = xlContinuous
End Sub

Sub writeTilTime(iws, iSheet, icol, ilne, ij)
    Dim rngstr
    rngstr = Chr(icol + 64) & Trim(Str(ilne))
    iSheet.Range(rngstr).FormulaR1C1 = ActiveWorkbook.Worksheets(iws).Cells(ij, 3).Value
    rngstr = Chr(icol + 65) & Trim(Str(ilne))
    iSheet.Range(rngstr).FormulaR1C1 = ActiveWorkbook.Worksheets(iws).Cells(ij, 8).Value
    rngstr = Chr(icol + 66) & Trim(Str(ilne))
    iSheet.Range(rngstr).FormulaR1C1 = ActiveWorkbook.Worksheets(iws).Cells(ij, 4).Value
    rngstr = Chr(icol + 67) & Trim(Str(ilne))
    iSheet.Range(rngstr).FormulaR1C1 = ActiveWorkbook.Worksheets(iws).Cells(ij, 5).Value
    rngstr = Chr(icol + 68) & Trim(Str(ilne))
    iSheet.Range(rngstr).FormulaR1C1 = ActiveWorkbook.Worksheets(iws).Cells(ij, 6).Value
    rngstr = Chr(icol + 69) & Trim(Str(ilne))
    iSheet.Range(rngstr).FormulaR1C1 = ActiveWorkbook.Worksheets(iws).Cells(ij, 7).Value
    rngstr = Chr(icol + 64) & Trim(Str(ilne)) & ":" & Chr(icol + 69) & Trim(Str(ilne))
    iSheet.Range(rngstr).NumberFormatLocal = "h:mm;@"
End Sub
