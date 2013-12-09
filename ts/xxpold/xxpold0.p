/* xxpold0.p - import from xls                                            */
{mfdeclre.i}
{xxpold.i}
define input parameter thfile as CHAR FORMAT "x(50)".

FUNCTION str2Date RETURNS DATE(INPUT datestr AS CHARACTER
                              ,INPUT fmt AS CHARACTER) forward.
define variable bexcel as com-handle.
define variable bbook as com-handle.
define variable bsheet as com-handle.
define variable intI as integer.
  create "Excel.Application" bexcel.
  bexcel:visible = false.
  bbook = bexcel:Workbooks:OPEN(thfile,,true).
  bsheet = bexcel:Sheets:Item(1) NO-ERROR.
  bsheet:Activate NO-ERROR.
  empty temp-table xxpod9 no-error.
  DO intI = 2 TO bsheet:UsedRange:Rows:Count:
     if TRIM(bsheet:cells(intI,1):FormulaR1C1) <> "" and
        TRIM(bsheet:cells(intI,2):FormulaR1C1) <> "" and
        TRIM(bsheet:cells(intI,3):FormulaR1C1) <> "" and
        TRIM(bsheet:cells(intI,9):FormulaR1C1) <> "" and
        TRIM(bsheet:cells(intI,10):FormulaR1C1) <> "" then do:
        create xxpod9.
        assign x9_nbr = TRIM(bsheet:cells(intI,1):FormulaR1C1)
               x9_vend = TRIM(bsheet:cells(intI,2):FormulaR1C1)
               x9_ship = TRIM(bsheet:cells(intI,3):FormulaR1C1)
               x9_due_date = str2Date(TRIM(bsheet:cells(intI,4):value),"ymd")
               x9_pr_list2 = TRIM(bsheet:cells(intI,5):FormulaR1C1)
               x9_pr_list = TRIM(bsheet:cells(intI,6):FormulaR1C1)
               x9_buyer = TRIM(bsheet:cells(intI,7):FormulaR1C1)
               x9_rmks  = TRIM(bsheet:cells(intI,8):FormulaR1C1)
               x9_site = TRIM(bsheet:cells(intI,9):FormulaR1C1)
               x9_line = integer(TRIM(bsheet:cells(intI,10):FormulaR1C1))
               x9_part = TRIM(bsheet:cells(intI,11):FormulaR1C1)
               x9_qty_ord = decimal(TRIM(bsheet:cells(intI,12):FormulaR1C1))
               x9_qty_fc1 = decimal(TRIM(bsheet:cells(intI,13):FormulaR1C1))
               x9_qty_fc2 = decimal(TRIM(bsheet:cells(intI,14):FormulaR1C1))
               no-error.
     end.
  END.
bbook:CLOSE().
bexcel:quit.
RELEASE OBJECT bsheet NO-ERROR.
RELEASE OBJECT bbook NO-ERROR.
RELEASE OBJECT bexcel NO-ERROR.

/* 日期YYYY-MM-DD转换为QAD日期格式 */
FUNCTION str2Date RETURNS DATE(INPUT datestr AS CHARACTER
                              ,INPUT fmt AS CHARACTER):
    DEFINE VARIABLE sstr AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iY   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iM   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE id   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE od   AS DATE      NO-UNDO.
    define variable spchar as character no-undo.
    define variable i as integer.
    if datestr = "" or datestr = "?" then do:
        assign od = ?.
    end.
    else do:
        ASSIGN sstr = datestr.
        do i = 1 to length(sstr).
           if index("0123456789",substring(sstr,i,1)) = 0 then do:
              assign spchar = substring(sstr,i,1).
              leave.
           end.
        end.
        if lower(fmt) = "ymd" then do:
           ASSIGN iY = INTEGER(SUBSTRING(sstr,1,INDEX(sstr,spchar) - 1)).
           ASSIGN sstr = SUBSTRING(sstr,INDEX(sstr,spchar) + 1).
           ASSIGN iM = INTEGER(SUBSTRING(sstr,1,INDEX(sstr,spchar) - 1)).
           ASSIGN iD = INTEGER(SUBSTRING(sstr,INDEX(sstr,spchar) + 1)).
        end.
        else if lower(fmt) = "mdy" then do:
           ASSIGN iM = INTEGER(SUBSTRING(sstr,1,INDEX(sstr,spchar) - 1)).
           ASSIGN sstr = SUBSTRING(sstr,INDEX(sstr,spchar) + 1).
           ASSIGN iD = INTEGER(SUBSTRING(sstr,1,INDEX(sstr,spchar) - 1)).
           ASSIGN iY = INTEGER(SUBSTRING(sstr,INDEX(sstr,spchar) + 1)).
        end.
        else if lower(fmt) = "dmy" then do:
           ASSIGN iD = INTEGER(SUBSTRING(sstr,1,INDEX(sstr,spchar) - 1)).
           ASSIGN sstr = SUBSTRING(sstr,INDEX(sstr,spchar) + 1).
           ASSIGN iM = INTEGER(SUBSTRING(sstr,1,INDEX(sstr,spchar) - 1)).
           ASSIGN iY = INTEGER(SUBSTRING(sstr,INDEX(sstr,spchar) + 1)).
        end.
        if iY <= 1000 then iY = iY + 2000.
        ASSIGN od = DATE(im,id,iy).
    end.
    RETURN od.
END FUNCTION.
