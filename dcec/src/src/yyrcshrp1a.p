{mfdeclre.i} /*GUI moved to top.*/
{gplabel.i} /* EXTERNAL LABEL INCLUDE */


DEF INPUT PARAMETER inp_value AS CHAR.

DEF TEMP-TABLE ttt1 RCODE-INFORMATION
    FIELDS ttt1_recid     AS INTEGER LABEL "RECID" FORMAT ">>>>>>>>>9"
    FIELDS ttt1_shipper   AS CHAR LABEL "发货单"
    FIELDS ttt1_shipfr    AS CHAR LABEL "发货地点"
    FIELDS ttt1_shipto    AS CHAR   LABEL "货物发往"
    FIELDS ttt1_date      AS DATE   LABEL "日期"
    FIELDS ttt1_container AS CHAR LABEL "集装箱" FORMAT "x(20)"
    FIELDS ttt1_box       AS CHAR LABEL "箱子"
    FIELDS ttt1_loc       LIKE pt_loc
    FIELDS ttt1_part      LIKE pt_part
    FIELDS ttt1_desc      LIKE pt_desc1
    FIELDS ttt1_qty       LIKE sod_qty_ord LABEL "数量"
    FIELDS ttt1_um        LIKE pt_um
    FIELDS ttt1_partnwet  LIKE pt_net_wt    LABEL "零件净重"
    FIELDS ttt1_wetum     LIKE pt_net_wt_um
    FIELDS ttt1_boxnwet   LIKE pt_net_wt    LABEL "箱子净重"
    FIELDS ttt1_boxgwet   LIKE pt_ship_wt   LABEL "箱子毛重"
    FIELDS ttt1_ponbr     LIKE po_nbr       LABEL "客户采购单"
    FIELDS ttt1_sonbr     LIKE so_nbr       LABEL "销售订单"
    FIELDS ttt1_soline    LIKE sod_line
    .


DEF VAR v-key AS CHAR EXTENT 5.
DEF VAR h-a AS HANDLE.
FOR EACH ttt1: DELETE ttt1. END.
v-key = "".

FIND FIRST ABS_mstr WHERE RECID(ABS_mstr) = INTEGER(inp_value) NO-LOCK NO-ERROR.
IF AVAILABLE ABS_mstr THEN ASSIGN
    v-key[1] = ABS_type
    v-key[2] = ABS_id
    v-key[3] = ABS_shipfrom
    v-key[4] = ABS_shipto
    v-key[5] = STRING(ABS_shp_date).


DEF BUFFER bbabs_mstr FOR ABS_mstr.
FOR EACH bbABS_mstr WHERE bbABS_mstr.abs_shipfrom = v-key[3]
        AND bbABS_mstr.ABS_par_id = v-key[2]
        AND bbABS_mstr.abs_type = v-key[1]
        AND bbABS_mstr.ABS_id BEGINS 'C'
        NO-LOCK:
        FOR EACH abs_mstr WHERE abs_mstr.ABS_shipfrom = bbabs_mstr.ABS_shipfrom
            AND abs_mstr.ABS_par_id = bbabs_mstr.abs_id
            AND ABS_mstr.abs_type = v-key[1]
            AND ABS_mstr.ABS_id BEGINS 'I'
            NO-LOCK:


            CREATE ttt1.
            ASSIGN 
                ttt1_recid     = RECID(ABS_mstr)
                ttt1_shipper   = substring(v-key[2],2)
                ttt1_shipfr    = v-key[3]
                ttt1_shipto    = v-key[4]
                ttt1_date      = DATE(v-key[5])
                ttt1_container = bbabs_mstr.ABS_user2
                ttt1_box       = substring(bbabs_mstr.ABS_id,2)
                ttt1_part      = abs_mstr.ABS_item
                ttt1_um        = ""
                ttt1_sonbr     = abs_mstr.ABS_order
                ttt1_soline    = INTEGER(ABS_line)
                ttt1_partnwet  = abs_mstr.ABS_nwt
                ttt1_wetum     = abs_mstr.ABS_wt_um
                ttt1_qty       = abs_mstr.ABS_qty
                ttt1_loc       = ABS_mstr.ABS_loc
                ttt1_boxnwet   = bbabs_mstr.ABS_nwt
                ttt1_boxgwet   = bbabs_mstr.ABS_gwt
                .
            FIND FIRST pt_mstr WHERE pt_part = ttt1_part NO-LOCK NO-ERROR.
            IF AVAILABLE pt_mstr THEN 
                ASSIGN ttt1_desc = pt_desc1 + pt_desc2
                       ttt1_um   = pt_um.
        END.
END.


h-a = TEMP-TABLE ttt1:HANDLE.
RUN value(lc(global_user_lang) + "\yy\yyut2browse.p") (INPUT-OUTPUT TABLE-HANDLE h-a, 
                                         INPUT "xxrcshrp1a", 
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
