/* xxpcld.p - xxppctmt.p cim load                                                */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

define {1} shared variable flhload as character format "x(70)".
define {1} shared variable cloadfile as logical initial "no".
define {1} shared temp-table xxtmppi
       fields xxpi_list like pi_list
       fields xxpi_cs   like pi_cs_code
       fields xxpi_part like pi_part_code
       fields xxpi_curr like pi_curr
       fields xxpi_um like pi_um
       fields xxpi_start like pi_start
       fields xxpi_expir like pi_expir
       fields xxpi_amt as decimal format "->>,>>>,>>>,>>>,>>9.<<<<<<<<<"
       fields xxpi_sn as integer
       fields xxpi_chk as character format "x(40)"
       .
