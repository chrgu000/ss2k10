{mfdtitle.i}
/*{mfdeclre.i }
 {gplabel.i}*/
{bcdeclre.i "new" }
 {bcini.i}
{bcwin.i}

/*DEFINE VARIABLE cust LIKE so_ship LABEL "客户".*/
DEFINE VARIABLE cust AS CHARACTER FORMAT "x(8)" LABEL "客户".
DEFINE VARIABLE adname LIKE ad_name.

DEFINE NEW SHARED VARIABLE dh AS CHARACTER FORMAT "x(10)" LABEL "单号".
DEFINE NEW SHARED VARIABLE batchid LIKE b_shp_batch.
DEFINE NEW SHARED VARIABLE shptype LIKE loc_status.  /*by shptype to decide if exec 7.9.8 cimload*/

DEFINE VARIABLE bccode LIKE b_co_code LABEL "条码".
DEFINE VARIABLE sonbr LIKE so_nbr LABEL "采购单号".
DEFINE VARIABLE sodline LIKE sod_line LABEL "项".
DEFINE VARIABLE bcpart LIKE pod_part LABEL "零件号".
DEFINE VARIABLE qty_ord LIKE pod_qty_ord LABEL "定单量".
DEFINE VARIABLE qty_ship LIKE b_co_qty_cur LABEL "条码数量".
DEFINE VARIABLE bcsite LIKE pod_site LABEL "条码地点".
DEFINE VARIABLE bcloc LIKE b_co_loc LABEL "条码库位".
DEFINE VARIABLE tloc LIKE pod_loc LABEL "目的库位".
DEFINE VARIABLE tsite LIKE pod_site LABEL "目的地点".
DEFINE VARIABLE bclot LIKE b_co_lot LABEL "批号".
DEFINE VARIABLE bcstatus LIKE b_co_status LABEL "条码状态".

DEFINE TEMP-TABLE cl_mstr 
    FIELD cl_part LIKE pt_part
    FIELD cl_loc LIKE ld_loc
    FIELD cl_site LIKE ld_site
    FIELD cl_lot LIKE ld_lot
    FIELD cl_ld_qty LIKE ld_qty_oh
    FIELD cl_co_qty LIKE ld_qty_oh.


/*buffer record id used to exec CIM */
DEFINE VARIABLE bfid AS INTEGER.  /*indicate the buffer id*/

DEFINE VARIABLE active AS LOGICAL.  /*if barcode active*/


DEFINE BUTTON btn_view LABEL "查看".
DEFINE BUTTON btn_shp LABEL "添加".
DEFINE BUTTON btn_quit LABEL "退出".

DEF FRAME a
    SKIP(.5)
    cust COLON 8 SKIP(.3)
    adname COLON 1 NO-LABEL
    dh COLON 8 SKIP(.3)
    /*sonbr COLON 8 SKIP(.3) 
    sodline COLON 8  SKIP(.3)
    qty_ord COLON 8  SKIP(.3)
    "条码:" AT 1 SKIP*/
    bccode  COLON 4 SKIP(.3) 
    bcpart COLON 8  SKIP(.3)
    qty_ship COLON 8  SKIP(.3)
    tsite COLON 8  SKIP(.3)
    tloc COLON 8  SKIP(.3)
    bclot COLON 8  SKIP(.3)
    space(23) btn_view 
WITH  WIDTH 30 TITLE "YFK发货"  SIDE-LABELS  NO-UNDERLINE THREE-D.



ON 'enter':U OF cust 
DO:
    ASSIGN cust.
    FIND FIRST so_mstr WHERE so_ship = cust NO-ERROR.
    IF NOT AVAILABLE so_mstr THEN DO:
        STATUS INPUT "找不到相应的日程单".
        RETURN.
    END.
    ELSE DO:
        FOR FIRST sod_det WHERE sod_nbr = so_nbr:
        END.
        sonbr = so_nbr.
        /*DISP sonbr WITH FRAME a.*/
        FIND FIRST ad_mstr NO-LOCK WHERE ad_addr = cust NO-ERROR.
        IF AVAILABLE ad_mstr THEN adname = ad_name.
        DISPLAY adname WITH FRAME a.
        APPLY "F2":u TO cust.
        DISABLE cust WITH FRAME a.  /*prevent user to add different cust during a shippment*/
    END.
    RETURN.
END.

ON 'value-changed':U OF bccode
DO:
    ASSIGN bccode.
    STATUS INPUT "".
    {gprun.i ""bccock.p""  "( INPUT bccode,
                                          OUTPUT active,
                                          OUTPUT bcpart,
                                          OUTPUT qty_ship,
                                          OUTPUT bcsite,
                                          OUTPUT bcloc,
                                          OUTPUT bclot,
                                          OUTPUT bcstatus )"}
    IF active =YES THEN DO:
        DISP bcpart  qty_ship bclot WITH FRAME a.
    END.
    ELSE DO:
        DISP "" @ bcpart  "" @ qty_ship "" @ bclot WITH FRAME a.
        STATUS INPUT "无法识别该条码".
        RETURN.
    END.
   
    IF bcstatus NE "FINI-GOOD" THEN DO:
        STATUS INPUT "该条码状态为:" + bcstatus + "不能发运,退出".
        RETURN.
    END.

    FIND FIRST scx_ref NO-LOCK WHERE scx_shipto = cust AND 
        scx_part = bcpart AND scx_type = 1  NO-ERROR.
    IF NOT AVAILABLE scx_ref THEN DO :
        STATUS INPUT "无法找到日程单,退出".
        RETURN.
    END.

    FOR EACH so_mstr WHERE so_ship = cust:
        FIND FIRST sod_det NO-LOCK WHERE so_nbr = so_nbr
            AND sod_part = bcpart NO-ERROR.
        IF AVAILABLE sod_det THEN DO:
            sodline = sod_line.
            qty_ord = sod_qty_ord.
            /*DISP sodline qty_ord WITH FRAME a.*/
        END.
        ELSE DO:
            STATUS INPUT "条码零件和订单零件不符，退出".
            RETURN.
        END.
    END.

        FIND FIRST b_shp_wkfl NO-LOCK WHERE b_shp_batch = batchid 
         AND b_shp_cust NE cust NO-ERROR.
       IF  AVAILABLE b_shp_wkfl THEN DO:
             STATUS INPUT  "不允许两个客户同时发货,退出".
             RETURN.
       END.

       
    FIND FIRST xshloc_mstr NO-LOCK WHERE xshloc_part = bcpart
        AND xshloc_cust = cust AND xshloc_site = sod_site
        AND xshloc_yfk_loc = bcloc NO-ERROR.
    IF AVAILABLE xshloc_mstr THEN DO:
        tloc = xshloc_cust_loc.
        DISP tloc WITH FRAME a.
        FIND FIRST loc_mstr NO-LOCK WHERE loc_loc = tloc NO-ERROR.
        IF AVAILABLE loc_mstr THEN DO:
            tsite = loc_site.
            IF bcsite = "" THEN bcsite = sod_site.  /*为防备该条码没有地点*/
            DISP tsite WITH FRAME a.
            IF loc_status = "customer" THEN shptype = "CUSTOMER". ELSE shptype = "TRANS".
            STATUS INPUT "发运类型为" + shptype .
        END.
        ELSE DO:
            STATUS INPUT "无法在loc_mstr找到发往库位".
            RETURN.
        END.
    END.
    ELSE DO:
        STATUS INPUT "无法在shloc里找到客户库位".
        RETURN.
    END.


    FIND FIRST b_shp_wkfl NO-LOCK WHERE b_shp_batch = batchid
        AND b_shp_loc1 NE tloc NO-ERROR.
    IF AVAILABLE b_shp_wkfl THEN DO:
        STATUS INPUT "本次发运存不同发往库位,退出".
        RETURN.
    END.


    FIND FIRST ld_det NO-LOCK WHERE ld_part  = bcpart AND ld_loc = bcloc AND ld_lot = bclot NO-ERROR.
    IF NOT AVAILABLE ld_det  THEN DO:
         STATUS INPUT "在库位" + bcloc + "无法发现该零件库存,退出".
         RETURN.
    END.
    ELSE DO:
        IF ld_qty_oh < qty_ship THEN DO:
            STATUS INPUT "库位" + bcloc + "批号" + bclot + "不足，退出".
            RETURN.
        END.
    END.

    FIND FIRST b_shp_wkfl NO-LOCK WHERE b_shp_code = bccode AND b_shp_batch = batchid NO-ERROR.
    IF AVAILABLE b_shp_wkfl THEN DO:
        STATUS INPUT "该条码本次已经扫描,退出".
        RETURN.
    END.



    IF bccode = "" OR sonbr = "" OR sodline = 0 /*OR qty_ord = 0*/
        OR cust = "" OR bcpart = "" OR qty_ship = 0 OR tsite = "" 
        OR tloc = "" OR bclot = "" THEN DO:
        STATUS INPUT "资料不完整，或者有数量为0，退出".
        RETURN.
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
          iq = jq + qty_ship.
          FIND FIRST ld_det NO-LOCK WHERE ld_part = bcpart AND ld_loc = bcloc AND ld_lot = bclot NO-ERROR.
          IF AVAILABLE ld_det THEN DO:
              IF ld_qty_oh >= iq THEN DO:
                  CREATE cl_mstr.
                  ASSIGN cl_part = bcpart
                      cl_site = bcsite
                      cl_loc = bcloc
                      cl_lot = bclot
                      cl_co_qty = qty_ship.
              END.
              ELSE DO:
                  MESSAGE "批号" + bclot + "库存" + string(ld_qty_oh)  + " 条码" + STRING( iq).
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
            cl_co_qty = qty_ship.
    END.

    {bcco001.i bccode bcpart qty_ship bcsite tloc bclot """"}
    CREATE b_shp_wkfl.
    ASSIGN
        b_shp_batch = batchid
        b_shp_cust = cust
        b_shp_date = TODAY
        b_shp_sonbr = sonbr
        b_shp_soline = sodline
        b_shp_part = bcpart
        b_shp_qty = qty_ship
        b_shp_lot = bclot
        b_shp_site = bcsite
        b_shp_loc = IF bcloc = "" THEN tloc ELSE bcloc
        b_shp_site1 = tsite
        b_shp_loc1 = tloc
        b_shp_code = bccode
        b_shp_status = "TOSHIP"
        b_shp_type = shptype.

        
   APPLY KEYCODE("F2") TO bccode.

    RETURN.
END.

ON 'choose':U OF btn_view 
DO:
    {gprun.i ""soshpxx01.p""}
    RETURN.
END.

/*
SELECT MAX(b_shp_batch) INTO batchid FROM b_shp_wkfl.
IF batchid = ? THEN batchid = 1. ELSE batchid = batchid + 1.*/
BATCHID = NEXT-VALUE(BSHP_SEQ01).
IF batchid = ? THEN DO:
      MESSAGE 'bshp_seq01用尽,请初始化!' VIEW-AS ALERT-BOX  ERROR.
      QUIT.
END.


REPEAT:
    UPDATE cust WITH FRAME a.
    UPDATE dh WITH FRAME a.
    REPEAT:
        UPDATE bccode WITH FRAME a.
    END.
    UPDATE btn_view WITH FRAME a.
END.



        




 



