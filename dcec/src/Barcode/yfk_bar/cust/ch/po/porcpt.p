{mfdtitle.i}
{bcdeclre.i NEW}
{bcini.i}
{bcwin.i}



DEFINE VARIABLE bccode LIKE b_co_code LABEL "����".
DEFINE VARIABLE ponbr LIKE po_nbr LABEL "�ɹ�����".
DEFINE VARIABLE adname LIKE ad_name.
DEFINE VARIABLE podline LIKE pod_line LABEL "��".
DEFINE VARIABLE podpart LIKE pod_part LABEL "�����".
DEFINE VARIABLE qty_ord LIKE pod_qty_ord LABEL "������".
DEFINE VARIABLE qty_rcvd LIKE pod_qty_rcvd LABEL "������".
DEFINE VARIABLE bcqty LIKE b_co_qty_cur LABEL "��������".
DEFINE VARIABLE bcsite LIKE b_co_site.
DEFINE VARIABLE bcloc LIKE b_co_loc.
DEFINE VARIABLE psite LIKE pod_site LABEL "�ص�".
DEFINE VARIABLE ploc LIKE pod_loc LABEL "��λ".
DEFINE VARIABLE plot LIKE pod_lot_next LABEL "����".
DEFINE VARIABLE bcstatus LIKE b_co_status LABEL "����״̬".

DEFINE NEW SHARED VARIABLE batchid LIKE b_rct_batch.
/*buffer record id used to exec CIM */
DEFINE VARIABLE bfid AS INTEGER.  /*indicate the buffer id*/

DEFINE VARIABLE active AS LOGICAL.  /*if barcode active*/

DEFINE BUTTON btn_view LABEL "�鿴".
DEFINE BUTTON btn_rec LABEL "�ջ�".
DEFINE BUTTON btn_quit LABEL "�˳�".

DEF FRAME a
    SKIP(1)
    ponbr COLON 8 SKIP(.3) 
    adname COLON 1 NO-LABEL SKIP(.3)
    bccode  COLON 4 SKIP(.3) 
   /*podline COLON 8  SKIP(.3)*/
    podpart COLON 8  SKIP(.3)
    /*qty_ord COLON 8  SKIP(.3)
    qty_rcvd COLON 8  SKIP(.3)*/
    bcqty COLON 8  SKIP(.3)
    psite COLON 8  SKIP(.3)
    ploc COLON 8  SKIP(.3)
    plot COLON 8  SKIP(.3)
     space(23) btn_view 
WITH  WIDTH 30 TITLE "�ɹ��ջ�"  SIDE-LABELS  NO-UNDERLINE THREE-D.

ON 'value-changed':U OF bccode 
DO:
    ASSIGN bccode ponbr.
    {gprun.i ""bccock.p""  "( INPUT bccode,
                                          OUTPUT active,
                                          OUTPUT podpart,
                                          OUTPUT bcqty,
                                          OUTPUT bcsite,
                                          OUTPUT bcloc,
                                          OUTPUT plot,
                                          OUTPUT bcstatus )"}
    IF active =YES THEN DO:
        DISP podpart  bcqty plot WITH FRAME a.
    END.
    ELSE DO:
        DISP "" @ podpart  "" @ bcqty "" @ plot WITH FRAME a.
    END.

    STATUS INPUT "".

    RUN po_info.
    ASSIGN bccode
        ponbr
    /*    podline*/
        podpart
    /*    qty_ord
        qty_rcvd*/
        bcqty
        psite
        ploc
        plot.
    IF  bcqty = 0
        OR podline = 0 OR ponbr = "" THEN DO:
        STATUS INPUT "���ϲ�����������ִ��,�����˳�".
        RETURN.
    END.

    IF bcstatus NE "MAT-CRE"  THEN DO:
        STATUS INPUT "������״̬����ִ�иò����������Ѿ�ִ���ջ����˳�".
        RETURN.
    END.

    FIND FIRST b_rct_wkfl NO-LOCK WHERE b_rct_code = bccode AND b_rct_batch = batchid NO-ERROR.
    IF AVAILABLE b_rct_wkfl THEN DO:
        STATUS INPUT "�������Ѿ����ջ��嵥��,��Ҫ�ظ�ɨ��".
        RETURN.
    END.

    FIND FIRST loc_mstr NO-LOCK WHERE loc_loc = ploc NO-ERROR.
    IF NOT AVAILABLE loc_mstr THEN DO:
        STATUS INPUT "�ɹ�Ĭ�Ͽ�λ������".
        RETURN.
    END.

    {bcco001.i bccode podpart bcqty psite ploc plot """"}
    CREATE b_rct_wkfl.
    ASSIGN b_rct_batch = batchid
        b_rct_ponbr = ponbr
        b_rct_podline = podline
        b_rct_part = podpart
        b_rct_code = bccode
        b_rct_qty = bcqty
        b_rct_site = psite
        b_rct_loc = ploc
        b_rct_lot = plot
        b_rct_date = TODAY.
    STATUS INPUT "��������������ջ��嵥".
        
    APPLY KEYCODE("F2") TO BCCODE.


    RETURN.
END.


ON 'choose':U OF btn_view
DO:
    {gprun.i ""porcpt01.p"" "(input ""RCT"")"}
    RETURN.
END.

SELECT MAX(b_rct_batch) INTO batchid FROM b_rct_wkfl.
IF batchid = ? THEN batchid = 1. ELSE batchid = batchid + 1.

REPEAT:
    UPDATE ponbr WITH FRAME a.
         FIND FIRST po_mstr NO-LOCK WHERE po_nbr = ponbr NO-ERROR.
         IF AVAILABLE po_mstr THEN DO:
             FIND FIRST ad_mstr NO-LOCK WHERE ad_addr = po_vend NO-ERROR.
             IF AVAILABLE ad_mstr THEN adname = ad_name.
                     DISPLAY adname WITH FRAME a.
         END.
    REPEAT:
        UPDATE bccode  WITH FRAME a.
    END.
    UPDATE btn_view WITH FRAME a.
END.

/*{BCTRAIL1.I}*/

PROCEDURE po_info:
   FIND FIRST pod_det NO-LOCK WHERE pod_nbr = ponbr AND pod_part = podpart NO-ERROR.
   IF AVAILABLE pod_det THEN DO:
       podline = pod_line.
       qty_ord = pod_qty_ord.
       qty_rcvd = pod_qty_rcvd.
       psite = pod_site.
       ploc = pod_loc.

       DISP  psite ploc WITH FRAME a.
   END.
END.
