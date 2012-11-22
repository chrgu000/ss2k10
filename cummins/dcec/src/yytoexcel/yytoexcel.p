/*output temptable to excel*/

DEFINE INPUT PARAMETER TABLE-HANDLE hTempTable.
DEFINE INPUT PARAMETER inp_where AS CHAR.
DEFINE INPUT PARAMETER inp_sortby AS CHAR.
DEFINE INPUT PARAMETER inp_list   AS CHAR.
DEFINE INPUT PARAMETER inp_rpttitle AS CHAR.

DEFINE VARIABLE bh AS HANDLE NO-UNDO.
DEFINE VARIABLE bf AS HANDLE NO-UNDO.
DEFINE VARIABLE hq AS HANDLE NO-UNDO.
DEFINE VARIABLE iCounter AS INTEGER NO-UNDO.
DEFINE VARIABLE i AS INTEGER.
DEFINE VARIABLE qrString AS CHARACTER FORMAT "x(256)" NO-UNDO.

{mfdeclre.i} /*GUI moved to top.*/
{gplabel.i} /* EXTERNAL LABEL INCLUDE */


/***************Define needed variables************/
DEFINE VARIABLE hExcel        AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE hWorkbook     AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE hWorksheet    AS COM-HANDLE NO-UNDO.
DEFINE VARIABLE iRowNum       AS INTEGER    NO-UNDO.
DEFINE VARIABLE ColumnRange   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE v_totalcol    AS INTEGER    NO-UNDO.
DEFINE VARIABLE v_label       AS CHAR.
DEFINE VARIABLE v_format      AS CHAR.

DEFINE FRAME WaitingFrame 
        "处理中，请稍候..." 
        SKIP
        iRowNum NO-LABEL
        SKIP
WITH VIEW-AS DIALOG-BOX.

IF hTempTable = ? THEN RETURN.

VIEW FRAME waitingframe.

bh = hTempTable:DEFAULT-BUFFER-HANDLE.

qrString = "FOR EACH " + hTempTable:NAME + " " + inp_where + " " + inp_sortby.
CREATE QUERY hq.
hq:SET-BUFFERS(bh).
hq:QUERY-PREPARE(qrstring).
hq:QUERY-OPEN.


/********Open Excel and initialize variables********/
CREATE "Excel.Application" hExcel.
ASSIGN
    hExcel:VISIBLE = FALSE
    hWorkbook      = hExcel:Workbooks:Add()
    hWorkSheet     = hExcel:Sheets:Item(1)
    iRowNum        = 1.
ASSIGN
    hWorkSheet:cells:FONT:NAME="Courier New".
    hWorkSheet:cells:FONT:SIZE = "9".


i = 0.
DO iCounter = 1 TO bh:NUM-FIELDS:
    bf = bh:BUFFER-FIELD(iCounter).

        i = i + 1.
        v_label = string(bf:LABEL).
        v_label = gettermlabel(v_label,20).
        hExcel:Worksheets("Sheet1"):Cells(iRowNum,i) = v_label.
        IF bf:DATA-TYPE = "character" THEN hExcel:Worksheets("Sheet1"):columns(i):NumberFormatLocal = "@".
END.

v_totalcol = 1.
REPEAT:
    iRowNum = iRowNum + 1.
    hq:GET-NEXT.
    IF hq:QUERY-OFF-END THEN LEAVE.
    i = 0.
    DO iCounter = 1 TO bh:NUM-FIELDS:
        bf = bh:BUFFER-FIELD(iCounter).

            i = i + 1.
            IF bf:DATA-TYPE = "Date" or bf:Data-type = "CHARACTER" then
            		hExcel:Worksheets("Sheet1"):Cells(iRowNum,i) = "'" + bf:BUFFER-VALUE.
            else
            		hExcel:Worksheets("Sheet1"):Cells(iRowNum,i) = bf:BUFFER-VALUE.
            v_totalcol = i.

    END.
    DISPLAY iRowNum WITH FRAME waitingframe.
    /*MESSAGE iRowNum. PAUSE 0.*/
END.

v_totalcol = MIN(v_totalcol,20).
ASSIGN 
    ColumnRange = CHR(65) + ":" + CHR(65 + v_totalcol - 1).
    hExcel:COLUMNS(ColumnRange):SELECT.
    hExcel:SELECTION:COLUMNS:AUTOFIT.


HIDE FRAME waitingframe NO-PAUSE.

ASSIGN hExcel:VISIBLE = TRUE.

MESSAGE "关闭EXCEL，返回" VIEW-AS ALERT-BOX BUTTONS OK.  

/* Perform housekeeping and cleanup steps */
hExcel:DisplayAlerts = FALSE.
hExcel:Application:Workbooks:CLOSE() NO-ERROR.
hExcel:Application:QUIT NO-ERROR.
RELEASE OBJECT hWorksheet.
RELEASE OBJECT hWorkbook.
RELEASE OBJECT hExcel.