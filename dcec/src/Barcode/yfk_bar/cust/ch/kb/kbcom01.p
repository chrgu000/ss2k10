{mfdeclre.i}
{bcdeclre.i "new"}
{bcini.i}

DEFINE INPUT PARAMETER part AS CHARACTER.
DEFINE INPUT PARAMETER pqty AS DECIMAL.
DEFINE INPUT PARAMETER shft AS CHARACTER.

DEFINE OUTPUT PARAMETER sucess AS LOGICAL INITIAL FALSE.

DEFINE VARIABLE ifmatch AS LOGICAL INITIAL FALSE.

DEFINE VARIABLE active AS LOGICAL.  /*if barcode active*/

DEFINE VARIABLE bccode LIKE b_co_code LABEL "条码".
DEFINE VARIABLE ponbr LIKE po_nbr LABEL "采购单号".
DEFINE VARIABLE podline LIKE pod_line LABEL "项".
DEFINE VARIABLE bcpart LIKE pod_part LABEL "零件号".
DEFINE VARIABLE qty_ord LIKE pod_qty_ord LABEL "定单量".
DEFINE VARIABLE qty_rcvd LIKE pod_qty_rcvd LABEL "已收量".
DEFINE VARIABLE bcqty LIKE b_co_qty_cur LABEL "条码数量".
DEFINE VARIABLE bcsite LIKE b_co_site.
DEFINE VARIABLE bcloc LIKE b_co_loc.
DEFINE VARIABLE psite LIKE pod_site LABEL "地点".
DEFINE VARIABLE ploc LIKE pod_loc LABEL "库位".
DEFINE VARIABLE plot LIKE pod_lot_next LABEL "批号".
DEFINE VARIABLE bcstatus LIKE b_co_status LABEL "条码状态".


DEFINE FRAME bc
    SKIP(1)
    bccode COLON 15 SKIP(.3)
    bcpart COLON 15 bcqty COLON 45
    SKIP(2)
WITH WIDTH 80 SIDE-LABEL THREE-D.
DEFINE FRAME bd
SKIP(1)
    bcpart COLON 15 bcqty COLON 45
    SKIP(2)
WITH WIDTH 80 SIDE-LABEL THREE-D.

ON 'value-changed':U OF bccode
DO:
    ASSIGN bccode.
    bccode = TRIM(bccode).

    {gprun.i ""bccock.p""  "( INPUT bccode,
                                         OUTPUT active,
                                         OUTPUT bcpart,
                                         OUTPUT bcqty,
                                         OUTPUT bcsite,
                                         OUTPUT bcloc,
                                         OUTPUT plot,
                                         OUTPUT bcstatus )"}
    
    IF active NE YES THEN DO:
          STATUS INPUT "无法识别该条码".
          RETURN.
    END.
    ELSE DO:
        STATUS INPUT "条码可识别".
    END.

    FIND FIRST b_co_mstr WHERE b_co_code = bccode  NO-ERROR.
    IF AVAILABLE b_co_mstr THEN DO:
        IF b_co_status = "FINI-COMP" THEN DO:
            STATUS INPUT "该条码头已经完成点击,退出".
            RETURN.
        END.
        ELSE IF b_co_status NE "FINI-REL" THEN DO:
            STATUS INPUT "该条码状态不是已下达的,退出".
            RETURN.
        END.
    END.

    ifmatch = TRUE.
    IF bcpart NE part THEN DO: ifmatch = FALSE. STATUS INPUT "零件不匹配".
    END.
    IF bcqty NE pqty THEN DO: ifmatch = FALSE.  STATUS INPUT "数量不匹配".
    END.
    FIND FIRST b_wo_mstr NO-LOCK WHERE b_wo_shift = shft AND b_wo_part = bcpart NO-ERROR.
    IF NOT AVAILABLE b_wo_mstr THEN DO: ifmatch = FALSE.  STATUS INPUT "班次不匹配".
    END.

    IF ifmatch = FALSE THEN DO:
       /* STATUS INPUT  "条码扫描结果不符，退出重新点击".*/
        sucess = FALSE.
        RETURN.
    END.
    ELSE DO:
        bcpart:SCREEN-VALUE = bcpart.
        bcqty:SCREEN-VALUE = string(bcqty).
        {bcco001.i bccode bcpart bcqty """" """" """" """"}
        sucess = TRUE.
        {bcco002.i ""FINI-COMP""}
        FIND b_wod_det WHERE b_wod_code = bccode NO-ERROR.
        IF AVAILABLE b_wod_det THEN 
            ASSIGN b_wod_status = "FINI-COMP"
                         b_wod_fin_date = TODAY
                         b_wod_shp_nbr = STRING(TIME,"hh:mm:ss").
        RELEASE b_wod_det.

        STATUS INPUT "扫描结果匹配".
        APPLY "F2":U TO bccode.
        /*APPLY "ESC":U TO bccode.*/
        RETURN.
    END.

    RETURN.
END.
 
/*REPEAT:*/
    UPDATE bccode WITH FRAME bc.
/*END.*/


PAUSE 1.

