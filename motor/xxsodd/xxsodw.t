/* xxsodw.t SALES ORDER LINE WRITE TRIGGER                                      */
/*Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                         */
/*All rights reserved worldwide.  This is an unpublished work.                */
/* $Revision: 1.9 $                                                           */
/*V8:ConvertMode=NoConvert                                                    */
/******************************************************************************/
/*  !Description : sod_det WRITE trigger program                              */
/*          : In order to enhance this trigger to support additional          */
/*          : interfaces, add a DO-END block similar to the one               */
/*          : used for the Warehousing Interface to (1) check for the         */
/*          : need to continue processing; (2) move the relevant              */
/*          : fields to an appropriate work area; and (3) call                */
/*          : one or more subprograms to continue processing.                 */
/*          : This .t program should remain short, relying on                 */
/*          : subprograms to perform most of the work.                        */
/******************************************************************************/
/*                             MODIFY LOG                                     */
/******************************************************************************/
/*Revision 8.5          Last Modified:  03/14/96    BY: BHolmes *J0FY*        */
/*Revision 8.5          Last Modified:  06/25/96    BY: BHolmes *J0M9*        */
/*Revision 8.5          Last Modified:  07/19/96    BY: fwy     *J0MB*        */
/*Revision 8.5          Last Modified:  07/27/96    BY: fwy     *J12B*        */
/*Revision 8.5          Last Modified:  01/07/97    BY: jpm     *J1DM*        */
/*Revision 9.1          Last Modified:  08/12/00    BY: *N0KN* Mark Brown     */
/* Revision: 1.4        BY: Jean Miller          DATE: 06/13/02  ECO: *P082*  */
/* Revision: 1.5        BY: Jean Miller          DATE: 08/01/02  ECO: *P0CL*  */
/* Revision: 1.6       BY: Jean Miller           DATE: 08/17/02 ECO: *P0FN* */
/* Revision: 1.8       BY: Paul Donnelly (SB)    DATE: 06/28/03 ECO: *Q00L* */
/* $Revision: 1.9 $    BY: Jean Miller           DATE: 01/10/06  ECO: *Q0PD*  */

/*Copy From sodw.t  
  ModiFied by Hill Cheng
  ECHO: *SS - 090727.1*
*/

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

TRIGGER PROCEDURE FOR WRITE OF SOD_DET OLD BUFFER OLD_SOD_DET.

{mfdeclre.i }

define variable l-qualifier as character format "x(8)".


/*SS - 090727.1 - B*/

   def var proid like sod_qty_ord extent 5 .
   def var i as int .
   def var m as int .
   def var ele as int format "-9" .
   def var fcs_date like soh_fst_week .
   def var fcs_qty like soh_fst_qty .
   def var buff_qty like sod_qty_ord .
   def var min_i as int .
   def var max_i as int .
   def var week_i as int .
   def var curr_date like sod_due_date .
   def var buff_week as int .
   def var stan_date like sod_due_date .
   def var curr_i  as int .
   def var curr_year as int .
   def var next_year as int .
   def var pro_year as int .
   def var next_week as int .
   def var pro_week as int .
   def var curr_buff_qty like sod_qty_ord .
   def var curr_fst_date  as date .
   def var n as int .
   def var j as int .
   def var tot_qty like sod_qty_ord .
    
    DEFINE TEMP-TABLE ttsoh_hist
       FIELD  ttfcs_qty  like sod_qty_ord
       FIELD  ttfcs_date as date
       .


  assign buff_qty = 0  .
  

  	 FIND soc_ctrl WHERE soc_domain = global_domain NO-LOCK NO-ERROR .  
	          
 
  /*预测备料设置数据*/
   FIND a6frc_cot WHERE a6frc_domain = global_domain NO-LOCK NO-ERROR .
  
  if old_sod_det.sod_consume = no and sod_det.sod_consume = yes then buff_qty = sod_det.sod_qty_ord .
   else do :
        assign tot_qty = 0 .

	 for each xxsoh_hist where xxsoh_hist.soh_domain = global_domain
			  and xxsoh_hist.soh_site = sod_det.sod_site
			  and xxsoh_hist.soh_nbr = sod_det.sod_nbr
			  and xxsoh_hist.soh_line = sod_det.sod_line 
			  use-index soh_nbr :
			  assign tot_qty = tot_qty + soh_fst_qty [1] + soh_fst_qty [2] + soh_fst_qty [3] + soh_fst_qty [4] + soh_fst_qty [5] .
             
         end .

      	  if tot_qty > 0 then assign buff_qty = sod_det.sod_qty_ord - tot_qty .
	  else buff_qty = sod_det.sod_qty_ord - old_sod_det.sod_qty_ord .
    end .

  assign tot_qty = 0 .
 if  (old_sod_det.sod_consume <> sod_det.sod_consume ) or (old_sod_det.sod_qty_ord  <> sod_det.sod_qty_ord) or (old_sod_det.sod_due_date  <> sod_det.sod_due_date)  then do:
  if sod_det.sod_consume  then do :
      if  buff_qty <> 0  then  do:
	      if buff_qty > 0 then do:     
		  if can-find(xxsoh_hist where xxsoh_hist.soh_domain = global_domain
				  and xxsoh_hist.soh_site = sod_det.sod_site
				  and xxsoh_hist.soh_nbr = sod_det.sod_nbr
				  and xxsoh_hist.soh_line = sod_det.sod_line ) then do:
				  
		     {a6fc02.i}			     
		    
		     {a6fc03.i}
		     

		  end .
		  else do:
		     assign curr_date = sod_det.sod_due_date .
		     
		     {a6fc03.i}
		     
		  end .
	      end .  /* if buff_qty > 0 then do: */
	      else do:	    

		     {a6fc04.i}	     

	      end .

     end. /*if  buff_qty <> 0  then  do:*/
  end .
  else if old_sod_det.sod_consume then do :

	    {a6fc01.i}     
  end .
End. /*if  (old_sod_det.sod_consume <> sod_det.sod_consume ) or (old_sod_det.sod_qty_ord  <> sod_det.sod_qty_ord) or (old_sod_det.sod_due_date  <> sod_det.sod_due_date)  then do:*/
/*SS - 090727.1 - E*/

/* Track Capacity Units */

if new sod_det and
  (old_sod_det.sod_nbr  <> sod_det.sod_nbr  or
   old_sod_det.sod_line <> sod_det.sod_line)
then do:

   l-qualifier = "".

   /* See if this is from SSM/PRM */
   if sod_det.sod_fsm_type <> "" then
      l-qualifier = sod_det.sod_fsm_type.

   /* Check if Scheduled Order Line */
   else
   if sod_det.sod_sched then
      l-qualifier = "SCHED".

   {lvucap.i &TABLE="sod_det" &QUALIFIER="l-qualifier"}

end .
