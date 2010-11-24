/* By: Neil Gao Date: 08/03/04 ECO: * ss 20080304 * */

define {1} shared var leave_rmks as logical no-undo.
define {1} shared temp-table tt-rqm-mstr no-undo
    field tt-dwn    as integer format ">>>" label "行"
    field tt-nbr    like sod_nbr label "订单" column-label "订单"
    field tt-line   like sod_line label "项"
    field tt-part   like sod_part column-label "料号" label "料号"
    field tt-status    like pt_part
    field tt-yn     like mfc_logical
    field tt-expert    as char format "x(16)" label "专批"
    field tt-cffw-nbr as character
    field tt-rt       as character
    field tt-desc     as character format "x(24)" label "品名"
    field tt-vend     as char label "供应商"
    field tt-venddesc as char label "简称"
    index tt-dwn is primary
       tt-dwn.

