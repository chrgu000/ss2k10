/* GUI CONVERTED from worcat01.p (converter v1.71) Tue May 25 23:03:36 1999 */
/* worcat01.p - CHANGE ATTRIBUTES TEST ERROR CONDITIONS                     */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.     */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                       */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                     */
/* REVISION: 7.5      LAST MODIFIED: 01/05/95   BY: pma *J040*              */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan       */
/* REVISION: 8.6      LAST MODIFIED: 03/25/99   BY: *J39K* Sanjeev Assudani */

     {mfdeclre.i}

         define input parameter wo_recid as recid.
         define input parameter site like sr_site no-undo.
         define input parameter location like sr_loc no-undo.
         define input parameter lotref like sr_ref no-undo.
         define input parameter lotserial like sr_lotser no-undo.
/*J39K*/ define input parameter effect_date like glt_effdate no-undo.
         define input-output parameter chg_assay  like tr_assay no-undo.
         define input-output parameter chg_grade  like tr_grade no-undo.
         define input-output parameter chg_expire like tr_expire no-undo.
         define input-output parameter chg_status like tr_status no-undo.
         define input-output parameter assay_actv like pt_rctwo_active no-undo.
         define input-output parameter grade_actv like pt_rctwo_active no-undo.
         define input-output parameter expire_actv like pt_rctwo_active no-undo.
         define input-output parameter status_actv like pt_rctwo_active no-undo.
         define output parameter trans-ok as logical no-undo.

     trans-ok = no.
     find wo_mstr no-lock where recid(wo_mstr) = wo_recid.
     find pt_mstr no-lock where pt_part = wo_part no-error.

     /*TEST & RETURN ON ERROR CONDITIONS*/
     find ld_det where ld_part = wo_part
               and ld_lot = lotserial
               and ld_ref = lotref
               and ld_site = site
               and ld_loc = location
               and ld_qty_oh <> 0
     no-lock no-error.

     if available ld_det then do:
        if assay_actv and chg_assay <> ld_assay then return.
        if grade_actv and chg_grade <> ld_grade then return.
        if expire_actv and
           ((chg_expire <> ? and chg_expire <> ld_expire)
        or (chg_expire = ?
            and available pt_mstr
            and  pt_shelflife <> 0
/*J39K**    and today + pt_shelflife <> ld_expire) */
/*J39K*/    and effect_date + pt_shelflife <> ld_expire)
        or (chg_expire = ?
            and available pt_mstr
            and  pt_shelflife = 0
            and ld_expire <> ?))
        then return.
        if status_actv and
           (chg_status <> ? and chg_status <> ld_status) then return.
     end.

     trans-ok = yes.
