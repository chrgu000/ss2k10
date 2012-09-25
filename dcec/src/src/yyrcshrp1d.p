{mfdeclre.i} /*GUI moved to top.*/
{gplabel.i} /* EXTERNAL LABEL INCLUDE */


DEF INPUT PARAMETER inp_value AS CHAR.

DEF TEMP-TABLE ttt1 RCODE-INFORMATION
    FIELDS ttt1_shipper   AS CHAR LABEL "发货单"
    FIELDS ttt1_shipfr    AS CHAR LABEL "发货地点"
    FIELDS ttt1_shipto    AS CHAR   LABEL "货物发往"
    FIELDS ttt1_date      AS DATE   LABEL "日期"
    FIELDS ttt1_sonbr     LIKE so_nbr       LABEL "销售订单"
    FIELDS ttt1_soline    LIKE sod_line
    FIELDS ttt1_part      LIKE pt_part
    FIELDS ttt1_desc      LIKE pt_desc1
    FIELDS ttt1_qty       LIKE tr_qty_loc LABEL "数量"
    .


DEF VAR v-key AS CHAR EXTENT 10.
DEF VAR h-a AS HANDLE.
FOR EACH ttt1: DELETE ttt1. END.
v-key = "".

FIND FIRST ABS_mstr WHERE RECID(ABS_mstr) = INTEGER(inp_value) NO-LOCK NO-ERROR.
IF NOT AVAILABLE ABS_mstr THEN LEAVE.

ASSIGN
    v-key[1] = "SHIPPER-" + substring(ABS_id,2)
    v-key[2] = substring(ABS_id,2)
    v-key[3] = ABS_shipfrom
    v-key[4] = ABS_shipto
    v-key[5] = STRING(ABS_shp_date).


FOR EACH usrw_wkfl NO-LOCK
    WHERE usrw_key1 = v-key[1]:
    CREATE ttt1.
    ASSIGN
        ttt1_shipper = substring(ABS_id,2)
        ttt1_shipfr  = ABS_shipfrom
        ttt1_shipto  = ABS_shipto
        ttt1_date    = ABS_shp_date
        ttt1_sonbr   = usrw_key5
        ttt1_soline  = INTEGER(usrw_key6)
        ttt1_part    = usrw_key3
        ttt1_desc    = usrw_charfld[1]
        ttt1_qty     = usrw_decfld[1]
        .
END.

h-a = TEMP-TABLE ttt1:HANDLE.
RUN value(lc(global_user_lang) + "\yy\yyut2browse.p") (INPUT-OUTPUT TABLE-HANDLE h-a, 
                                         INPUT "yyrcshrp1d", 
                                         INPUT "", 
                                         INPUT "",
                                         INPUT "发货计划" ,
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "").
