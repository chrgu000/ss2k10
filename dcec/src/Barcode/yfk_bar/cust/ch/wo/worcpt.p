{mfdtitle.i}
{bcdeclre.i NEW}
{bcini.i}
{bcwin.i}


DEFINE VARIABLE bccode LIKE b_co_code LABEL "条码".
DEFINE VARIABLE wonbr LIKE po_nbr LABEL "加工单号".
DEFINE VARIABLE bcpart LIKE pod_part LABEL "零件号".
DEFINE VARIABLE bcqty LIKE b_co_qty_cur LABEL "条码数量".
DEFINE VARIABLE bcsite LIKE b_co_site LABEL "地点".
DEFINE VARIABLE bcloc LIKE b_co_loc.
DEFINE VARIABLE psite LIKE pod_site LABEL "地点".
DEFINE VARIABLE ploc LIKE pod_loc LABEL "入库库位".
DEFINE VARIABLE plot LIKE pod_lot_next LABEL "入库批号".
DEFINE VARIABLE bcstatus LIKE b_co_status LABEL "条码状态".

DEFINE VARIABLE prodline AS CHARACTER LABEL "生产线".

DEFINE NEW SHARED VARIABLE batchid LIKE b_rct_batch.
/*buffer record id used to exec CIM */
DEFINE VARIABLE bfid AS INTEGER.  /*indicate the buffer id*/

DEFINE VARIABLE active AS LOGICAL.  /*if barcode active*/

DEFINE BUTTON btn_view LABEL "查看".
DEFINE BUTTON btn_rec LABEL "回冲".
DEFINE BUTTON btn_quit LABEL "退出".

DEF FRAME a
    SKIP(1)
    "条码:" AT 1 SKIP
    bccode NO-LABEL AT 1 SKIP(.3) 
    bcpart COLON 8  SKIP(.3)
    bcqty COLON 8  SKIP(.3)
    bcsite COLON 8  SKIP(.3)
    ploc COLON 8  SKIP(.3)
    plot COLON 8  SKIP(.3)
    SKIP(3.5)
     space(24) btn_view
WITH  WIDTH 30 TITLE "成品入库"  SIDE-LABELS  NO-UNDERLINE THREE-D.

ON 'value-changed':U OF bccode
DO:
    ASSIGN bccode.
    {gprun.i ""bccock.p""  "( INPUT bccode,
                                          OUTPUT active,
                                          OUTPUT bcpart,
                                          OUTPUT bcqty,
                                          OUTPUT bcsite,
                                          OUTPUT ploc,
                                          OUTPUT plot,
                                          OUTPUT bcstatus )"}
    IF active =YES THEN DO:
        DISP bcpart  bcqty plot WITH FRAME a.
    END.
    ELSE DO:
        DISP "" @ bcpart  "" @ bcqty "" @ plot WITH FRAME a.
        STATUS INPUT "无法识别该条码".
    END.


    ASSIGN bccode
        bcpart
        bcqty
        bcsite
        ploc
        plot.
    IF /*plot = "" OR ploc = "" OR bcsite = "" OR*/ bcqty = 0
        THEN DO:
        STATUS INPUT "资料不完整，不能执行,现在退出".
        RETURN.
    END.

    IF (bcstatus NE "FINI-COMP") AND (bcstatus NE "REWORK") THEN DO:
        STATUS INPUT "该条码必须状态为已完成下线点击的或者是返修入库的，现在退出".
        RETURN.
    END.

    FIND FIRST pt_mstr NO-LOCK WHERE pt_part = bcpart NO-ERROR.
    IF AVAILABLE pt_mstr THEN DO:
        IF pt_status = "e" THEN DO:
            STATUS INPUT "发现该零件状态未开通,退出".
            RETURN.
        END.
    END.

    FIND FIRST b_wod_det NO-LOCK WHERE b_wod_code = bccode NO-ERROR.
    IF AVAILABLE b_wod_det THEN DO:
        prodline = b_wod_line.
    END.
    ELSE DO:
        /*如果在生产计划中找不到,那么是来自导入的条码资料*/
        FIND FIRST xwo_srt WHERE xwo_lot = bccode AND xwo_part = bcpart NO-ERROR.
        IF AVAILABLE xwo_srt THEN DO:
            prodline = xwo_lnr.
        END.
        ELSE DO:
            STATUS INPUT "在导入的资料中无法发现生产线,退出".
            RETURN.
        END.
    END.

    FIND FIRST xgpl_ctrl NO-LOCK WHERE xgpl_lnr = prodline NO-ERROR.
    IF AVAILABLE xgpl_ctrl THEN DO:
        bcsite = xgpl_site.
        bcloc = xgpl_loc.
    END.
    ELSE DO:
        STATUS INPUT "在29.16.24没有维护相关生产线记录,无法取得回冲地点,推出".
        RETURN.
    END.

    bcsite = "1000".

    DISP bcpart bcsite bcqty WITH FRAME a.

    FIND FIRST b_fin_wkfl NO-LOCK WHERE b_fin_code = bccode  NO-ERROR.
    IF AVAILABLE b_fin_wkfl THEN DO:
        STATUS INPUT "本次已经扫描过该条码,退出".
        RETURN.
    END.


    FIND FIRST b_wis_wkfl NO-LOCK WHERE b_wis_code = bccode  NO-ERROR.
    IF AVAILABLE b_wis_wkfl THEN DO:
        STATUS INPUT "该条码已经在回冲清单中,退出".
        RETURN.
    END.
    

    CREATE b_fin_wkfl.
    ASSIGN b_fin_batch = batchid
            b_fin_part = bcpart
            b_fin_code = bccode
            b_fin_qty = bcqty
            b_fin_site = bcsite
            b_fin_loc = bcloc
            b_fin_lot = plot
            b_fin_status = ""
            b_fin_bkdate = TODAY
            b_fin_emp = ""
            b_fin_line = ""
            b_fin_op = ?
            b_fin_source = bcstatus.
        
    STATUS INPUT "条码正确".
    APPLY KEYCODE("F2") TO bccode.
    

    RETURN.
END.


ON 'choose':U OF btn_view
DO:
    {gprun.i ""worcpt01.p""}
    RETURN.
END.

SELECT MAX(b_fin_batch) INTO batchid FROM b_fin_wkfl.
IF batchid = ? THEN batchid = 1. ELSE batchid = batchid + 1.

DEFINE VARIABLE b LIKE b_fin_part.
REPEAT:
    ENABLE bccode WITH FRAME a.
    READKEY.
    IF LASTKEY = KEYCODE("ESC")  THEN DO:
        SELECT MAX(b_fin_part) INTO b FROM  b_fin_wkfl WHERE b_fin_batch = batchid AND b_fin_status = "".
        IF b NE ? THEN DO:
            STATUS INPUT "操作未完成，必须确认后退出".
        END.
        ELSE DO:
            LEAVE.
        END.
    END.
    UPDATE bccode WITH FRAME a.
    REPEAT:
         UPDATE bccode WITH FRAME a.
    END.
    UPDATE btn_view WITH FRAME a.
        
END.
/*       
{BCTRAIL1.I}*/



