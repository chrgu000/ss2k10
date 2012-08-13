{mfdeclre.i}
{bcdeclre.i "new"}
{bcini.i}

DEFINE INPUT PARAMETER part AS CHARACTER.
DEFINE INPUT PARAMETER pqty AS DECIMAL.
DEFINE INPUT PARAMETER shft AS CHARACTER.

DEFINE OUTPUT PARAMETER sucess AS LOGICAL INITIAL FALSE.

DEFINE VARIABLE ifmatch AS LOGICAL INITIAL FALSE.

DEFINE VARIABLE active AS LOGICAL.  /*if barcode active*/

DEFINE VARIABLE bccode LIKE b_co_code LABEL "����".
DEFINE VARIABLE ponbr LIKE po_nbr LABEL "�ɹ�����".
DEFINE VARIABLE podline LIKE pod_line LABEL "��".
DEFINE VARIABLE bcpart LIKE pod_part LABEL "�����".
DEFINE VARIABLE qty_ord LIKE pod_qty_ord LABEL "������".
DEFINE VARIABLE qty_rcvd LIKE pod_qty_rcvd LABEL "������".
DEFINE VARIABLE bcqty LIKE b_co_qty_cur LABEL "��������".
DEFINE VARIABLE bcsite LIKE b_co_site.
DEFINE VARIABLE bcloc LIKE b_co_loc.
DEFINE VARIABLE psite LIKE pod_site LABEL "�ص�".
DEFINE VARIABLE ploc LIKE pod_loc LABEL "��λ".
DEFINE VARIABLE plot LIKE pod_lot_next LABEL "����".
DEFINE VARIABLE bcstatus LIKE b_co_status LABEL "����״̬".


DEFINE FRAME bc
    SKIP(1)
    bccode COLON 15 SKIP(.3)
    bcpart COLON 15 bcqty COLON 45
    SKIP(2)
WITH WIDTH 80 SIDE-LABEL THREE-D.
DEFINE FRAME bd
SKIP(1)
    bcpart COLON 15 bcqty COLON 45
    SKIP(2)
WITH WIDTH 80 SIDE-LABEL THREE-D.

ON 'value-changed':U OF bccode
DO:
    ASSIGN bccode.
    bccode = TRIM(bccode).

    {gprun.i ""bccock.p""  "( INPUT bccode,
                                         OUTPUT active,
                                         OUTPUT bcpart,
                                         OUTPUT bcqty,
                                         OUTPUT bcsite,
                                         OUTPUT bcloc,
                                         OUTPUT plot,
                                         OUTPUT bcstatus )"}
    
    IF active NE YES THEN DO:
          STATUS INPUT "�޷�ʶ�������".
          RETURN.
    END.
    ELSE DO:
        STATUS INPUT "�����ʶ��".
    END.

    FIND FIRST b_co_mstr WHERE b_co_code = bccode  NO-ERROR.
    IF AVAILABLE b_co_mstr THEN DO:
        IF b_co_status = "FINI-COMP" THEN DO:
            STATUS INPUT "������ͷ�Ѿ���ɵ��,�˳�".
            RETURN.
        END.
        ELSE IF b_co_status NE "FINI-REL" THEN DO:
            STATUS INPUT "������״̬�������´��,�˳�".
            RETURN.
        END.
    END.

    ifmatch = TRUE.
    IF bcpart NE part THEN DO: ifmatch = FALSE. STATUS INPUT "�����ƥ��".
    END.
    IF bcqty NE pqty THEN DO: ifmatch = FALSE.  STATUS INPUT "������ƥ��".
    END.
    FIND FIRST b_wo_mstr NO-LOCK WHERE b_wo_shift = shft AND b_wo_part = bcpart NO-ERROR.
    IF NOT AVAILABLE b_wo_mstr THEN DO: ifmatch = FALSE.  STATUS INPUT "��β�ƥ��".
    END.

    IF ifmatch = FALSE THEN DO:
       /* STATUS INPUT  "����ɨ�����������˳����µ��".*/
        sucess = FALSE.
        RETURN.
    END.
    ELSE DO:
        bcpart:SCREEN-VALUE = bcpart.
        bcqty:SCREEN-VALUE = string(bcqty).
        {bcco001.i bccode bcpart bcqty """" """" """" """"}
        sucess = TRUE.
        {bcco002.i ""FINI-COMP""}
        FIND b_wod_det WHERE b_wod_code = bccode NO-ERROR.
        IF AVAILABLE b_wod_det THEN 
            ASSIGN b_wod_status = "FINI-COMP"
                         b_wod_fin_date = TODAY
                         b_wod_shp_nbr = STRING(TIME,"hh:mm:ss").
        RELEASE b_wod_det.

        STATUS INPUT "ɨ����ƥ��".
        APPLY "F2":U TO bccode.
        /*APPLY "ESC":U TO bccode.*/
        RETURN.
    END.

    RETURN.
END.
 
/*REPEAT:*/
    UPDATE bccode WITH FRAME bc.
/*END.*/


PAUSE 1.

