/* xxusrwkey.i - sh1202 common variable                                      */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120713.1 LAST MODIFIED: 07/13/12 BY: zy                         */
/* REVISION END                                                              */

define variable vlgvdkey like usrw_key1 no-undo
						    initial "SH1202_LOGISTICS_VENDOR".
define variable vsptokey like usrw_key1 no-undo
                initial "SH1202_SHIP_TO_ADDRESS".
define variable vdefcstkey like usrw_key1 no-undo
                initial "SH1202_DEFAULT_COST".
define variable vdefSite like si_site no-undo.

PROCEDURE getDefSite:
	  assign vdefSite = "1000".
		find first icc_ctrl no-lock where icc_domain = global_domain no-error.
		if available icc_ctrl then do:
	  	 assign vdefSite = icc_site no-error.
	  end.
END PROCEDURE. /* PROCEDURE getDefSite*/
