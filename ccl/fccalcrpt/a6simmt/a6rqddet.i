/*a6rqddet.i  �޸Ķ�ȱ��,���Ӆ^���Д�����..*/
/*
   1--a6rqd_custpono
   2--a6rqd_custpoln
   3--a6rqd_part 
   4--detail..
*/

FOR EACH a6rqd_det WHERE a6rqd_site = site AND a6rqd_cust = {5} AND a6rqd_custpono = {1}  
                     AND a6rqd_custpoln = {2} AND a6rqd_part = {3} :

    IF AVAILABLE a6rqd_det THEN  DO:
         ASSIGN a6rqd_short_qty = short_qty    a6rqd_char02 = STRING({6}) .
        IF a6rqd_pmcode = 'p' THEN DO:
          CASE {4}:
              WHEN 1 THEN ASSIGN a6rqd_stock = YES a6rqd_zone = 1 a6rqd_remark = getmsg(7806). /* '�����,�^�څ^' .              */
              WHEN 2 THEN ASSIGN a6rqd_stock = NO  a6rqd_zone = 2 a6rqd_remark = getmsg(7807). /* '��治��,��ُ�^��' .          */
              WHEN 3 THEN ASSIGN a6rqd_stock = YES a6rqd_zone = 3 a6rqd_remark = getmsg(7808). /* '�����,Ƿ�υ^' .              */
              WHEN 4 THEN ASSIGN a6rqd_stock = NO  a6rqd_zone = 4 a6rqd_remark = getmsg(7809). /* '��治��,��ُ�ڲ���' .        */
              WHEN 5 THEN ASSIGN a6rqd_stock = YES a6rqd_zone = 5 a6rqd_remark = getmsg(7810). /* '�����,����Ƿ�υ^' .          */
              WHEN 6 THEN ASSIGN a6rqd_stock = NO  a6rqd_zone = 6 a6rqd_remark = getmsg(7811). /* '��治��,���M��ُ' .          */
              WHEN 7 THEN ASSIGN a6rqd_stock = YES a6rqd_zone = 7 a6rqd_remark = getmsg(7812). /* '����������Ӌ���\��,��ȫ�^' .  */
          END CASE.
        END.
        ELSE DO:
           CASE {4}:
              WHEN 1 THEN ASSIGN a6rqd_stock = YES a6rqd_zone = 1 a6rqd_remark = getmsg(7806). /* '�����,�^�څ^' .             */
              WHEN 2 THEN ASSIGN a6rqd_stock = NO  a6rqd_zone = 2 a6rqd_remark = getmsg(7813). /* '��治��,���a�^��' .         */
              WHEN 3 THEN ASSIGN a6rqd_stock = YES a6rqd_zone = 3 a6rqd_remark = getmsg(7808). /* '�����,Ƿ�υ^'  .            */
              WHEN 4 THEN ASSIGN a6rqd_stock = NO  a6rqd_zone = 4 a6rqd_remark = getmsg(7814). /* '��治��,���a�ڲ���' .       */
              WHEN 5 THEN ASSIGN a6rqd_stock = YES a6rqd_zone = 5 a6rqd_remark = getmsg(7810). /* '�����,����Ƿ�υ^'    .      */
              WHEN 6 THEN ASSIGN a6rqd_stock = NO  a6rqd_zone = 6 a6rqd_remark = getmsg(7815). /* '��治��,���M���a'  .        */
              WHEN 7 THEN ASSIGN a6rqd_stock = YES a6rqd_zone = 7 a6rqd_remark = getmsg(7816). /* '���������aӋ���\��,��ȫ�^' . */
          END CASE.
        END.
    END.
END.


