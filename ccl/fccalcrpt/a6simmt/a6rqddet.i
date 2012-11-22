/*a6rqddet.i  修改短缺量,增加區域判斷明細..*/
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
              WHEN 1 THEN ASSIGN a6rqd_stock = YES a6rqd_zone = 1 a6rqd_remark = getmsg(7806). /* '庫存足,過期區' .              */
              WHEN 2 THEN ASSIGN a6rqd_stock = NO  a6rqd_zone = 2 a6rqd_remark = getmsg(7807). /* '庫存不足,采購過期' .          */
              WHEN 3 THEN ASSIGN a6rqd_stock = YES a6rqd_zone = 3 a6rqd_remark = getmsg(7808). /* '庫存足,欠料區' .              */
              WHEN 4 THEN ASSIGN a6rqd_stock = NO  a6rqd_zone = 4 a6rqd_remark = getmsg(7809). /* '庫存不足,采購期不足' .        */
              WHEN 5 THEN ASSIGN a6rqd_stock = YES a6rqd_zone = 5 a6rqd_remark = getmsg(7810). /* '庫存足,潛在欠料區' .          */
              WHEN 6 THEN ASSIGN a6rqd_stock = NO  a6rqd_zone = 6 a6rqd_remark = getmsg(7811). /* '庫存不足,跟進采購' .          */
              WHEN 7 THEN ASSIGN a6rqd_stock = YES a6rqd_zone = 7 a6rqd_remark = getmsg(7812). /* '按正常物料計划運作,安全區' .  */
          END CASE.
        END.
        ELSE DO:
           CASE {4}:
              WHEN 1 THEN ASSIGN a6rqd_stock = YES a6rqd_zone = 1 a6rqd_remark = getmsg(7806). /* '庫存足,過期區' .             */
              WHEN 2 THEN ASSIGN a6rqd_stock = NO  a6rqd_zone = 2 a6rqd_remark = getmsg(7813). /* '庫存不足,生產過期' .         */
              WHEN 3 THEN ASSIGN a6rqd_stock = YES a6rqd_zone = 3 a6rqd_remark = getmsg(7808). /* '庫存足,欠料區'  .            */
              WHEN 4 THEN ASSIGN a6rqd_stock = NO  a6rqd_zone = 4 a6rqd_remark = getmsg(7814). /* '庫存不足,生產期不足' .       */
              WHEN 5 THEN ASSIGN a6rqd_stock = YES a6rqd_zone = 5 a6rqd_remark = getmsg(7810). /* '庫存足,潛在欠料區'    .      */
              WHEN 6 THEN ASSIGN a6rqd_stock = NO  a6rqd_zone = 6 a6rqd_remark = getmsg(7815). /* '庫存不足,跟進生產'  .        */
              WHEN 7 THEN ASSIGN a6rqd_stock = YES a6rqd_zone = 7 a6rqd_remark = getmsg(7816). /* '按正常生產計划運作,安全區' . */
          END CASE.
        END.
    END.
END.


