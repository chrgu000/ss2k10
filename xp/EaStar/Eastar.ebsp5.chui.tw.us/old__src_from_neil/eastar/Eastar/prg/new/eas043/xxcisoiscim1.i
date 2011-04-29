/* REVISION: eb sp5 us  LAST MODIFIED: 05/10/04 BY: *EAS043* Leemy Lee  */


/*@@@@@@@@ 		IF FIRST-OF(xcim_sod_nbr) THEN DO:	*@@@@@@@@*/
			PUT '~"' xcim_sod_nbr '~" ' xcim_sod_inv_date " -" SKIP.
/*@@@@@@@@ 		END.*@@@@@@@@*/
		
		PUT xcim_sod_line " -" SKIP.
		PUT xcim_sod_qty_ship " " ' ~"' trim(xcim_sod_site) '~" ~"' trim(xcim_sod_loc) '~" ~"' trim(xcim_sod_lot) '~" ~"'
			trim(xcim_sod_ref) '~" ' NO SKIP.
		
/*@@@@@@@@ 		IF LAST-OF(xcim_sod_nbr) THEN DO:*@@@@@@@@*/
			PUT "." SKIP.
			PUT "no" SKIP.
			PUT "yes" SKIP.
			PUT "-" SKIP.
			PUT "- - - " '~"' trim(xcim_sod_rmks) '~" ~"' xcim_sod_inv_nbr '~" yes no' SKIP.
/*@@@@@@@@*/            put "." skip.
/*@@@@@@@@ 		END.  		*@@@@@@@@*/

	