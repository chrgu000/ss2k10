    DEF VAR h-tt AS HANDLE.
    h-tt = TEMP-TABLE ttx1:HANDLE.

    RUN value(lc(global_user_lang) + "\yy\yyut2browse.p") (INPUT-OUTPUT TABLE-HANDLE h-tt,
                                         INPUT "yywobmvrrp", 
                                         INPUT "", 
                                         INPUT "",
                                         INPUT "累计加工单",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "").
