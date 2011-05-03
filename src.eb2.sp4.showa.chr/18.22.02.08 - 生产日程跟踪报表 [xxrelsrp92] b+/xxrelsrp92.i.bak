/* relsrp.i - DISPLAY LOGIC FOR REPETITIVE SCHEDULE REPORT                    */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.7 $                                                           */
/*V8:ConvertMode=FullGUIReport                                                */
/* REVISION: 9.1         CREATED: 06/07/99   BY: *N005* Luke Pokic            */
/* REVISION: 9.1   LAST MODIFIED: 08/12/00   BY: *N0KP* myb                   */
/* Revision: 1.5  BY: Saurabh C. DATE: 02/07/02 ECO: *N18M* */
/* $Revision: 1.7 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/******************************************************************************/
/*!
SEARCH THROUGH FILE rps_mstr AND lnd_det FOR GIVEN SELECTION CRITERION AND
SORTING ORDER {1} FOR FIELD lnd_run_seq1, AND {2} FOR FIELD lnd_run_seq2.
*/

/*!
INPUT PARAMETERS:
{1} " " or descending (WHICHEVER ENTERED FOR PRIMARY RUN SEQUENCE SORTING ORDER)
{2} " " or descending (WHICHEVER ENTERED FOR SECONDARY RUN SEQUENCE SORTING
                       ORDER)
*/
/******************************************************************************/

/* RECORD RETREIVING AND DISPLAY LOGIC  */

for each temp_det :
delete temp_det.
end.

for each rps_mstr
   fields( rps_due_date rps_line rps_part rps_qty_req
           rps_qty_comp rps_rel_date rps_site)
   use-index rps_site_line
    where  rps_site     >= site
     and rps_site     <= site1
     and rps_line     >= prline
     and rps_line     <= prline1
/*minth*/  and rps_part     >= part
/*minth*/  and rps_part     <= part1
     and rps_rel_date >= release_date
     and rps_rel_date <= release_date1
   no-lock,
     each ln_mstr
      fields( ln_site ln_line ln_desc) no-lock
       where ln_site = rps_site
        and ln_line = rps_line,
     each pt_mstr
      fields(pt_desc1 pt_desc2 pt_part)
       where   pt_part = rps_part
      no-lock:

   open_qty = rps_qty_req - rps_qty_comp.
find first temp_det where temp_site = rps_site and temp_line = rps_line and temp_part = rps_part
    and temp_rel_date = rps_rel_date no-error.
    if not available temp_det then do:
    create temp_det .

    assign  temp_site     = rps_site
            temp_line     = rps_line          
	    temp_linedesc = ln_desc           
	    temp_rel_date = rps_rel_date  
	    temp_part     = rps_part          
	    temp_desc1    = pt_desc1         
	    temp_desc2    = pt_desc2         
	    temp_due_date = rps_due_date      
	    temp_qty_req  = rps_qty_req       
	    temp_qty_comp = rps_qty_comp      
	    temp_qty      = rps_qty_req - rps_qty_comp.          
    end.
    else  assign temp_qty_req  = temp_qty_req  + rps_qty_req       
	    temp_qty_comp = temp_qty_comp + rps_qty_comp      
	    temp_qty      = temp_qty + rps_qty_req - rps_qty_comp.
 

   
end. /* FOR EACH rps_mstr ,LAST lnd-det */


/*mage add*****************************************/

     assign qty_adjust = 0
            qty_comp   = 0
	    qty_rjct   = 0
	    qty_rwrk   = 0
	    qty_wip    = 0
	    qty_scrap  = 0.

for  each op_hist no-lock where  op_site >= site 
     and  op_site <= site1 and  op_line >= prline and op_line <= prline1
     and  op_part >= part  and  op_part <= part1 and op_type = "BackFLSH" 
     and op_date >= release_date and op_date <= release_date1  
     use-index op_wkctr  break by op_site by op_line by op_date by op_part:
     if first-of(op_part) then  assign qty_adjust = 0
            qty_comp   = 0
	    qty_rjct   = 0
	    qty_rwrk   = 0
	    qty_wip    = 0
	    qty_scrap  = 0.

     assign qty_adjust = qty_adjust + op_qty_adjust
            qty_comp   = qty_comp +   op_qty_comp
	    qty_rjct   = qty_rjct +   op_qty_rjct
	    qty_rwrk   = qty_rwrk +   op_qty_rwrk
	    qty_scrap  = qty_scrap +  op_qty_scrap 
	    qty_wip    = qty_wip  +  op_qty_wip.
     if last-of(op_part) then do:
        find first temp_det where temp_site = op_site and temp_line = op_line and temp_part = op_part
             and temp_rel_date = op_date no-error.
             if not available temp_det then do:
	     find first ln_mstr no-lock where  ln_line = op_line no-error.
             find first pt_mstr no-lock where  pt_part = op_part no-error.
	     create temp_det .
             assign  temp_site     = op_site
            temp_line     = op_line          
	    temp_rel_date = op_date  
	    temp_part     = op_part          
	    temp_desc1    = pt_desc1         
	    temp_desc2    = pt_desc2         
	    temp_due_date = op_date .
	    if available ln_mstr then temp_linedesc = ln_desc.

	    if available pt_mstr then assign temp_desc1    = pt_desc1         
	                                     temp_desc2    = pt_desc2 . 
         end.
         assign temp_comp     = temp_comp   + qty_comp  
	     temp_wip      = temp_wip    + qty_wip   
	     temp_adjust   = temp_adjust + qty_adjust
	     temp_rjct     = temp_rjct   + qty_rjct  
	     temp_rwrk     = temp_rwrk   + qty_rwrk  
	     temp_scrap    = temp_scrap  + (qty_comp - qty_wip - qty_rjct).

     end. /*if last-of(op_date) */
  end.  /*for each op_hist ***/

  for each temp_det no-lock with frame bx1 width 320 down:

   /* if onlyopen and temp_qty > 0  and not onlyover or onlyover and overdate <= temp_rel_date
               and temp_qty_comp > 0 and not onlyopen  then */

  if onlyopen and temp_qty > 0   or  not onlyopen  then  

	       display temp_site      label "地点"              
	       temp_line      label "生产线"               
	       temp_linedesc  label "生产线说明"               
	       temp_rel_date  label "日期"               
	       temp_part      label "零件"               
	       temp_desc1     label "说明"           
	       temp_desc2     label "特性"               
	       temp_qty_req   label "排产数量"               
	       temp_qty_comp  label "完成数量"               
	       temp_qty       label "短缺量"                    
	       temp_comp     label "本日处理数量"
	       temp_wip      label "本日正品数量"    
	       temp_rjct     label "本日次品数量"    
	       temp_rwrk     label "本日返工数量"                    
	       temp_scrap    label "本日废品数量"       with frame bx1.

/* REPORT EXIT FOR PAGING INCLUDE FILE */


  end. /*for each temp_det */