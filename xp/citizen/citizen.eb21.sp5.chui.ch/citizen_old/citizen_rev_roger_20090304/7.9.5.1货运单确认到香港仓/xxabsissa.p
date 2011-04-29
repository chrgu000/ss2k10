

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*****************************************************************************/

{mfdeclre.i}
{cxcustom.i "REPKISA.P"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE repkisa_p_1 "Use Workcenter Loc Status"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define     shared variable nbr like lad_nbr format "x(10)".

define     shared variable eff_date as date.
define     shared variable use-to-loc-status like mfc_logical
   label {&repkisa_p_1} no-undo.

define variable part like tr_part.
define variable ref like glt_ref.
define buffer trhist for tr_hist.
define variable lot like tr_lot.
define variable line as character.

define variable lotserial like sr_lotser no-undo.
define variable lotserial_qty like sr_qty no-undo.

define
   new shared
   variable transtype as character format "x(7)" initial "ISS-TR".
define variable from_nettable like mfc_logical.
define variable to_nettable like mfc_logical.
define variable null_ch as character initial "".
define variable intermediate_acct like trgl_dr_acct.
define variable intermediate_sub like trgl_dr_sub.
define variable intermediate_cc like trgl_dr_cc.
define variable from_expire like ld_expire.
define variable from_date like ld_date.
define variable from_status like ld_status no-undo.
define variable temp_qty like sr_qty.

define variable from_assay like ld_assay no-undo.

define variable from_grade like ld_grade no-undo.
define variable glcost like sct_cst_tot.
define variable iss_trnbr like tr_trnbr no-undo.
define variable rct_trnbr like tr_trnbr no-undo.
/*mage*/ define  shared TEMP-TABLE trhist1 
        fields tr1_domain  like tr_domain  
       fields tr1_site    like tr_site    
       fields tr1_trnbr   like tr_trnbr 
       fields tr1_part    like tr_part
       fields tr1_nbr     like tr_nbr     
       fields tr1_line    like tr_line    
       fields tr1_lot     like tr_lot     
       fields tr1_serial  like tr_serial  
       fields tr1_ref     like tr_ref     
       fields tr1_loc     like tr_loc     
       fields tr1_qty_loc like tr_qty_loc 
       fields tr1__dec01  like tr__dec01  
       fields tr1__log01  like tr__log01
       fields tr1_chg     like tr_qty_loc
       fields tr1_loc_to     like tr_loc 
       INDEX tr1_nbr IS PRIMARY tr1_nbr tr1_line tr1_trnbr
       INDEX tr1_part  tr1_part tr1_nbr tr1_line.
/*mage*/ define shared variable transok1 like mfc_logical .
{&REPKISA-P-TAG1}
transok1 = no.
laddet-loop:
for each trhist1 where trhist1.tr1_domain = global_domain no-lock:

   for each sr_wkfl exclusive-lock  
		where sr_wkfl.sr_domain = global_domain 
		 and sr_userid = mfguser
         and sr_lineid = string(tr1_line) + "::" + tr1_part
         and sr_site = tr1_site 
		 and sr_loc = tr1_loc
         and sr_lotser = tr1_serial  
		 and sr_ref = tr1_ref:

      {&REPKISA-P-TAG4}

      global_part = tr1_part.

      from_expire = ?.
      from_date = ?.

      from_assay = 0.

      from_grade = "".
      find ld_det no-lock  where ld_det.ld_domain = global_domain and  ld_part
      = tr1_part
         and ld_site = tr1_site
         and ld_loc = tr1_loc and ld_lot = tr1_serial
         and ld_ref = tr1_ref no-error.
      if available ld_det then do:
         assign
            from_status = ld_status
            from_expire = ld_expire
            from_date = ld_date

            from_assay = ld_assay

            from_grade = ld_grade.
      end.

      find ld_det exclusive-lock  where ld_det.ld_domain = global_domain and
         ld_site = tr1_site and
         ld_loc = tr1_loc_to and
         ld_part = tr1_part and
         ld_lot = sr_lotser and
         ld_ref = sr_ref
         no-error.
      if not available ld_det then do:
         create ld_det. ld_det.ld_domain = global_domain.
         assign
            ld_site = tr1_site
            ld_loc = tr1_loc_to
            ld_part = tr1_part
            ld_lot = sr_lotser
            ld_ref = sr_ref.
         if recid(ld_det) = -1 then .

         find loc_mstr no-lock  where loc_mstr.loc_domain = global_domain and
         loc_site = ld_site  and
            loc_loc = ld_loc no-error.
         if available loc_mstr then ld_status = loc_status.
         else do:
            find si_mstr no-lock  where si_mstr.si_domain = global_domain and
            si_site = ld_site no-error.
            if available si_mstr then ld_status = si_status.
         end.

      end. /* not available ld_det */

      if from_expire <> ? then ld_expire = from_expire.
      if from_date <> ? then ld_date = from_date.
      ld_assay = from_assay.
      ld_grade = from_grade.
      if not use-to-loc-status then ld_status = from_status.

      /* INPUT PARAMETER ORDER:                                        */
      /* TR_LOT, TR_SERIAL, LOTREF_FROM, LOTREF_TO QUANTITY, TR_NBR,   */
      /* TR_SO_JOB, TR_RMKS, PROJECT, TR_EFFDATE, SITE_FROM, LOC_FROM, */
      /* SITE_TO, LOC_TO, TEMPID                                       */
      /* SHIP_NBR, SHIP_DATE, INV_MOV,                                 */
      /* GLCOST                                                        */
      /* ASSAY, GRADE, EXPIRE                                          */
      /*CHANGE assay TO from_assay, CHANGE grade TO from_grade         */

      {&REPKISA-P-TAG2}
      {gprun.i ""icxfer.p""
         "("""",
           sr_lotser,
           sr_ref,
           sr_ref,
           sr_qty,
           tr1_lot,
           """",
           """",
           """",
           eff_date,
           tr1_site,
           tr1_loc,
           tr1_site,
           tr1_loc_to,
           no,
           """",
           ?,
           """",
           0,
           """",
           output glcost,
           output iss_trnbr,
           output rct_trnbr,
           input-output from_assay,
           input-output from_grade,
           input-output from_expire)"
         }
      {&REPKISA-P-TAG3}

   end. /* for each sr_wkfl */
transok1 = yes.
end. /* for each lad_det */

/* THIS SECTION WILL REDUCE QUANTITY ALLOCATED AND PICKED */
sr-loop:
for each sr_wkfl exclusive-lock
       where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
      and sr_qty > 0:
 /*  line = sr_rev.*/
   part = sr_user2.

   /* FIRST TRY TO APPLY USING EXACT LOTSER/REF MATCH */

   lad-loop1:
   for each lad_det exclusive-lock
          where lad_det.lad_domain = global_domain and (  lad_dataset =
          "rps_det"
         and lad_nbr = nbr
         and lad_line = sr_rev
         and lad_part = part
         and (lad_qty_all >= 0 or lad_qty_pick >= 0)
         and lad_site = sr_site
         and lad_loc = sr_loc
         and lad_lot = sr_lotser
         and lad_ref = sr_ref ) :

      /* SUBTRACT QTY ALLOCATED FROM INVENTORY MASTER */
      find in_mstr
          where in_mstr.in_domain = global_domain and  in_part = lad_part
         and in_site = lad_site
      exclusive-lock no-error.

      if available in_mstr then
      in_qty_all = in_qty_all -
      min(lad_qty_pick + lad_qty_all,sr_qty).

      find ld_det
          where ld_det.ld_domain = global_domain and  ld_part = lad_part
         and ld_site = lad_site
         and ld_loc = lad_loc
         and ld_lot = lad_lot
         and ld_ref = lad_ref
      exclusive-lock no-error.

      if available ld_det then
   do:
         ld_qty_all = ld_qty_all -
         min(lad_qty_pick + lad_qty_all,sr_qty).

         /* DELETE NON-PERMANENT ZERO QUANTITY LOCATION DETAIL RECORD*/

         run delete_ld_det
            (buffer ld_det).

      end. /* IF AVAILABLE ld_det */

      temp_qty = lad_qty_pick.
      if lad_qty_pick <> 0 then
      assign
         lad_qty_pick = lad_qty_pick - min(lad_qty_pick,sr_qty)
         /* REDUCE SR_QTY BY THE SAME AMOUNT THAT QTY PICKED  */
         /* WAS REDUCED                                       */
         sr_qty = sr_qty - (temp_qty - lad_qty_pick).
      temp_qty = lad_qty_all.
      if lad_qty_all <> 0 then
      assign
         lad_qty_all = lad_qty_all - min(lad_qty_all,sr_qty).
      /* REDUCE SR_QTY BY THE SAME AMOUNT REDUCED FOR       */
      /* QTY ALLOCATED                                      */
      sr_qty = sr_qty - (temp_qty - lad_qty_all).
      if lad_qty_all = 0 and lad_qty_pick = 0 then delete lad_det.
      if sr_qty = 0 then leave lad-loop1.

   end.  /*lad-loop1*/

   /* NOW TRY TO APPLY NOT USING EXACT LOTSER/REF MATCH */
   if sr_qty <> 0 then do:
      lad-loop2:
      for each lad_det exclusive-lock
             where lad_det.lad_domain = global_domain and (  lad_dataset =
             "rps_det"
            and lad_nbr = nbr
            and lad_line = sr_rev
            and lad_part = part
            and (lad_qty_all >= 0 or lad_qty_pick >= 0) ) :

         /* SUBTRACT QTY ALLOCATED FROM INVENTORY MASTER */
         find in_mstr
             where in_mstr.in_domain = global_domain and  in_part = lad_part
            and in_site = lad_site
         exclusive-lock no-error.

         if available in_mstr then
         in_qty_all = in_qty_all -

         min(lad_qty_pick + lad_qty_all,sr_qty).

         find ld_det
             where ld_det.ld_domain = global_domain and  ld_part = lad_part
            and ld_site = lad_site
            and ld_loc = lad_loc
            and ld_lot = lad_lot
            and ld_ref = lad_ref
         exclusive-lock no-error.

         if available ld_det then
      do:
            ld_qty_all = ld_qty_all -

            min(lad_qty_pick + lad_qty_all,sr_qty).

            /* DELETE NON-PERMANENT ZERO QUANTITY LOCATION DETAIL */
            /* RECORD                                             */

            run delete_ld_det
               (buffer ld_det).

         end. /* IF AVAILABLE ld_det */

         temp_qty = lad_qty_pick.
         if lad_qty_pick <> 0 then
         assign
            lad_qty_pick = lad_qty_pick - min(lad_qty_pick,sr_qty)
            /* REDUCE SR_QTY BY THE SAME AMOUNT THAT QTY PICKED  */
            /* WAS REDUCED                                       */
            sr_qty = sr_qty - (temp_qty - lad_qty_pick).
         temp_qty = lad_qty_all.
         if lad_qty_all <> 0 then
         assign
            lad_qty_all = lad_qty_all - min(lad_qty_all,sr_qty).
         /* REDUCE SR_QTY BY THE SAME AMOUNT REDUCED FOR       */
         /* QTY ALLOCATED                                      */
         sr_qty = sr_qty - (temp_qty - lad_qty_all).
         if lad_qty_all = 0 and lad_qty_pick = 0 then delete lad_det.
         if sr_qty = 0 then leave lad-loop2.

      end.  /*lad-loop2*/
   end. /* if sr_qty <> 0 */

   delete sr_wkfl.
end. /* sr-loop */

/* CLEAN UP ANY LAD_DET RECORDS WHERE LAD_QTY_ALL AND */
/* LAD_QTY_PICK = 0.                                  */
for each lad_det exclusive-lock
       where lad_det.lad_domain = global_domain and  lad_dataset = "rps_det"
      and lad_nbr = nbr
      and lad_qty_all = 0
      and lad_qty_pick = 0:
   delete lad_det.
end.


{&REPKISA-P-TAG5}

/* PROCEDURE TO DELETE NON-PERMANENT ZERO QUANTITY */
/* LOCATION DETAILS RECORD                         */

PROCEDURE delete_ld_det:
   define parameter buffer lddet for ld_det.

   for first   loc_mstr
      fields( loc_domain loc_loc loc_perm loc_site loc_status)
       where loc_mstr.loc_domain = global_domain and    loc_site = ld_site and
      loc_loc  = ld_loc
   no-lock:
   end. /* FOR FIRST loc_mstr */

   if available loc_mstr and not loc_perm then
   do:
      if ld_qty_oh  = 0 and
         ld_qty_all = 0 and
         ld_qty_frz = 0 and
         not can-find(first tag_mstr  where tag_mstr.tag_domain = global_domain
         and  tag_site   = ld_site   and
         tag_loc    = ld_loc    and
         tag_part   = ld_part   and
         tag_serial = ld_lot    and
         tag_ref    = ld_ref)   then
   do:
         delete ld_det.
      end. /* IF ld_qty_oh = 0 AND ... */
   end. /* IF AVAILABLE loc_mstr */

END PROCEDURE. /* PROCEDURE delete_ld_det */
