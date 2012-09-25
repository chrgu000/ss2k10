{mfdeclre.i} /*GUI moved to top.*/
{gplabel.i} /* EXTERNAL LABEL INCLUDE */


DEF INPUT PARAMETER inp_value AS CHAR.
DEF VAR i AS INTEGER.
DEF VAR v_data AS CHARACTER.

DEF TEMP-TABLE xxwk1 RCODE-INFORMATION
    FIELDS xxwk1_line AS INTEGER   FORMAT ">>>>" LABEL "行"
    FIELDS xxwk1_cmmt AS CHARACTER FORMAT "x(200)"  LABEL "内容"
    .

i = 0.

        INPUT CLOSE.
        INPUT FROM VALUE(inp_value).
        REPEAT:
            v_data = "".
            IMPORT UNFORMATTED v_data.
            i = i + 1.
            CREATE xxwk1.
            ASSIGN xxwk1_line = i
                   xxwk1_cmmt = v_data.
        END.
        INPUT CLOSE.

    DEFINE VAR h-a AS HANDLE.
    h-a = TEMP-TABLE xxwk1:HANDLE.
    RUN value(lc(global_user_lang) + "\yy\yyut2browse.p") (INPUT-OUTPUT TABLE-HANDLE h-a, 
                                         INPUT "yyedut002a", 
                                         INPUT "", 
                                         INPUT "",
                                         INPUT "日志内容" ,
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "").
