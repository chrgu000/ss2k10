/* By: Neil Gao Date: 08/03/03 ECO: * ss 20080303 * */

define {1} shared var leave_rmks as logical no-undo.

define {1} shared temp-table tt-rqm-mstr no-undo
    field tt-dwn    as integer label "��" format ">>>"
    field tt-nbr    like sod_nbr label "����" column-label "����"
    field tt-line   like sod_line label "��"  column-label "��"
    field tt-cffw-nbr as character 
    field tt-part   like sod_part label "���Ϻ�"
    field tt-price  like sod_price label "�۸�" column-label "�۸�"
    field tt-status as character format "x(34)" label "�۸�" column-label "�۸�"
    field tt-yn1     as logic label "ȷ��" column-label "ȷ��"
    field tt-rt     as character  
    field tt-req-date like sod_req_date label "��������"
    field tt-desc   as character format "x(23)"  column-label "����"
    field tt-qty    as int format ">>>>>9" label "����"
    index tt-dwn is primary
       tt-dwn.
       