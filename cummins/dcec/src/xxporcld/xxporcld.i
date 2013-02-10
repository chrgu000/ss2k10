/* xxpcld.p - xxppctmt.p cim load                                                */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

define {1} shared variable flhload as character format "x(70)".
define {1} shared variable errload as character format "x(70)".
define {1} shared variable cloadfile as logical initial "no".

define {1} shared temp-table xxtmp
       fields xx_nbr like po_nbr
       fields xx_part like pt_part
       fields xx_qty like pod_qty_ord
       fields xx_cost like pod_pur_cost
       fields xx_pkg as character
       fields xx_rc  as character
       fields xx_eff as date
       fields xx_site like si_site
       fields xx_loc  like loc_loc initial "TEMP"
       fields xx_line like pod_line
       fields xx_sn as integer
       fields xx_chk as character format "x(120)"
       fields xx_recid as integer
       .

define {1} shared temp-table xxpo
			 fields xxpo_nbr like pod_nbr
			 fields xxpo_line like pod_line
			 index xxpo1 xxpo_nbr xxpo_line.