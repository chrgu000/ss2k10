/**
 @File: yygetana.p
 @Description: 获取分析代码信息
 @Version: 1.0
 @Author: Cai Jing
 @Created: 2005-8-26
 @BusinessLogic: 获取分析代码信息
 @Todo: 
 @History: 
**/
/* $Revision:eb21sp12  $ BY: Jordan Lin            DATE: 08/13/12  ECO: *SS-20120813.1*   */


 /* *SS-20120813.1*   */  {mfdeclre.i }
DEF INPUT PARAMETER an_code LIKE gra_an_code .

DEF SHARED TEMP-TABLE xxitem
    FIELD xx_item AS CHAR .

FOR EACH xxitem :
    DELETE xxitem .
END.

FIND gra_mstr NO-LOCK WHERE  /* *SS-20120813.1*   */ gra_mstr.gra_domain = global_domain and  gra_an_code = an_code NO-ERROR .
IF NOT AVAILABLE gra_mstr THEN DO :
    MESSAGE an_code "分析代码不存在。" VIEW-AS ALERT-BOX ERROR .
    LEAVE .
END.

RUN getancode (INPUT an_code) .

PROCEDURE getancode :

    DEF INPUT PARAMETER ancode LIKE gra_an_code .

    FIND gra_mstr NO-LOCK WHERE  /* *SS-20120813.1*   */ gra_mstr.gra_domain = global_domain and  gra_an_code = ancode NO-ERROR .
    IF NOT AVAILABLE gra_mstr THEN LEAVE .
    
    IF gra_link = NO THEN DO :
        FOR EACH grad_det NO-LOCK WHERE /* *SS-20120813.1*   */ grad_det.grad_domain = global_domain and grad_an_code = gra_an_code :
            FIND xxitem WHERE xx_item = grad_gl_code NO-ERROR .
            IF NOT AVAILABLE xxitem THEN DO :
                CREATE xxitem .
                xx_item = grad_gl_code .
            END.
        END.
    END.
    ELSE DO :
        FOR EACH gral_det NO-LOCK WHERE /* *SS-20120813.1*   */ gral_det.gral_domain = global_domain and  gral_an_code = ancode :
            RUN getancode (INPUT gral_link_code) .
        END.
    END.

END .

