    DEF VAR h-tt AS HANDLE.
    h-tt = TEMP-TABLE ttx3:HANDLE.

    RUN value(lc(global_user_lang) + "\yy\yyut2browse.p") (INPUT-OUTPUT TABLE-HANDLE h-tt,
                                         INPUT "yywobmvrrpa", 
                                         INPUT "", 
                                         INPUT "",
                                         INPUT "累计加工单",
                                         INPUT "ttx3_i",
                                         INPUT "yywobmvrrpb.p",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "").
