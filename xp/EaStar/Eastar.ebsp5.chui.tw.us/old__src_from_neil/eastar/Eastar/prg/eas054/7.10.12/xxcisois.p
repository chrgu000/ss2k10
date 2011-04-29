/* REVISION: eb sp5 us  LAST MODIFIED: 05/10/04 BY: *EAS043* Leemy Lee  */

	{mfdeclre.i}
	{xxsoisdef.i}
	
	DEFINE OUTPUT PARAMETER pchr_error AS INTEGER NO-UNDO.
	
	DEFINE VARIABLE vchr_filename_in AS CHARACTER.
	DEFINE VARIABLE vchr_filename_out AS CHARACTER.	
	DEFINE VARIABLE vlog_fail_flag AS LOGICAL.
	
	pchr_error = 0. /* Initial variable */
	/* To lock the so detail records and record the original quantity*/
	FOR EACH xcim_sod_det,EACH sod_det EXCLUSIVE-LOCK 
		WHERE sod_nbr = xcim_sod_nbr AND sod_line = xcim_sod_line:
		xcim_sod_qty_ship_old = sod_qty_ship.
	END.
 	vchr_filename_in = "./ssi" + mfguser.
	vchr_filename_out = "./sso" + mfguser.

	CIM:
	DO TRANSACTION:		
		FOR EACH xcim_sod_det GROUP BY xcim_sod_nbr DESCENDING:
		
/*@@@@@@@@ 			IF FIRST-OF(xcim_sod_nbr) THEN DO:				*@@@@@@@@*/
				OUTPUT TO value(vchr_filename_in).
/*@@@@@@@@ 			END.	*@@@@@@@@*/
			
			{xxcisoiscim1.i}
			
/*@@@@@@@@ 			IF LAST-OF(xcim_sod_nbr) THEN DO:*@@@@@@@@*/
				OUTPUT CLOSE.
/*@@@@@@@@ 			END.*@@@@@@@@*/

/*@@@@@@@@ 			IF LAST-OF(xcim_sod_nbr) THEN DO:					*@@@@@@@@*/
				INPUT FROM VALUE(vchr_filename_in).	
				OUTPUT TO VALUE(vchr_filename_out).		
	
				batchrun = YES.  /* In order to	disable the "Pause" message */ 
				{gprun.i ""sosois.p""} 
				batchrun = NO.
				INPUT CLOSE.
				OUTPUT CLOSE.
/*@@@@@@@@ 			END.		*@@@@@@@@*/
		END.	/*EAS043*  FOR EACH xcim_sod_det */	
		
        vlog_fail_flag = NO.
/*@@@@@@@@ 
        DEFINE VARIABLE vdec_ship_tot like sod_qty_ship.
        vdec_ship_tot = 0.
		FOR EACH xcim_sod_det,EACH sod_det NO-LOCK 
			WHERE sod_nbr = xcim_sod_nbr AND sod_line = xcim_sod_line 
            break by sod_nbr:
            vdec_ship_tot = vdec_ship_tot + xcim_sod_qty_ship .
            IF last-of(sod_nbr) THEN
            DO:
            	
			IF sod_qty_ship = xcim_sod_qty_ship_old + xcim_sod_qty_ship THEN DO:
				xcim_ship_successful = YES.
			END.
			ELSE DO:
				xcim_ship_successful = NO. 
				vlog_fail_flag = YES. /* It means at least 1 item failures*/
			END.
            end.
		END.	
		IF vlog_fail_flag = YES THEN DO:
			pchr_error = 1.
			UNDO CIM,LEAVE CIM. 
		END.
*@@@@@@@@*/        
	END.  /*CIM: DO TRANSACTION:*/

	OS-DELETE VALUE("./ssi" + mfguser). 
	OS-DELETE VALUE("./sso" + mfguser).   
	