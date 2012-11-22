 /* GUI CONVERTED from chcfamt.p (converter v1.71) Sun Oct 21 21:39:25 2007 */
/* chcftrma.p -- GENERAL LEDGER CASH FLOW ENTRY TRANSACTION MAINT - CAS    */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.	                   */
/* All rights reserved worldwide.  This is an unpublished work.	           */
/*F0PN*/ /*V8:ConvertMode=Maintenance	                                   */
/*V8:RunMode=Character,Windows */
/* REVISION: 9.1     LAST MODIFIED:  07/15/02  by: XinChao Ma              */
/* REVISION: 9.3      LAST MODIFIED: 10/11/07   BY: LinYun   ECO: *XXLY*  */
/***************************************************************************/
    {mfdeclre.i}    
    {gplabel.i} /* EXTERNAL LABEL INCLUDE */
/*XXLY*/ define        variable ref like glt_ref no-undo.   
define shared variable w-recid as recid.
  find glt_det where recid(glt_det) = w-recid and glt_det.glt_domain = global_domain no-lock no-error.
         find first gl_ctrl no-lock no-error.
  if available glt_det then do:
    assign ref = glt_det.glt_ref. 

end. 
/*TEST*/  for each glt_det where glt_det.glt_ref = ref and glt_det.glt_domain = global_domain no-lock:             	 
             	 find first xcft_det where xcft_ref = glt_det.glt_ref and xcft_glt_line = glt_det.glt_line 
             	 and xcft_line = 1 exclusive-lock no-error.
             	 if available xcft_det then do:
       	    assign    xcft_amt      = glt_det.glt_amt
                      xcft_curr_amt = glt_det.glt_curr_amt.
                   
                 end.                  
             	end.   /*check amt total*/                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            