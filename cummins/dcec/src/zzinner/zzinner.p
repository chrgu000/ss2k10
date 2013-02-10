{mfdeclre.i "new global"}
{mf1.i "new global"}
session:date-format = 'dmy'.
base_curr = "RMB".
IF global_userid = "" THEN global_userid = "MFG".
mfguser="".
global_user_lang = "ch".
global_user_lang_dir = "ch/".
global_domain = "DCEC".
global_db = "DCEC".
execname = "zzinner.p".


DEFINE VAR path AS CHAR.
DEFINE VAR loadfile AS CHARA. /*对应帐户导入文件*/
DEFINE VAR logfile AS CHARA. /*对应帐户导入的日志*/
DEFINE VAR I AS INTEGER INIT 1. /*计数*/
DEFINE VAR excelapp AS COM-HANDLE.
DEFINE VAR excelworkbook AS COM-HANDLE.
DEFINE VAR excelsheetmain AS COM-HANDLE.
DEFINE VAR excelappout AS COM-HANDLE.
DEFINE VAR excelworkbookout AS COM-HANDLE.
DEFINE VAR excelsheetmainout AS COM-HANDLE.
DEFINE NEW SHARED TEMP-TABLE xx_table
    FIELD cc AS INTEGER
    FIELD xx_code AS CHARA
    FIELD xx_name AS CHARA
    FIELD dflkm AS CHARA
    FIELD dflact AS CHARA. /* 帐户对应表 */
DEFINE VAR outdir AS CHARA. /*输出文件目录*/
DEFINE VAR outfile AS CHARA. /*输出文件名称*/
ASSIGN loadfile = "E:\inv\inner.xls".
ASSIGN logfile = "D:\GLreport\logact.txt".
ASSIGN outdir = "D:\GLreport\".
ASSIGN outfile = "dflreport.xls".
FOR EACH xx_table.
    DELETE xx_table.
END.
CREATE "Excel.Application" excelapp.
excelworkbook = excelapp:workbooks:ADD(loadfile).
excelsheetmain = excelapp:worksheets("template"). /*引入Excel文件*/
REPEAT:
    i = i + 1.
    IF TRIM(excelsheetmain:cells(i,1):text) <>"" THEN DO:
       CREATE xx_table.
       ASSIGN
              xx_table.xx_code = TRIM(excelsheetmain:cells(i,1):text)
              xx_table.xx_name = TRIM(excelsheetmain:cells(i,2):text).
    END.
    ELSE DO:
        i = 0.
        excelapp:VISIBLE = FALSE.
        excelworkbook:CLOSE(FALSE).
        excelapp:QUIT.
        RELEASE OBJECT excelapp.
        RELEASE OBJECT excelworkbook.
        RELEASE OBJECT excelsheetmain.
        LEAVE.
    END.
END.


    CREATE "excel.application" excelapp.
    excelworkbook = excelapp:workbooks:ADD().
    excelsheetmain = excelapp:sheets:ITEM(1).

    excelsheetmain:cells(1,1) = "打印日期" .
    excelsheetmain:cells(1,2) = "客户名称" .
    excelsheetmain:cells(1,3) = "订单号" .
    excelsheetmain:cells(1,4) = "发票号" .
    excelsheetmain:cells(1,5) = "发票金额" .
    excelsheetmain:cells(1,6) = "领取人" .
    excelsheetmain:cells(1,7) = "备注" .


path = "\\qadtemp\INV\inner" + string(year(TODAY - 1),"9999") +  STRING(month(TODAY - 1),"99") + STRING(day(TODAY - 1),"99") + ".xls".

i = 2.
FOR EACH ar_mstr WHERE ar_domain = global_domain and ar_date = TODAY - 1 AND ar_type = "I" .
    FIND FIRST xx_table WHERE xx_code = ar_cust NO-LOCK NO-ERROR.
    IF AVAIL xx_table  THEN DO:
        /*DISP ar_date ad_name ar_so_nbr ar_nbr ar_base_amt WITH WIDTH 180 STREAM-IO.*/
        excelsheetmain:cells(i,1) = ar_date .
        excelsheetmain:cells(i,2) = xx_name .
        excelsheetmain:cells(i,3) = ar_so_nbr .
        excelsheetmain:cells(i,4) = ar_nbr .
        excelsheetmain:cells(i,5) = ar_base_amt .
        i = i + 1.
    END.
END.

excelapp:VISIBLE = false.
OS-DELETE VALUE(path).
excelworkbook:saveas(path,,,,,,,,,,,) no-error.
excelapp:QUIT.
RELEASE OBJECT excelapp.
RELEASE OBJECT excelworkbook.
RELEASE OBJECT excelsheetmain.
