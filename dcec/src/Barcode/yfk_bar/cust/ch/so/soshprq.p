{mfdtitle.i}
{bcdeclre.i NEW}
{bcini.i}
/*{bcwin01.i}*/


DEFINE VARIABLE shpnbr  LIKE b_trs_shipper.
DEFINE VARIABLE shpdate AS DATE.
DEFINE VARIABLE part LIKE pt_part.
DEFINE VARIABLE cust LIKE ad_addr.


DEFINE QUERY q_co FOR b_trs_det.
DEFINE BROWSE b_trs QUERY q_co
    DISPLAY
    b_trs_shipper LABEL "���˵�"
    b_trs_part LABEL "���"
    b_trs_f_loc LABEL "�Կ�λ"
     b_trs_t_loc LABEL "����λ"
    b_trs_qty LABEL "����"
    b_trs_cust LABEL "����"
    b_trs_type LABEL "״̬"
    b_trs_date LABEL "����"
    WITH 11 DOWN WIDTH 79
    TITLE "���˵��嵥".



DEFINE FRAME a
    SKIP(.5)
    shpnbr COLON 8 LABEL "���˵�"
    shpdate COLON 40  LABEL "����" 
    /*part COLON 15 LABEL "���"
    cust COLON 45 LABEL "�ͻ�"*/
    SKIP(1)
    b_trs
    SKIP(2)
    SPACE(40)
    WITH WIDTH 80 TITLE "���˵���ѯ"  SIDE-LABELS  NO-UNDERLINE THREE-D.

REPEAT:
     UPDATE shpnbr shpdate /*part cust*/  WITH FRAME a.

     shpnbr = TRIM(shpnbr).

     IF shpnbr = "" AND shpdate = ? THEN DO:
         OPEN QUERY q_co FOR EACH b_trs_det .
     END.

     IF shpnbr NE "" AND shpdate NE ?THEN DO:
         OPEN QUERY q_co FOR EACH b_trs_det WHERE
             b_trs_shipper = shpnbr AND b_trs_date = shpdate.
     END.

       IF shpnbr NE "" AND shpdate EQ ?THEN DO:
         OPEN QUERY q_co FOR EACH b_trs_det WHERE
             b_trs_shipper = shpnbr.
     END.

          IF shpnbr EQ "" AND shpdate NE ?THEN DO:
         OPEN QUERY q_co FOR EACH b_trs_det WHERE
             b_trs_date = shpdate.
     END.

     UPDATE b_trs WITH FRAME a.

 END.


