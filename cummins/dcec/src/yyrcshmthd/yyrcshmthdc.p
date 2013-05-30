/* GUI CONVERTED from icshmt.p (converter v1.77) Wed Sep 17 02:26:27 2003 */
/* icshmt.p - Multi-Transaction Shipper Maintenance                           */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.20.1.1 $                                                               */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke        */
/* REVISION: 8.6      LAST MODIFIED: 04/09/97   BY: *K08N* Steve Goeke        */
/* REVISION: 8.6      LAST MODIFIED: 04/22/97   BY: *K0C5* Taek-Soo Chang     */
/* REVISION: 8.6      LAST MODIFIED: 09/26/97   BY: *K0K1* John Worden        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 11/10/98   BY: *K1Y6* Seema Varma        */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B8* Hemanth Ebenezer   */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/25/99   BY: *N002* Bill Gates         */
/* REVISION: 9.1      LAST MODIFIED: 11/07/99   BY: *L0L4* Michael Amaladhas  */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* myb                */
/* REVISION: 9.1      LAST MODIFIED: 09/29/00   BY: *N0W6* Mudit Mehta        */
/* Revision: 1.16     BY: Ellen Borden          DATE: 07/09/01   ECO: *P007*  */
/* Revision: 1.17     BY: Katie Hilbert         DATE: 12/05/01   ECO: *P03C*  */
/* Revision: 1.18     BY: Samir Bavkar          DATE: 08/15/02   ECO: *P09K*  */
/* Revision: 1.19     BY: Ashish Maheshwari     DATE: 12/03/02   ECO: *N214*  */
/* Revision: 1.20     BY: Kirti Desai           DATE: 04/16/03   ECO: *P0Q0*  */
/* $Revision: 1.20.1.1 $       BY: Sunil Fegade          DATE: 09/15/03   ECO: *P134*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{cxcustom.i "ICSHMT.P"}
{gplabel.i}    /* EXTERNAL LABEL INCLUDE */
{apconsdf.i}   /* PRE-PROCESSOR CONSTANTS FOR LOGISTICS ACCOUNTING */

/* INPUT PARAMETERS */
define input parameter inp_recid AS RECID NO-UNDO.


FIND FIRST ABS_mstr WHERE recid(ABS_mstr) = inp_recid NO-LOCK NO-ERROR.
IF NOT AVAILABLE ABS_mstr THEN LEAVE.

MESSAGE "要维护发货计划吗？" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO TITLE "" UPDATE choice AS LOGICAL.
IF choice  = NO THEN LEAVE.


{yyzzut001a.i}
DEF VAR v_key1 AS CHARACTER NO-UNDO.
ASSIGN v_key1 = "SHIPPER-" + SUBSTRING(abs_id,2).

DEF TEMP-TABLE ttt1 RCODE-INFORMATION
    FIELDS ttt1_copy     AS LOGICAL INITIAL NO LABEL "复制"
    FIELDS ttt1_sonbr    AS CHAR               LABEL "销售订单"
    FIELDS ttt1_soline     AS INTEGER            LABEL "行"           
    FIELDS ttt1_ponbr    AS CHAR               LABEL "客户采购订单"
    FIELDS ttt1_part     LIKE pt_part          
    FIELDS ttt1_desc     LIKE pt_desc1
    FIELDS ttt1_date     AS DATE               LABEL "日期"
    FIELDS ttt1_qty      LIKE tr_qty_loc       LABEL "数量"
    .


FORM 
    usrw_key2        COLUMN-LABEL "行号"      FORMAT "x(4)"
    usrw_key3        COLUMN-LABEL "零件号"    FORMAT "x(12)"
    usrw_charfld[1]  COLUMN-LABEL "描述"      FORMAT "x(12)"
    usrw_key5        COLUMN-LABEL "订单"
    usrw_key6        COLUMN-LABEL "行"        FORMAT "x(4)"
    usrw_decfld[1]   COLUMN-LABEL "数量"      FORMAT ">>>>>9"
    with TITLE "发货计划...[A]添加 [D]删除 [Enter]修改" DOWN frame f-main ROW 4 CENTER OVERLAY width 80 attr-space
    THREE-D.
setFrameLabels(frame f-main:handle).

MainBlock:
do on error undo,leave on endkey undo,leave:

        { yyzzut001b.i
          &file = "usrw_wkfl"
          &where = "where (usrw_domain = global_domain and usrw_key1 = v_key1)"
          &frame = "f-main"
          &fieldlist = "
            usrw_key2
            usrw_key3
            usrw_charfld[1]
            usrw_key5
            usrw_key6
            usrw_decfld[1]
                       "
          &prompt     = "usrw_key2"
          &index      = "use-index usrw_index1"
          &midchoose  = "color mesages"
        &updkey     = "Enter"
        &updcode    = "~ run xxpro-upd-1. ~"
        &inskey     = "A"
        &inscode    = "~ run xxpro-add-1. ~"
        &delkey     = "D"
        &delcode    = "~ run xxpro-del-1. ~"
        }

end. /*MAIN BLOCK */


HIDE FRAME f-main NO-PAUSE.


/**************/
PROCEDURE xxpro-upd-1:
    find usrw_wkfl where recid(usrw_wkfl) = w-rid[Frame-line(f-main)]
    no-lock no-error.

    if not available usrw_wkfl then leave .

    find usrw_wkfl where recid(usrw_wkfl) = w-rid[Frame-line(f-main)] no-error.
    display
        usrw_key2
        usrw_key3
        usrw_charfld[1]
        usrw_key5
        usrw_key6
        usrw_decfld[1]
    with frame f-main.
    UPDATE
        usrw_decfld[1]
        with frame f-main.
    
END PROCEDURE.

/**************/
PROCEDURE xxpro-del-1:
    find usrw_wkfl where recid(usrw_wkfl) = w-rid[Frame-line(f-main)]
    no-lock no-error.

    if not available usrw_wkfl then leave .
    DEF VARIABLE v_confirm AS LOGICAL INITIAL YES.

    find usrw_wkfl where recid(usrw_wkfl) = w-rid[Frame-line(f-main)] no-error.
    message "确认删除" update v_confirm.
    if v_confirm and available usrw_wkfl then  do:
       delete usrw_wkfl.
    end.   
END PROCEDURE.
/**************/
PROCEDURE xxpro-add-1.
    DEF VARIABLE i AS INTEGER.
    DEF VARIABLE v_qty AS INTEGER.

    RUN Xxpro-bud-ttt.

    i = 0.
    FIND LAST usrw_wkfl WHERE usrw_domain = glbal_domain and usrw_key1 = v_key1 USE-INDEX usrw_index1 NO-LOCK NO-ERROR.
    IF AVAILABLE usrw_wkfl THEN DO:
        ASSIGN i = INTEGER(usrw_key2).
    END.

    FOR EACH ttt1 WHERE ttt1_copy = YES BREAK BY ttt1_sonbr BY ttt1_soline:
        IF FIRST-OF(ttt1_soline) THEN DO:
            v_qty = 0.
        END.
        v_qty = v_qty + ttt1_qty.
        IF LAST-OF(ttt1_soline) THEN DO:
            i = i + 1.
            CREATE usrw_wkfl.
            ASSIGN 
                usrw_key1 = v_key1
                usrw_key2 = STRING(i, "9999")
                usrw_key3 = ttt1_part
                usrw_charfld[1] = ttt1_desc
                usrw_key5 = ttt1_sonbr
                usrw_key6 = string(ttt1_soline, "9999")
                usrw_decfld[1] = v_qty
                .
            RELEASE usrw_wkfl.
        END.
    END.
END PROCEDURE.
/**************/
PROCEDURE xxpro-bud-ttt:
    DEF VAR v_ship_fr AS CHARACTER.
    DEF VAR v_ship_to AS CHARACTER.
    DEF VAR v_sonbr   LIKE so_nbr.

    FOR EACH ttt1:
        DELETE ttt1.
    END.

    FIND FIRST ABS_mstr WHERE recid(ABS_mstr) = inp_recid NO-LOCK NO-ERROR.
    IF NOT AVAILABLE ABS_mstr THEN LEAVE.
    ASSIGN 
        v_ship_fr = ABS_shipfrom
        v_ship_to  = ABS_shipto.
    MESSAGE "请输入销售订单号码" update v_sonbr.
    FIND FIRST so_mstr WHERE so_domain = global_domain and so_nbr = v_sonbr NO-LOCK NO-ERROR.
    IF NOT AVAILABLE so_mstr THEN DO:
        UNDO, RETRY.
    END.

    FOR EACH scx_ref NO-LOCK 
        WHERE scx_domain = global_domain and scx_type = 1
        AND scx_shipfrom = v_ship_fr
        AND scx_shipto   = v_ship_to
        AND scx_order    = v_sonbr
        , FIRST sod_det NO-LOCK
        WHERE sod_domain = global_domain and sod_nbr = scx_order
        AND   sod_line = scx_line
        , FIRST so_mstr NO-LOCK
        WHERE so_domain = global_domain and so_nbr = scx_order
        , FIRST pt_mstr NO-LOCK 
        WHERE pt_part = sod_part:

        FOR each schd_det NO-LOCK
            where schd_domain = global_domain and schd_type = 3
            and schd_rlse_id = sod_curr_rlse_id[3] 
            and schd_nbr = sod_nbr 
            and schd_line = sod_line 
            and schd_discr_qty > 0:
            
            CREATE ttt1.
            ASSIGN
                ttt1_part = sod_part
                ttt1_desc = pt_desc1
                ttt1_sonbr = sod_nbr
                ttt1_soline = sod_line
                ttt1_ponbr  = scx_po
                ttt1_date   = schd_date
                ttt1_qty    = schd_discr_qty
                .
        END.
    END.


    DEF VAR h-a AS HANDLE.
    h-a = TEMP-TABLE ttt1:HANDLE.
    RUN value(lc(global_user_lang) + "\yy\yyut2browse.p") (INPUT-OUTPUT TABLE-HANDLE h-a, 
                                         INPUT "yyrcshmthdc", 
                                         INPUT "", 
                                         INPUT "",
                                         INPUT "请选择要发布的行..." ,
                                         INPUT "",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "ttt1_copy",
                                         INPUT "",
                                         INPUT "",
                                         INPUT "").
END PROCEDURE.




