
/*a6rrddet.i  �޸Ķ�ȱ��,���Ӆ^���Д�����..*/
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
          WHEN 1 THEN ASSIGN a6rrd_zone = 1 a6rrd_remark = getmsg(7806). /* '�����,�^�څ^' .             */
          WHEN 2 THEN ASSIGN a6rrd_zone = 2 a6rrd_remark = getmsg(7807). /* '��治��,��ُ�^��' .         */
          WHEN 3 THEN ASSIGN a6rrd_zone = 3 a6rrd_remark = getmsg(7808). /* '�����,Ƿ�υ^' .             */
          WHEN 4 THEN ASSIGN a6rrd_zone = 4 a6rrd_remark = getmsg(7809). /* '��治��,��ُ�ڲ���' .       */
          WHEN 5 THEN ASSIGN a6rrd_zone = 5 a6rrd_remark = getmsg(7810). /* '�����,����Ƿ�υ^' .         */
          WHEN 6 THEN ASSIGN a6rrd_zone = 6 a6rrd_remark = getmsg(7811). /* '��治��,���M��ُ' .         */
          WHEN 7 THEN ASSIGN a6rrd_zone = 7 a6rrd_remark = getmsg(7812). /* '����������Ӌ���\��,��ȫ�^' . */
      END CASE.
    END.
    ELSE DO:
       CASE {4}:
          WHEN 1 THEN ASSIGN  a6rrd_zone = 1 a6rrd_remark = getmsg(7806). /* '�����,�^�څ^' .             */
          WHEN 2 THEN ASSIGN  a6rrd_zone = 2 a6rrd_remark = getmsg(7813). /* '��治��,���a�^��' .         */
          WHEN 3 THEN ASSIGN  a6rrd_zone = 3 a6rrd_remark = getmsg(7808). /* '�����,Ƿ�υ^'  .            */
          WHEN 4 THEN ASSIGN  a6rrd_zone = 4 a6rrd_remark = getmsg(7814). /* '��治��,���a�ڲ���' .       */
          WHEN 5 THEN ASSIGN  a6rrd_zone = 5 a6rrd_remark = getmsg(7810). /* '�����,����Ƿ�υ^'    .      */
          WHEN 6 THEN ASSIGN  a6rrd_zone = 6 a6rrd_remark = getmsg(7815). /* '��治��,���M���a'  .        */
          WHEN 7 THEN ASSIGN  a6rrd_zone = 7 a6rrd_remark = getmsg(7816). /* '���������aӋ���\��,��ȫ�^' . */
      END CASE.
    END.

