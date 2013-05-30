/**-----------------------------------------------**
 @File: yyrcshldbx.p
 @Description: upload supplier schedule from excel
 @Version: 1.0
 @Author: James Zou
 @Created: 2006-6-20
 @Mfgpro: eb2sp7
 @Parameters:
 @BusinessLogic:
  upload one date schedule to existed active release.
  check price when code_mstr=xx-supplier-sch#0001#y
  excel file default dir is code_mstr=xx-supplier-sch#0001###dir
 @data file format:
Row=5                                                   AA=日期
    | A   B     S           U   W        Y        AA   AC      AE      AG |
Row=16  |序号 零件号 供应商编码 数量 限定时间 接收库位 包装 保管员 采购单号 PO序|
**-----------------------------------------------**/


/* DISPLAY TITLE */
{mfdtitle.i "12413"}
{yyedcomlib.i}

DEF VAR v_ok         AS LOGICAL.
DEF VAR v_confirm    AS LOGICAL.
DEF VAR v_sys_status AS CHAR.
DEF VAR v_flag       AS CHAR.

DEF VAR v_fexcel     AS CHAR FORMAT "x(55)".
DEF VAR v_fdir       AS CHAR.

DEF VAR v_ship_fr    AS CHAR.
DEF VAR v_ship_to    AS CHAR.
DEF VAR v_box_item   AS CHAR.
DEF VAR v_box_loc    AS CHAR.
DEF VAR v_box_nbr    AS CHAR.
DEF VAR v_shipper    AS CHAR.

DEF VAR v_mot        AS CHAR.
DEF VAR v_fob        AS CHAR.
DEF VAR v_shipdate   AS DATE.

DEF VAR v_sheet      AS INTEGER INITIAL 1.
DEF VAR v_um         LIKE pt_um INITIAL "KG".

DEFINE TEMP-TABLE xxwk3
    FIELDS xxwk3_asn_nbr      AS CHAR LABEL "ASN编号"
    FIELDS xxwk3_sonbr        LIKE so_nbr
    FIELDS xxwk3_soldto       LIKE so_cust LABEL "客户"
    FIELDS xxwk3_name_soldto  LIKE ad_name
    FIELDS xxwk3_shipfr       LIKE so_site label  "发货地点"
    FIELDS xxwk3_name_shipfr  LIKE ad_name
    FIELDS xxwk3_shipto       LIKE so_ship LABEL "送货地点"
    FIELDS xxwk3_name_shipto  LIKE ad_name
    FIELDS xxwk3_mfg_soldto   LIKE so_cust LABEL "订单客户"
    FIELDS xxwk3_mfg_shipfr   LIKE so_site LABEL "订单地点"
    FIELDS xxwk3_mfg_shipto   LIKE so_ship LABEL "订单发货"
    FIELDS xxwk3_mot          AS CHAR LABEL "运输方式"
    FIELDS xxwk3_fob          AS CHAR LABEL "FOB地点"
    FIELDS xxwk3_date_ship    AS DATE LABEL "计划发货日期"
    FIELDS xxwk3_time_ship    AS CHAR LABEL "计划发货时间" FORMAT "HH:MM"
    FIELDS xxwk3_date_eta     AS DATE LABEL "预计到达日期"
    FIELDS xxwk3_time_eta     AS CHAR LABEL "预计到达时间"
    FIELDS xxwk3_carrier_id   AS CHAR LABEL "承运人"
    FIELDS xxwk3_carrier_ref  AS CHAR LABEL "承运参考单号"
    FIELDS xxwk3_vehicle_id   AS CHAR LABEL "车船号"
    FIELDS xxwk3_shipvia      AS CHAR LABEL "运输代理"
    FIELDS xxwk3_err          AS LOGICAL INITIAL NO LABEL "错误标识"
    .
DEF TEMP-TABLE xxwk2
    FIELDS xxwk2_box_id        AS CHAR     COLUMN-LABEL "箱号"
    FIELDS xxwk2_box_nwt       LIKE ABS_nwt LABEL "净重"
    FIELDS xxwk2_box_gwt       LIKE ABS_gwt LABEL "毛重"
    FIELDS xxwk2_box_cwt       LIKE ABS_nwt LABEL "箱子自重" FORMAT "->>>>>>9.9<<<<<<"
    FIELDS xxwk2_box_wtum      LIKE pt_um
    FIELDS xxwk2_box_dim       AS CHAR LABEL "长宽高" FORMAT "x(24)"
    FIELDS xxwk2_mfg_nwt       LIKE ABS_nwt
    FIELDS xxwk2_box_loc       AS CHAR LABEL "库位"
    INDEX xxwk2_idx1 xxwk2_box_id
    .

DEF TEMP-TABLE xxwk1
    FIELDS xxwk1_part          LIKE pt_part
    FIELDS xxwk1_desc          LIKE pt_desc1
    FIELDS xxwk1_lot           LIKE ld_lot
    FIELDS xxwk1_qty           LIKE schd_upd_qty
    FIELDS xxwk1_loc           LIKE ld_loc
    FIELDS xxwk1_box_id        AS CHAR LABEL "箱号"
    FIELDS xxwk1_box_nwt       LIKE ABS_nwt LABEL "净重"
    FIELDS xxwk1_mfg_nwt       LIKE ABS_nwt LABEL "系统计算净重"
    FIELDS xxwk1_sonbr         LIKE so_nbr
    FIELDS xxwk1_soln          LIKE sod_line
    FIELDS xxwk1_site          LIKE sod_site
    INDEX xxwk1_idx1 xxwk1_part
    .

DEF TEMP-TABLE xxwk4
    FIELDS xxwk4_line   AS INTEGER LABEL "行号" FORMAT ">>>>"
    FIELDS xxwk4_error  AS CHAR    LABEL "错误" FORMAT "x(60)"
    .


DEF STREAM s1.


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
FORM
    RECT-FRAME       AT ROW 1.4 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
    SKIP(.1)  /*GUI*/
    v_fexcel LABEL "上载文件" COLON 10
    SKIP
    v_sheet LABEL "工作薄号"  COLON 10
    SKIP
    v_um  COLON 10
    SKIP(.4)  /*GUI*/
    WITH FRAME a SIDE-LABELS WIDTH 80 NO-BOX THREE-D.

DEFINE VARIABLE F-a-title AS CHARACTER.
F-a-title = &IF (DEFINED(SELECTION_CRITERIA) = 0)
            &THEN " Selection Criteria "
            &ELSE {&SELECTION_CRITERIA}
            &ENDIF .
RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
                 FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
                 RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ",
                 RECT-FRAME-LABEL:FONT).
RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).



RUN xxpro-initial (OUTPUT v_sys_status).

REPEAT:
    UPDATE
        v_fexcel
        WITH FRAME a.
    v_ok = YES.
    IF v_fexcel = "" THEN DO:
        v_ok = NO.
        SYSTEM-DIALOG GET-FILE v_fexcel
            TITLE "请选择数据文件..."
            FILTERS "Source Files (*.xls)"   "*.xls"
            INITIAL-DIR v_fdir
            MUST-EXIST
            USE-FILENAME
            UPDATE v_ok.
        DISP v_fexcel WITH FRAME a.
    END.
    IF v_ok = YES THEN DO:
        UPDATE
            v_sheet
            v_um
            WITH FRAME a.
    END.
    ELSE DO:
        UNDO, RETRY.
    END.

    IF v_fexcel = "" THEN UNDO, RETRY.

    RUN xxpro-excel (OUTPUT v_sys_status).
    FIND FIRST xxwk3 NO-LOCK NO-ERROR.
    IF NOT AVAILABLE xxwk3 THEN UNDO, RETRY.

    /*review*/

    {mfselprt.i "terminal" 80}
    RUN xxpro-check.
    FIND FIRST xxwk4 NO-LOCK NO-ERROR.
    IF AVAILABLE xxwk4 THEN DO:
        FIND FIRST xxwk3 NO-ERROR.
        IF AVAILABLE xxwk3 THEN ASSIGN xxwk3_err = YES.
    END.
    RUN xxpro-report.
    {mfreset.i}
    {mfgrptrm.i} /*Report-to-Window*/

    FIND FIRST xxwk3.
    IF xxwk3_err = YES THEN DO:
        MESSAGE "数据存在错误，不能上载." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    END.
    ELSE DO:
        v_confirm = NO.
        MESSAGE "确认要上载所显示的数据" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE v_confirm.
        IF v_confirm = YES THEN DO:
            RUN xxpro-load  (OUTPUT v_sys_status).
        END.
    END.
END.


/*---------------------------*/
PROCEDURE xxpro-initial:
    DEF OUTPUT PARAMETER p_sys_status AS CHAR.
    p_sys_status = "".

    v_ok = NO.
    v_fexcel = "".
    v_fdir = "".
    v_flag = "".
    v_box_item = "".
    v_box_loc  = "".
    FIND FIRST CODE_mstr WHERE code_domain = global_domain and CODE_fldname = "xx-box-data"
        AND CODE_value = "0001" NO-LOCK NO-ERROR.
    IF AVAILABLE CODE_mstr THEN ASSIGN v_box_item = CODE_desc v_box_loc = CODE_user2.
    p_sys_status = "0".
END PROCEDURE.
/*---------------------------*/
PROCEDURE xxpro-excel:
    DEF OUTPUT PARAMETER p_sys_status AS CHAR.
    p_sys_status = "".

    DEF VAR chExcel AS COM-HANDLE.
    DEF VAR chWorkbook AS COM-HANDLE.
    DEF VAR chWorksheet AS COM-HANDLE.

    DEF VAR iRow   AS INTEGER.
    def var iError as integer.
    def var iWarning as integer.

    DEF VAR v_data AS CHAR EXTENT 20.
    DEF VAR i      AS INTEGER.

    CREATE "Excel.Application" chExcel.

    /*chWorkbook  =  chExcel:Workbooks:OPEN(v_filename1).*/
    chWorkbook = chExcel:Workbooks:OPEN(v_fexcel,0,true,,,,true).
    chWorkSheet =  chWorkbook:workSheets(v_sheet).
    chExcel:visible = NO.



    FOR EACH xxwk1:
        DELETE xxwk1.
    END.
    FOR EACH xxwk2:
        DELETE xxwk2.
    END.
    FOR EACH xxwk3:
        DELETE xxwk3.
    END.
    FOR EACH xxwk4:
        DELETE xxwk4.
    END.

    /* read EXCEL file and load data begin..*/
    iRow = 5. /* from the 17th row in the excel file, read data.*/
  iError = 0.
  iWarning = 0.


    iRow = 1.
    IF STRING(chWorkbook:Worksheets(v_sheet):Cells(iRow,"A"):value) <> "发货装箱单" THEN DO:
        MESSAGE "这不是发货装箱单，不能上载." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        LEAVE.
    END.

    CREATE xxwk3.
    ASSIGN
        xxwk3_asn_nbr = STRING(chWorkbook:Worksheets(v_sheet):Cells(iRow,6):value).

    iRow = 3.
    ASSIGN
        xxwk3_sonbr  = STRING(chWorkbook:Worksheets(v_sheet):Cells(iRow,2):value)
        xxwk3_soldto = STRING(chWorkbook:Worksheets(v_sheet):Cells(iRow,6):value).

    iRow = 4.
    ASSIGN
        xxwk3_shipfr = STRING(chWorkbook:Worksheets(v_sheet):Cells(iRow,2):value)
        xxwk3_shipto = STRING(chWorkbook:Worksheets(v_sheet):Cells(iRow,6):value).

    iRow = 9.
    REPEAT:
        iRow = iRow + 1.
        if string(chWorkbook:Worksheets(v_sheet):Cells(iRow,1):value) = "" then leave.
        if string(chWorkbook:Worksheets(v_sheet):Cells(iRow,1):value) = ? then leave.

        v_data = "".
        do i = 1 to 20:
            v_data[i] = trim(string(chWorkbook:Worksheets(v_sheet):Cells(iRow,i):TEXT)).
        end.
        FIND FIRST xxwk2 WHERE xxwk2_box_id = v_data[1] NO-ERROR.
        IF NOT AVAILABLE xxwk2 THEN DO:
            CREATE xxwk2.
            ASSIGN
                xxwk2_box_id   = v_data[1]
                xxwk2_box_nwt = 0
                xxwk2_box_gwt = decimal(v_data[6])
                xxwk2_box_cwt = 0
                xxwk2_box_wtum = v_um
                xxwk2_box_dim  = v_data[7]
                xxwk2_box_loc  = v_box_loc.
        END.
        /*assign xxwk2_box_nwt = xxwk2_box_nwt + decimal(v_data[6]).*/
        create xxwk1.
        assign
            xxwk1_sonbr   = xxwk3_sonbr
            xxwk1_part    = v_data[2]
            xxwk1_lot     = v_data[4]
            xxwk1_qty     = decimal(v_data[5])
            xxwk1_box_nwt = 0
            xxwk1_loc     = v_data[8]
            xxwk1_box_id  = v_data[1]
            .
    END.
    chExcel:DisplayAlerts = FALSE.
    chWorkbook:CLOSE.
    chExcel:QUIT.

    RELEASE OBJECT chWorksheet.
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chExcel.

    p_sys_status = "0".
END PROCEDURE.

/*---------------------------*/
PROCEDURE xxpro-check:
    DEF VAR i AS INTEGER.
    i = 0.
    FIND FIRST xxwk3 NO-ERROR.
    IF NOT AVAILABLE xxwk3 THEN DO:
        i = i + 1.
        CREATE xxwk4.
        ASSIGN
            xxwk4_line  = i
            xxwk4_error = "无发货单".
        NEXT.
    END.
    FIND FIRST ad_mstr WHERE ad_domain = global_domain and ad_addr = xxwk3_soldto NO-LOCK NO-ERROR.
    IF AVAILABLE ad_mstr THEN ASSIGN xxwk3_name_soldto = ad_name.
    FIND FIRST ad_mstr WHERE ad_domain = global_domain and ad_addr = xxwk3_shipfr NO-LOCK NO-ERROR.
    IF AVAILABLE ad_mstr THEN ASSIGN xxwk3_name_shipfr = ad_name.
    FIND FIRST ad_mstr WHERE ad_domain = global_domain and  ad_addr = xxwk3_shipto NO-LOCK NO-ERROR.
    IF AVAILABLE ad_mstr THEN ASSIGN xxwk3_name_shipto = ad_name.

    FIND FIRST so_mstr WHERE so_domain = global_domain and so_nbr = xxwk3_sonbr NO-LOCK NO-ERROR.
    IF AVAILABLE so_mstr THEN DO:
        xxwk3_mfg_soldto = so_cust.
        xxwk3_mfg_shipto = so_ship.
        FIND FIRST sod_det WHERE sod_domain = global_domain and sod_nbr = xxwk3_sonbr NO-LOCK NO-ERROR.
        IF AVAILABLE sod_det THEN xxwk3_mfg_shipfr = sod_site.
    END.

    FOR EACH xxwk1:
        FIND FIRST pt_mstr WHERE pt_domain = global_domain and pt_part = xxwk1_part NO-LOCK NO-ERROR.
        IF AVAILABLE pt_mstr THEN ASSIGN
            xxwk1_desc    = pt_desc2
            xxwk1_mfg_nwt = pt_net_wt * xxwk1_qty
            xxwk1_box_nwt = pt_net_wt * xxwk1_qty
            .
        IF xxwk1_sonbr <> "" THEN DO:
            FIND FIRST sod_det WHERE sod_domain = global_domain and sod_nbr = xxwk1_sonbr AND sod_part = xxwk1_part NO-LOCK NO-ERROR.
            IF AVAILABLE sod_det THEN do:
                xxwk1_soln = sod_line.
                xxwk1_site = sod_site.
            END.
            ELSE DO:
                i = i + 1.
                CREATE xxwk4.
                ASSIGN
                    xxwk4_line  = i
                    xxwk4_error = "零件:" + xxwk1_part + "不属于订单:" + xxwk1_sonbr.
            END.
        END.
        FIND FIRST xxwk2 WHERE xxwk2_box_id = xxwk1_box_id NO-ERROR.
        IF AVAILABLE xxwk2 THEN DO:
            ASSIGN
                xxwk2_mfg_nwt = xxwk2_mfg_nwt + xxwk1_mfg_nwt
                xxwk2_box_nwt = xxwk2_box_nwt + xxwk1_box_nwt
                .
        END.
    END.

    FOR EACH xxwk2:
        ASSIGN xxwk2_box_cwt = xxwk2_box_gwt - xxwk2_box_nwt.
    END.

    FIND FIRST xxwk1 NO-LOCK NO-ERROR.
    IF NOT AVAILABLE xxwk1 THEN DO:
        i = i + 1.
        CREATE xxwk4.
        ASSIGN
            xxwk4_line  = i
            xxwk4_error = "没有要上载的零件数据".
        NEXT.
    END.
    FIND FIRST xxwk2 WHERE xxwk2_box_id = "" NO-LOCK no-error.
    IF AVAILABLE xxwk2 THEN DO:
        i = i + 1.
        CREATE xxwk4.
        ASSIGN
            xxwk4_line  = i
            xxwk4_error = "包装箱号为空".
        NEXT.
    END.
    IF v_box_item = "" THEN DO:
        i = i + 1.
        CREATE xxwk4.
        ASSIGN
            xxwk4_line  = i
            xxwk4_error = "包装箱零件号错误".
        NEXT.
    END.
    IF v_box_loc = "" THEN DO:
        i = i + 1.
        CREATE xxwk4.
        ASSIGN
            xxwk4_line  = i
            xxwk4_error = "包装箱发货库位错误为空".
        NEXT.
    END.
    FIND FIRST loc_mstr WHERE loc_domain = global_domain
           and loc_site = xxwk3_shipfr AND loc_loc = v_box_loc NO-LOCK NO-ERROR.
    IF NOT AVAILABLE loc_mstr THEN DO:
        i = i + 1.
        CREATE xxwk4.
        ASSIGN
            xxwk4_line  = i
            xxwk4_error = "包装箱发货库位错误".
        NEXT.
    END.
    IF xxwk3_asn_nbr = "" THEN DO:
        i = i + 1.
        CREATE xxwk4.
        ASSIGN
            xxwk4_line  = i
            xxwk4_error = "发货单错误".
        NEXT.
    END.
    IF xxwk3_shipfr = "" OR xxwk3_shipfr <> xxwk3_mfg_shipfr THEN DO:
        i = i + 1.
        CREATE xxwk4.
        ASSIGN
            xxwk4_line  = i
            xxwk4_error = "发货地点错误".
        NEXT.
    END.
    IF xxwk3_shipto = "" OR xxwk3_shipto <> xxwk3_mfg_shipto THEN DO:
        i = i + 1.
        CREATE xxwk4.
        ASSIGN
            xxwk4_line  = i
            xxwk4_error = "到货地点错误".
        NEXT.
    END.
    IF xxwk3_soldto = "" OR xxwk3_soldto <> xxwk3_mfg_soldto THEN DO:
        i = i + 1.
        CREATE xxwk4.
        ASSIGN
            xxwk4_line  = i
            xxwk4_error = "客户错误".
        NEXT.
    END.
    FIND FIRST xxwk2 WHERE xxwk2_mfg_nwt <> xxwk2_box_nwt NO-LOCK NO-ERROR.
    IF AVAILABLE xxwk2 THEN DO:
        i = i + 1.
        CREATE xxwk4.
        ASSIGN
            xxwk4_line  = i
            xxwk4_error = "系统净重<>单据净重:" + xxwk2_box_id.
        NEXT.
    END.
    FIND FIRST xxwk2 WHERE xxwk2_box_nwt > xxwk2_box_gwt NO-LOCK NO-ERROR.
    IF AVAILABLE xxwk2 THEN DO:
        i = i + 1.
        CREATE xxwk4.
        ASSIGN
            xxwk4_line  = i
            xxwk4_error = "净重>毛重:" + xxwk2_box_id.
        NEXT.
    END.
    FIND FIRST xxwk1 WHERE xxwk1_site <> xxwk3_shipfr NO-LOCK NO-ERROR.
    IF AVAILABLE xxwk2 THEN DO:
        i = i + 1.
        CREATE xxwk4.
        ASSIGN
            xxwk4_line  = i
            xxwk4_error = "订单地点不匹配:" + xxwk1_part + "/行:" + STRING(xxwk1_soln).
        NEXT.
    END.

    /*check shipper existed*/
    find abs_mstr where abs_domain = global_domain and abs_mstr.abs_shipfrom = xxwk3_shipfr
                    and abs_mstr.abs_id = "S" + xxwk3_asn_nbr
    no-lock no-error.
    IF NOT AVAILABLE ABS_mstr THEN DO:
        i = i + 1.
        CREATE xxwk4.
        ASSIGN
            xxwk4_line  = i
            xxwk4_error = "发货单不存在".
        NEXT.
    END.
    ELSE IF substring(abs_status,2,1) = "Y" THEN DO:
        i = i + 1.
        CREATE xxwk4.
        ASSIGN
            xxwk4_line  = i
            xxwk4_error = "发货单已确认".
        NEXT.
    END.
    ELSE DO:
        xxwk3_shipvia = trim(SUBSTRING(ABS__qad01,1,20)).
        xxwk3_fob     = trim(SUBSTRING(ABS__qad01,21,20)).
        xxwk3_mot     = trim(SUBSTRING(ABS__qad01,61,20)).
    END.

    /*check box existed*/
    FOR EACH xxwk2:
        find abs_mstr where abs_domain = global_domain and abs_mstr.abs_shipfrom = xxwk3_shipfr
                        and abs_mstr.abs_id = "C" + xxwk2_box_id
        no-lock no-error.
        IF AVAILABLE ABS_mstr THEN DO:
            i = i + 1.
            CREATE xxwk4.
            ASSIGN
                xxwk4_line  = i
                xxwk4_error = "BOX已经存在:" + xxwk2_box_id.
            NEXT.
        END.
    END.
END PROCEDURE.


/*---------------------------*/
PROCEDURE xxpro-report:
    FOR EACH xxwk4:
        DISP xxwk4 WITH FRAME f-a DOWN WIDTH 80 STREAM-IO.
    END.
    FOR EACH xxwk3:
        DISP
            xxwk3_asn_nbr
            xxwk3_sonbr
            xxwk3_soldto
            xxwk3_name_soldto
            xxwk3_shipfr
            xxwk3_name_shipfr
            xxwk3_shipto
            xxwk3_name_shipto
            xxwk3_mot
            xxwk3_fob
            xxwk3_date_ship
            xxwk3_time_ship
            xxwk3_date_eta
            xxwk3_time_eta
            xxwk3_carrier_id
            xxwk3_carrier_ref
            xxwk3_vehicle_id
            xxwk3_shipvia
            xxwk3_err
        WITH FRAME f-b WIDTH 132 2 COLUMNS STREAM-IO.
        FOR EACH xxwk1 BY xxwk1_box_id BY xxwk1_part:
            DISP
                xxwk1_box_id
                 xxwk1_part
                 xxwk1_desc
                 xxwk1_lot
                 xxwk1_qty
                 xxwk1_loc
                 xxwk1_box_nwt
                 /*xxwk1_mfg_nwt*/
                 /*xxwk1_sonbr  */
                 xxwk1_soln
                /*xxwk1_site*/
                WITH FRAME f-c WIDTH 150 DOWN STREAM-IO.
        END.
        FOR EACH xxwk2:
            DISP
                SPACE(8)
                 xxwk2_box_id
                 xxwk2_box_nwt
                 xxwk2_box_gwt
                 xxwk2_box_cwt
                 xxwk2_box_wtum
                 xxwk2_box_dim
                 /*xxwk2_mfg_nwt*/
                 xxwk2_box_loc
                WITH FRAME f-d WIDTH 150 DOWN STREAM-IO.
        END.
    END.
END PROCEDURE.

/*---------------------------*/
PROCEDURE xxpro-load:
    DEF OUTPUT PARAMETER p_sys_status AS CHAR.
    p_sys_status = "".
    DEF VAR v_fcimdat    AS CHAR.
    DEF VAR v_fcimlog    AS CHAR.
    DEF VAR v_fdata      AS CHAR.
    DEF VAR v_freport    AS CHAR.

    FIND FIRST xxwk3 NO-ERROR.
    IF NOT AVAILABLE xxwk3 THEN LEAVE.

    v_fdata   = "boxdata.dat".
    v_freport = "boxrpt".
    v_fcimdat = "box" + string(time) + ".dat".
    v_fcimlog = v_fcimdat + ".log".
    OUTPUT STREAM s1 CLOSE.
    OUTPUT STREAM s1 TO VALUE(v_fdata).
     /*shipper header*
            put STREAM s1 UNFORMATTED
                '"S"'     SPACE(1)
                '- -' SPACE(1)
                '"' + v_ship_fr + '"' SPACE(1)
                '"' + v_shipper + '"' SPACE(1)
                '- - - -' SPACE(1)
                '"' + v_ship_to + '"' space(1)
                '- - - - - - - - - - - - - - - -' SPACE(1)
                SKIP.  */
    /*box*/
    FOR EACH xxwk2 BY xxwk2_box_id:
        put STREAM s1 UNFORMATTED
            '"C"'     SPACE(1)
            '"' + xxwk3_shipfr + '"' SPACE(1)
            '"' + xxwk2_box_loc + '"' SPACE(1)
            '"' + xxwk3_shipfr + '"' SPACE(1)
            '"' + xxwk2_box_id + '"' SPACE(1)
            '"' + v_box_item + '"' SPACE(1)
            ' - - 1 '  SPACE(1)
            '"' + xxwk3_shipto + '"' space(1)
            ' - - ' SPACE(1)
            's' + xxwk3_asn_nbr SPACE(1)
            ' - EA - - - - ' SPACE(1)
            /*xxwk1_box_gwt*/ xxwk2_box_cwt  SPACE(1)
            '"' + xxwk2_box_dim + '"' SPACE(1)  /*shipvia = boxdim*/
            ' - - - - - '   SPACE(1)
            SKIP.
        FOR EACH xxwk1 WHERE xxwk1_box_id = xxwk2_box_id:
            put STREAM s1 UNFORMATTED
            '"I"'  SPACE(1)
            '"' + xxwk3_shipfr + '"' SPACE(1)
            '"' + xxwk1_loc + '"' SPACE(1)
            '"' + xxwk3_shipfr + '"' SPACE(1)
            '-'       SPACE(1)
            '"' + xxwk1_part + '"' SPACE(1)
            ' - - '    SPACE(1)
            xxwk1_qty space(1)
            '-'       SPACE(1)
            '"' + xxwk1_sonbr + '"' space(1)
            xxwk1_soln  space(1)
            '"' + 'c' + xxwk1_box_id + '"' SPACE(1)
            ' - EA ' SPACE(1)
            '- - - -' SPACE(1)
            /*xxwk1_box_gwt*/ '-' SPACE(1)
            ' - '
            ' - - - - - '
            SKIP.
        END.
    END.
    OUTPUT STREAM s1 CLOSE.
    RUN xxpro-cimload (INPUT v_fdata, INPUT v_freport).
    p_sys_status = "0".
END PROCEDURE.
/*-----------------------*/
PROCEDURE xxpro-cimload:
    DEF INPUT PARAMETER p_cimdat AS CHAR.
    DEF INPUT PARAMETER p_cimlog AS CHAR.
    DEF VAR   v-loadok  AS LOGICAL.
    {gprun.i ""yyrcshgw.p"" "(input p_cimdat, input p_cimlog, input no, output v-loadok)"}
    IF v-loadok = NO THEN DO:
        MESSAGE "数据上载错误,请检查." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        {gprun.i ""yyut3.p"" "(input p_cimlog)"}
        UNDO, LEAVE.
    END.
    ELSE DO:
        MESSAGE "上载完毕." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    END.
END PROCEDURE.

