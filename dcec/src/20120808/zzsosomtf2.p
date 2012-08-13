/* GUI CONVERTED from sosomtf2.p (converter v1.69) Wed Sep 10 15:19:43 1997 */
/* sosomtf2.p - SALES ORDER MAINTENANCE CONFIGURED PRODUCTS             */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.3      LAST MODIFIED: 06/15/94   BY: WUG *GK60*          */
/* REVISION: 7.3      LAST MODIFIED: 07/21/94   BY: WUG *GK86*          */
/* REVISION: 7.2      LAST MODIFIED: 08/31/94   BY: WUG *FQ63*          */
/* REVISION: 7.2      LAST MODIFIED: 03/08/95   BY: KJM *F0LT*          */
/* REVISION: 7.2      LAST MODIFIED: 03/31/95   BY: AED *F0PX*          */
/* REVISION: 7.4      LAST MODIFIED: 03/25/96   BY: PCB *G1R1*          */
/* REVISION: 8.5      LAST MODIFIED: 05/28/97   BY: *J1RY* Tim Hinds    */
/* REVISION: 8.5      LAST MODIFIED: 11/14/03   BY: *LB01* Long Bo         */

/*GETS A FEATURE NAME FROM THE USER*/

/*F0PX*/ /*V8:EditableDownFrame=w */
/*G1R1 BEGIN: Fixed abbreviations in define statements which were
  causing standards violations. */

define input param parent_item as character.
define input param parent_id as character.
define input param parent_qty as decimal.
define input param parent_scrap_pct as decimal.

define shared variable cpex_prefix as character.
define shared variable cpex_ordernbr as character.
define shared variable cpex_orderline as integer.
define shared variable cpex_rev_date as date.
define shared variable cpex_order_due_date as date.
define shared variable cpex_site as character.
define shared variable cpex_ex_rate like so_ex_rate.
define shared variable cpex_mfg_lead like ptp_mfg_lead.
define shared variable cpex_last_id as integer.

define shared variable global_user_lang_dir as character.
define shared variable mfguser as character.
define shared variable config_changed like mfc_logical. /*F0LT*/

define new shared workfile wcomp_list
   field wcomp_comp like ps_comp
   field wcomp_component_req_qty as decimal
   field wcomp_component_sel_qty as decimal
   field wcomp_default like ps_default
   field wcomp_lt_off like ps_lt_off
   field wcomp_mandatory like ps_mandatory
   field wcomp_op like ps_op
   field wcomp_ps_code like ps_ps_code
   field wcomp_ref like ps_ref
   field wcomp_scrp_pct like ps_scrp_pct
/*J1RY*/ field wcomp_cf_lprice    like mfc_logical
/*J1RY*/ field wcomp_cf_lpricev like sod_list_pr
/*J1RY*/ field wcomp_cf_disc      like mfc_logical
/*J1RY*/ field wcomp_cf_discv   like sod_disc_pct
.

define  new shared variable use_lt_off like ps_lt_off.
define  new shared variable use_default like ps_default.
define  new shared variable use_mandatory like ps_mandatory.
define  new shared variable use_ref like ps_ref.

define  variable component_qty as decimal.
define  variable lines as integer.
define  variable  pm_code as character.
define  variable temp_id as integer.

define  workfile work_list
  field work_feature as character format "x(12)" column-label "特性"
  field work_mandatory like mfc_logical column-label "必备".

define  workfile work2_list
  field work2_feature as character format "x(12)" column-label "特性"
  field work2_mandatory like mfc_logical column-label "必备".

/*G1R1 END: Fixed abbreviations in define statements  which were
  causing standards violations. */

/*PICK UP INFO ALREADY IN SOB_DET; ALSO REMEMBER LAST RECORD IDENTIFIER*/
/*FQ63 cpex_last_id = 0. */

for each sob_det no-lock
where sob_nbr = cpex_prefix + cpex_ordernbr
and sob_line = cpex_orderline
and sob_parent = parent_id
break by sob_feature:
   if first-of(sob_feature) then do:
      create work_list.

      assign
      work_feature = sob_feature
      work_mandatory = substr(sob_serial,35,1) = "y".
   end.

   /*FQ63***************************************
   temp_id = int(substr(sob_serial,11,4)).

   if temp_id > cpex_last_id then do:
      cpex_last_id = temp_id.
   end.
   **FQ63**************************************/
end.



/*PICK UP ANY OTHER INFO IN PRODUCT STRUCTURE SO WE  CAN  DISPLAY
ALL POSSIBLE FEATURES.  THIS IS FOR CONFIGURED STRUCTURES ONLY. */

pm_code = "".
find pt_mstr where pt_part = parent_item no-lock no-error.

if available pt_mstr then do:
   pm_code = pt_pm_code.
end.

find ptp_det where ptp_part = parent_item and ptp_site = cpex_site
no-lock no-error.

if available ptp_det then do:
   pm_code = ptp_pm_code.
end.

if pm_code <> "c" then leave.


{gprun.i ""zzsosomtf5.p"" "(input parent_item, input 1,
input parent_scrap_pct, input 0)"}

for each wcomp_list no-lock
break by wcomp_ref:
   if last-of(wcomp_ref) then do:
      create work_list.

      assign
      work_feature = wcomp_ref
      work_mandatory = wcomp_mandatory.
   end.
end.


/*SORT IT FOR THE SELECT LIST*/

for each work_list no-lock
break by work_feature:
   if last-of(work_feature) then do:
      create work2_list.

      assign
      work2_feature = work_feature
      work2_mandatory = work_mandatory.

      lines = lines + 1.
   end.
end.


if lines = 0 then return.
lines = min(9,lines).


FORM /*GUI*/ 
   work2_feature
   work2_mandatory
with frame w
row 9
column 5
scroll 1
lines down
overlay
no-validate
attr-space
title color normal " " + parent_item + " 特性 " THREE-D /*GUI*/.


pause 0 . /*G1R1: Removed "before-hide" to corrects Stds. Violation*/.
view frame w.
pause before-hide.



mainloop:
do:
   {windo1u.i

   work2_list

   "
      work2_feature
      work2_mandatory
   "

   work2_feature

   " "

   yes
   }


   if keyfunction(lastkey) = "RETURN" then do:
      find work2_list
      where recid(work2_list) = recidarray[frame-line(w)].

      hide frame w no-pause.

/*LB01*/
      {gprun.i ""zzsosomtf3.p""
      "(input parent_id, input parent_qty, input parent_item,
      input work2_feature, input work2_mandatory)"}

      view frame w.
   end.
   else
   if keyfunction(lastkey) = "GO" then do:
      leave mainloop.
   end.



   {windo1u1.i work2_feature}

end.


hide frame w no-pause.
pause before-hide.

/*G1R1*/      
/*G1R1*/ ststatus = stline[1].
/*G1R1*/ status input ststatus.   
