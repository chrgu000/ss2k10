/**
 @File: yyexpctr.i
 @Description: 制造费用控制文件校验
 @Version: 1.0
 @Author: Cai Jing
 @Created: 2005-8-26
 @BusinessLogic: 制造费用控制文件校验
 @Todo: 
 @History: 
**/
/* $Revision:eb21sp12  $ BY: Jordan Lin            DATE: 08/13/12  ECO: *SS-20120813.1*   */

FIND FIRST xxexp_ctrl where /* *SS-20120813.1*   */ xxexp_ctrl.xxexp_domain = global_domain NO-LOCK NO-ERROR .
IF NOT AVAILABLE xxexp_ctrl THEN DO :
    MESSAGE "请先维护制造费用报表控制文件。" VIEW-AS ALERT-BOX ERROR.
    LEAVE .
END.
ELSE DO :
    FIND gra_mstr NO-LOCK WHERE /* *SS-20120813.1*   */ gra_mstr.gra_domain = global_domain and gra_an_code = xxexp_expense AND gra_gl_type = "1" NO-ERROR .
    IF NOT AVAILABLE gra_mstr THEN DO :
        MESSAGE "制造费用报表控制文件中制造费用分析代码错误！" VIEW-AS ALERT-BOX ERROR.
        LEAVE .
    END.
    FIND gra_mstr NO-LOCK WHERE /* *SS-20120813.1*   */ gra_mstr.gra_domain = global_domain and  gra_an_code = xxexp_sales AND gra_gl_type = "1" NO-ERROR .
    IF NOT AVAILABLE gra_mstr THEN DO :
        MESSAGE "制造费用报表控制文件中销售分析代码错误！" VIEW-AS ALERT-BOX ERROR.
        LEAVE .
    END.
    FIND gra_mstr NO-LOCK WHERE /* *SS-20120813.1*   */ gra_mstr.gra_domain = global_domain and  gra_an_code = xxexp_discount AND gra_gl_type = "1" NO-ERROR .
    IF NOT AVAILABLE gra_mstr THEN DO :
        MESSAGE "制造费用报表控制文件中折扣折让分析代码错误！" VIEW-AS ALERT-BOX ERROR.
        LEAVE .
    END.
END.
