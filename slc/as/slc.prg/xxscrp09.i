/* By: Neil Gao Date: 08/03/03 ECO: * ss 20080303 * */

define {1} shared var leave_rmks as logical no-undo.

define {1} shared temp-table tt-rqm-mstr no-undo
    field tt-dwn    as integer label "��" format ">>>"
    field tt-nbr    like sod_nbr label "����" column-label "����"
    field tt-line   like sod_line label "��"  column-label "��"
    field tt-cffw-nbr as character 
    field tt-part   like sod_part label "���Ϻ�"
    field tt-status    like pt_status label "�ɻ���" column-label "�ɻ���" format "x(18)"
    field tt-yn      as int label "�ɹ���" column-label "�ɹ���" format ">>>>>>"
    field tt-yn1     as logic label "ȷ��" column-label "ȷ��"
    field tt-rt     as character  format "x(3)" label "����"
    field tt-req-date like sod_req_date label "��������"
    field tt-xc     as integer label "���" column-label "���" format "->>>>>"
    field tt-desc   as character format "x(24)"
    field tt-qty    as int format ">>>>>9" label "������"
    field tt-due-date like sod_due_date label "��ֹ����"
    field tt-pur-lt   as integer label "�ɹ�"
    field tt-wo-lt   as integer  label "����"
    field tt-cust   like so_cust
    index tt-dwn is primary
       tt-dwn.