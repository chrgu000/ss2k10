/* bmcsruc.p - BOM ROLL-UP BUILD BY-PROD WKFL, CALL spt_det UPDATE      */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.11 $                                                     */
/*V8:ConvertMode=Maintenance                                            */
/*             from bmpsrub.p                                           */
/* REVISION: 8.5      LAST MODIFIED: 11/29/94   BY: pma *J036*          */
/* REVISION: 8.5      LAST MODIFIED: 02/15/95   BY: tjs *J036*          */
/* REVISION: 8.5      LAST MODIFIED: 04/11/96   BY: tjs *J0H0*          */
/* REVISION: 8.5      LAST MODIFIED: 11/21/97   BY: *J26H* evan bishop  */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6      LAST MODIFIED: 11/12/98   BY: *J34B* Abbas Hirkani*/
/* REVISION: 9.0      LAST MODIFIED: 06/06/00   BY: *L0YY* Rajesh Thomas*/
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn          */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.11 $    BY: Katie Hilbert         DATE: 02/25/02  ECO: *N194*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/************************************************************************/
/* NOTE:         pt_part = ps_par = PARENT = JOINT PRODUCT              */
/*               ps_comp = COMPONENT = BASE PROCESS                     */
/*                 level = Component level                              */
/*         cst_ll(level) = component's cost                             */
/*                       -> Parent's lower level cost                   */
/************************************************************************/

{mfdeclre.i}

define parameter buffer sct_det for sct_det.
define parameter buffer ps_mstr for ps_mstr.
define parameter buffer pt_mstr for pt_mstr.
define parameter buffer ptp_det for ptp_det.

define input parameter level like in_level no-undo.
define input parameter wkflflag as character no-undo.
define input parameter progflag as character no-undo.

define buffer ps_mstr1 for ps_mstr.
define buffer spt_det-upd for spt_det.

define shared variable eff_date as date initial today.
define shared variable item_yield as decimal no-undo.

define variable jp_joint_type like ps_joint_type no-undo.
define variable jp_cost_tl    like spt_cst_tl    no-undo.
define variable jp_cost_ll    like spt_cst_ll    no-undo.
define variable jp_cst_pct    like ps_cst_pct    no-undo.
define variable jp_batch      like bom_batch     no-undo.
define variable jp_qty_per_b  like ps_cop_qty    no-undo.
define variable bom_code      like pt_bom_code   no-undo.
define variable t_spt_cst_ll  like spt_cst_ll    no-undo.
define variable t_spt_cst_tl  like spt_cst_tl    no-undo.

/*WORKFILE TO PASS BY-PRODUCT DATA TO BMCSRUD.P*/
define new shared workfile by_wkfl no-undo
   field by_part like pt_part
   field by_qty_per_b like ps_cop_qty.

define shared workfile wkfl-13 no-undo
   field element like spt_element
   field cat     as integer
   field cst_ll  like spt_cst_ll extent 13.

define shared workfile wkfl-30 no-undo
   field element like spt_element
   field cat     as integer
   field cst_ll  like spt_cst_ll extent 30.

define shared workfile wkfl-45 no-undo
   field element like spt_element
   field cat     as integer
   field cst_ll  like spt_cst_ll extent 45.

define shared workfile wkfl-99 no-undo
   field element like spt_element
   field cat     as integer
   field cst_ll  like spt_cst_ll extent 99.

for each by_wkfl exclusive-lock:
   delete by_wkfl.
end.

/********************************************************************/
/* DETERMINE IF THIS ITEM IS A CO-PRODUCT                           */
/* NORMAL:        JP_JOINT_TYPE = 0                                 */
/* CO-PRODUCT:    JP_JOINT_TYPE = 1                                 */
/* BY-PRODUCT:    JP_JOINT_TYPE = 2                                 */
/* BY-PRODUCT COSTS ARE NOT ROLLED UP AS A PART A JOINT STRUCTURE   */
/********************************************************************/
jp_joint_type = "0".
bom_code = if available ptp_det then ptp_bom_code else pt_bom_code.

if bom_code <> "" then
do for ps_mstr1:

   for first ps_mstr1 where ps_par = pt_part
      and ps_comp = bom_code
      and ps_ps_code = "J"
      and ps_joint_type = "1"
      and (eff_date = ? or (eff_date <> ?
      and (ps_start = ? or ps_start <= eff_date)
      and (ps_end = ? or eff_date <= ps_end)))
   no-lock:
   end.

   /*SET CONSTANTS TO BE USED FOR EACH COST ELEMENT*/
   if available ps_mstr1 then do:
      assign
         jp_joint_type = ps_joint_type
         jp_cst_pct    = ps_cst_pct

         /*SET BATCH SIZE*/
         jp_batch = 1.

      for first bom_mstr fields (bom_batch bom_parent)
      no-lock where bom_parent = bom_code:
      end.
      if available bom_mstr and bom_batch <> 0 then jp_batch = bom_batch.

      /*SET QTY PER BATCH                                         */
      /*NOTE THAT THE PS_MSTR RECORD FOR THE ITEM WHOSE COST IS   */
      /*BEING CALCULATED IS FOUND AFTER THE BY-PRODUCT SECTION !!! */

      /* CREATE WF OF BY-PRODUCTS IN SET, ALSO SET CO-PROD'S Q PER BATCH*/
      for each ps_mstr1 where ps_comp = bom_code
            and ps_joint_type <> ""
            and (eff_date = ? or (eff_date <> ?
            and (ps_start = ? or ps_start <= eff_date)
            and (ps_end = ? or eff_date <= ps_end)))
      no-lock:

         /* BY-PRODUCT */
         if ps_joint_type = "2" then do:
            create by_wkfl.
            assign
               by_part = ps_par
               by_qty_per_b = ps_cop_qty
                            * (if ps_qty_type = ""
                               then jp_batch
                               else 1).
         end.

         /* CO-PRODUCT */
         else
         if  ps_par = pt_part
         and ps_joint_type = "1"
         then
            jp_qty_per_b = jp_qty_per_b + (ps_cop_qty
                         * (if ps_qty_type = ""
                            then jp_batch
                            else 1)).
      end.
   end.
end. /* do for ps_mstr1*/

/* NOTE THAT THE PS_MSTR RECORD FOR THE ITEM WHOSE COST IS   */
/* BEING CALCULATED IS FOUND AFTER THE BY-PRODUCT SECTION !!! */

if wkflflag = "13" then do:
   for each wkfl-13:

      /* ALL LOWER LEVEL COSTS SHOULD BE ROLLED UP USING */
      /* THE SAME YIELD.                                 */

      /* CALCULATE THE CO-PRODUCT COST FOR THIS COST ELEMENT */
      if jp_joint_type = "1" then do:

         assign
            jp_cost_tl = 0
            jp_cost_ll = 0
            jp_cost_ll = cst_ll [level].

         {gprun.i ""bmcsrud.p""
            "(input sct_site,
              input sct_sim,
              input element,
              input jp_cst_pct,
              input jp_batch,
              input jp_qty_per_b,
              input bom_code,
              input-output jp_cost_tl,
              input-output jp_cost_ll)"}
      end.

      if progflag = "2" then do:  /*COMPONENT LEVEL COST*/
         {bmcsrub2.i}
      end.
      else do:                    /*END ITEM LEVEL COST*/
         {bmcsrub3.i}
      end.
   end.
end.

if wkflflag = "30" then do:
   for each wkfl-30:

      /* CALCULATE THE CO-PRODUCT COST FOR THIS COST ELEMENT */
      if jp_joint_type = "1" then do:

         assign
            jp_cost_tl = 0
            jp_cost_ll = 0
            jp_cost_ll = cst_ll [level].

         {gprun.i ""bmcsrud.p""
            "(input sct_site,
              input sct_sim,
              input element,
              input jp_cst_pct,
              input jp_batch,
              input jp_qty_per_b,
              input bom_code,
              input-output jp_cost_tl,
              input-output jp_cost_ll)"}
      end.

      if progflag = "2" then do:  /*COMPONENT LEVEL COST*/
         {bmcsrub2.i}
      end.
      else do:                    /*END ITEM LEVEL COST*/
         {bmcsrub3.i}
      end.
   end.
end.

if wkflflag = "45" then do:
   for each wkfl-45:

      /* CALCULATE THE CO-PRODUCT COST FOR THIS COST ELEMENT */
      if jp_joint_type = "1" then do:

         assign
            jp_cost_tl = 0
            jp_cost_ll = 0
            jp_cost_ll = cst_ll [level].

         {gprun.i ""bmcsrud.p""
            "(input sct_site,
              input sct_sim,
              input element,
              input jp_cst_pct,
              input jp_batch,
              input jp_qty_per_b,
              input bom_code,
              input-output jp_cost_tl,
              input-output jp_cost_ll)"}
      end.

      if progflag = "2" then do:  /*COMPONENT LEVEL COST*/
         {bmcsrub2.i}
      end.
      else do:                    /*END ITEM LEVEL COST*/
         {bmcsrub3.i}
      end.
   end.
end.

if wkflflag = "99" then do:
   for each wkfl-99:

      /* CALCULATE THE CO-PRODUCT COST FOR THIS COST ELEMENT */
      if jp_joint_type = "1" then do:

         assign
            jp_cost_tl = 0
            jp_cost_ll = 0
            jp_cost_ll = cst_ll [level].

         {gprun.i ""bmcsrud.p""
            "(input sct_site,
              input sct_sim,
              input element,
              input jp_cst_pct,
              input jp_batch,
              input jp_qty_per_b,
              input bom_code,
              input-output jp_cost_tl,
              input-output jp_cost_ll)"}
      end.

      if progflag = "2" then do:  /*COMPONENT LEVEL COST*/
         {bmcsrub2.i}
      end.
      else do:                    /*END ITEM LEVEL COST*/
         {bmcsrub3.i}
      end.
   end.
end.
