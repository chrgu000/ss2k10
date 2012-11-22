
/*a6rrddet.i  修改短缺量,增加區域判斷明細..*/
/*
   1--a6rrd_custpono
   2--a6rrd_custpoln
   3--a6rrd_part
   4--detail..

*/
 /*
 MESSAGE STRING(rrd_sort) .
 PAUSE .
ASSIGN rrd_sort = rrd_sort + 1 .
MESSAGE STRING(rrd_sort) .
PAUSE .
*/

CREATE a6rrd_det .
ASSIGN a6rrd_site        = site
       a6rrd_custpono    =  {1}
       a6rrd_custpoln    = {2}
       a6rrd_sort        =  rrd_sort
        a6rrd_part       = {3}
        a6rrd_pmcode      = tpart_pmcode
      /* a6rrd_key         =
       a6rrd_yld_pcd     =
       a6rrd_scrap_pcd   =   */
       a6rrd_rel_Date    = rel_date
       a6rrd_rq_qty      = tmrp_qty
       /* a6rrd_desc        =     */
       a6rrd_rel_ord     = tmrp_ord_nbr
       a6rrd_rel_id      = tmrp_ord_id
       a6rrd_ord_type    = tmrp_ord_type
       a6rrd_short_qty   = SHORT_qty
       a6rrd_cust = {5}
       a6rrd_desc = STRING ({6}) .
   IF tmrp_type = 'CPO' THEN ASSIGN a6rrd_due_date    = tmrp_due_date1  a6rrd_rq_date = tmrp_due_Date  .
   ELSE ASSIGN a6rrd_due_date = due_date  a6rrd_rq_date  = tmrp_due_date  .


    IF tpart_pmcode = 'p' THEN DO:
      CASE {4}:
          WHEN 1 THEN ASSIGN a6rrd_zone = 1 a6rrd_remark = getmsg(7806). /* '庫存足,過期區' .             */
          WHEN 2 THEN ASSIGN a6rrd_zone = 2 a6rrd_remark = getmsg(7807). /* '庫存不足,采購過期' .         */
          WHEN 3 THEN ASSIGN a6rrd_zone = 3 a6rrd_remark = getmsg(7808). /* '庫存足,欠料區' .             */
          WHEN 4 THEN ASSIGN a6rrd_zone = 4 a6rrd_remark = getmsg(7809). /* '庫存不足,采購期不足' .       */
          WHEN 5 THEN ASSIGN a6rrd_zone = 5 a6rrd_remark = getmsg(7810). /* '庫存足,潛在欠料區' .         */
          WHEN 6 THEN ASSIGN a6rrd_zone = 6 a6rrd_remark = getmsg(7811). /* '庫存不足,跟進采購' .         */
          WHEN 7 THEN ASSIGN a6rrd_zone = 7 a6rrd_remark = getmsg(7812). /* '按正常物料計划運作,安全區' . */
      END CASE.
    END.
    ELSE DO:
       CASE {4}:
          WHEN 1 THEN ASSIGN  a6rrd_zone = 1 a6rrd_remark = getmsg(7806). /* '庫存足,過期區' .             */
          WHEN 2 THEN ASSIGN  a6rrd_zone = 2 a6rrd_remark = getmsg(7813). /* '庫存不足,生產過期' .         */
          WHEN 3 THEN ASSIGN  a6rrd_zone = 3 a6rrd_remark = getmsg(7808). /* '庫存足,欠料區'  .            */
          WHEN 4 THEN ASSIGN  a6rrd_zone = 4 a6rrd_remark = getmsg(7814). /* '庫存不足,生產期不足' .       */
          WHEN 5 THEN ASSIGN  a6rrd_zone = 5 a6rrd_remark = getmsg(7810). /* '庫存足,潛在欠料區'    .      */
          WHEN 6 THEN ASSIGN  a6rrd_zone = 6 a6rrd_remark = getmsg(7815). /* '庫存不足,跟進生產'  .        */
          WHEN 7 THEN ASSIGN  a6rrd_zone = 7 a6rrd_remark = getmsg(7816). /* '按正常生產計划運作,安全區' . */
      END CASE.
    END.

