/* xxwold.i - wowomt.p cim load                                              */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

define {1} shared variable flhload as character format "x(70)".
define {1} shared variable cloadfile as logical initial "no".
define {1} shared temp-table xxwoload no-undo
       fields xxwo_lot like wo_lot
       fields xxwo_orel_date like wo_rel_date
       fields xxwo_rel_date like wo_rel_date
       fields xxwo_odue_date like wo_due_date
       fields xxwo_due_date like wo_due_date
       fields xxwo_ostat like wo_stat
       fields xxwo_stat like wo_stat
       fields xxwo_chk as character format "x(40)"
       index xxwo_lot xxwo_lot.
