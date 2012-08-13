/**
 @File: yyexpdump.p
 @Description: 费用报表主程序
 @Version: 1.0
 @Author: Cai Jing
 @Created: 2005-8-26
 @BusinessLogic: 费用报表主程序
 @Todo: 
 @History: 
**/

{mfdtitle.i}
{yyburdef.i NEW}

DEF VAR expana LIKE gra_an_code LABEL "费用科目分析代码" .
DEF VAR ccana LIKE gra_an_code LABEL "成本中心分析代码" .
DEF VAR fname AS CHAR FORMAT "x(20)" LABEL "输出文件名" .
DEF VAR outfile AS CHAR .

FORM
    expana COLON 20
    ccana COLON 20
    ent COLON 20 ent1 LABEL {t001.i} COLON 50
    glyear COLON 20
    glper COLON 20
    fname COLON 20 
WITH FRAME a SIDE-LABELS THREE-D WIDTH 80 .
setFrameLabels(frame a:handle).

{yyexpctr.i}

REPEAT:
    IF ent1 = hi_char THEN ent1 = "" .
    glyear = YEAR(TODAY) .
    ent = "dcec".
    ent1 = "dcec".
    UPDATE expana VALIDATE(CAN-FIND(gra_mstr WHERE gra_an_code = expana AND gra_gl_type = "1") OR expana = "", "请输入有效的科目分析代码！")
        ccana VALIDATE(CAN-FIND(gra_mstr WHERE gra_an_code = ccana AND gra_gl_type = "2") OR ccana = "", "请输入有效的成本中心分析代码！")
        ent ent1
        glyear
        glper VALIDATE(glper >= 1 AND glper <= 12, "请输入有效的会计期间！")
        fname VALIDATE(fname <> "", "请输入输出文件名！")
        WITH FRAME a .

    IF ent1 = "" THEN ent1 = hi_char .

    IF expana = "" AND ccana = "" THEN DO :
        MESSAGE "请输入科目分析代码或成本中心分析代码！" VIEW-AS ALERT-BOX ERROR .
        LEAVE .
    END.

    IF xxexp_expense = expana THEN expense = YES .
    ELSE expense = NO .

    IF expense THEN DO :
        FIND FIRST CODE_mstr NO-LOCK WHERE CODE_fldname = "allbur" NO-ERROR .
        IF NOT AVAILABLE CODE_mstr THEN DO :
            MESSAGE "没有找到制造费用结转中心！" VIEW-AS ALERT-BOX ERROR .
            LEAVE .
        END.
    END.

    outfile = xxexp_dir + fname .
    IF SEARCH(outfile) <> ? THEN DO :
        MESSAGE "文件已存在" VIEW-AS ALERT-BOX ERROR .
        UNDO, RETRY .
    END.

/*get acount balance data*/
    STATUS DEFAULT "读入数据……" .
    {gprun.i ""yygetbur.p"" "(input expana,
        INPUT ccana,
        INPUT YES)"
     }

/*output excel format*/
    STATUS DEFAULT "输出文件……" .
    {gprun.i ""yyexpdu1.p"" "(INPUT outfile)"}

END.








