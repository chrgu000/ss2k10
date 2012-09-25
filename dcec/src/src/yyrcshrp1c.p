{mfdeclre.i} /*GUI moved to top.*/
{gplabel.i} /* EXTERNAL LABEL INCLUDE */


DEF INPUT PARAMETER inp_value AS CHAR.

DEF TEMP-TABLE ttt1 RCODE-INFORMATION
    FIELDS ttt1_recid     AS integer LABEL "RECID"   FORMAT ">>>>>>>>>9"
    FIELDS ttt1_shipper   AS CHAR LABEL "发货单"
    FIELDS ttt1_container AS CHAR LABEL "集装箱" FORMAT "x(20)"
    FIELDS ttt1_box       AS CHAR LABEL "箱子"
    FIELDS ttt1_loc       LIKE pt_loc
    FIELDS ttt1_part      LIKE pt_part
    FIELDS ttt1_desc      LIKE pt_desc1
    FIELDS ttt1_qty       LIKE sod_qty_ord LABEL "数量"
    FIELDS ttt1_um        LIKE pt_um
    FIELDS ttt1_nwet      LIKE pt_net_wt
    FIELDS ttt1_nwetum    LIKE pt_net_wt_um
    FIELDS ttt1_sonbr     LIKE so_nbr
    FIELDS ttt1_soline    LIKE sod_line.


DEF VAR v-key AS CHAR EXTENT 5.
DEF VAR h-a AS HANDLE.
FOR EACH ttt1: DELETE ttt1. END.
v-key = "".

FIND FIRST ABS_mstr WHERE RECID(ABS_mstr) = INTEGER(inp_value) NO-LOCK NO-ERROR.
IF AVAILABLE ABS_mstr THEN ASSIGN
    v-key[1] = ABS_type
    v-key[2] = ABS_id
    v-key[3] = substring(ABS_par,2)
    v-key[4] = ABS_user2.

FOR EACH ABS_mstr WHERE ABS_type = v-key[1] AND ABS_par = v-key[2] AND abs_id BEGINS "i" NO-LOCK:
    CREATE ttt1.
    ASSIGN 
        ttt1_recid     = RECID(ABS_mstr)
        ttt1_shipper   = ""
        ttt1_container = v-key[4]
        ttt1_box       = v-key[3]
        ttt1_part      = ABS_item
        ttt1_um        = ""
        ttt1_sonbr     = ABS_order
        ttt1_soline    = INTEGER(ABS_line)
        ttt1_nwet      = ABS_nwt
        ttt1_nwetum   = ABS_wt_um
        ttt1_qty       = ABS_qty
        .
    FIND FIRST pt_mstr WHERE pt_part = ttt1_part NO-LOCK NO-ERROR.
    IF AVAILABLE pt_mstr THEN 
        ASSIGN ttt1_desc = pt_desc1 + pt_desc2
               ttt1_um   = pt_um.
END.

h-a = TEMP-TABLE ttt1:HANDLE.
RUN value(lc(global_user_lang) + "\yy\yyut2browse.p") (INPUT-OUTPUT TABLE-HANDLE h-a, 
                                         INPUT "xxrcshrp1c", 
                                         INPUT "", 
                                         INPUT "",
                                         INPUT "发货装箱单明细" ,
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "").
