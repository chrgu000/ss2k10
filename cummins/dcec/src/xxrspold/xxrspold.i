/* xxrspold.p - rspoamt.p 2+  cim_load                                       */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

define {1} shared variable flhload as character format "x(70)".
define {1} shared variable errload as character format "x(70)".
define {1} shared variable cloadfile as logical initial "no".
define {1} shared variable maxsn as integer.

define {1} shared temp-table xxtmp
       fields xx_site like si_site
       fields xx_part like pt_part
       fields xx_eff as date
       fields xx_po like po_nbr
       fields xx_pct as decimal
       fields xx_sn as integer
       fields xx_chk as character format "x(120)"
       index xx_spe is primary xx_site xx_part xx_eff
       .
