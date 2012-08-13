
FIND FIRST b_usr_mstr NO-LOCK WHERE b_usr_usrid = global_userid NO-ERROR.
    IF AVAILABLE b_usr_mstr THEN DO:
        pname = b_usr_printer.
        IF (pname NE "ZPL") AND (pname NE "IPL") THEN DO:
            MESSAGE "用户资料里维护的打印机类型不正确,应为IPL或者ZPL".
            RETURN.
        END.
    END.
    ELSE DO:
        MESSAGE "没能在用户资料里找到打印机类型,应为IPL或者ZPL".
        RETURN.
    END.
