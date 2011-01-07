/* SS - 110105.1 By: Kaine Zhang */

define {1} temp-table t_bomlist_tmp
    field t_bomlist_par as character
    field t_bomlist_comp as character
    index t_bomlist_par_comp
        is primary unique
        t_bomlist_par
        t_bomlist_comp
    .





