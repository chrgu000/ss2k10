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
DEFINE VARIABLE bcsite LIKE b_co_site.
DEFINE VARIABLE bcloc LIKE b_co_loc.
DEFINE VARIABLE bclot LIKE b_co_lot LABEL  "批号".
DEFINE VARIABLE psite LIKE pod_site LABEL "地点".
DEFINE VARIABLE ploc LIKE pod_loc LABEL "库位".
DEFINE VARIABLE plot LIKE pod_lot_next LABEL "批号".
DEFINE VARIABLE bcstatus LIKE b_co_status LABEL "条码状态".

DEFINE NEW SHARED VARIABLE batchid LIKE b_rct_batch.
/*buffer record id used to exec CIM */
DEFINE VARIABLE bfid AS INTEGER.  /*indicate the buffer id*/

DEFINE VARIABLE active AS LOGICAL.  /*if barcode active*/

DEFINE BUTTON btn_view LABEL "查看".
DEFINE BUTTON btn_rec LABEL "收货".
DEFINE BUTTON btn_quit LABEL "退出".

DEF FRAME a
    SKIP(1)
    sonbr COLON 8 SKIP(.3) 
    bccode  COLON 4 SKIP(.3) 
    /*sodline COLON 8  SKIP(.3)*/
    bcpart COLON 8  SKIP(.3)
    /*qty_ord COLON 8  SKIP(.3)
    qty_shipped COLON 8  SKIP(.3)*/
    bcqty COLON 8  SKIP(.3)
    bclot COLON 8 SKIP(.3)
    psite COLON 8  SKIP(.3)
    ploc COLON 8  SKIP(.3)
    plot COLON 8  SKIP(.3)
     space(23) btn_view 
WITH WIDTH  30 TITLE "调拨"  SIDE-LABELS  NO-UNDERLINE THREE-D.

ON 'value-changed':U OF bccode 
DO:
    ASSIGN bccode sonbr.
    {gprun.i ""bccock.p""  "( INPUT bccode,
                                          OUTPUT active,
                                          OUTPUT bcpart,
                                          OUTPUT bcqty,
                                          OUTPUT bcsite,
                                          OUTPUT bcloc,
                                          OUTPUT bclot,
                                          OUTPUT bcstatus )"}
    IF active =YES THEN DO:
        DISP bcpart  bcqty bclot WITH FRAME a.
    END.
    ELSE DO:
        DISP "" @ bcpart  "" @ bcqty "" @ bclot WITH FRAME a.
    END.

    RUN so_info.
    ASSIGN bccode
        sonbr
        /*sodline*/
        bcpart
        /*qty_ord
        qty_shipped*/
        bcqty
        psite
        ploc
        bclot.
    IF  bcqty = 0
        OR sodline = 0 OR sonbr = "" THEN DO:
        STATUS INPUT "资料不完整，不能执行,现在退出".
        RETURN.
    END.

    /*IF bcstatus NE "FINI-GOOD"  THEN DO:
        STATUS INPUT "状态不能操作，必须是fini-good，退出".
        RETURN.
    END.      */

    FIND FIRST b_shp_wkfl NO-LOCK WHERE b_shp_code = bccode AND b_shp_batch = batchid NO-ERROR.
    IF AVAILABLE b_shp_wkfl THEN DO:
        STATUS INPUT "该条码已经在调拨清单中,不要重复扫描".
        RETURN.
    END.

    {bcco001.i bccode bcpart bcqty psite ploc bclot """"}
    CREATE b_shp_wkfl.
    ASSIGN b_shp_batch = batchid
        b_shp_cust= cust
        b_shp_sonbr = sonbr
        b_shp_soline = sodline
        b_shp_part = bcpart
        b_shp_code = bccode
        b_shp_qty = bcqty
        b_shp_site = bcsite
        b_shp_loc = bcloc
        b_shp_lot = bclot
        b_shp_site1 = psite
        b_shp_loc1 = ploc
        b_shp_date = TODAY
        b_shp_status = "TOCIM"
        b_shp_type = "SOTR".
    STATUS INPUT "该条码已添加至调拨清单".
        
    APPLY KEYCODE("F2") TO BCCODE.


    RETURN.
END.


ON 'choose':U OF btn_view
DO:
    {gprun.i ""sosotrs01.p""}
    RETURN.
END.

SELECT MAX(b_shp_batch) INTO batchid FROM b_shp_wkfl.
IF batchid = ? THEN batchid = 1. ELSE batchid = batchid + 1.

REPEAT:
    UPDATE sonbr WITH FRAME a.
    REPEAT:
        UPDATE bccode  WITH FRAME a.
    END.
    UPDATE btn_view WITH FRAME a.
END.



PROCEDURE so_info:
   FIND FIRST so_mstr NO-LOCK WHERE so_nbr = sonbr NO-ERROR.
   IF AVAILABLE so_mstr THEN DO:
       cust = so_cust.
   END.
   FIND FIRST sod_det NO-LOCK WHERE sod_nbr = sonbr AND sod_part = bcpart NO-ERROR.
   IF AVAILABLE sod_det THEN DO:
       sodline = sod_line.
       qty_ord = sod_qty_ord.
       qty_shipped = 0.
       psite = sod_site.
       ploc = sod_loc.

       DISP /*sodline qty_ord qty_shipped*/ psite ploc WITH FRAME a.
   END.
END.
