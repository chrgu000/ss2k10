{mfdeclre.i} /*GUI moved to top.*/
{gplabel.i} /* EXTERNAL LABEL INCLUDE */


DEF INPUT PARAMETER inp_value AS CHAR.

DEF TEMP-TABLE ttt1 RCODE-INFORMATION
    FIELDS ttt1_recid     AS INTEGER LABEL "RECID" FORMAT ">>>>>>>>>9"
    FIELDS ttt1_shipper   AS CHAR LABEL "发货单"
    FIELDS ttt1_container AS CHAR LABEL "集装箱" FORMAT "x(20)"
    FIELDS ttt1_box       AS CHAR LABEL "箱子"
    FIELDS ttt1_boxnwet   LIKE pt_net_wt LABEL "净重"
    FIELDS ttt1_boxgwet   LIKE pt_net_wt LABEL "毛重"
    FIELDS ttt1_wetum     LIKE pt_net_wt_um
    FIELDS ttt1_boxdim    AS CHAR FORMAT "x(20)" LABEL "尺寸"
    FIELDS ttt1_boxdimum  LIKE pt_net_wt_um.

DEF VAR v-key AS CHAR EXTENT 5.
DEF VAR h-a AS HANDLE.
FOR EACH ttt1: DELETE ttt1. END.
v-key = "".

FIND FIRST ABS_mstr WHERE RECID(ABS_mstr) = INTEGER(inp_value) NO-LOCK NO-ERROR.
IF AVAILABLE ABS_mstr THEN DO:
    ASSIGN
        v-key[1] = ABS_type
        v-key[2] = substring(ABS_id,1).
END.

FOR EACH ABS_mstr WHERE ABS_type = v-key[1] AND ABS_par = v-key[2] AND abs_id BEGINS "C" NO-LOCK:
    CREATE ttt1.
    ASSIGN 
        ttt1_recid     = RECID(ABS_mstr)
        ttt1_shipper   = substring(ABS_par,2)
        ttt1_container = ABS_user2
        ttt1_box       = substring(ABS_id,2)
        ttt1_boxnwet   = ABS_nwt
        ttt1_boxgwet   = ABS_gwt
        ttt1_wetum    = ABS_wt_um
        ttt1_boxdim    = ABS_user1
        ttt1_boxdimum  = ABS_dim_um
        .
END.

h-a = TEMP-TABLE ttt1:HANDLE.
RUN value(lc(global_user_lang) + "\yy\yyut2browse.p") (INPUT-OUTPUT TABLE-HANDLE h-a, 
                                         INPUT "xxrcshrp1b", 
                                         INPUT "", 
                                         INPUT "",
                                         INPUT "发货装箱单明细" ,
                                         INPUT "ttt1_recid",
                                         INPUT "yyrcshrp1c.p",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "").
