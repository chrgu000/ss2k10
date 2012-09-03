DEFINE VAR outExcelApp AS COM-HANDLE.
DEFINE VAR outExcelWorkbook AS COM-HANDLE.
DEFINE VAR outExcelSheet AS COM-HANDLE. /* 定义输出excel变量*/
DEFINE VAR outTemplateExcelPath AS CHARACTER.
DEFINE VAR outTemplateExcelName AS CHARACTER. /*定义输出模板的路径和文件名称*/
DEFINE VAR outFilePath AS CHARACTER.
DEFINE VAR outFileName AS CHARACTER. /*定义输出文件的路径和名称*/

DEFINE VAR inExcelApp AS COM-HANDLE.
DEFINE VAR inExcelWorkbook AS COM-HANDLE.
DEFINE VAR inExcelSheet AS COM-HANDLE. /* 定义输入excel变量*/
DEFINE VAR inTemplateExcelPath AS CHARACTER.
DEFINE VAR inTemplateExcelName AS CHARACTER. /*定义输入模板的路径和文件名称*/
DEFINE VAR inFilePath AS CHARACTER.
DEFINE VAR inFileName AS CHARACTER. /*定义输入文件的路径和名称*/

DEFINE VAR i AS INTEGER INIT 3.
DEFINE NEW SHARED TEMP-TABLE wkactt
    FIELD cc AS CHARA
    FIELD dcecjb AS CHARA
    FIELD dcecact AS CHARA
    FIELD dcecdesc AS CHARA FORMAT "X(50)"
    FIELD dflkm AS CHARA
    FIELD dflact AS CHARA
    FIELD dfldesc AS CHARA FORMAT "X(50)".  /* 帐户对应表 */

DEFINE VAR dbegsum AS DECIMAL INIT 0 FORMAT "->>>,>>>,>>>,>>>,>>9.99" .
DEFINE VAR drsum AS DECIMAL INIT 0 FORMAT "->>>,>>>,>>>,>>>,>>9.99" .
DEFINE VAR crsum AS DECIMAL INIT 0 FORMAT "->>>,>>>,>>>,>>>,>>9.99" .
DEFINE VAR dendsum AS DECIMAL INIT 0 FORMAT "->>>,>>>,>>>,>>>,>>9.99" .

ASSIGN outTemplateExcelPath = "D:\GLreport\template\".
       outTemplateExcelName = "TCReport.xlt".
       outFilePath = "D:\GLreport\".
       outFileName = "TCReport.xls".
CREATE "Excel.Application" outExcelApp.
outExcelWorkbook = outExcelApp:workbooks:ADD(outTemplateExcelPath + outTemplateExcelName).
ASSIGN i = 17.
FOR EACH wkacct BY acct.
    i = i + 1.
    outExcelWorkbook:worksheets(1):cells(i,1):VALUE = "891100".
    /*outExcelWorkbook:worksheets(1):cells(i,2):VALUE = enddt.*/
    outExcelWorkbook:worksheets(1):cells(i,3):VALUE =wkacct.acct.
    outExcelWorkbook:worksheets(1):cells(i,4):VALUE =wkacct.descc.
    outExcelWorkbook:worksheets(1):cells(i,5):VALUE =wkacct.dbeg.
    outExcelWorkbook:worksheets(1):cells(i,6):VALUE =wkacct.dract.
    outExcelWorkbook:worksheets(1):cells(i,7):VALUE =wkacct.cract.
    outExcelWorkbook:worksheets(1):cells(i,8):VALUE =wkacct.dend.
END.
outExcelWorkbook:saveas(outFilePath + outFileName,,,,,,1).
outExcelWorkbook:CLOSE.
RELEASE OBJECT outExcelWorkbook.
outExcelApp:QUIT.
RELEASE OBJECT outExcelApp. /*得到dcec帐户和数据*/
 
FOR EACH wkactt.
    DELETE wkactt.
END.

ASSIGN inTemplateExcelPath = "D:\GLreport\template\". /*得到帐户对应表*/
       inTemplateExcelName = "ActTOAct.xls".
       i = 3.
CREATE "Excel.Application" inExcelApp.
inExcelWorkbook = inExcelApp:workbooks:ADD(inTemplateExcelPath + inTemplateExcelName ).
inExcelSheet = inExcelApp:worksheets("account").
REPEAT:
    i = i + 1.
    IF TRIM(inExcelSheet:cells(i,5):text) <>"" THEN DO:
       CREATE wkactt.
       ASSIGN wkactt.cc = TRIM(inExcelSheet:cells(i,2):TEXT)
              wkactt.dcecjb = TRIM(inExcelSheet:cells(i,4):text)
              wkactt.dcecact = TRIM(inExcelSheet:cells(i,5):text)
              wkactt.dcecdesc = TRIM(inExcelSheet:cells(i,6):text)
              wkactt.dflkm = TRIM(inExcelSheet:cells(i,8):text)
              wkactt.dflact = TRIM(inExcelSheet:cells(i,9):text)
              wkactt.dfldesc = TRIM(inExcelSheet:cells(i,10):text).
    END.
    ELSE DO:
        i = 3.
        inExcelApp:VISIBLE = FALSE.
        inExcelWorkbook:CLOSE(FALSE).
        inExcelApp:QUIT.
        RELEASE OBJECT inExcelApp.
        RELEASE OBJECT inExcelWorkbook.
        RELEASE OBJECT inExcelSheet.
        LEAVE.
    END.
END.

ASSIGN outFileName = "DFLTCReport.xls". /*输出dfl 报表到DFLTCReport.xls*/
CREATE "Excel.Application" outExcelApp.
outExcelWorkbook = outExcelApp:workbooks:ADD(outTemplateExcelPath + outTemplateExcelName).
ASSIGN i = 17.
FOR EACH wkactt  BREAK BY wkactt.dflact BY wkactt.dflact.
    IF FIRST-OF(wkactt.dflact) THEN DO:
       dbegsum = 0.
       drsum = 0.
       crsum = 0.
       dendsum = 0.
    END.
    FOR EACH wkacct WHERE wkacct.acct = wkactt.dcecact.
        dbegsum = dbegsum + wkacct.dbeg.
	    drsum = drsum + wkacct.dract.
	    crsum = crsum + wkacct.cract.
	    dendsum = dendsum + wkacct.dend.
    END.
    IF LAST-OF(wkactt.dflact) AND wkactt.dflact <> "" THEN DO:
       i = i + 1.
       outExcelWorkbook:worksheets(1):cells(i,1):VALUE = "891100".
       /*outExcelWorkbook:worksheets(1):cells(i,2):VALUE = enddt.*/
       outExcelWorkbook:worksheets(1):cells(i,3):VALUE =wkactt.dflact.
       outExcelWorkbook:worksheets(1):cells(i,4):VALUE =wkactt.dfldesc.
       outExcelWorkbook:worksheets(1):cells(i,5):VALUE =dbegsum.
       outExcelWorkbook:worksheets(1):cells(i,6):VALUE =drsum.
       outExcelWorkbook:worksheets(1):cells(i,7):VALUE =crsum.
       outExcelWorkbook:worksheets(1):cells(i,8):VALUE =dendsum.
    END.
END.
outExcelWorkbook:saveas(outFilePath + outFileName,,,,,,1).
outExcelWorkbook:CLOSE.
RELEASE OBJECT outExcelWorkbook.
outExcelApp:QUIT.
RELEASE OBJECT outExcelApp.




