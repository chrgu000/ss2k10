

/* DISPLAY TITLE */
{mfdtitle.i "120925.1"}
{yyedcomlib.i}
/*
IF f-howareyou("HAHA") = NO THEN LEAVE.
*/
DEF VAR v_ok         AS LOGICAL.
DEF VAR v_sys_status AS CHAR.
DEF VAR v_printername AS CHAR.

DEF VAR v_fexcel     AS CHAR.
DEF VAR v_fname      AS CHAR.
DEF VAR v_fname2     AS CHAR.
DEF VAR v_description LIKE ad_name EXTENT 5.

DEF VAR v_ponbr       LIKE po_nbr.
DEF VAR v_date       AS DATE.
DEF VAR v_ship_fr       LIKE po_vend.
DEF VAR v_ship_to       LIKE po_site.
DEF VAR v_tot_amt   LIKE glt_amt.
DEF VAR v_curr  AS CHAR.
DEF VAR v_contract LIKE po_contract.
DEF VAR v_order_label AS CHAR.
DEF VAR v_polist  AS CHAR.
DEF VAR v_dt_prt AS DATE INITIAL TODAY.
DEF VAR v_rev    LIKE po_rev.
DEF VAR v_list_net AS LOGICAL INITIAL NO.
DEF VAR v_list_fp   AS CHAR INITIAL "".
DEF VAR v_list_zero AS LOGICAL INITIAL NO.
DEF VAR v_buyer    AS CHAR.
DEF VAR v_name     AS CHAR EXTENT 5.
DEF VAR v_noexport AS LOGICAL INITIAL YES.
DEF VAR v_releaseid LIKE schd_rlse_id.
DEF VAR v_datefmt   AS CHAR INITIAL "mm/dd/yy".

DEF TEMP-TABLE xxwk2
    FIELDS xxwk2_ponbr     LIKE po_nbr       LABEL "采购单"
    FIELDS xxwk2_contract  LIKE po_contract  LABEL "合同号"
    FIELDS xxwk2_shipfr    LIKE po_vend      LABEL "供应商"
    FIELDS xxwk2_name_fr   LIKE ad_name      LABEL "名称"
    FIELDS xxwk2_shipto    LIKE po_site      LABEL "收货地点"
    FIELDS xxwk2_name_to   LIKE ad_name      LABEL "名称"
    FIELDS xxwk2_releaseid LIKE schd_rlse_id LABEL "日程版本"
    FIELDS xxwk2_fob       LIKE po_fob
    FIELDS xxwk2_beg_dt    AS   DATE         LABEL "起始日期"
    FIELDS xxwk2_end_dt    AS   DATE         LABEL "结束日期"
    FIELDS xxwk2_curr      LIKE glt_curr     LABEL "币种"
    FIELDS xxwk2_amt       LIKE glt_amt      LABEL "金额"
    INDEX xxwk2_idx1 xxwk2_ponbr
    .

DEF TEMP-TABLE xxwk3
    FIELDS xxwk3_ponbr      LIKE po_nbr
    FIELDS xxwk3_poline    LIKE pod_line
    FIELDS xxwk3_shpdate    AS DATE            LABEL "发运日期"
    FIELDS xxwk3_duedate    AS DATE            LABEL "到货日期"
    FIELDS xxwk3_fp         AS CHAR            LABEL "F/P"
    FIELDS xxwk3_qty        LIKE tr_qty_loc    LABEL "数量"
    FIELDS xxwk3_price      LIKE pt_price      LABEL "价格"
    FIELDS xxwk3_amt        LIKE glt_amt       LABEL "金额"
    FIELDS xxwk3_lddays     LIKE pod_translt_days LABEL "运输提前期"
    INDEX  xxwk3_idx1 xxwk3_poline xxwk3_duedate.
    .

DEF TEMP-TABLE xxwk1 rcode-information
    FIELDS xxwk1_seq        AS INTEGER         LABEL "序"           FORMAT ">>>9"
    FIELDS xxwk1_part       LIKE pt_part       LABEL "零件号"
    FIELDS xxwk1_desc       LIKE pt_desc1      LABEL "零件名称"
    FIELDS xxwk1_org        AS CHAR            LABEL "产地"
    FIELDS xxwk1_model      AS CHAR            label "机型"
    FIELDS xxwk1_mot        AS CHAR            LABEL "运输方式"
    FIELDS xxwk1_fobpt      AS CHAR            LABEL "FOB地点"
    FIELDS xxwk1_beg_cumdat AS DATE            LABEL "累计起始日期"
    FIELDS xxwk1_end_cumdat AS DATE            LABEL "累计结束日期"
    FIELDS xxwk1_ord_cumqty LIKE pod_qty_ord   LABEL "累计订货量"
    FIELDS xxwk1_rct_cumqty LIKE pod_qty_ord   LABEL "累计收货量"
    FIELDS xxwk1_price      LIKE pt_price      LABEL "价格"
    FIELDS xxwk1_curr       AS CHAR            LABEL "币种"
    FIELDS xxwk1_ponbr      AS CHAR            LABEL "采购单"
    FIELDS xxwk1_poline     AS INTEGER         LABEL "行"
    FIELDS xxwk1_rlse_id    LIKE schd_rlse_id  LABEL "发布号"

    FIELDS xxwk1_msg        AS CHAR INITIAL "" LABEL "检查提示"  FORMAT "x(20)"
    INDEX xxwk1_idx1 xxwk1_ponbr xxwk1_poline
    INDEX xxwk1_idx2 xxwk1_ponbr xxwk1_part
    .



/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
FORM
    RECT-FRAME       AT ROW 1.4 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
    SKIP(.1)  /*GUI*/
    v_ponbr    LABEL "订单"          COLON 20
    v_ship_fr  LABEL "供应商"        COLON 20  v_description[1] NO-LABEL SKIP
    v_ship_to  LABEL "收货地点"      COLON 20  v_description[2] NO-LABEL SKIP
    v_buyer    LABEL "采购员"        COLON 20
    v_list_net  LABEL "显示未结数量" COLON 20
    v_list_fp   LABEL "状态(空/P/F)"  FORMAT "x(1)" COLON 20
    v_list_zero LABEL "显示0数量"     COLON 20
    v_noexport  LABEL "仅显示未下载" COLON 20
    v_releaseid LABEL "显示版本"     COLON 20
    v_datefmt   LABEL "日期格式"     COLON 20
                VALIDATE(LOOKUP(v_datefmt, "mm/dd/yy,dd/mm/yy,yy/mm/dd") <> 0 , "Please input mm/dd/yy or dd/mm/yy or yy/mm/dd")
    SKIP
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



DEFINE FRAME WaitingFrame
        "处理中，请稍候..."
        SKIP
WITH VIEW-AS DIALOG-BOX.


RUN xxpro-initial (OUTPUT v_sys_status).

REPEAT:
    VIEW FRAME a.

    RUN xxpro-input (OUTPUT v_sys_status).
    IF v_sys_status <> "0" THEN LEAVE.
    RUN xxpro-build (OUTPUT v_sys_status).
    FIND FIRST xxwk1 NO-LOCK NO-ERROR.
    IF NOT AVAILABLE xxwk1 THEN DO:
        MESSAGE "无数据,不能输出." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        NEXT.
    END.
    /*review*/
    {mfselprt.i "terminal" 80}

        FOR EACH xxwk2 NO-LOCK:
            DISP
            xxwk2_ponbr
            xxwk2_contract
            xxwk2_shipfr
            xxwk2_name_fr
            xxwk2_shipto
            xxwk2_name_to
            xxwk2_releaseid
            xxwk2_fob
            xxwk2_beg_dt
            xxwk2_end_dt
            xxwk2_curr
            xxwk2_amt
            WITH FRAME f-a 2 COLUMNS width 200 STREAM-IO.

            FOR EACH xxwk1 NO-LOCK WHERE xxwk1_ponbr = xxwk2_ponbr:
                DISP
                xxwk1_part
                xxwk1_desc
                xxwk1_poline
                xxwk1_rlse_id
                xxwk1_org
                xxwk1_model
                xxwk1_mot
                xxwk1_beg_cumdat
                xxwk1_end_cumdat
                xxwk1_ord_cumqty
                xxwk1_rct_cumqty
                WITH WITH FRAME f-b WIDTH 250 DOWN STREAM-IO.
                FOR EACH xxwk3 NO-LOCK WHERE xxwk3_ponbr = xxwk1_ponbr AND xxwk3_poline = xxwk1_poline:
                    DISP
                    space(12)
                    xxwk3_shpdate
                    xxwk3_duedate
                    xxwk3_fp
                    xxwk3_qty
                    xxwk3_price
                    xxwk3_amt
                    WITH FRAME f-c DOWN width 120 STREAM-IO.
                END.
            END.
        END.
    {mfreset.i}
    {mfgrptrm.i} /*Report-to-Window*/

    /*save to excel*/
    v_fname = "".
    SYSTEM-DIALOG GET-FILE v_fname
            TITLE "请输入要保存文件的名称..."
            FILTERS "Source Files (*.xls)"   "*.xls"
            /*MUST-EXIST*/
            SAVE-AS
            USE-FILENAME
            UPDATE v_ok.
    IF v_ok = TRUE THEN DO:
            IF v_fname MATCHES ".xls" THEN v_fname = v_fname + ".xls".
            VIEW FRAME waitingframe.
            RUN xxpro-excel  (OUTPUT v_sys_status).
            HIDE FRAME waitingframe NO-PAUSE.
            MESSAGE "输出完毕，要预览吗" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO TITLE "" UPDATE choice AS LOGICAL.
            IF choice = YES THEN DO:
                RUN xxpro-excel-view.
            END.
    END.
    ELSE DO:
            MESSAGE "未指定文件名称,不能输出." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    END.
END.


/*---------------------------*/
PROCEDURE xxpro-initial:
    DEF OUTPUT PARAMETER p_sys_status AS CHAR.
    p_sys_status = "".
    v_datefmt = "dd/mm/yy".
    v_description = "".
    p_sys_status = "0".
END PROCEDURE.
/*---------------------------*/
PROCEDURE xxpro-input:
    DEF OUTPUT PARAMETER p_sys_status AS CHAR.
    p_sys_status = "".

    v_description = "".
    UPDATE
        v_ponbr
        v_buyer

        v_list_net
        v_list_fp
        v_list_zero

        v_noexport
        v_releaseid
        v_datefmt
    WITH FRAME a EDITING :

        if frame-field = "v_ponbr" then do:
/* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i scx_ref v_ponbr
                 " scx_domain = global_domain and scx_type = 2 and
                 scx_po "  v_ponbr scx_po scx_po}

         if recno <> ? then do:
            assign v_description[1] = ""
                   v_description[2] = "".
            find first vd_mstr no-lock where vd_domain = global_domain and
                       vd_addr = scx_shipfrom no-error.
            if available vd_mstr then do:
               assign v_ship_fr = scx_shipfrom
                      v_description[1] = vd_sort.
            end.
            find first si_mstr no-lock where si_domain = global_domain and
                       si_site = scx_shipto no-error.
            if available si_mstr then do:
               assign v_ship_to = scx_shipto
                      v_description[2] = si_desc.
            end.
            display scx_po @ v_ponbr
                    v_ship_fr v_description[1]
                    v_ship_to v_description[2]
            with frame a.
         end.
        END.
        ELSE DO:
            status input.
            readkey.
            apply lastkey.
        END.
    END.
    assign v_ponbr v_ship_fr v_ship_to.
    FIND FIRST ad_mstr WHERE ad_domain = global_domain and ad_addr = v_ship_fr NO-LOCK NO-ERROR.
    IF AVAILABLE ad_mstr THEN DISPLAY ad_name @ v_description[1] WITH FRAME a.
    FIND FIRST ad_mstr WHERE ad_domain = global_domain and ad_addr = v_ship_to NO-LOCK NO-ERROR.
    IF AVAILABLE ad_mstr THEN DISPLAY ad_name @ v_description[2] WITH FRAME a.

   IF v_ponbr = "" AND v_ship_fr = "" THEN DO:
       UNDO, RETRY.
   END.
    p_sys_status = "0".
END PROCEDURE.
/*---------------------------*/
PROCEDURE xxpro-excel:

    DEF OUTPUT PARAMETER p_sys_status AS CHAR.
    p_sys_status = "".

    DEF VAR chExcel AS COM-HANDLE.
    DEF VAR chWorkbook AS COM-HANDLE.
    DEF VAR chWorksheet AS COM-HANDLE.

    DEF VAR i   AS INTEGER.
    DEF VAR j   AS INTEGER.
    DEF VAR k   AS INTEGER.

    CREATE "Excel.Application" chExcel.

    chWorkbook =  chExcel:Workbooks:ADD().
    chExcel:visible = NO.
    k = 0.
    FOR EACH xxwk2 NO-LOCK:
        k = k + 1.
        chWorkSheet = chWorkbook:workSheets(k).
        chWorkSheet:NAME = xxwk2_ponbr.
        chWorksheet:COLUMNS:Font:SIZE = 10.
        DO j = 1 TO 10:
            chWorkSheet:COLUMNS(j):NumberFormatLocal = "@".
        END.

        /*header*/
        i = 1.
        chWorkbook:worksheets(K):cells(i,1):Font:SIZE = 16.
        chWorkbook:worksheets(K):cells(i,1):Font:BOLD = TRUE.
        chWorkSheet:range("A" + string(i) + ":" + "D" + STRING(i)):merge().
        chWorkbook:worksheets(K):cells(i,1):value = "采购日程单".

        chWorkbook:worksheets(K):cells(i,6):Font:BOLD = TRUE.
        chWorkbook:worksheets(K):cells(i,6):value = "日期".
        chWorkbook:worksheets(K):cells(i,7):NumberFormatLocal = v_datefmt.
        chWorkbook:worksheets(K):cells(i,7):value = TODAY.

        i = 2.
        chWorkbook:worksheets(K):cells(i,1):Font:BOLD = TRUE.
        chWorkbook:worksheets(K):cells(i,1):value = "采购单".
        chWorkbook:worksheets(K):cells(i,2):value = xxwk2_ponbr.

        chWorkbook:worksheets(K):cells(i,6):Font:BOLD = TRUE.
        chWorkbook:worksheets(K):cells(i,6):value = "合同号".
        chWorkbook:worksheets(K):cells(i,7):value = xxwk2_contract.

        i = 3.
        chWorkbook:worksheets(K):cells(i,1):Font:BOLD = TRUE.
        chWorkbook:worksheets(K):cells(i,1):value = "供应商".
        chWorkbook:worksheets(K):cells(i,2):value = xxwk2_shipfr.
        chWorkbook:worksheets(K):cells(i,3):value = xxwk2_name_fr.

        i = 4.
        chWorkbook:worksheets(K):cells(i,1):Font:BOLD = TRUE.
        chWorkbook:worksheets(K):cells(i,1):value = "收货地点".
        chWorkbook:worksheets(K):cells(i,2):value = xxwk2_shipto.
        chWorkbook:worksheets(K):cells(i,3):value = xxwk2_name_to.

        i = 5.
        chWorkbook:worksheets(K):cells(i,1):Font:BOLD = TRUE.
        chWorkbook:worksheets(K):cells(i,1):value = "日程版本".
        chWorkbook:worksheets(K):cells(i,2):value = xxwk2_releaseid.

        chWorkbook:worksheets(K):cells(i,6):Font:BOLD = TRUE.
        chWorkbook:worksheets(K):cells(i,6):value = "FOB".
        chWorkbook:worksheets(K):cells(i,7):value = xxwk2_FOB.

        i = 6.
        chWorkbook:worksheets(K):cells(i,1):Font:BOLD = TRUE.
        chWorkbook:worksheets(K):cells(i,1):value = "起始日期".
        chWorkbook:worksheets(K):cells(i,2):NumberFormatLocal = v_datefmt.
        chWorkbook:worksheets(K):cells(i,2):value = xxwk2_beg_dt.

        chWorkbook:worksheets(K):cells(i,6):Font:BOLD = TRUE.
        chWorkbook:worksheets(K):cells(i,6):value = "结束日期".
        chWorkbook:worksheets(K):cells(i,7):NumberFormatLocal = v_datefmt.
        chWorkbook:worksheets(K):cells(i,7):value = xxwk2_end_dt.

        i = 7.
        chWorkbook:worksheets(K):cells(i,1):Font:BOLD = TRUE.
        chWorkbook:worksheets(K):cells(i,1):value = "币种".
        chWorkbook:worksheets(K):cells(i,2):value = xxwk2_curr.

        chWorkbook:worksheets(K):cells(i,6):Font:BOLD = TRUE.
        chWorkbook:worksheets(K):cells(i,6):value = "金额".
        chWorkbook:worksheets(K):cells(i,7):value = xxwk2_amt.

        /*body*/
        i = 9.
        chWorkSheet:range("A" + string(i) + ":" + "B" + string(i)):merge().
        chWorkSheet:range("C" + string(i) + ":" + "D" + string(i)):merge().
        DO j = 1 TO 11:
            chWorkbook:worksheets(K):cells(i,j):Borders(7):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(K):cells(i,j):Borders(7):Weight = 2.      /*  Hairline border's weight */
            chWorkbook:worksheets(K):cells(i,j):Borders(8):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(K):cells(i,j):Borders(8):Weight = 2.      /*  Hairline border's weight */
            chWorkbook:worksheets(K):cells(i,j):Borders(9):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(K):cells(i,j):Borders(9):Weight = 2.      /*  Hairline border's weight */
            chWorkbook:worksheets(K):cells(i,j):Borders(10):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(K):cells(i,j):Borders(10):Weight = 2.      /*  Hairline border's weight */
        END.
        chWorkbook:worksheets(K):cells(i,1):Font:BOLD = TRUE.
        chWorkbook:worksheets(K):cells(i,1):value = "零件".
        chWorkbook:worksheets(K):cells(i,3):Font:BOLD = TRUE.
        chWorkbook:worksheets(K):cells(i,3):value = "描述".
        chWorkbook:worksheets(K):cells(i,5):Font:BOLD = TRUE.
        chWorkbook:worksheets(K):cells(i,5):value = "发运日期".
        chWorkbook:worksheets(K):cells(i,6):Font:BOLD = TRUE.
        chWorkbook:worksheets(K):cells(i,6):value = "到货日期".
        chWorkbook:worksheets(K):cells(i,7):Font:BOLD = TRUE.
        chWorkbook:worksheets(K):cells(i,7):value = "确认".
        chWorkbook:worksheets(K):cells(i,8):Font:BOLD = TRUE.
        chWorkbook:worksheets(K):cells(i,8):value = "数量".
        chWorkbook:worksheets(K):cells(i,9):Font:BOLD = TRUE.
        chWorkbook:worksheets(K):cells(i,9):value = "单价".
        chWorkbook:worksheets(K):cells(i,10):Font:BOLD = TRUE.
        chWorkbook:worksheets(K):cells(i,10):value = "金额".
        chWorkbook:worksheets(K):cells(i,11):Font:BOLD = TRUE.
        chWorkbook:worksheets(K):cells(i,11):value = "运输提前期".

        FOR EACH xxwk1 NO-LOCK
            WHERE xxwk1_ponbr = xxwk2_ponbr BY xxwk1_part:
            FOR EACH xxwk3 NO-LOCK
                WHERE xxwk3_ponbr = xxwk1_ponbr
                AND xxwk3_poline = xxwk1_poline
                BY xxwk3_duedate:

                i = i + 1.
                chWorkSheet:range("A" + string(i) + ":" + "B" + string(i)):merge().
                chWorkSheet:range("C" + string(i) + ":" + "D" + string(i)):merge().

                chWorkbook:worksheets(k):cells(i,1):value = xxwk1_part.
                chWorkbook:worksheets(k):cells(i,3):value = xxwk1_desc.
                chWorkbook:worksheets(K):cells(i,5):NumberFormatLocal = v_datefmt.
                chWorkbook:worksheets(k):cells(i,5):value = xxwk3_shpdate.
                chWorkbook:worksheets(K):cells(i,6):NumberFormatLocal = v_datefmt.
                chWorkbook:worksheets(k):cells(i,6):value = xxwk3_duedate.
                chWorkbook:worksheets(k):cells(i,7):value = xxwk3_fp.
                chWorkbook:worksheets(k):cells(i,8):value = xxwk3_qty.
                chWorkbook:worksheets(k):cells(i,9):value = xxwk3_price.
                chWorkbook:worksheets(k):cells(i,10):value = xxwk3_amt.
                chWorkbook:worksheets(k):cells(i,11):value = xxwk3_lddays.
            END.
        END.

        /*foot*/
        i = i + 1.
        DO j = 1 TO 11:
            chWorkbook:worksheets(K):cells(i,j):Borders(8):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(K):cells(i,j):Borders(8):Weight = 2.      /*  Hairline border's weight */
        END.
        chWorkbook:worksheets(k):cells(i,9):value = "合计:".
        chWorkbook:worksheets(k):cells(i,10):value = xxwk2_amt.




    END. /*each wk2*/

    chExcel:DisplayAlerts = FALSE.
    chWorkbook:SaveAs(v_fname,, , ,,,).
    chWorkbook:CLOSE.
    chExcel:QUIT.

    RELEASE OBJECT chWorksheet.
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chExcel.

    p_sys_status = "0".
END PROCEDURE.



/*---------------------------*/
PROCEDURE xxpro-build:
    DEF OUTPUT PARAMETER p_sys_status AS CHAR.
    p_sys_status = "".

    DEF VAR i AS INTEGER.
    DEF VAR v_net_qty LIKE tr_qty_loc.
    DEF VAR v_cum_qty LIKE tr_qty_loc.

    i = 0.
    FOR EACH xxwk1:
        DELETE xxwk1.
    END.
    FOR EACH xxwk2:
        DELETE xxwk2.
    END.
    FOR EACH xxwk3:
        DELETE xxwk3.
    END.


    FOR EACH po_mstr
        WHERE po_domain = global_domain and (po_vend = v_ship_fr OR v_ship_fr = "")
        AND (po_sched = YES)
        AND (po_nbr = v_ponbr OR v_ponbr = "")
        AND (po_buyer = v_buyer OR v_buyer = "")
        NO-LOCK:


        FOR EACH pod_det NO-LOCK
            WHERE pod_domain = global_domain and pod_nbr = po_nbr /*AND pod_site = v_ship_to*/
            AND pod_sched = YES
            /*AND (pod_start_eff[1] >= TODAY OR pod_start_eff[1] = ?)
            AND (pod_end_eff[1] >= TODAY OR pod_end_eff[1] = ?)*/
            :
            IF v_releaseid <> "" THEN do:
                IF pod_curr_rlse_id[1] <> v_releaseid THEN NEXT.
            END.
            FIND FIRST sch_mstr
                where sch_domain = global_domain and sch_type = 4
                and sch_rlse_id = pod_curr_rlse_id[1]
                and sch_nbr = pod_nbr
                and sch_line = pod_line
                NO-LOCK NO-ERROR.
            IF AVAILABLE sch_mstr THEN do:
                IF sch_ship <> "" AND v_noexport = YES THEN NEXT.
            END.
            FOR each schd_det NO-LOCK
                where schd_domain = global_domain and schd_type = 4
                and schd_rlse_id = pod_curr_rlse_id[1]
                and schd_nbr = pod_nbr
                and schd_line = pod_line :


                IF v_list_net = YES THEN v_net_qty = max(min(schd_discr_qty, schd_cum_qty - pod_cum_qty[1]),0).
                ELSE v_net_qty = schd_discr_qty.

                IF v_list_zero = NO AND v_net_qty = 0 THEN NEXT.
                IF NOT (schd_fc_qual = v_list_fp OR v_list_fp = "") THEN NEXT.

                FIND FIRST xxwk2 WHERE xxwk2_ponbr = po_nbr NO-ERROR.
                IF NOT AVAILABLE xxwk2 THEN DO:
                    CREATE xxwk2.
                    ASSIGN
                        xxwk2_ponbr  = po_nbr
                        xxwk2_shipfr = po_vend
                        xxwk2_shipto = pod_site
                        xxwk2_contract = po_contract
                        xxwk2_curr    = po_curr
                        xxwk2_fob     = po_fob
                        xxwk2_releaseid = schd_rlse_id.
                    xxwk2_beg_dt  = sch_eff_start.
                    xxwk2_end_dt  = sch_eff_end.


                    xxwk2_name_fr = f-getaddata(xxwk2_shipfr, "Name").
                    xxwk2_name_to = f-getaddata(xxwk2_shipto, "Name").

                END.
                FIND FIRST xxwk1 WHERE xxwk1_ponbr = po_nbr
                    AND xxwk1_poline = pod_line
                    NO-ERROR.
                IF NOT AVAILABLE xxwk1 THEN DO:
                    CREATE xxwk1.
                    ASSIGN
                        xxwk1_ponbr = pod_nbr
                        xxwk1_poline  = pod_line
                        xxwk1_part = pod_part
                        xxwk1_rlse_id = schd_rlse_id
                        xxwk1_rct_cumqty = pod_cum_qty[1]
                        xxwk1_ord_cumqty = schd_cum_qty
                        xxwk1_beg_cumdat = pod_start_eff[1]
                        xxwk1_end_cumdat = pod_end_eff[1]
                        .
                    xxwk1_org     = f-getpartdata(pod_part, "pt__chr03").
                    xxwk1_desc = f-getpartdata(pod_part, "pt_desc1").
                    xxwk1_mot  = f-getpartdata(pod_part, "pt__chr04").
                    xxwk1_model     = f-getpartdata(pod_part, "pt__chr01").
                    xxwk1_fobpt   = f-getpartdata(pod_part, "pt__chr02").

                END.
                CREATE xxwk3.
                ASSIGN
                    xxwk3_ponbr =  po_nbr
                    xxwk3_poline = pod_line
                    xxwk3_duedate  = schd_date
                    xxwk3_shpdate  = schd_date - pod_translt_days
                    xxwk3_qty   = v_net_qty.
                IF schd_fc_qual = "F" THEN xxwk3_fp    = "YES".

                xxwk3_lddays  = pod_translt_days.
                xxwk3_price = f-getpoprice(pod_nbr, pod_line,xxwk3_duedate,xxwk3_qty).
                xxwk3_amt = xxwk3_qty * xxwk3_price.

                ASSIGN xxwk2_amt = xxwk2_amt + xxwk3_amt.

            END.
        END.
    END.
    p_sys_status = "0".
END PROCEDURE.
/*-----------------------*/
PROCEDURE xxpro-excel-view:
    DEF VAR chExcel AS COM-HANDLE.
    DEF VAR chWorkbook AS COM-HANDLE.
    DEF VAR chWorksheet AS COM-HANDLE.

    CREATE "Excel.Application" chExcel.
    chExcel:VISIBLE = YES.
    chWorkbook = chExcel:Workbooks:Open(v_fname).
    chWorkSheet = chWorkbook:workSheets(1).

    MESSAGE "关闭EXCEL，返回" VIEW-AS ALERT-BOX BUTTONS OK.
    /* Perform housekeeping and cleanup steps */
    chExcel:Application:Workbooks:CLOSE() NO-ERROR.
    chExcel:Application:QUIT NO-ERROR.

    RELEASE OBJECT chWorksheet.
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chExcel.
END PROCEDURE.
