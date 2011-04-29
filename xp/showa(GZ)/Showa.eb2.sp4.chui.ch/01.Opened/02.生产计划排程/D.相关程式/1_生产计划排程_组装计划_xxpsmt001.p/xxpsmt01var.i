define {1} shared var site            as char    init "GSA01" no-undo .
define {1} shared var v_week          as integer format "9" init 4 no-undo .
define {1} shared var v_month         as integer format "9" init 6 no-undo .
define {1} shared var v_sortby        as integer format "9" init 1 no-undo .


define {1} shared var v_date_min      as decimal .
define {1} shared var v_date_max      as decimal .

define {1} shared var v_case_used     as integer .

define {1} shared var v_nr_type       as char .
define {1} shared var v_nr_date       as date .

define {1} shared var v_rev           as char .


define {1} shared temp-table err_det  /*������Ϣ����*/
    field err_site        like sod_site
    field err_part        as char format "x(18)"
    field err_type        as char format "x(1)"
    field err_desc        as char format "x(100)"
    .

/*ת�Ƶ����ݿ�,�����ٶ�***********************************************

define {1} shared temp-table nr_det  /*������ϸ*/
    field nr_site         like sod_site
    field nr_part         like sod_part
    field nr_due_date     like sod_due_date 
    field nr_qty_open     like sod_qty_ord 
    .                     
                          

define {1} shared temp-table kc_det  /*���ۿ��*/
    field kc_site         like sod_site
    field kc_part         like sod_part
    field kc_type         like pt_status
    field kc_date         like sod_due_date 
    field kc_qty_nr       like sod_qty_ord 
    field kc_qty_oh       like ld_qty_oh 
    field kc_qty_min      like sod_qty_ord 
    field kc_qty_max      like sod_qty_ord 
    .
************************************************/


define {1} shared temp-table xrq_det  /*�ų�ʱ���Ŀ�����������*/
    field xrq_site        like sod_site
    field xrq_nbr         like sod_nbr 
    field xrq_qty_today   as integer  
    .

define {1} shared temp-table xrh_hist  /*�����ų�,ÿ��,ÿ������,���õ���������????????*/
    field xrh_site        like sod_site
    field xrh_nbr         like sod_nbr 
    field xrh_part        like sod_part
    field xrh_date        as date 
    field xrh_qty_used    as integer  
    .

define {1} shared temp-table xovh_hist  /*�Ӱ���ʷ????????????*/
    field xovh_site       like sod_site
    field xovh_line       like lnd_line
    field xovh_part       like sod_part
    field xovh_date       as date 
    field xovh_time_1     as decimal /*���1*/  
    field xovh_time_2     as decimal /*���2*/  
    field xovh_time_3     as decimal /*���1*/  
    field xovh_time_4     as decimal /*���2*/  
    .

define {1} shared temp-table xln_det  /*ÿ�������������*/
    field xln_site        like sod_site
    field xln_line        like lnd_line
    field xln_part        as char 
    field xln_main        as logical /*�Ƿ�������*/
    field xln_used        as logical /*�Ƿ����ų�*/
    field xln_qty_per_min as decimal /*ÿ���Ӳ�����Ʒ����*/
    .



define {1} shared temp-table ttemp1 /*�����ų�,ÿ�����ߵ���������˳��*/
    field tt1_site        as char
    field tt1_line        as char 
    field tt1_partlist    as char   /*���ŷָ����ַ���*/
    field tt1_time        as decimal 
    .
define {1} shared temp-table ttemp2 /*�����ų�,ÿ�����ߵ���������˳��*/
    field tt2_site        as char
    field tt2_line        as char 
    field tt2_seq         as integer 
    field tt2_part        as char 
    .



define {1} shared temp-table xcn_det  /*����ÿ�տ��ò���*/
    field xcn_site        like sod_site
    field xcn_line        like lnd_line
    field xcn_date        as date 
    field xcn_time_1      as decimal /*���1*/
    field xcn_time_2      as decimal /*���2*/
    field xcn_time_3      as decimal /*���3*/
    field xcn_time_4      as decimal /*���4*/
    field xcn_time_used   as decimal /*�����ѺĲ���*/
    .


define {1} shared temp-table xps_mstr  /*�ų�����*/
    field xps_rev         as   char
    field xps_site        like sod_site
    field xps_part        like sod_part
    field xps_date        as date 
    field xps_type        as char format "x(2)"

    field xps_qty_min     as decimal 
    field xps_qty_left    as decimal 
    .



define {1} shared temp-table xpsd_det  /*�ų���ϸ��*/
    field xpsd_rev         as   char
    field xpsd_site        like sod_site
    field xpsd_line        like lnd_line
    field xpsd_part        like sod_part
    field xpsd_date        as date 
    field xpsd_type        as char format "x(2)"

    field xpsd_seq         as integer  /*�Ų�˳��*/

    field xpsd_qty_prod1   as decimal  /*���1*/ 
    field xpsd_qty_prod2   as decimal  /*���2*/ 
    field xpsd_qty_prod3   as decimal  /*���3*/ 
    field xpsd_qty_prod4   as decimal  /*���4*/ 
    .


