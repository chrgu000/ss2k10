/**-----------------------------------------------**
 @File: yysopusld
 @Description: upload po shipper from excel
 @Version: 1.0
 @Author: James Zou
 @Created: 2008-12-03
 @Mfgpro: eb2sp7
 @Parameters:
 @BusinessLogic:
 @data file format:
**-----------------------------------------------**/

/* DISPLAY TITLE */
{mfdtitle.i "820"}

DEF VAR v_ok         AS LOGICAL.
DEF VAR v_confirm    AS LOGICAL.
DEF VAR v_sys_status AS integer.
DEF VAR v_flag       AS CHAR.

DEF VAR v_fexcel     AS CHAR FORMAT "x(72)".
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
DEF VAR v_um         LIKE pt_um INITIAL "".
DEF VAR v_loc_iss    LIKE loc_loc INITIAL "".
DEF VAR v_linecode   AS INTEGER INITIAL "52".
DEF VAR v_ord_nbr LIKE so_nbr.
DEF VAR v_mod_list   AS LOGICAL INITIAL NO NO-UNDO.

def var vSn as integer initial 1.
define temp-table xxcsv
    fields csv_sn as integer
    fields csv_data as character format "x(320)".

DEFINE TEMP-TABLE xxwk3
    FIELDS xxwk3_asn_nbr      AS CHAR LABEL "PUS编号" FORMAT "x(10)"
    FIELDS xxwk3_ord_nbr      LIKE so_nbr
    FIELDS xxwk3_shipfr       LIKE so_site label "发货地点"
    FIELDS xxwk3_shipto       LIKE so_cust LABEL "收货地点"
    FIELDS xxwk3_name_shipfr  LIKE ad_name LABEL "名称"
    FIELDS xxwk3_name_shipto  LIKE ad_name LABEL "名称"
    FIELDS xxwk3_mfg_shipfr   LIKE so_site LABEL "发货地点"
    FIELDS xxwk3_mfg_shipto   LIKE po_site LABEL "收货地点"
    FIELDS xxwk3_date         LIKE tr_date LABEL "到货日期"
    FIELDS xxwk3_err          AS LOGICAL INITIAL NO LABEL "错误标识"
    .
DEF TEMP-TABLE xxwk1
    FIELDS xxwk1_seq     AS INTEGER FORMAT ">>>9" COLUMN-LABEL "序号"
    FIELDS xxwk1_part    LIKE pt_part      COLUMN-LABEL "零件号"
    FIELDS xxwk1_partx   LIKE pt_part      COLUMN-LABEL "客户零件号"
    FIELDS xxwk1_desc    LIKE pt_desc1 FORMAT "x(24)"
    FIELDS xxwk1_qty_ord LIKE schd_upd_qty COLUMN-LABEL "订单数"
    FIELDS xxwk1_qty_chk LIKE schd_upd_qty COLUMN-LABEL "承诺数"
    FIELDS xxwk1_qty_rct LIKE schd_upd_qty COLUMN-LABEL "实发数"
    FIELDS xxwk1_loc     LIKE ld_loc       COLUMN-LABEL "库位"
    FIELDS xxwk1_ord_nbr LIKE po_nbr       COLUMN-LABEL "订单"
    FIELDS xxwk1_ord_ln  LIKE pod_line     COLUMN-LABEL "订单行"
    FIELDS xxwk1_site    LIKE pod_site     COLUMN-LABEL "地点"
    FIELDS xxwk1_um      LIKE pod_um       COLUMN-LABEL "单位"
    INDEX xxwk1_idx1 xxwk1_part
    .
FUNCTION str2Date RETURNS DATE(INPUT datestr AS CHARACTER
                              ,INPUT fmt AS CHARACTER) forward.
DEF TEMP-TABLE xxwk4
    FIELDS xxwk4_line   AS INTEGER LABEL "Ln" FORMAT ">>>>"
    FIELDS xxwk4_error  AS CHAR    LABEL "Stat" FORMAT "x(60)"
    .
DEF STREAM s1.
{gpcdget.i "UT"}
FORM
    v_fexcel LABEL "上载文件" COLON 10 view-as fill-in size 40 by 1
    SKIP
/*    v_sheet LABEL "工作薄号"  COLON 10   */
    SKIP
    v_um  COLON 10       LABEL "缺省单位"
    v_loc_iss COLON  10  LABEL "缺省库位"
    v_ord_nbr COLON 10   LABEL   "销售单"
/*    v_linecode COLON 10  LABEL "起始行"
    v_mod_list COLON 10 LABEL "维护替换" */
    WITH FRAME a SIDE-LABELS WIDTH 80.
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
display v_fexcel with frame a.

FORM
    xxwk1_part    COLUMN-LABEL "零件号"
    xxwk1_partx   COLUMN-LABEL "客户零件号"
    xxwk1_desc    COLUMN-LABEL "描述"
    xxwk1_qty_ord COLUMN-LABEL "订单数"
    with row 12 centered overlay down frame f-x width 80 TITLE "[Enter]修改".


RUN xxpro-initial (OUTPUT v_sys_status).
v_ord_nbr = "11000001".

v_linecode  = 52.

REPEAT:
    UPDATE
     v_fexcel
        WITH FRAME a.
     v_ok = YES.
    IF v_fexcel = "" THEN DO:
/*85*        v_ok = NO.                                                      */
/*85*        SYSTEM-DIALOG GET-FILE v_fexcel                                 */
/*85*            TITLE "请选择数据文件..."                                   */
/*85*            FILTERS "Source Files (*.xls)"   "*.xls"                    */
/*85*            INITIAL-DIR v_fdir                                          */
/*85*            MUST-EXIST                                                  */
/*85*            USE-FILENAME                                                */
/*85*            UPDATE v_ok.                                                */
/*85*        DISP v_fexcel WITH FRAME a.                                     */
       {mfmsg.i 7722 3}
       undo,retry.
    END.
    if search(v_fexcel) = "" or search(v_fexcel) = ? then do:
       {mfmsg.i 53 3}
       undo,retry.
    end.
    do transaction:
    find first usrw_wkfl exclusive-lock where usrw_domain = global_domain
           and usrw_key1 = global_userid and usrw_key2 = execname no-error.
    if not available usrw_wkfl then do:
       create usrw_wkfl. usrw_domain = global_domain.
       assign usrw_key1 = global_userid
              usrw_key2 = execname.
    end.
    if usrw_charfld[1] <> v_fexcel and not locked(usrw_wkfl) then do:
       assign usrw_charfld[1] = v_fexcel.
    end.
    release usrw_wkfl.
    end.
    IF v_ok = YES THEN DO:
        UPDATE
/*          v_sheet   */
            v_um
            v_loc_iss
            v_ord_nbr
/*          v_linecode
            v_mod_list */
            WITH FRAME a.
    END.
    ELSE DO:
        UNDO, RETRY.
    END.
    FIND FIRST so_mstr WHERE so_domain = global_domain
           and so_nbr = v_ord_nbr NO-LOCK NO-ERROR.
    IF NOT AVAILABLE so_mstr THEN DO:
       {pxmsg.i &MSGTEXT=""订单不存在,请重新输入订单号..."" &ERRORLEVEL=3}
        UNDO, RETRY.
    END.
    IF v_fexcel = "" THEN UNDO, RETRY.

    RUN xxpro-csv (OUTPUT v_sys_status).
    if v_sys_status = 41 then do:
       {pxmsg.i &MSGTEXT=""这不是PUS单,不能上载."" ERRORLEVEL=3}
       undo,retry.
    end.
    if v_sys_status = 42 then do:
        {pxmsg.i &MSGTEXT=""PUS单流水号为空,不能上载."" &ERRORLEVEL=3}
        undo,retry.
    end.
    FIND FIRST xxwk3 NO-LOCK NO-ERROR.
    IF NOT AVAILABLE xxwk3 THEN UNDO, RETRY.
/*
    IF v_mod_list = YES THEN DO:
        RUN xxpro-mod-list.
        HIDE FRAME f-x NO-PAUSE.
    END.
    /*review*/
*/
    {mfselprt.i "terminal" 80}

    RUN xxpro-check.
    FIND FIRST xxwk4 NO-LOCK NO-ERROR.
    IF AVAILABLE xxwk4 THEN DO:
        FIND FIRST xxwk3 NO-ERROR.
        IF AVAILABLE xxwk3 THEN ASSIGN xxwk3_err = YES.
    END.
    RUN xxpro-report.
    {mfreset.i}

    FIND FIRST xxwk3.
    IF xxwk3_err = YES THEN DO:
      /* 数据存在错误,不能上载 */
        {pxmsg.i &MSGNUM=2486 &MSGARG1=v_fexcel &ERRORLEVEL=3}
        undo,retry.
    END.
    ELSE DO:
        v_confirm = NO.
      /* "确认要上载所显示的数据" */
        {pxmsg.i &MSGNUM=12 &CONFIRM=v_confirm}
        IF v_confirm = YES THEN DO:
            RUN xxpro-load  (OUTPUT v_sys_status).
        END.
    END.
END.


/*---------------------------*/
PROCEDURE xxpro-initial:
    DEF OUTPUT PARAMETER p_sys_status AS integer.
    v_ok = no.
    v_fexcel = "".
    p_sys_status = 0.
    v_fdir = "".
    v_flag = "".
    find first usrw_wkfl no-lock where usrw_domain = global_domain
           and usrw_key1 = global_userid and usrw_key2 = execname no-error.
    if available usrw_wkfl then do:
       v_fexcel = usrw_charfld[1].
   end.
END PROCEDURE.

Procedure xxpro-csv:
    DEF OUTPUT PARAMETER p_sys_status AS integer.
    def var vchk as character.
    p_sys_status = 0.
    FOR EACH xxcsv exclusive-lock: DELETE xxcsv. END.
    FOR EACH xxwk1 exclusive-lock: DELETE xxwk1. END.
    FOR EACH xxwk3 exclusive-lock: DELETE xxwk3. END.
    INPUT FROM VALUE(v_fexcel).
    ASSIGN vSn = 1.
    REPEAT:
      CREATE xxcsv.
      IMPORT UNFORMAT csv_data.
      assign csv_sn = vsn.
      vsn = vSn + 1.
    END.
    INPUT CLOSE.
    for each xxcsv exclusive-lock where vsn = 0:
        delete xxcsv.
    end.

    vchk = "Delivery Information".
    for each xxcsv no-lock:
        if index(csv_data,vchk) > 0 then do:
           assign vchk = "".
           leave.
        end.
    end.
    if vchk <> "" then do:
         p_sys_status = 41.
        LEAVE.
    END.
    for each xxcsv no-lock:
        if index(csv_data,"PUS NO.") > 0 then do:
           assign vchk = trim(substring(csv_data,index(csv_data,"编号") + 2,12)).
           assign vchk = substring(vchk,1,9).
           leave.
        end.
    end.
    IF vchk= "" THEN DO:
        p_sys_status = 42.
        LEAVE.
    END.
    CREATE xxwk3.
    ASSIGN
        xxwk3_asn_nbr = vchk    /**???**/
        xxwk3_ord_nbr = v_ord_nbr.
    FIND FIRST so_mstr WHERE so_domain = global_domain and
               so_nbr = xxwk3_ord_nbr NO-LOCK NO-ERROR.
    IF AVAILABLE so_mstr THEN DO:
        ASSIGN xxwk3_shipto = so_cust.
    END.
    find first xxcsv no-lock where index(csv_data,"Delivery Date") > 0 no-error.
    if available xxcsv then do:
       if entry(2,csv_data,",") = "" then assign vsn = csv_sn - 1.
       else assign vsn = csv_sn.
    end.
    xxwk3_date = today.
    find first xxcsv no-lock where csv_sn = vsn no-error.
    if available xxcsv then do:
       assign xxwk3_date = str2Date(entry(2 , csv_data , ",") , "mdy").
    end.
    for each xxcsv no-lock where index(csv_data,"Seq.") > 0 and index(csv_data,"Part No.") > 0:
        assign vSn = csv_sn.
    end.
    for each xxcsv no-lock where csv_sn > vsn:
        if entry(1,csv_data,",") = "" or entry(1,csv_data,",") = ? then leave.
        create xxwk1.
        assign
            xxwk1_ord_nbr   = v_ord_nbr
            xxwk1_seq       = integer(entry(1,csv_data,",")) /* ( INTEGER(v_data[1]) */
            xxwk1_partx     = entry(2,csv_data,",")          /* v_data[2]            */
            xxwk1_desc      = entry(3,csv_data,",")          /* v_data[3]            */
            xxwk1_qty_ord   = decimal(entry(4,csv_data,",")) /* decimal(v_data[4])   */
            xxwk1_qty_chk   = decimal(entry(5,csv_data,",")) /* decimal(v_data[5])   */
            xxwk1_qty_rct   = decimal(entry(6,csv_data,",")) /* decimal(v_data[6])   */
            .
        IF v_loc_iss <> "" THEN xxwk1_loc = v_loc_iss.
        IF v_um <> "" THEN xxwk1_um = v_um.
        xxwk1_part = xxwk1_partx.
        FIND cp_mstr WHERE cp_domain = global_domain and
             cp_cust = xxwk3_shipto AND
             cp_cust_part = xxwk1_partx NO-LOCK NO-ERROR.
        IF AVAILABLE cp_mstr THEN ASSIGN xxwk1_part = cp_part.
    end.
    p_sys_status = 0.
end.

/*---------------------------*/
PROCEDURE xxpro-check:
    EMPTY TEMP-TABLE xxwk4.

    DEF VAR i AS INTEGER.
    i = 0.
    FIND FIRST xxwk3 NO-ERROR.
    IF NOT AVAILABLE xxwk3 THEN DO:
        i = i + 1.
        CREATE xxwk4.
        ASSIGN
            xxwk4_line  = i
            xxwk4_error = "无收货单".
        NEXT.
    END.

    IF LENGTH(TRIM(xxwk3_asn_nbr)) <> 9 THEN DO:
        i = i + 1.
        CREATE xxwk4.
        ASSIGN
            xxwk4_line  = i
            xxwk4_error = "收货单单号长度必须为9位，且由数字组成".
    END.
    FIND FIRST so_mstr WHERE so_domain = global_domain and
               so_nbr = xxwk3_ord_nbr NO-LOCK NO-ERROR.
    IF AVAILABLE so_mstr THEN DO:
        xxwk3_mfg_shipfr = so_site.
        xxwk3_mfg_shipto = so_cust.
        xxwk3_shipto     = so_cust.
        FIND FIRST sod_det WHERE so_domain = global_domain and
                   sod_nbr = xxwk3_ord_nbr NO-LOCK NO-ERROR.
        IF AVAILABLE sod_det THEN ASSIGN xxwk3_mfg_shipfr = sod_site.
        xxwk3_shipfr     = xxwk3_mfg_shipfr.
    END.
    ELSE DO:
        i = i + 1.
        CREATE xxwk4.
        ASSIGN
            xxwk4_line  = i
            xxwk4_error = "订单不存在".
        NEXT.
    END.

    FIND FIRST ad_mstr WHERE ad_domain = global_domain and
               ad_addr = xxwk3_shipfr NO-LOCK NO-ERROR.
    IF AVAILABLE ad_mstr THEN ASSIGN xxwk3_name_shipfr = ad_name.
    FIND FIRST ad_mstr WHERE ad_domain = global_domain and
               ad_addr = xxwk3_shipto NO-LOCK NO-ERROR.
    IF AVAILABLE ad_mstr THEN ASSIGN xxwk3_name_shipto = ad_name.


    FOR EACH xxwk1 WHERE xxwk1_qty_rct <> 0:
        /*xxwk1_part = xxwk1_partx.*/
        FIND FIRST pt_mstr WHERE pt_domain = global_domain and
                   pt_part = xxwk1_part NO-LOCK NO-ERROR.
        IF NOT AVAILABLE pt_mstr THEN DO:
            FIND cp_mstr WHERE cp_domain = global_domain and
                 cp_cust = xxwk3_shipto AND cp_cust_part = xxwk1_partx NO-LOCK NO-ERROR.
            IF AVAILABLE cp_mstr THEN ASSIGN xxwk1_part = cp_part.
        END.
        FIND FIRST pt_mstr WHERE pt_domain = global_domain and
                   pt_part = xxwk1_part NO-LOCK NO-ERROR.
        IF AVAILABLE pt_mstr THEN do:
            IF xxwk1_desc = "" THEN ASSIGN  xxwk1_desc    = pt_desc1.
            IF xxwk1_um = ""   THEN ASSIGN  xxwk1_um = pt_um.
        END.
        IF xxwk1_ord_nbr <> "" THEN DO:
            FIND FIRST sod_det WHERE sod_domain = global_domain and
                       sod_nbr = xxwk1_ord_nbr AND sod_part = xxwk1_part NO-LOCK NO-ERROR.
            IF AVAILABLE sod_det THEN do:
                xxwk1_ord_ln = sod_line.
                xxwk1_site = sod_site.
                IF xxwk1_loc = "" THEN xxwk1_loc = sod_loc.
            END.
            ELSE DO:
                i = i + 1.
                CREATE xxwk4.
                ASSIGN
                    xxwk4_line  = i
                    xxwk4_error = "零件:" + xxwk1_part + "不属于订单:" + xxwk1_ord_nbr.
            END.
        END.
        IF xxwk1_loc = "" THEN DO:
            i = i + 1.
            CREATE xxwk4.
            ASSIGN
                xxwk4_line  = i
                xxwk4_error = "零件:" + xxwk1_part + "发货库位不存在,库位码为" + xxwk1_loc.
        END.
    END.

    FIND FIRST xxwk1 WHERE xxwk1_qty_rct <> 0 NO-LOCK NO-ERROR.
    IF NOT AVAILABLE xxwk1 THEN DO:
        i = i + 1.
        CREATE xxwk4.
        ASSIGN
            xxwk4_line  = i
            xxwk4_error = "没有要上载的数据".
        NEXT.
    END.
    IF xxwk3_asn_nbr = "" THEN DO:
        i = i + 1.
        CREATE xxwk4.
        ASSIGN
            xxwk4_line  = i
            xxwk4_error = "PUS单错误".
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

    /*check shipper existed*/
    find abs_mstr where abs_domain = global_domain
        and abs_mstr.abs_type = "S"
        AND abs_mstr.abs_shipfrom = xxwk3_shipfr
        and abs_mstr.abs_id = "S" + xxwk3_asn_nbr
    no-lock no-error.
    IF AVAILABLE ABS_mstr THEN DO:
        i = i + 1.
        CREATE xxwk4.
        ASSIGN
            xxwk4_line  = i
            xxwk4_error = "PUS单存在".
        NEXT.
    END.
    /*
    ELSE IF substring(abs_status,2,1) = "Y" THEN DO:
        i = i + 1.
        CREATE xxwk4.
        ASSIGN
            xxwk4_line  = i
            xxwk4_error = "发货单已确认".
        NEXT.
    END.*/
END PROCEDURE.

/*---------------------------*/
PROCEDURE xxpro-report:
    FOR EACH xxwk4:
        DISP xxwk4 WITH FRAME f-a DOWN WIDTH 100.
    END.
    FOR EACH xxwk3:
        DISP
            xxwk3_asn_nbr
            xxwk3_ord_nbr
            xxwk3_shipfr
            xxwk3_shipto
            xxwk3_name_shipfr
            xxwk3_name_shipto
            xxwk3_date
            xxwk3_err
        WITH FRAME f-b WIDTH 100 2 COLUMNS.
        FOR EACH xxwk1 WHERE xxwk1_qty_rct <> 0 BY xxwk1_seq:
            DISP
                xxwk1_seq
                xxwk1_part
                xxwk1_partx
                xxwk1_desc
                xxwk1_qty_ord
                xxwk1_qty_chk
                xxwk1_qty_rct
                xxwk1_um
                xxwk1_loc
                xxwk1_ord_ln
                WITH FRAME f-c WIDTH 150 DOWN.
        END.
    END.
END PROCEDURE.

/*---------------------------*/
PROCEDURE xxpro-load:
    DEF OUTPUT PARAMETER p_sys_status AS integer.
    p_sys_status = 0.
    DEF VAR v_fcimdat    AS CHAR.
    DEF VAR v_fcimlog    AS CHAR.
    DEF VAR v_fdata      AS CHAR.
    DEF VAR v_freport    AS CHAR.

    FIND FIRST xxwk3 NO-ERROR.
    IF NOT AVAILABLE xxwk3 THEN LEAVE.

    v_fdata   = "TMP_" + execname + string(year(today), "9999")
              + string(MONTH(today), "99") + string(DAY(today), "99")
              + STRING(TIME) + "sopus.dat".
    v_freport = v_fdata + ".rpt".
    v_fcimdat = v_fdata + ".cim".
    v_fcimlog = v_fdata + ".log".
    OUTPUT STREAM s1 CLOSE.
    OUTPUT STREAM s1 TO VALUE(v_fdata).
     /*shipper header*/
            put STREAM s1 UNFORMATTED
                '"S"'     SPACE(1)
                '- -' SPACE(1)
                '"' + xxwk3_shipfr + '"' SPACE(1)
                '"' + xxwk3_asn_nbr + '"' SPACE(1)
                '- - - -' SPACE(1)
                '"' + xxwk3_shipto + '"' space(1)
                '- - - - - - - - - - - - - - - -'
                SKIP.
    /**Item **/
       FOR EACH xxwk1 WHERE xxwk1_qty_rct <> 0:
           put STREAM s1 UNFORMATTED
           '"I"'  SPACE(1)
           '"' + xxwk3_shipfr + '"' SPACE(1)
           '"' + xxwk1_loc + '"' SPACE(1)
           '"' + xxwk3_shipfr + '"' SPACE(1)
           '-' SPACE(1)
           '"' + xxwk1_part + '"' SPACE(1)
           '- -' SPACE(1)
           xxwk1_qty_rct space(1)
           '-' SPACE(1)
           '"' + xxwk1_ord_nbr + '"' space(1)
           xxwk1_ord_ln  space(1)
           '"' + 'S' + xxwk3_asn_nbr + '"' SPACE(1)
           ' - '
           '"' + xxwk1_um + '"' SPACE(1)
           '- - - -' SPACE(1)
           '-' SPACE(1)
           ' - '
           ' - - - - - '
           SKIP.
       END.
    OUTPUT STREAM s1 CLOSE.
    RUN xxpro-cimload (INPUT v_fdata, INPUT v_freport).
    p_sys_status = 0.
END PROCEDURE.
/*-----------------------*/
PROCEDURE xxpro-cimload:
    DEF INPUT PARAMETER p_cimdat AS CHAR.
    DEF INPUT PARAMETER p_cimlog AS CHAR.
    DEF VAR   v-loadok  AS LOGICAL.
/**
    {gprun.i ""xxrcshgw.p"" "(input p_cimdat, input p_cimlog,
                              output v-loadok)"}
**/
    def var v_file as character.
    def var v_log   as character.
    def var oldlng as character.

    assign v_log = "TMP" + string(time,">>>>9").
    assign oldlng = global_user_lang.
    global_user_lang = "us".
    global_user_lang_dir = global_user_lang + "/".
    assign v_file = "TMP_" + execname + global_userid + string(time) + ".tmp".
    output to value(v_file + ".bpi.prn").
        if opsys = "unix" then put unformat 'F '.
        put unformat '"' p_cimdat '" Y' skip.
        put unformat '"' v_log '"' skip.
    output close.

    batchrun = yes.
    input from value(v_file + ".bpi.prn").
    output to value(v_file + ".bpo.prn").
    {gprun.i ""rcshgw.p""}
    output close.
    input close.
    batchrun = no.
    global_user_lang = oldlng.
    global_user_lang_dir = global_user_lang + "/".

    vSn = 1.
    empty temp-table xxwk4 no-error.
    input stream s1 through value('grep -i "error~\|shipper~\|created~\|item~\|added" ' + v_log + '.prn').
    repeat:
       create xxwk4.
       import stream s1 unformat xxwk4_error.
       assign xxwk4_line = vsn.
       assign vsn = vsn + 1.
    end.
    input stream s1 close.

    OS-DELETE VALUE(v_file + ".bpi.prn").
    OS-DELETE VALUE(v_file + ".bpo.prn").
    OS-DELETE VALUE(p_cimdat).
    OS-DELETE VALUE(v_log + ".prn").
    v-loadok = yes.
    for each xxwk4 no-lock with frame porc-log width 100:
        display xxwk4.
        if index(xxwk4_error,"error") > 0 then do:
           v-loadok = NO.
        end.
    end.
  /*
    IF v-loadok = NO THEN DO:
        MESSAGE "数据上载错误,请检查." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        UNDO, LEAVE.
    END.
    ELSE DO:
        IF SEARCH(p_cimdat) <> ? THEN OS-DELETE VALUE(p_cimdat).
        IF SEARCH(p_cimlog) <> ? THEN OS-DELETE VALUE(p_cimlog).
        MESSAGE "上载完毕." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    END.
  */
END PROCEDURE.

/* 日期YYYY-MM-DD转换为QAD日期格式 */
FUNCTION str2Date RETURNS DATE(INPUT datestr AS CHARACTER
                              ,INPUT fmt AS CHARACTER):
    DEFINE VARIABLE sstr AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iY   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iM   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE id   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE od   AS DATE      NO-UNDO.
    define variable spchar as character no-undo.
    define variable i as integer.
    if datestr = "" or datestr = "?" then do:
        assign od = ?.
    end.
    else do:
        if index(trim(datestr)," ") = 0 then do:
           ASSIGN sstr = datestr.
        end.
        else do:
           assign sstr = substring(trim(datestr),1,index(trim(datestr)," ") - 1).
        end.
        do i = 1 to length(sstr).
           if index("0123456789",substring(sstr,i,1)) = 0 then do:
              assign spchar = substring(sstr,i,1).
              leave.
           end.
        end.
        if lower(fmt) = "ymd" then do:
           ASSIGN iY = INTEGER(SUBSTRING(sstr,1,INDEX(sstr,spchar) - 1)).
           ASSIGN sstr = SUBSTRING(sstr,INDEX(sstr,spchar) + 1).
           ASSIGN iM = INTEGER(SUBSTRING(sstr,1,INDEX(sstr,spchar) - 1)).
           ASSIGN iD = INTEGER(SUBSTRING(sstr,INDEX(sstr,spchar) + 1)).
        end.
        else if lower(fmt) = "mdy" then do:
           ASSIGN iM = INTEGER(SUBSTRING(sstr,1,INDEX(sstr,spchar) - 1)).
           ASSIGN sstr = SUBSTRING(sstr,INDEX(sstr,spchar) + 1).
           ASSIGN iD = INTEGER(SUBSTRING(sstr,1,INDEX(sstr,spchar) - 1)).
           ASSIGN iY = INTEGER(SUBSTRING(sstr,INDEX(sstr,spchar) + 1)).
        end.
        else if lower(fmt) = "dmy" then do:
           ASSIGN iD = INTEGER(SUBSTRING(sstr,1,INDEX(sstr,spchar) - 1)).
           ASSIGN sstr = SUBSTRING(sstr,INDEX(sstr,spchar) + 1).
           ASSIGN iM = INTEGER(SUBSTRING(sstr,1,INDEX(sstr,spchar) - 1)).
           ASSIGN iY = INTEGER(SUBSTRING(sstr,INDEX(sstr,spchar) + 1)).
        end.
        if iY <= 1000 then iY = iY + 2000.
        ASSIGN od = DATE(im,id,iy).
    end.
    RETURN od.
END FUNCTION.



/******************************************************************************
 * PROCEDURE xxpro-excel:
 *     DEF OUTPUT PARAMETER p_sys_status AS integer.
 *     p_sys_status = 0.
 *
 *     DEF VAR chExcel AS COM-HANDLE.
 *     DEF VAR chWorkbook AS COM-HANDLE.
 *     DEF VAR chWorksheet AS COM-HANDLE.
 *
 *     DEF VAR iRow   AS INTEGER.
 *     def var iError as integer.
 *     def var iWarning as integer.
 *
 *     DEF VAR v_data AS CHAR EXTENT 20.
 *     DEF VAR i      AS INTEGER.
 *
 *     CREATE "Excel.Application" chExcel.
 *
 *     /*chWorkbook  =  chExcel:Workbooks:OPEN(v_filename1).*/
 *     chWorkbook = chExcel:Workbooks:OPEN(v_fexcel,0,true,,,,true).
 *     chWorkSheet =  chWorkbook:workSheets(v_sheet).
 *     chExcel:visible = NO.
 *
 *     FOR EACH xxwk1:
 *         DELETE xxwk1.
 *     END.
 *     FOR EACH xxwk3:
 *         DELETE xxwk3.
 *     END.
 *     /* read EXCEL file and load data begin..*/
 *     iRow = 1.
 *     iError = 0.
 *     iWarning = 0.
 *
 *     IF trim(STRING(chWorkbook:Worksheets(v_sheet):Cells(22,1):TEXT))
 *          <> "Delivery Information 交货信息" THEN DO:
 *         {pxmsg.i &MSGTEXT=""这不是PUS单,不能上载."" &ERRORLEVEL=3}
 *         LEAVE.
 *     END.
 *     IF trim(STRING(chWorkbook:Worksheets(v_sheet):Cells(7,3):TEXT)) = "" THEN DO:
 *         {pxmsg.i &MSGTEXT=""PUS单流水号为空,不能上载."" &ERRORLEVEL=3}
 *         LEAVE.
 *     END.
 *
 *     iRow = 8.
 *     CREATE xxwk3.
 *     ASSIGN
 *         xxwk3_asn_nbr = SUBSTRING(STRING(chWorkbook:Worksheets(v_sheet):Cells(iRow,3):TEXT),8,9)
 *         xxwk3_ord_nbr = v_ord_nbr.
 *     FIND FIRST so_mstr WHERE so_domain = global_domain
 *            and so_nbr = xxwk3_ord_nbr NO-LOCK NO-ERROR.
 *     IF AVAILABLE so_mstr THEN DO:
 *         ASSIGN xxwk3_shipto = so_cust.
 *     END.
 *     iRow = 28.
 *     ASSIGN
 *         xxwk3_date   = chWorkbook:Worksheets(v_sheet):Cells(iRow,2):VALUE.
 *
 *
 *     iRow = 45.
 *     IF v_linecode <> 0 THEN iRow = v_linecode.
 *     REPEAT:
 *         iRow = iRow + 1.
 *         if string(chWorkbook:Worksheets(v_sheet):Cells(iRow,1):value) = "" then leave.
 *         if string(chWorkbook:Worksheets(v_sheet):Cells(iRow,1):value) = ? then leave.
 *
 *         v_data = "".
 *         do i = 1 to 20:
 *             v_data[i] = trim(string(chWorkbook:Worksheets(v_sheet):Cells(iRow,i):TEXT)).
 *         end.
 *         create xxwk1.
 *         assign
 *             xxwk1_ord_nbr   = xxwk3_ord_nbr
 *             xxwk1_seq       = INTEGER(v_data[1])
 *             xxwk1_partx     = v_data[2]
 *             xxwk1_desc      = v_data[3]
 *             xxwk1_qty_ord   = decimal(v_data[4])
 *             xxwk1_qty_chk   = decimal(v_data[5])
 *             xxwk1_qty_rct   = decimal(v_data[6])
 *             .
 *         IF v_loc_iss <> "" THEN xxwk1_loc = v_loc_iss.
 *         IF v_um <> "" THEN xxwk1_um = v_um.
 *         xxwk1_part = xxwk1_partx.
 *         FIND cp_mstr WHERE cp_domain = global_domain and
 *              cp_cust = xxwk3_shipto AND
 *              cp_cust_part = xxwk1_partx NO-LOCK NO-ERROR.
 *         IF AVAILABLE cp_mstr THEN ASSIGN xxwk1_part = cp_part.
 *     END.
 *     chExcel:DisplayAlerts = FALSE.
 *     chWorkbook:CLOSE.
 *     chExcel:QUIT.
 *
 *     RELEASE OBJECT chWorksheet.
 *     RELEASE OBJECT chWorkbook.
 *     RELEASE OBJECT chExcel.
 *
 *     p_sys_status = 0.
 * END PROCEDURE.
 *
 * PROCEDURE xxpro-mod-list:
 *     VIEW FRAME f-x.
 *     MainBlock:
 *     do on error undo,leave on endkey undo,leave:
 *         { yyut4b.i
 *           &file = "xxwk1"
 *           &where = "where yes = yes"
 *           &frame = "f-x"
 *           &fieldlist = "
 *             xxwk1_part
 *             xxwk1_partx
 *             xxwk1_desc
 *             xxwk1_qty_ord
 *                        "
 *           &prompt     = "xxwk1_part"
 *           &updkey     = "Enter"
 *           &updcode    = "~ run xxpro-list1-mod. ~"
 *         }
 *     end. /*MAIN BLOCK */
 *     HIDE FRAME f-x NO-PAUSE.
 * END PROCEDURE.
 *
 * PROCEDURE xxpro-list1-mod:
 *     find FIRST xxwk1 where recid(xxwk1) = w-rid[Frame-line(f-x)]
 *     no-lock no-error.
 *     if not available xxwk1 then leave .
 *     find FIRST xxwk1 where recid(xxwk1) = w-rid[Frame-line(f-x)]
 *     no-error.
 *         UPDATE xxwk1_part WITH FRAME f-x.
 * END PROCEDURE.
******************************************************************************/
