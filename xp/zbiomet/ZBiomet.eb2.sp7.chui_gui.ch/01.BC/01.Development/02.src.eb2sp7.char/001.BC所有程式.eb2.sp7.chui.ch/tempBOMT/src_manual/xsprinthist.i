/*保留条码打印历史记录 */
/* REVISION: 1.0         Last Modified: 2008/10/23   By: Roger             */
/* 20081106 客户tommy 要求保留到客制的table,所以:usrw_wkfl---> xprn_hist    */
/*-Revision end------------------------------------------------------------*/




/*------------------变量保存到历史记录-------------------------*/
define var vv_ii as integer .

find last xprn_hist 
    where xprn_key1 = "bcprint" 
    and   xprn_key2 begins string(year(today),"9999") + string(month(today),"99") + string(day(today),"99") /*today*/
exclusive-lock no-error .
vv_ii = if not avail xprn_hist then 1 else integer(substring(xprn_key2,9,4)) + 1 .
release xprn_hist .

find last xprn_hist 
    where xprn_key1 = "bcprint" 
    and xprn_key2 = string(year(today),"9999") + string(month(today),"99") + string(day(today),"99") + string(vv_ii,"9999") 
no-lock no-error .
if not avail xprn_hist then do:
    create xprn_hist.
    assign 
    xprn_key1       = "bcprint"             /*固定值*/
    xprn_key2       = string(year(today),"9999") + string(month(today),"99") + string(day(today),"99") + string(vv_ii,"9999")  /*流水号*/
    xprn_part       = vv_part2               /*零件编号*/
    xprn_lot        = vv_lot2                /*批号*/
    xprn_user       = global_userid          /*标签打印帐户*/
    xprn_date       = today                  /*标签打印日期*/
    xprn_time       = time                   /*标签打印时间*/
    xprn_execname   = execname               /*标签打印程式*/
    xprn_filename   = vv_filename2           /*生成的文件*/
    xprn_fileword   = vv_oneword2            /*打印的内容*/
    xprn_lbl_model  = vv_label2              /*所用的label模板*/
    xprn_nums       = integer(wtm_num)       /*标签张数*/
    xprn_qty        = decimal(vv_qtyp2)      /*标签数量*/
    .
    release xprn_hist .
end.
/*------------------变量保存到历史记录-------------------------*/

