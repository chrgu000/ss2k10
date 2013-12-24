
define {1} shared temp-table xxtmppc
       fields xxpc_list like pc_list
       fields xxpc_part like pc_part
       fields xxpc_curr like pc_curr
       fields xxpc_um like pt_um
       fields xxpc_start like pc_start
       fields xxpc_expir like pc_expir
       fields xxpc_type like pc_amt_type
       fields xxpc_min_qty as decimal FORMAT ">>>>>>9"
       fields xxpc_amt as decimal format "->>,>>>,>>>,>>>,>>9.99<<<<<<<"
       fields xxpc_sn as integer
       fields xxpc_sn1 as integer
       fields xxpc_chk as character format "x(40)"
       .
