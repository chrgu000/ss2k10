DEFINE INPUT PARAMETER xxdate AS DATE .
DEFINE INPUT PARAMETER dateformat AS CHARACTER .
DEFINE OUTPUT PARAMETER endmonthday AS DATE .
DEFINE VARIABLE dd AS INTEGER .
DEFINE VARIABLE mm AS INTEGER .
DEFINE VARIABLE yyyy AS INTEGER .
DEFINE VARIABLE datechar AS CHARACTER .
datechar = STRING(xxdate,"99/99/99") .
mm = MONTH(xxdate) .
yyyy = YEAR(xxdate) .
dd = 01 .
mm = mm + 1 .
IF mm > 12 THEN
    ASSIGN yyyy = yyyy + 1 
                 mm = 1 .
endmonthday = DATE(mm,dd,yyyy)  - 1 .
