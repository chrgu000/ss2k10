/**-----------------------------------------------**
 @File: xxrspoprt1.p
 @Description: print schedule order based on active release
 @Version: 1.0
 @Author: James Zou
 @Created: 2006-6-20
 @Mfgpro: eb2sp7
 @Parameters: 
 @BusinessLogic:
**-----------------------------------------------**/


/* DISPLAY TITLE */
{mfdtitle.i "f+"}
{yyedcomlib.i}
IF f-howareyou("HAHA") = NO THEN LEAVE.


DEF VAR v_ok         AS LOGICAL.
DEF VAR v_sys_status AS CHAR.

DEF VAR v_shipper1     AS CHAR.
DEF VAR v_shipper2     AS CHAR.
DEF VAR v_shipfr1     AS CHAR.
DEF VAR v_shipfr2     AS CHAR.
DEF VAR v_shipto1     AS CHAR.
DEF VAR v_shipto2     AS CHAR.
DEF VAR v_shstatus   AS CHAR FORMAT "X".
DEF VAR v_date1      AS DATE.
DEF VAR v_date2      AS DATE.


DEF TEMP-TABLE ttt1 RCODE-INFORMATION
    FIELDS ttt1_recid     AS INTEGER  LABEL "ID"  FORMAT ">>>>>>>>>9"
    FIELDS ttt1_shipper   AS CHAR   LABEL "发货单"
    FIELDS ttt1_billto    AS CHAR   LABEL "客户"
    FIELDS ttt1_billtoname   LIKE ad_name
    FIELDS ttt1_shipto    AS CHAR   LABEL "货物发往"
    FIELDS ttt1_shiptoname   LIKE ad_name
    FIELDS ttt1_shipfr    AS CHAR   LABEL "发货地点"
    FIELDS ttt1_shipfrname   LIKE ad_name
    FIELDS ttt1_date      AS DATE   LABEL "日期"
    FIELDS ttt1_nwet      LIKE ABS_nwt
    FIELDS ttt1_gwet      LIKE ABS_gwt
    FIELDS ttt1_wetum     LIKE pt_net_wt_um
    FIELDS ttt1_shstatus AS CHAR LABEL "状态"  FORMAT "x"
    FIELDS ttt1_con_nbr   AS CHAR   LABEL "合同号"
    FIELDS ttt1_so_nbr    AS CHAR   LABEL "销售订单"
    FIELDS ttt1_po_nbr    AS CHAR   LABEL "采购订单"
    FIELDS ttt1_curr      LIKE so_curr
    FIELDS ttt1_cmmt      LIKE so_rmks
    FIELDS ttt1_mot       AS CHAR   LABEL "运输方式"  
    FIELDS ttt1_fob       AS CHAR   LABEL "FOB" 
    .


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
FORM
    RECT-FRAME       AT ROW 1.4 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
    SKIP(.1)  /*GUI*/
    v_shipper1 COLON 20 LABEL "发货单"
    v_shipper2 COLON 45 LABEL "至"
    v_shipfr1  COLON 20 LABEL "发货地点"
    v_shipfr2  COLON 45 LABEL "至"
    v_shipto1  COLON 20 LABEL "货物发往"
    v_shipto2  COLON 45 LABEL "至"
    v_date1    COLON 20 LABEL "日期"
    v_date2    COLON 45 LABEL "至"
    v_shstatus COLON 20 LABEL "状态" VALIDATE(LOOKUP(v_shstatus, "C,X,,A") <> 0, "Please input X-取消/C-已发货/空白-未发货/A-所有")
    "(X-取消/C-已发货/空白-未发货/A-所有)" 
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



RUN xxpro-initial (OUTPUT v_sys_status).
REPEAT:
    VIEW FRAME a.
    RUN xxpro-input (OUTPUT v_sys_status).
    IF v_sys_status <> "0" THEN LEAVE.
    RUN xxpro-build (OUTPUT v_sys_status).
    RUN xxpro-view  (OUTPUT v_sys_status).

END.



/*---------------------------*/
PROCEDURE xxpro-initial:
    DEF OUTPUT PARAMETER p_sys_status AS CHAR.
    p_sys_status = "".
    v_shstatus = "A".
    p_sys_status = "0".
END PROCEDURE.
/*---------------------------*/
PROCEDURE xxpro-input:
    DEF OUTPUT PARAMETER p_sys_status AS CHAR.
    p_sys_status = "".
    
    IF v_shipper2 = hi_char THEN v_shipper2 = "".
    IF v_shipfr2  = hi_char THEN v_shipfr2  = "".
    IF v_shipto2  = hi_char THEN v_shipto2  = "".
    IF v_date1    = low_date THEN v_date1 = ?.
    IF v_date2    = hi_date THEN v_date2 = ?.
    UPDATE 
        v_shipper1
        v_shipper2
        v_shipfr1
        v_shipfr2
        v_shipto1
        v_shipto2
        v_date1
        v_date2
        v_shstatus 
    WITH FRAME a.

    IF v_shipper2 = "" THEN v_shipper2 = hi_char.
    IF v_shipfr2  = "" THEN v_shipfr2  = hi_char.
    IF v_shipto2  = "" THEN v_shipto2  = hi_char.
    IF v_date1    = ? THEN v_date1 = low_date.
    IF v_date2    = ? THEN v_date2 = hi_date.

    p_sys_status = "0".
END PROCEDURE.



/*---------------------------*/
PROCEDURE xxpro-build:
    DEF OUTPUT PARAMETER p_sys_status AS CHAR.
    p_sys_status = "".
    DEF VAR v_shipperstat AS CHAR.
    DEF VAR i AS INTEGER.
    i = 0.
    
    for each ttt1: delete ttt1. end.
    

    FOR EACH ABS_mstr no-lock
        WHERE abs_type = 's'
        AND ABS_id BEGINS 's'
        AND (ABS_shipfrom >= v_shipfr1  AND ABS_shipfrom <= v_shipfr2)
        AND (abs_shipto   >= v_shipto1  AND abs_shipto   <= v_shipto2)
        AND (substring(ABS_id,2) >= v_shipper1 AND substring(ABS_id,2) <= v_shipper2)
        AND ((ABS_shp_date >= v_date1 AND ABS_shp_date <= v_date2) OR ABS_shp_date = ? )
        :
        
        v_shipperstat = "".
        IF substring(abs_mstr.abs_status,2,1) = "y" THEN v_shipperstat = "C".
        IF abs_canceled = YES then v_shipperstat = "X".
        IF (v_shstatus <> "A") AND (v_shstatus <> v_shipperstat)  THEN NEXT.
        
        CREATE ttt1.
        ASSIGN 
            ttt1_recid   = RECID(ABS_mstr)
            ttt1_shipper = SUBSTRING(ABS_ID,2)
            ttt1_shipfr  = ABS_shipfrom
            ttt1_shipto  = ABS_shipto
            ttt1_billto  = ABS_shipto
            ttt1_date    = ABS_shp_date
            ttt1_mot     = trim(SUBSTRING(ABS_mstr.ABS__qad01,61,20))
            ttt1_fob     = trim(SUBSTRING(ABS_mstr.ABS__qad01,21,20))
            ttt1_shstatus = v_shipperstat
            ttt1_nwet    = ABS_nwt
            ttt1_gwet    = ABS_gwt
            ttt1_wetum   = ABS_wt_um
            .

        FIND FIRST ad_mstr WHERE ad_addr = ttt1_billto NO-LOCK NO-ERROR.
        IF AVAILABLE ad_mstr AND ad_ref <> "" THEN ttt1_billto = ad_ref.
        FIND FIRST ad_mstr WHERE ad_addr = ttt1_billto NO-LOCK NO-ERROR.
        IF AVAILABLE ad_mstr THEN ASSIGN ttt1_billtoname = ad_name.
        FIND FIRST ad_mstr WHERE ad_addr = ttt1_shipto NO-LOCK NO-ERROR.
        IF AVAILABLE ad_mstr THEN ASSIGN ttt1_shiptoname = ad_name.
        FIND FIRST ad_mstr WHERE ad_addr = ttt1_shipfr NO-LOCK NO-ERROR.
        IF AVAILABLE ad_mstr THEN ASSIGN ttt1_shipfrname = ad_name.
        p_sys_status = "0".
    END.
END PROCEDURE.


/*---------------------------*/
PROCEDURE xxpro-view:
    DEF OUTPUT PARAMETER p_sys_status AS CHAR.
    p_sys_status = "".
    p_sys_status = "0".
    FIND FIRST ttt1 NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ttt1 THEN do:
        MESSAGE "选择范围内没有数据" VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        LEAVE.
    END.
    DEFINE VAR h-a AS HANDLE.
    h-a = TEMP-TABLE ttt1:HANDLE.
    RUN value(lc(global_user_lang) + "\yy\yyut2browse.p") (INPUT-OUTPUT TABLE-HANDLE h-a, 
                                         INPUT "xxrcshrp1", 
                                         INPUT "", 
                                         INPUT "",
                                         INPUT "发货单" ,
                                         INPUT "ttt1_recid",
                                         INPUT "yyrcshrp1b.p,yyrcshrp1a.p,yyrcshrp1d.p",
                                         INPUT "层叠查询,平面查询,发货计划",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "").
END PROCEDURE.

