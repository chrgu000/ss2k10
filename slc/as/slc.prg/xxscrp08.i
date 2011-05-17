/* By: Neil Gao Date: 08/03/03 ECO: * ss 20080303 * */

define {1} shared temp-table tt-rqm-mstr no-undo
    field tt-dwn    as integer  label "��" format ">>>"
    field tt-nbr    like sod_nbr label "����" column-label "����"
    field tt-line   like sod_line label "��"  column-label "��"
    field tt-cffw-nbr as character 
    field tt-part   like sod_part  label "���Ϻ�"
    field tt-status    like pt_status label "�ɻ���" column-label "�ɻ���" format "x(18)"
    field tt-pur-lt  as integer label "�ɹ���" format ">>>>>>"
    field tt-req-date as date   label "��������"
    field tt-yn     as integer label "������" column-label "������" format ">>>>>>"
    field tt-yn1     as logic label "ȷ��" column-label "ȷ��"
    field tt-rt     as character format "x(3)" label "����"
    field tt-qty    like sod_qty_ord label "����" format ">>>>>9"
    field tt-desc   as character  format "x(24)"
    field tt-vin    as char format "x(12)" label "VIN�����"
    index tt-dwn is primary
       tt-dwn.