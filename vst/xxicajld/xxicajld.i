/* xxicajld.i - xxicccaj.p cim load                                                */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

define {1} shared variable flhload as character format "x(70)".
define {1} shared variable cloadfile as logical initial "no".
define {1} shared variable i as integer no-undo.
define {1} shared variable dte as date initial today no-undo.

define {1} shared temp-table xxic
       fields xxic_part like pt_part
       fields xxic_site like pt_site
       fields xxic_loc like ld_loc
       fields xxic_lot like ld_lot
       fields xxic_ref like ld_ref
       fields xxic_qty_loc like ld_qty_oh
       fields xxic_qty_ld like ld_qty_oh
       fields xxic_qty_adj like ld_qty_oh
       fields xxic_um like um_um
       fields xxic_conv as decimal initial 1
       fields xxic_rmks as character
       fields xxic_acct like pl_inv_acct
       fields xxic_sub like pl_inv_sub
       fields xxic_cc like pl_inv_cc
       fields xxic_sn as integer
       fields xxic_chk as character format "x(40)"
       index xxic_def is primary xxic_part xxic_site xxic_loc xxic_lot xxic_ref.
