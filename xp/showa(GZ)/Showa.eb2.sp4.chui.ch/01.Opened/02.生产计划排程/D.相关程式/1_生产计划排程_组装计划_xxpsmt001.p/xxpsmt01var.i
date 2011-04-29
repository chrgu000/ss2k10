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


define {1} shared temp-table err_det  /*错误信息汇总*/
    field err_site        like sod_site
    field err_part        as char format "x(18)"
    field err_type        as char format "x(1)"
    field err_desc        as char format "x(100)"
    .

/*转移到数据库,提升速度***********************************************

define {1} shared temp-table nr_det  /*纳入明细*/
    field nr_site         like sod_site
    field nr_part         like sod_part
    field nr_due_date     like sod_due_date 
    field nr_qty_open     like sod_qty_ord 
    .                     
                          

define {1} shared temp-table kc_det  /*理论库存*/
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


define {1} shared temp-table xrq_det  /*排程时间点的可用容器数量*/
    field xrq_site        like sod_site
    field xrq_nbr         like sod_nbr 
    field xrq_qty_today   as integer  
    .

define {1} shared temp-table xrh_hist  /*本次排程,每天,每个机种,耗用的容器数量????????*/
    field xrh_site        like sod_site
    field xrh_nbr         like sod_nbr 
    field xrh_part        like sod_part
    field xrh_date        as date 
    field xrh_qty_used    as integer  
    .

define {1} shared temp-table xovh_hist  /*加班历史????????????*/
    field xovh_site       like sod_site
    field xovh_line       like lnd_line
    field xovh_part       like sod_part
    field xovh_date       as date 
    field xovh_time_1     as decimal /*班次1*/  
    field xovh_time_2     as decimal /*班次2*/  
    field xovh_time_3     as decimal /*班次1*/  
    field xovh_time_4     as decimal /*班次2*/  
    .

define {1} shared temp-table xln_det  /*每个零件的主产线*/
    field xln_site        like sod_site
    field xln_line        like lnd_line
    field xln_part        as char 
    field xln_main        as logical /*是否主产线*/
    field xln_used        as logical /*是否有排程*/
    field xln_qty_per_min as decimal /*每分钟产出产品件数*/
    .



define {1} shared temp-table ttemp1 /*本次排程,每个产线的最优生产顺序*/
    field tt1_site        as char
    field tt1_line        as char 
    field tt1_partlist    as char   /*逗号分隔的字符串*/
    field tt1_time        as decimal 
    .
define {1} shared temp-table ttemp2 /*本次排程,每个产线的最优生产顺序*/
    field tt2_site        as char
    field tt2_line        as char 
    field tt2_seq         as integer 
    field tt2_part        as char 
    .



define {1} shared temp-table xcn_det  /*产线每日可用产能*/
    field xcn_site        like sod_site
    field xcn_line        like lnd_line
    field xcn_date        as date 
    field xcn_time_1      as decimal /*班次1*/
    field xcn_time_2      as decimal /*班次2*/
    field xcn_time_3      as decimal /*班次3*/
    field xcn_time_4      as decimal /*班次4*/
    field xcn_time_used   as decimal /*当天已耗产能*/
    .


define {1} shared temp-table xps_mstr  /*排程主表*/
    field xps_rev         as   char
    field xps_site        like sod_site
    field xps_part        like sod_part
    field xps_date        as date 
    field xps_type        as char format "x(2)"

    field xps_qty_min     as decimal 
    field xps_qty_left    as decimal 
    .



define {1} shared temp-table xpsd_det  /*排程明细表*/
    field xpsd_rev         as   char
    field xpsd_site        like sod_site
    field xpsd_line        like lnd_line
    field xpsd_part        like sod_part
    field xpsd_date        as date 
    field xpsd_type        as char format "x(2)"

    field xpsd_seq         as integer  /*排产顺序*/

    field xpsd_qty_prod1   as decimal  /*班次1*/ 
    field xpsd_qty_prod2   as decimal  /*班次2*/ 
    field xpsd_qty_prod3   as decimal  /*班次3*/ 
    field xpsd_qty_prod4   as decimal  /*班次4*/ 
    .


