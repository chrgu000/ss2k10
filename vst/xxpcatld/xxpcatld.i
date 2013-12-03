/* xxpcld.p - xxppctmt.p cim load                                            */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

define {1} shared variable sTxtDir as character format "x(58)".
define {1} shared variable cloadfile like mfc_logical initial no.

define {1} shared temp-table xxfl
       fields xf_file as character format "x(64)"
       fields xf_dname as character format "x(64)"
       fields xf_type as character.

define {1} shared temp-table xxtmppc0
       fields x0pc_list like pc_list
       fields x0pc_curr like pc_curr
       fields x0pc_part like pc_part
       fields x0pc_um like pt_um
       fields x0pc_start like pc_start
       fields x0pc_expir like pc_expir
       fields x0pc_user1 as character format "x(12)"
       fields x0pc_amt as decimal format "->>,>>>,>>>,>>>,>>9.<<<<<<<<<"
       fields x0pc_sn as integer
       fields x0pc_file as character
       fields x0pc_chk as character format "x(40)".

define {1} shared temp-table xxtmppc
       fields xxpc_list like pc_list
       fields xxpc_curr like pc_curr
       fields xxpc_part like pc_part
       fields xxpc_axum like pt_um
       fields xxpc_um like pt_um
       fields xxpc_start like pc_start
       fields xxpc_expir like pc_expir
       fields xxpc_user1 as character format "x(12)"
       fields xxpc_amt as decimal format "->>,>>>,>>>,>>>,>>9.<<<<<<<<<"
       fields xxpc_sn as integer
       fields xxpc_file as character
       fields xxpc_chk as character format "x(40)".
