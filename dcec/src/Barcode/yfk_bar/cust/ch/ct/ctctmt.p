{mfdtitle.i}

DEFINE VARIABLE yn AS LOGICAL.

DEFINE FRAME a
    SKIP(1)
    b_ct_nrm LABEL "�������ԭ��" COLON 15 SKIP(.5)
    b_ct_up_mtd LABEL "����ԭ��" COLON 15 SKIP(.5)
    b_ct_cnt_status LABEL "�̵�״̬" COLON 15 SKIP(.5)
    b_ct_fifo_shp LABEL "�����Ƿ��Ƚ��ȳ�" COLON 15 SKIP(.5)
     b_ct_fifo_stock LABEL "����Ƿ��Ƚ��ȳ�" COLON 15 SKIP(.5)
    SKIP(10) SPACE(24)
    WITH WIDTH 80 TITLE "����" THREE-D SIDE-LABEL.

FIND FIRST b_ct_ctrl NO-ERROR.
REPEAT:
 IF AVAILABLE b_ct_ctrl THEN
       UPDATE  b_ct_nrm b_ct_up_mtd b_ct_cnt_status  
                     b_ct_fifo_shp
                     b_ct_fifo_stock  WITH FRAME a.

       IF b_ct_cnt_status  THEN DO:
            MESSAGE "���̵�״̬��ΪON��ɾ���ִ��̵�����,Ҳ���ǽ�cnt_wkfl���" 
                VIEW-AS ALERT-BOX BUTTONS YES-NO-CANCEL UPDATE yn.
            IF yn = YES THEN DO:
                /*FOR EACH b_cnt_wkfl:
               DELETE b_cnt_wkfl.
           END.*/
                MESSAGE "ok" VIEW-AS ALERT-BOX.
            END.
            
           
       END.
END.



