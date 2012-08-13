{mfdtitle.i}
{bcdeclre2.i NEW}
{bcini.i}
{bcwin.i}


DEFINE VARIABLE bccode LIKE b_co_code LABEL "条码".

DEFINE VARIABLE bcpart LIKE pod_part LABEL "零件号".
DEFINE VARIABLE bcqty LIKE b_co_qty_cur LABEL "条码数量".
DEFINE VARIABLE bcsite LIKE b_co_site LABEL "地点".
DEFINE VARIABLE bcloc LIKE b_co_loc LABEL "库位".
DEFINE VARIABLE bclot LIKE pod_lot_next LABEL "批号".
DEFINE VARIABLE bcstatus LIKE b_co_status LABEL "条码状态".

DEFINE VARIABLE batchid LIKE b_rct_batch.
/*buffer record id used to exec CIM */
DEFINE VARIABLE bfid AS INTEGER.  /*indicate the buffer id*/

DEFINE VARIABLE active AS LOGICAL.  /*if barcode active*/

DEFINE BUTTON btn_view LABEL "查看".
DEFINE BUTTON btn_rec LABEL "收货".
DEFINE BUTTON btn_quit LABEL "退出".

DEF FRAME a
    SKIP(1)
    "条码:" AT 1 SKIP
    bccode NO-LABEL AT 1 SKIP(.3) 
    bcpart COLON 8  SKIP(.3)
    bcqty COLON 8  SKIP(.3)
    bcsite COLON 8  SKIP(.3)
    bcloc COLON 8  SKIP(.3)
    bclot COLON 8  SKIP(.3)
    bcstatus COLON 8 SKIP(3)
     space(20)   btn_quit
WITH  WIDTH 30 TITLE "盘点扫描"  SIDE-LABELS  NO-UNDERLINE THREE-D.

ON 'value-changed':U OF bccode 
DO:
    ASSIGN bccode.
    {gprun.i ""bccock.p""  "( INPUT bccode,
                                          OUTPUT active,
                                          OUTPUT bcpart,
                                          OUTPUT bcqty,
                                          OUTPUT bcsite,
                                          OUTPUT bcloc,
                                          OUTPUT bclot,
                                          OUTPUT bcstatus )"}
    IF active =YES THEN DO:
        DISP bcpart  bcqty bcsite bcloc bclot bcstatus WITH FRAME a.
    END.
    ELSE DO:
        DISP "" @  bcpart "" @  bcqty "" @ bcsite "" @ bcloc "" @ bclot "" @ bcstatus WITH FRAME a.
        STATUS INPUT "无法识别该条码".
        RETURN.
    END.

    FIND FIRST b_cnt_wkfl NO-LOCK WHERE b_cnt_code = bccode NO-ERROR.
    IF AVAILABLE b_cnt_wkfl THEN DO:
         STATUS INPUT "本次盘点已扫描过该条码".
        RETURN.
    END.

    CREATE b_cnt_wkfl.
    ASSIGN
        b_cnt_code = bccode
        b_cnt_part = bcpart
        b_cnt_qty_cnt = bcqty
        b_cnt_site = bcsite
        b_cnt_loc = bcloc
        b_cnt_lot = bclot
        b_cnt_status = bcstatus.

    STATUS INPUT "条码正确".
    APPLY KEYCODE("F2") TO bccode.

    RETURN.
END.

DISP bccode WITH FRAME a.
REPEAT:
   REPEAT:
       UPDATE bccode WITH FRAME a.
   END.
   UPDATE btn_quit WITH FRAME a.
END.
