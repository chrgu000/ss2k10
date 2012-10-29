/* xxfcsimp.p - Forecast import from xls                                      */
/*V8:ConvertMode=Report                                                       */

/* DISPLAY TITLE */
{mfdeclre.i}
def shared var thfile as CHAR FORMAT "x(50)".
def shared var bexcel as com-handle.
def shared var bbook as com-handle.
def shared var bsheet as com-handle.

DEFINE VAR myi AS INT NO-UNDO.
DEFINE VAR thchar AS CHAR NO-UNDO.

DEFINE SHARED TEMP-TABLE mytt
    FIELD f01 AS CHAR
    FIELD f02 AS CHAR
    FIELD f03 AS CHAR
    FIELD f04 AS CHAR
    FIELD f05 AS CHAR format "x(18)"
    FIELD f06 AS CHAR
    FIELD f07 AS CHAR format "x(18)"
    FIELD f08 AS CHAR format "x(18)"
    FIELD f09 AS CHAR
    FIELD f10 AS CHAR
    FIELD f11 AS CHAR
    FIELD f12 AS CHAR format "x(48)"
    .


  create "Excel.Application" bexcel.
  bexcel:visible = false.
  bbook = bexcel:workbooks:open(thfile).
  Bsheet = bexcel:sheets:ITEM("socnimp").
  myi = 3.
  thchar = Bsheet:range("A2"):VALUE.

  DO WHILE thchar > "" :
      CREATE mytt.
      f01 = trim(string(Bsheet:cells(myi, 1):VALUE)).
      f02 = trim(string(Bsheet:cells(myi, 2):VALUE)).
      f03 = trim(string(Bsheet:cells(myi, 3):VALUE)).
      f04 = trim(string(Bsheet:cells(myi, 4):VALUE)).
      f05 = trim(string(Bsheet:cells(myi, 5):VALUE)).
      f06 = trim(string(Bsheet:cells(myi, 6):VALUE)).
      f07 = trim(string(Bsheet:cells(myi, 7):VALUE)).
      f08 = trim(string(Bsheet:cells(myi, 8):VALUE)).
      f09 = trim(string(Bsheet:cells(myi, 9):VALUE)).
      f10 = trim(string(Bsheet:cells(myi,10):VALUE)).
      f11 = trim(string(Bsheet:cells(myi,11):VALUE)).
      f12 = "".
      if f01 = ? then f01 = "-" .
      if f02 = ? then f02 = "-" .
      if f03 = ? then f03 = "-" .
      if f04 = ? then f04 = "-" .
      if f05 = ? then f05 = "-" .
      if f06 = ? then f06 = "-" .
      if f07 = ? then f07 = "-" .
      if f08 = ? then f08 = "-" .
      if f09 = ? then f09 = "-" .
      if f10 = ? then f10 = "-" .
      if f11 = ? then f11 = "-" .
      myi = myi + 1.
      thchar = Bsheet:range("A" + STRING(myi)):VALUE.
  END.
