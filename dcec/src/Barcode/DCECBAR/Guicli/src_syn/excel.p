DEF  VAR chExcelApplication   AS COM-HANDLE.
DEF  VAR chWorkbook           AS COM-HANDLE.
DEF  VAR chWorksheet          AS COM-HANDLE.
create "Excel.Application" chExcelApplication.
       chExcelApplication:Visible = TRUE.
     
       chWorkbook = chExcelApplication:Workbooks:OPEN("e:\personal doc\ERP对口联系人-V02.xls").
       chWorkSheet = chExcelApplication:Sheets:Item(1).  
       chExcelApplication:Sheets:Item(1):SELECT().
       DISP chWorkSheet:Range("a1"):VALUE.
     
