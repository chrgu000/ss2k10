/* bmcsrub2.i - PRODUCT STRUCTURE ROLLUP (INCLUDE FILE)                 */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.5.1.7 $                                                         */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 7.3      LAST MODIFIED: 03/04/93   BY: pma *G681*          */
/* REVISION: 7.2      LAST MODIFIED: 01/20/95   BY: ais *F0FN*          */
/* REVISION: 8.5      LAST MODIFIED: 09/20/94   BY: pma *J036*          */
/* REVISION: 8.5      LAST MODIFIED: 04/10/96   BY: tjs *J0H0*          */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 9.0      LAST MODIFIED: 06/06/00   BY: *L0YY* Rajesh Thomas*/
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn          */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.5.1.7 $    BY: Katie Hilbert         DATE: 02/25/02  ECO: *N194*  */
/* $Revision: 1.5.1.7 $    BY: Bill Jiang         DATE: 09/07/05  ECO: *SS - 20050907*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*******************************************************************/
/*         NORMAL:       JP_JOINT_TYPE = 0                                  */
/*         COPRODUCT:    JP_JOINT_TYPE = 1                                  */
/*         BYPRODUCT:    JP_JOINT_TYPE = 2                                  */
/*         BYPRODUCT COSTS ARE NOT ROLLED UP AS A PART A JOINT STRUCTURE    */
/*******************************************************************/

for first spt_det
   fields (spt_site spt_sim spt_part spt_element
           spt_cst_ll spt_cst_tl spt_pct_ll)
no-lock
   where spt_det.spt_site    = sct_site
     and spt_det.spt_sim     = sct_sim
     and spt_det.spt_part    = sct_part
     and spt_det.spt_element = element:
end.

if not available spt_det then do:
   create spt_det.
   assign
      spt_det.spt_site    = sct_site
      spt_det.spt_sim     = sct_sim
      spt_det.spt_part    = sct_part
      spt_det.spt_element = element
      spt_det.spt_pct_ll  = cat + .01.
   /* SS - 20050907 - B */
   assign
      t_spt_cst_ll = 0
      t_spt_cst_tl = 0.
   /* SS - 20050907 - E */
end.
else
   assign
      t_spt_cst_ll = spt_det.spt_cst_ll
      t_spt_cst_tl = spt_det.spt_cst_tl.

if jp_joint_type = "0" then
   t_spt_cst_ll = max(0, cst_ll [level]).

else
if jp_joint_type = "1" then
   assign
      t_spt_cst_ll = max(jp_cost_ll,0)
      t_spt_cst_tl = max(jp_cost_tl,0).

if available ptp_det then
   if ptp_pm_code = "P" or ptp_pm_code = "D"
   then
      t_spt_cst_ll = 0.
if not available ptp_det then
   if pt_pm_code = "P" or pt_pm_code = "D"
   then
      t_spt_cst_ll = 0.
if ps_ps_code <> "O" then
   cst_ll [level - 1] = cst_ll [level - 1]
                      + (t_spt_cst_ll
                      + (if (available ptp_det and not ptp_phantom)
                         or (not available ptp_det and not pt_phantom)
                         then
                            t_spt_cst_tl
                         else
                            0))

                      * (ps_qty_per / (item_yield * .01))
                      * (if ps_scrp_pct < 100
                         then (100 / (100 - ps_scrp_pct))
                         else 0).

cst_ll [level] = 0.

if t_spt_cst_ll <> spt_cst_ll or
   t_spt_cst_tl <> spt_cst_tl
then do:

   if not new spt_det then do:
      find spt_det-upd where recid(spt_det-upd) = recid(spt_det)
      exclusive-lock.

      assign
         spt_det-upd.spt_cst_ll = t_spt_cst_ll
         spt_det-upd.spt_cst_tl = t_spt_cst_tl.
   end.
   else
      assign
         spt_det.spt_cst_ll = t_spt_cst_ll
         spt_det.spt_cst_tl = t_spt_cst_tl.

end.
