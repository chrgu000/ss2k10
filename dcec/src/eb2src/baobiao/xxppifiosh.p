/* LOAD DATA FROM PPIF INTO MFG/PRO AND EXPORT SCHEDULE FROM MFG/PRO    */
/* xxppifiosh.p - Interface between PPIF & MFG/PRO.      SCHEDULE		  */
/* CREATE BY *lb01* LONG BO      ATOS ORIGIN CHINA                      */


/*************************************************************************                                                                     
	THIS PROGRAM:
	1.READ 2 FILES GENERATED FROM PPIF WHICH INCLUDE THE 
	  INFOMATION OF ITEM MASTER, SHOP ORDER ITEM, ITEM & SHOP ORDER BOM.
	2.CIM LOAD THESE INFOMATION INTO MFG/PRO.
	3.WRITE LOG TO XXPPIF_LOG FOR TRACKING EVERY TRANSACTION
	4.GENERATE A FILE WHICH INCLUDE REPETITIVE SCHEDULE INFOMATION.
	
	PPIF -> MFG/PRO TRANSATIONS:
		PDIA	ITEM ADD
		PDIC	ITEM CHANGE
		PDID	ITEM DELETE
		PDSA	ITEM STRUCTURE ADD
		PDSC	ITEM STRUCTURE CHANGE
		SOIA	SHOP ORDER ITEM ADD
		SOIC	SHOP ORDER ITEM CHANGE
		SOSA	SHOP ORDER STRUCTURE ADD
		SOSC	SHOP ORDER STRUCTURE CHANGE
		
	MFG/PRO -> PPIF TRANSATTION:
		XSCD	SCHEDULE OUTPUT
	

*************************************************************************/

/* LAST MODIFIED 02 APR. 04      *LB01*         LONG BO                 */
/* LAST MODIFIED 2004-08-25 21:04      LONG BO                          */

		{ xxppifdef.i }
	
		/*READING INFOMATION*/
		
		
		find first code_mstr no-lock where code_fldname = "PPIF-QAD-CTRL" and code_value = "SCHEDULE_DAY" no-error.
		if available code_mstr then do:
			SCD_DAY = integer(code_cmmt).
		end.
		
		
		{ xxppif00.i }

	

	/*PROCEDURE*/
	{xxppifpro.i}














