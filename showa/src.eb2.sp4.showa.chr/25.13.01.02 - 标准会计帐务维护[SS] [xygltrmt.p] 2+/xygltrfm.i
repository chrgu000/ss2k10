/* gltrfm.i - GENERAL LEDGER FORM DEFINITIONS                                 */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.1 $                                                     */
/*V8:ConvertMode=Maintenance                                                  */
/* $Revision: 1.1 $    BY: Subramanian Iyer     DATE: 10/04/02 ECO: *N1TQ* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY FORM FOR STANDARD TRANSACTION */
form
   space(1)
   glt_ref
   /*V8! view-as fill-in size 14 by 1 */
   tr_type
   eff_dt  colon 50
   per_yr  colon 68
   skip
   space(1)
   ctrl_curr
   ctrl_amt  colon 23
   disp_curr no-label
   tot_amt   colon 55
   skip
   space(2)
   dft-daybook
   nrm-seq-num
   skip
   /****************************** Add by SS - Micho - 20060709 B ******************************/
    v_annex  COLON 34
   /****************************** Add by SS - Micho - 20060709 B ******************************/
   corr-flag colon 73
with side-labels frame a width 80 attr-space
   title color normal glname.

/* SET EXTERNAL LABELS  */
setFrameLabels(frame a:handle).

/* DISPLAY FORM FOR YEAR END ADJUSTMENT TRANSACTION */
form
   space(1)
   glt_ref
   /*V8! view-as fill-in size 14 by 1 */
   tr_type
   per_yr format "9999" colon 50
   eff_dt colon 67
   skip
   space(1)
   ctrl_curr
   ctrl_amt  colon 23
   disp_curr no-label
   tot_amt   colon 55
   skip
   space(2)
   dft-daybook
   nrm-seq-num
   skip
   corr-flag colon 73
with side-labels frame ya width 80 attr-space
   title color normal glname.

/* SET EXTERNAL LABELS  */
setFramelabels(frame ya:handle).
