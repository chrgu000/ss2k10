{mfdtitle.i}
{bcdeclre.i  NEW}
{bcwin.i}

DEFINE VARIABLE bccode LIKE b_co_code LABEL "����".
DEFINE VARIABLE ponbr LIKE po_nbr LABEL "�ɹ�����".
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
DEFINE BUTTON btn_rec LABEL "�˻�".
DEFINE BUTTON btn_quit LABEL "�˳�".

DEF FRAME a
    SKIP(1)
    ponbr COLON 8 SKIP(.3) 
    bccode  COLON 4 SKIP(.3) 
   /* podline COLON 8  SKIP(.3)*/
    podpart COLON 8  SKIP(.3)
    /*qty_ord COLON 8  SKIP(.3)
    qty_rcvd COLON 8  SKIP(.3)*/
    bcqty COLON 8  SKIP(.3)
    psite COLON 8  SKIP(.3)
    ploc COLON 8  SKIP(.3)
    plot COLON 8  SKIP(.3)
     space(20) btn_view
WITH  WIDTH 30 TITLE "�ɹ��˻�"  SIDE-LABELS  NO-UNDERLINE THREE-D.

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
        STATUS INPUT "�޷�ʶ�������".
    END.

    RUN po_info.

    ASSIGN bccode
        ponbr
       /* podline */
        podpart
       /* qty_ord
        qty_rcvd  */
        bcqty
        psite
        ploc
        plot.
    IF plot = "" OR ploc = "" OR psite = "" OR bcqty = 0
        OR podline = 0 OR ponbr = "" THEN DO:
        MESSAGE "���ϲ�����������ִ��,�����˳�".
        RETURN.
    END.
    CREATE b_rct_wkfl.
    ASSIGN b_rct_batch = batchid
        b_rct_ponbr = ponbr
        b_rct_podline = podline
        b_rct_part = podpart
        b_rct_code = bccode
        b_rct_qty = - bcqty
        b_rct_site = psite
        b_rct_loc = ploc
        b_rct_lot = plot
        b_rct_date = TODAY.
        
    ENABLE ALL WITH FRAME a.

    RETURN.
END.
    


ON 'choose':U OF btn_view
DO:
    {gprun.i ""porcpt01.p"" "(input ""RTN"")"}
    RETURN.
END.

SELECT MAX(b_rct_batch) INTO batchid FROM b_rct_wkfl.
IF batchid = ? THEN batchid = 1. ELSE batchid = batchid + 1.
REPEAT:
    UPDATE ponbr WITH FRAME a.
    REPEAT:
        UPDATE bccode  WITH FRAME a.
    END.
    UPDATE btn_view WITH FRAME a.
END.

PROCEDURE po_info:
   FIND FIRST pod_det NO-LOCK WHERE pod_nbr = ponbr AND pod_part = podpart NO-ERROR.
   IF AVAILABLE pod_det THEN DO:
       podline = pod_line.
       qty_ord = pod_qty_ord.
       qty_rcvd = pod_qty_rcvd.
       psite = pod_site.
       ploc = pod_loc.

       DISP /*podline qty_ord qty_rcvd*/ psite ploc WITH FRAME a.
   END.
END.
