/**
 @File: yyexpctr.i
 @Description: ������ÿ����ļ�У��
 @Version: 1.0
 @Author: Cai Jing
 @Created: 2005-8-26
 @BusinessLogic: ������ÿ����ļ�У��
 @Todo: 
 @History: 
**/
/* $Revision:eb21sp12  $ BY: Jordan Lin            DATE: 08/13/12  ECO: *SS-20120813.1*   */

FIND FIRST xxexp_ctrl where /* *SS-20120813.1*   */ xxexp_ctrl.xxexp_domain = global_domain NO-LOCK NO-ERROR .
IF NOT AVAILABLE xxexp_ctrl THEN DO :
    MESSAGE "����ά��������ñ�������ļ���" VIEW-AS ALERT-BOX ERROR.
    LEAVE .
END.
ELSE DO :
    FIND gra_mstr NO-LOCK WHERE /* *SS-20120813.1*   */ gra_mstr.gra_domain = global_domain and gra_an_code = xxexp_expense AND gra_gl_type = "1" NO-ERROR .
    IF NOT AVAILABLE gra_mstr THEN DO :
        MESSAGE "������ñ�������ļ���������÷����������" VIEW-AS ALERT-BOX ERROR.
        LEAVE .
    END.
    FIND gra_mstr NO-LOCK WHERE /* *SS-20120813.1*   */ gra_mstr.gra_domain = global_domain and  gra_an_code = xxexp_sales AND gra_gl_type = "1" NO-ERROR .
    IF NOT AVAILABLE gra_mstr THEN DO :
        MESSAGE "������ñ�������ļ������۷����������" VIEW-AS ALERT-BOX ERROR.
        LEAVE .
    END.
    FIND gra_mstr NO-LOCK WHERE /* *SS-20120813.1*   */ gra_mstr.gra_domain = global_domain and  gra_an_code = xxexp_discount AND gra_gl_type = "1" NO-ERROR .
    IF NOT AVAILABLE gra_mstr THEN DO :
        MESSAGE "������ñ�������ļ����ۿ����÷����������" VIEW-AS ALERT-BOX ERROR.
        LEAVE .
    END.
END.
