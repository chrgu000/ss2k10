
FIND FIRST b_usr_mstr NO-LOCK WHERE b_usr_usrid = global_userid NO-ERROR.
    IF AVAILABLE b_usr_mstr THEN DO:
        pname = b_usr_printer.
        IF (pname NE "ZPL") AND (pname NE "IPL") THEN DO:
            MESSAGE "�û�������ά���Ĵ�ӡ�����Ͳ���ȷ,ӦΪIPL����ZPL".
            RETURN.
        END.
    END.
    ELSE DO:
        MESSAGE "û�����û��������ҵ���ӡ������,ӦΪIPL����ZPL".
        RETURN.
    END.
