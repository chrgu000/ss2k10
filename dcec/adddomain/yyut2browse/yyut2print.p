/*output temptable to excel*/

DEFINE INPUT PARAMETER TABLE-HANDLE hTempTable.
DEFINE INPUT PARAMETER inp_where AS CHAR.
DEFINE INPUT PARAMETER inp_sortby AS CHAR.
DEFINE INPUT PARAMETER inp_list   AS CHAR.
DEFINE INPUT PARAMETER inp_rpttitle AS CHAR.

DEFINE VARIABLE bh AS HANDLE NO-UNDO.
DEFINE VARIABLE bf AS HANDLE NO-UNDO.
DEFINE VARIABLE hq AS HANDLE NO-UNDO.
DEFINE VARIABLE iCounter AS INTEGER NO-UNDO.
DEFINE VARIABLE i AS INTEGER.
DEFINE VARIABLE qrString AS CHARACTER FORMAT "x(256)" NO-UNDO.

/***************Define needed variables************/
DEFINE VARIABLE v_label        AS CHAR.
DEFINE VARIABLE v_format       AS CHAR.
DEFINE VARIABLE v_type         AS CHAR.
DEFINE VARIABLE v_datax        AS CHAR.


DEF VAR v_ok         AS LOGICAL.

DEFINE TEMP-TABLE xxformat1
    FIELDS xxformat1_column     AS INTEGER 
    FIELDS xxformat1_type       AS CHAR    INITIAL ""
    FIELDS xxformat1_format     AS CHAR
    FIELDS xxformat1_left       AS LOGICAL INITIAL YES
    FIELDS xxformat1_labeldat   AS CHAR INITIAL ""      
    FIELDS xxformat1_newformat  AS CHAR
    FIELDS xxformat1_length     AS INTEGER INITIAL 1
    FIELDS xxformat1_from       AS INTEGER
    FIELDS xxformat1_to         AS INTEGER
    INDEX xxformat1_idx1 xxformat1_column.


{mfdeclre.i} /*GUI moved to top.*/
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
                                                 



IF hTempTable = ? THEN RETURN.

FORM WITH FRAME a.

{yyut2guirpa.i false "printer" 132 " " " " " "  }

RUN p-report.

/*************************/
procedure xxpro-get-newformat:
    DEFINE INPUT        PARAMETER p_type   AS CHAR.
    DEFINE INPUT        PARAMETER p_format AS CHAR.
    define input        parameter p_oldlen as integer.
    define output       parameter p_newlen as integer.
    define output       parameter p_newfor as char.
    
    p_newlen = 1.
    if p_type = "CHARACTER" then do:
        IF INDEX(p_format,"(") = 0 then p_newlen = LENGTH(p_format,"RAW").
        else p_newlen = integer(substring(p_format, 
                                          INDEX(p_format,"(") + 1,
                                          INDEX(p_format,")" ) - INDEX(p_format,"(" ) - 1
                                          )).
    end.
    else do:
        p_newlen = LENGTH(p_format,"RAW").
    end.
    p_newlen = max(p_newlen, p_oldlen).
    if p_newlen = 0 then p_newlen = 1.
    p_newfor = "x(" + string(p_newlen) + ")".
end procedure.
/*************************/
PROCEDURE xxpro-newdata:
    DEFINE INPUT-OUTPUT PARAMETER p_data AS CHAR.
    DEFINE INPUT        PARAMETER p_length   AS INTEGER.
    DEF VAR v_space     AS CHAR.
    DEF VAR v_spacelength AS INTEGER.

    v_space = "".
    v_spacelength = p_length - LENGTH(p_data, "raw").
    IF v_spacelength > 0 THEN DO:
        v_space = FILL(" ", v_spacelength).
        ASSIGN p_data = v_space + p_data.
    END.
END PROCEDURE.


PROCEDURE p-report:
    DEFINE VAR v_pos AS INTEGER.

     {gpprtrpa.i "printer" 132 " " " " " " " " }

     bh = hTempTable:DEFAULT-BUFFER-HANDLE.

     qrString = "FOR EACH " + hTempTable:NAME + " " + inp_where + " " + inp_sortby.
     CREATE QUERY hq.
     hq:SET-BUFFERS(bh).
     hq:QUERY-PREPARE(qrstring).
     hq:QUERY-OPEN.

     IF GLOBAL_user_lang = "CH" THEN inp_rpttitle = "±¨±í:" + inp_rpttitle.
     ELSE inp_rpttitle = "Report:" + inp_rpttitle.
     PUT SKIP.
     PUT UNFORMATTED inp_rpttitle SKIP.
     /*PUT UNFORMATTED FILL("=", 132) SKIP.*/
     PUT " " SKIP.
     v_pos = 1.
     DO iCounter = 1 TO bh:NUM-FIELDS:
         bf = bh:BUFFER-FIELD(iCounter).
         IF LOOKUP(STRING(icounter), inp_list) <> 0 THEN DO:
             v_label = bf:LABEL.
             v_label = gettermlabel(v_label,20).
             v_format = bf:FORMAT.
             v_type   = bf:DATA-TYPE.
             
             CREATE xxformat1.
             ASSIGN
                 xxformat1_column = icounter
                 xxformat1_type   = v_type
                 xxformat1_format = v_format  
                 xxformat1_labeldat = v_label
                 .
			 if xxformat1_type = "character" or 
                xxformat1_type = "date" or 
                xxformat1_type = "logical" 
             then xxformat1_left = yes. else xxformat1_left = no.
             
             run xxpro-get-newformat (input xxformat1_type,
                                      input xxformat1_format,
                                      input length(xxformat1_labeldat, "RAW"),
                                      output xxformat1_length,
                                      output xxformat1_newformat).
             xxformat1_from = v_pos.
             v_pos          = v_pos + xxformat1_length - 1.
             xxformat1_to   = v_pos.
             v_pos = v_pos + 2.
             
             v_format = xxformat1_newformat.
             v_datax  = trim(v_label).
             IF xxformat1_left = NO THEN RUN xxpro-newdata(INPUT-OUTPUT v_datax, xxformat1_length). 
             PUT v_datax FORMAT xxformat1_newformat at xxformat1_from.
         END.
     END.
     PUT SKIP.
     /*
     FOR EACH xxformat1:
         DISP xxformat1 WITH WIDTH 200 DOWN.
     END.*/
     PUT UNFORMATTED FILL("-", v_pos) SKIP.

     REPEAT:
         hq:GET-NEXT.
         IF hq:QUERY-OFF-END THEN LEAVE.
         DO iCounter = 1 TO bh:NUM-FIELDS:
             bf = bh:BUFFER-FIELD(iCounter).
             IF LOOKUP(STRING(icounter), inp_list) <> 0 THEN DO:
                 find first xxformat1 where xxformat1_column = iCounter no-lock no-error.
                 if available xxformat1 then do:
                     v_format = xxformat1_newformat.
                     v_datax  = trim(bf:BUFFER-VALUE).
                     IF xxformat1_left = NO THEN RUN xxpro-newdata(INPUT-OUTPUT v_datax, xxformat1_length). 
                     PUT v_datax FORMAT xxformat1_newformat at xxformat1_from.
                 end.
             end.
         END.
         PUT SKIP.
     END.
     PUT UNFORMATTED FILL("-", v_pos) SKIP.


     {mfreset.i}
     {mfgrptrm.i} /*Report-to-Window*/
END.
