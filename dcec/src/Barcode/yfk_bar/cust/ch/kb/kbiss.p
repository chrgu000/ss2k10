{bcdeclre.i "new"}
{bcini.i}

DEFINE INPUT PARAMETER kbpart LIKE knbi_part.
DEFINE INPUT PARAMETER  kbqty LIKE knbd_kanban_quantity.
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
DEFINE VARIABLE bclot LIKE pod_lot_next LABEL "����".
DEFINE VARIABLE bcstatus LIKE b_co_status LABEL "����״̬".

DEFINE VARIABLE cumqty LIKE knbd_kanban_quantity LABEL "�ۼ�" INITIAL 0.

DEFINE FRAME bc
    SKIP(1)
    bccode COLON 15 SKIP(.3)
    bcpart COLON 15 bcqty COLON 45
    cumqty COLON 15
    SKIP(2)
WITH WIDTH 80 SIDE-LABEL THREE-D.

mainloop:
REPEAT:

    REPEAT:
        DISP bcpart bcqty cumqty WITH FRAME bc.
        UPDATE bccode WITH FRAME bc.

        {bcrun.i ""bcbccock.p""  "( INPUT bccode,
                                             OUTPUT active,
                                             OUTPUT bcpart,
                                             OUTPUT bcqty,
                                             OUTPUT bcsite,
                                             OUTPUT bcloc,
                                             OUTPUT bclot,
                                             OUTPUT bcstatus )"}
        IF active NE YES THEN DO:
           RETRY.
           STATUS INPUT "�޷�ʶ�������".
        END.
        ELSE DO:
            IF kbpart NE bcpart THEN DO:
                RETRY.
                STATUS INPUT "�����ƥ��".
            END.
            ELSE IF bcstatus = "ISSUED" THEN DO:
                RETRY.
                STATUS INPUT "����״̬��ISSUED,����ִ��".
            END.
            ELSE DO:
                cumqty = cumqty + bcqty.
                DISP bcpart bcqty cumqty WITH FRAME bc.
                {bcco001.i bccode bcpart bcqty bcsite bcloc bclot """"}
            END.
        END.
    END. /*repeat*/
  
  IF cumqty = kbqty THEN ifmatch = TRUE. ELSE ifmatch = FALSE.

  IF ifmatch = FALSE THEN DO:
      MESSAGE "����ɨ�����������˳����µ��".
      sucess = FALSE.
      LEAVE mainloop.
  END.
  ELSE DO:
      sucess = TRUE.
      {bcco002.i ""ISSUED""}
      STATUS INPUT "ɨ����ƥ��".
      LEAVE mainloop.
  END.

 END.

