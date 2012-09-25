DEFINE INPUT PARAMETER inp-rptfile AS CHAR.


{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */



IF SEARCH(inp-rptfile) = ? THEN LEAVE.

DEFINE TEMP-TABLE ttt1 RCODE-INFORMATION
    FIELDS ttt1_line AS INTEGER               LABEL "ÐÐ"
    FIELDS ttt1_data AS CHAR FORMAT "X(200)"  LABEL "ÄÚÈÝ".

FOR EACH ttt1: DELETE ttt1. END.

RUN xxpro-bud-ttt1.
RUN xxpro-view-ttt1.

PROCEDURE xxpro-bud-ttt1:
    DEF VAR i AS INTEGER.
    DEF VAR v-data AS CHAR.

    i = 0.
    INPUT FROM VALUE(inp-rptfile).

    REPEAT:
        v-data = "".
        i = i + 1.
        IMPORT UNFORMATTED v-data.
        CREATE ttt1.
        ASSIGN
            ttt1_line = i
            ttt1_data = v-data.
    END.
    INPUT CLOSE.
END PROCEDURE.

PROCEDURE xxpro-view-ttt1:
    DEFINE VAR h-a AS HANDLE.
    h-a = TEMP-TABLE ttt1:HANDLE.
    RUN value(lc(global_user_lang) + "\yy\yyut2browse.p") (INPUT-OUTPUT TABLE-HANDLE h-a, 
                                         INPUT "yyut3", 
                                         INPUT "", 
                                         INPUT "",
                                         INPUT "" ,
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "").
END PROCEDURE.

