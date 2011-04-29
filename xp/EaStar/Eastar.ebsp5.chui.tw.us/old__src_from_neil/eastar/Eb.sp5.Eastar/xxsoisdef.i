/* REVISION: eb sp5 us  LAST MODIFIED: 05/10/04 BY: *EAS043* Leemy Lee  */

	DEFINE {1} SHARED WORK-TABLE xcim_sod_det
		FIELD xcim_sod_nbr		LIKE sod_nbr
		FIELD xcim_sod_inv_date	LIKE ih_inv_date
		FIELD xcim_sod_line		LIKE sod_line
		FIELD xcim_sod_qty_ship	LIKE sod_qty_ship
		FIELD xcim_sod_site		LIKE ld_site		
		FIELD xcim_sod_loc		LIKE ld_loc
		FIELD xcim_sod_lot		LIKE ld_lot
		FIELD xcim_sod_ref		LIKE ld_ref
		FIELD xcim_sod_rmks		LIKE so_rmks
		FIELD xcim_sod_inv_nbr	LIKE sod_inv_nbr
		FIELD xcim_sod_qty_ship_old LIKE sod_qty_ship
		FIELD xcim_sod_qty_inv_old LIKE sod_qty_inv
		FIELD xcim_ship_successful AS LOGICAL INIT FALSE
		FIELD xcim_post_successful AS LOGICAL INIT FALSE
		.
		