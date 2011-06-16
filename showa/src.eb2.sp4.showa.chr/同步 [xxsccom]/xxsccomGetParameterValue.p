/* SS - 090908.1 By: Bill Jiang */

/* SS - 090908.1 - RNB
[090908.1]

1. 根据返回码从响应文件中提取解释
2. 输入参数:
   1) feedbackFileName - 响应文件
   2) rspcod - 返回码
3. 输出参数:
   1) rspnbr:
      0 - 成功
      53 - 文件不存在
      722 - 字段不存在
   2) rspmsg:
      0 - 解释
      非0 - 空

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
   /* 文件不存在 */
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

/* 字段不存在 */
rspnbr = 722.
rspmsg = "".

