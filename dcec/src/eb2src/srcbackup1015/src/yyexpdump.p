/**
 @File: yyexpdump.p
 @Description: ���ñ���������
 @Version: 1.0
 @Author: Cai Jing
 @Created: 2005-8-26
 @BusinessLogic: ���ñ���������
 @Todo: 
 @History: 
**/

{mfdtitle.i}
{yyburdef.i NEW}

DEF VAR expana LIKE gra_an_code LABEL "���ÿ�Ŀ��������" .
DEF VAR ccana LIKE gra_an_code LABEL "�ɱ����ķ�������" .
DEF VAR fname AS CHAR FORMAT "x(20)" LABEL "����ļ���" .
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
    UPDATE expana VALIDATE(CAN-FIND(gra_mstr WHERE gra_an_code = expana AND gra_gl_type = "1") OR expana = "", "��������Ч�Ŀ�Ŀ�������룡")
        ccana VALIDATE(CAN-FIND(gra_mstr WHERE gra_an_code = ccana AND gra_gl_type = "2") OR ccana = "", "��������Ч�ĳɱ����ķ������룡")
        ent ent1
        glyear
        glper VALIDATE(glper >= 1 AND glper <= 12, "��������Ч�Ļ���ڼ䣡")
        fname VALIDATE(fname <> "", "����������ļ�����")
        WITH FRAME a .

    IF ent1 = "" THEN ent1 = hi_char .

    IF expana = "" AND ccana = "" THEN DO :
        MESSAGE "�������Ŀ���������ɱ����ķ������룡" VIEW-AS ALERT-BOX ERROR .
        LEAVE .
    END.

    IF xxexp_expense = expana THEN expense = YES .
    ELSE expense = NO .

    IF expense THEN DO :
        FIND FIRST CODE_mstr NO-LOCK WHERE CODE_fldname = "allbur" NO-ERROR .
        IF NOT AVAILABLE CODE_mstr THEN DO :
            MESSAGE "û���ҵ�������ý�ת���ģ�" VIEW-AS ALERT-BOX ERROR .
            LEAVE .
        END.
    END.

    outfile = xxexp_dir + fname .
    IF SEARCH(outfile) <> ? THEN DO :
        MESSAGE "�ļ��Ѵ���" VIEW-AS ALERT-BOX ERROR .
        UNDO, RETRY .
    END.

/*get acount balance data*/
    STATUS DEFAULT "�������ݡ���" .
    {gprun.i ""yygetbur.p"" "(input expana,
        INPUT ccana,
        INPUT YES)"
     }

/*output excel format*/
    STATUS DEFAULT "����ļ�����" .
    {gprun.i ""yyexpdu1.p"" "(INPUT outfile)"}

END.








