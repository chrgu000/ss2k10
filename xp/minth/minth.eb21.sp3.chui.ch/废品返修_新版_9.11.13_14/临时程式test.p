{mfdtitle.i}



/*1.查找昨天出错的记录********
for each xlkh_hist 
    where xlkh_domain = global_domain 
    and xlkh_line = "生产线代码"
    and xlkh_part = "返修前零件代码" 
    and xlkh_qc_qty > 0 
    and xlkh_scrap_date = date(04,26,2010)
    and xlkh_scrap_user = "昨天的操作员"
    no-lock:
disp xlkh_trnbr xlkh_line xlkh_part xlkh_qc_qty xlkh_scrap_date xlkh_scrap_qty xlkh_ok_qty .
end.
****************************/


/*2.修改为:未执行过报废返修*************
define var aaa like xlkh_trnbr.

repeat:
    update aaa with frame a.

    for each xlkh_hist 
        where xlkh_domain = global_domain 
        and xlkh_trnbr = aaa :
        assign xlkh_scrap_date = ?
    end.
end.
****************************/
