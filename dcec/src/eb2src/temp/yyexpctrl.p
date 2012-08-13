{mfdtitle.i}

DEFINE VARIABLE l_slash AS CHARACTER .
DEFINE VARIABLE ydir AS CHARACTER .

FORM
    xxexp_expense COLON 20
    xxexp_sales COLON 20
    xxexp_discount COLON 20
    xxexp_dir COLON 20
WITH FRAME a SIDE-LABELS WIDTH 80 THREE-D .
setframelabels(FRAME a:HANDLE) .

IF OPSYS = "unix" THEN ASSIGN l_slash = "/".
ELSE IF OPSYS = "msdos" OR OPSYS = "win32" THEN ASSIGN l_slash = "~\".
ELSE IF OPSYS = "vms"  THEN l_slash = "]". 

FUNCTION slashok RETURNS CHARACTER (xdir AS CHARACTER):
    IF LOOKUP(SUBSTRING(xdir,LENGTH(xdir),1),"/,\,[.") = 0
    THEN RETURN ( xdir + l_slash)  .
    ELSE RETURN xdir .
END FUNCTION .

FUNCTION dirok RETURNS LOGICAL (xdir AS CHARACTER) :    
    DEFINE VARIABLE l_output_ok LIKE mfc_logical NO-UNDO .
    IF xdir = "" THEN RETURN NO .
    ELSE DO:
        xdir = slashok(xdir) .
        {gprun.i ""yymfoutexi.p"" "(xdir + ""TMP"",output l_output_ok)"}
        RETURN l_output_ok .
    END.
END FUNCTION .

REPEAT:
    FIND FIRST xxexp_ctrl EXCLUSIVE-LOCK NO-ERROR .
    IF NOT AVAILABLE xxexp_ctrl THEN DO :
        CREATE xxexp_ctrl .
    END.

    UPDATE xxexp_expense VALIDATE(CAN-FIND(gra_mstr WHERE gra_an_code = xxexp_expense AND gra_gl_type = "1"),"请输入有效的分析代码！")
        xxexp_sales VALIDATE(CAN-FIND(gra_mstr WHERE gra_an_code = xxexp_sales AND gra_gl_type = "1"),"请输入有效的分析代码！")
        xxexp_discount VALIDATE(CAN-FIND(gra_mstr WHERE gra_an_code = xxexp_discount AND gra_gl_type = "1"),"请输入有效的分析代码！")
        xxexp_dir VALIDATE(dirok(xxexp_dir), "目录不存在")
        WITH FRAME a .

    xxexp_dir = slashok(xxexp_dir) .
END.


