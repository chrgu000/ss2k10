/* icshprt.p - Shipper Print "on the fly"                                    */
/* Copyright 1986-2001 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/*V8:ConvertMode=Report                                                      */
/*K1JN*/ /*V8:RunMode=Character,Windows                                      */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke       */
/* REVISION: 8.6      LAST MODIFIED: 04/09/97   BY: *K08N* Steve Goeke       */
/* REVISION: 8.6      LAST MODIFIED: 06/20/97   BY: *H19N* Aruna Patil       */


/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.6E     LAST MODIFIED: 05/15/98   BY: *K1JN* Niranjan R.      */
/* REVISION: 8.6E     LAST MODIFIED: 07/20/98   BY: *H1MC* Mansih K.        */
/* REVISION: 8.6E     LAST MODIFIED: 08/05/98   BY: *J2VP* Mansih K.        */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan        */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B8* Hemanth Ebenezer  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.0      LAST MODIFIED: 06/22/99   BY: *K21B* Reetu Kapoor      */
/* REVISION: 9.1      LAST MODIFIED: 12/28/99   BY: *N05X* Surekha Joshi     */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00 BY: *N0KS* myb                 */
/* REVISION: 9.1      LAST MODIFIED: 09/25/00 BY: *N0W6* BalbeerS Rajput  */
/* REVISION: 9.1      LAST MODIFIED: 09/03/01 BY: *M1JZ* Nikita Joshi     */

         {mfdeclre.i}
/*N0W6*/ {cxcustom.i "ICSHPRT.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE icshprt_p_1 "Assign Shipper Number"
/* MaxLen: Comment: */

&SCOPED-DEFINE icshprt_p_2 "Print Features and Options"
/* MaxLen: Comment: */

&SCOPED-DEFINE icshprt_p_3 " Print Shipper "
/* MaxLen: Comment: */

&SCOPED-DEFINE icshprt_p_4 "Print Sales Order Detail"
/* MaxLen: Comment: */

&SCOPED-DEFINE icshprt_p_5 "Include Shipper Comments"
/* MaxLen: Comment: */

&SCOPED-DEFINE icshprt_p_6 "Include Packing List Comments"
/* MaxLen: Comment: */

/*J2VP*/
&SCOPED-DEFINE icshprt_p_7 "Display Quantity In SO UM"
/* MaxLen: Comment: */

/*N05X*/
&SCOPED-DEFINE icshprt_p_8 "Company Address"
/* MaxLen:23 Comment: */

/*M1JZ*/ &SCOPED-DEFINE icshprt_p_9 "Print Lot/Serial Numbers"
/*M1JZ*/ /* MaxLen:32 Comment: */

/* ********** End Translatable Strings Definitions ********* */

         /* INPUT PARAMETERS */
         define input parameter i_recid as recid no-undo.
/* 131023.1 */ {xxrcshwb.i}
         /* LOCAL VARIABLES */
         define variable v_ship_cmmts like mfc_logical initial true
                         label {&icshprt_p_5}      no-undo.
         define variable v_pack_cmmts like mfc_logical initial true
                         label {&icshprt_p_6} no-undo.
         define variable v_features   like mfc_logical initial false
                         label {&icshprt_p_2}    no-undo.
         define variable v_assign     like mfc_logical initial false
                         label {&icshprt_p_1}         no-undo.
/*H1MC** define variable v_assigned   as logical               no-undo. */
/*H1MC*/ define variable v_assigned   like mfc_logical         no-undo.
/*H1MC** define variable v_so_shipper as logical               no-undo. */
/*H1MC*/ define variable v_so_shipper like mfc_logical         no-undo.
         define variable v_old_print  as character             no-undo.

/*H1MC*  **BEGIN DELETE**
 *       define variable v_ok         as logical               no-undo.
 *       define variable v_abort      as logical               no-undo.
 *       define variable v_err        as logical               no-undo.
 *H1MC*  **END DELETE** */

/*H1MC*/ define variable v_ok    like mfc_logical  no-undo.
/*H1MC*/ define variable v_abort like mfc_logical  no-undo.
/*H1MC*/ define variable v_err   like mfc_logical  no-undo.

         define variable v_errnum     as integer               no-undo.
/*H1MC** /*H19N*/ define variable v_print_sodet as logical initial no */
/*H1MC*/ define variable v_print_sodet like mfc_logical initial no
/*H19N*/             label {&icshprt_p_4} no-undo.
/*J2VP*/ define variable l_so_um like mfc_logical
/*J2VP*/    label {&icshprt_p_7} no-undo.
/*N05X*/ define variable comp_addr like ad_addr label {&icshprt_p_8} no-undo.

/*K1JN*/ define variable l_abs_id           like abs_id        no-undo.
/*M1JZ*/ define variable l_print_lotserials like mfc_logical   initial no
/*M1JZ*/    label {&icshprt_p_9}                               no-undo.

         /* FRAMES */
         form
             v_ship_cmmts       colon 34
             v_pack_cmmts       colon 34
             v_features         colon 34
/*H19N*/     v_print_sodet      colon 34
             v_assign           colon 34
/*J2VP*/     l_so_um            colon 34
/*N05X*/     comp_addr          colon 34
/*M1JZ*/     l_print_lotserials colon 34
             skip
         with frame a side-labels width 80 attr-space
            title color normal (getFrameTitle("PRINT_SHIPPER",20)).

            /* SET EXTERNAL LABELS */
            setFrameLabels(frame a:handle).

/*N05X*/ for first soc_ctrl
/*N05X*/    fields (soc_company)
/*N05X*/    no-lock:
/*N05X*/ end. /* FOR FIRST soc_ctrl */

         /* MAIN PROCEDURE BODY */

         main_blk:
         repeat with frame a:
            /* SET DEFAULT COMPANY ADDRESS */

/*N05X*/    if comp_addr = "" and available soc_ctrl then
/*N05X*/       comp_addr = soc_company.

            /* Read the shipper record */
            find abs_mstr no-lock where recid(abs_mstr) eq i_recid no-error.
            if not available abs_mstr or
               abs_format eq "" or
               abs_canceled then return.

            /* Check whether shipper is for sales orders */
            v_so_shipper =
/*K08N*        abs_inv_mov eq "" or  *K08N*/
/*K08N*/       (abs_inv_mov eq "" and
/*K08N*/        (abs_type eq "s" or abs_type eq "p")) or
/*N0W6*/       {&ICSHPRT-P-TAG1}
               can-find
                  (im_mstr where
                     im_inv_mov eq abs_inv_mov and
                     im_tr_type eq "ISS-SO").
/*N0W6*/       {&ICSHPRT-P-TAG2}

            /* Hide inapplicable fields if not SO shipper */
            if not v_so_shipper then
               assign
                  v_pack_cmmts:HIDDEN       = true
                  v_pack_cmmts              = false
                  v_features:HIDDEN         = true
                  v_features                = false
/*H19N*/          v_print_sodet:HIDDEN      = true
/*H19N*/          v_print_sodet             = false
                  v_assign:HIDDEN           = true
/*J2VP**          v_assign                  = false. */
/*J2VP*/          v_assign                  = false
/*J2VP*/          l_so_um:HIDDEN            = true
/*N05X** /*J2VP*/ l_so_um                   = false. */
/*N05X*/          l_so_um                   = false
/*N05X*/          comp_addr:HIDDEN          = true
/*M1JZ*/          l_print_lotserials:HIDDEN = true
/*M1JZ*/          l_print_lotserials        = false
/*N05X*/          .

            /* Save print flag */
            v_old_print = substring(abs_status,1,1).

            /* Get print criteria */
            update
               v_ship_cmmts
               v_pack_cmmts       when (v_so_shipper)
               v_features         when (v_so_shipper)
/*H19N*/       v_print_sodet      when (v_so_shipper)
/*J2VP**       v_assign           when (v_so_shipper and abs_id begins "p"). */
/*J2VP*/       v_assign           when (v_so_shipper and abs_id begins "p")
/*N05X** /*J2VP*/ l_so_um         when (v_so_shipper). */
/*N05X*/       l_so_um            when (v_so_shipper)
/*N05X*/       comp_addr          when (v_so_shipper)
/*M1JZ*/       l_print_lotserials when (v_so_shipper)
/*N05X*/       .

/*N05X*/    /* VALIDATE THE COMPANY ADDRESS ONLY IF IT IS NOT BLANK */

/*N05X*/    if comp_addr <> "" then do:

/*N05X*/       for first ad_mstr
/*N05X*/          fields (ad_addr)
/*N05X*/          where ad_addr = comp_addr no-lock:
/*N05X*/       end. /* FOR FIRST ad_mstr */

/*N05X*/       if not available ad_mstr then do:
/*N05X*/          /* INVALID COMPANY ADDRESS */
/*N05X*/          {mfmsg.i 3516 3}
/*N05X*/          next-prompt comp_addr with frame a.
/*N05X*/          undo main_blk, retry main_blk.
/*N05X*/       end. /* IF NOT AVAILABLE AD_MSTR */

/*N05X*/       for first ls_mstr
/*N05X*/          fields (ls_addr ls_type)
/*N05X*/          where ls_addr = ad_addr and ls_type = "company" no-lock:
/*N05X*/       end. /* FOR FIRST ls_mstr */

/*N05X*/       if not available ls_mstr then do:
/*N05X*/          /* INVALID COMPANY ADDRESS */
/*N05X*/          {mfmsg.i 3516 3}
/*N05X*/          next-prompt comp_addr with frame a.
/*N05X*/          undo main_blk, retry main_blk.
/*N05X*/       end. /* IF NOT AVAILABLE LS_MSTR */

/*N05X*/    end. /* IF comp_addr <> "" */

            /* Set up batch parameters */
            bcdparm = "".
            {mfquoter.i v_ship_cmmts}
            if v_so_shipper then do:
               {mfquoter.i v_pack_cmmts}
               {mfquoter.i v_features}
/*H19N*/       {mfquoter.i v_print_sodet}
               {mfquoter.i v_assign}
/*J2VP*/       {mfquoter.i l_so_um}
/*N05X*/       {mfquoter.i comp_addr}
/*M1JZ*/       {mfquoter.i l_print_lotserials}
            end.  /* if v_so_shipper */

            /* Assign shipper number */
            if v_assign and not v_assigned then do:
               {gprun.i
                  ""icshcnv.p""
                  "(i_recid,
                    false,
                    """",
                    output v_abort,
                    output v_err,
                    output v_errnum)" }
               if v_err then do:
                  {mfmsg.i v_errnum 3 }
                  undo main_blk, retry main_blk.
               end.  /* if v_err */

               if v_abort then undo main_blk, retry main_blk.

               v_assigned = true.

/*K21B** BEGIN DELETE **
 * /*K1JN*/       /* AFTER THE PRE-SHIPPER IS CONVERTED TO SHIPPER UPDATING
 */
 * /*K1JN*/       /* SHIPMENT REQUIREMENT DETAIL                             */
 *
 * /*K1JN*/       for each absr_det
 * /*K1JN*/          where absr_shipfrom = abs_shipfrom
 * /*K1JN*/          and absr_ship_id    = abs_preship_id exclusive-lock:
 *
 * /*K1JN*/          assign
 * /*K1JN*/            absr_id = right-trim(substring(absr_id,1,1)) + abs_id +
 * /*K1JN*/                      right-trim(substring
 * /*K1JN*/                      (absr_id,length(abs_preship_id) + 2))
 * /*K1JN*/            absr_ship_id = abs_id.
 * /*K1JN*/       end. /* FOR EACH ABSR_DET */
 *K21B** END DELETE **/

            end.  /* if v_assign */

            /* Select printer */
            {mfselprt.i "printer" 80 }

            /* Set print flag */
            do transaction:

               /* Refind and lock record */
               find abs_mstr exclusive-lock where
                  recid(abs_mstr) eq i_recid no-error.
               if not available abs_mstr then return.
               /* Mark as printed */
               vabsid = substring(abs_mstr.abs_id,2).
               vshiptp = substring(abs_mstr.abs_id,1,1).
               vshipfrom = abs_mstr.abs_shipfrom.
               substring(abs_mstr.abs_status,1,1) = "y".
               release abs_mstr.

            end.  /* transaction */

            /* Print shipper using shipper form services */
/*H19N**            {gprun.i
 *              ""sofspr.p""
 *              "(i_recid, v_ship_cmmts, v_pack_cmmts, v_features)" }
 *H19N**/
/*H19N*/    /* ADDED THE PARAMETER v_print_sodet  */
/*J2VP*/    /* ADDED THE PARAMETER l_so_um         */
/*N05X*/    /* ADDED SEVENTH INPUT PARAMETER comp_addr */
/*M1JZ*/    /* ADDED EIGHTH INPUT PARAMETER l_print_lotserials */
/*H19N*/    {gprun.i
               ""sofspr.p""
               "(i_recid, v_ship_cmmts, v_pack_cmmts, v_features,
                 v_print_sodet, l_so_um, comp_addr, l_print_lotserials)" }

            {mfrpchk.i}

            {mfreset.i}

            /* Prompt whether documents printed correctly */
            v_ok = true.
            {mfmsg01.i 7158 1 v_ok }
            /* Have all documents printed correctly? */

            if not v_ok then do:

               do transaction:

                  /* Refind and lock record */
                  find abs_mstr exclusive-lock where
                     recid(abs_mstr) eq i_recid no-error.
                  if not available abs_mstr then return.

                  /* Reset print flag */
                  substring(abs_status,1,1) = v_old_print.

/*K1JN*/          l_abs_id = abs_id.
                  release abs_mstr.

               end.  /* transaction */

               /* Restore preshipper number */
               if v_assigned then do:
                  /* Prompt whether to unassign shipper number */
                  v_ok = false.
                  {mfmsg01.i 5809 1 v_ok }
                  /* Undo shipper number assignment? */
                  if v_ok then do:
                     {gprun.i ""icshunc.p"" "(i_recid)" }
                     v_assigned = false.

/*K21B** BEGIN DELETE **
 * /*K1JN*/         /* AFTER REVERTING BACK SHIPPER TO PRE-SHIPPER RESTORING  */
 * /*K1JN*/         /* BACK SHIPMENT REQUIREMENT DETAIL                       */
 *
 * /*K1JN*/             find  abs_mstr where recid(abs_mstr) = i_recid
 * /*K1JN*/             no-lock no-error.
 *
 * /*K1JN*/             for each absr_det
 * /*K1JN*/                where absr_shipfrom = abs_shipfrom
 * /*K1JN*/                and absr_ship_id    = l_abs_id exclusive-lock:
 *
 * /*K1JN*/                assign
 * /*K1JN*/                   absr_id = right-trim(substring(absr_id,1,1))
 * /*K1JN*/                             + abs_id + right-trim(
 * /*K1JN*/                             substring(absr_id,length(l_abs_id) + 2))
 * /*K1JN*/                   absr_ship_id = abs_id.
 *
 * /*K1JN*/             end. /* FOR EACH ABSR_DET */
 *K21B** END DELETE **/
                  end.  /* if v_ok */

               end.  /* if v_assigned */

               next main_blk.

            end.  /* if not v_ok (transaction) */
            if v_ok then do:
               output to value(vabsid + ".bpi").
               put unformat '"' vshipfrom '" "' vshiptp '" "' vabsid '"' skip.
               put unformat '-' skip.
               put unformat 'Y' skip. 
               output close.
               batchrun = yes.
               input from value(vabsid + ".bpi").
               output to value(vabsid + ".bpo").
               {gprun.i ""xxrcsois.p""}
               output close.
               input close.
               batchrun = no.
               os-delete value(vabsid + ".bpi").
               os-delete value(vabsid + ".bpo").
               {gprun.i ""xxrcsorp.p""}
            end.
            leave main_blk.

         end.  /* main_blk */

         hide frame a.

         /* END OF MAIN PROCEDURE BODY */
