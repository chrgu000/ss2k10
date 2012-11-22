/* GUI CONVERTED from socnrp4a.p (converter v1.78) Fri Oct 29 14:38:03 2004 */
/* socnrp4a.p - Consignment Material Usage Sub-pgm - Sort ShipFrom/Cust       */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.10 $                                                 */

/******************************************************************************/
/* Notes: This program reports the Customer consignment material usage by     */
/*        Ship-From, Customer, Ship-to, Order, Item, and PO.                  */
/*                                                                            */
/******************************************************************************/

/* Revision: 1.7      BY: Steve Nugent  DATE: 04/04/02 ECO: *P00F*  */
/* Revision: 1.8  BY: Dan Herman DATE: 06/19/02 ECO: *P091* */
/* $Revision: 1.10 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00L* */
/*-Revision end---------------------------------------------------------------*/


/*V8:ConvertMode=FullGUIReport                                                */

/*                                                                            */
/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----    */
/*                                                                            */
/*         THIS PROGRAM IS A BOLT-ON TO STANDARD PRODUCT MFG/PRO.             */
/* ANY CHANGES TO THIS PROGRAM MUST BE PLACED ON A SEPARATE ECO THAN          */
/* STANDARD PRODUCT CHANGES.  FAILURE TO DO THIS CAUSES THE BOLT-ON CODE TO   */
/* BE COMBINED WITH STANDARD PRODUCT AND RESULTS IN PATCH DELIVERY FAILURES.  */
/*                                                                            */
/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----    */
/*                                                                            */


/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdeclre.i}
{gplabel.i}
{wbrp02.i}


/* INPUT PARAMETERS */
define input parameter shipfrom_from like cncu_site no-undo.
define input parameter shipfrom_to   like cncu_site no-undo.
define input parameter cust_from     like cncu_cust no-undo.
define input parameter cust_to       like cncu_cust no-undo.
define input parameter shipto_from   like cncu_shipto no-undo.
define input parameter shipto_to     like cncu_shipto no-undo.
define input parameter part_from     like cncu_part no-undo.
define input parameter part_to       like cncu_part no-undo.
define input parameter po_from       like cncu_po no-undo.
define input parameter po_to         like cncu_po no-undo.
define input parameter order_from    like cncu_so_nbr no-undo.
define input parameter order_to      like cncu_so_nbr no-undo.
define input parameter date_from     like cncu_eff_date no-undo.
define input parameter date_to       like cncu_eff_date no-undo.
define input parameter usage_id_from like cncu_batch no-undo.
define input parameter usage_id_to   like cncu_batch no-undo.
define input parameter cust_usage_ref_from like cncu_cust_usage_ref no-undo.
define input parameter cust_usage_ref_to like cncu_cust_usage_ref no-undo.

{yysocnrp4b.i}
/* LOCAL VARIABLES */
define variable shipto_name like ad_name no-undo.
define variable cust_name  like ad_name no-undo.

/* ========================================================================= */
PROCEDURE getShipToName:
/* -------------------------------------------------------------------------
Purpose:      This procedure gets the ship-to name.
Exceptions:   None
Conditions:
Pre:
Post:
Notes:
History:
 --------------------------------------------------------------------------- */

   define input  parameter p_shipto           as character no-undo.
   define output parameter p_shipto_name      as character no-undo.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:
      for first ad_mstr
         fields( ad_domain ad_sort)
          where ad_mstr.ad_domain = global_domain and (  ad_addr = p_shipto and
         (ad_type = "ship-to" or ad_type = "customer")
         ) no-lock:
      end.

      if available ad_mstr then
         assign p_shipto_name = ad_sort.
      else
         assign p_shipto_name = "".

   end. /*Do on error undo..*/

   return {&SUCCESS-RESULT}.

END PROCEDURE. /*getShipToName*/


/*   /* FRAMES */                                                           */
/*   FORM /*GUI*/                                                           */
/*      cncu_batch label "Batch ID"                                         */
/*      space(2)                                                            */
/*      cncu_eff_date                                                       */
/*      space(2)                                                            */
/*      cncu_shipto                                                         */
/*      shipto_name no-label                                                */
/*      cncu_cust                                                           */
/*      cust_name no-label                                                  */
/*   with STREAM-IO /*GUI*/  frame xref_header width 152.                   */
/*                                                                          */
/*   /* SET EXTERNAL LABELS */                                              */
/*   setFrameLabels(frame xref_header:handle).                              */
/*                                                                          */
/*                                                                          */
/*   FORM /*GUI*/                                                           */
/*      space(3)                                                            */
/*      cncu_part                                                           */
/*      cncu_lotser           column-label "Lot/Serial!Ref"                 */
/*      cncu_so_nbr           column-label "Order!Line"                     */
/*      cncu_usage_qty                                                      */
/*      cncu_usage_um         column-label "UM"                             */
/*      cncu_cum_qty                                                        */
/*      sod_um                column-label "UM"                             */
/*      sod_list_pr           column-label "LIST_PRICE"                     */
/*      cncu_cust_usage_date  column-label "Cust Usage Date!Cust Usage Ref" */
/*      cncu_selfbill_auth    column-label "Self-Bill"                      */
/*   with STREAM-IO /*GUI*/  frame part_detail down width 152.              */
/*                                                                          */
/*   /* SET EXTERNAL LABELS */                                              */
/*   setFrameLabels(frame part_detail:handle).                              */
/*                                                                          */
/* REPORT PROCESSING */
for each cncu_mstr no-lock  where cncu_mstr.cncu_domain = global_domain and
   cncu_site      >= shipfrom_from      and
   cncu_site      <= shipfrom_to        and
   cncu_cust      >= cust_from          and
   cncu_cust      <= cust_to            and
   cncu_shipto    >= shipto_from        and
   cncu_shipto    <= shipto_to          and
   cncu_part      >= part_from          and
   cncu_part      <= part_to            and
   cncu_po        >= po_from            and
   cncu_po        <= po_to              and
   cncu_so_nbr    >= order_from         and
   cncu_so_nbr    <= order_to           and
   cncu_batch     >= usage_id_from      and
   cncu_batch     <= usage_id_to        and
   cncu_eff_date  >= date_from          and
   cncu_eff_date  <= date_to            and
   cncu_cust_usage_ref >= cust_usage_ref_from and
   cncu_cust_usage_ref <= cust_usage_ref_to
   break by cncu_cust_usage_date
         by cncu_batch
         by cncu_part
         by cncu_lotser:

   /* DETERMINE SHIP-TO NAME */
   run getShipToName
      (input cncu_shipto,
       output shipto_name).


   /* DETERMINE CUSTOMER NAME */
   run getShipToName
      (input cncu_cust,
       output cust_name).

   if first-of(cncu_batch) then do:
      /*   display                                            */
      /*      cncu_batch                                      */
      /*      cncu_eff_date                                   */
      /*      cncu_shipto                                     */
      /*      shipto_name                                     */
      /*      cncu_cust                                       */
      /*      cust_name                                       */
      /*   with frame xref_header STREAM-IO /*GUI*/ .         */
      assign  v_cncu_batch    =  cncu_batch   
              v_cncu_eff_date =  cncu_eff_date
              v_cncu_shipto   =  cncu_shipto  
              v_shipto_name   =  shipto_name  
              v_cncu_cust     =  cncu_cust    
              v_cust_name     =  cust_name.
 
   end.

   for first sod_det
        where sod_det.sod_domain = global_domain and  sod_nbr = cncu_so_nbr
         and sod_line = cncu_sod_line
       no-lock: end.

/*   display                                                  */
/*      cncu_part                                             */
/*      cncu_lotser                                           */
/*      cncu_so_nbr                                           */
/*      cncu_usage_qty                                        */
/*      cncu_usage_um                                         */
/*      cncu_cum_qty                                          */
/*      sod_um      when (available sod_det)                  */
/*      sod_list_pr when (available sod_det)                  */
/*      cncu_cust_usage_date                                  */
/*      cncu_selfbill_auth                                    */
/*   with frame part_detail STREAM-IO /*GUI*/ .               */
/*   down with frame part_detail.                             */
/*                                                            */
/*   display                                                  */
/*      cncu_ref @ cncu_lotser                                */
/*      cncu_sod_line @ cncu_so_nbr                           */
/*      cncu_cust_usage_ref @ cncu_cust_usage_date            */
/*   with frame part_detail STREAM-IO /*GUI*/ .               */
/*   down with frame part_detail.                             */
		create tmp_t.
	  assign t_cncu_batch              = v_cncu_batch    
					 t_cncu_eff_date           = v_cncu_eff_date 
					 t_cncu_shipto             = v_cncu_shipto   
					 t_shipto_name             = v_shipto_name   
					 t_cncu_cust               = v_cncu_cust     
					 t_cust_name               = v_cust_name     
					 t_cncu_part               = cncu_part                
					 t_cncu_lotser             = cncu_lotser             
					 t_cncu_so_nbr             = cncu_so_nbr             
					 t_cncu_usage_qty          = cncu_usage_qty          
					 t_cncu_usage_um           = cncu_usage_um           
					 t_cncu_cum_qty            = cncu_cum_qty            
					 t_sod_um                  = sod_um      when (available sod_det)          
					 t_sod_list_pr             = sod_list_pr when (available sod_det)          
					 t_cncu_cust_usage_date    = cncu_cust_usage_date    
					 t_cncu_selfbill_auth      = cncu_selfbill_auth      
					 t_cncu_ref                = cncu_ref
					 t_cncu_sod_line           = cncu_sod_line
					 t_cncu_cust_usage_ref     = cncu_cust_usage_ref.


   
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

end. /*FOR EACH CNCU_MSTR*/

for each tmp_t  with frame t_tmpdet width 432:
 /* SET EXTERNAL LABELS */
      setFrameLabels(frame t_tmpdet:handle).
      display  tmp_t with stream-io.
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
end.