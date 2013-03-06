/* xxrold.i - rwromt.p cim load                                              */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

define {1} shared variable flhload as character format "x(70)".
define {1} shared variable cloadfile as logical initial "no" no-undo.
define {1} shared variable i as integer no-undo.
define {1} shared temp-table xxros
       fields xxros_part like pt_part
       fields xxros_sub_cost like ro_sub_cost
       fields xxros_start like ro_start.
define {1} shared temp-table xxro
       fields xxro_routing like ro_routing
       fields xxro_op like ro_op
       fields xxro_wkctr like ro_wkctr
       fields xxro_start like ro_start
       fields xxro_end like ro_end
       fields xxro_mch like ro_mch
       fields xxro_desc like ro_desc
       fields xxro_run like ro_run
       fields xxro_sub_cost like ro_sub_cost
       fields xxro_sn as integer
       fields xxro_tp as character
       fields xxro_chk as character format "x(60)"
       index xxro_def is primary xxro_routing xxro_op xxro_start.
