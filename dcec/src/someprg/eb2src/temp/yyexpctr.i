FIND FIRST xxexp_ctrl NO-LOCK NO-ERROR .
IF NOT AVAILABLE xxexp_ctrl THEN DO :
    MESSAGE "����ά��������ñ�������ļ���" VIEW-AS ALERT-BOX ERROR.
    LEAVE .
END.
ELSE DO :
    FIND gra_mstr NO-LOCK WHERE gra_an_code = xxexp_expense AND gra_gl_type = "1" NO-ERROR .
    IF NOT AVAILABLE gra_mstr THEN DO :
        MESSAGE "������ñ�������ļ���������÷����������" VIEW-AS ALERT-BOX ERROR.
        LEAVE .
    END.
    FIND gra_mstr NO-LOCK WHERE gra_an_code = xxexp_sales AND gra_gl_type = "1" NO-ERROR .
    IF NOT AVAILABLE gra_mstr THEN DO :
        MESSAGE "������ñ�������ļ������۷����������" VIEW-AS ALERT-BOX ERROR.
        LEAVE .
    END.
    FIND gra_mstr NO-LOCK WHERE gra_an_code = xxexp_discount AND gra_gl_type = "1" NO-ERROR .
    IF NOT AVAILABLE gra_mstr THEN DO :
        MESSAGE "������ñ�������ļ����ۿ����÷����������" VIEW-AS ALERT-BOX ERROR.
        LEAVE .
    END.
END.
