{mfdtitle.i}



/*1.�����������ļ�¼********
for each xlkh_hist 
    where xlkh_domain = global_domain 
    and xlkh_line = "�����ߴ���"
    and xlkh_part = "����ǰ�������" 
    and xlkh_qc_qty > 0 
    and xlkh_scrap_date = date(04,26,2010)
    and xlkh_scrap_user = "����Ĳ���Ա"
    no-lock:
disp xlkh_trnbr xlkh_line xlkh_part xlkh_qc_qty xlkh_scrap_date xlkh_scrap_qty xlkh_ok_qty .
end.
****************************/


/*2.�޸�Ϊ:δִ�й����Ϸ���*************
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
