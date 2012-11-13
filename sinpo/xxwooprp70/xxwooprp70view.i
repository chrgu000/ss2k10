/* SS - 110801.1 By: Kaine Zhang */
put unformat "�������" sDelimiter "����" sDelimiter "������" sDelimiter "����ID" sDelimiter "�����´�����" sDelimiter "�����´�����" sDelimiter "�������" sDelimiter "��������" sDelimiter "��������" sDelimiter "�ӹ��ߴ���" sDelimiter "�ӹ���" sDelimiter "δ�깤����" sDelimiter "�깤δת����" sDelimiter "���ƿ�����" sDelimiter "���ƺϼ�".
for each t3_tmp,
first pt_mstr
    no-lock
    use-index pt_part
    where pt_domain = global_domain
        and pt_part = t3_part
:
    find first wo_mstr
        no-lock
        use-index wo_lot
        where wo_domain = global_domain
            and wo_lot = t3_wo_lot
        no-error.
    find first wr_route
        no-lock
        use-index wr_lot
        where wr_domain = global_domain
            and wr_lot = t3_wo_lot
            and wr_op = t3_op
        no-error.
    find first emp_mstr
        no-lock
        use-index emp_addr
        where emp_domain = global_domain
            and emp_addr = t3_employee
        no-error.
    put
        unformatted
        t3_part at 1                                                      sDelimiter
        pt_desc1 + pt_desc2                                               sDelimiter
        (if available(wo_mstr) then wo_nbr else "")                       sDelimiter
        t3_wo_lot                                                         sDelimiter
        (if available(wo_mstr) then string(wo_rel_date) else "")          sDelimiter
        (if available(wo_mstr) then wo_qty_ord else 0)                    sDelimiter
        t3_op                                                             sDelimiter
        (if available(wr_route) then wr_desc  else "")                    sDelimiter
        (if available(wr_route) then wr_wkctr else "")                    sDelimiter
        t3_employee                                                       sDelimiter
        (if available(emp_mstr) then emp_lname + emp_fname else "")       sDelimiter
        t3_qty_wip                                                        sDelimiter
        t3_qty_xc                                                         sDelimiter
        t3_qty_zz                                                         sDelimiter
        (t3_qty_wip
            + t3_qty_xc
            + t3_qty_zz
        )
        .
end.




