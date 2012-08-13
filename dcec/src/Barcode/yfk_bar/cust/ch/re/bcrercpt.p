
{bcdeclre.i}
{bcini.i}
{bcwin.i}

DEFINE VARIABLE bccode LIKE b_co_code LABEL "条码".
DEFINE VARIABLE employee LIKE emp_addr LABEL "雇员".
DEFINE VARIABLE bfsite AS CHARACTER LABEL "地点".
DEFINE VARIABLE bfdate AS DATE LABEL "回冲日期".
DEFINE VARIABLE bfop LIKE ro_op LABEL "工序".
DEFINE VARIABLE bcpart LIKE pt_part LABEL "零件".
DEFINE VARIABLE bcqty LIKE b_co_qty_cur LABEL "数量".
DEFINE VARIABLE prodline AS CHARACTER LABEL "生产线".
DEFINE VARIABLE bcsite LIKE b_co_site.
DEFINE VARIABLE bcloc LIKE b_co_loc.
DEFINE VARIABLE bcstatus LIKE b_co_status.
DEFINE VARIABLE tosite LIKE pod_site LABEL "地点".
DEFINE VARIABLE toloc LIKE pod_loc LABEL "库位".

DEFINE BUTTON btn_quit LABEL "退出".
DEFINE BUTTON btn_exec LABEL "入库".
DEFINE BUTTON btn_view LABEL "查看".

DEFINE VARIABLE active AS LOGICAL.
DEFINE VARIABLE bclot LIKE b_co_lot. 
/*buffer record id used to exec CIM */
DEFINE VARIABLE bfid AS INTEGER.  /*indicate the buffer id*/
DEFINE NEW SHARED VARIABLE batchid LIKE b_shp_batch LABEL "批号".

DEFINE FRAME a
    SKIP(2)
    "条码:" AT 1 SKIP
    bccode NO-LABEL AT 1 SKIP(.3)
    employee COLON 8 SKIP(.3)
    bfsite COLON 8 SKIP(.3)
    bfdate COLON 8 SKIP(.3)
    bcpart COLON 8 SKIP(.3)
    bfop COLON 8 SKIP(.3)
    prodline COLON 8 SKIP(.3)
    bcqty COLON 8 SKIP(2)
    space(20)  SPACE(2) btn_view
    WITH  SIZE 30 BY 18 TITLE "成品入库"  SIDE-LABELS  NO-UNDERLINE THREE-D.


ON 'value-changed':U OF bccode
DO:
    ASSIGN bccode.
    bfdate = TODAY.
    DISPLAY bfdate WITH FRAME a.
    {bcrun.i ""bcbccock.p""  "( INPUT bccode,
                                          OUTPUT active,
                                          OUTPUT bcpart,
                                          OUTPUT bcqty,
                                          OUTPUT bcsite,
                                          OUTPUT bcloc,
                                          OUTPUT bclot,
                                          OUTPUT bcstatus )"}
    IF active =YES THEN DO:
        DISP bcpart  bcqty WITH FRAME a.
    END.
    ELSE DO:
        DISP "" @ bcpart  "" @ bcqty  WITH FRAME a.
        STATUS INPUT "无法识别该条码".
        RETURN.
    END.

    IF (bcstatus NE "FINI-COMP") AND (bcstatus NE "REWORK") THEN DO:
        STATUS INPUT "该条码必须状态为已完成下线点击的或者是返修入库的，现在退出".
        RETURN.
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
        bfsite = xgpl_site.
        toloc = xgpl_loc.
    END.
    ELSE DO:
        STATUS INPUT "在29.16.24没有维护相关生产线记录,无法取得回冲地点,推出".
        RETURN.
    END.

    bfsite = "1000".

    DISP bcpart bfsite prodline bcqty WITH FRAME a.

    

    /*FIND FIRST rps_mstr NO-LOCK WHERE rps_part = b_wod_part
        AND rps_line = b_wod_line  NO-ERROR.
    IF AVAILABLE rps_mstr THEN DO:
        bfsite = rps_site.
        DISP bfsite WITH FRAME a.
    END.
    ELSE DO:
        MESSAGE "在生产线为" + prodline + "重复生产日程中无法找到相应记录，现在退出" VIEW-AS ALERT-BOX.
        RETURN.
    END.
    */
    /*本来是要检验日程单是否存在,但YFK似乎没有日程一样可以做回冲,所以驱除本段代码*/


    FIND FIRST ro_det NO-LOCK WHERE ro_routing = bcpart NO-ERROR.
    IF AVAILABLE ro_det THEN DO:
        DEFINE VARIABLE i AS INTEGER.
        SELECT MAX(ro_op) INTO i FROM ro_det WHERE ro_routing = bcpart.
        bfop = i.
        DISP bfop WITH FRAME a.
    END.
    ELSE DO:
        STATUS INPUT "在重复生产日程中记录的ROUTING号码无法找到相应工序，现在退出".
        RETURN.
    END.

    IF bcstatus = "REWORK" THEN STATUS INPUT "返修件入库".

    ASSIGN employee
        bfsite
        bfdate
        bcpart
        bfop
        prodline
        bcqty.
                             
    IF employee = "" OR bfsite = "" OR bcpart = ""
        OR bfop = 0 OR prodline = "" OR bcqty = 0 THEN DO:
        STATUS INPUT "资料不完整,退出".
        RETURN.
    END.

    FIND FIRST b_fin_wkfl NO-LOCK WHERE b_fin_batch = batchid AND b_fin_code = bccode NO-ERROR.
    IF AVAILABLE b_fin_wkfl THEN DO:
        STATUS INPUT "该条码已经添加,不能重复操作,退出".
        RETURN.
    END.

    CREATE b_fin_wkfl.
    ASSIGN b_fin_batch = batchid
        b_fin_part = bcpart
        b_fin_code = bccode
        b_fin_qty = bcqty
        b_fin_site = bfsite
        b_fin_loc = bcloc
        b_fin_lot = bclot
        b_fin_status = ""
        b_fin_bkdate = bfdate
        b_fin_emp = employee
        b_fin_line = prodline
        b_fin_op = bfop
        b_fin_source = bcstatus.

    APPLY KEYCODE("F2") TO bccode.
    STATUS INPUT "条码正确".

    RETURN.
END.


ON 'choose':U OF btn_view
DO:
    {bcrun.i ""bcrercpt01.p""}
    RETURN.
END.



FIND FIRST emp_mstr NO-LOCK NO-ERROR.
    IF NOT AVAILABLE emp_mstr THEN DO:
        MESSAGE employee:SCREEN-VALUE + "不存在" VIEW-AS ALERT-BOX.
        RETURN.
    END.
    ELSE DO:
        employee:SCREEN-VALUE = emp_addr.
    END.
employee = "NORM".

SELECT MAX(b_fin_batch) INTO batchid FROM b_fin_wkfl.
IF batchid = ? THEN batchid = 1. ELSE batchid = batchid + 1.

REPEAT:
    UPDATE employee WITH FRAME a.
    REPEAT:
        UPDATE bccode WITH FRAME a.
    END.
        UPDATE btn_view WITH FRAME a.
END.

{bctrail1.i}





