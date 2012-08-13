{mfdtitle.i}
{bcdeclre2.i NEW}
{bcini.i}
{bcwin.i}

DEFINE VARIABLE bccode LIKE b_co_code LABEL "条码".
DEFINE VARIABLE bcpart LIKE b_co_part LABEL "零件号".
DEFINE VARIABLE bcdpart LIKE pod_part LABEL "零件号".
DEFINE VARIABLE bcqty LIKE b_co_qty_cur LABEL "条码数量".
DEFINE VARIABLE bcsite LIKE pod_site LABEL "地点".
DEFINE VARIABLE bcloc LIKE pod_loc LABEL "库位".
DEFINE VARIABLE bclot LIKE pod_lot_next LABEL "批号".
DEFINE VARIABLE bcstatus LIKE b_co_status LABEL "条码状态".

DEFINE VARIABLE accode LIKE ac_code LABEL "帐号".
DEFINE VARIABLE sbsub LIKE sb_sub LABEL "分帐号".
DEFINE VARIABLE ccctr LIKE cc_ctr LABEL "成本中心".
DEFINE VARIABLE pjproject LIKE pj_project LABEL "项目".

/*buffer record id used to exec CIM */
DEFINE VARIABLE bfid AS INTEGER.  /*indicate the buffer id*/
DEFINE VARIABLE active AS LOGICAL.  /*if barcode active*/

DEFINE BUTTON btn_iss LABEL "出库".
DEFINE BUTTON btn_quit LABEL "退出".

DEF FRAME a
    SKIP(1)
    "条码:" AT 1 SKIP
    bccode NO-LABEL AT 1 SKIP(.3) 
    bcpart COLON 8 SKIP(.3) 
    bcqty COLON 8  SKIP(.3)
    bcsite COLON 8  SKIP(.3)
    bcloc COLON 8  SKIP(.3)
    bclot COLON 8  SKIP(.3)
    bcstatus COLON 8 SKIP(2)
    btn_quit AT 24
WITH  WIDTH 30 TITLE "条码状态查看"  SIDE-LABELS  NO-UNDERLINE THREE-D.

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
        DISP bcpart  bcqty bcsite bcloc  bclot bcstatus WITH FRAME a.
    END.
    ELSE DO:
        DISP "" @ bcpart  "" @ bcqty  "" @ bcsite  "" @ bcloc "" @ bclot WITH FRAME a.
        STATUS INPUT "无法识别该条码".
        RETURN.
    END.
    APPLY "F2":U TO bccode.
    RETURN.
END.
    

DISP bccode WITH FRAME a.
REPEAT:
    REPEAT:
            UPDATE bccode WITH FRAME a.
    END.
    UPDATE btn_quit WITH FRAME a.
END.
