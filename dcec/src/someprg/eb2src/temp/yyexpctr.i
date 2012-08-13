FIND FIRST xxexp_ctrl NO-LOCK NO-ERROR .
IF NOT AVAILABLE xxexp_ctrl THEN DO :
    MESSAGE "请先维护制造费用报表控制文件。" VIEW-AS ALERT-BOX ERROR.
    LEAVE .
END.
ELSE DO :
    FIND gra_mstr NO-LOCK WHERE gra_an_code = xxexp_expense AND gra_gl_type = "1" NO-ERROR .
    IF NOT AVAILABLE gra_mstr THEN DO :
        MESSAGE "制造费用报表控制文件中制造费用分析代码错误！" VIEW-AS ALERT-BOX ERROR.
        LEAVE .
    END.
    FIND gra_mstr NO-LOCK WHERE gra_an_code = xxexp_sales AND gra_gl_type = "1" NO-ERROR .
    IF NOT AVAILABLE gra_mstr THEN DO :
        MESSAGE "制造费用报表控制文件中销售分析代码错误！" VIEW-AS ALERT-BOX ERROR.
        LEAVE .
    END.
    FIND gra_mstr NO-LOCK WHERE gra_an_code = xxexp_discount AND gra_gl_type = "1" NO-ERROR .
    IF NOT AVAILABLE gra_mstr THEN DO :
        MESSAGE "制造费用报表控制文件中折扣折让分析代码错误！" VIEW-AS ALERT-BOX ERROR.
        LEAVE .
    END.
END.
