Attribute VB_Name = "cimroger"
Public v_Label_0 As String       '<--- main-menu-label,���sub�����

'/******* Created By Roger Xiao ,On 2011/03/xx ****************/


'����ʽ��ʼ:���Ŀ��˵�,��excel�˵��������
Sub Auto_Open()
    
    On Error Resume Next
    v_Label_0 = "SoftSpeed(&S)"
    
    '�����ظ�����,��ɾ�����˵�,�����������Ӷ༶�˵�
    ActiveMenuBar.Menus(v_Label_0).Delete
       
    '_0: 0���˵�,�����˵�
    Set v_Menu_0 = Application.CommandBars(1).Controls.Add(Type:=msoControlPopup)
        v_Menu_0.Caption = v_Label_0


    '_0X: 1���˵������----------------------------------------------------------------------------------
    Set v_Menu_01 = v_Menu_0.Controls.Add(Type:=msoControlPopup)
        v_Menu_01.Caption = "�չ���Ʊ����(&1)"
       
    '_0XX: 2���˵������----------------------------------------------------------------------------------
    Set v_Menu_011 = v_Menu_01.Controls.Add(Type:=msoControlPopup)
        v_Menu_011.Caption = "PL--->List       (&1)"
    Set v_Menu_012 = v_Menu_01.Controls.Add(Type:=msoControlButton)
        v_Menu_012.Caption = "List-->Cim�ı� (&2)"
        v_Menu_012.OnAction = "createcim"
        v_Menu_012.BeginGroup = True
    
    
    '_0XXX: 3���˵������----------------------------------------------------------------------------------
    Set v_Menu_0111 = v_Menu_011.Controls.Add(Type:=msoControlButton)
        v_Menu_0111.Caption = "����     (&1)"
        v_Menu_0111.OnAction = "createxls01"
    Set v_Menu_0112 = v_Menu_011.Controls.Add(Type:=msoControlButton)
        v_Menu_0112.Caption = "������  (&2)"
        v_Menu_0112.OnAction = "createxls02"
        v_Menu_0112.BeginGroup = True
    Set v_Menu_0113 = v_Menu_011.Controls.Add(Type:=msoControlButton)
        v_Menu_0113.Caption = "������  (&3)"
        v_Menu_0113.OnAction = "createxls03"
        v_Menu_0113.BeginGroup = True
        
        
End Sub


'����ʽ����:ɾ��Ŀ��˵�
Sub Auto_Close()

    On Error GoTo ErrorHandler
    ActiveMenuBar.Menus(v_Label_0).Delete
    ActiveMenuBar.Reset

ErrorHandler:
    Exit Sub

End Sub

'����excel�����ļ�
Sub createxls01()
    Dim wkbk_now    As Workbook
    Dim wksht_old   As Worksheet
    Dim wksht_new   As Worksheet
 
    Dim line_from, line_to As Long
    
    
    'Ϊ�����ظ�,�����ǰ�ļ��д���1����ҳ,,�򵯳����沢�˳�
    '�����Լ��ֹ�ɾ����ǰ�ļ�������ҳ��
    If ActiveWorkbook.Worksheets.Count > 1 Then
        MsgBox "���ļ�ֻ�������һ����ҳ. ����ɾ������ҳ��...", 48, "����"
        Exit Sub
    End If
    
    Set wkbk_now = ActiveWorkbook
    Set wksht_old = ActiveWorkbook.ActiveSheet
    wksht_old.Range("A1").Select
    
    '���ݵ�ǰ�ļ�
    'Call BackupThisFile
    
    '����ģ�嵽��excel��ҳ,��Ϊ��ʱģ��
    Call CopyFromSampleFile("C:\cim-xxinvmt-sample.xls")
    
    Set wksht_new = ActiveWorkbook.ActiveSheet
    
    'cimloadģ�������д���г�ʼ��
    line_from = 11
    line_to = line_from
    
    '������ݵ�ָ����Ԫ��
    For i = 21 To wksht_old.UsedRange.Rows.Count
    
        If wksht_old.Cells(i, 3).Value = "Total  :" Then
            Exit For
        End If
        
        
        If wksht_old.Cells(i, 9).Value <> "" Then
            
            'ָ��wksht_new��д����
            line_to = line_to + 1
            
            '��Ӧ�̣�
            wksht_new.Cells(line_to, 1).Value = "J19X003"
            '��Ʊ�ţ�
            wksht_new.Cells(line_to, 2).Value = wksht_old.Cells(16, 10).Value
            '��˰��
            wksht_new.Cells(line_to, 3).Value = wksht_old.Cells(16, 11).Value
            
            '��ͬ�ţ�
            wksht_new.Cells(line_to, 4).Value = wksht_old.Cells(15, 10).Value
            
            '��Σ�
            wksht_new.Cells(line_to, 13).Value = (line_to - line_from)
            
            '���ͼ��:
            wksht_new.Cells(line_to, 14).Value = wksht_old.Cells(i, 9).Value
            
            '�кţ�
            wksht_new.Cells(line_to, 15).Value = wksht_old.Cells(i, 3).Value
            If wksht_new.Cells(line_to, 15).Value = "" Then
                wksht_new.Cells(line_to, 15).Value = wksht_new.Cells(line_to - 1, 15).Value
            End If
            
            '������
            wksht_new.Cells(line_to, 16).Value = wksht_old.Cells(i, 29).Value
          
            '����Z/�»���R��
            wksht_new.Cells(line_to, 17).Value = "Z"
          
        End If
    Next
           
           
    'ɾ��ָ��ҳ:��һҳ
    DeleteSheet 1
    
    '���浱ǰ�ļ�
    wkbk_now.SaveAs FileName:="c:\cim-xxinvmt-" & CStr(Year(Now())) & CStr(Month(Now())) & CStr(Day(Now())) & "-" & CStr(Hour(Now())) & "-" & CStr(Minute(Now())) & ".xls", FileFormat:=xlNormal

End Sub

'����excel�����ļ�
Sub createxls02()
    Dim wkbk_now    As Workbook
    Dim wksht_old   As Worksheet
    Dim wksht_new   As Worksheet
 
    Dim line_from, line_to As Long
    Dim invoice, contract, baoshui As String
    
    
    'Ϊ�����ظ�,�����ǰ�ļ��д���1����ҳ,,�򵯳����沢�˳�
    '�����Լ��ֹ�ɾ����ǰ�ļ�������ҳ��
    If ActiveWorkbook.Worksheets.Count > 1 Then
        MsgBox "���ļ�ֻ�������һ����ҳ. ����ɾ������ҳ��...", 48, "����"
        Exit Sub
    End If
    
    Set wkbk_now = ActiveWorkbook
    Set wksht_old = ActiveWorkbook.ActiveSheet
    wksht_old.Range("A1").Select
    
    '���ݵ�ǰ�ļ�
    'Call BackupThisFile
    
    '����ģ�嵽��excel��ҳ,��Ϊ��ʱģ��
    Call CopyFromSampleFile("C:\cim-xxinvmt-sample.xls")
    
    Set wksht_new = ActiveWorkbook.ActiveSheet
    
    'cimloadģ�������д���г�ʼ��
    line_from = 11
    line_to = line_from
    
    '������ݵ�ָ����Ԫ��
    For i = 1 To wksht_old.UsedRange.Rows.Count
    
        If wksht_old.Cells(i, 4).Value = "Total:" Then
            Exit For
        End If
        
        If i < 6 And wksht_old.Cells(i, 3).Value = "Invoice ��" Then
            contract = wksht_old.Cells(i, 4).Value
            invoice = wksht_old.Cells(i, 5).Value
            baoshui = wksht_old.Cells(i, 6).Value
        End If
        
        If IsNumeric(wksht_old.Cells(i, 5).Value) And wksht_old.Cells(i, 5).Value <> "" And wksht_old.Cells(i, 3).Value <> "" Then
            
            'ָ��wksht_new��д����
            line_to = line_to + 1
            
            '��Ӧ�̣�
            wksht_new.Cells(line_to, 1).Value = "J19X004"
            '��Ʊ�ţ�
            wksht_new.Cells(line_to, 2).Value = invoice
            '��˰��
            wksht_new.Cells(line_to, 3).Value = baoshui
            
            '��ͬ�ţ�
            wksht_new.Cells(line_to, 4).Value = contract
            
            '��Σ�
            wksht_new.Cells(line_to, 13).Value = (line_to - line_from)
            
            '���ͼ��:
            wksht_new.Cells(line_to, 14).Value = wksht_old.Cells(i, 3).Value
            
            '�кţ�
            wksht_new.Cells(line_to, 15).Value = wksht_old.Cells(i, 2).Value
            If wksht_new.Cells(line_to, 15).Value = "" Then
                wksht_new.Cells(line_to, 15).Value = wksht_new.Cells(line_to - 1, 15).Value
            End If
            
            '������
            wksht_new.Cells(line_to, 16).Value = wksht_old.Cells(i, 5).Value
          
            '����Z/�»���R��
            wksht_new.Cells(line_to, 17).Value = "Z"
          
        End If
    Next
           
           
    'ɾ��ָ��ҳ:��һҳ
    DeleteSheet 1
    
    '���浱ǰ�ļ�
    wkbk_now.SaveAs FileName:="c:\cim-xxinvmt-" & CStr(Year(Now())) & CStr(Month(Now())) & CStr(Day(Now())) & "-" & CStr(Hour(Now())) & "-" & CStr(Minute(Now())) & ".xls", FileFormat:=xlNormal

End Sub


'����excel�����ļ�
Sub createxls03()
    Dim wkbk_now    As Workbook
    Dim wksht_old   As Worksheet
    Dim wksht_new   As Worksheet
 
    Dim line_from, line_to As Long
    
    
    'Ϊ�����ظ�,�����ǰ�ļ��д���1����ҳ,,�򵯳����沢�˳�
    '�����Լ��ֹ�ɾ����ǰ�ļ�������ҳ��
    If ActiveWorkbook.Worksheets.Count > 1 Then
        MsgBox "���ļ�ֻ�������һ����ҳ. ����ɾ������ҳ��...", 48, "����"
        Exit Sub
    End If
    
    Set wkbk_now = ActiveWorkbook
    Set wksht_old = ActiveWorkbook.ActiveSheet
    wksht_old.Range("A1").Select
    
    '���ݵ�ǰ�ļ�
    'Call BackupThisFile
    
    '����ģ�嵽��excel��ҳ,��Ϊ��ʱģ��
    Call CopyFromSampleFile("C:\cim-xxinvmt-sample.xls")
    
    Set wksht_new = ActiveWorkbook.ActiveSheet
    
    'cimloadģ�������д���г�ʼ��
    line_from = 11
    line_to = line_from
    
    '������ݵ�ָ����Ԫ��
    For i = 3 To wksht_old.UsedRange.Rows.Count
    
        If wksht_old.Cells(i, 1).Value = "��otal����" Then
            Exit For
        End If
        
        
        If wksht_old.Cells(i, 13).Value <> "" Then
            
            'ָ��wksht_new��д����
            line_to = line_to + 1
            
            '��Ӧ�̣�
            wksht_new.Cells(line_to, 1).Value = "J19X002"
            '��Ʊ�ţ�
            wksht_new.Cells(line_to, 2).Value = ""
            '��˰��
            wksht_new.Cells(line_to, 3).Value = "N"
            
            '��ͬ�ţ�
            wksht_new.Cells(line_to, 4).Value = ""
            
            '��Σ�
            wksht_new.Cells(line_to, 13).Value = (line_to - line_from)
            
            '���ͼ��:
            wksht_new.Cells(line_to, 14).Value = wksht_old.Cells(i, 2).Value
            
            '�кţ�
            wksht_new.Cells(line_to, 15).Value = wksht_old.Cells(i, 1).Value
            If wksht_new.Cells(line_to, 15).Value = "" Then
                wksht_new.Cells(line_to, 15).Value = wksht_new.Cells(line_to - 1, 15).Value
            End If
            
            '������
            wksht_new.Cells(line_to, 16).Value = wksht_old.Cells(i, 13).Value
          
            '����Z/�»���R��
            wksht_new.Cells(line_to, 17).Value = "Z"
          
        End If
    Next
           
           
    'ɾ��ָ��ҳ:��һҳ
    DeleteSheet 1
    
    '���浱ǰ�ļ�
    wkbk_now.SaveAs FileName:="c:\cim-xxinvmt-" & CStr(Year(Now())) & CStr(Month(Now())) & CStr(Day(Now())) & "-" & CStr(Hour(Now())) & "-" & CStr(Minute(Now())) & ".xls", FileFormat:=xlNormal

End Sub

'����ģ���ļ������ļ���ҳ,��Ϊ��ʱģ��
Sub CopyFromSampleFile(v_file_name As String)
    Dim wkbk_from As Workbook
    Dim wkbk_to   As Workbook
    Dim is_open As Boolean
    Dim all_open
    Dim FileName As String

    
    '��ǰexcelΪĿ���ļ�
    Set wkbk_to = ActiveWorkbook
    
    'ָ��ģ���ļ�: ����·�����ļ���
    FileName = v_file_name
    
    '�ж�ģ���ļ��Ƿ��
    is_open = False
    For Each all_open In Workbooks
        If all_open.Name = FileName Then
            is_open = True
            Exit For
        End If
    Next all_open


    '���ģ���ļ�δ��,�����
    If is_open = False Then
        Set wkbk_from = Workbooks.Open(FileName)
    End If
    
    '����ģ�嵽��ǰ�ļ������һҳ
    wkbk_from.Sheets(1).Copy after:=wkbk_to.Sheets(wkbk_to.Worksheets.Count)
    
    '�ر�ģ���ļ�
    wkbk_from.Close savechanges:=False

    'ѡ�����һҳ(��ʱģ��)��Ϊ��ǰ��
    If wkbk_to.Worksheets.Count >= 2 Then
        wkbk_to.Sheets(wkbk_to.Worksheets.Count).Select
    Else
        wkbk_to.Sheets(1).Select
    End If
    
End Sub


'ɾ��ָ��ҳ
Private Function DeleteSheet(SheetCount As Integer)
        Application.DisplayAlerts = False
        ActiveWorkbook.Sheets(SheetCount).Delete
        Application.DisplayAlerts = True
End Function


'����36.15.2���õ�cimload
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
        MsgBox "��ǰҳ������:�޿ɵ�����", vbOKOnly, "����"
        End
    End If
    
    If wksht_cim.Cells(3, 2) <> "xxinvmt.p" Then
        MsgBox "��ǰҳ������:����(�չ���Ʊ����-xxinvmt.p)�ĵ���ģ��.", vbOKOnly, "����"
        End
    End If
    
    
    strExecPrgName = wksht_cim.Cells(3, 2)
    fln = wksht_cim.Cells(2, 2)
    strFileName = InputBox("�����뱣���ļ�����·�����ļ���", "�ļ�����:", "c:\" & fln & ".txt")
    'i1 = CLng(InputBox("������CIMLoad���ݿ�ʼ��:", "��ʼ", "12"))
    'i2 = CLng(InputBox("������CIMLoad���ݽ�����:", "����", i2))
        
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
    MsgBox "����CIMlLoad�ļ��ɹ����ļ�������" & strFileName & ".", vbOKOnly, "���"
    End

ErrorHandlerCim:
    MsgBox "����CIMLoad�ļ������д���", vbOKOnly + vbCritical, "����"
    End
    
    
End Sub




'ת�����ڸ�ʽΪָ��
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



