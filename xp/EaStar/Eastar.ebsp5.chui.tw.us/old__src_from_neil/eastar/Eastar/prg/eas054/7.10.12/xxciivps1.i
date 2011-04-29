/* REVISION: eb sp5 us  LAST MODIFIED: 05/10/04 BY: *EAS043* Leemy Lee  */


		IF FIRST-OF(xcim_sod_inv_nbr) THEN DO:
			PUT '~"' xcim_sod_inv_nbr '~" ~"' xcim_sod_inv_nbr '~" - - - - ~"' 
				xcim_sod_inv_date '~" -' SKIP.				
			PUT "CIM " "-" SKIP.
		END.  		
