{mfdtitle.i}
{bcdeclre.i NEW}
{bcwin.i}

DEFINE VARIABLE bccode LIKE b_co_code LABEL "����".
DEFINE VARIABLE ponbr LIKE po_nbr LABEL "�ɹ�����".
DEFINE VARIABLE podline LIKE pod_line LABEL "��".
DEFINE VARIABLE bcpart LIKE pod_part LABEL "�����".
DEFINE VARIABLE qty_ord LIKE pod_qty_ord LABEL "������".
DEFINE VARIABLE qty_rcvd LIKE pod_qty_rcvd LABEL "������".
DEFINE VARIABLE bcqty LIKE b_co_qty_cur LABEL "��������".
DEFINE VARIABLE bcsite LIKE b_co_site LABEL "�ص�".
DEFINE VARIABLE psite LIKE pod_site LABEL "�ص�".
DEFINE VARIABLE bcloc LIKE pod_loc LABEL "��λ".
DEFINE VARIABLE bclot LIKE pod_lot_next LABEL "����".
DEFINE VARIABLE bcstatus LIKE b_co_status LABEL "����״̬".

DEFINE VARIABLE prodline LIKE b_wo_line.
DEFINE VARIABLE tosite LIKE pod_site LABEL "�ص�".
DEFINE VARIABLE toloc LIKE pod_loc LABEL "��λ".

DEFINE VARIABLE batchid LIKE b_rct_batch.
/*buffer record id used to exec CIM */
DEFINE VARIABLE bfid AS INTEGER.  /*indicate the buffer id*/
DEFINE VARIABLE succeed AS LOGICAL.

DEFINE VARIABLE active AS LOGICAL.  /*if barcode active*/


DEFINE BUTTON btn_rec LABEL "����".
DEFINE BUTTON btn_quit LABEL "�˳�".

DEF FRAME a
    SKIP(1)
    "����:" AT 1 SKIP
    bccode NO-LABEL AT 1 SKIP(.3) 
    bcpart COLON 8  SKIP(.3)
    bcqty COLON 8  SKIP(.3)
    bcsite COLON 8  SKIP(.3)
    bcloc COLON 8  SKIP(.3)
    bclot COLON 8  SKIP(.3)
    SKIP(3)
     space(22)  btn_rec 
WITH  WIDTH 80 TITLE "��������"  SIDE-LABELS  NO-UNDERLINE THREE-D.

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
        DISP bcpart  bcqty bclot bcsite bcloc WITH FRAME a.
    END.
    ELSE DO:
        DISP "" @ bcpart  "" @ bcqty "" @ bclot "" @ bcsite "" @ bcloc  WITH FRAME a.
        STATUS INPUT "�޷�ʶ�������".
    END.

    FIND FIRST b_wod_det NO-LOCK WHERE b_wod_code = bccode NO-ERROR.
    IF AVAILABLE b_wod_det THEN DO:
        prodline = b_wod_line.
    END.
    ELSE DO:
        /*����������ƻ����Ҳ���,��ô�����Ե������������*/
        FIND FIRST xwo_srt WHERE xwo_lot = bccode AND xwo_part = bcpart NO-ERROR.
        IF AVAILABLE xwo_srt THEN DO:
            prodline = xwo_lnr.
        END.
        ELSE DO:
            STATUS INPUT "�ڵ�����������޷�����������,�˳�".
            DISP "" @ bcpart  "" @ bcqty "" @ bclot "" @ bcsite "" @ bcloc  WITH FRAME a.
            RETURN.
        END.
    END.

    FIND FIRST xgpl_ctrl NO-LOCK WHERE xgpl_lnr = prodline NO-ERROR.
    IF AVAILABLE xgpl_ctrl THEN DO:
        tosite = xgpl_site.
        toloc = xgpl_loc1.
    END.
    ELSE DO:
        STATUS INPUT "��29.16.24û��ά����������߼�¼,�޷�ȡ�÷��޵ص㼰��λ,�Ƴ�".
        RETURN.
    END.

    RETURN.
END.
    


ON 'choose':U OF btn_rec
DO:
    ASSIGN bccode
        bcpart
        bcqty
        bcsite
        bcloc
        bclot.
    IF bclot = "" OR bcloc = "" OR bcsite = "" OR bcqty = 0
       OR bcpart = "" THEN DO:
        MESSAGE "���ϲ�����������ִ��,�����˳�".
        RETURN.
    END.
    {bcco001.i bccode bcpart bcqty tosite toloc bclot """"}
    CREATE b_rwk_mstr.
    ASSIGN b_rwk_id = batchid
        b_rwk_part = bcpart
        b_rwk_code = bccode
        b_rwk_qty = bcqty
        b_rwk_beg_date = TODAY
        b_rwk_end_date = ?
        b_rwk_status = "REWORK".

    {gprun.i ""mgwrbf.p"" "(INPUT """",
                                         INPUT """",
                                         INPUT bccode,
                                         INPUT bcpart,
                                         INPUT bclot,
                                         INPUT """",
                                         INPUT bcqty,
                                         INPUT """",
                                         INPUT TODAY,
                                         INPUT """",
                                         INPUT """",
                                         INPUT """",
                                         INPUT """",
                                         INPUT """",
                                         INPUT bcloc,
                                         INPUT bcsite,
                                         INPUT ""iclotr04.p"",
                                         INPUT tosite,
                                         INPUT toloc,
                                         INPUT bclot,
                                         INPUT """",
                                         INPUT YES,
                                         INPUT """",
                                         INPUT """",
                                         INPUT """",
                                         INPUT """",
                                         INPUT """",
                                         INPUT """",
                                         INPUT """",
                                         INPUT """",
                                         INPUT """",
                                         INPUT """",
                                         INPUT """",
                                         INPUT """",
                                         INPUT """",
                                         OUTPUT bfid)"}
/*b_bf_nbr*/  /*b_bf_line*/ /*b_bf_code*/ /*b_bf_part*/  /*b_bf_lot*/   /*b_bf_ser*/   /*b_bf_qty*/  /*b_bf_um*/  /*b_bf_enterdate*/ /*b_bf_tr_date*/ 
/*b_bf_eff_date*/ /*b_bf_trtype*/  /*b_bf_trnbr*/  /*b_bf_ntime*/  /*b_bf_loc*/  /*b_bf_site*/  /*b_bf_program*/  /*b_bf_tosite*/ /*b_bf_toloc*/  
/*b_bf_tolot*/ /*b_bf_toser*/  /*b_bf_tocim*/   /*b_bf_sess*/  /*b_bf_ref*/ /*b_bf_trid1*/  /*b_bf_trid2*/  /*b_bf_bc01*/  /*b_bf_bc02*/    /*b_bf_bc03*/  
/*b_bf_bc04*/   /*b_bf_bc05*/ /*b_bf_emp*/   
        {gprun.i ""mgwrfl.p"" "(input ""iclotr04.p"", input bfid)"}
        {gprun.i ""mgecim06.p"" "(input bfid, output succeed)"} 

        IF succeed = TRUE THEN DO:
            STATUS INPUT "���".
        END.
        ELSE DO:
            STATUS INPUT "�������ϳ�������".
            LEAVE.
        END.

    {bcco002.i ""REWORK""}  

    ENABLE ALL WITH FRAME a.

    RETURN.
END.


DISP bccode WITH FRAME a.
SELECT MAX(b_rwk_id) INTO batchid FROM b_rwk_mstr.
IF batchid = ? THEN batchid = 1. ELSE batchid = batchid + 1.
REPEAT:
    REPEAT:
        UPDATE bccode WITH FRAME a.
    END.
    UPDATE btn_rec  WITH FRAME a.
END.



