/* xxpcld.p - xxppctmt.p cim load                                                */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

define {1} shared variable flhload as character format "x(70)".
define {1} shared variable cloadfile as logical initial "no".
define {1} shared temp-table xxtmppc
       fields xxpc_list like pc_list
       fields xxpc_curr like pc_curr
       fields xxpc_part like pc_part
       fields xxpc_um like pt_um
       fields xxpc_start like pc_start
       fields xxpc_expir like pc_expir
       fields xxpc_amt as decimal format "->>,>>>,>>>,>>>,>>9.<<<<<<<<<"
       fields xxpc_sn as integer
       fields xxpc_chk as character format "x(40)"
       .
