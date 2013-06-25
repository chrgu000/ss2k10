/* podw.t PURCHASE ORDER LINE WRITE TRIGGER                                   */
/*Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                         */
/*All  rights reserved worldwide.  This is an unpublished work.                */
/* $Revision: 1.12 $                                                           */
/*V8:ConvertMode=NoConvert                                                    */
/******************************************************************************/
/*  !Description : This program is a database trigger running                 */
/*          : everytime a record is changed.  It will create a                */
/*          : worktable and then call another program                         */
/*          :                                                                 */
/******************************************************************************/
/*                             MODIFY LOG                                     */
/******************************************************************************/
/* REVISION 8.5      LAST MODIFIED: 01/19/96   BY: *J0FY* BHolmes             */
/* REVISION 8.5      LAST MODIFIED: 06/25/96   BY: *J0M9* BHolmes             */
/* REVISION 8.5      LAST MODIFIED: 01/07/97   BY: *J1DM* jpm                 */
/* REVISION 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb                 */
/* Old ECO marker removed, but no ECO header exists *J12B*                    */
/* Revision: 1.4       BY: Mark Christian        DATE: 09/09/01  ECO: *M1KG*  */
/* Revision: 1.5       BY: Jean Miller           DATE: 06/13/02  ECO: *P082*  */
/* Revision: 1.8       BY: Jean Miller           DATE: 08/01/02  ECO: *P0CL*  */
/* Revision: 1.9       BY: Jean Miller           DATE: 08/17/02  ECO: *P0FN* */
/* Revision: 1.11      BY: Paul Donnelly (SB)    DATE: 06/28/03  ECO: *Q00J* */
/* $Revision: 1.12 $    BY: Jean Miller           DATE: 01/10/06  ECO: *Q0PD*  */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

TRIGGER PROCEDURE FOR WRITE OF POD_DET OLD BUFFER OLD_POD_DET.

{mfdeclre.i }

define variable l-qualifier as character format "x(8)".

/* Track Capacity Units */
if new pod_det and
  (old_pod_det.pod_nbr  <> pod_det.pod_nbr  or
   old_pod_det.pod_line <> pod_det.pod_line)
then do:

   l-qualifier = "".

   /* See if this is a Blanket PO */
   if can-find(first po_mstr  where po_mstr.po_domain = global_domain
                               and po_mstr.po_nbr = pod_det.pod_nbr
                               and po_mstr.po_blanket <> "")
   then
      l-qualifier = "BLANKET".
   else
      l-qualifier = "".

   /* If not a Blanket PO, is this a scheduled Line */
   if l-qualifier = "" and pod_det.pod_sched then
      l-qualifier = "SCHED".

   {lvucap.i &TABLE="pod_det" &QUALIFIER="l-qualifier"}

end.
/*  ADD By SamSong For EDI Proposal START 20110623 */
if NOT ( old_pod_det.pod_part = "" and pod_det.pod_part = "" ) then do:   /*SKIP SITE CHECK*/

   if   (old_pod_det.pod_part = "" and old_pod_det.pod_line = 0 )   /* NEW Record */
     OR (old_pod_det.pod_qty_ord  <> pod_det.pod_qty_ord  OR        /* MOD Record */
         old_pod_det.pod_pur_cost <> pod_det.pod_pur_cost OR  
         old_pod_det.pod_due_date <> pod_det.pod_due_date )    then do:
        
	 find first po_mstr where po_mstr.po_domain = global_domain and pod_det.pod_nbr = po_mstr.po_nbr no-lock no-error. 
         if AVAILABLE(po_mstr) Then do:
            find first vd_mstr where vd_domain = global_domain and vd_addr = po_mstr.po_vend and vd_promo <>"" no-lock no-error. 
            if AVAILABLE(vd_mstr) Then do:
               define variable wgroup as char .
               create edi_hist.
                      if old_pod_det.pod_part = ""  then edi_action = "NEW" . else edi_action = "MOD".
		      edi_nbr	      = pod_det.pod_nbr  .               
     		      edi_line             = pod_det.pod_line .    
 		      edi_sourcedomain  = global_domain    .      
		      
		      if length(global_userid) <> 20 then do:   /* FIRST EMT*/
		         edi_group =                       		      	      
		         string ( decimal(substring( TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) + fill("0",20) ,1,20) ) + 10 ).
                      end.
 		      else do:
		         edi_group = string ( decimal(global_userid) + 10 ).
		      end.


		      find first si_mstr where si_domain = global_domain and si_site = pod_det.pod_site no-lock no-error.
		      if AVAILABLE(si_mstr) then  edi_entity        = si_entity.
		      edi_site          = pod_det.pod_site .
        	      edi_targetdomain  = vd_promo         .
                      edi_userid        = global_userid    .    
      		      edi_addr          = po_mstr.po_vend  .              
		      edi_part          = pod_det.pod_part .
 		      edi_curr          = po_mstr.po_curr  .    
      		      edi_qty_ord       = pod_det.pod_qty_ord .
     		      edi_due_date      = pod_det.pod_due_date.          
		      edi_price         = pod_det.pod_pur_cost.             
		      edi_type          = "ORD-PO" .            
          	      edi_time          = time.
		      edi_errormsg      = "".
    		      edi_old_due_date  = old_pod_det.pod_due_date.         
		      edi_old_price     = old_pod_det.pod_pur_cost.         
		      edi_old_qty_ord   = old_pod_det.pod_qty_ord .      
		
            end.    /* if AVAILABLE(vd_mstr) Then do */
	 end. /*if AVAILABLE(po_mstr) Then do:*/
   end. /* (old_pod_det.pod_part = "" and old_pod_det.pod_line = 0 ) */

end. /* if NOT ( old_pod_det.pod_part = "" and pod_det.pod_part = "" ) */

/*  ADD By SamSong For EDI Proposal END   20110623 */
