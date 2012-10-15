{mfdeclre.i} /*GUI moved to top.*/
{gplabel.i} /* EXTERNAL LABEL INCLUDE */


DEF INPUT PARAMETER inp_value AS CHAR.


DEF SHARED TEMP-TABLE xxwk1 RCODE-INFORMATION
    FIELDS xxwk1_ref      LIKE glt_ref
    FIELDS xxwk1_line     LIKE glt_line
    FIELDS xxwk1_acct     LIKE glt_acct
    FIELDS xxwk1_sub      LIKE glt_sub
    FIELDS xxwk1_cc       LIKE glt_cc
    FIELDS xxwk1_pj       LIKE glt_proj
    FIELDS xxwk1_amt      LIKE glt_amt
    FIELDS xxwk1_desc     LIKE glt_desc
    FIELDS xxwk1_doc      LIKE glt_doc
    fields xxwk1_date     like gltr_eff_dt
    FIELDS xxwk1_part     LIKE pt_part
    FIELDS xxwk1_type     AS   CHARACTER  LABEL "类型"
    INDEX xxwk1_idx1 xxwk1_acct xxwk1_sub xxwk1_cc
    INDEX xxwk1_idx2 xxwk1_part.

DEF SHARED TEMP-TABLE xxwk2 RCODE-INFORMATION
    FIELDS xxwk2_part     LIKE pt_part
    FIELDS xxwk2_desc     LIKE pt_desc1
    FIELDS xxwk2_amt0     LIKE glt_amt LABEL "总差异"
    FIELDS xxwk2_amt1     LIKE glt_amt LABEL "量差"
    FIELDS xxwk2_amt2     LIKE glt_amt LABEL "率差"
    FIELDS xxwk2_amt3     LIKE glt_amt LABEL "方法差"
    FIELDS xxwk2_amt4     LIKE glt_amt LABEL "其他"
    FIELDS xxwk2_amt5     LIKE glt_amt LABEL "调整"
    INDEX xxwk2_idx1 xxwk2_part.

DEF TEMP-TABLE xxwk3 LIKE xxwk1 RCODE-INFORMATION .

FOR EACH xxwk3:
    DELETE xxwk3.
END.

FOR EACH xxwk1 NO-LOCK WHERE xxwk1_part = inp_value:
    CREATE xxwk3.
    BUFFER-COPY xxwk1 TO xxwk3.
END.

PROCEDURE xxpro-report:
    DEF VAR h-tt AS HANDLE.
    h-tt = TEMP-TABLE xxwk3:HANDLE.

    RUN value(lc(global_user_lang) + "\yy\yyut2browse.p") (INPUT-OUTPUT TABLE-HANDLE h-tt,
                                         INPUT "yyacctvarrp2a", 
                                         INPUT "", 
                                         INPUT "",
                                         INPUT "差异明细",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "").

END PROCEDURE.
