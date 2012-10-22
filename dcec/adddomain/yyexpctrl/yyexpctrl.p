/**
 @File: yyexpctrl.p
 @Description: ������ÿ����ļ�
 @Version: 1.0
 @Author: Cai Jing
 @Created: 2005-8-26
 @BusinessLogic: ������ÿ����ļ�
 @Todo: 
 @History: 
**/
/* $Revision:eb21sp12  $ BY: Jordan Lin            DATE: 08/13/12  ECO: *SS-20120814.1*   */

{mfdtitle.i "120814.1"}

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
    FIND FIRST xxexp_ctrl /* *SS-20120814.1*   */ where xxexp_ctrl.xxexp_domain = global_domain EXCLUSIVE-LOCK NO-ERROR .
    IF NOT AVAILABLE xxexp_ctrl THEN DO :
        CREATE xxexp_ctrl .
        /* *SS-20120814.1*   */ xxexp_domain = global_domain .
    END.

    UPDATE xxexp_expense VALIDATE(CAN-FIND(gra_mstr WHERE /* *SS-20120813.1*   */ gra_mstr.gra_domain = global_domain and gra_an_code = xxexp_expense AND gra_gl_type = "1"),"��������Ч�ķ������룡")
        xxexp_sales VALIDATE(CAN-FIND(gra_mstr WHERE  /* *SS-20120813.1*   */ gra_mstr.gra_domain = global_domain and gra_an_code = xxexp_sales AND gra_gl_type = "1"),"��������Ч�ķ������룡")
        xxexp_discount VALIDATE(CAN-FIND(gra_mstr WHERE  /* *SS-20120813.1*   */ gra_mstr.gra_domain = global_domain and gra_an_code = xxexp_discount AND gra_gl_type = "1"),"��������Ч�ķ������룡")
        xxexp_dir VALIDATE(dirok(xxexp_dir), "Ŀ¼������")
        WITH FRAME a .

    xxexp_dir = slashok(xxexp_dir) .
END.

