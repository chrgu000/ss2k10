{mfdtitle.i}
{bcdeclre.i NEW}
{bcini.i}
{bcwin.i}

DEFINE VARIABLE bccode LIKE b_co_code LABEL "条码".
DEFINE VARIABLE sonbr LIKE po_nbr LABEL "订单号".
DEFINE VARIABLE sodline LIKE sod_line LABEL "项".
DEFINE VARIABLE cust LIKE so_ship.
DEFINE VARIABLE bcpart LIKE sod_part LABEL "零件号".
DEFINE VARIABLE qty_ord LIKE pod_qty_ord LABEL "定单量".
DEFINE VARIABLE qty_shipped LIKE pod_qty_rcvd LABEL "已收量".
DEFINE VARIABLE bcqty LIKE b_co_qty_cur LABEL "条码数量".
DEFINE VARIABLE bcsite LIKE b_co_site LABEL "地点".
DEFINE VARIABLE bcloc LIKE b_co_loc  LABEL "库位".
DEFINE VARIABLE bclot LIKE b_co_lot  LABEL "批号".
DEFINE VARIABLE psite LIKE pod_site LABEL "地点".
DEFINE VARIABLE ploc LIKE pod_loc LABEL "库位".
DEFINE VARIABLE plot LIKE pod_lot_next LABEL "批号".
DEFINE VARIABLE bcstatus LIKE b_co_status LABEL "条码状态".

DEFINE TEMP-TABLE cl_mstr 
    FIELD cl_part LIKE pt_part
    FIELD cl_loc LIKE ld_loc
    FIELD cl_site LIKE ld_site
    FIELD cl_lot LIKE ld_lot
    FIELD cl_ld_qty LIKE ld_qty_oh
    FIELD cl_co_qty LIKE ld_qty_oh.

DEFINE NEW SHARED VARIABLE batchid LIKE b_rct_batch.
/*buffer record id used to exec CIM */
DEFINE VARIABLE bfid AS INTEGER.  /*indicate the buffer id*/

DEFINE VARIABLE active AS LOGICAL.  /*if barcode active*/

DEFINE BUTTON btn_view LABEL "查看".
DEFINE BUTTON btn_rec LABEL "收货".
DEFINE BUTTON btn_quit LABEL "退出".
DEFINE BUTTON btn_add LABEL "添加".

DEF FRAME a
    SKIP(1)
    bccode  COLON 4 SKIP(.3) 
    bcpart COLON 8  SKIP(.3)
    bcqty COLON 8  SKIP(.3)
    bcsite COLON 8  SKIP(.3)
    bcloc COLON 8  SKIP(.3)
    bclot COLON 8  SKIP(.3)
    psite COLON 8  SKIP(.3)
    ploc COLON 8  SKIP(.3)
     space(20) space(1) btn_view
WITH  WIDTH 30 TITLE "非销售移库"  SIDE-LABELS  NO-UNDERLINE THREE-D.

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
        DISP bcpart  bcqty bclot bcsite bcloc bclot WITH FRAME a.
    END.
    ELSE DO:
        DISP "" @ bcpart  "" @ bcqty "" @ bclot "" @ bcsite ""  @ bclot WITH FRAME a.
    END.

    psite = bcsite.
    DISP psite WITH FRAME a.
    
    

    /*IF bcstatus NE "FINI-GOOD"  THEN DO:
        STATUS INPUT "该条码状态不能执行该操作，必须是fini-good，退出".
        RETURN.
    END.*/

    ASSIGN bccode
     bcpart
     bcqty
     bcsite
     bcloc
     psite
     ploc
     bclot.

    IF  bcqty = 0 OR psite = "" OR ploc = "" THEN DO:
        STATUS INPUT "资料不完整，不能执行,现在退出".
        RETURN.
    END.

      FIND FIRST b_shp_wkfl NO-LOCK WHERE b_shp_code = bccode AND b_shp_batch = batchid NO-ERROR.
      IF AVAILABLE b_shp_wkfl THEN DO:
          STATUS INPUT "该条码已经在移库清单中,不要重复添加".
          RETURN.
      END.

    IF bcstatus NE "FINI-GOOD" THEN DO:
        STATUS INPUT "该条码状态为:" + bcstatus + "不能发运,退出".
        RETURN.
    END.


    FIND FIRST ld_det NO-LOCK WHERE ld_part  = bcpart AND ld_loc = bcloc AND ld_lot = bclot NO-ERROR.
    IF NOT AVAILABLE ld_det  THEN DO:
         STATUS INPUT "在库位" + bcloc + "无法发现该零件库存,退出".
         RETURN.
    END.
    ELSE DO:
        IF ld_qty_oh < bcqty THEN DO:
            STATUS INPUT "库位" + bcloc + "批号" + bclot + "不足，退出".
            RETURN.
        END.
    END.


    FIND FIRST cl_mstr NO-LOCK WHERE cl_part = bcpart AND cl_site = bcsite AND cl_loc = bcloc
            AND bclot = cl_lot NO-ERROR.
    IF AVAILABLE cl_mstr  THEN DO:
          DEFINE VARIABL iq AS DECIMAL INITIAL 0.
          DEFINE VARIABLE jq AS DECIMAL INITIAL 0.
          FOR EACH cl_mstr WHERE cl_part = bcpart AND cl_site = bcsite AND cl_loc = bcloc
              AND bclot = cl_lot:
              jq = jq + cl_co_qty.
          END.
          iq = jq + bcqty.
          FIND FIRST ld_det NO-LOCK WHERE ld_part = bcpart AND ld_loc = bcloc AND ld_lot = bclot NO-ERROR.
          IF AVAILABLE ld_det THEN DO:
              IF ld_qty_oh >= iq THEN DO:
                  CREATE cl_mstr.
                  ASSIGN cl_part = bcpart
                      cl_site = bcsite
                      cl_loc = bcloc
                      cl_lot = bclot
                      cl_co_qty = bcqty.
              END.
              ELSE DO:
                   STATUS INPUT "库位" + bcloc + "批号" + bclot + "不足，退出".
                   RETURN.
              END.
          END.  /*if avaiable ld_det*/
          ELSE DO:
               STATUS INPUT "在库位" + bcloc + "无法发现该零件库存,退出".
               RETURN.
          END.   /*not available ld_det*/
    END.  /*if available cl_mstr*/
    ELSE DO:
        CREATE cl_mstr.
        ASSIGN cl_part = bcpart
            cl_site = bcsite
            cl_loc = bcloc
            cl_lot = bclot
            cl_co_qty = bcqty.
    END.


 {bcco001.i bccode bcpart bcqty psite ploc bclot """"}
 CREATE b_shp_wkfl.
 ASSIGN b_shp_batch = batchid
     b_shp_cust= ""
     b_shp_sonbr = ""
     b_shp_soline = 0
     b_shp_part = bcpart
     b_shp_code = bccode
     b_shp_qty = bcqty
     b_shp_site = bcsite
     b_shp_loc = bcloc
     b_shp_lot = bclot
     b_shp_site1 = psite
     b_shp_loc1 = ploc
     b_shp_status = "TOCIM"
     b_shp_date = TODAY
     b_shp_type = "NSOTR".
 STATUS INPUT "该条码已添加至调拨清单".

 APPLY KEYCODE("F2") TO BCCODE.

    RETURN.
END.


ON 'choose':U OF btn_view
DO:
    {gprun.i ""sonsotr01.p""}
    RETURN.
END.

psite = bcsite.
DISP psite WITH FRAME a.

SELECT MAX(b_shp_batch) INTO batchid FROM b_shp_wkfl.
IF batchid = ? THEN batchid = 1. ELSE batchid = batchid + 1.

REPEAT:
    UPDATE psite ploc WITH FRAME a.
    REPEAT:
        UPDATE bccode  WITH FRAME a.
    END.
    UPDATE btn_view WITH FRAME a.
END.


