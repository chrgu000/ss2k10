/**-----------------------------------------------**
 @File: xxedexdocp.p
 @Description: print edi exchange doc to excel
 @Version: 1.0
 @Author: James Zou
 @Created: 2006-6-20
 @Mfgpro: eb2sp7
 @Parameters:
 @BusinessLogic:
**-----------------------------------------------**/


/* DISPLAY TITLE */
{mfdtitle.i "3527.1"}
{yyzzut001a.i}
{yyedcomlib.i}

DEF VAR v_ok         AS LOGICAL.
DEF VAR v_sys_status AS CHAR.

DEF VAR v_fexcel     AS CHAR.
DEF VAR v_fname      AS CHAR.
DEF VAR v_check      AS LOGICAL INITIAL NO.

DEF VAR v_date1      AS DATE.
DEF VAR v_date2      AS DATE.
DEF VAR v_msg        AS CHAR.
DEF VAR v_tpid       AS CHAR FORMAT "x(20)".
DEF VAR v_recid      AS RECID.
DEF VAR v_seq        AS INTEGER.
DEF VAR v_inout      AS LOGICAL FORMAT "In/Out" INITIAL YES.
DEF VAR v_docnbr     AS CHAR FORMAT "x(20)".

DEF TEMP-TABLE xxwk1
    FIELDS xxwk1_seq   AS INTEGER
    FIELDS xxwk1_date  AS DATE
    FIELDS xxwk1_tpid  AS CHAR
    FIELDS xxwk1_msg   AS CHAR
    FIELDS xxwk1_inout AS LOGICAL FORMAT "In/Out"
    FIELDS xxwk1_rid   AS RECID
    FIELDS xxwk1_nbr   AS CHAR
    INDEX xxwk1_idx1 xxwk1_seq.



DEF FRAME a
    v_tpid   LABEL "业务伙伴"
    v_msg    LABEL "报文"      COLON 40
    v_inout  LABEL "In/Out"    COLON 70
    SKIP
    v_docnbr LABEL "单据序号"
    v_seq    LABEL "起始序号"  COLON 40
    v_check  LABEL "检查"      COLON 70
WITH WIDTH 80 SIDE-LABELS THREE-D.

DEF FRAME f-b
    xxwk1_seq    COLUMN-LABEL "序号"
    /*xxwk1_date   COLUMN-LABEL "日期"*/
    xxwk1_tpid   COLUMN-LABEL "业务伙伴"
    xxwk1_msg    COLUMN-LABEL "报文名称"
    xxwk1_inout  COLUMN-LABEL "进/出"
    xxwk1_nbr    COLUMN-LABEL "单据号"
WITH WIDTH 80 16 DOWN TITLE "结果 [光标-移动 回车-选择 ESC-退出]" THREE-D.


DEFINE FRAME WaitingFrame
        "处理中，请稍候..."
        SKIP
WITH VIEW-AS DIALOG-BOX.


RUN xxpro-initial (OUTPUT v_sys_status).

REPEAT:
    VIEW FRAME a.
    VIEW FRAME f-b.

    RUN xxpro-input (OUTPUT v_sys_status).
    IF v_sys_status <> "0" THEN LEAVE.
    RUN xxpro-build (OUTPUT v_sys_status).
    RUN xxpro-view  (OUTPUT v_sys_status).
    CLEAR FRAME b ALL.
END.


/*---------------------------*/
PROCEDURE xxpro-initial:
    DEF OUTPUT PARAMETER p_sys_status AS CHAR.
    p_sys_status = "".

    v_ok = NO.
    v_fexcel = "".
    v_fname = "".
    p_sys_status = "0".
END PROCEDURE.
/*---------------------------*/
PROCEDURE xxpro-input:
    DEF OUTPUT PARAMETER p_sys_status AS CHAR.
    p_sys_status = "".

    IF v_date1 = low_date THEN v_date1 = ?.
    IF v_date2 = hi_date THEN v_date2 = ?.

    UPDATE
        v_tpid
        v_msg
        v_inout
        v_docnbr
        v_seq
        v_check
    WITH FRAME a EDITING :
    v_date1 = ?.
    v_date2 = ?.
    IF v_date1 = ? THEN v_date1 = low_date.
    IF v_date2 = ? THEN v_date2 = hi_date.

        if frame-field = "v_tpid" then do:
            {mfnp05.i edtp_mstr edtp_tp_id "yes = yes" edtp_tp_id v_tpid}
            if recno <> ? then do:
                DISPLAY edtp_tp_id @ v_tpid WITH FRAME a.
            END.
        END.
        ELSE if frame-field = "v_msg" then do:
            {mfnp05.i CODE_mstr CODE_fldval "code_fldname = 'xx-edi-message'" CODE_value v_msg}
            if recno <> ? then do:
                DISPLAY CODE_value @ v_msg WITH FRAME a.
            END.
        END.
        ELSE DO:
            status input.
            readkey.
            apply lastkey.
        END.

    END.
    FIND FIRST CODE_mstr WHERE code_domain = global_domain
        and CODE_fldname = "xx-edi-message"
        AND CODE_value = v_msg
        NO-LOCK NO-ERROR.
    IF AVAILABLE CODE_mstr THEN DO:
        DISPLAY v_msg WITH FRAME a.
    END.
    ELSE DO:
        MESSAGE "MESSAGE 未找到" VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
        UNDO, RETRY.
    END.

    ASSIGN v_fexcel = CODE_desc.

    IF v_fexcel <> "" THEN DO:
        IF SEARCH(v_fexcel) = ? THEN DO:
            message "报表模板不存在!" view-as alert-box error.
            UNDO, RETRY.
        END.
    END.

    p_sys_status = "0".
END PROCEDURE.

/*---------------------------*/
PROCEDURE xxpro-build:
    DEF OUTPUT PARAMETER p_sys_status AS CHAR.
    p_sys_status = "".

    DEF VAR i AS INTEGER.
    i = 0.

    FOR EACH xxwk1:
        DELETE xxwk1.
    END.


    FOR EACH edxr_mstr NO-LOCK
        WHERE edxr_domain = global_domain
        and edxr_tp_id = v_tpid
        AND edxr_tp_doc = v_msg
        AND edxr_doc_in  = v_inout
        AND edxr_exf_seq >= v_seq
        AND edxr_tp_doc_ref >= v_docnbr
        /*
        AND  ((edxr_mod_date >= v_date1 OR edxr_mod_date = ?)
          AND (edxr_mod_date <= v_date2 OR edxr_mod_date = ?))*/
        :

        CREATE xxwk1.
        ASSIGN
            xxwk1_seq  = edxr_exf_seq
            xxwk1_date = edxr_mod_date
            xxwk1_tpid = edxr_tp_id
            xxwk1_msg  = edxr_tp_doc
            xxwk1_inout = edxr_doc_in
            xxwk1_nbr   = edxr_tp_doc_ref
            xxwk1_rid   = RECID(edxr_mstr)
            .
    END.
    p_sys_status = "0".
END PROCEDURE.

/*---------------------------*/
PROCEDURE xxpro-view:
    DEF OUTPUT PARAMETER p_sys_status AS CHAR.
    p_sys_status = "".

    MainBlock:
    do on error undo,leave on endkey undo,leave:
        { yyzzut001b.i
          &file = "xxwk1"
          &where = "where yes = yes"
          &frame = "f-b"
          &fieldlist = "
            xxwk1_seq
            xxwk1_tpid
            xxwk1_msg
            xxwk1_inout
            xxwk1_nbr
                       "
          &prompt     = "xxwk1_seq"
          &index      = "use-index xxwk1_idx1"
          &midchoose  = "color mesages"
        &updkey     = "Enter"
        &updcode    = "~ run xxpro-select-line. ~"

        }
    end. /*MAIN BLOCK */
    p_sys_status = "0".
END PROCEDURE.

/*---------------------------*/
PROCEDURE xxpro-select-line:
    DEFINE VAR v-subprgname AS CHAR.

    find xxwk1 where recid(xxwk1) = w-rid[Frame-line(f-b)]
    no-lock no-error.
    v_fname = "".
    SYSTEM-DIALOG GET-FILE v_fname
        TITLE "请输入要保存文件的名称..."
        FILTERS "Source Files (*.xls)"   "*.xls"
        /*MUST-EXIST*/
        SAVE-AS
        USE-FILENAME
        UPDATE v_ok.
    IF v_ok = TRUE THEN DO:
        /*
        IF xxwk1_inout = YES THEN RUN value(lc(global_user_lang) + "\xx\xxedexdcpt-" + LC(xxwk1_msg) + "i.p") (INPUT v_fexcel, INPUT v_fname, INPUT xxwk1_rid, INPUT v_check).
        IF xxwk1_inout = NO  THEN RUN value(lc(global_user_lang) + "\xx\xxedexdcpt-" + LC(xxwk1_msg) + "o.p") (INPUT v_fexcel, INPUT v_fname, INPUT xxwk1_rid, INPUT v_check).*/
        RUN value(lc(global_user_lang) + "\yy\yyedexdcpt-" + LC(xxwk1_msg) + ".p") (INPUT v_fexcel, INPUT v_fname, INPUT xxwk1_rid, INPUT v_check).
    END.
    ELSE DO:
        MESSAGE "未指定文件名称,不能输出." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    END.
END PROCEDURE.
