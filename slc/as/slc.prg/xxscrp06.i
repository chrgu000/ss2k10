/* By: Neil Gao Date: 08/03/03 ECO: * ss 20080303 * */

define {1} shared var leave_rmks as logical no-undo.

define {1} shared temp-table tt-rqm-mstr no-undo
    field tt-dwn    as integer label "��" format ">>>"
    field tt-nbr    like sod_nbr label "����" column-label "����"
    field tt-line   like sod_line label "��"  column-label "��"
    field tt-cffw-nbr as character 
    field tt-part   like sod_part label "���Ϻ�"
    field tt-status as character format "x(39)" label "�۸�" column-label "�۸�"
    field tt-yn1     as logic label "ȷ��" column-label "ȷ��"
    field tt-rt     as character format "x(3)" label "����"
    field tt-req-date like sod_req_date label "��������"
    field tt-desc   as character format "x(24)"
    field tt-qty    as int format ">>>>>9" label "����"
    field tt-cust   like so_cust
    field tt-cost   like pt_price
    index tt-dwn is primary
       tt-dwn.
       