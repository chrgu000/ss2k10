{mfdtitle.i}
{bcdeclre2.i NEW}
{bcini.i}
{bcwin.i}

DEFINE VARIABLE bccode LIKE b_co_code LABEL "����".
DEFINE VARIABLE bcpart LIKE b_co_part LABEL "�����".
DEFINE VARIABLE bcdpart LIKE pod_part LABEL "�����".
DEFINE VARIABLE bcqty LIKE b_co_qty_cur LABEL "��������".
DEFINE VARIABLE bcsite LIKE pod_site LABEL "�ص�".
DEFINE VARIABLE bcloc LIKE pod_loc LABEL "��λ".
DEFINE VARIABLE bclot LIKE pod_lot_next LABEL "����".
DEFINE VARIABLE bcstatus LIKE b_co_status LABEL "����״̬".

DEFINE VARIABLE accode LIKE ac_code LABEL "�ʺ�".
DEFINE VARIABLE sbsub LIKE sb_sub LABEL "���ʺ�".
DEFINE VARIABLE ccctr LIKE cc_ctr LABEL "�ɱ�����".
DEFINE VARIABLE pjproject LIKE pj_project LABEL "��Ŀ".

/*buffer record id used to exec CIM */
DEFINE VARIABLE bfid AS INTEGER.  /*indicate the buffer id*/
DEFINE VARIABLE active AS LOGICAL.  /*if barcode active*/

DEFINE BUTTON btn_iss LABEL "����".
DEFINE BUTTON btn_quit LABEL "�˳�".

DEF FRAME a
    SKIP(1)
    "����:" AT 1 SKIP
    bccode NO-LABEL AT 1 SKIP(.3) 
    bcpart COLON 8 SKIP(.3) 
    bcqty COLON 8  SKIP(.3)
    bcsite COLON 8  SKIP(.3)
    bcloc COLON 8  SKIP(.3)
    bclot COLON 8  SKIP(.3)
    bcstatus COLON 8 SKIP(2)
    btn_quit AT 24
WITH  WIDTH 30 TITLE "����״̬�鿴"  SIDE-LABELS  NO-UNDERLINE THREE-D.

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
        DISP bcpart  bcqty bcsite bcloc  bclot bcstatus WITH FRAME a.
    END.
    ELSE DO:
        DISP "" @ bcpart  "" @ bcqty  "" @ bcsite  "" @ bcloc "" @ bclot WITH FRAME a.
        STATUS INPUT "�޷�ʶ�������".
        RETURN.
    END.
    APPLY "F2":U TO bccode.
    RETURN.
END.
    

DISP bccode WITH FRAME a.
REPEAT:
    REPEAT:
            UPDATE bccode WITH FRAME a.
    END.
    UPDATE btn_quit WITH FRAME a.
END.
