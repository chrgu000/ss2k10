{mfdtitle.i}
{bcdeclre.i NEW}
{bcini.i}

DEFINE VARIABLE part LIKE ld_part LABEL "�����".
DEFINE VARIABLE lot LIKE ld_lot LABEL "����".
DEFINE VARIABLE part1 LIKE ld_part LABEL "��".
DEFINE VARIABLE lot1 LIKE ld_lot  LABEL "��".
DEFINE VARIABLE bcsta LIKE b_co_status LABEL "����״̬".
DEFINE VARIABLE coqty AS DECIMAL LABEL "�����������ϼ�".
DEFINE VARIABLE conum AS INT LABEL "��������".


DEFINE QUERY q_co FOR t_co_mstr.
DEFINE BROWSE b_co QUERY q_co
    DISPLAY
    t_co_code LABEL "����"
    t_co_site LABEL "�ص�"
    t_co_loc LABEL "��λ"
    t_co_qty_cur LABEL "����"
    t_co_lot LABEL "����"
    t_co_status LABEL "״̬"
    WITH 11 DOWN WIDTH 79
    TITLE "�����嵥".



DEFINE FRAME a
    SKIP(.5)
    part COLON 15  part1 COLON 45 SKIP(.3)
    lot COLON 15 lot1 COLON 45 SKIP(.5)
    bcsta COLON 30
    b_co SKIP(.3)
    conum COLON 15 coqty COLON 45 SKIP
     
    SPACE(48) 
    WITH WIDTH 80  THREE-D TITLE "�����ѯ"  SIDE-LABELS  NO-UNDERLINE.





REPEAT :

    UPDATE part part1 lot lot1 bcsta  WITH FRAME a.
    
    FOR EACH t_co_mstr:
        DELETE t_co_mstr.
    END.

    IF part1 = ""  THEN part1 = hi_char.
    IF lot1 = "" THEN lot1 = hi_char.
    
    coqty = 0.
    conum = 0.

    IF bcsta = "" THEN DO:

        FOR EACH b_co_mstr WHERE  (b_co_part >= part AND b_co_part <= part1)
            AND (b_co_lot >= lot AND b_co_lot <= lot1) AND b_co_status NE "DISABLE":
            CREATE t_co_mstr.
            ASSIGN 
                t_co_code = b_co_code
                t_co_part = b_co_part
                t_co_site = b_co_site
                t_co_loc = b_co_loc
                t_co_lot = b_co_lot
                t_co_qty_cur = b_co_qty_cur
                t_co_status = b_co_status.

           coqty = coqty + b_co_qty_cur.
           conum = conum + 1.
        END.
    END.
    ELSE DO:

        FOR EACH b_co_mstr WHERE  (b_co_part >= part AND b_co_part <= part1)
            AND (b_co_lot >= lot AND b_co_lot <= lot1) AND b_co_status NE "DISABLE" AND 
            b_co_status = bcsta :
            CREATE t_co_mstr.
            ASSIGN 
                t_co_code = b_co_code
                t_co_part = b_co_part
                t_co_site = b_co_site
                t_co_loc = b_co_loc
                t_co_lot = b_co_lot
                t_co_qty_cur = b_co_qty_cur
                t_co_status = b_co_status.

           coqty = coqty + b_co_qty_cur.
           conum = conum + 1.
        END.
    END.


    OPEN QUERY q_co FOR EACH t_co_mstr.
     DISP coqty conum WITH FRAME a.

    REPEAT:
        UPDATE b_co  WITH FRAME a.
    END.
END.
