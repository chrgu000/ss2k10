{mfdtitle.i "k+"}
DEFINE VARIABLE cmtype LIKE cm_type.

DEFINE TEMP-TABLE lcp_mstr
    FIELD lcp_cust_type LIKE cm_type LABEL "�ͻ�����"
    /*FIELD lcp_cust LIKE cp_cust*/
    FIELD lcp_part LIKE cp_part LABEL "���"
    FIELD lcp_cust_part LIKE cp_cust_part  LABEL "�ͻ����"
    FIELD lcp_comment LIKE cp_comment LABEL "��ע"
    FIELD lcp_cust_eco LIKE cp_cust_eco LABEL "�ͻ����̺�"
    FIELD lcp_cust_partd LIKE cp_cust_partd LABEL "��ӡ����"
    INDEX custtype lcp_cust_type ASC.

STATUS INPUT "system is loading data".

/*
FOR EACH cp_mstr , EACH cm_mstr WHERE cp_cust = cm_addr
    USE-INDEX cm_addr
    BREAK BY cm_type BY cp_cust_part:
    IF LAST-OF(cp_cust_part) THEN DO:
        CREATE lcp_mstr.
        ASSIGN
            lcp_cust_type = cm_type
            /*lcp_cust = cp_cust*/
            lcp_part = cp_part
            lcp_cust_part = cp_cust_part
            lcp_comment = cp_comment
            lcp_cust_eco = cp_cust_eco
            lcp_cust_partd = cp_cust_partd.
            /*    ASSIGN
            lcp_cust_type = "lld"
            lcp_cust = "lld"
            lcp_part = "lld"
            lcp_cust_part = "lld"
            lcp_comment = "cp_comment"
            lcp_cust_eco = "cp_cust_eco"
            lcp_cust_partd = "cp_cust_partd".*/

    END.
END.
*/


DEFINE QUERY q_lcp FOR lcp_mstr SCROLLING.

DEFINE BROWSE b_lcp QUERY q_lcp
    DISP /*lcp_cust*/
    lcp_cust_type
    lcp_part
    lcp_cust_part
    lcp_comment
    lcp_cust_eco
    lcp_cust_partd
    WITH 10 DOWN SEPARATORS /*MULTIPLE*/ SIZE 80 BY 12 TITLE "�ͻ����" /*THREE-D*/ /*EXPANDABLE SCROLLABLE*/.

DEFINE QUERY q_cp FOR cp_mstr,  cm_mstr
             SCROLLING.

DEFINE BROWSE b_cp QUERY q_cp
    DISP cp_cust
    cp_part
    cp_cust_part
    cp_comment
    cp_cust_eco
    cp_cust_partd
    WITH 10 DOWN SEPARATORS /*MULTIPLE*/ SIZE 80 BY 12 TITLE "�ͻ����"  /*EXPANDABLE SCROLLABLE*/.

DEFINE FRAME f_cm
    cm_type SKIP
    WITH WIDTH 80 THREE-D SIDE-LABEL NO-BOX.

DEFINE FRAME f_lcp
    b_lcp SKIP
    WITH WIDTH 80 THREE-D NO-BOX.

DEFINE FRAME f_cp
    b_cp SKIP
    WITH WIDTH 80 THREE-D NO-BOX.

DEFINE FRAME f_lcp_detail
    SKIP(.3)
    lcp_cust_type AT 5
    lcp_part AT 45
    lcp_cust_part AT 5
    lcp_comment AT 5
    lcp_cust_eco AT 5
    lcp_cust_partd AT 5
    SKIP(1)
    WITH WIDTH 80 THREE-D NO-BOX SIDE-LABEL.
  

REPEAT:
    
  PROMPT-FOR cm_type WITH FRAME f_cm.
  STATUS INPUT "system is loading data...".
  FOR EACH cp_mstr , EACH cm_mstr WHERE cp_cust = cm_addr
      AND cm_type = cm_type:SCREEN-VALUE
    USE-INDEX cm_addr
    BREAK BY cm_type BY cp_cust_part:
    IF LAST-OF(cp_cust_part) THEN DO:
        CREATE lcp_mstr.
        ASSIGN
            lcp_cust_type = cm_type
            lcp_part = cp_part
            lcp_cust_part = cp_cust_part
            lcp_comment = cp_comment
            lcp_cust_eco = cp_cust_eco
            lcp_cust_partd = cp_cust_partd.
    END.
   END.
  
 REPEAT:
  STATUS INPUT "F2 = GO F3 = ADD F4 = MODIFY F5 = DELETE F6 = UPDATE ENTER = VIEW DETAIL".
  OPEN QUERY q_lcp FOR EACH lcp_mstr.
  UPDATE b_lcp  GO-ON(F5 F4 F3 F6 ENTER)  WITH FRAME f_lcp.

   IF LASTKEY = KEYCODE("ENTER") THEN DO:
       OPEN QUERY q_cp FOR EACH cp_mstr , EACH cm_mstr
            WHERE cm_addr = cp_cust 
           AND cm_type = lcp_cust_type AND cp_cust_part = lcp_cust_part.
       UPDATE b_cp WITH FRAME f_cp.
   END.

   IF LASTKEY = KEYCODE("F3") THEN DO:
       SET lcp_cust_type
           lcp_part 
           lcp_cust_part
           lcp_comment
           lcp_cust_eco
           lcp_cust_partd
           WITH FRAME f_lcp_detail.
          FOR EACH cm_mstr WHERE cm_type = lcp_cust_type:
                CREATE cp_mstr.
                ASSIGN 
                  cp_cust = cm_addr
                  cp_part = lcp_part
                  cp_cust_part = lcp_cust_part
                  cp_comment = lcp_comment
                  cp_cust_eco = cp_cust_eco
                  cp_cust_partd = cp_cust_partd.
          END.
   END.

   IF LASTKEY = KEYCODE("F4") THEN DO:
       MESSAGE lcp_cust_type VIEW-AS ALERT-BOX.
       UPDATE lcp_cust_type
           lcp_part 
           lcp_cust_part
           lcp_comment
           lcp_cust_eco
           lcp_cust_partd
           WITH FRAME f_lcp_detail.
          FOR EACH cm_mstr WHERE cm_type = lcp_cust_type:
              FIND FIRST cp_mstr EXCLUSIVE-LOCK WHERE cp_cust = cm_addr
                  AND cp_cust_part = lcp_cust_part NO-ERROR.
              IF NOT AVAILABLE cp_mstr THEN DO:
                CREATE cp_mstr.
                ASSIGN 
                  cp_cust = cm_addr
                  cp_part = lcp_part
                  cp_cust_part = lcp_cust_part
                  cp_comment = lcp_comment
                  cp_cust_eco = cp_cust_eco
                  cp_cust_partd = cp_cust_partd.
              END.
              ELSE DO:
                ASSIGN 
                  cp_cust = cm_addr
                  cp_part = lcp_part
                  cp_cust_part = lcp_cust_part
                  cp_comment = lcp_comment
                  cp_cust_eco = cp_cust_eco
                  cp_cust_partd = cp_cust_partd.
              END.
          END.
   END.

   IF LASTKEY = KEYCODE("F5") THEN DO:
       MESSAGE "�Ƿ�Ҫɾ��������¼�������ص����пͻ�������ᱻɾ��" VIEW-AS ALERT-BOX BUTTONS OK-CANCEL
           UPDATE yn AS LOGICAL.
       IF yn = YES THEN DO:
           DELETE lcp_mstr.
         FOR EACH cm_mstr WHERE cm_type = lcp_cust_type:
              FIND FIRST cp_mstr EXCLUSIVE-LOCK WHERE cp_cust = cm_addr
                  AND cp_cust_part = lcp_cust_part NO-ERROR.
              IF  AVAILABLE cp_mstr THEN DO:
              
                DELETE cp_mstr.
              END.
         END.
       END.
       ELSE DO:
         NEXT.
       END.
   END.
       
   IF LASTKEY = KEYCODE("F6") THEN DO:
       MESSAGE "�����ѿͻ�����Ϊ" + lcp_cust_type + "�Ŀͻ����Ϊ" +  lcp_cust_part + "����Ϊ�������" + lcp_part VIEW-AS ALERT-BOX.
        FOR EACH cm_mstr WHERE cm_type = lcp_cust_type:
              FIND FIRST cp_mstr EXCLUSIVE-LOCK WHERE cp_cust = cm_addr
                  AND cp_cust_part = lcp_cust_part NO-ERROR.
              IF NOT AVAILABLE cp_mstr THEN DO:
                CREATE cp_mstr.
                ASSIGN 
                  cp_cust = cm_addr
                  cp_part = lcp_part
                  cp_cust_part = lcp_cust_part
                  cp_comment = lcp_comment
                  cp_cust_eco = cp_cust_eco
                  cp_cust_partd = cp_cust_partd.
              END.
        END.
   END.
END.
 END.

