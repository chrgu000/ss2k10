{bcdeclre.i}
{bcwin.i}



DEFINE FRAME a
    SKIP(1)
    b_ct_nrm LABEL "�������ԭ��" COLON 12 SKIP(.5)
    b_ct_up_mtd LABEL "����ԭ��" COLON 12 SKIP(.5)
    b_ct_cnt_status LABEL "�̵�״̬" COLON 12
    SKIP(10) SPACE(24)
    WITH WIDTH 30 TITLE "����" THREE-D SIDE-LABEL.

FIND FIRST b_ct_ctrl NO-ERROR.
REPEAT:
 IF AVAILABLE b_ct_ctrl THEN
       UPDATE  b_ct_nrm b_ct_up_mtd b_ct_cnt_status  WITH FRAME a.
END.

DELETE WIDGET CURRENT-WINDOW.

