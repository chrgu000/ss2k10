/* By: Neil Gao Date: 08/03/04 ECO: * ss 20080304 * */

define {1} shared var leave_rmks as logical no-undo.
define {1} shared temp-table tt-rqm-mstr no-undo
    field tt-dwn    as integer format ">>>" label "��"
    field tt-nbr    like sod_nbr label "����" column-label "����"
    field tt-line   like sod_line label "��"
    field tt-part   like sod_part column-label "�Ϻ�" label "�Ϻ�"
    field tt-status    like pt_part
    field tt-yn     like mfc_logical
    field tt-expert    as char format "x(16)" label "ר��"
    field tt-cffw-nbr as character
    field tt-rt       as character
    field tt-desc     as character format "x(24)" label "Ʒ��"
    field tt-vend     as char label "��Ӧ��"
    field tt-venddesc as char label "���"
    index tt-dwn is primary
       tt-dwn.

