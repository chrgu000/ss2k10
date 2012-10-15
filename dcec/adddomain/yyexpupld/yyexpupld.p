/**
 @File: yyexpupld.p
 @Description: ������ý�ת������
 @Version: 1.0
 @Author: Cai Jing
 @Created: 2005-8-11
 @BusinessLogic: ������ý�ת������
 @Todo: 
 @History: 
**/
/* $Revision:DCEC  $ BY: Jordan Lin       DATE: 10/09/12     ECO: *SS-20121009.1*   */
/* *SS-20121009.1*    {mfdtitle.i } */
/* *SS-20121009.1*   */{mfdtitle.i "121009.1"}
{zylib.i}
{yyburdef.i NEW}
{zycimload.i NEW}

DEF VAR effdate LIKE glt_effdate .

DEF VAR ifn AS CHAR .
DEF VAR lfn AS CHAR .
DEF VAR cimf AS CHAR .
DEF VAR yn AS LOGICAL .

DEF NEW SHARED TEMP-TABLE xxgl
    FIELD xxgl_acct LIKE glt_acct
    FIELD xxgl_sub LIKE glt_sub
    FIELD xxgl_cc LIKE glt_cc
    FIELD xxgl_entity LIKE glt_entity 
    FIELD xxgl_amt LIKE glt_amt .

FORM
    ent COLON 20 ent1 LABEL {t001.i} COLON 50
    glyear COLON 20
    glper COLON 20
    effdate COLON 20 SKIP(1)
WITH FRAME a THREE-D SIDE-LABELS WIDTH 80 .
setframelabels(FRAME a:HANDLE) .

{yyexpctr.i}

REPEAT:

    glyear = YEAR(TODAY) .
    IF ent1 = hi_char THEN ent1 = "" .
     ent = "dcec".
     ent1 = "dcec".
    UPDATE ent ent1
        glyear
        glper VALIDATE(glper >= 1 AND glper <= 12, "��������Ч�Ļ���ڼ䣡")
        effdate VALIDATE(effdate <> ?, "��������Ч���ڣ�") WITH FRAME a .

    IF ent1 = "" THEN ent1 = hi_char .

    FIND FIRST gl_ctrl NO-LOCK /* *SS-20121009.1*   */ where gl_ctrl.gl_domain = global_domain NO-ERROR .
    IF CKGLEffDate('GL', gl_entity, effdate) = NO THEN UNDO, RETRY .

/*get acount balance data*/
    STATUS DEFAULT "�������ݡ���" .
    {gprun.i ""yygetbur.p"" "(input xxexp_expense ,
        INPUT '',
        INPUT NO)"
     }

/*cim load gl transaction*/
    STATUS DEFAULT "������ݡ���" .
    /*create cim file*/
    cimf = mfguser + STRING(TIME) + ".bd" .
    {gprun.i ""yyburcim.p"" "(input cimf, input effdate, output yn)"}
    IF yn = NO THEN LEAVE .

    MESSAGE "���ݼ���ͨ�������ڽ�ת���������" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE yn .
    IF yn = NO THEN UNDO, RETRY .

    /*Cim load process*/
    STATUS DEFAULT "�������ݡ���" .
    cimloop:
    DO TRANSACTION ON ERROR UNDO, LEAVE
        ON ENDKEY UNDO, LEAVE :
        
        /*cimload*/
        {gprun.i ""zycimload.p"" "(input cimf)"}

        /*check err*/
        FIND FIRST xxerrtb NO-LOCK WHERE xxerr > "01" NO-ERROR .
        IF AVAILABLE xxerrtb THEN UNDO cimloop, LEAVE cimloop .
        ELSE OS-DELETE VALUE(cimf) .
        
    END.
    
    /*�����������*/
    {mfselprt.i "printer" 132}   
    {mfphead.i}
    
    DISPLAY "�������ݣ�" SKIP(1) .
    FOR EACH xxgl :
        DISPLAY xxgl_acc xxgl_sub xxgl_cc xxgl_entity xxgl_amt WITH STREAM-IO WIDTH 80 .
    END.

    DISPLAY SKIP(1) "��������" SKIP(1) .
    FOR EACH xxerrtb NO-LOCK :
          DISPLAY xxerr xxmsg FORMAT "x(60)" WITH STREAM-IO WIDTH 80 .
    END.

    {mfrtrail.i}    

END. /*repeat*/
