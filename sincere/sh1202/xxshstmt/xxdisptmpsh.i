/* xxdisptmpsh.i - xxdisptmpsh.i                                             */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120713.1 LAST MODIFIED: 07/13/12 BY: zy                         */
/* REVISION END                                                              */

display tsh_site
		    tsh_abs_id format "x(10)"
        tsh_nbr
        tsh_lgvd
        tsh_shipto
        tsh_price format "->>,>>9.9"
        tsh_stat
        tsh_ostat
with frame b.
