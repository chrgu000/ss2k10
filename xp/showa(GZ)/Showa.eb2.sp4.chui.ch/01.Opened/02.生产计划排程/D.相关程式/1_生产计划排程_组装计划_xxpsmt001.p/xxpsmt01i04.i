    /*�����Ų�ǰ�����ۿ��=(ʵ�ʿ��+δ����ȹ���-δ����������)*/   
	/*ȡ��ǰʱ���,û�а���v_time_stock,���Ǳ����賿2���????*/
    for each kc_det 
        where  kc_site = site
        and    kc_date = today :


        /*ʵ�ʿ��*/
        find first in_mstr 
            where in_part = kc_part
            and   in_site = kc_site
        no-lock no-error.
        kc_qty_oh = if avail in_mstr then in_qty_oh else 0 .

        /*δ������ų̹���*/
        for each wo_mstr 
            use-index wo_type_part 
            where wo_type = "S"
            and   wo_part = kc_part 
            and   wo_site = kc_site
            and   wo_due_date <= kc_date
            no-lock:
            kc_qty_oh = kc_qty_oh + (wo_qty_ord - wo_qty_comp) .
        end.

        /*δ����������*/
        for each nr_det 
            where nr_site = site
            and   nr_part = kc_part 
            and   nr_due_date <= kc_date :
            kc_qty_oh = kc_qty_oh - nr_qty_open .
        end.

        kc_qty_oh = max(0,kc_qty_oh ) .

    end. /* for each kc_det */
