/*By: Neil Gao 08/12/29 ECO: *SS 20081229* */

define {1} shared temp-table tt2 no-undo
    field tt2_f1  as integer label "��" format ">>>"
    field tt2_f2  like sod_nbr label "����" column-label "����"
    field tt2_f3  like sod_line label "��"  column-label "��"
    field tt2_f4  like sod_part label "���Ϻ�"
    field tt2_f5  like pt_desc1 label "˵��"
    field tt2_f6 	like sod_req_date column-label "��������"
    field tt2_f7  like sod_qty_ord column-label "����" format ">>>>>>"
    field tt2_f8  as int label "�ɹ���" column-label "�ɹ���" format ">>>"
    field tt2_f9  as logic label "ȷ��" column-label "ȷ��"
    index tt2_f1
    tt2_f1.
