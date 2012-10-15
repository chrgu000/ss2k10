/**
 @File: yygetbur.p
 @Description: 获取指定分析代码帐户信息
 @Version: 1.0
 @Author: Cai Jing
 @Created: 2005-8-26
 @BusinessLogic: 获取指定分析代码帐户信息
 @Todo: 
 @History: 
**/
/* $Revision:eb21sp12  $ BY: Jordan Lin            DATE: 08/13/12  ECO: *SS-20120813.1*   */

DEF INPUT PARAMETER expana LIKE gra_an_code .
DEF INPUT PARAMETER ccana LIKE gra_an_code .
DEF INPUT PARAMETER s AS LOGICAL .

DEF VAR cc0 LIKE acd_cc .

{mfdeclre.i}
{yyburdef.i}

DEF NEW SHARED TEMP-TABLE xxitem
    FIELD xx_item AS CHAR .

DEF TEMP-TABLE outacc
    FIELD out_acc LIKE acd_acc .

DEF TEMP-TABLE outcc
    FIELD out_cc LIKE acd_cc .

FIND FIRST xxexp_ctrl NO-LOCK NO-ERROR .

cc0 = "" .

IF xxexp_expense = expana THEN DO :
/*get turnover cost center*/    
    FIND FIRST CODE_mstr NO-LOCK WHERE  /* *SS-20120813.1*   */ CODE_mstr.CODE_domain = global_domain and  CODE_fldname = "allbur" NO-ERROR .
    cc0 = CODE_cmmt .

/*get sales amount*/        
    bsales = 0 .
    csales = 0 .

    {gprun.i ""yygetana.p"" "(input xxexp_sales)"}

    FOR EACH acd_det NO-LOCK
        WHERE  /* *SS-20120813.1*   */ acd_det.acd_domain = global_domain and acd_year = glyear
        AND acd_per = glper 
        AND acd_entity >= ent
        AND acd_entity <= ent1 ,
        EACH xxitem NO-LOCK
        WHERE xx_item = acd_acc :
        IF acd_sub = "1" THEN bsales = bsales + acd_amt .
        IF acd_sub = "2" THEN csales = csales + acd_amt .
    END.

/*get discount amount*/
    bdiscount = 0 .
    cdiscount = 0 .

    {gprun.i ""yygetana.p"" "(input xxexp_discount)"}

    FOR EACH acd_det NO-LOCK
        WHERE  /* *SS-20120813.1*   */ acd_det.acd_domain = global_domain and acd_year = glyear
        AND acd_per = glper 
        AND acd_entity >= ent
        AND acd_entity <= ent1 ,
        EACH xxitem NO-LOCK
        WHERE xx_item = acd_acc :
        IF acd_sub = "1" THEN bdiscount = bdiscount + acd_amt .
        IF acd_sub = "2" THEN cdiscount = cdiscount + acd_amt .
    END.

END. /*if expense*/

/*get account list*/
IF expana <> "" THEN DO :
    FOR EACH outacc :
        DELETE outacc .
    END.
    {gprun.i ""yygetana.p"" "(input expana)"}
    FOR EACH xxitem NO-LOCK :
        CREATE outacc .
        out_acc = xx_item .
    END.
END.

/*get cost center list*/
IF ccana <> "" THEN DO :
    FOR EACH outcc :
        DELETE outcc .
    END.
    {gprun.i ""yygetana.p"" "(input ccana)"}
    FOR EACH xxitem NO-LOCK :
        CREATE outcc .
        out_cc = xx_item .
    END.
END.

/*get data*/
FOR EACH data :
    DELETE data .
END.

FOR EACH acd_det NO-LOCK
    WHERE  /* *SS-20120813.1*   */ acd_det.acd_domain = global_domain and acd_year = glyear
      AND acd_per = glper 
      AND acd_entity >= ent
      AND acd_entity <= ent1 :

    IF expana <> "" THEN DO :
        FIND outacc WHERE out_acc = acd_acc NO-ERROR .
        IF NOT AVAILABLE outacc THEN NEXT .
    END.

    IF ccana <> "" THEN DO :
        FIND outcc WHERE out_cc = acd_cc NO-ERROR .
        IF NOT AVAILABLE outcc THEN NEXT .
    END.

    IF cc0 <> "" THEN IF cc0 = acd_cc THEN NEXT .

    IF s = NO THEN DO :
        FIND data WHERE data_acc = acd_acc
                    AND data_sub = acd_sub
                    AND data_cc = acd_cc 
                    AND data_entity = acd_entity NO-ERROR .
        IF NOT AVAILABLE data THEN DO :
            CREATE data .
            data_acc = acd_acc .
            data_sub = acd_sub .
            data_cc = acd_cc .
            data_entity = acd_entity .
        END.
    END.
    ELSE DO :
        FIND data WHERE data_acc = acd_acc
                    AND data_sub = acd_sub
                    AND data_cc = acd_cc NO-ERROR .
        IF NOT AVAILABLE data THEN DO :
            CREATE data .
            data_acc = acd_acc .
            data_sub = acd_sub .
            data_cc = acd_cc .
        END.
    END.
    data_amt = data_amt + acd_amt .

END .
