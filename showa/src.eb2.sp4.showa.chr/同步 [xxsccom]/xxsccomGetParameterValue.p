/* SS - 090908.1 By: Bill Jiang */

/* SS - 090908.1 - RNB
[090908.1]

1. ���ݷ��������Ӧ�ļ�����ȡ����
2. �������:
   1) feedbackFileName - ��Ӧ�ļ�
   2) rspcod - ������
3. �������:
   1) rspnbr:
      0 - �ɹ�
      53 - �ļ�������
      722 - �ֶβ�����
   2) rspmsg:
      0 - ����
      ��0 - ��

[090908.1]

SS - 090908.1 - RNE */

{mfdeclre.i}
{gplabel.i}

DEFINE INPUT PARAMETER feedbackFileName AS CHARACTER.
DEFINE INPUT PARAMETER rspcod AS CHARACTER.
/*
DEFINE VARIABLE rspcod AS CHARACTER INITIAL "msg".
*/
DEFINE OUTPUT PARAMETER rspnbr LIKE msg_nbr.
DEFINE OUTPUT PARAMETER rspmsg AS CHARACTER.

DEFINE VARIABLE i1 AS INTEGER.
DEFINE VARIABLE i2 AS INTEGER.

DEFINE TEMP-TABLE tt
    FIELD tt_c1 AS CHARACTER
    .

IF NOT (SEARCH(feedbackFileName) <> ?) THEN DO:
   /* �ļ������� */
   rspnbr = 53.
   rspmsg = "".
   RETURN.
END.

/* TEMP */
EMPTY TEMP-TABLE tt NO-ERROR.

INPUT FROM VALUE(feedbackFileName).
REPEAT:
   CREATE tt.
   IMPORT UNFORMATTED tt.
   i1 = INDEX(tt_c1,"<" + rspcod + ">").
   IF i1 <> 0 THEN DO:
      i1 = i1 + LENGTH("<" + rspcod + ">").
      i2 = INDEX(tt_c1,"</" + rspcod + ">").
      rspnbr = 0.
      rspmsg = SUBSTRING(tt_c1,i1,i2 - i1).
      INPUT CLOSE.
      RETURN.
   END. /* IF i1 <> 0 THEN DO: */
END.
INPUT CLOSE.

/* �ֶβ����� */
rspnbr = 722.
rspmsg = "".

