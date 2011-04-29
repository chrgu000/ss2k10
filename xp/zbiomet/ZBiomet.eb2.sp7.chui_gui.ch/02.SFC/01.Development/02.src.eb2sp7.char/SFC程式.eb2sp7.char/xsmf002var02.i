/* xsmf002var02.i  called by xsmf002.p   BARCODE SFC SYSTEM MAIN FRAME var defines      */
/* REVISION: 1.0         Last Modified: 2008/11/27   By: Roger   ECO:      */
/*-Revision end------------------------------------------------------------*/

/*
define var v_recno as recid . 
define var sectionid as integer init 0 .
define var wtm_num   as char format "x(20)" init "0".
define var wtm_fm    as char format "x(16)".
define var wsection  as char format "x(16)".
define var OkToRun   as logical init no .
*/

define var v_now  as char label "时间" format "x(20)" .
v_now = string(string(year(today),"9999") + "/" 
        + string(month(today),"99") + "/" 
        + string(day(today),"99") + " " 
        + string(time,"HH:MM:SS") ) .



define temp-table temp1 
    field t1_trnbr       like xxfb_trnbr
    field t1_type        like xxfb_type2 
    field t1_date_start  as date 
    field t1_date_end    as date
    field t1_time_start  as char format "x(5)"
    field t1_time_end    as char format "x(5)"
    field t1_time_used   as integer 
    field t1_wolot       as char
    field t1_op          as integer format ">>>" 
    field t1_qty         as decimal format "->>>>>>9.9<<"
    field t1_rmks        as char format "x(12)"
    .




define var v_nn as integer .                                   /*frame main1 行数控制*/
define var v_leave as logical format "Y/N".                                /*for leaveloop */
define var v_qty_open as decimal  .                        /*for frame main2*/
define var v_pwd  as char format "x(16)" .      /*用户登录密码*/     
